# Carrot Maps

This app is only supported for Android.
## Steps to build & run App

1- First we will generate the generated files by running:
`$ flutter pub run build_runner build`

2- I used dotenv to securely store API Keys. Please provide the .env file with the API Key for Open Weather API
Add a file named `.env` at the root of the folder and add a line with `OPEN_WEATHER_API_KEY=YOUR_API_KEY_HERE`

3- I also used an Android environment variable to securely store the Google Maps API Key
Add a file named `local_maps.properties` at `android/` and add a line like this `MAPS_API_KEY=YOUR_API_KEY_HERE`

4- Add the Google Services JSON to connect the app to your Firebase Project.

## Test Driven Development

This project was implemented using the test driven development metodology.

You can check the tests in the /test/ folder