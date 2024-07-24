package interaction

import (
	"context"

	"log"

	"github.com/go-kit/kit/endpoint"
	"github.com/ncostamagna/go-http-utils/response"
)

type (

	// Endpoints struct
	Endpoints struct {
		Get  endpoint.Endpoint
	}
)

func MakeEndpoints() Endpoints {
	return Endpoints{
		Get:  makeGet(),
	}
}

func makeGet() endpoint.Endpoint {
	return func(ctx context.Context, request interface{}) (interface{}, error) {
		log.Println("Entra")
		return response.OK("Success", nil, nil), nil
	}
}