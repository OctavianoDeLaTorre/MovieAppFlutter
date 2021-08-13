import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:peliculas/models/movie.dart';

class CardSwiper extends StatelessWidget {
  
  final List<Movie> movies;

  const CardSwiper({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    if (movies.length == 0){
      return Container(
        width: double.infinity,
        height: size.height * 0.6,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(top: size.height * 0.07, bottom:size.height * 0.07 ),
      width: double.infinity,
      height: size.height * 0.6,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.9,
        itemBuilder: (BuildContext context, int position){
          
          final movie = movies[position];
          movie.heroId = 'swiper-${movie.id}';

          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage(movie.fullPosterImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}