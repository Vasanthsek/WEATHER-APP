import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String date = DateFormat("yMMMd").format(DateTime.now());
  var data;
  bool isWorking = false;
  String? city;

  @override
  void initState() {
    super.initState();

    getUserApi();
  }

  Future<void> getUserApi() async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=43ea6baaad7663dc17637e22ee6f78f2&units=metric"));

    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());
      // print(data);
      return data;
    } else {
      return data;
    }
  }

  @override
  void dispose() {
    super.dispose();
    weatherController.dispose();
    weatherController.clear();
  }

  TextEditingController weatherController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(
              20.0,
            ),
            child: TextField(
              onSubmitted: (value) {
                setState(() {
                  city = weatherController.text.toLowerCase().trim();
                  isWorking = true;
                });
                getUserApi();
              },
              style: const TextStyle(color: Colors.black),
              autofocus: false,
              controller: weatherController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "Search City",
                fillColor: Colors.white70,
              ),
            ),
          ),
          isWorking
              ? Expanded(
                  child: FutureBuilder(
                  future: getUserApi(),
                  builder:
                      (BuildContext context, AsyncSnapshot<Object?> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Display(
                          dataa: data,
                          indexx: index,
                          datee: date,
                        );

                        // Card(
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Column(

                        //         children: [
                        //           Text(data["name"].toString()),
                        //           Text(data["cod"].toString()),
                        //           Text(data["weather"][index]['main'].toString()),
                        //           Text(data["coord"]["lat"].toString()),

                        //         ],
                        //       ),
                        //     ),
                        //   );
                      },
                    );
                  },
                ))
              : Expanded(
                  child: Container(
                  child: const RiveAnimation.asset(
                      "images/2741-5623-cloud-and-sun.riv"),
                )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getUserApi();

          setState(() {
            city = weatherController.text.toLowerCase().trim();
            isWorking = true;
          });
          //  weatherController.clear();
        },
        backgroundColor: Colors.amber,
        child: const Icon(
          IconData(0xe156, fontFamily: 'MaterialIcons'),
        ),
      ),
    );
  }
}

class Display extends StatelessWidget {
  var dataa;
  var indexx;
  var datee;
  Display(
      {Key? key,
      required this.dataa,
      required this.indexx,
      required this.datee})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  dataa["name"].toString(),
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(datee),
              ],
            ),
            const SizedBox(
              height: 30,
            ),

            Text(
              dataa["main"]["temp"].toString() + "\u2103",
              style: TextStyle(color: Colors.white70, fontSize: 40),
            ),

            const Text(
              "Temperature",
              style: TextStyle(color: Colors.white70, fontSize: 25),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      dataa["weather"][indexx]['main'].toString(),
                      style: TextStyle(color: Colors.white70, fontSize: 30),
                    ),
                    const Text(
                      "Weather Status",
                      style: TextStyle(color: Colors.white70, fontSize: 25),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      dataa["main"]["humidity"].toString() + "%",
                      style: TextStyle(color: Colors.white70, fontSize: 30),
                    ),
                    const Text(
                      "Humidity",
                      style: TextStyle(color: Colors.white70, fontSize: 25),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Image.asset(
                "images/${dataa["weather"][indexx]['icon'].toString()}.png"),
            // Text(dataa["weather"][1]['main'].toString(),style:const TextStyle(color: Colors.white70, fontSize: 30, fontWeight: FontWeight.bold),),
          ],
        ));
  }
}
