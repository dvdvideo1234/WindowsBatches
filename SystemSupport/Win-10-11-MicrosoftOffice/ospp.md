### Office 2016 Client Software License Management Tool


**Usage**
  `cscript ospp.vbs /Option:Value ComputerName User Password`
 * ComputerName: Name of remote computer. If a computer name is not passed local computer is used. |
 * User: Account with required privilege on remote computer.
 * Password: Password for the account. If a User account and password are not passed current credentials are used. |
 * Value: Required for outlined options.

| Global /Options | Description |
|:---|:---|
| /act | Activate installed Office product keys. |
| /inpkey:value | Install a product key (replaces existing key) with user-provided product key.** Value\*\* parameter applies. |
| /unpkey:value | Uninstall an installed product key with user-provided partial product key (as displayed by the /dstatus option). **Value\*\* parameter applies. |
| /inslic:value | Install a license with user-provided path to the .xrm-ms license.** Value\*\* parameter applies. |
| /dstatus | Display license information for installed product keys. |
| /dstatusall | Display license information for installed licenses. |
| /dhistoryacterr | Display MAK/Retail activation failure history. |
| /dinstid | Display installation ID for offline activation. |
| /actcid:value | Activate product with user-provided confirmation ID.** Value\*\* parameter applies. |
| /rearm | Reset the licensing status for all installed Office product keys. |
| /rearm:value | Reset the licensing status for an Office license with user provided SKUID value (as displayed by the /dstatus opton). **Value\*\* parameter applies. |
| /ddescr:value | Display the description for a user-provided error code. **Value\*\* parameter applies. |

| KMS client /Options | Description |
|:---|:---|
| /dhistorykms | Display KMS client activation history. |
| /dcmid | Display KMS client machine ID (CMID). |
| /sethst:value | Set a KMS host name with user-provided host name. **Value\*\* parameter applies. |
| /setprt:value | Set a KMS port with user-provided port number. **Value\*\* parameter applies. |
| /remhst | Remove KMS host name (sets port to default). |
| /cachst:value | Permit or deny KMS host caching. **Value\*\* parameter applies (TRUE or FALSE). |
| /actype:value | Set volume activation type. **Value\*\* parameter applies. (Windows 8 and above support only) Values: 1 (for AD) or 2 (for KMS) or 3 (for Token) or 0 (for all). |
| /skms-domain:value | Set the specific DNS domain in which all KMS SRV records can be found. This setting has no effect if the specific single KMS host is set via /sethst option. **Value\*\* parameter applies. (Windows 8 and above support only) Value:FQDN |
| /ckms-domain | Clear the specific DNS domain in which all KMS SRV records can be found. The specific KMS host will be used if set via /sethst option. Otherwise default KMS auto-discovery will be used. (Windows 8 and above support only) |
| Token /Options******** | Description******** |
| /dtokils | Display installed token-based activation issuance licenses. |
| /rtokil:value | Uninstall an installed token-based activation issuance license with user-provided license id (as displayed by the /dtokils option). **Value\*\* parameter applies. |
| /stokflag | Set token-based activation only flag. (Windows 7 support only) |
| /ctokflag | Clear token-based activation only flag. (Windows 7 support only) |
| /dtokcerts | Display token-based activation certificates. |
| /tokact:value1:value2 | Token activate with a user-provided thumbprint (as displayed by the /dtokcerts option) and a user-provided PIN (optional). **Value\*\* parameter applies. |

### Prior to running ospp.vbs ensure that:
Windows firewall allows WMI traffic on remote computer.
You have or pass credentials with required permissions on remote computer.
`Cmd.exe` is elevated (`Right click` > `Run as administrator`).

### Sample Usage:
```
cscript ospp.vbs /act 'Activate Office on local computer.
cscript ospp.vbs /act mypc1 'Activate Office on remote computer mypc1 with current credentials.
cscript ospp.vbs /inpkey:MFKXT-F6DT2-THMRV-KDWH2-TCDTC 'Install an Office product key on local computer.
cscript ospp.vbs /inslic:\\\myserver\\licenses\tail.xrm-ms 'Install license on local computer.
cscript ospp.vbs /inslic:"\\\myserver\\work licenses\\office2016 tail.xrm-ms" mypc1 'Install license on remote computer mypc1\\. Note the path is enclosed in "" since the value contains spaces.
cscript ospp.vbs /ddescr:0xC004F009 'Display the description for error code.
cscript ospp.vbs /actype:1 'Set volume activation type to Active Directory only.
```
### Token only:
```
cscript ospp.vbs /rtokil:4476b20e 'Uninstall an issuance license with license ID.
cscript ospp.vbs /tokact:96DE6755ABE0BC7D398E96C3AA3C7BFE8B565248 'Token activate with thumbprint.
cscript ospp.vbs /tokact:56AE6755AAB0BC7D398E96C3AA3C7BFE8B565256:54344 'Token activate with thumbprint & PIN.
```