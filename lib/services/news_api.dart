import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newsapp/consts/http_excepptions.dart';

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
}
