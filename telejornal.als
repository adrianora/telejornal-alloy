module telejornal

abstract sig Telejornal {
	apresentadores: one Apresentador,
	reporteresApresentadores: set ReporteresApresentadores
}
sig TeleJornalManha extends Telejornal {}
sig TeleJornalTarde extends Telejornal {}
sig TeleJornalNoite extends Telejornal {}

abstract sig Apresentador {
	roteiro: one Roteiro
}
sig ApresentadorManha extends Apresentador {}
sig ApresentadorTarde extends Apresentador {}
sig ApresentadorNoite extends Apresentador {}

sig Redacao {
	roteiro: one Roteiro,
	equipe: one EquipeReporteres
}

sig Roteiro {
	noticias: set Noticia
}

sig Reporter {}

sig EquipeReporteres {
	reporteres: set Reporter
}

sig ReporteresApresentadores {
	reporteresApresentadores: set Reporter
}

abstract sig Noticia {}
sig Entretenimento extends Noticia {}
sig Saude extends Noticia {}
sig Educacao extends Noticia {}
sig Politica extends Noticia {}
sig Violencia extends Noticia {}
sig Esporte extends Noticia {}

//setup para modelo de 1 telejornal
pred setup {
	#Telejornal = 1
	#Apresentador = 1
	#Redacao = 1
	#Roteiro = 1
	#Reporter = 10
	#EquipeReporteres = 1
	#ReporteresApresentadores = 1
}

//roteiros nao podem ter mais de 3 noticias de uma mesma categoria
pred max_roteiro_por_categoria {
	#Entretenimento <= 3
	#Saude <= 3
	#Educacao <= 3
	#Politica <= 3
	#Violencia <= 3
	#Esporte <= 3
}

-- funcoes
fun get_apresentadores_telejornal[t: Telejornal]: one Apresentador {
	t.apresentadores
}

fun get_reporteres_telejornal[t: Telejornal]: set ReporteresApresentadores {
	t.reporteresApresentadores
}

-- fatos
fact{
	setup
	max_roteiro_por_categoria


	all t:Telejornal | #(t.apresentadores) = 1
	all t:Telejornal | #(t.reporteresApresentadores) = 1

	all p:ReporteresApresentadores | #(p.reporteresApresentadores) = 4

	all e:EquipeReporteres | #(e.reporteres) = 10
	
	all r:Roteiro | #(r.noticias) = 10
}

-- tests
assert modeloDeTeste {
	all t:TeleJornalManha | t.apresentadores = ApresentadorManha
}

check modeloDeTeste

-- run
pred show[]{}
run show for 10
