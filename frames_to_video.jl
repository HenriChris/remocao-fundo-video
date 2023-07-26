using VideoIO
using Images
using ProgressBars

# Junta todos os frames de plano principal obtidos em um
# vídeo novamente.
function frames_to_video(filename, directory)

    for (root, dirs, files) in walkdir(directory)
        number_of_files = length(files)
        img_stack = empty(Array{Array{RGB{N0f8}}}(undef, number_of_files))
        println("Recombinando quadros em vídeo...")
        for file in ProgressBar(files)
            push!(img_stack, load(joinpath(directory, file)))
        end
        encoder_options = (crf=23, preset="medium")
        VideoIO.save(filename, img_stack, framerate=24, encoder_options=encoder_options)
    end
end

directory = "foreground_frames"
video = "foreground.mp4"
frames_to_video(video, directory)