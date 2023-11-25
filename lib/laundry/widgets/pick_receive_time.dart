import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rmservice/laundry/cubits/save_info_laundry_cubit.dart';
import 'package:rmservice/utilities/constants/variable.dart';

class PickReceiveTime extends StatefulWidget {
  const PickReceiveTime({super.key, required this.isDarkMode});

  final bool isDarkMode;

  @override
  State<PickReceiveTime> createState() => _PickReceiveTimeState();
}

class _PickReceiveTimeState extends State<PickReceiveTime> {
  @override
  Widget build(BuildContext context) {
    TimeOfDay? time =
        TimeOfDay.fromDateTime(context.read<SaveInfoLaundryCubit>().state.receiveTime ?? DateTime.now());

    DateTime timeChoose = DateTime(1969, 1, 1, time.hour, time.minute);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            "Vui lòng chọn giờ cộng tác viên trả đồ",
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white : Colors.black,
              fontFamily: fontApp,
              fontSize: fontSize.medium,
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            TimeOfDay? newTime = await showTimePicker(
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    primaryColor: colorProject.primaryColor,
                    colorScheme: widget.isDarkMode
                        ? ColorScheme.dark(
                            primary: colorProject.primaryColor,
                          )
                        : ColorScheme.light(
                            primary: colorProject.primaryColor,
                          ),
                    buttonTheme: ButtonThemeData(),
                  ),
                  child: child!,
                );
              },
              context: context,
              initialTime: time!,
            );
            if (newTime != null) {
              setState(() {
                time = newTime;
                timeChoose = DateTime(1969, 1, 1, time!.hour, time!.minute);
              });
              context.read<SaveInfoLaundryCubit>().updateReceiveTime(timeChoose);
              debugPrint(context
                  .read<SaveInfoLaundryCubit>()
                  .state
                  .receiveTime.toString());
            }
          },
          child: Ink(
            width: 100,
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.isDarkMode ? Colors.white : Colors.black,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(15),
              color: Colors.transparent,
            ),
            child: Center(
              child: Text(
                DateFormat('Hm').format(timeChoose),
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                  fontFamily: fontBoldApp,
                  fontSize: fontSize.large,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
