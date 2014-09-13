# Dynamic Social Buttons (with Google Analytics Tracking)
#
# ------------------------------------------------------------------------
#
# Copyright (c) 2014 Dan Cotora
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>
#
# ------------------------------------------------------------------------
#
# You can use this code to initialize social buttons (Facebook, Google+, Twitter) and dynamically &
# track social actions in Google Analytics.
#
# This library works with both versions of Google Analytics (old analytics code & the new universal analytics code).
#
# Make sure you customize the facebookAppId, facebookChannelURL and twitterButtonText variables below.
#

$ = jQuery

# Configure the Facebook APP id (required to initialize the Facebook API & monitor events in Google Analytics)
facebookAppId = '<your-facebook-app-id>'

# Configure the Facebook channel HTML  (see http://stackoverflow.com/questions/7052734/why-do-we-need-to-create-a-channel-html-on-our-server-to-use-facebook-js-sdk)
facebookChannelURL = window.location.protocol + '//' + window.location.hostname + '/fb-channel.html'

# Configure the twitter button's text
twitterButtonText = window.title


# Loads a JavaScript file from the specified URL
loadJS = (url) ->
    js = document.createElement('script')

    js.type  = 'text/javascript'
    js.async = true
    js.src   = url

    s = document.getElementsByTagName('script')[0]
    s.parentNode.insertBefore js, s

    return


# Adds the Facebook social button(s)
addFacebookLike = (url, appId, channelUrl) ->

    # Append the fb-root div to the body
    $('body').prepend '<div id="fb-root"></div>'

    # Add the facebook like button in the social div
    $('.dynamic-social-buttons').append '<div class="fb-like" data-href="' + url + '" data-send="false" data-layout="button_count" data-width="90" data-show-faces="false" data-font="arial"></div>'

    # Initialize Facebook API when the Facebook JS gets loaded
    window.fbAsyncInit = () ->

        # Define the API options
        options =
          appId      : appId
          channelUrl : channelUrl
          status     : true
          cookie     : true
          xfbml      : true

        # Initialize the Facebook API
        FB.init options

        # Listen for LIKE events and register them in Google Analytics
        FB.Event.subscribe 'edge.create', (targetUrl) ->
            _gaq.push ['_trackSocial', 'facebook', 'like', targetUrl] if _gaq?
            ga('send', 'social', 'facebook', 'like', targetUrl) if ga?

        # Listen for UNLIKE events and register them in Google Analytics
        FB.Event.subscribe 'edge.remove', (targetUrl) ->
            _gaq.push ['_trackSocial', 'facebook', 'unlike', targetUrl] if _gaq?
            ga('send', 'social', 'facebook', 'unlike', targetUrl) if ga?

        # Listen for SHARE events and register them in Google Analytics
        FB.Event.subscribe 'message.send', (targetUrl) ->
            _gaq.push ['_trackSocial', 'facebook', 'send', targetUrl] if _gaq?
            ga('send', 'social', 'facebook', 'send', targetUrl) if ga?

        return

    # Load the facebook JavaScript code
    loadJS '//connect.facebook.net/en_US/all.js'

    return


# Adds the Google+ social button
addGooglePlusOne = (url) ->

    # Append the +1 button
    $('.dynamic-social-buttons').append '<div class="g-plusone" data-size="medium" data-href="' + url + '"></div>'

    # Load the +1 JS
    loadJS 'https://apis.google.com/js/plusone.js'

    return


# Adds the Twitter social button
addTweetButton = (text, url) ->

    # Append the tweet button
    $('.dynamic-social-buttons').append '<a href="https://twitter.com/share" style="display: none;" class="twitter-share-button" data-text="' + text + '" data-via="sitedity" data-url="' + url + '">Tweet</a>'

    # Create the window.twttr object
    window.twttr =
        _e: []
        ready: (f) ->
            window.twttr._e.push f
            return

    # Bind to the events when the Twitter JS is loaded
    twttr.ready (twttr) ->

        extractParamFromUri = (uri, paramName) ->
            return unless uri
            regex = new RegExp '[\\?&#]' + paramName + '=([^&#]*)'
            params = regex.exec uri
            return if params != null then unescape(params[1]) else null

        twttr.events.bind 'tweet', (intent_event) ->
            if intent_event and intent_event.target and intent_event.target.nodeName is 'IFRAME'
                targetUrl = extractParamFromUri intent_event.target.src, 'url'

                _gaq.push ['_trackSocial', 'twitter', 'tweet', targetUrl] if _gaq?
                ga('send', 'social', 'twitter', 'tweet', targetUrl) if ga?

            return

    # Load the Twiter JS
    loadJS '//platform.twitter.com/widgets.js'

    return


$(window).on 'load', () ->
    # Add the Facebook like button
    addFacebookLike window.location.protocol + '//' + window.location.hostname + window.location.pathname, facebookAppId, facebookChannelURL

    # Add the Google +1 button
    addGooglePlusOne window.location.protocol + '//' + window.location.hostname + window.location.pathname

    # Add the Twitter button
    addTweetButton twitterButtonText, window.location.href

    return