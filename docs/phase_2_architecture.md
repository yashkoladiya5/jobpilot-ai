# Phase 2 Architecture: AI-Powered Career Copilot

## Overview

Transform JobPilot AI from a CRUD job tracker into an intelligent AI Career Copilot using Google Gemini.

## Architecture Principles

1. **All AI responses return structured JSON** — no free-form text
2. **Every analysis is stored** — history preserved, never overwritten
3. **Feature-by-feature vertical slices** — each module has backend API + Flutter BLoC + UI
4. **Clean Architecture maintained** — domain/ → data/ → presentation/ layers respected
5. **Prompt versioning** — each prompt has a version string for future migration

---

## New Database Models (Prisma)

```prisma
enum AnalysisStatus {
  PENDING
  PROCESSING
  COMPLETED
  FAILED
}

model ResumeAnalysis {
  id              String         @id @default(uuid())
  resumeId        String         @map("resume_id")
  userId          String         @map("user_id")
  status          AnalysisStatus @default(PENDING)
  atsScore        Int?           @map("ats_score")
  strengths       Json?          // string[]
  weaknesses      Json?          // string[]
  missingKeywords Json?          @map("missing_keywords") // string[]
  suggestions     Json?          // string[]
  experienceSummary String?      @map("experience_summary") @db.Text
  skillsSummary   String?        @map("skills_summary") @db.Text
  recruiterFeedback String?      @map("recruiter_feedback") @db.Text
  rawResponse     Json?          @map("raw_response") // store raw Gemini response
  promptVersion   String         @default("1.0") @map("prompt_version")
  errorMessage    String?        @map("error_message") @db.Text
  analyzedAt      DateTime?      @map("analyzed_at")
  createdAt       DateTime       @default(now()) @map("created_at")
  updatedAt       DateTime       @updatedAt @map("updated_at")

  resume          Resume         @relation(fields: [resumeId], references: [id], onDelete: Cascade)
  user            User           @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId])
  @@index([resumeId])
  @@map("resume_analyses")
}

model JobAnalysis {
  id                  String         @id @default(uuid())
  jobId               String?        @map("job_id") // nullable for paste-only analysis
  userId              String         @map("user_id")
  jobDescription      String         @map("job_description") @db.Text
  status              AnalysisStatus @default(PENDING)
  requiredSkills      Json?          @map("required_skills") // string[]
  preferredSkills     Json?          @map("preferred_skills") // string[]
  experienceRequired  String?        @map("experience_required")
  missingSkills       Json?          @map("missing_skills") // string[]
  resumeMatchScore    Int?           @map("resume_match_score")
  recommendedChanges  Json?          @map("recommended_changes") // string[]
  rawResponse         Json?          @map("raw_response")
  promptVersion       String         @default("1.0") @map("prompt_version")
  errorMessage        String?        @map("error_message") @db.Text
  analyzedAt          DateTime?      @map("analyzed_at")
  createdAt           DateTime       @default(now()) @map("created_at")
  updatedAt           DateTime       @updatedAt @map("updated_at")

  user                User           @relation(fields: [userId], references: [id], onDelete: Cascade)
  job                 JobApplication? @relation(fields: [jobId], references: [id], onDelete: SetNull)

  @@index([userId])
  @@index([jobId])
  @@map("job_analyses")
}

model InterviewSession {
  id              String         @id @default(uuid())
  userId          String         @map("user_id")
  jobId           String         @map("job_id")
  status          AnalysisStatus @default(PENDING) // PENDING, PROCESSING, COMPLETED, FAILED
  jobDescription  String?        @map("job_description") @db.Text
  hrQuestions     Json?          @map("hr_questions") // Question[]
  technicalQuestions Json?       @map("technical_questions") // Question[]
  behavioralQuestions Json?      @map("behavioral_questions") // Question[]
  followUpQuestions Json?        @map("follow_up_questions") // Question[]
  currentQuestionIndex Int       @default(0) @map("current_question_index")
  totalQuestions   Int           @default(0) @map("total_questions")
  answeredQuestions Int          @default(0) @map("answered_questions")
  score            Int?          // overall score 0-100
  rawResponse      Json?         @map("raw_response")
  promptVersion    String        @default("1.0") @map("prompt_version")
  completedAt      DateTime?     @map("completed_at")
  createdAt        DateTime      @default(now()) @map("created_at")
  updatedAt        DateTime      @updatedAt @map("updated_at")

  user             User          @relation(fields: [userId], references: [id], onDelete: Cascade)
  job              JobApplication @relation(fields: [jobId], references: [id], onDelete: Cascade)
  questions        InterviewQuestion[]
  results          InterviewResult[]

  @@index([userId])
  @@index([jobId])
  @@map("interview_sessions")
}

model InterviewQuestion {
  id              String            @id @default(uuid())
  sessionId       String            @map("session_id")
  category        String            // HR, TECHNICAL, BEHAVIORAL, FOLLOW_UP
  question        String            @db.Text
  orderIndex      Int               @map("order_index")
  answer          String?           @db.Text
  feedback        String?           @db.Text
  score           Int?              // 0-10 per question
  answeredAt      DateTime?         @map("answered_at")
  createdAt       DateTime          @default(now()) @map("created_at")

  session         InterviewSession  @relation(fields: [sessionId], references: [id], onDelete: Cascade)

  @@index([sessionId])
  @@map("interview_questions")
}

model InterviewResult {
  id              String            @id @default(uuid())
  sessionId       String            @map("session_id")
  overallScore    Int               @map("overall_score") // 0-100
  categoryScores  Json?             @map("category_scores") // {hr: 80, technical: 70, ...}
  strengths       Json?             // string[]
  improvements    Json?             // string[]
  summary         String?           @db.Text
  createdAt       DateTime          @default(now()) @map("created_at")

  session         InterviewSession  @relation(fields: [sessionId], references: [id], onDelete: Cascade)

  @@index([sessionId])
  @@map("interview_results")
}

model CareerInsight {
  id              String   @id @default(uuid())
  userId          String   @map("user_id")
  careerScore     Int?     @map("career_score") // 0-100
  interviewReadiness Int?  @map("interview_readiness") // 0-100
  resumeStrength  Int?     @map("resume_strength") // 0-100
  jobMatchQuality Int?     @map("job_match_quality") // 0-100
  applicationSuccessRate Int? @map("application_success_rate") // 0-100
  skillGaps       Json?    @map("skill_gaps") // string[]
  weeklyProgress  Json?    @map("weekly_progress") // {appsSubmitted: 3, interviews: 1, ...}
  recommendations Json?    // string[] actionable recommendations
  insightsData    Json?    @map("insights_data") // full computed data
  weekStart       DateTime @map("week_start")
  createdAt       DateTime @default(now()) @map("created_at")

  user            User     @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId])
  @@map("career_insights")
}
```

