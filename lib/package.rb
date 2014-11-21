require 'find'
require 'json'

class Package
  attr_reader :version, :binary_url, :binary_sha1, :source_url, :source_sha1, :is_fake, :name, :dependencies
  CREW_PREFIX = '/usr/local'
  CREW_LIB_PATH = CREW_PREFIX + '/lib/crew/'
  CREW_CONFIG_PATH = CREW_PREFIX + '/etc/crew/'
  CREW_BREW_DIR = CREW_PREFIX + '/tmp/crew/'
  CREW_DEST_DIR = CREW_BREW_DIR + '/dest'

  def self.packages
    packages = {}
    Find.find (CREW_LIB_PATH + 'packages') do |filename|
      packageName = File.basename filename, '.rb'
      packages[packageName] = self.installed? packageName
    end
    return packages
  end

  def self.installed? packageName
    Find.find(CREW_CONFIG_PATH + 'meta/') do |packageList|
      return true if packageList == CREW_CONFIG_PATH + 'meta/' + packageName + '.filelist'
    end
    return false
  end

end
