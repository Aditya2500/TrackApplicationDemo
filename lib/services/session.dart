import 'package:shared_preferences/shared_preferences.dart';

class Session {  
  static setString (String key,String value)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setString(key, value);
  }
 static setStringList (String key,List<String> values)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setStringList(key, values);
  }
 static setDouble (String key,double value)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
  await  prefs.setDouble(key, value);
  }
  static getString (String key)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   return prefs.getString(key);
  }
  static getStringList (String key)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
  return  prefs.getStringList(key);
  }
 static  getDouble (String key)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
  return  prefs.getDouble(key);
  }
}