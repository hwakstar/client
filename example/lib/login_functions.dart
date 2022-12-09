import 'package:animated_login/animated_login.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dialog_builders.dart';
import 'package:http/http.dart' as http;

class LoginFunctions {
  /// Collection of functions will be performed on login/signup.
  /// * e.g. [onLogin], [onSignup], [socialLogin], and [onForgotPassword]
  const LoginFunctions(this.context);
  final BuildContext context;

  /// Login action that will be performed on click to action button in login mode.
  Future<String?> onLogin(LoginData loginData) async {
    String apiurl = "http://192.168.121.18/test/login.php";
    var response = await http.post(Uri.parse(apiurl), body: {
      'email': loginData.email, //get the email text
      'password': loginData.password //get password text
    });
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      if (jsondata["error"]) {
        //  setState(() {
        //      showprogress = false; //don't show progress indicator
        //      error = true;
        //      errormsg = jsondata["message"];
        //  });
        DialogBuilder(context).showResultDialog(jsondata["message"]);
      } else {
        if (jsondata["success"]) {
          //  setState(() {
          //     error = false;
          //     showprogress = false;
          //  });
          //save the data returned from server
          //and navigate to home page
          //  String uid = jsondata["uid"];
          //  String fullname = jsondata["fullname"];
          //  String address = jsondata["address"];
          DialogBuilder(context).showResultDialog(jsondata["message"]);
          Future.delayed(const Duration(seconds: 5));
          //user shared preference to save data
        } else {
          //  showprogress = false; //don't show progress indicator
          //  error = true;
          //  errormsg = "Something went wrong.";
        }
      }
    } else {
      // setState(() {
      //    showprogress = false; //don't show progress indicator
      //    error = true;
      //    errormsg = "Error during connecting to server.";
      // });
    }

    //await Future.delayed(const Duration(seconds: 2));
    return null;
  }

  /// Sign up action that will be performed on click to action button in sign up mode.
  Future<String?> onSignup(SignUpData signupData) async {
    if (signupData.password != signupData.confirmPassword) {
      DialogBuilder(context).showResultDialog(
          'The passwords you entered do not match, check again.');
    } else {
      String apiurl = "http://192.168.121.18/test/login.php";
      var response = await http.post(Uri.parse(apiurl), body: {
        'email': signupData.email, //get the email text
        'password': signupData.password, //get password text
        'username': signupData.name //get username
      });
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["error"]) {
          DialogBuilder(context).showResultDialog(jsondata["message"]);
        } else {
          if (jsondata["success"]) {
            DialogBuilder(context).showResultDialog(jsondata["message"]);
          }
        }
      }
    }
    // await Future.delayed(const Duration(seconds: 2));

    return null;
  }

  /// Social login callback example.
  Future<String?> socialLogin(String type) async {
    await Future.delayed(const Duration(seconds: 2));
    return null;
  }

  /// Action that will be performed on click to "Forgot Password?" text/CTA.
  /// Probably you will navigate user to a page to create a new password after the verification.
  Future<String?> onForgotPassword(String email) async {
    DialogBuilder(context).showLoadingDialog();
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed('/forgotPass');
    return null;
  }
}
