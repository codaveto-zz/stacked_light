// @dart = 2.12
import 'package:stacked_light/data/enums/ui/notification_level_type.dart';
import 'package:stacked_light/data/enums/ui/notification_type.dart';

class ServiceResponse<T> {
  ServiceResponse._({
    required this.notificationLevelType,
    required this.notificationType,
    this.title,
    this.message,
    this.result,
  });

  final NotificationLevelType notificationLevelType;
  final NotificationType notificationType;
  final String? title;
  final String? message;
  final T? result;

  factory ServiceResponse.success({
    String? title,
    String? message,
    T? result,
    NotificationLevelType notificationLevelType = NotificationLevelType.success,
    NotificationType notificationType = NotificationType.snackbar,
  }) =>
      ServiceResponse._(
        notificationLevelType: notificationLevelType,
        title: title,
        message: message,
        notificationType: notificationType,
        result: result,
      );

  factory ServiceResponse.error({
    String? title,
    String? message,
    NotificationLevelType notificationLevelType = NotificationLevelType.error,
    NotificationType notificationType = NotificationType.dialog,
  }) =>
      ServiceResponse._(
        notificationLevelType: notificationLevelType,
        title: title,
        message: message,
        notificationType: notificationType,
      );

  bool get isSuccess => notificationLevelType == NotificationLevelType.success;
  E resultAsCast<E>() => result as E;
}
