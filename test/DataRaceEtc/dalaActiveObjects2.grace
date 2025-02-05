// inspired by fig 2 Active Objects

// ---------------------------
// Immutable Request Object
// ---------------------------
def Request := object is imm {
  var description := ""
  
  // Initialize the request with a description.
  method init(desc) {
    description := desc
  }
  
  // Return an immutable clone of the Request.
  method clone -> Object is imm {
    // Here we create a new object in a local scope
    object is imm {
      var description := self.description
      method getDescription -> String {
        description
      }
      method markAccepted {
        print "Request {description} marked accepted."
      }
    }
  }
  
  method getDescription -> String {
    description
  }
  
  method markAccepted {
    print "Request {description} marked accepted."
  }
}

// ---------------------------
// Isolated Offer Object
// ---------------------------
def Offer := object is iso {
  var details := ""         // Details about the offer
  var provider := none      // The Provider that made the offer
  var trackback := none     // The original Request for traceability
  
  // Initialize the offer with details, provider, and trackback request.
  method init(detailsStr, providerObj, requestObj) {
    details := detailsStr
    provider := providerObj
    trackback := requestObj
  }
  
  // Return the provider; the annotation indicates exclusive access.
  method getProvider -> Object is iso {
    provider
  }
  
  // Return an isolated clone of this offer.
  method clone -> Object is iso {
    // A local isolated copy is produced here.
    object is iso {
      var details := self.details
      var provider := self.provider
      var trackback := self.trackback
      method getProvider -> Object is iso {
        provider
      }
      method getDetails -> String {
        details
      }
      method getTrackback -> Object {
        trackback
      }
    }
  }
}

// ---------------------------
// Active Provider Object
// ---------------------------
def Provider := object is iso {
  method run {
    print "Provider is active."
  }
  
  // Query a request and return an offer (synchronously here for simplicity).
  method query(request) -> Object is iso {
    print "Provider received query for: {request.getDescription}"
    var offer := Offer.clone
    offer.init("Offer details from Provider", self, request)
    offer
  }
  
  // Accept an offer; marks the request as accepted.
  method accept(offer) -> Boolean {
    print "Provider accepting offer with details: {offer.getDetails}"
    offer.getTrackback.markAccepted
    true
  }
}

// ---------------------------
// Active Broker Object
// ---------------------------
def Broker := object is iso {
  method run {
    print "Broker is reactive."
  }
  
  // Process a booking request.
  method book(request) -> Object is iso {
    print "Broker processing request: {request.getDescription}"
    // For simplicity, the broker immediately consults a provider.
    var provider := Provider       // We assume one provider is available.
    // Ask provider for an offer (simulate copying the request).
    var offer := provider.query(request.clone)
    offer
  }
}

// ---------------------------
// Active Client Object
// ---------------------------
def Client := object is iso {
  var broker := none  // Will be initialized with a broker reference.
  
  method init(brokerObj) {
    broker := brokerObj
  }
  
  method run {
    print "Client starting..."
    
    // Formulate a Request (using immutable Request object).
    var request := Request.clone
    request.init("Need service booking")
    
    // --- Asynchronous Call 1 ---
    // Simulate sending a request to the Broker asynchronously
    // (The 'spawn' returns a channel that will eventually deliver the Offer.)
    var offerFuture := spawn { channel ->
      // The broker books the request, returning an Offer.
      var offer := broker.book(request.clone)
      channel.send(offer)
    }
    
    // Simulate doing some work before waiting on the offer...
    print "Client is doing some work..."
    
    // Wait for the offer to be delivered (blocking receive).
    var offer := offerFuture.receive
    
    print "Client received offer from broker."
    
    // --- Asynchronous Call 2 ---
    // The client then sends an acceptance to the Provider, again asynchronously.
    spawn { channel ->
      // Retrieve the provider from the offer.
      var provider := offer.getProvider
      // The provider accepts the offer (copying the offer to avoid aliasing).
      provider.accept(offer.clone)
      channel.send("Acceptance sent")
    }
  }
}

// ---------------------------
// Main Execution
// ---------------------------
def broker := Broker      // Use the Broker object as is.
def client := Client      // Use the Client object as is.
client.init(broker)
client.run
