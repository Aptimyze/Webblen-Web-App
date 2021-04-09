import 'dart:html';

extension StringExtensions on String {
  // RoutingData get getRoutingData {
  //   var uriData = Uri.parse(this);
  //   print("queryParams: ${uriData.queryParameters} path: ${uriData.path}");
  //   return RoutingData(queryParams: uriData.queryParameters, route: uriData.path);
  // }
}

// https://github.com/flutter/flutter/issues/33470#issuecomment-537802636
bool copyText(String text) {
  final textarea = TextAreaElement();
  document.body!.append(textarea);
  textarea.style.border = '0';
  textarea.style.margin = '0';
  textarea.style.padding = '0';
  textarea.style.opacity = '0';
  textarea.style.position = 'absolute';
  textarea.readOnly = true;
  textarea.value = text;
  textarea.select();
  final result = document.execCommand('copy');
  textarea.remove();
  return result;
}
