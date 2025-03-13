# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: abxp820.4gl
# Descriptions...: 料件倉庫各月異動統計重計作業
# Date & Author..: 96/11/02 By Eric
# Modify.........: 96/11/04 修改為不分庫別統計 
# Modify.........: 97/05/14 本期內銷數(bnf10),改為由放行單抓取(bnb_file,bnc_file)--Elaine
# Modify.........: No.MOD-530895 05/03/31 By kim 若g_bnz.bnz04 is null則不加入where 條件
# Modify.........: No.FUN-550033 05/05/18 By wujie 單據編號加大                           
# Modify.........: No.MOD-580323 05/08/28 By jackie 將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.FUN-570115 06/03/01 By saki 加入背景作業功能
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0007 06/11/02 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.MOD-970060 09/07/16 By Smapmin 未回寫內銷數
# Modify.........: No.FUN-980001 09/08/10 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-A60110 10/06/18 By Sarah 在abxp820的畫面上增加計算起迄日期,以此日期為範圍抓取資料
# Modify.........: No.MOD-C30403 12/03/10 By chenjing 計算起始日期不可小於關帳日
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_bxi             RECORD LIKE bxi_file.*
DEFINE b_bxj             RECORD LIKE bxj_file.*
DEFINE p_bxr             RECORD LIKE bxr_file.*
DEFINE p_bnf             RECORD LIKE bnf_file.*
DEFINE p_bng             RECORD LIKE bng_file.*
DEFINE p_bmb             RECORD LIKE bmb_file.*
DEFINE g_bxd             RECORD LIKE bxd_file.*    #FUN-6A0007
DEFINE g_yy,g_mm         LIKE type_file.num5       #No.FUN-680062 SMALLINT
DEFINE last_yy,last_mm   LIKE type_file.num5       #No.FUN-680062 SMALLINT
DEFINE l_found           LIKE type_file.chr1       #No.FUN-680062 VARCHAR(01)
DEFINE p_bnc03           LIKE bnc_file.bnc03 
DEFINE p_bnc06           LIKE bnc_file.bnc06 
DEFINE g_bdate,g_edate   LIKE type_file.dat        #No.FUN-680062 DATE
DEFINE g_wc,g_wc2,g_sql  STRING                    #No.FUN-580092 HCN        #No.FUN-680062
DEFINE l_flag            LIKE type_file.chr1       #No.FUN-680062
DEFINE g_bnz             RECORD LIKE bnz_file.*   
DEFINE g_chr             LIKE type_file.chr1       #No.FUN-680062
DEFINE g_change_lang     LIKE type_file.chr1       #No.FUN-570115  #No.FUN-680062 VARCHAR(01)
DEFINE ls_date           LIKE type_file.dat        #No.FUN-680062  DATE

MAIN
#  DEFINE l_time         LIKE type_file.chr8       #No.FUN-6A0062
   DEFINE p_row,p_col    LIKE type_file.num5       #No.FUN-570115  #No.FUN-680062 SMALLINT

   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   # No.FUN-570115 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy    = ARG_VAL(1)
   LET g_mm    = ARG_VAL(2)
   LET g_bdate = ARG_VAL(3)   #MOD-A60110 add
   LET g_edate = ARG_VAL(4)   #MOD-A60110 add
   LET g_bgjob = ARG_VAL(5)
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

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
   #No.FUN-570115 --start--
   #OPEN WINDOW p820_w AT p_row,p_col WITH FORM "abx/42f/abxp820" 
   #     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   #
   #CALL cl_ui_init()
   #No.FUN-570115 --end--
 
    SELECT * INTO g_bnz.* FROM bnz_file WHERE bnz00 = '0'
    WHILE TRUE
       IF g_bgjob="N" THEN                   #No.FUN-570115
          CLEAR FORM
          CALL p820_p1()
          IF cl_sure(0,0) THEN
             CALL cl_wait()                           #No.FUN-570115
             LET g_success="Y"                        #No.FUN-570115             
             BEGIN WORK                               #No.FUN-570115 
             CALL p820_s1() 
             IF g_success = 'Y' THEN
                COMMIT WORK
                CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
             ELSE 
                ROLLBACK WORK
                CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
             END IF
             IF l_flag THEN
                CONTINUE WHILE
             ELSE
                EXIT WHILE
             END IF
          #No.FUN-570115 --start
          ELSE
             CONTINUE WHILE
          END IF
          CLOSE WINDOW p820_w
       ELSE
          LET g_success="Y"                        #No.FUN-570115             
          BEGIN WORK                               #No.FUN-570115 
          CALL p820_s1()
          IF g_success="Y" THEN
             COMMIT WORK
          ELSE
             ROLLBACK WORK
          END IF
          CALL cl_batch_bg_javamail(g_success)
          EXIT WHILE
       END IF
    END WHILE
