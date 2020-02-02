import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/details_page.dart';

// 商品详情页 的路由配置
Handler detailsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String goodsId = params['id'].first; // 
    print('index > details goodsId is $goodsId');
    return DetailsPage(goodsId);
  }
);