# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: acop300.4gl
# Descriptions...: 保稅料件折合計算作業
# Date & Author..: 02/12/25 By Danny
# Modify.........: No.MOD-490398 04/11/25 By Carrier 
#                  add img01 
# Modify.........: No.FUN-550100 05/05/25 By ching 特性BOM功能修改
# Modify.........: No.FUN-560231 05/06/27 By Mandy QPA欄位放大
# Modify.........: No.FUN-570116 06/02/27 By yiting 批次背景執行
# Modify.........: No.TQC-660045 06/06/12 By hellen cl_err --> cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: no.TQC-790093 07/09/20 by Yiting  Primary Key的-268訊息 程式修改
# Modify.........: no.MOD-850157 08/05/15 by Dido 檢核倉儲批欄位
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.TQC-950025 09/06/09 By baofei 解決溢位問題
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-970407 09/08/21 By destiny 1.check()中抓ima910的where條件不對                                             
#                                                    2.向coq_file新增資料時，沒給coq02賦值，但coq02是not null                       
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B60093 11/06/10 By sabrina 在製工單應抓出倉庫
# Modify.........: No:FUN-BB0083 11/12/26 By xujing 增加數量欄位小數取位 coq_file
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_sql       STRING  #No.FUN-580092 HCN        #No.FUN-680069
DEFINE g_coq       RECORD LIKE coq_file.*
DEFINE g_wc        STRING  #No.FUN-580092 HCN        #No.FUN-680069
DEFINE tm          RECORD 
                   wc     LIKE type_file.chr1000,    #No.FUN-680069 VARCHAR(300)
                   a      LIKE type_file.chr1        #No.FUN-680069 VARCHAR(01)
                   END RECORD 
DEFINE g_tot       LIKE type_file.num10        #No.FUN-680069 INTEGER
DEFINE g_chk       LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)  #n.檢查         y.檢查且異動資料
DEFINE g_type      LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)  #1.成品/半成品  2.在製
DEFINE g_change_lang LIKE type_file.chr1       # Prog. Version..: '5.30.06-13.03.12(01)  #No.FUN-570116
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0063
  #DEFINE p_row,p_col  LIKE type_file.num5              #No.FUN-570116        #No.FUN-680069 SMALLINT
   DEFINE l_flag        LIKE type_file.chr1              #No.FUN-570116        #No.FUN-680069 VARCHAR(1)
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    #No.FUN-570116--start--
    INITIALIZE g_bgjob_msgfile TO NULL
    LET tm.wc = ARG_VAL(1)
    LET tm.a  = ARG_VAL(2)
    LET g_bgjob = ARG_VAL(3)
    IF cl_null(g_bgjob)THEN
       LET g_bgjob="N"
    END IF
    #No.FUN-570116--end--
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
 
#NO.FUN-570116 START---
#    LET p_row = 6 LET p_col = 30
 
#    OPEN WINDOW p300_w AT p_row,p_col WITH FORM "aco/42f/acop300" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
#    CALL cl_opmsg('z')
#    CALL p300_t()
#    CLOSE WINDOW p300_w
WHILE TRUE
    IF g_bgjob="N" THEN
        CALL p300_t()
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success='Y'
           BEGIN WORK
           CALL p300_cur()
           IF g_success='Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p300_w
              EXIT WHILE
           END IF
        ELSE
            CONTINUE WHILE
       END IF
    ELSE
       LET g_success='Y'
       BEGIN WORK
       CALL p300_cur()
       IF g_success="Y" THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
    END IF
 END WHILE
 #No.FUN-570116--end--
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION p300_t()
 #DEFINE l_wc,l_sql   STRING, #No.FUN-570116        #No.FUN-680069
 #       l_i          LIKE type_file.num5    #No.FUN-750116        #No.FUN-680069 SMALLINT
  DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-570116        #No.FUN-680069 SMALLINT
  DEFINE lc_cmd       LIKE type_file.chr1000 #No.FUN-680069 VARCHAR(500) #No.FUN-570116
 
  #No.FUN-570116--start--
      LET p_row = 6  LET p_col =30
      OPEN WINDOW p300_w AT p_row,p_col WITH FORM "aco/42f/acop300"
        ATTRIBUTE(STYLE=g_win_style)
      CALL cl_ui_init()
      CLEAR FORM
  #No.FUN-570116--end--
 
 LET tm.a = 'N'
 LET g_bgjob = "N" #No.FUN-570116
 
 WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON img01,img02,img03,img04  #No.MOD-490398
 
     ON ACTION locale
         LET g_change_lang = TRUE        #->No.FUN-570116
#NO.FUN-570116
#        CALL cl_dynamic_locale()
#        CALL cl_show_fld_cont()   #FUN-550037(smin)
         EXIT CONSTRUCT
