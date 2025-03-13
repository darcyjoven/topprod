# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asfp430.4gl
# Descriptions...: 工單凍結碼維護作業
# Date & Author..: 2003/03/12 By Hjwang
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-710026 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_sfb           DYNAMIC ARRAY OF RECORD        #程式變數(Program Variables)
           sfb01         LIKE sfb_file.sfb01,
           sfb05         LIKE sfb_file.sfb05,
           sfb08         LIKE sfb_file.sfb08,
           sfb09         LIKE sfb_file.sfb09,
           sfb04         LIKE sfb_file.sfb04,
           sfb02         LIKE sfb_file.sfb02,
           sfb41         LIKE sfb_file.sfb41
                    END RECORD,
    g_sfb_t         RECORD                      #程式變數 (舊值)
           sfb01         LIKE sfb_file.sfb01,
           sfb05         LIKE sfb_file.sfb05,
           sfb08         LIKE sfb_file.sfb08,
           sfb09         LIKE sfb_file.sfb09,
           sfb04         LIKE sfb_file.sfb04,
           sfb02         LIKE sfb_file.sfb02,
           sfb41         LIKE sfb_file.sfb41
                    END RECORD,
     g_wc2,g_sql         string,  #No.FUN-580092 HCN
    g_rec_b             LIKE type_file.num5,                 #單身筆數        #No.FUN-680121 SMALLINT
    l_ac                LIKE type_file.num5,                 #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_sl                LIKE type_file.num5,          #No.FUN-680121 SMALLINT #目前處理的SCREEN LINE
    l_sw                LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1) #單身進入指示
    p_row,p_col         LIKE type_file.num5           #No.FUN-680121 SMALLINT
DEFINE g_cnt            LIKE type_file.num10          #No.FUN-680121 INTEGER
DEFINE g_forupd_sql     STRING   #SELECT ... FOR UPDATE SQL
 
MAIN
    OPTIONS                                     #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                             #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)            #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
   LET l_sw = 0
 
   LET p_row = 2 LET p_col = 18
 
   OPEN WINDOW p430_w AT p_row,p_col WITH FORM "asf/42f/asfp430"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
 
# 開始即顯示
#
#    LET g_wc2 = '1=1' CALL p430_b_fill(g_wc2)
 
   CALL p430_menu()
 
   CLOSE WINDOW p430_w                         #結束畫面
 
     CALL  cl_used(g_prog,g_time,2)            #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
END MAIN
 
 
FUNCTION p430_menu()
   WHILE TRUE
      CALL p430_bp("G")
      CASE g_action_choice
 
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL p430_q() 
            END IF
 
         WHEN "detail" 
              IF cl_chk_act_auth() AND l_sw THEN
                  CALL p430_b()
              ELSE
                 LET g_action_choice = NULL
              END IF
 
         WHEN "help"
               CALL cl_show_help()
 
         WHEN "exit"
              EXIT WHILE
 
         WHEN "controlg"
              CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p430_q()
   CALL p430_b_askkey()
END FUNCTION
 
FUNCTION p430_b()
 
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,                 #No.FUN-680121 VARCHAR(1) #Esc結束INPUT ARRAY 否
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680121 VARCHAR(1)
    l_possible      LIKE type_file.num5,                 #No.FUN-680121 SMALLINT #用來設定判斷重複的可能性
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL p430_opmsg()
 
    LET g_forupd_sql = " SELECT sfb41 FROM sfb_file ",
                       "  WHERE sfb01 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p430_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_sfb WITHOUT DEFAULTS FROM s_sfb.* 
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW =FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
 
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_sfb_t.* = g_sfb[l_ac].*  #BACKUP
                OPEN p430_bcl USING g_sfb_t.sfb01
                IF STATUS THEN
#                  CALL cl_err("OPEN p430_bcl:", STATUS, 1)                  #NO.FUN-710026
                   CALL s_errmsg('','',"OPEN p430_bcl:", STATUS, 1)         #NO.FUN-710026
                   LET l_lock_sw = "Y"
                ELSE 
                   FETCH p430_bcl INTO g_sfb[l_ac].sfb41
                   IF SQLCA.sqlcode THEN
#                      CALL cl_err('fetch p430_bcl:',SQLCA.sqlcode,1)           #NO.FUN-710026  
                       CALL s_errmsg('','','fetch p430_bcl:',SQLCA.sqlcode,1)   #NO.FUN-710026
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER FIELD sfb41
            IF g_sfb[l_ac].sfb41 NOT MATCHES '[YyNn]' THEN
                NEXT FIELD sfb41
            ELSE
                IF g_sfb[l_ac].sfb41='y' THEN LET g_sfb[l_ac].sfb41='Y' END IF 
                IF g_sfb[l_ac].sfb41='n' THEN LET g_sfb[l_ac].sfb41='N' END IF 
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN                 #新增程式段
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sfb[l_ac].* = g_sfb_t.*
               CLOSE p430_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sfb[l_ac].sfb01,-263,1)
               LET g_sfb[l_ac].* = g_sfb_t.*
            ELSE
               UPDATE sfb_file SET(sfb41)=(g_sfb[l_ac].sfb41)
                     WHERE sfb01 = g_sfb_t.sfb01
               DISPLAY g_sfb[l_ac].*
               DISPLAY sqlca.sqlcode    
               IF SQLCA.sqlcode THEN
