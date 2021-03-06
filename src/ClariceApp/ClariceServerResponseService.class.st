"
I am a subclass of TKTService. I will process the responses received from the SoulSeek server
"
Class {
	#name : #ClariceServerResponseService,
	#superclass : #TKTService,
	#instVars : [
		'serverSocket'
	],
	#category : #'ClariceApp-Core'
}

{ #category : #accessing }
ClariceServerResponseService >> serverSocket [
	^ serverSocket
]

{ #category : #accessing }
ClariceServerResponseService >> serverSocket: anObject [
	serverSocket := anObject
]

{ #category : #stepping }
ClariceServerResponseService >> setUp [
	super setUp.
	GrowlMorph
		openWithLabel: 'Clarice'
		contents: 'Monitoring of server responses started'.

]

{ #category : #stepping }
ClariceServerResponseService >> tearDown [ 
	super tearDown .
	GrowlMorph
		openWithLabel: 'Clarice'
		contents: 'Monitoring of server responses stopped'
]
