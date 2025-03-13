# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglp130.4gl
# Descriptions...: 子系統統計更新作業
# Date & Author..:  NO.FUN-5C0015 05/12/19 By TSD.kevin
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-710023 07/01/18 By yjkhero 錯誤訊息匯整
# Modify.........: No.MOD-720061 07/02/08 By Smapmin 若axrt400沖A/P產生至aapt330後再由aapt330產生分錄的話,
#                                                    在此檢核僅需產生一筆即可,第二筆分錄則無須再重複產生
# Modify.........: No.FUN-740020 07/04/13 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.MOD-760055 07/06/13 By Smapmin 修改字串截取長度
# Modify.........: No.CHI-860007 08/07/22 By Sarah 1.將帳別bookno欄位拿掉
#                                                  2.若npp07為空時,當npptype='0'時npp07=aza81,當npptype='1'時npp07=aza82
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/16 By Lilan 將程式段多餘的DISPLAY給MARK
# Modify.........: No:CHI-9A0027 09/10/29 By mike 年度期别之初值应调整为 CALL s_yp(g_today) RETURNING yy,mm                         
# Modify.........: No:CHI-9B0035 09/11/27 By Sarah 當執行期別為當年最後一期時,詢問是否做年結
# Modify.........: No:FUN-A30110 10/04/12 By Carrier 客户/厂商简称修改
# Modify.........: No.FUN-A60056 10/07/08 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.FUN-A70139 10/07/29 By lutingting 修正FUN-A60056 内容
# Modify.........: No:MOD-A80187 10/08/25 By Dido 定存解除質押條件調整 
# Modify.........: No:MOD-A10145 10/09/28 By sabrina 當g_npp.npp06為null時，將g_plant給值
# Modify.........: No:MOD-C20066 12/02/08 By Polly 增加判斷aza125/aza126='Y'時，才做廠商/客戶簡稱調整
# Modify.........: No:MOD-C50213 12/05/29 By Polly 若為固質財簽二時，npp07改抓財簽二帳別(faa02c)
# Modify.........: No:MOD-C70021 12/07/03 By Carrier 隐藏画面“是否包含未抛转凭证资料”，处理逻辑时，此勾选项为’Y’
# Modify.........: No:MOD-C70027 12/07/03 By Elise g_sql少串npptype=npqtype造成子系統計算時會double
# Modify.........: No:TQC-C90032 12/09/06 By lujh 錯誤訊息 TSD0003 非標準命名規則,改為 agl-188
# Modify.........: No:CHI-D10048 13/01/30 By apo 執行時前先將對應的npr_file的資料清空
# Modify.........: No:TQC-D70023 13/07/05 By lujh 增加傳參

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
#DEFINE bookno           LIKE aaa_file.aaa01,   #No.FUN-740020   #CHI-860007 mark
DEFINE yy                LIKE npr_file.npr04,   #No.FUN-680098 SMALLINT 
       mm                LIKE npr_file.npr05,   #No.FUN-680098 SMALLINT
       b_date,e_date     LIKE type_file.dat,    #No.FUN-680098 DATE
       yn                LIKE type_file.chr1,   #No.FUN-680098 VARCHAR(1) 
       g_npp             RECORD
                          nppsys      LIKE npp_file.nppsys,  #系統別
                          npptype     LIKE npp_file.npptype, #分錄底稿類別   #CHI-860007 add
                          npp00       LIKE npp_file.npp00,   #類別
            	          npp01       LIKE npp_file.npp01,   #單號
            	          npp011      LIKE npp_file.npp011,  #異動序號
    		          npp02       LIKE npp_file.npp02,   #異動日期
    		          npp06       LIKE npp_file.npp06,   #工廠別  
    		          npp07       LIKE npp_file.npp07,   #帳別    
    		          npq03       LIKE npq_file.npq03,   #科目
    		          npq05       LIKE npq_file.npq05,   #部門
    		          npq06       LIKE npq_file.npq06,   #借貸別
    		          npq07       LIKE npq_file.npq07,   #本幣金額
    		          npq21       LIKE npq_file.npq21,   #廠商編號
    		          npq22       LIKE npq_file.npq22,   #廠商簡稱
                          npq07f      LIKE npq_file.npq07f,  #原幣金額
                          npq24       LIKE npq_file.npq24    #幣別     
    		         END RECORD
