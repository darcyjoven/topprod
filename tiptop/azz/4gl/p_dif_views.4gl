# Prog. Version..: '5.30.06-13.03.12(00004)'     #
# Prog. Version..: '5.30.06-13.03.12(00000)'     #
# Pattern name...: p_diff_views.4gl
# Descriptions...: 系統設定與虛擬資料庫 views 的差異比對
# Date & Author..: 09/11/12 By echo FUN-9B0011
# Modify.........: 
# Modify.........: No.FUN-9C0036 09/12/07 By Echo  資料庫 source 名稱調整
# Modify.........: No.FUN-A60017 10/06/03 By Kevin  加入GP5.2 SQL SERVER 語法
# Modify.........: No.FUN-A60022 10/07/15 By Echo GP5.2 SQL Server 移植-p_zta 工具調整(含集團架構)
# Modify.........: No.FUN-AA0052 10/10/14 By Jay 增加 Sybase ASE 的判斷
# Modify.........: No.FUN-A10082 11/04/08 By Jenjwu 增加虛擬schema是否建立的判斷


DATABASE ds

#FUN-9B0011 
GLOBALS "../../config/top.global"

GLOBALS
DEFINE  g_MODNO              LIKE zs_file.zs08,     #zs08(MODNO)
        g_tiptop_ver         LIKE zs_file.zs12,     #No.FUN-680135 VARCHAR(7)
        g_date               LIKE type_file.dat     #No.FUN-680135 DATE
END GLOBALS

DEFINE  g_view_db     LIKE azw_file.azw06
DEFINE  g_view_from   LIKE azw_file.azw05
DEFINE  g_dif         DYNAMIC ARRAY of RECORD        # 程式變數
            adjust           LIKE type_file.chr1,
            dif_view         LIKE gat_file.gat01,
            dif_exp          LIKE type_file.chr1
                      END RECORD,
         g_rec_b               LIKE type_file.num5   # 單身筆數   #No.FUN-680135 SMALLINT
DEFINE  g_file        STRING
DEFINE  g_db_type     STRING
 
FUNCTION p_dif_views()
DEFINE  l_plant    LIKE azw_file.azw01
DEFINE  l_dbs      LIKE azw_file.azw05

   WHENEVER ERROR CALL cl_err_msg_log

   OPEN WINDOW p_dif_views_w WITH FORM "azz/42f/p_dif_views"
     ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_locale("p_dif_views")
 
   CALL p_dif_views_maintain()

   CALL p_dif_views_menu() 
 
   CLOSE WINDOW p_dif_views_w                       # 結束畫面

