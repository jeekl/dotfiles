require 'rake'

@homedir = File.expand_path("~/")
@dotdir = "#{@homedir}/.config/dotfiles/"
@originalsdir = "#{@dotdir}/backup/"

def installed? (file)
  (File.symlink?(file) && (File.readlink (file)))
end

def linkhome(file)
  if stock? file
    stash file
  end
  ln_s expand_dot(file), expand_home(file), :verbose => true
end




namespace :install do
  task :install_file, :file do |t, args|
    file = args[:file]
    case file
    when "zsh" 
      puts "zsh"
    when "git" 
      puts "git"
    else 
      puts "Avaliable choices are: git, zsh"
    end
  end
end

