import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/forecast/forecast_providers.dart';
import '../../../core/preferences/preferences_providers.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/utils/double_utils.dart';
import '../../../l10n/app_localizations.dart';

class AccumulatedSection extends ConsumerStatefulWidget {
  const AccumulatedSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccumulatedSectionState();
}

class _AccumulatedSectionState extends ConsumerState<AccumulatedSection> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final forecastAsync = ref.watch(forecastProvider);
    final settingsAsync = ref.watch(preferencesProvider);
    final symbol = settingsAsync.value?.currency?? r'$';

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.accumulatedLabel,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              symbol,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: forecastAsync.when(
                loading: () => LinearProgressIndicator(),
                error: (e, _) => Text(e.toString()),
                data: (f) => _AnimatedSplitAmount(
                  duration: const Duration(milliseconds: 900),
                  value: f.accumulated,
                  curve: Curves.easeInCubic,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        forecastAsync.when(
          loading: () => CircularProgressIndicator(),
          error: (e, _) => Text(e.toString()),
          data: (f) {
            final goalFormated = fmt(f.target, symbol: symbol);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${l10n.goalLabel} $goalFormated",
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0,
                    end: f.accumulated / f.target * 100,
                  ),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => Text(
                    "${value.toPercentageString()}%",
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 5),
        forecastAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text(e.toString()),
          data: (f) => TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 0,
              end: (f.accumulated / f.target).toProgress,
            ),
            duration: const Duration(milliseconds: 900),
            curve: Curves.bounceOut,
            builder: (context, value, _) => LinearProgressIndicator(
              borderRadius: BorderRadius.circular(2),
              value: value,
              backgroundColor: colorScheme.primaryContainer,
              minHeight: 8,
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedSplitAmount extends StatefulWidget {
  final double value;
  final Duration duration;
  final Curve curve;

  const _AnimatedSplitAmount({
    required this.value,
    required this.duration,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<_AnimatedSplitAmount> createState() => _AnimatedSplitAmountState();
}

class _AnimatedSplitAmountState extends State<_AnimatedSplitAmount>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _fromValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedSplitAmount oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _fromValue =
          _fromValue + (oldWidget.value - _fromValue) * _animation.value;
      _controller
        ..duration = widget.duration
        ..forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _currentValue =>
      _fromValue + (widget.value - _fromValue) * _animation.value;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final v = _currentValue;
        final integer = fmt(v, symbol: '', decimals: 0);
        final decimal = fmtDecimal(v);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              integer,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 84,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              ".$decimal",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}
