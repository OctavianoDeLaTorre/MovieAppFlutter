

import 'package:flutter/material.dart';
import 'package:peliculas/models/movie.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate{

  @override
  String? get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
   return IconButton(
     icon: Icon(Icons.arrow_back),
     onPressed: (){
       close(context, null);
     },
   );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
   
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context,listen: false);
    moviesProvider.getSuggetionsByQuerty(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionsStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot){

        if (snapshot.hasData){
          final movies = snapshot.data;
          
          return ListView.builder(
            itemCount: movies!.length,
            itemBuilder: (_, int position){
              return _MovieItem(movie: movies[position]);
            }
          );

        }

        return _emptyContainer();
      }
    );
  }

  Widget _emptyContainer(){
    return Container(
        child: Center(
          child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 140,),
        ),
      );
  }

}

class _MovieItem extends StatelessWidget {
  
  final Movie movie;

  const _MovieItem({required this.movie});

  @override
  Widget build(BuildContext context) {

    movie.heroId = 'search-${movie.id}';

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
          child: Hero(
            tag: movie.heroId!,
            child: FadeInImage(
              height: 65,
              width: 35,
            placeholder: AssetImage('assets/no-image.jpg'), 
            image: NetworkImage(movie.fullPosterImg),
            fit: BoxFit.cover,
                ),
          ),
      ),
      title: Text(movie.title!),
      onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
    );
  }
}