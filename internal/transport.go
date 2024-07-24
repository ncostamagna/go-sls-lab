package interaction

import (
	"context"
	"log"

	"github.com/go-kit/kit/transport/awslambda"
	"github.com/ncostamagna/go-http-utils/response"

	"encoding/json"

	"github.com/aws/aws-lambda-go/events"
)

func NewGetHandler(endpoints Endpoints) *awslambda.Handler {
	return awslambda.NewHandler(
		endpoints.Get,
		decodeGetHandler,
		EncodeResponse,
		HandlerErrorEncoder(),
		awslambda.HandlerFinalizer(HandlerFinalizer()))
}

func decodeGetHandler(_ context.Context, payload []byte) (interface{}, error) {
	return nil, nil
}


func EncodeResponse(_ context.Context, resp interface{}) ([]byte, error) {
	var res response.Response
	switch resp.(type) {
	case response.Response:
		res = resp.(response.Response)
	default:
		res = response.InternalServerError("unknown response type")
	}
	return APIGatewayProxyResponse(res)
}

// HandlerErrorEncoder
func HandlerErrorEncoder() awslambda.HandlerOption {
	return awslambda.HandlerErrorEncoder(
		awslambda.ErrorEncoder(errorEncoder()),
	)
}

// HandlerFinalizer -
func HandlerFinalizer() func(context.Context, []byte, error) {
	return func(ctx context.Context, resp []byte, err error) {
		if err != nil {
			log.Println("err", err)
		}
	}
}

func errorEncoder() func(context.Context, error) ([]byte, error) {
	return func(_ context.Context, err error) ([]byte, error) {
		res := buildResponse(err)
		return APIGatewayProxyResponse(res)
	}
}

// buildResponse builds an error response from an error.
func buildResponse(err error) response.Response {
	switch err.(type) {
	case response.Response:
		return err.(response.Response)
	}

	return response.InternalServerError("")
}

// APIGatewayProxyResponse
func APIGatewayProxyResponse(res response.Response) ([]byte, error) {
	bytes, err := json.Marshal(res)
	if err != nil {
		return nil, err
	}
	awsResponse := events.APIGatewayProxyResponse{
		Body:       string(bytes),
		StatusCode: res.StatusCode(),
	}
	return json.Marshal(awsResponse)
}
