
defaultViewBoxDimensions =
    [
        1682,
        928
    ]

class FrontexMap extends Visualization

    constructor: (selector, dimensions) ->
        # append instead of select
        mapWrap = $(selector)
        mapWrap.append '<div id="map"></div>'
        @map = mapWrap.find('#map')[0]
        @map.style.width  = dimensions[0] + 'px'
        @map.style.height = dimensions[1] + 'px'

        @visualization = new Datamap
            element: @map
        svg = d3.select('.datamap')

        @views =
            default: [0,0,1,1]
            eu: [0.5, 0.19, 0.1, 0.226]

        super dimensions, svg




class FrontexVisualisation
    constructor: (@rawdata, @selector) ->
        @refusals = new RefusalsTree(@selector, defaultViewBoxDimensions)
        @map = new FrontexMap @selector, defaultViewBoxDimensions
        @map.applyFocus 'eu'
        @visualizationsWrap = $(@selector)
        $(window).scroll (e) =>
            # append class to #viz container
            newSection = @getCurrentSection()

            if newSection != @currentSection
                @visualizationsWrap.attr 'class', 'is-focusedOn' + newSection
                @currentSection = newSection

        @updateSectionPositions()
        @currentSection = @getCurrentSection()
        @visualizationsWrap.attr 'class', 'is-focusedOn' + @currentSection

    getCurrentSection: ->
        scrollPosition = $(window).scrollTop()
        for section in @sectionPositions
            if scrollPosition > (section.position - 200)
                currentSection = section.id
        return currentSection

    updateSectionPositions: ->
        sections = $('.Section')
        @sectionPositions = ({id: section.id, position: section.offsetTop} for section in sections)




new FrontexVisualisation window.data, '#Visualizations'
