# Prog. Version..:
#
# Pattern name...: cqcr002.4gl
# Descriptions...: 送货单打印
# Date & Author..: 16/03/03 By yaolf
#HFBG-16030001
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD                               
              wc      LIKE type_file.chr1000,      
              more    LIKE type_file.chr1          
              END RECORD  
DEFINE tm1 RECORD  qcs04_start LIKE qcs_file.qcs04,
                   qcs04_end   LIKE qcs_file.qcs04
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
  
   LET g_sql="qcs04.qcs_file.qcs04,",
             "qcs01.qcs_file.qcs01,",
             "qcs02.qcs_file.qcs02,",
             "qcs05.qcs_file.qcs05,",
             "qcs021.qcs_file.qcs021,",

             "ima02.ima_file.ima02,",
             "qcs091.qcs_file.qcs091,",
             "qcs09.qcs_file.qcs09,",
             "qcs22.qcs_file.qcs22,",
             "qcu04.qcu_file.qcu04,",

             "qce03.qce_file.qce03,",
             "sum1.type_file.num5,",
             "sum2.type_file.num5,",
             "sum3.type_file.num5,",
             "sum4.type_file.num5,",

             "pmc03.pmc_file.pmc03"
             
  
   LET  l_table = cl_prt_temptable('cqcr002',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"                     
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   CALL r002_table()
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
      THEN CALL cqcr002_tm(0,0)          
      ELSE
           CALL cqcr002()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION cqcr002_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW cqcr002_w AT p_row,p_col WITH FORM "cqc/42f/cqcr002"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON qcs021
     
         BEFORE CONSTRUCT
             CALL cl_qbe_init() 
 
       ON ACTION locale 
          CALL cl_show_fld_cont()                    
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION controlp
           CASE
              WHEN INFIELD(oga01)
                 WHEN INFIELD(qcs021)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO qcs021
                 NEXT FIELD qcs021
                OTHERWISE
                 EXIT CASE
           END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         
         ON ACTION qbe_select
            CALL cl_qbe_select()
         
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW cqcr002_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
  
  #UI
  LET tm1.qcs04_start=g_today   
  LET tm1.qcs04_end=g_today
   INPUT BY NAME tm1.qcs04_start,tm1.qcs04_end  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 --
      --AFTER FIELD more
         --IF tm.more = 'Y'
            --THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                --g_bgjob,g_time,g_prtway,g_copies)
                      --RETURNING g_pdate,g_towhom,g_rlang,
                                --g_bgjob,g_time,g_prtway,g_copies
         --END IF
    AFTER FIELD qcs04_end
        IF tm1.qcs04_start > tm1.qcs04_end THEN 
        CALL cl_err('','hlf01',0)
        NEXT FIELD qcs04_end
        END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW cqcr002_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cqcr002'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cqcr002','9031',1)
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
         CALL cl_cmdat('cqcr002',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cqcr002_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cqcr002()
   ERROR ""
END WHILE
   CLOSE WINDOW cqcr002_w
END FUNCTION


FUNCTION cqcr002()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_sql1    LIKE type_file.chr1000,
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_zo041   LIKE zo_file.zo041,   #FUN-810029 add
          l_zo042   LIKE zo_file.zo042,
          l_zo05    LIKE zo_file.zo05,     #FUN-810029 add
          l_zo09    LIKE zo_file.zo09,     #FUN-810029 add
          sr        RECORD
                    qcs04    LIKE qcs_file.qcs04,   #检验日期
                    qcs01    LIKE qcs_file.qcs01,   #收货单号
                    qcs02    LIKE qcs_file.qcs02,   #项次
                    qcs05    LIKE qcs_file.qcs05,   #分批顺序
                    qcs021   LIKE qcs_file.qcs021,  #料件编号

                    ima02    LIKE ima_file.ima02,   #品名
                    qcs091   LIKE qcs_file.qcs091,  #合格数量
                    qcs09    LIKE qcs_file.qcs09,   #判定结果
                    qcs22    LIKE qcs_file.qcs22,   #检验量
                    qcu04    LIKE qcu_file.qcu04,   #不良原因

                    qce03    LIKE qce_file.qce03,   #说明
                    sum1     LIKE type_file.num5,   #总检验批次
                    sum2     LIKE type_file.num5,   #不良批次数
                    sum3     LIKE qcs_file.qcs22,   #检测数量
                    sum4     LIKE qcs_file.qcs22,   #不良数量

                    pmc03    LIKE pmc_file.pmc03
                    
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5            

   DEFINE l_price LIKE ogb_file.ogb13

   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY             
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='cqcr002' 
 
     LET tm.wc = tm.wc CLIPPED 
     LET sr.sum1 =0
     LET sr.sum2=0
     LET sr.sum3=0
     LET sr.sum4=0
     
   #公司全名zo02、公司地址zo041、公司電話zo05、公司傳真zo09
   LET l_zo041 = NULL  LET l_zo05 = NULL  LET l_zo09 = NULL

DELETE FROM cqcr002_tmp
LET l_sql="select qcs04,qcs01,qcs02,qcs05,qcs021,ima02,qcs091,qcs09,qcs22,'','',0,0,0,0,pmc03",
           " from qcs_file ",
           " LEFT JOIN ima_file ON ima01 = qcs021 ",
           " LEFT JOIN pmc_file ON pmc01 = qcs03  ",
           " WHERE ", tm.wc CLIPPED," AND qcs04 between to_date('",tm1.qcs04_start,"','yy/mm/dd') and to_date('",tm1.qcs04_end,"','yy/mm/dd')",
           " AND qcs09 in('2','3')"
LET l_sql1 = " INSERT INTO cqcr002_tmp ",l_sql CLIPPED
PREPARE r002_ins FROM l_sql1
EXECUTE r002_ins

   
# sum1 总批次数
   LET l_sql="UPDATE cqcr002_tmp  set sum1= (select count(*) from qcs_file where",
   tm.wc CLIPPED," AND qcs04 between to_date('",tm1.qcs04_start,"','yy/mm/dd') and to_date('",tm1.qcs04_end,"','yy/mm/dd'))"
   PREPARE q002_pre5 FROM l_sql
   EXECUTE q002_pre5
   
# sum2 不良批次数
 LET l_sql="UPDATE cqcr002_tmp  set sum2= (select count(*) from qcs_file where",
   tm.wc CLIPPED," AND qcs04 between to_date('",tm1.qcs04_start,"','yy/mm/dd') and to_date('",tm1.qcs04_end,"','yy/mm/dd')",
   "and qcs09 in('2','3'))"
   PREPARE q002_pre0 FROM l_sql
   EXECUTE q002_pre0

# sum3 检测数量
     LET l_sql = " MERGE INTO cqcr002_tmp o ",
               "      USING (select qcs01,sum(qcs22) sum3 from cqcr002_tmp ",
              " GROUP BY qcs01 ",
               "        ) n ",
               "         ON (o.qcs01 = n.qcs01  ) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.sum3= n.sum3 "
   PREPARE q200_pre1 FROM l_sql
   EXECUTE q200_pre1
   
# sum4 数量
        LET l_sql = " MERGE INTO cqcr002_tmp o ",
               "      USING (select qcs01,sum(qcs22) sum4 from cqcr002_tmp  ",
              " GROUP BY qcs01 ",
               "        ) n ",
               "         ON (o.qcs01 = n.qcs01  ) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.sum4= n.sum4 "
   PREPARE q200_pre2 FROM l_sql
   EXECUTE q200_pre2

# 不良描述
         LET l_sql = " MERGE INTO cqcr002_tmp o ",
               "      USING (select qcs01, to_char(wmsys.wm_concat(qce03)) qce03 from qcs_file ",
               " LEFT JOIN qcu_file ON qcu01 = qcs01 AND qcu02 = qcs02 AND qcs05 = qcu021 ",
               " LEFT JOIN ima_file ON ima01 = qcs021 ",
               ",qce_file", 
               " WHERE qcu04 = qce01 and ", tm.wc CLIPPED," AND qcs04 between to_date('",tm1.qcs04_start,"','yy/mm/dd') and to_date('",tm1.qcs04_end,"','yy/mm/dd')",
               " GROUP BY qcs01 ",
               "        ) n ",
               "         ON (o.qcs01 = n.qcs01  ) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.qce03= n.qce03 "
   PREPARE q200_pre3 FROM l_sql
   EXECUTE q200_pre3

    LET l_sql = "SELECT * FROM cqcr002_tmp"
     PREPARE cqcr002_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE cqcr002_curs1 CURSOR FOR cqcr002_prepare1
 
     FOREACH cqcr002_curs1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF      
       EXECUTE insert_prep USING sr.*
     END FOREACH
    
  
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'qcs021')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc

     CALL cl_prt_cs3('cqcr002','cqcr002',g_sql,g_str)

END FUNCTION


FUNCTION r002_table()
  DROP TABLE cqcr002_tmp
  CREATE TEMP TABLE cqcr002_tmp(
                    qcs04    LIKE qcs_file.qcs04,   
                    qcs01    LIKE qcs_file.qcs01,   
                    qcs02    LIKE qcs_file.qcs02,   
                    qcs05    LIKE qcs_file.qcs05,   
                    qcs021   LIKE qcs_file.qcs021,  
                    ima02    LIKE ima_file.ima02,  
                    qcs091   LIKE qcs_file.qcs091,  
                    qcs09    LIKE qcs_file.qcs09,   
                    qcs22    LIKE qcs_file.qcs22,   
                    qcu04    LIKE qcu_file.qcu04,  
                    qce03    LIKE qce_file.qce03,   
                    sum1     LIKE type_file.num5,   
                    sum2     LIKE type_file.num5,  
                    sum3     LIKE qcs_file.qcs22,  
                    sum4     LIKE qcs_file.qcs22,
                    pmc03    LIKE pmc_file.pmc03 )   
                   
                                    
		
END FUNCTION



