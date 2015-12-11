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
        console.log @svg
        console.log this
        @dimensions.current =
            x: window.innerWidth
            y: window.innerHeight
        viewBox = ''
        for val, i in @views[@currentFocus]
            if i == 0
                viewBox += val * @dimensions.original['x'] + ' '
            if i == 1
                viewBox += val * @dimensions.original['y'] + ' '
            if i == 2
                viewBox += val / @dimensions.scale('x') * @dimensions.original['x'] + ' ' # width = correct
            if i == 3
                viewBox += val / @dimensions.scale('y') * @dimensions.original['y'] + ' ' # height = correct

        return @svg.transition().attr 'viewBox', viewBox


    applyFocus: (area, smoothDuration) ->
        @currentFocus = area
        zoom = @setViewBox()
        if smoothDuration?
            zoom.duration(smoothDuration)
