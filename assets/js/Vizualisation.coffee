class @Visualization
    constructor: (dimensions, @svg) ->
        # dimensions the map is initialised with
        @dimensions =
            original:
                x: dimensions[0]
                y: dimensions[1]

            scale: (dimension) -> @current[dimension] / @original[dimension]

        # rescale map on window resize
        @currentFocus = 'default'
        @setViewBox()

    # update viewbox of map
    setViewBox: =>
        @dimensions.current =
            x: window.innerWidth
            y: window.innerHeight
        viewBox = ''
        for value, i in @views[@currentFocus]
            if i == 0
                viewBox += value * @dimensions.original['x'] + ' '
            if i == 1
                viewBox += value * @dimensions.original['y'] + ' '
            if i == 2
                viewBox += value / @dimensions.scale('x') * @dimensions.original['x'] + ' ' # width = correct
            if i == 3
                viewBox += value / @dimensions.scale('y') * @dimensions.original['y'] + ' ' # height = correct

        return @svg.transition().attr 'viewBox', viewBox


    applyFocus: (area, smoothDuration) ->
        @currentFocus = area
        zoom = @setViewBox()
        if smoothDuration?
            zoom.duration(smoothDuration)
