# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: apmt810.4gl
# Descriptions...: 采购跟催维护
# Date & Author..: No.FUN-C90076 12/10/09 By xianghui

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE 
    g_pmn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pmm01       LIKE pmm_file.pmm01,       
        pmn02       LIKE pmn_file.pmn02,       
        pmm03       LIKE pmm_file.pmm03,       
        pmm12       LIKE pmm_file.pmm12,       
        gen02       LIKE gen_file.gen02,       
        pmm09       LIKE pmm_file.pmm09,   
        pmc03       LIKE pmc_file.pmc03,       
        pmn04       LIKE pmn_file.pmn04,       
        pmn041      LIKE pmn_file.pmn041,      
        ima021      LIKE ima_file.ima021,      
        pmn20       LIKE pmn_file.pmn20,
        pmn50       LIKE pmn_file.pmn50,
        pmn07       LIKE pmn_file.pmn07,
        pmn33       LIKE pmn_file.pmn33,
        pmn34       LIKE pmn_file.pmn34,
        pmn35       LIKE pmn_file.pmn35,
        pmz05       LIKE pmz_file.pmz05,
        pmz06       LIKE pmz_file.pmz06,
        pmz07       LIKE pmz_file.pmz07,
        pmz08       LIKE pmz_file.pmz08,
        pmz09       LIKE pmz_file.pmz09,
        pmz10       LIKE pmz_file.pmz10,
        gen02_1     LIKE gen_file.gen02,
        pmz11       LIKE pmz_file.pmz11,
        pmz12       LIKE pmz_file.pmz12
                    END RECORD,
    g_pmn_t         RECORD                      #程式變數 (舊值)
        pmm01       LIKE pmm_file.pmm01,       
        pmn02       LIKE pmn_file.pmn02,       
        pmm03       LIKE pmm_file.pmm03,       
        pmm12       LIKE pmm_file.pmm12,       
        gen02       LIKE gen_file.gen02,       
        pmm09       LIKE pmm_file.pmm09,   
        pmc03       LIKE pmc_file.pmc03,       
        pmn04       LIKE pmn_file.pmn04,       
        pmn041      LIKE pmn_file.pmn041,      
        ima021      LIKE ima_file.ima021,      
        pmn20       LIKE pmn_file.pmn20,
        pmn50       LIKE pmn_file.pmn50,
        pmn07       LIKE pmn_file.pmn07,
        pmn33       LIKE pmn_file.pmn33,
        pmn34       LIKE pmn_file.pmn34,
        pmn35       LIKE pmn_file.pmn35,
        pmz05       LIKE pmz_file.pmz05,
        pmz06       LIKE pmz_file.pmz06,
        pmz07       LIKE pmz_file.pmz07,
        pmz08       LIKE pmz_file.pmz08,
        pmz09       LIKE pmz_file.pmz09,
        pmz10       LIKE pmz_file.pmz10,
        gen02_1     LIKE gen_file.gen02,
        pmz11       LIKE pmz_file.pmz11,
        pmz12       LIKE pmz_file.pmz12      
                    END RECORD,
    g_pmz           DYNAMIC ARRAY OF RECORD    #程式變數 
        pmz03_1     LIKE pmz_file.pmz03,       
        pmz05_1     LIKE pmz_file.pmz05,       
        pmz06_1     LIKE pmz_file.pmz06,       
        pmz07_1     LIKE pmz_file.pmz07,       
        pmz08_1     LIKE pmz_file.pmz08,       
        pmz09_1     LIKE pmz_file.pmz09,   
        pmz10_1     LIKE pmz_file.pmz10,       
        gen02_2     LIKE gen_file.gen02,       
        pmz11_1     LIKE pmz_file.pmz11,      
        pmz12_1     LIKE pmz_file.pmz12,      
        pmz14       LIKE pmz_file.pmz14    
                    END RECORD,
    g_pmz_t           RECORD              #程式變數 (舊值)
        pmz03_1     LIKE pmz_file.pmz03,       
        pmz05_1     LIKE pmz_file.pmz05,       
        pmz06_1     LIKE pmz_file.pmz06,       
        pmz07_1     LIKE pmz_file.pmz07,       
        pmz08_1     LIKE pmz_file.pmz08,       
        pmz09_1     LIKE pmz_file.pmz09,   
        pmz10_1     LIKE pmz_file.pmz10,       
        gen02_2     LIKE gen_file.gen02,       
        pmz11_1     LIKE pmz_file.pmz11,      
        pmz12_1     LIKE pmz_file.pmz12,      
        pmz14       LIKE pmz_file.pmz14    
                    END RECORD,                    
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,        #單身筆數
    g_rec_b1        LIKE type_file.num5,           
    l_ac            LIKE type_file.num5,        #目前處理的ARRAY CNT
    l_ac_t          LIKE type_file.num5         #目前處理的ARRAY CNT

