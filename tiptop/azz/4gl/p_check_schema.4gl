# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: p_check_schema.4gl
# Descriptions...: schema比對清單工具
# Date & Author..: NO.FUN-A70013 10/07/02 By Jay
# Modify.........: No.FUN-A80014 10/08/02 By Jay  增加虛擬DB和ds比較zta_file的總數量
# Modify.........: No.FUN-A80009 10/08/10 By Jay  增加MSV比對功能

DATABASE ds
#FUN-A70013
GLOBALS "../../config/top.global"

DEFINE 
     g_zta_schema    DYNAMIC ARRAY OF RECORD       #zta各table類型統計表
        sch01           LIKE type_file.chr10,      #VARCHAR(1),
        sch02           LIKE type_file.chr1,       #VARCHAR(10), 
        sch03           LIKE type_file.chr10,      #VARCHAR(10),
        sch04           LIKE type_file.num10,      #INTEGER,
        sch05           LIKE type_file.num10,      #INTEGER,
        sch06           LIKE type_file.num10,      #INTEGER,
        sch07           LIKE type_file.num10,      #INTEGER,
        sch08           LIKE type_file.num10,      #INTEGER,
        sch09           LIKE type_file.num10       #INTEGER
                     END RECORD,
     g_zta_diff      DYNAMIC ARRAY OF RECORD       #zta間各DB與ds差異表
        diff01          LIKE type_file.chr10,      #VARCHAR(10),
        diff02          LIKE type_file.chr50,      #VARCHAR(50), 
        diff03          LIKE type_file.num10,      #INTEGER,
        diff04          STRING
                     END RECORD,
     g_db_diff       DYNAMIC ARRAY OF RECORD       #zta間各DB與實際DB現況差異表
        db01            LIKE type_file.chr10,      #VARCHAR(10),
        db02            LIKE type_file.chr50,      #VARCHAR(50), 
        db03            LIKE type_file.num10,      #INTEGER,
        db04            STRING
                     END RECORD,
    g_sql            STRING,
    g_rec_b          LIKE type_file.num5,          #單身筆數
    l_ac             LIKE type_file.num5,          #目前處理的ARRAY CNT  
    g_cnt            LIKE type_file.num10, 
    g_db_type        LIKE type_file.chr3           #FUN-A80009

MAIN
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP                               # 輸入的方式: 不打轉
      DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1)                  # 計算使用時間 (進入時間) 
         RETURNING g_time    

   OPEN WINDOW p_ods_db_w WITH FORM "azz/42f/p_check_schema"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()

   CALL p_check_schema_init()
   LET g_db_type=cl_db_get_database_type()         #FUN-A80009
   #CALL p_check_schema_zta_b_fill()
   CALL p_check_schema_menu()

   CLOSE WINDOW p_check_schema_w                   # 結束畫面
   CALL  cl_used(g_prog,g_time,2)                  # 計算使用時間 (退出使間) 
         RETURNING g_time    

END MAIN

FUNCTION p_check_schema_menu()
 
   WHILE TRUE
      CALL p_check_schema_bp("G")
      CASE g_action_choice
         WHEN "db_difference_statistics"
            CALL p_check_dbdiff_menu()
            EXIT WHILE
         WHEN "output"
#            IF cl_chk_act_auth() THEN
               CALL p_check_schema_out()
#            END IF
         WHEN "exporttoexcel"     
#            IF cl_chk_act_auth() THEN
              CALL p_check_schema_export_to_excel()
#            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask() 
      END CASE
   END WHILE
END FUNCTION

FUNCTION p_check_schema_init() #初始環境設定
   CALL g_zta_schema.clear()
   CALL g_zta_diff.clear()
   CALL g_db_diff.clear()
END FUNCTION

FUNCTION p_check_schema_zta_b_fill()  

DEFINE  l_sch01      LIKE type_file.chr10,   #VARCHAR(1),
        l_sch02      LIKE type_file.chr1,    #VARCHAR(10), 
        l_sch03      LIKE type_file.chr10    #VARCHAR(10)
DEFINE  l_cnt        LIKE type_file.num10    #INTEGER  個別數量
DEFINE  l_total      LIKE type_file.num10    #INTEGER  總數量 

    LET g_sql = "SELECT DISTINCT LOWER(azw05), 'Y', LOWER(azw09) ", 
                   "FROM azw_file WHERE azwacti = 'Y' ", 
                "UNION ",
                "SELECT distinct LOWER(azw06), 'N', LOWER(azw09) ",
                   "FROM azw_file WHERE azwacti = 'Y' AND azw05 <> azw06 ",
                "ORDER BY 1"

    PREPARE p_check_schema_zta FROM g_sql
    DECLARE schema_curs_zta CURSOR FOR p_check_schema_zta
 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH schema_curs_zta INTO l_sch01, l_sch02, l_sch03      #單身ARRAY填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
        END IF
        
        #已經建立的DB才需要比較
        IF NOT cl_chk_schema_has_built(l_sch01) THEN 
           CONTINUE FOREACH
        END IF
        
        LET g_zta_schema[g_cnt].sch01 = l_sch01
        LET g_zta_schema[g_cnt].sch02 = l_sch02
        LET g_zta_schema[g_cnt].sch03 = l_sch03
        LET g_zta_schema[g_cnt].sch04 = '0'
        LET g_zta_schema[g_cnt].sch05 = '0'
        LET g_zta_schema[g_cnt].sch06 = '0'
        LET g_zta_schema[g_cnt].sch07 = '0'
        LET g_zta_schema[g_cnt].sch08 = '0'
        LET g_zta_schema[g_cnt].sch09 = '0'
        LET l_cnt = 0
        LET l_total = 0
        
        #處理非ods的資料
        IF l_sch01 = "ds" THEN
           #ds只要取得Table的資料即可
           LET l_cnt = p_check_schema_get_table(l_sch01)
           LET g_zta_schema[g_cnt].sch04 = l_cnt
           LET l_total = l_total + l_cnt
        ELSE
           #表示此schema為實體DB
           IF l_sch02 = 'Y' THEN
              #取得Table的數量
              LET l_cnt = p_check_schema_get_table(l_sch01)
              LET g_zta_schema[g_cnt].sch04 = l_cnt
              LET l_total = l_total + l_cnt
              
              #取得Synonym for ds的數量
              LET l_cnt = p_check_schema_get_synfords(l_sch01)
              LET g_zta_schema[g_cnt].sch05 = l_cnt
              LET l_total = l_total + l_cnt
              
              #取得Synonym for非ds的數量
              LET l_cnt = p_check_schema_get_synfornotds(l_sch01) 
              LET g_zta_schema[g_cnt].sch06 = l_cnt
              LET l_total = l_total + l_cnt
           #表示此schema為虛擬DB
           ELSE
              #取得Synonym for實體DB的數量
              LET l_cnt = p_check_schema_get_synforentity(l_sch01, l_sch03)
              LET g_zta_schema[g_cnt].sch07 = l_cnt
              LET l_total = l_total + l_cnt
              
              #取得View from實體DB的數量
              LET l_cnt = p_check_schema_get_view(l_sch01)
              LET g_zta_schema[g_cnt].sch08 = l_cnt
              LET l_total = l_total + l_cnt
           END IF
        END IF

        LET g_zta_schema[g_cnt].sch09 = l_total
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    
    LET l_cnt = 0
    LET l_total = 0
        
    #處理ods的資料
    LET g_zta_schema[g_cnt].sch01 = 'ods'
    LET g_zta_schema[g_cnt].sch02 = 'N'
    LET g_zta_schema[g_cnt].sch03 = ' '
    LET g_zta_schema[g_cnt].sch04 = '0'
    
    #取得Synonym for ds的數量
    LET l_cnt = p_check_schema_get_ods_synfords('ds')
    LET g_zta_schema[g_cnt].sch05 = l_cnt
    LET l_total = l_total + l_cnt
    
    LET g_zta_schema[g_cnt].sch06 = '0'
    LET g_zta_schema[g_cnt].sch07 = '0'
    
    #取得View from ds的數量
    LET l_cnt = p_check_schema_get_ods_view('ds')
    LET g_zta_schema[g_cnt].sch08 = l_cnt
    LET l_total = l_total + l_cnt
    
    LET g_zta_schema[g_cnt].sch09 = l_total
            
    MESSAGE ""
    LET g_rec_b = g_cnt
    LET g_cnt = 0 
