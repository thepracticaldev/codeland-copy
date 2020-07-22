require 'csv'
require 'json'
require 'active_support/time'

# This script reads from a CSV file named `input_schedule.csv` and writes to
# a JSON file with the schedule data embedded named `output_schedule.json`

rows = CSV.new(File.read('schedule.csv')).read

data = []
keys = rows.shift.map(&:strip)
rows.each_with_index do |row, row_index|
  block = {}
  row.each_with_index do |value, index|
    key = keys[index]

    # These are keys we don't use in our JSON
    next if ['minutes', 'seconds', 'delay_min', 'delay_sec'].include?(key)

    if key == 'start_time'
      new_date = DateTime.parse('2020-07-23 00:00:00 EDT').to_time
      date_str = value.delete_suffix(' PM').delete_suffix(' AM')
      hour, minute, second = date_str.split(':').map(&:strip).map(&:to_i)
      parsed_date = new_date + hour.hours + minute.minutes + second.seconds
      block[key] = parsed_date.utc.strftime('%B %-d, %Y %H:%M:%S %Z')

      # The end_time is added to the 'previous block' (using the current 'start_time')
      data[row_index-1]['end_time'] = block[key] if row_index > 0
    elsif key == 'sponsor'
      block[key] = (value == 'TRUE')
    else
      block[key] = value.to_s
    end
  end
  data << block
end

data.pop # Last element is not needed ("THE END")

File.write('schedule.json', { schedule: data }.to_json)
