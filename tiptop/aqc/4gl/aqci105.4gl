# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aqci105.4gl
# Descriptions...: 1916抽樣計劃資料維護作業
# Date & Author..: 10/08/10 By wujie FUN-A80063
# Modify.........: No:MOD-B30494 11/03/17 by suncx 修改畫面,當qdg01=3時，qdg05和qdg06可不輸入值 
# Modify.........: No:FUN-D30034 13/04/17 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-A80063 
DEFINE
    g_qdg   DYNAMIC ARRAY OF RECORD LIKE qdg_file.*, #程式變數(Program Variables)
    g_qdg_t         RECORD LIKE qdg_file.*,          #程式變數 (舊值)
    g_wc2,g_sql     STRING,                          
    g_rec_b         LIKE type_file.num5,             #單身筆數       
    l_ac            LIKE type_file.num5              #目前處理的ARRAY CNT        
 DEFINE g_forupd_sql STRING                          #SELECT ... FOR UPDATE SQL
 DEFINE g_before_input_done   LIKE type_file.num5  
 DEFINE   g_cnt           LIKE type_file.num10     
 
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
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
 
   OPEN WINDOW i105_w WITH FORM "aqc/42f/aqci105"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1' CALL i105_b_fill(g_wc2)
   CALL i105_menu()

   CLOSE WINDOW i105_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN
 

FUNCTION i105_menu()
 
   WHILE TRUE
      CALL i105_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i105_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i105_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qdg),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i105_q()
   CALL i105_b_askkey()
END FUNCTION
 
FUNCTION i105_b()
DEFINE
    l_ac_t          LIKE type_file.num5,        #未取消的ARRAY CNT #No.FUN-680104 SMALLINT
    l_n             LIKE type_file.num5,        #檢查重複用        #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,        #單身鎖住否        #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,        #處理狀態          #No.FUN-680104 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,        #No.FUN-680104 VARCHAR(1) #可新增否
    l_allow_delete  LIKE type_file.chr1         #No.FUN-680104 VARCHAR(1) #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT * FROM qdg_file ",
                       "  WHERE qdg01 = ? AND qdg02 = ? AND qdg03 = ? FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i105_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_qdg WITHOUT DEFAULTS FROM s_qdg.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            #新UI點多筆時無法UPDATE
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_qdg_t.* = g_qdg[l_ac].*  #BACKUP
                OPEN i105_bcl USING g_qdg_t.qdg01,g_qdg_t.qdg02,g_qdg_t.qdg03
                IF STATUS THEN
                   CALL cl_err("OPEN i105_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                END IF
                FETCH i105_bcl INTO g_qdg[l_ac].*
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_qdg_t.qdg01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                END IF
                CALL cl_show_fld_cont()     
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_qdg[l_ac].* TO NULL      
            LET g_qdg_t.* = g_qdg[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()    
 
        AFTER INSERT
         IF INT_FLAG THEN               
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE i105_bcl
         END IF
          INSERT INTO qdg_file (qdg01,qdg02,qdg03,qdg04,qdg05,qdg06) 
              VALUES(g_qdg[l_ac].qdg01,g_qdg[l_ac].qdg02,g_qdg[l_ac].qdg03,
                     g_qdg[l_ac].qdg04,g_qdg[l_ac].qdg05,g_qdg[l_ac].qdg06)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","qdg_file",g_qdg[l_ac].qdg01,g_qdg[l_ac].qdg02,SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2     
         END IF

        AFTER FIELD qdg01                        #check 是否重複
          IF NOT cl_null(g_qdg[l_ac].qdg01) THEN
             IF g_qdg[l_ac].qdg01 NOT MATCHES '[34]' THEN
                NEXT FIELD qdg01
             END IF
             IF g_qdg[l_ac].qdg01 != g_qdg_t.qdg01 OR
                g_qdg[l_ac].qdg02 != g_qdg_t.qdg02 OR
                g_qdg[l_ac].qdg03 != g_qdg_t.qdg03 OR
                g_qdg_t.qdg01 IS NULL OR
                g_qdg_t.qdg02 IS NULL OR
                g_qdg_t.qdg03 IS NULL THEN
                SELECT count(*) INTO l_n FROM qdg_file
                 WHERE qdg01 = g_qdg[l_ac].qdg01
                   AND qdg02 = g_qdg[l_ac].qdg02
                   AND qdg03 = g_qdg[l_ac].qdg03
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_qdg[l_ac].qdg01 = g_qdg_t.qdg01
                   LET g_qdg[l_ac].qdg02 = g_qdg_t.qdg02
                   LET g_qdg[l_ac].qdg03 = g_qdg_t.qdg03
                   NEXT FIELD qdg01
                END IF
             END IF
             #MOD-B30494 add begin---------------------------
             IF g_qdg[l_ac].qdg01 = '3' THEN
                CALL cl_set_comp_required('qdg05,qdg06',FALSE)
             ELSE
                CALL cl_set_comp_required('qdg05,qdg06',TRUE)
             END IF
             #MOD-B30494 add end-----------------------------
          END IF

        AFTER FIELD qdg02                        #check 是否重複
          IF NOT cl_null(g_qdg[l_ac].qdg02) THEN
             IF g_qdg[l_ac].qdg02 NOT MATCHES '[1234567RT]' THEN
                NEXT FIELD qdg02
             END IF
             IF g_qdg[l_ac].qdg01 != g_qdg_t.qdg01 OR
                g_qdg[l_ac].qdg02 != g_qdg_t.qdg02 OR
                g_qdg[l_ac].qdg03 != g_qdg_t.qdg03 OR
                g_qdg_t.qdg01 IS NULL OR
                g_qdg_t.qdg02 IS NULL OR
                g_qdg_t.qdg03 IS NULL THEN
                SELECT count(*) INTO l_n FROM qdg_file
                 WHERE qdg01 = g_qdg[l_ac].qdg01
                   AND qdg02 = g_qdg[l_ac].qdg02
                   AND qdg03 = g_qdg[l_ac].qdg03
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_qdg[l_ac].qdg01 = g_qdg_t.qdg01
                   LET g_qdg[l_ac].qdg02 = g_qdg_t.qdg02
                   LET g_qdg[l_ac].qdg03 = g_qdg_t.qdg03
                   NEXT FIELD qdg02
                END IF
             END IF
          END IF
                       
        AFTER FIELD qdg03                        #check 是否重複
          IF NOT cl_null(g_qdg[l_ac].qdg03) THEN
             IF g_qdg[l_ac].qdg01 != g_qdg_t.qdg01 OR
                g_qdg[l_ac].qdg02 != g_qdg_t.qdg02 OR
                g_qdg[l_ac].qdg03 != g_qdg_t.qdg03 OR
                g_qdg_t.qdg01 IS NULL OR
                g_qdg_t.qdg02 IS NULL OR
                g_qdg_t.qdg03 IS NULL THEN
                SELECT count(*) INTO l_n FROM qdg_file
                 WHERE qdg01 = g_qdg[l_ac].qdg01
                   AND qdg02 = g_qdg[l_ac].qdg02
                   AND qdg03 = g_qdg[l_ac].qdg03
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_qdg[l_ac].qdg01 = g_qdg_t.qdg01
                   LET g_qdg[l_ac].qdg02 = g_qdg_t.qdg02
                   LET g_qdg[l_ac].qdg03 = g_qdg_t.qdg03
                   NEXT FIELD qdg03
                END IF
             END IF
          END IF
 

        AFTER FIELD qdg04                                                                                                           
            IF g_qdg[l_ac].qdg04<0 THEN                                                                                             
               CALL cl_err('','afa1001',0)                                                                                          
               NEXT FIELD qdg04                                                                                                     
            END IF

        AFTER FIELD qdg05                                                                                                           
            IF g_qdg[l_ac].qdg05<0 THEN                                                                                             
               CALL cl_err('','afa1001',0)                                                                                          
               NEXT FIELD qdg05                                                                                                     
            END IF
     
        AFTER FIELD qdg06                                                                                                           
            IF g_qdg[l_ac].qdg06<0 THEN                                                                                             
               CALL cl_err('','afa1001',0)                                                                                          
               NEXT FIELD qdg06                                                                                                     
            END IF

 
        BEFORE DELETE                            #是否取消單身
            IF g_qdg_t.qdg01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
	           ROLLBACK WORK
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM qdg_file
                 WHERE qdg01 = g_qdg_t.qdg01
                   AND qdg02 = g_qdg_t.qdg02
                   AND qdg03 = g_qdg_t.qdg03
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","qdg_file",g_qdg_t.qdg01,g_qdg_t.qdg02,SQLCA.sqlcode,"","",1) 
	           ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2      
                MESSAGE "Delete OK"
                CLOSE i105_bcl
                COMMIT WORK
            END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_qdg[l_ac].* = g_qdg_t.*
            CLOSE i105_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_qdg[l_ac].qdg01,-263,1)
             LET g_qdg[l_ac].* = g_qdg_t.*
         ELSE
             UPDATE qdg_file SET
                   qdg01= g_qdg[l_ac].qdg01,
                   qdg02= g_qdg[l_ac].qdg02,
                   qdg03= g_qdg[l_ac].qdg03,
                   qdg04= g_qdg[l_ac].qdg04,
                   qdg05= g_qdg[l_ac].qdg05,
                   qdg06= g_qdg[l_ac].qdg06
             WHERE qdg01 = g_qdg_t.qdg01
               AND qdg02 = g_qdg_t.qdg02
               AND qdg03 = g_qdg_t.qdg03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","qdg_file",g_qdg_t.qdg01,g_qdg_t.qdg02,SQLCA.sqlcode,"","",1) 
                LET g_qdg[l_ac].* = g_qdg_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i105_bcl
                COMMIT WORK
             END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qdg[l_ac].* = g_qdg_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_qdg.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE i105_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i105_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(qdg01) AND l_ac > 1 THEN
                LET g_qdg[l_ac].* = g_qdg[l_ac-1].*
                NEXT FIELD qdg01
            END IF
 
        ON ACTION CONTROLP
 
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
 
    CLOSE i105_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i105_b_askkey()
    CLEAR FORM
    CALL g_qdg.clear()
    CONSTRUCT g_wc2 ON qdg01,qdg02,qdg03,qdg04,qdg05,qdg06
         FROM s_qdg[1].qdg01,s_qdg[1].qdg02,
              s_qdg[1].qdg03,s_qdg[1].qdg04,
              s_qdg[1].qdg05,s_qdg[1].qdg06
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION HELP         
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
    CALL i105_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i105_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql =
        "SELECT *  ",
        " FROM qdg_file  ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1,2,3"
 
    PREPARE i105_pb FROM g_sql
    DECLARE qdg_curs CURSOR FOR i105_pb
 
    CALL g_qdg.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH qdg_curs INTO g_qdg[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_qdg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2     
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i105_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qdg TO s_qdg.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                 
 
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
          CALL cl_show_fld_cont()                 
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()     
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
