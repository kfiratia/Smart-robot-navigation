import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'newmap.dart';
var speed=1;
class thirdRoute extends StatefulWidget {
  thirdRoute({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<thirdRoute> {


  // late List<Model> data;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5572E3),
      body: Container(
        decoration: BoxDecoration(
          // shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage("images/EV3.jpeg"),

            fit: BoxFit.fill,
          ),
        ),
        // backgroundColor: const Color(0xFF5572E3),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(width: 20000000),
                      SizedBox(height: 250),
                      OutlinedButton(

                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "נמוכה",

                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          maximumSize: Size(250, 70),
                          backgroundColor: Colors.black,
                          primary: Colors.teal,
                          textStyle: TextStyle(
                              color: Colors.white24,
                              fontSize: 20,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                        onPressed: () {
                          speed=1;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                MyApp(title: 'mappage',)),);
                        },
                      ),
                      SizedBox(height: 40),
                      OutlinedButton(

                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "בינונית",

                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          maximumSize: Size(250, 70),
                          backgroundColor: Colors.black,
                          primary: Colors.teal,
                          textStyle: TextStyle(
                              color: Colors.white24,
                              fontSize: 20,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                        onPressed: () {
                          speed=2;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                MyApp(title: 'mappage',)),);
                        },
                      ),
                      SizedBox(height: 40),
                      OutlinedButton(

                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "גבוהה",

                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          maximumSize: Size(250, 70),
                          backgroundColor: Colors.black,
                          primary: Colors.teal,
                          textStyle: TextStyle(
                              color: Colors.white24,
                              fontSize: 20,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                        onPressed: () {
                          speed=3;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                MyApp(title: 'mappage',)),);
                        },
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ],
        ), /* add child content here */
      ),
    );
  }

}