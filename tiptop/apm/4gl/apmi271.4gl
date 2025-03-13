# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: apmi271.4gl
# Descriptions...: 料件特賣數量折扣維護作業
# Date & Author..: No.FUN-930137 09/03/23 By Cockroach 采購取價與定價
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.           09/10/20 By lilingyu r.c2錯誤
# Modify.........: No.FUN-AA0059 10/10/25 By huangtao 修改料號的管控`
# Modify.........: No.FUN-910088 11/11/28 By chenjing  增加數量欄位小數取位
# Modify.........: No.FUN-C20048 12/02/09 By chenjing  增加數量欄位小數取位
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   g_pof           RECORD LIKE pof_file.*,
   g_pof_t         RECORD LIKE pof_file.*,
   g_pof_o         RECORD LIKE pof_file.*,
   g_pof01_t       LIKE pof_file.pof01,
   g_pof02_t       LIKE pof_file.pof02,
   g_pof03_t       LIKE pof_file.pof03,
   g_pof04_t       LIKE pof_file.pof04,
   g_pof05_t       LIKE pof_file.pof05,
   g_poh           DYNAMIC ARRAY OF RECORD
       poh06       LIKE poh_file.poh06,
       ima02       LIKE ima_file.ima02,
       ima021      LIKE ima_file.ima021,
       poh07       LIKE poh_file.poh07,
       poh08       LIKE poh_file.poh08, 
       poh09       LIKE poh_file.poh09
                   END RECORD,
   g_poh_t         RECORD                 #程式變數 (舊值)
       poh06       LIKE poh_file.poh06,
       ima02       LIKE ima_file.ima02,
       ima021      LIKE ima_file.ima021,
       poh07       LIKE poh_file.poh07,
       poh08       LIKE poh_file.poh08, 
       poh09       LIKE poh_file.poh09
                   END RECORD,
   g_poh_o         RECORD                 #程式變數 (舊值)
       poh06       LIKE poh_file.poh06,
       ima02       LIKE ima_file.ima02,
       ima021      LIKE ima_file.ima021,
       poh07       LIKE poh_file.poh07,
       poh08       LIKE poh_file.poh08, 
       poh09       LIKE poh_file.poh09
                   END RECORD,                   
   g_wc,g_wc2,g_sql    STRING,    
   g_rec_b         LIKE type_file.num5,              #單身筆數   
   l_ac            LIKE type_file.num5,              #目前處理的ARRAY CNT  
   p_row,p_col     LIKE type_file.num5               
DEFINE   g_before_input_done LIKE type_file.num5     
 
