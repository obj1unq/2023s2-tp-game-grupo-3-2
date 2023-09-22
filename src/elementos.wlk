import wollok.game.*
import personajes.*
import direcciones.*

object antidoto {
	const property vidaOtorgada = 25
	
	method image() = "antidoto.png"
	
	method position() = game.center()
	
	method usado(personaje) {
		personaje.tomarPocion(vidaOtorgada)
		game.removeVisual(self)
	}
}
