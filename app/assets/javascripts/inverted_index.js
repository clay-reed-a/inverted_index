/* InvertedIndex APP */

var invertedIndex = angular.module('invertedIndex', [
  'ngSanitize',
  'autocomplete',
  'controllers',
  'services', 
  'filters']
);

/* SERVICES */

var services = angular.module('services', []);

services.service('Words', 
  function($http){
    this.indexWords = function(){
      return $http(
        {
          method: 'GET',
          url: 'api/words.json'
        }
      );
    };

    this.showWord = function(wordId){
      return $http(
        {
          method: 'GET',
          url: 'api/words/'+wordId+'.json'
        }
      );
    };

    return this; 
  });

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
  function($scope, Listings, Words){
    $scope.queryString = '';
    $scope.searchResults = null; 
    $scope.words = []; 

    Words.indexWords()
      .then(
        function(data,status,config,headers)
        {
          
          $scope.words = _.pluck(data.data, 'content'); 
          console.log(JSON.stringify($scope.words));
        },
        function(data,status,config,headers)
        {
          console.log('Problems!');
        }
      );

    $scope.searchListings = function(queryString){
 
      Listings.searchListings(queryString)
        .then(
          function(data,status,config,headers)
          {
            var resultsSection = 
              document.querySelector('.results-section');
            angular.element(resultsSection).removeClass('hidden');

            $scope.searchResults = data.data;

          },
          function(data,status,config,headers){
            console.log('Problems!');
          }
        )
    };

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

//* FILTERS */

var filters = angular.module('filters', []);

filters.filter('sanitize', ['$sce', function($sce) {
  return function(htmlCode){
    return $sce.trustAsHtml(htmlCode);
  }
}]);

filters.filter('removeContactInfo', [function(){
  return function(craigslistListing){
    // turn <a YIP YIP >show contact info</a>
    // into [see Craigslist]
    contactInfoREGEX = /<a.+>show contact info<\/a>/;
    return craigslistListing.replace(contactInfoREGEX, '[see Craigslist]');
  }
}]);