class ApplicationService
  attr_reader :action, :instance
  delegate :current_user, :params, :resource, :schema_class, :serializer_class, to: :@controller

  def initialize(controller)
    @controller = controller
    @action = params[:action]
  end

  def create!
    @instance = resource.new attributes
    authorize!
    validate!
    instance.save!
  end

  def update!
    @instance = resource.find params[:id]
    authorize!
    validate!
    instance.assign_attributes attributes
    instance.save!
  end

  def destroy!
    @instance = resource.find params[:id]
    authorize!
    instance.destroy!
  end

  def authorize!
    unauthorized! unless policy.send("#{ action }?")
  end

  def validate!
    schema = schema_class.new(policy: policy).send action
    schema.validate! data: attributes.to_h
  end

  def policy
    Pundit.policy! current_user, instance
  end

  def attributes
    return @attributes if @attributes

    data = params.dig(:data, :attributes) || { }
    relationships = params.dig(:data, :relationships) || { }

    relationships.each_pair do |key, value|
      value_data = value[:data] rescue nil
      next unless value_data

      if value_data.respond_to?(:to_ary)
        data[:"#{ key }_ids"] = []
        value_data.each do |relationship|
          data[:"#{ key }_ids"] << relationship[:id]
        end
      else
        data[:"#{ key }_id"] = value_data[:id]
      end
    end

    @attributes = data
  end

  def unauthorized!
    raise Pundit::NotAuthorizedError.new "not allowed to #{ action } this #{ resource.name }"
  end
end
