# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abxp910.4gl
# Descriptions...: 保稅原料年度結算統計作業
# Modify.........: No:9814 04/07/30 By Wiky 期初INSERT時未Default前期資料!
# Modify.........: NO.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.FUN-560231 05/06/27 By Mandy QPA欄位放大
# Modify.........: No.MOD-580323 05/08/31 By jackie 將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.MOD-5B0036 05/12/01 By Nicola 1.p910_3() line 252 之前, 應加入SELECT ima106 INTO bwe.bwe05 FROM ima_file WHERE ima01=bwe.bwe03, 以記錄正確的區分
#                                                   2.p910_3() line 303, 應加上 AND bwe05='1' 才是抓出正確的原料盤存數
#                                                   3.p910_3() line 366 應改為 AND bwe05 MATCHES '[23]' 才能含半成品及成品之盤存數
#                                                   4.p910_bom() line 1067 應改為 SELECT ima106 INTO bwe.bwe05 FROM ima_file WHERE ima01 = p_key
#                                                     抓取保稅型態時, 應以上階料號之保稅型態來看, 以利後續 bwf_file 統計成品倉之折合量
#                                                   5.p910_bom() line 1078-1079及1100-1101 應 mark , 全數以 4之保稅型態來看
#                                                   6.p910_4() line 395-396 應mark ,起迄時間應以畫面上輸入的來看, 不應該在此又重新 default 一次
#                                                   7.p910_7() line 683-684 應mark , 理由同 6
# Modify.........: No.FUN-570115 06/03/02 By saki 加入背景作業功能
# Modify.........: No.FUN-660052 05/06/13 By ice cl_err3訊息修改
# Modify.........: No.MOD-680044 06/08/15 By Claire 放大欄位bwh13 dec(15,3)
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0007 06/11/06 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-980001 09/08/10 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0308 10/12/01 By vealxu 737行有錯字g_plang應改為g_plant
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting  1、將cl_used()改成標準，使用g_prog
#                                                          2、未加離開前的 cl_used(2) 
# Modify.........: No:MOD-B60191 11/07/17 By Summer 結算日期應default abxs020的bxz07和bxz08
# Modify.........: No:MOD-C10032 12/01/05 By ck2yuan mark重複定義 g_bwh
# Modify.........: No:MOD-BA0160 12/06/15 By ck2yuan 銷貨退回的折合量應該要為負的
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_begin,g_end            LIKE type_file.dat       #No.FUN-680062 DATE 
   DEFINE l_found                  LIKE type_file.chr1      #No.FUN-680062 VARCHAR(1)   
   DEFINE x_total                  LIKE bwe_file.bwe04                        
   DEFINE g_no                     LIKE type_file.num5      #No.FUN-680062 SMALLINT 
   DEFINE l_n                      LIKE type_file.num5      #No.FUN-680062 SMALLINT 
   DEFINE x_n                      LIKE type_file.num5      #No.FUN-680062 SMALLINT
   DEFINE xx                       LIKE type_file.chr1      #No.FUN-680062 VARCHAR(1) 
   DEFINE x2                       LIKE bwg_file.bwg01
   DEFINE x3                       LIKE bwg_file.bwg02
   DEFINE yy                       LIKE type_file.chr20    #No.FUN-680062 VARCHAR(10)                                                             
   DEFINE g_yy                     LIKE bwh_file.bwh01     #No.FUN-680062 SMALLINT
   DEFINE g_step1,g_step2,g_step3  LIKE type_file.chr1      #No.FUN-680062CHAR(1)
   DEFINE g_step4,g_step5,g_step6  LIKE type_file.chr1      #No.FUN-680062CHAR(1)
   DEFINE g_step7                  LIKE type_file.chr1      #No.FUN-680062CHAR(1)   
   DEFINE g_step11                 LIKE type_file.chr1  #FUN-6A0007
   DEFINE g_wc,g_wc2,g_sql         STRING  #No.FUN-580092 HCN
   DEFINE g_part                   LIKE type_file.chr1000   #No.FUN-680062CHAR(12)                                                             
   DEFINE g_upd_flag               LIKE type_file.chr1      #No.FUN-680062 VARCHAR(1)
   DEFINE qty,qty1,qty2,qty3,qty4  LIKE bwh_file.bwh11      #No.FUN-680062 DECIMAL(15,3)
   DEFINE g_bxr                    RECORD LIKE bxr_file.*
   DEFINE g_bnd                    RECORD LIKE bnd_file.*
   DEFINE g_bwh                    RECORD LIKE bwh_file.*
   DEFINE g_bwd                    RECORD LIKE bwd_file.*
   DEFINE g_bwg                    RECORD LIKE bwg_file.*
   DEFINE bwe                      RECORD LIKE bwe_file.*
   DEFINE bwa                      RECORD LIKE bwa_file.*
   DEFINE bwb                      RECORD LIKE bwb_file.*
   DEFINE bwc                      RECORD LIKE bwc_file.*
   DEFINE g_ima20                  LIKE ima_file.ima20    #No.FUN-680062   DECIMAL(9,3) 
   DEFINE g_change_lang            LIKE type_file.chr1    #No.FUN-570115  #No.FUN-680062 VARCHAR(1)   
   DEFINE ls_date                  STRING                 #No.FUN-570115  
   DEFINE l_flag                   LIKE type_file.chr1   #No.FUN-570115   #No.FUN-680062 VARCHAR(1)   
   DEFINE g_ima106                 LIKE ima_file.ima106  #FUN-6A0007
   DEFINE g_bxi06                  LIKE bxi_file.bxi06   #FUN-6A0007
 
MAIN
#  DEFINE p_row,p_col   SMALLINT         #No.FUN-570115
#  DEFINE l_time LIKE type_file.chr8     #No.FUN-6A0062
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   #No.FUN-570115 --start--
    INITIALIZE g_bgjob_msgfile TO NULL
    LET g_yy = ARG_VAL(1)
    LET ls_date = ARG_VAL(2)
    LET g_begin = cl_batch_bg_date_convert(ls_date)
    LET ls_date = ARG_VAL(3)
    LET g_end = cl_batch_bg_date_convert(ls_date)
    LET g_step1 = ARG_VAL(4)
    LET g_step2 = ARG_VAL(5)
    LET g_step3 = ARG_VAL(6)
    LET g_step4 = ARG_VAL(7)
    LET g_step5 = ARG_VAL(8)
    LET g_step6 = ARG_VAL(9)
    LET g_step7 = ARG_VAL(10)
    LET g_bgjob = ARG_VAL(11)
    IF cl_null(g_bgjob) THEN
       LET g_bgjob = "N"
    END IF
   # No.FUN-570115 --end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-570115 --start--
#  OPEN WINDOW p910_w AT p_row,p_col WITH FORM "abx/42f/abxp910" 
#    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#  
#  CALL cl_ui_init()
 
   #CALL cl_used('abxp910',g_time,1) RETURNING g_time
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   WHILE TRUE
       IF g_bgjob="N" THEN                
          CALL p910_p1()
          IF cl_sure(21,21) THEN
             CALL cl_wait()                        
            #BEGIN WORK #FUN-6A0007
             IF g_step1 = 'Y' THEN
                CALL p910_1()
             END IF
     #FUN-6A0007 (S)-----
      IF g_step11= 'Y' THEN
         CALL p910_11()
      END IF
     #FUN-6A0007 (E)-----
             IF g_step2 = 'Y' THEN
                CALL p910_2()
             END IF
             IF g_step3 = 'Y' THEN
                CALL p910_3()
             END IF
             IF g_step4 = 'Y' THEN
                CALL p910_4()
             END IF
             IF g_step5 = 'Y' THEN
                CALL p910_5()
             END IF
             IF g_step6 = 'Y' THEN
                CALL p910_6()
             END IF
             IF g_step7 = 'Y' THEN
                CALL p910_7()
             END IF
             MESSAGE "年度結算完畢"
             CALL cl_end2(1) RETURNING l_flag
             IF l_flag THEN
                CONTINUE WHILE
             ELSE
                CLOSE WINDOW p910_w
                EXIT WHILE
             END IF
          ELSE
             CONTINUE WHILE
          END IF
          CLOSE WINDOW p910_w
       ELSE
         #BEGIN WORK #FUN-6A0007                                  
          IF g_step1 = 'Y' THEN
             CALL p910_1()
          END IF
          IF g_step2 = 'Y' THEN
             CALL p910_2()
          END IF
          IF g_step3 = 'Y' THEN
             CALL p910_3()
          END IF
          IF g_step4 = 'Y' THEN
             CALL p910_4()
          END IF
          IF g_step5 = 'Y' THEN
             CALL p910_5()
          END IF
          IF g_step6 = 'Y' THEN
             CALL p910_6()
          END IF
          IF g_step7 = 'Y' THEN
             CALL p910_7()
          END IF
          CALL cl_batch_bg_javamail(g_success)
          EXIT WHILE
       END IF
   END WHILE
#  CALL p910_p1()
#  CLOSE WINDOW p910_w
   #No.FUN-570115 --end--
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
END MAIN
 
FUNCTION p910_p1()
   DEFINE l_str1  STRING   #No.MOD-580323  
   DEFINE lc_cmd        LIKE type_file.chr1000    # No.FUN-570115    #No.FUN-680062  VARCHAR(500)  
   DEFINE p_row,p_col   LIKE type_file.num5       # No.FUN-570115    #No.FUN-680062  SMALLINT    
 
   #No.FUN-570115 --start--
   LET p_row=5
   LET p_col=25
 
   OPEN WINDOW p910_w AT p_row,p_col WITH FORM "abx/42f/abxp910"
   ATTRIBUTE(STYLE=g_win_style)
 
   CALL cl_ui_init()
   CLEAR FORM
   #No.FUN-570115 --end--
 
  #LET g_yy = YEAR(TODAY) USING "&&&&"
  #MOD-B60191---modify---start---
  #LET g_yy = YEAR(TODAY)-1 USING "&&&&"   #FUN-6A0007
  #DISPLAY BY NAME g_yy
  #LET g_begin = MDY(1,1,g_yy)
  #LET g_end   = MDY(12,31,g_yy)
   LET g_yy = g_bxz.bxz06
   IF cl_null(g_yy) THEN
      LET g_yy = YEAR(TODAY) USING "&&&&"   
   END IF
   DISPLAY BY NAME g_yy
   LET g_begin = g_bxz.bxz07 
   IF cl_null(g_begin) THEN
      LET g_begin = cl_batch_bg_date_convert(ls_date)
   END IF
   LET g_end = g_bxz.bxz08 
   IF cl_null(g_end) THEN
      LET g_end = cl_batch_bg_date_convert(ls_date)
   END IF
  #MOD-B60191---modify---end---
   LET g_step1 = 'Y'
   LET g_step11 = 'Y'  #FUN-6A0007
   LET g_step2 = 'Y'
   LET g_step3 = 'Y'
   LET g_step4 = 'Y'
   LET g_step5 = 'Y'
   LET g_step6 = 'Y'
   LET g_step7 = 'Y' 
 
   LET g_bgjob = "N"                                   #No.FUN-570115
   WHILE TRUE
     #FUN-6A0007 Mark (S)-------
     #LET g_yy    = YEAR(TODAY)-1
     #LET g_begin = MDY(7,1,g_yy)
     #LET g_end   = MDY(6,30,g_yy+1)
     #FUN-6A0007 Mark (E)-------
 
    #FUN-6A0007 Mod 增加g_step11的輸入(本年度盤點結算資料刪除)----
    # INPUT BY NAME g_yy,g_begin,g_end,g_step1,g_step2,g_step3,g_step4,
      INPUT BY NAME g_yy,g_begin,g_end,g_step1,g_step11,g_step2,g_step5,
                    g_step6,g_step3,g_step7,g_step4,g_bgjob WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
        #FUN-6A0007 (S)----------
         AFTER FIELD g_yy
            LET g_begin = MDY(1,1,g_yy)
            LET g_end   = MDY(12,31,g_yy)
            DISPLAY BY NAME g_begin,g_end
        #FUN-6A0007 (E)----------
 
 
         ON ACTION locale
#           CALL cl_dynamic_locale()                   #No.FUN-570115
#           CALL cl_show_fld_cont()                    #No.FUN-550037 hmf  No.FUN-570115
            LET g_change_lang = TRUE                   #No.FUN-570115
            EXIT INPUT                                 #No.FUN-570115
 
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      #No.FUN-570115 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      #No.FUN-570115 --end--
 
      IF INT_FLAG THEN 
         LET INT_FLAG=0 
         CLOSE WINDOW p910_w                       #No.FUN-570115
#        RETURN                                    #No.FUN-570115
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM                              #No.FUN-570115  
      END IF
 
      #No.FUN-570115 --start--
