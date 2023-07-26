println("Etapa 1/5 :")
# Vídeo Original -> Quadros Originais
run(`julia video_to_frames.jl`)
println("Etapa 2/5 :")
# Quadros Originais -> Quadros Temporais
run(`julia --threads 8 frames_to_temporal.jl`)
println("Etapa 3/5 :")
# Quadros Temporais -> Plano de fundo
run(`julia svd.jl`)
println("Etapa 4/5 :")
# Quadros originais - Plano de fundo -> Quadros de Plano Principal
run(`julia svd_to_foreground.jl`)
println("Etapa 5/5 :")
# Quadros de Plano Principal -> Vídeo de Plano Principal
run(`julia frames_to_video.jl`)
println("Finalizado!")
