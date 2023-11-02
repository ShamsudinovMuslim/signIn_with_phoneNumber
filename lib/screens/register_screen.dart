import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_zadanie/provider/auth_provider.dart';
import 'package:phone_zadanie/screens/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();
  Country selectedCountry = Country(
      phoneCode: '996',
      countryCode: "KG",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'Kyrgyzstan',
      example: 'Kyrgyzstan',
      displayName: 'Kyrgyzstan',
      displayNameNoCountryCode: 'KG',
      e164Key: "");
  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: phoneController.text.length));
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent.shade100),
                  // padding: const EdgeInsetsDirectional.all(20.0),
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/images/hh.png')),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Register",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Add your phone number.We\'ll send you a verification  code',
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  TextFormField(
                      onChanged: (value) {
                        setState(() {
                          phoneController.text = value;
                        });
                      },
                      keyboardType: TextInputType.number,
                      cursorColor: const Color.fromARGB(255, 15, 76, 126),
                      controller: phoneController,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          hintText: 'Enter your phone number',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.grey.shade600),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black12)),
                          prefixIcon: Container(
                              padding: const EdgeInsetsDirectional.all(11.0),
                              child: InkWell(
                                  onTap: () {
                                    showCountryPicker(
                                      context: context,
                                      countryListTheme: CountryListThemeData(
                                        inputDecoration: InputDecoration(
                                            labelText: "Search",
                                            hintText: 'Start typing to search',
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: const Color(0xFF8C98A8)
                                                      .withOpacity(0.2),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(30))),
                                        bottomSheetHeight: 500,
                                      ),
                                      onSelect: (Country value) {
                                        setState(() {
                                          selectedCountry = value;
                                        });
                                      },
                                    );
                                  },
                                  child: Text(
                                    '${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          suffixIcon: phoneController.text.length > 8
                              ? Icon(
                                  Icons.done,
                                  color: Colors.blue,
                                  size: 25,
                                )
                              : null)),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                        text: 'Login', onPressed: () => sendPhoneNumber()),
                  )
                ],
              )
            ],
          )),
    )));
  }

  void sendPhoneNumber() {
    // +9961234567890
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
  }
}
