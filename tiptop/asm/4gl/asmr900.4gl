# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: asmr900.4gl
# Descriptions...: 異動記錄資料列印作業
# Date & Author..: 92/09/11 By Lee
#
#........................Revision Log.............................
# 920206(Lee): 數值欄位的數值太小, 無法列印
#              若上個欄位有值, 但下個欄位無值, 則會列印上筆之值
#              space 若訂超過25, 則無法列印
# 920217(Lee): 在給條件時, 分成四區construct條件, 條件組合方式為
#              1 and 4 and 5 and ((2) or (3))
#              1. 料件及分群碼
#              2.來源狀況及倉庫及儲位及批號
#              3.目的狀況及倉庫及儲位及批號
#              4.借方會計科目及貸方會計科目
#              5.異動命令, 異動原因, 異動日期, 異動人
#1994/11/07(Lee): No space needed if it is the first column
 #Modify......: No.MOD-490093 04/09/24 By Smapmin 調整資料顯示方式
#........................DEBUG HISTORY............................
# Modify.........: No.FUN-4C0098 05/02/29 By pengu 修改單價、金額欄位寬度
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.TQC-610052 06/01/18 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-650051 06/05/12 By kim 列印後出現 A character variable has referenced subscripts that are out of range
 
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80024 11/08/03 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   tm RECORD            #Print condition RECORD
      wc       LIKE type_file.chr1000,#No.FUN-690010     VARCHAR(1000),      #Where condition
      wc1      LIKE type_file.chr1000,#No.FUN-690010     VARCHAR(1000),      #Where condition
      wc2      LIKE type_file.chr1000,#No.FUN-690010     VARCHAR(1000),      #Where condition
      wc3      LIKE type_file.chr1000,#No.FUN-690010     VARCHAR(2000),      #Where condition
      smw01    LIKE smw_file.smw01,   #report name
      more     LIKE type_file.chr1,  #No.FUN-690010  VARCHAR(1),    #Input more condition(Y/N)
      inv_only LIKE type_file.chr1   #No.FUN-690010  VARCHAR(1)     #Inventory only?
      END RECORD,
   g_program        LIKE zz_file.zz01,    #No.FUN-690010 VARCHAR(10)     #Program Name
   g_smw RECORD LIKE smw_file.*
 
#-------------------------------------------------------------------#
#            BEGIN PROGRAM EXECUTION                  #
#-------------------------------------------------------------------#
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
MAIN
   OPTIONS
   INPUT NO WRAP
   DEFER INTERRUPT         # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_program='asmr900'
 
   # Get arguments from command line
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc=ARG_VAL(7)
   LET tm.smw01=ARG_VAL(8)
       #TQC-610052-begin
   LET tm.inv_only=ARG_VAL(9)
        LET g_rep_user = ARG_VAL(10)
        LET g_rep_clas = ARG_VAL(11)
        LET g_template = ARG_VAL(12)
       ##No.FUN-570264 --start--
       #LET g_rep_user = ARG_VAL(9)
       #LET g_rep_clas = ARG_VAL(10)
       #LET g_template = ARG_VAL(11)
       ##No.FUN-570264 ---end---
       #TQC-610052-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r900_tm()
   ELSE
      CALL r900()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B80024 ADD
END MAIN
 
