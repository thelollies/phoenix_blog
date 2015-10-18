# Blog

To start the blog:

  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Drag in javascript dependencies using `npm install`.
  4. Copy dev.secret.exs.example to dev.secret.exs and fill it in.
  5. Set up an admin User for yourself:
    ```
     Blog.Repo.insert(Blog.User.changeset(%Blog.User{}, %{ username: "rory", role: "admin", password: "password", password_confirmation: "password"}))
     ```
  6. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## TODO
 -  [x] Add captcha to login
 -  [x] Add disqus
 -  [x] Add google analytics
 -  [x] Turn all secrets and env config to use env.
 -  [x] Handle accessing post with non existant id (text or wrong id) or unpublished (404).
 -  [x] Make captcha not used in dev.
 -  [x] Determine why priv/assets was in .gitignore and move stuff if needed.
 -  [x] Tidy up the Dockerfile so it's bare-bones prod requirements.
 -  [x] Check the [deployment guides](http://www.phoenixframework.org/docs/deployment).
 -  [x] use RDS
 -  [x] Deploy it
 -  [ ] Blog post URLs based on title (add permalink field which is - joined lowercase ascii representation and look up on that)
 -  [ ] SSL
 -  [ ] Fix hard-coded integer environment variables.

## Connecting to box

ssh -i <key> ec2-user@<public dns for instance>
