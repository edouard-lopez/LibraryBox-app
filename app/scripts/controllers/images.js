'use strict';

/**
 * @ngdoc function
 * @name libraryboxApp.controller:ImagesCtrl
 * @description
 * # ImagesCtrl
 * Controller of the libraryboxApp
 */
angular.module('libraryboxApp')
  .controller('ImagesCtrl', function ($scope) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
  });
