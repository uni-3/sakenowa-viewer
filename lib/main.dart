import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sake_api/req_sake.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => _PostsListScreenState(title: 'sakenowa api'),
          BreweryPage.routeName: (BuildContext context) => BreweryPage(),
          BrandPage.routeName: (BuildContext context) => BrandPage()
        });
  }
}

class _PostsListScreenState extends StatelessWidget {
  _PostsListScreenState({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Breweries>(
        create: (context) => Breweries(),
        child: Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: Container(
              padding: EdgeInsets.all(10),
              child: PostsListWidget(),
            )));
  }
}

class PostsListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final breweries = Provider.of<Breweries>(context, listen: false).breweriesRepositories();
    return FutureBuilder(
        future: breweries,
        builder: (context, snapshot) {
          // 成功
          if (snapshot.hasData) {
            return Consumer<Breweries>(
                builder: (cctx, data, child) =>
                    LinkWidget(data: data.list, routeName: BreweryPage.routeName));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class BreweryPage extends StatelessWidget {
  static const routeName = '/breweries';

  @override
  Widget build(BuildContext context) {
    final LinkArguments args = ModalRoute.of(context).settings.arguments;
    final id = args.id;
    final title = args.title;
    return ChangeNotifierProvider<Brands>(
        create: (context) => Brands(),
        child: Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: Container(
              padding: EdgeInsets.all(10),
              child: BrandListWidget(breweryId: id),
            )));
  }
}

class BrandListWidget extends StatelessWidget {
  BrandListWidget({Key key, this.breweryId}) : super(key: key);

  final int breweryId;

  @override
  Widget build(BuildContext context) {
    final brands = Provider.of<Brands>(context, listen: false).brandsRepositories(breweryId);
    return FutureBuilder(
        future: brands,
        builder: (context, snapshot) {
          // 成功
          if (snapshot.hasData) {
            return Consumer<Brands>(
                builder: (cctx, data, child) =>
                    LinkWidget(data: data.list, routeName: BrandPage.routeName));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

// brand page
class BrandPage extends StatelessWidget {
  //BrandPage({Key key, this.title, this.id}) : super(key: key);
  static const routeName = '/brands';

  @override
  Widget build(BuildContext context) {
    final LinkArguments args = ModalRoute.of(context).settings.arguments;
    final id = args.id;
    final title = args.title;
    return ChangeNotifierProvider<Flavorcharts>(
        create: (context) => Flavorcharts(),
        child: Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: Container(
              padding: EdgeInsets.all(10),
              child: BrandWidget(brandId: id),
            )));
  }
}

class BrandWidget extends StatelessWidget {
  BrandWidget({Key key, this.brandId}) : super(key: key);

  final int brandId;

  @override
  Widget build(BuildContext context) {
    // todo tag一覧を取得 https://muro.sakenowa.com/sakenowa-data/
    final flavorcharts =
        Provider.of<Flavorcharts>(context, listen: false).flavorchartsRepositories(brandId);
    return FutureBuilder(
        future: flavorcharts,
        builder: (context, snapshot) {
          // 成功
          if (snapshot.hasData) {
            return Consumer<Flavorcharts>(
                builder: (cctx, data, child) => data.list.isEmpty
                    ? Text("not found flavor tags")
                    : Center(child: flavorchartWidget(flavor: data.list.first)));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class flavorchartWidget extends StatelessWidget {
  flavorchartWidget({Key key, this.flavor}) : super(key: key);

  final FlavorchartsRepository flavor;

  @override
  Widget build(BuildContext context) {
    return (Text(
        // 華やか、芳醇、重厚、穏やか、ドライ、軽快
        "flavor chart: \n" +
            flavor.fruity.toString() +
            flavor.mellow.toString() +
            flavor.heavy.toString() +
            flavor.mild.toString() +
            flavor.dry.toString() +
            flavor.light.toString()));
  }
}

class LinkArguments {
  LinkArguments(this.title, this.id);

  final String title;
  final int id;
}

class LinkWidget extends StatelessWidget {
  LinkWidget({Key key, this.data, this.routeName}) : super(key: key);
  final List data;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (lctx, index) {
          return Column(children: <Widget>[
            ListTile(
                leading: Text(data[index].id.toString()),
                title: Text(data[index].name),
                onTap: () {
                  Navigator.of(context).pushNamed(routeName,
                      arguments: LinkArguments(data[index].name, data[index].id));
                }),
            Divider(height: 2.0, color: Colors.grey),
          ]);
        });
  }
}
