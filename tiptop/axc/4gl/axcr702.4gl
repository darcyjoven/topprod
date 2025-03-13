# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axcr702.4gl
# Descriptions...: 庫房移轉月報表
# Input parameter: 
# Return code....: 
# Date & Author..: 98/12/21 By ANN CHEN
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4C0099 05/01/03 By kim 報表轉XML功能
# Modify.........: No.MOD-530788 05/03/28 By pengu  倉庫只顯示2位，應顯示10位
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/06 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-570082 05/07/05 By kim 沒有進行單位換算(tlf10->tlf10*tlf60)
# Modify.........: No.FUN-630038 06/03/21 By Claire 少計加工,其他
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/13 By ice 修正報表格式錯誤
# Modify.........: No.CHI-690007 06/12/27 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-7C0101 08/01/30 By douzh 成本改善功能增加成本計算類型(type)
# Modify.........: No.FUN-830002 08/03/03 By lala    WHERE條件修改
# Modify.........: No.FUN-830140 08/04/09 By douzh   給tlccost賦初值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(300)     # Where condition
              bdate   LIKE type_file.dat,           #No.FUN-680122 DATE
              edate   LIKE type_file.dat,           #No.FUN-680122 DATE
              type    LIKE type_file.chr1,          #No.FUN-7C0101
              more    LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)        # Input more condition(Y/N)
              END RECORD,
          l_orderA ARRAY[2] OF LIKE cre_file.cre08            #No.FUN-680122CHAR(10)
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
 
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.type = ARG_VAL(13)          #FUN-7C0101
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
  
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL axcr702_tm(0,0)
      ELSE CALL axcr702()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
END MAIN
 
FUNCTION axcr702_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr702_w AT p_row,p_col
        WITH FORM "axc/42f/axcr702" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more= 'N'
   LET tm.type=g_ccz.ccz28                         #No.FUN-7C0101
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima12,ima01
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
 
#No.FUN-570240 --start                                                          
     ON ACTION controlp                                                      
        IF INFIELD(ima01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ima01                             
           NEXT FIELD ima01                                                 
        END IF                                                              
#No.FUN-570240 --end     
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr702_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.more 
      WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
        IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
      AFTER FIELD edate
        IF cl_null(tm.edate) OR tm.edate<tm.bdate THEN NEXT FIELD edate END IF
       AFTER FIELD type                                                            #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF              #No.FUN-7C0101
 
      AFTER FIELD more
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr702_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr702'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr702','9031',1)   
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
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",              #No.FUN-7C0101
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
         CALL cl_cmdat('axcr702',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr702_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr702()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr702_w
END FUNCTION
 
FUNCTION axcr702()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_chr     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          l_yy,l_mm LIKE type_file.num5,           #No.FUN-680122SMALLINT
          l_order    ARRAY[5] OF LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)
          sr               RECORD ima12    LIKE ima_file.ima12,
                                  ima01    LIKE ima_file.ima01,
                                  ima02    LIKE ima_file.ima02,
                                  ima021   LIKE ima_file.ima021,   #FUN-4C0099
                                  tlf031   LIKE tlf_file.tlf031,
                                  tlf021   LIKE tlf_file.tlf021,
                                  tlf06    LIKE tlf_file.tlf06,
                                  tlf036   LIKE tlf_file.tlf036,
                                  tlf01    LIKE tlf_file.tlf01,
                                  tlf10    LIKE tlf_file.tlf10,
                                  tlf13    LIKE tlf_file.tlf13,
                                  tlf02    LIKE tlf_file.tlf02,
                                  tlf03    LIKE tlf_file.tlf03,
                                  tlf907   LIKE tlf_file.tlf907,
                                  tlfccost LIKE tlfc_file.tlfccost, #類別編號 #No.FUN-7C0101
                                  amt01    LIKE ccc_file.ccc23a,  #材料金額
                                  amt02    LIKE ccc_file.ccc23b,  #人工金額     
                                  amt03    LIKE ccc_file.ccc23c,  #製造費用                --制費一 No.FUN-7C0101        
                                  amt05    LIKE ccc_file.ccc23d,  #加工費用   #FUN-630038
                                  amt06    LIKE ccc_file.ccc23e,  #其他費用   #FUN-630038  --制費二 #No.FUN-7C0101
                                  amt07    LIKE ccc_file.ccc23f,  #制費三     #No.FUN-7C0101
                                  amt08    LIKE ccc_file.ccc23g,  #制費四     #No.FUN-7C0101
                                  amt09    LIKE ccc_file.ccc23h,  #制費五     #No.FUN-7C0101
                                  amt04    LIKE ccc_file.ccc23    #總金額
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT ima12,ima01,ima02,ima021,",
                 "   tlf031,tlf021,tlf06,tlf036,tlf01,tlf10*tlf60,tlf13,", #MOD-570082
                 "   tlf02,tlf03,tlf907,tlfccost,0,0,0,0,0,0",    #FUN-630038 add 0,0    #No.FUN-7C0101
                 "  FROM tlf_file LEFT OUTER JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 , ima_file",     #No.FUN-7C0101
                 " WHERE ima01 = tlf01",
                 "   AND (tlf13 = 'aimt324')",
                 "   AND (tlf02 = '50' OR tlf03 = '50')",
                 "   AND tlfc_file.tlfctype = '",tm.type,"'",               #No.FUN-7C0101 
                 "   AND ",tm.wc CLIPPED,
                 "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
                 "   AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')"
 
     PREPARE axcr702_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr702_curs1 CURSOR FOR axcr702_prepare1
 
     CALL cl_outnam('axcr702') RETURNING l_name
 