END FUNCTION
 
FUNCTION p_check_schema_bp(p_ud)
   DEFINE p_ud      LIKE type_file.chr1
   DEFINE l_cnt     LIKE type_file.num10
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG   
      DISPLAY ARRAY g_zta_diff TO s_zta_diff.* 
      END DISPLAY
      
      DISPLAY ARRAY g_zta_schema TO s_zta_schema.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                  
      END DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG

      ON ACTION exporttoexcel    
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      ON ACTION zta_count_statistics
         LET g_action_choice="zta_count_statistics"
         CALL g_zta_schema.clear()
         CALL p_check_schema_zta_b_fill()
         EXIT DIALOG

      ON ACTION zta_difference_statistics
         LET g_action_choice="zta_difference_statistics"
         CALL g_zta_diff.clear()
         LET l_cnt = p_check_schema_get_zta_diff()
         EXIT DIALOG
 
      ON ACTION db_difference_statistics
         LET g_action_choice="db_difference_statistics"
         CALL g_db_diff.clear()
         LET l_cnt = p_check_schema_get_db_diff()
         EXIT DIALOG

      ON ACTION db_detail
         LET g_action_choice="db_difference_statistics"
         EXIT DIALOG
      
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()            
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION close  
         LET INT_FLAG=FALSE  
         LET g_action_choice='exit'
         EXIT DIALOG

      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about        
         CALL cl_about()    
         
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION p_check_dbdiff_menu()
 
   WHILE TRUE
      CALL p_check_dbdiff_bp("G")
      CASE g_action_choice
         WHEN "zta_difference_statistics"
            CALL p_check_schema_menu()
            EXIT WHILE
         WHEN "zta_count_statistics"
            CALL p_check_schema_menu()
            EXIT WHILE
         WHEN "output"
#            IF cl_chk_act_auth() THEN
               CALL p_check_schema_out()
#            END IF
         WHEN "exporttoexcel"     
#            IF cl_chk_act_auth() THEN
              CALL p_check_schema_export_to_excel()
#            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask() 
      END CASE
   END WHILE
END FUNCTION

FUNCTION p_check_dbdiff_bp(p_ud)
   DEFINE p_ud      LIKE type_file.chr1
   DEFINE l_cnt     LIKE type_file.num10
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_db_diff TO s_db_diff.* 

      ON ACTION zta_count_statistics
         LET g_action_choice="zta_count_statistics"
         CALL g_zta_schema.clear()
         CALL p_check_schema_zta_b_fill()
         EXIT DISPLAY
 
      ON ACTION zta_difference_statistics
         LET g_action_choice="zta_difference_statistics"
         CALL g_zta_diff.clear()
         LET l_cnt = p_check_schema_get_zta_diff()
         EXIT DISPLAY

      ON ACTION db_difference_statistics
         LET g_action_choice="db_difference_statistics"
         CALL g_db_diff.clear()
         LET l_cnt = p_check_schema_get_db_diff()
         EXIT DISPLAY

      ON ACTION zta_detail
         LET g_action_choice="zta_difference_statistics"
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION exporttoexcel    
         LET g_action_choice = 'exporttoexcel'
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

      ON ACTION close  
         LET INT_FLAG=FALSE  
         LET g_action_choice='exit'
         EXIT DISPLAY

      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()    
         
   END DISPLAY 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION                                           

FUNCTION p_check_schema_get_table(p_chk_db)                                               
   DEFINE p_chk_db        LIKE type_file.chr10        
   DEFINE l_table_cnt     LIKE type_file.num10   
   
   SELECT COUNT(*) INTO l_table_cnt FROM zta_file 
       WHERE zta02 = p_chk_db AND zta07 = 'T' AND zta03 <> 'AIN'  
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_table","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF
   
   RETURN l_table_cnt                                                           
END FUNCTION                                                                  

FUNCTION p_check_schema_get_synfords(p_chk_db)                                               
   DEFINE p_chk_db        LIKE type_file.chr10        
   DEFINE l_syn_ds_cnt    LIKE type_file.num10   
   
   SELECT COUNT(*) INTO l_syn_ds_cnt FROM zta_file 
       WHERE zta02 = p_chk_db AND zta07 = 'S' AND 
       zta17 = 'ds' AND zta03 <> 'AIN'  
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_synfords","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF
   
   RETURN l_syn_ds_cnt                                                           
END FUNCTION   

FUNCTION p_check_schema_get_synfornotds(p_chk_db)                                               
   DEFINE p_chk_db           LIKE type_file.chr10       
   DEFINE l_syn_notds_cnt    LIKE type_file.num10   
   
   SELECT COUNT(*) INTO l_syn_notds_cnt FROM zta_file 
       WHERE zta02 = p_chk_db AND zta07 = 'S' AND
       zta17 <> 'ds' AND zta03 <> 'AIN'  
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_synfornotds","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF
   
   RETURN l_syn_notds_cnt                                                           
END FUNCTION   

FUNCTION p_check_schema_get_synforentity(p_chk_db, p_finance_db)                                               
   DEFINE p_chk_db           LIKE type_file.chr10  
   DEFINE p_finance_db       LIKE type_file.chr10      
   DEFINE l_syn_entity_cnt  LIKE type_file.num10   
   #--FUN-A80009 modify start------
   CASE g_db_type
       WHEN "IFX"

       WHEN "ORA"
   #--FUN-A80009 modify end--------   
          SELECT COUNT(*) INTO l_syn_entity_cnt FROM zta_file 
              WHERE zta02 = p_chk_db AND zta07 = 'S' AND
              zta17 = p_finance_db AND zta03 <> 'AIN'  
   #--FUN-A80009 modify start------
       WHEN "MSV"
          SELECT COUNT(*) INTO l_syn_entity_cnt FROM zta_file 
              WHERE zta02 = p_chk_db AND zta07 = 'S' AND
              zta17 IN (p_finance_db, 'ds') AND zta03 <> 'AIN'  
   END CASE
   #--FUN-A80009 modify end--------  
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_synforentity","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF
   
   RETURN l_syn_entity_cnt                                                           
END FUNCTION  

FUNCTION p_check_schema_get_view(p_chk_db)         
   DEFINE p_chk_db           LIKE type_file.chr10   
   DEFINE l_view_cnt  LIKE type_file.num10   
   
   SELECT count(*) INTO l_view_cnt FROM zta_file 
       WHERE zta02 = p_chk_db AND zta07 = 'V' AND zta03 <> 'AIN'   
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_view","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF
   
   RETURN l_view_cnt                                                           
