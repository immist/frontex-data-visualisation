
defaultViewBoxDimensions =
    [
        1682,
        928
    ]

class FrontexMap extends Visualization

    constructor: (selector) ->
        # append instead of select
        mapWrap = $(selector)
        mapWrap.append '<div id="map"></div>'
        @map = mapWrap.find('#map')[0]
        @map.style.width = defaultViewBoxDimensions[0] + 'px'
        @map.style.height =defaultViewBoxDimensions[1] + 'px'

        @visualization = new Datamap
            element: @map
        @svg = d3.select('.datamap')

        @views =
            default: [0,0,1,1]
            eu: [0.5, 0.19, 0.1, 0.226]

        @makeResponsive()




class FrontexVisualisation
    constructor: (@rawdata, @mapSelector) ->
        @map = new FrontexMap @mapSelector
        @map.applyFocus 'eu'


new FrontexVisualisation window.data, '#Visualizations'
