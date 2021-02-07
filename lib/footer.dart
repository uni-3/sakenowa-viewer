import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  //const Footer();

  @override
  FooterWidget createState() => FooterWidget();
}

class FooterWidget extends State {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.copyright),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home2'),
        ),
      ],
    );
  }
}
