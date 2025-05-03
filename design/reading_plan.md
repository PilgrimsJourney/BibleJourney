# Reading Plan System

The Reading Plan system in **Bible Journey** is the core mechanism for guiding users through structured Bible reading. It allows users to select, customize, and track their reading plans, with data persisted locally using [Hive](https://pub.dev/packages/hive). This document explains the components of the reading plan system and how they are stored, organized into the `models/reading_plan` and `adapters/hive_adapters` packages.

## Class Diagram

The following diagram illustrates the classes and their relationships, including how Hive adapters handle persistence.

![Reading Plan Class Diagram](diagrams/hive_reading_plan_class.png)

See [plantuml/hive_reading_plan_class.puml](plantuml/hive_reading_plan_class.puml) for the PlantUML source.

## Reading Plan Components

The reading plan system is implemented in the `lib/models/reading_plan/` directory, with the following classes:

### ReadingPlan

- **Purpose**: Represents a predefined Bible reading plan, such as "Chronological Bible" or "New Testament in a Year".
- **Attributes**:
  - `name: String`: The name of the plan (e.g., "Chronological Bible").
  - `streams: List<Stream>`: A list of streams (sequences of readings) that make up the plan.
- **Role**: Acts as a template from which users can select streams to create their personalized `UserReadingPlan`. It is immutable, ensuring the original plan remains unchanged.

### Stream

- **Purpose**: Represents a sequence of readings within a plan, such as "Gospels" or "Psalms".
- **Attributes**:
  - `name: String`: The name of the stream (e.g., "Gospels").
  - `readings: List<Reading>`: A list of individual readings in the stream.
- **Role**: Organizes readings into logical groups, allowing users to follow specific parts of a plan independently.

### Reading

- **Purpose**: Represents a single reading task, such as a Bible chapter or verse.
- **Attributes**:
  - `reference: String`: The Bible reference (e.g., "John 3:16").
  - `isCompleted: bool`: Indicates whether the reading is completed (defaults to `false`).
- **Role**: The smallest unit of the reading plan, trackable by users to monitor progress.

### UserReadingPlan

- **Purpose**: Represents a user’s customized reading plan, derived from one or more `ReadingPlan` objects.
- **Attributes**:
  - `name: String`: The name of the user’s plan, typically copied from the source `ReadingPlan`.
  - `streams: List<Stream>`: A mutable list of streams selected or added by the user.
- **Methods**:
  - `fromReadingPlan(plan: ReadingPlan, streamIndices: List<int>)`: Creates a `UserReadingPlan` by copying selected streams from a `ReadingPlan`.
  - `addStreamFromPlan(plan: ReadingPlan, streamIndex: int)`: Adds a new stream from a `ReadingPlan` to the user’s plan.
  - `removeStreamByName(name: String)`: Removes a stream by its name.
- **Role**: Allows users to personalize their reading by selecting, adding, or removing streams, supporting features like independent stream navigation and plan cancellation.

### User

- **Purpose**: Represents the app’s user, storing their preferences and reading plan.
- **Attributes**:
  - `language: String`: The user’s preferred language for the UI.
  - `readingPlan: UserReadingPlan?`: The user’s current reading plan (optional, as a user may not have selected one).
- **Role**: Links the reading plan system to user-specific data, enabling features like language customization and plan persistence.

## Persistence with Hive

The reading plan system uses [Hive](https://pub.dev/packages/hive) for local storage, ensuring data (e.g., user progress, selected streams) persists across app sessions. Hive adapters, located in `lib/adapters/hive_adapters/`, serialize and deserialize each class for storage in a Hive `Box`. Each adapter extends `TypeAdapter<T>` and defines how to read/write objects to binary data.

### How Hive Adapters Work

- **Serialization**: Converts an object (e.g., `Reading`) into binary data for storage.
- **Deserialization**: Reconstructs an object from binary data when loaded.
- **Type ID**: Each adapter has a unique `typeId` to identify the class in the Hive database.

### Adapters

1. **`ReadingAdapter` (typeId: 0)**:
   - **Serializes/Deserializes**: `Reading` objects.
   - **Process**:
     - **Write**: Stores `reference` (String) and `isCompleted` (bool).
     - **Read**: Reconstructs a `Reading` with the stored values.
   - **Role**: Persists individual reading tasks, including completion status.

2. **`StreamAdapter` (typeId: 1)**:
   - **Serializes/Deserializes**: `Stream` objects.
   - **Process**:
     - **Write**: Stores `name` (String) and `readings` (List<Reading>, handled by `ReadingAdapter`).
     - **Read**: Reconstructs a `Stream` with its name and readings.
   - **Role**: Persists sequences of readings, relying on `ReadingAdapter` for the `readings` list.

3. **`ReadingPlanAdapter` (typeId: 2)**:
   - **Serializes/Deserializes**: `ReadingPlan` objects.
   - **Process**:
     - **Write**: Stores `name` (String) and `streams` (List<Stream>, handled by `StreamAdapter`).
     - **Read**: Reconstructs a `ReadingPlan` with its name and streams.
   - **Role**: Persists predefined plans, used as templates for `UserReadingPlan`.

4. **`UserReadingPlanAdapter` (typeId: 3)**:
   - **Serializes/Deserializes**: `UserReadingPlan` objects.
   - **Process**:
     - **Write**: Stores `name` (String) and `streams` (List<Stream>, handled by `StreamAdapter`).
     - **Read**: Reconstructs a `UserReadingPlan` with its name and mutable streams.
   - **Role**: Persists the user’s customized plan, including added or removed streams.

5. **`UserAdapter` (typeId: 4)**:
   - **Serializes/Deserializes**: `User` objects.
   - **Process**:
     - **Write**: Stores `language` (String) and `readingPlan` (UserReadingPlan?, handled by `UserReadingPlanAdapter`).
     - **Read**: Reconstructs a `User` with its language and optional reading plan.
   - **Role**: Persists user preferences and their current reading plan.

### Persistence Flow

1. **Initialization**: In `main.dart`, Hive is initialized, and adapters are registered with their `typeId` values (0–4). A `Box` (e.g., `userBox`) is opened to store `User` objects.
2. **Saving Data**: When a user modifies their plan (e.g., marks a `Reading` as completed or adds a `Stream`), the `User` object is updated, and `UserAdapter` serializes it, cascading to `UserReadingPlanAdapter`, `StreamAdapter`, and `ReadingAdapter` for nested objects.
3. **Loading Data**: On app startup, `UserAdapter` deserializes the `User` from the `Box`, reconstructing the `UserReadingPlan`, `Stream`, and `Reading` objects via their adapters.
4. **Dependencies**: The adapters rely on each other (e.g., `StreamAdapter` uses `ReadingAdapter` for `readings`), as shown in the class diagram’s “uses” relationships.

## Package Organization

- **`lib/models/reading_plan/`**:
  - Contains `ReadingPlan`, `Stream`, `Reading`, `UserReadingPlan`, and `User` classes.
  - Defines the data model and logic for reading plans, following the MVC pattern (models).
  - Example files: `reading_plan.dart`, `user.dart`.

- **`lib/adapters/hive_adapters/`**:
  - Contains `ReadingAdapter`, `StreamAdapter`, `ReadingPlanAdapter`, `UserReadingPlanAdapter`, and `UserAdapter`.
  - Handles persistence logic, keeping serialization separate from the model.
  - Example file: `hive_adapters.dart`.

This separation ensures the code remains modular and maintainable, with clear responsibilities:
- **Models**: Handle data structure and business logic (e.g., adding/removing streams).
- **Adapters**: Manage persistence, isolating Hive-specific code.

## Usage in Bible Journey

The reading plan system supports key user stories (see [Use Case Documentation](/design/use_case.md)):
- **Select Reading Plan**: Users choose a `ReadingPlan` and create a `UserReadingPlan` with selected `Stream` objects.
- **Track Progress**: Users mark `Reading` objects as completed, persisted via `ReadingAdapter`.
- **Customize Streams**: Users add or remove `Stream` objects in `UserReadingPlan`, persisted via `UserReadingPlanAdapter`.
- **Language Preference**: The `User`’s `language` is stored and loaded via `UserAdapter`.

The Hive adapters ensure that all changes (e.g., completing a reading, changing streams) are saved locally, providing a seamless experience across app sessions.

## Notes for Contributors

- **Extending the System**: To add new attributes (e.g., a `Stream` description), update the corresponding class and adapter, ensuring the `read` and `write` methods handle the new field.
- **Testing Persistence**: Use unit tests in `test/models/` (e.g., `reading_plan_test.dart`) to verify serialization/deserialization.
- **Performance**: Hive is lightweight, but large `ReadingPlan` objects with many `Stream` and `Reading` instances may require optimization (e.g., lazy loading).

This design supports **Bible Journey**’s mission to provide a free, open-source tool for Christians, with a robust and flexible reading plan system that is easy to maintain and extend.
