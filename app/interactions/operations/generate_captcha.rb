module Operations
  # oluşturucuyu alır ve onu kullanarak yeni bir captcha üretir
  class GenerateCaptcha < ActiveInteraction::Base
    interface :generator, methods: %i[generate]

    def execute
      image = generator.generate
      { image: image, hash: generator.hash }
    end

    private

    # def random_hash
    #   @random_hash ||= RandomString.generate(5, false, '0oqi').upcase
    # end

  end
end
