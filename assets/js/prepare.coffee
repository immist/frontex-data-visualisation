window.data = {}
window.data.refusals = {}

@toNumber = (number) ->
    if typeof number == 'number'
        return number
    if typeof number == 'string'
        return parseInt number.replace(/\s+/g, '')

@formatNumber = (number) ->
    formattedNumber = ''
    for digit, i in number.toString()
        digit += ' ' if i % 3 == 0
        formattedNumber = digit + formattedNumber
    return formattedNumber


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

class @GraphDirective
    margin:
        left: 0.1
        right: 0.1
        top: 0.1
        bottom: 0.1

    width: 800 * (1 - @margin.left - @margin.right)
    height: 600 * (1 - @margin.top - @margin.bottom)

    appendSvg: (el) ->
        el.append 'svg'
            .attr 'width', @width + @margin.left + @margin.right
            .attr 'height', @height + @margin.top + @margin.bottom

    styleWrapper: (el) ->
        el.style.width = '800px'
        el.style.height = '600px'
        el.style.display = 'block'

    controller: 'ViewController'
    scope: false

    restrict: 'E'
