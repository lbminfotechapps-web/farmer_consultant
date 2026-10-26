import 'package:farmer_consultant/core/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/important_links_bloc.dart';
import '../bloc/important_links_event.dart';
import '../bloc/important_links_state.dart';

import '../../domain/entities/important_link_entity.dart';

class ImportantLinksPage extends StatefulWidget {
  const ImportantLinksPage({super.key});

  @override
  State<ImportantLinksPage> createState() => _ImportantLinksPageState();
}

class _ImportantLinksPageState extends State<ImportantLinksPage> {
  static const Color primaryColor = Color(0xFF1B7044);

  @override
  void initState() {
    super.initState();
    context.read<ImportantLinksBloc>().add(const FetchImportantLinks());
  }

  Future<void> _openLink(BuildContext context, String link) async {
    final String cleanLink = link.trim();

    final Uri? uri = Uri.tryParse(
      cleanLink.startsWith('http://') || cleanLink.startsWith('https://')
          ? cleanLink
          : 'https://$cleanLink',
    );

    if (uri == null || uri.host.isEmpty) {
      _showMessage(context, 'Invalid link');
      return;
    }

    try {
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success && context.mounted) {
        _showMessage(context, 'Unable to open link');
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, 'Unable to open link');
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: CommonDashboardAppBar(
        title: 'Important Links',
        showProfile: false,
        showNotification: false,
        showThemeButton: true,
        showFilterButton: false,

        onBackTap: () => Navigator.of(context).pop(),
      ),
      body: BlocBuilder<ImportantLinksBloc, ImportantLinksState>(
        builder: (context, state) {
          if (state is ImportantLinksLoading) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (state is ImportantLinksError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 44,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ImportantLinksBloc>().add(
                          const FetchImportantLinks(),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ImportantLinksLoaded) {
            if (state.links.isEmpty) {
              return const Center(child: Text('No important links found'));
            }

            return RefreshIndicator(
              color: primaryColor,
              onRefresh: () async {
                final bloc = context.read<ImportantLinksBloc>();
                bloc.add(const FetchImportantLinks());

                await bloc.stream.firstWhere(
                  (state) =>
                      state is ImportantLinksLoaded ||
                      state is ImportantLinksError,
                );
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: state.links.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _buildLinkCard(context, state.links[index]);
                },
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        },
      ),
    );
  }

  Widget _buildLinkCard(BuildContext context, ImportantLinkEntity item) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),

      child: InkWell(
        onTap: () => _openLink(context, item.link),
        borderRadius: BorderRadius.circular(14),

        child: Container(
          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8EEE9)),
          ),

          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F4EA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.link_rounded,
                  color: primaryColor,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF183D2B),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      item.link,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: primaryColor),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.open_in_new_rounded,
                color: primaryColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
