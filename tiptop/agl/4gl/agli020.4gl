# Prog. Version..: '5.30.06-13.04.01(00004)'     #
#
# Pattern name...: agli020.4gl
# Descriptions...: 合併財報會計科目資料維護作業-區分部門別
# Date & Author..: No.FUN-CA0085 13/02/23 By apo
# Modify.........: No.FUN-D20044 13/02/19 by apo 增加EXCEL匯入範本功能
# Modify.........: NO.CHI-D20029 13/03/18 by apo 部門欄位開窗資料應依公司所在營運中心
# Modify.........: No.FUN-D20047 13/03/20 By Lori 增加年度(ayf10),期別(ayf11)
#                                                 因某些科目是不做部門管理，所以不是每個科目都有部門代號，因此部門代號要可以為空白，空白時存入空字串 

IMPORT os   #FUN-D20044
DATABASE ds

GLOBALS "../../config/top.global"  #FUN-CA0085 

#模組變數(Module Variables)
DEFINE  g_ayf09         LIKE ayf_file.ayf09,      #FUN-910001 add
        g_ayf09_t       LIKE ayf_file.ayf09,      #FUN-910001 add 
        g_ayf10         LIKE ayf_file.ayf10,   #FUN-D20047 add
        g_ayf10_t       LIKE ayf_file.ayf10,   #FUN-D20047 add
        g_ayf01         LIKE ayf_file.ayf01,  
        g_ayf01_t       LIKE ayf_file.ayf01, 
        g_ayf01_o       LIKE ayf_file.ayf01,
        g_ayf11         LIKE ayf_file.ayf11,   #FUN-D20047 add
        g_ayf11_t       LIKE ayf_file.ayf11,   #FUN-D20047 add
        g_ayf00         LIKE ayf_file.ayf00,   #No.FUN-730070
        g_ayf00_t       LIKE ayf_file.ayf00,   #No.FUN-730070
        g_ayf00_o       LIKE ayf_file.ayf00,   #No.FUN-730070
        g_ayf           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        ayf02       LIKE ayf_file.ayf02,
        gem02       LIKE gem_file.gem02,
        ayf03       LIKE ayf_file.ayf03,
        gem02_1     LIKE gem_file.gem02,
        ayf04       LIKE ayf_file.ayf04,                 
        ayf05       LIKE ayf_file.ayf05,                 
        ayf06       LIKE ayf_file.ayf06,                  
        aag02       LIKE aag_file.aag02,
        ayf07       LIKE ayf_file.ayf07,   #FUN-580063
        ayf08       LIKE ayf_file.ayf08    #FUN-580063
                    END RECORD,
    g_ayf_t         RECORD                 #程式變數 (舊值)
        ayf02       LIKE ayf_file.ayf02,
        gem02       LIKE gem_file.gem02,
        ayf03       LIKE ayf_file.ayf03,
        gem02_1     LIKE gem_file.gem02,
        ayf04       LIKE ayf_file.ayf04,                 
        ayf05       LIKE ayf_file.ayf05,                 
        ayf06       LIKE ayf_file.ayf06,
        aag02       LIKE aag_file.aag02,
        ayf07       LIKE ayf_file.ayf07,   #FUN-580063
        ayf08       LIKE ayf_file.ayf08    #FUN-580063
                    END RECORD,
    i               LIKE type_file.num5,           #No.FUN-680098 smallint
    g_wc,g_sql,g_wc2    STRING, #TQC-630166      
    g_sql_tmp           STRING, #No.FUN-730070
    g_rec_b         LIKE type_file.num5,           #單身筆數        #No.FUN-680098 smallint
    g_ss            LIKE type_file.chr1,           #No.FUN-680098  VARCHAR(1)
    g_dbs_gl        LIKE aag_file.aag01,           #No.FUN-680098  VARCHAR(24)
    g_plant_gl      LIKE aag_file.aag01,
    l_ac            LIKE type_file.num5,           #目前處理的ARRAY CNT     #No.FUN-680098 smallint
    g_cnt           LIKE type_file.num5,           #目前處理的ARRAY CNT     #No.FUN-680098 smallint 
    tm              RECORD 
           axe13  LIKE axe_file.axe13,     
           axe01  LIKE axe_file.axe01, 
           axe00  LIKE axe_file.axe00,    
           y      LIKE type_file.chr1    
       END RECORD
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL 
DEFINE g_before_input_done   LIKE type_file.num5         
DEFINE g_axz03      LIKE axz_file.axz03 
DEFINE g_axz04      LIKE axz_file.axz04 
DEFINE g_azp03      LIKE azp_file.azp03 
DEFINE g_azp01      LIKE azp_file.azp01
DEFINE g_dbs_o      LIKE axz_file.axz03  
DEFINE g_str        STRING               
DEFINE g_i          LIKE type_file.num5    
DEFINE g_msg        LIKE type_file.chr1000 
DEFINE g_row_count  LIKE type_file.num10   
DEFINE g_curs_index LIKE type_file.num10   
DEFINE g_jump       LIKE type_file.num10   
DEFINE g_no_ask     LIKE type_file.num5    
DEFINE g_aaz641        LIKE aaz_file.aaz641 
DEFINE g_aaz641_g      LIKE aaz_file.aaz641 
DEFINE g_dbs_axz03     LIKE type_file.chr21 
DEFINE g_plant_axz03   LIKE type_file.chr21
DEFINE g_axa_count     LIKE type_file.num5  
DEFINE g_ayf00_def     LIKE ayf_file.ayf00  
DEFINE g_axb02         LIKE axb_file.axb02  
DEFINE g_axz05         LIKE axz_file.axz05  
DEFINE g_axz05_g       LIKE axz_file.axz05  
DEFINE g_axz03_g       LIKE axz_file.axz03  
DEFINE g_axz04_g       LIKE axz_file.axz04  
DEFINE g_axa09         LIKE axa_file.axa09  
DEFINE g_axa09_g       LIKE axa_file.axa09  
DEFINE g_file          STRING
DEFINE g_disk          LIKE type_file.chr1
DEFINE g_ayfl          RECORD LIKE ayf_file.*
DEFINE l_table         STRING
DEFINE gg_sql          STRING
DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_choice        LIKE type_file.chr1
DEFINE g_i020_01       LIKE type_file.chr1000
DEFINE g_cmd            LIKE type_file.chr100        #FUN-D20044
DEFINE sheet1           STRING                       #FUN-D20044
DEFINE li_result        LIKE type_file.num5          #FUN-D20044
DEFINE l_cmd            LIKE type_file.chr100        #FUN-D20044
DEFINE l_path           LIKE type_file.chr100        #FUN-D20044
DEFINE l_unixpath       LIKE type_file.chr100        #FUN-D20044

MAIN

   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

   LET i=0
   LET g_ayf09_t = NULL 
   LET g_ayf10_t = NULL  #FUN-D20047 add
   LET g_ayf01_t = NULL
   LET g_ayf11_t = NULL  #FUN-D20047 add
   LET g_ayf00_t = NULL  #No.FUN-730070

   OPEN WINDOW i020_w WITH FORM "agl/42f/agli020"
        ATTRIBUTE(STYLE = g_win_style)
   
   CALL cl_ui_init()

   CALL i020_menu()

   CLOSE FORM i020_w                      #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

FUNCTION i020_cs()
DEFINE l_axz03    LIKE axz_file.axz03    #CHI-D20029 

   CLEAR FORM                            #清除畫面
   CALL g_ayf.clear()
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 

   INITIALIZE g_ayf09 TO NULL    #FUN-910001 add 
   INITIALIZE g_ayf10 TO NULL    #FUN-D20047 add
   INITIALIZE g_ayf01 TO NULL    #No.FUN-750051
   INITIALIZE g_ayf11 TO NULL    #FUN-D20047 add
   INITIALIZE g_ayf00 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON ayf09,ayf10,ayf01,ayf11,ayf00,ayf02,ayf03,ayf04,ayf05,ayf06,ayf07,ayf08     #FUN-D20047 add ayf10,ayf11
                FROM ayf09,ayf10,ayf01,ayf11,ayf00,s_ayf[1].ayf02,s_ayf[1].ayf03,                #FUN-D20047 add ayf10,ayf11
                     s_ayf[1].ayf04,s_ayf[1].ayf05,        
                     s_ayf[1].ayf06,s_ayf[1].ayf07,s_ayf[1].ayf08

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         LET g_ayf10 = null   #FUN-D20047 add
         LET g_ayf11 = null   #FUN-D20047 add
         DISPLAY g_ayf10 TO ayf10  #FUN-D20047 add
         DISPLAY g_ayf11 TO ayf11  #FUN-D20047 add

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ayf09) #族群編號                                                                                   
                 CALL cl_init_qry_var()                                                                                       
                 LET g_qryparam.state = "c"                                                                                   
                 LET g_qryparam.form = "q_axa1"                                                                               
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                           
                 DISPLAY g_qryparam.multiret TO ayf09                                                                         
                 NEXT FIELD ayf09                                                                                             
            WHEN INFIELD(ayf01)  
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_axz"      
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ayf01  
               NEXT FIELD ayf01
            WHEN INFIELD(ayf00)  
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aaa"     
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ayf00  
               NEXT FIELD ayf00
            WHEN INFIELD(ayf02)
              #--CHI-D20029 mark start--
              #CALL cl_init_qry_var()
              #LET g_qryparam.state = "c"
              #LET g_qryparam.form ="q_gem"
              #CALL cl_create_qry() RETURNING g_qryparam.multiret
              #DISPLAY g_qryparam.multiret TO ayf02
              #---CHI-D20029 mark end--
              #---CHI-D20029 start--
               SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01= g_ayf01
               CALL q_m_gem(TRUE,TRUE,g_ayf[l_ac].ayf02,l_axz03) 
               RETURNING g_ayf[l_ac].ayf02
               DISPLAY BY NAME g_ayf[l_ac].ayf02
               NEXT FIELD ayf02
              #---CHI-D20029 end--
            WHEN INFIELD(ayf03)
              #--CHI-D20029 mark start--
              #CALL cl_init_qry_var()
              #LET g_qryparam.state = "c"
              #LET g_qryparam.form ="q_gem"
              #CALL cl_create_qry() RETURNING g_qryparam.multiret
              #DISPLAY g_qryparam.multiret TO ayf03
              #---CHI-D20029 mark end---
              #---CHI-D20029 start--
               SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01= g_ayf01
               CALL q_m_gem(TRUE,TRUE,g_ayf[l_ac].ayf03,l_axz03) 
               RETURNING g_ayf[l_ac].ayf03
               DISPLAY BY NAME g_ayf[l_ac].ayf03
               NEXT FIELD ayf03
              #---CHI-D20029 end--
            WHEN INFIELD(ayf04)  
                CALL q_m_aag4(TRUE,TRUE,g_plant_gl,g_ayf[1].ayf04,'23',g_ayf00) 
                     RETURNING g_qryparam.multiret  
                DISPLAY g_qryparam.multiret TO ayf04 
               NEXT FIELD ayf04
           WHEN INFIELD(ayf06)  
               CALL q_m_aag4(TRUE,TRUE,g_plant_axz03,g_ayf[1].ayf06,'23',g_aaz641) 
                    RETURNING g_qryparam.multiret                                                                                   
               DISPLAY g_qryparam.multiret TO ayf06                                                                                 
               NEXT FIELD ayf06                                                                                                     
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
            CALL cl_qbe_select() 
          ON ACTION qbe_save
	    CALL cl_qbe_save()

   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ayfuser', 'ayfgrup')
   IF INT_FLAG THEN
      RETURN 
   END IF

   LET g_sql = "SELECT UNIQUE ayf09,ayf10,ayf01,ayf11,ayf00 FROM ayf_file ",     #FUN-D20047 add ayf10,ayf11
               " WHERE ", g_wc CLIPPED,
               " ORDER BY ayf09,ayf01,ayf00" 
   PREPARE i020_prepare FROM g_sql        #預備一下
   DECLARE i020_bcs SCROLL CURSOR WITH HOLD FOR i020_prepare

   LET g_sql_tmp = "SELECT UNIQUE ayf09,ayf10,ayf01,ayf11,ayf00 ",               #FUN-D20047 add ayf10,ayf11   
                   "  FROM ayf_file WHERE ", g_wc CLIPPED,
                   "  INTO TEMP x "
   DROP TABLE x
   PREPARE i020_pre_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i020_pre_x
   LET g_sql = "SELECT COUNT(*) FROM x"
   PREPARE i020_precount FROM g_sql
   DECLARE i020_count CURSOR FOR i020_precount

END FUNCTION

