Extension { #name : #SocketStream }

{ #category : #'*ClariceApp' }
SocketStream >> loginAs: anUser using: aPassword [
	| buffer hash |
	self socket
		ifNil:
			[ ClariceHelper popUp: 'Server Socket not connected. Unable to login.' ]
		ifNotNil: [ self isConnected
				ifFalse:
					[ ClariceHelper popUp: 'Server Socket not connected. Unable to login.' ]
				ifTrue: [ ClariceHelper
						popUp: 'Logging in as ' , anUser , ' using ' , aPassword ].
			"-- Hash field: MD5 hex digest of concatenated username & password ---"
			hash := (MD5 new hashMessage: anUser , aPassword) hex.
			"set up buffer"
			buffer := ByteArray new writeStream .
			"fill buffer"
			buffer
				nextPutAll: (1 asSoulSeekByteArrayOfSize: 4);
				nextPutAll: (anUser  size asSoulSeekByteArrayOfSize: 4);
				nextPutAll: anUser  asByteArray;
				nextPutAll: (aPassword  size asSoulSeekByteArrayOfSize: 4);
				nextPutAll: aPassword asByteArray;
				"<--- Major version of SoulSeek --->"
					nextPutAll: (157 asSoulSeekByteArrayOfSize: 4);
				nextPutAll: (hash size asSoulSeekByteArrayOfSize: 4);
				nextPutAll: hash asByteArray;
				"<--- Minor version of SoulSeek --->"
					nextPutAll: (100 asSoulSeekByteArrayOfSize: 4).
			self sendMessageToSoulSeekServer:  buffer contents			]
]

{ #category : #'*ClariceApp' }
SocketStream >> processSoulSeekServerResponse [
	| chunk response responseCode responseSize |
	"<--- check if there's data available --->"
	self isDataAvailable
		ifTrue: [ chunk := self next: 4.
			responseSize := chunk reverse asInteger - 4.
			chunk := self next: 4.
			responseCode := chunk reverse asInteger.
			response := self next: responseSize.
			Transcript
				trace:
					'Message code ' , responseCode asString , ' received. Size: '
						, responseSize asString,' Response: ',response;
				cr.
			ClariceHelper
				popUp:
					'Received message code: ' , responseCode asString , ' - Size: '
						, responseSize asString ]
]

{ #category : #'*ClariceApp' }
SocketStream >> sendMessageToSoulSeekServer: aMessageEncoded [
	"I send messages to the SoulSeek server"

	"--- Send the buffer to the server ---"

	self 
		nextPutAll: (aMessageEncoded size asSoulSeekByteArrayOfSize: 4);
		nextPutAll: aMessageEncoded.
	self flush
]

{ #category : #'*ClariceApp' }
SocketStream >> setSoulSeekClientListeningPort: aPort [
	| buffer |
	"set up buffer"
	buffer := ByteArray new writeStream.

	"fill buffer"
	buffer
		nextPutAll: (2 asSoulSeekByteArrayOfSize: 4);
		nextPutAll: (aPort asSoulSeekByteArrayOfSize: 4).
	^ buffer contents
]
