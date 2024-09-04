import 'package:family/model/remote/api_model.dart';
import 'package:family/utilities/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:family/app_links.dart';
import 'package:family/binding/dashboard_binding.dart';
import 'package:family/model/remote/api_data.dart';
import 'package:family/model/remote/remote_state.dart';
import 'package:family/utilities/classes/custom_dialog.dart';
import 'package:family/utilities/functions/api_function.dart';
import 'package:family/utilities/functions/status_request.dart';
import 'package:family/utilities/services/app_services.dart';
import 'package:family/view/screens/dashboard.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  final remoteState = RemoteState();
  final user = TextEditingController();
  final pass = TextEditingController();
  final loginKey = GlobalKey<FormState>();
  final api = ApiData(Get.find<Crud>());
  final storageService = Get.find<AppService>();
  final storage = AppService.getStorage;
  bool isEnablePassword = true;

  void login() async {
    if (loginKey.currentState!.validate()) {
      isLoading.value = true;
      StatusRequest.loading;
      final data = await remoteState.api.respone(
          "${AppLinks.user}?op_type=login&user_name=${user.text}&user_password=${pass.text}",
          isSignUp: true);

      if (data != null) {
        if (data.isEmpty) {
          CustomAlertDialog.showSnackBar(
              "تـأكد من اســم المستخــدم أو كلمـة المرور",
              size: 18,
              color: AppColors.red);
          isLoading.value = false;

          return;
        }
        if (data[0]["user_state"] == 0) {
          CustomAlertDialog.showSnackBar(
              "اســم المستخـدم لم يتـم تفعليه بعـد!.",
              size: 18);
          isLoading.value = false;

          return;
        }
        final dataFamily = await remoteState.api.respone(
            "${AppLinks.givenService}?op_type=select2&user_id=${data[0]["user_id"]}",
            isSignUp: true);
        await storage!.write("userType", data[0]["user_type"]);
        await storage!.write("userName", data[0]["user_name"]);
        await storage!.write("userID", data[0]["user_id"]);
        // await storage!.write("userID", data[0]["user_id"]);
        // await storage!.write("userID", data[0]["user_id"]);
        await storage!.write("allow", data[0]["allowAdd"]);
        await storage!.write("familyID", dataFamily?[0]["family_id"]);

        await storage!.write("family", {
          'family_id': dataFamily?[0]["family_id"],
          'user_id': dataFamily?[0]["user_id"],
          'family_address': dataFamily?[0]["family_address"],
          'family_name': dataFamily?[0]["family_name"],
          'family_phone': dataFamily?[0]["family_phone"],
        });
        isLoading.value = false;
        Future.delayed(const Duration(seconds: 2), () async {
          await navigateToLoginScreen();
        });
      } else {
        CustomAlertDialog.showSnackBar(
          "تـأكد من اســم المستخــدم أو كلمـة المرور",
          size: 18,
        );
        isLoading.value = false;

        return;
      }
    }
  }

  void enablePassword() {
    isEnablePassword = !isEnablePassword;
    update();
  }

  Future<void> navigateToLoginScreen() async {
    await Get.offAll(() => const Dashboard(),
        duration: const Duration(milliseconds: 400),
        curve: Curves.ease,
        transition: Transition.leftToRightWithFade,
        binding: DashboardBinding());
  }

  TextEditingController listOfController(int index) {
    final controller = [user, pass];
    return controller[index];
  }
}
