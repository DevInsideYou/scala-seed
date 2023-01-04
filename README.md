# What is this?
This is an opinionated [Nix](https://nixos.org/) [flake](https://nixos.wiki/wiki/Flakes) for getting started with the [Scala](https://scala-lang.org/) programming language. It creates a development subshell with the following Scala tools on the path:

* [Ammonite](https://ammonite.io/)
* [Coursier](https://get-coursier.io/)
* [GraalVM CE](https://www.graalvm.org/) based on [OpenJDK](https://openjdk.org/) 17
* [Mill](https://com-lihaoyi.github.io/mill/mill/Intro_to_Mill.html)
* [sbt](https://www.scala-sbt.org/)
* [Scala CLI](https://scala-cli.virtuslab.org/)
* [Scalafmt CLI](https://scalameta.org/scalafmt/)

In fact it can create alternative subshells with these instead:
* [GraalVM CE](https://www.graalvm.org/) based on [OpenJDK](https://openjdk.org/) 11
* [OpenJDK](https://openjdk.org/) 8

The first time you use this subshell these tools will be downloaded and cached. Once you exit the subshell they will no longer be on your path. The second run is instantaneous.

# Installation
1. Install the Nix package manager by selecting your OS in the [official guide](https://nixos.org/download.html). Don't forget to reopen the terminal!

1. Enable the flakes feature:

    ```bash
    mkdir -p ~/.config/nix
    echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
    ```
    If the Nix installation is in multi-user mode, don’t forget to restart the `nix-daemon` by running:
    ```bash
    sudo systemctl restart nix-daemon
    ```

# Usage
Use the default subshell (there is **NO** need to clone this repo) by running:
```bash
nix develop github:devinsideyou/scala-seed
```
For [direnv](https://direnv.net/)/[nix-direnv](https://github.com/nix-community/nix-direnv) users put the following into your `.envrc`:
```bash
use flake github:devinsideyou/scala-seed
```
**Pro tip**: I will keep updating this flake so you might want to pin it to a [specific commit](https://github.com/DevInsideYou/scala-seed/commits/main):
```bash
nix develop github:devinsideyou/scala-seed/0c3b8c657b37eae320b073724d74390cf3162edf
```
```bash
use flake github:devinsideyou/scala-seed/0c3b8c657b37eae320b073724d74390cf3162edf
```
Alternative shells can be used as follows:
```bash
nix develop github:devinsideyou/scala-seed#java17 # the same as the default
```
```bash
nix develop github:devinsideyou/scala-seed#java11
```
```bash
nix develop github:devinsideyou/scala-seed#java8
```
Here is how you can see the metadata of the flake:
```bash
nix flake metadata github:devinsideyou/scala-seed
```
And here is how you can see everything the flake has to offer:
```bash
nix flake show github:devinsideyou/scala-seed
```
Here is a useful incantation to pretty print a filtered list of what's on the path:
```bash
echo -e ${buildInputs// /\\n} | cut -d - -f 2- | sort
```
And here is another one that also shows the locations:
```bash
echo -e ${buildInputs// /\\n} | sort -t- -k2,2 -k3,3
```
And here is yet another one that shows **everything** Nix put on the path:
```bash
echo $PATH | sed 's/:/\n/g' | grep /nix/store | sort --unique -t- -k2,2 -k3,3
```
Just like any other subshell this one can be exited by typing `exit` or pressing `Ctrl+D`.

[![Watch on YouTube](resources/thumbnail_youtube.jpg)](https://youtu.be/HnoP7JZn2MQ "Watch a Demo on YouTube!")

# Scala first steps
Now that you have a working dev environment you can create your first Scala project like this:

```bash
cs launch giter8 -- devinsideyou/scala-seed  #Scala 2
```
```bash
cs launch giter8 -- devinsideyou/scala3-seed #Scala 3
```
Now `cd` into your newly created project and launch [sbt](https://www.scala-sbt.org/) by typing `sbt`. The template you just used to create a project will display a couple of useful aliases for you to try. For instance `r` to run the program or `t` to run the tests. Type `exit` or press `Ctrl+D` when you are done to exit `sbt`. Don't forget that you are still inside of the Nix subshell so type `exit` or press `Ctrl+D` again to end up back in your regular shell.

Here is a [Scala Crash Course](https://www.youtube.com/watch?v=-xRfJcwhy7A) and here is a [Functional Programming Crash Course](https://www.youtube.com/watch?v=XXkYBncbz0c).

Ask questions on [discord](http://discord.devinsideyou.com)!

Welcome to Scala!

PS

Most Scala devs either use [Intellij IDEA](https://www.jetbrains.com/help/idea/discover-intellij-idea-for-scala.html) or the editors supported by [Metals](https://scalameta.org/metals/) - a Scala language server.

This flake was tested in WSL 2 on Ubuntu-20.04 LTS, but it should work on Macs as well. I don't have a Mac, but I will set up CI eventually to test on them. Please report issues until then. Thank you!
