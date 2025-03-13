# Prog. Version..:
#
# Pattern name...: cqcr319.4gl
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
                   qcs03    LIKE type_file.chr20,
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
  
   LET g_sql= "qcs03.qcs_file.qcs03,",
              "pmc03.pmc_file.pmc03,",
              "pmc081.pmc_file.pmc081,",
              "goodbatch.type_file.num15_3,",
              "badbatch.type_file.num15_3,",
              "goodbatchrate.type_file.chr20," ,
              "goodcnt.type_file.num15_3,",
              "badcnt.type_file.num15_3,",
              "goodcntrate.type_file.chr20"


   LET  l_table = cl_prt_temptable('cqcr319',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?)"
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
      THEN CALL cqcr319_tm(0,0)          
      ELSE
           CALL cqcr319()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION cqcr319_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000 
DEFINE l_n   LIKE type_file.num5
DEFINE l_imz02_value,l_imz02_items STRING
define l_imz02 LIKE type_file.chr20
DEFINE l_cnt    like type_file.num5
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW cqcr319_w AT p_row,p_col WITH FORM "cqc/42f/cqcr319"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET tm1.bdate = g_today
   LET tm1.edate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 

   #  DECLARE r319_cur_imz02 CURSOR FOR 
   #      SELECT UNIQUE imz02 FROM darcy_imz where imz02 is not null 
   #  let l_imz02_value = ""
   #  let l_imz02_items = "" 
   #  let l_cnt = 1
   #  FOREACH r319_cur_imz02 INTO l_imz02 
   #      if cl_null(l_imz02_value) then
   #          let l_imz02_value = l_imz02
   #          let l_imz02_items = l_cnt,".",l_imz02
   #      else 
   #          let l_imz02_value = l_imz02_value clipped,",",l_imz02 clipped
   #          let l_imz02_items = l_imz02_items clipped,",",l_cnt,".",l_imz02 clipped
   #      end if  
   #      let l_cnt = l_cnt + 1
   #  END FOREACH 
   #  CALL cl_set_combo_items("imz02",l_imz02_value,l_imz02_items)
 
   CALL cl_opmsg('p')
WHILE TRUE
  
  #UI
   INPUT BY NAME tm1.qcs03,tm1.bdate,tm1.edate  WITHOUT DEFAULTS
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
      LET INT_FLAG = 0 CLOSE WINDOW cqcr319_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cqcr319'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cqcr319','9031',1)
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
         CALL cl_cmdat('cqcr319',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cqcr319_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cqcr319()
   ERROR ""
END WHILE
   CLOSE WINDOW cqcr319_w
END FUNCTION


FUNCTION cqcr319()
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
              qcs03  like qcs_file.qcs03,
              pmc03  like pmc_file.pmc03,
              pmc081  like pmc_file.pmc081,
              goodbatch like type_file.num15_3,
              badbatch  like type_file.num15_3,
              goodbatchrate like type_file.chr20,
              goodcnt like type_file.num15_3,
              badcnt like type_file.num15_3,
              goodcntrate like type_file.chr20
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

    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='cqcr319' 
    let l_sql = "SELECT qcs03,pmc03,pmc081,SUM(合格),SUM(不合格),  
                  RTrim(To_Char(ROUND( (SUM(合格)/(SUM(合格)+SUM(不合格)))*100,2), 'FM99999999990.9999'), '.')||'%',
                  SUM(合格数量),SUM(不合格数量),
                  RTrim(To_Char(ROUND( (SUM(合格数量)/(SUM(合格数量)+SUM(不合格数量)))*100,2), 'FM99999999990.9999'), '.')||'%'
                  FROM (
                  SELECT qcs03,pmc03,pmc081, 
                  CASE qcs09 WHEN '1' THEN qcsud03 ELSE 0 END 合格,
                  CASE qcs09 WHEN '2' THEN qcsud03 ELSE 0 END 不合格, 
                  CASE qcs09 WHEN '1' THEN qcs22 ELSE 0 END 合格数量,
                  CASE qcs09 WHEN '2' THEN qcs22 ELSE 0 END 不合格数量  
                  FROM (
                  SELECT qcs03,qcs09,COUNT(qcs01) qcsud03 ,SUM(qcs22) qcs22 FROM qcs_file
                  WHERE qcs04 BETWEEN ? AND ? "
    if not cl_null(tm1.qcs03) then
      let l_sql = l_sql , " and qcs03 =  '",tm1.qcs03,"'"
    end if 
    let l_sql = l_sql ," GROUP BY qcs03,qcs09 )
                  LEFT JOIN pmc_file ON pmc01 = qcs03 )
                  GROUP BY qcs03,pmc03,pmc081
                  ORDER BY 4 DESC ,7 DESC  "

    prepare r319_cur_f from l_sql 
    declare r319_cur_p cursor for r319_cur_f  
    
    foreach r319_cur_p 
      using tm1.bdate,tm1.edate into  sr.* 
        EXECUTE insert_prep USING sr.*
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
    LET g_str = tm.wc,";"
    CALL cl_prt_cs3('cqcr319','cqcr319',g_sql,g_str)

END FUNCTION
