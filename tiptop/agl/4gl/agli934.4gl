# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: agli934.4gl
# Descriptions...: 人工輸入金額設定
# Date & Author..: FUN-930155 09/04/23 by Yiting
# Modify.........: No.TQC-980248 09/08/25 By Carrier 帳套進行檢查
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9B0087 09/11/13 By Sarah gio02開窗改成q_gin,檢查也改成檢查gin_file
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-AB0320 10/11/30 By lixia 年度欄位輸入負數控管
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-BC0096 11/12/14 By Carrier 單頭會計科目取值來源gin_file(合並用)應該改為giv_file（個體用）
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE    #FUN-930155
    g_bookno        LIKE aaa_file.aaa01,
    g_aaa           RECORD LIKE aaa_file.*,
    g_gio00         LIKE gio_file.gio00,   #帳套代碼(假單頭)     #No.FUN-740020
    g_gio01         LIKE gio_file.gio01,   #群組代號(假單頭)
    g_gio02         LIKE gio_file.gio02,   #科目編號(假單頭)
    g_gio06         LIKE gio_file.gio06,   #科目編號(假單頭)
    g_gio07         LIKE gio_file.gio07,   #科目編號(假單頭)
    g_gio00_t       LIKE gio_file.gio00,   #帳套代號(舊值)      #No.FUN-740020
    g_gio01_t       LIKE gio_file.gio01,   #群組代號(舊值)
    g_gio02_t       LIKE gio_file.gio02,   #科目編號(舊值)
    g_gio06_t       LIKE gio_file.gio06,   #科目編號(舊值)
    g_gio07_t       LIKE gio_file.gio07,   #科目編號(舊值)
    g_gio           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gio03       LIKE gio_file.gio03,   #編號
        gio04       LIKE gio_file.gio04,   #說明
        gio05       LIKE gio_file.gio05    #金額
                    END RECORD,
    g_gio_t         RECORD                 #程式變數 (舊值)
        gio03       LIKE gio_file.gio03,   #編號
        gio04       LIKE gio_file.gio04,   #說明
        gio05       LIKE gio_file.gio05    #金額
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,        #TQC-630166  
    g_delete        LIKE type_file.chr1,      #若刪除資料,則要重新顯示筆數  #No.FUN-680098    VARCHAR(1) 
    g_rec_b         LIKE type_file.num5,      #單身筆數        #No.FUN-680098 SMALLINT
    l_ac            LIKE type_file.num5       #目前處理的ARRAY CNT        #No.FUN-680098 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680098  SMALLINT
DEFINE   g_cnt              LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_i                LIKE type_file.num5          #cont/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE   g_msg              LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE   g_row_count        LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_curs_index       LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_jump             LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   mi_no_ask          LIKE type_file.num5          #No.FUN-680098  SMALLINT
DEFINE   g_sql_tmp          STRING                       #No.MOD-740268
 
MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5             #開窗的位置       #No.FUN-680098 SMALLINT
#       l_time    LIKE type_file.chr8              #No.FUN-6A0073
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
     LET p_row = ARG_VAL(2)     #No.MOD-4C0171                 #取得螢幕位置
     LET p_col = ARG_VAL(3)     #No.MOD-4C0171
    LET g_gio00      = NULL                #清除鍵值        #No.FUN-740020
    LET g_gio01      = NULL                #清除鍵值
    LET g_gio00_t    = NULL       #No.FUN-740020
    LET g_gio01_t    = NULL
    IF g_bookno = ' ' OR g_bookno IS NULL THEN LET g_bookno = g_aaz.aaz64 END IF
    SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = g_bookno
    LET p_row = 3 LET p_col = 16
    OPEN WINDOW i934_w AT p_row,p_col      #顯示畫面
      WITH FORM "agl/42f/agli934"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
        
 
 
    LET g_delete = 'N'
    CALL i934_menu()
    CLOSE WINDOW i934_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i934_cs()
    CLEAR FORM                              #清除畫面
        CALL g_gio.clear()
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0029
 
   INITIALIZE g_gio00 TO NULL    #No.FUN-750051
   INITIALIZE g_gio01 TO NULL    #No.FUN-750051
   INITIALIZE g_gio02 TO NULL    #No.FUN-750051
   INITIALIZE g_gio06 TO NULL    #No.FUN-750051
   INITIALIZE g_gio07 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON gio06,gio07,gio00,gio01,gio02,gio03,gio04,gio05 #螢幕上取條件     #No.FUN-740020
        FROM  gio06,gio07,gio00,      #No.FUN-740020
              gio01,gio02,s_gio[1].gio03,s_gio[1].gio04,s_gio[1].gio05
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
    ON ACTION controlp                 # 沿用所有欄位
       CASE
          #No.FUN-740020   ---being
          WHEN INFIELD(gio00)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aaa"    #No.MOD-740268
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO gio00
             NEXT FIELD gio00 
          #No.FUN-740020   ---end
          WHEN INFIELD(gio01)
