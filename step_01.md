### What is Flutter

Flutter is Google's UI toolkit for building applications for mobile, web, and desktop from a single codebase. In this tutorial, you will build a fascinating todo list app

The application enables user to track their todos such as “Buy grocery”, “Maths homework”, “Learn Flutter basics” and mark each task as completed or uncompleted independently. The app is responsive to different screen sizes.

### What you'll learn

    • The basics of how Flutter works
    • Creating layouts in Flutter
    • Connecting user interactions (like button presses) to app behavior
    • Keeping your Flutter code organized
    • Making your app responsive (for different screens)
    • Achieving a consistent look & feel of your app
    • Using sqflite package to persist todos on local storage
    • User authentitaction and remote storage for todos using Firebase

You'll start with a basic scaffold so that you can jump straight to the interesting parts.

### Steps:

1. Create a Flutter project **todo_list** and open it with an IDE of your choice. I recommend VS Code or Android Studio.
2. Replace the contents inside main with the following code:

```bash
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Tasks')),
        body: Center(child: Text('Tasks will go here')),
      ),
    );
  }
}
```

3. Run your app. The app should look like this:

![Screenshot from 2025-04-12 16-20-28](https://github.com/user-attachments/assets/d58b1998-f2bf-4854-9be5-53596c24cd37)

4. Create a file **lib/screens/tasks_screen.dart** and place the following contents:

```bash
import 'package:flutter/material.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: const SafeArea(child: Center(child: Text('Tasks will go here'))),
    );
  }
}
```

and then change the home in the main method from

```bash
home: Scaffold(
  appBar: AppBar(title: Text('Tasks')),
  body: Center(child: Text('Tasks will go there')),
),
```

to

```bash
home: TasksScreen(),
```

and import the **tasks_screen.dart** file. Now run the app to see the results.

👉 [View Step 01 Code Commit](commit_link_here_later)
