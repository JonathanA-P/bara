-- ==============================================================================
-- BARA / ANDROZON SEED DATA
-- Bank Soal Validasi Kompetensi & Demo Data FILKOM UB
-- ==============================================================================

-- Bank Soal Kuis Diagnostik (Struktur Data & Algoritma, Basis Data, Pemrograman Berorientasi Objek)
INSERT INTO public.competency_quizzes (subject, question, options, correct_index, explanation)
VALUES 
(
    'Struktur Data & Algoritma',
    'Struktur data antrean mana yang paling tepat digunakan untuk algoritma traversal Breadth-First Search (BFS)?',
    '["Stack (Tumpukan)", "Queue (Antrean FIFO)", "Priority Queue", "Binary Search Tree"]'::jsonb,
    1,
    'BFS mengeksplorasi graf lapis demi lapis secara selevel, sehingga membutuhkan struktur antrean FIFO (First-In, First-Out).'
),
(
    'Struktur Data & Algoritma',
    'Berapa kompleksitas waktu rata-rata (average time complexity) dari algoritma QuickSort?',
    '["O(1)", "O(n)", "O(n log n)", "O(n^2)"]'::jsonb,
    2,
    'Rata-rata QuickSort membagi array menjadi dua sub-bagian seimbang di setiap partisi, menghasilkan O(n log n).'
),
(
    'Basis Data',
    'Normalisasi bentuk ketiga (3NF) mensyaratkan relasi tidak memiliki ketergantungan apa?',
    '["Ketergantungan Parsial", "Ketergantungan Transitif", "Ketergantungan Fungsional Penuh", "Ketergantungan Multi-nilai"]'::jsonb,
    1,
    '3NF mensyaratkan relasi sudah 2NF dan tidak memiliki dependensi transitif antar-atribut non-prime.'
),
(
    'Pemrograman Berorientasi Objek',
    'Prinsip OOP mana yang menyembunyikan detail implementasi internal dan hanya mengekspos antarmuka publik yang esensial?',
    '["Polymorphism", "Inheritance", "Encapsulation", "Abstraction"]'::jsonb,
    2,
    'Encapsulation membungkus data/state dan metode di dalam unit kelas serta membatasi akses langsung dari luar.'
)
ON CONFLICT DO NOTHING;

