# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: axrr530.4gl
# Descriptions...: 分錄底稿清單
# Date & Author..: 95/01/25 By Danny
# Modify.........: 97/08/28 By Sophia 新增帳別(npp07)
# Modify.........: 98/04/16 By Apple  修改
#       .........: (1)npp00 只有1/2/3 (2)類別加上using否則格式會亂
# Modify.........: No.FUN-4C0100 04/12/30 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-5B0030 05/11/28 By Smapmin 分錄底稿清單中,應增加判斷,若單據已做廢,就不在呈現出來!
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.TQC-6B0051 06/12/13 By xufeng 修改報表格式   
# Modify.........: No.FUN-740009 07/04/03 By Judy 會計科目加帳套
# Modify.........: No.MOD-750123 07/05/25 By Smapmin 清空變數值
# Modify.........: No.TQC-790085 07/09/13 By lumxa  表名和制表日期位置顛倒。
# Modify.........: NO.FUN-840051 08/04/15 By zhaijie 報表修改成CR
# Modify.........: No.MOD-920058 09/02/06 By Sarah l_sql裡先不串aag_file,等到FOREACH裡再抓取
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Mofify.........: No.FUN-980020 09/09/03 By douzh 集團架構調整
# Modify.........: No:MOD-A80185 10/08/25 By Dido 出貨應考量待驗出貨部分排除作廢資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD            
           wc      LIKE type_file.chr1000,   #No.FUN-680123 VARCHAR(1000) 
           s       LIKE type_file.chr4,      #No.FUN-680123 VARCHAR(3)   
           t       LIKE type_file.chr4,      #No.FUN-680123 VARCHAR(3)    
           u       LIKE type_file.chr4,      #No.FUN-680123 VARCHAR(3)     
           more    LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)     
           END RECORD,
         g_orderA  ARRAY[3] OF LIKE ooo_file.ooo02       #No.FUN-680123 ARRAY[3] OF VARCHAR(10)
 
DEFINE   g_i       LIKE type_file.num5     #count/index for any purpose     #No.FUN-680123 SMALLINT
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
   LET g_sql = "npp00.npp_file.npp00,",
               "npp01.npp_file.npp01,",
               "npp02.npp_file.npp02,",
               "nppglno.npp_file.nppglno,",
               "npq02.npq_file.npq02,",
               "npq03.npq_file.npq03,",
               "aag02.aag_file.aag02,",
               "npq04.npq_file.npq04,",
               "npq05.npq_file.npq05,",
               "npq06.npq_file.npq06,",
               "npq07f.npq_file.npq07f,",
               "npq07.npq_file.npq07,",
               "npq21.npq_file.npq21,",
               "npq22.npq_file.npq22,",
               "npq23.npq_file.npq23,",
               "npq24.npq_file.npq24,",
               "npq25.npq_file.npq25,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "azi07.azi_file.azi07,",
               "l_gem02.gem_file.gem02"
   LET l_table = cl_prt_temptable('axrr530',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?)"
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
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   #no.5196   #No.FUN-680123
#NO.FUN-840051---start--mark--- 
#   DROP TABLE curr_tmp
#   CREATE TEMP TABLE curr_tmp
#    (curr LIKE azi_file.azi01,
#     npq06 LIKE npq_file.npq06,
#     amt1 LIKE type_file.num20_6,
#     amt2 LIKE type_file.num20_6,
#     order1 LIKE ooo_file.ooo01,
#     order2 LIKE ooo_file.ooo01)
#NO.FUN-840051---end---mark---
   #no.5196(end) #No.FUN-680123 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N' 
      THEN CALL r530_tm(0,0)        
      ELSE CALL r530()             
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION r530_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5           #No.FUN-680123 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 14
   END IF
   OPEN WINDOW r530_w AT p_row,p_col
        WITH FORM "axr/42f/axrr530" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL        
   LET tm.s    = '12'
   LET tm.u    = ' Y'
   LET tm.t    = '  '
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
   CONSTRUCT BY NAME tm.wc ON npp00,npp01,npp02,nppglno,npp07  
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
 
  END CONSTRUCT
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r530_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,tm.more
                 WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
      CLOSE WINDOW r530_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   
             WHERE zz01='axrr530'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr530','9031',1)
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
                         " '",tm.u CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axrr530',g_time,l_cmd) 
      END IF
      CLOSE WINDOW r530_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r530()
   ERROR ""
END WHILE
   CLOSE WINDOW r530_w
END FUNCTION
 
