# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: axci120.4gl
# Descriptions...: 
# Date & Author..: 12/09/03 By fengrui #No.FUN-C80092
# Modify.........: No.FUN-D10107 13/01/22 By fengrui 添加資料根據語言別轉換簡繁體功能
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE
   g_cki01        LIKE cki_file.cki01, 
   g_cki DYNAMIC ARRAY OF RECORD          
         cki01    LIKE cki_file.cki01,
         cki02    LIKE cki_file.cki02,  
         cki03    LIKE cki_file.cki03,
         cki04    LIKE cki_file.cki04       
             END RECORD,
   g_cki_t   RECORD                  
         cki01    LIKE cki_file.cki01,
         cki02    LIKE cki_file.cki02,  
         cki03    LIKE cki_file.cki03,
         cki04    LIKE cki_file.cki04
             END RECORD,
   g_cki_attr DYNAMIC ARRAY OF RECORD
         cki01   STRING ,
         cki02   STRING ,
         cki03   STRING ,    
         cki04   STRING 
         END RECORD, 
   g_wc          STRING,  
   g_rec_b       LIKE type_file.num5,        
   l_ac          LIKE type_file.num5        
DEFINE   g_forupd_sql    STRING                       
DEFINE   g_cnt           LIKE type_file.num10                        
DEFINE   g_replace_0     STRING  #FUN-D10107 add
DEFINE   g_replace_1     STRING  #FUN-D10107 add
 
MAIN
   OPTIONS                               
      INPUT NO WRAP
   DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_replace_0 = cl_getmsg('axc-920',0)  #FUN-D10107 add
   LET g_replace_1 = cl_getmsg('axc-920',2)  #FUN-D10107 add
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   OPEN WINDOW i120_w WITH FORM "axc/42f/axci120"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL i120_show()  
   CALL i120_menu()
   CLOSE WINDOW i120_w                

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i120_curs()
   CLEAR FORM                            
   CALL g_cki.clear()       
   INITIALIZE g_cki01 TO NULL 
           
   CONSTRUCT BY NAME g_wc ON cki01,cki02,cki03,cki04

     BEFORE CONSTRUCT
       CALL cl_qbe_init()

     ON ACTION controlp                                                      
 
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
  IF INT_FLAG THEN RETURN END IF
END FUNCTION

FUNCTION i120_menu()
   WHILE TRUE
      CALL i120_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i120_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i120_b()
            ELSE 
               LET g_action_choice = ''
            END IF
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF l_ac>=0 THEN 
                  IF g_cki[l_ac].cki01 IS NOT NULL THEN
                     LET g_doc.column1 = "cki01"
                     LET g_doc.value1 = g_cki[l_ac].cki02
                     CALL cl_doc()
                  END IF
               END IF 
           END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cki),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i120_q()
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL i120_curs()                      
   IF INT_FLAG THEN                       
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL i120_show()               
END FUNCTION
 
FUNCTION i120_show()          
   CALL i120_b_fill()                
END FUNCTION

