# coding: utf-8
require 'open-uri'
require 'nokogiri'
require 'fileutils'
require 'active_record'



ActiveRecord::Base.establish_connection(
  "adapter" =>"sqlite3",
  "database" => "./npb.db"
)

class Hitter < ActiveRecord::Base
end
class Pitcher < ActiveRecord::Base
end

def player_get(type,uri)
  pageName = nil
  if type == "hitter"
    pageName = "tpa-1.html"
  else
    pageName = "era-1.html"
  end
  doc = getDoc(uri + pageName)
  league = doc.css("title").inner_text.chars[0] + "リーグ"
  doc.xpath('//tr').drop(1).each do |tr|
    row = tr.css('td').map(&:inner_text).drop(1)
    if row.length == 0 then next end
    if type == "hitter"
      Hitter.create(:player_name => row.shift,
                    :team => row.shift,
                    :league => league,
                    :batting_average => row.shift,
                    :match => row.shift,
                    :number_of_bats => row.shift,
                    :stroke_count => row.shift,
                    :hits => row.shift,
                    :homerun => row.shift,
                    :hit_point => row.shift,
                    :steal_base => row.shift,
                    :four_balls => row.shift,
                    :dead_ball => row.shift,
                    :struck_out => row.shift,
                    :sacrifice => row.shift,
                    :striking_together => row.shift,
                    :long_hit_rate => row.shift,
                    :base_rate => row.shift,
                    :ops => row.shift,
                    :rc_27 => row.shift,
                    :xr_27 => row.shift)
    else
      Pitcher.create(:player_name => row.shift,
                     :team => row.shift,
                     :league => league,
                     :protection_ratio => row.shift,
                     :match => row.shift,
                     :victory => row.shift,
                     :defeat => row.shift,
                     :p_save => row.shift,
                     :hold => row.shift,
                     :winning_percentage => row.shift,
                     :batter => row.shift,
                     :pitches => row.shift,
                     :hit => row.shift,
                     :home_runs_hit => row.shift,
                     :yosemite => row.shift,
                     :death_ball => row.shift,
                     :strike_out => row.shift,
                     :a_goal => row.shift,
                     :self_reward_point => row.shift,
                     :whip => row.shift,
                     :dips => row.shift)
    end
  end
end
def getDoc(uri)
  charset = nil
  html = open(uri) do |f|
    charset = f.charset
    f.read
  end
  Nokogiri::HTML.parse(html,nil,charset)
end
def getUri(type,uri)
  pageName = nil
  if type == "hitter"
    pageName = "tpa-1.html"
  else
    pageName = "era-1.html"
  end
  uri + pageName
end
uri=""
["ce","pa"].each do |l_type|
  ["hitter","pitcher"].each do |f_type|
    uri = "http://baseball-data.com/16/stats/#{f_type}-#{l_type}/"
    player_get(f_type,uri)
  end
end
