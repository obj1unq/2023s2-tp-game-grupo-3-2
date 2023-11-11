import wollok.game.*
import personajePrincipal.*
import elementos.*

object derecha {

	method siguiente(posicion) {
		if (posicion.x() < 18) {
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

// Para ajustar el banear unicamente cambie la que abajo no pase de la segunda celda.
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
		if (posicion.y() < 18) {
			return posicion.up(1)
		} else {
			return posicion.up(0)
		}
	}

}

// Hay codigo repetido pero es una solucion, hay q mejorar.
// Esto nos permite jugar mas con los movimientos de los enemigos
// Ya que nosotros asignamos que tipo de movimiento tenga.
object movimientoLibre {

	const vertical = ejeY
	const horizontal = ejeX

	method mover(enemigo, personaje) {
		return if (not (horizontal.mismoEjeX(enemigo, personaje))) {
			horizontal.celdaX(enemigo, personaje)
		} else if (not (vertical.mismoEjeY(enemigo, personaje))) {
			vertical.celdaY(enemigo, personaje)
		}
	}

}

object movimientoVertical {

	const vertical = ejeY

	method mover(enemigo, personaje) {
		return if (not (vertical.mismoEjeY(enemigo, personaje))) {
			vertical.celdaY(enemigo, personaje)
		} else {
			enemigo.position()
		}
	}

}

object movimientoHorizontal {

	const horizontal = ejeX

	method mover(enemigo, personaje) {
		if (not (horizontal.mismoEjeX(enemigo, personaje))) {
			horizontal.celdaX(personaje)
		} else {
			enemigo.position()
		}
	}

}

object ejeY {

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

object ejeX {

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

