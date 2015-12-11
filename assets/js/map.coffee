class @FrontexMap extends Visualization

    constructor: (selector, dimensions) ->
        # append instead of select
        mapWrap = $(selector)
        mapWrap.append '<div id="map"></div>'
        @map = mapWrap.find('#map')[0]
        @map.style.width  = dimensions[0] + 'px'
        @map.style.height = dimensions[1] + 'px'

        console.log d3.geo
        @visualization = new Datamap
            element: @map
            setProjection: (element, options) ->
                projection = d3.geo.stereographic()
                path = d3.geo.path()
                    .projection( projection )
                return {path: path, projection: projection}
        svg = d3.select('.datamap')

        @views =
            default: [0,0,1,1]
            euFar: [0.25, 0.15, 0.1, 0.1]
            euClose: [0.277, 0.178, 0.04, 0.045]

        super dimensions, svg



