-- CreateEnum
CREATE TYPE "AnalysisStatus" AS ENUM ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED');

-- CreateTable
CREATE TABLE "resume_analyses" (
    "id" TEXT NOT NULL,
    "resume_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "status" "AnalysisStatus" NOT NULL DEFAULT 'PENDING',
    "ats_score" INTEGER,
    "strengths" JSONB,
    "weaknesses" JSONB,
    "missing_keywords" JSONB,
    "suggestions" JSONB,
    "experience_summary" TEXT,
    "skills_summary" TEXT,
    "recruiter_feedback" TEXT,
    "raw_response" JSONB,
    "prompt_version" TEXT NOT NULL DEFAULT '1.0',
    "error_message" TEXT,
    "analyzed_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "resume_analyses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "job_analyses" (
    "id" TEXT NOT NULL,
    "job_id" TEXT,
    "user_id" TEXT NOT NULL,
    "job_description" TEXT NOT NULL,
    "status" "AnalysisStatus" NOT NULL DEFAULT 'PENDING',
    "required_skills" JSONB,
    "preferred_skills" JSONB,
    "experience_required" TEXT,
    "missing_skills" JSONB,
    "resume_match_score" INTEGER,
    "recommended_changes" JSONB,
    "raw_response" JSONB,
    "prompt_version" TEXT NOT NULL DEFAULT '1.0',
    "error_message" TEXT,
    "analyzed_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "job_analyses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "interview_sessions" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "job_id" TEXT NOT NULL,
    "status" "AnalysisStatus" NOT NULL DEFAULT 'PENDING',
    "job_description" TEXT,
    "hr_questions" JSONB,
    "technical_questions" JSONB,
    "behavioral_questions" JSONB,
    "follow_up_questions" JSONB,
    "current_question_index" INTEGER NOT NULL DEFAULT 0,
    "total_questions" INTEGER NOT NULL DEFAULT 0,
    "answered_questions" INTEGER NOT NULL DEFAULT 0,
    "score" INTEGER,
    "raw_response" JSONB,
    "prompt_version" TEXT NOT NULL DEFAULT '1.0',
    "completed_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "interview_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "interview_questions" (
    "id" TEXT NOT NULL,
    "session_id" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "question" TEXT NOT NULL,
    "order_index" INTEGER NOT NULL,
    "answer" TEXT,
    "feedback" TEXT,
    "score" INTEGER,
    "answered_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "interview_questions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "interview_results" (
    "id" TEXT NOT NULL,
    "session_id" TEXT NOT NULL,
    "overall_score" INTEGER NOT NULL,
    "category_scores" JSONB,
    "strengths" JSONB,
    "improvements" JSONB,
    "summary" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "interview_results_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "career_insights" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "career_score" INTEGER,
    "interview_readiness" INTEGER,
    "resume_strength" INTEGER,
    "job_match_quality" INTEGER,
    "application_success_rate" INTEGER,
    "skill_gaps" JSONB,
    "weekly_progress" JSONB,
    "recommendations" JSONB,
    "insights_data" JSONB,
    "week_start" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "career_insights_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "resume_analyses_user_id_idx" ON "resume_analyses"("user_id");

-- CreateIndex
CREATE INDEX "resume_analyses_resume_id_idx" ON "resume_analyses"("resume_id");

-- CreateIndex
CREATE INDEX "job_analyses_user_id_idx" ON "job_analyses"("user_id");

-- CreateIndex
CREATE INDEX "job_analyses_job_id_idx" ON "job_analyses"("job_id");

-- CreateIndex
CREATE INDEX "interview_sessions_user_id_idx" ON "interview_sessions"("user_id");

-- CreateIndex
CREATE INDEX "interview_sessions_job_id_idx" ON "interview_sessions"("job_id");

-- CreateIndex
CREATE INDEX "interview_questions_session_id_idx" ON "interview_questions"("session_id");

-- CreateIndex
CREATE INDEX "interview_results_session_id_idx" ON "interview_results"("session_id");

-- CreateIndex
CREATE INDEX "career_insights_user_id_idx" ON "career_insights"("user_id");

-- AddForeignKey
ALTER TABLE "resume_analyses" ADD CONSTRAINT "resume_analyses_resume_id_fkey" FOREIGN KEY ("resume_id") REFERENCES "resumes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "resume_analyses" ADD CONSTRAINT "resume_analyses_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "job_analyses" ADD CONSTRAINT "job_analyses_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "job_analyses" ADD CONSTRAINT "job_analyses_job_id_fkey" FOREIGN KEY ("job_id") REFERENCES "job_applications"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "interview_sessions" ADD CONSTRAINT "interview_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "interview_sessions" ADD CONSTRAINT "interview_sessions_job_id_fkey" FOREIGN KEY ("job_id") REFERENCES "job_applications"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "interview_questions" ADD CONSTRAINT "interview_questions_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "interview_sessions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "interview_results" ADD CONSTRAINT "interview_results_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "interview_sessions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "career_insights" ADD CONSTRAINT "career_insights_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
