import wollok.game.*
import personajePrincipal.*
import direcciones.*
import elementos.*
import armas.*
import randomizer.*
import nivel.*

class Personaje {

	var property vida = 10

	method morir()

	method impactoDeBala(elemento) {
		self.perderVida(elemento)
		elemento.eliminarSiEstoy()
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

	method impactoDeFuego(elemento)

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
	const moverMin = 3000

	method text()

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
		moverActual = (moverActual - decreser).max(moverMax)
		game.onTick(moverActual, "PERSEGUIR" + self.identity(), { self.mover()})
		danio = (danio + _danio).min(danioMax)
	}

	method esUnArma() {
		return false
	}

	override method impactoDeFuego(elemento) {
		self.disminuirMovimiento(elemento.efectoVelocidad())
		self.perderVida(elemento)
		administradorFuegos.quitar(elemento) // Necesita conocer el administrador
	}

	method disminuirMovimiento(aumentar) {
		game.removeTickEvent("PERSEGUIR" + self.identity())
		moverActual = (moverActual + aumentar).min(moverMin)
		game.onTick(moverActual, "PERSEGUIR" + self.identity(), { self.mover()})
	}

	method moverActual() { // unico metodo para los tests
		return moverActual
	}

}

class EnemigoNormal inherits Enemigo(danio = 1, movimiento = movimientoLibreX) {

	method image() = "esqueleto1.png"

	override method text() = self.vida().toString() + "/10"

}

class EnemigoMago inherits Enemigo(vida = 20, danio = 2, movimiento = movimientoVertical) {

	const velocidadAtaque = 300

	method image() = "mago3.png"

	override method text() = self.vida().toString() + "/20"

	override method atacar() {
		const nuevaBala = new Fuego(position = self.position().left(1), imagenDisparo = charge, danio = danio)
		nuevaBala.disparar(izquierda, velocidadAtaque) 
	}

}

class EnemigoSoporte inherits Enemigo(danio = 0, movimiento = movimientoNulo, vida = 30) {

	const reducirTiempoMovimiento = 100
	const aumentarDanio = 1

	method image() = "mago_soporte.png"

	override method text() = self.vida().toString() + "/30"

	// Debe conocer los zombies en el mapa directamente para aplicarle su efecto especial.
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
		return new EnemigoSoporte(position = randomizer.emptyPosition())
	}

}

object administradorEnemigos inherits AuxiliarDeAdministradores {

	// Enemigos con cierta probabilidad, ya que el soperte y el mago son dificiles.
	override method seleccionFactory() {
		const x = (1 .. 100).anyOne()
		return if (x < 80) { // un 80% de que sea normal
			enemigoNormalFactory
		} else if (x < 95) { // un 15% de que sea mago
			enemigoMagoFactory
		} else {
			enemigoSoporteFactory // menos del 5% que sea soporte
		}
	}

}

class AuxiliarDeAdministradores {

	var property enemigos = []
	const cantidadMaxima = 4

	method seleccionFactory()

	method generarEnemigos() {
		if (enemigos.size() < cantidadMaxima) {
			const nuevoEnemigo = self.seleccionFactory().nuevoEnemigo()
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

object enemigoJefe inherits Enemigo(danio = 3, danioMax = 5, vida = 40, moverActual = 500, moverMax = 100, moverMin = 1000, position = randomizer.emptyPosition(), movimiento = movimientoLibreX) {

	method image() = "orco.png"

	override method text() = self.vida().toString() + "/100"

	override method morir() {
		escenario.ganaste()
	}

}

object administradorJefe {

	method generarJefeFinal() {
		game.addVisual(enemigoJefe)
		enemigoJefe.generarOnTicksPerseguir()
	}

	method ataqueJefe() {
		enemigoJefe.atacar()
	}

}

// Se tiene que crear nuevos magos para ajustar donde disparan.
class EnemigoMagoEste inherits EnemigoMago {

	override method atacar() {
		const nuevaBala = new Fuego(position = self.position().right(1), imagenDisparo = charge, danio = danio)
		nuevaBala.disparar(derecha, velocidadAtaque)
	}

}

class EnemigoMagoNorte inherits EnemigoMago {

	override method atacar() {
		const nuevaBala = new Fuego(position = self.position().down(1), imagenDisparo = charge, danio = danio)
		nuevaBala.disparar(abajo, velocidadAtaque)
	}

}

class EnemigoMagoSur inherits EnemigoMago {

	override method atacar() {
		const nuevaBala = new Fuego(position = self.position().up(1), imagenDisparo = charge, danio = danio)
		nuevaBala.disparar(arriba, velocidadAtaque)
	}

}

object magoFactoryEste {

	method nuevoEnemigo() {
		return new EnemigoMagoEste(position = game.at(1, randomizer.yCualquiera()))
	}

}

object magoFactoryNorte {

	method nuevoEnemigo() {
		return new EnemigoMagoNorte(position = game.at(randomizer.xCualquiera(), 10), movimiento = movimientoHorizontal)
	}

}

object magoFactorySur {

	method nuevoEnemigo() {
		return new EnemigoMagoSur(position = game.at(randomizer.xCualquiera(), 2), movimiento = movimientoHorizontal)
	}

}

object administradorMagosFinal inherits AuxiliarDeAdministradores(cantidadMaxima = 2) {

	const factoryMagos = [ enemigoMagoFactory, magoFactoryEste, magoFactoryNorte, magoFactorySur ]

	override method seleccionFactory() {
		return factoryMagos.anyOne()
	}

}

