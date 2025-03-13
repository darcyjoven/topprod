# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: apmi004
# Descriptions...: 供應商評核項目設定
# Date & Author..: FUN-720041 07/03/02 By yiting
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ppa       DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                   ppa01   LIKE ppa_file.ppa01, #FUN-720041
                   ppa02   LIKE ppa_file.ppa02,
                   ppa03   LIKE ppa_file.ppa03
                   END RECORD,
       g_ppa_t     RECORD                 #程式變數 (舊值)
                   ppa01   LIKE ppa_file.ppa01,
                   ppa02   LIKE ppa_file.ppa02,
                   ppa03   LIKE ppa_file.ppa03
                   END RECORD,
       g_wc,g_sql  STRING,   #NO.TQC-630166 
       g_rec_b     LIKE type_file.num5,                #單身筆數               #No.FUN-680136 SMALLINT
       l_ac        LIKE type_file.num5                 #目前處理的ARRAY CNT    #No.FUN-680136 SMALLINT
DEFINE p_row,p_col LIKE type_file.num5                 #No.FUN-680136 SMALLINT 
DEFINE g_before_input_done  LIKE type_file.num5        #No.FUN-680136 SMALLINT
DEFINE g_forupd_sql    STRING
DEFINE g_cnt           LIKE type_file.num10            #No.FUN-680136 INTEGER
DEFINE g_i             LIKE type_file.num5             #No.FUN-680136 SMALLINT
DEFINE g_msg           LIKE ze_file.ze03               #No.FUN-680136 VARCHAR(72)
DEFINE li_result       LIKE type_file.num5             #No.FUN-680136 SMALLINT
 
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
 
   LET p_row = 4 LET p_col = 5
 
   OPEN WINDOW i004_w AT p_row,p_col WITH FORM "apm/42f/apmi004"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
       
   LET g_wc ='1=1'  CALL i004_b_fill(g_wc)  #No.TQC-6C0212 
   CALL i004_menu()
 
   CLOSE WINDOW i004_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i004_menu()
 
   WHILE TRUE
      CALL i004_bp("G")
 
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i004_q() 
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN 
               CALL i004_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ppa),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i004_q()
 
   CALL i004_b_askkey()
 
END FUNCTION
 
