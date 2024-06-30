# Grocery Shopping List App

🚀 Welcome to the Grocery Shopping List App! 🚀

This project is part of my Flutter learning journey, where I explored building a mobile application with Flutter and integrating it with Firebase for backend functionality. 

## 📱 What I Built

This app helps users manage their grocery shopping lists with a simple and intuitive interface.

## ScreenShots
<img src="https://github.com/subashghimirey/Grocery-Shopping-App-with-Backend/assets/88834868/6a413e75-1492-4569-9c84-2f34927d90ef" alt="Screenshot_1719769537" width="180" height="350" />
<img src="https://github.com/subashghimirey/Grocery-Shopping-App-with-Backend/assets/88834868/ecf078c5-9e43-43e5-a643-d402bfbc5761" alt="Screenshot_1719769542" width="180" height="350" />

## Set Up Firebase

### Frontend
- **Add Grocery Items**: Users can enter grocery items using `TextFormField` and select categories from a dropdown menu with `DropDownButtonFormField`.
- **Display Items**: The app shows a dynamic list of grocery items using `ListView.builder`.
- **Loading States**: Utilizes `CircularProgressIndicator` to manage loading states.
- **Delete Items**: Users can delete items with swipe gestures, and an Undo Snackbar appears for accidental deletions.
- **Error Handling**: Implemented `try-catch` blocks and status codes for robust error management.

### Backend Integration
- **Firebase**: Integrated Firebase for data storage, including `POST` and `GET` operations to manage grocery items.

## ✨ Key Features

- Add and validate grocery items.
- Display a list of grocery items with real-time updates.
- Manage loading states and display error messages.
- Swipe to delete items with an Undo option.

## 🛠️ Technologies Used

- **Flutter**: Framework for building the app’s frontend.
- **Firebase**: Backend service for data storage and management.
- **Dart**: Programming language used for Flutter development.

## 🏗️ Getting Started

To get started with this project, follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/grocery-shopping-list-app.git

2. **Navigate to the Project Directory**:
    ```bash
    cd grocery-shopping-list-app
    
3. **Install Dependencies**:
    ```bash
    flutter pub get

4. **Set Up Firebase**:

Follow the [Firebase setup guide](https://firebase.google.com/docs/flutter/setup) to configure Firebase for your app.

    1. Add your `google-services.json` to the `android/app` directory for Android.
    2. Add your `GoogleService-Info.plist` to the `ios/Runner` directory for iOS.

5. **Run the App**:  
    ```bash
    flutter run

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Contributing
Contributions are welcome! Feel free to open issues or submit pull requests.
