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

	method image() = "mago0.png"

	method irA(nuevaPosicion) {
		position = nuevaPosicion
		llevando.moverElemento(self)
	}

	method mover(direccion) {
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

	method agarrar() {
		self.validarPosition()
		llevando.cambiarEstado(self)
		//armaDePersonaje.cambioVisualArma(llevando)
	}

	method cambiarArma() {
		const objetos = game.colliders(self)
		if (not objetos.isEmpty() and objetos.all({ o => o.esUnArma() })) {
			armaDePersonaje = objetos.find({ arma => arma.esUnArma() })
		}
	}

//	method lanzar() { esto ya no sirve
//		self.validarPosition()
//		llevando.lanzar(self)
//	}

	method validarPosition() {
		if (position != armaDePersonaje.position()) {
			self.error("No estoy donde puedo hacerlo")
		}
	}

//	method validarBalacera() { ahora solamente necesita saber si tiene el arma encima
//		llevando.validarBalacera()
//	}

	method tirarHechizo() {
		self.validarPosition()
		llevando.accion(self)
	}

	override method impactoDeLanza(elemento) {
	}

}

