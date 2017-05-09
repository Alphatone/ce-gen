#!/usr/bin/env bash
clear
echo
echo "##################TYPO3 t3cegenerator by analog 2017 ####################"
echo "# This Generator generates an Contentelement to your provider extension #"
echo "#########################################################################"
echo

COLUMNS=12

if [ -f ~/.profile ]
    then
    source ~/.profile
fi
continue=true
bindir=vendor/analogde/ce-gen
libdir=vendor/analogde/ce-lib

source $bindir/bin/dir-selector.sh

extname="$(basename $extensiondir)"

ctype () {
    read -p "Enter cType you want to create: " cename
    while [[ $cename == '' ]]
    do
        echo "Enter a valid Name"
        read -p "Enter cType you want to create: " cename
    done
    cename=$(echo "$cename" | sed 's/ //g' | sed 's/[^a-zA-Z0-9]//g' | tr '[:upper:]' '[:lower:]')
    cenameUpper=${cename};
    cenameUpper=`echo ${cenameUpper:0:1} | tr  '[a-z]' '[A-Z]'`${cenameUpper:1}
    if [ -f "${extensiondir}/Configuration/PageTS/ContentElements/typoscript_${cename}.t3s" ]
    then
        echo "Content Element exists"
        exit 1
    fi
}

title () {
    read -p "Content Element Title: " cetitle
    while [[ ${cetitle} == '' ]]
    do
        read -p "Content Element Title: " cetitle
        echo "Enter a valid Content Element Title"
    done
}

description () {
    read -p "Content Element Description: " cedescription
    while [[ ${cedescription} == '' ]]
    do
        read -p "Content Element Description: " cedescription
        echo "Enter a valid Content Element Description"
    done
}

create_simple_ce () {
    ctype
    if [ -f "${extensiondir}/Configuration/TCA/Overrides/tt_content_${cename}.php" ]
        then
            echo
            echo "This cType is already present"
            echo
            exit 1
        else
            title
            description
            echo
            source ${bindir}/bin/basic-generator.sh
            echo
    fi
}

create_irre_ce () {
    ctype
    if [ -f "${extensiondir}/Configuration/TCA/Overrides/tt_content_${cename}.php" ]
        then
            echo
            echo "This cType is already present"
            echo
            exit 1
        else
            title
            description
            echo
            source ${bindir}/bin/irre-generator.sh
            echo
    fi
}

choose_type_to_generate () {
    PS3='What type of element do you want to generate: '
    options=("Default Item" "Irre Item")
    select opt in "${options[@]}"
    do
        case $opt in
            "Default Item")
                echo
                create_simple_ce
                echo
                break
                ;;
            "Irre Item")
                echo
                create_irre_ce
                echo
                break
                ;;
            *) echo invalid option;;
        esac
    done
}

clear_cache() {
if [ -f typo3cms ]
    then
        echo "Clear Cache and Update Schema"
        php typo3cms database:updateschema "*"
        php typo3cms cache:flush --force
fi
}

run_generator () {
    if [ -d "vendor/analogde/ce-lib" ]
    then
        read -p "Do you want to import a cType from the library? [Y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            source ${bindir}/bin/ce-library-tool.sh
        else
            echo
            echo "Ok! Create custom cType now:"
            choose_type_to_generate
        fi
    else
        choose_type_to_generate
    fi
}

restart () {
    echo
    echo
    read -p "Do you want to restart? [Y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        continue=true
        echo
    else
        continue=false
        echo
        echo "Bye!"
    fi
}

while [ $continue == "true" ]
do
    run_generator
    clear_cache
    restart
done