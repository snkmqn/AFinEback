package logger

import "log"

func Info(format string, args ...any) {
	log.Printf("[INFO] "+format, args...)
}

func Warn(format string, args ...any) {
	log.Printf("[WARN] "+format, args...)
}

func Error(format string, args ...any) {
	log.Printf("[ERROR] "+format, args...)
}
