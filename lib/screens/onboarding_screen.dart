import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rent_bill_maker/bloc/language/language_cubit.dart';
import 'package:rent_bill_maker/bloc/property/property_bloc.dart';
import 'package:rent_bill_maker/bloc/settings/settings_cubit.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/utils/responsive.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _fadeController.reset();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  void _completeOnboarding() {
    context.read<SettingsCubit>().setOnboardingComplete();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFF8FAFC),
            Color(0xFFEFF6FF),
            Color(0xFFDBEAFE),
          ],
        ),
      ),
      child: SafeArea(
        child: CenteredContent(
          breakpoint: ResponsiveBreakpoints.tablet,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              // Step indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: _StepIndicator(currentStep: _currentPage, totalSteps: 4),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int page) =>
                        setState(() => _currentPage = page),
                    children: <Widget>[
                      _LanguageStep(onNext: _nextPage),
                      _CalendarStep(onNext: _nextPage),
                      _PropertyStep(onNext: _nextPage, onSkip: _nextPage),
                      _TenantStep(
                        onNext: _completeOnboarding,
                      onSkip: _completeOnboarding,
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

// ---------------------------------------------------------------------------
// Step Indicator
// ---------------------------------------------------------------------------
class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep, required this.totalSteps});
  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) => Row(
    children: List<Widget>.generate(totalSteps, (int index) {
      final bool isActive = index <= currentStep;
      final bool isCurrent = index == currentStep;
      return Expanded(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: isCurrent ? 6 : 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isActive
                ? const Color(0xFF2563EB)
                : const Color(0xFF2563EB).withValues(alpha: 0.15),
          ),
        ),
      );
    }),
  );
}

