[![](https://images.microbadger.com/badges/image/weboaks/duplicity-backup.sh.svg)](https://microbadger.com/images/weboaks/duplicity-backup.sh "Get your own image badge on microbadger.com")

Dockerized [*duplicity-backup.sh*](https://github.com/zertrin/duplicity-backup.sh) backup tool.

## Usage

```
docker run --rm --user $UID \
  -v duplicity-cache:/home/duplicity/.cache/duplicity \
  -v duplicity-gnupg:/home/duplicity/.gnupg \
```
Mount folder to backup
```
  -v /home/backup/:/data:ro \
```
Set destination, credentials and other options
```
  -e DEST="ftp://user@other.host[:port]/some_dir"
  -e FTP_PASSWORD="password"
```
Pass options to make a backup or restore a backup
```
  weboaks/duplicity-backup.sh --full
```

Other options available:
```
-b, --backup               runs an incremental backup
-f, --full                 forces a full backup
-v, --verify               verifies the backup
-e, --cleanup              cleanup the backup (eg. broken sessions), by default using
                           duplicity --force flag, use --dry-run to actually log what
                           will be cleaned up without removing (see man duplicity
                           > ACTIONS > cleanup for details)
-l, --list-current-files   lists the files currently backed up in the archive
-s, --collection-status    show all the backup sets in the archive

    --restore [PATH]       restores the entire backup to [path]
    --restore-file [FILE_TO_RESTORE] [DESTINATION]
                           restore a specific file
    --restore-dir [DIR_TO_RESTORE] [DESTINATION]
                           restore a specific directory

-t, --time TIME            specify the time from which to restore or list files
                           (see duplicity man page for the format)

--backup-script            automatically backup the script and secret key(s) to
                           the current working directory

-n, --dry-run              perform a trial run with no changes made
-d, --debug                echo duplicity commands to logfile

-V, --version              print version information about this script and duplicity
```

## Configuration

All env variables useful to configure the script can be found in https://github.com/zertrin/duplicity-backup.sh/blob/dev/duplicity-backup.conf.example

### FTP / FTPS /FTPES / RSYNC / SCP / SSH / SFTP / IMAP / WEBDAV / FISH / MEGA
```
-e DEST="ftp://user@other.host[:port]/some_dir"
-e DEST="ftps://user@other.host[:port]/some_dir"
-e DEST="ftpes://user@other.host[:port]/some_dir"
-e DEST="rsync://user@other.host[:port]//absolute_path"
-e DEST="scp://user@other.host[:port]/[/]some_dir"
-e DEST="ssh://user@other.host[:port]/[/]some_dir"
-e DEST="sftp://user@other.host[:port]/[/]some_dir
-e DEST="imap[s]://user@other.host[/from_address_prefix]"
-e DEST="webdav[s]://user@other.host[:port]/some_dir"
-e DEST="fish://user@other.host[:port]/[relative|/absolute]_path"
-e DEST="mega://user@mega.co.nz/some_dir"

```
And specify your password :
```
-e FTP_PASSWORD="password"
```

### S3
```
-e DEST="s3+http://foobar-backup-bucket/backup-folder/"
-e AWS_ACCESS_KEY_ID="foobar_aws_key_id"
-e AWS_SECRET_ACCESS_KEY="foobar_aws_access_key"
```
To use *minio* or another s3 compatible storage
```
-e DEST="s3://host/backup-bucket/backup-folder/"
```

### Google Cloud storage
```
-e DEST=gs://bucket[/prefix]
-e GS_ACCESS_KEY_ID="foobar_gcs_key_id"
-e GS_SECRET_ACCESS_KEY="foobar_gcs_secret_id"
```
### Openstack Object Storage (SWIFT)
```
-e DEST="swift://foobar_swift_container/some_dir"
-e SWIFT_USERNAME="foobar_swift_tenant:foobar_swift_username"
-e SWIFT_PASSWORD="foobar_swift_password"
-e SWIFT_AUTHURL="foobar_swift_authurl"
-e SWIFT_AUTHVERSION="2"
```
