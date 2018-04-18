/**
 * Using Rails-like standard naming convention for endpoints.
 * GET     /api/lookups              ->  index
 */

'use strict';

var db = require("../../utils/db");
var _und = require("underscore");
var async = require("async");

// Gets a list of Lookups
export function index(req, res) {
  res.json([]);
}

// Gets a list of Lookups
export function postApiEndpoint(req, res) {
  var updateCount = 0;
  
  if (req.params.apiEndpoint === 'postFlashUpdate' && req.params.table === 'system') {
    updateCount = 0;

    async.forEach(req.body, 
      function (element, callback) {
        if (typeof element.SYSTEM_ID !== 'undefined') {
          db.query('update AMX_SYSTEM set OPCO_ID=?, NAME=?, DESCRIPTION=? where SYSTEM_ID=? and (NAME != ? or DESCRIPTION != ?)',
            [element.OPCO_ID, element.NAME, element.DESCRIPTION, element.SYSTEM_ID, element.NAME, element.DESCRIPTION], 
            function (updateErr, updateRow) {
              updateCount += updateRow.changedRows;
              if(updateErr !== null) {
                console.log(updateErr);
                res.json({success: false, error: updateErr});
              }
              callback();
            });
        }
        else {
          db.query('insert into AMX_SYSTEM (OPCO_ID, NAME, DESCRIPTION) values (?, ?, ?)', [element.OPCO_ID, element.NAME, element.DESCRIPTION], 
            function (insertErr, insertRow){
              updateCount += insertRow.changedRows;
              callback();
              //console.log(this.lastID);
            });
        }
      },
      // finally
      function () {
        res.json({success: true, updates: updateCount});
      }
    );
  }

  if (req.params.apiEndpoint === 'postFlashUpdate' && req.params.table === 'contact') {
    updateCount = 0;

    async.forEach(req.body, 
      function (element, callback) {
        if (typeof element.CONTACT_ID !== 'undefined') {
          db.query("update AMX_CONTACT set OPCO_ID=?, CONTACT_TYPE=?, NAME=?, EMAIL=? where CONTACT_ID=? and (ifnull(NAME, 'na') != ifnull(?, 'na') or ifnull(CONTACT_TYPE, 'na') != ifnull(?, 'na') or ifnull(EMAIL, 'na') != ifnull(?, 'na') )",
            [element.OPCO_ID, element.CONTACT_TYPE, element.NAME, element.EMAIL, element.CONTACT_ID, element.NAME, element.CONTACT_TYPE, element.EMAIL], 
            function (updateErr, updateRow) {
              updateCount += updateRow.changedRows;
              if(updateErr !== null) {
                console.log(updateErr);
                res.json({success: false, error: updateErr});
              }
              callback();
            });
        }
        else {
          db.query('insert into AMX_CONTACT (OPCO_ID, CONTACT_TYPE, NAME, EMAIL) values (?, ?, ?, ?)', 
            [element.OPCO_ID, element.CONTACT_TYPE, element.NAME, element.EMAIL], 
            function (insertErr, insertRow){
              updateCount += insertRow.changedRows;
              callback();
              //console.log(this.lastID);
            });
        }
      },
      // finally
      function () {
        res.json({success: true, updates: updateCount});
      }
    );

  }

  if (req.params.apiEndpoint === 'postFlashUpdate' && req.params.table === 'cycle') {
    updateCount = 0;

    async.forEach(req.body, 
      function (element, callback) {
        if (typeof element.BILL_CYCLE_ID !== 'undefined') {
          db.query("update AMX_BILL_CYCLE set OPCO_ID=?, BILL_CYCLE=?, DESCRIPTION=?, CYCLE_CLOSE_DAY=?, CYCLE_TYPE=? where BILL_CYCLE_ID=? and (ifnull(BILL_CYCLE, 0) != ? or ifnull(DESCRIPTION, '') != ? or ifnull(CYCLE_CLOSE_DAY, 0) != ? or CYCLE_TYPE != ?)",
            [element.OPCO_ID, element.BILL_CYCLE, element.DESCRIPTION, element.CYCLE_CLOSE_DAY,  element.CYCLE_TYPE, element.BILL_CYCLE_ID, element.BILL_CYCLE, element.DESCRIPTION, element.CYCLE_CLOSE_DAY, element.CYCLE_TYPE], 
            function (updateErr, updateRow) {
              if(updateErr !== null) {
                console.log(updateErr);
                res.json({success: false, error: updateErr});
              }
              else {
                updateCount += updateRow.changedRows;
                callback();
              }
            });
        }
        else {
          db.query('insert into AMX_BILL_CYCLE (OPCO_ID, BILL_CYCLE, DESCRIPTION, CYCLE_CLOSE_DAY, CYCLE_TYPE) values (?, ?, ?, ?, ?)', 
            [element.OPCO_ID, element.BILL_CYCLE, element.DESCRIPTION, element.CYCLE_CLOSE_DAY, element.CYCLE_TYPE], 
            function (insertErr, insertRow){
              updateCount += insertRow.changedRows;
              callback();
              //console.log(this.lastID);
            });
        }
      },
      // finally
      function () {
        res.json({success: true, updates: updateCount});
      }
    );
  }
}

