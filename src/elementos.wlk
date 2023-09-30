import wollok.game.*
import personajePrincipal.*
import direcciones.*

object antidoto {
	const property vidaOtorgada = 25
	
	method image() = "antidoto.png"
	
	method position() = game.center()
	
	method usado(personaje) {
		    personaje.tomarPocion(self)
		    game.removeVisual(self)
	}
	method mismaPosicion(personaje) {
		return self.position() == personaje.position()
	}
}
object espada {
	const property danio = 10
	var property position = game.at(3,3)
	
	method image() = "espada.png"
	
}
object arma {
	const property danio = 10
	var property position = game.at(3,9)
	
	method image() = "arma.png"
}
object bomba {
	const property danio = 10
	var property position = game.at(5,17)
	
	method image() = "bomba.png"
}
