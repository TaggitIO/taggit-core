module Errors
	class TaggitError < StandardError
		attr_reader :http_status, :message
	end

	class UnauthorizedError < TaggitError
		def initialize
			@http_status = 401
			@message 	 = "You are not authorized to view this resource."
		end
	end

	class NotFoundError < TaggitError
		def initialize(message = nil)
			@http_status = 404
			@message 	 = message || "Not found."
		end
	end

	class ConflictError < TaggitError
		def initialize(message = nil)
			@http_status = 409
			@message 	 = message || "Conflict."
		end
	end
end
