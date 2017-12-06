require 'msf/core'

class MetasploitModule < Msf::Auxiliary
	
	include Msf::Auxiliary::Scanner

	def initialize

		super(
			'Name' => 'LollaDolla Scanna',
			'Version' => 'v1',
			'Description' => 'Scan the lolladolla server',
			'Author' => 'Dope Beats',
			'License' => MSF_LICENSE
		)
	
		deregister_options('RPORT', 'RHOST')
	end

	def run_host(ip)
		begin
			puts "Scanned..."
		end
	end
end