DEFINE g_wc,g_sql        STRING
DEFINE amt_d             LIKE type_file.num20_6       #No.FUN-680098 DEC(20,6)
DEFINE amt_c             LIKE type_file.num20_6       #No.FUN-680098 DEC(20,6)
DEFINE p_row,p_col,g_cnt LIKE type_file.num5          #No.FUN-680098 SMALLINT
DEFINE amtf_d,amtf_c     LIKE type_file.num20_6       #No.FUN-680098 DEC(20,6)
DEFINE g_chr             LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
DEFINE g_bookno1     LIKE aza_file.aza81       #CHI-A70007 add
DEFINE g_bookno2     LIKE aza_file.aza82       #CHI-A70007 add
DEFINE g_flag        LIKE type_file.chr1       #CHI-A70007 add
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8  	    #No.FUN-6A0073
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   LET yy=ARG_VAL(1)    #TQC-D70023 add
   LET mm=ARG_VAL(2)    #TQC-D70023 add
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   OPEN WINDOW p130_w AT p_row,p_col WITH FORM "agl/42f/aglp130"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
  #LET yy = YEAR(g_today)  #CHI-9A0027  
  #LET mm = MONTH(g_today) #CHI-9A0027                                                                                              
   IF cl_null(yy) OR cl_null(mm) THEN   #TQC-D70023 add
      CALL s_yp(g_today) RETURNING yy,mm #CHI-9A0027   
   END IF     #TQC-D70023 add 
   #No.MOD-C70021  --Begin
   #LET yn = 'N'
   LET yn = 'Y'
   CALL cl_set_comp_visible('yn',FALSE)
   #No.MOD-C70021  --End  
   CALL p130()
 
   CLOSE WINDOW p130_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION p130()
   DEFINE l_flag  LIKE type_file.num5      #No.FUN-680098  SMALLINT
   DEFINE l_cmd   LIKE type_file.chr1000   #CHI-9B0035 add
 
   WHILE TRUE
      LET g_action_choice = ""
 
      CLEAR FORM
     #LET bookno = g_aza.aza81  #No.FUN-740020   #CHI-860007 mark
     #DISPLAY BY NAME bookno    #No.FUN-740020   #CHI-860007 mark
     #INPUT BY NAME bookno,yy,mm,yn WITHOUT DEFAULTS   #No.FUN-740020  #CHI-860007 mark
      INPUT BY NAME yy,mm,yn WITHOUT DEFAULTS                          #CHI-860007
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        #str CHI-860007 mark
        ##No.FUN-740020  --Begin
        #AFTER FIELD bookno
        #   IF NOT cl_null(bookno) THEN
        #      CALL p130_bookno(bookno)
        #      IF NOT cl_null(g_errno) THEN
        #         CALL cl_err(bookno,g_errno,0)
        #         LET bookno = g_aza.aza81
        #         DISPLAY BY NAME bookno
        #         NEXT FIELD bookno
        #      END IF
        #   END IF
        ##No.FUN-740020  --End  
        #end CHI-860007 mark
 
         AFTER FIELD yy
            IF cl_null(yy) THEN
               NEXT FIELD yy 
            END IF
            IF yy <= 0 THEN 
               NEXT FIELD yy
            END IF
 
         AFTER FIELD mm
            IF cl_null(mm) THEN 
               NEXT FIELD mm 
            END IF
            IF mm <= 0 THEN
               NEXT FIELD mm 
            END IF
            SELECT COUNT(*) INTO g_cnt FROM npr_file
              WHERE npr04 = yy AND npr05 = mm AND npr10 = '0'
            IF g_cnt > 0 THEN
               CALL cl_err('','TSD0001',1)
               NEXT FIELD yy
            END IF
            #CALL s_azm(yy,mm) #CHI-A70007 mark
            #RETURNING g_chr,b_date,e_date  #CHI-A70007 mark
            #CHI-A70007 add --start--
            CALL s_get_bookno(yy) RETURNING g_flag,g_bookno1,g_bookno2
            IF g_aza.aza63 = 'Y' THEN
               CALL s_azmm(yy,mm,g_plant,g_bookno1) RETURNING g_chr,b_date,e_date
            ELSE
               CALL s_azm(yy,mm) RETURNING g_chr,b_date,e_date
            END IF
            #CHI-A70007 add --end--
            IF g_chr = '1' THEN 
               NEXT FIELD mm 
            END IF
            DISPLAY BY NAME b_date,e_date 
 
         AFTER INPUT
            IF INT_FLAG THEN   
               EXIT INPUT     
            END IF
            SELECT COUNT(*) INTO g_cnt FROM npr_file
                WHERE npr04 = yy AND npr05 = mm AND npr10 = '0'
            IF g_cnt > 0 THEN
               CALL cl_err('','TSD0001',1)
               NEXT FIELD yy
            END IF
            #CALL s_azm(yy,mm)  #CHI-A70007 mark
            #RETURNING g_chr,b_date,e_date #CHI-A70007 mark
            #CHI-A70007 add --start--
            CALL s_get_bookno(yy) RETURNING g_flag,g_bookno1,g_bookno2
            IF g_aza.aza63 = 'Y' THEN
               CALL s_azmm(yy,mm,g_plant,g_bookno1) RETURNING g_chr,b_date,e_date
            ELSE
               CALL s_azm(yy,mm) RETURNING g_chr,b_date,e_date
            END IF
            #CHI-A70007 add --end--
            IF g_chr = '1' THEN
               NEXT FIELD mm
            END IF
            DISPLAY BY NAME b_date,e_date
 
        #str CHI-860007 mark
        ##No.FUN-740020  --Begin
        #ON ACTION CONTROLP
        #   CASE
        #      WHEN INFIELD(bookno) 
        #         CALL cl_init_qry_var()
        #         LET g_qryparam.form ="q_aaa"
        #         LET g_qryparam.default1 = bookno
        #         CALL cl_create_qry() RETURNING bookno
        #         DISPLAY BY NAME bookno
        #         NEXT FIELD bookno
        #   END CASE
        ##No.FUN-740020  --End  
        #end CHI-860007 mark
 
         ON ACTION locale
            LET g_action_choice='locale'
            CALL cl_show_fld_cont()          
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
 
         ON ACTION about         
            CALL cl_about()     
 
         ON ACTION help        
            CALL cl_show_help()
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN 
         LET INT_FLAG = 0
         RETURN 
      END IF
      IF cl_sure(18,20) THEN 
         LET g_success = 'Y'
         BEGIN WORK
         CALL p130_process()
         CALL s_showmsg()      #NO.FUN-710023
        #str CHI-9B0035 add
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         IF ((g_aza.aza02='1' AND mm=12) OR (g_aza.aza02='2' AND mm=13)) THEN
            LET l_cmd = ''
            IF cl_confirm('axr-240') THEN
               LET l_cmd = " aglp131 '",g_aza.aza81,"' '",yy,"' 'Y' '",g_success,"' "
               CALL cl_cmdrun_wait(l_cmd)
            END IF
         END IF
        #end CHI-9B0035 add
         IF g_success = 'Y' THEN
           #COMMIT WORK    #CHI-9B0035 mark
            CALL cl_end2(1) RETURNING l_flag
         ELSE
           #ROLLBACK WORK  #CHI-9B0035 mark
            CALL cl_end2(2) RETURNING l_flag
         END IF
         IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
      END IF
   END WHILE
 
END FUNCTION
 
