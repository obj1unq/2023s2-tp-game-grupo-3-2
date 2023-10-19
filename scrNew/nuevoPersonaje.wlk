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

}

object guerrero inherits Personaje (limiteSalud = 10, salud = 5, danio = 40) {

}

object arquero inherits Personaje (limiteSalud = 5, salud = 5, danio = 35) {

}

object mago inherits Personaje (limiteSalud = 5, salud = 5, danio = 30) {

}

