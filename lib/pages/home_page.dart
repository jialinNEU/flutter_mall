import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../services/service_method.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

// class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  // @override
  // bool get wantKeepAlive => true;

  // @override
  // void initState() {
  //   super.initState();
  //   print('1111');
  // }
  
class _HomePageState extends State<HomePage> {

  String homePageContent = '正在获取数据';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+')),
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // 数据处理
            var data = json.decode(snapshot.data.toString());
            List<Map> swiper = (data['data']['slides'] as List).cast();
            List<Map> navigatorList = (data['data']['category'] as List).cast();
            String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];
            List<Map> recommendList = (data['data']['recommend'] as List).cast();

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CustomSwiper(swiperDataList: swiper),
                  TopNavigator(navigatorList: navigatorList),
                  AdBanner(adPicture: adPicture),
                  LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone),
                  RecommendProducts(recommendList: recommendList),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('加载中...'),
            );
          }
        },
      ),
    );
  }
}

// 首页轮播组件
class CustomSwiper extends StatelessWidget {
  final List swiperDataList;

  CustomSwiper({Key key, this.swiperDataList}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('设备像素密度: ${ScreenUtil.pixelRatio}');
    // print('设备高度: ${ScreenUtil.screenHeight}');
    // print('设备宽度: ${ScreenUtil.screenWidth}');
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(333),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network('${swiperDataList[index]['image']}', fit: BoxFit.fill);
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// 种类导航
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({Key key, this.navigatorList}): super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.navigatorList.length > 10) {
      this.navigatorList.removeRange(10, navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

// 广告 Banner
class AdBanner extends StatelessWidget {
  final String adPicture;
  AdBanner({Key key, this.adPicture}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

// 店长电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;
  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}): super(key: key);

  void _launcherURL() async {
    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launcherURL,
        child: Image.network(leaderImage),
      ),
    );
  }
}

// 商品推荐
class RecommendProducts extends StatelessWidget {
  final List recommendList;
  RecommendProducts({Key key, this.recommendList}): super(key: key);

  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12)
        ),
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  Widget _productItem(index) {
    return InkWell(
      onTap: (){},
      child: Container(
        width: ScreenUtil().setWidth(250),
        height: ScreenUtil().setHeight(330),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 1, color: Colors.black12),
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _products() {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _productItem(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _products(),
        ],
      ),
    );
  }
}