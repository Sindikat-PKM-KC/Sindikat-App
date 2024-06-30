import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import 'package:sindikat_app/app/modules/home/views/home_view.dart';
import 'package:sindikat_app/app/modules/playground/views/playground_view.dart';
import 'package:sindikat_app/app/modules/settings/views/settings_view.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';

import '../controllers/navbar_controller.dart';

class NavbarView extends GetView<NavbarController> {
  const NavbarView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavbarController>(builder: (controller) {
      return Scaffold(
        body: FadeIndexedStack(
          beginOpacity: 0.0,
          endOpacity: 1.0,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 200),
          index: controller.tabIndex,
          children: const [
            HomeView(),
            SettingsView(),
            PlaygroundView(),
          ],
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            enableFeedback: true,
            backgroundColor: AppColors.secondaryColor,
            selectedItemColor: AppColors.white,
            unselectedItemColor: AppColors.white,
            selectedFontSize: 12,
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex,
            showUnselectedLabels: false,
            showSelectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            items: const [
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.home),
                icon: Icon(
                  Icons.home_outlined,
                  color: AppColors.white,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.settings),
                icon: Icon(
                  Icons.settings_outlined,
                  color: AppColors.white,
                ),
                label: 'Settings',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.bug_report),
                icon: Icon(
                  Icons.bug_report_outlined,
                  color: AppColors.white,
                ),
                label: 'Playground',
              ),
            ],
          ),
        ),
      );
    });
  }
}
