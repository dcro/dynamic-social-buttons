Dynamic social buttons (with Google Analytics social tracking)
==============================================================

You can use this code to initialize social buttons (Facebook, Google+, Twitter) dynamically & track social actions in Google Analytics. This library works with both versions of Google Analytics (old analytics code & the new universal analytics code).

The code is written in [Coffeescript](http://coffeescript.org/), but you can easily transform it to JavaScript using the online compiler from the Coffeescript website.

You'll need to include [social-buttons.coffee](social-buttons.coffee) in your code & customize a few options before it's ready to be used:

- get a Facebook App ID & customize the `facebookAppId` value. The Facebook App ID is required to be able to monitor `like`, `unlike` and `share` social actions trough the Facebook API and records these actions in Google Analytics.

- add a Facebook channel HTML file. To learn more about this file, see [this StackOverflow question](http://stackoverflow.com/questions/7052734/why-do-we-need-to-create-a-channel-html-on-our-server-to-use-facebook-js-sdk).

- customize the twitter tweet text (that appears when users click the `Tweet` button). By default, the app will use the current page's title (`window.title`), but you might want to change this in certain cases.

This Coffeescript code uses the [jQuery library](http://jquery.com/) so you'll need to include a recent version of this lib in your page to be able to use the social buttons code.

Also, in your HTML files, you'll need to include an empty `div` element with the class name `dynamic-social-buttons` where you want the social buttons to be inserted (e.g. `<div class="dynamic-social-buttons"></div>`).

