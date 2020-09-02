Extension { #name : #Integer }

{ #category : #'*ClariceApp' }
Integer >> asSoulSeekByteArrayOfSize: aSize [
	"Answer a ByteArray of aSize with my value, most-significant byte first, padded with zeros"

	| answer digitPos |
	aSize < self bytesCount
		ifTrue: [ self error: 'number too large for byte array' ].
	aSize = 4
		ifTrue: [ answer := {0 . 0 . 0 . 0} asByteArray ]
		ifFalse: [ aSize = 8
				ifTrue: [ answer := {0 . 0 . 0 . 0 . 0 . 0 . 0 . 0} asByteArray ]
				ifFalse: [ self error: 'width must be 4 or 8 bytes' ] ].

	digitPos := 1.
	1 to: aSize - self bytesCount + 1 by: 1 do: [ :pos | 
		answer at: pos put: (self byteAt: digitPos).
		digitPos := digitPos + 1 ].

	^ answer
]
