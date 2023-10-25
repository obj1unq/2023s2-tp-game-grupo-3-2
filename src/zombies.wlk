import wollok.game.*
import personajePrincipal.*
import direcciones.*
import elementos.*
import randomizer.*

class Personaje inherits Elemento {
	var property vida = 5
	var property danio = 1
	
	method position()
	
	method mover(personaje)
	
	method morir()
	
	method perderVida(personaje) {
		vida -= personaje.danio()
		if (self.estaMuerto()) {
			self.morir()
		}
	}
	method estaMuerto() {
		return (vida <= 0)
	}
	
	method atacar(enemigo) {
		if(self.position() == enemigo.position()) {
		enemigo.perderVida(self)
		}
	}
}
class Zombie inherits Personaje {
    
	const property rojo = "FF0000FF" // Color rojo

	method text() = self.vida().toString() + "/100"

	method textColor() = self.rojo()

	override method image() = "esqueleto1.png"

	override method mover(personaje) {
	    if (not (self.mismoEjeX(personaje))) {
			self.irACeldaX(personaje)
		}else if (not (self.mismoEjeY(personaje))) {
			self.irACeldaY(personaje)
	    }
	}

	method mismoEjeY(personaje) {
		return self.position().y() == personaje.position().y()
	}
    method irACeldaY(personaje)
	
	method mismoEjeX(personaje) {
		return self.position().x() == personaje.position().x()
	}

	method irACeldaX(personaje) 

	override method morir() {
		game.removeVisual(self)
	}
	
	method atacarSoldado() { 
		const soldaditos = game.colliders(self)
	    soldaditos.forEach({soldadillo => self.atacar(soldadillo) }) 
	}
	override method chocasteCon(elemento) {
    	self.perderVida(elemento)
    }
   
}
class ZombieNormal inherits Zombie {
	var property position
	
	override method irACeldaY(personaje) {
		position = self.subirOBajar(personaje)
	}
	 method subirOBajar(personaje) {
		return if (personaje.position().y() > self.position().y()) {
			self.position().up(1)
		} else {
			self.position().down(1)
		}
	}
	
	override method irACeldaX(personaje) {
		position = self.izqODerecha(personaje)
	}
	method izqODerecha(personaje) {
		return if (personaje.position().x() > self.position().x()) {
			self.position().right(1)
		} else {
			self.position().left(1)
		}
	}
}
object ataqueZombie {
	var property zombies = []
	const cantidadMaxima = 3

	method generarZombiesNormales() {
		if (zombies.size() < cantidadMaxima) {
			const nuevoZombi = new ZombieNormal(position = game.at(18,randomizer.yCualquiera()) )
			game.addVisual(nuevoZombi)
			zombies.add(nuevoZombi)
		}
	}
	method moverALosZombies(personaje) {
		if (zombies.size() > 0) {
			zombies.forEach({ zombie => zombie.mover(personaje)})
		}
	}
	method ataqueZombie() {
		if (zombies.size() > 0) {
			zombies.forEach({ zombie => zombie.atacarSoldado()})
		}
	}
}