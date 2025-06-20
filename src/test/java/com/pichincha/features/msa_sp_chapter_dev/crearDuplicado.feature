@ignore
Feature: Helper para probar creación de personaje con nombre duplicado

  Scenario: Intentar crear un personaje con nombre duplicado
    * url baseUrl
    * path '/characters'
    * def jsonData = read('classpath:data/msa_sp_chapter_dev/request_create_character.json')
    * set jsonData.name = name
    * headers { 'Content-Type': 'application/json' }
    And request jsonData
    When method POST
    Then status 400
    And match response.error contains 'Character name already exists'
