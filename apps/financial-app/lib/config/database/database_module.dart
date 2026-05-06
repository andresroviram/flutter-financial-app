import 'package:financial_app/config/database/funds_database.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DatabaseModule {
  @singleton
  FundsDatabase get database => FundsDatabase();
}
