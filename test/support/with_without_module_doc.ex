defmodule WithModuleDoc do
  @moduledoc """
  - `t:t/0`, `t:WithModuleDoc.t/0`
  - `c:handle_foo/0`, `c:WithModuleDoc.handle_foo/0`
  - `c:handle_macro_foo/0`, `c:WithModuleDoc.handle_macro_foo/0`
  - `foo/1`, `WithModuleDoc.foo/1`
  - `_foo/1`, `WithModuleDoc._foo/1`
  - `_foo/2`, `WithModuleDoc._foo/2`
  - `foo/2`, `WithModuleDoc.foo/2`
  - `foo/3`, `WithModuleDoc.foo/3`
  - `_foo/3`, `WithModuleDoc._foo/3`

  - `t:t/0`, `t:WithoutModuleDoc.t/0`
  - `c:handle_foo/0`, `c:WithoutModuleDoc.handle_foo/0`
  - `c:handle_macro_foo/0`, `c:WithoutModuleDoc.handle_macro_foo/0`
  - `foo/1`, `WithoutModuleDoc.foo/1`
  - `_foo/1`, `WithoutModuleDoc._foo/1`
  - `_foo/2`, `WithoutModuleDoc._foo/2`
  - `foo/2`, `WithoutModuleDoc.foo/2`
  - `foo/3`, `WithoutModuleDoc.foo/3`
  - `_foo/3`, `WithoutModuleDoc._foo/3`

  """

  @type t() :: :ok

  @callback handle_foo() :: :ok
  @macrocallback handle_macro_foo() :: :ok

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

defmodule WithoutModuleDoc do
  @type t() :: :ok

  @callback handle_foo() :: :ok
  @macrocallback handle_macro_foo() :: :ok

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
