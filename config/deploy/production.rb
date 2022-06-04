# beanstamp-prod-ec2-web01
server '52.199.124.131', user: 'deploy', roles: %w[app db web]
# beanstampprod-ec2-web02
server '18.178.147.224', user: 'deploy', roles: %w[app db web]

set :ssh_options, {
  keys: %w[~/.ssh/beanstamp-ec2-ed25519.pem],
  forward_agent: true,
  auth_methods: %w[publickey],
}
