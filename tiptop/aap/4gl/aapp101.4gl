# Prog. Version..: '5.30.06-13.03.25(00010)'     #
#
# Pattern name...: aapp101.4gl
# Descriptions...: 帳款統計更新
# Date & Author..: 92/12/20 By Roger
# Modify.........: 97/04/16 By Danny (將apc_file改成npp_file,npq_file)
# Modify.........: 97/08/27 By Kitty 增加工廠別[apm08],帳別[apm09]    
#                  01-04-16 BY ANN CHEN No.B372
# Modify ........: No.A091 03/08/13 By Kammy 補充 No.A074 未修改到的部份
# Modify ........: No.9019 04/03/11 By Kitty UPDATE 的where條件加上apm11
# Modify ........: No.MOD-4B0085 04/11/10 By Kammy 改AFTER FIELD mm       
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify ........: No.MOD-4C0087 04/12/15 By DAY  組SQL出錯
# Modify.........: No.MOD-530682 05/05/03 By Smapmin CALL s_azm() 應加到AFTER INPUT
#                                         以防進入作業直接按確認執行後, 實際上未處理任何資料
# Modify.........: No.MOD-5B0201 05/11/21 By Smapmin 系統別AP/LC都要抓進來.
# Modify.........: No.FUN-570112 06/02/23 By yiting 批次背景執行
# Modify.........: No.TQC-640141 06/04/17 By Smapmin 增加"包含未拋傳票資料"的選項
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680029 06/08/17 By Rayven 新增多帳套功能
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-710014 07/01/10 By Carrier 錯誤訊息匯整
# Modify.........: No.TQC-780069 07/08/22 By Smapmin 修改變數定義型態
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.MOD-8A0243 08/10/29 By Sarah 預付費用待抵於成本分攤時沖銷,但統計更新時未寫入統計檔
# Modify.........: No.MOD-970020 09/07/09 By wujie   沒有列出應付衝應收的資料
# Modify.........: No.FUN-980001 09/08/04 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/14 By Lilan 將程式段多餘的DISPLAY給MARK
# Modify.........: No:CHI-A10007 10/03/26 By sabrina 對沖後分錄底稿所產生的資料有誤
# Modify.........: No:CHI-A70005 10/07/12 By Summer 增加aza63判斷使用s_azmm
# Modify.........: No:MOD-B30049 11/03/07 By Dido union 調整為 union all 
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
# Modify.........: No:TQC-C20347 12/02/21 By yinhy 因應付衝應收同時產生npqsys為AP及AR的分錄底稿，無需統計應收的，否則會DOUBLE
# Modify.........: No:MOD-CA0113 12/10/19 By Polly 針對LC傳票部份加以判斷，計算科目金額
# Modify.........: No:FUN-D40121 13/06/28 By lujh 若參數有值，则年度期別使用參數的值

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    yy,mm           LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    b_date,e_date   LIKE type_file.dat,     #No.FUN-690028 DATE
    k               LIKE type_file.chr1,    # No.FUN-690028 VARCHAR(1),   #TQC-640141
    l_flag          LIKE type_file.chr1,                  #No.FUN-570112  #No.FUN-690028 VARCHAR(1)
    g_change_lang   LIKE type_file.chr1,                 #是否有做語言切換 No.FUN-570112  #No.FUN-690028 VARCHAR(1)
    g_npp           RECORD
                    #add 030223  NO.A048
                    npp00       LIKE npp_file.npp00,
            	    npp01	LIKE npp_file.npp01,   #單號
    		    npp02	LIKE npp_file.npp02,   #異動日期
    		    npp06	LIKE npp_file.npp06,   #工廠別  
    		    npp07	LIKE npp_file.npp07,   #帳別    
    		    npq03	LIKE npq_file.npq03,   #科目
    		    npq05	LIKE npq_file.npq05,   #部門
    		    npq06	LIKE npq_file.npq06,   #借貸別
    		    npq07	LIKE npq_file.npq07,   #本幣金額
    		    npq21	LIKE npq_file.npq21,   #廠商編號
    		    npq22	LIKE npq_file.npq22,   #廠商簡稱
                    npq07f      LIKE npq_file.npq07f,  #原幣金額 No.A091 add
                    npq24       LIKE npq_file.npq24,   #幣別     No.A091 add
                    nppsys      LIKE npp_file.nppsys,  #CHI-A10007 add
                    npq23       LIKE npq_file.npq23,   #CHI-A10007 add
                    npp011      LIKE npp_file.npp011   #MOD-CA0113 add
    		    END RECORD
    DEFINE g_wc,g_sql  	string  #No.FUN-580092 HCN
    DEFINE amt_d                LIKE type_file.num20_6 # No.FUN-690028 DECIMAL(20,6)  #FUN-4B0079
    DEFINE amt_c                LIKE type_file.num20_6 # No.FUN-690028 DECIMAL(20,6)  #FUN-4B0079
    DEFINE g_cnt    LIKE type_file.num5    # No.FUN-690028 SMALLINT
    DEFINE amtf_d,amtf_c        LIKE type_file.num20_6    # No.FUN-690028 DECIMAL(20,6)  #No.A091 add #No.FUN-4B0079   #TQC-780069
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)

MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
#->No.FUN-570112 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET yy = ARG_VAL(1)                  #更新年度
   LET mm = ARG_VAL(2)                  #期間
   LET k  = ARG_VAL(3)    #TQC-640141
   LET g_bgjob = ARG_VAL(4)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570112 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p101()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p101_process('0')  #No.FUN-680029 新增參數'0'
            #No.FUN-680029 --start--
            IF g_aza.aza63 = 'Y' THEN
               CALL p101_process('1')
            END IF
            #No.FUN-680029 --end--
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p101_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p101_process('0')  #No.FUN-680029 新增參數'0'
         #No.FUN-680029 --start--
         IF g_aza.aza63 = 'Y' THEN
            CALL p101_process('1')
         END IF
         #No.FUN-680029 --end--
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p101()
   DEFINE   l_flag    LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE   lc_cmd    LIKE type_file.chr1000 # No.FUN-690028 VARCHAR(500)     #No.FUN-570112
 
#WHILE TRUE  #NO.FUN-570112 MARK
 
   LET g_action_choice = ""
 
#->No.FUN-570112 --start--
   OPEN WINDOW p101_w WITH FORM "aap/42f/aapp101"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL cl_opmsg('z')
#->No.FUN-570112 ---end---
 
   CLEAR FORM
#->No.FUN-570112 --start--
   IF cl_null(yy) OR yy = 0 THEN   #FUN-D40121 add
      LET yy = YEAR(g_today)
   END IF                          #FUN-D40121 add
   IF cl_null(mm) OR mm = 0 THEN   #FUN-D40121 add
      LET mm = MONTH(g_today)
   END IF                          #FUN-D40121 add
   LET k = 'N'   #TQC-640141
   LET g_bgjob = "N"
#->No.FUN-570112 ---end---
 