END FUNCTION  

FUNCTION p_check_schema_get_ods_synfords(p_chk_db)                     
   DEFINE p_chk_db        LIKE type_file.chr10        
   DEFINE l_syn_ds_cnt    LIKE type_file.num10   
   
   SELECT count(*) INTO l_syn_ds_cnt FROM zta_file 
       WHERE zta02 = p_chk_db AND zta07 = 'T' AND
       zta09 = 'Z' AND zta03 <> 'AIN'  

   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_ods_synfords","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF
   
   RETURN l_syn_ds_cnt                                                           
END FUNCTION  

FUNCTION p_check_schema_get_ods_view(p_chk_db)         
   DEFINE p_chk_db           LIKE type_file.chr10      
   DEFINE l_view_cnt  LIKE type_file.num10   
   
   SELECT count(*) INTO l_view_cnt FROM zta_file 
       WHERE zta02 = p_chk_db AND zta07 = 'T' AND
       zta09 <> 'Z' AND zta03 <> 'AIN'  
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_ods_view","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF
   
   RETURN l_view_cnt                                                           
END FUNCTION  

FUNCTION p_check_schema_get_diff_table(p_chk_db)                                               
   DEFINE p_chk_db        LIKE type_file.chr10
   DEFINE l_zta01         LIKE zta_file.zta01   
   DEFINE l_table         STRING

   LET l_table = ""
   LET g_sql = "SELECT zta01 FROM zta_file ",
               "  WHERE zta02 = 'ds' AND zta07 = 'T' AND zta09 <> 'Z' ",
               "  AND zta03 <> 'AIN' AND zta01 NOT IN ( ",
               "      SELECT zta01 FROM zta_file ", 
               "        WHERE zta02 = '", p_chk_db, "' ",
               "        AND zta07 = 'T' AND zta03 <> 'AIN')"

    PREPARE p_check_schema_diff_table FROM g_sql
    DECLARE schema_curs_diff_table CURSOR FOR p_check_schema_diff_table
 
    FOREACH schema_curs_diff_table INTO l_zta01
        LET l_table = l_table, l_zta01, ", "
    END FOREACH
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_diff_table","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF
   
   RETURN l_table                                                           
END FUNCTION

FUNCTION p_check_schema_get_diff_synfords(p_chk_db)                                               
   DEFINE p_chk_db        LIKE type_file.chr10        
   DEFINE l_zta01         LIKE zta_file.zta01   
   DEFINE l_table         STRING
   DEFINE l_cnt           LIKE type_file.num10
   
   LET l_table = ""
   LET l_cnt = 0
   LET g_sql = "SELECT zta01 FROM zta_file ",
               "  WHERE zta02 = 'ds' AND zta07 = 'T' AND zta09 = 'Z' ",
               "  AND zta03 <> 'AIN' AND zta01 NOT IN ( ",
               "      SELECT zta01 FROM zta_file ", 
               "        WHERE zta02 = '", p_chk_db, "' ",
               "        AND zta07 = 'S' AND zta17 = 'ds' ",
               "        AND zta03 <> 'AIN')"
 
    PREPARE p_check_schema_diff_synfords FROM g_sql
    DECLARE schema_curs_diff_synfords CURSOR FOR p_check_schema_diff_synfords
 
    FOREACH schema_curs_diff_synfords INTO l_zta01
        LET l_table = l_table, l_zta01, ", "
        LET l_cnt = l_cnt + 1
    END FOREACH
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_diff_synfords","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF
   
   RETURN l_table, l_cnt                                                           
END FUNCTION   

FUNCTION p_check_schema_get_diff_notsynfords(p_chk_db)                                               
   DEFINE p_chk_db        LIKE type_file.chr10
   DEFINE l_zta01         LIKE zta_file.zta01   
   DEFINE l_table         STRING
   DEFINE l_cnt           LIKE type_file.num10
   
   LET l_table = ""
   LET l_cnt = 0
   LET g_sql = "SELECT zta01 FROM zta_file ",
               "  WHERE zta02 = 'ds' ",           
               "  AND zta07 = 'T' AND zta09 <> 'Z' ",          #取出ds檔案類型不屬於'Z'(系統檔)的檔案名稱
               "  AND zta03 <> 'AIN' AND zta01 NOT IN ( ",     #是否有不存在於要檢查的DB裡--表示要檢查的DB裡並沒有ds的檔案,要列出此差異
               "    SELECT zta01 FROM zta_file ",              #取出要與ds檢查的檔案名稱
               "      WHERE zta02 = '", p_chk_db, "' ",
               "      AND zta03 <> 'AIN' ",
               "      AND (zta07 = 'T' OR ",                   #取出要檢查的DB檔案類型是屬於'T'(Table)的部份
               "          (zta07 = 'S' AND zta17 <> 'ds'))",   #取出要檢查的DB Sysnonmy的部份不屬於Sysnonmy for ds的部份
               "  )"

    PREPARE p_check_schema_diff_notsynfords FROM g_sql
    DECLARE schema_curs_diff_notsynfords CURSOR FOR p_check_schema_diff_notsynfords
 
    FOREACH schema_curs_diff_notsynfords INTO l_zta01
        LET l_table = l_table, l_zta01, ", "
        LET l_cnt = l_cnt + 1
    END FOREACH
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_diff_table","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF
   
   RETURN l_table, l_cnt                                                           
END FUNCTION

#--FUN-A80014 modify start------
FUNCTION p_check_schema_get_diff_virtualdb(p_chk_db, p_finance_db)                                               
   DEFINE p_chk_db        LIKE type_file.chr10  
   DEFINE p_finance_db    LIKE type_file.chr10  
   DEFINE l_zta01         LIKE zta_file.zta01   
   DEFINE l_table         STRING
   DEFINE l_cnt           LIKE type_file.num10
   
   LET l_table = ""
   LET l_cnt = 0

   #--FUN-A80009 modify start------
   CASE g_db_type
       WHEN "IFX"

       WHEN "ORA"
   #--FUN-A80009 modify end--------   
          LET g_sql = "SELECT zta01 FROM zta_file ",
                      "  WHERE zta02 = 'ds' ",           
                      "  AND zta07 = 'T' AND zta03 <> 'AIN' ", 
                      "  AND zta01 NOT IN ( ", 
                      "    SELECT zta01 FROM zta_file ", 
                      "      WHERE zta02 = '", p_chk_db, "' ",
                      "      AND ((zta07 = 'S' AND zta17 = '", p_finance_db, "') ",    #取得虛擬DB Synonym for實體DB的數量
                      "      OR zta07 = 'V') AND zta03 <> 'AIN'",                      #取得虛擬DB View的數量
                      "  )"
    #--FUN-A80009 modify start------
       WHEN "MSV"
          LET g_sql = "SELECT zta01 FROM zta_file ",
                      "  WHERE zta02 = 'ds' ",           
                      "  AND zta07 = 'T' AND zta03 <> 'AIN' ", 
                      "  AND zta01 NOT IN ( ", 
                      "    SELECT zta01 FROM zta_file ", 
                      "      WHERE zta02 = '", p_chk_db, "' ",
                      "      AND zta03 <> 'AIN'",    
                      "  )"
   END CASE
   #--FUN-A80009 modify end--------  

   PREPARE p_check_schema_diff_virtualdb FROM g_sql
   DECLARE schema_curs_diff_virtualdb CURSOR FOR p_check_schema_diff_virtualdb
 
   FOREACH schema_curs_diff_virtualdb INTO l_zta01
       LET l_table = l_table, l_zta01, ", "
       LET l_cnt = l_cnt + 1
   END FOREACH
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_diff_virtualdb","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF
   
   RETURN l_table, l_cnt                                                           
