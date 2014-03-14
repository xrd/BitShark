@app = angular.module( 'plbh', [ 'ngRoute', 'ngResource', 'ngSanitize', 'ng-rails-csrf', 'ui.bootstrap' ] )

markified = (txt) ->
        markdown.toHTML txt

@app.factory( 'Needed', () ->
        { donations: undefined }
        )

@app.directive 'clearSearch', () ->
        link = (scope,element,attrs) ->
                element.clearSearch()
                
        return { restrict: 'A',
        link: link }

@app.factory 'Loans', [ '$resource', ($resource) ->
        $resource '/loans/:action', {},
                all: { isArray: true, method: 'GET', params: { action: "all" } },
                create: { isArray: false, method: 'POST' }
        ]
@app.factory 'Facebook', [ '$resource', ( $resource ) ->
        $resource '/facebook/:action', {},
                friends: { params: { action: 'friends' }, isArray: true, method: 'GET' }
                invite: { params: { action: 'invite' }, method: 'POST', isArray: false }
        ]

@app.controller 'HomeCtrl', [ '$scope', 'Needed', 'Loans', ( $scope, Needed, Loans ) ->
        $scope.needed = Needed
        ]

@app.controller 'DonateCtrl', [ '$scope', 'Loans', ($scope, Loans) ->
        $scope.markified = markified

        Loans.all {}, (response) ->
                $scope.loans = response
                for loan in $scope.loans
                        loan.progress = parseInt(Math.random()*100)
        ]

@app.controller 'LoansCtrl', [ '$scope', 'Loans', '$location', '$timeout', ( $scope, Loans, $location, $timeout ) ->

        $scope.init = () ->
                $scope.type = "sponsor"
                $scope.loan = {}

        $scope.loans = Loans.all()
        $scope.message = undefined

        $scope.preview = (onOff) ->
                $scope.isPreview = onOff
                $scope.rendered = markified $scope.loan.description

        $scope.markified = markified

        $scope.sponsor = () ->
                Loans.create( {}, { loan: $scope.loan }, ( (response) ->
                        $scope.message = "Successfully added loan"
                        $timeout ( () -> $location.path '/' ), 2000
                        ), ( (error) -> $scope.message = "Bad response" ) )

        $scope.init()
        
        ]

