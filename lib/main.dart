import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:embiteltest/apimanager/apiutils.dart';
import 'package:embiteltest/model/wikisearchmodel.dart';
import 'package:embiteltest/validator.dart';
import 'package:embiteltest/webviewscreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WikiSearchPage(),
    );
  }
}

class WikiSearchPage extends StatefulWidget {
  @override
  _WikiSearchPageState createState() => _WikiSearchPageState();
}

class _WikiSearchPageState extends State<WikiSearchPage> {
  List recent = List(5);
  ApiResponse apiResponse = ApiResponse();

  String wiki = "https://en.wikipedia.org/wiki/";
  TextEditingController _textEditingController = TextEditingController();
  bool isClose = false;
  bool isShowRecent = true;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
  }

  BuildContext context;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("WikiSearch"),
      ),
      body: _buildSearchView(),
    );
  }

  Widget _buildSearchView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            margin: EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black38.withAlpha(10),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search terms above 2 character",
                      hintStyle: TextStyle(
                        color: Colors.black.withAlpha(120),
                      ),
                      border: InputBorder.none,
                    ),
                    controller: _textEditingController,
                    onChanged: (String keyword) {
                      if (keyword.length > 0) {
                        isClose = true;
                      } else {
                        isClose = false;
                      }
                      if (keyword.length > 2) {
                        isShowRecent = false;
                        getApi(keyword);
                      } else {
                        isShowRecent = true;
                      }
                      setState(() {});
                    },
                  ),
                ),
                isClose
                    ? IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black.withAlpha(120),
                        ),
                        onPressed: () {
                          _textEditingController.clear();
                          isClose = false;
                          isShowRecent = true;
                          setState(() {});
                        })
                    : Icon(
                        Icons.search,
                        color: Colors.black.withAlpha(120),
                      )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        isShowRecent
            ? Center(
                child: Text("No Results"),
              )
            : Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebViewScreen(wiki +
                                      apiResponse.query.pages[index].title)),
                            );
                          },
                          title: Text(
                            apiResponse.query.pages[index].title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            (apiResponse.query.pages[index].terms.description !=
                                        null &&
                                    apiResponse.query.pages[index].terms
                                            .description[0] !=
                                        null)
                                ? apiResponse
                                    .query.pages[index].terms.description[0]
                                : "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: (apiResponse.query.pages[index]?.thumbnail
                                          ?.source !=
                                      null &&
                                  Validator().isCorrectUrl(apiResponse
                                      .query.pages[index]?.thumbnail?.source))
                              ? Image.network(apiResponse
                                  .query.pages[index]?.thumbnail?.source)
                              : Container(
                                  width: 50,
                                  height: 60,
                                ),
                        ),
                      );
                    },
                    itemCount: apiResponse?.query?.pages?.length ?? 0,
                  ),
                ),
              )
      ],
    );
  }

  void getApi(String keyword) async {
    var cacheDir = await getTemporaryDirectory();

    if (await File(cacheDir.path + "/" + keyword + ".json").exists()) {
      print("Loading from cache");

      var jsonData =
          File(cacheDir.path + "/" + keyword + ".json").readAsStringSync();
      ApiResponse response = ApiResponse.fromJson(json.decode(jsonData));
      setState(() {
        this.apiResponse = response;
      });
    } else {
      try {
        ApiUtils apiUtils = ApiUtils();
        String str = await apiUtils.getDataFromServer(keyword);
        if (str != null) {
          ApiResponse apiResponse = ApiResponse.fromJson(json.decode(str));
          setState(() {
            this.apiResponse = apiResponse;
          });
        } else {
          final snackBar = SnackBar(content: Text('Please check your internet connection'));
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      } on Exception catch (_) {
        final snackBar = SnackBar(content: Text('Please check your internet connection'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }
}
