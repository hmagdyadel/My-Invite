
import 'package:flutter/material.dart';

import '../dimensions/dimensions.dart';


class LocaleDropdown extends StatefulWidget {
  const LocaleDropdown({super.key});

  @override
  State<LocaleDropdown> createState() => _LocaleDropdownState();
}

class _LocaleDropdownState extends State<LocaleDropdown> {

  Locale locale = const Locale('en','US');

  @override
  void initState() {
    super.initState();
    getSelectedLocale();
  }

  getSelectedLocale() async{
    //locale =  AppUtilities().getDeviceLanguage();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        selectLanguage();
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            image: DecorationImage(
                image:
                locale == const Locale('en','US') ?
                const AssetImage("assets/images/usflag.png")
                    : const AssetImage("assets/images/saflag.png"),
                fit: BoxFit.cover)),
      ),
    );
  }

  void selectLanguage() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return FittedBox(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding:  EdgeInsets.all(edge),
              child: Column(
                children: [
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                        if(locale == const Locale('en','US')) return;
                       // await changeLocale();
                        getSelectedLocale();
                      },
                      child: Row(
                        children: [
                          Image.asset("assets/images/usflag.png", fit: BoxFit.cover, width: 24, height: 24,),
                          const SizedBox(width: 6,),
                          //Text("English", style: paragraph1.copyWith(color: bgColor),)
                        ],
                      )
                  ),
                  TextButton(
                      onPressed: () async{
                        Navigator.of(context, rootNavigator: true).pop();
                        if(locale == const Locale('ar','AR')) return;
                        //await changeLocale();
                        getSelectedLocale();
                      },
                      child: Row(
                        children: [
                          Image.asset("assets/images/saflag.png", fit: BoxFit.cover, width: 24, height: 24,),
                          const SizedBox(width: 6,),
                          //Text("عربي", style: paragraph1.copyWith(color: bgColor),)
                        ],
                      )
                  ),
                ],
              ),
            ),
          );
        });
  }
}
