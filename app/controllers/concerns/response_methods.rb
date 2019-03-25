module ResponseMethods

  extend ActiveSupport::Concern

  included do

    rescue_from Exception do |e|
      Rails.logger.error ">>>[INTERNAL ERROR][#{e.class}] #{e.to_s}!\n#{e.backtrace.join("\n")}"
      api_error "Критическая ошибка: #{e.to_s}", status: 500
    end

    rescue_from ActionController::ParameterMissing do |e|
      Rails.logger.error ">>>[ParameterMissing] #{e.to_s}!\n#{e.backtrace.join("\n")}"
       api_error 'Неверный запрос'
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      Rails.logger.error "[ActiveRecord::RecordNotFound] #{e.backtrace.first(10).join("\n")}"
      api_error 'Объект не найден'
    end

  end

  def api_save resource
    resource.class.transaction do
      is_persisted = resource.persisted?
      if resource.save
        yield if block_given?
        return if performed?
        api_object resource
      else
        api_error resource
      end
    end
  end

  def api_destroy resource, default_render: true
    resource.class.transaction do
      if resource.destroy
        yield if block_given?
        return if performed?
        render :show, status: :ok if default_render
      else
        api_error resource
      end
    end
  end

  def api_collection collection 
    hash = {}
    hash[:collection] = collection.map(&:attributes)
    hash[:success] = true
    render json: hash
  end

  def api_error resource, status: 400, title: nil
    hash = 
      if resource.respond_to? :errors
        msgs = resource.errors.try(:full_messages) || resource.errors
        { msg: msgs.join(', '), errors: resource.errors, title: title || 'Ошибка валидации' }
      elsif resource.is_a? Array
        { msg: resource.join('! '), errors: resource, title: title }
      else
        { msg: resource, errors: [resource], title: title || resource.truncate(30) }
      end
    hash[:success] = false
    render json: hash, status: status
  end

  def api_success hash = {}
    hash[:success] = true
    render json: hash
  end

  def api_object resource
    hash = {}
    hash[:object] = resource.attributes
    hash[:success] = true
    render json: hash
  end

end