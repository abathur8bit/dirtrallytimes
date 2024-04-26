/* *****************************************************************************
 * Created by Lee Patterson 7/9/2021
 * Copyright 2021 Virtu-on, LLC <https://virtu-on.com>
 * ******************************************************************************/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:url_launcher/url_launcher.dart';
// import 'package:launch_review/launch_review.dart';
import "version.dart";

class AboutPage extends StatelessWidget {
  static const TITLE = "About";
  static const _urlSupport = 'https://axorion.com/support';
  static const _urlWebsite = 'https://axorion.com/dirtrallytimer';
  static const _urlTwitter = 'https://mobile.twitter.com/patterson7019';
  static const androidAppId = "com.axorion.dirtrallytimer";
  static const iosAppId = "666";

  @override
  Widget build(BuildContext context) {
    double largeFontSize = 80;
    double fontSize = 20;
    double minorFontSize = 15;
    double padding = 5;
    return Scaffold(
        appBar: AppBar(title: const Text(TITLE)),
        body:ListView(padding: EdgeInsets.all(20),
        children: [
          // Padding(padding:EdgeInsets.all(20),child:Image.asset("images/ppa-logo.png",width: 150,height: 150,)),
          Center(child:Text("Dirt Rally Track Time Tracker",style: TextStyle(fontSize: fontSize))),
          Center(child:Text("Version ${VERSION}",style: TextStyle(fontSize: minorFontSize))),
          Center(child:Text("",style: TextStyle(fontSize: minorFontSize))),
          Center(child:Text("An app by Lee Patterson",style: TextStyle(fontSize: minorFontSize))),
          Center(child:Text("",style: TextStyle(fontSize: minorFontSize))),
          Center(child:Text("",style: TextStyle(fontSize: minorFontSize))),
          Center(child:Text("",style: TextStyle(fontSize: minorFontSize))),
          ElevatedButton(onPressed: () {_launchUrl(_urlSupport);}, child: Text("Support")),
          Padding(padding:EdgeInsets.all(padding)),
          ElevatedButton(onPressed: () {_launchUrl(_urlWebsite);}, child: Text("Website")),
          // Padding(padding:EdgeInsets.all(padding)),
          // ElevatedButton(onPressed: () {_launchUrl(_urlTwitter);}, child: Text("Twitter")),
          // Padding(padding:EdgeInsets.all(padding)),
          // ElevatedButton(onPressed: () {    LaunchReview.launch(
          //     androidAppId: AboutTab.androidAppId,
          //     iOSAppId: AboutTab.iosAppId);
          // }, child: Text("Rate")),
          // Center(child:Text("",style: TextStyle(fontSize: minorFontSize))),
          // Center(child:Text("If you enjoyed the app, please consider rating the app. It really helps us developers!",textAlign: TextAlign.center,style: TextStyle(fontSize: minorFontSize))),
    ]));
  }

  void _launchUrl(String url) async {
    // await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }
}
