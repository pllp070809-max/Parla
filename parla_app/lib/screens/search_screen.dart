import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/salon.dart';
import '../theme.dart';
import '../widgets/shared_widgets.dart';
import 'salons_list_screen.dart';
import 'salon_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _queryCtrl = TextEditingController();
  final _focusNode = FocusNode();

  static const _recentSearches = ['Saç kesmek', 'Barberhana', 'Dyrnak', 'Massage'];
  static const _popularSearches = ['Gözellik salony', 'Spa', 'Kirpik', 'Makiýaž'];

  @override
  void dispose() {
    _queryCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) return;
    Navigator.pushReplacement(
      context,
      fadeSlideRoute(SalonsListScreen(searchQuery: query.trim())),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final query = _queryCtrl.text.trim();
    final salonsAsync = ref.watch(_searchResultsProvider(query));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _queryCtrl,
                      focusNode: _focusNode,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onSubmitted: _onSearch,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Salonlary we hyzmatlary gözle',
                        prefixIcon: const Icon(Icons.search_rounded, color: kTextTertiary, size: 22),
                        suffixIcon: query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 20),
                                onPressed: () {
                                  _queryCtrl.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: query.isEmpty ? _buildSuggestions(tt) : _buildResults(context, salonsAsync, tt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(TextTheme tt) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 8),
        Text('Soňky gözlegler', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ..._recentSearches.map((q) => _SuggestionChip(label: q, onTap: () => _onSearch(q))),
        const SizedBox(height: 24),
        Text('Meşhur gözlegler', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ..._popularSearches.map((q) => _SuggestionChip(label: q, onTap: () => _onSearch(q))),
      ],
    );
  }

  Widget _buildResults(BuildContext context, AsyncValue<List<Salon>> data, TextTheme tt) {
    return data.when(
      loading: () => const Center(child: CircularProgressIndicator(color: kPrimary)),
      error: (e, _) => ErrorRetryWidget(
        message: 'Gözleg netijesi ýüklenmedi',
        onRetry: () => ref.invalidate(_searchResultsProvider(_queryCtrl.text.trim())),
      ),
      data: (salons) {
        if (salons.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off_rounded, size: 64, color: kTextTertiary),
                const SizedBox(height: 16),
                Text('Netije tapylmady', style: tt.titleMedium),
                Text('"${_queryCtrl.text}" boýunça hiç zat tapylmady', style: tt.bodyMedium, textAlign: TextAlign.center),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          itemCount: salons.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final s = salons[i];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: kPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(kRadiusMd),
                ),
                child: const Icon(Icons.storefront_rounded, color: kPrimary),
              ),
              title: Text(s.name, style: tt.titleSmall),
              subtitle: s.address != null ? Text(s.address!, style: tt.bodySmall, maxLines: 1) : null,
              trailing: const Icon(Icons.chevron_right_rounded, color: kTextTertiary),
              onTap: () => Navigator.push(context, fadeSlideRoute(SalonDetailScreen(salonId: s.id))),
            );
          },
        );
      },
    );
  }
}

final _searchResultsProvider = FutureProvider.family<List<Salon>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final list = await ref.read(apiServiceProvider).getSalons();
  final q = query.toLowerCase();
  return list.where((s) {
    if (s.name.toLowerCase().contains(q)) return true;
    if (s.address != null && s.address!.toLowerCase().contains(q)) return true;
    if (s.category != null && s.category!.toLowerCase().contains(q)) return true;
    return false;
  }).toList();
});

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.history_rounded, size: 20, color: kTextSecondary),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyLarge)),
            ],
          ),
        ),
      ),
    );
  }
}
