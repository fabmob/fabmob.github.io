// Generated by CoffeeScript 1.4.0
(function() {
  var DataSharing, FilterService, module;

  module = angular.module("commons.base.services", ['restangular']);

  DataSharing = (function() {

    function DataSharing($rootScope) {
      this.$rootScope = $rootScope;
      console.log("init DataSharing");
      this.sharedObject = {};
    }

    return DataSharing;

  })();

  module.factory('DataSharing', function($rootScope) {
    return new DataSharing($rootScope);
  });

  FilterService = (function() {

    function FilterService($rootScope) {
      this.$rootScope = $rootScope;
      console.log("init FilterService");
      this.filterParams = {};
    }

    return FilterService;

  })();

  module.factory('FilterService', function($rootScope) {
    return new FilterService($rootScope);
  });

}).call(this);
