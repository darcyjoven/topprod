# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apst800.4gl
# Descriptions...: APS訂單建議調整維護作業
# Date & Author..: 08/04/23 By rainy  #FUN-840156
# Modify.........: No.FUN-840209 08/05/22 By Mandy g_dbs =>g_plant
# Modify.........: No.TQC-8A0051 08/10/17 BY DUKE UPDATE l_ac3 --> l_ac4
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No:EXT-940019 09/05/06 By Duke 查詢時,從第一筆按下一筆到最後卻找不到直接按最後一筆的aps版本記錄
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/13 By vealxu 精簡程式碼
# Modify.........: No.FUN-B50020 11/05/05 By Lilan (1)調整APS版本開窗模式
#                                                  (2)獨立需求和銷售預測page變更否為NULL時show沒有勾選的圖案
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#模組變數(Module Variables)
DEFINE
    g_vld05         LIKE vld_file.vld05, #日期沖銷方式
    g_vld11         LIKE vld_file.vld11, #日期沖銷方式
    g_voa01         LIKE voa_file.voa01,
    g_voa02         LIKE voa_file.voa01,
    g_voa1          DYNAMIC ARRAY OF RECORD #一般訂單
        voa40_1            LIKE voa_file.voa40,   #變更否
        oea49_1         LIKE type_file.chr1,   #建議調整狀態 A.訂單維護 B.訂單變更單維護
        voa14_1          LIKE voa_file.voa14,   #訂單編號
        voa08_1          LIKE voa_file.voa08,   #客戶編號
        occ02_1          LIKE occ_file.occ02,   #客戶名稱
        vmu26_1          LIKE vmu_file.vmu26,   #項次
        voa04_1          LIKE voa_file.voa04,   #料號
        ima02_1          LIKE ima_file.ima02,   #品名
        oeb12_1          LIKE oeb_file.oeb12,   #訂購數量
        date_1           LIKE oeb_file.oeb15,   #原交期
        voa23_1          LIKE voa_file.voa23,   #APS建議交期
        oeb24_1          LIKE oeb_file.oeb24,   #已交量
        oea14_1          LIKE oea_file.oea14,   #業務員
        gen02_1          LIKE gen_file.gen02,   #姓名
        voa03_1          LIKE voa_file.voa03    #voa03(key)
                    END RECORD,
    g_voa2          DYNAMIC ARRAY OF RECORD #合約訂單
        voa40_2          LIKE voa_file.voa40,   #變更否
        oea49_2         LIKE type_file.chr1,   #建議調整狀態 A.合約維護 B.訂單變更單維護
        voa14_2          LIKE voa_file.voa14,   #合約編號
        voa08_2          LIKE voa_file.voa08,   #客戶編號
        occ02_2          LIKE occ_file.occ02,   #客戶名稱
        vmu26_2          LIKE vmu_file.vmu26,   #項次
        voa04_2          LIKE voa_file.voa04,   #料號
        ima02_2          LIKE ima_file.ima02,   #品名
        oeb12_2          LIKE oeb_file.oeb12,   #訂購數量
        date_2           LIKE oeb_file.oeb15,   #原交期
        voa23_2          LIKE voa_file.voa23,   #APS建議交期
        oeb24_2          LIKE oeb_file.oeb24,   #已訂數量
        oea14_2          LIKE oea_file.oea14,   #業務員
        gen02_2          LIKE gen_file.gen02,   #姓名
        voa03_2          LIKE voa_file.voa03    #voa03(key)
                    END RECORD,
    g_voa3          DYNAMIC ARRAY OF RECORD #獨立需求
        voa40_3          LIKE voa_file.voa40,   #變更否
        oea49_3         LIKE type_file.chr1,   #建議調整狀態 A.獨立需求
        voa14_3          LIKE voa_file.voa14,   #需求編號
        vmu26_3          LIKE vmu_file.vmu26,   #項次
        voa04_3          LIKE voa_file.voa04,   #料號
        ima02_3          LIKE ima_file.ima02,   #品名
        rpc13            LIKE rpc_file.rpc13,   #需求數量
        date_3           LIKE rpc_file.rpc12,   #原需求日期
        voa23_3          LIKE voa_file.voa23,   #APS建議日期
        rpc131           LIKE rpc_file.rpc131,  #已耗需求
        voa03_3          LIKE voa_file.voa03    #voa03(key)
                    END RECORD,
    g_voa4          DYNAMIC ARRAY OF RECORD #銷售預測
        voa40_4          LIKE voa_file.voa40,   #變更否
        oea49_4          LIKE type_file.chr1,   #建議調整狀態 A.銷售預測
        voa08_4          LIKE voa_file.voa08,   #客戶編號
        occ02_4          LIKE occ_file.occ02,   #客戶名稱
        vmu26_4          LIKE vmu_file.vmu26,   #項次
        voa04_4          LIKE voa_file.voa04,   #料號
        ima02_4          LIKE ima_file.ima02,   #品名
        opd08            LIKE opd_file.opd08,   #數量
        date_4           LIKE oeb_file.oeb15,   #原起始日期
        voa23_4          LIKE voa_file.voa23,   #APS建議日期
        opc04            LIKE opc_file.opc04,   #業務員
        gen02_4          LIKE gen_file.gen02,   #姓名
        voa03_4          LIKE voa_file.voa03    #voa03(key)
                    END RECORD,
 
    g_wc            STRING,  
    g_rec_b1,g_rec_b2,g_rec_b3,g_rec_b4   LIKE type_file.num5,            #單身筆數        #No.FUN-680072 SMALLINT
    g_sql           STRING, 
    g_cmd           LIKE type_file.chr1000,       
    g_t1            LIKE type_file.chr5,          
    l_ac,l_ac2,l_ac3,l_ac4   LIKE type_file.num5     #目前處理的ARRAY CNT      
 
