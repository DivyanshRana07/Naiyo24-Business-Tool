// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:convert';

void downloadFile({required String filename, required String content, required String mimeType}) {
  final bytes = utf8.encode(content);
  final blob = html.Blob([bytes], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = filename;
  html.document.body?.children.add(anchor);
  anchor.click();
  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}

void shareToWhatsApp({required String text}) {
  final encodedText = Uri.encodeComponent(text);
  final url = 'https://api.whatsapp.com/send?text=$encodedText';
  html.window.open(url, '_blank');
}
