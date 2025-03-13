# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri059.4gl
# Descriptions...: 标准薪资日历
# Date & Author..: 13/05/07 By yangjian

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_head          RECORD 
           hrcs01      LIKE hrcs_file.hrcs01,
           hrcs01_name LIKE type_file.chr100,
           hrcs02      LIKE hrcs_file.hrcs02,
           cb1         LIKE type_file.num5,
           cb1_name    LIKE type_file.chr100,
           cb2         LIKE type_file.num5,
           cb2_name    LIKE type_file.chr100,
           note        LIKE hrcs_file.hrcs06,
           hrcsuser    LIKE hrcs_file.hrcsuser,
           hrcsgrup    LIKE hrcs_file.hrcsgrup,
           hrcsoriu    LIKE hrcs_file.hrcsoriu,
           hrcsorig    LIKE hrcs_file.hrcsorig,      
           hrcsmodu    LIKE hrcs_file.hrcsmodu,
           hrcsdate    LIKE hrcs_file.hrcsdate,
           hrcsacti    LIKE hrcs_file.hrcsacti
              END RECORD,     
    g_hrcs           DYNAMIC ARRAY OF RECORD   
        hrcs03       LIKE hrcs_file.hrcs03,  
        hrcs04       LIKE hrcs_file.hrcs04,  
        hrcs05       LIKE hrcs_file.hrcs05,  
        hrcs05_name  LIKE type_file.chr100,
        hrcs06       LIKE hrcs_file.hrcs06,  
        hrcsud01     LIKE hrcs_file.hrcsud01,
        hrcsud02     LIKE hrcs_file.hrcsud02,
        hrcsud03     LIKE hrcs_file.hrcsud03,
        hrcsud04     LIKE hrcs_file.hrcsud04,
        hrcsud05     LIKE hrcs_file.hrcsud05,
        hrcsud06     LIKE hrcs_file.hrcsud06,
        hrcsud07     LIKE hrcs_file.hrcsud07,
        hrcsud08     LIKE hrcs_file.hrcsud08,
        hrcsud09     LIKE hrcs_file.hrcsud09,
        hrcsud10     LIKE hrcs_file.hrcsud10,
        hrcsud11     LIKE hrcs_file.hrcsud11,
        hrcsud12     LIKE hrcs_file.hrcsud12,
        hrcsud13     LIKE hrcs_file.hrcsud13,
        hrcsud14     LIKE hrcs_file.hrcsud14,
        hrcsud15     LIKE hrcs_file.hrcsud15 
                    END RECORD,
    g_hrcs_t         RECORD                 #程式變數 (舊值)
        hrcs03       LIKE hrcs_file.hrcs03,  
        hrcs04       LIKE hrcs_file.hrcs04,  
        hrcs05       LIKE hrcs_file.hrcs05, 
        hrcs05_name  LIKE type_file.chr100, 
        hrcs06       LIKE hrcs_file.hrcs06,  
        hrcsud01     LIKE hrcs_file.hrcsud01,
        hrcsud02     LIKE hrcs_file.hrcsud02,
        hrcsud03     LIKE hrcs_file.hrcsud03,
        hrcsud04     LIKE hrcs_file.hrcsud04,
        hrcsud05     LIKE hrcs_file.hrcsud05,
        hrcsud06     LIKE hrcs_file.hrcsud06,
        hrcsud07     LIKE hrcs_file.hrcsud07,
        hrcsud08     LIKE hrcs_file.hrcsud08,
        hrcsud09     LIKE hrcs_file.hrcsud09,
        hrcsud10     LIKE hrcs_file.hrcsud10,
        hrcsud11     LIKE hrcs_file.hrcsud11,
        hrcsud12     LIKE hrcs_file.hrcsud12,
        hrcsud13     LIKE hrcs_file.hrcsud13,
        hrcsud14     LIKE hrcs_file.hrcsud14,
        hrcsud15     LIKE hrcs_file.hrcsud15 
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
    g_wc2,g_sql     string,  #No.FUN-580092 HCN
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
 
   LET g_head.hrcs01 = ARG_VAL(1) 
   LET g_head.hrcs02 = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
   
   LET g_forupd_sql = "SELECT * FROM hrcs_file WHERE hrcs01 = ? ",
                      "   AND hrcs02 = ? ",
                      "   FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i059_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   OPEN WINDOW i059_w WITH FORM "ghr/42f/ghri059"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   
   LET g_flag ='N'
 
   CALL i059_menu()
 
   CLOSE WINDOW i059_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i059_menu()
 
   WHILE TRUE
      #默认g_flag = 'N' 当执行第二个页签的ACTION时，将g_flag置成Y；当执行非第二页签的ACTION时，重置为'N'
      IF g_flag ='pg1' THEN   
        CALL i059_bp1("G")   #仅包含第二页签的DISPLAY
      ELSE
      	CALL i059_bp("G")    #包含两个DISPLAY，目前的函数不动
      END IF   
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
            	 CALL i059_a()
            END IF 
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i059_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i059_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
            	 CALL i059_r()
            END IF 
         WHEN "next"
            IF cl_chk_act_auth() THEN
            	 CALL i059_fetch('N')
            END IF    
         WHEN "previous"
            IF cl_chk_act_auth() THEN
            	 CALL i059_fetch('P')
            END IF  
         WHEN "jump"
            IF cl_chk_act_auth() THEN
            	 CALL i059_fetch('/')
            END IF  
         WHEN "first"
            IF cl_chk_act_auth() THEN
            	 CALL i059_fetch('F')
            END IF  
         WHEN "last"
            IF cl_chk_act_auth() THEN
            	 CALL i059_fetch('L')
            END IF   
         WHEN "jan"
            IF cl_chk_act_auth() THEN
            	 CALL i059_month(g_head.cb1,'1')
            END IF  
         WHEN "feb"
            IF cl_chk_act_auth() THEN
            	 CALL i059_month(g_head.cb1,'2')
            END IF
         WHEN "mar"
            IF cl_chk_act_auth() THEN
            	 CALL i059_month(g_head.cb1,'3')
            END IF
         WHEN "apr"
            IF cl_chk_act_auth() THEN
            	 CALL i059_month(g_head.cb1,'4')
            END IF
         WHEN "may"
            IF cl_chk_act_auth() THEN
            	 CALL i059_month(g_head.cb1,'5')
            END IF
         WHEN "jun"
            IF cl_chk_act_auth() THEN
            	 CALL i059_month(g_head.cb1,'6')
            END IF
         WHEN "jul"
            IF cl_chk_act_auth() THEN
            	 CALL i059_month(g_head.cb1,'7')
            END IF
         WHEN "aug"
            IF cl_chk_act_auth() THEN
            	 CALL i059_month(g_head.cb1,'8')
            END IF
         WHEN "sep"
            IF cl_chk_act_auth() THEN
            	 CALL i059_month(g_head.cb1,'9')
            END IF
         WHEN "oct"
            IF cl_chk_act_auth() THEN
            	 CALL i059_month(g_head.cb1,'10')
            END IF
         WHEN "nov"
            IF cl_chk_act_auth() THEN
            	 CALL i059_month(g_head.cb1,'11')
            END IF
         WHEN "dec"
            IF cl_chk_act_auth() THEN
            	 CALL i059_month(g_head.cb1,'12')
            END IF   
         WHEN "cb1_pre"
            IF cl_chk_act_auth() THEN
               CALL i059_cb1(-1)
            END IF     
         WHEN "cb1_next"
            IF cl_chk_act_auth() THEN
               CALL i059_cb1(+1)
            END IF  
         WHEN "cb2_pre"
            IF cl_chk_act_auth() THEN
               CALL i059_cb2(-1)
            END IF 
         WHEN "cb2_next"
            IF cl_chk_act_auth() THEN
               CALL i059_cb2(+1)
            END IF         
         WHEN "upd_note"
            IF cl_chk_act_auth() THEN
            	 CALL i059_upd_note()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcs),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION


