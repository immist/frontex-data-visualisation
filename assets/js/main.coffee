class FrontexVisualisation
    constructor: ->
        @map = new FrontexMap()
        @map.applyFocus 'euFar'
        graphics =
            map: @map
            crossings: new StreamGraph '#Crossings', window.data.crossings
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




# new FrontexVisualisation()

app = new angular.module 'FrontexVisualisationApp', []

app.controller 'ViewController',
    class ViewController
        constructor: ($scope, $window) ->
            $scope.currentSection = 'start'
            angular.element($window).bind 'scroll', ->
                $scope.currentSection = this.pageYOffset
                $scope.$apply()

app.directive 'map', ($window) ->
    directiveObject =
        controller: 'ViewController'
        restrict: 'E'
        scope:
            currentSection: '&'
        link: (scope, el, attrs) ->
            el[0].style.width = '800px'
            el[0].style.height = '600px'
            el[0].style.display = 'block'
            euMap = new FrontexMap el[0]
            scope.$watch 'currentSection', (newValue, oldValue) ->
                euMap.applyFocus 'euClose'


    return directiveObject
