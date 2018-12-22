class Kindergarden < ActiveRecord::Base
    serialize :freArr, Array
    serialize :danArr, Array
    serialize :schArr, Array
    
    serialize :fre, Array
    serialize :dan, Array
    serialize :sch, Array
    
    paginates_per 10
    has_many :users
    has_many :children
    # has_many :buses
end
