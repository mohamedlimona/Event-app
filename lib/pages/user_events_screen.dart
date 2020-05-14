import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_event_item.dart';
import '../widgets/app_drawer.dart';
import './edit_event_screen.dart';

class UsereventsScreen extends StatelessWidget {
  static const routeName = '/user-events';

  Future<void> _refreshevents(BuildContext context) async {
    await Provider.of<Events>(context, listen: false)
        .fetchAndSetEvents(true);
  }

  @override
  Widget build(BuildContext context) {
    // final eventsData = Provider.of<events>(context);
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xff023429),
        title: const Text('My Events'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditEventScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshevents(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshevents(context),
                    child: Consumer<Events>(
                      builder: (ctx, eventsData, _) => Padding(
                            padding: EdgeInsets.all(8),
                            child: ListView.builder(
                              itemCount: eventsData.items.length,
                              itemBuilder: (_, i) => Column(
                                    children: [
                                      UsereventItem(
                                        eventsData.items[i].id,
                                        eventsData.items[i].title,
                                        eventsData.items[i].imageUrl,
                                      ),
                                      Divider(),
                                    ],
                                  ),
                            ),
                          ),
                    ),
                  ),
      ),
    );
  }
}
