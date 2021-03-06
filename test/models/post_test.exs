defmodule Blog.PostTest do
  use Blog.ModelCase

  alias Blog.Post

  @valid_attrs %{basename: "some content", date: "2010-04-17", file: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