FUNCTION i059_cs()
 
    CLEAR FORM
    INITIALIZE g_head.* TO NULL
    CALL g_sch.clear()
    CALL g_hrcs.clear()
    LET g_wc2 = NULL
    
    CONSTRUCT g_wc2 ON hrcs01,hrcs02,hrcsuser,hrcsgrup,hrcsmodu,hrcsdate,
                       hrcsacti,hrcsoriu,hrcsorig,
                       hrcs03,hrcs04,hrcs05,hrcs06,
                       hrcsud01,hrcsud02,hrcsud03,hrcsud04,hrcsud05,
                       hrcsud06,hrcsud07,hrcsud08,hrcsud09,hrcsud10,
                       hrcsud11,hrcsud12,hrcsud13,hrcsud14,hrcsud15
         FROM hrcs01,hrcs02,hrcsuser,hrcsgrup,hrcsmodu,hrcsdate,
              hrcsacti,hrcsoriu,hrcsorig,
              s_hrcs[1].hrcs03,s_hrcs[1].hrcs04,s_hrcs[1].hrcs05,s_hrcs[1].hrcs06,
              s_hrcs[1].hrcsud01,s_hrcs[1].hrcsud02,s_hrcs[1].hrcsud03,s_hrcs[1].hrcsud04, 
              s_hrcs[1].hrcsud05,s_hrcs[1].hrcsud06,s_hrcs[1].hrcsud07,s_hrcs[1].hrcsud08,
              s_hrcs[1].hrcsud09,s_hrcs[1].hrcsud10,s_hrcs[1].hrcsud11,s_hrcs[1].hrcsud12,
              s_hrcs[1].hrcsud13,s_hrcs[1].hrcsud14,s_hrcs[1].hrcsud15
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
          

       ON ACTION controlp
          CASE
              WHEN INFIELD(hrcs01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcs01
                 NEXT FIELD hrcs01
              WHEN INFIELD(hrcs05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '105'
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_hrag06"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcs05
                 NEXT FIELD hrcs05                                                    
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrcsuser', 'hrcsgrup') #FUN-980030
 
    LET g_sql = "SELECT DISTINCT hrcs01,hrcs02 FROM hrcs_file ",
                " WHERE ",g_wc2 CLIPPED, 
                " ORDER BY hrcs01,hrcs02"
    PREPARE i059_prepare FROM g_sql
    DECLARE i059_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i059_prepare

    LET g_sql = "SELECT COUNT (*) FROM (",
                " SELECT DISTINCT hrcs01,hrcs02 FROM hrcs_file ",
                " WHERE ",g_wc2 CLIPPED ,
                " ) "
    PREPARE i059_precount FROM g_sql
    DECLARE i059_count CURSOR FOR i059_precount
END FUNCTION
 
FUNCTION i059_q()
 
   CALL i059_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i059_count
    FETCH i059_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i059_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_head.hrcs01,SQLCA.sqlcode,0)
        INITIALIZE g_head.* TO NULL
    ELSE
        CALL i059_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION


FUNCTION i059_fetch(p_flhrcs)
    DEFINE p_flhrcs         LIKE type_file.chr1
 
    CASE p_flhrcs
        WHEN 'N' FETCH NEXT     i059_cs INTO g_head.hrcs01,g_head.hrcs02
        WHEN 'P' FETCH PREVIOUS i059_cs INTO g_head.hrcs01,g_head.hrcs02
        WHEN 'F' FETCH FIRST    i059_cs INTO g_head.hrcs01,g_head.hrcs02
        WHEN 'L' FETCH LAST     i059_cs INTO g_head.hrcs01,g_head.hrcs02
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
            FETCH ABSOLUTE g_jump i059_cs INTO g_head.hrcs01,g_head.hrcs02
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_head.hrcs01,SQLCA.sqlcode,0)
        INITIALIZE g_head.* TO NULL  
        RETURN
    ELSE
      CASE p_flhrcs
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx     
    END IF
 
    SELECT DISTINCT hrcs01,hrcs02,hrcsuser,hrcsgrup,hrcsmodu,hrcsdate,
           hrcsacti,hrcsoriu,hrcsorig
      INTO g_head.hrcs01,g_head.hrcs02,g_head.hrcsuser,g_head.hrcsgrup,
           g_head.hrcsmodu,g_head.hrcsdate,g_head.hrcsacti,
           g_head.hrcsoriu,g_head.hrcsorig
      FROM hrcs_file    # 重讀DB,因TEMP有不被更新特性
     WHERE hrcs01 = g_head.hrcs01
       AND hrcs02 = g_head.hrcs02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrcs_file",g_head.hrcs01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        CALL i059_show()                   # 重新顯示
    END IF
