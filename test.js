// test.js
const { sumar } = require('./index');

test('Sumar 2 + 2 debe ser 4', () => {
  if (sumar(2, 2) !== 4) {
    throw new Error("El test ha fallado: 2 + 2 no es 4");
  }
  console.log("✅ Test pasado con éxito");
});

function test(nombre, fn) {
  try {
    fn();
  } catch (error) {
    console.error(`❌ ${nombre}`);
    console.error(error);
    process.exit(1); // Esto le dice al robot de GitHub que ALGO SALIÓ MAL
  }
}