FUNCTION r530()
DEFINE l_name    LIKE type_file.chr20,                      #No.FUN-680123 VARCHAR(8)       # External(Disk) file name
#      l_time    LIKE type_file.chr8                        #No.FUN-6A0095
       l_sql     LIKE type_file.chr1000,                    # RDSQL STATEMENT     #No.FUN-680123 VARCHAR(1000)
       l_za05    LIKE type_file.chr1000,                    #No.FUN-680123 VARCHAR(40)
       l_order   ARRAY[5] OF LIKE ooo_file.ooo02,           #No.FUN-680123 VARCHAR(20)
       l_omavoid LIKE oma_file.omavoid,                     #MOD-5B0030
       l_ogaconf LIKE oga_file.ogaconf,                     #MOD-A80185
       l_ooaconf LIKE ooa_file.ooaconf,                     #MOD-5B0030
       sr        RECORD order1    LIKE ooo_file.ooo01,      #No.FUN-680123 VARCHAR(20)
                        order2    LIKE ooo_file.ooo01,      #No.FUN-680123 VARCHAR(20)
                        npp00     LIKE npp_file.npp00,
                        npp01     LIKE npp_file.npp01,
                        npp02     LIKE npp_file.npp02,
                        nppglno   LIKE npp_file.nppglno,
                        npq02     LIKE npq_file.npq02,
                        npq03     LIKE npq_file.npq03,
                        aag02     LIKE aag_file.aag02,
                        npq04     LIKE npq_file.npq04,
                        npq05     LIKE npq_file.npq05,
                        npq06     LIKE npq_file.npq06,
                        npq07f    LIKE npq_file.npq07f,
                        npq07     LIKE npq_file.npq07,
                        npq21     LIKE npq_file.npq21,
                        npq22     LIKE npq_file.npq22,
                        npq23     LIKE npq_file.npq23,
                        npq24     LIKE npq_file.npq24,
                        npq25     LIKE npq_file.npq25,
                        azi03     LIKE azi_file.azi03,
                        azi04     LIKE azi_file.azi04,
                        azi05     LIKE azi_file.azi05, 
                        azi07     LIKE azi_file.azi07,
                        npptype   LIKE npp_file.npptype   #MOD-920058 add
                        END RECORD,
       l_curr      LIKE bgb_file.bgb05,     #No.FUN-680123 DECIMAL(7,4)
       l_gem02     LIKE gem_file.gem02,     #NO.FUN-840051
       l_bookno11  LIKE aza_file.aza81,     #MOD-920058 add
       l_bookno22  LIKE aza_file.aza82,     #MOD-920058 add
       l_bookno33  LIKE aza_file.aza82,     #MOD-920058 add
       l_flag      LIKE type_file.chr1      #MOD-920058 add
 
#NO.FUN-840051---str----              
     CALL cl_del_data(l_table) 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axrr410'
#NO.FUN-840051---end----              
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #no.5196
#     DELETE FROM curr_tmp;                       #NO.FUN-840051
     #no.5196
     LET l_sql = "SELECT '','',",
                #"     npp00,npp01,npp02,nppglno,npq02,npq03,aag02,npq04,",  #MOD-920058 mark
                 "     npp00,npp01,npp02,nppglno,npq02,npq03,'',npq04,",     #MOD-920058
                 "     npq05,npq06,npq07f,npq07,npq21,npq22,npq23,",
                 "     npq24,npq25,azi03,azi04,azi05,azi07 ",
                 "    ,npptype ",   #MOD-920058 add
                #"  FROM npp_file,npq_file,OUTER aag_file,OUTER azi_file ",  #MOD-920058 mark
                 "  FROM npp_file,npq_file,OUTER azi_file ",                 #MOD-920058
                 " WHERE npp01=npq01 ", 
                 "   AND npp00=npq00 ", 
                 "   AND nppsys=npqsys ", 
                 "   AND npp011=npq011 ", 
                 "   AND nppsys='AR' ", 
                #"   AND aag01=npq03 ",                 #MOD-920058 mark
                #"   AND aag00=npp07 ",   #FUN-740009   #MOD-920058 mark
                 "   AND azi_file.azi01=npq_file.npq24 ", 
                 "   AND ", tm.wc CLIPPED,
                 " ORDER BY npp00,npp01,npq02"
     PREPARE r530_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM 
     END IF
     DECLARE r530_curs1 CURSOR FOR r530_prepare1
#     CALL cl_outnam('axrr530') RETURNING l_name            #NO.FUN-840051
#     START REPORT r530_rep TO l_name                       #NO.FUN-840051
     LET g_pageno = 0
     FOREACH r530_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN 
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
        END IF
 
       #str MOD-920058 add
        LET g_plant_new=g_plant
        CALL s_getdbs()
