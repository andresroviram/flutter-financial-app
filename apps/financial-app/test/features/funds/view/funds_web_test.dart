import 'package:bloc_test/bloc_test.dart';
import 'package:feature_funds/domain/entities/fund_entity.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_bloc.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_event.dart';
import 'package:feature_funds/presentation/funds/bloc/funds_state.dart';
import 'package:feature_funds/presentation/funds/view/funds_web.dart';
import 'package:feature_funds/presentation/funds/widgets/funds_column.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class MockFundsBloc extends MockBloc<FundsEvent, FundsState>
    implements FundsBloc {}

const tAvailableFund = FundEntity(
  id: '1',
  name: 'FPV_BTG_PACTUAL_RECAUDADORA',
  minimumAmount: 75000,
  category: FundCategory.fpv,
);

const tSubscribedFund = FundEntity(
  id: '2',
  name: 'FIC_BTG_PACTUAL_EFECTIVO',
  minimumAmount: 50000,
  category: FundCategory.fic,
  isSubscribed: true,
  subscribedAmount: 50000,
);

void main() {
  setUpAll(() async {
    await initTestLocalization();
    registerFallbackValue(const FundsEvent.loadRequested());
    registerFallbackValue(const FundsState());
  });

  group('FundsWeb', () {
    Widget buildSubject(FundsBloc bloc) => makeTestWidget(
      BlocProvider<FundsBloc>.value(value: bloc, child: const FundsWeb()),
    );

    testWidgets('usa layout responsive apilado en anchos reducidos', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(900, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final bloc = MockFundsBloc();
      whenListen(
        bloc,
        const Stream<FundsState>.empty(),
        initialState: const FundsState(
          status: FundsStatus.success,
          funds: [tSubscribedFund, tAvailableFund],
        ),
      );

      await tester.pumpWidget(buildSubject(bloc));
      await tester.pumpAndSettle();

      final horizontalListFinder = find.byWidgetPredicate(
        (widget) =>
            widget is ListView && widget.scrollDirection == Axis.horizontal,
      );
      final horizontalList = tester.widget<ListView>(horizontalListFinder);

      expect(horizontalList.scrollDirection, Axis.horizontal);
      expect(horizontalList.primary, isFalse);
      expect(horizontalList.shrinkWrap, isTrue);
      expect(find.byType(FundsColumn), findsNothing);
      expect(find.text('Fondos Suscritos'), findsOneWidget);
      expect(find.text('Fondos Disponibles'), findsOneWidget);

      final behavior = ScrollConfiguration.of(
        tester.element(horizontalListFinder),
      );

      expect(behavior.dragDevices, contains(PointerDeviceKind.mouse));
      expect(behavior.dragDevices, contains(PointerDeviceKind.trackpad));

      final verticalListFinder = find.byWidgetPredicate(
        (widget) =>
            widget is ListView && widget.scrollDirection == Axis.vertical,
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer();
      await mouse.moveTo(tester.getCenter(horizontalListFinder));
      await tester.pump();

      final verticalList = tester.widget<ListView>(verticalListFinder.first);
      expect(verticalList.physics, isA<NeverScrollableScrollPhysics>());
      expect(verticalList.padding, const EdgeInsets.only(right: 16));
    });

    testWidgets('mantiene dos columnas en anchos amplios', (tester) async {
      tester.view.physicalSize = const Size(1400, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final bloc = MockFundsBloc();
      whenListen(
        bloc,
        const Stream<FundsState>.empty(),
        initialState: const FundsState(
          status: FundsStatus.success,
          funds: [tSubscribedFund, tAvailableFund],
        ),
      );

      await tester.pumpWidget(buildSubject(bloc));
      await tester.pumpAndSettle();

      expect(find.byType(FundsColumn), findsNWidgets(2));
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is ListView && widget.scrollDirection == Axis.horizontal,
        ),
        findsNothing,
      );
    });
  });
}
