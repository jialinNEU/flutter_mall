import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:fluro/fluro.dart';
import './pages/index_page.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/details_info.dart';
import './provide/category_goods_list.dart';
import './routers/routers.dart';
import './routers/application.dart';

// void main() => runApp(MyApp());

void main() {
  final router = Router();
  Routers.configureRoutes(router);
  Application.router = router;
  var counter = Counter();
  var childCategory = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var detailsInfoProvide = DetailsInfoProvide();
  var providers = Providers();
  providers
    ..provide(Provider<Counter>.value(counter)) // 将 provide 和 counter 引入程序顶层
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide));
  runApp(
    ProviderNode(
      child: MyApp(),
      providers: providers,
    )
  );

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Application.router.generator, // 添加路由
        theme: ThemeData(
          primaryColor: Colors.pink,
        ),
        home: IndexPage(),
      ),
    );
  }
}

