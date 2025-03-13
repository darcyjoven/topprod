# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_opendel.4gl
# Descriptions...: 開帳資料刪除作業
# Input parameter:
# Date & Author..: FUN-810012 08/03/13 By ice 作業新增
# Modify.........: FUN-8A0050 08/10/13 By Nicola   
 
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
    g_rec_b3        LIKE type_file.num5,   #單身筆數
    l_ac2           LIKE type_file.num5,   #目前處理的ARRAY CNT
    l_ac3           LIKE type_file.num5    #目前處理的ARRAY CNT
 
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
 
   OPEN WINDOW p_opendel_w AT p_row,p_col
      WITH FORM "azz/42f/p_opendel"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL p_opendel_q()
 
   CALL p_opendel_menu()
 
   CLOSE WINDOW p_opendel_w               #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION p_opendel_curs()
 
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
 
   CALL p_opendel_b_fill(g_wc)  
 # CALL p_opendel_b_fill2(g_wc2)   
 
END FUNCTION
 
FUNCTION p_opendel_menu()
   DEFINE l_cmd   STRING    
 
   WHILE TRUE
      CALL p_opendel_bp("G")
   
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p_opendel_q()
            END IF
       # WHEN "condition_detail"
       #    IF cl_chk_act_auth() THEN
       #       CALL p_opendel_b2()
       #    ELSE
       #       LET g_action_choice = NULL
       #    END IF
         WHEN "qry_condition_detail"
            IF cl_chk_act_auth() THEN
               CALL p_opendel_bp2('G')
            ELSE 
               LET g_action_choice = NULL 
            END IF
         WHEN "del_detail"
            IF cl_chk_act_auth() THEN
               CALL p_opendel_del("ALL")
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
 
FUNCTION p_opendel_zoa03(p_cmd)
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
FUNCTION p_opendel_q()
 
   CLEAR FORM
   CALL g_zoa.clear()
   CALL p_opendel_curs()                    #取得查詢條件
   IF INT_FLAG THEN                         #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
 
END FUNCTION
 
