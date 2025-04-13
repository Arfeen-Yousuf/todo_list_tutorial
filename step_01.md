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

**Step 1: Create Flutter project**

Create a Flutter project **todo_list_tutorial** and open it with an IDE of your choice. I recommend VS Code or Android Studio.

**Step 2: Update main method**

Replace the contents inside main with the following code:

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

**Step 3: Run your app**

The app should look like this:

![Screenshot from 2025-04-12 16-20-28](https://github.com/user-attachments/assets/d58b1998-f2bf-4854-9be5-53596c24cd37)

**Step 4: Create TasksScreen widget**

Create a file **lib/screens/tasks_screen.dart** and place the following contents:

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

**What's Next**

We are done with the first part. In the coming part, we will add interactivity to our app.

👉 [View Step 01 Code Commit]
[https://github.com/Arfeen-Yousuf/todo_list_tutorial/commit/a3396136ed26c8a6ea55bec18a4a3a053608f8bf#diff-e61eb31d013d12616f5532636a88cfa63631dda8f7829e5424e68542214d1608]
[https://github.com/Arfeen-Yousuf/todo_list_tutorial/commit/a3396136ed26c8a6ea55bec18a4a3a053608f8bf#diff-023efa392bf3477b754965f637670adbe6bf36eb1abf2e075ff5015c815a1d78]
