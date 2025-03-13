# Prog. Version..: '5.30.06-13.03.27(00010)'     #
#
# Pattern name...: afap999.4gl
# Descriptions...: 固定資產期初轉檔作業                    
# Date & Author..: 99/09/17 By Sophia
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-480085 04/08/23 By Nicola 加入離開功能
# Modify.........: No.FUN-570144 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-720085 07/02/12 By Smapmin INSERT INTO fan_file 時,fan10='2'
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.MOD-950282 09/06/01 By Sarah 新增前判斷key值是否已存在,若是則不新增,並產生彙總錯誤訊息
# Modify.........: No.FUN-980003 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0093 09/12/23 By sabrina fan10的值改成faj43 
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No:MOD-B40085 11/04/13 By Sarah 增完fan_file與fbn_file後,若faj23='2'需再產生多部門分攤(fan05='3')的資料
# Modify.........: No:TQC-BA0070 11/10/14 By Sarah 修正MOD-B40085,g_cnt2忘記給預設值
# Modify.........: No:FUN-BB0093 12/01/12 By Sakura 財簽二Mark,拆置afap997 
# Modify.........: No:MOD-C20187 12/02/24 By Polly 多部門分攤時，增加fan02的條件
# Modify.........: No:MOD-C50026 12/05/07 By suncx fan09/fan20沒有賦值
# Modify.........: No:MOD-C70222 12/07/20 By suncx 如果fan_file资料重复，则需要UPDATE
# Modify.........: No:MOD-D30116 13/03/12 By Polly 調整update多部門折舊金額條件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       STRING,                       #No.FUN-580092 HCN
       tm               RECORD
                         wc  LIKE type_file.chr1000,  #No.FUN-680070 VARCHAR(1000)
                         yy  LIKE type_file.num5,     #No.FUN-680070 SMALLINT
                         mm  LIKE type_file.num5      #No.FUN-680070 SMALLINT
                        END RECORD,
       b_date,e_date    LIKE type_file.dat,           #No.FUN-680070 DATE
       g_dc             LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
       g_amt1,g_amt2    LIKE type_file.num20_6,       #No.FUN-680070 DECIMAL(20,6)
       g_flag           LIKE type_file.chr1,          #No.FUN-570144       #No.FUN-680070 VARCHAR(1)
       g_change_lang    LIKE type_file.chr1,          #是否有做語言切換 No.FUN-570144       #No.FUN-680070 VARCHAR(01)
       p_row,p_col      LIKE type_file.num5,          #No.FUN-680070 SMALLINT
#str MOD-B40085 add
       m_tot            LIKE type_file.num20_6,
       m_tot_fan07      LIKE fan_file.fan07, 
       m_tot_fan14      LIKE fan_file.fan14, 
       m_tot_fan15      LIKE fan_file.fan15, 
       m_tot_fan17      LIKE fan_file.fan17,
       m_tot_curr       LIKE type_file.num20_6,
       g_cnt,g_cnt2     LIKE type_file.num5,
       m_fad05          LIKE fad_file.fad05,
       m_fad031         LIKE fad_file.fad031,
       m_fae08,mm_fae08 LIKE fae_file.fae08,
       m_aao            LIKE type_file.num20_6,
       m_amt            LIKE type_file.num20_6,  
       m_amt2           LIKE type_file.num20_6,  
       m_cost           LIKE type_file.num20_6,  
       m_accd           LIKE type_file.num20_6,  
       m_curr           LIKE type_file.num20_6,  
       m_amt_o          LIKE type_file.num20_6,
       m_fan07          LIKE fan_file.fan07, 
       m_fan08          LIKE fan_file.fan08, 
       m_fan14          LIKE fan_file.fan14, 
       m_fan15          LIKE fan_file.fan15, 
       m_fan17          LIKE fan_file.fan17,
       mm_fan07         LIKE fan_file.fan07,
       mm_fan08         LIKE fan_file.fan08,
       mm_fan14         LIKE fan_file.fan14,
       mm_fan15         LIKE fan_file.fan15,
       mm_fan17         LIKE fan_file.fan17,
       m_ratio,mm_ratio LIKE type_file.num26_10,   
       m_max_ratio      LIKE type_file.num26_10,
       m_max_fae06      LIKE fae_file.fae06,
       g_fan07_year     LIKE fan_file.fan07,
       g_fan07_all      LIKE fan_file.fan07,
       y_curr           LIKE fan_file.fan08,
       m_fae06          LIKE fae_file.fae06,
       l_fan07          LIKE fan_file.fan07,
       l_fan08          LIKE fan_file.fan08,
       l_diff,l_diff2   LIKE fan_file.fan07,
       g_show_msg       DYNAMIC ARRAY OF RECORD  
                         faj02     LIKE faj_file.faj02,
                         faj022    LIKE faj_file.faj022,
                         ze01      LIKE ze_file.ze01,
                         ze03      LIKE ze_file.ze03
                        END RECORD,
       l_msg,l_msg2     STRING,
       lc_gaq03         LIKE gaq_file.gaq03,
       m_tot_fbn07      LIKE fbn_file.fbn07, 
       m_tot_fbn14      LIKE fbn_file.fbn14, 
       m_tot_fbn15      LIKE fbn_file.fbn15, 
       m_tot_fbn17      LIKE fbn_file.fbn17,
       g_fbn            RECORD LIKE fbn_file.*,
       m_fbn07          LIKE fbn_file.fbn07, 
       m_fbn08          LIKE fbn_file.fbn08, 
       m_fbn14          LIKE fbn_file.fbn14, 
       m_fbn15          LIKE fbn_file.fbn15, 
       m_fbn17          LIKE fbn_file.fbn17,
       mm_fbn07         LIKE fbn_file.fbn07,
       mm_fbn08         LIKE fbn_file.fbn08,
       mm_fbn14         LIKE fbn_file.fbn14,
       mm_fbn15         LIKE fbn_file.fbn15,
       mm_fbn17         LIKE fbn_file.fbn17,
       l_li             LIKE type_file.num10,
       g_fbn07_year     LIKE fbn_file.fbn07,
       g_fbn07_all      LIKE fbn_file.fbn07,
       l_fbn07          LIKE fbn_file.fbn07,
       l_fbn08          LIKE fbn_file.fbn08
#end MOD-B40085 add
 
MAIN
#DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0069

   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #->No.FUN-570144 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc  = ARG_VAL(1)
   LET tm.yy  = ARG_VAL(2)
   LET tm.mm  = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #->No.FUN-570144 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570144 MARK--
