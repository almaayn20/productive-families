import 'package:arabic_font/arabic_font.dart';
import 'package:family/binding/home_binding.dart';
import 'package:family/binding/login_binding.dart';
import 'package:family/utilities/classes/custom_buttom.dart';
import 'package:family/utilities/constants/app_colors.dart';
import 'package:family/view/screens/home_screen.dart';
import 'package:family/view/screens/login_screen.dart';
import 'package:family/view/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDecided extends StatelessWidget {
  const UserDecided({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: DAppBar(
        title: "الأســـر المنتجــة",
        back: AppColors.primary101,
        front: AppColors.primary,
        isHasSetting: false,
        height: 230,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
           
            ...List.generate(
                2,
                (index) => CustomButton(
                      onPressed: () {
                        if (index == 0) {
                          Get.to(() => const HomeScreen(),
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.ease,
                              transition: Transition.zoom,
                              opaque: true,
                              binding: HomeBinding());
                        } else {
                          Get.to(
                            () => const LoginScreen(), //const Dashboard(),
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.ease,
                            transition: Transition.leftToRight,
                            binding: LoginBinding(),
                          );
                        }
                      },
                      text: index == 0 ? " زائــر" : " حسـاب أعمـال",
                      radius: 12,

                      buttonColor: AppColors.primary,
                      textColor: AppColors.secondary,
                      margin: const EdgeInsets.symmetric(
                          vertical: 17, horizontal: 35),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      fontSize: 22,
                      fontFamily: ArabicFont.dinNextLTArabic,
                      
                      fontWeight: FontWeight.bold,
                    ))
          ],
        ),
      ),
    );
  }
}
