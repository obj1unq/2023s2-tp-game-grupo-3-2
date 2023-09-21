import wollok.game.*
import personajes.*
import direcciones.*
import elementos.*

object zombie1 {
	
	var property position = game.at(10,10)
	
	var property vida = 10 // Falta mostrar la vida del zombie
	
	var property danio = 50 
	
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
	method mismaPosicion(personaje) {
		return self.position() == personaje.position()
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
	method morir(){
		game.removeVisual(self)
	}
	method estaMuerto() {
		return (vida <= 0) 
	}
	method perderVida(personaje) {
		vida -= personaje.danio()
		if (self.estaMuerto()) {
			self.morir()
		}
	}
	method atacar(enemigo){
		if (self.mismaPosicion(enemigo)){
			enemigo.perderVida(self)
		}
	}
}