# E-Book Digital Library Platform

A professional, full-stack digital library application featuring a modern Flutter frontend and a robust Node.js/MongoDB backend. This platform provides a seamless reading experience for users and comprehensive management tools for administrators.

## 🚀 Key Features

### User Experience
- **Premium PDF Reader**: Integrated with `Syncfusion` for a smooth, high-quality reading experience.
- **Personalized Library**: Track reading history and manage favorite books.
- **Real-time Stats**: Dynamic dashboard showing "Books Read" and "Favorite Genres".
- **Account Security**: Secure login/signup system with a robust "Forgot Password" flow including database-level username verification.

### Administrator Features
- **Centralized Dashboard**: Real-time platform metrics (Total Users, Total Books, Total Reads).
- **Book Management**: Full CRUD operations for digital content, including cover art and PDF uploads.
- **User Management**: Monitor and manage registered users.
- **Dynamic Content**: Automated "Weekly Top Pick" based on rating analytics.

---

## 🛠 Technology Stack

### Frontend (Flutter)
- **Framework**: [Flutter](https://flutter.dev/) (SDK ^3.9.2)
- **State Management**: [GetX](https://pub.dev/packages/get)
- **Networking**: [Dio](https://pub.dev/packages/dio) (with interceptors for JWT security)
- **PDF Engine**: [Syncfusion Flutter PDF Viewer](https://pub.dev/packages/syncfusion_flutter_pdfviewer)
- **Local Storage**: [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)

### Backend (Node.js)
- **Runtime**: [Node.js](https://nodejs.org/) (Express Framework)
- **Database**: [MongoDB](https://www.mongodb.com/) (Mongoose ODM)
- **Security**: [Bcrypt](https://www.npmjs.com/package/bcrypt) for hashing, [JWT](https://jwt.io/) for authentication.
- **File Handling**: [Multer](https://www.npmjs.com/package/multer) for managing book covers and PDF uploads.

---

## 📂 Project Structure

### Frontend (`/E-B`)
```
lib/
├── api/             # API service and endpoint configurations
├── screens/         # Feature-based UI screens
│   ├── Admin/       # Dashboard, Book Management, User Management
│   ├── User/        # Home, Library, Reader, Profile
│   └── auth/        # Login, Signup, Forgot Password
├── widgets/         # Reusable UI components
└── utils/           # App colors, themes, and helpers
```

### Backend (`/Baxkend`)
```
src/
├── controller/      # Business logic and request handling
├── model/           # MongoDB schemas (User, Book)
├── router/          # API route definitions
├── middleware/      # Auth and Role-based access control
└── config/          # Database connection settings
```

---

## ⚙️ Installation & Setup

### 1. Backend Setup
1. Navigate to the `Baxkend` directory.
2. Install dependencies:
   ```bash
   npm install
   ```
3. Configure your `.env` file with `MONGODB_URI` and `JWT_SECRET`.
4. Start the server:
   ```bash
   npm run dev
   ```

### 2. Frontend Setup
1. Navigate to the `E-B` directory.
2. Fetch Flutter packages:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

---

## 📄 License
This project is for educational and portfolio purposes.
