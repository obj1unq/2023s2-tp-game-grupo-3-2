import wollok.game.*
import direcciones.*
import elementos.*
import zombies.*
import randomizer.*

object soldado inherits Personaje {
	
    var property position = game.at(1,0)
	const  saludMaxima = 5
	var property monedas = 0
	
	override method image() = "mago1.png"

	method irA(nuevaPosicion) {
		position = nuevaPosicion
	}

     override method mover(direccion) {
		self.irA(direccion.siguiente(self.position()))
	}

	//method atacarZombie() { // esto tendria que estar en el objeto espada 
	//	const zombies = game.colliders(self)
		//zombies.forEach({ zombie => self.atacar(zombie)})
	//}

	
	override method morir() {
		game.stop()
	}
    method tomarPocion(pocion) {
		vida += pocion.vidaOtorgada()
		self.validarVidaMaxima()
	}
	method agarrarElemento(){
		 game.onCollideDo(self, { elemento => elemento.usado(self) })
	}
	method validarVidaMaxima() {
		if (vida > saludMaxima) {
			vida = saludMaxima
		}
	}

	method impactoDeBala(bala) {
	}

	method agarrar(elemento) {
		self.validarPosition(elemento)
		elemento.serLlevada(self)
	}

	method validarPosition(algo) {
		if (position != algo.position()) {
			self.error("No estoy donde puedo hacerlo")
		}
	}

}

class Clase {

	method image()

}

object guerrero inherits Clase {

	// Ataque a corta distancia
	var property saludMaxima = 10
	var property salud = 10
	var property danio = 40

	override method image() {
		return "guerrero1.png"
	}

}

object mago inherits Clase {

	// Ataque a media distancia
	var property saludMaxima = 5
	var property salud = 5
	var property danio = 30

	override method image() {
		return "mago1.png"
	}

}

object arquero inherits Clase {

	// Ataque a distancia
	var property saludMaxima = 5
	var property salud = 5
	var property danio = 35

	override method image() {
		return "arquero1.png"
	}

}



