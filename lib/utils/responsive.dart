import 'package:flutter/material.dart';

/// Central responsive breakpoint utilities.
class ResponsiveBreakpoints {
  ResponsiveBreakpoints._();

  static const double tablet = 600;
  static const double desktop = 900;
  static const double navRail = 800;
  static const double wideContent = 700;

  static bool useRailNavigation(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= navRail;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;

  static double maxContentWidth(double screenW) {
    if (screenW >= desktop) return 800;
    if (screenW >= tablet) return 560;
    return double.infinity;
  }
}

/// On screens wider than [breakpoint], constrains content to a centered
/// max-width box. On narrow screens, this is a no-op passthrough.
class CenteredContent extends StatelessWidget {
  const CenteredContent({
    required this.child,
    super.key,
    this.breakpoint = ResponsiveBreakpoints.tablet,
    this.padding,
    this.maxWidth,
  });

  final Widget child;
  final double breakpoint;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < breakpoint) return child;

        final double maxW =
            maxWidth ?? ResponsiveBreakpoints.maxContentWidth(constraints.maxWidth);

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
            child: Padding(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
              child: child,
            ),
          ),
        );
      },
    );
}

/// Returns an adaptive column count for grids.
/// [baseCount] is the mobile count. Scales to baseCount * 2 on tablet+, capped at 4.
int adaptiveGridCount(BuildContext context, {int baseCount = 2}) {
  final double w = MediaQuery.sizeOf(context).width;
  if (w >= ResponsiveBreakpoints.tablet) return (baseCount * 2).clamp(2, 4);
  return baseCount;
}