#主程式開始
DEFINE  p_row,p_col         LIKE type_file.num5          
DEFINE  l_action_flag        STRING
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_before_input_done  LIKE type_file.num5         
DEFINE  g_chr           LIKE type_file.chr1          
DEFINE  g_cnt           LIKE type_file.num10         
DEFINE  g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE  g_msg           LIKE ze_file.ze03        
 
DEFINE  g_row_count    LIKE type_file.num10         
DEFINE  g_curs_index   LIKE type_file.num10         
DEFINE  g_jump         LIKE type_file.num10         
DEFINE  mi_no_ask      LIKE type_file.num5          
DEFINE  g_void         LIKE type_file.chr1          
 
 
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
 
    LET p_row = 4 LET p_col = 5
 
    OPEN WINDOW t800_w AT 2,2 WITH FORM "aps/42f/apst800"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL t800_default()
    CALL t800_menu()
 
    CLOSE WINDOW t800_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
 
#QBE 查詢資料
FUNCTION t800_cs()
 
 DEFINE  l_type          LIKE type_file.chr2        
 DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
 
   CLEAR FORM                             #清除畫面
   CALL g_voa1.clear()
   CALL g_voa2.clear()
   CALL g_voa3.clear()
   CALL g_voa4.clear()
 
   INITIALIZE g_voa01 TO NULL   
   INITIALIZE g_voa02 TO NULL   
 
   CONSTRUCT BY NAME g_wc ON voa01,voa02
     BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(voa01)
           CALL cl_init_qry_var()
          #FUN-B50020 mark str -----
          #LET g_qryparam.state = "c"
          #LET g_qryparam.form ="q_voa01"
          #CALL cl_create_qry() RETURNING g_qryparam.multiret
          #DISPLAY g_qryparam.multiret TO voa01
          #FUN-B50020 mark end -----

          #FUN-B50020 add str -----
           LET g_qryparam.form = "q_voa03"
           LET g_qryparam.default1 = g_voa01
           LET g_qryparam.arg1 = g_plant CLIPPED
           CALL cl_create_qry() RETURNING g_voa01,g_voa02
           DISPLAY g_voa01 TO voa01
           DISPLAY g_voa02 TO voa02
          #FUN-B50020 add end -----
           NEXT FIELD voa01
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
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN RETURN END IF
 
 
   LET g_sql  = "SELECT UNIQUE voa01,voa02 ",
                " FROM voa_file ",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY voa01,voa02"
   PREPARE t800_prepare FROM g_sql
   DECLARE t800_cs SCROLL CURSOR WITH HOLD FOR t800_prepare
 
   LET g_sql  = " SELECT COUNT(*) FROM        ",
                "    (SELECT DISTINCT voa01,voa02 " ,
                "       FROM voa_file ",
                "      WHERE ", g_wc CLIPPED,
                "      GROUP BY voa01,voa02) "
 
   PREPARE t800_precount FROM g_sql
   DECLARE t800_count CURSOR FOR t800_precount
END FUNCTION
 
 
FUNCTION t800_default()
  CALL cl_set_comp_visible("voa03_1,voa03_2,voa03_3,voa03_4",FALSE)
 
