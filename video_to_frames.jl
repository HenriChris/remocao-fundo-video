using VideoIO
using Images
using ProgressBars

function create_dir(directory)
    rm(directory, force=true, recursive=true)
    mkdir(directory)
end
    
function video_to_frames(file_path, directory)
    io = VideoIO.open(file_path)
    f = VideoIO.openvideo(io)
    number_of_frames = counttotalframes(f)
    number_of_digits = length(string(number_of_frames))
    i = 0
    println("Separando o vídeo em quadros...")
    pbar = ProgressBar(total=number_of_frames)
    for img in f
        filename = "frame_" * lpad(i,number_of_digits,"0") * ".png"
        save_path = joinpath(directory, filename)
        save(save_path, img)
        i += 1
        update(pbar)
    end
    close(f)
end

directory = "original_frames"
video = "video.mp4"
create_dir(directory)
video_to_frames(video, directory)