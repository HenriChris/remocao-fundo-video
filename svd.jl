using Images
using LinearAlgebra
using Statistics
using ProgressBars

# Função que retorna uma aproximação de um certo posto da matriz fornecida utilizando
# mínimos quadrados alternados.
function compress(temporal_frames::Array{RGB{N0f8}}, factor::Int)
    
    m, n = size(temporal_frames)
    
    temporal_frames_R = Array{N0f8}(undef, m, n)
    temporal_frames_G = Array{N0f8}(undef, m, n)
    temporal_frames_B = Array{N0f8}(undef, m, n)
    svd_array = empty(Array{Matrix{Float64}}(undef, 3))
    
    temporal_frames_R, temporal_frames_G, temporal_frames_B = red.(temporal_frames), green.(temporal_frames), blue.(temporal_frames )
    
    for channel in [temporal_frames_R, temporal_frames_G, temporal_frames_B]
        
        B = randn(m, factor)

        C = B\channel
        B = channel/C
        temp = B * C

        while norm(temp - B * C) > 0.000001
            C = B\channel
            B = channel/C    
            temp = B * C
        end
        
        # Caso os valores fujam do intervalo [0, 1], utilizado por N0f8.
        push!(svd_array, clamp.(temp, 0.0, 1.0))
            
    end

    svd = Array{RGB{N0f8}}(undef, m, n)
    for i in 1:m
        for j in 1:n
            svd[i, j] = RGB(svd_array[1][i, j], svd_array[2][i, j], svd_array[3][i, j])
        end
    end

    return svd
end

directory = "./temporal_frames"
m, n = size(load("./original_frames/frame_0000.png"))

# Aplica a aproximação acima em cada um dos frames temporais.
# Então, tira a média de todos os valores da mesma linha, produzindo
# uma única coluna.
# Cada uma dessas colunas é concatenada em uma única matriz,
# que representa uma aproximação de posto baixo do vídeo inteiro,
# ou seja, o plano de fundo do vídeo, que é, então, salvo.
for (root, dirs, files) in walkdir(directory)
    println("Aplicando o svd em cada coluna...")
    svd_vector = [mean(compress(load(joinpath(root, file)), 10), dims = 2) for file in ProgressBar(files)]
    svd = hcat(svd_vector...)
    save("./svd.png", svd)
end