import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../pages/login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  Container buildButton({String text, Function function, Color color}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 250,
          height: 27,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: color,
              ),
              borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _username = Provider.of<Auth>(context, listen: false).username;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xff023429),
      ),
      drawer: AppDrawer(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 15),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        _username,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          buildButton(text: 'Edit Data', function: () {}, color: Colors.blue),
          Padding(
            padding: EdgeInsets.all(10),
            child: Divider(
              thickness: 1,
            ),
          ),
          ListTile(
            title: Text('Helping & Support'),
            leading: Icon(Icons.message),
          ),
          ListTile(
            title: Text('Contact Us'),
            leading: Icon(Icons.call),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Divider(
              thickness: 1,
            ),
          ),
          SizedBox(
            height: 7,
          ),
          Center(
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
