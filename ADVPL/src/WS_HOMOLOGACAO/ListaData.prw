#Include 'Protheus.ch'
#Include 'apWebSRV.ch'


WSService LISTA_DATA Description "Mostra a data de Hoje."
		
	WsData dData 		as String
	WsData Parametro 	as String
	WSData cHora 		as String
	
	WsMethod MostraData Description "Informa a data"
	WsMethod MostraHora Description "Informa a hora"
	
EndWSService	


WsMethod MostraData WsReceive Parametro WsSend dData WsService LISTA_DATA 

::dData := Dtos ( date() )

Return .T.


WsMethod MostraHora WsReceive Parametro WsSend cHora WsService LISTA_DATA 

::cHora := Time()

Return .T.