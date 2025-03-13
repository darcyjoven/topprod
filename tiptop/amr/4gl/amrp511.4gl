# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amrp511.4gl
# Descriptions...: MRP 請購單產生作業
# Date & Author..: 96/06/10 By Roger
# Modify.........: 00/08/06 By Carol:轉PR時check單位換算
# Modify.........: NO.MOD-4C0101 04/12/17  by pengu 修改報表檔案產生模式
# Modify.........: No.FUN-550055 05/05/25 By Will 單據編號放大
# Modify.........: No.FUN-560060 05/06/17 By day  單據編號修改
# Modify.........: No.FUN-580005 05/08/03 By ice 報表修改轉XML
# Modify.........: NO.MOD-580222 05/08/23 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.FUN-630040 06/03/23 By Nicola 產生的請購單單身多三欄位
# Modify.........: No.TQc-640132 06/04/17 By Nicola 日期調整
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/17 By xumin 報表標題調整
# Modify.........: No.TQC-6B0011 06/12/04 By Sarah 沒有列印(amrp511)、(接下頁)、(結束)等表尾字樣
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-980004 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0023 09/11/04 By baofei 寫入請購單身時，也要一併寫入"電子採購否(pml92)"='N'
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No.FUN-910088 11/11/22 By chenjing 增加數量欄位小數取位
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE mss		RECORD LIKE mss_file.*
DEFINE pmk		RECORD LIKE pmk_file.*
DEFINE pml		RECORD LIKE pml_file.*
DEFINE ver_no		LIKE mss_file.mss_v     #NO.FUN-680082 VARCHAR(2)
DEFINE mxno  		LIKE type_file.num10    #NO.FUN-680082 INTEGER
DEFINE summary_flag	LIKE type_file.chr1     #NO.FUN-680082 VARCHAR(1)
DEFINE tm               RECORD
                         msm06 LIKE msm_file.msm06
                        END RECORD
DEFINE g_t1    	        LIKE pmk_file.pmk01     #No.FUN-550055 #NO.FUN-680082 VARCHAR(5) 
DEFINE l_za05  	        LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(40) 
DEFINE g_wc,g_sql	STRING                  #No.FUN-580092 HCN  
DEFINE i,j,k		LIKE type_file.num10    #NO.FUN-680082 INTEGER
DEFINE g_flag           LIKE type_file.chr1     #NO.FUN-680082 VARCHAR(01)
DEFINE g_chr            LIKE type_file.chr1     #NO.FUN-680082 VARCHAR(1)
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose  #NO.FUN-680082 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(72)
DEFINE g_pmk01          LIKE pmk_file.pmk01     #No.FUN-560060
MAIN
#     DEFINE   l_time   LIKE type_file.chr8          #No.FUN-6A0076
   DEFINE   p_row,p_col LIKE type_file.num5     #NO.FUN-680082 SMALLINT
 
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
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
   OPEN WINDOW p511_w AT p_row,p_col
        WITH FORM "amr/42f/amrp511"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   INITIALIZE pmk.* TO NULL
   SELECT MAX(smyslip) INTO pmk.pmk01 FROM smy_file
         WHERE smysys='apm' AND smykind='1'
   LET pmk.pmk04 = TODAY
   LET pmk.pmk12 = g_user
   LET summary_flag= '1'
   LET mxno      = 20
   SELECT gen03 INTO pmk.pmk13 FROM gen_file WHERE gen01=g_user
 
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:BUG-580088  HCN 20050818 #MOD-580222  #No.FUN-6A0076
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   WHILE TRUE
      LET g_flag = 'Y'
      CALL p511_ask()
      IF g_flag = 'N' THEN
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      IF cl_sure(20,20) THEN
         BEGIN WORK
         LET g_success='Y'
         CALL cl_wait()
         CALL p511()
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_success='N'
         END IF
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
         END IF
         IF g_flag THEN
            CONTINUE WHILE
            ERROR ''
         ELSE
            EXIT WHILE
         END IF
      END IF
   END WHILE
   CLOSE WINDOW p511_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION p511_ask()
   DEFINE   l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gem02   LIKE gem_file.gem02,
            l_n       LIKE type_file.num5     #NO.FUN-680082 SMALLINT
   DEFINE   li_result LIKE type_file.num5     #NO.Fun-550055 #NO.FUN-680082 SMALLINT
 
   CONSTRUCT BY NAME g_wc ON mss01, ima08, ima67, mss02, mss03, mss11
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION locale                    #genero
         LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT CONSTRUCT
       ON ACTION exit              #加離開功能genero
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF g_action_choice = "locale" THEN  #genero
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      LET g_flag = 'N'
      RETURN
   END IF
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   INPUT BY NAME
      ver_no,pmk.pmk04,pmk.pmk01,pmk.pmk12,pmk.pmk13,
      summary_flag,mxno,tm.msm06
      WITHOUT DEFAULTS
 
      AFTER FIELD pmk01
         IF NOT cl_null(pmk.pmk01) THEN
