# docker_archlinux_user

This creates a user based on `archlinux:base-devel` and, a docker image that generates an XDG Base Directory structure in the user directory.

## Useage

### Add packages

Read `config/pkglist.txt` and add packages when building the image.
By default, it is just `xdg-user-dirs`, but you can add more packages by adding the package name as follows.

```config/pkglist.txt
  xdg-user-dirs
+ zsh
+ git
+ vim
```

### Change make user configs

If you add `zsh` etc. as above and set the user shell to zsh, you can change it by specifying the following arguments when building.

```zsh:terminal
docker image build -t archlinux_user --build-args=SHELL_NAME=zsh .
```

Also, the default username is `user`, but this can also be changed by specifying `--build-args`.
If you check `Dockerfile#L23-35` for details, that area is the setting related to user creation.
