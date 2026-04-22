import 'package:flutter/material.dart';

import '../app_radius.dart';
import '../app_spacing.dart';
import '../models/salon.dart';
import '../theme.dart';

enum ServiceCatalogActionMode {
  book,
  toggle,
}

class ServiceCatalogSection extends StatefulWidget {
  final List<Service> services;
  final ServiceCatalogActionMode actionMode;
  final ValueChanged<Service> onAction;
  final Set<int> selectedServiceIds;
  final bool showTitle;
  final bool showViewAllButton;
  final String title;
  final int initialVisibleCount;
  final EdgeInsetsGeometry padding;

  const ServiceCatalogSection({
    super.key,
    required this.services,
    required this.actionMode,
    required this.onAction,
    this.selectedServiceIds = const <int>{},
    this.showTitle = true,
    this.showViewAllButton = false,
    this.title = 'Hyzmatlar',
    this.initialVisibleCount = 5,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<ServiceCatalogSection> createState() => _ServiceCatalogSectionState();
}

class _ServiceCatalogSectionState extends State<ServiceCatalogSection> {
  static const Duration _expandAnimationDuration = Duration(milliseconds: 320);

  bool _showAll = false;
  String _selectedCategoryKey = 'all';

  @override
  void didUpdateWidget(covariant ServiceCatalogSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final keys = serviceCategoryKeysForList(widget.services);
    if (_selectedCategoryKey != 'all' && !keys.contains(_selectedCategoryKey)) {
      _selectedCategoryKey = 'all';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final categoryKeysRow = serviceCategoryKeysForList(widget.services);
    final filteredServices = _selectedCategoryKey == 'all'
        ? widget.services
        : widget.services
            .where((service) => service.categoryKey == _selectedCategoryKey)
            .toList();
    final selectedCategoryLabel = serviceCategoryLabel(_selectedCategoryKey);
    final baseServices = widget.showViewAllButton
        ? filteredServices.take(widget.initialVisibleCount).toList()
        : filteredServices;
    final extraServices = widget.showViewAllButton
        ? filteredServices.skip(widget.initialVisibleCount).toList()
        : const <Service>[];
    final showViewAll = widget.showViewAllButton &&
        filteredServices.length > widget.initialVisibleCount;

    final content = <Widget>[
      if (widget.showTitle) ...[
        Text(
          widget.title,
          key: const ValueKey('section-title-services'),
          style: _sectionTitleStyle(tt),
        ),
        const SizedBox(height: 18),
      ],
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            'all',
            ...categoryKeysRow,
          ].map((categoryKey) {
            final selected = categoryKey == _selectedCategoryKey;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(
                  begin: selected ? 0.98 : 1.0,
                  end: selected ? 1.0 : 0.98,
                ),
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () {
                      if (_selectedCategoryKey == categoryKey) return;
                      setState(() {
                        _selectedCategoryKey = categoryKey;
                        _showAll = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      height: 38,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: selected ? Colors.black : Colors.transparent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        serviceCategoryLabel(categoryKey),
                        style: tt.labelLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: selected ? Colors.white : kTextSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      const SizedBox(height: 10),
    ];

    if (filteredServices.isEmpty) {
      content.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            _selectedCategoryKey == 'all'
                ? 'Bu bölümde hyzmat ýok'
                : '$selectedCategoryLabel kategoriýasynda hyzmat ýok',
            style: tt.bodyMedium?.copyWith(color: _kDetailMeta),
          ),
        ),
      );
    } else {
      content.addAll(
        _buildServiceRows(
          services: baseServices,
          showLeadingDivider: false,
        ),
      );
      if (showViewAll) {
        content.add(
          ClipRect(
            child: AnimatedSize(
              duration: _expandAnimationDuration,
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: _showAll
                    ? const BoxConstraints()
                    : const BoxConstraints(maxHeight: 0),
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _showAll ? 1 : 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _buildServiceRows(
                      services: extraServices,
                      showLeadingDivider: baseServices.isNotEmpty,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        content.addAll([
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              key: const ValueKey('services-view-all-button'),
              onPressed: () => setState(() => _showAll = !_showAll),
              style: _wideOutlinedButtonStyle(tt),
              child: Text(
                _showAll ? 'Az görkez' : 'Hemmesi',
                key: ValueKey(
                  _showAll
                      ? 'services-view-all-label-expanded'
                      : 'services-view-all-label-collapsed',
                ),
              ),
            ),
          ),
        ]);
      }
    }

    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content,
      ),
    );
  }

  List<Widget> _buildServiceRows({
    required List<Service> services,
    required bool showLeadingDivider,
  }) {
    final rows = <Widget>[];
    for (int i = 0; i < services.length; i++) {
      final service = services[i];
      rows.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLeadingDivider || i > 0)
              const Divider(height: 1, color: kDetailDivider),
            _ServiceCatalogRow(
              service: service,
              actionMode: widget.actionMode,
              isSelected: widget.selectedServiceIds.contains(service.id),
              onAction: () => widget.onAction(service),
            ),
          ],
        ),
      );
    }
    return rows;
  }
}

