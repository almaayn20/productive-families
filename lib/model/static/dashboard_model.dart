import 'package:flutter/material.dart';

class DashBoardModel {
  final String? label;
  final IconData? icon;
  const DashBoardModel({this.label, this.icon});
}

class DashBoardData {
  static const user = [
    DashBoardModel(label: "بيانات الأســرة"),
    DashBoardModel(label: "المنتجــات"),
    DashBoardModel(label: "إضـافة منتـجات"),
    DashBoardModel(label: "الحجوزات النشطـة"),
    DashBoardModel(label: "الحجوزات المنفذة"),
  ];
  static const admin = [
    DashBoardModel(label: "الأصنــاف"),
    DashBoardModel(label: "إضـافة أصنــاف"),
    DashBoardModel(label: "المــدراء"),
    DashBoardModel(label: "العمــلاء الغير مفعلين"),
    DashBoardModel(label: "العمــلاء المفعلين"),
  ];
}
