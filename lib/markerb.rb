require "action_view/template"
require "redcarpet"
require "markerb/railtie"

module Markerb
  mattr_accessor :processing_options, :renderer
  @@processing_options = {}
  @@renderer = Redcarpet::Render::HTML

  class Handler
    def erb_handler
      @erb_handler ||= ActionView::Template.registered_template_handler(:erb)
    end

    def call(template)
      compiled_source = erb_handler.call(template)
      if template.formats.include?(:html)
        "Redcarpet::Markdown.new(Markerb.renderer, Markerb.processing_options).render(begin;#{compiled_source};end)"
      else
        compiled_source
      end
    end
  end
end

ActionView::Template.register_template_handler :markerb, Markerb::Handler.new
