Class {
	#name : #ClariceHelper,
	#superclass : #Object,
	#category : #'ClariceApp-Core'
}

{ #category : #'as yet unclassified' }
ClariceHelper class >> popUp: aContent [
	GrowlMorph openWithLabel: 'Clarice' contents: aContent
]
