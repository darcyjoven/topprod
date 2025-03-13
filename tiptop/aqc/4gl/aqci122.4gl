# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aqci122.4gl
# Descriptions...: 材料類別檢驗項目AQL設定作業
# Date & Author..: 02/01/15 By Melody
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0160 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790099 07/09/17 By lumxa  錄入的下限值可大于上限值，無控管
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.FUN-910079 09/02/20 By ve007 增加品管類型的邏輯
# Modify.........: No.TQC-950129 09/05/21 By chenmoyan 單頭新增料號開窗default值給了''
# Modify.........: No.TQC-980079 09/08/12 By lilingyu 資料全部查詢出,刪除一筆資料后,無法顯示下一筆資料 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A60050 10/06/12 By houlia INSERT 與values的字段不一致，調整
# Modify.........: No.FUN-A80063 10/08/16 By wujie     qck04和qck05位置互换
#                                                      qck05增加item选项及控管
# Modify.........: No.TQC-AB0041 10/11/09 By Lixh1 BUG修正
# Modify.........: No.MOD-AC0317 10/12/27 By chenying 程序未修改，只是過單 
# Modify.........: No.MOD-B30221 11/03/12 By wangxin  程序未修改，過單同步per 
# Modify.........: No:TQC-B30121 11/03/14 By Nicola 重新過單
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BC0104 11/12/29 By xujing 增加"QC判定料件否(qck09)"
# Modify.........: No.FUN-BB0086 12/02/08 By xujing BUG修改,更改ACTION 死循環 
# Modify.........: No.FUN-C20047 12/02/09 By xujing 修改QC判定問題
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/17 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_qck01         LIKE qck_file.qck01,   #類別代號 (假單頭)
    g_qck09         LIKE qck_file.qck09,   #FUN-BC0104 add qck09
    g_qckacti       LIKE qck_file.qckacti, #    96-06-18
    g_qckuser       LIKE qck_file.qckuser, #
    g_qckgrup       LIKE qck_file.qckgrup, #
    g_qckmodu       LIKE qck_file.qckmodu, #
    g_qckdate       LIKE qck_file.qckdate, #
    g_qck01_t       LIKE qck_file.qck01,   #類別代號 (舊值)
    g_qck09_t       LIKE qck_file.qck09,   #FUN-BC0104 add qck09
    g_qck           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        qck02       LIKE qck_file.qck02,
		azf03       LIKE azf_file.azf03,
        ta_qck01    LIKE qck_file.ta_qck01,
		qck08       LIKE qck_file.qck08,            #No.FUN-910079
		qck03       LIKE qck_file.qck03,
#No.FUN-A80063 --begin
		qck05       LIKE qck_file.qck05,
		qck04       LIKE qck_file.qck04,
#No.FUN-A80063 --end
		qck061      LIKE qck_file.qck061,
		qck062      LIKE qck_file.qck062,
		qck07       LIKE qck_file.qck07
          # hlf add
                    END RECORD,
    g_qck_t         RECORD                 #程式變數 (舊值)
        qck02       LIKE qck_file.qck02,
		azf03       LIKE azf_file.azf03,
        ta_qck01    LIKE qck_file.ta_qck01,
		qck08       LIKE qck_file.qck08,            #No.FUN-910079
		qck03       LIKE qck_file.qck03,
#No.FUN-A80063 --begin
		qck05       LIKE qck_file.qck05,
		qck04       LIKE qck_file.qck04,
#No.FUN-A80063 --end
		qck061      LIKE qck_file.qck061,
		qck062      LIKE qck_file.qck062,
		qck07       LIKE qck_file.qck07 #hlf add
                    END RECORD,
    g_qck_lock   RECORD LIKE qck_file.*,  #FUN-BC0104 add 
    g_before_input_done  LIKE type_file.num5, #FUN-BC0104 add
    g_argv1         LIKE qck_file.qck01,
     g_wc,g_sql     STRING,                      #No.FUN-580092 HCN
    g_ss            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)             #決定後續步驟
    g_rec_b         LIKE type_file.num5,         #單身筆數        #No.FUN-680104 SMALLINT
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql     STRING                   #SELECT ... FOR UPDATE SQL        #No.FUN-680104
DEFINE g_chr          LIKE type_file.chr1        #No.FUN-680104 VARCHAR(1)
DEFINE g_cnt          LIKE type_file.num10       #No.FUN-680104 INTEGER
DEFINE g_msg          LIKE type_file.chr1000     #No.FUN-680104 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10       #No.FUN-680104 INTEGER
DEFINE g_curs_index   LIKE type_file.num10       #No.FUN-680104 INTEGER
DEFINE g_jump         LIKE type_file.num10       #TQC-980079
DEFINE mi_no_ask      LIKE type_file.num5        #TQC-980079
 
MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0085
    p_row,p_col   LIKE type_file.num5            #No.FUN-680104 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AQC")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1)           #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
    RETURNING g_time                         #No.FUN-6A0085
    LET g_argv1  = ARG_VAL(1)                #料件編號
    LET g_qck01 = NULL                       #清除鍵值
    LET g_qck01_t = NULL
    LET g_qck09_t = NULL                     #FUN-BC0104
    LET g_qck01 = g_argv1
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i122_w AT p_row,p_col
        WITH FORM "aqc/42f/aqci122"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    #FUN-BC0104---add---str
    CALL i122_set_comp_visible() 
    LET g_forupd_sql = "SELECT * FROM qck_file WHERE qck01 = ? ",
                      " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i122_cl CURSOR FROM g_forupd_sql                 
    #FUN-BC0104---add---end
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
	   CALL  i122_q()
    END IF
    CALL i122_menu()
    CLOSE WINDOW i122_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)      #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
    RETURNING g_time                    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION i122_curs()
    CLEAR FORM                             #清除畫面
    CALL g_qck.clear()
    IF g_argv1 IS NULL OR g_argv1 = ' ' THEN
   
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_qck01 TO NULL    #No.FUN-750051
   INITIALIZE g_qck09 LIKE qck_file.qck09   #FUN-BC0104
    CONSTRUCT g_wc ON qck01,qck09 FROM qck01,qck09   #FUN-BC0104 add qck09
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(qck01)
#                    CALL q_azf(10,3,'','8') RETURNING g_qck01
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azf"
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.arg1 = '8'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO qck01
                     NEXT FIELD qck01
                OTHERWISE EXIT CASE
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
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('qckuser', 'qckgrup') #FUN-980030
       IF INT_FLAG THEN RETURN END IF
    ELSE LET g_wc = " qck01 = '",g_argv1,"'"
    END IF
    LET g_sql= "SELECT UNIQUE qck01 FROM qck_file ", 
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i122_prepare FROM g_sql      #預備一下
    DECLARE i122_b_curs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i122_prepare
    LET g_sql="SELECT COUNT(DISTINCT qck01) FROM qck_file WHERE ",g_wc CLIPPED
    PREPARE i122_precount FROM g_sql
    DECLARE i122_count CURSOR FOR i122_precount
