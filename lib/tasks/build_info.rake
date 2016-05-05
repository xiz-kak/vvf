namespace :build_info do

  desc 'Bump app version and set build date. argument: major/minor/patch'
  task :bump_version, ['type'] do |task, args|
    filename = Rails.root.join('.build_info.yml')
    swapfilename = "#{filename}.swap"

    version = [0, 0 ,0]

    if File.exist?(filename)
      build_info = YAML.load_file(filename)
      version = build_info['version'].split('.').map(&:to_i)
    end

    if args.type == 'major'
      version[0] += 1
      version[1] = 0
      version[2] = 0
    elsif args.type == 'minor'
      version[1] += 1
      version[2] = 0
    elsif args.type == 'patch'
      version[2] += 1
    end

    version = version.join('.')

    build_date = Time.now.strftime('%Y%m%d-%H%M%S')

    build_info = {'version' => version, 'build_date' => build_date}

    puts "Version: #{version}"
    puts "Build date: #{build_date}"

    File.open(swapfilename, 'w') do |f|
      YAML.dump(build_info, f)
    end

    File.delete(filename) if File.exist?(filename)
    File.rename(swapfilename, filename)
  end
end
