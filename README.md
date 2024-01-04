# RestoRaterApp

## Overview

RestoRaterApp is a comprehensive restaurant review application designed for iOS. It provides an intuitive platform for users to rate and review restaurants. It is built using Swift and UIKit. 

## Technologies Used
- **UIKit**: A framework to build the user interface for iOS apps.
- **CoreData**: Used for local data storage and management.
- **TextFieldEffects**: A pod used to create beautiful text fields.

## Features

- **Offline User Account Management**: Users can create an account and log in, with all user data managed locally using Core Data.
- **Role-Based Access Control**: Supports two user roles, Regular User and Admin, each with distinct permissions and access levels.
- **Restaurant Listings**: Users can browse a list of restaurants, sorted by their average ratings.
- **Detailed Restaurant Views**: Offers detailed information about each restaurant, including overall ratings, highest and lowest rated reviews, and the latest review.
- **Review System**: Users can leave restaurant reviews with a 5-star rating system, date of visit, and comments.
- **Admin control**: Administrators can add, edit, and delete restaurants, users, and reviews.

## Prepopulated Data and Sample Accounts

To enhance the user experience and demonstrate the app's capabilities, RestoRaterApp comes with prepopulated sample data including a list of restaurants and user accounts. This allows you to test and explore the app's features without the need to create data from scratch.

### Sample Restaurants

The app is preloaded with a variety of restaurants to showcase the listing, review, and rating functionalities.

### Sample User Accounts

For testing purposes, two user accounts with different roles are provided:

1. **Regular User Account**
   - Email: `test@gmail.com`
   - Password: `test`
   - Role: Regular user with the ability to rate and review restaurants.

2. **Admin User Account**
   - Email: `admin@gmail.com`
   - Password: `admin`
   - Role: Admin with the ability to add, edit, and delete restaurant information, manage users, and reviews.

Feel free to use these credentials to log in and explore the different functionalities available to each user type.


### Screenshots
<p float="left">
  <img src="https://github.com/Hus782/RestoRaterUIKit/blob/main/screenshots/1.jpg" width="250" />
  <img src="https://github.com/Hus782/RestoRaterUIKit/blob/main/screenshots/2.jpg" width="250" />
   <img src="https://github.com/Hus782/RestoRaterUIKit/blob/main/screenshots/3.jpg" width="250" />
</p>
<p float="left">
  <img src="https://github.com/Hus782/RestoRaterUIKit/blob/main/screenshots/4.jpg" width="250" />
  <img src="https://github.com/Hus782/RestoRaterUIKit/blob/main/screenshots/5.jpg" width="250" />
  <img src="https://github.com/Hus782/RestoRaterUIKit/blob/main/screenshots/6.jpg" width="250" />
</p>

### Demo GIFs
<p float="left">
  <img src="https://github.com/Hus782/RestoRaterUIKit/blob/main/screenshots/add_restaurant.gif" width="250" />
  <img src="https://github.com/Hus782/RestoRaterUIKit/blob/main/screenshots/add_review.gif" width="250" />
</p>

<p float="left">
  <img src="https://github.com/Hus782/RestoRaterUIKit/blob/main/screenshots/edit_user.gif" width="250" />
  <img src="https://github.com/Hus782/RestoRaterUIKit/blob/main/screenshots/login.gif" width="250" />
</p>

## Installation
To get started with the RestoRaterApp, follow these simple steps:
1. Clone the repository to your local machine.
2. Open the project in Xcode.
3. pod install
4. Run the app on your preferred iOS simulator or physical device.


