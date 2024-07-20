import 'dart:convert';
import 'dart:io';

import 'package:elearn/generated/l10n.dart';
import 'package:elearn/screens/signup.dart';
import 'package:elearn/service/httpservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../consttants.dart';
import 'bottom_navigation.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController forget = TextEditingController();
  RxBool showPassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: comboBlackAndWhite(),
      body: Obx(() {
        inAsyncCall.value;
        return ModalProgressHUD(
          inAsyncCall: inAsyncCall.value,
          progressIndicator: CircularProgressIndicator(strokeWidth: 1.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.h, right: 10.w),
                    child: GestureDetector(
                      onTap: () async {
                        final sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setBool("guest", true);
                        getUserId();
                        Get.offAll(() {
                          return HomeScreen();
                        });
                      },
                      child: Text(
                        S.of(context).loginPage_SKIP,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Gilroy-Bold',
                          color: comboWhiteAndBlack(),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
                Padding(
                  padding: EdgeInsets.only(left: 15.0.w),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).loginPage_WELCOME,
                          style: TextStyle(
                            fontSize: 20.0.sp,
                            fontFamily: "Gilroy-Bold",
                            color: comboWhiteAndBlack(),
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                  height: 100.0.h,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFiled(
                      controller: emailController,
                      icon: 'assets/images/Vector.png',
                      obse: false,
                      hintText: S.of(context).loginPage_emailHint,
                    ),
                    Obx(() {
                      return CustomTextFiled(
                        controller: passwordController,
                        icon: 'assets/images/Group.png',
                        obse: showPassword.value,
                        hintText: S.of(context).loginPage_passwordHint,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            showPassword.value = !showPassword.value;
                          },
                          child: Icon(
                              showPassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: comboLightGreyAndGrey()),
                        ),
                      );
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 9.0.w),
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Dialog(
                                  insetPadding: EdgeInsets.all(10.r),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Spacer(flex: 2),
                                          Text(
                                            S
                                                .of(context)
                                                .loginPage_forgot_ENTER_YOUR_EMAIL,
                                            style: TextStyle(
                                                fontFamily: "Gilroy-SemiBold",
                                                fontSize: 15.sp),
                                          ),
                                          Spacer(),
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Icon(Icons.clear,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      CustomTextFiled(
                                        controller: forget,
                                        icon: 'assets/images/email.png',
                                        obse: false,
                                        hintText:
                                            S.of(context).loginPage_emailHint,
                                      ),
                                      SizedBox(height: 20.h),
                                      DialogButton(
                                        width: 173.w,
                                        height: 50.h,
                                        radius: BorderRadius.circular(14.r),
                                        color: Color(0xff000000),
                                        onPressed: () async {
                                          final String bASEURL =
                                              "$apiLink/user_forgot_pass_api.php?email=${forget.text}";
                                          var response = await http
                                              .get(Uri.parse(bASEURL));
                                          var data = jsonDecode(response.body);
                                          if (data["EBOOK_APP"][0]["success"] ==
                                              '1') {
                                            showToast(
                                                msg: data["EBOOK_APP"][0]
                                                    ["msg"]);
                                            Get.back();
                                          } else {
                                            showToast(
                                                msg: data["EBOOK_APP"][0]
                                                    ["msg"]);
                                          }
                                          forget.text = '';
                                          forget.clear();
                                        },
                                        child: Text(
                                          S
                                              .of(context)
                                              .loginPage_forgot_APPLY_button,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Gilroy-SemiBold",
                                              fontSize: 20.sp),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              S.of(context).loginPage_FORGOT_PASSWORD,
                              style: TextStyle(
                                fontFamily: "Gilroy-SemiBold",
                                color: Colors.black,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 40.h),

                ///Login Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      inAsyncCall.value;
                      return GestureDetector(
                        onTap: () async {
                          inAsyncCall.value = true;
                          await HttpService.getUserLogin(
                            context,
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 15.0.w),
                          height: 60.h,
                          width: 300.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0.r),
                              color: comboWhiteAndBlack()),
                          child: Text(
                            S.of(context).loginPage_LOGIN,
                            style: TextStyle(
                                fontSize: 20.0.sp,
                                color: comboBlackAndWhite(),
                                fontFamily: "Gilroy-Bold"),
                          ),
                        ),
                      );
                    }),
                  ],
                  //S.of(context).loginPage_LOGIN,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        S.of(context).loginPage_Create_New_Account,
                        style: TextStyle(
                            color: comboWhiteAndBlack(),
                            fontFamily: "Gilroy-Medium"),
                      ),
                      onPressed: () {
                        Get.to(() => SignUp());
                      },
                    )
                  ],
                ),
                SizedBox(height: 40.h),

                /// Apple , Facebook , Google
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /// Google Login
                    GestureDetector(
                      onTap: () {
                        inAsyncCall.value = true;
                        googleLogIn(context);
                      },
                      child: Container(
                        height: 40.h,
                        width: 40.w,
                        child: Image.asset("assets/images/google.png"),
                      ),
                    ),
                    SizedBox(width: 50.w),

                    /// Facebook Login
                    GestureDetector(
                      onTap: () {
                        inAsyncCall.value = true;
                        loginWithFacebook(context);
                      },
                      child: Container(
                        height: 40.h,
                        width: 40.w,
                        child: Image.asset("assets/images/facebook.png"),
                      ),
                    ),

                    /// Apple Login
                    if (Platform.isIOS) SizedBox(width: 50.w),

                    if (Platform.isIOS)
                      GestureDetector(
                        onTap: () async {
                          inAsyncCall.value = true;
                          await appleLoginApi();
                        },
                        child: Container(
                          height: 40.h,
                          width: 40.w,
                          child: Image.asset(
                            "assets/images/apple_logo.png",
                            color: comboWhiteAndBlack(),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: comboBlackAndWhite(),
                            insetPadding: EdgeInsets.all(10.r),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Spacer(),
                                    Text(
                                      S.of(context).setting_PRIVACY_POLICY,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy-SemiBold',
                                          fontSize: 20.sp,
                                          color: comboWhiteAndBlack()),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: comboWhiteAndBlack(),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.r),
                                    child: Text(
                                      htmlString(html: privacypolicy!),
                                      style: TextStyle(
                                        fontFamily: 'Gilroy-SemiBold',
                                        fontSize: 15.sp,
                                        color: comboWhiteAndBlack(),
                                      ),
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Text(S.of(context).setting_PRIVACY_POLICY,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: comboWhiteAndBlack(),
                              fontFamily: "Gilroy-Medium")),
                    ),
                    // can add more TextSpans here...
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class CustomTextFiled extends StatelessWidget {
  const CustomTextFiled({
    required this.hintText,
    this.labelText,
    this.icon,
    this.obse,
    this.suffixIcon,
    this.readOnly,
    required this.controller,
  });

  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final String? icon;
  final bool? obse;
  final Widget? suffixIcon;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 15.w),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'empty';
          }
          return null;
        },
        controller: controller,
        autofocus: false,
        obscureText: obse ?? false,
        readOnly: readOnly ?? false,
        cursorColor: comboWhiteAndBlack(),
        decoration: new InputDecoration(
          hintText: hintText,
          labelText: labelText,
          isDense: true,
          suffixIcon: suffixIcon,
          prefixIcon: Padding(
            padding: EdgeInsets.all(15.r),
            child: Image.asset(icon!,
                height: 10.w, width: 10.w, color: comboLightGreyAndGrey()),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
          hintStyle: TextStyle(
            color: comboLightGreyAndGrey(),
            fontFamily: "Gilroy-SemiBold",
          ),
          fillColor: comboBlackAndWhite(),
          focusedBorder: OutlineInputBorder(
            gapPadding: 5,
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(color: comboWhiteAndBlack(), width: 0.8.w),
          ),
          border: OutlineInputBorder(
            gapPadding: 5,
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(color: comboWhiteAndBlack(), width: 0.5.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(color: comboWhiteAndBlack(), width: 0.5.w),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(color: comboWhiteAndBlack(), width: 0.5.w),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontFamily: "Gilroy-SemiBold",
          color: comboWhiteAndBlack(),
          fontSize: 16.sp,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

///Google Login
Future<void> googleLogIn(context) async {
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  if (googleSignInAccount == null) {
    inAsyncCall.value = false;
  }
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await FirebaseAuth.instance.signInWithCredential(credential);
  final User? user = authResult.user;

  if (user != null) {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String baseUrl =
        "$apiLink/user_register_api.php?user_image=${user.photoURL}&name=${user.displayName}&email=${user.email}&password="
        "&phone="
        "&auth_id=${googleSignInAuthentication.accessToken}&type=Google";
    final response = await http.get(Uri.parse(baseUrl));
    final data = jsonDecode(response.body);
    if (data['EBOOK_APP'][0]['success'] == '1') {
      pref.setString('userId', data["EBOOK_APP"][0]["user_id"]);
      showToast(msg: data['EBOOK_APP'][0]['MSG']);
      getUserId();
      inAsyncCall.value = false;
      Get.offAll(() => HomeScreen());
    } else {
      showToast(msg: data['EBOOK_APP'][0]['MSG']);
      if (data['EBOOK_APP'][0]['MSG'] == "Sorry ! Your account is deleted" ||
          data['EBOOK_APP'][0]['MSG']
              .toString()
              .contains('Sorry ! Your account is deleted')) {
        await googleSignIn.signOut();
      }
      inAsyncCall.value = false;
    }
  } else {
    inAsyncCall.value = false;
  }
}

/// Facebook Login
Future<void> loginWithFacebook(context) async {
  try {
    FirebaseAuth _auth = FirebaseAuth.instance;
    SharedPreferences pref = await SharedPreferences.getInstance();
    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']).onError(
            (error, stackTrace) async {
      print('error ========> $error');
      print('stackTrace ==========> $stackTrace');
      return Future.error(stackTrace);
    });
    switch (result.status) {
      case LoginStatus.success:
        try {
          final OAuthCredential credential =
              FacebookAuthProvider.credential(result.accessToken!.tokenString);
          final UserCredential authResult =
              await _auth.signInWithCredential(credential);
          final User? _user = authResult.user;

          if (_user != null) {
            final String bBASEURL =
                "$apiLink/user_register_api.php?user_image=${_user.photoURL}&name=${_user.displayName}&email=${_user.email}&password="
                "&phone="
                "&auth_id=${credential.accessToken}&type=Facebook";
            final response = await http.get(Uri.parse(bBASEURL));
            final data = jsonDecode(response.body);
            if (data["EBOOK_APP"][0]["success"] == '1') {
              pref.setString('userId', data["EBOOK_APP"][0]["user_id"]);
              getUserId();
              showToast(msg: data["EBOOK_APP"][0]["MSG"]);
              inAsyncCall.value = false;
              Get.offAll(() => HomeScreen());
            } else {
              showToast(msg: data["EBOOK_APP"][0]["MSG"]);
              inAsyncCall.value = false;
            }
          } else {
            inAsyncCall.value = false;
          }
        } on FirebaseAuthException catch (e) {
          showToast(msg: "${e.message}");
          inAsyncCall.value = false;
        }
        break;
      case LoginStatus.cancelled:
        inAsyncCall.value = false;
        break;
      case LoginStatus.failed:
        inAsyncCall.value = false;
        break;
      case LoginStatus.operationInProgress:
        inAsyncCall.value = false;
        break;
    }
  } catch (e) {
    inAsyncCall.value = false;
    print('ERROR IN FACEBOOK $e');
  }
}

///Apple login
Future<void> appleLoginApi() async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    inAsyncCall.value = true;
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ],
    );

    final oAuthProvider = OAuthProvider('apple.com');
    final firebaseauth = oAuthProvider.credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );
    UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(firebaseauth);
    final firebaseUser = authResult.user;

    String? appleEmail = firebaseUser!.email;
    String appleName = firebaseUser.displayName ?? appleEmail!.split('@').first;
    String authId = firebaseUser.uid;

    final String bBASEURL =
        "$apiLink/user_register_api.php?name=$appleName&email=${appleEmail ?? ''}&password=&phone=&auth_id=$authId&type=Apple";
    final response = await http.get(Uri.parse(bBASEURL));
    final jsonResponse = jsonDecode(response.body);
    final second = jsonResponse["EBOOK_APP"][0];
    if (second['success'] == '1') {
      pref.setString('userId', second["user_id"]);
      inAsyncCall.value = false;
      pref.setString("type", "APPLE");
      showToast(msg: second["MSG"]);
      getUserId();
      Get.offAll(() => HomeScreen());
    } else {
      showToast(msg: second["MSG"]);
      inAsyncCall.value = false;
    }
  } on SignInWithAppleAuthorizationException catch (e) {
    inAsyncCall.value = false;
    print('FirebaseAuthException ==== error $e');
    showToast(msg: "Apple ${e.message}");
  }
}
