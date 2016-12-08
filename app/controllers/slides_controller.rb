class SlidesController < ApplicationController

  def index
  end

  def select
    slide_path = params[:slide_path]

    if slide_path.blank?
      redirect_to slides_url
    else
      redirect_to view_slide_url(:slide_name => slide_path)
    end
  end

  def view
    @slide_name = params[:slide_name]
    slide_path = Rails.root.join("app/views/storage/#{@slide_name}")
    slide_path = Pathname.new @slide_name if !slide_path.exist?

    @slide_index = params[:slide_index]
    @slide_index = @slide_index.to_i if !@slide_index.in? ['all']

    load_slide slide_path
  end

  private

  def load_slide slide_path
    begin
      if slide_path.file?
        slide_index = slide_path
        slide_path = slide_path.dirname
      else
        slide_index = slide_path.join('index.md')
      end

      content = File.read(slide_index)
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

      css_path = slide_path.join('assets/style.css')
      css = css_path.exist? ? File.read(css_path) : nil

      script_path = slide_path.join('assets/script.js')
      script = script_path.exist? ? File.read(script_path) : nil

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
