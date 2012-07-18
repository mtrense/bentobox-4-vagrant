require 'chef/api_client'
require 'chef/json_compat'


class User
  include Mongoid::Document
  include DeviseExt

  validates :email, uniqueness: {case_sensitive: false}
  validates :email, format: {with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/,
                             message: "Invalid email"}

  field :client_name, type: String
  validates :client_name, uniqueness: true
  validates :client_name, format: {with: /\w*_*-*/,
                                   message: "Invalid client name, only aphanumerical - and _ allowed"}

  field :private_key, type: String

  has_many :bentoboxes, dependent: :destroy

  after_create :generate_client_name
  #after_create :create_chef_client

  def generate_client_name(record)
    result = record.email.gsub /@/, '_a_'
    record.client_name = result.gsub(/\W/, '')
    record.save
  end


  #client_create.rb
  def create_chef_client(record)
    #must use reset-api directly when not using couchdb

    client = Chef::ApiClient.new
    client.name(record.name)


    #output = edit_data(client)

    # Chef::ApiClient.save will try to create a client and if it exists will update it instead silently
    client.save

    # We only get a private_key on client creation, not on client update.
    if client['private_key']
      record.private_key = client['private_key']
    end
  end
end
