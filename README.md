
# dyalog/dyalog Container

This container provides access to a Dyalog APL interpreter, with support for interactive debugging via RIDE or a web browser. The container is built using a Dockerfile and startup script which can be found in the [Dyalog/DyalogDocker](https://github.com/Dyalog/DyalogDocker) GitHub repository.

## Interactive APL Sessions

Dyalog's Remote IDE (RIDE) is recommended for interactive use and debugging of the container. You can either download RIDE from [GitHub](https://github.com/Dyalog/ride) and install it locally, or you can configure the interpreter to serve RIDE up as a web application and connect to it using a web browser. Either option requires opening a port and set the [RIDE_INIT]([http://help.dyalog.com/latest/Content/UserGuide/Installation%20and%20Configuration/Configuration%20Parameters/RIDE_Init.htm) environment variable:

To connect from a local RIDE, use the `serve` keyword in `RIDE_INIT`, after which you can connect RIDE and establish an interactive session. In this example, we use port 4502:

`docker run -e RIDE_INIT=serve:*:4502 -p 4502:4502 dyalog/dyalog`

To use a web browser, use the `http` keyword, after which you can connect a browser, in this example to [http://localhost:8888](http://localhost:8888/).

`docker run -e RIDE_INIT=http:*:8888 -p 8888:8888 dyalog/dyalog`

It is also possible to start an interactive session without RIDE simply by starting the container with the `--interactive` and `--tty` switches (or `-it` for short).

`docker run -it dyalog/dyalog`

If you do not set `RIDE_INIT` or enable `-it`, the container will terminate as soon as the interpreter requires session input.

If you map directories into the container using the `-v` switch, your APL session will be able to load source code and data from these directories. The next sections describes how you can configure the container to run code that is mapped into it.

## Starting Your Application

If you set one of the environment variables `LOAD`, `CONFIGFILE` or `DYAPP` in the container at startup, the settings will be used by the interpreter when it is launched. For example, if the directory `/home/mkrom/myapp` contains your application, you can mount this directory into the running image as `/myapp` and start your application from the workspace `boot.dws`within the directory as follows:

`docker run -v /home/mkrom/myapp:/myapp -e LOAD=/myapp/boot.dws`

As the application runs, any changes that it makes to the `/myapp` directory will immediately be visible from outside the container. You will need to add the settings for RIDE if you want to be able to interact with the application while it is running (other than by inspecting the contents of mapped directories).

## Automatic Application Startup

When the container starts, it runs the [entrypoint](https://github.com/Dyalog/DyalogDocker/blob/master/entrypoint) script. If none of the environment variables mentioned in the previous section are set, the script looks for a directory called `/app`, and if the directory contains APL code or a configuration file which the script is able to identify, it will be used to automatically launch your application. The script searches for:

1. A single configuration file `.dcfg`. Note that the file must have a setting for the `LX` parameter if it is to start an application.
2. A single source for a function `.aplf`, namespace `.apln` or class `.aplc`.
3. A single Dyalog application file `.dyapp` (note that these are considered deprecated).
4. A single Dyalog workspace `.dws`.

If the mapped folder does not match any of the above constraints, APL is started with a clear workspace.

For example, if you have a directory which contains a single APL function:

```
$ cat /home/mkrom/helloworld/helloworld.aplf
 helloworld
 ⎕←'Hello World!'
```

Then you can start a container which runs the function my mapping the folder into the container as `/app`:

```
$ docker run -v /home/mkrom/helloworld:/app dyalog/dyalog
 _______     __      _      ____   _____
|  __ \ \   / //\   | |    / __ \ / ____|
|_|  | \ \_/ //  \  | |   | |  | | |
     | |\   // /\ \ | |   | |  | | |   _
 ____| | | |/ /  \ \| |___| |__| | |__| |
|_____/  |_/_/    \_\______\____/ \_____|

https://www.dyalog.com

found aplf file Launching with LOAD=/app/helloworld.aplf
Dyalog APL/S-64 Version 18.2.45333
Serial number: UNREGISTERED - not for commercial use
+-----------------------------------------------------------------+
| Dyalog is free for non-commercial use but is not free software. |
| A basic licence can be used for experiments and proof of        |
| concept until the point in time that it is of value.            |
| For further information visit                                   |
| https://www.dyalog.com/prices-and-licences.htm                  |
+-----------------------------------------------------------------+
Mon Mar  7 11:03:02 2022
Loaded: #.helloworld from "/app/helloworld.aplf"
Hello World!
```

If you follow the instructions for enabling RIDE that you can find at the start of this document , the container will not terminate after running the loaded code (unless the code itself closes the APL session), but pause and allow debugging. If changes are made to the files in the `/app` directory, they will be reflected in the mapped directory (in this case `/home/mkrom/helloworld`).

## Extending the dyalog/dyalog Container

You can build your own container images based on `dyalog/dyalog` using the statement `FROM dyalog/dyalog` in a dockerfile. This will give you a container which contains the Dyalog APL interpreter as `/opt/mdyalog/18.2/64/unicode/dyalog`. 

Review the [entrypoint](https://github.com/Dyalog/DyalogDocker/blob/master/entrypoint) script for an example of how to launch the interpreter.


## Licence
Dyalog is free for non-commercial use and for limited commercial use, but is not free software. You may create public docker images which include Dyalog APL in addition to your own work, if you observe the following conditions:

- You must include Dyalog's LICENSE file in a prominent location and include instructions which require it's inclusion in any derived works.
- If you do not have a commercial licence with a corresponding [Run Time Licence](https://www.dyalog.com/prices-and-licences.htm#runtimelic), and you make images available for download, the default Run Time Licence will automatically apply. This allows non-commercial use, and limited commercial distribution up to the revenue limit set out in the [Licenses, Terms and Conditions](https://www.dyalog.com/prices-and-licences.htm).