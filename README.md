# Remoção do plano de fundo de vídeos utilizando Mínimos Quadrados Alternados

### Autor : Henrique Chrispim

## Introdução

A relevância da informação de um vídeo está intimamente ligada à capacidade de identificar e destacar mudanças significativas. Conteúdos estáticos ou repetitivos muitas vezes carecem de interesse ou valor para o usuário ou aplicação. Nesse contexto, a extração do plano de fundo de vídeos pode ser vista como uma solução para esse e outros problemas.

Essa técnica transforma vídeos, principalmente aqueles capturados por câmeras estacionárias, de forma a preservar somente os elementos dinâmicos do conteúdo, eliminando o cenário estático de fundo.

## Ferramentas básicas

### VideoIO.jl
Biblioteca da Julia utlizada para separar o vídeo em quadros e, após concluídas as outras etapas, reconstituir os quadros resultantes novamente em um vídeo.

### Mínimos Quadrados Alternados [(1)](https://en.wikipedia.org/wiki/Matrix_completion)
Técnica utilizada para se obter uma fatoração de matriz aproximada.
$$A_{m \times n} \approx B_{m \times t}C_{t \times n}$$
Inicialmente escolhemos um valor para $C$ e então calculamos o $B$ que melhor aproxima a equação acima utilzando mínimos quadrados.

Agora podemos esquecer o valor de $C$ previamente escolhido e novamente resolver mínimos quadrados para encontrar o $B$ que melhor aproxima a equação.

Repetindo esse processo inúmeras vezes, melhoramos nossa aproximação, até encontrarmos a fatoração mais próxima possível.

Podemos diminuir o valor de $t$ para obtermos aproximações de posto menores. Isso é devido ao fato de essa aproximação também ordenar as informações em relação a quanto elas contribuem para a imagem original. [(2)](https://timbaumann.info/svd-image-compression-demo/)

No nosso caso, as informações que mais contribuem para nossa imagem original são as que compõe o plano de fundo, pois são, por definição, as mais prevalentes ao longo do vídeo, e obtê-lo é um objetivo intermediário desse projeto.

## Metodologia
O processo de remoção foi realizado em 5 etapas :
### 1. Separação do vídeo em quadros
Realizada pela biblioteca VideoIO.jl, cada quadro é armazenado em um pasta chamada "original_frames".

### 2. Criar uma matriz da evolução temporal de cada coluna do vídeo

É criada uma matriz para cada pixel na resolução horizontal do vídeo. Por exemplo, um vídeo 1280 x 720 resultará em 1280 matrizes de evolução temporal.

Cada uma dessas matrizes representa a concatenação horizontal de uma coluna do vídeo original, do início ao fim. A primeira coluna dessas matrizes é equivalente à coluna do vídeo no primeiro quadro, a segunda do segundo quadro, até a última coluna que é equivalente à coluna no último quadro.

Após serem criadas, as matrizes são armazenadas em uma pasta chamada “temporal_frames”.

### 3. Aplicar Mínimos Quadrados Alternados em cada uma das matrizes de evolução temporal

Em seguida, aplicamos o método dos mínimos quadrados alternados a cada uma das matrizes de evolução temporal. Embora o resultado dessas operações seja uma matriz, o nosso interesse é obter apenas uma coluna. Para alcançar esse objetivo, calculamos a média dos valores de cada coluna nessas matrizes, resultando em uma coluna para cada matriz de evolução temporal.

Posteriormente, essas colunas são concatenadas horizontalmente, o que resulta em uma matriz representando uma aproximação de baixo posto do vídeo original, ou seja, o plano de fundo do vídeo.

### 4. Subtrair o plano de fundo obtido na etapa anterior de cada quadro do vídeo

Cada quadro do vídeo original passa por um processo de subtração do plano de fundo obtido na etapa anterior. Como resultado, os quadros resultantes podem apresentar cores distorcidas em comparação com os originais, sendo, então, utilizados apenas como "máscaras".

Nesse contexto, as matrizes de subtração atuam como indicadores: quando essas matrizes têm valores próximos de zero, significa que não há um objeto presente naquele ponto, e esse ponto será representado como cor preta. Por outro lado, se o valor for significativamente maior que zero, o valor será igual ao da matriz correspondente no quadro original naquele mesmo ponto.

### 5. Agregar os quadros diferença obtidos na última etapa em um vídeo novamente
Novamente realizada pela biblioteca VideoIO.jl, resultando em um video nomeado "foreground.mp4"

## Resultados

### Plano de fundo encontrado :
![svd](https://github.com/HenriChris/remocao-fundo-video/assets/127856850/9ea60bad-75f3-4aec-85cd-50bd616ee7ef)
### Vídeo original :
https://github.com/HenriChris/remocao-fundo-video/assets/127856850/80393d8c-54d2-4682-a4a9-76ea924dc22c
### Vídeo com o plano de fundo removido :
https://github.com/HenriChris/remocao-fundo-video/assets/127856850/c698937d-d7d2-4f03-af1c-90414831ffe7

## Conculsão

Esse método produz resultados aceitáveis, considerando a quantidade de detalhes presentes no vídeo original. No entanto, sua aplicação prática é prejudicada pela demora no processamento.

Uma alternativa viável para melhorar o desempenho é obter o plano de fundo do vídeo usando apenas uma pequena porcentagem de quadros selecionados aleatoriamente do vídeo original, ao invéz de utilizar todos os quadros.

## Referências
[1. https://en.wikipedia.org/wiki/Matrix_completion](https://en.wikipedia.org/wiki/Matrix_completion) (Acessado em 23/07/2023, Sub-seção : "Alternating Least Squares")

[2. https://timbaumann.info/svd-image-compression-demo/](https://timbaumann.info/svd-image-compression-demo/) (Acessado em 23/07/2023, Sub-seção : "Using SVD for image compression")
