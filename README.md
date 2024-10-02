![App Icon](https://firebasestorage.googleapis.com/v0/b/profile-3b7ca.appspot.com/o/launchIcon.svg?alt=media&token=1da68642-53f1-428c-95d9-7612eb35c989)
# GitHub User Browser 

An iOS application that allows users to browse GitHub profiles and their repositories using the GitHub REST API. This app focuses on providing a user-friendly experience by showing user information and non-forked repositories.

## Features

- **User List Screen**: Displays a list of GitHub users with their avatars and usernames.
- **User Search**: Allows users to quickly find GitHub users by their usernames.
- **User Repository Screen**:
  - Shows user details, including avatar, username, full name, and follower stats.
  - Lists non-forked repositories with the repository name, primary programming language, star count, and a short description.
  - Each repository can be tapped to view more details in a WebView.
- **Localization Support**: The app supports both English and Japanese.

## Technologies Used

This project uses the following technologies:

- **UIKit**: Used to build the user interface of the application.
- **CoreData**: Used for local data management, allowing storage and retrieval of user profiles and repository data.
- **UICollectionView**: Used to display lists of GitHub user profiles and repositories.
- **Swift Package Manager**: Used for managing dependencies in the project.
- **URLCache**: Implemented for caching network responses to reduce loading times and minimize repeated network requests.
- **NSCache**: Utilized to cache user profile pictures in memory, improving the performance of image loading and reducing flickering when scrolling through lists.
- **GraphQL API**: Moved from the GitHub User list REST API to GraphQL to access extra data fields not available in REST. However, GraphQL returns results in random order with each app launch, which can cause the user list to rearrange when loading the next page.

### Additional Details

- **MVVM Architecture**: The app uses the Model-View-ViewModel (MVVM) architecture to separate concerns, making it easier to maintain.
- **Coordinator Pattern**: Navigation is handled with the coordinator pattern, making it simpler to manage routing.

## Security and Configuration

To keep sensitive information, like API keys and user data, secure:

- **Secure Configuration**: The GitHub Personal Access Token is stored using `Config.xcconfig`, which is not included in version control to prevent exposure.

## Installation

### Clone the Repository

To get started with this project, clone the repository to your local machine:

```bash
git clone https://github.com/rkramvs/github-users.git
cd github-users
```
## Secure Your Token

To keep your GitHub Personal Access Token secure and avoid accidental exposure, follow these steps:

### Configuration Files

- If you want to use a configuration file like `Config.xcconfig`, do the following:
  - Create a `Config.xcconfig` file in your project's `Config` directory.
  - Add the token entry in the file:
    ```
    GITHUB_PERSONAL_ACCESS_TOKEN = your_personal_access_token_here
    ```
  - Make sure to add `Config.xcconfig` to your `.gitignore` file to prevent it from being committed:
    ```
    # Ignore configuration files that contain sensitive information
    Github Users/Config/Config.xcconfig
    ```

### Auto-Translation for Localization

- **Added an automated translation feature** using a Python script during the build phase to support English and Japanese.
- **Used the `Translator` open-source Python package** to fetch and translate strings in localization files.
- **Integrated the Python script into the Xcode build process** to ensure all user interface elements are translated with the latest updates.

<img src="https://firebasestorage.googleapis.com/v0/b/profile-3b7ca.appspot.com/o/Wednesday%2C%2002%20Oct%202024%2020%3A30%3A17.png?alt=media&token=365492ee-e9e0-4489-904c-3cd0aa437fa4" alt="iPhone User List" width="300" height="600">
