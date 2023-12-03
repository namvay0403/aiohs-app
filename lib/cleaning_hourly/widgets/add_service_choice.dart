import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmservice/cleaning_hourly/constants/cleaning_hourly_const.dart';
import 'package:rmservice/cleaning_hourly/cubits/caculate_price/caculate_price_cubit.dart';
import 'package:rmservice/cleaning_hourly/cubits/save_info/save_info.dart';
import 'package:rmservice/utilities/constants/variable.dart';

class AddServiceChoice extends StatefulWidget {
  const AddServiceChoice({super.key, required this.isDarkMode});

  final bool isDarkMode;

  @override
  State<AddServiceChoice> createState() => _AddServiceChoiceState();
}

class _AddServiceChoiceState extends State<AddServiceChoice> {
  @override
  Widget build(BuildContext context) {
    var infoCleaningHourlyCubit = context.read<SaveInfoCleaningHourlyCubit>();
    List<bool> isCheck = [
      infoCleaningHourlyCubit.state.cooking!,
      infoCleaningHourlyCubit.state.iron!,
      infoCleaningHourlyCubit.state.bringTool!
    ];
    List<AddServiceClass> listAddService = getListAddService(context);

    return Wrap(
      runSpacing: 14,
      children: List<Widget>.generate(
        listAddService.length - 1,
        (int index) {
          return InkWell(
            onTap: () {
              setState(
                () {
                  isCheck[index] == true
                      ? isCheck[index] = false
                      : isCheck[index] = true;
                  switch (index) {
                    case 0:
                      context
                          .read<SaveInfoCleaningHourlyCubit>()
                          .updateCooking(isCheck[index]);
                      break;

                    case 1:
                      context
                          .read<SaveInfoCleaningHourlyCubit>()
                          .updateIron(isCheck[index]);
                      break;

                    case 2:
                      context
                          .read<SaveInfoCleaningHourlyCubit>()
                          .updateBringTool(isCheck[index]);
                      break;
                  }
                },
              );
              context
                  .read<CaculatePriceCleaningHourlyCubit>()
                  .caculatePrice(context.read<SaveInfoCleaningHourlyCubit>().state);
              debugPrint("Selected ${index}: ${isCheck[index]}");

              debugPrint(context
                  .read<SaveInfoCleaningHourlyCubit>()
                  .state
                  .toJson()
                  .toString());
            },
            child: Ink(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                  width: 0.5,
                ),
                color: isCheck[index]
                    ? colorProject.primaryColor
                    : Colors.transparent,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 13),
                        Icon(
                          size: 30,
                          listAddService[index].icon,
                          color: isCheck[index]
                              ? Colors.white
                              : (widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        SizedBox(width: 10),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          listAddService[index].name!,
                          style: TextStyle(
                            fontFamily: fontApp,
                            fontSize: fontSize.medium,
                            color: isCheck[index]
                                ? Colors.white
                                : (widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          overflow: TextOverflow.ellipsis,
                          listAddService[index].action!,
                          style: TextStyle(
                            fontFamily: fontApp,
                            fontSize: fontSize.medium,
                            color: isCheck[index]
                                ? Colors.white
                                : (widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                        SizedBox(width: 13)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
