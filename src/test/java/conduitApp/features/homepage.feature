Feature: Tests for homepage

    Background: 
        Given url 'https://api.realworld.io/api/'
     
    Scenario: Get all tag
        Given path 'tags'
        When method get 
        Then status 200
        And match response.tags contains ['welcome', 'ipsum']
        And match response.tags !contains 'implementation'
        And match response.tags contains any ['world', 'welcome', 'live']
        And match response.tags == '#array'
        And match each response.tags == '#string'

    Scenario: Get 10 articles from the page
        * def timeValidator = read('classpath:helpers/timeValidator.js') 

        Given params { limit: 10 , offset: 0 }
        Given path 'articles'
        When method get
        Then status 200 
        And match response == {"articles": "#[10]", "articlesCount": 197}
        And match each response.articles == 
        """
            {
                "slug": "#string",
                "title": "#string",
                "description": "#string",
                "body": "#string",
                "tagList": "#array",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "favorited": "#boolean",
                "favoritesCount": "#number",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                }
            }
        """