# Blog

To start the blog:

  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Drag in javascript dependencies using `npm install`.
  4. Copy dev.secret.exs.example to dev.secret.exs and fill it in.
  5. Set up an admin User for yourself:
    ```elixir
     Blog.Repo.insert(User.changeset(%User{}, %{ username: "rory", role: "admin", password: "password", password_confirmation: "password"}))
     ```
  6. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## TODO
 -  [x] Add captcha to login
 -  [ ] Tidy up nav etcc
 -  [ ] Write first blog post
 -  [ ] Add disqus
 -  [ ] Add google analytics
 -  [ ] Document creating user: Blog.Repo.insert( Blog.User.changeset(%Blog.User{}, %{ username: "", password: "", password_confirmation: "", role: ""} )
 -  [ ] tidy up dockerfile so it's just prod
 -  [ ] use rds?
 -  [ ] turn all secrets and env config to use env
 -  [ ] [check the deployment guides](http://www.phoenixframework.org/docs/deployment).
 -  [ ] deploy it

## Connecting to box

ssh -i <key> ec2-user@<public dns for instance>
