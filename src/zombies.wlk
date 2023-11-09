import wollok.game.*
import personajePrincipal.*
import direcciones.*
import elementos.*
import randomizer.*

class Personaje inherits Elemento(danio = 1) {

	var property vida = 10


	method position()

	method mover(personaje)

	method morir()

	override method impactoDeBala(elemento) {
		self.perderVida(elemento)
		game.removeVisual(elemento)
	}

	override method perderVida(personaje) {
		vida -= personaje.danio()
		if (self.estaMuerto()) {
			self.morir()
		}
	}

	method estaMuerto() {
		return (vida <= 0)
	}

	method atacar(enemigo) {
		if (self.position() == enemigo.position()) {
			enemigo.perderVida(self)
		}
	}

}

class Zombie inherits Personaje {

	const enemigo = soldado
	const property rojo = "FF0000FF" // Color rojo

	method text() = self.vida().toString() + "/10"

	method textColor() = self.rojo()

	override method mover(personaje) {
		if (not (self.mismoEjeX(personaje))) {
			self.irACeldaX(personaje)
		} else if (not (self.mismoEjeY(personaje))) {
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
		self.soltarMoneda()
		ataqueZombie.quitar(self)
	}

	method atacarSoldado() {
		self.atacar(enemigo)
	}

	method soltarMoneda() {
		monedero.generarMoneda(self.position())
	}

}

class ZombieNormal inherits Zombie {

	var property position

	override method irACeldaY(personaje) {
		position = self.subirOBajar(personaje)
	}

	override method image() = "esqueleto1.png"

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

class ZombieGrande inherits ZombieNormal(position = game.at(17, randomizer.yCualquiera())) {

	override method image() = "mago3.png"

	override method mover(personaje) {
		if (not (self.mismoEjeY(personaje))) {
			self.irACeldaY(personaje)
		}
	}

	override method atacarSoldado() {
		const nuevaBala = new Bala(position = self.position().left(1).up(1), imagenDisparo = charge, danio = 2)
		nuevaBala.disparar(izquierda)
	}

	override method morir() {
		super()
		game.removeTickEvent("MORDER")
	}

}

object ataqueZombie {

	var property zombies = []
	const cantidadMaxima = 3
	const cantidadZombieGrande = []

	method generarZombiesNormales() {
		if (zombies.size() < cantidadMaxima) {
			const nuevoZombi = new ZombieNormal(position = game.at(18, randomizer.yCualquiera()))
			game.addVisual(nuevoZombi)
			zombies.add(nuevoZombi)
		}
	}

	method generarZombieGrande() {
		if (monedero.cantidadMonedas() > 10 and cantidadZombieGrande.size() < 1) {
			game.removeTickEvent("HORDA")
			const zombiGrande = new ZombieGrande()
			game.addVisual(zombiGrande)
			cantidadZombieGrande.add(zombiGrande)
		}
	}

	method moverALosZombies(personaje) {
		if (zombies.size() > 0) {
			zombies.forEach({ zombie => zombie.mover(personaje)})
		}
	}

	method moverAZombieGrande(personaje) {
		if (cantidadZombieGrande.size() > 0) {
			cantidadZombieGrande.forEach({ zombie => zombie.mover(personaje)})
		}
	}

	method ataqueZombie() {
		if (zombies.size() > 0 or cantidadZombieGrande.size() > 0) {
			zombies.forEach({ zombie => zombie.atacarSoldado()})
			cantidadZombieGrande.forEach({ zombie => zombie.atacarSoldado()})
		}
	}

	method quitar(zombie) {
		zombies.remove(zombie)
		game.removeVisual(zombie)
	}

}