#NO.FUN-570116
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.FUN-570611--start--
      IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
        CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
            LET INT_FLAG=0
            CLOSE WINDOW p300_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
            EXIT PROGRAM
      END IF
#No.FUN-570116--end--
 
   #INPUT BY NAME tm.a WITHOUT DEFAULTS 
   INPUT BY NAME tm.a,g_bgjob  WITHOUT DEFAULTS   #NO.FUN-570116
 
 
#      ON ACTION locale
#        CALL cl_dynamic_locale()
#        CALL cl_show_fld_cont()   #FUN-550037(smin)
       ON ACTION locale
          LET g_change_lang = TRUE        #->No.FUN-570116
          EXIT INPUT
 
      AFTER FIELD a 
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN NEXT FIELD a END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT 
#No.FUN-570611--start--
      IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
        CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
            LET INT_FLAG=0
            CLOSE WINDOW p300_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
            EXIT PROGRAM
      END IF
   #No.FUN-570116--end--
 
#NO.FUN-570116 START---
#   IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
#   IF NOT cl_sure(0,0) THEN CONTINUE WHILE END IF
#   LET l_wc = tm.wc
#    #No.MOD-490398  --begin
#   FOR l_i = 1 TO 296
#       IF l_wc[l_i,l_i+4] = 'img01' THEN LET l_wc[l_i,l_i+4] = 'coq01' END IF
#       IF l_wc[l_i,l_i+4] = 'img02' THEN LET l_wc[l_i,l_i+4] = 'coq03' END IF
#       IF l_wc[l_i,l_i+4] = 'img03' THEN LET l_wc[l_i,l_i+4] = 'coq04' END IF
#       IF l_wc[l_i,l_i+4] = 'img04' THEN LET l_wc[l_i,l_i+4] = 'coq05' END IF
#   END FOR
#   LET g_wc = "(",l_wc CLIPPED,")"
#   LET l_wc = tm.wc
#   FOR l_i = 1 TO 296
#       IF l_wc[l_i,l_i+4] = 'img01' THEN LET l_wc[l_i,l_i+4] = 'coq02' END IF
#       IF l_wc[l_i,l_i+4] = 'img02' THEN LET l_wc[l_i,l_i+4] = 'coq03' END IF
#       IF l_wc[l_i,l_i+4] = 'img03' THEN LET l_wc[l_i,l_i+4] = 'coq04' END IF
#       IF l_wc[l_i,l_i+4] = 'img04' THEN LET l_wc[l_i,l_i+4] = 'coq05' END IF
#   END FOR
#   IF NOT cl_null(l_wc) THEN
#      LET g_wc = g_wc CLIPPED," OR (",l_wc CLIPPED,")"
#   END IF
#    #No.MOD-490398  --end   
#   CALL cl_wait()
#   BEGIN WORK
#   LET g_success='Y'
#    LET l_sql = "DELETE FROM coq_file WHERE ",g_wc CLIPPED  #No.MOD-490398
#   PREPARE del_pre FROM l_sql
#   IF STATUS THEN CALL cl_err('del_pre',STATUS,0) LET g_success='N' END IF
#   EXECUTE del_pre 
#   IF STATUS THEN CALL cl_err('del_curs',STATUS,0) LET g_success='N' END IF
#   DELETE FROM coq_file WHERE coq00='1'
#   IF STATUS THEN CALL cl_err('del coq00=1',STATUS,0) END IF
#   CALL p300_p() 
#   IF g_success='Y' THEN
#      COMMIT WORK CALL cl_cmmsg(1)
#   ELSE 
#      ROLLBACK WORK CALL cl_rbmsg(1)
#   END IF
 #No.FUN-570116--start--
    IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "acop300"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('acop300','9031',1)
        ELSE
         LET tm.wc = cl_replace_str(tm.wc,"'","\"")
         LET lc_cmd = lc_cmd CLIPPED,
                   " '",tm.wc CLIPPED,"'",
                   " '",tm.a CLIPPED,"'",
                   " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('acop300',g_time,lc_cmd CLIPPED)
       END IF
         CLOSE WINDOW p300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
     END IF
   EXIT WHILE
   #No.FUN-570116--end---
 
 END WHILE
END FUNCTION
 
#NO.FUN-570116 
FUNCTION p300_cur()
 DEFINE l_sql,l_wc   LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(300)
 DEFINE l_i          LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   LET l_wc = tm.wc
    #No.MOD-490398  --begin
