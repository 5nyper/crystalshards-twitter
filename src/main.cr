#credits to crystalshards app.cr for Github api snippets
 
require "http/client"
require "json"
 
class Gitapi1
	json_mapping({
  	name: { type: String },
  	watchers_count: { type: Int32 },
		 html_url: { type: String },
  	description: { type: String, nilable: true }
	})
end
 
class Gitapi2
	json_mapping({
	    total_count: { type: Int32 },
	    items: { type: Array(Gitapi1) }
	})
 
def items
	@items.sort_by(&.watchers_count).reverse
	end
end
 
def headers
	headers = HTTP::Headers.new
	headers["User-Agent"] = "crystalshards"
	headers
end
 
client = HTTP::Client.new("api.github.com", 443, true)
response = client.get("/search/repositories?q=language:crystal&per_page=100", headers)
total = Gitapi2.from_json(response.body).total_count
puts total
par = Gitapi2.from_json(response.body).items.map {|repo| [repo.name, [repo.description, repo.html_url]] }.to_h.to_a
 
if File.exists?("list.json") == false
	File.open("list.json", "w") { |f|
	    f << par.to_h.to_json
	    puts "File saved"
	}
elsif
	par1 = Hash(String, Array(String)).from_json File.read("list.json")
	pH = par-par1.to_a
	if pH.length == 0
		File.open("file.tweet", "w") { |f|
		    f << ""
		    puts "No new projects"
    }
	elsif
		res = pH.to_a
		File.open("file.tweet", "w") { |f|
			if res[0][1][0] == ""
				f << "#{res[0][0]} - N/A - #{res[0][1][1]}"
			else
      			f << "#{res[0][0]} - #{res[0][1][0]} - #{res[0][1][1]}"
		    	puts "New project recieved! Tweeting..."
			end
		}
		`ruby twit.rb`
		puts "Tweeted!"
		File.open("list.json", "w") { |f|
		    f << par.to_h.to_json
		    puts "File Updated"
		}
	end
end
