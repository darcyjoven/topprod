# Prog. Version..: '5.25.01-10.05.01(00010)'     #
# Pattern name...: ghri072.4gl
# Descriptions...:
# Date & Author..: 13/5/22 By zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_head   RECORD 
         hrde01     LIKE     hrde_file.hrde01,
         hrde02     LIKE     hrde_file.hrde02,
         hrde03     LIKE     hrde_file.hrde03,
         hrde04     LIKE     hrde_file.hrde04,
         hrde07     LIKE     hrde_file.hrde07,        #add by zhangbo130906
         hrde08     LIKE     hrde_file.hrde08,        #add by zhangbo130906
         hrde09     LIKE     hrde_file.hrde09,        #add by zhangbo130906
         hrde10     LIKE     hrde_file.hrde10,        #add by zhangbo130906
         hrde11     LIKE     hrde_file.hrde11         #add by zhangbo130906   
                END RECORD
DEFINE g_head_t RECORD 
         hrde01     LIKE     hrde_file.hrde01,
         hrde02     LIKE     hrde_file.hrde02,
         hrde03     LIKE     hrde_file.hrde03,
         hrde04     LIKE     hrde_file.hrde04,
         hrde07     LIKE     hrde_file.hrde07,        #add by zhangbo130906
         hrde08     LIKE     hrde_file.hrde08,        #add by zhangbo130906
         hrde09     LIKE     hrde_file.hrde09,        #add by zhangbo130906
         hrde10     LIKE     hrde_file.hrde10,        #add by zhangbo130906
         hrde11     LIKE     hrde_file.hrde11         #add by zhangbo130906
                END RECORD
DEFINE g_hrde   DYNAMIC ARRAY OF RECORD 
         hrde05     LIKE     hrde_file.hrde05,
         hrde06     LIKE     hrde_file.hrde06,
         hrdeud01     LIKE     hrde_file.hrdeud01,
         hrdeud02     LIKE     hrde_file.hrdeud02
         #hrde07     LIKE     hrde_file.hrde07        #mark by zhangbo130906
                END RECORD
DEFINE g_hrde_t RECORD 
         hrde05     LIKE     hrde_file.hrde05,
         hrde06     LIKE     hrde_file.hrde06,
         hrdeud01     LIKE     hrde_file.hrdeud01,
         hrdeud02     LIKE     hrde_file.hrdeud02
         #hrde07     LIKE     hrde_file.hrde07        #mark by zhangbo130906
                END RECORD
DEFINE g_col   DYNAMIC ARRAY OF RECORD
         col1       LIKE     hrde_file.hrde03,
         col2       LIKE     hrde_file.hrde06,
         col3       LIKE     hrde_file.hrde06,
         col4       LIKE     hrde_file.hrde06,
         col5       LIKE     hrde_file.hrde06,
         col6       LIKE     hrde_file.hrde06,
         col7       LIKE     hrde_file.hrde06,                                                
         col8       LIKE     hrde_file.hrde06,
         col9       LIKE     hrde_file.hrde06,
         col10      LIKE     hrde_file.hrde06,
         col11      LIKE     hrde_file.hrde06,
         col12      LIKE     hrde_file.hrde06,
         col13      LIKE     hrde_file.hrde06,
         col14      LIKE     hrde_file.hrde06,
         col15      LIKE     hrde_file.hrde06,
         col16      LIKE     hrde_file.hrde06,
         col17      LIKE     hrde_file.hrde06,
         col18      LIKE     hrde_file.hrde06,
         col19      LIKE     hrde_file.hrde06,
         col20      LIKE     hrde_file.hrde06,
         col21      LIKE     hrde_file.hrde06,
         col22      LIKE     hrde_file.hrde06,
         col23      LIKE     hrde_file.hrde06,
         col24      LIKE     hrde_file.hrde06,
         col25      LIKE     hrde_file.hrde06
               END RECORD
DEFINE   g_wc,g_wc2,g_sql     STRING
DEFINE   g_rec_b         LIKE type_file.num5
DEFINE   g_rec_b1        LIKE type_file.num5
DEFINE   l_ac            LIKE type_file.num5
DEFINE   l_ac1           LIKE type_file.num5
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680102 INTEGER   
DEFINE   g_i             LIKE type_file.num5      #No.FUN-680102 SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING                   #No.FUN-850016                                                                    
DEFINE   g_str           STRING                   #No.FUN-850016   
DEFINE   g_msg                 STRING
DEFINE   g_curs_index          LIKE type_file.num10
DEFINE   g_row_count           LIKE type_file.num10        #總筆數     
DEFINE   g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE   g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗    
DEFINE   g_flag                LIKE type_file.chr10
DEFINE   g_tree DYNAMIC ARRAY OF RECORD
          name           LIKE type_file.chr1000,                 
          pid            LIKE type_file.chr1000, 
          id             LIKE hrde_file.hrde02,  
          has_children   BOOLEAN,                
          expanded       BOOLEAN,                
          level          LIKE type_file.num5,    
          treekey1       VARCHAR(1000),
          treekey2       VARCHAR(1000)
          END RECORD
DEFINE   l_tree_ac       LIKE type_file.num5
DEFINE   g_idx           LIKE type_file.num5          
DEFINE   g_curr_idx      INTEGER
DEFINE   gs_wc           STRING
DEFINE g_before_input_done LIKE type_file.num5 

  
MAIN
DEFINE l_name   STRING
DEFINE l_items  STRING

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
   
   LET g_forupd_sql = "SELECT * FROM hrde_file WHERE hrde01 = ? ",
                      "   AND hrde02 = ? AND hrde03 = ? AND hrde04 = ?",
                      "   FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i072_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   OPEN WINDOW i072_w WITH FORM "ghr/42f/ghri072_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   
   CALL cl_set_combo_items("hrde05",NULL,NULL)
   CALL i072_get_items('648') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrde05",l_name,l_items) 
   
   LET g_flag ='N'
 
   CALL i072_menu()
 
   CLOSE WINDOW i072_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION i072_get_items(p_hrag01)
DEFINE p_hrag01   LIKE  hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING

       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i072_get_items_pre FROM l_sql
       DECLARE i072_get_items CURSOR FOR i072_get_items_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i072_get_items INTO l_hrag06,l_hrag07
          IF cl_null(l_name) AND cl_null(l_items) THEN
            LET l_name=l_hrag06
            LET l_items=l_hrag07
          ELSE
            LET l_name=l_name CLIPPED,",",l_hrag06 CLIPPED
            LET l_items=l_items CLIPPED,",",l_hrag07 CLIPPED
          END IF
       END FOREACH
       
       RETURN l_name,l_items
END FUNCTION

FUNCTION i072_menu()
DEFINE l_n   LIKE  type_file.num5
 
   WHILE TRUE
      IF g_flag ='pg2' THEN
        CALL g_tree.clear()
        CALL g_col.clear()
        SELECT COUNT(DISTINCT hrde01) INTO l_n FROM hrde_file 
        IF l_n>0 THEN 
           CALL i072_tree_fill()          
        END IF 
        CALL i072_bp2("G")   #包含第二页签的DISPLAY
      ELSE
      	CALL i072_bp("G")    #包含第一页签DISPLAY
      END IF   
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
            	 CALL i072_a()
            END IF 
         WHEN "query" 
            IF cl_chk_act_auth() THEN
            	 LET gs_wc=NULL  	
               CALL i072_q()  
            END IF
            	
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i072_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            	
         WHEN "delete"
            IF cl_chk_act_auth() THEN
            	 CALL i072_r()
            END IF 
            	
         WHEN "modify"
            IF cl_chk_act_auth() THEN
            	 CALL i072_r()
            END IF
            	 
         WHEN "piliang"
            IF cl_chk_act_auth() THEN
            	 CALL i072_gen()
            END IF
            	   	  	
         WHEN "next"
            IF cl_chk_act_auth() THEN
            	 CALL i072_fetch('N')
            END IF    
         WHEN "previous"
            IF cl_chk_act_auth() THEN
            	 CALL i072_fetch('P')
            END IF  
         WHEN "jump"
            IF cl_chk_act_auth() THEN
            	 CALL i072_fetch('/')
            END IF  
         WHEN "first"
            IF cl_chk_act_auth() THEN
            	 CALL i072_fetch('F')
            END IF  
         WHEN "last"
            IF cl_chk_act_auth() THEN
            	 CALL i072_fetch('L')
            END IF                                                                                                                                                                                                                               
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              IF g_flag ='pg2' THEN
                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_col),'','')
              ELSE
              	 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrde),'','')
              END IF	    
            END IF
      END CASE
   END WHILE
 
