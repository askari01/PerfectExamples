//
//  PerfectHandlers.swift
//  URL Routing
//
//  Created by Kyle Jessup on 2015-12-15.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib

// This is the function which all Perfect Server modules must expose.
// The system will load the module and call this function.
// In here, register any handlers or perform any one-time tasks.
public func PerfectServerModuleInit() {
	
	Routing.Routes[.Get, ["/", "index.html"] ] = indexHandler
	Routing.Routes["/foo/*/baz"] = echoHandler
	Routing.Routes["/foo/bar/baz"] = echoHandler
	Routing.Routes[.Get, "/user/{id}/baz"] = echo2Handler
	Routing.Routes[.Get, "/user/{id}"] = echo2Handler
	Routing.Routes[.Post, "/user/{id}/baz"] = echo3Handler
	
	// Test this one via command line with curl:
	// curl --data "{\"id\":123}" http://0.0.0.0:8181/raw --header "Content-Type:application/json"
	Routing.Routes[.Post, "/raw"] = rawPOSTHandler
	
    // Trailing wildcard matches any path
    Routing.Routes["**"] = echo4Handler
    
	// Check the console to see the logical structure of what was installed.
	print("\(Routing.Routes.description)")
}

func indexHandler(request: WebRequest, _ response: WebResponse) {
	response.appendBody(string: "Index handler: You accessed path \(request.requestURI!)")
	response.requestCompleted()
}

func echoHandler(request: WebRequest, _ response: WebResponse) {
	response.appendBody(string: "Echo handler: You accessed path \(request.requestURI!) with variables \(request.urlVariables)")
	response.requestCompleted()
}

func echo2Handler(request: WebRequest, _ response: WebResponse) {
	response.appendBody(string: "<html><body>Echo 2 handler: You GET accessed path \(request.requestURI!) with variables \(request.urlVariables)<br>")
	response.appendBody(string: "<form method=\"POST\" action=\"/user/\(request.urlVariables["id"] ?? "error")/baz\"><button type=\"submit\">POST</button></form></body></html>")
	response.requestCompleted()
}

func echo3Handler(request: WebRequest, _ response: WebResponse) {
	response.appendBody(string: "<html><body>Echo 3 handler: You POSTED to path \(request.requestURI!) with variables \(request.urlVariables)</body></html>")
	response.requestCompleted()
}

func echo4Handler(request: WebRequest, _ response: WebResponse) {
    response.appendBody(string: "<html><body>Echo 4 (trailing wildcard) handler: You accessed path \(request.requestURI!)</body></html>")
    response.requestCompleted()
}

func rawPOSTHandler(request: WebRequest, _ response: WebResponse) {
	response.appendBody(string: "<html><body>Raw POST handler: You POSTED to path \(request.requestURI!) with content-type \(request.contentType) and POST body \(request.postBodyString)</body></html>")
	response.requestCompleted()
}