#   OPEN WINDOW p999_w AT p_row,p_col WITH FORM "afa/42f/afap999"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#    CALL cl_ui_init()
#NO.FUN-570144 MARK---
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
#NO.FUN-570144 START-------------------------
   IF g_bgjob ='N' THEN
      INITIALIZE tm.* TO NULL
   END IF
 
   SELECT faa07,faa08 INTO tm.yy,tm.mm FROM faa_file
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p999()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL g_show_msg.clear()              #MOD-B40085 add
            CALL p999_1()
           #CALL s_showmsg()   #MOD-950282 add   #MOD-B40085 mark
           #str MOD-B40085 add
            IF g_show_msg.getLength() > 0 THEN 
               CALL cl_get_feldname("faj02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_get_feldname("faj022",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
               CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
               CONTINUE WHILE
            END IF
           #end MOD-B40085 add
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING g_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING g_flag
            END IF
            IF g_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p999_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL g_show_msg.clear()              #MOD-B40085 add
         CALL p999_1()
        #CALL s_showmsg()   #MOD-950282 add   #MOD-B40085 mark
        #str MOD-B40085 add
         IF g_show_msg.getLength() > 0 THEN 
            CALL cl_get_feldname("faj02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_get_feldname("faj022",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
            CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
         END IF
        #end MOD-B40085 add
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#->No.FUN-570144 ---end---
 # CALL p999()
 # CLOSE WINDOW p999_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
END MAIN
 
FUNCTION p999()
DEFINE   lc_cmd        LIKE type_file.chr1000           #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
 
   #->No.FUN-570144 --start--
   LET p_row = 5 LET p_col = 28
 
   OPEN WINDOW p999_w AT p_row,p_col WITH FORM "afa/42f/afap999"
     ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
 
   #->No.FUN-570144 ---end---
 
   CLEAR FORM
   
   INITIALIZE tm.* TO NULL
   SELECT faa07,faa08 INTO tm.yy,tm.mm FROM faa_file
   DISPLAY tm.yy TO FORMONLY.yy 
   DISPLAY tm.mm TO FORMONLY.mm 
   
   WHILE TRUE
      CALL cl_opmsg('z')
      CONSTRUCT BY NAME tm.wc ON faj04,faj02,faj25
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
         #CALL cl_dynamic_locale()
         # CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE        #->No.FUN-570144
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
 
  
      #-----No.MOD-480085----- 
     ON ACTION exit
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     #-----END--------------- 
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup') #FUN-980030
 
#NO.FUN-570144 start----
#      IF INT_FLAG THEN
#         EXIT WHILE 
#      END IF
  IF g_change_lang THEN
     LET g_change_lang = FALSE
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     CONTINUE WHILE
  END IF
 
  IF INT_FLAG THEN
     LET INT_FLAG=0
     CLOSE WINDOW p999_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
  END IF
 
#->No.FUN-570144 --end--
      
      LET g_bgjob ='N' #NO.FUN-570144 
      #INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS 
      INPUT BY NAME tm.yy,tm.mm,g_bgjob   WITHOUT DEFAULTS   #NO.FUN-570144 
  
         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               NEXT FIELD yy
            END IF
      
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
#No.TQC-720032 -- end --
            IF cl_null(tm.mm) THEN
               NEXT FIELD mm 
            END IF
#No.TQC-720032 -- begin --
#            IF tm.mm < 1 OR tm.mm > 12 THEN
#               NEXT FIELD mm
#            END IF
#No.TQC-720032 -- end --   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      
          #-----No.MOD-480085----- 
         ON ACTION exit
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
         #-----END--------------- 
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
        #->No.FUN-570144 --start--
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
        #->No.FUN-570144 ---end---
 
      END INPUT
 
#NO.FUN-570144 start--------------------
  IF g_change_lang THEN
     LET g_change_lang = FALSE
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     CONTINUE WHILE
  END IF
 
  IF INT_FLAG THEN
     LET INT_FLAG=0
     CLOSE WINDOW p999_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
  END IF
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         RETURN
#      END IF
#      IF NOT cl_sure(0,0) THEN
#         RETURN
#      END IF
#      CALL cl_wait()
#      CALL p999_1()
#      MESSAGE ''
#      CALL cl_end(0,0)
  IF g_bgjob = 'Y' THEN
     SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'afap999'
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('afap999','9031',1)
     ELSE
        LET g_wc = cl_replace_str(g_wc,"'","\"")
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",tm.wc CLIPPED,"'",
                     " '",tm.yy CLIPPED,"'",
                     " '",tm.mm CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('afap999',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p999_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
  END IF
#NO.FUN-570144 end--------------
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION p999_1()
 DEFINE l_faj     RECORD LIKE faj_file.*,
        l_fan     RECORD LIKE fan_file.*, 
        l_fbn     RECORD LIKE fbn_file.*,    #No:FUN-AB0088
        l_sql     LIKE type_file.chr1000,    #No.FUN-680070 VARCHAR(1000)
        i         LIKE type_file.num10,      #No.FUN-680070 INTEGER
        j         LIKE type_file.num10,      #No.FUN-680070 INTEGER
        l_var     LIKE type_file.chr1,       #No.FUN-680070 VARCHAR(1)
        l_cnt     LIKE type_file.num5,       #MOD-950282 add
#str MOD-B40085 add
        p_yy,p_mm LIKE type_file.num5,   
        g_fan     RECORD LIKE fan_file.*,
        g_fae     RECORD LIKE fae_file.*,
        g_fbn     RECORD LIKE fbn_file.*, 
        l_aag04   LIKE aag_file.aag04,
        p_fan08   LIKE fan_file.fan08,
        p_fan15   LIKE fan_file.fan15,
        p_fbn08   LIKE fbn_file.fbn08, 
        p_fbn15   LIKE fbn_file.fbn15,
        l_cnt1    LIKE type_file.num5
#end MOD-B40085 add
 
  LET l_sql ="SELECT * FROM faj_file WHERE ",tm.wc CLIPPED
  PREPARE p999_pre FROM l_sql
  DECLARE p999_cur CURSOR FOR p999_pre
 
  CALL s_showmsg_init()   #MOD-950282 add
  LET i = 0
  LET j = 0
  LET g_cnt2 = 1   #TQC-BA0070 add
  FOREACH p999_cur INTO l_faj.*
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('foreach',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF
 
    IF l_faj.faj28 ='0' THEN         #'0'.不提折舊
       CONTINUE FOREACH
    END IF   
    LET l_fan.fan01 = l_faj.faj02
    LET l_fan.fan02 = l_faj.faj022
    LET l_fan.fan03 = tm.yy
    LET l_fan.fan04 = tm.mm
    LET l_fan.fan041= '0'     #No:5790
    LET l_fan.fan05 = l_faj.faj23
    LET l_fan.fan06 = l_faj.faj20
    LET l_fan.fan07 = 0
    LET l_fan.fan08 = l_faj.faj203
    LET l_fan.fan09 = l_faj.faj24   #MOD-C50026 add
    LET l_fan.fan10 = l_faj.faj43   #MOD-720085     #MOD-9C0093 2 modify l_faj.faj43
    LET l_fan.fan11 = l_faj.faj53
    LET l_fan.fan12 = l_faj.faj55
    #No.FUN-680028 --begin
   ##-----No:FUN-AB0088 Mark-----
   # IF g_aza.aza63 = 'Y' THEN
   #    LET l_fan.fan111= l_faj.faj531
   #    LET l_fan.fan121= l_faj.faj551
   # END IF
   ##-----No:FUN-AB0088 Mark END-----
    #No.FUN-680028 --end
    LET l_fan.fan13 = l_faj.faj24
    LET l_fan.fan14 = l_faj.faj14 + l_faj.faj141 - l_faj.faj59
    LET l_fan.fan15 = l_faj.faj32
    LET l_fan.fan16 = 0
    LET l_fan.fan17 = l_faj.faj101          #No:A099
    #CHI-790004..................begin
    IF cl_null(l_fan.fan06) THEN
       LET l_fan.fan06=' '
    END IF
    #CHI-790004..................end
 
    LET l_fan.fanlegal = g_legal #FUN-980003 add
    LET l_fan.fan20 = l_faj.faj54   #MOD-C50026 add
    LET l_fan.fan201= l_faj.faj541  #MOD-C50026 add
 
    #str MOD-950282 add
    #資料重覆則跳過不新增,但寫入彙總訊息裡,重复资料需要UPDATE
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM fan_file
      WHERE fan01 =l_fan.fan01  AND fan02=l_fan.fan02
        AND fan03 =l_fan.fan03  AND fan04=l_fan.fan04
        AND fan041=l_fan.fan041
        AND fan05 =l_fan.fan05  AND fan06=l_fan.fan06        
     IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
     IF l_cnt > 0 THEN
        #MOD-C70222 modfiy begin--------------------
        #LET g_showmsg=l_fan.fan01,"/",l_fan.fan02,"/",l_fan.fan03,"/",
        #              l_fan.fan04,"/",l_fan.fan041,"/",l_fan.fan05,"/",
        #              l_fan.fan06
        #CALL s_errmsg("fan01,fan02,fan03,fan04,fan041,fan05,fan06",g_showmsg,
        #              "insert fan_file",'-239',1)
        #CONTINUE FOREACH
        UPDATE fan_file SET fan_file.* = l_fan.*
         WHERE fan01 =l_fan.fan01  AND fan02=l_fan.fan02
           AND fan03 =l_fan.fan03  AND fan04=l_fan.fan04
           AND fan041=l_fan.fan041
           AND fan05 =l_fan.fan05  AND fan06=l_fan.fan06 
        #MOD-C70222 modfiy end----------------------
     #MOD-C70222 add begin--------
     ELSE 
        INSERT INTO fan_file VALUES (l_fan.*)  
     #MOD-C70222 add end----------
     END IF
    #end MOD-950282 add
 
    #INSERT INTO fan_file VALUES (l_fan.*)   #MOD-C70222 mark
    IF g_bgjob = 'N' THEN  #NO.FUN-570144 
       MESSAGE l_faj.faj02,l_faj.faj022   
       CALL ui.Interface.refresh()
    END IF

   #str MOD-B40085 add
    IF l_faj.faj23 = '2' THEN
       #-------- 折舊明細檔 SQL (針對多部門分攤折舊金額) ---------------
       LET g_sql="SELECT * FROM fan_file WHERE fan03='",tm.yy,"'",
                 "                         AND fan04='",tm.mm,"'",
                 "                         AND fan05='2' AND fan041='0' ",
                 "                         AND fan01='",l_faj.faj02,"'", 
                 "                         AND fan02='",l_faj.faj022,"'"     #MOD-C20187 add
       PREPARE p999_pre1 FROM g_sql
       DECLARE p999_cur1 CURSOR WITH HOLD FOR p999_pre1
       FOREACH p999_cur1 INTO g_fan.*
          IF STATUS THEN
             LET g_show_msg[g_cnt2].faj02  = l_faj.faj02 
             LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
             LET g_show_msg[g_cnt2].ze01   = ''
             LET g_show_msg[g_cnt2].ze03   = 'foreach p999_cur1'
             LET g_cnt2 = g_cnt2 + 1
             LET g_success='N'  
             CONTINUE FOREACH
          END IF
          #-->讀取分攤方式
          SELECT fad05,fad03 INTO m_fad05,m_fad031 FROM fad_file
           WHERE fad01=g_fan.fan03 AND fad02=g_fan.fan04
             AND fad03=g_fan.fan11 AND fad04=g_fan.fan13
             AND fad07="1"
          IF SQLCA.sqlcode THEN 
             CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
             LET g_show_msg[g_cnt2].faj02  = l_faj.faj02 
             LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
             LET g_show_msg[g_cnt2].ze01   = 'afa-152'
             LET g_show_msg[g_cnt2].ze03   = l_msg
             LET g_cnt2 = g_cnt2 + 1
             LET g_success='N'
             CONTINUE FOREACH
          END IF
          #-->讀取分母
          IF m_fad05='1' THEN
             SELECT SUM(fae08) INTO m_fae08 FROM fae_file
              WHERE fae01=g_fan.fan03 AND fae02=g_fan.fan04
                AND fae03=g_fan.fan11 AND fae04=g_fan.fan13
                AND fae10="1"
             IF SQLCA.sqlcode OR cl_null(m_fae08) THEN 
                CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
                LET g_show_msg[g_cnt2].faj02  = l_faj.faj02 
                LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
                LET g_show_msg[g_cnt2].ze01   = 'afa-152'
                LET g_show_msg[g_cnt2].ze03   = l_msg
                LET g_cnt2 = g_cnt2 + 1
                LET g_success='N'
                CONTINUE FOREACH 
             END IF
             LET mm_fae08 = m_fae08            # 分攤比率合計
          END IF
       
          #-->保留金額以便處理尾差
          LET mm_fan07=g_fan.fan07          # 被分攤金額
          LET mm_fan08=g_fan.fan08          # 本期累折金額
          LET mm_fan14=g_fan.fan14          # 被分攤成本
          LET mm_fan15=g_fan.fan15          # 被分攤累折
          LET mm_fan17=g_fan.fan17          # 被分攤減值 
       
          #------- 找 fae_file 分攤單身檔 ---------------
          LET m_tot=0  
          DECLARE p999_cur2 CURSOR WITH HOLD FOR
          SELECT * FROM fae_file
           WHERE fae01=g_fan.fan03 AND fae02=g_fan.fan04
             AND fae03=g_fan.fan11 AND fae04=g_fan.fan13
             AND fae10="1"
          FOREACH p999_cur2 INTO g_fae.*
             IF SQLCA.sqlcode OR (cl_null(m_fae08) AND m_fad05='1') THEN
                CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
                LET g_show_msg[g_cnt2].faj02  = l_faj.faj02 
                LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
                LET g_show_msg[g_cnt2].ze01   = 'afa-152'
                LET g_show_msg[g_cnt2].ze03   = l_msg
                LET g_cnt2 = g_cnt2 + 1
                LET g_success='N'
                CONTINUE FOREACH 
             END IF
             CASE m_fad05
                WHEN '1'
                   LET l_cnt1 = 0
                   SELECT COUNT(*) INTO l_cnt1 FROM fan_file
                    WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                      AND fan03=g_fan.fan03 AND fan04=g_fan.fan04
                      AND fan06=g_fae.fae06 AND fan05='3'
                      AND (fan041 = '1' OR fan041='0')    
                   LET mm_ratio=g_fae.fae08/mm_fae08*100     # 分攤比率(存入fan16用)
                   LET m_ratio=g_fae.fae08/m_fae08*100       # 分攤比率
                   LET m_fan07=mm_fan07*m_ratio/100          # 分攤金額
                   LET m_curr =mm_fan08*m_ratio/100          # 分攤金額
                   LET m_fan14=mm_fan14*m_ratio/100          # 分攤成本
                   LET m_fan15=mm_fan15*m_ratio/100          # 分攤累折
                   LET m_fan17=mm_fan17*m_ratio/100          # 分攤減值 
                   LET m_fae08 = m_fae08 - g_fae.fae08       # 總分攤比率減少
                   LET m_fan07 = cl_digcut(m_fan07,g_azi04)
                   LET mm_fan07 = mm_fan07 - m_fan07         # 被分攤總數減少
                   LET m_curr   = cl_digcut(m_curr,g_azi04)
                   LET mm_fan08 = mm_fan08 - m_curr          # 被分攤總數減少
                   LET m_fan14 = cl_digcut(m_fan14,g_azi04)
                   LET mm_fan14 = mm_fan14 - m_fan14         # 被分攤總數減少
                   LET m_fan15  = cl_digcut(m_fan15,g_azi04)
                   LET mm_fan15 = mm_fan15 - m_fan15         # 被分攤總數減少
                   LET m_fan17  = cl_digcut(m_fan17,g_azi04)  
                   LET mm_fan17 = mm_fan17 - m_fan17         # 被分攤總數減少
                   IF l_cnt1 > 0 THEN
                      UPDATE fan_file SET fan07 = m_fan07,
                                          fan08 = m_curr,
                                          fan09 = g_fan.fan06,
                                          fan12 = g_fae.fae07,
                                          fan14 = m_fan14,
                                          fan15 = m_fan15,
                                          fan16 = mm_ratio,
                                          fan17 = m_fan17
                       WHERE fan01 = g_fan.fan01 AND fan02 = g_fan.fan02
                         AND fan03 = g_fan.fan03 AND fan04 = g_fan.fan04
                      #  AND fan05 = g_fan.fan05 AND fan06 = g_fan.fan06    #MOD-D30116 mark  
                      #  AND fan041= g_fan.fan041                           #MOD-D30116 mark
                         AND fan05 = '3'                                    #MOD-D30116 add:
                         AND fan06 = g_fae.fae06                            #MOD-D30116 add
                         AND (fan041 = '1' OR fan041 = '0')                 #MOD-D30116 add
                      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                         LET g_show_msg[g_cnt2].faj02  = l_faj.faj02 
                         LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
                         LET g_show_msg[g_cnt2].ze01   = ''
                         LET g_show_msg[g_cnt2].ze03   = 'upd fan_file'
                         LET g_cnt2 = g_cnt2 + 1
                         LET g_success='N'
                         CONTINUE FOREACH 
                      END IF
                   ELSE
                      IF cl_null(g_fae.fae06) THEN
                         LET g_fae.fae06=' '
                      END IF
                      LET m_curr = cl_digcut(m_curr,g_azi04)
                      INSERT INTO fan_file(fan01,fan02,fan03,fan04,fan041,   
                                           fan05,fan06,fan07,fan08,fan09,    
                                           fan10,fan11,fan12,fan13,fan14,    
                                           fan15,fan16,fan17,fan20,fan201,
                                           fanlegal)
                                    VALUES(g_fan.fan01,g_fan.fan02,          
                                           g_fan.fan03,g_fan.fan04,'0','3',  
                                           g_fae.fae06,m_fan07,m_curr,       
                                           g_fan.fan06,l_faj.faj43,g_fan.fan11,   
                                           g_fae.fae07,g_fan.fan13,m_fan14,  
                                           m_fan15,mm_ratio,m_fan17,
                                           g_fan.fan20,g_fan.fan201,
                                           g_legal)  
                      IF STATUS THEN
                         LET g_show_msg[g_cnt2].faj02  = l_faj.faj02 
                         LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
                         LET g_show_msg[g_cnt2].ze01   = ''
                         LET g_show_msg[g_cnt2].ze03   = 'ins fan_file'
                         LET g_cnt2 = g_cnt2 + 1
                         LET g_success='N'
                         CONTINUE FOREACH 
                      END IF
                   END IF
                WHEN '2'
                   LET l_aag04 = ''
                   SELECT aag04 INTO l_aag04 FROM aag_file
                    WHERE aag01=g_fae.fae09 AND aag00=g_bookno1
                   IF l_aag04='1' THEN
                      SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                       WHERE aao00 =m_faa02b    AND aao01=g_fae.fae09
                         AND aao02 =g_fae.fae06 AND aao03=tm.yy
                         AND aao04<=tm.mm
                   ELSE
                      SELECT aao05-aao06 INTO m_aao FROM aao_file
                       WHERE aao00=m_faa02b    AND aao01=g_fae.fae09
                         AND aao02=g_fae.fae06 AND aao03=tm.yy
                         AND aao04=tm.mm
                   END IF
                   IF STATUS=100 OR m_aao IS NULL THEN LET m_aao=0 END IF
                   LET m_tot=m_tot+m_aao          ## 累加變動比率分母金額
             END CASE
          END FOREACH
 
          #----- 若為變動比率, 重新 foreach 一次 insert into fan_file -----------
          IF m_fad05='2' THEN
             LET m_max_ratio = 0
             LET m_max_fae06 =''
             FOREACH p999_cur2 INTO g_fae.*
                LET l_aag04 = ''
                SELECT aag04 INTO l_aag04 FROM aag_file
                 WHERE aag01=g_fae.fae09 AND aag00=g_bookno1
                IF l_aag04='1' THEN
                   SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                    WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                      AND aao02=g_fae.fae06 AND aao03=tm.yy AND aao04<=tm.mm
                ELSE
                   SELECT aao05-aao06 INTO m_aao FROM aao_file
                    WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                      AND aao02=g_fae.fae06 AND aao03=tm.yy AND aao04=tm.mm
                END IF
                IF STATUS=100 OR m_aao IS NULL THEN 
                   LET m_aao=0
                END IF
                SELECT SUM(fan07) INTO y_curr FROM fan_file
                 WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                   AND fan03=tm.yy       AND fan04<tm.mm         
                   AND fan06=g_fae.fae06 AND fan05='3' 
                IF cl_null(y_curr) THEN LET y_curr = 0 END IF 
                LET m_ratio = m_aao/m_tot*100
                IF m_ratio > m_max_ratio THEN
                   LET m_max_fae06 = g_fae.fae06
                   LET m_max_ratio = m_ratio
                END IF
                LET m_fan07=g_fan.fan07*m_ratio/100
                LET m_curr = y_curr + m_fan07
                LET m_fan14=g_fan.fan14*m_ratio/100
                LET m_fan15=g_fan.fan15*m_ratio/100
                LET m_fan17=g_fan.fan17*m_ratio/100   
                LET m_fan07 = cl_digcut(m_fan07,g_azi04)
                LET m_curr = cl_digcut(m_curr,g_azi04)
                LET m_fan14 = cl_digcut(m_fan14,g_azi04)
                LET m_fan15 = cl_digcut(m_fan15,g_azi04)
                LET m_fan17 = cl_digcut(m_fan17,g_azi04)
                LET m_tot_fan07=m_tot_fan07+m_fan07
                LET m_tot_curr =m_tot_curr +m_curr  
                LET m_tot_fan14=m_tot_fan14+m_fan14
                LET m_tot_fan15=m_tot_fan15+m_fan15
                LET m_tot_fan17=m_tot_fan17+m_fan17  
                SELECT COUNT(*) INTO g_cnt FROM fan_file
                 WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                   AND fan03=g_fan.fan03 AND fan04=g_fan.fan04
                   AND fan06=g_fae.fae06 AND fan05='3' AND fan041='0'
                IF g_cnt>0 THEN
                   UPDATE fan_file SET fan07 = m_fan07,
                                       fan08 = m_curr,
                                       fan09 = g_fan.fan06,
                                       fan12 = g_fae.fae07,
                                       fan16 = m_ratio,
                                       fan17 = m_fan17
                    WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                      AND fan03=g_fan.fan03 AND fan04=g_fan.fan04
                      AND fan06=g_fae.fae06 AND fan05='3' AND fan041='0'
                   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN  
                      LET g_show_msg[g_cnt2].faj02  = l_faj.faj02 
                      LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
                      LET g_show_msg[g_cnt2].ze01   = ''
                      LET g_show_msg[g_cnt2].ze03   = 'upd fan_file'
                      LET g_cnt2 = g_cnt2 + 1
                      LET g_success='N'
                      CONTINUE FOREACH 
                   END IF
                ELSE
                   IF cl_null(g_fae.fae06) THEN
                      LET g_fae.fae06=' '
                   END IF
                   LET m_curr = cl_digcut(m_curr,g_azi04)
                   INSERT INTO fan_file(fan01,fan02,fan03,fan04,fan041,fan05,      
                                        fan06,fan07,fan08,fan09,fan10,fan11,       
                                        fan12,fan13,fan14,fan15,fan16,fan17,
                                        fan20,fan201,fanlegal)
                              VALUES(g_fan.fan01,g_fan.fan02,g_fan.fan03,       
                                     g_fan.fan04,'0','3',g_fae.fae06,m_fan07,   
                                     m_curr,g_fan.fan06,l_faj.faj43,g_fan.fan11,       
                                     g_fae.fae07,g_fan.fan13,m_fan14,m_fan15,   
                                     m_ratio,m_fan17,g_fan.fan20,g_fan.fan201, 
                                     g_legal)
                   IF STATUS THEN
                      LET g_show_msg[g_cnt2].faj02  = l_faj.faj02 
                      LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
                      LET g_show_msg[g_cnt2].ze01   = ''
                      LET g_show_msg[g_cnt2].ze03   = 'ins fan_file'
                      LET g_cnt2 = g_cnt2 + 1
                      LET g_success='N'
                      CONTINUE FOREACH 
                   END IF
                END IF
             END FOREACH
             IF cl_null(m_max_fae06) THEN LET m_max_fae06=g_fae.fae06 END IF
          END IF
          IF m_fad05 = '2' THEN
             IF m_tot_fan07!=mm_fan07 OR m_tot_curr!=m_curr OR 
                m_tot_fan14!=mm_fan14 OR m_tot_fan15!=mm_fan15 THEN 
                LET m_fae06 = m_max_fae06
                SELECT fan07,fan08 INTO l_fan07,l_fan08 from fan_file
                 WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                   AND fan03=tm.yy AND fan04=tm.mm AND fan06=m_fae06
                   AND fan05='3' 
                LET l_diff = mm_fan07 - m_tot_fan07
                IF l_diff < 0 THEN 
                   LET l_diff = l_diff * -1 
                   IF l_fan07 < l_diff THEN
                      LET l_diff = 0
	           ELSE 
	              LET l_diff = l_diff * -1 
	           END IF
	        END IF 
	        IF cl_null(m_tot_curr) THEN
                   LET m_tot_curr=0
                END IF 
	        LET l_diff2 = mm_fan08 - m_tot_curr  
	        IF l_diff2 < 0 THEN 
	           LET l_diff2 = l_diff2 * -1 
	           IF l_fan08 < l_diff2 THEN
	              LET l_diff2 = 0 
	           ELSE 
	              LET l_diff2 = l_diff2 * -1
	           END IF
	        END IF 
	        UPDATE fan_file SET fan07=fan07+l_diff,
                                    fan08=fan08+l_diff2,
                                    fan14=fan14+mm_fan14-m_tot_fan14,
                                    fan15=fan15+mm_fan15-m_tot_fan15,
                                    fan17=fan17+mm_fan17-m_tot_fan17 
	         WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
	           AND fan03=tm.yy AND fan04=tm.mm AND fan06=m_fae06
	           AND fan05='3' 
	        IF STATUS OR SQLCA.sqlerrd[3]=0  THEN
	           LET g_success='N' 
	           CALL cl_err3("upd","fan_file",g_fan.fan01,g_fan.fan02,STATUS,"","upd fan",1)   
	           EXIT FOREACH
	        END IF
	     END IF
	     LET m_tot_fan07=0
	     LET m_tot_fan14=0
	     LET m_tot_fan15=0
	     LET m_tot_fan17=0        
	     LET m_tot_curr =0
	     LET m_tot=0
	  END IF      
       END FOREACH
    END IF
   #end MOD-B40085 add

   ##-----No:FUN-BB0093 Mark-----
   ##-----No:FUN-AB0088-----
   #IF g_faa.faa31 = 'Y' THEN
   #   IF l_faj.faj282 ='0' THEN         #'0'.不提折舊
   #      CONTINUE FOREACH
   #   END IF

   #   LET l_fbn.fbn01 = l_faj.faj02
   #   LET l_fbn.fbn02 = l_faj.faj022
   #   LET l_fbn.fbn03 = tm.yy
   #   LET l_fbn.fbn04 = tm.mm
   #   LET l_fbn.fbn041= '0'
   #   LET l_fbn.fbn05 = l_faj.faj232
   #   LET l_fbn.fbn06 = l_faj.faj20
   #   LET l_fbn.fbn07 = 0
   #   LET l_fbn.fbn08 = l_faj.faj2032
   #   LET l_fbn.fbn10 = l_faj.faj432
   #   LET l_fbn.fbn11 = l_faj.faj531
   #   LET l_fbn.fbn12 = l_faj.faj551
   #   LET l_fbn.fbn13 = l_faj.faj242
   #   LET l_fbn.fbn14 = l_faj.faj142 + l_faj.faj1412 - l_faj.faj592
   #   LET l_fbn.fbn15 = l_faj.faj322
   #   LET l_fbn.fbn16 = 0
   #   LET l_fbn.fbn17 = l_faj.faj1012

   #   IF cl_null(l_fbn.fbn06) THEN
   #      LET l_fbn.fbn06=' '
   #   END IF

   #   #資料重覆則跳過不新增,但寫入彙總訊息裡
   #    LET l_cnt = 0
   #    SELECT COUNT(*) INTO l_cnt FROM fbn_file
   #     WHERE fbn01 =l_fbn.fbn01  AND fbn02=l_fbn.fbn02
   #       AND fbn03 =l_fbn.fbn03  AND fbn04=l_fbn.fbn04
   #       AND fbn041=l_fbn.fbn041
   #       AND fbn05 =l_fbn.fbn05  AND fbn06=l_fbn.fbn06

   #    IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF

   #    IF l_cnt > 0 THEN
   #       LET g_showmsg=l_fbn.fbn01,"/",l_fbn.fbn02,"/",l_fbn.fbn03,"/",
   #                     l_fbn.fbn04,"/",l_fbn.fbn041,"/",l_fbn.fbn05,"/",
   #                     l_fbn.fbn06
   #       CALL s_errmsg("fbn01,fbn02,fbn03,fbn04,fbn041,fbn05,fbn06",g_showmsg,
   #                     "insert fbn_file",'-239',1)
   #       CONTINUE FOREACH
   #    END IF

   #   INSERT INTO fbn_file VALUES (l_fbn.*)
   #   IF g_bgjob = 'N' THEN
   #      MESSAGE l_faj.faj02,l_faj.faj022
   #      CALL ui.Interface.refresh()
   #   END IF

   #  #str MOD-B40085 add
   #   IF l_faj.faj232 = '2' THEN
   #      #-------- 折舊明細檔 SQL (針對多部門分攤折舊金額) ---------------
   #      LET g_sql="SELECT * FROM fbn_file ",
   #                " WHERE fbn03='",tm.yy,"'",
   #                "   AND fbn04='",tm.mm,"'",
   #                "   AND fbn05='2' AND fbn041='0' ",
   #                "   AND fbn01='",l_faj.faj02,"'"
   #      PREPARE p999_pre12 FROM g_sql
   #      DECLARE p999_cur12 CURSOR WITH HOLD FOR p999_pre12
   #      FOREACH p999_cur12 INTO g_fbn.*
   #         IF STATUS THEN
   #            LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
   #            LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
   #            LET g_show_msg[g_cnt2].ze01   = ''
   #            LET g_show_msg[g_cnt2].ze03   = 'foreach p999_cur12'
   #            LET g_cnt2 = g_cnt2 + 1
   #            LET g_success='N'
   #            CONTINUE FOREACH
   #         END IF
   #         #-->讀取分攤方式
   #         SELECT fad05,fad03 INTO m_fad05,m_fad031 FROM fad_file
   #          WHERE fad01=g_fbn.fbn03
   #            AND fad02=g_fbn.fbn04
   #            AND fad03=g_fbn.fbn11
   #            AND fad04=g_fbn.fbn13
   #            AND fad07="2"
   #         IF SQLCA.sqlcode THEN
   #            CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
   #            LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
   #            LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
   #            LET g_show_msg[g_cnt2].ze01   = 'afa-152'
   #            LET g_show_msg[g_cnt2].ze03   = l_msg
   #            LET g_cnt2 = g_cnt2 + 1
   #            LET g_success='N'
   #            CONTINUE FOREACH
   #         END IF
   #         #-->讀取分母
   #         IF m_fad05='1' THEN
   #            SELECT SUM(fae08) INTO m_fae08 FROM fae_file
   #              WHERE fae01=g_fbn.fbn03
   #                AND fae02=g_fbn.fbn04
   #                AND fae03=g_fbn.fbn11
   #                AND fae04=g_fbn.fbn13
   #                AND fae10="2"
   #            IF SQLCA.sqlcode OR cl_null(m_fae08) THEN
   #               CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
   #               LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
   #               LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
   #               LET g_show_msg[g_cnt2].ze01   = 'afa-152'
   #               LET g_show_msg[g_cnt2].ze03   = l_msg
   #               LET g_cnt2 = g_cnt2 + 1
   #               LET g_success='N'
   #               CONTINUE FOREACH
   #            END IF
   #            LET mm_fae08 = m_fae08            # 分攤比率合計
   #         END IF
  
   #         #-->保留金額以便處理尾差
   #         LET mm_fbn07=g_fbn.fbn07          # 被分攤金額
   #         LET mm_fbn08=g_fbn.fbn08          # 本期累折金額
   #         LET mm_fbn14=g_fbn.fbn14          # 被分攤成本
   #         LET mm_fbn15=g_fbn.fbn15          # 被分攤累折
   #         LET mm_fbn17=g_fbn.fbn17          # 被分攤減值
  
   #         #------- 找 fae_file 分攤單身檔 ---------------
   #         LET m_tot=0
   #         DECLARE p999_cur21 CURSOR WITH HOLD FOR
   #         SELECT * FROM fae_file
   #          WHERE fae01=g_fbn.fbn03
   #            AND fae02=g_fbn.fbn04
   #            AND fae03=g_fbn.fbn11
   #            AND fae04=g_fbn.fbn13
   #            AND fae10="2"
   #         FOREACH p999_cur21 INTO g_fae.*
   #            IF SQLCA.sqlcode OR (cl_null(m_fae08) AND m_fad05='1') THEN
   #               CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
   #               LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
   #               LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
   #               LET g_show_msg[g_cnt2].ze01   = 'afa-152'
   #               LET g_show_msg[g_cnt2].ze03   = l_msg
   #               LET g_cnt2 = g_cnt2 + 1
   #               LET g_success='N'
   #               CONTINUE FOREACH
   #            END IF
   #            CASE m_fad05
   #               WHEN '1'
   #                  SELECT COUNT(*) INTO l_li FROM fbn_file
   #                   WHERE fbn01=g_fbn.fbn01
   #                     AND fbn02=g_fbn.fbn02
   #                     AND fbn03=g_fbn.fbn03
   #                     AND fbn04=g_fbn.fbn04
   #                     AND fbn06=g_fae.fae06
   #                     AND fbn05='3'
   #                     AND (fbn041 = '1' OR fbn041='0')
   #                  IF STATUS=100 THEN
   #                     LET l_li=NULL
   #                  END IF
   #                  LET mm_ratio=g_fae.fae08/mm_fae08*100     # 分攤比率(存入fbn16用)
   #                  LET m_ratio=g_fae.fae08/m_fae08*100       # 分攤比率
   #                  LET m_fbn07=mm_fbn07*m_ratio/100          # 分攤金額
   #                  LET m_curr =mm_fbn08*m_ratio/100          # 分攤金額
   #                  LET m_fbn14=mm_fbn14*m_ratio/100          # 分攤成本
   #                  LET m_fbn15=mm_fbn15*m_ratio/100          # 分攤累折
   #                  LET m_fbn17=mm_fbn17*m_ratio/100          # 分攤減值
   #                  LET m_fae08 = m_fae08 - g_fae.fae08       # 總分攤比率減少
   #                  LET m_fbn07 = cl_digcut(m_fbn07,g_azi04)
   #                  LET mm_fbn07 = mm_fbn07 - m_fbn07         # 被分攤總數減少
   #                  LET m_curr   = cl_digcut(m_curr,g_azi04)
   #                  LET mm_fbn08 = mm_fbn08 - m_curr          # 被分攤總數減少
   #                  LET m_fbn14 = cl_digcut(m_fbn14,g_azi04)
   #                  LET mm_fbn14 = mm_fbn14 - m_fbn14         # 被分攤總數減少
   #                  LET m_fbn15  = cl_digcut(m_fbn15,g_azi04)
   #                  LET mm_fbn15 = mm_fbn15 - m_fbn15         # 被分攤總數減少
   #                  LET m_fbn17  = cl_digcut(m_fbn17,g_azi04)
   #                  LET mm_fbn17 = mm_fbn17 - m_fbn17         # 被分攤總數減少
   #                  IF l_li<>0 THEN
   #                     UPDATE fbn_file SET fbn07 = m_fbn07,
   #                                         fbn08 = m_curr,
   #                                         fbn09 = g_fbn.fbn06,
   #                                         fbn14 = m_fbn14,
   #                                         fbn15 = m_fbn15,
   #                                         fbn16 = mm_ratio,
   #                                         fbn17 = m_fbn17,
   #                                         fbn11 =m_fad031,
   #                                         fbn12 =g_fae.fae07
   #                      WHERE fbn01=g_fbn.fbn01
   #                        AND fbn02=g_fbn.fbn02
   #                        AND fbn03=g_fbn.fbn03
   #                        AND fbn04=g_fbn.fbn04
   #                        AND fbn06=g_fae.fae06
   #                        AND fbn05='3'
   #                        AND (fbn041 = '1' OR fbn041='0')
   #                     IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
   #                        LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
   #                        LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
   #                        LET g_show_msg[g_cnt2].ze01   = ''
   #                        LET g_show_msg[g_cnt2].ze03   = 'upd fbn_file'
   #                        LET g_cnt2 = g_cnt2 + 1
   #                        LET g_success='N'
   #                        CONTINUE FOREACH
   #                     END IF
   #                  ELSE
   #                     IF cl_null(g_fae.fae06) THEN
   #                        LET g_fae.fae06=' '
   #                     END IF
   #                     INSERT INTO fbn_file(fbn01,fbn02,fbn03,fbn04,fbn041,
   #                                          fbn05,fbn06,fbn07,fbn08,fbn09,
   #                                          fbn10,fbn11,fbn12,fbn13,fbn14,
   #                                          fbn15,fbn16,fbn17)
   #                                   VALUES(g_fbn.fbn01,g_fbn.fbn02,g_fbn.fbn03,       
   #                                          g_fbn.fbn04,'0','3',g_fae.fae06,m_fbn07,   
   #                                          m_curr,g_fan.fan06,l_faj.faj43,g_fbn.fbn11,       
   #                                          g_fae.fae07,g_fbn.fbn13,m_fbn14,m_fbn15,   
   #                                          mm_ratio,m_fbn17)
   #                     IF STATUS THEN
   #                        LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
   #                        LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
   #                        LET g_show_msg[g_cnt2].ze01   = ''
   #                        LET g_show_msg[g_cnt2].ze03   = 'ins fbn_file'
   #                        LET g_cnt2 = g_cnt2 + 1
   #                        LET g_success='N'
   #                        CONTINUE FOREACH
   #                     END IF
   #                  END IF
   #               WHEN '2'
   #                  LET l_aag04 = ''
   #                  SELECT aag04 INTO l_aag04 FROM aag_file
   #                   WHERE aag01=g_fae.fae09 AND aag00=g_faa.faa02c
   #                  IF l_aag04='1' THEN
   #                     SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
   #                      WHERE aao00 =m_faa02b    AND aao01=g_fae.fae09
   #                        AND aao02 =g_fae.fae06 AND aao03=tm.yy
   #                        AND aao04<=tm.mm
   #                  ELSE
   #                     SELECT aao05-aao06 INTO m_aao FROM aao_file
   #                      WHERE aao00=m_faa02b    AND aao01=g_fae.fae09
   #                        AND aao02=g_fae.fae06 AND aao03=tm.yy
   #                        AND aao04=tm.mm
   #                  END IF
   #                  IF STATUS=100 OR m_aao IS NULL THEN LET m_aao=0 END IF
   #                  LET m_tot=m_tot+m_aao          ## 累加變動比率分母金額
   #            END CASE
   #         END FOREACH
  
   #         #----- 若為變動比率, 重新 foreach 一次 insert into fbn_file -----------
   #         IF m_fad05='2' THEN
   #            LET m_max_ratio = 0
   #            LET m_max_fae06 =''
   #            FOREACH p999_cur21 INTO g_fae.*
   #               LET l_aag04 = ''
   #               SELECT aag04 INTO l_aag04 FROM aag_file
   #                WHERE aag01=g_fae.fae09 AND aag00=g_faa.faa02c
   #               IF l_aag04='1' THEN
   #                  SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
   #                   WHERE aao00=m_faa02b    AND aao01=g_fae.fae09
   #                     AND aao02=g_fae.fae06 AND aao03=tm.yy AND aao04<=tm.mm
   #               ELSE
   #                  SELECT aao05-aao06 INTO m_aao FROM aao_file
   #                   WHERE aao00=m_faa02b AND aao01=g_fae.fae09
   #                     AND aao02=g_fae.fae06 AND aao03=tm.yy AND aao04=tm.mm
   #               END IF
   #               IF STATUS=100 OR m_aao IS NULL THEN
   #                  LET m_aao=0
   #               END IF
   #               SELECT SUM(fbn07) INTO y_curr FROM fbn_file
   #                WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
   #                  AND fbn03=tm.yy       AND fbn04<tm.mm
   #                  AND fbn06=g_fae.fae06 AND fbn05='3'

   #               IF cl_null(y_curr) THEN
   #                  LET y_curr = 0
   #               END IF
   #               LET m_ratio = m_aao/m_tot*100
   #               IF m_ratio > m_max_ratio THEN
   #                  LET m_max_fae06 = g_fae.fae06
   #                  LET m_max_ratio = m_ratio
   #               END IF
   #               LET m_fbn07=g_fbn.fbn07*m_ratio/100
   #               LET m_curr = y_curr + m_fbn07
   #               LET m_fbn14=g_fbn.fbn14*m_ratio/100
   #               LET m_fbn15=g_fbn.fbn15*m_ratio/100
   #               LET m_fbn17=g_fbn.fbn17*m_ratio/100
   #               LET m_fbn07 = cl_digcut(m_fbn07,g_azi04)
   #               LET m_curr = cl_digcut(m_curr,g_azi04)
   #               LET m_fbn14 = cl_digcut(m_fbn14,g_azi04)
   #               LET m_fbn15 = cl_digcut(m_fbn15,g_azi04)
   #               LET m_fbn17 = cl_digcut(m_fbn17,g_azi04)
   #               LET m_tot_fbn07=m_tot_fbn07+m_fbn07
   #               LET m_tot_curr =m_tot_curr +m_curr
   #               LET m_tot_fbn14=m_tot_fbn14+m_fbn14
   #               LET m_tot_fbn15=m_tot_fbn15+m_fbn15
   #               LET m_tot_fbn17=m_tot_fbn17+m_fbn17
   #               SELECT COUNT(*) INTO g_cnt FROM fbn_file
   #                WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
   #                  AND fbn03=g_fbn.fbn03 AND fbn04=g_fbn.fbn04
   #                  AND fbn06=g_fae.fae06 AND fbn05='3' AND fbn041='0'
   #               IF g_cnt>0 THEN
   #                  UPDATE fbn_file SET fbn07 = m_fbn07,
   #                                      fbn08 = m_curr,
   #                                      fbn09 = g_fbn.fbn06,
   #                                      fbn16 = m_ratio,
   #                                      fbn17 = m_fbn17,
   #                                      fbn11 =m_fad031,
   #                                      fbn12 =g_fae.fae07
   #                   WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
   #                     AND fbn03=g_fbn.fbn03 AND fbn04=g_fbn.fbn04
   #                     AND fbn06=g_fae.fae06 AND fbn05='3' AND fbn041='0'
   #                  IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
   #                     LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
   #                     LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
   #                     LET g_show_msg[g_cnt2].ze01   = ''
   #                     LET g_show_msg[g_cnt2].ze03   = 'upd fbn_file'
   #                     LET g_cnt2 = g_cnt2 + 1
   #                     LET g_success='N'
   #                     CONTINUE FOREACH
   #                  END IF
   #               ELSE
   #                  IF cl_null(g_fae.fae06) THEN
   #                     LET g_fae.fae06=' '
   #                  END IF
   #                  INSERT INTO fbn_file(fbn01,fbn02,fbn03,fbn04,fbn041,fbn05,
   #                                       fbn06,fbn07,fbn08,fbn09,fbn10,fbn11,
   #                                       fbn12,fbn13,fbn14,fbn15,fbn16,fbn17)
   #                                VALUES(g_fbn.fbn01,g_fbn.fbn02,g_fbn.fbn03,       
   #                                       g_fbn.fbn04,'0','3',g_fae.fae06,m_fbn07,   
   #                                       m_curr,g_fan.fan06,l_faj.faj43,g_fbn.fbn11,       
   #                                       g_fae.fae07,g_fbn.fbn13,m_fbn14,m_fbn15,   
   #                                       m_ratio,m_fbn17)
   #                  IF STATUS THEN
   #                     LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
   #                     LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
   #                     LET g_show_msg[g_cnt2].ze01   = ''
   #                     LET g_show_msg[g_cnt2].ze03   = 'ins fbn_file'
   #                     LET g_cnt2 = g_cnt2 + 1
   #                     LET g_success='N'
   #                     CONTINUE FOREACH
   #                  END IF
   #               END IF
   #            END FOREACH
   #            IF cl_null(m_max_fae06) THEN LET m_max_fae06=g_fae.fae06 END IF
   #         END IF
   #         IF m_fad05 = '2' THEN
   #            IF m_tot_fbn07!=mm_fbn07 OR m_tot_curr!=m_curr OR
   #               m_tot_fbn14!=mm_fbn14 OR m_tot_fbn15!=mm_fbn15 THEN
   #               LET m_fae06 = m_max_fae06
   #               SELECT fbn07,fbn08 INTO l_fbn07,l_fbn08 from fbn_file
   #                WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
   #                  AND fbn03=tm.yy AND fbn04=tm.mm AND fbn06=m_fae06
   #                  AND fbn05='3'
   #               LET l_diff = mm_fbn07 - m_tot_fbn07
   #               IF l_diff < 0 THEN
   #                  LET l_diff = l_diff * -1
   #                  IF l_fbn07 < l_diff THEN
   #                     LET l_diff = 0
   #                  ELSE
   #                     LET l_diff = l_diff * -1
   #                  END IF
   #               END IF
   #               IF cl_null(m_tot_curr) THEN
   #                  LET m_tot_curr=0
   #               END IF
   #               LET l_diff2 = mm_fbn08 - m_tot_curr
   #               IF l_diff2 < 0 THEN
   #                  LET l_diff2 = l_diff2 * -1
   #                  IF l_fbn08 < l_diff2 THEN
   #                     LET l_diff2 = 0
   #                  ELSE
   #                     LET l_diff2 = l_diff2 * -1
   #                  END IF
   #               END IF
   #               UPDATE fbn_file SET fbn07=fbn07+l_diff,
   #                                   fbn08=fbn08+l_diff2,
   #                                   fbn14=fbn14+mm_fbn14-m_tot_fbn14,
   #                                   fbn15=fbn15+mm_fbn15-m_tot_fbn15,
   #                                   fbn17=fbn17+mm_fbn17-m_tot_fbn17,
   #                                   fbn11= m_fad031,
   #                                   fbn12= g_fae.fae07
   #                WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
   #                  AND fbn03=tm.yy AND fbn04=tm.mm AND fbn06=m_fae06
   #                  AND fbn05='3'
   #               IF STATUS OR SQLCA.sqlerrd[3]=0  THEN
   #                  LET g_success='N'
   #                  CALL cl_err3("upd","fbn_file",g_fbn.fbn01,g_fbn.fbn02,STATUS,"","upd fbn",1)
   #                  EXIT FOREACH
   #               END IF
   #            END IF
   #            LET m_tot_fbn07=0
   #            LET m_tot_fbn14=0
   #            LET m_tot_fbn15=0
   #            LET m_tot_fbn17=0
   #            LET m_tot_curr =0
   #            LET m_tot=0
   #         END IF
   #      END FOREACH
   #   END IF
   #  #end MOD-B40085 add

   #END IF
   ##-----No:FUN-AB0088 END-----
   ##-----No:FUN-BB0093 Mark-----

  END FOREACH
END FUNCTION