export function getApiEndpoint(req, res, next) {

  if (req.params.apiEndpoint === "getOpcos")
    db.query("select * from AMX_OPCO order by opco_id", function(err, row) {
      if(err !== null) {
        console.log(err);
        next(err);
      }
      else {
        res.json(row);
      }
    });

  if (req.params.apiEndpoint === "getLobs")
    db.query("select * from AMX_LOB order by lob_id", function(err, row) {
      if(err !== null) {
        console.log(err);
        next(err);
      }
      else {
        res.json(row);
      }
    });

  if (req.params.apiEndpoint === "getAreas")
    db.query("select * from AMX_AREA order by area_id", function(err, row) {
      if(err !== null) {
        console.log(err);
        next(err);
      }
      else {
        res.json(row);
      }
    });

  if (req.params.apiEndpoint === "getServices")
    db.query("select * from AMX_SERVICE order by service_id", function(err, row) {
      if(err !== null) {
        console.log(err);
        next(err);
      }
      else {
        res.json(row);
      }
    });

  if (req.params.apiEndpoint === "getTechnologies")
    db.query("select * from AMX_TECHNOLOGY order by technology_id", function(err, row) {
      if(err !== null) {
        console.log(err);
        next(err);
      }
      else {
        res.json(row);
      }
    });

  if (req.params.apiEndpoint === "getSystems")
    db.query("select * from AMX_SYSTEM order by opco_id, name", function(err, row) {
      if(err !== null) {
        console.log(err);
        next(err);
      }
      else {
        res.json(row);
      }
    });

  if (req.params.apiEndpoint === "getContacts")
    db.query("select * from AMX_CONTACT order by opco_id, contact_type, name", function(err, row) {
      if(err !== null) {
        console.log(err);
        next(err);
      }
      else {
        res.json(row);
      }
    });

  if (req.params.apiEndpoint === "getBillCycles")
    db.query("select * from AMX_BILL_CYCLE order by opco_id, bill_cycle", function(err, row) {
      if(err !== null) {
        console.log(err);
        next(err);
      }
      else {
        res.json(row);
      }
    });

  if (req.params.apiEndpoint === "getPeriodicity")
    db.query("select * from AMX_PERIODICITY order by periodicity_id", function(err, row) {
      if(err !== null) {
        console.log(err);
        next(err);
      }
      else {
        res.json(row);
      }
    });

  if (req.params.apiEndpoint === "getCounters") {
      db.query("select * from V_COUNTERS where OPCO_ID = ifnull(?, 0) LIMIT 1", 
        [req.query.opcoId],
        function(err, row) {
          if(err !== null) {
            console.log(err);
            next(err);
          }
          else {
            res.json(row[0]);
          }
        });
    }

  if (req.params.apiEndpoint === "getCountersAll") {
      db.query("select * from V_COUNTERS", 
        [],
        function(err, row) {
          if(err !== null) {
            console.log(err);
            next(err);
          }
          else {
            res.json(row);
          }
        });
    }

  // IF TAG Overview
  if (req.params.apiEndpoint === "getOverview" && req.query.opcoId === '0') {
        if(req.query.frequency === 'D'){
          db.query(`select 
                  MONTH,
                  '0' OPCO_ID,
                  DISTINCT_CNT,
                  CNT,
                  ifnull(GREEN/CNT * 100, 0) GREEN,
                  ifnull(YELLOW/CNT * 100, 0) YELLOW,
                  ifnull(ORANGE/CNT * 100, 0)  ORANGE,
                  ifnull(RED/CNT * 100, 0)  RED,
                  ifnull(NO_RESULT/CNT * 100, 0) NO_RESULT
              from
              (
                  select 
                      substr(v.DATE, 1, 7) MONTH,
                      count(distinct v.METRIC_ID) DISTINCT_CNT,
                      sum(v.GREEN) GREEN,
                      sum(v.YELLOW) YELLOW,
                      sum(v.ORANGE) ORANGE,
                      sum(v.RED) RED,
                      sum(v.NO_RESULT) NO_RESULT,
                      sum(v.GREEN + YELLOW + ORANGE + RED + NO_RESULT) CNT
                  from (
                          SELECT t.DATE,
                            a.METRIC_ID,
                            ifnull(b.BILL_CYCLE, 0) CYCLE_CODE,
                            sum(CASE WHEN (b.VALUE <= (a.OBJECTIVE)) or (b.VALUE > (a.OBJECTIVE) AND b.VALUE <= (a.OBJECTIVE + a.TOLERANCE) and a.TREND='Y') THEN 1 ELSE 0 END) GREEN,
                            sum(CASE WHEN b.VALUE > (a.OBJECTIVE) AND b.VALUE <= (a.OBJECTIVE + a.TOLERANCE) and a.TREND='N' THEN 1 ELSE 0 END) YELLOW,
                            sum(CASE WHEN b.VALUE > (a.OBJECTIVE + a.TOLERANCE) and a.TREND='Y' THEN 1 ELSE 0 END) ORANGE,
                            sum(CASE WHEN b.VALUE > (a.OBJECTIVE + a.TOLERANCE) and a.TREND='N' THEN 1 ELSE 0 END) RED,
                            sum(case when (b.RESULT_ID is null or b.ERROR_CODE is not null) and datediff(curdate(), t.DATE) > ifnull(dm.DELAY,2) then 1 else 0 end) NO_RESULT
                          FROM AMX_TIME_DAY t
                          JOIN AMX_METRIC_CATALOGUE a ON 1 = 1
                          left join V_DIM_METRIC dm on dm.OPCO_ID = a.OPCO_ID
                              and dm.METRIC_ID = a.METRIC_ID
                          LEFT JOIN AMX_METRIC_RESULT b ON b.METRIC_ID = a.METRIC_ID 
                              and b.OPCO_ID = a.OPCO_ID 
                              and b.DATE = t.DATE
                              and ifnull(b.BILL_CYCLE, 0) = ifnull(dm.BILL_CYCLE, 0)
                              and b.DATE BETWEEN case when date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -13 month) > '2016-02-01' then date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -13 month) else '2016-02-01' end and date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -1 day)
                          WHERE a.FREQUENCY = 'D'
                              and a.START_DATE <= t.DATE                        
                              and a.RELEVANT = 'Y'
                              and t.DATE BETWEEN date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -13 month) AND date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -1 day)
                              and a.IMPLEMENTED like ?
                          GROUP BY t.DATE,
                              a.METRIC_ID,
                              ifnull(b.BILL_CYCLE, 0)                    
                      ) v                  
                  group by substr(v.DATE, 1, 7)
              ) sub1
              order by 1 desc`, 
            [req.query.finetuneFilter], 
            function(err, row) {
              if(err !== null) {
                console.log(err);
                next(err);
              }
              else {
                res.json(row);
              }
          });
        }
        else if(req.query.frequency === 'M') {
          db.query(`select 
                  MONTH,
                  '0' OPCO_ID,
                  CNT,
                  DISTINCT_CNT,
                  ifnull(GREEN/CNT * 100, 0) GREEN,
                  ifnull(YELLOW/CNT * 100, 0) YELLOW,
                  ifnull(ORANGE/CNT * 100, 0)  ORANGE,
                  ifnull(RED/CNT * 100, 0)  RED,
                  ifnull(NO_RESULT/CNT * 100, 0) NO_RESULT
              from
              (
                  select 
                      substr(DATE, 1, 7) MONTH,
                      count(distinct v.METRIC_ID) DISTINCT_CNT,
                      sum(GREEN) GREEN,
                      sum(YELLOW) YELLOW,
                      sum(ORANGE) ORANGE,
                      sum(RED) RED,
                      sum(NO_RESULT) NO_RESULT,
                      sum(GREEN + YELLOW + ORANGE + RED + NO_RESULT) CNT
                  from (
                        SELECT 
                          t.DATE,
                          a.METRIC_ID,
                          c.BILL_CYCLE,
                          sum(CASE WHEN (b.VALUE <= (a.OBJECTIVE)) or (b.VALUE > (a.OBJECTIVE) AND b.VALUE <= (a.OBJECTIVE + a.TOLERANCE) and a.TREND='Y') THEN 1 ELSE 0 END) GREEN,
                          sum(CASE WHEN b.VALUE > (a.OBJECTIVE) AND b.VALUE <= (a.OBJECTIVE + a.TOLERANCE) and a.TREND='N' THEN 1 ELSE 0 END) YELLOW,
                          sum(CASE WHEN b.VALUE > (a.OBJECTIVE + a.TOLERANCE) and a.TREND='Y' THEN 1 ELSE 0 END) ORANGE,
                          sum(CASE WHEN b.VALUE > (a.OBJECTIVE + a.TOLERANCE) and a.TREND='N' THEN 1 ELSE 0 END) RED,
                          sum(case when (b.RESULT_ID is null or b.ERROR_CODE is not null) and datediff(curdate(), t.DATE) - case when ifnull(c.CYCLE_CLOSE_DAY, 0) = 0 then datediff(t.LAST_DATE, t.DATE) else ifnull(c.CYCLE_CLOSE_DAY, 0) end > ifnull(dm.DELAY,2) then 1 else 0 end) NO_RESULT
                        FROM AMX_TIME_MONTH t
                        JOIN AMX_METRIC_CATALOGUE a ON 1 = 1
                        JOIN AMX_BILL_CYCLE c ON c.OPCO_ID = case when a.FREQUENCY = 'C' then a.OPCO_ID else 0 end
                          and (t.CALENDAR_MONTH * substr(c.CYCLE_TYPE, 2, 1) + substr(c.CYCLE_TYPE, 3, 1))%2 = 0
                        left join V_DIM_METRIC dm on dm.OPCO_ID = a.OPCO_ID
                          and dm.METRIC_ID = a.METRIC_ID      
                          and ifnull(dm.BILL_CYCLE, 0) = ifnull(c.BILL_CYCLE, 0)
                        LEFT JOIN AMX_METRIC_RESULT b ON  
                          b.METRIC_ID = a.METRIC_ID AND 
                          b.OPCO_ID = a.OPCO_ID AND 
                          b.DATE = t.DATE AND 
                          ifnull(b.BILL_CYCLE, 0) = ifnull(c.BILL_CYCLE, 0) AND
                          b.DATE BETWEEN case when date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -14 month) > '2016-01-01' then date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -14 month) else '2016-01-01' end and date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -1 month)
                        WHERE a.FREQUENCY in ('C', 'M') 
                          and a.START_DATE <= t.DATE                      
                          and a.RELEVANT = 'Y' 
                          and t.DATE BETWEEN date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -14 month) AND date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -1 month)
                          and a.IMPLEMENTED like ?
                        GROUP BY t.DATE,
                          a.METRIC_ID,
                          c.BILL_CYCLE                
                  ) v
                  group by substr(DATE, 1, 7)
              ) sub1
              order by 1 desc`,
          [req.query.finetuneFilter], 
          function(err, row) {
            if(err !== null) {
              console.log(err);
              next(err);
            }
            else {
              res.json(row);
            }
          });
        }
    }    
    
    if (req.params.apiEndpoint === "getOverview" && req.query.opcoId !== '0') {
        if(req.query.frequency === 'D'){
          db.query(`select 
                  MONTH,
                  OPCO_ID,
                  DISTINCT_CNT,
                  CNT,
                  ifnull(GREEN/CNT * 100, 0) GREEN,
                  ifnull(YELLOW/CNT * 100, 0) YELLOW,
                  ifnull(ORANGE/CNT * 100, 0)  ORANGE,
                  ifnull(RED/CNT * 100, 0)  RED,
                  ifnull(NO_RESULT/CNT * 100, 0) NO_RESULT
              from
              (
                  select 
                      substr(v.DATE, 1, 7) MONTH,
                      v.OPCO_ID,
                      count(distinct v.METRIC_ID) DISTINCT_CNT,
                      sum(v.GREEN) GREEN,
                      sum(v.YELLOW) YELLOW,
                      sum(v.ORANGE) ORANGE,
                      sum(v.RED) RED,
                      sum(v.NO_RESULT) NO_RESULT,
                      sum(v.GREEN + YELLOW + ORANGE + RED + NO_RESULT) CNT
                  from (
                          SELECT t.DATE,
                              a.OPCO_ID,
                              a.METRIC_ID,
                              ifnull(b.BILL_CYCLE, 0) CYCLE_CODE,
                              sum(CASE WHEN (b.VALUE <= (a.OBJECTIVE)) or (b.VALUE > (a.OBJECTIVE) AND b.VALUE <= (a.OBJECTIVE + a.TOLERANCE) and a.TREND='Y') THEN 1 ELSE 0 END) GREEN,
                              sum(CASE WHEN b.VALUE > (a.OBJECTIVE) AND b.VALUE <= (a.OBJECTIVE + a.TOLERANCE) and a.TREND='N' THEN 1 ELSE 0 END) YELLOW,
                              sum(CASE WHEN b.VALUE > (a.OBJECTIVE + a.TOLERANCE) and a.TREND='Y' THEN 1 ELSE 0 END) ORANGE,
                              sum(CASE WHEN b.VALUE > (a.OBJECTIVE + a.TOLERANCE) and a.TREND='N' THEN 1 ELSE 0 END) RED,
                              sum(case when (b.RESULT_ID is null or b.ERROR_CODE is not null) and datediff(curdate(), t.DATE) > ifnull(dm.DELAY,2) then 1 else 0 end) NO_RESULT
                          FROM AMX_TIME_DAY t
                          JOIN AMX_METRIC_CATALOGUE a ON 1 = 1
                          left join V_DIM_METRIC dm on dm.OPCO_ID = a.OPCO_ID
                              and dm.METRIC_ID = a.METRIC_ID
                          LEFT JOIN AMX_METRIC_RESULT b ON b.METRIC_ID = a.METRIC_ID 
                              and b.OPCO_ID = a.OPCO_ID 
                              and b.DATE = t.DATE
                              and ifnull(b.BILL_CYCLE, 0) = ifnull(dm.BILL_CYCLE, 0)
                              and b.DATE BETWEEN case when date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -13 month) > '2016-02-01' then date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -13 month) else '2016-02-01' end and date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -1 day)
                          WHERE a.FREQUENCY = 'D'
                              and a.START_DATE <= t.DATE
                              and a.RELEVANT = 'Y'
                              and t.DATE BETWEEN date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -13 month) AND date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -1 day)
                              and a.OPCO_ID = ?
                              and a.IMPLEMENTED like ?
                          GROUP BY t.DATE,
                              a.OPCO_ID,
                              a.METRIC_ID,
                              ifnull(b.BILL_CYCLE, 0)                    
                      ) v                  
                  group by substr(v.DATE, 1, 7), v.OPCO_ID
              ) sub1
              order by 1 desc`, 
            [req.query.opcoId, req.query.finetuneFilter], 
            function(err, row) {
              if(err !== null) {
                console.log(err);
                next(err);
              }
              else {
                res.json(row);
              }
          });
        }
        else if(req.query.frequency === 'M') {
          db.query(`select 
                  MONTH,
                  OPCO_ID,
                  CNT,
                  DISTINCT_CNT,
                  ifnull(GREEN/CNT * 100, 0) GREEN,
                  ifnull(YELLOW/CNT * 100, 0) YELLOW,
                  ifnull(ORANGE/CNT * 100, 0)  ORANGE,
                  ifnull(RED/CNT * 100, 0)  RED,
                  ifnull(NO_RESULT/CNT * 100, 0) NO_RESULT
              from
              (
                  select 
                      substr(DATE, 1, 7) MONTH,
                      count(distinct v.METRIC_ID) DISTINCT_CNT,
                      OPCO_ID,
                      sum(GREEN) GREEN,
                      sum(YELLOW) YELLOW,
                      sum(ORANGE) ORANGE,
                      sum(RED) RED,
                      sum(NO_RESULT) NO_RESULT,
                      sum(GREEN + YELLOW + ORANGE + RED + NO_RESULT) CNT
                  from (
                        SELECT 
                          t.DATE,
                          a.OPCO_ID,
                          a.METRIC_ID,
                          c.BILL_CYCLE,
                          sum(CASE WHEN (b.VALUE <= (a.OBJECTIVE)) or (b.VALUE > (a.OBJECTIVE) AND b.VALUE <= (a.OBJECTIVE + a.TOLERANCE) and a.TREND='Y') THEN 1 ELSE 0 END) GREEN,
                          sum(CASE WHEN b.VALUE > (a.OBJECTIVE) AND b.VALUE <= (a.OBJECTIVE + a.TOLERANCE) and a.TREND='N' THEN 1 ELSE 0 END) YELLOW,
                          sum(CASE WHEN b.VALUE > (a.OBJECTIVE + a.TOLERANCE) and a.TREND='Y' THEN 1 ELSE 0 END) ORANGE,
                          sum(CASE WHEN b.VALUE > (a.OBJECTIVE + a.TOLERANCE) and a.TREND='N' THEN 1 ELSE 0 END) RED,
                          sum(case when (b.RESULT_ID is null or b.ERROR_CODE is not null) and datediff(curdate(), t.DATE) - case when ifnull(c.CYCLE_CLOSE_DAY, 0) = 0 then datediff(t.LAST_DATE, t.DATE) else ifnull(c.CYCLE_CLOSE_DAY, 0) end > ifnull(dm.DELAY,2) then 1 else 0 end) NO_RESULT
                        FROM AMX_TIME_MONTH t
                        JOIN AMX_METRIC_CATALOGUE a ON 1 = 1
                        JOIN AMX_BILL_CYCLE c ON c.OPCO_ID = case when a.FREQUENCY = 'C' then a.OPCO_ID else 0 end
                          and (t.CALENDAR_MONTH * substr(c.CYCLE_TYPE, 2, 1) + substr(c.CYCLE_TYPE, 3, 1))%2 = 0
                        left join V_DIM_METRIC dm on dm.OPCO_ID = a.OPCO_ID
                          and dm.METRIC_ID = a.METRIC_ID      
                          and ifnull(dm.BILL_CYCLE, 0) = ifnull(c.BILL_CYCLE, 0)
                        LEFT JOIN AMX_METRIC_RESULT b ON  
                          b.METRIC_ID = a.METRIC_ID 
                          and b.OPCO_ID = a.OPCO_ID 
                          and b.DATE = t.DATE 
                          and ifnull(b.BILL_CYCLE, 0) = ifnull(c.BILL_CYCLE, 0)
                          and b.DATE BETWEEN case when date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -14 month) > '2016-01-01' then date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -14 month) else '2016-01-01' end and date_add(date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -1 month), interval -1 day)
                        WHERE a.FREQUENCY in ('C', 'M') 
                          and a.START_DATE <= t.DATE
                          and a.RELEVANT = 'Y' 
                          and t.DATE BETWEEN date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -14 month) AND date_add(date_add(DATE_FORMAT(NOW() ,'%Y-%m-01'), interval -1 month), interval -1 day)
                          and a.OPCO_ID = ?
                          and a.IMPLEMENTED like ?
                        GROUP BY t.DATE,
                          a.OPCO_ID,
                          a.METRIC_ID,
                          c.BILL_CYCLE                
                  ) v
                  group by substr(DATE, 1, 7), OPCO_ID
              ) sub1
              order by 1 desc`,
          [req.query.opcoId, req.query.finetuneFilter], 
          function(err, row) {
            if(err !== null) {
              console.log(err);
              next(err);
            }
            else {
              res.json(row);
            }
          });
        }
    }      
}


export function deleteIdFromTable(req, res, next) {

if (req.params.table === 'system')
    db.query("delete from AMX_SYSTEM where system_id = ?", 
      [req.query.id], function (err, row) {
      if(err !== null) {
        console.log(err);
        res.json({success: false, error: err});
      }
      else {
        res.json({success: true});
      }
    });

  if (req.params.table === 'contact')
    db.query("delete from AMX_CONTACT where contact_id = ?", 
      [req.query.id], function (err, row) {
      if(err !== null) {
        console.log(err);
        res.json({success: false, error: err});
      }
      else {
        res.json({success: true});
      }
    });

  if (req.params.table === 'cycle')
    db.query("delete from AMX_BILL_CYCLE where bill_cycle_id = ?", 
      [req.query.id], function (err, row) {
      if(err !== null) {
        console.log(err);
        res.json({success: false, error: err});
      }
      else {
        res.json({success: true});
      }
    });

}