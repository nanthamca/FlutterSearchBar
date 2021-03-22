import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ApiUtils {
  static final ApiUtils _singleton = ApiUtils._internal();

  factory ApiUtils() {
    return _singleton;
  }

  ApiUtils._internal();

  Future<String> getDataFromServer(String str) async {
    var queryParameters = {
      'action': 'query',
      'format': 'json',
      'prop': 'pageimages|pageterms',
      'generator': 'prefixsearch',
      'redirects': '1',
      'formatversion': '2',
      'piprop': 'thumbnail',
      'pithumbsize': '50',
      'pilimit': '10',
      'wbptterms': 'description',
      'gpssearch': '${str}',
      'gpslimit': '10'
    };
    var uri = Uri.https('en.wikipedia.org', '/w/api.php', queryParameters);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var tempDir = await getTemporaryDirectory();
      File file = new File(tempDir.path + "/" + str + ".json");
      file.writeAsString(response.body, flush: true, mode: FileMode.write);
      return response.body;
    } else {
      return null;
    }
  }
}
