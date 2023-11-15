import wollok.game.*
import personajePrincipal.*
import direcciones.*
import zombies.*
import elementos.*
import randomizer.*

class Nivel {

// Clase para crear mas de un nivel	
	method configuracionTeclado() { // Configuración de teclado
	}

	method objetosVisualesExtra() {
	}

	method iniciarNivel() { // metodo para iniciar nivel desde main
		self.imagenDeFondo()
		self.instanciarObjetosFijos()
		self.configuracionTeclado()
		self.objetosVisualesExtra()
	}

	method instanciarObjetosFijos() // instanciar objetos fijos 

	method imagenDeFondo()

}

object nivel1 inherits Nivel {

	override method instanciarObjetosFijos() {
		game.addVisual(new ArbolQuemado(position = game.at(0, 11)))
		game.addVisual(new ArbolQuemado(position = game.at(1, 11)))
		game.addVisual(new ArbolQuemado(position = game.at(2, 11)))
		game.addVisual(new ArbolQuemado(position = game.at(3, 11)))
		game.addVisual(new ArbolQuemado(position = game.at(4, 11)))
		game.addVisual(new ArbolQuemado(position = game.at(5, 11)))
		game.addVisual(new ArbolQuemado(position = game.at(6, 11)))
		game.addVisual(new ArbolQuemado(position = game.at(7, 11)))
		game.addVisual(new ArbolQuemado(position = game.at(8, 11)))
		game.addVisual(new ArbolQuemado(position = game.at(9, 11)))
		game.addVisual(new ArbolQuemado(position = game.at(10, 11)))
		game.addVisual(new ArbolQuemado(position = game.at(11, 11)))
		game.addVisual(new ArbolQuemado(position = game.at(12, 11)))
		game.addVisual(new ArbolQuemado(position = game.at(13, 11)))
		game.addVisual(new ArbolQuemado(position = game.at(14, 11)))
		game.addVisual(new ArbolQuemado(position = game.at(15, 11)))
		game.addVisual(new ArbolNormal(position = game.at(12, 4)))
		game.addVisual(new ArbolCortado(position = game.at(9, 9)))
		game.addVisual(new Roca(position = game.at(7, 7), numeroRoca = 1))
		game.addVisual(new Roca(position = game.at(5, 3), numeroRoca = 2))
		game.addVisual(cueva)
		game.addVisual(totem)
	}

	override method imagenDeFondo() {
		game.boardGround("background600x480_noche.png")
	}

}

object nivel2 inherits Nivel {

	// Siguiente nivel
	override method instanciarObjetosFijos() {
	}

	override method imagenDeFondo() {
	}

}

class Objeto { // Falta implementar que los objetos sean solidos y no se puedan atravesar 

	const property position

	method image()

	method contacto(personaje) { // Para que no tire error 
	}

	method impactoDeBala(elemento) { // Elimina imagen y evento de disparo si colisiona con objeto
		game.removeVisual(elemento)
		game.removeTickEvent("disparar")
	}

}

class ArbolQuemado inherits Objeto {

	override method image() = "arbol_quemado.png"

}

class ArbolNormal inherits Objeto {

	override method image() = "arbol_normal.png"

}

class ArbolCortado inherits Objeto {

	override method image() = "arbol_cortado.png"

}

class Roca inherits Objeto {

	const property numeroRoca

	override method image() = "roca" + numeroRoca.toString() + ".png"

}

object cueva inherits Objeto(position = game.at(13, 9)) { // Puede ser una cueva/castillo - Colisionar y pasar al siguiente nivel 

	override method image() = "cueva.png"

}

object totem inherits Objeto(position = game.at(3, 9)) {

	override method image() = "totem.png"

}

