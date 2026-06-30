# Chapter 02 - DSA Core Problems in Ruby and TypeScript

## Slice

Como responder os problemas classicos que reaparecem em entrevistas backend, com pattern certo, codigo limpo e follow-up previsto.

## Study Context

- `Track order`: `02/06` - problemas nucleares e respostas fortes
- `Upstream principal`: [NeetCode 150](https://neetcode.io/practice)
- `Upstream complementar`: [Tech Interview Handbook - Best Practice Questions](https://www.techinterviewhandbook.org/best-practice-questions/), [Ruby Stdlib - Set](https://docs.ruby-lang.org/en/master/Set.html), [MDN - Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map), [MDN - Array.prototype.sort](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort), [TypeScript Handbook - Narrowing](https://www.typescriptlang.org/docs/handbook/2/narrowing.html)
- `Review card`: [Card 02](../reviews/cards/02-dsa-core-problems-in-ruby-and-typescript.md)

## Why This Matters In Interviews

Voce nao precisa memorizar `200` solucoes.

Voce precisa reconhecer `6-8` familias de resposta que cobrem a maior parte do que reaparece.

## Problem Pack

### 1. Two Sum

- `Pattern`: HashMap
- `Raciocinio verbalizavel`:
  - brute force e `O(n^2)` porque eu testo todos os pares
  - o gargalo e procurar complemento repetidamente
  - uso HashMap `valor -> indice`
- `Tempo / espaco`: `O(n)` / `O(n)`
- `Follow-ups`:
  - array ordenado? two pointers
  - todos os pares? tratar duplicados
  - multiplas respostas? combine contrato antes

```ruby
def two_sum(nums, target)
  index_by_value = {}

  nums.each_with_index do |num, index|
    complement = target - num
    return [index_by_value[complement], index] if index_by_value.key?(complement)

    index_by_value[num] = index
  end

  []
end
```

### 2. Longest Substring Without Repeating Characters

- `Pattern`: sliding window variavel
- `Raciocinio verbalizavel`:
  - a janela precisa ficar sempre valida
  - ao encontrar repeticao, movo `left` para depois da ultima aparicao
- `Tempo / espaco`: `O(n)` / `O(min(n, alfabeto))`
- `Follow-ups`:
  - Unicode real? pergunte se pode assumir ASCII
  - substring ou subsequence? muda tudo

```ts
function lengthOfLongestSubstring(input: string): number {
  const lastSeen = new Map<string, number>();
  let left = 0;
  let best = 0;

  for (let right = 0; right < input.length; right += 1) {
    const char = input[right];
    const previous = lastSeen.get(char);

    if (previous !== undefined && previous >= left) {
      left = previous + 1;
    }

    lastSeen.set(char, right);
    best = Math.max(best, right - left + 1);
  }

  return best;
}
```

### 3. Product of Array Except Self

- `Pattern`: prefix + suffix
- `Raciocinio verbalizavel`:
  - sem divisao
  - primeira passada grava produto a esquerda
  - segunda passada multiplica pelo produto a direita
- `Tempo / espaco`: `O(n)` / `O(1)` extra fora do output
- `Follow-ups`:
  - zeros? a abordagem ainda funciona
  - overflow? em JS `number` perde precisao para inteiros grandes

```ruby
def product_except_self(nums)
  result = Array.new(nums.length, 1)
  prefix = 1

  nums.each_index do |i|
    result[i] = prefix
    prefix *= nums[i]
  end

  suffix = 1
  (nums.length - 1).downto(0) do |i|
    result[i] *= suffix
    suffix *= nums[i]
  end

  result
end
```

### 4. Search in Rotated Sorted Array

- `Pattern`: binary search modificado
- `Raciocinio verbalizavel`:
  - uma das metades sempre esta ordenada
  - descubro qual metade esta ordenada
  - verifico se o target mora nela
- `Tempo / espaco`: `O(log n)` / `O(1)`
- `Follow-ups`:
  - duplicados podem degradar o caso para `O(n)`
  - array vazio e tamanho `1` precisam ser citados cedo

### 5. Number of Islands

- `Pattern`: BFS ou DFS em grade
- `Raciocinio verbalizavel`:
  - toda vez que acho terra nao visitada, conto `1` ilha
  - depois afundo todo o componente conectado
- `Tempo / espaco`: `O(rows * cols)`
- `Follow-ups`:
  - diagonal conta?
  - pode mutar o grid?
  - grade gigante pede estrategia de streaming, nao so DFS bonito

```ruby
DIRECTIONS = [[1, 0], [-1, 0], [0, 1], [0, -1]].freeze

def num_islands(grid)
  rows = grid.length
  cols = grid[0]&.length || 0
  islands = 0

  rows.times do |row|
    cols.times do |col|
      next unless grid[row][col] == "1"

      islands += 1
      sink_island(grid, row, col)
    end
  end

  islands
end

def sink_island(grid, start_row, start_col)
  queue = [[start_row, start_col]]
  head = 0
  grid[start_row][start_col] = "0"

  while head < queue.length
    row, col = queue[head]
    head += 1

    DIRECTIONS.each do |dr, dc|
      nr = row + dr
      nc = col + dc
      next if nr.negative? || nc.negative?
      next if nr >= grid.length || nc >= grid[0].length
      next unless grid[nr][nc] == "1"

      grid[nr][nc] = "0"
      queue << [nr, nc]
    end
  end
end
```

### 6. Top K Frequent Elements

- `Pattern`: HashMap + heap ou bucket sort
- `Raciocinio verbalizavel`:
  - primeiro conto frequencia
  - depois escolho mecanismo de top K
  - heap vale quando `k` e pequeno; bucket vale quando quero linearizar por frequencia
- `Tempo / espaco`:
  - heap: `O(n log k)`
  - bucket: `O(n)`
- `Follow-ups`:
  - stream infinito? min-heap de tamanho `k`
  - distribuido? count local, merge global

### 7. LRU Cache

- `Pattern`: HashMap + doubly linked list
- `Raciocinio verbalizavel`:
  - HashMap sozinho nao resolve ordem de uso
  - lista sozinha nao resolve lookup rapido
  - a combinacao entrega `get` e `put` em `O(1)`
- `Tempo / espaco`: `O(1)` por operacao / `O(capacidade)`
- `Follow-ups`:
  - TTL?
  - concorrencia?
  - capacidade por bytes em vez de itens?

### 8. Coin Change

- `Pattern`: DP unidimensional
- `Raciocinio verbalizavel`:
  - `dp[amount]` e o minimo de moedas para formar aquele valor
  - para cada valor, tento todas as moedas
  - a resposta final reaproveita subproblemas menores
- `Tempo / espaco`: `O(amount * coins)` / `O(amount)`
- `Follow-ups`:
  - contar combinacoes em vez de minimo muda a transicao
  - moedas unicas vs infinitas muda o problema

## Knowledge Gaps That Hurt More Than People Admit

- `Big-O basico`
  - nested loop nao vira `O(n)` porque "o computador e rapido"
- `Recursao`
  - precisa de base case e risco de stack overflow
- `Queue vs stack`
  - BFS e DFS nao sao a mesma coisa com nomes diferentes
- `Mutacao escondida`
  - `sort()` e muitas operacoes in-place podem quebrar contrato
- `Precisao numerica`
  - JS `number` nao e inteiro arbitrario

## Practical Drill Pack

O pack executavel fica em `interview/dsa-drills`.

Rode assim a partir da raiz do repo:

```sh
bundle exec rake drills:ruby
npm install --prefix interview/dsa-drills/typescript
bundle exec rake drills:typescript
bundle exec rake drills
```

Use este loop:

1. preveja o pattern e a complexidade antes de abrir o arquivo;
2. rode os testes em Ruby;
3. reescreva a mesma ideia em TypeScript;
4. mude um edge case no teste para provar que voce entendeu o contrato;
5. explique em voz alta qual follow-up senior quebra primeiro a resposta.

## What To Say If You Freeze

Boa resposta:
- "o brute force e testar todos os pares"
- "o gargalo e lookup repetido"
- "um HashMap elimina esse custo"

Resposta ruim:
- "eu lembro que esse problema e de hash"

Nomeie o motivo antes do pattern.

## Interview Compression

- `15 segundos`: mostre o brute force e o gargalo antes do codigo.
- `15 segundos`: os problemas acima cobrem a maior parte do que se repete por pattern.
- `1 minuto`: se voce consegue explicar Two Sum, Sliding Window, Number of Islands, LRU e Coin Change com follow-up, sua base ja mudou de nivel.

## Decision Synthesis

### Use When

- voce quer treino com ROI alto
- precisa conectar problema a pattern, nao a memorizacao
- quer respostas que sobrevivem ao follow-up

### Why This Matters

- o entrevistador normalmente testa familias de problemas
- follow-up bom revela se voce entendeu o mecanismo
- linguagem importa menos do que estrutura, mas traps de linguagem ainda derrubam

### Main Trade-offs

- otimizar cedo demais pode esconder erro de leitura
- explicar demais sem fechar complexidade parece inseguranca
- memorizar codigo sem raciocinio quebra no follow-up

### Warning Signs

- voce nao sabe dizer por que a estrutura escolhida ajuda
- escreve BFS com `shift()` em loop enorme sem notar custo
- usa TypeScript como JavaScript com `any` em todo canto

## Production Recall

- `Pergunta`: quais problemas melhor comprimem o 80/20 de DSA para entrevistas backend?
- `Resposta com as suas palavras`: Two Sum, Longest Substring, Product Except Self, Search Rotated Array, Number of Islands, Top K Frequent, LRU Cache e Coin Change cobrem os patterns que mais reaparecem.
- `Resposta ruim`: eu preciso decorar toda a lista do NeetCode antes de estar pronto.
- `Troque por isto`: eu preciso dominar as familias e saber defender o por que da estrutura escolhida.

## Fixacao Relampago

- `Pergunta`: qual frase voce deve dizer antes de escolher o pattern?
- `Resposta curta`: o gargalo do brute force e este.
- `Armadilha`: "esse eu lembro de cabeca".
- `Correcao`: pattern sem gargalo nomeado nao se sustenta.
