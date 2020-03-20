import 'package:flutter/material.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/views/my_profile.dart';
import 'package:mobile_app/views/weekly_menu.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/providers/auth.dart';
import 'package:mobile_app/utils/slide_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/globals/globals.dart' as globals;

enum DrawerSelection { daily, weekly, profile}

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {

  DrawerSelection _drawerSelection = DrawerSelection.daily;

  @override
  Widget build(BuildContext context) {

    Future<String> _getUserImage() async{
      final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      return sharedPrefs.getString('img');
    }

    Future<String> _getUserName() async{
      final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      return sharedPrefs.getString('name');
    }

    return  Drawer(
        child: Container(color: Colors.black87,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 12.0),
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(50.0),
                          child: FutureBuilder<String>(
                              future: _getUserImage(),
                              initialData: '${globals.backendUrl}/img/users/DefaultUserImage.png',
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                return snapshot.hasData ?
                                Image.network(snapshot.data != 'NO_IMAGE_SET' ? snapshot.data : '${globals.backendUrl}/img/users/DefaultUserImage.png', width: 75, height: 75) :
                                CircularProgressIndicator();
                              }
                            ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                        child: FutureBuilder<String>(
                            future: _getUserName(),
                            initialData: 'Name',
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                              return snapshot.hasData ?
                              Text(snapshot.data, style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500)) :
                              CircularProgressIndicator();
                            }
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: new Container(
                                    child: Divider(
                                      color: Colors.white,
                                      height: 36,
                                    )),
                              )],
                          )
                      ),
                    ],
                  )),
              ListTile(
                leading: Icon(Icons.restaurant_menu, color: Colors.grey),
                title: Text('Daily Menu', style: TextStyle(color: Colors.grey)),
                  selected: _drawerSelection == DrawerSelection.daily,
                onTap: () {
                  _drawerSelection = DrawerSelection.daily;
                  Navigator.push(context, SlideRoute(page: Router(), from: 1.0));
                }
              ),
              ListTile(
                leading: Icon(Icons.menu, color: _drawerSelection== DrawerSelection.weekly ? Colors.orangeAccent:Colors.grey),
                title: Text('Weekly Menu', style: TextStyle(color: Colors.grey)),
                selected:  _drawerSelection == DrawerSelection.weekly,
                onTap: () {
                    _drawerSelection = DrawerSelection.weekly;
                    Navigator.push(context, SlideRoute(page: WeeklyMenu(), from: 1.0));
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle, color: Colors.grey),
                title: Text('My Profile', style: TextStyle(color: Colors.grey)),
                selected: _drawerSelection == DrawerSelection.profile,
                onTap: () {
                  _drawerSelection = DrawerSelection.profile;
                  Navigator.push(context, SlideRoute(page: MyProfile(), from: 1.0));
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.grey),
                title: Text('Logout', style: TextStyle(color: Colors.grey)),
                onTap: () {
                  Navigator.pop(context);
                  Provider.of<AuthProvider>(context, listen: false).logOut();
                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                },
              ),
            ],
          ),
        )
    );
  }
}