FUNCTION i020_menu()

   WHILE TRUE
      CALL i020_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i020_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i020_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i020_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i020_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i020_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i020_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "batch_generate"
            IF cl_chk_act_auth() THEN
               CALL i020_g()
            END IF
          WHEN "related_document" 
            IF cl_chk_act_auth() THEN
               IF g_ayf01 IS NOT NULL THEN
                  LET g_doc.column1 = "ayf09"                                                                               
                  LET g_doc.value1 = g_ayf09                                                                                
                  LET g_doc.column2 = "ayf01"                                                                               
                  LET g_doc.value2 = g_ayf01                                                                                
                  LET g_doc.column3 = "ayf00"                                                                               
                  LET g_doc.value3 = g_ayf00                                                                                
                  LET g_doc.column4 = "ayf10"   #FUN-D20047
                  LET g_doc.value4 = g_ayf10    #FUN-D20047
                  LET g_doc.column5 = "ayf11"   #FUN-D20047
                  LET g_doc.value5 = g_ayf11    #FUN-D20047                                                                               
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ayf),'','')
            END IF
         WHEN "dataload"                        # 資料匯入
            CALL i020_dataload()
        #FUN-D20044--
         WHEN "excelexample"                    # 匯出Excel範本
            LET l_unixpath = os.Path.join( os.Path.join( os.Path.join(FGL_GETENV("TOP"),"tool"),"report"),"aglsample.xls")
            LET l_path = "C:\\tiptop\\agli020.xls"
            LET g_cmd = "EXCEL ",l_path
            LET sheet1 = "sheet1"
            LET li_result = cl_download_file(l_unixpath,l_path)
            IF STATUS THEN
               CALL cl_err('',"amd-021",1)
               DISPLAY "Download fail!!"
               LET g_success = 'N'
               RETURN
            END IF
            CALL ui.Interface.frontCall("standard","shellexec",[g_cmd],[])
            SLEEP 10
            CALL ui.Interface.frontCall("WINDDE","DDEConnect",[g_cmd,sheet1],[li_result])
            CALL i020_exceldata()
            CALL ui.Interface.frontCall("WINDDE","DDEFinish",[l_cmd,sheet1],[li_result])
        #FUN-D20044--
      END CASE
   END WHILE
END FUNCTION

FUNCTION i020_a()

   IF s_aglshut(0) THEN
      RETURN
   END IF  

   MESSAGE ""
   CLEAR FORM
   CALL g_ayf.clear()
   INITIALIZE g_ayf09 LIKE ayf_file.ayf09      #DEFAULT 設定  #FUN-910001 add  
   INITIALIZE g_ayf01 LIKE ayf_file.ayf01         #DEFAULT 設定
   INITIALIZE g_ayf00 LIKE ayf_file.ayf00         #DEFAULT 設定  #No.FUN-730070
   INITIALIZE g_ayf10 LIKE ayf_file.ayf10         #FUN-D20047 add
   INITIALIZE g_ayf11 LIKE ayf_file.ayf11         #FUN-D20047 add 

   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i020_i("a")                           #輸入單頭

      IF INT_FLAG THEN                           #使用者不玩了
         LET g_ayf09=NULL  #FUN-910001 add
         LET g_ayf10=NULL    #FUN-D20047 add
         LET g_ayf01=NULL
         LET g_ayf11=NULL    #FUN-D20047 add
         LET g_ayf00=NULL  #No.FUN-730070
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      LET g_rec_b = 0                    #No.FUN-680064
      IF g_ss='N' THEN
         CALL g_ayf.clear()
      ELSE
         CALL i020_b_fill('1=1')         #單身
      END IF

      CALL i020_b()                       #輸入單身

      LET g_ayf09_t = g_ayf09            #保留舊值  #FUN-910001 add 
      LET g_ayf10_t = g_ayf10             #FUN-D20047 add
      LET g_ayf01_t = g_ayf01             #保留舊值
      LET g_ayf11_t = g_ayf11             #FUN-D20047 add
      LET g_ayf00_t = g_ayf00             #保留舊值  #No.FUN-730070
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION i020_i(p_cmd)
DEFINE
   l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入   #No.FUN-680098 VARCHAR(1)
   l_n1,l_n        LIKE type_file.num5,          #No.FUN-680098  smallint
   p_cmd           LIKE type_file.chr1           #a:輸入 u:更改        #No.FUN-680098 VARCHAR(1)
DEFINE l_axz04     LIKE axz_file.axz04

   LET g_ss = 'Y'

   DISPLAY g_ayf09 TO ayf09   #FUN-910001 add 
   DISPLAY g_ayf10 TO ayd10   #FUN-D20047 add  
   DISPLAY g_ayf01 TO ayf01 
   DISPLAY g_ayf11 TO ayf11   #FUN-D20047 add
   DISPLAY g_ayf00 TO ayf00   #No.FUN-730070
   CALL cl_set_head_visible("","YES")         
   INPUT g_ayf09,g_ayf10,g_ayf01,g_ayf11,g_ayf00 WITHOUT DEFAULTS FROM ayf09,ayf10,ayf01,ayf11,ayf00   #No.FUN-730070  #FUN-910001    #FUN-D20047 add ayf10,ayf11
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i020_set_entry(p_cmd) 
         CALL i020_set_no_entry(p_cmd) 
         LET g_before_input_done = TRUE
         LET g_ayf10 = year(g_today)   #FUN-D20047 add
         LET g_ayf11 = month(g_today)  #FUN-D20047 add
         DISPLAY g_ayf10 TO ayf10      #FUN-D20047 add
         DISPLAY g_ayf11 TO ayf11      #FUN-D20047 add

      AFTER FIELD ayf09   #族群代號                                                                                         
         IF cl_null(g_ayf09) THEN                                                                                           
            CALL cl_err(g_ayf09,'mfg0037',0)                                                                                
            NEXT FIELD ayf09                                                                                                
         ELSE                                                                                                               
            LET g_ayf09_t = g_ayf09    #FUN-D20047 add                                                                                                                
            LET l_n = 0                                                                                                     
            SELECT COUNT(*) INTO l_n FROM axa_file                                                                          
             WHERE axa01=g_ayf09                                                                                            
            IF cl_null(l_n) THEN LET l_n = 0 END IF                                                                         
            IF l_n = 0 THEN                                                                                                 
               CALL cl_err(g_ayf09,'agl-223',0)                                                                             
               NEXT FIELD ayf09                                                                                             
            END IF                                                                                                          
        END IF                                                                                                             

      AFTER FIELD ayf01 
         IF NOT cl_null(g_ayf01) THEN 
               CALL i020_ayf01('a',g_ayf01) RETURNING g_ayf00
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ayf01,g_errno,0)
                  NEXT FIELD ayf01
               ELSE
                  LET g_ayf00_t = g_ayf00   #FUN-D20047 add
                  DISPLAY g_ayf00 TO ayf00
               END IF
             LET g_ayf01_t = g_ayf01   #FUN-D20047 add
             IF g_ayf09 IS NOT NULL AND g_ayf01 IS NOT NULL AND                                                              
                g_ayf00 IS NOT NULL THEN                                                                                     
                LET l_n = 0   LET l_n1 = 0                                                                                   
                SELECT COUNT(*) INTO l_n FROM axa_file                                                                       
                 WHERE axa01=g_ayf09 AND axa02=g_ayf01                                                                       
                   AND axa03=g_ayf00                                                                                         
                SELECT COUNT(*) INTO l_n1 FROM axb_file                                                                      
                WHERE axb01=g_ayf09 AND axb04=g_ayf01                                                                       
                  AND axb05=g_ayf00                                                                                         
                IF l_n+l_n1 = 0 THEN                                                                                         
                   CALL cl_err(g_ayf01,'agl-223',0)                                                                          
                   LET g_ayf09 = g_ayf09_t                                                                                   
                   LET g_ayf01 = g_ayf01_t                                                                                   
                   LET g_ayf00 = g_ayf00_t                                                                                   
                   DISPLAY BY NAME g_ayf09,g_ayf01,g_ayf00                                                                   
                   NEXT FIELD ayf01                                                                                          
                END IF                                                                                                       
             END IF                                                                                                          
         END IF

      AFTER FIELD ayf00
         IF cl_null(g_ayf01) THEN NEXT FIELD ayf01 END IF
         IF NOT cl_null(g_ayf00) THEN
            CALL i020_ayf00('a',g_ayf00)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ayf00,g_errno,0)
               NEXT FIELD ayf00
            END IF
            #增加公司+帳別的合理性判斷,應存在agli009
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axz_file
             WHERE axz01=g_ayf01 AND axz05=g_ayf00
            IF l_n = 0 THEN
               CALL cl_err(g_ayf00,'agl-946',0)
               NEXT FIELD ayf00
            END IF
            IF g_ayf09 != g_ayf09_t OR cl_null(g_ayf09_t) OR                                                                
               g_ayf01 != g_ayf01_t OR cl_null(g_ayf01_t) OR                                                                
               g_ayf00 != g_ayf00_t OR cl_null(g_ayf00_t) THEN                                                              
               LET g_cnt = 0 
               SELECT COUNT(*) INTO g_cnt FROM ayf_file
                WHERE ayf01=g_ayf01
                  AND ayf00=g_ayf00
                  AND ayf09=g_ayf09   
               IF g_cnt = 0  THEN     
                  IF p_cmd = 'a' THEN 
                     LET g_ss = 'N' 
                  END IF
               ELSE
                  IF p_cmd='u' THEN
                     CALL cl_err(g_ayf01,-239,0)
                     LET g_ayf09=g_ayf09_t   
                     LET g_ayf01=g_ayf01_t
                     LET g_ayf00=g_ayf00_t
                     NEXT FIELD ayf01
                  END IF
               END IF
               LET l_n = 0   LET l_n1 = 0                                                                                           
               SELECT COUNT(*) INTO l_n FROM axa_file                                                                               
                WHERE axa01=g_ayf09 AND axa02=g_ayf01                                                                               
                  AND axa03=g_ayf00                                                                                                 
               SELECT COUNT(*) INTO l_n1 FROM axb_file                                                                              
                WHERE axb01=g_ayf09 AND axb04=g_ayf01                                                                               
                  AND axb05=g_ayf00                                                                                                 
               IF l_n+l_n1 = 0 THEN                                                                                                 
                  CALL cl_err(g_ayf01,'agl-223',0)                                                                                  
                  LET g_ayf09 = g_ayf09_t                                                                                           
                  LET g_ayf01 = g_ayf01_t                                                                                           
                  LET g_ayf00 = g_ayf00_t                                                                                           
                  DISPLAY BY NAME g_ayf09,g_ayf01,g_ayf00                                                                           
                  NEXT FIELD ayf01                                                                                                  
               END IF                                                                                                               
            END IF
         END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
        

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ayf09) #族群編號                                                                                           
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_axa1"                                                                                        
               LET g_qryparam.default1 = g_ayf09                                                                                    
               CALL cl_create_qry() RETURNING g_ayf09                                                                               
               DISPLAY g_ayf09 TO ayf09                                                                                             
               NEXT FIELD ayf09                                                                                                     
            WHEN INFIELD(ayf01)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"     #FUN-580063
               LET g_qryparam.default1 = g_ayf01
               CALL cl_create_qry() RETURNING g_ayf01
               DISPLAY g_ayf01 TO ayf01 
               NEXT FIELD ayf01
            WHEN INFIELD(ayf00)  
               SELECT azp03 INTO g_azp03 FROM axz_file,azp_file
                WHERE axz01=g_ayf01 AND axz03=azp01
               SELECT azp01 INTO g_azp01 FROM axz_file,azp_file      
                WHERE axz01=g_ayf01 AND axz03=azp01                 
               IF cl_null(g_azp03) THEN LET g_azp03 = g_dbs END IF  
               IF cl_null(g_azp01) THEN LET g_azp01 = g_plant END IF  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa4"    #FUN-580063   #TQC-760205 q_aaa->q_aaa4
               LET g_qryparam.default1 = g_ayf00
               LET g_qryparam.plant = g_azp01
               CALL cl_create_qry() RETURNING g_ayf00
               DISPLAY g_ayf00 TO ayf00 
               NEXT FIELD ayf00
            OTHERWISE EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
      
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
   
   END INPUT
 
END FUNCTION
   
FUNCTION i020_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("ayf09,ayf10,ayf01,ayf11,ayf00",TRUE)  #No.FUN-73070  #FUN-910001 add ayf09   #FUN-D20047 add ayf10,ayf11
   END IF 

END FUNCTION

FUNCTION i020_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("ayf09,ayf10,ayf01,ayf11,ayf00",FALSE)   #No.FUN-73070    #FUN-910001 add ayf09    #FUN-D20047 ayf10,ayf11
   END IF 

   CALL cl_set_comp_entry("ayf00",FALSE)  #FUN-920035  
END FUNCTION

#MOD-5A0443
FUNCTION i020_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
END FUNCTION

FUNCTION i020_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
          l_axz04 LIKE axz_file.axz04

   SELECT axz04 INTO l_axz04 FROM axz_file
      WHERE axz01 = g_ayf01
   IF l_axz04 = 'Y' THEN
      CALL cl_set_comp_entry ("ayf05",FALSE)
   END IF
END FUNCTION

FUNCTION i020_ayf01(p_cmd,p_ayf01)  
DEFINE p_cmd           LIKE type_file.chr1,  
       p_ayf01         LIKE ayf_file.ayf01,
       l_axz02         LIKE axz_file.axz02,
       l_axz03         LIKE axz_file.axz03,
       l_axz05         LIKE axz_file.axz05  

    LET g_errno = ' '

    SELECT axz02,axz03,axz05 INTO l_axz02,l_axz03,l_axz05   
      FROM axz_file
     WHERE axz01 = p_ayf01

    CASE
       WHEN SQLCA.SQLCODE=100 
          LET g_errno = 'aco-025'   
          LET l_axz02 = NULL
          LET l_axz03 = NULL 
       OTHERWISE
          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE

    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_axz02 TO FORMONLY.axz02 
       DISPLAY l_axz03 TO FORMONLY.axz03
    END IF
    RETURN l_axz05 
END FUNCTION

FUNCTION i020_ayf00(p_cmd,p_ayf00)
  DEFINE p_cmd     LIKE type_file.chr1,  
         p_ayf00   LIKE ayf_file.ayf00,
         l_aaaacti LIKE aaa_file.aaaacti,
         l_azp01   LIKE azp_file.azp01 
 
    LET g_errno = ' '
    SELECT azp01 INTO l_azp01 FROM azp_file,axz_file
     WHERE azp01 = axz03 
       AND axz01 = g_ayf01
    LET g_sql = "SELECT aaaacti FROM ",cl_get_target_table(l_azp01,'aaa_file'), 
                " WHERE aaa01 = '",p_ayf00,"'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql   
    CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
    PREPARE aaa_pre FROM g_sql
    DECLARE aaa_cs CURSOR FOR aaa_pre
    OPEN aaa_cs 
    FETCH aaa_cs INTO l_aaaacti
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
END FUNCTION

FUNCTION i020_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_ayf09 TO NULL             #FUN-910001 add 
   INITIALIZE g_ayf10 TO NULL             #FUN-D20047 add
   INITIALIZE g_ayf01 TO NULL             #No.FUN-6B0040
   INITIALIZE g_ayf11 TO NULL             #FUN-D20047 add
   INITIALIZE g_ayf00 TO NULL             #No.FUN-6B0040  #No.FUN-730070
   MESSAGE ""
   CLEAR FORM
   CALL g_ayf.clear()

   CALL i020_cs()                         #取得查詢條件

   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF

   OPEN i020_bcs                          #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                  #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ayf09 TO NULL  #FUN-910001 add
      INITIALIZE g_ayf10 TO NULL  #FUN-D20047 add 
      INITIALIZE g_ayf01 TO NULL
      INITIALIZE g_ayf11 TO NULL  #FUN-D20047 add
      INITIALIZE g_ayf00 TO NULL  #No.FUN-730070
   ELSE
      CALL i020_fetch('F')                #讀出TEMP第一筆並顯示

      OPEN i020_count
      FETCH i020_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
   END IF
END FUNCTION

FUNCTION i020_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098 integer

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i020_bcs INTO g_ayf09,g_ayf10,g_ayf01,g_ayf11,g_ayf00  #No.FUN-730070  #FUN-910001 add ayf09    #FUN-D20047 add ayf10,ayf11
      WHEN 'P' FETCH PREVIOUS i020_bcs INTO g_ayf09,g_ayf10,g_ayf01,g_ayf11,g_ayf00  #No.FUN-730070  #FUN-910001 add ayf09    #FUN-D20047 add ayf10,ayf11
      WHEN 'F' FETCH FIRST    i020_bcs INTO g_ayf09,g_ayf10,g_ayf01,g_ayf11,g_ayf00  #No.FUN-730070  #FUN-910001 add ayf09    #FUN-D20047 add ayf10,ayf11 
      WHEN 'L' FETCH LAST     i020_bcs INTO g_ayf09,g_ayf10,g_ayf01,g_ayf11,g_ayf00  #No.FUN-730070  #FUN-910001 add ayf09    #FUN-D20047 add ayf10,ayf11
      WHEN '/' 
         IF (NOT g_no_ask) THEN 
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump

               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
                ON ACTION about         #MOD-4C0121
                   CALL cl_about()      #MOD-4C0121
            
                ON ACTION help          #MOD-4C0121
                   CALL cl_show_help()  #MOD-4C0121
            
                ON ACTION controlg      #MOD-4C0121
                   CALL cl_cmdask()     #MOD-4C0121
              
              END PROMPT
 
              IF INT_FLAG THEN
                 LET INT_FLAG = 0 
                 EXIT CASE 
              END IF
           END IF

           FETCH ABSOLUTE g_jump i020_bcs INTO g_ayf09,g_ayf10,g_ayf01,g_ayf11,g_ayf00  #No.FUN-730070  #FUN-910001 add ayf09   #FUN-D20047 add ayf10,ayf11
           LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_ayf01,SQLCA.sqlcode,0)
      INITIALIZE g_ayf09 TO NULL  #FUN-910001 add  
      INITIALIZE g_ayf10 TO NULL  #FUN-D20047 add
      INITIALIZE g_ayf01 TO NULL  #TQC-6B0105
      INITIALIZE g_ayf11 TO NULL  #FUN-D20047 add
      INITIALIZE g_ayf00 TO NULL  #TQC-6B0105  #No.FUN-730070
   ELSE
      CALL i020_show()

      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
   
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF

END FUNCTION

FUNCTION i020_show()

   DISPLAY g_ayf09 TO ayf09  
   DISPLAY g_ayf01 TO ayf01 

   CALL i020_ayf01('d',g_ayf01) RETURNING g_ayf00
   DISPLAY g_ayf00 TO ayf00

   CALL i020_ayf00('d',g_ayf00)     

   #FUN-D20047 add begin---
   IF cl_null(g_ayf10) OR g_ayf10 = 0 THEN
      LET g_ayf10 = NULL
   END IF

   IF cl_null(g_ayf11) OR g_ayf11 = 0 THEN
      LET g_ayf11 = NULL
   END IF

   DISPLAY g_ayf10 TO ayf10   
   DISPLAY g_ayf11 TO ayf11   
   #FUN-D20047 add end-----

   CALL i020_getdbs(g_ayf01,g_ayf09) 
   CALL s_aaz641_dbs(g_ayf09,g_ayf01) RETURNING g_plant_axz03     
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641      
   CALL i020_b_fill(g_wc)              #單身

   CALL cl_show_fld_cont()  
END FUNCTION

