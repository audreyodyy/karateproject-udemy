Feature: Create token

Scenario: create token
    Given url 'https://api.realworld.io/api/'
    Given path 'users/login'
    And request {"user": {"email": "#(userEmail)","password": "#(userPassword)"}}
    When method post
    Then status 200
    * def authToken = response.user.token