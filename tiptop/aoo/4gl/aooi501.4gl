# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: aooi501.4gl
# Descriptions...: 公式維護作業
# Date & Author..: 05/08/24 By Lifeng
# Modify.........: No.FUN-610022 06/01/16 By jackie 修改報表dash線顯示不出
#                                                   以及將部分功能選項改為按鈕
# Modify.........: NO.TQC-630074 06/03/07 By Echo 流程訊息通知功能
# Modify.........: NO.MOD-640497 06/04/17 By Claire 顯示公式簡名
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-660157 06/06/22 By Echo p_flow功能補強
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0015 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6C0166 06/12/27 By Ray 無效按鈕無效
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760083 07/07/12 By mike 報表格式修改為crystal reports
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-960096 10/11/04 By sabrina _copy()內如果SQL不成功，RETURN之前少了ROLLBACK WORK 
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80035 11/08/03 By Lujh 模組程序撰寫規範修正
# Modify.........: No.CHI-C30107 12/06/14 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.MOD-CC0061 12/12/07 By zhangll gepacti缺少赋值
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D20059 13/03/26 By xumm 取消確認賦值確認異動日期
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
  g_gep        RECORD LIKE gep_file.*,
  g_gep_t      RECORD LIKE gep_file.*,
  g_gep_o      RECORD LIKE gep_file.*,
  g_gep01_t    LIKE gep_file.gep01,      #公式編號 (舊值)
  g_gep05_t    LIKE gep_file.gep05,      #公式內容 (舊值)
 
  g_geq        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables),存放變量信息
     geq02     LIKE geq_file.geq02,      #項次
     geq03     LIKE geq_file.geq03,      #變量名稱
     ges02     LIKE ges_file.ges02       #變量說明
  END RECORD,
  g_ger        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables),存放子公式信息
    ger02      LIKE ger_file.ger02,      #項次
    ger03      LIKE ger_file.ger03,      #子公式名稱
    gep02a     LIKE gep_file.gep02       #子公式說明
  END RECORD,
 
  g_wc,g_wc2,g_wc3,g_sql STRING,       
  g_before_input_done    LIKE type_file.num5,          #No.FUN-680102 SMALLINT
 
  g_rec_b       LIKE type_file.num5,           #單身筆數        #No.FUN-680102 SMALLINT
  g_rec_d       LIKE type_file.num5,           #No.FUN-680102SMALLINT     #單身筆數
  l_ac          LIKE type_file.num5,           #目前處理的ARRAY CNT       #No.FUN-680102 SMALLINT
  l_cmdstr      LIKE type_file.chr1000,        #No.FUN-680102CHAR(100), 
  g_forupd_sql  STRING,                       #SELECT ... FOR UPDATE   SQL    
  g_chr         LIKE gep_file.gep03,          #No.FUN-680102 VARCHAR(1)
  g_cnt         LIKE type_file.num10,         #No.FUN-680102 INTEGER
  g_msg         LIKE ze_file.ze03,            #No.FUN-680102 VARCHAR(72),
  g_curs_index  LIKE type_file.num10,         #No.FUN-680102 INTEGER
  g_row_count   LIKE type_file.num10,         #總筆數                     #No.FUN-680102 INTEGER
  g_jump        LIKE type_file.num10,         #查詢指定的筆數             #No.FUN-680102 INTEGER
  g_forex       STRING,                       #范例字符串
  g_no_ask     LIKE type_file.num5           #是否開啟指定筆視窗         #No.FUN-680102 SMALLINT
DEFINE g_argv1  LIKE gep_file.gep01           #No.FUN-680102 VARCHAR(16)     #單號           #TQC-630074
DEFINE g_argv2  STRING                        #指定執行的功能 #TQC-630074
DEFINE g_str    STRING                        #No.FUN-760083 
DEFINE   g_result            LIKE type_file.num20_6   #No.FUN-680102DEC(20,6)
 
MAIN
  OPTIONS                            #改變一些系統預設值
    INPUT NO WRAP
  DEFER INTERRUPT                    #擷取中斷鍵, 由程式處理
 
   LET g_argv1=ARG_VAL(1)           #TQC-630074
   LET g_argv2=ARG_VAL(2)           #TQC-630074
 
  IF (NOT cl_user()) THEN
     EXIT PROGRAM
  END IF
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF (NOT cl_setup("AOO")) THEN
     EXIT PROGRAM
  END IF
 
  CALL cl_used(g_prog,g_time,1) RETURNING g_time    #計算使用時間 (進入時間)   #No.FUN-6A0081
 
  LET g_forupd_sql = "SELECT * FROM gep_file WHERE gep01 = ? FOR UPDATE"
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE i501_cl CURSOR FROM g_forupd_sql
 
  OPEN WINDOW i501_w WITH FORM "aoo/42f/aooi501"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_init()

  #取得范例文本
  LET g_forex = cl_fml_example()
 
  DISPLAY g_forex TO FORMONLY.forex
 
  #No.TQC-630074 --start--
  IF NOT cl_null(g_argv1) THEN
     CASE g_argv2
        WHEN "query"
           LET g_action_choice = "query"
           IF cl_chk_act_auth() THEN
              CALL i501_q()
           END IF
        WHEN "insert"
           LET g_action_choice = "insert"
           IF cl_chk_act_auth() THEN
              CALL i501_a()
           END IF
        OTHERWISE                       #FUN-660157
           CALL i501_q()
     END CASE
  END IF
  #No.TQC-630074 ---end---
 
  CALL i501_menu()
 
  #關閉窗體
  CLOSE WINDOW i501_w

  CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-6A0081
END MAIN
 
#QBE 查詢資料
FUNCTION i501_cs()
  CLEAR FORM                          #清除畫面
  CALL g_geq.clear()
  CALL g_ger.clear()
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   #TQC-630074
   IF NOT cl_null(g_argv1) THEN
      LET g_wc =" gep01 = '",g_argv1,"'"    #No.TQC-630074
   ELSE
   INITIALIZE g_gep.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON gep01,gep02,gep03,gep04,gep07,gep05,gep06,
                               gepuser,gepgrup,gepmodu,gepdate
    
                 #No.FUN-580031 --start--     HCN
                 BEFORE CONSTRUCT
                    CALL cl_qbe_init()
                 #No.FUN-580031 --end--       HCN
   
        ON ACTION controlp
           CASE
              WHEN INFIELD(gep01)        #公式名稱
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.form ="q_gep"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gep01
                   NEXT FIELD gep01
   
              WHEN INFIELD(gep07)        #分類碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_get"  #參考cq_ppi
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO gep07
                 NEXT FIELD gep07
              OTHERWISE EXIT CASE
            END CASE
    
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
   
           	#No.FUN-580031 --start--     HCN
                   ON ACTION qbe_select
            	   CALL cl_qbe_select()
           	#No.FUN-580031 --end--       HCN
    
     END CONSTRUCT
    
     IF INT_FLAG THEN
        RETURN
     END IF
   END IF
   #END TQC-630074
 
  #資料權限的檢查
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                           #只能使用自己的資料
  #     LET g_wc = g_wc clipped," AND gepuser = '",g_user,"'"
  #  END IF
 
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND gepgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc = g_wc clipped," AND gepgrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gepuser', 'gepgrup')
  #End:FUN-980030
 
  #TQC-630074
  IF NOT cl_null(g_argv1) THEN
      LET g_wc2 = ' 1=1'
      LET g_wc3 = ' 1=1'
  ELSE
      CONSTRUCT g_wc2 ON geq02,geq03
              FROM s_geq[1].geq02,s_geq[1].geq03
         ON ACTION controlp
           IF INFIELD(geq03) THEN      #參數名稱
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_ges"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO geq03
              NEXT FIELD geq03
           END IF
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
            	#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
            	   CALL cl_qbe_save()
            	#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
      
      CONSTRUCT g_wc3 ON ger02,ger03
              FROM s_ger[1].ger02,s_ger[1].ger03
         ON ACTION controlp
           IF INFIELD(ger03) THEN      #公式代號
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_gep"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ger03
              NEXT FIELD ger03
           END IF
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
            	#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
            	   CALL cl_qbe_save()
            	#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
  END IF
  #END TQC-630074
 
  #因為geq_file或ges_file中數據有可能會為空，所以做如下判斷
  IF g_wc3 = " 1=1" THEN
     IF g_wc2 = " 1=1" THEN            # 若單身未輸入條件
        LET g_sql = "SELECT  gep01 FROM gep_file ",
                    " WHERE ", g_wc CLIPPED
     ELSE                              # 若單身有輸入條件
        LET g_sql = "SELECT UNIQUE gep_file. gep01 ",
                    "  FROM gep_file, geq_file ",
                    " WHERE gep01 = geq01",
                    "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
     END IF
  ELSE
     IF g_wc2 = " 1=1" THEN
        LET g_sql = "SELECT UNIQUE gep_file. gep01 ",
                    "  FROM gep_file, ger_file ",
                    " WHERE gep01 = ger01",
                    "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED
     ELSE
        LET g_sql = "SELECT UNIQUE gep_file. gep01 ",
                    "  FROM gep_file, geq_file ,ger_file",
                    " WHERE gep01 = geq01 AND gep01 = ger01",
                    "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                    "   AND ", g_wc3 CLIPPED
     END IF
  END IF
  LET g_sql = g_sql," ORDER BY 1"
  PREPARE i501_prepare FROM g_sql
  DECLARE i501_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i501_prepare
 
  IF g_wc3 = " 1=1" THEN
     IF g_wc2 = " 1=1" THEN            # 若單身未輸入條件
        LET g_sql = "SELECT COUNT(*) FROM gep_file ",
                    " WHERE ",g_wc CLIPPED
     ELSE                              # 若單身有輸入條件
        LET g_sql = "SELECT COUNT(DISTINCT gep01) ",
                    "  FROM gep_file, geq_file ",
                    " WHERE gep01 = geq01",
                    "   AND ", g_wc CLIPPED," AND ",g_wc2 CLIPPED
     END IF
  ELSE           # 若單身未輸入條件
     IF g_wc2 = " 1=1" THEN
        LET g_sql =  "SELECT COUNT(DISTINCT gep01) ",
                    "  FROM gep_file, ger_file ",
                    " WHERE gep01 = ger01",
                    "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED
     ELSE
        LET g_sql =  "SELECT COUNT(DISTINCT gep01) ",
                    "  FROM gep_file, geq_file ,ger_file",
                    " WHERE gep01 = geq01 AND gep01 = ger01",
                    "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                    "   AND ", g_wc3 CLIPPED
     END IF
  END IF
  PREPARE i501_precount FROM g_sql
  DECLARE i501_count CURSOR FOR i501_precount
 
END FUNCTION
 
FUNCTION i501_menu()
DEFINE
  li_result LIKE type_file.num5,          #No.FUN-680102 SMALLINT
  l_result  STRING,
  l_success LIKE type_file.num5            #No.FUN-680102SMALLINT
 
  WHILE TRUE
   CALL i501_bp("G")
   CASE g_action_choice
     WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i501_a()
           END IF
     WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i501_q()
           END IF
     WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i501_r()
           END IF
     WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i501_u()
           END IF
#No.TQC-6C0166 --begin
#    WHEN "invalid"
#          IF cl_chk_act_auth() THEN
#             CALL i501_x()
#          END IF
     WHEN "void"
           IF cl_chk_act_auth() THEN
             #CALL i501_x()   #CHI-D20010
              CALL i501_x(1)  #CHI-D20010
           END IF
#No.TQC-6C0166 --end
     #CHI-D20010---begin
     WHEN "undo_void"
        IF cl_chk_act_auth() THEN
           CALL i501_x(2)
        END IF
     #CHI-D20010---end
     WHEN "reproduce"
           IF cl_chk_act_auth() THEN
              CALL i501_copy()
           END IF
     WHEN "confirm"
           IF cl_chk_act_auth() THEN
              CALL i501_y('Y')
           END IF
     WHEN "undoconfirm"
           IF cl_chk_act_auth() THEN
              CALL i501_y('N')
           END IF
     WHEN "acttest"  #測試公式
           IF cl_chk_act_auth() THEN
              #拿來測試的不能是空串
              IF NOT cl_null(g_gep.gep05) THEN
                 #調用測試函數得到公式的計算結果
                 CALL cl_fml_run_content(g_gep.gep05,'',1) RETURNING l_result,l_success
                 DISPLAY l_result TO FORMONLY.res
              END IF
           END IF
 
     WHEN "output"
          IF cl_chk_act_auth() THEN
             CALL i501_out()
          END IF
 
     WHEN "help"
           CALL cl_show_help()
     WHEN "exit"
           EXIT WHILE
     WHEN "controlg"
           CALL cl_cmdask()
     #No.FUN-6A0015-------add--------str----
     WHEN "related_document"  #相關文件
        IF cl_chk_act_auth() THEN
           IF g_gep.gep01 IS NOT NULL THEN
             LET g_doc.column1 = "gep01"
             LET g_doc.value1 = g_gep.gep01
             CALL cl_doc()
           END IF
       END IF
     #No.FUN-6A0015-------add--------end----
 
     END CASE
   END WHILE
END FUNCTION
 
FUNCTION i501_a()
DEFINE
  i,j       LIKE type_file.num5,          #No.FUN-680102 SMALLINT
  k         LIKE type_file.num5           #檢查變量是否重復的標志 0:不重復，1□重復        #No.FUN-680102 SMALLINT
 
  MESSAGE ""
  CLEAR FORM
 
  CALL g_geq.clear()
  CALL g_ger.clear()
  LET  k = 0
 
  IF s_shut(0) THEN RETURN END IF
 
  INITIALIZE g_gep.* LIKE gep_file.*        #DEFAULT 設定
  LET g_gep.gep01 = '&&'
  LET g_gep.gep03 = 'N'
  LET g_gep01_t = NULL
  LET g_gep05_t = NULL
 
  #預設值及將數值類變數清成零
  LET g_gep_t.* = g_gep.*
  LET g_gep_o.* = g_gep.*
  CALL cl_opmsg('a')
 
  WHILE TRUE
     LET g_gep.gepuser=g_user
     LET g_gep.gepgrup=g_grup
     LET g_gep.gepdate=g_today
     LET g_gep.gep03='N'                    #設為未審核狀態
     LET g_gep.gepacti='Y'                  #MOD-CC0061 add
 
     CALL i501_i("a")                       #數據輸入
 
     IF INT_FLAG THEN                       #使用者不玩了
        INITIALIZE g_gep.* TO NULL
        LET INT_FLAG = 0
        CALL cl_err('',9001,0)
        EXIT WHILE
     END IF
 
     IF cl_null(g_gep.gep01) THEN           # KEY 不可空白
        CONTINUE WHILE
     END IF
 
     #輸入后, 若該單據需自動編號, 并且其單號為空白, 則自動賦予單號
     BEGIN WORK
 
     #插入公式單頭檔資料
     LET g_gep.geporiu = g_user      #No.FUN-980030 10/01/04
     LET g_gep.geporig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO gep_file VALUES (g_gep.*)
     IF SQLCA.sqlcode THEN                  #置入資料庫不成功
        CALL cl_err3("ins","gep_file",g_gep.gep01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131    #FUN-B80035  ADD
        ROLLBACK WORK      #No:7857
#       CALL cl_err(g_gep.gep01,SQLCA.sqlcode,1)   #No.FUN-660131
      #  CALL cl_err3("ins","gep_file",g_gep.gep01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131   #FUN-B80035  MARK 
        CONTINUE WHILE
     END IF
 
     #插入公式單身檔（變量）資料
     FOR i = 1 TO g_geq.getLength()
         INSERT INTO geq_file(geq01,geq02,geq03)
           VALUES(g_gep.gep01,g_geq[i].geq02,g_geq[i].geq03)
         IF SQLCA.sqlcode  THEN
#          CALL cl_err('geq',SQLCA.sqlcode,0)   #No.FUN-660131
           CALL cl_err3("ins","geq_file",g_gep.gep01,g_geq[i].geq02,SQLCA.sqlcode,"","geq",1)  #No.FUN-660131
           ROLLBACK WORK
           CONTINUE WHILE
        END IF
     END FOR
 
     #插入公式單身檔（表達式）資料
     FOR i = 1 TO g_ger.getLength()
       INSERT INTO ger_file(ger01,ger02,ger03)
         VALUES(g_gep.gep01,g_ger[i].ger02,g_ger[i].ger03)
       IF SQLCA.sqlcode THEN
#        CALL cl_err('ger',SQLCA.sqlcode,0)   #No.FUN-660131
         CALL cl_err3("ins","ger_file",g_gep.gep01,g_ger[i].ger02,SQLCA.sqlcode,"","ger",1)  #No.FUN-660131
         ROLLBACK WORK
         CONTINUE WHILE
       END IF
     END FOR
 
     #如果上面操作無誤則提交事務
     COMMIT WORK        #No:7857
 
     #插入完畢，刷新一下新的ROWID以及初始化原有的資料為當前資料等
     SELECT gep01 INTO g_gep.gep01 FROM gep_file
        WHERE gep01 = g_gep.gep01
     LET g_gep01_t = g_gep.gep01
     LET g_gep05_t = g_gep.gep05
     LET g_gep_t.* = g_gep.*
     LET g_gep_o.* = g_gep.*
     EXIT WHILE
  END WHILE
 
END FUNCTION
 
#檢查傳入的公式是否已經被引用
FUNCTION i501_checkUsed(p_gep01)
DEFINE
  p_gep01    LIKE gep_file.gep01,
  l_n        LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
  LET g_errno = ""
  SELECT COUNT(*) INTO l_n FROM ger_file WHERE ger03 = p_gep01
  IF l_n > 0 then
     LET g_errno = "aoo-152"  #本公式已經被引用，不能刪除或無效
     RETURN
  END IF
END FUNCTION
 
FUNCTION i501_u()
DEFINE
  i,k LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
  IF s_shut(0) THEN RETURN END IF
 
  IF g_gep.gep01 IS NULL THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
 
  LET k = 0
  SELECT * INTO g_gep.* FROM gep_file WHERE gep01=g_gep.gep01
 
  CASE
    #如果已經無效則不允許修改
    WHEN g_gep.gep03 ='X'
      CALL cl_err(g_gep.gep01,'9022',0)
      RETURN
    #如果已經審核通過則不允許修改
    WHEN g_gep.gep03 ='Y'
      CALL cl_err(g_gep.gep01,'9003',0)
      RETURN
  END CASE
 
  MESSAGE ""
  CALL cl_opmsg('u')
  LET g_gep01_t = g_gep.gep01
  LET g_gep05_t = g_gep.gep05
 
  BEGIN WORK
 
  OPEN i501_cl USING g_gep.gep01
  IF STATUS THEN
     CALL cl_err("OPEN i501_cl:", STATUS, 1)    
     CLOSE i501_cl
     ROLLBACK WORK
     RETURN
  END IF
 
  FETCH i501_cl INTO g_gep.*                     # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_gep.gep01,SQLCA.sqlcode,0)    # 資料被他人LOCK
     CLOSE i501_cl
     ROLLBACK WORK
     RETURN
  END IF
 
  CALL i501_show()
 
  WHILE TRUE
    LET g_gep01_t = g_gep.gep01
    LET g_gep05_t = g_gep.gep05
    LET g_gep_o.* = g_gep.*
    LET g_gep.gepmodu=g_user
    LET g_gep.gepdate=g_today
 
    CALL i501_i("u")                            #欄位更改
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_gep.*=g_gep_t.*
       CALL i501_show()
       CALL cl_err('','9001',0)
       EXIT WHILE
    END IF
 
    #如果公式內容改變了
    IF g_gep.gep05 != g_gep05_t THEN
       #首先清空單身檔(變量)geq_file中的內容
       DELETE FROM geq_file WHERE geq01 = g_gep.gep01
       IF SQLCA.sqlcode  THEN
#         CALL cl_err('geq',SQLCA.sqlcode,0)   #No.FUN-660131
          CALL cl_err3("del","geq_file",g_gep.gep01,"",SQLCA.sqlcode,"","geq",1)  #No.FUN-660131
          ROLLBACK WORK
          CONTINUE WHILE
       END IF
       #再清空單身檔(表達式)ger_file中的內容
       DELETE FROM ger_file WHERE ger01 = g_gep.gep01
       IF SQLCA.sqlcode  THEN
#         CALL cl_err('ger',SQLCA.sqlcode,0)   #No.FUN-660131
          CALL cl_err3("del","ger_file",g_gep.gep01,"",SQLCA.sqlcode,"ger","",1)  #No.FUN-660131
          ROLLBACK WORK
          CONTINUE WHILE
       END IF
 
       #按照當前公式的解析情況重新生成單身檔(變量)
       FOR i = 1 TO g_geq.getLength()
         INSERT INTO geq_file(geq01,geq02,geq03)
           VALUES(g_gep.gep01,g_geq[i].geq02,g_geq[i].geq03)
         IF SQLCA.sqlcode  THEN
#           CALL cl_err('geq',SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("ins","geq_file",g_gep.gep01,g_geq[i].geq02,SQLCA.sqlcode,"","geq",1)  #No.FUN-660131
            ROLLBACK WORK
            CONTINUE WHILE
         END IF
       END FOR
       #按照當前公式的解析情況重新生成單身檔(表達式)
       FOR i = 1 TO g_ger.getLength()
         INSERT INTO ger_file(ger01,ger02,ger03)
           VALUES(g_gep.gep01,g_ger[i].ger02,g_ger[i].ger03)
         IF SQLCA.sqlcode THEN
#           CALL cl_err('ger',SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("ins","ger_file",g_gep.gep01,g_ger[i].ger02,SQLCA.sqlcode,"","ger",1)  #No.FUN-660131
            ROLLBACK WORK
            CONTINUE WHILE
        END IF
      END FOR
    ELSE
      #如果公式編號發生了改變但公式內容沒有發生改變則修改單身表中的編號欄位
      #(因為如果公式內容改了會重建一遍單身，這樣自然也會把編號改掉)
      IF g_gep.gep01 != g_gep01_t THEN
         UPDATE geq_file SET geq01 = g_gep.gep01 WHERE geq01 = g_gep01_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('geq',SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","geq_file",g_gep01_t,"",SQLCA.sqlcode,"","geq",1)  #No.FUN-660131
            ROLLBACK WORK
            CONTINUE WHILE
         END IF
         UPDATE ger_file SET ger01 = g_gep.gep01 WHERE ger01 = g_gep01_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('ger',SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","ger_file",g_gep01_t,"",SQLCA.sqlcode,"","ger",1)  #No.FUN-660131
            ROLLBACK WORK
             CONTINUE WHILE
          END IF
      END IF
    END IF
 
    #更新單頭表
    UPDATE gep_file SET gep_file.* = g_gep.* WHERE gep01 = g_gep.gep01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_gep.gep01,SQLCA.sqlcode,0)   #No.FUN-660131
       CALL cl_err3("upd","gep_file",g_gep.gep01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
       ROLLBACK WORK
       CONTINUE WHILE
    END IF
 
    EXIT WHILE
  END WHILE
 
  CLOSE i501_cl
  COMMIT WORK
 
END FUNCTION
 
FUNCTION i501_i(p_cmd)
DEFINE
  l_ges01            LIKE ges_file.ges01,
  l_ze03             LIKE ze_file.ze03,
  l_n                LIKE type_file.num5,          #No.FUN-680102 SMALLINT
  l_strlen           LIKE type_file.num5,           #No.FUN-680102SMALLINT,
  l_success          LIKE type_file.num5,           #No.FUN-680102SMALLINT,          #判斷解析測試過程是否正確
  l_result           STRING,
  l_gep01            LIKE gep_file.gep01,
  l_gep02            STRING,  
  l_gep05            LIKE gep_file.gep05,           #No.FUN-680102CHAR(1000),
  l_pos,l_len        LIKE type_file.num5,           #No.FUN-680102SMALLINT
  l_pos_ex,l_len1    LIKE type_file.num5,           #No.FUN-680102SMALLINT
  l_str              LIKE type_file.chr1000,        #No.FUN-680102CHAR(1000),
  str                STRING,  
  p_cmd              LIKE type_file.chr1               #a:輸入 u:更改        #No.FUN-680102 VARCHAR(1)
 
  DISPLAY g_forex  TO FORMONLY.forex
 
  IF s_shut(0) THEN RETURN END IF
 
  #資料頁面的東東作只讀顯示
  DISPLAY BY NAME g_gep.gepuser,g_gep.gepmodu,
                  g_gep.gepgrup,g_gep.gepdate,g_gep.gep03
 
  #Main頁面上的東東要可以輸入
  WHILE TRUE
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT BY NAME g_gep.gep01,g_gep.gep02,g_gep.gep03,
                  g_gep.gep07,g_gep.gep05 WITHOUT DEFAULTS
      BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i501_set_entry(p_cmd)
        CALL i501_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
 
        LET l_success = FALSE
 
      AFTER FIELD gep01
        IF NOT cl_null(g_gep.gep01) THEN
           LET l_strlen = LENGTH(g_gep.gep01)
           LET l_gep01 = g_gep.gep01 CLIPPED
           #判斷公式代碼的第一個和最后一個字符是否是&
           IF (( l_gep01[1,1] <> '&' )OR( l_gep01[l_strlen,l_strlen] <> '&' )) THEN
              CALL cl_err('gep01','aoo-153',0)        #公式代碼必須包含在兩個'&'之間
              NEXT FIELD gep01
           END IF
           #判斷輸入公式代碼是否合法
           IF l_gep01 = '&' OR l_gep01 = '&&' THEN
             CALL cl_err('gep01','aoo-154',0)         #‘&’必須成對出現，且其中必須包含有效的公式名稱
             NEXT FIELD gep01
           ELSE
             LET l_gep01 = l_gep01[2,l_strlen-1] CLIPPED
             IF cl_null(l_gep01) THEN
               CALL cl_err('gep01','aoo-154',0)       #‘&’必須成對出現，且其中必須包含有效的公式名稱
               NEXT FIELD gep01
             END IF
           END IF
 
           IF g_gep.gep01 != g_gep01_t OR g_gep01_t IS NULL THEN
              SELECT count(*) INTO l_n FROM gep_file
               WHERE gep01 = g_gep.gep01
              IF l_n > 0 THEN                         #單據編號重復
                 CALL cl_err(g_gep.gep01,-239,0)
                 LET g_gep.gep01 = g_gep01_t
                 DISPLAY BY NAME g_gep.gep01
                 NEXT FIELD gep01
              END IF
           END IF
        END IF
 
      AFTER FIELD gep02
        IF NOT cl_null(g_gep.gep02) THEN
           LET l_gep02 = g_gep.gep02 CLIPPED
           IF (( l_gep02.getIndexOf('$',1) > 0 )OR( l_gep02.getIndexOf('#',1) > 0 )OR
               ( l_gep02.getIndexOf('&',1) > 0 )) THEN
               CALL cl_err(g_gep.gep02,'aoo-157',0)   #在公式名稱中不能出現#、$或&
               NEXT FIELD gep02
           END IF
        END IF
 
     #MOD-640497-begin
      AFTER FIELD gep07
        IF NOT cl_null(g_gep.gep07) THEN
           CALL i501_gep07(p_cmd) 
        END IF
     #MOD-640497-end
 
      #測試公式(規則定義是在保存公式前必須要先進行測試)
      ON ACTION acttest
         #因為如果當前是在gep05公式內容字段中，那么對
         #其進行的修改還沒有保存到程序變量中去，這時要手工保存一次
         IF INFIELD(gep05) THEN
            LET g_gep.gep05 = GET_FLDBUF(gep05)
         END IF
 
         #拿來測試的不能是空串
         IF cl_null(g_gep.gep05) THEN
            CALL cl_err('','lib-296',0)      #公式內容不能為空
            NEXT FIELD gep05
         END IF
         #首先調用函數來解析并生成該公式的說明信息
         CALL cl_fml_trans_desc(g_gep.gep05) RETURNING l_result,l_success
         LET g_gep.gep06 = l_result
         DISPLAY g_gep.gep06 TO gep06
         IF NOT l_success THEN
            NEXT FIELD gep05
         ELSE
            #調用測試函數得到公式的計算結果
            CALL cl_fml_run_content(g_gep.gep05,'',1) RETURNING l_result,l_success
            DISPLAY l_result TO FORMONLY.res
            IF NOT l_success THEN
               NEXT FIELD gep05
            ELSE
               #填充單身列表(從解析公式文本中得到)，如果在解析過程中發生錯誤則不允許通過
               #注意下面兩個IF判斷要有先后順序的，這樣參數頁面才會在最前面
               IF NOT i501_FillGer() THEN #單身表達式
                  NEXT FIELD gep05
               ELSE
                  LET l_success = TRUE
               END IF
               IF NOT i501_FillGeq() THEN #單身參數
                  NEXT FIELD gep05
               ELSE
                  LET l_success = TRUE
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CASE
            WHEN INFIELD(gep01) CALL cl_fldhlp('gep01')
            WHEN INFIELD(gep02) CALL cl_fldhlp('gep02')
            WHEN INFIELD(gep03) CALL cl_fldhlp('gep03')
            WHEN INFIELD(gep04) CALL cl_fldhlp('gep04')
            WHEN INFIELD(gep05) CALL cl_fldhlp('gep05')
            WHEN INFIELD(gep06) CALL cl_fldhlp('gep06')
            WHEN INFIELD(geq02) CALL cl_fldhlp('geq02')
            WHEN INFIELD(geq03) CALL cl_fldhlp('geq08')
            WHEN INFIELD(ger02) CALL cl_fldhlp('ger02')
            WHEN INFIELD(ger03) CALL cl_fldhlp('ger03')
            OTHERWISE           CALL cl_fldhlp('    ')
         END CASE
 
#No.FUN-610022 --start--
#      ON ACTION CONTROLP
      ON ACTION act01
#No.FUN-610022 --end--
         CASE
            WHEN INFIELD(gep05) #公式內容Ctrl+P開變量窗
               #注意這里的開窗后返回的內容是在文本中當前光標位置添加
               LET l_ges01 = ''
               #得到當前Field的內容
               CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
               #記錄當前光標位置
               LET l_pos = FGL_GETCURSOR()
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ges"
               LET g_qryparam.default1 = ""
               CALL cl_create_qry() RETURNING l_ges01
               #得到返回字符串的長度
               LET l_ges01 = l_ges01 CLIPPED
               LET l_len = LENGTH(l_ges01)
               LET l_len1 = LENGTH(l_str)
               #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
               IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
               #將返回字符串插入到當前文本中光標所在的位置
               IF l_pos = 1 THEN
                  LET g_gep.gep05 = l_ges01,l_str
               ELSE
                  LET g_gep.gep05 = l_str[1,l_pos-1],l_ges01,l_str[l_pos,l_len1]
               END IF
               DISPLAY BY NAME g_gep.gep05
               #將插入后的光標位置置于插入文本的末尾
               CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
               #NEXT FIELD gep05 這里一定不能有這一句話，否則光標的位置就到第一個去了
 
            OTHERWISE EXIT CASE
          END CASE
 
      ON ACTION CONTROLP
           CASE
            WHEN INFIELD(gep07) #分類碼
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_get"
               CALL cl_create_qry() RETURNING g_gep.gep07
               DISPLAY BY NAME g_gep.gep07
               NEXT FIELD gep07
 
            OTHERWISE EXIT CASE
          END CASE
 
#No.FUN-610022 --start--
#      ON ACTION CONTROLK
      ON ACTION act02
#No.FUN-610022 --end--
         #公式內容Ctrl+K標識開表達式窗
         CASE WHEN INFIELD(gep05)
               #注意這里的開窗后返回的內容是在文本中當前光標位置添加
               LET l_gep01 = ''
               #得到當前Field的內容
               CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
               #記錄當前光標位置
               LET l_pos = FGL_GETCURSOR()
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gep"
               LET g_qryparam.default1 = ""
               CALL cl_create_qry() RETURNING l_gep01
               #得到返回字符串的長度
               LET l_gep01 = l_gep01 CLIPPED
               LET l_len = LENGTH(l_gep01)
               LET l_len1 = LENGTH(l_str)
               #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
               IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
               #將返回字符串插入到當前文本中光標所在的位置
               IF l_pos = 1 THEN
                  LET g_gep.gep05 = l_gep01,l_str
               ELSE
                  LET g_gep.gep05 = l_str[1,l_pos-1],l_gep01,l_str[l_pos,l_len1]
               END IF
               DISPLAY BY NAME g_gep.gep05
               #將插入后的光標位置置于插入文本的末尾
               CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
               #NEXT FIELD gep05 這里一定不能有這一句話，否則光標的位置就到第一個去了
 
            OTHERWISE EXIT CASE
         END CASE
 
#No.FUN-610022 --start--
#     ON ACTION CONTROLL
      ON ACTION act03
#No.FUN-610022 --end--
         #公式內容Ctrl+L標識開函數窗
         CASE WHEN INFIELD(gep05)
               #注意這里的開窗后返回的內容是在文本中當前光標位置添加
               LET l_ze03 = ''
               #得到當前Field的內容
               CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
               #記錄當前光標位置
               LET l_pos = FGL_GETCURSOR()
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_fun"
               LET g_qryparam.default1 = ""
               LET g_qryparam.arg1 = g_lang  #查詢當前語言別下的提示字符串
               CALL cl_create_qry() RETURNING l_ze03
 
               #函數開窗的特別加工,因為是放在ze_file中的，所以函數的名稱和說明
               #信息是在一個字符串中的，但是我們要的返回值應該只有函數名稱，所以
               #要進行分離操作
               LET str = l_ze03 CLIPPED
               LET l_pos_ex = str.getIndexOf(' ',1)
               IF l_pos_ex = 0 THEN LET l_pos_ex = 1 END IF
               LET l_ze03 = str.subString(1,l_pos_ex)
 
               #得到返回字符串的長度
               LET l_ze03 = l_ze03 CLIPPED
               LET l_len = LENGTH(l_ze03)
               LET l_len1 = LENGTH(l_str)
               #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
               IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
               #將返回字符串插入到當前文本中光標所在的位置
               IF l_pos = 1 THEN
                  LET g_gep.gep05 = l_ze03,l_str
               ELSE
                  LET g_gep.gep05 = l_str[1,l_pos-1],l_ze03,l_str[l_pos,l_len1]
               END IF
               DISPLAY BY NAME g_gep.gep05
               #將插入后的光標位置置于插入文本的末尾
               CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
               #NEXT FIELD gep05 這里一定不能有這一句話，否則光標的位置就到第一個去了
 
            OTHERWISE EXIT CASE
         END CASE
 
     ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
    END INPUT
    #如果用戶是點擊“確定”退出的
    IF NOT INT_FLAG THEN
       #限制用戶必須先進行過測試并跑出正確結果了才允許保存
       IF NOT l_success THEN
          CALL cl_err('','lib-295',1)     #在公式保存前必須先經過測試
          CONTINUE WHILE
       END IF
    END IF
 
    EXIT WHILE
  END WHILE
 
END FUNCTION
 
# {# Marked by Lifeng for not using formula Classic code   #MOD-640497
FUNCTION i501_gep07(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
  DEFINE l_get02 LIKE get_file.get02
  LET g_errno = ''
 
 
  SELECT get02 INTO l_get02
    FROM get_file WHERE get01=g_gep.gep07
  IF SQLCA.sqlcode THEN
    LET g_errno = 'aoo1011'
  END IF
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
    DISPLAY l_get02 TO FORMONLY.get02
  END IF
END FUNCTION   # }  #MOD-640497
 
FUNCTION i501_q()
 
  LET  g_row_count = 0
  LET  g_curs_index = 0
  CALL cl_navigator_setting(g_curs_index, g_row_count)
  CALL cl_opmsg('q')
  INITIALIZE g_gep.* TO NULL            #No.FUN-6A0015
 
  MESSAGE ""
  CLEAR FORM
  DISPLAY ' ' TO FORMONLY.cnt
 
  CALL i501_cs()
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     INITIALIZE g_gep.* TO NULL
     RETURN
  END IF
 
  # 從DB產生合乎條件TEMP(0-30秒)
  OPEN i501_cs
  IF SQLCA.sqlcode THEN
     CALL cl_err('',SQLCA.sqlcode,0)
     INITIALIZE g_gep.* TO NULL
  ELSE
     OPEN i501_count
     FETCH i501_count INTO g_row_count
     DISPLAY g_row_count TO FORMONLY.cnt
 
     #讀出TEMP第一筆并顯示
     CALL i501_fetch('F')
  END IF
 
END FUNCTION
 
FUNCTION i501_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680102 VARCHAR(1)
 
   CASE p_flag
     WHEN 'N' FETCH NEXT     i501_cs INTO g_gep.gep01
     WHEN 'P' FETCH PREVIOUS i501_cs INTO g_gep.gep01
     WHEN 'F' FETCH FIRST    i501_cs INTO g_gep.gep01
     WHEN 'L' FETCH LAST     i501_cs INTO g_gep.gep01
     WHEN '/'
           IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
               END PROMPT
               IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT CASE
               END IF
           END IF
           FETCH ABSOLUTE g_jump i501_cs INTO g_gep.gep01
           LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gep.gep01,SQLCA.sqlcode,0)
      INITIALIZE g_gep.* TO NULL  #TQC-6B0105
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
 
   SELECT * INTO g_gep.* FROM gep_file WHERE gep01 = g_gep.gep01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_gep.gep01,SQLCA.sqlcode,0)   #No.FUN-660131
      CALL cl_err3("sel","gep_file",g_gep.gep01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
      INITIALIZE g_gep.* TO NULL
      RETURN
   END IF
 
   CALL i501_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i501_show()
DEFINE
  li_i     LIKE type_file.num5           #No.FUN-680102SMALLINT
 
  LET g_gep_t.* = g_gep.*                #保存單頭舊值
  LET g_gep_o.* = g_gep.*                #保存單頭舊值
  DISPLAY BY NAME g_gep.gep01,g_gep.gep02,g_gep.gep03,
                  g_gep.gep04,g_gep.gep05,g_gep.gep06,
                  g_gep.gep07,
                  g_gep.gepuser,g_gep.gepgrup,g_gep.gepmodu,
                  g_gep.gepdate     #No.TQC-6C0166
 
  DISPLAY g_forex TO FORMONLY.forex
  DISPLAY '' TO FORMONLY.res
 
  #刷新單身顯示
  CALL i501_b_b_fill(g_wc2)              #內含參數
  CALL i501_b_d_fill(g_wc3)              #內含表達式
END FUNCTION
 
#資料作廢操作
#FUNCTION i501_x()   #CHI-D20010
FUNCTION i501_x(p_type) #CHI-D20010
DEFINE
  l_gep03   LIKE gep_file.gep03
DEFINE l_flag LIKE type_file.chr1  #CHI-D20010
DEFINE p_type LIKE type_file.chr1  #CHI-D20010
 
  #這里說明一下,原來的cl_exp是對'Y','N'兩種標志進行判斷
  #的,但是現在是有'Y','N','X'三種標志,按道理是已經確認的
  #不允許作廢,即Y是不允許,N理解為原來的Y,X理解為原來的Y
  #所以這里進行了轉換
  IF g_gep.gep03 = 'Y' THEN
     CALL cl_err('','9003',0)
     RETURN
  ELSE
     IF g_gep.gep03 = 'N' THEN
        LET l_gep03 = 'Y'
     ELSE
        LET l_gep03 = 'N'
     END IF
  END IF
 
  IF s_shut(0) THEN RETURN END IF
  IF g_gep.gep01 IS NULL THEN
     CALL cl_err("",-400,0)
     RETURN
  END IF
 
  #在操作之前檢查當前的公式是否被別的公式使用過
  CALL i501_checkUsed(g_gep.gep01)
  IF g_errno <> "" OR g_errno IS NOT NULL then
    CALL cl_err("g_gep.gep01",g_errno,0)
    RETURN
  END IF

  #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_gep.gep03 ='X' THEN RETURN END IF
   ELSE
      IF g_gep.gep03 <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

  BEGIN WORK
 
  OPEN i501_cl USING g_gep.gep01
  IF STATUS THEN
     CALL cl_err("OPEN i501_cl:", STATUS, 1)
     CLOSE i501_cl
     ROLLBACK WORK
     RETURN
  END IF
 
  FETCH i501_cl INTO g_gep.*                   #鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_gep.gep01,SQLCA.sqlcode,0)  #資料被他人LOCK
     ROLLBACK WORK
     RETURN
  END IF
 
  LET g_success = 'Y'
 
  CALL i501_show()
 
  IF g_gep.gep03 = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
# IF cl_exp(0,0,l_gep03) THEN              #確認一下     #No.TQC-6C0153
# IF cl_void(0,0,g_gep.gep03) THEN              #確認一下    #No.TQC-6C0153  #CHI-D20010
  IF cl_void(0,0,l_flag) THEN              #確認一下    #No.TQC-6C0153  #CHI-D20010
     LET g_chr=g_gep.gep03
    #IF g_gep.gep03='X' THEN  #CHI-D20010
     IF p_type = 2 THEN       #CHI-D20010
        LET g_gep.gep03='N'
     ELSE
        LET g_gep.gep03='X'
     END IF
 
     UPDATE gep_file SET gep03=g_gep.gep03,
                         gepmodu=g_user,
                         gepdate=g_today
      WHERE gep01=g_gep.gep01
     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#       CALL cl_err(g_gep.gep01,SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("upd","gep_file",g_gep.gep01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        LET g_gep.gep03=g_chr
     END IF
  END IF
 
  CLOSE i501_cl
 
  IF g_success = 'Y' THEN
     COMMIT WORK
     #CALL cl_flow_notify(g_gep.gep01,'V')
  ELSE
     ROLLBACK WORK
  END IF
 
  SELECT gep03,gepmodu,gepdate
    INTO g_gep.gep03,g_gep.gepmodu,g_gep.gepdate FROM gep_file
   WHERE gep01=g_gep.gep01
  DISPLAY BY NAME g_gep.gep03,g_gep.gepmodu,g_gep.gepdate
 
END FUNCTION
 
#資料審核操作
FUNCTION i501_y(p_cmd)
DEFINE
  p_cmd LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
  IF s_shut(0) THEN RETURN END IF
  IF g_gep.gep01 IS NULL THEN
     CALL cl_err("",-400,0)
     RETURN
  END IF
 
  IF g_gep.gep03 = p_cmd THEN              #如果重復確認，不予執行，退出
    RETURN
  END IF
 
  BEGIN WORK
 
  OPEN i501_cl USING g_gep.gep01
  IF STATUS THEN
     CALL cl_err("OPEN i501_cl:", STATUS, 1)
     CLOSE i501_cl
     ROLLBACK WORK
     RETURN
  END IF
 
  FETCH i501_cl INTO g_gep.*                  # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_gep.gep01,SQLCA.sqlcode,0) #資料被他人LOCK
     ROLLBACK WORK
     RETURN
  END IF
#No.TQC-6C0166 --begin
  IF g_gep.gep03='X' THEN
    CALL cl_err(g_gep.gep03,'9024',0)      #此筆資料已經作廢，不能確認
    RETURN
  END IF
#No.TQC-6C0166 --end
 
  LET g_success = 'Y'
 
  CALL i501_show()
 
  IF cl_upsw(0,0,g_gep.gep03) THEN            #確認一下
#CHI-C30107 ------------- add --------------- begin
     SELECT * INTO g_gep.* FROM gep_file WHERE gep01 = g_gep.gep01
     IF g_gep.gep03 = p_cmd THEN              #如果重復確認，不予執行，退出
        RETURN
     END IF
     IF g_gep.gep03='X' THEN
        CALL cl_err(g_gep.gep03,'9024',0)      #此筆資料已經作廢，不能確認
        RETURN
     END IF
#CHI-C30107 ------------- add --------------- end
     LET g_chr=g_gep.gep03
#No.TQC-6C0166 --begin
#    IF g_gep.gep03='X' THEN
#      CALL cl_err(g_gep.gep03,'9024',0)      #此筆資料已經作廢，不能確認
#      RETURN
#    END IF
#No.TQC-6C0166 --end
 
     LET g_gep.gep03 = p_cmd
     IF p_cmd = 'Y' THEN
        LET g_gep.gep04 = g_today
     ELSE
       #LET g_gep.gep04 = ""     #FUN-D20059 Mark
        LET g_gep.gep04 = g_today #FUN-D20059 Add
     END IF
     UPDATE gep_file SET gep03=g_gep.gep03,
                         gep04 = g_gep.gep04,
                         gepmodu=g_user,
                         gepdate=g_today
      WHERE gep01=g_gep.gep01
     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#       CALL cl_err(g_gep.gep01,SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("upd","gep_file",g_gep.gep01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        LET g_gep.gep03=g_chr
     END IF
     DISPLAY BY NAME g_gep.gep04
  END IF
 
  CLOSE i501_cl
 
  IF g_success = 'Y' THEN
     COMMIT WORK
     #CALL cl_flow_notify(g_gep.gep01,'V')
  ELSE
     ROLLBACK WORK
  END IF
 
  SELECT gep03,gepmodu,gepdate
    INTO g_gep.gep03,g_gep.gepmodu,g_gep.gepdate FROM gep_file
   WHERE gep01=g_gep.gep01
  DISPLAY BY NAME g_gep.gep03,g_gep.gepmodu,g_gep.gepdate
 
END FUNCTION
 
#資料刪除操作
FUNCTION i501_r()
 
  IF s_shut(0) THEN RETURN END IF
  IF g_gep.gep01 IS NULL THEN
     CALL cl_err("",-400,0)
     RETURN
  END IF
 
  #在刪除前檢查該資料是否曾被別處使用過
  CALL i501_checkUsed(g_gep.gep01)
  IF g_errno <> "" OR g_errno IS NOT NULL then
    CALL cl_err("g_gep.gep01",g_errno,0)
    RETURN
  END IF
 
  SELECT * INTO g_gep.* FROM gep_file
   WHERE gep01=g_gep.gep01
  IF g_gep.gep03 <> 'N' THEN                  #檢查資料是否為無效
     CALL cl_err(g_gep.gep01,'9021',0)
     RETURN
  END IF
  BEGIN WORK
 
  OPEN i501_cl USING g_gep.gep01
  IF STATUS THEN
     CALL cl_err("OPEN i501_cl:", STATUS, 1)
     CLOSE i501_cl
     ROLLBACK WORK
     RETURN
  END IF
 
  FETCH i501_cl INTO g_gep.*                         #鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_gep.gep01,SQLCA.sqlcode,0)        #資料被他人LOCK
     ROLLBACK WORK
     RETURN
  END IF
 
  CALL i501_show()
 
  IF cl_delh(0,0) THEN                               #確認一下
      INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "gep01"         #No.FUN-9B0098 10/02/24
      LET g_doc.value1 = g_gep.gep01      #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                            #No.FUN-9B0098 10/02/24
     DELETE FROM gep_file WHERE gep01 = g_gep.gep01
     DELETE FROM geq_file WHERE geq01 = g_gep.gep01
     DELETE FROM ger_file WHERE ger01= g_gep.gep01
     IF SQLCA.sqlcode THEN
#      CALL cl_err(g_gep.gep01,SQLCA.sqlcode,0)      #資料被他人LOCK   #No.FUN-660131
       CALL cl_err3("del","ger_file",g_gep.gep01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
       ROLLBACK WORK
       RETURN
     END IF
     CLEAR FORM
     CALL g_geq.clear()
     CALL g_ger.clear()
     OPEN i501_count
     #FUN-B50063-add-start--
     IF STATUS THEN
        CLOSE i501_cs
        CLOSE i501_count
        COMMIT WORK
        RETURN
     END IF
     #FUN-B50063-add-end-- 
     FETCH i501_count INTO g_row_count
     #FUN-B50063-add-start--
     IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
        CLOSE i501_cs
        CLOSE i501_count
        COMMIT WORK
        RETURN
     END IF
     #FUN-B50063-add-end--
     DISPLAY g_row_count TO FORMONLY.cnt
     OPEN i501_cs
     IF g_curs_index = g_row_count + 1 THEN
        LET g_jump = g_row_count
        CALL i501_fetch('L')
     ELSE
        LET g_jump = g_curs_index
        LET g_no_ask = TRUE
        CALL i501_fetch('/')
     END IF
  END IF
 
  CLOSE i501_cl
  COMMIT WORK
END FUNCTION
 
 
FUNCTION i501_b_b_askkey()
DEFINE
  l_wc2    LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(200)
 
  CONSTRUCT l_wc2 ON geq02,geq03
    FROM s_geq[1].geq02,s_geq[1].geq03
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
  ON IDLE g_idle_seconds
     CALL cl_on_idle()
     CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
  END CONSTRUCT
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     RETURN
  END IF
 
  CALL i501_b_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i501_b_d_askkey()
DEFINE
  l_wc2            LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(200)
 
  CONSTRUCT l_wc2 ON ger02,ger03
          FROM s_ger[1].ger02,s_ger[1].ger03
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
  END CONSTRUCT
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     RETURN
  END IF
 
  CALL i501_b_d_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i501_b_b_fill(p_wc2)              #BODY FILL UP(變量)
DEFINE
  p_wc2          LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(200)
 
 
  LET g_sql = "SELECT geq02,geq03,ges02",
              "   FROM geq_file LEFT OUTER JOIN ges_file ON geq03 = ges01",
              " WHERE geq01 ='",g_gep.gep01,"'"   #單頭
  #No:9506
  IF NOT cl_null(p_wc2) THEN
     LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
  END IF
  LET g_sql=g_sql CLIPPED," ORDER BY 1 "
  #No:9506
 
  PREPARE i501_pb FROM g_sql
  DECLARE geq_cs CURSOR FOR i501_pb       #CURSOR
 
  CALL g_geq.clear()
  LET g_cnt = 1
 
  FOREACH geq_cs INTO g_geq[g_cnt].*        #單身 ARRAY 填充
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
    END IF
  END FOREACH
 
  CALL g_geq.deleteElement(g_cnt)
  LET g_rec_b=g_cnt-1
  DISPLAY g_rec_b TO FORMONLY.cn2
  LET g_cnt = 0
 
  DISPLAY ARRAY g_geq TO s_geq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
    BEFORE DISPLAY
       EXIT DISPLAY
  END DISPLAY
END FUNCTION
 
FUNCTION i501_b_d_fill(p_wc3)              #BODY FILL UP(表達式)
DEFINE
  p_wc3         LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(200)
 
 
  LET g_sql = "SELECT ger02,ger03,gep02 ",
              "  FROM ger_file LEFT OUTER JOIN gep_file ON ger03 = gep01",
              " WHERE ger01 ='",g_gep.gep01,"'"   #單頭
 
  #No:9506
  IF NOT cl_null(p_wc3) THEN
     LET g_sql=g_sql CLIPPED," AND ",p_wc3 CLIPPED
  END IF
  LET g_sql=g_sql CLIPPED," ORDER BY 1 "
  #No:9506
  #DISPLAY g_sql
 
  PREPARE i501_ger FROM g_sql
  DECLARE ger_cs                       #CURSOR
      CURSOR FOR i501_ger
 
  CALL g_ger.clear()
  LET g_cnt = 1
 
  FOREACH ger_cs INTO g_ger[g_cnt].*   #單身 ARRAY 填充
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
    END IF
  END FOREACH
 
  CALL g_ger.deleteElement(g_cnt)
  LET g_rec_d=g_cnt-1
  DISPLAY g_rec_d TO FORMONLY.cn3
  LET g_cnt = 0
  DISPLAY ARRAY g_ger TO s_ger.* ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED)
    BEFORE DISPLAY
      EXIT DISPLAY
  END DISPLAY
END FUNCTION
 
FUNCTION i501_bp(p_ud)
DEFINE
  p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
  IF p_ud <> "G" OR g_action_choice = "detail" THEN RETURN END IF
 
  LET g_action_choice = " "
  DISPLAY ARRAY g_ger TO s_ger.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
    BEFORE DISPLAY
      EXIT DISPLAY
  END DISPLAY
 
  CALL cl_set_act_visible("accept,cancel", FALSE)
 
  DISPLAY ARRAY g_geq TO s_geq.* ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED)
     BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     BEFORE ROW
        LET l_ac = ARR_CURR()
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
        CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
     ##################################################################
     # Standard 4ad ACTION
     ##################################################################
     ON ACTION insert
        LET g_action_choice="insert"
        EXIT DISPLAY
     ON ACTION query
        LET g_action_choice="query"
        EXIT DISPLAY
     ON ACTION delete
        LET g_action_choice="delete"
        EXIT DISPLAY
     ON ACTION modify
        LET g_action_choice="modify"
        EXIT DISPLAY
     ON ACTION first
        CALL i501_fetch('F')
        CALL cl_navigator_setting(g_curs_index, g_row_count)
        CALL fgl_set_arr_curr(1)
     ON ACTION previous
        CALL i501_fetch('P')
        CALL cl_navigator_setting(g_curs_index, g_row_count)
        CALL fgl_set_arr_curr(1)
     ON ACTION jump
        CALL i501_fetch('/')
        CALL cl_navigator_setting(g_curs_index, g_row_count)
        CALL fgl_set_arr_curr(1)
     ON ACTION next
        CALL i501_fetch('N')
        CALL cl_navigator_setting(g_curs_index, g_row_count)
        CALL fgl_set_arr_curr(1)
     ON ACTION last
        CALL i501_fetch('L')
        CALL cl_navigator_setting(g_curs_index, g_row_count)
        CALL fgl_set_arr_curr(1)
#No.TQC-6C0166 --begin
#    ON ACTION invalid
#       LET g_action_choice="invalid"
#       EXIT DISPLAY
     ON ACTION void
        LET g_action_choice="void"
        EXIT DISPLAY
     #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end

#No.TQC-6C0166 --end
     ON ACTION reproduce
        LET g_action_choice="reproduce"
        EXIT DISPLAY
     {ON ACTION detail
        LET g_action_choice="detail"
        LET l_ac = 1
        EXIT DISPLAY}
     ON ACTION output
        LET g_action_choice="output"
        EXIT DISPLAY
     ON ACTION help
        LET g_action_choice="help"
        EXIT DISPLAY
     ON ACTION confirm
        LET g_action_choice="confirm"
        EXIT DISPLAY
     ON ACTION undoconfirm
        LET g_action_choice="undoconfirm"
        EXIT DISPLAY
     ON ACTION acttest
        LET g_action_choice="acttest"
        EXIT DISPLAY
 
     ON ACTION locale
        CALL cl_dynamic_locale()
     ON ACTION exit
        LET g_action_choice="exit"
        EXIT DISPLAY
     ON ACTION controlg
        LET g_action_choice="controlg"
        EXIT DISPLAY
     {ON ACTION accept
        LET g_action_choice="detail"
        LET l_ac = ARR_CURR()
        EXIT DISPLAY}
     ON ACTION cancel
        LET g_action_choice="exit"
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
     ON ACTION related_document                #No.FUN-6A0015  相關文件
        LET g_action_choice="related_document"          
        EXIT DISPLAY
  END DISPLAY
 
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i501_copy()
DEFINE
  l_newno         LIKE gep_file.gep01,
  l_oldno         LIKE gep_file.gep01,
  l_strlen       LIKE type_file.num5,           #No.FUN-680102SMALLINT, 
  l_gep01        LIKE gep_file.gep01
 
  IF s_shut(0) THEN RETURN END IF
  IF g_gep.gep01 IS NULL THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
 
  LET g_before_input_done = FALSE
  CALL i501_set_entry('a')
 
  CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
  INPUT l_newno FROM gep01
    AFTER FIELD gep01
      SELECT count(*) INTO g_cnt FROM gep_file WHERE gep01 = l_newno
      IF g_cnt > 0 THEN
         CALL cl_err(l_newno,-239,0)
         NEXT FIELD gep01
      END IF
      IF NOT cl_null(l_newno) THEN
         LET l_strlen = LENGTH(l_newno)
         LET l_gep01 = l_newno CLIPPED
         #判斷公式代碼的第一個和最后一個字符是否是&
         IF (( l_gep01[1,1] <> '&' )OR( l_gep01[l_strlen,l_strlen] <> '&' )) THEN
            CALL cl_err('gep01','aoo-153',0)        #公式代碼必須包含在兩個'&'之間
            NEXT FIELD gep01
         END IF
         #判斷輸入公式代碼是否合法
         IF l_gep01 = '&' OR l_gep01 = '&&' THEN
           CALL cl_err('gep01','aoo-154',0)         #‘&’必須成對出現，且其中必須包含有效的公式名稱
           NEXT FIELD gep01
         ELSE
           LET l_gep01 = l_gep01[2,l_strlen-1] CLIPPED
           IF cl_null(l_gep01) THEN
             CALL cl_err('gep01','aoo-154',0)       #‘&’必須成對出現，且其中必須包含有效的公式名稱
             NEXT FIELD gep01
           END IF
         END IF
      ELSE
      	NEXT FIELD gep01
      END IF
 
    ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE INPUT
 
  END INPUT
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     DISPLAY BY NAME g_gep.gep01
     RETURN
  END IF
 
  BEGIN WORK #No:7857
 
  #單頭復制
  DROP TABLE y
 
  SELECT * FROM gep_file WHERE gep01=g_gep.gep01 INTO TEMP y
 
  UPDATE y
      SET gep01=l_newno,      #新的鍵值
          gep03='N',
          gepacti='Y',        #MOD-CC0061 add
          gepuser=g_user,     #資料所有者
          gepgrup=g_grup,     #資料所有者所屬群
          gepmodu=NULL,       #資料修改日期
          gepdate=g_today     #資料建立日期
 
  INSERT INTO gep_file SELECT * FROM y
 
  #單身(變量)復制
  DROP TABLE x
 
  SELECT * FROM geq_file WHERE geq01=g_gep.gep01 INTO TEMP x
  IF SQLCA.sqlcode THEN
#    CALL cl_err(g_gep.gep01,SQLCA.sqlcode,0)   #No.FUN-660131
     CALL cl_err3("ins","x",g_gep.gep01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
     ROLLBACK WORK       #TQC-960096 add
     RETURN
  END IF
 
  UPDATE x SET geq01=l_newno
 
  INSERT INTO geq_file SELECT * FROM x
  IF SQLCA.sqlcode THEN
  #   ROLLBACK WORK #No:7857    #FUN-B80035  MARK
#    CALL cl_err(g_gep.gep01,SQLCA.sqlcode,0)   #No.FUN-660131
     CALL cl_err3("ins","geq_file",g_gep.gep01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
     ROLLBACK WORK       #TQC-960096 add
     RETURN
  END IF
 
  #單身(表達式)復制
  DROP TABLE  z
  SELECT * FROM ger_file WHERE ger01=g_gep.gep01 INTO TEMP  z
  IF SQLCA.sqlcode THEN
#    CALL cl_err(g_gep.gep01,SQLCA.sqlcode,0)   #No.FUN-660131
     CALL cl_err3("sel","ger_file",g_gep.gep01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
     ROLLBACK WORK       #TQC-960096 add
     RETURN
  END IF
 
  UPDATE z SET ger01=l_newno
 
  INSERT INTO ger_file SELECT * FROM z
  IF SQLCA.sqlcode THEN
#     ROLLBACK WORK #No:7857    #FUN-B80035  MARK
#    CALL cl_err(g_gep.gep01,SQLCA.sqlcode,0)   #No.FUN-660131
     CALL cl_err3("ins","ger_file",g_gep.gep01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
     ROLLBACK WORK       #TQC-960096 add
     RETURN
  ELSE
     COMMIT WORK
  END IF
 
  #統計單身復制的記錄數量
  LET g_cnt=SQLCA.SQLERRD[3]
  MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
  LET l_oldno = g_gep.gep01
  SELECT gep01 INTO g_gep.gep01 FROM gep_file WHERE gep01 = l_newno
  SELECT * INTO g_gep.* FROM gep_file WHERE gep01 = l_newno
  CALL i501_u()
  CALL i501_show()
 
END FUNCTION
 
FUNCTION i501_set_entry(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
    CALL cl_set_comp_entry("gep01",TRUE)
  END IF
END FUNCTION
 
FUNCTION i501_set_no_entry(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
  IF p_cmd = 'u' AND g_chkey = "N" AND (NOT g_before_input_done) THEN
    CALL cl_set_comp_entry("gep01",FALSE)
  END IF
END FUNCTION
 
#解析gep05公式內容并生成geq_file單身參數資料
FUNCTION i501_FillGeq()
DEFINE
  l_result    STRING,
  l_str_tok   base.StringTokenizer,
  l_i         LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
  CALL g_geq.clear()
  CALL cl_fml_extract_param(g_gep.gep05,'$') RETURNING l_result
 
  LET l_i = 0
  LET l_str_tok = base.StringTokenizer.create(l_result,'|')
  WHILE l_str_tok.hasMoretokens()
    LET l_i = l_i + 1
    LET g_geq[l_i].geq02 = l_i
    LET g_geq[l_i].geq03 = l_str_tok.nextToken()
 
    SELECT ges02 INTO g_geq[l_i].ges02 FROM ges_file WHERE ges01 = g_geq[l_i].geq03
    IF SQLCA.sqlcode THEN
#      CALL cl_err('','aoo-155',1)    #變量代碼不存在,請檢查是否輸入錯誤   #No.FUN-660131
       CALL cl_err3("sel","ges_file",g_geq[l_i].geq03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
       RETURN FALSE
    END IF
  END WHILE
 
  DISPLAY ARRAY g_geq TO s_geq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
    BEFORE DISPLAY
       EXIT DISPLAY
  END DISPLAY
 
  RETURN TRUE
END FUNCTION
 
#解析gep05公式內容并生成ger_file單身表達式資料
FUNCTION i501_FillGer()
DEFINE
  l_result    STRING,
  l_str_tok   base.StringTokenizer,
  l_i         LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
  CALL g_ger.clear()
  CALL cl_fml_extract_param(g_gep.gep05,'&') RETURNING l_result
 
  LET l_i = 0
  LET l_str_tok = base.StringTokenizer.create(l_result,'|')
  WHILE l_str_tok.hasMoretokens()
    LET l_i = l_i + 1
    LET g_ger[l_i].ger02 = l_i
    LET g_ger[l_i].ger03 = l_str_tok.nextToken()
 
    SELECT gep02 INTO g_ger[l_i].gep02a FROM gep_file WHERE gep01 = g_ger[l_i].ger03
    IF SQLCA.sqlcode THEN
#      CALL cl_err('','aoo-156',1)    #表達式代碼不存在,請檢查是否輸入錯誤   #No.FUN-660131
       CALL cl_err3("sel","gep_file",g_geq[l_i].geq03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
       RETURN FALSE
    END IF
  END WHILE
 
  DISPLAY ARRAY g_ger TO s_ger.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
    BEFORE DISPLAY
       EXIT DISPLAY
  END DISPLAY
 
  RETURN TRUE
END FUNCTION
 
FUNCTION i501_out()
DEFINE
  l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
  l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680102 VARCHAR(20)
  l_za05          LIKE za_file.za05,
  sr RECORD
       gep01      LIKE gep_file.gep01,
       gep02      LIKE gep_file.gep02,
       gep07      LIKE gep_file.gep07,
       gep05      LIKE gep_file.gep05,
       gep06      LIKE gep_file.gep06
  END RECORD
 
  CALL cl_wait()
  LET g_str=''                                      #No.FUN-760083
  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog    #No.FUN-760083 
  CALL cl_outnam('aooi501') RETURNING l_name
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
  LET g_sql="SELECT gep01,gep02,gep07,gep05,gep06",
              "  FROM gep_file LEFT OUTER JOIN geq_file ON gep01=geq01 LEFT OUTER JOIN ger_file ON gep01=ger01 ",   # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED ,
              "   AND ",g_wc2 CLIPPED ,
              " ORDER BY gep01 "
#No.FUN-760083 --BEGIN--
{
  PREPARE i501_p1 FROM g_sql                # RUNTIME 編譯
  DECLARE i501_co CURSOR FOR i501_p1
 
  START REPORT i501_rep TO l_name
 
  FOREACH i501_co INTO sr.*
    IF SQLCA.sqlcode THEN
       CALL cl_err('Foreach:',SQLCA.sqlcode,1)    
       EXIT FOREACH
    END IF
    OUTPUT TO REPORT i501_rep(sr.*)
  END FOREACH
 
  FINISH REPORT i501_rep
 
  CLOSE i501_co
  ERROR ""
  CALL cl_prt(l_name,' ','1',g_len)
}
  IF g_zz05='Y' THEN
     CALL cl_wcchp(g_wc,'gep01,gep02,gep03,gep04,gep07,gep05,gep06,                                                           
                               gepuser,gepgrup,gepmodu,gepdate')
     RETURNING g_wc
  END IF
  LET g_str=g_wc
  CALL cl_prt_cs1("aooi501","aooi501",g_sql,g_str) 
#No.FUN-760083 --end--
END FUNCTION
 
#No.FUN-760083  --begin--
{
REPORT i501_rep(sr)
DEFINE
  l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1),
  sr RECORD
       gep01      LIKE gep_file.gep01,
       gep02      LIKE gep_file.gep02,
       gep07      LIKE gep_file.gep07,
       gep05      LIKE gep_file.gep05,
       gep06      LIKE gep_file.gep06
  END RECORD,
  l_gep05_tok     base.stringTokenizer,
  l_gep06_tok     base.stringTokenizer,
  l_gep05         LIKE gep_file.gep05,
  l_gep06         LIKE gep_file.gep06
 
 
  OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_line
 
   ORDER BY sr.gep01
 
   FORMAT
       PAGE HEADER
           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
 
           LET g_pageno = g_pageno + 1
           LET pageno_total = PAGENO USING '<<<',"/pageno"
           PRINT g_head CLIPPED,pageno_total
 
           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
           PRINT
           PRINT g_dash[1,g_len]
 
           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
           PRINT g_dash1
           LET l_trailer_sw = 'y'
 
       ON EVERY ROW
           #因為gep05和gep06都允許多行,所以在打印的時候要特別注意,分別對每一行
           #進行打印處理,否則會亂掉
           LET l_gep05_tok = base.stringTokenizer.create(sr.gep05,'n')
           LET l_gep06_tok = base.stringTokenizer.create(sr.gep06,'n')
 
           LET l_gep05 = l_gep05_tok.nextToken()
           LET l_gep06 = l_gep06_tok.nextToken()
 
           PRINT COLUMN g_c[31],sr.gep01,
                 COLUMN g_c[32],sr.gep02,
                 COLUMN g_c[33],sr.gep07,
                 COLUMN g_c[34],l_gep05,
                 COLUMN g_c[35],l_gep06
 
           WHILE ((l_gep05_tok.hasMoreTokens())OR(l_gep06_tok.hasMoreTokens()))
             LET l_gep05 = l_gep05_tok.nextToken()
             LET l_gep06 = l_gep06_tok.nextToken()
 
             PRINT COLUMN g_c[34],l_gep05,
                   COLUMN g_c[35],l_gep06
           END WHILE
 
       ON LAST ROW
           PRINT g_dash[1,g_len]
           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
           LET l_trailer_sw = 'n'
 
       PAGE TRAILER
           IF l_trailer_sw = 'y' THEN
               PRINT g_dash[1,g_len]
               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
           ELSE
               SKIP 2 LINE
           END IF
 
END REPORT
}
#No.FUN-760083  --end--