#-------------------------------------------------------------------#
#                      Get User Options                             #
#-------------------------------------------------------------------#
FUNCTION r900_tm()
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
       l_cmd          LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(1000)
 
   LET p_row =3  LET p_col = 16
 
   OPEN WINDOW r900_w AT p_row,p_col WITH FORM "asm/42f/asmr900"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more='N'
   LET tm.inv_only='Y'
   LET g_pdate=g_today
   LET g_rlang=g_lang
   LET g_bgjob='N'
   LET g_copies='1'
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON tlf01,ima06
#No.FUN-570240 --start--
       ON ACTION controlp
            IF INFIELD(tlf01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf01
               NEXT FIELD tlf01
            END IF
#No.FUN-570240 --end--
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
     END CONSTRUCT
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     CONSTRUCT BY NAME tm.wc1 ON tlf02,tlf021,tlf022,tlf023
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
     END CONSTRUCT
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
    CONSTRUCT BY NAME tm.wc2 ON tlf03,tlf031,tlf032,tlf033
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
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    CONSTRUCT BY NAME tm.wc3 ON tlf15,tlf13,tlf06,tlf16,tlf14,tlf09
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
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    DISPLAY BY NAME tm.smw01,tm.more
      
    INPUT BY NAME tm.smw01,tm.inv_only,tm.more WITHOUT DEFAULTS
   AFTER FIELD smw01
      IF tm.smw01 IS NULL THEN
         NEXT FIELD smw01
      END IF
      SELECT * INTO g_smw.* FROM smw_file
        WHERE smw01 = tm.smw01
      IF SQLCA.sqlcode THEN
#                   CALL cl_err('','mfg9002',0)  # FUN-660138
                   CALL cl_err3("sel","smw_file",tm.smw01,"","mfg9002","","",0) # FUN-660138
         NEXT FIELD smw01
      END IF
      IF g_smw.smwacti='N' THEN
         CALL cl_err('','9028',0)
         NEXT FIELD smw01
      END IF
 
   AFTER FIELD inv_only
      IF tm.inv_only NOT MATCHES "[YN]" THEN
         NEXT FIELD inv_only
      END IF
   AFTER FIELD more
      IF tm.more = 'Y' THEN
         CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
            g_bgjob,g_time,g_prtway,g_copies)
         RETURNING g_pdate,g_towhom,g_rlang,
            g_bgjob,g_time,g_prtway,g_copies
      END IF
   AFTER INPUT
      IF INT_FLAG THEN EXIT INPUT END IF
      IF tm.smw01 IS NULL THEN NEXT FIELD smw01 END IF
 
        ON ACTION CONTROLR
               CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()   # Command execution
 
        ON ACTION qry_item_master
            CALL r900_wc()   # Input detail Where Condition
 
        ON ACTION CONTROLP
      CASE
          WHEN INFIELD(smw01)   #報表代號
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = 'q_smw'
                        LET g_qryparam.default1 = tm.smw01
                        CALL cl_create_qry() RETURNING tm.smw01
#                        CALL FGL_DIALOG_SETBUFFER( tm.smw01 )
                        DISPLAY BY NAME tm.smw01
                        NEXT FIELD smw01
                    OTHERWISE EXIT CASE
      END CASE
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
     END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
   IF g_bgjob = 'Y' THEN
      #get exec cmd (fglgo xxxx)
      SELECT zz08 INTO l_cmd FROM zz_file
         WHERE zz01=g_program
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err(g_program,'9031',1)
         EXIT WHILE
      END IF
      #(at time fglgo xxxx p1 p2 p3)
                LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
      LET l_cmd = l_cmd CLIPPED,
         " '",g_pdate CLIPPED,"'",
         " '",g_towhom CLIPPED,"'",
         " '",g_lang CLIPPED,"'",
         " '",g_bgjob CLIPPED,"'",
         " '",g_prtway CLIPPED,"'",
         " '",g_copies CLIPPED,"'",
         " '",tm.wc CLIPPED,"'",
         " '",tm.smw01 CLIPPED,"'",
         " '",tm.inv_only CLIPPED,"'",           #TQC-610052
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
      CALL cl_cmdat(g_program,g_time,l_cmd)
      CLOSE WINDOW r900_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80024  ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r900()
   ERROR ""
    END WHILE
    CLOSE WINDOW r900_w
END FUNCTION
 
FUNCTION r900_wc()
    DEFINE l_wc LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(350)
    OPEN WINDOW aimr100_w2 AT 2,2
      WITH FORM "aim/42f/aimi100"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimi100")
 
    CALL cl_opmsg('q')
    CONSTRUCT BY NAME l_wc ON                    # 螢幕上取條件
      ima05, ima08, ima02, ima03,
      ima13, ima04, ima14, ima70,
      ima15, ima24, ima07, ima16,
      ima37, ima51, ima52, ima09,
      ima10, ima11, ima12, ima25,
      ima73, ima74, ima29, ima30
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
    END CONSTRUCT
    CLOSE WINDOW aimr100_w2
    LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
    IF INT_FLAG THEN
    LET INT_FLAG = 0
    CLOSE WINDOW r100_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80024  ADDA
    EXIT PROGRAM
    END IF
END FUNCTION
 
