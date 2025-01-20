### **EWI: University System Mobile Application**

#### **Description**
EWI is a mobile application designed to streamline university administrative and academic processes. It offers students, faculty, and staff an intuitive platform for managing schedules, courses, and university-related information efficiently.

---

#### **Features**
- User authentication and role-based access control (e.g., student, faculty, admin).
- Academic calendar integration and event notifications.
- Course registration and schedule management.
- Access to grades, attendance, and academic records.
- Real-time notifications for updates and announcements.
- Secure document uploads and downloads.

---

#### **Technologies Used**
- **Frontend:** Flutter for cross-platform mobile development.
- **Backend:** Firestore Firebase for database and real-time synchronization.
- **UI/UX Design:** Figma for creating a modern and user-friendly interface.
- **Cloud Services:** Firebase Authentication and Firebase Storage.

---

#### **Project Structure**
The project is organized into the following key directories:
- **`lib/`**: Contains the core application logic, widgets, and screens.
- **`assets/`**: Stores static assets such as images and icons.
- **`android/`**: Android-specific build configurations.
- **`ios/`**: iOS-specific build configurations.
- **`auth_repository/`**: Manages authentication logic and integration.
  
For a detailed overview, see the full project structure in `project_structure.txt`.

---

#### **Installation**
To run the project locally, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/AbdullahAlassi/EWI.git
   cd EWI
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Set up Firebase:
   - Add the `google-services.json` file (for Android) to the `android/app/` directory.
   - Add the `GoogleService-Info.plist` file (for iOS) to the `ios/Runner/` directory.
4. Run the application:
   ```bash
   flutter run
   ```

---

#### **Screenshots**

---

#### **Contributing**
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add new feature"
   ```
4. Push to your branch:
   ```bash
   git push origin feature-name
   ```
5. Open a pull request.

---

#### **License**
This project is licensed under the MIT License. See `LICENSE` for details.

---
