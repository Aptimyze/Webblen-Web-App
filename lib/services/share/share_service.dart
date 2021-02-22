import 'package:share_plus/share.dart';

class ShareService {
  shareLink(String url) {
    Share.share(url);
  }
}
