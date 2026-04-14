const { saludo, calcularDescuento, main } = require('../index');

describe('TechMarket App', () => {
  test('saludo retorna mensaje correcto', () => {
    expect(saludo('TechMarket')).toBe('Hola desde TechMarket, TechMarket!');
  });

  test('calcula descuento correctamente', () => {
    expect(calcularDescuento(100, 20)).toBe(80);
  });

  test('descuento del 0% retorna precio original', () => {
    expect(calcularDescuento(100, 0)).toBe(100);
  });

  test('lanza error con porcentaje inválido', () => {
    expect(() => calcularDescuento(100, 150)).toThrow('Porcentaje inválido');
  });

  test('descuento del 100% retorna cero', () => {
    expect(calcularDescuento(100, 100)).toBe(0);
  });

  test('saludo con nombre vacío', () => {
    expect(saludo('')).toBe('Hola desde TechMarket, !');
  });

  test('main ejecuta sin errores', () => {
    const consoleSpy = jest.spyOn(console, 'log').mockImplementation(() => {});
    expect(() => main()).not.toThrow();
    consoleSpy.mockRestore();
  });
});
