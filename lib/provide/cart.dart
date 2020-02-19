import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cartInfo.dart';

class CartProvide with ChangeNotifier {
  String cartString = '[]'; // shared_preferences 不支持对象持久化，因此使用 cartString 再转换到 cartList 中
  List<CartInfoModel> cartList = [];

  double totalPrice = 0; // 商品总价
  int totalGoodsCount = 0; // 商品总数量
  bool isAllCheck = true; // 是否全选

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
    totalPrice = 0; // 初始化总价
    totalGoodsCount = 0; // 初始化总数量

    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        // 购物车中商品存在
        tempList[indexVal]['count'] = item['count'] + 1;
        cartList[indexVal].count++;
        isHave = true;
      }
      if (item['isCheck']) {
        totalPrice += (cartList[indexVal].price * cartList[indexVal].count);
        totalGoodsCount += cartList[indexVal].count;
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
        'isCheck': true,
      };
      tempList.add(newGoods);
      cartList.add(new CartInfoModel.fromJson(newGoods));
      totalPrice += count * price;
      totalGoodsCount += count;
    }

    // 持久化
    cartString = json.encode(tempList).toString();
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
      totalPrice = 0;
      totalGoodsCount = 0;
      isAllCheck = true;

      tempList.forEach((item) {
        if (item['isCheck']) {
          totalPrice += (item['count'] * item['price']);
          totalGoodsCount += item['count'];
        } else {
          isAllCheck = false;
        }
        cartList.add(new CartInfoModel.fromJson(item));
      });
    }
    notifyListeners();
  }


  // 删除购物车中的指定商品
  deleteSingleCartItem(String goodsId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    int tempIndex = 0;
    int delIndex = 0; // 需要删除的索引

    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        delIndex = tempIndex;
      }
      tempIndex++;
    });

    /* dart语言不支持循环迭代的时候进行修改或删除，因此在循环结束后才删除 */

    tempList.removeAt(delIndex);
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
    notifyListeners();
  }

  // 清空购物车
  remove() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('cartInfo');
    print('清空购物车 TODO');
    notifyListeners();
  }

  // 更新购物车中的指定商品
  changeCheckState(CartInfoModel cartItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    int tempIndex = 0;
    int changeIndex = 0; // 需要修改的索引

    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });

    tempList[changeIndex] = cartItem.toJson(); // 把对象变成 Map
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
    notifyListeners();
  }

  // 更新全选按钮
  changeAllCheckBtnState(bool isCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    
    List<Map> newList = [];
    for (var item in tempList) {
      var newItem = item;
      newItem['isCheck'] = isCheck;
      newList.add(newItem);
    }

    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
    notifyListeners();
  }

  // 控制购物车增减商品数量
  addOrReduceAction(var cartItem, String action) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    int tempIndex = 0;
    int changeIndex = 0; // 需要
    
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });

    if (action == 'add') {
      cartItem.count++;
    } else {
      cartItem.count--;
    }

    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
    notifyListeners();
  }
}