END FUNCTION
#--FUN-A80014 modify end--------

FUNCTION p_check_schema_get_diff_dbtable(p_chk_db)                                               
   DEFINE p_chk_db        LIKE type_file.chr10
   DEFINE l_zta01         LIKE zta_file.zta01   
   DEFINE l_table         STRING
   DEFINE l_cnt           LIKE type_file.num10

   IF p_chk_db IS NOT NULL THEN
      CLOSE DATABASE
      DATABASE p_chk_db
   END IF
   
   LET l_table = ""
   LET l_cnt = 0

   #--FUN-A80009 modify start------
   CASE g_db_type
       WHEN "IFX"

       WHEN "ORA"
   #--FUN-A80009 modify end--------   
          LET g_sql = "SELECT zta01 FROM zta_file ",
                      "  WHERE zta02 = '", p_chk_db, "' ",
                      "  AND zta07 = 'T' AND zta03 <> 'AIN' ",
                      "  AND zta01 NOT IN ( ",
                      "    SELECT LOWER(table_name) FROM user_tables)"
   #--FUN-A80009 modify start------
       WHEN "MSV"
          LET g_sql = "SELECT zta01 FROM zta_file ",
                      "  WHERE zta02 = '", p_chk_db, "' ",
                      "  AND zta07 = 'T' AND zta03 <> 'AIN' ",
                      "  AND zta01 NOT IN ( ",
                      "    SELECT LOWER(name) FROM sys.tables)"
   END CASE
   #--FUN-A80009 modify end--------  

   PREPARE p_check_schema_diff_dbtable FROM g_sql
   DECLARE schema_curs_diff_dbtable CURSOR FOR p_check_schema_diff_dbtable
 
   FOREACH schema_curs_diff_dbtable INTO l_zta01
       LET l_table = l_table, l_zta01, ", "
       LET l_cnt = l_cnt + 1
   END FOREACH
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_diff_dbtable","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF

   CLOSE DATABASE
   DATABASE ds
   
   RETURN l_table, l_cnt                                                           
END FUNCTION

FUNCTION p_check_schema_get_diff_dbsynfords(p_chk_db)                                               
   DEFINE p_chk_db        LIKE type_file.chr10
   DEFINE l_zta01         LIKE zta_file.zta01   
   DEFINE l_table         STRING
   DEFINE l_cnt           LIKE type_file.num10

   IF p_chk_db IS NOT NULL THEN
      CLOSE DATABASE
      DATABASE p_chk_db
   END IF
   
   LET l_table = ""
   LET l_cnt = 0

   #--FUN-A80009 modify start------
   CASE g_db_type
       WHEN "IFX"

       WHEN "ORA"
   #--FUN-A80009 modify end--------   
          LET g_sql = "SELECT zta01 FROM zta_file ",
                      "  WHERE zta02 = '",p_chk_db, "' ",
                      "   AND zta07 = 'S' AND zta17 = 'ds' AND zta03 <> 'AIN' ",
                      "   AND zta01 NOT IN (  ",
                      "    SELECT LOWER(synonym_name) FROM user_synonyms ", 
                      "     WHERE db_link IS NULL AND table_owner = UPPER('ds') ",
                      "   )"
   #--FUN-A80009 modify start------
       WHEN "MSV"
          LET g_sql = "SELECT zta01 FROM zta_file ",
                      "  WHERE zta02 = '",p_chk_db, "' ",
                      "   AND zta07 = 'S' AND zta17 = 'ds' AND zta03 <> 'AIN' ",
                      "   AND zta01 NOT IN (  ",
                      "    SELECT LOWER(name) FROM sys.synonyms ", 
                      "      WHERE base_object_name like '%ds]%'",
                      "   )"
   END CASE
   #--FUN-A80009 modify end--------  

   PREPARE p_check_schema_diff_dbsynfords FROM g_sql
   DECLARE schema_curs_diff_dbsynfords CURSOR FOR p_check_schema_diff_dbsynfords
 
   FOREACH schema_curs_diff_dbsynfords INTO l_zta01
       LET l_table = l_table, l_zta01, ", "
       LET l_cnt = l_cnt + 1
   END FOREACH
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_diff_dbsynfords","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF

   CLOSE DATABASE
   DATABASE ds

   RETURN l_table, l_cnt                                                           
END FUNCTION

FUNCTION p_check_schema_get_diff_dbsynfornotds(p_chk_db)                                               
   DEFINE p_chk_db        LIKE type_file.chr10
   DEFINE l_zta01         LIKE zta_file.zta01   
   DEFINE l_table         STRING
   DEFINE l_cnt           LIKE type_file.num10

   IF p_chk_db IS NOT NULL THEN
      CLOSE DATABASE
      DATABASE p_chk_db
   END IF
   
   LET l_table = ""
   LET l_cnt = 0

   #--FUN-A80009 modify start------
   CASE g_db_type
       WHEN "IFX"

       WHEN "ORA"
   #--FUN-A80009 modify end--------   
          LET g_sql = "SELECT zta01 FROM zta_file ",
                      "  WHERE zta02 = '", p_chk_db, "' ",
                      "   AND zta07 = 'S' AND zta17 <> 'ds' AND zta03 <> 'AIN' ",
                      "   AND zta01 NOT IN (  ",
                      "    SELECT LOWER(synonym_name) FROM user_synonyms ", 
                      "     WHERE db_link IS NULL AND table_owner <> UPPER('ds') ",
                      "   )"
   #--FUN-A80009 modify start------
       WHEN "MSV"
          LET g_sql = "SELECT zta01 FROM zta_file ",
                      "  WHERE zta02 = '", p_chk_db, "' ",
                      "   AND zta07 = 'S' AND zta17 <> 'ds' AND zta03 <> 'AIN' ",
                      "   AND zta01 NOT IN (  ",
                      "    SELECT LOWER(name) FROM sys.synonyms ", 
                      "      WHERE base_object_name NOT LIKE '%ds]%'",
                      "   )"
   END CASE
   #--FUN-A80009 modify end--------  

   PREPARE p_check_schema_diff_dbsynfornotds FROM g_sql
   DECLARE schema_curs_diff_dbsynfornotds CURSOR FOR p_check_schema_diff_dbsynfornotds
 
   FOREACH schema_curs_diff_dbsynfornotds INTO l_zta01
       LET l_table = l_table, l_zta01, ", "
       LET l_cnt = l_cnt + 1
   END FOREACH
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_diff_dbsynfornotds","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF

   CLOSE DATABASE
   DATABASE ds

   RETURN l_table, l_cnt                                                           
END FUNCTION

FUNCTION p_check_schema_get_diff_dbsynforentity(p_chk_db, p_finance_db)                                               
   DEFINE p_chk_db        LIKE type_file.chr10  
   DEFINE p_finance_db    LIKE type_file.chr10  
   DEFINE l_zta01         LIKE zta_file.zta01   
   DEFINE l_table         STRING
   DEFINE l_cnt           LIKE type_file.num10

   IF p_chk_db IS NOT NULL THEN
      CLOSE DATABASE
      DATABASE p_chk_db
   END IF
   
   LET l_table = ""
   LET l_cnt = 0

   #--FUN-A80009 modify start------
   CASE g_db_type
       WHEN "IFX"

       WHEN "ORA"
   #--FUN-A80009 modify end--------   
          LET g_sql = "SELECT zta01 FROM zta_file ", 
                      " WHERE zta02 = '", p_chk_db, "' AND zta07 = 'S' ", 
                      " AND zta17 = '", p_finance_db, "' AND zta03 <> 'AIN' ", 
                      " AND zta01 NOT IN ( ", 
                      "  SELECT LOWER(synonym_name) FROM user_synonyms ", 
                      "   WHERE db_link IS NULL AND table_owner = UPPER('", p_finance_db, "') ", 
                      " )"
   #--FUN-A80009 modify start------
       WHEN "MSV"
          LET g_sql = "SELECT zta01 FROM zta_file ", 
                      " WHERE zta02 = '", p_chk_db, "' AND zta07 = 'S' ", 
                      " AND zta17 = '", p_finance_db, "' AND zta03 <> 'AIN' ", 
                      " AND zta01 NOT IN ( ", 
                      "  SELECT LOWER(name) FROM sys.synonyms ", 
                      "   WHERE base_object_name LIKE '%", p_finance_db, "]%' ", 
                      "   OR base_object_name LIKE '%ds]%' ", 
                      " )"
   END CASE
   #--FUN-A80009 modify end--------  

   PREPARE p_check_schema_diff_dbsynforentity FROM g_sql
   DECLARE schema_curs_diff_dbsynforentity CURSOR FOR p_check_schema_diff_dbsynforentity
 
   FOREACH schema_curs_diff_dbsynforentity INTO l_zta01
       LET l_table = l_table, l_zta01, ", "
       LET l_cnt = l_cnt + 1
   END FOREACH
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_diff_dbsynforentity","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF

   CLOSE DATABASE
   DATABASE ds

   RETURN l_table, l_cnt                                                           
END FUNCTION

FUNCTION p_check_schema_get_diff_dbview(p_chk_db)                                               
   DEFINE p_chk_db        LIKE type_file.chr10
   DEFINE l_zta01         LIKE zta_file.zta01   
   DEFINE l_table         STRING
   DEFINE l_cnt           LIKE type_file.num10

   IF p_chk_db IS NOT NULL THEN
      CLOSE DATABASE
      DATABASE p_chk_db
   END IF
   
   LET l_table = ""
   LET l_cnt = 0

   #--FUN-A80009 modify start------
   CASE g_db_type
       WHEN "IFX"

       WHEN "ORA"
   #--FUN-A80009 modify end--------   
          LET g_sql = "SELECT zta01 FROM zta_file ",
                      "  WHERE zta02 = '", p_chk_db, "' ", 
                      "  AND zta07 = 'V' AND zta03 <> 'AIN' ", 
                      "  AND zta01 NOT IN ( ",
                      "   SELECT LOWER(view_name) FROM user_views)"
   #--FUN-A80009 modify start------
       WHEN "MSV"
          LET g_sql = "SELECT zta01 FROM zta_file ",
                      "  WHERE zta02 = '", p_chk_db, "' ", 
                      "  AND zta07 = 'V' AND zta03 <> 'AIN' ", 
                      "  AND zta01 NOT IN ( ",
                      "   SELECT LOWER(name) FROM sys.views)"
   END CASE
   #--FUN-A80009 modify end--------  
       
   PREPARE p_check_schema_diff_dbview FROM g_sql
   DECLARE schema_curs_diff_dbview CURSOR FOR p_check_schema_diff_dbview
 
   FOREACH schema_curs_diff_dbview INTO l_zta01
       LET l_table = l_table, l_zta01, ", "
       LET l_cnt = l_cnt + 1
   END FOREACH
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_diff_dbview","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF

   CLOSE DATABASE
   DATABASE ds

   RETURN l_table, l_cnt                                                           
END FUNCTION

FUNCTION p_check_schema_get_diff_ods_dbsynfords(p_chk_db)                                               
   DEFINE p_chk_db        LIKE type_file.chr10
   DEFINE l_zta01         LIKE zta_file.zta01   
   DEFINE l_table         STRING
   DEFINE l_cnt           LIKE type_file.num10

   IF p_chk_db IS NOT NULL THEN
      CLOSE DATABASE
      DATABASE ods
   END IF
 
   LET l_table = ""
   LET l_cnt = 0

   #--FUN-A80009 modify start------
   CASE g_db_type
       WHEN "IFX"

       WHEN "ORA"
   #--FUN-A80009 modify end--------   
          LET g_sql = "SELECT zta01 FROM zta_file ",
                      "  WHERE zta02 = '", p_chk_db, "' ",
                      "   AND zta07 = 'T' AND zta09 = 'Z' AND zta03 <> 'AIN' ",
                      "   AND zta01 NOT IN (  ",
                      "    SELECT LOWER(synonym_name) FROM user_synonyms ", 
                      "     WHERE db_link IS NULL AND table_owner = UPPER('ds') ",
                      "   )"
   #--FUN-A80009 modify start------
       WHEN "MSV"
          LET g_sql = "SELECT zta01 FROM zta_file ",
                      "  WHERE zta02 = '", p_chk_db, "' ",
                      "   AND zta07 = 'T' AND zta09 = 'Z' AND zta03 <> 'AIN' ",
                      "   AND zta01 NOT IN (  ",
                      "    SELECT LOWER(name) FROM sys.synonyms ", 
                      "     WHERE base_object_name LIKE '%ds]%' ",
                      "   )"
   END CASE
   #--FUN-A80009 modify end--------  
 
   PREPARE p_check_schema_diff_ods_dbsynfords FROM g_sql
   DECLARE schema_curs_diff_ods_dbsynfords CURSOR FOR p_check_schema_diff_ods_dbsynfords
 
   FOREACH schema_curs_diff_ods_dbsynfords INTO l_zta01
       LET l_table = l_table, l_zta01, ", "
       LET l_cnt = l_cnt + 1
   END FOREACH
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_diff_ods_dbsynfords","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF

   CLOSE DATABASE
   DATABASE ds

   RETURN l_table, l_cnt                                                           
END FUNCTION

FUNCTION p_check_schema_get_diff_ods_dbview(p_chk_db)                                               
   DEFINE p_chk_db        LIKE type_file.chr10
   DEFINE l_zta01         LIKE zta_file.zta01   
   DEFINE l_table         STRING
   DEFINE l_cnt           LIKE type_file.num10

   IF p_chk_db IS NOT NULL THEN
      CLOSE DATABASE
      DATABASE ods
   END IF
   
   LET l_table = ""
   LET l_cnt = 0

   #--FUN-A80009 modify start------
   CASE g_db_type
       WHEN "IFX"

       WHEN "ORA"
   #--FUN-A80009 modify end--------   
          LET g_sql = "SELECT zta01 FROM zta_file ",
                      "  WHERE zta02 = '", p_chk_db, "' AND zta07 = 'T' ", 
                      "   AND zta09 <> 'Z' AND zta03 <> 'AIN' ",
                      "   AND zta01 NOT IN ( ",
                      "    SELECT LOWER(view_name) FROM user_views) "
   #--FUN-A80009 modify start------
       WHEN "MSV"
          LET g_sql = "SELECT zta01 FROM zta_file ",
                      "  WHERE zta02 = '", p_chk_db, "' AND zta07 = 'T' ", 
                      "   AND zta09 <> 'Z' AND zta03 <> 'AIN' ",
                      "   AND zta01 NOT IN ( ",
                      "    SELECT LOWER(name) FROM sys.views) "
   END CASE
   #--FUN-A80009 modify end--------  
       
   PREPARE p_check_schema_diff_ods_dbview FROM g_sql
   DECLARE schema_curs_diff_ods_dbview CURSOR FOR p_check_schema_diff_ods_dbview
 
   FOREACH schema_curs_diff_ods_dbview INTO l_zta01
       LET l_table = l_table, l_zta01, ", "
       LET l_cnt = l_cnt + 1
   END FOREACH
                                                                                                 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("get_diff_ods_dbview","zta_file",p_chk_db,"",SQLCA.sqlcode,"","",1) 
   END IF

   CLOSE DATABASE
   DATABASE ds

   RETURN l_table, l_cnt                                                           
