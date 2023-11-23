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

}

class FuegoAzul inherits Arma(danio = 10, maxDanio = 15, velocidad = 100) {

	const property efectoVelocidad = 0
	const duenio = mago

	override method image() = "fuegoAzul.png"

	override method accion(direccion) {
		llevada.cambiarEstado(duenio)
		self.serLanzada(direccion)
	}

	method serLanzada(direccion) {
		game.onTick(velocidad, "lanzar", { self.avanzar(direccion)})
		game.onCollideDo(self, { zombie => zombie.impactoDeFuego(self)})
	}

	method avanzar(direccion) {
		position = direccion.siguiente(self.position())
		self.eliminarDelTablero()
	}

	method eliminarDelTablero() {
		if (self.position().x() > 13 or self.position().x() < 1 or self.position().y() < 2) {
			self.eliminarSiEstoy()
		}
	}

	method estoyEnElTablero() {
		return game.hasVisual(self)
	}

	method eliminarSiEstoy() {
		if (self.estoyEnElTablero()) {
			administradorFuegos.quitar(self)
		}
	}

}

class FuegoVerde inherits FuegoAzul(danio = 4, maxDanio = 6, velocidad = 150, efectoVelocidad = 50) {

	var contador = 5

	override method image() = "fuegoVerde.png"

	override method avanzar(direccion) {
		if (contador != 0) {
			contador--
			position = direccion.siguiente(self.position())
			self.eliminarDelTablero()
		} else {
			contador = 5
			administradorFuegos.quitar(self)
		}
	}

}

object fuegoAzulFactory {

	method nuevoFuego() {
		return new FuegoAzul(position = randomizer.emptyPosition())
	}

}

object fuegoVerdeFactory {

	method nuevoFuego() {
		return new FuegoVerde(position = randomizer.emptyPosition())
	}

}

object administradorFuegos {

	var property fuegos = []
	const cantidadMaxima = 3
	const factoryFuegos = [ fuegoAzulFactory, fuegoVerdeFactory ]

	method seleccionFactory() {
		return factoryFuegos.anyOne()
	}

	method generarFuegos() {
		if (fuegos.size() < cantidadMaxima) {
			const fuego = self.seleccionFactory().nuevoFuego()
			game.addVisual(fuego)
			fuegos.add(fuego)
		}
	}

	method quitar(elemento) {
		fuegos.remove(elemento)
		game.removeTickEvent("lanzar")
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

	method velocidad() { // metodo unico para los test
		return velocidad
	}

}

class EstadoLlevando {

	const property cambioEstado
	const property poseeArma

	method moverElemento(personaje)

	method cambiarEstado(personaje) {
		personaje.llevando(cambioEstado)
	}

	method accion(personaje) {
		personaje.armaDePersonaje().accion(personaje.ultimaDireccion())
	}

	method validarBalacera() {
	}

}

object llevada inherits EstadoLlevando(cambioEstado = libre, poseeArma = true) {

	override method moverElemento(personaje) {
		return personaje.armaDePersonaje().position(personaje.position())
	}

}

object libre inherits EstadoLlevando(cambioEstado = llevada, poseeArma = false) {

	override method moverElemento(personaje) {
	}

	override method validarBalacera() {
		self.error("No me esta llevando")
	}

}

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

	method eliminarDelTablero() { // Elimina fuego si supera valores fuera del mapa en eje X y eje y
		if (self.position().x() > 13 or self.position().x() < 1 or self.position().y() < 2) {
			self.eliminarSiEstoy()
		}
	}

	method estoyEnElTablero() {
		return game.hasVisual(self)
	}

	method eliminarSiEstoy() {
		if (self.estoyEnElTablero()) {
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

	method esUnArma() {
		return false // no es un arma es un proyectil
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

