import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rmservice/shopping/cubits/caculate_price/caculate_price_cubit.dart';
import 'package:rmservice/shopping/cubits/save_data.dart';
import 'package:rmservice/shopping/cubits/save_price_shopping.dart';
import 'package:rmservice/utilities/constants/variable.dart';

class PickDateWork extends StatefulWidget {
  const PickDateWork({super.key, required this.isDarkMode});

  final bool isDarkMode;

  @override
  State<PickDateWork> createState() => _PickDateWorkState();
}

class _PickDateWorkState extends State<PickDateWork> {
  final items = List<DateTime>.generate(
      7, (i) => DateTime.now().add(Duration(days: i + 1)));
  int value = 0;

  @override
  Widget build(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;

    return Container(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List<Widget>.generate(
          items.length,
          (int index) {
            return Row(
              children: [
                ChoiceChip(
                  selectedColor: colorProject.primaryColor,
                  labelStyle: TextStyle(
                    color: value == index
                        ? Colors.white
                        : (widget.isDarkMode ? Colors.white : Colors.black),
                  ),
                  showCheckmark: false,
                  selected: index == value,
                  onSelected: (bool selected) {
                    setState(() {
                      value = selected ? index : 0;
                    });
                    context.read<SaveDataShopping>().state.date = items[index];
                    context.read<CalculatePriceShoppingCubit>().calculatePrice(
                        context.read<SaveDataShopping>().state,
                        context.read<SavePriceShopping>().state);
                    debugPrint("Selected ${index}: ${items[index].toString()}");
                  },
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.MMM(locale).format(items[index]).toString(),
                        style: TextStyle(
                          fontFamily: fontApp,
                          fontSize: fontSize.medium,
                        ),
                      ),
                      Text(
                        DateFormat('dd').format(items[index]).toString(),
                        style: TextStyle(
                          fontFamily: fontBoldApp,
                          fontSize: fontSize.large,
                        ),
                      ),
                      Text(
                        DateFormat.E(locale).format(items[index]).toString(),
                        style: TextStyle(
                          fontFamily: fontApp,
                          fontSize: fontSize.medium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10)
              ],
            );
          },
        ),
      ),
    );
  }
}