#主程式開始
DEFINE   g_chr           LIKE type_file.chr1        
DEFINE   g_cnt           LIKE type_file.num10       
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose 
DEFINE   g_msg           LIKE type_file.chr1000      
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL    
DEFINE g_sql_tmp    STRING  
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10     
DEFINE   g_jump         LIKE type_file.num10     
DEFINE   mi_no_ask      LIKE type_file.num5        
DEFINE   l_table        STRING                                                                                
DEFINE   l_sql          STRING                                                                               
DEFINE   g_str          STRING                    
DEFINE   g_check        LIKE type_file.chr1
DEFINE   g_check1       LIKE type_file.chr1
DEFINE   g_check2       LIKE type_file.chr1
DEFINE   g_poh07_t      LIKE poh_file.poh07   #FUN-910088-add--
MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5  
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time    

    LET g_forupd_sql = "SELECT * FROM pof_file WHERE pof01 = ? AND pof02 = ? ",  #091020
                         " AND pof03 = ? AND pof04 = ? AND pof05 = ? FOR UPDATE"   #091020 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i271_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW i271_w WITH FORM "apm/42f/apmi271"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    CALL i271_menu()
    CLOSE WINDOW i271_w                 #結束畫面
 
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
#QBE 查詢資料
FUNCTION i271_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01   
  CLEAR FORM                             #清除畫面
  CALL g_poh.clear()
  CALL cl_set_head_visible("","YES")    
 
   INITIALIZE g_pof.* TO NULL   
  CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
         pof01,pof02,pof03,pof06,pof04,pof05,
         pof08,pof09,pof07,
         pofuser,pofgrup,pofmodu,pofdate
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(pof01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pof01"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pof01
                     NEXT FIELD pof01
              WHEN INFIELD(pof02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pof02"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pof02
                     NEXT FIELD pof02
              WHEN INFIELD(pof04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pof04"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pof04
                     NEXT FIELD pof04
              WHEN INFIELD(pof05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pof05"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pof05
                     NEXT FIELD pof05
              WHEN INFIELD(pof08)
                      CALL cl_init_qry_var()                                                                                         
                     LET g_qryparam.form = "q_pof08"                                                                                
                     LET g_qryparam.state = 'c'                                                                                     
                     CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
                     DISPLAY g_qryparam.multiret TO pof08                                                                           
                     NEXT FIELD pof08     
              OTHERWISE EXIT CASE
            END CASE
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        END CONSTRUCT
        IF INT_FLAG THEN RETURN END IF
 
  #資料權限的檢查
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                           #只能使用自己的資料
  #     LET g_wc = g_wc clipped," AND pofuser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND pofgrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #群組權限
  #     LET g_wc = g_wc clipped," AND pofgrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pofuser', 'pofgrup')
  #End:FUN-980030
 
 
    CONSTRUCT g_wc2 ON poh06,poh07,poh08,poh09   #螢幕上取單身條件
            FROM s_poh[1].poh06,s_poh[1].poh07,s_poh[1].poh08,
                 s_poh[1].poh09
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(poh06) #料件編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_poh06"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO poh06
                  NEXT FIELD poh06
               WHEN INFIELD(poh07) #單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_poh07"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO poh07
                  NEXT FIELD poh07
               OTHERWISE EXIT CASE
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about       
         CALL cl_about()  
 
      ON ACTION help         
         CALL cl_show_help() 
 
      ON ACTION controlg   
         CALL cl_cmdask()    
 
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
        LET g_sql = "SELECT pof01,pof02,pof03,pof04,pof05  ",  #091020
                   " FROM pof_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY pof01,pof02,pof03,pof04,pof05"  #091020 
    ELSE					# 若單身有輸入條件
        LET g_sql = "SELECT pof01,pof02,pof03,pof04,",  #091020
                   " pof05 ",
                   " FROM pof_file, poh_file ",
                   " WHERE pof01 = poh01 AND pof02=poh02 AND pof03=poh03 ",
                   " AND poh04=pof04 AND poh05=pof05 ",
                   " AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                    " ORDER BY pof01,pof02,pof03,pof04,pof05"   #091020
    END IF
 
    PREPARE i271_prepare FROM g_sql
    DECLARE i271_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i271_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql_tmp="SELECT DISTINCT pof01,pof02,pof03,pof04,pof05 FROM pof_file WHERE ",g_wc CLIPPED,
                     "  INTO TEMP x "  
    ELSE
       LET g_sql_tmp="SELECT DISTINCT pof01,pof02,pof03,pof04,pof05 ",  
                 "  FROM pof_file,poh_file ",
                 " WHERE poh01=pof01 AND poh02=pof02 AND poh03=pof03 ",
                 "   AND poh04=pof04 AND poh05=pof05 ",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 "  INTO TEMP x "
    END IF
    #因主鍵值有多個故所抓出資料筆數有誤
    DROP TABLE x
    PREPARE i271_precount_x  FROM g_sql_tmp 
    EXECUTE i271_precount_x
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i271_precount FROM g_sql
    DECLARE i271_count CURSOR FOR i271_precount
END FUNCTION
 
FUNCTION i271_menu()
 
   WHILE TRUE
      CALL i271_bp("G")
      CASE g_action_choice
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i271_q()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i271_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i271_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_poh),'','')
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
                 IF g_pof.pof01 IS NOT NULL THEN            
                    LET g_doc.column1 = "pof01"               
                    LET g_doc.column2 = "pof02" 
                    LET g_doc.column3 = "pof03"
                    LET g_doc.column4 = "pof04"  
                    LET g_doc.column5 = "pof05"
                    LET g_doc.value1 = g_pof.pof01            
                    LET g_doc.value2 = g_pof.pof02
                    LET g_doc.value3 = g_pof.pof03
                    LET g_doc.value4 = g_pof.pof04
                    LET g_doc.value5 = g_pof.pof05
                    CALL cl_doc() 
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION
 
 
#
FUNCTION i271_pof01(p_cmd)  #價格條件
    DEFINE
           l_pnz02   LIKE pnz_file.pnz02,
           p_cmd     LIKE type_file.chr1   
 
    IF g_pof.pof01 IS NULL THEN
       LET l_pnz02=NULL
    ELSE
       SELECT pnz02 INTO l_pnz02 FROM pnz_file
        WHERE pnz01=g_pof.pof01 AND pnz03 = '9'
        IF SQLCA.sqlcode THEN
            LET l_pnz02 = NULL
        END IF
    END IF
    IF p_cmd = 'd' THEN
       DISPLAY l_pnz02 TO FORMONLY.pnz02
    END IF
END FUNCTION
 
FUNCTION i271_pof02(p_cmd)                                                                                                
    DEFINE                                                                                                                          
           l_azi02   LIKE azi_file.azi02,                                                                                           
           p_cmd     LIKE type_file.chr1                                                                                            
                                                                                                                                    
    IF g_pof.pof02 IS NULL THEN                                                                                                     
       LET l_azi02=NULL                                                                                                             
    ELSE                                                                                                                            
       SELECT azi02 INTO l_azi02 FROM azi_file                                                                                      
        WHERE azi01=g_pof.pof02 AND aziacti = 'Y'                                                                                     
        IF SQLCA.sqlcode THEN                                                                                                       
            LET l_azi02 = NULL                                                                                                      
        END IF                                                                                                                      
    END IF                                                                                                                          
    IF p_cmd = 'd' THEN                                                                                                             
       DISPLAY l_azi02 TO FORMONLY.azi02                                                                                            
    END IF                                                                                                                          
END FUNCTION           
 
FUNCTION i271_pof04(p_cmd)
   DEFINE l_pmc03    LIKE pmc_file.pmc03,
          p_cmd      LIKE type_file.chr1 
 
   IF g_pof.pof04 IS NULL THEN
      LET l_pmc03=NULL
   ELSE  
      SELECT pmc03 INTO l_pmc03 FROM pmc_file 
       WHERE pmc01 = g_pof.pof04
         AND pmc05 = '1'
      IF SQLCA.sqlcode THEN                                                                                                       
         LET l_pmc03 = NULL                                                                                                      
      END IF
   END IF   
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO FORMONLY.pmc03
   END IF
END FUNCTION
 
FUNCTION i271_pof05(p_cmd)
   DEFINE l_pma02   LIKE pma_file.pma02,
          p_cmd     LIKE type_file.chr1   
 
   IF g_pof.pof05 IS NULL THEN                                                                                                      
      LET l_pma02=NULL                                                                                                              
   ELSE       
      SELECT pma02 INTO l_pma02 FROM pma_file 
       WHERE pma01 = g_pof.pof05
         AND pmaacti='Y'
      IF SQLCA.sqlcode THEN                                                                                                         
         LET l_pma02 = NULL                                                                                                         
      END IF  
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pma02 TO FORMONLY.pma02
   END IF
END FUNCTION
 
FUNCTION i271_pof08(p_cmd)                                                                                                          
   DEFINE l_gec04  LIKE gec_file.gec04,
          l_gec07  LIKE gec_file.gec07,                                                                                            
          p_cmd    LIKE type_file.chr1                                                                                             
                                                                                                                                    
   IF g_pof.pof08 IS NULL THEN                                                                                                      
      LET l_gec04=NULL
      LET l_gec07=NULL                                                                                                              
   ELSE                                                                                                                             
      SELECT gec04,gec07 INTO l_gec04,l_gec07 FROM gec_file                                                                                       
       WHERE gec01   = g_pof.pof08                                                                                                    
         AND gecacti = 'Y' 
         AND gec011  = '1'                                                                                                           
      IF SQLCA.sqlcode THEN                                                                                                         
         LET l_gec04 = NULL
         LET l_gec07 = NULL                                                                                                         
      END IF                                                                                                                        
   END IF                                                                                                                           
   IF cl_null(g_errno) OR p_cmd = 'd' THEN 
      LET g_pof.pof09 = l_gec04
      DISPLAY BY NAME g_pof.pof09
      DISPLAY l_gec07 TO FORMONLY.gec07                                                                                             
   END IF                                                                                                                           
END FUNCTION             
 
#Query 查詢
FUNCTION i271_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_pof.* TO NULL              
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_poh.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i271_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_pof.* TO NULL
        RETURN
    END IF
    OPEN i271_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_pof.* TO NULL
    ELSE
        OPEN i271_count
        FETCH i271_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i271_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i271_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  
 
    CASE p_flag
#        WHEN 'N' FETCH NEXT     i271_cs INTO g_pof_rowi,g_pof.pof01,  #091020
         WHEN 'N' FETCH NEXT     i271_cs INTO g_pof.pof01,  #091020
                                             g_pof.pof02,g_pof.pof03,
                                             g_pof.pof04,g_pof.pof05
#        WHEN 'P' FETCH PREVIOUS i271_cs INTO g_pof_rowi,g_pof.pof01, #091020
         WHEN 'P' FETCH PREVIOUS i271_cs INTO g_pof.pof01, #091020
                                             g_pof.pof02,g_pof.pof03,
                                             g_pof.pof04,g_pof.pof05
#        WHEN 'F' FETCH FIRST    i271_cs INTO g_pof_rowi,g_pof.pof01,   #091020
         WHEN 'F' FETCH FIRST    i271_cs INTO g_pof.pof01,   #091020
                                             g_pof.pof02,g_pof.pof03,
                                             g_pof.pof04,g_pof.pof05
#        WHEN 'L' FETCH LAST     i271_cs INTO g_pof_rowi,g_pof.pof01,  #091020
         WHEN 'L' FETCH LAST     i271_cs INTO g_pof.pof01,  #091020
                                             g_pof.pof02,g_pof.pof03,
                                             g_pof.pof04,g_pof.pof05
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0 
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
 
      ON ACTION about       
         CALL cl_about() 
 
      ON ACTION help        
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask() 
 
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
#            FETCH ABSOLUTE g_jump i271_cs INTO g_pof_rowi,g_pof.pof01,  #091020
             FETCH ABSOLUTE g_jump i271_cs INTO g_pof.pof01,  #091020
                                               g_pof.pof02,g_pof.pof03,
                                               g_pof.pof04,g_pof.pof05
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pof.pof01,SQLCA.sqlcode,0)
        INITIALIZE g_pof.* TO NULL
#        LET g_pof_rowi = NULL   #091020
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump       
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
       DISPLAY g_curs_index TO FORMONLY.idx
    END IF
    SELECT * INTO g_pof.* FROM pof_file 
     WHERE pof01 = g_pof.pof01  #091020
       AND pof02 = g_pof.pof02  #091020
       AND pof03 = g_pof.pof03  #091020       
       AND pof04 = g_pof.pof04  #091020       
       AND pof05 = g_pof.pof05  #091020       
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","pof_file",g_pof.pof01,g_pof.pof02,SQLCA.sqlcode,"","",1)
       INITIALIZE g_pof.* TO NULL
       RETURN
    END IF
    LET g_data_owner = g_pof.pofuser    
    LET g_data_group = g_pof.pofgrup  
    CALL i271_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i271_show()
    LET g_pof_t.* = g_pof.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
        g_pof.pof01,g_pof.pof02,g_pof.pof03,g_pof.pof06,
        g_pof.pof04,g_pof.pof05,g_pof.pof08,g_pof.pof09,
        g_pof.pof07,
        g_pof.pofuser,g_pof.pofgrup,g_pof.pofmodu,g_pof.pofdate
 
    CALL i271_pof01('d')
    CALL i271_pof02('d') 
    CALL i271_pof04('d')
    CALL i271_pof05('d')
    CALL i271_pof08('d') 
 
    CALL i271_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()      
END FUNCTION
 
 
 
#單身
FUNCTION i271_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    
    l_n             LIKE type_file.num5,    #檢查重複用   
    l_cnt           LIKE type_file.num5,    #檢查重複用        
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否       
    p_cmd           LIKE type_file.chr1,    #處理狀態       
    l_sw            LIKE type_file.chr1,    #wip or storage   
    l_i             LIKE type_file.num5,    
    l_swl           LIKE type_file.num5,  
    l_s             LIKE type_file.num5,    
    l_poh06         LIKE poh_file.poh06,
    l_poh08         LIKE poh_file.poh08,
    l_poh09         LIKE poh_file.poh09,
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_p             LIKE type_file.num5,   
    l_allow_insert  LIKE type_file.num5,    #可新增否     
    l_allow_delete  LIKE type_file.num5    #可刪除否    
#    l_gec07         LIKE gec_file.gec07
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_pof.pof01) OR cl_null(g_pof.pof02) OR cl_null(g_pof.pof03) THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_pof.* FROM pof_file
     WHERE pof01=g_pof.pof01
       AND pof02=g_pof.pof02
       AND pof03=g_pof.pof03
       AND pof04=g_pof.pof04
       AND pof05=g_pof.pof05
