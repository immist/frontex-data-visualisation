



class @StreamGraph extends GraphDirective
    constructor: (@$compile) ->
    controller: ($scope) ->
        $scope.selectCountry = (country) ->
            $scope.update $scope.data.get 'layers', $scope.subset, country

    scope: {
            focusedCountry: '='
        }

    link: ($scope, el, attrs) =>
        $scope.data = new Dataset window.data[el[0].dataset.graph]
        $scope.subset = 'total'
        $scope.country = ''

        vis = @createVisualisation el

        graph = vis.append 'g'
            .attr 'class', 'Graph'

        vis.append 'g'
            .attr 'class', 'axisX'
        vis.append 'g'
            .attr 'class', 'axisY'

        $scope.update = (source) =>
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
                .attr 'd', area
                .attr 'ng-click', 'selectCountry("")'
                .call (els) =>
                    for el in els[0]
                        @$compile(el)($scope)


            streams.exit()
                .transition()
                .remove()


            streams.enter().append 'path'
                .attr 'd', area
                .attr 'class', 'streamLayer'
                .attr 'ng-click', (d) -> 'selectCountry("' + d.country + '")'
                .on 'mouseover', (d) ->
                    vis.append 'text'
                        .attr 'class', 'tooltip'
                        .text d.country
                .on 'mouseout', (d) ->
                    vis.selectAll '.tooltip'
                        .remove()

                .style 'stroke', 'transparent'
                .style 'opacity', -> 0.5 + Math.random() * 0.5
                .call (els) =>
                    for el in els[0]
                        @$compile(el)($scope)




            labels = window.data.header
            axisX = ->
                d3.svg.axis()
                    .scale x
                    .ticks layers[0].length
                    .tickFormat (d) -> labels[d]

            axisY = ->
                d3.svg.axis()
                    .scale y
                    .orient 'left'
                    .ticks 8
                    .tickFormat d3.format 's'


            vis.select '.axisX'
                .attr 'transform', 'translate(0,' + @height+ ')'
                .call(axisX()
                    .tickSize(-@width, 0, 0))


            vis.select '.axisY'
                .call(axisY()
                    .tickSize(-@width, 0, 0))
        $scope.update $scope.data.get 'layers', $scope.subset, $scope.country

        #updateGraph(scope.subset, scope.country)
