
puts ARGV
# puts Process.pid
begin
    Process.getpgid( Process.pid )
    true
  rescue Errno::ESRCH
    system("ruby bash_assignment.rb #{ARGV}")
  end
  
child_command = ARGV.join(' ')

