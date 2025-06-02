import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokepedia_firebase_setup/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var pokepediaApi = "https://pokeapi.co/api/v2/pokemon/ditto";
  List pokepedia = [];

  @override
  void initState() {
    if (mounted) {
      fetchData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Image.asset(
              'assets/images/pokeball.png',
              width: 200,
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            top: 90,
            left: 15,
            child: Text(
              "Pokepedia",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 160,
            bottom: 0,
            // child: Container(height: height, width: width, color: Colors.red),
            child: Column(
              children: [
                pokepedia != null
                    ? Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.4,
                        ),
                        itemBuilder: (context, index) {
                          var type = pokepedia[index]['type'][0];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    type == 'Grass'
                                        ? Colors.greenAccent
                                        : type == 'Fire'
                                        ? Colors.redAccent
                                        : type == 'Water'
                                        ? Colors.blueAccent
                                        : type == 'Electric'
                                        ? Colors.yellowAccent
                                        : type == 'Rock'
                                        ? Colors.grey
                                        : type == 'Ground'
                                        ? Colors.brown
                                        : type == 'Psychic'
                                        ? Colors.indigo
                                        : type == 'Fighthing'
                                        ? Colors.orange
                                        : type == 'Bug'
                                        ? Colors.lightGreen
                                        : type == 'Ghost'
                                        ? Colors.deepPurple
                                        : type == 'Normal'
                                        ? Colors.black26
                                        : type == 'Poison'
                                        ? Colors.deepPurpleAccent
                                        : Colors.pink,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: -10,
                                    right: -10,
                                    child: Image.asset(
                                      'assets/images/pokeball.png',
                                      width: 100,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  Positioned(
                                    top: 15,
                                    left: 10,
                                    child: Text(
                                      pokepedia[index]['Name'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    left: 10,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                          top: 4.0,
                                          bottom: 4.0,
                                        ),
                                        child: Text(
                                          type.toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                        color: Colors.white30,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: CachedNetworkImage(
                                      imageUrl: pokepedia[index]['img'],
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
    // return Scaffold(
    //   body: Center(
    //     child: ElevatedButton(
    //       child: Text("Button"),
    //       onPressed: () {
    //         // print("Pressed");
    //         fetchData();
    //       },
    //     ),
    //   ),
    // );
  }

  void fetchData() {
    var url = Uri.https("https://pokeapi.co/api/v2/pokemon/ditto");
    http.get(url).then((value) {
      if (value.statusCode == 200) {
        var decodeData = jsonDecode(value.body);
        var pokepedia = decodeData["abilities	"];

        setState(() {});
      }
    });
  }
}
