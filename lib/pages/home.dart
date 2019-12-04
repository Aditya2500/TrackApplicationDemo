import 'package:flutter/material.dart';
import 'package:trackapp/pages/dashboard.dart';
import 'package:trackapp/services/drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(),  
      drawer:AddDrawer(),
      body: Dashboard(),      
    );
  }
}