import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/details.dart';
import '../services/service_method.dart';

class DetailsInfoProvide with ChangeNotifier {

  DetailsModel goodsInfo;
  bool isLeft = true;
  bool isRight = false;

  // 从后台获取商品详情
  getGoodsInfo(String id) async {
    var formData = { 'goodId': id };
    await request('getGoodsDetailById', formData: formData).then((val) {
      var responseData = json.decode(val.toString());
      goodsInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }

  // 改变自定义TabBar状态
  changeLeftAndRight(String changeState) {
    if (changeState == 'left') {
      isLeft = true;
      isRight = false;
    } else {
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }
}