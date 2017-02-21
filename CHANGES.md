# Release Change Log

Update this file when creating new releases, with most recent releases first.

## Version 1.5.1

 - Update `pip` dependencies and `apt` packages to reflect latest requirements
 - Change condition in which to use `-r requirements.txt` or `setup.py`
 - Add `--master` to default `uwsgi` run behavior

## Version 1.5.0

 - Removed `pycrypto` dependency thanks to Credstash changes upstream


## Version 0.7.0

 -  Change `uwsgi` invocation to work without shared/master socket


## Version 0.6.0

 -  Fix `entrypoint.sh` to work properly for microcosm services running the dev server