DEFINE g_forupd_sql STRING     #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5    
DEFINE g_row_count  LIKE type_file.num5   
DEFINE g_curs_index LIKE type_file.num5  
DEFINE g_str        STRING              
MAIN
    DEFINE p_row,p_col   LIKE type_file.num5

    OPTIONS                                #改變一些系統預設值
#       FORM LINE       FIRST + 2,         #畫面開始的位置
#       MESSAGE LINE    LAST,              #訊息顯示的位置
#       PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF

      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
         RETURNING g_time

    LET p_row = 4 LET p_col = 3
    OPEN WINDOW t810_w AT p_row,p_col WITH FORM "apm/42f/apmt810"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()

    LET g_wc2 = '1=1'
    CALL t810_b_fill(g_wc2)
    CALL t810_menu()
    CLOSE WINDOW t810_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
         RETURNING g_time
END MAIN

FUNCTION t810_menu()

   WHILE TRUE
      CALL t810_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t810_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t810_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmn),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION t810_q()
   CALL t810_b_askkey()
END FUNCTION

FUNCTION t810_b()
DEFINE
    l_n             LIKE type_file.num5,                 #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否
    p_cmd           LIKE type_file.chr1,                 #處理狀態 
    l_allow_insert  LIKE type_file.chr1,                 #可新增否
    l_allow_delete  LIKE type_file.chr1,                 #可刪除否
    v,l_str         string,
    l_pmn02         LIKE pmn_file.pmn02
DEFINE  g_ima49     LIKE ima_file.ima49
DEFINE  l_ima491    LIKE ima_file.ima491
DEFINE  l_flag      LIKE type_file.chr1    
DEFINE  l_date      LIKE type_file.dat 
DEFINE  li_result   LIKE type_file.num5
DEFINE  i           LIKE type_file.num5
DEFINE  l_pmz       RECORD LIKE pmz_file.*
DEFINE  l_pmm04     LIKE pmm_file.pmm04

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""


    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE
    INPUT ARRAY g_pmn WITHOUT DEFAULTS FROM s_pmn.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW = l_allow_insert) 

    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF

    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()      
        LET l_n  = ARR_COUNT()
        LET g_on_change = TRUE 
        CALL g_pmz.clear()
        CALL t810_d_fill('1=1')
        DISPLAY ARRAY g_pmz TO s_pmz.* ATTRIBUTE(COUNT=g_cnt)
           BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY
        CALL cl_show_fld_cont() 
        
        AFTER FIELD pmz07    #交貨日期
             IF NOT cl_null(g_pmn[l_ac].pmz07) THEN
                SELECT pmm04 INTO l_pmm04 FROM pmm_file WHERE pmm01 = g_pmn[l_ac].pmm01
                IF l_pmm04 > g_pmn[l_ac].pmz07 THEN
                   CALL cl_err("","apm-029",1)           
                   NEXT FIELD pmz07
                END IF
                LET li_result = 0
                CALL s_daywk(g_pmn[l_ac].pmz07) RETURNING li_result
  
                IF li_result = 0 THEN      #0:非工作日
                   CALL cl_err(g_pmn[l_ac].pmz07,'mfg3152',1)
                END IF
                IF li_result = 2 THEN      #2:未設定
                   CALL cl_err(g_pmn[l_ac].pmz07,'mfg3153',1)
                END IF
                IF NOT cl_null(g_pmn[l_ac].pmz08) THEN
                   IF g_pmn[l_ac].pmz07 > g_pmn[l_ac].pmz08 THEN
                      CALL cl_err('','mfg3225',1) 
                      NEXT FIELD pmz08  
                   END IF
                END IF
             END IF
             
 
