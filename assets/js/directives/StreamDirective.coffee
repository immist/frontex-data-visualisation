class @StreamGraphDirective
    duration: 600
    constructor: (@$compile) ->
    scope: false

    createVisualisation: (el) ->
        el = el[0]
        @width = el.offsetWidth
        @height = el.offsetHeight
        return d3.select el
            .append 'svg'
            .attr 'class', 'stream-vis-svg'


    link: (scope, el, attrs) =>

        vis = @createVisualisation el

        graph = vis.append 'g'
            .attr 'class', 'Graph'

        vis.append 'g'
            .attr 'class', 'axisX'
        vis.append 'g'
            .attr 'class', 'axisY'

        update = (source) =>
            stack = d3.layout.stack().offset 'zero'
            layers = stack source


            x = d3.scale.linear()
                .domain [0, layers[0].length - 1]
                .range [0, @width ]

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

            y = d3.scale.linear()
                .domain [totalMax * 1.3, 0]
                .range [0, @height]

            colorScale = d3.scale.linear()
                .range ['#000', '#FFF']
            area = d3.svg.area()
                .x (d) ->
                    x d.x
                .y0 (d) -> y d.y0 
                .y1 (d) -> y(d.y0 + d.y)

            streams = graph.selectAll 'path'
                .data layers
            streams
                .transition()
                .duration @duration
                .attr 'd', area


            streams.exit()
                .transition()
                .remove()


            streams.enter().append 'path'
                .attr 'd', area
                .attr 'class', 'stream-layer'
                .attr 'ng-click', (d) -> 'selectCountry("' + d.country + '")'
                .attr 'ng-mouseenter', (d) -> 'hintCountry("' + d.country + '")'
                .attr 'ng-mouseleave', (d) -> 'unhintCountry()'
                .style 'stroke', 'transparent'
                .style 'opacity', -> 0.5 + Math.random() * 0.5
                .call (els) =>
                    for el, i in els[0]
                        @$compile(el)(scope)

            labels = window.data.header
            axisX = d3.svg.axis()
                .scale x
                .ticks layers[0].length
                .tickFormat (d) -> labels[d]
                .tickSize(-@width, 0, 0)

            axisY = ->
                d3.svg.axis()
                    .scale y
                    .orient 'left'
                    .ticks 5
                    .tickFormat d3.format 's'

            vis.select '.axisX'
                .attr 'transform', 'translate(0,' + @height+ ')'
                .call axisX


            vis.select '.axisY'
                .transition()
                .duration @duration
                .call(axisY()
                    .tickSize(-@width, 0, 0))

        updateGraph = =>
            update scope.dataset.get
                format: 'layers'
                subset: scope.subset
                selected: scope.selectedCountry
        scope.$watch 'selectedCountry', updateGraph, true
        scope.$watch 'hintedCountry', updateGraph, true
        scope.$watch 'subset', updateGraph, true
