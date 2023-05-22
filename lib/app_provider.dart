import 'package:flutter/cupertino.dart';

class AppProvider extends ChangeNotifier{
  refresh(){
    notifyListeners();
  }
}