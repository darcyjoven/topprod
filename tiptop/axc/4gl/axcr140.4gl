# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr140.4gl
# Descriptions...: 收貨明細表
# Input parameter: 
# Return code....: 
# Date & Author..: 95/12/04 By Alinna
# Modify.........: No.FUN-4C0099 04/12/28 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.FUN-570240 05/07/27 By Elva 月份改為期別處理方式 
# Modify.........: No.MOD-570087 05/07/05 By kim 沒有進行單位換算(tlf10->tlf10*tlf60)
# Modify.........: No.TQC-5A0022 05/10/13 By Claire 語法修正
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-610092 06/05/25 By Joe 增加庫存單位欄位
# Modify.........: No.FUN-670058 06/07/18 By Sarah axcr140_cs2增加抓取ima25,FOREACH段忘記INTO sr.ima25
# Modify.........: No.TQC-670030 06/07/20 By Claire 單據明細無法印出
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-670100 06/07/27 By Sarah 入出庫明細都沒有印出來
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換  
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/08 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-7C0101 08/01/25 By ChenMoyan 成本改善報表部分
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.MOD-B10067 11/01/10 By sabrina axcr140_cs1 cursor最後要多抓cca11,ccc11欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(300)      # Where condition
              yy      LIKE type_file.num5,           #No.FUN-680122SMALLINT
              mm      LIKE type_file.num5,           #No.FUN-680122SMALLINT
              type    LIKE type_file.chr1,           #No.FUN-7C0101
              more    LIKE type_file.chr1            #No.FUN-680122CHAR(1)         # Input more condition(Y/N)
              END RECORD,
          g_bdate LIKE type_file.dat,            #No.FUN-680122DATE
          g_edate LIKE type_file.dat,            #No.FUN-680122DATE
          l_tot2,l_tot3,l_tot4,l_tot5 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          g_tot_bal LIKE type_file.num20_6        #No.FUN-680122 DECIMAL(20,6)    # User defined variable
   DEFINE yy,mm LIKE type_file.num5           #No.FUN-680122SMALLINT
   DEFINE l_sw  LIKE type_file.chr1           #No.FUN-680122CHAR(01)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610051-begin
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   LET tm.type = ARG_VAL(13)
   #TQC-610051-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr140_tm(0,0)        # Input print condition
      ELSE CALL axcr140()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr140_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr140_w AT p_row,p_col WITH FORM "axc/42f/axcr140" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
#  LET tm.yy=year(g_today)  #No.FUN-570240
#  LET tm.mm=month(g_today) #No.FUN-570240
   LET tm.type = g_ccz.ccz28                 #No.FUN-7C0101
   CALL s_yp(g_today) RETURNING tm.yy,tm.mm  #No.FUN-570240 
   LEt l_tot2 = 0
   LET l_tot3 = 0
   LET l_tot4 = 0
   LEt l_tot5 = 0
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01,ima08,ima06,ima09,ima10,ima11,ima12
#No.FUN-570240 --start--                                                                                    
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp                                                                                              
            IF INFIELD(ima01) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO ima01                                                                                 
               NEXT FIELD ima01                                                                                                     
            END IF  
#No.FUN-570240 --end-- 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr140_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
  WHILE TRUE   #TQC-670030
  #INPUT BY NAME tm.yy,tm.mm,tm.more WITHOUT DEFAULTS                    #No.FUN-7C0101
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.more WITHOUT DEFAULTS            #No.FUN-7C0101
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
 
      AFTER FIELD type                                                   #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF    #No.FUN-7C0101
 
      AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
##No.FUN-570240 --start--                                                                                    
#         IF cl_null(tm.mm) OR tm.mm < 1 OR tm.mm > 13 THEN
#            NEXT FIELD mm
#         END IF
#No.TQC-720032 -- end --
         CALL s_lsperiod(tm.yy,tm.mm) RETURNING yy,mm
    #    IF tm.mm = 1 THEN
    #       LET mm = 12
    #       LET yy = tm.yy-1
    #    ELSE
    #       LET mm = tm.mm -1
    #       LET yy = tm.yy
    #    END IF
