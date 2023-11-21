import wollok.game.*
import personajePrincipal.*
import direcciones.*
import zombies.*
import elementos.*
import armas.*
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
		//keyboard.z().onPressDo({ mago.lanzar()}) ya no hace falta
		//keyboard.x().onPressDo({ mago.cambiarArma()})  ya no hace falta
	}

	method iniciarNivel() { // Iniciar nivel desde main
		self.imagenDeFondo()
		self.instanciarObjetosFijos()
		self.configuracionTeclado()
		self.configuracionDelJuego()
		self.administradores()
	}

	method instanciarObjetosFijos() {
		mapa.generar()
	}

	method imagenDeFondo() {
		game.boardGround(imagenFondo)
	}
	
	method configuracionDelJuego() {
    	game.onCollideDo(mago, { elemento => elemento.contacto(mago) })
        game.onTick(700, "arma", {mago.cambiarArma()})
    }
    method administradores() {
    	game.onTick(700, "HORDA", {administradorEnemigos.generarEnemigos()})
        game.onTick(2000, "MORDER", {administradorEnemigos.ataqueEnemigo()})
        game.onTick(2000, "POCIONES", {administradorPociones.generarPociones()})
        game.onTick(2000, "LANZAS", {administradorFuego.generarLanzas()})
    	
    }

}