END FUNCTION
 
 
FUNCTION t800_menu()
 
   WHILE TRUE
      CASE
         WHEN (l_action_flag IS NULL) OR (l_action_flag = "page01")  #一般訂單
            CALL t800_bp1("G")
         WHEN l_action_flag = "page02"                   #合約訂單
            CALL t800_bp2("G")
         WHEN l_action_flag = "page03"                   #獨立需求
            CALL t800_bp3("G")
         WHEN l_action_flag = "page04"                   #銷售預測
            CALL t800_bp4("G")
      END CASE
 
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t800_q()
            END IF
 
         WHEN "mtn_so"      #訂單維護
            IF cl_chk_act_auth() THEN
               IF g_rec_b1 > 0 AND l_ac > 0 THEN
                 LET g_msg = " axmt410 '", g_voa1[l_ac].voa14_1,"'"
                 CALL cl_cmdrun_wait(g_msg CLIPPED)
               END IF
            END IF
         WHEN "mtn_so_adj"  #訂單變更單維護
            IF cl_chk_act_auth() THEN
               LET g_msg = " axmt800 "
               CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
         WHEN "mtn_const"   #客戶合約維護
            IF cl_chk_act_auth() THEN
               IF g_rec_b2 > 0 AND l_ac2 > 0 THEN
                 LET g_msg = " axmt400 '", g_voa2[l_ac2].voa14_2,"'"
                 CALL cl_cmdrun_wait(g_msg CLIPPED)
               END IF
            END IF
         WHEN "mtn_indpt"   #獨立需求維護
            IF cl_chk_act_auth() THEN
               IF g_rec_b3 > 0 AND l_ac3 > 0 THEN
                 LET g_msg = " amri506 '", g_voa3[l_ac3].voa14_3,"'"
                 CALL cl_cmdrun_wait(g_msg CLIPPED)
               END IF
            END IF
         WHEN "mtn_forecast"#銷售預測維護
            IF cl_chk_act_auth() THEN
               IF g_rec_b4 > 0 AND l_ac4 > 0 THEN
                 CALL t800_mtn_forecast()
               END IF
            END IF
 
         WHEN "detail"
            CASE
            WHEN (l_action_flag IS NULL) OR (l_action_flag = "page01")  #一般訂單
               CALL t800_b1()
            WHEN l_action_flag = "page02"                   #合約訂單
               CALL t800_b2()
            WHEN l_action_flag = "page03"                   #獨立需求
               CALL t800_b3()
            WHEN l_action_flag = "page04"                   #銷售預測
               CALL t800_b4()
            END CASE
 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t800_mtn_forecast()
  DEFINE  l_opc01   LIKE opc_file.opc01,
          l_opc02   LIKE opc_file.opc02,
          l_opc03   LIKE opc_file.opc03,
          l_opc04   LIKE opc_file.opc04
 
  LET l_opc01 = g_voa4[l_ac4].voa04_4
  LET l_opc02 = g_voa4[l_ac4].voa08_4
  
 
  SELECT vmu18,vmu16 INTO l_opc03,l_opc04
    FROM vmu_file
   WHERE vmu01 = g_voa01
     AND vmu02 = g_voa02
     AND vmu03 = g_voa4[l_ac4].voa03_4
  IF SQLCA.sqlcode THEN
    RETURN
  END IF
 
 
 
  LET g_msg = " axmi171 '",l_opc01,"'",
                      " '",l_opc02,"'",
                      " '",l_opc03,"'",
                      " '",l_opc04,"'"
  CALL cl_cmdrun_wait(g_msg CLIPPED)
END FUNCTION
 
FUNCTION t800_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_voa01 TO NULL   
   INITIALIZE g_voa02 TO NULL   
   CALL g_voa1.clear()
   CALL g_voa2.clear()
   CALL g_voa3.clear()
   CALL g_voa4.clear()
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL t800_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t800_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      INITIALIZE g_voa01 TO NULL   
      INITIALIZE g_voa02 TO NULL   
      CALL g_voa1.clear()
      CALL g_voa2.clear()
      CALL g_voa3.clear()
      CALL g_voa4.clear()
   ELSE
      OPEN t800_count
      FETCH t800_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t800_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
 
#處理資料的讀取
FUNCTION t800_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680072 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t800_cs INTO g_voa01,g_voa02
      WHEN 'P' FETCH PREVIOUS t800_cs INTO g_voa01,g_voa02
      WHEN 'F' FETCH FIRST    t800_cs INTO g_voa01,g_voa02
      WHEN 'L' FETCH LAST     t800_cs INTO g_voa01,g_voa02
      WHEN '/'
         IF NOT mi_no_ask THEN
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
 
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump t800_cs INTO g_voa01,g_voa02 
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_voa01,SQLCA.sqlcode,0)
      INITIALIZE g_voa01 TO NULL  
      INITIALIZE g_voa02 TO NULL  
      CLEAR FORM
      CALL g_voa1.clear()
      CALL g_voa2.clear()
      CALL g_voa3.clear()
      CALL g_voa4.clear()
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
   SELECT UNIQUE voa01,voa02 INTO g_voa01,g_voa02 FROM voa_file WHERE voa01 = g_voa01 AND voa02 = g_voa02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","voa_file",g_voa01,g_voa02,SQLCA.sqlcode,"","",1)  
      INITIALIZE g_voa01 TO NULL  
      INITIALIZE g_voa02 TO NULL  
      CALL g_voa1.clear()
      CALL g_voa2.clear()
      CALL g_voa3.clear()
      CALL g_voa4.clear()
      RETURN
   END IF
   CALL t800_show()
END FUNCTION
 
 
#將資料顯示在畫面上
FUNCTION t800_show()
   DISPLAY g_voa01 TO voa01
   DISPLAY g_voa02 TO voa02
 
   SELECT vld05,vld11 INTO g_vld05,g_vld11 FROM vld_file
    WHERE vld01 = g_voa01
      AND vld02 = g_voa02
   
   CALL t800_b1_fill("1=1")    #單身 一般訂單
   CALL t800_b2_fill("1=1")    #單身 合約訂單
   CALL t800_b3_fill("1=1")    #單身 獨立需求
   CALL t800_b4_fill("1=1")    #單身 銷售預測
   CALL cl_show_fld_cont()               
