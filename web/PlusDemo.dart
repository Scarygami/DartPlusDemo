import 'dart:html';
import 'dart:uri';
import "dart:json";

class Plus {
  const String _baseUrl = "https://www.googleapis.com/plus/v1";
  final String _apiKey;

  Plus(this._apiKey);

  Future<Map> _sendRequest(String requestUrl, [Map optParams]) {
    String url;
    HttpRequest request = new HttpRequest();
    Completer completer = new Completer();
    StringBuffer params = new StringBuffer();

    if(optParams != null) {
      optParams.forEach((key, value) {
        params.add("&${encodeUriComponent(key)}=${encodeUriComponent(value.toString())}");  
      });
    }
    url = "$requestUrl?key=${encodeUriComponent(_apiKey)}${params}";

    request.on.loadEnd.add((Event e) {
      if (request.status == 200) {
        Map data = JSON.parse(request.responseText);
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
    final String url = "$_baseUrl/activities/${encodeUriComponent(activityId)}";
    return _sendRequest(url, optParams);
  }
  
  Future<Map> activitiesList(String userId, String collection, [Map optParams]) {
    final String url = "$_baseUrl/people/${encodeUriComponent(userId)}/activities/${encodeUriComponent(collection)}";
    return _sendRequest(url, optParams);
  }

  Future<Map> activitiesSearch(String query, [Map optParams]) {
    final String url = "$_baseUrl/activities";
    if(optParams == null) {
      optParams = new Map();
    }
    optParams["query"] = query;
    return _sendRequest(url, optParams);
  }

  Future<Map> commentsGet(String commentId, [Map optParams]) {
    final String url = "$_baseUrl/comments/${encodeUriComponent(commentId)}";
    return _sendRequest(url, optParams);
  }
  
  Future<Map> commentsList(String activityId, [Map optParams]) {
    final String url = "$_baseUrl/activities/${encodeUriComponent(activityId)}/comments";
    return _sendRequest(url, optParams);
  }

  Future<Map> peopleGet(String userId, [Map optParams]) {
    final String url = "$_baseUrl/people/${encodeUriComponent(userId)}";
    return _sendRequest(url, optParams);
  }
  
  Future<Map> peopleSearch(String query, [Map optParams]) {
    final String url = "$_baseUrl/people";
    if(optParams == null) {
      optParams = new Map();
    }
    optParams["query"] = query;
    return _sendRequest(url, optParams);
  }
  
  Future<Map> peopleListByActivity(String activityId, String collection, [Map optParams]) {
    final String url = "$_baseUrl/activities/${encodeUriComponent(activityId)}/people/${encodeUriComponent(collection)}";
    return _sendRequest(url, optParams);
  }
}

// Just to create a little bit nicer JSON output
String formatJson(Map data, [int depth=0]) {
  StringBuffer html = new StringBuffer();
  data.forEach((key, value) {
    if (value is Map) {
      html.add("<p style=\"margin-left: ${depth*15}px\"><b>$key</b>:</p>");
      html.add(formatJson(value, depth + 1));
    } else if (value is List) {
      html.add("<p style=\"margin-left: ${depth*15}px\"><b>$key:</b></p>");
      for (int i = 0; i < value.length; i++) {
        if (i > 0) {
          html.add("<p style=\"margin-left: ${(depth+1)*15}px\">---------------</p>");
        }
        html.add("<p style=\"margin-left: ${(depth+1)*15}px\">($key $i)</p>");
        html.add(formatJson(value[i], depth + 1));
      }
    } else {
      html.add("<p style=\"margin-left: ${depth*15}px\"><b>$key</b>: ${value.toString().replaceAll("<", "&lt;").replaceAll(">", "&gt;")}</p>");
    }
  });
  return html.toString();
}

void main() {
  // use your own API Key from the API Console here
  Plus plus = new Plus("AIzaSyDxnNu9Dm3eGxnDD72EF02IjRvR5v_eMPc");

  plus.activitiesList("+FoldedSoft", "public", {"maxResults": 3}).then((Map data) {
    query("#text").appendHtml("<h2>activities.list</h2>");
    query("#text").appendHtml(formatJson(data));
  });
  plus.activitiesGet("z12sczfo3zquc52n322mjp2oan3zzv1pw04").then((Map data) {
    query("#text").appendHtml("<h2>activities.get</h2>");
    query("#text").appendHtml(formatJson(data));
  });
  plus.activitiesSearch("dart", {"orderBy": "best", "language": "en"}).then((Map data) {
    query("#text").appendHtml("<h2>activities.search</h2>");
    query("#text").appendHtml(formatJson(data));
  });
  plus.commentsList("z12sczfo3zquc52n322mjp2oan3zzv1pw04").then((Map data) {
    query("#text").appendHtml("<h2>comments.list</h2>");
    query("#text").appendHtml(formatJson(data));
  });
  plus.commentsGet("z13bght5qszphtesn23lhhbgdt2fz1dgr04.1354878294969622").then((Map data) {
    query("#text").appendHtml("<h2>comments.get</h2>");
    query("#text").appendHtml(formatJson(data));
  });
  plus.peopleGet("112336147904981294875").then((Map data) {
    query("#text").appendHtml("<h2>people.get</h2>");
    query("#text").appendHtml(formatJson(data));
  });
  plus.peopleSearch("dart").then((Map data) {
    query("#text").appendHtml("<h2>people.search</h2>");
    query("#text").appendHtml(formatJson(data));
  });
  plus.peopleListByActivity("z12sczfo3zquc52n322mjp2oan3zzv1pw04", "plusoners").then((Map data) {
    query("#text").appendHtml("<h2>people.listByActivity(plusoners)</h2>");
    query("#text").appendHtml(formatJson(data));
  });
  plus.peopleListByActivity("z12sczfo3zquc52n322mjp2oan3zzv1pw04", "resharers").then((Map data) {
    query("#text").appendHtml("<h2>people.listByActivity(resharers)</h2>");
    query("#text").appendHtml(formatJson(data));
  });
}
