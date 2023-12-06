import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmservice/history/models/cooking_history.dart';
import 'package:rmservice/history/widgets/cooking/location_info_cooking.dart';
import 'package:rmservice/history/widgets/cooking/maid_info.dart';
import 'package:rmservice/history/widgets/cooking/work_info_cooking.dart';
import 'package:rmservice/login/cubit/user_cubit.dart';
import 'package:rmservice/utilities/components/button_green.dart';
import 'package:rmservice/utilities/components/text_label.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rmservice/utilities/constants/variable.dart';
import 'package:rmservice/utilities/dialog/dialog.dart';
import 'package:rmservice/worker_screen/controllers/worker.dart';

class WorkerCookingHistoryDetail extends StatefulWidget {
  const WorkerCookingHistoryDetail({super.key, required this.order});

  final CookingHistory order;

  @override
  State<WorkerCookingHistoryDetail> createState() =>
      _WorkerCookingHistoryDetailState();
}

class _WorkerCookingHistoryDetailState
    extends State<WorkerCookingHistoryDetail> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chi tiết đơn - Nấu ăn",
          style: TextStyle(
            fontFamily: fontBoldApp,
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
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextLabel(
                      label: AppLocalizations.of(context)!.locationLabel,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            HistoryLocationInfoCooking(
              isDarkMode: isDarkMode,
              order: widget.order,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 17),
              child: TextLabel(
                label: AppLocalizations.of(context)!.workingInfoLabel,
                isDarkMode: isDarkMode,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 17),
              child: HistoryInfoCooking(
                isDarkMode: isDarkMode,
                order: widget.order,
              ),
            ),
            if (widget.order.orderCooking.maidCode != "")
              Padding(
                padding: const EdgeInsets.only(top: 17),
                child: TextLabel(
                  label: "Thông tin người giúp việc",
                  isDarkMode: isDarkMode,
                ),
              ),
            if (widget.order.orderCooking.maidCode != "")
              Padding(
                padding: const EdgeInsets.only(top: 17),
                child: HistoryMaidInfoCooking(
                  isDarkMode: isDarkMode,
                  order: widget.order,
                ),
              ),
            if (widget.order.orderCooking.maidCode == "") SizedBox(height: 15),
            if (widget.order.orderCooking.maidCode == "")
              ButtonGreenApp(
                label: "Nhận đơn này",
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  try {
                    await WorkerController().acceptedOrder(
                        widget.order.orderCooking.code,
                        context.read<UserCubit>().state.code!);
                    Navigator.pop(context);
                    showCustomDialog(
                        context: context,
                        dialogType: CustomDialogType.SUCCESS,
                        msg: "Bạn đã nhận đơn này",
                        isMultipleButton: false);
                  } catch (e) {
                    Navigator.pop(context);
                    showCustomDialog(
                      context: context,
                      dialogType: CustomDialogType.FAILURE,
                      msg: e.toString(),
                      isMultipleButton: false,
                    );
                  }
                },
              ),
            if (widget.order.orderCooking.maidCode ==
                context.read<UserCubit>().state.code)
              SizedBox(height: 15),

            if (widget.order.orderCooking.maidCode ==
                context.read<UserCubit>().state.code)
              ButtonGreenApp(label: "Hủy đơn này", onPressed: null),
            if (widget.order.orderCooking.maidCode ==
                context.read<UserCubit>().state.code)
              SizedBox(height: 15),

            // Padding(
            //   padding: const EdgeInsets.only(top: 17),
            //   child: TextLabel(
            //     label: 'Phương thức thanh toán',
            //     isDarkMode: isDarkMode,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 17),
            //   child: MethodPaymentCleaningHourly(
            //     isDarkMode: isDarkMode,
            //   ),
            // ),
            SizedBox(height: 8)
          ],
        ),
      ),
    );
  }
}