FUNCTION i120_b()
DEFINE              
   l_n             LIKE type_file.num5,               
   l_cnt           LIKE type_file.num5,                
   l_lock_sw       LIKE type_file.chr1,               
   p_cmd           LIKE type_file.chr1,                
   l_allow_insert  LIKE type_file.num5,                
   l_allow_delete  LIKE type_file.num5,
   l_cki02         LIKE cki_file.cki02,  #FUN-D10107
   l_cki04         LIKE cki_file.cki04,  #FUN-D10107
   l_ac_t          LIKE type_file.num5   #FUN-D40030 add

   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   CALL cl_opmsg('b') 
   LET g_forupd_sql = "SELECT cki01,cki02,cki03,cki04 ",
                      "  FROM cki_file ",
                      "  WHERE cki01 = ? ",
                      "   FOR UPDATE " 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i120_bcl CURSOR FROM g_forupd_sql      
  #LET l_allow_insert = TRUE    #FUN-C80092 新增時,請給TRUE.使用後請還原為FALSE
  #LET l_allow_delete = TRUE    #FUN-C80092 刪除時,請給TRUE.使用後請還原為FALSE
   LET l_allow_insert = FALSE   #FUN-C80092 新增時,請給TRUE.使用後請還原為FALSE
   LET l_allow_delete = FALSE   #FUN-C80092 刪除時,請給TRUE.使用後請還原為FALSE
 
   INPUT ARRAY g_cki WITHOUT DEFAULTS FROM s_cki.*
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
         BEGIN WORK
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_cki_t.* = g_cki[l_ac].* 
            OPEN i120_bcl USING g_cki_t.cki01
            IF STATUS THEN
               CALL cl_err("OPEN i209_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i120_bcl INTO g_cki[l_ac].*
               #FUN-D10107--add--str--
               IF g_lang ='0' THEN
                  LET g_cki[l_ac].cki02 =  cl_trans_utf8_twzh(g_lang,g_cki[l_ac].cki02)
                  LET g_cki[l_ac].cki04 =  cl_trans_utf8_twzh(g_lang,g_cki[l_ac].cki04)
                  LET g_cki[l_ac].cki02 =  cl_replace_str(g_cki[l_ac].cki02,g_replace_1,g_replace_0)
                  LET g_cki[l_ac].cki04 =  cl_replace_str(g_cki[l_ac].cki04,g_replace_1,g_replace_0)
               END IF
               #FUN-D10107--add--end--
            END IF  
         END IF 
         CALL i120_set_entry(p_cmd)
         CALL i120_set_no_entry(p_cmd)
             
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_cki[l_ac].* TO NULL
         CALL cl_show_fld_cont()
         NEXT FIELD cki01

      #FUN-D10107--add--str--
      AFTER FIELD cki02
         LET l_cki02 = g_cki[l_ac].cki02
         IF NOT cl_null(g_cki[l_ac].cki02) THEN
            IF NOT cl_unicode_check02("0",g_cki[l_ac].cki02,"0") AND
               NOT cl_unicode_check02("2",g_cki[l_ac].cki02,"0") THEN
               IF g_lang='0' THEN
                  IF NOT cl_unicode_check02("0",g_cki[l_ac].cki02,"0") THEN END IF
               END IF
               NEXT FIELD cki02
            ELSE
               IF cl_unicode_check02("0",g_cki[l_ac].cki02,"0") THEN
                  LET l_cki02 =  cl_trans_utf8_twzh('2',g_cki[l_ac].cki02)
               END IF
               ERROR ''
            END IF
            IF g_lang='0' THEN
               LET g_cki[l_ac].cki02 =  cl_replace_str(g_cki[l_ac].cki02,g_replace_1,g_replace_0)
               DISPLAY BY NAME g_cki[l_ac].cki02
            END IF
         END IF

      AFTER FIELD cki04
         LET l_cki04 = g_cki[l_ac].cki04
         IF NOT cl_null(g_cki[l_ac].cki04) THEN
            IF NOT cl_unicode_check02("0",g_cki[l_ac].cki04,"0") AND
               NOT cl_unicode_check02("2",g_cki[l_ac].cki04,"0") THEN
               IF g_lang='0' THEN
                  IF NOT cl_unicode_check02("0",g_cki[l_ac].cki04,"0") THEN END IF
               END IF
               NEXT FIELD cki04
            ELSE
               IF cl_unicode_check02("0",g_cki[l_ac].cki04,"0") THEN
                  LET l_cki04 =  cl_trans_utf8_twzh('2',g_cki[l_ac].cki04)
               END IF
               ERROR ''
            END IF
            IF g_lang='0' THEN
               LET g_cki[l_ac].cki04 =  cl_replace_str(g_cki[l_ac].cki04,g_replace_1,g_replace_0)
               DISPLAY BY NAME g_cki[l_ac].cki04
            END IF
         END IF
      #FUN-D10107--add--end--

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO cki_file
         #FUN-D10107--modify--str--
         #VALUES(g_cki[l_ac].cki01,g_cki[l_ac].cki02,
         #       g_cki[l_ac].cki03,g_cki[l_ac].cki04) 
         VALUES(g_cki[l_ac].cki01,l_cki02,
                g_cki[l_ac].cki03,l_cki04) 
         #FUN-D10107--modify--end--
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tc_aah_file",g_cki[l_ac].cki01,"",SQLCA.sqlcode,"","",1)     
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
        
      BEFORE DELETE                  
         IF g_cki_t.cki01 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM tc_aah_file
             WHERE tc_aah01 = g_tc_aah_t.tc_aah01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tc_aah_file",g_cki_t.cki01,"",SQLCA.sqlcode,"","",1) 
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_cki[l_ac].* = g_cki_t.*
            CLOSE i120_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_cki[l_ac].cki01,-263,1)
            LET g_cki[l_ac].* = g_cki_t.*
         ELSE
            UPDATE cki_file SET   cki01=g_cki[l_ac].cki01,
                                  #cki02=g_cki[l_ac].cki02,  #FUN-D10107
                                  cki02=l_cki02,             #FUN-D10107
                                  cki03=g_cki[l_ac].cki03,
                                  #cki04=g_cki[l_ac].cki04   #FUN-D10107
                                  cki04=l_cki04              #FUN-D10107
             WHERE cki01=g_cki_t.cki01
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","cki_file",g_cki[l_ac].cki01,"",SQLCA.sqlcode,"","",1)
               LET g_cki[l_ac].* = g_cki_t.*
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
            IF p_cmd = 'u' THEN
               LET g_cki[l_ac].* = g_cki_t.*
            #FUN-D40030---add---str---
            ELSE
               CALL g_cki.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030---add---end---
            END IF
            CLOSE i120_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D40030 add
         CLOSE i120_bcl
         COMMIT WORK
      
      ON ACTION CONTROLZ
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
   CLOSE i120_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i120_b_fill()               
   DEFINE   l_sql       STRING    

   CALL g_cki_attr.clear()
   IF cl_null(g_wc) THEN 
      LET g_wc = " 1=1"
   END IF 
   LET l_sql = " SELECT cki01,cki02,cki03,cki04 ",   
               "   FROM cki_file ",        
               "  WHERE ",g_wc,
               "  ORDER BY cki01 "   
   PREPARE i120_pre1 FROM l_sql
   DECLARE i120_cs1 CURSOR FOR i120_pre1
   CALL g_cki.clear()
   LET g_cnt = 1

   FOREACH i120_cs1 INTO g_cki[g_cnt].*  
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      IF g_cnt=1 OR g_cnt=16 OR g_cnt=33 THEN 
         LET g_cki_attr[g_cnt].cki01 = "blue reverse"
         LET g_cki_attr[g_cnt].cki02 = "blue reverse"
         LET g_cki_attr[g_cnt].cki03 = "blue reverse"
         LET g_cki_attr[g_cnt].cki04 = "blue reverse"
      END IF 
      #FUN-D10107--add--str--
      IF g_lang ='0' THEN
         LET g_cki[g_cnt].cki02 =  cl_trans_utf8_twzh(g_lang,g_cki[g_cnt].cki02)
         LET g_cki[g_cnt].cki04 =  cl_trans_utf8_twzh(g_lang,g_cki[g_cnt].cki04)
         LET g_cki[g_cnt].cki02 =  cl_replace_str(g_cki[g_cnt].cki02,g_replace_1,g_replace_0)
         LET g_cki[g_cnt].cki04 =  cl_replace_str(g_cki[g_cnt].cki04,g_replace_1,g_replace_0)
      END IF
      #FUN-D10107--add--enendd--
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF       
   END FOREACH
     
   CALL g_cki.deleteElement(g_cnt)
   LET g_cnt = g_cnt -1
   LET g_rec_b = g_cnt
   DISPLAY g_rec_b TO FORMONLY.cn2  
 
END FUNCTION
 
FUNCTION i120_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED=TRUE)
      DISPLAY ARRAY g_cki TO s_cki.* 
         BEFORE DISPLAY
            CALL DIALOG.setArrayAttributes("s_cki",g_cki_attr)   
         BEFORE ROW
            LET l_ac = ARR_CURR()
      END DISPLAY 
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
         
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION related_document              
         LET g_action_choice="related_document"
         EXIT DIALOG
      
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL i120_show()  #FUN-D10107
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
    
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON ACTION controls                                       
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i120_set_entry(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1 
   CALL cl_set_comp_entry("cki01,cki02,cki03,cki04",TRUE )
END FUNCTION 

FUNCTION i120_set_no_entry(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd = 'u' OR p_cmd = 'U' THEN 
      CALL cl_set_comp_entry("cki01,cki03",FALSE )  #FUN-C80092 維護人員修改時,請mark此行.修改后請還原.
   END IF 
END FUNCTION 
 
