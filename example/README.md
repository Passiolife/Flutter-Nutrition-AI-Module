# example

Demo app for the Flutter Nutrition AI Module.

## First run

* The first time the app is built, the build will not complete because the app is missing an API key.
* To use the SDK sign up at https://www.passio.ai/nutrition-ai. The SDK WILL NOT WORK without a valid SDK key.

## Changing the data storage

* The demo app comes equipped with ```passio_connector.dart``` class. This abstract class defines where the data is stored and retrieved from. The default implementation ```LocalDBConnector``` uses a local database to store user data.
* To change where the data is being store create an implementation of the ```PassioConnector``` class.