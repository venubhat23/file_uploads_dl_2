# Puma configuration for production deployment

# The environment Puma will run in.
environment ENV.fetch('RAILS_ENV', 'production')

# Specifies the number of `workers` to boot in clustered mode.
workers ENV.fetch('WEB_CONCURRENCY', 2)

# Use the `preload_app!` method when specifying a `workers` number.
preload_app!

# Bind to all interfaces
port ENV.fetch('PORT', 8080)
bind "tcp://0.0.0.0:#{ENV.fetch('PORT', 8080)}"

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart