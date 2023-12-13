import 'package:flutter/material.dart';
//import 'package:photo_view/photo_view.dart';

import '../models/movie.dart';
import '../base_api.dart';

class MovieDetailsView extends StatelessWidget {
  final Movie movie;
  final BaseAPI baseAPI;

  static const routeName = '/movie_details';

  const MovieDetailsView({
    super.key,
    required this.baseAPI,
    required this.movie,
  });

  // PhotoView(
  //         imageProvider:
  //             NetworkImage(baseAPI.bigImageUrl(movie.posterPath ?? "")),
  //         minScale: PhotoViewComputedScale.contained * 0.8,
  //         maxScale: PhotoViewComputedScale.covered * 2,
  //         backgroundDecoration: const BoxDecoration(
  //           color: Color.fromARGB(31, 0, 0, 0),
  //         ),
  //       )

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                baseAPI.bigImageUrl(movie.posterPath ?? ""),
                height: 800.0,
                width: double.infinity,
                fit: BoxFit.fitHeight,
              ),
              const SizedBox(height: 22.0),
              Center(
                child: Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Center(
                child: Text('Release Date: ${movie.releaseDate}'),
              ),
              const SizedBox(height: 8.0),
              Center(
                child: Text(
                  movie.overview ?? "",
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
