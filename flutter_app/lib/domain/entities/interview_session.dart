class InterviewQuestion {
  final String id;
  final String question;
  final String category;
  final String difficulty;
  final String? answer;
  final String? feedback;

  InterviewQuestion({
    required this.id,
    required this.question,
    required this.category,
    required this.difficulty,
    this.answer,
    this.feedback,
  });

  factory InterviewQuestion.fromJson(Map<String, dynamic> json) =>
      InterviewQuestion(
        id: json['id'] as String,
        question: json['question'] as String,
        category: json['category'] as String,
        difficulty: json['difficulty'] as String,
        answer: json['answer'] as String?,
        feedback: json['feedback'] as String?,
      );
}

class InterviewSession {
  final String id;
  final String companyName;
  final String role;
  final String status;
  final int totalQuestions;
  final int answeredQuestions;
  final double? score;
  final List<InterviewQuestion> questions;
  final DateTime createdAt;

  InterviewSession({
    required this.id,
    required this.companyName,
    required this.role,
    required this.status,
    required this.totalQuestions,
    required this.answeredQuestions,
    this.score,
    required this.questions,
    required this.createdAt,
  });

  factory InterviewSession.fromJson(Map<String, dynamic> json) =>
      InterviewSession(
        id: json['id'] as String,
        companyName: json['companyName'] as String,
        role: json['role'] as String,
        status: json['status'] as String,
        totalQuestions: json['totalQuestions'] as int,
        answeredQuestions: json['answeredQuestions'] as int,
        score: (json['score'] as num?)?.toDouble(),
        questions: (json['questions'] as List)
            .map((e) =>
                InterviewQuestion.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
