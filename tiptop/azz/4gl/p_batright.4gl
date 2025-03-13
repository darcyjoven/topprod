# Prog. Version..: '5.30.06-13.03.12(00002)'     #
   
# Pattern name...: p_batright.4gl
# Descriptions...: 金額欄位整體權限設定
# Date & Author..: 09/02/03 By kevin    #FUN-9B0131
# Modify.........: No:FUN-A70120 10/08/03 BY alex 拿掉 rowid

DATABASE ds #FUN-9B0131

GLOBALS "../../config/top.global"

DEFINE  tm             RECORD
           price          LIKE type_file.chr1,  #單價
           amount         LIKE type_file.chr1,  #金額
           cost           LIKE type_file.chr1,  #成本
           allmodule      LIKE type_file.chr1,
           modules        STRING
        END RECORD,
        g_gaz          DYNAMIC ARRAY OF RECORD   
        	          chk1   LIKE type_file.chr1,
                          gaz01  LIKE gaz_file.gaz01,  #程式代碼
                          gaz03  LIKE gaz_file.gaz03   #程式名稱
                       END RECORD,       
       g_rec_b         LIKE type_file.num5,                #單身筆數  
       g_sql           STRING,
       g_choice        STRING,
       l_ac            LIKE type_file.num5
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE NOWAIT NOWAIT SQL
DEFINE g_cnt           LIKE type_file.num10   
DEFINE g_msg           LIKE ze_file.ze03      
DEFINE g_show          LIKE type_file.chr1   
DEFINE g_no_ask        LIKE type_file.num5  
DEFINE g_before_input_done   LIKE type_file.num5       #No.FUN-680135 SMALLINT  
DEFINE g_gaj     RECORD 
                    gaj03     LIKE gaj_file.gaj03,
                    gaj04     LIKE gaj_file.gaj04,
                    gaj05     LIKE gaj_file.gaj05,
                    gaj06     LIKE gaj_file.gaj06
                 END RECORD,       
       g_qry_f   DYNAMIC ARRAY OF RECORD
   	            gae02     LIKE gae_file.gae02        
                 END RECORD,
       g_gajb    RECORD  LIKE gajb_file.*,
       g_gajb_t  DYNAMIC ARRAY OF RECORD LIKE gajb_file.*

MAIN
   DEFINE l_cnt         LIKE type_file.num5    #FUN-A70120

   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW batright_w WITH FORM "azz/42f/p_batright"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()

   SELECT COUNT(*) INTO l_cnt FROM gajb_file #刪除舊資料
   IF l_cnt > 0 THEN
      DELETE FROM gajb_file 
   END IF 
   CALL p_batright_menu()

   CLOSE WINDOW batright_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p_batright_menu()

   WHILE TRUE
      CALL p_batright_bp("G")
      CASE g_action_choice         
         WHEN "query"
            IF cl_chk_act_auth() THEN                              
               CALL p_batright_q()
            END IF         
         WHEN "detail"
            IF cl_chk_act_auth() AND g_rec_b > 0 THEN
               CALL p_batright_b()
                
               IF g_action_choice="exit" THEN                  
                  CALL p_batright_init()
               END IF
               
               IF g_success = "Y" THEN
               	  LET g_action_choice = NULL
               END IF 
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

FUNCTION p_batright_init()
   CLEAR FORM                             #清除畫面
   CALL g_gaz.clear()
   LET tm.price = "Y"
   LET tm.amount= "Y"
   LET tm.cost  = "Y"
   LET tm.allmodule  = "Y"
   LET tm.modules  = ""
   LET g_success=""
   MESSAGE ""
END FUNCTION

