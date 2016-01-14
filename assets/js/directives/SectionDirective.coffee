class @SectionDirective

    link: (scope, element, attr) ->
        scope.focus = attr.focus

        # Get color scheme from directive
        scope.baseTones = attr.baseTones
        scope.highlightColor = attr.highlightColor
        scope.getColorClasses = -> [scope.baseTones, scope.highlightColor]

        scope.getBaseColor = (shade) ->
            if scope.baseTones == 'dark'
                return colors['base0' + shade]
            if scope.baseTones == 'light'
                return colors['base' + shade]

        scope.getMainColor = (shade) ->
            if scope.baseTones == 'light'
                return colors['base0' + shade]
            if scope.baseTones == 'dark'
                return colors['base' + shade]

        scope.getHighlightColor = ->
            colors[scope.highlightColor]

        # instantiate new Dataset 
        scope.dataset = new Dataset attr.section
        scope.subset  = 'total'
        scope.selectedCountry = ''
        scope.hintedCountry = ''


        scope.unhintCountry = () =>
            scope.hintedCountry = '' if scope.selectedCountry == ''

        scope.hintCountry = (country) =>
            scope.hintedCountry = country if scope.selectedCountry == ''

        scope.selectCountry = (country) ->
            # de-select when country is clicked again
            if scope.selectedCountry == country
                scope.selectedCountry = ""
            else
                scope.selectedCountry = country

    scope: true