END FUNCTION


FUNCTION p_check_schema_get_zta_diff()         
   DEFINE l_length    LIKE type_file.num10 
   DEFINE l_i         LIKE type_file.num10 
   DEFINE l_return    STRING
   DEFINE l_str       STRING 
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_j         LIKE type_file.num10 
   DEFINE l_msg       STRING
   DEFINE l_isdiff    LIKE type_file.chr1

   LET l_return = ""
   LET l_str = ""
   LET l_cnt = 0
   LET l_j = 1
   LET l_length = g_zta_schema.getlength()

   IF l_length = 0 THEN
      CALL cl_err('','azz1059',1)
      RETURN 0
   END IF
   
   FOR l_i = 1 TO l_length
       #處理非ods的資料
       IF g_zta_schema[l_i].sch01 <> "ds" THEN
          #表示此schema為實體DB
          IF g_zta_schema[l_i].sch02 = 'Y' THEN 
             LET l_isdiff = 'N'
             LET g_zta_diff[l_j].diff01 = g_zta_schema[l_i].sch01
             
             #檢查是否有'ds'的檔案類型屬於'Z'(系統檔)的Table資料並沒有存在在要檢查的DB中
             CALL p_check_schema_get_diff_synfords(g_zta_schema[l_i].sch01) RETURNING l_return, l_cnt
             CALL cl_getmsg('azz1050',g_lang) RETURNING l_msg       #"Synonym for ds少了 "
             LET g_zta_diff[l_j].diff02 = l_msg
             LET g_zta_diff[l_j].diff03 = l_cnt
             IF NOT cl_null(l_return) THEN
                LET l_return = l_return.subString(1, l_return.getLength() - 2) 
                LET g_zta_diff[l_j].diff04 = l_return
                LET l_isdiff = 'Y'
             ELSE
                CALL cl_getmsg('azz1049',g_lang) RETURNING l_msg       #"無差異" 
                LET g_zta_diff[l_j].diff04 = l_msg
             END IF

             IF l_isdiff = 'Y' THEN
                LET l_j = l_j + 1
             END IF

             #檢查是否有'ds'的排除了檔案類型屬於'Z'(系統檔)的Table資料並沒有存在在要檢查的DB中
             CALL p_check_schema_get_diff_notsynfords(g_zta_schema[l_i].sch01) RETURNING l_return, l_cnt
             CALL cl_getmsg('azz1051',g_lang) RETURNING l_msg       #"除了Synonym for ds以外,其它Table少了 "
             LET g_zta_diff[l_j].diff02 = l_msg
             LET g_zta_diff[l_j].diff03 = l_cnt
             IF NOT cl_null(l_return) THEN
                LET l_return = l_return.subString(1, l_return.getLength() - 2)
                LET g_zta_diff[l_j].diff04 = l_return
                LET l_isdiff = 'Y'
             ELSE
                IF l_isdiff = 'Y' THEN
                   LET l_j = l_j - 1
                END IF
                #CALL cl_getmsg('azz1049',g_lang) RETURNING l_msg       #"無差異" 
                #LET g_zta_diff[l_j].diff04 = l_msg
             END IF

             IF l_isdiff = 'Y' THEN
                LET l_j = l_j + 1
             ELSE
                LET g_zta_diff[l_j].diff02 = ' '
                LET g_zta_diff[l_j].diff03 = ' '   
                LET l_j = l_j + 1
             END IF
          #--FUN-A80014 modify start------   
          #表示此schema為虛擬DB
          ELSE
             LET l_isdiff = 'N'
             LET g_zta_diff[l_j].diff01 = g_zta_schema[l_i].sch01

             IF g_zta_schema[l_i].sch01 <> "ods" THEN
                #檢查是否有'ds'的所有檔案Table資料並沒有存在在要檢查的虛擬DB中
                CALL p_check_schema_get_diff_virtualdb(g_zta_schema[l_i].sch01, g_zta_schema[l_i].sch03) RETURNING l_return, l_cnt
                CALL cl_getmsg('azz1051',g_lang) RETURNING l_msg       #"其他資料少了 "
                LET g_zta_diff[l_j].diff02 = l_msg
                LET g_zta_diff[l_j].diff03 = l_cnt

                IF NOT cl_null(l_return) THEN
                   LET l_return = l_return.subString(1, l_return.getLength() - 2)
                   LET g_zta_diff[l_j].diff04 = l_return
                   LET l_isdiff = 'Y'
                ELSE
                   CALL cl_getmsg('azz1049',g_lang) RETURNING l_msg       #"無差異" 
                   LET g_zta_diff[l_j].diff04 = l_msg
                END IF

                IF l_isdiff = 'Y' THEN
                   LET l_j = l_j + 1
                ELSE
                   LET g_zta_diff[l_j].diff02 = ' '
                   LET g_zta_diff[l_j].diff03 = ' '   
                   LET l_j = l_j + 1
                END IF
             ELSE     #ods在zta_file中是直接取ds資料,所以直接顯示與zta_file中的ds比較無差異即可
                CALL cl_getmsg('azz1049',g_lang) RETURNING l_msg       #"無差異" 
                LET g_zta_diff[l_j].diff04 = l_msg
                LET l_j = l_j + 1
             END IF
          #--FUN-A80014 modify end--------
          END IF
       END IF
   END FOR

   RETURN l_j - 1                                                          
END FUNCTION  

