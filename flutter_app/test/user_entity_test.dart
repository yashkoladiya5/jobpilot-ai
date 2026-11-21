import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/domain/entities/user.dart';

void main() {
  group('User Entity Tests', () {
    test('User.fromJson deserializes authenticated user correctly', () {
      final json = {
        'id': 'user-999',
        'email': 'developer@jobpilot.ai',
        'name': 'Alex Johnson',
        'profilePictureUrl': 'https://jobpilot.ai/avatar.png',
        'bio': 'Passionate Mobile & Backend Architect',
        'isEmailVerified': true,
        'createdAt': '2026-11-20T10:00:00.000Z',
      };

      final user = User.fromJson(json);

      expect(user.id, equals('user-999'));
      expect(user.email, equals('developer@jobpilot.ai'));
      expect(user.name, equals('Alex Johnson'));
      expect(user.profilePictureUrl, equals('https://jobpilot.ai/avatar.png'));
      expect(user.bio, equals('Passionate Mobile & Backend Architect'));
      expect(user.isEmailVerified, isTrue);
    });

    test('User.fromJson handles optional fields and default unverified status', () {
      final json = {
        'id': 'user-1000',
        'email': 'newuser@domain.com',
        'name': 'Jane Doe',
      };

      final user = User.fromJson(json);

      expect(user.id, equals('user-1000'));
      expect(user.email, equals('newuser@domain.com'));
      expect(user.name, equals('Jane Doe'));
      expect(user.profilePictureUrl, isNull);
      expect(user.bio, isNull);
      expect(user.isEmailVerified, isFalse);
      expect(user.createdAt, isNull);
    });
  });
}
