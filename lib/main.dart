import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paywize/src/app.dart';
import 'package:paywize/src/common/database/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// start the db connection
  await PaywizeDB.database;
  runApp(ProviderScope(child: const PaywizeApp()));
}
