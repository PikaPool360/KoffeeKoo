import 'package:koffeeko/screens/authenticate/admin.dart';
import 'package:koffeeko/screens/home/brew_list.dart';
import 'package:koffeeko/screens/home/settings_form.dart';
import 'package:koffeeko/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:koffeeko/services/database.dart';
import 'package:provider/provider.dart';
import 'package:koffeeko/models/brew.dart';

class SharedHome extends StatelessWidget {
  SharedHome({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: const SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService(uid: "ihW0982y2aToOChku0i0FmvX6Eu1").brews,
      initialData: const [],
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: const Text('KoffeeKo'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              onPressed: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Admin())),
              icon: const Icon(Icons.logout, color: Colors.blue, size: 27.0),
              label: const Text('Logout',
                  style: TextStyle(color: Colors.blue, fontSize: 18.0)),
            ),
          ],
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/coffee_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: const BrewList()),
      ),
    );
  }
}
