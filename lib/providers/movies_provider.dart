
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/credits_response.dart';
import 'package:peliculas/models/movie.dart';
import 'package:peliculas/models/now_playing_response.dart';
import 'package:peliculas/models/popular_response.dart';
import 'package:peliculas/models/search_respose.dart';


class MoviesProvider extends ChangeNotifier {

  String _apiKey   = 'b618405444270ee9703734613c47a0a9';
  String _baseUrl  = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> onDisplayMovie = [];
  List<Movie> popularMOvies = [];

  Map<int,List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 400),
  );

  final StreamController<List<Movie>> _suggestionsStreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionsStream => this._suggestionsStreamController.stream;


  MoviesProvider(){
    print('Movies provider');
    getOnDisplayMovies();
    getPopularsMovies();
  }

  Future<String> _getJsonData(String endPoint, {int page = 1}) async {
      final url = Uri.https(
      _baseUrl, 
      endPoint, 
      {
        'api_key': _apiKey,
        'language': _language,
        'page': '$page'
      }

    );

   final response = await http.get(url);

   return response.body;
  }
  

  getOnDisplayMovies() async {
   final response = await _getJsonData('3/movie/now_playing');
   final nowPlayingResponse = NowPlayingResponse.fromJson(response);
    onDisplayMovie= nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularsMovies() async {
    _popularPage++;
   final response = await _getJsonData('3/movie/popular',page: _popularPage);
   final popularsResponse = PopularResponse.fromJson(response);
    popularMOvies = [...popularMOvies, ...popularsResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {

     if (moviesCast.containsKey(movieId)) {
       return moviesCast[movieId]!;
     }

     final response = await _getJsonData('3/movie/$movieId/credits',page: _popularPage);
     final creditsResponse = CreditsResponse.fromJson(response);
     moviesCast[movieId] = creditsResponse.cast;
     return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies( String query) async {
     final url = Uri.https(
      _baseUrl, 
      '3/search/movie', 
      {
        'api_key': _apiKey,
        'language': _language,
        'query': '$query'
      }

    );

   final response = await http.get(url);
   final searchResponse = SearchResponse.fromJson(response.body);

   return searchResponse.results;

  }


  void getSuggetionsByQuerty(String query){
    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      final result = await this.searchMovies(value);
      this._suggestionsStreamController.add(result);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      debouncer.value = query;
     });

     Future.delayed(Duration(milliseconds: 3001)).then((value) => timer.cancel());
  }

}