END FUNCTION
 
 
FUNCTION i122_menu()
 
   WHILE TRUE
      CALL i122_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i122_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i122_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i122_r()
            END IF
         #FUN-BC0104---add---str
         WHEN "modify"
              IF cl_chk_act_auth() THEN
                 CALL i122_u()
              END IF
         #FUN-BC0104---add---end 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i122_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i122_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qck),'','')
            END IF
         #No.FUN-6A0160-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_qck01 IS NOT NULL THEN
                 LET g_doc.column1 = "qck01"
                 LET g_doc.value1 = g_qck01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0160-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i122_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_qck.clear()
    INITIALIZE g_qck01 LIKE qck_file.qck01
    INITIALIZE g_qck09 LIKE qck_file.qck09
    LET g_qck01_t = NULL
    LET g_qck09_t = NULL #FUN-BC0104
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i122_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ss='N' THEN
            CALL g_qck.clear()
            LET g_rec_b = 0   #TQC-A60050 houlia
        ELSE
            CALL i122_b_fill('1=1')         #單身
        END IF
        CALL i122_b()                   #輸入單身
        LET g_qck01_t = g_qck01            #保留舊值
        LET g_qck09_t = g_qck09            #FUN-BC0104
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i122_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680104 VARCHAR(1)

    #FUN-BC0104---mark---str 
    #LET g_ss='Y'
    #LET g_qckacti = 'Y'             # 有效的資料 96-06-18
    #LET g_qckuser = g_user          # 使用者
    #LET g_qckgrup = g_grup          # 使用者所屬群
    #LET g_qckdate = g_today         # 更改日期
    #LET g_qck09 = 'N'               #FUN-BC0104
    #FUN-BC0104---mark---end
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT g_qck01,g_qck09           #FUN-BC0104 add qck09
        WITHOUT DEFAULTS
        FROM qck01,qck09            #FUN-BC0104 add qck09

        #FUN-BC0104---add---str
        BEFORE INPUT
           IF p_cmd = 'a' THEN
              LET g_ss='Y'
              LET g_qckacti = 'Y'             # 有效的資料 96-06-18
              LET g_qckuser = g_user          # 使用者
              LET g_qckgrup = g_grup          # 使用者所屬群
              LET g_qckdate = g_today         # 更改日期
              LET g_qck09 = 'N'     
              DISPLAY g_qck09 TO qck09   
           END IF
           LET g_before_input_done = FALSE
           CALL i122_set_entry(p_cmd)
           CALL i122_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        #FUN-BC0104---add---end
        
        AFTER FIELD qck01                  #類別代號
            IF NOT cl_null(g_qck01) THEN
                IF g_qck01 != g_qck01_t OR     #輸入後更改不同時值
                   g_qck01_t IS NULL THEN
                    SELECT UNIQUE qck01 INTO g_chr
                        FROM qck_file
                        WHERE qck01=g_qck01
                    IF SQLCA.sqlcode THEN             #不存在, 新來的
                        IF p_cmd='a' THEN
                            LET g_ss='N'
                        END IF
                    ELSE
                        IF p_cmd='u' THEN
                            CALL cl_err(g_qck01,-239,0)
                            LET g_qck01=g_qck01_t
                            NEXT FIELD qck01
                        END IF
                    END IF
                    #FUN-BB0086---add---str--- 
                    CALL i122_qck01(p_cmd)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_qck01,g_errno,0)
                       NEXT FIELD qck01
                    END IF
                    #FUN-BB0086---add---end---
                END IF
                #FUN-BB0086---MARK---ADD
                #CALL i122_qck01(p_cmd)
                #IF NOT cl_null(g_errno) THEN
                #   CALL cl_err(g_qck01,g_errno,0)
                #   NEXT FIELD qck01
                #END IF
                #FUN-BB0086---MARK---END
                CALL i122_qck09_d(p_cmd) #FUN-BC0104
            END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(qck01)
#                    CALL q_azf(10,3,'','8') RETURNING g_qck01
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azf"
#                    LET g_qryparam.default1 = ''      #No.TQC-950129
                     LET g_qryparam.default1 = g_qck01 #No.TQC-950129
                     LET g_qryparam.arg1 = '8'
                     CALL cl_create_qry() RETURNING  g_qck01
                   #  DISPLAY BY NAME g_qck01  #TQC-AB0041
                     DISPLAY g_qck01 TO qck01     #TQC-AB0041
                     NEXT FIELD qck01
                OTHERWISE EXIT CASE
            END CASE
         #MOD-860081------add-----str---
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE INPUT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
         #MOD-860081------add-----end---
    END INPUT
END FUNCTION
 
FUNCTION  i122_qck01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
    l_azf03         LIKE azf_file.azf03,
    l_azfacti       LIKE azf_file.azfacti
 
    LET g_errno = ' '
    SELECT azf03 INTO l_azf03
        FROM azf_file
        WHERE azf01 = g_qck01 AND azf02='8'
    CASE WHEN STATUS=100          LET g_errno = 'mfg1306' #No.7926
              LET l_azf03 = NULL
         WHEN l_azfacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_azf03  TO FORMONLY.azf03_1
    END IF
END FUNCTION

#FUN-BC0104---add---str
FUNCTION i122_qck09_d(p_cmd)   
DEFINE l_n   LIKE type_file.num5
DEFINE p_cmd LIKE type_file.chr1
   
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM qck_file 
                   WHERE qck01 = g_qck01
   IF l_n >0 AND p_cmd = 'a' THEN
      SELECT qck09 INTO g_qck09 FROM qck_file
                   WHERE qck01 = g_qck01
      IF cl_null(g_qck09) THEN
         LET g_qck09 = 'N'
      END IF
      DISPLAY g_qck09 TO qck09
      CALL cl_set_comp_entry('qck09',FALSE)
   ELSE
      CALL cl_set_comp_entry('qck09',TRUE)
   END IF
END FUNCTION
#FUN-BC0104---add---end
 