FUNCTION i004_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT   #No.FUN-680136 SMALLINT
          l_n             LIKE type_file.num5,                #檢查重複用          #No.FUN-680136 SMALLINT
          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否          #No.FUN-680136 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,                #處理狀態            #No.FUN-680136 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,                #可新增否            #No.FUN-680136 SMALLINT
          l_allow_delete  LIKE type_file.num5                 #可刪除否            #No.FUN-680136 SMALLINT
   DEFINE l_ima131        LIKE ima_file.ima131                #No.MOD-640029
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ppa01,ppa02,ppa03 ",
                      "  FROM ppa_file",
                      "  WHERE ppa01 = ?",
                      "   AND ppa02 = ?",
                      "   FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i004_bcl CURSOR FROM g_forupd_sql
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ppa WITHOUT DEFAULTS FROM s_ppa.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
          
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd = 'u'
            LET g_ppa_t.* = g_ppa[l_ac].* 
            BEGIN WORK
            OPEN i004_bcl USING g_ppa_t.ppa01,g_ppa_t.ppa02
            IF STATUS THEN
               CALL cl_err("OPEN i004_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i004_bcl INTO g_ppa[l_ac].* 
               IF STATUS THEN
                  CALL cl_err(g_ppa_t.ppa01,STATUS,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO ppa_file(ppa01,ppa02,ppa03)
                       VALUES(g_ppa[l_ac].ppa01,g_ppa[l_ac].ppa02,
                              g_ppa[l_ac].ppa03)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ppa_file",g_ppa[l_ac].ppa01,"",
                          SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_ppa[l_ac].* TO NULL
         LET g_ppa_t.* = g_ppa[l_ac].* 
         CALL cl_show_fld_cont()
         NEXT FIELD ppa01
 
      BEFORE FIELD ppa01                        #default 序號
          IF g_ppa[l_ac].ppa01 IS NULL OR
             g_ppa[l_ac].ppa01 = 0 THEN
             SELECT max(ppa01)+1
                 INTO g_ppa[l_ac].ppa01
                 FROM ppa_file
             IF g_ppa[l_ac].ppa01 IS NULL THEN
                LET g_ppa[l_ac].ppa01 = 1
             END IF
          END IF
 
      AFTER FIELD ppa01                        #check 序號是否重複
          IF g_ppa[l_ac].ppa01 IS NULL THEN
             LET g_ppa[l_ac].ppa01 = g_ppa_t.ppa01
          END IF
          IF NOT cl_null(g_ppa[l_ac].ppa01) THEN
              IF g_ppa[l_ac].ppa01 != g_ppa_t.ppa01 OR
                 g_ppa_t.ppa01 IS NULL THEN
                  SELECT count(*)
                      INTO l_n
                      FROM ppa_file
                     WHERE ppa01 = g_ppa[l_ac].ppa01
                  IF l_n > 0 THEN
                      CALL cl_err('',-239,1)  
                      LET g_ppa[l_ac].ppa01 = g_ppa_t.ppa01
                      NEXT FIELD ppa01
                  END IF
              END IF
              LET g_ppa_t.ppa01 = g_ppa[l_ac].ppa01
          END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_ppa_t.ppa01) AND NOT cl_null(g_ppa_t.ppa02) THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM ppa_file
             WHERE ppa01 = g_ppa_t.ppa01
               AND ppa02 = g_ppa_t.ppa02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ppa_file",g_ppa_t.ppa01,"",
                             SQLCA.sqlcode,"","",1)  #No.FUN-660129  
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"
            CLOSE i004_bcl
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ppa[l_ac].* = g_ppa_t.*
            CLOSE i004_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ppa[l_ac].ppa01,-263,1)
            LET g_ppa[l_ac].* = g_ppa_t.*
         ELSE
            UPDATE ppa_file SET ppa01=g_ppa[l_ac].ppa01,
                                ppa02=g_ppa[l_ac].ppa02,
                                ppa03=g_ppa[l_ac].ppa03
             WHERE ppa01 = g_ppa_t.ppa01
               AND ppa02 = g_ppa_t.ppa02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ppa_file",g_ppa[l_ac].ppa01,"",
                             SQLCA.sqlcode,"","",1)  #No.FUN-660129
               LET g_ppa[l_ac].* = g_ppa_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i004_bcl
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac      #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN 
               LET g_ppa[l_ac].* = g_ppa_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_ppa.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF 
            CLOSE i004_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D30034 add
         CLOSE i004_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(ppa01) AND l_ac > 1 THEN
            LET g_ppa[l_ac].* = g_ppa[l_ac-1].*
            NEXT FIELD ppa01
         END IF
 
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
       
   END INPUT
 
   CLOSE i004_bcl
   COMMIT WORK
       
END FUNCTION
 
FUNCTION i004_b_askkey()
 
   CLEAR FORM
   CALL g_ppa.clear()
   CALL cl_opmsg('q')
 
   CONSTRUCT g_wc ON ppa01,ppa02,ppa03
                FROM s_ppa[1].ppa01,s_ppa[1].ppa02,s_ppa[1].ppa03
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
    
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
    
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
   
 
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      RETURN
   END IF
 
   CALL i004_b_fill(g_wc)
 
END FUNCTION
 
FUNCTION i004_b_fill(p_wc2)
   DEFINE p_wc2   LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
   DEFINE l_n     LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   LET g_sql = "SELECT ppa01,ppa02,ppa03 ",
               "  FROM ppa_file",
               " WHERE ", p_wc2 CLIPPED,
               " ORDER BY ppa01,ppa02,ppa03"
 
   PREPARE i004_pb FROM g_sql
   DECLARE ppa_curs CURSOR FOR i004_pb
 
   CALL g_ppa.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH ppa_curs INTO g_ppa[g_cnt].*
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
 
   CALL g_ppa.deleteElement(g_cnt)
 
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i004_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ppa TO s_ppa.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      
      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
