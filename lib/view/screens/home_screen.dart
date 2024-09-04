import 'package:arabic_font/arabic_font.dart';
import 'package:family/utilities/classes/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:family/app_links.dart';
import 'package:family/controller/home_controller.dart';
// import 'package:family/utilities/classes/custom_buttom.dart';
import 'package:family/utilities/classes/custom_text.dart';
import 'package:family/utilities/constants/app_colors.dart';
import 'package:family/view/screens/setting_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final outerController = Get.find<HomeController>();
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0.0,
        toolbarHeight: 120,
        flexibleSpace: ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Container(
            height: 150,
            width: Get.width,
            color: AppColors.primary,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(
                  flex: 1,
                ),
                CustomText(
                  text: "الرئيسيــة",
                  fontFamily: ArabicFont.avenirArabic,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  colorText: AppColors.secondary,
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Get.to(() => const SettingScreen(),
                          duration: const Duration(milliseconds: 550),
                          curve: Curves.ease,
                          transition: Transition.upToDown);
                    },
                    icon: const Icon(
                      Icons.settings,
                      size: 35,
                      color: AppColors.whiteColor,
                    ))
              ],
            )),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            InputField(
              controller: outerController.search,
              label: "بحــث",
              hint: "بحــث",
              // isNumber: false,
              onChanged: (val) => outerController.filterCategory(val),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Obx(() {
                if (outerController.remoteState.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  outerController.allCategory.value =
                      outerController.remoteState.serviceState;

                  return outerController.allCategory.isEmpty
                      ? Center(
                          child: CustomText(
                            text: "لا توجـــد بيانــات",
                            fontSize: 20,
                            fontFamily: ArabicFont.avenirArabic,
                            colorContainer: AppColors.secondary,
                          ),
                        )
                      : GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 20,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          children: List.generate(
                              outerController.allCategory.length, (index) {
                            return InkWell(
                              onTap: () {
                                outerController.sectionServiceViewScreen(
                                    id: outerController
                                        .remoteState.serviceState[index].id,
                                    name: outerController
                                        .remoteState.serviceState[index].name,
                                    index: 0);
                              },
                              child: Container(
                                  width: Get.width / 2 - 150,
                                  height: Get.width / 2 - 50,
                                  clipBehavior: Clip.hardEdge,
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: AppColors.grayColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        bottomRight: Radius.circular(30)),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: Container(
                                          width: Get.width,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              color: AppColors.red,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Image.network(
                                            "${AppLinks.upload}/${outerController.allCategory[index].url}",
                                            // width: 200,

                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          child: Container(
                                            color: AppColors.primary,
                                            // alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            child: CustomText(
                                              text: outerController
                                                  .allCategory[index].name!,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              colorContainer: AppColors.primary,
                                              colorText: AppColors.whiteColor,

                                              // alignment: Alignment.bottomCenter,
                                              width: Get.width,
                                            ),
                                          )),
                                    ],
                                  )),
                            );
                          }),
                        );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
