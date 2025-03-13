# Prog. Version..: '5.30.06-13.04.22(00006)'     #
# Pattern name...: agli933.4gl
# Descriptions...: 現金流量表活動科目設定 
# Date & Author..: FUN-930155 09/04/23 BY yiting
# Modify.........: FUN-B50001 11/05/09 By wuxj   群组代码改为单身维护
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60063 11/06/14 By yinhy 修改單身gin01群組編號開窗
# Modify.........: NO.MOD-B60186 By Polly 修正「查詢」科目編號開窗後，按確認或放棄，程式會被關掉
# Modify.........: No.TQC-C30136 12/03/08 By fengrui 處理ON ACITON衝突問題
# Modify.........: No:FUN-D30033 13/04/12 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE   #FUN-930155
    g_gin00         LIKE gin_file.gin00,   #No.FUN-740020
    g_gin01         LIKE gin_file.gin01,   #活動類別(假單頭)
    g_gin00_t       LIKE gin_file.gin00,   #活動類別(舊值)  #No.FUN-740020
    g_gin01_t       LIKE gin_file.gin01,   #活動類別(舊值)
#---> by FUN-B50001 101220  begin 
    g_gin05        LIKE gin_file.gin05,      
    g_gin05_t      LIKE gin_file.gin05,     
    g_gin06        LIKE gin_file.gin06,    
    g_gin06_t      LIKE gin_file.gin06,   
    g_axz05        LIKE axz_file.axz05,
#---> by FUN-B50001 101220  end 
#---> by FUN-B50001 101109  begin  add
    g_gir           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
       gin01           LIKE gin_file.gin01,   #群組代碼
       gir02           LIKE gir_file.gir02,   #說明
       gir03           LIKE gir_file.gir03,   #變動分類
       gir04           LIKE gir_file.gir04,   #合併否
       gir05           LIKE gir_file.gir05    #行次 #FUN-640004
                    END RECORD,
    g_gir_t         RECORD                 #程式變數 (舊值)
       gin01           LIKE gin_file.gin01,   #群組代碼
       gir02           LIKE gir_file.gir02,   #說明
       gir03           LIKE gir_file.gir03,   #變動分類
       gir04           LIKE gir_file.gir04,   #合併否
       gir05           LIKE gir_file.gir05    #行次 #FUN-640004
                    END RECORD,
#---> by FUN-B50001 101109  end
    g_gin           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gin02       LIKE gin_file.gin02,   #科目編號
        aag02       LIKE aag_file.aag02,   #科目名稱
        gin03       LIKE gin_file.gin03,   #加減項
        gin04       LIKE gin_file.gin04    #異動別
                    END RECORD,
    g_gin_t         RECORD                 #程式變數 (舊值)
        gin02       LIKE gin_file.gin02,   #科目編號
        aag02       LIKE aag_file.aag02,   #科目名稱
        gin03       LIKE gin_file.gin03,   #加減項
        gin04       LIKE gin_file.gin04    #異動別
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,        #TQC-630166     
    g_sql_tmp           STRING,        #No.FUN-740020
    g_rec_b         LIKE type_file.num5,    #單身筆數               #No.FUN-680098 SMALLINT
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT    #No.FUN-680098 SMALLINT
DEFINE g_str        STRING     #No.FUN-830113 
DEFINE g_dbs_axz03         LIKE type_file.chr21     #FUN-B50001 add 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL       
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680098 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680098 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680098   INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680098   INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680098   INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680098   SMALLINT
DEFINE l_ac0        LIKE type_file.num5  #by FUN-B50001 101109  add
DEFINE g_rec_b0     LIKE type_file.num5  #by FUN-B50001 101109  add
DEFINE g_flag_b     LIKE type_file.chr1  #FUN-D30033 add
MAIN
DEFINE
   p_row,p_col     LIKE type_file.num5                 #開窗的位置        #No.FUN-680098 SMALLINT

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


   LET p_row = ARG_VAL(2)     #No:MOD-4C0171                 #取得螢幕位置
   LET p_col = ARG_VAL(3)     #No:MOD-4C0171
   LET g_gin01      = NULL                #清除鍵值
   LET g_gin01_t    = NULL
   LET g_gin00      = NULL                #清除鍵值
   LET g_gin00_t    = NULL
#---> by FUN-B50001 101220  begin 
   LET g_gin05   = NULL 
   LET g_gin05_t = NULL
   LET g_gin06   = NULL  
   LET g_gin06_t = NULL
#---> by wuxn 101202  end 
   LET p_row = 3 LET p_col = 14
       
   OPEN WINDOW i933_w AT p_row,p_col      #顯示畫面
     WITH FORM "agl/42f/agli933"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
    CALL cl_ui_init()

   CALL i933_menu()
   CLOSE WINDOW i933_w                    #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

#QBE 查詢資料
FUNCTION i933_cs()
   CLEAR FORM                                   #清除畫面
      CALL g_gin.clear()
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0029 

   INITIALIZE g_gin00 TO NULL    #No.FUN-750051
   INITIALIZE g_gin01 TO NULL    #No.FUN-750051
#---> by FUN-B50001 101220  begin 
   INITIALIZE g_gin05 TO NULL
   INITIALIZE g_gin06 TO NULL
