# encoding: utf-8
require 'logstash/codecs/base'
require 'zlib'
require 'stringio'

# The "gunzip" codec is for unpacking optionally gzipped events.
class LogStash::Codecs::Gunzip < LogStash::Codecs::Base
  config_name 'gunzip'

  public
  def register
  end

  public
  def decode(data)

    # try to gunzip data
    begin
      gz = Zlib::GzipReader.new(StringIO.new(data))
      unpacked = gz.read
    rescue Zlib::GzipFile::Error
      unpacked = ''
    ensure
      gz.close unless gz.nil?
    end

    # send unpacked, original or none data (in case of it's empty)
    if !unpacked.empty?
      yield LogStash::Event.new('message' => unpacked)
    elsif !data.empty?
      yield LogStash::Event.new('message' => data)
    end

  end # def decode

end # class LogStash::Codecs::Gunzip