FUNCTION r900()
DEFINE
   l_name   LIKE type_file.chr20,       # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time   LIKE type_file.chr8       #No.FUN-6A0089
   l_bal   LIKE aao_file.aao05,    #No.FUN-690010 DECIMAL(13,3),
   l_qty,l_sqty LIKE aao_file.aao05,    #No.FUN-690010 DECIMAL(13,3),
   l_part LIKE ima_file.ima01,
   l_sql    LIKE type_file.chr1000,   #RDSQL STATEMENT  #No.FUN-690010 VARCHAR(1000)
   l_chr   LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
   l_i,l_j LIKE type_file.num5,    #No.FUN-690010 SMALLINT
   l_za05   LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
   l_k  LIKE type_file.num10,      #No.FUN-690010INTEGER,
   l_item   LIKE type_file.num5,   #No.FUN-690010 SMALLINT,
   sr   DYNAMIC ARRAY OF RECORD
      LineSeq   LIKE type_file.num5,  #No.FUN-690010SMALLINT,
      FieldSeq  LIKE type_file.num5,  #No.FUN-690010SMALLINT,
      Contents  LIKE ima_file.ima01,  #No.FUN-690010CHAR(35),
      Lengths   LIKE nmz_file.nmz57 , #No.FUN-690010DECIMAL(4,2),
      coltype   LIKE type_file.num5   #No.FUN-690010 SMALLINT
      END RECORD
 
   CALL cl_used(g_program,g_time,1) RETURNING g_time      #No.FUN-6A0089 
 
   #公司名稱
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #報表表頭資料, 長度, 及畫線
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01=g_program
       #TQC-650051...............begin
       #LET g_len=g_smw.smw06
       #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 136 END IF
       #IF g_len<79 THEN LET g_len=79 END IF
       #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
       #TQC-650051...............end
 
   #取得所要處理的欄位
   DECLARE r900_smx
      CURSOR FOR SELECT smx03,smx04,smx05,smx06,smx07
      FROM smx_file
      WHERE smx01=tm.smw01
      ORDER BY 1,2
   LET l_i=1
   FOREACH r900_smx INTO sr[l_i].*
      IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
      LET l_i=l_i+1
      IF l_i > 5 THEN EXIT FOREACH END IF
        END FOREACH
   LET l_i=l_i-1
   LET l_item=l_i
 
   #所要選資料的SQL
   LET l_sql="SELECT"
   FOR l_j=1 TO 90
      IF sr[l_j].Contents IS NOT NULL THEN
         IF sr[l_j].Contents='space' THEN
            LET l_sql=l_sql CLIPPED," ' '"
         ELSE
            LET l_sql=l_sql CLIPPED," ",sr[l_j].Contents
         END IF
      ELSE
         LET l_sql=l_sql CLIPPED," ''"
      END IF
      IF l_j<90 THEN LET l_sql=l_sql CLIPPED,"," END IF
   END FOR
   LET l_sql=l_sql CLIPPED,
      " FROM tlf_file,ima_file",
      " WHERE ima01=tlf01 ",
      " AND ",tm.wc CLIPPED, " AND ",tm.wc3 CLIPPED,
      " AND ((",tm.wc1 CLIPPED,") OR (", tm.wc2 CLIPPED, "))"
   IF tm.inv_only = 'Y' THEN
      LET l_sql=l_sql CLIPPED, " AND ((tlf02>49 AND tlf02<60)",
      " OR (tlf03>49 AND tlf03<60))"
   END IF
   LET l_sql=l_sql CLIPPED, " ORDER BY 1,2,3"
   PREPARE r900_pre FROM l_sql
   IF SQLCA.sqlcode THEN CALL cl_err('Prepare:',SQLCA.sqlcode,1) RETURN END IF
   DECLARE r900_cus CURSOR FOR r900_pre   #demand cursor
   CALL cl_outnam(g_program) RETURNING l_name
       #TQC-650051...............begin
