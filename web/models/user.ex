defmodule Blog.User do
  use Blog.Web, :model

  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :role,                  :string
    field :username,              :string
    field :encrypted_password,    :string
    field :password,              :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps
  end

  @required_fields ~w(username role password password_confirmation)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do


    model
    |> cast( params, @required_fields, @optional_fields )
    |> update_change( :username, &String.downcase/1 )
    |> unique_constraint( :username )
    |> validate_password_set( :password )
    |> validate_confirmation( :password )
    |> encrypt_pass( :password )
  end

  def validate_password_set(changeset, field) do
    password_value = get_field(changeset, field)
    encrypted_pass_value = get_field(changeset, :"encrypted_#{field}")

    if password_value == nil && encrypted_pass_value == nil  do
      add_error(changeset, field, "must be set")
    else
      changeset
    end
  end

  defp encrypt_pass( changeset, field ) do

    password_value = get_field(changeset, field)
    if password_value != nil do
      put_change(changeset, :encrypted_password, hashpwsalt( password_value ))
    else
      changeset
    end

  end

end
