require 'spec_helper'
require './lib/time_formatter'

describe TimeFormatter do
  it 'formats times from Time.now to time in minutes ago' do
    time_formatter = TimeFormatter.new(Time.now - 300)
    expect(time_formatter.format).to eq "5 minutes ago"
  end

  it 'will display Just Now if the post is from 0 minutes ago' do
    time_formatter = TimeFormatter.new(Time.now)
    expect(time_formatter.format).to eq "Just now"
  end
end