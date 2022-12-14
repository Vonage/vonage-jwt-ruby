# frozen_string_literal: true

require 'jwt'

module Vonage
  class JWT
    attr_accessor :generator, :typ, :iat

    def initialize(params = {})
      @generator = params.fetch(:generator)
      @typ = params.fetch(:typ, 'JWT')
      @iat = params.fetch(:iat, Time.now.to_i)
    end

    def generate
      ::JWT.encode(to_payload, generator.private_key, generator.alg, header_fields={typ: typ})
    end

    def to_payload
      hash = {
        iat: iat,
        jti: generator.jti,
        exp: generator.exp || iat + generator.ttl,
        sub: generator.subject,
        application_id: generator.application_id
      }
      hash.merge!(generator.paths) if generator.paths
      hash.merge!(nbf: generator.nbf) if generator.nbf
      hash.merge!(generator.additional_claims) if !generator.additional_claims.empty?
      hash
    end
  end
end
