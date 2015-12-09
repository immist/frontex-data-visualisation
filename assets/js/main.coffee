
class FrontexMap

    constructor: (selector) ->
        @map = $(selector)[0]
        @vizualisation = new Datamap
            element: @map

        @wrap = d3.select('.Map-wrap')[0]

        @svg = d3.select('.datamap')

        # dimensions the map is initialised with
        @dimensions =

            original:
                x: @map.offsetWidth
                y: @map.offsetHeight

            scale: (dimension) -> @current[dimension] / @original[dimension]

        # rescale map on window resize
        @currentFocus = 'default'
        @setViewBox()
        window.onresize = @setViewBox

    # update viewbox of map
    setViewBox: () =>
        @dimensions.current =
            x: window.innerWidth
            y: window.innerHeight
        viewBox = ''
        for val, i in @views[@currentFocus]
            if i == 0
                viewBox += val *  @dimensions.original['x'] + ' '
            if i == 1
                viewBox += val * @dimensions.original['y'] + ' '
            if i == 2
                viewBox += val / @dimensions.scale('x') * @dimensions.original['x'] + ' ' # width = correct
            if i == 3
                viewBox += val / @dimensions.scale('y') * @dimensions.original['y'] + ' ' # height = correct

        return @svg.transition().attr 'viewBox', viewBox

    views:
        # default: '0 0 1680 928'
        default: [0,0,1,1]
        eu: [0.446, 0.19, 0.1, 0.226]


    applyFocus: (area, smoothDuration) ->
        @currentFocus = area
        zoom = @setViewBox()
        if smoothDuration?
            zoom.duration(smoothDuration)


class FrontexVisualisation
    constructor: (@rawdata, @mapSelector) ->
        @map = new FrontexMap @mapSelector
        @map.applyFocus 'eu'

new FrontexVisualisation window.data, '#map'
