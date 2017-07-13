revision_file = Rails.root.join 'revision.txt'

if File.exists?(revision_file)
  Rails.application.revision = File.read(revision_file).chomp
end