#     IF NOT cl_sure(0,0) THEN
#        CONTINUE WHILE 
#     END IF
#     IF g_step1 = 'Y' THEN 
#        CALL p910_1() 
#     END IF
#     IF g_step2 = 'Y' THEN 
#        CALL p910_2() 
#     END IF
#     IF g_step3 = 'Y' THEN 
#        CALL p910_3() 
#     END IF
#     IF g_step4 = 'Y' THEN 
#        CALL p910_4() 
#     END IF
#     IF g_step5 = 'Y' THEN 
#        CALL p910_5() 
#     END IF
#     IF g_step6 = 'Y' THEN 
#        CALL p910_6() 
#     END IF
#     IF g_step7 = 'Y' THEN 
#        CALL p910_7() 
#     END IF
 
      IF g_bgjob="Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
            WHERE zz01="abxp910"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('abxp910','9031',1)
         ELSE
            LET lc_cmd=lc_cmd CLIPPED,
                       " '",g_yy CLIPPED,"'",
                       " '",g_begin CLIPPED,"'",
                       " '",g_end CLIPPED,"'",
                       " '",g_step1 CLIPPED,"'",
                       " '",g_step2 CLIPPED,"'",
                       " '",g_step3 CLIPPED,"'",
                       " '",g_step4 CLIPPED,"'",
                       " '",g_step5 CLIPPED,"'",
                       " '",g_step6 CLIPPED,"'",
                       " '",g_step7 CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('abxp910',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p910_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      #No.MOD-580323 --start--                                                       
      CALL cl_getmsg('abx9101',g_lang) RETURNING l_str1                         
      MESSAGE l_str1                                                            
      #No.MOD-580323 --end--              
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p910_1()                # 1.本年度結算資料全部刪除
   #No.MOD-580323 --start--                                                       
   DEFINE l_str2 STRING  #No.MOD-580323                                         
 
   IF g_bgjob = "N" THEN                         #No.FUN-570115
      CALL cl_getmsg('abx9102',g_lang) RETURNING l_str2                             
      MESSAGE l_str2                                                                
   END IF                                        #No.FUN-570115
 
   DELETE FROM bwh_file WHERE bwh01=g_yy                                         
 
   DELETE FROM bwd_file                                                          
    WHERE bwd011=g_yy  #FUN-6A0007
 
 # DELETE FROM bwe_file   #FUN-6A0007 Mark 改在p910_11()處理                                                         
 # DELETE FROM bwf_file   #FUN-6A0007 Mark 改在p910_11()處理                                                         
   DELETE FROM bwg_file                                                          
    WHERE bwg011=g_yy  #FUN-6A0007
 
   IF STATUS THEN                                                                          
#     CALL cl_err(l_str2,STATUS,1)   #No.FUN-660052
      CALL cl_err3("del","bwg_file","","",STATUS,"",l_str2,1) 
   #No.MOD-580323 --end--   
   END IF
 
END FUNCTION
 
#FUN-6A0007 (S)--本年度盤點結算資料全部刪除--
FUNCTION p910_11()
 DEFINE l_str STRING  
 #"11.刪除 bwe_file(年度保稅盤點結算資料檔)"
  CALL cl_getmsg('abx-081',g_lang) RETURNING l_str                             
  MESSAGE l_str                                                                
 
 DELETE FROM bwe_file WHERE bwe011 = g_yy
 DELETE FROM bwf_file WHERE bwf011 = g_yy
END FUNCTION
#FUN-6A0007 (E)------------------------------
 
 
FUNCTION p910_2()                # 2.去年結存結轉本年期初
   #No.MOD-580323 --start--                                                       
   DEFINE l_str3 STRING  #No.MOD-580323                                         
 
   IF g_bgjob = "N" THEN                        #No.FUN-570115
      CALL cl_getmsg('abx9103',g_lang) RETURNING l_str3                             
      MESSAGE l_str3                                                                
      #No.MOD-580323 --end--      
   END IF                                       #No.FUN-570115
 
   UPDATE bwh_file SET bwh03=0,
                       bwh04=0
    WHERE bwh01 = g_yy
      AND (bwh03 != 0 OR bwh04 != 0)
 
   DECLARE p910_2_c CURSOR FOR SELECT bwh02,bwh15,bwh16
                                 FROM bwh_file
                                WHERE bwh01 = g_yy-1
 
   FOREACH p910_2_c INTO g_bwh.bwh02,g_bwh.bwh15,g_bwh.bwh16
      IF STATUS THEN
         CALL cl_err('for-1',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF g_bwh.bwh15 IS NULL THEN 
         LET g_bwh.bwh15 = 0 
      END IF
 
      IF g_bwh.bwh16 IS NULL THEN
         LET g_bwh.bwh16 = 0
      END IF
 
      UPDATE bwh_file SET bwh03 = g_bwh.bwh15,
                          bwh04 = g_bwh.bwh16
       WHERE bwh01 = g_yy
         AND bwh02 = g_bwh.bwh02 
      IF STATUS THEN 
#        CALL cl_err('UPDATE bwh_file:',STATUS,1)   #NO.FUN-660052
         CALL cl_err3("upd","bwh_file",g_yy,g_bwh.bwh02,STATUS,"","UPDATE bwh_file:",1) 
         EXIT FOREACH 
      END IF
 
      IF SQLCA.SQLERRD[3]=0 THEN
         #no:5287
         IF cl_null(g_bwh.bwh01) OR g_bwh.bwh01=0 THEN 
            LET g_bwh.bwh01 = g_yy 
         END IF
 
         LET g_bwh.bwh03 = g_bwh.bwh15  #No.9814
         LET g_bwh.bwh04 = g_bwh.bwh16  #No.9814
         IF g_bwh.bwh03 IS NULL THEN LET g_bwh.bwh03 = 0 END IF
         IF g_bwh.bwh04 IS NULL THEN LET g_bwh.bwh04 = 0 END IF
         IF g_bwh.bwh05 IS NULL THEN LET g_bwh.bwh05 = 0 END IF
         IF g_bwh.bwh06 IS NULL THEN LET g_bwh.bwh06 = 0 END IF
         IF g_bwh.bwh07 IS NULL THEN LET g_bwh.bwh07 = 0 END IF
         IF g_bwh.bwh08 IS NULL THEN LET g_bwh.bwh08 = 0 END IF
         IF g_bwh.bwh09 IS NULL THEN LET g_bwh.bwh09 = 0 END IF
         IF g_bwh.bwh10 IS NULL THEN LET g_bwh.bwh10 = 0 END IF
         IF g_bwh.bwh11 IS NULL THEN LET g_bwh.bwh11 = 0 END IF
         IF g_bwh.bwh12 IS NULL THEN LET g_bwh.bwh12 = 0 END IF
         IF g_bwh.bwh13 IS NULL THEN LET g_bwh.bwh13 = 0 END IF
         IF g_bwh.bwh14 IS NULL THEN LET g_bwh.bwh14 = 0 END IF
         #no:5287
 
         LET g_bwh.bwhplant = g_plant   #FUN-980001 add
         LET g_bwh.bwhlegal = g_legal   #FUN-980001 add
 
         INSERT INTO bwh_file VALUES(g_bwh.*)
         IF STATUS THEN 
#           CALL cl_err('INSERT bwh_file:',STATUS,1)   #No.FUN-660052
            CALL cl_err3("ins","bwh_file",g_bwh.bwh01,g_bwh.bwh02,STATUS,"","INSERT bwh_file:",1) 
            EXIT FOREACH 
         END IF
      END IF
   END FOREACH
 
END FUNCTION
 
FUNCTION p910_3()                # 3.盤點資料折合統計(成品,半成品,原料) 
   DEFINE sr      RECORD
                     part            LIKE type_file.chr1000,    #No.FUN-680062   VARCHAR(12) 
                     qty1,qty2,qty3  LIKE bwh_file.bwh11        #No.FUN-680062   decimal(15,3) 
                  END RECORD
   DEFINE xima106 LIKE ima_file.ima106
   DEFINE l_n     LIKE type_file.num5                     #No.FUN-680062    smallint
   #No.MOD-580323 --start--                                                       
        DEFINE l_str4,l_str5,l_str6,l_str7,l_str8,l_str9,l_str10  STRING              
 
   IF g_bgjob = "N" THEN                        #No.FUN-570115
      CALL cl_getmsg('abx9104',g_lang) RETURNING l_str4                             
      MESSAGE l_str4                                                                
   END IF                                       #No.FUN-570115
 
   DECLARE p910_3_c CURSOR FOR SELECT bwa_file.*,ima106
                                 FROM bwa_file,ima_file                            
                                WHERE bwa02 = ima01                                                           
                                  AND bwa011 = g_yy   #FUN-6A0007
 
   FOREACH p910_3_c INTO bwa.*,xima106                                           
      IF g_bgjob = "N" THEN                     #No.FUN-570115
         CALL cl_getmsg('abx9105',g_lang) RETURNING l_str5                          
         MESSAGE l_str5,bwa.bwa02                                                   
      END IF                                    #No.FUN-570115
  #No.MOD-580323 --end     
      LET bwe.bwe011 = g_yy  #年度  #FUN-6A0007
      LET bwe.bwe00 = "S"       #庫存盤點
      LET bwe.bwe01 = bwa.bwa01 #盤點標籤  
      LET bwe.bwe03 = bwa.bwa02 #料件編號
      LET bwe.bwe04 = bwa.bwa06 #數量
      LET g_no = 0
      LET x_total=bwa.bwa06
 
     #FUN-6A0007 (S)------------------
     #CALL p910_bom(0,bwe.bwe03,bwe.bwe04)
      LET g_ima106 = xima106
      CALL p910_bom(0,bwe.bwe03,bwe.bwe04,1)
     #FUN-6A0007 (E)------------------
 
      LET bwe.bwe011 = g_yy  #年度  #FUN-6A0007
      LET bwe.bwe00 = "S"       #庫存盤點
      LET bwe.bwe02 = 0         #序號  
      LET bwe.bwe01 = bwa.bwa01 #盤點標籤  
      LET bwe.bwe03 = bwa.bwa02 #料件編號
      LET bwe.bwe031= 1         #單位用量
 
      #-----No.MOD-5B0036-----
      SELECT ima106 INTO bwe.bwe05 FROM ima_file
       WHERE ima01 = bwe.bwe03
      #-----No.MOD-5B0036 END-----
 
      LET bwe.bwe04 = bwa.bwa06 #數量
 
      LET bwe.bweplant = g_plant   #FUN-980001 add
      LET bwe.bwelegal = g_legal   #FUN-980001 add
 
      INSERT INTO bwe_file VALUES (bwe.*) 
      IF SQLCA.SQLCODE <> 0 THEN 
         UPDATE bwe_file SET bwe04 = bwe04 + bwe.bwe04
          WHERE bwe00 = bwe.bwe00
            AND bwe01 = bwe.bwe01
            AND bwe02 = bwe.bwe02
            AND bwe03 = bwe.bwe03
            AND bwe011 = bwe.bwe011  #FUN-6A0007
      END IF
   END FOREACH 
 
 #FUN-6A0007 (S)----非委外工單bwb07 = 'N'--------------------
 #原PACKAGE對於是以單頭檔成品編號(bwb03)及未入庫量(bwb04)去折合,
 #         改成取單身檔的料件編號(bwc03)及實盤數量(bwc05)往下折合!
 {
   DECLARE p910_3_d CURSOR FOR SELECT bwb_file.* FROM bwb_file  
 
   FOREACH p910_3_d INTO bwb.*
      IF g_bgjob = "N" THEN                     #No.FUN-570115
         #No.MOD-580323 --start--                                                       
         CALL cl_getmsg('abx9106',g_lang) RETURNING l_str6                          
         MESSAGE l_str6,bwb.bwb03                                                   
         #No.MOD-580323 --end--    
      END IF                                    #No.FUN-570115
      LET bwe.bwe00 = "W"       #庫存盤點
      LET bwe.bwe01 = bwb.bwb01 #盤點標籤  
      LET bwe.bwe02 = 0         #序號  
      LET bwe.bwe03 = bwb.bwb03 #料件編號
      LET bwe.bwe04 = bwb.bwb04 #數量
      LET g_no = 0
      LET x_total=bwe.bwe04
 
      CALL p910_bom(0,bwe.bwe03,bwe.bwe04)
     
      LET bwe.bwe00 = "W"       #庫存盤點
      LET bwe.bwe02 = 0         #序號  
      LET bwe.bwe01 = bwb.bwb01 #盤點標籤  
      LET bwe.bwe03 = bwb.bwb03 #料件編號
      LET bwe.bwe031= 1         #單位用量
      LET bwe.bwe04 = bwb.bwb04 #數量
 
      SELECT ima106 INTO bwe.bwe05 FROM ima_file WHERE ima01 = bwb.bwb03
 }
   DECLARE p910_3_d CURSOR FOR
    SELECT bwc_file.* FROM bwb_file,bwc_file
     WHERE bwb01=bwc01
       AND bwb011 = g_yy   #FUN-6A0007
       AND (bwb07 = 'N' OR bwb07 IS NULL)   #非委外工單
   FOREACH p910_3_d INTO bwc.*
      IF g_bgjob = "N" THEN
         CALL cl_getmsg('abx9106',g_lang) RETURNING l_str6   
         MESSAGE l_str6,bwc.bwc03     
      END IF
      LET bwe.bwe00 = "W"#庫存盤點
      LET bwe.bwe01 = bwc.bwc01 #盤點標籤
      LET bwe.bwe02 = bwc.bwc02 #序號  #原LET 0 改給bwc02 #FUN-6A0007
      LET bwe.bwe03 = bwc.bwc03 #料件編號
      LET bwe.bwe04 = bwc.bwc05 #數量(實盤數量)
      LET g_no = 0
      LET bwe.bwe011 = bwc.bwc011  #年度  #FUN-6A0007
      LET x_total=bwe.bwe04
      #最上階開始展BOM料號的保稅料件型態(ima106) #FUN-6A0007
      LET g_ima106= ''
      SELECT ima106 INTO g_ima106 FROM ima_file
         WHERE ima01=bwe.bwe03
      CALL p910_bom(0,bwe.bwe03,bwe.bwe04,1)
 
      LET bwe.bwe011 = bwc.bwc011  #年度  #FUN-6A0007
      LET bwe.bwe00 = "W"       #庫存盤點
      LET bwe.bwe02 = bwc.bwc02 #序號  #原LET 0 改給bwc02 #FUN-6A0007
      LET bwe.bwe01 = bwc.bwc01 #盤點標籤
      LET bwe.bwe03 = bwc.bwc03 #料件編號
      LET bwe.bwe031= 1         #單位用量
      LET bwe.bwe04 = bwc.bwc05 #數量(實盤數量)
      LET bwe.bwe05 = g_ima106
 #FUN-6A0007 (E)----非委外工單-----------------------------------
 
      LET bwe.bweplant = g_plant   #FUN-980001 add
      LET bwe.bwelegal = g_legal   #FUN-980001 add
 
      INSERT INTO bwe_file VALUES(bwe.*)
      IF SQLCA.SQLCODE <> 0 THEN 
         UPDATE bwe_file SET bwe04 = bwe04 + bwe.bwe04
          WHERE bwe00 = bwe.bwe00
            AND bwe01 = bwe.bwe01
            AND bwe02 = bwe.bwe02
            AND bwe03 = bwe.bwe03
            AND bwe011 = bwe.bwe011   #年度 #FUN-6A0007
      END IF
   END FOREACH 
   
 #FUN-6A0007 (S)----委外工單bwb07 = 'Y'----------------------
   DECLARE p910_3_dp CURSOR FOR
    SELECT bwc_file.* FROM bwb_file,bwc_file
     WHERE bwb01=bwc01
       AND bwc011 = g_yy  #FUN-6A0007
       AND bwb07 = 'Y'   #委外工單
   FOREACH p910_3_dp INTO bwc.*
      CALL cl_getmsg('abx9106',g_lang) RETURNING l_str6   
      MESSAGE l_str6,bwc.bwc03     
 
      LET bwe.bwe011 = bwc.bwc011  #年度  #FUN-6A0007
      LET bwe.bwe00 = "P"       #庫存盤點(委外工單=P)*
      LET bwe.bwe01 = bwc.bwc01 #盤點標籤
      LET bwe.bwe02 = bwc.bwc02 #序號   #原LET 0 改給bwc02  #FUN-6A0007
      LET bwe.bwe03 = bwc.bwc03 #料件編號
      LET bwe.bwe04 = bwc.bwc05 #數量(實盤數量)
      LET g_no = 0
      LET x_total=bwe.bwe04
      #最上階開始展BOM料號的保稅料件型態(ima106) #FUN-6A0007
      LET g_ima106= ''
      SELECT ima106 INTO g_ima106 FROM ima_file
       WHERE ima01=bwe.bwe03
      CALL p910_bom(0,bwe.bwe03,bwe.bwe04,1) 
      LET bwe.bwe011 = bwc.bwc011  #年度  #FUN-6A0007
      LET bwe.bwe00 = "P"       #庫存盤點(委外工單=P)
      LET bwe.bwe02 = bwc.bwc02 #序號   #原LET 0 改給bwc02  #FUN-6A0007
      LET bwe.bwe01 = bwc.bwc01 #盤點標籤
      LET bwe.bwe03 = bwc.bwc03 #料件編號
      LET bwe.bwe031= 1         #單位用量
      LET bwe.bwe04 = bwc.bwc05 #數量(實盤數量)
      LET bwe.bwe05 = g_ima106
 
      LET bwe.bweplant = g_plant   #FUN-980001 add
      LET bwe.bwelegal = g_legal   #FUN-980001 add
 
      INSERT INTO bwe_file VALUES(bwe.*)
      IF sqlca.sqlcode <> 0 THEN
         UPDATE bwe_file SET bwe04 = bwe04 + bwe.bwe04
          WHERE bwe00 = bwe.bwe00
            AND bwe01 = bwe.bwe01
            AND bwe02 = bwe.bwe02
            AND bwe03 = bwe.bwe03
            AND bwe011 = bwe.bwe011  #FUN-6A0007
      END IF
   END FOREACH
 #FUN-6A0007 (E)----委外工單-------------------------------------
   
   #計算 bwf_file.bwf02
   DECLARE p910_3_g CURSOR FOR SELECT bwe00,bwe03,bwe05,SUM(bwe04)
                                 FROM bwe_file
                                WHERE bwe00 = "S"
                                  AND bwe05 = '1'   #No.MOD-5B0036
                                  AND bwe011 = g_yy  #FUN-6A0007
                                GROUP BY bwe00,bwe03,bwe05
 
   FOREACH p910_3_g INTO bwe.bwe00,bwe.bwe03,bwe.bwe05,bwe.bwe04
      IF g_bgjob = "N" THEN                     #No.FUN-570115
         #No.MOD-580323 --start--                                                       
         CALL cl_getmsg('abx9107',g_lang) RETURNING l_str7                             
         MESSAGE l_str7                                                                
         #No.MOD-580323 --end--                         
      END IF                                    #No.FUN-570115
 
      UPDATE bwf_file SET bwf02 = bwf02+bwe.bwe04
       WHERE bwf01 = bwe.bwe03
         AND bwf011 = g_yy  #FUN-6A0007
      IF STATUS THEN
#        CALL cl_err('UPDATE BWF_FILE:',STATUS,1)   #No.FUN-660052
         CALL cl_err3("upd","bwf_file",bwe.bwe03,"",STATUS,"","UPDATE bwh_file:",1) 
         EXIT FOREACH
      END IF
 
     IF SQLCA.SQLERRD[3]=0 THEN
       #FUN-6A0007、C4--(S)-------------------------------
       #INSERT INTO bwf_file VALUES(bwe.bwe03,bwe.bwe04,0,0,0)
        #FUN-980001 -----------(S)
       #INSERT INTO bwf_file VALUES(bwe.bwe03,bwe.bwe04,0,0,0,g_yy,0,0,0,0)
        INSERT INTO bwf_file VALUES(bwe.bwe03,bwe.bwe04,0,0,0,g_yy,0,0,0,0,
                                    g_plant,g_legal)
        #FUN-980001 -----------(E)
       #FUN-6A0007、C4--(E)-------------------------------
        IF STATUS THEN 
#          CALL cl_err('INSERT BWF_FILE:',STATUS,1) #No.FUN-660052
           CALL cl_err3("ins","bwf_file",bwe.bwe03,"",STATUS,"","INSERT BWH_FIlE:",1) 
           EXIT FOREACH
        END IF
     END IF
   END FOREACH 
 
   #計算 bwf_file.bwf03
   DECLARE p910_3_h CURSOR FOR SELECT bwe00,bwe03,bwe05,SUM(bwe04)
                                 FROM bwe_file
                                WHERE bwe00 = "W"
                                  AND bwe05 = "1"
                                  AND bwe011 = g_yy   #FUN-6A0007
                                GROUP BY bwe00,bwe03,bwe05
 
   FOREACH p910_3_h INTO bwe.bwe00,bwe.bwe03,bwe.bwe05,bwe.bwe04
      IF g_bgjob = "N" THEN                     #No.FUN-570115
         #No.MOD-580323 --start--                                                       
         CALL cl_getmsg('abx9108',g_lang) RETURNING l_str8                             
         MESSAGE l_str8                                                                
         #No.MOD-580323 --end--      
      END IF                                    #No.FUN-570115
 
      UPDATE bwf_file SET bwf03 = bwf03+bwe.bwe04
       WHERE bwf01 = bwe.bwe03
         AND bwf011 = g_yy   #FUN-6A0007
      IF STATUS THEN 
#        CALL cl_err('UPDATE BWF_FILE:',STATUS,1)  #No.FUN-660052
         CALL cl_err3("upd","bwf_file",bwe.bwe03,"",STATUS,"","UPDATE BWH_FIlE:",1) 
         EXIT FOREACH
      END IF
 
      IF SQLCA.SQLERRD[3]=0 THEN
        #FUN-6A0007 & C4--(S)-------------------
        #INSERT INTO bwf_file values (bwe.bwe03,0,bwe.bwe04,0,0)
        #FUN-980001 -----------(S)
        #INSERT INTO bwf_file values (bwe.bwe03,0,bwe.bwe04,0,0,g_yy,0,0,0,0)
         INSERT INTO bwf_file values (bwe.bwe03,0,bwe.bwe04,0,0,g_yy,0,0,0,0,
                                      g_plant,g_legal)                   #TQC-AB0308 mod g_plang -> g_plant
        #FUN-980001 -----------(E)
        #FUN-6A0007 & C4--(E)-------------------
         IF STATUS THEN
#           CALL cl_err('INSERT BWF_FILE:',STATUS,1)  #No.FUN-660052
            CALL cl_err3("ins","bwf_file",bwe.bwe03,"",STATUS,"","INSERT BWH_FIlE:",1) 
            EXIT FOREACH
         END IF
      END IF
   END FOREACH 
 
   #計算 bwf_file.bwf04
   DECLARE p910_3_i CURSOR FOR SELECT bwe00,bwe03,bwe05,SUM(bwe04)
                                 FROM bwe_file
                                WHERE bwe00 = "W"
                                  AND bwe05 IN ('2','3')
                                  AND bwe011 = g_yy  #FUN-6A0007
                                GROUP BY bwe00,bwe03,bwe05
 
   FOREACH p910_3_i INTO bwe.bwe00,bwe.bwe03,bwe.bwe05,bwe.bwe04
      IF g_bgjob = "N" THEN                     #No.FUN-570115
         #No.MOD-580323 --start--                                                       
         CALL cl_getmsg('abx9109',g_lang) RETURNING l_str9                             
         MESSAGE l_str9                                                                
         #No.MOD-580323 --end--
      END IF                                    #No.FUN-570115
 
      UPDATE bwf_file SET bwf04 = bwf04+bwe.bwe04
       WHERE bwf01 = bwe.bwe03
         AND bwf011 = g_yy   #FUN-6A0007
      IF STATUS THEN
#        CALL cl_err('UPDATE BWF_FILE:',STATUS,1)  #No.FUN-660052
         CALL cl_err3("upd","bwf_file",bwe.bwe03,"",STATUS,"","UPDATE BWH_FIlE:",1) 
         EXIT FOREACH
      END IF
 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
        #FUN-6A0007 & C4--(S)----------------
        #INSERT INTO bwf_file values (bwe.bwe03,0,0,bwe.bwe04,0)
        #FUN-980001 -----------(S)
        #INSERT INTO bwf_file values (bwe.bwe03,0,0,bwe.bwe04,0,g_yy,0,0,0,0)
         INSERT INTO bwf_file values (bwe.bwe03,0,0,bwe.bwe04,0,g_yy,0,0,0,0,
                                      g_plant,g_legal)
        #FUN-980001 -----------(E)
        #FUN-6A0007 & C4--(E)----------------
         IF STATUS THEN
#           CALL cl_err('INSERT BWF_FILE:',STATUS,1) #No.FUN-660052
            CALL cl_err3("ins","bwf_file",bwe.bwe03,"",STATUS,"","INSERT BWH_FIlE:",1) 
            EXIT FOREACH
         END IF
      END IF
   END FOREACH 
 
   #計算 bwf_file.bwf05
   DECLARE p910_3_j CURSOR FOR SELECT bwe00,bwe03,bwe05,SUM(bwe04)
                                 FROM bwe_file
                                WHERE bwe00 = "S"
                                 #AND bwe05 = "3"
                                  AND bwe05 IN ('2','3')  #No.MOD-5B0036
                                  AND bwe011 = g_yy  #FUN-6A0007
                                GROUP BY bwe00,bwe03,bwe05
 
   FOREACH p910_3_j INTO bwe.bwe00,bwe.bwe03,bwe.bwe05,bwe.bwe04
      IF g_bgjob = "N" THEN                     #No.FUN-570115
         #No.MOD-580323 --start--                                                       
         CALL cl_getmsg('abx9110',g_lang) RETURNING l_str10                            
         MESSAGE l_str10                                                               
         #No.MOD-580323 --end--                     
      END IF                                    #No.FUN-570115
 
      UPDATE bwf_file SET bwf05 = bwf05+bwe.bwe04
       WHERE bwf01 = bwe.bwe03
         AND bwf011 = g_yy    #FUN-6A0007
      IF STATUS THEN 
#        CALL cl_err('UPDATE BWF_FILE:',STATUS,1)  #No.FUN-60052
         CALL cl_err3("upd","bwf_file",bwe.bwe03,"",STATUS,"","UPDATE BWH_FIlE:",1) 
         EXIT FOREACH
      END IF
 
      IF SQLCA.SQLERRD[3]=0 THEN
        #FUN-6A0007 & C4--(S)--------------
        #INSERT INTO bwf_file values (bwe.bwe03,0,0,0,bwe.bwe04)
        #FUN-980001 -----------(S)
        #INSERT INTO bwf_file values (bwe.bwe03,0,0,0,bwe.bwe04,g_yy,0,0,0,0)
         INSERT INTO bwf_file values (bwe.bwe03,0,0,0,bwe.bwe04,g_yy,0,0,0,0,
                                      g_plant,g_legal)
        #FUN-980001 -----------(E)
        #FUN-6A0007 & C4--(E)--------------
         IF STATUS THEN
#           CALL cl_err('INSERT BWF_FILE:',STATUS,1)   #No.FUN-660052
            CALL cl_err3("ins","bwf_file",bwe.bwe03,"",STATUS,"","INSERT BWH_FIlE:",1) 
            EXIT FOREACH
         END IF
      END IF
   END FOREACH 
 
#FUN-6A0007 (S)增加計算bwf06、bwf07、bwf08、bwf09--
  #計算 生產線上半成品折合(bwf06)
   DECLARE p910_5_i CURSOR FOR
    SELECT bwe00,bwe03,bwe05,sum(bwe04) FROM bwe_file
     WHERE bwe00 = "W"
       AND bwe05 IN ('2')  
       AND bwe011 = g_yy   #FUN-6A0007
     GROUP BY bwe00,bwe03,bwe05
   FOREACH p910_5_i INTO bwe.bwe00,bwe.bwe03,bwe.bwe05,bwe.bwe04
      # "555555.dbo.BWE_FILE 匯總 BWF_file( bwf06 )"
      CALL cl_getmsg('abx-082',g_lang) RETURNING l_str10  
      MESSAGE l_str10 
      UPDATE bwf_file SET bwf06 = bwf06+bwe.bwe04
       WHERE bwf01 = bwe.bwe03
         AND bwf011 = g_yy   #FUN-6A0007
      IF STATUS THEN
         CALL cl_err('UPDATE BWF_FILE:',STATUS,1) EXIT FOREACH 
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
        #FUN-980001 -----------(S)
        #INSERT INTO bwf_file values (bwe.bwe03,0,0,0,0,g_yy,bwe.bwe04,0,0,0)
         INSERT INTO bwf_file values (bwe.bwe03,0,0,0,0,g_yy,bwe.bwe04,0,0,0,
                                      g_plant,g_legal)
        #FUN-980001 -----------(E)
         IF STATUS THEN 
            CALL cl_err('INSERT BWF_FILE:',STATUS,1) EXIT FOREACH 
         END IF
      END IF
   END FOREACH
 
  #計算 生產線上成品折合(bwf07)
   DECLARE p910_6_i CURSOR FOR
    SELECT bwe00,bwe03,bwe05,sum(bwe04) FROM bwe_file
     WHERE bwe00 = "W"
       AND bwe05 IN ('3')  
       AND bwe011 = g_yy   #FUN-6A0007
     GROUP BY bwe00,bwe03,bwe05
   FOREACH p910_6_i INTO bwe.bwe00,bwe.bwe03,bwe.bwe05,bwe.bwe04
      #"666666.dbo.BWE_FILE 匯總 BWF_file( bwf07 )"
      CALL cl_getmsg('abx-083',g_lang) RETURNING l_str10  
      MESSAGE l_str10 
 
      UPDATE bwf_file SET bwf07 = bwf07+bwe.bwe04
       WHERE bwf01 = bwe.bwe03
         AND bwf011 = g_yy   #FUN-6A0007
      IF STATUS THEN
         CALL cl_err('UPDATE BWF_FILE:',STATUS,1) EXIT FOREACH
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
        #FUN-980001 -----------(S)
        #INSERT INTO bwf_file values (bwe.bwe03,0,0,0,0,g_yy,0,bwe.bwe04,0,0)
         INSERT INTO bwf_file values (bwe.bwe03,0,0,0,0,g_yy,0,bwe.bwe04,0,0,
                                      g_plant,g_legal)
        #FUN-980001 -----------(E)
         IF STATUS THEN CALL cl_err('INSERT BWF_FILE:',STATUS,1) EXIT FOREACH
         END IF
      END IF
   END FOREACH
 
  #計算 託外數量折合原料(bwf08)
   DECLARE p910_7_i CURSOR FOR
    SELECT bwe00,bwe03,bwe05,sum(bwe04) FROM bwe_file
     WHERE bwe00 = "P"
       AND bwe05 IN ('1','2','3')  
       AND bwe011 = g_yy   #FUN-6A0007
   GROUP BY bwe00,bwe03,bwe05
   FOREACH p910_7_i INTO bwe.bwe00,bwe.bwe03,bwe.bwe05,bwe.bwe04
      #"777777.dbo.BWE_FILE 匯總 BWF_file( bwf08 )"
      CALL cl_getmsg('abx-084',g_lang) RETURNING l_str10  
      MESSAGE l_str10 
 
      UPDATE bwf_file SET bwf08 = bwf08+bwe.bwe04
       WHERE bwf01 = bwe.bwe03
         AND bwf011 = g_yy   #FUN-6A0007
      IF STATUS THEN
         CALL cl_err('UPDATE BWF_FILE:',STATUS,1) EXIT FOREACH
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
        #FUN-980001 -----------(S)
        #INSERT INTO bwf_file values (bwe.bwe03,0,0,0,0,g_yy,0,0,bwe.bwe04,0)
         INSERT INTO bwf_file values (bwe.bwe03,0,0,0,0,g_yy,0,0,bwe.bwe04,0,
                                      g_plant,g_legal)
        #FUN-980001 -----------(E)
         IF STATUS THEN
            CALL cl_err('INSERT BWF_FILE:',STATUS,1) EXIT FOREACH 
         END IF
      END IF
   END FOREACH
 
  #計算 倉庫半成品折合原料數(bwf09)
   DECLARE p910_8_j CURSOR FOR
    SELECT bwe00,bwe03,bwe05,sum(bwe04) FROM bwe_file
     WHERE bwe00 = "S"
       AND bwe011 = g_yy   #FUN-6A0007
       AND bwe05 = "2"
       GROUP BY bwe00,bwe03,bwe05
   FOREACH p910_8_j INTO bwe.bwe00,bwe.bwe03,bwe.bwe05,bwe.bwe04
      #"888888.dbo.BWE_FILE 匯總 BWF_file( bwf09 )"
      CALL cl_getmsg('abx-085',g_lang) RETURNING l_str10  
      MESSAGE l_str10 
  
      UPDATE bwf_file SET bwf09 = bwf09+bwe.bwe04
       WHERE bwf01 = bwe.bwe03
         AND bwf011 = g_yy   #FUN-6A0007
      IF STATUS THEN 
         CALL cl_err('UPDATE BWF_FILE:',STATUS,1) EXIT FOREACH 
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
        #FUN-980001 -----------(S)
        #INSERT INTO bwf_file values (bwe.bwe03,0,0,0,0,g_yy,0,0,0,bwe.bwe04)
         INSERT INTO bwf_file values (bwe.bwe03,0,0,0,0,g_yy,0,0,0,bwe.bwe04,
                                      g_plant,g_legal)
        #FUN-980001 -----------(E)
         IF STATUS THEN 
            CALL cl_err('INSERT BWF_FILE:',STATUS,1) EXIT FOREACH 
         END IF
      END IF
   END FOREACH
#FUN-6A0007 (E)增加計算bwf06、bwf07、bwf08、bwf09--
END FUNCTION
 
FUNCTION p910_4() #4.產生各料件年度工程變更期間資料
   DEFINE g_bwd            RECORD LIKE bwd_file.*
   DEFINE g_bnd            RECORD LIKE bnd_file.*
   DEFINE p_id             LIKE bnd_file.bnd01
   DEFINE l_str11,l_str12  STRING  #No.MOD-580323
 
   LET g_bwd.bwd03 = 0 
   LET g_bwd.bwd04 = 0 
   LET g_bwd.bwd05 = 0 
   LET g_bwd.bwd06 = 0 
   LET g_bwd.bwd011 = g_yy   #FUN-6A0007
  #LET g_begin = MDY(1,1,g_yy)     #No.MOD-5B0036 Mark
  #LET g_end   = MDY(12,31,g_yy)   #No.MOD-5B0036 Mark
 
   DECLARE bnd_cur1 CURSOR FOR SELECT unique bnd01 FROM bnd_file
 
   FOREACH bnd_cur1 INTO p_id 
      LET g_bwd.bwd01 = p_id 
      DECLARE bnd_cur2 CURSOR FOR SELECT * FROM bnd_file 
                                   WHERE bnd01 = p_id
                                     AND bnd02 <= g_end
                            AND (bnd03 > g_end OR bnd03 IS NULL)  #FUN-6A0007
                                   ORDER BY bnd02 DESC 
 
      FOREACH bnd_cur2 INTO g_bnd.* 
         IF g_bgjob = "N" THEN                     #No.FUN-570115
            #No.MOD-580323 --start--                                                       
            CALL cl_getmsg('abx9111',g_lang) RETURNING l_str11                      
            CALL cl_getmsg('abx9112',g_lang) RETURNING l_str12                      
            MESSAGE l_str11,g_bnd.bnd01,l_str12,g_bnd.bnd02                         
            #No.MOD-580323 --end--  
         END IF                                    #No.FUN-570115
 
         IF g_bnd.bnd02 <= g_begin THEN
            LET g_bwd.bwd02 = g_bnd.bnd02 
 
            LET g_bwd.bwdplant = g_plant #FUN-980001 add
            LET g_bwd.bwdlegal = g_legal #FUN-980001 add
 
            INSERT INTO bwd_file VALUES(g_bwd.*)
            EXIT FOREACH
         END IF
 
         LET g_bwd.bwd02 = g_bnd.bnd02 
 
         LET g_bwd.bwdplant = g_plant #FUN-980001 add
         LET g_bwd.bwdlegal = g_legal #FUN-980001 add
 
         INSERT INTO bwd_file VALUES(g_bwd.*)
      END FOREACH 
   END FOREACH 
 
END FUNCTION 
 
FUNCTION p910_5() #統計年度銷售,報廢,外運數 
   DEFINE l_sql      LIKE type_file.chr1000   #No.FUN-680062 VARCHAR(1000)   
   DEFINE g_bxi02    LIKE bxi_file.bxi02
   DEFINE g_bxi08    LIKE bxi_file.bxi08
   DEFINE g_bxj04    LIKE bxj_file.bxj04
   DEFINE g_bxj06    LIKE bxj_file.bxj06
   DEFINE l_bwd02    LIKE bwd_file.bwd02
   DEFINE l_str13,l_str14,l_str15 STRING #No.MOD-580323
 
   IF g_bgjob = "N" THEN                     #No.FUN-570115
      #No.MOD-580323 --start--                                                       
      CALL cl_getmsg('abx9113',g_lang) RETURNING l_str13                            
      MESSAGE l_str13                                                               
      #No.MOD-580323 --end--         
   END IF                                    #No.FUN-570115
 
   UPDATE bwd_file SET bwd03 = 0,
                       bwd04 = 0,
                       bwd05 = 0,
                       bwd06 = 0
                WHERE bwd011 = g_yy    #FUN-6A0007
 
 #FUN-6A0007 (S)原用保稅單據維護(abxt800)單頭保稅異動原因代碼(bxi08)
 #改用單身折合原因代碼(bxj21)去折合
 {
   LET l_sql = "SELECT bxj04,bxi02,bxi08,SUM(bxj06)",
               "  FROM bxj_file, bxi_file, bxr_file",
               " WHERE bxj01=bxi01 AND bxi08=bxr01",
               "   AND bxi02 between '",g_begin,"' AND '",g_end,"'",
               "   AND (bxr61 != 0 OR bxr62 != 0 OR bxr63 !=0 ",
               "    OR bxr23 !=0 OR bxr41 !=0)",
               " GROUP BY bxj04,bxi02,bxi08"
 }
   LET l_sql = "SELECT bxj04,bxi02,bxj21,bxi06,SUM(bxj06)",
               "  FROM bxj_file, bxi_file, bxr_file",
               " WHERE bxj01=bxi01 AND bxj21=bxr01",
               "   AND bxi02 between '",g_begin,"' and '",g_end,"'",
               "   AND (bxr61 != 0 OR bxr62 != 0 OR bxr63 !=0 ",
               "    OR bxr23 !=0 OR bxr41 !=0)",
               " GROUP BY bxj04,bxi02,bxj21,bxi06"
 #FUN-6A0007 (E)-------------------------------------------------
 
 
   PREPARE p910_5_pre FROM l_sql
   DECLARE p910_5_c CURSOR FOR p910_5_pre
 
 # FOREACH p910_5_c INTO g_bxj04,g_bxi02,g_bxi08,g_bxj06
   FOREACH p910_5_c INTO g_bxj04,g_bxi02,g_bxi08,g_bxi06,g_bxj06  #FUN-6A0007
      IF STATUS THEN 
         CALL cl_err('for-5',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF g_bgjob = "N" THEN                     #No.FUN-570115
         #No.MOD-580323 --start--                                                       
         CALL cl_getmsg('abx9111',g_lang) RETURNING l_str14                            
         CALL cl_getmsg('abx9115',g_lang) RETURNING l_str15                            
         MESSAGE l_str14,g_bxj04,l_str15,g_bxi08                                       
         #No.MOD-580323 --end--         
      END IF                                    #No.FUN-570115
 
      IF qty IS NULL THEN
         LET qty = 0
      END IF
    #MOD-BA0160---mark---start---
    ##FUN-6A0007 (S) 入庫時以負值表示---
    # IF g_bxi06 = '1' THEN
    #    LET g_bxj06 = g_bxj06 * (-1)
    # END IF
    ##FUN-6A0007 (E) -------------------
    #MOD-BA0160---mark---end-----
      
      LET l_found = "N"
 
      SELECT * INTO g_bxr.* FROM bxr_file WHERE bxr01 = g_bxi08
 
      CASE 
         WHEN g_bxr.bxr63 !=0 #內銷
            LET g_bxj06 = g_bxr.bxr63 * g_bxj06
           #FUN-6A0007--(S)------------------------------------
           #INSERT INTO bwd_file VALUES(g_bxj04,g_bxi02,g_bxj06,0,0,0)
           #FUN-980001 -----------(S)
           #INSERT INTO bwd_file VALUES(g_bxj04,g_bxi02,g_bxj06,0,0,0,g_yy)
            INSERT INTO bwd_file VALUES(g_bxj04,g_bxi02,g_bxj06,0,0,0,g_yy,
                                        g_plant,g_legal)
           #FUN-980001 -----------(E)
           #FUN-6A0007--(E)------------------------------------
           #IF STATUS=-239 OR STATUS=-268  THEN #TQC-790102
            IF  cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790102
               UPDATE bwd_file SET bwd03 = bwd03 + g_bxj06
                WHERE bwd01 = g_bxj04
                  AND bwd02 = g_bxi02
                  AND bwd011 = g_yy  #FUN-6A0007
            END IF
         WHEN g_bxr.bxr61 !=0 #外銷
            LET g_bxj06 = g_bxr.bxr61 * g_bxj06
           #FUN-6A0007--(S)------------------------------------
           #INSERT INTO bwd_file VALUES(g_bxj04,g_bxi02,0,g_bxj06,0,0)
           #FUN-980001 -----------(S)
           #INSERT INTO bwd_file VALUES(g_bxj04,g_bxi02,0,g_bxj06,0,0,g_yy)
            INSERT INTO bwd_file VALUES(g_bxj04,g_bxi02,0,g_bxj06,0,0,g_yy,
                                        g_plant,g_legal)
           #FUN-980001 -----------(E)
           #FUN-6A0007--(E)------------------------------------
           #IF STATUS=-239 OR STATUS=-268 THEN #TQC-790102
            IF  cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790102
               UPDATE bwd_file SET bwd04 = bwd04 + g_bxj06
                WHERE bwd01 = g_bxj04
                  AND bwd02 = g_bxi02
                  AND bwd011 = g_yy  #FUN-6A0007
            END IF
         WHEN g_bxr.bxr62 !=0 #外銷
            LET g_bxj06 = g_bxr.bxr62 * g_bxj06
           #FUN-6A0007--(S)------------------------------------
           #INSERT INTO bwd_file VALUES(g_bxj04,g_bxi02,0,g_bxj06,0,0)
           #FUN-980001 -----------(S)
           #INSERT INTO bwd_file VALUES(g_bxj04,g_bxi02,0,g_bxj06,0,0,g_yy)
            INSERT INTO bwd_file VALUES(g_bxj04,g_bxi02,0,g_bxj06,0,0,g_yy,
                                        g_plant,g_legal)
           #FUN-980001 -----------(E)
           #FUN-6A0007--(E)------------------------------------
           #IF STATUS=-239 OR STATUS=-268 THEN #TQC-790102
            IF  cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790102
               UPDATE bwd_file SET bwd04 = bwd04 + g_bxj06
                WHERE bwd01 = g_bxj04
                  AND bwd02 = g_bxi02
                  AND bwd011 = g_yy  #FUN-6A0007
            END IF
         WHEN g_bxr.bxr41 !=0 #報廢
            LET g_bxj06 = g_bxr.bxr41 * g_bxj06
           #FUN-6A0007--(S)------------------------------------
           #INSERT INTO bwd_file VALUES(g_bxj04,g_bxi02,0,0,g_bxj06,0)
           #FUN-980001 -----------(S)
           #INSERT INTO bwd_file VALUES(g_bxj04,g_bxi02,0,0,g_bxj06,0,g_yy)
            INSERT INTO bwd_file VALUES(g_bxj04,g_bxi02,0,0,g_bxj06,0,g_yy,
                                        g_plant,g_legal)
           #FUN-980001 -----------(E)
           #FUN-6A0007--(E)------------------------------------
           #IF STATUS=-239 OR STATUS=-268 THEN #TQC-790102
            IF  cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790102
               UPDATE bwd_file SET bwd05 = bwd05 + g_bxj06
                WHERE bwd01 = g_bxj04
                  AND bwd02 = g_bxi02
                  AND bwd011 = g_yy  #FUN-6A0007
            END IF
         WHEN g_bxr.bxr23 !=0 #外運
            LET g_bxj06 = g_bxr.bxr23 * g_bxj06
           #FUN-6A0007--(S)------------------------------------
           #INSERT INTO bwd_file VALUES(g_bxj04,g_bxi02,0,0,0,g_bxj06)
           #FUN-980001 -----------(S)
           #INSERT INTO bwd_file VALUES(g_bxj04,g_bxi02,0,0,0,g_bxj06,g_yy)
            INSERT INTO bwd_file VALUES(g_bxj04,g_bxi02,0,0,0,g_bxj06,g_yy,
                                        g_plant,g_legal)
           #FUN-980001 -----------(E)
           #FUN-6A0007--(E)------------------------------------
           #IF STATUS=-239 OR STATUS=-268 THEN #TQC-790102
            IF  cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790102
               UPDATE bwd_file SET bwd06 = bwd06 + g_bxj06
                WHERE bwd01 = g_bxj04 
                  AND bwd02 = g_bxi02
                  AND bwd011 = g_yy  #FUN-6A0007
            END IF
      END CASE 
   END FOREACH
 
END FUNCTION
 
FUNCTION p910_6() #6.年度銷售 報廢 外運折合
   DEFINE g_count  LIKE type_file.num5        #No.FUN-680062  smallint  
   DEFINE l_str16,l_str17,l_str18,l_str19,l_str20  STRING   #No.MOD-580323 
 
   DELETE FROM bwg_file 
     WHERE bwg011 = g_yy  #FUN-6A0007
  #DELETE FROM bwh_file    # p910_1() 已依條件(年度) delete 過了
 
   DECLARE selbwd01 CURSOR FOR SELECT * FROM bwd_file
                                WHERE bwd03 <> 0
                                  AND bwd011 = g_yy   #FUN-6A0007
                                ORDER BY bwd01,bwd02 
 
   INITIALIZE g_bwg.* TO NULL
 
   FOREACH selbwd01 INTO g_bwd.*
      IF g_bgjob = "N" THEN                     #No.FUN-570115
         #No.MOD-580323 --start--                                                       
         CALL cl_getmsg('abx9116',g_lang) RETURNING l_str16                       
         CALL cl_getmsg('abx9117',g_lang) RETURNING l_str17                       
         MESSAGE l_str16,g_bwd.bwd01,l_str17,g_bwd.bwd02                          
         #No.MOD-580323 --end--          
      END IF                                    #No.FUN-570115
 
      LET g_count = 0 
      LET g_bwg.bwg011 = g_yy     #FUN-6A0007
      LET g_bwg.bwg00 = "L"
      LET g_bwg.bwg01 = g_bwd.bwd01  #料件編號
      LET g_bwg.bwg02 = g_bwd.bwd02  #生效日
      LET g_bwg.bwg03 = g_count      #序號
      LET g_bwg.bwg04 = g_bwd.bwd01
      LET g_bwg.bwg041= 1            #組合用量
      LET g_bwg.bwg05 = g_bwd.bwd03  #折合數量(庫存單位)
      LET xx = g_bwg.bwg00
      LET x2 = g_bwg.bwg01
      LET x3 = g_bwg.bwg02
      LET g_no = 0
      LET x_total= g_bwg.bwg05
 
      CALL p910_bom_3(0,g_bwd.bwd01,g_bwg.bwg02,g_bwg.bwg05)
 
      LET g_count = 0 
      LET g_bwg.bwg011 = g_yy     #FUN-6A0007
      LET g_bwg.bwg00 = "L"
      LET g_bwg.bwg01 = g_bwd.bwd01  #料件編號
      LET g_bwg.bwg02 = g_bwd.bwd02  #生效日
      LET g_bwg.bwg03 = g_count      #序號
      LET g_bwg.bwg04 = g_bwd.bwd01  #料件編號 
      LET g_bwg.bwg041= 1            #組合用量
      LET g_bwg.bwg05 = g_bwd.bwd03  #折合數量(庫存單位
 
      LET g_bwg.bwgplant = g_plant   #FUN-980001 add
      LET g_bwg.bwglegal = g_legal   #FUN-980001 add
 
      INSERT INTO bwg_file VALUES (g_bwg.*)
   END FOREACH 
      
   DECLARE selbwd02 CURSOR FOR SELECT * FROM bwd_file
                                WHERE bwd04 <> 0
                                  AND bwd011 = g_yy  #FUN-6A0007
                                ORDER BY bwd01,bwd02 
  
   FOREACH selbwd02 INTO g_bwd.*
      IF g_bgjob = "N" THEN                     #No.FUN-570115
         #No.MOD-580323 --start--                                                       
         CALL cl_getmsg('abx9118',g_lang) RETURNING l_str18                       
         CALL cl_getmsg('abx9117',g_lang) RETURNING l_str17                       
         MESSAGE l_str18,g_bwd.bwd01,l_str17,g_bwd.bwd02                          
         #No.MOD-580323 --end--      
      END IF                                    #No.FUN-570115
 
      LET g_count = 0 
      LET g_bwg.bwg011 = g_yy   #FUN-6A0007
      LET g_bwg.bwg00 = "F"
      LET g_bwg.bwg01 = g_bwd.bwd01
      LET g_bwg.bwg02 = g_bwd.bwd02
      LET g_bwg.bwg03 = g_count
      LET g_bwg.bwg04 = g_bwd.bwd01 
      LET g_bwg.bwg041= 1            #組合用量
      LET g_bwg.bwg05 = g_bwd.bwd04 
      LET xx = g_bwg.bwg00
      LET x2 = g_bwg.bwg01
      LET x3 = g_bwg.bwg02
      LET g_no = 0
      LET x_total= g_bwg.bwg05
 
      CALL p910_bom_3(0,g_bwd.bwd01,g_bwg.bwg02,g_bwg.bwg05)
 
      LET g_count = 0 
      LET g_bwg.bwg011 = g_yy   #FUN-6A0007
      LET g_bwg.bwg00 = "F"
      LET g_bwg.bwg01 = g_bwd.bwd01
      LET g_bwg.bwg02 = g_bwd.bwd02
      LET g_bwg.bwg03 = g_count
      LET g_bwg.bwg04 = g_bwd.bwd01 
      LET g_bwg.bwg041= 1            #組合用量
      LET g_bwg.bwg05 = g_bwd.bwd04 
 
      LET g_bwg.bwgplant = g_plant   #FUN-980001 add
      LET g_bwg.bwglegal = g_legal   #FUN-980001 add
 
      INSERT INTO bwg_file VALUES (g_bwg.*)
   END FOREACH 
 
   DECLARE selbwd03 CURSOR FOR SELECT * FROM bwd_file
                                WHERE bwd05 <> 0
                                  AND bwd011 = g_yy  #FUN-6A0007
                                ORDER BY bwd01,bwd02 
  
   FOREACH selbwd03 INTO g_bwd.*
      IF g_bgjob = "N" THEN                     #No.FUN-570115
         #No.MOD-580323 --start--                                                       
         CALL cl_getmsg('abx9119',g_lang) RETURNING l_str19                       
         CALL cl_getmsg('abx9117',g_lang) RETURNING l_str17                       
         MESSAGE l_str19,g_bwd.bwd01,l_str17,g_bwd.bwd02                          
         #No.MOD-580323 --end--            
      END IF                                    #No.FUN-570115
 
      LET g_count = 0 
      LET g_bwg.bwg011 = g_yy   #FUN-6A0007
      LET g_bwg.bwg00 = "S"
      LET g_bwg.bwg01 = g_bwd.bwd01
      LET g_bwg.bwg02 = g_bwd.bwd02
      LET g_bwg.bwg03 = g_count 
      LET g_bwg.bwg04 = g_bwd.bwd01 
      LET g_bwg.bwg041= 1            #組合用量
      LET g_bwg.bwg05 = g_bwd.bwd05 
      LET xx = g_bwg.bwg00
      LET x2 = g_bwg.bwg01
      LET x3 = g_bwg.bwg02
      LET g_no = 0
      LET x_total = g_bwg.bwg05
 
      CALL p910_bom_3(0,g_bwd.bwd01,g_bwg.bwg02,g_bwg.bwg05)
 
      LET g_count = 0 
      LET g_bwg.bwg011 = g_yy   #FUN-6A0007
      LET g_bwg.bwg00 = "S"
      LET g_bwg.bwg01 = g_bwd.bwd01
      LET g_bwg.bwg02 = g_bwd.bwd02
      LET g_bwg.bwg03 = g_count 
      LET g_bwg.bwg04 = g_bwd.bwd01 
      LET g_bwg.bwg041= 1            #組合用量
      LET g_bwg.bwg05 = g_bwd.bwd05 
 
      LET g_bwg.bwgplant = g_plant   #FUN-980001 add
      LET g_bwg.bwglegal = g_legal   #FUN-980001 add
 
      INSERT INTO bwg_file VALUES (g_bwg.*)
   END FOREACH 
 
   DECLARE selbwd04 CURSOR FOR SELECT * FROM bwd_file
                                WHERE bwd06 <> 0
                                  AND bwd011 = g_yy  #FUN-6A0007
                                ORDER BY bwd01,bwd02 
   
   FOREACH selbwd04 INTO g_bwd.*
      IF g_bgjob = "N" THEN                     #No.FUN-570115
         #No.MOD-580323 --start--                                                       
         CALL cl_getmsg('abx9120',g_lang) RETURNING l_str20                       
         CALL cl_getmsg('abx9117',g_lang) RETURNING l_str17                       
         MESSAGE l_str20,g_bwd.bwd01,l_str17,g_bwd.bwd02                          
         #No.MOD-580323 --end--                
      END IF                                    #No.FUN-570115
 
      LET g_count = 0 
      LET g_bwg.bwg011 = g_yy   #FUN-6A0007
      LET g_bwg.bwg00 = "T"
      LET g_bwg.bwg01 = g_bwd.bwd01
      LET g_bwg.bwg02 = g_bwd.bwd02
      LET g_bwg.bwg03 = g_count 
      LET g_bwg.bwg04 = g_bwd.bwd01 
      LET g_bwg.bwg041= 1            #組合用量
      LET g_bwg.bwg05 = g_bwd.bwd06 
      LET xx = g_bwg.bwg00
      LET x2 = g_bwg.bwg01
      LET x3 = g_bwg.bwg02
      LET g_no = 0
      LET x_total = g_bwg.bwg05
 
      CALL p910_bom_3(0,g_bwd.bwd01,g_bwg.bwg02,g_bwg.bwg05)
 
      LET g_count = 0 
      LET g_bwg.bwg011 = g_yy   #FUN-6A0007
      LET g_bwg.bwg00 = "T"
      LET g_bwg.bwg01 = g_bwd.bwd01
      LET g_bwg.bwg02 = g_bwd.bwd02
      LET g_bwg.bwg03 = g_count 
      LET g_bwg.bwg04 = g_bwd.bwd01 
      LET g_bwg.bwg041= 1            #組合用量
      LET g_bwg.bwg05 = g_bwd.bwd06 
 
      LET g_bwg.bwgplant = g_plant   #FUN-980001 add
      LET g_bwg.bwglegal = g_legal   #FUN-980001 add
 
      INSERT INTO bwg_file VALUES (g_bwg.*)
   END FOREACH 
 
END FUNCTION
 
FUNCTION p910_7()
  #DEFINE g_bwh     RECORD LIKE bwh_file.*   #MOD-C10032 mark
   DEFINE g_bxi08   LIKE bxi_file.bxi08 
   DEFINE g_bxj04   LIKE bxj_file.bxj04
   DEFINE g_bxj06   LIKE bxj_file.bxj06
   DEFINE qty0,qty1,qty2,qty3,qty4,qty5  LIKE bwh_file.bwh11    #No.FUN-680062   decimal(15,3) 
   DEFINE l_ima20   LIKE ima_file.ima20
   DEFINE g_bwg00   LIKE bwg_file.bwg00
   DEFINE g_bwg04   LIKE bwg_file.bwg04
   DEFINE g_bwg05   LIKE bwg_file.bwg05
   DEFINE g_bwe03   LIKE bwe_file.bwe03 
   DEFINE g_bwe04   LIKE bwe_file.bwe04 
   DEFINE l_str21   STRING   #No.MOD-580323                                       
   DEFINE l_str22   STRING   #No.MOD-580323                                       
   DEFINE l_str23   STRING   #No.MOD-580323                                       
   DEFINE l_str24   STRING   #No.MOD-580323                                       
   DEFINE l_str25   STRING   #No.MOD-580323                                       
   DEFINE l_str26   STRING   #No.MOD-580323                                       
   DEFINE l_str27   STRING   #No.MOD-580323                                       
   DEFINE l_str28   STRING   #No.MOD-580323
 
  #LET g_begin = MDY(1,1,g_yy)     #No.MOD-5B0036 Mark
  #LET g_end   = MDY(12,31,g_yy)   #No.MOD-5B0036 Mark
 
   IF g_bgjob = "N" THEN                     #No.FUN-570115
      #No.MOD-580323 --start--                                                       
      CALL cl_getmsg('abx9121',g_lang) RETURNING l_str21                          
      MESSAGE l_str21                                                             
   END IF                                    #No.FUN-570115
 
   #1.UPDATE bwh05(本期保稅進貨數),bwh06(本期非保蛻進貨數)                     
   UPDATE bwh_file SET bwh05 = 0,
                       bwh06 = 0,
                       bwh07 = 0,
                       bwh08 = 0,                
                       bwh09 = 0,
                       bwh10 = 0,
                       bwh11 = 0,
                       bwh12 = 0,                
                       bwh13 = 0,
                       bwh14 = 0,
                       bwh15 = 0,
                       bwh16 = 0                 
    WHERE bwh01 = g_yy                                                          
                                                                                
   IF g_bgjob = "N" THEN                     #No.FUN-570115
      CALL cl_getmsg('abx9122',g_lang) RETURNING l_str22                            
      MESSAGE l_str22                                                               
      #No.MOD-580323 --end--             
   END IF                                    #No.FUN-570115
 
 #FUN-6A0007 (S)原用保稅單據維護(abxt800)單頭保稅異動原因代碼(bxi08)
 #改用單身折合原因代碼(bxj21)去折合
 {
   DECLARE p910_7_c CURSOR FOR SELECT bxj04,bxi08,SUM(bxj06)
                                 FROM bxj_file,bxi_file,bxr_file
                                WHERE bxj01 = bxi01
                                  AND bxi08 = bxr01
                                  AND bxi02 BETWEEN g_begin AND g_end
                                  AND (bxr11 != 0 OR bxr12 != 0 OR bxr13 !=0)
                                GROUP BY bxj04,bxi08
 
   FOREACH p910_7_c INTO g_bxj04,g_bxi08,g_bxj06
  }
   DECLARE p910_7_c CURSOR FOR SELECT bxj04,bxj21,bxi06,SUM(bxj06)
                                 FROM bxj_file, bxi_file, bxr_file
                                WHERE bxj01=bxi01 AND bxj21=bxr01
                                  AND bxi02 between g_begin and g_end
                                  AND (bxr11 != 0 OR bxr12 != 0 OR bxr13 !=0)
                             GROUP BY bxj04,bxj21,bxi06
 
   FOREACH p910_7_c into g_bxj04,g_bxi08,g_bxi06,g_bxj06
      IF g_bxi06 = '2' THEN  #出庫時以負值表示
         LET g_bxj06 = g_bxj06 * (-1)
      END IF
 #FUN-6A0007 (E)-------------------------------------------------
 
      SELECT * INTO g_bxr.* FROM bxr_file WHERE bxr01 = g_bxi08 
 
      CASE 
         WHEN g_bxr.bxr11 <> 0 OR g_bxr.bxr12 <> 0
            IF g_bxr.bxr11 <> 0 THEN
               LET g_bxj06 = g_bxj06 * g_bxr.bxr11
            ELSE 
               LET g_bxj06 = g_bxj06 * g_bxr.bxr12
            END IF
 
            UPDATE bwh_file SET bwh05 = bwh05 + g_bxj06
             WHERE bwh01 =g_yy
               AND bwh02 =g_bxj04 
            IF SQLCA.SQLERRD[3] = 0 THEN
               INITIALIZE g_bwh.* TO NULL
               LET g_bwh.bwh03 = 0
               LET g_bwh.bwh04 = 0
               LET g_bwh.bwh05 = 0
               LET g_bwh.bwh06 = 0
               LET g_bwh.bwh07 = 0
               LET g_bwh.bwh08 = 0
               LET g_bwh.bwh09 = 0
               LET g_bwh.bwh10 = 0
               LET g_bwh.bwh11 = 0
               LET g_bwh.bwh12 = 0
               LET g_bwh.bwh13 = 0
               LET g_bwh.bwh14 = 0
               LET g_bwh.bwh15 = 0
               LET g_bwh.bwh16 = 0
               LET g_bwh.bwh01 = g_yy
               LET g_bwh.bwh02 = g_bxj04 
               LET g_bwh.bwh05 = g_bxj06 
 
               LET g_bwh.bwhplant = g_plant   #FUN-980001 add
               LET g_bwh.bwhlegal = g_legal   #FUN-980001 add
 
               INSERT INTO bwh_file VALUES(g_bwh.*)
            END IF
         WHEN g_bxr.bxr13 <> 0
            LET g_bxj06 = g_bxj06 * g_bxr.bxr13
 
            UPDATE bwh_file SET bwh06 = bwh06 + g_bxj06
             WHERE bwh01 =g_yy
               AND bwh02 =g_bxj04 
            IF SQLCA.SQLERRD[3] = 0 THEN
               INITIALIZE g_bwh.* TO NULL
               LET g_bwh.bwh03 = 0
               LET g_bwh.bwh04 = 0
               LET g_bwh.bwh05 = 0
               LET g_bwh.bwh06 = 0
               LET g_bwh.bwh07 = 0
               LET g_bwh.bwh08 = 0
               LET g_bwh.bwh09 = 0
               LET g_bwh.bwh10 = 0
               LET g_bwh.bwh11 = 0
               LET g_bwh.bwh12 = 0
               LET g_bwh.bwh13 = 0
               LET g_bwh.bwh14 = 0
               LET g_bwh.bwh15 = 0
               LET g_bwh.bwh16 = 0
               LET g_bwh.bwh01 = g_yy
               LET g_bwh.bwh02 = g_bxj04 
               LET g_bwh.bwh06 = g_bxj06
 
               LET g_bwh.bwhplant = g_plant   #FUN-980001 add
               LET g_bwh.bwhlegal = g_legal   #FUN-980001 add
 
               INSERT INTO bwh_file VALUES(g_bwh.*)
            END IF
      END CASE 
   END FOREACH 
 
   IF g_bgjob = "N" THEN                     #No.FUN-570115
      #No.MOD-580323 --start--                                                       
      CALL cl_getmsg('abx9123',g_lang) RETURNING l_str23                            
      MESSAGE l_str23                                                               
      #No.MOD-580323 --end--      
   END IF                                    #No.FUN-570115
 
   DECLARE selbwg CURSOR FOR SELECT bwg00,bwg04,sum(bwg05) FROM bwg_file
                              WHERE bwg011 = g_yy   #FUN-6A0007
                              GROUP BY bwg00,bwg04 
 
   FOREACH selbwg INTO g_bwg00,g_bwg04,g_bwg05
      CASE 
         WHEN g_bwg00 = "L" #內銷
            UPDATE bwh_file SET bwh08 = bwh08 + g_bwg05
             WHERE bwh01 =g_yy
               AND bwh02 =g_bwg04 
 
            IF SQLCA.SQLERRD[3]=0 THEN
               INITIALIZE g_bwh.* TO NULL
               LET g_bwh.bwh03 = 0
               LET g_bwh.bwh04 = 0
               LET g_bwh.bwh05 = 0
               LET g_bwh.bwh06 = 0
               LET g_bwh.bwh07 = 0
               LET g_bwh.bwh08 = 0
               LET g_bwh.bwh09 = 0
               LET g_bwh.bwh10 = 0
               LET g_bwh.bwh11 = 0
               LET g_bwh.bwh12 = 0
               LET g_bwh.bwh13 = 0
               LET g_bwh.bwh14 = 0
               LET g_bwh.bwh15 = 0
               LET g_bwh.bwh16 = 0
               LET g_bwh.bwh01 = g_yy
               LET g_bwh.bwh02 = g_bwg04 
               LET g_bwh.bwh08 = g_bwg05 
 
               LET g_bwh.bwhplant = g_plant   #FUN-980001 add
               LET g_bwh.bwhlegal = g_legal   #FUN-980001 add
 
               INSERT INTO bwh_file values (g_bwh.*)
            END IF 
         WHEN g_bwg00 = "F" #外銷
            UPDATE bwh_file SET bwh07 = bwh07 + g_bwg05
             WHERE bwh01 =g_yy
               AND bwh02 =g_bwg04 
            IF SQLCA.SQLERRD[3]=0 THEN
               INITIALIZE g_bwh.* TO NULL
               LET g_bwh.bwh03 = 0
               LET g_bwh.bwh04 = 0
               LET g_bwh.bwh05 = 0
               LET g_bwh.bwh06 = 0
               LET g_bwh.bwh07 = 0
               LET g_bwh.bwh08 = 0
               LET g_bwh.bwh09 = 0
               LET g_bwh.bwh10 = 0
               LET g_bwh.bwh11 = 0
               LET g_bwh.bwh12 = 0
               LET g_bwh.bwh13 = 0
               LET g_bwh.bwh14 = 0
               LET g_bwh.bwh15 = 0
               LET g_bwh.bwh16 = 0
               LET g_bwh.bwh01 = g_yy
               LET g_bwh.bwh02 = g_bwg04 
               LET g_bwh.bwh07 = g_bwg05
 
               LET g_bwh.bwhplant = g_plant   #FUN-980001 add
               LET g_bwh.bwhlegal = g_legal   #FUN-980001 add
 
               INSERT INTO bwh_file values (g_bwh.*)
            END IF 
         WHEN g_bwg00 = "S" #報廢
            UPDATE bwh_file SET bwh10 = bwh10 + g_bwg05
             WHERE bwh01 =g_yy
               AND bwh02 =g_bwg04 
            IF SQLCA.SQLERRD[3]=0 THEN
               INITIALIZE g_bwh.* TO NULL
               LET g_bwh.bwh03 = 0
               LET g_bwh.bwh04 = 0
               LET g_bwh.bwh05 = 0
               LET g_bwh.bwh06 = 0
               LET g_bwh.bwh07 = 0
               LET g_bwh.bwh08 = 0
               LET g_bwh.bwh09 = 0
               LET g_bwh.bwh10 = 0
               LET g_bwh.bwh11 = 0
               LET g_bwh.bwh12 = 0
               LET g_bwh.bwh13 = 0
               LET g_bwh.bwh14 = 0
               LET g_bwh.bwh15 = 0
               LET g_bwh.bwh16 = 0
               LET g_bwh.bwh01 = g_yy
               LET g_bwh.bwh02 = g_bwg04 
               LET g_bwh.bwh10 = g_bwg05
 
               LET g_bwh.bwhplant = g_plant   #FUN-980001 add
               LET g_bwh.bwhlegal = g_legal   #FUN-980001 add
 
               INSERT INTO bwh_file values (g_bwh.*)
            END IF 
         WHEN g_bwg00 = "T" #外運
            UPDATE bwh_file SET bwh09 = bwh09 + g_bwg05
             WHERE bwh01 =g_yy
               AND bwh02 =g_bwg04 
            IF SQLCA.SQLERRD[3]=0 THEN
               INITIALIZE g_bwh.* TO NULL
               LET g_bwh.bwh03 = 0
               LET g_bwh.bwh04 = 0
               LET g_bwh.bwh05 = 0
               LET g_bwh.bwh06 = 0
               LET g_bwh.bwh07 = 0
               LET g_bwh.bwh08 = 0
               LET g_bwh.bwh09 = 0
               LET g_bwh.bwh10 = 0
               LET g_bwh.bwh11 = 0
               LET g_bwh.bwh12 = 0
               LET g_bwh.bwh13 = 0
               LET g_bwh.bwh14 = 0
               LET g_bwh.bwh15 = 0
               LET g_bwh.bwh16 = 0
               LET g_bwh.bwh01 = g_yy
               LET g_bwh.bwh02 = g_bwg04 
               LET g_bwh.bwh09 = g_bwg05
 
               LET g_bwh.bwhplant = g_plant   #FUN-980001 add
               LET g_bwh.bwhlegal = g_legal   #FUN-980001 add
 
               INSERT INTO bwh_file values (g_bwh.*)
            END IF 
         END CASE
   END FOREACH 
 
   DECLARE selbwe CURSOR FOR SELECT bwe03,SUM(bwe04) FROM bwe_file 
                              WHERE bwe011 = g_yy  #FUN-6A0007
                              GROUP BY bwe03
 
   FOREACH selbwe INTO g_bwe03,g_bwe04
      IF g_bgjob = "N" THEN                     #No.FUN-570115
         #No.MOD-580323 --start--                                                       
         CALL cl_getmsg('abx9124',g_lang) RETURNING l_str24                            
         MESSAGE l_str24,g_bwe03," ",g_bwe04                                           
         #No.MOD-580323 --end--         
      END IF                                    #No.FUN-570115
 
      UPDATE bwh_file SET bwh11 = bwh11 + g_bwe04
       WHERE bwh01 =g_yy
         AND bwh02 =g_bwe03 
      IF SQLCA.SQLERRD[3]=0 THEN
         INITIALIZE g_bwh.* TO NULL
         LET g_bwh.bwh03 = 0
         LET g_bwh.bwh04 = 0
         LET g_bwh.bwh05 = 0
         LET g_bwh.bwh06 = 0
         LET g_bwh.bwh07 = 0
         LET g_bwh.bwh08 = 0
         LET g_bwh.bwh09 = 0
         LET g_bwh.bwh10 = 0
         LET g_bwh.bwh11 = 0
         LET g_bwh.bwh12 = 0
         LET g_bwh.bwh13 = 0
         LET g_bwh.bwh14 = 0
         LET g_bwh.bwh15 = 0
         LET g_bwh.bwh16 = 0
         LET g_bwh.bwh01 = g_yy
         LET g_bwh.bwh02 = g_bwe03 
         LET g_bwh.bwh11 = g_bwe04
 
         LET g_bwh.bwhplant = g_plant   #FUN-980001 add
         LET g_bwh.bwhlegal = g_legal   #FUN-980001 add
 
         INSERT INTO bwh_file values (g_bwh.*)
      END IF
   END FOREACH 
 
   DECLARE selbwhxx CURSOR FOR SELECT * FROM bwh_file
                                WHERE bwh01 = g_yy
 
   FOREACH selbwhxx INTO g_bwh.*
      IF g_bgjob = "N" THEN                     #No.FUN-570115
         #No.MOD-580323 --start--                                                       
         CALL cl_getmsg('abx9125',g_lang) RETURNING l_str25                            
         MESSAGE l_str25                                                               
         #No.MOD-580323 --end--             
      END IF                                    #No.FUN-570115
 
      LET qty0 = 0  
      LET qty1 = 0  #本期盤虧盈數
      LET qty2 = 0  #盤差容許率
      LET qty3 = 0  #本期盤差補稅數
      LET qty4 = 0  #結轉下期保稅數
      LET qty5 = 0  #結轉下期非保稅數
      LET qty0 = g_bwh.bwh03 + g_bwh.bwh04 + g_bwh.bwh05 + g_bwh.bwh06-
                 g_bwh.bwh07 - g_bwh.bwh08 - g_bwh.bwh09 - g_bwh.bwh10
 
      IF cl_null(qty0) THEN
         LET qty0 = 0
      END IF
 
     #FUN-6A0007 (S)-----------
     #LET qty1 = qty0 - g_bwh.bwh11 
      LET qty1 = g_bwh.bwh11 - qty0
     #FUN-6A0007 (E)-----------
 
      IF cl_null(qty1) THEN
         LET qty1 = 0
      END IF
 
      SELECT ima20 INTO l_ima20 
        FROM ima_file
       WHERE ima01 = g_bwh.bwh02 #容許率  
 
      IF cl_null(l_ima20) THEN
         LET l_ima20 = 0 
      END IF
 
      IF qty1 < 0 THEN  #盤虧 
         #NO:4049盤差容許數=(本期外銷使用數+本期內銷使用數)*容許率
         LET qty2 = ((g_bwh.bwh07+g_bwh.bwh08) * l_ima20)/100  #盤差容許數
 
         IF g_bgjob = "N" THEN                     #No.FUN-570115
            #No.MOD-580323 --start--                                                       
            CALL cl_getmsg('abx9126',g_lang) RETURNING l_str26                    
            MESSAGE l_str26,g_bwh.bwh02 CLIPPED," ",qty2                          
         END IF                                    #No.FUN-570115
 
         IF cl_null(qty2) THEN
            LET qty2 = 0
         END IF                             
 
         LET qty3 = (qty1*(-1))-(g_bwh.bwh03+g_bwh.bwh04)-qty2  #NO:4049       
 
         IF qty3 < 0 THEN
            LET qty3 = 0
         END IF                                      
                                                                                
         IF g_bgjob = "N" THEN                     #No.FUN-570115
            CALL cl_getmsg('abx9127',g_lang) RETURNING l_str27                        
            MESSAGE l_str27 ,qty3                                                     
            #No.MOD-580323 --end--                              
         END IF                                    #No.FUN-570115
         #應補稅數=盤虧數-(上期非保數+上其保數)-盤差容許數       
      END IF
 
     #FUN-6A0007 (S) qty4、qty5計算公式修改--------------------------
     {
      IF (g_bwh.bwh07+g_bwh.bwh08+g_bwh.bwh09+g_bwh.bwh10) >=
         (g_bwh.bwh03+g_bwh.bwh05) THEN
         LET qty4 = 0
         LET qty5 = g_bwh.bwh11
      END IF
 
      IF (g_bwh.bwh07+g_bwh.bwh08+g_bwh.bwh09+g_bwh.bwh10) <
         (g_bwh.bwh03+g_bwh.bwh05) THEN
         IF ((g_bwh.bwh03+g_bwh.bwh05)-
            (g_bwh.bwh07+g_bwh.bwh08+g_bwh.bwh09+g_bwh.bwh10)) >= g_bwh.bwh11 THEN
            LET qty4 = g_bwh.bwh11
            LET qty5 = 0
         ELSE 
            LET qty4 = (g_bwh.bwh03+g_bwh.bwh05)- 
                       (g_bwh.bwh07+g_bwh.bwh08+g_bwh.bwh09+g_bwh.bwh10)
            LET qty5 = g_bwh.bwh11-qty4
         END IF
      END IF
     }
      IF (g_bwh.bwh04+g_bwh.bwh06=0) THEN
         LET qty4 = g_bwh.bwh11
         LET qty5 = 0
      ELSE
         IF g_bwh.bwh11>=(g_bwh.bwh03+g_bwh.bwh04+g_bwh.bwh05+g_bwh.bwh06
                          -g_bwh.bwh07-g_bwh.bwh08-g_bwh.bwh09-g_bwh.bwh10) THEN
            IF (g_bwh.bwh07+g_bwh.bwh08+g_bwh.bwh09+g_bwh.bwh10) <
               (g_bwh.bwh03+g_bwh.bwh05)  THEN
               LET qty4 = g_bwh.bwh11-g_bwh.bwh04-g_bwh.bwh06
               LET qty5 = g_bwh.bwh04+g_bwh.bwh06
            ELSE
               IF (g_bwh.bwh11) <= (g_bwh.bwh04+g_bwh.bwh06) THEN
                  LET qty4 = 0
                  LET qty5 = g_bwh.bwh11
               ELSE
                  LET qty4 = g_bwh.bwh11-g_bwh.bwh04-g_bwh.bwh06
                  LET qty5 = g_bwh.bwh04+g_bwh.bwh06
               END IF
            END IF
          ELSE
            IF (g_bwh.bwh07+g_bwh.bwh08+g_bwh.bwh09+g_bwh.bwh10) >=
               (g_bwh.bwh03+g_bwh.bwh05) THEN
               LET qty4 = 0
               LET qty5 = g_bwh.bwh11
            ELSE
               IF ((g_bwh.bwh03+g_bwh.bwh05)-
                   (g_bwh.bwh07+g_bwh.bwh08+g_bwh.bwh09+g_bwh.bwh10))
                    >= g_bwh.bwh11
               THEN
                   LET qty4 = g_bwh.bwh11
                   LET qty5 = 0
               ELSE
                   LET qty4 =(g_bwh.bwh03+g_bwh.bwh05)-
                             (g_bwh.bwh07+g_bwh.bwh08+g_bwh.bwh09+g_bwh.bwh10)
                   LET qty5 = g_bwh.bwh11-qty4
               END IF
            END IF
         END IF
      END IF
     #FUN-6A0007 (E) qty4、qty5計算公式修改--------------------------
 
      IF g_bgjob = "N" THEN                     #No.FUN-570115
         #No.MOD-580323 --start--                                                       
         CALL cl_getmsg('abx9128',g_lang) RETURNING l_str28                        
         MESSAGE l_str28,g_bwh.bwh02                                               
         #No.MOD-580323 --end--    
      END IF                                    #No.FUN-570115
 
      UPDATE bwh_file SET bwh12 = qty1,
                          bwh13 = qty2,
                          bwh14 = qty3,
                          bwh15 = qty4,
                          bwh16 = qty5
       WHERE bwh01 = g_yy
         AND bwh02 = g_bwh.bwh02
       #FUN-6A0007 (S)--------------
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('upd bwh_file:7-4',STATUS,1)
       END IF
       #FUN-6A0007 (E)--------------
   END FOREACH  
 
END FUNCTION
 
#FUNCTION p910_bom(p_level,p_key,p_total)
FUNCTION p910_bom(p_level,p_key,p_total,p_bwe031)   #FUN-6A0007
   DEFINE p_level   LIKE type_file.num5,       #No.FUN-680062   smallint 
          l_cmd     LIKE type_file.chr1000,    #No.FUN-680062  VARCHAR(600)   
          p_key     LIKE bma_file.bma01,  #主件料件編號
          p_total   LIKE bwe_file.bwe04,
          p_bwe01   LIKE bwe_file.bwe01,
          p_ln      LIKE type_file.num5,       #No.FUN-680062    smallint
          l_ac,i    LIKE type_file.num5,       #No.FUN-680062    smallint
          l_ima106  LIKE ima_file.ima106,
          xbwe031   LIKE bwe_file.bwe031,
          arrno     LIKE type_file.num5,     #BUFFER SIZE (可存筆數)  #No.FUN-680062    smallint
          l_chr     LIKE type_file.chr1,     #No.FUN-680062    VARCHAR(1)
          sr        DYNAMIC ARRAY OF RECORD           #每階存放資料
                       level       LIKE type_file.num5,        #No.FUN-680062    smallint
                       bmb02 LIKE bmb_file.bmb02,    #項次
                       bmb03 LIKE bmb_file.bmb03,    #元件料號
                       bmb06 LIKE bmb_file.bmb06,    #QPA/BASE #FUN-560231
                       bmb13 LIKE bmb_file.bmb13,    #插件位置
                       bma01 LIKE bma_file.bma01     #NO.MOD-490217
                    END RECORD 
   DEFINE l_str29,l_str30 STRING #No.MOD-580323
   DEFINE p_bwe031 LIKE bwe_file.bwe031     #FUN-6A0007
 
   IF p_level > 20 THEN 
      CALL cl_err('','mfg2733',1)
      CALL cl_batch_bg_javamail("N")  #No.FUN-570115
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   LET p_level = p_level + 1
   LET arrno = 600                        #95/12/21 Modify By Lynn
 
  #FUN-6A0007--(S)---------------------------------------------
  #生效日判斷改成單頭之生效日(bnd02)，失效日判斷改成單頭之失效日(bnd03)
  {
   LET l_cmd= "SELECT 0, bne03, bne05, bne08, ' ', bnd01",
              "  FROM bne_file, bnd_file",
              " WHERE bnd01='", p_key,"' AND bne01 = bnd01 ",
              "   AND bne06 <='", g_today,"'",   #NO:4049
              "   AND (bne07 > '", g_today,"'",
              "    OR bne07 IS NULL ) ",
              "   AND bnd02=bne02 AND bne09='Y' " 
  }
   LET l_cmd= "SELECT 0, bne03, bne05, bne08, ' ', bnd01",
              "  FROM bne_file, bnd_file",
              " WHERE bnd01='", p_key,"' AND bne01 = bnd01 ",
              " AND  (bnd02 <='",g_end,"' OR bnd02 IS NULL) ",
              " AND  (bnd03 > '",g_end,"' OR bnd03 IS NULL) ",
              "   AND bnd02=bne02 AND bne09='Y' " 
  #FUN-6A0007--(E)---------------------------------------------
   #---->生效日及失效日的判斷
 
   LET l_cmd = l_cmd CLIPPED, ' ORDER BY bne03'
 
   PREPARE xxx FROM l_cmd
   DECLARE p830_cur CURSOR FOR xxx      
   IF SQLCA.sqlcode THEN 
      CALL cl_err('P1:',STATUS,1)
      CALL cl_batch_bg_javamail("N")  #No.FUN-570115
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   LET l_ac = 1
 
   FOREACH p830_cur INTO sr[l_ac].*        # 先將BOM單身存入BUFFER
      LET l_ac = l_ac + 1
      IF l_ac > arrno THEN
         EXIT FOREACH 
      END IF
   END FOREACH
 
   FOR i = 1 TO l_ac-1                            # 讀BUFFER傳給REPORT
      LET p_ln = p_ln + 1
      LET sr[i].level = p_level
     #FUN-6A0007 Mark(S)-----------------
     {
      LET xbwe031 = 0
 
      SELECT bwe031 INTO xbwe031 FROM bwe_file 
       WHERE bwe00 = bwe.bwe00
         AND bwe01 = bwe.bwe01
         AND bwe03 = sr[i].bma01
 
      IF xbwe031<=0 or cl_null(xbwe031) THEN
         LET xbwe031 = 1
      END IF
 
      LET sr[i].bmb06=sr[i].bmb06*xbwe031
     }
     #FUN-6A0007 Mark(E)-----------------
      LET sr[i].bmb06=sr[i].bmb06*p_bwe031   #FUN-6A0007
      LET bwe.bwe04 = x_total*sr[i].bmb06
      LET bwe.bwe031=sr[i].bmb06
     #SELECT ima106 INTO l_ima106 FROM ima_file WHERE ima01 = sr[i].bmb03  
      SELECT ima106 INTO l_ima106 FROM ima_file WHERE ima01 = p_key  #No.MOD-5B0036
 
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM bnd_file
       WHERE bnd01=sr[i].bmb03 
         AND (bnd02 <=g_end OR bnd02 IS NULL)
         AND (bnd03 > g_end OR bnd03 IS NULL)
 
      IF l_n > 0 THEN
         LET g_no = g_no + 1
        #FUN-6A0007 (S)----------
        #LET bwe.bwe02 = g_no
         IF bwe.bwe00 = 'S' THEN
         LET bwe.bwe02 = g_no
         ELSE
            LET bwe.bwe02 = bwc.bwc02
         END IF
        #FUN-6A0007 (E)----------
         LET bwe.bwe03 = sr[i].bmb03
        #SELECT ima106 INTO bwe.bwe05 FROM ima_file   #No.MOD-5B0036 Mark
        #WHERE ima01 = bwe.bwe03
         LET bwe.bwe05 = g_ima106  #FUN-6A0007 LET最上階開始展BOM料號的
 
         LET bwe.bwe011 = g_yy  #FUN-6A0007
 
         LET bwe.bweplant = g_plant   #FUN-980001 add
         LET bwe.bwelegal = g_legal   #FUN-980001 add
 
         INSERT INTO bwe_file VALUES (bwe.*)
         IF SQLCA.SQLCODE <> 0 THEN
            #UPDATE bme_file SET bme04 = bme04 + bwe.bwe04
             UPDATE bwe_file SET bwe04 = bwe04 + bwe.bwe04  #FUN-6A0007
             WHERE bwe00 = bwe.bwe00
               AND bwe01 = bwe.bwe01
               AND bwe02 = bwe.bwe02
               AND bwe03 = bwe.bwe03
               AND bwe011 = bwe.bwe011   #FUN-6A0007
         END IF
 
        #FUN-6A0007 (S)----------------------
        #CALL p910_bom(p_level,sr[i].bmb03,bwe.bwe04)
         CALL p910_bom(p_level,sr[i].bmb03,bwe.bwe04,sr[i].bmb06*p_bwe031)
        #FUN-6A0007 (E)----------------------
      ELSE
         IF g_bgjob = "N" THEN                     #No.FUN-570115
            #No.MOD-580323 --start--                                                       
            CALL cl_getmsg('abx9129',g_lang) RETURNING l_str29                  
            CALL cl_getmsg('abx9130',g_lang) RETURNING l_str30                  
            MESSAGE l_str29,p_key clipped,l_str30,bwe.bwe03                     
            #No.MOD-580323 --end--       
         END IF                                    #No.FUN-570115
 
         LET g_no = g_no + 1
        #FUN-6A0007 (S)----------
        #LET bwe.bwe02 = g_no
         IF bwe.bwe00 = 'S' THEN
         LET bwe.bwe02 = g_no
         ELSE
            LET bwe.bwe02 = bwc.bwc02
         END IF
        #FUN-6A0007 (E)----------
         LET bwe.bwe03 = sr[i].bmb03
       # SELECT ima106 INTO bwe.bwe05 FROM ima_file  #No.MOD-5B0036 Mark
       # WHERE ima01 = bwe.bwe03
         LET bwe.bwe05 = g_ima106  #FUN-6A0007 LET最上階開始展BOM料號的
 
         LET bwe.bwe011 = g_yy   #FUN-6A0007
 
         LET bwe.bweplant = g_plant   #FUN-980001 add
         LET bwe.bwelegal = g_legal   #FUN-980001 add
 
         INSERT INTO bwe_file VALUES (bwe.*)
         IF SQLCA.SQLCODE <> 0 THEN
           #UPDATE bme_file SET bme04 = bme04 + bwe.bwe04
            UPDATE bwe_file SET bwe04 = bwe04 + bwe.bwe04  #FUN-6A0007
             WHERE bwe00 = bwe.bwe00
               AND bwe01 = bwe.bwe01
               AND bwe02 = bwe.bwe02
               AND bwe03 = bwe.bwe03
               AND bwe011 = bwe.bwe011   #FUN-6A0007
         END IF
      END IF
   END FOR
 
END FUNCTION
 
FUNCTION p910_bom_3(p_level,p_key,p_date,p_total)
   DEFINE p_level   LIKE type_file.num5,                 #No.FUN-680062    smallint
          l_cmd     LIKE type_file.chr1000,              #No.FUN-680062    VARCHAR(1000)
          g_bwg     RECORD LIKE bwg_file.*,
          p_key     LIKE bma_file.bma01,       #主件料件編號
          p_date    LIKE bnd_file.bnd02,
          p_total   LIKE bmb_file.bmb06,       #FUN-560231
          p_flag    LIKE type_file.chr1,       #No.FUN-680062    VARCHAR(1)
          p_ln,l_n  LIKE type_file.num5,       #No.FUN-680062    smallint
          l_ac,i    LIKE type_file.num5,       #No.FUN-680062    smallint
          xbwg041   LIKE bwg_file.bwg041,
          l_ima106  LIKE ima_file.ima106,
          arrno     LIKE type_file.num5,          #BUFFER SIZE (可存筆數)  #No.FUN-680062    smalilnt
          l_chr     LIKE type_file.chr1,          #No.FUN-680062    VARCHAR(1)
          sr        DYNAMIC ARRAY OF RECORD           #每階存放資料
                       level LIKE type_file.num5,     #No.FUN-680062    smallint
                       bmb02 LIKE bmb_file.bmb02,     #項次
                       bmb03 LIKE bmb_file.bmb03,     #元件料號
                       bmb06 LIKE bmb_file.bmb06,     #QPA/BASE #FUN-560231
                       bmb13 LIKE bmb_file.bmb13,     #插件位置
                       bnd02 LIKE bnd_file.bnd02,     #生效日
                       bma01 LIKE bma_file.bma01      #NO.MOD-490217
                    END RECORD 
   DEFINE l_str31,l_str32 STRING   #No.MOD-580323  
 
   IF p_level > 20 THEN 
      CALL cl_err('','mfg2733',1)
      CALL cl_batch_bg_javamail("N")           #No.FUN-570115
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   LET p_level = p_level + 1
   LET arrno = 600                        #95/12/21 Modify By Lynn
   LET l_cmd= "SELECT 0, bne03, bne05, bne08, ' ',bnd02,bnd01",
              "  FROM bne_file, bnd_file",
              " WHERE bnd01='", p_key,"' AND bne01 = bnd01 ",
            # " AND   bnd02<='", p_date,"'",
              " AND  (bnd02<='", p_date,"' OR bnd02 IS NULL) ",  ##FUN-6A0007
              " AND  ( bnd03 > '", p_date,"'",  #NO:4049
              "  OR   bnd03  IS NULL) ",
              " AND   bnd02=bne02 AND bne09='Y' " 
   #---->生效日及失效日的判斷
 
   LET l_cmd = l_cmd CLIPPED, ' ORDER BY bne03'
 
   PREPARE yyy FROM l_cmd
   DECLARE p830_cur_xx CURSOR FOR yyy      
   IF SQLCA.sqlcode THEN 
      CALL cl_err('P1:',STATUS,1) 
      CALL cl_batch_bg_javamail("N")           #No.FUN-570115
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
   END IF
 
   LET l_ac = 1
 
   FOREACH p830_cur_xx INTO sr[l_ac].*        # 先將BOM單身存入BUFFER
      LET l_ac = l_ac + 1
      IF l_ac > arrno THEN 
         EXIT FOREACH 
      END IF
   END FOREACH
 
   FOR i = 1 TO l_ac-1                            # 讀BUFFER傳給REPORT
      LET p_ln = p_ln + 1
      LET sr[i].level = p_level
      LET xbwg041 = 0
 
      DECLARE selbwg041 CURSOR FOR SELECT bwg041 FROM bwg_file 
                                    WHERE bwg00 = xx
                                      AND bwg04 = sr[i].bma01
                                      AND bwg02 >= sr[i].bnd02
                                      AND bwg011 = g_yy   #FUN-6A0007
 
      FOREACH selbwg041 INTO xbwg041 
         EXIT FOREACH 
      END FOREACH         
 
      IF (xbwg041<=0 or cl_null(xbwg041)) AND p_level = 1 THEN
         LET xbwg041 = 1
      END IF
 
      LET sr[i].bmb06 = sr[i].bmb06*xbwg041
      LET g_bwg.bwg05 = x_total*sr[i].bmb06
      LET g_bwg.bwg041 = sr[i].bmb06
 
     #FUN-6A0007 (S)----------------
     #SELECT COUNT(*) INTO l_n FROM bnd_file
     # WHERE bnd01 = sr[i].bmb03 
     #   AND bnd02 = p_date 
       SELECT COUNT(*) INTO l_n FROM bnd_file WHERE bnd01 = sr[i].bmb03
                             AND (bnd02 <= p_date OR bnd02 IS NULL)
                             AND (bnd03 >  p_date OR bnd03 IS NULL)
     #FUN-6A0007 (E)----------------
 
      IF l_n > 0 THEN
         IF g_bgjob = "N" THEN                     #No.FUN-570115
            #No.MOD-580323 --start--                                                       
            CALL cl_getmsg('abx9131',g_lang) RETURNING l_str31                   
            CALL cl_getmsg('abx9132',g_lang) RETURNING l_str32                   
            MESSAGE l_str31,p_level," ",xx," ",sr[i].bmb03 clipped,
                    l_str32,sr[i].bmb06                              
            #No.MOD-580323 --end--           
         END IF                                    #No.FUN-570115
 
         LET g_no = g_no + 1
         LET g_bwg.bwg00 = xx 
         LET g_bwg.bwg01 = x2
         LET g_bwg.bwg02 = x3
         LET g_bwg.bwg03 = g_no
         LET g_bwg.bwg04 = sr[i].bmb03
         LET g_bwg.bwg011 = g_yy    #FUN-6A0007
 
         LET g_bwg.bwgplant = g_plant   #FUN-980001 add
         LET g_bwg.bwglegal = g_legal   #FUN-980001 add
 
         INSERT INTO bwg_file VALUES(g_bwg.*)
 
         CALL p910_bom_3(p_level,sr[i].bmb03,p_date,sr[i].bmb06)
      END IF  
 
      IF l_n = 0 THEN
         IF g_bgjob = "N" THEN                     #No.FUN-570115
            MESSAGE "折合統計:",p_level," ",xx," ",
                    sr[i].bmb03 clipped," 折合數量:",g_bwg.bwg05
         END IF                                    #No.FUN-570115
         LET g_no = g_no + 1
         LET g_bwg.bwg00 = xx 
         LET g_bwg.bwg01 = x2
         LET g_bwg.bwg02 = x3
         LET g_bwg.bwg03 = g_no
         LET g_bwg.bwg04 = sr[i].bmb03
         LET g_bwg.bwg011 = g_yy    #FUN-6A0007
 
         LET g_bwg.bwgplant = g_plant   #FUN-980001 add
         LET g_bwg.bwglegal = g_legal   #FUN-980001 add
 
         INSERT INTO bwg_file VALUES(g_bwg.*)
      END IF
   END FOR
 
END FUNCTION
