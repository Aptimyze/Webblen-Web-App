import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/enums/dialog_type.dart';
import 'package:webblen_web_app/ui/custom_dialogs/login_dialog/login_dialog.dart';

void setupDialogUi() {
  var dialogService = locator<DialogService>();

  final builders = {DialogType.loginDialog: (context, sheetRequest, completer) => LoginDialog(request: sheetRequest, completer: completer)};

  dialogService.registerCustomDialogBuilders(builders);
}
