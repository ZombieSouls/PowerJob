CREATE SEQUENCE power_job.native;

CREATE TABLE IF NOT EXISTS power_job.app_info
(
    id             BIGINT NOT NULL
        CONSTRAINT app_info_pkey PRIMARY KEY,
    app_name       VARCHAR(255)
        CONSTRAINT uidx01_app_info UNIQUE,
    current_server VARCHAR(255),
    gmt_create     TIMESTAMP,
    gmt_modified   TIMESTAMP,
    PASSWORD       VARCHAR(255)
);

COMMENT ON TABLE power_job.app_info IS '应用信息表';

COMMENT ON COLUMN power_job.app_info.id IS '应用id';

COMMENT ON COLUMN power_job.app_info.app_name IS '应用名称';

COMMENT ON COLUMN power_job.app_info.current_server IS 'Server地址,用于负责调度应用的ActorSystem地址';

COMMENT ON COLUMN power_job.app_info.gmt_create IS '创建时间';

COMMENT ON COLUMN power_job.app_info.gmt_modified IS '更新时间';

COMMENT ON COLUMN power_job.app_info.PASSWORD IS '密码';

CREATE TABLE IF NOT EXISTS power_job.container_info
(
    id               BIGINT NOT NULL
        CONSTRAINT container_info_pkey PRIMARY KEY,
    app_id           BIGINT,
    container_name   VARCHAR(255),
    gmt_create       TIMESTAMP,
    gmt_modified     TIMESTAMP,
    last_deploy_time TIMESTAMP,
    source_info      VARCHAR(255),
    source_type      INTEGER,
    status           INTEGER,
    VERSION          VARCHAR(255)
);

CREATE INDEX IF NOT EXISTS idx01_container_info ON power_job.container_info (app_id);

CREATE TABLE IF NOT EXISTS power_job.instance_info
(
    id                    BIGINT NOT NULL
        CONSTRAINT instance_info_pkey PRIMARY KEY,
    actual_trigger_time   BIGINT,
    app_id                BIGINT,
    expected_trigger_time BIGINT,
    finished_time         BIGINT,
    gmt_create            TIMESTAMP,
    gmt_modified          TIMESTAMP,
    instance_id           BIGINT,
    instance_params       OID,
    job_id                BIGINT,
    job_params            OID,
    last_report_time      BIGINT,
    RESULT                OID,
    running_times         BIGINT,
    status                INTEGER,
    task_tracker_address  VARCHAR(255),
    TYPE                  INTEGER,
    wf_instance_id        BIGINT
);

CREATE INDEX IF NOT EXISTS idx01_instance_info ON power_job.instance_info (job_id, status);

CREATE INDEX IF NOT EXISTS idx02_instance_info ON power_job.instance_info (app_id, status);

CREATE INDEX IF NOT EXISTS idx03_instance_info ON power_job.instance_info (instance_id, status);

CREATE TABLE IF NOT EXISTS power_job.job_info
(
    id                       BIGINT           NOT NULL
        CONSTRAINT job_info_pkey PRIMARY KEY,
    advanced_runtime_config  VARCHAR(255),
    alarm_config             VARCHAR(255),
    app_id                   BIGINT,
    concurrency              INTEGER,
    designated_workers       VARCHAR(255),
    dispatch_strategy        INTEGER,
    dispatch_strategy_config VARCHAR(255),
    execute_type             INTEGER,
    extra                    VARCHAR(255),
    gmt_create               TIMESTAMP,
    gmt_modified             TIMESTAMP,
    instance_retry_num       INTEGER,
    instance_time_limit      BIGINT,
    job_description          VARCHAR(255),
    job_name                 VARCHAR(255),
    job_params               OID,
    lifecycle                VARCHAR(255),
    log_config               VARCHAR(255),
    max_instance_num         INTEGER,
    max_worker_count         INTEGER,
    min_cpu_cores            DOUBLE PRECISION NOT NULL,
    min_disk_space           DOUBLE PRECISION NOT NULL,
    min_memory_space         DOUBLE PRECISION NOT NULL,
    next_trigger_time        BIGINT,
    notify_user_ids          VARCHAR(255),
    processor_info           VARCHAR(255),
    processor_type           INTEGER,
    status                   INTEGER,
    tag                      VARCHAR(255),
    task_retry_num           INTEGER,
    time_expression          VARCHAR(255),
    time_expression_type     INTEGER
);