#       CALL s_get_bookno1(YEAR(sr.npp02),g_dbs_new)         #FUN-980020 mark
        CALL s_get_bookno1(YEAR(sr.npp02),g_plant)           #FUN-980020
             RETURNING l_flag,l_bookno11,l_bookno22
        IF sr.npptype =  '0' THEN
           LET l_bookno33 = l_bookno11
        ELSE
           LET l_bookno33 = l_bookno22
        END IF
        SELECT aag02 INTO sr.aag02 FROM aag_file
         WHERE aag00=l_bookno33 AND aag01=sr.npq03
        IF cl_null(sr.aag02) THEN LET sr.aag02=' ' END IF
       #end MOD-920058 add
#MOD-5B0030
        IF sr.npp00='1' OR sr.npp00='2' THEN
           SELECT omavoid INTO l_omavoid FROM oma_file
             WHERE oma01=sr.npp01
           IF l_omavoid = 'Y' THEN
              CONTINUE FOREACH
           END IF
          #-MOD-A80185-add-
           LET g_sql = " SELECT ogaconf ",
                       "   FROM ",cl_get_target_table(g_plant_new,'oga_file'), 
                       "  WHERE oga01 = '",sr.npp01,"'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
           PREPARE sel_oga_pre FROM g_sql
           EXECUTE sel_oga_pre INTO l_ogaconf
           IF sr.npp00='1' AND l_ogaconf = 'X' THEN
              CONTINUE FOREACH
           END IF
          #-MOD-A80185-add-
        END IF
        IF sr.npp00='3' THEN
           SELECT ooaconf INTO l_ooaconf FROM ooa_file
             WHERE ooa01=sr.npp01
           IF l_ooaconf = 'X' THEN
              CONTINUE FOREACH
           END IF
        END IF
#END MOD-5B0030
#NO.FUN-840051---start--mark--
#        FOR g_i = 1 TO 2
#            CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.npp00
#                                          LET g_orderA[g_i]= g_x[10]
#                 WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.npp01
#                                          LET g_orderA[g_i]= g_x[11]
#                 WHEN tm.s[g_i,g_i] = '3' 
#                      LET l_order[g_i] = sr.npp02 USING 'YYYYMMDD'
#                      LET g_orderA[g_i]= g_x[12]
#                 WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.nppglno
#                                          LET g_orderA[g_i]= g_x[13]
#                 OTHERWISE LET l_order[g_i]  = '-'       
#                           LET g_orderA[g_i] = ' '          #清為空白
#            END CASE
#        END FOR
#        LET sr.order1 = l_order[1]
#        LET sr.order2 = l_order[2]
#NO.FUN-840051---end--mark--
        #no.5196
#        INSERT INTO curr_tmp VALUES(sr.npq24,sr.npq06,sr.npq07f,sr.npq07,sr.order1,sr.order2) #NO.FUN-840051
        #no.5196(end)
        IF cl_null(sr.order1) THEN LET sr.order1 = ' ' END IF
        IF cl_null(sr.order2) THEN LET sr.order2 = ' ' END IF
#        OUTPUT TO REPORT r530_rep(sr.*)                    #NO.FUN-840051
#NO.FUN-840051---start----
      LET l_gem02 = NULL 
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.npq05
      EXECUTE insert_prep USING
        sr.npp00,sr.npp01,sr.npp02,sr.nppglno,sr.npq02,sr.npq03,sr.aag02,
        sr.npq04,sr.npq05,sr.npq06,sr.npq07f,sr.npq07,sr.npq21,sr.npq22,
        sr.npq23,sr.npq24,sr.npq25,sr.azi03,sr.azi04,sr.azi05,sr.azi07,
        l_gem02
#NO.FUN-840051---end----
     END FOREACH
 
#     FINISH REPORT r530_rep                                #NO.FUN-840051
#NO.FUN-840051---start----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'npp00,npp01,npp02,nppglno,npp07')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1],";",
                 tm.t[2,2],";",g_azi04,";",tm.u[1,1],";",tm.u[2,2],";",
                 g_azi05,";",tm.s[3,3],";",tm.t[3,3],";",tm.u[3,3]
     CALL cl_prt_cs3('axrr530','axrr530',g_sql,g_str) 
