# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri028.4gl
# Descriptions...: 企业行事例维护作业
# Date & Author..: 13/05/03 By yangjian

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_head          RECORD 
           hrbk01      LIKE hrbk_file.hrbk01,
           hrbk01_name LIKE type_file.chr100,
           hrbk02      LIKE hrbk_file.hrbk02,
           hrbk10      LIKE hrbk_file.hrbk10,
           cb1         LIKE type_file.num5,
           cb1_name    LIKE type_file.chr100,
           cb2         LIKE type_file.num5,
           cb2_name    LIKE type_file.chr100,
           note        LIKE hrbk_file.hrbk09,
           hrbkuser    LIKE hrbk_file.hrbkuser,
           hrbkgrup    LIKE hrbk_file.hrbkgrup,
           hrbkoriu    LIKE hrbk_file.hrbkoriu,
           hrbkorig    LIKE hrbk_file.hrbkorig,      
           hrbkmodu    LIKE hrbk_file.hrbkmodu,
           hrbkdate    LIKE hrbk_file.hrbkdate,
           hrbkacti    LIKE hrbk_file.hrbkacti,
           hrbk11      LIKE hrbk_file.hrbk10
              END RECORD,     
    g_hrbk           DYNAMIC ARRAY OF RECORD   
        hrbk03       LIKE hrbk_file.hrbk03,  
        hrbk04       LIKE hrbk_file.hrbk04,  
        hrbk05       LIKE hrbk_file.hrbk05,  
        hrbk05_name  LIKE type_file.chr100,
        hrbk06       LIKE hrbk_file.hrbk06,  
        hrbk07       LIKE hrbk_file.hrbk07, 
        hrbk07_name  LIKE type_file.chr100, 
        hrbk08       LIKE hrbk_file.hrbk08,
        hrbk08_name  LIKE type_file.chr100,  
        hrbk09       LIKE hrbk_file.hrbk09,  
        hrbkud01     LIKE hrbk_file.hrbkud01,
        hrbkud02     LIKE hrbk_file.hrbkud02,
        hrbkud03     LIKE hrbk_file.hrbkud03,
        hrbkud04     LIKE hrbk_file.hrbkud04,
        hrbkud05     LIKE hrbk_file.hrbkud05,
        hrbkud06     LIKE hrbk_file.hrbkud06,
        hrbkud07     LIKE hrbk_file.hrbkud07,
        hrbkud08     LIKE hrbk_file.hrbkud08,
        hrbkud09     LIKE hrbk_file.hrbkud09,
        hrbkud10     LIKE hrbk_file.hrbkud10,
        hrbkud11     LIKE hrbk_file.hrbkud11,
        hrbkud12     LIKE hrbk_file.hrbkud12,
        hrbkud13     LIKE hrbk_file.hrbkud13,
        hrbkud14     LIKE hrbk_file.hrbkud14,
        hrbkud15     LIKE hrbk_file.hrbkud15 
                    END RECORD,
    g_hrbk_t         RECORD                 #程式變數 (舊值)
        hrbk03       LIKE hrbk_file.hrbk03,  
        hrbk04       LIKE hrbk_file.hrbk04,  
        hrbk05       LIKE hrbk_file.hrbk05, 
        hrbk05_name  LIKE type_file.chr100, 
        hrbk06       LIKE hrbk_file.hrbk06,  
        hrbk07       LIKE hrbk_file.hrbk07,  
        hrbk07_name  LIKE type_file.chr100,
        hrbk08       LIKE hrbk_file.hrbk08, 
        hrbk08_name  LIKE type_file.chr100, 
        hrbk09       LIKE hrbk_file.hrbk09,  
        hrbkud01     LIKE hrbk_file.hrbkud01,
        hrbkud02     LIKE hrbk_file.hrbkud02,
        hrbkud03     LIKE hrbk_file.hrbkud03,
        hrbkud04     LIKE hrbk_file.hrbkud04,
        hrbkud05     LIKE hrbk_file.hrbkud05,
        hrbkud06     LIKE hrbk_file.hrbkud06,
        hrbkud07     LIKE hrbk_file.hrbkud07,
        hrbkud08     LIKE hrbk_file.hrbkud08,
        hrbkud09     LIKE hrbk_file.hrbkud09,
        hrbkud10     LIKE hrbk_file.hrbkud10,
        hrbkud11     LIKE hrbk_file.hrbkud11,
        hrbkud12     LIKE hrbk_file.hrbkud12,
        hrbkud13     LIKE hrbk_file.hrbkud13,
        hrbkud14     LIKE hrbk_file.hrbkud14,
        hrbkud15     LIKE hrbk_file.hrbkud15 
                    END RECORD,
   #1,8,15,22,29,36 --星期日
   #2,9,16,23,30,37 --星期一
   #3,10,17,24,31,38 --星期二
   #4,11,18,25,32,39 --星期三
   #5,12,19,26,33,40 --星期四
   #6,13,20,27,34,41 --星期五
   #7,14,21,28,35,42 --星期六
    g_sch     DYNAMIC ARRAY OF RECORD     
               sch   STRING,
               sch1  LIKE type_file.dat,
               sch2  LIKE type_file.chr100
                END RECORD,
    g_att     DYNAMIC ARRAY OF RECORD
               sch   STRING,
               sch1  STRING,
               sch2  STRING
                END RECORD,
    g_hrag   RECORD LIKE hrag_file.*,
    g_wc2,g_sql,g_wc3     string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #單身筆數
    l_ac            LIKE type_file.num5,      #No.FUN-680102 SMALLINT               #目前處理的ARRAY CNT
    l_ac1           LIKE type_file.num5
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680102 INTEGER   
DEFINE   g_i             LIKE type_file.num5      #No.FUN-680102 SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING                   #No.FUN-850016                                                                    
DEFINE   g_str           STRING                   #No.FUN-850016   
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數     
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗    
DEFINE g_flag            LIKE type_file.chr10             #add by leo 130503                                                              


MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_head.hrbk01 = ARG_VAL(1) 
   LET g_head.hrbk02 = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
   
   LET g_forupd_sql = "SELECT * FROM hrbk_file WHERE hrbk01 = ? ",
                      "   AND hrbk02 = ? ",
                      "   FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i028_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   OPEN WINDOW i028_w WITH FORM "ghr/42f/ghri028"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   
   LET g_flag ='N'
   CALL cl_set_comp_visible('hrbk08,hrbk08_name',FALSE)
   CALL i028_test()
   CALL i028_menu()
 
   CLOSE WINDOW i028_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i028_menu()
 
   WHILE TRUE
      #默认g_flag = 'N' 当执行第二个页签的ACTION时，将g_flag置成Y；当执行非第二页签的ACTION时，重置为'N'
      IF g_flag ='pg1' THEN   
        CALL i028_bp1("G")   #仅包含第二页签的DISPLAY
      ELSE
      	CALL i028_bp("G")    #包含两个DISPLAY，目前的函数不动
      END IF   
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
            	 CALL i028_a()
            END IF 
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i028_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i028_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
            	 CALL i028_r()
            END IF 
         WHEN "next"
            IF cl_chk_act_auth() THEN
            	 CALL i028_fetch('N')
            END IF    
         WHEN "previous"
            IF cl_chk_act_auth() THEN
            	 CALL i028_fetch('P')
            END IF  
         WHEN "jump"
            IF cl_chk_act_auth() THEN
            	 CALL i028_fetch('/')
            END IF  
         WHEN "first"
            IF cl_chk_act_auth() THEN
            	 CALL i028_fetch('F')
            END IF  
         WHEN "last"
            IF cl_chk_act_auth() THEN
            	 CALL i028_fetch('L')
            END IF   
         WHEN "jan"
            IF cl_chk_act_auth() THEN
            	 CALL i028_month(g_head.cb1,'1')
            END IF  
         WHEN "feb"
            IF cl_chk_act_auth() THEN
            	 CALL i028_month(g_head.cb1,'2')
            END IF
         WHEN "mar"
            IF cl_chk_act_auth() THEN
            	 CALL i028_month(g_head.cb1,'3')
            END IF
         WHEN "apr"
            IF cl_chk_act_auth() THEN
            	 CALL i028_month(g_head.cb1,'4')
            END IF
         WHEN "may"
            IF cl_chk_act_auth() THEN
            	 CALL i028_month(g_head.cb1,'5')
            END IF
         WHEN "jun"
            IF cl_chk_act_auth() THEN
            	 CALL i028_month(g_head.cb1,'6')
            END IF
         WHEN "jul"
            IF cl_chk_act_auth() THEN
            	 CALL i028_month(g_head.cb1,'7')
            END IF
         WHEN "aug"
            IF cl_chk_act_auth() THEN
            	 CALL i028_month(g_head.cb1,'8')
            END IF
         WHEN "sep"
            IF cl_chk_act_auth() THEN
            	 CALL i028_month(g_head.cb1,'9')
            END IF
         WHEN "oct"
            IF cl_chk_act_auth() THEN
            	 CALL i028_month(g_head.cb1,'10')
            END IF
         WHEN "nov"
            IF cl_chk_act_auth() THEN
            	 CALL i028_month(g_head.cb1,'11')
            END IF
         WHEN "dec"
            IF cl_chk_act_auth() THEN
            	 CALL i028_month(g_head.cb1,'12')
            END IF   
         WHEN "cb1_pre"
            IF cl_chk_act_auth() THEN
               CALL i028_cb1(-1)
            END IF     
         WHEN "cb1_next"
            IF cl_chk_act_auth() THEN
               CALL i028_cb1(+1)
            END IF  
         WHEN "cb2_pre"
            IF cl_chk_act_auth() THEN
               CALL i028_cb2(-1)
            END IF 
         WHEN "cb2_next"
            IF cl_chk_act_auth() THEN
               CALL i028_cb2(+1)
            END IF         
         WHEN "upd_note"
            IF cl_chk_act_auth() THEN
            	 CALL i028_upd_note()
            END IF                                                                                                                                                                                                                                       
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              LET g_flag ='N'
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbk),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION


