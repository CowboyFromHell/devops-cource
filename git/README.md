# Git API Script

Shell script that checks if there are open pull requests for a repository by GitHub repository link.

A link is like https://github.com/user/repo

This script also does the following:
* Prints the sorted list of the most productive contributors (authors of more than 1 open PR).
* (-)Prints the number of PRs each contributor has created with the labels.
* Prints info about repository owner.


### Requirements:
+ [jq](https://stedolan.github.io/jq/)
+ [curl](https://curl.se)

### Usage:
```sh    
git.sh [-u username] [-t token] [-d] [-v|-h] link
```

### Options:
+ **-u** GitHub username (***optional***)
+ **-t** GitHub OAuth token (***optional***)
+ **-d** Debug mode, no argument needed (***optional***)
+ **-v** Version, no argument needed (***optional***)
+ **-h** Help information about script, no argument needed (***optional***)

### Notes: 
1. The order of the options is **not important**.
2. For **-h** and **-v** options **link** *isn't necessary*.
3. You can create a OAuth token in your [GitHub account settings](https://github.com/settings/tokens), it allows you to increase the rate limit to GitHub API from 60 to 5000 requests per hour.

### Usage examples:

```sh
git.sh -u MikeKozhevnikov -t *** 'http://github.com/SerenityOS/serenity'

```

```sh
git.sh -d 'http://github.com/SerenityOS/serenity'

```

```sh
git.sh -h
```

---


## Unleash your creativity with GitHub
* write a script that checks if there are open pull requests for a repository. An url like "https://github.com/user/repo" will be passed to the script
* print the list of the most productive contributors (authors of more than 1 open PR)
* print the number of PRs each contributor has created with the labels
* implement your own feature that you find the most attractive: anything from sorting to comment count or even fancy output format
* ask your chat mate to review your code and create a meaningful pull request
* do the same for her xD
* merge your fellow PR! We will see the repo history

### Hints
* [Have a look here](https://github.com/trending)
* read about GitHub API
* make use of curl and jq