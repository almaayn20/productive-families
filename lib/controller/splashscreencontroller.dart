import 'package:family/binding/dashboard_binding.dart';
import 'package:family/view/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:family/view/screens/user_decided.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void onInit() {
    animationInitilization();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    toAnotherPage();
  }

  animationInitilization() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut)
            .obs
            .value;
    animation.addListener(() => update());
    animationController.forward();
    // await toAnotherPage();
  }

  toAnotherPage() async {
    await Future.delayed(const Duration(seconds: 4), () async {
      if (GetStorage().read('userID') != null) {
        await Get.offAll(() => const Dashboard(),
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease,
            transition: Transition.leftToRightWithFade,
            binding: DashboardBinding());
      } else {
        Get.to(
          transition: Transition.upToDown,
          curve: Curves.ease,
          duration: const Duration(milliseconds: 600),
          () => const UserDecided(),
          // binding: OnBoardingBinding()
        );
      }
    });
  }
}
