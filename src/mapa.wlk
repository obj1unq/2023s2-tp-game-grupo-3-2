import wollok.game.*
import personajePrincipal.*
import direcciones.*
import zombies.*
import elementos.*
import randomizer.*
import nivel.*

object _ {
	
	method generar(position) {
		
	}
}
object m {
	
	method generar(position) {
		mago.position(position)
	}
}

object a {
	method generar(position) {
        game.addVisual(new Objeto(position = position, image = "arbol_quemado.png") )
	}
}

object r {
	method generar(position) {
        game.addVisual(new Objeto(position = position, image = "roca1.png") )
	}
}

object f {
	method generar(position) {
        game.addVisual(armaFuego)
	}
}

object c {
	method generar(position) {
        game.addVisual(new Objeto(position = position, image = "cueva.png") )
	}
	
	method pasarNivel() {} // crear metodo para pasar de nivel cuando se cumpla el objetivo de monedas y colisione con objeto
}

object t {
	method generar(position) {
        game.addVisual(new Objeto(position = position, image = "totem.png") )
	}
}

object mapaNivel1 {
	const celdas = [
		[a,a,a,a,a,a,a,a,a,a,a,a,a,a,a],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,t,_,a,_,_,_,_,_,_,_,c,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,r,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,r,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,m,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]
	].reverse()
	
	method generar() {
		game.width(celdas.anyOne().size())
		game.height(celdas.size())
		(0..game.width() - 1).forEach({x => 
			(0..game.height() - 1).forEach({y =>
				self.generarCelda(x,y)
			})
		})
		     
	}
	method generarCelda(x,y) {
		const celda = celdas.get(y).get(x)
		celda.generar(game.at(x,y))
	}
}