WHILE TRUE  #NO.FUN-570112
#   INPUT BY NAME yy,mm WITHOUT DEFAULTS   #NO.FUN-570112 MARK
   #INPUT BY NAME yy,mm,g_bgjob WITHOUT DEFAULTS   #TQC-640141
   INPUT BY NAME yy,mm,k,g_bgjob WITHOUT DEFAULTS   #TQC-640141
      AFTER FIELD yy
         IF cl_null(yy) THEN
            NEXT FIELD yy 
         END IF
 
      AFTER FIELD mm
         IF cl_null(mm) THEN 
            NEXT FIELD mm 
         END IF
         #CALL s_azm(yy,mm)              #CHI-A70005 mark
         #RETURNING g_chr,b_date,e_date  #CHI-A70005 mark
         #CHI-A70005 add --start--
         IF g_aza.aza63 = 'Y' THEN
            CALL s_azmm(yy,mm,g_apz.apz02p,g_apz.apz02b) RETURNING g_chr,b_date,e_date
         ELSE   
            CALL s_azm(yy,mm) RETURNING g_chr,b_date,e_date
         END IF
         #CHI-A70005 add --end--
         IF g_chr = 'N' THEN 
            NEXT FIELD mm 
         END IF
         DISPLAY BY NAME b_date,e_date 
         { No.MOD-4B0085 mark
         SELECT COUNT(*) INTO g_cnt FROM apm_file
          WHERE apm04 = yy AND apm05 = mm
         IF g_cnt = 0 THEN
            CALL cl_err('','agl-022',1)
            NEXT FIELD yy
         END IF
         } #No.MOD-4B0085 (end) mark
 
      #-----TQC-640141---------
      AFTER FIELD k 
         IF k NOT MATCHES'[YN]' THEN  
            NEXT FIELD k
         END IF
      #-----END TQC-640141-----
 
 #MOD-530682
      AFTER INPUT
         #CALL s_azm(yy,mm)  #CHI-Ak70005 mark
         #RETURNING g_chr,b_date,e_date #CHI-A70005 mark
         #CHI-A70005 add --start--
         IF g_aza.aza63 = 'Y' THEN
            CALL s_azmm(yy,mm,g_apz.apz02p,g_apz.apz02b) RETURNING g_chr,b_date,e_date
         ELSE   
            CALL s_azm(yy,mm) RETURNING g_chr,b_date,e_date
         END IF
         #CHI-A70005 add --end--
         IF g_chr = 'N' THEN
            NEXT FIELD mm
         END IF
         DISPLAY BY NAME b_date,e_date
 #END MOD-530682
 
      ON ACTION locale
        #->No.FUN-570112 --start--
        #LET g_action_choice='locale'
        #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE
        #->No.FUN-570112 ---end---
         EXIT INPUT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
  #->No.FUN-570112 --start--
  #IF g_action_choice = 'locale' THEN
   IF g_change_lang THEN
      LET g_change_lang = FALSE
  #->No.FUN-570112 ---end---
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
  #->No.FUN-570112 --start--
  #IF INT_FLAG THEN  RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p101_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #NO:FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "aapp101"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aapp101','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " ",yy CLIPPED,
                      " ",mm CLIPPED,
                      " ",k  CLIPPED,   #TQC-640141
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aapp101',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p101_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #NO:FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
#--NO.FUN-570112 MARK-------------
#   IF cl_sure(18,20) THEN 
#      LET g_success = 'Y'
#      BEGIN WORK
#      CALL p101_process()
#      IF g_success = 'Y' THEN
#         COMMIT WORK
#         CALL cl_end2(1) RETURNING l_flag
#      ELSE
#         ROLLBACK WORK
#         CALL cl_end2(2) RETURNING l_flag
#      END IF
#      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#   END IF
#--NO.FUN-570112 MARK----
END WHILE
END FUNCTION
 
FUNCTION p101_process(l_npptype)  #No.FUN-680029 新增l_npptype
   DEFINE   l_apa01   LIKE apa_file.apa01   #add 030223  NO.A048
   DEFINE   l_apa41   LIKE apa_file.apa41   #add 030223  No.A048
   DEFINE   l_npptype LIKE npp_file.npptype #No.FUN-680029
   DEFINE   l_oob06   LIKE oob_file.oob06     #CHI-A10007 add
 
  #No.FUN-680029 --start--
   IF g_aza.aza63 = 'Y' THEN
      IF l_npptype = '0' THEN
         CALL s_azmm(yy,mm,g_apz.apz02p,g_apz.apz02b)
              RETURNING g_chr,b_date,e_date
      ELSE
         CALL s_azmm(yy,mm,g_apz.apz02p,g_apz.apz02c)
              RETURNING g_chr,b_date,e_date
      END IF
   ELSE   
  #No.FUN-680029 --end--   
  #->No.FUN-570112 --start--
      CALL s_azm(yy,mm)
          RETURNING g_chr,b_date,e_date
  #->No.FUN-570112 ---end---
   END IF  #No.FUN-680029
 
 #modify 030223  NO.A048
 # LET g_sql ="SELECT npp01,npp02,npp06,npp07,npq03,npq05,npq06,",
   LET g_sql ="SELECT npp00,npp01,npp02,npp06,npp07,npq03,npq05,npq06,",
              "       npq07,npq21,npq22,",                                     #MOD-4C0087
              "       npq07f,npq24,nppsys,npq23,npp011 ",                      #No.A091 add#CHI-A10007 add nppsys,npq23 #MOD-CA0113 add npp011 
              "  FROM npp_file,npq_file ",
              " WHERE npp02 BETWEEN '",b_date,"' AND '",e_date,"'",
              "   AND npp02 IS NOT NULL",        #傳票日期不為空白
              #"   AND nppglno IS NOT NULL ",     #傳票編號不為空白    #TQC-640141
              "   AND npp01 = npq01 ",
              "   AND npp00 = npq00 ",