#No.FUN-550055  --start
            CALL s_check_no("apm",pmk.pmk01,"","1","pmk_file","pmk01","")
              RETURNING li_result,pmk.pmk01
            DISPLAY BY NAME pmk.pmk01
            IF (NOT li_result) THEN
    	       NEXT FIELD pmk01
            END IF
 
            LET g_t1=s_get_doc_no(pmk.pmk01)
## No:2524 modify 1998/12/13 --------------------------
#           LET g_t1=pmk.pmk01[1,3]
#           CALL s_mfgslip(g_t1,'apm','1')
#           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#              CALL cl_err(g_t1,g_errno,0) NEXT FIELD pmk01
#           END IF
## ----------------------------------------------------
#           CALL s_smyauno(pmk.pmk01,pmk.pmk04) RETURNING i,pmk.pmk01
#           DISPLAY BY NAME pmk.pmk01
 
            CALL s_auto_assign_no("apm",pmk.pmk01,pmk.pmk04,"1","pmk_file","pmk01","","","")
              RETURNING li_result,pmk.pmk01
            DISPLAY BY NAME pmk.pmk01
#NO.Fun-550055 --end
         END IF
 
      AFTER FIELD pmk12
         IF NOT cl_null(pmk.pmk12) THEN
            SELECT gen02,gen03 INTO l_gen02,l_gen03
              FROM gen_file   WHERE gen01 = pmk.pmk12
               AND genacti = 'Y'
            IF SQLCA.sqlcode THEN
#               CALL cl_err(SQLCA.sqlcode,'mfg1312',0) #No.FUN-660107
                CALL cl_err3("sel","gen_file",pmk.pmk12,"",SQLCA.SQLCODE,"","",0)        #NO.FUN-660107
               DISPLAY BY NAME pmk.pmk13
               NEXT FIELD pmk12
            END IF
         END IF
 
      BEFORE FIELD pmk13
         IF cl_null(pmk.pmk13) THEN
            LET pmk.pmk13 = l_gen03
         END IF
 
      AFTER FIELD pmk13
         IF NOT cl_null(pmk.pmk13)  THEN
            SELECT gem02 INTO l_gem02
              FROM gem_file  WHERE gem01 = pmk.pmk13
               AND gemacti = 'Y'
            IF SQLCA.sqlcode THEN
#               CALL cl_err(SQLCA.sqlcode,'mfg3097',0) #No.FUN-660107
                CALL cl_err3("sel","gem_file",pmk.pmk13,"",SQLCA.SQLCODE,"","",0)        #NO.FUN-660107
               DISPLAY BY NAME pmk.pmk13
               NEXT FIELD pmk13
            END IF
         END IF
 
      AFTER FIELD msm06
         IF NOT cl_null(tm.msm06) THEN
            SELECT COUNT(*) INTO l_n FROM gem_file WHERE gem01 = tm.msm06
            IF l_n = 0 THEN
               CALL cl_err(tm.msm06,100,0)
               NEXT FIELD msm06
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pmk01) #order nubmer
#               LET g_t1=pmk.pmk01[1,3]
               LET g_t1=s_get_doc_no(pmk.pmk01)       #No.FUN-550055
               CALL q_smy(FALSE,FALSE,g_t1,'APM','1') RETURNING g_t1 #TQC-670008
