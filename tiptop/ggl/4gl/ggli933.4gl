# Prog. Version..: '5.30.06-13.04.22(00004)'     #
# Pattern name...: ggli933.4gl
# Descriptions...: 現金流量表活動科目設定 
# Date & Author..: FUN-B60083 11/06/15 BY lixia
# Modify.........: No.TQC-C30136 12/03/08 By fengrui 處理ON ACITON衝突問題
# Modify.........: No.TQC-C50230 12/05/29 By lujh 第二單身開窗查詢應該也可以查到統制科目，需和AFTER FIELD 判斷條件一致
# Modify.........: No:FUN-D30032 13/04/02 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE   
    g_giv00         LIKE giv_file.giv00,  
    g_giv01         LIKE giv_file.giv01,      #活動類別(假單頭)
    g_giv00_t       LIKE giv_file.giv00,      #活動類別(舊值)  
    g_giv01_t       LIKE giv_file.giv01,      #活動類別(舊值)
    g_gir           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
       giv01           LIKE giv_file.giv01,   #群組代碼
       gir02           LIKE gir_file.gir02,   #說明
       gir03           LIKE gir_file.gir03,   #變動分類
       gir04           LIKE gir_file.gir04,   #合併否
       gir05           LIKE gir_file.gir05    #行次 
                    END RECORD,
    g_gir_t         RECORD                    #程式變數 (舊值)
       giv01           LIKE giv_file.giv01,   #群組代碼
       gir02           LIKE gir_file.gir02,   #說明
       gir03           LIKE gir_file.gir03,   #變動分類
       gir04           LIKE gir_file.gir04,   #合併否
       gir05           LIKE gir_file.gir05    #行次 
                    END RECORD,
    g_giv           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        giv02       LIKE giv_file.giv02,      #科目編號
        aag02       LIKE aag_file.aag02,      #科目名稱
        giv03       LIKE giv_file.giv03,      #加減項
        giv04       LIKE giv_file.giv04       #異動別
                    END RECORD,
    g_giv_t         RECORD                    #程式變數 (舊值)
        giv02       LIKE giv_file.giv02,      #科目編號
        aag02       LIKE aag_file.aag02,      #科目名稱
        giv03       LIKE giv_file.giv03,      #加減項
        giv04       LIKE giv_file.giv04       #異動別
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,            
    g_sql_tmp           STRING,        
    g_rec_b         LIKE type_file.num5,      #單身筆數             
    l_ac            LIKE type_file.num5       #目前處理的ARRAY CNT    
DEFINE g_str        STRING     
DEFINE g_dbs_axz03         LIKE type_file.chr21    
#主程式開始
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE NOWAIT SQL       
DEFINE g_before_input_done  LIKE type_file.num5       
DEFINE g_cnt                LIKE type_file.num10         
DEFINE g_i                  LIKE type_file.num5          
DEFINE g_msg                LIKE ze_file.ze03          
DEFINE g_row_count          LIKE type_file.num10        
DEFINE g_curs_index         LIKE type_file.num10        
DEFINE g_jump               LIKE type_file.num10        
DEFINE mi_no_ask            LIKE type_file.num5          
DEFINE l_ac0                LIKE type_file.num5  
DEFINE g_rec_b0             LIKE type_file.num5  

MAIN
DEFINE
   p_row,p_col     LIKE type_file.num5    #開窗的位置        

   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

  IF (NOT cl_user()) THEN
     EXIT PROGRAM
  END IF
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF (NOT cl_setup("GGL")) THEN
     EXIT PROGRAM
  END IF
  CALL cl_used(g_prog,g_time,1) RETURNING g_time 


   LET p_row = ARG_VAL(2)                 #取得螢幕位置
   LET p_col = ARG_VAL(3)    
   LET g_giv01      = NULL                #清除鍵值
   LET g_giv01_t    = NULL
   LET g_giv00      = NULL                #清除鍵值
   LET g_giv00_t    = NULL
   
   LET p_row = 3 LET p_col = 14
       
   OPEN WINDOW i933_w AT p_row,p_col      #顯示畫面
     WITH FORM "ggl/42f/ggli933"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
   CALL i933_menu()
   CLOSE WINDOW i933_w                    #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

