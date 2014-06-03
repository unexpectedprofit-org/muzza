describe 'Twitter Login', ->

  beforeEach ->

    module 'firebase'
    module 'Muzza.twitter'
    module 'Muzza.templates'

    module ($provide) ->
      $provide.value '$firebaseSimpleLogin',
        ()->
          $login: ()->
            then: (callback)->
              user =
                uid: 11
                thirdPartyUserData: {name: 'San'}
              callback(user)
          $logout: -> null

      return null

  isolatedScope = undefined

  beforeEach ->
    inject ($compile, $rootScope) ->
      $scope = $rootScope
      $scope.contact = {}
      element = angular.element('<twitter-login ng-model="contact"></twitter-login>')
      $compile(element)($rootScope)
      $scope.$digest()
      isolatedScope = element.isolateScope()

  describe 'login', ->

    it 'should delegate to firebase and capture uid and name', ->
      isolatedScope.login()
      expect(isolatedScope.user.twitterId).toBe 11
      expect(isolatedScope.user.name).toBe 'San'

  describe 'logout', ->

    it 'should delegate to firebase and reset user to an empty object', ->
      isolatedScope.logout()
      expect(isolatedScope.user).toEqual { }




