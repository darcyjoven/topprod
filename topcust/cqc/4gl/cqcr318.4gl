# Prog. Version..:
#
# Pattern name...: cqcr318.4gl
# Descriptions...: 料件分类良率打印
# Date & Author..: 22/07/04 By darcy
#HFBG-16030001
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD                               
              wc      LIKE type_file.chr1000,      
              more    LIKE type_file.chr1   
              END RECORD  

DEFINE tm1 RECORD  
                   imz02    LIKE type_file.chr20,
                   bdate    LIKE type_file.dat,
                   edate    LIKE type_file.dat 
            END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_i             LIKE type_file.num5       
DEFINE   g_msg           LIKE type_file.chr1000   
 
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CQC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql="imz02.type_file.chr20,",
             "goodrate1.type_file.chr20,",
             "goodlot1.type_file.num15_3,",
             "badlot1.type_file.num15_3,",
             "goodrate2.type_file.chr20,",
             "goodlot2.type_file.num15_3,",
             "badlot2.type_file.num15_3,",
             "goodrate3.type_file.chr20,",
             "goodlot3.type_file.num15_3,",
             "badlot3.type_file.num15_3,",
             "goodrate4.type_file.chr20,",
             "goodlot4.type_file.num15_3,",
             "badlot4.type_file.num15_3,",
             "goodrate5.type_file.chr20,",
             "goodlot5.type_file.num15_3,",
             "badlot5.type_file.num15_3,",
             "goodrate6.type_file.chr20,",
             "goodlot6.type_file.num15_3,",
             "badlot6.type_file.num15_3,",
             "goodrate7.type_file.chr20,",
             "goodlot7.type_file.num15_3,",
             "badlot7.type_file.num15_3,",
             "goodrate8.type_file.chr20,",
             "goodlot8.type_file.num15_3,",
             "badlot8.type_file.num15_3,",
             "goodrate9.type_file.chr20,",
             "goodlot9.type_file.num15_3,",
             "badlot9.type_file.num15_3,",
             "goodrate10.type_file.chr20,",
             "goodlot10.type_file.num15_3,",
             "badlot10.type_file.num15_3,",
             "goodrate11.type_file.chr20,",
             "goodlot11.type_file.num15_3,",
             "badlot11.type_file.num15_3,",
             "goodrate12.type_file.chr20,",
             "goodlot12.type_file.num15_3,",
             "badlot12.type_file.num15_3,"


   LET  l_table = cl_prt_temptable('cqcr318',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   INITIALIZE tm.* TO NULL         
   LET g_pdate = ARG_VAL(1)       
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11) 
   
   IF cl_null(tm.wc)
      THEN CALL cqcr318_tm(0,0)          
      ELSE
           CALL cqcr318()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION cqcr318_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000 
DEFINE l_n   LIKE type_file.num5
DEFINE l_imz02_value,l_imz02_items STRING
define l_imz02 LIKE type_file.chr20
DEFINE l_cnt    like type_file.num5
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW cqcr318_w AT p_row,p_col WITH FORM "cqc/42f/cqcr318"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET tm1.bdate = g_today
   LET tm1.edate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 

    DECLARE r318_cur_imz02 CURSOR FOR 
        SELECT UNIQUE imz02 FROM darcy_imz where imz02 is not null 
    let l_imz02_value = ""
    let l_imz02_items = "" 
    let l_cnt = 1
    FOREACH r318_cur_imz02 INTO l_imz02 
        if cl_null(l_imz02_value) then
            let l_imz02_value = l_imz02
            let l_imz02_items = l_cnt,".",l_imz02
        else 
            let l_imz02_value = l_imz02_value clipped,",",l_imz02 clipped
            let l_imz02_items = l_imz02_items clipped,",",l_cnt,".",l_imz02 clipped
        end if  
        let l_cnt = l_cnt + 1
    END FOREACH 
    CALL cl_set_combo_items("imz02",l_imz02_value,l_imz02_items)
 
   CALL cl_opmsg('p')
WHILE TRUE
  
  #UI
   INPUT BY NAME tm1.imz02,tm1.bdate,tm1.edate  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        
        
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW cqcr318_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cqcr318'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cqcr318','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc,'\\\"', "'")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,            #MOD-650024 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('cqcr318',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cqcr318_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cqcr318()
   ERROR ""
END WHILE
   CLOSE WINDOW cqcr318_w
END FUNCTION


