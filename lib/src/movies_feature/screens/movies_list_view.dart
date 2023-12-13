import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

import '../../settings/settings_view.dart';
import '../common/common_widgets.dart';
import '../models/movies.dart';
import '../models/movie.dart';
import '../base_api.dart';

import 'movie_details_view.dart';

/// Displays a list of Movies.
class MoviesListView extends StatefulWidget {
  static const routeName = '/';

  final BaseAPI baseAPI;

  const MoviesListView({
    super.key,
    required this.baseAPI,
  });

  @override
  State<MoviesListView> createState() => _MoviesListViewState();
}

class _MoviesListViewState extends State<MoviesListView> {
  final Connectivity _connectivity = Connectivity();

  List<Movie> _moviesList = [];
  List<Movie> _filteredMoviesList = [];
  String _filterQuery = "";
  int _currentPage = 1;

  bool _isFetching = false;

  void _filterList(String query) {
    setState(() {
      _filterQuery = query;
      _filteredMoviesList = _moviesList
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showNoInternet() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
              'Please check your internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshMoviesList() async {
    _currentPage = 1;
    _moviesList = [];
    _filteredMoviesList = [];
    return _fetchMoviesList();
  }

  Future<void> _fetchMoviesList() async {
    if (_isFetching) {
      return;
    }

    setState(() {
      _isFetching = true;
    });

    var connectivityResult = await _connectivity.checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      Movies movies = await widget.baseAPI.fetchMovies(_currentPage);

      setState(() {
        _moviesList.addAll(movies.list);
        _isFetching = false;
        _currentPage++;
        _filterList(_filterQuery);
      });
    } else {
      _showNoInternet();
      setState(() {
        _isFetching = false;
      });
    }
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _fetchMoviesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Movies",
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              )),
          actions: [
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.restorablePushNamed(
                      context, SettingsView.routeName);
                })
          ]),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (query) => _filterList(query),
            decoration: const InputDecoration(
              labelText: 'Search',
              hintText: 'Type to filter...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () {
              return _refreshMoviesList();
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollEndNotification &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    scrollInfo.metrics.pixels != 0) {
                  _fetchMoviesList();
                }
                return false;
              },
              child: ListView.builder(
                restorationId: 'moviesListView',
                // +1 for the loading indicator
                itemCount: _filteredMoviesList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == _filteredMoviesList.length) {
                    return _buildLoadingIndicator();
                  } else {
                    final movie = _filteredMoviesList[index];
                    final posterUrl =
                        widget.baseAPI.imageUrl(movie.posterPath ?? "");
                    return MovieCard(
                      movie: movie,
                      posterUrl: posterUrl,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsView(
                              baseAPI: widget.baseAPI,
                              movie: movie,
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