END FUNCTION
	
FUNCTION i072_tree_fill()
DEFINE l_sql    STRING
             
         LET l_sql=" SELECT DISTINCT hrde01,hrde02 FROM hrde_file ORDER BY hrde01,hrde02"
         
         PREPARE i072_tree_pre FROM l_sql
         DECLARE i072_tree_cs CURSOR FOR i072_tree_pre
         
         LET g_idx=1
         
         FOREACH i072_tree_cs INTO g_tree[g_idx].id,g_tree[g_idx].name
            LET g_tree[g_idx].pid=NULL
            LET g_tree[g_idx].expanded=0
            LET g_tree[g_idx].has_children=FALSE
            LET g_tree[g_idx].level=0
            
            LET g_idx=g_idx+1
         
         END FOREACH
         
         CALL g_tree.deleteelement(g_idx)  #刪除FOREACH最後新增的空白列
         LET g_idx=g_idx-1   
             
END FUNCTION 
	            			  
	
FUNCTION i072_cs()
  IF gs_wc IS NULL THEN
    CLEAR FORM
    INITIALIZE g_head.* TO NULL
    CALL g_col.clear()
    CALL g_hrde.clear()
    LET g_wc2 = NULL
    
    CONSTRUCT g_wc ON hrde01,hrde02,hrde03,hrde04,hrde08,hrde09,hrde10,hrde11,hrde07    #mod by zhangbo130906
         FROM hrde01,hrde02,hrde03,hrde04,hrde08,hrde09,hrde10,hrde11,hrde07    #mod by zhangbo130906
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT         
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
       
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
       
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
    
         ON ACTION qbe_select
            CALL cl_qbe_select() 
         ON ACTION qbe_save
            CALL cl_qbe_save()
    END CONSTRUCT
  ELSE
  	LET g_wc=gs_wc
  END IF 	  
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrdeuser', 'hrdegrup') #FUN-980030
 
  LET g_sql = "SELECT DISTINCT hrde01,hrde02,hrde03,hrde04 FROM hrde_file ",
              " WHERE ",g_wc CLIPPED, 
              " ORDER BY hrde01,hrde02"
  PREPARE i072_prepare FROM g_sql
  DECLARE i072_cs                                                  # SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i072_prepare

  LET g_sql = "SELECT COUNT (*) FROM (",
              " SELECT DISTINCT hrde01,hrde02,hrde03,hrde04 FROM hrde_file ",
              " WHERE ",g_wc CLIPPED ,
              " ) "
  PREPARE i072_precount FROM g_sql
  DECLARE i072_count CURSOR FOR i072_precount
END FUNCTION
	
FUNCTION i072_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_head.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i072_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i072_count
    FETCH i072_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i072_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_head.hrde01,SQLCA.sqlcode,0)
        INITIALIZE g_head.* TO NULL
    ELSE
        CALL i072_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION
	
FUNCTION i072_fetch(p_flhrde)
    DEFINE p_flhrde         LIKE type_file.chr1
 
    CASE p_flhrde
        WHEN 'N' FETCH NEXT     i072_cs INTO g_head.hrde01,g_head.hrde02,
                                             g_head.hrde03,g_head.hrde04
        WHEN 'P' FETCH PREVIOUS i072_cs INTO g_head.hrde01,g_head.hrde02,
                                             g_head.hrde03,g_head.hrde04
        WHEN 'F' FETCH FIRST    i072_cs INTO g_head.hrde01,g_head.hrde02,
                                             g_head.hrde03,g_head.hrde04
        WHEN 'L' FETCH LAST     i072_cs INTO g_head.hrde01,g_head.hrde02,
                                             g_head.hrde03,g_head.hrde04
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i072_cs INTO g_head.hrde01,g_head.hrde02,
                                               g_head.hrde03,g_head.hrde04
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_head.hrde01,SQLCA.sqlcode,0)
        INITIALIZE g_head.* TO NULL  
        RETURN
    ELSE
      CASE p_flhrde
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
          
    END IF

    #add by zhangbo130906---begin
    SELECT DISTINCT hrde07,hrde08,hrde09,hrde10,hrde11 
      INTO g_head.hrde07,g_head.hrde08,g_head.hrde09,g_head.hrde10,g_head.hrde11
      FROM hrde_file
     WHERE hrde01=g_head.hrde01
       AND hrde02=g_head.hrde02
       AND hrde03=g_head.hrde03
       AND hrde04=g_head.hrde04
     #add by zhangbo130906
    
    CALL i072_show()                   # 重新顯示

END FUNCTION	
	
FUNCTION i072_show()
DEFINE l_hrde03_desc     LIKE    type_file.chr1000
DEFINE l_hraa12          LIKE    hraa_file.hraa12        #add by zhangbo130906
    
    LET g_head_t.*=g_head.*
    DISPLAY BY NAME g_head.hrde01,g_head.hrde02,
                    g_head.hrde03,g_head.hrde04,
                    #add by zhangbo130906---begin
                    g_head.hrde07,g_head.hrde08,
                    g_head.hrde09,g_head.hrde10,g_head.hrde11
                    #add by zhangbo130906
                    
    CASE g_head.hrde04 
    	 WHEN '0'               #职务  
    	    SELECT hrar04 INTO l_hrde03_desc FROM hrar_file WHERE hrar03=g_head.hrde03
    	 WHEN '1'               #职位
    	    SELECT hras04 INTO l_hrde03_desc FROM hras_file WHERE hras01=g_head.hrde03
    	 WHEN '2'               #其他
    	    SELECT hrag07 INTO l_hrde03_desc FROM hrag_file WHERE hrag06=g_head.hrde03
    	                                                      AND hrag01='649'
    	 OTHERWISE 
    	    LET l_hrde03_desc=''
    END CASE
    	
    DISPLAY l_hrde03_desc TO hrde03_desc		      
   
    #add by zhangbo130906---begin
    SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=g_head.hrde08
    DISPLAY l_hraa12 TO hraa12
    #add by zhangbo130906                                                          

    CALL cl_show_fld_cont()
    
    CALL i072_b_fill()
END FUNCTION
	
FUNCTION i072_a()
 
    CLEAR FORM 
    INITIALIZE g_head.* TO NULL
    CALL g_hrde.clear()
    CALL g_col.clear()
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i072_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
        	  CALL g_hrde.clear()
        	  CALL g_col.clear()  
        	  INITIALIZE g_head.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE        	      	
        END IF
        
        LET g_rec_b=0
        CALL i072_g_b()
        CALL i072_b_fill()
        CALL i072_b()
                
        LET g_head_t.*=g_head.*
        
        EXIT WHILE
    END WHILE
END FUNCTION
	