FUNCTION i020_r()
   DEFINE l_chr LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)

   IF s_aglshut(0) THEN RETURN END IF

   IF cl_null(g_ayf09) OR cl_null(g_ayf01) OR cl_null(g_ayf00) THEN   #No.FUN-730070  #FUN-910001 
      CALL cl_err('',-400,0)
      RETURN 
   END IF

   BEGIN WORK

   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ayf09"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ayf09       #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "ayf01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_ayf01       #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "ayf00"      #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_ayf00       #No.FUN-9B0098 10/02/24
       LET g_doc.column4 = "ayf10"      #FUN-D20047 add
       LET g_doc.value4 = "ayf10"       #FUN-D20047 add
       LET g_doc.column5 = "ayf11"      #FUN-D20047 add
       LET g_doc.value5 = "ayf11"       #FUN-D20047 add
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM ayf_file WHERE ayf01=g_ayf01 
                             AND ayf00=g_ayf00  #No.FUN-730070
                             AND ayf09=g_ayf09  #FUN-910001 add
                             AND ayf10=g_ayf10  #FUN-D20047 add
                             AND ayf11=g_ayf11  #FUN-D20047 add
      IF SQLCA.sqlcode THEN
          CALL cl_err3("del","ayf_file",g_ayf01,g_ayf00,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660123  #No.FUN-730070
      ELSE
         CLEAR FORM
         CALL g_ayf.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'

         DROP TABLE x
         PREPARE i003_pre_x2 FROM g_sql_tmp
         EXECUTE i003_pre_x2              
         OPEN i020_count
         FETCH i020_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt

         OPEN i020_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i020_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i020_fetch('/')
         END IF
      END IF

      LET g_msg=TIME

      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
                   VALUES ('agli020',g_user,g_today,g_msg,g_ayf01,'delete',g_plant,g_legal)
   END IF

   COMMIT WORK

END FUNCTION

FUNCTION i020_b()
DEFINE
    l_ayf05         LIKE ayf_file.ayf05,
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,      #檢查重複用      
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否    
    p_cmd           LIKE type_file.chr1,      #處理狀態     
    l_sql           LIKE type_file.chr1000,   
    l_allow_insert  LIKE type_file.chr1,      #可新增否  
    l_allow_delete  LIKE type_file.chr1,      #可刪除否
    l_axz04         LIKE axz_file.axz04,      
    l_axz03         LIKE axz_file.axz03      
DEFINE l_axb02      LIKE axb_file.axb02       
DEFINE l_axa09      LIKE axa_file.axa09      
DEFINE l_aag04      LIKE aag_file.aag04       
DEFINE l_cnt        LIKE type_file.num5     
DEFINE l_axe05      LIKE axe_file.axe05

   IF s_aglshut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   CALL s_aaz641_dbs(g_ayf09,g_ayf01) RETURNING g_plant_axz03      

   CALL s_aaz641_dbs(g_ayf09,g_ayf01) RETURNING g_dbs_axz03 
   CALL i020_getdbs(g_ayf01,g_ayf09) 
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   LET g_forupd_sql = "SELECT ayf02,'',ayf03,'',ayf04,ayf05,ayf06,'',ayf07,ayf08 FROM ayf_file ",  #FUN-580063
                      " WHERE ayf09= ? AND ayf01= ? AND ayf00 = ? ",
                      "   AND ayf10= ? AND ayf11= ? ",                                             #FUN-D20047 add
                      "   AND ayf02 =? AND ayf03 = ? ",
                      "   AND ayf04 = ? FOR UPDATE " 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i020_bcl CURSOR FROM g_forupd_sql       # LOCK CURSOR

   LET l_ac_t = 0
   INPUT ARRAY g_ayf WITHOUT DEFAULTS FROM s_ayf.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,
                   DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL cl_set_comp_required("ayf02,ayf03",FALSE)    #FUN-D20047 add

      BEFORE ROW
         LET p_cmd='' 
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()

         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_ayf_t.* = g_ayf[l_ac].*  #BACKUP

            OPEN i020_bcl USING g_ayf09,g_ayf01,g_ayf00,g_ayf10,g_ayf11,g_ayf_t.ayf02,g_ayf_t.ayf03,g_ayf_t.ayf04    #FUN-D20047 add ayf10,ayf11
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ayf_t.ayf04,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i020_bcl INTO g_ayf[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ayf_t.ayf04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i020_gem(g_ayf[l_ac].ayf02) RETURNING g_ayf[l_ac].gem02
                  CALL i020_gem(g_ayf[l_ac].ayf03) RETURNING g_ayf[l_ac].gem02_1
                  CALL i020_ayf06(l_ac)
                  LET g_errno = ' '            
                  DISPLAY BY NAME g_ayf[l_ac].gem02
                  DISPLAY BY NAME g_ayf[l_ac].gem02_1
               END IF
            END IF

            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF 

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ayf[l_ac].* TO NULL
         LET g_ayf_t.* = g_ayf[l_ac].*  
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD ayf02

      AFTER INSERT
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

         #FUN-D20047 add begin---
         IF cl_null(g_ayf[l_ac].ayf02) THEN
            LET g_ayf[l_ac].ayf02 = ' '
         END IF
         IF cl_null(g_ayf[l_ac].ayf03) THEN
            LET g_ayf[l_ac].ayf03 = ' '
         END IF
         #FUN-D20047 add end-----
         INSERT INTO ayf_file(ayf00,ayf01,ayf02,ayf03,ayf04,ayf05,ayf06,ayf07,ayf08,ayfacti,ayfuser, 
                              ayfgrup,ayfmodu,ayfdate,ayf09,ayforiu,ayforig,ayf10,ayf11)                #FUN-D20047 add ayf10,ayf11
                       VALUES(g_ayf00,g_ayf01,g_ayf[l_ac].ayf02,
                              g_ayf[l_ac].ayf03,g_ayf[l_ac].ayf04,g_ayf[l_ac].ayf05,  
                              g_ayf[l_ac].ayf06,g_ayf[l_ac].ayf07,g_ayf[l_ac].ayf08,
                              'Y',g_user,g_grup,g_user,g_today,g_ayf09, g_user, g_grup,g_ayf10,g_ayf11)   #FUN-D20047 add ayf10,ayf11

         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ayf_file",g_ayf01,g_ayf[l_ac].ayf04,SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

        AFTER FIELD ayf02
           #IF g_ayf[l_ac].ayf02 = ' ' THEN NEXT FIELD ayf02 END IF   #FUN-D20047 mark
            #FUN-D20047 add begin---
            IF cl_null(g_ayf[l_ac].ayf02) OR g_ayf[l_ac].ayf02 = '' THEN 
               LET g_ayf[l_ac].ayf02 = ' '
            END IF   
            #FUN-D20047 add end-----
            IF NOT cl_null(g_ayf[l_ac].ayf02) THEN
                CALL i020_gem(g_ayf[l_ac].ayf02) RETURNING g_ayf[l_ac].gem02
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ayf[l_ac].ayf02,g_errno,1)
                   LET g_ayf[l_ac].ayf02=g_ayf_t.ayf02
                   DISPLAY BY NAME g_ayf[l_ac].ayf02
                   NEXT FIELD ayf02
                ELSE
                   DISPLAY BY NAME g_ayf[l_ac].gem02
                END IF
            END IF
      
        AFTER FIELD ayf03
           #IF g_ayf[l_ac].ayf03 = ' ' THEN NEXT FIELD ayf03 END IF   #FUN-D20047 mark
            IF cl_null(g_ayf[l_ac].ayf03) OR g_ayf[l_ac].ayf03 = '' THEN LET g_ayf[l_ac].ayf03 = ' '  END IF     #FUN-D20047 add 
            IF NOT cl_null(g_ayf[l_ac].ayf03) THEN
                CALL i020_gem(g_ayf[l_ac].ayf03) RETURNING g_ayf[l_ac].gem02_1
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ayf[l_ac].ayf03,g_errno,1)
                   LET g_ayf[l_ac].ayf03=g_ayf_t.ayf03
                   DISPLAY BY NAME g_ayf[l_ac].ayf03
                   NEXT FIELD ayf03
                ELSE
                   DISPLAY BY NAME g_ayf[l_ac].gem02_1
                END IF
            END IF

         AFTER FIELD ayf04
         IF NOT cl_null(g_ayf[l_ac].ayf04) THEN 
             IF (g_ayf_t.ayf04 IS NOT NULL AND g_ayf[l_ac].ayf04 != g_ayf_t.ayf04) OR g_ayf_t.ayf04 IS NULL THEN  
                 LET l_axz04 = ' '
                 SELECT axz04 INTO l_axz04 FROM axz_file
                    WHERE axz01 = g_ayf01
                 IF l_axz04 = 'N' THEN   #非TIPTOP公司
                     LET l_sql = " SELECT count(*) ",
                                  "  FROM ",cl_get_target_table(g_plant_gl,'axq_file'),   
                                  " WHERE axq04 = '",g_ayf01,"'",
                                  " AND axq01 = '",g_ayf09,"'",
                                  " AND axq041 = '",g_ayf00,"'",
                                  " AND axq05 = '", g_ayf[l_ac].ayf04,"'"
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql   
                     CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql
                     PREPARE axq_sel3 FROM l_sql 
                     EXECUTE axq_sel3 INTO l_n
                     IF l_n=0 THEN
                        CALL cl_err(g_ayf[l_ac].ayf04,'agl-229',0)
                        NEXT FIELD ayf04
                     END IF
                 ELSE
                     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_gl,'aag_file'),
                                 " WHERE aag00 = '",g_ayf00,"' ",  
               	                 " AND aag07 IN ('2','3')",
                                 " AND aag09 = 'Y'"                 
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql  
                     CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql 
                     DECLARE axq_sel4 CURSOR FROM l_sql
                     OPEN axq_sel4 
                     FETCH axq_sel4 INTO l_n
                     CLOSE axq_sel4 
                     IF l_n=0 THEN
                        CALL cl_err(g_ayf[l_ac].ayf04,'agl-229',0)
                        NEXT FIELD ayf04
                     END IF                                     
                  END IF
                  LET g_errno = ' '
                  LET l_ayf05 = ' '
                  LET l_aag04 = ''
                  LET l_sql = " SELECT aag04 FROM ",cl_get_target_table(g_plant_gl,'aag_file'),
                              "  WHERE aag00 = '",g_ayf00,"'",
                              "  AND aag01 = '",g_ayf[l_ac].ayf04,"'",
                              "  AND aag09 = 'Y'"                      
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
                  CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql 
                       DECLARE aag_sel_c CURSOR FROM l_sql
                  OPEN aag_sel_c 
                  FETCH aag_sel_c INTO l_aag04
                  CLOSE aag_sel_c 
                  IF cl_null(l_aag04) OR l_aag04 = '1' THEN  
                     LET g_ayf[l_ac].ayf07 = '1'
                     LET g_ayf[l_ac].ayf08 = '1'
                  ELSE
                     LET g_ayf[l_ac].ayf07 = '3'
                     LET g_ayf[l_ac].ayf08 = '3'
                  END IF
               END IF 
               IF l_axz04 = 'Y' THEN 
                   CALL i020_ayf04()      
                   LET g_sql = "SELECT aag02 ",
                                "  FROM ",cl_get_target_table(g_plant_gl,'aag_file'),
                                " WHERE aag01 = '",g_ayf[l_ac].ayf04,"'",
                                "   AND aag00 = '",g_ayf00,"'",
                                "   AND aag09 = 'Y'"          
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                   CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql
                   PREPARE i020_sel_aag1 FROM g_sql
                   DECLARE i020_cur_aag1 CURSOR FOR i020_sel_aag1
                   OPEN i020_cur_aag1
                   FETCH i020_cur_aag1 INTO g_ayf[l_ac].ayf05
                   DISPLAY BY NAME g_ayf[l_ac].ayf05
               ELSE                                                                 
		   LET l_sql = " SELECT axq051",
                               " FROM ",cl_get_target_table(g_plant_gl,'axq_file'),  
                               " WHERE axq04 = '",g_ayf01,"'",
                               " AND axq01 = '",g_ayf09,"'",
                               " AND axq041 = '",g_ayf00,"'",
                               " AND axq05 = '", g_ayf[l_ac].ayf04,"'"
                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql  
                   CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql
                   PREPARE axq_sel1 FROM l_sql
                   DECLARE axq_sel2 SCROLL CURSOR FOR axq_sel1
                   OPEN axq_sel2
                   FETCH FIRST  axq_sel2  INTO l_axe05
                   CLOSE axq_sel2          
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ayf[l_ac].ayf04,g_errno,0)
                  LET g_ayf[l_ac].ayf04=g_ayf_t.ayf04
                  NEXT FIELD ayf04
               END IF
               IF cl_null(g_ayf[l_ac].ayf05) THEN 
                  LET g_ayf[l_ac].ayf05 = l_ayf05
               END IF
             END IF       
         DISPLAY BY NAME g_ayf[l_ac].ayf07,g_ayf[l_ac].ayf08     
         CALL i020_set_entry_b(p_cmd) 
         CALL i020_set_no_entry_b(p_cmd)  

      AFTER FIELD ayf06
         IF NOT cl_null(g_ayf[l_ac].ayf06) THEN 
            CALL i020_ayf06(l_ac)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ayf[l_ac].ayf06,g_errno,0)
               CALL q_m_aag4(FALSE,FALSE,g_plant_axz03,g_ayf[1].ayf06,'23',g_aaz641)      
                    RETURNING g_ayf[l_ac].ayf06                       
               LET g_ayf[l_ac].ayf06=g_ayf_t.ayf06
               NEXT FIELD ayf06
            END IF
         END IF
     #--FUN-D20047 mark start-- 
     #AFTER FIELD ayf07
     #   LET l_cnt = 0
     #   IF NOT cl_null(g_ayf[l_ac].ayf07) THEN 
     #       SELECT COUNT(*) INTO l_cnt       
     #         FROM ayf_file
     #        WHERE ayf00 = g_ayf00
     #          AND ayf01 = g_ayf01
     #          AND ayf04 = g_ayf[l_ac].ayf04
     #          AND ayf09 = g_ayf09
     #          AND ayf07 != g_ayf[l_ac].ayf07 
     #       IF l_cnt > 0 THEN
     #           CALL cl_err(g_ayf[l_ac].ayf04,'agl1053',0)
     #           NEXT FIELD ayf07
     #       END IF
     #   END IF  
     #--FUN-D20047  mark end---

      AFTER FIELD ayf08
         LET l_cnt = 0
         IF NOT cl_null(g_ayf[l_ac].ayf08) THEN 
             SELECT COUNT(*) INTO l_cnt       
               FROM ayf_file
              WHERE ayf00 = g_ayf00
                AND ayf01 = g_ayf01
                AND ayf04 = g_ayf[l_ac].ayf04
                AND ayf09 = g_ayf09
                AND ayf08 != g_ayf[l_ac].ayf08
             IF l_cnt > 0 THEN
                 CALL cl_err(g_ayf[l_ac].ayf04,'agl1054',0)
                 NEXT FIELD ayf08
             END IF
         END IF  
      BEFORE DELETE                            #是否取消單身
         IF g_ayf_t.ayf04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 

            DELETE FROM ayf_file
             WHERE ayf01 = g_ayf01 AND ayf02 = g_ayf_t.ayf02
               AND ayf03 = g_ayf_t.ayf03 AND ayf04 = g_ayf_t.ayf04 
               AND ayf00 = g_ayf00 AND ayf09 = g_ayf09  #No.FUN-730070  #FUN-910001 add ayf09
               AND ayf10 = g_ayf10 AND ayf11 = g_ayf11  #FUN-D20047 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ayf_file",g_ayf01,g_ayf[l_ac].ayf04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               ROLLBACK WORK
               CANCEL DELETE
            END IF

            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ayf[l_ac].* = g_ayf_t.*
            CLOSE i020_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF

         #FUN-D20047 add begin---
         IF (cl_null(g_ayf[l_ac].ayf02) OR g_ayf[l_ac].ayf02=' ') 
            AND (NOT cl_null(g_ayf[l_ac].ayf03) AND g_ayf[l_ac].ayf03 <> ' ') THEN
            CALL cl_err('','agl1066',1)
            NEXT FIELD ayf03
         END IF
         IF (NOT cl_null(g_ayf[l_ac].ayf02) AND g_ayf[l_ac].ayf02 <> ' ')
            AND (cl_null(g_ayf[l_ac].ayf03) OR g_ayf[l_ac].ayf03 = ' ') THEN
            CALL cl_err('','agl1066',1)
            NEXT FIELD ayf02
         END IF
         #FUN-D20047 add end-----

         IF l_lock_sw = 'Y' THEN 
            CALL cl_err(g_ayf[l_ac].ayf04,-263,0)
            LET g_ayf[l_ac].* = g_ayf_t.*
         ELSE 
            UPDATE ayf_file SET ayf02 = g_ayf[l_ac].ayf02,
                                ayf03 = g_ayf[l_ac].ayf03,
                                ayf04 = g_ayf[l_ac].ayf04,
                                ayf05 = g_ayf[l_ac].ayf05,
                                ayf06 = g_ayf[l_ac].ayf06,
                                ayf07 = g_ayf[l_ac].ayf07,   #FUN-580063
                                ayf08 = g_ayf[l_ac].ayf08,   #FUN-580063
                                ayfmodu = g_user,
                                ayfdate = g_today
             WHERE ayf01 = g_ayf01 
               AND ayf00 = g_ayf00  #No.FUN-730070
               AND ayf09 = g_ayf09  #FUN-910001 add 
               AND ayf10 = g_ayf10  #FUN-D20047 add
               AND ayf11 = g_ayf11  #FUN-D20047 add
               AND ayf04 = g_ayf_t.ayf04
               AND ayf02 = g_ayf_t.ayf02
               AND ayf03 = g_ayf_t.ayf03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ayf_file",g_ayf01,g_ayf_t.ayf04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               LET g_ayf[l_ac].* = g_ayf_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()         # 新增

         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_ayf[l_ac].* = g_ayf_t.*
            END IF
            CLOSE i020_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  
         CLOSE i020_bcl
         COMMIT WORK
      
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(ayf02) AND l_ac > 1 THEN
            LET g_ayf[l_ac].* = g_ayf[l_ac-1].*
            NEXT FIELD ayf02
         END IF

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ayf02)
              #---CHI-D20029 MARK START--
              #CALL cl_init_qry_var()
              #LET g_qryparam.form ="q_gem"
              #LET g_qryparam.default1 = g_ayf[l_ac].ayf02
              #CALL cl_create_qry() RETURNING g_ayf[l_ac].ayf02
              #DISPLAY BY NAME g_ayf[l_ac].ayf02        
              #NEXT FIELD ayf02
              #---CHI-D20029 MARK END---
              #---CHI-D20029 start--
               SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01= g_ayf01
               CALL q_m_gem(FALSE,TRUE,g_ayf[l_ac].ayf02,l_axz03) 
               RETURNING g_ayf[l_ac].ayf02
               DISPLAY BY NAME g_ayf[l_ac].ayf02        
               NEXT FIELD ayf02
              #---CHI-D20029 end--
            WHEN INFIELD(ayf03)
              #---CHI-D20029 MARK START--
              #CALL cl_init_qry_var()
              #LET g_qryparam.form ="q_gem"
              #LET g_qryparam.default1 = g_ayf[l_ac].ayf03
              #CALL cl_create_qry() RETURNING g_ayf[l_ac].ayf03
              #DISPLAY BY NAME g_ayf[l_ac].ayf03       
              #NEXT FIELD ayf03
              #---CHI-D20029 MARK END--
              #---CHI-D20029 start--
               SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01= g_ayf01
               CALL q_m_gem(FALSE,TRUE,g_ayf[l_ac].ayf03,l_axz03) 
               RETURNING g_ayf[l_ac].ayf03
               DISPLAY BY NAME g_ayf[l_ac].ayf03       
               NEXT FIELD ayf03
              #---CHI-D20029 end--
            WHEN INFIELD(ayf04)  
                SELECT axz04 INTO l_axz04  FROM axz_file WHERE axz01 = g_ayf01
                IF l_axz04 = 'N' THEN 
                    CALL q_m_aag3(FALSE,TRUE,g_plant_gl,g_ayf[l_ac].ayf04,g_ayf[l_ac].ayf05,g_ayf01,g_ayf09,g_ayf00)
                       RETURNING g_ayf[l_ac].ayf04,g_ayf[l_ac].ayf05
                ELSE    
                    CALL q_m_aag4(FALSE,TRUE,g_plant_gl,g_ayf[l_ac].ayf04,'23',g_ayf00)  #FUN-B60082 mod  #No.MOD-480092  #No.FUN-730070
                    RETURNING g_ayf[l_ac].ayf04
                END IF
                DISPLAY BY NAME g_ayf[l_ac].ayf04      
                NEXT FIELD ayf04
            WHEN INFIELD(ayf06) 
               CALL q_m_aag4(FALSE,TRUE,g_plant_axz03,g_ayf[1].ayf06,'23',g_aaz641)      #FUN-B60082 mod                           
               RETURNING g_ayf[l_ac].ayf06                                                                                     
               DISPLAY g_qryparam.multiret TO ayf06                                                                                 
               NEXT FIELD ayf06                                                                                                     
            OTHERWISE EXIT CASE
         END CASE

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
       ON ACTION controls                                        
          CALL cl_set_head_visible("","AUTO")                    

   END INPUT

   CLOSE i020_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i020_ayf06(l_cnt)
