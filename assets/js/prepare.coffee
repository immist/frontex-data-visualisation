window.data = {}
window.data.refusals = {}
window.data.crossings = {}

@formatNumber = (number) ->
    formattedNumber = ''
    for digit, i in number.toString()
        digit += ' ' if i % 3 == 0
        formattedNumber = digit + formattedNumber
    return formattedNumber


colors =
    base03:   "#002b36"
    base02:   "#073642"
    base01:   "#586e75"
    base00:   "#657b83"
    base0:    "#839496"
    base1:    "#93a1a1"
    base2:    "#eee8d5"
    base3:    "#fdf6e3"
    yellow:   "#b58900"
    orange:   "#cb4b16"
    red:      "#dc322f"
    magenta:  "#d33682"
    violet:   "#6c71c4"
    blue:     "#268bd2"
    cyan:     "#2aa198"
    green:    "#859900"

class @Dataset

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

