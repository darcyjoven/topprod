# Prog. Version..: '5.30.06-13.04.22(00004)'     #
# Pattern name...: ggli502.4gl
# Descriptions...: 現金流量表活動科目設定 
# Date & Author..: FUN-930155 09/04/23 BY yiting
# Modify.........: FUN-B50001 11/05/09 By wuxj   群组代码改为单身维护
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60063 11/06/14 By yinhy 修改單身atk01群組編號開窗
# Modify.........: NO.MOD-B60186 By Polly 修正「查詢」科目編號開窗後，按確認或放棄，程式會被關掉
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植
# Modify.........: No.TQC-C30136 12/03/08 By fengrui 處理ON ACITON衝突問題
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40025 13/04/19 By xumm 修改FUN-D30032遗留问题

DATABASE ds

GLOBALS "../../config/top.global"    #FUN-BB0037

#模組變數(Module Variables)
DEFINE   #FUN-930155
    g_atk00         LIKE atk_file.atk00,   #No.FUN-740020
    g_atk01         LIKE atk_file.atk01,   #活動類別(假單頭)
    g_atk00_t       LIKE atk_file.atk00,   #活動類別(舊值)  #No.FUN-740020
    g_atk01_t       LIKE atk_file.atk01,   #活動類別(舊值)
#---> by FUN-B50001 101220  beatk 
    g_atk05        LIKE atk_file.atk05,      
    g_atk05_t      LIKE atk_file.atk05,     
    g_atk06        LIKE atk_file.atk06,    
    g_atk06_t      LIKE atk_file.atk06,   
    g_asg05        LIKE asg_file.asg05,
#---> by FUN-B50001 101220  end 
#---> by FUN-B50001 101109  beatk  add
    g_atj           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
       atk01           LIKE atk_file.atk01,   #群組代碼
       atj02           LIKE atj_file.atj02,   #說明
       atj03           LIKE atj_file.atj03,   #變動分類
       atj04           LIKE atj_file.atj04,   #合併否
       atj05           LIKE atj_file.atj05    #行次 #FUN-640004
                    END RECORD,
    g_atj_t         RECORD                 #程式變數 (舊值)
       atk01           LIKE atk_file.atk01,   #群組代碼
       atj02           LIKE atj_file.atj02,   #說明
       atj03           LIKE atj_file.atj03,   #變動分類
       atj04           LIKE atj_file.atj04,   #合併否
       atj05           LIKE atj_file.atj05    #行次 #FUN-640004
                    END RECORD,
#---> by FUN-B50001 101109  end
    g_atk           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        atk02       LIKE atk_file.atk02,   #科目編號
        aag02       LIKE aag_file.aag02,   #科目名稱
        atk03       LIKE atk_file.atk03,   #加減項
        atk04       LIKE atk_file.atk04    #異動別
                    END RECORD,
    g_atk_t         RECORD                 #程式變數 (舊值)
        atk02       LIKE atk_file.atk02,   #科目編號
        aag02       LIKE aag_file.aag02,   #科目名稱
        atk03       LIKE atk_file.atk03,   #加減項
        atk04       LIKE atk_file.atk04    #異動別
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,        #TQC-630166     
    g_sql_tmp           STRING,        #No.FUN-740020
    g_rec_b         LIKE type_file.num5,    #單身筆數               #No.FUN-680098 SMALLINT
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT    #No.FUN-680098 SMALLINT
DEFINE g_str        STRING     #No.FUN-830113 
DEFINE g_dbs_asg03         LIKE type_file.chr21     #FUN-B50001 add 
DEFINE g_b_flag            STRING                   #TQC-D40025
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
 
  IF (NOT cl_setup("GGL")) THEN
     EXIT PROGRAM
  END IF
  CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114


   LET p_row = ARG_VAL(2)     #No:MOD-4C0171                 #取得螢幕位置
   LET p_col = ARG_VAL(3)     #No:MOD-4C0171
   LET g_atk01      = NULL                #清除鍵值
   LET g_atk01_t    = NULL
   LET g_atk00      = NULL                #清除鍵值
   LET g_atk00_t    = NULL
#---> by FUN-B50001 101220  beatk 
   LET g_atk05   = NULL 
   LET g_atk05_t = NULL
   LET g_atk06   = NULL  
   LET g_atk06_t = NULL
#---> by wuxn 101202  end 
   LET p_row = 3 LET p_col = 14
       
   OPEN WINDOW i933_w AT p_row,p_col      #顯示畫面
     WITH FORM "ggl/42f/ggli502"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
    CALL cl_ui_init()

   CALL i933_menu()
   CLOSE WINDOW i933_w                    #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

#QBE 查詢資料
FUNCTION i933_cs()
   CLEAR FORM                                   #清除畫面
      CALL g_atk.clear()
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0029 

   INITIALIZE g_atk00 TO NULL    #No.FUN-750051
   INITIALIZE g_atk01 TO NULL    #No.FUN-750051
#---> by FUN-B50001 101220  beatk 
   INITIALIZE g_atk05 TO NULL
   INITIALIZE g_atk06 TO NULL
#---> by FUN-B50001 101220  end 

   CONSTRUCT g_wc ON atk05,atk06,atk00,atk01,atk02,atk03,atk04  #by FUN-B50001 101220 add     #螢幕上取條件   # No:FUN-740020
      # FROM atk00,atk01,s_atk[1].atk02,s_atk[1].atk03,s_atk[1].atk04
        FROM atk05,atk06,atk00,s_atj[1].atk01,s_atk[1].atk02,s_atk[1].atk03,s_atk[1].atk04  #FUN-B50001 101109 add

              #No:FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No:FUN-580031 --end--       HCN
      ON ACTION controlp                 # 沿用所有欄位
         CASE
          #No.FUN-740020  --Beatk                                                                                                   
          WHEN INFIELD(atk00)                                                                                                       
             CALL cl_init_qry_var()                                                                                                 
             LET g_qryparam.state = "c"                                                                                             
             LET g_qryparam.form ="q_aaa"                                                                                           
             CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                     
             DISPLAY g_qryparam.multiret TO atk00                                                                                   
             NEXT FIELD atk00                                                                                                       
          #No.FUN-740020  --End 
            WHEN INFIELD(atk01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               #LET g_qryparam.form ="q_atj"   #No.TQC-B60063
               LET g_qryparam.form ="q_atj1"   #No.TQC-B60063
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO atk01
               NEXT FIELD atk01 
            WHEN INFIELD(atk02)
              #CALL cl_init_qry_var()                                    #No.MOD-B60186 mark
              #LET g_qryparam.state = "c"                                #No.MOD-B60186 mark
              #LET g_qryparam.form ="q_aag"                              #No.MOD-B60186 mark
              #CALL cl_create_qry() RETURNING g_qryparam.multiret        #No.MOD-B60186 mark
               CALL q_m_aag2(TRUE,TRUE,'',g_atk[1].atk02,'23',g_atk00)   #No.MOD-B60186 add
                    RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO atk02
              #CALL i933_atk()                                           #No.MOD-B60186 mark
               NEXT FIELD atk02
#---> by FUN-B50001 101220   beatk 
              WHEN INFIELD(atk05) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_asa1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO atk05
                 NEXT FIELD atk05
              WHEN INFIELD(atk06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_asg"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO atk06
                 NEXT FIELD atk06
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
   LET g_sql="SELECT UNIQUE atk00,atk05,atk06 FROM atk_file ", #by FUN-B50001 mark atk01 # 組合出SQL 指令,看atk01有幾種就run幾次 #No.FUN-740020
             " WHERE ", g_wc CLIPPED,
             " ORDER BY 1"
   PREPARE i933_prepare FROM g_sql              #預備一下
   DECLARE i933_b_cs                            #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i933_prepare
                                                #計算本次查詢單頭的筆數
   LET g_sql_tmp= "SELECT UNIQUE atk00,atk05,atk06 FROM atk_file ",         #by FUN-B50001 mark atk01                                                  
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
               IF g_atk00 IS NULL OR g_atk01 IS NOT NULL THEN  #No.FUN-740020
                  LET g_doc.column1 = "atk01"
                  LET g_doc.value1 = g_atk01
#by FUN-B50001 101220   beatk 
                  LET g_doc.column2 = "atk05"
                  LET g_doc.value2 = g_atk05
                  LET g_doc.column3 = "atk06"
                  LET g_doc.value3 = g_atk06
                  LET g_doc.column4 = "atk00"
                  LET g_doc.value4 = g_atk00
#by FUN-B50001 101220   end
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No:FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_atk),'','')
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
      CALL g_atk.clear()
#  INITIALIZE g_atk01 LIKE atk_file.atk01     #by FUN-B50001 mark
#  LET g_atk01_t = NULL                       #by FUN-B50001 mark
   #No.FUN-740020  --Beatk
   INITIALIZE g_atk00 LIKE atk_file.atk00
   LET g_atk00_t = NULL
   #No.FUN-740020  --End
#by FUN-B50001 101220  beatk 
   INITIALIZE g_atk05 LIKE atk_file.atk05      #DEFAULT 設定
   INITIALIZE g_atk06 LIKE atk_file.atk06      #DEFAULT 設定
   LET g_atk05_t = NULL
   LET g_atk06_t = NULL
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
      CALL g_atk.clear()
#---> by FUN-B50001 101109   beatk 
#     SELECT COUNT(*) INTO l_n FROM atk_file WHERE atk01=g_atk01
#                                              AND atk00=g_atk00 #No.FUN-740020
      LET g_rec_b = 0                    #No.FUN-680064
      LET g_rec_b0 = 0
#     IF l_n > 0 THEN
#        CALL i933_b_fill('1=1')
#     END IF
      CALL g_atj.clear()
#---> by FUN-B50001 101109  end 
      CALL i933_b()                             #輸入單身
      LET g_atk00_t = g_atk00                   #保留舊值 #No.FUN-740020
   #  LET g_atk01_t = g_atk01   #FUN-B50001 mark      #保留舊值
#---> by FUN-B50001 101220  beatk 
      LET g_atk05_t = g_atk05                   #保留舊值
      LET g_atk06_t = g_atk06                   #保留舊值
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

 # INPUT g_atk00,g_atk01 WITHOUT DEFAULTS FROM atk00,atk01     #No.FUN-740020
   INPUT g_atk05,g_atk06,g_atk00 WITHOUT DEFAULTS FROM atk05,atk06,atk00 #by FUN-B50001 101109 add  
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i933_set_entry(p_cmd)
         CALL i933_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      #-----MOD-840537---------
      AFTER FIELD atk00 
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM aaa_file 
           WHERE aaa01 = g_atk00 AND 
                 aaaacti = 'Y'
         IF l_cnt = 0 THEN
            CALL cl_err('','agl-095',0)   
            NEXT FIELD atk00
         END IF
      #-----END MOD-840537-----
#---> by FUN-B50001 101109  beatk  mark 
#     AFTER FIELD atk01                  #設定活動類別
#        IF NOT cl_null(g_atk01) THEN
#           CALL i933_atk01('a')
#           IF NOT cl_null(g_errno) THEN
#              CALL cl_err('',g_errno,0)   #MOD-840537
#              NEXT FIELD atk01
#           END IF
#        END IF
#---> by FUN-B50001  101109 end 

#---> by FUN-B50001 101220  beatk 
      AFTER FIELD atk05   #族群代號
         IF cl_null(g_atk05) THEN
            CALL cl_err(g_atk05,'mfg0037',0)
            NEXT FIELD atk05
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM asa_file
             WHERE asa01=g_atk05
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err(g_atk05,'agl-223',0)
               NEXT FIELD atk05
            END IF
         END IF

      AFTER FIELD atk06
         IF NOT cl_null(g_atk06) THEN
               CALL i933_atk06('a',g_atk06,g_atk05)                                      
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_atk06,g_errno,0)
                  NEXT FIELD atk06
               END IF
            IF g_atk05 IS NOT NULL AND g_atk06 IS NOT NULL AND
               g_atk00 IS NOT NULL THEN
               LET l_n = 0   LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM asa_file
                WHERE asa01=g_atk05 AND asa02=g_atk06
                  AND asa03=g_asg05
               SELECT COUNT(*) INTO l_n1 FROM asb_file
                WHERE asb01=g_atk05 AND asb04=g_atk06
                  AND asb05=g_asg05
               IF l_n+l_n1 = 0 THEN
                  CALL cl_err(g_atk06,'agl-223',0)
                  LET g_atk05 = g_atk05_t
                  LET g_atk06 = g_atk06_t
                  LET g_atk00 = g_atk00_t
                  DISPLAY BY NAME g_atk05,g_atk06,g_atk00
                  NEXT FIELD atk06
               END IF
            END IF
         END IF
#by FUN-B50001 101220   end 

      ON ACTION controlp                 # 沿用所有欄位
         CASE
          #No.FUN-740020  --Beatk
            WHEN INFIELD(atk00)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = g_atk00
               CALL cl_create_qry() RETURNING g_atk00
               DISPLAY BY NAME g_atk00
               NEXT FIELD atk00 
          #No.FUN-740020  --End 
#---> by FUN-B50001 101109  beatk  mark 
#           WHEN INFIELD(atk01)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_atj"
#              LET g_qryparam.default1 = g_atk01
#              CALL cl_create_qry() RETURNING g_atk01
#               CALL FGL_DIALOG_SETBUFFER( g_atk01 )
#              DISPLAY BY NAME g_atk01
#              NEXT FIELD atk01 
#---> by FUN-B50001 101109  end 

#by FUN-B50001 101220   beatk 
            WHEN INFIELD(atk05) #族群編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asa1"
               LET g_qryparam.default1 = g_atk05
               CALL cl_create_qry() RETURNING g_atk05
               DISPLAY g_atk05 TO atk05
               NEXT FIELD atk05
            WHEN INFIELD(atk06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asg"
               LET g_qryparam.default1 = g_atk06
               CALL cl_create_qry() RETURNING g_atk06
               DISPLAY g_atk06 TO atk06
               NEXT FIELD atk06
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

FUNCTION i933_atk01(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
   l_atj02    LIKE atj_file.atj02

   LET g_errno=''
   SELECT atj02,atj03,atj04,atj05 INTO g_atj[l_ac0].atj02,g_atj[l_ac0].atj03,g_atj[l_ac0].atj04,g_atj[l_ac0].atj05 #by FUN-B50001
     FROM atj_file
   # WHERE atj01=g_atk01
     WHERE atj01=g_atj[l_ac0].atk01  #by FUN-B50001 add 
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-917'
                              # LET l_atj02=NULL              #FUN-B50001 
                                LET g_atj[l_ac0].atj02=NULL   #FUN-B50001
                                LET g_atj[l_ac0].atj03=NULL   #FUN-B50001
                                LET g_atj[l_ac0].atj04=NULL   #FUN-B50001
                                LET g_atj[l_ac0].atj05=NULL   #FUN-B50001
       WHEN g_atj[l_ac0].atj04='N'   LET g_errno='agl1005'    #TQC-B60063

       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
#---> by FUN-B50001 101109 beatk  mark
#  IF p_cmd='d' OR cl_null(g_errno)THEN
#
#    DISPLAY l_atj02 TO FORMONLY.atj02 
#  END IF
#---> by FUN-B50001 101109 end 
END FUNCTION
#Query 查詢
FUNCTION i933_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
  #INITIALIZE g_atk00,g_atk01 TO NULL    #No.FUN-6B0040  #No.FUN-740020
   INITIALIZE g_atk00 TO NULL   #FUN-B50001 
   INITIALIZE g_atk05 TO NULL   #FUN-B50001
   INITIALIZE g_atk06 TO NULL   #FUN-B50001
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
     #INITIALIZE g_atk00,g_atk01 TO NULL  #No.FUN-740020
      INITIALIZE g_atk00 TO NULL   #FUN-B50001
      INITIALIZE g_atk05 TO NULL   #FUN-B50001
      INITIALIZE g_atk06 TO NULL   #FUN-B50001 
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
       WHEN 'N' FETCH NEXT     i933_b_cs INTO g_atk00,g_atk05,g_atk06#,g_atk01   #by FUN-B50001 101109 mark g_atk01,add atk05,06 
       WHEN 'P' FETCH PREVIOUS i933_b_cs INTO g_atk00,g_atk05,g_atk06#,g_atk01   #by FUN-B50001 101109 mark g_atk01,add atk05,06
       WHEN 'F' FETCH FIRST    i933_b_cs INTO g_atk00,g_atk05,g_atk06#,g_atk01   #by FUN-B50001 101109 mark g_atk01,add atk05,06 
       WHEN 'L' FETCH LAST     i933_b_cs INTO g_atk00,g_atk05,g_atk06#,g_atk01   #by FUN-B50001 101109 mark g_atk01,add atk05,06
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
            FETCH ABSOLUTE g_jump i933_b_cs INTO g_atk00,g_atk05,g_atk06  #by FUN-B50001 101109 mark g_atk01,add atk05,06
            LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_atk01,SQLCA.sqlcode,0)
      INITIALIZE g_atk01 TO NULL  #TQC-6B0105
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
   DISPLAY g_atk00 TO atk00               #單頭 #No.FUN-740020
   DISPLAY g_atk05 TO atk05 #FUN-B50001 
   DISPLAY g_atk06 TO atk06 #FUN-B50001 
   CALL i933_atk06('d',g_atk06,g_atk05) #FUN-B50001  
#  DISPLAY g_atk01 TO atk01 #FUN-B50001         #單頭
#  CALL i933_atk01('d')     #FUN-B50001
#  CALL i933_b_fill(g_wc)   #FUN-B50001         #單身
   CALL i933_b_fill0(g_wc)  #FUN-B50001 
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION i933_r()
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_atk01 IS NULL THEN
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "atk01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_atk01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM atk_file WHERE atk00 = g_atk00  #No.FUN-740020
                             AND atk01 = g_atk01
                             AND atk05 = g_atk05  #by FUN-B50001 101220 add 
                             AND atk06 = g_atk06  #by FUN-B50001 101220 add 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","atk_file",g_atk01,"",SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660123 #No.FUN-740020
      ELSE
         CLEAR FORM
         CALL g_atk.clear()
         LET g_atk00 = NULL   #No.FUN-740020
         LET g_atk01 = NULL
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

#---> by FUN-B50001 101109  beatk
FUNCTION i933_b_fill0(p_wc)
DEFINE p_wc    LIKE type_file.chr1000
DEFINE l_cmd  LIKE type_file.chr1000

   LET g_sql = "SELECT DISTINCT atk01,atj02,atj03,atj04,atj05 ",
               " FROM atj_file,atk_file",
               " WHERE ", p_wc CLIPPED,                     #單身
               "   AND atk01 = atj01 ",
               "   AND atk00 = '",g_atk00,"' AND atk05='",g_atk05,"' AND atk06='",g_atk06,"'", 
               " ORDER BY atk01"
   PREPARE i933_pb FROM g_sql
   DECLARE atj_curs CURSOR FOR i933_pb

   CALL g_atj.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"

   FOREACH atj_curs INTO g_atj[g_cnt].*   #單身 ARRAY 填充
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

   CALL g_atj.deleteElement(g_cnt)
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
   l_atk_delyn     LIKE type_file.chr1,     #判斷是否可以刪除單身資料ROW   #No.FUN-680098  VARCHAR(1)
   l_chr           LIKE type_file.chr1,     #No.FUN-680098    VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,     #可新增否         #No.FUN-680098 SMALLINT
   l_allow_delete  LIKE type_file.num5      #可刪除否         #No.FUN-680098 SMALLINT
DEFINE l_ac0_t     LIKE type_file.num5      #FUN-B50001


   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF        #檢查權限
#  IF g_atk00 IS NULL OR g_atk01 IS NULL THEN  #No.FUN-740020
   IF g_atk00 IS NULL THEN  #FUN-B50001 
       RETURN
   END IF

   CALL cl_opmsg('b')                #單身處理的操作提示

   LET g_forupd_sql = "SELECT atk02,'',atk03,atk04 FROM atk_file",
                      " WHERE atk00 = ? AND atk01=? AND atk02=? AND atk05=? AND atk06=? FOR UPDATE "  #No.FUN-740020#FUN-B50001 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i933_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

#---> by FUN-B50001 101109   beatk
   LET g_forupd_sql = " SELECT atk01,atj02,atj03,atj04,atj05 ",
                      "   FROM atk_file,atj_file ",
                      "  WHERE atk01 = atj01 AND atk01 = ? AND atk00 = ? AND atk05=? AND atk06=? FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i933_bcl0 CURSOR FROM g_forupd_sql      # LOCK CURSOR

   DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT ARRAY g_atj FROM s_atj.*
      ATTRIBUTE (COUNT=g_rec_b0,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b0!=0 THEN
            CALL fgl_set_arr_curr(l_ac0)
         END IF
         CALL cl_set_comp_entry("atj02,atj03,atj04,atj05",FALSE)
         LET g_b_flag = '1'     #TQC-D40025 Add

      BEFORE ROW
         LET p_cmd=''
         LET l_ac0 = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b0 >= l_ac0 THEN
            LET p_cmd='u'
            LET g_atj_t.* = g_atj[l_ac0].*  #BACKUP
            OPEN i933_bcl0 USING g_atj_t.atk01,g_atk00,g_atk05,g_atk06                           
            IF STATUS THEN
               CALL cl_err("OPEN i933_bcl0:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i933_bcl0 INTO g_atj[l_ac0].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_atj_t.atk01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_atj[l_ac0].* TO NULL
         LET g_atj_t.* = g_atj[l_ac0].*
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD atk01

      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE i933_bcl0
         END IF
         INSERT INTO atk_file(atk00,atk01,atk02,atk05,atk06)
                       VALUES(g_atk00,g_atj[l_ac0].atk01,' ',g_atk05,g_atk06)                              
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","atk_file",g_atj[l_ac].atk01,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b0 = g_rec_b0 + 1 
         END IF

      BEFORE FIELD atk01
         IF NOT cl_null(g_atj[l_ac0].atk01) THEN
       #    LET g_atj_t.atk01 = g_atj[l_ac0].atk01
            CALL i933_b_fill(g_atj[l_ac0].atk01)
         ELSE
            CALL g_atk.clear()
         END IF

      AFTER FIELD atk01                        #check 編號是否重複
         IF g_atj[l_ac0].atk01 != g_atj_t.atk01 OR
            (g_atj[l_ac0].atk01 IS NOT NULL AND g_atj_t.atk01 IS NULL) THEN
            SELECT count(*) INTO l_n FROM atk_file
             WHERE atk01 = g_atj[l_ac0].atk01
               AND atk00 = g_atk00
               AND atk05 = g_atk05
               AND atk06 = g_atk06
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_atj[l_ac0].atk01 = g_atj_t.atk01
               NEXT FIELD atk01
            END IF
            CALL i933_atk01('a')
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               LET g_atj[l_ac0].atk01 = g_atj_t.atk01
               NEXT FIELD atk01
            END IF
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_atj_t.atk01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM atk_file
             WHERE atk01 = g_atj_t.atk01
               AND atk00 = g_atk00
               AND atk05 = g_atk05
               AND atk06 = g_atk06
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","atk_file",g_atj_t.atk01,"",SQLCA.sqlcode,"","",1)
               CANCEL DELETE
            END IF
            LET g_rec_b0=g_rec_b0-1
         END IF

      ON ROW CHANGE
         IF g_atj_t.atk01 IS NOT NULL THEN
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_atj[l_ac0].atk01,-263,1)
               LET g_atj[l_ac0].* = g_atj_t.*
            ELSE
               UPDATE atk_file SET atk01 = g_atj[l_ac0].atk01
                WHERE atk00 = g_atk00
                  AND atk05 = g_atk05
                  AND atk06 = g_atk06
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","atk_file",g_atk00,g_atj_t.atk01,SQLCA.sqlcode,"","",1)
                  LET g_atj[l_ac0].* = g_atj_t.*
               ELSE
                  CALL cl_msg('UPDATE O.K')
               END IF
            END IF
         END IF

      AFTER ROW
         LET l_ac0 = ARR_CURR()
        #FUN-D30032-----mark&add-----str
        #LET l_ac0_t = l_ac0
        #IF p_cmd = 'u' THEN
        #   CLOSE i933_bcl0
        #END IF
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_atj[l_ac0].* = g_atj_t.*
            END IF
            CLOSE i933_bcl0
            EXIT DIALOG
         END IF 
         LET l_ac0_t = l_ac0
         CLOSE i933_bcl0
        #FUN-D30032-----mark&add-----end 

      ON ACTION CONTROLP
           IF INFIELD(atk01) THEN
              CALL cl_init_qry_var()
              #LET g_qryparam.form ="q_atj"  #No.TQC-B60063
              LET g_qryparam.form ="q_atj1"  #No.TQC-B60063
              LET g_qryparam.default1 = g_atj[l_ac0].atk01
              CALL cl_create_qry() RETURNING g_atj[l_ac0].atk01
              NEXT FIELD atk01
           END IF

   END INPUT
#by FUN-B50001 101109   end

 # INPUT ARRAY g_atk WITHOUT DEFAULTS FROM s_atk.*
   INPUT ARRAY g_atk FROM s_atk.*                   #FUN-B50001 
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE, #FUN-B50001 
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)

      BEFORE INPUT
#---> by FUN-B50001 101109   beatk
         IF cl_null(g_atj[l_ac0].atk01) THEN
            CONTINUE DIALOG
         ELSE
            LET g_atk01 = g_atj[l_ac0].atk01
         END IF
#--- by FUN-B50001 101109    end
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_b_flag = '2'     #TQC-D40025 Add 
   
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'                   
            LET g_atk_t.* = g_atk[l_ac].*  #BACKUP
          # BEGIN WORK   #FUN-B50001 mark 
            OPEN i933_bcl USING g_atk00,g_atk01,g_atk_t.atk02,g_atk05,g_atk06 #FUN-B50001      #No.MOD-740269
            IF STATUS THEN
               CALL cl_err("OPEN i933_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i933_bcl INTO g_atk_t.* 
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock atk',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
   
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_atk[l_ac].* TO NULL         #900423
         INITIALIZE g_atk_t.* TO NULL  
         IF l_ac > 1 THEN
            LET g_atk[l_ac].atk03 = g_atk[l_ac-1].atk03
            LET g_atk[l_ac].atk04 = g_atk[l_ac-1].atk04
         END IF
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD atk02
   
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
#---> By FUN-B50001 101109  beatk 
         IF l_ac = 1 THEN 
            UPDATE atk_file SET atk02 = g_atk[l_ac].atk02,atk03 = g_atk[l_ac].atk03,atk04 = g_atk[l_ac].atk04
             WHERE atk00 = g_atk00 AND atk01 = g_atk01 AND atk05 = g_atk05 AND atk06 = g_atk06
         ELSE
            INSERT INTO atk_file (atk00,atk01,atk02,atk03,atk04,atk05,atk06)  #No:MOD-470041 #No.FUN-740020
               VALUES(g_atk00,g_atk01,g_atk[l_ac].atk02,g_atk[l_ac].atk03,  #No.FUN-740020
                      g_atk[l_ac].atk04,g_atk05,g_atk06)
         END IF 
#---> By FUN-B50001 101109  end 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","atk_file",g_atk01,g_atk[l_ac].atk02,SQLCA.sqlcode,"","",1)  #No.FUN-660123 #No.FUN-740020
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
   
      AFTER FIELD atk02
         IF NOT cl_null(g_atk[l_ac].atk02) THEN
            CALL i933_atk()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD atk02
            END IF
         END IF
         IF g_atk[l_ac].atk02 != g_atk_t.atk02 OR
            cl_null(g_atk_t.atk02) THEN
            SELECT COUNT(*) INTO l_n FROM atk_file
             WHERE atk02 = g_atk[l_ac].atk02 
            IF l_n > 0 THEN    #科目已存在其他群組中
               IF NOT cl_confirm('agl-919') THEN
                  NEXT FIELD atk02
               END IF
            END IF
            SELECT count(*) INTO l_n FROM atk_file 
             WHERE atk01 = g_atk01 AND atk02 = g_atk[l_ac].atk02
               AND atk00 = g_atk00  #No.FUN-740020
               AND atk05 = g_atk05 #FUN-B50001 
               AND atk06 = g_atk06 #FUN-B50001 
            IF l_n <> 0 THEN
               LET g_atk[l_ac].atk02 = g_atk_t.atk02
               CALL cl_err('','-239',0) 
               NEXT FIELD atk02
            END IF
         END IF
   
      AFTER FIELD atk03
         IF NOT cl_null(g_atk[l_ac].atk03) THEN
            IF g_atk[l_ac].atk03 NOT MATCHES '[-+]' THEN 
               NEXT FIELD atk03 
            END IF
         END IF
   
      AFTER FIELD atk04
         IF NOT cl_null(g_atk[l_ac].atk04) THEN
            IF g_atk[l_ac].atk04 NOT MATCHES '[123456]' THEN
               NEXT FIELD atk04
            END IF 
         END IF
   
      BEFORE DELETE                                    #modify:Mandy
         #判斷是否可以刪除此ROW,因為此ROW可能和其它file有key值的關聯性,
         #所以不能隨便亂刪掉
         CALL i933_atk_delyn() RETURNING l_atk_delyn 
         IF g_atk_t.atk02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN   #詢問是否確定
               CANCEL DELETE
            END IF
            IF l_atk_delyn = 'N ' THEN   #為不可刪除此ROW的狀態下
               #人工輸入金額設定作業中此ROW已被使用,不可刪除!!
               CALL cl_err(g_atk_t.atk02,'agl-918',0) 
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM atk_file WHERE atk00 = g_atk00  #No.FUN-740020
                                   AND atk01 = g_atk01 AND atk02 = g_atk_t.atk02 
                                   AND atk05 = g_atk05 AND atk06 = g_atk06 #FUN-B50001  add 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","atk_file",g_atk01,g_atk_t.atk02,SQLCA.sqlcode,"","",1)  #No.FUN-660123 #No.FUN-740020
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
   
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_atk[l_ac].* = g_atk_t.*
            CLOSE i933_bcl
       #    ROLLBACK WORK #FUN-B50001
       #    EXIT INPUT    #FUN-B50001 
            EXIT DIALOG   #FUN-B50001 
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_atk[l_ac].atk02,-263,1)
            LET g_atk[l_ac].* = g_atk_t.*
         ELSE
            UPDATE atk_file SET atk02 = g_atk[l_ac].atk02,
                                atk03 = g_atk[l_ac].atk03,
                                atk04 = g_atk[l_ac].atk04 
             WHERE atk00=g_atk00  #No.FUN-740020
               AND atk01=g_atk01 AND atk02=g_atk_t.atk02
               AND atk05=g_atk05 AND atk06=g_atk06 #FUN-B50001 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","atk_file",g_atk01,g_atk_t.atk02,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-740020
               LET g_atk[l_ac].* = g_atk_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
        #      COMMIT WORK   #FUN-B50001 
            END IF
         END IF
   
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D30032 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_atk[l_ac].* = g_atk_t.*
            END IF
            CLOSE i933_bcl
       #    ROLLBACK WORK   #FUN-B50001 
       #    EXIT INPUT      #FUN-B50001 
            EXIT DIALOG     #FUN-B50001 
         END IF
         LET l_ac_t = l_ac  #FUN-D30032 Add 
         CLOSE i933_bcl
       # COMMIT WORK        #FUN-B50001 
   
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(atk02) AND l_ac > 1 THEN
            LET g_atk[l_ac].* = g_atk[l_ac-1].*
            NEXT FIELD atk02
         END IF
   
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
   
      #TQC-C30136--mark--str--
      #ON ACTION CONTROLG
      #   CALL cl_cmdask()
      #TQC-C30136--mark--end--
   
      ON ACTION controlp
         CASE
            WHEN INFIELD(atk02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_atk[l_ac].atk02
               LET g_qryparam.arg1 = g_atk00      #No.TQC-740093
               LET g_qryparam.where = "aag07 != '1'"  #by FUN-B50001 101221  add 
               CALL cl_create_qry() RETURNING g_atk[l_ac].atk02
               DISPLAY BY NAME g_atk[l_ac].atk02        #No:MOD-490344
               CALL i933_atk()
               NEXT FIELD atk02
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
#No.FUN-6B0029--beatk                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
         
   END INPUT
#---> by FUN-B50001 101109   beatk
   BEFORE DIALOG
      CALL cl_set_act_visible("close,append", FALSE)
      BEGIN WORK
      #TQC-D40025--add--begin--
      CASE g_b_flag
           WHEN '1' NEXT FIELD atk01
           WHEN '2' NEXT FIELD atk02
      END CASE
      #TQC-D40025--add--end---

   ON ACTION accept
      ACCEPT DIALOG
   
   ON ACTION cancel
      #TQC-D40025--------ADD----STR
      LET INT_FLAG = 0
      IF g_b_flag = '1' THEN
          IF p_cmd = 'u' THEN
             LET g_atj[l_ac0].* = g_atj_t.*
          ELSE
             CALL g_atj.deleteElement(l_ac0)
             IF g_rec_b0 != 0 THEN
                LET g_action_choice = "detail"  
             END IF  
          END IF
          CLOSE i933_bcl0
          ROLLBACK WORK
       END IF
       IF g_b_flag = '2' THEN
          IF p_cmd = 'u' THEN
             LET g_atk[l_ac].* = g_atk_t.*
          ELSE
             CALL g_atk.deleteElement(l_ac)
             IF g_rec_b != 0 THEN
                LET g_action_choice = "detail"
             END IF
          END IF
          CLOSE i933_bcl
          ROLLBACK WORK
       END IF
      #TQC-D40025--------ADD----END
      EXIT DIALOG

   ON ACTION CONTROLG
      CALL cl_cmdask()

   ON ACTION about
      CALL cl_about()

   ON ACTION help
      CALL cl_show_help()

   END DIALOG

  #IF INT_FLAG THEN
  #   LET INT_FLAG = 0
  #   CLOSE i933_bcl
  #   ROLLBACK WORK
  #   RETURN
  #END IF
#---> by FUN-B50001 101109   end
   CLOSE i933_bcl0    #TQC-D40025 Add
   CLOSE i933_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i933_atk()
DEFINE 
   l_atkacti    LIKE aag_file.aagacti    #No.FUN-680098 VARCHAR(1)

   LET g_errno = ' '
   SELECT aag02,aagacti INTO g_atk[l_ac].aag02,l_atkacti FROM aag_file
    WHERE aag01 = g_atk[l_ac].atk02 
    AND aag00 = g_atk00               #No.MOD-740269
   CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-001'
        WHEN l_atkacti = 'N'     LEt g_errno = '9028'
        OTHERWISE
   END CASE
END FUNCTION

FUNCTION i933_atk_delyn()
DEFINE 
   l_delyn       LIKE type_file.chr1,      #存放可否刪除的變數  #No.FUN-680098   VARCHAR(1)   
   l_n           LIKE type_file.num5          #No.FUN-680098 SMALLINT
   
   LET l_delyn = 'Y'

   SELECT COUNT(*)  INTO l_n FROM atl_file 
    WHERE atl01 = g_atk01
      AND atl02 = g_atk[l_ac].atk02 
      AND atk00 = g_atk00  #No.FUN-740020
      AND atl08 = g_atk05  #FUN-B50001 
      AND atl09 = g_atk06  #FUN-B50001 
   IF l_n > 0 THEN 
      LET l_delyn = 'N'
   END IF
   RETURN l_delyn
END FUNCTION

FUNCTION i933_b_askkey()
   CLEAR FORM
   CALL g_atk.clear()
   CONSTRUCT g_wc2 ON atk05,atk06,atk00,atk01,atk02,atk03,atk04 #FUN-B50001 add atk05,atk06  #螢幕上取條件 #No.FUN-740020
        FROM atk05,atk06,atk00,atk01,s_atk[1].atk02,s_atk[1].atk03,s_atk[1].atk04 #No.FUN-740020
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
 FUNCTION i933_b_fill(p_atk01)  #FUN-B50001 
DEFINE p_atk01     LIKE atk_file.atk01 #FUN-B50001   
DEFINE
   p_wc            STRING,             #TQC-630166   
   l_flag          LIKE type_file.chr1,              #有無單身筆數        #No.FUN-680098 VARCHAR(1)
   l_sql           STRING        #TQC-630166        
 
   LET l_sql = "SELECT atk02,aag02,atk03,atk04 ",
               "  FROM atk_file,OUTER aag_file",
             # " WHERE atk01 = '",g_atk01,"'",   #FUN-B50001 
               " WHERE atk01 = '",p_atk01,"'",   #FUN-B50001 
               "   AND atk00 = '",g_atk00,"'",   #No.FUN-740020
               "   AND atk05 = '",g_atk05,"'",   #FUN-B50001 
               "   AND atk06 = '",g_atk06,"'",   #FUN-B50001
               "   AND atk00 = aag00 ",          #No.MOD-740269
             # "   AND atk02 = aag01 AND ",p_wc CLIPPED, #FUN-B50001 
               "   AND atk02 = aag01 ",                  #FUN-B50001 
               " ORDER BY atk02"

   PREPARE atk_pre FROM l_sql
   DECLARE atk_cs CURSOR FOR atk_pre

   CALL g_atk.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH atk_cs INTO g_atk[g_cnt].*     #單身 ARRAY 填充
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
   CALL g_atk.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF l_flag='N' THEN LET g_rec_b=0 END IF     #無單身時將筆數清為零
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION

#---> by FUN-B50001 101220   beatk 
FUNCTION  i933_atk06(p_cmd,p_atk06,p_atk05)  
DEFINE p_cmd           LIKE type_file.chr1,
       p_atk06         LIKE atk_file.atk06,
       l_asg02         LIKE asg_file.asg02,
       l_asg03         LIKE asg_file.asg03,
       l_asg05         LIKE asg_file.asg05,
       l_aaz641        LIKE aaz_file.aaz641,
       l_asa09         LIKE asa_file.asa09,    #FUN-950051
       p_atk05         LIKE atk_file.atk05     #FUN-950051

    LET g_errno = ' '

       SELECT asg02,asg03,asg05 INTO l_asg02,l_asg03,l_asg05
         FROM asg_file
        WHERE asg01 = p_atk06
    CALL s_aaz641_asg(p_atk05,p_atk06) RETURNING g_dbs_asg03
    CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING l_aaz641
    SELECT asg05 INTO l_asg05 FROM asg_file WHERE asg01 = p_atk06
    LET g_atk00 = l_aaz641
    LET g_asg05 = l_asg05

    CASE
       WHEN SQLCA.SQLCODE=100

          LET g_errno = 'agl-988'          #TQC-970018
          LET l_asg02 = NULL
          LET l_asg03 = NULL
       OTHERWISE
          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE

    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_asg02 TO FORMONLY.asg02
       DISPLAY l_asg03 TO FORMONLY.asg03
       DISPLAY g_atk00 TO FORMONLY.atk00
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
#---by FUN-B50001 101109  beatk
   DIALOG ATTRIBUTES(UNBUFFERED)
     DISPLAY ARRAY g_atj TO s_atj.* ATTRIBUTE(COUNT=g_rec_b0)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag='1'     #TQC-D40025 Add
      BEFORE ROW
         LET l_ac0 = ARR_CURR()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         IF l_ac0 > 0 THEN
            CALL i933_b_fill(g_atj[l_ac0].atk01)
         END IF
     END DISPLAY
#---by FUN-B50001 101109 end
     DISPLAY ARRAY g_atk TO s_atk.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag='2'   #TQC-D40025 Add

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
      #FUN-D30032----Add----Str
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DIALOG 
      #FUN-D30032----Add----End

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
      CALL cl_set_comp_entry("atk00,atk01",TRUE)  #No.FUN-740020
    END IF 

END FUNCTION

FUNCTION i933_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("atk00,atk01",FALSE) #No.FUN-740020
    END IF 

END FUNCTION

FUNCTION i933_out()
DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                
     IF cl_null(g_wc) AND NOT cl_null(g_atk00) AND 
        NOT cl_null(g_atk01) 
        THEN LET g_wc=" atk00='",g_atk00,"' AND atk01='",g_atk01,"'"
     END IF                                                                                                                         
     IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF                                                                    
     LET l_cmd = 'p_query "ggli502" "',g_wc CLIPPED,'"'                                                                             
     CALL cl_cmdrun(l_cmd)                                                                                                          
     RETURN                                                                                                                         
END FUNCTION
