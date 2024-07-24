package main

import (
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"

	"github.com/aws/aws-lambda-go/lambda"
	app "github.com/ncostamagna/go-sls-lab/internal"
)

func main() {

	errs := make(chan error)

	go func() {
		c := make(chan os.Signal, 1)
		signal.Notify(c, syscall.SIGINT, syscall.SIGTERM)
		errs <- fmt.Errorf("%s", <-c)
	}()

	handler := app.NewGetHandler(app.MakeEndpoints())
	lambda.StartHandler(handler)

	log.Println(<-errs)
}
