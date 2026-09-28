# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cxct002.4gl
# Descriptions...: 每月在制结存导入作业
# Date & Author..: 17/03/27 by donghy

IMPORT os
DATABASE ds
GLOBALS "../../../tiptop/config/top.global"
DEFINE g_tc_ccg_m  RECORD  
       tc_ccg01           LIKE tc_ccg_file.tc_ccg01,
       tc_ccg02           LIKE tc_ccg_file.tc_ccg02
       END RECORD 
DEFINE g_tc_ccg03_t       LIKE tc_ccg_file.tc_ccg03

DEFINE  g_tc_ccg             DYNAMIC ARRAY OF RECORD  
           tc_ccg03    LIKE tc_ccg_file.tc_ccg03,
           sfb05       LIKE sfb_file.sfb05,
           ima02       LIKE ima_file.ima02,
           ima021      LIKE ima_file.ima021,
           tc_ccg04    LIKE tc_ccg_file.tc_ccg04,
           ecd02       LIKE ecd_file.ecd02,
           tc_ccg05    LIKE tc_ccg_file.tc_ccg05
                    END RECORD,
      g_tc_ccg_t           RECORD   
          tc_ccg03    LIKE tc_ccg_file.tc_ccg03,
           sfb05       LIKE sfb_file.sfb05,
           ima02       LIKE ima_file.ima02,
           ima021      LIKE ima_file.ima021,
           tc_ccg04    LIKE tc_ccg_file.tc_ccg04,
           ecd02       LIKE ecd_file.ecd02,
           tc_ccg05    LIKE tc_ccg_file.tc_ccg05
                    END RECORD
DEFINE g_wc                  STRING                      #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680102
DEFINE g_sql                 STRING                      #組 sql 用 
DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE  SQL    
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令 
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose 
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數     
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE str                   STRING
DEFINE g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗 
DEFINE g_t1                  LIKE oay_file.oayslip
DEFINE g_rec_b               LIKE type_file.num5         
DEFINE l_ac                  LIKE type_file.num5 
DEFINE g_correct,g_sdate,g_edate LIKE tc_omc_file.tc_omc08
DEFINE g_chr                 LIKE type_file.chr1
DEFINE g_days                LIKE type_file.num5
DEFINE g_show                LIKE type_file.chr1
DEFINE g_change          LIKE type_file.chr1
MAIN
    OPTIONS
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN                     #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                             #切換成使用者預設的營運中心
   END IF

   WHENEVER ERROR CALL cl_err_msg_log          #遇錯則記錄log檔
 
   IF (NOT cl_setup("CXC")) THEN               #預設模組參數(g_aza.*,...)、權限參數
      EXIT PROGRAM                             #判斷使用者程式執行權限
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程式進入時間
   CLEAR FORM 
   CALL g_tc_ccg.clear()
    INITIALIZE g_tc_ccg_m.* TO NULL 
    INITIALIZE g_tc_ccg_t.* TO NULL 
 
   LET g_forupd_sql =  " SELECT tc_ccg03,tc_ccg04,tc_ccg05 ",
                       " FROM tc_ccg_file WHERE tc_ccg01 = ?",
                       "   AND tc_ccg02=?  ",
                       " FOR UPDATE"      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE t002_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW t002_w WITH FORM "cxc/42f/cxct002"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊
   

   LET g_action_choice = ""
   CALL t002_menu()                                         #進入選單 Menu
 
   CLOSE WINDOW t002_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN

