require 'date'
require 'json'

class SampleScheduleGenerator
  STEP_INTERVAL = 120

  LOREM_IPSUM = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation'.freeze
  SPEAKERS = ['Scott Hanselman', 'Vaidehi Joshi', 'Sangeetha KP'].freeze
  TITLES = ['Keynote', 'The Cost of Data', 'Machine Learning On The Edge'].freeze
  URLS = ['https://dev.to/fdoxyz/speaker-discussion-1c91-temp-slug-3619252?preview=bc7593fd6e022218ee2944d91dc69e8043429d2ee86be941a4e2a5e71b519fb7f9e018a3abebe8c30d027852febbb5cb1523358776c9284d6141a67d', 
    'https://dev.to/fdoxyz/speaker-discussion-132b-temp-slug-1943013?preview=a26e78ab2bd2bff858bf3f18153039330d9ff081fecdf4d62997dce268d048775b281dc39b0cf2839c0ff657f91e5eeeec19eebd4df9ee03d302d92d'].freeze

    
  def initialize(start_time_string, end_time_string)
    @start_time = DateTime.parse(start_time_string).to_time.utc
    @end_time = DateTime.parse(end_time_string).to_time.utc
  end

  # take a start and end date/time
  # iterate over them in 1 minute intervals, rotating through presenters and talks
  # output json

  def generate
    schedule = []
    counter = 0

    (@start_time.to_i .. @end_time.to_i).step(STEP_INTERVAL) do |time|
      counter += 1
      schedule << create_talk_hash(counter, time, time + STEP_INTERVAL)
    end

    {schedule: schedule}.to_json
  end

  def create_talk_hash(id, start_time, end_time)
    {
      id: id,
      start_time: Time.at(start_time).utc.strftime('%B %-d, %Y %H:%M:%S %Z'),
      end_time: Time.at(end_time).utc.strftime('%B %-d, %Y %H:%M:%S %Z'),
      speaker: SPEAKERS.sample,
      title: TITLES.sample,
      bio: LOREM_IPSUM,
      url: URLS.sample
    }
  end


end

puts SampleScheduleGenerator.new("June 26, 2020 15:00:00 UTC", "June 26, 2020 17:00:00 UTC").generate

