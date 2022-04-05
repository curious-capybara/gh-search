require "tilt"

module Template
  def self.render(template_name, opts)
    Tilt.new(File.join(File.dirname(__FILE__), "templates", "#{template_name}.erb")).render(self, opts)
  end
end