import wollok.game.*
import personajePrincipal.*
import direcciones.*
import zombies.*
import elementos.*

object randomizer {
		
	method position() {
		return 	game.at( 
					(0 .. game.width() - 1 ).anyOne(),
					(0..  game.height() - 1).anyOne()
		) 
	}
	
	method emptyPosition() {
		const position = self.position()
		if(game.getObjectsIn(position).isEmpty()) {
			return position	
		}
		else {
			return self.emptyPosition()
		}
	}
	method yCualquiera() {
		return (0..  (game.height()-2) ).anyOne()
	}
	method xCualquiera() {
		return (0..  (game.width()-2) ).anyOne()
	}

}
