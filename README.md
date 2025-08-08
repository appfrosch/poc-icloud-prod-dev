# poc-icloud-prod-dev

## Abstract
Little proof-of-concept project to see what's possible with iCloud containers
and separate bundle ids for debug and release.

The goal is to have separate schemes with different values to be able to install
separate versions of the app.

## Deeper description
Both these schemes are supposed to connect with the iCloud container 
`iCloud.ch.appfros.ch.poc-icloud-prod-dev`.

Differences are:

- `debug`
  - BundleId: `poc-icloud-prod-dev-debug`
  - uses the entitlements file `poc-icloud-prod-dev-debug.entitlements`
  - uses a separate AppIcon marked with "debug"
  - uses the `Development` environment of above mentioned iCloud container
- `release`
  - BundleId: `poc-icloud-prod-dev-debug` 
  - uses the entitlements file `poc-icloud-prod-dev-release.entitlements`
  - uses a separate AppIcon other than the debug one
  - uses the `Production` environment of above mentioned iCloud container
  
### ACL on iCloud containers
There is a setting for bundle identifiers in the "Edit your App ID Configuration"
on developers.apple.com  ([Link](https://developer.apple.com/account/resources/identifiers/list)).

How to get there:
1. click on above link to see your list of identifiers
2. search for the bundle id you'd like to check
3. in the identifier's detail page, scroll down to the "iCloud" section" and click the "Edit" button
4. in the "iCloud Container Assignment" detail sheet, make sure that the correct iCloud container is checked 

## Issue and open questions
### "Permission Failure"
Once I have started any of the above mentioned schemes (doesn't matter which),
the *other* will fail to connect to the iCloud container with the following 
error:

```
<CKSyncEngine Shared> failed sending changes for context 
<SendChangesContext reason=scheduled options=<SendChangesOptions scope=all 
group=CKSyncEngine-SendChanges-Automatic groupID=CDAC77957DDB47E8>>: 
<CKError 0x10735c3f0: 
"Permission Failure" (10/2007); 
server message = "Invalid bundle ID for container"; 
op = CBDA290480B8DCFA; 
uuid = 1AB5ECEB-37ED-4DDB-8920-BF48B291938B; 
container ID = "iCloud.ch.appfros.ch.poc-icloud-prod-dev">
```

This is despite the fact that I have checked the "iCloud Container Assignment" 
for both of my bundle identifiers and they are both correctly set.
Which of my settings and / or assumptions are falling short here?

### Usage `com.apple.developer.icloud-container-environment`
Is this the right way to decide which environment is being talked to from 
which scheme when connecting with the iCloud container?

From what I've seen, this seems to be the case …

### Who's problem is this?
So far, I think this issue is not [SharingGRDB](https://github.com/pointfreeco/sharing-grdb/tree/cloudkit) related.
I can't be sure though–unless I try this approach with vanilla `CoreData` …
