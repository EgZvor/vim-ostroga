# Ostroga

... is just a popup with global marks and the ability to jump to them.

It is a minimalistic alternative to [harpoon](https://github.com/ThePrimeagen/harpoon).

![](https://user-images.githubusercontent.com/11237935/181624607-b0caf89b-eb19-486f-89bd-453e404a889c.png)

## Usage

- Create a couple of **global** (upper case) marks.
- Create a mapping or use `:OstrogaJump` directly.

```vim
nnoremap <leader>' <cmd>OstrogaJump<cr>
```

- Press a *lower case* letter to choose a mark to jump to.

## Fork this

If you want to jump to local marks or change the popup border,
fork this repository.
It's less than 100 lines of code.

## Suggested vimrc changes

The following is *not* necessary,
but recommended to make all of this fit together.
It solves a problem of making global marks per-project.

```vim
" Search upwards for a manually created .viminfo file or use a default
let &viminfofile=findfile('.viminfo','.;') ?? $HOME . '/.vim/viminfo'
```

*Note* that this will lead to Vim "forgetting" some things you might be
accustomed to it remembering when you switch from project to project.
Like the content of registers.
