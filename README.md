
# Anthem - a different kind of music recommendation app

Anthem is an app (built with Flutter) that recommends music based on more characteristics than the obvious (genre, tempo, artist). It takes into account:
- energy
- valence
- acousticness

The idea behind the application is to offer the user personalized recommendations based on their preferences, as well as the ability to follow top charts, rate songs, and display newly discovered songs of other users on the map.


It was built as a project for *Social Networks* course at the Faculty of Electrical Engineering and Computing, Zagreb.
## Features

- Cross-platform
- Twitter login - used to discover followed artists
- Music recommender
- *Music map* - discover music loved by nearby users


## Built with

Main technologies used in the project:

- [Flutter](https://flutter.dev) - framework for building multi-platform applications
- [twitter_login](https://pub.dev/packages/twitter_login) - logging in with Twitter
- [geolocator](https://pub.dev/packages/geolocator) - location services
- [shared_preferences](https://pub.dev/packages/shared_preferences) - data persistance

Components and UI libraries:
- [flutter_map](https://pub.dev/packages/flutter_map) - map display component (implementation of Leaflet)
- [flutter_rating_bar](https://pub.dev/packages/flutter_rating_bar) - customizable rating bar component
- [flutter_feather_icons](https://pub.dev/packages/feather_icons) - open-source icon library


Back-end:
- [Google Firebase](https://firebase.google.com)

## Screenshots

![Screenshots 1](https://res.cloudinary.com/filippavic/image/upload/v1645721829/Project%20screenshots/Anthem/anthem_mockup_3_pt39iw.png)

![Screenshots 2](https://res.cloudinary.com/filippavic/image/upload/v1645721829/Project%20screenshots/Anthem/anthem_mockup_2_ia35i4.png)

