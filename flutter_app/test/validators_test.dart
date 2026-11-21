import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/core/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    group('Email validator', () {
      test('rejects empty or null email', () {
        expect(Validators.email(null), equals('Email is required'));
        expect(Validators.email('  '), equals('Email is required'));
      });

      test('rejects invalid email formats', () {
        expect(Validators.email('plainaddress'), isNotNull);
        expect(Validators.email('missingdomain@'), isNotNull);
        expect(Validators.email('@nodomain.com'), isNotNull);
      });

      test('accepts valid email addresses', () {
        expect(Validators.email('engineer@jobpilot.ai'), isNull);
        expect(Validators.email('first.last@company.co.uk'), isNull);
      });
    });

    group('Password validator', () {
      test('rejects short passwords or missing required characters', () {
        expect(Validators.password(null), equals('Password is required'));
        expect(Validators.password('Ab1!'), contains('at least 8 characters'));
        expect(Validators.password('12345678!'), contains('at least one letter'));
        expect(Validators.password('abcdefgh!'), contains('at least one number'));
        expect(Validators.password('abcdefgh1'), contains('at least one special character'));
      });

      test('accepts strong compliant password', () {
        expect(Validators.password('SecretP@ss123'), isNull);
      });
    });

    group('Name and requiredField validator', () {
      test('validates name minimum length', () {
        expect(Validators.name(null), equals('Name is required'));
        expect(Validators.name('A'), contains('at least 2 characters'));
        expect(Validators.name('Alex Doe'), isNull);
      });

      test('validates requiredField with custom field name', () {
        expect(Validators.requiredField(null, 'Title'), equals('Title is required'));
        expect(Validators.requiredField('   ', 'Company'), equals('Company is required'));
        expect(Validators.requiredField('Google', 'Company'), isNull);
      });
    });

    group('URL and Phone validator', () {
      test('validates URL correctly', () {
        expect(Validators.url(null), isNull);
        expect(Validators.url(''), isNull);
        expect(Validators.url('not-a-url'), isNotNull);
        expect(Validators.url('https://jobpilot.ai'), isNull);
      });

      test('validates phone numbers', () {
        expect(Validators.phone(null), isNull);
        expect(Validators.phone('123'), isNotNull);
        expect(Validators.phone('+1 (555) 019-2834'), isNull);
        expect(Validators.phone('1234567890'), isNull);
      });
    });
  });
}
