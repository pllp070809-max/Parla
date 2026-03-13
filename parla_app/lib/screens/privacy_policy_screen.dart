import 'package:flutter/material.dart';
import '../theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Gizlinlik syýasaty')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(kSpaceXl, kSpaceMd, kSpaceXl, kSpace3xl),
        children: [
          Text(
            'Parla bukilikleriňizi goramaga we gizlinligiňize hörmet etmäge söz berýär.',
            style: tt.bodyLarge,
          ),
          const SizedBox(height: kSpaceLg),
          _Section(tt: tt, title: 'Ýygnanýan maglumatlar', body: '''
• Adyňyz we telefon nomeriňiz – bron üçin we siziň bilen habarlaşmak üçin
• Bron maglumatlary – wagty, salon we hyzmatlar
• Enjamyňyzdaky sazlamalar (meselem, saýlanan dil)

Bu maglumatlar diňe hyzmaty üpjün etmek we siziň bilen habarlaşmak üçin ulanylýar.'''),
          const SizedBox(height: kSpaceLg),
          _Section(tt: tt, title: 'Maglumatlary paýlaşmak', body: '''
Salonlara diňe bron üçin zerur maglumatlar (adyňyz, wagtyňyz) berilýär. Maglumatlaryňyzy üçünji tarapa satmaýarys we reklama üçin üçünji tarapa bermeýäris.'''),
          const SizedBox(height: kSpaceLg),
          _Section(tt: tt, title: 'Maglumatlary pozmak', body: '''
Sazlamalaryňyzdan "Maglumatlary pozmak" arkaly profil maglumatlaryňyzy pozup bilersiňiz. Soňundan täzeden dolduryp, hyzmaty dowam etdirip bilersiňiz.'''),
          const SizedBox(height: kSpaceLg),
          Text(
            'Soraglaryňyz üçin: support@parla.tm',
            style: tt.bodyMedium?.copyWith(color: kTextSecondary, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final TextTheme tt;
  final String title;
  final String body;

  const _Section({required this.tt, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: tt.titleSmall?.copyWith(color: kPrimary)),
        const SizedBox(height: kSpaceXs),
        Text(body.trim(), style: tt.bodyMedium),
      ],
    );
  }
}
