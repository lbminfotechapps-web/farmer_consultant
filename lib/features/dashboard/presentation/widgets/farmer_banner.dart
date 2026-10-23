import 'package:farmer_consultant/core/theme/app_theme_context.dart';
import 'package:farmer_consultant/core/theme/typography/app_typography_extension.dart';
import 'package:flutter/material.dart';

class FarmingBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const FarmingBanner({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 166,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          gradient: context.appGradient,
        ),
        child: Stack(
          children: [
            // Optional background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/farmerfield.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return const SizedBox.shrink();
                },
              ),
            ),

            // Text readability gradient
            // Positioned.fill(
            //   child: DecoratedBox(
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         colors: [
            //           context.cardBackgroundColor.withValues(alpha: 0.95),
            //           context.cardBackgroundColor.withValues(alpha: 0.90),
            //           Colors.transparent,
            //         ],
            //         stops: const [0.0, 0.43, 0.80],
            //       ),
            //     ),
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('AI Powered', style: context.appTextStyles.cardTitle.copyWith(  color: context.backgroundColor,),),
                  const SizedBox(height: 4),
                  Text(
                    'Smart Farming',
                    style: context.appTextStyles.headingLarge.copyWith(
                      color: context.backgroundColor,
                    ),
                  ),
                  const SizedBox(height: 11),
                  Text(
                    'Better Decisions,\nBetter Yields.',
                    style: context.appTextStyles.cardDescription.copyWith(  color: context.backgroundColor,),
                  ),
                ],
              ),
            ),

            // Fallback illustration when image is absent
            Positioned(
              right: 18,
              bottom: 13,
              child: IgnorePointer(
                child: Icon(
                  Icons.agriculture_rounded,
                  size: 72,
                  color: context.appColors.primary.withValues(alpha: 0.14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