FUNCTION p_batright_q()
   
   CALL p_batright_init()
   DISPLAY "  " TO FORMONLY.cnt
   
   CALL cl_set_act_visible("accept,cancel", true)
   INPUT BY NAME tm.price,tm.amount,tm.cost,tm.allmodule,tm.modules WITHOUT DEFAULTS
      BEFORE INPUT      
         CALL cl_qbe_init()
         IF tm.allmodule = "Y" THEN
      	    CALL cl_set_comp_entry("modules",FALSE)
      	 END IF
      
      ON CHANGE allmodule
      	 IF tm.allmodule = "Y" THEN
      	    CALL cl_set_comp_entry("modules",FALSE)
      	    LET tm.modules = ""
      	    DISPLAY BY NAME tm.modules
      	 ELSE
            CALL cl_set_comp_entry("modules",TRUE)      	    
         END IF
    
      AFTER INPUT
         IF tm.allmodule = "N" AND cl_null(tm.modules) THEN
      	    CALL cl_err("","azz-905",1)
            NEXT FIELD modules
      	 END IF
         
      	 IF tm.price="Y" OR tm.amount="Y" OR tm.cost="Y" THEN       	 	  
            LET g_choice = "" #三選一
            IF tm.price="Y" THEN
            	LET g_choice =  " '019' "
            END IF
            
            IF tm.amount="Y" THEN
               IF g_choice.getLength()> 0 THEN
            	  LET g_choice =  g_choice ,",'020' "
               ELSE
            	  LET g_choice =  " '020' "
               END IF
            END IF
            
            IF tm.cost="Y" THEN
               IF g_choice.getLength()> 0 THEN
            	  LET g_choice =  g_choice ,",'021' "
               ELSE
            	  LET g_choice =  " '021' "
               END IF
            END IF      	 	  
      	 ELSE
      	    CALL cl_err("","azz-905",1)
      	    NEXT FIELD price
      	 END IF
      	 
      	 CALL p_batright_b_fill()
      	 
       ON ACTION CONTROLP
         CASE
            WHEN INFIELD(modules)            
               CALL q_zz4(TRUE,TRUE,'') RETURNING g_qryparam.multiret
               LET tm.modules = g_qryparam.multiret
               DISPLAY BY NAME tm.modules
               NEXT FIELD modules	
         END CASE
         
      ON ACTION CANCEL          
         LET INT_FLAG = 0
         EXIT INPUT  	 
      	 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 	 

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

  END INPUT
       
END FUNCTION

FUNCTION p_batright_b()        
   DEFINE i       LIKE type_file.num5,
          l_run   LIKE type_file.num5
       
   LET g_show = "N"
          
   INPUT ARRAY g_gaz WITHOUT DEFAULTS FROM s_gaz.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
      BEFORE INPUT
      	 IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)           
         END IF
         CALL cl_set_act_visible("accept", FALSE)
         IF g_show = "N" THEN
            CALL cl_set_act_visible("restore_user_rights", FALSE)
            CALL cl_set_act_visible("batch_user_rights", TRUE)
         END IF 
                  
      ON ACTION batch_user_rights   #設定權限      
         LET l_run = FALSE
         FOR i = 1 TO ARR_COUNT()  
             IF g_gaz[i].chk1 = "Y" THEN
             	LET l_run = TRUE
                EXIT FOR 
             END IF 
         END FOR
         
         IF l_run THEN
            CALL p_batright_user()  
            LET g_show = "Y"    
            CALL cl_set_act_visible("accept", FALSE)
            CALL cl_set_act_visible("batch_user_rights", FALSE)
            EXIT INPUT
         ELSE
             CALL cl_err("","azz-903",1)
         END IF
      
      ON ACTION select_all        
         FOR i = 1 TO ARR_COUNT()  
             LET g_gaz[i].chk1 = "Y"
             DISPLAY BY NAME g_gaz[i].chk1
         END FOR
         	 
      ON ACTION select_none
         FOR i = 1 TO ARR_COUNT()  
             LET g_gaz[i].chk1 = "N"
             DISPLAY BY NAME g_gaz[i].chk1
         END FOR        
     

      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
          
      ON ACTION controlg
          CALL cl_cmdask()                

      ON ACTION HELP
         CALL cl_show_help()          

      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT INPUT
         	
      ON ACTION CANCEL         	
         LET g_action_choice = "exit"
         EXIT INPUT
           	
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      	
   END INPUT
   
END FUNCTION 