@app.controller 'FacebookCtrl', [ '$scope', 'Facebook', '$filter', '$timeout', '$location', 'Loans', ( $scope, fb, $filter, $timeout, $location, Loans ) ->
                
        $scope.alphabetPagerSize = 6
        $scope.display = {}

        $scope.loading = true
        $scope.message = "Loading friends from Facebook"

        $scope.loanName = (name, description) ->
                name + description[0..10] + "..."
        
        fb.friends {}, (response) ->
                $scope.display.items = $scope.items = response
                $scope.buildPagers()
                Loans.all {}, (response) ->
                        $scope.loans = response
                        $scope.loading = false
                        $scope.message = undefined

        $scope.getNameFromFullName = (text) ->
                rv = undefined
                lastIndex = text.lastIndexOf( " " )
                unless -1 == lastIndex
                        rv = text[lastIndex+1..-1]
                        # Watch out for stuff like "Barron  "
                        rv = text unless /\w/.test rv
                else
                        rv = text
                rv

        $scope.sortItems = () ->
                $scope.items.sort (a,b) ->
                        first = $scope.getNameFromFullName( a.name ).toLowerCase() || a.name
                        second = $scope.getNameFromFullName( b.name ).toLowerCase() || b.name
                        if first < second
                                -1
                        else if second < first
                                1
                        else
                                if a.name < b.name
                                        -1
                                else if b.name < a.name
                                        1
                                else
                                        0

        $scope.$watch 'filters.list', (newVal, oldVal) ->
                if newVal != oldVal
                        console.log "Filtering..."
                        $scope.filter( newVal )
                        $scope.search = ""

        $scope.searchByName = () ->
                lc = $scope.search.toLowerCase()
                $scope.display.items = $filter('filter')( $scope.items, (item) ->
                        -1 != item.name.toLowerCase().indexOf( lc ) )
                $scope.buildPagers()

        $scope.pageSize = 100
        $scope.offset = 0

        # Pager stuff
        $scope.initializePager = () ->
                unless $scope.items and $scope.items.length
                        console.log "Waiting"
                        $timeout $scope.initializePager, 1000
                else
                        # console.log "Inside pager initialize"
                        $scope.offset = 0
                        $scope.currentPage = 0
                        $scope.display.pageCount = Math.ceil( $scope.display.items.length / $scope.pageSize )
                        $scope.recalculatePage()

        $scope.buildPagers = () ->
                $scope.sortItems()
                # console.log item.name for item in $scope.items[0..5]
                $scope.initializePager()
                $scope.buildAlphabetPager()

        $scope.previous = () ->
                # Go forward
                $scope.jump($scope.offset-$scope.pageSize)

        $scope.next = () ->
                # Go forward
                $scope.jump($scope.offset+$scope.pageSize)

        $scope.jump = (index) ->
                # Don't let us go below zero or above
                index = 0 if index < 0
                index = $scope.pageSize*($scope.display.pageCount-1) if index >= $scope.items.length

                # Make sure index is multiple of page size
                index = parseInt(index/$scope.pageSize)*$scope.pageSize

                $scope.offset = index
                $scope.currentPage = parseInt($scope.offset/$scope.pageSize)
                $scope.recalculatePage()

        $scope.recalculatePage = () ->
                # console.log "#{$scope.items.length} / #{$scope.offset} / #{$scope.pageSize} "
                $scope.page = $scope.display.items[$scope.offset..($scope.offset+$scope.pageSize)]

        $scope.buildAlphabetPager = () ->
                unless $scope.alphabetPagerSize
                        console.log "WARNING: You have not set the alphabetPagerSize on scope and are using it"
                
                if $scope.display.items.length > $scope.pageSize
                        $scope.alphabetPagerChunks = []
                        if ( Math.floor( $scope.display.items.length / $scope.alphabetPagerSize ) ) > $scope.pageSize
                                chunkSize = parseInt( $scope.display.items.length / $scope.alphabetPagerSize ) + 1
                                for num in [0...$scope.alphabetPagerSize]
                                        the_start = $scope.display.items[num*chunkSize]
                                        the_end = $scope.display.items[((num+1)*chunkSize)-1] ||
                                                $scope.display.items[$scope.display.items.length-1]
                                        the_end_char = if the_end then $scope.getNameFromFullName( the_end.name )[0] else 'Z'
                                        $scope.alphabetPagerChunks.push { link: "#{$scope.getNameFromFullName(the_start.name)[0]}-#{the_end_char}", offset: num*chunkSize }
                else
                        $scope.alphabetPagerChunks = undefined

        $scope.filter = (list) ->
                if list
                        $scope.display.items = $filter('filter')( $scope.items, (item) -> item.lists && item.lists[list] )
                else
                        $scope.display.items = $scope.items
                $scope.buildPagers()

        $scope.pager = (bump) ->
                $scope.offset += bump
                $scope.offset = Math.max(0, $scope.offset)
                $scope.offset = Math.min($scope.offset, $scope.items.length)
                $scope.search = ""

        $scope.show = (item) ->
                $scope.showing = item
                
        $scope.selected = {}

        $scope.addToSelected = (friend, onOff ) ->
                if onOff
                        $scope.selected[friend.id] = friend
                else
                        delete $scope.selected[friend.id]
                        
                $scope.selectedCount = Object.keys($scope.selected).length

        $scope.inviteFriends = () ->
                $scope.inviting = true
                $scope.message = "Please wait, sending invites"
                fb.invite {}, { sponsors: $scope.selected, loan: $scope.loan.id }, (response) ->
                        $scope.message = response.message
                        $scope.message = "Invited friends."
                        $timeout ( () -> $location.path "/" ), 2000 
        
        $scope.toggle = (friend) ->
                friend.selected = !friend.selected
                $scope.addToSelected( friend, friend.selected )
        
        ]

@app.controller 'LoginCtrl', [ '$scope', '$window', ($scope, $window) ->
        $window.location.href = "/auth/facebook"
        ]

@app.controller 'HelpCtrl', [ '$scope', ($scope) ->

        $scope.markified = markified

        $scope.init = () ->
                $scope.type = "inneed"
                $scope.loan = {}


        
        $scope.ask = () ->
                Loans.create( {}, { loan: $scope.loan }, ( (response) ->
                        $scope.message = "Successfully added loan"
                        $timeout ( () -> $location.path '/' ), 2000
                        ), ( (error) -> $scope.message = "Bad response" ) )

        $scope.init()
        ]

@app.config [ '$httpProvider', ($httpProvider) ->
        $httpProvider.defaults.headers.common = { "AngularRails" : "1" }
        ]

@app.config [ '$routeProvider', '$locationProvider', ( $routeProvider, $locationProvider ) ->
        $routeProvider.when('/invite',
                templateUrl: '/t/invite',
                controller: 'FacebookCtrl' )
        $routeProvider.when('/help',
                templateUrl: '/t/loans',
                controller: 'HelpCtrl' )
        $routeProvider.when('/sponsor',
                templateUrl: '/t/loans',
                controller: 'LoansCtrl' )
        $routeProvider.when('/donate',
                templateUrl: '/t/donate',
                controller: 'DonateCtrl' )
        $routeProvider.when('/auth/facebook',
                templateUrl: '/t/login'
                controller: 'LoginCtrl' )
        $routeProvider.when('/',
                templateUrl: '/t/home',
                controller: 'HomeCtrl' )
        $routeProvider.otherwise( redirectTo: '/' )
        $locationProvider.html5Mode(true)
        ]


