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
            layers = stack source.layers


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

            streams = graph.selectAll '.stream-layer'
                .data layers
            streams
                .attr 'class', (d) ->
                    return 'stream-layer hinted' if d.hinted?
                    return 'stream-layer'
                .style 'fill', (d) ->
                    return scope.getHighlightColor() if d.hinted? | d.selected?
                    return undefined
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

            dots = graph.selectAll '.precision-circle'
                .data source.sum

            dots.enter().append 'circle'
                .attr 'class', 'precision-circle'
                .attr 'cx', (d) ->
                    x d.x
                .attr 'cy', (d) ->
                    y d.y
                .attr 'r', '7'
                .style 'fill', scope.getMainColor(3)
                .style 'stroke', ->
                    scope.getBaseColor(3)
                .on "mouseover", -> tooltip.classed "visible", 1
                .on "mouseout", -> tooltip.classed "visible", 0
                .on "mousemove", (d) ->
                    tooltip
                        .attr 'x', x d.x
                        .text formatNumber d.y
                        .style 'fill', scope.getMainColor(3)
                        .style 'stroke', scope.getBaseColor(3)
                        .style 'stroke-width',  0.1
                        .style 'alignment-baseline', 'middle'
                        .style 'dominant-baseline', 'central'


            dots
                .transition()
                .duration @duration
                .attr 'cx', (d) ->
                    x d.x
                .attr 'cy', (d) ->
                    y d.y



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

        tooltip = vis
            .append("text")
            .attr 'class', 'tooltip'
            .style("position", "absolute")
            .style("z-index", "10")

        updateGraph = =>
            update scope.dataset.get
                format: 'layers'
                subset: scope.subset
                selected: scope.selectedCountry
                hinted: scope.hintedCountry
        scope.$watch 'selectedCountry', updateGraph, true
        scope.$watch 'hintedCountry', updateGraph, true
        scope.$watch 'subset', updateGraph, true