#              "   AND nppsys = 'AP' ",   #MOD-5B0201
              "   AND (nppsys = 'AP' OR nppsys = 'LC') ",   #MOD-5B0201
              "   AND nppsys=npqsys",
              "   AND npp011=npq011",
              "   AND npptype = '",l_npptype,"'"  #No.FUN-680029
   
   #-----TQC-640141---------
   IF k = 'N' THEN 
      LET g_sql = g_sql , " AND nppglno IS NOT NULL "
   END IF
   #-----END TQC-640141-----
#No.TQC-C20347  --Mark Begin
##No.MOD-970020 --begin                                                          
#     LET g_sql = g_sql,                                                         
#                 " UNION ALL ",        #MOD-B30049 mod union -> UNION ALL 
#                 "SELECT npp00,npp01,npp02,npp06,npp07,npq03,npq05,npq06,",     
#                 "  npq07,npq21,npq22,",      #MOD-4C0087                       
#                 "       npq07f,npq24,nppsys,npq23 ",      #No.A091 add    #CHI-A10007 add nppsys,npq23
#                 "  FROM npp_file,npq_file ",                                   
#                 " WHERE npp02 BETWEEN '",b_date,"' AND '",e_date,"'",          
#                 "   AND npp02 IS NOT NULL",        #傳票日期不為空白           
#                 "   AND npp01 = npq01 ",                                       
#                 "   AND npp00 = npq00 ",                                       
#                 "   AND (nppsys = 'AR' OR nppsys = 'LC') ",                    
#                 "   AND nppsys=npqsys",                                        
#                 "   AND npp011=npq011",                                        
#                 "   AND npptype = '",l_npptype,"'",                            
#                 "   AND npq23 in (select apg04 from apg_file)"                 
#   IF k = 'N' THEN                                                              
#      LET g_sql = g_sql , " AND nppglno IS NOT NULL "                           
#   END IF                                                                       
##No.MOD-970020 --end 
#No.TQC-C20347  --Mark End
   
   PREPARE p101_prepare FROM g_sql
   IF STATUS THEN 
      CALL cl_err('p101_pre',STATUS,1) 
      LET g_success = 'N'
      CALL cl_batch_bg_javamail("N")  #NO.FUN-570112
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #NO:FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE p101_cs CURSOR WITH HOLD FOR p101_prepare
   #No.B372 010426 by plum 刪除本月資料
   #No.FUN-680029 --start--
   IF g_aza.aza63 = 'Y' THEN
      IF l_npptype = '0' THEN
         DELETE FROM apm_file WHERE apm04 = yy AND apm05 = mm AND apm10 = '1'
                                AND apm09 = g_apz.apz02b
      ELSE
         DELETE FROM apm_file WHERE apm04 = yy AND apm05 = mm AND apm10 = '1'
                                AND apm09 = g_apz.apz02c
      END IF
   ELSE   
   #No.FUN-680029 --end--
      DELETE FROM apm_file WHERE apm04 = yy AND apm05 = mm AND apm10 = '1'
   END IF  #No.FUN-680029
   #No.B372..end
 
   CALL s_showmsg_init()   #No.FUN-710014
   FOREACH p101_cs INTO g_npp.*
      IF STATUS THEN
         #No.FUN-710014  --Begin
         #CALL cl_err('p101(ckp#1):',SQLCA.sqlcode,1)   
         #LET g_success = 'N'
         CALL s_errmsg('','','p101(ckp#1):',SQLCA.sqlcode,1)
         LET g_success = 'N'                  #No.FUN-8A0086
         LET g_totsuccess='N'
         EXIT FOREACH
         #No.FUN-710014  --End  
      END IF
     #add 030223 NO.A048
      IF g_npp.nppsys = 'AP' THEN                                                   #MOD-CA0113 add
         IF g_npp.npp00 != 5 THEN
            LET l_apa01 = ''
            LET l_apa41 = ''
            SELECT apa01,apa41 INTO l_apa01,l_apa41 FROM apa_file WHERE apa01 = g_npp.npp01
            IF STATUS = 100 THEN
               SELECT apf01,apf41 INTO l_apa01,l_apa41
                 FROM apf_file WHERE apf01 = g_npp.npp01 AND apf41 != 'X'
               IF STATUS THEN
                 #str MOD-8A0243 mod
                 #CONTINUE FOREACH
                  SELECT aqa01,aqaconf INTO l_apa01,l_apa41
                    FROM aqa_file WHERE aqa01 = g_npp.npp01 AND aqaconf != 'X'
                  IF STATUS THEN
                     CONTINUE FOREACH
                  ELSE
                     IF l_apa41 = 'N' THEN
                        CONTINUE FOREACH
                     END IF
                  END IF
                 #end MOD-8A0243 mod
               ELSE 
                  IF l_apa41 = 'N' THEN
                     CONTINUE FOREACH 
                  END IF
               END IF
            ELSE
               IF l_apa41 = 'N' THEN
                  CONTINUE FOREACH
               END IF
            END IF
         END IF
     #-------------------------------MOD-CA0113---------------------------(S)
      ELSE
         IF g_npp.nppsys = 'LC' THEN
            CASE
              WHEN (g_npp.npp011 = 1 AND g_npp.npp00 = 4)
                 SELECT alk01,alkfirm INTO l_apa01,l_apa41
                   FROM alk_file
                  WHERE alk01 = g_npp.npp01
                 IF STATUS THEN
                    CONTINUE FOREACH
                 ELSE
                    IF l_apa41 = 'N' THEN
                       CONTINUE FOREACH
                    END IF
                 END IF
              WHEN (g_npp.npp011 = 2 AND g_npp.npp00 = 4)
                 SELECT alh01,alhfirm INTO l_apa01,l_apa41
                   FROM alh_file
                  WHERE alh01 = g_npp.npp01
                 IF STATUS THEN
                    CONTINUE FOREACH
                 ELSE
                    IF l_apa41 = 'N' THEN
                       CONTINUE FOREACH
                    END IF
                 END IF
              WHEN (g_npp.npp011 = 0 AND g_npp.npp00 = 5)
                 SELECT ala01,ala78 INTO l_apa01,l_apa41
                   FROM ala_file
                  WHERE ala01 = g_npp.npp01
                 IF STATUS THEN
                    CONTINUE FOREACH
                 ELSE
                    IF l_apa41 = 'N' THEN
                       CONTINUE FOREACH
                    END IF
                 END IF
              WHEN (g_npp.npp011 = 0 AND g_npp.npp00 = 4)
                 SELECT ala01,alafirm INTO l_apa01,l_apa41
                   FROM ala_file
                  WHERE ala01 = g_npp.npp01
                 IF STATUS THEN
                    CONTINUE FOREACH
                 ELSE
                    IF l_apa41 = 'N' THEN
                       CONTINUE FOREACH
                    END IF
                 END IF
              WHEN (g_npp.npp00 = 6)
                 SELECT alc01,alcfirm INTO l_apa01,l_apa41
                   FROM alc_file
                  WHERE alc01 = g_npp.npp01
                    AND alc02 = g_npp.npp011
                 IF STATUS THEN
                    CONTINUE FOREACH
                 ELSE
                    IF l_apa41 = 'N' THEN
                       CONTINUE FOREACH
                    END IF
                 END IF
              WHEN (g_npp.npp00 = 7)
                 SELECT alc01,alc78 INTO l_apa01,l_apa41
                   FROM alc_file
                  WHERE alc01 = g_npp.npp01
                    AND alc02 = g_npp.npp011
                 IF STATUS THEN
                    CONTINUE FOREACH
                 ELSE
                    IF l_apa41 = 'N' THEN
                       CONTINUE FOREACH
                    END IF
                 END IF
              OTHERWISE
                       CONTINUE FOREACH
            END CASE
         END IF
      END IF
     #-------------------------------MOD-CA0113---------------------------(E)
     #CHI-A10007---modify---start---
      LET l_oob06 = ' '            
      IF g_npp.npp00 = '3' AND g_npp.nppsys = 'AP' THEN
         SELECT oob06 INTO l_oob06 FROM oob_file 
          WHERE oob06 = g_npp.npq23
            AND oob01 = g_npp.npp01
            AND oob11 = g_npp.npq03
            AND ((oob03 = '1' AND oob04 = '3') OR (oob03 = '2' AND oob04 = '1')) 
          SELECT apa06,apa07 INTO g_npp.npq21,g_npp.npq22 FROM apa_file
           WHERE apa01 = l_oob06
      END IF
     #CHI-A10007---modify---end---
      IF g_npp.npq05 IS NULL THEN
         LET g_npp.npq05 = ' '
      END IF
      IF g_npp.npq21 IS NULL THEN
         LET g_npp.npq21 = ' ' 
      END IF
      IF g_npp.npq22 IS NULL THEN
         LET g_npp.npq22 = ' '
      END IF
      IF g_npp.npq03 IS NULL THEN
         LET g_npp.npq03 = ' ' 
      END IF
      IF g_npp.npq24 IS NULL THEN LET g_npp.npq24 = ' ' END IF #No.A091
