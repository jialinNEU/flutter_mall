import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/details.dart';
import '../services/service_method.dart';

class DetailsInfoProvide with ChangeNotifier {

  DetailsModel goodsInfo;

  // 从后台获取商品详情
  getGoodsInfo(String id) {
    var formData = { 'goodId': id };
    request('getGoodsDetailById', formData: formData).then((val) {
      var responseData = json.decode(val.toString());
      print(responseData);
      goodsInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }
}