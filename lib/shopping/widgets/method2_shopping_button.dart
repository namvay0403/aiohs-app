import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rmservice/shopping/cubits/save_data.dart';
import 'package:rmservice/shopping/views/shopping_step2.dart';
import 'package:rmservice/shopping/views/shopping_step3_M2.dart';
import 'package:rmservice/utilities/constants/app_assets.dart';
import 'package:rmservice/utilities/constants/variable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Methoad2ShoppingButton extends StatefulWidget {
  const Methoad2ShoppingButton({super.key});

  @override
  State<Methoad2ShoppingButton> createState() => _Methoad2ShoppingButtonState();
}

class _Methoad2ShoppingButtonState extends State<Methoad2ShoppingButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        context.read<SaveDataShopping>().state.methodOfShpping = 2;
        Navigator.push(
          context,
          PageTransition(
            duration: Duration(milliseconds: 400),
            type: PageTransitionType.rightToLeftWithFade,
            child: ShoppingStep3Method2Screen(),
            childCurrent: ShoppingStep2Screen(),
          ),
        );
        debugPrint("Select Method 2");
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: const Color.fromARGB(172, 172, 172, 172), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .shoppingStep2Method2Title,
                          style: TextStyle(
                            fontSize: fontSize.mediumLarger,
                            fontFamily: fontBoldApp,
                            color: colorProject.primaryColor,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "- ${AppLocalizations.of(context)!.shoppingStep2Method2Sub1}",
                          style: TextStyle(
                            fontSize: fontSize.medium,
                            fontFamily: fontApp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Image.asset(
                  AppAssets.shoppingM2,
                  scale: 4,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppAssets.shoppingM3,
                  scale: 4,
                ),
                SizedBox(width: 15),
                Container(
                  child: Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          "- ${AppLocalizations.of(context)!.shoppingStep2Method2Sub2}",
                          style: TextStyle(
                            fontSize: fontSize.medium,
                            fontFamily: fontApp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: new BoxDecoration(
                  color: colorProject.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_forward_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
