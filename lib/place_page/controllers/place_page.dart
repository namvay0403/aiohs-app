import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rmservice/place_page/models/rental_place.dart';
import 'package:rmservice/place_page/models/rental_place_res.dart';
import 'package:rmservice/place_page/models/rental_place_result.dart';
import 'package:rmservice/utilities/constants/function.dart';
import 'package:rmservice/utilities/constants/variable.dart';

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

class PlacePageController {
  Future<void> createPlaceRental(
      RentalPlace rentalPlace, String userCode, List<File> imagesFile) async {
    try {
      List<String> images = [];
      for (var i = 0; i < imagesFile.length; i++) {
        String path = await uploadImage(imagesFile[i]);
        images.add(path);
      }
      rentalPlace.images = images;
      print(rentalPlace.toJson().toString());

      var response = await dio.post(
        '/user/$userCode/area-booking/create',
        data: rentalPlace.toJson(),
      );
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
    } catch (e) {
      debugPrint(e.toString());
      throw e.toString();
    }
  }

  Future<List<RentalPlaceRes>> getRental(String userCode) async {
    try {
      var response = await dio.get(
        '/user/$userCode/area-booking',
      );
      await Future.delayed(const Duration(milliseconds: 800));
      if (response.data['code'] == 0) {
        List<RentalPlaceRes> rentalPlaceRes = (response.data['posts'] as List)
            .map((e) => RentalPlaceRes.fromJson(e))
            .toList();
        return rentalPlaceRes;
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

  Future<List<RentalPlaceRes>> getRentalInactive(String userCode) async {
    try {
      var response =
          await dio.get('/user/$userCode/area-booking', queryParameters: {
        'status': 'AREA_BOOKING_STATUS_INACTIVE',
      });
      await Future.delayed(const Duration(milliseconds: 800));
      if (response.data['code'] == 0) {
        List<RentalPlaceRes> rentalPlaceRes = (response.data['posts'] as List)
            .map((e) => RentalPlaceRes.fromJson(e))
            .toList();
        return rentalPlaceRes;
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

  Future<RentalPlaceResult> getRentalPublic(
    String userCode,
    String next,
    double? distance,
    String? city,
    String? district,
  ) async {
    try {
      var response = await dio
          .get('/user/$userCode/area-booking/public', queryParameters: {
        "next": next,
        "limit": 10,
        "distance": distance,
        "city": city,
        "district": district,
      });
      await Future.delayed(const Duration(milliseconds: 800));
      if (response.data['code'] == 0) {
        List<RentalPlaceRes> rentalPlaceRes = (response.data['posts'] as List)
            .map((e) => RentalPlaceRes.fromJson(e))
            .toList();
        String next = response.data['next'];
        return RentalPlaceResult(next: next, rentalPlaceRes: rentalPlaceRes);
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

  Future<void> updateRental(RentalPlace rentalPlace, String code,
      String userCode, List<File> imagesFile) async {
    try {
      List<String> images = [];
      for (var i = 0; i < imagesFile.length; i++) {
        String path = await uploadImage(imagesFile[i]);
        images.add(path);
      }
      rentalPlace.images = images;
      var response = await dio.post(
        '/user/$userCode/area-booking/$code/update',
        data: jsonEncode(rentalPlace),
      );
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

  Future<void> cancelRental(RentalPlaceRes rentalPlace, String userCode) async {
    try {
      var response = await dio
          .get('/user/$userCode/area-booking/${rentalPlace.code}/close');
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