#   SELECT gec07 INTO l_gec07 FROM gec_file
#    WHERE gec01=g_pof.pof08 
#   CALL i271_g_b()                 #auto input body
#   CALL i271_b_fill('1=1')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT poh06,'','',poh07,poh08,poh09 ",
      " FROM poh_file ",
      " WHERE poh01= ? ",
      "   AND poh02= ? ",
      "   AND poh03= ? ",
      "   AND poh04= ? ",
      "   AND poh05= ? ",
      "   AND poh06= ? ",
      "   AND poh07= ? ",
      "   AND poh08= ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i271_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_poh
              WITHOUT DEFAULTS
              FROM s_poh.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_swl = 0
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_success = 'Y'
            BEGIN WORK
#           OPEN i271_cl USING g_pof_rowi  #091020
            OPEN i271_cl USING g_pof.pof01,g_pof.pof02,g_pof.pof03,g_pof.pof04,g_pof.pof05  #091020         
            IF STATUS THEN
               CALL cl_err("OPEN i271_cl:", STATUS, 1)
               CLOSE i271_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i271_cl INTO g_pof.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_pof.pof01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i271_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_poh_t.* = g_poh[l_ac].*  #BACKUP
               LET g_poh_o.* = g_poh[l_ac].*  #BACKUP 
               LET g_poh07_t = g_poh[l_ac].poh07  #FUN-910088--add--
               OPEN i271_bcl USING g_pof.pof01,g_pof.pof02,g_pof.pof03,
                                   g_pof.pof04,g_pof.pof05,g_poh_t.poh06,
                                   g_poh_t.poh07,g_poh_t.poh08
               IF STATUS THEN
                   CALL cl_err("OPEN i520_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
               ELSE
                   FETCH i271_bcl INTO g_poh[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_poh_t.poh06,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                       CLOSE i271_bcl
                       ROLLBACK WORK
                   END IF
                   SELECT ima02,ima021 INTO g_poh[l_ac].ima02,g_poh[l_ac].ima021 
                    FROM  ima_file
                    WHERE ima01 = g_poh[l_ac].poh06 
               END IF
               CALL cl_show_fld_cont()     
            END IF
            LET g_before_input_done = FALSE
            CALL i271_set_entry_b(p_cmd)
            CALL i271_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_poh[l_ac].* TO NULL     
            LET g_poh_t.* = g_poh[l_ac].*         #新輸入資料
            LET g_poh_o.* = g_poh[l_ac].*         #新輸入資料 
#            LET g_before_input_done = FALSE
#            CALL i271_set_entry_b(p_cmd)
#            CALL i271_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
            LET g_poh[l_ac].poh08 =  0            #Body default
            LET g_poh[l_ac].poh09 =  100          #Body default
#            LET g_poh_t.* = g_poh[l_ac].*         #新輸入資料
             LET g_poh07_t = NULL                 #FUN-910088--add--
 
            CALL i271_poh06('d') 
            LET g_before_input_done = FALSE 
            CALL i271_set_entry_b(p_cmd)                                                                                            
            CALL i271_set_no_entry_b(p_cmd)  
            LET g_before_input_done = TRUE    
            CALL cl_show_fld_cont()    
            NEXT FIELD poh06
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO poh_file(poh01,poh02,poh03,poh04,poh05,poh06,
                                 poh07,poh08,poh09)
                          VALUES(g_pof.pof01,g_pof.pof02,g_pof.pof03,
                                 g_pof.pof04,g_pof.pof05,
                                 g_poh[l_ac].poh06,g_poh[l_ac].poh07,
                                 g_poh[l_ac].poh08,g_poh[l_ac].poh09)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","poh_file",g_pof.pof01,g_poh[l_ac].poh06,SQLCA.sqlcode,"","",1) 
               CANCEL INSERT
               LET g_success = 'N'
            ELSE
               MESSAGE 'INSERT O.K'
               IF g_success = 'Y' THEN
                   COMMIT WORK
               END IF
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
 
       AFTER FIELD poh06
          IF p_cmd = "a" OR (p_cmd = "u" AND 
             g_poh[l_ac].poh06 != g_poh_t.poh06)THEN
             IF g_poh[l_ac].poh06 IS NOT NULL THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_poh[l_ac].poh06,"") THEN
             CALL cl_err('',g_errno,1)
             LET g_poh[l_ac].poh06= g_poh_t.poh06
             NEXT FIELD poh06
            END IF
#FUN-AA0059 ---------------------end-------------------------------
                SELECT count(*) INTO l_cnt FROM pog_file
                 WHERE pog01 = g_pof.pof01
                   AND pog02 = g_pof.pof02
                   AND pog03 = g_pof.pof03
                   AND pog04 = g_pof.pof04
                   AND pog05 = g_pof.pof05
                   AND pog06 = g_poh[l_ac].poh06
                IF l_cnt = 0 THEN
                   CALL cl_err(" ",'aic-036',0) 
                   NEXT FIELD poh06 
                END IF
                CALL i271_poh06(p_cmd)
                IF g_errno!=' ' THEN                                                                                                 
                   CALL cl_err(g_poh[l_ac].poh06,g_errno,0)                                                                                
                   LET g_poh[l_ac].poh06 = g_poh_t.poh06                                                                                   
                   NEXT FIELD poh06       
                END IF 
                IF g_poh[l_ac].poh06 IS NOT NULL 
                   AND g_poh[l_ac].poh07 IS NOT NULL THEN
                   SELECT count(*) INTO l_cnt FROM pog_file
                     WHERE pog01 = g_pof.pof01
                       AND pog02 = g_pof.pof02
                       AND pog03 = g_pof.pof03
                       AND pog04 = g_pof.pof04
                       AND pog05 = g_pof.pof05
                       AND pog06 = g_poh[l_ac].poh06
                       AND pog07 = g_poh[l_ac].poh07  
                    IF l_cnt = 0 THEN
                      CALL cl_err(" ",'aic-036',0) 
                      NEXT FIELD poh06
                    END IF
               END IF                   
               DISPLAY g_poh[l_ac].ima02 TO s_poh[l_ac].ima02
               DISPLAY g_poh[l_ac].ima021 TO s_poh[l_ac].ima021  
               DISPLAY g_poh[l_ac].poh07 TO s_poh[l_ac].poh07    
             #FUN-910088--add--start--
               IF NOT cl_null(g_poh[l_ac].poh08) AND g_poh[l_ac].poh08 != 0 THEN    #FUN-C20048--add--
                  IF NOT i271_poh08_check(p_cmd) THEN 
                     LET g_poh07_t = g_poh[l_ac].poh07
                     NEXT FIELD poh08
                  END IF
                  LET g_poh07_t = g_poh[l_ac].poh07
               END IF                                                               #FUN-C20048--add--
             #FUN-910088--add--end--
             END IF
           END IF      
                         
         
 
 
        AFTER FIELD poh07                  #單位
            IF NOT cl_null(g_poh[l_ac].poh07) THEN
               IF p_cmd='a' OR (p_cmd='u' AND
                 g_poh[l_ac].poh07 != g_poh_t.poh07) THEN
                IF g_poh[l_ac].poh06 IS NOT NULL 
                   AND g_poh[l_ac].poh07 IS NOT NULL THEN
                   SELECT count(*) INTO l_cnt FROM pog_file
                     WHERE pog01 = g_pof.pof01
                       AND pog02 = g_pof.pof02
                       AND pog03 = g_pof.pof03
                       AND pog04 = g_pof.pof04
                       AND pog05 = g_pof.pof05
                       AND pog06 = g_poh[l_ac].poh06
                       AND pog07 = g_poh[l_ac].poh07  
                    IF l_cnt = 0 THEN
                      CALL cl_err(" ",'aic-036',0) 
                      NEXT FIELD poh07
                    END IF
                  END IF           
              #FUN-910088--add--start--
                  IF NOT cl_null(g_poh[l_ac].poh08) AND g_poh[l_ac].poh08 != 0 THEN      #FUN-C20048--add-- 
                     IF NOT i271_poh08_check(p_cmd) THEN
                        LET g_poh07_t = g_poh[l_ac].poh07
                        NEXT FIELD poh08
                     END IF
                     LET g_poh07_t = g_poh[l_ac].poh07
                  END IF                                                                 #FUN-C20048--add--
              #FUN-910088--add--end--
               END IF
            END IF
 
        AFTER FIELD poh08
           IF NOT i271_poh08_check(p_cmd) THEN NEXT FIELD poh08 END IF  #FUN-910088--add--
       #FUN-910088--mark--start--    
       #   IF NOT cl_null(g_poh[l_ac].poh08) THEN
       #       IF g_poh[l_ac].poh08 < 0 THEN
       #           CALL cl_err(g_poh[l_ac].poh08,'aps-406',0)
       #           NEXT FIELD poh08
       #       END IF
       #   END IF
       #   IF p_cmd = 'a' OR (p_cmd = 'u' AND
       #      (g_poh[l_ac].poh06 != g_poh_t.poh06 OR
       #       g_poh[l_ac].poh07 != g_poh_t.poh07 OR
       #       g_poh[l_ac].poh08 != g_poh_t.poh08)) THEN
       #      SELECT COUNT(*) INTO l_cnt FROM poh_file
       #       WHERE poh01 = g_pof.pof01 AND poh02 = g_pof.pof02
       #         AND poh03 = g_pof.pof03 AND poh04 = g_pof.pof04
       #         AND poh05 = g_pof.pof05 AND poh06 = g_poh[l_ac].poh06
       #         AND poh07 = g_poh[l_ac].poh07 AND poh08 = g_poh[l_ac].poh08
       #      IF l_cnt > 0 THEN
       #         CALL cl_err('',-239,0) NEXT FIELD poh08
       #      END IF
       #   END IF
       #FUN-910088--mark--end--
 
        AFTER FIELD poh09
           IF NOT cl_null(g_poh[l_ac].poh09) THEN
               IF g_poh[l_ac].poh09 < 0 OR g_poh[l_ac].poh09 > 100 THEN
                   CALL cl_err(g_poh[l_ac].poh09,'mfg1332',0)
                   NEXT FIELD poh09
               END IF
#              IF g_poh[l_ac].poh08 > 0 AND g_poh[l_ac].poh09 <> 100 THEN 
#                 IF g_poh_t.poh09 IS NULL THEN    
#                    SELECT COUNT(*) INTO l_cnt
#                      FROM poh_file
#                     WHERE poh01 = g_pof.pof01 AND poh02 = g_pof.pof02
#                       AND poh03 = g_pof.pof03 AND poh04 = g_pof.pof04
#                       AND poh05 = g_pof.pof05
#                       AND poh06 = g_poh[l_ac].poh06
#                       AND poh07 = g_poh[l_ac].poh07
#                       AND ((poh08 > g_poh[l_ac].poh08
#                       AND poh09 >= g_poh[l_ac].poh09)
#                        OR (poh08 < g_poh[l_ac].poh08
#                       AND poh09 <= g_poh[l_ac].poh09))
#                    IF l_cnt >0 THEN
#                       CALL cl_err('','axm-521',0) NEXT FIELD poh09
#                    END IF
#                 END IF
#                      
#                 IF g_poh[l_ac].poh09 != g_poh_t.poh09 OR             
#                    g_poh_t.poh09 IS NOT NULL THEN                     
#                    SELECT COUNT(*) INTO l_cnt                          
#                      FROM poh_file                                      
#                     WHERE poh01 = g_pof.pof01 AND poh02 = g_pof.pof02    
#                       AND poh03 = g_pof.pof03 AND poh04 = g_pof.pof04     
#                       AND poh05 = g_pof.pof05                              
#                       AND poh06 = g_poh[l_ac].poh06                         
#                       AND poh07 = g_poh[l_ac].poh07                          
#                       AND (((poh08 >  g_poh[l_ac].poh08 AND poh08!=g_poh_t.poh08)
#                       AND   (poh09 >= g_poh[l_ac].poh09 AND poh09!=g_poh_t.poh09))
#                        OR  ((poh08 <  g_poh[l_ac].poh08 AND poh08!=g_poh_t.poh08)
#                       AND   (poh09 <= g_poh[l_ac].poh09 AND poh09!=g_poh_t.poh09)))
#                    IF l_cnt >0 THEN                                                                                               
#                       CALL cl_err('','axm-521',0) NEXT FIELD poh09              
#                    END IF                                                                                                         
#                 END IF                                      
#              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_poh_t.poh06 IS NOT NULL AND g_poh_t.poh07 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM poh_file
                    WHERE poh01 = g_pof.pof01 AND poh02 = g_pof.pof02 AND
                          poh03 = g_pof.pof03 AND poh04 = g_pof.pof04 AND
                          poh05 = g_pof.pof05 AND poh06 = g_poh_t.poh06 AND
                          poh07 = g_poh_t.poh07  AND poh08 = g_poh_t.poh08
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","poh_file",g_pof.pof01,g_poh_t.poh06,SQLCA.sqlcode,"","",1)  
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
 
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_poh[l_ac].* = g_poh_t.*
               CLOSE i271_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_poh[l_ac].poh06,-263,1)
                LET g_poh[l_ac].* = g_poh_t.*
            ELSE
                UPDATE poh_file SET poh06=g_poh[l_ac].poh06,
                                    poh07=g_poh[l_ac].poh07,
                                    poh08=g_poh[l_ac].poh08,
                                    poh09=g_poh[l_ac].poh09
                 WHERE poh01=g_pof.pof01
                   AND poh02=g_pof.pof02
                   AND poh03=g_pof.pof03
                   AND poh04=g_pof.pof04
                   AND poh05=g_pof.pof05
                   AND poh06=g_poh_t.poh06
                   AND poh07=g_poh_t.poh07
                   AND poh08=g_poh_t.poh08
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("upd","poh_file",g_pof.pof01,g_poh_t.poh06,SQLCA.sqlcode,"","",1)
                   LET g_poh[l_ac].* = g_poh_t.*
                   LET g_success = 'N'
                ELSE
                   MESSAGE 'UPDATE O.K'
                   IF g_success = 'Y' THEN
                       COMMIT WORK
                   END IF
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac        #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_poh[l_ac].* = g_poh_t.*
               #FUN-D30034---add---str---
               ELSE
                  CALL g_poh.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034---add---end---
               END IF
               CLOSE i271_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac        #FUN-D30034 add
            CLOSE i271_bcl
            COMMIT WORK
 
 
        ON ACTION CONTROLO     
            IF INFIELD(poh06) AND l_ac > 1 THEN
                LET g_poh[l_ac].* = g_poh[l_ac-1].*
                NEXT FIELD poh06
            END IF
 
        ON ACTION set_qty
               CALL i271_ctry_poh08()
               NEXT FIELD poh08
 
        ON ACTION set_discount  #延用定價
               CALL i271_ctry_poh09()
               NEXT FIELD poh09
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(poh06) #料件編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pog06"
                  LET g_qryparam.default1 = g_poh[l_ac].poh06
                  LET g_qryparam.where =   "pog01 = '",g_pof.pof01 ,                                                                   
                                     "' AND pog02 = '",g_pof.pof02 ,                                                                   
                                     "' AND pog03 = '",g_pof.pof03 ,                                                                   
                                     "' AND pog04 = '",g_pof.pof04 ,                                                                   
                                     "' AND pog05 = '",g_pof.pof05,"'"  
                  CALL cl_create_qry() RETURNING g_poh[l_ac].poh06
                   DISPLAY BY NAME g_poh[l_ac].poh06      
                  NEXT FIELD poh06
               WHEN INFIELD(poh07) #單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pog07"
                  LET g_qryparam.default1 = g_poh[l_ac].poh07
                  LET g_qryparam.where =   "pog01 = '",g_pof.pof01 ,                                                                
                                     "' AND pog02 = '",g_pof.pof02 ,                                                                
                                     "' AND pog03 = '",g_pof.pof03 ,                                                                
                                     "' AND pog04 = '",g_pof.pof04 ,                                                                
                                     "' AND pog05 = '",g_pof.pof05 ,
                                     "' AND pog06 = '",g_poh[l_ac].poh06,"'" 
                  CALL cl_create_qry() RETURNING g_poh[l_ac].poh07
                   DISPLAY BY NAME g_poh[l_ac].poh07       
                  NEXT FIELD poh07
               OTHERWISE EXIT CASE
            END CASE
 
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
 
      ON ACTION controlg      
         CALL cl_cmdask()   
        
         END INPUT
 
     LET g_pof.pofmodu = g_user
     LET g_pof.pofdate = g_today
     UPDATE pof_file SET pofmodu = g_pof.pofmodu,pofdate = g_pof.pofdate
      WHERE pof01 = g_pof.pof01
        AND pof02 = g_pof.pof02
        AND pof03 = g_pof.pof03
        AND pof04 = g_pof.pof04
        AND pof05 = g_pof.pof05
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err3("upd","pof_file",g_pof.pof01,g_pof.pof02,SQLCA.SQLCODE,"","upd pof",1)
     END IF
     DISPLAY BY NAME g_pof.pofmodu,g_pof.pofdate
 
    CLOSE i271_bcl
    IF g_success = 'Y' THEN
        COMMIT WORK
    ELSE
        ROLLBACK WORK
    END IF
    CALL i271_show()