#   CLOSE WINDOW p820_w
    #No.FUN-570115 --end--
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION p820_p1()
   DEFINE lc_cmd        LIKE type_file.chr1000     # No.FUN-570115        #No.FUN-680062 VARCHAR(500)
   DEFINE p_row,p_col   LIKE type_file.num5        # No.FUN-570115        #No.FUN-680062
 
   #No.FUN-570115 --start--
   LET p_row=5
   LET p_col=25
 
   OPEN WINDOW p820_w AT p_row,p_col WITH FORM "abx/42f/abxp820"
        ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_init()
   CLEAR FORM
   # No.FUN-570115 --end--
 
   LET g_yy = YEAR(TODAY) LET g_mm = MONTH(TODAY)
   CALL s_ymtodate(g_yy,g_mm,g_yy,g_mm) RETURNING g_bdate,g_edate  #MOD-A60110 add 
   LET g_bgjob="N"                                        #No.FUN-570115
   WHILE TRUE                                             #No.FUN-570115
     #INPUT BY NAME g_yy,g_mm,g_bgjob WITHOUT DEFAULTS    #No:FUN-570115                   #MOD-A60110 mark
      INPUT BY NAME g_yy,g_mm,g_bdate,g_edate,g_bgjob WITHOUT DEFAULTS    #No:FUN-570115   #MOD-A60110
         AFTER FIELD g_yy
            IF g_yy IS NULL THEN
               NEXT FIELD g_yy
            END IF
 
         AFTER FIELD g_mm
            IF g_mm IS NULL THEN
               NEXT FIELD g_mm 
            END IF
 
        #str MOD-A60110 add
         AFTER FIELD g_bdate
            IF g_bdate IS NULL THEN
               NEXT FIELD g_bdate 
            ELSE
               IF g_bdate>g_edate THEN
                  CALL cl_err(g_bdate,'mfg6164',0)
                  NEXT FIELD g_edate
               END IF
            #MOD-C30403--add--start--
               IF g_bdate<g_bxz.bxz09 THEN
                  CALL cl_err(g_bdate,'abx-861',0)
                  NEXT FIELD g_bdate
               END IF
            #MOD-C30403--add--end--
            END IF

         AFTER FIELD g_edate
            IF g_edate IS NULL THEN
               NEXT FIELD g_edate 
            ELSE
               IF g_bdate>g_edate THEN
                  CALL cl_err(g_edate,'mfg5067',0)
                  NEXT FIELD g_edate
               END IF
            END IF
        #end MOD-A60110 add

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
    
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
    
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION locale
#           CALL cl_dynamic_locale()               #No.FUN-570115
#           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf No.FUN-570115
            LET g_change_lang = TRUE                  #No.FUN-570115
            EXIT INPUT                                #No.FUN-570115

         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT

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
         CLOSE WINDOW p820_w                        #No.FUN-570115 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
         EXIT PROGRAM
      END IF
      #No.FUN-570115 --start--
#     CALL s_azm(g_yy,g_mm) RETURNING g_chr,g_bdate,g_edate
#     IF g_chr!=0 THEN
#        ERROR 'Error in s_azm()' 
#        RETURN 
#     END IF
#     IF g_mm = 1 THEN 
#        LET last_mm = 12       
#        LET last_yy = g_yy - 1
#     ELSE
#        LET last_mm = g_mm - 1 
#        LET last_yy = g_yy
#     END IF
 
      IF g_bgjob="Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01="abxp820"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('abxp820','9031',1)
         ELSE
            LET lc_cmd=lc_cmd CLIPPED,
                       " '",g_yy CLIPPED,"'",
                       " '",g_mm CLIPPED,"'",
                       " '",g_bdate CLIPPED,"'",   #MOD-A60110 add
                       " '",g_edate CLIPPED,"'",   #MOD-A60110 add
                       " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('abxp820',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p820_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
         EXIT PROGRAM
       END IF
       EXIT WHILE
  END WHILE
      #No.FUN-570115 ---end---
END FUNCTION
 
#FUN-570114 -----start-----
#FUNCTION p820_p2()
#   BEGIN WORK
#   LET g_success='Y'
#   DELETE FROM bnf_file WHERE bnf03=g_yy AND bnf04=g_mm
#   DELETE FROM bng_file WHERE bng03=g_yy AND bng04=g_mm
#   CALL p820_s1()
#END FUNCTION
#FUN-570114 ----end-----
 
