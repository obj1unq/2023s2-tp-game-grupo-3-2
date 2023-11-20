import wollok.game.*
import personajePrincipal.*
import direcciones.*
import zombies.*
import elementos.*
import randomizer.*
import nivel.*
import armas.*

class Mapa {

	const property celdas

	method generar() {
		game.width(celdas.anyOne().size())
		game.height(celdas.size())
		(0 .. game.width() - 1).forEach({ x => (0 .. game.height() - 1).forEach({ y => self.generarCelda(x, y)})})
	}

	method generarCelda(x, y) {
		const celda = celdas.get(y).get(x)
		celda.generar(game.at(x, y))
	}

}

object mapaNivel1 inherits Mapa(celdas = [ 
		[a,a,a,a,a,a,a,a,a,a,a,a,a,a,a],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,t,_,_,n,_,_,_,_,_,_,c,_],
		[_,_,_,_,_,_,_,_,_,e,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,e,_,_,e,_,_,_,_,_,_,n,_,_],
		[_,_,_,_,_,_,_,_,y,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,r,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,n,_,_,_,r,_],
		[_,_,m,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]
	].reverse()) {

}

object mapaNivel2 inherits Mapa(celdas = [ 
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,m,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]
	].reverse()) {

}

class Objeto {

	const property position
	const property image

	method contacto(personaje) {
	}

	method impactoDeBala(elemento) { // Elimina imagen y evento de disparo si colisiona con objeto
		game.removeVisual(elemento)
		game.removeTickEvent("disparar")
	}

	method solido() {
		return true
	}
    method impactoDeLanza(elemento) { // Elimina imagen y evento de disparo si colisiona con objeto
		game.removeVisual(elemento)
		game.removeTickEvent("lanzar")
	}
}

object _ {

	method generar(position) {
	}

}

object m { // Personaje principal

	method generar(position) {
		mago.position(position)
	}

}

object a { // Arbol quemado

	method generar(position) {
		game.addVisual(new Objeto(position = position, image = "arbol_quemado.png"))
	}

}

object n { // Arbol normal

	method generar(position) {
		game.addVisual(new Objeto(position = position, image = "arbol_normal.png"))
	}

}

object e { // Arbol cortado

	method generar(position) {
		game.addVisual(new Objeto(position = position, image = "arbol_cortado.png"))
	}

}

object r { // Roca 1

	method generar(position) {
		game.addVisual(new Objeto(position = position, image = "roca1.png"))
	}

}

object y { // Roca 2

	method generar(position) {
		game.addVisual(new Objeto(position = position, image = "roca2.png"))
	}

}

object f { // Arma tipo fuego

	method generar(position) {
		game.addVisual(armaFuego)
	}

}

object c inherits Objeto(position = game.at(11, 9), image = "cueva.png"){ 

	method generar(position) {
		game.addVisual(self)
	}
	
	override method solido() {
		return false
	}
	
	method esUnArma() {
		return false
	}
	
	override method contacto(personaje) {
		// Validar si puede pasar de nivel - Cambiar a nuevo mapa
	}

	method pasarNivel() {
		
	} // crear metodo para pasar de nivel cuando se cumpla el objetivo de monedas y colisione con objeto

}

object t {

	method generar(position) {
		game.addVisual(new Objeto(position = position, image = "totem.png"))
	}

}