FUNCTION i028_cs()
 
    CLEAR FORM
    INITIALIZE g_head.* TO NULL
    CALL g_sch.clear()
    CALL g_hrbk.clear()
    LET g_wc2 = NULL
    LET g_wc3 = NULL 
    
    CONSTRUCT g_wc2 ON hrbk01,hrbk02,hrbk10,hrbkuser,hrbkgrup,hrbkmodu,hrbkdate,
                       hrbkacti,hrbkoriu,hrbkorig
         FROM hrbk01,hrbk02,hrbk10,hrbkuser,hrbkgrup,hrbkmodu,hrbkdate,
              hrbkacti,hrbkoriu,hrbkorig
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
          

       ON ACTION controlp
          CASE
              WHEN INFIELD(hrbk01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbk01
                 NEXT FIELD hrbk01                                              
           OTHERWISE
              EXIT CASE
           END CASE          
 
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
    
        CONSTRUCT g_wc3 ON  hrbk03,hrbk04,hrbk05,hrbk06,hrbk07,hrbk08,hrbk09,
                       hrbkud01,hrbkud02,hrbkud03,hrbkud04,hrbkud05,
                       hrbkud06,hrbkud07,hrbkud08,hrbkud09,hrbkud10,
                       hrbkud11,hrbkud12,hrbkud13,hrbkud14,hrbkud15
         FROM s_hrbk[1].hrbk03,s_hrbk[1].hrbk04,s_hrbk[1].hrbk05,s_hrbk[1].hrbk06,
              s_hrbk[1].hrbk07,s_hrbk[1].hrbk08,s_hrbk[1].hrbk09, 
              s_hrbk[1].hrbkud01,s_hrbk[1].hrbkud02,s_hrbk[1].hrbkud03,s_hrbk[1].hrbkud04, 
              s_hrbk[1].hrbkud05,s_hrbk[1].hrbkud06,s_hrbk[1].hrbkud07,s_hrbk[1].hrbkud08,
              s_hrbk[1].hrbkud09,s_hrbk[1].hrbkud10,s_hrbk[1].hrbkud11,s_hrbk[1].hrbkud12,
              s_hrbk[1].hrbkud13,s_hrbk[1].hrbkud14,s_hrbk[1].hrbkud15
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
          

       ON ACTION controlp
          CASE
              WHEN INFIELD(hrbk05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '105'
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_hrag06"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbk05
                 NEXT FIELD hrbk05  
              WHEN INFIELD(hrbk07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '326'
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_hrag06"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbk07
                 NEXT FIELD hrbk07  
              WHEN INFIELD(hrbk08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '515'
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_hrag06"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbk08
                 NEXT FIELD hrbk08                                                    
           OTHERWISE
              EXIT CASE
           END CASE          
 
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
    
    
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrbkuser', 'hrbkgrup') #FUN-980030
 
    LET g_sql = "SELECT DISTINCT hrbk01,hrbk02 FROM hrbk_file ",
                " WHERE ",g_wc2 CLIPPED, 
                " ORDER BY hrbk01,hrbk02"
    PREPARE i028_prepare FROM g_sql
    DECLARE i028_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i028_prepare

    LET g_sql = "SELECT COUNT (*) FROM (",
                " SELECT DISTINCT hrbk01,hrbk02 FROM hrbk_file ",
                " WHERE ",g_wc2 CLIPPED ," and ",g_wc3 CLIPPED,
                " ) "
    PREPARE i028_precount FROM g_sql
    DECLARE i028_count CURSOR FOR i028_precount
END FUNCTION
 
FUNCTION i028_q()
 
   CALL i028_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i028_count
    FETCH i028_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i028_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_head.hrbk01,SQLCA.sqlcode,0)
        INITIALIZE g_head.* TO NULL
    ELSE
        CALL i028_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION


FUNCTION i028_fetch(p_flhrbk)
    DEFINE p_flhrbk         LIKE type_file.chr1
 
    CASE p_flhrbk
        WHEN 'N' FETCH NEXT     i028_cs INTO g_head.hrbk01,g_head.hrbk02
        WHEN 'P' FETCH PREVIOUS i028_cs INTO g_head.hrbk01,g_head.hrbk02
        WHEN 'F' FETCH FIRST    i028_cs INTO g_head.hrbk01,g_head.hrbk02
        WHEN 'L' FETCH LAST     i028_cs INTO g_head.hrbk01,g_head.hrbk02
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
            FETCH ABSOLUTE g_jump i028_cs INTO g_head.hrbk01,g_head.hrbk02
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_head.hrbk01,SQLCA.sqlcode,0)
        INITIALIZE g_head.* TO NULL  
        RETURN
    ELSE
      CASE p_flhrbk
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx     
    END IF
 
    SELECT DISTINCT hrbk01,hrbk02,hrbkuser,hrbkgrup,hrbkmodu,hrbkdate,
           hrbkacti,hrbkoriu,hrbkorig
      INTO g_head.hrbk01,g_head.hrbk02,g_head.hrbkuser,g_head.hrbkgrup,
           g_head.hrbkmodu,g_head.hrbkdate,g_head.hrbkacti,
           g_head.hrbkoriu,g_head.hrbkorig
      FROM hrbk_file    # 重讀DB,因TEMP有不被更新特性
     WHERE hrbk01 = g_head.hrbk01
       AND hrbk02 = g_head.hrbk02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrbk_file",g_head.hrbk01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        CALL i028_show()                   # 重新顯示
    END IF
END FUNCTION
 

FUNCTION i028_show()

    DISPLAY BY NAME g_head.hrbk01,g_head.hrbk02,
                    g_head.hrbkuser,g_head.hrbkgrup,g_head.hrbkmodu,
                    g_head.hrbkdate,g_head.hrbkacti,g_head.hrbkorig,g_head.hrbkoriu
    CALL i028_hrbk01('d')
    CALL cl_show_fld_cont()
    
    CALL i028_b_fill()
    CALL i028_month(g_head.hrbk02,'1')
END FUNCTION


FUNCTION i028_a()
 DEFINE l_hrbk   RECORD LIKE hrbk_file.*
 DEFINE l_ifsd LIKE type_file.num5
 DEFINE l_flag LIKE type_file.num5

    CLEAR FORM 
    INITIALIZE g_head.* TO NULL
    INITIALIZE l_hrbk.* TO NULL
    CALL g_sch.clear()
    CALL g_hrbk.clear()
    CALL cl_opmsg('a')
    WHILE TRUE
    	LET g_head.hrbk10 = 'N'
    	LET g_head.hrbk11 = 'N'
        LET g_head.hrbkuser = g_user
        LET g_head.hrbkoriu = g_user 
        LET g_head.hrbkorig = g_grup 
        LET g_head.hrbkgrup = g_grup               #使用者所屬群
        LET g_head.hrbkdate = g_today
        LET g_head.hrbkacti = 'Y'
        CALL i028_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
        	  CALL g_hrbk.clear()
        	  CALL g_sch.clear()  
        	  INITIALIZE g_head.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_head.hrbk01 IS NULL OR g_head.hrbk02 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        
        LET g_success = 'Y'
        BEGIN WORK
        CALL s_showmsg_init()
        LET l_hrbk.hrbk01 = g_head.hrbk01
        LET l_hrbk.hrbk02 = g_head.hrbk02
        LET l_hrbk.hrbk10 = g_head.hrbk10 
        LET l_hrbk.hrbk07 = '001'
       #------------ 
#        LET g_sql = "select a,CASE TO_CHAR(a,'d') ",
#                    "          WHEN '1' THEN '7' ",
#                    "          WHEN '2' THEN '1' ",
#                    "          WHEN '3' THEN '2' ",
#                    "          WHEN '4' THEN '3' ",
#                    "          WHEN '5' THEN '4' ",
#                    "          WHEN '6' THEN '5' ",
#                    "          WHEN '7' THEN '6' ",
#                    "          END  FROM(        ",
#                    " SELECT TO_DATE('",g_head.hrbk02,"0101', 'yyyymmdd') + (rownum - 1) a  ",
#                    "   FROM dual ",
#                    "  CONNECT BY ROWNUM <= TO_CHAR(TO_DATE('",g_head.hrbk02,"1231', 'yyyymmdd'), 'ddd') ",
#                    ")"
       #------------------ 
               LET g_sql = "select a,CASE TO_CHAR(a,'d') ",
                    "          WHEN '1' THEN '7' ",
                    "          WHEN '2' THEN '1' ",
                    "          WHEN '3' THEN '2' ",
                    "          WHEN '4' THEN '3' ",
                    "          WHEN '5' THEN '4' ",
                    "          WHEN '6' THEN '5' ",
                    "          WHEN '7' THEN '6' ",
                    "          END, mod(to_number(TO_CHAR(a,'iw')),2)  FROM(        ",
                    " SELECT TO_DATE('",g_head.hrbk02,"0101', 'yyyymmdd') + (rownum - 1) a  ",
                    "   FROM dual ",
                    "  CONNECT BY ROWNUM <= TO_CHAR(TO_DATE('",g_head.hrbk02,"1231', 'yyyymmdd'), 'ddd') ",
                    ")"
       ------------------------- 
#add by yinbq 20141208 for 调整单双休判断逻辑，原逻辑可能存在每一个周末当成上一年最后一周的问题 
        LET l_flag = 0                        
#add by yinbq 20141208 for 调整单双休判断逻辑，原逻辑可能存在每一个周末当成上一年最后一周的问题 
        PREPARE i028_insert_prep FROM g_sql
        DECLARE i028_insert_cs CURSOR FOR i028_insert_prep 
        FOREACH i028_insert_cs INTO l_hrbk.hrbk03,l_hrbk.hrbk04,l_ifsd
           IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
#add by yinbq 20141208 for 调整单双休判断逻辑，原逻辑可能存在每一个周末当成上一年最后一周的问题 
           IF l_hrbk.hrbk04 = 6 THEN
              LET l_flag = l_flag + 1
              SELECT  MOD(l_flag,2) INTO l_ifsd FROM DUAL
           END IF
#add by yinbq 20141208 for 调整单双休判断逻辑，原逻辑可能存在每一个周末当成上一年最后一周的问题 
           CASE 
              WHEN MONTH(l_hrbk.hrbk03) = 1 AND DAY(l_hrbk.hrbk03) = 1
                 LET l_hrbk.hrbk05 = '003'
                 LET l_hrbk.hrbk06 = '元旦'              
              WHEN MONTH(l_hrbk.hrbk03) = 5 AND DAY(l_hrbk.hrbk03) = 1
                 LET l_hrbk.hrbk05 = '003'
                 LET l_hrbk.hrbk06 = '劳动节'
              WHEN MONTH(l_hrbk.hrbk03) = 10 AND DAY(l_hrbk.hrbk03) MATCHES '[123]'
                 LET l_hrbk.hrbk05 = '003'
                 LET l_hrbk.hrbk06 = '国庆节'   
#              WHEN l_hrbk.hrbk10 = 'Y' AND l_hrbk.hrbk04 MATCHES '[6]'
#              	  LET l_hrbk.hrbk05 = '001'
#              	  LET l_hrbk.hrbk06 = '工作日'
              WHEN l_hrbk.hrbk10 = 'Y' AND l_hrbk.hrbk04 MATCHES '[6]'
              	  LET l_hrbk.hrbk05 = '001'
              	  LET l_hrbk.hrbk06 = '工作日'
              WHEN g_head.hrbk11 = 'Y' AND l_ifsd=1 AND l_hrbk.hrbk04 MATCHES '[6]' 
              	  LET l_hrbk.hrbk05 = '001'
              	  LET l_hrbk.hrbk06 = '工作日' 	  
              WHEN l_hrbk.hrbk04 MATCHES '[67]'
              	  LET l_hrbk.hrbk05 = '002'
              	  LET l_hrbk.hrbk06 = '公休'
              OTHERWISE
                 LET l_hrbk.hrbk05 = '001'
                 LET l_hrbk.hrbk06 = '工作日'
           END CASE         	        
           INSERT INTO hrbk_file VALUES(l_hrbk.*)
           IF SQLCA.sqlcode THEN
           	  LET g_success = 'N'
           	  CALL s_errmsg("hrbk03",l_hrbk.hrbk03,"ins err",SQLCA.sqlcode,1)
              CONTINUE WHILE
           END IF
        END FOREACH
        IF g_success = 'Y' THEN 
        	 COMMIT WORK
        	 MESSAGE "Generate Success..."
        ELSE 
           ROLLBACK WORK
           MESSAGE "Generate Fail..."
           CALL s_showmsg()
        END IF 
        EXIT WHILE
    END WHILE
    CALL i028_show()
END FUNCTION

FUNCTION i028_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_hrat04      LIKE hrat_file.hrat04
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
 
   DISPLAY BY NAME g_head.hrbk01,g_head.hrbk01_name,g_head.cb1,g_head.cb2,g_head.note,
                   g_head.hrbkuser,g_head.hrbkgrup,g_head.hrbkacti,
                   g_head.hrbkmodu,g_head.hrbkdate,g_head.hrbkoriu,g_head.hrbkorig
 
   INPUT BY NAME
      g_head.hrbk01,g_head.hrbk02,g_head.hrbk10 
      WITHOUT DEFAULTS
 
      BEFORE INPUT
 
      AFTER FIELD hrbk01
         IF g_head.hrbk01 IS NOT NULL THEN
         #   CALL i028_hrbk01('a')
         #   IF NOT cl_null(g_errno) THEN
         #      CALL cl_err('hrbk01:',g_errno,1)
         #      LET g_head.hrbk01 = NULL
         #      NEXT FIELD hrbk01
         #   ELSE 
         #   
         #   END IF
         END IF

    #证件类型
      AFTER FIELD hrbk02
         IF NOT cl_null(g_head.hrbk02) THEN
            CALL i028_hrbk02()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('hrbk02:',g_errno,1)
               LET g_head.hrbk02 = NULL
               NEXT FIELD hrbk02
            ELSE 
            
            END IF
         END IF         	
         
      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

     ON ACTION controlp
        CASE
              WHEN INFIELD(hrbk01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.default1 = g_head.hrbk01
                 CALL cl_create_qry() RETURNING g_head.hrbk01
                 DISPLAY g_head.hrbk01 TO hrbk01
                 NEXT FIELD hrbk01
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


FUNCTION i028_r()
    IF g_head.hrbk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i028_cl USING g_head.hrbk01,g_head.hrbk02
    IF STATUS THEN
       CALL cl_err("OPEN i028_cl:", STATUS, 0)
       CLOSE i028_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i028_cl INTO g_head.hrbk01,g_head.hrbk02
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_head.hrbk01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i028_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrbk01"   
       LET g_doc.value1 = g_head.hrbk01 
       LET g_doc.column2 = "hrbk02"   
       LET g_doc.value2 = g_head.hrbk02        

       CALL cl_del_doc()
       DELETE FROM hrbk_file WHERE hrbk01 = g_head.hrbk01
                               AND hrbk02 = g_head.hrbk02
       CLEAR FORM
       OPEN i028_count
       IF STATUS THEN
          CLOSE i028_cl
          CLOSE i028_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i028_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i028_cl
          CLOSE i028_count
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i028_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i028_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i028_fetch('/')
       END IF
    END IF
    CLOSE i028_cl
    COMMIT WORK
END FUNCTION


FUNCTION i028_b()
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
 
                      #FUN-510041 add hrbk05
   LET g_forupd_sql = " SELECT hrbk03 ",
                      "   FROM hrbk_file ",  #TQC-B30004 
                      "  WHERE hrbk01= ? AND hrbk02= ? ",
                      "    AND hrbk03= ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i028_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_hrbk WITHOUT DEFAULTS FROM s_hrbk.*
         ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,
                   APPEND ROW=FALSE)
 
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
            LET g_hrbk_t.* = g_hrbk[l_ac].*  #BACKUP
            OPEN i028_bcl USING g_head.hrbk01,g_head.hrbk02,g_hrbk_t.hrbk03
            IF STATUS THEN
               CALL cl_err("OPEN i028_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i028_bcl INTO g_hrbk[l_ac].hrbk03 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrbk_t.hrbk03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_hrbk[l_ac].* TO NULL      #900423
         LET g_hrbk_t.* = g_hrbk[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrbk03
         
      AFTER FIELD hrbk05
         IF NOT cl_null(g_hrbk[l_ac].hrbk05) THEN
         	  CALL s_code('105',g_hrbk[l_ac].hrbk05) RETURNING g_hrag.*
         	  IF NOT cl_null(g_errno) THEN
         	  	 CALL cl_err('',g_errno,0)
         	  	 NEXT FIELD hrbk05
         	  ELSE 
         	     LET g_hrbk[l_ac].hrbk05_name = g_hrag.hrag07
         	  END IF 
         END IF 
         
      AFTER FIELD hrbk07
         IF NOT cl_null(g_hrbk[l_ac].hrbk07) THEN
         	  CALL s_code('326',g_hrbk[l_ac].hrbk07) RETURNING g_hrag.*
         	  IF NOT cl_null(g_errno) THEN
         	  	 CALL cl_err('',g_errno,0)
         	  	 NEXT FIELD hrbk07
         	  ELSE 
         	     LET g_hrbk[l_ac].hrbk07_name = g_hrag.hrag07
         	  END IF 
         END IF       
         
#      AFTER FIELD hrbk08
#         IF NOT cl_null(g_hrbk[l_ac].hrbk08) THEN
#         	  CALL s_code('515',g_hrbk[l_ac].hrbk08) RETURNING g_hrag.*
#         	  IF NOT cl_null(g_errno) THEN
#         	  	 CALL cl_err('',g_errno,0)
#         	  	 NEXT FIELD hrbk08
#         	  ELSE 
#         	     LET g_hrbk[l_ac].hrbk08_name = g_hrag.hrag07
#         	  END IF 
#         END IF 
          
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO hrbk_file(hrbk01,hrbk02,hrbk10,hrbk03,hrbk04,hrbk05,hrbk06,hrbk07,hrbk08,hrbk09,
                               hrbkud01,hrbkud02,hrbkud03,hrbkud04,hrbkud05,
                               hrbkud06,hrbkud07,hrbkud08,hrbkud09,hrbkud10,
                               hrbkud11,hrbkud12,hrbkud13,hrbkud14,hrbkud15,
                               hrbkuser,hrbkgrup,hrbkmodu,hrbkdate,hrbkacti,
                               hrbkoriu,hrbkorig)
                       VALUES(g_head.hrbk01,g_head.hrbk02,g_head.hrbk10,
                              g_hrbk[l_ac].hrbk03,
                              g_hrbk[l_ac].hrbk04,   
                              g_hrbk[l_ac].hrbk05,  
                              g_hrbk[l_ac].hrbk06,   
                              g_hrbk[l_ac].hrbk07,   
                              g_hrbk[l_ac].hrbk08,   
                              g_hrbk[l_ac].hrbk09,   
                              g_hrbk[l_ac].hrbkud01,
                              g_hrbk[l_ac].hrbkud02,
                              g_hrbk[l_ac].hrbkud03,
                              g_hrbk[l_ac].hrbkud04,
                              g_hrbk[l_ac].hrbkud05,
                              g_hrbk[l_ac].hrbkud06,
                              g_hrbk[l_ac].hrbkud07,
                              g_hrbk[l_ac].hrbkud08,
                              g_hrbk[l_ac].hrbkud09,
                              g_hrbk[l_ac].hrbkud10,
                              g_hrbk[l_ac].hrbkud11,
                              g_hrbk[l_ac].hrbkud12,
                              g_hrbk[l_ac].hrbkud13,
                              g_hrbk[l_ac].hrbkud14,
                              g_hrbk[l_ac].hrbkud15,
                              g_user,g_grup,g_user,g_today,'Y',g_user,g_grup)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrbk_file",g_hrbk[l_ac].hrbk03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_hrbk_t.hrbk03 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM hrbk_file WHERE hrbk01 = g_head.hrbk01
                                    AND hrbk02 = g_head.hrbk02
                                    AND hrbk03 = g_hrbk_t.hrbk03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrbk_file",g_hrbk_t.hrbk03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
            LET g_hrbk[l_ac].* = g_hrbk_t.*
            CLOSE i028_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrbk[l_ac].hrbk03,-263,1)
            LET g_hrbk[l_ac].* = g_hrbk_t.*
         ELSE
            UPDATE hrbk_file SET 
                                hrbk01=g_head.hrbk01,
                                hrbk02=g_head.hrbk02,
                                hrbk03=g_hrbk[l_ac].hrbk03,
                                hrbk04=g_hrbk[l_ac].hrbk04,
                                hrbk05=g_hrbk[l_ac].hrbk05,  
                                hrbk06=g_hrbk[l_ac].hrbk06,  
                                hrbk07=g_hrbk[l_ac].hrbk07,  
                                hrbk08=g_hrbk[l_ac].hrbk08,  
                                hrbk09=g_hrbk[l_ac].hrbk09,      
                                hrbkud01=g_hrbk[l_ac].hrbkud01, 
                                hrbkud02=g_hrbk[l_ac].hrbkud02, 
                                hrbkud03=g_hrbk[l_ac].hrbkud03, 
                                hrbkud04=g_hrbk[l_ac].hrbkud04, 
                                hrbkud05=g_hrbk[l_ac].hrbkud05, 
                                hrbkud06=g_hrbk[l_ac].hrbkud06, 
                                hrbkud07=g_hrbk[l_ac].hrbkud07, 
                                hrbkud08=g_hrbk[l_ac].hrbkud08, 
                                hrbkud09=g_hrbk[l_ac].hrbkud09, 
                                hrbkud10=g_hrbk[l_ac].hrbkud10, 
                                hrbkud11=g_hrbk[l_ac].hrbkud11, 
                                hrbkud12=g_hrbk[l_ac].hrbkud12, 
                                hrbkud13=g_hrbk[l_ac].hrbkud13, 
                                hrbkud14=g_hrbk[l_ac].hrbkud14, 
                                hrbkud15=g_hrbk[l_ac].hrbkud15
             WHERE hrbk01 = g_head.hrbk01
               AND hrbk02 = g_head.hrbk02
               AND hrbk03 = g_hrbk_t.hrbk03 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrbk_file",g_head.hrbk01,g_hrbk_t.hrbk03,SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_hrbk[l_ac].* = g_hrbk_t.*
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
               LET g_hrbk[l_ac].* = g_hrbk_t.*
            END IF
            CLOSE i028_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i028_bcl
         COMMIT WORK

       ON ACTION controlp
          CASE
              WHEN INFIELD(hrbk05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '105'
                 LET g_qryparam.default1 = g_hrbk[l_ac].hrbk05
                 LET g_qryparam.form = "q_hrag06"
                 CALL cl_create_qry() RETURNING g_hrbk[l_ac].hrbk05
                 DISPLAY g_hrbk[l_ac].hrbk05 TO hrbk05
                 NEXT FIELD hrbk05  
              WHEN INFIELD(hrbk07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '326'
                 LET g_qryparam.default1 = g_hrbk[l_ac].hrbk07
                 LET g_qryparam.form = "q_hrag06"
                 CALL cl_create_qry() RETURNING g_hrbk[l_ac].hrbk07 
                 DISPLAY g_hrbk[l_ac].hrbk07 TO hrbk07
                 NEXT FIELD hrbk07  
              WHEN INFIELD(hrbk08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '515'
                 LET g_qryparam.default1 = g_hrbk[l_ac].hrbk08
                 LET g_qryparam.form = "q_hrag06"
                 CALL cl_create_qry() RETURNING g_hrbk[l_ac].hrbk08
                 DISPLAY g_hrbk[l_ac].hrbk08 TO hrbk08
                 NEXT FIELD hrbk08                                                    
           OTHERWISE
              EXIT CASE
           END CASE  
            
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(hrbk01) AND l_ac > 1 THEN
            LET g_hrbk[l_ac].* = g_hrbk[l_ac-1].*
            NEXT FIELD hrbk03
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
 
      #No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
      #No.FUN-6B0030-----End------------------     
 
   END INPUT
 
   CLOSE i028_bcl
 
   COMMIT WORK
 
END FUNCTION

 
FUNCTION i028_b_fill()  
   DEFINE p_wc2   LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
   LET g_sql = "SELECT hrbk03,hrbk04,hrbk05,'',hrbk06,hrbk07,'',hrbk08,'',hrbk09, ",
               "       hrbkud01,hrbkud02,hrbkud03,hrbkud04,hrbkud05,",
               "       hrbkud06,hrbkud07,hrbkud08,hrbkud09,hrbkud10,",
               "       hrbkud11,hrbkud12,hrbkud13,hrbkud14,hrbkud15 ",
               "  FROM hrbk_file ",                                         #FUN-B80058 add hrbk071,hrbk141
               " WHERE hrbk01 = '",g_head.hrbk01 CLIPPED,"' ",
               "   AND hrbk02 =  ",g_head.hrbk02," and ",g_wc3 CLIPPED,                     #單身
               " ORDER BY hrbk03"
   PREPARE i028_pb FROM g_sql
   DECLARE hrbk_curs CURSOR FOR i028_pb
 
   CALL g_hrbk.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH hrbk_curs INTO g_hrbk[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      CALL s_code('105',g_hrbk[g_cnt].hrbk05) RETURNING g_hrag.*
      LET g_hrbk[g_cnt].hrbk05_name = g_hrag.hrag07
      CALL s_code('326',g_hrbk[g_cnt].hrbk07) RETURNING g_hrag.*
      LET g_hrbk[g_cnt].hrbk07_name = g_hrag.hrag07
      CALL s_code('515',g_hrbk[g_cnt].hrbk08) RETURNING g_hrag.*
      LET g_hrbk[g_cnt].hrbk08_name = g_hrag.hrag07
                  
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_hrbk.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION

 
 
FUNCTION i028_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   
   DIALOG ATTRIBUTES(UNBUFFERED)
      
      DISPLAY ARRAY g_hrbk TO s_hrbk.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
             CALL cl_navigator_setting(g_curs_index, g_row_count)
#            NEXT FIELD sch
               
            
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()  
#            NEXT FIELD sch   
      END DISPLAY 
         
      DISPLAY ARRAY g_sch TO s_sch.* 
         BEFORE DISPLAY 
            CALL dialog.setArrayAttributes("s_sch",g_att)
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()        
      END DISPLAY 
        
         ON ACTION pg1
            LET g_flag = "pg1"
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
         ON ACTION jan
            LET g_action_choice="jan"
            EXIT DIALOG
         ON ACTION feb               
            LET g_action_choice="feb"
            EXIT DIALOG
         ON ACTION mar               
            LET g_action_choice="mar"
            EXIT DIALOG
         ON ACTION apr               
            LET g_action_choice="apr"
            EXIT DIALOG
         ON ACTION may               
            LET g_action_choice="may"
            EXIT DIALOG
         ON ACTION jun               
            LET g_action_choice="jun"
            EXIT DIALOG
         ON ACTION jul               
            LET g_action_choice="jul"
            EXIT DIALOG
         ON ACTION aug               
            LET g_action_choice="aug"
            EXIT DIALOG
         ON ACTION sep               
            LET g_action_choice="sep"
            EXIT DIALOG
         ON ACTION oct              
            LET g_action_choice="oct"
            EXIT DIALOG
         ON ACTION nov               
            LET g_action_choice="nov"
            EXIT DIALOG
         ON ACTION dec               
            LET g_action_choice="dec"
            EXIT DIALOG
         ON ACTION cb1_pre
            LET g_action_choice="cb1_pre"
            EXIT DIALOG
         ON ACTION cb1_next
            LET g_action_choice="cb1_next"
            EXIT DIALOG
         ON ACTION cb2_pre
            LET g_action_choice="cb2_pre"
            EXIT DIALOG
         ON ACTION cb2_next
            LET g_action_choice="cb2_next"  
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
#add by leo 130503
FUNCTION i028_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
   DEFIne   l_note LIKE type_file.chr1000
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   
   DIALOG ATTRIBUTES(UNBUFFERED)
             
      DISPLAY ARRAY g_sch TO s_sch.* 
         BEFORE DISPLAY 
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL dialog.setArrayAttributes("s_sch",g_att)
            IF l_ac1 > 1 THEN 
            	 CALL fgl_set_arr_curr(l_ac1)
            END IF 
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            SELECT hrbk09 INTO l_note FROM hrbk_file
             WHERE hrbk01 = g_head.hrbk01
               AND hrbk02 = g_head.hrbk02
               AND hrbk03 = g_sch[l_ac1].sch1
            DISPLAY l_note TO note
            CALL cl_show_fld_cont()        
      END DISPLAY 
        
         ON ACTION pg
            LET g_flag = "pg"
            EXIT DIALOG
         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
#         ON ACTION detail
#            LET g_action_choice="detail"
#            LET l_ac = 1
#            EXIT DIALOG
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG
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
         ON ACTION jan
            LET g_action_choice="jan"
            EXIT DIALOG
         ON ACTION feb               
            LET g_action_choice="feb"
            EXIT DIALOG
         ON ACTION mar               
            LET g_action_choice="mar"
            EXIT DIALOG
         ON ACTION apr               
            LET g_action_choice="apr"
            EXIT DIALOG
         ON ACTION may               
            LET g_action_choice="may"
            EXIT DIALOG
         ON ACTION jun               
            LET g_action_choice="jun"
            EXIT DIALOG
         ON ACTION jul               
            LET g_action_choice="jul"
            EXIT DIALOG
         ON ACTION aug               
            LET g_action_choice="aug"
            EXIT DIALOG
         ON ACTION sep               
            LET g_action_choice="sep"
            EXIT DIALOG
         ON ACTION oct              
            LET g_action_choice="oct"
            EXIT DIALOG
         ON ACTION nov               
            LET g_action_choice="nov"
            EXIT DIALOG
         ON ACTION dec               
            LET g_action_choice="dec"
            EXIT DIALOG
         ON ACTION cb1_pre
            LET g_action_choice="cb1_pre"
            EXIT DIALOG
         ON ACTION cb1_next
            LET g_action_choice="cb1_next"
            EXIT DIALOG
         ON ACTION cb2_pre
            LET g_action_choice="cb2_pre"
            EXIT DIALOG
         ON ACTION cb2_next
            LET g_action_choice="cb2_next"  
            EXIT DIALOG    
         ON ACTION upd_note
            LET g_action_choice="upd_note"
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
      
#         ON ACTION accept
#            LET g_action_choice="detail"
#            LET l_ac = ARR_CURR()
#            EXIT DIALOG
      
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
#end by leo 130503 
FUNCTION i028_test()

    LET g_sch[1].sch = "1\n劳动节"               LET g_att[1].sch = "red reverse"     
    LET g_sch[2].sch = "2\n工作日"               LET g_att[2].sch = "gray reverse"  
    LET g_sch[3].sch = "3\n工作日"               LET g_att[3].sch = "gray reverse"  
    LET g_sch[4].sch = "4\n工作日"               LET g_att[4].sch = "white reverse"  
    LET g_sch[5].sch = "5\n工作日"               LET g_att[5].sch = "white reverse"  
    LET g_sch[6].sch = "6\n工作日"               LET g_att[6].sch = "gray reverse"  
    LET g_sch[7].sch = "7\n工作日"               LET g_att[7].sch = "yellow reverse"  
    LET g_sch[8].sch = "8\n工作日"               LET g_att[8].sch = "yellow reverse"  
    LET g_sch[9].sch = "9\n工作日"               LET g_att[9].sch =  "gray"  
    LET g_sch[10].sch = "10\n工作日"             LET g_att[10].sch = "gray"
    LET g_sch[11].sch = "11\n工作日"             LET g_att[11].sch = ""
    LET g_sch[12].sch = "12\n工作日"             LET g_att[12].sch = ""
    LET g_sch[13].sch = "13\n工作日"             LET g_att[13].sch = ""
    LET g_sch[14].sch = "14\n工作日"             LET g_att[14].sch = "yellow reverse "
    LET g_sch[15].sch = "15\n工作日"             LET g_att[15].sch = "yellow reverse "
    LET g_sch[16].sch = "16\n工作日"             LET g_att[16].sch = ""
    LET g_sch[17].sch = "17\n工作日"             LET g_att[17].sch = ""
    LET g_sch[18].sch = "18\n工作日"             LET g_att[18].sch = ""
    LET g_sch[19].sch = "19\n工作日"             LET g_att[19].sch = ""
    LET g_sch[20].sch = "20\n工作日"             LET g_att[20].sch = ""
    LET g_sch[21].sch = "21\n工作日"             LET g_att[21].sch = "yellow reverse "
    LET g_sch[22].sch = "22\n工作日"             LET g_att[22].sch = "yellow reverse "
    LET g_sch[23].sch = "23\n工作日"             LET g_att[23].sch = ""
    LET g_sch[24].sch = "24\n工作日"             LET g_att[24].sch = ""
    LET g_sch[25].sch = "25\n工作日"             LET g_att[25].sch = ""
    LET g_sch[26].sch = "26\n工作日"             LET g_att[26].sch = ""
    LET g_sch[27].sch = "27\n工作日"             LET g_att[27].sch = ""
    LET g_sch[28].sch = "28\n工作日"             LET g_att[28].sch = "yellow reverse "
    LET g_sch[29].sch = "29\n工作日"             LET g_att[29].sch = "yellow reverse "
    LET g_sch[30].sch = "30\n工作日"             LET g_att[30].sch = ""
    LET g_sch[31].sch = "31\n工作日"             LET g_att[31].sch = ""

END FUNCTION

FUNCTION i028_hrbk01(p_cmd) 
 DEFINE p_cmd         LIKE type_file.chr1
 DEFINE p_hrat03      LIKE hrat_file.hrat03
   DEFINE l_hraa02    LIKE hraa_file.hraa02 
   DEFINE l_hraaacti  LIKE hraa_file.hraaacti 
   DEFINE l_n         LIKE type_file.num5

   LET g_errno = NULL
   SELECT hraa02,hraaacti INTO l_hraa02,l_hraaacti FROM hraa_file
    WHERE hraa01=g_head.hrbk01
    CASE
        WHEN SQLCA.sqlcode=100   LET g_errno='ghr-001'
                                 LET l_hraa02=NULL
   
        WHEN l_hraaacti='N'      LET g_errno='9028'
        OTHERWISE
             LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
   SELECT COUNT(*) INTO l_n FROM hrbk_file 
    WHERE hrbk01 = g_head.hrbk01
      AND hrbk02 = g_head.hrbk02
   IF l_n > 0 THEN 
   	  LET g_errno = 'ghr-054'
   END IF 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
   	  DISPLAY l_hraa02 TO hrbk01_name
   END IF 
   
END FUNCTION

FUNCTION i028_hrbk02() 
 DEFINE l_n  LIKE type_file.num5

   LET g_errno = NULL
   IF g_head.hrbk02 <2000 OR g_head.hrbk02 >2999 THEN
   	  LET g_errno = 'ghr-055'
   	  RETURN
   END IF 
   SELECT COUNT(*) INTO l_n FROM hrbk_file 
    WHERE hrbk01 = g_head.hrbk01
      AND hrbk02 = g_head.hrbk02
   IF l_n > 0 THEN 
   	  LET g_errno = 'ghr-054'
   END IF 
END FUNCTION


FUNCTION i028_month(p_year,p_month)
  DEFINE p_year    LIKE type_file.num5
  DEFINE p_month   LIKE type_file.num5
  
  IF p_year != g_head.hrbk02 THEN
     LET g_head.hrbk02 = p_year
     DISPLAY g_head.hrbk02 TO hrbk02
     CALL i028_b_fill()  	 
  END IF 
  LET g_head.cb1 = p_year
  LET g_head.cb1_name = p_year||'年'
  LET g_head.cb2 = g_head.cb1 * 12 + p_month
  LET g_head.cb2_name = g_head.cb1||'年'||p_month||'月'
  DISPLAY g_head.cb1_name,g_head.cb2_name TO cb1,cb2
  
  CALL i028_sch_fill(g_head.cb1,p_month)
END FUNCTION

FUNCTION i028_sch_fill(p_year,p_month)
  DEFINE  p_year  LIKE type_file.num5
  DEFINE  p_month LIKE type_file.num5
  DEFINE  l_hrbk03  LIKE hrbk_file.hrbk03     
  DEFINE  l_hrbk04  LIKE hrbk_file.hrbk04
  DEFINE  l_idx     LIKE type_file.num5
  DEFINE  l_first   LIKE type_file.num5
  DEFINE  l_last    LIKE type_file.num5  
  DEFINE  l_n       LIKE type_file.num5
  DEFINE  l_enter   LIKE type_file.chr1

    CALL g_sch.clear()
    CALL g_att.clear()
    LET l_idx = 0
    LET l_enter = 'N'
    LET g_sql = "SELECT hrbk03,hrbk04 FROM hrbk_file",
                " WHERE hrbk01 = '",g_head.hrbk01,"' ",
                "   AND hrbk02 =  ",g_head.hrbk02,
                "   AND YEAR(hrbk03) = ",p_year,
                "   AND MONTH(hrbk03) = ",p_month,
                " ORDER BY hrbk03 "
    PREPARE i028_date_prep FROM g_sql
    DECLARE i028_date_cs CURSOR FOR i028_date_prep
    FOREACH i028_date_cs INTO l_hrbk03,l_hrbk04
       IF SQLCA.sqlcode THEN 
          RETURN 
       END IF 
       CASE l_hrbk04 
          WHEN '7'  CALL i028_get_date(g_head.hrbk01,l_hrbk03) RETURNING g_sch[7*l_idx+1].sch,g_sch[7*l_idx+1].sch1,g_sch[7*l_idx+1].sch2
          WHEN '1'  CALL i028_get_date(g_head.hrbk01,l_hrbk03) RETURNING g_sch[7*l_idx+2].sch,g_sch[7*l_idx+2].sch1,g_sch[7*l_idx+2].sch2
          WHEN '2'  CALL i028_get_date(g_head.hrbk01,l_hrbk03) RETURNING g_sch[7*l_idx+3].sch,g_sch[7*l_idx+3].sch1,g_sch[7*l_idx+3].sch2
          WHEN '3'  CALL i028_get_date(g_head.hrbk01,l_hrbk03) RETURNING g_sch[7*l_idx+4].sch,g_sch[7*l_idx+4].sch1,g_sch[7*l_idx+4].sch2
          WHEN '4'  CALL i028_get_date(g_head.hrbk01,l_hrbk03) RETURNING g_sch[7*l_idx+5].sch,g_sch[7*l_idx+5].sch1,g_sch[7*l_idx+5].sch2
          WHEN '5'  CALL i028_get_date(g_head.hrbk01,l_hrbk03) RETURNING g_sch[7*l_idx+6].sch,g_sch[7*l_idx+6].sch1,g_sch[7*l_idx+6].sch2
          WHEN '6'  CALL i028_get_date(g_head.hrbk01,l_hrbk03) RETURNING g_sch[7*l_idx+7].sch,g_sch[7*l_idx+7].sch1,g_sch[7*l_idx+7].sch2
                    LET l_idx = l_idx + 1 
       END CASE 
       LET l_enter = 'Y'
    END FOREACH 
    
    IF l_enter = 'N' THEN
       FOR l_n = 1 TO 42
          LET g_sch[l_n].sch = ' '
       END FOR
       RETURN
    END IF 
    FOR l_n = 1 TO 42
       IF NOT cl_null(g_sch[1].sch) THEN LET l_first = 1 EXIT FOR END IF 
       IF cl_null(g_sch[l_n].sch) AND NOT cl_null(g_sch[l_n+1].sch) THEN 
       	  LET l_first = l_n+1
       	  EXIT FOR
       END IF 
    END FOR
    FOR l_n = 42 TO 1 STEP -1
       IF NOT cl_null(g_sch[42].sch) THEN LET l_last = 42 EXIT FOR END IF 
       IF cl_null(g_sch[l_n].sch) AND NOT cl_null(g_sch[l_n-1].sch) THEN
       	  LET l_last = l_n-1
       	  EXIT FOR
       END IF  
    END FOR
    FOR l_n = l_first-1 TO 1 STEP -1
        LET l_hrbk03 = g_sch[l_first].sch1 - (l_first-l_n)
        CALL i028_get_date(g_head.hrbk01,l_hrbk03) RETURNING g_sch[l_n].sch,g_sch[l_n].sch1,g_sch[l_n].sch2
    END FOR 
    
    FOR l_n = l_last+1 TO 42 
         LET l_hrbk03 = g_sch[l_last].sch1 + l_n - l_last
         CALL i028_get_date(g_head.hrbk01,l_hrbk03) RETURNING g_sch[l_n].sch,g_sch[l_n].sch1,g_sch[l_n].sch2
    END FOR
    
    FOR l_n = 1 TO 42
        IF MONTH(g_sch[l_n].sch1) != p_month THEN 
        	 LET g_att[l_n].sch = 'gray'
        	 CONTINUE FOR
        END IF 
        CASE g_sch[l_n].sch2 
           WHEN '001'
              LET g_att[l_n].sch = ""
           WHEN '002'
              LET g_att[l_n].sch = "yellow reverse"
           WHEN '003'
              LET g_att[l_n].sch = "red reverse"
           OTHERWISE 
              LET g_att[l_n].sch = ""
        END CASE 
    END FOR 

END FUNCTION

FUNCTION i028_get_date(p_hrbk01,p_hrbk03)
  DEFINE p_hrbk01  LIKE hrbk_file.hrbk01
  DEFINE p_hrbk02  LIKE hrbk_file.hrbk02
  DEFINE p_hrbk03  LIKE hrbk_file.hrbk03  
  DEFINE l_hrbk    RECORD LIKE hrbk_file.*
  DEFINE l_day     LIKE type_file.num5   
  DEFINE l_str     STRING
  
  INITIALIZE l_hrbk.* TO NULL
   SELECT * INTO l_hrbk.* FROM hrbk_file 
    WHERE hrbk01 = p_hrbk01
      AND hrbk03 = p_hrbk03
   LET l_day = DAY(l_hrbk.hrbk03)
   LET l_str = l_day USING '#####'
   IF NOT (l_hrbk.hrbk06 = '公休' OR
           l_hrbk.hrbk06 = '工作日') THEN
   	  LET l_str = l_str||'\n'||l_hrbk.hrbk06
   END IF
   RETURN l_str,l_hrbk.hrbk03,l_hrbk.hrbk05
   
END FUNCTION

FUNCTION i028_cb1(p_step)
 DEFINE p_step   LIKE  type_file.num5
 
   LET g_head.cb1 = g_head.cb1+p_step
   
   LET g_head.cb1_name = g_head.cb1||'年'
   DISPLAY g_head.cb1_name TO cb1
END FUNCTION

FUNCTION i028_cb2(p_step)
 DEFINE p_step   LIKE  type_file.num5
 DEFINE l_year   LIKE  type_file.num5
 DEFINE l_month  LIKE  type_file.num5
 
   LET g_head.cb2 = g_head.cb2 + p_step
   
   LET l_month = g_head.cb2 MOD 12
   LET l_year = (g_head.cb2 - l_month)/12
   LET g_head.cb1 = l_year
   IF l_month=0 THEN
      LET l_year = l_year-1
      LET g_head.cb1 = l_year
      LET l_month = 12
      LET g_head.cb2 = l_month 
   END IF   
   LET g_head.cb1_name = g_head.cb1||'年'
   LET g_head.cb2_name = g_head.cb1||'年'||l_month||'月'
   DISPLAY g_head.cb1_name,g_head.cb2_name TO cb1,cb2
   
   CALL i028_month(l_year,l_month)
END FUNCTION


FUNCTION i028_upd_note()
 DEFINE l_note  LIKE hrbk_file.hrbk09

      SELECT hrbk09 INTO l_note FROM hrbk_file
       WHERE hrbk01 = g_head.hrbk01
         AND hrbk02 = g_head.hrbk02
         AND hrbk03 = g_sch[l_ac1].sch1
         
      INPUT l_note WITHOUT DEFAULTS FROM formonly.note  
           
         ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
      END INPUT
      
      IF INT_FLAG THEN 
      	 RETURN 
      END IF 
      
      UPDATE hrbk_file SET hrbk09 = l_note
       WHERE hrbk01 = g_head.hrbk01
         AND hrbk02 = g_head.hrbk02
         AND hrbk03 = g_sch[l_ac1].sch1
      IF SQLCA.sqlcode THEN
      	 CALL cl_err3("upd","hrbk_file",g_hrbk[l_ac1].hrbk03,"",SQLCA.sqlcode,"","",1)   #No.FUN-660151
      END IF 
      
      CALL i028_b_fill()
END FUNCTION

