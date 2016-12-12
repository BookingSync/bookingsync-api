module VcrHelper
  def find_resource(filename, resources_key)
    response_body = retrive_response_body_from_yaml(filename)
    BookingSync::API::Resource.new(nil, response_body[resources_key].first)
  end

  def find_resources(filename, resources_key)
    response_body = retrive_response_body_from_yaml(filename)
    response_body[resources_key]
  end

  def casette_path(casette_dir, example_metadata)
    File.join(casette_dir, example_metadata[:described_class].to_s.gsub("::", "_"), "")
  end

  private

  def retrive_response_body_from_yaml(filename)
    parse_sever_response_body(parse_yaml(filename))
  end

  def parse_yaml(filename)
    YAML.load_file(filename)
  end

  def parse_sever_response_body(server_response)
    JSON.parse(server_response["http_interactions"].first["response"]["body"]["string"])
  end
end
