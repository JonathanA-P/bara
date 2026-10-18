-- ==============================================================================
-- BARA / ANDROZON DATABASE SCHEMA (SUPABASE POSTGRESQL)
-- Ekosistem Pembelajaran Peer-to-Peer & Mentoring FILKOM UB
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 0. SCHEMA PERMISSIONS
-- ------------------------------------------------------------------------------
GRANT ALL ON SCHEMA public TO postgres;
GRANT USAGE, CREATE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT USAGE, CREATE ON SCHEMA public TO PUBLIC;

-- ------------------------------------------------------------------------------
-- 1. PROFILES (Pengguna / Mahasiswa)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    nim TEXT UNIQUE,
    major TEXT NOT NULL DEFAULT 'Teknik Informatika',
    role TEXT NOT NULL DEFAULT 'mentee' CHECK (role IN ('mentee', 'mentor', 'both')),
    avatar_url TEXT DEFAULT 'assets/images/CloudArt_margin.png',
    bio TEXT DEFAULT 'Mahasiswa FILKOM Universitas Brawijaya',
    points INT NOT NULL DEFAULT 100,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE INDEX IF NOT EXISTS idx_profiles_role ON public.profiles(role);
CREATE INDEX IF NOT EXISTS idx_profiles_major ON public.profiles(major);

-- ------------------------------------------------------------------------------
-- 2. MENTOR PROFILES (Spesialisasi & Rating)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.mentor_profiles (
    user_id UUID PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
    skills TEXT[] NOT NULL DEFAULT '{}',
    hourly_rate INT NOT NULL DEFAULT 0,
    rating NUMERIC(3, 2) NOT NULL DEFAULT 5.00,
    review_count INT NOT NULL DEFAULT 0,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    teaching_badge TEXT NOT NULL DEFAULT 'Rising Tutor',
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- ------------------------------------------------------------------------------
-- 3. MATCHMAKING & SWIPES (Tinder-style swipe)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.mentor_swipes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mentee_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    mentor_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    action TEXT NOT NULL CHECK (action IN ('like', 'pass')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT uq_mentee_mentor_swipe UNIQUE (mentee_id, mentor_id)
);

CREATE TABLE IF NOT EXISTS public.mentorship_matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mentee_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    mentor_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'pending_quiz' CHECK (status IN ('pending_quiz', 'accepted', 'ongoing', 'completed', 'cancelled')),
    matched_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE INDEX IF NOT EXISTS idx_matches_mentee ON public.mentorship_matches(mentee_id);
CREATE INDEX IF NOT EXISTS idx_matches_mentor ON public.mentorship_matches(mentor_id);

-- ------------------------------------------------------------------------------
-- 4. COMPETENCY QUIZZES (Validasi Kompetensi Pra-Bimbingan)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.competency_quizzes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subject TEXT NOT NULL,
    question TEXT NOT NULL,
    options JSONB NOT NULL,
    correct_index INT NOT NULL,
    explanation TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.quiz_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    match_id UUID REFERENCES public.mentorship_matches(id) ON DELETE CASCADE,
    mentee_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    score INT NOT NULL,
    diagnostic_summary TEXT,
    completed_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- ------------------------------------------------------------------------------
-- 5. MENTORING SESSIONS & LIVE CHAT REALTIME
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.mentoring_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    match_id UUID REFERENCES public.mentorship_matches(id) ON DELETE SET NULL,
    mentor_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    mentee_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    topic TEXT NOT NULL DEFAULT 'Bimbingan Akademik',
    started_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    duration_minutes INT NOT NULL DEFAULT 60,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'finished', 'cancelled')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES public.mentoring_sessions(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    message_text TEXT NOT NULL,
    attachment_name TEXT,
    attachment_url TEXT,
    is_flagged_ai BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE INDEX IF NOT EXISTS idx_chat_session ON public.chat_messages(session_id, created_at ASC);

-- ------------------------------------------------------------------------------
-- 6. DISCUSSIONS & COMMENTS (Forum Komunitas)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.discussions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    tag TEXT NOT NULL DEFAULT 'Umum',
    live_duration_minutes INT NOT NULL DEFAULT 0,
    likes_count INT NOT NULL DEFAULT 0,
    replies_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.discussion_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    discussion_id UUID NOT NULL REFERENCES public.discussions(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    comment_text TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.bookmarks (
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    discussion_id UUID NOT NULL REFERENCES public.discussions(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    PRIMARY KEY (user_id, discussion_id)
);

-- ------------------------------------------------------------------------------
-- 7. INCIDENT REPORTS (Duty of Care & Keamanan)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.incident_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    accused_name TEXT NOT NULL,
    category TEXT NOT NULL,
    incident_date DATE NOT NULL,
    description TEXT NOT NULL,
    evidence_urls TEXT[] DEFAULT '{}',
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'investigating', 'resolved', 'dismissed')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- ------------------------------------------------------------------------------
-- 8. NOTIFICATIONS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'system',
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE INDEX IF NOT EXISTS idx_notifications_user ON public.notifications(user_id, is_read);

-- ------------------------------------------------------------------------------
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ------------------------------------------------------------------------------
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mentor_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mentor_swipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mentorship_matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.competency_quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mentoring_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.discussions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.discussion_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookmarks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.incident_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Profiles
DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON public.profiles;
CREATE POLICY "Public profiles are viewable by everyone" ON public.profiles FOR SELECT USING (true);

DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Mentor profiles
DROP POLICY IF EXISTS "Mentor profiles are viewable by everyone" ON public.mentor_profiles;
CREATE POLICY "Mentor profiles are viewable by everyone" ON public.mentor_profiles FOR SELECT USING (true);

DROP POLICY IF EXISTS "Mentors can update own mentor profile" ON public.mentor_profiles;
CREATE POLICY "Mentors can update own mentor profile" ON public.mentor_profiles FOR UPDATE USING (auth.uid() = user_id);

-- Discussions
DROP POLICY IF EXISTS "Discussions viewable by everyone" ON public.discussions;
CREATE POLICY "Discussions viewable by everyone" ON public.discussions FOR SELECT USING (true);

DROP POLICY IF EXISTS "Authenticated users can create discussions" ON public.discussions;
CREATE POLICY "Authenticated users can create discussions" ON public.discussions FOR INSERT WITH CHECK (auth.uid() = author_id);

DROP POLICY IF EXISTS "Author can update own discussion" ON public.discussions;
CREATE POLICY "Author can update own discussion" ON public.discussions FOR UPDATE USING (auth.uid() = author_id);

-- Comments
DROP POLICY IF EXISTS "Comments viewable by everyone" ON public.discussion_comments;
CREATE POLICY "Comments viewable by everyone" ON public.discussion_comments FOR SELECT USING (true);

DROP POLICY IF EXISTS "Authenticated users can comment" ON public.discussion_comments;
CREATE POLICY "Authenticated users can comment" ON public.discussion_comments FOR INSERT WITH CHECK (auth.uid() = author_id);

-- Bookmarks
DROP POLICY IF EXISTS "Users can manage own bookmarks" ON public.bookmarks;
CREATE POLICY "Users can manage own bookmarks" ON public.bookmarks FOR ALL USING (auth.uid() = user_id);

-- Swipes & Matches
DROP POLICY IF EXISTS "Users can view and insert own swipes" ON public.mentor_swipes;
CREATE POLICY "Users can view and insert own swipes" ON public.mentor_swipes FOR ALL USING (auth.uid() = mentee_id);

DROP POLICY IF EXISTS "Participants can view matches" ON public.mentorship_matches;
CREATE POLICY "Participants can view matches" ON public.mentorship_matches FOR SELECT USING (auth.uid() = mentee_id OR auth.uid() = mentor_id);

-- Quizzes
DROP POLICY IF EXISTS "Quizzes viewable by everyone" ON public.competency_quizzes;
CREATE POLICY "Quizzes viewable by everyone" ON public.competency_quizzes FOR SELECT USING (true);

DROP POLICY IF EXISTS "Mentees can view and insert own quiz attempts" ON public.quiz_attempts;
CREATE POLICY "Mentees can view and insert own quiz attempts" ON public.quiz_attempts FOR ALL USING (auth.uid() = mentee_id);

-- Mentoring Sessions & Chat
DROP POLICY IF EXISTS "Participants can view sessions" ON public.mentoring_sessions;
CREATE POLICY "Participants can view sessions" ON public.mentoring_sessions FOR SELECT USING (auth.uid() = mentor_id OR auth.uid() = mentee_id);

DROP POLICY IF EXISTS "Participants can view chat messages" ON public.chat_messages;
CREATE POLICY "Participants can view chat messages" ON public.chat_messages FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.mentoring_sessions s 
        WHERE s.id = chat_messages.session_id 
        AND (s.mentor_id = auth.uid() OR s.mentee_id = auth.uid())
    )
);

