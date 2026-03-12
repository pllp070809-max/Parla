import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/providers.dart';
import '../theme.dart';
import 'settings_screen.dart';

const _kPrefName = 'profile_name';
const _kPrefPhone = 'profile_phone';
const _kPrefGender = 'profile_gender';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _phoneFocus = FocusNode();

  String? _gender;
  bool _editing = false;
  bool _saving = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    _nameCtrl.text = prefs.getString(_kPrefName) ?? '';
    _phoneCtrl.text = _stripPrefix(prefs.getString(_kPrefPhone) ?? '');
    setState(() {
      _gender = prefs.getString(_kPrefGender);
      _loaded = true;
      _editing = _nameCtrl.text.isEmpty && _phoneCtrl.text.isEmpty;
    });
  }

  String _stripPrefix(String phone) {
    if (phone.startsWith('+993')) return phone.substring(4);
    return phone;
  }

  String _fullPhone() {
    final digits = _phoneCtrl.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return '';
    return '+993$digits';
  }

  String _formatPhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length <= 3) return '+993 $digits';
    if (digits.length <= 5) return '+993 ${digits.substring(0, 2)} ${digits.substring(2)}';
    return '+993 ${digits.substring(0, 2)} ${digits.substring(2, 4)} ${digits.substring(4)}';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    final phone = _fullPhone();
    await prefs.setString(_kPrefName, _nameCtrl.text.trim());
    await prefs.setString(_kPrefPhone, phone);
    if (_gender != null) {
      await prefs.setString(_kPrefGender, _gender!);
    } else {
      await prefs.remove(_kPrefGender);
    }
    if (!mounted) return;
    ref.read(userPhoneProvider.notifier).setPhone(phone);
    ref.invalidate(myBookingsProvider);
    setState(() { _saving = false; _editing = false; });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
          SizedBox(width: kSpaceSm),
          Text('Üstünlikli saklandy!'),
        ]),
        backgroundColor: kSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusMd)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _startEdit() => setState(() => _editing = true);

  void _cancelEdit() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    _nameCtrl.text = prefs.getString(_kPrefName) ?? '';
    _phoneCtrl.text = _stripPrefix(prefs.getString(_kPrefPhone) ?? '');
    setState(() {
      _gender = prefs.getString(_kPrefGender);
      _editing = false;
    });
  }

  Future<void> _openSettings() async {
    final cleared = await Navigator.push<bool>(
      context,
      fadeSlideRoute(const SettingsScreen()),
    );
    if (cleared == true && mounted) {
      _nameCtrl.clear();
      _phoneCtrl.clear();
      setState(() { _gender = null; _editing = true; });
    }
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Adyňyzy ýazyň';
    if (v.trim().length < 2) return 'Iň az 2 harp bolmaly';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Telefon nomeriňizi ýazyň';
    final digits = v.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length < 8) return 'Nädogry telefon nomeri';
    return null;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          if (_loaded && !_editing)
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              tooltip: 'Üýtgetmek',
              onPressed: _startEdit,
            ),
          if (_editing && _nameCtrl.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              tooltip: 'Goýbolsun',
              onPressed: _cancelEdit,
            ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            tooltip: 'Sazlamalar',
            onPressed: _openSettings,
          ),
        ],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator(color: kPrimary))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(kSpaceXl, kSpaceSm, kSpaceXl, kSpace3xl),
                children: [
                  _buildHeader(tt),
                  const SizedBox(height: kSpace2xl),

                  if (_editing) ..._buildEditMode(tt)
                  else ..._buildViewMode(tt),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(TextTheme tt) {
    final hasName = _nameCtrl.text.trim().isNotEmpty;
    final initials = hasName
        ? _nameCtrl.text.trim().split(' ').map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').take(2).join()
        : '';

    return Column(
      children: [
        Center(
          child: Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [kPrimary.withValues(alpha: 0.25), kPrimary.withValues(alpha: 0.08)],
              ),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: kPrimary.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: hasName
                ? Center(child: Text(initials, style: tt.headlineLarge?.copyWith(color: kPrimary, fontWeight: FontWeight.w700)))
                : const Icon(Icons.person_rounded, size: 48, color: kPrimary),
          ),
        ),
        const SizedBox(height: kSpaceLg),
        if (hasName && !_editing) ...[
          Text(
            _nameCtrl.text.trim(),
            style: tt.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kSpaceXs),
          Text(
            _fullPhone().isNotEmpty ? _formatPhone(_phoneCtrl.text) : 'Telefon goşulmadyk',
            style: tt.bodyMedium?.copyWith(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          if (_gender != null) ...[
            const SizedBox(height: kSpaceXs),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: kSpaceMd, vertical: kSpaceXs),
              decoration: BoxDecoration(
                color: kPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(kRadiusXl),
              ),
              child: Text(
                _gender == 'male' ? 'Erkek' : 'Zenan',
                style: tt.labelLarge?.copyWith(color: kPrimary, fontSize: 12),
              ),
            ),
          ],
        ] else ...[
          Text('Maglumatyňyz', style: tt.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: kSpaceXs),
          Text(
            'Lokal saklanýar, bron wagtynda awtomatik doldurylýar.',
            style: tt.bodyMedium, textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  List<Widget> _buildViewMode(TextTheme tt) {
    return [
      _ProfileInfoCard(
        children: [
          _InfoRow(icon: Icons.person_rounded, label: 'Ady', value: _nameCtrl.text.trim()),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.phone_rounded,
            label: 'Telefon',
            value: _fullPhone().isNotEmpty ? _formatPhone(_phoneCtrl.text) : '—',
          ),
          if (_gender != null) ...[
            const Divider(height: 1),
            _InfoRow(
              icon: _gender == 'male' ? Icons.male_rounded : Icons.female_rounded,
              label: 'Jyns',
              value: _gender == 'male' ? 'Erkek' : 'Zenan',
            ),
          ],
        ],
      ),
      const SizedBox(height: kSpaceLg),
      OutlinedButton.icon(
        onPressed: _startEdit,
        icon: const Icon(Icons.edit_rounded, size: 18),
        label: const Text('Üýtgetmek'),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusMd)),
        ),
      ),
    ];
  }

  List<Widget> _buildEditMode(TextTheme tt) {
    return [
      _ProfileInfoCard(
        children: [
          Padding(
            padding: const EdgeInsets.all(kSpaceLg),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Adyňyz', prefixIcon: Icon(Icons.person_rounded)),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                  onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
                ),
                const SizedBox(height: kSpaceLg),
                TextFormField(
                  controller: _phoneCtrl,
                  focusNode: _phoneFocus,
                  decoration: InputDecoration(
                    labelText: 'Telefon',
                    prefixIcon: const Icon(Icons.phone_rounded),
                    prefixText: '+993 ',
                    prefixStyle: tt.bodyLarge?.copyWith(color: kTextSecondary),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(8)],
                  textInputAction: TextInputAction.done,
                  validator: _validatePhone,
                  onFieldSubmitted: (_) => _save(),
                ),
                const SizedBox(height: kSpaceLg),
                _GenderSelector(
                  value: _gender,
                  onChanged: (v) => setState(() => _gender = v),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: kSpaceLg),
      ElevatedButton(
        onPressed: _saving ? null : _save,
        child: _saving
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Text('Saklamak'),
      ),
    ];
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final List<Widget> children;
  const _ProfileInfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(kRadiusLg),
        boxShadow: kShadowSm,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpaceLg, vertical: kSpaceMd + 4),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: kPrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(kRadiusSm),
            ),
            child: Icon(icon, size: 20, color: kPrimary),
          ),
          const SizedBox(width: kSpaceMd),
          SizedBox(width: 72, child: Text(label, style: tt.bodyMedium?.copyWith(color: kTextSecondary))),
          Expanded(child: Text(value, style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w500), textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  const _GenderSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Jyns (hökmany däl)', style: tt.bodyMedium),
        const SizedBox(height: kSpaceSm),
        Row(
          children: [
            Expanded(child: _GenderChip(
              icon: Icons.male_rounded,
              label: 'Erkek',
              selected: value == 'male',
              onTap: () => onChanged(value == 'male' ? null : 'male'),
            )),
            const SizedBox(width: kSpaceMd),
            Expanded(child: _GenderChip(
              icon: Icons.female_rounded,
              label: 'Zenan',
              selected: value == 'female',
              onTap: () => onChanged(value == 'female' ? null : 'female'),
            )),
          ],
        ),
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _GenderChip({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kRadiusMd),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: kSpaceMd),
          decoration: BoxDecoration(
            color: selected ? kPrimary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(kRadiusMd),
            border: Border.all(
              color: selected ? kPrimary : kTextSecondary.withValues(alpha: 0.3),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: selected ? kPrimary : kTextSecondary),
              const SizedBox(width: kSpaceSm),
              Text(label, style: tt.labelLarge?.copyWith(color: selected ? kPrimary : kTextSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