FUNCTION p_batright_b_fill()
DEFINE l_where   STRING,
       l_cnt     LIKE type_file.num5
       
   LET g_sql ="select distinct 'Y',gae01,gaz03 from gae_file,gaq_file,OUTER gaz_file ",
              " where gae02 = gaq01 ",
              " and gaq02 = ? ",
              " and gaq07 in (" , g_choice ,")",
              " and gae01 = gaz01 ",
              " and gaz02 = ? ",              
              " and gae12 = 'std' "
              
              
   IF tm.allmodule = "N" THEN #加入個別模組
   	  CALL p_batright_make_where(tm.modules) RETURNING l_where
   	  LET g_sql = g_sql, l_where 
   END IF
   
   LET g_sql = g_sql, " order by gae01"
   PREPARE prog_sql FROM g_sql
   DECLARE prog_cs CURSOR FOR prog_sql
   
   CALL g_gaz.clear()
   LET g_cnt = 1
   LET g_rec_b=0
    
   FOREACH prog_cs USING g_lang,g_lang INTO g_gaz[g_cnt].*  #單身 ARRAY 填充    	
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,0)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   
   CALL g_gaz.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1   
   LET g_cnt = 0
   DISPLAY g_rec_b TO FORMONLY.cnt
      
   IF g_rec_b = 0 THEN
      CALL cl_err('',100,0)
   ELSE
      LET g_action_choice = "detail" #有資料則進入單身
   END IF 
   
   SELECT COUNT(*) INTO l_cnt FROM gajb_file #查詢時刪除備份資料
   IF l_cnt > 0 THEN
      DELETE FROM gajb_file 
      LET g_show = "N"   	  
   END IF 
    
END FUNCTION

FUNCTION p_batright_make_where(ps_temp)
   DEFINE ps_temp     STRING
   DEFINE ls_result   STRING
   DEFINE lst_tokens  base.StringTokenizer   
   DEFINE ls_module   STRING
   DEFINE l_i         LIKE type_file.num5  
   
   LET lst_tokens = base.StringTokenizer.create(ps_temp.trim(), "|")
   
   LET ls_result = ""  
   LET l_i = 1 
   WHILE lst_tokens.hasMoreTokens()
       LET ls_module = lst_tokens.nextToken()
       LET ls_module = ls_module.trim()  
       IF l_i = 1 THEN       	  
          LET ls_result = ls_result CLIPPED," gae01 like '", DOWNSHIFT(ls_module), "%'"
       ELSE
       	  LET ls_result = ls_result CLIPPED," or gae01 like '", DOWNSHIFT(ls_module), "%'"      
       END IF
       LET l_i = l_i + 1
   END WHILE
   LET ls_result =  " and (",ls_result CLIPPED ,")"   
   RETURN ls_result
END FUNCTION

FUNCTION p_batright_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1,
            l_cnt     LIKE type_file.num5,
            l_i       LIKE type_file.num5,
            l_success LIKE type_file.num5,
            l_msg     LIKE ze_file.ze03

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   SELECT COUNT(*) INTO l_cnt FROM gajb_file
   IF l_cnt > 0 THEN                             
      CALL cl_set_act_visible("restore_user_rights", TRUE)
   ELSE
      CALL cl_set_act_visible("restore_user_rights", FALSE)
   END IF
   
   DISPLAY ARRAY g_gaz TO s_gaz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf      

         {IF g_rec_b > 0 THEN
            CALL cl_set_action_active("accept", TRUE)           
         ELSE
            CALL cl_set_action_active("accept", FALSE) # 關閉單身可進入修改
            CALL cl_set_act_visible("detail", FALSE)
         END IF
         
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1         
         EXIT DISPLAY}
         
      ON ACTION restore_user_rights      
         SELECT COUNT(*) INTO l_cnt FROM gajb_file
         IF l_cnt > 0 THEN  #開始還原權限設定
       	    BEGIN WORK 
            PREPARE gajb_sql FROM "select * from gajb_file"
            DECLARE bcurs_qry CURSOR FOR gajb_sql
            
            LET l_success = TRUE 
            LET l_i = 1
            	
            FOREACH bcurs_qry INTO g_gajb_t[l_i].*
            	 
               DELETE FROM gaj_file   #新舊都要刪除
   	          WHERE gaj01 = g_gajb_t[l_i].gajb01
   	            AND gaj02 = g_gajb_t[l_i].gajb02
   	          
   	       IF SQLCA.sqlcode THEN
   	          LET l_success = FALSE
                  CALL cl_err3("del","gajb_file",g_gajb_t[l_i].gajb01,g_gajb_t[l_i].gajb02,SQLCA.sqlcode,"","",1)
                  EXIT FOREACH
               END IF
               
               IF g_gajb_t[l_i].gajb12 <> 'X' THEN 
                  INSERT INTO gaj_file VALUES (g_gajb_t[l_i].*) #還原舊資料到 gaj_file
               
                  IF SQLCA.sqlcode THEN
                      LET l_success = FALSE
                      CALL cl_err3("ins","gajb_file",g_gajb_t[l_i].gajb01,g_gajb_t[l_i].gajb02,SQLCA.sqlcode,"","",1)
                      EXIT FOREACH                  
                  END IF
               END IF
               LET l_i = l_i + 1               
            END FOREACH            
                     
            IF l_success = FALSE THEN               
               CALL cl_err('',"azz-908",1)   #還原失敗 
               ROLLBACK WORK 	
            ELSE
               COMMIT WORK               
               CALL cl_err('',"azz-906",1)   #還原成功
               DELETE FROM gajb_file
               CALL cl_set_act_visible("restore_user_rights", FALSE)
            END IF 
            LET g_success = NULL 
         END IF 
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      #ON ACTION accept
      #   LET g_action_choice="detail"
      #   LET l_ac = ARR_CURR()
      #   EXIT DISPLAY
 
      ON ACTION close
         LET INT_FLAG=FALSE                 
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION exit
         LET INT_FLAG=FALSE                 
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE                 #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121 

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032

       
         EXIT DISPLAY 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   