#               CALL FGL_DIALOG_SETBUFFER( g_t1 )
#               LET pmk.pmk01[1,3]=g_t1
               LET pmk.pmk01=g_t1                     #No.FUN-550055
               DISPLAY BY NAME pmk.pmk01
               NEXT FIELD pmk01
            WHEN INFIELD(pmk12) #請購員
#              CALL q_gen(8,10,pmk.pmk12) RETURNING pmk.pmk12
#              CALL FGL_DIALOG_SETBUFFER( pmk.pmk12 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = pmk.pmk12
               CALL cl_create_qry() RETURNING pmk.pmk12
#               CALL FGL_DIALOG_SETBUFFER( pmk.pmk12 )
               DISPLAY BY NAME pmk.pmk12
               NEXT FIELD pmk12
            WHEN INFIELD(pmk13) #請購Dept
#              CALL q_gem(8,10,pmk.pmk13) RETURNING pmk.pmk13
#              CALL FGL_DIALOG_SETBUFFER( pmk.pmk13 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = pmk.pmk13
               CALL cl_create_qry() RETURNING pmk.pmk13
#               CALL FGL_DIALOG_SETBUFFER( pmk.pmk13 )
               DISPLAY BY NAME pmk.pmk13
               NEXT FIELD pmk13
            WHEN INFIELD(msm06) #生產部門
#              CALL q_gem(10,2,tm.msm06) RETURNING tm.msm06
#              CALL FGL_DIALOG_SETBUFFER( tm.msm06 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = tm.msm06
               CALL cl_create_qry() RETURNING tm.msm06
#               CALL FGL_DIALOG_SETBUFFER( tm.msm06 )
               DISPLAY BY NAME tm.msm06
               NEXT FIELD msm06
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exit  #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION p511()
   DEFINE l_name	LIKE type_file.chr20         #NO.FUN-680082 VARCHAR(20)
   DEFINE l_order	LIKE ima_file.ima43          #NO.FUN-680082 VARCHAR(10)
   DEFINE l_ima06,l_ima43	LIKE ima_file.ima06  #NO.FUN-680082 VARCHAR(6)
   DEFINE l_pmc15    LIKE pmc_file.pmc15
   DEFINE l_pmk10    LIKE pmk_file.pmk10
 
#  CALL p500_pmk_default()
   LET g_sql="SELECT mss_file.*, ima06, ima43,pmc15",
             "  FROM mss_file LEFT OUTER JOIN pmc_file ON mss_file.mss02=pmc_file.pmc01 ,ima_file",
             " WHERE mss01=ima01 AND mss09 > 0 AND mss10='N'",
             " AND mss_v='",ver_no,"'",
             "   AND ",g_wc CLIPPED
#BugNo:6466
      CASE WHEN summary_flag='1'
               LET g_sql = g_sql CLIPPED," ORDER BY ima43,mss01, mss03"
           WHEN summary_flag='2'
               LET g_sql = g_sql CLIPPED," ORDER BY ima06,mss01, mss03"
           WHEN summary_flag='3'
               LET g_sql = g_sql CLIPPED," ORDER BY pmc15,mss01, mss03"
           OTHERWISE
               LET g_sql = g_sql CLIPPED," ORDER BY mss01, mss03"
      END CASE
#BugNo:6466}
 
   PREPARE p511_p FROM g_sql
   DECLARE p511_c CURSOR FOR p511_p
    CALL cl_outnam('amrp511') RETURNING l_name       #MOD-4C0101
   START REPORT p511_rep TO l_name
   FOREACH p511_c INTO mss.*, l_ima06, l_ima43,l_pmc15
 
## 1-3
   LET l_pmk10 = ' '
   IF NOT cl_null(tm.msm06) THEN
     SELECT msm02 INTO l_pmk10 FROM msm_file    # 地址代碼
      WHERE msm01 = mss.mss01
        AND msm06 = tm.msm06                    # 生產部門
     IF NOT cl_null(l_pmk10) THEN
       LET l_pmc15 = l_pmk10
     END IF
   END IF
   IF l_pmc15 IS NULL THEN LET l_pmc15=' ' END IF
## end
 
