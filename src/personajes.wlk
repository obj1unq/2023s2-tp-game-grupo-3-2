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
	
	var property position = game.at(17,17)
	
	method image() = "zombie.png"
	
	method mover(personaje){
		if (not (self.mismoEjeY(personaje))){
		 self.irACeldaY(personaje)
		}else if (not (self.mismoEjeX(personaje))){
			self.irACeldaX(personaje) 
		} 
	} 
	method mismoEjeY(personaje){
		return self.position().y() == personaje.position().y()
	}
	method irACeldaY(personaje){
		position = self.subirOBajar(personaje)
	}
	method subirOBajar(personaje){
		return if (personaje.position().y() > self.position().y()){
			self.position().up(1)			
		} else {
			self.position().down(1)
		}
	}
	method mismoEjeX(personaje){
		return self.position().x() == personaje.position().x()
	}
	method irACeldaX(personaje){
		position = self.izqODerecha(personaje)
	}
	method izqODerecha(personaje){
		return if (personaje.position().x() > self.position().x()){
			self.position().right(1)			
		} else {
			self.position().left(1)
		}
	}
}