END FUNCTION

 
FUNCTION p_dif_views_menu()
DEFINE w ui.Window                
DEFINE n om.DomNode               
 
   WHILE TRUE
      CALL p_dif_views_bp("G")
 
      CASE g_action_choice
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
         WHEN "dif_maintain"
            IF cl_chk_act_auth() THEN
               CALL p_dif_views_maintain()      
            END IF   
         WHEN "adjust"
            IF cl_chk_act_auth() THEN
               CALL p_dif_views_adjust()      
            END IF   

         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              LET w = ui.Window.getCurrent()
              LET n = w.getNode()
              CALL cl_export_to_excel(n,base.TypeInfo.create(g_dif),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION

FUNCTION p_dif_views_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_dif TO s_dif.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      ON ACTION dif_maintain                     #輸入比對虛擬資料庫 
         LET g_action_choice = "dif_maintain"
         EXIT DISPLAY         
 
      ON ACTION adjust                           #調整 
         LET g_action_choice = "adjust"
         EXIT DISPLAY         
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                       #No.FUN-6A0092                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6A0092 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION p_dif_views_maintain()              # 處理INPUT
DEFINE l_cnt   LIKE type_file.num10

 
   INPUT g_view_db WITHOUT DEFAULTS FROM view_db
 
      AFTER FIELD view_db
         IF NOT cl_null(g_view_db) THEN      #檢查是否存在 
            SELECT COUNT(*) INTO l_cnt FROM azw_file
             WHERE azw06 = g_view_db AND azw05 <> azw06
             
            #FUN-A10082 -start-
            IF l_cnt = 0 THEN
               CALL cl_err(g_view_db,'azz-314',0)
               NEXT FIELD view_db               
            END IF                           
            
            IF NOT cl_chk_schema_has_built(g_view_db) THEN   #檢查是否已經建立
               CALL cl_err_msg('','azz1025',g_view_db, 10) 
               NEXT FIELD view_db
            END IF 
            
            SELECT unique azw05 INTO g_view_from FROM azw_file
            WHERE  azw06 = g_view_db
            DISPLAY g_view_from TO FORMONLY.view_from
            #FUN-A10082 -end-   
            
         END IF  
 
      AFTER INPUT
         IF INT_FLAG THEN
            CLEAR FORM
            CALL g_dif.clear()
            EXIT INPUT
         END IF
         CALL p_dif_views_array('Y')

      ON ACTION controlp
         CASE
            WHEN INFIELD(view_db)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azw03"
               LET g_qryparam.arg1 =  g_view_db
               CALL cl_create_qry() RETURNING g_view_db

               SELECT unique azw05 INTO g_view_from FROM azw_file
                WHERE  azw06 = g_view_db
               DISPLAY g_view_db TO FORMONLY.view_db
               DISPLAY g_view_from TO FORMONLY.view_from
               NEXT FIELD view_db

            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
    
END FUNCTION
 
FUNCTION p_dif_views_array(p_flag)   #抓取 view 的差異清單
DEFINE p_flag      LIKE type_file.chr1      #顯示ProgressBar 
DEFINE l_gat01     DYNAMIC ARRAY of LIKE gat_file.gat01   
DEFINE l_cnt       LIKE type_file.num10
DEFINE l_cnt1      LIKE type_file.num10
DEFINE l_cnt2      LIKE type_file.num10
DEFINE l_cnt3      LIKE type_file.num10
DEFINE l_cnt4      LIKE type_file.num10
DEFINE l_cnt5      LIKE type_file.num10
DEFINE l_view_cnt  LIKE type_file.num10
DEFINE l_i         LIKE type_file.num10
DEFINE l_j         LIKE type_file.num10
DEFINE l_sql       STRING
DEFINE l_str       STRING
DEFINE l_feld      STRING
DEFINE l_text      CHAR(4000)
DEFINE l_dif_exp   LIKE type_file.chr1
DEFINE l_tok       base.StringTokenizer
DEFINE l_RecV      DYNAMIC ARRAY of LIKE gaq_file.gaq01   

   CONNECT TO g_view_db AS "viewdb"
   CONNECT TO g_view_from AS "viewfrom"

   CALL g_dif.clear()
   LET g_rec_b = 0

   #取得View清單
   LET l_cnt = 1
   LET l_sql = cl_get_view_sql(g_view_from)    #回傳取得View清單的SQL #FUN-9C0036
   DECLARE views_cs CURSOR FROM l_sql
   FOREACH views_cs INTO l_gat01[l_cnt]
       LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_gat01.deleteElement(l_cnt)
   LET l_cnt = l_cnt -1

   IF p_flag = 'Y' THEN
      CALL cl_progress_bar(l_cnt)
   END IF
   #判斷 zta_file 的設定是否與目前 schema 的設定有所不同
   FOR l_i = 1 TO l_cnt
       LET l_dif_exp = ""
       
       IF p_flag = 'Y' THEN
           CALL cl_progressing("view : " || l_gat01[l_i] CLIPPED)
       END IF

       SET CONNECTION "viewfrom"
       #判斷 table 是否已建立
       CASE cl_db_get_database_type()
         WHEN 'ORA'
            SELECT COUNT(*) INTO l_cnt1 FROM user_tables WHERE lower(table_name) = l_gat01[l_i]
         WHEN 'MSV'
       	    SELECT COUNT(*) INTO l_cnt1 FROM sys.tables WHERE NAME = l_gat01[l_i] #FUN-A60017
       END CASE
       IF l_cnt1 > 0 THEN
         
          SET CONNECTION "viewdb"

          #判斷 zta_file 的設定是否吻合實際設定
          CASE cl_db_get_database_type()
            WHEN 'ORA'
               SELECT COUNT(*) INTO l_cnt2 FROM user_views WHERE lower(view_name) = l_gat01[l_i]
            WHEN 'MSV'
               SELECT COUNT(*) INTO l_cnt2 FROM sys.views WHERE NAME = l_gat01[l_i] #FUN-A60017
          END CASE
          IF l_cnt2 > 0 THEN

             #判斷View的欄位是否和實體Table相同:不同時,也要重新建立View.
             #1.取得View的欄位清單(text內的欄位都是大寫) 
             CASE cl_db_get_database_type()
               WHEN 'ORA' #FUN-A60017
                    #SELECT text INTO l_text FROM user_views WHERE lower(view_name) = l_gat01[l_i]
                    LET l_sql = "SELECT column_name FROM user_tab_columns WHERE lower(table_name) = ? "
               WHEN 'MSV'
               	    LET l_sql = "SELECT name FROM sys.columns  WHERE object_id=OBJECT_id(?)"
             END CASE
  
             #2. 取得 view 的欄位             
             
             #LET l_str = l_text CLIPPED
             #LET l_str = l_str.toLowerCase()
             #LET l_str = l_str.subString(l_str.getIndexOf("select",1)+6, l_str.getIndexOf("from",1)-1)
             #LET l_str = cl_replace_str(l_str.trim(),'"','')
             #LET l_tok = base.StringTokenizer.createExt(l_str,",","",TRUE)
             #LET l_view_cnt = 0
             #WHILE l_tok.hasMoreTokens()
             #     LET l_feld = l_tok.nextToken()
             #     LET l_view_cnt = l_view_cnt + 1
             #     LET l_RecV[l_view_cnt] = l_feld
             #END WHILE
             DECLARE view_cols_cs CURSOR FROM l_sql
             
             LET l_view_cnt = 1
             FOREACH view_cols_cs USING l_gat01[l_i] INTO l_RecV[l_view_cnt]
             	  IF SQLCA.SQLCODE THEN
                   CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)    
                   EXIT FOREACH
                END IF

                LET l_view_cnt = l_view_cnt + 1
             END FOREACH
             CALL l_RecV.deleteElement(l_view_cnt)
             LET l_view_cnt = l_view_cnt - 1
                   
             #3.判斷欄位個數是否相同,不同就建立
             SET CONNECTION "viewfrom"

             #取得實體Table的欄位個數.
             CASE cl_db_get_database_type()
               WHEN 'ORA'
                  SELECT COUNT(*) INTO l_cnt4 FROM user_tab_columns WHERE lower(table_name) = l_gat01[l_i]                  
               WHEN 'MSV'
               	  SELECT COUNT(*) INTO l_cnt4 FROM sys.objects a ,sys.columns b #FUN-A60017
               	   WHERE a.name     = l_gat01[l_i]
               	     AND a.object_id= b.object_id
             END CASE

             IF l_cnt4 <> l_view_cnt THEN
                LET l_dif_exp='3'   #3.zta_file已經Alter table,但是View卻沒有同步調整
             ELSE
                DROP TABLE tmp_column 
                #個數相同再比較欄位名稱是否相同.
                #4.取得實體Table的欄位清單(都是大寫)
                CASE cl_db_get_database_type()
                  WHEN 'ORA'
                     SELECT column_name FROM user_tab_columns WHERE lower(table_name) = l_gat01[l_i] 
                     INTO TEMP tmp_column
                     IF SQLCA.SQLCODE THEN 
                        CALL cl_err3("sel","user_tab_columns",l_gat01[l_i] CLIPPED,'',SQLCA.SQLCODE,"","",0)
                        CALL g_dif.clear()
                        LET g_rec_b = 0
                        RETURN 
                     END  IF
                  WHEN 'MSV'
                     SELECT name FROM sys.columns WHERE object_id= object_id(l_gat01[l_i])
                     INTO TEMP tmp_column
                     IF SQLCA.SQLCODE THEN 
                        CALL cl_err3("sel","user_tab_columns",l_gat01[l_i] CLIPPED,'',SQLCA.SQLCODE,"","",0)
                        CALL g_dif.clear()
                        LET g_rec_b = 0
                        RETURN 
                     END  IF                  	
                END CASE
                
                FOR l_j = 1 TO l_view_cnt
                   CASE cl_db_get_database_type()
                     WHEN 'ORA'                	  
                       SELECT COUNT(*) INTO l_cnt5 FROM tmp_column WHERE column_name = l_RecV[l_j]
                     WHEN 'MSV'
                       SELECT COUNT(*) INTO l_cnt5 FROM tmp_column WHERE name = l_RecV[l_j]
                   END CASE 
                   
                   IF l_cnt5 = 0 THEN
                       LET l_dif_exp='3'   #3.zta_file已經Alter table,但是View卻沒有同步調整
                       EXIT FOR
                   END IF 
                END FOR 
             END IF
             
          ELSE
              #有實體Table卻找不到建立的View資訊,有兩種情況:1.真的少建立了 2.設定為Synonym
              LET l_cnt3 = p_zta_dff_synonym_check(l_gat01[l_i], g_view_db)
              IF l_cnt3 > 0 THEN
                 LET l_dif_exp='1'  #1.zta_file設定為View,但是實際上卻是Synonym
              ELSE
                 LET l_dif_exp='3'  #3.zta_file已經Alter table,但是View卻沒有同步調整
              END IF
          END IF  
       ELSE
