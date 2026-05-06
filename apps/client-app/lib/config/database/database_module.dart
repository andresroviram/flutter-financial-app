import 'package:flutter_wigilabs_sr/config/database/app_database.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DatabaseModule {
  @singleton
  AppDatabase get database => AppDatabase();
}