FUNCTION  i122_qck01_c(p_qck01)
DEFINE
    p_qck01         LIKE qck_file.qck01,
    l_azf03         LIKE azf_file.azf03,
    l_azfacti       LIKE azf_file.azfacti
 
    LET g_errno = ''
    SELECT azf03 INTO l_azf03
        FROM azf_file
        WHERE azf01 = p_qck01 AND azf02='8'
    CASE WHEN STATUS=100          LET g_errno = 'mfg1306' #No.7926
              LET l_azf03 = NULL
         WHEN l_azfacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
       DISPLAY l_azf03  TO FORMONLY.azf03_1
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION i122_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_qck01 TO NULL             #No.FUN-6A0160
    INITIALIZE g_qck09 TO NULL             #FUN-BC0104
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i122_curs()                       #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_qck01 TO NULL
        INITIALIZE g_qck09 TO NULL             #FUN-BC0104
        RETURN
    END IF
    OPEN i122_b_curs                       #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_qck01 TO NULL
        INITIALIZE g_qck09 TO NULL         #FUN-BC0104
    ELSE
        CALL i122_fetch('F')               #讀出TEMP第一筆並顯示
        OPEN i122_count
        FETCH i122_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i122_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680104 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i122_b_curs INTO g_qck01
        WHEN 'P' FETCH PREVIOUS i122_b_curs INTO g_qck01
        WHEN 'F' FETCH FIRST    i122_b_curs INTO g_qck01
        WHEN 'L' FETCH LAST     i122_b_curs INTO g_qck01
        WHEN '/'
          IF (NOT mi_no_ask) THEN                   #TQC-980079
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
   #         PROMPT g_msg CLIPPED,': ' FOR l_abso   #TQC-980079
             PROMPT g_msg CLIPPED,': ' FOR g_jump   #TQC-980079   
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
            END PROMPT
          END IF                                    #TQC-980079  
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
       #     FETCH ABSOLUTE l_abso i122_b_curs INTO g_qck01  #TQC-980079 
             FETCH ABSOLUTE g_jump i122_b_curs INTO g_qck01   #TQC-980079    
            LET mi_no_ask = FALSE                            #TQC-980079                
    END CASE
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_qck01,SQLCA.sqlcode,0)
        INITIALIZE g_qck01 TO NULL
    ELSE
        SELECT qck09 INTO g_qck09 FROM qck_file WHERE qck01 = g_qck01     #FUN-BC0104
        CALL i122_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
 #         WHEN '/' LET g_curs_index = l_abso #TQC-980079 
           WHEN '/' LET g_curs_index = g_jump #TQC-980079  
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i122_show()
    DISPLAY g_qck01 TO qck01                 #單頭
    DISPLAY g_qck09 TO qck09                 #FUN-BC0104
    CALL i122_qck01('d')                     #單身
    CALL i122_b_fill(g_wc)                   #單身
    CALL cl_show_fld_cont()                  #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i122_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_qck01 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6A0160
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "qck01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_qck01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM qck_file WHERE qck01 = g_qck01
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660115
            CALL cl_err3("del","qck_file",g_qck01,"",SQLCA.sqlcode,"","BODY DELETE",1)  #No.FUN-660115
        ELSE
            CLEAR FORM
            CALL g_qck.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
#TQC-980079 --begin--
            OPEN i122_count
            #FUN-B50064-add-start--
            IF STATUS THEN
               CLOSE i122_b_curs
               CLOSE i122_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end-- 
            FETCH i122_count INTO g_row_count
            #FUN-B50064-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i122_b_curs
               CLOSE i122_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i122_b_curs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i122_fetch('L')
            ELSE
            	 LET g_jump = g_curs_index
               LET mi_no_ask = TRUE       	 
               CALL i122_fetch('/')
            END IF
         END IF           
#TQC-980079 --end--            
 
        LET g_msg=TIME
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i122_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT        #No.FUN-680104 SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用  #No.FUN-680104 SMALLINT
    l_n1            LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否  #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態    #No.FUN-680104 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,   #可新增否    #No.FUN-680104 VARCHAR(80)
    l_allow_insert  LIKE type_file.num5,      #可新增否    #No.FUN-680104 SMALLINT
    l_allow_delete  LIKE type_file.num5       #可刪除否    #No.FUN-680104 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_qck01 IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
    LET g_qckmodu=g_user          #修改者96-06-18
    LET g_qckdate=g_today         #修改日期
 #hlfadd ta_qck01
 
    LET g_forupd_sql =
