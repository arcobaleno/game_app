class Address < ActiveRecord::Base
	attr_accessible :user_id, :street_number, :street, :city, :zipcode, :state, :country, :phone

	belongs_to :user

	validates :street_number, presence: true
	validates :street, presence: true
	validates :city, presence: true
	validates :zipcode, presence: true, length: {minimum: 5, maximum: 5}
	validates :country, presence: true
	validates :phone, presence: true

end