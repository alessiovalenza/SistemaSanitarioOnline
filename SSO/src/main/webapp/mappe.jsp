<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri = "http://java.sun.com/jsp/jstl/functions"%>

<c:set var="language" value="${sessionScope.language}" scope="page" />
<c:set var="sectionToShow" value="${sessionScope.selectedSection}" scope="page" />
<c:set var="baseUrl" value="<%=request.getContextPath()%>"/>
<c:set var="url" value="${baseUrl}/pages/mappe.jsp?language=" scope="page" />

<fmt:setLocale value="${language}" />
<fmt:setBundle basename="labels" />
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes">
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8">
    <title><fmt:message key="Mappa"/></title>
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
    let baseUrl = "<%=request.getContextPath()%>";
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

            var iconUrl = 'assets/img/croce_farmacia.jpg';

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

        var lan;
        switch ('${sessionScope.language}'){
            case 'it_IT': lan = 'it-IT'; break;
            case 'fr_FR': lan = 'fr-FR'; break;
            case 'en_EN': lan = 'en-EN'; break;
            default: lan = 'it-IT';
        }

        var ui = H.ui.UI.createDefault(this.map, defaultLayers, lan);

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
        lat: 44.73914,
        lng: 10.61476
    };

    var mapOptions = {
        center: coordinates,
        zoom: 14
    };

    var map = new HEREMap(mapContainer, platform, mapOptions);
</script>
</body>