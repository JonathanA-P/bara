<div align="center">

  <img src="assets/images/hiGavi.png" alt="Hi!Gavi logo" width="180" />

  # Hi!Gavi

  Temukan Teman Belajar, Diskusikan Materi Kuliah, dan Persiapkan Semestermu: ekosistem sosial akademik & kolaborasi *peer-to-peer* mahasiswa FILKOM Universitas Brawijaya.

  <br />

  ![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
  ![Platform](https://img.shields.io/badge/Platform-iOS-000000?style=for-the-badge&logo=apple&logoColor=white)
  ![Framework](https://img.shields.io/badge/Framework-Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Backend](https://img.shields.io/badge/Backend-Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)

</div>

---

## Table of contents

- [Project overview](#project-overview)
- [Key features](#key-features)
- [Technology stack](#technology-stack)
- [Project structure](#project-structure)
- [Getting Started](#getting-started)

## Project overview

| Item | Details |
| --- | --- |
| Application Type | Mobile Application |
| Primary Platform | Cross-platform (Android & iOS) |
| Target Audience | Mahasiswa Fakultas Ilmu Komputer (FILKOM) Universitas Brawijaya |

**Hi!Gavi** adalah aplikasi mobile komunitas akademik dan kolaborasi belajar *peer-to-peer* yang dirancang untuk mahasiswa Fakultas Ilmu Komputer (FILKOM) Universitas Brawijaya. Aplikasi ini membantu mahasiswa berdiskusi seputar perkuliahan maupun kehidupan kampus, mengeksplorasi detail serta tingkat kesulitan mata kuliah berdasarkan ulasan nyata, berbagi materi/catatan, hingga terhubung langsung dengan sesama mahasiswa maupun mentor melalui *Direct Message* (DM) secara *real-time*.

## Key features

| Feature | What the user can do |
| --- | --- |
| Campus Discussion Feed (Kuliah & Luar Kelas) | Membuat postingan diskusi, melampirkan gambar atau dokumen materi (`.pdf`), memberikan *like*, menyimpan postingan (*bookmark*), serta berdiskusi lewat komentar bertingkat (*nested replies*). |
| Course Explorer & Difficulty Rating | Menjelajahi katalog mata kuliah per Program Studi dan Semester lengkap dengan silabus RPS mingguan, prasyarat, histori persentase dosen pengajar, serta memberi ulasan & skor tingkat kesulitan mata kuliah. |
| Explore & Smart Discovery | Mencari pengguna, mata kuliah, dan topik populer secara *real-time* untuk menemukan obrolan serta rekan belajar yang relevan. |
| Direct Message (DM) & Camera | Mengobrol langsung 1-on-1 bersama mahasiswa lain, mengirim foto langsung dari *in-app camera* maupun lampiran dokumen kuliah, serta memantau notifikasi interaksi terbaru. |
| Social Profile & Follow System | Mengelola profil akademik (Nama, Username, Program Studi, NIM, Bio, Foto), melihat daftar *Postingan* dan *Disimpan (Bookmark)*, serta mengikuti (*Follow / Following / Followers*) akun mahasiswa lain. |
| Campus Authentication & KTM Scan | Mendaftar akun menggunakan email kampus (`@student.ub.ac.id`), memindai Kartu Tanda Mahasiswa (KTM), verifikasi OTP email, serta fitur lupa kata sandi. |
| Incident & Content Reporting | Melaporkan postingan, komentar, atau pengguna yang melanggar pedoman komunitas langsung ke sistem moderasi untuk menjaga keamanan ekosistem kampus. |

## Technology stack

| Category | Technology | Purpose |
| --- | --- | --- |
| Frontend | Flutter (Dart) | Framework utama pengembangan antarmuka aplikasi mobile multiplatform dengan animasi interaktif |
| State Management | ChangeNotifier & ListenableBuilder | Sinkronisasi *state* reaktif lintas layar untuk profil, *follow*, diskusi, *bookmark*, rating, dan DM |
| Backend as a Service | Supabase | Layanan backend terkelola untuk autentikasi, database relasional, dan *realtime messaging* |
| Database | PostgreSQL (Supabase) | Penyimpanan data profil mahasiswa, relasi *follow*, diskusi, komentar, *bookmark*, sesi chat, dan laporan |
| Authentication | Supabase Auth | Manajemen *session*, registrasi email kampus, verifikasi OTP, dan pemulihan kata sandi |
| UI & Assets | Google Fonts & Flutter SVG | Tipografi *Manrope* & *Plus Jakarta Sans*, ikon vektor kustom, dan animasi maskot Gavi |
| Environment Config | flutter_dotenv | Pengelolaan kredensial API dan *environment variable* (`.env`) secara aman |

## Project structure

```text
lib/
├── core/
│   ├── constants/          # Konstanta teks dan aset aplikasi
│   ├── services/           # Integrasi Supabase (Auth, Discussion, Chat, Report, AppDataController)
│   ├── theme/              # Konfigurasi warna, tipografi, dan tema aplikasi
│   └── utils/              # Utilitas ukuran responsif dan animasi
├── features/
│   ├── auth/
│   │   └── screens/
│   │       ├── course/     # Katalog Mata Kuliah, Detail RPS, dan Rating Kesulitan
│   │       ├── discussion/ # Buat Diskusi Baru dan Detail Postingan + Nested Replies
│   │       ├── forgot_password/
│   │       ├── home/       # Main Screen (Floating Navbar) dan Home Discussion Feed
│   │       ├── login/      # Halaman Login & SSO Kampus
│   │       ├── onboarding/ # Onboarding Pengenalan Fitur Hi!Gavi
│   │       ├── profile/    # Profil Pengguna, Stranger View, Followers/Following, Edit Profil
│   │       ├── register/   # Multi-step Registrasi (Scan KTM, Form Akademik, Verifikasi OTP)
│   │       └── splash_screen/ # Custom Animated Splash Screen Maskot Hi!Gavi
│   ├── chat/
│   │   └── screens/        # Notifikasi, Direct Message (DM), dan In-App Camera
│   ├── explore/
│   │   └── screens/        # Pencarian Global (User, Mata Kuliah, Postingan) & Topik Populer
│   └── report/
│       └── screens/        # Pelaporan Insiden & Moderasi Komunitas
└── main.dart               # Entry point aplikasi dan inisialisasi Supabase & dotenv
assets/                     # Gambar ilustrasi, ikon SVG, dan logo maskot Hi!Gavi
supabase/                   # Skema tabel PostgreSQL dan kebijakan RLS (schema.sql)
pubspec.yaml                # Konfigurasi dependensi dan aset Flutter
```

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   Flutter SDK installed on your machine.
*   An editor like VS Code or Android Studio.

### Installation

1.  **Clone the repo**
    ```sh
    git clone https://github.com/JonathanA-P/bara.git
    ```
2.  **Navigate to the project directory**
    ```sh
    cd higavi-repo
    ```
3.  **Install dependencies**
    ```sh
    flutter pub get
    ```
4.  **Configure environment variables**
    Buat file `.env` di *root directory* project (atau salin dari `.env.example`) dan isi dengan kredensial Supabase:
    ```env
    SUPABASE_URL=https://your-project-id.supabase.co
    SUPABASE_ANON_KEY=your-supabase-anon-key
    ```
5.  **Run the app**
    ```sh
    flutter run
    ```

