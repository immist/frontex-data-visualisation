class @SectionDirective

    link: (scope, element, attr) ->

        scope.dataset = new Dataset attr.section
        scope.subset  = 'total'
        scope.selectedCountry = ''
        scope.hintedCountry = ''

    scope: true
