import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/career_insight.dart';
import 'package:jobpilot_ai/domain/entities/cover_letter.dart';
import 'package:jobpilot_ai/domain/entities/interview_result.dart';
import 'package:jobpilot_ai/domain/entities/interview_session.dart';
import 'package:jobpilot_ai/domain/entities/job_analysis.dart';
import 'package:jobpilot_ai/domain/entities/resume_analysis.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';
import 'package:jobpilot_ai/domain/usecases/ai/analyze_job_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/ai/analyze_resume_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/ai/match_resume_job_usecase.dart';

class MockAiRepository implements AiRepository {
  @override
  Future<Either<Failure, ResumeAnalysis>> analyzeResume(String resumeId) async {
    return Right(
      ResumeAnalysis(
        id: 'ra-1',
        resumeId: resumeId,
        resumeFileName: 'test.pdf',
        atsScore: 85,
        strengths: ['Formatting'],
        weaknesses: [],
        missingKeywords: [],
        suggestions: [],
        experienceSummary: 'Experienced',
        skillsSummary: 'Flutter',
        recruiterFeedback: 'Great candidate',
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<Either<Failure, JobAnalysis>> analyzeJobDescription(
      String jobDescription, {String? jobId}) async {
    return Right(
      JobAnalysis(
        id: 'ja-1',
        jobId: jobId,
        description: jobDescription,
        analyzedAt: DateTime.now(),
        requiredSkills: ['Flutter'],
        preferredSkills: ['Dart'],
        experienceRequired: '3 years',
        missingSkills: [],
        matchScore: 90,
        recommendations: [],
      ),
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> matchResumeAndJob(
      String resumeId, String jobDescription) async {
    return const Right({'matchScore': 92, 'resumeId': 'res-1'});
  }

  @override
  Future<Either<Failure, CareerInsight>> getCareerInsights() async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));

  @override
  Future<Either<Failure, List<CareerInsight>>> getCareerInsightsHistory() async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));

  @override
  Future<Either<Failure, CoverLetter>> generateCoverLetter(
      String resumeId, String jobDescription,
      {String? jobId, String? tone}) async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));

  @override
  Future<Either<Failure, CoverLetter>> getCoverLetter(String id) async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));

  @override
  Future<Either<Failure, List<CoverLetter>>> getCoverLetters() async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));

  @override
  Future<Either<Failure, InterviewResult>> completeInterview(String sessionId) async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));

  @override
  Future<Either<Failure, InterviewSession>> generateInterviewQuestions(String jobId) async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));

  @override
  Future<Either<Failure, InterviewResult>> getInterviewResult(String sessionId) async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));

  @override
  Future<Either<Failure, InterviewSession>> getInterviewSession(String sessionId) async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));

  @override
  Future<Either<Failure, List<InterviewSession>>> getInterviewSessions() async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));

  @override
  Future<Either<Failure, List<JobAnalysis>>> getJobAnalyses() async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));

  @override
  Future<Either<Failure, JobAnalysis>> getJobAnalysis(String analysisId) async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));

  @override
  Future<Either<Failure, JobAnalysis>> getMatchResult(String matchId) async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));

  @override
  Future<Either<Failure, List<ResumeAnalysis>>> getResumeAnalyses() async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));

  @override
  Future<Either<Failure, ResumeAnalysis>> getResumeAnalysis(String resumeId) async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));

  @override
  Future<Either<Failure, Map<String, dynamic>>> submitAnswer(String questionId, String answer) async =>
      const Left(Failure.serverFailure(message: 'Unimplemented'));
}

void main() {
  late MockAiRepository mockRepo;
  late AnalyzeJobUseCase analyzeJobUseCase;
  late AnalyzeResumeUseCase analyzeResumeUseCase;
  late MatchResumeJobUseCase matchResumeJobUseCase;

  setUp(() {
    mockRepo = MockAiRepository();
    analyzeJobUseCase = AnalyzeJobUseCase(mockRepo);
    analyzeResumeUseCase = AnalyzeResumeUseCase(mockRepo);
    matchResumeJobUseCase = MatchResumeJobUseCase(mockRepo);
  });

  group('AI UseCases Tests', () {
    test('AnalyzeJobUseCase returns parsed JobAnalysis result', () async {
      final result = await analyzeJobUseCase('Senior Mobile Lead opening', jobId: 'job-10');
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected success'),
        (analysis) {
          expect(analysis.matchScore, equals(90));
          expect(analysis.requiredSkills, contains('Flutter'));
        },
      );
    });

    test('AnalyzeResumeUseCase returns ATS ResumeAnalysis result', () async {
      final result = await analyzeResumeUseCase('res-10');
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected success'),
        (analysis) => expect(analysis.atsScore, equals(85)),
      );
    });

    test('MatchResumeJobUseCase returns map of match details', () async {
      final result = await matchResumeJobUseCase('res-1', 'Mobile Engineer');
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected success'),
        (map) => expect(map['matchScore'], equals(92)),
      );
    });
  });
}
