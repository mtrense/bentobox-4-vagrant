Fabricator(:bentobox) do
  name "Bentobox"
  description "Description"
  public false
  user { Fabricate(:user) }
  vagrantbox { Fabricate(:vagrantbox) }
end

Fabricator(:bentobox_with_ingredient, from: :bentobox) do
  after_create do |bentobox|
    bentobox.ingredients.push(Fabricate.build(:full_ingredient))
  end
  #ingredients(count:1) { |bentobox| Fabricate(:full_ingredient, bentobox: bentobox) }
end