END FUNCTION

#權限設定畫面
FUNCTION p_batright_user()   
DEFINE  l_i     LIKE type_file.num5
          
   OPEN WINDOW p_batright_user_w WITH FORM "azz/42f/p_batright_user"         
          ATTRIBUTE (STYLE = "create_qry")

   CALL cl_ui_locale("p_batright_user")
   CALL cl_set_act_visible("accept,cancel", TRUE)   
   
   INITIALIZE g_gaj.* TO NULL
   LET INT_FLAG = 0
   INPUT BY NAME g_gaj.gaj03,g_gaj.gaj04,g_gaj.gaj05,g_gaj.gaj06 WITHOUT DEFAULTS
        BEFORE INPUT 
           LET g_before_input_done = FALSE
           CALL p_batright_set_entry_b()
           CALL p_batright_set_no_entry_b()
           LET g_before_input_done = TRUE
         
        BEFORE FIELD gaj03
           CALL p_batright_set_entry_b()

        AFTER FIELD gaj03
           IF NOT cl_null(g_gaj.gaj03) THEN   #MOD-560212
              IF NOT p_batright_chkzwacti(g_gaj.gaj03) THEN
                 NEXT FIELD gaj03
              END IF
           END IF
           CALL p_batright_set_no_entry_b()

        BEFORE FIELD gaj04
        	 CALL p_batright_set_entry_b()

        AFTER FIELD gaj04
           IF NOT cl_null(g_gaj.gaj04) THEN   #MOD-560212
              IF NOT p_batright_chkzwacti(g_gaj.gaj04) THEN
                 NEXT FIELD gaj04
              END IF
           END IF
           CALL p_batright_set_no_entry_b()

        BEFORE FIELD gaj05
           CALL p_batright_set_entry_b()

        AFTER FIELD gaj05
           CALL p_batright_set_no_entry_b()

        BEFORE FIELD gaj06
           CALL p_batright_set_entry_b()

        AFTER FIELD gaj06
           CALL p_batright_set_no_entry_b()
           
      AFTER INPUT 
      	 IF INT_FLAG THEN
            LET INT_FLAG = 0
      	    EXIT INPUT	
      	 END IF
         
         IF NOT cl_confirm('azz-907') THEN
            CONTINUE INPUT
         END IF
          
      	 IF cl_null(g_gaj.gaj03) AND cl_null(g_gaj.gaj04) AND
            cl_null(g_gaj.gaj05) AND cl_null(g_gaj.gaj06) THEN
              CALL cl_err('',"azz-907",1)      
              NEXT FIELD gaj03
         END IF
   	     
   	 BEGIN WORK    	     
   	 LET g_success='Y'
   	 
   	 FOR l_i = 1 TO g_gaz.getLength() 
            IF g_gaz[l_i].chk1 = "Y" THEN
       	       CALL p_batright_f_result_set(g_gaz[l_i].gaz01)
            END IF 
         END FOR
         
         IF g_success='N' THEN
       	    ROLLBACK WORK
            CALL cl_err("","azz-904",1)
         ELSE
            COMMIT WORK
            CALL cl_end(1,1)         	           		
         END IF 
   	 EXIT INPUT
   	  
     ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gaj03)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_zw"
               LET g_qryparam.default1 = g_gaj.gaj03
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_gaj.gaj03
               DISPLAY g_gaj.gaj03 TO gaj03
               NEXT FIELD gaj03
               
            WHEN INFIELD(gaj04)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_zw"
               LET g_qryparam.default1 = g_gaj.gaj04
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_gaj.gaj04
               DISPLAY g_gaj.gaj04 TO gaj04
               NEXT FIELD gaj04
               
            WHEN INFIELD(gaj05)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_zx"
               LET g_qryparam.default1 = g_gaj.gaj05
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_gaj.gaj05
               DISPLAY g_gaj.gaj05 TO gaj05
               NEXT FIELD gaj05
                  
            WHEN INFIELD(gaj06)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_zx"
               LET g_qryparam.default1 = g_gaj.gaj06
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_gaj.gaj06
               DISPLAY g_gaj.gaj06 TO gaj06
               NEXT FIELD gaj06
                  
         END CASE
                  	    	
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
         	
      ON ACTION controlg
         CALL cl_cmdask()  
         
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
         
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
         
   END INPUT
     
   CLOSE WINDOW p_batright_user_w