DROP POLICY IF EXISTS "Participants can insert chat messages" ON public.chat_messages;
CREATE POLICY "Participants can insert chat messages" ON public.chat_messages FOR INSERT WITH CHECK (
    auth.uid() = sender_id AND
    EXISTS (
        SELECT 1 FROM public.mentoring_sessions s 
        WHERE s.id = chat_messages.session_id 
        AND (s.mentor_id = auth.uid() OR s.mentee_id = auth.uid())
    )
);

-- Incident Reports
DROP POLICY IF EXISTS "Reporters can create incident reports" ON public.incident_reports;
CREATE POLICY "Reporters can create incident reports" ON public.incident_reports FOR INSERT WITH CHECK (auth.uid() = reporter_id);

DROP POLICY IF EXISTS "Reporters can view their own reports" ON public.incident_reports;
CREATE POLICY "Reporters can view their own reports" ON public.incident_reports FOR SELECT USING (auth.uid() = reporter_id);

-- Notifications
DROP POLICY IF EXISTS "Users can view and manage their notifications" ON public.notifications;
CREATE POLICY "Users can view and manage their notifications" ON public.notifications FOR ALL USING (auth.uid() = user_id);

-- ------------------------------------------------------------------------------
-- STORAGE BUCKETS (Safely handled)
-- ------------------------------------------------------------------------------
DO $$
BEGIN
    INSERT INTO storage.buckets (id, name, public) 
    VALUES 
        ('avatars', 'avatars', true),
        ('chat_attachments', 'chat_attachments', false),
        ('report_evidence', 'report_evidence', false)
    ON CONFLICT (id) DO NOTHING;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Storage buckets creation skipped or handled via dashboard';
END $$;

-- ------------------------------------------------------------------------------
-- TRIGGERS & FUNCTIONS
-- ------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name, nim, major, role)
    VALUES (
        new.id,
        new.email,
        COALESCE(new.raw_user_meta_data->>'full_name', 'Mahasiswa FILKOM'),
        COALESCE(new.raw_user_meta_data->>'nim', '235150200111000'),
        COALESCE(new.raw_user_meta_data->>'major', 'Teknik Informatika'),
        COALESCE(new.raw_user_meta_data->>'role', 'mentee')
    );
    RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
