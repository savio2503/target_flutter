import 'dart:typed_data';

import 'package:http/http.dart' as http;

class RemoveBackground {

  static final _apiKey = "9cdESde845WdMbpALvcQKjzG";

  static final _baseUrl = Uri.parse("https://api.remove.bg/v1.0/removebg");

  static Future<List<int>?> _fetchImageBytes(String imageUrl) async {

    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
  }

  static Future<Uint8List>? removebg(String urlImageWeb) async {

    var req = http.MultipartRequest("POST", _baseUrl);

    req.headers.addAll({"X-API-Key": _apiKey});

    List<int>? bytesFromImage = await _fetchImageBytes(urlImageWeb);

    if (bytesFromImage == null) {
      throw "erro ao baixar a imagem";
    }

    req.files.add(await http.MultipartFile.fromBytes("image_file", bytesFromImage));

    final res = await req.send();

    if (res.statusCode == 200) {

      http.Response img = await http.Response.fromStream(res);
      return img.bodyBytes;

    } else {
      throw "Failed to fetch data";
    }
  }
}