#        LET g_len=g_smw.smw06
#        IF g_len = 0 OR g_len IS NULL THEN LET g_len = 136 END IF
#        IF g_len<79 THEN LET g_len=79 END IF
        FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
       #TQC-650051...............end
   START REPORT r900_rep TO l_name
 
   LET g_pageno = 0
   LET l_j=1
   LET l_k=0
   FOREACH r900_cus INTO
      sr[1].Contents, sr[2].Contents, sr[3].Contents,
      sr[4].Contents, sr[5].Contents, sr[6].Contents,
      sr[7].Contents, sr[8].Contents, sr[9].Contents,
      sr[10].Contents,sr[11].Contents,sr[12].Contents,
      sr[13].Contents,sr[14].Contents,sr[15].Contents,
      sr[16].Contents,sr[17].Contents,sr[18].Contents,
      sr[19].Contents,sr[20].Contents,sr[21].Contents,
      sr[22].Contents,sr[23].Contents,sr[24].Contents,
      sr[25].Contents,sr[26].Contents,sr[27].Contents,
      sr[28].Contents,sr[29].Contents,sr[30].Contents,
      sr[31].Contents,sr[32].Contents,sr[33].Contents,
      sr[34].Contents,sr[35].Contents,sr[36].Contents,
      sr[37].Contents,sr[38].Contents,sr[39].Contents,
      sr[40].Contents,sr[41].Contents,sr[42].Contents,
      sr[43].Contents,sr[44].Contents,sr[45].Contents,
      sr[46].Contents,sr[47].Contents,sr[48].Contents,
      sr[49].Contents,sr[50].Contents,sr[51].Contents,
      sr[52].Contents,sr[53].Contents,sr[54].Contents,
      sr[55].Contents,sr[56].Contents,sr[57].Contents,
      sr[58].Contents,sr[59].Contents,sr[60].Contents,
      sr[61].Contents,sr[62].Contents,sr[63].Contents,
      sr[64].Contents,sr[65].Contents,sr[66].Contents,
      sr[67].Contents,sr[68].Contents,sr[69].Contents,
      sr[70].Contents,sr[71].Contents,sr[72].Contents,
      sr[73].Contents,sr[74].Contents,sr[75].Contents,
      sr[76].Contents,sr[77].Contents,sr[78].Contents,
      sr[79].Contents,sr[80].Contents,sr[81].Contents,
      sr[82].Contents,sr[83].Contents,sr[84].Contents,
      sr[85].Contents,sr[86].Contents,sr[87].Contents,
      sr[88].Contents,sr[89].Contents,sr[90].Contents
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      FOR l_i=1 TO 90
         IF sr[l_i].Contents IS NULL THEN
            #若還是在欄位之內, 則應送出值將之清為空白, 無則
            #會列印上筆之值
            IF l_i>l_item THEN CONTINUE FOR
            ELSE LET sr[l_i].Contents=' ' END IF
         END IF
         OUTPUT TO REPORT r900_rep(l_k,l_i,sr[l_i].*)
      END FOR
      LET l_k=l_k+1
   END FOREACH
 
   DISPLAY "" AT 2,1
   FINISH REPORT r900_rep
 
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #No.FUN-BB0047--mark--Begin---
   #CALL cl_used(g_program,g_time,2) RETURNING g_time   #No.FUN-6A0089 
   #No.FUN-BB0047--mark--End-----
END FUNCTION
 
REPORT r900_rep(p_seq,p_lseq,sr)
DEFINE
   l_last_sw          LIKE type_file.chr1,  #No.FUN-690010CHAR(1),
   l_ima RECORD       LIKE ima_file.*,
   p_seq              LIKE type_file.num10, #No.FUN-690010INTEGER,
   p_lseq             LIKE type_file.num5,  #No.FUN-690010SMALLINT,
   l_sql              LIKE type_file.chr1000,  #No.FUN-690010 VARCHAR(1000)
   l_line ARRAY[3] OF LIKE type_file.chr1000,#No.FUN-690010 VARCHAR(136),
   l_now  ARRAY[3] OF LIKE type_file.num5,  #No.FUN-690010 SMALLINT,
   l_i,l_j,l_k,l_l,l_m,l_n LIKE type_file.num5,    #No.FUN-690010 SMALLINT
   l_contents         LIKE aab_file.aab01, #No.FUN-690010 VARCHAR(25),
   l_deci             LIKE type_file.num20_6,#No.FUN-690010 decimal(30,6),
   l_lines            LIKE type_file.chr1000,#No.FUN-690010char(136),
   sr   RECORD
      LineSeq  LIKE type_file.num5,  #No.FUN-690010SMALLINT,
      FieldSeq LIKE type_file.num5,  #No.FUN-690010SMALLINT,
      Contents LIKE ima_file.ima01,  #No.FUN-690010CHAR(35),
      Lengths  LIKE nmz_file.nmz57,  #No.FUN-690010DECIMAL(4,2),
      ColType  LIKE type_file.num5   #No.FUN-690010SMALLINT
      END RECORD,
   sa   DYNAMIC ARRAY OF RECORD
      LineSeq  LIKE type_file.num5,  #No.FUN-690010SMALLINT,
      FieldSeq LIKE type_file.num5,  #No.FUN-690010SMALLINT,
      Contents LIKE ima_file.ima01,  #No.FUN-690010CHAR(35),
      Lengths  LIKE nmz_file.nmz57,  #No.FUN-690010DECIMAL(4,2),
      ColType  LIKE type_file.num5   #No.FUN-690010SMALLINT
      END RECORD,
   l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   OUTPUT TOP MARGIN g_top_margin
      LEFT MARGIN         0
      BOTTOM MARGIN g_bottom_margin   
      PAGE LENGTH g_page_line
      ORDER BY p_seq
   FORMAT
 
   PAGE HEADER
      #公司名稱
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#No.TQC-6B0002 -- begin --
#      #送到那兒去
#      IF g_towhom IS NULL OR g_towhom = ' ' THEN
#         PRINT '';
#      ELSE
#         PRINT 'TO:',g_towhom;
#      END IF
#      #打從那兒來
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_smw.smw02))/2 SPACES,g_smw.smw02
#      #空一行
#      PRINT ' '    #No.TQC-6B0002
#      LET g_pageno = g_pageno + 1
#      #製表日期
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      IF g_towhom IS NULL OR g_towhom = ' ' THEN                      
         PRINT '';                                               
      ELSE                                                            
         PRINT 'TO:',g_towhom;                                   
      END IF
         LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN (g_len-FGL_WIDTH(g_user)-15),'FROM:',g_user CLIPPED,
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6B0002
      PRINT ''
