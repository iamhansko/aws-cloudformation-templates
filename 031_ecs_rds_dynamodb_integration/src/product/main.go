package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"strconv"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"github.com/gin-gonic/gin"
)

type Product struct {
	RequestID string  `json:"requestid" binding:"required"`
	UUID      string  `json:"uuid" binding:"required"`
	ID        string  `json:"id" binding:"required"`
	Name      string  `json:"name" binding:"required"`
	Price     float64 `json:"price" binding:"required"`
}

var (
	ddbClient *dynamodb.Client
	tableName string
	indexName string
	ctx       = context.Background()
)

func main() {
	tableName = os.Getenv("TABLE_NAME")
	if tableName == "" {
		log.Fatal("환경변수 TABLE_NAME이 설정되지 않았습니다")
	}
	indexName = os.Getenv("TABLE_INDEX_NAME")

	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		log.Fatalf("AWS config load failed: %v", err)
	}

	ddbClient = dynamodb.NewFromConfig(cfg)

	router := gin.Default()
	router.Use(gin.Logger())
	router.Use(gin.Recovery())

	router.POST("/v1/product", postProduct)
	router.GET("/v1/product", getProduct)
	router.GET("/healthcheck", healthCheck)

	router.Run(":8080")
}

func postProduct(c *gin.Context) {
	var p Product
	if err := c.ShouldBindJSON(&p); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	item := map[string]types.AttributeValue{
		"id":    &types.AttributeValueMemberS{Value: p.ID},
		"name":  &types.AttributeValueMemberS{Value: p.Name},
		"price": &types.AttributeValueMemberN{Value: strconv.FormatFloat(p.Price, 'f', 2, 64)},
	}

	_, err := ddbClient.PutItem(ctx, &dynamodb.PutItemInput{
		TableName: &tableName,
		Item:      item,
	})
	if err != nil {
		log.Printf("DynamoDB PutItem error: %v\n", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal Server Error"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"status": "created"})
}

func getProduct(c *gin.Context) {
	id := c.Query("id")
	requestID := c.Query("requestid")
	uuid := c.Query("uuid")

	if id == "" || requestID == "" || uuid == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Missing query parameters"})
		return
	}

	key := map[string]types.AttributeValue{
		"id": &types.AttributeValueMemberS{Value: id},
	}

	out, err := ddbClient.GetItem(ctx, &dynamodb.GetItemInput{
		TableName: &tableName,
		Key:       key,
	})
	if err != nil {
		log.Printf("DynamoDB GetItem error: %v\n", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal Server Error"})
		return
	}

	if out.Item == nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "product not found"})
		return
	}

	nameAttr, ok := out.Item["name"].(*types.AttributeValueMemberS)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Malformed product data"})
		return
	}
	priceAttr, ok := out.Item["price"].(*types.AttributeValueMemberN)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Malformed product data"})
		return
	}

	price, err := strconv.ParseFloat(priceAttr.Value, 64)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Malformed price data"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"id":    id,
		"name":  nameAttr.Value,
		"price": price,
	})
}

func healthCheck(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"status": "ok"})
}
