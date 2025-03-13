# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apmp458.4gl
# Descriptions...: 無交期采購單整批結案作業 
# Input parameter: 
# Return code....: 
# Date & Author..: #No.FUN-850154 08/07/02 By xiaofeizhu
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-980283 09/08/28 By lilingyu 已經結案的作業輸入后繼續顯示運行成功,沒有控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          wc             STRING           #NO.FUN-910082   
          END RECORD 
DEFINE g_pom01        LIKE pom_file.pom01
DEFINE g_pom04        LIKE pom_file.pom04
DEFINE g_pom12        LIKE pom_file.pom12
DEFINE p_row,p_col    LIKE type_file.num5       
DEFINE g_flag         LIKE type_file.chr1       
DEFINE l_flag         LIKE type_file.chr1,     
       g_change_lang  LIKE type_file.chr1,     
       ls_date        STRING                  
DEFINE g_pom25        LIKE pom_file.pom25   #TQC-980283
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc     = ARG_VAL(1)
   LET g_bgjob = ARG_VAL(2)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob= "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
     CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   WHILE TRUE
      IF g_bgjob= "N" THEN
         CALL p458_cs()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL p458_chk()
            CALL s_showmsg()       
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
               CLOSE WINDOW p458_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p458_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p458_chk()
         CALL s_showmsg()       
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
 
