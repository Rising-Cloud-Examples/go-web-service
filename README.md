# go-web-service
This guide will walk you through the simple steps needed to build and run a Go app on Rising Cloud.  You can clone all the files needed for this example from our GitHub repository at: [https://github.com/Rising-Cloud-Examples/go-task](https://github.com/Rising-Cloud-Examples/go-task)

# 1. Install the Rising Cloud Command Line Interface (CLI)
In order to run the Rising Cloud commands in this guide, you will need to [install](https://risingcloud.com/docs/install) the Rising Cloud Command Line Interface. This program provides you with the utilities to setup your Rising Cloud Task or Web Service, upload your application to Rising Cloud, setup authentication, and more.

# 2. Login to Rising Cloud using the CLI
Using a command line console (called terminal on Mac OS X and command prompt on Windows) run the Rising Cloud login command. The interface will request your Rising Cloud email address and password.

```risingcloud login```

# 3. Initialize Your Web Service

Whether this is an existing project or a new project, you must initialize it as a Rising Cloud Web Service.

Create or navigate to your project directory, and be sure to remove any files which will not be a part of your Rising Cloud App.  Your Web Service will require a unique task name.

Your unique task name must be at least 12 characters long and consist of only alphanumeric characters and hyphens (-). This task name is unique to all tasks on Rising Cloud. A unique dispatch URL will be provided to you with this name, and this URL must be used to send requests to your web service.  If a task name is not available, the CLI will return with an error so you can try again.

In your project directory, run the following command replacing $TASK with your unique task name.

```risingcloud init -w $TASK```

The -w flag lets the Rising Cloud CLI know that you would like to initialize a Rising Cloud Web Service and not a Rising Cloud Task.

This creates a risingcloud.yaml file in your project directory. This file can be used to configure the build script.

# 4. Setup Your Project

**Configure your risingcloud.yaml**

Open the previously created risingcloud.yaml file and change the Port line to the following:

```port: 8080```

**Create your Program**
This server will create a /hello endpoint which will respond to http GET requests with Hello World!  

To get started, make a new file called **main.go**, and paste into it the following:

```
package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, World!")
	})
	fmt.Printf("Server running (port=8080)\n")
	if err := http.ListenAndServe("[]:8080", nil); err != nil {
		log.Fatal(err)
	}
}

```

Make another new file called **go.mod**, and paste into it the following:

```
module hellogohttp

go 1.18

```

**Setup the Dockerfile**

Create a new file called **Dockerfile** and in it, paste the following:

```
FROM golang:1.18-buster AS builder
WORKDIR /app
COPY go.* ./
COPY *.go ./
RUN go build -o /hello_go_http

FROM gcr.io/distroless/base-debian11

WORKDIR /

COPY --from=builder /hello_go_http /hello_go_http

ENTRYPOINT ["/hello_go_http"]
```

# 5. Build and Deploy Your Rising Cloud Web Service

Use the push command to push your updated risingcloud.yaml to your Task on Rising Cloud.

```risingcloud push```

Use the build command to zip, upload, and build your app on Rising Cloud.

```risingcloud build```

Use the deploy command to deploy your app as soon as the build is complete.  Change $TASK to your unique task name.

```risingcloud deploy $TASK```

Alternatively, you could also use a combination to push, build and deploy all at once.

```risingcloud build -r -d```

Rising Cloud will now build out the infrastructure necessary to run and scale your application including networking, load balancing and DNS.  Allow DNS a few minutes to propogate and then your app will be ready and available to use!

# 6. Send a request to your new App!

The Web Service URL for all new apps needs a few minutes to propogate across the internet.  Once your app is built and DNS has had a chance to propogate, open up your Web Browser and type:
```
https://<your_task_url>.risingcloud.app/hello
```
Congratulations, you’ve successfully created and used Go on Rising Cloud!
