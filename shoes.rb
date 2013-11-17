require "rubygems"
require "nike_v2"
require "yaml"

module Shoes

	def Shoes.get_tweet
		info = Shoes.get_nike_info()
		puts Shoes.cocky_brag info

		return nil
		if Shoes.new_info? info
			return Shoes.cocky_brag info
		else
			return Shoes.lazy_dis info
		end
	end

	private

		def Shoes.get_nike_info
			nike_creds = YAML.load_file("config/nike_creds.yml")
			me = NikeV2::Person.new(access_token: nike_creds[:access_token])
			me.summary.running

			info = {}
			km_to_miles = 0.621371  

			summary = me.summary.running
			total_duration = summary["LIFETIMEDURATION"]
			info[:total_hours] = total_duration.split(":")[0]
			total_distance = summary["LIFETIMEDISTANCE"]
			info[:total_miles] = Float(total_distance) * km_to_miles

			latest_run = me.activities(activity_type: "RUN").first
			info[:latest_id] = latest_run.activity_id
			metrics = latest_run.metric_summary
			(hours, minutes, secs) = metrics["duration"].split(":")
			info[:latest_minutes] = 60*Integer(hours) + Integer(minutes)
			info[:latest_miles] = metrics["distance"] * km_to_miles

			info
		end

		def Shoes.new_info? info
			true
		end

		def Shoes.random_phrase type
			f = File.open "phrases/#{type}.txt"
			phrase_ar = []
			f.each_line{ |l| phrase_ar.push l }
			phrase_ar.sample
		end

		def Shoes.cocky_brag info
			base = ""
			r = rand
			if r < 0.25
				base += "Went"
			else
				base += "Ran"
			end
			
			r = rand
			if r < 0.6
				base += " #{"%0.1f" % info[:latest_miles]} miles today"
			else
				base += " #{info[:latest_minutes]} minutes today"
			end

			r = rand
			if r < 0.4
				base += "!"
			else
				base += "."
			end
		
			hashtag = Shoes.random_phrase "positive_hashtags"
			return "#{base} #{hashtag}"
		end

		def Shoes.lazy_dis info
			"Lazy man"
		end

end
