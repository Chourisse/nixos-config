{ pkgs, ... }:

{
  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      host = "127.0.0.1";
      port = 11434;
      environmentVariables = {
        OLLAMA_KEEP_ALIVE = "0";
      };
    };

    open-webui = {
      enable = true;
      host = "127.0.0.1";
      port = 8080;
      openFirewall = false;
      environment = {
        OLLAMA_BASE_URL = "http://127.0.0.1:11434";
        WEBUI_AUTH = "True";
        ENABLE_RAG_WEB_SEARCH = "True";
        RAG_WEB_SEARCH_ENGINE = "searxng";
        SEARXNG_QUERY_URL = "http://127.0.0.1:8888/search?q=<query>&format=json";
        RAG_WEB_SEARCH_RESULT_COUNT = "5";
        RAG_WEB_SEARCH_CONCURRENT_REQUESTS = "10";
      };
    };

    searx = {
      enable = true;
      redisCreateLocally = false;
      settings = {
        server = {
          port = 8888;
          bind_address = "127.0.0.1";
          secret_key = "f845ee73a31a09e6ad231722cb80aa20d5cdfaa62b40bc893a4c6f81a562cafa";
          limiter = false;
        };
        search.formats = [ "html" "json" ];
      };
    };
  };
}