FUNCTION p820_s1()
  DEFINE l_bxi         RECORD LIKE bxi_file.*
  DEFINE l_bxj         RECORD LIKE bxj_file.*
  DEFINE l_ima15       LIKE ima_file.ima15
  DEFINE l_bxz11       LIKE bxz_file.bxz11
  DEFINE l_bng05       LIKE bng_file.bng05
  DEFINE l_bng08       LIKE bng_file.bng08
  DEFINE last_bnc03    LIKE bnc_file.bnc03 
  DEFINE l_sign        LIKE type_file.num5      #No.FUN-680062 SMALLINT
  DEFINE l_bnz04,l_sql STRING                   #MOD-530895             
  DEFINE l_str1,l_str2 STRING                   #No.MOD-580323   
  DEFINE l_bxr01       LIKE bxr_file.bxr01
 
   #No.FUN-570115 --start--
   DELETE FROM bnf_file WHERE bnf03=g_yy AND bnf04=g_mm
   DELETE FROM bng_file WHERE bng03=g_yy AND bng04=g_mm
  #FUN-6A0007(S)-------------------------------------------
   DELETE FROM bxd_file WHERE bxd03=g_yy AND bxd04=g_mm 
   LET g_sql = "SELECT bxd_file.*  FROM bxd_file ",
               "  WHERE bxd01 = ? ",
               "   AND bxd03 = ? ",
               "   AND bxd04 = ? ",
               "   AND bxd05 = ? ",
               "   AND bxd06 = ? ",
               "   FOR UPDATE "
   LET g_sql=cl_forupd_sql(g_sql)
   PREPARE p820_s1_bzz_p1 FROM g_sql
   DECLARE p820_s1_bzz_c1 CURSOR FOR p820_s1_bzz_p1
  #FUN-6A0007(E)-------------------------------------------
 
  #str MOD-A60110 mark
  #CALL s_azm(g_yy,g_mm) RETURNING g_chr,g_bdate,g_edate
  #IF g_chr!=0 THEN
  #   IF g_bgjob = 'N' THEN ERROR 'Error in s_azm()' END IF RETURN
  #END IF
  #end MOD-A60110 mark
   
   IF g_mm = 1 THEN 
      LET last_mm = 12       
      LET last_yy = g_yy - 1
   ELSE
      LET last_mm = g_mm - 1 
      LET last_yy = g_yy
   END IF
  #No.FUN-570115 ---end---
 
   DECLARE p820_s1_c CURSOR FOR
      SELECT * FROM bnf_file WHERE bnf03=last_yy AND bnf04=last_mm
   FOREACH p820_s1_c INTO p_bnf.*
      IF STATUS THEN
         CALL cl_err('foreach1',STATUS,1)
         LET g_success = 'N' RETURN
      END IF
      LET p_bnf.bnf03=g_yy
      LET p_bnf.bnf04=g_mm
      LET p_bnf.bnf05=0
      LET p_bnf.bnf06=0
      LET p_bnf.bnf08=0
      LET p_bnf.bnf09=0
      LET p_bnf.bnf10=0
      LET p_bnf.bnf11=0
     #FUN-6A0007-----------------------(S)
      LET p_bnf.bnf21 = 0
      LET p_bnf.bnf22 = 0
      LET p_bnf.bnf23 = 0
      LET p_bnf.bnf24 = 0
      LET p_bnf.bnf25 = 0
      LET p_bnf.bnf26 = 0
      LET p_bnf.bnf27 = 0
      LET p_bnf.bnf28 = 0
      LET p_bnf.bnf29 = 0
      LET p_bnf.bnf30 = 0
      LET p_bnf.bnf31 = 0
    
      LET p_bnf.bnfplant = g_plant  #FUN-980001 add
      LET p_bnf.bnflegal = g_legal  #FUN-980001 add
    
     #FUN-6A0007-----------------------(E)
      INSERT INTO bnf_file VALUES(p_bnf.*)
      #No.FUN-570115 --start--
      IF g_bgjob = "N" THEN
         #No.MOD-580323 --start--                                                                                                           
         CALL cl_getmsg('mfg8201',g_lang) RETURNING  l_str1                                                                              
         MESSAGE l_str1,p_bnf.bnf01,' ',p_bnf.bnf02                                                                                      
#        MESSAGE "擷轉上期資料:",p_bnf.bnf01,' ',p_bnf.bnf02                                                                            
      END IF
      #No.FUN-570115 --end--
   END FOREACH                                                                                                                       
  #FUN-6A0007---------------------------------------------------------(S)
  #新增:受託加工原料料件月統計檔(bxd_file)(抓上期新增本期)
   CALL p820_bxd_ins()
   IF g_success = 'N' THEN RETURN END IF
  #FUN-6A0007---------------------------------------------------------(E)
  
   DECLARE p820_s1_c2 CURSOR FOR                                                                                                     
      SELECT * FROM bxi_file WHERE bxi02 BETWEEN g_bdate AND g_edate                                                                  
   FOREACH p820_s1_c2 INTO l_bxi.*                                                                                                   
      IF STATUS THEN CALL cl_err('foreach2',STATUS,1) LET g_success = 'N' RETURN END IF                                                    
      #No.FUN-570115 --start--
      IF g_bgjob="N" THEN
         CALL cl_getmsg('mfg8202',g_lang) RETURNING l_str2                                                                               
         MESSAGE l_str2,l_bxi.bxi01                                                                                                      
