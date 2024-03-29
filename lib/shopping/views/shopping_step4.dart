import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:rmservice/cleaning_hourly/widgets/notice_step2.dart';
import 'package:rmservice/shopping/cubits/save_data.dart';
import 'package:rmservice/utilities/components/text_label.dart';
import 'package:rmservice/utilities/components/text_sub_label.dart';
import 'package:rmservice/shopping/widgets/floating_step4.dart';
import 'package:rmservice/shopping/widgets/note_for_maid.dart';
import 'package:rmservice/shopping/widgets/pick_date_work.dart';
import 'package:rmservice/shopping/widgets/pick_time_work.dart';
import 'package:rmservice/utilities/constants/variable.dart';

class ShoppingStep4Screen extends StatefulWidget {
  const ShoppingStep4Screen({super.key});

  @override
  State<ShoppingStep4Screen> createState() => _ShoppingStep4ScreenState();
}

class _ShoppingStep4ScreenState extends State<ShoppingStep4Screen> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    var infoShopping = context.read<SaveDataShopping>().state;
    bool isDarkMode = brightness == Brightness.dark;
    NumberFormat formatter =
        NumberFormat.simpleCurrency(locale: 'vi-VN', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.shoppingStep4Title,
          style: TextStyle(
            fontSize: fontSize.mediumLarger,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 90),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 17),
              child: TextLabel(
                label: "Thời gian giao hàng",
                isDarkMode: isDarkMode,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: TextSubLabel(
                label: "Vui lòng chọn ngày giao hàng (trong vòng 7 ngày)",
                isDarkMode: isDarkMode,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: PickDateWork(
                isDarkMode: isDarkMode,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: PickTimeWork(
                isDarkMode: isDarkMode,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 15),
                child: NoticeStep2(
                  isDarkMode: isDarkMode,
                )),
            Padding(
              padding: const EdgeInsets.only(top: 17),
              child: TextLabel(
                label: AppLocalizations.of(context)!.noticeForMaidLabel,
                isDarkMode: isDarkMode,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: NoteForMaid(
                isDarkMode: isDarkMode,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Text(
                '* Giá bên dưới đã bao gồm phí mua hàng (${formatter.format(infoShopping.purchaseFee)}) và phụ thu.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: fontSize.medium,
                  fontFamily: fontApp,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingStep4(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
