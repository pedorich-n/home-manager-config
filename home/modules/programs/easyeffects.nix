{
  services.easyeffects = {
    extraPresets = {
      "Voice Processing" = {
        input = {
          blocklist = [ ];
          "deepfilternet#0" = {
            attenuation-limit = 65.0;
            bypass = false;
            input-gain = 0.0;
            max-df-processing-threshold = 20.0;
            max-erb-processing-threshold = 25.0;
            min-processing-buffer = 0;
            min-processing-threshold = -15.0;
            output-gain = 0.0;
            post-filter-beta = 0.05;
          };
          "echo_canceller#0" = {
            bypass = false;
            echo-canceller = {
              automatic-gain-control = false;
              enable = true;
              enforce-high-pass = true;
              mobile-mode = false;
            };
            high-pass = {
              enable = true;
              full-band = true;
            };
            input-gain = 0.0;
            noise-suppression = {
              enable = false;
              level = "Moderate";
            };
            output-gain = 0.0;
          };
          plugins_order = [
            "deepfilternet#0"
            "echo_canceller#0"
          ];
        };
      };
    };
  };
}
