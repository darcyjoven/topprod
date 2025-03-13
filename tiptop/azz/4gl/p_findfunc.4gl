# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_findfunc.4gl
# Descriptions...: TIPTOP GP函式功能查詢作業  
# Date & Author..: 07/07/05 By alex (FUN-760087)          
# Modify.........: No.FUN-7C0063 07/12/20 By alex 新增報表列印功能
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-760087
 
DEFINE 
     g_hjb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hjb01       LIKE hjb_file.hjb01,  
        hjb02       LIKE hjb_file.hjb02,   
        hjb04       LIKE hjb_file.hjb04, 
        hjb05       LIKE hjb_file.hjb05,   
        hjb06       LIKE hjb_file.hjb06,  
        hjb07       LIKE hjb_file.hjb07,  
        hjb08       LIKE hjb_file.hjb08     
                    END RECORD,
    g_hjb_t         RECORD                 #程式變數 (舊值)
        hjb01       LIKE hjb_file.hjb01,  
        hjb02       LIKE hjb_file.hjb02,  
        hjb04       LIKE hjb_file.hjb04,  
        hjb05       LIKE hjb_file.hjb05, 
        hjb06       LIKE hjb_file.hjb06,  
        hjb07       LIKE hjb_file.hjb07,  
        hjb08       LIKE hjb_file.hjb08     
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, #No.FUN-680102 VARCHAR(80)
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-680102 INTEGER
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110  #No.FUN-680102 SMALLINT
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose  #No.FUN-680102 SMALLINT
DEFINE g_on_change  LIKE type_file.num5      #No.FUN-680102 SMALLINT   #FUN-550077
DEFINE g_row_count  LIKE type_file.num5       #No.TQC-680158 add
DEFINE g_curs_index LIKE type_file.num5       #No.TQC-680158 add
 
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   
 
   OPEN WINDOW p_findfunc_w WITH FORM "azz/42f/p_findfunc"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1'
   CALL p_findfunc_b_fill(g_wc2)
   CALL p_findfunc_menu()
 
   CLOSE WINDOW p_findfunc_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p_findfunc_menu()
 
   WHILE TRUE
      CALL p_findfunc_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL p_findfunc_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL p_findfunc_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"    #FUN-7C0063
            IF cl_chk_act_auth() THEN
               CALL p_findfunc_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hjb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_findfunc_q()
   CALL p_findfunc_b_askkey()
END FUNCTION
 
FUNCTION p_findfunc_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT      #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用             #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否             #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態               #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 # Prog. Version..: '5.30.06-13.03.12(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1                  # Prog. Version..: '5.30.06-13.03.12(01),              #可刪除否
 
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
#   #07/07/05 本作業不可新增刪除,須重新由 p_get_lib 抓取
#   LET l_allow_insert = cl_detail_input_auth('insert')
#   LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = " SELECT hjb01,hjb02,hjb04,hjb05,hjb06,hjb07,hjb08 ",
                         " FROM hjb_file ",
                        " WHERE hjb01=? AND hjb02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_findfunc_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hjb WITHOUT DEFAULTS FROM s_hjb.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW=FALSE, DELETE ROW=FALSE, APPEND ROW=FALSE) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
        LET g_on_change = TRUE         #FUN-550077
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_hjb_t.* = g_hjb[l_ac].*  #BACKUP
           OPEN p_findfunc_bcl USING g_hjb_t.hjb01
           IF STATUS THEN
              CALL cl_err("OPEN p_findfunc_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH p_findfunc_bcl INTO g_hjb[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hjb_t.hjb01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           CALL cl_show_fld_cont()  
        END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_hjb[l_ac].* = g_hjb_t.*
          CLOSE p_findfunc_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_hjb[l_ac].hjb01,-263,0)
           LET g_hjb[l_ac].* = g_hjb_t.*
        ELSE
           UPDATE hjb_file SET hjb08=g_hjb[l_ac].hjb08
                         WHERE hjb01 = g_hjb_t.hjb01
                           AND hjb02 = g_hjb_t.hjb02
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","hjb_file",g_hjb_t.hjb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK   
              LET g_hjb[l_ac].* = g_hjb_t.*
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()           
        LET l_ac_t = l_ac            
 
        IF INT_FLAG THEN         
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_hjb[l_ac].* = g_hjb_t.*
           END IF
           CLOSE p_findfunc_bcl   
           ROLLBACK WORK    
           EXIT INPUT
         END IF
         CLOSE p_findfunc_bcl   
         COMMIT WORK
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(hjb01) AND l_ac > 1 THEN
             LET g_hjb[l_ac].* = g_hjb[l_ac-1].*
             NEXT FIELD hjb01
         END IF
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON ACTION CONTROLF
        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
 
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
 
    CLOSE p_findfunc_bcl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION p_findfunc_b_askkey()
    CLEAR FORM
    CALL g_hjb.clear()
 
    CONSTRUCT g_wc2 ON hjb01,hjb02,hjb04,hjb05,hjb06,hjb07,hjb08
         FROM s_hjb[1].hjb01,s_hjb[1].hjb02,s_hjb[1].hjb04,
              s_hjb[1].hjb05,s_hjb[1].hjb06,s_hjb[1].hjb07,
              s_hjb[1].hjb08
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
    
      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hjbuser', 'hjbgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
    CALL p_findfunc_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION p_findfunc_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
 
    LET g_sql = " SELECT hjb01,hjb02,hjb04,hjb05,hjb06,hjb07,hjb08 ",
                  " FROM hjb_file ",
                 " WHERE ", p_wc2 CLIPPED,           #單身
                 " ORDER BY hjb01,hjb02 " 
 
    PREPARE p_findfunc_pb FROM g_sql
    DECLARE hjb_curs CURSOR FOR p_findfunc_pb
 
    CALL g_hjb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hjb_curs INTO g_hjb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hjb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_findfunc_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hjb TO s_hjb.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION output    #FUN-7C0063
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_findfunc_out()    #FUN-7C0063
 
   DEFINE l_name    LIKE type_file.chr20
   DEFINE #l_sql     LIKE type_file.chr1000
          l_sql   STRING      #NO.FUN-910082
   DEFINE l_chr     LIKE type_file.chr1
   DEFINE l_za05    LIKE type_file.chr1000
   DEFINE l_order   ARRAY[5] OF LIKE type_file.chr20
   DEFINE sr               RECORD
           hjb01          LIKE hjb_file.hjb01,  
           hjb02          LIKE hjb_file.hjb02,   
           hjb04          LIKE hjb_file.hjb04, 
           hjb05          LIKE hjb_file.hjb05,   
           hjb06          LIKE hjb_file.hjb06,  
           hjb07          LIKE hjb_file.hjb07,  
           hjb08          LIKE hjb_file.hjb08     
                      END RECORD
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   LET l_sql = " SELECT hjb01,hjb02,hjb04,hjb05,hjb06,hjb07,hjb08 ",
                 " FROM hjb_file ", 
                " WHERE ",g_wc2,
                " ORDER BY hjb01,hjb02 "
 
   CALL cl_prt_cs1("p_findfunc","p_findfunc",l_sql,'')
 
END FUNCTION
 
