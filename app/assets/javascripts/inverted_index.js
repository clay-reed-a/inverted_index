/* InvertedIndex APP */

var invertedIndex = angular.module('invertedIndex', [
  'controllers',
  'services']
);

/* SERVICES */

var services = angular.module('services', []);

services.service('Listings', 
  function($http){
    this.searchListings = function(queryString){
      return $http(
        {
          method: 'GET', 
          url: '/api/listings/s.json',
          params: {
            q: queryString
          }
        }
      );

    }

    this.indexListings = function(){
      return $http(
        {
          method: 'GET', 
          url: '/api/listings.json'
        }
      );
    }

    this.showListing = function(listingId){
      return $http(
        {
          method: 'GET', 
          url: '/api/listings/'+listingId+'.json'
        }
      );
    }

    return this; 
  });

/* CONTROLLERS */

var controllers = angular.module('controllers', []);

controllers.controller('MainController', 
  function($scope, Listings){
    $scope.queryString = '';
    $scope.searchResults = null; 

    $scope.consoleLogListings = function(){
      Listings.indexListings()
        .then(
          function(data, status, config, headers)
          {
            for (var i = 0; i < data.data.length; i++) {
              console.log(data.data[i].title); 
            }
          },
          function(data, status, config, headers)
          {
            console.log('Problems!');
          }
        )
    };
  }
);