#        BEFORE FIELD pmz08     #到廠日期
#            IF cl_null(g_pmn[l_ac].pmz08) AND NOT cl_null(g_pmn[l_ac].pmz07) THEN 
#               SELECT ima49 INTO g_ima49 FROM ima_file WHERE ima01 = g_pmn[l_ac].pmn04
#               IF cl_null(g_ima49) THEN LET g_ima49 = 0 END IF    
#               LET g_pmn[l_ac].pmz08 = g_pmn[l_ac].pmz07 + g_ima49
#               CALL s_wkday(g_pmn[l_ac].pmz08) RETURNING l_flag,l_date
#               IF l_date IS NULL OR l_date = ' ' THEN
#                   NEXT FIELD pmz08
#               ELSE
#                   LET g_pmn[l_ac].pmz08 = l_date
#                   DISPLAY g_pmn[l_ac].pmz08 TO pmz08
#               END IF
#            END IF
 
        AFTER FIELD pmz08     
            IF NOT cl_null(g_pmn[l_ac].pmz08) AND NOT cl_null(g_pmn[l_ac].pmz07) THEN
               IF g_pmn[l_ac].pmz07 > g_pmn[l_ac].pmz08 THEN
                  CALL cl_err('','mfg3225',1)  
                  NEXT FIELD pmz08
               END IF
            END IF
            
     AFTER FIELD pmz09
       IF NOT cl_null(g_pmn[l_ac].pmz09) THEN 
          IF g_pmn[l_ac].pmz09 >= 0 THEN 
             IF g_pmn[l_ac].pmz09 > g_pmn[l_ac].pmn20 - g_pmn[l_ac].pmn50 THEN 
                #CALL cl_err(g_pmn[l_ac].pmz09,'apm-908',0) #free mark
                CALL cl_err(g_pmn[l_ac].pmz09,'apm1087',0)  #free
                NEXT FIELD pmz09
             END IF 
          ELSE
             CALL cl_err(g_pmn[l_ac].pmz09,'apm-909',0)
             NEXT FIELD pmz09       
          END IF
       END IF         

     AFTER FIELD pmz10
       IF NOT cl_null(g_pmn[l_ac].pmz10) THEN
          CALL t810_pmz10('a')
          IF NOT cl_null(g_errno)  THEN
             CALL cl_err('',g_errno,0) 
             NEXT FIELD pmz10
          END IF
       END IF 

     AFTER ROW
        LET l_ac = ARR_CURR()            # 新增
        LET l_ac_t = l_ac                # 新增

        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_pmn[l_ac].* = g_pmn_t.*
           END IF
           ROLLBACK WORK                 # 新增
           EXIT INPUT
         END IF
         COMMIT WORK

       ON ACTION controlp
           CASE WHEN INFIELD(pmz10)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.default1 = g_pmn[l_ac].pmz10
                     CALL cl_create_qry() RETURNING g_pmn[l_ac].pmz10
                     DISPLAY g_pmn[l_ac].pmz10 TO pmz10
                OTHERWISE
                     EXIT CASE
            END CASE
            

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

    END INPUT

    IF INT_FLAG THEN
    ELSE
    	 FOR i = 1 TO g_rec_b
    	   IF NOT cl_null(g_pmn[i].pmz07) OR NOT cl_null(g_pmn[i].pmz08) THEN 
    	     BEGIN WORK
    	     INITIALIZE l_pmz.* TO NULL     	      
    	     LET l_pmz.pmz01 = g_pmn[i].pmm01
    	     LET l_pmz.pmz02 = g_pmn[i].pmn02
    	     SELECT MAX(pmz03) INTO l_pmz.pmz03 FROM pmz_file WHERE pmz01 = l_pmz.pmz01 AND pmz02 = l_pmz.pmz02
    	     IF cl_null(l_pmz.pmz03) THEN 
    	        LET l_pmz.pmz03 = 1
    	     ELSE 
    	     	  LET l_pmz.pmz03 = l_pmz.pmz03 + 1
    	     END IF 
    	     LET l_pmz.pmz05 = g_pmn[i].pmz05
    	     LET l_pmz.pmz06 = g_pmn[i].pmz06
    	     LET l_pmz.pmz07 = g_pmn[i].pmz07
    	     LET l_pmz.pmz08 = g_pmn[i].pmz08
    	     LET l_pmz.pmz09 = g_pmn[i].pmz09
    	     LET l_pmz.pmz10 = g_pmn[i].pmz10 
    	     LET l_pmz.pmz11 = g_pmn[i].pmz11
    	     LET l_pmz.pmz12 = g_pmn[i].pmz12
    	     LET l_pmz.pmz13 = '' 
    	     LET l_pmz.pmz14 = g_pmn[i].pmm03
    	     LET l_pmz.pmzplant = g_plant
    	     LET l_pmz.pmzlegal = g_legal
    	     INSERT INTO pmz_file VALUES(l_pmz.*)
           IF SQLCA.sqlcode THEN                     #置入資料庫不成功
              CALL cl_err3("ins","pmz_file",l_pmz.pmz01,l_pmz.pmz02,SQLCA.sqlcode,"","",1)
              ROLLBACK WORK 
