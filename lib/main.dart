import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'adapters/hive_adapter.dart';
import 'adapters/user_storage_adapter.dart';
import 'models/reading_plan.dart';
import 'models/user.dart';
import 'providers/reading_plan_provider.dart';
import 'home_page.dart';
import 'app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ReadingAdapter());
  Hive.registerAdapter(StreamAdapter());
  Hive.registerAdapter(ReadingPlanAdapter());
  Hive.registerAdapter(UserReadingPlanAdapter());
  Hive.registerAdapter(UserAdapter());

  // Initialize globalUser
  final userBox = await Hive.openBox<User>('userBox');
  final userStorageAdapter = UserStorageAdapter(userBox);
  globalUser = userStorageAdapter.loadUser() ?? User();
  userStorageAdapter.setUser(globalUser!);

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAppState()),
        ChangeNotifierProvider(create: (context) => ReadingPlanProvider()),
      ],
      child: MaterialApp(
        title: 'Bible Journey',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        // supportedLocales: AppLocalizations.supportedLocales,
        home: MyHomePage(),
      ),
    );
  }
}