#TQC-950025---BEGEIN                                                            
#   FOR l_i = 1 TO 296                                                          
#       IF l_wc[l_i,l_i+4] = 'img01' THEN LET l_wc[l_i,l_i+4] = 'coq01' END IF  
#       IF l_wc[l_i,l_i+4] = 'img02' THEN LET l_wc[l_i,l_i+4] = 'coq03' END IF  
#       IF l_wc[l_i,l_i+4] = 'img03' THEN LET l_wc[l_i,l_i+4] = 'coq04' END IF  
#       IF l_wc[l_i,l_i+4] = 'img04' THEN LET l_wc[l_i,l_i+4] = 'coq05' END IF  
#   END FOR                                                                     
    LET l_wc=cl_replace_str(l_wc,"img01","coq01")                               
    LET l_wc=cl_replace_str(l_wc,"img02","coq03")                               
    LET l_wc=cl_replace_str(l_wc,"img03","coq04")                               
    LET l_wc=cl_replace_str(l_wc,"img04","coq05")                               
#TQC-950025---END     
   LET g_wc = "(",l_wc CLIPPED,")"
   LET l_wc = tm.wc
#TQC-950025---BEGIN                                                             
#   FOR l_i = 1 TO 296                                                          
#       IF l_wc[l_i,l_i+4] = 'img01' THEN LET l_wc[l_i,l_i+4] = 'coq02' END IF  
#       IF l_wc[l_i,l_i+4] = 'img02' THEN LET l_wc[l_i,l_i+4] = 'coq03' END IF  
#       IF l_wc[l_i,l_i+4] = 'img03' THEN LET l_wc[l_i,l_i+4] = 'coq04' END IF  
#       IF l_wc[l_i,l_i+4] = 'img04' THEN LET l_wc[l_i,l_i+4] = 'coq05' END IF  
#   END FOR                                                                     
    LET l_wc=cl_replace_str(l_wc,"img01","coq02")                               
    LET l_wc=cl_replace_str(l_wc,"img02","coq03")                               
    LET l_wc=cl_replace_str(l_wc,"img03","coq04")                               
    LET l_wc=cl_replace_str(l_wc,"img04","coq05")                               
#TQC-950025---END  
   IF NOT cl_null(l_wc) THEN
      LET g_wc = g_wc CLIPPED," OR (",l_wc CLIPPED,")"
   END IF
    #No.MOD-490398  --end   
   CALL cl_wait()
   BEGIN WORK
   LET g_success='Y'
    LET l_sql = "DELETE FROM coq_file WHERE ",g_wc CLIPPED  #No.MOD-490398
   PREPARE del_pre FROM l_sql
   IF STATUS THEN CALL cl_err('del_pre',STATUS,0) LET g_success='N' END IF
   EXECUTE del_pre 
   IF STATUS THEN CALL cl_err('del_curs',STATUS,0) LET g_success='N' END IF
   DELETE FROM coq_file WHERE coq00='1'
   IF STATUS THEN 
#  CALL cl_err('del coq00=1',STATUS,0)  #No.TQC-660045
   CALL cl_err3("del","coq_file",g_coq.coq00,"",STATUS,"","del coq00=1",0) #TQC-660045
   END IF
   CALL p300_p() 
END FUNCTION
#NO.FUN-570116  END--
 
FUNCTION p300_p()   
 DEFINE l_cnt       LIKE type_file.num5          #No.FUN-680069 SMALLINT
  DEFINE l_n        LIKE type_file.num5     #MOD-490398        #No.FUN-680069 SMALLINT
  DEFINE l_sw       LIKE type_file.chr1         #No.FUN-680069 VARCHAR(1)   #MOD-490398
  DEFINE l_fac      LIKE bmb_file.bmb10_fac   #MOD-490398
  DEFINE l_sfb081   LIKE sfb_file.sfb081      #MOD-490398
  DEFINE l_ima55    LIKE ima_file.ima55       #MOD-490398
 DEFINE l_ima910    LIKE ima_file.ima910      #FUN-550100
 DEFINE l_flag      LIKE type_file.num5         #No.FUN-680069 SMALLINT
 DEFINE sr          RECORD
                    img01   LIKE img_file.img01,
                    img02   LIKE img_file.img02,
                    img03   LIKE img_file.img03,
                    img04   LIKE img_file.img04,
                    img09   LIKE img_file.img09,
                    img10   LIKE img_file.img10,
                    ima08   LIKE ima_file.ima08,
                    cob01   LIKE cob_file.cob01 
                    END RECORD
 DEFINE sr2         RECORD
                    sfb01   LIKE sfb_file.sfb01,
                    sfb05   LIKE sfb_file.sfb05,
                    sfb08   LIKE sfb_file.sfb08,
                    sfb09   LIKE sfb_file.sfb09,
                    sfa03   LIKE sfa_file.sfa03,
                    sfa06   LIKE sfa_file.sfa06,
                    sfa12   LIKE sfa_file.sfa12,
                    sfa161  LIKE sfa_file.sfa161,
                    qty1    LIKE sfa_file.sfa05,   
                    qty2    LIKE sfa_file.sfa05,
                    cob01   LIKE cob_file.cob01,
                    ima08   LIKE ima_file.ima08,
                    sfa08   LIKE sfa_file.sfa08          #MOD-B60093 add
                    END RECORD
 
 #No.MOD-490398  --begin
   #LET g_sql = " SELECT img01,img02,img03,img04,img09,img10,ima08,cob01 ",
   #            "   FROM img_file,ima_file,OUTER cob_file ",
   LET g_sql = " SELECT img01,img02,img03,img04,img09,img10,ima08,'' ",
               "   FROM img_file,ima_file",
               "  WHERE ima01 = img01 ",
               "    AND img10 > 0 ",
               "    AND ima08 IN ('P','M','S') ",
               "    AND imaacti = 'Y' ",
               "    AND img25 = 'Y' ",        #保稅倉
   #            "    AND cob_file.cob01 = ima75 ",
               "    AND ",tm.wc CLIPPED 
 #No.MOD-490398  --end    
 
   PREPARE p300_pre1 FROM g_sql
   IF STATUS THEN 
      CALL cl_err('p300_pre1',STATUS,1)
      LET g_success='N' 
      CALL cl_batch_bg_javamail("N") #No.FUN-570116
      RETURN 
   END IF
   DECLARE p300_cs1 CURSOR FOR p300_pre1
   FOREACH p300_cs1 INTO sr.*
     IF STATUS THEN 
        CALL cl_err('foreach:',STATUS,1) 
        LET g_success='N' 
        EXIT FOREACH 
     END IF
     INITIALIZE g_coq.* TO NULL
     #原料
     IF sr.ima08 = 'P' THEN
         #No.MOD-490398  --begin
        LET l_n = 0
        SELECT COUNT(*) INTO l_n FROM coa_file,cob_file
         WHERE coa01=sr.img01 AND coa03=cob01
        IF l_n = 0 THEN CONTINUE FOREACH END IF   #不為保稅料件
