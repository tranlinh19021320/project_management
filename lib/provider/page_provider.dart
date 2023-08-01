import 'package:flutter/material.dart';
import 'package:project_management/utils/utils.dart';

class PageProvider extends ChangeNotifier {
  int _page = IS_PROJECTS_PAGE;

  int get page => _page;

  Future<void> changePage(int pageName) async{
    _page = pageName;
    notifyListeners();
  }

  Future<void> refreshPage() async{
    _page = IS_PROJECTS_PAGE;
    notifyListeners();
  }

}