#No.FUN-7C0101--begin
     IF tm.type MATCHES '[12]' THEN
        LET g_zaa[44].zaa06 = "Y" 
     ELSE
        LET g_zaa[44].zaa06 = "N"
     END IF
     CALL cl_prt_pos_len()
#No.FUN-7C0101--end
 
     START REPORT axcr702_rep TO l_name
     LET g_pageno = 0
     FOREACH axcr702_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_yy = YEAR(sr.tlf06)
       LET l_mm = MONTH(sr.tlf06)
       IF sr.tlfccost IS NULL THEN LET sr.tlfccost=' ' END IF                    #No.FUN-830140
       SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,ccc23f,ccc23g,ccc23h           #FUN-630038 add ccc23d,23e  #FUN-7C0101 add ccc23f,23g,23h
         INTO sr.amt01,sr.amt02,sr.amt03,sr.amt05,sr.amt06,                     #FUN-630038 add amt05,06
              sr.amt07,sr.amt08,sr.amt09                                        #No.FUN-7C0101 add amt07,08,09
         FROM ccc_file
        WHERE ccc01 = sr.tlf01
          AND ccc02 = l_yy
          AND ccc03 = l_mm
          AND ccc07 = tm.type                                                   #No.FUN-7C0101
          AND ccc08 = sr.tlfccost                                               #No.FUN-7C0101
       IF SQLCA.sqlcode THEN 
          LET sr.amt01 = 0 LET sr.amt02 = 0 LET sr.amt03 = 0 
       END IF
       IF sr.tlf02='50' THEN
          LET sr.amt01 = sr.amt01 * (-1) * sr.tlf10
          LET sr.amt02 = sr.amt02 * (-1) * sr.tlf10
          LET sr.amt03 = sr.amt03 * (-1) * sr.tlf10
          LET sr.amt05 = sr.amt05 * (-1) * sr.tlf10       #FUN-630038
          LET sr.amt06 = sr.amt06 * (-1) * sr.tlf10       #FUN-630038 
          LET sr.amt07 = sr.amt07 * (-1) * sr.tlf10       #No.FUN-7C0101 
          LET sr.amt08 = sr.amt08 * (-1) * sr.tlf10       #No.FUN-7C0101
          LET sr.amt09 = sr.amt09 * (-1) * sr.tlf10       #No.FUN-7C0101
          LET sr.amt04 = sr.amt01 + sr.amt02 + sr.amt03 + sr.amt05 + sr.amt06  #FUN-630038 add amt05,amt06
                       + sr.amt07 + sr.amt08 + sr.amt09                        #No.FUN-7C0101
          LET sr.tlf10 = sr.tlf10 * (-1)
       ELSE 
          LET sr.amt01 = sr.amt01 * sr.tlf10
          LET sr.amt02 = sr.amt02 * sr.tlf10
          LET sr.amt03 = sr.amt03 * sr.tlf10
          LET sr.amt05 = sr.amt05 * sr.tlf10       #FUN-630038
          LET sr.amt06 = sr.amt06 * sr.tlf10       #FUN-630038 
          LET sr.amt07 = sr.amt07 * sr.tlf10       #No.FUN-7C0101 
          LET sr.amt08 = sr.amt08 * sr.tlf10       #No.FUN-7C0101
          LET sr.amt09 = sr.amt09 * sr.tlf10       #No.FUN-7C0101
          LET sr.amt04 = sr.amt01 + sr.amt02 + sr.amt03 + sr.amt05 + sr.amt06  #FUN-630038  add amt05,amt06
                       + sr.amt07 + sr.amt08 + sr.amt09                        #No.FUN-7C0101
       END IF
       LET sr.tlf06 = sr.tlf06 USING "YYYYMMDD"
       OUTPUT TO REPORT axcr702_rep(sr.*)
     END FOREACH
 
     FINISH REPORT axcr702_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT axcr702_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
          l_tmpstr     STRING,
           sr           RECORD ima12  LIKE ima_file.ima12,
                               ima01  LIKE ima_file.ima01,
                               ima02  LIKE ima_file.ima02,
                               ima021   LIKE ima_file.ima021,   #FUN-4C0099
                               tlf031 LIKE tlf_file.tlf031,
                               tlf021 LIKE tlf_file.tlf021,
                               tlf06  LIKE tlf_file.tlf06,
                               tlf036 LIKE tlf_file.tlf036,
                               tlf01  LIKE tlf_file.tlf01,
                               tlf10  LIKE tlf_file.tlf10,
                               tlf13  LIKE tlf_file.tlf13,
                               tlf02  LIKE tlf_file.tlf02,
                               tlf03  LIKE tlf_file.tlf03,
                               tlf907 LIKE tlf_file.tlf907,
                               tlfccost LIKE tlfc_file.tlfccost,#類別編號     #No.FUN-7C0101
                               amt01  LIKE ccc_file.ccc23a,    #材料金額
                               amt02  LIKE ccc_file.ccc23b,    #人工金額
                               amt03  LIKE ccc_file.ccc23c,    #製造費用                --制費一 No.FUN-7C0101        
                               amt05  LIKE ccc_file.ccc23d,    #加工費用   #FUN-630038
                               amt06  LIKE ccc_file.ccc23e,    #其他費用   #FUN-630038  --制費二 #No.FUN-7C0101
                               amt07  LIKE ccc_file.ccc23f,    #制費三     #No.FUN-7C0101
                               amt08  LIKE ccc_file.ccc23g,    #制費四     #No.FUN-7C0101
                               amt09  LIKE ccc_file.ccc23h,    #制費五     #No.FUN-7C0101
                               amt04  LIKE ccc_file.ccc23      #總金額
                        END RECORD,
      l_Itlf10,l_Otlf10,l_Subtlf10,l_Tottlf10 LIKE type_file.num10,          #No.FUN-680122INTGER
      l_Iamt01,l_Oamt01,l_Subamt01,l_Totamt01 LIKE ccc_file.ccc23a,
      l_Iamt02,l_Oamt02,l_Subamt02,l_Totamt02 LIKE ccc_file.ccc23b,
      l_Iamt03,l_Oamt03,l_Subamt03,l_Totamt03 LIKE ccc_file.ccc23c,
      l_Iamt04,l_Oamt04,l_Subamt04,l_Totamt04 LIKE ccc_file.ccc23,
      l_Iamt05,l_Oamt05,l_Subamt05,l_Totamt05 LIKE ccc_file.ccc23d,  #FUN-630038
      l_Iamt06,l_Oamt06,l_Subamt06,l_Totamt06 LIKE ccc_file.ccc23e,  #FUN-630038 
      l_Iamt07,l_Oamt07,l_Subamt07,l_Totamt07 LIKE ccc_file.ccc23f,  #No.FUN-7C0101
      l_Iamt08,l_Oamt08,l_Subamt08,l_Totamt08 LIKE ccc_file.ccc23g,  #No.FUN-7C0101
      l_Iamt09,l_Oamt09,l_Subamt09,l_Totamt09 LIKE ccc_file.ccc23h,  #No.FUN-7C0101
      l_azf03        LIKE azf_file.azf03,
      l_chr        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
  ORDER BY sr.ima12,sr.tlf06,sr.tlf036,sr.tlf01,sr.tlf907 desc
  FORMAT
   PAGE HEADER
      IF PAGENO = 1 THEN 
         LET l_Tottlf10 = 0
         LET l_Totamt01 = 0
         LET l_Totamt02 = 0
         LET l_Totamt03 = 0
         LET l_Totamt04 = 0
         LET l_Totamt05 = 0    #FUN-630038
         LET l_Totamt06 = 0    #FUN-630038
         LET l_Totamt07 = 0    #No.FUN-7C0101
         LET l_Totamt08 = 0    #No.FUN-7C0101
         LET l_Totamt09 = 0    #No.FUN-7C0101
      END IF
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      LET l_tmpstr=g_x[9] CLIPPED,' ',tm.bdate ," - ",tm.edate
      PRINT COLUMN ((g_len-FGL_WIDTH(l_tmpstr))/2)+1,l_tmpstr
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[44],g_x[37],g_x[38],g_x[39],g_x[40],       #No.FUN-7C0101 add[44]
            g_x[42],g_x[43],g_x[45],g_x[46],g_x[47],g_x[41]        #FUN-630038 add[42,43] #No.FUN-7C0101 add[45,46,47]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
    BEFORE GROUP OF sr.ima12     #group code
      LET l_Itlf10 = 0   LET l_Otlf10 = 0
      LET l_Iamt01 = 0   LET l_Oamt01 = 0
      LET l_Iamt02 = 0   LET l_Oamt02 = 0
      LET l_Iamt03 = 0   LET l_Oamt03 = 0
      LET l_Iamt04 = 0   LET l_Oamt04 = 0
      LET l_Iamt05 = 0   LET l_Oamt05 = 0            #FUN-630038
      LET l_Iamt06 = 0   LET l_Oamt06 = 0            #FUN-630038   
      LET l_Iamt07 = 0   LET l_Oamt07 = 0            #No.FUN-7C0101  
      LET l_Iamt08 = 0   LET l_Oamt08 = 0            #No.FUN-7C0101   
      LET l_Iamt09 = 0   LET l_Oamt09 = 0            #No.FUN-7C0101
      LET l_Subtlf10 = 0
      LET l_Subamt01 = 0
      LET l_Subamt02 = 0
      LET l_Subamt03 = 0
      LET l_Subamt04 = 0
      LET l_Subamt05 = 0    #FUN-630038
      LET l_Subamt06 = 0    #FUN-630038
      LET l_Subamt07 = 0    #No.FUN-7C0101
      LET l_Subamt08 = 0    #No.FUN-7C0101
      LET l_Subamt09 = 0    #No.FUN-7C0101
 
   ON EVERY ROW
      IF sr.tlf02 = '50' THEN
          PRINT COLUMN g_c[31],sr.tlf021;    #No.MOD-530788
      ELSE
          PRINT COLUMN g_c[31],sr.tlf031;    #No.MOD-530788
      END IF
      PRINT COLUMN g_c[32], sr.tlf06,
            COLUMN g_c[33], sr.tlf036,   
            COLUMN g_c[34], sr.tlf01,
            COLUMN g_c[35], sr.ima02 CLIPPED, #MOD-4A0238
            COLUMN g_c[36], sr.ima021 CLIPPED, 
            COLUMN g_c[44], sr.tlfccost CLIPPED,                #FUN-7C0101
            COLUMN g_c[37], cl_numfor(sr.tlf10,37,g_ccz.ccz27), #CHI-690007
            COLUMN g_c[38], cl_numfor(sr.amt01,38,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26 
            COLUMN g_c[39], cl_numfor(sr.amt02,39,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26 
            COLUMN g_c[40], cl_numfor(sr.amt03,40,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26 
            COLUMN g_c[42], cl_numfor(sr.amt05,42,g_ccz.ccz26),      #FUN-630038 #CHI-C30012 g_azi03->g_ccz.ccz26 
            COLUMN g_c[43], cl_numfor(sr.amt06,43,g_ccz.ccz26),      #FUN-630038 #CHI-C30012 g_azi03->g_ccz.ccz26 
            COLUMN g_c[45], cl_numfor(sr.amt07,45,g_ccz.ccz26),      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26 
            COLUMN g_c[46], cl_numfor(sr.amt08,46,g_ccz.ccz26),      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26 
            COLUMN g_c[47], cl_numfor(sr.amt09,47,g_ccz.ccz26),      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26 
            COLUMN g_c[41], cl_numfor(sr.amt04,41,g_ccz.ccz26)       #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26 
      IF sr.tlf02 = '50' THEN
         LET l_Oamt01 =l_Oamt01 + sr.amt01
         LET l_Oamt02 =l_Oamt02 + sr.amt02
         LET l_Oamt03 =l_Oamt03 + sr.amt03
         LET l_Otlf10 =l_Otlf10 + sr.tlf10
         LET l_Oamt04 =l_Oamt04 + sr.amt04
         LET l_Oamt05 =l_Oamt05 + sr.amt05                     #FUN-630038
         LET l_Oamt06 =l_Oamt06 + sr.amt06                     #FUN-630038
         LET l_Oamt07 =l_Oamt07 + sr.amt07                     #No.FUN-7C0101
         LET l_Oamt08 =l_Oamt08 + sr.amt08                     #No.FUN-7C0101
         LET l_Oamt09 =l_Oamt09 + sr.amt09                     #No.FUN-7C0101
      END IF
      IF sr.tlf03 = '50' THEN
         LET l_Iamt01 =l_Iamt01 + sr.amt01
         LET l_Iamt02 =l_Iamt02 + sr.amt02
         LET l_Iamt03 =l_Iamt03 + sr.amt03
         LET l_Itlf10 =l_Itlf10 + sr.tlf10
         LET l_Iamt04 =l_Iamt04 + sr.amt04
         LET l_Iamt05 =l_Iamt05 + sr.amt05                     #FUN-630038   
         LET l_Iamt06 =l_Iamt06 + sr.amt06                     #FUN-630038 
         LET l_Iamt07 =l_Iamt07 + sr.amt07                     #No.FUN-7C0101 
         LET l_Iamt08 =l_Iamt08 + sr.amt08                     #No.FUN-7C0101 
         LET l_Iamt09 =l_Iamt09 + sr.amt09                     #No.FUN-7C0101 
      END IF
 
   AFTER GROUP OF sr.ima12  
      PRINT
      PRINT COLUMN g_c[36],g_dash2[1,g_w[36]],
            COLUMN g_c[44],g_dash2[1,g_w[44]],   #No.FUN-7C0101
            COLUMN g_c[37],g_dash2[1,g_w[37]],
            COLUMN g_c[38],g_dash2[1,g_w[38]],
            COLUMN g_c[39],g_dash2[1,g_w[39]],
            COLUMN g_c[40],g_dash2[1,g_w[40]],
            COLUMN g_c[42],g_dash2[1,g_w[42]],   #FUN-630038
            COLUMN g_c[43],g_dash2[1,g_w[43]],   #FUN-630038
            COLUMN g_c[45],g_dash2[1,g_w[45]],   #No.FUN-7C0101
            COLUMN g_c[46],g_dash2[1,g_w[46]],   #No.FUN-7C0101
            COLUMN g_c[47],g_dash2[1,g_w[47]],   #No.FUN-7C0101
            COLUMN g_c[41],g_dash2[1,g_w[41]]
      #-->分群小計 
      LET l_Subtlf10 = l_Subtlf10 + l_Itlf10  + l_Otlf10
      LET l_Subamt01 = l_Subamt01 + l_Iamt01  + l_Oamt01
      LET l_Subamt02 = l_Subamt02 + l_Iamt02  + l_Oamt02
      LET l_Subamt03 = l_Subamt03 + l_Iamt03  + l_Oamt03
      LET l_Subamt05 = l_Subamt05 + l_Iamt05  + l_Oamt05    #FUN-630038 
      LET l_Subamt06 = l_Subamt06 + l_Iamt06  + l_Oamt06    #FUN-630038
      LET l_Subamt07 = l_Subamt07 + l_Iamt07  + l_Oamt07    #No.FUN-7C0101
      LET l_Subamt08 = l_Subamt08 + l_Iamt08  + l_Oamt08    #No.FUN-7C0101
      LET l_Subamt09 = l_Subamt09 + l_Iamt09  + l_Oamt09    #No.FUN-7C0101
      LET l_Subamt04 = l_Subamt04 + l_Iamt04  + l_Oamt04
      
      IF NOT cl_null(sr.ima12) THEN
         SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.ima12 AND azf02='G' #6818
         LET l_azf03 = l_azf03[1,8]
         PRINT COLUMN g_c[36],l_azf03 CLIPPED,':';
      END IF
      PRINT COLUMN g_c[37],cl_numfor(l_Subtlf10,37,g_ccz.ccz27), #CHI-690007
            COLUMN g_c[38],cl_numfor(l_Subamt01,38,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(l_Subamt02,39,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(l_Subamt03,40,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[42],cl_numfor(l_Subamt05,42,g_ccz.ccz26),      #FUN-630038 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[43],cl_numfor(l_Subamt06,43,g_ccz.ccz26),      #FUN-630038 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[45],cl_numfor(l_Subamt07,45,g_ccz.ccz26),      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[46],cl_numfor(l_Subamt08,46,g_ccz.ccz26),      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[47],cl_numfor(l_Subamt09,47,g_ccz.ccz26),      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[41],cl_numfor(l_Subamt04,41,g_ccz.ccz26)       #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
      #-->移入小計
      PRINT COLUMN g_c[36],g_dash2[1,g_w[36]],
            COLUMN g_c[44],g_dash2[1,g_w[44]],   #No.FUN-7C0101
            COLUMN g_c[37],g_dash2[1,g_w[37]],
            COLUMN g_c[38],g_dash2[1,g_w[38]],
            COLUMN g_c[39],g_dash2[1,g_w[39]],
            COLUMN g_c[40],g_dash2[1,g_w[40]],
            COLUMN g_c[42],g_dash2[1,g_w[42]],                  #FUN-630038  
            COLUMN g_c[43],g_dash2[1,g_w[43]],                  #FUN-630038
            COLUMN g_c[45],g_dash2[1,g_w[45]],   #No.FUN-7C0101
            COLUMN g_c[46],g_dash2[1,g_w[46]],   #No.FUN-7C0101
            COLUMN g_c[47],g_dash2[1,g_w[47]],   #No.FUN-7C0101
            COLUMN g_c[41],g_dash2[1,g_w[41]]
      PRINT COLUMN g_c[36],g_x[12] CLIPPED,
            COLUMN g_c[37],cl_numfor(l_Itlf10,37,g_ccz.ccz27), #CHI-690007
            COLUMN g_c[38],cl_numfor(l_Iamt01,38,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(l_Iamt02,39,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(l_Iamt03,40,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[42],cl_numfor(l_Iamt05,42,g_ccz.ccz26),      #FUN-630038 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[43],cl_numfor(l_Iamt06,43,g_ccz.ccz26),      #FUN-630038 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[45],cl_numfor(l_Iamt07,45,g_ccz.ccz26),      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[46],cl_numfor(l_Iamt08,46,g_ccz.ccz26),      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[47],cl_numfor(l_Iamt09,47,g_ccz.ccz26),      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[41],cl_numfor(l_Iamt04,41,g_ccz.ccz26)       #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
 
      #-->移出小計
      PRINT COLUMN g_c[36],g_dash2[1,g_w[36]],
            COLUMN g_c[44],g_dash2[1,g_w[44]],   #No.FUN-7C0101
            COLUMN g_c[37],g_dash2[1,g_w[37]],
            COLUMN g_c[38],g_dash2[1,g_w[38]],
            COLUMN g_c[39],g_dash2[1,g_w[39]],
            COLUMN g_c[40],g_dash2[1,g_w[40]],
            COLUMN g_c[42],g_dash2[1,g_w[42]],                  #FUN-630038  
            COLUMN g_c[43],g_dash2[1,g_w[43]],                  #FUN-630038
            COLUMN g_c[45],g_dash2[1,g_w[45]],   #No.FUN-7C0101
            COLUMN g_c[46],g_dash2[1,g_w[46]],   #No.FUN-7C0101
            COLUMN g_c[47],g_dash2[1,g_w[47]],   #No.FUN-7C0101
            COLUMN g_c[41],g_dash2[1,g_w[41]]
      PRINT COLUMN g_c[36],g_x[13] CLIPPED,
            COLUMN g_c[37],cl_numfor(l_Otlf10,37,g_ccz.ccz27),  #CHI-690007
            COLUMN g_c[38],cl_numfor(l_Oamt01,38,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(l_Oamt02,39,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(l_Oamt03,40,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[42],cl_numfor(l_Oamt05,42,g_ccz.ccz26),      #FUN-630038 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[43],cl_numfor(l_Oamt06,43,g_ccz.ccz26),      #FUN-630038 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[45],cl_numfor(l_Oamt07,45,g_ccz.ccz26),      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[46],cl_numfor(l_Oamt08,46,g_ccz.ccz26),      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[47],cl_numfor(l_Oamt09,47,g_ccz.ccz26),      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[41],cl_numfor(l_Oamt04,41,g_ccz.ccz26)       #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
      PRINT COLUMN g_dash2
      PRINT
 
   ON LAST ROW
       PRINT COLUMN g_c[36],g_dash2[1,g_w[36]],
             COLUMN g_c[44],g_dash2[1,g_w[44]],   #No.FUN-7C0101
             COLUMN g_c[37],g_dash2[1,g_w[37]],
             COLUMN g_c[38],g_dash2[1,g_w[38]],
             COLUMN g_c[39],g_dash2[1,g_w[39]],
             COLUMN g_c[40],g_dash2[1,g_w[40]],
             COLUMN g_c[42],g_dash2[1,g_w[42]],   #FUN-630038 
             COLUMN g_c[43],g_dash2[1,g_w[43]],   #FUN-630038
             COLUMN g_c[45],g_dash2[1,g_w[45]],   #No.FUN-7C0101
             COLUMN g_c[46],g_dash2[1,g_w[46]],   #No.FUN-7C0101
             COLUMN g_c[47],g_dash2[1,g_w[47]],   #No.FUN-7C0101
             COLUMN g_c[41],g_dash2[1,g_w[41]]
       PRINT COLUMN  g_c[36], g_x[14] CLIPPED,
             COLUMN g_c[37],cl_numfor(l_Tottlf10,37,g_ccz.ccz27),  #CHI-690007
             COLUMN g_c[38],cl_numfor(l_Totamt01,38,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
             COLUMN g_c[39],cl_numfor(l_Totamt02,39,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
             COLUMN g_c[40],cl_numfor(l_Totamt03,40,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
             COLUMN g_c[42],cl_numfor(l_Totamt05,42,g_ccz.ccz26),      #FUN-630038 #CHI-C30012 g_azi03->g_ccz.ccz26
             COLUMN g_c[43],cl_numfor(l_Totamt06,43,g_ccz.ccz26),      #FUN-630038 #CHI-C30012 g_azi03->g_ccz.ccz26
             COLUMN g_c[45],cl_numfor(l_Totamt07,45,g_ccz.ccz26),      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
             COLUMN g_c[46],cl_numfor(l_Totamt08,46,g_ccz.ccz26),      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
             COLUMN g_c[47],cl_numfor(l_Totamt09,47,g_ccz.ccz26),      #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
             COLUMN g_c[41],cl_numfor(l_Totamt04,41,g_ccz.ccz26)       #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
       PRINT g_dash[1,g_len]   #No.TQC-6A0078
       LET l_last_sw = 'y'
       PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9,g_x[7] CLIPPED   #No.TQC-6A0078
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]   #No.TQC-6A0078
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED   #No.TQC-6A0078
         ELSE SKIP 2 LINE
      END IF
END REPORT
