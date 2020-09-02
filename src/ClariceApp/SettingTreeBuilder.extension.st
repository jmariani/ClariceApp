Extension { #name : #SettingTreeBuilder }

{ #category : #'*ClariceApp' }
SettingTreeBuilder >> claricesettings [
	"Process a <claricesettings> pragma"

	<settingPragmaProcessor>
	currentPragma methodClass instanceSide
		perform: currentPragma methodSelector
		with: self
]
