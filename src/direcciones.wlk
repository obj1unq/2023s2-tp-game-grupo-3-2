import wollok.game.*
import personajes.*
import zombies.*
import elementos.*

object derecha {
	method siguiente(posicion) {
		return posicion.right(1)
	}	
}
object izquierda {
	method siguiente(posicion) {
		return posicion.left(1)
	}
}
object abajo {
	method siguiente(posicion) {
		return posicion.down(1)
	}
}
object arriba {
	method siguiente(posicion) {
		return posicion.up(1)
	}
}
