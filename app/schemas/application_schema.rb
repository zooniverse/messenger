class ApplicationSchema
  include JSON::SchemaBuilder

  def self.inherited(klass)
    klass.root_key = :data
  end
end
