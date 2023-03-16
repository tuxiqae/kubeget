# Configuration file for VHS -- https://github.com/charmbracelet/vhs
Require kubeget

# Output file
Output kubeget.gif

# Set GIF dimensions
Set FontSize 20
Set Width 1600
Set Height 600
Set Framerate 60

# Welcome
Type "echo 'Welcome to Kubeget ☸🐳'"
Sleep 200ms
Enter

# Run kubeget
Type "kubeget --version && kubeget --help"
Sleep 200ms
Enter
Sleep 2s
Type "Let's list all pods, without filtering any"
Sleep 1s
Backspace 43
Type "kubeget"
Enter
Sleep 2s
Type "And now a specific namespace"
Sleep 2s
Backspace 28
Enter
Type "kubeget --namespace=default"
Enter

# Admire the output for a bit.
Sleep 5s
