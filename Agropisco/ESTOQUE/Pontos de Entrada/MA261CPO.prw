#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
User Function MA261CPO( ) 
Local aTam := {}
aTam := TamSX3('D3_NROOS')
Aadd(aHeader, {'Nro.Ord.Serv.' , 'D3_NROOS' , PesqPict('SD3', 'D3_NROOS' , aTam[1]) , aTam[1], aTam[2], '', USADO, 'C', 'SD3', ''})


Return Nil
