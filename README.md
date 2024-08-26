# ToDoList

## Overview

ToDoList is a simple iOS app designed as a test project for a job application. The app allows users to manage their tasks efficiently, leveraging a range of modern iOS development practices. Built using Swift and UIKit, ToDoList demonstrates key concepts such as reactive programming, data persistence, and robust architecture.

## Key Features

- **Task Management**: Create, update, and delete tasks with ease.
- **Reactive Programming**: Utilizes Combine for handling asynchronous data streams and updates.
- **Persistent Storage**: Uses Core Data to manage local storage and ensure data is retained across app launches.
- **API Integration**: Fetches initial task data from a remote API using URLSession.
- **Modern Layout**: Employs SnapKit for clean and responsive UI layout.
- **VIPER Architecture**: Implements the VIPER design pattern for a modular and scalable codebase.
- **Multithreading**: Uses Grand Central Dispatch (GCD) for efficient background processing.

## Architecture

The app follows the VIPER architecture, which consists of the following components:

- **View**: Presents the user interface and interacts with the user.
- **Interactor**: Handles the business logic and data operations.
- **Presenter**: Manages the communication between the View and the Interactor.
- **Entity**: Defines the data model used by the Interactor.
- **Router**: Handles navigation and routing within the app.

## Data Flow

1. **Initial Data Fetch**: On the first launch, the app fetches task data from a remote API using URLSession.
2. **Local Storage**: Fetched data is saved to Core Data for offline access and future use.
3. **Subsequent Launches**: The app loads tasks from local Core Data, avoiding further API calls.

## Testing

Unit tests are written using XCTest to ensure the correctness of the app's core components:

- **NetworkServiceTests**: Validates the network communication layer by testing API interactions and data retrieval.
- **CoreDataServiceTests**: Tests CRUD operations on the Core Data stack, including saving, updating, and deleting tasks.
- **Presenter Tests**: Ensures the correctness of both `TasksPresenter` and `TaskPresenter` by validating their interaction with the View and Interactor.

## License

This project is for demonstration purposes and does not include a license.
