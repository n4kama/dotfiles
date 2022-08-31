# PICOM config

Tips : 
1. Filter which app gets transparency or not.
   1. Ensure that `inactive-opacity` and `active-opacity` are set to '1'
   2. Modify `opacity-rule` to set opacity on specific window. Example for Alacritty : 
   ```
    "90:class_g = 'Alacritty' && focused",
    "50:class_g = 'Alacritty' && !focused"
   ```

Using picom on i3 : 
1. Add `exec --no-startup-id picom -b` to your i3 config
2. Reload config file