FUNCTION i072_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_hrde03_desc LIKE type_file.chr100 
   DEFINE l_hraa12      LIKE hraa_file.hraa12     #add by zhangbo130906
 
   DISPLAY BY NAME g_head.hrde01,g_head.hrde02,g_head.hrde03,g_head.hrde04,
                   g_head.hrde07,g_head.hrde08,g_head.hrde09,g_head.hrde10,g_head.hrde11   #add by zhangbo130906
                   
 
   INPUT BY NAME
      g_head.hrde01,g_head.hrde02,
      g_head.hrde08,g_head.hrde09,     #add by zhangbo130906
      g_head.hrde04,g_head.hrde03,
      g_head.hrde10,g_head.hrde11,g_head.hrde07    #add by zhangbo130906
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         #CALL i072_set_entry(p_cmd)
         #CALL i072_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         
         IF cl_null(g_head.hrde01) THEN
         	  LET g_head.hrde02=NULL
         	  LET g_head.hrde04=NULL
                  LET g_head.hrde08=NULL    #add by zhangbo130906
                  LET g_head.hrde09=NULL    #add by zhangbo130906
                  LET g_head.hrde10=NULL    #add by zhangbo130906
                  LET g_head.hrde11=NULL    #add by zhangbo130906
         	  CALL cl_set_comp_entry("hrde02,hrde04",FALSE)
                  CALL cl_set_comp_entry("hrde08,hrde09,hrde10,hrde11",FALSE)    #add by zhangbo130906
         ELSE
         	  CALL cl_set_comp_entry("hrde02,hrde04",TRUE)
                  CALL cl_set_comp_entry("hrde08,hrde09,hrde10,hrde11",TRUE)    #add by zhangbo130906
         END IF
         
         IF cl_null(g_head.hrde04) THEN
         	  LET g_head.hrde03=NULL
         	  CALL cl_set_comp_entry("hrde03",FALSE)
         ELSE
         	  CALL cl_set_comp_entry("hrde03",TRUE)
         END IF		  	  
 
      AFTER FIELD hrde01
         IF g_head.hrde01 IS NOT NULL THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrde_file WHERE hrde01=g_head.hrde01
            IF l_n>0 THEN
            	 SELECT DISTINCT hrde02,hrde04 INTO g_head.hrde02,g_head.hrde04
            	   FROM hrde_file WHERE hrde01=g_head.hrde01
                 #add by zhangbo130906---begin
                 SELECT DISTINCT hrde08,hrde09,hrde10,hrde11 
                   INTO g_head.hrde08,g_head.hrde09,g_head.hrde10,g_head.hrde11
                   FROM hrde_file WHERE hrde01=g_head.hrde01
                 SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=g_head.hrde08
                 #add by zhangbo130906---end
            	 DISPLAY BY NAME g_head.hrde02,g_head.hrde04
                 DISPLAY BY NAME g_head.hrde08,g_head.hrde09,g_head.hrde10,g_head.hrde11    #add by zhangbo130906
                 DISPLAY l_hraa12 TO hraa12                                                 #add by zhangbo130906
            	 CALL cl_set_comp_entry("hrde02,hrde04",FALSE)
                 CALL cl_set_comp_entry("hrde08,hrde09,hrde10,hrde11",FALSE)                #add by zhangbo130906  
            ELSE
            	 CALL cl_set_comp_entry("hrde02,hrde04",TRUE)
                 CALL cl_set_comp_entry("hrde08,hrde09,hrde10,hrde11",TRUE)                #add by zhangbo130906
                 LET g_head.hrde09='Y'                                                     #add by zhangbo130906
                 LET g_head.hrde10=g_today                                                 #add by zhangbo130906
                 LET g_head.hrde11=g_today                                                 #add by zhangbo130906
                 DISPLAY BY NAME g_head.hrde09,g_head.hrde10,g_head.hrde11                 #add by zhangbo130906
            END IF
            	
            IF cl_null(g_head.hrde04) THEN
         	     LET g_head.hrde03=NULL
         	     CALL cl_set_comp_entry("hrde03",FALSE)
            ELSE
         	     CALL cl_set_comp_entry("hrde03",TRUE)
            END IF				 	    
         END IF

      AFTER FIELD hrde02
         IF NOT cl_null(g_head.hrde02) THEN
            IF g_head.hrde02 != g_head_t.hrde02 OR g_head_t.hrde02 IS NULL THEN
            	 LET l_n=0
            	 SELECT COUNT(*) INTO l_n FROM hrde_file WHERE hrde02=g_head.hrde02
            	 IF l_n>0 THEN
            	 	  CALL cl_err("该名称已和其他编号对应,请检查","！",0)
            	 	  NEXT FIELD hrde02
            	 END IF
            END IF	 		   
         END IF
         	
      AFTER FIELD hrde04
         IF NOT cl_null(g_head.hrde04) THEN
         	  CALL cl_set_comp_entry("hrde03",TRUE)
         ELSE
         	  CALL cl_set_comp_entry("hrde03",FALSE)
         END IF
         	
      AFTER FIELD hrde03
        IF NOT cl_null(g_head.hrde03) THEN
        	 LET l_n=0
        	 CASE g_head.hrde04
        	 	  WHEN '0'                    #职务
        	 	     SELECT COUNT(*) INTO l_n FROM hrar_file WHERE hrar03=g_head.hrde03
        	 	  WHEN '1'                    #职位
        	 	     SELECT COUNT(*) INTO l_n FROM hras_file WHERE hras01=g_head.hrde03
        	 	  WHEN '2'                    #其他
        	 	     SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag06=g_head.hrde03
        	 	                                               AND hrag01='649'
        	 END CASE
        	 	
        	 IF l_n=0 THEN
        	 	  CALL cl_err("职位/职位/代码组不存在,请检查","!",0)
        	 	  NEXT FIELD hrde03
        	 END IF
        	 
        	 CASE g_head.hrde04
        	 	  WHEN '0'                    #职务
        	 	     SELECT hrar04 INTO l_hrde03_desc FROM hrar_file WHERE hrar03=g_head.hrde03
        	 	  WHEN '1'                    #职位
        	 	     SELECT hras04 INTO l_hrde03_desc FROM hras_file WHERE hras01=g_head.hrde03
        	 	  WHEN '2'                    #其他
        	 	     SELECT hrag07 INTO l_hrde03_desc FROM hrag_file WHERE hrag06=g_head.hrde03
        	 	                                                      AND hrag01='649'
        	 END CASE	
        	 
        	 DISPLAY l_hrde03_desc TO hrde03_desc	
        	 	
        	 IF g_head.hrde03 != g_head_t.hrde03 OR g_head_t.hrde03 IS NULL THEN
        	 	  LET l_n=0
        	 	  SELECT COUNT(*) INTO l_n FROM hrde_file 
        	 	   WHERE hrde01=g_head.hrde01
        	 	     AND hrde02=g_head.hrde02
        	 	     AND hrde03=g_head.hrde03
        	 	     AND hrde04=g_head.hrde04
        	 	  IF l_n>0 THEN
        	 	  	 CALL cl_err("此笔资料已录入,不可重复录入","!",0)
        	 	  	 NEXT FIELD hrde03
        	 	  END IF
        	 END IF 	
           END IF	                                         		  		                                                         		  	     	         	
      #add by zhangbo130906---begin
      AFTER FIELD hrde08
         IF NOT cl_null(g_head.hrde08) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa01=g_head.hrde08
            IF l_n=0 THEN
               CALL cl_err("该公司不存在","!",0)
               NEXT FIELD hrde08
            END IF

            SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=g_head.hrde08
            DISPLAY l_hraa12 TO hraa12
         END IF
      #add by zhangbo130906---end 
  
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

     ON ACTION controlp
        CASE
           WHEN INFIELD(hrde03)
              CALL cl_init_qry_var()
              IF g_head.hrde04='0' THEN
                 LET g_qryparam.form = "q_hrar03"
                 LET g_qryparam.where = " hrar03 NOT IN (SELECT hrde03 FROM hrde_file", 
                                        "                 WHERE hrde01='",g_head.hrde01,"'",
                                        "                   AND hrde02='",g_head.hrde02,"'",
                                        "                   AND hrde04='",g_head.hrde04,"') "
              END IF
              IF g_head.hrde04='1' THEN
                 LET g_qryparam.form = "q_hras01"
                 LET g_qryparam.where = " hras01 NOT IN (SELECT hrde03 FROM hrde_file ",
                                        "                 WHERE hrde01='",g_head.hrde01,"'",
                                        "                   AND hrde02='",g_head.hrde02,"'",
                                        "                   AND hrde04='",g_head.hrde04,"') "
              END IF
              IF g_head.hrde04='2' THEN
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.arg1='649'
                 LET g_qryparam.where = " hrag06 NOT IN (SELECT hrde03 FROM hrde_file ",
                                        "                 WHERE hrde01='",g_head.hrde01,"'",
                                        "                   AND hrde02='",g_head.hrde02,"'",
                                        "                   AND hrde04='",g_head.hrde04,"') "
              END IF		   
              LET g_qryparam.default1 = g_head.hrde03
              CALL cl_create_qry() RETURNING g_head.hrde03
              DISPLAY g_head.hrde03 TO hrde03
              NEXT FIELD hrde03

              #add by zhangbo130906---begin
              WHEN INFIELD(hrde08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.default1 = g_head.hrde08
                 CALL cl_create_qry() RETURNING g_head.hrde08
                 DISPLAY g_head.hrde08 TO hrde08
                 NEXT FIELD hrde08
              #add by zhangbo130906---end
           OTHERWISE
              EXIT CASE
           END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help   
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION
	
FUNCTION i072_g_b()
DEFINE  l_hrde     RECORD LIKE hrde_file.*
DEFINE  l_sql      STRING
DEFINE  l_sr       LIKE type_file.num5
DEFINE  l_sr1      LIKE type_file.num5 

        LET l_hrde.hrde01=g_head.hrde01
        LET l_hrde.hrde02=g_head.hrde02
        LET l_hrde.hrde03=g_head.hrde03
        LET l_hrde.hrde04=g_head.hrde04
        #add by zhangbo130906---begin
        LET l_hrde.hrde07=g_head.hrde07
        LET l_hrde.hrde08=g_head.hrde08
        LET l_hrde.hrde09=g_head.hrde09
        LET l_hrde.hrde10=g_head.hrde10
        LET l_hrde.hrde11=g_head.hrde11
        #add by zhangbo130906---end
        
        LET l_hrde.hrde06=0
        LET l_hrde.hrdeuser=g_user
        LET l_hrde.hrdegrup=g_grup
        LET l_hrde.hrdeoriu=g_user
        LET l_hrde.hrdeorig=g_grup
        LET l_hrde.hrdedate=g_today
        LET l_hrde.hrdeacti='Y'
        

        LET l_sql=" SELECT DISTINCT hrag06 FROM hrag_file WHERE hrag01='648' "
        PREPARE i072_g_pre FROM l_sql
        DECLARE i072_g_cs CURSOR FOR i072_g_pre
        
        FOREACH i072_g_cs INTO l_hrde.hrde05
           
           INSERT INTO hrde_file VALUES (l_hrde.*)
        
        END FOREACH   
        SELECT COUNT(*) INTO l_sr FROM hrde_file WHERE hrde01=g_head.hrde01
        SELECT COUNT(*) INTO l_sr1 FROM hrag_file WHERE hrag01='648'
        IF l_sr = l_sr1 THEN 
        CALL i072_ins_hrbh(g_head.hrde01,g_head.hrde02,                                  #add by shenran 130905
                              g_head.hrde03,g_head.hrde04)
        END IF       
        
END FUNCTION
	
FUNCTION i072_r()
    IF g_head.hrde01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i072_cl USING g_head.hrde01,g_head.hrde02,g_head.hrde03,g_head.hrde04
    IF STATUS THEN
       CALL cl_err("OPEN i072_cl:", STATUS, 0)
       CLOSE i072_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i072_cl INTO g_head.hrde01,g_head.hrde02,g_head.hrde03,g_head.hrde04
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_head.hrde01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i072_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrde01"   
       LET g_doc.value1 = g_head.hrde01       
       CALL cl_del_doc()
       DELETE FROM hrde_file WHERE hrde01 = g_head.hrde01
                               AND hrde02 = g_head.hrde02
                               AND hrde03 = g_head.hrde03
                               AND hrde04 = g_head.hrde04
       CLEAR FORM
       OPEN i072_count
       IF STATUS THEN
          CLOSE i072_cl
          CLOSE i072_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i072_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i072_cl
          CLOSE i072_count
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i072_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i072_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i072_fetch('/')
       END IF
    END IF
    CLOSE i072_cl
    COMMIT WORK
END FUNCTION
	
FUNCTION i072_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_head.hrde01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
   OPEN i072_cl USING g_head.hrde01,g_head.hrde02,g_head.hrde03,g_head.hrde04
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i072_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i072_cl INTO g_head.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("hrde01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i072_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL i072_i("u")
      IF INT_FLAG THEN
         LET g_head.* = g_head_t.*
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CALL i072_show()
         EXIT WHILE
      END IF
      UPDATE hrde_file SET hrde03=g_head.hrde03
                     WHERE hrde01 = g_head_t.hrde01
                       AND hrde02 = g_head_t.hrde02
                       AND hrde03 = g_head_t.hrde03
                       AND hrde04 = g_head_t.hrde04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","hrde_file",g_head_t.hrde01,'',SQLCA.sqlcode,"","",1) #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
	
FUNCTION i072_b()
   DEFINE l_ac_t          LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #檢查重複用
          l_lock_sw       LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #單身鎖住否
          p_cmd           LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #處理狀態
          l_allow_insert  LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #可新增否
          l_allow_delete  LIKE type_file.num5      #No.FUN-680102 SMALLINT               #可刪除否
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
                      #FUN-510041 add hrde05
   LET g_forupd_sql = " SELECT hrde05,hrde06,hrdeud01,hrdeud02",    #mod by zhangbo130906
                      "   FROM hrde_file ",  
                      "  WHERE hrde01= ? AND hrde02= ? ",
                      "    AND hrde03= ? AND hrde04= ? AND hrde05= ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i072_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_hrde WITHOUT DEFAULTS FROM s_hrde.*
         ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_rec_b,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=TRUE,
                   APPEND ROW=TRUE)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac      = ARR_CURR()
         LET l_n       = ARR_COUNT()
         LET l_lock_sw = 'N'            #DEFAULT
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_hrde_t.* = g_hrde[l_ac].*  #BACKUP
            OPEN i072_bcl USING g_head.hrde01,g_head.hrde02,
                                g_head.hrde03,g_head.hrde04,g_hrde_t.hrde05
            IF STATUS THEN
               CALL cl_err("OPEN i072_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i072_bcl INTO g_hrde[l_ac].hrde05,g_hrde[l_ac].hrde06
                                   #g_hrde[l_ac].hrde07     #mark by zhangbo130906
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrde_t.hrde05,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_hrde[l_ac].* TO NULL      #900423
         LET g_hrde_t.* = g_hrde[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrde06
         
      AFTER FIELD hrde06
         IF NOT cl_null(g_hrde[l_ac].hrde06) THEN
         	  IF g_hrde[l_ac].hrde06<0 THEN
         	  	 CALL cl_err("基本薪资不可小于0","!",0)
         	  	 NEXT FIELD hrde06
         	  END IF	 
         END IF 
 
          
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO hrde_file(hrde01,hrde02,hrde03,hrde04,hrde05,hrde06,hrde07,
                               hrde08,hrde09,hrde10,hrde11,                     #ad by zhangbo130906
                               hrdeuser,hrdegrup,hrdeoriu,hrdeorig,hrdedate,hrdeacti)
                       VALUES(g_head.hrde01,g_head.hrde02,
                              g_head.hrde03,g_head.hrde04,
                              g_hrde[l_ac].hrde05,
                              g_hrde[l_ac].hrde06,   
                              #g_hrde[l_ac].hrde07,        #mark by zhangbo130906 
                              g_head.hrde07,g_head.hrde08, #add by zhangbo130906
                              g_head.hrde09,g_head.hrde10, #add by zhangbo130906
                              g_head.hrde11,               #add by zhangbo130906
                              g_user,g_grup,g_user,g_grup,g_today,'Y')
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrde_file",g_hrde[l_ac].hrde05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_hrde_t.hrde05 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM hrde_file WHERE hrde01 = g_head.hrde01
                                    AND hrde02 = g_head.hrde02
                                    AND hrde03 = g_head.hrde03
                                    AND hrde04 = g_head.hrde04
                                    AND hrde05 = g_hrde_t.hrde05
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrde_file",g_hrde_t.hrde05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
            
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrde[l_ac].* = g_hrde_t.*
            CLOSE i072_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrde[l_ac].hrde05,-263,1)
            LET g_hrde[l_ac].* = g_hrde_t.*
         ELSE
            UPDATE hrde_file SET hrde06=g_hrde[l_ac].hrde06,
                                 hrdeud01=g_hrde[l_ac].hrdeud01,
                                 hrdeud02=g_hrde[l_ac].hrdeud02
                                 #hrde07=g_hrde[l_ac].hrde07    #mark by zhangbo130906  
             WHERE hrde01 = g_head.hrde01
               AND hrde02 = g_head.hrde02
               AND hrde03 = g_head.hrde03
               AND hrde04 = g_head.hrde04
               AND hrde05 = g_hrde_t.hrde05 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrde_file",g_head.hrde01,g_hrde_t.hrde05,SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_hrde[l_ac].* = g_hrde_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_hrde[l_ac].* = g_hrde_t.*
            END IF
            CLOSE i072_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i072_bcl
         COMMIT WORK
 
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
 
      #No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
      #No.FUN-6B0030-----End------------------     
 
   END INPUT
 
   CLOSE i072_bcl
 
   COMMIT WORK
 
END FUNCTION
	
FUNCTION i072_b_fill()  
   DEFINE p_wc   LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
   LET g_sql = "SELECT hrde05,hrde06,hrdeud01,hrdeud02",                #mod by zhangbo130906
               "  FROM hrde_file ",                                         #FUN-B80058 add hrde071,hrde141
               " WHERE hrde01 = '",g_head.hrde01,"' ",
               "   AND hrde02 = '",g_head.hrde02,"' ",
               "   AND hrde03 = '",g_head.hrde03,"' ",
               "   AND hrde04 = '",g_head.hrde04,"' ",     
               " ORDER BY hrde05"
   PREPARE i072_pb FROM g_sql
   DECLARE hrde_curs CURSOR FOR i072_pb
 
   CALL g_hrde.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH hrde_curs INTO g_hrde[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_hrde.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
	
FUNCTION i072_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   
   DIALOG ATTRIBUTES(UNBUFFERED)
      
      DISPLAY ARRAY g_hrde TO s_hrde.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
             CALL cl_navigator_setting(g_curs_index, g_row_count)               
            
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()    
      END DISPLAY 
         
        
         ON ACTION pg2
            LET g_flag = "pg2"
            EXIT DIALOG

         ON ACTION piliang
            LET g_action_choice="piliang"
            EXIT DIALOG
            
         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
            EXIT DIALOG
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG
         #ON ACTION modify
         #   LET g_action_choice="modify"
         #   EXIT DIALOG   
         ON ACTION next
            LET g_action_choice="next"
            EXIT DIALOG
         ON ACTION previous
            LET g_action_choice="previous" 
            EXIT DIALOG     
         ON ACTION jump
            LET g_action_choice="jump" 
            EXIT DIALOG
         ON ACTION first
            LET g_action_choice="first" 
            EXIT DIALOG
         ON ACTION last
            LET g_action_choice="last"    
            EXIT DIALOG                                    
                                
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG
      
         ON ACTION locale
            CALL cl_dynamic_locale()
             CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
      
         ##########################################################################
         # Special 4ad ACTION
         ##########################################################################
         ON ACTION controlg 
            LET g_action_choice="controlg"
            EXIT DIALOG
      
         ON ACTION accept
            LET g_action_choice="detail"
            LET l_ac = ARR_CURR()
            EXIT DIALOG
      
         ON ACTION cancel
            LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice="exit"
            EXIT DIALOG
            
         ON ACTION close
            LET g_action_choice="exit"
            EXIT DIALOG   

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
      
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
      
         ON ACTION exporttoexcel   #No.FUN-4B0020
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
      
      END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
	
FUNCTION i072_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
   DEFINE   l_wc   LIKE type_file.chr1000
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
    DIALOG ATTRIBUTES(UNBUFFERED)
    
   
        DISPLAY ARRAY g_tree TO tree.* 
         BEFORE DISPLAY 
            CALL cl_navigator_setting( g_curs_index, g_row_count )
             
         BEFORE ROW
            LET l_ac = ARR_CURR()
            LET l_tree_ac = ARR_CURR()            
            LET g_curr_idx = ARR_CURR()  
            CALL i072_col_fill(g_tree[l_tree_ac].id) 	    
                        
         
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG
                                    
                                       
      END DISPLAY 
     
            
      DISPLAY ARRAY g_col TO s_col.*  ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
                                        
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG
           
      END DISPLAY 
                                               
 
      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()               
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()          
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG   
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
                                                                                      
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
	
FUNCTION i072_gen()
DEFINE  l_hrde    RECORD LIKE hrde_file.*
DEFINE  l_n       LIKE  type_file.num5
DEFINE  lc_qbe_sn  LIKE gbm_file.gbm01
DEFINE  p_row,p_col  LIKE type_file.num5
DEFINE  l_zl      DYNAMIC ARRAY OF RECORD
          sel     LIKE   type_file.chr1,
          code    LIKE   type_file.chr100,
          name    LIKE   type_file.chr1000
                  END RECORD
DEFINE l_allow_insert  LIKE type_file.num5
DEFINE l_allow_deLETe  LIKE type_file.num5  
DEFINE l_check         LIKE type_file.chr1
DEFINE l_i,l_cnt       LIKE type_file.num5 
DEFINE l_hrag      DYNAMIC ARRAY OF RECORD
         hrag06    LIKE   hrag_file.hrag06
                   END RECORD 
DEFINE   i          LIKE   type_file.num5
DEFINE   li_k                    LIKE type_file.num5
DEFINE   li_i_r                  LIKE type_file.num5
DEFINE   lr_err       DYNAMIC ARRAY OF RECORD
            line    STRING,
            key1    STRING,
            err     STRING
       END RECORD    
DEFINE l_sql  STRING                                
DEFINE l_hraa12     LIKE    hraa_file.hraa12      #add by zhangbo130909
DEFINE l_hrdh12     LIKE    hrdh_file.hrdh12
DEFINE l_sr         LIKE    type_file.num5

	LET gs_wc=NULL
	CLEAR FORM
	      
        INPUT l_hrde.hrde01,l_hrde.hrde02,
              l_hrde.hrde08,l_hrde.hrde09,                    #add by zhangbo130909
              l_hrde.hrde04,
              l_hrde.hrde10,l_hrde.hrde11,l_hrde.hrde07       #add by zhangbo130909
          WITHOUT DEFAULTS FROM hrde01,hrde02,
                                hrde08,hrde09,                #add by zhangbo130909 
                                hrde04,
                                hrde10,hrde11,hrde07          #add by zhangbo130909 
         
        BEFORE INPUT 
           IF cl_null(l_hrde.hrde01) THEN
           	  CALL cl_set_comp_entry("hrde02,hrde04",FALSE)
                  CALL cl_set_comp_entry("hrde08,hrde09,hrde10,hrde11",FALSE)    #add by zhangbo130909
           ELSE
           	  CALL cl_set_comp_entry("hrde02,hrde04",TRUE)
                  CALL cl_set_comp_entry("hrde08,hrde09,hrde10,hrde11",TRUE)    #add by zhangbo130909
           END IF
           	
        AFTER FIELD hrde01
           IF NOT cl_null(l_hrde.hrde01) THEN
           	  LET l_n=0
           	  SELECT COUNT(*) INTO l_n FROM hrde_file WHERE hrde01=l_hrde.hrde01
           	  IF l_n>0 THEN
            	   SELECT DISTINCT hrde02,hrde04 INTO l_hrde.hrde02,l_hrde.hrde04
            	     FROM hrde_file WHERE hrde01=l_hrde.hrde01
                   #add by zhangbo130909----begin
                   SELECT DISTINCT hrde08,hrde09,hrde10,hrde11
                     INTO l_hrde.hrde08,l_hrde.hrde09,l_hrde.hrde10,l_hrde.hrde11
                     FROM hrde_file WHERE hrde01=l_hrde.hrde01
                   SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=l_hrde.hrde08
                   DISPLAY l_hrde.hrde08 TO hrde08
                   DISPLAY l_hrde.hrde09 TO hrde09
                   DISPLAY l_hrde.hrde10 TO hrde10
                   DISPLAY l_hrde.hrde11 TO hrde11
                   DISPLAY l_hraa12 TO hraa12 
                   #add by zhangbo130909----end                       
            	   DISPLAY l_hrde.hrde02 TO hrde02
            	   DISPLAY l_hrde.hrde04 TO hrde04
            	   CALL cl_set_comp_entry("hrde02,hrde04",FALSE)
                   CALL cl_set_comp_entry("hrde08,hrde09,hrde10,hrde11",FALSE)    #add by zhangbo130909
              ELSE
            	   CALL cl_set_comp_entry("hrde02,hrde04",TRUE)
                   LET l_hrde.hrde10=g_today         #add by zhangbo130909
                   LET l_hrde.hrde11=g_today         #add by zhangbo130909
                   DISPLAY l_hrde.hrde10 TO hrde10   #add by zhangbo130909 
                   DISPLAY l_hrde.hrde11 TO hrde11   #add by zhangbo130909
                   CALL cl_set_comp_entry("hrde08,hrde09,hrde10,hrde11",TRUE)    #add by zhangbo130909
              END IF
           END IF
              	
        AFTER FIELD hrde02
           IF NOT cl_null(l_hrde.hrde02) THEN
           	  LET l_n=0
           	  SELECT COUNT(*) INTO l_n FROM hrde_file WHERE hrde02=l_hrde.hrde02
           	  IF l_n>0 THEN
           	  	 CALL cl_err("该名称已对应到其他编号,请检查","!",0)
           	  	 NEXT FIELD hrde02
           	  END IF
           END IF
        
        #add by zhangbo130909---begin
        AFTER FIELD hrde08
           IF NOT cl_null(l_hrde.hrde08) THEN
              LET l_n=0
              SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa01=l_hrde.hrde08
              IF l_n=0 THEN
                 CALL cl_err("此公司不存在","!",0)
                 NEXT FIELD hrde08
              END IF
              SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=l_hrde.hrde08
              DISPLAY l_hraa12 TO hraa12
           END IF  
        #add by zhangbo130909---end
           	
        AFTER INPUT
           IF INT_FLAG THEN
              EXIT INPUT
           END IF 
           IF l_hrde.hrde01 IS NULL THEN
           	  NEXT FIELD hrde01
           END IF
           	
           IF l_hrde.hrde02 IS NULL THEN
           	  NEXT FIELD hrde02
           END IF
           	
           IF l_hrde.hrde04 IS NULL THEN
           	  NEXT FIELD hrde04
           END IF			 
        
        #add by zhangbo130909---begin
        ON ACTION controlp
           CASE
              WHEN INFIELD(hrde08)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = l_hrde.hrde08
              CALL cl_create_qry() RETURNING l_hrde.hrde08
              DISPLAY l_hrde.hrde08 TO hrde08
              NEXT FIELD hrde08
           END CASE
        #add by zhangbo130909---end   	   		  		       	   		  	   
	      
	ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
        ON ACTION about         
            CALL cl_about()      
 
        ON ACTION help          
            CALL cl_show_help()
 
        ON ACTION exit      
            LET INT_FLAG = 1
            EXIT INPUT  
       END INPUT
        
       IF INT_FLAG THEN
          LET INT_FLAG=0
          RETURN
       END IF
       	
       DROP TABLE i072_tmp
       IF l_hrde.hrde04='0' THEN
          SELECT hrar03 code,hrar04 name FROM hrar_file
           WHERE hrar03 NOT IN (SELECT hrde03 FROM hrde_file 
                                 WHERE hrde01=l_hrde.hrde01
                                   AND hrde02=l_hrde.hrde02
                                   AND hrde04=l_hrde.hrde04
                                )
           INTO TEMP i072_tmp
       END IF
       	
       IF l_hrde.hrde04='1' THEN
          SELECT hras01 code,hras04 name FROM hras_file
           WHERE hras01 NOT IN (SELECT hrde03 FROM hrde_file 
                                 WHERE hrde01=l_hrde.hrde01
                                   AND hrde02=l_hrde.hrde02
                                   AND hrde04=l_hrde.hrde04
                                )
           INTO TEMP i072_tmp
       END IF	
       	
       IF l_hrde.hrde04='2' THEN
          SELECT hrag06 code,hrag07 name FROM hrag_file
           WHERE hrag06 NOT IN (SELECT hrde03 FROM hrde_file 
                                 WHERE hrde01=l_hrde.hrde01
                                   AND hrde02=l_hrde.hrde02
                                   AND hrde04=l_hrde.hrde04
                                )
             AND hrag01='649'                   
            INTO TEMP i072_tmp
       END IF	
       	
       IF STATUS THEN 
         CALL cl_err('ins i072_tmp:',STATUS,1)
         CLEAR FORM 
         RETURN 
       END IF
       	
       LET p_row=3   LET p_col=6

       OPEN WINDOW i072_m_w AT p_row,p_col WITH FORM "ghr/42f/ghri072_m"
              ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_locale("ghri072_m")
      
      IF l_hrde.hrde04='0' THEN
      	 CALL cl_set_comp_att_text("code","职务编号")
      	 CALL cl_set_comp_att_text("name","职务名称")
      END IF
      
      IF l_hrde.hrde04='1' THEN
      	 CALL cl_set_comp_att_text("code","职位编号")
      	 CALL cl_set_comp_att_text("name","职位名称")
      END IF	
      	
      IF l_hrde.hrde04='2' THEN
      	 CALL cl_set_comp_att_text("code","代码组编号")
      	 CALL cl_set_comp_att_text("name","代码组名称")
      END IF	
      		  
      
      WHILE TRUE
      CLEAR FORM
      LET l_check='N'

      CONSTRUCT gs_wc ON code FROM s_zl[1].code

      BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)
           
           

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
               

       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121

       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121

       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()

     END CONSTRUCT

     IF INT_FLAG THEN
     	   LET INT_FLAG=0
         DROP TABLE i072_tmp
         CLOSE WINDOW i072_m_w
         RETURN
     END IF
     	
     LET l_sql=" SELECT 'N',code,name ",
               "   FROM i072_tmp ",
               "  WHERE ",gs_wc CLIPPED,
               "  ORDER BY code,name"


      PREPARE i072_m_pre FROM l_sql
      DECLARE i072_m_cs CURSOR FOR i072_m_pre

      LET i=1
      CALL l_zl.clear()

      FOREACH i072_m_cs INTO l_zl[i].*   
         
        LET i=i+1

      END FOREACH
      
      CALL l_zl.deleteElement(i)
      LET i=i-1

      INPUT ARRAY l_zl WITHOUT DEFAULTS FROM s_zl.*
            ATTRIBUTE(COUNT=i,MAXCOUNT=i,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_deLETe,APPEND ROW=l_allow_insert)

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         FOR g_cnt=1 TO i
            IF l_zl[g_cnt].sel='Y' AND l_zl[g_cnt].sel IS NOT NULL
               AND l_zl[g_cnt].sel <>' ' THEN
               CONTINUE FOR
            END IF
            IF l_zl[g_cnt].code IS NULL THEN CONTINUE FOR END IF

            DELETE FROM i072_tmp WHERE code=l_zl[g_cnt].code

         END FOR
               
      ON ACTION reconstruct
         LET l_check='Y'
         EXIT INPUT

      END INPUT
      	
      IF l_check='Y' THEN
         CALL l_zl.clear()
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF

      END WHILE
      
      CLOSE WINDOW i072_m_w	 		
      
      IF INT_FLAG THEN
          LET INT_FLAG=0
          DROP TABLE i072_tmp
          RETURN
      END IF 
      	
      LET l_n=0
      LET l_sql=" SELECT COUNT(*) FROM i072_tmp WHERE ",gs_wc

      PREPARE i072_sel_count FROM l_sql
      EXECUTE i072_sel_count INTO l_n

      IF l_n=0 THEN
         DROP TABLE i072_tmp
         RETURN
      END IF
      	
      LET l_sql=" SELECT DISTINCT hrag06 FROM hrag_file WHERE hrag01='648' "
      
      PREPARE i072_hrag06_pre FROM l_sql
      DECLARE i072_hrag06_cs CURSOR FOR i072_hrag06_pre
      
      LET l_i=1
      
      FOREACH i072_hrag06_cs INTO l_hrag[l_i].*
         
          LET l_i=l_i+1
          
      END FOREACH
      CALL l_hrag.deleteElement(l_i)
      LET l_i=l_i-1
      
      IF l_i<1 THEN
      	 CALL cl_err("代码组中等级未维护","!",0)
      	 DROP TABLE i072_tmp
         RETURN
      END IF   
      	 
          
      	
      	
      LET g_success='Y'
      LET li_k=1
       
      BEGIN WORK
       
        
      LET l_sql=" SELECT code FROM i072_tmp WHERE ",gs_wc
       
      PREPARE i072_sel_pre FROM l_sql 
      DECLARE i072_sel CURSOR FOR i072_sel_pre
       
      FOREACH i072_sel INTO l_hrde.hrde03
          
         FOR l_cnt=1 TO l_i 
            LET l_hrde.hrde05=l_hrag[l_cnt].hrag06
            LET l_hrde.hrde06=0
            LET l_hrde.hrdeuser=g_user
            LET l_hrde.hrdegrup=g_grup
            LET l_hrde.hrdeoriu=g_user
            LET l_hrde.hrdeorig=g_grup
            LET l_hrde.hrdedate=g_today
            LET l_hrde.hrdeacti='Y' 
               
            INSERT INTO hrde_file VALUES (l_hrde.*)
            
            IF SQLCA.sqlcode THEN  
               LET g_success='N'
               LET lr_err[li_k].line=li_k
               LET lr_err[li_k].key1=l_hrde.hrde01
               LET lr_err[li_k].err=SQLCA.sqlcode
               LET li_k=li_k+1
               CONTINUE FOR
            END IF 

        END FOR
        LET l_hrdh12='hrde',l_hrde.hrde01
        SELECT COUNT(*) INTO l_sr FROM hrdh_file WHERE  hrdh12=l_hrdh12
          IF l_sr='0' THEN 
           CALL i072_ins_hrbh(l_hrde.hrde01,l_hrde.hrde02,                                  #add by shenran 130905
                              l_hrde.hrde03,l_hrde.hrde04)
         END IF 
      END FOREACH
       
      DROP TABLE i072_tmp
            
       IF lr_err.getLength() > 0 THEN
          ROLLBACK WORK
          CALL cl_show_array(base.TypeInfo.create(lr_err),cl_getmsg("lib-314",g_lang),"序号|编号|错误描述")
       ELSE
          COMMIT WORK
          CALL cl_replace_str(gs_wc,'code','hrde03') RETURNING gs_wc
          LET gs_wc=gs_wc," AND hrde01='",l_hrde.hrde01,"' AND hrde02='",l_hrde.hrde02,"' AND hrde04='",l_hrde.hrde04,"'" 
          CALL i072_q()  
       END IF		     	
       		      
END FUNCTION
	
FUNCTION i072_col_fill(p_hrde01)
DEFINE p_hrde01    LIKE    hrde_file.hrde01
DEFINE l_sql       STRING 
DEFINE i,l_i       LIKE   type_file.num5
DEFINE l_txt       DYNAMIC ARRAY OF RECORD
         hrde05    LIKE   hrde_file.hrde05
                   END RECORD
DEFINE l_field  LIKE type_file.chr10 
DEFINE l_str    LIKE type_file.chr10
DEFINE li_txt    LIKE hrag_file.hrag07
DEFINE l_sql1   STRING
DEFINE l_sql2   STRING
DEFINE l_col    RECORD 
         col1         LIKE type_file.chr100,
         col2         LIKE hrde_file.hrde06,
         col3         LIKE hrde_file.hrde06,
         col4         LIKE hrde_file.hrde06,
         col5         LIKE hrde_file.hrde06,
         col6         LIKE hrde_file.hrde06,
         col7         LIKE hrde_file.hrde06,
         col8         LIKE hrde_file.hrde06,
         col9         LIKE hrde_file.hrde06,
         col10        LIKE hrde_file.hrde06,
         col11        LIKE hrde_file.hrde06,
         col12        LIKE hrde_file.hrde06,
         col13        LIKE hrde_file.hrde06,
         col14        LIKE hrde_file.hrde06,
         col15        LIKE hrde_file.hrde06,
         col16        LIKE hrde_file.hrde06,
         col17        LIKE hrde_file.hrde06,
         col18        LIKE hrde_file.hrde06,
         col19        LIKE hrde_file.hrde06,
         col20        LIKE hrde_file.hrde06,
         col21      LIKE     hrde_file.hrde06,
         col22      LIKE     hrde_file.hrde06,
         col23      LIKE     hrde_file.hrde06,
         col24      LIKE     hrde_file.hrde06,
         col25      LIKE     hrde_file.hrde06
                END RECORD
DEFINE  l_hrde04      LIKE hrde_file.hrde04
DEFINE  l_hrde03      LIKE hrde_file.hrde03 
DEFINE  l_value       LIKE type_file.chr10
DEFINE  ls_field_str  LIKE type_file.chr1000
DEFINE  ls_value_str  LIKE type_file.chr1000     

       
       SELECT DISTINCT hrde04 INTO l_hrde04 FROM hrde_file WHERE hrde01=p_hrde01
       
       CALL cl_set_comp_visible("col1,col2,col3,col4,col5",FALSE)
       CALL cl_set_comp_visible("col6,col7,col8,col9,coL10",FALSE)
       CALL cl_set_comp_visible("col11,col12,col13,col14,col15",FALSE)
       CALL cl_set_comp_visible("col16,col17,col18,col19,col20",FALSE)     
       CALL cl_set_comp_visible("col21,col22,col23,col24,col25",FALSE)           
     
       DROP TABLE hrde_tmp
       CREATE TEMP TABLE hrde_tmp(
                       col1         LIKE type_file.chr100,
                       col2         LIKE hrde_file.hrde06,
                       col3         LIKE hrde_file.hrde06,
                       col4         LIKE hrde_file.hrde06,
                       col5         LIKE hrde_file.hrde06,
                       col6         LIKE hrde_file.hrde06,
                       col7         LIKE hrde_file.hrde06,
                       col8         LIKE hrde_file.hrde06,
                       col9         LIKE hrde_file.hrde06,
                       col10        LIKE hrde_file.hrde06,
                       col11        LIKE hrde_file.hrde06,
                       col12        LIKE hrde_file.hrde06,
                       col13        LIKE hrde_file.hrde06,
                       col14        LIKE hrde_file.hrde06,
                       col15        LIKE hrde_file.hrde06,
                       col16        LIKE hrde_file.hrde06,
                       col17        LIKE hrde_file.hrde06,
                       col18        LIKE hrde_file.hrde06,
                       col19        LIKE hrde_file.hrde06,
                       col20        LIKE hrde_file.hrde06,
                        col21      LIKE     hrde_file.hrde06,
                        col22      LIKE     hrde_file.hrde06,
                        col23      LIKE     hrde_file.hrde06,
                        col24      LIKE     hrde_file.hrde06,
                        col25      LIKE     hrde_file.hrde06
                                )
      LET l_sql=" SELECT DISTINCT hrde05 FROM hrde_file WHERE hrde01='",p_hrde01,"'",
                " ORDER BY hrde05 "
                
      PREPARE i072_txt_pre FROM l_sql
      DECLARE i072_txt_cs CURSOR FOR i072_txt_pre
      
      LET i=1
      LET l_txt[i].hrde05=' '
      LET i=i+1
      
      FOREACH i072_txt_cs INTO l_txt[i].hrde05
         
         LET i=i+1
         
      END FOREACH
      
      CALL l_txt.deleteElement(i)
      LET i=i-1
      
      FOR l_i=1 TO i
         LET l_field=''
         LET l_str=l_i
         LET l_field='col' CLIPPED,l_str CLIPPED
         
         IF l_i=1 THEN
            CALL cl_set_comp_att_text(l_field,'职务/职位/其他')
            CALL cl_set_comp_visible(l_field,TRUE)
         ELSE    
            SELECT hrag07 INTO li_txt FROM hrag_file WHERE hrag01='648' 
                                                      AND hrag06=l_txt[l_i].hrde05
            CALL cl_set_comp_att_text(l_field,li_txt)
            CALL cl_set_comp_visible(l_field,TRUE)
         END IF   
      
      END FOR
      
      LET l_sql=" SELECT DISTINCT hrde03 FROM hrde_file WHERE hrde01='",p_hrde01,"'",
                "  ORDER BY hrde03"
      
      PREPARE i072_ins_pre FROM l_sql
      DECLARE i072_ins_cs CURSOR FOR i072_ins_pre
      
      FOREACH i072_ins_cs INTO l_hrde03
          
          LET ls_value_str="'",l_hrde03,"'"
          LET ls_field_str="col1"
          FOR l_i=2 TO i
              LET l_field=''
              LET l_value=''
              LET l_str=l_i
              LET l_field='col' CLIPPED,l_str CLIPPED
              LET l_sql1=" SELECT hrde06 FROM hrde_file WHERE hrde01='",p_hrde01,"'",
                        "    AND hrde03='",l_hrde03,"' AND hrde05='",l_txt[l_i].hrde05,"'"
              PREPARE i072_hrde06 FROM l_sql1
              EXECUTE i072_hrde06 INTO l_value
              
              IF cl_null(l_value) THEN LET l_value="''" END IF
              	
              LET ls_value_str=ls_value_str CLIPPED,",",l_value CLIPPED
              LET ls_field_str=ls_field_str CLIPPED,",",l_field CLIPPED
              
              
          END FOR
          
          LET l_sql2=" INSERT INTO hrde_tmp(",ls_field_str,") VALUES (",ls_value_str,")"  

          PREPARE i072_ins_tmp FROM l_sql2
          EXECUTE i072_ins_tmp
 
      END FOREACH
      
      LET l_sql=" SELECT * FROM hrde_tmp WHERE 1=1 ORDER BY col1"
      
      PREPARE i072_fill_pre FROM l_sql
      DECLARE i072_fill_cs CURSOR FOR i072_fill_pre
      
      CALL g_col.clear()
      LET l_i=1
      
      FOREACH i072_fill_cs INTO g_col[l_i].*
          CASE l_hrde04
          	 WHEN '0'
          	     SELECT hrar04 INTO g_col[l_i].col1 FROM hrar_file 
          	      WHERE hrar03=g_col[l_i].col1
          	 WHEN '1'
          	     SELECT hras04 INTO g_col[l_i].col1 FROM hras_file 
          	      WHERE hras01=g_col[l_i].col1
          	 WHEN '2'
          	     SELECT hrag07 INTO g_col[l_i].col1 FROM hrag_file 
          	      WHERE hrag06=g_col[l_i].col1
    	              AND hrag01='649'
    	    END CASE
    	    	
    	    LET l_i=l_i+1
    	    
    	END FOREACH
    	
    	CALL g_col.deleteElement(l_i)
      LET g_rec_b1= l_i-1
      LET l_i = 0
    	    	                  
                                     
END FUNCTION		
#add by shenran 20130905
FUNCTION i072_ins_hrbh(p_hrde01,p_hrde02,p_hrde03,p_hrde04)
DEFINE  p_hrde01   LIKE  hrde_file.hrde01
DEFINE  p_hrde02   LIKE  hrde_file.hrde02
DEFINE  p_hrde03   LIKE  hrde_file.hrde03
DEFINE  p_hrde04   LIKE  hrde_file.hrde04
DEFINE  p_hrde05   LIKE  hrde_file.hrde05
DEFINE  l_hrde     RECORD LIKE hrde_file.*
DEFINE  l_hrdh     RECORD LIKE hrdh_file.*

        SELECT * INTO l_hrde.* FROM hrde_file WHERE hrde01=p_hrde01
                                                AND hrde02=p_hrde02
                                                AND hrde03=p_hrde03
                                                AND hrde04=p_hrde04
                                                AND hrde05='001'
        
        LET l_hrdh.hrdh02='002'
        LET l_hrdh.hrdh10='N'
        LET l_hrdh.hrdh03='001'
        LET l_hrdh.hrdh07='0000'
        LET l_hrdh.hrdhacti='Y'
        LET l_hrdh.hrdhuser=g_user
        LET l_hrdh.hrdhgrup=g_grup
        LET l_hrdh.hrdhoriu=g_user
        LET l_hrdh.hrdhorig=g_grup
        LET l_hrdh.hrdhdate=g_today
        LET l_hrdh.hrdh06=l_hrde.hrde02
        LET l_hrdh.hrdh12="hrde",l_hrde.hrde01                         #add by zhangbo130624
        SELECT MAX(hrdh01) INTO l_hrdh.hrdh01 FROM hrdh_file
        IF l_hrdh.hrdh01 IS NULL THEN
       	   LET l_hrdh.hrdh01=1
        ELSE
       	   LET l_hrdh.hrdh01=l_hrdh.hrdh01+1
        END IF

        SELECT F_TRANS_PINYIN_CAPITAL(l_hrdh.hrdh06) INTO l_hrdh.hrdh13 FROM DUAL    #add by zhangbo130821
 	
        INSERT INTO hrdh_file VALUES (l_hrdh.*)
        
END FUNCTION    	
        
        								
	
			        	
	 						                                    
