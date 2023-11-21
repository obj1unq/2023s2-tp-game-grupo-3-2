import wollok.game.*
import personajePrincipal.*
import direcciones.*
import elementos.*
import armas.*
import randomizer.*

class Personaje {

	var property vida = 10

	method morir()

	method impactoDeBala(elemento) {
		self.perderVida(elemento)
		game.removeVisual(elemento)
	}

	method perderVida(elemento) {
		vida -= elemento.danio()
		if (self.estaMuerto()) {
			self.morir()
		}
	}

	method estaMuerto() {
		return (vida <= 0)
	}

	method contacto(personaje) {
	// agrege este mensaje por sino sale pantalla de error.
	}

	method impactoDeFuego(elemento) {
		self.perderVida(elemento)
		game.removeVisual(elemento)
	}

	method solido() {
		return false
	}

}

class Enemigo inherits Personaje {

	var property danio
	const danioMax = 4
	var property position
	const enemigo = mago
	const property rojo = "FF0000FF" // Color rojo
	var property movimiento // para que cambie la inteligencia del movimiento.
	var moverActual = 2000
	const moverMax = 1000

	method text() = self.vida().toString() + "/10"

	method mover() {
		movimiento.mover(self, enemigo)
	}

	method textColor() = self.rojo()

	override method morir() {
		self.soltarMoneda()
		administradorEnemigos.quitar(self)
		game.removeTickEvent("PERSEGUIR" + self.identity())
	}

	method soltarMoneda() {
		monedero.generarMoneda(self.position())
	}

	method atacar() {
		if (self.position() == enemigo.position()) {
			enemigo.perderVida(self)
		}
	}

	// Cada zombie tiene su propio onTick para moverse,y asi poder modificar.
	method generarOnTicksPerseguir() {
		game.onTick(moverActual, "PERSEGUIR" + self.identity(), { self.mover()})
	}

	// Metodo donde aumenta el movimiento del movimiento.
	method aumentarMovimientoYAtaque(decreser, _danio) {
		game.removeTickEvent("PERSEGUIR" + self.identity())
		const tiempoActual = (moverActual - decreser).max(moverMax)
		game.onTick(tiempoActual, "PERSEGUIR" + self.identity(), { self.mover()})
		danio = (danio + _danio).min(danioMax)
	}

	method esUnArma() {
		return false
	}

}

class EnemigoNormal inherits Enemigo(danio = 1, movimiento = new MovimientoLibreX()) {

	method image() = "esqueleto1.png"

}

class EnemigoMago inherits Enemigo(vida = 20, danio = 2, movimiento = movimientoVertical) {

	method image() = "mago3.png"

	override method atacar() {
		const nuevaBala = new Fuego(position = self.position().left(1), imagenDisparo = charge, danio = danio)
		nuevaBala.disparar(izquierda,250) // x ahora sera un numero magico
	}

}

class EnemigoSoporte inherits Enemigo(danio = 0, movimiento = movimientoNulo) {

	const reducirTiempoMovimiento = 100
	const aumentarDanio = 1

	method image() = "esqueleto2.png"

	// Debe conocer los zombies en el mapa directamente para aplicarle su efecto especial.
	// No es correcto el usar el metodo ataque pero es algo a mejorar.
	override method atacar() {
		administradorEnemigos.enemigos().forEach({ enemigo => enemigo.aumentarMovimientoYAtaque(reducirTiempoMovimiento, aumentarDanio)})
	}

	// Metodo utilizado unicamente en los tests.
	method pruebaAtacar(enemigo) {
		enemigo.aumentarMovimientoYAtaque(reducirTiempoMovimiento, aumentarDanio)
	}

}

object enemigoNormalFactory {

	method nuevoEnemigo() {
		return new EnemigoNormal(position = game.at(15, randomizer.yCualquiera()))
	}

}

object enemigoMagoFactory {

	method nuevoEnemigo() {
		return new EnemigoMago(position = game.at(13, randomizer.yCualquiera()))
	}

}

object enemigoSoporteFactory {

	method nuevoEnemigo() {
		return new EnemigoSoporte(position = randomizer.position())
	}

}

object administradorEnemigos {

	var property enemigos = []
	const cantidadMaxima = 2
	// const enemigosFactory = [ enemigoNormalFactory, enemigoMagoFactory, enemigoSoporteFactory ]

	// enemigos con cierta probabilidad, ya que el soperte y el mago son dificiles.
	method ramdomFactoryEnemigo() {
		const x = (1..100).anyOne() 
		return if (x < 80 ) {	// un 80% de que sea normal
			enemigoNormalFactory
		} else if (x < 95) {	// un 15% de que sea mago
			enemigoMagoFactory
		} else {
			enemigoSoporteFactory // menos del 5% que sea soporte
		}
	}

	method generarEnemigos() {
		if (enemigos.size() < cantidadMaxima) {
			const nuevoEnemigo = self.ramdomFactoryEnemigo().nuevoEnemigo()
			game.addVisual(nuevoEnemigo)
			enemigos.add(nuevoEnemigo)
			nuevoEnemigo.generarOnTicksPerseguir()
		}
	}

	method ataqueEnemigo() {
		if (enemigos.size() > 0) {
			enemigos.forEach({ enemigo => enemigo.atacar()})
		}
	}

	method quitar(enemigo) {
		enemigos.remove(enemigo)
		game.removeVisual(enemigo)
	}

}

