treeData =
    [
        parent: null
        name: 'Total illegal border crossings'
        value: 0
        parent: 'null'
        children: [
            name: 'Q1 2014'
            parent: 'Total illegal border crossings'
            _children: []
        ,
            name: 'Q2 2014'
            parent: 'Total illegal border crossings'
            _children: []
        ,
            name: 'Q3 2014'
            parent: 'Total illegal border crossings'
            _children: []
        ,
            name: 'Q4 2014'
            parent: 'Total illegal border crossings'
            _children: []
        ,
            name: 'Q1 2015'
            parent: 'Total illegal border crossings'
            _children: []
        ,
            name: 'Q2 2015'
            parent: 'Total illegal border crossings'
            _children: []
        ]
    ]

for country, data of window.data.crossings
    window.data.crossings[country] = data.map toNumber

delete window.data.crossings['Total All Borders']
for country, data of window.data.crossings # for each country
    numbers = []
    for quarter,i in treeData[0].children # select data for each quarter
        treeData[0].children[i]._children.push # push data into each quarter
            name: country
            type: 'country'
            parent: quarter
            value: window.data.crossings[country][i]
    for quarter,i in treeData[0].children # select data for each quarter
        treeData[0].children[i].value = 0
        treeData[0].children[i].value += window.data.crossings[country][i]

    for quarter,i in treeData[0].children # select data for each quarter
        treeData[0].value += treeData[0].children[i].value









class @RefusalsTree
    @dimensions: {}

    constructor: (@selector, dimensions) ->
        @views =
            default: [0,0,1,1]

        height = '400'

        tree = d3.layout.tree()
            .size [height * 2, height * 4]

        svg = d3.select '#Visualizations'
            .append 'svg'
            .attr 'id', 'RefusalsTree'
            .attr 'width',  dimensions[0]
            .attr 'height', dimensions[1]

        root = treeData[0]
        root.x0 = height / 2
        root.y0 = 0

        i = 0

        toggleNode = (d) ->
            siblings = d.parent.children
            expanded = d.children?
            for sibling in siblings
                if sibling.children?
                    sibling._children = sibling.children
                    delete sibling.children
            if !expanded
                d.children = d._children
                delete d._children
            update d

        diagonal = d3.svg.diagonal()
            .projection (d) -> [d.y, d.x]

        update = (source) =>
            nodes = tree.nodes(root).reverse()
            links = tree.links(nodes)

            node = svg.selectAll("g.node").data nodes, (d) ->
                d.id || (d.id = ++i)

            nodes.forEach (d) -> d.y = (d.depth + 0.5) * 400

            nodes.forEach (d) ->
                d.x0 = d.x
                d.y0 = d.y

            #enter
            nodeEnter = node
                .enter()
                    .append 'g'
                        .attr 'class', (d) ->
                            className = 'node'
                            if d.type?
                                className += ( ' ' + d.type)
                            className
                        .attr 'transform' , (d) ->
                            'translate(' + d.y + ',' + d.x + ')'
                        .on 'click', (d) ->
                            toggleNode(d)

            nodeEnter.append 'circle'
                .attr 'fill', 'white'
                .attr 'r', (d) ->
                    d.value / 100000


            nodeEnter.append 'text'
                .text (d) ->
                    text = ''

                    if d.value?
                        text += d.value
                    if d.name?
                        text += d.name
                    text

            nodeEnter.append 'text'
                .text (d) ->
                    if d.country?
                        return d.sum

            nodeUpdate = node
                .attr "transform", (d) -> "translate(" + d.y + "," + d.x + ")"
                .attr "opacity", 1
            nodeExit = node.exit()
                .attr "opacity", 0

            link = svg.selectAll 'path.link'
                .data links, (d) -> d.target.id

            calculateLink = (d) ->
                o =
                    x: source.x0
                    y: source.y0

                return diagonal
                    source: o
                    target: o

            link.enter().insert 'path', 'g'
                .attr 'd', calculateLink
                .attr 'stroke-width', (d) ->
                    d.target.value / 1000
                .attr 'class', 'link'
            link
                .attr("d", diagonal)
                .attr 'opacity', 1

            link.exit()
                .attr 'opacity', 0
                .attr 'd', calculateLink


            nodes.forEach (d) ->
                d.x0 = d.x
                d.y0 = d.y
        update root
