// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'RoomTime';

  @override
  String get commonShowPassword => 'Показать пароль';

  @override
  String get commonHidePassword => 'Скрыть пароль';

  @override
  String get homeCreateRoom => 'Создать комнату';

  @override
  String get homeCreate => 'Создать';

  @override
  String get homePasswordOptional => 'Пароль (необязательно)';

  @override
  String get homeCameraPreview => 'Превью камеры';

  @override
  String get homeJoinWithCode => 'Войти по коду';

  @override
  String get homeJoinLabel => 'Код или ссылка';

  @override
  String get homeJoin => 'Войти';

  @override
  String get homeChecking => 'Проверяем…';

  @override
  String get homeRecent => 'Недавние комнаты';

  @override
  String get homeRecentEmpty =>
      'Здесь появятся комнаты, которые вы создали или в которые вошли.';

  @override
  String get homeRecentHost => 'Создана вами';

  @override
  String homeRecentRemoveFor(String room) {
    return 'Убрать $room из недавних';
  }

  @override
  String get homeRecentRemoved => 'Убрано из недавних';

  @override
  String get homeUndo => 'Отменить';

  @override
  String homeRecentRow(String room, String when) {
    return '$room, $when';
  }

  @override
  String get homeJustNow => 'только что';

  @override
  String homeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минуты назад',
      many: '$count минут назад',
      few: '$count минуты назад',
      one: '$count минуту назад',
    );
    return '$_temp0';
  }

  @override
  String homeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часа назад',
      many: '$count часов назад',
      few: '$count часа назад',
      one: '$count час назад',
    );
    return '$_temp0';
  }

  @override
  String get homeYesterday => 'вчера';

  @override
  String homeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня назад',
      many: '$count дней назад',
      few: '$count дня назад',
      one: '$count день назад',
    );
    return '$_temp0';
  }

  @override
  String get homeInvalidCode =>
      'Это не похоже на код комнаты. Код состоит из 10 букв, например abc-defg-hjk.';

  @override
  String get homeInvalidInviteLink => 'Ссылка-приглашение недействительна.';

  @override
  String get homeNotARoomLink => 'Это не ссылка-приглашение в комнату.';

  @override
  String get homeCancel => 'Отмена';

  @override
  String get homeCreateNameLabel => 'Название (необязательно)';

  @override
  String get homeCreatePasswordTooShort => 'Не меньше 4 символов';

  @override
  String get homeCreatePasswordTooLong =>
      'Слишком длинный: до 64 латинских символов (кириллицей до 36)';

  @override
  String get homeCreateRetry => 'Повторить';

  @override
  String get roomFinding => 'Ищем комнату…';

  @override
  String roomTitleUnnamed(String code) {
    return 'Комната $code';
  }

  @override
  String get roomNameLabel => 'Ваше имя';

  @override
  String get roomNameRequired => 'Введите имя';

  @override
  String get roomNameTooLong => 'Не больше 32 символов';

  @override
  String get roomPasswordLabel => 'Пароль комнаты';

  @override
  String get roomPasswordHelper => 'Узнайте у того, кто вас пригласил';

  @override
  String get roomPasswordRequired => 'Для этой комнаты нужен пароль.';

  @override
  String get roomWrongPassword =>
      'Неверный пароль. Проверьте его и попробуйте снова.';

  @override
  String roomTooManyAttempts(String mmss) {
    return 'Слишком много попыток. Повторите через $mmss.';
  }

  @override
  String get roomCanTryAgain => 'Можно попробовать снова';

  @override
  String get roomJoin => 'Войти в звонок';

  @override
  String get roomJoining => 'Входим…';

  @override
  String get roomLockedNotice =>
      'Организатор сейчас не пускает новых участников.';

  @override
  String get roomHostNotice => 'Вы организатор этой комнаты.';

  @override
  String get roomBack => 'Назад';

  @override
  String get roomPreviewOn => 'Предпросмотр камеры, камера включена';

  @override
  String get roomPreviewOff => 'Предпросмотр камеры, камера выключена';

  @override
  String get roomPermExplainer =>
      'Разрешите доступ к камере и микрофону, чтобы другие вас видели и слышали.';

  @override
  String get roomPermAllow => 'Разрешить';

  @override
  String get roomCameraBlocked => 'Доступ к камере запрещён';

  @override
  String get roomMicBlocked =>
      'Доступ к микрофону запрещён. Другие вас не услышат.';

  @override
  String get roomOpenSettings => 'Открыть настройки';

  @override
  String get roomCameraBlockedWeb =>
      'Доступ к камере запрещён. Разрешите его в адресной строке браузера и перезагрузите страницу.';

  @override
  String get roomCameraBlockedDesktop =>
      'Доступ к камере запрещён. Разрешите его в Системных настройках, раздел «Конфиденциальность и безопасность».';

  @override
  String get roomMicBlockedWeb =>
      'Доступ к микрофону запрещён. Другие вас не услышат. Разрешите его в адресной строке браузера и перезагрузите страницу.';

  @override
  String get roomMicBlockedDesktop =>
      'Доступ к микрофону запрещён. Другие вас не услышат. Разрешите его в Системных настройках, раздел «Конфиденциальность и безопасность».';

  @override
  String get roomMic => 'Микрофон';

  @override
  String get roomCamera => 'Камера';

  @override
  String get roomFlip => 'Сменить камеру';

  @override
  String get roomSpeaker => 'Динамик';

  @override
  String get roomEarpiece => 'Телефон';

  @override
  String get roomInvite => 'Пригласить';

  @override
  String get roomParticipants => 'Участники';

  @override
  String get roomLeave => 'Выйти';

  @override
  String roomMicTurnOff(String shortcut) {
    return 'Выключить микрофон ($shortcut)';
  }

  @override
  String roomMicTurnOn(String shortcut) {
    return 'Включить микрофон ($shortcut)';
  }

  @override
  String roomCameraTurnOff(String shortcut) {
    return 'Выключить камеру ($shortcut)';
  }

  @override
  String roomCameraTurnOn(String shortcut) {
    return 'Включить камеру ($shortcut)';
  }

  @override
  String get roomSwitchToEarpiece => 'Переключить на разговорный динамик';

  @override
  String get roomSwitchToSpeaker => 'Переключить на громкую связь';

  @override
  String get roomSoundBlocked => 'Браузер приостановил звук.';

  @override
  String get roomTurnOnSound => 'Включить звук';

  @override
  String get roomMicUnavailable => 'Микрофон недоступен. Другие вас не слышат.';

  @override
  String get roomMicUnavailableWeb =>
      'Микрофон недоступен. Другие вас не слышат. Проверьте доступ в адресной строке браузера.';

  @override
  String get roomAlone => 'Кроме вас, здесь никого нет';

  @override
  String get roomAloneBody => 'Отправьте ссылку, чтобы кого-нибудь пригласить.';

  @override
  String get roomYou => 'Вы';

  @override
  String get roomHost => 'Организатор';

  @override
  String get roomSpeaking => 'говорит';

  @override
  String get roomMicOn => 'микрофон включён';

  @override
  String get roomMicOff => 'микрофон выключен';

  @override
  String get roomWeakConnection => 'слабое соединение';

  @override
  String get roomWeakConnectionTitle => 'Слабое соединение';

  @override
  String get roomCamOff => 'камера выключена';

  @override
  String get roomSwap => 'Поменять местами';

  @override
  String roomNameYou(String name) {
    return '$name (Вы)';
  }

  @override
  String roomNameYouHost(String name) {
    return '$name (Вы, организатор)';
  }

  @override
  String roomJoined(String name) {
    return '$name присоединяется к звонку';
  }

  @override
  String roomLeft(String name) {
    return '$name покидает звонок';
  }

  @override
  String roomJoinedMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count человека присоединились',
      many: '$count человек присоединились',
      few: '$count человека присоединились',
      one: '$count человек присоединился',
    );
    return '$_temp0';
  }

  @override
  String get roomSomeone => 'Кто-то';

  @override
  String roomParticipantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участника',
      many: '$count участников',
      few: '$count участника',
      one: '$count участник',
    );
    return '$_temp0';
  }

  @override
  String roomExpiresSoon(String time) {
    return 'Ссылка-приглашение перестанет работать в $time. Кто отключится после этого, не сможет вернуться.';
  }

  @override
  String get roomDismiss => 'Скрыть';

  @override
  String roomPeopleTitle(int count) {
    return 'Участники ($count)';
  }

  @override
  String get roomLock => 'Закрыть комнату';

  @override
  String get roomLockSub => 'Новые участники не смогут войти';

  @override
  String get roomLocked => 'Комната закрыта';

  @override
  String get roomUnlocked => 'Комната открыта';

  @override
  String get roomPasswordSet => 'Пароль изменён';

  @override
  String get roomPasswordRemoved => 'Пароль удалён';

  @override
  String get roomInviteRotated =>
      'Новая ссылка-приглашение готова. Старая больше не работает.';

  @override
  String get roomChangePassword => 'Изменить пароль';

  @override
  String get roomSetPassword => 'Задать пароль';

  @override
  String get roomRemovePassword => 'Удалить пароль';

  @override
  String get roomPasswordDialogTitle => 'Пароль комнаты';

  @override
  String get roomPasswordDialogBody =>
      'Те, кто уже в звонке, останутся. Новым участникам понадобится новый пароль.';

  @override
  String get roomPasswordTooShort => 'Не меньше 4 символов';

  @override
  String get roomPasswordTooLong =>
      'Слишком длинный: до 64 латинских символов (кириллицей до 36)';

  @override
  String get roomSave => 'Сохранить';

  @override
  String get roomRemovePasswordTitle => 'Удалить пароль?';

  @override
  String get roomRemovePasswordBody =>
      'Любой, у кого есть ссылка, сможет войти без пароля.';

  @override
  String get roomRemovePasswordConfirm => 'Удалить';

  @override
  String roomOptionsFor(String name) {
    return 'Действия: $name';
  }

  @override
  String get roomMute => 'Выключить микрофон';

  @override
  String roomMuted(String name) {
    return 'Микрофон участника $name выключен';
  }

  @override
  String roomRemoved(String name) {
    return 'Участник $name удалён из звонка';
  }

  @override
  String get roomRemove => 'Удалить из звонка';

  @override
  String roomRemoveTitle(String name) {
    return 'Удалить участника $name?';
  }

  @override
  String get roomRemoveBody => 'Участник будет отключён от звонка.';

  @override
  String get roomBan => 'Не пускать обратно';

  @override
  String get roomBanNote =>
      'Это блокирует повторный вход только с того же устройства и браузера. Чтобы не пускать человека совсем, смените также код комнаты.';

  @override
  String get roomRemoveConfirm => 'Удалить';

  @override
  String get roomCancel => 'Отмена';

  @override
  String get roomRoomSettings => 'Настройки комнаты';

  @override
  String get roomLeaveSheetTitle => 'Выйти из звонка?';

  @override
  String get roomLeaveLeave => 'Выйти из звонка';

  @override
  String get roomLeaveLeaveSub => 'Звонок продолжится без вас';

  @override
  String get roomLeaveEnd => 'Завершить для всех';

  @override
  String get roomLeaveEndSub => 'Все будут отключены, комната закроется';

  @override
  String get roomLeaveConfirmTitle => 'Завершить звонок для всех?';

  @override
  String get roomLeaveConfirmBody =>
      'Все участники будут отключены, а ссылка-приглашение перестанет работать. Это нельзя отменить.';

  @override
  String get roomLeaveConfirm => 'Завершить для всех';

  @override
  String get roomReconnecting => 'Соединение потеряно. Переподключаемся…';

  @override
  String get roomReconnected => 'Соединение восстановлено';

  @override
  String get roomEndedLeft => 'Вы вышли из звонка';

  @override
  String get roomEndedByHost => 'Звонок завершён';

  @override
  String get roomEndedByHostBody => 'Организатор завершил звонок для всех.';

  @override
  String get roomEndedByYou => 'Вы завершили звонок для всех';

  @override
  String get roomEndedRemoved => 'Вас удалили из звонка';

  @override
  String get roomEndedExpired => 'Срок действия приглашения истёк';

  @override
  String get roomEndedExpiredBody =>
      'После истечения срока приглашения вернуться нельзя. Попросите организатора создать новую комнату.';

  @override
  String get roomEndedElsewhere => 'Вы вошли с другого устройства';

  @override
  String get roomEndedElsewhereBody =>
      'Звонок продолжается на другом устройстве или в другой вкладке браузера.';

  @override
  String get roomEndedConnectionLost => 'Соединение потеряно';

  @override
  String get roomEndedConnectionLostBody =>
      'Проверьте подключение к интернету и попробуйте снова.';

  @override
  String get roomRejoin => 'Вернуться';

  @override
  String get roomUseHere => 'Продолжить здесь';

  @override
  String get roomHome => 'На главную';

  @override
  String get roomNewRoom => 'Новая комната';

  @override
  String get roomNotFoundTitle => 'Комната не найдена';

  @override
  String get roomNotFoundBody =>
      'Возможно, звонок завершён, срок приглашения истёк или код комнаты изменили. Попросите новую ссылку.';

  @override
  String get roomFullTitle => 'Комната заполнена';

  @override
  String roomFullBody(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other:
          'В комнате может быть не больше $max человека. Попробуйте позже или обратитесь к организатору.',
      many:
          'В комнате может быть не больше $max человек. Попробуйте позже или обратитесь к организатору.',
      few:
          'В комнате может быть не больше $max человек. Попробуйте позже или обратитесь к организатору.',
      one:
          'В комнате может быть не больше $max человека. Попробуйте позже или обратитесь к организатору.',
    );
    return '$_temp0';
  }

  @override
  String get roomFullBodyUnknown =>
      'Попробуйте позже или обратитесь к организатору.';

  @override
  String get roomLockedTitle => 'Комната закрыта';

  @override
  String get roomLockedBody =>
      'Организатор сейчас не пускает новых участников.';

  @override
  String get roomBannedTitle => 'Вы не можете войти в эту комнату';

  @override
  String get roomBannedBody =>
      'Организатор удалил вас и запретил возвращаться.';

  @override
  String get roomTryAgain => 'Попробовать снова';

  @override
  String get roomNoConnectionTitle => 'Нет соединения';

  @override
  String get roomSomethingWrongTitle => 'Что-то пошло не так';

  @override
  String get roomShortcutsTitle => 'Сочетания клавиш';

  @override
  String get roomShortcutMic => 'Включить или выключить микрофон';

  @override
  String get roomShortcutCamera => 'Включить или выключить камеру';

  @override
  String get roomShortcutPeople => 'Показать или скрыть участников';

  @override
  String get roomShortcutHelp => 'Показать сочетания клавиш';

  @override
  String get roomClose => 'Закрыть';

  @override
  String get inviteReady => 'Ваша комната готова';

  @override
  String get inviteTitle => 'Пригласить участников';

  @override
  String get inviteCodeLabel => 'Код комнаты';

  @override
  String get inviteLinkLabel => 'Ссылка-приглашение';

  @override
  String get inviteCopyLink => 'Скопировать ссылку';

  @override
  String get inviteCopyCode => 'Скопировать код';

  @override
  String get inviteShare => 'Поделиться…';

  @override
  String inviteShareText(String link) {
    return 'Присоединяйтесь к звонку: $link';
  }

  @override
  String get inviteShareSubject => 'Присоединяйтесь к звонку';

  @override
  String get inviteLinkCopied => 'Ссылка скопирована';

  @override
  String get inviteCodeCopied => 'Код скопирован';

  @override
  String get invitePasswordNote =>
      'В этой комнате есть пароль. Отправьте его отдельно.';

  @override
  String get inviteDone => 'Готово';

  @override
  String get inviteRotate => 'Сменить код комнаты';

  @override
  String get inviteRotateTitle => 'Сменить код комнаты?';

  @override
  String get inviteRotateBody =>
      'Старые ссылка и код перестанут работать. Те, кто уже в звонке, останутся.';

  @override
  String get inviteRotateConfirm => 'Сменить код';

  @override
  String get inviteCancel => 'Отмена';

  @override
  String get failureRoomNotFound =>
      'Комната не найдена. Возможно, звонок завершён, срок приглашения истёк или код комнаты изменили.';

  @override
  String get failurePasswordRequired => 'Для этой комнаты нужен пароль.';

  @override
  String get failureInvalidPassword =>
      'Неверный пароль. Проверьте его и попробуйте снова.';

  @override
  String get failureRoomFull =>
      'Комната заполнена. Попробуйте позже или обратитесь к организатору.';

  @override
  String get failureRoomLocked =>
      'Организатор сейчас не пускает новых участников.';

  @override
  String get failureTooManyAttempts =>
      'Слишком много попыток. Попробуйте позже.';

  @override
  String get failureInvalidCode =>
      'Это не похоже на код комнаты. Код состоит из 10 букв, например abc-defg-hjk.';

  @override
  String get failureForbidden => 'Это может сделать только организатор.';

  @override
  String get failureParticipantBanned =>
      'Организатор не разрешает вам входить в эту комнату.';

  @override
  String get failureParticipantNotFound => 'Этот участник уже вышел.';

  @override
  String get failureInvalidRoomName =>
      'Название комнаты — не больше 40 символов.';

  @override
  String get failureInvalidPasswordInput => 'Пароль — от 4 до 64 символов.';

  @override
  String get failureInvalidMaxParticipants =>
      'В комнате может быть от 2 до 10 участников.';

  @override
  String get failureInvalidLifetime => 'Выберите срок от 15 минут до 24 часов.';

  @override
  String get failureInvalidDisplayName => 'Имя — от 1 до 32 символов.';

  @override
  String get failureMediaDevice => 'Камера или микрофон недоступны.';

  @override
  String get failureNetwork =>
      'Нет соединения. Проверьте подключение к интернету и попробуйте снова.';

  @override
  String get failureServer =>
      'Что-то пошло не так. Попробуйте ещё раз чуть позже.';

  @override
  String get failureServerBusy =>
      'Сервер сейчас перегружен. Попробуйте ещё раз через пару секунд.';

  @override
  String get failureMediaRefused =>
      'Не удалось подключиться к звонку. Проверьте соединение и попробуйте снова.';

  @override
  String get failureUnknown =>
      'Что-то пошло не так. Попробуйте ещё раз чуть позже.';
}
