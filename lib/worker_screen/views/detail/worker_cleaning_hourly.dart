import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmservice/history/models/cleaning_hourly_history.dart';
import 'package:rmservice/history/widgets/cleaning_hourly/location_info.dart';
import 'package:rmservice/history/widgets/cleaning_hourly/maid_info.dart';
import 'package:rmservice/history/widgets/cleaning_hourly/work_info.dart';
import 'package:rmservice/login/cubit/user_cubit.dart';
import 'package:rmservice/utilities/components/button_green.dart';
import 'package:rmservice/utilities/components/text_label.dart';
import 'package:rmservice/utilities/constants/variable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rmservice/utilities/dialog/dialog.dart';
import 'package:rmservice/worker_screen/controllers/worker.dart';

class WorkerCleaingHourly extends StatefulWidget {
  const WorkerCleaingHourly({super.key, required this.order});

  final CleaningHourlyHistory order;

  @override
  State<WorkerCleaingHourly> createState() => _WorkerCleaingHourlyState();
}

class _WorkerCleaingHourlyState extends State<WorkerCleaingHourly> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chi tiết đơn - Giúp việc theo giờ",
          style: TextStyle(
            fontFamily: fontBoldApp,
            fontSize: fontSize.mediumLarger,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 17),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextLabel(
                      label: "Thông tin chung",
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            HistoryLocationInfoCleaningHourly(
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
              child: HistoryInfoCleaningHourly(
                isDarkMode: isDarkMode,
                order: widget.order,
              ),
            ),
            if (widget.order.maid_name != "")
              Padding(
                padding: const EdgeInsets.only(top: 17),
                child: TextLabel(
                  label: "Thông tin người giúp việc",
                  isDarkMode: isDarkMode,
                ),
              ),
            if (widget.order.maid_code != "")
              Padding(
                padding: const EdgeInsets.only(top: 17),
                child: HistoryMaidInfoCleaningHourly(
                  isDarkMode: isDarkMode,
                  order: widget.order,
                ),
              ),
            if (widget.order.maid_code == "") SizedBox(height: 15),
            if (widget.order.maid_code == "")
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
                      await WorkerController().acceptedOrder(widget.order.code,
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
                          isMultipleButton: false);
                    }
                  }),
            if (widget.order.maid_code == context.read<UserCubit>().state.code)
              SizedBox(height: 15),

            if (widget.order.maid_code == context.read<UserCubit>().state.code)
              ButtonGreenApp(label: "Hủy đơn này", onPressed: null),
            if (widget.order.maid_code == context.read<UserCubit>().state.code)
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
          ],
        ),
      ),
    );
  }
}