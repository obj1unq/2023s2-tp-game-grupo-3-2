import wollok.game.*
import personajePrincipal.*
import direcciones.*
import enemigos.*
import elementos.*

object randomizer {

	method position() {
		return game.at((1 .. game.width() - 2 ).anyOne(), (1 .. game.height() - 2).anyOne())
	}

	method emptyPosition() {
		const position = self.position()
		if (game.getObjectsIn(position).isEmpty()) {
			return position
		} else {
			return self.emptyPosition()
		}
	}

	method yCualquiera() {
		return (2 .. (game.height() - 2) ).anyOne()
	}

	method xCualquiera() {
		return (0 .. (game.width() - 2) ).anyOne()
	}

}

