# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: abxp830.4gl
# Descriptions...: 保稅內銷料件BOM展開與彙總作業
# Date & Author..: 96/11/11 By Eric
# Modify.........: NO.MOD-490217 04/09/10 by yiting  料號欄位放大
# Modify.........: No.FUN-560231 05/06/27 By Mandy QPA欄位放大
# Modify.........: No.MOD-580323 05/08/30 By jackie 將程序中寫死為中文的錯誤
# Modify.........: NO.FUN-570115 06/03/02 By saki 加入背景作業功能
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-980001 09/08/10 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting  1、將cl_used()改成標準，使用g_prog
#                                                          2、未加離開前的 cl_used(2)  
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_bxi                    RECORD LIKE bxi_file.*
DEFINE b_bxj                    RECORD LIKE bxj_file.*
DEFINE p_bxr                    RECORD LIKE bxr_file.*
DEFINE p_bnf                    RECORD LIKE bnf_file.*
DEFINE p_bng                    RECORD LIKE bng_file.*
DEFINE p_bmb                    RECORD LIKE bmb_file.*
DEFINE g_yy,g_mm,last_yy,last_mm LIKE type_file.num5,     #No.FUN-680062 SMALLINT
       l_found LIKE type_file.chr1                        #No.FUN-680062 VARCHAR(01)
DEFINE g_bdate,g_edate   LIKE type_file.dat               #No.FUN-680062 DATE
DEFINE g_wc,g_wc2,g_sql  STRING  #No.FUN-580092 HCN     
 
DEFINE   g_chr           LIKE type_file.chr1,         #No.FUN-680062
         l_flag          LIKE type_file.chr1          #No.FUN-680062
DEFINE g_change_lang     LIKE  type_file.chr1         #No.FUN-570115     #No.FUN-680062 VARCHAR(01)
DEFINE ls_date           LIKE  type_file.dat          #No.FUN-570115     #No.FUN-680062 DATE
MAIN
#  DEFINE l_time         LIKE type_file.chr8          #No.FUN-6A0062
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-570115     #No.FUN-680062SMALLINT
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    # No.FUN-570115 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy = ARG_VAL(1)
   LET g_mm = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
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
   #OPEN WINDOW p830_w AT p_row,p_col WITH FORM "abx/42f/abxp830" 
   #   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   #
   #CALL cl_ui_init()
   #No.FUN-570115 --end--
 
    #CALL cl_used('abxp830',g_time,1) RETURNING g_time  #No.FUN-570115
    CALL cl_used(g_prog,g_time,1) RETURNING g_time      #No.FUN-570115     #FUN-B30211
    WHILE TRUE
#       CLEAR FORM                                     #No.FUN-570115
        IF g_bgjob="N" THEN                   #No.FUN-570115        
           CALL p830_p1()
           IF cl_sure(0,0) THEN
              BEGIN WORK
              LET g_success = 'Y'
              CALL cl_wait()                              #No.FUN-570115
              CALL p830_p2() 
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
           CLOSE WINDOW p830_w
        ELSE
           BEGIN WORK
           LET g_success = 'Y'
           CALL p830_p2()
           IF g_success="Y" THEN
              COMMIT WORK
           ELSE
              ROLLBACK WORK
           END IF
           CALL cl_batch_bg_javamail(g_success)
           EXIT WHILE
           #No.FUN-570115 --end--
        END IF
    END WHILE
#   CLOSE WINDOW p830_w                                   #No.FUN-570115
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
END MAIN
 
