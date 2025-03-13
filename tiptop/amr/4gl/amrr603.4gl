# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: amrr603.4gl
# Descriptions...: 多工廠MRP調撥建議表
# Date & Author..: 05/11/10 By Jackie
# Modify.........: No.TQC-650087 06/06/01 By Rayven mss_g_file和mst_g_file命名                                                      
#                  不規範，mss_g_file現使用msu_file，mst_g_file現使用msv_file，                                                     
#                  相關欄位做相應更改：mss_gv改為msu000，mst_gv改為msv000，                                                         
#                  mst_gplant改為msv031，mst_gplantv改為msv032
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-850143 08/06/04 By lutingting報表轉為使用CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No.TQC-CA0020 12/10/09 By chenjing 修改msu01開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      LIKE type_file.chr1000,# QBE 條件                    #NO.FUN-680082 VARCHAR(500) 
           msu000  LIKE msu_file.msu000,                               
           s       LIKE type_file.chr3,    # 排序 (INPUT 條件)         #NO.FUN-680082 VARCHAR(03)
           t       LIKE type_file.chr3,    # 跳頁 (INPUT 條件)         #NO.FUN-680082 VARCHAR(03)
           more    LIKE type_file.chr1   # 輸入其它特殊列印條件        #NO.FUN-680082 VARCHAR(01)
           END RECORD
DEFINE   g_orderA  ARRAY[3] OF LIKE type_file.chr20  # 篩選排序條件用變數  #NO.FUN-680082 VARCHAR(20)       
DEFINE   g_i       LIKE type_file.num5   #count/index for any purpose  #NO.FUN-680082 SMALLINT
DEFINE   g_head1   STRING
DEFINE   g_sql     STRING              #No.FUN-850143
DEFINE   g_str     STRING              #No.FUN-850143
DEFINE   l_table   STRING              #No.FUN-850143
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
   #No.FUN-850143--------start--
   LET g_sql = "tmp_g01.msu_file.msu01,",
               "ima02.ima_file.ima02,",
               "tmp_g02.msu_file.msu02,",
               "pmc03.pmc_file.pmc03,", 
               "tmp_g03.msu_file.msu03,",
               "tmp_sgplant.msv_file.msv031,", 
               "tmp_sgplantv.msv_file.msv032,",
               "tmp_dgplant.msv_file.msv031,", 
               "tmp_dgplantv.msv_file.msv032,",
               "tmp_qty.msv_file.msv070" 
   LET l_table = cl_prt_temptable('amrr603',g_sql) CLIPPED
   IF l_table =-1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF            
   #No.FUN-850143--------end
   
   #--外部程式傳遞參數或 Background Job 時接受參數 --#
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.msu000= ARG_VAL(8)
   LET tm.s     = ARG_VAL(9)
   LET tm.t     = ARG_VAL(10)
   LET tm.more  = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
 
   IF NOT cl_null(tm.wc) THEN
      CALL r603()
   ELSE
      CALL r603_tm(0,0)
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION r603_tm(p_row,p_col)
DEFINE lc_qbe_sn            LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col          LIKE type_file.num5    #NO.FUN-680082 SMALLINT 
DEFINE l_cmd                LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(1000)
DEFINE s_gplant,d_gplant    LIKE msv_file.msv031
DEFINE s_gplantv,d_gplantv  LIKE msv_file.msv032
 
   #開啟視窗
   LET p_row = 3 LET p_col = 11
   OPEN WINDOW r603_w AT p_row,p_col WITH FORM "amr/42f/amrr603"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   #預設畫面欄位
   INITIALIZE tm.* TO NULL
   LET tm.s   = '123'
   LET tm.t   = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[1,1]
   LET tm2.t3   = tm.t[1,1]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
 
