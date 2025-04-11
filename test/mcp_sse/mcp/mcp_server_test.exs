defmodule MCPServerTest do
  use ExUnit.Case, async: true

  # Mock implementation of the MCPServer behaviour
  defmodule MockServer do
    @behaviour MCPServer

    @impl true
    def handle_ping(request_id) do
      {:ok, %{request_id: request_id, type: "pong"}}
    end

    @impl true
    def handle_initialize(request_id, params) do
      {:ok, %{request_id: request_id, type: "initialize", capabilities: params.capabilities}}
    end

    # Optional callbacks implementation for testing
    @impl true
    def handle_complete(request_id, _params) do
      {:ok, %{request_id: request_id, type: "completion", completion: %{}}}
    end

    @impl true
    def handle_list_prompts(request_id, _params) do
      {:ok, %{request_id: request_id, type: "list_prompts", prompts: []}}
    end

    @impl true
    def handle_get_prompt(request_id, params) do
      {:ok, %{request_id: request_id, type: "get_prompt", description: params.name}}
    end

    @impl true
    def handle_list_resources(request_id, _params) do
      {:ok, %{request_id: request_id, type: "list_resources", resources: []}}
    end

    @impl true
    def handle_read_resource(request_id, _params) do
      {:ok, %{request_id: request_id, type: "read_resource", contents: []}}
    end

    @impl true
    def handle_list_tools(request_id, _params) do
      {:ok, %{request_id: request_id, type: "list_tools", tools: []}}
    end

    @impl true
    def handle_call_tool(request_id, _params) do
      {:ok, %{request_id: request_id, type: "call_tool", content: []}}
    end
  end

  describe "MCPServer behaviour" do
    test "handle_ping implementation" do
      request_id = "123"

      assert {:ok, response} = MockServer.handle_ping(request_id)
      assert response.type == "pong"
      assert response.request_id == request_id
    end

    test "handle_initialize implementation" do
      request_id = "456"

      capabilities = %{version: "1.0"}
      params = %{capabilities: capabilities}

      assert {:ok, response} = MockServer.handle_initialize(request_id, params)
      assert response.type == "initialize"
      assert response.request_id == request_id
      assert response.capabilities == capabilities
    end

    test "optional callback handle_complete" do
      request_id = "789"

      params = %{ref: %{type: "ref/prompt", name: "test_prompt"}}

      assert {:ok, response} = MockServer.handle_complete(request_id, params)
      assert response.type == "completion"
      assert response.request_id == request_id
      assert Map.has_key?(response, :completion)
    end

    test "behaviour module defines expected callbacks" do
      callbacks = MCPServer.behaviour_info(:callbacks)

      assert {:handle_ping, 1} in callbacks
      assert {:handle_initialize, 2} in callbacks
      assert {:handle_complete, 2} in callbacks
      assert {:handle_list_prompts, 2} in callbacks
      assert {:handle_get_prompt, 2} in callbacks
      assert {:handle_list_resources, 2} in callbacks
      assert {:handle_read_resource, 2} in callbacks
      assert {:handle_list_tools, 2} in callbacks
      assert {:handle_call_tool, 2} in callbacks
    end
  end
end
