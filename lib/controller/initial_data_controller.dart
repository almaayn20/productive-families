import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:family/app_links.dart';
import 'package:family/model/remote/api_model.dart';
import 'package:family/model/remote/remote_state.dart';
import 'package:family/utilities/functions/status_request.dart';
import 'package:family/utilities/services/app_services.dart';

class InitialDataControllrt extends GetxController {
  final remoteState = RemoteState();
  late TextEditingController name;
  late TextEditingController address;
  late TextEditingController phone;
  final initialDataKey = GlobalKey<FormState>();
  late String serviceID;
  int? userID;
  final storage = AppService.getStorage;
  Family? existFamily;
  @override
  void onInit() {
    super.onInit();
    var temp = storage!.read('family');
    existFamily = temp == null ? null : Family.fromjson(temp);
    name = TextEditingController(
        text: existFamily != null ? existFamily!.name! : null);
    address = TextEditingController(
        text: existFamily != null ? existFamily!.address! : null);
    phone = TextEditingController(
        text: existFamily != null ? existFamily!.phone! : null);
    fetchData();
    checkFromUser();
  }

  void login() async {
    if (initialDataKey.currentState!.validate()) {
      StatusRequest.loading;
      if (existFamily == null || existFamily!.id == 0) {
        final data = await remoteState.api.request(
            AppLinks.givenService,
            {
              "op_type": "insert",
              "family_name": name.text,
              "family_address": address.text,
              "family_phone": phone.text,
              "user_id": userID.toString(),
            },
            label: "عملية الاضافة");
        log("DATA...${data}");
        await storage!.write("familyID", data![1]);
      } else {
        final data = await remoteState.api.request(
            AppLinks.givenService,
            {
              "op_type": "update",
              "family_name": name.text,
              "family_address": address.text,
              "family_phone": phone.text,
              'family_id': existFamily!.id.toString(),
              "user_id": userID.toString(),
            },
            label: "عملية الاضافة");
        log("DATA...${data}");
        await storage!.write("familyID", existFamily!.id);
        var tempUpdate = Family(
            address: address.text,
            phone: phone.text,
            id: existFamily!.id,
            name: name.text,
            userID: userID);
        await storage!.write("family", tempUpdate.toJson());
      }
    }
  }

  TextEditingController listOfController(int index) {
    final controller = [name, address, phone];
    return controller[index];
  }

  void checkFromUser() async {
    if (storage!.read("userID") != null) {
      userID = storage!.read("userID");

      log("${storage!.read("userID")}");
      update();
    }
  }

  List<String> listOfDataService() {
    return remoteState.getNames(remoteState.serviceState);
  }

  void fetchData() async {
    remoteState.serviceState.clear();
    remoteState.isLoading(true);
    try {
      final response =
          await remoteState.api.respone("${AppLinks.service}?op_type=select");
      if (response != null) {
        remoteState.serviceState
            .addAll(response.map((e) => Catagory.fromjson(e)).toList());
        remoteState.serviceState.refresh();
      }
    } finally {
      remoteState.isLoading(false);
    }
  }
}
