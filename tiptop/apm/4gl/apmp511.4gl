# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: apmp511.4gl
# Descriptions...: 請購單拋轉還原作業
# Date & Author..: No.FUN-630040 06/03/16 By Nicola
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-710030 07/01/19 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-740028 07/04/06 By Ray 增加語言轉換功能
# Modify.........: No.FUN-8A0086 08/10/21 By baofei =完善FUN-710050的錯誤匯總的修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.TQC-BB0084 11/11/09 By destiny 开窗过滤掉非统购的请购单
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pnx          RECORD LIKE pnx_file.* 
DEFINE g_pnx03        LIKE pnx_file.pnx03
DEFINE g_wc,g_sql     STRING 
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680136 SMALLINT 
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_msg          LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   CALL p511_p1()
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p511_p1()
   DEFINE l_flag      LIKE type_file.num5   #No.FUN-680136 SMALLINT
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
 
   OPEN WINDOW p511_w WITH FORM "apm/42f/apmp511"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      IF s_shut(0) THEN RETURN END IF
 
      CLEAR FORM
 
      CONSTRUCT BY NAME g_wc ON pnx05,pnx08,pnx07
      
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pnx05)
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_pmk3"     #TQC-BB0084
                  LET g_qryparam.form = "q_pmk3_1"   #TQC-BB0084
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pnx05
                  NEXT FIELD pnx05
               WHEN INFIELD(pnx07)
#FUN-AA0059---------mod------------str-----------------              
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO pnx07
                  NEXT FIELD pnx07
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION help
            CALL cl_show_help()
      
         ON ACTION controlg
            CALL cl_cmdask()
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
         #No.TQC-740028 --begin
         ON ACTION locale    
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
         #No.TQC-740028 --end
      
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      #No.TQC-740028 --begin
      IF g_action_choice = "locale" THEN  #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE 
      END IF
      #No.TQC-740028 --end
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
 
      INPUT g_pnx03 WITHOUT DEFAULTS FROM pnx03
 
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD pnx03
            IF NOT cl_null(g_pnx03) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM pnx_file
                WHERE pnx03 = g_pnx03
               IF g_cnt <= 0 THEN
                  CALL cl_err(g_pnx03,"mfg9329",0)
                  NEXT FIELD pnx03
               END IF
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
       
         ON ACTION help
            CALL cl_show_help()
       
         ON ACTION controlg
            CALL cl_cmdask()
       
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
         #No.TQC-740028 --begin
         ON ACTION locale       
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()
            EXIT INPUT
         #No.TQC-740028 --end
 
      END INPUT
 
      #No.TQC-740028 --begin
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      #No.TQC-740028 --end
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
 
      IF cl_sure(0,0) THEN
         BEGIN WORK              #No.FUN-710030
         CALL p511_p2()
         CALL s_showmsg()       #No.FUN-710030
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
            EXIT WHILE
         END IF
      END IF
   END WHILE
 
   CLOSE WINDOW p511_w
 
END FUNCTION
 
FUNCTION p511_p2()
 
   LET g_sql = "SELECT * FROM pnx_file",
               " WHERE ",g_wc CLIPPED,
               "   AND pnx03 ='",g_pnx03,"'"
 
   PREPARE p511_pb FROM g_sql
   DECLARE pnx_curs CURSOR FOR p511_pb
  
#   BEGIN WORK             #No.FUN-710030
   LET g_success = "Y"
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH pnx_curs INTO g_pnx.*
      IF STATUS THEN
#No.FUN-710030 -- begin --
#         CALL cl_err("pnx_curs",STATUS,1)
         LET g_success = "N"
         IF g_bgerr THEN
            CALL s_errmsg("","","pnx_curs",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","pnx_curs",1)
         END IF
#No.FUN-710030 -- end --
         LET g_success = 'N'  #No.FUN-8A0086  
         EXIT FOREACH
      END IF
#No.FUN-710030 -- begin --
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
#No.FUN-710030 -- end --
 
      SELECT COUNT(*) INTO g_cnt
        FROM pny_file
       WHERE pny01 = g_pnx.pnx01
         AND pny02 = g_pnx.pnx02
         AND pny03 = g_pnx.pnx03
         AND pny04 = g_pnx.pnx04
         AND pny05 = g_pnx.pnx05
         AND pny06 = g_pnx.pnx06
 
      IF g_cnt > 0 THEN
         CALL cl_err("","axm-044",0)
         LET g_success = "N"
         RETURN
      END IF
 
      UPDATE pml_file SET pml192 = "N"
       WHERE pml01 = g_pnx.pnx05
         AND pml02 = g_pnx.pnx06
      IF STATUS THEN
#        CALL cl_err("upd pml err",STATUS,0)   #No.FUN-660129
#No.FUN-710030 -- begin --
#         CALL cl_err3("upd","pml_file",g_pnx.pnx05,g_pnx.pnx06,STATUS,"","upd pml err",0)  #No.FUN-660129
#         LET g_success = "N"
         LET g_success = "N"
         IF g_bgerr THEN
            CALL s_errmsg("pml01,pml02",g_showmsg,"upd pml err",STATUS,0)
         ELSE
            CALL cl_err3("","","","",STATUS,"","upd pml err",0)
         END IF
#No.FUN-710030 -- end --
      END IF
 
      DELETE FROM pnx_file 
       WHERE pnx01 = g_pnx.pnx01
         AND pnx02 = g_pnx.pnx02
         AND pnx03 = g_pnx.pnx03
         AND pnx04 = g_pnx.pnx04
         AND pnx05 = g_pnx.pnx05
         AND pnx06 = g_pnx.pnx06
      IF STATUS THEN
#        CALL cl_err("del pnx error",STATUS,0)   #No.FUN-660129
#No.FUN-710030 -- begin --
#         CALL cl_err3("del","pnx_file",g_pnx.pnx01,g_pnx.pnx02,STATUS,"","del pnx error",0)  #No.FUN-660129
#         LET g_success = "N"
         LET g_success = "N"
         IF g_bgerr THEN
            LET g_showmsg = g_pnx.pnx01,"/",g_pnx.pnx02,"/",g_pnx.pnx03,"/",g_pnx.pnx04,"/",g_pnx.pnx05,"/",g_pnx.pnx06
            CALL s_errmsg("pnx01,pnx02,pnx03,pnx04,pnx05,pnx06",g_showmsg,"del pnx error",STATUS,0)
         ELSE
            CALL cl_err3("del","pnx_file",g_pnx.pnx01,g_pnx.pnx02,STATUS,"","del pnx error",0)
         END IF
#No.FUN-710030 -- begin --
      END IF
 
   END FOREACH
#No.FUN-710030 -- begin --
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
#No.FUN-710030 -- end --
 
END FUNCTION
 
 
