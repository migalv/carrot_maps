# Carrot Maps

This project uses Flutter version 2.2.1 as of date 10/06/2021
Please make sure to use this Flutter version. Or update the dependencies when upgrading Flutter Version.
This app is only supported for Android.

## Steps to build & run App

1- First we will generate the generated files by running:
`$ flutter pub run build_runner build`

2- I used dotenv to securely store API Keys. Please provide the .env file with the API Key for Open Weather API
Add a file named `.env` at the root of the folder and add a line with `OPEN_WEATHER_API_KEY=YOUR_API_KEY_HERE`

3- I also used an Android environment variable to securely store the Google Maps API Key
Add a file named `local_maps.properties` at `android/` and add a line like this `MAPS_API_KEY=YOUR_API_KEY_HERE`

4- Add this to the `android/app/build.gradle` 
```
def mapsProperties = new Properties()
def localMapsPropertiesFile = rootProject.file('local_maps.properties')
if (localMapsPropertiesFile.exists()) {
    project.logger.info('Load maps properties from local file')
    localMapsPropertiesFile.withReader('UTF-8') { reader ->
        mapsProperties.load(reader)
    }
} else {
    project.logger.info('Load maps properties from environment')
    try {
        mapsProperties['MAPS_API_KEY'] = System.getenv('MAPS_API_KEY')
    } catch(NullPointerException e) {
        project.logger.warn('Failed to load MAPS_API_KEY from environment.', e)
    }
}
def mapsApiKey = mapsProperties.getProperty('MAPS_API_KEY')
if(mapsApiKey == null){
    mapsApiKey = ""
    project.logger.error('Google Maps Api Key not configured. Set it in `local_maps.properties` or in the environment variable `MAPS_API_KEY`')
}
```

5- Add the Google Services JSON to connect the app to your Firebase Project.

## Test Driven Development

This project was implemented using the test driven development metodology.

You can check the tests in the /test/ folder
