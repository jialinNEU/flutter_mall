import 'package:flutter/material.dart';
import '../models/categoryGoodsList.dart';

class CategoryGoodsListProvide with ChangeNotifier {
  List<CategoryListData> goodsList = [];

  getGoodsList(List<CategoryListData> list) {
    goodsList = list;
    notifyListeners();
  }
}