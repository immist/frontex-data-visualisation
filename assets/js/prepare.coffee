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

    constructor: (datasetId) ->
        # process all subsets
        ## transform all data to numbers
        ## calculate total if it does not exist yet
        ## provide functions for getting subsets and data in a specific format
        # for all types e.g. land,  air, sea
        @dataset = window.data[datasetId]
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

    get: (opts) ->

        # select subset
        if opts.subset?
            dataset = JSON.parse JSON.stringify @dataset[opts.subset]
        else
            dataset = JSON.parse JSON.stringify @dataset.total

        # reduce all except selected countries to zero
        if dataset[opts.selected]?
            for country, data of dataset
                if country != opts.selected
                    for value, i in data
                        dataset[country][i] = 0

        # mark highlighted country
        if dataset[opts.selected]?
            dataset[opts.selected].hinted = true

        # transform set to desired format
        dataset = @transformations[opts.format] dataset

        return dataset



    countryMap:
        "Afghanistan":                       'AFG'
        "Albania":                           'ALB'
        "Algeria":                           'DZA'
        "Bangladesh":                        'BDG'
        "Belarus":                           'BLR'
        "Bosnia and Herzegovina":            'BIH'
        "Brazil":                            'BRA'
        "China":                             'CHN'
        "Congo":                             'RCB'
        "Eritrea":                           'ERI'
        "Eritrea":                           'ERI'
        "FYR Macedonia":                     'MKD'
        "Gambia":                            'GMB'
        "Georgia":                           'GEO'
        "Honduras":                          'HND'
        "India":                             'IND'
        "Iran":                              'IRN'
        "Iraq":                              'IRQ'
        "Kosovo":                            'UNK'
        "Morocco":                           'MAR'
        "Nigeria":                           'NGA'
        "Not specified":                     'XXX'
        "Others":                            'OXX'
        "Pakistan":                          'PAK'
        "Palestine":                         'PSE'
        "Russian Federation":                'RUS'
        "Serbia":                            'SRB'
        "Somalia":                           'SOM'
        "Sudan":                             'SDN'
        "Syria":                             'SYR'
        "Tunisia":                           'TUN'
        "Turkey":                            'TUR'
        "USA":                               'USA'
        "Ukraine":                           'UKR'
        "Unspecified sub-Saharan nationals": 'SXX'

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
                            y: dataPoint
                    layerData.country = country
                    layers.push layerData

            return layers

