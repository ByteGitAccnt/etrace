import 'package:etrace/Pages/AddExpensePage.dart';
import 'package:etrace/Pages/AddIncomePage.dart';
import 'package:etrace/Pages/AddReservePage.dart';
import 'package:etrace/Pages/HomeContent.dart';
import 'package:etrace/Pages/ReportPage.dart';
import 'package:etrace/Pages/ReservePage.dart';
import 'package:flutter/material.dart';
import 'package:etrace/Pages/ExpensePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.emerald, super.key});

  final Color lightCard = const Color(0xFFE8F5E9);
  final Color emerald;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  Widget _getPage(int index) {
    // avoiod building all pages at once/ initialy
    switch (index) {
      case 0:
        return HomeContent();
      case 1:
        return ExpensePage();
      case 2:
        return ReservePage();
      case 3:
        return Reportpage();
      default:
        return HomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.emerald,
      //App Bar
      appBar: AppBar(
        backgroundColor: widget.emerald,
        elevation: 2,
        centerTitle: true,

        // LEFT: Logout button (replaces back button)
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.logout),
              color: Colors.white,
              onPressed: () {
                // TODO: logout logic
              },
            ),
          ),
        ),

        // 🔹 TITLE
        title: const Text(
          "ETrace",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),

        iconTheme: const IconThemeData(color: Colors.white),

        // RIGHT: Notification button
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_none),
                color: Colors.white,
                onPressed: () {
                  // TODO: open notifications
                },
              ),
            ),
          ),
        ],
      ),

      //  Body
      body: _getPage(_currentIndex), // 👈 show current page,
      //  Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // 👈 IMPORTANT
        selectedItemColor: widget.emerald,
        unselectedItemColor: Colors.grey,

        //  show all labels
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: "Expenses",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.savings), label: "Reserve"),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Reports",
          ),
        ],

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // 🔹 Navigation placeholders -neeed while apoi call
          switch (index) {
            case 0:
              print("Home");
              break;
            case 1:
              print("Expenses");
              break;
            case 2:
              print("Reserve");
              break;
            case 3:
              print("No Reports currently!");
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Color(0xFF046A38)),
        onPressed: () {
          _showAddOptions(context);
        },
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _optionTile(
                icon: Icons.arrow_downward,
                color: Colors.red,
                label: "Add Expense",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context, // ✅ parent context (safe)
                    MaterialPageRoute(
                      builder: (_) => AddExpensePage(emerald: widget.emerald),
                    ),
                  );
                },
              ),
              _optionTile(
                icon: Icons.arrow_upward,
                color: Colors.green,
                label: "Add Income",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context, // ✅ parent context (safe)
                    MaterialPageRoute(
                      builder: (_) => AddIncomePage(emerald: widget.emerald),
                    ),
                  );
                },
              ),
              _optionTile(
                icon: Icons.savings,
                color: Colors.blue,
                label: "Add Reserve",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context, // ✅ parent context (safe)
                    MaterialPageRoute(
                      builder: (_) => AddReservePage(emerald: widget.emerald),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _optionTile({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(label),
      onTap: onTap,
    );
  }
}
