import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/staff.dart';
import '../theme.dart';
import '../app_sizes.dart';
import '../utils/salon_images.dart';
import '../providers/providers.dart';

class ProfessionalCard extends ConsumerStatefulWidget {
  final Staff staff;
  final VoidCallback onTap;

  const ProfessionalCard({
    super.key,
    required this.staff,
    required this.onTap,
  });

  @override
  ConsumerState<ProfessionalCard> createState() => _ProfessionalCardState();
}

class _ProfessionalCardState extends ConsumerState<ProfessionalCard> {
  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final isFavourite = ref.watch(favouriteStaffProvider).contains(widget.staff.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.elementSpacing),
      child: Semantics(
        button: true,
        label: '${widget.staff.name}, ${widget.staff.role}, ${widget.staff.salonName}',
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Container(
            height: 112,
            decoration: BoxDecoration(
              color: kCardBg,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: kBorderMedium, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Avatar (Left Side)
                SizedBox(
                  width: 112,
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(imageForKey(widget.staff.imageKey)),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(color: kBorderMedium.withValues(alpha: 0.8), width: 1),
                      ),
                    ),
                  ),
                ),
                
                // Content (Right Side)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title and Heart Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.staff.name,
                                style: tt.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                ref.read(favouriteStaffProvider.notifier).toggle(widget.staff.id);
                                setState(() {
                                  _isAnimating = true;
                                });
                                Future.delayed(const Duration(milliseconds: 200), () {
                                  if (mounted) {
                                    setState(() {
                                      _isAnimating = false;
                                    });
                                  }
                                });
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                                child: AnimatedScale(
                                  scale: _isAnimating && isFavourite ? 1.15 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                  child: Icon(
                                    isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    color: isFavourite ? kPrimary : kTextTertiary.withValues(alpha: 0.6),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Role and Salon Name (Ugry we Salon)
                        Text(
                          '${widget.staff.role} • ${widget.staff.salonName}',
                          style: tt.bodyMedium?.copyWith(
                            color: kTextSecondary,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        // Rating and Distance (Reýting we Aralyk)
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: kStar, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              widget.staff.rating.toStringAsFixed(1),
                              style: tt.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${widget.staff.reviewsCount} syn',
                              style: tt.bodyMedium?.copyWith(
                                color: kTextSecondary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '•',
                              style: tt.bodyMedium?.copyWith(
                                color: kTextSecondary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${widget.staff.distanceKm.toStringAsFixed(1)} km',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