WHILE TRUE
 
   # QBE
   CONSTRUCT BY NAME tm.wc ON msu03,msu02,msu01
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
          LET g_action_choice = "locale"
          EXIT CONSTRUCT
 
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(msu02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pmc2"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO msu02
                NEXT FIELD msu02
              WHEN INFIELD(msu01)
                CALL cl_init_qry_var()
            #   LET g_qryparam.form = "q_occ"      #TQC-CA0020
                LET g_qryparam.form = "q_ima"      #TQC-CA0020
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO msu01
                NEXT FIELD msu01
 
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
 
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
      CLOSE WINDOW r603_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
 
   # INPUT
   INPUT BY NAME tm.msu000,
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
              #   tm2.u1,tm2.u2,tm2.u3,
                 tm.more
      WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more    #是否輸入其它特殊條件
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
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
      CLOSE WINDOW r603_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
 
   #選擇延后執行本作業 ( Background Job 設定)
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='amrr603'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrr603','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('amrr603',g_time,l_cmd)
      END IF
      CLOSE WINDOW r603_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
 
   CALL cl_wait()  # 列印中，請稍候
   #開始制作報表
   CALL r603()
   ERROR ""
   DROP TABLE curr_tmp
END WHILE
CLOSE WINDOW r603_w
END FUNCTION
 
FUNCTION r603()
DEFINE l_name    LIKE type_file.chr20   # External(Disk) file name        #NO.FUN-680082 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0076
DEFINE l_sql     LIKE type_file.chr1000  # SQL STATEMENT                  #NO.FUN-680082 VARCHAR(1000)
DEFINE l_za05    LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(40)
DEFINE l_order   ARRAY[5] OF LIKE msu_file.msu01                          #NO.FUN-680082 VARCHAR(10)
DEFINE i,j,k     LIKE type_file.num10   #NO.FUN-680082 INTEGER 
DEFINE bal       LIKE msu_file.msu08
DEFINE qty2      LIKE msv_file.msv070
DEFINE s_gplant  LIKE msv_file.msv031
DEFINE s_gplantv LIKE msv_file.msv032
DEFINE d_gplant  LIKE msv_file.msv031
DEFINE d_gplantv LIKE msv_file.msv032
DEFINE sr_tmpmrp RECORD
                 tmp_gv         LIKE msu_file.msu000,   #NO.FUN-680082 VARCHAR(04)
                 tmp_g01        LIKE msu_file.msu01,    #NO.FUN-680082 VARCHAR(40) 
                 tmp_g02        LIKE msu_file.msu02,    #NO.FUN-680082 VARCHAR(10)
                 tmp_g03        LIKE msu_file.msu03,    #NO.FUN-680082 DATE
                 tmp_sgplant    LIKE msv_file.msv031,   #NO.FUN-680082 VARCHAR(10)
                 tmp_sgplantv   LIKE msv_file.msv032,   #NO.FUN-680082 VARCHAR(02)
                 tmp_dgplant    LIKE msv_file.msv031,   #NO.FUN-680082 VARCHAR(10)
                 tmp_dgplantv   LIKE msv_file.msv032,   #NO.FUN-680082 VARCHAR(02)
                 tmp_qty        LIKE msv_file.msv070    #NO.FUN-680082 DECIMAL(12,3)
                 END RECORD
DEFINE lmsskey   RECORD
                 msu000 LIKE msu_file.msu000,
                 msu01 LIKE msu_file.msu01,
                 msu02 LIKE msu_file.msu02,
                 msu03 LIKE msu_file.msu03
                 END RECORD
DEFINE lmrp      DYNAMIC ARRAY OF RECORD
                 msv01     LIKE msv_file.msv01,
                 msv031    LIKE msv_file.msv031,
                 msv032    LIKE msv_file.msv032,
                 msv070    LIKE msv_file.msv070
                 END RECORD
DEFINE sr        RECORD order1  LIKE msu_file.msu01,  #NO.FUN-680082 VARCHAR(20)
                        order2  LIKE msu_file.msu01,  #NO.FUN-680082 VARCHAR(20)
                        order3  LIKE msu_file.msu01   #NO.FUN-680082 VARCHAR(20)
                        END RECORD
 
     DEFINE l_ima02      LIKE ima_file.ima02    #No.FUN-850143
     DEFINE l_pmc03      LIKE pmc_file.pmc03    #No.FUN-850143
     DEFINE l_tmp_g01    LIKE msu_file.msu01    #TQC-9C0179
     
     CALL cl_del_data(l_table)     #No.FUN-850143
     #抓取公司名稱
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'amrr603'    #No.FUN-850143
     
     CREATE TEMP TABLE pmrp_tmp(
      tmp_gv         LIKE msu_file.msu000,
      tmp_g01        LIKE msu_file.msu01,
      tmp_g02        LIKE msu_file.msu02,
      tmp_g03        LIKE msu_file.msu03,
      tmp_sgplant    LIKE msv_file.msv031,
      tmp_sgplantv   LIKE msv_file.msv032,
      tmp_dgplant    LIKE msv_file.msv031,
      tmp_dgplantv   LIKE msv_file.msv032,
      tmp_qty        LIKE msv_file.msv070);
      
 
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND msuuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND msugrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND msugrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('msuuser', 'msugrup')
     #End:FUN-980030
 
 
     DELETE FROM pmrp_tmp;
     LET i=0
     LET j=0
     LET l_sql = "SELECT msu000,msu01,msu02,msu03 FROM msu_file ",
                 " WHERE ", tm.wc, " AND msu000 = '", tm.msu000 ,"'",
                 " ORDER BY msu000, msu01,msu02,msu03"
     PREPARE tmp1_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('pre_1:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE lcur_ms CURSOR FOR tmp1_pre
     FOREACH lcur_ms INTO lmsskey.*
 
     LET l_sql= " SELECT msv01,msv031,msv032,msv070 ",
                " FROM msv_file ",
                " WHERE msv000 = '",lmsskey.msu000,"'",
                "   AND msv01= '",lmsskey.msu01,"'",
                "   AND msv02= '",lmsskey.msu02,"'",
                "   AND msv03= '",lmsskey.msu03,"'",
                " ORDER BY msv000,msv01,msv02,msv03,msv070"
     PREPARE tmp2_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('pre_2:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE lcur_mrp CURSOR FOR tmp2_pre
 
     CALL lmrp.clear()
     LET k = 1
     FOREACH lcur_mrp INTO lmrp[k].msv01,lmrp[k].msv031,lmrp[k].msv032,lmrp[k].msv070
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET k = k + 1
      IF k > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
     LET i = i+1
     LET bal = 0
     #對于同料號，同限定廠商，同間距日期的每一個工廠
     FOR i = 1 TO 100
       IF lmrp[i].msv01 IS NULL THEN
          EXIT FOR
       END IF
       LET bal=lmrp[i].msv070
       IF bal < 0 THEN     #如果預估結存小于0
         FOR j = i+1 TO 100
             IF lmrp[j].msv01 IS NULL THEN
                EXIT FOR
             END IF
             LET qty2=lmrp[j].msv070    #取得下一工廠的預估結存
             IF qty2 <= 0 THEN
                CONTINUE FOR
             END IF
             IF qty2 >= bal*-1 THEN
                LET s_gplant=lmrp[j].msv031
                LET s_gplantv=lmrp[j].msv032
                LET d_gplant=lmrp[i].msv031
                LET d_gplantv=lmrp[i].msv032
                INSERT INTO pmrp_tmp
                VALUES(lmsskey.msu000,lmsskey.msu01,lmsskey.msu02,lmsskey.msu03, s_gplant,s_gplantv,d_gplant,d_gplantv,bal*-1)
                LET bal=0
                EXIT FOR
             ELSE
                LET s_gplant=lmrp[j].msv031
                LET s_gplantv=lmrp[j].msv032
                LET d_gplant=lmrp[i].msv031
                LET d_gplantv=lmrp[i].msv032
                Insert into pmrp_tmp values(lmsskey.msu000,lmsskey.msu01,lmsskey.msu02,lmsskey.msu03 ,s_gplant,s_gplantv,d_gplant,d_gplantv,qty2)
                LET bal=bal+qty2       #重新計算被支援后的目標工廠的預估結存
             END IF
         END FOR
       END IF
     END FOR
     END FOREACH
     END FOREACH
 
 
     #抓取資料
     LET l_sql = " SELECT * FROM pmrp_tmp ",
                 " ORDER BY tmp_gv,tmp_g01,tmp_g02,tmp_g03 "
     PREPARE r603_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM
     END IF
     DECLARE lcur_tmpmrp CURSOR FOR r603_prepare1
     #CALL cl_outnam('amrr603') RETURNING l_name     #No.FUN-850143
     #START REPORT r603_rep TO l_name                #No.FUN-850143
     LET g_pageno = 0
     FOREACH lcur_tmpmrp INTO sr_tmpmrp.*
          #No.FUN-850143-----start--         
          ##篩選排列順序條件
          #FOR g_i = 1 TO 3
          #    CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr_tmpmrp.tmp_g01
          #                                  LET g_orderA[g_i]= g_x[20]
          #         WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr_tmpmrp.tmp_g02
          #                                      USING 'yyyymmdd'
          #                                  LET g_orderA[g_i]= g_x[21]
          #         WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr_tmpmrp.tmp_g03
          #                                  LET g_orderA[g_i]= g_x[22]
          #         WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr_tmpmrp.tmp_sgplant
          #                                  LET g_orderA[g_i]= g_x[23]
          #         WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr_tmpmrp.tmp_dgplant
          #                                  LET g_orderA[g_i]= g_x[24]
          #         OTHERWISE LET l_order[g_i]  = '-'
          #                   LET g_orderA[g_i] = ' '          #清為空白
          #    END CASE
          #END FOR
          #LET sr.order1 = l_order[1]
          #LET sr.order2 = l_order[2]
          #LET sr.order3 = l_order[3]
          SELECT ima02 INTO l_ima02 FROM ima_file
               WHERE ima01= sr_tmpmrp.tmp_g01     
          SELECT pmc03 INTO l_pmc03 FROM pmc_file
               WHERE pmc01= sr_tmpmrp.tmp_g02 
          LET l_tmp_g01 = sr_tmpmrp.tmp_g01[1,20]   #TQC-9C0179
          EXECUTE insert_prep USING
               #sr_tmpmrp.tmp_g01[1,20],l_ima02,sr_tmpmrp.tmp_g02,l_pmc03, #TQC-9C0179 mark
               l_tmp_g01,l_ima02,sr_tmpmrp.tmp_g02,l_pmc03,                #TQC-9C0179
               sr_tmpmrp.tmp_g03,sr_tmpmrp.tmp_sgplant,sr_tmpmrp.tmp_sgplantv,
               sr_tmpmrp.tmp_dgplant,sr_tmpmrp.tmp_dgplantv,sr_tmpmrp.tmp_qty                  
          #OUTPUT TO REPORT r603_rep(sr.*,sr_tmpmrp.*)
          #No.FUN-850143-----end
     END FOREACH
     
     #No.FUN-850143-------start--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'msu03,msu02,msu01')
        RETURNING tm.wc
     END IF
     
     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.msu000
     
     CALL cl_prt_cs3('amrr603','amrr603',g_sql,g_str)
     #FINISH REPORT r603_rep
     #DROP TABLE pmrp_tmp
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-850143-------end
END FUNCTION
 
#No.FUN-850143------start--
#REPORT r603_rep(sr,sr_tmpmrp)
#DEFINE l_last_sw    LIKE type_file.chr1          #NO.FUN-680082 VARCHAR(1)
#DEFINE l_ima02      LIKE ima_file.ima02
#DEFINE l_pmc03      LIKE pmc_file.pmc03
#DEFINE sr_tmpmrp    RECORD
#                 tmp_gv         LIKE msu_file.msu000,   #NO.FUN-680082 VARCHAR(04)
#                 tmp_g01        LIKE msu_file.msu01,    #NO.FUN-680082 VARCHAR(40) 
#                 tmp_g02        LIKE msu_file.msu02,    #NO.FUN-680082 VARCHAR(10)
#                 tmp_g03        LIKE msu_file.msu03,    #NO.FUN-680082 DATE
#                 tmp_sgplant    LIKE msv_file.msv031,   #NO.FUN-680082 VARCHAR(10)
#                 tmp_sgplantv   LIKE msv_file.msv032,   #NO.FUN-680082 VARCHAR(02)
#                 tmp_dgplant    LIKE msv_file.msv031,   #NO.FUN-680082 VARCHAR(10)
#                 tmp_dgplantv   LIKE msv_file.msv032,   #NO.FUN-680082 VARCHAR(02)
#                    tmp_qty     LIKE msv_file.msv070    #NO.FUN-680082 DECIMAL(12,3)
#                    END RECORD
#
#DEFINE sr           RECORD order1  LIKE msu_file.msu01,  #NO.FUN-680082 VARCHAR(20)
#                           order2  LIKE msu_file.msu01,  #NO.FUN-680082 VARCHAR(20)
#                           order3  LIKE msu_file.msu01   #NO.FUN-680082 VARCHAR(20)
#                           END RECORD
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.order1,sr.order2,sr.order3,
#           sr_tmpmrp.tmp_g01,sr_tmpmrp.tmp_g02,sr_tmpmrp.tmp_g03
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[9]))/2)-1,g_x[9],tm.msu000
#      LET g_head1 = g_x[13] CLIPPED,
#                    g_orderA[1] CLIPPED,'-',
#                    g_orderA[2] CLIPPED,'-',
#                    g_orderA[3] CLIPPED
#      PRINT g_head1
#
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],
#            g_x[32],
#            g_x[33],
#            g_x[34],
#            g_x[35],
#            g_x[36],
#            g_x[37],
#            g_x[38],
#            g_x[39],
#            g_x[40]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y'           #跳頁控制
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2       #跳頁控制
#      IF tm.t[2,2] = 'Y'
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order3       #跳頁控制
#      IF tm.t[3,3] = 'Y'
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr_tmpmrp.tmp_g01
#      SELECT ima02 INTO l_ima02 FROM ima_file
#       WHERE ima01= sr_tmpmrp.tmp_g01
#      PRINT COLUMN g_c[31],sr_tmpmrp.tmp_g01[1,20],
#            COLUMN g_c[32],l_ima02 CLIPPED;
#
#   BEFORE GROUP OF sr_tmpmrp.tmp_g02
#      SELECT pmc03 INTO l_pmc03 FROM pmc_file
#       WHERE pmc01= sr_tmpmrp.tmp_g02
#      PRINT COLUMN g_c[33],sr_tmpmrp.tmp_g02 CLIPPED,
#            COLUMN g_c[34],l_pmc03 CLIPPED;
#
#   BEFORE GROUP OF sr_tmpmrp.tmp_g03
#      PRINT COLUMN g_c[35],sr_tmpmrp.tmp_g03 CLIPPED;
#
#   ON EVERY ROW
#      PRINT COLUMN g_c[36],sr_tmpmrp.tmp_sgplant CLIPPED,
#            COLUMN g_c[37],sr_tmpmrp.tmp_sgplantv CLIPPED,
#            COLUMN g_c[38],sr_tmpmrp.tmp_dgplant CLIPPED,
#            COLUMN g_c[39],sr_tmpmrp.tmp_dgplantv CLIPPED,
#            COLUMN g_c[40],sr_tmpmrp.tmp_qty USING '#######&.&&&'
#
#   AFTER GROUP OF sr_tmpmrp.tmp_g01
#      SKIP 1 LINE
#      PRINT g_dash2[1,g_len]
# 
#   ON LAST ROW
#      LET l_last_sw = 'y'
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash2[1,g_len]
#         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED
#      ELSE
#         SKIP 2 LINE
#      END IF
#
#END REPORT
#No.FUN-850143------end
#FUN-870144
