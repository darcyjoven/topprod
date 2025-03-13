# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_openchk.4gl
# Descriptions...: 開帳資料檢核表
# Input parameter:
# Date & Author..: FUN-810012 08/03/13 By ice 作業新增
# Modify.........: No.FUN-890131 08/09/30 By Nicola 加入檢核功能
# Modify.........: No.FUN-8A0021 08/10/06 By douzh  加入限制字元的檢查
#                  08/11/18 更改p_opencheck.4gl為p_openchk.4gl
# Modify.........: No.FUN-8A0050 08/10/09 By Nicola 把檢核功能移至查詢單身二中
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_zoa           DYNAMIC ARRAY OF RECORD 
        zoa01       LIKE zoa_file.zoa01,   #資料型態
        zoa03       LIKE zoa_file.zoa03,   #資料代號
        gaz03       LIKE gaz_file.gaz03,   #資料內容
        zoa04       LIKE zoa_file.zoa04,   #單別
        zoa05       LIKE zoa_file.zoa05,   #最後匯入日期
        zoa06       LIKE zoa_file.zoa06,   #最後匯入者
        zoa07       LIKE zoa_file.zoa07    #匯入筆數
                    END RECORD,
    g_zoa_t         RECORD                 #程式變數 (舊值)
        zoa01       LIKE zoa_file.zoa01,   #資料型態
        zoa03       LIKE zoa_file.zoa03,   #資料代號
        gaz03       LIKE gaz_file.gaz03,   #資料內容
        zoa04       LIKE zoa_file.zoa04,   #單別
        zoa05       LIKE zoa_file.zoa05,   #最後匯入日期
        zoa06       LIKE zoa_file.zoa06,   #最後匯入者
        zoa07       LIKE zoa_file.zoa07    #匯入筆數
                    END RECORD,
    g_zod           DYNAMIC ARRAY OF RECORD 
        zod01       LIKE zod_file.zod01,   #檔案代號
        zod02       LIKE zod_file.zod02,   #匯入序號
        zod03       LIKE zod_file.zod03,   #匯入檔名
        zod04       LIKE zod_file.zod04,   #匯入日期
        zod05       LIKE zod_file.zod05,   #匯入者
        zod06       LIKE zod_file.zod06,   #匯入筆數  
        zod07       LIKE zod_file.zod07,   #舊單號（起）   
        zod08       LIKE zod_file.zod08,   #舊單號（訖）   
        zod09       LIKE zod_file.zod09,   #TP單號（起）   
        zod10       LIKE zod_file.zod10,   #TP單號（訖）   
        zod11       LIKE zod_file.zod11,   #已刪除否       
        zod12       LIKE zod_file.zod12    #已檢核否     
                    END RECORD,                          
    g_zod_t         RECORD                 #程式變數 (舊值)
        zod01       LIKE zod_file.zod01,   #檔案代號
        zod02       LIKE zod_file.zod02,   #匯入序號
        zod03       LIKE zod_file.zod03,   #匯入檔名
        zod04       LIKE zod_file.zod04,   #匯入日期
        zod05       LIKE zod_file.zod05,   #匯入者
        zod06       LIKE zod_file.zod06,   #匯入筆數  
        zod07       LIKE zod_file.zod07,   #舊單號（起）   
        zod08       LIKE zod_file.zod08,   #舊單號（訖）   
        zod09       LIKE zod_file.zod09,   #TP單號（起）   
        zod10       LIKE zod_file.zod10,   #TP單號（訖）   
        zod11       LIKE zod_file.zod11,   #已刪除否       
        zod12       LIKE zod_file.zod12    #已檢核否 
                    END RECORD,
    g_ss            LIKE type_file.chr1,
    g_wc,g_sql      STRING,
    g_wc2           STRING,
    g_rec_b         LIKE type_file.num5,   #單身筆數
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT
    g_rec_b2        LIKE type_file.num5,   #單身筆數
    l_ac2           LIKE type_file.num5    #目前處理的ARRAY CNT
 
