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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: [
          // Header
          Text(
            l10n.get('settings'),
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),

          // ── App Settings ──
          _SectionHeader(label: l10n.get('settings')),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.translate,
                  title: l10n.get('language'),
                  subtitle: context.watch<LanguageCubit>().state == AppLanguage.ne ? 'नेपाली' : 'English',
                  onTap: () => _showLanguageDialog(context),
                  iconColor: Colors.blue,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Data Management ──
          _SectionHeader(label: l10n.get('management')),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.people_alt,
                  title: l10n.get('tenants'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TenantListScreen()),
                  ),
                  iconColor: AppTheme.accent,
                ),
                Divider(height: 1, indent: 56, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                _SettingsTile(
                  icon: Icons.home_work,
                  title: l10n.get('properties'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PropertyListScreen()),
                  ),
                  iconColor: AppTheme.warning,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Information ──
          _SectionHeader(label: l10n.get('about')),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            ),
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
                          color: isDark ? Colors.grey.shade800 : AppTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.receipt_long,
                          color: isDark ? Colors.white : AppTheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.get('app_name'),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Version 1.0.0',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.get('app_description'),
                    style: TextStyle(fontSize: 14, color: theme.textTheme.bodyMedium?.color),
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
    showDialog(
      context: context,
      builder: (ctx) {
        final currentLang = ctx.watch<LanguageCubit>().state;
        return AlertDialog(
          title: Text(L10n.of(ctx).get('language')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('नेपाली'),
                leading: Radio<AppLanguage>(
                  value: AppLanguage.ne,
                  groupValue: currentLang,
                  onChanged: (val) {
                    if (val != null) {
                      ctx.read<LanguageCubit>().toggleLanguage();
                      Navigator.pop(ctx);
                    }
                  },
                ),
                onTap: () {
                  ctx.read<LanguageCubit>().toggleLanguage();
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: const Text('English'),
                leading: Radio<AppLanguage>(
                  value: AppLanguage.en,
                  groupValue: currentLang,
                  onChanged: (val) {
                    if (val != null) {
                      ctx.read<LanguageCubit>().toggleLanguage();
                      Navigator.pop(ctx);
                    }
                  },
                ),
                onTap: () {
                  ctx.read<LanguageCubit>().toggleLanguage();
                  Navigator.pop(ctx);
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
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade500,
          letterSpacing: 1.2,
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

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDark ? iconColor.withValues(alpha: 0.2) : iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: isDark ? iconColor.withValues(alpha: 0.9) : iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            )
          : null,
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
    );
  }
}
