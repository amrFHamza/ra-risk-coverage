/**
 * Using Rails-like standard naming convention for endpoints.
 * GET     /api/dfl-procedures              ->  index
 */

'use strict';

var db = require("../../utils/db");
var _und = require("underscore");
var moment = require("moment");
var async = require("async");

// Gets a list of DflProcedures

export function getApiEndpoint(req, res, next) {

	if (req.params.apiEndpoint === "getAllProcedures") {

		db.query(`
							SELECT 
								p.PROCEDURE_ID, p.OPCO_ID, p.TYPE, p.SUB_TYPE, p.STATUS_CODE, p.NAME, p.DESCRIPTION, p.MODIFIED,
								jc.CODE_LOCATION, jc.JOB_PARAMETERS, 
								cc.CONTROL_TYPE, cc.CONTROL_ASSERTION, cc.START_DATE, cc.END_DATE, cc.CVG_CONTROL_ID, cc.ESCALATION_NOTES,
								sc.SOX_RELEVANT, sc.SOLUTION_CONTACT_ID, sc.DOCU_LINK,
								s.SCHEDULE_ID, s.NAME SCHEDULE_NAME, s.TYPE SCHEDULE_TYPE, s.FREQUENCY, s.COMMENT SCHEDULE_COMMENT,
								cvc.CVG_RN_CNT, 
								case
									when cvc.CVG_RN_CNT > 0 then 'Y'
									when cvc.CVG_RN_CNT = 0 then 'N'
								end IN_COVERAGE_MODEL,
								cvc.CTRL_COVERAGE,
								cvc.CTRL_COVERAGE_OVERLAP,
								case 
									when p.TYPE = 'J' then 'Job' 
									when p.TYPE = 'C' then 'Control' 
									when p.TYPE = 'T' then 'Dato' 
									when p.TYPE = 'S' then 'Report solution'
								end TYPE_TEXT,
								case 
									when s.TYPE = 'A' then 'Application' 
									when s.TYPE = 'W' then 'Windows' 
									when s.TYPE = 'U' then 'UX Cron' 
									when s.TYPE = 'D' then 'Database'
									when s.TYPE = 'M' then 'Manual'
								end SCHEDULE_TYPE_TEXT,
								case 
									when s.FREQUENCY = 'A' then 'Ad-hoc' 
									when s.FREQUENCY = 'H' then 'Hourly' 
									when s.FREQUENCY = 'D' then 'Daily' 
									when s.FREQUENCY = 'W' then 'Weekly' 
									when s.FREQUENCY = 'M' then 'Monthly' 
									when s.FREQUENCY = 'C' then 'Bill cycle' 
								end FREQUENCY_TEXT														
							FROM dfl_procedure p
							left join dfl_job_catalogue jc on jc.procedure_id = p.procedure_id
							left join dfl_control_catalogue cc on cc.procedure_id = p.procedure_id
							left join dfl_solution_catalogue sc on sc.procedure_id = p.procedure_id
							left join dfl_schedule s on s.schedule_id = p.schedule_id
							left join v_cvg_control cvc on cvc.control_id = cc.cvg_control_id
							where p.OPCO_ID like case when ? = '0' then '%' else ifnull(?, '%') end
							order by p.MODIFIED desc
			`, 
			[req.query.opcoId, req.query.opcoId],
			function (err, row) {
				if(err !== null) {
					console.log(err);
					next(err);
				}
				else {
					res.json(row);
				}
		});

	}

 if (req.params.apiEndpoint === "getSchedules") {
		db.query(`
							SELECT 
								SCHEDULE_ID, 
								NAME, 
								TYPE, 
								FREQUENCY, 
								COMMENT,
								case 
									when s.TYPE = 'A' then 'Application' 
									when s.TYPE = 'W' then 'Windows' 
									when s.TYPE = 'U' then 'UX Cron' 
									when s.TYPE = 'D' then 'Database'
									when s.TYPE = 'M' then 'Manual'
								end SCHEDULE_TYPE_TEXT,
								case 
									when s.FREQUENCY = 'A' then 'Ad-hoc' 
									when s.FREQUENCY = 'D' then 'Daily' 
									when s.FREQUENCY = 'H' then 'Hourly' 
									when s.FREQUENCY = 'W' then 'Weekly' 
									when s.FREQUENCY = 'M' then 'Monthly' 
									when s.FREQUENCY = 'C' then 'Bill cycle' 
								end FREQUENCY_TEXT								
							FROM dfl_schedule s
							where 1=1
								and s.OPCO_ID like ifnull(?, '%')
							order by 3,4,2
			`, 
			[req.query.opcoId],
			function (err, row) {
				if(err !== null) {
					console.log(err);
					next(err);
				}
				else {
					//res.json(_und.pluck(row, 'SUB_TYPE'));
					res.json(row);
				}
		});
	}

 if (req.params.apiEndpoint === "getLinkedDatasources") {
		db.query(`
							select  
								df.DATAFLOW_ID,
								df.PROCEDURE_ID,
								df.DIRECTION,
								ds.DATASOURCE_ID, 
								ds.OPCO_ID, 
								ds.TYPE, 
								ds.NAME, 
								ds.RETENTION_POLICY, 
								ds.DESCRIPTION, 
								ds.STATUS_CODE,
								d.OWNER, 
								d.COMMENT, 
								f.HOST, 
								f.DIRECTORY, 
								f.FILEMASK, 
								f.FORMAT, 
								f.COMPRESSION,
								m.SUBJECT, 
								m.RECIPIENTS,
								case 
									when ds.TYPE = 'D' then 'DB Object' 
									when ds.TYPE = 'F' then 'File' 
									when ds.TYPE = 'E' then 'Email' 
								end TYPE_TEXT 
							from dfl_dataflow df
							join dfl_datasource ds on ds.DATASOURCE_ID = df.DATASOURCE_ID
							left join dfl_dbobject d on d.datasource_id = ds.datasource_id
							left join dfl_file f on f.datasource_id = ds.datasource_id
							left join dfl_mail m on m.datasource_id = ds.datasource_id
							where df.procedure_id = ? and df.DIRECTION like ?

							union 

							select  
								null DATAFLOW_ID,
								dfp.procedure_id PROCEDURE_ID,
								'O' DIRECTION,
								concat('M', '-', mc.METRIC_ID,'-',mc.OPCO_ID) DATASOURCE_ID,
								mc.OPCO_ID, 
								'R' TYPE, 
								mc.METRIC_ID NAME, 
								null RETENTION_POLICY, 
								concat(mc.NAME, ' - ', mc.DESCRIPTION) DESCRIPTION, 
								case 
									when mc.IMPLEMENTED = 'Y' then 'A' 
									else 'D'
								end STATUS_CODE,
								null OWNER, 
								null COMMENT, 
								null HOST, 
								null DIRECTORY, 
								null FILEMASK, 
								null FORMAT, 
								null COMPRESSION,
								null SUBJECT, 
								null RECIPIENTS,
								'AMX Metric' TYPE_TEXT 
							from dfl_procedure dfp
							join amx_metric_dato_link mdl on mdl.DATO_ID = dfp.NAME and mdl.OPCO_ID = dfp.OPCO_ID
							join amx_metric_catalogue mc on mc.METRIC_ID = mdl.METRIC_ID and mc.OPCO_ID = dfp.OPCO_ID
							where dfp.type = 'T' and dfp.procedure_id = ?	and 'O' like ?						
			`, 
			[req.query.procedureId, (req.query.getDirection === 'A'?'%':req.query.getDirection), req.query.procedureId, (req.query.getDirection === 'A'?'%':req.query.getDirection)],
			function (err, row) {
				if(err !== null) {
					console.log(err);
					next(err);
				}
				else {
					//res.json(_und.pluck(row, 'SUB_TYPE'));
					res.json(row);
				}
		});
	}

 if (req.params.apiEndpoint === "getProcedureSubTypesList") {
		db.query(`
							SELECT distinct SUB_TYPE FROM dfl_procedure p
							where 1=1
								and p.OPCO_ID like ifnull(?, '%')
								and p.TYPE = ifnull(? , 'J')
			`, 
			[req.query.opcoId, req.query.type],
			function (err, row) {
				if(err !== null) {
					console.log(err);
					next(err);
				}
				else {
					//res.json(_und.pluck(row, 'SUB_TYPE'));
					res.json(row);
				}
		});
	}

	if (req.params.apiEndpoint === "getProcedure") {
		db.query(`
								SELECT 
									p.PROCEDURE_ID, p.OPCO_ID, p.TYPE, p.SUB_TYPE, p.STATUS_CODE, p.NAME, p.DESCRIPTION, p.MODIFIED,
									jc.CODE_LOCATION, jc.JOB_PARAMETERS, 
									cc.CONTROL_TYPE, cc.CONTROL_ASSERTION, cc.START_DATE, cc.END_DATE, cc.CVG_CONTROL_ID, cc.ESCALATION_NOTES,
									sc.SOX_RELEVANT, sc.SOLUTION_CONTACT_ID, sc.DOCU_LINK,
									s.SCHEDULE_ID, s.NAME SCHEDULE_NAME, s.TYPE SCHEDULE_TYPE, s.FREQUENCY, s.COMMENT SCHEDULE_COMMENT,
									case 
										when p.TYPE = 'J' then 'Job' 
										when p.TYPE = 'C' then 'Control' 
										when p.TYPE = 'T' then 'Dato' 
										when p.TYPE = 'S' then 'Report solution'
									end TYPE_TEXT,
									case 
										when p.STATUS_CODE = 'A' then 'Active' 
										when p.STATUS_CODE = 'I' then 'Inactive' 
										when p.STATUS_CODE = 'D' then 'Development' 
										when p.STATUS_CODE = 'P' then 'Plan' 
									end STATUS_CODE_TEXT,									
									case 
										when s.TYPE = 'A' then 'Application' 
										when s.TYPE = 'W' then 'Windows' 
										when s.TYPE = 'U' then 'UX Cron' 
										when s.TYPE = 'D' then 'Database'
										when s.TYPE = 'M' then 'Manual'
									end SCHEDULE_TYPE_TEXT,
									case 
										when s.FREQUENCY = 'A' then 'Ad-hoc' 
										when s.FREQUENCY = 'H' then 'Hourly' 
										when s.FREQUENCY = 'D' then 'Daily' 
										when s.FREQUENCY = 'W' then 'Weekly' 
										when s.FREQUENCY = 'M' then 'Monthly' 
										when s.FREQUENCY = 'C' then 'Bill cycle' 
									end FREQUENCY_TEXT													
								FROM dfl_procedure p
								left join dfl_job_catalogue jc on jc.procedure_id = p.procedure_id
								left join dfl_control_catalogue cc on cc.procedure_id = p.procedure_id
								left join dfl_solution_catalogue sc on sc.procedure_id = p.procedure_id
								left join dfl_schedule s on s.schedule_id = p.schedule_id
								where p.PROCEDURE_ID = ?
				`, 
				[req.query.procedureId],
				function (err, row) {
					if(err !== null) {
						console.log(err);
						next(err);
					}
					else {
						res.json(row[0]);
					}
			});
	}

 if (req.params.apiEndpoint === "getAllSchedulers") {
		db.query(`
							select 
								s.*,
								case 
									when s.TYPE = 'A' then 'Application' 
									when s.TYPE = 'W' then 'Windows' 
									when s.TYPE = 'U' then 'UX/Cron' 
									when s.TYPE = 'D' then 'Database'
									when s.TYPE = 'M' then 'Manual'
								end TYPE_TEXT
							from dfl_schedule s
							where 1=1
								and OPCO_ID like ifnull(?, '%')
			`, 
			[req.query.opcoId],
			function (err, row) {
				if(err !== null) {
					console.log(err);
					next(err);
				}
				else {
					//res.json(_und.pluck(row, 'SUB_TYPE'));
					res.json(row);
				}
		});
	}

	if (req.params.apiEndpoint === "getScheduler") {
		db.query(`
							select 
								s.*,
								case 
									when s.TYPE = 'A' then 'Application' 
									when s.TYPE = 'W' then 'Windows' 
									when s.TYPE = 'U' then 'UX/Cron' 
									when s.TYPE = 'D' then 'Database'
									when s.TYPE = 'M' then 'Manual'
								end TYPE_TEXT
							from dfl_schedule s
							where 1=1
								and SCHEDULE_ID = ?
				`, 
				[req.query.schedulerId],
				function (err, row) {
					if(err !== null) {
						console.log(err);
						next(err);
					}
					else {
						res.json(row[0]);
					}
			});
	}

}

