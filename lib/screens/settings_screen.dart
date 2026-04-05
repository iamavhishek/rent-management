import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rent_bill_maker/bloc/language/language_cubit.dart';
import 'package:rent_bill_maker/bloc/settings/settings_cubit.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/utils/responsive.dart';
import 'package:rent_bill_maker/utils/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context);

    return CenteredContent(
      child: SafeArea(
        child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: <Widget>[
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
              children: <Widget>[
                _SettingsTile(
                  icon: Icons.translate_rounded,
                  title: l10n.get('language'),
                  subtitle:
                      context.watch<LanguageCubit>().state == AppLanguage.ne
                      ? 'नेपाली'
                      : 'English',
                  onTap: () => _showLanguageDialog(context),
                  iconColor: const Color(0xFF2563EB),
                  showDivider: true,
                ),
                _SettingsTile(
                  icon: Icons.calendar_month_rounded,
                  title: l10n.get('select_calendar'),
                  subtitle:
                      context.watch<SettingsCubit>().state == DateSystem.bs
                      ? l10n.get('bs_system')
                      : l10n.get('ad_system'),
                  onTap: () => _showDateSystemDialog(context),
                  iconColor: const Color(0xFF059669),
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
              children: <Widget>[
                _SettingsTile(
                  icon: Icons.people_alt_rounded,
                  title: l10n.get('tenants'),
                  onTap: () => context.push('/tenants'),
                  iconColor: AppTheme.accent,
                  showDivider: true,
                ),
                _SettingsTile(
                  icon: Icons.home_work_rounded,
                  title: l10n.get('properties'),
                  onTap: () => context.push('/properties'),
                  iconColor: AppTheme.warning,
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
                children: <Widget>[
                  Row(
                    children: <Widget>[
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
                        children: <Widget>[
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
      ),
    );
  }

  void _showDateSystemDialog(BuildContext context) {
    final L10n l10n = L10n.of(context);
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        final DateSystem currentSystem = ctx.watch<SettingsCubit>().state;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(l10n.get('select_calendar')),
          content: RadioGroup<DateSystem>(
            groupValue: currentSystem,
            onChanged: (DateSystem? val) {
              if (val != null) {
                ctx.read<SettingsCubit>().setDateSystem(val);
                Navigator.pop(ctx);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile<DateSystem>(
                  title: Text(l10n.get('bs_system')),
                  value: DateSystem.bs,
                ),
                RadioListTile<DateSystem>(
                  title: Text(l10n.get('ad_system')),
                  value: DateSystem.ad,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final L10n l10n = L10n.of(context);
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        final AppLanguage currentLang = ctx.watch<LanguageCubit>().state;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(l10n.get('language')),
          content: RadioGroup<AppLanguage>(
            groupValue: currentLang,
            onChanged: (AppLanguage? val) {
              if (val != null) {
                ctx.read<LanguageCubit>().setLanguage(val);
                Navigator.pop(ctx);
              }
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile<AppLanguage>(
                  title: Text('नेपाली'),
                  value: AppLanguage.ne,
                ),
                RadioListTile<AppLanguage>(
                  title: Text('English'),
                  value: AppLanguage.en,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
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

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.iconColor,
    this.subtitle,
    this.showDivider = false,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color iconColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
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