END FUNCTION
 
 
#一般訂單
FUNCTION t800_b1()
DEFINE
   l_lock_sw       LIKE type_file.chr1,   #單身鎖住否      
   p_cmd           LIKE type_file.chr1,   #處理狀態       
   l_exit_sw       LIKE type_file.chr1,   
   l_allow_insert  LIKE type_file.num5,   #可新增否       
   l_allow_delete  LIKE type_file.num5,   #可刪除否      
   l_voa40t        LIKE voa_file.voa40
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_voa01) OR cl_null(g_voa02) THEN RETURN END IF
 
   IF g_rec_b1 = 0 THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT * ",
                      " FROM voa_file",
                      " WHERE voa00=? AND voa01=? AND voa02=? AND voa03=?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t800_b1_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   INPUT ARRAY g_voa1 WITHOUT DEFAULTS FROM s_voa1.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
     BEFORE INPUT
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
     BEFORE ROW
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
 
        BEGIN WORK
        IF g_rec_b1 >= l_ac THEN
           LET p_cmd='u'
           OPEN t800_b1_cl USING g_plant,g_voa01,g_voa02,g_voa1[l_ac].voa03_1 #FUN-840209
           IF STATUS THEN
              CALL cl_err("OPEN t800_b1_cl:", STATUS, 1)
              LET l_lock_sw = "Y"
           END IF
           LET l_voa40t = g_voa1[l_ac].voa40_1
        END IF
 
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_voa1[l_ac].voa40_1 = l_voa40t
             CLOSE t800_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_voa1[l_ac].voa03_1,-263,1)
          ELSE
             UPDATE voa_file SET voa40 = g_voa1[l_ac].voa40_1
              WHERE voa00=g_plant  #FUN-840209
                AND voa01=g_voa01 
                AND voa02=g_voa02
                AND voa03=g_voa1[l_ac].voa03_1
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","voa_file",g_voa01,g_voa02,SQLCA.sqlcode,"","",1)  
                LET g_voa1[l_ac].voa40_1 = l_voa40t
                CLOSE t800_b1_cl
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_voa1[l_ac].voa40_1 = l_voa40t
             END IF
             CLOSE t800_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE t800_b1_cl
          COMMIT WORK
 
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION help          
          CALL cl_show_help()  
   END INPUT
 
   CLOSE t800_b1_cl
   COMMIT WORK
END FUNCTION
 
 
#合約訂單
FUNCTION t800_b2()
DEFINE
   l_lock_sw       LIKE type_file.chr1,   #單身鎖住否      
   p_cmd           LIKE type_file.chr1,   #處理狀態       
   l_exit_sw       LIKE type_file.chr1,   
   l_allow_insert  LIKE type_file.num5,   #可新增否       
   l_allow_delete  LIKE type_file.num5,   #可刪除否      
   l_voa40t        LIKE voa_file.voa40
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_voa01) OR cl_null(g_voa02) THEN RETURN END IF
   IF g_rec_b2 = 0 THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT * ",
                      " FROM voa_file",
                      " WHERE voa00=? AND voa01=? AND voa02=? AND voa03=?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t800_b2_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   INPUT ARRAY g_voa2 WITHOUT DEFAULTS FROM s_voa2.*
         ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
     BEFORE INPUT
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF
 
     BEFORE ROW
       LET p_cmd=''
       LET l_ac2 = ARR_CURR()
       LET l_lock_sw = 'N'            #DEFAULT
 
       BEGIN WORK
       IF g_rec_b2>= l_ac2 THEN
          LET p_cmd='u'
          OPEN t800_b2_cl USING g_plant,g_voa01,g_voa02,g_voa2[l_ac2].voa03_2 #FUN-840209
          IF STATUS THEN
             CALL cl_err("OPEN t800_b2_cl:", STATUS, 1)
             LET l_lock_sw = "Y"
          END IF
          LET l_voa40t = g_voa2[l_ac2].voa40_2
       END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_voa2[l_ac2].voa40_2 = l_voa40t
             CLOSE t800_b2_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_voa2[l_ac2].voa03_2,-263,1)
          ELSE
             UPDATE voa_file SET voa40 = g_voa2[l_ac2].voa40_2
              WHERE voa00=g_plant  #FUN-840209
                AND voa01=g_voa01 
                AND voa02=g_voa02
                AND voa03=g_voa2[l_ac2].voa03_2
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","voa_file",g_voa01,g_voa02,SQLCA.sqlcode,"","",1)  
                LET g_voa2[l_ac2].voa40_2 = l_voa40t
                CLOSE t800_b2_cl
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac2 = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_voa2[l_ac2].voa40_2 = l_voa40t
             END IF
             CLOSE t800_b2_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE t800_b2_cl
          COMMIT WORK
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION help          
          CALL cl_show_help()  
   END INPUT
 
   CLOSE t800_b2_cl
   COMMIT WORK
END FUNCTION
 
 
#獨立需求
FUNCTION t800_b3()
DEFINE
   l_lock_sw       LIKE type_file.chr1,   #單身鎖住否      
   p_cmd           LIKE type_file.chr1,   #處理狀態       
   l_exit_sw       LIKE type_file.chr1,   
   l_allow_insert  LIKE type_file.num5,   #可新增否       
   l_allow_delete  LIKE type_file.num5,   #可刪除否      
   l_voa40t        LIKE voa_file.voa40
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_voa01) OR cl_null(g_voa02) THEN RETURN END IF
   IF g_rec_b3 = 0 THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT * ",
                      " FROM voa_file",
                      " WHERE voa00=? AND voa01=? AND voa02=? AND voa03=?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t800_b3_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   INPUT ARRAY g_voa3 WITHOUT DEFAULTS FROM s_voa3.*
         ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
     BEFORE INPUT
         IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(l_ac3)
         END IF
 
     BEFORE ROW
       LET p_cmd=''
       LET l_ac3 = ARR_CURR()
       LET l_lock_sw = 'N'            #DEFAULT
 
       BEGIN WORK
       IF g_rec_b3>= l_ac3 THEN
          LET p_cmd='u'
          OPEN t800_b3_cl USING g_plant,g_voa01,g_voa02,g_voa3[l_ac3].voa03_3 #FUN-840209
          IF STATUS THEN
             CALL cl_err("OPEN t800_b3_cl:", STATUS, 1)
             LET l_lock_sw = "Y"
          END IF
          LET l_voa40t = g_voa3[l_ac3].voa40_3
       END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_voa3[l_ac3].voa40_3 = l_voa40t
             CLOSE t800_b3_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_voa3[l_ac3].voa03_3,-263,1)
          ELSE
             UPDATE voa_file SET voa40 = g_voa3[l_ac3].voa40_3
              WHERE voa00=g_plant  #FUN-840209
                AND voa01=g_voa01 
                AND voa02=g_voa02
                AND voa03=g_voa3[l_ac3].voa03_3
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","voa_file",g_voa01,g_voa02,SQLCA.sqlcode,"","",1)  
                LET g_voa3[l_ac3].voa40_3 = l_voa40t
                CLOSE t800_b3_cl
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac3 = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_voa3[l_ac3].voa40_3 = l_voa40t
             END IF
             CLOSE t800_b3_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE t800_b3_cl
          COMMIT WORK
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION help          
          CALL cl_show_help()  
   END INPUT
 
   CLOSE t800_b3_cl
   COMMIT WORK
