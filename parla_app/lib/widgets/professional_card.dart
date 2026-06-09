import 'package:flutter/material.dart';
import '../models/staff.dart';
import '../theme.dart';
import '../app_spacing.dart';
import '../app_sizes.dart';
import '../utils/salon_images.dart';

class ProfessionalCard extends StatelessWidget {
  final Staff staff;
  final VoidCallback onTap;

  const ProfessionalCard({
    super.key,
    required this.staff,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.elementSpacing),
      child: Semantics(
        button: true,
        label: '${staff.name}, ${staff.role}',
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Container(
            height: 112,
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: kBorderMedium, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(imageForKey(staff.imageKey)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff.name,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${staff.distanceKm} km • ${staff.salonAddress}',
                        style: tt.bodyMedium?.copyWith(
                          color: kTextSecondary,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        staff.role,
                        style: tt.bodyMedium?.copyWith(
                          color: kTextSecondary,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: kStar, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            staff.rating.toStringAsFixed(1),
                            style: tt.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${staff.reviewsCount} syn',
                            style: tt.bodyMedium?.copyWith(
                              color: kTextSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
