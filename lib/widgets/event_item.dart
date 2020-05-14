import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/auth.dart';
import '../pages/eventt_detail_screen.dart';

class EventItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final event = Provider.of<Event>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return InkWell(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width - 10,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          margin: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 10,
                      height: 200,
                      child: FadeInImage(
                        image: NetworkImage(event.imageUrl),
                        placeholder: AssetImage(''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(height: 50,
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      width: MediaQuery.of(context).size.width - 20,
                      color: Colors.black54,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              event.title,
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                            Consumer<Event>(
                              builder: (ctx, e, _) => IconButton(
                                icon: Icon(
                                  e.isFavorite ? Icons.favorite : Icons.favorite_border,
                                ),
                                color: Colors.deepOrange,
                                onPressed: () {
                                  e.toggleFavoriteStatus(
                                    authData.token,
                                    authData.userId,
                                  );
                                },
                              ),
                            ),
                          ]),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 4),
                          child: Icon(
                            Icons.schedule,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          event.datetime,
                          style: TextStyle(fontSize: 20),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: MaterialButton(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            color: Theme.of(context).primaryColor,
                            splashColor: Colors.grey,
                            onPressed: () { Navigator.of(context).pushNamed(
                              eventDetailScreen.routeName,
                              arguments: event.id,
                            );},
                            minWidth: 80.0,
                            height: 35.0,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Book',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Icon(
                                    Icons.fast_forward,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
