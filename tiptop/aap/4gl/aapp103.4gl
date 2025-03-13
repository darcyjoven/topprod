# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapp103.4gl
# Descriptions...: 帳款統計更新
# Date & Author..: 92/12/20 By Roger
# Modify.........: 97/04/16 By Danny (將apc_file改成npp_file,npq_file)
# Modify.........: 97/08/27 By Kitty 增加工廠別[apn08],帳別[apn09]    
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.MOD-5B0203 05/11/21 By Smapmin 二次ENTER就會有錯誤訊息，直接按確認就不會.
#　　　　　　　　　　　　　　　　　　　　　　　　　　系統別AP/LC都要抓進來.
# Modify.........: No.FUN-570112 06/02/23 By YITING 批次背景執行
# Modify.........: No.TQC-660054 06/06/12 By Smapmin 按放棄時應要可以離開程式
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680029 06/08/17 By Rayven 新增多帳套功能
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-710014 07/01/11 By hongmei 錯誤訊息匯整
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.FUN-980001 09/08/04 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/14 By Lilan 將程式段多餘的DISPLAY給MARK
# Modify.........: No:CHI-A70005 10/07/12 By Summer 增加aza63判斷使用s_azmm
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    yy,mm           LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    b_date,e_date   LIKE type_file.dat,     #No.FUN-690028 DATE
    g_change_lang   LIKE type_file.chr1,                 #是否有做語言切換 No.FUN-570112  #No.FUN-690028 VARCHAR(1)
    g_npp           RECORD
            	    nppsys	LIKE npp_file.nppsys,   #
            	    npp00	LIKE npp_file.npp00,   #
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
    		    npq23	LIKE npq_file.npq23,   #
    		    nppglno	LIKE npp_file.nppglno, #
    		    npq04	LIKE npq_file.npq04,   #
    		    npq24	LIKE npq_file.npq24,   #
    		    npq25	LIKE npq_file.npq25    #
    		    END RECORD
    DEFINE l_apa55  LIKE apa_file.apa55  #FUN-660117
    DEFINE g_wc,g_sql  	string  #No.FUN-580092 HCN
    DEFINE amt_d                LIKE type_file.num20_6 # No.FUN-690028 DEC(20,6)  #FUN-4B0079
    DEFINE amt_c                LIKE type_file.num20_6 # No.FUN-690028 DEC(20,6)  #FUN-4B0079
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690028 INTEGER


MAIN
   DEFINE l_flag        LIKE type_file.num5      #No.FUN-570112  #No.FUN-690028 SMALLINT
 
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET yy = ARG_VAL(1)                  #更新年度
   LET mm = ARG_VAL(2)                  #期間
   LET g_bgjob = ARG_VAL(3)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p103()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p103_process('0')  #No.FUN-680029 新增參數'0'
            #No.FUN-680029 --start--
            IF g_aza.aza63 = 'Y' THEN
               CALL p103_process('1')
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
              CLOSE WINDOW p103_w
              EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p103_process('0')  #No.FUN-680029 新增參數'0'
         #No.FUN-680029 --start--
         IF g_aza.aza63 = 'Y' THEN
            CALL p103_process('1')
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
 
FUNCTION p103()
   DEFINE   lc_cmd    LIKE type_file.chr1000    # No.FUN-690028 VARCHAR(500)     #No.FUN-570112
 
WHILE TRUE
   LET g_action_choice = ""
 
   OPEN WINDOW p103_w WITH FORM "aap/42f/aapp103"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL cl_opmsg('z')
 
   LET yy = YEAR(g_today)
   LET mm = MONTH(g_today)
   LET g_bgjob = "N"
 
   CLEAR FORM
 
   INPUT BY NAME yy,mm,g_bgjob WITHOUT DEFAULTS
      AFTER FIELD yy
         IF cl_null(yy) THEN 
            NEXT FIELD yy 
         END IF
 
      AFTER FIELD mm
         IF cl_null(mm) THEN 
            NEXT FIELD mm
         END IF
      AFTER INPUT  #MOD-5B0203
         IF INT_FLAG THEN EXIT INPUT  END IF   #TQC-660054
         #CALL s_azm(yy,mm)  #CHI-A70005 mark
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
         SELECT COUNT(*) INTO g_cnt FROM apm_file
          WHERE apm04 = yy AND apm05 = mm
         IF g_cnt = 0 THEN
            CALL cl_err('','agl-022',1)
            NEXT FIELD yy
         END IF
 
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
 
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
 
