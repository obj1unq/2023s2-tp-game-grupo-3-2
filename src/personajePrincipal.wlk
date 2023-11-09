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
	var property armaDePersonaje = arma

	override method image() = llevando.imagenDePersonaje() + ".png"

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

	method validarVidaMaxima() {
		if (vida > saludMaxima) {
			vida = saludMaxima
		}
	}

	method aumentarVida(_vida) {
		vida += _vida
		self.validarVidaMaxima()
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

	/*
	 *  method llevarLaPelota(pelota) {
	 *     self.validarTieneLaPelota(pelota)
	 *     if (pelotaEnMano != null) {
	 *       self.soltarPelota(pelotaEnMano)
	 *     }
	 *     llevando.cambiarEstado(self, pelota)
	 *     pelotaEnMano = pelota
	 *   }
	 */
	method validarPosition() {
		if (position != armaDePersonaje.position()) {
			self.error("No estoy donde puedo hacerlo")
		}
	}

	method sumarMoneda(valor) {
		moneda += valor
	}

}