display "11:",time
          #有實體Table卻找不到建立的View資訊,有兩種情況:0.實際table不存在 4.設定為Synonym
          LET l_cnt2 = p_zta_dff_synonym_check(l_gat01[l_i], g_view_from)
          IF l_cnt2 > 0 THEN
              LET l_dif_exp = '4'       #4.在實體 DB 裡,此 Table 為 synonym, 請自行至 p_zta 手動調整。
          ELSE   
              LET l_dif_exp = '0'       #0.實際Table不存在
          END IF
display "12:",time
       END IF
       IF NOT cl_null(l_dif_exp) THEN
          LET g_rec_b = g_rec_b + 1
          LET g_dif[g_rec_b].adjust='N'
          LET g_dif[g_rec_b].dif_view = l_gat01[l_i]
          LET g_dif[g_rec_b].dif_exp = l_dif_exp
       END IF 
   END FOR

   DISCONNECT "viewdb"
   DISCONNECT "viewfrom"

  #DATABASE  g_dbs
  #CALL cl_ins_del_sid(1,g_plant)
  #CALL cl_ins_del_sid(2,'') 
  #CLOSE DATABASE
   DATABASE g_dbs
   CALL cl_ins_del_sid(1,g_plant) 

END FUNCTION
 

FUNCTION p_dif_views_adjust()      
DEFINE l_i               LIKE type_file.num10
DEFINE l_cnt             LIKE type_file.num10
DEFINE l_sql             STRING
DEFINE l_str             STRING
DEFINE l_cmd             STRING
DEFINE l_plant_fld       STRING
DEFINE l_status          LIKE type_file.chr1

   IF g_rec_b = 0 THEN   RETURN  END IF

   #g_MODNO會寫入p_zs裡的蟲號,先檢查g_MODNO是不是Null,若是則跳出小視窗要求輸入
   IF cl_null(g_MODNO)  THEN
      PROMPT "input MODNO:" FOR g_MODNO
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
      END PROMPT
      display g_MODNO
   END IF

   CONNECT TO g_view_db AS "viewdb"
   CONNECT TO g_view_from AS "viewfrom"
   
   LET g_db_type = cl_db_get_database_type()
    
   LET g_file = ">> ",FGL_GETENV("TEMPDIR"),"/p_dif_views_",g_view_db,"_",FGL_GETPID() USING '<<<<<<<<<<',".log"
   LET g_file = ">> ",FGL_GETENV("TEMPDIR"),"/p_dif_views_",g_view_db,"_",FGL_GETPID() USING '<<<<<<<<<<',".log"
   LET l_cmd = "echo 'Error   db_name     command'",g_file
   RUN l_cmd
   LET l_cmd = "echo '        error_no    err_message'",g_file 
   RUN l_cmd
   LET l_cmd = "echo '------- ----------- ---------------------------------------------------------------------------------'",g_file
   RUN l_cmd

   FOR l_i = 1 to g_rec_b

       IF g_dif[l_i].dif_exp MATCHES "[123]" THEN
          SET CONNECTION "viewfrom"
          IF g_db_type <> "MSV" THEN
             LET l_cmd = "grant select,insert,update,delete on ",g_dif[l_i].dif_view CLIPPED," to ",g_view_db
             IF NOT p_dif_views_excute_cmd(g_view_from,g_dif[l_i].dif_view CLIPPED,l_cmd,"grant") THEN
                CONTINUE FOR
             END IF
          END IF

          LET l_str = g_dif[l_i].dif_view
          LET l_plant_fld = l_str.subString(1,l_str.getIndexOf('_file',1)-1),"plant"

          #取得 dif_exp<>'0'和'4'的資料
          SET CONNECTION "viewdb"

          CASE g_dif[l_i].dif_exp 
             WHEN '1'    #1.zta_file設定為View,但是實際上卻是Synonym
                  LET l_cmd = "drop synonym ", g_dif[l_i].dif_view CLIPPED                              
                  IF NOT p_dif_views_excute_cmd(g_view_db,g_dif[l_i].dif_view CLIPPED,l_cmd,"drop synonym") THEN
                     CONTINUE FOR
                  END IF

                  CASE cl_db_get_database_type() #FUN-A60017
                    WHEN 'ORA'
                       LET l_cmd = "create view ",g_dif[l_i].dif_view CLIPPED, " as ",
                              " select * from ",s_dbstring(g_view_from),g_dif[l_i].dif_view CLIPPED,
                             #"  where ",l_plant_fld," IN (select azwa03 from azwa_file where azwa01=(select sid04 from sid_file where sid01=(SELECT AUDSID FROM V\$SESSION WHERE AUDSID=USERENV('SESSIONID'))) and azwa02=(select sid02 from sid_file where sid01=(SELECT AUDSID FROM V\$SESSION WHERE AUDSID=USERENV('SESSIONID'))))"
                              " where ",l_plant_fld," = (select sid02 from sid_file where sid01=(select userenv('SESSIONID') from dual))"  #FUN-9C0036
                    WHEN 'MSV'
                      LET l_cmd = "CREATE VIEW ",g_dif[l_i].dif_view, " as ",
                                  "SELECT * FROM ",s_dbstring(g_view_from),g_dif[l_i].dif_view,
                                  " WHERE ",l_plant_fld," = (SELECT sid02 FROM sid_file",
                                                    " WHERE sid01=(SELECT @@SPID))"
                  END CASE
                  IF NOT p_dif_views_excute_cmd(g_view_db,g_dif[l_i].dif_view CLIPPED,l_cmd,"create view") THEN 
                     CONTINUE FOR
                  END IF
                  LET l_status = TRUE
                  LET g_dif[l_i].adjust='Y'
                   
             WHEN '2'    #2.zta_file設定為Synonym,但是實際上卻是View
                  LET l_cmd = "drop view ", g_dif[l_i].dif_view CLIPPED                              
                  IF NOT p_dif_views_excute_cmd(g_view_db,g_dif[l_i].dif_view CLIPPED,l_cmd,"drop view") THEN
                     CONTINUE FOR
                  END IF

                  LET l_cmd = "create synonym ",g_dif[l_i].dif_view CLIPPED,
                              " for ",s_dbstring(g_view_from),g_dif[l_i].dif_view CLIPPED
                  IF NOT p_dif_views_excute_cmd(g_view_db,g_dif[l_i].dif_view CLIPPED,l_cmd,"create synonym") THEN
                     CONTINUE FOR
                  END IF
                  LET l_status = TRUE
                  LET g_dif[l_i].adjust='Y'

             WHEN '3'    #3.zta_file已經Alter table,但是View卻沒有同步調整
                  #判斷是否已建立view, 若已建立view，必須先dorp view
                  CASE cl_db_get_database_type()
                    WHEN 'ORA'
                       SELECT COUNT(*) INTO l_cnt FROM user_views 
                        WHERE lower(view_name) = g_dif[l_i].dif_view
                    WHEN 'MSV'
            	       SELECT COUNT(*) INTO l_cnt FROM sys.views #FUN-A60017
                        WHERE NAME = g_dif[l_i].dif_view
                  END CASE
                  IF l_cnt > 0 THEN
                     LET l_cmd = "drop view ", g_dif[l_i].dif_view CLIPPED                              
                         IF NOT p_dif_views_excute_cmd(g_view_db,g_dif[l_i].dif_view CLIPPED,l_cmd,"drop view") THEN
                            CONTINUE FOR
                         END IF
                  END IF
                  CASE cl_db_get_database_type()
                    WHEN 'ORA'
                      LET l_cmd = "CREATE VIEW ",g_dif[l_i].dif_view CLIPPED, " as ",
                              " SELECT * FROM ",s_dbstring(g_view_from),g_dif[l_i].dif_view CLIPPED,
                             #"  where ",l_plant_fld," IN (select azwa03 from azwa_file where azwa01=(select sid04 from sid_file where sid01=(SELECT AUDSID FROM V\$SESSION WHERE AUDSID=USERENV('SESSIONID'))) and azwa02=(select sid02 from sid_file where sid01=(SELECT AUDSID FROM V\$SESSION WHERE AUDSID=USERENV('SESSIONID'))))"
                              " WHERE ",l_plant_fld," = (SELECT sid02 FROM sid_file WHERE sid01=(SELECT userenv('SESSIONID') FROM dual))"  #FUN-9C0036
                    WHEN 'MSV'
                      LET l_cmd = "CREATE VIEW ",g_dif[l_i].dif_view, " as ",
                                  "SELECT * FROM ",s_dbstring(g_view_from),g_dif[l_i].dif_view,
                                  " WHERE ",l_plant_fld," = (SELECT sid02 FROM sid_file",
                                                    " WHERE sid01=(SELECT @@SPID))"
                  END CASE
                  IF NOT p_dif_views_excute_cmd(g_view_db,g_dif[l_i].dif_view CLIPPED,l_cmd,"create view") THEN
                     CONTINUE FOR
                  END IF
                  LET l_status = TRUE
                  LET g_dif[l_i].adjust='Y'

          END CASE
       END IF

   END FOR

   IF l_status = TRUE THEN
      #調整後，重新check資料並顯示
      #CALL p_dif_views_array('N')

      LET g_file = g_file.subString(4,g_file.getLength())
      LET l_cmd = "p_view ", g_file CLIPPED," 33"
      display l_cmd 
      CALL cl_cmdrun_wait(l_cmd)
   ELSE
      CALL cl_msg('mfg3442')

   END IF
   DISCONNECT "viewdb"
   DISCONNECT "viewfrom"

  #DATABASE  g_dbs
  #CALL cl_ins_del_sid(1,g_plant)
  #CALL cl_ins_del_sid(2,'') 
  #CLOSE DATABASE
   DATABASE g_dbs
   CALL cl_ins_del_sid(1,g_plant) 
END FUNCTION

FUNCTION p_dif_views_excute_cmd(p_dbs,p_tabname,p_cmd,p_str)
DEFINE p_dbs             STRING
DEFINE p_tabname         STRING
DEFINE p_cmd             STRING
DEFINE p_str             STRING
DEFINE l_cmd             STRING

   EXECUTE IMMEDIATE p_cmd
   IF SQLCA.SQLCODE THEN
      LET l_cmd = "echo 'V",COLUMN 15,p_tabname CLIPPED, COLUMN 27, p_cmd,"'",g_file
      RUN l_cmd
      LET l_cmd = "echo '",COLUMN 15,sqlca.sqlcode CLIPPED USING '----------', 
                           COLUMN 27, cl_getmsg(sqlca.sqlcode,g_lang),"'",g_file
      RUN l_cmd
      RETURN FALSE
   ELSE
      IF NOT p_insert_zs_file(p_dbs,p_tabname,p_cmd) THEN 
         LET l_cmd = "echo 'V",COLUMN 15,p_tabname CLIPPED, COLUMN 27, "insert zs_file error","'",g_file
         RUN l_cmd
         LET l_cmd = "echo ' '",g_file
         RUN l_cmd
         RETURN FALSE
      END IF
      LET l_cmd = "echo '",COLUMN 15,p_tabname CLIPPED, COLUMN 27, p_cmd,"'",g_file
      RUN l_cmd
      LET l_cmd = "echo ' '",g_file
      RUN l_cmd
   END IF
   RETURN TRUE

