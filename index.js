// index.js
const http = require('http');
const { Client } = require('pg');

// Configuración de conexión (leerá variables de entorno)
const dbClient = new Client({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: 5432,
});

// Intentamos conectar al arrancar
dbClient.connect()
  .then(() => console.log("¡Conectado a la BD de AWS!"))
  .catch(err => console.error("Error al conectar:", err));

function sumar(a, b) {
  return a + b;
}

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Automatización Total Nivel 2: BD Integrada');
});

module.exports = { sumar, server };

if (require.main === module) {
  server.listen(3000, () => console.log('Servidor en puerto 3000'));
}