![Flutter CI](https://github.com/paurakhsharma/onesheep_test/workflows/Flutter%20CI/badge.svg)

# Biblia API Flutter

Flutter app build for mobile and web.

## Getting Started

To run the project first of all you have to get the API key from [biblia](http://bibliaapi.com/).
And follow the following steps.

1) Clone the repo and go to the root directory of the repo.
2) Export environment variables `API_KEY` and `BASE_URL`.
```bash
export API_KEY=[API_KEY_FROM_Biblia] BASE_URL=https://api.biblia.com/v1/bible
```

3) Run `dart tool/env.dart`
This will create a file `lib/.env.dart` with following contents:
```dart
final environment = {
  "apiKey":"[API_KEY_FROM_Biblia]",
  "baseUrl":"https://api.biblia.com/v1/bible"
 };
```

4) That is all you need to do, now you can run the app using `flutter run`

*Note: To build the flutter app for the web you need to be on a `dev` channel*
