import 'package:core/database/app_database.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DatabaseModule {
  @singleton
  AppDatabase get database => AppDatabase();
}