##No.B372
      #IF g_npp.npp06 IS NULL THEN LET g_npp.npp06 = ' ' END IF
      #IF g_npp.npp07 IS NULL THEN LET g_npp.npp07 = ' ' END IF
      IF cl_null(g_npp.npp06) THEN
         LET g_npp.npp06=g_apz.apz02p
      END IF
      IF cl_null(g_npp.npp07) THEN
         #No.FUN-680029 --start--
         IF g_aza.aza63 = 'Y' THEN
            IF l_npptype = '0' THEN
               LET g_npp.npp07 = g_apz.apz02b
            ELSE
               LET g_npp.npp07 = g_apz.apz02c
            END IF
         ELSE
         #No.FUN-680029 --end--
            LET g_npp.npp07=g_apz.apz02b
         END IF  #No.FUN-680029
      END IF
##No.B372  END 
     #DISPLAY "Update apm:",g_npp.npp02,' ',g_npp.npq03,' ',g_npp.npq21 AT 1,1 #CHI-9A0021
     #DISPLAY "" AT 2,1                                                        #CHI-9A0021
      IF g_npp.npq06 = '1' THEN
         LET amt_d = g_npp.npq07 
         LET amt_c = 0
         LET amtf_d = g_npp.npq07f LET amtf_c = 0            #No.A091 add
      ELSE
         LET amt_d = 0  
         LET amt_c = g_npp.npq07
         LET amtf_d = 0            LET amtf_c = g_npp.npq07f #No.A091 add
      END IF
      UPDATE apm_file SET apm06 = apm06 + amt_d,
                          apm07 = apm07 + amt_c,
                          apm06f= apm06f+ amtf_d, #No.A091 add
                          apm07f= apm07f+ amtf_c  #No.A091 add
                 WHERE apm00 = g_npp.npq03
                   AND apm01 = g_npp.npq21
                   AND apm02 = g_npp.npq22
                   AND apm03 = g_npp.npq05
                   AND apm04 = yy AND apm05 = mm
                   AND apm08 = g_npp.npp06
                   AND apm09 = g_npp.npp07
                   AND apm10 = '1'   #No.B372
                   AND apm11 = g_npp.npq24           #No:9019
      IF STATUS THEN
