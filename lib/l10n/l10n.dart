import 'package:flutter/widgets.dart';
import 'package:roomtime/l10n/app_localizations.dart';

export 'package:roomtime/l10n/app_localizations.dart';
export 'package:roomtime/l10n/failure_message.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n {
    return AppLocalizations.of(this);
  }
}
