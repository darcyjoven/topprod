# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asfq4201.4gl
# Descriptions...: 查詢入庫明細
# Date & Author..: 08/10/20 By Jan
# Modify.........: #No.FUN-890121 08/10/20 Byjan 
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-D60038 13/06/06 By wangrr 單身增加倉庫名稱和庫位名稱欄位
 
DATABASE ds                                                                                                                         
GLOBALS "../../config/top.global"
 
DEFINE
            g_sfh DYNAMIC ARRAY OF RECORD
            sfh13   LIKE sfh_file.sfh13,
            sfh02   LIKE sfh_file.sfh02,
            sfh08   LIKE sfh_file.sfh08,
            imd02   LIKE imd_file.imd02, #TQC-D60038
            sfh06   LIKE sfh_file.sfh06,
            sfh07   LIKE sfh_file.sfh07,
            sfh09   LIKE sfh_file.sfh09,
            ime03   LIKE ime_file.ime03, #TQC-D60038
            sfh10   LIKE sfh_file.sfh10
        END RECORD,
            g_sql    STRING,
            g_cnt1   LIKE type_file.num5
DEFINE g_argv1       LIKE sfb_file.sfb01
DEFINE g_argv2       LIKE sfb_file.sfb05
 
MAIN
DEFINE   p_row,p_col LIKE type_file.num5
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
                                                                                                                                    
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
                                                                                                                                    
   WHENEVER ERROR CALL cl_err_msg_log
                                                                                                                                    
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q4201_w AT p_row,p_col
         WITH FORM "asf/42f/asfq4201"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL q420_qry()
    CALL q4201_menu()
    CLOSE WINDOW q4201_w 
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION q4201_menu()
 
   WHILE TRUE
      CALL q4201_bp("G")
      CASE g_action_choice
 
        WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN                                                                                               
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfh),'','')
            END IF
  
        WHEN "exit"
           EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q420_qry()
 
    DISPLAY g_argv1 TO sfb01
    DISPLAY g_argv2 TO sfb05
 
    LET g_sql=" SELECT sfh13,sfh02,sfh08,'',sfh06,sfh07,sfh09,'',sfh10 ", #TQC-D60038 add 2''
              " FROM sfh_file ",
              " WHERE sfh01 = '",g_argv1,"'",
              " AND sfh03 IN ('2','3')"
    PREPARE q420_prepare1 FROM g_sql
    DECLARE q420_cs1                         
           SCROLL CURSOR FOR q420_prepare1
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q420_cs1                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL q420_dis()
    END IF
END FUNCTION
 
FUNCTION q420_dis()
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(1000)
 
    CALL g_sfh.clear()
    LET g_cnt1 = 1
    FOREACH q420_cs1 INTO g_sfh[g_cnt1].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_sfh[g_cnt1].sfh06 IS NULL THEN
  	       LET g_sfh[g_cnt1].sfh06 = 0
        END IF
        #TQC-D60038--add--str--
        SELECT imd02 INTO g_sfh[g_cnt1].imd02 FROM imd_file WHERE imd01=g_sfh[g_cnt1].sfh08
        SELECT ime03 INTO g_sfh[g_cnt1].ime03 FROM ime_file
        WHERE ime01=g_sfh[g_cnt1].sfh08 AND ime02=g_sfh[g_cnt1].sfh09
       #TQC-D60038--add--end
        LET g_cnt1 = g_cnt1 + 1
    END FOREACH
    LET g_cnt1 = g_cnt1 - 1
END FUNCTION
 
FUNCTION q4201_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)   
   DISPLAY ARRAY g_sfh TO s_sfh.* ATTRIBUTE(COUNT=g_cnt1,UNBUFFERED)
 
 
       ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DISPLAY
 
       ON ACTION cancel
          LET INT_FLAG = FALSE
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON ACTION exit
          LET INT_FLAG = FALSE
          LET g_action_choice="exit" 
          EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-890121