#        CALL cl_err('p101(ckp#3):',SQLCA.sqlcode,1)   #No.FUN-660122
         #No.FUN-710014  --Begin
         #CALL cl_err3("upd","apm_file",g_npp.npq03,g_npp.npq21,SQLCA.sqlcode,"","p101(ckp#3):",1) #No.FUN-660122
         #LET g_success = 'N'
         #EXIT FOREACH
         LET g_showmsg=g_npp.npq03,"/",g_npp.npq21,"/",
                       g_npp.npq22,"/",g_npp.npq05,"/",
                       yy,"/",mm,"/",g_npp.npp06,"/",
                       g_npp.npp07,"/","1","/",g_npp.npq24
         CALL s_errmsg("apm00,apm01,apm02,apm03,apm04,apm05,apm08,apm09,apm10,apm11",
                       g_showmsg,"p101(ckp#3):",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
         CONTINUE FOREACH
         #No.FUN-710014  --End  
      END IF
      IF SQLCA.SQLERRD[3] = 0 THEN
        #DISPLAY "Insert apm:" AT 2,1  #CHI-9A0021
        ##No.B372  010426 by plum
        #INSERT INTO apm_file(apm00,apm01,apm02,apm03,apm04,apm05,apm06,apm07,apm08,apm09)
        #FUN-980001 mark --(S)
        # INSERT INTO apm_file(apm00,apm01,apm02,apm03,apm04,apm05,
        #                     apm06,apm07,apm06f,apm07f,       #No.A091 add
        #                     apm08,apm09,apm10, apm11 )       #No.A091 add
        #      VALUES(g_npp.npq03,g_npp.npq21,g_npp.npq22,g_npp.npq05,yy,mm,
        #             amt_d,amt_c,amtf_d,amtf_c,               #No.A091 add
        #             g_npp.npp06,g_npp.npp07,'1',g_npp.npq24) #No.A091 add
        #FUN-980001 mark --(E)
        #FUN-980001 add --(S)
         INSERT INTO apm_file(apm00,apm01,apm02,apm03,apm04,apm05,
                             apm06,apm07,apm06f,apm07f,  
                             apm08,apm09,apm10, apm11,apmlegal ) 
              VALUES(g_npp.npq03,g_npp.npq21,g_npp.npq22,g_npp.npq05,yy,mm,
                     amt_d,amt_c,amtf_d,amtf_c,          
                     g_npp.npp06,g_npp.npp07,'1',g_npp.npq24,g_legal)
        #FUN-980001 add --(E)
         IF STATUS THEN
#           CALL cl_err('p101(ckp#4):',SQLCA.sqlcode,1)   #No.FUN-660122
            #No.FUN-710014  --Begin
            #CALL cl_err3("ins","apm_file",g_npp.npq03,g_npp.npq21,SQLCA.sqlcode,"","p101(ckp#4):",1) #No.FUN-660122
            #LET g_success = 'N'
            #EXIT FOREACH
            LET g_showmsg=g_npp.npq03,"/",g_npp.npq21,"/",
                          g_npp.npq22,"/",g_npp.npq05,"/",
                          yy,"/",mm,"/",g_npp.npp06,"/",
                          g_npp.npp07,"/","1","/",g_npp.npq24
            CALL s_errmsg("apm00,apm01,apm02,apm03,apm04,apm05,apm08,apm09,apm10,apm11",
                          g_showmsg,"p101(ckp#4):",SQLCA.sqlcode,1)
            LET g_totsuccess = 'N'
            CONTINUE FOREACH
            #No.FUN-710014  --End  
         END IF
      END IF
   END FOREACH
 
   #No.FUN-710014  --Begin
   IF g_totsuccess="N" THEN 
      LET g_success="N"
   END IF
 
   CALL s_showmsg()
   #No.FUN-710014  --End  
 
END FUNCTION
