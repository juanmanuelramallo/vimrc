require 'neovim'
require 'fileutils'

Neovim.plugin do |plug|
  # Creates and opens a spec file for a the current open buffer
  # When the spec file already exists, it just opens the spec file
  plug.command(:CreateSpecFile) do |nvim|
    file_path = nvim.current.buffer.get_name

    file_path.gsub!('/app/', '/spec/')
    file_path.gsub!(/.rb\z/, '_spec.rb')

    unless (existing_file = File.exist?(file_path))
      FileUtils.mkdir_p(File.dirname(file_path))
      File.open(file_path, "w") do |file|
        file.puts "require \"rails_helper\"\n\n"
        file.puts "RSpec.describe \"\" do\n\n"
        file.puts "end\n"
      end
    end

    nvim.exec(":e #{file_path}", true)
    nvim.current.window.cursor = [3,16] unless existing_file
  end
end
