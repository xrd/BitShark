@app = angular.module( 'plbh', [ 'ngRoute', 'ngResource' ] )

@app.factory( 'Needed', () ->
        { donations: 23 }
        )

@app.factory 'Sponsors', [ '$resource', ($resource) ->
        $resource '/sponsors/:action', {},
                index: { isArray: true, method: 'GET' }
        ]
@app.factory 'Facebook', [ '$resource', ( $resource ) ->
        $resource '/facebook/:action', {},
                friends: { params: { action: 'friends' }, isArray: true, method: 'GET' }
                invite: { params: { action: 'invite' }, method: 'POST' }
        ]

@app.controller 'HomeCtrl', [ '$scope', 'Needed', ( $scope, Needed ) ->
        $scope.needed = Needed
        ]

@app.controller 'SponsorCtrl', [ '$scope', 'Sponsors', ($scope, Sponsors) ->
        $scope.sponsors = Sponsors.index()
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
        $routeProvider.when('/sponsor',
                templateUrl: '/t/sponsor',
                controller: 'SponsorCtrl' )
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


