import wollok.game.*
import personajePrincipal.*
import direcciones.*
import randomizer.*

class Pocion {

	var property position
	var vidaOtorgada 
	const imagenPocion  // ahora le pasamos la imagen por parametro
	const danioAdicional = 0 

	method image() = imagenPocion

	method contacto(personaje) {
		personaje.tomarPocion(self)
		administradorPociones.quitar(self)
	}

	// Cada pocion pasara los valores que le asignemos nosotros.
	method efectoPocion(personaje) {
		personaje.aumentarVida(vidaOtorgada)
		personaje.aumentarDanio(danioAdicional)
	}

	method impactoDeBala(elemento) {
	// Sirve para que no salga el mensaje error
	}

	method solido() {
		return false
	}

}

class PocionRoja inherits Pocion(imagenPocion = "pocion_salud.png",vidaOtorgada = 5){
	// Pocion de salud 	
}
class PocionAzul inherits Pocion(imagenPocion = "pocion_azul.png", vidaOtorgada = 3) {
	// Pocion de ... (hay que proveerle algo)
}

class PocionAmarilla inherits Pocion(imagenPocion = "pocion_amarilla.png", vidaOtorgada = 1, danioAdicional = 2) {
	// Pocion de daño
}

object pocionRojaFactory {

	method nuevaPocion() {
		return new PocionRoja(position = randomizer.position())
	}

}

object pocionAzulFactory {

	method nuevaPocion() {
		return new PocionAzul(position = randomizer.position())
	}

}

object pocionAmarillaFactory {

	method nuevaPocion() {
		return new PocionAmarilla(position = randomizer.position())
	}

}

// las pociones factory repiten codigo, tratemos de evitar porque a medida que metamos mas cosas se va hacer un choclo.
object administradorPociones {

	var property pociones = []
	const cantidadMaxima = 4
	
	const pocionesFactory = [ pocionRojaFactory, pocionAzulFactory, pocionAmarillaFactory ]

	// Esto sirve para que genere nuevas pociones que nosotros definamos.
	method generarPocion() {
		return pocionesFactory.anyOne().nuevaPocion()
	}

	method generarPociones() {
		if (pociones.size() < cantidadMaxima) {
			const pocion = self.generarPocion()
			game.addVisual(pocion)
			pociones.add(pocion)
		}
	}

	method quitar(elemento) {
		pociones.remove(elemento)
		game.removeVisual(elemento)
	}

}

class Lanza {

	var property danio = 5
	var property position
	const maxDanio = 10

	method image() = "flecha.png"

	method aumentarSuDanio(_danio) {
		danio = (danio + _danio).min(maxDanio)
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
		if (self.position().x() > 17 or self.position().x() < 1) {
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

}

object generadorLanzas {

	var property lanzas = []
	const cantidadMaxima = 3

	method generarLanzas() {
		if (lanzas.size() < cantidadMaxima) {
			const lanza = new Lanza(position = randomizer.position())
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
	const propetario = mago

	method image() = "poder_fuego.png"

	method generarBalacera(direccion) {
		//propetario.validarBalacera()
		//self.validarBalacera()
		const nuevaBala = new Fuego(position = self.position().right(1), imagenDisparo = fireball, danio = danio)
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
	/*
	method validarBalacera() {
		propetario.validarBalacera()
		if (propetario.armaDePersonaje() != self) {
			self.error("No me esta llevando")
		}
		
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

	method lanzar(personaje) {
		self.cambiarEstado(personaje)
		personaje.armaDePersonaje().serLanzada()
	}

//	method imagenFuego(arma) { // Hay que cambiar el nombre de este metodo
//		game.removeVisual(arma)
//	}
	method validarBalacera() {
	}

//	method imagenDePersonaje() {
//		return "mago1"
//	}
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

	method lanzar(personaje) {
		personaje.armaDePersonaje().serLanzada()
	}

//	method imagenFuego(arma) { // Hay que cambiar el nombre de este metodo
//		game.addVisual(arma)
//	}
//	method imagenDePersonaje() {
//		return "mago0"
//	}
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

object corazon {

	const property position = game.at(1, 0)

	method image() = "corazon" + mago.vida().toString() + ".png"

}

class Moneda {

	var property position
	const property valorMoneda

	method image() = "moneda.png"

	method contacto(personaje) {
		monedero.removerMoneda(self)
	}

	method impactoDeBala(elemento) {
	// Sirve para que no salga el mensaje error
	}

	method solido() {
		return false
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

object monedero {

	const property position = game.at(10, 0)
	var property cantidadMonedas = 0
	var property monedas = []

	method image() = "monedero.png"

	method text() = self.cantidadMonedas().toString() + "/100"

	method textColor() = "FFFFFF"

	method generarMoneda(_position) { // con probabilidad simple de 1 a 10 de valor 
		const monedaNueva = new Moneda(position = _position, valorMoneda = (1 .. 10).anyOne())
		self.agregarMoneda(monedaNueva)
	}

	method agregarMoneda(moneda) {
		game.addVisual(moneda)
		monedas.add(moneda)
	}

	method removerMoneda(moneda) {
		cantidadMonedas += moneda.valorMoneda()
		monedas.remove(moneda)
		game.removeVisual(moneda)
	}

}

