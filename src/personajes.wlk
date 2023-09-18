import wollok.game.*
import direcciones.*

object soldado {
	var property position = game.origin()
	
	method image() = "soldado.png"
	
	method irA(nuevaPosicion) {
		position = nuevaPosicion
	}
	method mover(direccion) {
		self.irA(direccion.siguiente(self.position()) )
	}
}
object zombie {
	
	method image() = "zombie.png"
	
	method position() = game.at(soldado.position().x(),17)
}