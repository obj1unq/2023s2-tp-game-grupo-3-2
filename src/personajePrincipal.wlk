import wollok.game.*
import direcciones.*
import elementos.*
import zombies.*
import randomizer.*
import armas.*
import mapa.*

object mago inherits Personaje {

	var property position = game.at(1, 2)
	const saludMaxima = 10
	var property llevando = libre
	var property armaDePersonaje = armaFuego
	var property ultimaDireccion = null

	method image() = "mago0.png"

	method irA(nuevaPosicion) {
		position = nuevaPosicion
		llevando.moverElemento(self)
	}

	method mover(direccion) {
		ultimaDireccion = direccion
		if (self.sePuedeMover(direccion)) {
			// self.validarMover(direccion)
			const proxima = direccion.siguiente(self.position())
			self.irA(proxima)
		}
	}

	method puedeOcupar(posicion) {
		return tablero.puedeOcupar(posicion)
	}

	method sePuedeMover(direccion) {
		const proxima = direccion.siguiente(self.position())
		return self.puedeOcupar(proxima)
	}

	method validarMover(direccion) {
		if (not self.sePuedeMover(direccion)) {
			self.error("no puedo ir ahi")
		}
	}

	override method morir() {
		game.stop()
	}

	method tomarPocion(pocion) {
		pocion.efectoPocion(self)
	}

	method aumentarVida(_vida) {
		vida = (vida + _vida).min(saludMaxima)
	}

	method aumentarDanio(danio) {
		armaDePersonaje.aumentarSuDanio(danio)
	}

	method aumentarVelocidadArma(velocidad) {
		armaDePersonaje.aumentarSuVelocidad(velocidad)
	}

	method agarrar() {
		self.validarPosition()
		llevando.cambiarEstado(self)
	// armaDePersonaje.cambioVisualArma(llevando)
	}

	method cambiarArma() {
		const objetos = game.colliders(self)
		if (not objetos.isEmpty() and objetos.all({ o => o.esUnArma() })) {
			armaDePersonaje = objetos.find({ arma => arma.esUnArma() })
		}
	}

	method validarPosition() {
		if (position != armaDePersonaje.position()) {
			self.error("No estoy donde puedo hacerlo")
		}
	}

	method tirarHechizo() {
		self.validarPosition()
		llevando.accion(self)
	}

	override method impactoDeFuego(elemento) {
	}

}

