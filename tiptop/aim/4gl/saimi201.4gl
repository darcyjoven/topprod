# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: s_i201tr.4gl
# Descriptions...: 倉管員限定資料維護作業
# Date & Author..: #No.FUN-930109 09/03/17 By xiaofeizhu 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40103 13/05/16 By fengrui 新增時關閉庫位欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_inc           DYNAMIC ARRAY OF RECORD  
          inc02        LIKE inc_file.inc02,
          inc03        LIKE inc_file.inc03,
          zx02         LIKE zx_file.zx02   
                       END RECORD,
       g_inc_t         RECORD                
          inc02        LIKE inc_file.inc02,
          inc03        LIKE inc_file.inc03,
          zx02         LIKE zx_file.zx02    
                       END RECORD,
       g_sql           STRING,         
       g_rec_b         LIKE type_file.num5,               
       l_ac            LIKE type_file.num5,
       g_imd           RECORD LIKE imd_file.*
DEFINE g_cnt           LIKE type_file.num10
DEFINE   g_curs_index  LIKE type_file.num10       
DEFINE   g_row_count   LIKE type_file.num10
DEFINE   g_imd01       LIKE imd_file.imd01,
         g_ime02       LIKE ime_file.ime02,
         g_ime17       LIKE ime_file.ime17 
DEFINE g_forupd_sql    STRING
DEFINE g_before_input_done  LIKE type_file.num5                               
 
FUNCTION saimi201(p_imd01,p_ime02,p_ime17)
DEFINE p_imd01         LIKE imd_file.imd01,
       p_ime02         LIKE ime_file.ime02,
       p_ime17         LIKE ime_file.ime17
       
    LET g_imd01 = p_imd01
    LET g_ime02 = p_ime02
    LET g_ime17 = p_ime17   
              
    IF g_ime17 = 'N' OR cl_null(g_ime17) THEN
       CALL cl_err(g_ime02,'aim-008',1)
       RETURN               
    END IF
    
    WHENEVER ERROR CALL cl_err_msg_log
 
    OPEN WINDOW i2011_w AT 19,18 WITH FORM "aim/42f/aimi2011"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_locale("aimi2011")
    
    SELECT * INTO g_imd.* FROM imd_file WHERE imd01 = g_imd01
    
    CALL i201tr_b_fill()
    CALL i201tr_menu()
    CLOSE WINDOW i2011_w    
END FUNCTION
 
FUNCTION i201tr_menu()
   WHILE TRUE
     CALL i201tr_bp("G")
     CASE g_action_choice
        WHEN "help"                                                                                                                
            CALL cl_show_help()                                                                                                     
        WHEN "detail"                                                                                                              
            IF cl_chk_act_auth() THEN                                                                                               
               CALL i201tr_b()                                                                                                        
            ELSE                                                                                                                    
               LET g_action_choice = NULL                                                                                           
            END IF
        WHEN "exit"                                                                                                                
            EXIT WHILE                                                                                                              
        WHEN "controlg"                                                                                                            
            CALL cl_cmdask()
     END CASE
   END WHILE
END FUNCTION
 
FUNCTION i201tr_b_fill()
 
    LET g_sql = "SELECT inc02,inc03",   
                "  FROM inc_file ",
                " WHERE inc01 = '",g_imd01,"'",
                "   AND inc02 = '",g_ime02,"'"
    PREPARE i2011_pb FROM g_sql
    DECLARE inc_curs CURSOR FOR i2011_pb
 
    CALL g_inc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH inc_curs INTO g_inc[g_cnt].inc02,g_inc[g_cnt].inc03   
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT zx02 INTO g_inc[g_cnt].zx02 FROM zx_file
         WHERE zx01 = g_inc[g_cnt].inc03
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_inc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn3  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i201tr_b()                  
DEFINE l_lock_sw       LIKE type_file.chr1,                 
       p_cmd           LIKE type_file.chr1,                 
       l_allow_insert  LIKE type_file.chr1,           
       l_allow_delete  LIKE type_file.chr1
