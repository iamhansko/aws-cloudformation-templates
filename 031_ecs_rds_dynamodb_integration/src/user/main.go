package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
)

type User struct {
	RequestID     string `json:"requestid" binding:"required"`
	UUID          string `json:"uuid" binding:"required"`
	Username      string `json:"username" binding:"required"`
	Email         string `json:"email" binding:"required"`
	StatusMessage string `json:"status_message" binding:"required"`
}

var (
	db *sql.DB
)

func main() {
	mysqlUser := os.Getenv("MYSQL_USER")
	mysqlPass := os.Getenv("MYSQL_PASSWORD")
	mysqlHost := os.Getenv("MYSQL_HOST")
	mysqlPort := os.Getenv("MYSQL_PORT")
	mysqlDB := os.Getenv("MYSQL_DBNAME")

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", mysqlUser, mysqlPass, mysqlHost, mysqlPort, mysqlDB)
	var err error
	db, err = sql.Open("mysql", dsn)
	if err != nil {
		log.Fatalf("DB연결 실패: %v", err)
	}
	db.SetConnMaxLifetime(time.Minute * 3)
	db.SetMaxOpenConns(10)
	db.SetMaxIdleConns(10)

	router := gin.Default()
	router.Use(gin.Logger())
	router.Use(gin.Recovery())

	router.POST("/v1/user", postUser)
	router.GET("/v1/user", getUser)
	router.GET("/healthcheck", healthCheck)

	router.Run(":8080")
}

func postUser(c *gin.Context) {
	var user User
	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	_, err := db.Exec("INSERT INTO user (id, username, email, status_message) VALUES (?, ?, ?, ?)",
		user.UUID, user.Username, user.Email, user.StatusMessage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"status": "created"})
}

func getUser(c *gin.Context) {
	email := c.Query("email")
	requestid := c.Query("requestid")
	uuid := c.Query("uuid")

	if email == "" || requestid == "" || uuid == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Missing query parameters"})
		return
	}

	var id, username, statusMessage string
	err := db.QueryRow("SELECT id, username, status_message FROM user WHERE email = ?", email).Scan(&id, &username, &statusMessage)
	if err != nil {
		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"id":             id,
		"username":       username,
		"email":          email,
		"status_message": statusMessage,
	})
}

func healthCheck(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"status": "ok"})
}
