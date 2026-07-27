import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

/// Represents an authenticated user in the application.
/// Holds core identity data returned from the backend API.
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    DateTime? createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
