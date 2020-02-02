import 'package:flutter/material.dart';
import '../models/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = []; // 右侧小类类名列表
  int childIndex = 0; // 用于高亮显示右侧导航选中项
  String categoryId = '4'; // 左侧大类的 ID
  String subId = ''; // 右侧小类的 ID

  // 对象化，声明一个泛型的 List 变量，然后使用 function 进行赋值
  getChildCategory(List<BxMallSubDto> list, String id) {
    categoryId = id;
    childIndex = 0;
    subId = ''; // 点击左侧大类的时候，将右侧小类清空
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '00';
    all.mallCategoryId = '00';
    all.mallSubName = '全部';
    all.comments = 'null';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  changeChildIndex(int index, String id) {
    childIndex = index;
    subId = id;
    notifyListeners();
  }
}