#---> by FUN-B50001 101220  end 

   CONSTRUCT g_wc ON gin05,gin06,gin00,gin01,gin02,gin03,gin04  #by FUN-B50001 101220 add     #螢幕上取條件   # No:FUN-740020
      # FROM gin00,gin01,s_gin[1].gin02,s_gin[1].gin03,s_gin[1].gin04
        FROM gin05,gin06,gin00,s_gir[1].gin01,s_gin[1].gin02,s_gin[1].gin03,s_gin[1].gin04  #FUN-B50001 101109 add

              #No:FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No:FUN-580031 --end--       HCN
      ON ACTION controlp                 # 沿用所有欄位
         CASE
          #No.FUN-740020  --Begin                                                                                                   
          WHEN INFIELD(gin00)                                                                                                       
             CALL cl_init_qry_var()                                                                                                 
             LET g_qryparam.state = "c"                                                                                             
             LET g_qryparam.form ="q_aaa"                                                                                           
             CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                     
             DISPLAY g_qryparam.multiret TO gin00                                                                                   
             NEXT FIELD gin00                                                                                                       
          #No.FUN-740020  --End 
            WHEN INFIELD(gin01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               #LET g_qryparam.form ="q_gir"   #No.TQC-B60063
               LET g_qryparam.form ="q_gir1"   #No.TQC-B60063
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gin01
               NEXT FIELD gin01 
            WHEN INFIELD(gin02)
              #CALL cl_init_qry_var()                                    #No.MOD-B60186 mark
              #LET g_qryparam.state = "c"                                #No.MOD-B60186 mark
              #LET g_qryparam.form ="q_aag"                              #No.MOD-B60186 mark
              #CALL cl_create_qry() RETURNING g_qryparam.multiret        #No.MOD-B60186 mark
               CALL q_m_aag2(TRUE,TRUE,'',g_gin[1].gin02,'23',g_gin00)   #No.MOD-B60186 add
                    RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gin02
              #CALL i933_gin()                                           #No.MOD-B60186 mark
               NEXT FIELD gin02
#---> by FUN-B50001 101220   begin 
              WHEN INFIELD(gin05) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_axa1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO gin05
                 NEXT FIELD gin05
              WHEN INFIELD(gin06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_axz"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO gin06
                 NEXT FIELD gin06
#--> by FUN-B50001 101220  end 
            OTHERWISE
               EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
		#No:FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No:FUN-580031 --end--       HCN
   END CONSTRUCT

   IF INT_FLAG THEN RETURN END IF
   LET g_sql="SELECT UNIQUE gin00,gin05,gin06 FROM gin_file ", #by FUN-B50001 mark gin01 # 組合出SQL 指令,看gin01有幾種就run幾次 #No.FUN-740020
             " WHERE ", g_wc CLIPPED,
             " ORDER BY 1"
   PREPARE i933_prepare FROM g_sql              #預備一下
   DECLARE i933_b_cs                            #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i933_prepare
                                                #計算本次查詢單頭的筆數
   LET g_sql_tmp= "SELECT UNIQUE gin00,gin05,gin06 FROM gin_file ",         #by FUN-B50001 mark gin01                                                  
                  " WHERE ",g_wc CLIPPED,                                                                                           
                  "   INTO TEMP x"                                                                                                  
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
          WHEN "related_document"  #No:MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_gin00 IS NULL OR g_gin01 IS NOT NULL THEN  #No.FUN-740020
                  LET g_doc.column1 = "gin01"
                  LET g_doc.value1 = g_gin01
#by FUN-B50001 101220   begin 
                  LET g_doc.column2 = "gin05"
                  LET g_doc.value2 = g_gin05
                  LET g_doc.column3 = "gin06"
                  LET g_doc.value3 = g_gin06
                  LET g_doc.column4 = "gin00"
                  LET g_doc.value4 = g_gin00
#by FUN-B50001 101220   end
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No:FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gin),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

#Add  輸入
FUNCTION i933_a()
DEFINE   l_n    LIKE type_file.num5          #No.FUN-680098 SMALLINT
   
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
      CALL g_gin.clear()
#  INITIALIZE g_gin01 LIKE gin_file.gin01     #by FUN-B50001 mark
#  LET g_gin01_t = NULL                       #by FUN-B50001 mark
   #No.FUN-740020  --Begin
   INITIALIZE g_gin00 LIKE gin_file.gin00
   LET g_gin00_t = NULL
   #No.FUN-740020  --End
#by FUN-B50001 101220  begin 
   INITIALIZE g_gin05 LIKE gin_file.gin05      #DEFAULT 設定
   INITIALIZE g_gin06 LIKE gin_file.gin06      #DEFAULT 設定
   LET g_gin05_t = NULL
   LET g_gin06_t = NULL
#by FUN-B50001 101220  end 
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i933_i("a")                           #輸入單頭
      IF INT_FLAG THEN                           #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_gin.clear()
#---> by FUN-B50001 101109   begin 
#     SELECT COUNT(*) INTO l_n FROM gin_file WHERE gin01=g_gin01
#                                              AND gin00=g_gin00 #No.FUN-740020
      LET g_rec_b = 0                    #No.FUN-680064
      LET g_rec_b0 = 0
#     IF l_n > 0 THEN
#        CALL i933_b_fill('1=1')
#     END IF
      CALL g_gir.clear()
#---> by FUN-B50001 101109  end 
      CALL i933_b()                             #輸入單身
      LET g_gin00_t = g_gin00                   #保留舊值 #No.FUN-740020
   #  LET g_gin01_t = g_gin01   #FUN-B50001 mark      #保留舊值
#---> by FUN-B50001 101220  begin 
      LET g_gin05_t = g_gin05                   #保留舊值
      LET g_gin06_t = g_gin06                   #保留舊值
#---> by FUN-B50001 101220  end 
      EXIT WHILE
   END WHILE
END FUNCTION

#處理INPUT
FUNCTION i933_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改        #No.FUN-680098 VARCHAR(1)
   l_cnt           LIKE type_file.num5          #MOD-840537
  ,l_n1,l_n        LIKE type_file.num5          #FUN-B50001 101220 add 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0029 

 # INPUT g_gin00,g_gin01 WITHOUT DEFAULTS FROM gin00,gin01     #No.FUN-740020
   INPUT g_gin05,g_gin06,g_gin00 WITHOUT DEFAULTS FROM gin05,gin06,gin00 #by FUN-B50001 101109 add  
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i933_set_entry(p_cmd)
         CALL i933_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      #-----MOD-840537---------
      AFTER FIELD gin00 
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM aaa_file 
           WHERE aaa01 = g_gin00 AND 
                 aaaacti = 'Y'
         IF l_cnt = 0 THEN
            CALL cl_err('','agl-095',0)   
            NEXT FIELD gin00
         END IF
      #-----END MOD-840537-----
#---> by FUN-B50001 101109  begin  mark 
#     AFTER FIELD gin01                  #設定活動類別
#        IF NOT cl_null(g_gin01) THEN
#           CALL i933_gin01('a')
#           IF NOT cl_null(g_errno) THEN
#              CALL cl_err('',g_errno,0)   #MOD-840537
#              NEXT FIELD gin01
#           END IF
#        END IF
#---> by FUN-B50001  101109 end 

#---> by FUN-B50001 101220  begin 
      AFTER FIELD gin05   #族群代號
         IF cl_null(g_gin05) THEN
            CALL cl_err(g_gin05,'mfg0037',0)
            NEXT FIELD gin05
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axa_file
             WHERE axa01=g_gin05
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err(g_gin05,'agl-223',0)
               NEXT FIELD gin05
            END IF
         END IF

      AFTER FIELD gin06
         IF NOT cl_null(g_gin06) THEN
               CALL i933_gin06('a',g_gin06,g_gin05)                                      
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_gin06,g_errno,0)
                  NEXT FIELD gin06
               END IF
            IF g_gin05 IS NOT NULL AND g_gin06 IS NOT NULL AND
               g_gin00 IS NOT NULL THEN
               LET l_n = 0   LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM axa_file
                WHERE axa01=g_gin05 AND axa02=g_gin06
                  AND axa03=g_axz05
               SELECT COUNT(*) INTO l_n1 FROM axb_file
                WHERE axb01=g_gin05 AND axb04=g_gin06
                  AND axb05=g_axz05
               IF l_n+l_n1 = 0 THEN
                  CALL cl_err(g_gin06,'agl-223',0)
                  LET g_gin05 = g_gin05_t
                  LET g_gin06 = g_gin06_t
                  LET g_gin00 = g_gin00_t
                  DISPLAY BY NAME g_gin05,g_gin06,g_gin00
                  NEXT FIELD gin06
               END IF
            END IF
         END IF
