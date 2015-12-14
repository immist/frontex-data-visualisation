window.data = {}
window.data.refusals = {}

@toNumber = (number) -> parseInt number.replace(/\s+/g, '')

@formatNumber = (number) ->
    formattedNumber = ''
    for digit, i in number.toString()
        digit += ' ' if i % 3 == 0
        formattedNumber = digit + formattedNumber
    return formattedNumber

@defaultWidth = 1600
@defaultHeight = 900

@scale =
    x: 1
    y: 1

@getViewBox = (view) =>
    # params: original dimensions, scale
    viewBox = ''
    for val, i in view
        if i == 0
            viewBox += val * defaultWidth + ' '
        if i == 1
            viewBox += val * defaultHeight + ' '
        if i == 2
            viewBox += val / scale.x * defaultWidth  + ' ' # width = correct
        if i == 3
            viewBox += val / scale.y * defaultHeight + ' ' # height = correct

    return viewBox
