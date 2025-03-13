# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amsp630.4gl 
# Descriptions...: MPS 計劃工單產生作業
# Date & Author..: 00/02/19 By Raymon
# Modify.........: No.FUN-510036 05/01/18 By pengu 報表轉XML
# Modify.........: No.FUN-570126 06/03/08 By yiting 批次背景執行
# Modify.........: No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.FUN-680101 06/08/29 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/20 By xumin 報表寬度不符
# Modify.........: No.MOD-6B0110 06/12/13 By pengu 程式詢問是否轉MPS計畫,若輸入否時mps10還是會被update成"Y"
# Modify.........: No.TQC-770034 07/07/10 By wujie  數量欄位沒有右對齊
# Modify.........: No.TQC-7B0023 07/11/05 By lumxa 建立臨時表的效率很低導致開啟畫面的時間很長
# Modify.........: No.MOD-840437 08/04/21 By Pengu 預設MPS的單據日期
# Modify.........: No.MOD-950191 09/05/19 By Smapmin MPS計劃編號增加開窗功能
# Modify.........: No.MOD-960210 09/06/17 By Carrier mps計劃編號自動編號
# Modify.........: No.FUN-980005 09/08/13 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0200 09/12/04 By lilingyu 變量g_t1長度過短
# Modify.........: No:MOD-9C0098 09/12/10 By Smapmin 單別欄位變數放大
# Modify.........: No:MOD-9C0121 09/12/14 By Smapmin msa05預設為N
# Modify.........: No:FUN-A90063 10/09/27 By rainy INSERT INTO p630_tmp時，應給 plant/legal值
# Modify.........: No:MOD-810190 10/11/24 By Summer 計畫生產量應轉換為生產單位數量
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No:MOD-CA0068 12/10/11 By suncx ams-018開窗詢問未考慮背景運行的情況
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE mps		RECORD LIKE mps_file.*
DEFINE msa		RECORD LIKE msa_file.*
DEFINE msb		RECORD LIKE msb_file.*
DEFINE g_mpl            RECORD LIKE mpl_file.*
DEFINE ver_no		LIKE mpm_file.mpm_v
DEFINE g_wc,g_sql	STRING     #No.FUN-580092 HCN
#DEFINE g_t1            LIKE type_file.chr3       #NO.FUN-680101 VARCHAR(3)  #TQC-9B0200
#DEFINE g_t1            LIKE type_file.chr8      #TQC-9B0200   #MOD-9C0098
DEFINE g_t1             LIKE smy_file.smyslip    #MOD-9C0098
DEFINE i,j,k		LIKE type_file.num10     #NO.FUN-680101 INTEGER 
DEFINE g_flag           LIKE type_file.chr1      #NO.FUN-680101 VARCHAR(01)
DEFINE g_chr            LIKE type_file.chr1      #NO.FUN-680101 VARCHAR(1)
DEFINE g_cnt            LIKE type_file.num10     #NO.FUN-680101 INTEGER  
DEFINE g_i              LIKE type_file.num5      #NO.FUN-680101 SMALLINT #count/index for any purpose
DEFINE g_msg            LIKE type_file.chr1000   #NO.FUN-680101 VARCHAR(72)
DEFINE l_flag           LIKE type_file.chr1      #No.FUN-570126   #NO.FUN-680101 VARCHAR(1)
DEFINE g_change_lang    LIKE type_file.chr1      #是否有做語言切換 No.FUN-570126  #NO.FUN-680101 VARCHAR(01)
DEFINE p_row,p_col      LIKE type_file.num5      #NO.FUN-680101 SMALLINT 
 
