import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileState();
  }
}

class ProfileState extends State {
  Text titleText({String title}) {
    return Text(
      title,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text contextText({String context}) {
    return Text(
      context,
      textAlign: TextAlign.end,
      style: TextStyle(
        fontSize: 20,
        color: Colors.black54,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.blueGrey),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Text(
              "Rawit",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Lohakhachornphan",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Rawitgun@gmail.com",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: <Widget>[
                  titleText(title: "Gender"),
                  contextText(context: "Male")
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: <Widget>[
                  titleText(title: "Date of Birth"),
                  contextText(context: "4 April 1999")
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: <Widget>[
                  titleText(title: "Height"),
                  contextText(context: "170 cm")
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: <Widget>[
                  titleText(title: "Weight"),
                  contextText(context: "60 kg")
                ],
              ),
            ),
            RaisedButton(
              child: Text(
                'Logout',
                style: TextStyle(
                    color: Color.fromRGBO(216, 32, 32, 1), fontSize: 15),
              ),
              color: Colors.white,
              elevation: 4.0,
              splashColor: Colors.redAccent,
              onPressed: () {
                // Perform some action
              },
            ),
          ],
        ),
      ),
    );
  }
}