#        IF cl_null(sr.cob01) THEN CONTINUE FOREACH END IF   #不為保稅料件
         #No.MOD-490398  --end     
        LET g_coq.coq00 = '0'
        LET g_coq.coq01 = sr.img01
        LET g_coq.coq03 = sr.img02
        LET g_coq.coq04 = sr.img03
        LET g_coq.coq05 = sr.img04
        LET g_coq.coq06 = sr.img09
        LET g_coq.coq07 = sr.img10
        LET g_coq.coqplant = g_plant #FUN-980002
        LET g_coq.coqlegal = g_legal #FUN-980002
        LET g_coq.coq02 =' '                        #No.TQC-970407       
        #---- MOD-850157---
       #IF cl_null(g_coq.coq03) THEN      #MOD-B60093 mark
        IF g_coq.coq03 IS NULL THEN       #MOD-B60093 add
           CALL cl_err(g_coq.coq03,'asf-770',1)
           LET g_success = 'N' EXIT FOREACH
        END IF 
        IF cl_null(g_coq.coq04) THEN
           LET g_coq.coq04 = ' '
        END IF 
        IF cl_null(g_coq.coq05) THEN
           LET g_coq.coq05 = ' '
        END IF 
        #---- END MOD-850157---
        INSERT INTO coq_file VALUES(g_coq.*)
        IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#          CALL cl_err('ins coq',STATUS,1) #No.TQC-660045
           CALL cl_err3("ins","coq_file",g_coq.coq00,g_coq.coq01,STATUS,"","ins coq",1) #TQC-660045
           LET g_success = 'N' EXIT FOREACH
        END IF
     END IF
     #成品/半成品
     IF sr.ima08 MATCHES '[MS]' THEN
        SELECT COUNT(*) INTO l_cnt FROM bmb_file WHERE bmb03 = sr.img01 
 #No.MOD-490398  --begin
        LET l_n = 0
        SELECT COUNT(*) INTO l_n FROM coa_file,cob_file
         WHERE coa01=sr.img01 AND coa03=cob01
        IF l_cnt > 0 AND l_n = 0  THEN 
        #IF l_cnt > 0 AND cl_null(sr.cob01) THEN 
 #No.MOD-490398  --end    
           CALL p300_check(sr.img01) RETURNING l_flag
           IF l_flag THEN CONTINUE FOREACH END IF              #不為保稅料件
           LET g_coq.coq00 = '2'     #半成品
        ELSE
 #No.MOD-490398  --begin
           LET l_n = 0
           SELECT COUNT(*) INTO l_n FROM coa_file,cob_file
            WHERE coa01=sr.img01 AND coa03=cob01
           IF l_n = 0 THEN CONTINUE FOREACH END IF
           #IF cl_null(sr.cob01) THEN CONTINUE FOREACH END IF   #不為保稅料件
 #No.MOD-490398  --end    
           LET g_coq.coq00 = '3'     #成品
        END IF
        LET g_coq.coq02 = sr.img01
        LET g_coq.coq03 = sr.img02
        LET g_coq.coq04 = sr.img03
        LET g_coq.coq05 = sr.img04
        LET g_coq.coq06 = sr.img09
        LET g_coq.coq07 = sr.img10
        LET g_chk = 'y'
        LET g_type = '1'             #成品/半成品
        #FUN-550100
        SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=sr.img01
        IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
        #--
         #No.MOD-490398  --begin
        CALL p300_bom(0,sr.img01,l_ima910,sr.img10,1,1,1)    #依實際BOM展開
         #No.MOD-490398  --end    
        IF g_success='N' THEN EXIT FOREACH END IF
     END IF
   END FOREACH
   IF g_success='N' THEN RETURN END IF
   #在制工單
 #No.MOD-490398  --begin  
   LET g_sql = " SELECT sfb01,sfb05,sfb08,sfb09,sfa03,sfa06+sfa062,sfa12,",
               #"        sfa161,sfa161*sfb09,0,cob01,ima08 ",
               #"   FROM sfb_file,sfa_file,ima_file,OUTER cob_file ",
               "        sfa161,sfa161*sfb09,0,'',ima08,sfa08 ",       #MOD-B60093 add sfa08
               "   FROM sfb_file,sfa_file,ima_file ",
               "  WHERE sfa01 = sfb01 ",
               "    AND sfb02 != 11 AND sfb02 != 13 ",
               "    AND sfb04 IN ('4','5','6','7') ",
               "    AND sfa06+sfa062 > 0 ",
               "    AND sfb87 = 'Y' ",
               "    AND ima01 = sfa03 " 
               #"    AND cob_file.cob01 = ima75 "
 #No.MOD-490398  --end    
   PREPARE p300_pre2 FROM g_sql
   IF STATUS THEN 
      CALL cl_err('p300_pre2',STATUS,1) LET g_success='N' RETURN 
   END IF
   DECLARE p300_cs2 CURSOR FOR p300_pre2
   FOREACH p300_cs2 INTO sr2.*
     IF STATUS THEN 
        CALL cl_err('foreach #2:',STATUS,1) LET g_success='N' EXIT FOREACH 
     END IF
 #No.MOD-490398  --begin
     LET l_n = 0
     IF cl_null(sr2.sfa08) THEN LET sr2.sfa08=' ' END IF    #MOD-B60093 add
     SELECT COUNT(*) INTO l_n FROM coa_file,cob_file
      WHERE coa01=sr2.sfa03 AND coa03=cob01
     IF sr2.ima08 = 'P' AND l_n = 0 THEN CONTINUE FOREACH END IF   #不為保稅料件
