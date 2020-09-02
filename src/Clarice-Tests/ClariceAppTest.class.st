"
A ClariceAppTest is a test class for testing the behavior of ClariceApp
"
Class {
	#name : #ClariceAppTest,
	#superclass : #TestCase,
	#category : #'Clarice-Tests'
}

{ #category : #tests }
ClariceAppTest >> testConnectingClarice [
	"A test that will check if Clarice connects to SoulSeek is done properly"

	| tmp |
	tmp := ClariceApp new connect.
	self deny: tmp equals: nil
]

{ #category : #tests }
ClariceAppTest >> testCreatingClarice [
	"A test that will check if the creation of an object Clarice is done properly"

	| tmp |
	tmp := ClariceApp new.
	self deny: tmp equals: nil
]

{ #category : #tests }
ClariceAppTest >> testStartingClarice [
	"A test that will check if starting Clarice is done properly"

	| tmp |
	tmp := ClariceApp new start.
	self deny: tmp equals: nil
]

{ #category : #tests }
ClariceAppTest >> testStoppingClarice [
	"A test that will check if the stopping Clarice is done properly"

	| tmp |
	tmp := ClariceApp new stop.
	self deny: tmp equals: nil
]
