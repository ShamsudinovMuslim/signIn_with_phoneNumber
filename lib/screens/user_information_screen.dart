import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phone_zadanie/model/user_model.dart';
import 'package:phone_zadanie/provider/auth_provider.dart';
import 'package:phone_zadanie/screens/home_screen.dart';
import 'package:phone_zadanie/utils/utils.dart';
import 'package:provider/provider.dart';

import 'widgets/custom_button.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  File? image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }

  // for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
              child: Center(
                  child: Column(
                children: [
                  GestureDetector(
                    onTap: () => selectImage(),
                    child: image == null
                        ? CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.grey.shade600,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 90,
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(image!),
                            radius: 50,
                          ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    margin: const EdgeInsetsDirectional.only(top: 20),
                    child: Column(
                      children: [
                        textField(
                            hinText: 'Shamsudinov Muslim',
                            icon: Icons.person,
                            inputType: TextInputType.name,
                            maxLines: 1,
                            controller: nameController),
                        SizedBox(
                          height: 25,
                        ),
                        textField(
                            hinText: 'absd@gmail.com',
                            icon: Icons.email,
                            inputType: TextInputType.emailAddress,
                            maxLines: 1,
                            controller: emailController),
                        SizedBox(
                          height: 25,
                        ),
                        textField(
                            hinText: 'Enter your bio here...',
                            icon: Icons.edit,
                            inputType: TextInputType.name,
                            maxLines: 2,
                            controller: bioController)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: CustomButton(
                        onPressed: () => storedata(),
                        text: 'Continue',
                      ))
                ],
              )),
            )),
    );
  }

  Widget textField(
      {required String hinText,
      required IconData icon,
      required TextInputType inputType,
      required int maxLines,
      required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.blue,
        keyboardType: inputType,
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
            prefixIcon: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.blue),
              child: Icon(
                icon,
                size: 20,
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.transparent)),
            hintText: hinText,
            alignLabelWithHint: true,
            border: InputBorder.none,
            fillColor: Colors.blue.shade50,
            filled: true),
      ),
    );
  }

  // store user data  to database
  void storedata() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        bio: bioController.text.trim(),
        profilePic: "",
        createdAt: "",
        phoneNumber: "",
        uid: "");
    if (image != null) {
      ap.saveUserDataToFirebase(
          context: context,
          userModel: userModel,
          profilePic: image!,
          onSuccess: () {
            ap.saveUserDataToSP().then(
                  (value) => ap.setSignIn().then((value) =>
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false)),
                );
          });
    } else {
      showSnackBar(context, "Please upload your profile photo");
    }
  }
}
