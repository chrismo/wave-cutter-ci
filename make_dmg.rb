require 'fileutils'

class DmgBuilder
  def initialize(zip_fn)
    @zip_fn = zip_fn

    raise ArgumentError unless zip_fn
  end

  def execute
    prep_tmp_dir
    unzip
    modify_contents
    make_dmg
  end

  private

  def prep_tmp_dir
    @tmp_dir = File.join(__dir__, 'tmp')
    FileUtils.rm_r(@tmp_dir)
    FileUtils.makedirs(@tmp_dir)
  end

  def unzip
    system "unzip '#{@zip_fn}' -d #{@tmp_dir}"
  end

  def modify_contents
    FileUtils.mv(tmp_fn("Mac", "Mac.app"), tmp_fn(app_root_dir), verbose: true)
    FileUtils.chmod("+x", tmp_fn(app_root_dir, "Contents", "MacOS", "Wave Cutter"), verbose: true)
  end

  def make_dmg
    system "create-dmg '#{tmp_fn(app_root_dir)}'"
  end

  def app_root_dir
    "Wave Cutter.app"
  end

  def tmp_fn(*fn)
    File.join(@tmp_dir, fn)
  end
end

DmgBuilder.new(zip_fn = ARGV[0]).execute
