const http = require('http');
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('¡Despliegue Automatizado Funcionando!');
});

server.listen(port, () => {
  console.log(`Servidor corriendo en puerto ${port}`);
});
