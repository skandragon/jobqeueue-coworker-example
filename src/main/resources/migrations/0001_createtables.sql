CREATE TABLE IF NOT EXISTS public.delayed_work (
	id BIGSERIAL PRIMARY KEY,
	locked_by VARCHAR(255),
	created_at TIMESTAMP,
	run_at TIMESTAMP,
	stage INTEGER,
	priority INTEGER,
	work_unique_name VARCHAR(255),
	strand VARCHAR(255),
	state TEXT
);

CREATE TABLE IF NOT EXISTS public.failed_work (
	id BIGINT PRIMARY KEY,
	failed_at TIMESTAMP,
	stage INTEGER,
	work_unique_name VARCHAR(255),
	failed_msg TEXT,
	strand VARCHAR(255),
	state TEXT,
	run_by VARCHAR(255)
);

CREATE INDEX IF NOT EXISTS index_delayed_work_on_locked_by ON public.delayed_work(locked_by) WHERE locked_by IS NULL;
CREATE INDEX IF NOT EXISTS index_delayed_work_on_strand ON public.delayed_work(strand);

CREATE TABLE IF NOT EXISTS public.delayed_work_credits (
    job_name VARCHAR(255),
    strand_name VARCHAR(255),
    stage INTEGER,
    rolling_average_seconds BIGINT,
    total_jobs BIGINT,
    PRIMARY KEY(job_name, strand_name, stage)
);

CREATE UNLOGGED TABLE IF NOT EXISTS public.delayed_work_credit_use(
    job_name VARCHAR(255),
    strand_name VARCHAR(255),
    stage INTEGER,
    in_use BIGINT,
    PRIMARY KEY(job_name, strand_name, stage)
);
