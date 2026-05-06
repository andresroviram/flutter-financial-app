import 'package:core/get_it.dart';
import '../../../domain/usecases/funds_usecases.dart';
import '../bloc/funds_bloc.dart';
import '../bloc/funds_event.dart';
import '../bloc/funds_state.dart';
import 'funds_mobile.dart';
import 'funds_web.dart';
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
    )..add(const FundsLoadRequested()),
    child: const FundsView(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<FundsBloc, FundsState>(
      listenWhen: (prev, curr) =>
          prev.lastActionSuccess != curr.lastActionSuccess ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null && state.status == FundsStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        if (state.lastActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Operación realizada con éxito'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
          ? const FundsWeb()
          : const FundsMobile(),
    );
  }
}
