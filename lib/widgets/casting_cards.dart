import 'package:flutter/material.dart';
import 'package:peliculas/models/credits_response.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {

  final int movieId;

  const CastingCards(this.movieId);

  @override
  Widget build(BuildContext context) {

   final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

   return FutureBuilder(
     future: moviesProvider.getMovieCast(movieId),
     builder: (_, AsyncSnapshot<List<Cast>> snapshot) {

       if (!snapshot.hasData){
          return Container(
            constraints: BoxConstraints(maxWidth: 50),
              width:50,
              height: 50,
              child: CircularProgressIndicator(),
          );
       }

       final List<Cast> cast = snapshot.data!;

          return Container(
              width: double.infinity,
              height: 100,
              child:Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cast.length,
                  itemBuilder: (BuildContext cotext, int position){
                    return _CastCard( actor: cast[position] );
                  }
                ),
              ),
            );

     },
   );
  }
}


class _CastCard extends StatelessWidget {

  final Cast actor; 

  _CastCard({required this.actor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePath), 
              fit: BoxFit.cover,
              height: 75,
              width: 75,
            ),
          ),

          Text(
            actor.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}