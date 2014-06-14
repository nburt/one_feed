module Facebook
  class Response

    def success?
      @response.code == 200
    end

    def authed?
      !(@response.code == 463 || @response.code == 467 || @response.code == 400 || @response.code == 190)
    end

    def parse_json(data)
      Oj.load(data)
    end

    def picture_url(response)
      parse_json(response.body)["data"]["url"]
    end

  end
end