MAIN
   DEFINE l_name    LIKE type_file.chr20,        #NO.FUN-680101 VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0081
          l_sql     LIKE type_file.chr1000,      #NO.FUN-680101 VARCHAR(600)  # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,         #NO.FUN-680101 VARCHAR(1)
          l_za05    LIKE type_file.chr50,        #NO.FUN-680101 VARCHAR(40)
          l_mpz_v   LIKE mpz_file.mpz_v
   DEFINE ls_date   STRING           #No.FUN-570126
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				 
 
   #->No.FUN-570126 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc        = ARG_VAL(1)
   LET ver_no      = ARG_VAL(2)
   LET msb.msb01   = ARG_VAL(3)
   LET g_bgjob     = ARG_VAL(4)    #背景作業
   IF cl_null(g_bgjob) THEN
       LET g_bgjob = "N"
   END IF
   #->No.FUN-570126 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
 
#NO.FUN-570126 mark----
#   LET p_row = 5 LET p_col = 17
 
#   OPEN WINDOW p630_w AT p_row,p_col WITH FORM "ams/42f/amsp630" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
#   INITIALIZE msa.* TO NULL
#   INITIALIZE msb.* TO NULL
#   WHILE TRUE 
#      LET g_flag = 'Y'
#      CALL p630_create_tmp()
#      CALL p630_ask()
#      IF g_flag = 'N' THEN
#         CONTINUE WHILE
#      END IF
#      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#      IF cl_sure(20,20) THEN 
#         BEGIN WORK
#         LET g_success='Y'
#         CALL cl_wait()
#         CALL p630_p()
#         CALL p630()
#         IF INT_FLAG THEN LET INT_FLAG = 0 LET g_success='N' END IF
#         IF g_success='N' THEN 
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING g_flag
#         ELSE 
#            LET g_mpz.mpz04 = g_mpl.mpl01,' ',g_mpl.mpl02
#         
#            # mpk_v空白表示為release為MPS計劃時的時距
#            DELETE FROM mpk_file WHERE mpk_v=' '
#            IF STATUS THEN
#               CALL cl_err('del mpk_file',STATUS,1)
#               LET g_success='N' 
#            END IF
#         
#            DROP TABLE x
#            SELECT * FROM mpk_file WHERE mpk_v = ver_no INTO TEMP x
#            UPDATE x SET mpk_v = ' '
#            INSERT INTO mpk_file SELECT * FROM x
#         
#            DELETE FROM mpm_file WHERE mpm_v=' '
#            IF STATUS THEN
#               CALL cl_err('del mpm_file',STATUS,1)
#               LET g_success='N' 
#            END IF
#         
#            DROP TABLE x
#            SELECT * FROM mpm_file WHERE mpm_v = ver_no INTO TEMP x
#            UPDATE x SET mpm_v = ' '
#            INSERT INTO mpm_file SELECT * FROM x
#         
#            UPDATE mpz_file SET mpz_v = ver_no,mpz04=g_mpz.mpz04
#            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#               LET g_success='N' 
#               CALL cl_err('upd mpz_file',STATUS,1)
#            END IF
#            IF g_success = 'Y' THEN
#               COMMIT WORK
#               CALL cl_end2(1) RETURNING g_flag
#            ELSE
#               ROLLBACK WORK
#               CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#            END IF
#          END IF
#      END IF
#      IF g_flag THEN
#         CONTINUE WHILE
#         ERROR ''
#      ELSE
#         EXIT WHILE
#      END IF
#   END WHILE
#   CLOSE WINDOW p630_w
#NO.FUN-570126 mark-----
 
#NO.FUN-570126 start---
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p630_create_tmp()
         CALL p630_ask()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p630_p()
            CALL p630()
           #-----------No.MOD-6B0110 modify
            IF g_success = 'Y' THEN
               CALL p630_process()
            END IF
           #-----------No.MOD-6B0110 end
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING g_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
            END IF
            IF g_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p630_w
               EXIT WHILE
            END IF
       ELSE
          CONTINUE WHILE
       END IF
    ELSE
       LET g_success = 'Y'
       BEGIN WORK
       CALL p630_create_tmp()
       CALL p630_p()
       CALL p630()
       CALL p630_process()
       IF g_success = 'Y' THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
    END IF
 END WHILE
#->No.FUN-570126 ---end---
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 
FUNCTION p630_ask()
   DEFINE   lc_cmd        LIKE type_file.chr1000  #No.FUN-570126 #NO.FUN-680101 VARCHAR(500) 
   DEFINE li_result       LIKE type_file.num5     #MOD-950191
 