#->No.FUN-570112 --start--
  #IF INT_FLAG THEN RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p103_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   # FUN-B20311
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "aapp103"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('aapp103','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",yy CLIPPED,"'",
                      " '",mm CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aapp103',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p103_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
#NO.FUN-570112 END---------
#NO.FUN-570112 MARK--------
#   IF INT_FLAG THEN RETURN END IF
#   IF cl_sure(18,20) THEN 
#      LET g_success = 'Y'
#      BEGIN WORK
#      CALL p103_process()
#      IF g_success = 'Y' THEN
#         COMMIT WORK
#         CALL cl_end2(1) RETURNING l_flag
#      ELSE
#         ROLLBACK WORK
#         CALL cl_end2(2) RETURNING l_flag
#      END IF
#      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#    END IF
#NO.FUN-570112 MARK--------
END WHILE
END FUNCTION
 
FUNCTION p103_process(l_npptype)  #No.FUN-680029 新增l_npptype
  DEFINE l_npptype LIKE npp_file.npptype  #No.FUN-680029
 
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
 
   LET g_sql ="SELECT nppsys,npp00,npp01,npp02,npp06,npp07,npq03,npq05,npq06,",
              "npq07,npq21,npq22,npq23,nppglno,npq04,npq24,npq25 ",
              "  FROM npp_file,npq_file ",
              " WHERE npp02 BETWEEN '",b_date,"' AND '",e_date,"'",
              "   AND npp02 IS NOT NULL",
              "   AND npp03 IS NOT NULL", #傳票日期不為空白
              "   AND nppglno IS NOT NULL", #傳票編號不為空白
              "   AND npp01 = npq01 ",
              "   AND npp00 = npq00 ",
            # "   AND nppsys = 'AP' ",
              "   AND (nppsys = 'AP' OR nppsys = 'LC') ",   #MOD-5B0203
              "   AND nppsys=npqsys",
              "   AND npp011=npq011",
              "   AND npptype = '",l_npptype,"'",  #No.FUN-680029
              " ORDER BY nppsys,npp00 "
   PREPARE p103_prepare FROM g_sql
   IF STATUS THEN
      CALL cl_err('p103_pre',STATUS,1)
      LET g_success = 'N'
      CALL cl_batch_bg_javamail("N")  #NO.FUN-570112
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE p103_cs CURSOR WITH HOLD FOR p103_prepare
   #No.FUN-680029 --start--
   IF g_aza.aza63 = 'Y' THEN
      IF l_npptype = '0' THEN
         UPDATE apn_file SET apn06 = 0, apn07 = 0 
          WHERE apn04 = yy AND apn05 = mm
            AND apn09 = g_apz.apz02b
      ELSE
         UPDATE apn_file SET apn06 = 0, apn07 = 0 
          WHERE apn04 = yy AND apn05 = mm
            AND apn09 = g_apz.apz02c
      END IF   
   ELSE
   #No.FUN-680029 --end--
      UPDATE apn_file SET apn06 = 0, apn07 = 0 
       WHERE apn04 = yy AND apn05 = mm
   END IF  #No.FUN-680029
 
   CALL s_showmsg_init()   #No.FUN-710014 
   FOREACH p103_cs INTO g_npp.*
      IF STATUS THEN
#No.FUN-710014  --Begin 
#        CALL cl_err('p103(ckp#1):',SQLCA.sqlcode,1)
#        LET g_success = 'N'
         CALL s_errmsg('','','p103(ckp#1):',SQLCA.sqlcode,1)                                                                        
         LET g_success = 'N'              #No.FUN-8A0086
         LET g_totsuccess='N'                                                                                                       
#No.FUN-710014  --End
         EXIT FOREACH
      END IF
      # 010116 By Star 判斷若為直接付款, 則不做餘額
      IF g_npp.npp00 = 2 AND g_npp.nppsys = 'AP' THEN 
         CONTINUE FOREACH
      END IF 
      IF g_npp.npp00 = 1 AND g_npp.nppsys = 'AP' THEN
         LET l_apa55 = ''
         SELECT apa55 INTO l_apa55 FROM apa_file WHERE apa01 = g_npp.npq23
         IF l_apa55 = '2' THEN 
            CONTINUE FOREACH
         END IF 
      END IF 
      # 020218 By Star 若為AR 沖AP 者, 會Insert 到付款沖帳, 則A/P 的分錄底稿
      # 須跳過
      IF g_npp.npp00 = 3 AND g_npp.nppsys = 'AP' THEN
         LET g_cnt = 0 
         SELECT COUNT(*) INTO g_cnt FROM ooa_file 
          WHERE ooa01 = g_npp.npp01 
         IF g_cnt > 0 THEN
            CONTINUE FOREACH
         END IF 
      END IF 
      IF g_npp.npq05 IS NULL THEN
         LET g_npp.npq05 = ' ' 
      END IF
      IF g_npp.npq21 IS NULL THEN
         LET g_npp.npq21 = ' ' 
      END IF
      IF g_npp.npq22 IS NULL THEN
         LET g_npp.npq22 = ' ' 
      END IF
      IF g_npp.npq23 IS NULL THEN 
         LET g_npp.npq23 = ' ' 
      END IF
      IF g_npp.npq03 IS NULL THEN 
         LET g_npp.npq03 = ' '
      END IF
      IF g_npp.npp06 IS NULL THEN 
         LET g_npp.npp06 = ' ' 
      END IF
      IF g_npp.npp07 IS NULL THEN 
         #No.FUN-680029 --start--
         IF g_aza.aza63 = 'Y' THEN
            IF l_npptype = '0' THEN
               LET g_npp.npp07 = g_apz.apz02b
            ELSE
               LET g_npp.npp07 = g_apz.apz02c
            END IF
         ELSE
         #No.FUN-680029 --end--
            LET g_npp.npp07 = ' ' 
         END IF  #No.FUN-680029
      END IF
     #DISPLAY "Update apn:",g_npp.npp02,' ',g_npp.npq03,' ',g_npp.npq21 AT 1,1  #CHI-9A0021
     #DISPLAY "" AT 2,1                                                         #CHI-9A0021
      IF g_npp.npq06 = '1' THEN
         LET amt_d = g_npp.npq07
         LET amt_c = 0
      ELSE
         LET amt_d = 0  
         LET amt_c = g_npp.npq07
      END IF
      UPDATE apn_file SET apn06=apn06+amt_d,
                          apn07=apn07+amt_c
                 WHERE apn00 = g_npp.npq03 
                   AND apn01 = g_npp.npq21
                   AND apn02 = g_npp.npq22
                 # AND apn03 = g_npp.npq05 #不以部門為key
                   AND apn04 = yy AND apn05 = mm
                   AND apn08 = g_npp.npp06
                   AND apn09 = g_npp.npp07
                   AND apn10 = g_npp.npq23
      IF STATUS THEN
#        CALL cl_err('p103(ckp#3):',SQLCA.sqlcode,1)    #No.FUN-660122
#No.FUN-710014  --Begin 
#        CALL cl_err3("upd","apn_file",g_npp.npq03,g_npp.npq21,SQLCA.sqlcode,"","p103(ckp#3)",1)   #No.FUN-660122
#        LET g_success = 'N'
#        EXIT FOREACH
         LET g_showmsg=g_npp.npq03,"/",g_npp.npq21,"/",                                                                             
                       g_npp.npq22,"/",g_npp.npq05,"/",                                                                             
                       yy,"/",mm,"/",g_npp.npp06,"/",                                                                               
                       g_npp.npp07,"/",g_npp.npq23                                                                          
         CALL s_errmsg("apn00,apn01,apn02,apn03,apn04,apn05,apn08,apn09,apn10,apn11",                                               
                       g_showmsg,"p103(ckp#3):",SQLCA.sqlcode,1)                                                                    
         LET g_totsuccess='N'                                                                                                       
         CONTINUE FOREACH                                                                                                           
#No.FUN-710014  --End                                     
      END IF
      IF SQLCA.SQLERRD[3] = 0 THEN
        #DISPLAY "Insert apn:" AT 2,1  #CHI-9A0021
         INSERT INTO apn_file(apn00,apn01,apn02,apn03,apn04,apn05,apn06,apn07,
                              apn08,apn09,apn10,apn11,apn12,apn13,apn14,apn15,
                              #apn16,apn17,apn18)
                              #apn16,apn17,apn18)  #FUN-980001 mark
                              apn16,apn17,apn18,apnlegal) #FUN-980001 add apnlegal
         VALUES(g_npp.npq03,g_npp.npq21,g_npp.npq22,g_npp.npq05,
                yy,mm,amt_d,amt_c,g_npp.npp06,g_npp.npp07,g_npp.npq23,
                g_npp.npp02,g_npp.nppglno,g_npp.npq04,g_npp.npq24,
                #g_npp.npq25,g_npp.npq22,'','') #FUN-980001 mark
                g_npp.npq25,g_npp.npq22,'','',g_legal) #FUN-980001 add g_legal
         IF STATUS THEN
#           CALL cl_err('p103(ckp#4):',SQLCA.sqlcode,1)    #No.FUN-660122
#No.FUN-710014  --Begin
#           CALL cl_err3("ins","apn_file",g_npp.npp06,g_npp.npp07,SQLCA.sqlcode,"","p103(ckp#4)",1)   #No.FUN-660122
#           LET g_success = 'N'
#           EXIT FOREACH
            LET g_showmsg=g_npp.npq03,"/",g_npp.npq21,"/",                                                                             
                       g_npp.npq22,"/",g_npp.npq05,"/",                                                                             
                       yy,"/",mm,"/",g_npp.npp06,"/",                                                                               
                       g_npp.npp07,"/",g_npp.npq23                                                                                  
         CALL s_errmsg("apn00,apn01,apn02,apn03,apn04,apn05,apn08,apn09,apn10,apn11",                                               
                       g_showmsg,"p103(ckp#4):",SQLCA.sqlcode,1)                                                                    
         LET g_totsuccess='N'                                                                                                       
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
