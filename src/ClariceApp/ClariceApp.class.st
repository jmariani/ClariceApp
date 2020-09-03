"
Class: I am Clarice, a SoulSeek client made with Pharo.
Responsibility: I am the entry point for the app.
Collaborators: None so far.

How I am going to do it?

1) I am a singleton. I will check if there's an instance of me already loaded. If not, I will create a new instance of me.
2) I will load settings from the Pharo Settings Manager
3) If the settings are OK, connect to the SoulSeek server
4) Once the connection is established, enter in a loop monitoring the socket



Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #ClariceApp,
	#superclass : #Object,
	#classVars : [
		'Default',
		'ListeningPort',
		'Password',
		'ServerName',
		'ServerPort',
		'ServerResponseProcessService',
		'ServerSocket',
		'Username'
	],
	#category : #'ClariceApp-Clarice'
}

{ #category : #settings }
ClariceApp class >> clariceServerSettingsOn: aBuilder [
	<claricesettings>
	(aBuilder group: #serverSettings)
		label: 'Server settings' translated;
		"parent: #clariceSettings;"
			with: [ (aBuilder setting: #serverName)
"				target: ClariceApp;"
				default: 'vps.slsknet.org';
				label: 'SoulSeek server name' translated;
				description: 'This is the SoulSeek server name. Defaults to vps.slsknet.org'.
			(aBuilder pickOne: #serverPort)
"				target: ClariceApp;"
				default: 2416;
				label: 'SoulSeek server port' translated;
				description: 'This is the SoulSeek server TCP port. Defaults to 2416';
				domainValues:
					#(2242 2271 2300 2329 2358 2387 2416 2445 2474 2503 2532 2561 2590 2619 2648 2677) ]
]

{ #category : #settings }
ClariceApp class >> clariceUserInfoSettingsOn: aBuilder [
	<claricesettings>
	(aBuilder group: #userInfoSettings)
		label: 'User information' translated;
		"parent: #clariceSettings;"
			with: [ (aBuilder setting: #username)
				order: 1;
				default: '';
				label: 'Username' translated;
				description: 'Please enter your SoulSeek account name.'.
			"				target: ClariceApp;"
			(aBuilder setting: #password)
				order: 2;
				default: '';
				label: 'Password' translated;
				description: 'Please enter your SoulSeek account password'.
			"				target: ClariceApp;"
			(aBuilder setting: #listeningPort)
"				target: ClariceApp;"
				order: 3;
				default: 2234;
				label: 'Listening port' translated;
				description: 'Please enter Clarice''s listening port' ]
]

{ #category : #ssl }
ClariceApp class >> connect [
	GrowlMorph
		openWithLabel: 'Clarice'
		contents:
			'Connecting to ' , self serverName , ' using port '
				, self serverPort asString.
	"--- Open the server socket ---"
	self
		serverSocket:
			(SocketStream
				openConnectionToHostNamed: self serverName
				port: self serverPort).

	self connected
		ifFalse: [ GrowlMorph
				openWithLabel: 'Clarice'
				contents:
					'Failed to connect to ' , self serverName , ' using port '
						, self serverPort asString ]
		ifTrue: [ 	"--- set socket as binary ---"
	self serverSocket
		binary;
		autoFlush: true.
		GrowlMorph
				openWithLabel: 'Clarice'
				contents:
					'Connected to ' , self serverName , ' using port '
						, self serverPort asString ]
]

{ #category : #'as yet unclassified' }
ClariceApp class >> connected [ 	^ ServerSocket isConnected
]

{ #category : #accessing }
ClariceApp class >> default [
	^ Default ifNil: [ Default := self new ]
]

{ #category : #accessing }
ClariceApp class >> default: aClariceApp [
	Default := aClariceApp
]

{ #category : #'class initialization' }
ClariceApp class >> initialize [
self serverResponseProcessService: ClariceServerResponseService new
]

{ #category : #'as yet unclassified' }
ClariceApp class >> listeningPort [
	^ ListeningPort
]

{ #category : #'as yet unclassified' }
ClariceApp class >> listeningPort: aNumber [
	ListeningPort := aNumber
]

{ #category : #'private protocol' }
ClariceApp class >> login [
	| buffer hash |
	GrowlMorph
		openWithLabel: 'Clarice'
		contents: 'Logging in as ' , self username , ' with ' , self password.

	"-- Hash field: MD5 hex digest of concatenated username & password ---"
	hash := (MD5 new hashMessage: self username , self password) hex.

	"set up buffer"
	buffer := ByteArray new writeStream.

	"fill buffer"
	buffer
		nextPutAll: (1 asSoulSeekByteArrayOfSize: 4);
		nextPutAll: (self username size asSoulSeekByteArrayOfSize: 4);
		nextPutAll: self username asByteArray;
		nextPutAll: (self password size asSoulSeekByteArrayOfSize: 4);
		nextPutAll: self password asByteArray;
		"<--- Major version of SoulSeek --->"
		nextPutAll: (157 asSoulSeekByteArrayOfSize: 4);
		nextPutAll: (hash size asSoulSeekByteArrayOfSize: 4);
		nextPutAll: hash asByteArray;
		"<--- Minor version of SoulSeek --->"		
		nextPutAll: (100 asSoulSeekByteArrayOfSize: 4).
	self sendMessage: buffer contents
]

{ #category : #'world menu' }
ClariceApp class >> menuCommandOn: aBuilder [
	<worldMenu>
	aBuilder item: #Clarice.
	(aBuilder
		item: 'Settings' translated;
		icon: (self iconNamed: #configuration);
		parent: #Clarice)
		action: [ (SettingBrowser forKeywords: #('claricesettings')) open ]
]

{ #category : #accessing }
ClariceApp class >> password [
	^ Password
]

{ #category : #accessing }
ClariceApp class >> password: aString [
	Password := aString
]

{ #category : #'as yet unclassified' }
ClariceApp class >> sendMessage: aMessageEncoded [
	"I send messages to the SoulSeek server"

	"--- Send the buffer to the server ---"

	self serverSocket
		nextPutAll: (aMessageEncoded size asSoulSeekByteArrayOfSize: 4);
			nextPutAll: aMessageEncoded.
	self serverSocket flush
]

{ #category : #accessing }
ClariceApp class >> serverName [
	^ ServerName
]

{ #category : #accessing }
ClariceApp class >> serverName: aString [
	ServerName := aString
]

{ #category : #'as yet unclassified' }
ClariceApp class >> serverPort [
	^ ServerPort
]

{ #category : #'as yet unclassified' }
ClariceApp class >> serverPort: aNumber [
	ServerPort := aNumber
]

{ #category : #accessing }
ClariceApp class >> serverResponseProcessService [
	^ ServerResponseProcessService
]

{ #category : #accessing }
ClariceApp class >> serverResponseProcessService: anObject [
	ServerResponseProcessService := anObject
]

{ #category : #accessing }
ClariceApp class >> serverSocket [
	^ ServerSocket
]

{ #category : #'as yet unclassified' }
ClariceApp class >> serverSocket: aSocketStream [
	ServerSocket := aSocketStream
]

{ #category : #'system startup' }
ClariceApp class >> startUp [
	WorldState desktopMenuTitle: 'Clarice'.
"	PasteUpMorph shouldShowWorldMenu: false"
]

{ #category : #accessing }
ClariceApp class >> username [
	^ Username
]

{ #category : #accessing }
ClariceApp class >> username: aString [
	Username := aString
]
