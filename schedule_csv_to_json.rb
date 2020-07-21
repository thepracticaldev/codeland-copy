require 'csv'
require 'json'
require 'active_support/time'

# This script reads from a CSV file named `input_schedule.csv` and writes to
# a JSON file with the schedule data embedded named `output_schedule.json`

rows = CSV.new(File.read('input_schedule.csv')).read

data = []
keys = rows.shift
rows.each do |row|
  block = {}
  row.each_with_index do |value, index|
    key = keys[index]
    if value.nil?
      # This should not happen -> CSV file should be correct!
      block[key] = ''
    elsif key == 'start_time' || key == 'end_time'
      new_date = Time.current
      hour, minute, second = value.split(':').map(&:strip).map(&:to_i)
      parsed_date = new_date.change(hour: hour || 0, min: minute || 0, sec: second || 0)
      block[key] = parsed_date.utc.strftime('%B %-d, %Y %H:%M:%S %Z')
    else
      block[key] = value
    end
  end
  data << block
end

File.write('output_schedule.json', { schedule: data }.to_json)
