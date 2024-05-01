import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universities in Indonesia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UniversityList(),
    );
  }
}

class University {
  final String name;
  final String webPage;

  University({required this.name, required this.webPage});

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      webPage: json['web_pages'][0],
    );
  }
}

Future<List<University>> fetchUniversities() async {
  final response = await http.get(Uri.parse('http://universities.hipolabs.com/search?country=Indonesia'));
  if (response.statusCode == 200) {
    List<dynamic> universitiesJson = jsonDecode(response.body);
    return universitiesJson.map((json) => University.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load university data');
  }
}

class UniversityList extends StatefulWidget {
  @override
  _UniversityListState createState() => _UniversityListState();
}

class _UniversityListState extends State<UniversityList> {
  late Future<List<University>> futureUniversities;

  @override
  void initState() {
    super.initState();
    futureUniversities = fetchUniversities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Indonesian Universities'),
        backgroundColor: Colors.blue[800],
      ),
      body: FutureBuilder<List<University>>(
        future: futureUniversities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                var university = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text(university.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(university.webPage, style: TextStyle(color: Colors.blueAccent)),
                    onTap: () => launchWebsite(university.webPage),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

void launchWebsite(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
