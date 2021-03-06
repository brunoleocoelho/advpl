#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

User Function ListBox1()

Private oDlg
Private oLbx1,oLbx2,oLbx3,oLbx4
Private oFld
Private oBtn  
Private oFont1        := TFont():New( "Calibri",0,16,,.T.,0,,700,.T.,.F.,,,,,, )  
Private oFont2		 := TFont():New( "Arial",0,24,,.T.,,,,.F.,.F.,,,,,, )   

Private aTitles	:= {"Cliente","Fornecedor","Produto","Unidades"}
Private aCliente	:= {{"","","","","","//"}}
Private aFornece	:= {{"","","","",""}}
Private aProdutos	:= {{"","","",""}}
Private aUn		:= {{"","","",""}}
 
oDlg := MsDialog():New(000,000,550,950,"Exemplo de LisBox",,,.F.,,,,,,.T.,,,.T.) 

// Criando abas 
oFld := tFolder():New(025,005,aTitles,{},oDlg,,,,.T.,.F.,468,228)

fCarregaDados() // Chamando a rotina para alimentar as array. 

//===================================================================== Folder 1 - Cliente ======================================================================
//Estrutura do listBox com campos
@ 005,005 LISTBOX oLbx1 FIELDS HEADER "Cod.Cliente","Loja","Nome ","Estado","Ultima Compra","Bloqueado" SIZE 456,205 PIXEL OF oFld:aDialogs[1]
oLbx1:SetArray(aCliente)
oLbx1:bLine := { || {	aCliente[oLbx1:nAt,01],	aCliente[oLbx1:nAt,02],	aCliente[oLbx1:nAt,03],	aCliente[oLbx1:nAt,04],;
								aCliente[oLbx1:nAt,05],	aCliente[oLbx1:nAt,06]}}  
// Metodo de clique duplo no listBix
oLbx1:bLDblClick := {|| Alert('DblClick Cliente') }

								
//===================================================================== Folder 2 - aFornece ======================================================================
@ 005,005 LISTBOX oLbx2 FIELDS HEADER 	"Cod.Forne","Loja","Nome"," UF ","Bloqueado" SIZE 456,205 PIXEL OF oFld:aDialogs[2]
oLbx2:SetArray(aFornece)
oLbx2:bLine := { || {aFornece[oLbx2:nAt,01],	aFornece[oLbx2:nAt,02],	aFornece[oLbx2:nAt,03],	aFornece[oLbx2:nAt,04],	aFornece[oLbx2:nAt,05]}} 							

// Metodo de clique duplo no listBix
oLbx2:bLDblClick := {|| Alert('DblClick Fornecedor') }  
							
//===================================================================== Folder 3 - aProdutos ======================================================================
@ 005,005 LISTBOX oLbx3 FIELDS HEADER 	"Produto ","Descri�ao ", "Tipo ","Bloqueado" colsizes 35,25,50,20, SIZE 456,205 PIXEL OF oFld:aDialogs[3]
oLbx3:SetArray(aProdutos)
oLbx3:bLine := { || {	aProdutos[oLbx3:nAt,01],aProdutos[oLbx3:nAt,02],aProdutos[oLbx3:nAt,03],aProdutos[oLbx3:nAt,04] } } 							

// Metodo de clique duplo no listBix
oLbx3:bLDblClick := {|| Alert('DblClick Produto') }  
//=========================== nova aba
@ 005,005 LISTBOX oLbx4 FIELDS HEADER 	"UN","Unidade","Desc. Portugues","Desc. Ingles" SIZE 456,205 PIXEL OF oFld:aDialogs[4]
oLbx4:SetArray(aUn)
oLbx4:bLine := { || {aUn[oLbx4:nAt,01],	aUn[oLbx4:nAt,02],	aUn[oLbx4:nAt,03],	aUn[oLbx4:nAt,04]}} 							

// Metodo de clique duplo no listBix
oLbx4:bLDblClick := {|| U_posic() } 
//====================

oBtn := tButton():New(258,435,"Sair",oDlg,{||Sair()},036,012,,,,.T.,,"",,,,.F.)

ACTIVATE MSDIALOG oDlg CENTERED


Return( NIL )

//******************************************************************************************************

Static Function fCarregaDados() 

Local cAliasFor := GetNextAlias()  //Criando um alias de memoria 
Local cAliasProd := GetNextAlias() //Criando um alias de memoria  
Local cAliasUnid := GetNextAlias()                                   
Local cSql      := ""
                                                
// 1�  Folder Cliente

dbSelectArea("SA1")
SA1->( dbSetOrder(1) )
SA1->( dbGoTop())

aCliente := {}

