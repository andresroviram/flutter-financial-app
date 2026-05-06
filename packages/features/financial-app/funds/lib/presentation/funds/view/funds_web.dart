import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:feature_funds/domain/entities/fund_entity.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_bloc.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_event.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_state.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_state_x.dart';
import 'package:feature_funds/presentation/funds/widgets/balance_header.dart';
import 'package:feature_funds/presentation/funds/widgets/fund_card.dart';
import 'package:feature_funds/presentation/funds/widgets/funds_column.dart';
import 'package:feature_funds/presentation/funds/widgets/section_title.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class FundsWeb extends StatelessWidget {
  const FundsWeb({super.key});

  static const double _narrowLayoutBreakpoint = 1100;
  static const double _subscribedListHeight = 208;
  static const double _verticalListRightPadding = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FundsBloc, FundsState>(
        buildWhen: (prev, curr) =>
            prev.status != curr.status ||
            prev.funds != curr.funds ||
            prev.balance != curr.balance ||
            prev.errorMessage != curr.errorMessage,
        builder: (context, state) => state.resolve(
          loading: () => const Center(child: CircularProgressIndicator()),
          failure: (errorMessage) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const Gap(16),
                Text(
                  errorMessage.isEmpty
                      ? 'funds.error_loading'.tr()
                      : errorMessage,
                ),
                const Gap(16),
                FilledButton(
                  onPressed: () => context.read<FundsBloc>().add(
                    const FundsEvent.loadRequested(),
                  ),
                  child: Text('funds.retry'.tr()),
                ),
              ],
            ),
          ),
          data: (state) => LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < _narrowLayoutBreakpoint;

              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'funds.title'.tr(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(16),
                    BalanceHeader(balance: state.balance),
                    const Gap(24),
                    Expanded(
                      child: isNarrow
                          ? _NarrowFundsLayout(state: state)
                          : _WideFundsLayout(state: state),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WideFundsLayout extends StatelessWidget {
  const _WideFundsLayout({required this.state});

  final FundsState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: FundsColumn(
            title: 'funds.available'.tr(),
            funds: state.availableFunds,
            status: state.status,
            onSubscribe: (fundId, method) => context.read<FundsBloc>().add(
              FundsEvent.subscribeRequested(
                fundId: fundId,
                notificationMethod: method,
              ),
            ),
            onCancel: (_) {},
          ),
        ),
        const Gap(24),
        Expanded(
          child: FundsColumn(
            title: 'funds.subscribed'.tr(),
            funds: state.subscribedFunds,
            status: state.status,
            onSubscribe: (_, _) {},
            onCancel: (fundId) => context.read<FundsBloc>().add(
              FundsEvent.cancelRequested(fundId),
            ),
          ),
        ),
      ],
    );
  }
}

class _NarrowFundsLayout extends StatefulWidget {
  const _NarrowFundsLayout({required this.state});

  final FundsState state;

  @override
  State<_NarrowFundsLayout> createState() => _NarrowFundsLayoutState();
}

class _NarrowFundsLayoutState extends State<_NarrowFundsLayout> {
  bool _lockVerticalScroll = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final subscribedCardWidth = math.min(
          (constraints.maxWidth * 0.75).clamp(320.0, 420.0).toDouble(),
          constraints.maxWidth,
        );

        return ListView(
          padding: const EdgeInsets.only(
            right: FundsWeb._verticalListRightPadding,
          ),
          physics: _lockVerticalScroll
              ? const NeverScrollableScrollPhysics()
              : null,
          children: [
            if (widget.state.subscribedFunds.isNotEmpty) ...[
              SectionTitle(
                title: 'funds.subscribed'.tr(),
                count: widget.state.subscribedFunds.length,
              ),
              const Gap(8),
              _HorizontalSubscribedFundsList(
                height: FundsWeb._subscribedListHeight,
                cardWidth: subscribedCardWidth,
                funds: widget.state.subscribedFunds,
                status: widget.state.status,
                onHoverChanged: (isHovering) {
                  if (_lockVerticalScroll == isHovering) {
                    return;
                  }
                  setState(() => _lockVerticalScroll = isHovering);
                },
              ),
              const Gap(16),
            ],
            SectionTitle(
              title: 'funds.available'.tr(),
              count: widget.state.availableFunds.length,
            ),
            const Gap(8),
            ...widget.state.availableFunds.map(
              (fund) => FundCard(
                fund: fund,
                fundsStatus: widget.state.status,
                onSubscribe: (method) => context.read<FundsBloc>().add(
                  FundsEvent.subscribeRequested(
                    fundId: fund.id,
                    notificationMethod: method,
                  ),
                ),
                onCancel: () {},
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SubscribedFundCard extends StatelessWidget {
  const _SubscribedFundCard({required this.fund, required this.status});

  final FundEntity fund;
  final FundsStatus status;

  @override
  Widget build(BuildContext context) {
    return FundCard(
      fund: fund,
      fundsStatus: status,
      onSubscribe: (_) {},
      onCancel: () =>
          context.read<FundsBloc>().add(FundsEvent.cancelRequested(fund.id)),
    );
  }
}

class _HorizontalSubscribedFundsList extends StatefulWidget {
  const _HorizontalSubscribedFundsList({
    required this.height,
    required this.cardWidth,
    required this.funds,
    required this.status,
    required this.onHoverChanged,
  });

  final double height;
  final double cardWidth;
  final List<FundEntity> funds;
  final FundsStatus status;
  final ValueChanged<bool> onHoverChanged;

  @override
  State<_HorizontalSubscribedFundsList> createState() =>
      _HorizontalSubscribedFundsListState();
}

class _HorizontalSubscribedFundsListState
    extends State<_HorizontalSubscribedFundsList> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || !_controller.hasClients) {
      return;
    }

    final delta = event.scrollDelta.dy == 0
        ? event.scrollDelta.dx
        : event.scrollDelta.dy;
    final targetOffset = (_controller.offset + delta).clamp(
      _controller.position.minScrollExtent,
      _controller.position.maxScrollExtent,
    );

    if (targetOffset != _controller.offset) {
      _controller.jumpTo(targetOffset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: MouseRegion(
        onEnter: (_) => widget.onHoverChanged(true),
        onExit: (_) => widget.onHoverChanged(false),
        child: Listener(
          onPointerSignal: _handlePointerSignal,
          child: ScrollConfiguration(
            behavior: const _InvisibleHorizontalScrollBehavior(),
            child: ListView.separated(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              primary: false,
              shrinkWrap: true,
              itemCount: widget.funds.length,
              separatorBuilder: (_, _) => const Gap(12),
              itemBuilder: (_, index) => SizedBox(
                width: widget.cardWidth,
                child: _SubscribedFundCard(
                  fund: widget.funds[index],
                  status: widget.status,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InvisibleHorizontalScrollBehavior extends MaterialScrollBehavior {
  const _InvisibleHorizontalScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.unknown,
  };

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
