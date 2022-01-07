import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'dart:io';
import 'dart:core';
import 'dart:convert';
import 'Route.dart';
import 'newmap.dart';
import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
int nodesNum = 0;
var places; //cor for my target
var target = "0";
var my_locat = "0";
var places_my; //cor for my location
var start;
var end;
var coordinates = [];
int password = 0;
int user = 0;



void main() async {
  runApp(const MaterialApp(
    home: MyApp(title: '',),
  ));
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key, required String title}) : super(key: key);

  static const String _title = 'ניווט בלגו';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        appBar: AppBar(title: const Text(_title) ),
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
                        SizedBox(height: 150),
                        SizedBox(width: 20000000),
                        OutlinedButton(

                          child: Stack(
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "בחירת מהירות",

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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  thirdRoute(title: 'mappage',)),);
                          },
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        SizedBox(height: 40),
                        OutlinedButton(
                            child: Stack(
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "סע",

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
                            onPressed: () async {}),
                        SizedBox(height: 40),

                        OutlinedButton(
                          child: Stack(
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "בחירת יעד ומוצא",

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
                          onPressed: () async {
                            //       print("!!!");
                            //
                            //             coordinates = [];
                            // // if (target != "0" && my_locat != "0")
                            //   print("start point: ");
                            //   var connection = PostgreSQLConnection(
                            //       "47.254.229.61", 5432, "robotics",
                            //       username: "postgres", password: "joeDolan123!@#");
                            //   await connection.open();
                            //       print("!!!");
                            //   var nodes = await connection.query(
                            //       "SELECT node FROM pgr_dijkstra(  'SELECT id,  source AS source, target AS target, length as cost FROM routes',1, 5,FALSE);");
                            //   nodesNum = nodes.length;
                            //   for (int i = 0; i < nodesNum; i++) {
                            //     var currNode = json.encode(nodes[i]);
                            //     currNode =
                            //         currNode.substring(
                            //             1, currNode.length - 1);
                            //     coordinates.add(await connection.query(
                            //         'SELECT xcoord,ycoord FROM junctions WHERE id = $currNode'));
                            //   }
                            //       print("!!!");
                            //   print("best route: $nodes");

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SecondRoute(
                                        title: 'mappage',
                                      )),
                            );
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
        //Maps widget contain
      ),
    );
  }
}
