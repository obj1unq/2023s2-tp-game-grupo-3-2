import wollok.game.*
import personajePrincipal.*
import direcciones.*
import zombies.*
import elementos.*

object randomizer {
		// Actualize el randomizer para que tanto las posiciones y enemigos no toquen las celdas
		// donde estan el corazon y el monedero. Puse 1 para que no este en los bordes.
	method position() {
		return 	game.at( 
					(1 .. game.width() - 2 ).anyOne(),
					(1..  game.height() - 2).anyOne()
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
		return (1..  (game.height()-2) ).anyOne()
	}
	method xCualquiera() {
		return (0..  (game.width()-2) ).anyOne()
	}

}
