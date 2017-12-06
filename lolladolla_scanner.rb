require 'msf/core'

class MetasploitModule < Msf::Auxiliary
	
	include Msf::Exploit::Remote::HttpClient

	def initialize
		super(
			'Name' => 'LollaDolla Scanna',
			'Version' => 'v1',
			'Description' => 'Scan the lolladolla server',
			'Author' => 'Dope Beats',
			'License' => MSF_LICENSE
		)
	end

	def run
		puts "Scanning..."

		res = send_request_cgi({
			'method'=> 'GET',
			'uri'	=> normalize_uri('dump'),
			'port'	=> rport
		})

		if not res or res.code != 200
			print_error("The dump request failed!")
			return
		end

		html = res.get_html_document
		ul_entries = html.search('li')
		
		output = "Accounts\n    Name (Pubkey) : balance\n    =======================\n"

		for li in ul_entries
			match = li.text.match(/^balance (.*)   public_key (.*)   name (.*)/)
			if not match
				next
			end
	
			arr = match.captures
			output += "    #{arr[2]} (#{arr[1]}) : #{arr[0]}\n"
		end

		if ul_entries.length > 0
			print_good(output)
		end

	end
end