DEFINE
    l_cnt           LIKE type_file.num5,          #No.FUN-680098 smallint
    l_aag02         LIKE aag_file.aag02,
    l_aag03         LIKE aag_file.aag03,
    l_aag07         LIKE aag_file.aag07,
    l_aagacti       LIKE aag_file.aagacti
DEFINE l_axa09      LIKE axa_file.axa09   #FUN-950051

    LET g_errno = ' '

   LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",                                                                                 
               "  FROM ",cl_get_target_table(g_plant_axz03,'aag_file'), 
               " WHERE aag01 = '",g_ayf[l_cnt].ayf06,"'",                                                                           
               "  AND aag00 = '",g_aaz641,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql      
   CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql   
   PREPARE i020_pre_05 FROM g_sql                                                                                                   
   DECLARE i020_cur_05 CURSOR FOR i020_pre_05                                                                                       
   OPEN i020_cur_05                                                                                                                 
   FETCH i020_cur_05 INTO l_aag02,l_aag03,l_aag07,l_aagacti                                                                         

    CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001' 
        #WHEN l_aagacti = 'N'     LET g_errno = '9028'       #MOD-BB0131 mark 
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015' 
         #WHEN l_aag03 != '2'     LET g_errno = 'agl-201'    #MOD-760085
         OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE 

    IF SQLCA.sqlcode = 0 THEN
       LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",                                                                                 
                   "  FROM ",cl_get_target_table(g_plant_axz03,'aag_file'), 
                   " WHERE aag01 = '",g_ayf[l_cnt].ayf06,"'",                                                                           
                   "  AND aag00 = '",g_aaz641,"'",
                   "  AND aag09 = 'Y'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
       PREPARE i020_pre_06 FROM g_sql                                                                                                   
       DECLARE i020_cur_06 CURSOR FOR i020_pre_06 
       OPEN i020_cur_06
       FETCH i020_cur_06 INTO l_aag02,l_aag03,l_aag07,l_aagacti                                                                         

       CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-214'
           #WHEN l_aagacti = 'N'     LET g_errno = '9028'             #MOD-BB0131 mark
            WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
            OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
       END CASE 
    END IF

    IF cl_null(g_errno) THEN
       LET g_ayf[l_cnt].aag02 = l_aag02
    END IF
    
END FUNCTION
   
FUNCTION i020_ayf04()
DEFINE
    l_cnt           LIKE type_file.num5,
    l_aag02         LIKE aag_file.aag02,
    l_aag03         LIKE aag_file.aag03,
    l_aag07         LIKE aag_file.aag07,
    l_aagacti       LIKE aag_file.aagacti

    LET g_errno = ' '  
    LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                "  FROM ",g_dbs_gl,"aag_file",
                " WHERE aag01 = '",g_ayf[l_ac].ayf04,"'",  
                "   AND aag00 = '",g_ayf00,"'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     PREPARE i020_sel_aag FROM g_sql
     DECLARE i020_cur_aag CURSOR FOR i020_sel_aag
     OPEN i020_cur_aag
     FETCH i020_cur_aag INTO l_aag02,l_aag03,l_aag07,l_aagacti

     CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
          WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
          OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
     END CASE

     IF SQLCA.sqlcode = 0 THEN
     LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                "  FROM ",g_dbs_gl,"aag_file",
                " WHERE aag01 = '",g_ayf[l_ac].ayf04,"'",
                "   AND aag00 = '",g_ayf00,"'",
                "   AND aag09 = 'Y'" 
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     PREPARE i020_sel_cs7 FROM g_sql
     DECLARE i020_cur_cs7 CURSOR FOR i020_sel_cs7
     OPEN i020_cur_cs7
     FETCH i020_cur_cs7 INTO l_aag02,l_aag03,l_aag07,l_aagacti

     CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-214'
         #WHEN l_aagacti = 'N'     LET g_errno = '9028'   
          WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
          OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
     END CASE
    END IF

    IF cl_null(g_errno) THEN
       LET g_ayf[l_ac].ayf05 = l_aag02 
    END IF
END FUNCTION

FUNCTION i020_b_askkey()
DEFINE
    l_wc   LIKE type_file.chr1000  

   CLEAR FORM
   CALL g_ayf.clear()
   CALL g_ayf.clear()

   CONSTRUCT l_wc ON ayf04,ayf05,ayf06,ayf07,ayf08  #螢幕上取條件
        FROM s_ayf[1].ayf04,s_ayf[1].ayf05,s_ayf[1].ayf06,s_ayf[1].ayf07,s_ayf[1].ayf08

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
   
   IF INT_FLAG THEN
      RETURN 
   END IF

   CALL i020_b_fill(l_wc)
   
END FUNCTION

FUNCTION i020_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc      LIKE type_file.chr1000 #No.FUN-680098  VARCHAR(200)

   LET g_sql = "SELECT ayf02,'',ayf03,'',ayf04,ayf05,ayf06,'',ayf07,ayf08 ", 
               " FROM ayf_file ",
               " WHERE ayf01 = '",g_ayf01,"' AND ", p_wc CLIPPED ,
               "   AND ayf00 = '",g_ayf00,"'",
               "   AND ayf09 = '",g_ayf09,"'", 
               "   AND ayf10 = '",g_ayf10,"'",    #FUN-D20047 add
               "   AND ayf11 = '",g_ayf11,"'",    #FUN-D20047 add 
               " ORDER BY 1,2 "
   PREPARE i020_prepare2 FROM g_sql      #預備一下
   DECLARE ayf_cs CURSOR FOR i020_prepare2

   CALL g_ayf.clear()

   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH ayf_cs INTO g_ayf[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i020_gem(g_ayf[g_cnt].ayf02) RETURNING g_ayf[g_cnt].gem02
      CALL i020_gem(g_ayf[g_cnt].ayf03) RETURNING g_ayf[g_cnt].gem02_1
      CALL i020_ayf06(g_cnt)
      LET g_errno = ' '                #MOD-A60033 
      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_ayf.deleteElement(g_cnt)
   LET g_rec_b=g_cnt -1

   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0

END FUNCTION

FUNCTION i020_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ayf TO s_ayf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first 
         CALL i020_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
                              

      ON ACTION previous
         CALL i020_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
                              

      ON ACTION jump
         CALL i020_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
                              

      ON ACTION next
         CALL i020_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
                              

      ON ACTION last
         CALL i020_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
                              

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
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

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION batch_generate
         LET g_action_choice="batch_generate"
         EXIT DISPLAY

      ON ACTION related_document  #No:MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel   #No:FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
     ##FUN-B90061--begin--
      ON ACTION dataload
         LET g_action_choice = 'dataload'
         EXIT DISPLAY
     #FUN-D20044--
      ON ACTION excelexample 
         LET g_action_choice = 'excelexample'
         EXIT DISPLAY
     #FUN-D20044--

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
   
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 

FUNCTION i020_copy()
DEFINE l_ayf          RECORD LIKE ayf_file.*,
       l_sql          LIKE type_file.chr1000,  
       l_oldno0       LIKE ayf_file.ayf00,    
       l_newno0       LIKE ayf_file.ayf00,   
       l_oldno1       LIKE ayf_file.ayf01,
       l_newno1       LIKE ayf_file.ayf01,
       l_oldno2       LIKE ayf_file.ayf09,    
       l_newno2       LIKE ayf_file.ayf09,   
       l_oldno3       LIKE ayf_file.ayf10,    #FUN-D20047 add
       l_newno3       LIKE ayf_file.ayf10,    #FUN-D20047 add
       l_oldno4       LIKE ayf_file.ayf11,    #FUN-D20047 add
       l_newno4       LIKE ayf_file.ayf11,    #FUN-D20047 add   
       l_n,l_n1       LIKE type_file.num5   
DEFINE l_ayf01_cnt    LIKE type_file.num5  
DEFINE l_axz04        LIKE axz_file.axz04

   IF s_aglshut(0) THEN RETURN END IF

   IF cl_null(g_ayf09) OR cl_null(g_ayf01) OR cl_null(g_ayf00) THEN  #No.FUN-730070  #FUN-910001 
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_before_input_done = FALSE
   CALL i020_set_entry('a') 
   CALL i020_set_no_entry('a')      #FUN-D20047 
   LET g_before_input_done = TRUE
   CALL cl_set_head_visible("","YES")   

     INPUT l_newno2,l_newno1,l_newno3,l_newno4 FROM ayf09,ayf01,ayf10,ayf11     #FUN-D20047 add ayf10,ayf11  

      AFTER FIELD ayf09   #族群代號                                                                                                 
         IF cl_null(l_newno2) THEN                                                                                           
            CALL cl_err(g_ayf09,'mfg0037',0)                                                                                
            NEXT FIELD ayf09                                                                                                
         ELSE                                                                                                               
            LET l_n = 0                                                                                                     
            SELECT COUNT(*) INTO l_n FROM axa_file                                                                          
             WHERE axa01=l_newno2
            IF cl_null(l_n) THEN LET l_n = 0 END IF                                                                         
            IF l_n = 0 THEN                                                                                                 
               CALL cl_err(g_ayf09,'agl-223',0)                                                                             
               NEXT FIELD ayf09                                                                                             
            END IF                                                                                                          
        END IF                                                                                                             

      AFTER FIELD ayf01
         IF l_newno1 IS NULL THEN 
            NEXT FIELD ayf01
         END IF
         SELECT COUNT(*)                                                                                                            
           INTO l_ayf01_cnt                                                                                                         
           FROM axz_file                                                                                                            
          WHERE axz01 = l_newno1                                                                                                    
         IF l_ayf01_cnt = 0 THEN                                                                                                 
            LET g_errno = 'aco-025'  
         END IF                                                                                                                     
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(l_newno1,g_errno,0)
            NEXT FIELD ayf01
         ELSE                                                                                                                       
            SELECT axz05 INTO l_newno0                                                                                              
              FROM axz_file                                                                                                         
             WHERE axz01 = l_newno1                                                                                                 
            DISPLAY l_newno0 TO ayf00                                                                                               
         END IF

         IF l_newno2 IS NOT NULL AND l_newno1 IS NOT NULL AND                                                                       
            l_newno0 IS NOT NULL THEN                                                                                               
            LET l_n = 0   LET l_n1 = 0                                                                                              
            SELECT COUNT(*) INTO l_n FROM axa_file                                                                                  
             WHERE axa01=l_newno2 AND axa02=l_newno1                                                                                
               AND axa03=l_newno0                                                                                                   
            SELECT COUNT(*) INTO l_n1 FROM axb_file                                                                                 
             WHERE axb01=l_newno2 AND axb04=l_newno1                                                                                
               AND axb05=l_newno0                                                                                                   
            IF l_n+l_n1 = 0 THEN                                                                                                    
               CALL cl_err(l_newno1,'agl-223',0)                                                                                    
               NEXT FIELD ayf01                                                                                                     
            END IF                                                                                                                  
         END IF                                                                                                                     

      #FUN-D20047 add begin---
      AFTER FIELD ayf10
         IF l_newno3 IS NULL THEN
            NEXT FIELD ayf10
         END IF

      AFTER FIELD ayf11
         IF l_newno4 IS NULL THEN
            NEXT FIELD ayf11
         END IF
      #FUN-D20047 add end-----                                                                                      

      ON ACTION CONTROLP
         CASE
           #str FUN-910001 add                                                                                                      
            WHEN INFIELD(ayf09) #族群編號                                                                                           
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_axa1"                                                                                        
               LET g_qryparam.default1 = l_newno2                                                                                   
               CALL cl_create_qry() RETURNING l_newno2                                                                              
               DISPLAY l_newno2 TO ayf09                                                                                            
               NEXT FIELD ayf09                                                                                                     
            WHEN INFIELD(ayf01)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz" 
               LET g_qryparam.default1 = l_newno1
               CALL cl_create_qry() RETURNING l_newno1
               DISPLAY l_newno1 TO ayf01 
               NEXT FIELD ayf01
            WHEN INFIELD(ayf00)  
               SELECT azp03 INTO g_azp03 FROM axz_file,azp_file
                WHERE axz01=l_newno1 AND axz03=azp01
               SELECT azp01 INTO g_azp01 FROM axz_file,azp_file   
                WHERE axz01=l_newno1 AND axz03=azp01           
               IF cl_null(g_azp03) THEN LET g_azp03 = g_dbs END IF
               IF cl_null(g_azp01) THEN LET g_azp01 = g_plant END IF
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa4"   #TQC-760205 q_aaa->q_aaa4
               LET g_qryparam.default1 = l_newno0
               LET g_qryparam.plant = g_azp01 
               CALL cl_create_qry() RETURNING l_newno0
               DISPLAY l_newno0 TO ayf00 
               NEXT FIELD ayf00
            OTHERWISE EXIT CASE
         END CASE


     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
  
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
  
      ON ACTION controlg      #MOD-4C0121
        CALL cl_cmdask()     #MOD-4C0121
   
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_ayf01 TO ayf01 
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM ayf_file         #單身複製
    WHERE ayf01=g_ayf01 
      AND ayf00=g_ayf00  #No.FUN-730070
      AND ayf09=g_ayf09  #FUN-910001 add
      AND ayf10=g_ayf10  #FUN-D20047 add
      AND ayf11=g_ayf11  #FUN-D20047 add
     INTO TEMP x
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ayf_file",g_ayf01,g_ayf00,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730070
      RETURN
   END IF

   UPDATE x SET ayf01=l_newno1,ayf00=l_newno0,ayf09=l_newno2,ayf10=l_newno3,ayf11=l_newno4  #No.FUN-730070  #FUN-910001 add ayf09    #FUN-D20047 add ayf10,ayf11

   INSERT INTO ayf_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ayf_file",l_newno1,l_newno0,SQLCA.sqlcode,"","ayf:",1)  #No.FUN-660123  #No.FUN-730070
      RETURN
   END IF

   LET g_cnt=SQLCA.SQLERRD[3]

   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
   
   LET l_oldno2 = g_ayf09   #FUN-910001 add    
   LET l_oldno1 = g_ayf01 
   LET l_oldno0 = g_ayf00   #No.FUN-730070
   LET l_oldno3 = g_ayf10   #FUN-D20047 add
   LET l_oldno4 = g_ayf11   #FUN-D20047 add
   LET g_ayf09=l_newno2     #FUN-910001 add
   LET g_ayf01=l_newno1
   LET g_ayf00=l_newno0     #No.FUN-730070
   LET g_ayf10=l_newno3     #FUN-D20047 add
   LET g_ayf11=l_newno4     #FUN-D20047 add

   CALL i020_b()
   
   LET g_ayf09=l_oldno2     #FUN-910001 add 
   LET g_ayf01=l_oldno1
   LET g_ayf00=l_oldno0     #No.FUN-730070

   CALL i020_show()

END FUNCTION

FUNCTION i020_out()
   DEFINE l_i             LIKE type_file.num5,          #No.FUN-680098  smallint
          l_name          LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-680098 VARCHAR(20)
          l_chr           LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)  
          sr RECORD
               ayf09     LIKE ayf_file.ayf09,     #族群代號  #FUN-910001 add  
               ayf10     LIKE ayf_file.ayf10,     #year      #FUN-D20047 add  
               ayf01     LIKE ayf_file.ayf01,     #營運中心
               ayf11     LIKE ayf_file.ayf11,     #period    #FUN-D20047 add
               ayf00     LIKE ayf_file.ayf00,     #帳套  #No.FUN-730070
               ayf04     LIKE ayf_file.ayf04,     #科目編號
               ayf05     LIKE ayf_file.ayf05,     #科目名稱
               ayf06     LIKE ayf_file.ayf06,     #合併財報科目編號
               aag02     LIKE aag_file.aag02,     #合併財報科目名稱
               ayf07     LIKE ayf_file.ayf07,     #再衡量匯率類別
               ayf08     LIKE ayf_file.ayf08      #換算匯率類別
             END RECORD

   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

   LET g_sql="SELECT ayf09,ayf10,ayf01,ayf11,ayf00,ayf04,ayf05,ayf06,aag02,ayf07,ayf08 ",    #FUN-D20047 add ayf10,ayf11
             " FROM ayf_file,OUTER aag_file ",
             " WHERE ",g_wc CLIPPED ,
             "   AND ayf06 = aag01",  
             "   AND aag00 = '",g_aaz.aaz641,"'",   
             " ORDER BY ayf09,ayf01,ayf00,ayf04 "  

   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(g_wc,'ayf09,ayf10,ayf01,ayf11,ayf00,ayf04,ayf05,ayf06,ayf07,ayf08')      #FUN-D20047 add ayf10,ayf11
      RETURNING g_wc                                                          
      LET g_str = g_str CLIPPED,";", g_wc                                     
   END IF                                                                      
   LET g_str =  g_wc    
   CALL cl_prt_cs1('agli020','agli020',g_sql,g_str)
