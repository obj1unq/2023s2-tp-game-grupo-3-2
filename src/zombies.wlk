import wollok.game.*
import personajePrincipal.*
import direcciones.*
import elementos.*
import randomizer.*

class Personaje {
	
	var property vida = 10
	
	method morir()

	method impactoDeBala(elemento) {
		self.perderVida(elemento)
		game.removeVisual(elemento)
	}

	method perderVida(elemento) {
		vida -= elemento.danio()
		if (self.estaMuerto()) {
			self.morir()
		}
	}

	method estaMuerto() {
		return (vida <= 0)
	}
	method contacto(personaje){
		// agrege este mensaje por sino sale pantalla de error.
	}
}

class Zombie inherits Personaje {

	var property danio
	var property position
	const enemigo = mago
	const property rojo = "FF0000FF" // Color rojo
	const movimiento 
	method text() = self.vida().toString() + "/10"
	
	method mover(){
		position = movimiento.mover(self,enemigo)
	}
	
	method textColor() = self.rojo()

	override method morir() {
		self.soltarMoneda()
		ataqueZombie.quitar(self)
	}

	method soltarMoneda() {
		monedero.generarMoneda(self.position())
	}
	
	method atacar() {
		if (self.position() == enemigo.position()) {
			enemigo.perderVida(self)
		}
	}
}

class ZombieNormal inherits Zombie(danio = 1,movimiento = movimientoLibre) {


	method image() = "esqueleto1.png"


}

class ZombieGrande inherits ZombieNormal(position = game.at(17, randomizer.yCualquiera()),vida = 20,movimiento = movimientoVertical) {

	override method image() = "mago3.png"


	override method atacar() {
		const nuevaBala = new Fuego(position = self.position().left(1).up(1), imagenDisparo = charge, danio = danio)
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
			zombies.forEach({ zombie => zombie.mover()})
		}
	}

	method moverAZombieGrande(personaje) {
		if (cantidadZombieGrande.size() > 0) {
			cantidadZombieGrande.forEach({ zombie => zombie.mover()})
		}
	}

	method ataqueZombie() {
		if (zombies.size() > 0 or cantidadZombieGrande.size() > 0) {
			zombies.forEach({ zombie => zombie.atacar()})
			cantidadZombieGrande.forEach({ zombie => zombie.atacar()})
		}
	}

	method quitar(zombie) {
		zombies.remove(zombie)
		game.removeVisual(zombie)
	}

}

