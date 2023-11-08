import wollok.game.*
import direcciones.*
import elementos.*
import zombies.*
import randomizer.*

object soldado inherits Personaje {

	var property position = game.at(1, 0)
	const saludMaxima = 10
	var moneda = 0
	var imagenPersonaje = 0
	var property llevando = libre
	var property armaDePersonaje = arma

	override method image() = "mago" + imagenPersonaje.toString() + ".png"

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
		vida += pocion.vidaOtorgada()
		self.validarVidaMaxima()
	}
	/*
	method agarrarElemento() {
		game.onCollideDo(self,{elemento => elemento.usado(self)})
	}
	 */
	method validarVidaMaxima() {
		if (vida > saludMaxima) {
			vida = saludMaxima
		}
	}
//    method lanzar() {
//    	armaDePersonaje.disparar(derecha)
//    }

	method agarrar() {
		self.validarPosition()
		llevando.cambiarEstado(self)
	}
	/*
	 method llevarLaPelota(pelota) {
    self.validarTieneLaPelota(pelota)
    if (pelotaEnMano != null) {
      self.soltarPelota(pelotaEnMano)
    }
    llevando.cambiarEstado(self, pelota)
    pelotaEnMano = pelota
  }
	 */

	method validarPosition() {
		if (position != armaDePersonaje.position()) {
			self.error("No estoy donde puedo hacerlo")
		}
	}

	method imagenPersonaje(numeroImagen) {
		imagenPersonaje = numeroImagen
	}
	
	method sumarMoneda(valor) {
		moneda += valor
	}

}

