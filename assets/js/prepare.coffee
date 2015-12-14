window.data = {}
window.data.refusals = {}

@toNumber = (number) -> parseInt number.replace(/\s+/g, '')

@formatNumber = (number) ->
    formattedNumber = ''
    for digit, i in number.toString()
        digit += ' ' if i % 3 == 0
        formattedNumber = digit + formattedNumber
    return formattedNumber