#No.TQC-6B0002 -- end --
      #畫一條線
      PRINT g_dash[1,g_len]
#No.TQC-6B0002 -- begin --
#      PRINT g_smw.smw03
#      PRINT g_smw.smw04
#      PRINT g_smw.smw05
#      PRINT g_dash[1,g_len]
      PRINT g_x[15],COLUMN 32,g_x[16],COLUMN 47,g_x[17],COLUMN 62,g_x[18],COLUMN 82,g_x[19]
      PRINT '------------------------- --------- -------------- ------------------------      ---------'
 
#No.TQC-6B0002 -- end --
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      LET sa[p_lseq].LineSeq=sr.LineSeq
      LET sa[p_lseq].FieldSeq=sr.FieldSeq
      LET sa[p_lseq].Contents=sr.Contents
      LET sa[p_lseq].Lengths=sr.Lengths
      LET sa[p_lseq].Coltype=sr.Coltype
 
   AFTER GROUP OF p_seq
      LET l_line[1]=' '
      LET l_line[2]=' '
      LET l_line[3]=' '
      LET l_now[1]=1
      LET l_now[2]=1
      LET l_now[3]=1
      FOR l_i=1 TO 90
         IF sa[l_i].LineSeq IS NULL OR sa[l_i].LineSeq=0 THEN
            CONTINUE FOR END IF
         LET l_contents=sa[l_i].Contents
         LET l_j=sa[l_i].Lengths       #整數
                                              
         IF sa[l_i].Coltype>0 THEN   #數值格式, 請轉換之
            IF sa[l_i].Coltype!=7 THEN   #DATE FORMAT
               LET l_l=(sa[l_i].Lengths-l_j)*1    #小數
               let l_deci=l_contents
               LET l_contents=cl_numfor(l_deci,l_j,l_l)
            END IF
         END IF
         LET l_n=sa[l_i].LineSeq
         LET l_k=l_now[l_n]
         LET l_m=l_k+l_j
         IF sa[l_i].coltype=0 THEN
            let l_lines=l_contents
            IF l_i>1 THEN
               LET l_line[l_n][l_k+1,l_m]=l_lines[1,l_j]
            ELSE
               LET l_line[l_n][l_k,l_m]=l_lines[1,l_j]
            END IF
         ELSE
 
            LET l_line[l_n][l_k,l_m]=l_contents[1,l_j+1] #MOD-490093
         END IF
 
         LET l_now[l_n]=l_now[l_n]+20 #MOD-490093
         #LET l_now[l_n]=l_now[l_n]+l_j
      END FOR
 
      FOR l_i=1 TO 3
         IF NOT cl_null(l_line[l_i]) THEN
            PRINT l_line[l_i] CLIPPED
         END IF
      END FOR
 
   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
      PRINT g_dash[1,g_len]
      PRINT g_x[10],g_x[11]
      PRINT g_x[12],g_x[13]
      PRINT g_x[14],g_x[15]
#      ELSE SKIP 4 LINE
#      END IF
END REPORT
#Patch....NO.TQC-610037 <001> #
