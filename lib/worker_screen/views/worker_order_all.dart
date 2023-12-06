import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmservice/login/cubit/user_cubit.dart';
import 'package:rmservice/utilities/components/button_green.dart';
import 'package:rmservice/utilities/components/dialog_wrong.dart';
import 'package:rmservice/utilities/components/text_field_basic.dart';
import 'package:rmservice/utilities/components/text_label.dart';
import 'package:rmservice/utilities/components/text_sub_label.dart';
import 'package:rmservice/utilities/constants/variable.dart';
import 'package:rmservice/worker_screen/cubits/get_order_all/get_order_all_cubit.dart';
import 'package:rmservice/worker_screen/cubits/get_order_all/get_order_all_state.dart';
import 'package:rmservice/worker_screen/widgets/worker_order_card.dart';

class WorkerOrderAll extends StatefulWidget {
  const WorkerOrderAll({super.key});

  @override
  State<WorkerOrderAll> createState() => _WorkerOrderAllState();
}

class _WorkerOrderAllState extends State<WorkerOrderAll> {
  double distance = 5;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context
        .read<WorkerGetOrderAllCubit>()
        .getOrderAll(distance, context.read<UserCubit>().state.code!);
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        //the bottom of the scrollbar is reached
        //adding more widgets
        context
            .read<WorkerGetOrderAllCubit>()
            .getOrderAll(distance, context.read<UserCubit>().state.code!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    var workerGetOrderAll = context.watch<WorkerGetOrderAllCubit>();
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextSubLabel(
                label: "Bạn muốn tìm việc trong khoảng: ",
                isDarkMode: isDarkMode,
              ),
              Text(
                distance.toString() + " km",
                style: TextStyle(
                  fontFamily: fontBoldApp,
                  fontSize: fontSize.medium,
                ),
              ),
              SizedBox(width: 5),
              InkWell(
                child: Icon(
                  Icons.filter_list,
                  color: colorProject.primaryColor,
                  size: 30,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: changeDistance(isDarkMode),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: workerGetOrderAll is WorkerGetOrderAllError
                ? Center(child: Text("Đã có lỗi xảy ra"))
                : SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        for (int i = 0;
                            i < workerGetOrderAll.orders.length;
                            i++)
                          WorkerOrderCard(order: workerGetOrderAll.orders[i]),
                        //loading
                        BlocBuilder<WorkerGetOrderAllCubit,
                            WorkerGetOrderAllState>(builder: (context, state) {
                          if (state is WorkerGetOrderAllLoading) {
                            return Align(
                              alignment: FractionalOffset.topCenter,
                              child: CircularProgressIndicator(
                                color: colorProject.primaryColor,
                              ),
                            );
                          }
                          return Container();
                        }),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget changeDistance(bool isDarkMode) {
    TextEditingController controller = TextEditingController();
    controller.text = distance.toString();
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextLabel(label: "Thay đổi khoảng cách", isDarkMode: isDarkMode),
          SizedBox(height: 20),
          TextFieldBasic(
            controller: controller,
            isDarkMode: isDarkMode,
            hintText: "Khoảng cách (km)",
          ),
          SizedBox(height: 20),
          ButtonGreenApp(
            label: "Đồng ý",
            onPressed: () {
              if (double.tryParse(controller.text) == null ||
                  double.tryParse(controller.text)! <= 0) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogWrong(
                      notification: "Khoảng cách phải là số và lớn hơn không",
                    );
                  },
                );
              } else {
                setState(() {
                  distance = double.tryParse(controller.text)!;
                });
                Navigator.pop(context);
                context.read<WorkerGetOrderAllCubit>().reset();
                context.read<WorkerGetOrderAllCubit>().getOrderAll(
                    distance, context.read<UserCubit>().state.code!);
              }
            },
          )
        ],
      ),
    );
  }
}