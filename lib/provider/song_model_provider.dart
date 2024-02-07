import 'package:flutter/material.dart';

class SongModelProvider with ChangeNotifier {
  int id = 0;
  int get songid => id;
  void setId(int songid) {
    id = songid;
    notifyListeners();
  }
}
