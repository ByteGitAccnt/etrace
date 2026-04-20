import 'package:etrace/Api/TokenManager.dart';
import 'package:etrace/Pages/ExpensePage.dart';
import 'package:etrace/Pages/HomePage.dart';
import 'package:etrace/Pages/LoginPage.dart';
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
    const Color emerald = Color(0xFF046A38);
    return MaterialApp(
      initialRoute: '/login', // 👈 start here
      onGenerateRoute: (settings) {
        late Widget page;
        switch (settings.name) {
          case '/login':
            page = LoginPage(emerald: emerald);
            break;
          case '/register':
            page = Registerpage(emerald: emerald);
            break;
          case '/home':
            page = HomePage(emerald: emerald);
            break;
          case '/searchResults':
            page = ExpensePage();
            break;
          default:
            page = HomePage(emerald: emerald);
        }

        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(
            milliseconds: 250,
          ), // 👈 shorter = faster
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
- logout and token managment - partial , need a seperate for logout in apiclient , chatgpt/chatname: refractoring expense tracker 
TESTING:
- login - Done
- register - Done
- home page - Done
- balance fetching - pending 
- reserve fetching  - pending
- category fetching - pending 
- exense serach and fetch with offset and paging and without offset and paging - pending
- Expense add - pending
- Reserve add - pending
- income add - pending
- deletion logic - pending
- Category fetching for id - pending
- reserve withdraw - pending
- reserve deposite - pending
 */