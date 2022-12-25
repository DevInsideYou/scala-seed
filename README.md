# What is this?
This is an opinionated [Nix](https://nixos.org/) [flake](https://nixos.wiki/wiki/Flakes) for getting started with the [Scala](https://scala-lang.org/) programming language. It creates a development subshell with the following Scala tools on the path:

* [Ammonite](https://ammonite.io/)
* [Coursier](https://get-coursier.io/)
* [GraalVM CE](https://www.graalvm.org/) based on [OpenJDK](https://openjdk.org/) 17
* [Mill](https://com-lihaoyi.github.io/mill/mill/Intro_to_Mill.html)
* [sbt](https://www.scala-sbt.org/)
* [Scala CLI](https://scala-cli.virtuslab.org/)
* [Scalafmt CLI](https://scalameta.org/scalafmt/)

The first time you use this subshell these tools will be downloaded and cached. Once you exit the subshell they will no longer be on your path. The second run is instantaneous.

# Installation
1. Install the Nix package manager by following the [official guide](https://nixos.org/download.html). Don't forget to reopen the terminal.
1. Enable the flakes feature:

    ```bash
    mkdir -p ~/.config/nix
    echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
    ```
    If the Nix installation is in multi-user mode, don’t forget to restart the `nix-daemon` by running:
    ```bash
    sudo systemctl restart nix-daemon
    ```
1. Use this subshell by running:

    ```bash
    nix develop github:devinsideyou/scala-seed
    ```
    For [direnv](https://direnv.net/)/[nix-direnv](https://github.com/nix-community/nix-direnv) users put the following into your `.envrc`:
    ```bash
    use flake github:devinsideyou/scala-seed
    ```
    Tip: I will keep this flake up-to-date so if you want to use a specific commit you can do this by appending `?rev=FULL_COMMIT_SHA` at the end like so:
    ```bash
    # This particular SHA does not exist. It's just here for demonstration purposes
    nix develop github:devinsideyou/scala-seed?rev=fa06d1eab819aa87b4b9cedefb4b00ac8125335b # native
    use   flake github:devinsideyou/scala-seed?rev=fa06d1eab819aa87b4b9cedefb4b00ac8125335b # direnv
    ```
1. Just like any other subshell it can be exited by typing `exit` or pressing `Ctrl+D`.

# Scala first steps
Now that you have a working dev environment you can create your first Scala project like this:

```bash
cs launch giter8 -- devinsideyou/scala-seed  #Scala 2
cs launch giter8 -- devinsideyou/scala3-seed #Scala 3
```
Now `cd` into your newly created project and launch [sbt](https://www.scala-sbt.org/) by typing `sbt`. The template you just used to create a project will display a couple of useful aliases for you to try. For instance `r` to run the program or `t` to run the tests. Type `exit` or press `Ctrl+D` when you are done to exit `sbt`. Don't forget that you are still inside of the Nix subshell so type `exit` or press `Ctrl+D` again to end up back in your regular shell.

Here is a [Scala Crash Course](https://www.youtube.com/watch?v=-xRfJcwhy7A) and here is a [Functional Programming Crash Course](https://www.youtube.com/watch?v=XXkYBncbz0c).

Ask questions on [discord](http://discord.devinsideyou.com)!

Welcome to Scala!

PS

Most Scala devs either use [Intellij IDEA](https://www.jetbrains.com/help/idea/discover-intellij-idea-for-scala.html) or the editors supported by [Metals](https://scalameta.org/metals/) - a Scala language server.

This flake was tested in WSL2 on Ubuntu-20.04 LTS, but it should work on Macs as well. I don't have a Mac, but I will set up CI eventually to test on them. Please report issues until then. Thank you!
