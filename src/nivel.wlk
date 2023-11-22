import wollok.game.*
import personajePrincipal.*
import direcciones.*
import enemigos.*
import elementos.*
import armas.*
import randomizer.*
import mapa.*

object escenario {
	var nivel 
	
	 method configuracionSonido() {
    	const sonido = game.sound("musica.mp3")
    	game.schedule(200,{sonido.play()})
    }
	method inciarNivel(nuevoNivel) {
		nuevoNivel.iniciarNivel()
		nivel = nuevoNivel
	}
	method pasarNivel() {
	   const segundoNivel = new Nivel2()
	   self.inciarNivel(segundoNivel)
 	}
	method perdiste(){
		const gameOver = new PortadaNivel(fondo= fondoGameOver) 
		self.inciarNivel(gameOver)
	}
	method ganaste() {
		const winner = new PortadaNivel(fondo= fondoWinner) 
		self.inciarNivel(winner)
	}
	method empezar() {
		const comienzo = new PortadaNivel(fondo= inicioJuego) 
		self.inciarNivel(comienzo)
	}
		
}
class Nivel {

	const property mapa

	method configuracionTeclado() { // Configuración de teclado para todos los niveles
		keyboard.up().onPressDo({ mago.mover(arriba)})
		keyboard.down().onPressDo({ mago.mover(abajo)})
		keyboard.left().onPressDo({ mago.mover(izquierda)})
		keyboard.right().onPressDo({ mago.mover(derecha)})
		keyboard.w().onPressDo({ mago.tirarHechizo()})
		keyboard.a().onPressDo({ mago.agarrar()})
	}

	method iniciarNivel() { 
	    monedero.cantidadMonedas(0)
	    mago.vida(10)
	    mago.llevando(libre)
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
    	game.onTick(100, "AGARRAR", {mago.cambiarArma()})
    }
    method vaciarAdministradores()
    
    method administradores()
	
}

class Nivel1 inherits Nivel (mapa = mapaNivel1) {
	
       override method 	vaciarAdministradores() {
       	    administradorEnemigos.enemigos().clear()
    	    administradorPociones.pociones().clear()
    	    administradorFuegos.fuegos().clear()
       }
       
	   override method administradores() {
	   	   game.onTick(1000, "HORDA", {administradorEnemigos.generarEnemigos()})
           game.onTick(2000, "MORDER", {administradorEnemigos.ataqueEnemigo()})
           game.onTick(5000, "POCIONES", {administradorPociones.generarPociones()})
           game.onTick(3000, "LANZAS", {administradorFuegos.generarFuegos()})
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

class Nivel2 inherits Nivel (mapa = mapaNivel2){ 
	
       override method 	vaciarAdministradores() {
       	    administradorEnemigos.enemigos().clear()
    	    administradorPociones.pociones().clear()
    	    administradorFuegos.fuegos().clear()
       }
       
	   override method administradores() {
	   	administradorJefe.generarJefeFinal()
		game.onTick(750, "ATAQUEJEFE",{administradorJefe.ataqueJefe()})
		game.onTick(5000, "ORDAMAGOS", {administradorMagosFinal.generarEnemigos()})
		game.onTick(3000, "ATAQUEMAGOS", {administradorMagosFinal.ataqueEnemigo()})
		game.onTick(5000, "POCIONES", {administradorPociones.generarPociones()})
        game.onTick(3000, "LANZAS", {administradorFuegos.generarFuegos()})
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
class PortadaNivel inherits Nivel(mapa=null) {
	const fondo 
	
	override method iniciarNivel() {
		self.removerNivel()
		self.configuracionFondo()
		self.configuracionTeclado()
	}	
	
	override method configuracionFondo(){
		game.addVisual(fondo)		
	}
	
	override method configuracionTeclado() {
		const primerNivel = new Nivel1()
		keyboard.x().onPressDo({ escenario.inciarNivel(primerNivel)})
		keyboard.z().onPressDo({ game.stop()})
	}
	
	override method vaciarAdministradores() {
		
	}
	
	override method administradores() {
		
	}	
}

object fondoGameOver {
	
	var property position = game.at(0, 0)

	 method image() = "imagen.gameOver.jpg"

	 method chocasteCon(personaje) {
	}
	
}	
   
object fondoWinner {
	var property position = game.at(0, 0)

	 method image() = "imagen.winner.jpg"

	 method chocasteCon(personaje) {
	}
	
}

object inicioJuego {
	var property position = game.at(0, 0)

	 method image() = "imagen.inicioJuego.jpg"

	 method chocasteCon(personaje) {
	}
	
}	

