import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/event_item.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
class FavoritePage extends StatefulWidget {
  const FavoritePage({Key key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final eventsdata = Provider.of<Events>(context);
    final events = eventsdata.favoriteItems;
    return Scaffold(appBar: AppBar(
      title: Text('Favourite'), backgroundColor: Color(0xff023429),
    ), drawer: AppDrawer(),body: SingleChildScrollView(
      child: Container(
        child: ListView.builder(physics: const NeverScrollableScrollPhysics(),scrollDirection: Axis.vertical,shrinkWrap: true,
          padding: const EdgeInsets.all(10.0),
          itemCount: events.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            value: events[i],
            child:EventItem(),
          ),
        ),
      ),
    ));
  }
}

