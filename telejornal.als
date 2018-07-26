module telejornal

one abstract sig Telejornal {
	reporteres: one ReporteresApresentadores,
	redacao: one Redacao
}
sig TelejornalManha extends Telejornal {
	apresentador: one ApresentadorManha
}
sig TelejornalTarde extends Telejornal {
	apresentador: one ApresentadorPermutado
}
sig TelejornalNoite extends Telejornal {
	apresentador: one ApresentadorPermutado
}

one abstract sig Apresentador {
	roteiro: one Roteiro
}
sig ApresentadorManha extends Apresentador {}

abstract sig ApresentadorPermutado extends Apresentador {}
sig ApresentadorTarde extends ApresentadorPermutado {}
sig ApresentadorNoite extends ApresentadorPermutado {}

one sig Redacao {
	roteiro: one Roteiro,
	equipe: one EquipeReporteres
}

one sig Roteiro {
	noticias: set Noticia
}

sig Reporter {}

one sig EquipeReporteres {
	reporteres: set Reporter
}

one sig ReporteresApresentadores {
	reporteres: set Reporter
}

abstract sig Noticia {}
some sig Entretenimento extends Noticia {}
some sig Saude extends Noticia {}
some sig Educacao extends Noticia {}
some sig Politica extends Noticia {}
some sig Violencia extends Noticia {}
some sig Esporte extends Noticia {}

-- predicados

//regras de integridade
pred setup {
	#Reporter = 10
	#Noticia <= 10
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
fun get_apresentadores_telejornal[t:Telejornal]: set ReporteresApresentadores {
	t.reporteres
}

fun get_reporteres_da_equipe[e:EquipeReporteres]: set Reporter {
	e.reporteres
}

fun get_noticias_roteiro[r:Roteiro]: set Noticia {
	r.noticias
}

-- predicados
pred reporter_apresentador {
	#ReporteresApresentadores.reporteres = 4
}

pred equipe_reporteres {
	all e:EquipeReporteres | #get_reporteres_da_equipe[e] = 10
}

pred noticias_em_roteiro {
	all r:Roteiro | #get_noticias_roteiro[r] = 10
}

pred instancias_noticias_em_roteiro {
	all n:Noticia, r:Roteiro | n in get_noticias_roteiro[r]
}

-- fatos
fact {
	setup
	max_roteiro_por_categoria
	reporter_apresentador
	equipe_reporteres
	instancias_noticias_em_roteiro
}

-- tests
assert teste_reporteres_da_equipe {
	all e:EquipeReporteres | #(e.reporteres) = 10
}

assert teste_numero_noticias {
	all r:Roteiro | #(r.noticias) = 10
}

assert teste_noticias_dentro_do_roteiro {
	lone n:Noticia, r:Roteiro | n in get_noticias_roteiro[r]
}

check teste_reporteres_da_equipe
check teste_numero_noticias
check teste_noticias_dentro_do_roteiro

-- run
pred show[]{}
run show for 10