END FUNCTION
 
 
#銷售預測
FUNCTION t800_b4()
DEFINE
   l_lock_sw       LIKE type_file.chr1,   #單身鎖住否      
   p_cmd           LIKE type_file.chr1,   #處理狀態       
   l_exit_sw       LIKE type_file.chr1,   
   l_allow_insert  LIKE type_file.num5,   #可新增否       
   l_allow_delete  LIKE type_file.num5,   #可刪除否      
   l_voa40t   LIKE voa_file.voa40
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_voa01) OR cl_null(g_voa02) THEN RETURN END IF
   IF g_rec_b4 = 0 THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT * ",
                      " FROM voa_file",
                      " WHERE voa00=? AND voa01=? AND voa02=? AND voa03=?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t800_b4_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   INPUT ARRAY g_voa4 WITHOUT DEFAULTS FROM s_voa4.*
         ATTRIBUTE(COUNT=g_rec_b4,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
     BEFORE INPUT
         IF g_rec_b4 != 0 THEN
            CALL fgl_set_arr_curr(l_ac4)
         END IF
 
     BEFORE ROW
       LET p_cmd=''
       LET l_ac4 = ARR_CURR()
       LET l_lock_sw = 'N'            #DEFAULT
 
       BEGIN WORK
       IF g_rec_b4>= l_ac4 THEN
          LET p_cmd='u'
          OPEN t800_b4_cl USING g_plant,g_voa01,g_voa02,g_voa4[l_ac4].voa03_4 #FUN-840209
          IF STATUS THEN
             CALL cl_err("OPEN t800_b4_cl:", STATUS, 1)
             LET l_lock_sw = "Y"
          END IF
          LET l_voa40t = g_voa4[l_ac4].voa40_4
       END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_voa4[l_ac4].voa40_4 = l_voa40t
             CLOSE t800_b4_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_voa4[l_ac4].voa03_4,-263,1)
          ELSE
             UPDATE voa_file SET voa40 = g_voa4[l_ac4].voa40_4
              WHERE voa00=g_plant  #FUN-840209
                AND voa01=g_voa01 
                AND voa02=g_voa02
                AND voa03=g_voa4[l_ac4].voa03_4
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","voa_file",g_voa01,g_voa02,SQLCA.sqlcode,"","",1)  
                LET g_voa4[l_ac4].voa40_4 = l_voa40t
                CLOSE t800_b4_cl
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac4 = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_voa4[l_ac4].voa40_4 = l_voa40t
             END IF
             CLOSE t800_b4_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE t800_b4_cl
          COMMIT WORK
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION help          
          CALL cl_show_help()  
   END INPUT
 
   CLOSE t800_b4_cl
   COMMIT WORK
