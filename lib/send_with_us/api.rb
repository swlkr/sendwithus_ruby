module SendWithUs
  class ApiNilEmailId < StandardError; end

  class Api
    attr_reader :configuration

    # ------------------------------ Class Methods ------------------------------

    def self.configuration
      @configuration ||= SendWithUs::Config.new
    end

    def self.configure
      yield self.configuration if block_given?
    end

    # ------------------------------ Instance Methods ------------------------------

    def initialize(options = {})
      settings = SendWithUs::Api.configuration.settings.merge(options)
      @configuration = SendWithUs::Config.new(settings)
    end

    def send_with(email_id, to, data = {}, from = {}, cc={}, bcc={})

      if email_id.nil?
        raise SendWithUs::ApiNilEmailId, 'email_id cannot be nil'
      end

      payload = { email_id: email_id, recipient: to, 
        email_data: data }

      if from.any?
        payload[:sender] = from
      end
      if cc.any?
        payload[:cc] = cc
      end
      if bcc.any?
        payload[:bcc] = bcc
      end

      payload = payload.to_json
      SendWithUs::ApiRequest.new(@configuration).send_with(payload)
    end

    def drips_unsubscribe(email_address)

      if email_address.nil?
        raise SendWithUs::ApiNilEmailId, 'email_address cannot be nil'
      end

      payload = { email_address: email_address }
      payload = payload.to_json
      
      SendWithUs::ApiRequest.new(@configuration).drips_unsubscribe(payload)
    end

    def emails()
      SendWithUs::ApiRequest.new(@configuration).get(:emails)
    end

  end

end
