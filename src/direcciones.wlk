import wollok.game.*
import personajePrincipal.*
import elementos.*

object derecha {
	method siguiente(posicion) {
		if (posicion.x() < 18 ) {
		    return posicion.right(1)
	    }else {
	    	return posicion.right(0)
	    }
	}	
}
object izquierda {
	method siguiente(posicion) {
		if (posicion.x() > 0 ) {
		    return posicion.left(1)
		}else {
			return posicion.left(0)
		}
	}
}
object abajo {
	method siguiente(posicion) {
		if (posicion.y() > 0 ) {
		    return posicion.down(1)
		}else {
			return posicion.down(0)
		}
	}
}
object arriba {
	method siguiente(posicion) {
		if (posicion.y() < 18 ) {
		    return posicion.up(1)
		}else {
			return posicion.up(0)
		}
	}
}
