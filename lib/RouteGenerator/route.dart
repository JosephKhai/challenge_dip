
import 'package:challenge_diploma/pages/addMatch.dart';
import 'package:challenge_diploma/pages/edit.dart';
import 'package:challenge_diploma/pages/homePage.dart';
import 'package:challenge_diploma/pages/loginPage.dart';
import 'package:challenge_diploma/pages/registerPage.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case LoginPage.id:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case RegisterPage.id:
        return MaterialPageRoute(builder: (_) => RegisterPage());       
      case HomePage.id:
        return MaterialPageRoute(builder: (_) => HomePage(loggedInUser: settings.arguments,));
      case EditPage.id:
        return MaterialPageRoute(builder: (_) => EditPage(loggedInUser: settings.arguments,));
      
      case AddMatchPage.id:
        return MaterialPageRoute(builder: (_) => AddMatchPage(loggedInUser: settings.arguments,));
      
      default:
        return null; 
    }
  }
}