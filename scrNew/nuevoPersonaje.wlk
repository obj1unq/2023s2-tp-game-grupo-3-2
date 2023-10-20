import wollok.game.*
import nuevoDirecciones.*

class Personaje {

	var salud
	var danio
	var property position = game.origin()
	const limiteSalud
	const mapa = tablero
	const danioCuerpo = 3

	method image() {
		return "" + self + "" + 1 + ".png"
	}

	method mover(direccion) {
		const nuevaPosicion = direccion.siguiente(self.position())
		self.validarMover(nuevaPosicion)
		self.irA(nuevaPosicion)
	}

	method irA(nuevaPosicion) {
		position = nuevaPosicion
	}

	method validarMover(direccion) {
		if (not mapa.puedeOcupar(direccion)) {
			self.error("No puedo ir hacia ahi.")
		}
	}

	method atacarCuerpoACuerpo() {
		const enemigos = game.colliders(self)
		enemigos.forEach({ enemigo => self.daniar(enemigo)})
	}

	method daniar(enemigo) {
		enemigo.perderVida(danioCuerpo)
	}

	method atacar()

}

object guerrero inherits Personaje (limiteSalud = 10, salud = 5, danio = 40) {

	override method atacar() {
	}

}

object arquero inherits Personaje (limiteSalud = 5, salud = 5, danio = 35) {

	override method atacar() {
		const nuevaBala = new Flecha(position = self.position().right(1))
		nuevaBala.disparar()
	}

}

object mago inherits Personaje (limiteSalud = 5, salud = 5, danio = 30) {

	override method atacar() {
	}

}

class Flecha {

	const property danio = 5
	var property position

	method image() =  "Flecha.png"

	method disparar() {
		game.addVisual(self)
		game.onTick(150, "disparar", { self.avanzar()})
		game.onCollideDo(self, { enemigo => enemigo.impacto(self)})
		
	}

	method avanzar() {
		position = self.position().right(1)
	}

	

}

