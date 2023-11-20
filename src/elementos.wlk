import wollok.game.*
import personajePrincipal.*
import direcciones.*
import randomizer.*

class Pocion {

	var property position
	var vidaOtorgada
	const imagenPocion // ahora le pasamos la imagen por parametro
	const danioAdicional = 0
	const velocidadAdicional = 0

	method image() = imagenPocion

	method contacto(personaje) {
		personaje.tomarPocion(self)
		administradorPociones.quitar(self)
	}

	// Cada pocion pasara los valores que le asignemos nosotros.
	method efectoPocion(personaje) {
		personaje.aumentarVida(vidaOtorgada)
		personaje.aumentarDanio(danioAdicional)
		personaje.aumentarVelocidadArma(velocidadAdicional)
	}

	method impactoDeBala(elemento) {
	// Sirve para que no salga el mensaje error
	}

	method solido() {
		return false
	}

}

class PocionRoja inherits Pocion(imagenPocion = "pocion_salud.png", vidaOtorgada = 5) {

// Pocion de salud 	
}

class PocionAzul inherits Pocion(imagenPocion = "pocion_azul.png", vidaOtorgada = 3, velocidadAdicional = 10) {

// Pocion de ... (hay que proveerle algo)
}

class PocionAmarilla inherits Pocion(imagenPocion = "pocion_amarilla.png", vidaOtorgada = 1, danioAdicional = 2) {

// Pocion de daño
}

object pocionRojaFactory {

	method nuevaPocion() {
		return new PocionRoja(position = randomizer.emptyPosition())
	}

}

object pocionAzulFactory {

	method nuevaPocion() {
		return new PocionAzul(position = randomizer.emptyPosition())
	}

}

object pocionAmarillaFactory {

	method nuevaPocion() {
		return new PocionAmarilla(position = randomizer.emptyPosition())
	}

}

// las pociones factory repiten codigo, tratemos de evitar porque a medida que metamos mas cosas se va hacer un choclo.
object administradorPociones {

	var property pociones = []
	const cantidadMaxima = 4
	const pocionesFactory = [ pocionAzulFactory, pocionRojaFactory, pocionAmarillaFactory ]

	// Esto sirve para que genere nuevas pociones que nosotros definamos.
	method generarPocion() {
		return pocionesFactory.anyOne().nuevaPocion()
	}

	method generarPociones() {
		if (pociones.size() < cantidadMaxima) {
			const pocion = self.generarPocion()
			game.addVisual(pocion)
			pociones.add(pocion)
		}
	}

	method quitar(elemento) {
		pociones.remove(elemento)
		game.removeVisual(elemento)
	}

}

object corazon {

	const property position = game.at(1, 0)

	method image() = "corazon" + mago.vida().toString() + ".png"

}

class Moneda {

	var property position
	const property valorMoneda

	method image() = "moneda.png"

	method contacto(personaje) {
		monedero.removerMoneda(self)
	}

	method impactoDeBala(elemento) {
	// Sirve para que no salga el mensaje error
	}

	method solido() {
		return false
	}

}

object monedero {

	const property position = game.at(10, 0)
	var property cantidadMonedas = 0
	var property monedas = []

	method image() = "monedero.png"

	method text() = self.cantidadMonedas().toString() + "/100"

	method textColor() = "FFFFFF"

	method generarMoneda(_position) { // con probabilidad simple de 1 a 10 de valor 
		const monedaNueva = new Moneda(position = _position, valorMoneda = (1 .. 10).anyOne())
		self.agregarMoneda(monedaNueva)
	}

	method agregarMoneda(moneda) {
		game.addVisual(moneda)
		monedas.add(moneda)
	}

	method removerMoneda(moneda) {
		cantidadMonedas += moneda.valorMoneda()
		monedas.remove(moneda)
		game.removeVisual(moneda)
	}

}

