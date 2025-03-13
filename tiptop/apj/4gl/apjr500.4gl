# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: apjr500.4gl
# Descriptions...: 專案材料未轉採購清單
# Input parameter:
# Date & Author..: 00/01/27 By Alex Lin
# Modify.........: No.FUN-4C0099 05/01/14 By kim 報表轉XML功能
# Modify.........: No.FUN-570243 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.MOD-590003 05/09/05 By DAY 報表結束未對齊
# Modify.........: NO.FUN-680103 06/08/26 BY hongmei 欄位型態轉換
# Modify.........: No.FUN-690118 06/10/16 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0083 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-750101 07/05/25 By mike 報表格式修改為crystal report
# Modify.........: No.FUN-830107 08/03/27 By ChenMoyan 項目管理報表部分
# Modify.........: No.TQC-840049 08/04/20 By ChenMoyan BUG處理
# Modify.........: No.MOD-930109 09/03/11 By rainy 已專請購及未轉請購量不正確，未將所胝未轉請購單的量印出來
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No.TQC-AC0268 10/12/17 By yinhy 增加開窗功能
# Modify.........: No.MOD-B30330 11/03/12 By sabrina r500_c1不需再OUTER pml_file
# Modify.........: No.TQC-B80006 11/08/01 By lixia 開窗全選報錯
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				        # Print condition RECORD
             #wc   VARCHAR(500),                # Where Condition
              wc   STRING, #TQC-630166       # Where Condition
               a    LIKE type_file.chr1,     # Prog. Version..: '5.30.06-13.03.12(01), # 排列項目 
#              b    LIKE type_file.num5,     #No.#FUN-680103 SMALLINT  # 排列項目#No.FUN-830107
              more   LIKE type_file.chr1     # Prog. Version..: '5.30.06-13.03.12(01)  # 特殊列印條件
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680103
DEFINE   g_str           STRING                  #No.FUN-750101
DEFINE   l_table         STRING                  #No.FUN-750101
DEFINE   g_sql           STRING                  #No.FUN-750101
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690118
 
 
#No.FUN-750101  --begin--
   LET g_sql="pjb01.pjb_file.pjb01,",   #專案代號
             "pjb02.pjb_file.pjb02,",   #順序
#No.FUN-830107  --Begin
#            "pjb03.pjb_file.pjb03,",   #工作項目
#            "pjb031.pjb_file.pjb031,", #工作說明
#            "pjf021.pjf_file.pjf021,", #項次
#            "pjf03.pjf_file.pjf03,",   #料件編號
#            "pjf04.pjf_file.pjf04,",   #品名
#            "pjf041.pjf_file.pjf041,", #規格 
#            "pjf05.pjf_file.pjf05,",   #單位
#            "pjf07.pjf_file.pjf07,",   #需求日期
#            "pjf06.pjf_file.pjf06,",   #需求量
#            "pjf08.pjf_file.pjf08"     #已轉請購量
             "pjf03.pjf_file.pjf03,",
             "ima25.ima_file.ima25,",
             "pjf05.pjf_file.pjf05,",
             "pjf06.pjf_file.pjf06,",
             "amt.type_file.num20_6,",
             "diff.type_file.num20_6,",
             "pjf04.pjf_file.pjf04"
#No.FUN-830107  --End 
   LET l_table = cl_prt_temptable('apjr500',g_sql)  CLIPPED   #產生TEMP TABLE
   IF l_table = -1 THEN EXIT PROGRAM END IF                   #TEMP TABLE 產生
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
#              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"             #No.FUN-830107
               " VALUES(?,?,?,?,?, ?,?,?,?)"                  #No.FUN-830107
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
       CALL cl_err('insert_prep:',status,1)  EXIT PROGRAM
   END IF #}
#No.FUN-750101  --END --
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.a     = ARG_VAL(8)
#  LET tm.b     = ARG_VAL(9)         #No.FUN-830107
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r500_tm(0,0)	
      ELSE CALL r500()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
END MAIN
 
