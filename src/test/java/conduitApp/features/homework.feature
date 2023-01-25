
Feature: Home Work

    Background: Preconditions
        * url apiUrl
        * def timeValidator = read('classpath:helpers/timeValidator.js') 

    @debug 
    Scenario: Favorite articles
        # Step 1: Get articles of the global feed
        Given params { limit: 10 , offset: 0 }
        Given path 'articles'
        When method get
        Then status 200
        # Step 2: Get the favorites count and slug ID for the first article, save it to variables
        * def initialFavoritesCount = response.articles[0].favoritesCount
        * def articleId = response.articles[0].slug
        * def articleTitle = response.articles[0].title
        # Step 3: Make POST request to increse favorites count for the first article
        Given path 'articles', articleId, "favorite" 
        When method post
        Then status 200
        # Step 4: Verify response schema
        And match response == 
        """
        {
            "article":{
                "id": "#number",
                "slug":"#string",
                "title":"#(articleTitle)",
                "description":"#string",
                "body":"#string",
                "createdAt":"#? timeValidator(_)",
                "updatedAt":"#? timeValidator(_)",
                "authorId":"#number",
                "tagList": "#array",
                "author":{
                    "username":"#string",
                    "bio": "##string",
                    "image":"#string",
                    "following":"#boolean"
                    },
                "favoritedBy":[{
                        "id":"#number",
                        "email":"#string",
                        "username":"#string",
                        "password":"#string",
                        "image":"#string",
                        "bio":"##string","demo": "#boolean"
                        }],
                "favorited": "#boolean",
                "favoritesCount":"#number"
            }
        }
        """
        # Step 5: Verify that favorites article incremented by 1
        * match response.article.favoritesCount == initialFavoritesCount + 1

        # Step 6: Get all favorite articles
        Given params { favorited: "userone", limit: 10 , offset: 0 }
        Given path 'articles'
        When method get
        Then status 200
        # Step 7: Verify response schema
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
        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
        * match response.articles[*].slug contains articleId
 
    # Scenario: Comment articles
    #     # Step 1: Get atricles of the global feed
    #     Given params { limit: 10 , offset: 0 }
    #     Given path 'articles'
    #     When method get
    #     Then status 200
    #     # Step 2: Get the slug ID for the first artice, save it to variable
    #     * def articleId = response.articles[0].slug
    #     # Step 3: Make a GET call to 'comments' end-point to get all comments
    #     Given path 'articles', articleId, "comments" 
    #     When method get
    #     Then status 200
    #     # Step 4: Verify response schema
    #     And match each response.comments ==
    #     """
    #         {
    #             "id": "#number",
    #             "createdAt": "#? timeValidator(_)",
    #             "updatedAt": "#? timeValidator(_)",
    #             "body": "#string",
    #             "author": {
    #                 "username": "#string",
    #                 "bio": "##string",
    #                 "image": "#string",
    #                 "following": "#boolean"
    #             }
    #         }
    #     """
    #     # # Step 5: Get the count of the comments array lentgh and save to variable
    #     #     #Example
    #     # * def responseWithComments = response.comments
    #     # * def commentCount = responseWithComments.length
    #     # # Step 6: Make a POST request to publish a new comment
    #     # Given path 'articles', articleId, "comments" 
    #     # And request { comment: { body: "test1" }}
    #     # When method post
    #     # Then status 200
    #     # # Step 7: Verify response schema that should contain posted comment text
    #     # And match response.comments ==
    #     # """
    #     #     {
    #     #         "id": "#number",
    #     #         "createdAt": "#? timeValidator(_)",
    #     #         "updatedAt": "#? timeValidator(_)",
    #     #         "body": "#string",
    #     #         "author": {
    #     #             "username": "#string",
    #     #             "bio": "##string",
    #     #             "image": "#string",
    #     #             "following": "#boolean"
    #     #         }
    #     #     }
    #     # """
    #     # Step 8: Get the list of all comments for this article one more time
    #     # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
    #     # Step 10: Make a DELETE request to delete comment
    #     # Step 11: Get all comments again and verify number of comments decreased by 1