#             CALL cl_err3("ins","pmz_file",l_pmz.pmz01,l_pmz.pmz02,SQLCA.sqlcode,"","",1)   #FUN-C90076 xj 調換位置
           ELSE
              COMMIT WORK
           END IF 
         END IF 
       END FOR
    END IF 
    CALL t810_b_fill(g_wc2)         	     
           
    COMMIT WORK
END FUNCTION

FUNCTION t810_pmz10(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_genacti       LIKE gen_file.genacti

    LET g_errno = ' '
    SELECT gen02,genacti INTO g_pmn[l_ac].gen02_1,l_genacti
      FROM gen_file
     WHERE gen01 = g_pmn[l_ac].pmz10 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-005'
                            LET g_pmn[l_ac].gen02_1 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION t810_b_askkey()
    CLEAR FORM
    CALL g_pmn.clear()

    CONSTRUCT g_wc2 ON pmm01,pmn02,pmm03,pmm12,pmm09,pmn04,pmn041,pmn07,pmn33,pmn34,pmn35
         FROM s_pmn[1].pmm01,s_pmn[1].pmn02,s_pmn[1].pmm03,s_pmn[1].pmm12,s_pmn[1].pmm09,s_pmn[1].pmn04,s_pmn[1].pmn041,
              s_pmn[1].pmn07,s_pmn[1].pmn33,s_pmn[1].pmn34,s_pmn[1].pmn35

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE WHEN INFIELD(pmm01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_pmm"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_pmn[1].pmm01
              WHEN INFIELD(pmm12)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_gen"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_pmn[1].pmm12  
              WHEN INFIELD(pmm09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_pmc"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_pmn[1].pmm09  
              WHEN INFIELD(pmn04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_ima"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_pmn[1].pmn04                                                       
              OTHERWISE
                   EXIT CASE
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

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
    END IF
    CALL t810_b_fill(g_wc2)

END FUNCTION

FUNCTION t810_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           STRING,
       l_pmm           RECORD LIKE pmm_file.*,
       l_pmn           RECORD LIKE pmn_file.*,
       l_ima           RECORD LIKE ima_file.*,
       l_imz           RECORD LIKE imz_file.*

    LET g_sql = "SELECT * FROM pmm_file,pmn_file,ima_file LEFT JOIN imz_file ON ima06 = imz01 ",
                " WHERE pmm01 = pmn01 AND pmn04 = ima01 AND pmm25 = '2' AND pmn16 = '2' ",
                " AND ((pmn33 - nvl(ima171,0)) <= sysdate OR (pmn34 - nvl(ima172,0)) <= sysdate) ",
                " AND pmm02 not like 'T%'",
                " and pmn20 > pmn50 ",
                " AND ", p_wc2 CLIPPED, 
                " ORDER BY pmm09,pmm12,pmn33 "

    PREPARE t810_pb FROM g_sql
    DECLARE pmn_curs CURSOR FOR t810_pb

    CALL g_pmn.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pmn_curs INTO l_pmm.*,l_pmn.*,l_ima.*,l_imz.*
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
       LET g_pmn[g_cnt].pmm01 = l_pmm.pmm01  
       LET g_pmn[g_cnt].pmn02 = l_pmn.pmn02  
       LET g_pmn[g_cnt].pmm03 = l_pmm.pmm03  
       LET g_pmn[g_cnt].pmm12 = l_pmm.pmm12  
       LET g_pmn[g_cnt].pmm09 = l_pmm.pmm09  
       LET g_pmn[g_cnt].pmn04 = l_pmn.pmn04  
       LET g_pmn[g_cnt].pmn041= l_pmn.pmn041 
       LET g_pmn[g_cnt].ima021= l_ima.ima021 
       LET g_pmn[g_cnt].pmn20 = l_pmn.pmn20  
       LET g_pmn[g_cnt].pmn50 = l_pmn.pmn50  
       LET g_pmn[g_cnt].pmn07 = l_pmn.pmn07  
       LET g_pmn[g_cnt].pmn33 = l_pmn.pmn33  
       LET g_pmn[g_cnt].pmn34 = l_pmn.pmn34  
       LET g_pmn[g_cnt].pmn35 = l_pmn.pmn35  

       SELECT gen02 INTO g_pmn[g_cnt].gen02
         FROM gen_file
        WHERE gen01 = g_pmn[g_cnt].pmm12
       SELECT pmc03 INTO g_pmn[g_cnt].pmc03
         FROM pmc_file
        WHERE pmc01 = g_pmn[g_cnt].pmm09
        LET g_pmn[g_cnt].pmz05 = g_today
        LET g_pmn[g_cnt].pmz06 = g_today
        LET g_pmn[g_cnt].pmz09 = g_pmn[g_cnt].pmn20 - g_pmn[g_cnt].pmn50 
        LET g_pmn[g_cnt].pmz10 = g_user
        SELECT gen02 INTO g_pmn[g_cnt].gen02_1 
          FROM gen_file
         WHERE gen01 = g_pmn[g_cnt].pmz10
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pmn.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0

END FUNCTION

FUNCTION t810_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   LET g_row_count = 0
   LET g_curs_index = 0

   CALL cl_set_act_visible("accept,cancel", FALSE)
   
 DIALOG ATTRIBUTES(UNBUFFERED)    
   DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF NOT cl_null(l_ac_t) THEN
            CALL fgl_set_arr_curr(l_ac_t)
         END IF
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL g_pmz.clear()
         CALL t810_d_fill('1=1')         
         CALL cl_show_fld_cont()
         
      AFTER DISPLAY
         CONTINUE DIALOG
   END DISPLAY 
   
   DISPLAY ARRAY g_pmz TO s_pmz.* ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
         
      AFTER DISPLAY
         CONTINUE DIALOG
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

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

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

FUNCTION t810_d_fill(p_wc2)              #BODY FILL UP

    DEFINE p_wc2           STRING

    LET g_sql = "SELECT pmz03,pmz05,pmz06,pmz07,pmz08,pmz09,pmz10,'',pmz11,pmz12,pmz14 ",
                "  FROM pmz_file ",
                " WHERE pmz01 = '",g_pmn[l_ac].pmm01,"' ",
                "   AND pmz02 = '",g_pmn[l_ac].pmn02,"' ",
                "   AND ",p_wc2

    PREPARE t810_pb1 FROM g_sql
    DECLARE pmz_curs CURSOR FOR t810_pb1

    CALL g_pmz.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pmz_curs INTO g_pmz[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT gen02 INTO g_pmz[g_cnt].gen02_2 FROM gen_file WHERE gen01 = g_pmz[g_cnt].pmz10_1        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pmz.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b1 = g_cnt-1
    #DISPLAY g_rec_b1 TO FORMONLY.cn2  
    LET g_cnt = 0

END FUNCTION

#FUN-C90076
