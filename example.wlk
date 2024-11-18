class Linea {
  const numeroDeTelefono
  const packsActivos = [] // sirven para que la línea pueda realizar consumos
  const consumos = []

  // 2) Sacar información de los consumos realizados por una línea:
  // a. Conocer el costo promedio de todos los consumos realizados dentro de un rango de fechas inicial y final.
  method costoPromedio(inicial, final) = self.costosDeConsumosEntre(inicial, final) / self.consumosEntre(inicial, final).size() 

  method costosDeConsumosEntre(inicial, final) = self.consumosEntre(inicial, final).sum({consumo => consumo.costo()})

  method consumosEntre(inicial, final) = consumos.filter({consumo => consumo.consumidoEntre(inicial, final)})

  // b. Conocer el costo total que gastó la línea entre todos los consumos de los últimos 30 días.
  method costoTotaldeLosUltimos30dias() = self.consumosEntre(new Date().minusMonths(1), new Date()).sum({consumo => consumo.costo()})


  method agregarPack(pack) {
    packsActivos.add(pack)
  }
}

// 1) Conocer el costo de un consumo realizado
class Consumo {
  const property fecha = new Date()

  method costo() // metodo abstracto

  method consumidoEntre(x,y) = fecha.between(x, y) 
}

class ConsumoInternet inherits Consumo {
  const property cantidadMB

  override method costo() = cantidadMB * pdepfoni.precioPorMB()  
}

class ConsumoLlamada inherits Consumo {
  const property cantidadSeg

  method cobrarDespuesDe30segundos() = if(cantidadSeg > 30) cantidadSeg - 30 else 0

  override method costo() = pdepfoni.precioFijoLlamadas() + (self.cobrarDespuesDe30segundos()) * pdepfoni.precioPorSegundo()
}


// -- PACKS --

// 3) Saber si un pack puede satisfacer un consumo.
// Por ejemplo, un pack de 100MB libres satisface un consumo de internet de 5 MB, 
// pero una llamada de 60 segundos no puede ser satisfecha por ese pack. 
// Por otro lado, un pack de $100 de crédito satisface ambos consumos (con los precios del ejemplo del punto 1).

class Pack {
  method puedeSatisfacer(consumo)
}

class Credito inherits Pack { // Cierta cantidad de crédito disponible.
  var cantidadCredito

  //override method puedeSatisfacer(consumo) = 
}

class MbsLibres inherits Pack { // Una cant de MB libres para navegar por Internet.
  var cantidadMbs

  override method puedeSatisfacer(consumo) = cantidadMbs >= consumo.costo()
}

class LlamadasGratis inherits Pack {
  //override method puedeSatifacer(consumo) = 
}

object pdepfoni {
  const property precioPorMB = 0.10
  const property precioPorSegundo = 0.05
  const property precioFijoLlamadas = 1
}