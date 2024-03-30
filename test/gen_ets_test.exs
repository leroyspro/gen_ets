defmodule GenETSTest do
  use ExUnit.Case

  setup do
    table_name = GenETS.start_link()

    {:ok, table_name: table_name}
  end

  describe "GenETS read/2" do
  end
  
  describe "GenETS write/3" do
  end

  describe "GenETS delete/2" do
  end

  describe "GenETS prune/1" do
  end

  describe "GenETS exists?/2" do
  end
end
