import 'package:flutter/material.dart';
import 'package:peliculas/models/movie.dart';
import 'package:peliculas/widgets/casting_cards.dart';

class DetailsScreen extends StatelessWidget {

 @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(movie:movie),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(movie:movie),
              SizedBox(height: 10,),
              CastingCards(movie.id!),
              _OverView(movie:movie),
            ])
          ),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {

  final Movie movie;

  _CustomAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.pink,
      expandedHeight: 250,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          color: Colors.black12,
          padding: EdgeInsets.only(left: 10,right: 10),
          child: Text(
            movie.title!,
            style: TextStyle(
              fontSize: 16
            ),
          )
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullBackDropPath), 
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {

  final Movie movie;

  _PosterAndTitle({required this.movie});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg), 
                fit: BoxFit.cover,
                height: 150,
                width: 110,
              ),
            ),
          ),

          SizedBox(width: 20,),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width - 190),
                child: Text(movie.title!, 
                style: Theme.of(context).textTheme.headline5,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                          ),
              ),

            Text(movie.originalLanguage!, 
              style: Theme.of(context).textTheme.subtitle1,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),

            Row(
              children: [
                Icon(Icons.star_outline),
                SizedBox(width: 5,),
                Text('${movie.voteAverage!}',  style: Theme.of(context).textTheme.caption,)
              ],
            )

            ],
          )
        ],
      ),
    );
  }
}


class _OverView extends StatelessWidget {

  final Movie movie;

  _OverView({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview!,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}    