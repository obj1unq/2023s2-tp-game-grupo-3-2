import wollok.game.*
import direcciones.*
import elementos.*
import zombies.*
import randomizer.*

object mago inherits Personaje {

	var property position = game.at(1, 2)
	const saludMaxima = 10
	var property llevando = libre
	var property armaDePersonaje = armaFuego

	method image() = "mago0.png"//llevando.imagenDePersonaje() + ".png"

	method irA(nuevaPosicion) {
		position = nuevaPosicion
		llevando.moverElemento(self)
	}

	method mover(direccion) {
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

	method aumentarDanio(danio) {
		armaDePersonaje.aumentarSuDanio(danio)
	}

	method agarrar() {
		self.validarPosition()
		llevando.cambiarEstado(self)
		//llevando.imagenFuego(armaDePersonaje)
	}
    
    method cambiarArma() {
    	 armaDePersonaje = game.uniqueCollider(self)
    }
    
    method lanzar() {
    	self.validarPosition()
    	llevando.lanzar(self)
    }
    
	method validarPosition() {
		if (position != armaDePersonaje.position()) {
			self.error("No estoy donde puedo hacerlo")
		}
	}

	method validarBalacera() {
		llevando.validarBalacera()
	}
    
    override method impactoDeLanza(elemento) {
		
	}
}

