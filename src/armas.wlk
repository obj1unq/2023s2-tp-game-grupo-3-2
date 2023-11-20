import wollok.game.*
import personajePrincipal.*
import direcciones.*
import randomizer.*

class Lanza {

	var property danio = 5
	var property position
	const maxDanio = 10
	const duenio = mago

	method image() = "lanza.png"

	method aumentarSuDanio(_danio) {
		danio = (danio + _danio).min(maxDanio)
	}
    
    method accion() {
    	llevada.cambiarEstado(duenio)
    	self.serLanzada()
    }
	method serLanzada() {
		game.onTick(300, "lanzar", { self.avanzar(derecha)})
		game.onCollideDo(self, { zombie => zombie.impactoDeLanza(self)})
	}

	method avanzar(direccion) {
		position = direccion.siguiente(self.position())
		self.eliminarDelTablero()
	}

	method eliminarDelTablero() {
		if (self.position().x() > 13 or self.position().x() < 1) {
			self.eliminarSiEstoy()
		}
	}

	method estoyEnElTablero() {
		return game.hasVisual(self)
	}

	method eliminarSiEstoy() {
		if (self.estoyEnElTablero()) {
			game.removeTickEvent("lanzar")
			game.removeVisual(self)
		}
	}

	method contacto(personaje) {
	// Sirve para que no salga el mensaje error
	}

	method esUnArma() {
		return true
	}

	method impactoDeBala(elemento) {
	// Sirve para que no salga el mensaje error
	}

	method solido() {
		return false
	}

	method imagenMagoConArma() {
		return "mago_lanza.png"
	}

}

object generadorLanzas {

	var property lanzas = []
	const cantidadMaxima = 3

	method generarLanzas() {
		if (lanzas.size() < cantidadMaxima) {
			const lanza = new Lanza(position = randomizer.emptyPosition())
			game.addVisual(lanza)
			lanzas.add(lanza)
		}
	}

	method quitar(elemento) {
		lanzas.remove(elemento)
		game.removeVisual(elemento)
	}

	method contacto(personaje) { // Para que no tire error 
	}

}

object armaFuego {

	var danio = 2
	const maxDanio = 10
	var property position = game.at(3, 8)

	method image() = "poder_fuego.png"
    
    method accion(direccion) {
    	self.generarBalacera(direccion)
    }
	method generarBalacera(direccion) {
		// Ahora sabe la direccion en cual tiene q ir x parametro.
		const nuevaBala = new Fuego(position = direccion.siguiente(self.position()), imagenDisparo = fireball, danio = danio)
		nuevaBala.disparar(direccion)
	}

	method aumentarSuDanio(_danio) {
		danio = (danio + _danio).min(maxDanio)
	}

	method contacto(personaje) {
	// agrege este mensaje por sino sale pantalla de error.
	}

	method impactoDeBala(elemento) {
	}

	method esUnArma() {
		return true
	}

	method solido() {
		return false
	}

	method imagenMagoConArma() {
		return "mago_fuego.png"
	}

/*
 * method validarBalacera() {
 * 	propetario.validarBalacera()
 * 	if (propetario.armaDePersonaje() != self) {
 * 		self.error("No me esta llevando")
 * 	}
 * 	
 } */
}

object llevada {

	const cambioEstado = libre

	method moverElemento(personaje) {
		return personaje.armaDePersonaje().position(personaje.position())
	}

	method cambiarEstado(personaje) {
		personaje.llevando(cambioEstado)
	}
    
	method accion(personaje) {
		//self.cambiarEstado(personaje) esto tampoco sirve, solamente la lanza cambia el estado al personaje 
		personaje.armaDePersonaje().accion(personaje.ultimaDireccion())
	}

	method validarBalacera() {
	}

	method poseeArma() {
		return true
	}

}

object libre {

	const cambioEstado = llevada

	method moverElemento(personaje) {
	}

	method cambiarEstado(personaje) {
		personaje.llevando(cambioEstado)
	}
    
	method accion(personaje) {
		// no deberia hacer nada en el estado libre ??? 
		personaje.armaDePersonaje().accion(personaje.ultimaDireccion())
	}

	method validarBalacera() {
		self.error("No me esta llevando")
	}

	method poseeArma() {
		return false
	}

}

// Ahora a la bala le asigno el danio desde el arma, pasando el danio que tiene el arma 
class Fuego {

	var property danio
	var property position
	const property imagenDisparo

	method image() = imagenDisparo.image()

	method disparar(direccion) {
		game.addVisual(self)
		game.onTick(200, "disparar", { self.avanzar(direccion)})
		game.onCollideDo(self, { zombie => zombie.impactoDeBala(self)})
	}

	method avanzar(direccion) {
		position = direccion.siguiente(self.position())
		self.eliminarDelTablero()
	}

	method eliminarDelTablero() { // Elimina fuego si supera supera eje X
		if (self.position().x() > 13 or self.position().x() < 1) {
			self.eliminarSiEstoy()
		}
	}

	method estoyEnElTablero() {
		return game.hasVisual(self)
	}

	method eliminarSiEstoy() {
		if (self.estoyEnElTablero()) {
			game.removeTickEvent("disparar")
			game.removeVisual(self)
		}
	}

	method impactoDeBala(elemento) {
	// Sirve para que no salga el mensaje error
	}

	method solido() {
		return false
	}

	method contacto(personaje) {
	}

}

object fireball {

	method image() {
		return "fireball.png"
	}

}

object charge {

	method image() {
		return "charge.png"
	}

}