FUNCTION p_check_schema_get_db_diff()            
   DEFINE l_length    LIKE type_file.num10 
   DEFINE l_i         LIKE type_file.num10 
   DEFINE l_return    STRING
   DEFINE l_str       STRING 
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_j         LIKE type_file.num10 
   DEFINE l_msg       STRING
   DEFINE l_isdiff    LIKE type_file.chr1

   LET l_return = ""
   LET l_str = ""
   LET l_cnt = 0
   LET l_j = 1
   LET l_length = g_zta_schema.getlength()

   IF l_length = 0 THEN
      CALL cl_err('','azz1059',1)
      RETURN 0
   END IF

   #處理非ods的資料
   FOR l_i = 1 TO l_length
       LET l_isdiff = 'N'
       LET g_db_diff[l_j].db01 = g_zta_schema[l_i].sch01
       
       #ds只要判斷Table的資料即可       
       IF g_zta_schema[l_i].sch01 = "ds" THEN
          #比較'ds'的Table資料與實際DB中之差異
          CALL p_check_schema_get_diff_dbtable(g_zta_schema[l_i].sch01) RETURNING l_return, l_cnt
          CALL cl_getmsg('azz1052',g_lang) RETURNING l_msg       #"與實際DB檢查,Table少了 "
          LET g_db_diff[l_j].db02 = l_msg
          LET g_db_diff[l_j].db03 = l_cnt
          IF NOT cl_null(l_return) THEN
             LET l_return = l_return.subString(1, l_return.getLength() - 2) 
             LET g_db_diff[l_j].db04 = l_return
             LET l_isdiff = 'Y'
          ELSE
             CALL cl_getmsg('azz1049',g_lang) RETURNING l_msg       #"無差異" 
             LET g_db_diff[l_j].db04 = l_msg
          END IF

          IF l_isdiff = 'Y' THEN
             LET l_j = l_j + 1
          ELSE
             LET g_db_diff[l_j].db02 = ' '
             LET g_db_diff[l_j].db03 = ' '   
             LET l_j = l_j + 1
          END IF
       END IF

       #處理非ods的資料
       IF g_zta_schema[l_i].sch01 <> "ods" AND g_zta_schema[l_i].sch01 <> "ds" THEN
          #表示此schema為實體DB
          IF g_zta_schema[l_i].sch02 = 'Y' THEN
             #比較schema的Table資料與實際DB中之差異
             CALL p_check_schema_get_diff_dbtable(g_zta_schema[l_i].sch01) RETURNING l_return, l_cnt
             CALL cl_getmsg('azz1052',g_lang) RETURNING l_msg       #"與實際DB檢查,Table少了 "
             LET g_db_diff[l_j].db02 = l_msg
             LET g_db_diff[l_j].db03 = l_cnt
             IF NOT cl_null(l_return) THEN
                LET l_return = l_return.subString(1, l_return.getLength() - 2) 
                LET g_db_diff[l_j].db04 = l_return
                LET l_isdiff = 'Y'
             ELSE
                CALL cl_getmsg('azz1049',g_lang) RETURNING l_msg       #"無差異" 
                LET g_db_diff[l_j].db04 = l_msg
             END IF

             IF l_isdiff = 'Y' THEN
                LET l_j = l_j + 1
             END IF
              
             #比較schema的Synonym for ds資料與實際DB中之差異
             CALL p_check_schema_get_diff_dbsynfords(g_zta_schema[l_i].sch01) RETURNING l_return, l_cnt
             CALL cl_getmsg('azz1053',g_lang) RETURNING l_msg       #"與實際DB檢查,Synonym for ds少了 "
             LET g_db_diff[l_j].db02 = l_msg
             LET g_db_diff[l_j].db03 = l_cnt
             IF NOT cl_null(l_return) THEN
                LET l_return = l_return.subString(1, l_return.getLength() - 2) 
                LET g_db_diff[l_j].db04 = l_return
                LET l_isdiff = 'Y'
             ELSE
                IF l_isdiff = 'Y' THEN
                   LET l_j = l_j - 1
                END IF
                #CALL cl_getmsg('azz1049',g_lang) RETURNING l_msg       #"無差異" 
                #LET g_db_diff[l_j].db04 = l_msg
             END IF
             
             IF l_isdiff = 'Y' THEN
                LET l_j = l_j + 1
             END IF
              
             #比較schema的Synonym for 非ds資料與實際DB中之差異
             CALL p_check_schema_get_diff_dbsynfornotds(g_zta_schema[l_i].sch01) RETURNING l_return, l_cnt
             CALL cl_getmsg('azz1054',g_lang) RETURNING l_msg       #"與實際DB檢查,Synonym for 非ds少了 "
             LET g_db_diff[l_j].db02 = l_msg
             LET g_db_diff[l_j].db03 = l_cnt
             IF NOT cl_null(l_return) THEN
                LET l_return = l_return.subString(1, l_return.getLength() - 2) 
                LET g_db_diff[l_j].db04 = l_return
                LET l_isdiff = 'Y'
             ELSE
                IF l_isdiff = 'Y' THEN
                   LET l_j = l_j - 1
                END IF
                #CALL cl_getmsg('azz1049',g_lang) RETURNING l_msg       #"無差異" 
                #LET g_db_diff[l_j].db04 = l_msg
             END IF

             IF l_isdiff = 'Y' THEN
                LET l_j = l_j + 1
             ELSE
                LET g_db_diff[l_j].db02 = ' '
                LET g_db_diff[l_j].db03 = ' '   
                LET l_j = l_j + 1
             END IF
              
          #表示此schema為虛擬DB
          ELSE
             #比較schema的Synonym for 實體DB資料與實際DB中之差異
             CALL p_check_schema_get_diff_dbsynforentity(g_zta_schema[l_i].sch01, g_zta_schema[l_i].sch03) RETURNING l_return, l_cnt
             CALL cl_getmsg('azz1055',g_lang) RETURNING l_msg       #"與實際DB檢查,Synonym for 實體DB少了 "
             LET g_db_diff[l_j].db02 = l_msg
             LET g_db_diff[l_j].db03 = l_cnt
             IF NOT cl_null(l_return) THEN
                LET l_return = l_return.subString(1, l_return.getLength() - 2) 
                LET g_db_diff[l_j].db04 = l_return
                LET l_isdiff = 'Y'
             ELSE
                CALL cl_getmsg('azz1049',g_lang) RETURNING l_msg       #"無差異" 
                LET g_db_diff[l_j].db04 = l_msg
             END IF

             IF l_isdiff = 'Y' THEN
                LET l_j = l_j + 1
             END IF
             
             #比較schema的view資料與實際DB中之差異
             CALL p_check_schema_get_diff_dbview(g_zta_schema[l_i].sch01) RETURNING l_return, l_cnt
             CALL cl_getmsg('azz1056',g_lang) RETURNING l_msg       #"與實際DB檢查,view少了 "
             LET g_db_diff[l_j].db02 = l_msg
             LET g_db_diff[l_j].db03 = l_cnt
             IF NOT cl_null(l_return) THEN
                LET l_return = l_return.subString(1, l_return.getLength() - 2) 
                LET g_db_diff[l_j].db04 = l_return
                LET l_isdiff = 'Y'
             ELSE
                IF l_isdiff = 'Y' THEN
                   LET l_j = l_j - 1
                END IF
                #CALL cl_getmsg('azz1049',g_lang) RETURNING l_msg       #"無差異" 
                #LET g_db_diff[l_j].db04 = l_msg
             END IF

             IF l_isdiff = 'Y' THEN
                LET l_j = l_j + 1
             ELSE
                LET g_db_diff[l_j].db02 = ' '
                LET g_db_diff[l_j].db03 = ' '   
                LET l_j = l_j + 1
             END IF
          END IF
       END IF
    END FOR
    
        
    #處理ods的資料
    IF g_zta_schema[l_length].sch01 = "ods" THEN
       LET g_db_diff[l_j].db01 = g_zta_schema[l_length].sch01
       
       #比較ods的Synonym for ds資料與實際DB中之差異
       CALL p_check_schema_get_diff_ods_dbsynfords('ds') RETURNING l_return, l_cnt
       CALL cl_getmsg('azz1053',g_lang) RETURNING l_msg       #"與實際DB檢查,Synonym for ds少了 "
       LET g_db_diff[l_j].db02 = l_msg
       LET g_db_diff[l_j].db03 = l_cnt
       IF NOT cl_null(l_return) THEN
          LET l_return = l_return.subString(1, l_return.getLength() - 2) 
          LET g_db_diff[l_j].db04 = l_return
          LET l_isdiff = 'Y'
       ELSE
          CALL cl_getmsg('azz1049',g_lang) RETURNING l_msg       #"無差異" 
          LET g_db_diff[l_j].db04 = l_msg
       END IF

       IF l_isdiff = 'Y' THEN
          LET l_j = l_j + 1
       END IF
             
       #比較ods的view資料與實際DB中之差異
       CALL p_check_schema_get_diff_ods_dbview('ds') RETURNING l_return, l_cnt
       CALL cl_getmsg('azz1056',g_lang) RETURNING l_msg       #"與實際DB檢查,view少了 "
       LET g_db_diff[l_j].db02 = l_msg
       LET g_db_diff[l_j].db03 = l_cnt
       IF NOT cl_null(l_return) THEN
          LET l_return = l_return.subString(1, l_return.getLength() - 2) 
          LET g_db_diff[l_j].db04 = l_return
          LET l_isdiff = 'Y'
       ELSE
          IF l_isdiff = 'Y' THEN
             LET l_j = l_j - 1
          END IF
          CALL cl_getmsg('azz1049',g_lang) RETURNING l_msg       #"無差異" 
          LET g_db_diff[l_j].db04 = l_msg
       END IF

       IF l_isdiff = 'Y' THEN
          LET l_j = l_j + 1
       ELSE
          LET g_db_diff[l_j].db02 = ' '
          LET g_db_diff[l_j].db03 = ' '   
          LET l_j = l_j + 1
       END IF
    END IF

   RETURN l_j - 1                                                          
