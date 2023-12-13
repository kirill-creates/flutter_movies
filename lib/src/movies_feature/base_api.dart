import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/movies.dart';

class BaseAPI {
  static const _apiKey = 'afd546f1dc614c6c19a53dab9ce71f6f';
  static const _moviesListUrl = 'https://api.themoviedb.org/3/discover/movie';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w200';
  static const _bigImageUrl = 'https://image.tmdb.org/t/p/w400';

  BaseAPI();

  Map<String, String> get headers => {
        "accept": "application/json",
      };

  String bigImageUrl(String url) {
    return _bigImageUrl + url;
  }

  String imageUrl(String url) {
    return _imageUrl + url;
  }

  Future<Movies> fetchMovies(int page) async {
    try {
      final response = await http.get(
          Uri.parse("$_moviesListUrl?api_key=$_apiKey&page=$page"),
          headers: headers);

      switch (response.statusCode) {
        case 200:
          return Movies.fromJson(
              jsonDecode(response.body) as Map<String, dynamic>);

        default:
          throw Exception('Failed to load Movies');
      }
    } on Exception catch (_) {
      // make it explicit that this function can throw exceptions
      rethrow;
    }
  }
}