END FUNCTION

#建立zs_file資料
FUNCTION p_insert_zs_file(p_dbs,p_tabname,p_cmd)
DEFINE p_dbs          LIKE zta_file.zta02    #資料庫
DEFINE p_tabname      LIKE zta_file.zta01    #Table  
DEFINE p_cmd          STRING                 #alter指令
DEFINE l_zs03         LIKE zs_file.zs03
DEFINE l_cust         LIKE type_file.chr1
DEFINE l_sql          STRING
DEFINE l_err          STRING
DEFINE l_strbuf       base.StringBuffer 

   IF NOT cl_null(FGL_GETENV("TOPLINK")) THEN
      LET l_cust = 'p'
   ELSE
      LET l_cust = 'c'
   END IF

   SELECT max(zs03)+1 INTO l_zs03 FROM zs_file
    WHERE zs01 = p_tabname AND zs02 =  p_dbs
   IF l_zs03 IS NULL THEN
      LET l_zs03 = 1
   END IF

   LET l_strbuf=base.StringBuffer.create()
   CALL l_strbuf.append(p_cmd)
   CALL l_strbuf.replace('\'','\'\'',0)
   LET p_cmd=l_strbuf.toString()

   LET l_sql="INSERT INTO zs_file(zs01,zs02,zs03,zs04,zs05,",
              "zs06,zs07,zs08,zs09,zs10,zs11,zs12)", 
             "VALUES('",p_tabname CLIPPED,"','",
                        p_dbs CLIPPED,"',",
                        l_zs03 CLIPPED,",'",
                        g_date CLIPPED,"','",
                        l_cust CLIPPED,"','",
                        p_cmd CLIPPED,";','",
                        g_user CLIPPED,"','",
                        g_MODNO CLIPPED,"','Y','N','N','",
                        g_tiptop_ver CLIPPED,"')"
   #FUN-9C0036 -- start --
   EXECUTE IMMEDIATE l_sql
   IF sqlca.sqlcode THEN
      LET l_err="insert zs error(b):no.",l_zs03
      CALL cl_err3("ins","zs_file",p_tabname CLIPPED,l_zs03,SQLCA.sqlcode,"",l_err,1)  
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION

#密碼檢測.
FUNCTION p_db_psw_check(p_user, p_psw)
   DEFINE p_user,p_psw STRING
   DEFINE l_source STRING,
          l_flag BOOLEAN

   LET p_user = p_user.trim()
   LET p_psw = p_psw.trim()

   #No.FUN-9C0036 -- start --
   #FGLPROFILE內一定會有的設定,而且每個schema都是相同.
   #LET l_source = FGL_GETRESOURCE("dbi.database." || p_user || ".source")   
   CASE cl_db_get_database_type()
      WHEN "IFX"
       LET l_source = FGL_GETRESOURCE("dbi.database.ds.source")      
      WHEN "ORA"  
       LET l_source = FGL_GETRESOURCE("dbi.database.ds.source") 
      WHEN "MSV"  
       LET l_source = g_dbs
      WHEN "ASE"               #FUN-AA0052 
       LET l_source = g_dbs    #FUN-AA0052
   END CASE

   #No.FUN-9C0036 -- end --
 
   TRY

      CONNECT TO l_source USER p_user USING p_psw
      #檢查連線後要切斷連線.
      DISCONNECT CURRENT
      DATABASE g_dbs
      LET l_flag = TRUE
      LET INT_FLAG = 0 #091217 by Hiko:這樣可以避免一些問題
   CATCH
      DATABASE g_dbs
      CALL cl_err_msg(null,"azz1016",p_user,10)
      LET l_flag = FALSE
   END TRY 

   RETURN l_flag
END FUNCTION

FUNCTION p_zta_dff_synonym_check(p_tabname,p_tag_db)
DEFINE p_tabname   LIKE type_file.chr20,   #No.FUN-680135 VARCHAR(20)
       l_result    LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
       p_tag_db    LIKE type_file.chr20    #No.FUN-680135 VARCHAR(20)
 
       LET l_result='0'
       #FUN-730016
       #IF g_db_type='IFX' THEN
       CASE cl_db_get_database_type()
        WHEN "IFX"                                      
          select count(*) into l_result from syssyntable
           where tabname=p_tabname
 
        WHEN "ORA"                                      
          select count(1) into l_result from all_synonyms
           where lower(synonym_name)=p_tabname and lower(owner)=p_tag_db
 
        WHEN "MSV"   #FUN-A60017  
          select count(*) into l_result from sys.synonyms
           where tabname=p_tabname                                 
       END CASE
       #END FUN-730016
       RETURN l_result
END FUNCTION
 