END FUNCTION
 
FUNCTION i271_delall()
    SELECT COUNT(*) INTO g_cnt FROM poh_file
     WHERE poh01 = g_pof.pof01 AND poh02 = g_pof.pof02
       AND poh03 = g_pof.pof03 AND poh04 = g_pof.pof04
       AND poh05 = g_pof.pof05
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM pof_file WHERE pof01 = g_pof.pof01 AND pof02 = g_pof.pof02
                              AND pof03 = g_pof.pof03 AND pof04 = g_pof.pof04
                              AND pof05 = g_pof.pof05
    END IF
END FUNCTION
 
FUNCTION i271_poh06(p_cmd)  #料件編號
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_ima44    LIKE ima_file.ima44, 
           l_cnt      LIKE type_file.num5,       
           p_cmd      LIKE type_file.chr1      
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima44 INTO l_ima02,l_ima021,l_ima44 
      FROM ima_file 
     WHERE ima01 = g_poh[l_ac].poh06
       AND ima1010 = '1'               
    IF STATUS THEN LET g_errno='mfg3098' END IF 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_poh[l_ac].ima02 = l_ima02
       LET g_poh[l_ac].ima021= l_ima021
       LET g_poh[l_ac].poh07 = l_ima44
    END IF
END FUNCTION
 
