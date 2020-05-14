import 'package:carousel_pro/carousel_pro.dart';
import 'package:eventful_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/events_list.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Events>(context).fetchAndSetEvents().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _username = Provider.of<Auth>(context, listen: false).username;
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: Color(0xff023429),
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      right: 15,
                      left: 15,
                    ),
                    child: Text(
                      'HI $_username',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      right: 15,
                      left: 15,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  Container(
                    height: 220,
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      child: Carousel(
                        images: [
                          ExactAssetImage(
                            "assets/images/event1.jpeg",
                          ),
                          ExactAssetImage(
                            "assets/images/event2.jpeg",
                          ),
                          ExactAssetImage(
                            "assets/images/event3.jpeg",
                          ),
                          ExactAssetImage(
                            "assets/images/event4.jpeg",
                          ),
                        ],
                        showIndicator: true,
                        animationDuration: Duration(seconds: 2),
                        dotSize: 4.0,
                        dotSpacing: 15.0,
                        dotColor: Colors.white,
                        autoplay: true,
                        indicatorBgPadding: 5.0,
                        borderRadius: true,
                        onImageChange: (_, __) {},
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : eventslist(),
              ),
            ],
          ),
        ));
  }
}
