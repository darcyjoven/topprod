# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axrr410.4gl
# Descriptions...: 收款沖帳清單
# Date & Author..: 95/02/13 By Danny
# Modify.........: No.FUN-4C0100 04/12/29 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-5B0133 05/11/14 By COCO 加上sr.order的說明
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: NO.FUN-840051 08/04/14 By zhaijie 報表輸出改為CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20014 11/02/12 By lilingyu SQL增加ooa37='1'的條件
# Modify.........: No.FUN-C40001 12/04/13 By yinhy 增加開窗功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,
           s       LIKE type_file.chr3,             #No.FUN-680123 VARCHAR(03)
           t       LIKE type_file.chr3,             #No.FUN-680123 VARCHAR(03)
           u       LIKE type_file.chr3,             #No.FUN-680123 VARCHAR(03)
           a       LIKE type_file.chr1,             #No.FUN-680123 VARCHAR(1)
           more    LIKE type_file.chr1              #No.FUN-680123 VARCHAR(01)
           END RECORD,
          g_amt1   LIKE type_file.num20_6,          #No.FUN-680123 DEC(20,6)
          g_amt2   LIKE type_file.num20_6,          #No.FUN-680123 DEC(20,6)
          g_orderA ARRAY[2] OF LIKE ooa_file.ooa03  #No.FUN-680123 ARRAY[2] OF VARCHAR(10) 
 
DEFINE   g_i       LIKE type_file.num5              #count/index for any purpose #No.FUN-680123 SMALLINT
#NO.FUN-840051----START-----
   DEFINE g_sql           STRING
   DEFINE g_str           STRING
   DEFINE l_table         STRING
