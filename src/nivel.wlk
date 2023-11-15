import wollok.game.*
import personajePrincipal.*
import direcciones.*
import zombies.*
import elementos.*
import randomizer.*
import mapa.*

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
        game.addVisual(new ArbolQuemado(position = position) )
	}
}
object r {
	method generar(position) {
        game.addVisual(new Roca(position = position, numeroRoca = 1) )
	}
}
object f {
	method generar(position) {
        game.addVisual(armaFuego)
	}
}
object mapa {
	var celdas = [
		[a,a,a,a,a,a,a,a,a,a,a,a,a,a,a],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,a,_,_,_,_,_,_,_,_,_],
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