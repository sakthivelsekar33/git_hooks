#!/home/sakthivel/.rvm/rubies/ruby-1.9.3-p286/bin/ruby

puts 'sakthivel - started git commit hook'

# Check Code Style for Committed Files

commit_files = `git diff --cached --name-only`
files_list =  commit_files.split('\\n')

total_offense, total_failures = 0, 0

files_list.each do |file_with_path|
	comments = `rubocop #{file_with_path}`

	offense = comments.match(/.*, [0-9] .*/)

	if offense
		offense_count = offense[0].match(/.*, [0-9] .*/)[0].split(',').last.match(/[0-9]/)[0].to_i
		total_offense += offense_count
	end

end

# Executing Rspec for Test Coverage

rspec_result = `rspec`
total_failures = rspec_result.match(/.*[0-9]\sexample.*/)[0].split(',')[1].match(/[0-9]/)[0].to_i

if total_offense > 0 || total_failures > 0
	puts "Total Test Failures : #{total_failures}"
	puts "Total Coding Style Offense : #{total_offense}"
	exit 1
end

puts "Passes All Pre Commit Checks"

exit 0