#QBE 查詢資料
FUNCTION i933_cs()
   CLEAR FORM                                   #清除畫面
      CALL g_giv.clear()
   CALL cl_set_head_visible("","YES")           

   INITIALIZE g_giv00 TO NULL    
   INITIALIZE g_giv01 TO NULL    

   CONSTRUCT g_wc ON giv00,giv01,giv02,giv03,giv04      #螢幕上取條件  
        FROM giv00,s_gir[1].giv01,s_giv[1].giv02,s_giv[1].giv03,s_giv[1].giv04 
              
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         
      ON ACTION controlp                 # 沿用所有欄位
         CASE
            WHEN INFIELD(giv00)                                                                                                       
               CALL cl_init_qry_var()                                                                                                 
               LET g_qryparam.state = "c"                                                                                             
               LET g_qryparam.form ="q_aaa"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                     
               DISPLAY g_qryparam.multiret TO giv00                                                                                   
               NEXT FIELD giv00
            WHEN INFIELD(giv01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gir2"  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO giv01
               NEXT FIELD giv01 
            WHEN INFIELD(giv02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aag"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO giv02
               #CALL i933_giv()      #TQC-C50230  mark
               NEXT FIELD giv02
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

   IF INT_FLAG THEN RETURN END IF
   LET g_sql="SELECT UNIQUE giv00 FROM giv_file ", 
             " WHERE ", g_wc CLIPPED,
             " ORDER BY giv00"
   PREPARE i933_prepare FROM g_sql              #預備一下
   DECLARE i933_b_cs                            #宣告成可捲動的
    SCROLL CURSOR WITH HOLD FOR i933_prepare
                                                #計算本次查詢單頭的筆數
   LET g_sql_tmp= "SELECT UNIQUE giv00 FROM giv_file ",        
                  " WHERE ",g_wc CLIPPED,                                                                                           
                  "  INTO TEMP x"                                                                                                  
   DROP TABLE x                                                                                                                     
   PREPARE i933_pre_x FROM g_sql_tmp                                                                                   
   EXECUTE i933_pre_x                                                                                                               
   LET g_sql = "SELECT COUNT(*) FROM x"                                                                                             
   PREPARE i933_precount FROM g_sql
   DECLARE i933_count CURSOR FOR i933_precount
END FUNCTION

FUNCTION i933_menu()

   WHILE TRUE
      CALL i933_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i933_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i933_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i933_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i933_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  
            IF cl_chk_act_auth() THEN
               IF g_giv00 IS NULL OR g_giv01 IS NOT NULL THEN  
                  LET g_doc.column1 = "giv01"
                  LET g_doc.value1 = g_giv01
                  LET g_doc.column2 = "giv00"
                  LET g_doc.value2 = g_giv00
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_giv),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

#Add  輸入
FUNCTION i933_a()
DEFINE   l_n    LIKE type_file.num5          
   
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
   CALL g_giv.clear()
   INITIALIZE g_giv00 LIKE giv_file.giv00
   LET g_giv00_t = NULL
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i933_i("a")                           #輸入單頭
      IF INT_FLAG THEN                           #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_giv.clear()
      LET g_rec_b = 0                    
      LET g_rec_b0 = 0
      CALL g_gir.clear()
      CALL i933_b()                             #輸入單身
      LET g_giv00_t = g_giv00                   #保留舊值 
      EXIT WHILE
   END WHILE
END FUNCTION

#處理INPUT
FUNCTION i933_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改   
   l_cnt           LIKE type_file.num5,          
   l_n1,l_n        LIKE type_file.num5 
   
   CALL cl_set_head_visible("","YES")  
   INPUT g_giv00 WITHOUT DEFAULTS FROM giv00 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i933_set_entry(p_cmd)
         CALL i933_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD giv00 
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM aaa_file 
           WHERE aaa01 = g_giv00 AND 
                 aaaacti = 'Y'
         IF l_cnt = 0 THEN
            CALL cl_err('','agl-095',0)   
            NEXT FIELD giv00
         END IF
         
      ON ACTION controlp                 # 沿用所有欄位
         CASE
            WHEN INFIELD(giv00)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = g_giv00
               CALL cl_create_qry() RETURNING g_giv00
               DISPLAY BY NAME g_giv00
               NEXT FIELD giv00 
            OTHERWISE
               EXIT CASE
          END CASE
 
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
END FUNCTION

FUNCTION i933_giv01(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,         
   l_gir02    LIKE gir_file.gir02

   LET g_errno=''
   SELECT gir02,gir03,gir04,gir05 
     INTO g_gir[l_ac0].gir02,g_gir[l_ac0].gir03,g_gir[l_ac0].gir04,g_gir[l_ac0].gir05 
     FROM gir_file
     WHERE gir01=g_gir[l_ac0].giv01  
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-917'     
                                LET g_gir[l_ac0].gir02=NULL   
                                LET g_gir[l_ac0].gir03=NULL   
                                LET g_gir[l_ac0].gir04=NULL   
                                LET g_gir[l_ac0].gir05=NULL   
       WHEN g_gir[l_ac0].gir04='Y'   LET g_errno='agl1006'    

       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
END FUNCTION
#Query 查詢
FUNCTION i933_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_giv00 TO NULL  
   
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL i933_cs()                         #取得查詢條件
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i933_b_cs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                  #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_giv00 TO NULL   
      
   ELSE
      CALL i933_fetch('F')               #讀出TEMP第一筆並顯示
      OPEN i933_count
      FETCH i933_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
   END IF
END FUNCTION

#處理資料的讀取
FUNCTION i933_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        
   l_abso          LIKE type_file.num10                 #絕對的筆數        

   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i933_b_cs INTO g_giv00
       WHEN 'P' FETCH PREVIOUS i933_b_cs INTO g_giv00
       WHEN 'F' FETCH FIRST    i933_b_cs INTO g_giv00 
       WHEN 'L' FETCH LAST     i933_b_cs INTO g_giv00
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
            FETCH ABSOLUTE g_jump i933_b_cs INTO g_giv00
            LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_giv01,SQLCA.sqlcode,0)
      INITIALIZE g_giv01 TO NULL  
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
   END IF

   CALL i933_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION i933_show()
   DISPLAY g_giv00 TO giv00               #單頭 

   CALL i933_b_fill0(g_wc)  
    CALL cl_show_fld_cont()                  
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION i933_r()
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_giv01 IS NULL THEN
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       
       LET g_doc.column1 = "giv01"      
       LET g_doc.value1 = g_giv01       
       CALL cl_del_doc()                
      DELETE FROM giv_file WHERE giv00 = g_giv00  
                             AND giv01 = g_giv01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","giv_file",g_giv01,"",SQLCA.sqlcode,"","BODY DELETE:",1)  
      ELSE
         CLEAR FORM
         CALL g_giv.clear()
         LET g_giv00 = NULL   
         LET g_giv01 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         OPEN i933_count
         IF STATUS THEN
            CLOSE i933_b_cs
            CLOSE i933_count
            COMMIT WORK
            RETURN
         END IF
         FETCH i933_count INTO g_row_count
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i933_b_cs
            CLOSE i933_count
            COMMIT WORK
            RETURN
         END IF
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i933_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i933_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i933_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION

FUNCTION i933_b_fill0(p_wc)
DEFINE p_wc    LIKE type_file.chr1000
DEFINE l_cmd  LIKE type_file.chr1000

   LET g_sql = "SELECT DISTINCT giv01,gir02,gir03,gir04,gir05 ",
               " FROM gir_file,giv_file",
               " WHERE ", p_wc CLIPPED,                     #單身
               "   AND giv01 = gir01 ",
               "   AND giv00 = '",g_giv00,"'", 
               " ORDER BY giv01"
   PREPARE i933_pb FROM g_sql
   DECLARE gir_curs CURSOR FOR i933_pb

   CALL g_gir.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"

   FOREACH gir_curs INTO g_gir[g_cnt].*   #單身 ARRAY 填充
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

   CALL g_gir.deleteElement(g_cnt)
   LET g_rec_b0 = g_cnt - 1
   MESSAGE ""
END FUNCTION

#單身
FUNCTION i933_b()
DEFINE
   l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT       
   l_n             LIKE type_file.num5,     #檢查重複用      
   l_lock_sw       LIKE type_file.chr1,     #單身鎖住否       
   p_cmd           LIKE type_file.chr1,     #處理狀態         
   l_giv_delyn     LIKE type_file.chr1,     #判斷是否可以刪除單身資料ROW   
   l_chr           LIKE type_file.chr1,     
   l_allow_insert  LIKE type_file.num5,     #可新增否         
   l_allow_delete  LIKE type_file.num5      #可刪除否         
DEFINE l_ac0_t     LIKE type_file.num5      


   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF        #檢查權限
   IF g_giv00 IS NULL THEN   
       RETURN
   END IF

   CALL cl_opmsg('b')                #單身處理的操作提示

   LET g_forupd_sql = "SELECT giv02,'',giv03,giv04 FROM giv_file",
                      " WHERE giv00 = ? AND giv01=? AND giv02=? FOR UPDATE "  
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i933_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   LET g_forupd_sql = " SELECT giv01,gir02,gir03,gir04,gir05 ",
                      "   FROM giv_file,gir_file ",
                      "  WHERE giv01 = gir01 AND giv01 = ? AND giv00 = ? FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i933_bcl0 CURSOR FROM g_forupd_sql      # LOCK CURSOR

   DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT ARRAY g_gir FROM s_gir.*
      ATTRIBUTE (COUNT=g_rec_b0,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b0!=0 THEN
            CALL fgl_set_arr_curr(l_ac0)
         END IF
         CALL cl_set_comp_entry("gir02,gir03,gir04,gir05",FALSE)

      BEFORE ROW
         LET p_cmd=''
         LET l_ac0 = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b0 >= l_ac0 THEN
            LET p_cmd='u'
            LET g_gir_t.* = g_gir[l_ac0].*  #BACKUP
            OPEN i933_bcl0 USING g_gir_t.giv01,g_giv00                          
            IF STATUS THEN
               CALL cl_err("OPEN i933_bcl0:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i933_bcl0 INTO g_gir[l_ac0].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gir_t.giv01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gir[l_ac0].* TO NULL
         LET g_gir_t.* = g_gir[l_ac0].*
         CALL cl_show_fld_cont()     
         NEXT FIELD giv01

      AFTER INSERT
         IF INT_FLAG THEN                
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE i933_bcl0
         END IF
         INSERT INTO giv_file(giv00,giv01,giv02,giv03,giv04)
                       VALUES(g_giv00,g_gir[l_ac0].giv01,' ',' ',' ')                              
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","giv_file",g_gir[l_ac].giv01,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            LET g_rec_b0 = g_rec_b0 + 1 
         END IF

      BEFORE FIELD giv01
         IF NOT cl_null(g_gir[l_ac0].giv01) THEN
            CALL i933_b_fill(g_gir[l_ac0].giv01)
         ELSE
            CALL g_giv.clear()
         END IF

      AFTER FIELD giv01                        #check 編號是否重複
         IF g_gir[l_ac0].giv01 != g_gir_t.giv01 OR
            (g_gir[l_ac0].giv01 IS NOT NULL AND g_gir_t.giv01 IS NULL) THEN
            SELECT COUNT(*) INTO l_n FROM giv_file
             WHERE giv01 = g_gir[l_ac0].giv01
               AND giv00 = g_giv00
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_gir[l_ac0].giv01 = g_gir_t.giv01
               NEXT FIELD giv01
            END IF
            CALL i933_giv01('a')
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               LET g_gir[l_ac0].giv01 = g_gir_t.giv01
               NEXT FIELD giv01
            END IF
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_gir_t.giv01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM giv_file
             WHERE giv01 = g_gir_t.giv01
               AND giv00 = g_giv00
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","giv_file",g_gir_t.giv01,"",SQLCA.sqlcode,"","",1)
               CANCEL DELETE
            END IF
            LET g_rec_b0=g_rec_b0-1
         END IF

      ON ROW CHANGE
         IF g_gir_t.giv01 IS NOT NULL THEN
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_gir[l_ac0].giv01,-263,1)
               LET g_gir[l_ac0].* = g_gir_t.*
            ELSE
               UPDATE giv_file SET giv01 = g_gir[l_ac0].giv01
                WHERE giv00 = g_giv00
                  AND giv01 = g_gir_t.giv01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","giv_file",g_giv00,g_gir_t.giv01,SQLCA.sqlcode,"","",1)
                  LET g_gir[l_ac0].* = g_gir_t.*
               END IF
            END IF
         END IF

      AFTER ROW
         LET l_ac0 = ARR_CURR()
        #FUN-D30032--mark&add--str--
        #LET l_ac0_t = l_ac0
        #IF p_cmd = 'u' THEN
        #   CLOSE i933_bcl0
        #END IF
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gir[l_ac0].* = g_gir_t.*
            ELSE
               CALL g_gir.deleteElement(l_ac0)
               IF g_rec_b0 != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac0 = l_ac0_t
               END IF
            END IF
            CLOSE i933_bcl0 
            EXIT DIALOG
         END IF
         LET l_ac0_t = l_ac0
         CLOSE i933_bcl0
        #FUN-D30032--mark&add--end--

      ON ACTION CONTROLP
           IF INFIELD(giv01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gir2"  
              LET g_qryparam.default1 = g_gir[l_ac0].giv01
              CALL cl_create_qry() RETURNING g_gir[l_ac0].giv01
              NEXT FIELD giv01
           END IF

      #FUN-D30032--add--str--
      ON ACTION cancel
         LET INT_FLAG = 1
         IF p_cmd = 'a' THEN
            CALL g_gir.deleteElement(l_ac0)
            IF g_rec_b0 != 0 THEN
               LET g_action_choice = "detail"
               LET l_ac0 = l_ac0_t
            END IF
         END IF
         EXIT DIALOG
      #FUN-D30032--add--end--
   END INPUT

   INPUT ARRAY g_giv FROM s_giv.*                   
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE, 
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF cl_null(g_gir[l_ac0].giv01) THEN
            CONTINUE DIALOG
         ELSE
            LET g_giv01 = g_gir[l_ac0].giv01
         END IF
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
   
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'                   
            LET g_giv_t.* = g_giv[l_ac].*  #BACKUP
            OPEN i933_bcl USING g_giv00,g_giv01,g_giv_t.giv02
            IF STATUS THEN
               CALL cl_err("OPEN i933_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i933_bcl INTO g_giv_t.* 
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock giv',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     
         END IF
   
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_giv[l_ac].* TO NULL        
         INITIALIZE g_giv_t.* TO NULL  
         IF l_ac > 1 THEN
            LET g_giv[l_ac].giv03 = g_giv[l_ac-1].giv03
            LET g_giv[l_ac].giv04 = g_giv[l_ac-1].giv04
         END IF
         CALL cl_show_fld_cont()    
         NEXT FIELD giv02
   
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF l_ac = 1 THEN 
            UPDATE giv_file SET giv02 = g_giv[l_ac].giv02,giv03 = g_giv[l_ac].giv03,giv04 = g_giv[l_ac].giv04
             WHERE giv00 = g_giv00 AND giv01 = g_giv01 
         ELSE
            INSERT INTO giv_file (giv00,giv01,giv02,giv03,giv04)  
               VALUES(g_giv00,g_giv01,g_giv[l_ac].giv02,g_giv[l_ac].giv03,  
                      g_giv[l_ac].giv04)
         END IF 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","giv_file",g_giv01,g_giv[l_ac].giv02,SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
   
      AFTER FIELD giv02
         IF NOT cl_null(g_giv[l_ac].giv02) THEN
            CALL i933_giv()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD giv02
            END IF
         END IF
         IF g_giv[l_ac].giv02 != g_giv_t.giv02 OR cl_null(g_giv_t.giv02) THEN            
            SELECT COUNT(*) INTO l_n FROM giv_file
             WHERE giv02 = g_giv[l_ac].giv02 
            IF l_n > 0 THEN    #科目已存在其他群組中
               IF NOT cl_confirm('agl-919') THEN
                  NEXT FIELD giv02
               END IF
            END IF
            SELECT COUNT(*) INTO l_n FROM giv_file 
             WHERE giv01 = g_giv01 AND giv02 = g_giv[l_ac].giv02
               AND giv00 = g_giv00 
            IF l_n <> 0 THEN
               LET g_giv[l_ac].giv02 = g_giv_t.giv02
               CALL cl_err('','-239',0) 
               NEXT FIELD giv02
            END IF
         END IF
   
      AFTER FIELD giv03
         IF NOT cl_null(g_giv[l_ac].giv03) THEN
            IF g_giv[l_ac].giv03 NOT MATCHES '[-+]' THEN 
               NEXT FIELD giv03 
            END IF
         END IF
   
      AFTER FIELD giv04
         IF NOT cl_null(g_giv[l_ac].giv04) THEN
            IF g_giv[l_ac].giv04 NOT MATCHES '[123456]' THEN
               NEXT FIELD giv04
            END IF 
         END IF
   
      BEFORE DELETE                                  
         #判斷是否可以刪除此ROW,因為此ROW可能和其它file有key值的關聯性,
         #所以不能隨便亂刪掉
         CALL i933_giv_delyn() RETURNING l_giv_delyn 
         IF g_giv_t.giv02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN   #詢問是否確定
               CANCEL DELETE
            END IF
            IF l_giv_delyn = 'N ' THEN   #為不可刪除此ROW的狀態下
               #人工輸入金額設定作業中此ROW已被使用,不可刪除!!
               CALL cl_err(g_giv_t.giv02,'agl-918',0) 
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM giv_file WHERE giv00 = g_giv00  
                                   AND giv01 = g_giv01 AND giv02 = g_giv_t.giv02 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","giv_file",g_giv01,g_giv_t.giv02,SQLCA.sqlcode,"","",1) 
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
   
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_giv[l_ac].* = g_giv_t.*
            CLOSE i933_bcl
            EXIT DIALOG   
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_giv[l_ac].giv02,-263,1)
            LET g_giv[l_ac].* = g_giv_t.*
         ELSE
            UPDATE giv_file SET giv02 = g_giv[l_ac].giv02,
                                giv03 = g_giv[l_ac].giv03,
                                giv04 = g_giv[l_ac].giv04 
             WHERE giv00=g_giv00  
               AND giv01=g_giv01 AND giv02=g_giv_t.giv02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","giv_file",g_giv01,g_giv_t.giv02,SQLCA.sqlcode,"","",1)  
               LET g_giv[l_ac].* = g_giv_t.*
            END IF
         END IF
   
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac   #FUN-D30032 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_giv[l_ac].* = g_giv_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_giv.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i933_bcl
            EXIT DIALOG    
         END IF
         LET l_ac_t = l_ac    #FUN-D30032 Add 
         CLOSE i933_bcl
   
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(giv02) AND l_ac > 1 THEN
            LET g_giv[l_ac].* = g_giv[l_ac-1].*
            NEXT FIELD giv02
         END IF
   
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
   
      #TQC-C30136--mark--str--
      #ON ACTION CONTROLG
      #   CALL cl_cmdask()
      #TQC-C30136--mark--end--
   
      ON ACTION controlp
         CASE
            WHEN INFIELD(giv02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_giv[l_ac].giv02
               LET g_qryparam.arg1 = g_giv00      
               #LET g_qryparam.where = "aag07 != '1'"      #TQC-C50230   mark
               CALL cl_create_qry() RETURNING g_giv[l_ac].giv02
               DISPLAY BY NAME g_giv[l_ac].giv02       
               CALL i933_giv()
               NEXT FIELD giv02
            OTHERWISE
               EXIT CASE
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()         
         CONTINUE DIALOG 
         
      #TQC-C30136--mark--str--
      #ON ACTION about         
      #   CALL cl_about()      
      # 
      #ON ACTION help         
      #   CALL cl_show_help() 
      #TQC-C30136--mark--end--
         
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
   
      #FUN-D30032--add--str--
      ON ACTION cancel
         LET INT_FLAG = 1
         IF p_cmd = 'a' THEN
            CALL g_giv.deleteElement(l_ac)
            IF g_rec_b != 0 THEN
               LET g_action_choice = "detail"
               LET l_ac = l_ac_t
            END IF
         END IF
         EXIT DIALOG 
      #FUN-D30032--add--end--

   END INPUT
   
   BEFORE DIALOG
      CALL cl_set_act_visible("close,append", FALSE)
      BEGIN WORK

   ON ACTION accept
      ACCEPT DIALOG

  #FUN-D30032--mark--str--
  #ON ACTION cancel
  #   LET INT_FLAG = 1
  #   EXIT DIALOG
  #FUN-D30032--mark--end-- 

   ON ACTION CONTROLG
      CALL cl_cmdask()

   ON ACTION about
      CALL cl_about()

   ON ACTION help
      CALL cl_show_help()

   END DIALOG

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE i933_bcl
      ROLLBACK WORK
      RETURN
   END IF
   
   CLOSE i933_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i933_giv()
DEFINE 
   l_givacti    LIKE aag_file.aagacti     

   LET g_errno = ' '
   SELECT aag02,aagacti INTO g_giv[l_ac].aag02,l_givacti FROM aag_file
    WHERE aag01 = g_giv[l_ac].giv02 
    AND aag00 = g_giv00               
   CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-001'
        WHEN l_givacti = 'N'     LEt g_errno = '9028'
        OTHERWISE
   END CASE
END FUNCTION

FUNCTION i933_giv_delyn()
DEFINE 
   l_delyn       LIKE type_file.chr1,      #存放可否刪除的變數 
   l_n           LIKE type_file.num5         
   
   LET l_delyn = 'Y'

   SELECT COUNT(*)  INTO l_n FROM git_file 
    WHERE git01 = g_giv01
      AND git02 = g_giv[l_ac].giv02 
      AND giv00 = g_giv00 
   IF l_n > 0 THEN 
      LET l_delyn = 'N'
   END IF
   RETURN l_delyn
END FUNCTION

FUNCTION i933_b_askkey()
   CLEAR FORM
   CALL g_giv.clear()
   CONSTRUCT g_wc2 ON giv00,giv01,giv02,giv03,giv04 
        FROM giv00,giv01,s_giv[1].giv02,s_giv[1].giv03,s_giv[1].giv04 
              
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
   CALL i933_b_fill(g_wc2)
END FUNCTION
   
FUNCTION i933_b_fill(p_giv01)  
DEFINE p_giv01     LIKE giv_file.giv01 
DEFINE
   p_wc            STRING,             
   l_flag          LIKE type_file.chr1,              #有無單身筆數       
   l_sql           STRING        
 
   LET l_sql = "SELECT giv02,aag02,giv03,giv04 ",
               "  FROM giv_file,OUTER aag_file",
               " WHERE giv01 = '",p_giv01,"'",  
               "   AND giv00 = '",g_giv00,"'",  
               "   AND giv00 = aag00 ",          
               "   AND giv02 = aag01 ",                 
               " ORDER BY giv02"

   PREPARE giv_pre FROM l_sql
   DECLARE giv_cs CURSOR FOR giv_pre

   CALL g_giv.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH giv_cs INTO g_giv[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_flag='Y'
      LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
   END FOREACH
   CALL g_giv.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF l_flag='N' THEN LET g_rec_b=0 END IF     #無單身時將筆數清為零
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0 
END FUNCTION

FUNCTION i933_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_gir TO s_gir.* ATTRIBUTE(COUNT=g_rec_b0)
      
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         
      BEFORE ROW
         LET l_ac0 = ARR_CURR()
         CALL cl_show_fld_cont()                   
         IF l_ac0 > 0 THEN
            CALL i933_b_fill(g_gir[l_ac0].giv01)
         END IF
      END DISPLAY
     
      DISPLAY ARRAY g_giv TO s_giv.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      END DISPLAY   

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG    
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG    
         
      ON ACTION first 
         CALL i933_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF      
         ACCEPT DIALOG  

      ON ACTION previous
         CALL i933_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF              
         ACCEPT DIALOG   

      ON ACTION jump
         CALL i933_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF            
         ACCEPT DIALOG              

      ON ACTION next
         CALL i933_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DIALOG                       

      ON ACTION last
         CALL i933_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DIALOG                

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG  
         
      ON ACTION output
         LET g_action_choice="output"
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
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################

      #FUN-D30032--add--str--
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DIALOG
      #FUN-D30032--add--end--

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG   
         
      ON ACTION related_document         
         LET g_action_choice="related_document"
         EXIT DIALOG   
         
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG   
         
      ON ACTION ACCEPT
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
         
      AFTER DIALOG         
         CONTINUE DIALOG   
         
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")  
         
   END DIALOG   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i933_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1         

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("giv00,giv01",TRUE)  
    END IF 

END FUNCTION

FUNCTION i933_set_no_entry(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1           

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("giv00,giv01",FALSE) 
   END IF 

END FUNCTION

FUNCTION i933_out()
   DEFINE l_cmd  STRING                                                                       
   IF cl_null(g_wc) AND NOT cl_null(g_giv00) AND NOT cl_null(g_giv01) THEN      
      LET g_wc=" giv00='",g_giv00,"' AND giv01='",g_giv01,"'"
   END IF                                                                                                                         
   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF                                                                    
   LET l_cmd = 'p_query "ggli933" "',g_wc CLIPPED,'"'                                                                             
   CALL cl_cmdrun(l_cmd)                                                                                                          
   RETURN                                                                                                                         
END FUNCTION
#FUN-B60083
