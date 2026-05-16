import 'package:etrace/Api/TokenManager.dart';
import 'package:etrace/Notifiers/auth/AuthGate.dart';
import 'package:etrace/Pages/ExpensePage.dart';
import 'package:flutter/material.dart';
import 'package:etrace/Pages/RegisterPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//inal Color emeraldDark = const Color(0xFF046A38);
// final Color emeraldLight = const Color(0xFF2EBB57);
// final Color blackShade = const Color(0xFF1C1C1C);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenManager().loadTokens(); // load tokens from storage to memory
  await dotenv.load(fileName: ".env"); //  load env
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AuthGate(),
      onGenerateRoute: (settings) {
        const Color emerald = Color(0xFF046A38);
        late Widget page;
        switch (settings.name) {
          case '/register':
            page = Registerpage(emerald: emerald);
            break;

          case '/searchResults':
            page = ExpensePage();
            break;

          default:
            page = const AuthGate();
        }

        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(
            milliseconds: 250,
          ), // shorter = faster
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // slide from right
            const end = Offset.zero;
            const curve = Curves.fastOutSlowIn;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Project App',
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}
/* 

TODO:
- Expense caching and state managment - pending
- Reserve caching and state managment - pending 
TESTING:
- Category caching and state managment - Done 
- login - Done
- register - Done
- home page - Done
- logout and token managment - Done
- balance fetching - Done 
- reserve fetching  - Done
- category fetching - Done 
- exense serach and fetch with offset and paging and without offset and paging - Done
- Expense add - Done
- Reserve add - Done
- income add - Done
- deletion logic for expense - Done
- deletion logic for reserve - Done
- Category fetching for id - Done
- reserve withdraw - Done
- reserve deposite - Done

 */