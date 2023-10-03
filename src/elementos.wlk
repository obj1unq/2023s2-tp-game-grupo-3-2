
import wollok.game.*
import personajePrincipal.*
import direcciones.*
import randomizer.*

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
	method impactoDeBala(bala) {	
	}
}
object espada {
	const property danio = 10
	var property position = game.at(3,3)
	const property rango = 2
	
	method image() = "espada.png"
	
	method impactoDeBala(bala) {	
	}
	
}
object arma {
	const property danio = 10
	var property position = game.at(3,9)
	var estado = libre
	
	method image() = "arma.png"
	
	method generarBalacera() {
			self.validarEstado()
			const nuevaBala = new Bala(position = self.position().right(1))
			nuevaBala.disparar()
	}
	method validarEstado(){
		if (self.esLibre()){
			self.error("no esta en posicion de nadie")
		}
	}
	method esLibre(){
		return estado === libre
	}
	method position(_position) {
		estado.position(_position)
	}
	method serLlevada(_personaje) {
		llevada.personaje(_personaje)
		estado = llevada
	}
	method dejarLlevada() {
		libre.position(self.position())
		estado = libre
	}
	method position() {
		return estado.position()
	}
} 
object llevada {
	var property personaje = null
	
	method position() {
		return personaje.position()
	}
	method position(_position) {
		self.error("me estan llevando")
	}	
}
object libre {
	var property position = game.at(3,9)
}
class Bala {
	const property danio = 5
	var property position 
	
	method image() = "bala.png"
	
	method disparar() {
      game.addVisual(self)
      game.onTick(300, "disparar",{self.avanzar()} )
      game.onCollideDo(self, { zombie => zombie.impactoDeBala(self) })	
	}
	method avanzar() {
		position = self.position().right(1)
	}
	method impactoDeBala(personaje) {
		   
	}
}
object bomba {
	const property danio = 10
	var property position = game.at(5,17)
	
	method image() = "bomba.png"
	
	method impactoDeBala(bala) {	
	}
}
