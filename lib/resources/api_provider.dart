import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_aej_news/resources/ItemModel.dart';

class ApiProvider {

  final String _baseUrl = "https://hacker-news.firebaseio.com/v0";

  Dio _getDio() {
    BaseOptions options = new BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: 50000,
      receiveTimeout: 30000,
    );
    Dio dio = new Dio(options);
    dio.interceptors.addAll(<Interceptor>[_loggingInterceptor()]);

    return dio;
  }


  Future<List<int>> fetchTopIds() async {
    Response response = await _getDio().get("/topstories.json?print=pretty");
    return response.data.cast<int>();
  }


  Future<ItemModel> fetchItem(int id) async {
    final response = await _getDio().get("/item/$id.json");

    return ItemModel.fromJson(response.data);
  }


  Interceptor _loggingInterceptor() {
    return InterceptorsWrapper(onRequest: (RequestOptions options) {
      // Do something before request is sent
      debugPrint("\n"
          "Request ${options.uri} \n"
          "-- headers --\n"
          "${options.headers.toString()} \n"
          "-- payload --\n"
          "${jsonEncode(options.data)} \n"
          "");

      return options; //continue
      // If you want to resolve the request with some custom data，
      // you can return a `Response` object or return `dio.resolve(data)`.
      // If you want to reject the request with a error message,
      // you can return a `DioError` object or return `dio.reject(errMsg)`
    }, onResponse: (Response response) {
      // Do something with response data
      debugPrint("\n"
          "Response ${response.request.uri} \n"
          "-- headers --\n"
          "${response.headers.toString()} \n"
          "-- payload --\n"
          "${jsonEncode(response.data)} \n"
          "");
      return response; // continue
    }, onError: (DioError e) {
      // Do something with response error
      return e; //continue
    });
  }


}