#No.FUN-570240 --end--                                                                                    
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                               g_bgjob,g_time,g_prtway,g_copies)
                     RETURNING g_pdate,g_towhom,g_rlang,
                               g_bgjob,g_time,g_prtway,g_copies
         END IF
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()    # Command execution
 
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
      CLOSE WINDOW axcr140_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 #TQC-670030-begin
   IF cl_null(tm.mm) OR tm.mm < 1 OR tm.mm > 13 THEN
      CONTINUE WHILE 
   END IF
   CALL s_lsperiod(tm.yy,tm.mm) RETURNING yy,mm
   IF (cl_null(yy) OR yy=0 OR cl_null(mm) OR mm=0) THEN CONTINUE WHILE END IF
   EXIT WHILE 
  END WHILE
 #TQC-670030-end
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr140'
 
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr140','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",                #TQC-610051
                         " '",tm.mm CLIPPED,"'",                #TQC-610051
                         " '",tm.mm CLIPPED,"'",                #No.FUN-7C0101
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axcr140',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr140_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr140()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr140_w
END FUNCTION
 
FUNCTION axcr140()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     STRING,   #CHAR(1000),        # RDSQL STATEMENT   #FUN-670058 modify
          l_sql1    LIKE type_file.chr1000,       #No.FUN-680122CHAR(600)
          l_sql2    LIKE type_file.chr1000,       #No.FUN-680122CHAR(600)
          l_chr     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          xxx       LIKE aab_file.aab02,           #No.FUN-680122CHAR(5),        #No.FUN-550025
          u_sign    LIKE type_file.num5,           #No.FUN-680122SMALLINT,
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(50)
          l_order    ARRAY[5] OF LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)
          l_ima53   LIKE ima_file.ima53,
          l_ima91   LIKE ima_file.ima91,
          l_ima531  LIKE ima_file.ima531,
          l_tlf13  LIKE tlf_file.tlf13,
          l_smydmy1   LIKE smy_file.smydmy1,
          l_cca11  LIKE cca_file.cca11,
          l_ccc11  LIKE ccc_file.ccc11,
          sr   RECORD 
               ima01   LIKE ima_file.ima01,    #料號
               ima02   LIKE ima_file.ima02,    #品名
               ima021  LIKE ima_file.ima021,   #規格   #FUN-5A0059
               tlfccost LIKE tlfc_file.tlfccost,  #No.FUN-7C0101
               ima25   LIKE ima_file.ima25,    #庫存單位  ##NO.FUN-610092
               tlf026  LIKE tlf_file.tlf026,   #單據單號
               desc    LIKE smy_file.smydesc,  #單據名稱
               tlf06   LIKE tlf_file.tlf06,    #單據日期 
               tlf10   LIKE tlf_file.tlf10,    #數量     
               code    LIKE type_file.chr1,           #No.FUN-680122CHAR(1)                #1:領;2:退
               tlf62   LIKE tlf_file.tlf62     #數量     
               END RECORD
 
    #TQC-670030-begin
     LET l_tot2 = 0
     LET l_tot3 = 0
     LET l_tot4 = 0
     LET l_tot5 = 0
    #TQC-670030-end
 
     CALL s_azn01(tm.yy,tm.mm) RETURNING g_bdate,g_edate
     CALL s_lsperiod(tm.yy,tm.mm) RETURNING yy,mm   #FUN-670058 add
 
 
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
 
 
     CALL cl_outnam('axcr140') RETURNING l_name
 
     #No.FUN-7C0101--start--                                                                                                        
     IF tm.type MATCHES '[12]' THEN                                                                                                 
        LET g_zaa[42].zaa06='Y'                                                                                                     
     END IF                                                                                                                         
     IF tm.type MATCHES '[345]' THEN                                                                                                
        LET g_zaa[42].zaa06='N'                                                                                                     
     END IF                                                                                                                         
     #No.FUN-7C0101---end---   
 
     START REPORT axcr140_rep TO l_name
 
    #LET l_sql1 = " SELECT ima01,ima02,cca11 FROM ima_file,cca_file",        #FUN-5A0059 mark
   ##LET l_sql1 = " SELECT ima01,ima02,ima021,cca11 FROM ima_file,cca_file",       ##NO.FUN-610092
    #LET l_sql1 = " SELECT ima01,ima02,ima021,ima25,cca11 FROM ima_file,cca_file", ##NO.FUN-610092 #No.FUN-7C0101
     LET l_sql1 = " SELECT ima01,ima02,ima021,ima25,cca07,cca11 FROM ima_file,cca_file",           #No.FUN-7C0101
                  "  WHERE ima01 = cca01",
                  "    AND cca02 = ",yy,
                  "    AND cca03 = ",mm,
                  "    AND cca06 ='",tm.type,"'",                 #No.FUN-7C0101
                  "    AND ",tm.wc
 
     PREPARE axcr140_re FROM l_sql1
     DECLARE axcr140_cs2 CURSOR FOR axcr140_re
     INITIALIZE sr.* ,l_ccc11 TO NULL
    #FOREACH axcr140_cs2 INTO sr.ima01,sr.ima02,l_cca11           #FUN-5A0059 mark
    #FOREACH axcr140_cs2 INTO sr.ima01,sr.ima02,sr.ima021,l_cca11 #FUN-5A0059            #FUN-670058 mark
     FOREACH axcr140_cs2 INTO sr.ima01,sr.ima02,sr.ima021,sr.ima25,l_cca11 #FUN-5A0059   #FUN-670058 add sr.ima25
       OUTPUT TO REPORT axcr140_rep (sr.*,l_cca11,l_ccc11)
     END FOREACH
    #LET l_sql2 = " SELECT ima01,ima02,ccc11 FROM ima_file,ccc_file",         #FUN-5A0059 mark
   ##LET l_sql2 = " SELECT ima01,ima02,ima021,ccc11 FROM ima_file,ccc_file",        ##NO.FUN-610092
    #LET l_sql2 = " SELECT ima01,ima02,ima021,ima25,ccc11 FROM ima_file,ccc_file",  ##NO.FUN-610092 #No.FUN-7C0101
     LET l_sql2 = " SELECT ima01,ima02,ima021,ima25,ccc08,ccc11 FROM ima_file,ccc_file",            #No.FUN-7C0101
                  "  WHERE ima01 =ccc01",
                  "    AND ccc02 = ",tm.yy,
                  "    AND ccc03 = ",tm.mm,
                  "    AND ccc07 ='",tm.type,"'",                  #No.FUN-7C0101
                  "    AND ",tm.wc
 
     PREPARE axcr140_re1 FROM l_sql2
     DECLARE axcr140_cs3 CURSOR FOR axcr140_re1
     INITIALIZE sr.* ,l_cca11 TO NULL
    #FOREACH axcr140_cs3 INTO sr.ima01,sr.ima02,l_ccc11            #FUN-5A0059 mark
   ##FOREACH axcr140_cs3 INTO sr.ima01,sr.ima02,sr.ima021,l_ccc11           ##NO.FUN-610092
     FOREACH axcr140_cs3 INTO sr.ima01,sr.ima02,sr.ima021,sr.ima25,l_ccc11  ##NO.FUN-610092
       OUTPUT TO REPORT axcr140_rep(sr.*,l_cca11,l_ccc11)
     END FOREACH
       
     #LET l_sql = " SELECT ima01,ima02,tlf026,' ',tlf06,tlf10*tlf60,'1',tlf62,tlf13 ", #MOD-570087          #FUN-5A0059 mark
    ##LET l_sql = " SELECT ima01,ima02,ima021,tlf026,' ',tlf06,tlf10*tlf60,'1',tlf62,tlf13 ",        ##NO.FUN-610092
     LET l_sql = " SELECT ima01,ima02,ima021,ima25,tlf026,' ',tlf06,tlf10*tlf60,'1',tlf62,tlf13 ",
                 "        ,cca11,ccc11 ",               #MOD-B10067 add
                 "   FROM ima_file LEFT OUTER JOIN ccc_file ON ima01=ccc01 LEFT OUTER JOIN cca_file ON ima01=cca01,tlf_file",
                 "  WHERE tlf02=50 ",
                 "    AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,
                 "'   AND tlf01=ima01 AND ",tm.wc CLIPPED,
                 "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
                 "    AND ccc02 = '",tm.yy,"' AND ccc03 = '",tm.mm,"'",
                 #"    AND cca02 = '",yy,"' AND cca03 = '",mm,"'",   #FUN-670100 mark
                  "    AND ccc07 = '",tm.type,"'",                   #No.FUN-7C0101
                  "    AND cca06 = '",tm.type,"'",                   #No.FUN-7C0101
                 " UNION ALL ",
                 " SELECT ima01,ima02,ima021,ima25,tlf036,' ',tlf06,tlf10*tlf60,'2',tlf62,tlf13 ",
                 "        ,cca11,ccc11 ",               #MOD-B10067 add
                 "   FROM ima_file LEFT OUTER JOIN ccc_file ON ima01=ccc01 LEFT OUTER JOIN cca_file ON ima01=cca01,tlf_file",
                 "  WHERE tlf03=50 ",
                 "    AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,
                 "'   AND tlf01=ima01 AND ",tm.wc CLIPPED,
                 "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
                 "    AND ccc02 = '",tm.yy,"' AND ccc03 = '",tm.mm,"'" 
                 #"    AND cca02 = '",yy,"' AND cca03 = '",mm,"'"    #FUN-670100 mark
                 ,"    AND ccc07 = '",tm.type,"'",                   #FUN-7C0101
                  "    AND cca06 = '",tm.type,"'"                    #FUN-7C0101
 
     PREPARE axcr140_pr FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr140_cs1 CURSOR FOR axcr140_pr
 
     #CALL cl_outnam('axcr140') RETURNING l_name
     #START REPORT axcr140_rep TO l_name
     LET g_pageno = 0
     INITIALIZE l_cca11 ,l_ccc11 TO NULL
     FOREACH axcr140_cs1 INTO sr.*,l_tlf13,l_cca11,l_ccc11          #MOD-B10067 add l_cca11,l_ccc11
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     #No.FUN-550025 --start--
     #  LET xxx=sr.tlf026[1,3] 
        CALL s_get_doc_no(sr.tlf026) RETURNING xxx
     #No.FUN-550025 --end--  
        SELECT smydesc,smydmy1 INTO sr.desc,l_smydmy1 FROM smy_file 
              WHERE smyslip=xxx
        IF sr.code='1' THEN LET sr.tlf10=sr.tlf10*(-1)  END IF
        IF l_tlf13[1,3] != 'asf' THEN LET sr.tlf62 = ' ' END IF
        IF sr.tlf10 IS NULL OR sr.tlf10 = ' ' THEN
           LEt sr.tlf10 = 0
        END IF
        IF l_smydmy1 = 'N' THEN CONTINUE FOREACH END IF
          OUTPUT TO REPORT axcr140_rep(sr.*,l_cca11,l_ccc11)
     END FOREACH
 
     FINISH REPORT axcr140_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT axcr140_rep(sr,c_cc,c_cc1) 
 #  DEFINE qty          LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
   DEFINE qty          LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
          u_p          LIKE oeb_file.oeb13,           #No.FUN-680122DEC(20,6)
          amt          LIKE type_file.num20_6         #No.FUN-680122 DECIMAL(20,6)
   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
          l_tot,l_tot1  LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6)
          l_tt1,l_tt  LIKE tlf_file.tlf10,
          sr   RECORD 
               ima01   LIKE ima_file.ima01,    #工單單號
               ima02   LIKE ima_file.ima02,    #品名
               ima021  LIKE ima_file.ima021,   #規格   #FUN-5A0059
               tlfccost LIKE tlfc_file.tlfccost, #No.FUN-7C0101
               ima25   LIKE ima_file.ima25,    #庫存單位  ##NO.FUN-610092
               tlf026  LIKE tlf_file.tlf026,   #單據單號
               desc    LIKE smy_file.smydesc,  #單據名稱
               tlf06   LIKE tlf_file.tlf06,    #單據日期 
               tlf10   LIKE tlf_file.tlf10,    #數量     
               code    LIKE type_file.chr1,           #No.FUN-680122CHAR(1)                #1:領;2:退
               tlf62   LIKE tlf_file.tlf62     #數量     
               END RECORD,
      l_qty        LIKE type_file.num10,          #No.FUN-680122INTEGER
      c_cc         LIKE ccc_file.ccc11,
      c_cc1        LIKE ccc_file.ccc11,
      l_amt        LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6)
      l_chr        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.ima01,sr.tlf06,sr.code,sr.tlf026
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[9] CLIPPED,tm.yy USING '####',' ',
            g_x[10] CLIPPED,tm.mm USING '##'
      PRINT g_dash
  #   PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35], #No.FUN-7C0101
      PRINT g_x[31],g_x[32],g_x[33],g_x[42],g_x[34],g_x[35], #No.FUN-7C0101
        ##  g_x[36],g_x[37],g_x[38],g_x[39]         ##NO.FUN-610092
            g_x[36],g_x[37],g_x[41],g_x[38],g_x[39] ##NO.FUN-610092
           ,g_x[40]   #FUN-5A0059
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ima01
       LEt l_tt = 0
       LET l_tt1 = 0
       IF c_cc IS NULL THEN
         IF c_cc1 IS NOT NULL THEN
            LEt c_cc = c_cc1
         ELSE
             LET c_cc = 0
         END IF
       END IF
       PRINT COLUMN g_c[31],sr.ima01 CLIPPED,
             COLUMN g_c[32],sr.ima02 CLIPPED,
            #start FUN-5A0059
             COLUMN g_c[33],sr.ima021 CLIPPED,
             COLUMN g_c[42],sr.tlfccost CLIPPED,#No.FUN-7C0101
             COLUMN g_c[41],sr.ima25 CLIPPED,  ##NO.FUN-610092
             COLUMN g_c[38],g_x[13] CLIPPED,
             COLUMN g_c[39],cl_numfor(c_cc,39,g_ccz.ccz27) #CHI-690007 0->g_ccz.ccz27
            #end FUN-5A0059
       LET l_tot1 = c_cc
       LET l_tot5 = l_tot5 + l_tot1
   ON EVERY ROW             
      IF sr.tlf06 IS NOT NULL THEN
        #start FUN-5A0059
         PRINT COLUMN g_c[34],sr.tlf06,
               COLUMN g_c[35],sr.tlf026,
               COLUMN g_c[36],sr.desc,
               COLUMN g_c[37],sr.tlf62;   #TQC-670030 38->37
        #end FUN-5A0059
         IF sr.code = '2' THEN
            PRINT COLUMN g_c[38],cl_numfor(sr.tlf10,38,g_ccz.ccz27)   #FUN-5A0059 #CHI-690007 0->g_ccz.ccz27
            LEt l_tt = l_tt + sr.tlf10
            LET l_tot2 = l_tot2 + sr.tlf10
         ELSE
            PRINT COLUMN g_c[39],cl_numfor(sr.tlf10,39,g_ccz.ccz27)   #FUN-5A0059 #CHI-690007 0->g_ccz.ccz27
            LET l_tt1 = l_tt1 + sr.tlf10
            LET l_tot3 = l_tot3 + sr.tlf10
         END IF
      ELSE
          LEt sr.tlf10 = 0
      END IF
 
   AFTER GROUP OF sr.ima01 
         PRINT COLUMN g_c[40],cl_numfor(l_tt+l_tt1,40,g_ccz.ccz27)   #FUN-5A0059 #CHI-690007 0->g_ccz.ccz27
         PRINT 
