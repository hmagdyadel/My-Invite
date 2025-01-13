import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions.dart';
import '../../../../core/theming/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _animateLanguageChange(BuildContext context) async {
    // Store the language code before the async gap
    final String newCode = context.locale.languageCode == 'en' ? 'ar' : 'en';

    await _controller.forward();
    if (!mounted) return;  // Check if widget is still mounted

     AppUtilities().setLocality(newCode);
    if (!mounted) return;  // Check again after the async operation

    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: edge,vertical: edge*0.5),
              child: SubTitleText(
                text: 'settings'.tr(),
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            const Divider(
              height: 24,
              color: bgColorOverlay,
            ),
            SizedBox(height: edge),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: edge),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: bgColorOverlay,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    languageButton(context),
                    const Divider(
                      height: 0,
                      color: bgColor,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget languageButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _animateLanguageChange(context),
        child: Padding(
          padding: EdgeInsets.all(edge),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: NormalText(
                    text: 'changeLanguage'.tr(),
                    color: Colors.white,
                    fontSize: 18,
                    align: TextAlign.start,
                  ),
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SubTitleText(
                  text: context.locale.languageCode == 'en' ? 'عربي' : 'English',
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}