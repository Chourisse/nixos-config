{ config, pkgs, ... }:

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
      };
    };
  };
}
