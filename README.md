# MatchMate App

This is an iOS app that allows users to create and list events, and the app should store and display their decisions persistently, even in
offline mode.

## Installation

1. **Clone the Repository**:

```bash
[git clone https://github.com/manish-chaurasiya-23/MatchMate](https://github.com/manish-chaurasiya-23/EventHub)
```
## Features
- **Event Creation**: Allows users to create events.
- - **Event Listing**: Displays a list of all created events, showing the title, date/time, and a thumbnail of the media.
- **Core Data Integration**: Stores events locally for offline access.
- **Image Handling**: Allows users to select images or videos and resize them to a 4:5 aspect ratio for consistency..
- **Seamless Synchronization**: Merges data fetched from the API with existing data stored in Core Data, maintaining consistency.
- **Input Validation**: Ensures required fields are filled before event creation.


## Libraries and Frameworks Used

- **Combine**: Used for reactive programming, to observe network connectivity and handle asynchronous events.
- **Core Data**: Used to persist user data locally.
- - **UIImagePickerController**: Used for selecting images or videos and resizing them.
Foundation**: Standard library for networking and other fundamental operations.
- **SwiftUI**: Used for building the app’s UI.
- **PersistenceController**: Custom class for managing the Core Data stack.

### Prerequisites

1. **Xcode**: Make sure you have the latest version of Xcode installed.
2. **Swift Version**: This project is compatible with Swift 5.0 and later.

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.
