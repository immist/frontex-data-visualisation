crossingsBumps = [ # layers, samples inside
]
for country, data of window.data.crossings
    layerData = []
    for dataPoint, i in data
        layerData.push
            x: i
            y: toNumber dataPoint
    crossingsBumps.push layerData





class @CrossingsBarChart extends Visualization
    constructor: (@selector, dimensions) ->
        @views =
            default: [0,0,1,1]
        svg = d3.select @selector
            .append 'svg'
            .attr 'width', dimensions[0]
            .attr 'height', dimensions[1]
            .attr 'id', 'CrossingsBarChart'
        width = dimensions[0]
        update = (source) =>
            stack = d3.layout.stack().offset 'wiggle'
            layers = stack source

            width = dimensions[0]
            height = dimensions[1]
            console.log source
            console.log layers

            x = d3.scale.linear()
                .domain [0, layers[0].length - 1]
                .range [width * 0.1, width * 0.9]

            y = d3.scale.linear()
                .domain [0, 100]
                .range [0, 0.1]

            area = d3.svg.area()
                .x (d) -> x d.x
                .y0 (d) -> y d.y0
                .y1 (d) -> y(d.y0 + d.y)
            streams = svg.selectAll 'path'
                .data layers
                .enter().append 'path'
                .attr 'd', area
                .style 'stroke', 'red'
                .style 'fill', 'transparent'



        update crossingsBumps


