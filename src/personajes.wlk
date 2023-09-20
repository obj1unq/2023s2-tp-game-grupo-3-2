import wollok.game.*
import direcciones.*

object soldado {
	var property position = game.origin()
	
	var property vida = 100 // Falta mostrar la vida del soldado
	
	var property danio = 5
	
	var property rangoAtacarNorte = position.y()+1
	var property rangoAtacarEste  = position.x()+1
	var property rangoAtacarSur   = position.y()-1
	var property rangoAtacarOeste = position.x()-1
	
	method image() = "soldado.png"
	
	method irA(nuevaPosicion) {
		position = nuevaPosicion
	}
	method mover(direccion) {
		self.irA(direccion.siguiente(self.position()) )
	}
	method atacar(enemigo){
		if (self.zombieEnSuRango(enemigo)){
			enemigo.perderVida(danio)
		}
	}
	method zombieEnSuRango(enemigo){
		return enemigo.position().y() == rangoAtacarNorte ||
			   enemigo.position().x() == rangoAtacarEste ||
			   enemigo.position().y() == rangoAtacarSur ||
			   enemigo.position().x() == rangoAtacarOeste 
			   // hacer un between con una lista del rango del soldado 
	}
	method perderVida(){
		if ((vida - 2) < 0 ){
			game.stop()
		}else{ vida -= 2 }
	}
}
object zombie1 {
	
	var property position = game.at(10,10)
	
	var property vida = 10 // Falta mostrar la vida del zombie
	
	var property danio = 2 
	
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
	method perderVida(_danio){
		if (vida - _danio < 0){
			game.removeVisual(self)
		}else {vida -= danio}
	}
	method morder(personaje){
		personaje.perderVida()
	}
}	