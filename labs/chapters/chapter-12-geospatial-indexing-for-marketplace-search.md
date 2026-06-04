# Lab - Chapter 12

## Chapter

- [Back to Chapter 12](../../chapters/chapter-12-geospatial-indexing-for-marketplace-search.md)

## Drill de 3 Minutos

Responda em voz alta. Nao escreva; use o gabarito logo abaixo para corrigir na hora.

- modelem uma busca `nearby` para um marketplace pequeno com fornecedores moveis
- escolham uma resolucao unica para o bucket espacial e defendam por que ela cabe no raio real do produto
- expliquem a busca em duas fases: candidatos por celula vizinha e filtro final por distancia exata
- digam qual metrica faria voces subir ou descer a resolucao hoje
- digam qual erro de desenho esse experimento precisa evitar: borda de celula, localizacao velha ou bucket fino demais

## Gabarito Oral Imediato

- `Resposta curta`: a celula serve para gerar candidatos baratos; a distancia exata confirma se eles realmente estao perto o bastante.
- `Resposta curta`: a resolucao boa cabe no raio real do produto e gera um conjunto de candidatos administravel.
- `Resposta curta`: candidatos demais ou candidatos bons demais ficando fora mostram resolucao errada.
- `Armadilha`: "a celula ja e a resposta". Nao. Ela e o atalho para voltar a calcular distancia no conjunto certo.
