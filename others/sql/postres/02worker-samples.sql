CREATE TABLE IF NOT EXISTS power_job_daily.app_info
(
    id             BIGSERIAL    NOT NULL PRIMARY KEY,
    app_name       VARCHAR(255) NOT NULL
        CONSTRAINT uidx01_app_info UNIQUE,
    current_server VARCHAR(255)          DEFAULT NULL,
    password       VARCHAR(255) NOT NULL,
    gmt_create     TIMESTAMP    NOT NULL DEFAULT timezone('PRC', CURRENT_TIMESTAMP),
    gmt_modified   TIMESTAMP    NOT NULL DEFAULT timezone('PRC', CURRENT_TIMESTAMP)
);

COMMENT ON COLUMN power_job_daily.app_info.id IS '应用id';
COMMENT ON COLUMN power_job_daily.app_info.app_name IS '应用名称';
COMMENT ON COLUMN power_job_daily.app_info.current_server IS 'Server地址,用于负责调度应用的ActorSystem地址';
COMMENT ON COLUMN power_job_daily.app_info.password IS '密码';
COMMENT ON COLUMN power_job_daily.app_info.gmt_create IS '创建时间';
COMMENT ON COLUMN power_job_daily.app_info.gmt_modified IS '更新时间';

COMMENT ON TABLE power_job_daily.app_info IS '应用信息表';

ALTER TABLE power_job_daily.app_info
    OWNER TO power_job;

INSERT INTO power_job_daily.app_info (app_name, password)
SELECT DISTINCT 'powerjob-worker-samples',
                '123456'
FROM power_job_daily.app_info
WHERE NOT EXISTS (SELECT * FROM power_job_daily.app_info WHERE app_name = 'powerjob-worker-samples');