class @SectionDirective

    link: (scope, element, attr) ->

        scope.dataset = new Dataset attr.section
        scope.subset  = 'total'
        scope.selectedCountry = ''
        scope.hintedCountry = ''


        scope.unhintCountry = () ->
            scope.hintedCountry = ''
        scope.hintCountry = (country) ->
            scope.hintedCountry = country

        scope.selectCountry = (country) ->
            if scope.selectedCountry == country
                scope.selectedCountry = ""
            else
                scope.selectedCountry = country

    scope: true
