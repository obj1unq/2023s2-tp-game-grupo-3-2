import wollok.game.*
import personajePrincipal.*
import elementos.*

object derecha {

	method siguiente(posicion) {
		if (posicion.x() < 14) { // Limite de mapa en eje X
			return posicion.right(1)
		} else {
			return posicion.right(0)
		}
	}

}

object izquierda {

	method siguiente(posicion) {
		if (posicion.x() > 0) {
			return posicion.left(1)
		} else {
			return posicion.left(0)
		}
	}

}

object abajo {

	method siguiente(posicion) {
		if (posicion.y() > 1) { // por eso tiene posicion 1.
			return posicion.down(1)
		} else {
			return posicion.down(0)
		}
	}

}

object arriba {

	method siguiente(posicion) {
		if (posicion.y() < 12) {
			return posicion.up(1)
		} else {
			return posicion.up(0)
		}
	}

}

class MovimientoLibreX {

	method mover(enemigo, personaje) {
		if (not (self.mismoEjeX(enemigo, personaje))) {
			self.irACeldaX(enemigo, personaje)
		} else if (not (self.mismoEjeY(enemigo, personaje))) {
			self.irACeldaY(enemigo, personaje)
		}
	}

	method irACeldaY(enemigo, personaje) {
		enemigo.position(self.celdaY(enemigo, personaje))
	}

	method mismoEjeY(enemigo, personaje) {
		return enemigo.position().y() == personaje.position().y()
	}

	method celdaY(enemigo, personaje) {
		return if (personaje.position().y() > enemigo.position().y()) {
			self.moverArribaColisionY(enemigo, personaje)
		} else {
			self.moverAbajoColisionY(enemigo, personaje)
		}
	}

	method irACeldaX(enemigo, personaje) {
		enemigo.position(self.celdaX(enemigo, personaje))
	}

	method mismoEjeX(enemigo, personaje) {
		return enemigo.position().x() == personaje.position().x()
	}

	method celdaX(enemigo, personaje) {
		return if (personaje.position().x() > enemigo.position().x()) {
			self.moverDerechaColisionX(enemigo, personaje)
		} else {
			self.moverIzquierdaColisionX(enemigo, personaje)
		}
	}

	// Es mucho codigo repetido, 
	method moverDerechaColisionX(enemigo, personaje) {
		const posicion = enemigo.position().right(1)
		return if (not tablero.puedeOcupar(posicion)) {
			self.celdaY(enemigo, personaje)
		} else {
			posicion
		}
	}

	method moverIzquierdaColisionX(enemigo, personaje) {
		const posicion = enemigo.position().left(1)
		return if (not tablero.puedeOcupar(posicion)) {
			self.celdaY(enemigo, personaje)
		} else {
			posicion
		}
	}

	// Al chocar con algo en el ejeY cambia su estado y lo persegui por el EjeY
	method moverArribaColisionY(enemigo, personaje) {
		const posicion = enemigo.position().up(1)
		return if (not tablero.puedeOcupar(posicion)) {
			enemigo.movimiento(movimientoLibreY)
			self.celdaX(enemigo, personaje)
		} else {
			posicion
		}
	}

	method moverAbajoColisionY(enemigo, personaje) {
		const posicion = enemigo.position().down(1)
		return if (not tablero.puedeOcupar(posicion)) {
			enemigo.movimiento(movimientoLibreY)
			self.celdaX(enemigo, personaje)
		} else {
			posicion
		}
	}

}

object movimientoLibreY inherits MovimientoLibreX {

	const movimientoX = new MovimientoLibreX()

	override method mover(enemigo, personaje) {
		if (not (self.mismoEjeY(enemigo, personaje))) {
			self.irACeldaY(enemigo, personaje)
		} else if (not (self.mismoEjeX(enemigo, personaje))) {
			self.irACeldaX(enemigo, personaje)
		}
	}

	override method moverDerechaColisionX(enemigo, personaje) {
		const posicion = enemigo.position().right(1)
		return if (not tablero.puedeOcupar(posicion)) {
			enemigo.movimiento(movimientoX)
			self.celdaY(enemigo, personaje)
		} else {
			posicion
		}
	}

	override method moverIzquierdaColisionX(enemigo, personaje) {
		const posicion = enemigo.position().left(1)
		return if (not tablero.puedeOcupar(posicion)) {
			enemigo.movimiento(movimientoX)
			self.celdaY(enemigo, personaje)
		} else {
			posicion
		}
	}

	// Se sobrescribe para que no cambie el estado del movimiento del personaje.
	override method moverArribaColisionY(enemigo, personaje) {
		const posicion = enemigo.position().up(1)
		return if (not tablero.puedeOcupar(posicion)) {
			self.celdaX(enemigo, personaje)
		} else {
			posicion
		}
	}

	override method moverAbajoColisionY(enemigo, personaje) {
		const posicion = enemigo.position().down(1)
		return if (not tablero.puedeOcupar(posicion)) {
			self.celdaX(enemigo, personaje)
		} else {
			posicion
		}
	}

}

object movimientoVertical {

	method mover(enemigo, personaje) {
		return if (not (self.mismoEjeY(enemigo, personaje))) {
			self.irACeldaY(enemigo, personaje)
		} else {
			enemigo.position()
		}
	}

	method irACeldaY(enemigo, personaje) {
		enemigo.position(self.celdaY(enemigo, personaje))
	}

	method mismoEjeY(enemigo, personaje) {
		return enemigo.position().y() == personaje.position().y()
	}

	method celdaY(enemigo, personaje) {
		return if (personaje.position().y() > enemigo.position().y()) {
			enemigo.position().up(1)
		} else {
			enemigo.position().down(1)
		}
	}

}
object movimientoHorizontal {
	
	method mover(enemigo, personaje) {
		return if (not (self.mismoEjeX(enemigo, personaje))) {
			self.irACeldaX(enemigo, personaje)
		} else {
			enemigo.position()
		}
	}

	method irACeldaX(enemigo, personaje) {
		enemigo.position(self.celdaX(enemigo, personaje))
	}

	method mismoEjeX(enemigo, personaje) {
		return enemigo.position().x() == personaje.position().x()
	}

	method celdaX(enemigo, personaje) {
		return if (personaje.position().x() > enemigo.position().x()) {
			enemigo.position().right(1)
		} else {
			enemigo.position().left(1)
		}
	}	
}
object movimientoNulo {

	method mover(enemigo, personaje) {
	// sirve para que el enemigo de Soporte este quieto
	}

}

object tablero {

	method pertenece(position) {
		return position.x().between(0, game.width() - 1) and position.y().between(0, game.height() - 1)
	}

	method puedeOcupar(position) {
		return self.pertenece(position) and not self.haySolido(position)
	}

	method haySolido(position) {
		return game.getObjectsIn(position).any({ elemento => elemento.solido() })
	}

}

