#!/usr/bin/env racket
#lang racket
(require net/url)

(define LASTFM "http://ws.audioscrobbler.com/2.0/?method=library.getartists&format=json")
(define APIKEY
  (call-with-input-file "api.key" (lambda (in) (read-line in))))
(define RESULTS-LIMIT "10")
(define LASTFM-ARTISTS
  (string-append LASTFM "&api_key=" APIKEY "&limit=" RESULTS-LIMIT "&user="))

(define (get-user-url user)
  (string->url (string-append LASTFM-ARTISTS user)))

(print (read-line (get-pure-port (get-user-url "mapleoin"))))
