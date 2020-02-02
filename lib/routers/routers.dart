import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';

class Routers {
  static String root = '/';
  static String detailsPage = '/details';
  
  static void configureRoutes(Router router) {
    // 路由不存在的配置
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        print('ERROR ===> Route was not found!');
      }
    );

    router.define(detailsPage, handler: detailsHandler); // 配置 商品详情页 路由
  }
}