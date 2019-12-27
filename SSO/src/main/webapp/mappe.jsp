<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes">
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8">
    <title>Map at user's position</title>
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

            onSuccess = function(data) {
                if (data.results && data.results.items) {
                    var places = data.results.items.map(function(place){
                        place.coordinates = {
                            lat: place.position[0],
                            lng: place.position[1]
                        };
                        return place;
                    });

                    var ricette = [];
                    ricette =  $.ajax({
                        type: "GET",
                        url: "http://localhost:8080/SSO_war_exploded/api/pazienti/"+ ${sessionScope.utente.id} +"/ricette?evaseonly=false&nonevaseonly=true"
                    });
                    console.log(ricette);

                    if(data.results.items[0].distance < 900){
                        alert('Vai a comprare le medicine');
                    }

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

                var iconUrl = './images/1.jpg';

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
            //apikey: '9ZZLQaMKUi1q7AIY9burFElLlUtLunmqcYc6w4JbQN8'
            app_id: 'eXyeKXjLMDyo92pFfzNf', // // <-- ENTER YOUR APP ID HERE
            app_code: 'QuU-fH5ZjNfHHzf2IZHEkg' // <-- ENTER YOUR APP CODE HERE
        });

        var coordinates = {
            lat: 52.530974,
            lng: 13.384944
        };

        var mapOptions = {
            center: coordinates,
            zoom: 14
        };

        var map = new HEREMap(mapContainer, platform, mapOptions);
    </script>
</body>