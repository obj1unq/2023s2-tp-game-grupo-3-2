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
	}
	method pasarNivel() {
		//const segundoNivel = new Nivel2(mapa = mapaNivel2, imagenFondo = game.boardGround("background600x480_cueva.png"))
        const segundoNivel = new Nivel2()
        self.inciarNivel(segundoNivel)
	}
	method perdiste(){
		const gameOver = new GameOver() 
		self.inciarNivel(gameOver)
	}
}
class Nivel {

	const property mapa
	//const property imagenFondo

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
	    monedero.cantidadMonedas(0)
	    mago.vida(10)
	    self.removerNivel()
	    self.configuracionFondo()
		self.instanciarObjetosFijos()
		self.configuracionTeclado()
		self.configuracionDelJuego()
		self.vaciarAdministradores()
		self.administradores()
	}
    method configuracionFondo()
    
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
    method vaciarAdministradores()
    
    method administradores()
	
}

class Nivel1 inherits Nivel (mapa = mapaNivel1) {//, imagenFondo = game.boardGround("background600x480_noche.png")) {
       
       override method 	vaciarAdministradores() {
       	    administradorEnemigos.enemigos().clear()
    	    administradorPociones.pociones().clear()
    	    administradorFuego.fuegos().clear()
       }
	   override method administradores() {
	   	   game.onTick(700, "HORDA", {administradorEnemigos.generarEnemigos()})
           game.onTick(2000, "MORDER", {administradorEnemigos.ataqueEnemigo()})
           game.onTick(2000, "POCIONES", {administradorPociones.generarPociones()})
           game.onTick(2000, "LANZAS", {administradorFuego.generarFuegoAzul()})
	   }
	   override method configuracionFondo(){
		   game.addVisual(fondoPasto)	
	}
}
object fondoPasto  {

	var property position = game.at(0, 0)

	 method image() = "background600x480_noche.png"

	 method chocasteCon(personaje) {
	}

}

class Nivel2 inherits Nivel (mapa = mapaNivel2){ //, imagenFondo = game.boardGround("background600x480_cueva.png")) {
       
       override method 	vaciarAdministradores() {
       	    administradorEnemigos.enemigos().clear()
    	    administradorPociones.pociones().clear()
    	    administradorFuego.fuegos().clear()
       }
	   override method administradores() {
	   	administradorJefe.generarJefeFinal()
		game.onTick(1000, "ATAQUEJEFE",{administradorJefe.ataqueJefe()})
		game.onTick(2000, "POCIONES", {administradorPociones.generarPociones()})
        game.onTick(2000, "LANZAS", {administradorFuego.generarFuegoAzul()})
	   }
	   override method configuracionFondo(){
		game.addVisual(fondoTierra)	
	}
}
object fondoTierra  {

	var property position = game.at(0, 0)

	 method image() = "background600x480_cueva.png"

	 method chocasteCon(personaje) {
	}

}
class GameOver inherits Nivel(mapa=null) {
	
	override method iniciarNivel() {
		self.removerNivel()
		self.configuracionFondo()
		self.configuracionTeclado()
	}	
	override method configuracionFondo(){
		game.addVisual(fondoGameOver)		
	}
	override method configuracionTeclado() {
		const primerNivel = new Nivel1()
		keyboard.x().onPressDo({ escenario.inciarNivel(primerNivel)})
	}
	override method vaciarAdministradores() {
		
	}
	override method administradores() {
		
	}	
}
object fondoGameOver {
	var property position = game.at(0, 0)

	 method image() = "background600x480_gameover.png"

	 method chocasteCon(personaje) {
	}
}	   