#NO.FUN-570126  start---
   LET p_row = 5 LET p_col = 17
 
   OPEN WINDOW p630_w AT p_row,p_col WITH FORM "ams/42f/amsp630" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   WHILE TRUE
   INITIALIZE msa.* TO NULL
   INITIALIZE msb.* TO NULL
#NO.FUN-570126 end--------
   LET ver_no =NULL
   LET msb.msb01=NULL
   CONSTRUCT BY NAME g_wc ON mps01, ima08, ima67, mps03, mps11 
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
         #LET g_action_choice = "locale"
         #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE                   #no.FUN-570127
         EXIT CONSTRUCT
 
      ON ACTION exit                      #加離開功能genero
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
#NO.FUN-570127 start---
#   IF g_action_choice = "locale" THEN  #genero
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      LET g_flag = 'N'
#      RETURN
#   END IF
#   IF INT_FLAG THEN
#      RETURN
#   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p630_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
#NO.FUN-570127 end-------------
   LET g_bgjob = "N"   #NO.FUN-570127 
#   INPUT BY NAME ver_no,msb.msb01 WITHOUT DEFAULTS 
   INPUT BY NAME ver_no,msb.msb01,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570127
 
      AFTER FIELD msb01
         IF NOT cl_null(msb.msb01) THEN
            SELECT COUNT(*) INTO g_cnt FROM msa_file
             WHERE msa01 = msb.msb01
               #AND msa03='N' #010813增
            IF g_cnt>0 THEN                        #抱歉, 有問題
               CALL cl_err('count>1:',-239,0)
               NEXT FIELD msb01
            END IF
            #-----MOD-950191---------
            CALL s_check_no("asf",msb.msb01,msb.msb01,"K","msb_file","msb01","")
            RETURNING li_result,msb.msb01
            DISPLAY BY NAME msb.msb01
            IF (NOT li_result) THEN
              NEXT FIELD msb01
            END IF
            #-----END MOD-950191-----
         END IF
 
      #-----MOD-950191---------
      ON ACTION controlp
          CASE
             WHEN INFIELD(msb01)
                 CALL q_smy(FALSE,TRUE,g_t1,'ASF','K') RETURNING g_t1
                 LET msb.msb01=g_t1   
                 DISPLAY BY NAME msb.msb01
                 NEXT FIELD msb01
         END CASE
      #-----END MOD-950191----- 
 
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
         LET g_success='N' 
         EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
         #->No.FUN-570126 --start--
          LET g_change_lang = TRUE
          EXIT INPUT
         #->No.FUN-570126 ---end---
 
   END INPUT
