import wollok.game.*
import personajePrincipal.*
import direcciones.*
import randomizer.*

class Arma {

	var property danio
	var velocidad
	const maxDanio
	const maxVelocidad = 100
	var property position

	method image()

	method accion(dirrecion)

	method aumentarSuDanio(_danio) {
		danio = (danio + _danio).min(maxDanio)
	}

	method aumentarSuVelocidad(_velocidad) {
		velocidad = (velocidad - _velocidad).max(maxVelocidad)
	}

	method contacto(personaje) {
	// agrege este mensaje por sino sale pantalla de error.
	}

	method impactoDeBala(elemento) {
	}

	method impactoDeFuego(elemento) {
	// para que no salga mensaje de error. 
	}

	method esUnArma() {
		return true
	}

	method solido() {
		return false
	}

	method imagenMagoConArma()

}

class FuegoAzul inherits Arma(danio = 5, maxDanio = 10, velocidad = 300) {

	const property efectoVelocidad = 0
	const duenio = mago

	override method image() = "fuegoAzul.png"

	override method accion(direccion) {
		llevada.cambiarEstado(duenio)
		self.serLanzada(direccion)
	}

	method serLanzada(direccion) {
		game.onTick(300, "lanzar", { self.avanzar(direccion)})
		game.onCollideDo(self, { zombie => zombie.impactoDeFuego(self)})
	}

	method avanzar(direccion) {
		position = direccion.siguiente(self.position())
		self.eliminarDelTablero()
	}

	method eliminarDelTablero() {
		if (self.position().x() > 13 or self.position().x() < 1 or self.position().y() < 1) {
			self.eliminarSiEstoy()
		}
	}

	method estoyEnElTablero() {
		return game.hasVisual(self)
	}

	method eliminarSiEstoy() {
		if (self.estoyEnElTablero()) {
			game.removeTickEvent("lanzar")
			administradorFuego.quitar(self)
		}
	}

	override method imagenMagoConArma() {
		return "mago_lanza.png"
	}

}

class FuegoVerde inherits FuegoAzul(danio = 2, maxDanio = 5, velocidad = 200, efectoVelocidad = 50) {

	var contador = 5

	override method image() = "fuegoVerde.png"

	override method avanzar(direccion) {
		if (contador != 0) {
			contador--
			position = direccion.siguiente(self.position())
			self.eliminarDelTablero()
		} else {
			contador = 5
			game.removeTickEvent("lanzar")
			administradorFuego.quitar(self)
		}
	}

}

object administradorFuego {

	var property fuegos = []
	const cantidadMaxima = 3

	method generarLanzas() {
		if (fuegos.size() < cantidadMaxima) {
			const fuego = new FuegoAzul(position = randomizer.emptyPosition())
			game.addVisual(fuego)
			fuegos.add(fuego)
		}
	}

	method quitar(elemento) {
		fuegos.remove(elemento)
		game.removeVisual(elemento)
	}

	method contacto(personaje) { // Para que no tire error 
	}

}

object armaFuego inherits Arma(danio = 2, maxDanio = 5, velocidad = 250, position = game.at(3, 8)) {

	override method image() = "fuegoRojo.png"

	override method accion(direccion) {
		self.generarBalacera(direccion)
	}

	method generarBalacera(direccion) {
		const nuevaBala = new Fuego(position = direccion.siguiente(self.position()), imagenDisparo = fireball, danio = danio)
		nuevaBala.disparar(direccion, velocidad)
	}

	override method imagenMagoConArma() {
		return "mago_fuego.png"
	}

}

object llevada {

	const cambioEstado = libre

	method moverElemento(personaje) {
		return personaje.armaDePersonaje().position(personaje.position())
	}

	method cambiarEstado(personaje) {
		personaje.llevando(cambioEstado)
	}

	method accion(personaje) {
		// self.cambiarEstado(personaje) esto tampoco sirve, solamente la lanza cambia el estado al personaje 
		personaje.armaDePersonaje().accion(personaje.ultimaDireccion())
	}

	method validarBalacera() {
	}

	method poseeArma() {
		return true
	}

}

object libre {

	const cambioEstado = llevada

	method moverElemento(personaje) {
	}

	method cambiarEstado(personaje) {
		personaje.llevando(cambioEstado)
	}

	method accion(personaje) {
	// no deberia hacer nada en el estado libre ??? 
	// personaje.armaDePersonaje().accion(personaje.ultimaDireccion())
	}

	method validarBalacera() {
		self.error("No me esta llevando")
	}

	method poseeArma() {
		return false
	}

}

// Ahora a la bala le asigno el danio desde el arma, pasando el danio que tiene el arma 
class Fuego {

	var property danio
	var property position
	const property imagenDisparo

	method image() = imagenDisparo.image()

	method disparar(direccion, velocidad) {
		game.addVisual(self)
		game.onTick(velocidad, "disparar", { self.avanzar(direccion)})
		game.onCollideDo(self, { zombie => zombie.impactoDeBala(self)})
	}

	method avanzar(direccion) {
		position = direccion.siguiente(self.position())
		self.eliminarDelTablero()
	}

	method eliminarDelTablero() { // Elimina fuego si supera supera eje X
		if (self.position().x() > 13 or self.position().x() < 1 or self.position().y() < 2) {
			self.eliminarSiEstoy()
		}
	}

	method estoyEnElTablero() {
		return game.hasVisual(self)
	}

	method eliminarSiEstoy() {
		if (self.estoyEnElTablero()) {
			game.removeTickEvent("disparar")
			game.removeVisual(self)
		}
	}

	method impactoDeBala(elemento) {
	// Sirve para que no salga el mensaje error
	}

	method impactoDeFuego(elemento) {
	// para que no salga mensaje de error. 
	}

	method solido() {
		return false
	}

	method contacto(personaje) {
	}

}

object fireball {

	method image() {
		return "fuegoRojo.png"
	}

}

object charge {

	method image() {
		return "charge.png"
	}

}

