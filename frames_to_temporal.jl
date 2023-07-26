using Images
using ProgressBars

function create_dir(directory)
    rm(directory, force=true, recursive=true)
    mkdir(directory)
end

# Paraleliza o processo de transformação dos frames.
function make_temporal_frames(file_directory, save_directory)
    println("Criando a evolução temporal de cada coluna do vídeo...")
    Threads.@threads for i in ProgressBar(1:n)
        save_temporal_frames(i, file_directory, save_directory)
    end
end

# Retorna apenas uma coluna específica de um frame selecionado.
function get_column(frame_filename, column)
    frame = load(frame_filename)
    temporal_frame_column = frame[:, column]
    return temporal_frame_column
end

# Para cada pixel de resolução horizontal do vídeo, cria uma matriz
# onde cada coluna é oriunda da mesma coluna do vídeo original, mas
# em momentos diferentes, evoluindo temporalmente, da esquerda para
# a direita. Salvamos então essas matrizes como imagens.
function save_temporal_frames(i, file_directory, save_directory)
    number_of_digits = length(string(n))
    j = 0
    local frame_columns
    for (root, dirs, files) in walkdir(file_directory)
        frame_columns_vector = [get_column(joinpath(root, file), i) for file in files]
        frame_columns = hcat(frame_columns_vector...)
        j += 1
    end
    filename = "frame_" * lpad(i - 1,number_of_digits,"0") * ".png"
    save(joinpath(save_directory, filename), frame_columns)
end

m, n = size(load("./original_frames/frame_0000.png"))
save_directory = "./temporal_frames"
create_dir(save_directory)
file_directory = "original_frames"
make_temporal_frames(file_directory, save_directory)