END FUNCTION


FUNCTION p_batright_f_result_set(p_prog)
DEFINE p_prog    LIKE gae_file.gae01, 
       li_i      LIKE type_file.num5,
       l_cnt     LIKE type_file.num5,
       ls_sql    STRING,
       ls_sql2   STRING
DEFINE lc_gav10  LIKE gav_file.gav10
   
   #gae_file 畫面檔    
   LET ls_sql = " select distinct gae02 from gae_file,gaq_file",
                "  where gae02=gaq01 ",
                "    and gae01=? and gaq07 in (" , g_choice ,")",                
                "    and gae03 = ? ",
                "    and gaq02 = gae03", 
                "    and gae12 = 'std' "
   
   PREPARE gav_sql FROM ls_sql
   DECLARE fcurs_qry CURSOR FOR gav_sql
   
   LET ls_sql2 = "SELECT count(*) FROM gaj_file WHERE gaj01=? AND gaj02=? and gaj11='std' "
   PREPARE count_sql FROM ls_sql
   DECLARE count_qry CURSOR FOR count_sql
   
   LET li_i = 1
   FOREACH fcurs_qry USING p_prog,g_lang INTO g_qry_f[li_i].*
   	
   	  IF NOT cl_null(g_qry_f[li_i].gae02) THEN
   	  	
   	      SELECT count(*) INTO l_cnt FROM gaj_file 
   	       WHERE gaj01 = p_prog
   	         AND gaj02 = g_qry_f[li_i].gae02
   	       
   	      IF l_cnt > 0 THEN
   	      	 SELECT * INTO  g_gajb.* FROM gaj_file 
   	          WHERE gaj01 = p_prog
   	            AND gaj02 = g_qry_f[li_i].gae02  
   	           
   	         INSERT INTO gajb_file VALUES (g_gajb.*) #備份舊資料到 gajb_file
   	         
   	         IF SQLCA.sqlcode THEN
   	      	    LET g_success='N'
                    CALL cl_err3("ins","gajb_file",p_prog,g_qry_f[li_i].gae02,SQLCA.sqlcode,"","",1)   
                RETURN
              END IF
   	      	               
   	      DELETE FROM gaj_file   #舊資料刪除
   	       WHERE gaj01 = p_prog 
   	         AND gaj02 = g_qry_f[li_i].gae02
   	            
   	      IF SQLCA.sqlcode THEN
   	         LET g_success='N'
                 CALL cl_err3("del","gaj_file",p_prog,g_qry_f[li_i].gae02,SQLCA.sqlcode,"","",1)   
                 RETURN
              END IF
             
         ELSE
            INSERT INTO gajb_file(gajb01,gajb02,gajb12) #備份新資料到 gajb_file
   	      	      VALUES (p_prog,g_qry_f[li_i].gae02,'X')
   	      	
   	      	IF SQLCA.sqlcode THEN
   	           LET g_success='N'
                   CALL cl_err3("ins","gajb_file",p_prog,g_qry_f[li_i].gae02,SQLCA.sqlcode,"","",1)   
                   RETURN
                END IF      
   	     END IF
   	      
   	      	SELECT gav10 INTO lc_gav10 FROM gav_file
                 WHERE gav01 = p_prog AND gav02=g_qry_f[li_i].gae02 AND gav11 = 'std'
             
                 IF cl_null(lc_gav10) THEN  #若是必要欄位,則需要將gaj12設定為"Y"
             	   LET lc_gav10="N"
                 END IF 
             
   	      	 INSERT INTO gaj_file(gaj01,gaj02,gaj03,gaj04,gaj05,gaj06,gaj11,gaj12)
   	      	      VALUES (p_prog,g_qry_f[li_i].gae02,g_gaj.gaj03,g_gaj.gaj04,
   	      	               g_gaj.gaj05,g_gaj.gaj06,'std',lc_gav10)
   	      	               
   	      	 IF SQLCA.sqlcode THEN
   	      	 	  LET g_success='N'
                CALL cl_err3("ins","gaj_file",p_prog,g_qry_f[li_i].gae02,SQLCA.sqlcode,"","",1)
                RETURN
             END IF            
   	     	       
   	  END IF 
   	  
   END FOREACH
              
