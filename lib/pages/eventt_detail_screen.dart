import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class eventDetailScreen extends StatelessWidget {
  static const routeName = '/event-detail';

  @override
  Widget build(BuildContext context) {
    final eventId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedevent = Provider.of<Events>(
      context,
      listen: false,
    ).findById(eventId);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: loadedevent.id,
                child: Image.network(
                  loadedevent.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [SizedBox(height: 20,),
                Center(
                  child: Text(loadedevent.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,fontWeight: FontWeight.bold
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
               Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[Icon(Icons.timer),SizedBox(width: 4,), Text(
                 '${loadedevent.datetime}',
                 style: TextStyle(
                     color: Colors.black,
                     fontSize: 30,
                 ),
                 textAlign: TextAlign.center,
               ),],),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                      width: 280.00,
                      height: 180.00,
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: NetworkImage(loadedevent.barcodeurl),
                          fit: BoxFit.fill,
                        ),
                      )),
                ),SizedBox(height: 15,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedevent.description,style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                    softWrap: true,

                  ),
                ),
                SizedBox(
                  height: 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
