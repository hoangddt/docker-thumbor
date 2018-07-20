A fork form [APSL/docker-thumbor](https://github.com/APSL/docker-thumbor). 
Added thumbor 6.5.1

### Build image

```
$ docker build -t hoangddt/thumbor:6.5.1 .
```

### Run with docker-compose

```
version: '3'

services:
  redis:
    image: redis
    ports:
    - 6379:6379

  thumbor-remotecv:
    image: apsl/remotecv:6.4.2
    links:
    - redis:redis
    environment:
      REDIS_HOST: redis
      REDIS_PORT: 6379
      REDIS_DATABASE: '11'
      REMOTECV_LOADER: remotecv_aws.loader

  thumbor-server:
    image: hoangddt/thumbor:6.5.1
    links:
    - redis:redis
    ports:
    - 8887:8001
    environment:
      LOG_LEVEL: WARNING
      ALLOW_UNSAFE_URL: 'True'
      SECURITY_KEY: <....>
      DETECTORS: "['thumbor.detectors.queued_detector.queued_complete_detector',]"
      ENGINE: 'thumbor.engines.pil'
      RESULT_STORAGE: thumbor.result_storages.file_storage
      STORAGE: thumbor.storages.mixed_storage
      MIXED_STORAGE_DETECTOR_STORAGE: tc_redis.storages.redis_storage
      MIXED_STORAGE_FILE_STORAGE: thumbor.storages.file_storage
      REDIS_STORAGE_SERVER_DB: '10'
      REDIS_QUEUE_SERVER_DB: '11'
      THUMBOR_PORT: 8001
```