#        MESSAGE "計算統計資料:",l_bxi.bxi01      
      END IF                                                                                      
 #No.MOD-580323 --end-- 
     #FUN-6A0007-------------------------------------------------------(S)
     #SELECT * INTO p_bxr.* FROM bxr_file WHERE bxr01=l_bxi.bxi08
     #IF STATUS <> 0 OR l_bxi.bxi08 IS NULL OR l_bxi.bxi08 = ' ' THEN
     #   LET p_bxr.bxr11=0
     #   LET p_bxr.bxr12=0
     #   LET p_bxr.bxr13=0
     #   LET p_bxr.bxr63=0
     #END IF
     #IF p_bxr.bxr11 IS NULL THEN LET p_bxr.bxr11=0 END IF
     #IF p_bxr.bxr12 IS NULL THEN LET p_bxr.bxr12=0 END IF
     #IF p_bxr.bxr13 IS NULL THEN LET p_bxr.bxr13=0 END IF
     #IF p_bxr.bxr63 IS NULL THEN LET p_bxr.bxr63=0 END IF
     #FUN-6A0007-------------------------------------------------------(E)
      DECLARE p820_s1_c3 CURSOR FOR SELECT * FROM bxj_file WHERE bxj01=l_bxi.bxi01
      FOREACH p820_s1_c3 INTO l_bxj.*
         IF STATUS THEN CALL cl_err('foreach3',STATUS,1) LET g_success = 'N' RETURN END IF
        #FUN-6A0007-----------------------------------------------------(S)
         IF NOT cl_null(l_bxj.bxj21) THEN
            LET l_bxr01 = l_bxj.bxj21
         ELSE
            LET l_bxr01 = l_bxi.bxi08 
         END IF
        #No.FUN-570115 --end--
         INITIALIZE p_bxr.* TO NULL  #FUN-6A0007
        #SELECT * INTO p_bxr.* FROM bxr_file WHERE bxr01=l_bxi.bxi08 #FUN-6A0007
        #IF STATUS <> 0 OR l_bxi.bxi08 IS NULL OR l_bxi.bxi08 = ' ' THEN  #FUN-6A0007
         SELECT * INTO p_bxr.* FROM bxr_file
          WHERE bxr01 = l_bxr01
         IF STATUS <> 0 OR cl_null(l_bxr01) THEN
            LET p_bxr.bxr11=0
            LET p_bxr.bxr12=0
            LET p_bxr.bxr13=0
            LET p_bxr.bxr21=0
            LET p_bxr.bxr22=0
            LET p_bxr.bxr23=0
            LET p_bxr.bxr24=0
            LET p_bxr.bxr25=0
            LET p_bxr.bxr26=0
            LET p_bxr.bxr31=0
            LET p_bxr.bxr41=0
            LET p_bxr.bxr51=0
            LET p_bxr.bxr60=0
            LET p_bxr.bxr61=0
            LET p_bxr.bxr62=0
            LET p_bxr.bxr63=0
            LET p_bxr.bxr64=0
         END IF
         IF p_bxr.bxr11 IS NULL THEN LET p_bxr.bxr11=0 END IF
         IF p_bxr.bxr12 IS NULL THEN LET p_bxr.bxr12=0 END IF
         IF p_bxr.bxr13 IS NULL THEN LET p_bxr.bxr13=0 END IF
         IF p_bxr.bxr21 IS NULL THEN LET p_bxr.bxr21=0 END IF
         IF p_bxr.bxr22 IS NULL THEN LET p_bxr.bxr22=0 END IF
         IF p_bxr.bxr23 IS NULL THEN LET p_bxr.bxr23=0 END IF
         IF p_bxr.bxr24 IS NULL THEN LET p_bxr.bxr24=0 END IF
         IF p_bxr.bxr25 IS NULL THEN LET p_bxr.bxr25=0 END IF
         IF p_bxr.bxr26 IS NULL THEN LET p_bxr.bxr26=0 END IF
         IF p_bxr.bxr31 IS NULL THEN LET p_bxr.bxr31=0 END IF
         IF p_bxr.bxr41 IS NULL THEN LET p_bxr.bxr41=0 END IF
         IF p_bxr.bxr51 IS NULL THEN LET p_bxr.bxr51=0 END IF
         IF p_bxr.bxr60 IS NULL THEN LET p_bxr.bxr60=0 END IF
         IF p_bxr.bxr61 IS NULL THEN LET p_bxr.bxr61=0 END IF
         IF p_bxr.bxr62 IS NULL THEN LET p_bxr.bxr62=0 END IF
         IF p_bxr.bxr63 IS NULL THEN LET p_bxr.bxr63=0 END IF
         IF p_bxr.bxr64 IS NULL THEN LET p_bxr.bxr64=0 END IF
        #FUN-6A0007-----------------------------------------------------(E)
         LET p_bnf.bnf01=l_bxj.bxj04
