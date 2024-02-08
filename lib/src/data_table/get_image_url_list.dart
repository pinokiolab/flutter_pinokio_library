import 'dart:convert';
import 'dart:io';

import 'package:cds_host/cds_host.dart';
import 'package:http/http.dart';

Future<List<String>> getImageUrlList(String jwt, List<String> partList) async {
  var filenameList = partList.map((e) => e.split(':').last).toList();
  var response = await post(
      CdsHost.httpMode(
        CdsHost.host,
        '/picture/thumbnail/',
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $jwt',
        'Content-Type': 'application/json',
      },
      body: json.encode({'uuid_list': filenameList}));
  var urlList = json.decode(response.body)['data'].cast<String>();
  return urlList;
}

Future<String> getOriginalUrl(String jwt, String fileName) async {
  var response = await get(
      CdsHost.httpMode(
        CdsHost.host,
        '/picture/original/',
        {'uuid': fileName},
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $jwt',
      });
  String url = json.decode(response.body)['data'] ?? '';
  return url;
}
