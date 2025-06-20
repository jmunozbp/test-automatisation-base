function fn() {
  var env = karate.env || 'local';
  
  // Configuración base para todos los entornos
  var config = {
    baseUrl: 'http://localhost:8080'
  };
  
  // URLs para todos los microservicios (nombrados con formato port_nombre_microservicio)
  config.port_chapter_dev = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/jemunozv/api';
  
  // Configuración específica por entorno
  if (env == 'dev') {
    config.baseUrl = 'https://api-dev.empresa.com';
    config.port_chapter_dev = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/jemunozv/api';
  } 
  else if (env == 'qa') {
    config.baseUrl = 'https://api-qa.empresa.com';
    config.port_chapter_dev = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/jemunozv/api';
  }
  
  return config;
}
