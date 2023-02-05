#!/bin/bash

AUTHOR="Skull"
VERSION="2.3"

# Function to initialize a new Git repository and add a remote
function setupRepo() {
    # Clear the terminal screen
    clear

    # Initialize a new Git repository
    echo "Initializing new Git repository..."
    rm -rf .git

    # option to select the branch default name
    # echo ""
    # echo "Select the default branch name (default: main):"
    # echo ""
    # read -r branchname
    # if [[ "$branchname" == "" ]]; then
    #     branchname="main"
    # fi
    echo ""

    git init -b main

    echo ""

    echo -e "Git repository initialized with \033[0;32mmain\033[0m branch"

    # Set the user's email and name
    echo ""
    echo "Enter your email address: "
    read -r useremail

    # Verify the email address using a regular expression
    emailRegex="^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$"
    if [[ $useremail =~ $emailRegex ]]; then
        git config user.email "$useremail"
    else
        echo "Invalid email address"
        return 1
    fi

    echo ""
    echo "Enter your name: "
    read -r username
    git config user.name "$username"

    # Add a remote repository
    echo ""
    echo "Enter the remote address: "
    read -r remoteaddr
    git remote add origin "$remoteaddr"

    # success in green color
    echo ""
    echo -e "\033[0;32mSuccessfully set up Git repository\033[0m"
}

# Function to push changes to the remote
# Arguments:
#   - $1: option for pulling changes before pushing (U = update, F = update and force push)
function pushChanges() {

    clear

    # give option to type the branch name, if not main will be used
    echo ""
    echo "Select the branch name (default: main):"
    echo ""
    read -r branchname
    if [[ "$branchname" == "" ]]; then
        branchname="main"
    fi

    if [[ "$1" == "U" ]]; then
        clear

        # Pull the latest changes from the remote
        echo "Pulling latest changes from remote..."
        git pull --ff origin "$branchname"
    fi

    # Add all changed files
    git add .

    clear

    # Prompt the user for a commit message
    echo ""
    echo "Enter your commit message: "
    read -r commitmsg

    # Create the commit
    git commit -m "$commitmsg"

    clear
    echo ""

    # print selected branch name
    echo "Selected branch: $branchname"
    echo ""

    # Push the changes to the remote
    if [[ "$2" == "F" ]]; then
        # Force push to resolve any non-fast-forward conflicts
        echo "Pushing changes to remote (resolving non-fast-forward conflicts)..."
        git push -u -f origin "$branchname"
    else
        echo "Pushing changes to remote..."
        git push -u origin "$branchname"
    fi
}

echo ""
echo "-------------------------------"
echo "This is an script which will"
echo "help you with github cmds."
echo ""
echo -e "version: \033[0;32m$VERSION\033[0m"
echo ""
echo -e "Author: \033[0;32m$AUTHOR\033[0m"
echo "-------------------------------"
echo ""

# Check if a Git repository has been set up
if [ -a ".git" ]; then

    echo "Git repository already exists."
    echo "What would you like to do?"
    echo ""
    # print current branch name
    echo -e "Current branch: \033[0;32m$(git branch --show-current)\033[0m"
    echo ""
    echo "-------------------------------"
    echo "1: Initialize a new repository"
    echo "2: Push changes to the remote"
    echo "3: Update and push changes to the remote"
    echo -e "4: Force push changes to the remote \033[0;33m(Warning: this will overwrite any changes on the remote)\033[0m"
    echo "-------------------------------"
    echo ""
    read -r selectedOption

    case "$selectedOption" in
    1) setupRepo ;;
    2) pushChanges ;;
    3) pushChanges "U" ;;
    4) pushChanges "U" "F" ;;
    *) echo "Invalid option. Please try again." ;;
    esac

else
    setupRepo
fi