#        LET p_bnf.bnf02=l_bxj.bxj07
# 96/11/04 不分庫
         LET p_bnf.bnf02=' '
         LET p_bnf.bnf03=g_yy
         LET p_bnf.bnf04=g_mm
         SELECT * INTO p_bnf.* FROM bnf_file 
          WHERE bnf01=p_bnf.bnf01 AND bnf02=p_bnf.bnf02
            AND bnf03=p_bnf.bnf03 AND bnf04=p_bnf.bnf04
         IF STATUS <> 0 THEN
            LET p_bnf.bnf05=0
            LET p_bnf.bnf06=0
            LET p_bnf.bnf07=0
            LET p_bnf.bnf08=0
            LET p_bnf.bnf09=0
            LET p_bnf.bnf10=0
            LET p_bnf.bnf11=0
            LET p_bnf.bnf12=0
           #FUN-6A0007-----------------------(S)
            LET p_bnf.bnf21 = 0
            LET p_bnf.bnf22 = 0
            LET p_bnf.bnf23 = 0
            LET p_bnf.bnf24 = 0
            LET p_bnf.bnf25 = 0
            LET p_bnf.bnf26 = 0
            LET p_bnf.bnf27 = 0
            LET p_bnf.bnf28 = 0
            LET p_bnf.bnf29 = 0
            LET p_bnf.bnf30 = 0
            LET p_bnf.bnf31 = 0
           #FUN-6A0007-----------------------(E)
 
            LET p_bnf.bnfplant = g_plant  #FUN-980001 add
            LET p_bnf.bnflegal = g_legal  #FUN-980001 add
 
            INSERT INTO bnf_file VALUES(p_bnf.*)
         END IF
         IF l_bxi.bxi06='1' THEN                         ## 入庫
            LET p_bnf.bnf05=p_bnf.bnf05+l_bxj.bxj06
            LET p_bnf.bnf07=p_bnf.bnf07+l_bxj.bxj06
         ELSE
            LET p_bnf.bnf06=p_bnf.bnf06+l_bxj.bxj06
            LET p_bnf.bnf07=p_bnf.bnf07-l_bxj.bxj06
         END IF
#        IF l_bxi.bxi06='1' THEN                         ## 入庫
#           IF p_bxr.bxr11 <> 0 OR p_bxr.bxr12 <> 0 OR p_bxr.bxr13 <> 0 THEN
#              IF NOT cl_null(l_bxj.bxj11) THEN          ## 保稅進口
#                 LET p_bnf.bnf08=p_bnf.bnf08+l_bxj.bxj06
#              ELSE                                      ## 非保稅進口
#                 LET p_bnf.bnf09=p_bnf.bnf09+l_bxj.bxj06
#              END IF
#           END IF
#        END IF
         #-----MOD-970060--------- 
         #取消原先的mark
         IF l_bxi.bxi06='2' THEN                         ## 出庫
            IF p_bxr.bxr63 <> 0 THEN                     ## 內銷
               LET p_bnf.bnf10=p_bnf.bnf10+l_bxj.bxj06
            END IF
         END IF
         #-----END MOD-970060-----
# 96/11/04 Eric Mark & Modify
         IF l_bxi.bxi06='1' THEN                         ## 入庫
            LET l_sign=1
         ELSE
            LET l_sign=-1
         END IF
##1999/08/04 modify by sophia
        #IF l_bxi.bxi08='A1' THEN  
         IF (p_bxr.bxr11 <> 0 OR p_bxr.bxr12 <> 0) THEN
            IF p_bxr.bxr11 <> 0 THEN
               LET p_bnf.bnf08=p_bnf.bnf08+l_bxj.bxj06*p_bxr.bxr11
            END IF
            IF p_bxr.bxr12 <> 0 THEN
               LET p_bnf.bnf08=p_bnf.bnf08+l_bxj.bxj06*p_bxr.bxr12
            END IF
         END IF
        #IF l_bxi.bxi08='A2' THEN  
         LET p_bnf.bnf09=p_bnf.bnf09+l_bxj.bxj06*p_bxr.bxr13
