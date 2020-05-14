import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/event_item.dart';
import '../providers/products.dart';

class eventslist extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final eventsdata = Provider.of<Events>(context);
    final events = eventsdata.items;
    return ListView.builder(physics: const NeverScrollableScrollPhysics(),scrollDirection: Axis.vertical,shrinkWrap: true,
      padding: const EdgeInsets.all(10.0),
      itemCount: events.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: events[i],
        child:EventItem(),
      ),
    );

  }

}
