import 'package:flutter_movies/src/movies_feature/models/movie.dart';

class Movies {
  final int page;
  final int totalPages;
  final int totalResults;
  final List<Movie> list;

  Movies(this.page, this.totalPages, this.totalResults, this.list);

  Movies.fromJson(Map<String, dynamic> json)
      : page = json['page'] as int,
        totalPages = json['total_pages'] as int,
        totalResults = json['total_results'] as int,
        list = List<dynamic>.from(json['results'])
            .map((i) => Movie.fromJson(i))
            .toList();
}