#     IF sr2.ima08 = 'P' AND cl_null(sr2.cob01) THEN         #不為保稅料件
#        CONTINUE FOREACH
#     END IF
 #No.MOD-490398  --end     
     INITIALIZE g_coq.* TO NULL
     LET g_coq.coq00 = '1'
     LET g_coq.coq01 = sr2.sfa03
     LET g_coq.coq02 = sr2.sfb01
     LET g_coq.coq03 = sr2.sfa08      #MOD-B60093 add
     LET g_coq.coq08 = sr2.sfa161
     LET g_coq.coq11 = sr2.sfb05                
     LET g_coq.coq12 = sr2.sfb08                #生產量
     LET g_coq.coq13 = sr2.sfb09                #完工量
     LET g_coq.coq14 = sr2.sfa06                #已發數量
     LET g_coq.coq15 = sr2.qty1                 #已轉出量=組成用量*已入庫量
     LET g_coq.coq16 = sr2.sfa12
     LET g_coq.coq13 = s_digqty(g_coq.coq13,g_coq.coq16) #FUN-BB0083 add 
     LET g_coq.coq17 = sr2.sfa06 - sr2.qty1     #在制量=已發數量-已轉出量    
     LET g_coq.coqplant = g_plant #FUN-980002
     LET g_coq.coqlegal = g_legal #FUN-980002
     IF sr2.ima08 MATCHES '[MS]' THEN
        CALL p300_check(sr2.sfa03) RETURNING l_flag
        IF l_flag THEN CONTINUE FOREACH END IF              #不為保稅料件
        LET g_chk = 'y'
        LET g_type = '2'                                    #在製
         #No.MOD-490398  by carrier
        LET l_fac = 1
        SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=sr2.sfa03    
 
 
        IF l_ima55 !=sr2.sfa12 THEN
           CALL s_umfchk(sr2.sfa03,sr2.sfa12,l_ima55)
                 RETURNING l_sw, l_fac    #單位換算
           IF l_sw  = '1'  THEN #有問題
              CALL cl_err(sr2.sfa03,'abm-731',1)
              LET l_fac = 1
           END IF
        END IF
        #FUN-550100
        LET l_ima910=''
        SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=sr2.sfa03
        IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
        #--
        #在製量=已發量-(完工量*QPA)
        CALL p300_bom(0,sr2.sfa03,l_ima910,(sr2.sfa06-sr2.qty1)*l_fac,1*l_fac*sr2.sfa161,sr2.sfa06*l_fac,sr2.qty1*l_fac)     #依實際BOM展開  #FUN-550100
         #No.MOD-490398  end
        CONTINUE FOREACH
     END IF
     IF g_coq.coq17 = 0 THEN CONTINUE FOREACH END IF
     #---- MOD-850157---
    #IF cl_null(g_coq.coq03) THEN      #MOD-B60093 mark
     IF g_coq.coq03 IS NULL THEN       #MOD-B60093 add
        CALL cl_err(g_coq.coq03,'asf-770',1)
        LET g_success = 'N' EXIT FOREACH
     END IF 
     IF cl_null(g_coq.coq04) THEN
        LET g_coq.coq04 = ' '
     END IF 
     IF cl_null(g_coq.coq05) THEN
        LET g_coq.coq05 = ' '
     END IF 
     #---- END MOD-850157---
     INSERT INTO coq_file VALUES(g_coq.*)
