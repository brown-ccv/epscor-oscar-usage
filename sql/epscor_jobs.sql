SELECT DISTINCT
	ass.user,
	ass.parent_acct,
	job.id_user,
	job.account,
	job.id_qos,
	qos.name AS qos_name,
	acc.organization,
	job.partition,
	job.id_group,
	job.job_name,
	job.cpus_req,
	job.mem_req,
	job.nodes_alloc,
	job.tres_alloc,
	job.gres_req,
	job.time_start,
	FROM_UNIXTIME(job.time_start)  AS start_time,
	FROM_UNIXTIME(job.time_submit) AS submit_time,
	FROM_UNIXTIME(job.time_end)    AS end_time,
	job.timelimit,
	(FROM_UNIXTIME(job.time_start) - FROM_UNIXTIME(job.time_submit))   AS sec_waiting_in_queue,
	(FROM_UNIXTIME(job.time_end) - FROM_UNIXTIME(job.time_start))      AS sec_runtime,
	(FROM_UNIXTIME(job.time_end) - FROM_UNIXTIME(job.time_start)) / 60 AS min_runtime,
	job.exit_code
	
FROM
	slurmctld_job_table job
	LEFT JOIN slurmctld_assoc_table AS ass ON job.id_assoc = ass.id_assoc
	LEFT JOIN qos_table             AS qos ON job.id_qos = qos.id
	LEFT JOIN acct_table            AS acc ON job.account = acc.name
WHERE
    qos.name = 'epscor-condo'
    OR job.account LIKE 'epscor%'
;       

