import "dart:html";
import "package:dartplusclient/plus.dart";

String formatJson(Map data) {
  var html = new StringBuffer();
  html.add("<dl>");
  data.forEach((key, value) {
    html.add("<dt>$key:</dt><dd>");
    if (value is Map) {
      html.add(formatJson(value));
    } else if (value is List) {
      html.add("<dl>");
      for (var i = 0; i < value.length; i++) {
        html.add("<dt>$i:</dt><dd>");
        html.add(formatJson(value[i]));
        html.add("</dd>");
      }
      html.add("</dl>");
    } else {
      html.add("${value.toString().replaceAll("<", "&lt;").replaceAll(">", "&gt;")}");
    }
    html.add("</dd>");
  });
  html.add("</dl>");
  return html.toString();
}

void main() {
  // use your own API Key from the API Console here
  var plus = new Plus("AIzaSyDxnNu9Dm3eGxnDD72EF02IjRvR5v_eMPc");
  var container = query("#text");
  
  plus.activitiesList("+FoldedSoft", "public", {"maxResults": 3}).then((Map data) {
    container.appendHtml("<h2>activities.list</h2>");
    container.appendHtml(formatJson(data));
  });
  plus.activitiesGet("z12sczfo3zquc52n322mjp2oan3zzv1pw04").then((Map data) {
    container.appendHtml("<h2>activities.get</h2>");
    container.appendHtml(formatJson(data));
  });
  plus.activitiesSearch("dart", {"orderBy": "best", "language": "en"}).then((Map data) {
    container.appendHtml("<h2>activities.search</h2>");
    container.appendHtml(formatJson(data));
  });
  plus.commentsList("z12sczfo3zquc52n322mjp2oan3zzv1pw04").then((Map data) {
    container.appendHtml("<h2>comments.list</h2>");
    container.appendHtml(formatJson(data));
  });
  plus.commentsGet("z13bght5qszphtesn23lhhbgdt2fz1dgr04.1354878294969622").then((Map data) {
    container.appendHtml("<h2>comments.get</h2>");
    container.appendHtml(formatJson(data));
  });
  plus.peopleGet("112336147904981294875").then((Map data) {
    container.appendHtml("<h2>people.get</h2>");
    container.appendHtml(formatJson(data));
  });
  plus.peopleSearch("dart").then((Map data) {
    container.appendHtml("<h2>people.search</h2>");
    container.appendHtml(formatJson(data));
  });
  plus.peopleListByActivity("z12sczfo3zquc52n322mjp2oan3zzv1pw04", "plusoners").then((Map data) {
    container.appendHtml("<h2>people.listByActivity(plusoners)</h2>");
    container.appendHtml(formatJson(data));
  });
  plus.peopleListByActivity("z12sczfo3zquc52n322mjp2oan3zzv1pw04", "resharers").then((Map data) {
    container.appendHtml("<h2>people.listByActivity(resharers)</h2>");
    container.appendHtml(formatJson(data));
  });
}