#     IF STATUS AND STATUS != -239 THEN
      IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN   #NO.TQC-790093
#       CALL cl_err('ins coq#3',STATUS,1)  #No.TQC-660045
        CALL cl_err3("ins","coq_file",g_coq.coq00,g_coq.coq01,STATUS,"","ins coq#3",1) #TQC-660045
        LET g_success = 'N' EXIT FOREACH
     END IF
     #IF STATUS = -239 THEN
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #no.TQC-790093
        UPDATE coq_file SET coq14 = coq14 + g_coq.coq14,
                            coq15 = coq15 + g_coq.coq15,
                            coq17 = coq17 + g_coq.coq17
         WHERE coq00 = g_coq.coq00
           AND coq01 = g_coq.coq01
           AND coq02 = g_coq.coq02
        IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#          CALL cl_err('upd coq#3',STATUS,1)  #No.TQC-660045
           CALL cl_err3("upd","coq_file",g_coq.coq00,g_coq.coq01,STATUS,"","upd coq#3",1) #TQC-660045
           LET g_success = 'N' EXIT FOREACH
        END IF
     END IF
   END FOREACH
END FUNCTION
 
FUNCTION p300_check(p_part)
   DEFINE p_part       LIKE bma_file.bma01
   DEFINE l_ima910     LIKE ima_file.ima910         #FUN-550100
   DEFINE l_flag       LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
   DEFINE l_cnt        LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   LET g_tot = 0
   LET g_chk = 'n'     #表只檢查，不INSERT/UPDATE資料
   #FUN-550100
#  SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=sr.ima01                #No.TQC-97040
   SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=p_part                  #No.TQC-97040
   IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
   #--
    #No.MOD-490398  --begin
   CALL p300_bom(0,p_part,l_ima910,1,1,1,1)  #FUN-550100
    #No.MOD-490398  --end   
   IF g_tot > 0 THEN RETURN 0 ELSE RETURN 1 END IF
END FUNCTION
 
 #No.MOD-490398  --begin
