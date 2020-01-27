import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import './pages/index_page.dart';
import './provide/counter.dart';
import './provide/child_category.dart';

// void main() => runApp(MyApp());

void main() {
  var counter = Counter();
  var childCategory = ChildCategory();
  var providers = Providers();
  providers
    ..provide(Provider<Counter>.value(counter)) // 将 provide 和 counter 引入程序顶层
    ..provide(Provider<ChildCategory>.value(childCategory));
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
        theme: ThemeData(
          primaryColor: Colors.pink,
        ),
        home: IndexPage(),
      ),
    );
  }
}

