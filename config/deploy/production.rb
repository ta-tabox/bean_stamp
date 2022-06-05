# beanstamp-prod-ec2-web01
server 'web01.bean-stamp.com', user: 'deploy', roles: %w[app db web]
# beanstampprod-ec2-web02
server 'web02.bean-stamp.com', user: 'deploy', roles: %w[app db web]

set :ssh_options, {
  keys: [ENV.fetch('PRODUCTION_SSH_KEY').to_s],
  forward_agent: true,
  auth_methods: %w[publickey],
}
