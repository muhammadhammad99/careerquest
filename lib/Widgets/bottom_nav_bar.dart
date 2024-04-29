import 'package:career_quest/Jobs/job_screen.dart';
import 'package:career_quest/Jobs/upload_job.dart';
import 'package:career_quest/LoginPage/login_screen.dart';
import 'package:career_quest/Persistent/persistent.dart';
import 'package:career_quest/Search/profile_company.dart';
import 'package:career_quest/Search/search_companies.dart';
import 'package:career_quest/Services/api.dart';
import 'package:career_quest/Services/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavigationBarForApp extends StatefulWidget {
  final int indexNum;

  const BottomNavigationBarForApp({super.key, required this.indexNum});

  @override
  State<BottomNavigationBarForApp> createState() =>
      _BottomNavigationBarForApp();
}

class _BottomNavigationBarForApp extends State<BottomNavigationBarForApp> {
  @override
  void initState() {
    super.initState();
    Persistent persistent = Persistent();
    persistent.getMyData();
  }

  void _logout(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                ),
              ],
            ),
            content: const Text(
              'Do you want to Log Out?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  ApiManager.logout().then((value) {
                    if (value.contains("User logged out")) {
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => login()));
                    }
                  }).catchError((err) {
                    throw Exception(err.toString());
                  });
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      const Icon(
        Icons.list,
        size: 19,
        color: Colors.black,
      ),
      const Icon(
        Icons.search,
        size: 19,
        color: Colors.black,
      ),
      const Icon(
        Icons.add,
        size: 19,
        color: Colors.black,
      ),
      const Icon(
        Icons.person_pin,
        size: 19,
        color: Colors.black,
      ),
      const Icon(
        Icons.exit_to_app,
        size: 19,
        color: Colors.black,
      )
    ];
    return uid != null
        ? CurvedNavigationBar(
            index: widget.indexNum,
            items: items,
            color: Colors.deepOrange.shade400,
            backgroundColor: Colors.blueAccent,
            buttonBackgroundColor: Colors.deepOrange.shade300,
            animationCurve: Curves.bounceInOut,
            animationDuration: const Duration(microseconds: 300),
            height: 50,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const JobScreen()));
              } else if (index == 1) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => AllWorkersScreen()));
              } else if (index == 2) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const UploadJobNow()));
              } else if (index == 3) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                              userID: uid!,
                            )));
              } else if (index == 4) {
                _logout(context);
              }
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
