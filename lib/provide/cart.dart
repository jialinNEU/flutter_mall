import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cartInfo.dart';

class CartProvide with ChangeNotifier {
  String cartString = '[]'; // shared_preferences 不支持对象持久化，因此使用 cartString 再转换到 cartList 中
  List<CartInfoModel> cartList = [];

  // 将商品添加到购物车
  save(goodsId, goodsName, count, price, images) async {
    // 初始化 SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');

    // 判断 cartString 是否为空，空说明是第一次添加，非空进行 decode
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    List<Map> tempList = (temp as List).cast();

    var isHave = false; // 购物车中是否已经存在此商品 ID
    int indexVal = 0; // 索引

    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        // 购物车中商品存在
        tempList[indexVal]['count'] = item['count'] + 1;
        cartList[indexVal].count++;
        isHave = true;
      }
      indexVal++;
    });

    // 购物车中商品不存在
    if(!isHave) {
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images,
      };
      tempList.add(newGoods);
      cartList.add(new CartInfoModel.fromJson(newGoods));
    }

    // 持久化
    cartString = json.encode(tempList).toString();
    print(cartString);
    print(cartList.toString());
    prefs.setString('cartInfo', cartString);
    notifyListeners();
  }

  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.get('cartInfo');
    cartList = [];
    if (cartString == null) {
      cartList = [];
    } else {
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      tempList.forEach((item) {
        cartList.add(new CartInfoModel.fromJson(item));
      });
    }
  }

  // 清空购物车
  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    print('清空');
    notifyListeners();
  }
}