FUNCTION p830_p1()
    DEFINE   lc_cmd        LIKE  type_file.chr1000      # No.FUN-570115   #No.FUN-680062 VARCHAR(500)
    DEFINE   p_row,p_col   LIKE type_file.num5          # No.FUN-570115   #No.FUN-680062smallint
 
   #No.FUN-570115 --start--
   LET p_row=5
   LET p_col=25
   OPEN WINDOW p830_w AT p_row,p_col WITH FORM "abx/42f/abxp830"
   ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_init()
   CLEAR FORM
   # No.FUN-570115 --end--
 
   LET g_yy = YEAR(TODAY) 
   LET g_mm = MONTH(TODAY)
   LET g_bgjob="N"                                           #No.FUN-570115
   WHILE TRUE                                                #No.FUN-570115
      INPUT BY NAME g_yy,g_mm,g_bgjob WITHOUT DEFAULTS       #No.FUN-570115
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         AFTER FIELD g_yy
            IF g_yy IS NULL THEN
               NEXT FIELD g_yy 
            END IF
 
         AFTER FIELD g_mm
            IF g_mm IS NULL THEN
               NEXT FIELD g_mm 
            END IF
 
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
#           CALL cl_dynamic_locale()                  #No.FUN-570115
#           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf   No.FUN-570115
            LET g_change_lang = TRUE                  #No.FUN-570115
            EXIT INPUT                                #No.FUN-570115
 
         ON ACTION exit                            #加離開功能
             LET INT_FLAG = 1
             EXIT INPUT
 
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
         CLOSE WINDOW p830_w                       #No.FUN-570115
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
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
         SELECT zz08 INTO lc_cmd FROM zz_file
            WHERE zz01="abxp830"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('abxp830','9031',1)
         ELSE
            LET lc_cmd=lc_cmd CLIPPED,
                       " '",g_yy CLIPPED,"'",
                       " '",g_mm CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('abxp830',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p830_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
   #No.FUN-570115 ---end---
END FUNCTION
 
FUNCTION p830_p2()
   DEFINE v_lastyy,v_lastmm     LIKE  type_file.num5,     #上期年月     #No.FUN-680062 SMALLINT
          v_bnf12 LIKE bnf_file.bnf12 #上期結存非保稅數
# 計算 上期結存非保稅數+本期非保稅進貨數
  DEFINE l_str1  STRING      #No.MOD-580323      
  # No.FUN-570115 --start--
  CALL s_azm(g_yy,g_mm) RETURNING g_chr,g_bdate,g_edate
  IF g_chr!=0 THEN
     IF g_bgjob = 'N' THEN ERROR 'Error in s_azm()' END IF
     LET g_success = 'N'
     RETURN
  END IF
 
  IF g_mm = 1 THEN 
     LET last_mm = 12       
     LET last_yy = g_yy - 1
  ELSE 
     LET last_mm = g_mm - 1 
     LET last_yy = g_yy
  END IF
  # No.FUN-570115 ---end---
 
  IF g_mm=1 THEN
     LET v_lastyy=g_yy-1
     LET v_lastmm=12
  ELSE
     LET v_lastyy=g_yy
     LET v_lastmm=g_mm-1
  END IF
  DECLARE p830_s1_c7 CURSOR FOR SELECT * FROM bnf_file
     WHERE bnf03=g_yy AND bnf04=g_mm
  FOREACH p830_s1_c7 INTO p_bnf.*
    IF STATUS THEN CALL cl_err('foreach4',STATUS,1) LET g_success = 'N' RETURN END IF
    LET v_bnf12=0
    SELECT bnf12 INTO v_bnf12 FROM bnf_file
       WHERE bnf01=p_bnf.bnf01 AND bnf02=p_bnf.bnf02
       AND bnf03=v_lastyy AND bnf04=v_lastmm
    IF v_bnf12 IS NULL THEN LET v_bnf12=0 END IF
    IF g_bgjob="N" THEN                          #No.FUN-570115
       #No.MOD-580323 --start--                                                       
       CALL cl_getmsg('abx-830',g_lang) RETURNING l_str1                           
       MESSAGE l_str1,p_bnf.bnf01,v_bnf12                                          
#      MESSAGE "上期結存非保稅數:",p_bnf.bnf01,v_bnf12                            
       #No.MOD-580323 --end--          
    END IF                                       #No.FUN-570115
    UPDATE bnf_file SET bnf12=v_bnf12+bnf09
       WHERE bnf01=p_bnf.bnf01 AND bnf02=p_bnf.bnf02
       AND bnf03=g_yy AND bnf04=g_mm
  END FOREACH
 
# bnf11歸零
  UPDATE bnf_file SET bnf11=0 WHERE bnf03=g_yy AND bnf04=g_mm
 
# 刪除本期內銷折合檔
  DELETE FROM bng_file WHERE bng03=g_yy AND bng04=g_mm
  CALL p830_s1()
END FUNCTION
 
FUNCTION p830_s1()
  DEFINE l_bxi RECORD LIKE bxi_file.*
  DEFINE l_bxj RECORD LIKE bxj_file.*
  DEFINE l_ima15 LIKE ima_file.ima15
  DEFINE l_bxz11 LIKE bxz_file.bxz11,
         l_bng05 LIKE bng_file.bng05,
         l_bng08 LIKE bng_file.bng08,
         l_sign LIKE type_file.num5              #No.FUN-680062 SMALLINT
  DEFINE l_str2,l_str3  STRING    #No.MOD-580323            
 
# 展內銷用料
  DECLARE p830_s1_c4 CURSOR FOR
    SELECT * FROM bnf_file 
     WHERE bnf03=g_yy AND bnf04=g_mm AND bnf10 <> 0
  FOREACH p830_s1_c4 INTO p_bnf.*
    IF STATUS THEN CALL cl_err('foreach3',STATUS,1) LET g_success = 'N' RETURN END IF
    IF g_bgjob="N" THEN                          #No.FUN-570115
       #No.MOD-580323 --start--                                                       
       CALL cl_getmsg('abx-831',g_lang) RETURNING l_str2                           
       MESSAGE l_str2,p_bnf.bnf01,' ',p_bnf.bnf02                                  
#      MESSAGE "展內銷用料:",p_bnf.bnf01,' ',p_bnf.bnf02                          
       #No.MOD-580323 --end--       
    END IF                                       #No.FUN-570115
    LET p_bng.bng01=p_bnf.bnf01
    LET p_bng.bng02=p_bnf.bnf02
    LET p_bng.bng03=g_yy
    LET p_bng.bng04=g_mm
    LET l_found='N'
    CALL p830_bom(1,p_bnf.bnf01,1)
    IF l_found='N' THEN     ## 找不到BOM
       LET p_bng.bng05=p_bng.bng01
       LET p_bng.bng06=0
       LET p_bng.bng07=1
       LET p_bng.bng08=p_bnf.bnf10
 
       LET p_bng.bngplant = g_plant  #FUN-980001 add
       LET p_bng.bnglegal = g_legal  #FUN-980001 add
 
       INSERT INTO bng_file VALUES(p_bng.*)
    END IF
  END FOREACH
# 彙總內銷用料
  DECLARE p830_s1_c6 CURSOR FOR
    SELECT bng05,SUM(bng08) FROM bng_file 
     WHERE bng03=g_yy AND bng04=g_mm GROUP BY bng05
  FOREACH p830_s1_c6 INTO l_bng05,l_bng08
     IF g_bgjob="N" THEN                       #No.FUN-570115
        #No.MOD-580323 --start--                                                       
        CALL cl_getmsg('abx-833',g_lang) RETURNING l_str3                           
        MESSAGE l_str3,l_bng05                                                      
#       MESSAGE "匯總內銷用料:",l_bng05                                            
        #No.MOD-580323 --end--    
     END IF                                    #No.FUN-570115
     IF STATUS THEN CALL cl_err('foreach4',STATUS,1) LET g_success = 'N' RETURN END IF
     IF l_bng05 IS NULL THEN CONTINUE FOREACH END IF
     IF l_bng08 IS NULL THEN LET l_bng08=0 END IF
     LET p_bnf.bnf01=l_bng05
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
 
        LET p_bnf.bnfplant = g_plant  #FUN-980001 add
        LET p_bnf.bnflegal = g_legal  #FUN-980001 add
 
        INSERT INTO bnf_file VALUES(p_bnf.*)
     END IF
     LET p_bnf.bnf11=l_bng08
     LET p_bnf.bnf12=p_bnf.bnf12-p_bnf.bnf11
     UPDATE bnf_file SET bnf11=p_bnf.bnf11,bnf12=p_bnf.bnf12
      WHERE bnf01=p_bnf.bnf01 AND bnf02=p_bnf.bnf02
        AND bnf03=p_bnf.bnf03 AND bnf04=p_bnf.bnf04
  END FOREACH
  IF g_bgjob="N" THEN                         #No.FUN-570115
     MESSAGE " "
  END IF                                      #No.FUN-570115
END FUNCTION
 
FUNCTION p830_bom(p_level,p_key,p_total)
   DEFINE p_level       LIKE type_file.num5,       #No.FUN-680062  smallint
          p_key		LIKE bma_file.bma01,  #主件料件編號
          p_total       LIKE bmb_file.bmb06,  #FUN-560231
          l_ac,i	LIKE type_file.num5,          #No.FUN-680062
          arrno         LIKE type_file.num5,    #BUFFER SIZE (可存筆數)  #No.FUN-680062 SMALLINT
          l_chr		LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              level LIKE type_file.num5,       #No.FUN-680062 SMALLINT
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb06 LIKE bmb_file.bmb06,    #QPA/BASE
              bmb13 LIKE bmb_file.bmb13,    #插件位置
               bma01 LIKE bma_file.bma01     #NO.MOD-490217
          END RECORD,
          sr2     RECORD 
                            bmb01   LIKE bmb_file.bmb01,
                            bmb03   LIKE bmb_file.bmb03,    #元件
                            ima02   LIKE ima_file.ima02,    #品名規格
                            bmb06   LIKE bmb_file.bmb06,    #QPA   
                            ima08   LIKE ima_file.ima08     #來源碼
                  END RECORD,
          l_cmd	  LIKE type_file.chr1000                                 #No.FUN-680062
 
	IF p_level > 20 THEN 
           CALL cl_err('','mfg2733',1)
           CALL cl_batch_bg_javamail("N")             #No.FUN-570115
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM
	END IF
    LET p_level = p_level + 1
    LET arrno = 600			#95/12/21 Modify By Lynn
    LET l_cmd= "SELECT 0, bne03, bne05, bne08, ' ', bnd01",
               "  FROM bne_file, bnd_file",
               " WHERE bnd01='", p_key,"' AND bne01 = bnd01 ",
               " AND bnd02=bne02 AND bne09='Y' " 
    #---->生效日及失效日的判斷
    IF g_edate IS NOT NULL THEN
        LET l_cmd=l_cmd CLIPPED,
                  " AND (bnd02 <='",g_edate,"' OR bnd02 IS NULL)",
                  " AND (bnd03 > '",g_edate,"' OR bnd03 IS NULL)"
    END IF
    LET l_cmd = l_cmd CLIPPED, ' ORDER BY bne03'
    PREPARE p830_cur FROM l_cmd
    DECLARE p830_s1 CURSOR FOR p830_cur      
    IF SQLCA.sqlcode THEN
       CALL cl_err('P1:',STATUS,1)
       LET g_success = 'N'
       CALL cl_batch_bg_javamail("N")           #No.FUN-570115
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
    END IF
    LET l_ac = 1
    FOREACH p830_s1  INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
        LET l_ac = l_ac + 1
        IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    FOR i = 1 TO l_ac-1    	        	# 讀BUFFER傳給REPORT
        LET sr[i].level = p_level
        LET sr[i].bmb06=p_total*sr[i].bmb06
        SELECT bnd01 FROM bnd_file WHERE bnd01=sr[i].bmb03 AND 
                   (bnd02 <=g_edate OR bnd02 IS NULL)
                   AND (bnd03 >g_edate OR bnd03 IS NULL)
        IF STATUS=0 			#若為主件
           THEN CALL p830_bom(p_level,sr[i].bmb03,sr[i].bmb06)
           ELSE 
                LET p_bng.bng05=sr[i].bmb03
                LET p_bng.bng06=sr[i].bmb02
                LET p_bng.bng07=sr[i].bmb06
                LET p_bng.bng08=p_bng.bng07*p_bnf.bnf10
 
                LET p_bng.bngplant = g_plant  #FUN-980001 add
                LET p_bng.bnglegal = g_legal  #FUN-980001 add
 
                INSERT INTO bng_file VALUES (p_bng.*)
                LET l_found='Y'
        END IF
    END FOR
END FUNCTION
 
