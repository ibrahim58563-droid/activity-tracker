-- =============================================================
-- The Archivist — Supabase Database Schema
-- Run this in your Supabase SQL Editor (Dashboard → SQL Editor)
-- =============================================================

-- 1. Students table
CREATE TABLE IF NOT EXISTS students (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name       TEXT NOT NULL,
  level_of_study TEXT DEFAULT '',
  academic_year  TEXT DEFAULT '',
  notes      TEXT DEFAULT '',
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Index for fast lookups by owner
CREATE INDEX IF NOT EXISTS idx_students_user_id ON students(user_id);

-- 2. Daily records table
CREATE TABLE IF NOT EXISTS daily_records (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  date       DATE NOT NULL,
  ibadaat    JSONB DEFAULT '{}'::jsonb,
  quran      JSONB DEFAULT '{}'::jsonb,
  habits     JSONB DEFAULT '{}'::jsonb,
  study      JSONB DEFAULT '{}'::jsonb,

  -- One record per student per day
  UNIQUE(student_id, date)
);

-- Index for fast lookups by student + date
CREATE INDEX IF NOT EXISTS idx_daily_records_student_date
  ON daily_records(student_id, date DESC);

-- =============================================================
-- Row Level Security (RLS) — each user only sees their own data
-- =============================================================

ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_records ENABLE ROW LEVEL SECURITY;

-- Students: users can only CRUD their own students
CREATE POLICY "Users can view own students"
  ON students FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own students"
  ON students FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own students"
  ON students FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own students"
  ON students FOR DELETE
  USING (auth.uid() = user_id);

-- Daily records: access through student ownership
CREATE POLICY "Users can view own daily records"
  ON daily_records FOR SELECT
  USING (
    student_id IN (SELECT id FROM students WHERE user_id = auth.uid())
  );

CREATE POLICY "Users can insert own daily records"
  ON daily_records FOR INSERT
  WITH CHECK (
    student_id IN (SELECT id FROM students WHERE user_id = auth.uid())
  );

CREATE POLICY "Users can update own daily records"
  ON daily_records FOR UPDATE
  USING (
    student_id IN (SELECT id FROM students WHERE user_id = auth.uid())
  )
  WITH CHECK (
    student_id IN (SELECT id FROM students WHERE user_id = auth.uid())
  );

CREATE POLICY "Users can delete own daily records"
  ON daily_records FOR DELETE
  USING (
    student_id IN (SELECT id FROM students WHERE user_id = auth.uid())
  );
