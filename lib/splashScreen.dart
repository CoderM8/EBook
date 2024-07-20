import 'package:elearn/consttants.dart';
import 'package:elearn/screens/bottom_navigation.dart';
import 'package:elearn/screens/login.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    dynamicLinkInit();
    loadData().whenComplete(() {
      Future.delayed(Duration(seconds: 2), () {
        if (initialLink == null) {
          Get.offAll(
            () {
              if (userId == null) {
                if (guest == false) {
                  return Login();
                } else {
                  return HomeScreen();
                }
              } else {
                return HomeScreen();
              }
            },
          );
        } else {
          initDynamicLinks(context);
        }
      });
    });

    super.initState();
  }

  Future<void> loadData() async {
    initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  }

  PendingDynamicLinkData? initialLink;

  /// when Application in background
  dynamicLinkInit() {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      switch (dynamicLinkData.link.path) {
        case "/Author":
          {
            Get.offAll(
              () {
                if (userId == null) {
                  if (guest == false) {
                    return Login();
                  } else {
                    return HomeScreen();
                  }
                } else {
                  return HomeScreen();
                }
              },
            );
          }
          break;
        case "/AudioBook":
          {
            Get.offAll(
              () {
                if (userId == null) {
                  if (guest == false) {
                    return Login();
                  } else {
                    return HomeScreen();
                  }
                } else {
                  return HomeScreen();
                }
              },
            );
          }
          break;
        default:
          {}
      }
    });
  }

  /// when app kill
  initDynamicLinks(BuildContext context) async {
    var deepLink = initialLink!.link;
    loadData().then((sdf) {
      switch (deepLink.path) {
        case "/Author":
          {
            Get.offAll(
              () {
                if (userId == null) {
                  if (guest == false) {
                    return Login();
                  } else {
                    return HomeScreen();
                  }
                } else {
                  return HomeScreen();
                }
              },
            );
          }
          break;
        case "/AudioBook":
          {
            Get.offAll(
              () {
                if (userId == null) {
                  if (guest == false) {
                    return Login();
                  } else {
                    return HomeScreen();
                  }
                } else {
                  return HomeScreen();
                }
              },
            );
          }
          break;
        default:
          {
            Get.offAll(
              () {
                if (userId == null) {
                  if (guest == false) {
                    return Login();
                  } else {
                    return HomeScreen();
                  }
                } else {
                  return HomeScreen();
                }
              },
            );
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/1234.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