While ! SA1->( EOF() ) 

		aAdd ( aCliente, { SA1->A1_COD   ,;
 	  				          SA1->A1_LOJA  ,;
 	  				          SA1->A1_NREDUZ,;
 	  				          SA1->A1_EST   ,;
 	  				          SA1->A1_ULTCOM,;
 	  				      IIF( SA1->A1_MSBLQL <> "1" , "N�o","Sim" ) } )             

	SA1->(dbSkip())

EndDo

 If Empty(aCliente)
	aCliente	:=	{{"","","","","","//"}}
 EndIf	            

//******************************************************************************

// 2�  Folder Fornecedor   


cSql :=" Select A2_COD,   "
cSql +="	   A2_LOJA,      "
cSql +="       A2_NREDUZ, "
cSql +="       A2_EST,    "
cSql +="       A2_MSBLQL  "
cSql +=" From " + RetSQLName("SA2") 
cSql +="  Where A2_FILIAL = '" + xFilial("SA2") + "'"
cSql +="  AND D_E_L_E_T_ = ' '  "

cSql := ChangeQuery(cSql)

//Criando um alias virtual com os dados do SQL
dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cSql),(cAliasFor), .F., .T.)

If Select( cAliasFor ) == 0
	(cAliasFor)->( dbCloseArea() )
EndIf	

 dbSelectArea( cAliasFor )
 (cAliasFor)->( dbGoTop() )
 
 aFornece	:=	{}
   
While ! (cAliasFor)->( EOF() ) 
	                              
        AADD ( aFornece, { (cAliasFor)->A2_COD   ,;
 	  				            (cAliasFor)->A2_LOJA  ,;
 	  					        (cAliasFor)->A2_NREDUZ,;
 	  						     (cAliasFor)->A2_EST   ,;
 	  				       IIF( (cAliasFor)->A2_MSBLQL <> "1" , "N�o","Sim" ) } )             

	   (cAliasFor)->(dbSkip())

EndDo

 If Empty(aFornece) 
	aFornece	:=	{{ "","","","","" }}
 EndIf	            


//******************************************************************************

// 3�  Folder Produto

////Criando um alias virtual com os dados do SQL
BeginSql Alias cAliasProd

	SELECT B1_COD, 
		    B1_DESC, 
		  	 B1_TIPO, 
			 B1_UM, 
			 B1_MSBLQL 
	FROM %Table:SB1%
		WHERE B1_FILIAL =  %xFilial:SB1%
		AND %NotDel%
EndSQL
        

If Select( cAliasProd ) == 0
	//Ao criar o alias virtual na memoria necessairo fechar, pois o sistema n�o reconhece como tabela padr�o
	//ficando aberta ate fechar a thread
	(cAliasFor)->( dbCloseArea() )
	
EndIf	     

 dbSelectArea( cAliasProd )
 (cAliasProd)->( dbGoTop() ) 
 
 aProdutos := {} 

While ! (cAliasProd)->(EOF())
        
	 AADD ( aProdutos, {    (cAliasProd)->B1_COD   ,;
	 					 	  (cAliasProd)->B1_DESC   ,;
							  (cAliasProd)->B1_TIPO   ,;
						  IIF((cAliasProd)->B1_MSBLQL <> "1" , "N�o","Sim" ) } )  

	(cAliasProd)->( dbSkip() )

EndDo           

 If Empty(aProdutos) 
	aProdutos	:=	{{ "","","","" }}
 EndIf	  
//******************************************************************************************************
// 4 aba
BeginSql Alias cAliasUnid

SELECT ah_unimed, 
       ah_umres, 
       ah_descpo, 
       ah_descin 
	FROM %Table:SAH%
		WHERE AH_FILIAL =  %xFilial:SAH%
		AND %NotDel%
EndSQL
        

If Select( cAliasUnid ) == 0
	//Ao criar o alias virtual na memoria necessairo fechar, pois o sistema n�o reconhece como tabela padr�o
	//ficando aberta ate fechar a thread
	(cAliasUnid)->( dbCloseArea() )
	
EndIf	     

 dbSelectArea( cAliasUnid )
 (cAliasUnid)->( dbGoTop() ) 
 
 aUn := {} 

While ! (cAliasUnid)->(EOF())
        
	 AADD ( aUn, {    (cAliasUnid)->AH_UNIMED   ,;
	 					 	  (cAliasUnid)->AH_UMRES   ,;
							  (cAliasUnid)->AH_DESCPO   ,;
						  	  (cAliasUnid)->AH_DESCIN } )  

	(cAliasUnid)->( dbSkip() )

EndDo           

 If Empty(aUn) 
	aUn	:=	{{ "","","","" }}
 EndIf	
// 4 aba, unidades


Return( NIL )




//------------------
Static Function Sair()

	oDlg:END()	

Return( NIL )

User Function posic()
	MsgInfo("estou na posicao " + aUn[oLbx4:nAt,02])
Return (nil)

//******************************************************************************************************