###-------------------------------
#        IF l_bxi.bxi08='C4' THEN  
#           LET p_bnf.bnf10=p_bnf.bnf10-l_bxj.bxj06*l_sign
#        END IF
      
        #FUN-6A0007---------------------------------------------------(S)
         IF p_bxr.bxr21 <> 0 THEN
            LET p_bnf.bnf21 = p_bnf.bnf21 + l_bxj.bxj06 * p_bxr.bxr21
         END IF
         IF p_bxr.bxr22 <> 0 THEN
            LET p_bnf.bnf22 = p_bnf.bnf22 + l_bxj.bxj06 * p_bxr.bxr22
         END IF
         IF p_bxr.bxr23 <> 0 THEN
            LET p_bnf.bnf23 = p_bnf.bnf23 + l_bxj.bxj06 * p_bxr.bxr23
         END IF
         IF p_bxr.bxr24 <> 0 THEN
            LET p_bnf.bnf24 = p_bnf.bnf24 + l_bxj.bxj06 * p_bxr.bxr24
         END IF
         IF p_bxr.bxr31 <> 0 THEN
            LET p_bnf.bnf25 = p_bnf.bnf25 + l_bxj.bxj06 * p_bxr.bxr31
         END IF
         IF p_bxr.bxr25 <> 0 THEN
            LET p_bnf.bnf26 = p_bnf.bnf26 + l_bxj.bxj06 * p_bxr.bxr25
         END IF
         IF p_bxr.bxr26 <> 0 THEN
            LET p_bnf.bnf26 = p_bnf.bnf26 + l_bxj.bxj06 * p_bxr.bxr26
         END IF
         IF p_bxr.bxr41 <> 0 THEN
            LET p_bnf.bnf27 = p_bnf.bnf27 + l_bxj.bxj06 * p_bxr.bxr41
         END IF
         IF p_bxr.bxr61 <> 0 THEN
            LET p_bnf.bnf28 = p_bnf.bnf28 + l_bxj.bxj06 * p_bxr.bxr61
         END IF
         IF p_bxr.bxr62 <> 0 THEN
            LET p_bnf.bnf28 = p_bnf.bnf28 + l_bxj.bxj06 * p_bxr.bxr62
         END IF
         IF p_bxr.bxr51 <> 0 THEN
            LET p_bnf.bnf29 = p_bnf.bnf29 + l_bxj.bxj06 * p_bxr.bxr51
         END IF
         IF p_bxr.bxr60 <> 0 THEN
            LET p_bnf.bnf30 = p_bnf.bnf30 + l_bxj.bxj06 * p_bxr.bxr60
         END IF
         IF p_bxr.bxr64 <> 0 THEN
            LET p_bnf.bnf31 = p_bnf.bnf31 + l_bxj.bxj06 * p_bxr.bxr64
         END IF
        #UPDATE bnf_file
        #   SET bnf05=p_bnf.bnf05, bnf06=p_bnf.bnf06, bnf07=p_bnf.bnf07,
        #       bnf08=p_bnf.bnf08, bnf09=p_bnf.bnf09
         UPDATE bnf_file
            SET bnf05 = p_bnf.bnf05,
                bnf06 = p_bnf.bnf06,
                bnf07 = p_bnf.bnf07,
                bnf08 = p_bnf.bnf08,
                bnf09 = p_bnf.bnf09,
                bnf10 = p_bnf.bnf10,   #MOD-970060
                bnf21 = p_bnf.bnf21,
                bnf22 = p_bnf.bnf22,
                bnf23 = p_bnf.bnf23,
                bnf24 = p_bnf.bnf24,
                bnf25 = p_bnf.bnf25,
                bnf26 = p_bnf.bnf26,
                bnf27 = p_bnf.bnf27,
                bnf28 = p_bnf.bnf28,
                bnf29 = p_bnf.bnf29,
                bnf30 = p_bnf.bnf30,
                bnf31 = p_bnf.bnf31
        #FUN-6A0007---------------------------------------------------(E)
          WHERE bnf01=p_bnf.bnf01 AND bnf02=p_bnf.bnf02
            AND bnf03=p_bnf.bnf03 AND bnf04=p_bnf.bnf04
 
        #FUN-6A0007---------------------------------------------------(S)
        #計算且新增修改:受託加工原料料件月統計檔(bxd_file)
         IF NOT cl_null(l_bxj.bxj22) AND l_bxj.bxj23 IS NOT NULL THEN
            CALL p820_bxd_upd(l_bxi.*,l_bxj.*)
            IF g_success = 'N' THEN EXIT FOREACH END IF
         END IF
        #FUN-6A0007---------------------------------------------------(E)
      END FOREACH
      IF g_success = 'N' THEN EXIT FOREACH END IF  #FUN-6A0007
   END FOREACH
  
   LET last_bnc03 = ' '
   LET p_bnc03 = ' '
   LET p_bnc06 = 0
   #MOD-530895.............................begin
   LET l_bnz04=''
   IF g_bnz.bnz04 IS NOT NULL THEN