END FUNCTION

FUNCTION i020_g()
   DEFINE l_sql    LIKE type_file.chr1000,   #No.FUN-680098 VARCHAR(200)
          l_ayf06  LIKE ayf_file.ayf06,
          l_aag01  LIKE aag_file.aag01,
          l_type   STRING,                   #FUN-960062
          l_aag02  LIKE aag_file.aag02,
          l_flag   LIKE type_file.chr1,      #TQC-590045        #No.FUN-680098 VARCHAR(1)
          l_axz03  LIKE axz_file.axz03,      #TQC-660043
          l_axz04  LIKE axz_file.axz04,    
          l_n      LIKE type_file.num5,   
          l_n1     LIKE type_file.num5    
DEFINE l_axb02      LIKE axb_file.axb02   
DEFINE l_axa09      LIKE axa_file.axa09  
DEFINE l_ayf07     LIKE ayf_file.ayf07    
DEFINE l_ayf08     LIKE ayf_file.ayf08   
DEFINE l_aag04     LIKE aag_file.aag04   
DEFINE l_qbe_aag01  LIKE aag_file.aag01  
DEFINE l_ayf        DYNAMIC ARRAY OF RECORD  
       ayf02        LIKE ayf_file.ayf02,
       ayf03        LIKE ayf_file.ayf03,
       ayf04        LIKE ayf_file.ayf04,                 
       ayf05        LIKE ayf_file.ayf05,                 
       ayf06        LIKE ayf_file.ayf06,                  
       aag02        LIKE aag_file.aag02,
       ayf07        LIKE ayf_file.ayf07, 
       ayf08        LIKE ayf_file.ayf08 
                    END RECORD
