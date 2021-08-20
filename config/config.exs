use Mix.Config

config_file = "#{Mix.env()}.exs"

if File.exists?(Path.join("config", config_file)) do
  import_config config_file
end
