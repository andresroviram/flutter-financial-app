import 'package:core/get_it.dart';
import 'package:core/utils/notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feature_funds/domain/usecases/funds_usecases.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_bloc.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_event.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_state.dart';
import 'package:feature_funds/presentation/funds/view/funds_mobile.dart';
import 'package:feature_funds/presentation/funds/view/funds_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class FundsView extends StatelessWidget {
  const FundsView({super.key});

  static const String path = '/funds';
  static const String name = 'funds';

  static Widget create() => BlocProvider(
    create: (_) => FundsBloc(
      getFunds: getIt<GetFundsUseCase>(),
      getBalance: getIt<GetBalanceUseCase>(),
      subscribeFund: getIt<SubscribeFundUseCase>(),
      cancelFund: getIt<CancelFundUseCase>(),
    )..add(const FundsEvent.loadRequested()),
    child: const FundsView(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<FundsBloc, FundsState>(
      listenWhen: (prev, curr) =>
          prev.lastActionSuccess != curr.lastActionSuccess ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (context.mounted) {
          if (state.errorMessage != null &&
              state.status == FundsStatus.success) {
            AppNotification.showNotificationError(
              context,
              title: state.errorMessage!,
            );
          }
          if (state.lastActionSuccess) {
            AppNotification.showNotification(
              context,
              title: 'funds.success'.tr(),
            );
          }
        }
      },
      child: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
          ? const FundsWeb()
          : const FundsMobile(),
    );
  }
}