DEFINE l_zx02          LIKE zx_file.zx02    
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT inc02,inc03",   
                      "  FROM inc_file WHERE inc01 = ? AND inc02 = ? AND inc03 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i2011_bcl CURSOR FROM g_forupd_sql      
 
   INPUT ARRAY g_inc WITHOUT DEFAULTS FROM s_inc.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            
 
          IF g_rec_b>=l_ac THEN 
             BEGIN WORK
             LET p_cmd='u'
             
             LET g_before_input_done = FALSE                                    
             CALL cl_set_comp_entry("inc02,zx02",FALSE)                                      
             LET g_before_input_done = TRUE                                                   
            
             LET g_inc_t.* = g_inc[l_ac].* 
             OPEN i2011_bcl USING g_imd01,g_inc_t.inc02,g_inc_t.inc03
             IF STATUS THEN
                CALL cl_err("OPEN i2011_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i2011_bcl INTO g_inc[l_ac].inc02,g_inc[l_ac].inc03
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_inc_t.inc02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET p_cmd='a'          
          INITIALIZE g_inc[l_ac].* TO NULL
          LET g_inc[l_ac].inc02 = g_ime02                
	  CALL cl_set_comp_entry("inc02,zx02",FALSE)   #FUN-D40103 add 
          CALL cl_show_fld_cont()     
          NEXT FIELD inc03
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i2011_bcl
             CANCEL INSERT
          END IF
          INSERT INTO inc_file(inc01,inc02,inc03)   
          VALUES(g_imd01,g_inc[l_ac].inc02,g_inc[l_ac].inc03)  
          IF SQLCA.sqlcode THEN  
             CALL cl_err3("ins","inc_file",g_imd01,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn3  
             COMMIT WORK
          END IF
       
        AFTER FIELD inc03
          LET l_zx02 = NULL
          SELECT zx02 INTO l_zx02 FROM zx_file
           WHERE zx01 = g_inc[l_ac].inc03 
             LET g_inc[l_ac].zx02 = l_zx02
          DISPLAY g_inc[l_ac].zx02 TO zx02   
       		
       BEFORE DELETE                            
          IF g_inc_t.inc02 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM inc_file 
              WHERE inc01 = g_imd01 
                AND inc02 = g_inc_t.inc02
                AND inc03 = g_inc_t.inc03 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","inc_file",g_imd01,"",SQLCA.sqlcode,"","",1)  
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn3  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_inc[l_ac].* = g_inc_t.*
             CLOSE i2011_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_inc[l_ac].inc02,-263,0)
             LET g_inc[l_ac].* = g_inc_t.*
          ELSE
             UPDATE inc_file SET inc03=g_inc[l_ac].inc03
              WHERE inc01 = g_imd01 
                AND inc02 = g_inc_t.inc02
                AND inc03 = g_inc_t.inc03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","inc_file",g_inc_t.inc02,"",SQLCA.sqlcode,"","",1)  
                LET g_inc[l_ac].* = g_inc_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()             
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_inc[l_ac].* = g_inc_t.*
             #FUN-D40030--add--str--
             ELSE
                CALL g_inc.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                END IF
             #FUN-D40030--add--end--
             END IF
             CLOSE i2011_bcl           
             ROLLBACK WORK         
             EXIT INPUT
          END IF
          CLOSE i2011_bcl           
          COMMIT WORK
          
        ON ACTION controlp
           CASE
              WHEN INFIELD(inc03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_zx"
                 CALL cl_create_qry() RETURNING g_inc[l_ac].inc03
                 DISPLAY g_inc[l_ac].inc03 TO inc03
                 LET l_zx02 = NULL
                 SELECT zx02 INTO l_zx02 FROM zx_file
                  WHERE zx01 = g_inc[l_ac].inc03 
                 LET g_inc[l_ac].zx02 = l_zx02
                 DISPLAY g_inc[l_ac].zx02 TO zx02
                 NEXT FIELD inc03
              OTHERWISE
                 EXIT CASE
           END CASE          
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  
        
   END INPUT
 
   CLOSE i2011_bcl
   COMMIT WORK
                   
END FUNCTION
 
FUNCTION i201tr_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_inc TO s_inc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
        BEFORE DISPLAY
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
           CALL cl_show_fld_cont()
 
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
 
        ON ACTION controlg     
           CALL cl_cmdask()    
 
        AFTER DISPLAY
           CONTINUE DISPLAY
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
#NO.FUN-930109
