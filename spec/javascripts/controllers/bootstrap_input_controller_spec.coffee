describe 'Actionman', ()->

  beforeEach(module('Actionman'))

  describe 'BootstrapInputCtrl', () -> 
    scope = null
    ctrl = null
    element = $("<bootstrap-input key='name' description='Event Name' model='event.name'></bootstrap-input>")

    beforeEach inject (_$httpBackend_, $rootScope, $controller, $cacheFactory) ->
      scope = $rootScope.$new()
      ctrl = $controller( 'BootstrapInputCtrl', { $scope: scope, $element: element })

    it 'should set attributes the model to the scope', ->
      expect(scope.model).toEqual(element.attr('model'))

    it 'should set attributes the key to the scope', ->
      expect(scope.key).toEqual(element.attr('key'))

    it 'should set attributes the description to the scope', ->
      expect(scope.description).toEqual(element.attr('description'))