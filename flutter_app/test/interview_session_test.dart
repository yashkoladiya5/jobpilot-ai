import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/domain/entities/interview_session.dart';

void main() {
  group('InterviewQuestion and InterviewSession Entity Tests', () {
    test('InterviewQuestion.fromJson parses question model accurately', () {
      final json = {
        'id': 'q-101',
        'question': 'How do you optimize render performance in Flutter?',
        'category': 'Technical',
        'difficulty': 'HARD',
        'answer': 'Using const constructors and isolating rebuilds with ValueListenableBuilder or BlocSelector.',
        'feedback': 'Excellent clear technical explanation.',
      };

      final question = InterviewQuestion.fromJson(json);

      expect(question.id, equals('q-101'));
      expect(question.question, contains('render performance'));
      expect(question.category, equals('Technical'));
      expect(question.difficulty, equals('HARD'));
      expect(question.answer, contains('ValueListenableBuilder'));
      expect(question.feedback, contains('Excellent'));
    });

    test('InterviewSession.fromJson parses session payload with questions array', () {
      final json = {
        'id': 'sess-500',
        'companyName': 'Stripe',
        'role': 'Senior Mobile Engineer',
        'status': 'COMPLETED',
        'totalQuestions': 3,
        'answeredQuestions': 3,
        'score': 91.5,
        'questions': [
          {
            'id': 'q-1',
            'question': 'Explain STAR format.',
            'category': 'Behavioral',
            'difficulty': 'MEDIUM',
            'answer': 'Situation, Task, Action, Result',
            'feedback': 'Good structure',
          },
        ],
        'createdAt': '2026-11-20T12:00:00.000Z',
      };

      final session = InterviewSession.fromJson(json);

      expect(session.id, equals('sess-500'));
      expect(session.companyName, equals('Stripe'));
      expect(session.role, equals('Senior Mobile Engineer'));
      expect(session.status, equals('COMPLETED'));
      expect(session.totalQuestions, equals(3));
      expect(session.answeredQuestions, equals(3));
      expect(session.score, equals(91.5));
      expect(session.questions.length, equals(1));
      expect(session.questions.first.category, equals('Behavioral'));
    });

    test('InterviewSession.fromJson handles null score for in-progress session', () {
      final json = {
        'id': 'sess-501',
        'companyName': 'Apple',
        'role': 'iOS Architect',
        'status': 'IN_PROGRESS',
        'totalQuestions': 5,
        'answeredQuestions': 1,
        'score': null,
        'questions': <Map<String, dynamic>>[],
        'createdAt': '2026-11-21T09:00:00.000Z',
      };

      final session = InterviewSession.fromJson(json);

      expect(session.id, equals('sess-501'));
      expect(session.score, isNull);
      expect(session.questions, isEmpty);
    });
  });
}