#  CALL p500_pmk_default(l_pmc15)
      CASE WHEN summary_flag='1' LET l_order=l_ima43
           WHEN summary_flag='2' LET l_order=l_ima06
           WHEN summary_flag='3' LET l_order=l_pmc15
           OTHERWISE             LET l_order=' '
      END CASE
      OUTPUT TO REPORT p511_rep(l_order,mss.*)
   END FOREACH
   FINISH REPORT p511_rep
   CALL cl_prt(l_name,' ','1',g_len)
 
   CASE g_lang
     WHEN '0'
       LET g_msg = " 是否確定產生請購單 ?: "
     WHEN '2'
       LET g_msg = " 是否確定產生請購單 ?: "
     OTHERWISE
       LET g_msg = "  Process RequFM ?: "
   END CASE
   IF cl_prompt(16,10,g_msg)
      THEN
      LET g_success='Y'
   ELSE
      LET g_success='N'
   END IF
 
   CLOSE WINDOW p511_sure_w
END FUNCTION
 
REPORT p511_rep(l_order, mss)
  DEFINE mss		RECORD LIKE mss_file.*
  DEFINE mst		RECORD LIKE mst_file.*
  DEFINE l_sw           LIKE type_file.chr1      #NO.FUN-680082 VARCHAR(1) 
  DEFINE l_order	LIKE ima_file.ima43      #NO.FUN-680082 VARCHAR(10)
  DEFINE l_ima49        LIKE ima_file.ima49
  DEFINE l_ima491       LIKE ima_file.ima491
  DEFINE l_pmc15        LIKE pmc_file.pmc15
  DEFINE l_pmk10        LIKE pmk_file.pmk10
  DEFINE l_date         LIKE type_file.dat       #NO.FUN-680082 DATE
  DEFINE l_pmli         RECORD LIKE pmli_file.*  #NO.FUN-7B0018       
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_order, mss.mss01, mss.mss03 #BugNo:6466
#No.FUN-580005-begin
  FORMAT
    PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED   #TQC-6A0080
      PRINT
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #TQC-6A0080
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],
            g_x[35],g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_sw = 'n'   #TQC-6B0011 add
 
#No.FUN-560060-begin
    BEFORE GROUP OF l_order
#     CALL p500_pmk_default(l_pmc15)
      CALL p500_pmk_default(l_order)
      CALL ins_pmk()
      PRINT COLUMN g_c[31],g_pmk01 CLIPPED,    #No.FUN-560060
            COLUMN g_c[32],l_order[1,6];
#     LET pmk.pmk01[8,10]=(pmk.pmk01[8,10]+1) USING '&&&'  #No.FUN-560060
#     LET pmk.pmk09=l_order
    ON EVERY ROW
      IF pml.pml02>=mxno THEN
         CALL ins_pmk()
         PRINT
         PRINT COLUMN g_c[31],g_pmk01 CLIPPED,    #No.FUN-560060
               COLUMN g_c[32],l_order[1,6];
#        LET pmk.pmk01[8,10]=(pmk.pmk01[8,10]+1) USING '&&&'    #No.FUN-560060
      END IF
      LET pml.pml02 =pml.pml02+1
      MESSAGE 'ins pml:',pml.pml01,' ',pml.pml02
      CALL ui.Interface.refresh()
      LET pml.pml04 =mss.mss01
      LET pml.pml041=NULL
      LET pml.pml07 =NULL
      LET pml.pml08 =NULL
      LET pml.pml09 =1
      SELECT ima02,ima39,ima44,ima25,ima44_fac,ima913,ima914   #No.FUN-630040
         INTO pml.pml041,pml.pml40,pml.pml07,pml.pml08,pml.pml09,
              pml.pml190,pml.pml191   #No.FUN-630040
             FROM ima_file WHERE ima01=pml.pml04
      LET pml.pml192 = "N"   #No.FUN-630040
      IF pml.pml07 != pml.pml08 THEN    # 00/08/06 add by Carol
         LET mss.mss09=mss.mss09 / pml.pml09
      END IF
      LET pml.pml11 ='N'
      LET pml.pml13 =g_sma.sma401
      LET pml.pml14 =g_sma.sma886[1,1]         #部份交貨
      LET pml.pml15 =g_sma.sma886[2,2]         #提前交貨
      IF g_smy.smydmy4='Y'   #立即確認
         THEN
         LET pml.pml16='1'
      ELSE
         LET pml.pml16='0'
      END IF
      #-----No.TQC-640132-----
      LET pml.pml18=mss.mss03
      CALL s_aday(pml.pml18,-1,0) RETURNING pml.pml18
     #WHILE TRUE
     #   SELECT sme02 INTO g_chr FROM sme_file WHERE sme01=pml.pml18
     #   IF STATUS THEN EXIT WHILE END IF
     #   IF g_chr='Y' THEN EXIT WHILE END IF
