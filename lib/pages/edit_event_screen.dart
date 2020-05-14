import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class EditEventScreen extends StatefulWidget {
  static const routeName = '/edit-Event';

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _startFocusNode = FocusNode();
  final _endFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  DateTime _selesteddateTime;
  var _editedEvent = Event(
    id: null,
    title: '',
    datetime: '',
    description: '',
    imageUrl: '',
    barcodeurl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'datetime': '',
    'imageUrl': '',
    'barcodeurl': '',
  };
  var _isInit = true;
  var _isLoading = false;
  File _storedImage;
  File _storedbarcode;
  String barcodeurl;
  String imagurl;
  DateFormat dateFormat = DateFormat('dd-MM-yyyy hh:mm a');
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final EventId = ModalRoute.of(context).settings.arguments as String;
      if (EventId != null) {
        _editedEvent =
            Provider.of<Events>(context, listen: false).findById(EventId);
        _initValues = {
          'title': _editedEvent.title,
          'description': _editedEvent.description,
          'datetime': _editedEvent.datetime.toString(),
          'imageUrl': _editedEvent.imageUrl,
          'barcodeurl': _editedEvent.barcodeurl,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _startFocusNode.dispose();
    _endFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_storedImage == null) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred!'),
          content: Text('Please choose event image'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    if (_storedbarcode == null) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred!'),
          content: Text('Please choose event image'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Events>(context, listen: false).uploadimage(
          _storedImage, _storedbarcode, _editedEvent, _editedEvent.id);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  Future<void> _getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source, maxWidth: 400.0);
    setState(() {
      _storedImage = image;
    });
    Navigator.pop(context);
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(children: [
              Text(
                'Pick an Image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Use Camera'),
                onPressed: () {
                  _getImage(ImageSource.camera);
                },
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Use Gallery'),
                onPressed: () {
                  _getImage(ImageSource.gallery);
                },
              )
            ]),
          );
        });
  }

  Future<void> _getbarcode(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source, maxWidth: 400.0);
    setState(() {
      _storedbarcode = image;
    });
    Navigator.pop(context);
  }

  void _openbarcodePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(children: [
              Text(
                'Pick an Image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Use Camera'),
                onPressed: () {
                  _getImage(ImageSource.camera);
                },
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Use Gallery'),
                onPressed: () {
                  _getbarcode(ImageSource.gallery);
                },
              )
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_startFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedEvent = Event(
                            title: value,
                            datetime: _editedEvent.datetime,
                            description: _editedEvent.description,
                            imageUrl: imagurl,
                            barcodeurl: barcodeurl,
                            id: _editedEvent.id,
                            isFavorite: _editedEvent.isFavorite);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              onChanged: (date) {}, onConfirm: (date) {
                            setState(() {
                              _selesteddateTime = date;
                            });
                            _editedEvent = Event(
                                title: _editedEvent.title,
                                datetime: dateFormat.format(_selesteddateTime),
                                description: _editedEvent.description,
                                imageUrl: imagurl,
                                barcodeurl: barcodeurl,
                                id: _editedEvent.id,
                                isFavorite: _editedEvent.isFavorite);
                          }, currentTime: DateTime.now());
                        },
                        child: Text(
                          _selesteddateTime != null
                              ? dateFormat.format(_selesteddateTime)
                              : 'Select event time',
                          style:
                              TextStyle(color: Color(0xff023429), fontSize: 23),
                        )),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedEvent = Event(
                          title: _editedEvent.title,
                          datetime: _editedEvent.datetime,
                          description: value,
                          imageUrl: imagurl,
                          barcodeurl: barcodeurl,
                          id: _editedEvent.id,
                          isFavorite: _editedEvent.isFavorite,
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Column(
                              children: <Widget>[
                                OutlineButton(
                                  borderSide: BorderSide(
                                    color: buttonColor,
                                    width: 2.0,
                                  ),
                                  onPressed: () {
                                    _openImagePicker(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.camera_alt,
                                        color: buttonColor,
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        'Event Image',
                                        style: TextStyle(color: buttonColor),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                _storedImage != null
                                    ? Image.file(
                                        _storedImage,
                                        fit: BoxFit.cover,
                                        height: 200.0,
                                        alignment: Alignment.topCenter,
                                      )
                                    : _initValues['imageUrl'] != null
                                        ? Image.network(
                                            _initValues['imageUrl'],
                                            fit: BoxFit.cover,
                                            height: 200.0,
                                            alignment: Alignment.topCenter,
                                          )
                                        : Text('choose event image')
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Column(
                              children: <Widget>[
                                OutlineButton(
                                  borderSide: BorderSide(
                                    color: buttonColor,
                                    width: 2.0,
                                  ),
                                  onPressed: () {
                                    _openbarcodePicker(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.camera_alt,
                                        color: buttonColor,
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        'Barcode Image',
                                        style: TextStyle(color: buttonColor),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                _storedbarcode != null
                                    ? Image.file(
                                        _storedbarcode,
                                        fit: BoxFit.cover,
                                        height: 200.0,
                                        alignment: Alignment.topCenter,
                                      )
                                    : _initValues['barcodeurl'] != null
                                        ? Image.network(
                                            _initValues['barcodeurl'],
                                            fit: BoxFit.cover,
                                            height: 200.0,
                                            alignment: Alignment.topCenter,
                                          )
                                        : Text('choose barcode image')
                              ],
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