END FUNCTION
 
 
#一般訂單
FUNCTION t800_b1_fill(p_wc1)
DEFINE
    p_wc1          STRING     #NO.FUN-910082    
 
    IF cl_null(p_wc1) THEN LET p_wc1 = ' 1=1' END IF
 
    IF g_vld05 = '1' THEN  
      LET g_sql = "SELECT case when voa40 is null then 'N' else voa40 end voa40,oea49,voa14,voa08,'',",  #FUN-840209
                  "       vmu26,voa04,'',   oeb12,oeb15,",
                  "       voa23,oeb24,oea14,'',voa03",
                  "  FROM voa_file,vmu_file,oea_file,oeb_file ",
                  " WHERE voa00 ='",g_plant,"'",  #FUN-840209
                  "   AND voa01 ='",g_voa01,"'",
                  "   AND voa02 ='",g_voa02,"'",
                  "   AND ",p_wc1 CLIPPED,
                  "   AND voa01=vmu01 AND voa02=vmu02 AND voa03=vmu03 ",
                  "   AND vmu25='1'",
                  "   AND oeb01=vmu11 AND oeb03=vmu26",
                  "   AND oeb01=oea01 ",
                  "   AND (voa23 is not null and voa23<>oeb15) ", #FUN-840209 
                  " ORDER BY voa03"
    ELSE
      LET g_sql = "SELECT case when voa40 is null then 'N' else voa40 end voa40,oea49,voa14,voa08,'',", #FUN-840209
                  "       vmu26,voa04,'',   oeb12,oeb16,",
                  "       voa23,oeb24,oea14,'',voa03",
                  "  FROM voa_file,vmu_file,oea_file,oeb_file ",
                  " WHERE voa00 ='",g_plant,"'",  #FUN-840209
                  "   AND voa01 ='",g_voa01,"'",
                  "   AND voa02 ='",g_voa02,"'",
                  "   AND ",p_wc1 CLIPPED,
                  "   AND voa01=vmu01 AND voa02=vmu02 AND voa03=vmu03 ",
                  "   AND vmu25='1'",
                  "   AND oeb01=vmu11 AND oeb03=vmu26",
                  "   AND oeb01=oea01 ",
                  "   AND (voa23 is not null and voa23<>oeb16) ", #FUN-840209
                  " ORDER BY voa03"
    END IF
    PREPARE t800_pb1 FROM g_sql
    DECLARE voa1_curs1 CURSOR FOR t800_pb1
 
    CALL g_voa1.clear()
    LET g_cnt= 1
    FOREACH voa1_curs1 INTO g_voa1[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       IF g_voa1[g_cnt].oea49_1 = '0' THEN LET g_voa1[g_cnt].oea49_1 = 'A' END IF
       IF g_voa1[g_cnt].oea49_1 = '1' THEN LET g_voa1[g_cnt].oea49_1 = 'B' END IF
 
       SELECT occ02 INTO g_voa1[g_cnt].occ02_1  
         FROM occ_file WHERE occ01 = g_voa1[g_cnt].voa08_1
       IF SQLCA.sqlcode THEN LET g_voa1[g_cnt].occ02_1 = '' END IF
 
       SELECT ima02 INTO g_voa1[g_cnt].ima02_1  
         FROM ima_file WHERE ima01 = g_voa1[g_cnt].voa04_1
       IF SQLCA.sqlcode THEN LET g_voa1[g_cnt].ima02_1 = '' END IF
 
       SELECT gen02 INTO g_voa1[g_cnt].gen02_1  
         FROM gen_file WHERE gen01 = g_voa1[g_cnt].oea14_1
       IF SQLCA.sqlcode THEN LET g_voa1[g_cnt].gen02_1 = '' END IF
 
       LET g_cnt=g_cnt+1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_voa1.deleteElement(g_cnt)
    LET g_rec_b1 = g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cn2
END FUNCTION
 
 
#合約訂單
FUNCTION t800_b2_fill(p_wc1)
DEFINE
    p_wc1          STRING     #NO.FUN-910082    
 
    IF cl_null(p_wc1) THEN LET p_wc1 = ' 1=1' END IF
 
    IF g_vld05 = '1' THEN  
      LET g_sql = "SELECT case when voa40 is null then 'N' else voa40 end voa40,oea49,voa14,voa08,'',", #FUN-840209
                  "       vmu26,voa04,'',   oeb12,oeb15,",
                  "       voa23,oeb24,oea14,'',voa03",
                  "  FROM voa_file,vmu_file,oea_file,oeb_file ",
                  " WHERE voa00 ='",g_plant,"'", #FUN-840209
                  "   AND voa01 ='",g_voa01,"'",
                  "   AND voa02 ='",g_voa02,"'",
                  "   AND ",p_wc1 CLIPPED,
                  "   AND voa01=vmu01 AND voa02=vmu02 AND voa03=vmu03 ",
                  "   AND vmu25='0'",
                  "   AND oeb01=vmu11 AND oeb03=vmu26",
                  "   AND oeb01=oea01 ",
                  "   AND (voa23 is not null and voa23<>oeb15) ",  #FUN-840209
                  " ORDER BY voa03"
    ELSE
      LET g_sql = "SELECT case when voa40 is null then 'N' else voa40 end voa40,oea49,voa14,voa08,'',", #FUN-840209
                  "       vmu26,voa04,'',   oeb12,oeb16,",
                  "       voa23,oeb24,oea14,'',voa03",
                  "  FROM voa_file,vmu_file,oea_file,oeb_file ",
                  " WHERE voa00 ='",g_plant,"'", #FUN-840209
                  "   AND voa01 ='",g_voa01,"'",
                  "   AND voa02 ='",g_voa02,"'",
                  "   AND ",p_wc1 CLIPPED,
                  "   AND voa01=vmu01 AND voa02=vmu02 AND voa03=vmu03 ",
                  "   AND vmu25='0'",
                  "   AND oeb01=vmu11 AND oeb03=vmu26",
                  "   AND oeb01=oea01 ",
                  "   AND (voa23 is not null and voa23<>oeb16) ",  #FUN-840209 
                  " ORDER BY voa03"
    END IF
    PREPARE t800_pb2 FROM g_sql
    DECLARE voa2_curs1 CURSOR FOR t800_pb2
 
    CALL g_voa2.clear()
    LET g_cnt= 1
    FOREACH voa2_curs1 INTO g_voa2[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       IF g_voa2[g_cnt].oea49_2 = '0' THEN LET g_voa2[g_cnt].oea49_2 = 'A' END IF
       IF g_voa2[g_cnt].oea49_2 = '1' THEN LET g_voa2[g_cnt].oea49_2 = 'B' END IF
 
       SELECT occ02 INTO g_voa2[g_cnt].occ02_2  
         FROM occ_file WHERE occ01 = g_voa2[g_cnt].voa08_2
       IF SQLCA.sqlcode THEN LET g_voa2[g_cnt].occ02_2 = '' END IF
 
       SELECT ima02 INTO g_voa2[g_cnt].ima02_2  
         FROM ima_file WHERE ima01 = g_voa2[g_cnt].voa04_2
       IF SQLCA.sqlcode THEN LET g_voa2[g_cnt].ima02_2 = '' END IF
 
       SELECT gen02 INTO g_voa2[g_cnt].gen02_2  
         FROM gen_file WHERE gen01 = g_voa2[g_cnt].oea14_2
       IF SQLCA.sqlcode THEN LET g_voa2[g_cnt].gen02_2 = '' END IF
 
       LET g_cnt=g_cnt+1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_voa2.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
END FUNCTION
 
 
#獨立需求
FUNCTION t800_b3_fill(p_wc1)
DEFINE
    p_wc1          STRING     #NO.FUN-910082    
 
    IF cl_null(p_wc1) THEN LET p_wc1 = ' 1=1' END IF
 
     #LET g_sql = "SELECT voa40,'A',voa14,",                                                 #FUN-B50020(2)
      LET g_sql = "SELECT case when voa40 is null then 'N' else voa40 end voa40,'A',voa14,", #FUN-B50020(2)
                  "       vmu26,voa04,'',   rpc13,rpc12,",
                  "       voa23,rpc131,voa03",
                  "  FROM voa_file,vmu_file,rpc_file ",
                  " WHERE voa00 ='",g_plant,"'",  #FUN-840209
                  "   AND voa01 ='",g_voa01,"'",
                  "   AND voa02 ='",g_voa02,"'",
                  "   AND ",p_wc1 CLIPPED,
                  "   AND voa01=vmu01 AND voa02=vmu02 AND voa03=vmu03 ",
                  "   AND vmu25='2'",
                  "   AND rpc02=vmu11 AND rpc03=vmu26",
                  "   AND  (voa23<>rpc12 or voa23 is null) ", #FUN-840209
                  " ORDER BY voa03"
    PREPARE t800_pb3 FROM g_sql
    DECLARE voa3_curs1 CURSOR FOR t800_pb3
 
    CALL g_voa3.clear()
    LET g_cnt= 1
    FOREACH voa3_curs1 INTO g_voa3[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       SELECT ima02 INTO g_voa3[g_cnt].ima02_3  
         FROM ima_file WHERE ima01 = g_voa3[g_cnt].voa04_3
       IF SQLCA.sqlcode THEN LET g_voa3[g_cnt].ima02_3 = '' END IF
 
       LET g_cnt=g_cnt+1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_voa3.deleteElement(g_cnt)
    LET g_rec_b3 = g_cnt-1
    DISPLAY g_rec_b3 TO FORMONLY.cn2
END FUNCTION
 
 
#銷售預測
FUNCTION t800_b4_fill(p_wc1)
DEFINE
    p_wc1          STRING     #NO.FUN-910082     
 
    IF cl_null(p_wc1) THEN LET p_wc1 = ' 1=1' END IF
 
    IF g_vld11 = '1' THEN  
     #LET g_sql = "SELECT voa40,'A',voa08,'',",                                                 #FUN-B50020(2)
      LET g_sql = "SELECT case when voa40 is null then 'N' else voa40 end voa40,'A',voa08,'',", #FUN-B50020(2)
                  "       vmu26,voa04,'',opd08,opd06,",
                  "       voa23,opd04,'',voa03",
                  "  FROM voa_file,vmu_file,opd_file ",
                  " WHERE voa00 ='",g_plant,"'",  #FUN-840209
                  "   AND voa01 ='",g_voa01,"'",
                  "   AND voa02 ='",g_voa02,"'",
                  "   AND ",p_wc1 CLIPPED,
                  "   AND voa01=vmu01 AND voa02=vmu02 AND voa03=vmu03 ",
                  "   AND vmu25='3'",
                  "   AND opd01=voa04 AND opd02=voa08 ",
                  "   AND opd03=vmu18 AND opd04=vmu16 ",
                  "   AND opd05=vmu26 ",
                  "   AND (voa23<>opd06 or voa23 is null) ", #FUN-840209
                  " ORDER BY voa03"
    ELSE
     #LET g_sql = "SELECT voa40,'A',voa08,'',", #FUN-B50020(2)
      LET g_sql = "SELECT case when voa40 is null then 'N' else voa40 end voa40,'A',voa08,'',", #FUN-B50020(2)
                  "       vmu26,voa04,'',opd09,opd06,",
                  "       voa23,opd04,'',voa03",
                  "  FROM voa_file,vmu_file,opd_file ",
                  " WHERE voa00 ='",g_plant,"'",  #FUN-840209
                  "   AND voa01 ='",g_voa01,"'",
                  "   AND voa02 ='",g_voa02,"'",
                  "   AND ",p_wc1 CLIPPED,
                  "   AND voa01=vmu01 AND voa02=vmu02 AND voa03=vmu03 ",
                  "   AND vmu25='3'",
                  "   AND opd01=voa04 AND opd02=voa08 ",
                  "   AND opd03=vmu18 AND opd04=vmu16 ",
                  "   AND opd05=vmu26 ",
                  "   AND (voa23<>opd06 or voa23 is null) ", #FUN-840209 
                  " ORDER BY voa03"
    END IF
 
    PREPARE t800_pb4 FROM g_sql
    DECLARE voa4_curs1 CURSOR FOR t800_pb4
 
    CALL g_voa4.clear()
    LET g_cnt= 1
    FOREACH voa4_curs1 INTO g_voa4[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       SELECT occ02 INTO g_voa4[g_cnt].occ02_4
         FROM occ_file
        WHERE occ01 = g_voa4[g_cnt].voa08_4
       IF SQLCA.sqlcode THEN LET g_voa4[g_cnt].occ02_4 = '' END IF
 
       
       SELECT ima02 INTO g_voa4[g_cnt].ima02_4  
         FROM ima_file WHERE ima01 = g_voa4[g_cnt].voa04_4
       IF SQLCA.sqlcode THEN LET g_voa4[g_cnt].ima02_4 = '' END IF
 
       SELECT gen02 INTO g_voa4[g_cnt].gen02_4
         FROM gen_file
        WHERE gen01 = g_voa4[g_cnt].opc04
       IF SQLCA.sqlcode THEN LET g_voa4[g_cnt].gen02_4 = '' END IF
 
       LET g_cnt=g_cnt+1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_voa4.deleteElement(g_cnt)
    LET g_rec_b4 = g_cnt-1
    DISPLAY g_rec_b4 TO FORMONLY.cn2
END FUNCTION
 
 
 
#一般訂單
FUNCTION t800_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   DISPLAY g_rec_b1 TO FORMONLY.cn2
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
 
   DISPLAY ARRAY g_voa1 TO s_voa1.* ATTRIBUTE(COUNT=g_rec_b1)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION page02   #合約訂單
         LET l_action_flag = "page02"
         EXIT DISPLAY
      ON ACTION page03   #獨立需求
         LET l_action_flag = "page03"
         EXIT DISPLAY
      ON ACTION page04   #銷售預測
         LET l_action_flag = "page04"
         EXIT DISPLAY
 
      ON ACTION mtn_so   #訂單維護
         LET g_action_choice = "mtn_so"
         EXIT DISPLAY
 
      ON ACTION mtn_so_adj   #訂單變更單維護
         LET g_action_choice = "mtn_so_adj"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t800_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b1 != 0 THEN
          CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY
 
      ON ACTION previous
         CALL t800_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL t800_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL t800_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL t800_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
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
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="page01"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#合約訂單
FUNCTION t800_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   DISPLAY g_rec_b2 TO FORMONLY.cn2
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
 
   DISPLAY ARRAY g_voa2 TO s_voa2.* ATTRIBUTE(COUNT=g_rec_b2)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
 
      ON ACTION page01   #一般訂單
         LET l_action_flag = "page01"
         EXIT DISPLAY
      ON ACTION page03   #獨立需求
         LET l_action_flag = "page03"
         EXIT DISPLAY
      ON ACTION page04   #銷售預測
         LET l_action_flag = "page04"
         EXIT DISPLAY
 
      ON ACTION mtn_const   #合約維護
         LET g_action_choice = "mtn_const"
         EXIT DISPLAY
 
      ON ACTION mtn_so_adj   #訂單變更單維護
         LET g_action_choice = "mtn_so_adj"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t800_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b2 != 0 THEN
          CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY
 
      ON ACTION previous
         CALL t800_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL t800_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL t800_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL t800_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
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
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="page01"
         LET l_ac2 = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#獨立需求
FUNCTION t800_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   DISPLAY g_rec_b3 TO FORMONLY.cn2
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
 
   DISPLAY ARRAY g_voa3 TO s_voa3.* ATTRIBUTE(COUNT=g_rec_b3)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac3 = ARR_CURR()
 
      ON ACTION page01   #一般訂單
         LET l_action_flag = "page01"
         EXIT DISPLAY
      ON ACTION page02   #合約訂單
         LET l_action_flag = "page02"
         EXIT DISPLAY
      ON ACTION page04   #銷售預測
         LET l_action_flag = "page04"
         EXIT DISPLAY
 
      ON ACTION mtn_indpt   #獨立需求維護
         LET g_action_choice = "mtn_indpt"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t800_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b3 != 0 THEN
          CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY
 
      ON ACTION previous
         CALL t800_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL t800_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL t800_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL t800_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
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
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="page01"
         LET l_ac3 = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#銷售預測
FUNCTION t800_bp4(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   DISPLAY g_rec_b4 TO FORMONLY.cn2
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
 
   DISPLAY ARRAY g_voa4 TO s_voa4.* ATTRIBUTE(COUNT=g_rec_b4)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac4 = ARR_CURR()
 
      ON ACTION page01   #一般訂單
         LET l_action_flag = "page01"
         EXIT DISPLAY
      ON ACTION page02   #合約訂單
         LET l_action_flag = "page02"
         EXIT DISPLAY
      ON ACTION page03   #獨立需求
         LET l_action_flag = "page03"
         EXIT DISPLAY
 
      ON ACTION mtn_forecast   #銷售預測維護
         LET g_action_choice = "mtn_forecast"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t800_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b4 != 0 THEN
          CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY
 
      ON ACTION previous
         CALL t800_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b4 != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL t800_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b4 != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL t800_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b4 != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL t800_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b4 != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
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
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="page01"
         LET l_ac4 = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
 