#    #   LET pml.pml18=pml.pml18+1
     #   LET pml.pml18=pml.pml18-1
     #END WHILE
      #-----No.TQC-640132-----
      LET pml.pml123=mss.mss02
      LET pml.pml20=mss.mss09
      LET pml.pml20=s_digqty(pml.pml20,pml.pml07)  #FUN-910088--add--
      LET pml.pml21=0
      LET pml.pml30=0
      LET pml.pml31=0
      LET pml.pml32=0
      #---modi in 99/12/23------------------------
      SELECT ima49,ima491 INTO l_ima49,l_ima491
       FROM ima_file WHERE ima01=pml.pml04
 
      IF cl_null(l_ima49) THEN LET l_ima49=0 END IF
      IF cl_null(l_ima491) THEN LET l_ima491=0 END IF
 
     #LET pml.pml35=pml.pml18
      CALL s_aday(pml.pml18,-1,0) RETURNING pml.pml35   #No.TQC-640132
 
     #LET pml.pml34=pml.pml35 - l_ima491     #到廠日
      CALL s_aday(pml.pml35,-1,l_ima491) RETURNING pml.pml34   #No.TQC-640132
 
      # 到廠日考慮是否工作日
      SELECT sme01 FROM sme_file
       WHERE sme01 = pml.pml34 AND sme02 IN ('Y','y')
      IF STATUS  # 非工作日
         THEN
         SELECT max(sme01) INTO l_date FROM sme_file
          WHERE sme01 < pml.pml34 AND sme02 IN ('Y','y')
         IF NOT cl_null(l_date)
            THEN
            LET pml.pml34 = l_date
         END IF
      END IF
 
     #LET pml.pml33=pml.pml34 - l_ima49
      CALL s_aday(pml.pml34,-1,l_ima49) RETURNING pml.pml33   #No.TQC-640132
      #-------------------------------------------
      LET pml.pml38='Y'
      LET pml.pml41=mss.mss_v,'-',mss.mss00 USING '&&&&'
      LET pml.pml42='0'
      LET pml.pml44=0
      PRINT COLUMN g_c[33],pml.pml41 CLIPPED,
           #COLUMN g_c[34],pml.pml02 USING '###',    #TQC-6B0011 mark
            COLUMN g_c[34],pml.pml02 USING '###&',   #TQC-6B0011
            COLUMN g_c[35],pml.pml04 CLIPPED,  #FUN-5B0014 [1,20],
            COLUMN g_c[36],pml.pml07 CLIPPED,
            COLUMN g_c[37],pml.pml20 USING '##,###,###.##',' ',
            COLUMN g_c[38],pml.pml33 CLIPPED
#No.FUN-560060-end
      LET pml.pmlplant=g_plant #FUN-980004 add
      LET pml.pmllegal=g_legal #FUN-980004 add
      LET pml.pml49='1' #No.FUN-870007
      LET pml.pml50='1' #No.FUN-870007
      LET pml.pml54='2' #No.FUN-870007
      LET pml.pml56='1' #No.FUN-870007
      LET pml.pml92 = 'N' #FUN-9B0023
      INSERT INTO pml_file VALUES(pml.*)
      IF STATUS THEN 
