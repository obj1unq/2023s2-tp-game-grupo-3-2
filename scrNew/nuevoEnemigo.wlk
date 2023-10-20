import wollok.game.*
import nuevoPersonaje.*
import nuevoDirecciones.*
import nuevoRandomizer.*

class Enemigo{
	var property position 
	var property vida 
	const vidaMaxima = vida 
	var property danio  
	const property rojo = "FF0000FF" // Color rojo
	
	method text() = self.vida().toString() + "/" + vidaMaxima + ""
	
	method textColor() = self.rojo()

	method image()
	
	method mover(personaje) {
		if (not (self.mismoEjeX(personaje))) {
			self.irACeldaX(personaje)
		} else if (not (self.mismoEjeY(personaje))) {
			self.irACeldaY(personaje)
		}
	}

	method mismoEjeY(personaje) {
		return self.position().y() == personaje.position().y()
	}

	method irACeldaY(personaje) {
		position = self.subirOBajar(personaje)
	}

	method subirOBajar(personaje) {
		return if (personaje.position().y() > self.position().y()) {
			self.position().up(1)
		} else {
			self.position().down(1)
		}
	}

	method mismoEjeX(personaje) {
		return self.position().x() == personaje.position().x()
	}

	method mismaPosicion(personaje) {
		return self.position() == personaje.position()
	}

	method irACeldaX(personaje) {
		position = self.izqODerecha(personaje)
	}

	method izqODerecha(personaje) {
		return if (personaje.position().x() > self.position().x()) {
			self.position().right(1)
		} else {
			self.position().left(1)
		}
	}
	method morir() {
		game.removeVisual(self)
		game.removeTickEvent("Morder")
	}

	method estaMuerto() {
		return vida <= 0
	}
	method perderVida(_danio) {
		vida -= _danio
		if (self.estaMuerto()) {
			self.morir()
		}
	}

	method atacar(enemigo) {
		if (self.mismaPosicion(enemigo)) {
	        enemigo.perderVida(self)	
		}
	}
	method atacarSoldado() { 
		const personajes = game.colliders(self)
	    personajes.forEach({personaje => self.atacar(personaje) }) 
	}
	method solido(){
		return false
	}
	method impacto(arma){
		self.perderVida(arma.danio())
		game.removeVisual(arma)
	}
}

class Esqueleto inherits Enemigo(vida = 50, danio = 1,position = game.at(18,randomizer.yCualquiera())){
	
	override method image() {
		return "Esqueleto1.png"
	}
}
object hordaEnemiga {
	var property enemigos = []
	const variedadEnemigo = [esqueletoFactorial]
	const cantidadMaxima = 2
	
	
	method randomEnemigo(){
		return variedadEnemigo.anyOne()
	}
	method generarEnemigos() {
		if (enemigos.size() <= cantidadMaxima) {
			const nuevoEnemigo = self.randomEnemigo().nuevoEnemigo()
			game.addVisual(nuevoEnemigo)
			enemigos.add(nuevoEnemigo)
		}
	}
	method moverALosEnemigos(personaje) {
		if (enemigos.size() > 0) {
			enemigos.forEach({ enemigo=> enemigo.mover(personaje)})
		}
	}
	method ataqueEnemigo(personaje) {
		if (enemigos.size() > 0) {
			enemigos.forEach({ enemigo=> enemigo.atacar(personaje)})
		}
	}
}
object esqueletoFactorial{
	
	method nuevoEnemigo(){
		return new Esqueleto()		
	}
	
}
/*
object enemigo{
	var property position = game.at(10,10)
	var property vida = 50
	const vidaMaxima = vida 
	var property danio = 1
	const property rojo = "FF0000FF" // Color rojo
	
	method text() = self.vida().toString() + "/" + vidaMaxima + ""
	
	method textColor() = self.rojo()

	method image(){
		return "Esqueleto1.png"
	}
	method perderVida(_danio) {
		vida -= _danio
		if (self.estaMuerto()) {
			self.morir()
		}
	}
	method morir() {
		game.removeVisual(self)
		game.removeTickEvent("Morder")
	}

	method estaMuerto() {
		return vida <= 0
	}
	method solido(){
		return false
	}
	method impacto(arma){
		self.perderVida(arma.danio())
		game.removeVisual(arma)
	}
	method mover(personaje) {
		if (not (self.mismoEjeX(personaje))) {
			self.irACeldaX(personaje)
		} else if (not (self.mismoEjeY(personaje))) {
			self.irACeldaY(personaje)
		}
	}

	method mismoEjeY(personaje) {
		return self.position().y() == personaje.position().y()
	}

	method irACeldaY(personaje) {
		position = self.subirOBajar(personaje)
	}

	method subirOBajar(personaje) {
		return if (personaje.position().y() > self.position().y()) {
			self.position().up(1)
		} else {
			self.position().down(1)
		}
	}

	method mismoEjeX(personaje) {
		return self.position().x() == personaje.position().x()
	}

	method mismaPosicion(personaje) {
		return self.position() == personaje.position()
	}

	method irACeldaX(personaje) {
		position = self.izqODerecha(personaje)
	}

	method izqODerecha(personaje) {
		return if (personaje.position().x() > self.position().x()) {
			self.position().right(1)
		} else {
			self.position().left(1)
		}
	}
}
*/