END FUNCTION
 

FUNCTION i059_show()

    DISPLAY BY NAME g_head.hrcs01,g_head.hrcs02,
                    g_head.hrcsuser,g_head.hrcsgrup,g_head.hrcsmodu,
                    g_head.hrcsdate,g_head.hrcsacti,g_head.hrcsorig,g_head.hrcsoriu
    CALL i059_hrcs01('d')
    CALL cl_show_fld_cont()
    
    CALL i059_b_fill()
    CALL i059_month(g_head.hrcs02,'1')
END FUNCTION


FUNCTION i059_a()
 DEFINE l_hrcs   RECORD LIKE hrcs_file.*

    CLEAR FORM 
    INITIALIZE g_head.* TO NULL
    INITIALIZE l_hrcs.* TO NULL
    CALL g_sch.clear()
    CALL g_hrcs.clear()
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_head.hrcsuser = g_user
        LET g_head.hrcsoriu = g_user 
        LET g_head.hrcsorig = g_grup 
        LET g_head.hrcsgrup = g_grup               #使用者所屬群
        LET g_head.hrcsdate = g_today
        LET g_head.hrcsacti = 'Y'
        CALL i059_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
        	  CALL g_hrcs.clear()
        	  CALL g_sch.clear()  
        	  INITIALIZE g_head.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_head.hrcs01 IS NULL OR g_head.hrcs02 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        
        LET g_success = 'Y'
        BEGIN WORK
        CALL s_showmsg_init()
        LET l_hrcs.hrcs01 = g_head.hrcs01
        LET l_hrcs.hrcs02 = g_head.hrcs02
        
        LET g_sql = "select a,CASE TO_CHAR(a,'d') ",
                    "          WHEN '1' THEN '7' ",
                    "          WHEN '2' THEN '1' ",
                    "          WHEN '3' THEN '2' ",
                    "          WHEN '4' THEN '3' ",
                    "          WHEN '5' THEN '4' ",
                    "          WHEN '6' THEN '5' ",
                    "          WHEN '7' THEN '6' ",
                    "          END  FROM(        ",
                    " SELECT TO_DATE('",g_head.hrcs02,"0101', 'yyyymmdd') + (rownum - 1) a  ",
                    "   FROM dual ",
                    "  CONNECT BY ROWNUM <= TO_CHAR(TO_DATE('",g_head.hrcs02,"1231', 'yyyymmdd'), 'ddd') ",
                    ")"
        PREPARE i059_insert_prep FROM g_sql
        DECLARE i059_insert_cs CURSOR FOR i059_insert_prep 
        FOREACH i059_insert_cs INTO l_hrcs.hrcs03,l_hrcs.hrcs04
           IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
           CASE   
              WHEN l_hrcs.hrcs04 MATCHES '[67]'
              	  LET l_hrcs.hrcs05 = '002'
              OTHERWISE
                 LET l_hrcs.hrcs05 = '001'
           END CASE         	        
           INSERT INTO hrcs_file VALUES(l_hrcs.*)
           IF SQLCA.sqlcode THEN
           	  LET g_success = 'N'
           	  CALL s_errmsg("hrcs03",l_hrcs.hrcs03,"ins err",SQLCA.sqlcode,1)
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
    CALL i059_show()
