class @FrontexMap
    applyFocus: (focus, transition) ->
        @svg.attr 'viewBox', getViewBox @views[focus]

    constructor: (@map) ->
        @visualization = new Datamap
            element: @map
            setProjection: (element, options) ->
                projection = d3.geo.stereographic()
                path = d3.geo.path()
                    .projection( projection )
                return {path: path, projection: projection}
        @svg = d3.select('svg.datamap')

        @views =
            default: [0,0,1,1]
            euFar: [0.25, 0.15, 0.1, 0.1]
            euClose: [0.277, 0.178, 0.04, 0.045]


        @visualization.arc [
                origin:
                    latitude: 38.311
                    longitude: 24.489
                destination:
                    latitude: -40
                    longitude: 30
                options:
                    greatArc: true
                    arcSharpness: 0.3
            ]
