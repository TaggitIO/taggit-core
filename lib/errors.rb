module Errors
	class UnauthorizedError < StandardError
		attr_reader :http_status, :message

		def initialize
			@http_status = 401
			@message = "You are not authorized to view this resource."
		end
	end
end
