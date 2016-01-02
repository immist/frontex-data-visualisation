crossingsBumps = [ # layers, samples inside
]

transformDataToLayers = (rawData) ->
    layers = []
    for country, data of rawData
        # create each layer
        layerData = []
        if country != 'Total All Borders'
            for dataPoint, i in data
                # trim last values
                if i < 6
                    layerData.push
                        x: i
                        y: toNumber dataPoint
            layerData.country = country
            layers.push layerData
    return layers




class @StreamGraph extends GraphDirective
    constructor: (el, data, @$compile) ->
    link: (scope, el, attrs) =>
        el = el[0] # select proper element
        @styleWrapper el # add dimensions
        data = window.data[el.dataset.graph]
        @views =
            default: [0,0,1,1]
        @el = d3.select el

        svg = @appendSvg @el

        graph = svg.append 'g'
            .attr 'class', 'Graph'

        @data = transformDataToLayers data

        update = (source) =>
            stack = d3.layout.stack().offset 'zero'
            layers = stack source
            console.log layers


            x = d3.scale.linear()
                .domain [0, layers[0].length - 1]
                .range [@width , @width ]

            maxOfLayer = (layer) ->
                    d3.max layer, (layerPoint) ->
                        layerPoint.y0 + layerPoint.y

            minOfLayer = (layer) ->
                    d3.min layer, (layerPoint) ->
                        layerPoint.y0 + layerPoint.y

            meanOfLayer = (layer) ->
                    d3.mean layer, (layerPoint) ->
                        layerPoint.y0 + layerPoint.y

            totalMax = d3.max(layers, maxOfLayer)
            totalMin = d3.min(layers, minOfLayer)
            totalMaxMean = d3.max(layers, meanOfLayer)
            totalMinMean = d3.min(layers, meanOfLayer)

            sortedLayers = d3.sorty

            y = d3.scale.linear()
                .domain [totalMax, 0]
                .range [@height, @height]

            colorScale = d3.scale.linear()
                .range ['#000', '#FFF']
            area = d3.svg.area()
                .x (d) ->
                    x d.x
                .y0 (d) -> y d.y0 
                .y1 (d) -> y(d.y0 + d.y)

            tooltip = svg.append 'div'
                .text 'tooltip'

            streams = graph.selectAll 'path'
                .data layers
                .enter().append 'path'
                .attr 'd', area
                .style 'stroke', 'transparent'
                .style 'opacity', -> Math.random()
                .call => $compile(this[0].parentnode)(scope)
                #.style 'fill', -> colorScale Math.random()




            labels = window.data.header
            axisX = d3.svg.axis()
                .scale x
                .ticks layers[0].length
                .tickFormat (d) -> labels[d]

            axisY = d3.svg.axis()
                .scale y
                .ticks 10
                .tickFormat d3.format 's'
                .orient 'left'


            svg.append 'g'
                .attr 'transform', 'translate(0,' + (defaultHeight * 0.9) + ')'
                .call axisX
            svg.append 'g'
                .call axisY
                .attr 'transform', 'translate(' + (defaultWidth * 0.1) + ', 0)'
        update @data