#        PRINT g_dash2
        #start FUN-5A0059
         PRINT COLUMN g_c[38],g_dash2[1,g_w[38]],
               COLUMN g_c[39],g_dash2[1,g_w[39]],
               COLUMN g_c[40],g_dash2[1,g_w[40]]
        #end FUN-5A0059
 
         LET l_tot = GROUP SUM(sr.tlf10)
         IF cl_null(l_tot) THEN LET  l_tot = 0 END IF
         IF cl_null(l_tot1) THEn LET l_tot1 = 0 END IF
        #start FUN-5A0059
         PRINT COLUMN g_c[37],g_x[11] CLIPPED,
               COLUMN g_c[38],cl_numfor(l_tt,38,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
               COLUMN g_c[39],cl_numfor(l_tt1,39,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
               COLUMN g_c[40],cl_numfor(l_tot+ l_tot1,40,g_ccz.ccz27) #CHI-690007 0->g_ccz.ccz27
        #end FUN-5A0059
         LET l_tot4 = l_tot4 + l_tt+l_tt1+l_tot1
 
   ON LAST ROW
     #start FUN-5A0059
      PRINT COLUMN g_c[37],g_dash2[1,g_w[37]],
            COLUMN g_c[38],g_dash2[1,g_w[38]],
            COLUMN g_c[39],g_dash2[1,g_w[39]],
            COLUMN g_c[40],g_dash2[1,g_w[40]]
      PRINT COLUMN g_c[36],g_x[12] CLIPPED,
            #TQC-5A0022-begin加入COLUMN
            COLUMN g_c[37],cl_numfor(l_tot5,37,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
            COLUMN g_c[38],cl_numfor(l_tot2,38,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
            COLUMN g_c[39],cl_numfor(l_tot3,39,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
            COLUMN g_c[40],cl_numfor(l_tot5+l_tot2+l_tot3,40,g_ccz.ccz27) #CHI-690007 0->g_ccz.ccz27
            #TQC-5A0022-end
     #end FUN-5A0059
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
