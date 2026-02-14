// index.js
const http = require('http');

// Una función simple que queremos asegurar que funcione
function sumar(a, b) {
  return a + b;
}

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('¡Despliegue con Tests funcionando!');
});

// Exportamos la función para el test
module.exports = { sumar, server };

if (require.main === module) {
  server.listen(3000, () => console.log('Puerto 3000'));
}
