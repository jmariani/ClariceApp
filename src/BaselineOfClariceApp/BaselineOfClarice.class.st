Class {
	#name : #BaselineOfClarice,
	#superclass : #Object,
	#category : #BaselineOfClariceApp
}

{ #category : #baselines }
BaselineOfClarice class >> baseline: spec [
	<baseline>
	spec
		baseline: 'TaskIt'
		with: [ spec repository: 'github://pharo-contributions/taskit' ].
	spec
		for: #common
		do: [ "Packages"
			spec
				package: 'Clarice';
				package: 'Clarice-Tests' with: [ spec requires: #('Clarice') ] ]
]

{ #category : #accessing }
BaselineOfClarice class >> projectClass [
	^ MetacelloCypressBaselineProject
]