#str CHI-860007 mark
#No.FUN-740020  --Begin
#FUNCTION p130_bookno(p_bookno)
#   DEFINE p_bookno   LIKE aaa_file.aaa01,
#          l_aaaacti  LIKE aaa_file.aaaacti
# 
#   LET g_errno = ' '
#   SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_bookno
#   CASE
#       WHEN l_aaaacti = 'N' LET g_errno = '9028'
#       WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
#       OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
#   END CASE
#END FUNCTION
##No.FUN-740020  --End  
#end CHI-860007 mark
 
FUNCTION p130_process()
   DEFINE   l_apa01   LIKE apa_file.apa01  
   DEFINE   l_apa41   LIKE apa_file.apa41 
   DEFINE   max_gxg02 LIKE type_file.num10     #No.FUN-680098  INTEGER
   DEFINE   l_nnm01   LIKE nnm_file.nnm01      #No.FUN-680098  VARCHAR(10)
   DEFINE   l_nnm02   LIKE type_file.chr4      #No.FUN-680098  VARCHAR(4)
   DEFINE   l_nnm03   LIKE type_file.chr2      #No.FUN-680098  VARCHAR(2)
   DEFINE   l_count   LIKE type_file.num10     #No.FUN-680098  INTEGER
   DEFINE   l_npq30   LIKE npq_file.npq30      #FUN-A60056
   DEFINE   l_n       LIKE type_file.num5      #FU-A60056
   DEFINE   l_faa02c  LIKE faa_file.faa02c     #MOD-C50213 add

  #--------------------------MOD-C50213-----------(S)
   SELECT faa02c INTO l_faa02c FROM faa_file
    WHERE faa00 = '0'
  #--------------------------MOD-C50213-----------(E)
   LET g_sql ="SELECT nppsys,npptype,npp00,npp01,npp011,npp02,npp06,",   #CHI-860007 add npptype
              "  npp07,npq03,npq05,npq06,",
              "  npq07,npq21,npq22,",      
              "  npq07f,npq24 ",      
              " FROM npp_file,npq_file ",
              " WHERE npp02 BETWEEN '",b_date,"' AND '",e_date,"'",
             #"   AND npp07 = '",bookno,"'",   #No.FUN-740020   #CHI-860007 mark
              "   AND npp01 = npq01 ",
              "   AND npp00 = npq00 ",
              "   AND nppsys= npqsys",
              "   AND npp011= npq011",  #MOD-C70027 add ,
              "   AND npptype=npqtype"  #MOD-C70027 add
 
   # 是否包含未拋轉傳票資料
   IF yn = 'N' THEN 
      LET g_sql = g_sql,
              "   AND npp03 IS NOT NULL",        # 傳票日期不為空白
              "   AND nppglno IS NOT NULL "      # 傳票編號不為空白 
   END IF
 
   PREPARE p130_prepare FROM g_sql
   IF STATUS THEN 
      CALL cl_err('p130_pre',STATUS,1) 
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE p130_cs CURSOR WITH HOLD FOR p130_prepare
   #CHI-D10048--
   # 刪除本月資料
   DELETE FROM npr_file WHERE npr04 = yy AND npr05 = mm AND npr10 = '1'
   #CHI-D10048--
   # 如該期間無分錄底稿，則不做
   LET l_count = 0
   IF yn = 'N' THEN
      SELECT COUNT(*) INTO l_count FROM npp_file,npq_file 
       WHERE npp02 BETWEEN b_date AND e_date
         AND npp01 = npq01  AND npp00 = npq00
         AND nppsys= npqsys AND npp011= npq011
         AND npp03 IS NOT NULL 
         AND nppglno IS NOT NULL
         AND npptype=npqtype   #MOD-C70027 add
   ELSE
      SELECT COUNT(*) INTO l_count FROM npp_file,npq_file
       WHERE npp02 BETWEEN b_date AND e_date
         AND npp01 = npq01  AND npp00 = npq00
         AND nppsys= npqsys AND npp011= npq011 
         AND npptype=npqtype   #MOD-C70027 add
   END IF
   IF SQLCA.sqlcode OR l_count=0 THEN
      #CALL cl_err('','TSD0003',1)     #TQC-C90032  mark
      CALL cl_err('','agl-188',1)      #TQC-C90032  add
     #LET g_success = 'N'   #CHI-D10048 mark
      RETURN
   END IF
  #CHI-D10048 mark--
  ## 刪除本月資料
  #DELETE FROM npr_file WHERE npr04 = yy AND npr05 = mm AND npr10 = '1'
  #CHI-D10048 mark--
   
   # 確定執行後，將符合該年度期別區間內的 npp_file.npp04 更新為0  0
   # 符合資料更新後將 npp04 更新為  11
   UPDATE npp_file SET npp04='0' WHERE npp02 BETWEEN b_date AND e_date  
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('p130_up',STATUS,1)   #No.FUN-660123
      CALL cl_err3("upd","npp_file","","",STATUS,"","p130_up",1)   #No.FUN-660123
      LET g_success = 'N'
      RETURN
   END IF
   CALL s_showmsg_init()                #NO.FUN-710023
   FOREACH p130_cs INTO g_npp.*
      IF STATUS THEN
#        CALL cl_err('p130(ckp#1):',SQLCA.sqlcode,1)           #NO.FUN-710023
         CALL s_errmsg(' ',' ','p130(ckp#1):',SQLCA.sqlcode,1) #NO.FUN-710023
         LET g_success = 'N'
         EXIT FOREACH
      END IF
#NO.FUN-710023--BEGIN                                                           
      IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
      END IF                                                     
#NO.FUN-710023--END
      LET l_apa01 = NULL
      LET l_apa41 = NULL
      CASE 
         # AP
         WHEN g_npp.nppsys = 'AP' AND 
             (g_npp.npp00 = '1' OR g_npp.npp00 = '2')
            SELECT apa01,apa41 INTO l_apa01,l_apa41 FROM apa_file
              WHERE apa01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel apa:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("apa01","apa_file",g_npp.npp01,"",STATUS,"","sel apa:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('apa01',g_npp.npp01,'sel apa:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'AP' AND g_npp.npp00 = '3'
            #-----MOD-720061---------
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM ooa_file
             WHERE ooa01 = g_npp.npp01
            IF g_cnt > 0 THEN
               CONTINUE FOREACH
            END IF             
            #-----END MOD-720061-----
            SELECT apf01,apf41 INTO l_apa01,l_apa41 FROM apf_file
              WHERE apf01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel apf:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","apf_file",g_npp.npp01,"",STATUS,"","sel apf:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('apf01',g_npp.npp01,'sel apf:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'AP' AND g_npp.npp00 = '4'
            SELECT aqa01,aqaconf INTO l_apa01,l_apa41 FROM aqa_file
              WHERE aqa01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel aqa:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","aqa_file",g_npp.npp01,"",STATUS,"","sel aqa:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('aqa01',g_npp.npp01,'sel aqa:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         #WHEN g_npp.nppsys = 'AP' AND g_npp.npp00 = '5'
 
         # LC
         WHEN g_npp.nppsys = 'LC' AND g_npp.npp00 = '4' AND
              g_npp.npp011 = '0' 
            SELECT ala01,alafirm INTO l_apa01,l_apa41 FROM ala_file 
              WHERE ala01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel ala:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","ala_file",g_npp.npp01,"",STATUS,"","sel ala:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('ala01',g_npp.npp01,'sel ala:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'LC' AND g_npp.npp00 = '4' AND
              g_npp.npp011 = '1'
            SELECT alk01,alkfirm INTO l_apa01,l_apa41 FROM alk_file
              WHERE alk01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel alk:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","alk_file",g_npp.npp01,"",STATUS,"","sel alk:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('alk01',g_npp.npp01,'sel alk:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'LC' AND g_npp.npp00 = '4' AND
              g_npp.npp011 = '2'
            SELECT alh01,alhfirm INTO l_apa01,l_apa41 FROM alh_file
              WHERE alh01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel alk:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","alh_file",g_npp.npp01,"",STATUS,"","sel alk:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('alh01',g_npp.npp01,'sel alh:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'LC' AND g_npp.npp00 = '5' AND
              g_npp.npp011 = '0'
            SELECT ala01,ala78 INTO l_apa01,l_apa41 FROM ala_file
              WHERE ala01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel ala:',STATUS,0)    #No.FUN-660123
               CALL cl_err3("sel","ala_file",g_npp.npp01,"",STATUS,"","sel ala:",0)   #No.FUN-660123 #no.fun-710023
               CALL s_errmsg('ala01',g_npp.npp01,'sel ala:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'LC' AND 
             (g_npp.npp00 = '6' OR g_npp.npp00 = '7')
            SELECT alc01,alcfirm INTO l_apa01,l_apa41 FROM alc_file,ala_file
              WHERE alc01=g_npp.npp01 AND alc02=g_npp.npp011 AND alc01=ala01
            IF STATUS THEN
#              CALL cl_err('sel alc:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","alc_file,ala_file",g_npp.npp01,"",STATUS,"","sel alc:",0)   #No.FUN-660123 #NO.FUN-710023
               LET g_showmsg=g_npp.npp01,"/",g_npp.npp011                      #NO.FUN-710023 
               CALL s_errmsg('alc01,alc02',g_showmsg,'sel alc:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'LC' AND g_npp.npp00 = '9' AND
              g_npp.npp011 = '0'
            SELECT ala01,alaclos INTO l_apa01,l_apa41 FROM ala_file
              WHERE ala01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel ala:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","ala_file",g_npp.npp01,"",STATUS,"","sel ala:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('ala01',g_npp.npp01,'sel ala:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
 
         # AR 
         WHEN g_npp.nppsys = 'AR' AND g_npp.npp00 = '1'
#FUN-A60056--mod--str--
#           SELECT oga01,ogaconf INTO l_apa01,l_apa41 FROM oga_file
#             WHERE oga01=g_npp.npp01
            LET l_n = 0 
            LET g_sql = "SELECT UNIQUE npq30 FROM npq_file WHERE npq01 = '",g_npp.npp01,"'"   #FUN-A70139 add UNIQUE 
            PREPARE sel_npq30_pre FROM g_sql
            DECLARE sel_npq30_cur CURSOR FOR sel_npq30_pre 
            FOREACH sel_npq30_cur INTO l_npq30
               LET g_sql = "SELECT oga01,ogaconf FROM ",cl_get_target_table(l_npq30,'oga_file'),
                           " WHERE oga01='",g_npp.npp01,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,l_npq30) RETURNING g_sql
               PREPARE sel_oga01 FROM g_sql
               EXECUTE sel_oga01 INTO l_apa01,l_apa41 
#FUN-A60056--mod--end
               IF STATUS THEN
#                  CALL cl_err('sel oga:',STATUS,0)   #No.FUN-660123
#                  CALL cl_err3("sel","oga_file",g_npp.npp01,"",STATUS,"","sel oga:",0)   #No.FUN-660123 #NO.FUN-710023
                   CALL s_errmsg('oga01',g_npp.npp01,'sel oga:',STATUS,0)  #NO.FUN-710023
                   LET l_n = l_n+1    #FUN-A60056
                   EXIT FOREACH       #FUN-A60056
                  #CONTINUE FOREACH   #FUN-A60056
               END IF
           #FUN-A60056--add--str--
            END FOREACH   
            IF l_n>0 THEN
               CONTINUE FOREACH
            END IF 
           #FUN-A60056--add--end
         WHEN g_npp.nppsys = 'AR' AND g_npp.npp00 = '2'
            SELECT oma01,omaconf INTO l_apa01,l_apa41 FROM oma_file
              WHERE oma01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel oma:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","oma_file",g_npp.npp01,"",STATUS,"","sel oma:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('oma01',g_npp.npp01,'sel oma:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'AR' AND g_npp.npp00 = '3'
            SELECT ooa01,ooaconf INTO l_apa01,l_apa41 FROM ooa_file
              WHERE ooa01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel ooa:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","ooa_file",g_npp.npp01,"",STATUS,"","sel ooa:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('ooa01',g_npp.npp01,'sel ooa:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         #WHEN g_npp.nppsys = 'AR' AND g_npp.npp00 = '4'
         WHEN g_npp.nppsys = 'AR' AND g_npp.npp00 = '41'
            SELECT ola01,olaconf INTO l_apa01,l_apa41 FROM ola_file
              WHERE ola01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel ola:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","ola_file",g_npp.npp01,"",STATUS,"","sel ola:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('ola01',g_npp.npp01,'sel ola:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'AR' AND g_npp.npp00 = '42'
            SELECT ole01,oleconf INTO l_apa01,l_apa41 FROM ole_file
              WHERE ole01=g_npp.npp01 AND ole02 = g_npp.npp011
            IF STATUS THEN
#              CALL cl_err('sel ole:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","ole_file",g_npp.npp01,g_npp.npp011,STATUS,"","sel ole:",0)   #No.FUN-6601233 #NO.FUN-710023
               LET g_showmsg=g_npp.npp01,"/",g_npp.npp011                  #NO.FUN-710023          
               CALL s_errmsg('ole01,ole02',g_showmsg,'sel ole:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'AR' AND g_npp.npp00 = '43'
            SELECT olc29,olcconf INTO l_apa01,l_apa41 FROM olc_file
              WHERE olc29=g_npp.npp01 AND olc28=g_npp.npp011
            IF STATUS THEN
#              CALL cl_err('sel olc:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","olc_file",g_npp.npp01,g_npp.npp011,STATUS,"","sel olc:",0)   #No.FUN-660123 #NO.FUN-710023
               LET g_showmsg=g_npp.npp01,"/",g_npp.npp011                  #NO.FUN-710023          
               CALL s_errmsg('olc29,olc28',g_showmsg,'sel olc:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
 
         # FA 
         #WHEN g_npp.nppsys = 'FA' AND g_npp.npp00 = 'X'
         #WHEN g_npp.nppsys = 'FA' AND g_npp.npp00 = '0'
         WHEN g_npp.nppsys = 'FA' AND g_npp.npp00 = '1'
            SELECT faq01,faqconf INTO l_apa01,l_apa41 FROM faq_file
              WHERE faq01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel faq:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","faq_file",g_npp.npp01,"",STATUS,"","sel faq:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('faq01',g_npp.npp01,'sel faq:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'FA' AND g_npp.npp00 = '2'
            SELECT fas01,fasconf INTO l_apa01,l_apa41 FROM fas_file
              WHERE fas01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel fas:',STATUS,0)   #No.FUN-660123
#              CALL cl_err3("sel","fas_file",g_npp.npp01,"",STATUS,"","sel fas:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('fas01',g_npp.npp01,'sel fas:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'FA' AND g_npp.npp00 = '4'
            SELECT fbe01,fbeconf INTO l_apa01,l_apa41 FROM fbe_file
              WHERE fbe01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel fbe:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","fbe_file",g_npp.npp01,"",STATUS,"","sel fbe:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('fbe01',g_npp.npp01,'sel fbe:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'FA' AND 
             (g_npp.npp00 = '5' OR g_npp.npp00 = '6')
            SELECT fbg01,fbgconf INTO l_apa01,l_apa41 FROM fbg_file
              WHERE fbg01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel fbg:',STATUS,1)    #No.FUN-660123
#              CALL cl_err3("sel","fbg_file",g_npp.npp01,"",STATUS,"","sel fbg:",1)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('fbga01',g_npp.npp01,'sel fbg:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'FA' AND g_npp.npp00 = '7'
            SELECT fay01,fayconf INTO l_apa01,l_apa41 FROM fay_file
              WHERE fay01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel fay:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","fay_file",g_npp.npp01,"",STATUS,"","sel fay:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('fay01',g_npp.npp01,'sel fay:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'FA' AND g_npp.npp00 = '8'
            SELECT fba01,fbaconf INTO l_apa01,l_apa41 FROM fba_file
              WHERE fba01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel fba:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","fba_file",g_npp.npp01,"",STATUS,"","sel fba:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('fba01',g_npp.npp01,'sel fba:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'FA' AND g_npp.npp00 = '9'
            SELECT fbc01,fbcconf INTO l_apa01,l_apa41 FROM fbc_file
              WHERE fbc01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel fbc:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","fbc_file",g_npp.npp01,"",STATUS,"","sel fbc:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('fbc01',g_npp.npp01,'sel fbc:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         #WHEN g_npp.nppsys = 'FA' AND g_npp.npp00 = '10'
         #WHEN g_npp.nppsys = 'FA' AND g_npp.npp00 = '11'
         #WHEN g_npp.nppsys = 'FA' AND g_npp.npp00 = '12'
         WHEN g_npp.nppsys = 'FA' AND g_npp.npp00 = '13'
            SELECT fbs01,fbsconf INTO l_apa01,l_apa41 FROM fbs_file
              WHERE fbs01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel fbs:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","fbs_file",g_npp.npp01,"",STATUS,"","sel fbs:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('fbs01',g_npp.npp01,'sel fbs:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
 
         # NM
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '1'
            SELECT npl01,nplconf INTO l_apa01,l_apa41 FROM npl_file
              WHERE npl01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel npl:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","npl_file",g_npp.npp01,"",STATUS,"","sel npl:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('npl01',g_npp.npp01,'sel npl:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '2'
          AND g_npp.npp011 = '1'
            SELECT nmh01,nmh38 INTO l_apa01,l_apa41 FROM nmh_file
              WHERE nmh01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel nmh:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","nmh_file",g_npp.npp01,"",STATUS,"","sel nmh:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('nmh01',g_npp.npp01,'sel nmh:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '2'
          AND g_npp.npp011 != '1'
            SELECT npn01,npnconf INTO l_apa01,l_apa41 FROM npn_file
              WHERE npn01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel npn:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","npn_file",g_npp.npp01,"",STATUS,"","sel npn:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('npn01',g_npp.npp01,'sel npn:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '3'
          AND g_npp.npp011 = '1'
            SELECT nmg00,nmgconf INTO l_apa01,l_apa41 FROM nmg_file
              WHERE nmg00=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel nmg:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","nmg_file",g_npp.npp01,"",STATUS,"","sel nmg:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('nmg00',g_npp.npp01,'sel nmg:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '6'
            SELECT nni01,nniconf INTO l_apa01,l_apa41 FROM nni_file
              WHERE nni01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel nni:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","nni_file",g_npp.npp01,"",STATUS,"","sel nni:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('nni01',g_npp.npp01,'sel nni:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '7'
            SELECT nnk01,nnkconf INTO l_apa01,l_apa41 FROM nnk_file
              WHERE nnk01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel nnk:',STATUS,0)   #No.FUN-660123
#              CALL cl_err3("sel","nnk_file",g_npp.npp01,"",STATUS,"","sel nnk:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('npk01',g_npp.npp01,'sel npk:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH 
            END IF
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '16'
            SELECT nne01,nneconf INTO l_apa01,l_apa41 FROM nne_file
              WHERE nne01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel nne:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","nne_file",g_npp.npp01,"",STATUS,"","sel nne:",0)   #No.FUN-6601233 #NO.FUN-710023
               CALL s_errmsg('nne01',g_npp.npp01,'sel nne01:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH  
            END IF
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '17'
            SELECT nng01,nngconf INTO l_apa01,l_apa41 FROM nng_file
              WHERE nng01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel nng:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","nng_file",g_npp.npp01,"",STATUS,"","sel nng:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('nng01',g_npp.npp01,'sel nng:',STATUS,0)  #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '18'
            #-----MOD-760055---------
            #LET l_nnm01=g_npp.npp01[1,10]
            #LET l_nnm02=g_npp.npp01[11,14]
            #LET l_nnm03=g_npp.npp01[15,16]
            LET l_nnm01=g_npp.npp01[1,g_no_ep]
            LET l_nnm02=g_npp.npp01[g_no_ep+1,g_no_ep+4]
            LET l_nnm03=g_npp.npp01[g_no_ep+5,g_no_ep+6]
            #-----END MOD-760055-----
            SELECT nnm01,nnmconf INTO l_apa01,l_apa41 FROM nnm_file
              WHERE nnm01=l_nnm01 AND 
                    nnm02=l_nnm02 AND
                    nnm03=l_nnm03
            IF STATUS THEN
#              CALL cl_err('sel nnm:',STATUS,0)    #No.FUN-660123 
#              CALL cl_err3("sel","nnm_file",l_nnm01,l_nnm02,STATUS,"","sel nnm:",0)   #No.FUN-6601233 #NO.FUN-710023
               LET g_showmsg=l_nnm01,"/",l_nnm02,"/",l_nnm03                           #NO.FUN-710023
               CALL s_errmsg('nnm01,nnm02,nnm03',g_showmsg,'sel nnm:',STATUS,0)        #NO.FUN-710023  
               CONTINUE FOREACH
            END IF
         #WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '13'
         #WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '14'
         #WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '15'
        
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '4'
            SELECT MAX(gxg02) INTO max_gxg02 FROM gxg_file
              WHERE gxg011=g_npp.npp01 AND gxg09 IS NULL
            IF max_gxg02 != g_npp.npp011 THEN
               CONTINUE FOREACH
            END IF
            SELECT gxg011,gxgconf INTO l_apa01,l_apa41 FROM gxg_file
              WHERE gxg011=g_npp.npp01 AND gxg02=g_npp.npp011
                AND gxg09 IS NULL
            IF STATUS THEN
#              CALL cl_err('sel gxg:',STATUS,0)   #No.FUN-660123
#              CALL cl_err3("sel","gxg_file",g_npp.npp01 ,g_npp.npp011,STATUS,"","sel gxg:",0)   #No.FUN-660123 #NO.FUN-710023
               LET g_showmsg=g_npp.npp01,"/",g_npp.npp011                         #NO.FUN-710023
               CALL s_errmsg('gxg011,gxg02',g_showmsg,'sel gxg:',STATUS,0)        #NO.FUN-710023  
               CONTINUE FOREACH
            END IF
 
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '5'
            SELECT MAX(gxg02) INTO max_gxg02 FROM gxg_file
              WHERE gxg011=g_npp.npp01 AND gxg09 IS NOT NULL
            IF max_gxg02 != g_npp.npp011 THEN
               CONTINUE FOREACH
            END IF
            SELECT gxg011,gxgconf INTO l_apa01,l_apa41 FROM gxg_file
              WHERE gxg011=g_npp.npp01 AND gxg02=g_npp.npp011
               #AND gxg09 IS NULL                                                 #MOD-A80187 mark
                AND gxg09 IS NOT NULL                                             #MOD-A80187
            IF STATUS THEN
#              CALL cl_err('sel gxg:',STATUS,0)   #No.FUN-660123
#              CALL cl_err3("sel","gxg_file",g_npp.npp01,g_npp.npp011,STATUS,"","sel gxg:",0)   #No.FUN-660123 #NO.FUN-710023
               LET g_showmsg=g_npp.npp01,"/",g_npp.npp011                         #NO.FUN-710023
               CALL s_errmsg('gxg011,gxg02',g_showmsg,'sel gxg:',STATUS,0)        #NO.FUN-710023  
               CONTINUE FOREACH
            END IF
 
 
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '8'
            SELECT gxe01,gxe13 INTO l_apa01,l_apa41 FROM gxe_file
              WHERE gxe01=g_npp.npp01 AND gxe011=g_npp.npp011
            IF STATUS THEN
#              CALL cl_err('sel gxe:',STATUS,0)   #No.FUN-660123
#              CALL cl_err3("sel","gxe_file",g_npp.npp01,g_npp.npp011,STATUS,"","sel gxe:",0)   #No.FUN-660123 #NO.FUN-710023
               LET g_showmsg=g_npp.npp01,"/",g_npp.npp011                         #NO.FUN-710023
               CALL s_errmsg('gxe011,gxe02',g_showmsg,'sel gxe:',STATUS,0)        #NO.FUN-710023  
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '9'
            SELECT gxc01,gxc13 INTO l_apa01,l_apa41 FROM gxc_file
              WHERE gxc01=g_npp.npp01 
            IF STATUS THEN
#              CALL cl_err('sel gxc:',STATUS,0)    #No.FUN-660123
#              CALL cl_err3("sel","gxc_file",g_npp.npp01,"",STATUS,"","sel gxc:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('gxc01',g_npp.npp01,'sel gxc:',STATUS,0)        #NO.FUN-710023  
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '10'
            SELECT gxi01,gxiconf INTO l_apa01,l_apa41 FROM gxi_file
              WHERE gxi01=g_npp.npp01 
            IF STATUS THEN
#              CALL cl_err('sel gxi:',STATUS,0)   #No.FUN-660123
#              CALL cl_err3("sel","gxi_file",g_npp.npp01,"",STATUS,"","sel gxi:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('gxi01',g_npp.npp01,'sel gxi:',STATUS,0)        #NO.FUN-710023  
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '11'
            SELECT gxk01,gxkconf INTO l_apa01,l_apa41 FROM gxk_file
              WHERE gxk01=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel gxk:',STATUS,0)   #No.FUN-660123
               CALL cl_err3("sel","gxk_file",g_npp.npp01,"",STATUS,"","sel gxk:",0)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('gxk01',g_npp.npp01,'sel gxk:',STATUS,0)        #NO.FUN-710023  
               CONTINUE FOREACH
            END IF
         WHEN g_npp.nppsys = 'NM' AND g_npp.npp00 = '12'
            SELECT gxf01,gxfconf INTO l_apa01,l_apa41 FROM gxf_file
              WHERE gxf011=g_npp.npp01
            IF STATUS THEN
#              CALL cl_err('sel gxf:',STATUS,0)    #No.FUN-660123
               CALL cl_err3("sel","gxf_file",g_npp.npp01,"",STATUS,"","sel gxf:",0)   #No.FUN-660123
               CALL s_errmsg('gxf01',g_npp.npp01,'sel gxf:',STATUS,0)        #NO.FUN-710023   #NO.FUN-710023
               CONTINUE FOREACH
            END IF
         
         # PY
         #WHEN g_npp.nppsys = 'PY' AND g_npp.npp00 = '1'
         #WHEN g_npp.nppsys = 'PY' AND g_npp.npp00 = '2'
         #WHEN g_npp.nppsys = 'PY' AND g_npp.npp00 = '3'
 
         #OTHERWISE CONTINUE FOREACH
      END CASE
 
      IF l_apa41 != 'Y' THEN
         CONTINUE FOREACH
      END IF

      IF g_aza.aza125 = 'Y' AND g_aza.aza126 = 'Y' THEN                         #MOD-C20066 add
        #No.FUN-A30110  --Begin                                                   
         IF NOT cl_null(g_npp.npq21) THEN                                          
            IF g_npp.npq21 MATCHES 'MISC*' OR g_npp.npq21 MATCHES 'EMPL*' THEN     
            ELSE                                                                   
               IF g_npp.nppsys = 'AR' OR g_npp.nppsys = 'NM'   #应收               
                                     AND g_npp.npp00 = '2' THEN                    
                  SELECT occ02 INTO g_npp.npq22 FROM occ_file                      
                   WHERE occ01 = g_npp.npq21                                       
                  IF SQLCA.sqlcode = 100 THEN                                      
                     SELECT pmc03 INTO g_npp.npq22 FROM pmc_file                   
                      WHERE pmc01 = g_npp.npq21                                    
                  END IF                                                           
               ELSE                                            #应付               
                  SELECT pmc03 INTO g_npp.npq22 FROM pmc_file                      
                   WHERE pmc01 = g_npp.npq21                                       
                  IF SQLCA.sqlcode = 100 THEN                                      
                     SELECT occ02 INTO g_npp.npq22 FROM occ_file                   
                      WHERE occ01 = g_npp.npq21                                    
                  END IF                                                           
               END IF                                                              
            END IF                                                                 
         END IF                                                                    
        #No.FUN-A30110  --End
      END IF                                                                      #MOD-C20066 add
 
      IF cl_null(g_npp.npq05) THEN  #部門 
         LET g_npp.npq05 = ' '
      END IF
      IF cl_null(g_npp.npq21) THEN  #對象編號
         LET g_npp.npq21 = ' ' 
      END IF
      IF cl_null(g_npp.npq22) THEN  #對象簡稱
         LET g_npp.npq22 = ' '
      END IF
      IF cl_null(g_npp.npq03) THEN  #科目
         LET g_npp.npq03 = ' ' 
      END IF
      IF cl_null(g_npp.npq24) THEN  #原幣幣別
         LET g_npp.npq24 = ' '
      END IF
      IF cl_null(g_npp.npp06) THEN  #工廠編號
        #LET g_npp.npp06 = ' '                 #MOD-A10145 mark  
         LET g_npp.npp06 = g_plant             #MOD-A10145 add 
      END IF
      IF cl_null(g_npp.npp07) THEN  #帳別
         LET g_npp.npp07 = ' '
      END IF
     #str CHI-860007 add
     #若npp07為空時,當npptype='0'時npp07=aza81(主財務帳別),
     #              當npptype='1'時npp07=aza82(主管理帳別)
      IF g_npp.npp07=' ' THEN
         CASE g_npp.npptype
            WHEN '0'   
                 LET g_npp.npp07 = g_aza.aza81
           #-----------------------MOD-C50213-----------------(S)
           #WHEN '1'   LET g_npp.npp07 = g_aza.aza82    #MOD-C50213 mark
            WHEN '1'
                 IF g_npp.nppsys = 'FA' THEN
                    LET g_npp.npp07 = l_faa02c
                 ELSE
                    LET g_npp.npp07 = g_aza.aza82
                 END IF
           #-----------------------MOD-C50213-----------------(E)
         END CASE
      END IF
     #end CHI-860007 add
 
     #DISPLAY "Update npr:",g_npp.npp02,' ',g_npp.npq03,' ',g_npp.npq21 AT 1,1 #CHI-9A0021
     #DISPLAY "" AT 2,1                                                        #CHI-9A0021
      IF g_npp.npq06 = '1' THEN
         LET amt_d = g_npp.npq07 
         LET amt_c = 0
         LET amtf_d = g_npp.npq07f LET amtf_c = 0            
      ELSE
         LET amt_d = 0  
         LET amt_c = g_npp.npq07
         LET amtf_d = 0 
         LET amtf_c = g_npp.npq07f 
      END IF
      UPDATE npr_file SET npr06 = npr06 + amt_d,
                          npr07 = npr07 + amt_c,
                          npr06f= npr06f+ amtf_d, 
                          npr07f= npr07f+ amtf_c 
                 WHERE npr00 = g_npp.npq03
                   AND npr01 = g_npp.npq21
                   AND npr02 = g_npp.npq22
                   AND npr03 = g_npp.npq05
                   AND npr04 = yy AND npr05 = mm
                   AND npr08 = g_npp.npp06
                   AND npr09 = g_npp.npp07
                #  AND npr09 = bookno  #No.FUN-740020   #CHI-860007 mark
                   AND npr10 = '1'  
                   AND npr11 = g_npp.npq24     
      IF STATUS THEN
#        CALL cl_err('p130(ckp#3):',SQLCA.sqlcode,1)   #No.FUN-660123
#        CALL cl_err3("upd","npr_file",g_npp.npq03,g_npp.npq21,SQLCA.sqlcode,"","p130(ckp#3):",1)   #No.FUN-660123                   #NO.FUN-710023
         LET g_showmsg=g_npp.npq03,"/",g_npp.npq21,"/",g_npp.npq22,"/",g_npp.npq05,"/",yy,"/",mm,"/",g_npp.npq06,"/",g_npp.npq07,    #NO.FUN-710023
                       "/",'1',"/",g_npp.npq24                                                                                       #NO.FUN-710023
         CALL s_errmsg('npr00,npr01,npr02,npr03,npr04,npr08,npr09,npr10,npr11',g_showmsg,'p130(ckp#3):',SQLCA.sqlcode,1)             #NO.FUN-710023  
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF SQLCA.SQLERRD[3] = 0 THEN
        #DISPLAY "Insert npr:" AT 2,1  #CHI-9A0021
         INSERT INTO npr_file(npr00,npr01,npr02,npr03,npr04,npr05,
                             npr06,npr07,npr06f,npr07f,    
                             npr08,npr09,npr10, npr11,nprlegal )     #FUN-980003 add nprlegal
              VALUES(g_npp.npq03,g_npp.npq21,g_npp.npq22,g_npp.npq05,yy,mm,
                     amt_d,amt_c,amtf_d,amtf_c,              
                     g_npp.npp06,g_npp.npp07,'1',g_npp.npq24,g_legal)  #FUN-980003 add g_legal
         IF STATUS THEN
#           CALL cl_err('p130(ckp#4):',SQLCA.sqlcode,1)   #No.FUN-660123
#           CALL cl_err3("ins","npr_file",g_npp.npq03,g_npp.npq21,SQLCA.sqlcode,"","p130(ckp#4):",1)   #No.FUN-660123  #NO.FUN-710023
            LET g_showmsg=g_npp.npq03,"/",g_npp.npq21,"/",g_npp.npq22,"/",g_npp.npq05,                 #NO.FUN-710023 
                          "/",g_npp.npp06,"/",g_npp.npp07,"/",g_npp.npq24                             #NO.FUN-710023    
            CALL s_errmsg('npr00,npr01,npr02,npr03,npr08,npr10,npr11',g_showmsg,'p130(ckp#4):',SQLCA.sqlcode,1) #NO.FUN-710023   
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END IF
      # 符合資料更新後將 npp04 更新為  11
      UPDATE npp_file SET npp04 = '1' 
        WHERE nppsys=g_npp.nppsys AND npp00=g_npp.npp00 AND
              npp01=g_npp.npp01 AND npp011=g_npp.npp011
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err('p130_up',STATUS,1)   #No.FUN-660123
#        CALL cl_err3("upd","npp_file",g_npp.npp01,g_npp.npp00,STATUS,"","p130_up",1)   #No.FUN-660123 #NO.FUN-710023
         LET g_showmsg=g_npp.nppsys,"/",g_npp.npp00,"/",g_npp.npp01,"/",g_npp.npp011    #NO.FUN-710023   
         CALL s_errmsg('nppsys,npp00,npp01,npp011',g_showmsg,'p130_up',STATUS,1)        #NO.FUN-710023            
         LET g_success = 'N'
#        EXIT FOREACH                        #NO.FUN-710023
         CONTINUE FOREACH                    #NO.FUN-710023
      END IF
   END FOREACH
#NO.FUN-710023--BEGIN                                                           
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
#NO.FUN-710023--END
 
END FUNCTION
