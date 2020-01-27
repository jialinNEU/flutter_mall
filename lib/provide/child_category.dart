import 'package:flutter/material.dart';
import '../models/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];

  // 对象化，声明一个泛型的 List 变量，然后使用 function 进行赋值
  getChildCategory(List<BxMallSubDto> list) {
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '00';
    all.mallCategoryId = '00';
    all.mallSubName = '全部';
    all.comments = 'null';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }
}