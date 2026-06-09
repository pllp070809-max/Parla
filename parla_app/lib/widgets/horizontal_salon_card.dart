import 'package:flutter/material.dart';
import '../models/salon.dart';
import '../theme.dart';
import '../app_sizes.dart';
import '../utils/salon_images.dart';

class HorizontalSalonCard extends StatefulWidget {
  final Salon salon;
  final VoidCallback onTap;

  const HorizontalSalonCard({
    super.key,
    required this.salon,
    required this.onTap,
  });

  @override
  State<HorizontalSalonCard> createState() => _HorizontalSalonCardState();
}

class _HorizontalSalonCardState extends State<HorizontalSalonCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.elementSpacing),
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
              // Image (Left Side)
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(AppSizes.radiusLg),
                ),
                child: SizedBox(
                  width: 112,
                  child: Image.asset(
                    salonMainImage(widget.salon),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: kSurfaceBg,
                      child: const Icon(Icons.storefront_rounded, color: kTextTertiary),
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
                              widget.salon.name,
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
                              setState(() {
                                _isFavorite = !_isFavorite;
                              });
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                              child: AnimatedScale(
                                scale: _isFavorite ? 1.15 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOut,
                                child: Icon(
                                  _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: _isFavorite ? kPrimary : kTextTertiary.withValues(alpha: 0.6),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Address
                      Text(
                        widget.salon.address ?? '',
                        style: tt.bodyMedium?.copyWith(
                          color: kTextSecondary,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: kStar, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            widget.salon.rating > 0 ? widget.salon.rating.toStringAsFixed(1) : 'Täze',
                            style: tt.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (widget.salon.reviewsCount > 0)
                            Text(
                              '${widget.salon.reviewsCount} syn',
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
    );
  }
}
