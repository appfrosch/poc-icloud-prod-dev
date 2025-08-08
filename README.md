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
  
## Todo-List
- [X] create sep. app icons for debug and release

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
