using Images
using ProgressBars

function create_dir(directory)
    rm(directory, force=true, recursive=true)
    mkdir(directory)
end

function get_foreground(image1_path, image2_path)
    file1 = load(image1_path)
    file2 = load(image2_path)

    m, n = size(file1)

    foreground = Array{RGB{N0f8}}(undef, m, n)

    for i=1:m
        for j=1:n
            foreground[i, j] = (RGB(
                convert(N0f8, abs(convert(Float64, red(file1[i, j])) - convert(Float64, red(file2[i, j])))),
                convert(N0f8, abs(convert(Float64, green(file1[i, j])) - convert(Float64, green(file2[i, j])))),
                convert(N0f8, abs(convert(Float64, blue(file1[i, j])) - convert(Float64, blue(file2[i, j])))),
            ))
        end
    end
    return foreground
end

function get_dir_info(file_directory)
    local root_path
    local dirs_path
    local files_path
    for (root, dirs, files) in walkdir(file_directory)
        root_path = root
        dirs_path = dirs
        files_path = files
    end
    return root_path, dirs_path, files_path
end

function save_foreground_frames(files, root, save_directory, number_of_frames, treshold)
    local frame
    number_of_digits = length(string(number_of_frames))
    println("Calculando a diferença entre cada quadro e o svd...")
    m, n = size(load("./svd.png"))
    Threads.@threads for file in ProgressBar(files)
        filename = file
        frame = get_foreground(joinpath(root, file), "./svd.png")
        file = load(joinpath(root, file))
        img = zeros(RGB{N0f8}, m, n)
        for i=1:m
            for j=1:n
                if red(frame[i, j]) > treshold
                    img[i, j] = RGB(red(file[i, j]), green(img[i, j]), blue(img[i, j]))
                end
                if green(frame[i, j]) > treshold
                    img[i, j] = RGB(red(img[i, j]), green(file[i, j]), blue(img[i, j]))
                end
                if blue(frame[i, j]) > treshold
                    img[i, j] = RGB(red(img[i, j]), green(img[i, j]), blue(file[i, j]))
                end
            end
        end
        save(joinpath(save_directory, filename), img)
    end
end

file_directory = "original_frames"
root, dirs, files = get_dir_info(file_directory)
number_of_frames = length(files)
save_directory = "./foreground_frames"
create_dir(save_directory)
save_foreground_frames(files, root, save_directory, number_of_frames, 0.3)