FUNCTION p300_bom(p_level,p_key,p_key2,p_total,p_QPA,p_coq14,p_coq15)
 #No.MOD-490398  --end    
   DEFINE p_level	LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          p_key		LIKE bma_file.bma01,  #主件料件編號
          p_key2	LIKE ima_file.ima910,   #FUN-550100
          p_QPA,l_QPA   LIKE bmb_file.bmb06,
          p_coq14       LIKE coq_file.coq14,  #N.MOD-490398
          l_coq14       LIKE coq_file.coq14,  #N.MOD-490398
          p_coq15       LIKE coq_file.coq15,  #N.MOD-490398
          l_coq15       LIKE coq_file.coq15,  #N.MOD-490398
          p_total       LIKE coq_file.coq10,  #FUN-560231
          l_total       LIKE coq_file.coq10,  #FUN-560231
          l_ac,i	LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          arrno		LIKE type_file.num5,         #No.FUN-680069 SMALLINT	#BUFFER SIZE (可存筆數)
          l_chr,l_sw    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
          l_fac         LIKE bmb_file.bmb10_fac,  #MOD-490398
          l_n           LIKE type_file.num5,    #MOD-490398        #No.FUN-680069 SMALLINT
          l_cnt 	LIKE type_file.num5,          #No.FUN-680069 SMALLINT
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              level	LIKE type_file.num5,         #No.FUN-680069 SMALLINT
              bmb02     LIKE bmb_file.bmb02,    #項次
              bmb03     LIKE bmb_file.bmb03,    #元件料號
              bmb06     LIKE bmb_file.bmb06,    #QPA/BASE
              bmb08     LIKE bmb_file.bmb08,    #損耗率 
              bmb10     LIKE bmb_file.bmb10,    #發料單位
              bma01     LIKE bma_file.bma01
          END RECORD,
          l_ima25       LIKE ima_file.ima25,
          l_ima55       LIKE ima_file.ima55,
          l_factor      LIKE bmb_file.bmb10_fac,
          l_cmd		LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(600)
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
	
    IF p_level > 20 THEN 
       CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
          
    END IF
    LET p_level = p_level + 1
    LET arrno = 600			
    LET l_cmd= "SELECT 0, bmb02, bmb03, (bmb06/bmb07),bmb08,bmb10, bma01",
               "  FROM bmb_file LEFT OUTER JOIN bma_file ON bmb_file.bmb03 = bma_file.bma01",
               " WHERE bmb01='", p_key,"' ",
               "   AND bmb29 ='",p_key2,"' "  #FUN-550100
    #---->生效日及失效日的判斷
     LET l_cmd=l_cmd CLIPPED,
               " AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
               " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"
    LET l_cmd = l_cmd CLIPPED, ' ORDER BY bmb02'
    PREPARE p300_precur FROM l_cmd
    IF SQLCA.sqlcode THEN 
        CALL cl_err('P1:',STATUS,1) 
        CALL cl_batch_bg_javamail("N")    #No.FUN-570116
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
    END IF
    DECLARE p300_cur CURSOR FOR p300_precur 
    LET l_ac = 1
    FOREACH p300_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
        #FUN-8B0035--BEGIN--                                                                                                    
        LET l_ima910[l_ac]=''
        SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
        IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
        #FUN-8B0035--END--
        LET l_ac = l_ac + 1
        IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    FOR i = 1 TO l_ac-1    	        	# 讀BUFFER傳給REPORT
        LET sr[i].level = p_level
         #No.MOD-490398  by carrier
        LET l_fac = 1
        SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=sr[i].bmb03
        IF l_ima55 !=sr[i].bmb10 THEN
           CALL s_umfchk(sr[i].bmb03,sr[i].bmb10,l_ima55)
                 RETURNING l_sw, l_fac    #單位換算
           IF l_sw  = '1'  THEN #有問題
              CALL cl_err(sr[i].bmb03,'abm-731',1)
              LET l_fac = 1
           END IF
        END IF
        LET sr[i].bmb06=sr[i].bmb06*l_fac
        IF g_type = '1' AND tm.a = 'Y' THEN       #含損耗率
           LET l_total = p_total * sr[i].bmb06 * (1+sr[i].bmb08/100)
           LET l_QPA = (sr[i].bmb06 * (1+sr[i].bmb08/100)) * p_QPA 
           LET l_coq14 = p_coq14 * sr[i].bmb06 * (1+sr[i].bmb08/100)
           LET l_coq15 = p_coq15 * sr[i].bmb06 * (1+sr[i].bmb08/100)
        ELSE
           LET l_total = p_total * sr[i].bmb06
           LET l_QPA = sr[i].bmb06 * p_QPA 
           LET l_coq14 = p_coq14 * sr[i].bmb06
           LET l_coq15 = p_coq15 * sr[i].bmb06
        END IF
         #No.MOD-490398  end
        IF sr[i].bma01 IS NOT NULL THEN           #若為主件
           #CALL p300_bom(p_level,sr[i].bmb03,' ',l_total,l_QPA,1,1) #No.MOD-490398  #FUN-550100#FUN-8B0035
            CALL p300_bom(p_level,sr[i].bmb03,l_ima910[i],l_total,l_QPA,1,1) #FUN-8B0035
        ELSE
 #No.MOD-490398  --begin
           #SELECT ima01 FROM ima_file,cob_file
           # WHERE ima01 = sr[i].bmb03 AND cob01 = ima75 
           #IF STATUS THEN CONTINUE FOR END IF        #沒有對應的海關編號
           LET l_n = 0
           SELECT COUNT(*) INTO l_n FROM coa_file,cob_file
            WHERE coa01=sr[i].bmb03 AND coa03=cob01
           IF l_n = 0 THEN CONTINUE FOR END IF   #不為保稅料件
 #No.MOD-490398  --end     
           LET g_tot = g_tot + 1
           IF g_chk = 'n' THEN CONTINUE FOR END IF   #只檢查，不異動資料
           LET g_coq.coqplant = g_plant #FUN-980002
           LET g_coq.coqlegal = g_legal #FUN-980002
           IF g_type = '1' THEN        #成品/半成品
                LET g_coq.coq01 = sr[i].bmb03
                LET g_coq.coq08 = l_QPA
 #No.MOD-490398  --begin
                #LET g_coq.coq09 = sr[i].bmb10
                LET g_coq.coq09 = l_ima55 
                LET g_coq.coq12 = s_digqty(g_coq.coq12,g_coq.coq09) #FUN-BB0083 add
 #No.MOD-490398  --end     
                LET g_coq.coq10 = l_total
                LET g_coq.coq10 = s_digqty(g_coq.coq10,g_coq.coq09) #FUN-BB0083 add
                #---- MOD-850157---
               #IF cl_null(g_coq.coq03) THEN      #MOD-B60093 mark
                IF g_coq.coq03 IS NULL THEN       #MOD-B60093 add
                   CALL cl_err(g_coq.coq03,'asf-770',1)
                   LET g_success = 'N' EXIT FOR
                END IF 
                IF cl_null(g_coq.coq04) THEN
                   LET g_coq.coq04 = ' '
                END IF 
                IF cl_null(g_coq.coq05) THEN
                   LET g_coq.coq05 = ' '
                END IF 
                #---- END MOD-850157---
                INSERT INTO coq_file VALUES(g_coq.*)
