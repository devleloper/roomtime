// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'RoomTime';

  @override
  String get commonShowPassword => 'Show password';

  @override
  String get commonHidePassword => 'Hide password';

  @override
  String get homeCreateRoom => 'Create Room';

  @override
  String get homeCreate => 'Create';

  @override
  String get homePasswordOptional => 'Password (optional)';

  @override
  String get homeCameraPreview => 'Camera preview';

  @override
  String get homeJoinWithCode => 'Join with code';

  @override
  String get homeJoinLabel => 'Code or link';

  @override
  String get homeJoin => 'Join';

  @override
  String get homeChecking => 'Checking…';

  @override
  String get homeRecent => 'Recent rooms';

  @override
  String get homeRecentEmpty => 'Rooms you create or join appear here.';

  @override
  String get homeRecentHost => 'You created it';

  @override
  String homeRecentRemoveFor(String room) {
    return 'Remove $room from recent';
  }

  @override
  String get homeRecentRemoved => 'Removed from recent';

  @override
  String get homeUndo => 'Undo';

  @override
  String homeRecentRow(String room, String when) {
    return '$room, $when';
  }

  @override
  String get homeJustNow => 'just now';

  @override
  String homeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String homeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String get homeYesterday => 'yesterday';

  @override
  String homeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get homeInvalidCode =>
      'That doesn\'t look like a room code. Codes have 10 letters, like abc-defg-hjk.';

  @override
  String get homeInvalidInviteLink => 'This invite link is invalid.';

  @override
  String get homeNotARoomLink => 'This link isn\'t a room invite.';

  @override
  String get homeCancel => 'Cancel';

  @override
  String get homeCreateNameLabel => 'Room name (optional)';

  @override
  String get homeCreatePasswordTooShort => 'Use at least 4 characters';

  @override
  String get homeCreatePasswordTooLong =>
      'Too long: up to 64 Latin characters (36 in Cyrillic)';

  @override
  String get homeCreateRetry => 'Try again';

  @override
  String get roomFinding => 'Finding the room…';

  @override
  String roomTitleUnnamed(String code) {
    return 'Room $code';
  }

  @override
  String get roomNameLabel => 'Your name';

  @override
  String get roomNameRequired => 'Enter your name';

  @override
  String get roomNameTooLong => 'Use at most 32 characters';

  @override
  String get roomPasswordLabel => 'Room password';

  @override
  String get roomPasswordHelper => 'Ask the person who invited you';

  @override
  String get roomPasswordRequired => 'This room needs a password.';

  @override
  String get roomWrongPassword => 'Wrong password. Check it and try again.';

  @override
  String roomTooManyAttempts(String mmss) {
    return 'Too many attempts. Try again in $mmss.';
  }

  @override
  String get roomCanTryAgain => 'You can try again';

  @override
  String get roomJoin => 'Join call';

  @override
  String get roomJoining => 'Joining…';

  @override
  String get roomLockedNotice =>
      'The host isn\'t letting new people in right now.';

  @override
  String get roomHostNotice => 'You are the host of this room.';

  @override
  String get roomBack => 'Back';

  @override
  String get roomPreviewOn => 'Camera preview, camera on';

  @override
  String get roomPreviewOff => 'Camera preview, camera off';

  @override
  String get roomPermExplainer =>
      'Allow camera and microphone so others can see and hear you.';

  @override
  String get roomPermAllow => 'Allow';

  @override
  String get roomCameraBlocked => 'Camera is blocked';

  @override
  String get roomMicBlocked => 'Microphone is blocked. Others won\'t hear you.';

  @override
  String get roomOpenSettings => 'Open settings';

  @override
  String get roomCameraBlockedWeb =>
      'Camera is blocked. Allow access in the browser\'s address bar, then reload the page.';

  @override
  String get roomCameraBlockedDesktop =>
      'Camera is blocked. Allow access in System Settings, Privacy & Security.';

  @override
  String get roomMicBlockedWeb =>
      'Microphone is blocked. Others won\'t hear you. Allow access in the browser\'s address bar, then reload the page.';

  @override
  String get roomMicBlockedDesktop =>
      'Microphone is blocked. Others won\'t hear you. Allow access in System Settings, Privacy & Security.';

  @override
  String get roomMic => 'Microphone';

  @override
  String get roomCamera => 'Camera';

  @override
  String get roomFlip => 'Flip camera';

  @override
  String get roomSpeaker => 'Speaker';

  @override
  String get roomEarpiece => 'Phone';

  @override
  String get roomInvite => 'Invite';

  @override
  String get roomParticipants => 'Participants';

  @override
  String get roomLeave => 'Leave';

  @override
  String roomMicTurnOff(String shortcut) {
    return 'Turn off microphone ($shortcut)';
  }

  @override
  String roomMicTurnOn(String shortcut) {
    return 'Turn on microphone ($shortcut)';
  }

  @override
  String roomCameraTurnOff(String shortcut) {
    return 'Turn off camera ($shortcut)';
  }

  @override
  String roomCameraTurnOn(String shortcut) {
    return 'Turn on camera ($shortcut)';
  }

  @override
  String get roomSwitchToEarpiece => 'Switch to phone earpiece';

  @override
  String get roomSwitchToSpeaker => 'Switch to speaker';

  @override
  String get roomSoundBlocked => 'Your browser paused the sound.';

  @override
  String get roomTurnOnSound => 'Turn on sound';

  @override
  String get roomMicUnavailable =>
      'Microphone isn\'t available. Others can\'t hear you.';

  @override
  String get roomMicUnavailableWeb =>
      'Microphone isn\'t available. Others can\'t hear you. Check access in the browser\'s address bar.';

  @override
  String get roomAlone => 'You\'re the only one here';

  @override
  String get roomAloneBody => 'Share the link to invite someone.';

  @override
  String get roomYou => 'You';

  @override
  String get roomHost => 'Host';

  @override
  String get roomSpeaking => 'speaking';

  @override
  String get roomMicOn => 'microphone on';

  @override
  String get roomMicOff => 'microphone off';

  @override
  String get roomWeakConnection => 'weak connection';

  @override
  String get roomWeakConnectionTitle => 'Weak connection';

  @override
  String get roomCamOff => 'camera off';

  @override
  String get roomSwap => 'Swap';

  @override
  String roomNameYou(String name) {
    return '$name (You)';
  }

  @override
  String roomNameYouHost(String name) {
    return '$name (You, host)';
  }

  @override
  String roomJoined(String name) {
    return '$name joined';
  }

  @override
  String roomLeft(String name) {
    return '$name left';
  }

  @override
  String roomJoinedMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people joined',
      one: '1 person joined',
    );
    return '$_temp0';
  }

  @override
  String get roomSomeone => 'Someone';

  @override
  String roomParticipantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participants',
      one: '1 participant',
    );
    return '$_temp0';
  }

  @override
  String roomExpiresSoon(String time) {
    return 'The invite link stops working at $time. Anyone who drops out after that can\'t rejoin.';
  }

  @override
  String get roomDismiss => 'Dismiss';

  @override
  String roomPeopleTitle(int count) {
    return 'Participants ($count)';
  }

  @override
  String get roomLock => 'Lock room';

  @override
  String get roomLockSub => 'No one new can join';

  @override
  String get roomLocked => 'Room locked';

  @override
  String get roomUnlocked => 'Room unlocked';

  @override
  String get roomPasswordSet => 'Password changed';

  @override
  String get roomPasswordRemoved => 'Password removed';

  @override
  String get roomInviteRotated =>
      'New invite link ready. The old one stopped working.';

  @override
  String get roomChangePassword => 'Change password';

  @override
  String get roomSetPassword => 'Set a password';

  @override
  String get roomRemovePassword => 'Remove password';

  @override
  String get roomPasswordDialogTitle => 'Room password';

  @override
  String get roomPasswordDialogBody =>
      'People already in the call stay. New people need the new password.';

  @override
  String get roomPasswordTooShort => 'Use at least 4 characters';

  @override
  String get roomPasswordTooLong =>
      'Too long: up to 64 Latin characters (36 in Cyrillic)';

  @override
  String get roomSave => 'Save';

  @override
  String get roomRemovePasswordTitle => 'Remove the password?';

  @override
  String get roomRemovePasswordBody =>
      'Anyone with the link can join without a password.';

  @override
  String get roomRemovePasswordConfirm => 'Remove';

  @override
  String roomOptionsFor(String name) {
    return 'Options for $name';
  }

  @override
  String get roomMute => 'Mute';

  @override
  String roomMuted(String name) {
    return '$name was muted';
  }

  @override
  String roomRemoved(String name) {
    return '$name was removed';
  }

  @override
  String get roomRemove => 'Remove from call';

  @override
  String roomRemoveTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get roomRemoveBody => 'They will be disconnected from the call.';

  @override
  String get roomBan => 'Don\'t let them rejoin';

  @override
  String get roomBanNote =>
      'This only blocks rejoining from the same device and browser. To keep someone out for good, change the invite code too.';

  @override
  String get roomRemoveConfirm => 'Remove';

  @override
  String get roomCancel => 'Cancel';

  @override
  String get roomRoomSettings => 'Room settings';

  @override
  String get roomLeaveSheetTitle => 'Leave the call?';

  @override
  String get roomLeaveLeave => 'Leave call';

  @override
  String get roomLeaveLeaveSub => 'The call continues without you';

  @override
  String get roomLeaveEnd => 'End call for everyone';

  @override
  String get roomLeaveEndSub => 'Everyone is disconnected and the room closes';

  @override
  String get roomLeaveConfirmTitle => 'End the call for everyone?';

  @override
  String get roomLeaveConfirmBody =>
      'Everyone will be disconnected and the invite link will stop working. This can\'t be undone.';

  @override
  String get roomLeaveConfirm => 'End for everyone';

  @override
  String get roomReconnecting => 'Connection lost. Reconnecting…';

  @override
  String get roomReconnected => 'Reconnected';

  @override
  String get roomEndedLeft => 'You left the call';

  @override
  String get roomEndedByHost => 'The call has ended';

  @override
  String get roomEndedByHostBody => 'The host ended the call for everyone.';

  @override
  String get roomEndedByYou => 'You ended the call for everyone';

  @override
  String get roomEndedRemoved => 'You were removed from the call';

  @override
  String get roomEndedExpired => 'The invite link has expired';

  @override
  String get roomEndedExpiredBody =>
      'You can\'t rejoin after the link expires. Ask the host for a new room.';

  @override
  String get roomEndedElsewhere => 'You joined from another device';

  @override
  String get roomEndedElsewhereBody =>
      'This call continues on your other device or browser tab.';

  @override
  String get roomEndedConnectionLost => 'Connection lost';

  @override
  String get roomEndedConnectionLostBody =>
      'Check your internet connection and try again.';

  @override
  String get roomRejoin => 'Rejoin';

  @override
  String get roomUseHere => 'Join here instead';

  @override
  String get roomHome => 'Back to home';

  @override
  String get roomNewRoom => 'New room';

  @override
  String get roomNotFoundTitle => 'Room not found';

  @override
  String get roomNotFoundBody =>
      'It may have ended, expired, or the invite code was changed. Ask for a new link.';

  @override
  String get roomFullTitle => 'The room is full';

  @override
  String roomFullBody(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'This room allows $max people. Try again later or ask the host.',
      one: 'This room allows 1 person. Try again later or ask the host.',
    );
    return '$_temp0';
  }

  @override
  String get roomFullBodyUnknown => 'Try again later or ask the host.';

  @override
  String get roomLockedTitle => 'The room is locked';

  @override
  String get roomLockedBody =>
      'The host isn\'t letting new people in right now.';

  @override
  String get roomBannedTitle => 'You can\'t join this room';

  @override
  String get roomBannedBody => 'The host removed you and blocked rejoining.';

  @override
  String get roomTryAgain => 'Try again';

  @override
  String get roomNoConnectionTitle => 'No connection';

  @override
  String get roomSomethingWrongTitle => 'Something went wrong';

  @override
  String get roomShortcutsTitle => 'Keyboard shortcuts';

  @override
  String get roomShortcutMic => 'Turn microphone on or off';

  @override
  String get roomShortcutCamera => 'Turn camera on or off';

  @override
  String get roomShortcutPeople => 'Show or hide participants';

  @override
  String get roomShortcutHelp => 'Show shortcuts';

  @override
  String get roomClose => 'Close';

  @override
  String get inviteReady => 'Your room is ready';

  @override
  String get inviteTitle => 'Invite people';

  @override
  String get inviteCodeLabel => 'Room code';

  @override
  String get inviteLinkLabel => 'Invite link';

  @override
  String get inviteCopyLink => 'Copy link';

  @override
  String get inviteCopyCode => 'Copy code';

  @override
  String get inviteShare => 'Share…';

  @override
  String inviteShareText(String link) {
    return 'Join my call: $link';
  }

  @override
  String get inviteShareSubject => 'Join my call';

  @override
  String get inviteLinkCopied => 'Link copied';

  @override
  String get inviteCodeCopied => 'Code copied';

  @override
  String get invitePasswordNote =>
      'This room has a password. Send it separately.';

  @override
  String get inviteDone => 'Done';

  @override
  String get inviteRotate => 'Change invite code';

  @override
  String get inviteRotateTitle => 'Change the invite code?';

  @override
  String get inviteRotateBody =>
      'The old link and code stop working. People already in the call stay.';

  @override
  String get inviteRotateConfirm => 'Change code';

  @override
  String get inviteCancel => 'Cancel';

  @override
  String get failureRoomNotFound =>
      'Room not found. It may have ended, expired, or the invite code was changed.';

  @override
  String get failurePasswordRequired => 'This room needs a password.';

  @override
  String get failureInvalidPassword =>
      'Wrong password. Check it and try again.';

  @override
  String get failureRoomFull =>
      'The room is full. Try again later or ask the host.';

  @override
  String get failureRoomLocked =>
      'The host isn\'t letting new people in right now.';

  @override
  String get failureTooManyAttempts => 'Too many attempts. Try again later.';

  @override
  String get failureInvalidCode =>
      'That doesn\'t look like a room code. Codes have 10 letters, like abc-defg-hjk.';

  @override
  String get failureForbidden => 'Only the host can do this.';

  @override
  String get failureParticipantBanned =>
      'The host doesn\'t allow you in this room.';

  @override
  String get failureParticipantNotFound => 'This participant has already left.';

  @override
  String get failureInvalidRoomName =>
      'Use a room name of at most 40 characters.';

  @override
  String get failureInvalidPasswordInput =>
      'Use a password of 4 to 64 characters.';

  @override
  String get failureInvalidMaxParticipants =>
      'A room can have 2 to 10 participants.';

  @override
  String get failureInvalidLifetime =>
      'Choose a duration between 15 minutes and 24 hours.';

  @override
  String get failureInvalidDisplayName => 'Use a name of 1 to 32 characters.';

  @override
  String get failureMediaDevice => 'Camera or microphone is not available.';

  @override
  String get failureNetwork =>
      'No connection. Check your internet connection and try again.';

  @override
  String get failureServer =>
      'Something went wrong. Please try again in a moment.';

  @override
  String get failureServerBusy =>
      'The server is busy right now. Try again in a moment.';

  @override
  String get failureMediaRefused =>
      'Couldn\'t connect to the call. Check your connection and try again.';

  @override
  String get failureUnknown =>
      'Something went wrong. Please try again in a moment.';
}