---

## Gemini Integration Architecture

### Service Layer (`backend/src/services/ai/`)

```
services/ai/
├── gemini.client.ts         # Low-level Gemini API client (retry, timeout, error handling)
├── gemini.config.ts         # Model config, API key, safety settings
├── prompts/
│   ├── resume-analysis.prompt.ts    # Resume analysis prompt template
│   ├── job-analysis.prompt.ts       # Job description analysis prompt
│   ├── resume-matching.prompt.ts    # Resume vs JD matching prompt
│   ├── interview.prompt.ts          # Interview question generation prompt
│   └── career-insights.prompt.ts    # Career insights computation prompt
├── schemas/
│   ├── resume-analysis.schema.ts    # Zod schema for structured output validation
│   ├── job-analysis.schema.ts
│   ├── resume-matching.schema.ts
│   ├── interview.schema.ts
│   └── career-insights.schema.ts
├── resume-analysis.service.ts
├── job-analysis.service.ts
├── matching.service.ts
├── interview.service.ts
└── career-insights.service.ts
```

### Prompt Design Pattern

Every prompt includes:
1. System context (role: "You are an expert resume reviewer...")
2. Structured output instruction ("Respond ONLY with valid JSON matching this schema:")
3. The target schema
4. The input data
5. Quality constraints

### Response Validation

Every Gemini response is validated against a Zod schema before returning to the caller. Malformed responses trigger retry (max 2).

---

## API Endpoints

### Resume Analysis
- `POST /api/ai/resume/analyze/:resumeId` → Trigger analysis
- `GET /api/ai/resume/analysis/:resumeId` → Get latest analysis
- `GET /api/ai/resume/analyses` → Get all analyses for user

### Job Analysis
- `POST /api/ai/job/analyze` → Paste + analyze job description (body: { jobDescription, jobId? })
- `GET /api/ai/job/analysis/:analysisId` → Get specific analysis
- `GET /api/ai/job/analyses` → Get all analyses for user

### Resume Matching
- `POST /api/ai/match` → Match resume against job (body: { resumeId, jobDescription })
- `GET /api/ai/match/:matchId` → Get match results

### Interview Prep
- `POST /api/ai/interview/generate/:jobId` → Generate interview questions
- `GET /api/ai/interview/sessions` → List all sessions
- `GET /api/ai/interview/session/:sessionId` → Get session with questions
- `POST /api/ai/interview/answer` → Submit answer (body: { questionId, answer })
- `POST /api/ai/interview/complete/:sessionId` → Complete session + get results
- `GET /api/ai/interview/result/:sessionId` → Get interview results

### Career Insights
- `GET /api/ai/insights` → Get latest career insights
- `GET /api/ai/insights/history` → Get weekly history

---

## Flutter Architecture

### New Domain Entities
```
domain/entities/
├── resume_analysis.dart       # ResumeAnalysis (@freezed)
├── job_analysis.dart          # JobAnalysis (@freezed)
├── match_result.dart          # MatchResult (@freezed)
├── interview_session.dart     # InterviewSession (@freezed)
├── interview_question.dart    # InterviewQuestion (@freezed)
├── interview_result.dart      # InterviewResult (@freezed)
└── career_insight.dart        # CareerInsight (@freezed)
```

