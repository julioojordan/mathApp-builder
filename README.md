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
- **Postgress** make sure to stop any postgres server running or check availability for port 5432
- **Redis** make sure to stop any redis server running or check availability for port 6379
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
- rejecting submissions if a record exists in user_progresssubmission behavior will make re-attempt with same attempt_id got error rejected because record already exist, but in case anything happend I already did the hardening with the correct error code and message as the requirement given [see here](https://github.com/julioojordan/mathApp-service/blob/a21f655f6073e000d1be19bd5cb4b164554b11b3/src/repositories/submissionRepository.js#L27)
- user progress data is only stored in Redis on "Check" (not yet persisted to DB) and will be stored to DB after user submit  
- Redis caching is prioritized over frequent DB writes  
- Ideal background task (Kafka/microservice) not yet implemented to sync Redis → DB  
- Secrets (DB/Redis) still exposed in `.env` instead of using Docker/CI secrets  
- Quiz session does not persist — if user refreshes, progress resets (will invalidated redis cache ) unless final submission is done  
- api documentation: [Link to Postman Collection](https://www.postman.com/security-geoscientist-58981571/workspace/test-math-app/collection/32935117-adc7b708-554f-48ab-8c65-baf39f823deb?action=share&source=copy-link&creator=32935117) 

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
  > These are invalidated everytime user enters QuizPage, accesses `/api/lesson/:id`, or submits

- Validation compares `meta_json` (Redis) with user's answers to ensure integrity  
- Duplicate `attempt_id`s raise DB error to prevent double submission  
- Answered problems are locked in redis cache (re-answer triggers rejection)

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
