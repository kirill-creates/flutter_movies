class Movie {
  int id = -1;
  String title;
  String? overview;
  String? releaseDate;
  String? posterPath;

  Movie(this.id, this.title, this.overview, this.releaseDate, this.posterPath);

  Movie.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'] ?? "",
        overview = json['overview'],
        releaseDate = json['release_date'],
        posterPath = json['poster_path'];
}
