
defaultViewBoxDimensions =
    [
        1682,
        928
    ]


class FrontexVisualisation
    constructor: (@rawdata, @selector) ->
        @refusals = new RefusalsTree(@selector, defaultViewBoxDimensions)
        @map = new FrontexMap @selector, defaultViewBoxDimensions
        @map.applyFocus 'euFar'
        @visualizationsWrap = $(@selector)
        $(window).scroll (e) =>
            # append class to #viz container
            newSection = @getCurrentSection()

            if newSection != @currentSection
                @visualizationsWrap.attr 'class', 'is-focusedOn' + newSection
                @currentSection = newSection
                if newSection == 'Intro'
                    @map.applyFocus 'euFar', 2000
                if newSection == 'Routes'
                    @map.applyFocus 'euClose', 1500


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
