require 'active_record'
require 'resolv'

module Rubykitchen
	module ValidatesWebsite
		module Validator
			class WebsiteValidator < ActiveModel::EachValidator
				def validate_each(record, attribute, value)
					if system("ping -c 1 google.com") then
					  ip = Resolv.getaddress value rescue []
					  if ip.nil? then
						  record.errors[attribute] << "Its not an active site."
					  end
					else
						record.errors[attribute] << "No active internet connection"
					end
				end
			end
		end

		module ClassMethods
			def validates_website_of(*attr_names)
				validates_with ActiveRecord::Base::WebsiteValidator, _merge_attributes(attr_names)
			end
		end
	end
end

ActiveRecord::Base.send(:include, Rubykitchen::ValidatesWebsite::Validator)
ActiveRecord::Base.send(:extend, Rubykitchen::ValidatesWebsite::ClassMethods)