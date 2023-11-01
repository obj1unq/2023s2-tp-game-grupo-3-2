import wollok.game.*
import personajePrincipal.*
import direcciones.*
import randomizer.*

class Elemento {

	method image()

	method chocasteCon(elemento) {
	}

	method usado(personaje) {
	}

}

class Antidoto inherits Elemento {

	var property position
	const property vidaOtorgada = 5

	override method image() = "pocion_salud.png"

	override method usado(personaje) {
		personaje.tomarPocion(self)
		generadorAntidotos.quitar(self)
	}

}

object generadorAntidotos {

	var property antidotos = []
	const cantidadMaxima = 2

	method generarAntidotos() {
		if (antidotos.size() < cantidadMaxima) {
			const antidoto = new Antidoto(position = game.at(randomizer.xCualquiera(), randomizer.yCualquiera()))
			game.addVisual(antidoto)
			antidotos.add(antidoto)
		}
	}

	method quitar(elemento) {
		antidotos.remove(elemento)
		game.removeVisual(elemento)
	}

}

object arma inherits Elemento {

	const property danio = 10
	var property position = game.at(3, 9)
	var estado = libre

	override method image() = "fire.png"

	method generarBalacera() {
		self.validarEstado()
		const nuevaBala = new Bala(position = self.position().right(1))
		nuevaBala.disparar()
	}

	method validarEstado() {
		if (self.esLibre()) {
			self.error("no esta en posicion de nadie")
		}
	}

	method esLibre() {
		return estado === libre
	}

	method position(_position) {
		estado.position(_position)
	}

	method serLlevada(_personaje) {
		estado = llevada
		estado.personaje(_personaje)
		estado.removerImagenFuego(self)
		_personaje.imagenPersonaje(1) // Crear estado para cambiar imagen y no hardcodear metodo
	}

	method dejarLlevada() {
		estado = libre
		estado.position(self.position())
	}

	method position() {
		return estado.position()
	}

}

object llevada {

	var property personaje = null

	method position() {
		return personaje.position()
	}

	method position(_position) {
		self.error("me estan llevando")
	}

	method removerImagenFuego(arma) {
		game.removeVisual(arma)
	}

}

object libre {

	var property position = game.at(3, 9)

}

class Bala inherits Elemento {

	const property danio = 2
	var property position

	override method image() = "fireball1.png"

	method disparar() {
		game.addVisual(self)
		game.onTick(300, "disparar", { self.avanzar()})
		game.onCollideDo(self, { zombie => zombie.chocasteCon(self)})
	}

	method avanzar() {
		position = self.position().right(1)
	}

}

object corazon inherits Elemento {

	const property position = game.at(1, 1)

	override method image() = "corazon" + soldado.vida().toString() + ".png"

}

class Moneda inherits Elemento {

	var property position

	override method usado(personaje) {
		personaje.sumarMoneda()
		monedero.removerMoneda(self)
	}

	override method image() = "moneda.png"

}

object monedero {

	const property position = game.at(10, 1)
	var property cantidadMonedas = 0
	var monedas = []

	method image() = "monedero.png"

	method text() = self.cantidadMonedas().toString() + "/10"

	method textColor() = "FFFFFF"

	method generarMoneda(_position) { // con probabilidad 
		const monedaNueva = new Moneda(position = _position)
		self.agregarMoneda(monedaNueva)
	}

	method agregarMoneda(moneda) {
		game.addVisual(moneda)
		monedas.add(moneda)
	}

	method removerMoneda(moneda) {
		monedas.remove(moneda)
		cantidadMonedas += 1
		game.removeVisual(moneda)
	}

}

