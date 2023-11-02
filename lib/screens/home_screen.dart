import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_zadanie/provider/auth_provider.dart';
import 'package:phone_zadanie/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Flutter Phone Auth '),
          actions: [
            IconButton(
                onPressed: () async {
                  ap.userSignOut().then(
                        (value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()),
                        ),
                      );
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(ap.userModel.profilePic),
                radius: 50,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(ap.userModel.name),
              Text(ap.userModel.phoneNumber),
              Text(ap.userModel.email),
              Text(ap.userModel.bio),
            ],
          ),
        ));
  }
}
