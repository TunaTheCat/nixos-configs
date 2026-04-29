{ ... }:
{
  flake.modules.homeManager.helix =
    { lib, ... }:
    {
      programs.helix = {
        enable = true;
        defaultEditor = true;

        themes.base16-ashes-custom = {
          inherits = "stylix";
          "ui.virtual.jump-label" = {
            fg = "#ff69b4";
            modifiers = [ "bold" ];
          };
        };

        settings = {
          theme = lib.mkForce "base16-ashes-custom";
          editor = {
            bufferline = "multiple";
            cursorline = true;
            line-number = "relative";
            true-color = true;
            end-of-line-diagnostics = "hint";
            trim-trailing-whitespace = true;

            inline-diagnostics.cursor-line = "warning";

            statusline.left = [
              "mode"
              "spinner"
              "version-control"
              "file-name"
            ];

            file-picker.hidden = false;

            lsp = {
              display-messages = true;
              display-inlay-hints = true;
              auto-signature-help = true;
            };

            cursor-shape = {
              insert = "bar";
              normal = "block";
              select = "underline";
            };
          };

          keys.normal = {
            "A-x" = "extend_to_line_bounds";
            "X" = [
              "extend_line_up"
              "extend_to_line_bounds"
            ];
            "H" = "goto_previous_buffer";
            "L" = "goto_next_buffer";
            "A-w" = ":buffer-close";
            "A-/" = "repeat_last_motion";
          };

          keys.select = {
            "A-x" = "extend_to_line_bounds";
            "X" = [
              "extend_line_up"
              "extend_to_line_bounds"
            ];
          };
        };

        languages = {
          language-server = {
            clangd.command = "clangd";
            vscode-json-language-server.config = {
              json = {
                validate.enable = true;
                format.enable = true;
              };
              provideFormatter = true;
            };
            vscode-css-language-server.config = {
              css.validate.enable = true;
              scss.validate.enable = true;
              less.validate.enable = true;
              provideFormatter = true;
            };
          };

          language = [
            {
              name = "nix";
              language-servers = [ "nil" ];
              formatter.command = "nixpkgs-fmt";
              auto-format = true;
            }
            {
              name = "go";
              formatter.command = "gofmt";
              auto-format = true;
            }
            {
              name = "typescript";
              language-servers = [ "typescript-language-server" ];
              formatter = {
                command = "npx prettier";
                args = [ "--parser" "typescript" ];
              };
              auto-format = true;
            }
            {
              name = "json";
              formatter = {
                command = "npx prettier";
                args = [ "--parser" "json" ];
              };
              auto-format = true;
            }
            {
              name = "html";
              language-servers = [ "vscode-html-language-server" "emmet-ls" ];
              formatter = {
                command = "npx prettier";
                args = [ "--parser" "html" ];
              };
              auto-format = true;
            }
            {
              name = "css";
              language-servers = [ "vscode-css-language-server" "emmet-ls" ];
              formatter = {
                command = "npx prettier";
                args = [ "--parser" "css" ];
              };
              auto-format = true;
            }
            {
              name = "cpp";
              scope = "source.cpp";
              injection-regex = "cpp";
              file-types = [
                "cc" "hh" "c++" "cpp" "hpp" "h" "ipp" "tpp" "cxx" "hxx"
                "ixx" "txx" "ino" "C" "H" "cu" "cuh" "cppm" "h++" "ii" "inl"
              ];
              comment-token = "//";
              block-comment-tokens = { start = "/*"; end = "*/"; };
              language-servers = [ "clangd" ];
              indent = { tab-width = 2; unit = "  "; };
              auto-format = true;
              debugger = {
                name = "lldb-dap";
                transport = "stdio";
                command = "lldb-dap";
                templates = [
                  {
                    name = "binary";
                    request = "launch";
                    completion = [{ name = "binary"; completion = "filename"; }];
                    args = { console = "internalConsole"; program = "{0}"; };
                  }
                  {
                    name = "attach";
                    request = "attach";
                    completion = [ "pid" ];
                    args = { console = "internalConsole"; pid = "{0}"; };
                  }
                ];
              };
            }
          ];

          grammar = [
            {
              name = "cpp";
              source = {
                git = "https://github.com/tree-sitter/tree-sitter-cpp";
                rev = "56455f4245baf4ea4e0881c5169de69d7edd5ae7";
              };
            }
          ];
        };
      };
    };
}