FUNCTION cqcr318()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     STRING,       #No.FUN-680137 VARCHAR(3000)
          l_sql1    LIKE type_file.chr1000,
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_zo041   LIKE zo_file.zo041,   #FUN-810029 add
          l_zo042   LIKE zo_file.zo042,
          l_zo05    LIKE zo_file.zo05,     #FUN-810029 add
          l_zo09    LIKE zo_file.zo09,     #FUN-810029 add
          sr        RECORD
                imz02     LIKE type_file.chr20, 
                goodrate ARRAY [12] OF varchar(20),
                goodlot  ARRAY [12] OF decimal(15,3),
                badlot   ARRAY [12] OF decimal(15,3)
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_start   LIKE type_file.chr20
   DEFINE l_end     LIKE type_file.chr20   

   DEFINE l_price LIKE ogb_file.ogb13

   DEFINE l_img_blob     LIKE type_file.blob
   DEFINE l_month        LIKE type_file.chr20
   define l_imz02        like type_file.chr20
   define l_yy,l_mm,l_moncnt      like type_file.num5
   define l_yy1,l_mm1      like type_file.num5
   LOCATE l_img_blob IN MEMORY             

 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='cqcr318'

    let l_sql = "SELECT CASE  WHEN YEAR(?)=YEAR(?) THEN MONTH(?)-MONTH(?)+1
                              WHEN YEAR(?)!=YEAR(?) THEN (YEAR(?)-YEAR(?))*12+MONTH(?)-MONTH(?)+1 
                        ELSE 0 END FROM dual" 
    prepare r318_cur_moncnt from l_sql 

    execute r318_cur_moncnt 
      using tm1.edate,tm1.bdate,tm1.edate,tm1.bdate,tm1.edate,tm1.bdate,tm1.edate,tm1.bdate,tm1.edate,tm1.bdate
      into l_moncnt
    if sqlca.sqlcode then
        call cl_err("r318_cur_moncnt",sqlca.sqlcode,1)
        return
    end if 

    if l_moncnt >12 then
        call cl_err("此报表每次只能查询12个月份的资料，请重新录入查询区间","!",1)
        return
    end if

    let l_sql = "select year(?),month(?) from dual"
    prepare r318_cur_ym from l_sql 

    execute r318_cur_ym using tm1.bdate,tm1.bdate into l_yy,l_mm
    if sqlca.sqlcode then
        call cl_err("r318_cur_ym",sqlca.sqlcode,1)
        return
    end if

    let l_sql = "SELECT RTrim(To_Char(ROUND( (SUM(合格)/(SUM(合格)+SUM(不合格)))*100,2), 'FM99999999990.9999'), '.')||'%' 合格率批次,SUM(合格) 合格 ,SUM(不合格) 不合格
                FROM (
                SELECT  imz02,
                CASE qcs09 WHEN '1' THEN qcsud03 ELSE 0 END 合格,
                CASE qcs09 WHEN '2' THEN qcsud03 ELSE 0 END 不合格
                FROM (
                SELECT NVL(imz02,'其它') imz02,qcs09,COUNT(qcsud03) qcsud03
                FROM qcs_file 
                LEFT JOIN ima_file ON ima01 = qcs021
                LEFT JOIN darcy_imz ON imz01 = ima06
                WHERE YEAR(qcs04) = ? AND MONTH(qcs04)=? 
                GROUP BY imz02,qcs09
                ) WHERE imz02 =? ) "

    prepare r318_cur_f from l_sql 
    declare r318_cur_fetch cursor for r318_cur_f 

    DECLARE r318_cur_imz CURSOR FOR 
        SELECT UNIQUE imz02 FROM darcy_imz where imz02 is not null
    
    foreach r318_cur_imz into sr.imz02 
        call sr.goodrate.clear()
        call sr.goodlot.clear()
        call sr.badlot.clear()
        let l_yy1 = l_yy
        let l_mm1 = l_mm
        for l_cnt = 1 to l_moncnt 
            execute r318_cur_fetch using l_yy1,l_mm1,sr.imz02 into sr.goodrate[l_cnt],sr.goodlot[l_cnt],sr.badlot[l_cnt]
            if sqlca.sqlcode then
                call cl_err("r318_cur_fetch",sqlca.sqlcode,1)
                return
            end if
            if l_mm1 <12 then
                let l_mm1=  l_mm1 + 1
            else
                let l_yy1 = l_yy1 + 1
                let l_mm1 = l_mm1 = 1
            end if
        end for
        EXECUTE insert_prep USING sr.imz02,
                                  sr.goodrate[1],sr.goodlot[1],sr.badlot[1],
                                  sr.goodrate[2],sr.goodlot[2],sr.badlot[2],
                                  sr.goodrate[3],sr.goodlot[3],sr.badlot[3],
                                  sr.goodrate[4],sr.goodlot[4],sr.badlot[4],
                                  sr.goodrate[5],sr.goodlot[5],sr.badlot[5],
                                  sr.goodrate[6],sr.goodlot[6],sr.badlot[6],
                                  sr.goodrate[7],sr.goodlot[7],sr.badlot[7],
                                  sr.goodrate[8],sr.goodlot[8],sr.badlot[8],
                                  sr.goodrate[9],sr.goodlot[9],sr.badlot[9],
                                  sr.goodrate[10],sr.goodlot[10],sr.badlot[10],
                                  sr.goodrate[11],sr.goodlot[11],sr.badlot[11],
                                  sr.goodrate[12],sr.goodlot[12],sr.badlot[12]
        if sqlca.sqlcode then
            call cl_err("insert_prep",sqlca.sqlcode,1)
            return
        end if
    end foreach
   
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    IF g_zz05='Y' THEN
       CALL cl_wcchp(tm.wc,'qcs021')
            RETURNING tm.wc
    END IF
    LET g_str = tm.wc,";",l_yy,";",l_mm
    CALL cl_prt_cs3('cqcr318','cqcr318',g_sql,g_str)

END FUNCTION
