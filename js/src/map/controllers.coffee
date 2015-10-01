module = angular.module("map.controllers", [])

module.run(['$anchorScroll', ($anchorScroll) ->
  $anchorScroll.yOffset = 50
])

module.controller("ImaginationProjectsMapCtrl", ($scope, $compile, $anchorScroll, $timeout, $location, leafletData, leafletEvents, geocoderService, Project, ProjectSheet) ->
    """
    This controller is made to be child of ProjectListCtrl where it watches for update in $scope.projectsheets list
    Upon update, it rebuilds its marker base
    """
    $scope.rebuildMarkers = ()->
        console.log(" Updating marker")
        $scope.markers = new Array()
        cluster_group_name = Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0, 5);
        angular.forEach($scope.projectsheets, (ps)->
            # Either get LatLng directly, or from address_locality ? 
            if ps.project.location
                if ps.project.location.geo 
                    marker_data = {
                            title: ps.project.title
                            baseline: ps.project.baseline
                            description: ps.project.description
                            cover: ps.cover                                                                                                           
                            id: ps.id
                            slug: ps.project.slug
                        }              
                    marker = 
                    {
                        group: cluster_group_name
                        groupOption :
                            showCoverageOnHover : false
                        lat: ps.project.location.geo.coordinates[1]
                        lng: ps.project.location.geo.coordinates[0]
                        getMessageScope: ()->
                                newScope = $scope.$new()
                                angular.extend(newScope,
                                        marker: {
                                            data: marker_data
                                        }
                                )
                                return newScope
                        message: '<div ng-include="\'views/map/marker_card.html\'" class="boxes boxes-small"></div>'
                        icon:
                                type: 'awesomeMarker'
                                prefix: 'fa'
                                # icon: marker.category.icon_name
                                markerColor: "blue"
                                iconColor: "white"
                    }
                    $scope.markers.push(marker)
                # no geo coords yet, try resolving address ?
        )

    $scope.gotoAnchor = (x) ->
        newHash = 'anchor' + x
        if $location.hash() != newHash
            $location.hash('anchor' + x)
        else
            $anchorScroll()

    console.log("loadind map, projectsheets ?", $scope.projectsheets)

    angular.extend($scope,
        defaults :
            scrollWheelZoom: true # Keep the scrolling working on the page, not in the map
            maxZoom: 14
            minZoom: 1
            path:
                weight: 10
                color: '#800000'
                opacity: 1
        center:
            lat: 46.43
            lng: 2.35
            zoom: 5
        markers : []
    )
    # loading time, build markers list
    # HACK : if group already defined, then clustered markers are not redrawn, see: https://github.com/tombatossals/angular-leaflet-directive/issues/381                                                                                                                                                                                                              
    #         => we redefine group name each time 
    $scope.cluster_group_name = Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0, 5); 
    $scope.rebuildMarkers()
    
    # Watch for update in projectsheets list
    $scope.$on('projectListRefreshed', (event)->
        $scope.rebuildMarkers() 
    )
)
