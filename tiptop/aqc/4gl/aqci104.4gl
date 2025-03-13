# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aqci104.4gl
# Descriptions...: 1916檢驗水準樣本代碼資料建立作業
# Date & Author..: 10/08/10 By wujie FUN-A80063
# Modify.........: No:MOD-B30494 11/03/16 By suncx qdf03預設值修改
# Modify.........: No:FUN-D30034 13/04/17 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-A80063 
DEFINE
     g_qdf          DYNAMIC ARRAY OF RECORD
                    qdf01         LIKE qdf_file.qdf01,
                    qdf02         LIKE qdf_file.qdf02,
                    qdf03         LIKE qdf_file.qdf03,
                    qdf04         LIKE qdf_file.qdf04
                    END RECORD,
    g_qdf_t         RECORD
                    qdf01         LIKE qdf_file.qdf01,
                    qdf02         LIKE qdf_file.qdf02,
                    qdf03         LIKE qdf_file.qdf03,
                    qdf04         LIKE qdf_file.qdf04
                    END RECORD,
    g_wc2,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,            #單身筆數       
    l_ac            LIKE type_file.num5             #目前處理的ARRAY CNT       
DEFINE g_cnt          LIKE type_file.num10       
DEFINE g_forupd_sql   STRING                    
DEFINE g_before_input_done   LIKE type_file.num5   


MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   

   OPEN WINDOW i104_w WITH FORM "aqc/42f/aqci104"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1' CALL i104_b_fill(g_wc2)
   CALL i104_menu()

   CLOSE WINDOW i104_w  
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN
 
FUNCTION i104_menu()
 
   WHILE TRUE
      CALL i104_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i104_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i104_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qdf),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i104_q()
   CALL i104_b_askkey()
END FUNCTION
 
