require_relative 'spec_helper'

describe Vonage::JWT do
  let(:token) { "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1ODc0OTQ5NjIsImp0aSI6ImM1YmE4ZjI0LTFhMTQtNGMxMC1iZmRmLTNmYmU4Y2U1MTFiNSIsImlzcyI6IlZvbmFnZSIsInBheWxvYWRfaGFzaCI6ImQ2YzBlNzRiNTg1N2RmMjBlM2I3ZTUxYjMwYzBjMmE0MGVjNzNhNzc4NzliNmYwNzRkZGM3YTIzMTdkZDAzMWIiLCJhcGlfa2V5IjoiYTFiMmMzZCIsImFwcGxpY2F0aW9uX2lkIjoiYWFhYWFhYWEtYmJiYi1jY2NjLWRkZGQtMDEyMzQ1Njc4OWFiIn0.JQRKi1d0SQitmjPINfTWMpt3XZkGsLbD7EjCdXoNSbk" }

  describe '.decode' do
    let(:decoded_token) do
      [{"iat"=>1587494962,
        "jti"=>"c5ba8f24-1a14-4c10-bfdf-3fbe8ce511b5",
        "iss"=>"Vonage",
        "payload_hash"=>"d6c0e74b5857df20e3b7e51b30c0c2a40ec73a77879b6f074ddc7a2317dd031b",
        "api_key"=>"a1b2c3d",
        "application_id"=>"aaaaaaaa-bbbb-cccc-dddd-0123456789ab"},
       {"alg"=>"HS256", "typ"=>"JWT"}]
    end

    it 'correctly decodes the token payload' do
      expect(Vonage::JWT.decode(token, nil, false).first).to match(
        hash_including(
          {
            "iat"=>1587494962,
            "jti"=>"c5ba8f24-1a14-4c10-bfdf-3fbe8ce511b5",
            "iss"=>"Vonage",
            "payload_hash"=>"d6c0e74b5857df20e3b7e51b30c0c2a40ec73a77879b6f074ddc7a2317dd031b",
            "api_key"=>"a1b2c3d",
            "application_id"=>"aaaaaaaa-bbbb-cccc-dddd-0123456789ab"
          }
        )
      )
    end

    it 'correctly decodes the token header' do
      expect(Vonage::JWT.decode(token, nil, false).last).to match(hash_including({"alg"=>"HS256", "typ"=>"JWT"}))
    end
  end

  describe '.verify_signature' do
    context 'with a valid signature secret' do
      let(:signature_secret) { "ZYtdTtGV3BCFN7tWmOWr1md66XsquMggr4W2cTtXtcPgfnI0Xw" }

      it 'returns true' do
        expect(Vonage::JWT.verify_signature(token, signature_secret, 'HS256')).to be true
      end
    end

    context 'with an invalid signature secret' do
      let(:signature_secret) { "ZYtdTtGV3BCFN7tWmOWr1md66XsquMggr4W2cTtXtcPgf55555" }

      it 'returns false' do
        expect(Vonage::JWT.verify_signature(token, signature_secret, 'HS256')).to be false
      end
    end
  end
end
