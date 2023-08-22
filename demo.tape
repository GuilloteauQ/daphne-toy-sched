# Where should we write the GIF?
Output demo.gif

# Set up a 1200x600 terminal with 46px font.
Set FontSize 20
Set Width 1920
Set Height 1080


Type "echo 'Enter the environment with the modified `daphne`'"
Enter
Sleep 5s

Type "nix develop .#daphne-cst-shell"
Enter
Sleep 5s

Type "daphne --help | head -n 28"
Enter

Sleep 5s

Type "echo 'The new scheduler is called CST'"
Enter
Sleep 5s

Type 'daphne --vec --num-threads=4 --select-matrix-representations --partitioning=CST --args f=\"./data/Amazon0601_0.csv\" --args iterations=1 src/components_read.daphne'
Enter
Sleep 10s

Type "echo 'We actually need to pass the size of the block through `DAPHNE_CST_TASK_SIZE`'"
Enter
Sleep 5s

Type 'DAPHNE_CST_TASK_SIZE=42 daphne --vec --num-threads=4 --select-matrix-representations --partitioning=CST --args f=\"./data/Amazon0601_0.csv\" --args iterations=1 src/components_read.daphne'

Enter

# Admire the output for a bit.
Sleep 10s

