import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:http/http.dart' as http;
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/models/webblen_post.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';

class DynamicLinkService {
  PlatformDataService? _platformDataService = locator<PlatformDataService>();

  String webblenShareContentPrefix = 'https://app.webblen.io/shared_link';
  String androidPackageName = 'com.webblen.events.webblen';
  String iosBundleID = 'com.webblen.events';
  String iosAppStoreID = '1196159158';

  Future<String?> createProfileLink({required WebblenUser user}) async {
    String? key = await _platformDataService!.getGoogleApiKey();
    String kDynamicLinkURL = 'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=$key';

    // Construct the link which will open when the Dynamic Link is used
    String link = 'https://app.webblen.io/profiles/profile?id=${user.id}';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    // Configure the Dynamic Link
    Map body = {
      'dynamicLinkInfo': {
        'link': link,
        'domainUriPrefix': webblenShareContentPrefix,
        'androidInfo': {'androidPackageName': androidPackageName},
        'iosInfo': {'iosBundleId': iosBundleID, 'iosAppStoreId': iosAppStoreID}
      },
      'suffix': {'option': 'SHORT'}
    };

    // Request the deep link
    http.Response response = await http.post(
      Uri.parse(kDynamicLinkURL),
      body: jsonEncode(body),
      headers: headers,
      encoding: Encoding.getByName("utf-8"),
    );

    // Check if we generated a valid Dynamic Link
    if (response.statusCode == 200) {
      Map bodyAnswer = jsonDecode(response.body);
      return bodyAnswer['shortLink'];
    } else {
      return '';
    }
  }

  Future<String?> createPostLink({required String? authorUsername, required WebblenPost post}) async {
    String? key = await _platformDataService!.getGoogleApiKey();
    String kDynamicLinkURL = 'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=$key';

    // Construct the link which will open when the Dynamic Link is used
    String link = 'https://app.webblen.io/posts/post?id=${post.id}';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    Map body = {
      'dynamicLinkInfo': {
        'link': link,
        'domainUriPrefix': webblenShareContentPrefix,
        'androidInfo': {'androidPackageName': androidPackageName},
        'iosInfo': {'iosBundleId': iosBundleID, 'iosAppStoreId': iosAppStoreID}
      },
      'suffix': {'option': 'SHORT'}
    };

    print(jsonEncode(body));

    // Request the deep link
    http.Response response = await http
        .post(
      Uri.parse(kDynamicLinkURL),
      body: jsonEncode(body),
      headers: headers,
      encoding: Encoding.getByName("utf-8"),
    )
        .catchError((e) {
      print(e);
    });

    // Check if we generated a valid Dynamic Link
    if (response.statusCode == 200) {
      print(response.body);
      var bodyAnswer = jsonDecode(response.body);
      return bodyAnswer['shortLink'];
    } else {
      return '';
    }
  }

  Future<String?> createEventLink({required String? authorUsername, required WebblenEvent event}) async {
    String? key = await _platformDataService!.getGoogleApiKey();
    String kDynamicLinkURL = 'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=$key';

    // Construct the link which will open when the Dynamic Link is used
    String link = 'https://app.webblen.io/events/event?id=${event.id}';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    // Configure the Dynamic Link
    Map body = {
      'dynamicLinkInfo': {
        'link': link,
        'domainUriPrefix': webblenShareContentPrefix,
        'androidInfo': {'androidPackageName': androidPackageName},
        'iosInfo': {'iosBundleId': iosBundleID, 'iosAppStoreId': iosAppStoreID}
      },
      'suffix': {'option': 'SHORT'}
    };

    // Request the deep link
    http.Response response = await http.post(
      Uri.parse(kDynamicLinkURL),
      body: jsonEncode(body),
      headers: headers,
      encoding: Encoding.getByName("utf-8"),
    );

    // Check if we generated a valid Dynamic Link
    if (response.statusCode == 200) {
      Map bodyAnswer = jsonDecode(response.body);
      return bodyAnswer['shortLink'];
    } else {
      return '';
    }
  }

  Future<String?> createLiveStreamLink({required String? authorUsername, required WebblenLiveStream stream}) async {
    String? key = await _platformDataService!.getGoogleApiKey();
    String kDynamicLinkURL = 'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=$key';

    // Construct the link which will open when the Dynamic Link is used
    String link = 'https://app.webblen.io/streams/stream?id=${stream.id}';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    // Configure the Dynamic Link
    Map body = {
      'dynamicLinkInfo': {
        'link': link,
        'domainUriPrefix': webblenShareContentPrefix,
        'androidInfo': {'androidPackageName': androidPackageName},
        'iosInfo': {'iosBundleId': iosBundleID, 'iosAppStoreId': iosAppStoreID}
      },
      'suffix': {'option': 'SHORT'}
    };

    // Request the deep link
    http.Response response = await http.post(
      Uri.parse(kDynamicLinkURL),
      body: jsonEncode(body),
      headers: headers,
      encoding: Encoding.getByName("utf-8"),
    );

    // Check if we generated a valid Dynamic Link
    if (response.statusCode == 200) {
      Map bodyAnswer = jsonDecode(response.body);
      return bodyAnswer['shortLink'];
    } else {
      return '';
    }
  }

  Future handleDynamicLinks() async {
    CustomDialogService _customDialogService = locator<CustomDialogService>();
    // get dynamic link on app open
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDynamicLink(data);

    // get dynamic link if app already running
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData? linkData) async {
      _handleDynamicLink(linkData);
    }, onError: (OnLinkErrorException err) async {
      _customDialogService.showErrorDialog(description: "App Link Error");
    });
  }

  void _handleDynamicLink(PendingDynamicLinkData? linkData) {
    NavigationService _navigationService = locator<NavigationService>();
    CustomDialogService _customDialogService = locator<CustomDialogService>();
    final Uri? link = linkData?.link;
    if (link != null) {
      String? id = link.queryParameters['id'];
      if (id != null) {
        if (link.pathSegments.contains('profile')) {
          _navigationService.navigateTo(Routes.UserProfileView(id: id));
        } else if (link.pathSegments.contains('post')) {
          _navigationService.navigateTo(Routes.PostViewRoute(id: id));
        } else if (link.pathSegments.contains('event')) {
          _navigationService.navigateTo(Routes.EventDetailsViewRoute(id: id));
        } else if (link.pathSegments.contains('stream')) {
          _navigationService.navigateTo(Routes.LiveStreamViewRoute(id: id));
        } else if (link.pathSegments.contains('ticket')) {
          _navigationService.navigateTo(Routes.TicketSelectionViewRoute(id: id));
        } else {
          _customDialogService.showErrorDialog(description: "There was an issue loading the desired link");
        }
      } else {
        _customDialogService.showErrorDialog(description: "There was an issue loading the desired link");
      }
    }
  }
}
