import 'package:flutter/material.dart';
import '../models/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = []; // 右侧小类类名列表
  int childIndex = 0; // 用于高亮显示右侧导航选中项
  String categoryId = '4'; // 左侧大类的 ID
  String subId = ''; // 右侧小类的 ID

  int page = 1; //列表页数，当改变左侧大类或者右侧小类的时候，进行改变
  String noMoreText = ''; // 显示更多的标识

  // 切换大类时调用
  getChildCategory(List<BxMallSubDto> list, String id) {
    categoryId = id;
    childIndex = 0;
    subId = ''; // 点击左侧大类的时候，将右侧小类清空

    page = 1;
    noMoreText = '';

    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '00';
    all.mallCategoryId = '00';
    all.mallSubName = '全部';
    all.comments = 'null';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  // 切换右侧小类时调用
  changeChildIndex(int index, String id) {
    childIndex = index;
    subId = id;

    page = 1;
    noMoreText = '';

    notifyListeners();
  }

  addPage() {
    page++;
  }

  changeNoMoreText(String text) {
    noMoreText = text;
    notifyListeners();
  }
}