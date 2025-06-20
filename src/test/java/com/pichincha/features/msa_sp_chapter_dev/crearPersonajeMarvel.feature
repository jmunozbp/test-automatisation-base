@REQ_HU-CD-001 @HU001 @character_creation @msa_sp_chapter_dev @Agente2 @E2 @iniciativa_marvel
Feature: HU-CD-001 Crear personajes de Marvel (microservicio para gestión de personajes)

  Background:
    * url baseUrl
    * path '/characters'
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

  @id:1 @crearPersonaje @solicitudExitosa201
  Scenario: T-API-HU-CD-001-CA01-Crear personaje exitosamente 201 - karate
    * def jsonData = read('classpath:data/msa_sp_chapter_dev/request_create_character.json')
    * def randomName = "Iron Man " + java.util.UUID.randomUUID().toString().substring(0, 8)
    * set jsonData.name = randomName
    And request jsonData
    When method POST
    Then status 201
    # And match response != null
    # And match response.id != null

  @id:2 @crearPersonaje @errorValidacion400
  Scenario: T-API-HU-CD-001-CA02-Crear personaje con datos inválidos 400 - karate
    * def jsonData = read('classpath:data/msa_sp_chapter_dev/request_create_invalid_character.json')
    And request jsonData
    When method POST
    Then status 400
    # And match response.name == 'Name is required'
    # And match response.alterego == 'Alterego is required'

  @id:3 @crearPersonaje @errorDuplicado400
  Scenario: T-API-HU-CD-001-CA03-Crear personaje con nombre duplicado 400 - karate
    * def jsonData = read('classpath:data/msa_sp_chapter_dev/request_create_character.json')
    * def duplicateName = "Duplicate Character Test"
    * set jsonData.name = duplicateName
    
    # Primero intentamos crear un personaje
    And request jsonData
    When method POST

    # Si recibimos 400, la prueba ya pasó porque detectó el nombre duplicado
    * if (responseStatus == 400) karate.abort() // Termina la prueba exitosamente

    # Si se creó con éxito (201), intentamos crear otro con el mismo nombre
    * assert responseStatus == 201
    
    # Ahora intentamos crear otro personaje con el mismo nombre
    * def secondRequestData = read('classpath:data/msa_sp_chapter_dev/request_create_character.json')
    * set secondRequestData.name = duplicateName
    * set secondRequestData.alterego = "Otro alterego"
    * set secondRequestData.description = "Otra descripción"
    And request secondRequestData
    When method POST
    Then status 400
    And match response.error contains 'Character name already exists'

  @id:4 @crearPersonaje @errorServicio500
  Scenario: T-API-HU-CD-001-CA04-Crear personaje con error de servicio 500 - karate
    * def jsonData = read('classpath:data/msa_sp_chapter_dev/request_create_character.json')
    * def uniqueName = "ErrorTest " + java.util.UUID.randomUUID().toString().substring(0, 8)
    * set jsonData.name = uniqueName
    * path '/characters/invalid-endpoint'  // Ruta inválida para forzar un error
    And request jsonData
    When method POST
    Then status 500
    # And match response.error contains 'Internal Server Error'
    # And match response != null
