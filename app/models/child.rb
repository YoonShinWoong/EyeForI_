class Child < ActiveRecord::Base
    paginates_per 10
    # mount_uploader :image, ImageUploader
    # belongs_to :user
    belongs_to :kindergarden
end
