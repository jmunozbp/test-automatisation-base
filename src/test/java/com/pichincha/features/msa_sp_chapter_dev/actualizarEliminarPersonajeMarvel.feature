@REQ_HU-CD-001 @HU001 @character_update_delete @msa_sp_chapter_dev @Agente2 @E2 @iniciativa_marvel
Feature: HU-CD-001 Actualizar y eliminar personajes de Marvel (microservicio para gestión de personajes)
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

  @id:1 @actualizarPersonaje @solicitudExitosa200
  Scenario: T-API-HU-CD-001-CA09-Actualizar personaje exitosamente 200 - karate
    # Primero creamos un personaje para asegurar que existe
    * path '/characters'
    * def jsonData = read('classpath:data/msa_sp_chapter_dev/request_create_character.json')
    * def uniqueName = "UpdateTest " + java.util.UUID.randomUUID().toString().substring(0, 8)
    * set jsonData.name = uniqueName
    And request jsonData
    When method POST
    Then status 201
    * def characterId = response.id

    # Ahora actualizamos el personaje
    * path '/characters/' + characterId
    * def jsonUpdateData = read('classpath:data/msa_sp_chapter_dev/request_update_character.json')
    * set jsonUpdateData.name = uniqueName  // Mantener el mismo nombre para evitar errores de duplicación
    And request jsonUpdateData
    When method PUT
    Then status 200
    # And match response.id == characterId
    # And match response.description == 'Updated description'

  @id:2 @actualizarPersonaje @errorNoEncontrado404
  Scenario: T-API-HU-CD-001-CA10-Actualizar personaje no existente 404 - karate
    * path '/characters/999'
    * def jsonUpdateData = read('classpath:data/msa_sp_chapter_dev/request_update_character.json')
    And request jsonUpdateData
    When method PUT
    Then status 404
    # And match response.error == 'Character not found'
    # And match response != null

  @id:3 @actualizarPersonaje @errorServicio404
  Scenario: T-API-HU-CD-001-CA11-Actualizar personaje no existente 404 - karate
    * path '/characters/-1'
    * def jsonUpdateData = read('classpath:data/msa_sp_chapter_dev/request_update_character.json')
    And request jsonUpdateData
    When method PUT
    Then status 404
    # And match response.error == 'Character not found'
    # And match response != null

  @id:4 @eliminarPersonaje @solicitudExitosa204
  Scenario: T-API-HU-CD-001-CA12-Eliminar personaje exitosamente 204 - karate
    # Primero creamos un personaje para asegurar que existe
    * path '/characters'
    * def jsonData = read('classpath:data/msa_sp_chapter_dev/request_create_character.json')
    * def uniqueName = "DeleteTest " + java.util.UUID.randomUUID().toString().substring(0, 8)
    * set jsonData.name = uniqueName
    And request jsonData
    When method POST
    Then status 201
    * def characterId = response.id

    # Ahora eliminamos el personaje
    * path '/characters/' + characterId
    When method DELETE
    Then status 204
    
    # Verificamos que ya no existe
    * path '/characters/' + characterId
    When method GET
    Then status 404

  @id:5 @eliminarPersonaje @errorNoEncontrado404
  Scenario: T-API-HU-CD-001-CA13-Eliminar personaje no existente 404 - karate
    * path '/characters/999'
    When method DELETE
    Then status 404
    # And match response.error == 'Character not found'
    # And match response != null
    
  @id:6 @eliminarPersonaje @errorServicio404
  Scenario: T-API-HU-CD-001-CA14-Eliminar personaje inexistente 404 - karate
    * path '/characters/-1'
    When method DELETE
    Then status 404
    # And match response.error == 'Character not found'
    # And match response != null
