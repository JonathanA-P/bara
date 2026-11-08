# BARA Application Known Limitations & Considerations

Dokumen ini merangkum batasan teknis (limitations), dependensi pihak ketiga, dan pertimbangan operasional pada sistem BARA saat ini:

## 1. Supabase API Key Migration (Post-2026/2027)
- **Kondisi**: Dashboard Supabase menandai bahwa Legacy API Keys (JWT format lama) akan dipensiunkan pada awal 2027.
- **Status saat ini**: Aplikasi menggunakan `publishableKey` (`sb_publishable_...`) yang kompatibel dengan standar baru Supabase SDK `v2.16.0+`.
- **Rekomendasi**: Pastikan project settings di Supabase tetap mengaktifkan format kunci publishable publik untuk koneksi mobile client.

## 2. Row Level Security (RLS) pada Akun Baru
- **Kondisi**: Saat pengguna baru mendaftar (`signUp`), pembuatan data di tabel publik `profiles` diproteksi oleh RLS policy Supabase.
- **Mitigasi**: Pastikan trigger PostgreSQL `on_auth_user_created` aktif di database Supabase untuk secara otomatis menyalin record dari `auth.users` ke `public.profiles`.

## 3. PostgREST Relationship Embedding
- **Kondisi**: Tabel `discussions` memiliki lebih dari satu relasi dengan tabel `profiles` (sebagai pembuat postingan dan relasi bookmark/likes), yang dapat memicu error `PGRST201` jika di-query tanpa spesifikasi relasi eksplisit.
- **Mitigasi**: Seluruh query query join di `DiscussionService` telah di-pin menggunakan relasi eksplisit `profiles!discussions_author_id_fkey(...)`.

## 4. Push Notifications (FCM / APNs)
- **Kondisi**: Modul notifikasi saat ini mengambil dan menampilkan riwayat notifikasi dari tabel database `notifications` secara in-app.
- **Rekomendasi ke Depan**: Untuk notifikasi background saat aplikasi ditutup, diperlukan penambahan konfigurasi Firebase Cloud Messaging (FCM) dan sertifikat APNs di level native Android & iOS.

## 5. Offline Fallback Behavior
- **Kondisi**: Jika koneksi jaringan pengguna terputus saat berada di halaman tertentu (seperti Kuis atau Matching Mentor), aplikasi secara cerdas beralih ke cache / fallback data lokal (`AppDataController`) guna mencegah force close/crash. Perubahan offline tidak otomatis di-sinkronkan kembali sebelum ada koneksi stabil.
