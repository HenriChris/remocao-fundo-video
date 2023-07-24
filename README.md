# Remoção do plano de fundo de vídeos utilizando Mínimos Quadrados Alternados

## Introdução

## Ferramentas básicas

### VideoIO.jl
### Mínimos Quadrados Alternados

## Metodologia
O processo de remoção foi realizado em 5 etapas :
### 1. Separação do vídeo em quadros
### 2. Criar uma matriz da evolução temporal de cada coluna do vídeo
### 3. Aplicar Mínimos Quadrados Alternados em cada uma das matrizes de evolução temporal
### 4. Subtrair o plano de fundo obtido na etapa anterior de cada quadro do vídeo
### 5. Agregar os quadros diferença obtidos na última etapa em um vídeo novamente

## Resultados

### Plano de fundo encontrado :
![svd](https://github.com/HenriChris/remocao-fundo-video/assets/127856850/9ea60bad-75f3-4aec-85cd-50bd616ee7ef)

### Vídeo original :
https://github.com/HenriChris/remocao-fundo-video/assets/127856850/80393d8c-54d2-4682-a4a9-76ea924dc22c
### Vídeo com o plano de fundo removido :
https://github.com/HenriChris/remocao-fundo-video/assets/127856850/c698937d-d7d2-4f03-af1c-90414831ffe7

## Conculsão

## Referências
