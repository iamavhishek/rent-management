import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_bill_maker/bloc/language/language_cubit.dart';
import 'package:rent_bill_maker/screens/property_list_screen.dart';
import 'package:rent_bill_maker/screens/tenant_list_screen.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/utils/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          Text(
            l10n.get('settings'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),

          // App Settings
          _SectionHeader(label: l10n.get('settings')),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.translate_rounded,
                  title: l10n.get('language'),
                  subtitle:
                      context.watch<LanguageCubit>().state == AppLanguage.ne
                      ? 'नेपाली'
                      : 'English',
                  onTap: () => _showLanguageDialog(context),
                  iconColor: const Color(0xFF2563EB),
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Data Management
          _SectionHeader(label: l10n.get('management')),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.people_alt_rounded,
                  title: l10n.get('tenants'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TenantListScreen()),
                  ),
                  iconColor: AppTheme.accent,
                  showDivider: true,
                ),
                _SettingsTile(
                  icon: Icons.home_work_rounded,
                  title: l10n.get('properties'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PropertyListScreen(),
                    ),
                  ),
                  iconColor: AppTheme.warning,
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // About
          _SectionHeader(label: l10n.get('about')),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E7FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          color: AppTheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rent Bill Maker',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Version 1.0.0',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.get('app_description'),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = L10n.of(context);
    showDialog(
      context: context,
      builder: (ctx) {
        final currentLang = ctx.watch<LanguageCubit>().state;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(l10n.get('language')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<AppLanguage>(
                title: const Text('नेपाली'),
                value: AppLanguage.ne,
                groupValue: currentLang,
                onChanged: (val) {
                  if (val != null) {
                    ctx.read<LanguageCubit>().toggleLanguage();
                    Navigator.pop(ctx);
                  }
                },
              ),
              RadioListTile<AppLanguage>(
                title: const Text('English'),
                value: AppLanguage.en,
                groupValue: currentLang,
                onChanged: (val) {
                  if (val != null) {
                    ctx.read<LanguageCubit>().toggleLanguage();
                    Navigator.pop(ctx);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toLowerCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF64748B),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color iconColor;
  final bool showDivider;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.iconColor,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                )
              : null,
          trailing: const Icon(
            Icons.chevron_right,
            color: Color(0xFFCBD5E1),
            size: 20,
          ),
        ),
        if (showDivider) const Divider(height: 1, indent: 60),
      ],
    );
  }
}
