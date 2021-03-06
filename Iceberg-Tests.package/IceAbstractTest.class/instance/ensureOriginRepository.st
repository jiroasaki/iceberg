running
ensureOriginRepository
	| originDirectory |
	originDirectory := FileLocator temp asFileReference / 'pharo' / 'iceberg' / projectName.
	originDirectory exists ifFalse: [ 
		originDirectory parent ensureCreateDirectory.
		IceGitCommand 
			in: originDirectory parent  
			execute: { 
				'clone'. 
				'--bare'. 
				'https://github.com/npasserini/{1}.git' format: { projectName }. 
				projectName }. 
		
		(OSEnvironment default at: 'CI' ifAbsent: []) = 'true' ifTrue: [
			Transcript show: 'Setting user information for CI'; cr. 
			IceGitCommand in: originDirectory execute: { 'config'. '--global'. 'user.email'. '"npasserini@gmail.com"' }.
			IceGitCommand in: originDirectory execute: { 'config'. '--global'. 'user.name'.  '"Iceberg CI"' }
		]				
	].

	^ 'file://', originDirectory fullName.
