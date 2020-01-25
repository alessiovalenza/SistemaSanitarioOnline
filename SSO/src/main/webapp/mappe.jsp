<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes">
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8">
    <title>Map at user's position funzionante</title>
    <link href = "https://code.jquery.com/ui/1.10.4/themes/ui-lightness/jquery-ui.css" rel = "stylesheet">
    <link rel="stylesheet" type="text/css" href="https://js.api.here.com/v3/3.0/mapsjs-ui.css" />
    <script type="text/javascript" charset="UTF-8" src="https://js.api.here.com/v3/3.0/mapsjs-core.js"></script>
    <script type="text/javascript" charset="UTF-8" src="https://js.api.here.com/v3/3.0/mapsjs-service.js"></script>
    <script type="text/javascript" charset="UTF-8" src="https://js.api.here.com/v3/3.0/mapsjs-ui.js"></script>
    <script type="text/javascript" charset="UTF-8" src="https://js.api.here.com/v3/3.0/mapsjs-places.js"></script>
    <script type="text/javascript" charset="UTF-8" src="https://js.api.here.com/v3/3.0/mapsjs-mapevents.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
</head>
<body>
<div id="mapContainer"></div>
<script>

    function HEREPlaces (map, platform) {
        this.map = map;
        this.placeSearch = new H.places.Search (platform.getPlacesService());
        this.searchResults = [];
    }

    HEREPlaces.prototype.searchPlaces = function(query) {
        this.getPlaces(query, function(places) {
            this.updatePlaces(places);
        }.bind(this));
    };

    HEREPlaces.prototype.getPlaces = function(query, onSuccessCallback) {
        var onSuccess, onError;
        function notifyMe() {
            // Let's check if the browser supports notifications
            if (!("Notification" in window)) {
                alert("This browser does not support desktop notification");
            }

            // Let's check whether notification permissions have already been granted
            else if (Notification.permission === "granted") {
                // If it's okay let's create a notification
                var notification = new Notification("Hai delle ricette non evase; se vuoi qui vicino trovi una farmacia ;)");
            }

            // Otherwise, we need to ask the user for permission
            else if (Notification.permission !== "denied") {
                Notification.requestPermission().then(function (permission) {
                    // If the user accepts, let's create a notification
                    if (permission === "granted") {
                        var notification = new Notification("Hai delle ricette non evase; se vuoi qui vicino trovi una farmacia ;)");
                    }
                });
            }
        }

        onSuccess = function(data) {
            if (data.results && data.results.items) {

                var places = data.results.items.map(function(place){
                    place.coordinates = {
                        lat: place.position[0],
                        lng: place.position[1]
                    };
                    return place;
                });

                var distance = data.results.items[0].distance;

                function sendEmail(){
                    $.get("mappeEmail.jsp")
                }

                $.ajax({
                    type: "GET",
                    url: "http://localhost:8080/SSO_war_exploded/api/pazienti/"+ ${sessionScope.utente.id} +"/ricette?evaseonly=false&nonevaseonly=true",
                        success: function (data) {
                        if (data[0] && distance <= 2000) {
                            notifyMe();
                            $(sendEmail());
                        }
                    }
                });

                onSuccessCallback(data.results.items);

            } else {
                onError(data);
            }
        };

        onError = function(error) {
            console.error('Error happened when fetching places!', error);
        };

        this.placeSearch.request(query, {}, onSuccess, onError);
    };

    HEREPlaces.prototype.clearSearch = function() {
        this.searchResults.forEach(function(marker){
            this.map.removeObject(marker);
        }.bind(this));
        this.searchResults = [];
    };

    HEREPlaces.prototype.updatePlaces = function(places) {
        this.clearSearch();
        this.searchResults = places.map(function(place){

            var iconUrl = 'assets/img/1.jpg';

            var iconOptions = {
                // The icon's size in pixel:
                size: new H.math.Size(46, 58),
                // The anchorage point in pixel,
                // defaults to bottom-center
                anchor: new H.math.Point(14, 34)
            };

            var markerOptions = {
                icon: new H.map.Icon(iconUrl, iconOptions)
            };

            var marker = new H.map.Marker(place.coordinates, markerOptions);
            this.map.addObject(marker,'red');
            return marker;
        }.bind(this));
    };

</script>
<script>
    function HEREMap (mapContainer, platform, mapOptions) {
        this.platform = platform;
        this.position = mapOptions.center;

        var defaultLayers = platform.createDefaultLayers();

        // Instantiate wrapped HERE map
        this.map = new H.Map(mapContainer, defaultLayers.normal.map, mapOptions);
        // Basic behavior: Zooming and panning
        var behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(this.map));
        // Watch the user's geolocation and display it
        navigator.geolocation.watchPosition(this.updateMyPosition.bind(this));
        // Resize the map when the window is resized
        window.addEventListener('resize', this.resizeToFit.bind(this));

        this.places = new HEREPlaces(this.map, this.platform);


    }

    HEREMap.prototype.updateMyPosition = function(event) {

        if (event.coords.latitude < (this.position.lat-0.0001) ||
            event.coords.latitude > (this.position.lat+0.0001) ||
            event.coords.longitude < (this.position.lng-0.0001) ||
            event.coords.longitude > (this.position.lng+0.0001)) {

            this.position = {
                lat: event.coords.latitude,
                lng: event.coords.longitude
            };

            if (this.myLocationMarker) {
                this.removeMarker(this.myLocationMarker);
            }

            this.myLocationMarker = this.addMarker(this.position);
            this.map.setCenter(this.position);
            this.searchForPharmacies();
        }
    };

    HEREMap.prototype.addMarker = function(coordinates) {
        var marker = new H.map.Marker(coordinates);
        this.map.addObject(marker);

        return marker;
    };

    HEREMap.prototype.removeMarker = function(marker) {
        this.map.removeObject(marker);
    };

    HEREMap.prototype.resizeToFit = function() {
        this.map.getViewPort().resize();
    };

    HEREMap.prototype.searchForPharmacies = function(){

        var query = {
            'q': 'pharmacies',
            'at': this.position.lat + ',' + this.position.lng
        };

        this.places.searchPlaces(query);
    };
</script>
<script>
    var mapContainer = document.getElementById('mapContainer');

    var platform = new H.service.Platform({
        app_id: 'eXyeKXjLMDyo92pFfzNf', // // <-- ENTER YOUR APP ID HERE
        app_code: 'QuU-fH5ZjNfHHzf2IZHEkg' // <-- ENTER YOUR APP CODE HERE
    });

    var coordinates = {
        lat: 45.365349,
        lng: 10.923873
    };

    var mapOptions = {
        center: coordinates,
        zoom: 15
    };

    var map = new HEREMap(mapContainer, platform, mapOptions);
</script>
</body>