class _ServiceCatalogRow extends StatelessWidget {
  final Service service;
  final ServiceCatalogActionMode actionMode;
  final bool isSelected;
  final VoidCallback onAction;

  const _ServiceCatalogRow({
    required this.service,
    required this.actionMode,
    required this.isSelected,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      color: actionMode == ServiceCatalogActionMode.toggle && isSelected
          ? Colors.black.withValues(alpha: 0.02)
          : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.name, style: _rowTitleStyle(tt)),
                  const SizedBox(height: 6),
                  Text(
                    '${service.durationMinutes} min',
                    style: _rowMetaStyle(tt),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${service.price?.toStringAsFixed(0) ?? '?'} TMT',
                    style: _rowTitleStyle(tt),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: actionMode == ServiceCatalogActionMode.book
                  ? OutlinedButton(
                      onPressed: onAction,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: kPrimary),
                        foregroundColor: kTextPrimary,
                        backgroundColor: kCardBg,
                        shape: const StadiumBorder(),
                        minimumSize: const Size(92, 38),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        textStyle: tt.labelMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: kTextPrimary,
                        ),
                      ),
                      child: const Text('Bron'),
                    )
                  : InkWell(
                      onTap: onAction,
                      borderRadius: BorderRadius.circular(999),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : kCardBg,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.black : kDetailDivider,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          isSelected ? Icons.check_rounded : Icons.add_rounded,
                          color: isSelected ? Colors.white : Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

const kDetailDivider = Color(0xFFF0F1F5);
const _kDetailMeta = Color(0xFF8D8D98);

const List<String> _categoryKeyOrder = [
  'haircut',
  'color',
  'beard',
  'styling',
  'treatment',
  'nails',
  'spa',
  'brows',
  'wax',
  'massage',
];

const Map<String, String> _categoryLabels = {
  'haircut': 'Saç kesim',
  'color': 'Saç boýag',
  'beard': 'Sakal',
  'styling': 'Ustilleme',
  'treatment': 'Bejeriş',
  'nails': 'Dyrnak',
  'spa': 'Spa',
  'brows': 'Göz we gaş',
  'wax': 'Depilasia',
  'massage': 'Massage',
};

List<String> serviceCategoryKeysForList(List<Service> services) {
  final present = services.map((service) => service.categoryKey).whereType<String>().toSet();
  final ordered = <String>[];
  for (final key in _categoryKeyOrder) {
    if (present.contains(key)) ordered.add(key);
  }
  final rest = present.where((key) => !ordered.contains(key)).toList()..sort();
  ordered.addAll(rest);
  return ordered;
}

String serviceCategoryLabel(String key) {
  if (key == 'all') return 'Hemmesi';
  return _categoryLabels[key] ?? key;
}

TextStyle? _sectionTitleStyle(TextTheme tt) {
  return tt.titleLarge?.copyWith(
    fontWeight: FontWeight.w600,
    color: kTextPrimary,
    letterSpacing: -0.1,
  );
}

TextStyle? _rowTitleStyle(TextTheme tt) {
  return tt.titleMedium?.copyWith(
    fontWeight: FontWeight.w500,
    color: kTextPrimary,
    height: 1.3,
  );
}

TextStyle? _rowMetaStyle(TextTheme tt) {
  return tt.labelSmall?.copyWith(
    color: _kDetailMeta,
    fontWeight: FontWeight.w400,
  );
}

ButtonStyle _wideOutlinedButtonStyle(TextTheme tt) {
  return OutlinedButton.styleFrom(
    side: const BorderSide(color: kPrimary),
    foregroundColor: kTextPrimary,
    backgroundColor: kCardBg,
    shape: const StadiumBorder(),
    elevation: 0,
    minimumSize: const Size.fromHeight(42),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: 10,
    ),
    textStyle: tt.labelMedium?.copyWith(fontWeight: FontWeight.w700),
  );
}
