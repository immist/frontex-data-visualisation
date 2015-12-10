
defaultViewBoxDimensions =
    [
        1682,
        928
    ]

class FrontexMap extends Visualization

    constructor: (selector, dimensions) ->
        # append instead of select
        mapWrap = $(selector)
        mapWrap.append '<div id="map"></div>'
        @map = mapWrap.find('#map')[0]
        @map.style.width  = dimensions[0] + 'px'
        @map.style.height = dimensions[1] + 'px'

        @visualization = new Datamap
            element: @map
        @svg = d3.select('.datamap')

        @views =
            default: [0,0,1,1]
            eu: [0.5, 0.19, 0.1, 0.226]

        @makeResponsive(dimensions)




class FrontexVisualisation
    constructor: (@rawdata, @selector) ->
        # @map = new FrontexMap @selector, defaultViewBoxDimensions
        # @map.applyFocus 'eu'
        @refusals = new RefusalsTree(@selector, defaultViewBoxDimensions)




new FrontexVisualisation window.data, '#Visualizations'
