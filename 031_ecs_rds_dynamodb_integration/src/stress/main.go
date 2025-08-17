package main

import (
	"crypto/rand"
	"encoding/hex"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

type StressRequest struct {
	RequestID string `json:"requestid" binding:"required"`
	UUID      string `json:"uuid" binding:"required"`
	Length    int    `json:"length" binding:"required"`
}

func main() {
	router := gin.Default()
	router.Use(gin.Logger())
	router.Use(gin.Recovery())

	router.POST("/v1/stress", postStress)
	router.GET("/healthcheck", healthCheck)

	router.NoRoute(noRouteHandler)

	if err := router.Run(":8080"); err != nil {
		log.Fatalf("서버 시작 실패: %v", err)
	}
}

func postStress(c *gin.Context) {
	var req StressRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if req.Length <= 0 || req.Length > 10240 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "length must be between 1 and 10240"})
		return
	}

	byteLen := (req.Length + 1) / 2

	buf := make([]byte, byteLen)
	_, err := rand.Read(buf)
	if err != nil {
		log.Printf("랜덤 생성 실패: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal Server Error"})
		return
	}
	randomStr := hex.EncodeToString(buf)
	if len(randomStr) > req.Length {
		randomStr = randomStr[:req.Length]
	}

	c.JSON(http.StatusCreated, gin.H{
		"requestid": req.RequestID,
		"uuid":      req.UUID,
		"length":    req.Length,
		"data":      randomStr,
	})
}

func healthCheck(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"status": "ok"})
}

func noRouteHandler(c *gin.Context) {
	path := c.Request.URL.Path
	if len(path) >= 4 && path[:4] == "/v1/" {
		c.JSON(http.StatusForbidden, gin.H{"error": "forbidden"})
	} else {
		c.JSON(http.StatusNotFound, gin.H{"error": "not found"})
	}
}