DEFINE l_axb02_axz04  LIKE axz_file.axz04

   OPEN WINDOW i020_w3 AT 6,11
     WITH FORM "agl/42f/agli020_g"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN

   CALL cl_ui_locale("agli020_g")

   CALL cl_getmsg('agl-021',g_lang) RETURNING g_msg
   MESSAGE g_msg 

   LET g_success='Y' 

   WHILE TRUE 
      CONSTRUCT g_wc ON aag01 FROM aag01

         AFTER FIELD aag01
            CALL GET_FLDBUF(aag01) RETURNING l_qbe_aag01

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
    
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW i020_w3 
         RETURN 
      END IF
    
      LET tm.y='Y'
      DISPLAY tm.y TO FORMONLY.y 
    
      INPUT tm.axe13,tm.axe01,tm.y WITHOUT DEFAULTS  
       FROM FORMONLY.axe13,FORMONLY.axe01,FORMONLY.y  
 
         AFTER FIELD axe01
            IF NOT cl_null(tm.axe01) THEN 
               SELECT axz04 INTO l_axz04 FROM axz_file
                WHERE axz01 = tm.axe01
               CALL i020_ayf01('a',tm.axe01) RETURNING g_ayf00_def
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.axe01,g_errno,0)
                  NEXT FIELD axe01
               ELSE                                                                                                                 
                  DISPLAY g_ayf00_def TO axe00
               END IF                                                                                                               
            END IF

         AFTER FIELD y
            IF NOT cl_null(tm.y) THEN 
               IF tm.y NOT MATCHES '[YN]' THEN
                  NEXT FIELD y
               END IF 
            END IF
    
         ON ACTION CONTROLZ
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG
            CALL cl_cmdask()
    
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axe13) #族群編號                                                                                        
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form ="q_axa1"                                                                                     
                  LET g_qryparam.default1 = tm.axe13                                                                                
                  CALL cl_create_qry() RETURNING tm.axe13                                                                           
                  DISPLAY tm.axe13 TO axe13                                                                                         
                  NEXT FIELD axe13                                                                                                  
               WHEN INFIELD(axe01)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axz"      #FUN-580063
                  LET g_qryparam.default1 = tm.axe01
                  CALL cl_create_qry() RETURNING tm.axe01
                  DISPLAY tm.axe01 TO axe01 
                  NEXT FIELD axe01
               WHEN INFIELD(axe00)  
                  SELECT azp03 INTO g_azp03 FROM axz_file,azp_file
                   WHERE axz01=tm.axe01 AND axz03=azp01
                  SELECT azp01 INTO g_azp01 FROM axz_file,azp_file   
                   WHERE axz01=tm.axe01 AND axz03=azp01   
                  IF cl_null(g_azp03) THEN LET g_azp03 = g_dbs END IF
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa4"  
                  LET g_qryparam.default1 = tm.axe00
                  LET g_qryparam.plant = g_azp01
                  IF cl_null(g_azp01) THEN LET g_azp01 = g_plant END IF
                  CALL cl_create_qry() RETURNING tm.axe00
                  DISPLAY tm.axe00 TO axe00 
                  NEXT FIELD axe00
               OTHERWISE EXIT CASE
            END CASE
    
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
    
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
        
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
    
      END INPUT
    
      IF INT_FLAG THEN 
         LET INT_FLAG=0
         CLOSE WINDOW i020_w3
         RETURN
      END IF
    
      IF cl_sure(0,0) THEN 
         BEGIN WORK   
         CALL i020_getdbs(tm.axe01,tm.axe13)  
         IF g_axz04 = 'Y' THEN   
             LET l_sql ="SELECT aag01,aag02,aag04 ",
                        "  FROM ",cl_get_target_table(g_plant_gl,'aag_file'),
                        " WHERE aag07 IN ('2','3')",
                        "  AND ",g_wc CLIPPED,
                        "  AND aag00 = '",g_ayf00_def,"'",
                        "  AND aag09 = 'Y'",              
                        " ORDER BY 1 "
         ELSE
             LET l_sql ="SELECT UNIQUE axq05,axq051,'' ",
                        "  FROM ",cl_get_target_table(g_plant_gl,'axq_file'),   
                        "  WHERE axq04 = '",tm.axe01,"'",     #下層公司
                        "   AND axq01 = '",tm.axe13,"'",      #群組
                        "   AND axq041 = '",g_ayf00_def,"'"   #下層公司帳別
         END IF
	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql   
         CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql  
         PREPARE i020_g_pre  FROM l_sql
         DECLARE i020_g CURSOR FOR i020_g_pre 
         LET i = 1   
         FOREACH i020_g INTO l_aag01,l_aag02,l_aag04  
            IF SQLCA.sqlcode THEN 
               CALL cl_err('i020_g',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
            LET l_ayf06 = NULL 
            IF tm.y = 'Y' THEN
               LET l_ayf06 = l_aag01 
            ELSE 
               LET l_ayf06 = ' '
            END IF
            LET l_aag04 = ''
            LET l_sql = " SELECT aag04 FROM ",cl_get_target_table(g_plant_gl,'aag_file'),
                        "  WHERE aag00 = '",g_ayf00,"'",
                        "    AND aag01 = '",l_aag01,"'"            
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
            CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql  
            PREPARE aag_sel_c1 FROM l_sql
            EXECUTE aag_sel_c1 INTO l_aag04
            IF cl_null(l_aag04) OR l_aag04 = '1' THEN   
               LET l_ayf07 = '1'
               LET l_ayf08 = '1'
            ELSE
               LET l_ayf07 = '3'
               LET l_ayf08 = '3'
            END IF

            #FUN-D20047 add begin---
            LET l_ayf[i].ayf02 = ' '
            LET l_ayf[i].ayf03 = ' '
            #FUN-D20047 add end-----
            LET l_ayf[i].ayf04 = l_aag01
            LET l_ayf[i].ayf05 = l_aag02
            IF tm.y = 'Y' THEN 
                LET l_ayf[i].ayf06 = l_ayf06
            ELSE
                LET l_ayf[i].ayf06 = ' '
            END IF
                
            LET l_ayf[i].aag02 = ''
            LET l_ayf[i].ayf07 = l_ayf07
            LET l_ayf[i].ayf08 = l_ayf08
            LET i = i + 1 
         END FOREACH

         FOR i = 1 TO l_ayf.getLength()
           INSERT INTO ayf_file (ayf00,ayf01,ayf02,ayf03,ayf04,ayf05,ayf06,ayf07,ayf08, 
                                 ayfacti,ayfuser,ayfgrup,ayfmodu,ayfdate,ayf09,ayforiu,ayforig,ayf10,ayf11)     #FUN-D20047 add ayf10,ayf11
                         VALUES (g_ayf00_def,tm.axe01,' ',' ',l_ayf[i].ayf04,
                                 l_ayf[i].ayf05,l_ayf[i].ayf06,
                                 l_ayf[i].ayf07,l_ayf[i].ayf08,
                                  'Y',g_user,g_grup,' ',g_today,tm.axe13, g_user, g_grup,g_auf10,g_ayf11)       #FUN-D20047 add ayf10,ayf11  
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
               CONTINUE FOR   
            ELSE
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","ayf_file",tm.axe01,l_aag01,STATUS,"","ins ayf",1)  
                  LET g_success='N' 
                  EXIT FOR   
               END IF
            END IF  
         END FOR   
      END IF
    
      IF g_success='Y' THEN
         COMMIT WORK    
         CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
      ELSE
         ROLLBACK WORK  
         CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
      END IF
      IF l_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
   END WHILE

   CLOSE WINDOW i020_w3

END FUNCTION

FUNCTION i020_getdbs(p_ayf01,p_ayf09)
DEFINE  p_ayf01  LIKE ayf_file.ayf01
DEFINE  p_ayf09  LIKE ayf_file.ayf09
DEFINE  l_cnt    LIKE type_file.num5
DEFINE  l_axa02  LIKE axa_file.axa02
DEFINE  l_axa02_cnt  LIKE type_file.num5

   SELECT axz03,axz04,axz05 INTO g_axz03,g_axz04,g_axz05 FROM axz_file 
     WHERE axz01 = p_ayf01
   IF g_axz04 = 'N' THEN LET g_axz03=g_plant    
       SELECT azp03 INTO g_dbs_new FROM azp_file
        WHERE azp01 = g_axz03
       IF STATUS THEN
          LET g_dbs_new = NULL
       END IF
       LET g_plant_gl = g_axz03    #No.FUN-980025 add
       LET g_dbs_gl = s_dbstring(g_dbs_new CLIPPED) 
   ELSE
       SELECT azp03 INTO g_dbs_new FROM azp_file
        WHERE azp01 = g_axz03
       IF STATUS THEN
          LET g_dbs_new = NULL
       END IF
       LET g_plant_gl = g_axz03 
       LET g_dbs_gl = s_dbstring(g_dbs_new CLIPPED) 
   END IF

END FUNCTION

FUNCTION i020_dataload()    #資料匯入

   OPEN WINDOW i020_l_w AT p_row,p_col
     WITH FORM "agl/42f/agli020_l" ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("agli020_l")

   CLEAR FORM
   ERROR ''
   LET g_disk = "Y" 
   LET g_choice = '1'
    
   INPUT g_file WITHOUT DEFAULTS FROM FORMONLY.file
        
      ON ACTION locale
         LET g_action_choice = "locale"
         CALL cl_show_fld_cont()
         EXIT INPUT
   
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()     # Command execution
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

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
      LET INT_FLAG = 0
      CLOSE WINDOW i020_l_w
      RETURN
   END IF
  
   WHILE TRUE
   IF cl_sure(0,0) THEN
      LET g_success='Y'
      BEGIN WORK 
    
      CALL i020_excel_bring(g_file)      

      DROP TABLE i020_tmp
      CALL s_showmsg() 
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF

      CLOSE WINDOW i020_l_w
   END IF
   EXIT WHILE  
   END WHILE  
   CLOSE WINDOW i020_l_w    
END FUNCTION

FUNCTION i020_ins_ayf()
   SELECT * FROM ayf_file
    WHERE ayf00=g_ayfl.ayf00 AND ayf01=g_ayfl.ayf01 AND ayf02=g_ayfl.ayf02
      AND ayf03=g_ayfl.ayf03 AND ayf04=g_ayfl.ayf04
      AND ayf05=g_ayfl.ayf05 AND ayf06=g_ayfl.ayf06 AND ayf07=g_ayfl.ayf07
      AND ayf08=g_ayfl.ayf08 AND ayf09=g_ayfl.ayf09
      AND ayf10=g_ayfl.ayf10 AND ayf11=g_ayfl.ayf11    #FUN-D20047 add
   IF STATUS THEN
      LET g_ayfl.ayfacti='Y'
      LET g_ayfl.ayfuser=g_user
      LET g_ayfl.ayfgrup=g_grup
      LET g_ayfl.ayfdate=g_today
      LET g_ayfl.ayforiu=g_user
      LET g_ayfl.ayforig=g_grup

      INSERT INTO ayf_file VALUES (g_ayfl.*)
      IF STATUS THEN
         LET g_showmsg=g_ayfl.ayf00,"/",g_ayfl.ayf01,"/",g_ayfl.ayf02,"/",
                       g_ayfl.ayf03,"/",g_ayfl.ayf04,"/",g_ayfl.ayf05,"/",
                       g_ayfl.ayf06,"/",g_ayfl.ayf07,"/",g_ayfl.ayf08,"/",g_ayfl.ayf09
                      ,"/",g_ayfl.ayf10,"/",g_ayfl.ayf11                                              #FUN-D20047 add
         CALL s_errmsg('ayf00,ayf01,ayf02,ayf03,ayf04,ayf05,ayf06,ayf07,ayf08,ayf09,ayf10,ayf11'      #FUN-D20047 add ayf10,ayf11
                       ,g_showmsg,'ins ayf_file',STATUS,1)
      END IF
   END IF
END FUNCTION

FUNCTION i020_excel_bring(p_fname)
   DEFINE p_fname     STRING  
   DEFINE channel_r   base.Channel
   DEFINE l_string    LIKE type_file.chr1000
   DEFINE unix_path   LIKE type_file.chr1000
   DEFINE window_path LIKE type_file.chr1000
   DEFINE l_cmd       LIKE type_file.chr1000 
   DEFINE li_result   LIKE type_file.chr1 
   DEFINE l_column    DYNAMIC ARRAY of RECORD 
            col1      LIKE gaq_file.gaq01,
            col2      LIKE gaq_file.gaq03
                      END RECORD
   DEFINE l_cnt3      LIKE type_file.num5
   DEFINE li_i        LIKE type_file.num5
   DEFINE li_n        LIKE type_file.num5
   DEFINE ls_cell     STRING
   DEFINE ls_cell_r   STRING
   DEFINE li_i_r      LIKE type_file.num5
   DEFINE ls_cell_c   STRING
   DEFINE ls_value    STRING
   DEFINE ls_value_o  STRING
   DEFINE li_flag     LIKE type_file.chr1 
   DEFINE lr_data_tmp   DYNAMIC ARRAY OF RECORD
             data01     STRING
                    END RECORD
   DEFINE l_fname     STRING   
   DEFINE l_column_name LIKE zta_file.zta01
   DEFINE l_data_type LIKE ztb_file.ztb04
   DEFINE l_nullable  LIKE ztb_file.ztb05
   DEFINE l_flag_1    LIKE type_file.chr1  
   DEFINE l_date      LIKE type_file.dat
   DEFINE li_k        LIKE type_file.num5
   DEFINE l_err_cnt   LIKE type_file.num5
   DEFINE l_no_b      LIKE pmw_file.pmw01   
   DEFINE l_no_e      LIKE pmw_file.pmw01
   DEFINE l_old_no    LIKE type_file.chr50  
   DEFINE l_old_no_b  LIKE type_file.chr50  
   DEFINE l_old_no_e  LIKE type_file.chr50
   DEFINE lr_err      DYNAMIC ARRAY OF RECORD
               line        STRING,
               key1        STRING,
               err         STRING
                      END RECORD
   DEFINE  m_tempdir  LIKE type_file.chr1000,    
           ss1        LIKE type_file.chr1000,
           m_sf       LIKE type_file.chr1000,
           m_file     LIKE type_file.chr1000,
           l_j        LIKE type_file.num5,
           l_n        LIKE type_file.num5
   DEFINE  g_target   LIKE type_file.chr1000
   DEFINE  tok        base.StringTokenizer
   DEFINE  ss         STRING 
   DEFINE  l_str      DYNAMIC ARRAY OF STRING  
   DEFINE  ms_codeset String  
   DEFINE  l_txt1     LIKE type_file.chr1000
   DEFINE  l_axz04    LIKE axz_file.axz04
   DEFINE  l_sql      LIKE type_file.chr1000
   DEFINE
           l_cnt      LIKE type_file.num5,
           l_aag02    LIKE aag_file.aag02,
           l_aag03    LIKE aag_file.aag03,
           l_aag07    LIKE aag_file.aag07,
           l_aag09    LIKE aag_file.aag09,
           l_aagacti  LIKE aag_file.aagacti

   LET m_tempdir = FGL_GETENV("TEMPDIR")
   LET l_n = LENGTH(m_tempdir)
   
   LET ms_codeset = cl_get_codeset()
   
   IF l_n>0 THEN
      IF m_tempdir[l_n,l_n]='/' THEN
         LET m_tempdir[l_n,l_n]=' '
      END IF
   END IF

   IF m_tempdir is null THEN
      LET m_file=p_fname
   ELSE
      LET m_file=m_tempdir CLIPPED,'/',p_fname,".txt"
   END IF

   IF g_disk= "Y" THEN
      LET m_sf = "c:/tiptop/"
      LET m_sf = m_sf CLIPPED,p_fname CLIPPED,".txt"
      IF NOT cl_upload_file(m_sf, m_file) THEN
         CALL cl_err(NULL, "lib-212", 1)
      END IF
   END IF

   LET ss1="test -s ",m_file CLIPPED
   RUN ss RETURNING l_n

   IF l_n THEN
      IF m_tempdir IS NULL THEN
         LET m_tempdir='.'
      END IF

      DISPLAY "* NOTICE * No such excel file '",m_file CLIPPED,"'"
      DISPLAY "PLEASE make sure that the excel file download from LEADER"
      DISPLAY "has been put in the directory:"
      DISPLAY '--> ',m_tempdir
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
    
   LET channel_r = base.Channel.create()                                                                                         
   LET g_target  = FGL_GETENV("TEMPDIR"),"\/", p_fname,"_",g_dbs CLIPPED,".TXT"  
   
         
   IF m_sf IS NOT NULL THEN 
      IF NOT cl_upload_file(m_sf,g_target) THEN
         CALL cl_err("Can't upload file: ", m_sf, 0)
         RETURN 
      END IF
   END IF  
   
   LET l_txt1 = FGL_GETENV("TEMPDIR"),"\/",p_fname,"_",g_dbs CLIPPED,".txt"
   
   CASE ms_codeset
      WHEN "UTF-8"
         LET l_cmd = "cp ",g_target," ",l_txt1
         RUN l_cmd
         LET l_cmd = "ule2utf8 ",l_txt1
         RUN l_cmd
         #CHI-B50010 -- end --
         LET l_cmd = "cp -f " || l_txt1 CLIPPED || " " || g_target CLIPPED  
         RUN l_cmd 
         LET l_cmd = " killcr " ||g_target CLIPPED     
         RUN l_cmd   
      WHEN "BIG5"
         LET l_cmd = "iconv -f UNICODE -t BIG-5 " || g_target CLIPPED || " > " || l_txt1 CLIPPED  #MOD-AB0097
         RUN l_cmd
         LET l_cmd = "cp -f " || l_txt1 CLIPPED || " " || g_target CLIPPED  
         RUN l_cmd 
         LET l_cmd = " killcr " ||g_target CLIPPED     
         RUN l_cmd   
      WHEN "GB2312"
         LET l_cmd = "iconv -f UNICODE -t GB2312 " || g_target CLIPPED || " > " || l_txt1 CLIPPED  #MOD-AB0097
         RUN l_cmd
         LET l_cmd = "cp -f " || l_txt1 CLIPPED || " " || g_target CLIPPED  
         RUN l_cmd 
         LET l_cmd = " killcr " ||g_target CLIPPED     
         RUN l_cmd 
   END CASE
     
   LET g_success='Y' 
   CALL channel_r.openFile(g_target,  "r") 
   IF STATUS THEN
      CALL cl_err("Can't open file: ", STATUS, 0)
      RETURN
   END IF
   CALL channel_r.setDelimiter("")
   CALL s_showmsg_init()
   WHILE channel_r.read(ss)
    #LET tok = base.StringTokenizer.create(ss,ASCII 9)              #FUN-D20044 mark
     LET tok = base.StringTokenizer.createExt(ss,ASCII 9,'',TRUE)   #FUN-D20044
     LET l_j=0
     CALL l_str.clear()
     WHILE tok.hasMoreTokens()
       LET l_j=l_j+1
       LET l_str[l_j]=tok.nextToken()
     END WHILE
     LET g_ayfl.ayf01  = null 
     LET g_ayfl.ayf02  = null
     LET g_ayfl.ayf03  = null
     LET g_ayfl.ayf04  = null 
     LET g_ayfl.ayf06  = null
     LET g_ayfl.ayf07  = null
     LET g_ayfl.ayf08  = null 
     LET g_ayfl.ayf09  = null 
     LET g_ayfl.ayf10  = null                   #FUN-D20047 add
     LET g_ayfl.ayf11  = NULL                   #FUN-D20047 add 
     LET g_ayfl.ayf01  = l_str[1] CLIPPED
     LET g_ayfl.ayf02  = l_str[2] CLIPPED
     LET g_ayfl.ayf03  = l_str[3] CLIPPED
     LET g_ayfl.ayf04  = l_str[4] CLIPPED
     LET g_ayfl.ayf05  = l_str[5] CLIPPED
     LET g_ayfl.ayf06  = l_str[6] CLIPPED
     LET g_ayfl.ayf07  = l_str[7] CLIPPED
     LET g_ayfl.ayf08  = l_str[8] CLIPPED
     LET g_ayfl.ayf09  = l_str[9] CLIPPED
     LET g_ayfl.ayf10  = l_str[10] CLIPPED      #FUN-D20047 add
     LET g_ayfl.ayf11  = l_str[11] CLIPPED      #FUN-D20047 add
    #FUN-D20047 mark begin---
    #IF cl_null(g_ayfl.ayf01) OR cl_null(g_ayfl.ayf02) OR
    #   cl_null(g_ayfl.ayf03) OR 
    #   cl_null(g_ayfl.ayf04) OR cl_null(g_ayfl.ayf09) THEN
    #   CONTINUE WHILE
    #END IF
    #FUN-D20047 mark end-----
    #FUN-D20047 add begin---
     IF cl_null(g_ayfl.ayf01) OR
        cl_null(g_ayfl.ayf04) OR cl_null(g_ayfl.ayf09) THEN
        CONTINUE WHILE
     END IF
     IF cl_null(g_ayfl.ayf02) OR g_ayfl.ayf02 = '' THEN LET g_ayfl.ayf02 = ' ' END IF
     IF cl_null(g_ayfl.ayf03) OR g_ayfl.ayf03 = '' THEN LET g_ayfl.ayf03 = ' ' END IF
    #FUN-D20047 add end-----  
    #依ayf01去撈ayf00帳別
     SELECT axz05 INTO g_ayfl.ayf00
       FROM axz_file
      WHERE axz01 = g_ayfl.ayf01
     IF cl_null(g_ayfl.ayf00) THEN
        CALL s_errmsg('ayf00',g_showmsg,'','agl-095',1)
        CONTINUE WHILE
     END IF
     CALL i020_getdbs(g_ayfl.ayf01,g_ayfl.ayf09)
     IF NOT cl_null(g_ayfl.ayf04) THEN
        SELECT axz04 INTO l_axz04 FROM axz_file
         WHERE axz01 = g_ayfl.ayf01
         IF l_axz04 = 'N' THEN   #非TIPTOP公司
            LET l_sql = "SELECT axq051",
                        "  FROM ",cl_get_target_table(g_plant_gl,'axq_file'),
                        " WHERE axq04 = '",g_ayfl.ayf01,"'",           
                        "   AND axq01 = '",g_ayfl.ayf09,"'",            
                        "   AND axq041 ='",g_ayfl.ayf00,"'",
                        "   AND axq05 = '",g_ayfl.ayf04,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            PREPARE axe04_sel1 FROM l_sql 
            EXECUTE axe04_sel1 INTO g_ayfl.ayf05
            IF cl_null(g_ayfl.ayf05) THEN
               LET g_showmsg = g_ayfl.ayf00,'/',g_ayfl.ayf04
               CALL s_errmsg('ayf00,ayf04',g_showmsg,'','agl1007',1)
               CONTINUE WHILE
            END IF
        ELSE
            LET g_errno = null
            LET l_aag02 = null
            LET l_aag03 = null
            LET l_aag07 = null
            LET l_aagacti = null
            LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                        "  FROM ",cl_get_target_table(g_plant_gl,'aag_file'),
                        " WHERE aag01 = '",g_ayfl.ayf04,"'",
                        "   AND aag00 = '",g_ayfl.ayf00,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql   #FUN-D20047 add
            PREPARE ayf04_sel2 FROM g_sql
            DECLARE ayf04_cur2 CURSOR FOR ayf04_sel2
            OPEN ayf04_cur2
            FETCH ayf04_cur2 INTO l_aag02,l_aag03,l_aag07,l_aagacti
            LET g_ayfl.ayf05 = l_aag02
            CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
                #WHEN l_aagacti = 'N'     LET g_errno = '9028'         #MOD-BB0131 mark
                 WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                 OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               LET g_showmsg = g_ayfl.ayf00,'/',g_ayfl.ayf04
               CALL s_errmsg('ayf00,ayf04',g_showmsg,'',g_errno,1)
               CONTINUE WHILE
            END IF
            CLOSE ayf04_cur2
            IF SQLCA.sqlcode = 0 THEN
               LET g_errno = null
               LET l_aag02 = null
               LET l_aag03 = null
               LET l_aag07 = null
               LET l_aagacti = null
               LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                           "  FROM ",cl_get_target_table(g_plant_gl,'aag_file'),
                           " WHERE aag01 = '",g_ayfl.ayf04,"'",
                           "   AND aag00 = '",g_ayfl.ayf00,"'",
                           "   AND aag09 = 'Y'" 
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               PREPARE ayf04_sel3 FROM g_sql
               DECLARE ayf04_cur3 CURSOR FOR ayf04_sel3
               OPEN ayf04_cur3
               FETCH ayf04_cur3 INTO l_aag02,l_aag03,l_aag07,l_aagacti
               LET g_ayfl.ayf05 = l_aag02
               CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-214'
                    WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                    OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
               END CASE
               IF NOT cl_null(g_errno) THEN
                  LET g_showmsg = g_ayfl.ayf00,'/',g_ayfl.ayf04
                  CALL s_errmsg('ayf00,ayf04',g_showmsg,'',g_errno,1)
                  CONTINUE WHILE
               END IF
               CLOSE ayf04_cur3
             END IF
         END IF
     END IF
     IF NOT cl_null(g_ayfl.ayf06) THEN
        CALL s_aaz641_dbs(g_ayfl.ayf09,g_ayfl.ayf01) RETURNING g_plant_axz03
        CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641 
        LET g_errno = null
        LET l_aag02 = null
        LET l_aag03 = null
        LET l_aag07 = null
        LET l_aagacti = null
        LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",                                                                                 
                    "  FROM ",cl_get_target_table(g_plant_axz03,'aag_file'),
                    " WHERE aag01 = '",g_ayfl.ayf06,"'",                                                                           
                    "  AND aag00 = '",g_aaz641,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                                            
        PREPARE ayf06_sel2 FROM g_sql 
        DECLARE ayf06_cur2 CURSOR FOR ayf06_sel2                                                                                       
        OPEN ayf06_cur2                                                                                                                 
        FETCH ayf06_cur2 INTO l_aag02,l_aag03,l_aag07,l_aagacti                                                                         

        CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001' 
            #WHEN l_aagacti = 'N'     LET g_errno = '9028'               #MOD-BB0131 mark 
             WHEN l_aag07  = '1'      LET g_errno = 'agl-015' 
             OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
        END CASE 
        IF NOT cl_null(g_errno) THEN
           LET g_showmsg = g_ayfl.ayf00,'/',g_ayfl.ayf06
           CALL s_errmsg('ayf00,ayf06',g_showmsg,'',g_errno,1)
           CONTINUE WHILE
        END IF

        IF SQLCA.sqlcode = 0 THEN
           LET g_errno = null
           LET l_aag02 = null
           LET l_aag03 = null
           LET l_aag07 = null
           LET l_aagacti = null
           LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",                                                                                 
                       "  FROM ",cl_get_target_table(g_plant_axz03,'aag_file'),
                       " WHERE aag01 = '",g_ayfl.ayf06,"'",                                                                           
                       "  AND aag00 = '",g_aaz641,"'",
                       "  AND aag09 = 'Y'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
           PREPARE ayf06_sel3 FROM g_sql                                                                                                   
           DECLARE ayf06_cur3 CURSOR FOR ayf06_sel3
           OPEN ayf06_cur3
           FETCH ayf06_cur3 INTO l_aag02,l_aag03,l_aag07,l_aagacti                                                                         

           CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-214'
               #WHEN l_aagacti = 'N'     LET g_errno = '9028'                #MOD-BB0131 mark
                WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
           END CASE 
        END IF
        IF NOT cl_null(g_errno) THEN
           LET g_showmsg = g_ayfl.ayf00,'/',g_ayfl.ayf06
           CALL s_errmsg('ayf00,ayf06',g_showmsg,'',g_errno,1)
           CONTINUE WHILE
        END IF
     END IF
     LET l_cnt = 0
     IF NOT cl_null(g_ayfl.ayf07) THEN 
        #--FUN-D20047 mark start--
        #SELECT COUNT(*) INTO l_cnt       
        #  FROM ayf_file
        # WHERE ayf00 = g_ayfl.ayf00
        #   AND ayf01 = g_ayfl.ayf01
        #   AND ayf04 = g_ayfl.ayf04
        #   AND ayf09 = g_ayfl.ayf09
        #   AND ayf07 != g_ayfl.ayf07 
        #IF l_cnt > 0 THEN
        #    LET g_showmsg = g_ayfl.ayf00,'/',g_ayfl.ayf06
        #    CALL s_errmsg('ayf00,ayf06',g_showmsg,'','agl1053',1)
        #    CONTINUE WHILE
        #END IF
        #---FUN-D20047 mark end---
         SELECT COUNT(*) INTO l_cnt       
           FROM ayf_file
          WHERE ayf00 = g_ayfl.ayf00
            AND ayf01 = g_ayfl.ayf01
            AND ayf04 = g_ayfl.ayf04
            AND ayf09 = g_ayfl.ayf09
            AND ayf10 = g_ayfl.ayf10   #FUN-D20047 add
            AND ayf11 = g_ayfl.ayf11   #FUN-D20047 add
            AND ayf07 != g_ayfl.ayf08 
         IF l_cnt > 0 THEN
             LET g_showmsg = g_ayfl.ayf00,'/',g_ayfl.ayf06
             CALL s_errmsg('ayf00,ayf06',g_showmsg,'','agl1054',1)
             CONTINUE WHILE
         END IF
     END IF  
     CALL i020_ins_ayf()
   END WHILE
   CALL channel_r.close()
   
   IF g_totsuccess="N" THEN 
      LET g_success="N" 
   END IF  
END FUNCTION

FUNCTION i020_gem(l_gem01)
DEFINE l_gem05   LIKE gem_file.gem05
DEFINE l_gemacti LIKE gem_file.gemacti
DEFINE l_gem01   LIKE gem_file.gem01
DEFINE l_gem02   LIKE gem_file.gem02
DEFINE l_axz03   LIKE axz_file.axz03   #CHI-D20029
  #--CHI-D20029 mark start--
  #SELECT gem02,gem05,gemacti
  #  INTO l_gem02,l_gem05,l_gemacti FROM gem_file
  #   WHERE gem01 = l_gem01
  #--CHI-D20029 mark end---
  #--CHI-D20029 start--
   SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01= g_ayf01
   LET g_sql = "SELECT gem02,gem05,gemacti  ",
               " FROM ",cl_get_target_table(l_axz03,'gem_file'),
               " WHERE gem01 ='",l_gem01,"'"
 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
   CALL cl_parse_qry_sql(g_sql,l_axz03) RETURNING g_sql 
   PREPARE i020_gem_p1 FROM g_sql
   DECLARE i020_gem_c1 CURSOR FOR i020_gem_p1
   OPEN i020_gem_c1
   FETCH i020_gem_c1 INTO l_gem02,l_gem05,l_gemacti
   CLOSE i020_gem_c1
  #--CHI-D20029 end----

    CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-003'
         WHEN l_gemacti = 'N'     LET g_errno = '9028'
         WHEN l_gem05  = 'N'      LET g_errno = 'agl-202'
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
    RETURN l_gem02
END FUNCTION

#FUN-D20044--
FUNCTION i020_exceldata()  

DEFINE l_gaq03   LIKE gaq_file.gaq03
DEFINE l_str     STRING
DEFINE l_str1    STRING
DEFINE ls_cell   STRING
DEFINE l_gaq03_s STRING 
DEFINE i         LIKE type_file.num5

DEFINE l_gaq_feld   DYNAMIC ARRAY OF RECORD
        gaq01       LIKE gaq_file.gaq01,
        locate      LIKE gaq_file.gaq01
        END RECORD

   CALL l_gaq_feld.clear()

  #公司編號
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'ayc01'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C1'

  #起始部門編號
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'ayf02'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C2'

  #截止部門編號
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'ayf03'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C3'

  #來源科目編號
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'ayf04'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C4'

  #來源科目名稱
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'ayf05'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C5'

  #合併財報科目編號
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'ayf06'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C6'

  #再衡量匯率類別
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'ayf07'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C7'

  #換算匯率類別
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'ayf08'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C8'

  #族群代號
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'ayf09'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C9'

  #FUN-D20047 add begin--- 
  #Year
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'ayf10'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C10'

  #Period
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'ayf11'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C11'
  #FUN-D20047 add end-----

   FOR i = 1 TO l_gaq_feld.getLength()
      SELECT gaq03 INTO l_gaq03 
        FROM gaq_file 
       WHERE gaq01 = l_gaq_feld[i].gaq01
         AND gaq02 = g_lang
      LET l_gaq03_s = l_gaq03       
      LET l_str = l_gaq03_s.trim() 
      LET ls_cell = l_gaq_feld[i].locate
      LET l_str1 = "DDEPoke Sheet1 "CLIPPED,l_gaq_feld[i].locate
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet1,ls_cell,l_str],li_result)
   END FOR

END FUNCTION
#FUN-D20044--