#No.FUN-550033--begin
#     LET l_bnz04=" AND bnb04[1,3] MATCHES '",g_bnz.bnz04,"'"
     #LET l_bnz04=" AND bnb04 MATCHES '",g_bnz.bnz04,"-*'"   #MOD-A60110 mark
      LET l_bnz04=" AND bnb04 LIKE '",g_bnz.bnz04,"-%'"      #MOD-A60110
#No.FUN-550033--end   
   END IF
   LET l_sql="SELECT bnc03,SUM(bnc06),bnf10 ",
             "  FROM bnb_file,bnc_file,bnf_file ",
             "  WHERE bnb02 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
             "  AND bnb01=bnc01 ",
             l_bnz04,
             "  AND bnf01=bnc03 ",
             "  AND bnf03=",g_yy," AND bnf04=",g_mm,
             "  GROUP BY bnc03,bnf10 "
 
   PREPARE p820_s1_c4_sql FROM l_sql
   DECLARE p820_s1_c4 CURSOR FOR p820_s1_c4_sql
 
#  DECLARE p820_s1_c4 CURSOR FOR
#     SELECT bnc03,SUM(bnc06),bnf10
#       FROM bnb_file,bnc_file,bnf_file
#      WHERE bnb02 BETWEEN g_bdate AND g_edate
#        AND bnb01=bnc01
#        AND bnb04[1,3] MATCHES g_bnz.bnz04
#        AND bnf01=bnc03
#        AND bnf03=g_yy AND bnf04=g_mm
#      GROUP BY bnc03,bnf10
    #MOD-530895.............................end
 
   FOREACH p820_s1_c4 INTO p_bnc03,p_bnc06,p_bnf.bnf10
      IF STATUS THEN
         CALL cl_err('foreach4',STATUS,1)
         LET g_success = 'N' RETURN
      END IF
      IF p_bnf.bnf10 <> 0 AND last_bnc03 <> p_bnc03 THEN
         LET p_bnf.bnf10 = 0
      END IF
      LET p_bnf.bnf10 = p_bnf.bnf10 + p_bnc06
      LET last_bnc03 = p_bnc03
 
     #FUN-6A0007----------------------------------(S)
     #UPDATE bnf_file SET bnf10 = p_bnf.bnf10
     # WHERE bnf01 = p_bnc03 and bnf02 = p_bnf.bnf02
     #   AND bnf03 = g_yy  AND bnf04 = g_mm
     #FUN-6A0007----------------------------------(E)
   END FOREACH
   #No.FUN-570115 --start--
   IF g_bgjob = "N" THEN
      MESSAGE " "
   END IF
   #No.FUN-570115 --end--
END FUNCTION
 
#FUN-6A0007-------------------------------(S)
#default值:受託加工原料料件月統計檔(bxd_file)
FUNCTION p820_bxd_def()
   LET g_bxd.bxd07 = 0
   LET g_bxd.bxd08 = 0
   LET g_bxd.bxd09 = 0
   LET g_bxd.bxd10 = 0
   LET g_bxd.bxd11 = 0
   LET g_bxd.bxd12 = 0
   LET g_bxd.bxd13 = 0
   LET g_bxd.bxd14 = 0
   LET g_bxd.bxd15 = 0
   LET g_bxd.bxd16 = 0
   LET g_bxd.bxd17 = 0
   LET g_bxd.bxdplant = g_plant  #FUN-980001 add
   LET g_bxd.bxdlegal = g_legal  #FUN-980001 add
END FUNCTION
 