#NO.FUN-570127 start--
#   IF INT_FLAG THEN RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p630_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
#       EXIT WHILE
   END IF
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "amsp630"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('amsp630','9031',1)
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED ,"'",
                      " '",ver_no CLIPPED ,"'",
                      " '",msb.msb01 CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('amsp630',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p630_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
  EXIT WHILE
  #->No.FUN-570126 ---end---
 END WHILE
END FUNCTION
 
FUNCTION p630_p()
   DEFINE li_result   LIKE type_file.num5    #No.MOD-960210
 
# 先將所有 MPS 計劃結案
   UPDATE msa_file SET msa03 = 'Y',     #結案碼
                       msa04 = g_today, #結案日期
                       msamodu=g_user,
                       msamodd=g_today
   WHERE 1=1                           #全部結案
   IF STATUS THEN
#     CALL cl_err('upd msa:',STATUS,1)  #No.FUN-660108
      CALL cl_err3("upd","msa_file",msa.msa01,"",STATUS,"","upd msa:",1)       #No.FUN-660108
      LET g_success = 'N' RETURN
   END IF
   
# 抓取MPS 執行Log檔執行日期,執行時間
   SELECT MIN(mpl01),MIN(mpl02) 
     INTO g_mpl.mpl01,g_mpl.mpl02
     FROM mpl_file
    WHERE mpl_v = ver_no
   IF STATUS THEN 
 #    CALL cl_err('sel mpl_file',STATUS,1) #No.FUN-660108
      CALL cl_err3("sel","mpl_file",ver_no,"",STATUS,"","sel mpl_file",1)       #No.FUN-660108 
      LET g_success = 'N' RETURN
   END IF
 
   #No.MOD-960210  --Begin
   CALL s_auto_assign_no("asf",msb.msb01,g_today,"K","msa_file","msa01","","","")
        RETURNING li_result,msb.msb01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN 
   END IF
   DISPLAY BY NAME msb.msb01
   #No.MOD-960210  --End  
   LET msa.msa01 = msb.msb01
   LET msa.msa02 = ver_no,' ',g_mpz.mpz04
   LET msa.msa03 = 'N'
   LET msa.msa05 = 'N'   #MOD-9C0121
   LET msa.msa08 = g_today      #No.MOD-840437 add
   LET msa.msauser = g_user
   LET msa.msadate = g_today
   LET msa.msaplant = g_plant #FUN-980005
   LET msa.msalegal = g_legal #FUN-980005
 
   LET msa.msaoriu = g_user      #No.FUN-980030 10/01/04
   LET msa.msaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO msa_file VALUES(msa.*)
   IF STATUS THEN
#     CALL cl_err('ins msa:',STATUS,1)  #No.FUN-660108
      CALL cl_err3("ins","msa_file",msa.msa01,"",STATUS,"","ins msa:",1)       #No.FUN-660108
      LET g_success = 'N' RETURN
   END IF
 
END FUNCTION
 
FUNCTION p630()
   DEFINE l_name        LIKE type_file.chr20,    #NO.FUN-680101 VARCHAR(20)	
          l_mpr         RECORD LIKE mpr_file.*
 
    ###  MOD-480590 ####
 
   DEFINE   l_za05      LIKE type_file.chr50     #NO.FUN-680101 VARCHAR(40)
 
   CALL cl_outnam('amsp630') RETURNING l_name
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    #### END MOD-480590 ####
 
 
   SELECT * INTO l_mpr.* FROM mpr_file 
    WHERE mpr_v = ver_no
   IF STATUS THEN 
      LET g_success='N'
#     CALL cl_err('sel mpr_file',STATUS,1) #No.FUN-660108
      CALL cl_err3("sel","mpr_file",ver_no,"",STATUS,"","sel mpr",1)       #No.FUN-660108
      RETURN
   END IF
 
   LET g_sql="SELECT mps_file.* FROM mps_file,ima_file",
             " WHERE mps01=ima01 AND mps09 > 0 AND mps10='N'",
             "   AND ima08<>'P'",   #採購料件 (Purchase)
             "   AND mps_v='",ver_no,"'",
             "   AND ",g_wc CLIPPED
   PREPARE p630_p FROM g_sql
   DECLARE p630_c CURSOR FOR p630_p
  # LET l_name='amsp630.out'                    #MOD-480590
 #  LET g_len=80
   LET g_len=81  #TQC-6A0080
 
   LET msb.msb02 = 0
 
   START REPORT p630_rep TO l_name
   LET g_pageno = 0
   
# MPS 模擬時選擇要保留現有MPS 計劃時, 應將原要保留項目寫到本次 release
# 所產生的 MPS 計劃中
   IF l_mpr.mps_save = 'Y' AND l_mpr.mps_msa01 <> ' ' THEN
      INITIALIZE mps.* TO NULL
      DECLARE msb_curs CURSOR FOR 
       SELECT msb03,msb04,msb05 FROM msb_file
        WHERE msb01 = l_mpr.mps_msa01 
          AND msb04 >= l_mpr.mbdate
          AND msb04 <= l_mpr.medate
      FOREACH msb_curs INTO mps.mps01,mps.mps03,mps.mps09
          LET mps.mps_v = ver_no
          LET mps.mpsplant = g_plant  #FUN-A90063
          LET mps.mpslegal = g_legal  #FUN-A90063
          INSERT INTO p630_tmp VALUES(mps.*)
          IF STATUS THEN
             CALL cl_err('ins tmp1:',STATUS,1)
             LET g_success = 'N'
          END IF
         #OUTPUT TO REPORT p630_rep(mps.*)
      END FOREACH
   END IF
 
   FOREACH p630_c INTO mps.*
      INSERT INTO p630_tmp VALUES(mps.*)
      IF STATUS THEN
         CALL cl_err('ins tmp2:',STATUS,1)
         LET g_success = 'N'
      END IF
     #OUTPUT TO REPORT p630_rep(mps.*)
   END FOREACH
 
   DECLARE p630_tmp_cs CURSOR FOR
    SELECT * FROM p630_tmp
     ORDER BY mps01,mps03
   FOREACH p630_tmp_cs INTO mps.*
      OUTPUT TO REPORT p630_rep(mps.*)
   END FOREACH
   
   FINISH REPORT p630_rep
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
   WHILE TRUE
      IF g_bgjob = "N" THEN      #MOD-CA0068 add
         IF cl_confirm("ams-018") THEN
            EXIT WHILE 
         ELSE
            LET g_success = 'N' EXIT WHILE
         END IF
      ELSE              #MOD-CA0068 add
         EXIT WHILE     #MOD-CA0068 add
      END IF            #MOD-CA0068 add
   END WHILE
   CLOSE WINDOW p630_sure_w
 
END FUNCTION
 
REPORT p630_rep(mps)
  DEFINE mps		RECORD LIKE mps_file.*
  DEFINE l_ima08        LIKE ima_file.ima08,
         l_last_sw      LIKE type_file.chr1       #NO.FUN-680101 VARCHAR(1)
  DEFINE l_ima25        LIKE ima_file.ima25       #No:MOD-810190 add
  DEFINE l_ima55        LIKE ima_file.ima55       #No:MOD-810190 add
  DEFINE l_ima55_fac    LIKE ima_file.ima55_fac   #No:MOD-810190 add
  DEFINE l_cnt          LIKE type_file.num5       #No:MOD-810190 add
 
  OUTPUT TOP MARGIN g_top_margin 
  LEFT MARGIN g_left_margin 
  BOTTOM MARGIN g_bottom_margin
  PAGE LENGTH g_page_line
 
  ORDER EXTERNAL BY mps.mps01,mps.mps03
  FORMAT
    PAGE HEADER
      LET l_last_sw = 'n'
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED   #TQC-6A0080
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #TQC-6A0080
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED
      PRINT g_dash1
 
    ON EVERY ROW
     #-----------No:MOD-810190 modify
     #SELECT ima08 INTO l_ima08 FROM ima_file WHERE ima01=mps.mps01 
      SELECT ima08,ima25,ima55 INTO l_ima08,l_ima25,l_ima55 
        FROM ima_file WHERE ima01=mps.mps01  #No:MOD-810190 modify

      CALL s_umfchk(mps.mps01,l_ima25,l_ima55) RETURNING l_cnt,l_ima55_fac
      IF l_cnt = 1 THEN
        LET l_ima55_fac = 1
      END IF
     #-----------No:MOD-810190 end

      IF STATUS THEN LET l_ima08='M' END IF
### -------------------------------------------------
#     IF l_ima08='M' OR l_ima08='T' THEN LET msb.msb02='1' END IF
#     IF l_ima08='S' THEN LET msb.msb02='7' END IF
      LET msb.msb02  =msb.msb02 + 1   # 項次
      LET msb.msb03  =mps.mps01       # 料號
      LET msb.msb04  =mps.mps03       # 預計生產完工日期
     #LET msb.msb05  =mps.mps09       # MPS 數量             #No:MOD-810190 mark
      LET msb.msb05  =mps.mps09*l_ima55_fac       # MPS 數量 #No:MOD-810190 add
      LET msb.msb06  =''
      LET msb.msb07  =msb.msb04       # BOM 有效日期
      LET msb.msb08  =msb.msb05       # 原始計劃數量
      LET msb.msbplant = g_plant   #FUN-980005
      LET msb.msblegal = g_legal   #FUN-980005
 
      PRINT COLUMN g_c[31],msb.msb01,
            COLUMN g_c[32],msb.msb02 USING '####',
            COLUMN g_c[33],msb.msb03,
            COLUMN g_c[34],msb.msb04,
            COLUMN g_c[35],msb.msb05 USING '##########&.###'   #No.TQC-770034 
      INSERT INTO msb_file VALUES(msb.*)
      IF STATUS THEN 
 #    CALL cl_err('ins msb:',STATUS,1)  #No.FUN-660108
      CALL cl_err3("ins","msb_file",msb.msb01,msb.msb02,STATUS,"","ins msb:",1)       #No.FUN-660108
          CALL cl_batch_bg_javamail("N")   #NO.FUN-570127
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM 
      END IF
 
#   mps.mps_v 若為 NULL 表示為 MPS 模擬時所指定保留的項目,則不用更新 mps10
      IF NOT cl_null(mps.mps_v) THEN
         UPDATE mps_file SET mps10='Y'
          WHERE mps01=mps.mps01 AND mps02=mps.mps02 AND mps03=mps.mps03 AND
                mps_v=mps.mps_v
         IF STATUS THEN 
#        CALL cl_err('upd mps10:',STATUS,1)  #No.FUN-660108
         CALL cl_err3("upd","mps_file",mps.mps01,mps.mps03,STATUS,"","upd mps10:",1)       #No.FUN-660108
             CALL cl_batch_bg_javamail("N")  #NO.FUN-570127
             CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
             EXIT PROGRAM 
         END IF
      END IF
 
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash CLIPPED
      PRINT '(amsp630)'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash CLIPPED
              PRINT '(amsp630)'
         ELSE SKIP 2 LINE
      END IF
 
END REPORT
 
FUNCTION p630_create_tmp()
 
  DROP TABLE p630_tmp;
  SELECT mps_file.* FROM mps_file
#  WHERE 1=1 INTO TEMP p630_tmp      #TQC-7B0023
   WHERE 1=2 INTO TEMP p630_tmp      #TQC-7B0023
#  DELETE FROM p630_tmp WHERE 1=1    #TQC-7B0023
 
END FUNCTION
 
FUNCTION p630_process()
 
    LET g_mpz.mpz04 = g_mpl.mpl01,' ',g_mpl.mpl02
 
    # mpk_v空白表示為release為MPS計劃時的時距
    DELETE FROM mpk_file WHERE mpk_v=' '
    IF STATUS THEN
  #    CALL cl_err('del mpk_file',STATUS,1) #No.FUN-660108
       CALL cl_err3("del","mpk_file","","",STATUS,"","del mpk_file",1)       #No.FUN-660108
       LET g_success='N'
    END IF
 
    DROP TABLE x
    SELECT * FROM mpk_file WHERE mpk_v = ver_no INTO TEMP x
    UPDATE x SET mpk_v = ' '
    INSERT INTO mpk_file SELECT * FROM x
 
    DELETE FROM mpm_file WHERE mpm_v=' '
    IF STATUS THEN
 #     CALL cl_err('del mpm_file',STATUS,1) #No.FUN-660108
       CALL cl_err3("del","mpm_file","","",STATUS,"","del mpm_file",1)       #No.FUN-660108
       LET g_success='N'
    END IF
 
    DROP TABLE x
    SELECT * FROM mpm_file WHERE mpm_v = ver_no INTO TEMP x
    UPDATE x SET mpm_v = ' '
    INSERT INTO mpm_file SELECT * FROM x
 
    UPDATE mpz_file SET mpz_v = ver_no,mpz04=g_mpz.mpz04
    IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
       LET g_success='N'
  #    CALL cl_err('upd mpz_file',STATUS,1) #No.FUN-660108
       CALL cl_err3("upd","mpz_file",ver_no,g_mpz.mpz04,STATUS,"","upd mpz_file",1)       #No.FUN-660108
    END IF
 
END FUNCTION
 