#主程式開始
DEFINE g_forupd_sql         STRING
DEFINE g_sql_tmp            STRING
DEFINE g_before_input_done  LIKE type_file.num5 
DEFINE g_cnt                LIKE type_file.num10
DEFINE g_i                  LIKE type_file.num5
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_row_count          LIKE type_file.num10
DEFINE g_curs_index         LIKE type_file.num10
DEFINE g_jump               LIKE type_file.num10
DEFINE mi_no_ask            LIKE type_file.num5
DEFINE g_str                STRING            
 
MAIN
   DEFINE p_row,p_col     LIKE type_file.num5
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET p_row = 4 LET p_col = 30
 
   OPEN WINDOW p_openchk_w AT p_row,p_col
        WITH FORM "azz/42f/p_openchk"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL p_openchk_q()
 
   CALL p_openchk_menu()
 
   CLOSE WINDOW p_openchk_w              #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION p_openchk_curs()
   CLEAR FORM                             #清除畫面
   CALL g_zoa.clear()
   CALL g_zod.clear()
 
   CONSTRUCT g_wc ON zoa01,zoa03,zoa04
        FROM s_zoa[1].zoa01,s_zoa[1].zoa03,s_zoa[1].zoa04
 
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
        ON ACTION about    
           CALL cl_about()
 
        ON ACTION help   
           CALL cl_show_help()
 
        ON ACTION controlg   
           CALL cl_cmdask()    
 
        ON ACTION qbe_select
           CALL cl_qbe_select()
 
        ON ACTION qbe_save
           CALL cl_qbe_save()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(zoa03) 
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_zoa"
              LET g_qryparam.state  = "c" 
              LET g_qryparam.arg1  = g_lang
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO zoa03
              NEXT FIELD zoa03
              OTHERWISE
              EXIT CASE
           END CASE
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN RETURN END IF
     
   CALL p_openchk_b_fill(g_wc)  
 
END FUNCTION
 
