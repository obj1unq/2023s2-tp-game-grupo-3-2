import wollok.game.*
import direcciones.*
import elementos.*
import zombies.*
import randomizer.*

object soldado {

	var property clase = arquero // Falta automatizar la selección de clase al inicio del juego
	var property position = game.origin()
	var property salud = clase.salud()
	var property danio = clase.danio()
	var property saludMaxima = clase.saludMaxima()

	method image() = clase.image() // Buscar imagenes de guerrero, mago y arquero 

	method irA(nuevaPosicion) {
		position = nuevaPosicion
	}

	method mover(direccion) {
		self.irA(direccion.siguiente(self.position()))
	}

	method atacarZombie() { // esto tendria que estar en el objeto arma 
		const zombies = game.colliders(self)
		zombies.forEach({ zombie => self.atacar(zombie)})
	}

	method mismaPosicion(personaje) {
		return self.position() == personaje.position()
	}

	method atacar(enemigo) {
		if (self.mismaPosicion(enemigo)) {
			enemigo.perderVida(self)
		}
	}

	method morir() {
		game.stop()
	}

	method estaMuerto() {
		return (salud <= 0)
	}

	method perderVida(personaje) {
		salud -= personaje.danio()
		if (self.estaMuerto()) {
			self.morir()
		}
	}

	method tomarPocion(pocion) {
		if (self.mismaPosicion(pocion)) {
			salud += pocion.vidaOtorgada()
		}
		self.validarVidaMaxima()
	}

	method tomarPosion() {
		const pocion = game.uniqueCollider(self)
		pocion.usado(self)
	}

	method validarVidaMaxima() {
		if (salud > self.saludMaxima()) {
			salud = self.saludMaxima()
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

object corazonesSoldado {

// Falta agregar 10 corazones para el guerrero
	const property position = game.at(1, 0)

	method image() = "corazon" + soldado.salud().toString() + ".png"

}

