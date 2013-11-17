require "rubygems"
require "yaml"
require "nike_v2"

module Shoes

	def Shoes.get_tweet
		info = Shoes.get_nike_info()

		if Shoes.new_info? info
			return Shoes.cocky_brag info
		else
			return Shoes.lazy_dis info
		end
	end

	private

		def Shoes.get_nike_info
			creds_path = File.expand_path("../config/nike_creds.yml", __FILE__)
			nike_creds = YAML.load_file(creds_path)
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
			info[:latest_time] = latest_run.start_time
			info[:latest_id] = latest_run.activity_id
			metrics = latest_run.metric_summary
			(hours, minutes, secs) = metrics["duration"].split(":")
			info[:latest_minutes] = 60*Integer(hours) + Integer(minutes)
			info[:latest_miles] = metrics["distance"] * km_to_miles

			info
		end

		def Shoes.new_info? info
			return !Shoes.note_match("latest_run_id", info[:latest_id])
		end

		def Shoes.random_phrase type
			f = File.open "phrases/#{type}.txt"
			phrase_ar = []
			f.each_line{ |l| phrase_ar.push l.strip }
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

			r = rand
			return "#{base} #{hashtag}"
		end

		def Shoes.lazy_dis info
			seconds_passed = (Time.now - Time.parse(info[:latest_time]))
			days_passed = Integer(seconds_passed/24/60/60)

			description = "Been a "
			if days_passed < 7
				Shoes.note_match("last_dig", days_passed) # reset note file
				return nil
			elsif days_passed == 7
				return nil if Shoes.note_match("last_dig", days_passed)	
				description += "week"
			elsif days_passed == 30
				return nil if Shoes.note_match("last_dig", days_passed)	
				description += "month"
			elsif days_passed == 365
				return nil if Shoes.note_match("last_dig", days_passed)	
				description += "year"
			else
				return nil
			end
			description += " since the last run."
		
			comment = Shoes.random_phrase "negative_comments"
			hashtag = Shoes.random_phrase "negative_hashtags"
			return "#{description} #{comment} #{hashtag}"
		end

		def Shoes.note_match name, contents
			contents = contents.to_s()
			path = File.expand_path("../notes/#{name}", __FILE__)
			if File.exists? path
				f = File.open path
				if f.read == contents
					return true
				end
			end

			f = File.open path, "w"
			f.write contents
			f.close()
			return false
		end

end
