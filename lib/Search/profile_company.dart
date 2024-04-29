import 'package:career_quest/Persistent/persistent.dart';
import 'package:career_quest/Services/api.dart';
import 'package:career_quest/Services/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  final String userID;

  const ProfileScreen({super.key, required this.userID});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String email = '';
  String phoneNumber = '';
  String? pic;
  String location = "";
  bool _isLoading = false;
  bool _isSameUser = false;

  void getUserData() async {
    try {
      _isLoading = true;
      ApiManager.getUserDetail(widget.userID).then((user) {
        setState(() {
          name = user.name;
          email = user.email;
          phoneNumber = user.phoneNumber;
          pic = user.pic;
          // Timestamp joinedAtTimeStamp = user.get('createdAt');
          // var joinedDate = joinedAtTimeStamp.toDate();
          // joinedAt = '${joinedDate.year} - ${joinedDate.month} - ${joinedDate.day}';
        });
      }).catchError((err) {
        throw Exception(err.toString());
      });

      setState(() {
        _isSameUser = uid == widget.userID;
      });
    } catch (error) {
      throw Exception(error.toString());
    } finally {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    Persistent persistent = Persistent();
    persistent.getMyData();
    getUserData();
  }

  Widget userInfo({required IconData icon, required String content}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: const TextStyle(color: Colors.white54),
          ),
        ),
      ],
    );
  }

  Widget _contactBy(
      {required Color color, required Function fct, required IconData icon}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(
            icon,
            color: color,
          ),
          onPressed: () {
            fct();
          },
        ),
      ),
    );
  }

  void _openWhatsAppChat() async {
    var url = 'https://wa.me/$phoneNumber?text=HelloWorld';
    launchUrlString(url);
  }

  void _mailTo() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query:
          'subject=Write subject here, Please&body=Hello, please write details here',
    );
    final url = params.toString();
    launchUrlString(url);
  }

  void _callPhoneNumber() async {
    var url = 'tel://$phoneNumber';
    launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade300, Colors.blueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: const BottomNavigationBarForApp(
          indexNum: 3,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Stack(
                      children: [
                        Card(
                          color: Colors.white10,
                          margin: const EdgeInsets.all(30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 100),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    name == null ? 'Name here' : name!,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 24.0),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Account Information :',
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 22.0),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: userInfo(
                                      icon: Icons.email, content: email),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: userInfo(
                                      icon: Icons.phone, content: phoneNumber),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                                _isSameUser
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          _contactBy(
                                            color: Colors.green,
                                            fct: () {
                                              _openWhatsAppChat();
                                            },
                                            icon: FontAwesome.whatsapp,
                                          ),
                                          _contactBy(
                                            color: Colors.red,
                                            fct: () {
                                              _mailTo();
                                            },
                                            icon: Icons.mail_outline,
                                          ),
                                          _contactBy(
                                            color: Colors.purple,
                                            fct: () {
                                              _callPhoneNumber();
                                            },
                                            icon: Icons.call,
                                          ),
                                        ],
                                      ),
                                const SizedBox(
                                  height: 25,
                                ),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.26,
                              height: size.width * 0.26,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 8,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      pic ??
                                          'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png',
                                    ),
                                    fit: BoxFit.fill,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