END FUNCTION

FUNCTION i059_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_hrat04      LIKE hrat_file.hrat04
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
 
   DISPLAY BY NAME g_head.hrcs01,g_head.hrcs01_name,g_head.cb1,g_head.cb2,g_head.note,
                   g_head.hrcsuser,g_head.hrcsgrup,g_head.hrcsacti,
                   g_head.hrcsmodu,g_head.hrcsdate,g_head.hrcsoriu,g_head.hrcsorig
 
   INPUT BY NAME
      g_head.hrcs01,g_head.hrcs02
      WITHOUT DEFAULTS
 
      BEFORE INPUT
 
      AFTER FIELD hrcs01
         IF g_head.hrcs01 IS NOT NULL THEN
            CALL i059_hrcs01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('hrcs01:',g_errno,1)
               LET g_head.hrcs01 = NULL
               NEXT FIELD hrcs01
            ELSE 
            
            END IF
         END IF

    #
      AFTER FIELD hrcs02
         IF NOT cl_null(g_head.hrcs02) THEN
            CALL i059_hrcs02()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('hrcs02:',g_errno,1)
               LET g_head.hrcs02 = NULL
               NEXT FIELD hrcs02
            ELSE 
            
            END IF
         END IF         	
         
      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

     ON ACTION controlp
        CASE
              WHEN INFIELD(hrcs01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.default1 = g_head.hrcs01
                 CALL cl_create_qry() RETURNING g_head.hrcs01
                 DISPLAY g_head.hrcs01 TO hrcs01
                 NEXT FIELD hrcs01
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


FUNCTION i059_r()
    IF g_head.hrcs01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i059_cl USING g_head.hrcs01,g_head.hrcs02
    IF STATUS THEN
       CALL cl_err("OPEN i059_cl:", STATUS, 0)
       CLOSE i059_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i059_cl INTO g_head.hrcs01,g_head.hrcs02
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_head.hrcs01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i059_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrcs01"   
       LET g_doc.value1 = g_head.hrcs01 
       LET g_doc.column2 = "hrcs02"   
       LET g_doc.value2 = g_head.hrcs02        

       CALL cl_del_doc()
       DELETE FROM hrcs_file WHERE hrcs01 = g_head.hrcs01
                               AND hrcs02 = g_head.hrcs02
       CLEAR FORM
       OPEN i059_count
       IF STATUS THEN
          CLOSE i059_cl
          CLOSE i059_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i059_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i059_cl
          CLOSE i059_count
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i059_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i059_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i059_fetch('/')
       END IF
    END IF
    CLOSE i059_cl
    COMMIT WORK
END FUNCTION


FUNCTION i059_b()
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
 
                      #FUN-510041 add hrcs05
   LET g_forupd_sql = " SELECT hrcs03 ",
                      "   FROM hrcs_file ",  #TQC-B30004 
                      "  WHERE hrcs01= ? AND hrcs02= ? ",
                      "    AND hrcs03= ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i059_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_hrcs WITHOUT DEFAULTS FROM s_hrcs.*
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
            LET g_hrcs_t.* = g_hrcs[l_ac].*  #BACKUP
            OPEN i059_bcl USING g_head.hrcs01,g_head.hrcs02,g_hrcs_t.hrcs03
            IF STATUS THEN
               CALL cl_err("OPEN i059_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i059_bcl INTO g_hrcs[l_ac].hrcs03 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrcs_t.hrcs03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_hrcs[l_ac].* TO NULL      #900423
         LET g_hrcs_t.* = g_hrcs[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrcs03
         
      AFTER FIELD hrcs05
         IF NOT cl_null(g_hrcs[l_ac].hrcs05) THEN
         	  CALL s_code('105',g_hrcs[l_ac].hrcs05) RETURNING g_hrag.*
         	  IF NOT cl_null(g_errno) THEN
         	  	 CALL cl_err('',g_errno,0)
         	  	 NEXT FIELD hrcs05
         	  ELSE 
         	     LET g_hrcs[l_ac].hrcs05_name = g_hrag.hrag07
         	  END IF 
         END IF 
 
          
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO hrcs_file(hrcs01,hrcs02,hrcs03,hrcs05,hrcs06,
                               hrcsud01,hrcsud02,hrcsud03,hrcsud04,hrcsud05,
                               hrcsud06,hrcsud07,hrcsud08,hrcsud09,hrcsud10,
                               hrcsud11,hrcsud12,hrcsud13,hrcsud14,hrcsud15,
                               hrcsuser,hrcsgrup,hrcsmodu,hrcsdate,hrcsacti,
                               hrcsoriu,hrcsorig)
                       VALUES(g_head.hrcs01,g_head.hrcs02,
                              g_hrcs[l_ac].hrcs03,
                              g_hrcs[l_ac].hrcs04,   
                              g_hrcs[l_ac].hrcs05,  
                              g_hrcs[l_ac].hrcs06,   
                              g_hrcs[l_ac].hrcsud01,
                              g_hrcs[l_ac].hrcsud02,
                              g_hrcs[l_ac].hrcsud03,
                              g_hrcs[l_ac].hrcsud04,
                              g_hrcs[l_ac].hrcsud05,
                              g_hrcs[l_ac].hrcsud06,
                              g_hrcs[l_ac].hrcsud07,
                              g_hrcs[l_ac].hrcsud08,
                              g_hrcs[l_ac].hrcsud09,
                              g_hrcs[l_ac].hrcsud10,
                              g_hrcs[l_ac].hrcsud11,
                              g_hrcs[l_ac].hrcsud12,
                              g_hrcs[l_ac].hrcsud13,
                              g_hrcs[l_ac].hrcsud14,
                              g_hrcs[l_ac].hrcsud15,
                              g_user,g_grup,g_user,g_today,'Y',g_user,g_grup)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrcs_file",g_hrcs[l_ac].hrcs03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_hrcs_t.hrcs03 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM hrcs_file WHERE hrcs01 = g_head.hrcs01
                                    AND hrcs02 = g_head.hrcs02
                                    AND hrcs03 = g_hrcs_t.hrcs03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrcs_file",g_hrcs_t.hrcs03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
            LET g_hrcs[l_ac].* = g_hrcs_t.*
            CLOSE i059_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrcs[l_ac].hrcs03,-263,1)
            LET g_hrcs[l_ac].* = g_hrcs_t.*
         ELSE
            UPDATE hrcs_file SET 
                                hrcs01=g_head.hrcs01,
                                hrcs02=g_head.hrcs02,
                                hrcs03=g_hrcs[l_ac].hrcs03,
                                hrcs04=g_hrcs[l_ac].hrcs04,
                                hrcs05=g_hrcs[l_ac].hrcs05,  
                                hrcs06=g_hrcs[l_ac].hrcs06,  
                                hrcsud01=g_hrcs[l_ac].hrcsud01, 
                                hrcsud02=g_hrcs[l_ac].hrcsud02, 
                                hrcsud03=g_hrcs[l_ac].hrcsud03, 
                                hrcsud04=g_hrcs[l_ac].hrcsud04, 
                                hrcsud05=g_hrcs[l_ac].hrcsud05, 
                                hrcsud06=g_hrcs[l_ac].hrcsud06, 
                                hrcsud07=g_hrcs[l_ac].hrcsud07, 
                                hrcsud08=g_hrcs[l_ac].hrcsud08, 
                                hrcsud09=g_hrcs[l_ac].hrcsud09, 
                                hrcsud10=g_hrcs[l_ac].hrcsud10, 
                                hrcsud11=g_hrcs[l_ac].hrcsud11, 
                                hrcsud12=g_hrcs[l_ac].hrcsud12, 
                                hrcsud13=g_hrcs[l_ac].hrcsud13, 
                                hrcsud14=g_hrcs[l_ac].hrcsud14, 
                                hrcsud15=g_hrcs[l_ac].hrcsud15
             WHERE hrcs01 = g_head.hrcs01
               AND hrcs02 = g_head.hrcs02
               AND hrcs03 = g_hrcs_t.hrcs03 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrcs_file",g_head.hrcs01,g_hrcs_t.hrcs03,SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_hrcs[l_ac].* = g_hrcs_t.*
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
               LET g_hrcs[l_ac].* = g_hrcs_t.*
            END IF
            CLOSE i059_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i059_bcl
         COMMIT WORK

       ON ACTION controlp
          CASE
              WHEN INFIELD(hrcs05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '105'
                 LET g_qryparam.default1 = g_hrcs[l_ac].hrcs05
                 LET g_qryparam.form = "q_hrag06"
                 CALL cl_create_qry() RETURNING g_hrcs[l_ac].hrcs05
                 DISPLAY g_hrcs[l_ac].hrcs05 TO hrcs05
                 NEXT FIELD hrcs05                                                     
           OTHERWISE
              EXIT CASE
           END CASE  
            
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(hrcs01) AND l_ac > 1 THEN
            LET g_hrcs[l_ac].* = g_hrcs[l_ac-1].*
            NEXT FIELD hrcs03
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
 
   CLOSE i059_bcl
 
   COMMIT WORK
 
END FUNCTION

 
FUNCTION i059_b_fill()  
   DEFINE p_wc2   LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
   LET g_sql = "SELECT hrcs03,hrcs04,hrcs05,'',hrcs06,",
               "       hrcsud01,hrcsud02,hrcsud03,hrcsud04,hrcsud05,",
               "       hrcsud06,hrcsud07,hrcsud08,hrcsud09,hrcsud10,",
               "       hrcsud11,hrcsud12,hrcsud13,hrcsud14,hrcsud15 ",
               "  FROM hrcs_file ",                                         #FUN-B80058 add hrcs071,hrcs141
               " WHERE hrcs01 = '",g_head.hrcs01 CLIPPED,"' ",
               "   AND hrcs02 =  ",g_head.hrcs02,                     #單身
               " ORDER BY hrcs03"
   PREPARE i059_pb FROM g_sql
   DECLARE hrcs_curs CURSOR FOR i059_pb
 
   CALL g_hrcs.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH hrcs_curs INTO g_hrcs[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      CALL s_code('105',g_hrcs[g_cnt].hrcs05) RETURNING g_hrag.*
      LET g_hrcs[g_cnt].hrcs05_name = g_hrag.hrag07
                  
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_hrcs.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION

 
 
FUNCTION i059_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   
   DIALOG ATTRIBUTES(UNBUFFERED)
      
      DISPLAY ARRAY g_hrcs TO s_hrcs.* ATTRIBUTE(COUNT=g_rec_b)
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
FUNCTION i059_bp1(p_ud)
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
            SELECT hrcs06 INTO l_note FROM hrcs_file
             WHERE hrcs01 = g_head.hrcs01
               AND hrcs02 = g_head.hrcs02
               AND hrcs03 = g_sch[l_ac1].sch1
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


FUNCTION i059_hrcs01(p_cmd) 
 DEFINE p_cmd         LIKE type_file.chr1
 DEFINE p_hrat03      LIKE hrat_file.hrat03
   DEFINE l_hraa02    LIKE hraa_file.hraa02 
   DEFINE l_hraaacti  LIKE hraa_file.hraaacti 
   DEFINE l_n         LIKE type_file.num5

   LET g_errno = NULL
   SELECT hraa02,hraaacti INTO l_hraa02,l_hraaacti FROM hraa_file
    WHERE hraa01=g_head.hrcs01
    CASE
        WHEN SQLCA.sqlcode=100   LET g_errno='ghr-001'
                                 LET l_hraa02=NULL
   
        WHEN l_hraaacti='N'      LET g_errno='9028'
        OTHERWISE
             LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
   SELECT COUNT(*) INTO l_n FROM hrcs_file 
    WHERE hrcs01 = g_head.hrcs01
      AND hrcs02 = g_head.hrcs02
   IF l_n > 0 THEN 
   	  LET g_errno = 'ghr-054'
   END IF 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
   	  DISPLAY l_hraa02 TO hrcs01_name
   END IF 
   
END FUNCTION

FUNCTION i059_hrcs02() 
 DEFINE l_n  LIKE type_file.num5

   LET g_errno = NULL
   IF g_head.hrcs02 <2000 OR g_head.hrcs02 >2999 THEN
   	  LET g_errno = 'ghr-055'
   	  RETURN
   END IF 
   SELECT COUNT(*) INTO l_n FROM hrcs_file 
    WHERE hrcs01 = g_head.hrcs01
      AND hrcs02 = g_head.hrcs02
   IF l_n > 0 THEN 
   	  LET g_errno = 'ghr-054'
   END IF 
END FUNCTION


FUNCTION i059_month(p_year,p_month)
  DEFINE p_year    LIKE type_file.num5
  DEFINE p_month   LIKE type_file.num5
  
  IF p_year != g_head.hrcs02 THEN
     LET g_head.hrcs02 = p_year
     DISPLAY g_head.hrcs02 TO hrcs02
     CALL i059_b_fill()  	 
  END IF 
  LET g_head.cb1 = p_year
  LET g_head.cb1_name = p_year||'年'
  LET g_head.cb2 = g_head.cb1 * 12 + p_month
  LET g_head.cb2_name = g_head.cb1||'年'||p_month||'月'
  DISPLAY g_head.cb1_name,g_head.cb2_name TO cb1,cb2
  
  CALL i059_sch_fill(g_head.cb1,p_month)
END FUNCTION

FUNCTION i059_sch_fill(p_year,p_month)
  DEFINE  p_year  LIKE type_file.num5
  DEFINE  p_month LIKE type_file.num5
  DEFINE  l_hrcs03  LIKE hrcs_file.hrcs03     
  DEFINE  l_hrcs04  LIKE hrcs_file.hrcs04
  DEFINE  l_idx     LIKE type_file.num5
  DEFINE  l_first   LIKE type_file.num5
  DEFINE  l_last    LIKE type_file.num5  
  DEFINE  l_n       LIKE type_file.num5
  DEFINE  l_enter   LIKE type_file.chr1

    CALL g_sch.clear()
    CALL g_att.clear()
    LET l_idx = 0
    LET l_enter = 'N'
    LET g_sql = "SELECT hrcs03,hrcs04 FROM hrcs_file",
                " WHERE hrcs01 = '",g_head.hrcs01,"' ",
                "   AND hrcs02 =  ",g_head.hrcs02,
                "   AND YEAR(hrcs03) = ",p_year,
                "   AND MONTH(hrcs03) = ",p_month,
                " ORDER BY hrcs03 "
    PREPARE i059_date_prep FROM g_sql
    DECLARE i059_date_cs CURSOR FOR i059_date_prep
    FOREACH i059_date_cs INTO l_hrcs03,l_hrcs04
       IF SQLCA.sqlcode THEN 
          RETURN 
       END IF 
       CASE l_hrcs04 
          WHEN '7'  CALL i059_get_date(g_head.hrcs01,l_hrcs03) RETURNING g_sch[7*l_idx+1].sch,g_sch[7*l_idx+1].sch1,g_sch[7*l_idx+1].sch2
          WHEN '1'  CALL i059_get_date(g_head.hrcs01,l_hrcs03) RETURNING g_sch[7*l_idx+2].sch,g_sch[7*l_idx+2].sch1,g_sch[7*l_idx+2].sch2
          WHEN '2'  CALL i059_get_date(g_head.hrcs01,l_hrcs03) RETURNING g_sch[7*l_idx+3].sch,g_sch[7*l_idx+3].sch1,g_sch[7*l_idx+3].sch2
          WHEN '3'  CALL i059_get_date(g_head.hrcs01,l_hrcs03) RETURNING g_sch[7*l_idx+4].sch,g_sch[7*l_idx+4].sch1,g_sch[7*l_idx+4].sch2
          WHEN '4'  CALL i059_get_date(g_head.hrcs01,l_hrcs03) RETURNING g_sch[7*l_idx+5].sch,g_sch[7*l_idx+5].sch1,g_sch[7*l_idx+5].sch2
          WHEN '5'  CALL i059_get_date(g_head.hrcs01,l_hrcs03) RETURNING g_sch[7*l_idx+6].sch,g_sch[7*l_idx+6].sch1,g_sch[7*l_idx+6].sch2
          WHEN '6'  CALL i059_get_date(g_head.hrcs01,l_hrcs03) RETURNING g_sch[7*l_idx+7].sch,g_sch[7*l_idx+7].sch1,g_sch[7*l_idx+7].sch2
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
        LET l_hrcs03 = g_sch[l_first].sch1 - (l_first-l_n)
        CALL i059_get_date(g_head.hrcs01,l_hrcs03) RETURNING g_sch[l_n].sch,g_sch[l_n].sch1,g_sch[l_n].sch2
    END FOR 
    
    FOR l_n = l_last+1 TO 42 
         LET l_hrcs03 = g_sch[l_last].sch1 + l_n - l_last
         CALL i059_get_date(g_head.hrcs01,l_hrcs03) RETURNING g_sch[l_n].sch,g_sch[l_n].sch1,g_sch[l_n].sch2
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

FUNCTION i059_get_date(p_hrcs01,p_hrcs03)
  DEFINE p_hrcs01  LIKE hrcs_file.hrcs01
  DEFINE p_hrcs02  LIKE hrcs_file.hrcs02
  DEFINE p_hrcs03  LIKE hrcs_file.hrcs03  
  DEFINE l_hrcs    RECORD LIKE hrcs_file.*
  DEFINE l_day     LIKE type_file.num5   
  DEFINE l_str     STRING
  
  INITIALIZE l_hrcs.* TO NULL
   SELECT * INTO l_hrcs.* FROM hrcs_file 
    WHERE hrcs01 = p_hrcs01
      AND hrcs03 = p_hrcs03
   LET l_day = DAY(l_hrcs.hrcs03)
   LET l_str = l_day USING '#####'
#   IF NOT (l_hrcs.hrcs05 = '公休' OR
#           l_hrcs.hrcs06 = '工作日') THEN
#   	  LET l_str = l_str||'\n'||l_hrcs.hrcs06
#   END IF
   RETURN l_str,l_hrcs.hrcs03,l_hrcs.hrcs05
   
END FUNCTION

FUNCTION i059_cb1(p_step)
 DEFINE p_step   LIKE  type_file.num5
 
   LET g_head.cb1 = g_head.cb1+p_step
   
   LET g_head.cb1_name = g_head.cb1||'年'
   DISPLAY g_head.cb1_name TO cb1
END FUNCTION

FUNCTION i059_cb2(p_step)
 DEFINE p_step   LIKE  type_file.num5
 DEFINE l_year   LIKE  type_file.num5
 DEFINE l_month  LIKE  type_file.num5
 
   LET g_head.cb2 = g_head.cb2 + p_step
   
   LET l_month = g_head.cb2 MOD 12
   LET l_year = (g_head.cb2 - l_month)/12
   LET g_head.cb1 = l_year

   #add by zhangbo130905---begin
   IF l_month=0 THEN
      LET l_year = l_year-1
      LET g_head.cb1 = l_year
      LET l_month = 12
      LET g_head.cb2 = l_month
   END IF
   #add by zhangbo130905---end
   
   LET g_head.cb1_name = g_head.cb1||'年'
   LET g_head.cb2_name = g_head.cb1||'年'||l_month||'月'
   DISPLAY g_head.cb1_name,g_head.cb2_name TO cb1,cb2
   
   CALL i059_month(l_year,l_month)
END FUNCTION


FUNCTION i059_upd_note()
 DEFINE l_note  LIKE hrcs_file.hrcs06

      SELECT hrcs06 INTO l_note FROM hrcs_file
       WHERE hrcs01 = g_head.hrcs01
         AND hrcs02 = g_head.hrcs02
         AND hrcs03 = g_sch[l_ac1].sch1
         
      INPUT l_note WITHOUT DEFAULTS FROM formonly.note  
           
         ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
      END INPUT
      
      IF INT_FLAG THEN 
      	 RETURN 
      END IF 
      
      UPDATE hrcs_file SET hrcs06 = l_note
       WHERE hrcs01 = g_head.hrcs01
         AND hrcs02 = g_head.hrcs02
         AND hrcs03 = g_sch[l_ac1].sch1
      IF SQLCA.sqlcode THEN
      	 CALL cl_err3("upd","hrcs_file",g_hrcs[l_ac1].hrcs03,"",SQLCA.sqlcode,"","",1)   #No.FUN-660151
      END IF 
      
      CALL i059_b_fill()
END FUNCTION

