require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  t.test_files = FileList['test/test_golden.rb']
  t.warning = false
  t.ruby_opts = ["-I#{File.expand_path('../tyco-c/build', __dir__)}"]
end

task default: :test
