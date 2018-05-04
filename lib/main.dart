import 'package:flutter/material.dart';
import 'package:f1utter/pages/countdown_page.dart';
import 'package:f1utter/pages/standings_page.dart';
import 'package:f1utter/pages/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:f1utter/persistent_state.dart';

void main() => runApp(new F1utter());

class F1utter extends StatefulWidget{
  F1utter({Key key});
  
  @override
  _F1utterState createState() {
    SharedPreferences.getInstance().then((prefs) {
      var br = prefs.getString("brightness");
      GlobalData.updateTheme(br == "Brightness.dark" ? Brightness.dark : Brightness.light);
    });
    return new _F1utterState();
  }
}

class _F1utterState extends State<F1utter> {
  Brightness brightness;
  Color accent;
  Color primarySwatch;
  int currentTab = 0;

  CountdownPage countdownPage = new CountdownPage();
  StandingsPage standingsPage = new StandingsPage();
  SettingsPage settingsPage = new SettingsPage();

  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    super.initState();
    GlobalData.appBrightness.addListener(_themeUpdated);
    _themeUpdated();
    pages = [countdownPage, standingsPage, settingsPage];
    currentPage = countdownPage;
  }

  _themeUpdated() {
    _saveUserTheme();
    setState(() {
      this.brightness = GlobalData.appBrightness.value;
      this.accent = GlobalData.accent;
      this.primarySwatch = GlobalData.primarySwatch;
    });
  }

  _saveUserTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("brightness", this.brightness.toString());
  }
  
  _tabTapped(int tappedTab) {
    setState(() {
      currentTab = tappedTab;
      currentPage = this.pages[tappedTab];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'F1utter',
      home: new MaterialApp(
        theme: new ThemeData( 
          primarySwatch: this.primarySwatch,
          accentColor: this.accent,
          brightness: this.brightness,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text("F1utter"),
          ),
          bottomNavigationBar: new BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentTab,
            onTap: this._tabTapped,
            items: <BottomNavigationBarItem>[
              new BottomNavigationBarItem( // tab 0
                icon: new Icon(Icons.timer),
                title: new Text("Schedule"),
              ),
              new BottomNavigationBarItem( // tab 1
                icon: new Icon(Icons.equalizer),
                title: new Text("Drivers"),
              ),
              new BottomNavigationBarItem( // tab 2
                icon: new Icon(Icons.settings),
                title: new Text("Settings"),
              ),
            ],
          ),
          body: this.currentPage,
        ),
      )
    );
  }
}