FUNCTION i271_poh07()  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
                WHERE gfe01 = g_poh[l_ac].poh07
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_gfeacti = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i271_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       
 
    CONSTRUCT l_wc2 ON poh06,poh07,poh08,poh09 # 螢幕上取單身條件
         FROM s_poh[1].poh06,s_poh[1].poh07,s_poh[1].poh08,s_poh[1].poh09
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i271_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i271_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    l_ima02         LIKE ima_file.ima02,
    p_wc2           LIKE type_file.chr1000   
 
    IF cl_null(p_wc2)  THEN LET p_wc2=' 1=1' END IF
    LET g_sql =
        "SELECT poh06,ima02,ima021,poh07,poh08,poh09 ", #FUN-560193
#       "  FROM poh_file,OUTER ima_file ", #091020
        "  FROM poh_file LEFT OUTER JOIN ima_file ON ima01 = poh06",  #091020
        " WHERE poh01 ='",g_pof.pof01,"'",  #單頭
        "   AND poh02 ='",g_pof.pof02,"'",
        "   AND poh03 ='",g_pof.pof03,"'",
        "   AND poh04 ='",g_pof.pof04,"'",
        "   AND poh05 ='",g_pof.pof05,"'",
#       "   AND ima01 = poh06 ",               #091020
        "   AND ",p_wc2 CLIPPED, #單身
        " ORDER BY 1,4"
    PREPARE i271_pb FROM g_sql
    DECLARE poh_cs                       #CURSOR
        CURSOR FOR i271_pb
 
    CALL g_poh.clear()
    LET g_cnt = 1
    FOREACH poh_cs INTO g_poh[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_poh.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i271_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_poh TO s_poh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()              
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i271_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY         
 
      ON ACTION previous
         CALL i271_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY           
 
 
      ON ACTION jump
         CALL i271_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY           
 
 
      ON ACTION next
         CALL i271_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY            
 
 
      ON ACTION last
         CALL i271_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY           
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION controls        
         CALL cl_set_head_visible("","AUTO")           
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
      ON ACTION related_document                #  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i271_out()
 DEFINE l_cmd   LIKE  type_file.chr1000       
     IF cl_null(g_wc) AND NOT cl_null(g_pof.pof01) THEN
        LET g_wc = " pof01='",g_pof.pof01,
              "' AND pof02='",g_pof.pof02,
              "' AND pof03='",g_pof.pof03,
              "' AND pof04='",g_pof.pof04,
              "' AND pof05='",g_pof.pof05,"'"
     END IF
     IF g_wc IS NULL THEN 
        CALL cl_err('','9057',0) 
        RETURN
     END IF
     IF cl_null(g_wc2) THEN
        LET g_wc2 = '1=1'
     END IF
     LET l_cmd = 'p_query "apmi271" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'
     CALL cl_cmdrun(l_cmd)
     RETURN              
 
END FUNCTION
 
 
#以下修正和此筆相同的數量
FUNCTION i271_ctry_poh08()
 DEFINE l_i LIKE type_file.num10,      
        l_poh08 LIKE poh_file.poh08 
 
    LET l_i = l_ac
    LET l_poh08 = g_poh[l_ac].poh08
    IF cl_confirm('abx-080') THEN
        #先update 本筆的資料
              UPDATE poh_file
                 SET poh08 = l_poh08 
               WHERE poh01 = g_pof.pof01
                 AND poh02 = g_pof.pof02
                 AND poh03 = g_pof.pof03
                 AND poh04 = g_pof.pof04
                 AND poh05 = g_pof.pof05
                 AND poh06 = g_poh[l_i].poh06
                 AND poh07 = g_poh[l_i].poh07
                 AND poh08 = g_poh_t.poh08
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","poh_file",g_pof.pof01,g_poh[l_i].poh06,SQLCA.sqlcode,"","",1)  
                  LET g_success='N'
                  RETURN
              END IF
        LET g_poh_o.poh08 = g_poh_t.poh08
        LET g_poh_t.poh08 = l_poh08
 
        WHILE l_i <= g_rec_b    #自本行至最後一行延用此值
              UPDATE poh_file
                 SET poh08 = l_poh08
               WHERE poh01 = g_pof.pof01
                 AND poh02 = g_pof.pof02
                 AND poh03 = g_pof.pof03
                 AND poh04 = g_pof.pof04
                 AND poh05 = g_pof.pof05
                 AND poh06 = g_poh[l_i].poh06
                 AND poh07 = g_poh[l_i].poh07
                 AND poh08 = g_poh[l_i].poh08 
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","poh_file",g_pof.pof01,g_poh[l_i].poh06,SQLCA.sqlcode,"","",1)  
                  LET g_success='N'
                  EXIT WHILE
              END IF    
              LET l_i = l_i + 1
              IF g_cnt > g_max_rec THEN
                  CALL cl_err( '', 9035, 0 )
                  EXIT WHILE
              END IF
        END WHILE
    END IF
    CALL i271_show()
END FUNCTION
 
#以下修正和此筆相同的折扣
FUNCTION i271_ctry_poh09()
 DEFINE l_i LIKE type_file.num10,       
        l_poh09 LIKE poh_file.poh09
    LET l_i = l_ac
    LET l_poh09 = g_poh[l_ac].poh09
    IF cl_confirm('abx-080') THEN
        WHILE l_i <= g_rec_b  #自本行至最后一行延用其上的值
              UPDATE poh_file SET poh09 = l_poh09
               WHERE poh01 = g_pof.pof01
                 AND poh02 = g_pof.pof02
                 AND poh03 = g_pof.pof03
                 AND poh04 = g_pof.pof04
                 AND poh05 = g_pof.pof05
                 AND poh06 = g_poh[l_i].poh06
                 AND poh07 = g_poh[l_i].poh07
                 AND poh08 = g_poh[l_i].poh08
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","poh_file",g_pof.pof01,g_poh[l_i].poh06,SQLCA.sqlcode,"","",1) 
                  LET g_success='N'
                  EXIT WHILE
              END IF
              LET l_i = l_i + 1
              IF g_cnt > g_max_rec THEN
                  CALL cl_err( '', 9035, 0 )
                  EXIT WHILE
              END IF
        END WHILE
    END IF
    CALL i271_show()
END FUNCTION
#genero
 
#單身
FUNCTION i271_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1      
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("poh06,poh07",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i271_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1       
   IF p_cmd = 'u' THEN
       CALL cl_set_comp_entry("poh06,poh07",FALSE)
   END IF
                                                                                                                   
END FUNCTION                                                                                                                        
#No.FUN-930137 #
#Patch....NO.FUN-930113 <001> #
#FUN-910088--add--start--
FUNCTION i271_poh08_check(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1,
          l_cnt LIKE type_file.num5

   IF NOT cl_null(g_poh[l_ac].poh08) AND NOT cl_null(g_poh[l_ac].poh07) THEN
      IF cl_null(g_poh_t.poh08) OR cl_null(g_poh07_t) OR g_poh_t.poh08 != g_poh[l_ac].poh08 OR g_poh07_t != g_poh[l_ac].poh07 THEN
         LET g_poh[l_ac].poh08 = s_digqty(g_poh[l_ac].poh08,g_poh[l_ac].poh07)
         DISPLAY BY NAME g_poh[l_ac].poh08
      END IF
   END IF
   IF NOT cl_null(g_poh[l_ac].poh08) THEN
       IF g_poh[l_ac].poh08 < 0 THEN
           CALL cl_err(g_poh[l_ac].poh08,'aps-406',0)
           RETURN FALSE    
       END IF
   END IF
   IF p_cmd = 'a' OR (p_cmd = 'u' AND
      (g_poh[l_ac].poh06 != g_poh_t.poh06 OR
       g_poh[l_ac].poh07 != g_poh_t.poh07 OR
       g_poh[l_ac].poh08 != g_poh_t.poh08)) THEN
      SELECT COUNT(*) INTO l_cnt FROM poh_file
       WHERE poh01 = g_pof.pof01 AND poh02 = g_pof.pof02
         AND poh03 = g_pof.pof03 AND poh04 = g_pof.pof04
         AND poh05 = g_pof.pof05 AND poh06 = g_poh[l_ac].poh06
         AND poh07 = g_poh[l_ac].poh07 AND poh08 = g_poh[l_ac].poh08
      IF l_cnt > 0 THEN
         CALL cl_err('',-239,0) RETURN FALSE   
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--
  
