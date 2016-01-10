class DatamapDirective
    scope: {
            focusedCountry: '&'
    }

    link: ($scope, el, attrs) =>
        $scope.map = new Datamap
            fills: 
                defaultFill: null
            element: el[0]
            setProjection: (element, options) ->
                projection = d3.geo.stereographic()
                path = d3.geo.path()
                    .projection( projection )
                return {path: path, projection: projection}
        svg = d3.select(el[0])
        $scope.svg = svg.select 'svg'
        width = $scope.svg[0][0].clientWidth
        height = $scope.svg[0][0].clientHeight
        $scope.svg.attr 'viewBox', '469 134 87 89'
