// @dart=2.15
// ignore: unused _import
import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;

// Weather currentTemp;

void main() {
  runApp(const MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        title: 'Weather App',
        home: Home(),
      )));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  var temp;
  var description;
  var currently;
  var humidity;
  var windspeed;
  var input;

  Future getWeather(String input) async {
    String searchApiURL = "http://api.openweathermap.org/data/2.5/weather?q=";
    http.Response response = await http.get(Uri.parse(searchApiURL +
        input +
        "&units=metric&appid=fc47715eb3409a6fdf573759b4299d86"));
    var result = jsonDecode(response.body);
    setState(() {
      this.temp = result['main']['temp'];
      this.description = result['weather'][0]['description'];
      this.currently = result['weather'][0]['main'];
      this.humidity = result['main']['humidity'];
      this.windspeed = result['wind']['speed'];
      this.input = result['name'];
    });
  }

  onTextFieldSubmitted(String input) {
    getWeather(input);
  }

  @override
  void initState() {
    super.initState();
    getWeather(onTextFieldSubmitted(input));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: dead_code
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.indigo[700],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                Container(
                  width: 200,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        onSubmitted: (input) {
                          onTextFieldSubmitted(input);
                        },
                        style: TextStyle(color: Colors.white, fontSize: 15),
                        decoration: InputDecoration(
                            hintText: '      Input a new Location',
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 10.0),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    input != null
                        ? 'Currently in ' + input.toString()
                        : 'Insert a city',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  temp != null ? temp.toString() + "°" : 'loading...',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 40.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    currently != null ? currently.toString() : 'loading',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                  title: Text('Temperature'),
                  trailing: Text(
                      temp != null ? temp.toString() + '\u0000' : 'loading'),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.cloud),
                  title: Text('Weather'),
                  trailing: Text(
                      description != null ? description.toString() : 'loading'),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.sun),
                  title: Text('Humidity'),
                  trailing:
                      Text(humidity != null ? humidity.toString() : 'loading'),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.wind),
                  title: Text('WindSpeed'),
                  trailing: Text(
                      windspeed != null ? windspeed.toString() : 'loading'),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
