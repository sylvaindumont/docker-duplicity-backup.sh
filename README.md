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
  -v /path/to/backup/:/data \
```
Set destination, credentials and other options
```
  -e DEST="ftp://user@other.host[:port]/some_dir"
  -e FTP_PASSWORD="password"
```
Set backup passphrase
```
 -e PASSPHRASE="pass"
```
Set retention
```
-e CLEAN_UP_TYPE="remove-all-but-n-full"
-e CLEAN_UP_VARIABLE="4"
```

Pass options to make a backup
```
  weboaks/duplicity-backup.sh --backup
```
or restore a backup
```
  -it weboaks/duplicity-backup.sh --restore /data
```

### options
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
all env variables supported by duplicity-backup.sh are listed in [duplicity-backup.conf.example](https://github.com/zertrin/duplicity-backup.sh/blob/dev/duplicity-backup.conf.example)

duplicity-backup.sh is based on duplicity, you can pass any argument to duplicity via
```
-e STATIC_OPTIONS=" --s3-use-new-style"
```

### GPG

```
-v /path/to/keys/:/home/duplicity/keys/
-e GPG_ENC_KEY="/home/duplicity/keys/gpgenc.key"
-e GPG_SIGN_KEY="/home/duplicity/keys/gpgsign.key"
-e GPG_OPTIONS="--no-show-photos"
```

### Data retention

You can remove older than a specific time period:
```
-e CLEAN_UP_TYPE="remove-older-than"
-e CLEAN_UP_VARIABLE="31D"
```
Or, If you would rather keep a certain (n) number of full backups (rather than removing the files based on their age), you can use what I use:
```
-e CLEAN_UP_TYPE="remove-all-but-n-full"
-e CLEAN_UP_VARIABLE="4"
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
-e DEST="mega://user@mega.nz/some_dir"

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
To specify storage class options
```
-e STORAGECLASS="--s3-use-ia"
-e STORAGECLASS="--s3-use-rss"
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