CREATE INDEX IF NOT EXISTS idx01_job_info ON power_job.job_info (app_id, status, time_expression_type, next_trigger_time);

CREATE TABLE IF NOT EXISTS power_job.oms_lock
(
    id            BIGINT NOT NULL
        CONSTRAINT oms_lock_pkey PRIMARY KEY,
    gmt_create    TIMESTAMP,
    gmt_modified  TIMESTAMP,
    lock_name     VARCHAR(255)
        CONSTRAINT uidx01_oms_lock UNIQUE,
    max_lock_time BIGINT,
    ownerip       VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS power_job.server_info
(
    id           BIGINT NOT NULL
        CONSTRAINT server_info_pkey PRIMARY KEY,
    gmt_create   TIMESTAMP,
    gmt_modified TIMESTAMP,
    ip           VARCHAR(255)
        CONSTRAINT uidx01_server_info UNIQUE
);

CREATE INDEX IF NOT EXISTS idx01_server_info ON power_job.server_info (gmt_modified);

CREATE TABLE IF NOT EXISTS power_job.user_info
(
    id           BIGINT NOT NULL
        CONSTRAINT user_info_pkey PRIMARY KEY,
    email        VARCHAR(255),
    extra        VARCHAR(255),
    gmt_create   TIMESTAMP,
    gmt_modified TIMESTAMP,
    PASSWORD     VARCHAR(255),
    phone        VARCHAR(255),
    username     VARCHAR(255),
    web_hook     VARCHAR(255)
);

CREATE INDEX IF NOT EXISTS uidx01_user_info ON power_job.user_info (username);

CREATE INDEX IF NOT EXISTS uidx02_user_info ON power_job.user_info (email);

CREATE TABLE IF NOT EXISTS power_job.workflow_info
(
    id                   BIGINT NOT NULL
        CONSTRAINT workflow_info_pkey PRIMARY KEY,
    app_id               BIGINT,
    extra                VARCHAR(255),
    gmt_create           TIMESTAMP,
    gmt_modified         TIMESTAMP,
    lifecycle            VARCHAR(255),
    max_wf_instance_num  INTEGER,
    next_trigger_time    BIGINT,
    notify_user_ids      VARCHAR(255),
    pedag                OID,
    status               INTEGER,
    time_expression      VARCHAR(255),
    time_expression_type INTEGER,
    wf_description       VARCHAR(255),
    wf_name              VARCHAR(255)
);

CREATE INDEX IF NOT EXISTS idx01_workflow_info ON power_job.workflow_info (app_id, status, time_expression_type, next_trigger_time);

CREATE TABLE IF NOT EXISTS power_job.workflow_instance_info
(
    id                    BIGINT NOT NULL
        CONSTRAINT workflow_instance_info_pkey PRIMARY KEY,
    actual_trigger_time   BIGINT,
    app_id                BIGINT,
    dag                   OID,
    expected_trigger_time BIGINT,
    finished_time         BIGINT,
    gmt_create            TIMESTAMP,
    gmt_modified          TIMESTAMP,
    parent_wf_instance_id BIGINT,
    RESULT                OID,
    status                INTEGER,
    wf_context            OID,
    wf_init_params        OID,
    wf_instance_id        BIGINT
        CONSTRAINT uidx01_wf_instance UNIQUE,
    workflow_id           BIGINT
);

CREATE INDEX IF NOT EXISTS idx01_wf_instance ON power_job.workflow_instance_info (workflow_id, status, app_id, expected_trigger_time);

CREATE TABLE IF NOT EXISTS power_job.workflow_node_info
(
    id               BIGINT    NOT NULL
        CONSTRAINT workflow_node_info_pkey PRIMARY KEY,
    app_id           BIGINT    NOT NULL,
    ENABLE           BOOLEAN   NOT NULL,
    extra            OID,
    gmt_create       TIMESTAMP NOT NULL,
    gmt_modified     TIMESTAMP NOT NULL,
    job_id           BIGINT,
    node_name        VARCHAR(255),
    node_params      OID,
    skip_when_failed BOOLEAN   NOT NULL,
    TYPE             INTEGER,
    workflow_id      BIGINT
);

CREATE INDEX IF NOT EXISTS idx01_workflow_node_info ON power_job.workflow_node_info (workflow_id, gmt_create);
