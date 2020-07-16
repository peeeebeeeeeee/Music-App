import 'package:components/Language%20Module/Auth%20Services.dart';
import 'OnBoarding Screen.dart';
import 'package:components/Language%20Module/Shared%20Preference%20Services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

class LoginScreen extends StatefulWidget {
  static const String id='Login Screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Preference method = new Preference();

  //formkey used for login method
  final formKey = new GlobalKey<FormState>();
  //variables used
  String phoneNo, verificationId, smsCode,countryCode;
  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: CountryCodePicker(
                    onChanged: (value){
                      countryCode=value.toString();
                    },
                    initialSelection: 'IN',
                    favorite: ['+91','IN'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                  ),
                  flex: 3,
                ),
                Flexible(
                  child: new TextFormField(
                    onChanged: (value){
                      phoneNo=value;
                    },
                    decoration: InputDecoration(hintText: "Enter Phone Number"),
                    textAlign: TextAlign.start,
                    autofocus: false,
                    enabled: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  flex: 10,
                ),
              ],
            ),
            codeSent
                ? Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: "Enter OTP"),
                      onChanged: (val) {
                        setState(() {
                          this.smsCode = val;
                        });
                      },
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: RaisedButton(
                  child: Center(
                      child:
                          codeSent ? Text("Login") : Text("Verify Your Phone")),
                  onPressed: () {
                    if (codeSent) {
                      AuthService().signInWithOTP(smsCode, verificationId);
                      Navigator.pushNamed(context, OnBoardingScreen.id);
                    } else {
                      verifyPhone(countryCode+phoneNo);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  //Firebase part

  Future<void> verifyPhone(phoneNo) async {
    //used for verification completed method of firebase
    final PhoneVerificationCompleted verified =
        (AuthCredential authResult) async {
      //here we store the value of logedIn user

      method.setLoginCompleted(true);

      AuthService().signIn(authResult);
    };

    //used for verificationFailed method of Firebase
    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print("${authException.message}");
    };

    //used for codeSent process of Firebase
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    //used for autoretrieval method of firebase
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    //Firebase method that contains all methods required for authentication
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: this.phoneNo,
      timeout: const Duration(seconds: 10),
      verificationCompleted: verified,
      verificationFailed: verificationfailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }
}


