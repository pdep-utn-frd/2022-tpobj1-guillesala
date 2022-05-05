import wollok.game.*
    
const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Contra")
		game.addVisual(suelo)
		game.addVisual(bala)
		game.addVisual(soldado)
		game.addVisual(reloj)
	    game.boardGround("fondocontra (6).png")
		keyboard.space().onPressDo{ self.jugar()}
		
		game.onCollideDo(soldado,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	method    iniciar(){
		soldado.iniciar()
		reloj.iniciar()
		bala.iniciar()
	}
	
	method jugar(){
		if (soldado.estaVivo()) 
			soldado.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		bala.detener()
		reloj.detener()
		soldado.morir()
	}
	
}

object gameOver {
	method position() = game.center()
	method image()= "gameovercontra.png"

}

object reloj {
	
	var tiempo = 0
	method textColor() = paleta.blanco()
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo +1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
}

object bala {
	 
	const posicionInicial = game.at(game.width()-1,suelo.position().y())
	var position = posicionInicial

	method image() = "bala_contra.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverbala",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverbala")
	}
}

object suelo{
	
	method position() = game.origin().up(1)
	
}


object soldado {
	var vivo = true
	var position = game.at(1,suelo.position().y())
	
	method image() = "contraaa1.png"
	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(velocidad*2,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"embrace your dreams")
		muerte.play()
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}
object paleta {
	const property blanco = "FFFFFFFF"
}
object muerte {
	
	method play(){
		game.sound("008842237_prev.mp3").play()
	}
}

