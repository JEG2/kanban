# Kanban

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Finding Instances

    aws ec2 describe-instances --query "Reservations[*].Instances[*].{IP:PublicIpAddress}" --filters "Name=tag:aws:autoscaling:groupName,Values=swarm-asg" "Name=instance-state-name,Values=running" --region us-west-1 --output text | awk '{print "ssh -i ./private_key.pem ec2-user@"$1}'

## Seeding

    docker ps
    docker exec -ti CONTAINER_ID bin/seed
