import wollok.game.*
import direcciones.*
import zombies.*
import elementos.*

object soldado {
	var property position = game.origin()
	
	var property vida = 100 // Falta mostrar la vida del soldado
	var property danio = 5
	
	method image() = "soldado.png"
	
	method irA(nuevaPosicion) {
		    position = nuevaPosicion
	}
	method mover(direccion) {
		self.irA(direccion.siguiente(self.position()) )
	}
	method atacarZombie() {  //esto tendria que estar en el objeto arma 
		const zombies = game.colliders(self)
		zombies.forEach({zombie => self.atacar(zombie)})
	}
	method mismaPosicion(personaje) {
		return self.position() == personaje.position()
	}
	method atacar(enemigo){
		if (self.mismaPosicion(enemigo)){
			enemigo.perderVida(self)
		}
	}
	method morir(){
		game.stop()
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
	method tomarPocion() {
		const pociones = game.colliders(self)
		pociones.forEach({pocion => self.tomar(pocion)})
	}
	method tomar(pocion) {
		vida += pocion.vidaOtorgada().min(100)
    }
}
	