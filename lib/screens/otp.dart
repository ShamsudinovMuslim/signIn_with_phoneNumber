import 'package:flutter/material.dart';
import 'package:phone_zadanie/provider/auth_provider.dart';
import 'package:phone_zadanie/screens/home_screen.dart';
import 'package:phone_zadanie/screens/user_information_screen.dart';
import 'package:phone_zadanie/screens/widgets/custom_button.dart';
import 'package:phone_zadanie/utils/utils.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                )
              : SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 35),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(Icons.arrow_back),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueAccent.shade100),
                              // padding: const EdgeInsetsDirectional.all(20.0),
                              height: 200,
                              width: 200,
                              child: Image.asset('assets/images/flutter.png')),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Verification",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Enter the OTP send to your phone number',
                            style: TextStyle(
                                color: Colors.black38,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Pinput(
                            length: 6,
                            showCursor: true,
                            defaultPinTheme: PinTheme(
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.blue))),
                            onCompleted: (value) {
                              setState(() {
                                otpCode = value;
                              });
                              print(otpCode);
                            },
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: CustomButton(
                                text: 'Verify',
                                onPressed: () {
                                  if (otpCode != null) {
                                    verifyOtp(context, otpCode!);
                                  } else {
                                    showSnackBar(context, 'Enter 6-Digit code');
                                  }
                                }),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Didn\'t receive any code?',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'Resend New Code',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }

  void verifyOtp(BuildContext context, String userOtp) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
        verificationId: widget.verificationId,
        context: context,
        userOtp: userOtp,
        onSuccess: () {
          // cheking whether user exists in the db
          ap.checkExistingUser().then((value) async {
            if (value == true) {
              // user exists in our app
              ap.getDataFromSP().then((value) => ap.saveUserDataToSP().then(
                  (value) => ap.setSignIn().then((value) =>
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false))));
            } else {
              // new users
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserInformationScreen()),
                  (route) => false);
            }
          });
        });
  }
}
