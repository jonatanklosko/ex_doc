defmodule ExDoc.RefsTest do
  use ExUnit.Case, async: true
  alias ExDoc.Refs

  defmodule InMemory do
    @type t() :: :ok

    @callback handle_foo() :: :ok

    def foo(), do: :ok

    def foo(x), do: x
    def _foo(x), do: x

    @doc false
    def foo(x, y), do: {x, y}

    @doc false
    def _foo(x, y), do: {x, y}

    @doc "docs..."
    def foo(x, y, z), do: {x, y, z}

    @doc "docs..."
    def _foo(x, y, z), do: {x, y, z}
  end

  test "get_visibility/1" do
    assert Refs.get_visibility({:module, Code}) == :public
    assert Refs.get_visibility({:module, Code.Typespec}) == :hidden
    assert Refs.get_visibility({:module, Unknown}) == :undefined
    assert Refs.get_visibility({:module, InMemory}) == :public

    assert Refs.get_visibility({:function, Enum, :join, 1}) == :public
    assert Refs.get_visibility({:function, Enum, :join, 2}) == :public
    assert Refs.get_visibility({:function, Code.Typespec, :spec_to_quoted, 2}) == :hidden
    assert Refs.get_visibility({:function, Code.Typespec, :spec_to_quoted, 9}) == :undefined
    assert Refs.get_visibility({:function, Enum, :join, 9}) == :undefined
    assert Refs.get_visibility({:function, :lists, :all, 2}) == :public
    assert Refs.get_visibility({:function, :lists, :all, 9}) == :undefined
    assert Refs.get_visibility({:function, InMemory, :foo, 0}) == :public
    assert Refs.get_visibility({:function, InMemory, :foo, 9}) == :undefined

    assert Refs.get_visibility({:function, WithModuleDoc, :foo, 1}) == :public
    assert Refs.get_visibility({:function, WithModuleDoc, :_foo, 1}) == :hidden
    assert Refs.get_visibility({:function, WithModuleDoc, :foo, 2}) == :hidden
    assert Refs.get_visibility({:function, WithModuleDoc, :_foo, 2}) == :hidden
    assert Refs.get_visibility({:function, WithModuleDoc, :foo, 3}) == :public
    assert Refs.get_visibility({:function, WithModuleDoc, :_foo, 3}) == :public
    assert Refs.get_visibility({:function, WithModuleDoc, :foo, 4}) == :undefined
    assert Refs.get_visibility({:function, WithModuleDoc, :_foo, 4}) == :undefined

    assert Refs.get_visibility({:function, WithoutModuleDoc, :foo, 1}) == :public
    assert Refs.get_visibility({:function, WithoutModuleDoc, :_foo, 1}) == :hidden
    assert Refs.get_visibility({:function, WithoutModuleDoc, :foo, 2}) == :hidden
    assert Refs.get_visibility({:function, WithoutModuleDoc, :_foo, 2}) == :hidden
    assert Refs.get_visibility({:function, WithoutModuleDoc, :foo, 3}) == :public
    assert Refs.get_visibility({:function, WithoutModuleDoc, :_foo, 3}) == :public
    assert Refs.get_visibility({:function, WithoutModuleDoc, :foo, 4}) == :undefined
    assert Refs.get_visibility({:function, WithoutModuleDoc, :_foo, 4}) == :undefined

    assert Refs.get_visibility({:function, InMemory, :foo, 1}) == :public
    # assert Refs.get_visibility({:function, InMemory, :_foo, 1}) == :hidden
    # assert Refs.get_visibility({:function, InMemory, :foo, 2}) == :hidden
    # assert Refs.get_visibility({:function, InMemory, :_foo, 2}) == :hidden
    assert Refs.get_visibility({:function, InMemory, :foo, 3}) == :public
    assert Refs.get_visibility({:function, InMemory, :_foo, 3}) == :public
    assert Refs.get_visibility({:function, InMemory, :foo, 4}) == :undefined
    assert Refs.get_visibility({:function, InMemory, :_foo, 4}) == :undefined

    # macros are classified as functions
    assert Refs.get_visibility({:function, Kernel, :def, 2}) == :public

    assert Refs.get_visibility({:function, Unknown, :unknown, 0}) == :undefined

    assert Refs.get_visibility({:type, String, :t, 0}) == :public
    assert Refs.get_visibility({:type, String, :t, 1}) == :undefined
    assert Refs.get_visibility({:type, :sets, :set, 0}) == :public
    assert Refs.get_visibility({:type, :sets, :set, 9}) == :undefined

    assert Refs.get_visibility({:type, WithModuleDoc, :t, 0}) == :public
    assert Refs.get_visibility({:type, WithoutModuleDoc, :t, 0}) == :public
    # types are in abstract_code chunk so not available for in-memory modules
    assert Refs.get_visibility({:type, InMemory, :t, 0}) == :undefined

    # @typep
    assert Refs.get_visibility({:type, :sets, :seg, 0}) == :hidden

    assert Refs.get_visibility({:callback, GenServer, :handle_call, 3}) == :public
    assert Refs.get_visibility({:callback, GenServer, :handle_call, 9}) == :undefined
    assert Refs.get_visibility({:callback, :gen_server, :handle_call, 3}) == :public
    assert Refs.get_visibility({:callback, :gen_server, :handle_call, 9}) == :undefined
    assert Refs.get_visibility({:callback, InMemory, :handle_foo, 0}) == :public
    assert Refs.get_visibility({:callback, WithModuleDoc, :handle_foo, 0}) == :public
    assert Refs.get_visibility({:callback, WithModuleDoc, :handle_macro_foo, 0}) == :public
    assert Refs.get_visibility({:callback, WithoutModuleDoc, :handle_foo, 0}) == :public
    assert Refs.get_visibility({:callback, WithoutModuleDoc, :handle_macro_foo, 0}) == :public
    assert Refs.get_visibility({:callback, InMemory, :handle_foo, 9}) == :undefined
  end

  test "public?/1" do
    assert Refs.public?({:module, Code})
    refute Refs.public?({:module, Code.Typespec})
  end

  test "insert_from_chunk/2 with module that doesn't exist" do
    result = ExDoc.Utils.Code.fetch_docs(:elixir)
    assert :ok = ExDoc.Refs.insert_from_chunk(Elixir, result)
  end
end