#NO.FUN-840051---end----
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-840051
END FUNCTION
#NO.FUN-840051---start--mark---
#REPORT r530_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1,                    #No.FUN-680123 VARCHAR(1)
#       g_head1      STRING,
#       str2         STRING,
#       l_gem02      LIKE gem_file.gem02,
#       sr        RECORD order1    LIKE ooo_file.ooo01,      #No.FUN-680123 VARCHAR(20)
#                        order2    LIKE ooo_file.ooo01,      #No.FUN-680123 VARCHAR(20)
#                        npp00     LIKE npp_file.npp00,
#                        npp01     LIKE npp_file.npp01,
#                        npp02     LIKE npp_file.npp02,
#                        nppglno   LIKE npp_file.nppglno,
#                        npq02     LIKE npq_file.npq02,
#                        npq03     LIKE npq_file.npq03,
#                        aag02     LIKE aag_file.aag02,
#                        npq04     LIKE npq_file.npq04,
#                        npq05     LIKE npq_file.npq05,
#                        npq06     LIKE npq_file.npq06,
#                        npq07f    LIKE npq_file.npq07f,
#                        npq07     LIKE npq_file.npq07,
#                        npq21     LIKE npq_file.npq21,
#                        npq22     LIKE npq_file.npq22,
#                        npq23     LIKE npq_file.npq23,
#                        npq24     LIKE npq_file.npq24,
#                        npq25     LIKE npq_file.npq25,
#                        azi03     LIKE azi_file.azi03,
#                        azi04     LIKE azi_file.azi04,
#                        azi05     LIKE azi_file.azi05, 
#                        azi07     LIKE azi_file.azi07 
#                        END RECORD,
#		l_str       LIKE type_file.chr4,       #No.FUN-680123 VARCHAR(4)
#		l_curr      LIKE azi_file.azi01,       #No.FUN-680123 VARCHAR(4)
#		l_amt_1     LIKE npq_file.npq07f,
#		l_amt_2     LIKE npq_file.npq07f,
#		l_amt_3     LIKE npq_file.npq07f,
#		l_amt_4     LIKE npq_file.npq07f, 
#		l_amt1      LIKE npq_file.npq07f, 
#		l_amt2      LIKE npq_file.npq07, 
#		l_amt3      LIKE npq_file.npq07f, 
#		l_amt4      LIKE npq_file.npq07 
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.npp00,sr.npp01
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
##     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #No.TQC-6B0051
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #No.TQC-790085
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
##     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #No.TQC-6B0051 #TQC-790085 mark
#      LET g_head1 = g_x[9] CLIPPED,g_orderA[1] CLIPPED,'-',g_orderA[2] CLIPPED
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
#            g_x[45],g_x[46],g_x[47]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#   BEFORE GROUP OF sr.npp00
#      CASE
#        WHEN sr.npp00='1' LET l_str=g_x[18] CLIPPED
#        WHEN sr.npp00='2' LET l_str=g_x[19] CLIPPED
#        WHEN sr.npp00='3' LET l_str=g_x[20] CLIPPED
#        OTHERWISE LET l_str=' ' CLIPPED
#      END CASE
#      LET str2 = sr.npp00 using '#',l_str
#      PRINT COLUMN g_c[31],str2;
#   
#   BEFORE GROUP OF sr.npp01
#      PRINT COLUMN g_c[32],sr.npp01,
#            COLUMN g_c[33],sr.npp02,
#            COLUMN g_c[34],sr.nppglno;
#
#   ON EVERY ROW
#      LET l_gem02 = NULL   #MOD-750123
#      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.npq05
#      PRINT COLUMN g_c[35],sr.npq02 USING '####',   #No.TQC-6A0087
#            COLUMN g_c[36],sr.npq03 CLIPPED,
#            COLUMN g_c[37],sr.aag02,
#            COLUMN g_c[38],sr.npq05,
#            COLUMN g_c[39],l_gem02,
#            COLUMN g_c[40],sr.npq06,
#            COLUMN g_c[41],cl_numfor(sr.npq07f,41,sr.azi04),
#            COLUMN g_c[42],cl_numfor(sr.npq07,42,g_azi04),
#            COLUMN g_c[43],sr.npq21 CLIPPED,
#            COLUMN g_c[44],sr.npq22 CLIPPED,
#            COLUMN g_c[45],sr.npq23,
#            COLUMN g_c[46],sr.npq24,
#            COLUMN g_c[47],cl_numfor(sr.npq25,47,sr.azi07) 
#      IF NOT cl_null(sr.npq04) THEN 
#         PRINT COLUMN g_c[36],sr.npq04
#      END IF
#
#   AFTER GROUP OF sr.order1
#      IF tm.u[1,1] = 'Y' THEN
#        LET l_amt_1 = GROUP SUM(sr.npq07f) WHERE sr.npq06='1'
#	  	LET l_amt_2 = GROUP SUM(sr.npq07) WHERE sr.npq06='1'
#        LET l_amt_3 = GROUP SUM(sr.npq07f) WHERE sr.npq06='2'
#	  	LET l_amt_4 = GROUP SUM(sr.npq07) WHERE sr.npq06='2'
#        PRINT COLUMN g_c[39],g_x[14] CLIPPED,
#              COLUMN g_c[41],cl_numfor(l_amt_1,41,sr.azi05),
#              COLUMN g_c[42],cl_numfor(l_amt_2,42,g_azi05) 
#        PRINT COLUMN g_c[39],g_x[15] CLIPPED,
#              COLUMN g_c[41],cl_numfor(l_amt_3,41,sr.azi05),
#              COLUMN g_c[42],cl_numfor(l_amt_4,42,g_azi05) 
#      END IF
#
#   AFTER GROUP OF sr.order2
#      IF tm.u[2,2] = 'Y' THEN
#        LET l_amt_1 = GROUP SUM(sr.npq07f) WHERE sr.npq06='1'
#	  	LET l_amt_2 = GROUP SUM(sr.npq07) WHERE sr.npq06='1'
#        LET l_amt_3 = GROUP SUM(sr.npq07f) WHERE sr.npq06='2'
#	  	LET l_amt_4 = GROUP SUM(sr.npq07) WHERE sr.npq06='2'
#        PRINT COLUMN g_c[39],g_x[14] CLIPPED,
#              COLUMN g_c[41],cl_numfor(l_amt_1,41,sr.azi05),
#              COLUMN g_c[42],cl_numfor(l_amt_2,42,g_azi05) 
#        PRINT COLUMN g_c[39],g_x[15] CLIPPED,
#              COLUMN g_c[41],cl_numfor(l_amt_3,41,sr.azi05),
#              COLUMN g_c[42],cl_numfor(l_amt_4,42,g_azi05) 
#      END IF
#
#   ON LAST ROW
#        #no.5196
#         DECLARE curr_temp1 CURSOR FOR                    #借方
#          SELECT curr,SUM(amt1),SUM(amt2) FROM curr_tmp
#          WHERE npq06='1'    #NO:6780
#           GROUP BY curr
#         FOREACH curr_temp1 INTO l_curr,l_amt1,l_amt2   
#             SELECT azi05 into t_azi05
#               FROM azi_file
#               WHERE azi01=l_curr
#         PRINT COLUMN g_c[39],g_x[16] CLIPPED,
#               COLUMN g_c[41],cl_numfor(l_amt1,41,t_azi05),
#               COLUMN g_c[42],cl_numfor(l_amt2,42,g_azi05),
#               COLUMN g_c[46],l_curr
#         END FOREACH
#      
#         DECLARE curr_temp2 CURSOR FOR                    #貸方 
#          SELECT curr,SUM(amt1),SUM(amt2) FROM curr_tmp
#           WHERE npq06='2'      #NO:6780
#           GROUP BY curr
#         FOREACH curr_temp2 INTO l_curr,l_amt3,l_amt4
#             SELECT azi05 into t_azi05
#               FROM azi_file
#               WHERE azi01=l_curr
#         PRINT COLUMN g_c[39],g_x[17] CLIPPED,
#               COLUMN g_c[41],cl_numfor(l_amt3,41,t_azi05),
#               COLUMN g_c[42],cl_numfor(l_amt4,42,g_azi05),
#               COLUMN g_c[46],l_curr
#         END FOREACH
#    
#         #no.5196(end)
#{
#        LET l_amt_1 = SUM(sr.npq07f) WHERE sr.npq06='1'
#	  	LET l_amt_2 = SUM(sr.npq07) WHERE sr.npq06='1'
#        LET l_amt_3 = SUM(sr.npq07f) WHERE sr.npq06='2'
#	  	LET l_amt_4 = SUM(sr.npq07) WHERE sr.npq06='2'
#        PRINT COLUMN g_c[39],g_x[16] CLIPPED,
#              COLUMN g_c[41],cl_numfor(l_amt_1,41,sr.azi05),
#              COLUMN g_c[42],cl_numfor(l_amt_2,42,t_azi05) 
#        PRINT COLUMN g_c[39],g_x[17] CLIPPED,
#              COLUMN g_c[41],cl_numfor(l_amt_3,41,sr.azi05),
#              COLUMN g_c[42],cl_numfor(l_amt_4,42,t_azi05) 
#		PRINT ''
#}
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#              IF tm.wc[001,120] > ' ' THEN            # for 132
#          PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#              IF tm.wc[121,240] > ' ' THEN
#          PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#              IF tm.wc[241,300] > ' ' THEN
#          PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
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
#NO.FUN-840051---start--end---
