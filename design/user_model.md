# User Model

A User is an object to represent the current user of the application in
runtime. It contains the preferences, config, and current state of those things
that belong to the user.

## Class Diagram
![User Class Diagram](diagrams/user_class.png)

The `User` model (`lib/models/user.dart`) is a `ChangeNotifier` that notifies
the `UserStorageAdapter` (`lib/adapters/user_storage_adapter.dart`) of changes,
which saves to Hive.

See [plantuml/user_class.puml](plantuml/user_class.puml) for the source.