#            CALL q_gir(4,4,g_gio01) RETURNING g_gio01
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_gir"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO gio01
             NEXT FIELD gio01 
          WHEN INFIELD(gio02)
#            CALL q_gis(4,4,g_gio01,g_gio02) RETURNING l_gio01,g_gio02
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             #No.TQC-BC0096  --Begin
             #LET g_qryparam.form ="q_gin"  #MOD-9B0087 mod q_gis->q_gin
             LET g_qryparam.form ="q_giv"
             #No.TQC-BC0096  --End  
            #LET g_qryparam.multiret_index = "2"   #MOD-9B0087 mark
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO gio02
             NEXT FIELD gio02 
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
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN RETURN END IF
    LET g_sql="SELECT UNIQUE gio00,gio01,gio02,gio06,gio07 FROM gio_file ",     #No.FUN-740020
              "    WHERE ", g_wc CLIPPED,
              "    ORDER BY gio00,gio01 "  #No.TQC-740093
    PREPARE i934_prepare FROM g_sql              #預備一下
    DECLARE i934_b_cs                            #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i934_prepare
                                                 #計算本次查詢單頭的筆數
   #No.MOD-740268  --Begin
   #LET g_sql="SELECT COUNT(DISTINCT gio01) FROM gio_file ",
   LET g_sql_tmp ="SELECT UNIQUE gio00,gio01,gio02,gio06,gio07 FROM gio_file ",     
              "    WHERE ", g_wc CLIPPED,
              " INTO TEMP x "
    DROP TABLE x
    PREPARE i934_precount_x FROM g_sql_tmp  
    EXECUTE i934_precount_x
    LET g_sql="SELECT COUNT(*) FROM x"
   #No.MOD-740268  --End 
    PREPARE i934_precount FROM g_sql
    DECLARE i934_count CURSOR FOR i934_precount
END FUNCTION
 
FUNCTION i934_menu()
   DEFINE l_cmd    LIKE  type_file.chr1000   #NO.FUN-7C0043
   WHILE TRUE
      CALL i934_bp("G")
      CASE g_action_choice
           WHEN "insert" 
                IF cl_chk_act_auth() THEN 
                   CALL i934_a()
                END IF
           WHEN "query" 
                IF cl_chk_act_auth() THEN
                   CALL i934_q()
                END IF
           WHEN "next" 
                CALL i934_fetch('N')
           WHEN "previous" 
                CALL i934_fetch('P')
           WHEN "delete" 
            IF cl_chk_act_auth() THEN
                CALL i934_r()
            END IF
           WHEN "detail" 
                IF cl_chk_act_auth() THEN
                   CALL i934_b()
                ELSE
                   LET g_action_choice = NULL
                END IF
           WHEN "output" 
                IF cl_chk_act_auth() THEN
                   CALL i934_out()                                                                                                 
                END IF
           WHEN "help" 
                CALL cl_show_help()
           WHEN "exit"
                 EXIT WHILE
           WHEN "jump"
                CALL i934_fetch('/')
           WHEN "controlg"
                CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_gio01 IS NOT NULL THEN
                  LET g_doc.column1 = "gio01"
                  LET g_doc.value1 = g_gio01
                  LET g_doc.column2 = "gio02"
                  LET g_doc.value2 = g_gio02
                  LET g_doc.column4 = "gio06"
                  LET g_doc.value4 = g_gio06
                  LET g_doc.column5 = "gio07"
                  LET g_doc.value5 = g_gio07
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gio),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
 
