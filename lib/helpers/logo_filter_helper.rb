class Thumbnailize < Nanoc::Filter

  identifier :logo
  type       :binary

  def run(filename, params={})
    system(
      'gm',
      'convert',
      '-size',       '100x100',
      filename,
      '-resize',     '100x100',
      '-background', 'white',
      '-gravity',    'Center',
      '-extent',     '100x100',
      '+profile',    '*',
      output_filename
    )
  end

end