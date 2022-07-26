import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:newsapp/consts/http_excepptions.dart';
import 'package:newsapp/models/bookmark_model.dart';

import '../consts/api_consts.dart';
import '../models/news_model.dart';

class NewsAPiServices {
  static Future<List<NewsModel>> getAllNews(
      {required int page, required String sortBy}) async {
    //
    // var url = Uri.parse(
    //     'https://newsapi.org/v2/everything?q=bitcoin&pageSize=5&apiKey=');

    try {
      var uri = Uri.https(BASEURL, "v2/everything", {
        "q": "bitcoin",
        "pageSize": "5",
        "domains": "bbc.co.uk,techcrunch.com,engadget.com",
        "page": page.toString(), // "apiKEY": API_KEY
        "sortBy": sortBy
      });
      var response = await http.get(
        uri,
        headers: {"X-Api-key": API_KEY},
      );
      // print('Response status: ${response.statusCode}');
      // log('Response body: ${response.body}');
      Map data = jsonDecode(response.body);
      List newsTempList = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
        // throw data['message'];
      }
      for (var v in data["articles"]) {
        newsTempList.add(v);
        // log(v.toString());
        // print(data["articles"].length.toString());

      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<List<NewsModel>> getTopHeadLines() async {
    try {
      var uri = Uri.https(BASEURL, "v2/top-headlines", {'country': 'us'});
      var response = await http.get(
        uri,
        headers: {"X-Api-key": API_KEY},
      );
      // print('Response status: ${response.statusCode}');
      // log('Response body: ${response.body}');
      Map data = jsonDecode(response.body);
      List newsTempList = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
        // throw data['message'];
      }
      for (var v in data["articles"]) {
        newsTempList.add(v);
        // log(v.toString());
        // print(data["articles"].length.toString());

      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<List<NewsModel>> searchNews({required String query}) async {
    try {
      var uri = Uri.https(BASEURL, "v2/everything", {
        "q": query,
        "pageSize": "10",
        "domains": "bbc.co.uk,techcrunch.com,engadget.com",
      });
      var response = await http.get(
        uri,
        headers: {"X-Api-key": API_KEY},
      );
      // print('Response status: ${response.statusCode}');
      // log('Response body: ${response.body}');
      Map data = jsonDecode(response.body);
      List newsTempList = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
        // throw data['message'];
      }
      for (var v in data["articles"]) {
        newsTempList.add(v);
        // log(v.toString());
        // print(data["articles"].length.toString());

      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<List<BookmarksModel>?> getBookmarks() async {
    try {
      var uri = Uri.https(BASEURL_FIREBASE, "bookmarks.json");
      var response = await http.get(
        uri,
      );
      // log('Response status: ${response.statusCode}');
      // log('Response body :${response.body}');

      Map data = jsonDecode(response.body);
      List allKeys = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
        // throw data['message'];
      }
      for (String key in data.keys) {
        allKeys.add(key);
      }
      log("allKeys $allKeys");
      return BookmarksModel.bookmarkFromSnapshot(json: data, allKeys: allKeys);
    } catch (error) {
      rethrow;
    }
  }
}