FUNCTION p_openchk_menu()
   DEFINE l_cmd   STRING    
 
   WHILE TRUE
      CALL p_openchk_bp("G")
   
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p_openchk_q()
            END IF
         WHEN "condition_detail"
            IF cl_chk_act_auth() THEN
               CALL p_openchk_b2()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "qry_condition_detail"
            IF cl_chk_act_auth() THEN
               CALL p_openchk_bp2('G')
            ELSE 
               LET g_action_choice = NULL 
            END IF
         #-----No.FUN-890131-----
         WHEN "check"
            IF cl_chk_act_auth() THEN
               CALL p_openchk_check("ALL")
            END IF
         #-----No.FUN-890131 END-----
 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_openchk_zoa03(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_gaz03   LIKE gaz_file.gaz03   
 
   LET g_errno = ' '
   SELECT gaz03 INTO l_gaz03
     FROM gaz_file 
    WHERE gaz01 = g_zoa[l_ac].zoa03
      AND gaz02 =g_lang   
   CASE
       WHEN STATUS=100      LET g_errno = 100
       OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
   IF NOT cl_null(g_errno) THEN 
      LET l_gaz03 = NULL
      LET g_zoa[l_ac].gaz03 = NULL
   END IF
   IF p_cmd = 'd' OR g_errno IS NULL THEN
      LET g_zoa[l_ac].gaz03 = l_gaz03
   END IF
   DISPLAY BY NAME g_zoa[l_ac].gaz03
END FUNCTION
 
#Query 查詢
FUNCTION p_openchk_q()
 
   CALL p_openchk_curs()                    #取得查詢條件
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
 
END FUNCTION
 
#單身
FUNCTION p_openchk_b2()
DEFINE
   l_ac2_t         LIKE type_file.num5,           #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,           #檢查重復用       
   l_lock_sw       LIKE type_file.chr1,           #單身鎖住否       
   p_cmd           LIKE type_file.chr1,           #處理狀態         
   l_allow_insert  LIKE type_file.num5,           #可新增否         
   l_allow_delete  LIKE type_file.num5            #可刪除否         
 
   LET g_action_choice = ""
 
   IF g_zoa[l_ac].zoa03 IS NULL THEN
      RETURN
   END IF
 
   IF l_ac < 1 OR l_ac > g_rec_b THEN
      RETURN
   END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT zod01,zod02,zod03,zod04,zod05,zod06,zod07,zod08,zod09,zod10,zod11,zod12 ",
                      " FROM zod_file ",
                      " WHERE zod00= ? AND zod01 =? AND zod02 = ?  FOR UPDATE  "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_openchk_bcl2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac2_t = 0
#   LET l_allow_insert = cl_detail_input_auth("insert")
#   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_zod WITHOUT DEFAULTS FROM s_zod.*
         ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b2!=0 THEN
              CALL fgl_set_arr_curr(l_ac2)
           END IF
 
       BEFORE ROW
           LET p_cmd=''
           LET l_ac2 = ARR_CURR()
           LET l_lock_sw = 'N'   
           LET l_n  = ARR_COUNT()
           IF g_rec_b2 >= l_ac2 THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_zod_t.* = g_zod[l_ac2].*  #BACKUP
              OPEN p_openchk_bcl2 USING g_zoa[l_ac].zoa03,g_zod_t.zod01,g_zod_t.zod02
              IF STATUS THEN
                 CALL cl_err("OPEN p_openchk_bcl2:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH p_openchk_bcl2 INTO g_zod[l_ac2].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_zod_t.zod05,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()
           END IF
        
       AFTER FIELD zod12 
           IF g_zod[l_ac2].zod11 ='Y' AND g_zod[l_ac2].zod12 != g_zod_t.zod12 THEN  
              CALL cl_err('','azz-518',1)
              LET g_zod[l_ac2].zod12 = g_zod_t.zod12
              DISPLAY BY NAME g_zod[l_ac2].zod12
              NEXT FIELD zod12
           END IF 
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_zod[l_ac2].* = g_zod_t.*
              CLOSE p_openchk_bcl2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_zod[l_ac2].zod03,-263,1)
              LET g_zod[l_ac2].* = g_zod_t.*
           ELSE
              UPDATE zod_file SET zod12 = g_zod[l_ac2].zod12
               WHERE zod00 = g_zoa[l_ac].zoa03
                 AND zod01 = g_zod_t.zod01
                 AND zod02 = g_zod_t.zod02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","zod_file",g_zoa[l_ac].zoa03,g_zod_t.zod02,SQLCA.sqlcode,"","",1)
                 LET g_zod[l_ac2].* = g_zod_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
       AFTER ROW
           LET l_ac2 = ARR_CURR()
           LET l_ac2_t = l_ac2
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_zod[l_ac2].* = g_zod_t.*
              END IF
              CLOSE p_openchk_bcl2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE p_openchk_bcl2
           COMMIT WORK
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about     
          CALL cl_about() 
 
       ON ACTION help       
          CALL cl_show_help()
                      
       ON ACTION controls                                        
          CALL cl_set_head_visible("","AUTO")                    
 
   END INPUT
   
   CLOSE p_openchk_bcl2
   COMMIT WORK
 
END FUNCTION
 
FUNCTION p_openchk_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc     STRING
   DEFINE l_i      LIKE type_file.num10
 
   LET g_sql ="SELECT zoa01,zoa03,'',zoa04,zoa05,zoa06,zoa07 FROM zoa_file ",
              " WHERE ",p_wc CLIPPED,
              " ORDER BY zoa01,zoa03"
   PREPARE p_openchk_p2 FROM g_sql           #預備一下
   DECLARE zoa_curs CURSOR FOR p_openchk_p2
 
   CALL g_zoa.clear()
 
   LET l_i = 1
   FOREACH zoa_curs INTO g_zoa[l_i].*         #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       SELECT gaz03 INTO g_zoa[l_i].gaz03
         FROM gaz_file
        WHERE gaz01=g_zoa[l_i].zoa03
          AND gaz02 = g_lang 
       LET l_i = l_i + 1 
       IF l_i > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_zoa.deleteElement(l_i)
   LET g_rec_b = l_i - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION p_openchk_b_fill2(p_wc2)              #BODY FILL UP
   DEFINE p_wc2     STRING
 
   LET g_sql ="SELECT zod01,zod02,zod03,zod04,zod05,zod06,zod07,zod08,zod09,zod10,zod11,zod12 FROM zod_file ",
              " WHERE zod00 = '",g_zoa[l_ac].zoa03,"'",
              "   AND ",p_wc2 CLIPPED,
              " ORDER BY zod02"
   PREPARE p_openchk_pb2 FROM g_sql      #預備一下
   DECLARE zod_curs CURSOR FOR p_openchk_pb2
 
   CALL g_zod.clear()
 
   LET g_cnt = 1
   FOREACH zod_curs INTO g_zod[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1 
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
	        EXIT FOREACH
       END IF
   END FOREACH
   CALL g_zod.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO FORMONLY.cn3
   LET g_cnt = 0
END FUNCTION
 
FUNCTION p_openchk_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_zoa TO s_zoa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL fgl_set_arr_curr(l_ac)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac = 0 THEN
            LET l_ac = 1
         END IF
         CALL p_openchk_b_fill2(" 1=1")
         CALL p_openchk_bp2_refresh()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION condition_detail         
         LET g_action_choice="condition_detail"
         LET l_ac2 = 1
         EXIT DISPLAY
 
      ON ACTION qry_condition_detail
         LET g_action_choice="qry_condition_detail"
         EXIT DISPLAY
        
      #-----No.FUN-890131-----
      ON ACTION check
         LET g_action_choice="check"
         EXIT DISPLAY
      #-----No.FUN-890131 END-----
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about    
         CALL cl_about()
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_openchk_bp2_refresh()
   DISPLAY ARRAY g_zod TO s_zod.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END DISPLAY
END FUNCTION
 
FUNCTION p_openchk_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL cl_set_act_visible("cancel", FALSE)
   DISPLAY ARRAY g_zod TO s_zod.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
         
      BEFORE DISPLAY
         CALL fgl_set_arr_curr(l_ac2)
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about    
         CALL cl_about()
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
      #-----No.FUN-8A0050-----
      ON ACTION check
         LET l_ac2 = ARR_CURR()
         IF l_ac2 >= 1 THEN
            IF cl_chk_act_auth() THEN
               CALL p_openchk_check(g_zod[l_ac2].zod02)
            END IF
         END IF
         EXIT DISPLAY
      #-----No.FUN-8A0050 END-----
 
   END DISPLAY
 
   CALL cl_set_act_visible("cancel", FALSE)
 
END FUNCTION
#No.FUN-810012
 
#-----No.FUN-890131-----
FUNCTION p_openchk_check(p_zod02)
   DEFINE p_zod02       LIKE zod_file.zod02
   DEFINE p_row,p_col   LIKE type_file.num5
   DEFINE l_sql         STRING
   DEFINE l_ind_val     LIKE type_file.chr1000
   DEFINE l_ind_key     STRING
   DEFINE l_err_key     STRING
   DEFINE l_key2        STRING
   DEFINE ls_value      STRING
   DEFINE l_str         STRING
   DEFINE l_zod02       LIKE zod_file.zod02
   DEFINE l_zod         RECORD
                           zod01   LIKE zod_file.zod01,
                           zod11   LIKE zod_file.zod11,
                           zod12   LIKE zod_file.zod12 
                        END RECORD
   DEFINE l_c           LIKE type_file.num5
   DEFINE l_ztd         DYNAMIC ARRAY OF RECORD
                           colname LIKE zoc_file.zoc02,
                           data    STRING
                        END RECORD
   DEFINE l_zoc         RECORD LIKE zoc_file.*
   DEFINE l_chr200      LIKE type_file.chr200
   DEFINE l_chkno       LIKE type_file.num5
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_openinsn    LIKE zoc_file.zoc02
   DEFINE l_msg         STRING
   DEFINE l_msg1        STRING
   DEFINE l_msg2        STRING
   DEFINE l_tabname     LIKE gat_file.gat03
   DEFINE i             LIKE type_file.num5
   DEFINE l_tot_cnt     LIKE type_file.num10
   DEFINE tok base.StringTokenizer
   DEFINE l_zoc03       LIKE zoc_file.zoc03
 
   IF g_zoa[l_ac].zoa03 IS NULL THEN
      RETURN
   END IF
 
   LET p_row = 4 LET p_col = 30
 
   OPEN WINDOW p_openchk_1_w AT p_row,p_col
     WITH FORM "azz/42f/p_opendel_1" ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_opendel_1")
 
   IF STATUS THEN
      CALL cl_err('open win:',STATUS,1)
      RETURN
   END IF
 
   LET g_action_choice = ""
 
   INPUT l_zod02 FROM zod02
 
      BEFORE FIELD zod02
         LET l_zod02 = p_zod02
         DISPLAY l_zod02 TO zod02
 
      AFTER FIELD zod02
         IF NOT cl_null(l_zod02) THEN 
            SELECT COUNT(*) INTO l_n 
              FROM zod_file
             WHERE zod00 = g_zoa[l_ac].zoa03
               AND zod02 = l_zod02
            IF l_n = 0  THEN 
               IF l_zod02 <> "ALL"  THEN
                  CALL cl_err('','azz-896',1)
                  NEXT FIELD zod02
               END IF
            END IF
         ELSE 
            CALL cl_err('','aar-011',1)              #不能為空  
            NEXT FIELD zod02
         END IF 
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p_openchk_1_w
      RETURN
   END IF
 
   CLOSE WINDOW p_openchk_1_w
 
   IF l_zod02 = "ALL" THEN
      LET l_sql =" SELECT UNIQUE zod01,'',''  FROM zod_file ", 
                 "  WHERE zod00 = '",g_zoa[l_ac].zoa03,"' "  
   ELSE
      LET l_sql =" SELECT zod01,zod11,zod12  FROM zod_file ",
                 "  WHERE zod02 = '",l_zod02,"' "
   END IF
 
   PREPARE zod_pre FROM l_sql
 
   DECLARE zod_cur CURSOR FOR zod_pre
 
   CALL s_showmsg_init()
 
   FOREACH zod_cur INTO l_zod.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH zod:',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
 
      IF l_zod02 <> "ALL" THEN
         IF l_zod.zod11 ='Y' THEN               #已刪除之資料不可檢核 
            CALL cl_err(l_zod.zod01,'azz-511',1)
            CONTINUE FOREACH
         END IF 
 
         SELECT zoc02 INTO l_openinsn FROM zoc_file   #匯入序號
          WHERE zoc01 = l_zod.zod01
            AND zoc05 ='6'
         
         IF cl_null(l_openinsn) THEN 
            CALL cl_err(l_zod.zod01,'azz-507',1)               #記錄TP單號的字段不能為空
            CONTINUE FOREACH
         END IF 
      END IF 
 
      #ORA-抓取table的primary key欄位
      LET l_sql =" SELECT LOWER(COLUMN_NAME) FROM ALL_CONS_COLUMNS ",
                 "  WHERE LOWER(OWNER)='ds'  ",
                 "    AND LOWER(TABLE_NAME) ='",l_zod.zod01 CLIPPED,"'  ",
                 "    AND LOWER(CONSTRAINT_NAME) LIKE '%_pk' ", 
                 "  ORDER BY POSITION  " 
 
      PREPARE ztd_pre FROM l_sql
      
      DECLARE ztd_cur CURSOR FOR ztd_pre
      
      LET l_c = 1
 
      LET l_err_key = ""
      LET l_ind_key = ""
 
      FOREACH ztd_cur INTO l_ztd[l_c].colname
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH ztd:',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF
 
         IF cl_null(l_err_key) THEN
            LET l_err_key = l_ztd[l_c].colname CLIPPED 
            LET l_ind_key = l_ztd[l_c].colname CLIPPED 
         ELSE  
            LET l_err_key = l_err_key CLIPPED,",",l_ztd[l_c].colname CLIPPED 
            LET l_ind_key = l_err_key CLIPPED,"||','||",l_ztd[l_c].colname CLIPPED 
         END IF
 
         LET l_c = l_c + 1
 
      END FOREACH
 
      LET l_c = l_c - 1
 
      #抓取筆數
      IF l_zod02 = "ALL" THEN
         LET l_sql =" SELECT COUNT(*) FROM ",l_zod.zod01 
      ELSE
         LET l_sql =" SELECT COUNT(*) FROM ",l_zod.zod01,
                    "  WHERE ",l_openinsn,"='",l_zod02,"'"
      END IF
 
      PREPARE count_pre FROM l_sql
      
      DECLARE count_cur CURSOR FOR count_pre
      
      OPEN count_cur 
 
      FETCH count_cur INTO l_tot_cnt
 
      IF l_tot_cnt = 0 OR cl_null(l_tot_cnt) THEN
         CALL cl_err('','azz-526',1)
         EXIT FOREACH
      END IF
 
      #抓取KEY值資料
     #LET l_sql =" SELECT ROWID FROM ",l_zod.zod01,
      IF l_zod02 = "ALL" THEN
         LET l_sql =" SELECT ",l_ind_key ," FROM ",l_zod.zod01 
      ELSE
         LET l_sql =" SELECT ",l_ind_key ," FROM ",l_zod.zod01,
                    "  WHERE ",l_openinsn,"='",l_zod02,"'"
      END IF
 
      PREPARE rowid_pre FROM l_sql
      
      DECLARE rowid_cur CURSOR FOR rowid_pre
      
     #FOREACH rowid_cur INTO l_rowid
      FOREACH rowid_cur INTO l_ind_val
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH rowid:',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF
 
         LET l_str = l_ind_val CLIPPED
 
         LET l_key2 =" 1=1"
 
         LET i = 0
 
         LET tok = base.StringTokenizer.create(l_str,",")
 
         WHILE tok.hasMoreTokens()
            LET ls_value = tok.nextToken()
            LET i = i +1
 
            SELECT zoc03 INTO l_zoc03 FROM zoc_file
             WHERE zoc02 = l_ztd[i].colname
 
            IF l_zoc03 = "NUMBER" THEN
               LET l_key2 = l_key2 CLIPPED," AND ",l_ztd[i].colname,"=",ls_value 
            ELSE  
               LET l_key2 = l_key2 CLIPPED," AND ",l_ztd[i].colname,"='",ls_value,"'" 
            END IF
            
        END WHILE
 
        ##抓取primary key欄位值資料 
        #FOR i = 1 TO l_c
        #   LET l_sql =" SELECT ",l_ztd[i].colname CLIPPED,
        #              "   FROM ",l_zod.zod01, 
        #              "  WHERE ROWID= '",l_rowid,"'"
        #   
        #   PREPARE key_pre FROM l_sql
        #   
        #   DECLARE key_cur CURSOR FOR key_pre
        #   
        #   OPEN key_cur 
 
        #   FETCH key_cur INTO l_chr200 
 
        #   IF cl_null(l_key2) THEN
        #      LET l_key2 = l_chr200 CLIPPED 
        #   ELSE  
        #      LET l_key2 = l_key2 CLIPPED,"/",l_chr200 CLIPPED 
        #   END IF
        #   
        #END FOR
 
         #抓取zoc資料
         LET l_sql =" SELECT * FROM zoc_file ",
                    "  WHERE zoc01 ='",l_zod.zod01,"'",
                    "    AND zoc05 = '0'"
         
         PREPARE zoc_pre FROM l_sql
         
         DECLARE zoc_cur CURSOR FOR zoc_pre
         
         FOREACH zoc_cur INTO l_zoc.*
            IF SQLCA.sqlcode THEN
               CALL cl_err('FOREACH zoc:',SQLCA.sqlcode,1)
               CONTINUE FOREACH
            END IF
 
            IF cl_null(l_zoc.zoc07) THEN
               CONTINUE FOREACH
            END IF
 
            #抓取要判斷的資料
 
            LET l_sql = "SELECT ",l_zoc.zoc02 CLIPPED,
                        "  FROM ",l_zoc.zoc01 CLIPPED,
                        " WHERE ",l_key2
                      # " WHERE ROWID = ? "
 
            PREPARE value_pre FROM l_sql
 
            DECLARE value_cur CURSOR FOR value_pre
 
           #OPEN value_cur USING l_rowid
            OPEN value_cur
 
            FETCH value_cur INTO l_chr200 
 
            #判斷資料的合理性
            IF cl_null(l_zoc.zoc10) THEN
               LET l_zoc.zoc10 = " 1=1 "
            END IF
 
            #No.FUN-8A0021--begin
            IF l_zoc.zoc07 ='IN' THEN
               LET l_sql = "SELECT COUNT(*) ",
                           "  FROM ",l_zoc.zoc01 CLIPPED,
                           " WHERE ",l_zoc.zoc02 CLIPPED," ",l_zoc.zoc07 CLIPPED,
                           " (",l_zoc.zoc10 CLIPPED,")"
 
               PREPARE chk_pre2 FROM l_sql
               EXECUTE chk_pre2 INTO l_chkno
               IF cl_null(l_chkno) OR l_chkno = 0 THEN
                  LET l_msg1 = l_err_key CLIPPED,",",l_zoc.zoc02 CLIPPED 
                  LET l_msg2 = l_str CLIPPED,"/",l_chr200 CLIPPED 
                  CALL cl_getmsg('azz-523',g_lang) RETURNING l_msg
                  LET l_msg = l_chr200 CLIPPED,l_msg CLIPPED,"(",l_zoc.zoc10,")"
                  CALL s_errmsg(l_msg1,l_msg2,l_msg,'',1)
               END IF
            ELSE
            #No.FUN-8A0021--end
               LET l_sql = "SELECT COUNT(*) ",
                           "  FROM ",l_zoc.zoc07 CLIPPED,
                           " WHERE ",l_zoc.zoc08 CLIPPED," = '",l_chr200 CLIPPED,"'",
                           "   AND ",l_zoc.zoc10
 
               PREPARE chk_pre FROM l_sql
               EXECUTE chk_pre INTO l_chkno
 
               IF cl_null(l_chkno) OR l_chkno = 0 THEN
                  LET l_msg1 = l_err_key CLIPPED,",",l_zoc.zoc02 CLIPPED 
                  LET l_msg2 = l_str CLIPPED,"/",l_chr200 CLIPPED 
 
                  CALL cl_getmsg('azz-523',g_lang) RETURNING l_msg
 
                  SELECT gat03 INTO l_tabname FROM gat_file
                   WHERE gat01=l_zoc.zoc07
                     AND gat02=g_lang
 
                  LET l_msg = l_chr200 CLIPPED,l_msg CLIPPED,l_tabname,"(",l_zoc.zoc07,")"
 
                  CALL s_errmsg(l_msg1,l_msg2,l_msg,'',1)
               END IF
            END IF                         #No.FUN-8A0021
         END FOREACH
 
      END FOREACH
 
   END FOREACH
 
   CALL s_showmsg()
 
END FUNCTION
#-----No.FUN-890131 END-----
