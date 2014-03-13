@app = angular.module( 'plbh', [ 'ngRoute', 'ngResource', 'ngSanitize', 'ng-rails-csrf' ] )

@app.factory( 'Needed', () ->
        { donations: undefined }
        )

@app.factory 'Loans', [ '$resource', ($resource) ->
        $resource '/loans/:action', {},
                index: { isArray: true, method: 'GET' },
                create: { isArray: false, method: 'POST' }
        ]
@app.factory 'Facebook', [ '$resource', ( $resource ) ->
        $resource '/facebook/:action', {},
                friends: { params: { action: 'friends' }, isArray: true, method: 'GET' }
                invite: { params: { action: 'invite' }, method: 'POST' }
        ]

@app.controller 'HomeCtrl', [ '$scope', 'Needed', 'Loans', ( $scope, Needed, Loans ) ->
        $scope.needed = Needed
        ]

@app.controller 'DonateCtrl', [ '$scope', 'Loans', ($scope, Loans) ->
        Loans.index {}, (response) ->
                $scope.loans = response
        ]

@app.controller 'LoansCtrl', [ '$scope', 'Loans', '$location', '$timeout', ($scope, Loans, $location, $timeout) ->
        $scope.loan = {}
        $scope.loans = Loans.index()
        $scope.message = undefined

        $scope.preview = (onOff) ->
                $scope.isPreview = onOff
                $scope.rendered = markdown.toHTML $scope.loan.description

        $scope.sponsor = () ->
                Loans.create( {}, { loan: $scope.loan }, ( (response) ->
                        $scope.message = "Successfully added loan"
                        $timeout ( () -> $location.path '/' ), 2000
                        ), ( (error) -> $scope.message = "Bad response" ) )
        ]

@app.controller 'FacebookCtrl', [ '$scope', 'Facebook', ( $scope, fb ) ->
        fb.friends {}, (response) ->
                $scope.friends = response
        $scope.selected = {}

        $scope.addToSelected = (friend, onOff ) ->
                $scope.selected[friend.id] = if onOff then friend else undefined
                $scope.selectedFriends = Object.values( $scope.selected )

        $scope.inviteFriends = () ->
                fb.invite {}, friends: $scope.selectedFriends, (response) ->
                        $scope.message = response.message
        
        $scope.toggle = (friend) ->
                friend.selected = !friend.selected
                $scope.addToSelected( friend, friend.selected )
        ]

@app.controller 'LoginCtrl', [ '$scope', '$window', ($scope, $window) ->
        $window.location.href = "/auth/facebook"
        ]

@app.config [ '$routeProvider', '$locationProvider', ( $routeProvider, $locationProvider ) ->
        $routeProvider.when('/invite',
                templateUrl: '/t/invite',
                controller: 'FacebookCtrl' )
        $routeProvider.when('/loans',
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


