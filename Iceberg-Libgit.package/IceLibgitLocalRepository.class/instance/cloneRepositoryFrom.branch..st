actions
cloneRepositoryFrom: aRemote branch: aBranchName
	| url |
	"TODO (issue #81): Cloning with https doesn't require credentials. This is done because of a bug between libgit2/libssh2 which keeps ssh authentication from working. Yet, our current tests do not use this behavior so it is not clear that it works. Moreover, I tested that ssh does not work with clone, but this implementation suggests that it might work for other commands (?). "
	url := aRemote httpsUrl.

	LGitGlobal runSequence: [ 
		| repo cloneOptions |
		repo := LGitRepository on: self location.
		cloneOptions := LGitCloneOptions withCredentialsProvider: (IceCredentialsProvider default).
		
		repo clone: url options: cloneOptions.
		aBranchName ifNotNil: [ 
			repo checkout: aBranchName ].

		(LGitRemote of: repo named: 'origin')
			lookup;
			setUrl: url ]