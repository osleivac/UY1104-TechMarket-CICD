// TechMarket - Aplicación principal
function saludo(nombre) {
  return `Hola desde TechMarket, ${nombre}!`;
}

function calcularDescuento(precio, porcentaje) {
  if (porcentaje < 0 || porcentaje > 100) {
    throw new Error('Porcentaje inválido');
  }
  return precio - (precio * porcentaje / 100);
}

function main() {
  console.log(saludo('Mundo'));
  console.log('Precio con descuento:', calcularDescuento(100, 20));
}

module.exports = { saludo, calcularDescuento, main };
