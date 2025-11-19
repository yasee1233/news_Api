import 'dart:convert';

import 'package:demo_prj/newsapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http ;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override 
  Widget build(BuildContext context){
    return MaterialApp(
      title: " News_API App",
      debugShowCheckedModeBanner: false,
      color: Colors.black,
      home: Homepage(),
    );
  }
}
Future fetchNewsApi()async{
var Url =("https://newsapi.org/v2/everything?q=tesla&from=2025-10-19&sortBy=publishedAt&apiKey=dd95be60dbad4e02b46a6e6e7a8efaef");
final Response =await http.get(Uri.parse(Url));
if(Response.statusCode ==200){
  final result = jsonDecode(Response.body);
  return News_api.fromJson(result);
}
else{
  return News_api();
}
}
class Homepage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
  title: Text(" News_API App",
  style: TextStyle(color: Colors.white)
      ),
      ),
      body: FutureBuilder(future: fetchNewsApi(), builder: (context ,snapshot){
         if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
  } else if (snapshot.hasError) {
    return Center(child: Text("Error: ${snapshot.error}"));
  } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.articles == null) {
    return Center(child: Text("No articles found"));
  }

        return ListView.builder(itemBuilder: (context ,index){
          return Card(
            child: ListTile(
              leading:CircleAvatar(
                backgroundImage:  NetworkImage("${snapshot.data!.articles![index]?.urlToImage}"),
              ),
              title: Text("${snapshot.data!.articles![index]?.title ?? "No Title"}"),
              subtitle: Text("${snapshot.data!.articles![index]?.description ?? "No Description"}"),
            ),
          );
        },itemCount:snapshot.data!.articles!.length);
      })
    );
  }
}