#新增:受託加工原料料件月統計檔(bxd_file)(抓上期新增本期)
FUNCTION p820_bxd_ins()
   DECLARE p820_s1_bzz_c CURSOR FOR
      SELECT * FROM bxd_file
       WHERE bxd03 = last_yy 
         AND bxd04 = last_mm
   FOREACH p820_s1_bzz_c INTO g_bxd.*
      IF STATUS THEN
         CALL cl_err('FOREACH p820_s1_bzz_c:',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET g_bxd.bxd03 = g_yy
      LET g_bxd.bxd04 = g_mm
      IF cl_null(g_bxd.bxd18) THEN
         LET g_bxd.bxd18 = 0
      END IF
      CALL p820_bxd_def()
      INSERT INTO bxd_file VALUES(g_bxd.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('Ins bxd_file:','abx-075',1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
 
#計算且新增修改:受託加工原料料件月統計檔(bxd_file)
FUNCTION p820_bxd_upd(p_bxi,p_bxj)
   DEFINE p_bxi        RECORD LIKE bxi_file.*,
          p_bxj        RECORD LIKE bxj_file.*,
          l_bxd18      LIKE bxd_file.bxd18,
          l_sql        STRING
 
   INITIALIZE g_bxd.* TO NULL
   LET g_bxd.bxd01 = p_bxj.bxj04
   LET g_bxd.bxd03 = g_yy
   LET g_bxd.bxd04 = g_mm
   LET g_bxd.bxd05 = p_bxj.bxj22
   LET g_bxd.bxd06 = p_bxj.bxj23
   OPEN p820_s1_bzz_c1 USING g_bxd.bxd01,g_bxd.bxd03,
                             g_bxd.bxd04,g_bxd.bxd05,
                             g_bxd.bxd06
   IF SQLCA.SQLCODE THEN
      CALL cl_err('OPEN p820_s1_bzz_c1:',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF
   FETCH p820_s1_bzz_c1 INTO g_bxd.*
   IF SQLCA.SQLCODE THEN
      IF SQLCA.SQLCODE = 100 THEN
         LET g_bxd.bxd18 = 0
         CALL p820_bxd_def()
         INSERT INTO bxd_file VALUES(g_bxd.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('Ins bxd_file:','abx-075',1)
            LET g_success = 'N'
            RETURN
         ELSE
            CLOSE p820_s1_bzz_c1
            OPEN p820_s1_bzz_c1 USING g_bxd.bxd01,g_bxd.bxd03,
                                      g_bxd.bxd04,g_bxd.bxd05,
                                      g_bxd.bxd06
            IF SQLCA.SQLCODE THEN
               CALL cl_err('OPEN p820_s1_bzz_c1:',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               RETURN
            END IF
            FETCH p820_s1_bzz_c1 INTO g_bxd.*
            IF SQLCA.SQLCODE THEN
               CALL cl_err('FETCH p820_s1_bzz_c1:',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      ELSE
         CALL cl_err('FETCH p820_s1_bzz_c1:',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #抓上期數量
   LET l_bxd18 = 0
   SELECT bxd18 INTO l_bxd18 FROM bxd_file 
    WHERE bxd01 = g_bxd.bxd01
      AND bxd03 = last_yy
      AND bxd04 = last_mm
      AND bxd05 = g_bxd.bxd05
      AND bxd06 = g_bxd.bxd06 
   IF l_bxd18 IS NULL THEN LET l_bxd18 = 0 END IF
   #計算
   CASE p_bxi.bxi15 
      WHEN '1' LET g_bxd.bxd07 = g_bxd.bxd07 + p_bxj.bxj06
      WHEN '2' LET g_bxd.bxd08 = g_bxd.bxd08 + p_bxj.bxj06
      WHEN '3' LET g_bxd.bxd09 = g_bxd.bxd09 + p_bxj.bxj06
      WHEN '4' LET g_bxd.bxd10 = g_bxd.bxd10 + p_bxj.bxj06
      WHEN '5' LET g_bxd.bxd11 = g_bxd.bxd11 + p_bxj.bxj06
      WHEN '6' LET g_bxd.bxd12 = g_bxd.bxd12 + p_bxj.bxj06
      WHEN '7' LET g_bxd.bxd13 = g_bxd.bxd13 + p_bxj.bxj06
      WHEN '8' LET g_bxd.bxd14 = g_bxd.bxd14 + p_bxj.bxj06
      WHEN '9' LET g_bxd.bxd15 = g_bxd.bxd15 + p_bxj.bxj06
      WHEN 'A' LET g_bxd.bxd16 = g_bxd.bxd16 + p_bxj.bxj06
      WHEN 'B' LET g_bxd.bxd17 = g_bxd.bxd17 + (p_bxj.bxj06 * -1)
   END CASE
   LET g_bxd.bxd18 = l_bxd18 + 
                     g_bxd.bxd07 + g_bxd.bxd11 + 
                     g_bxd.bxd12 + g_bxd.bxd13 +
                     g_bxd.bxd16 + g_bxd.bxd17 - 
                     g_bxd.bxd08 - g_bxd.bxd09 -
                     g_bxd.bxd14 - g_bxd.bxd10 -
                     g_bxd.bxd15
   UPDATE bxd_file SET * = g_bxd.*
    WHERE bxd01 = g_bxd.bxd01
      AND bxd03 = g_bxd.bxd03
      AND bxd04 = g_bxd.bxd04
      AND bxd05 = g_bxd.bxd05
      AND bxd06 = g_bxd.bxd06 
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('Upd bxd_file:','abx-076',1)
      LET g_success = 'N'
      RETURN
   END IF
   CLOSE p820_s1_bzz_c1
END FUNCTION
#FUN-6A0007-------------------------------(E)
