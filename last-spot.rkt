#!/usr/bin/env racket
#lang racket
(require net/url)
(require (planet mordae/redis:1:1))


(define LASTFM "http://ws.audioscrobbler.com/2.0/?method=library.getartists&format=json")
(define APIKEY
  (call-with-input-file "api.key" (lambda (in) (read-line in))))
(define RESULTS-LIMIT "10")
(define LASTFM-ARTISTS
  (string-append LASTFM "&api_key=" APIKEY "&limit=" RESULTS-LIMIT "&user="))

(define RDB (redis-connect)) ;; TODO - host and port from config file


(define (get-user-url user)
  (string->url (string-append LASTFM-ARTISTS user)))

(define (fetch-user-artists user)
  (read-line (get-pure-port (get-user-url user))))

(define (get-user-artists user)
  (let ([cached-artists (bytes->string/utf-8 (redis-query RDB "get" user))])
    (if (string? cached-artists)
        cached-artists
        ; the result was probably #\null , but if it's not a string,
        ; something bad happened so we have to recache it anyway
        (let ([new-artists (fetch-user-artists user)])
          (redis-query RDB "set" user new-artists)
          new-artists))))
            
      
(print (get-user-artists "mapleoin"))
