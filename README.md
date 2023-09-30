# LLVM Setup Script

This script automates the setup of a development environment for the **"GNU/Linux System Software"** course at St. Petersburg Polytechnic University, instructed by Alexey Levchenko. It primarily focuses on setting up LLVM and related tools.

## Usage

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/seigtm/llvm-setup.git
   ```

2. Change into the cloned directory:

   ```bash
   cd llvm-setup
   ```

3. Inside the script, you may need to configure variables to match your specific requirements. Pay attention to variables like `llvm_id`, `jobs_compiler`, `jobs_linker`, and directories like `home_dir`, `dev_dir`, `llvm_build`, `llvm_ccache`, `llvm_install`, `llvm_module`, `llvm_src`, and `llvm_src_main`. Customize these variables as needed.

4. Make the script executable:

   ```bash
   chmod +x setup.sh
   ```

5. Run the script:

   ```bash
   ./setup.sh
   ```

## What It Does

- Updates the system and installs necessary packages.
- Sets up directories for LLVM and related tools.
- Clones the LLVM repository and creates a worktree for a specific branch.
- Configures and builds LLVM with specified options.
- Updates the user's environment settings.
- Creates a module file for LLVM.