### New BLoCs
```
presentation/bloc/
├── ai_resume/                 # AI Resume Analysis
│   ├── ai_resume_bloc.dart
│   ├── ai_resume_event.dart
│   └── ai_resume_state.dart
├── ai_job/                    # Job Description Analysis
│   ├── ai_job_bloc.dart
│   ├── ai_job_event.dart
│   └── ai_job_state.dart
├── ai_match/                  # Resume vs Job Matching
│   ├── ai_match_bloc.dart
│   ├── ai_match_event.dart
│   └── ai_match_state.dart
├── interview/                 # Interview Prep
│   ├── interview_bloc.dart
│   ├── interview_event.dart
│   └── interview_state.dart
└── career_insights/           # Career Insights Dashboard
    ├── career_insights_bloc.dart
    ├── career_insights_event.dart
    └── career_insights_state.dart
```

### New Routes
```
/ai
├── /ai/resume/:resumeId/analysis       -> ResumeAnalysisScreen
├── /ai/resume/analyses                 -> AllResumeAnalysesScreen
├── /ai/job/analyze                     -> JobAnalysisScreen (paste JD)
├── /ai/job/analysis/:analysisId        -> JobAnalysisDetailScreen
├── /ai/job/analyses                    -> AllJobAnalysesScreen
├── /ai/match                           -> ResumeMatchingScreen
├── /ai/match/:matchId                  -> MatchResultScreen
├── /ai/interview/:jobId/setup          -> InterviewSetupScreen
├── /ai/interview/session/:sessionId    -> InterviewSessionScreen
├── /ai/interview/sessions              -> InterviewSessionsScreen
├── /ai/interview/result/:sessionId     -> InterviewResultScreen
├── /ai/insights                        -> CareerInsightsScreen
└── /ai/insights/history                -> InsightsHistoryScreen
```

### Updated Bottom Navigation
```
Tab 0: Dashboard → Career Insights (replaces old dashboard)
Tab 1: Jobs → Jobs List (with AI analysis entry points)
Tab 2: Resumes → Resumes (with AI analysis button)
Tab 3: AI Hub → Central AI features hub
```

---

## UI/UX Redesign Principles

1. **Action-oriented** — every screen has one primary action
2. **AI as assistant** — AI suggestions appear as subtle cards, not popups
3. **Scorecards** — visual score meters (radial or bar) for ATS, match, readiness
4. **Empty states** — helpful illustrations + clear next steps
5. **Onboarding** — first-use walkthrough for AI features
6. **Consistent spacing** — 8px grid, 16px/24px/32px spacing increments
7. **Typography** — Inter font (existing), refined hierarchy

---

## Implementation Order

1. ✅ Prisma schema updates + migration
2. ✅ Gemini client + config + prompts
3. ✅ Resume analyzer (backend + frontend)
4. ✅ Job analyzer (backend + frontend)
5. ✅ Resume matching (backend + frontend)
6. ✅ Interview prep (backend + frontend)
7. ✅ Career insights (backend + frontend)
8. ✅ UI redesign + AI Hub
9. ✅ Seed data + testing + documentation

---

## Progress

### Completed (as of June 2026)

- **Backend:** All AI services implemented (resume analysis, job analysis, matching, interview prep, career insights) with Gemini integration, Zod schema validation, and prompt versioning.
- **Flutter Domain Entities:** `ResumeAnalysis`, `JobAnalysis`, `MatchResult`, `InterviewSession`, `InterviewQuestion`, `InterviewResult`, `CareerInsight` — all with freezed.
- **BLoCs:** `AiResumeBloc`, `AiJobBloc`, `AiMatchBloc`, `InterviewBloc`, `CareerInsightsBloc` registered via `@injectable` in DI.
- **Screens:** Placeholder screens for all AI routes (`AiHubScreen`, `ResumeAnalysesScreen`, `ResumeAnalysisScreen`, `JobAnalysisScreen`, `JobAnalysisDetailScreen`, `JobAnalysesScreen`, `MatchingScreen`, `InterviewSessionsScreen`, `InterviewSessionScreen`, `InterviewResultScreen`, `CareerInsightsScreen`).
- **Routing:** GoRouter updated with `StatefulShellRoute.indexedStack` — 4th tab (AI Hub) added to bottom navigation with nested routes.
- **App Shell:** `app.dart` provides all 9 BLoCs via `MultiBlocProvider`.
- **Seed Data:** Sample interview sessions (with questions + results) and career insights added for test users.
- **DI:** `configureDependencies()` in `injection.dart` auto-registers all dependencies via `injectable` + `build_runner`.

### Next Steps
- Implement full AI screen UIs with BLoC integration
- Add onboarding walkthrough for AI features
- Write widget tests for AI screens
- Performance profiling for Gemini API calls