#                IF STATUS AND STATUS != -239 THEN
                 IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN   #NO.TQC-790093
#                  CALL cl_err('ins coq #2',STATUS,1) #No.TQC-660045
                   CALL cl_err3("ins","coq_file",g_coq.coq00,g_coq.coq01,STATUS,"","ins coq#2",1) #TQC-660045
                   LET g_success = 'N' EXIT FOR
                END IF
#                IF STATUS = -239 THEN
                 IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #NO.TQC-790093
                   UPDATE coq_file SET coq08 = coq08 + g_coq.coq08,
                                       coq10 = coq10 + g_coq.coq10
                    WHERE coq00 = g_coq.coq00 AND coq01 = g_coq.coq01
                      AND coq02 = g_coq.coq02 AND coq03 = g_coq.coq03
                      AND coq04 = g_coq.coq04 AND coq05 = g_coq.coq05
                   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#                     CALL cl_err('upd coq #2',STATUS,1) #No.TQC-660045
                      CALL cl_err3("upd","coq_file",g_coq.coq00,g_coq.coq01,STATUS,"","upd coq #2",1) #TQC-660045
                      LET g_success = 'N' EXIT FOR
                   END IF
                END IF
           ELSE                        #在製工單
                LET g_coq.coq01 = sr[i].bmb03
                LET g_coq.coq08 = l_QPA
 #No.MOD-490398  --begin
                LET g_coq.coq14 = l_coq14     
                LET g_coq.coq15 = l_coq15     
                LET g_coq.coq16 = l_ima55     
                #LET g_coq.coq16 = sr[i].bmb10
 #No.MOD-490398  --end     
                LET g_coq.coq17 = l_total
                #FUN-BB0083---add---str
                LET g_coq.coq13 = s_digqty(g_coq.coq13,g_coq.coq16)
                LET g_coq.coq14 = s_digqty(g_coq.coq14,g_coq.coq16)
                LET g_coq.coq15 = s_digqty(g_coq.coq15,g_coq.coq16)
                LET g_coq.coq17 = s_digqty(g_coq.coq17,g_coq.coq16)
                #FUN-BB0083---add---end
                #---- MOD-850157---
               #IF cl_null(g_coq.coq03) THEN      #MOD-B60093 mark
                IF g_coq.coq03 IS NULL THEN       #MOD-B60093 add
                   CALL cl_err(g_coq.coq03,'asf-770',1)
                   LET g_success = 'N' EXIT FOR
                END IF 
                IF cl_null(g_coq.coq04) THEN
                   LET g_coq.coq04 = ' '
                END IF 
                IF cl_null(g_coq.coq05) THEN
                   LET g_coq.coq05 = ' '
                END IF 
                #---- END MOD-850157---
                INSERT INTO coq_file VALUES(g_coq.*)
#                IF STATUS AND STATUS != -239 THEN
                IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN   #NO.TQC-790093
#                  CALL cl_err('ins coq #4',STATUS,1)  #No.TQC-660045
                   CALL cl_err3("ins","coq_file",g_coq.coq00,g_coq.coq01,STATUS,"","ins coq #4",1) #TQC-660045
                   LET g_success = 'N' EXIT FOR
                END IF
#                IF STATUS = -239 THEN
                 IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #NO.TQC-790093
                   UPDATE coq_file SET coq14 = coq14 + g_coq.coq14,
                                       coq15 = coq15 + g_coq.coq15,
                                       coq17 = coq17 + g_coq.coq17
                    WHERE coq00 = g_coq.coq00
                      AND coq01 = g_coq.coq01
                      AND coq02 = g_coq.coq02
                   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#                     CALL cl_err('upd coq #4',STATUS,1) #No.TQC-660045
                      CALL cl_err3("upd","coq_file",g_coq.coq00,g_coq.coq01,STATUS,"","upd coq #4",1) #TQC-660045
                      LET g_success = 'N' EXIT FOR
                   END IF
                END IF
           END IF
        END IF
    END FOR
END FUNCTION
