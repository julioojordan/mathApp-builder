# 🧮 mathApp-builder

Build and run the **Math App** with a single command using Docker.

---

## 📦 One-Click App Installer

This repository provides a self-contained "one-click" setup to run the **Math App** application using Docker. It supports both Windows and macOS/Linux environments with minimal effort.

---

## ✅ Prerequisites

- **Git** installed and available on your PATH  
- **Windows**: PowerShell (for `.bat` script)  
- **macOS/Linux**: Bash (for `.sh` script)  
- **Docker** installed and running
- **Postgress** make sure to stop any postgres server running
---

## 🚀 How To use Locally

### 🪟 Windows

1. Copy `setup.bat` to your local directory  
2. Double-click `setup.bat` to launch the setup  
   > ⏳ The process may take a while (due to downloading Redis & PostgreSQL), but you can leave it running in the background  

---

### 🐧 macOS / Linux

1. Copy `setup.sh`  
2. Make it executable and run it:

```bash
chmod +x setup.sh
./setup.sh
```

---

## ⏱ Time Spent and Development Notes

### Time Allocation Breakdown

- 🔍 Requirement breakdown, schema design, and app flow: **15 min**  
- 🗃 Creating and seeding the database: **45 min**  
- 🛠 Backend development: **150 min**  
- 🎨 Frontend development: **90 min**  
- 🔒 Validation, env config, almost-auth/interceptors: **20 min**  
- ⚙️ Dockerized one-click deployment setup and docs: **40 min**

---

## ❌ Things Not Yet Built

### Backend

- No unit tests implemented  
- Only one GitHub branch (this is a personal project)  
- this rules: _"Re-submit with same `attempt_id` on the same day shouldn't increment streak"_ — handled by rejecting submissions if a record exists in user_progress
- Submission data is only stored in Redis on "Check" (not yet persisted to DB)  
- Redis caching is prioritized over frequent DB writes  
- Ideal background task (Kafka/microservice) not yet implemented to sync Redis → DB  
- Secrets (DB/Redis) still exposed in `.env` instead of using Docker/CI secrets  
- Quiz session does not persist — if user refreshes, progress resets unless final submission is done  

### Frontend

- No sidebar (only 2 core pages: Dashboard & QuizPage)  
- No animations for correct/wrong answers — fallback to alerts  
- No Props checking for hardening - not much time
- No unit testing

---

## 🛠 Developer Notes

### Backend

- Redis keys:  
  - `attempt:${user_id}:${lesson_id}`  
  - `answered:${user_id}:${lesson_id}:${problem_id}`  
  > These are invalidated when user enters QuizPage, accesses `/api/lesson/:id`, or submits

- Validation compares `meta_json` (Redis) with user's answers to ensure integrity  
- Duplicate `attempt_id`s raise DB error to prevent double submission  
- Answered problems are locked (re-answer triggers rejection)

### Frontend

- Loading states are intentionally delayed for better UX Components like Dashboard and QuizPage simulate async feedback  

---

## 💡 Post-Quiz Experience Design

After the user clicks **Check**, a motivational alert appears — regardless of correctness.  
This instant feedback is designed to encourage users to keep trying.

---

## 📈 Scaling Plan: 1000+ Users

### Backend

- Redis-first architecture, backed by eventual DB sync (via Kafka with ms-like / worker)  
- Microservices pattern planned (e.g., `ms-dashboard`, `ms-user`, etc.)  
- Redis caches global/static data and revalidates on update  

### Frontend

- Utilizes **lazy loading** and **React.memo** to optimize re-renders  
- Lean page structure ensures scalability with minimal complexity  

---

## 🧪 Product Review

### ✅ Works Well For Teens

- Social sharing of badges and achievements  
- Visibility into how many users solved the same problems (peer motivation)  
- Simple 2-page UX with minimal distractions  

### 🔧 To Improve

- Implement microservice separation for better scaling  
- Randomize MCQ answer order & shuffle problems  
- Show problem difficulty or success rates like HackerRank  
