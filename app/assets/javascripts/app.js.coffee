@app = angular.module( 'plbh', [ 'ngRoute', 'ngResource' ] )

@app.factory( 'Needed', () ->
        { sponsors: 45, cashiers: 12, checkers: 5 }
        )

@app.factory 'Facebook', [ '$resource', ( $resource ) ->
        $resource '/facebook/:action', {},
                friends: { params: { action: 'friends' }, isArray: true, method: 'GET' }
                invite: { params: { action: 'invite' }, method: 'POST' }
        ]

@app.controller 'TopCtrl', [ '$scope', 'Needed', ( $scope, Needed ) ->
        $scope.needed = Needed
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

@app.controller 'LoginCtrl', [ '$scope', ($scope) ->
        $window.location.href = "/auth/facebook"
        ]

@app.config [ '$routeProvider', '$locationProvider', ( $routeProvider, $locationProvider ) ->
        $routeProvider.when('/invite',
                templateUrl: '/t/invite',
                controller: 'FacebookCtrl' )
        $routeProvider.when('/checker',
                templateUrl: '/t/checker',
                controller: 'CheckerCtrl' )
        $routeProvider.when('/cashier',
                templateUrl: '/t/cashier',
                controller: 'CashierCtrl' )
        $routeProvider.when('/',
                templateUrl: '/t/home',
                controller: 'TopCtrl' )
        $routeProvider.when('/auth/facebook',
                controller: 'LoginCtrl' )
        $routeProvider.otherwise( redirectTo: '/' )
        $locationProvider.html5Mode(true)
        ]


