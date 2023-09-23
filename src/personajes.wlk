import wollok.game.*
import direcciones.*
import zombies.*
import elementos.*

object soldado {

	var property position = game.origin()
	var property vida = 100
	const property vidaMaxima = 100
	var property danio = 20
	const property verde = "00FF00FF" // Color verde

	method text() = self.vida().toString() + "/100"

	method textColor() = paletaColores.verde()

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
		return (vida <= 0)
	}

	method perderVida(personaje) {
		vida -= personaje.danio()
		if (self.estaMuerto()) {
			self.morir()
		}
	}

	method tomarPocion(pocion) { // Funciona pero falta mejorar
	    if (self.mismaPosicion(pocion)) {
		    vida += pocion.vidaOtorgada()
		}
		self.validarVidaMaxima()
	}
    method tomarPosion() {
    	const pocion = game.uniqueCollider(self)
	    pocion.usado(self) 
    }
	method validarVidaMaxima() {
		if (vida > vidaMaxima) {
			vida = vidaMaxima
		}
	}
}

object paletaColores {

	const property verde = "00FF00FF"
	const property rojo = "FF0000FF"

}

