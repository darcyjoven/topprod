# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: admr123.4gl
# Descriptions...: 銷退次數金額分析
# Input parameter:
# Date & Author..: 09/01/05 By jan
# Modify.........: No.FUN-760009 09/01/14 By jan過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A70180 10/07/23 By Sarah 權限控管段抓取的欄位fakuser與fakgrup應改為ohauser與ohagrup
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				        # Print condition RECORD
              wc     STRING,                            # Where Condition  
              bdate  LIKE type_file.dat,
              edate  LIKE type_file.dat,
              s      LIKE type_file.chr3,
              t      LIKE type_file.chr3,
              u      LIKE type_file.chr3,
              more   LIKE type_file.chr1                # 特殊列印條件       #No.FUN-680097 VARCHAR(01) 
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
 
#No.FUN-760005 --start--
DEFINE g_sql    STRING
DEFINE l_table  STRING
DEFINE g_str    STRING
#No.FUN-760005 --end--
          
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ADM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690111
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  
   LET tm.s     = ARG_VAL(14)
   LET tm.t     = ARG_VAL(15)
   LET tm.u     = ARG_VAL(16)   
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
   
   LET g_sql = "ima131.ima_file.ima131,",
               "ohb50.ohb_file.ohb05,",
               "oak02.oak_file.oak02,",
               "aa.type_file.num10,",
               "omb16.omb_file.omb16,",
               "azi04.azi_file.azi04,",
               "oha03.oha_file.oha03"
   LET  l_table = cl_prt_temptable('admr123',g_sql) CLIPPED 
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES (?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r123_tm(0,0)	
      ELSE CALL r123()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r123_tm(p_row,p_col)
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   
   DEFINE p_row,p_col	LIKE type_file.num5,
          l_cmd		    LIKE type_file.chr1000 
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 11 END IF
   OPEN WINDOW r123_w AT p_row,p_col
        WITH FORM "adm/42f/admr123"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
   LET tm.s ='123'
   LET tm.t ='Y  '
   LET tm.u ='Y  '
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON oha03,ima131,ohb50
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
     
     ON ACTION CONTROLP
        IF INFIELD(oha03) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.state = "c"
           LET g_qryparam.form ="q_occ"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO oha03
        END IF
        IF INFIELD(ima131) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.state = "c"
           LET g_qryparam.form ="q_oca"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO ima131
        END IF
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r123_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.bdate,tm.edate,tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
            NEXT FIELD bdate
         END IF
 
      AFTER FIELD edate
         IF cl_null(tm.edate) OR (tm.bdate>tm.edate) THEN
            NEXT FIELD edate
         END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES'[YN]' THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3 
         
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
      LET INT_FLAG = 0
      CLOSE WINDOW r123_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='admr123'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('admr123','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", 
                         " '",g_rlang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'", 
                         " '",g_rep_clas CLIPPED,"'", 
                         " '",g_template CLIPPED,"'", 
                         " '",g_rpt_name CLIPPED,"'", 
                         " '",tm.s CLIPPED,"'" ,
                         " '",tm.t CLIPPED,"'" ,
                         " '",tm.u CLIPPED,"'" 
         CALL cl_cmdat('admr123',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r123_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r123()
   ERROR ""
END WHILE
   CLOSE WINDOW r123_w
END FUNCTION
 
FUNCTION r123()
   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name       
          l_sql      LIKE type_file.chr1000,  # RDSQL STATEMENT
          l_za05     LIKE type_file.chr1000, 
          l_ima131    LIKE    ima_file.ima131, 
          l_ohb50     LIKE    ohb_file.ohb50,  
          l_oha03     LIKE    oha_file.oha03,
          l_aa        LIKE type_file.num10,               
          l_omb16     LIKE    omb_file.omb16, 
          l_tmp_aa        LIKE type_file.num10,
          l_tmp_omb16     LIKE    omb_file.omb16, 
          l_oak02     LIKE    oak_file.oak02, 
          
          sr         RECORD
                     ima131    LIKE    ima_file.ima131,   #產品分類
                     ohb50     LIKE    ohb_file.ohb50,    #銷退理由
                     oak02     LIKE    oak_file.oak02,    #理由說明
                     aa        LIKE    type_file.num10,   #次數 
                     bb        LIKE    ala_file.ala21,    #次數百分比
                     omb16     LIKE    omb_file.omb16,    #銷退本幣金額
                     cc        LIKE    ala_file.ala21     #銷退百分比
                     END RECORD
 
     CALL cl_del_data(l_table)  #No.FUN-760005
    
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='admr123' 
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fakuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
    #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fakuser', 'fakgrup')  #MOD-A70180 mark
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ohauser', 'ohagrup')  #MOD-A70180
     #End:FUN-980030
 
     LET l_sql = " SELECT ima131,ohb50,oha03,count(*),SUM(omb16) ",
                 " FROM oha_file,ohb_file,oma_file,omb_file,ima_file",
                 " WHERE oma00 ='21' AND oha01=ohb01 AND oma01=omb01",
                 "  AND  ohb01=omb31 AND ohb03=omb32 AND ohb04=ima01",
                 "  AND  oha02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "  AND  ohaconf='Y' AND ohapost='Y' AND omaconf='Y' ",
                 "  AND  omavoid='N' AND ",tm.wc CLIPPED,
                 "  GROUP BY ima131,ohb50,oha03 "
 
 
     PREPARE r123_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)   
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE r123_c1 CURSOR FOR r123_p1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     
 
     LET g_pageno = 0
     FOREACH r123_c1 INTO l_ima131,l_ohb50,l_oha03,l_aa,l_omb16
       IF SQLCA.SQLCODE THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       #No.FUN-760005 --start--
       LET l_oak02 = ""
       SELECT oak02 INTO l_oak02 FROM oak_file WHERE oak01=l_ohb50
       #INSERT INTO admr123_tmp VALUES (l_ima131,l_ohb50,l_aa,l_omb16)
       EXECUTE insert_prep USING l_ima131,l_ohb50,l_oak02,l_aa,l_omb16,t_azi04,l_oha03
       #No.FUN-760005 --end--
     END FOREACH
 
     #--將暫存檔的資料丟到sr列印
     #No.FUN-760005 --start--
     #DECLARE r122_temp CURSOR FOR
     # SELECT tmp_ima131,tmp_ohb50,' ',tmp_aa,0,tmp_omb16,0 FROM admr122_tmp
     #FOREACH r122_temp INTO sr.*
     #  IF STATUS THEN CALL cl_err('foreach temp',STATUS,0) EXIT FOREACH END IF
     #  SELECT SUM(tmp_aa),SUM(tmp_omb16) INTO l_tmp_aa,l_tmp_omb16 FROM admr122_tmp
     #  IF cl_null(l_tmp_aa) OR l_tmp_aa=0 THEN
     #      LET sr.bb=0
     #  ELSE
     #      LET sr.bb=sr.aa/l_tmp_aa*100
     #  END IF
     #  IF  cl_null(l_tmp_omb16) OR l_tmp_omb16=0 THEN
     #      LET sr.cc=0
     #  ELSE
     #      LET sr.cc=sr.omb16/l_tmp_omb16*100
     #  END IF
     #  
     #  SELECT oak02 INTO sr.oak02 FROM oak_file
     #   WHERE oak01=sr.ohb50
     #  OUTPUT TO REPORT r122_rep(sr.*)
     #END FOREACH
     #No.FUN-760005 --end--
 
     #No.FUN-760005 --start--
     #FINISH REPORT r122_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'oha03,ima131,ohb50')
             RETURNING g_str
     END IF
     IF cl_null(tm.s[1,1]) THEN LET tm.s[1,1] = '0' END IF  
     IF cl_null(tm.s[2,2]) THEN LET tm.s[2,2] = '0' END IF  
     IF cl_null(tm.s[3,3]) THEN LET tm.s[3,3] = '0' END IF
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u 
     CALL cl_prt_cs3('admr123','admr123',g_sql,g_str)
     #No.FUN-760005 --end--
END FUNCTION
#FUN-760009
