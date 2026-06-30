# Review Card 06 - JavaScript and TypeScript Interview Surface Area

## Linked Material

- [Chapter 06](../../chapters/06-javascript-and-typescript-interview-surface-area.md)

## Anchor

- `Problema`: algoritmo certo pode fracassar por trap de linguagem ou runtime mal explicado.
- `Decisao`: priorizar semantica de base, colecoes certas e TypeScript simples e seguro.

## Cue Signal

- `Sinal`: `sort()` sem comparator, `shift()` em loop ou `any` por reflexo.

## Case/Bridge Anchor

- `Ponte`: [REST API Design](../../../../../areas/09-backend-principles/cards/rest-api-design.md), [React / React Native Story Bank](../../../../../interview/story-bank/02-react-react-native-story-bank.md)

## QDSAA Recall

- `Requirement corrigido`: o importante e fechar fronteira e evitar traps de runtime, nao parecer engenhoso com tipo exotico.
- `Delete`: `any` e estruturas erradas por costume.
- `Forma simples`: Map/Set, sort comparator, queue com head pointer, union discriminada e event loop basico.

## Trade-off to Remember

- `Custo`: tipo demais sem ganho real atrasa.
- `Failure mode`: tipagem frouxa demais empurra erro para runtime.

## Trap

- `Resposta ruim`: "eu sei React, entao nao preciso revisar JavaScript/TypeScript basico".
- `Troque por isto`: "semantica de linguagem e runtime ainda define se o codigo e correto e defendivel".

## 1-Minute Answer

JavaScript/TypeScript forte em entrevista significa escolher a colecao certa, evitar mutacao e custo escondidos, explicar o minimo necessario de event loop e usar tipos simples para fechar estados e fronteiras sem cair em `any`.
