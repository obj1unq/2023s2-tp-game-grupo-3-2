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

	method contacto(personaje) {
	// agrege este mensaje por sino sale pantalla de error.
	}

	method impactoDeLanza(elemento) {
		self.perderVida(elemento)
		game.removeVisual(elemento)
	}
    method solido() {
		return false
	}
}

class Zombie inherits Personaje {

	var property danio
	const danioMax = 4
	var property position
	const enemigo = mago
	const property rojo = "FF0000FF" // Color rojo
	const movimiento
	var moverActual = 2000
	const moverMax = 1000

	method text() = self.vida().toString() + "/10"

	method mover() {
		movimiento.mover(self, enemigo)
	}

	method textColor() = self.rojo()

	override method morir() {
		self.soltarMoneda()
		ataqueZombie.quitar(self)
		game.removeTickEvent("PERSEGUIR" + self.identity())
	}

	method soltarMoneda() {
		monedero.generarMoneda(self.position())
	}

	method atacar() {
		if (self.position() == enemigo.position()) {
			enemigo.perderVida(self)
		}
	}

	// Cada zombie tiene su propio onTick para moverse,y asi poder modificar.
	method generarOnTicksPerseguir() {
		game.onTick(moverActual, "PERSEGUIR" + self.identity(), { self.mover()})
	}

	// Metodo donde aumenta el movimiento del movimiento.
	method aumentarMovimientoYAtaque(decreser, _danio) {
		game.removeTickEvent("PERSEGUIR" + self.identity())
		const tiempoActual = (moverActual - decreser).max(moverMax)
		game.onTick(tiempoActual, "PERSEGUIR" + self.identity(), { self.mover()})
		danio = (danio + _danio).min(danioMax)
	}
	method esUnArma() {
		return false
	}

}

class ZombieNormal inherits Zombie(danio = 1, movimiento = movimientoLibre) {

	method image() = "esqueleto1.png"

}

class ZombieGrande inherits ZombieNormal(position = game.at(13, randomizer.yCualquiera()), vida = 20, movimiento = movimientoVertical) {

	override method image() = "mago3.png"

	override method atacar() {
		const nuevaBala = new Fuego(position = self.position().left(1), imagenDisparo = charge, danio = danio)
		nuevaBala.disparar(izquierda)
	}

	override method morir() {
		super()
		game.removeTickEvent("MORDER")
	}

}

// Por el momento es unico para probar su funcionamiento
object zombieSoporte inherits Zombie(position = game.at(10, 10), danio = 1, movimiento = movimientoNulo) {

	const reducirTiempoMovimiento = 100
	const aumentarDanio = 1

	method image() = "esqueleto2.png"

	// Debe conocer los zombies en el mapa directamente para aplicarle su efecto especial.
	// No es correcto el usar el metodo ataque pero es algo a mejorar.
	override method atacar() {
		ataqueZombie.zombies().forEach({ zombie => zombie.aumentarMovimientoYAtaque(reducirTiempoMovimiento, aumentarDanio)})
	}

	// Metodo utilizado unicamente en los tests.
	method pruebaAtacar(enemigo) {
		enemigo.aumentarMovimientoYAtaque(reducirTiempoMovimiento, aumentarDanio)
	}

}

object ataqueZombie {
	 // hay que hacer el que lanza fuego sea un enemigo normal asi tambien sirve el zombieSoporte.
	var property zombies = []
	const cantidadMaxima = 3
	const cantidadZombieGrande = []

	method generarZombiesNormales() {
		if (zombies.size() < cantidadMaxima) {
			const nuevoZombi = new ZombieNormal(position = game.at(15, randomizer.yCualquiera()))
			game.addVisual(nuevoZombi)
			zombies.add(nuevoZombi)
			nuevoZombi.generarOnTicksPerseguir()
		}
	}
	// haciendo que sea un enemigo mas nos ahorramos codigo repitido.
	method generarZombieGrande() {
		if (monedero.cantidadMonedas() > 10 and cantidadZombieGrande.size() < 1) {
			game.removeTickEvent("HORDA")
			const zombiGrande = new ZombieGrande()
			game.addVisual(zombiGrande)
			cantidadZombieGrande.add(zombiGrande)
			zombiGrande.generarOnTicksPerseguir()
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

