library plus;

import 'dart:html';
import 'dart:uri';
import "dart:json";

class Plus {
  const _baseUrl = "https://www.googleapis.com/plus/v1";
  final _apiKey;

  Plus(this._apiKey);

  Future<Map> _sendRequest(String requestUrl, [Map optParams]) {
    var url;
    var request = new HttpRequest();
    var completer = new Completer();
    var params = new StringBuffer();

    if (optParams != null) {
      optParams.forEach((key, value) {
        params.add("&${encodeUriComponent(key)}=${encodeUriComponent(value.toString())}");  
      });
    }
    url = "$requestUrl?key=${encodeUriComponent(_apiKey)}${params}";

    request.on.loadEnd.add((Event e) {
      if (request.status == 200) {
        var data = JSON.parse(request.responseText);
        completer.complete(data);
      } else {
        completer.complete({"error": "Error ${request.status}: ${request.statusText}"});
      }
    });

    request.open("GET", url);
    request.send();

    return completer.future;
  }

  Future<Map> activitiesGet(String activityId, [Map optParams]) {
    final url = "$_baseUrl/activities/${encodeUriComponent(activityId)}";
    return _sendRequest(url, optParams);
  }
  
  Future<Map> activitiesList(String userId, String collection, [Map optParams]) {
    final url = "$_baseUrl/people/${encodeUriComponent(userId)}/activities/${encodeUriComponent(collection)}";
    return _sendRequest(url, optParams);
  }

  Future<Map> activitiesSearch(String query, [Map optParams]) {
    final url = "$_baseUrl/activities";
    if (optParams == null) {
      optParams = new Map();
    }
    optParams["query"] = query;
    return _sendRequest(url, optParams);
  }

  Future<Map> commentsGet(String commentId, [Map optParams]) {
    final url = "$_baseUrl/comments/${encodeUriComponent(commentId)}";
    return _sendRequest(url, optParams);
  }
  
  Future<Map> commentsList(String activityId, [Map optParams]) {
    final url = "$_baseUrl/activities/${encodeUriComponent(activityId)}/comments";
    return _sendRequest(url, optParams);
  }

  Future<Map> peopleGet(String userId, [Map optParams]) {
    final url = "$_baseUrl/people/${encodeUriComponent(userId)}";
    return _sendRequest(url, optParams);
  }
  
  Future<Map> peopleSearch(String query, [Map optParams]) {
    final url = "$_baseUrl/people";
    if (optParams == null) {
      optParams = new Map();
    }
    optParams["query"] = query;
    return _sendRequest(url, optParams);
  }
  
  Future<Map> peopleListByActivity(String activityId, String collection, [Map optParams]) {
    final url = "$_baseUrl/activities/${encodeUriComponent(activityId)}/people/${encodeUriComponent(collection)}";
    return _sendRequest(url, optParams);
  }
}