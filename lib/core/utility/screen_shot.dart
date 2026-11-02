import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:farmer_consultant/core/secure_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

class NextScreen extends StatefulWidget {
  final Widget? child;

  const NextScreen({super.key, this.child});

  static Widget toolbarButton(BuildContext context) {
    final state = context.findAncestorStateOfType<_NextScreenState>();
    if (state == null) return const SizedBox.shrink();
    return IconButton(
      tooltip: 'Take Screenshot',
      onPressed: state.isCapturing
          ? null
          : () => state.captureScreenshot(context),
      icon: const Icon(Icons.screenshot_rounded),
    );
  }

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  final GlobalKey _screenshotKey = GlobalKey();

  bool isCapturing = false;
  static const String sendScreenShotApi =
      'https://agroaicrm.com/solufine_agritech/mobileapi/Mobile_app_for_businessplus_kotlin_new/add_screenshot';

  // CAPTURE SCREENSHOT
  Future<void> captureScreenshot([BuildContext? sourceContext]) async {
    final captureContext = sourceContext ?? context;
    if (isCapturing) return;

    setState(() {
      isCapturing = true;
    });

    try {
      // Wait until the loading state is rendered.
      await WidgetsBinding.instance.endOfFrame;

      final boundary =
          _screenshotKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('Screenshot boundary not found');
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);

      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      image.dispose();

      if (byteData == null) {
        throw Exception('Unable to capture screenshot');
      }

      final Uint8List screenshotBytes = byteData.buffer.asUint8List();

      if (!mounted || !captureContext.mounted) return;

      setState(() {
        isCapturing = false;
      });

      showScreenshotDialog(screenshotBytes, captureContext);
    } catch (e) {
      if (!mounted || !captureContext.mounted) return;

      setState(() {
        isCapturing = false;
      });

      ScaffoldMessenger.of(
        captureContext,
      ).showSnackBar(SnackBar(content: Text('Screenshot failed: $e')));
    }
  }

  // SHOW SCREENSHOT POPUP

  void showScreenshotDialog(
    Uint8List screenshotBytes,
    BuildContext sourceContext,
  ) {
    final TextEditingController remarkController = TextEditingController();

    bool isLoading = false;

    showDialog<void>(
      context: sourceContext,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // COMMON API CALL FOR SUBMIT AND SHARE
            Future<void> handleScreenshot({
              required bool shareAfterUpload,
            }) async {
              if (isLoading) return;

              final String remark = remarkController.text.trim();

              // VALIDATE REMARK
              if (remark.isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Please enter remark')),
                );
                return;
              }

              /*if (widget.userId.trim().isEmpty) {
                ScaffoldMessenger.of(dialogContext)
                    .showSnackBar(
                  const SnackBar(
                    content: Text('User ID is missing'),
                  ),
                );
                return;
              }*/

              setDialogState(() {
                isLoading = true;
              });

              try {
                // STEP 1: CALL MULTIPART API
                final bool isSuccess = await uploadScreenshot(
                  remark: remark,
                  userId: await SecureStorage.instance.getFarmerId(),
                  screenshotBytes: screenshotBytes,
                );

                if (!dialogContext.mounted) return;

                // STEP 2: CHECK API RESPONSE
                if (!isSuccess) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Screenshot upload failed. Please try again.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // STEP 3: SUBMIT ONLY
                if (!shareAfterUpload) {
                  Navigator.pop(dialogContext);

                  if (sourceContext.mounted) {
                    ScaffoldMessenger.of(sourceContext).showSnackBar(
                      const SnackBar(
                        content: Text('Screenshot uploaded successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  return;
                }

                // STEP 4: SHARE AFTER API SUCCESS
                debugPrint('API SUCCESS - OPENING SHARE SHEET');

                final String fileName =
                    'screenshot_${DateTime.now().millisecondsSinceEpoch}.png';

                await SharePlus.instance.share(
                  ShareParams(
                    text: remark,
                    files: [
                      XFile.fromData(screenshotBytes, mimeType: 'image/png'),
                    ],
                    fileNameOverrides: [fileName],
                  ),
                );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              } catch (e) {
                debugPrint('SCREENSHOT UPLOAD / SHARE ERROR: $e');

                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text('Something went wrong: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } finally {
                if (dialogContext.mounted) {
                  setDialogState(() {
                    isLoading = false;
                  });
                }
              }
            }

            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: SizedBox(
                  height: MediaQuery.sizeOf(dialogContext).height * 0.80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      const Center(
                        child: Text(
                          'Screenshot Preview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // SCREENSHOT PREVIEW
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              screenshotBytes,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // REMARK LABEL
                      const Text(
                        'Remark',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // REMARK TEXT FIELD
                      TextField(
                        controller: remarkController,
                        enabled: !isLoading,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 2,
                        maxLines: 3,
                        maxLength: 500,
                        decoration: InputDecoration(
                          hintText: 'Enter your remark here...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.edit_note_rounded,
                            color: Colors.blue,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // SUBMIT AND SHARE BUTTONS
                      Row(
                        children: [
                          // SUBMIT BUTTON
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => handleScreenshot(
                                      shareAfterUpload: false,
                                    ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Submit'),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // SHARE BUTTON
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () => handleScreenshot(
                                      shareAfterUpload: true,
                                    ),
                              icon: const Icon(Icons.share_rounded, size: 18),
                              label: const Text('Share'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> uploadScreenshot({
    required String remark,
    required String userId,
    required Uint8List screenshotBytes,
  }) async {
    const String apiUrl =
        'https://agroaicrm.com/solufine_agritech/mobileapi/'
        'Mobile_app_for_businessplus_kotlin_new/add_screenshot';

    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
      ),
    );

    try {
      if (userId.trim().isEmpty) {
        debugPrint('User ID is missing');
        return false;
      }

      final String fileName =
          'screenshot_${DateTime.now().millisecondsSinceEpoch}.png';

      // CREATE MULTIPART REQUEST
      final FormData formData = FormData.fromMap({
        'remark': remark,
        'userId': userId,
        'screenshot_photo': MultipartFile.fromBytes(
          screenshotBytes,
          filename: fileName,
          contentType: DioMediaType('image', 'png'),
        ),
      });

      debugPrint('======================================');
      debugPrint('ADD SCREENSHOT API PARAMETERS');
      debugPrint('remark: $remark');
      debugPrint('userId: $userId');
      debugPrint('screenshot_photo: $fileName');
      debugPrint('Screenshot size: ${screenshotBytes.length} bytes');
      debugPrint('======================================');

      // CALL API
      final Response response = await dio.post(
        apiUrl,
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
          responseType: ResponseType.json,
        ),
      );

      debugPrint('======================================');
      debugPrint('ADD SCREENSHOT API RESPONSE');
      debugPrint('HTTP STATUS: ${response.statusCode}');
      debugPrint('RESPONSE: ${response.data}');
      debugPrint('RESPONSE TYPE: ${response.data.runtimeType}');
      debugPrint('======================================');

      // HANDLE STRING AND MAP RESPONSE
      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map) {
        final dynamic status = data['status'];
        final String message = data['message']?.toString() ?? '';

        debugPrint('API STATUS: $status');
        debugPrint('API MESSAGE: $message');

        if (status == true ||
            status == 1 ||
            status.toString().toLowerCase() == 'true') {
          debugPrint('SCREENSHOT UPLOADED SUCCESSFULLY');
          return true;
        }

        debugPrint('SCREENSHOT UPLOAD FAILED: $message');
        return false;
      }

      debugPrint('Unexpected API response format: ${data.runtimeType}');

      return false;
    } on DioException catch (e) {
      debugPrint('DIO ERROR: ${e.message}');
      debugPrint('STATUS CODE: ${e.response?.statusCode}');
      debugPrint('ERROR RESPONSE: ${e.response?.data}');
      return false;
    } catch (e) {
      debugPrint('SCREENSHOT UPLOAD ERROR: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _screenshotKey,
      child:
          widget.child ??
          Scaffold(
            backgroundColor: const Color(0xFFF5F7FB),

            appBar: AppBar(
              title: const Text('Next Screen'),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  tooltip: 'Take Screenshot',
                  onPressed: isCapturing ? null : captureScreenshot,
                  icon: const Icon(Icons.camera_alt_outlined, size: 24),
                ),
                const SizedBox(width: 8),
              ],
            ),

            body: const Center(
              child: Text(
                'Welcome to Next Screen',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
    );
  }
}
