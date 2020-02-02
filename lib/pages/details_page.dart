import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/details_info.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;
  DetailsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品详情页'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回上一级（页面）
          }
        ),
      ),
      body: FutureBuilder(
        future: _getDetailsInfo(context), // 一个返回 Future 部件的函数
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                children: <Widget>[

                ],
              ),
            );
          } else {
            return Text('加载中...');
          }
        }

      ),
    );
  }

  Future _getDetailsInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '加载完成';
  }
}