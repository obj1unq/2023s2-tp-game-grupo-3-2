import wollok.game.*
import direcciones.*
import elementos.*

object soldado {

	var property position = game.origin()
	var property salud = 5
	const property saludMaxima = 5
	var property danio = 20

	method image() = "soldado.png"

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

	method tomarPocion(pocion) { // Funciona pero falta mejorar
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
		if (salud > saludMaxima) {
			salud = saludMaxima
		}
	}
	method impactoDeBala(bala) {
		
	}
	method agarrar(elemento) {
		self.validarPosition(elemento)
		elemento.serLlevada(self)
	}
	method validarPosition(algo) {
		if(position != algo.position()) {
			self.error("No estoy donde puedo hacerlo")
		}
	}
	

}

object corazonesSoldado {

// Achicar tamaño de corazones
	const property position = game.at(1, 0)

	method image() = "corazon" + soldado.salud().toString() + ".png"

}

