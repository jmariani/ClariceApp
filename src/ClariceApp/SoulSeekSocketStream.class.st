"
I am a subclass of the SocketStream class.

I implement an instance of TaskScheduler to monitor the receiving of data from the endpoint.


"
Class {
	#name : #SoulSeekSocketStream,
	#superclass : #SocketStream,
	#instVars : [
		'scheduler'
	],
	#category : #ClariceApp
}

{ #category : #initialization }
SoulSeekSocketStream >> initialize [
	super initialize.
	socket := Socket newTCP.
	binary.
	scheduler := TaskScheduler new
]

{ #category : #'as yet unclassified' }
SoulSeekSocketStream >> loginAs: anUser using: aPassword [
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
			buffer := ByteArray new writeStream.
			"fill buffer"
			buffer
				nextPutAll: (1 asSoulSeekByteArrayOfSize: 4);
				nextPutAll: (anUser size asSoulSeekByteArrayOfSize: 4);
				nextPutAll: anUser asByteArray;
				nextPutAll: (aPassword size asSoulSeekByteArrayOfSize: 4);
				nextPutAll: aPassword asByteArray;
				"<--- Major version of SoulSeek --->"
					nextPutAll: (157 asSoulSeekByteArrayOfSize: 4);
				nextPutAll: (hash size asSoulSeekByteArrayOfSize: 4);
				nextPutAll: hash asByteArray;
				"<--- Minor version of SoulSeek --->"
					nextPutAll: (100 asSoulSeekByteArrayOfSize: 4).
			 self sendMessageToSoulSeekServer: buffer contents ]
]

{ #category : #'as yet unclassified' }
SoulSeekSocketStream >> sendMessageToSoulSeekServer: aMessageEncoded [
	"I send messages to the SoulSeek server"

	"--- Send the buffer to the server ---"
	self
		nextPutAll: (aMessageEncoded size asSoulSeekByteArrayOfSize: 4);
		nextPutAll: aMessageEncoded.
		self flush
]

{ #category : #initialization }
SoulSeekSocketStream >> setSoulSeekClientListeningPort: aPort [
	| buffer |
	"set up buffer"
	buffer := ByteArray new writeStream.

	"fill buffer"
	buffer
		nextPutAll: (2 asSoulSeekByteArrayOfSize: 4);
		nextPutAll: (aPort asSoulSeekByteArrayOfSize: 4).
				self sendMessageToSoulSeekServer: buffer contents
]

{ #category : #'as yet unclassified' }
SoulSeekSocketStream >> waitForConnectionFor: seconds onObfuscatedPort: aPort [
	socket port: aPort waitForConnectionFor: seconds
]