#by FUN-B50001 101220   end 

      ON ACTION controlp                 # 沿用所有欄位
         CASE
          #No.FUN-740020  --Begin
            WHEN INFIELD(gin00)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = g_gin00
               CALL cl_create_qry() RETURNING g_gin00
               DISPLAY BY NAME g_gin00
               NEXT FIELD gin00 
          #No.FUN-740020  --End 
#---> by FUN-B50001 101109  begin  mark 
#           WHEN INFIELD(gin01)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_gir"
#              LET g_qryparam.default1 = g_gin01
#              CALL cl_create_qry() RETURNING g_gin01
#               CALL FGL_DIALOG_SETBUFFER( g_gin01 )
#              DISPLAY BY NAME g_gin01
#              NEXT FIELD gin01 
#---> by FUN-B50001 101109  end 

#by FUN-B50001 101220   begin 
            WHEN INFIELD(gin05) #族群編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.default1 = g_gin05
               CALL cl_create_qry() RETURNING g_gin05
               DISPLAY g_gin05 TO gin05
               NEXT FIELD gin05
            WHEN INFIELD(gin06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"
               LET g_qryparam.default1 = g_gin06
               CALL cl_create_qry() RETURNING g_gin06
               DISPLAY g_gin06 TO gin06
               NEXT FIELD gin06
#by FUN-B50001 101220  end 
            OTHERWISE
               EXIT CASE
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
END FUNCTION

FUNCTION i933_gin01(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
   l_gir02    LIKE gir_file.gir02

   LET g_errno=''
   SELECT gir02,gir03,gir04,gir05 INTO g_gir[l_ac0].gir02,g_gir[l_ac0].gir03,g_gir[l_ac0].gir04,g_gir[l_ac0].gir05 #by FUN-B50001
     FROM gir_file
   # WHERE gir01=g_gin01
     WHERE gir01=g_gir[l_ac0].gin01  #by FUN-B50001 add 
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-917'
                              # LET l_gir02=NULL              #FUN-B50001 
                                LET g_gir[l_ac0].gir02=NULL   #FUN-B50001
                                LET g_gir[l_ac0].gir03=NULL   #FUN-B50001
                                LET g_gir[l_ac0].gir04=NULL   #FUN-B50001
                                LET g_gir[l_ac0].gir05=NULL   #FUN-B50001
       WHEN g_gir[l_ac0].gir04='N'   LET g_errno='agl1005'    #TQC-B60063

       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
#---> by FUN-B50001 101109 begin  mark
#  IF p_cmd='d' OR cl_null(g_errno)THEN
#
#    DISPLAY l_gir02 TO FORMONLY.gir02 
#  END IF
#---> by FUN-B50001 101109 end 
END FUNCTION
#Query 查詢
FUNCTION i933_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
  #INITIALIZE g_gin00,g_gin01 TO NULL    #No.FUN-6B0040  #No.FUN-740020
   INITIALIZE g_gin00 TO NULL   #FUN-B50001 
   INITIALIZE g_gin05 TO NULL   #FUN-B50001
   INITIALIZE g_gin06 TO NULL   #FUN-B50001
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
     #INITIALIZE g_gin00,g_gin01 TO NULL  #No.FUN-740020
      INITIALIZE g_gin00 TO NULL   #FUN-B50001
      INITIALIZE g_gin05 TO NULL   #FUN-B50001
      INITIALIZE g_gin06 TO NULL   #FUN-B50001 
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
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680098 INTEGER

   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i933_b_cs INTO g_gin00,g_gin05,g_gin06#,g_gin01   #by FUN-B50001 101109 mark g_gin01,add gin05,06 
       WHEN 'P' FETCH PREVIOUS i933_b_cs INTO g_gin00,g_gin05,g_gin06#,g_gin01   #by FUN-B50001 101109 mark g_gin01,add gin05,06
       WHEN 'F' FETCH FIRST    i933_b_cs INTO g_gin00,g_gin05,g_gin06#,g_gin01   #by FUN-B50001 101109 mark g_gin01,add gin05,06 
       WHEN 'L' FETCH LAST     i933_b_cs INTO g_gin00,g_gin05,g_gin06#,g_gin01   #by FUN-B50001 101109 mark g_gin01,add gin05,06
       WHEN '/' 
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i933_b_cs INTO g_gin00,g_gin05,g_gin06  #by FUN-B50001 101109 mark g_gin01,add gin05,06
            LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_gin01,SQLCA.sqlcode,0)
      INITIALIZE g_gin01 TO NULL  #TQC-6B0105
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
   DISPLAY g_gin00 TO gin00               #單頭 #No.FUN-740020
   DISPLAY g_gin05 TO gin05 #FUN-B50001 
   DISPLAY g_gin06 TO gin06 #FUN-B50001 
   CALL i933_gin06('d',g_gin06,g_gin05) #FUN-B50001  
#  DISPLAY g_gin01 TO gin01 #FUN-B50001         #單頭
#  CALL i933_gin01('d')     #FUN-B50001
#  CALL i933_b_fill(g_wc)   #FUN-B50001         #單身
   CALL i933_b_fill0(g_wc)  #FUN-B50001 
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION i933_r()
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_gin01 IS NULL THEN
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "gin01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_gin01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM gin_file WHERE gin00 = g_gin00  #No.FUN-740020
                             AND gin01 = g_gin01
                             AND gin05 = g_gin05  #by FUN-B50001 101220 add 
                             AND gin06 = g_gin06  #by FUN-B50001 101220 add 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gin_file",g_gin01,"",SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660123 #No.FUN-740020
      ELSE
         CLEAR FORM
         CALL g_gin.clear()
         LET g_gin00 = NULL   #No.FUN-740020
         LET g_gin01 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         OPEN i933_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i933_b_cs
            CLOSE i933_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i933_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i933_b_cs
            CLOSE i933_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end-- 
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

#---> by FUN-B50001 101109  begin
FUNCTION i933_b_fill0(p_wc)
DEFINE p_wc    LIKE type_file.chr1000
DEFINE l_cmd  LIKE type_file.chr1000

   LET g_sql = "SELECT DISTINCT gin01,gir02,gir03,gir04,gir05 ",
               " FROM gir_file,gin_file",
               " WHERE ", p_wc CLIPPED,                     #單身
               "   AND gin01 = gir01 ",
               "   AND gin00 = '",g_gin00,"' AND gin05='",g_gin05,"' AND gin06='",g_gin06,"'", 
               " ORDER BY gin01"
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
#---> by FUN-B50001 101109   end
#單身
FUNCTION i933_b()
DEFINE
   l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT        #No.FUN-680098 SMALLINT
   l_n             LIKE type_file.num5,     #檢查重複用       #No.FUN-680098 SMALLINT
   l_lock_sw       LIKE type_file.chr1,     #單身鎖住否       #No.FUN-680098 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,     #處理狀態         #No.FUN-680098 VARCHAR(1)
   l_gin_delyn     LIKE type_file.chr1,     #判斷是否可以刪除單身資料ROW   #No.FUN-680098  VARCHAR(1)
   l_chr           LIKE type_file.chr1,     #No.FUN-680098    VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,     #可新增否         #No.FUN-680098 SMALLINT
   l_allow_delete  LIKE type_file.num5      #可刪除否         #No.FUN-680098 SMALLINT
DEFINE l_ac0_t     LIKE type_file.num5      #FUN-B50001


   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF        #檢查權限
#  IF g_gin00 IS NULL OR g_gin01 IS NULL THEN  #No.FUN-740020
   IF g_gin00 IS NULL THEN  #FUN-B50001 
       RETURN
   END IF

   CALL cl_opmsg('b')                #單身處理的操作提示

   LET g_forupd_sql = "SELECT gin02,'',gin03,gin04 FROM gin_file",
                      " WHERE gin00 = ? AND gin01=? AND gin02=? AND gin05=? AND gin06=? FOR UPDATE "  #No.FUN-740020#FUN-B50001 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i933_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

#---> by FUN-B50001 101109   begin
   LET g_forupd_sql = " SELECT gin01,gir02,gir03,gir04,gir05 ",
                      "   FROM gin_file,gir_file ",
                      "  WHERE gin01 = gir01 AND gin01 = ? AND gin00 = ? AND gin05=? AND gin06=? FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i933_bcl0 CURSOR FROM g_forupd_sql      # LOCK CURSOR
   
   IF g_rec_b0 > 0 THEN LET l_ac0 = 1 END IF  #FUN-D30033 add
   IF g_rec_b> 0 THEN LET l_ac = 1 END IF  #FUN-D30033 add
   
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
         LET g_flag_b = '1' #FUN-D30033 add

      BEFORE ROW
         LET p_cmd=''
         LET l_ac0 = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b0 >= l_ac0 THEN
            LET p_cmd='u'
            LET g_gir_t.* = g_gir[l_ac0].*  #BACKUP
            OPEN i933_bcl0 USING g_gir_t.gin01,g_gin00,g_gin05,g_gin06                           
            IF STATUS THEN
               CALL cl_err("OPEN i933_bcl0:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i933_bcl0 INTO g_gir[l_ac0].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gir_t.gin01,SQLCA.sqlcode,1)
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
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gin01

      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE i933_bcl0
         END IF
         INSERT INTO gin_file(gin00,gin01,gin02,gin05,gin06)
                       VALUES(g_gin00,g_gir[l_ac0].gin01,' ',g_gin05,g_gin06)                              
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gin_file",g_gir[l_ac].gin01,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b0 = g_rec_b0 + 1 
         END IF

      BEFORE FIELD gin01
         IF NOT cl_null(g_gir[l_ac0].gin01) THEN
       #    LET g_gir_t.gin01 = g_gir[l_ac0].gin01
            CALL i933_b_fill(g_gir[l_ac0].gin01)
         ELSE
            CALL g_gin.clear()
         END IF

      AFTER FIELD gin01                        #check 編號是否重複
         IF g_gir[l_ac0].gin01 != g_gir_t.gin01 OR
            (g_gir[l_ac0].gin01 IS NOT NULL AND g_gir_t.gin01 IS NULL) THEN
            SELECT count(*) INTO l_n FROM gin_file
             WHERE gin01 = g_gir[l_ac0].gin01
               AND gin00 = g_gin00
               AND gin05 = g_gin05
               AND gin06 = g_gin06
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_gir[l_ac0].gin01 = g_gir_t.gin01
               NEXT FIELD gin01
            END IF
            CALL i933_gin01('a')
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               LET g_gir[l_ac0].gin01 = g_gir_t.gin01
               NEXT FIELD gin01
            END IF
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_gir_t.gin01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM gin_file
             WHERE gin01 = g_gir_t.gin01
               AND gin00 = g_gin00
               AND gin05 = g_gin05
               AND gin06 = g_gin06
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gin_file",g_gir_t.gin01,"",SQLCA.sqlcode,"","",1)
               CANCEL DELETE
            END IF
            LET g_rec_b0=g_rec_b0-1
         END IF

      ON ROW CHANGE
         IF g_gir_t.gin01 IS NOT NULL THEN
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_gir[l_ac0].gin01,-263,1)
               LET g_gir[l_ac0].* = g_gir_t.*
            ELSE
               UPDATE gin_file SET gin01 = g_gir[l_ac0].gin01
                WHERE gin00 = g_gin00
                  AND gin05 = g_gin05
                  AND gin06 = g_gin06
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","gin_file",g_gin00,g_gir_t.gin01,SQLCA.sqlcode,"","",1)
                  LET g_gir[l_ac0].* = g_gir_t.*
               ELSE
                  CALL cl_msg('UPDATE O.K')
               END IF
            END IF
         END IF

      AFTER ROW
         LET l_ac0 = ARR_CURR()
         LET l_ac0_t = l_ac0
         IF p_cmd = 'u' THEN 
            CLOSE i933_bcl0
         END IF             

      ON ACTION CONTROLP
           IF INFIELD(gin01) THEN
              CALL cl_init_qry_var()
              #LET g_qryparam.form ="q_gir"  #No.TQC-B60063
              LET g_qryparam.form ="q_gir1"  #No.TQC-B60063
              LET g_qryparam.default1 = g_gir[l_ac0].gin01
              CALL cl_create_qry() RETURNING g_gir[l_ac0].gin01
              NEXT FIELD gin01
           END IF
     
   END INPUT
#by FUN-B50001 101109   end

 # INPUT ARRAY g_gin WITHOUT DEFAULTS FROM s_gin.*
   INPUT ARRAY g_gin FROM s_gin.*                   #FUN-B50001 
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE, #FUN-B50001 
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)

      BEFORE INPUT
#---> by FUN-B50001 101109   begin
         IF cl_null(g_gir[l_ac0].gin01) THEN
            CONTINUE DIALOG
         ELSE
            LET g_gin01 = g_gir[l_ac0].gin01
         END IF
#--- by FUN-B50001 101109    end
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_flag_b = '2' #FUN-D30033 add
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'                   
            LET g_gin_t.* = g_gin[l_ac].*  #BACKUP
          # BEGIN WORK   #FUN-B50001 mark 
            OPEN i933_bcl USING g_gin00,g_gin01,g_gin_t.gin02,g_gin05,g_gin06 #FUN-B50001      #No.MOD-740269
            IF STATUS THEN
               CALL cl_err("OPEN i933_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i933_bcl INTO g_gin_t.* 
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock gin',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
   
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gin[l_ac].* TO NULL         #900423
         INITIALIZE g_gin_t.* TO NULL  
         IF l_ac > 1 THEN
            LET g_gin[l_ac].gin03 = g_gin[l_ac-1].gin03
            LET g_gin[l_ac].gin04 = g_gin[l_ac-1].gin04
         END IF
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gin02
   
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
#---> By FUN-B50001 101109  begin 
         IF l_ac = 1 THEN 
            UPDATE gin_file SET gin02 = g_gin[l_ac].gin02,gin03 = g_gin[l_ac].gin03,gin04 = g_gin[l_ac].gin04
             WHERE gin00 = g_gin00 AND gin01 = g_gin01 AND gin05 = g_gin05 AND gin06 = g_gin06
         ELSE
            INSERT INTO gin_file (gin00,gin01,gin02,gin03,gin04,gin05,gin06)  #No:MOD-470041 #No.FUN-740020
               VALUES(g_gin00,g_gin01,g_gin[l_ac].gin02,g_gin[l_ac].gin03,  #No.FUN-740020
                      g_gin[l_ac].gin04,g_gin05,g_gin06)
         END IF 
#---> By FUN-B50001 101109  end 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gin_file",g_gin01,g_gin[l_ac].gin02,SQLCA.sqlcode,"","",1)  #No.FUN-660123 #No.FUN-740020
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
   
      AFTER FIELD gin02
         IF NOT cl_null(g_gin[l_ac].gin02) THEN
            CALL i933_gin()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD gin02
            END IF
         END IF
         IF g_gin[l_ac].gin02 != g_gin_t.gin02 OR
            cl_null(g_gin_t.gin02) THEN
            SELECT COUNT(*) INTO l_n FROM gin_file
             WHERE gin02 = g_gin[l_ac].gin02 
            IF l_n > 0 THEN    #科目已存在其他群組中
               IF NOT cl_confirm('agl-919') THEN
                  NEXT FIELD gin02
               END IF
            END IF
            SELECT count(*) INTO l_n FROM gin_file 
             WHERE gin01 = g_gin01 AND gin02 = g_gin[l_ac].gin02
               AND gin00 = g_gin00  #No.FUN-740020
               AND gin05 = g_gin05 #FUN-B50001 
               AND gin06 = g_gin06 #FUN-B50001 
            IF l_n <> 0 THEN
               LET g_gin[l_ac].gin02 = g_gin_t.gin02
               CALL cl_err('','-239',0) 
               NEXT FIELD gin02
            END IF
         END IF
   
      AFTER FIELD gin03
         IF NOT cl_null(g_gin[l_ac].gin03) THEN
            IF g_gin[l_ac].gin03 NOT MATCHES '[-+]' THEN 
               NEXT FIELD gin03 
            END IF
         END IF
   
      AFTER FIELD gin04
         IF NOT cl_null(g_gin[l_ac].gin04) THEN
            IF g_gin[l_ac].gin04 NOT MATCHES '[123456]' THEN
               NEXT FIELD gin04
            END IF 
         END IF
   
      BEFORE DELETE                                    #modify:Mandy
         #判斷是否可以刪除此ROW,因為此ROW可能和其它file有key值的關聯性,
         #所以不能隨便亂刪掉
         CALL i933_gin_delyn() RETURNING l_gin_delyn 
         IF g_gin_t.gin02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN   #詢問是否確定
               CANCEL DELETE
            END IF
            IF l_gin_delyn = 'N ' THEN   #為不可刪除此ROW的狀態下
               #人工輸入金額設定作業中此ROW已被使用,不可刪除!!
               CALL cl_err(g_gin_t.gin02,'agl-918',0) 
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM gin_file WHERE gin00 = g_gin00  #No.FUN-740020
                                   AND gin01 = g_gin01 AND gin02 = g_gin_t.gin02 
                                   AND gin05 = g_gin05 AND gin06 = g_gin06 #FUN-B50001  add 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gin_file",g_gin01,g_gin_t.gin02,SQLCA.sqlcode,"","",1)  #No.FUN-660123 #No.FUN-740020
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
   
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gin[l_ac].* = g_gin_t.*
            CLOSE i933_bcl
       #    ROLLBACK WORK #FUN-B50001
       #    EXIT INPUT    #FUN-B50001 
            EXIT DIALOG   #FUN-B50001 
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gin[l_ac].gin02,-263,1)
            LET g_gin[l_ac].* = g_gin_t.*
         ELSE
            UPDATE gin_file SET gin02 = g_gin[l_ac].gin02,
                                gin03 = g_gin[l_ac].gin03,
                                gin04 = g_gin[l_ac].gin04 
             WHERE gin00=g_gin00  #No.FUN-740020
               AND gin01=g_gin01 AND gin02=g_gin_t.gin02
               AND gin05=g_gin05 AND gin06=g_gin06 #FUN-B50001 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gin_file",g_gin01,g_gin_t.gin02,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-740020
               LET g_gin[l_ac].* = g_gin_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
        #      COMMIT WORK   #FUN-B50001 
            END IF
         END IF
   
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gin[l_ac].* = g_gin_t.*
            END IF
            CLOSE i933_bcl
       #    ROLLBACK WORK   #FUN-B50001 
       #    EXIT INPUT      #FUN-B50001 
            EXIT DIALOG     #FUN-B50001 
         END IF
         CLOSE i933_bcl
       # COMMIT WORK        #FUN-B50001 
   
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gin02) AND l_ac > 1 THEN
            LET g_gin[l_ac].* = g_gin[l_ac-1].*
            NEXT FIELD gin02
         END IF
   
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
   
      #TQC-C30136--mark--str--
      #ON ACTION CONTROLG
      #   CALL cl_cmdask()
      #TQC-C30136--mark--end--
   
      ON ACTION controlp
         CASE
            WHEN INFIELD(gin02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_gin[l_ac].gin02
               LET g_qryparam.arg1 = g_gin00      #No.TQC-740093
               LET g_qryparam.where = "aag07 != '1'"  #by FUN-B50001 101221  add 
               CALL cl_create_qry() RETURNING g_gin[l_ac].gin02
               DISPLAY BY NAME g_gin[l_ac].gin02        #No:MOD-490344
               CALL i933_gin()
               NEXT FIELD gin02
            OTHERWISE
               EXIT CASE
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
     #   CONTINUE INPUT    #FUN-B50001 
         CONTINUE DIALOG   #FUN-B50001 
      #TQC-C30136--mark--str--
      #ON ACTION about         #MOD-4C0121
      #   CALL cl_about()      #MOD-4C0121
      #
      #ON ACTION help          #MOD-4C0121
      #   CALL cl_show_help()  #MOD-4C0121
      #TQC-C30136--mark--end--
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
       
   END INPUT
#---> by FUN-B50001 101109   begin

   BEFORE DIALOG
      CALL cl_set_act_visible("close,append", FALSE)
      BEGIN WORK
     #FUN-D30033--add--begin---
      CASE g_flag_b
         WHEN '1' NEXT FIELD gin01
         WHEN '2' NEXT FIELD gin02
      END CASE
    #FUN-D30033--add--end----  

   ON ACTION accept
      ACCEPT DIALOG

   ON ACTION cancel
     #FUN-D30033--add--begin--- 
      IF p_cmd ='a' THEN
         IF g_flag_b = '1' AND g_rec_b0 != 0 THEN
            LET g_action_choice = "detail"
            CALL g_gir.deleteElement(l_ac0)
         END IF
         IF g_flag_b = '2' AND g_rec_b != 0 THEN
            LET g_action_choice = "detail"
            CALL g_gin.deleteElement(l_ac)
         END IF
      END IF
     #FUN-D30033--add--end---
      LET INT_FLAG = 1
      EXIT DIALOG

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
#---> by FUN-B50001 101109   end
   CLOSE i933_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i933_gin()
DEFINE 
   l_ginacti    LIKE aag_file.aagacti    #No.FUN-680098 VARCHAR(1)

   LET g_errno = ' '
   SELECT aag02,aagacti INTO g_gin[l_ac].aag02,l_ginacti FROM aag_file
    WHERE aag01 = g_gin[l_ac].gin02 
    AND aag00 = g_gin00               #No.MOD-740269
   CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-001'
        WHEN l_ginacti = 'N'     LEt g_errno = '9028'
        OTHERWISE
   END CASE
END FUNCTION

FUNCTION i933_gin_delyn()
DEFINE 
   l_delyn       LIKE type_file.chr1,      #存放可否刪除的變數  #No.FUN-680098   VARCHAR(1)   
   l_n           LIKE type_file.num5          #No.FUN-680098 SMALLINT
   
   LET l_delyn = 'Y'

   SELECT COUNT(*)  INTO l_n FROM git_file 
    WHERE git01 = g_gin01
      AND git02 = g_gin[l_ac].gin02 
      AND gin00 = g_gin00  #No.FUN-740020
      AND git08 = g_gin05  #FUN-B50001 
      AND git09 = g_gin06  #FUN-B50001 
   IF l_n > 0 THEN 
      LET l_delyn = 'N'
   END IF
   RETURN l_delyn
END FUNCTION

FUNCTION i933_b_askkey()
   CLEAR FORM
   CALL g_gin.clear()
   CONSTRUCT g_wc2 ON gin05,gin06,gin00,gin01,gin02,gin03,gin04 #FUN-B50001 add gin05,gin06  #螢幕上取條件 #No.FUN-740020
        FROM gin05,gin06,gin00,gin01,s_gin[1].gin02,s_gin[1].gin03,s_gin[1].gin04 #No.FUN-740020
              #No:FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No:FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
		#No:FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No:FUN-580031 --end--       HCN
   END CONSTRUCT

   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CALL i933_b_fill(g_wc2)
END FUNCTION
   
#FUNCTION i933_b_fill(p_wc)              #BODY FILL UP
 FUNCTION i933_b_fill(p_gin01)  #FUN-B50001 
DEFINE p_gin01     LIKE gin_file.gin01 #FUN-B50001   
DEFINE
   p_wc            STRING,             #TQC-630166   
   l_flag          LIKE type_file.chr1,              #有無單身筆數        #No.FUN-680098 VARCHAR(1)
   l_sql           STRING        #TQC-630166        
 
   LET l_sql = "SELECT gin02,aag02,gin03,gin04 ",
               "  FROM gin_file,OUTER aag_file",
             # " WHERE gin01 = '",g_gin01,"'",   #FUN-B50001 
               " WHERE gin01 = '",p_gin01,"'",   #FUN-B50001 
               "   AND gin00 = '",g_gin00,"'",   #No.FUN-740020
               "   AND gin05 = '",g_gin05,"'",   #FUN-B50001 
               "   AND gin06 = '",g_gin06,"'",   #FUN-B50001
               "   AND gin00 = aag00 ",          #No.MOD-740269
             # "   AND gin02 = aag01 AND ",p_wc CLIPPED, #FUN-B50001 
               "   AND gin02 = aag01 ",                  #FUN-B50001 
               " ORDER BY gin02"

   PREPARE gin_pre FROM l_sql
   DECLARE gin_cs CURSOR FOR gin_pre

   CALL g_gin.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH gin_cs INTO g_gin[g_cnt].*     #單身 ARRAY 填充
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
   CALL g_gin.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF l_flag='N' THEN LET g_rec_b=0 END IF     #無單身時將筆數清為零
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION

#---> by FUN-B50001 101220   begin 
FUNCTION  i933_gin06(p_cmd,p_gin06,p_gin05)  
DEFINE p_cmd           LIKE type_file.chr1,
       p_gin06         LIKE gin_file.gin06,
       l_axz02         LIKE axz_file.axz02,
       l_axz03         LIKE axz_file.axz03,
       l_axz05         LIKE axz_file.axz05,
       l_aaz641        LIKE aaz_file.aaz641,
       l_axa09         LIKE axa_file.axa09,    #FUN-950051
       p_gin05         LIKE gin_file.gin05     #FUN-950051

    LET g_errno = ' '

       SELECT axz02,axz03,axz05 INTO l_axz02,l_axz03,l_axz05
         FROM axz_file
        WHERE axz01 = p_gin06
    CALL s_aaz641_dbs(p_gin05,p_gin06) RETURNING g_dbs_axz03
    CALL s_get_aaz641(g_dbs_axz03) RETURNING l_aaz641
    SELECT axz05 INTO l_axz05 FROM axz_file WHERE axz01 = p_gin06
    LET g_gin00 = l_aaz641
    LET g_axz05 = l_axz05

    CASE
       WHEN SQLCA.SQLCODE=100

          LET g_errno = 'agl-988'          #TQC-970018
          LET l_axz02 = NULL
          LET l_axz03 = NULL
       OTHERWISE
          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE

    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_axz02 TO FORMONLY.axz02
       DISPLAY l_axz03 TO FORMONLY.axz03
       DISPLAY g_gin00 TO FORMONLY.gin00
    END IF
END FUNCTION
#---> by FUN-B50001 101220   end 

FUNCTION i933_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
#---by FUN-B50001 101109  begin
   DIALOG ATTRIBUTES(UNBUFFERED)
     DISPLAY ARRAY g_gir TO s_gir.* ATTRIBUTE(COUNT=g_rec_b0)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_flag_b = '1'   #FUN-D30033 add

      BEFORE ROW
         LET l_ac0 = ARR_CURR()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         IF l_ac0 > 0 THEN
            CALL i933_b_fill(g_gir[l_ac0].gin01)
         END IF
     END DISPLAY
#---by FUN-B50001 101109 end
     DISPLAY ARRAY g_gin TO s_gin.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_flag_b = '2'   #FUN-D30033 add

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf 
    END DISPLAY   #FUN-B50001 

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
      #  EXIT DISPLAY   #FUN-B50001 
         EXIT DIALOG    #FUN-B50001 
      ON ACTION query
         LET g_action_choice="query"
      #  EXIT DISPLAY   #FUN-B50001 
         EXIT DIALOG    #FUN-B50001
      ON ACTION first 
         CALL i933_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
       #   ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
           ACCEPT DIALOG   #FUN-B50001 

      ON ACTION previous
         CALL i933_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         #ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
          ACCEPT DIALOG   #FUN-B50001

      ON ACTION jump
         CALL i933_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         #ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
          ACCEPT DIALOG  #FUN-B50001                      

      ON ACTION next
         CALL i933_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
#	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
        ACCEPT DIALOG   #FUN-B50001                       

      ON ACTION last
         CALL i933_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
#	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
        ACCEPT DIALOG  #FUN-B50001                       

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
      #  EXIT DISPLAY
         EXIT DIALOG   #FUN-B50001 
      ON ACTION output
         LET g_action_choice="output"
      #  EXIT DISPLAY
         EXIT DIALOG  #FUN-B50001 
      ON ACTION help
         LET g_action_choice="help"
      #  EXIT DISPLAY
         EXIT DIALOG  #FUN-B50001 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
      #  EXIT DISPLAY
         EXIT DIALOG   #FUN-B50001 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
      #  EXIT DISPLAY
         EXIT DIALOG   #FUN-B50001 
       ON ACTION related_document  #No:MOD-470515
         LET g_action_choice="related_document"
      #  EXIT DISPLAY
         EXIT DIALOG   #FUN-B50001 
      ON ACTION exporttoexcel   #No:FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
      #  EXIT DISPLAY
         EXIT DIALOG   #FUN-B50001 
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
    # EXIT DISPLAY
      EXIT DIALOG   #FUN-B50001

   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
    # EXIT DISPLAY
      EXIT DIALOG   #FUN-B50001
  #FUN-D30033--add--begin---
   ON ACTION close
      LET INT_FLAG=FALSE
      LET g_action_choice="exit"
      EXIT DIALOG
  #FUN-D30033--add--end---
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
       # CONTINUE DISPLAY
         CONTINUE DIALOG  #FUN-B50001 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

    # AFTER DISPLAY
    #    CONTINUE DISPLAY
      AFTER DIALOG         #FUN-B50001 
         CONTINUE DIALOG   #FUN-B50001 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
   
 # END DISPLAY
   END DIALOG   #FUN-B50001 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i933_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("gin00,gin01",TRUE)  #No.FUN-740020
    END IF 

END FUNCTION

FUNCTION i933_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("gin00,gin01",FALSE) #No.FUN-740020
    END IF 

END FUNCTION

FUNCTION i933_out()
DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                
     IF cl_null(g_wc) AND NOT cl_null(g_gin00) AND 
        NOT cl_null(g_gin01) 
        THEN LET g_wc=" gin00='",g_gin00,"' AND gin01='",g_gin01,"'"
     END IF                                                                                                                         
     IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF                                                                    
     LET l_cmd = 'p_query "agli933" "',g_wc CLIPPED,'"'                                                                             
     CALL cl_cmdrun(l_cmd)                                                                                                          
     RETURN                                                                                                                         
END FUNCTION
