class Ingredient
  include Mongoid::Document

  belongs_to :category
  #http://stackoverflow.com/questions/5078661/field-for-and-nested-form-with-mongoid

  embeds_one :networkconfig
  embeds_many :portmappings
  embeds_many :share_folders
  has_and_belongs_to_many :bentoboxes, :inverse_of => :ingredients

  field :name, type: String
  field :cookbooks, type: String

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true

  #validates_associated :networkconfig

  accepts_nested_attributes_for :networkconfig,
                                :portmappings,
                                :share_folders,
                                allow_destroy: true

  attr_accessible :name,
                  :category,
                  :cookbooks,
                  :portmappings_attributes, :portmappings,
                  :share_folders_attributes, :share_folders,
                  :networkconfig_attributes, :networkconfig

  scope :with_network_config, excludes(:networkconfig => nil)
  scope :with_share_folders, excludes(:share_folders => nil)
  scope :with_portmappings, excludes(:portmappings => nil)

=begin
  after_save :rebuild_categories

  protected

  #todo

  def rebuild_categories
    Post.collection.map_reduce(
        "function() { this.categories.forEach(function(c){ emit(c, c.ingredients); }); }",
        "function(key,values) { var count = 0; values.forEach(function(v){ count += v; }); return count; }",
        {:out => 'tags'}
    )
  end

  def self.all_tags(limit = nil)
    tags = Mongoid.master.collection('tags')
    opts = {:sort => ["_id", :desc]}
    opts[:limit] = limit unless limit.nil?

    tags.find({}, opts).to_a \
      .map! { |item| {:name => item['_id'], :post_count => item['value'].to_i} }
  end
=end

end