#NO.FUN-840051----END-----
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
#NO.FUN-840051----START-----
   LET g_sql = "ooa01.ooa_file.ooa01,",
               "ooa02.ooa_file.ooa02,",
               "ooa15.ooa_file.ooa15,",
               "ooa03.ooa_file.ooa03,",
               "ooa032.ooa_file.ooa032,",
               "oob03.oob_file.oob03,",
               "oob04.oob_file.oob04,",
               "oob05.oob_file.oob05,",
               "oob06.oob_file.oob06,",
               "oob07.oob_file.oob07,",
               "oob08.oob_file.oob08,",
               "oob09.oob_file.oob09,",
               "oob10.oob_file.oob10,",
               "oob12.oob_file.oob12,",
               "l_gem02.gem_file.gem02,",
               "l_str.type_file.chr8,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "azi07.azi_file.azi07"
   LET l_table = cl_prt_temptable('axrr410',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF         
#NO.FUN-840051----END-----
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.a  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
     #No.FUN-680123 begin
   CREATE TEMP TABLE r410_tmp_1       
   ( tmp01 LIKE azi_file.azi01,
     tmp02 LIKE type_file.chr1,  
     tmp03 LIKE type_file.num20_6,
     tmp04 LIKE type_file.num20_6)
   CREATE TEMP TABLE r410_tmp_2       
   ( tot01 LIKE azi_file.azi01,
     tot02 LIKE type_file.chr1,  
     tot03 LIKE type_file.num20_6,
     tot04 LIKE type_file.num20_6)
   CREATE TEMP TABLE r410_tmp_3       
   ( amt01 LIKE azi_file.azi01,
     amt02 LIKE type_file.chr1,  
     amt03 LIKE type_file.num20_6,
     amt04 LIKE type_file.num20_6)
        #No.FUN-680123 end 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r410_tm(0,0)
      ELSE CALL r410()
   END IF
   DROP TABLE r410_tmp_1
   DROP TABLE r410_tmp_2
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION r410_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680123 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 5 LET p_col = 18
   ELSE LET p_row = 5 LET p_col = 14
   END IF
 
   OPEN WINDOW r410_w AT p_row,p_col
        WITH FORM "axr/42f/axrr410"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.s    = '32'
   LET tm.t    = '  '
   LET tm.u    = 'YY'
   LET tm.a    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
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
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ooa01,ooa02,ooa15,ooa03
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
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

        #No.FUN-C40001  --Begin
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ooa01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ooa"
                 LET g_qryparam.arg1 = "1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa01
                 NEXT FIELD ooa01
              WHEN INFIELD(ooa03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa03
                 NEXT FIELD ooa03
              WHEN INFIELD(ooa15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa15
                 NEXT FIELD ooa15
              END CASE
        #No.FUN-C40001  --End
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r410_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,tm.a,tm.more
                 WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[123]' THEN NEXT FIELD a END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      ON ACTION CONTROLG CALL cl_cmdask()
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
      CLOSE WINDOW r410_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axrr410'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr410','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.a CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axrr410',g_time,l_cmd)
      END IF
      CLOSE WINDOW r410_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r410()
   ERROR ""
END WHILE
   CLOSE WINDOW r410_w
END FUNCTION
 
FUNCTION r410()
DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680123 VARCHAR(20) # External(Disk) file name
#       l_time       LIKE type_file.chr8        #No.FUN-6A0095
       l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-680123 VARCHAR(1000)
       l_za05    LIKE type_file.chr1000,      #No.FUN-680123 VARCHAR(40)
       l_order   ARRAY[5] OF LIKE type_file.chr20,        #No.FUN-680123 ARRAY[5] OF VARCHAR(20)
       sr        RECORD order1    LIKE type_file.chr20,   #No.FUN-680123 VARCHAR(20)
                        order2    LIKE type_file.chr20,   #No.FUN-680123 VARCHAR(20)
                        ooa01     LIKE ooa_file.ooa01,
                        ooa02     LIKE ooa_file.ooa02,
                        ooa15     LIKE ooa_file.ooa15,
                        ooa03     LIKE ooa_file.ooa03,
                        ooa032    LIKE ooa_file.ooa032,
                        oob03     LIKE oob_file.oob03,
                        oob04     LIKE oob_file.oob04,
                        oob05     LIKE oob_file.oob05,
                        oob06     LIKE oob_file.oob06,
                        oob07     LIKE oob_file.oob07,
                        oob08     LIKE oob_file.oob08,
                        oob09     LIKE oob_file.oob09,
                        oob10     LIKE oob_file.oob10,
                        oob12     LIKE oob_file.oob12,
                        azi03     LIKE azi_file.azi03,
                        azi04     LIKE azi_file.azi04,
                        azi05     LIKE azi_file.azi05,
                        azi07     LIKE azi_file.azi07
                        END RECORD,
             l_curr     LIKE csd_file.csd04      #No.FUN-680123 DECIMAL(7,4)
DEFINE       l_gem02     LIKE gem_file.gem02     #NO.FUN-840020
DEFINE       l_str       LIKE type_file.chr8     #NO.FUN-840020
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   CALL cl_del_data(l_table)                                    #NO.FUN-840051
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axrr410' #NO.FUN-840051
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN#只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ooauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ooagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ooagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ooauser', 'ooagrup')
     #End:FUN-980030
 
 
     DELETE FROM r410_tmp_2;     #no.5376
 
     LET l_sql = "SELECT '','',",
                 "     ooa01,ooa02,ooa15,ooa03,ooa032,oob03,oob04,oob05,",
                 "     oob06,oob07,oob08,oob09,oob10,oob12,azi03,azi04,azi05,azi07",
                 "  FROM ooa_file,oob_file,OUTER azi_file ",
                 " WHERE ooa01=oob01 ",
                 "   AND azi_file.azi01=oob_file.oob07 ",
                 "   AND ooaconf !='X' ",  #010803 增
                 "   AND ooa37 = '1'",     #FUN-B20014
                 "   AND ", tm.wc CLIPPED
 
     CASE WHEN tm.a = '1'   #已確認
             LET l_sql = l_sql CLIPPED," AND ooaconf = 'Y'"
          WHEN tm.a = '2'   #未確認
             LET l_sql = l_sql CLIPPED," AND ooaconf = 'N'"
          WHEN tm.a = '3'   #全部
	     LET l_sql= l_sql CLIPPED
     END CASE
     LET l_sql = l_sql CLIPPED," ORDER BY ooa01,ooa02,oob03"
     PREPARE r410_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE r410_curs1 CURSOR FOR r410_prepare1
#     CALL cl_outnam('axrr410') RETURNING l_name            #NO.FUN-840020
#     START REPORT r410_rep TO l_name                       #NO.FUN-840020
     LET g_pageno = 0 
     LET g_amt1 = 0
     LET g_amt2 = 0
     FOREACH r410_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
#NO.FUN-840051---START--MARK---        
#        FOR g_i = 1 TO 2
#            CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ooa01
#                                          LET g_orderA[g_i]= g_x[10]
#                 WHEN tm.s[g_i,g_i] = '2'
#                      LET l_order[g_i] = sr.ooa02 USING 'YYYYMMDD'
#                      LET g_orderA[g_i]= g_x[11]
#                 WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ooa15
#                                          LET g_orderA[g_i]= g_x[12]
#                 WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ooa03
#                                          LET g_orderA[g_i]= g_x[13]
#                 OTHERWISE LET l_order[g_i]  = '-'
#                           LET g_orderA[g_i] = ' '          #清為空白
#            END CASE
#        END FOR
#        LET sr.order1 = l_order[1]
#        LET sr.order2 = l_order[2]
#        OUTPUT TO REPORT r410_rep(sr.*)
#NO.FUN-840051---START--MARK--- 
#NO.FUN-840051---start---
      SELECT gem02 INTO l_gem02 FROM gem_file where gem01 = sr.ooa15
      CALL s_oob04(sr.oob03,sr.oob04) RETURNING l_str
      EXECUTE insert_prep USING 
        sr.ooa01,sr.ooa02,sr.ooa15,sr.ooa03,sr.ooa032,sr.oob03,sr.oob04,
        sr.oob05,sr.oob06,sr.oob07,sr.oob08,sr.oob09,sr.oob10,sr.oob12,
        l_gem02,l_str,sr.azi03,sr.azi04,sr.azi05,sr.azi07
#NO.FUN-840051-----end---
     END FOREACH
 
#     FINISH REPORT r410_rep                                #NO.FUN-840020
#NO.FUN-840051----START-----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ooa01,ooa02,ooa15,ooa03')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1],";",
                 tm.t[2,2],";",g_azi04,";",tm.u[1,1],";",tm.u[2,2],";",
                 g_azi05,";",tm.s[3,3],";",tm.t[3,3],";",tm.u[3,3]
     CALL cl_prt_cs3('axrr410','axrr410',g_sql,g_str) 
#NO.FUN-840051----END-----
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-840020
END FUNCTION
#NO.FUN-840020---MARK---START---
#REPORT r410_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1,                      #No.FUN-680123 VARCHAR(1)
#       g_head1      STRING,
#       sr        RECORD order1    LIKE type_file.chr20,       #No.FUN-680123 VARCHAR(20)
#                        order2    LIKE type_file.chr20,       #No.FUN-680123 VARCHAR(20)
#                        ooa01     LIKE ooa_file.ooa01,
#                        ooa02     LIKE ooa_file.ooa02,
#                        ooa15     LIKE ooa_file.ooa15,
#                        ooa03     LIKE ooa_file.ooa03,
#                        ooa032    LIKE ooa_file.ooa032,
#                        oob03     LIKE oob_file.oob03,
#                        oob04     LIKE oob_file.oob04,
#                        oob05     LIKE oob_file.oob05,
#                        oob06     LIKE oob_file.oob06,
#                        oob07     LIKE oob_file.oob07,
#                        oob08     LIKE oob_file.oob08,
#                        oob09     LIKE oob_file.oob09,
#                        oob10     LIKE oob_file.oob10,
#                        oob12     LIKE oob_file.oob12,
#                        azi03     LIKE azi_file.azi03,
#                        azi04     LIKE azi_file.azi04,
#                        azi05     LIKE azi_file.azi05,
#                        azi07     LIKE azi_file.azi07
#                        END RECORD,
#          st            RECORD
#                        tmp01     LIKE azi_file.azi01,        #No.FUN-680123 VARCHAR(04)
#                        tmp02     LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(01)
#                        tmp03     LIKE type_file.num20_6,     #No.FUN-680123 DEC(20,6)
#                        tmp04     LIKE type_file.num20_6      #No.FUN-680123 DEC(20,6)
#                        END RECORD,
#                l_tmp01     LIKE azi_file.azi01,              #No.FUN-680123 VARCHAR(04) 
#                l_n         LIKE type_file.num5,              #No.FUN-680123 SMALLINT
#		l_str       LIKE type_file.chr8,              #No.FUN-680123 VARCHAR(08)
#		l_amt_1     LIKE oob_file.oob09,
#		l_amt_2     LIKE oob_file.oob09,
#		l_amt_3     LIKE oob_file.oob09,
#		l_amt_4     LIKE oob_file.oob09,
#                l_gem02     LIKE gem_file.gem02
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.ooa01,sr.ooa02,sr.oob03
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      LET g_head1 = g_x[9] CLIPPED,g_orderA[1] CLIPPED,'-',g_orderA[2] CLIPPED
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
#            g_x[45]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      DELETE FROM r410_tmp_1
#      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#   BEFORE GROUP OF sr.order2
#      DELETE FROM r410_tmp_3
#      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#   BEFORE GROUP OF sr.ooa01
#       SELECT gem02 INTO l_gem02 FROM gem_file where gem01 = sr.ooa15
#       PRINT COLUMN g_c[31],sr.ooa01,
#             COLUMN g_c[32],sr.ooa02,
#             COLUMN g_c[33],sr.ooa15,
#             COLUMN g_c[34],l_gem02,
#             COLUMN g_c[35],sr.ooa03,
#             COLUMN g_c[36],sr.ooa032;
 
#   ON EVERY ROW
#      IF NOT cl_null(sr.oob07) THEN
#         INSERT INTO r410_tmp_1 VALUES(sr.oob07,sr.oob03,sr.oob09,sr.oob10)
#         INSERT INTO r410_tmp_2 VALUES(sr.oob07,sr.oob03,sr.oob09,sr.oob10)
#         INSERT INTO r410_tmp_3 VALUES(sr.oob07,sr.oob03,sr.oob09,sr.oob10)
#      END IF
#      CALL s_oob04(sr.oob03,sr.oob04) RETURNING l_str
#      PRINT COLUMN g_c[37],sr.oob03,
#            COLUMN g_c[38],l_str,
#            COLUMN g_c[39],sr.oob05,
#            COLUMN g_c[40],sr.oob06,
#            COLUMN g_c[41],sr.oob07,
#            COLUMN g_c[42],cl_numfor(sr.oob08,42,sr.azi07),
#            COLUMN g_c[43],cl_numfor(sr.oob09,43,sr.azi04),
#            COLUMN g_c[44],cl_numfor(sr.oob10,44,g_azi04),
#            COLUMN g_c[45],sr.oob12
#
#   AFTER GROUP OF sr.order1
#      IF tm.u[1,1] = 'Y' THEN
#         DECLARE r410_tmp CURSOR FOR SELECT UNIQUE(tmp01) FROM r410_tmp_1
#         FOREACH r410_tmp INTO l_tmp01
#          SELECT SUM(tmp03),SUM(tmp04) INTO st.tmp03,st.tmp04 FROM r410_tmp_1
#           WHERE tmp01=l_tmp01 AND tmp02='1'
#           PRINT COLUMN g_c[38],sr.order1,':', ## TQC-5B0133 ##
#                 COLUMN g_c[40],g_x[14],
#                 COLUMN g_c[41],l_tmp01,
#                 COLUMN g_c[43],cl_numfor(st.tmp03,43,sr.azi05),
#                 COLUMN g_c[44],cl_numfor(st.tmp04,44,g_azi05)
#           SELECT SUM(tmp03),SUM(tmp04) INTO st.tmp03,st.tmp04 FROM r410_tmp_1
#            WHERE tmp01=l_tmp01 AND tmp02='2'
# 
#            PRINT COLUMN g_c[38],sr.order1,':', ## TQC-5B0133 ##
#                  COLUMN g_c[40],g_x[15],
#                  COLUMN g_c[41],l_tmp01,
#                  COLUMN g_c[43],cl_numfor(st.tmp03,43,sr.azi05),
#                  COLUMN g_c[44],cl_numfor(st.tmp04,44,g_azi05)
#         END FOREACH
#      END IF
#
#   AFTER GROUP OF sr.order2
#      IF tm.u[2,2] = 'Y' THEN
#         DECLARE r410_tmp_cs CURSOR FOR SELECT UNIQUE(amt01) FROM r410_tmp_3
#         FOREACH r410_tmp_cs INTO l_tmp01
#          SELECT SUM(amt03),SUM(amt04) INTO st.tmp03,st.tmp04 FROM r410_tmp_3
#           WHERE amt01=l_tmp01 AND amt02='1'
#          PRINT COLUMN g_c[38],sr.order2,':', ## TQC-5B0133 ##
#                COLUMN g_c[40],g_x[14],
#                COLUMN g_c[41],l_tmp01,
#                COLUMN g_c[43],cl_numfor(st.tmp03,43,sr.azi05),
#                COLUMN g_c[44],cl_numfor(st.tmp04,44,g_azi05)
#          SELECT SUM(amt03),SUM(amt04) INTO st.tmp03,st.tmp04 FROM r410_tmp_3
#           WHERE amt01=l_tmp01 AND amt02='2'
#           PRINT COLUMN g_c[38],sr.order2,':', ## TQC-5B0133 ##
#                 COLUMN g_c[40],g_x[15],
#                 COLUMN g_c[41],l_tmp01,
#                 COLUMN g_c[43],cl_numfor(st.tmp03,43,sr.azi05),
#                 COLUMN g_c[44],cl_numfor(st.tmp04,44,g_azi05)
#         END FOREACH
#      END IF
#
#   ON LAST ROW
#      #依幣別總計
#      DECLARE r410_tot_cs CURSOR FOR SELECT UNIQUE(tot01) FROM r410_tmp_2
#      FOREACH r410_tot_cs INTO l_tmp01
#         SELECT SUM(tot03),SUM(tot04) INTO st.tmp03,st.tmp04 FROM r410_tmp_2
#          WHERE tot01=l_tmp01 AND tot02='1'
#         PRINT COLUMN g_c[40],g_x[16],
#               COLUMN g_c[41],l_tmp01,
#               COLUMN g_c[43],cl_numfor(st.tmp03,43,sr.azi05),
#               COLUMN g_c[44],cl_numfor(st.tmp04,44,g_azi05)
#         SELECT SUM(tot03),SUM(tot04) INTO st.tmp03,st.tmp04 FROM r410_tmp_2
#          WHERE tot01=l_tmp01 AND tot02='2'
#            PRINT COLUMN g_c[40],g_x[17],
#                  COLUMN g_c[41],l_tmp01,
#                  COLUMN g_c[43],cl_numfor(st.tmp03,43,sr.azi05),
#                  COLUMN g_c[44],cl_numfor(st.tmp04,44,g_azi05)
#      END FOREACH
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#         #TQC-630166
#         #     IF tm.wc[001,120] > ' ' THEN            # for 132
#         # PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#         #     IF tm.wc[121,240] > ' ' THEN
#         # PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#         #     IF tm.wc[241,300] > ' ' THEN
#         # PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#         #END TQC-630166
#
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#NO.FUN-840020----MARK--END---
