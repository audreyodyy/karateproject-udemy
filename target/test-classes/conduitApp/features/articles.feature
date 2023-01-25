Feature: Articles

    Background: Define url
    * url apiUrl
    * def articleRequestBody = read('classpath:conduitApp/json/articleResquest.json')
    * def dataGenerator = Java.type('helpers.dataGenerator')
    * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
    * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
    * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body

    @new-art
    Scenario: Create new article
        Given path 'articles'
        And request articleRequestBody
        When method post
        Then status 200
        And match response.article.title == articleRequestBody.article.title
    
    Scenario: Create and delete article
        Given path 'articles'
        And request articleRequestBody
        When method post
        Then status 200
        * def articleId = response.article.slug
        
        Given params { limit: 10 , offset: 0 }
        Given path 'articles'
        When method get
        Then status 200 
        And match response.articles[0].title == articleRequestBody.article.title

        Given path 'articles',articleId
        When method delete
        Then status 204

        Given params { limit: 10 , offset: 0 }
        Given path 'articles'
        When method get
        Then status 200 
        And match response.articles[0].title != articleRequestBody.article.title



        

