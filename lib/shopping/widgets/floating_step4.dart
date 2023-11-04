import 'package:datetime_setting/datetime_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rmservice/shopping/cubits/save_data.dart';
import 'package:rmservice/shopping/views/shopping_step4.dart';
import 'package:rmservice/shopping/views/shopping_step5.dart';
import 'package:rmservice/shopping/widgets/dialog_wrong.dart';
import 'package:rmservice/utilities/components/button_green.dart';
import 'package:rmservice/utilities/constants/variable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FloatingStep4 extends StatefulWidget {
  const FloatingStep4({super.key});

  @override
  State<FloatingStep4> createState() => _FloatingStep4State();
}

class _FloatingStep4State extends State<FloatingStep4> {
  int time6Hours = 6 * 60;
  int time22Hours = 22 * 60;

  @override
  Widget build(BuildContext context) {
    final date = context.read<SaveDataShopping>().state.date;
    final time = context.read<SaveDataShopping>().state.time;

    int timeToInt = time!.hour * 60 + time.minute;
    int timeEnd = time22Hours;

    debugPrint(timeToInt.toString() + ' ' + timeEnd.toString());

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            NumberFormat.simpleCurrency(locale: 'vi-VN', decimalDigits: 0)
                .format(context.watch<SaveDataShopping>().state.price),
            style: TextStyle(
              fontFamily: fontBoldApp,
              fontSize: fontSize.mediumLarger + 1,
              color: colorProject.primaryColor,
            ),
          ),
          ButtonGreenApp(
            label: AppLocalizations.of(context)!.nextLabel,
            onPressed: () async {
              if (await DatetimeSetting.timeIsAuto() == false ||
                  await DatetimeSetting.timeZoneIsAuto() == false) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogWrong(
                      notification:
                          "Vui lòng lựa chọn giờ và múi giờ tự động trên thiết bị",
                    );
                  },
                );
                return;
              }
              if (context.read<SaveDataShopping>().state.time!.hour * 60 +
                          context.read<SaveDataShopping>().state.time!.minute <
                      time6Hours ||
                  context.read<SaveDataShopping>().state.time!.hour * 60 +
                          context.read<SaveDataShopping>().state.time!.minute >
                      time22Hours) {
                debugPrint("Vui lòng chọn giờ làm việc từ 06:00 tới " +
                    (22).toString() +
                    " giờ");
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogWrong(
                      notification:
                          "Vui lòng chọn giờ làm việc từ 06:00 tới ${(22).toString()}:00",
                    );
                  },
                );
                return;
              }
              Navigator.push(
                context,
                PageTransition(
                  duration: Duration(milliseconds: 400),
                  type: PageTransitionType.rightToLeftWithFade,
                  child: ShoppingStep5Screen(),
                  childCurrent: ShoppingStep4Screen(),
                ),
              );

              debugPrint(
                  context.read<SaveDataShopping>().state.toJson().toString());
            },
          ),
        ],
      ),
    );
  }
}