class Attachment < ApplicationRecord
  # self.abstract_class = true
  # app/models/document.rb

  attr_accessor :file

  has_and_belongs_to_many :users

  def uploaded_file(incoming_file)
    if incoming_file
      self.filename = sanitize_filename(incoming_file.original_filename)
      self.content_type = incoming_file.content_type
      self.file_contents = incoming_file.read
    else
      raise "missing file"
    end
  end

  def filename=(new_filename)
    write_attribute("filename", sanitize_filename(new_filename))
  end

  # def initialize(params = {})
  #   puts "initialize - parmas: #{params.inspect}"
  #   # file = params[:file] || params['file'] || nil
  #   file = params.delete(:file)

  #   # file = file
  #   # tempfile = Tempfile.new('file')
  #   # tempfile.binmode
  #   # tempfile.write(Base64.decode64(temp_file))

  #   super
  #   if file && file.tempfile && file.tempfile.present?
  #     # self.file_contents = file.read
  #     # puts "file.read #{self.file_contents}"
  #     # file.tempfile.binmode
  #     # test123 = Base64.encode64(file.tempfile.read)
  #     test123 = file.read
  #     puts "WHAT : #{ test123}"
  #     #@file.tempfile = Base64.encode64(file.tempfile.read)

  #     self.filename = sanitize_filename(file.original_filename)
  #     self.content_type = file.content_type
  #     self.file_contents = test123
  #     puts "FILE CONTENTS: "
  #     puts self.file_contents
  #   end
  # end
# def initialize(params = {})
#   # File is now an instance variable so it can be
#   # accessed in the validation.
#   @file = params.delete(:file)
#   super
#   if @file
#     self.filename = sanitize_filename(@file.original_filename)
#     self.content_type = @file.content_type
#     self.file_contents = @file.read
#   end
# end


#   validate :file_size_under_one_mb
# NUM_BYTES_IN_MEGABYTE = 1048576
# def file_size_under_one_mb
#   if (@file.size.to_f / NUM_BYTES_IN_MEGABYTE) > 1
#     errors.add(:file, 'File size cannot be over one megabyte.')
#   end
# end

  protected

  def sanitize_filename(filename)
    # Get only the filename, not the whole path (for IE)
    # Thanks to this article I just found for the tip: http://mattberther.com/2007/10/19/uploading-files-to-a-database-using-rails
    return File.basename(filename)
  end

end