#       "SELECT qck02,'',qck03,qck04,qck05,qck061,qck062,qck07,'' ",
       "SELECT qck02,'',ta_qck01,qck08,qck03,qck05,qck04,qck061,qck062,qck07,'' ",   #No.FUN-910079   #No.FUN-A80063
       "  FROM qck_file ",
       "  WHERE qck01= ? ",
       "   AND qck02= ? ",
       "FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i122_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_qck
              WITHOUT DEFAULTS
              FROM s_qck.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
           #IF g_qck_t.qck02 IS NOT NULL THEN
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_qck_t.* = g_qck[l_ac].*  #BACKUP
                BEGIN WORK
 
                OPEN i122_bcl USING g_qck01,g_qck_t.qck02
                IF STATUS THEN
                    CALL cl_err("OPEN i122_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i122_bcl INTO g_qck[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_qck_t.qck02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        LET g_qck_t.*=g_qck[l_ac].*
                    END IF
                END IF
                CALL i122_qck02('d')
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
#              CALL g_qck.deleteElement(l_ac)   #取消 Array Element
#              IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
#                 LET g_action_choice = "detail"
#                 LET l_ac = l_ac_t
#              END IF
#              EXIT INPUT
            END IF
            #FUN-BC0104---add---str
            IF cl_null(g_qck09) THEN 
               LET g_qck09 = 'N'
               DISPLAY g_qck09 TO qck09
            END IF 
            #FUN-BC0104---add---end  hlf
            INSERT INTO qck_file(qck01,qck09,qck02,qck03,qck04,qck05,qck061,qck062, #FUN-BC0104 add qck09
 #                  qck07,qckacti,qckuser,qckgrup,qckmodu,qckdate,qckoriu,qckorig)
 #                qck07,qck08,qckacti,qckuser,qckgrup,qckmodu,qckdate)      #No.FUN-910079 #TQC-A60050
                    qck07,qck08,ta_qck01,qckacti,qckuser,qckgrup,qckmodu,qckdate,qckoriu,qckorig)  #TQC-A60050 insert columns oriu, orig
            VALUES(g_qck01,g_qck09,g_qck[l_ac].qck02,g_qck[l_ac].qck03,      #FUN-BC0104 add qck09
                           g_qck[l_ac].qck04,g_qck[l_ac].qck05,
                           g_qck[l_ac].qck061,g_qck[l_ac].qck062,
#                           g_qck[l_ac].qck07,g_qckacti,g_qckuser,g_qckgrup,
                           g_qck[l_ac].qck07,g_qck[l_ac].qck08,g_qck[l_ac].ta_qck01,g_qckacti,g_qckuser,g_qckgrup,    #No.FUN-910079
                           g_qckmodu,g_qckdate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_qck[l_ac].qck02,SQLCA.sqlcode,0)   #No.FUN-660115
                CALL cl_err3("ins","qck_file",g_qck01,g_qck[l_ac].qck02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b = g_rec_b + 1
                COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_qck[l_ac].* TO NULL      #900423
            LET g_qck[l_ac].qck07='N'
            LET g_qck[l_ac].qck08='9'               #No.FUN-910079
            LET g_qck_t.* = g_qck[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD qck02
 
        AFTER FIELD qck02                        #check 序號是否重複
            IF NOT cl_null(g_qck[l_ac].qck02) THEN
                IF (g_qck[l_ac].qck02 != g_qck_t.qck02 OR
                    g_qck_t.qck02 IS NULL) THEN
                    SELECT count(*)
                        INTO l_n
                        FROM qck_file
                        WHERE qck01 = g_qck01 AND
                              qck02 = g_qck[l_ac].qck02
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_qck[l_ac].qck02 = g_qck_t.qck02
                        NEXT FIELD qck02
                      ELSE
                        CALL i122_qck02('a')
                        IF NOT cl_null(g_errno) THEN
                            CALL cl_err(g_qck[l_ac].qck02,g_errno,0)
                            LET g_qck[l_ac].qck02 = g_qck_t.qck02    #no.5185
                            NEXT FIELD qck02
                        END IF
                    END IF
                END IF
            END IF
    #hlf07751------------------- add----------------------------------------------
           AFTER FIELD ta_qck01
            IF NOT cl_null(g_qck[l_ac].ta_qck01)   
            THEN  
                SELECT count(*) INTO l_n1 FROM gfe_file WHERE gfeacti='Y' AND gfe01=g_qck[l_ac].ta_qck01
                IF l_n1=0 THEN CALL cl_err('','cqc-001',0)
                NEXT FIELD ta_qck01
            END IF   
            END IF
            
#hlf07751------------------end-----------------------------------------
 
	AFTER FIELD qck03
	    IF NOT cl_null(g_qck[l_ac].qck03) THEN
               IF g_qck[l_ac].qck03 NOT MATCHES'[123]' THEN
                   NEXT FIELD qck03
	       END IF
	    END IF
#No.FUN-A80063 --begin
  BEFORE FIELD qck05
      CALL cl_set_comp_entry('qck04,qck07',TRUE)
#No.FUN-A80063 --end
 
	AFTER FIELD qck05
	    IF NOT cl_null(g_qck[l_ac].qck05) THEN
	        IF g_qck[l_ac].qck05 NOT MATCHES "[1234]" THEN   #No.FUN-A80063
                   NEXT FIELD qck05
	        END IF
	    END IF
#No.FUN-A80063 --begin
      IF g_qck[l_ac].qck05 <> g_qck_t.qck05 OR g_qck_t.qck05 IS NULL THEN 
         IF g_qck[l_ac].qck05 MATCHES '[34]' THEN  
            LET g_qck[l_ac].qck04 =NULL             
            CALL cl_set_comp_entry('qck04',FALSE) 
         END IF                                    
         IF g_qck[l_ac].qck05 ='4' THEN 
            LET g_qck[l_ac].qck07 ='Y'
            CALL cl_set_comp_entry('qck07',FALSE)
         END IF 
      END IF 
      LET g_qck_t.qck05 = g_qck[l_ac].qck05
#No.FUN-A80063 --end
#TQC-AB0041--add--str--
      ON CHANGE qck05
         IF g_qck[l_ac].qck05 MATCHES '[12]' THEN
            CALL cl_set_comp_entry('qck04',TRUE)
         END IF
         IF g_qck[l_ac].qck05 MATCHES '[34]' THEN
            LET g_qck[l_ac].qck04 =NULL
            CALL cl_set_comp_entry('qck04',FALSE)
         END IF
#TQC-AB0041--add--end--
 
	AFTER FIELD qck07
	    IF NOT cl_null(g_qck[l_ac].qck07) THEN
	        IF g_qck[l_ac].qck07 NOT MATCHES "[YN]" THEN
                   NEXT FIELD qck07
	        END IF
	    END IF
#TQC-790099 --start---
        AFTER FIELD qck061
            IF NOT cl_null(g_qck[l_ac].qck061)
                AND (g_qck[l_ac].qck061 > g_qck[l_ac].qck062) THEN
                CALL cl_err('','aqc-719',1)
                NEXT FIELD qck061
            END IF 
                                                               
        AFTER FIELD qck062
            IF NOT cl_null(g_qck[l_ac].qck062) 
                AND (g_qck[l_ac].qck062 < g_qck[l_ac].qck061) THEN
                CALL cl_err('','aqc-719',1)
                NEXT FIELD qck062  
            END IF   
#No.FUN-A80063 --begin
            IF g_qck[l_ac].qck05 ='4' AND cl_null(g_qck[l_ac].qck061) AND cl_null(g_qck[l_ac].qck062) THEN 
               NEXT FIELD qck062
            END IF 
#No.FUN-A80063 --end
#TQC-790099 --end---  


        BEFORE DELETE                            #是否取消單身
            IF g_qck_t.qck02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM qck_file
                    WHERE qck01 = g_qck01 AND
                          qck02 = g_qck_t.qck02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_qck_t.qck02,SQLCA.sqlcode,0)   #No.FUN-660115
                    CALL cl_err3("del","qck_file",g_qck01,g_qck_t.qck02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b = g_rec_b - 1
            END IF
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_qck[l_ac].* = g_qck_t.*
               CLOSE i122_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_qck[l_ac].qck02,-263,1)
                LET g_qck[l_ac].* = g_qck_t.*
            ELSE
                UPDATE qck_file SET
                       qck02=g_qck[l_ac].qck02,
                       qck03=g_qck[l_ac].qck03,
                       qck04=g_qck[l_ac].qck04,
                       qck05=g_qck[l_ac].qck05,
                       qck061=g_qck[l_ac].qck061,
                       qck062=g_qck[l_ac].qck062,
                       qck07=g_qck[l_ac].qck07,
                       qck08=g_qck[l_ac].qck08,                #No.FUN-910079
                       ta_qck01=g_qck[l_ac].ta_qck01,
                       qckmodu=g_qckmodu,
                       qckdate=g_qckdate
                 WHERE qck01=g_qck01
                   AND qck02=g_qck_t.qck02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_qck[l_ac].qck02,SQLCA.sqlcode,0)   #No.FUN-660115
                    CALL cl_err3("upd","qck_file",g_qck01,g_qck_t.qck02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                    LET g_qck[l_ac].* = g_qck_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac   #FUN-D30034
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qck[l_ac].* = g_qck_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_qck.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE i122_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034
            CLOSE i122_bcl
            COMMIT WORK
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(qck02)     #廠商編號
#                    CALL q_azf(4,3,g_qck[l_ac].qck02,'6') RETURNING g_qck[l_ac].qck02
#                    CALL FGL_DIALOG_SETBUFFER( g_qck[l_ac].qck02 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azf"
                     LET g_qryparam.default1 = g_qck[l_ac].qck02
                     LET g_qryparam.arg1 = '6'
                     CALL cl_create_qry() RETURNING g_qck[l_ac].qck02
#                     CALL FGL_DIALOG_SETBUFFER( g_qck[l_ac].qck02 )
                     DISPLAY g_qck[l_ac].qck02 TO qck02
                     NEXT FIELD qck02
                 WHEN INFIELD(ta_qck01)     #单价 add by hlf
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gfe"
                     LET g_qryparam.default1 = g_qck[l_ac].ta_qck01
                     CALL cl_create_qry() RETURNING g_qck[l_ac].ta_qck01
                     DISPLAY g_qck[l_ac].ta_qck01 TO ta_qck01
                     NEXT FIELD ta_qck01
                OTHERWISE EXIT CASE
            END CASE
     #  ON ACTION CONTROLN
     #      CALL i122_b_askkey()
     #      EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(qck02) AND l_ac > 1 THEN
                LET g_qck[l_ac].* = g_qck[l_ac-1].*
                NEXT FIELD qck02
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
        END INPUT
 
    CLOSE i122_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i122_qck02(p_cmd)
    DEFINE p_cmd	LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
           l_azf03 LIKE azf_file.azf03
 
    LET g_errno = ' '
    SELECT azf03
        INTO g_qck[l_ac].azf03
        FROM azf_file
        WHERE azf01 = g_qck[l_ac].qck02
          AND azf02='6'
 
    CASE WHEN STATUS=100          LET g_errno = 'aqc-041' #No.7926
                            LET  g_qck[l_ac].azf03 = NULL
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i122_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
    CONSTRUCT l_wc ON qck02,qck03,qck04,qck05,qck061,qck062,qck07,ta_qck01
                 FROM s_qck[1].qck02,s_qck[1].qck03,s_qck[1].qck05,       #No.FUN-A80063
                      s_qck[1].qck04,s_qck[1].qck061,s_qck[1].qck062,s_qck[1].qck07,s_qck[1].ta_qck01
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
    IF INT_FLAG THEN RETURN END IF
    CALL i122_b_fill(l_wc)
END FUNCTION
 
FUNCTION i122_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
    LET g_sql =
#       "SELECT qck02,azf03,qck03,qck04,qck05,qck061,qck062,qck07 ",
       "SELECT qck02,azf03,ta_qck01,qck08,qck03,qck05,qck04,qck061,qck062,qck07 ",     #No.FUN-A80063
       " FROM qck_file LEFT OUTER JOIN azf_file ON qck02 = azf01 AND azf02 = '6'",
       " WHERE qck01 = '",g_qck01,"'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY 1"
    PREPARE i122_prepare2 FROM g_sql      #預備一下
    DECLARE qck_curs CURSOR FOR i122_prepare2
    CALL g_qck.clear()
    LET g_cnt = 1
    FOREACH qck_curs INTO g_qck[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_qck.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i122_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qck TO s_qck.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #FUN-C20047---add---str---
         IF g_qcz.qcz14 = 'N' THEN
            CALL DIALOG.setActionActive( "modify", 0 )
         END IF
         #FUN-C20047---add---end--- 
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      #FUN-BC0104---add---str
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      #FUN-BC0104---add---end
      ON ACTION first
         CALL i122_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i122_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i122_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i122_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i122_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6A0160  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i122_copy()
DEFINE l_newno,l_oldno1  LIKE qck_file.qck01,
       l_n           LIKE type_file.num5,          #No.FUN-680104 SMALLINT
       l_ima02       LIKE ima_file.ima02,
       l_ima021      LIKE ima_file.ima021
 
    IF s_shut(0) THEN RETURN END IF
    IF g_qck01 IS NULL
       THEN CALL cl_err('',-400,0)
            RETURN
    END IF
#bugno:5994 add....................................................
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       CALL cl_getmsg('mfg3161',g_lang) RETURNING g_msg
       MESSAGE g_msg
    ELSE
       DISPLAY '' AT 1,1
       CALL cl_getmsg('mfg3161',g_lang) RETURNING g_msg
       DISPLAY g_msg AT 2,1
    END IF
#bugno:5994 end....................................................
    DISPLAY ' ' TO qck01
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT l_newno FROM qck01
        AFTER FIELD qck01
            IF NOT cl_null(l_newno) THEN
                SELECT count(*)
                   INTO l_n
                   FROM qck_file
                   WHERE qck01 = l_newno
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    NEXT FIELD qck01
                END IF	
                CALL i122_qck01_c(l_newno)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_qck01,g_errno,0)
                   NEXT FIELD qck01
                END IF
            END IF
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(qck01)
#                 CALL q_azf(10,3,'','8') RETURNING l_newno
#                 CALL FGL_DIALOG_SETBUFFER( l_newno )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azf"
#                 LET g_qryparam.default1 = ''      #No.TQC-950129
                  LET g_qryparam.default1 = l_newno #No.TQC-950129
                  LET g_qryparam.arg1 = '8'
                  CALL cl_create_qry() RETURNING l_newno
#                  CALL FGL_DIALOG_SETBUFFER( l_newno )
                  DISPLAY l_newno TO qck01
                  NEXT FIELD qck01
                  
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
    IF INT_FLAG
       THEN LET INT_FLAG = 0
            DISPLAY  g_qck01 TO qck01
            RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM qck_file         #單身複製
        WHERE qck01 = g_qck01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_qck01,SQLCA.sqlcode,0)   #No.FUN-660115
       CALL cl_err3("ins","x",g_qck01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
       RETURN
    END IF
    UPDATE x
        SET qck01 = l_newno
    INSERT INTO qck_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660115
       CALL cl_err3("ins","qck_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno1= g_qck01
     LET g_qck01=l_newno
     CALL i122_u()   #FUN-BC0104
     CALL i122_b()
     #LET g_qck01=l_oldno1  #FUN-C80046
     #CALL i122_show()      #FUN-C80046
END FUNCTION

#FUN-BC0104---add---str
FUNCTION i122_set_comp_visible()
   IF g_qcz.qcz14 = 'N' THEN 
      CALL cl_set_comp_visible('qck09',FALSE)
   END IF
END FUNCTION

FUNCTION i122_u()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_qck01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   
   MESSAGE ""

   LET g_qck01_t = g_qck01 
   
   BEGIN WORK
   OPEN i122_cl USING g_qck01_t
   IF STATUS THEN
      CALL cl_err("OPEN i122_cl:", STATUS, 1)
      CLOSE i122_cl
      ROLLBACK WORK
      RETURN
   END IF

   IF g_qckacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_qck01,'mfg1000',0)
      RETURN
   END IF
   
   FETCH i122_cl INTO g_qck_lock.*             # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_qck01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i122_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL i122_show() 
   
   WHILE TRUE
      LET g_qckmodu=g_user
      LET g_qckdate=g_today
      CALL i122_i("u")                  
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL i122_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      UPDATE qck_file 
      SET qck09 = g_qck09,
          qckmodu=g_user,
          qckdate=g_today
       WHERE qck01 = g_qck01
      LET g_qckmodu=g_user
      LET g_qckdate=g_today
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","qck_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE i122_cl
   COMMIT WORK
   CALL cl_flow_notify(g_qck01,'U')
   MESSAGE "UPDATE O.K"
   DISPLAY BY NAME g_qckmodu,g_qckdate 
   CALL i122_b_fill("1=1")
END FUNCTION

FUNCTION i122_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1  
    IF p_cmd = 'a'  AND ( NOT g_before_input_done ) THEN
         CALL cl_set_comp_entry("qck01",TRUE)
    END IF

END FUNCTION

FUNCTION i122_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         
    
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("qck01",FALSE)
    END IF

END FUNCTION
#FUN-BC0104---add---end

#Patch....NO.TQC-610036 <001> #
#MOD-AC0317 過單 
#MOD-B30221 同步per過單
#NO:TQC-B30121

