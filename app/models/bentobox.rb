class Bentobox
  include ActiveModel::Validations
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user
  belongs_to :vagrantbox
  has_and_belongs_to_many :ingredients, :inverse_of => :bentoboxes

  field :name
  field :description
  field :public, type: Boolean

  validates :name, presence: true
  validates :vagrantbox, :has_one => true

  scope :visible_to_user, lambda { |user|
    any_of({:public => true}, {:user_id => user.id})
  }

end
