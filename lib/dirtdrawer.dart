import "package:dirtrallytimer/database.dart";
import 'package:flutter/material.dart';
import "database.dart";
import "home_page.dart";
import "tracks_page.dart";
import "about_page.dart";

class DirtDrawer {
  static Drawer create(BuildContext context,DirtDatabase db) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(8),
        children: [
          // DrawerHeader(
          //   decoration: BoxDecoration(color: Colors.blue),
          //   child: Padding(
          //     padding: const EdgeInsets.only(bottom: 20),
          //     child: Image.asset('images/ppa-logo.png'),
          //   ),
          // ),
          Padding(padding: const EdgeInsets.only(top:50)),
          ListTile(leading: const Icon(Icons.timer),title: const Text("Times"), onTap: () => show(context,HomePage())),
          ListTile(leading: const Icon(Icons.map_outlined),title: const Text("Tracks"), onTap: () => show(context,TracksPage(db:db))),
          ListTile(leading: const Icon(Icons.time_to_leave),title: const Text("Cars"), onTap: () => show(context,AboutPage())),
          ListTile(leading: const Icon(Icons.contact_support),title: const Text('About'),onTap: () => show(context,AboutPage())),
        ],
      ),
    );
  }

  static void show(BuildContext context,Widget tab) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => tab),
    );
  }
}