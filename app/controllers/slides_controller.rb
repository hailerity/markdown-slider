class SlidesController < ApplicationController

  def index
    @slide_name = params[:slide_name]
    @slide_index = params[:slide_index]
    @slide_index = @slide_index.to_i if !@slide_index.in? ['all']

    begin
      slide_path = Rails.root.join("app/views/storage/#{@slide_name}")
      content = File.read(slide_path.join('index.md'))
      regex = /(\d+)\.\s*\[(.*)\]\((.*)\)$/

      slides = content.scan(regex).map do |match|
        {
          index: match[0].to_i,
          title: match[1],
          relative_path: match[2],
          absolute_path: slide_path.join(match[2]).to_s,
        }
      end

      # Create renderer
      renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      slides.each do |slide|
        slide[:html] = renderer.render(File.read(slide[:absolute_path]))
      end

      css = File.read(slide_path.join('assets/style.css'))
      script = File.read(slide_path.join('assets/script.js'))

      @slide = {
        slides: slides,
        css: css,
        script: script
      }
    rescue Exception => ex
      @error = ex
    end
  end
end
