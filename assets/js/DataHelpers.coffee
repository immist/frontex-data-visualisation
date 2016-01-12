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