#Add  輸入
FUNCTION i934_a()
DEFINE   l_n    LIKE type_file.num5          #No.FUN-680098  SMALLINT
   
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
        CALL g_gio.clear()
    INITIALIZE g_gio00 LIKE gio_file.gio00      #No.FUN-740020
    INITIALIZE g_gio01 LIKE gio_file.gio01
    INITIALIZE g_gio02 LIKE gio_file.gio02
    INITIALIZE g_gio06 LIKE gio_file.gio06
    INITIALIZE g_gio07 LIKE gio_file.gio07
    LET g_gio00_t = NULL       #No.FUN-740020
    LET g_gio01_t = NULL
    LET g_gio02_t = NULL
    LET g_gio06_t = NULL
    LET g_gio07_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i934_i("a")                           #輸入單頭
        IF INT_FLAG THEN                           #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        CALL g_gio.clear()
        SELECT COUNT(*) INTO l_n FROM gio_file 
         WHERE gio01 = g_gio01
           AND gio00 = g_gio00      #No.FUN-740020
           AND gio02 = g_gio02
           AND gio06 = g_gio06
           AND gio07 = g_gio07
        LET g_rec_b = 0                    #No.FUN-680064
        IF l_n > 0 THEN
           CALL i934_b_fill('1=1')
         END IF
        #LET g_rec_b =0 #No.MOD-470583 mark
        CALL i934_b()                             #輸入單身
        LET g_gio01_t = g_gio01                   #保留舊值
        LET g_gio00_t = g_gio00       #No.FUN-740020
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i934_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,                  #a:輸入 u:更改        #No.FUN-680098 VARCHAR(1)
    l_gio01         LIKE gio_file.gio01,
    l_gio00         LIKE gio_file.gio00
 
    DISPLAY g_gio06,g_gio07,g_gio00,g_gio01,g_gio02 TO gio06,gio07,gio00,gio01,gio02       #No.FUN-740020 
 
         LET g_before_input_done = FALSE
         CALL i934_set_entry(p_cmd)
         CALL i934_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
    INPUT g_gio06,g_gio07,g_gio00,g_gio01,g_gio02      #No.FUN-740020
        WITHOUT DEFAULTS
        FROM gio06,gio07,gio00,gio01,gio02      #No.FUN-740020
 
        #No.TQC-980248  --Begin
        AFTER FIELD gio00
           IF NOT cl_null(g_gio00) THEN
              CALL i934_gio00(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_gio00,g_errno,0)
                 NEXT FIELD gio00
              END IF
           END IF
        #No.TQC-980248  --End
 
#TQC-AB0320--add---str---
       AFTER FIELD gio06
          IF NOT cl_null(g_gio06) AND g_gio06 < 0 THEN
             CALL cl_err('', 'afa-370', 0)
             NEXT FIELD gio06
          END IF
#TQC-AB0320--add---end---

        AFTER FIELD gio07
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_gio07) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_gio06
            IF g_azm.azm02 = 1 THEN
               IF g_gio07 > 12 OR g_gio07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD gio07
               END IF
            ELSE
               IF g_gio07 > 13 OR g_gio07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD gio07
               END IF
            END IF
         END IF
#           IF NOT cl_null(g_gio07) THEN
#              IF g_gio07 < 1 OR g_gio07 > 12 THEN
#                 NEXT FIELD gio07
#              END IF
#           END IF
#No.TQC-720032 -- end --
 
        AFTER FIELD gio01  #群組代號                
           IF NOT cl_null(g_gio01) THEN
              CALL i934_gio01('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_gio01,g_errno,0)
                 LET g_gio01 = g_gio01_t
                 DISPLAY g_gio01 TO gio01
                 NEXT FIELD gio01
              END IF
           END IF
 
        AFTER FIELD gio02  #科目編號
           IF NOT cl_null(g_gio02) THEN
              CALL i934_gio02('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_gio02,g_errno,0)
                 LET g_gio02 = g_gio02_t
                 DISPLAY g_gio02 TO gio02
                 NEXT FIELD gio02
              END IF
           END IF
 
        ON ACTION CONTROLP                 # 沿用所有欄位
           CASE
              #No.MOD-740268   ---begin
              WHEN INFIELD(gio00)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"    
                  LET g_qryparam.default1 = g_gio00
                  CALL cl_create_qry() RETURNING g_gio00 
                  DISPLAY g_gio00 TO gio00
                  NEXT FIELD gio00 
              #No.MOD-740268   ---end
              WHEN INFIELD(gio01)
#                CALL q_gir(4,4,g_gio01) RETURNING g_gio01
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gir"
                 LET g_qryparam.default1 = g_gio01
                 CALL cl_create_qry() RETURNING g_gio01
                 DISPLAY g_gio01 TO gio01
                 NEXT FIELD gio01 
              WHEN INFIELD(gio02)
#                CALL q_gis(4,4,g_gio01,g_gio02) RETURNING l_gio01,g_gio02
                 CALL cl_init_qry_var()
                 #No.TQC-BC0096  --Begin 
                #LET g_qryparam.form ="q_gin"  #MOD-9B0087 mod q_gis->q_gin
                 LET g_qryparam.form ="q_giv"
                 #No.TQC-BC0096  --End   
                 LET g_qryparam.arg1 = g_gio00     #No.TQC-740093
                 LET g_qryparam.arg2 = g_gio01     #MOD-9B0087 add
                 LET g_qryparam.default1 = g_gio02  #MOD-9B0087 mod
                #LET g_qryparam.default2 = g_gio02  #MOD-9B0087 mark
                #CALL cl_create_qry() RETURNING l_gio01,g_gio02  #MOD-9B0087 mark
                 CALL cl_create_qry() RETURNING g_gio02          #MOD-9B0087
                 DISPLAY g_gio02 TO gio02
                 NEXT FIELD gio02 
              OTHERWISE
                 EXIT CASE
          END CASE
#No.FUN-6B0029--begin                                             
        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
        #-----END TQC-860018-----
    END INPUT
END FUNCTION
 
FUNCTION i934_gio01(p_cmd) #群組代碼
DEFINE
    p_cmd      LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
    l_gir02    LIKE gir_file.gir02
 
   LET g_errno=''
   SELECT gir02 INTO l_gir02
       FROM gir_file
       WHERE gir01 = g_gio01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-917' #無此群組代碼!!
                                LET l_gir02=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
       DISPLAY l_gir02 TO FORMONLY.gir02 
   END IF
END FUNCTION
 
FUNCTION i934_gio02(p_cmd) #科目編號
DEFINE
    p_cmd      LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
    l_aag02  LIKE aag_file.aag02
 
   LET g_errno=''
  #str MOD-9B0087 mod
  #SELECT * FROM gis_file
  # WHERE gis01 = g_gio01
  #   AND gis00 = g_gio00       #No.FUN-740020
  #   AND gis02 = g_gio02
  #   AND gis04 = '4'   #人工輸入
   #No.TQC-BC0096  --Begin
   #SELECT * FROM gin_file
   # WHERE gin00 = g_gio00
   #   AND gin01 = g_gio01
   #   AND gin02 = g_gio02
   SELECT * FROM giv_file
    WHERE giv00 = g_gio00
      AND giv01 = g_gio01
      AND giv02 = g_gio02
   #No.TQC-BC0096  --End  
  #end MOD-9B0087 mod
   CASE
      WHEN SQLCA.sqlcode=100   LET g_errno='agl-001' #無此科目編號!!
                               RETURN   #MOD-9B0087 add
      OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = g_gio02
                                             AND aag00 = g_gio00      #No.FUN-740020
   CASE
      WHEN SQLCA.sqlcode=100   LET g_errno='agl-001' #無此科目編號!!
      OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF cl_null(g_errno) THEN 
      DISPLAY l_aag02 TO FORMONLY.aag02
   END IF
END FUNCTION
 
#Query 查詢
FUNCTION i934_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i934_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i934_b_cs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_gio01 TO NULL
    ELSE
        CALL i934_fetch('F')               #讀出TEMP第一筆並顯示
        OPEN i934_count
        FETCH i934_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  #
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i934_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式          #No.FUN-680098 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680098 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i934_b_cs INTO g_gio00,g_gio01,g_gio02,g_gio06,g_gio07       #No.FUN-740020
        WHEN 'P' FETCH PREVIOUS i934_b_cs INTO g_gio00,g_gio01,g_gio02,g_gio06,g_gio07       #No.FUN-740020
        WHEN 'F' FETCH FIRST    i934_b_cs INTO g_gio00,g_gio01,g_gio02,g_gio06,g_gio07       #No.FUN-740020
        WHEN 'L' FETCH LAST     i934_b_cs INTO g_gio00,g_gio01,g_gio02,g_gio06,g_gio07       #No.FUN-740020
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
            FETCH ABSOLUTE g_jump i934_b_cs INTO g_gio00,g_gio01,g_gio02,g_gio06,g_gio07     #No.FUN-740020
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_gio01,SQLCA.sqlcode,0)
       INITIALIZE g_gio01 TO NULL             #No.FUN-6B0040  add
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
 
    CALL i934_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i934_show()
    DISPLAY g_gio06,g_gio07,g_gio00,g_gio01,g_gio02 TO gio06,gio07,gio00,gio01,gio02    #單頭    #No.FUN-740020
    CALL i934_gio01('d')
    CALL i934_gio02('d')
    CALL i934_b_fill(g_wc)                    #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i934_r()
    IF s_shut(0) THEN RETURN END IF           #檢查權限
    IF g_gio01 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6B0040
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                      #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "gio01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_gio01       #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "gio02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_gio02       #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "gio06"      #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_gio06       #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "gio07"      #No.FUN-9B0098 10/02/24
        LET g_doc.value5 = g_gio07       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                   #No.FUN-9B0098 10/02/24
        DELETE FROM gio_file WHERE gio01 = g_gio01
                               AND gio00 = g_gio00      #No.FUN-740020
                               AND gio02 = g_gio02
                               AND gio06 = g_gio06
                               AND gio07 = g_gio07
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("del","gio_file",g_gio01,g_gio02,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660123
        ELSE
            CLEAR FORM
            #No.MOD-740268  --Begin
            DROP TABLE x
            PREPARE i934_precount_x2 FROM g_sql_tmp  
            EXECUTE i934_precount_x2                 
            #No.MOD-740268  --End
            CALL g_gio.clear()
            LET g_delete='Y'
            LET g_gio00 = NULL
            LET g_gio01 = NULL
            LET g_gio02 = NULL
            LET g_gio06 = NULL
            LET g_gio07 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i934_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i934_b_cs
               CLOSE i934_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i934_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i934_b_cs
               CLOSE i934_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i934_b_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i934_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i934_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i934_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680098 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680098 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680098 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680098 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680098 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680098 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF        #檢查權限
   IF g_gio01 IS NULL OR g_gio02 IS NULL THEN
       RETURN
   END IF
 
   CALL cl_opmsg('b')                #單身處理的操作提示
   SELECT azi04 INTO g_azi04        #幣別檔小數位數讀取
     FROM azi_file
    WHERE azi01=g_aaa.aaa03
 
   LET g_forupd_sql = "SELECT gio03,gio04,gio05 FROM gio_file",
                      " WHERE gio00 = ? AND gio01 =? AND gio02 =? AND gio06 =?",     #No.FUN-740020
                      "   AND gio07 =? AND gio03 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i934_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_gio WITHOUT DEFAULTS FROM s_gio.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b>=l_ac THEN
            LET p_cmd='u'                   
            LET g_gio_t.* = g_gio[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i934_bcl USING g_gio00,g_gio01,g_gio02,g_gio06,g_gio07,g_gio_t.gio03
            IF STATUS THEN
               CALL cl_err("OPEN i934_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i934_bcl INTO g_gio_t.* 
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock gio',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      AFTER FIELD gio03
         IF NOT cl_null(g_gio[l_ac].gio03) THEN
            IF g_gio[l_ac].gio03 != g_gio_t.gio03 OR g_gio_t.gio03 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM gio_file 
                WHERE gio01 = g_gio01 
                  AND gio00 = g_gio00      #No.FUN-740020
                  AND gio02 = g_gio02
                  AND gio06 = g_gio06
                  AND gio07 = g_gio07
                  AND gio03 = g_gio[l_ac].gio03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gio[l_ac].gio03 = g_gio_t.gio03
                  NEXT FIELD gio03
               END IF
            END IF
         END IF
 
      AFTER FIELD gio05
      # No.TQC-740305 --begin
         IF g_gio[l_ac].gio05 < 0 THEN
            LET g_gio[l_ac].gio05 = NULL
            NEXT FIELD gio05
         END IF 
      # No.TQC-740305 --end
         IF NOT cl_null(g_gio[l_ac].gio05) THEN
            LET g_gio[l_ac].gio05 = cl_numfor(g_gio[l_ac].gio05,15,g_azi04)
         END IF
     
      BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_gio[l_ac].* TO NULL         #900423
          LET g_gio_t.* = g_gio[l_ac].*            #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD gio03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO gio_file (gio00,gio01,gio02,gio03,gio06,gio07,gio04,gio05)  #No.MOD-470041   #No.FUN-740020
              VALUES(g_gio00,g_gio01,g_gio02,g_gio[l_ac].gio03,g_gio06,g_gio07,       #No.FUN-740020
                     g_gio[l_ac].gio04,g_gio[l_ac].gio05)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_gio[l_ac].gio03,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","gio_file",g_gio01,g_gio02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      BEFORE DELETE                                #是否取消單身
         IF g_gio_t.gio03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN             #詢問是否確定
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM gio_file
             WHERE gio01 = g_gio01
               AND gio00 = g_gio00      #No.FUN-740020
               AND gio02 = g_gio02
               AND gio06 = g_gio06
               AND gio07 = g_gio07
               AND gio03 = g_gio_t.gio03 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_gio_t.gio03,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("del","gio_file",g_gio01,g_gio02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_gio[l_ac].* = g_gio_t.*
             CLOSE i934_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_gio[l_ac].gio03,-263,1)
             LET g_gio[l_ac].* = g_gio_t.*
          ELSE
             UPDATE gio_file SET gio03 = g_gio[l_ac].gio03,
                                 gio04 = g_gio[l_ac].gio04,
                                 gio05 = g_gio[l_ac].gio05 
              WHERE gio01 = g_gio01 
                AND gio00= g_gio00     #No.FUN-740020
                AND gio02 = g_gio02
                AND gio06 = g_gio06
                AND gio07 = g_gio07
                AND gio03 = g_gio_t.gio03
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_gio[l_ac].gio03,SQLCA.sqlcode,0)   #No.FUN-660123
                CALL cl_err3("upd","gio_file",g_gio01,g_gio02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                LET g_gio[l_ac].* = g_gio_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
      AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-C30032 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
            #LET g_gio[l_ac].* = g_gio_t.*  #FUN-C30032 mark
             #FUN-D30032--add--begin--
             IF p_cmd = 'u' THEN
                LET g_gio[l_ac].* = g_gio_t.*
             ELSE
                CALL g_gio.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             END IF 
             #FUN-D30032--add--end----
             CLOSE i934_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-C30032 add
          LET g_gio_t.* = g_gio[l_ac].*
          CLOSE i934_bcl
          COMMIT WORK
 
#     ON ACTION CONTROLN
#        CALL i934_b_askkey()
#        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gio03) AND l_ac > 1 THEN
            LET g_gio[l_ac].* = g_gio[l_ac-1].*
            NEXT FIELD gio03
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT
 
 
   CLOSE i934_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i934_b_askkey()
   CLEAR FORM
   CALL g_gio.clear()
   CONSTRUCT g_wc2 ON gio03,gio04,gio05                #螢幕上取條件
       FROM s_gio[1].gio03,s_gio[1].gio04,s_gio[1].gio05
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CALL i934_b_fill(g_wc2)
END FUNCTION
   
FUNCTION i934_b_fill(p_wc)              #BODY FILL UP
DEFINE
#   p_wc            VARCHAR(300),
    p_wc            STRING,        #TQC-630166    
    l_flag          LIKE type_file.chr1,              #有無單身筆數        #No.FUN-680098 VARCHAR(1)
#   l_sql           VARCHAR(300)     #No.FUN-680098
    l_sql           STRING        #TQC-630166        
 
    LET l_sql = "SELECT gio03,gio04,gio05 FROM gio_file",
                " WHERE gio01 = '",g_gio01,"'",
                "   AND gio00 = '",g_gio00,"'",      #No.FUN-740020
                "   AND gio02 = '",g_gio02,"'",
                "   AND gio06 = '",g_gio06,"'",
                "   AND gio07 = '",g_gio07,"'",
                "   AND ",p_wc CLIPPED,
                " ORDER BY gio03"  #No.TQC-740093
 
    PREPARE gio_pre FROM l_sql
    DECLARE gio_cs CURSOR FOR gio_pre
 
    CALL g_gio.clear()
    LET g_cnt = 1
    LET l_flag='N'
    LET g_rec_b=0
    FOREACH gio_cs INTO g_gio[g_cnt].*     #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt=g_cnt+1
       LET l_flag='Y'
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gio.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    IF l_flag='N' THEN LET g_rec_b=0 END IF     #無單身時將筆數清為零
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i934_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gio TO s_gio.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL i934_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i934_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL i934_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i934_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL i934_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
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
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i934_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("gio01",TRUE)
    END IF 
 
END FUNCTION
 
FUNCTION i934_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("gio01",FALSE) 
    END IF 
END FUNCTION
 
FUNCTION i934_out()
     DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                
     IF cl_null(g_wc) AND NOT cl_null(g_gio00) AND NOT cl_null(g_gio01) AND NOT cl_null(g_gio02) AND NOT cl_null(g_gio06) AND NOT cl_null(g_gio07)
        THEN LET g_wc=" gio00='",g_gio00,"' AND gio01='",g_gio01,"' AND gio02='",g_gio02,"' AND gio06='",g_gio06,"' AND gio07='",g_gio07,"'"
     END IF                                                                                                                         
     IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF                                                                    
     LET l_cmd = 'p_query "agli934" "',g_wc CLIPPED,'"'                                                                             
     CALL cl_cmdrun(l_cmd)                                                                                                          
     RETURN                                                                                                                         
END FUNCTION
 
#No.TQC-980248  --Begin
FUNCTION i934_gio00(p_cmd)
DEFINE   p_cmd       LIKE type_file.chr1
DEFINE   l_aaaacti   LIKE aaa_file.aaaacti
 
   LET g_errno = ' '
 
   SELECT aaaacti INTO l_aaaacti FROM aaa_file
    WHERE aaa01 = g_gio00
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-062'
        WHEN l_aaaacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
END FUNCTION
#No.TQC-980248  --End  
