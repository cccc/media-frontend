class Thumbnailize < Nanoc::Filter

  identifier :logo
  type       :binary

  def run(filename, params={})
    system(
      'gm',
      'convert',
      filename,
      '-resize',     'x100',
      '-background', 'white',
      '-gravity',    'Center',
      '-extent',     'x100',
      '+profile',    '*',
      output_filename
    )
  end

end