FUNCTION p458_cs()
   DEFINE lc_cmd        LIKE type_file.chr1000    
 
   LET p_row = 3 LET p_col = 15
 
   OPEN WINDOW p458_w AT p_row,p_col WITH FORM "apm/42f/apmp458"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
 
 WHILE TRUE
 
   INITIALIZE tm.wc TO NULL
   CONSTRUCT BY NAME tm.wc ON pom01, pom04, pom12 
 
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
      ON ACTION CONTROLP                                                                                                            
           CASE                                                                                                                     
              WHEN INFIELD(pom01)                                                                                                   
                   CALL cl_init_qry_var()                                                                                           
                   LET g_qryparam.form = "q_pom02"                                                                                  
                   LET g_qryparam.state = 'c'                                                                                       
                   CALL cl_create_qry() RETURNING g_qryparam.multiret                                                               
                   DISPLAY g_qryparam.multiret TO pom01                                                                             
                   NEXT FIELD pom01
              OTHERWISE EXIT CASE                                                                                                   
           END CASE
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG CALL cl_cmdask()
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
     
     ON ACTION locale                   
 
         LET g_change_lang = TRUE
         EXIT CONSTRUCT
     
     ON ACTION exit             
        LET INT_FLAG = 1
        EXIT CONSTRUCT
 
 
     ON ACTION qbe_select
        CALL cl_qbe_select()
 
     ON ACTION qbe_save
        CALL cl_qbe_save()
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pomuser', 'pomgrup') #FUN-980030
   
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p454_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
    LET g_bgjob = "N"          
    INPUT BY NAME g_bgjob WITHOUT DEFAULTS
 
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
 
     ON ACTION locale                   
         LET g_change_lang = TRUE
         EXIT INPUT
 
      ON ACTION exit 
         LET INT_FLAG = 1
         EXIT INPUT
 
   END INPUT
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p458_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "apmp458"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('apmp458','9031',1)   
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.wc CLIPPED ,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('apmp458',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p458_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
   EXIT WHILE
 
 END WHILE
 
END FUNCTION
 
FUNCTION p458_chk()  
   DEFINE 
      #l_sql      LIKE type_file.chr1000,   
      l_sql        STRING ,      #NO.FUN-910082
      sr         RECORD LIKE pon_file.*,
      l_name     LIKE type_file.chr20,     
      l_correct  LIKE type_file.chr1,      
      l_do       LIKE type_file.chr1       
 
   LET l_sql ="SELECT pom01,pom04,pom12,pom25 FROM pom_file ",   #TQC-980283 add pom25
              " WHERE pom02 !='SUB' AND pom18 !='X' AND ",tm.wc CLIPPED 
   PREPARE p458_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p458_p1 error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p458_c1 CURSOR FOR p458_p1 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('declare p458_c1 error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
 
   LET l_sql = "SELECT * FROM pon_file ",
              "  WHERE pon01 = ? " 
   PREPARE p458_p2 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p458_p2 error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
 
   DECLARE p458_c2 CURSOR FOR p458_p2 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('declare p458_c2 error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
 
   LET g_success = 'Y'
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH p458_c1 INTO g_pom01, g_pom04, g_pom12,g_pom25     #FOREACH 單頭 #TQC-980283 add g_pom25
      IF SQLCA.sqlcode THEN 
 
         IF g_bgerr THEN
            CALL s_errmsg("","","",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('',SQLCA.sqlcode,1)
         END IF
 
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
#TQC-980283 --begin--
       IF g_pom25 = '6' THEN
          LET g_success = 'N'
          CALL s_errmsg('pom01',g_pom01,'','apm-049',1)
          CONTINUE FOREACH
      END IF
#TQC-980283 --end--
 
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
 
      FOREACH p458_c2 USING g_pom01 INTO sr.*                  #FOREACH 單身
        IF SQLCA.sqlcode THEN 
 
           IF g_bgerr THEN
              CALL s_errmsg("","","",SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("","","","",SQLCA.SQLCODE,"","foreach cursor",1)
           END IF
 
           LET g_success = 'N'
           EXIT FOREACH
        END IF
        CASE                    
           #正常
           WHEN sr.pon20 = sr.pon50
              UPDATE pon_file SET pon16 = '6'
               WHERE pon01 = sr.pon01 AND pon02 = sr.pon02 
              IF SQLCA.SQLCODE THEN
 
                 IF g_bgerr THEN
                    LET g_showmsg = sr.pon01,"/",sr.pon02
                    CALL s_errmsg("pon01,pon02",g_showmsg,"",SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("upd","pon_file",sr.pon01,sr.pon02,SQLCA.sqlcode,"","",1)
                 END IF
 
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
              IF SQLCA.SQLERRD[3] = 0 THEN
 
                 IF g_bgerr THEN
                    CALL s_errmsg("","","","apm-204",1)
                 ELSE
                    CALL cl_err('','apm-204',1)
                 END IF
 
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           #結長
           WHEN sr.pon20 < sr.pon50
              UPDATE pon_file SET pon16 = '7'
               WHERE pon01 = sr.pon01 AND pon02 = sr.pon02 
              IF SQLCA.SQLCODE THEN
 
                 IF g_bgerr THEN
                    LET g_showmsg = sr.pon01,"/",sr.pon02
                    CALL s_errmsg("pon01,pon02",g_showmsg,"",SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("upd","pon_file",sr.pon01,sr.pon02,SQLCA.sqlcode,"","",1)
                 END IF
 
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
              IF SQLCA.SQLERRD[3] = 0 THEN
 
                 IF g_bgerr THEN
                    CALL s_errmsg("","","","apm-204",1)
                 ELSE
                    CALL cl_err3("","","","","apm-204","","",1)
                 END IF
 
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           OTHERWISE
              UPDATE pon_file SET pon16 = '8'
               WHERE pon01 = sr.pon01 AND pon02 = sr.pon02 
              IF SQLCA.SQLCODE THEN
 
                 IF g_bgerr THEN
                    LET g_showmsg = sr.pon01,"/",sr.pon02
                    CALL s_errmsg("pon01,pon02",g_showmsg,"",SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("upd","pon_file",sr.pon01,sr.pon02,SQLCA.sqlcode,"","",1)
                 END IF
 
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
              IF SQLCA.SQLERRD[3] = 0 THEN
 
                 IF g_bgerr THEN
                    CALL s_errmsg("","","","apm-204",1)
                 ELSE
                    CALL cl_err3("","","","","apm-204","","",1)
                 END IF
 
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
        END CASE
      END FOREACH
      IF g_bgjob = 'N' THEN  #NO.FUN-570138 
          DISPLAY g_pom01, g_pom04, g_pom12 TO a, b, c 
      END IF
      UPDATE pom_file SET pom25 = '6',pommodu=g_user,pomdate=g_today  #No.8778
       WHERE pom01 = g_pom01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
 
         IF g_bgerr THEN
            CALL s_errmsg("pom01",g_pom01,"",SQLCA.sqlcode,1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("upd","pom_file",g_pom01,"",SQLCA.sqlcode,"","",1)
            EXIT FOREACH
         END IF
 
      END IF
 
   END FOREACH
 
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
 
END FUNCTION      
#FUN-850154 
