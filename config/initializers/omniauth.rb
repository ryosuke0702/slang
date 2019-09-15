Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,ENV['357295418270974'],ENV['da41206ce7167142564326266a8b6ffd']
  provider :google_oauth2,ENV['581820041444-0jecs5n0fnl22401i49igdp5qch0171b.apps.googleusercontent.com'],ENV['MOVdE7TV3vAB2GCkcLncGdRw'], {:skip_jwt => true }

  {:provider_ignores_state => true}
end
