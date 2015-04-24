#credits to crystalshards app.cr for Github api snippets

require "http/client"
require "json"

class GithubRepo
  json_mapping({
    name: { type: String },
	watchers_count: { type: Int32 },
    description: { type: String, nilable: true }
  })
end

class Compare
	json_mapping({
		name: { type: String },
		description: { type: String }
	})
end

class GithubRepos
  json_mapping({
    total_count: { type: Int32 },
    items: { type: Array(GithubRepo) }
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
total = GithubRepos.from_json(response.body).total_count
puts total
par = GithubRepos.from_json(response.body).items.map {|repo| [repo.name, repo.description] }.to_h.to_a

if File.exists?("list.json") == false 
	File.open("list.json", "w") { |f|
		f << par.to_h.to_json
		puts "File saved"
	}
elsif
	par1 = Hash(String, String).from_json File.read("list.json")
	res = par1.to_a-par
	if res.length == 0
		puts "No"
	elsif
		puts res
	end
end
	
