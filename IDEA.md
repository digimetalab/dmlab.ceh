# IDEA - Agentic AI Pentest

## Masalah

Pentest yang lengkap itu berulang dan berat: recon -> triage -> assessment per-attack-surface -> exploit -> reporting. Manual berarti context-switch antar puluhan teknik, tool, dan skill. AI agent tunggal tanpa struktur mudah lupa fase, melewatkan permukaan serangan, dan menghasilkan laporan yang tidak bisa dipertanggungjawabkan.

## Ide

**Multi-agent orchestrator di atas skill.** Setiap skill di `.agents/skills/` adalah "otak specialist" yang sudah berisi metodologi mendalam untuk satu permukaan serangan. Skema ini memetakan: 1 agent = 1+ skill + 1 workflow nyata (Prism CLI, SpiderFoot). Sebuah **Commander agent** menyusun rencana, meng-dispatch specialist yang tepat di fase yang tepat, lalu mengagregasi temuan menjadi laporan profesional.

Bukan membangun tool baru - tapi **mengorkestrasi yang sudah ada**: 58 skill methodology + 22 modul OSINT Prism + SpiderFoot.

## Kenapa ini powerful

| Keuntungan | Penjelasan |
|---|---|
| **Cakupan lengkap** | Setiap attack surface punya specialist: web, auth, AD, wireless, cloud, mobile, IoT, AI, exploit, fuzzing |
| **Methodology yang dalam** | Agent tidak bergantung pada memori model - ia memuat SKILL.md spesialis saat dibutuhkan |
| **Reusable** | Workflow nyata (Prism/SpiderFoot) dipanggil apa adanya; skill tidak diubah |
| **Eskalasi berbasis bukti** | Temuan fase recon menentukan agent mana yang di-dispatch berikutnya |
| **Auditable** | Evidence hygiene + timestamp per temuan -> laporan bisa dipertanggungjawabkan (CEH: penulisan laporan yang benar) |

## Visi

1. **v1 (sekarang)** - skema + mapping skill->agent->workflow terdokumentasi di `AGENTS.md`; Commander menjalankan alurnya secara manual/terpandu di opencode.
2. **v2** - folder `results/` sebagai blackboard terstruktur (engagement.json, findings per fase) agar orchestrator punya state antar sesi.
3. **v3** - otomatisasi: Commander membaca `results/findings/*.json`, memutuskan eskalasi secara programatik, dan memicu reporting-agent otomatis.
4. **v4** - API wrapper: orchestrator memanggil Prism/SpiderFoot via Python (bukan shell) agar bisa masuk CI/CD.

## Konteks Pembelajaran CEH

Proyek ini juga alat belajar CEH: memaksa alur kerja yang benar (recon -> scanning -> Gaining Access -> Maintaining -> Covering Tracks -> Reporting) dan penggunaan metodologi standar industri (OWASP, CVSS) lewat skill `offensive-reporting`.

## Batasan & Etika

- Hanya untuk target dengan izin resmi (lab, CTF, bug bounty). No authz -> no execution.
- Tidak mem-publish data target; semua output lokal di `results/`.
- Dokumentasi ini dan seluruh skill ditujukan untuk **pengujian keamanan yang sah**.
