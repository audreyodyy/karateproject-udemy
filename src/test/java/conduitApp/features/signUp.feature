Feature: Sign up

    Background:
        * def dataGenerator = Java.type('helpers.dataGenerator')
        * def timeValidator = read('classpath:helpers/timeValidator.js') 
        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUsername = dataGenerator.getRandomUsername()
        * url apiUrl
    
    
    Scenario: Create a new user
        Given path 'users'
        And request 
        """
            {
                "user": {
                    "email": #(randomEmail),
                    "password": "newkarateuserpass",
                    "username": #(randomUsername)
                }
            }
        """
        When method post 
        Then status 200
        And match response == 
        """
            {
                "user": {
                    "email": #(randomEmail),
                    "username": #(randomUsername),
                    "bio": "##string",
                    "image": "#string",
                    "token": "#string"
                }
            }
        """
    Scenario Outline: Validate sign up error messages
        Given path 'users'
        And request 
        """
            {
                "user": {
                    "email": "<email>",
                    "password": "<password>",
                    "username": "<username>"
                }
            }
        """
        When method post 
        Then status 422
        And match response == <errorResponse>

        Examples:
            | email                       | password          | username               | errorResponse                                                                      |
            | #(randomEmail)              | newkarateuserpass | newkarateuser123       | {"errors":{"username":["has already been taken"]}}                                 |
            | newkarateuser123@mail.com   | newkarateuserpass | #(randomUsername)      | {"errors":{"email":["has already been taken"]}}                                    |



