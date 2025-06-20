@REQ_HU-CD-001 @HU001 @character_get @msa_sp_chapter_dev @Agente2 @E2 @iniciativa_marvel
Feature: HU-CD-001 Consultar personajes de Marvel (microservicio para gestión de personajes)

  Background:
    * url baseUrl
    * def generarHeaders =
      """
      function() {
        return {
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers

  @id:1 @consultarPersonajes @solicitudExitosa200
  Scenario: T-API-HU-CD-001-CA05-Consultar todos los personajes 200 - karate
    * path '/characters'
    When method GET
    Then status 200
    And match response != null
    And match response == '#array'

  @id:2 @consultarPersonaje @solicitudExitosa200
  Scenario: T-API-HU-CD-001-CA06-Consultar personaje por ID 200 - karate
    # Primero creamos un personaje para asegurar que hay datos
    * path '/characters'
    * def jsonData = read('classpath:data/msa_sp_chapter_dev/request_create_character.json')
    * def uniqueName = "Character " + java.util.UUID.randomUUID().toString().substring(0, 8)
    * set jsonData.name = uniqueName
    And request jsonData
    When method POST
    Then status 201
    * def characterId = response.id
    * def characterName = response.name

    # Ahora consultamos ese personaje
    * path '/characters/' + characterId
    When method GET
    Then status 200
    And match response.id == characterId
    And match response.name == characterName

  @id:3 @consultarPersonaje @errorNoEncontrado404
  Scenario: T-API-HU-CD-001-CA07-Consultar personaje no existente 404 - karate
    * path '/characters/999'
    When method GET
    Then status 404
    And match response.error == 'Character not found'
    And match response != null

  @id:4 @consultarPersonaje @errorServicio404
  Scenario: T-API-HU-CD-001-CA08-Consultar personaje con ID no válido 404 - karate
    * path '/characters/-1'
    When method GET
    Then status 404
    And match response.error == 'Character not found'
    And match response != null