FUNCTION i104_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT        #No.FUN-680104 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,         #檢查重複用        #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否        #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #處理狀態        #No.FUN-680104 VARCHAR(1)
    max_qdf04       LIKE qdf_file.qdf04,
    l_allow_insert  LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)             #可新增否
    l_allow_delete  LIKE type_file.chr1          #No.FUN-680104 VARCHAR(01)              #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT qdf01,qdf02,qdf03,qdf04  ",
                       "  FROM qdf_file ",
                       " WHERE qdf01=? AND qdf02=? ",
                       "   AND qdf03=? ",   #MOD-B30494 add 
                       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i104_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_qdf WITHOUT DEFAULTS FROM s_qdf.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_qdf_t.* = g_qdf[l_ac].*  #BACKUP
                OPEN i104_bcl USING g_qdf_t.qdf01,g_qdf_t.qdf02,g_qdf_t.qdf03   ##MOD-B30494 add qdf03
                IF STATUS THEN
                   CALL cl_err("OPEN i104_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i104_bcl INTO g_qdf[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_qdf_t.qdf03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()    
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_qdf[l_ac].* TO NULL     
            CALL cl_show_fld_cont()   
            LET g_qdf_t.* = g_qdf[l_ac].*         #新輸入資料
 
        AFTER INSERT
         IF INT_FLAG THEN                
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE i104_bcl
         END IF
         INSERT INTO qdf_file(qdf01,qdf02,qdf03,qdf04)  
                       VALUES(g_qdf[l_ac].qdf01,g_qdf[l_ac].qdf02,
                              g_qdf[l_ac].qdf03,g_qdf[l_ac].qdf04)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","qdf_file",g_qdf[l_ac].qdf01,g_qdf[l_ac].qdf02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2      
         END IF
 
        AFTER FIELD qdf03
            IF g_qdf[l_ac].qdf03<0 THEN
               CALL cl_err('','afa1001',0)
               NEXT FIELD qdf03
            END IF

        AFTER FIELD qdf04
            IF NOT cl_null(g_qdf[l_ac].qdf04) THEN
               IF g_qdf[l_ac].qdf04 < g_qdf[l_ac].qdf03 THEN
                  NEXT FIELD qdf04
               END IF
            END IF
 
        AFTER FIELD qdf01                        #check 是否重複
          IF NOT cl_null(g_qdf[l_ac].qdf01) THEN
            IF g_qdf[l_ac].qdf01 NOT MATCHES '[1234567RT]' THEN              
               NEXT FIELD qdf01
            END IF
            IF g_qdf[l_ac].qdf01 != g_qdf_t.qdf01 OR
               g_qdf[l_ac].qdf02 != g_qdf_t.qdf02 OR
               g_qdf_t.qdf01 IS NULL OR
               g_qdf_t.qdf02 IS NULL THEN
               SELECT count(*) INTO l_n FROM qdf_file
                  WHERE qdf01 = g_qdf[l_ac].qdf01
                    AND qdf02 = g_qdf[l_ac].qdf02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_qdf[l_ac].qdf01 = g_qdf_t.qdf01
                  LET g_qdf[l_ac].qdf02 = g_qdf_t.qdf02
                  NEXT FIELD qdf01
               END IF
            END IF
            IF g_qdf_t.qdf03 IS NULL OR
               ( NOT cl_null(g_qdf[l_ac].qdf03) AND
                 g_qdf_t.qdf03 !=g_qdf[l_ac].qdf03) THEN
               # check所輸入之數量是否有區間重疊
                SELECT COUNT(*) INTO l_cnt FROM qdf_file
                 WHERE g_qdf[l_ac].qdf03 BETWEEN qdf03 AND qdf04
                   AND qdf01=g_qdf[l_ac].qdf01
                IF l_cnt > 0 THEN
                   CALL cl_err(g_qdf[l_ac].qdf03,'aqc-035',1)
                   NEXT FIELD qdf03
                END IF
            END IF
            IF g_qdf_t.qdf04 IS NULL OR
               ( NOT cl_null(g_qdf[l_ac].qdf04) AND
                 g_qdf_t.qdf04 !=g_qdf[l_ac].qdf04) THEN
               # check所輸入之數量是否有數量區間重疊
                SELECT COUNT(*) INTO l_cnt FROM qdf_file
                 WHERE g_qdf[l_ac].qdf04 BETWEEN qdf03 AND qdf04
                   AND qdf01=g_qdf[l_ac].qdf01
                IF l_cnt > 0 THEN
                   CALL cl_err(g_qdf[l_ac].qdf04,'aqc-035',1)
                   NEXT FIELD qdf04
                END IF
            END IF
            IF cl_null(g_qdf[l_ac].qdf03) THEN 
                SELECT max(qdf04) INTO g_qdf[l_ac].qdf03
                  FROM qdf_file
                 WHERE qdf01 = g_qdf[l_ac].qdf01
                   
                IF g_qdf[l_ac].qdf03 = 999999 THEN
                   MESSAGE ' '
                END IF
                LET g_qdf[l_ac].qdf03 = g_qdf[l_ac].qdf03 + 1
                IF cl_null(g_qdf[l_ac].qdf03) THEN
                   #LET g_qdf[l_ac].qdf03 = 1   #MOD-B30494 mark
                   LET g_qdf[l_ac].qdf03 = 2    #MOD-B30494 add
                END IF
            END IF
            IF g_qdf[l_ac].qdf01 != g_qdf_t.qdf01 OR
               g_qdf_t.qdf01 IS NULL OR  
               g_qdf[l_ac].qdf02 != g_qdf_t.qdf02 OR
               g_qdf_t.qdf02 IS NULL AND  
               g_qdf[l_ac].qdf03 IS NOT NULL THEN     
               SELECT count(*) INTO l_n FROM qdf_file
                  WHERE qdf01 = g_qdf[l_ac].qdf01
                    AND qdf02 = g_qdf[l_ac].qdf02
                    AND qdf03 = g_qdf[l_ac].qdf03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_qdf[l_ac].qdf01 = g_qdf_t.qdf01
                  NEXT FIELD qdf01
               END IF
            END IF
          END IF
    
        AFTER FIELD qdf02  
            IF g_qdf[l_ac].qdf01 != g_qdf_t.qdf01 OR
               g_qdf_t.qdf01 IS NULL OR  
               g_qdf[l_ac].qdf02 != g_qdf_t.qdf02 OR
               g_qdf_t.qdf02 IS NULL AND  
               g_qdf[l_ac].qdf03 IS NOT NULL THEN     
               SELECT count(*) INTO l_n FROM qdf_file
                  WHERE qdf01 = g_qdf[l_ac].qdf01
                    AND qdf02 = g_qdf[l_ac].qdf02
                    AND qdf03 = g_qdf[l_ac].qdf03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_qdf[l_ac].qdf01 = g_qdf_t.qdf01
                  NEXT FIELD qdf01
               END IF
            END IF
 
 
        BEFORE DELETE                            #是否取消單身
            IF g_qdf_t.qdf03 IS NOT NULL THEN
                IF NOT cl_delete() THEN
	           ROLLBACK WORK
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM qdf_file
                 WHERE qdf01 = g_qdf_t.qdf01
                   AND qdf02 = g_qdf_t.qdf02
                   AND qdf03 = g_qdf_t.qdf03
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","qdf_file",g_qdf_t.qdf01,g_qdf_t.qdf02,SQLCA.sqlcode,"","",1) 
	           ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2     
                MESSAGE "Delete OK"
                CLOSE i104_bcl
                COMMIT WORK
            END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN               
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_qdf[l_ac].* = g_qdf_t.*
            CLOSE i104_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_qdf[l_ac].qdf03,-263,1)
             LET g_qdf[l_ac].* = g_qdf_t.*
         ELSE
             UPDATE qdf_file SET
                    qdf01 = g_qdf[l_ac].qdf01,
                    qdf02 = g_qdf[l_ac].qdf02,
                    qdf03 = g_qdf[l_ac].qdf03,
                    qdf04 = g_qdf[l_ac].qdf04
              WHERE qdf01 = g_qdf_t.qdf01
                AND qdf02 = g_qdf_t.qdf02
                AND qdf03 = g_qdf_t.qdf03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","qdf_file",g_qdf_t.qdf01,g_qdf_t.qdf02,SQLCA.sqlcode,"","",1) 
                LET g_qdf[l_ac].* = g_qdf_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i104_bcl
                COMMIT WORK
             END IF
         END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qdf[l_ac].* = g_qdf_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_qdf.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE i104_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i104_bcl
            COMMIT WORK
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(qdf03) AND l_ac > 1 THEN
                LET g_qdf[l_ac].* = g_qdf[l_ac-1].*
                NEXT FIELD qdf03
            END IF
 
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
 
 
        END INPUT
 
    CLOSE i104_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i104_b_askkey()
    CLEAR FORM
    CONSTRUCT g_wc2 ON qdf01,qdf02,qdf03,qdf04
            FROM s_qdf[1].qdf01,s_qdf[1].qdf02,
                 s_qdf[1].qdf03,s_qdf[1].qdf04
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

    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) 
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i104_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i104_b_fill(p_wc2)              #BODY FILL UP
    DEFINE p_wc2 STRING 
 
    LET g_sql = "SELECT qdf01,qdf02,qdf03,qdf04 ",
                 " FROM qdf_file  ",
                 " WHERE ", p_wc2 CLIPPED,                     #單身
                #" ORDER BY 1"   #MOD-B30494 mark 
                 " ORDER BY qdf01,qdf02,qdf03 "  #MOD-B30494 add
 
    PREPARE i104_pb FROM g_sql
    DECLARE qdf_curs CURSOR FOR i104_pb
 
    CALL g_qdf.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH qdf_curs INTO g_qdf[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    MESSAGE ""
    CALL g_qdf.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2      #No.TQC-710119
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i104_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qdf TO s_qdf.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         EXIT DISPLAY
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
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()     
 
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
  
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