END FUNCTION

FUNCTION p_batright_chkzwacti(ls_zw)
    DEFINE ls_zw       STRING
    DEFINE lst_grup    base.StringTokenizer,
           ls_grup     STRING
    DEFINE ls_unact    STRING
    DEFINE lc_zw01     LIKE zw_file.zw01
    DEFINE lc_zwacti   LIKE zw_file.zwacti

    LET lst_grup = base.StringTokenizer.create(ls_zw CLIPPED, "|")
    LET ls_unact = ""

    WHILE lst_grup.hasMoreTokens()
       LET ls_grup = lst_grup.nextToken()
       LET lc_zw01 = ls_grup.trim()

       SELECT zwacti INTO lc_zwacti FROM zw_file
        WHERE zw01 = lc_zw01
       IF lc_zwacti = "N" THEN
          LET ls_unact = ls_unact,", ",lc_zw01 CLIPPED
       END IF
    END WHILE

    IF cl_null(ls_unact) THEN
       RETURN TRUE
    ELSE
       LET ls_unact = ls_unact.subString(2,ls_unact.getLength())
       LET ls_unact = ls_unact.trim()
       CALL cl_err_msg(NULL,"azz-218",ls_unact.trim(),10)
       RETURN FALSE
    END IF

END FUNCTION

FUNCTION p_batright_set_entry_b()
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680135 CHAR(1)

   IF INFIELD(gaj03) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gaj04",TRUE)
   END IF
   IF INFIELD(gaj04) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gaj03",TRUE)
   END IF
   IF INFIELD(gaj05) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gaj06",TRUE)
   END IF
   IF INFIELD(gaj06) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gaj05",TRUE)
   END IF
END FUNCTION

FUNCTION p_batright_set_no_entry_b()
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680135 CHAR(1)

   IF INFIELD(gaj03) OR (NOT g_before_input_done) THEN
      IF NOT cl_null(g_gaj.gaj03) THEN
         CALL cl_set_comp_entry("gaj04",FALSE)
      END IF
   END IF

   IF INFIELD(gaj04) OR (NOT g_before_input_done) THEN
      IF NOT cl_null(g_gaj.gaj04) THEN
         CALL cl_set_comp_entry("gaj03",FALSE)
      END IF
   END IF

   IF INFIELD(gaj05) OR (NOT g_before_input_done) THEN
      IF NOT cl_null(g_gaj.gaj05) THEN
         CALL cl_set_comp_entry("gaj06",FALSE)
      END IF
   END IF

   IF INFIELD(gaj06) OR (NOT g_before_input_done) THEN
      IF NOT cl_null(g_gaj.gaj06) THEN
         CALL cl_set_comp_entry("gaj05",FALSE)
      END IF
   END IF
END FUNCTION
