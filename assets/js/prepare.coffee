window.data = {}
window.data.refusals = {}
window.data.crossings = {}

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

@getViewBox = (view, width, height) =>
    # params: original dimensions, scale
    viewBox = ''
    for val, i in view
        if i == 0
            viewBox += val * width + ' '
        if i == 1
            viewBox += val * height + ' '
        if i == 2
            viewBox += val / scale.x * width  + ' ' # width = correct
        if i == 3
            viewBox += val / scale.y * height + ' ' # height = correct

    return viewBox

class @GraphDirective
    createVisualisation: (el) ->

        # select proper element
        el = el[0]
        # assign data


        # define dimensions
        @margin =
            left: 100
            right: 100
            top: 100
            bottom: 100

        @width = 1000 - @margin.left - @margin.right
        @height = 800 - @margin.top - @margin.bottom


        # select with d3 and create wrapping elements
        el = d3.select el

        graph = el
            .append 'svg'
            .attr 'width', @width + @margin.left + @margin.right
            .attr 'height', @height + @margin.top + @margin.bottom
            .append 'g'
            .attr 'width', @width
            .attr 'height', @height
            .attr("transform", "translate(" + @margin.left + "," + @margin.top + ")")


        graph

    appendSvg: (el) ->

    styleWrapper: (el) =>


    restrict: 'E'

class @Dataset
    transformations:
        layers: (rawData) ->
            layers = []
            for country, data of rawData
                # create each layer
                layerData = []
                if country != 'Total All Borders'
                    for dataPoint, i in data
                        layerData.push
                            x: i
                            y: toNumber dataPoint
                    layerData.country = country
                    layers.push layerData
            return layers


    constructor: (@dataset) ->
        # process all subsets
        ## transform all data to numbers
        ## calculate total if it does not exist yet
        ## provide functions for getting subsets and data in a specific format
        # for all types e.g. land,  air, sea
        if !@dataset.total?
            total = {}
            for type, set of @dataset
                for country, data of set
                    if !total[country]?
                        total[country] = data
                    else
                        for value, index in data
                            total[country][index] = total[country][index] + value
             @dataset.total = total

    countryMap:
        "Albania":            'ALB'
        "Brazil":             'BRA'
        "Algeria":            'ALG'
        "USA":                'USA'
        "Ukraine":            'UKR'
        "China":              'CHN'
        "Russian Federation": 'RUS'
        "Honduras":           'HND'
        "Nigeria":            'NGA'
        "Syria":              'SYR'
        "Afghanistan":        'AFG'
        "Eritrea":            'ERI'
        "Iraq":               'IRQ'
        "Morocco":            'MAR'
        "Pakistan":           'PAK'
        "Somalia":            'SOM'
        "Algeria":            'DZA'
        # "Others":             [6434 ,6648 ,6948 ,7006 ,7208 ,6587]
        # "Not specified":      '


    getCountries: =>
        countries = []
        for country of @dataset.total
            countries.push @countryMap[country]
        countries
    getSubsetIdentifiers: ->
        subsets = []
        for subset of @dataset
            subsets.push subset
        subsets

    get: (transform, subSet, country) ->
        if subSet?
            dataset = @dataset[subSet]
        else
            dataset = @dataset.total
        if dataset[country]?
            countryData = dataset[country]
            dataset = {}
            dataset[country] = countryData
        dataset = @transformations[transform] dataset
        dataset
