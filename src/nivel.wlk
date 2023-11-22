import wollok.game.*
import personajePrincipal.*
import direcciones.*
import zombies.*
import elementos.*
import armas.*
import randomizer.*
import mapa.*

object escenario {
	var nivel 
	
	method inciarNivel(nuevoNivel) {
		nuevoNivel.iniciarNivel()
		nivel = nuevoNivel
		nuevoNivel.vaciarAdministradores()
		nuevoNivel.administradores()
	}
	method pasarNivel() {
		const segundoNivel = new Nivel(mapa = mapaNivel2, imagenFondo = game.boardGround("background600x480_cueva.png"))
        self.inciarNivel(segundoNivel)
        segundoNivel.vaciarAdministradores()
        segundoNivel.administradores()
	}
	
}
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
	    self.removerNivel()
		self.instanciarObjetosFijos()
		self.configuracionTeclado()
		self.configuracionDelJuego()
	}

	method instanciarObjetosFijos() {
		mapa.generar()
	}
	method removerNivel() {
    	game.clear()
    }
	method configuracionDelJuego() {
    	game.onCollideDo(mago, { elemento => elemento.contacto(mago) })
        game.onTick(700, "arma", {mago.cambiarArma()})
    }
    method vaciarAdministradores() {
    	administradorEnemigos.enemigos().clear()
    	administradorPociones.pociones().clear()
    	administradorFuego.fuegos().clear()
    }
    method administradores() {
    	game.onTick(700, "HORDA", {administradorEnemigos.generarEnemigos()})
        game.onTick(2000, "MORDER", {administradorEnemigos.ataqueEnemigo()})
        game.onTick(2000, "POCIONES", {administradorPociones.generarPociones()})
        game.onTick(2000, "LANZAS", {administradorFuego.generarFuegoAzul()})
    	
    }
	
}
class Nivel2 inherits Nivel {
	
	override method administradores(){
		administradorJefe.generarJefeFinal()
		game.onTick(1000, "ATAQUEJEFE",{administradorJefe.ataqueJefe()})
		game.onTick(2000, "POCIONES", {administradorPociones.generarPociones()})
        game.onTick(2000, "LANZAS", {administradorFuego.generarFuegoAzul()})
	}
}