export function postApiEndpoint(req, res, next) {

	if (req.params.apiEndpoint === "saveProcedure") {

		if (typeof req.body.PROCEDURE_ID === 'undefined') {
			// new procedure 
			// console.log("Insert:");
			// console.log(req.body);
			db.query(`insert into DFL_PROCEDURE (OPCO_ID, TYPE, SUB_TYPE, NAME, DESCRIPTION, STATUS_CODE, SCHEDULE_ID) 
								values (?,?,?,?,?,?,?)`,
								[req.body.OPCO_ID, req.body.TYPE, req.body.SUB_TYPE, req.body.NAME, req.body.DESCRIPTION, req.body.STATUS_CODE, req.body.SCHEDULE_ID],
								function (err, row) {
									if (!err) {
										var procedureId = row.insertId;

										// Start insert links
										if (typeof req.body.links !== 'undefined' && req.body.links.length > 0) {
												db.query('delete from dfl_dataflow where PROCEDURE_ID = ?', [procedureId],
													function(err, row) {
													if (err) {
														console.log(err);
													}
													else {
														async.forEach(req.body.links, 
															function(link, callback) {
																// Ignore Metric (TYPE == R)
																if (link.TYPE !== 'R') {
																	db.query('insert into dfl_dataflow (PROCEDURE_ID, DATASOURCE_ID, DIRECTION) values (?,?,?)',
																		[procedureId, link.DATASOURCE_ID, link.DIRECTION],
																		function(err, row) {
																			if (err) {
																				console.log(err);
																			}
																			callback();
																	});
																}
															}
														); // end async 
													}
												});
										}
										// End insert links

										switch (req.body.TYPE) {
											case 'J':
																db.query(`insert into DFL_JOB_CATALOGUE (PROCEDURE_ID, CODE_LOCATION, JOB_PARAMETERS) 
																					values (?,?,?)`,
																					[procedureId, req.body.CODE_LOCATION, req.body.JOB_PARAMETERS],
																					function (err, row) {
																						if (!err) {
																							res.json({success: true})
																						}
																						else {
																							res.json({success: false, error: err});
																							console.log(err);
																						}
																					}
																);
																break;
											case 'C':
																db.query(`insert into DFL_CONTROL_CATALOGUE (PROCEDURE_ID, CONTROL_TYPE, CONTROL_ASSERTION, START_DATE, END_DATE, ESCALATION_NOTES) 
																					values (?,?,?,?,?,?)`,
																					[procedureId, req.body.CONTROL_TYPE, JSON.stringify(req.body.CONTROL_ASSERTION), (req.body.START_DATE?moment(req.body.START_DATE).format("YYYY-MM-DD"):null), (req.body.END_DATE?moment(req.body.END_DATE).format("YYYY-MM-DD"):null), req.body.ESCALATION_NOTES],
																					function (err, row) {
																						if (!err) {
																							res.json({success: true})
																						}
																						else {
																							res.json({success: false, error: err});
																							console.log(err);
																						}
																					}
																);
																break;
											case 'S':
																db.query(`insert into DFL_SOLUTION_CATALOGUE (PROCEDURE_ID, SOX_RELEVANT, SOLUTION_CONTACT_ID, DOCU_LINK) 
																					values (?,?,?,?)`,
																					[procedureId, req.body.SOX_RELEVANT, req.body.SOLUTION_CONTACT_ID, req.body.DOCU_LINK],
																					function (err, row) {
																						if (!err) {
																							res.json({success: true})
																						}
																						else {
																							res.json({success: false, error: err});
																							console.log(err);
																						}
																					}
																);
																break;
											case 'T':
																db.query(`update amx_dato_catalogue set PROCEDURE_ID=? 
																					where DATO_ID=? and OPCO_ID=?`,
																					[procedureId, req.body.NAME, req.body.OPCO_ID],
																					function (err, row) {
																						if (!err) {
																							res.json({success: true})
																						}
																						else {
																							res.json({success: false, error: err});
																							console.log(err);
																						}
																					}
																);
																break;												  		
											default:
																res.json({success: false, error: 'No procedure type for insert'});
																break;
										}
										
									}
									else {
										res.json({success: false, error: err});
										console.log(err);
									}
								}
			);

		}
		else {
			// update
			// console.log("Update:");
			// console.log(req.body);  		
			db.query(`update DFL_PROCEDURE set OPCO_ID=?, TYPE=?, SUB_TYPE=?, NAME=?, DESCRIPTION=?, STATUS_CODE=?, SCHEDULE_ID=? 
								where PROCEDURE_ID = ?`,
								[req.body.OPCO_ID, req.body.TYPE, req.body.SUB_TYPE, req.body.NAME, req.body.DESCRIPTION, req.body.STATUS_CODE, req.body.SCHEDULE_ID, req.body.PROCEDURE_ID],
								function (err, row) {
									if (!err) {

										// Start insert links
										if (typeof req.body.links !== 'undefined' && req.body.links.length > 0) {
												db.query('delete from dfl_dataflow where PROCEDURE_ID = ?', [req.body.PROCEDURE_ID],
													function(err, row) {
													if (err) {
														console.log(err);
													}
													else {
														async.forEach(req.body.links, 
															function(link, callback) {
																// Ignore Metric (TYPE == R)
																if (link.TYPE !== 'R') {
																	db.query('insert into dfl_dataflow (PROCEDURE_ID, DATASOURCE_ID, DIRECTION) values (?,?,?)',
																		[link.PROCEDURE_ID, link.DATASOURCE_ID, link.DIRECTION],
																		function(err, row) {
																			if (err) {
																				console.log(err);
																			}
																			callback();
																	});
																}
															}
														); // end async 
													}
												});
										}
										// End insert links

										switch (req.body.TYPE) {
											case 'J':
																db.query(`update DFL_JOB_CATALOGUE set CODE_LOCATION=?, JOB_PARAMETERS=?
																					where PROCEDURE_ID = ?`,
																					[req.body.CODE_LOCATION, req.body.JOB_PARAMETERS, req.body.PROCEDURE_ID],
																					function (err, row) {
																						if (!err) {
																							res.json({success: true})
																						}
																						else {
																							res.json({success: false, error: err});
																							console.log(err);
																						}
																					}
																);
																break;
											case 'C':
																db.query(`update DFL_CONTROL_CATALOGUE set CONTROL_TYPE=?, CONTROL_ASSERTION=?, START_DATE=?, END_DATE=?, ESCALATION_NOTES = ?
																					where PROCEDURE_ID = ?`,
																					[req.body.CONTROL_TYPE, JSON.stringify(req.body.CONTROL_ASSERTION), (req.body.START_DATE?moment(req.body.START_DATE).format("YYYY-MM-DD"):null), (req.body.END_DATE?moment(req.body.END_DATE).format("YYYY-MM-DD"):null), req.body.ESCALATION_NOTES, req.body.PROCEDURE_ID],
																					function (err, row) {
																						if (!err) {
																							res.json({success: true})
																						}
																						else {
																							res.json({success: false, error: err});
																							console.log(err);
																						}
																					}
																);
																break;
											case 'S':
																db.query(`update DFL_SOLUTION_CATALOGUE set SOX_RELEVANT=?, SOLUTION_CONTACT_ID=?, DOCU_LINK=? 
																					where PROCEDURE_ID=?`,
																					[req.body.SOX_RELEVANT, req.body.SOLUTION_CONTACT_ID, req.body.DOCU_LINK, req.body.PROCEDURE_ID],
																					function (err, row) {
																						if (!err) {
																							res.json({success: true})
																						}
																						else {
																							res.json({success: false, error: err});
																							console.log(err);
																						}
																					}
																);
																break;
											case 'T':
																db.query(`update amx_dato_catalogue set PROCEDURE_ID=null
																					where PROCEDURE_ID=? and OPCO_ID=?`,
																					[req.body.PROCEDURE_ID, req.body.OPCO_ID],
																					function (err, row) {
																						if (!err) {
																							db.query(`update amx_dato_catalogue set PROCEDURE_ID=? 
																												where DATO_ID=? and OPCO_ID=?`,
																												[req.body.PROCEDURE_ID, req.body.NAME, req.body.OPCO_ID],
																												function (err, row) {
																													if (!err) {
																														res.json({success: true})
																													}
																													else {
																														res.json({success: false, error: err});
																														console.log(err);
																													}
																												}
																							);
																						}
																						else {
																							res.json({success: false, error: err});
																							console.log(err);
																						}
																					}
																);
																break;													  		
											default:
																res.json({success: false, error: 'No procedure type for update'});
																break;
										}
										
									}
									else {
										res.json({success: false, error: err});
										console.log(err);
									}
								}
			);  		
		}
	} else if (req.params.apiEndpoint === "saveScheduler") {
		if (typeof req.body.SCHEDULE_ID === 'undefined') {
			// new procedure 
			// console.log("Insert:");
			// console.log(req.body);
			db.query(`insert into dfl_schedule (SCHEDULE_ID, OPCO_ID, NAME, TYPE, FREQUENCY, COMMENT) 
								values (?,?,?,?,?,?)`,
								[req.body.SCHEDULE_ID, req.body.OPCO_ID, req.body.NAME, req.body.TYPE, req.body.FREQUENCY, req.body.COMMENT],
								function (err, row) {
									if (!err) {
										res.json({success: true})
									}
									else {
										res.json({success: false, error: err});
										console.log(err);
									}
								}
			);

		}
		else {
			// update
			// console.log("Update:");
			// console.log(req.body);  		
			db.query(`update dfl_schedule set OPCO_ID=?, NAME=?, TYPE=?, FREQUENCY=?, COMMENT=?
								where SCHEDULE_ID=?`,
								[req.body.OPCO_ID, req.body.NAME, req.body.TYPE, req.body.FREQUENCY, req.body.COMMENT, req.body.SCHEDULE_ID],
								function (err, row) {
									if (!err) {
										res.json({success: true})
									}
									else {
										res.json({success: false, error: err});
										console.log(err);
									}  								
								}
			);  		
		}
	}
	else {
		res.json({success: false, error: 'Method not found: ' + req.params.apiEndpoint});
	}

}

export function deleteApiEndpoint(req, res, next) {

	if (req.params.apiEndpoint === "deleteProcedure") {
		db.query('delete from dfl_procedure where PROCEDURE_ID = ?', 
			[req.query.procedureId], 
			function (err, row) {
				if(err !== null) {
					console.log(err);
					res.json({success: false, error: err});
				}
				else {
					res.json({success: true});
				}
			});	
	}
}