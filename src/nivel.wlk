import wollok.game.*
import personajePrincipal.*
import direcciones.*
import zombies.*
import elementos.*
import randomizer.*
import mapa.*

class Nivel {

	const property mapa
	const property imagenFondo

	method configuracionTeclado() { // Configuración de teclado para todos los niveles
		keyboard.up().onPressDo({ mago.mover(arriba)})
		keyboard.down().onPressDo({ mago.mover(abajo)})
		keyboard.left().onPressDo({ mago.mover(izquierda)})
		keyboard.right().onPressDo({ mago.mover(derecha)})
		keyboard.w().onPressDo({ armaFuego.generarBalacera(derecha)})
		keyboard.a().onPressDo({ mago.agarrar()})
		keyboard.z().onPressDo({ mago.lanzar()})
		keyboard.x().onPressDo({ mago.cambiarArma()})
	}

	method iniciarNivel() { // Iniciar nivel desde main
		self.imagenDeFondo()
		self.instanciarObjetosFijos()
		self.configuracionTeclado()
	}

	method instanciarObjetosFijos() {
		mapa.generar()
	}

	method imagenDeFondo() {
		game.boardGround(imagenFondo)
	}

}

class Objeto { // Falta implementar que los objetos sean solidos y no se puedan atravesar 

	const property position
	const property image

	method contacto(personaje) { // Para que no tire error 
	}

	method impactoDeBala(elemento) { // Elimina imagen y evento de disparo si colisiona con objeto
		game.removeVisual(elemento)
		game.removeTickEvent("disparar")
	}

	method solido() {
		return true
	}

}

