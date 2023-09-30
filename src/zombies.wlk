import wollok.game.*
import personajePrincipal.*
import direcciones.*
import elementos.*
import randomizer.*

class Zombie {

	var property position 
	var property vida = 100
	var property danio = 1
	const property rojo = "FF0000FF" // Color rojo

	method text() = self.vida().toString() + "/100"

	method textColor() = self.rojo()

	method image() = "zombie.png"

	method mover(personaje) {
		if (not (self.mismoEjeY(personaje))) {
			self.irACeldaY(personaje)
		} else if (not (self.mismoEjeX(personaje))) {
			self.irACeldaX(personaje)
		}
	}

	method mismoEjeY(personaje) {
		return self.position().y() == personaje.position().y()
	}

	method irACeldaY(personaje) {
		position = self.subirOBajar(personaje)
	}

	method subirOBajar(personaje) {
		return if (personaje.position().y() > self.position().y()) {
			self.position().up(1)
		} else {
			self.position().down(1)
		}
	}

	method mismoEjeX(personaje) {
		return self.position().x() == personaje.position().x()
	}

	method mismaPosicion(personaje) {
		return self.position() == personaje.position()
	}

	method irACeldaX(personaje) {
		position = self.izqODerecha(personaje)
	}

	method izqODerecha(personaje) {
		return if (personaje.position().x() > self.position().x()) {
			self.position().right(1)
		} else {
			self.position().left(1)
		}
	}

	method morir() {
		game.removeVisual(self)
		game.removeTickEvent("Morder")
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

	method atacar(enemigo) {
		if (self.mismaPosicion(enemigo)) {
	        enemigo.perderVida(self)	
		}
	}
	method atacarSoldado() { 
		const soldaditos = game.colliders(self)
	    soldaditos.forEach({soldadillo => self.atacar(soldadillo) }) 
	}
	method impactoDeBala(bala) {
    	self.perderVida(bala)
    }

}

object ataqueZombie {
	var property zombies = []
	const cantidadMaxima = 5

	method generarZombies() {
		if (zombies.size() <= cantidadMaxima) {
			const nuevoZombi = new Zombie(position = game.at(18,randomizer.yCualquiera() ) )
			game.addVisual(nuevoZombi)
			zombies.add(nuevoZombi)
		}
	}
	method moverALosZombies(personaje) {
		if (zombies.size() > 0) {
			zombies.forEach({ zombie => zombie.mover(personaje)})
		}
	}
	method ataqueZombie(personaje) {
		if (zombies.size() > 0) {
			zombies.forEach({ zombie => zombie.atacar(personaje)})
		}
	}
}