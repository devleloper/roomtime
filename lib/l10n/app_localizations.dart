import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// Brand name. Never translated.
  ///
  /// In en, this message translates to:
  /// **'RoomTime'**
  String get appName;

  /// Tooltip of the eye button in password fields.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get commonShowPassword;

  /// Tooltip of the eye button in password fields.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get commonHidePassword;

  /// Home call to action and the title of the create dialog
  ///
  /// In en, this message translates to:
  /// **'Create Room'**
  String get homeCreateRoom;

  /// Primary button of the Create Room dialog
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get homeCreate;

  /// Password field label in the Create Room dialog
  ///
  /// In en, this message translates to:
  /// **'Password (optional)'**
  String get homePasswordOptional;

  /// Accessible name of the round camera preview toggle on Home
  ///
  /// In en, this message translates to:
  /// **'Camera preview'**
  String get homeCameraPreview;

  /// Section label above the room code field on Home
  ///
  /// In en, this message translates to:
  /// **'Join with code'**
  String get homeJoinWithCode;

  /// Home screen: label of the join field.
  ///
  /// In en, this message translates to:
  /// **'Code or link'**
  String get homeJoinLabel;

  /// Home screen: button next to the join field.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get homeJoin;

  /// Home screen: join button label while the code is checked.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get homeChecking;

  /// Home screen: section title.
  ///
  /// In en, this message translates to:
  /// **'Recent rooms'**
  String get homeRecent;

  /// Home screen: empty state of recent rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms you create or join appear here.'**
  String get homeRecentEmpty;

  /// Home screen: note on a recent room the user created.
  ///
  /// In en, this message translates to:
  /// **'You created it'**
  String get homeRecentHost;

  /// Home screen: screen reader label of the remove button.
  ///
  /// In en, this message translates to:
  /// **'Remove {room} from recent'**
  String homeRecentRemoveFor(String room);

  /// Home screen: snackbar after removing a recent room.
  ///
  /// In en, this message translates to:
  /// **'Removed from recent'**
  String get homeRecentRemoved;

  /// Home screen: snackbar action that restores a removed recent room.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get homeUndo;

  /// Home screen: screen reader label of a recent room: name, time ago.
  ///
  /// In en, this message translates to:
  /// **'{room}, {when}'**
  String homeRecentRow(String room, String when);

  /// Home screen: time ago under one minute.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get homeJustNow;

  /// Home screen: time ago in minutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String homeMinutesAgo(int count);

  /// Home screen: time ago in hours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String homeHoursAgo(int count);

  /// Home screen: time ago, one day.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get homeYesterday;

  /// Home screen: time ago in days.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String homeDaysAgo(int count);

  /// Home screen: join field error.
  ///
  /// In en, this message translates to:
  /// **'That doesn\'t look like a room code. Codes have 10 letters, like abc-defg-hjk.'**
  String get homeInvalidCode;

  /// Home screen: one-shot notice after opening an invite link (/r/<code>) whose code is malformed.
  ///
  /// In en, this message translates to:
  /// **'This invite link is invalid.'**
  String get homeInvalidInviteLink;

  /// Home screen: join field error for a foreign link.
  ///
  /// In en, this message translates to:
  /// **'This link isn\'t a room invite.'**
  String get homeNotARoomLink;

  /// Home screen: dialog button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get homeCancel;

  /// New room sheet: field label.
  ///
  /// In en, this message translates to:
  /// **'Room name (optional)'**
  String get homeCreateNameLabel;

  /// New room sheet: password validation error.
  ///
  /// In en, this message translates to:
  /// **'Use at least 4 characters'**
  String get homeCreatePasswordTooShort;

  /// New room sheet: password validation error.
  ///
  /// In en, this message translates to:
  /// **'Too long: up to 64 Latin characters (36 in Cyrillic)'**
  String get homeCreatePasswordTooLong;

  /// New room sheet: retry button after an error.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get homeCreateRetry;

  /// Lobby: loading state.
  ///
  /// In en, this message translates to:
  /// **'Finding the room…'**
  String get roomFinding;

  /// Lobby: title of a room without a name.
  ///
  /// In en, this message translates to:
  /// **'Room {code}'**
  String roomTitleUnnamed(String code);

  /// Lobby: field label.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get roomNameLabel;

  /// Lobby: validation error.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get roomNameRequired;

  /// Lobby: validation error.
  ///
  /// In en, this message translates to:
  /// **'Use at most 32 characters'**
  String get roomNameTooLong;

  /// Lobby: field label.
  ///
  /// In en, this message translates to:
  /// **'Room password'**
  String get roomPasswordLabel;

  /// Lobby: password field helper.
  ///
  /// In en, this message translates to:
  /// **'Ask the person who invited you'**
  String get roomPasswordHelper;

  /// Lobby: password error.
  ///
  /// In en, this message translates to:
  /// **'This room needs a password.'**
  String get roomPasswordRequired;

  /// Lobby: password error.
  ///
  /// In en, this message translates to:
  /// **'Wrong password. Check it and try again.'**
  String get roomWrongPassword;

  /// Lobby: lockout countdown; mmss is like 0:42.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {mmss}.'**
  String roomTooManyAttempts(String mmss);

  /// Lobby: announced when the lockout ends.
  ///
  /// In en, this message translates to:
  /// **'You can try again'**
  String get roomCanTryAgain;

  /// Lobby: primary button.
  ///
  /// In en, this message translates to:
  /// **'Join call'**
  String get roomJoin;

  /// Lobby: primary button while joining.
  ///
  /// In en, this message translates to:
  /// **'Joining…'**
  String get roomJoining;

  /// Lobby: banner.
  ///
  /// In en, this message translates to:
  /// **'The host isn\'t letting new people in right now.'**
  String get roomLockedNotice;

  /// Lobby: banner.
  ///
  /// In en, this message translates to:
  /// **'You are the host of this room.'**
  String get roomHostNotice;

  /// Lobby: back button.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get roomBack;

  /// Lobby: screen reader label of the preview.
  ///
  /// In en, this message translates to:
  /// **'Camera preview, camera on'**
  String get roomPreviewOn;

  /// Lobby: screen reader label of the preview.
  ///
  /// In en, this message translates to:
  /// **'Camera preview, camera off'**
  String get roomPreviewOff;

  /// Permissions: explainer.
  ///
  /// In en, this message translates to:
  /// **'Allow camera and microphone so others can see and hear you.'**
  String get roomPermExplainer;

  /// Permissions: button.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get roomPermAllow;

  /// Permissions: banner.
  ///
  /// In en, this message translates to:
  /// **'Camera is blocked'**
  String get roomCameraBlocked;

  /// Permissions: banner.
  ///
  /// In en, this message translates to:
  /// **'Microphone is blocked. Others won\'t hear you.'**
  String get roomMicBlocked;

  /// Permissions: button.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get roomOpenSettings;

  /// Permissions: banner on the web.
  ///
  /// In en, this message translates to:
  /// **'Camera is blocked. Allow access in the browser\'s address bar, then reload the page.'**
  String get roomCameraBlockedWeb;

  /// Permissions: banner on macOS.
  ///
  /// In en, this message translates to:
  /// **'Camera is blocked. Allow access in System Settings, Privacy & Security.'**
  String get roomCameraBlockedDesktop;

  /// Permissions: banner on the web.
  ///
  /// In en, this message translates to:
  /// **'Microphone is blocked. Others won\'t hear you. Allow access in the browser\'s address bar, then reload the page.'**
  String get roomMicBlockedWeb;

  /// Permissions: banner on macOS.
  ///
  /// In en, this message translates to:
  /// **'Microphone is blocked. Others won\'t hear you. Allow access in System Settings, Privacy & Security.'**
  String get roomMicBlockedDesktop;

  /// Call controls: control label.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get roomMic;

  /// Call controls: control label.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get roomCamera;

  /// Call controls: control label.
  ///
  /// In en, this message translates to:
  /// **'Flip camera'**
  String get roomFlip;

  /// Call controls: audio output label (loudspeaker).
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get roomSpeaker;

  /// Call controls: audio output label (earpiece).
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get roomEarpiece;

  /// Call controls: control label.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get roomInvite;

  /// Call controls: control label.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get roomParticipants;

  /// Call controls: leave button label.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get roomLeave;

  /// Call controls: tooltip; shortcut is like Ctrl+D.
  ///
  /// In en, this message translates to:
  /// **'Turn off microphone ({shortcut})'**
  String roomMicTurnOff(String shortcut);

  /// Call controls: tooltip; shortcut is like Ctrl+D.
  ///
  /// In en, this message translates to:
  /// **'Turn on microphone ({shortcut})'**
  String roomMicTurnOn(String shortcut);

  /// Call controls: tooltip; shortcut is like Ctrl+E.
  ///
  /// In en, this message translates to:
  /// **'Turn off camera ({shortcut})'**
  String roomCameraTurnOff(String shortcut);

  /// Call controls: tooltip; shortcut is like Ctrl+E.
  ///
  /// In en, this message translates to:
  /// **'Turn on camera ({shortcut})'**
  String roomCameraTurnOn(String shortcut);

  /// Call controls: tooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch to phone earpiece'**
  String get roomSwitchToEarpiece;

  /// Call controls: tooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch to speaker'**
  String get roomSwitchToSpeaker;

  /// Call controls: web autoplay banner.
  ///
  /// In en, this message translates to:
  /// **'Your browser paused the sound.'**
  String get roomSoundBlocked;

  /// Call controls: web autoplay banner action.
  ///
  /// In en, this message translates to:
  /// **'Turn on sound'**
  String get roomTurnOnSound;

  /// Call controls: banner.
  ///
  /// In en, this message translates to:
  /// **'Microphone isn\'t available. Others can\'t hear you.'**
  String get roomMicUnavailable;

  /// Call controls: banner on the web.
  ///
  /// In en, this message translates to:
  /// **'Microphone isn\'t available. Others can\'t hear you. Check access in the browser\'s address bar.'**
  String get roomMicUnavailableWeb;

  /// Call: empty call title.
  ///
  /// In en, this message translates to:
  /// **'You\'re the only one here'**
  String get roomAlone;

  /// Call: empty call body.
  ///
  /// In en, this message translates to:
  /// **'Share the link to invite someone.'**
  String get roomAloneBody;

  /// Call: the local participant.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get roomYou;

  /// Call: host badge.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get roomHost;

  /// Call: screen reader state of a tile.
  ///
  /// In en, this message translates to:
  /// **'speaking'**
  String get roomSpeaking;

  /// Call: screen reader state of a tile.
  ///
  /// In en, this message translates to:
  /// **'microphone on'**
  String get roomMicOn;

  /// Call: screen reader state of a tile.
  ///
  /// In en, this message translates to:
  /// **'microphone off'**
  String get roomMicOff;

  /// Call: screen reader state of a tile.
  ///
  /// In en, this message translates to:
  /// **'weak connection'**
  String get roomWeakConnection;

  /// Call: badge.
  ///
  /// In en, this message translates to:
  /// **'Weak connection'**
  String get roomWeakConnectionTitle;

  /// Call: screen reader state of a tile.
  ///
  /// In en, this message translates to:
  /// **'camera off'**
  String get roomCamOff;

  /// Call: picture-in-picture action.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get roomSwap;

  /// Call: local participant name.
  ///
  /// In en, this message translates to:
  /// **'{name} (You)'**
  String roomNameYou(String name);

  /// Call: local participant name when host.
  ///
  /// In en, this message translates to:
  /// **'{name} (You, host)'**
  String roomNameYouHost(String name);

  /// Call: notice.
  ///
  /// In en, this message translates to:
  /// **'{name} joined'**
  String roomJoined(String name);

  /// Call: notice.
  ///
  /// In en, this message translates to:
  /// **'{name} left'**
  String roomLeft(String name);

  /// Call: grouped join notice.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person joined} other{{count} people joined}}'**
  String roomJoinedMany(int count);

  /// Call: name of a participant without a name.
  ///
  /// In en, this message translates to:
  /// **'Someone'**
  String get roomSomeone;

  /// Call: participant count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 participant} other{{count} participants}}'**
  String roomParticipantCount(int count);

  /// Call: banner; time is a clock time.
  ///
  /// In en, this message translates to:
  /// **'The invite link stops working at {time}. Anyone who drops out after that can\'t rejoin.'**
  String roomExpiresSoon(String time);

  /// Call: banner action.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get roomDismiss;

  /// Participants and host actions: panel title.
  ///
  /// In en, this message translates to:
  /// **'Participants ({count})'**
  String roomPeopleTitle(int count);

  /// Participants and host actions: switch.
  ///
  /// In en, this message translates to:
  /// **'Lock room'**
  String get roomLock;

  /// Participants and host actions: switch subtitle.
  ///
  /// In en, this message translates to:
  /// **'No one new can join'**
  String get roomLockSub;

  /// Participants and host actions: snackbar.
  ///
  /// In en, this message translates to:
  /// **'Room locked'**
  String get roomLocked;

  /// Participants and host actions: snackbar.
  ///
  /// In en, this message translates to:
  /// **'Room unlocked'**
  String get roomUnlocked;

  /// Participants and host actions: snackbar.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get roomPasswordSet;

  /// Participants and host actions: snackbar.
  ///
  /// In en, this message translates to:
  /// **'Password removed'**
  String get roomPasswordRemoved;

  /// Participants and host actions: snackbar.
  ///
  /// In en, this message translates to:
  /// **'New invite link ready. The old one stopped working.'**
  String get roomInviteRotated;

  /// Participants and host actions: action.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get roomChangePassword;

  /// Participants and host actions: action.
  ///
  /// In en, this message translates to:
  /// **'Set a password'**
  String get roomSetPassword;

  /// Participants and host actions: action.
  ///
  /// In en, this message translates to:
  /// **'Remove password'**
  String get roomRemovePassword;

  /// Participants and host actions: dialog title.
  ///
  /// In en, this message translates to:
  /// **'Room password'**
  String get roomPasswordDialogTitle;

  /// Participants and host actions: dialog body.
  ///
  /// In en, this message translates to:
  /// **'People already in the call stay. New people need the new password.'**
  String get roomPasswordDialogBody;

  /// Participants and host actions: validation error.
  ///
  /// In en, this message translates to:
  /// **'Use at least 4 characters'**
  String get roomPasswordTooShort;

  /// Participants and host actions: validation error.
  ///
  /// In en, this message translates to:
  /// **'Too long: up to 64 Latin characters (36 in Cyrillic)'**
  String get roomPasswordTooLong;

  /// Participants and host actions: dialog button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get roomSave;

  /// Participants and host actions: dialog title.
  ///
  /// In en, this message translates to:
  /// **'Remove the password?'**
  String get roomRemovePasswordTitle;

  /// Participants and host actions: dialog body.
  ///
  /// In en, this message translates to:
  /// **'Anyone with the link can join without a password.'**
  String get roomRemovePasswordBody;

  /// Participants and host actions: dialog button.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get roomRemovePasswordConfirm;

  /// Participants and host actions: menu label for a participant.
  ///
  /// In en, this message translates to:
  /// **'Options for {name}'**
  String roomOptionsFor(String name);

  /// Participants and host actions: host action on a participant.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get roomMute;

  /// Participants and host actions: snackbar.
  ///
  /// In en, this message translates to:
  /// **'{name} was muted'**
  String roomMuted(String name);

  /// Participants and host actions: snackbar.
  ///
  /// In en, this message translates to:
  /// **'{name} was removed'**
  String roomRemoved(String name);

  /// Participants and host actions: host action.
  ///
  /// In en, this message translates to:
  /// **'Remove from call'**
  String get roomRemove;

  /// Participants and host actions: dialog title.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String roomRemoveTitle(String name);

  /// Participants and host actions: dialog body.
  ///
  /// In en, this message translates to:
  /// **'They will be disconnected from the call.'**
  String get roomRemoveBody;

  /// Participants and host actions: checkbox.
  ///
  /// In en, this message translates to:
  /// **'Don\'t let them rejoin'**
  String get roomBan;

  /// Participants and host actions: checkbox note.
  ///
  /// In en, this message translates to:
  /// **'This only blocks rejoining from the same device and browser. To keep someone out for good, change the invite code too.'**
  String get roomBanNote;

  /// Participants and host actions: dialog button.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get roomRemoveConfirm;

  /// Participants and host actions: dialog button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get roomCancel;

  /// Participants and host actions: section title.
  ///
  /// In en, this message translates to:
  /// **'Room settings'**
  String get roomRoomSettings;

  /// Leaving: sheet title.
  ///
  /// In en, this message translates to:
  /// **'Leave the call?'**
  String get roomLeaveSheetTitle;

  /// Leaving: option.
  ///
  /// In en, this message translates to:
  /// **'Leave call'**
  String get roomLeaveLeave;

  /// Leaving: option subtitle.
  ///
  /// In en, this message translates to:
  /// **'The call continues without you'**
  String get roomLeaveLeaveSub;

  /// Leaving: option.
  ///
  /// In en, this message translates to:
  /// **'End call for everyone'**
  String get roomLeaveEnd;

  /// Leaving: option subtitle.
  ///
  /// In en, this message translates to:
  /// **'Everyone is disconnected and the room closes'**
  String get roomLeaveEndSub;

  /// Leaving: dialog title.
  ///
  /// In en, this message translates to:
  /// **'End the call for everyone?'**
  String get roomLeaveConfirmTitle;

  /// Leaving: dialog body.
  ///
  /// In en, this message translates to:
  /// **'Everyone will be disconnected and the invite link will stop working. This can\'t be undone.'**
  String get roomLeaveConfirmBody;

  /// Leaving: dialog button.
  ///
  /// In en, this message translates to:
  /// **'End for everyone'**
  String get roomLeaveConfirm;

  /// Reconnecting: banner.
  ///
  /// In en, this message translates to:
  /// **'Connection lost. Reconnecting…'**
  String get roomReconnecting;

  /// Reconnecting: banner.
  ///
  /// In en, this message translates to:
  /// **'Reconnected'**
  String get roomReconnected;

  /// Ended screen: title.
  ///
  /// In en, this message translates to:
  /// **'You left the call'**
  String get roomEndedLeft;

  /// Ended screen: title.
  ///
  /// In en, this message translates to:
  /// **'The call has ended'**
  String get roomEndedByHost;

  /// Ended screen: body.
  ///
  /// In en, this message translates to:
  /// **'The host ended the call for everyone.'**
  String get roomEndedByHostBody;

  /// Ended screen: title.
  ///
  /// In en, this message translates to:
  /// **'You ended the call for everyone'**
  String get roomEndedByYou;

  /// Ended screen: title.
  ///
  /// In en, this message translates to:
  /// **'You were removed from the call'**
  String get roomEndedRemoved;

  /// Ended screen: title.
  ///
  /// In en, this message translates to:
  /// **'The invite link has expired'**
  String get roomEndedExpired;

  /// Ended screen: body.
  ///
  /// In en, this message translates to:
  /// **'You can\'t rejoin after the link expires. Ask the host for a new room.'**
  String get roomEndedExpiredBody;

  /// Ended screen: title.
  ///
  /// In en, this message translates to:
  /// **'You joined from another device'**
  String get roomEndedElsewhere;

  /// Ended screen: body.
  ///
  /// In en, this message translates to:
  /// **'This call continues on your other device or browser tab.'**
  String get roomEndedElsewhereBody;

  /// Ended screen: title.
  ///
  /// In en, this message translates to:
  /// **'Connection lost'**
  String get roomEndedConnectionLost;

  /// Ended screen: body.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get roomEndedConnectionLostBody;

  /// Ended screen: button.
  ///
  /// In en, this message translates to:
  /// **'Rejoin'**
  String get roomRejoin;

  /// Ended screen: button.
  ///
  /// In en, this message translates to:
  /// **'Join here instead'**
  String get roomUseHere;

  /// Ended screen: button.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get roomHome;

  /// Ended screen: button.
  ///
  /// In en, this message translates to:
  /// **'New room'**
  String get roomNewRoom;

  /// Full-screen errors: title.
  ///
  /// In en, this message translates to:
  /// **'Room not found'**
  String get roomNotFoundTitle;

  /// Full-screen errors: body.
  ///
  /// In en, this message translates to:
  /// **'It may have ended, expired, or the invite code was changed. Ask for a new link.'**
  String get roomNotFoundBody;

  /// Full-screen errors: title.
  ///
  /// In en, this message translates to:
  /// **'The room is full'**
  String get roomFullTitle;

  /// Full-screen errors: body with the room limit.
  ///
  /// In en, this message translates to:
  /// **'{max, plural, =1{This room allows 1 person. Try again later or ask the host.} other{This room allows {max} people. Try again later or ask the host.}}'**
  String roomFullBody(int max);

  /// Full-screen errors: body without the limit.
  ///
  /// In en, this message translates to:
  /// **'Try again later or ask the host.'**
  String get roomFullBodyUnknown;

  /// Full-screen errors: title.
  ///
  /// In en, this message translates to:
  /// **'The room is locked'**
  String get roomLockedTitle;

  /// Full-screen errors: body.
  ///
  /// In en, this message translates to:
  /// **'The host isn\'t letting new people in right now.'**
  String get roomLockedBody;

  /// Full-screen errors: title.
  ///
  /// In en, this message translates to:
  /// **'You can\'t join this room'**
  String get roomBannedTitle;

  /// Full-screen errors: body.
  ///
  /// In en, this message translates to:
  /// **'The host removed you and blocked rejoining.'**
  String get roomBannedBody;

  /// Full-screen errors: button.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get roomTryAgain;

  /// Full-screen errors: title.
  ///
  /// In en, this message translates to:
  /// **'No connection'**
  String get roomNoConnectionTitle;

  /// Full-screen errors: title.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get roomSomethingWrongTitle;

  /// Keyboard shortcuts: dialog title.
  ///
  /// In en, this message translates to:
  /// **'Keyboard shortcuts'**
  String get roomShortcutsTitle;

  /// Keyboard shortcuts: row.
  ///
  /// In en, this message translates to:
  /// **'Turn microphone on or off'**
  String get roomShortcutMic;

  /// Keyboard shortcuts: row.
  ///
  /// In en, this message translates to:
  /// **'Turn camera on or off'**
  String get roomShortcutCamera;

  /// Keyboard shortcuts: row.
  ///
  /// In en, this message translates to:
  /// **'Show or hide participants'**
  String get roomShortcutPeople;

  /// Keyboard shortcuts: row.
  ///
  /// In en, this message translates to:
  /// **'Show shortcuts'**
  String get roomShortcutHelp;

  /// Keyboard shortcuts: dialog button.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get roomClose;

  /// Invite card and sheet: title after creating a room.
  ///
  /// In en, this message translates to:
  /// **'Your room is ready'**
  String get inviteReady;

  /// Invite card and sheet: sheet title.
  ///
  /// In en, this message translates to:
  /// **'Invite people'**
  String get inviteTitle;

  /// Invite card and sheet: label.
  ///
  /// In en, this message translates to:
  /// **'Room code'**
  String get inviteCodeLabel;

  /// Invite card and sheet: label.
  ///
  /// In en, this message translates to:
  /// **'Invite link'**
  String get inviteLinkLabel;

  /// Invite card and sheet: button.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get inviteCopyLink;

  /// Invite card and sheet: button.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get inviteCopyCode;

  /// Invite card and sheet: button that opens the system share sheet.
  ///
  /// In en, this message translates to:
  /// **'Share…'**
  String get inviteShare;

  /// Invite card and sheet: text sent via the share sheet.
  ///
  /// In en, this message translates to:
  /// **'Join my call: {link}'**
  String inviteShareText(String link);

  /// Invite card and sheet: subject sent via the share sheet.
  ///
  /// In en, this message translates to:
  /// **'Join my call'**
  String get inviteShareSubject;

  /// Invite card and sheet: snackbar.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get inviteLinkCopied;

  /// Invite card and sheet: snackbar.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get inviteCodeCopied;

  /// Invite card and sheet: note.
  ///
  /// In en, this message translates to:
  /// **'This room has a password. Send it separately.'**
  String get invitePasswordNote;

  /// Invite card and sheet: button.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get inviteDone;

  /// Invite card and sheet: host action.
  ///
  /// In en, this message translates to:
  /// **'Change invite code'**
  String get inviteRotate;

  /// Invite card and sheet: dialog title.
  ///
  /// In en, this message translates to:
  /// **'Change the invite code?'**
  String get inviteRotateTitle;

  /// Invite card and sheet: dialog body.
  ///
  /// In en, this message translates to:
  /// **'The old link and code stop working. People already in the call stay.'**
  String get inviteRotateBody;

  /// Invite card and sheet: dialog button.
  ///
  /// In en, this message translates to:
  /// **'Change code'**
  String get inviteRotateConfirm;

  /// Invite card and sheet: dialog button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get inviteCancel;

  /// Error message for a failed request.
  ///
  /// In en, this message translates to:
  /// **'Room not found. It may have ended, expired, or the invite code was changed.'**
  String get failureRoomNotFound;

  /// Error message for a failed request.
  ///
  /// In en, this message translates to:
  /// **'This room needs a password.'**
  String get failurePasswordRequired;

  /// Error message for a failed request.
  ///
  /// In en, this message translates to:
  /// **'Wrong password. Check it and try again.'**
  String get failureInvalidPassword;

  /// Error message for a failed request.
  ///
  /// In en, this message translates to:
  /// **'The room is full. Try again later or ask the host.'**
  String get failureRoomFull;

  /// Error message for a failed request.
  ///
  /// In en, this message translates to:
  /// **'The host isn\'t letting new people in right now.'**
  String get failureRoomLocked;

  /// Error message for a failed request.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get failureTooManyAttempts;

  /// Error message for a failed request.
  ///
  /// In en, this message translates to:
  /// **'That doesn\'t look like a room code. Codes have 10 letters, like abc-defg-hjk.'**
  String get failureInvalidCode;

  /// Error message for a failed request.
  ///
  /// In en, this message translates to:
  /// **'Only the host can do this.'**
  String get failureForbidden;

  /// Error message for a failed request.
  ///
  /// In en, this message translates to:
  /// **'The host doesn\'t allow you in this room.'**
  String get failureParticipantBanned;

  /// Error message for a failed request.
  ///
  /// In en, this message translates to:
  /// **'This participant has already left.'**
  String get failureParticipantNotFound;

  /// Error message for a failed request: invalid room name.
  ///
  /// In en, this message translates to:
  /// **'Use a room name of at most 40 characters.'**
  String get failureInvalidRoomName;

  /// Error message for a failed request: invalid password length.
  ///
  /// In en, this message translates to:
  /// **'Use a password of 4 to 64 characters.'**
  String get failureInvalidPasswordInput;

  /// Error message for a failed request: invalid participant limit.
  ///
  /// In en, this message translates to:
  /// **'A room can have 2 to 10 participants.'**
  String get failureInvalidMaxParticipants;

  /// Error message for a failed request: invalid invite lifetime.
  ///
  /// In en, this message translates to:
  /// **'Choose a duration between 15 minutes and 24 hours.'**
  String get failureInvalidLifetime;

  /// Error message for a failed request: invalid display name.
  ///
  /// In en, this message translates to:
  /// **'Use a name of 1 to 32 characters.'**
  String get failureInvalidDisplayName;

  /// Error message for a failed request.
  ///
  /// In en, this message translates to:
  /// **'Camera or microphone is not available.'**
  String get failureMediaDevice;

  /// Error message for a failed request.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet connection and try again.'**
  String get failureNetwork;

  /// Error message for a failed request.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again in a moment.'**
  String get failureServer;

  /// Error message for a failed request: 503 server_busy, the server is at capacity; nothing counted against the user.
  ///
  /// In en, this message translates to:
  /// **'The server is busy right now. Try again in a moment.'**
  String get failureServerBusy;

  /// Error message for a failed request: media server refused the connection.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect to the call. Check your connection and try again.'**
  String get failureMediaRefused;

  /// Error message for a failed request: unknown error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again in a moment.'**
  String get failureUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
