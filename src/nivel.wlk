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
		keyboard.w().onPressDo({ mago.tirarHechizo()})
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