// ---------------------------------------------------------------------------
// Step 1 – Language (NOT skippable)
// ---------------------------------------------------------------------------
class _LanguageStep extends StatelessWidget {
  const _LanguageStep({required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: <Widget>[
          const Spacer(flex: 2),
          // Illustrated icon
          const _IllustrationBubble(
            icon: Icons.translate_rounded,
            color: Color(0xFF2563EB),
            size: 100,
          ),
          const SizedBox(height: 36),
          Text(
            l10n.get('welcome'),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.get('onboarding_subtitle'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.get('select_language'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _LanguageTile(
            flag: '🇳🇵',
            title: 'नेपाली',
            subtitle: 'Nepali',
            isSelected: l10n.language == AppLanguage.ne,
            onTap: () =>
                context.read<LanguageCubit>().setLanguage(AppLanguage.ne),
          ),
          const SizedBox(height: 12),
          _LanguageTile(
            flag: '🇬🇧',
            title: 'English',
            subtitle: 'English',
            isSelected: l10n.language == AppLanguage.en,
            onTap: () =>
                context.read<LanguageCubit>().setLanguage(AppLanguage.en),
          ),
          const Spacer(flex: 3),
          _PrimaryButton(
            label: l10n.get('next'),
            onPressed: onNext,
            icon: Icons.arrow_forward_rounded,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 2 – Calendar (NOT skippable)
// ---------------------------------------------------------------------------
class _CalendarStep extends StatelessWidget {
  const _CalendarStep({required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context);
    final DateSystem currentSystem = context.watch<SettingsCubit>().state;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: <Widget>[
          const Spacer(flex: 2),
          const _IllustrationBubble(
            icon: Icons.calendar_month_rounded,
            color: Color(0xFF2563EB),
            size: 100,
          ),
          const SizedBox(height: 36),
          Text(
            l10n.get('welcome_calendar'),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.get('calendar_desc'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.get('select_calendar'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _LanguageTile(
            flag: '📅',
            title: l10n.get('bs_system'),
            subtitle: l10n.get('use_bs'),
            isSelected: currentSystem == DateSystem.bs,
            onTap: () =>
                context.read<SettingsCubit>().setDateSystem(DateSystem.bs),
          ),
          const SizedBox(height: 12),
          _LanguageTile(
            flag: '🗓️',
            title: l10n.get('ad_system'),
            subtitle: l10n.get('use_ad'),
            isSelected: currentSystem == DateSystem.ad,
            onTap: () =>
                context.read<SettingsCubit>().setDateSystem(DateSystem.ad),
          ),
          const Spacer(flex: 3),
          _PrimaryButton(
            label: l10n.get('next'),
            onPressed: onNext,
            icon: Icons.arrow_forward_rounded,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 2 – Property (skippable)
// ---------------------------------------------------------------------------
class _PropertyStep extends StatefulWidget {
  const _PropertyStep({required this.onNext, required this.onSkip});
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  State<_PropertyStep> createState() => _PropertyStepState();
}

class _PropertyStepState extends State<_PropertyStep> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                children: <Widget>[
                  const SizedBox(height: 20),
                  const _IllustrationBubble(
                    icon: Icons.home_work_rounded,
                    color: Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l10n.get('setup_property'),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.get('add_property'),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Form card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(
                            0xFF2563EB,
                          ).withValues(alpha: 0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        _OnboardingField(
                          controller: _nameController,
                          label: l10n.get('property_name'),
                          hint: l10n.get('property_name_hint'),
                          icon: Icons.apartment_rounded,
                          validator: (String? v) => v == null || v.isEmpty
                              ? l10n.get('required')
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _OnboardingField(
                          controller: _addressController,
                          label: l10n.get('address'),
                          hint: l10n.get('address_hint'),
                          icon: Icons.location_on_rounded,
                          validator: (String? v) => v == null || v.isEmpty
                              ? l10n.get('required')
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _OnboardingField(
                          controller: _unitController,
                          label: l10n.get('room_number'),
                          hint: l10n.get('room_number_hint'),
                          icon: Icons.door_front_door_rounded,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _GhostButton(
                  label: l10n.get('skip'),
                  onPressed: widget.onSkip,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _PrimaryButton(
                  label: l10n.get('next'),
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final PropertyModel property = PropertyModel.create(
                        name: _nameController.text.trim(),
                        address: _addressController.text.trim(),
                        unitNumber: _unitController.text.trim(),
                        ownerName: '',
                        ownerPhone: '',
                      );
                      context.read<PropertyBloc>().add(AddProperty(property));
                      widget.onNext();
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 3 – Tenant (skippable)
// ---------------------------------------------------------------------------
class _TenantStep extends StatefulWidget {
  const _TenantStep({required this.onNext, required this.onSkip});
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  State<_TenantStep> createState() => _TenantStepState();
}

class _TenantStepState extends State<_TenantStep> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                children: <Widget>[
                  const SizedBox(height: 20),
                  const _IllustrationBubble(
                    icon: Icons.person_add_alt_1_rounded,
                    color: Color(0xFF059669),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l10n.get('setup_tenant'),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.get('add_tenant'),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Property chip (if added)
                  BlocBuilder<PropertyBloc, PropertyState>(
                    builder: (BuildContext context, PropertyState state) {
                      if (state is PropertyLoaded &&
                          state.properties.isNotEmpty) {
                        final PropertyModel p = state.properties.first;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF059669,
                            ).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(
                                0xFF059669,
                              ).withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.home_rounded,
                                size: 20,
                                color: Color(0xFF059669),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  p.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: Color(0xFF059669),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  // Form card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(
                            0xFF059669,
                          ).withValues(alpha: 0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        _OnboardingField(
                          controller: _nameController,
                          label: l10n.get('tenant_name'),
                          hint: l10n.get('full_name_hint'),
                          icon: Icons.person_rounded,
                          validator: (String? v) => v == null || v.isEmpty
                              ? l10n.get('required')
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _OnboardingField(
                          controller: _phoneController,
                          label: l10n.get('contact_number'),
                          hint: l10n.get('phone_hint'),
                          icon: Icons.phone_rounded,
                          keyboardType: TextInputType.phone,
                          validator: (String? v) => v == null || v.isEmpty
                              ? l10n.get('required')
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _GhostButton(
                  label: l10n.get('skip'),
                  onPressed: widget.onSkip,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _PrimaryButton(
                  label: l10n.get('get_started'),
                  icon: Icons.rocket_launch_rounded,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final PropertyState propertyState = context
                          .read<PropertyBloc>()
                          .state;
                      if (propertyState is PropertyLoaded &&
                          propertyState.properties.isNotEmpty) {
                        final PropertyModel property =
                            propertyState.properties.first;
                        final TenantModel tenant = TenantModel.create(
                          name: _nameController.text.trim(),
                          phone: _phoneController.text.trim(),
                          propertyId: property.id,
                          moveInDate: DateTime.now(),
                          citizenshipNumber: '',
                        );
                        context.read<TenantBloc>().add(AddTenant(tenant));
                      }
                      widget.onNext();
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ===========================================================================
// Shared Widgets
// ===========================================================================

/// Animated illustrated circle with icon
class _IllustrationBubble extends StatelessWidget {
  const _IllustrationBubble({
    required this.icon,
    required this.color,
    this.size = 80,
  });
  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.06),
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.65,
          height: size * 0.65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.12),
          ),
          child: Icon(icon, size: size * 0.35, color: color),
        ),
      ),
    ),
  );
}

/// Language selection tile
class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.flag,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });
  final String flag;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : <BoxShadow>[],
      ),
      child: Row(
        children: <Widget>[
          Text(flag, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isSelected
                ? Container(
                    key: const ValueKey<String>('check'),
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2563EB),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  )
                : Container(
                    key: const ValueKey<String>('uncheck'),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 2,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}

/// Styled text field for onboarding forms
class _OnboardingField extends StatelessWidget {
  const _OnboardingField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
    ),
  );
}

/// Primary gradient-ish button
class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
  });
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 54,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        shadowColor: const Color(0xFF2563EB).withValues(alpha: 0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          if (icon != null) ...<Widget>[
            const SizedBox(width: 8),
            Icon(icon, size: 20),
          ],
        ],
      ),
    ),
  );
}

/// Ghost / skip button
class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 54,
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF64748B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
