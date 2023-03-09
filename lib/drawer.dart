import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class sidebar extends StatelessWidget {
  const sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Ahmad Muhammad'),
            accountEmail: Text('ahmadnwz32@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/slider.jpeg',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill, image: AssetImage('assets/back.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Policies'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () {
                Share.share(
                    'https://apkfab.com/musicbox/com.example.musicbox/apk?h=5059d37459768ba05a58b290956f6eb284230c7297c24882ad1ab5d6cc043a8e');
              }),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("About"),
                  content: const Text(
                      "When I am silent, I fall into the place where everything is music \n\n                    ~Rumi\n\n\n            App Version 1.0.0"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: const Text("OK"),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
