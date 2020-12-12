# Dictionaries

In this place I store all my diccionaries based on [Hunspell](http://hunspell.github.io/) specifications.

With them I configure all other my apps like VSCode, Libreoffice...

So, I can respect spelling of languages easily making a soft link to them:

```shell
# Install library
> sudo apt install hunspell

# Link to vscode dictionarires
> ln -fs .config/dictionaries/* ~/.config/Code/Dictionaries/

# Link to core dictionaries
> sudo ln -fs diccionaries/* /usr/share/hunspell/

# Check
> ls -la .config/dictionaries
> ls -la ~/.config/Code/Dictionaries/
> ls -la /usr/share/hunspell/
```

More dictionaries at next urls:

- https://github.com/titoBouzout/Dictionaries
