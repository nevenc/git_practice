#!/bin/bash

main() {
    if [[ $1 == "--verify" ]] 
    then
	check_that_configuration_is_properly_written $2
    else
	setup_scenario
	generate_description_file
	generate_help_file
	show_scenario_text
    fi
}

show_scenario_text() {
    cat <<EOF
*****************************************************************
Scenario set up.
You can always read 
    description.txt to know what you need to do
    help.txt to get pointers on what to read in order to succeed
    repository.txt  to see where the scenario is created
*****************************************************************
Run this script as
       $0 --verify ${SCENARIO_GIT_REPO}
when you think you are done
*****************************************************************
EOF
echo "> description.txt"
cat description.txt
echo "*****************************************************************"
echo "> help.txt"
cat help.txt
echo "*****************************************************************"
}

setup_scenario() {
    SCENARIO_GIT_REPO=$(mktemp -d)
    pushd ${SCENARIO_GIT_REPO} &> /dev/null
    git init . &> /dev/null
    popd &> /dev/null
    echo ${SCENARIO_GIT_REPO} > repository.txt
}

generate_description_file() {
    cat > description.txt <<EOF
Configure the git repository locally so that the editor is configured 
to emacs in no-window mode, that is
     emacs -nw 
and that the diff tool is configured to be kdiff3

You can find the repository location in the file named 
    repository.txt
EOF
}

generate_help_file() {
    cat > help.txt <<EOF
Chapter 1.5 Getting Started - First Time Git Setup
EOF
}

check_that_configuration_is_properly_written() {
    pushd $1 &> /dev/null
    if [[ ($(git config --local core.editor) == "emacs -nw") &&  
		($(git config --local merge.tool) ==  "kdiff3") ]]
    then
	RES="Verified - you are done"
    else
	RES="No - you are not done"
    fi
    echo ${RES}
    popd &> /dev/null
}

main $@