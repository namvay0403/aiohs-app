import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rmservice/cleaning_longterm/cubit/order_cleaning_longterm/order_cleaning_longterm_cubit.dart';
import 'package:rmservice/cleaning_longterm/cubit/save_info_cubit.dart';
import 'package:rmservice/cleaning_longterm/widgets/work_info_long_term.dart';
import 'package:rmservice/utilities/constants/variable.dart';

import '../../cleaning_hourly/widgets/location_info.dart';
import '../../cleaning_hourly/widgets/method_payment.dart';
import '../../cleaning_hourly/widgets/show_bottom_edit_name_phone.dart';
import '../../utilities/components/text_label.dart';
import '../../utilities/dialog/dialog.dart';
import '../widgets/button_next_step2.dart';
import '../widgets/method_payment.dart';

class CleaningLongTermStep2 extends StatefulWidget {
  const CleaningLongTermStep2({super.key});

  @override
  State<CleaningLongTermStep2> createState() => _CleaningLongTermStep2State();
}

class _CleaningLongTermStep2State extends State<CleaningLongTermStep2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(
        'End Data is: ${context.read<SaveInfoCleaningLongTermCubit>().state.toJson().toString()}');
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return BlocListener<OrderCleaningLongtermCubit, OrderCleaningLongtermState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is OrderCleaningLongtermSuccess) {
          debugPrint('OrderCleaningLongTermSuccess');
          Navigator.pop(context);
          context.read<OrderCleaningLongtermCubit>().setInit();
          showCustomDialog(
            context: context,
            dialogType: CustomDialogType.SUCCESS,
            msg: 'Order SuccessFully',
            isMultipleButton: false,
          );
        }
        if (state is OrderCleaningLongtermFailed) {
          debugPrint(state.message);
          Navigator.pop(context);
          context.read<OrderCleaningLongtermCubit>().setInit();
          showCustomDialog(
            context: context,
            dialogType: CustomDialogType.FAILURE,
            msg: state.message,
            isMultipleButton: false,
          );
        }
        if (state is OrderCleaningLongtermLoading) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return PopScope(
                canPop: false,
                child: AlertDialog(
                  content: Container(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: colorProject.primaryColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            'Xác nhận và thanh toán',
            style: TextStyle(
              fontSize: fontSize.mediumLarger,
              color: isDarkMode ? Colors.white : Colors.black,
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
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => colorProject.primaryColor,
                        ),
                      ),
                      icon: Icon(color: Colors.white, Icons.edit),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (builder) {
                            return BottomEditNamePhone(isDarkMode: isDarkMode);
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
              LocationInfoCleaningHourly(
                isDarkMode: isDarkMode,
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
                child: WorkInfoCleaningLongTerm(
                  isDarkMode: isDarkMode,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17),
                child: TextLabel(
                  label: 'Phương thức thanh toán',
                  isDarkMode: isDarkMode,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17),
                child: MethodPayment(
                  isDarkMode: isDarkMode,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        floatingActionButton: const ButtonNextStep2(),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
      ),
    );
  }
}