END FUNCTION  

FUNCTION p_check_schema_out()
DEFINE l_i         LIKE type_file.num5,    
       l_name      LIKE type_file.chr20,      #External(Disk) file name VARCHAR(20)
       sr          RECORD
          sr01     LIKE type_file.chr50,      #差異表名稱
          sr02     LIKE type_file.chr10,      #檢查DB
          sr03     LIKE type_file.chr50,      #檢查差異類型
          sr04     LIKE type_file.num10,      #差異個數
          sr05     STRING                     #差異檔案名稱
                   END RECORD 
DEFINE l_length    LIKE type_file.num10 
 
    CALL cl_wait()
 
    CALL cl_outnam('p_check_schema') RETURNING l_name
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    START REPORT p_check_schema_rep TO l_name

    #列印zta_file差異表
    LET l_length = g_zta_diff.getlength()
    LET sr.sr01 = "zta_file"
    FOR l_i = 1 TO l_length
        LET sr.sr02 = g_zta_diff[l_i].diff01 CLIPPED
        LET sr.sr03 = g_zta_diff[l_i].diff02 CLIPPED
        LET sr.sr04 = g_zta_diff[l_i].diff03 CLIPPED
        LET sr.sr05 = g_zta_diff[l_i].diff04 CLIPPED
        OUTPUT TO REPORT p_check_schema_rep(sr.*)
        LET sr.sr01 = ""
    END FOR

    #列印三行空白
    FOR l_i = 1 TO 3
        LET sr.sr01 = ""
        LET sr.sr02 = ""
        LET sr.sr03 = ""
        LET sr.sr04 = ""
        LET sr.sr05 = ""
        OUTPUT TO REPORT p_check_schema_rep(sr.*)
    END FOR

    #列印與實際DB差異表
    LET l_length = g_db_diff.getlength()
    LET sr.sr01 = "DB"
    FOR l_i = 1 TO l_length
        LET sr.sr02 = g_db_diff[l_i].db01 CLIPPED
        LET sr.sr03 = g_db_diff[l_i].db02 CLIPPED
        LET sr.sr04 = g_db_diff[l_i].db03 CLIPPED
        LET sr.sr05 = g_db_diff[l_i].db04 CLIPPED
        OUTPUT TO REPORT p_check_schema_rep(sr.*)
        LET sr.sr01 = ""
    END FOR
 
    FINISH REPORT p_check_schema_rep
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT p_check_schema_rep(sr)
DEFINE
    l_trailer_sw   LIKE type_file.chr1,       #VARCHAR(1)
    sr             RECORD
        sr01       LIKE type_file.chr50,      #差異表名稱
        sr02       LIKE type_file.chr10,      #檢查DB
        sr03       LIKE type_file.chr50,      #檢查差異類型
        sr04       LIKE type_file.num10,      #差異個數
        sr05       STRING                     #差異檔案名稱
                   END RECORD 
                   
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,g_x[35] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.sr01,
                  COLUMN g_c[32],sr.sr02,
                  COLUMN g_c[33],sr.sr03,
                  COLUMN g_c[34],sr.sr04,
                  COLUMN g_c[35],sr.sr05
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-29), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-29), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT

FUNCTION p_check_schema_export_to_excel()
DEFINE l_i         LIKE type_file.num5,
       l_cnt       LIKE type_file.num5,    
       l_name      LIKE type_file.chr20,      #External(Disk) file name VARCHAR(20)
       sr          DYNAMIC ARRAY OF RECORD
          sr01     LIKE type_file.chr100,      #檢查DB
          sr02     LIKE type_file.chr100,      #檢查差異類型
          sr03     LIKE type_file.num10,      #差異個數
          sr04     STRING                     #差異檔案名稱
                   END RECORD 
DEFINE l_length    LIKE type_file.num10 
DEFINE l_msg       STRING

DEFINE w           ui.Window                      
DEFINE n           om.DomNode 

    LET l_cnt = 0
    
    #列印zta_file差異表
    CALL sr.appendElement()
    LET l_cnt = l_cnt + 1
    CALL cl_getmsg('azz1057',g_lang) RETURNING l_msg       #"各DB之間的zta_file差異表" 
    LET sr[l_cnt].sr01 = l_msg CLIPPED
        
    LET l_length = g_zta_diff.getlength()
    FOR l_i = 1 TO l_length
        CALL sr.appendElement()
        LET l_cnt = l_cnt + 1
        LET sr[l_cnt].sr01 = g_zta_diff[l_i].diff01 CLIPPED
        LET sr[l_cnt].sr02 = g_zta_diff[l_i].diff02 CLIPPED
        LET sr[l_cnt].sr03 = g_zta_diff[l_i].diff03 CLIPPED
        LET sr[l_cnt].sr04 = g_zta_diff[l_i].diff04 CLIPPED
    END FOR

    #列印三行空白
    FOR l_i = 1 TO 3
        CALL sr.appendElement()
        LET l_cnt = l_cnt + 1
        LET sr[l_cnt].sr01 = ""
        LET sr[l_cnt].sr02 = ""
        LET sr[l_cnt].sr03 = ""
        LET sr[l_cnt].sr04 = ""
    END FOR

    #列印與實際DB差異表
    CALL sr.appendElement()
    LET l_cnt = l_cnt + 1
    CALL cl_getmsg('azz1058',g_lang) RETURNING l_msg       #"各DB之間與實際DB缺少明細差異表" 
    LET sr[l_cnt].sr01 = l_msg CLIPPED
    
    LET l_length = g_db_diff.getlength()
    FOR l_i = 1 TO l_length
        CALL sr.appendElement()
        LET l_cnt = l_cnt + 1
        LET sr[l_cnt].sr01 = g_db_diff[l_i].db01 CLIPPED
        LET sr[l_cnt].sr02 = g_db_diff[l_i].db02 CLIPPED
        LET sr[l_cnt].sr03 = g_db_diff[l_i].db03 CLIPPED
        LET sr[l_cnt].sr04 = g_db_diff[l_i].db04 CLIPPED
    END FOR

    LET w = ui.Window.getCurrent()
    LET n = w.findNode("Table","s_db_diff")

    CALL cl_export_to_excel(n,base.TypeInfo.create(sr),'','')
END FUNCTION
