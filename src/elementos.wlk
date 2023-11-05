import wollok.game.*
import personajePrincipal.*
import direcciones.*
import randomizer.*

class Elemento {

	method image()

	method impactoDeBala(elemento) {
		
	}

	method usado(personaje) {
	}

	method contacto(personaje) { 
	// por el momento sirve para a la hora de estar en la misma posicion agarre la moneda.
	}
	method perderVida(personaje) {
		
	}

}

class Pocion inherits Elemento {

	var property position
	const property vidaOtorgada = 5

	override method image() = "pocion_salud.png"

	override method usado(personaje) {
		personaje.tomarPocion(self)
		generadorAntidotos.quitar(self)
	}

}

class PocionAzul inherits Pocion {

	// Elejir que otorga esta pocion ademas de salud
	override method image() = "pocion_azul.png"

}

class PocionAmarilla inherits Pocion {

	// Elejir que otorga esta pocion ademas de salud
	override method image() = "pocion_amarilla.png"

}

object pocionFactory{
	method nuevaPocion(){
		return new Pocion(position = game.at(randomizer.xCualquiera(), randomizer.yCualquiera()))
	}
}
object pocionAzulFactory{
	method nuevaPocion(){
		return new PocionAzul(position = game.at(randomizer.xCualquiera(), randomizer.yCualquiera()))
	}
}
object pocionAmarillaFactory{
	method nuevaPocion(){
		return new PocionAmarilla(position = game.at(randomizer.xCualquiera(), randomizer.yCualquiera()))
	}
}
// las pociones factory repiten codigo, tratemos de evitar porque a medida que metamos mas cosas se va hacer un choclo.
object generadorAntidotos {

	var property pociones = []
	const cantidadMaxima = 5
	const pocionesDisponibles = [pocionFactory,pocionAzulFactory,pocionAmarillaFactory]
	// Esto sirve para que genere nuevas pociones que nosotros definamos.
	method generarPocion(){
		return pocionesDisponibles.anyOne()
	}
	method generarAntidotos() {
		if (pociones.size() < cantidadMaxima) {
			const antidoto = self.generarPocion().nuevaPocion()
			game.addVisual(antidoto)
			pociones.add(antidoto)
		}
	}

	method quitar(elemento) {
		pociones.remove(elemento)
		game.removeVisual(elemento)
	}

}

object arma inherits Elemento {

	const property danio = 10
	var property position = game.at(3, 9)
	var estado = libre

	override method image() = "fire.png"

	method generarBalacera(direccion) {
		self.validarEstado()
		const nuevaBala = new Bala(position = self.position().right(1))
		nuevaBala.disparar(direccion)
	}

	method validarEstado() {
		if (self.esLibre()) {
			self.error("no esta en posicion de nadie")
		}
	}

	method esLibre() {
		return estado === libre // Esto es mal, hay que cambiarlo.
	}

	method position(_position) {
		estado.position(_position)
	}

	method serLlevada(_personaje) {
		estado = llevada
		estado.personaje(_personaje)
		estado.removerImagenFuego(self)
		_personaje.imagenPersonaje(1) // Crear estado para cambiar imagen y no hardcodear metodo
	}

	method dejarLlevada() {
		estado = libre
		estado.position(self.position())
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

	method removerImagenFuego(arma) {
		game.removeVisual(arma)
	}

}

object libre {

	var property position = game.at(3, 9)

}

class Bala inherits Elemento {

	const property danio = 2
	var property position

	override method image() = "fireball1.png"

	method disparar(direccion) {
		game.addVisual(self)
		game.onTick(300, "disparar", { self.avanzar(direccion)})
		game.onCollideDo(self, { zombie => zombie.impactoDeBala(self)})
	}

	method avanzar(direccion) {
		position = direccion.siguiente(self.position())
	} 

}

object corazon inherits Elemento {

	const property position = game.at(1, 1)

	override method image() = "corazon" + soldado.vida().toString() + ".png"

}

class Moneda inherits Elemento {

	var property position
	const property valorMoneda

	override method image() = "moneda.png"

	override method contacto(personaje) {
		personaje.sumarMoneda(valorMoneda)
		monedero.removerMoneda(self)
	}

}

object monedero {

	const property position = game.at(10, 1)
	var property cantidadMonedas = 0
	var monedas = []

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

