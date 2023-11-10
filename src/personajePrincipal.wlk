import wollok.game.*
import direcciones.*
import elementos.*
import zombies.*
import randomizer.*

object soldado inherits Personaje {

	var property position = game.at(1, 2)
	const saludMaxima = 10
	var moneda = 0
	var property llevando = libre
	// Meter diferentes tipos de armas polimórficas
	var property armaDePersonaje = arma

	override method image() = llevando.imagenDePersonaje() + ".png"


	method validarBalacera() {
		llevando.validarBalacera()
	}

	method irA(nuevaPosicion) {
		position = nuevaPosicion
		llevando.moverElemento(self)
	}

	override method mover(direccion) {
		self.irA(direccion.siguiente(self.position()))
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
	
	method aumentarDanio(danio){
		armaDePersonaje.aumentarSuDanio(danio)
	}
//    method lanzar() {
//    	armaDePersonaje.disparar(derecha)
//    }
	method agarrar() {
		self.validarPosition()
		llevando.cambiarEstado(self)
		llevando.imagenFuego(armaDePersonaje)
	}


	method validarPosition() {
		if (position != armaDePersonaje.position()) {
			self.error("No estoy donde puedo hacerlo")
		}
	}

	method sumarMoneda(valor) {
		moneda += valor
	}

}