#                  CALL cl_err('FreezeCode:',SQLCA.sqlcode,0)   #No.FUN-660128
#                  CALL cl_err3("upd","sfb_file",g_sfb_t.sfb01,"",SQLCA.sqlcode,"","FreezeCode:",0)    #No.FUN-660128 #NO.FUN-710026
                   CALL s_errmsg('sfb01',g_sfb_t.sfb01,'FreezeCode:',SQLCA.sqlcode,0)                #NO.FUN-710026
                   LET g_sfb[l_ac].sfb41 = g_sfb_t.sfb41
                   DISPLAY g_sfb[l_ac].sfb41 TO s_sfb[l_sl].sfb41
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
 
           IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_sfb[l_ac].* = g_sfb_t.*
               END IF
               CLOSE p430_bcl
               ROLLBACK WORK
               EXIT INPUT
           END IF
           CLOSE p430_bcl
           COMMIT WORK
 
        ON ACTION CONTROLN
            CALL p430_b_askkey()
            LET l_exit_sw = "n"
            EXIT INPUT
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
        
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
        END INPUT
 
    CLOSE p430_bcl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION p430_b_askkey()
    CLEAR FORM
   CALL g_sfb.clear()
 
    CONSTRUCT g_wc2 ON sfb01,sfb05,sfb08,sfb09,sfb04,sfb02,sfb41
         FROM s_sfb[1].sfb01,s_sfb[1].sfb05,s_sfb[1].sfb08,
              s_sfb[1].sfb09,s_sfb[1].sfb04,s_sfb[1].sfb02,
              s_sfb[1].sfb41
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL p430_b_fill(g_wc2)
END FUNCTION
 
FUNCTION p430_b_fill(l_wc2)              #BODY FILL UP
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
    LET g_sql =
        "SELECT sfb01,sfb05,sfb08,sfb09,sfb04,sfb02,sfb41",
        " FROM sfb_file",
        " WHERE sfb04 != '8' AND ", l_wc2 CLIPPED,   #單身
        " ORDER BY sfb01"
 
    PREPARE p430_pb FROM g_sql
    DECLARE sfb_curs CURSOR FOR p430_pb
 
    FOR g_cnt = 1 TO g_sfb.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_sfb[g_cnt].* TO NULL
    END FOR
 
    LET g_cnt = 1
    MESSAGE "Searching!" 
 
    FOREACH sfb_curs INTO g_sfb[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.SQLCODE THEN
             CALL cl_err('foreach:',STATUS,1)
             EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
    END FOREACH
    CALL g_sfb.deleteElement(g_cnt)
    LET l_sw = TRUE                        #先開啟單身進入指示
    #尋得筆數小於 1 筆則跳出，相反，則繼續
    IF (g_cnt-1) < 1 THEN
        LET l_sw = 0                       #搜詢沒結果就不給進單身
        CALL cl_err('Foreach:','asf-430',0)
        RETURN
    END IF
 
    MESSAGE ""
 
    LET g_rec_b = g_cnt-1
 
    CALL SET_COUNT(g_cnt-1)                     #告訴I.單身筆數
        DISPLAY g_rec_b TO FORMONLY.cn2
        LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p430_bp(p_ud)
 
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    CALL SET_COUNT(g_rec_b)   #告訴I.單身筆數
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b)
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION query
           LET g_action_choice="query"     
           EXIT DISPLAY
 
        ON ACTION detail
           LET g_action_choice="detail"    
           EXIT DISPLAY
 
        ON ACTION help
           LET g_action_choice="help"      
           EXIT DISPLAY
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           EXIT DISPLAY
 
        ON ACTION controlg
           LET g_action_choice="controlg"      
           EXIT DISPLAY
 
        ON ACTION exit
           LET g_action_choice="exit"      
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
    
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p430_opmsg()
 
DEFINE
          l_msg1        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(120)
          l_msg2        LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(80)
 
    CASE WHEN g_lang = '0'
         IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
             LET l_msg1 = '<Esc>處理結束 <^N>重查 <F4>上頁 <Del>放棄修改 <F3>下頁'
             MESSAGE l_msg1
         ELSE
             LET l_msg1 = '<Esc>處理結束 <^N>重查 <F4>上頁'
             LET l_msg2 = '<Del>放棄修改          <F3>下頁'
             DISPLAY l_msg1 AT 1,1 
             DISPLAY l_msg2 AT 2,1 
         END IF
 
         WHEN g_lang = '1'
         IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
             LET l_msg1 = '<Esc>End <^N>New <F4>PgUp <Del>Abort <F3>PgDn'
             MESSAGE l_msg1
         ELSE
             LET l_msg1 = '<Esc>End <^N>New <F4>PgUp'
             LET l_msg2 = '<Del>Abort       <F3>PgDn'
             DISPLAY l_msg1 AT 1,1 
             DISPLAY l_msg2 AT 2,1 
         END IF
 
         WHEN g_lang = '2'
         IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
             LET l_msg1 = '<Esc>處理結束 <^N>重查 <F4>上頁 <Del>放棄修改 <F3>下頁'
             MESSAGE l_msg1
         ELSE
             LET l_msg1 = '<Esc>處理結束 <^N>重查 <F4>上頁'
             LET l_msg2 = '<Del>放棄修改          <F3>下頁'
             DISPLAY l_msg1 AT 1,1 
             DISPLAY l_msg2 AT 2,1 
         END IF
    END CASE
    RETURN
END FUNCTION
 