#單身
FUNCTION p_opendel_b2()
   DEFINE l_ac2_t         LIKE type_file.num5            #未取消的ARRAY CNT
   DEFINE l_n             LIKE type_file.num5            #檢查重復用       
   DEFINE l_lock_sw       LIKE type_file.chr1            #單身鎖住否       
   DEFINE p_cmd           LIKE type_file.chr1            #處理狀態         
   DEFINE l_allow_insert  LIKE type_file.num5            #可新增否         
   DEFINE l_allow_delete  LIKE type_file.num5            #可刪除否         
 
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
   DECLARE p_opendel_bcl2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac2_t = 0
 
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
              OPEN p_opendel_bcl2 USING g_zoa[l_ac].zoa03,g_zod_t.zod01,g_zod_t.zod02
              IF STATUS THEN
                 CALL cl_err("OPEN p_opendel_bcl2:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH p_opendel_bcl2 INTO g_zod[l_ac2].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_zod_t.zod05,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()
           END IF
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_zod[l_ac2].* = g_zod_t.*
              CLOSE p_opendel_bcl2
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
              CLOSE p_opendel_bcl2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE p_opendel_bcl2
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
   
   CLOSE p_opendel_bcl2
   COMMIT WORK
 
END FUNCTION
 
FUNCTION p_opendel_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc     STRING
   DEFINE l_i      LIKE type_file.num10
 
   LET g_sql ="SELECT zoa01,zoa03,'',zoa04,zoa05,zoa06,zoa07 FROM zoa_file ",
              " WHERE ",p_wc CLIPPED,
              " ORDER BY zoa01,zoa03"
 
   PREPARE p_opendel_p2 FROM g_sql           #預備一下
   DECLARE zoa_curs CURSOR FOR p_opendel_p2
 
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
 
FUNCTION p_opendel_b_fill2(p_wc2)              #BODY FILL UP
   DEFINE p_wc2     STRING
 
   LET g_sql ="SELECT zod01,zod02,zod03,zod04,zod05,zod06,zod07,zod08,zod09,zod10,zod11,zod12 FROM zob_file,zod_file ",
              " WHERE zod00 = '",g_zoa[l_ac].zoa03,"'",
              "   AND zod00 = zob01  ",
              "   AND zod01 = zob02  ",
              "   AND zob04 = 'Y'    ",
              "   AND ",p_wc2 CLIPPED,
              " ORDER BY zod02"
 
   PREPARE p_opendel_pb2 FROM g_sql      #預備一下
   DECLARE zod_curs CURSOR FOR p_opendel_pb2
 
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
 
FUNCTION p_opendel_bp(p_ud)
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
         CALL p_opendel_b_fill2(" 1=1")
         CALL p_opendel_bp2_refresh()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
     #ON ACTION condition_detail         
     #   LET g_action_choice="condition_detail"
     #   LET l_ac2 = 1
     #   EXIT DISPLAY
 
      ON ACTION qry_condition_detail
         LET g_action_choice="qry_condition_detail"
         EXIT DISPLAY
 
      ON ACTION del_detail
         LET g_action_choice="del_detail"
         EXIT DISPLAY        
 
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
 
FUNCTION p_opendel_bp2_refresh()
 
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
 
FUNCTION p_opendel_bp2(p_ud)
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
      ON ACTION del_detail
         LET l_ac2 = ARR_CURR()
         IF l_ac2 >= 1 THEN
            IF cl_chk_act_auth() THEN
               CALL p_opendel_del(g_zod[l_ac2].zod02)
            END IF
         END IF
         EXIT DISPLAY
      #-----No.FUN-8A0050 END-----
 
   END DISPLAY
 
   CALL cl_set_act_visible("cancel", FALSE)
 
END FUNCTION
 
FUNCTION p_opendel_del(p_zod02)
   DEFINE p_zod02         LIKE zod_file.zod02
   DEFINE l_ac3_t         LIKE type_file.num5            #未取消的ARRAY CNT
   DEFINE l_n             LIKE type_file.num5            #檢查重復用       
   DEFINE l_max           LIKE type_file.num5            #記錄最大項次
   DEFINE l_det           LIKE type_file.num5            #有資料的最大項次
   DEFINE i               LIKE type_file.num5            
   DEFINE l_lock_sw       LIKE type_file.chr1            #單身鎖住否       
   DEFINE p_cmd           LIKE type_file.chr1            #處理狀態         
   DEFINE l_allow_insert  LIKE type_file.num5            #可新增否         
   DEFINE l_allow_delete  LIKE type_file.num5             #可刪除否         
   DEFINE g_del           RECORD 
                             zod02   LIKE zod_file.zod02
                          END RECORD
   DEFINE l_del           DYNAMIC ARRAY OF RECORD 
                             zod01   LIKE zod_file.zod01,
                             zod09   LIKE zod_file.zod09,
                             zod10   LIKE zod_file.zod10,
                             zod11   LIKE zod_file.zod11,
                             zod12   LIKE zod_file.zod12,
                             zoc02   LIKE zoc_file.zoc02
                          END RECORD
   DEFINE g_del_t         RECORD 
                             imn02   LIKE imn_file.imn02,
                             zod02   LIKE zod_file.zod02
                          END RECORD
   DEFINE a_sql           STRING
   DEFINE b_sql           STRING                   
   DEFINE p_row,p_col     LIKE type_file.num5
 
   IF cl_null(g_zoa[l_ac].zoa03) THEN
      RETURN
   END IF
 
   LET p_row = 4 LET p_col = 30
 
   OPEN WINDOW p_opendel_1_w AT p_row,p_col
      WITH FORM "azz/42f/p_opendel_1"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_opendel_1")
 
   IF STATUS THEN CALL cl_err('open win:',STATUS,1) RETURN END IF
 
   LET g_action_choice = ""
   LET l_max =0
 
   INPUT BY NAME g_del.zod02
 
     #-----No.FUN-8A0050-----
      BEFORE FIELD zod02
         LET g_del.zod02 = p_zod02
         DISPLAY g_del.zod02 TO zod02
     #-----No.FUN-8A0050 END-----
 
      AFTER FIELD zod02
         IF NOT cl_null(g_del.zod02) THEN 
            SELECT COUNT(*) INTO l_n 
              FROM zob_file,zod_file    #存在于zod中的且為匯入資料
             WHERE zod00 = zob01  
               AND zod01 = zob02 
               AND zob04 = 'Y' 
               AND zod02 = g_del.zod02
            IF l_n = 0  THEN 
               IF g_del.zod02 <> "ALL" THEN
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
      CLOSE WINDOW  p_opendel_1_w
      RETURN
   END IF
 
   IF g_del.zod02 = "ALL" THEN
      LET a_sql =" SELECT UNIQUE zod01,''  FROM zod_file   ", 
                 "  WHERE zod00 = '",g_zoa[l_ac].zoa03,"' "  
   ELSE
      LET a_sql =" SELECT zod01,zod11  FROM zod_file   ",
                 " WHERE zod02 = '",g_del.zod02,"' "
   END IF
 
   PREPARE p_opendel_a_pre FROM a_sql           #預備一下
   DECLARE del_a_cur CURSOR FOR p_opendel_a_pre
 
   LET l_det = 1
   
   IF cl_sure(18,20) THEN
      LET g_success = 'Y'
      BEGIN WORK
 
      FOREACH del_a_cur INTO l_del[l_det].zod01,l_del[l_det].zod11
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            CLOSE WINDOW p_opendel_1_w
            RETURN
         END IF
      
         IF g_del.zod02 <> "ALL"  THEN
            IF l_del[l_det].zod11 ='Y' THEN 
               CALL cl_err(g_del.zod02,'azz-511',1)               #已刪除
               CLOSE WINDOW p_opendel_1_w
               RETURN
            END IF 
      
            SELECT zoc02 INTO l_del[l_det].zoc02 FROM zoc_file
             WHERE zoc01 = l_del[l_det].zod01     #表
               AND zoc05 ='6'                     #單據編號 TP編號欄位
            
            IF SQLCA.sqlcode THEN 
               CALL cl_err(g_del.zod02,SQLCA.sqlcode,1)
               CLOSE WINDOW p_opendel_1_w
               RETURN
            END IF
      
            IF cl_null(l_del[l_det].zoc02) THEN 
               CALL cl_err(g_del.zod02,'azz-507',1)               #記錄TP單號的字段不能為空
               CLOSE WINDOW p_opendel_1_w
               RETURN
            END IF 
         END IF
 
         IF g_del.zod02 = "ALL" THEN
            LET b_sql =" DELETE FROM  ",l_del[l_det].zod01
         ELSE
            LET b_sql =" DELETE FROM  ",l_del[l_det].zod01,
                       "  WHERE ",l_del[l_det].zoc02," = '",g_del.zod02,"' "
         END IF
 
         PREPARE p_opendel_b_pre FROM b_sql           #預備一下
         EXECUTE p_opendel_b_pre
 
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            IF SQLCA.sqlcode = 0 THEN
               CALL cl_err('FOREACH:','azz-522',1)
            ELSE
               CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            END IF
            LET g_success = 'N'
            EXIT FOREACH
         END IF
 
         IF g_del.zod02 = "ALL" THEN
            UPDATE zod_file SET zod11 ='Y' 
             WHERE zod01 = l_del[l_det].zod01    #表
         ELSE
            UPDATE zod_file SET zod11 ='Y' 
             WHERE zod01 = l_del[l_det].zod01    #表
               AND zod02 = g_del.zod02       #序號
         END IF
 
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF          
      END FOREACH
 
      IF g_success = 'Y' THEN                                                                                                 
         COMMIT WORK                                                                                                          
         CALL cl_err('','abm-019',1)
      ELSE                                                                                                                    
         ROLLBACK WORK                                                                                                        
         CALL cl_err('','aic-060',1)
      END IF 
   END IF 
 
   CLOSE WINDOW  p_opendel_1_w
      
 
  #LET a_sql =" SELECT zod01,zod09,zod10,zod11,zod12  FROM zod_file   ",
  #           " WHERE zod02 = '",g_del.zod02,"' "
  #PREPARE p_opendel_a_pre FROM a_sql           #預備一下
  #DECLARE del_a_cur CURSOR FOR p_opendel_a_pre
 
  #LET l_det = 1
  #
  #FOREACH del_a_cur INTO l_del[l_det].zod01,l_del[l_det].zod09,l_del[l_det].zod10,l_del[l_det].zod11,l_del[l_det].zod12
  #   IF SQLCA.sqlcode THEN
  #      CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
  #      CLOSE WINDOW p_opendel_1_w
  #      RETURN
  #   END IF
 
  #   IF l_del[l_det].zod11 ='Y' THEN 
  #      CALL cl_err(g_del.zod02,'azz-511',1)               #已刪除
  #      CLOSE WINDOW p_opendel_1_w
  #      RETURN
  #   END IF 
 
  #      SELECT zoc02 INTO l_del[l_det].zoc02 FROM zoc_file
  #       WHERE zoc01 = l_del[l_det].zod01     #表
  #         AND zoc05 ='6'                     #單據編號 TP編號欄位
  #      
  #      IF SQLCA.sqlcode THEN 
  #         CALL cl_err(g_del.zod02,SQLCA.sqlcode,1)
  #         CLOSE WINDOW p_opendel_1_w
  #         RETURN
  #      END IF
 
  #   IF cl_null(l_del[l_det].zoc02) THEN 
  #      CALL cl_err(g_del.zod02,'azz-507',1)               #記錄TP單號的字段不能為空
  #      CLOSE WINDOW p_opendel_1_w
  #      RETURN
  #   END IF 
  #   LET l_det = l_det + 1
  #END FOREACH 
 
  #LET l_det = l_det-1
  #
  #IF l_det = 0 THEN 
  #   CALL cl_err(g_del.zod02,'azz-509',1)                 #沒有滿足的表
  #   CLOSE WINDOW p_opendel_1_w
  #   RETURN                
  #ELSE 
  #   IF cl_sure(18,20) THEN
  #      LET g_success = 'Y'
  #      BEGIN WORK
 
  #      FOR i = 1 TO l_det 
  #         LET b_sql =" DELETE FROM  ",l_del[i].zod01," ",
  #                    "  WHERE ",l_del[i].zoc02," = '",g_del.zod02,"' "
  #         PREPARE p_opendel_b_pre FROM b_sql           #預備一下
  #         EXECUTE p_opendel_b_pre
  #         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
  #            IF SQLCA.sqlcode = 0 THEN
  #               CALL cl_err('FOREACH:','azz-522',1)
  #            ELSE
  #               CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
  #            END IF
  #            LET g_success = 'N'
  #            EXIT FOR
  #         END IF
  #         UPDATE zod_file SET zod11 ='Y' 
  #          WHERE zod01 = l_del[i].zod01    #表
  #            AND zod02 = g_del.zod02       #序號
  #         IF SQLCA.sqlcode THEN
  #            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
  #            LET g_success = 'N'
  #            EXIT FOR
  #         END IF          
  #      END FOR   
  #      IF g_success = 'Y' THEN                                                                                                 
  #         COMMIT WORK                                                                                                          
  #         CALL cl_err('','abm-019',1)
  #      ELSE                                                                                                                    
  #         ROLLBACK WORK                                                                                                        
  #         CALL cl_err('','aic-060',1)
  #      END IF 
  #   END IF 
  #END IF 
 
  #CLOSE WINDOW  p_opendel_1_w
      
END FUNCTION
#No.FUN-810012
