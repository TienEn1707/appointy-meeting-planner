# 📅 Appointy Meeting Planner

**Appointy Meeting Planner** is a mobile application designed to simplify the meeting scheduling process. It features an intuitive UI that allows users to create, edit, and delete meeting information efficiently. Users can also manage company details to ensure organized and structured planning.

---

## 🚀 Technologies Used

- **Framework**: Flutter  
- **Programming Language**: Dart  
- **Local Database**: SQLite (using the `sqflite` package)

---

## 📁 Important Folder Structure

Below is the folder structure and important files used in this project:

```
├── android/
│   └── app/
│       └── src/
│           └── main/
│               ├── res/                  # App icons and resources
│               └── AndroidManifest.xml   # App permissions and configuration
├── assets/                               # Folder for icons, images, etc.
├── lib/                                  # All Dart & Flutter code
├── pubspec.yaml                          # File for managing dependencies and assets
```

---

## ✅ Steps to Run the Application

Follow these steps to run the Appointy Meeting Planner on your device:

1. **Check Your Flutter & Dart Version**
   - Ensure Flutter SDK is installed and matches the required version.
   - Alternatively, create a new project with:
     ```
     flutter create your_project_name
     ```
     Then, copy all files and folders from this project into the new one.

2. **Install Dependencies**
   - Open terminal and run:
     ```
     flutter pub get
     ```

3. **Connect Your Test Device**
   - Recommended: Use a physical device via USB for better performance.
   - Enable developer mode and USB debugging on your device.

4. **Run the Application**
   - Run the following command to launch the app:
     ```
     flutter run
     ```
     
---

## 📷 App Screenshots

Here are some initial screens from the Appointy Meeting Planner:

<p>
  <img src="GetStarted.png" alt="Get Started" width="240"/>
  <img src="Home.png" alt="Home Page" width="240"/>
</p>

---

## 📌 Additional Notes

- If the `assets` folder does not exist, create it manually to ensure assets load properly.
- Optional: Make sure to add all required permissions in `AndroidManifest.xml` (e.g., camera, notifications, etc.).
- To build the `.apk` release version of the app, run:
