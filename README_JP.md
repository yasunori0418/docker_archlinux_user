# docker_archlinux_user

これは、`archlinux:base-devel`をベースにユーザーを作成して、ユーザーディレクトリにXDG Base Directoryの構造を生成するdockerイメージです。

## Useage

### Add packages

イメージをビルドする際に、`config/pkglist.txt`を読み込んでパッケージを追加します。
デフォルトでは`xdg-user-dirs`だけになっていますが、以下のようにパッケージ名を追加すれば、更にパッケージを追加することが可能です。

```config/pkglist.txt
  xdg-user-dirs
+ zsh
+ git
+ vim
```

### Change make user configs

上記のように`zsh`などを追加して、ユーザーシェルをzshにした場合は、ビルド時に以下のように引数を指定すれば変更できます。

```zsh:terminal
docker image build -t archlinux_user --build-args=SHELL_NAME=zsh .
```

また、デフォルトのユーザー名は`user`になっていますが、こちらも`--build-args`で指定することで変更が可能です。
詳しくは`Dockerfile#L23-35`を確認すると、その辺りがユーザー作成に関する設定です。
