# Chapter 06 - JavaScript and TypeScript Interview Surface Area

## Slice

O pequeno conjunto de traps e respostas de JavaScript/TypeScript que mais reaparece em entrevistas de backend, frontend infra e full stack.

## Study Context

- `Track order`: `06/06` - perguntas laterais de linguagem e runtime
- `Upstream principal`: [MDN - Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map), [MDN - Set](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set), [MDN - Array.prototype.sort](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)
- `Upstream complementar`: [TypeScript Handbook - Narrowing](https://www.typescriptlang.org/docs/handbook/2/narrowing.html)
- `Pontes locais`: [React / React Native Story Bank](../../../../interview/story-bank/02-react-react-native-story-bank.md), [REST API Design](../../../../areas/09-backend-principles/cards/rest-api-design.md)
- `Review card`: [Card 06](../reviews/cards/06-javascript-and-typescript-interview-surface-area.md)

## Why This Matters In Interviews

Muita gente boa erra nao por algoritmo, mas por semantica de linguagem:
- `sort()` ordenando como string
- `Object` usado como se fosse `Map`
- `any` apagando o valor do TypeScript
- fila implementada com `shift()`

## The Core Questions

### 1. Map vs Object?

Resposta forte:
- `Object` e bom para shape conhecido
- `Map` e melhor para dicionario dinamico, chaves arbitrarias, `has/get/set/delete` e iteracao previsivel

Boa fala:
- "para frequencia em problema DSA eu prefiro `Map`; para record fixo vindo do dominio eu prefiro `Object`"

### 2. Set vs Array?

Resposta forte:
- `Set` para unicidade e membership
- `Array` para ordem e indexacao

Boa fala:
- "se a operacao principal e `ja vi isso?`, `Set` economiza trabalho e expressa melhor a intencao"

### 3. Por que `sort()` pode quebrar?

Sem comparator:

```ts
[10, 2, 1].sort(); // [1, 10, 2]
```

Com comparator:

```ts
const nums = [10, 2, 1];
nums.sort((a, b) => a - b);
```

Fale tambem:
- `sort()` muta o array
- complexidade depende da implementacao

### 4. Como fazer queue sem custo escondido?

Resposta forte:
- usar array + ponteiro `head`
- evitar `shift()` em loop grande

```ts
const queue: number[] = [0];
let head = 0;

while (head < queue.length) {
  const current = queue[head];
  head += 1;
}
```

### 5. `unknown` vs `any`?

- `any` desliga o compilador
- `unknown` obriga narrowing antes de usar

Boa fala:
- "eu uso `unknown` na fronteira externa e reduzo com guard; `any` so entra quando estou encapsulando algo realmente dinamico"

### 6. Como modelar resposta segura em TypeScript?

```ts
type Result<T> =
  | { ok: true; value: T }
  | { ok: false; error: string };

function parseId(input: string): Result<number> {
  const value = Number(input);

  if (!Number.isInteger(value)) {
    return { ok: false, error: "Invalid integer" };
  }

  return { ok: true, value };
}
```

Isso mostra:
- union discriminada
- narrowing por branch
- nenhuma necessidade de `any`

### 7. Promise.all vs Promise.allSettled?

- `Promise.all`
  - falha rapido se uma promise rejeita
  - bom quando todas precisam dar certo
- `Promise.allSettled`
  - recolhe sucesso e falha de todas
  - bom para agregacao tolerante a erro

### 8. Event loop basico: o que importa responder?

Resposta forte:
- JS executa codigo userland em thread principal
- I/O e timers voltam pelo loop
- CPU-bound trava o progresso do processo

Boa fala:
- "para throughput de backend Node, eu separo I/O-bound de CPU-bound e nao escondo CPU cara atras de `async`"

### 9. `type` vs `interface`?

Resposta forte:
- ambos servem para modelar shapes
- `interface` encaixa bem para contratos extensivos e declaration merging
- `type` e mais flexivel para unions, tuples e aliases compostos

Nao force dogma. O importante e consistencia e clareza.

## Interview Traps That Reappear

- tratar `Promise.all` como se executasse CPU pesado em paralelo magico
- usar `sort()` sem comparator
- usar `Object` e depois esquecer `hasOwnProperty` / colisao de chaves especiais
- abusar de generic sem necessidade
- usar `any` onde um union simples resolveria

## Interview Compression

- `15 segundos`: Map/Set, sort comparator, queue com head pointer e unions discriminadas pagam muito aluguel.
- `15 segundos`: TypeScript forte em entrevista nao e exibicao de generic; e seguranca simples e clara.
- `1 minuto`: JavaScript/TypeScript bom em entrevista evita traps de runtime e usa o type system para fechar fronteira, nao para impressionar.

## Decision Synthesis

### Use When

- voce esta preparando entrevistas JS/TS ou full stack
- quer limpar traps recorrentes de linguagem
- precisa responder follow-ups de runtime sem decorar internals exoticos

### Why This Matters

- os erros mais caros aqui sao silenciosos
- semantica ruim derruba algoritmo certo
- TypeScript bem usado sinaliza disciplina de fronteira

### Main Trade-offs

- tipagem excessiva sem ganho real atrasa
- pouco tipo demais empurra erro para runtime
- micro-otimizacao em array antes de clareza nao ajuda

### Warning Signs

- voce usa `Object` para tudo
- `sort()` sem comparator passa despercebido
- `any` aparece onde um union resolveria
- voce fala "Node e paralelo" sem qualificar o tipo de trabalho

## Production Recall

- `Pergunta`: quais traps de JavaScript/TypeScript mais reaparecem em entrevistas?
- `Resposta com as suas palavras`: Map vs Object, Set vs Array, sort comparator, queue com `shift()`, `unknown` vs `any`, unions discriminadas, Promise concurrency e event loop basico.
- `Resposta ruim`: eu sei React, entao o resto vem automatico.
- `Troque por isto`: linguagem e runtime ainda cobram precision basic e follow-up forte.

## Fixacao Relampago

- `Pergunta`: o que diferencia uma resposta forte de TypeScript em entrevista?
- `Resposta curta`: modelar fronteiras e estados com tipos simples, seguros e claros, sem cair em `any`.
- `Armadilha`: usar generic e utilitario complexo para parecer avancado.
- `Correcao`: clareza e narrowing valem mais do que exibicao.
