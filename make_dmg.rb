require 'fileutils'


class DmgBuilder
  def initialize(zip_fn, version)
    @zip_fn = zip_fn
    @version = version

    raise ArgumentError unless zip_fn && version
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
    FileUtils.makedirs(tmp_fn(app_root_dir))
    FileUtils.mv(tmp_fn("Mac"), tmp_fn(app_root_dir, "Contents"))
    FileUtils.chmod("+x", tmp_fn(app_root_dir, "Contents", "MacOS", "Wave Cutter"))
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

DmgBuilder.new(zip_fn = ARGV[0], version = ARGV[1]).execute
