#!/bin/bash
# Shell script that checks if there are open pull requests for a repository by GitHub repository link.

version=0.1

# Help information for -h option
help_info=$(cat <<EOF
Shell script that checks if there are open pull requests for a repository by GitHub repository link.
A link is like "https://github.com/$user/$repo".
This script also does the following:
    - Prints the sorted list of the most productive contributors (authors of more than 1 open PR).
    - (-)Prints the number of PRs each contributor has created with the labels.
    - Prints info about repository owner.

Usage:
    git.sh [-u username] [-t token] [-d] [-v|-h] link

Options:
    -u GitHub username (optional)
    -t GitHub OAuth token (optional)
    -d Debug mode, no argument needed (optional)
    -v Version, no argument needed (optional)
    -h Help information about script, no argument needed (optional)
EOF
)

# Preparing checks: curl & jq availability on system 
if [[ -z "$(which curl)" ]]; then
    echo -en "\033[37;1;41m  Error!  \033[0m You have not curl on your system! You may install it and try again.\n"
    exit
fi

if [[ -z "$(which jq)" ]]; then
    echo -en "\033[37;1;41m  Error!  \033[0m You have not jp on your system! You may install it and try again.\n"
    exit
fi

# Collecting agruments and options
while [ -n "$1" ]; do
    case "$1" in
    -u) param="$2" 
        username=$param
        debug_info+="\033[44mDebug info\033[0m Found the -u (username) option with argument value $param\n"
        shift ;;
    -t) param="$2"
        token=$param
        debug_info+="\033[44mDebug info\033[0m Found the -t (token) option with argument value $param\n"
        shift ;;
    -d) debug_flag=1
        debug_info+="\033[44mDebug info\033[0m Found the -d (debug) option\n";;
    -v) version_flag=1
        debug_info+="\033[44mDebug info\033[0m Found the -v (version) option\n";;
    -h) help_flag=1
        debug_info+="\033[44mDebug info\033[0m Found the -h (help) option\n";;   
    --) shift
        break ;;
    -?*) debug+="\033[44mDebug info\033[0m $1 is not an option for that script\n";;
    *) break ;;
    esac
    shift
done

if [[ "$debug_flag" == 1 ]]; then
    echo -en $debug_info
    debug_info=''
fi

if [[ "$help_flag" == 1 ]]; then
    echo "${help_info}"
    exit
fi

if [[ "$version_flag" == 1 ]]; then
    echo "$(basename $0) version: $version"
    exit
fi

link="${1}"

if [ -z "$link" ]; then
    echo -en "\033[37;1;41m  Error!  \033[0m Link isn't set. Please, specify the link and try again. \n" 
    exit
fi

# Parsing link
parsed_link=($(echo $link | awk '{split($0, arr, /[\/\@:]*/); for (pulls_page in arr) { print arr[pulls_page] }}'))
protocol=${parsed_link[0]}
host=${parsed_link[1]}
user=${parsed_link[2]}
repo=${parsed_link[3]}

debug_info+="\033[44mDebug info\033[0m Protocol: $protocol\n\033[44mDebug info\033[0m Host: $host\n\033[44mDebug info\033[0m User: $user\n\033[44mDebug info\033[0m Repo: $repo\n\033[44mDebug info\033[0m Username: $username\n\033[44mDebug info\033[0m Token: $token\n"

# Check OAuth token and GitHub username
if [[ -z "$username" ]] || [[ -z "$token" ]]; then
    curl_params=''
    echo -e "\033[43;1;43m Notice!  \033[0m Script don't use OAuth tokens to access GitHub.\n\033[43;1;43m Notice!  \033[0m You can reach rate limit (60 requests per hour)."
    debug_info+="\033[44mDebug info\033[0m curl don't use OAuth tokens to access GitHub.\n"
else
    curl_params="-u $username:$token"
    debug_info+="\033[44mDebug info\033[0m curl use OAuth tokens to access GitHub\n"
fi

# Repo owner account information show function
repo_owner_info () {
    git_user_info_json=$(curl $curl_params https://api.github.com/users/$user 2> /dev/null)
    git_login=$(jq --raw-output '.login' <<< $git_user_info_json)
    git_name=$(jq --raw-output '.name' <<< $git_user_info_json)
    git_avatar_url=$(jq --raw-output '.avatar_url' <<< $git_user_info_json)
    git_public_repos=$(jq --raw-output '.public_repos' <<< $git_user_info_json)
    git_created_at=$(jq --raw-output '.created_at' <<< $git_user_info_json)
    echo -e "\e[1;32m█  Login\e[0m:\t \033[44m"$git_login"\033[0m"
    echo -e "\e[1;32m█  Name\e[0m:\t \033[44m"$git_name"\033[0m"
    echo -e "\e[1;32m█  Public repos\e[0m: \033[44m"$git_public_repos"\033[0m"
    echo -e "\e[1;32m█  Created\e[0m:\t \033[44m"$git_created_at"\033[0m\n"
} 

#
pulls_page=1
temp_query=$(curl $curl_params 'https://api.github.com/repos/'$user'/'$repo'/pulls?page='$pulls_page'' 2> /dev/null | jq -j '.[] | .user.login, "\n"')
while [[ ! -z "$temp_query" ]]
    do
    pulls_info_contributors+=($(curl $curl_params 'https://api.github.com/repos/'$user'/'$repo'/pulls?page='$pulls_page'' 2> /dev/null | jq -j '.[] | .user.login, "\n"'))
    pulls_page=$(( $pulls_page + 1 ))
    temp_query=$(curl $curl_params 'https://api.github.com/repos/'$user'/'$repo'/pulls?page='$pulls_page'' 2> /dev/null | jq -j '.[] | .user.login, "\n"')
done

debug_info+="\033[44mDebug info\033[0m Pulls pages counter value: $pulls_page\n"
debug_info+="\n\033[44mDebug info\033[0m Countributers list:\n"

for i in ${pulls_info_contributors[@]}
    do
    debug_info+="\033[44mDebug info\033[0m $i\n"
done

if [[ "$debug_flag" == 1 ]]; then
    echo -e $debug_info''
    debug_info=''
fi

# Calculating PR for each contributor
declare -A pulls_info_contributors_with_count
for i in "${pulls_info_contributors[@]}"; do 

    if [[ -v pulls_info_contributors[$i] ]]; then
        pulls_info_contributors_with_count[$i]=$((${pulls_info_contributors_with_count[$i]}+1))
    else
        pulls_info_contributors_with_count[$i]=1
    fi
done

echo -e "\nRepository link: "$link

if [[ "${#pulls_info_contributors[@]}" > 0 ]]; then
    echo -e "\nThis repository have \e[1;32m${#pulls_info_contributors[@]}\e[0m open Pull Requests."
    echo -e "\nList of the most productive contributors (>1 open PR):\n"
    # Sorting contributers by PR and output all those with PR > 1
    for k in "${!pulls_info_contributors_with_count[@]}"
        do
        if [[ "${pulls_info_contributors_with_count["$k"]}" > 1 ]]; then
            echo -e "\e[1;32m"${pulls_info_contributors_with_count["$k"]}" PR\e[0m - \e[1;33m"$k"\e[0m" 
        fi
    done | sort -rn -k3

    echo -e "\nAnd also we have information about the repo owner:\n"
    repo_owner_info
else
    echo -e "This repository \e[1;31mhaven't\e[0m open Pull Requests, try different repository."
    echo -e "But we have information about the repo owner:\n"
    repo_owner_info
fi