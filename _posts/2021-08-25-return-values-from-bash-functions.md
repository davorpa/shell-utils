---
layout: post
comments: true
category: posts
tags: [programming, scripting, shell, bash, how-to, coding, tech tips]
title: Bash. How to return values from functions
lang: en
excerpt_separator: <!--more-->
excerpt_image: /assets/posts/returning-values-from-bash-functions.jpg
thumbnail_image: /assets/posts/returning-values-from-bash-functions.jpg
created_at: 2021-08-25T12:00:00.0Z
#created_by:
last_modified_at: 2021-09-04T18:00:00.0Z
#last_modified_by:
alternate:
    es: 2021-08-25-return-values-from-bash-functions
---
---

<!--
![A Bash code snippet where it is shown how to return values both by standard output and by output variables](../assets/posts/returning-values-from-bash-functions.jpg)
-->

![A Bash code snippet where it is shown how to return values both by standard output and by output variables]({{ '/assets/posts/returning-values-from-bash-functions.jpg' | relative_url }})

**Bash functions**, unlike functions in most programming languages **do not allow you to return a value to the caller**. When a bash function ends its return value is its status: zero for success, non-zero for failure. To return values, you can set a **global variable** with the result, or use **command substitution**, or you can **pass in the name of a variable** to use as the result variable. The examples below describe these different mechanisms.
<!--more-->

Although bash has a `return` statement, the only thing you can specify with it is the function's status, which is a numeric value, between 0 and 255, like the value specified in an `exit` statement. The status value is stored in the `$?` variable. If a function does not contain a `return` statement, its status is set based on the status of the last statement executed in the function. To actually return arbitrary values to the caller you must use other mechanisms.

The simplest way to return a value from a bash function is to just **set a global variable** to the result. Since all variables in bash are global by default this is easy:

```bash
# declare
function awesome_func() {
    # set global variable value
    my_result='some value'
}

# call / invoke
awesome_func
echo $my_result
```

The code above sets the global variable `my_result` to the function result. Reasonably simple, but as we all know, using global variables, particularly in large programs, can lead to difficult to find bugs.

A better approach is to **use local variables** in your functions. The problem then becomes how do you get the result to the caller. One mechanism is to use command substitution, also called sub-shells:

```shell
function awesome_func() {
    # do some work
    local my_result;
    my_result='some value'
    # print to standard output
    echo "$my_result"
}

# call /invoke in a subshell
result=$(awesome_func)
# or using the legacy way (with backticks)...
#result=`awesome_func`
echo $?          # numeric function exit code. `echo "$my_result"`
echo $result
echo $my_result  # <-- empty/undefined
                 # due to it's local scoped to `awesome_func`
```

Here the result is output to the stdout **and the caller uses command substitution to capture the value** in a variable. The variable can then be used as needed. Just one drawback, performance issues: the cost of opening a terminal thread.

The other way to return a value is to **write your function so that it accepts a variable name** as part of its command line **and then set that variable to the result** of the function:

```shell
function awesome_func() {
    # save output variable name parameter
    local __var_outval=$1
    # do some work
    local my_result;
    my_result='some value'
    # assign result to output variable
    eval $__var_outval="'$my_result'"
}

# call with variable name argument
awesome_func result
echo $?          # numeric function exit code. `eval...`.
# here `result` variable contains assigned value
echo $result
```

Since we have the name of the variable to set stored in a variable, we can't set the variable directly, we have to use `eval` to actually do the setting. The `eval` statement basically tells bash to interpret the line twice, the first interpretation above results in the string `my_result='some value'` which is then interpreted once more and ends up setting the caller's variable.

When you store the name of the variable passed on the command line, **make sure you store it in a local variable with a name** that won't be (unlikely to be) used by the caller (which is why I used `__var_outval` rather than just `var_outval`). If you don't, and the caller happens to choose the same name for their result variable as you use for storing the name, the result variable will not get set. For example, the following does not work:

```shell
function awesome_func() {
    local result=$1             # caller variable name collision
    local my_result;
    my_result='some value'
    eval $result="'$my_result'" # variable assign collision
}

awesome_func result
echo $result
```

The reason it doesn't work is because when `eval` does the second interpretation and evaluates `result='some value'`, result is now a local variable in the function, scope is preserved and so it gets set rather than setting the caller's result variable.

**For more flexibility**, you may want to write your functions so that they **combine both**, result variables and command substitution:

```shell
function awesome_func() {
    # save output variable name parameter
    local __var_outval=$1
    # do some work
    local my_result;
    my_result='some value'
    # decide how to output computed value
    if [ -n "$__var_outval" ]; then         # if name provided...
        eval $__var_outval="'$my_result'"   # ... assign
    else                     # if not...
        echo "$my_result"    # ... print to standard output
    fi
}

awesome_func result
echo $?          # numeric function exit code. `eval...`.
echo $result
result2=$(awesome_func)
echo $?          # numeric function exit code. `echo...`.
echo $result2
```

Here, if no variable name is passed to the function, , `[[ "$__var_outval" ]]` is evaluated to `false` and then, the value is output to the standard output.

## A real showcase

And here a little more advanced function, a live portrait of the image that can be seen as post heading. :rocket:

It put in practice all together, delegating the standard output enhancement to a merely option flag argument:

```shell
function extract_meta() {
  # support both, in/out variables either write result to stdout
  local __var_pipe_mode=0
  if [ "$1" = "-o" ]; then
    __var_pipe_mode=1          # enable flag
    shift                      # consume parameter
  fi
  local __var_outval;
  local __var_in_metas=$1      # all properties, one per line: name=value
  local __var_in_prop=$2       # token to search
  local __var_outname=$3       # variable alias where output result
  if [ -z "$__var_outname" ]; then   # use token as default
    __var_outname="$__var_in_prop"
  else  # if both options are provided, warn in stderr
    [ $__var_pipe_mode -eq 1 ] && {
      printf >&2 "\e[33mwarn\e[0m: \e[32m-o\e[0m is flag set. Pipe mode has prevalence over output variable: %s" "$__var_outname"
    }
  fi

  __var_outval="$__var_in_metas"
  __var_outval=${__var_outval#*$__var_in_prop=}   # substring after first token
  __var_outval=${__var_outval%%$'\n'*}            # substring before first token

  if [ $__var_pipe_mode -eq 0 ]; then
    eval $__var_outname="'$__var_outval'"
  else
    printf "$__var_outval"
  fi
}
```

And go ahead with tests. Here below, we have some to check how it works in each case :wink::

```shell
# Giving ...
metas="
  exitcode=%{exitcode}
  errormsg=%{errormsg}
  http_code=%{http_code}
  num_redirects=%{num_redirects}
  redirect_url=%{redirect_url}
  url_effective=%{url_effective}
"

# Do ...
extract_meta "$metas" exitcode
echo "$exitcode"      # %{exitcode}

extract_meta "$metas" errormsg myerror
echo "$errormsg"      # <-- empty/undefined
                      # due to variable name is the 3th argument: `myerror`
echo "$myerror"       # %{errormsg}

http_code=$(extract_meta -o "$metas" http_code)
echo $?               # numeric function exit code. `echo "$my_result"`
echo "$http_code"     # %{http_code}
```

Automate!! It's said... :smile:

*Passion = Learn + Code + Enjoy + Repeat* :hugs:
