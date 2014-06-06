require 'spec_helper'

describe TimelineConcatenator do

  let(:facebook_data) { Oj.load(File.read("./spec/support/timeline_concatenator_data.json")) }

  it 'should merge timelines and sort them by date' do
    timeline_concatenator = TimelineConcatenator.new
    result = timeline_concatenator.merge([], [], facebook_data)
    expect(result).to eq [
                           {
                             :provider => "facebook",
                             :created_time => "2014-05-25 14:35:03 -0600",
                             :type => nil,
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2014-05-18 17:59:03 -0600",
                             :type => nil,
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2014-05-18 17:47:10 -0600",
                             :type => nil,
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2014-05-18 17:24:46 -0600",
                             :type => nil,
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2014-05-18 15:49:57 -0600",
                             :type => nil,
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2014-05-18 15:41:10 -0600",
                             :type => nil,
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2014-05-18 15:29:54 -0600",
                             :type => nil,
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2008-05-03 13:09:46 -0600",
                             :type => nil,
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2007-03-07 18:27:09 -0700",
                             :type => nil,
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2007-03-06 18:27:09 -0700",
                             :type => nil,
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2004-11-07 08:36:26 -0700",
                             :type => nil,
                           }
                         ]
  end

end