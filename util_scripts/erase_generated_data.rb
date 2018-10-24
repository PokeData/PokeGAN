require 'fileutils'

FileUtils.rm('./data.hdf5') if File.exists?('./data.hdf5')
FileUtils.rm('./fakes.png') if File.exists?('./fakes.png')
FileUtils.rm('./frame.png') if File.exists?('./frame.png')
FileUtils.rm('./reals.png') if File.exists?('./reals.png')
FileUtils.rm('./loss.csv') if File.exists?('./loss.csv')

FileUtils.rm_rf('./anim') if File.exists?('./anim')
FileUtils.rm_rf('./snapshots') if File.exists?('./snapshots')
