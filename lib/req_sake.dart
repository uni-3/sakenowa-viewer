import 'dart:convert';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// factory pattern
// todo エリア名をいれて、地域ごとに表示されるようにする
class BreweriesRepository {
  final int id;
  final String name;
  final int areaId;

  // corstructor
  BreweriesRepository({required this.id, required this.name, required this.areaId});
  factory BreweriesRepository.fromJson(Map<String, dynamic> json) {
    return BreweriesRepository(id: json['id'], name: json['name'], areaId: json['areaId']);
  }
}

// 状態クラス
class Breweries with ChangeNotifier {
  List<BreweriesRepository> _list = [];

  List<BreweriesRepository> get list {
    return [..._list];
  }

  //Future<void> breweriesRepositories() async {
  Future<List<BreweriesRepository>> breweriesRepositories() async {
    var uri = Uri.parse('https://muro.sakenowa.com/sakenowa-data/api/breweries');
    final response = await http.get(uri,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = json.decode(response.body);
      for (var item in decoded['breweries']) {
        _list.add(BreweriesRepository.fromJson(item));
      }
      // 状態変化を検知する
      notifyListeners();
      return list;
    } else {
      throw Exception('Fail to repository');
    }
  }
}

class BrandsRepository {
  final int id;
  final String name;
  final int breweryId;

  BrandsRepository.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        breweryId = json['breweryId'];
}

// 状態クラス
class Brands with ChangeNotifier {
  List<BrandsRepository> _list = [];

  late List<BrandsRepository> list;
  //List<BrandsRepository> get list {
  //  return [..._list];
  //}

  //Future<void> brandsRepositories([int? breweryId]) async {
  Future<List<BrandsRepository>> brandsRepositories([int? breweryId]) async {
    var uri = Uri.parse('https://muro.sakenowa.com/sakenowa-data/api/brands');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      //List<BrandsRepository> list = [];
      Map<String, dynamic> decoded = json.decode(response.body);
      for (var item in decoded['brands']) {
        _list.add(BrandsRepository.fromJson(item));
      }
      // breweryIdがあれば絞り込んで表示
      list = (breweryId == null) ? _list : _list.where((l) => l.breweryId == breweryId).toList();
      _list = list;

      notifyListeners();
      return list;
    } else {
      throw Exception('Fail to repository');
    }
  }
}

class FlavorchartsRepository {
  final int id;
  // 華やか、芳醇、重厚、穏やか、ドライ、軽快
  final double fruity;
  final double mellow;
  final double heavy;
  final double mild;
  final double dry;
  final double light;

  FlavorchartsRepository.fromJson(Map<String, dynamic> json)
      : id = json['brandId'],
        fruity = json['f1'],
        mellow = json['f2'],
        heavy = json['f3'],
        mild = json['f4'],
        dry = json['f5'],
        light = json['f6'];
}

// 状態クラス
class Flavorcharts with ChangeNotifier {
  List<FlavorchartsRepository> _list = [];

  late List<FlavorchartsRepository> list;
  //List<BrandsRepository> get list {
  //  return [..._list];
  //}

  //Future<void> flavorchartsRepositories([int? brandId]) async {
  Future<List<FlavorchartsRepository>> flavorchartsRepositories([int? brandId]) async {
    var uri = Uri.parse('https://muro.sakenowa.com/sakenowa-data/api/flavor-charts');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = json.decode(response.body);
      for (var item in decoded['flavorCharts']) {
        _list.add(FlavorchartsRepository.fromJson(item));
      }
      list = (brandId == null) ? _list : _list.where((l) => l.id == brandId).toList();
      _list = list;

      notifyListeners();
      return list;
    } else {
      throw Exception('Fail to repository');
    }
  }
}
