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

app = new angular.module 'FrontexVisualisationApp', ['ngParallax']

app.controller 'ViewController',
    class ViewController
        constructor: ($scope, $window) ->
            $scope.currentSection = 'start'
            $scope.crossings
            $scope.animateElementIn = ($el) ->
                $el.addClass('is-visible')
                $el.removeClass('is-hidden')
            $scope.animateElementOut = ($el) ->
                $el.addClass('is-hidden')
                $el.removeClass('is-visible')

            angular.element($window).bind 'scroll', ->
                $scope.$apply()



app.directive 'streamGraph', ['$compile', ($compile) ->
    new StreamGraph($compile)]

class DataMapDirective
    constructor: ($compile) ->
    scope: {
            focusedCountry: '&'
    }
    controller: ($scope) ->
        $scope.views =
            default: [0,0,1,1]
            euFar: [0.25, 0.15, 0.1, 0.1]
            euClose: [0.277, 0.178, 0.04, 0.045]
            euClose: [0.277, 0.178, 0.04, 0.045]
        focus = 'euClose'

    link: ($scope, el, attrs) =>
        $scope.map = new Datamap
            fills: 
                defaultFill: null
            element: el[0]
            setProjection: (element, options) ->
                projection = d3.geo.stereographic()
                path = d3.geo.path()
                    .projection( projection )
                return {path: path, projection: projection}
        svg = d3.select(el[0])
        $scope.svg = svg.select 'svg'
        width = $scope.svg[0][0].clientWidth
        height = $scope.svg[0][0].clientHeight
        $scope.svg.attr 'viewBox', '469 134 87 89'

app.directive 'map', ($compile) ->
    return new DataMapDirective()


class DataMapDirective
    constructor: ($compile) ->
    scope: {
            focusedCountry: '&'
    }
    controller: ($scope) ->
        $scope.views =
            default: [0,0,1,1]
            euFar: [0.25, 0.15, 0.1, 0.1]
            euClose: [0.277, 0.178, 0.04, 0.045]
            euClose: [0.277, 0.178, 0.04, 0.045]
        focus = 'euClose'

    link: ($scope, el, attrs) =>
        $scope.map = new Datamap
            element: el[0]
            fills: 
                defaultFill: null
            setProjection: (element, options) ->
                projection = d3.geo.stereographic()
                path = d3.geo.path()
                    .projection( projection )
                return {path: path, projection: projection}
        svg = d3.select(el[0])
        $scope.svg = svg.select 'svg'
        width = $scope.svg[0][0].clientWidth
        height = $scope.svg[0][0].clientHeight
        $scope.svg.attr 'viewBox', '469 134 87 89'

class RefusalsMap
    constructor: ($compile) ->
    scope: {
            focusedCountry: '&'
    }
    controller: ($scope) ->
        $scope.views =
            default: [0,0,1,1]
            euFar: [0.25, 0.15, 0.1, 0.1]
            euClose: [0.277, 0.178, 0.04, 0.045]
            euClose: [0.277, 0.178, 0.04, 0.045]
        focus = 'euClose'

    link: ($scope, el, attrs) =>
        data = new Dataset window.data.refusals
        countries = data.getCountries()
        mapData = {}
        for country in countries
            mapData[country] =
                fillKey: 'peopleCameFromHere'
        $scope.map = new Datamap
            element: el[0]
            setProjection: (element, options) ->
                projection = d3.geo.stereographic()
                path = d3.geo.path()
                    .projection( projection )
                return {path: path, projection: projection}
            fills: 
                defaultFill: null
                'peopleCameFromHere': "#FF3757"
            data: mapData
        svg = d3.select(el[0])
        $scope.svg = svg.select 'svg'
        width = $scope.svg[0][0].clientWidth
        height = $scope.svg[0][0].clientHeight
        $scope.svg.attr 'viewBox', '469 134 87 89'

app.directive 'refusalsmap', ($compile) ->
    return new RefusalsMap()

class StayersMap
    constructor: ($compile) ->
    scope: {
            focusedCountry: '&'
    }
    controller: ($scope) ->
        $scope.views =
            default: [0,0,1,1]
            euFar: [0.25, 0.15, 0.1, 0.1]
            euClose: [0.277, 0.178, 0.04, 0.045]
            euClose: [0.277, 0.178, 0.04, 0.045]
        focus = 'euClose'

    link: ($scope, el, attrs) =>
        colors = d3.scale.category10()


        $scope.map = new Datamap
            element: el[0]
            projection: d3.geo.stereographic()
            setProjection: (element, options) ->
                projection = d3.geo.stereographic()
                path = d3.geo.path()
                    .projection( projection )
                return {path: path, projection: projection}

            fills: 
                defaultFill: null
                peopleCameFromHere: "#FF3757"

        svg = d3.select(el[0])
        $scope.svg = svg.select 'svg'

        data = new Dataset window.data.stays
        countries = data.getCountries()
        path = d3.geo.path()
        for country in countries
            console.log country
            countryFeature = $scope.svg.select '.' + country
            if countryFeature?
                console.log path.centroid countryFeature

        $scope.svg.attr 'viewBox', '469 134 87 89'
        $scope.map.bubbles [
                name: 'Castle Bravo',
                radius: 25,
                yeild: 15000,
                country: 'USA',
                significance: 'First dry fusion fuel "staged" thermonuclear weapon; a serious nuclear fallout accident occurred',
                fillKey: 'USA',
                date: '1954-03-01',
                latitude: 11.415,
                longitude: 165.1619
            ]

app.directive 'stayersmap', ($compile) ->
    return new StayersMap()