FUNCTION r500_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680103 SMALLINT
          l_cmd		LIKE type_file.chr1000  #No.FUN-680103 VARCHAR(1000)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 5 LET p_col = 18
   ELSE LET p_row = 4 LET p_col = 11
   END IF
   OPEN WINDOW r500_w AT p_row,p_col
        WITH FORM "apj/42f/apjr500"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a      = 'Y'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON pjb01,pjb02,pjf03
 
#No.FUN-570243 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
            #No.TQC-AC0268 --Begin
            CASE
               WHEN INFIELD(pjb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_pja"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjb01
                  NEXT FIELD pjb01
            #IF INFIELD(pjf03) THEN
               WHEN INFIELD(pjf03)
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_ima"
                  #LET g_qryparam.state = "c"
                  #CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjf03
                  NEXT FIELD pjf03
            #END IF
               OTHERWISE EXIT CASE
            END CASE
            #No.TQC-AC0268 --End
#No.FUN-570243 --end
 
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
#    INPUT BY NAME tm.a,tm.b,tm.more   WITHOUT DEFAULTS  #No.FUN-830107
     INPUT BY NAME tm.a,tm.more   WITHOUT DEFAULTS       #No.FUN-830107
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a  NOT MATCHES'[YN]' OR cl_null(tm.a) THEN
            NEXT FIELD a
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
      CLOSE WINDOW r500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apjr500'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apjr500','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a,"'",
#                        " '",tm.b,"'",                         #No.FUN-830107
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apjr500',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r500()
   ERROR ""
END WHILE
   CLOSE WINDOW r500_w
END FUNCTION
 
FUNCTION r500()
   DEFINE
          l_name     LIKE type_file.chr20,       #No.#FUN-680103 VARCHAR(20), # External(Disk) file name
#       l_time          LIKE type_file.chr8         #No.FUN-6A0083
#          l_sql      LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-680103 VARCHAR(1000)
          l_sql      STRING,                     #TQC-B80006
          l_za05     LIKE type_file.chr1000,     #No.#FUN-680103 VARCHAR(40)
#         l_rr       LIKE type_file.num5        #No.#FUN-680103 SMALLINT   #No.FUN-830107
          l_pml09    LIKE pml_file.pml09,        #No.FUN-830107
          l_pml20    LIKE pml_file.pml20        #No.FUN-830107
 DEFINE         sr         RECORD
                     pjb01     LIKE    pjb_file.pjb01,   #專案代號
                     pjb02     LIKE    pjb_file.pjb02,   #專案順序
#No.FUN-830107  --Begin
#                    pjb03     LIKE    pjb_file.pjb03,   #工作項目
#                    pjb031    LIKE    pjb_file.pjb031,  #工作說明
#                    pjf021    LIKE    pjf_file.pjf021,  #行序
#                    pjf03     LIKE    pjf_file.pjf03,   #料件編號
#                    pjf04     LIKE    pjf_file.pjf04,   #品名
#                    pjf041    LIKE    pjf_file.pjf041,  #規格
#                    pjf05     LIKE    pjf_file.pjf05,   #單位
#                    pjf07     LIKE    pjf_file.pjf07,   #需求日期
#                    pjf06     LIKE    pjf_file.pjf06,   #需求數量
#                    pjf08     LIKE    pjf_file.pjf08    #已轉請購量
                     pjf03     LIKE    pjf_file.pjf03,  
                     ima25     LIKE    ima_file.ima25,
                     pjf05     LIKE    pjf_file.pjf05,
                     pjf06     LIKE    pjf_file.pjf06,
                     amt       LIKE    type_file.num20_6,
                     diff      LIKE    type_file.num20_6,
                     pjf04     LIKE    pjf_file.pjf04
#No.FUN-830107  --End
                     END RECORD
#No.FUN-750101  --BEGIN--
     LET g_str=''
     CALL cl_del_data(l_table)           
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='apjr500'  
#No.FUN-750101   --END--
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pjauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pjagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pjagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pjauser', 'pjagrup')
     #End:FUN-980030
#No.TQC-840049 --Begin
#     LET l_sql = " SELECT pjb01,pjb02,pjb03,pjb031,",
#                 " pjf021,pjf03,pjf04,pjf041,pjf05,pjf07,pjf06,pjf08 ",
#                 " FROM pja_file,pjb_file,pjf_file ",
#                 " WHERE pja01=pjb01 AND pjb01=pjf01 AND pjb02=pjf02 ",
#                 " AND pjaclose !='Y' AND ",tm.wc CLIPPED
      LET l_sql = " SELECT pjb01,pjb02,pjf03,pjf05,pjf06,pjf04 ",
                  #" FROM pja_file,pjf_file,pjb_file LEFT OUTER JOIN pml_file ON pjb01=pml_file.pml12 AND pjb02=pml_file.pml121 ",      #MOD-930109
                 #" FROM pja_file,pjf_file,pjb_file LEFT OUTER JOIN pml_file ON pjb01=pml_file.pml12 AND pjb02=pml_file.pml121 ", #MOD-930109  #MOD-B30330 mark 
                  " FROM pja_file,pjf_file,pjb_file ",     #MOD-B30330 add 
                  " WHERE pja01=pjb01 AND pjb02=pjf01 ",
                  "   AND pjb09 = 'Y'",                               #MOD-930109 add
                  " AND pjaclose='N' AND ",tm.wc CLIPPED
#No.TQC-840049 --End
     #-->只列印未轉完的資料
#    IF tm.a='Y' THEN LET l_sql=l_sql CLIPPED," AND (pjf06-pjf08)>0 " END IF            #No.FUN-830107
     PREPARE r500_p1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
        EXIT PROGRAM
     END IF
     DECLARE r500_c1 CURSOR FOR r500_p1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
        EXIT PROGRAM
     END IF
 
 #No.FUN-750101 --begin--
{
     #CALL cl_outnam('apjr500') RETURNING l_name
    # START REPORT r500_rep TO l_name
}
#No.FUN-750101  --END--
     LET g_pageno = 1 
     FOREACH r500_c1 INTO sr.pjb01,sr.pjb02,sr.pjf03,sr.pjf05,sr.pjf06,sr.pjf04
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#No.FUN-830107 --Begin
#      IF cl_null(sr.pjf08) THEN LET sr.pjf08=0 END IF
#      IF NOT cl_null(tm.b) THEN
#         IF sr.pjf06=0 THEN
#            LET l_rr=0
#         ELSE
#            LET l_rr=(sr.pjf06-sr.pjf08)/sr.pjf06*100
#         END IF
#         #-->最小差異率判斷
#         IF l_rr<tm.b  THEN
#               CONTINUE FOREACH
#         END IF                                          
#      END IF
       SELECT ima25 INTO sr.ima25 FROM ima_file WHERE ima01=sr.pjf03
     #MOD-930109 begin
       #SELECT SUM(pml09*pml20) INTO sr.amt
       #FROM pml_file,pjb_file,pjf_file
       #WHERE pml12=sr.pjb01 AND pml121=sr.pjb02 AND pml04=sr.pjf03
       #GROUP BY pml12,pml121
       SELECT SUM(pml09*pml20) INTO sr.amt
       FROM pml_file
       WHERE pml12=sr.pjb01 AND pml121=sr.pjb02 AND pml04=sr.pjf03
     #MOD-930109 end
       IF cl_null(sr.pjf05) THEN LET sr.pjf05=0 END IF
       IF cl_null(sr.amt) THEN LET sr.amt=0 END IF
       LET sr.diff = sr.pjf05 - sr.amt
       IF cl_null(sr.diff) THEN LET sr.diff=0 END IF
       IF tm.a='Y' THEN 
          IF sr.diff <= 0 THEN CONTINUE FOREACH END IF
       END IF
#No.FUN-830107 --End
     # OUTPUT TO REPORT r500_rep(sr.*)  #No.FUN-750101 
#No.FUN-750101  --begin--
#    EXECUTE insert_prep USING sr.pjb01,sr.pjb02,sr.pjb03,sr.pjb031,sr.pjf021,sr.pjf03,sr.pjf04,sr.pjf041,#No.FUN-830107
#                              sr.pjf05,sr.pjf07,sr.pjf06,sr.pjf08                                        #No.FUN-830107
     EXECUTE insert_prep USING sr.*     #No.FUN-830107                                          
#No.FUN-750101  --end--
     END FOREACH  
#No.FUN-750101  --BEGIN--
{
    # FINISH REPORT r500_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
}
     IF g_zz05='Y' THEN                                                                                                             
#       CALL cl_wcchp(tm.wc,'pjb01,pjb02,pjb03,pjb031,pjf03')          #No.FUN-830107 
        CALL cl_wcchp(tm.wc,'pjb01,pjb02,pjf03')                       #No.FUN-830107                                      
             RETURNING tm.wc                                                                                                        
        LET g_str=tm.wc                                                                                                             
     END IF          
#No.FUN-750101  --END--
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  #No.FUN-750101
     CALL cl_prt_cs3("apjr500","apjr500",l_sql,g_str)    #No.FUN-750101
 
END FUNCTION
 
#No.FUN-750101  --BEGIN--
{
REPORT r500_rep(sr)
   DEFINE
          l_last_sw     LIKE type_file.chr1,             #No.#FUN-680103  VARCHAR(1)
          l_cnt         LIKE type_file.num5,             #No.FUN-680103 SMALLINT
          sr         RECORD
                     pjb01     LIKE    pjb_file.pjb01,   #專案代號
                     pjb02     LIKE    pjb_file.pjb02,   #專案順序
                     pjb03     LIKE    pjb_file.pjb03,   #工作項目
                     pjb031    LIKE    pjb_file.pjb031,  #工作說明
                     pjf021    LIKE    pjf_file.pjf021,  #行序
                     pjf03     LIKE    pjf_file.pjf03,   #料件編號
                     pjf04     LIKE    pjf_file.pjf04,   #品名
                     pjf041    LIKE    pjf_file.pjf041,  #規格
                     pjf05     LIKE    pjf_file.pjf05,   #單位
                     pjf07     LIKE    pjf_file.pjf07,   #需求日期
                     pjf06     LIKE    pjf_file.pjf06,   #需求數量
                     pjf08     LIKE    pjf_file.pjf08    #已轉請購量
                     END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pjb01,sr.pjb02,sr.pjf021
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                    g_x[36],g_x[37],g_x[38]
      PRINTX name=H2 g_x[39],g_x[40],g_x[41]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.pjb01
      PRINTX name=D1 COLUMN  g_c[31],sr.pjb01;
   BEFORE GROUP OF sr.pjb02
      PRINTX name=D1 COLUMN g_c[32],sr.pjb02 USING '####';
      LET l_cnt =1
 
   ON EVERY ROW
      PRINTX name=D1 COLUMN g_c[33],sr.pjf03 CLIPPED,
                     COLUMN g_c[34],sr.pjf05,
                     COLUMN g_c[35],sr.pjf07,
                     COLUMN g_c[36],cl_numfor(sr.pjf06,36,2) CLIPPED,
                     COLUMN g_c[37],cl_numfor(sr.pjf08,37,2) CLIPPED,
                     COLUMN g_c[38],cl_numfor(sr.pjf06-sr.pjf08,38,2) CLIPPED
      IF l_cnt =1 THEN PRINTX name=D2 COLUMN g_c[39],sr.pjb031; END IF
      PRINTX name=D2 COLUMN g_c[40],sr.pjf04 CLIPPED,
                     COLUMN g_c[41],sr.pjf041 CLIPPED
      LET l_cnt=l_cnt + 1
 
   AFTER GROUP OF sr.pjb02
      PRINT ' '
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash
           #   IF tm.wc[001,80] > ' ' THEN			# for 132
           #	 PRINT g_x[8] CLIPPED,tm.wc[001,80] CLIPPED END IF
	#TQC-630166
	CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.MOD-590003
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED  #No.MOD-590003
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#No.FUN-750101  --END--
