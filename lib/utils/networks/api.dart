import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class Network extends ChangeNotifier {
  final String _url = 'https://login-odes.sgeede.com/api/';

  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'));
    if (token == null) {
      print('No Tokens');
    }
  }

  authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl, body: data);
  }

  postData(apiUrl, data) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    final response = await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());

    if (response.statusCode == 200) {
      return response;
    } else {
      print(jsonDecode(response.body));
      throw Exception('Failed to load data!');
    }
  }

  updateData(apiUrl, data) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    final response = await http.patch(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());

    if (response.statusCode == 200) {
      return response;
    } else {
      print(jsonDecode(response.body));
      throw Exception('Failed to load data!');
    }
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    final response =
        await http.get(fullUrl, headers: _setHeaders()).catchError((error) {});

    if (response.statusCode == 200) {
      return response;
    } else {
      if (response.statusCode == 404) {}
      return response;
    }
  }

  getDataFullURL(apiUrl) async {
    var fullUrl = apiUrl;
    await _getToken();
    final response =
        await http.get(fullUrl, headers: _setHeaders()).catchError((error) {
      print('error');
      print(jsonEncode(error));
    });

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load data!');
    }
  }

  destroyData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    final response = await http.delete(fullUrl, headers: _setHeaders());

    if (response.statusCode == 200) {
      return response;
    } else {
      print(jsonDecode(response.body));
      throw Exception('Failed to load data!');
    }
  }

  _setHeaders() => {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json',
        // 'Authorization': 'Bearer $token'
      };

  getCurrentUser({refresh: false}) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString('user');

    if (refresh || user == null) {
      var res = await getData('auth/me');
      var body = json.decode(res.body);
      localStorage.setString('user', json.encode(body['data']));
      user = localStorage.getString('user');
    }
    return jsonDecode(user);
  }

  getAssetStatistics({refresh: false}) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    final auth = await getCurrentUser();
    final target = 'asset_statistic' + auth['id'].toString();
    var data = localStorage.getString(target);
    if (refresh || data == null) {
      var res = await getData('v1/statistic');
      var body = json.decode(res.body);
      localStorage.setString(target, json.encode(body['data']));
      data = localStorage.getString(target);
    }
    notifyListeners();
    return jsonDecode(data);
  }

  getAssetsByRequest({refresh: false, type: ''}) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final auth = await getCurrentUser();
    var target = 'assets';
    if (type != '') {
      target = target + auth['id'].toString() + '_' + type;
    }

    var data = localStorage.getString(target);

    if (refresh || data == null) {
      var res = await getData('v1/requests/' + type);
      var body = json.decode(res.body);
      localStorage.setString(target, json.encode(body['data']));
      data = localStorage.getString(target);
    }
    notifyListeners();
    return jsonDecode(data);
  }

  getAssetsByCode({refresh: false, code: ''}) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final auth = await getCurrentUser();
    var target = 'assets_' + code;
    if (code != '') {
      target = target + auth['id'].toString();
    }

    var data = localStorage.getString(target);
    if (refresh || data == null) {
      var res = await getData('search-item/asset?code=' + code);
      var body = json.decode(res.body);
      print(body);
      localStorage.setString(target, json.encode(body['data']));
      data = localStorage.getString(target);
    }
    notifyListeners();
    return jsonDecode(data);
  }
}
