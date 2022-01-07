
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_map/flutter_map.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:postgres/postgres.dart';
import 'package:flutter/material.dart';
import 'Route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'main.dart';
import 'mapf.dart';
import 'package:flutter_spinbox/material.dart';
var my_locat = 0;
var target = 0;
var id = 39;
double speed = 0;
// final MapShapeLayerController _layerController = MapShapeLayerController();
String dropdownValue = 'בחירה';
String dropdownValue1 = 'בחירה';
// final TextEditingController _currentLocationTextController =
// TextEditingController();
//
// final TextEditingController _destinationLocationTextController =
// TextEditingController();
var places ;
var places_my;

final client = MqttServerClient('47.254.229.61', '');

Future<int>() async {
  client.logging(on: false);
  client.keepAlivePeriod = 20;
  client.onDisconnected = onDisconnected;
  client.onConnected = onConnected;
  client.pongCallback = pong;
  // final connMess = MqttConnectMessage()
  //     .withClientIdentifier('client-4')
  //     .startClean() // Non persistent session for testing
  //     .withWillQos(MqttQos.atLeastOnce);
  // print('EXAMPLE::Mosquitto client connecting....');
  // client.connectionMessage = connMess;
  // await client.connect();
  // try {
  //   await client.connect();
  // } on NoConnectionException catch (e) {
  //   // Raised by the client when connection fails.
  //   print('EXAMPLE::client exception - $e');
  //   client.disconnect();
  // } on SocketException catch (e) {
  //   // Raised by the socket layer
  //   print('EXAMPLE::socket exception - $e');
  //   client.disconnect();
  // }
  //
  // if (client.connectionStatus!.state == MqttConnectionState.connected) {
  //   print('EXAMPLE::Mosquitto client connected');
  // } else {
  //   print(
  //       'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
  //   client.disconnect();
  //   exit(-1);
  // }
  // print('EXAMPLE::Sleeping....');
  await MqttUtilities.asyncSleep(120);

  await MqttUtilities.asyncSleep(2);
  print('EXAMPLE::Disconnecting');
  client.disconnect();
  return 0;
}

void onDisconnected() {
  print('EXAMPLE::OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
  }
  // exit(-1);
}

void onConnected() {
  print(
      'EXAMPLE::OnConnected client callback - Client connection was sucessful');
}
void pong() {
  print('EXAMPLE::Ping response client callback invoked');
}


late Position _currentPosition, _destinationPosition;
late StreamSubscription _positionStream;


class SecondRoute extends StatefulWidget {
  SecondRoute({Key? key, required this.title}) : super(key: key);

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

class _MyHomePageState extends State<SecondRoute> {
  late double _distanceInMiles = 0;
  final MapShapeLayerController _layerController = MapShapeLayerController();
  final TextEditingController _currentLocationTextController =
  TextEditingController();

  final TextEditingController _destinationLocationTextController =
  TextEditingController();
  MapZoomPanBehavior _zoomPanBehavior = MapZoomPanBehavior(
    focalLatLng: MapLatLng(32.014138, 34.773087),
    zoomLevel: 1.05,
    // enableDoubleTapZooming: true,

  );
  List<Model1> _data = const <Model1>[
  Model1('images.png', 32.014063, 34.773032),
    Model1('door.png', 32.014136, 34.773193),
    Model1('door.png', 32.014317, 34.773016),
    Model1('door.png', 32.014, 34.773019),
    Model1('toilet.png', 32.014066, 34.772979),
    Model1('room.png', 32.014077, 34.773147),
    Model1('room.png', 32.014063, 34.773108),
    Model1('room.png', 32.014256, 34.773142),
  ];
  List<Model> data = const <Model>[

    Model('shape', Color.fromRGBO(5, 27, 33, 0.8),'מדעי המחשב'),
  ];


  @override
  void dispose() {
    // _layerController.dispose();
    _layerController.insertMarker(2);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF73BDE8),
      body:

      SafeArea(

        child: Column(
          children: [
            //Title widget
            SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                //Current location text field
                Container(
                  width: 220,

                  // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        // color: Colors.blueGrey,
                        width: 2,

                      )
                  ),
                  alignment: Alignment.centerRight,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: dropdownValue1,
                    elevation: 16,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Open Sans',
                        fontSize: 20),
                    alignment: Alignment.center,
                    // underline: Container(
                    //   height: 5,
                    //
                    //   color: Colors.black,
                    // ),
                    onChanged: (String? newValue) async {
                      if(my_locat != 0)
                      {
                        _layerController.removeMarkerAt(0);
                      }

                      dropdownValue1 = newValue!;
                      if (dropdownValue1 == "כיתה 100")
                         my_locat = 1;
                      else if (dropdownValue1 == "כיתה 101")
                        my_locat = 2;
                      else if (dropdownValue1 == "יציאה קרובה")
                        my_locat = 3;
                      else if (dropdownValue1 == "יציאה רחוקה")
                        my_locat = 4;
                      else if (dropdownValue1 == "שירותים")
                        my_locat = 5;
                      else if (dropdownValue1 == "מעלית")
                        my_locat = 14;
                      else if (dropdownValue1 == "כיתה 111")
                        my_locat = 8;
                      else if (dropdownValue1 == "כניסה ראשית")
                        my_locat = 9;
                        var connection = PostgreSQLConnection(
                            "47.254.229.61", 5432, "robotics",
                            username: "postgres",
                            password: "joeDolan123!@#");
                        await connection.open();
                        places_my = (await connection.query(
                            'SELECT xcoord,ycoord FROM junctions WHERE id = $my_locat'));
                        await connection.close();
                        print(places_my);
                        _layerController.insertMarker(0);

                        setState(() {});

                    },

                    items: <String>[ 'בחירה','כיתה 100','כיתה 101','כיתה 111','שירותים', 'מעלית','יציאה קרובה', 'יציאה רחוקה',   'כניסה ראשית']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          alignment: Alignment.centerRight,

                          child: Text(
                            value,
                          ),
                        ),
                      );

                    }).toList(),

                  ),
                ),

                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    '   המיקום שלי:        ',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height:15),
            //Maps widget container
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                //Current location text field
                Container(
                  width: 220,

                  // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        // color: Colors.blueGrey,
                        width: 2,

                      )
                  ),
                  alignment: Alignment.centerRight,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: dropdownValue,
                    elevation: 16,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Open Sans',
                        fontSize: 20),
                    alignment: Alignment.center,
                    // underline: Container(
                    //   height: 5,
                    //
                    //   color: Colors.black,
                    // ),
                    onChanged: (String? newValue) async {
                      if(target != 0)
                      {
                        _layerController.removeMarkerAt(1);
                      }

                      dropdownValue = newValue!;
                      if (dropdownValue == "כיתה 100")
                        target = 1;
                      else if (dropdownValue == "כיתה 101")
                        target = 2;
                      else if (dropdownValue == "יציאה קרובה")
                        target = 3;
                      else if (dropdownValue == "יציאה רחוקה")
                        target = 4;
                      else if (dropdownValue == "שירותים")
                        target = 5;
                      else if (dropdownValue == "מעלית")
                        target = 14;
                      else if (dropdownValue == "כיתה 111")
                        target = 8;
                      else if (dropdownValue == "כניסה ראשית")
                        target = 9;
                      var connection = PostgreSQLConnection(
                          "47.254.229.61", 5432, "robotics",
                          username: "postgres",
                          password: "joeDolan123!@#");
                      await connection.open();
                      places = (await connection.query(
                          'SELECT xcoord,ycoord FROM junctions WHERE id = $target'));
                      await connection.close();
                      print(places);
                      _layerController.insertMarker(1);

                      setState(() {});

                    },

                    items: <String>[ 'בחירה','כיתה 100','כיתה 101','כיתה 111','שירותים', 'מעלית','יציאה קרובה', 'יציאה רחוקה',   'כניסה ראשית']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          alignment: Alignment.centerRight,

                          child: Text(
                            value,
                          ),
                        ),
                      );

                    }).toList(),

                  ),
                ),

                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    '   יעד:                     ',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            Container(
              child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: SfMaps(
                      layers: [
                        MapShapeLayer(
                          zoomPanBehavior: _zoomPanBehavior,
                          controller: _layerController,
                          // initialMarkersCount: 5,
                          markerBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return MapMarker(
                                  latitude: places_my[0][1],
                                  longitude: places_my[0][0],
                                  child: new Image.asset('images/EV3.jpeg',width:25,height:25));
                            } else if (index == 1) {
                              //destination position
                              return MapMarker(
                                  latitude: places[0][1],
                                  longitude: places[0][0],
                                  child: Icon(Icons.location_on, color: Colors.red,));
                            } else if (index == 2) {
                              //flight current position
                              print(_destinationPosition.latitude);
                              print(_destinationPosition.longitude);
                              return MapMarker(
                                  latitude: 32.014063,
                                  longitude:  34.773032,
                                  // child: Icon(Icons.location_on));
                                  child: new Image.asset('assets/images.png',width:30,height:30));

                            }
                            return MapMarker(
                                latitude: 32.014063,
                                longitude:  34.773032,
                                // child: Icon(Icons.location_on));
                                child: new Image.asset('assets/images.png',width:30,height:30));

                          },

                          source: MapShapeSource.asset(
                            'assets/b8.json',
                            shapeDataField: 'name',
                            dataCount: data.length,
                            primaryValueMapper: (int index) =>
                            data[index].country,
                            shapeColorValueMapper: (int index) =>
                            data[index].color,
                            // dataLabelMapper: (int index) => data[index].size,

                          ),

                          showDataLabels: true,
                          shapeTooltipBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(7),
                              child: Text(data[index].size,
                              ),
                            );
                          },
                      sublayers: [
                      MapShapeSublayer(
                    source: MapShapeSource.asset(
                    'assets/b8.json',
                      shapeDataField: 'name',
                      dataCount: data.length,
                      primaryValueMapper: (int index) =>
                      data[index].country,
                      shapeColorValueMapper: (int index) =>
                      data[index].color,
                    ),
                          initialMarkersCount: 8,
                          markerBuilder: (BuildContext context, int index) {
                            return MapMarker(
                              latitude: _data[index].latitude,
                              longitude: _data[index].longitude,
                              iconColor: Colors.blue,
                                child: new Image.asset('assets/${_data[index].country}',width:30,height:30));

                          }
                    ),
                ],
                          ),


                      ],
                    ),
                  )
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    child:
                    SpinBox(
                      min: 0,
                      max: 5,
                      value: 0,
                      decimals: 3,
                      step: 0.5,
                      onChanged: (value) => speed = value,
                      decoration: InputDecoration(
                        suffixText: 'מהירות בקמ״ש',
                        prefixIconColor: Colors.black,
                        labelStyle: TextStyle(fontSize: 25),
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                    ),


                  ),
                  Column(
                    children: [
                      SizedBox(height:15),
                      ElevatedButton(
                        onPressed: () async {
                          id++;
                          print(id);
                          coordinates = [];
                          // if (target != "0" && my_locat != "0")
                          print("start point: ");
                          var connection = PostgreSQLConnection(
                              "47.254.229.61", 5432, "robotics",
                              username: "postgres", password: "joeDolan123!@#");
                          await connection.open();
                          var nodes = await connection.query(
                              "SELECT node FROM pgr_dijkstra(  'SELECT id,  source AS source, target AS target, length as cost FROM routes',$my_locat, $target,FALSE);");
                          nodesNum = nodes.length;
                          print(nodes[1]);
                          for (int i = 0; i < nodesNum; i++) {
                            var currNode = json.encode(nodes[i]);
                            currNode =
                                currNode.substring(1, currNode.length - 1);
                            coordinates.add(await connection.query(
                                'SELECT xgraph,ygraph FROM junctions WHERE id = $currNode'));
                          }
                          var path = "";
                          // for (int i = 0; i < nodesNum; i++) {
                          //   path += coordinates[0][i][0].toString();
                          //   path += " ";
                          //
                          // }
                          print(coordinates);

                          print(coordinates[1][0][1].toString());
                          for (int i = 0; i < nodesNum; i++) {
                          for (int j = 0; j < 2; j++) {
                          path += coordinates[i][0][j].toString();
                          path += " ";
                          }
                          }
                          print(path);
                          // path = path + speed.toString();
                          // print(path);
                          print("best route: $nodes speed: $speed");
                          final connMess = MqttConnectMessage()
                              .withClientIdentifier('client-$id')
                              .startClean() // Non persistent session for testing
                              .withWillQos(MqttQos.atMostOnce);
                          print('EXAMPLE::Mosquitto client connecting....');
                          client.connectionMessage = connMess;
                          await client.connect();

                          try {
                          await client.connect();
                          } on NoConnectionException catch (e) {
                          // Raised by the client when connection fails.
                          print('EXAMPLE::client exception - $e');
                          client.disconnect();
                          } on SocketException catch (e) {
                          // Raised by the socket layer
                          print('EXAMPLE::socket exception - $e');
                          client.disconnect();
                          }

                          /// Check we are connected
                          if (client.connectionStatus!.state ==
                          MqttConnectionState.connected) {
                          print('EXAMPLE::Mosquitto client connected');
                          } else {
                          /// Use status here rather than state if you also want the broker return code.
                          print(
                          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
                          client.disconnect();
                          exit(-1);
                          }

                          /// Lets publish to our topic
                          /// Use the payload builder rather than a raw buffer
                          /// Our known topic to publish to
                          const pubTopic = "topic/test";
                          final builder = MqttClientPayloadBuilder();

                          builder.addString(path);

                          print(builder.payload!);

                          /// Publish it
                          print('EXAMPLE::Publishing our topic');
                          client.publishMessage(pubTopic,
                          MqttQos.exactlyOnce, builder.payload!);

                          /// Ok, we will now sleep a while, in this gap you will see ping request/response
                          /// messages being exchanged by the keep alive mechanism.
                          print('EXAMPLE::Sleeping....');
                          await MqttUtilities.asyncSleep(5);
                          onDisconnected();
                        },
                        child: Text(
                          "סע",
                          textAlign: TextAlign.center,

                        ),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(30),

                          primary: Colors.blue, // <-- Button color
                          onPrimary: Colors.black,
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 50,
                              fontStyle: FontStyle.italic
                          ),// <-- Splash color
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
class Model {
  const Model(this.country, this.color, this.size );
  final String country;
  // final double width;
  final String size;
  final Color color;
// final String stateCode;
}

  class Model1 {
  const Model1(this.country, this.latitude, this.longitude);

  final String country;
  final double latitude;
  final double longitude;
  }