#      CALL cl_err('ins pml:',STATUS,1) #No.FUN-660107
       CALL cl_err3("ins","pml_file",pml.pml01,pml.pml02,STATUS,"","ins pml:",1)        #NO.FUN-660107 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM END IF
 
      #NO.FUN-7B0018 08/01/31 add --begin
      IF NOT s_industry('std') THEN
         INITIALIZE l_pmli.* TO NULL
         LET l_pmli.pmli01 = pml.pml01
         LET l_pmli.pmli02 = pml.pml02
         IF NOT s_ins_pmli(l_pmli.*,'') THEN
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM 
         END IF
      END IF
      #NO.FUN-7B0018 08/01/31 add --end
 
      UPDATE mss_file SET mss10='Y'
         WHERE mss_v=mss.mss_v AND mss00=mss.mss00
      IF STATUS THEN 
#      CALL cl_err('upd mss10:',STATUS,1) #No.FUN-660107
       CALL cl_err3("upd","mss_file",mss.mss_v,mss.mss00,STATUS,"","upd mss10:",1)        #NO.FUN-660107 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM END IF
 
    ON LAST ROW
       PRINT g_dash[1,g_len]
   #start TQC-6B0011 add
       LET l_sw = 'y'
       PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
    PAGE TRAILER
      IF l_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
   #end TQC-6B0011 add
 
END REPORT
 
FUNCTION p500_pmk_default(p_pmc15)
      DEFINE    p_pmc15   LIKE pmc_file.pmc15
      LET pmk.pmk02='REG'
#     LET pmk.pmk10=g_plant
      LET pmk.pmk10=p_pmc15
      LET pmk.pmk09=mss.mss02
      IF pmk.pmk09='-' THEN LET pmk.pmk09=' ' END IF
      IF g_smy.smydmy4='Y'   #立即確認
         THEN
         LET pmk.pmk18='Y'
         LET pmk.pmk25='1'
      ELSE
         LET pmk.pmk18='N'
         LET pmk.pmk25='0'
      END IF
      LET pmk.pmk27=TODAY
      LET pmk.pmk30='Y'
      LET pmk.pmk31=YEAR(pmk.pmk04)
      LET pmk.pmk32=MONTH(pmk.pmk04)
      LET pmk.pmk40=0
      LET pmk.pmk401=0
      LET pmk.pmk42=1
      LET pmk.pmk43=0
      LET pmk.pmk45='Y'
      LET pmk.pmkprsw='Y'
      LET pmk.pmkprno=0
      LET pmk.pmkmksg='N'
      LET pmk.pmkacti='Y'
      LET pmk.pmkuser=g_user
      LET pmk.pmkgrup=g_grup
      LET pmk.pmkdate=TODAY
      LET pmk.pmkplant=g_plant #FUN-980004 add
      LET pmk.pmklegal=g_legal #FUN-980004 add
END FUNCTION
 
FUNCTION ins_pmk()
DEFINE li_result LIKE type_file.num5        #No.FUN-550060  #NO.FUN-680082 SMALLINT 
 
#No.FUN-560060-begin
        CALL s_auto_assign_no("apm",pmk.pmk01,pmk.pmk04,"1","pmk_file","pmk01","","","")
          RETURNING li_result,pmk.pmk01
        IF (NOT li_result) THEN
           LET g_success='N' 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM
        END IF
#     CALL s_smyauno(pmk.pmk01,pmk.pmk04) RETURNING i,pmk.pmk01
#     IF i THEN LET g_success='N' EXIT PROGRAM END IF
#No.FUN-560060-end
      MESSAGE 'ins pmk:',pmk.pmk01
      CALL ui.Interface.refresh()
      LET pmk.pmk46 = '1'  #No.FUN-870007
      LET pmk.pmkoriu = g_user      #No.FUN-980030 10/01/04
      LET pmk.pmkorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO pmk_file VALUES(pmk.*)
      IF STATUS THEN 
#      CALL cl_err('ins pmk:',STATUS,1)  #No.FUN-660107
       CALL cl_err3("ins","pmk_file",pmk.pmk01,"",STATUS,"","ins pmk:",1)        #NO.FUN-660107
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM END IF
      LET pml.pml01=pmk.pmk01
      LET pml.pml011=pmk.pmk02
      LET pml.pml02=0
      #LET pmk.pmk01[5,10]=' '	# 以便下一次會重新編號
      LET g_pmk01 = pmk.pmk01        #No.FUN-560060
      LET pmk.pmk01 = g_t1           #No.FUN-560060
END FUNCTION
#Patch....NO.TQC-610035 <> #
