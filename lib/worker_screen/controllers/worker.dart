import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rmservice/history/models/order.dart';
import 'package:rmservice/utilities/constants/variable.dart';
import 'package:rmservice/worker_screen/models/order_result.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: debugServer,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500;
    },
  ),
);

class WorkerController {
  Future<OrderResult> getOrderPublic(
    String userCode,
    int next, {
    num? distance,
    String? city,
    String? district,
    String? productCode,
  }) async {
    try {
      final response = await dio.get(
        '/user/$userCode/orders/public',
        queryParameters: {
          "distance": distance,
          "limit": 15,
          "next": next,
          "city": city,
          "district": district,
          "product_code": productCode,
        },
      );
      await Future.delayed(const Duration(milliseconds: 800));
      if (response.data['code'] == 0) {
        List<Order> orders = [];
        orders = (response.data['orders'] as List)
            .map((e) => Order.fromJson(e))
            .toList();

        debugPrint(orders.length.toString());

        print(
            "-------------------------------------------------------------------------------");
        print('data reponse: ${response.data}');
        print(
            "-------------------------------------------------------------------------------");

        return OrderResult(orders, int.tryParse(response.data['next'])!);
      } else {
        throw response.data['message'];
      }
    } on DioException catch (e) {
      debugPrint(e.type.toString());
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        throw 'Connection Timeout';
      }

      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError) {
        throw 'Internet Error or Server Error';
      }
      debugPrint(e.type.toString());
      throw 'Server Error';
    }
  }

  Future<OrderResult> getOrderMaidAccepted(String userCode, String next) async {
    try {
      final response = await dio.get(
        '/user/$userCode/orders',
        queryParameters: {
          "limit": 15,
          "next": next,
          "status": 'ORDER_STATUS_MAID_ACCEPTED',
          "search_role_type": 'maid'
        },
      );
      await Future.delayed(const Duration(milliseconds: 800));
      if (response.data['code'] == 0) {
        List<Order> orders = [];
        orders = (response.data['orders'] as List)
            .map((e) => Order.fromJson(e))
            .toList();

        debugPrint(orders.length.toString());

        print(
            "-------------------------------------------------------------------------------");
        print('data reponse: ${response.data}');
        print(
            "-------------------------------------------------------------------------------");

        return OrderResult(orders, int.tryParse(response.data['next'])!);
      } else {
        throw response.data['message'];
      }
    } on DioException catch (e) {
      debugPrint(e.type.toString());
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        throw 'Connection Timeout';
      }

      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError) {
        throw 'Internet Error or Server Error';
      }
      debugPrint(e.type.toString());
      throw 'Server Error';
    }
  }

  Future<OrderResult> getOrderMaidCompleted(
      String userCode, String next) async {
    try {
      final response = await dio.get(
        '/user/$userCode/orders',
        queryParameters: {
          "limit": 15,
          "next": next,
          "status": 'ORDER_STATUS_DONE',
          "search_role_type": 'maid'
        },
      );
      await Future.delayed(const Duration(milliseconds: 800));
      if (response.data['code'] == 0) {
        List<Order> orders = [];
        orders = (response.data['orders'] as List)
            .map((e) => Order.fromJson(e))
            .toList();

        debugPrint(orders.length.toString());

        print(
            "-------------------------------------------------------------------------------");
        print('data reponse: ${response.data}');
        print(
            "-------------------------------------------------------------------------------");

        return OrderResult(orders, int.tryParse(response.data['next'])!);
      } else {
        throw response.data['message'];
      }
    } on DioException catch (e) {
      debugPrint(e.type.toString());
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        throw 'Connection Timeout';
      }

      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError) {
        throw 'Internet Error or Server Error';
      }
      debugPrint(e.type.toString());
      throw 'Server Error';
    }
  }

  Future<OrderResult> getOrderMaidCancelled(
      String userCode, String next) async {
    try {
      final response = await dio.get(
        '/user/$userCode/orders',
        queryParameters: {
          "limit": 15,
          "next": next,
          "status": 'ORDER_STATUS_CANCELED',
          "search_role_type": 'maid'
        },
      );
      await Future.delayed(const Duration(milliseconds: 800));
      if (response.data['code'] == 0) {
        List<Order> orders = [];
        orders = (response.data['orders'] as List)
            .map((e) => Order.fromJson(e))
            .toList();

        debugPrint(orders.length.toString());

        print(
            "-------------------------------------------------------------------------------");
        print('data reponse: ${response.data}');
        print(
            "-------------------------------------------------------------------------------");

        return OrderResult(orders, int.tryParse(response.data['next'])!);
      } else {
        throw response.data['message'];
      }
    } on DioException catch (e) {
      debugPrint(e.type.toString());
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        throw 'Connection Timeout';
      }

      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError) {
        throw 'Internet Error or Server Error';
      }
      debugPrint(e.type.toString());
      throw 'Server Error';
    }
  }

  Future<void> acceptedOrder(String orderCode, String userCode) async {
    try {
      final response =
          await dio.get('/user/$userCode/orders/$orderCode/accepts');
      await Future.delayed(const Duration(milliseconds: 800));
      if (response.data['code'] == 0) {
        return;
      } else {
        String message = jsonEncode(response.data['message']);
        throw message;
      }
    } on DioException catch (e) {
      debugPrint(e.type.toString());
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        throw 'Connection Timeout';
      }

      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError) {
        throw 'Internet Error or Server Error';
      }
      debugPrint(e.type.toString());
      throw 'Server Error';
    }
  }
}