FUNCTION t002_curs()

    CLEAR FORM
    CALL g_tc_ccg.clear()
    CALL cl_set_head_visible("","YES")  
    INITIALIZE g_tc_ccg_m.* TO NULL 


    INPUT BY NAME g_tc_ccg_m.tc_ccg01,g_tc_ccg_m.tc_ccg02 WITHOUT DEFAULTS
   	
      BEFORE INPUT
   #     CALL cl_qbe_display_condition(lc_qbe_sn)

      ON ACTION controlg       
         CALL cl_cmdask()    

      ON IDLE g_idle_seconds 
         CALL cl_on_idle()   
         CONTINUE INPUT      

      ON ACTION about        
         CALL cl_about()     

      ON ACTION help         
         CALL cl_show_help() 

   END INPUT
   
   IF INT_FLAG THEN
      RETURN
   END IF
    CONSTRUCT BY NAME g_wc ON  tc_ccg03,sfb05,tc_ccg04,tc_ccg05
        
        BEFORE CONSTRUCT                                   
           CALL cl_qbe_init()                               
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_ccg03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sfb"
                 LET g_qryparam.state = "c"                 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ccg03
                 NEXT FIELD tc_ccg03 
              WHEN INFIELD(sfb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"                 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfb05
                 NEXT FIELD sfb05 
              WHEN INFIELD(tc_ccg04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ecd"
                 LET g_qryparam.state = "c"                 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ccg04
                 NEXT FIELD tc_ccg04 
              OTHERWISE
                 EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds                                #Idle控管（每一交談指令皆要加入）
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about                                       #程式資訊（每一交談指令皆要加入）
         CALL cl_about()  

      ON ACTION generate_link
         CALL cl_generate_shortcut()
 
      ON ACTION help                                        #程式說明（每一交談指令皆要加入）
         CALL cl_show_help()  
 
      ON ACTION controlg                                    #開啟其他作業（每一交談指令皆要加入）
         CALL cl_cmdask()  
 
      ON ACTION qbe_select                                  #選擇儲存的查詢條件
         CALL cl_qbe_select()

      ON ACTION qbe_save                                    #儲存畫面上欄位條件
         CALL cl_qbe_save()
    END CONSTRUCT
    
  
    IF INT_FLAG THEN RETURN END IF
  
    CALL t002_cursor()
    
END FUNCTION

FUNCTION t002_cursor()
   LET g_sql=" SELECT DISTINCT tc_ccg01,tc_ccg02 FROM tc_ccg_file ",
              " WHERE ",g_wc CLIPPED
   IF NOT cl_null(g_tc_ccg_m.tc_ccg01) THEN
     LET g_sql = g_sql," AND tc_ccg01 = ",g_tc_ccg_m.tc_ccg01
   END IF
   IF NOT cl_null(g_tc_ccg_m.tc_ccg02) THEN
     LET g_sql = g_sql," AND tc_ccg02 = ",g_tc_ccg_m.tc_ccg02
   END IF
    PREPARE t002_prepare FROM g_sql
    DECLARE t002_cs SCROLL CURSOR WITH HOLD FOR t002_prepare
    LET g_sql=" SELECT COUNT(*) ",
              "   FROM (",g_sql,")"
    PREPARE t002_precount FROM g_sql
    DECLARE t002_count CURSOR FOR t002_precount
END FUNCTION 

FUNCTION t002_menu()
    DEFINE l_cmd    STRING 

    WHILE TRUE
      CALL t002_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL t002_a()
            END IF        
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t002_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t002_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
                  CALL t002_b()
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
               call cl_export_to_excel(ui.interface.getrootnode(),base.typeinfo.create(g_tc_ccg),'','')
            END IF 
      END CASE
    END WHILE
END FUNCTION

FUNCTION t002_a()
DEFINE li_result LIKE type_file.num5
DEFINE l_count   LIKE type_file.num5
    CLEAR FORM                                   # 清螢幕欄位內容
    CALL g_tc_ccg.clear()
    INITIALIZE g_tc_ccg_m.*  TO NULL 
  
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE

        CALL t002_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET g_tc_ccg_m.tc_ccg01=NULL 
            CLEAR FORM 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_tc_ccg_m.tc_ccg01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
         
        LET g_rec_b=0
        CALL t002_b()     
        
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

FUNCTION t002_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n,l_count   LIKE type_file.num5 
   DEFINE li_result     LIKE type_file.num5
   DEFINE l_azf03       LIKE azf_file.azf03
   DEFINE l_num         LIKE type_file.num5
   DEFINE l_cn1         LIKE type_file.num10
 
   DISPLAY BY NAME g_tc_ccg_m.tc_ccg01,g_tc_ccg_m.tc_ccg02
            
   INPUT BY NAME g_tc_ccg_m.tc_ccg01,g_tc_ccg_m.tc_ccg02 WITHOUT DEFAULTS 
 
      BEFORE INPUT
          LET g_before_input_done = TRUE
          
      AFTER FIELD tc_ccg01
            SELECT COUNT(*) INTO l_num FROM tc_ccg_file 
            WHERE tc_ccg01 = g_tc_ccg_m.tc_ccg01 AND tc_ccg02 = g_tc_ccg_m.tc_ccg02
            IF l_num>0 THEN
               CALL cl_err(g_tc_ccg_m.tc_ccg01,'cxc-004',0)
               NEXT FIELD tc_ccg01
            END IF

         AFTER FIELD tc_ccg02
            SELECT COUNT(*) INTO l_num FROM tc_ccg_file 
            WHERE tc_ccg01 = g_tc_ccg_m.tc_ccg01 AND tc_ccg02 = g_tc_ccg_m.tc_ccg02
            IF l_num>0 THEN
               CALL cl_err(g_tc_ccg_m.tc_ccg01,'cxc-004',0)
               NEXT FIELD tc_ccg02
            END IF

    
      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            
 
     
 
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
 
      ON ACTION generate_link
         CALL cl_generate_shortcut()
 
      ON ACTION help   
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION

FUNCTION t002_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_tc_ccg_m.tc_ccg01 TO NULL 
    
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM 
    CALL g_tc_ccg.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t002_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t002_count
    FETCH t002_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t002_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_ccg_m.tc_ccg01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_ccg_m.tc_ccg01 TO NULL
    ELSE
        CALL t002_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION


FUNCTION t002_fetch(p_flazb)
    DEFINE p_flazb         LIKE type_file.chr1
 
    CASE p_flazb
        WHEN 'N' FETCH NEXT     t002_cs INTO g_tc_ccg_m.tc_ccg01,g_tc_ccg_m.tc_ccg02
        WHEN 'P' FETCH PREVIOUS t002_cs INTO g_tc_ccg_m.tc_ccg01,g_tc_ccg_m.tc_ccg02
        WHEN 'F' FETCH FIRST    t002_cs INTO g_tc_ccg_m.tc_ccg01,g_tc_ccg_m.tc_ccg02
        WHEN 'L' FETCH LAST     t002_cs INTO g_tc_ccg_m.tc_ccg01,g_tc_ccg_m.tc_ccg02
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about       
                     CALL cl_about()    
 
                  ON ACTION generate_link
                     CALL cl_generate_shortcut()
 
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
            FETCH ABSOLUTE g_jump t002_cs INTO g_tc_ccg_m.tc_ccg01,g_tc_ccg_m.tc_ccg02
            LET g_no_ask = FALSE   
        WHEN 'A'
             FETCH ABSOLUTE g_curs_index t002_cs INTO g_tc_ccg_m.tc_ccg01,g_tc_ccg_m.tc_ccg02
  
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_ccg_m.tc_ccg01,SQLCA.sqlcode,0)
          INITIALIZE g_tc_ccg_m.tc_ccg01,g_tc_ccg_m.tc_ccg02 TO NULL 
          LET g_tc_ccg_m.tc_ccg01 = NULL      
        RETURN
    ELSE
      CASE p_flazb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE    
    END IF
    DISPLAY g_curs_index TO FORMONLY.cn1
    CALL t002_show()                   # 重新顯示
END FUNCTION

FUNCTION t002_show()
DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_gen02    LIKE gen_file.gen02
   DEFINE l_gen02_1  LIKE gen_file.gen02
   DEFINE l_azf03    LIKE azf_file.azf03
   
    SELECT DISTINCT tc_ccg01,tc_ccg02
    INTO  g_tc_ccg_m.tc_ccg01,g_tc_ccg_m.tc_ccg02
    FROM  tc_ccg_file
    WHERE tc_ccg01=g_tc_ccg_m.tc_ccg01 AND tc_ccg02 = g_tc_ccg_m.tc_ccg02
     
    
    DISPLAY BY NAME g_tc_ccg_m.tc_ccg01,g_tc_ccg_m.tc_ccg02


    CALL t002_b_fill(g_wc)
    
    CALL cl_show_fld_cont()
END FUNCTION


FUNCTION t002_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n,l_i         LIKE type_file.num5,                #檢查重復用         #No.FUN-680136 SMALLINT
    l_ac_o          LIKE type_file.num5,                #No.FUN-680136 SMALLINT
    l_rows          LIKE type_file.num5,                #No.FUN-680136 SMALLINT
    l_success       LIKE type_file.chr1,                #No.FUN-680136 VARCHAR(1)
    l_str           LIKE type_file.chr20,               #No.FUN-680136 VARCHAR(20)
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否      #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態        #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否        #No.FUN-680136 SMALLINT
    l_cn2           LIKE type_file.num10, 
    l_num           LIKE type_file.num5
DEFINE l_azf03      LIKE azf_file.azf03 
DEFINE l_count,l_change,l_period   LIKE type_file.num5
DEFINE l_sql STRING 

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF cl_null(g_tc_ccg_m.tc_ccg01) THEN RETURN END IF
 
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT tc_ccg03,'','','',tc_ccg04,tc_ccg05 ",
                       " FROM tc_ccg_file  ",
                       " WHERE tc_ccg01 = ?   ",
                       " AND tc_ccg02 = ?  ",
                       " AND tc_ccg03 = ? ",
                       " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t002_bcl CURSOR FROM g_forupd_sql 
    
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_tc_ccg WITHOUT DEFAULTS FROM s_tc_ccg.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
    BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
  
           #CALL cl_set_comp_entry("tc_omc05,tc_omc11",FALSE)
            
            
    BEFORE ROW
         BEGIN WORK
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
           
            IF g_rec_b >=l_ac THEN
                LET p_cmd='u'
                LET g_tc_ccg_t.* = g_tc_ccg[l_ac].*
                SELECT COUNT(*) INTO l_count 
                FROM tc_ccg_file 
                WHERE tc_ccg01 = g_tc_ccg_m.tc_ccg01
                      AND tc_ccg01 = g_tc_ccg_m.tc_ccg02
                      AND tc_ccg01 = g_tc_ccg[l_ac].tc_ccg03
                IF l_count>0 THEN 
                    OPEN t002_bcl USING g_tc_ccg_m.tc_ccg01,g_tc_ccg_m.tc_ccg02,g_tc_ccg[l_ac].tc_ccg03
                    
                    IF SQLCA.sqlcode THEN
                       CALL cl_err("OPEN t002_bcl:",SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                       EXIT INPUT 
                    ELSE
                       FETCH t002_bcl INTO g_tc_ccg[l_ac].tc_ccg03,g_tc_ccg[l_ac].sfb05,g_tc_ccg[l_ac].ima02,
                                           g_tc_ccg[l_ac].ima021,g_tc_ccg[l_ac].tc_ccg04,g_tc_ccg[l_ac].ecd02,
                                           g_tc_ccg[l_ac].tc_ccg05
                       IF SQLCA.sqlcode THEN
                          CALL cl_err(g_tc_ccg_t.tc_ccg03,SQLCA.sqlcode,1)
                          LET l_lock_sw = "Y"
                          EXIT INPUT 
                       END IF
                       SELECT sfb05 INTO g_tc_ccg[l_ac].sfb05 FROM sfb_file WHERE sfb01=g_tc_ccg[l_ac].tc_ccg03
                       SELECT ima02,ima021 INTO g_tc_ccg[l_ac].ima02,g_tc_ccg[l_ac].ima021 
                       FROM ima_file WHERE ima01 = g_tc_ccg[l_ac].sfb05
                       DISPLAY BY NAME g_tc_ccg[l_ac].ima02,g_tc_ccg[l_ac].ima021,g_tc_ccg[l_ac].sfb05
                    END IF  
                    LET g_tc_ccg_t.* = g_tc_ccg[l_ac].*      #BACKUP
                 END IF 
                CALL cl_show_fld_cont()     #FUN-550037(smin)

               
            END IF
          
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_tc_ccg[l_ac].* TO NULL      #900423
            LET g_tc_ccg_t.* = g_tc_ccg[l_ac].*         #輸入新資料

            CALL cl_show_fld_cont()     
            NEXT FIELD tc_ccg03
 
    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF

            INSERT INTO tc_ccg_file(tc_ccg01,tc_ccg02,tc_ccg03,
                                    tc_ccg04,tc_ccg05)
                          VALUES(g_tc_ccg_m.tc_ccg01,g_tc_ccg_m.tc_ccg02,g_tc_ccg[l_ac].tc_ccg03,
                                 g_tc_ccg[l_ac].tc_ccg04,g_tc_ccg[l_ac].tc_ccg05)     
            IF SQLCA.sqlcode THEN                     
               CALL cl_err3("ins","tc_ccg_file",g_tc_ccg_m.tc_ccg01,g_tc_ccg_m.tc_ccg02,
                             SQLCA.sqlcode,"","",1)  #No.FUN-660104
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK 
               LET g_rec_b=g_rec_b+1
            END IF
  

    AFTER FIELD tc_ccg03
       IF NOT cl_null(g_tc_ccg[l_ac].tc_ccg03) THEN
       	  LET l_cn2 = 0
       	  SELECT COUNT(*) INTO l_cn2 FROM sfb_file WHERE sfb01 = g_tc_ccg[l_ac].tc_ccg03
       	  IF l_cn2 = 0 THEN 
       	  	 CALL cl_err(g_tc_ccg[l_ac].tc_ccg03,'cxc-002',0)
       	  	 NEXT FIELD tc_ccg03
       	  END IF 	
          SELECT sfb05 INTO g_tc_ccg[l_ac].sfb05 FROM sfb_file WHERE sfb01=g_tc_ccg[l_ac].tc_ccg03
          SELECT ima02,ima021 INTO g_tc_ccg[l_ac].ima02,g_tc_ccg[l_ac].ima021
          FROM ima_file WHERE ima01 = g_tc_ccg[l_ac].sfb05
          DISPLAY BY NAME g_tc_ccg[l_ac].ima02,g_tc_ccg[l_ac].ima021,g_tc_ccg[l_ac].sfb05

        IF (g_tc_ccg[l_ac].tc_ccg03 ! = g_tc_ccg_t.tc_ccg03 AND NOT cl_null(g_tc_ccg[l_ac].tc_ccg03)) OR p_cmd = 'a' THEN
          SELECT COUNT(*) INTO l_num FROM tc_ccg_file 
          WHERE tc_ccg01 = g_tc_ccg_m.tc_ccg01 AND tc_ccg02 = g_tc_ccg_m.tc_ccg02
            AND tc_ccg03 = g_tc_ccg[l_ac].tc_ccg03      
          IF l_num >0 THEN
                CALL cl_err('','cxc-003',0)
                NEXT FIELD tc_ccg03
          END IF
        END IF 
       END IF

    AFTER FIELD tc_ccg04
       IF NOT cl_null(g_tc_ccg[l_ac].tc_ccg04) THEN 
          SELECT COUNT(*) INTO l_num FROM ecd_file WHERE ecd01=g_tc_ccg[l_ac].tc_ccg04
          IF l_num =0 THEN
                CALL cl_err('','cxc-005',0)
                NEXT FIELD tc_ccg04
          END IF
          SELECT COUNT(*) INTO l_num FROM ecm_file WHERE ecm01=g_tc_ccg[l_ac].tc_ccg03
             AND ecm04=g_tc_ccg[l_ac].tc_ccg04
          IF l_num =0 THEN
                CALL cl_err('','cxc-006',0)
                NEXT FIELD tc_ccg04
          END IF
       END IF
       SELECT ecd02 INTO g_tc_ccg[l_ac].ecd02 FROM ecd_file WHERE ecd01=g_tc_ccg[l_ac].tc_ccg04
       DISPLAY BY NAME g_tc_ccg[l_ac].ecd02
   
       
          


     BEFORE DELETE                            #刪除單身
        IF g_tc_ccg_t.tc_ccg03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM tc_ccg_file
                 WHERE tc_ccg01 = g_tc_ccg_m.tc_ccg01 
                     AND  tc_ccg02 = g_tc_ccg_m.tc_ccg02 
                     AND  tc_ccg03 = g_tc_ccg_t.tc_ccg03
                     AND  tc_ccg04 = g_tc_ccg_t.tc_ccg04
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","tc_ccg_file",'',"",
                                  SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE 
                    EXIT INPUT
                END IF
            LET g_rec_b=g_rec_b-1
            END IF
            COMMIT WORK  
            
    ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tc_ccg[l_ac].* = g_tc_ccg_t.*
               CLOSE t002_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tc_ccg[l_ac].tc_ccg03,-263,1)
               LET g_tc_ccg[l_ac].* = g_tc_ccg_t.*
            ELSE
               UPDATE tc_ccg_file SET  tc_ccg03 = g_tc_ccg[l_ac].tc_ccg03,
                                       tc_ccg04 = g_tc_ccg[l_ac].tc_ccg04,
                                       tc_ccg05 = g_tc_ccg[l_ac].tc_ccg05
                WHERE tc_ccg01 = g_tc_ccg_m.tc_ccg01 AND tc_ccg02 = g_tc_ccg_m.tc_ccg02
                  AND tc_ccg03 = g_tc_ccg_t.tc_ccg03 AND tc_ccg04 = g_tc_ccg_t.tc_ccg04
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","tc_ccgfile",'',"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_tc_ccg[l_ac].* = g_tc_ccg_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF

     AFTER INPUT
         
     ON ACTION controlp
        CASE
           WHEN INFIELD(tc_ccg03)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_sfb"
             LET g_qryparam.default1 = g_tc_ccg[l_ac].tc_ccg03
             CALL cl_create_qry() RETURNING g_tc_ccg[l_ac].tc_ccg03
             DISPLAY BY NAME g_tc_ccg[l_ac].tc_ccg03
             NEXT FIELD tc_ccg03
          WHEN INFIELD(tc_ccg04)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_ecd3"
             LET g_qryparam.default1 = g_tc_ccg[l_ac].tc_ccg04
             CALL cl_create_qry() RETURNING g_tc_ccg[l_ac].tc_ccg04
             DISPLAY BY NAME g_tc_ccg[l_ac].tc_ccg04
             NEXT FIELD tc_ccg04

           OTHERWISE
              EXIT CASE
           END CASE    
     AFTER ROW
        LET l_ac = ARR_CURR()
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd = 'u' THEN
              LET g_tc_ccg[l_ac].* = g_tc_ccg_t.*
           ELSE
              CALL g_tc_ccg.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D30034---add---end---
           END IF
           CLOSE t002_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        LET l_ac_t = l_ac  

      ON ACTION CONTROLR
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    
    END INPUT
   
    CALL t002_show()
       
    CLOSE t002_bcl
   COMMIT WORK

    SELECT COUNT(tc_ccg02) INTO l_n FROM tc_ccg_file
    WHERE tc_ccg01 = g_tc_ccg_m.tc_ccg01 AND tc_ccg02 = g_tc_ccg_m.tc_ccg02
    IF l_n = 0 THEN
       CALL t002_delall() 
    END IF
    CALL t002_show()
END FUNCTION

FUNCTION t002_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc  LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
DEFINE l_i   LIKE type_file.num5

    IF cl_null(g_wc) THEN
       LET g_wc = "1=1"
    END IF
    LET g_sql = " SELECT DISTINCT tc_ccg03,sfb05,ima02,ima021,tc_ccg04,'',tc_ccg05 ",                
                " FROM tc_ccg_file,ima_file,sfb_file ",
                " WHERE tc_ccg03 = sfb01 AND sfb05=ima01 ",
                " AND ",g_wc CLIPPED
    IF NOT cl_null(g_tc_ccg_m.tc_ccg01) THEN
       LET g_sql = g_sql," AND tc_ccg01 = ",g_tc_ccg_m.tc_ccg01
    END IF
    IF NOT cl_null(g_tc_ccg_m.tc_ccg02) THEN
       LET g_sql = g_sql," AND tc_ccg02 = ",g_tc_ccg_m.tc_ccg02
    END IF 
    LET g_sql = g_sql," ORDER BY tc_ccg03,tc_ccg04"
    PREPARE t002_prepare2 FROM g_sql      
    DECLARE tc_ccg_cs CURSOR FOR t002_prepare2
    CALL g_tc_ccg.clear()
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH tc_ccg_cs INTO g_tc_ccg[g_cnt].*   #單身ARRAY填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        SELECT ecd02 INTO g_tc_ccg[g_cnt].ecd02 FROM ecd_file WHERE ecd01=g_tc_ccg[g_cnt].tc_ccg04
        LET g_cnt = g_cnt + 1
    END FOREACH

        CALL g_tc_ccg.deleteElement(g_cnt)
        LET g_rec_b = g_cnt - 1  
        DISPLAY g_rec_b TO FORMONLY.cn2   
END FUNCTION


FUNCTION t002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
   DEFINE   l_date_str STRING 
   DEFINE   l_i    LIKE type_file.num5
   DEFINE   l_i_str STRING

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_tc_ccg TO s_tc_ccg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()   
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
         
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
         
      ON ACTION first 
         CALL t002_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY            
 
      ON ACTION previous
         CALL t002_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
	     ACCEPT DISPLAY            
 
      ON ACTION jump 
         CALL t002_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	     ACCEPT DISPLAY              
 
      ON ACTION next
         CALL t002_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	     ACCEPT DISPLAY              
 
      ON ACTION last 
         CALL t002_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
	     ACCEPT DISPLAY               
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY 

      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION ACCEPT 
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit" 
         EXIT DISPLAY 
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()     
      
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
 
         
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION t002_r()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_tc_ccg_m.tc_ccg01 IS NULL THEN 
       CALL cl_err("",-400,0)                 #No.FUN-6A0162
       RETURN
    END IF
    
    IF cl_delh(0,0) THEN                   #確認一下 

        DELETE FROM tc_ccg_file WHERE tc_ccg01 = g_tc_ccg_m.tc_ccg01  AND tc_ccg02 = g_tc_ccg_m.tc_ccg02
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","tc_ccg_file",g_tc_ccg_m.tc_ccg01,"",SQLCA.sqlcode,"",
                         "BODY DELETE",1)  #No.FUN-660104
        ELSE
            CLEAR FORM
            CALL g_tc_ccg.clear()
            LET g_tc_ccg_m.tc_ccg01 = NULL
            LET g_tc_ccg_m.tc_ccg02 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN t002_count                                                     
            #FUN-B50063-add-start--
            IF STATUS THEN
               CLOSE t002_cs
               CLOSE t002_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end-- 
            FETCH t002_count INTO g_row_count                 
            #FUN-B50063-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE t002_cs
               CLOSE t002_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt               
            OPEN t002_cs                                      
            IF g_curs_index = g_row_count + 1 THEN            
               LET g_jump = g_row_count                       
               CALL t002_fetch('L')                           
            ELSE                                              
               LET g_jump = g_curs_index                      
               LET g_no_ask = TRUE         #No.FUN-6A0067                   
               CALL t002_fetch('/')                           
            END IF
        END IF
    END IF
END FUNCTION

FUNCTION t002_delall()                                                                                                              
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 則取消單頭資料                                                            
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED                                         
          DELETE FROM tc_ccg_file WHERE tc_ccg01 = g_tc_ccg_m.tc_ccg01  AND tc_ccg02 = g_tc_ccg_m.tc_ccg02
          CLEAR FORM 
          CALL g_tc_ccg.clear() 
    END IF                                                                                                                          
END FUNCTION

