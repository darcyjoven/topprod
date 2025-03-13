# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi101.4gl
# Descriptions...: 工程 BOM - 插件位置維護作業
# Date & Author..: 03/06/12 By Kammy
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能:
# Modify.........: No.MOD-4C0062 04/12/09 By Mandy bmpuser,bmpgrup無此欄位,abmi101,abmi103程式有作權限判斷應取消
# Modify.........: No.FUN-550106 05/05/27 By Smapmin QPA欄位放大
# Modify.........: No.FUN-560027 05/06/13 By Mandy 特性BOM+KEY 值bmu08
# Modify.........: No.FUN-560231 05/06/27 By Mandy QPA欄位放大
# Modify.........: No.FUN-590110 05/09/28 By Tracy 修改報表,轉XML格式
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.TQC-660046 06/06/09 By xumin cl_err修改為cl_err3 
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION i101_q() 一開始應清空g_bmp.*值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能	
# Modify.........: No.MOD-720111 07/03/02 By pengu 查詢若單身下條件時，查出的資料會異常
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740189 07/04/23 By Carol 插件位置是否勾稽是由參數設定(aimi100)來決定, 'Y'則不match不可離開
# Modify.........: No.TQC-750041 07/05/26 By mike 報表格式修改
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-810059 08/03/24 By pengu 報表頭尾修改
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.TQC-870018 08/07/11 By Jerry 修正若程式寫法為SELECT .....寫法會出現ORA-600的錯誤
# Modify.........: No.MOD-890166 08/09/17 By cliare 以bmo05判斷是否已轉正式BOM
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0025 10/11/05 By lixh1 拿掉FUN-AA0059系統料號的開窗控管
# Modify.........: No.FUN-ABOO25 10/11/11 By lixh1 还原FUN-AA0059 系統開窗管控
# Modify.........: No.FUN-B10030 11/01/19 By Mengxw Remove "switch_plant"action 
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bmp   RECORD LIKE bmp_file.*,
    g_bmp_t RECORD LIKE bmp_file.*,
    g_bmp_o RECORD LIKE bmp_file.*,
    g_bmp01_t LIKE bmp_file.bmp01,
    g_bmp28_t LIKE bmp_file.bmp28,             #FUN-560027 add
    b_bmu       RECORD LIKE bmu_file.*,
    g_ima	RECORD LIKE ima_file.*,
    g_wc,g_wc2,g_sql    string,                #No.FUN-580092 HCN
    g_bmu           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        bmu05		LIKE bmu_file.bmu05,
        bmu06		LIKE bmu_file.bmu06,
        bmu07		LIKE bmu_file.bmu07
                    END RECORD,
    g_bmu_t         RECORD                     #程式變數 (舊值)
        bmu05		LIKE bmu_file.bmu05,
        bmu06		LIKE bmu_file.bmu06,
        bmu07		LIKE bmu_file.bmu07
                    END RECORD,
    #tot	   	 DEC(15,3),          #FUN-550106
    tot		    LIKE bmu_file.bmu07,     #FUN-550106 #FUN-560231
    g_buf           LIKE type_file.chr1000,  #No.FUN-680096  VARCHAR(78)
    g_rec_b         LIKE type_file.num5,     #單身筆數       #No.FUN-680096 SMALLINT
    l_ac            LIKE type_file.num5,     #目前處理的ARRAY CNT    #No.FUN-680096 SMALLINT
    g_ls            LIKE type_file.chr1,     #No.FUN-590110  #No.FUN-680096 VARCHAR(1)
    g_argv1         LIKE bmp_file.bmp01,     #主件料號  #TQC-840066
    g_argv2         LIKE bmo_file.bmo011,    #版本
    g_argv3         LIKE bmo_file.bmo06      #FUN-560027 add
DEFINE   p_row,p_col     LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE   g_forupd_sql    STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680096 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0060
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
   LET g_argv3=ARG_VAL(3) #FUN-560027 add
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
 
   LET p_row = 3 LET p_col = 2
   OPEN WINDOW i101_w AT p_row,p_col WITH FORM "abm/42f/abmi101"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   #FUN-560027................begin
   CALL cl_set_comp_visible("bmp28",g_sma.sma118='Y')
   #FUN-560027................end
 
   CALL i101()
   IF NOT cl_null(g_argv1) THEN
       CALL i101_q()
   END IF
 
   CALL i101_menu()
 
   CLOSE WINDOW i101_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
END MAIN
 
FUNCTION i101()
    INITIALIZE g_bmp.* TO NULL
    INITIALIZE g_bmp_t.* TO NULL
    INITIALIZE g_bmp_o.* TO NULL
    CALL i101_lock_cur()
END FUNCTION
 
FUNCTION i101_lock_cur()
    LET g_forupd_sql =
        "SELECT * FROM bmp_file WHERE bmp01 = ? AND bmp28 = ? AND bmp011 = ? AND bmp02 = ? AND bmp03 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
END FUNCTION
 
FUNCTION i101_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM
   CALL g_bmu.clear()
    IF cl_null(g_argv1) THEN
       CALL cl_set_head_visible("","YES")         #No.FUN-6B0033
   INITIALIZE g_bmp.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON
              bmp01,bmp28, bmp011,bmp04,bmp03,bmp02,bmp06,bmp07  #FUN-560027 add bmp28
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bmp01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bmq"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bmp01
                  NEXT FIELD bmp01

              WHEN INFIELD(bmp03) #料件主檔
#FUN-AB0025 --Begin--  remark
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.form = "q_ima"
                #   LET g_qryparam.state = 'c'
                #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
#FUN-AB0025 --End--    remark
                   DISPLAY g_qryparam.multiret TO bmp03
                   NEXT FIELD bmp03
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
       IF INT_FLAG THEN RETURN END IF
       CONSTRUCT g_wc2 ON bmu05,bmu06,bmu07
            FROM s_bmu[1].bmu05,s_bmu[1].bmu06,s_bmu[1].bmu07
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
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
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
     ELSE
       LET g_wc=" bmp01='",g_argv1,"'"
       IF NOT cl_null(g_argv2) THEN
          LET g_wc = g_wc CLIPPED, " AND bmp011='",g_argv2,"'"
       END IF
       #FUN-560027 add
       LET g_wc = g_wc CLIPPED, " AND bmp28='",g_argv3,"'"
       #FUN-560027(end)
       LET g_wc2=" 1=1"
    END IF
 #MOD-4C0062 MARK 掉
#   #資料權限的檢查
#   IF g_priv2='4' THEN                            # 只能使用自己的資料
#       LET g_wc = g_wc clipped," AND bmpuser = '",g_user,"'"
#   END IF
#   IF g_priv3='4' THEN                            # 只能使用相同群的資料
#       LET g_wc = g_wc clipped," AND bmpgrup MATCHES '",g_grup CLIPPED,"*'"
#   END IF
 
#   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
#       LET g_wc = g_wc clipped," AND bmpgrup IN ",cl_chk_tgrup_list()
#   END IF
 
#
    IF g_wc2=' 1=1'
       THEN LET g_sql="SELECT bmp01,bmp28,bmp011,bmp02,bmp03 ", #FUN-560027 add bmp28 #TQC-870018
                      "  FROM bmp_file ",
                      " WHERE ",g_wc CLIPPED,
                      " ORDER BY bmp01,bmp28,bmp011,bmp02,bmp03" #FUN-560027 add bmp28
       ELSE LET g_sql="SELECT bmp01,bmp28,bmp011,bmp02,bmp03", #FUN-560027 add bmp28 #TQC-870018
                      
                      "  FROM bmp_file,bmu_file ",
                      " WHERE bmp01=bmu01 AND bmp02=bmu02",
                      "   AND bmp03=bmu03 ",
                      "   AND bmp011=bmu_file.bmu011 ",
                      "   AND bmp28 =bmu08  ", #FUN-560027 add
                      "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                      " ORDER BY bmp01,bmp28,bmp011,bmp02,bmp03" #FUN-560027 add bmp28
    END IF
    PREPARE i101_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i101_cs SCROLL CURSOR WITH HOLD FOR i101_prepare
   #----------No.MOD-720111 modify
    IF g_wc2=' 1=1' THEN
       LET g_sql = "SELECT UNIQUE bmp01,bmp011,bmp02,bmp03 ",
                   "  FROM bmp_file ",
                   " WHERE ", g_wc CLIPPED,
                   " INTO TEMP x "
    ELSE
       LET g_sql = "SELECT UNIQUE bmp01,bmp011,bmp02,bmp03 ",
                   "  FROM bmp_file,bmu_file ",
                   " WHERE bmp01=bmu01 AND bmp02=bmu02",
                   "   AND bmp03=bmu03 ",
                   "   AND bmp011=bmu_file.bmu011 ",
                   "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   " INTO TEMP x "
    END IF
   #----------No.MOD-720111 end
    DROP TABLE x
    PREPARE i101_pre_x FROM g_sql
    EXECUTE i101_pre_x
 
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i101_precnt FROM g_sql
    DECLARE i101_count CURSOR FOR i101_precnt
END FUNCTION
 
FUNCTION i101_menu()
 
   WHILE TRUE
      CALL i101_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i101_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i101_b('0')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i101_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "工廠切換"
          #--FUN-B10030--start--
         # WHEN "switch_plant"
         #   CALL i101_d()
         #--FUN-B10030--end-- 
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bmp.bmp01 IS NOT NULL THEN
                  LET g_doc.column1 = "bmp01"
                  LET g_doc.value1 = g_bmp.bmp01
                  LET g_doc.column2 = "bmp011"
                  LET g_doc.value2 = g_bmp.bmp011
                  LET g_doc.column3 = "bmp02"
                  LET g_doc.value3 = g_bmp.bmp02
                  LET g_doc.column4 = "bmp03"
                  LET g_doc.value4 = g_bmp.bmp03
                  LET g_doc.column5 = "bmp28"    #FUN-560027 add
                  LET g_doc.value5 = g_bmp.bmp28 #FUN-560027 add
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmu),'','')
            END IF
      END CASE
   END WHILE
      CLOSE i101_cs
END FUNCTION
 
FUNCTION i101_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bmp.* TO NULL             #No.FUN-6A0002
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i101_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_bmu.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i101_count
    FETCH i101_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i101_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmp.bmp01,SQLCA.sqlcode,0)
        INITIALIZE g_bmp.* TO NULL
    ELSE
        CALL i101_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i101_fetch(p_flbmp)
    DEFINE
        p_flbmp          LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
 
    CASE p_flbmp
        WHEN 'N' FETCH NEXT     i101_cs INTO g_bmp.bmp01,g_bmp.bmp28, #FUN-560027 add bmp28
                                             g_bmp.bmp011,g_bmp.bmp02,
                                             g_bmp.bmp03 #TQC-870018 
        WHEN 'P' FETCH PREVIOUS i101_cs INTO g_bmp.bmp01,g_bmp.bmp28, #FUN-560027 add bmp28
                                             g_bmp.bmp011,g_bmp.bmp02,
                                             g_bmp.bmp03 #TQC-870018
        WHEN 'F' FETCH FIRST    i101_cs INTO g_bmp.bmp01,g_bmp.bmp28, #FUN-560027 add bmp28
                                             g_bmp.bmp011,g_bmp.bmp02,
                                             g_bmp.bmp03 #TQC-870018
        WHEN 'L' FETCH LAST     i101_cs INTO g_bmp.bmp01,g_bmp.bmp28, #FUN-560027 add bmp28
                                             g_bmp.bmp011,g_bmp.bmp02,
                                             g_bmp.bmp03 #TQC-870018
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i101_cs INTO g_bmp.bmp01,g_bmp.bmp28, #FUN-560027 add bmp28
                                                g_bmp.bmp011,g_bmp.bmp02,
                                                g_bmp.bmp03 #TQC-870018
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmp.bmp01,SQLCA.sqlcode,0)
        INITIALIZE g_bmp.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flbmp
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_bmp.* FROM bmp_file       # 重讀DB,因TEMP有不被更新特性
       WHERE bmp01=g_bmp.bmp01 AND bmp28 =g_bmp.bmp28 AND bmp011 = g_bmp.bmp011 AND bmp02=g_bmp.bmp02 AND bmp03=g_bmp.bmp03
    IF SQLCA.sqlcode THEN
     #  CALL cl_err(g_bmp.bmp01,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("sel","bmp_file",g_bmp.bmp01,g_bmp.bmp011,SQLCA.sqlcode,"","",1)   #No.TQC-660046
    ELSE
        CALL i101_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i101_show()
    LET g_bmp_t.* = g_bmp.*
    DISPLAY BY NAME
           g_bmp.bmp01,g_bmp.bmp28, g_bmp.bmp011,g_bmp.bmp02, g_bmp.bmp03, #FUN-560027 add bmp28
           g_bmp.bmp04, g_bmp.bmp06 ,g_bmp.bmp07
    INITIALIZE g_ima.* TO NULL
    CALL i101_item(g_bmp.bmp01)
         RETURNING g_ima.ima02,g_ima.ima021,g_ima.ima25
    DISPLAY BY NAME g_ima.ima02,g_ima.ima021,g_ima.ima25
    INITIALIZE g_ima.* TO NULL
    CALL i101_item(g_bmp.bmp03)
         RETURNING g_ima.ima02,g_ima.ima021,g_ima.ima25
    DISPLAY g_ima.ima02,g_ima.ima021,g_ima.ima25 TO ima02b,ima021b,ima25b
    CALL i101_b_fill(' 1=1')
    DISPLAY BY NAME tot
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i101_item(p_item)
DEFINE
    p_item          LIKE ima_file.ima01,
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_ima25         LIKE ima_file.ima25,
    l_imaacti       LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima25,imaacti
        INTO l_ima02,l_ima021,l_ima25,l_imaacti
        FROM ima_file WHERE ima01 = p_item
 
    CASE WHEN SQLCA.SQLCODE = 100
         SELECT bmq02,bmq021,bmq25,bmqacti
               INTO l_ima02,l_ima021,l_ima25,l_imaacti
               FROM bmq_file WHERE bmq01 = p_item
            IF SQLCA.sqlcode THEN
                LET g_errno  = 'mfg2772'
                LET l_ima02  = NULL
                LET l_ima021 = NULL
                LET l_ima25  = NULL
                LET l_imaacti = NULL
            END IF
         WHEN l_imaacti='N' LET g_errno = '9028'
     #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
     #FUN-690022------mod-------
 
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN l_ima02,l_ima021,l_ima25
END FUNCTION
#--FUN-B10030--start-- 
#FUNCTION i101_d()
#   DEFINE l_plant,l_dbs	LIKE type_file.chr21   #No.FUN-680096 VARCHAR(21)
 
#            LET INT_FLAG = 0  ######add for prompt bug
#   PROMPT 'PLANT CODE:' FOR l_plant
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE PROMPT
 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
 
 
#   END PROMPT
#   IF l_plant IS NULL THEN RETURN END IF
#   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#   IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
#   DATABASE l_dbs
#   CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
#   CALL cl_ins_del_sid(1,l_plant) #FUN-980030  #FUN-990069
#   IF STATUS THEN ERROR 'open database error!' RETURN END IF
#   LET g_plant = l_plant
#   LET g_dbs   = l_dbs
#   CALL i101_lock_cur()
#END FUNCTION
#--FUN-B10030--end-- 
FUNCTION i101_b(p_mod_seq)
DEFINE
    p_mod_seq       LIKE type_file.chr1,     #No.FUN-680096   VARCHAR(1)
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態          #No.FUN-680096 VARCHAR(1)
    l_sfb38         LIKE sfb_file.sfb38,     #No.FUN-680096  DATE
    l_ima107        LIKE ima_file.ima107,
    l_bmo05         LIKE bmo_file.bmo05,     #MOD-890166 add
    l_allow_insert  LIKE type_file.num5,     #可新增否          #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否          #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_bmp.bmp01 IS NULL THEN
        RETURN
    END IF
    #no.6542
    SELECT * INTO g_bmp.* FROM bmp_file
     WHERE bmp01 = g_bmp.bmp01 AND bmp011 = g_bmp.bmp011
       AND bmp02 = g_bmp.bmp02 AND bmp03  = g_bmp.bmp03
       AND bmp28 = g_bmp.bmp28 #FUN-560027 add bmp28
   #MOD-890166-begin-add
    SELECT bmo05 INTO l_bmo05 FROM bmo_file
     WHERE bmo01 = g_bmp.bmp01 AND bmo011 = g_bmp.bmp011
       AND bmo06 = g_bmp.bmp28
        
   #IF NOT cl_null(g_bmp.bmp04) THEN
    IF NOT cl_null(l_bmo05) THEN
   #MOD-890166-end-add
     #  CALL cl_err('','mfg2761',0) #No.TQC-660046
        CALL cl_err3("sel","bmp_file",g_bmp.bmp01,g_bmp.bmp011,"mfg2761","","",1)   #No.TQC-660046
    RETURN
    END IF
    #no.6542(end)
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT bmu05,bmu06,bmu07 ",
      " FROM bmu_file ",
      "  WHERE bmu01  = ? ",
      "   AND bmu011 = ? ",
      "   AND bmu02  = ? ",
      "   AND bmu03  = ? ",
      "   AND bmu05  = ? ",
      "   AND bmu08  = ? ", #FUN-560027 add
      " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET g_success = 'Y'
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    WHILE TRUE #TQC-740189 add (WHILE TRUE .. END WHILE)
        INPUT ARRAY g_bmu WITHOUT DEFAULTS FROM s_bmu.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET g_bmu_t.* = g_bmu[l_ac].*  #BACKUP
                LET p_cmd='u'
                BEGIN WORK
                OPEN i101_bcl USING g_bmp.bmp01,g_bmp.bmp011,
                                    g_bmp.bmp02,g_bmp.bmp03,g_bmu_t.bmu05,g_bmp.bmp28 #FUN-560027 add
                IF STATUS THEN
                    CALL cl_err("OPEN i101_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i101_bcl INTO g_bmu[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bmu_t.bmu05,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD bmu05
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO bmu_file(bmu01,bmu011,bmu02,bmu03,bmu04,
                                bmu05,bmu06,bmu07,bmu08) #FUN-560027 add bmu08
            VALUES(g_bmp.bmp01,g_bmp.bmp011,
                   g_bmp.bmp02,g_bmp.bmp03,
                   g_bmp.bmp04,
                   g_bmu[l_ac].bmu05,g_bmu[l_ac].bmu06,
                   g_bmu[l_ac].bmu07,g_bmp.bmp28) #FUN-560027 add bmp28
            IF SQLCA.sqlcode THEN
             #  CALL cl_err(g_bmu[l_ac].bmu05,SQLCA.sqlcode,0)
                 #No.TQC-660046
                CALL cl_err3("ins","bmu_file",g_bmp.bmp01,g_bmp.bmp011,SQLCA.sqlcode,"","",1)  #No.TQC-660046
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
             END IF
 
        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_bmu[l_ac].* TO NULL      #900423
            LET g_bmu[l_ac].bmu07 = 0
            LET g_bmu_t.* = g_bmu[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmu05
 
        BEFORE FIELD bmu05                        #default 序號
            IF g_bmu[l_ac].bmu05 IS NULL OR
               g_bmu[l_ac].bmu05 = 0 THEN
                SELECT max(bmu05) INTO g_bmu[l_ac].bmu05
                   FROM bmu_file
                   WHERE bmu01 = g_bmp.bmp01 AND bmu011= g_bmp.bmp011
                     AND bmu02 = g_bmp.bmp02 AND bmu03 = g_bmp.bmp03
                     AND bmu08 = g_bmp.bmp28  #FUN-560027 add
                IF g_bmu[l_ac].bmu05 IS NULL THEN
                    LET g_bmu[l_ac].bmu05 = 0
                END IF
                LET g_bmu[l_ac].bmu05 = g_bmu[l_ac].bmu05 + g_sma.sma19
            END IF
 
        AFTER FIELD bmu05                        #check 序號是否重複
            IF g_bmu[l_ac].bmu05 IS NULL THEN
               LET g_bmu[l_ac].bmu05 = g_bmu_t.bmu05
            END IF
            IF NOT cl_null(g_bmu[l_ac].bmu05) THEN
                IF g_bmu[l_ac].bmu05 != g_bmu_t.bmu05 OR
                   g_bmu_t.bmu05 IS NULL THEN
                    SELECT count(*) INTO l_n
                        FROM bmu_file
                        WHERE bmu01 = g_bmp.bmp01 AND bmu011= g_bmp.bmp011
                          AND bmu02 = g_bmp.bmp02 AND bmu03 = g_bmp.bmp03
                          AND bmu05 = g_bmu[l_ac].bmu05
                          AND bmu08 = g_bmp.bmp28 #FUN-560027 add
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_bmu[l_ac].bmu05 = g_bmu_t.bmu05
                        NEXT FIELD bmu05
                    END IF
                END IF
            END IF
 
        #No.TQC-750041  --BEGIN--
        AFTER FIELD bmu07
        IF NOT cl_null(g_bmu[l_ac].bmu07)  THEN 
           IF g_bmu[l_ac].bmu07 < 0 THEN 
               CALL cl_err(g_bmu[l_ac].bmu07 ,'mfg5034',0)
               NEXT FIELD bmu07 
           END IF
        END IF 
        #No.TQC-750041   --END-- 
 
        BEFORE DELETE                            #是否取消單身
            IF g_bmu_t.bmu05 > 0 AND g_bmu_t.bmu05 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM bmu_file
                    WHERE bmu01 = g_bmp.bmp01 AND bmu011= g_bmp.bmp011
                      AND bmu02 = g_bmp.bmp02 AND bmu03 = g_bmp.bmp03
                      AND bmu05 = g_bmu_t.bmu05
                      AND bmu08 = g_bmp.bmp28 #FUN-560027 add
                IF SQLCA.sqlcode THEN
                  # CALL cl_err(g_bmu_t.bmu05,SQLCA.sqlcode,0) 
 #No.TQC-660046
                    CALL cl_err3("del","bmu_file",g_bmp.bmp01,g_bmp.bmp011,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                CALL i101_b_tot()
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmu[l_ac].* = g_bmu_t.*
               CLOSE i101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bmu[l_ac].bmu05,-263,1)
                LET g_bmu[l_ac].* = g_bmu_t.*
            ELSE
                UPDATE bmu_file SET bmu05=g_bmu[l_ac].bmu05,
                                    bmu06=g_bmu[l_ac].bmu06,
                                    bmu07=g_bmu[l_ac].bmu07
                 WHERE bmu01  = g_bmp.bmp01
                   AND bmu011 = g_bmp.bmp011
                   AND bmu02  = g_bmp.bmp02
                   AND bmu03  = g_bmp.bmp03
                   AND bmu05  = g_bmu_t.bmu05
                   AND bmu08 = g_bmp.bmp28 #FUN-560027 add
                IF SQLCA.sqlcode THEN
               #    CALL cl_err(g_bmu[l_ac].bmu05,SQLCA.sqlcode,0)
                     #No.TQC-660046
                    CALL cl_err3("upd","bmu_file",g_bmp.bmp01,g_bmp.bmp011,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    LET g_bmu[l_ac].* = g_bmu_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                  # COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_bmu[l_ac].* = g_bmu_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmu.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
 
            CALL i101_b_tot()
            CALL i101_up_bmp13() #BugNo:4476
            CALL i101_b_tot()
 
          #CKP
          #LET g_bmu_t.* = g_bmu[l_ac].*          # 900423
            CLOSE i101_bcl
            COMMIT WORK
 
       #ON ACTION CONTROLN
       #    CALL i101_b_askkey()
       #    EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bmu05) AND l_ac > 1 THEN
                LET g_bmu[l_ac].* = g_bmu[l_ac-1].*
                NEXT FIELD bmu05
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT
        CALL i101_b_tot()
        CALL i101_chk_QPA()
#TQC-740189-add
        IF NOT cl_null(g_errno) THEN
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
#TQC-740189-end
 
    CLOSE i101_bcl
    IF g_success = 'Y' THEN
        COMMIT WORK
    ELSE
        ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION i101_b_tot()
   SELECT SUM(bmu07) INTO tot
          FROM bmu_file
         WHERE bmu01 = g_bmp.bmp01 AND bmu011= g_bmp.bmp011
           AND bmu02 = g_bmp.bmp02 AND bmu03 = g_bmp.bmp03
           AND bmu08 = g_bmp.bmp28 #FUN-560027 add
   IF cl_null(tot) THEN LET tot = 0 END IF
   DISPLAY tot TO FORMONLY.tot
END FUNCTION
 
FUNCTION i101_b_askkey()
DEFINE
    l_wc2      LIKE type_file.chr1000       #No.FUN-680096  VARCHAR(200)
 
    CONSTRUCT g_wc2 ON bmu05,bmu06,bmu07
            FROM s_bmu[1].bmu05,s_bmu[1].bmu06,s_bmu[1].bmu07
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
    CALL i101_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i101_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2       LIKE type_file.chr1000       #No.FUN-680096  VARCHAR(200)
 
    LET g_sql =
        "SELECT bmu05,bmu06,bmu07",
        " FROM bmu_file",
        " WHERE bmu01 ='",g_bmp.bmp01,"' AND bmu011='",g_bmp.bmp011,"'",
        "   AND bmu02 ='",g_bmp.bmp02,"'",
        "   AND bmu03 ='",g_bmp.bmp03,"'",
        "   AND bmu08 ='",g_bmp.bmp28,"'", #FUN-560027 add
        " ORDER BY 1"
    PREPARE i101_pb FROM g_sql
    DECLARE bmu_curs CURSOR FOR i101_pb
 
    CALL g_bmu.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    LET tot = 0
    FOREACH bmu_curs INTO g_bmu[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET tot = tot + g_bmu[g_cnt].bmu07
        LET g_cnt = g_cnt + 1
        # TQC-630105----------start add by Joe
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
        # TQC-630105----------end add by Joe
    END FOREACH
    #CKP
    CALL g_bmu.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    DISPLAY BY NAME tot
END FUNCTION
 
#BugNo:4476
FUNCTION i101_up_bmp13()
 DEFINE l_bmu06   LIKE bmu_file.bmu06,
        l_bmp13   LIKE bmp_file.bmp13,
        l_bmu05   LIKE bmu_file.bmu05, #FUN-560027 add
        l_i       LIKE type_file.num5,      #No.FUN-680096 SMALLINT
        p_ac      LIKE type_file.num5       #No.FUN-680096 SMALLINT
 
    LET l_bmp13=' '
    LET l_i = 0
    DECLARE up_bmp13_cs CURSOR FOR
     SELECT bmu06,bmu05 FROM bmu_file #FUN-560027 add bmu05
      WHERE bmu01 =g_bmp.bmp01
        AND bmu011=g_bmp.bmp011
        AND bmu02 =g_bmp.bmp02
        AND bmu03 =g_bmp.bmp03
        AND bmu08 =g_bmp.bmp28  #FUN-560027 add
      ORDER BY bmu05 #FUN-560027 add
 
    FOREACH up_bmp13_cs INTO l_bmu06,l_bmu05 #FUN-560027 add bmu05
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     IF l_i = 0 THEN
        LET l_bmp13=l_bmu06
     ELSE
        LET l_bmp13= l_bmp13 CLIPPED , ',', l_bmu06
     END IF
     LET l_i = l_i + 1
    END FOREACH
    UPDATE bmp_file
      SET bmp13 = l_bmp13
      WHERE bmp01 =g_bmp.bmp01
        AND bmp011=g_bmp.bmp011
        AND bmp02 =g_bmp.bmp02
        AND bmp03 =g_bmp.bmp03
        AND bmp28 =g_bmp.bmp28  #FUN-560027 add
END FUNCTION
 
FUNCTION i101_chk_QPA()
 DEFINE l_i       LIKE type_file.num10   #No.FUN-680096  INTEGER
 DEFINE g_ima147  LIKE ima_file.ima147   
 #DEFINE g_qpa     DEC(15,3)   #FUN-550106
 DEFINE g_qpa      LIKE bmp_file.bmp06 #FUN-550106 #FUN-560231
    LET g_errno = ''
    SELECT ima147 INTO g_ima147 FROM ima_file WHERE ima01=g_bmp.bmp03
    IF STATUS =100 THEN
       SELECT bmq147 INTO g_ima147 FROM bmq_file WHERE bmq01=g_bmp.bmp03
    END IF
    LET g_qpa = g_bmp.bmp06 / g_bmp.bmp07
    LET tot = 0
    FOR l_i = 1 TO g_bmu.getLength()
        IF cl_null(g_bmu[l_i].bmu07) THEN
            EXIT FOR
        END IF
        LET tot = tot + g_bmu[l_i].bmu07
    END FOR
    DISPLAY tot TO FORMONLY.tot
    LET g_errno = NULL
    IF g_ima147 = 'Y' AND (tot != g_qpa) THEN
       CALL cl_err(tot,'mfg2765',1)
       LET g_errno = 'mfg2765'
    END IF
END FUNCTION
 
FUNCTION i101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmu TO s_bmu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i101_fetch('L')
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
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #--FUN-B10030--start-- 
      # ON ACTION switch_plant
      #   LET g_action_choice="switch_plant"
      #   EXIT DISPLAY
      #--FUN-B10030--end--
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
 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
#@    ON ACTION 相關文件
       ON ACTION related_document                   #MOD-470051
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
 
FUNCTION i101_out()
    IF g_wc IS NULL THEN
     #  CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
    RETURN END IF
 
    MENU ""
       ON ACTION assm_p_n_type_print
          LET g_ls="Z"        #No.FUN-590110   依主件
          CALL i101_out1()
 
       ON ACTION component_p_n_type_print
          LET g_ls="Y"        #No.FUN-590110   依元件
          CALL i101_out1()    #No.FUN-590110
 
       ON ACTION inser_loc_print
          LET g_ls="C"        #No.FUN-590110   依插件
          CALL i101_out1()    #No.FUN-590110
 
       ON ACTION exit
          EXIT MENU
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
FUNCTION i101_out1()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    l_name          LIKE type_file.chr20,  #External(Disk) file name  #No.FUN-680096 VARCHAR(20)
    l_order1        LIKE bmp_file.bmp01,   #No.FUN-590110    #No.FUN-680096 VARCHAR(20)  
    l_order2        LIKE bmp_file.bmp01,   #No.FUN-590110    #No.FUN-680096 VARCHAR(20) 
    l_order3        LIKE bmp_file.bmp011,  #No.FUN-590110    #No.FUN-680096 VARCHAR(20) 
    l_order4        LIKE bmp_file.bmp02,   #No.FUN-590110    #No.FUN-680096 VARCHAR(20) 
    l_order5        LIKE bmp_file.bmp02,   #No.FUN-590110    #No.FUN-680096 VARCHAR(20) 
    l_order6        LIKE bmp_file.bmp03,   #No.FUN-590110    #No.FUN-680096 VARCHAR(20) 
    l_order7        LIKE bmp_file.bmp02,   #No.FUN-590110    #No.FUN-680096 VARCHAR(20) 
    l_order8        LIKE bmp_file.bmp03,   #No.FUN-590110    #No.FUN-680096 VARCHAR(20) 
    sr              RECORD                 #No.FUN-590110
        order1      LIKE bmp_file.bmp01,   #No.FUN-680096 VARCHAR(20) 
        order2      LIKE bmp_file.bmp01,   #No.FUN-680096 VARCHAR(20) 
        order3      LIKE bmp_file.bmp011,  #No.FUN-680096 VARCHAR(20) 
        order4      LIKE bmp_file.bmp02,   #No.FUN-680096 VARCHAR(20) 
        order5      LIKE bmp_file.bmp02,   #No.FUN-680096 VARCHAR(20) 
        order6      LIKE bmp_file.bmp03,   #No.FUN-680096 VARCHAR(20) 
        order7      LIKE bmp_file.bmp02,   #No.FUN-680096 VARCHAR(20) 
        order8      LIKE bmp_file.bmp03,   #No.FUN-680096 VARCHAR(20) 
        bmp01       LIKE bmp_file.bmp01,
        bmp011      LIKE bmp_file.bmp011,
        bmp02       LIKE bmp_file.bmp02,
        bmp03       LIKE bmp_file.bmp03,
        bmp04       LIKE bmp_file.bmp04,
        bmp06       LIKE bmp_file.bmp06,
        bmp28       LIKE bmp_file.bmp28,
        bmu01       LIKE bmu_file.bmu01,
        bmu011      LIKE bmu_file.bmu011,
        bmu02       LIKE bmu_file.bmu02,
        bmu03       LIKE bmu_file.bmu03,
        bmu06       LIKE bmu_file.bmu06,
        bmu07       LIKE bmu_file.bmu07,
        bmu08       LIKE bmu_file.bmu08
                    END RECORD
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT '','','','','','','','',bmp01,bmp011,bmp02,bmp03,bmp04,bmp06,
               bmp28,bmu01,bmu011,bmu02,bmu03,bmu06,bmu07,bmu08",#No.FUN-590110     ",
              " FROM bmp_file LEFT OUTER JOIN bmu_file ON bmp01=bmu01 AND bmp011=bmu011 AND bmp02=bmu02 AND bmp03=bmu03 ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
              "   AND bmp28=bmu08 " #FUN-560027 add
    PREPARE i101_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i101_co
        CURSOR FOR i101_p1
 
    CALL cl_outnam('abmi101') RETURNING l_name
#No.FUN-590110 --start--
    IF g_ls='Z' THEN
       LET g_zaa[31].zaa06='Y'
       LET g_zaa[32].zaa06='Y'
       LET g_zaa[33].zaa06='Y'
       LET g_zaa[36].zaa06='Y'
       LET g_zaa[39].zaa06='N'
    ELSE
       IF g_ls='Y' THEN
          LET g_zaa[31].zaa06='Y'
          LET g_zaa[32].zaa06='Y'
          LET g_zaa[33].zaa06='Y'
          LET g_zaa[36].zaa06='N'
          LET g_zaa[39].zaa06='N'
          LET g_zaa[35].zaa08=g_x[11] CLIPPED
       ELSE
          LET g_zaa[31].zaa06='N'
          LET g_zaa[32].zaa06='N'
          LET g_zaa[33].zaa06='N'
          LET g_zaa[36].zaa06='Y'
          LET g_zaa[39].zaa06='Y'
       END IF
    END IF
    CALL cl_prt_pos_len()
 
    START REPORT i101_rep TO l_name
 
    FOREACH i101_co INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        IF g_ls="Z" THEN
           LET l_order1=sr.bmp01
           LET l_order4=sr.bmp011
           LET l_order5=sr.bmp02
           LET l_order6=sr.bmp03
        ELSE IF g_ls="Y" THEN
                LET l_order1=sr.bmp03
                LET l_order2=sr.bmp01
                LET l_order3=sr.bmp011
                LET l_order4=sr.bmp02
             ELSE
                LET l_order1=sr.bmu06
                LET l_order4=sr.bmu06
                LET l_order5=sr.bmp01
                LET l_order6=sr.bmp011
                LET l_order7=sr.bmp02
                LET l_order8=sr.bmp03
             END IF
        END IF
        LET sr.order1=l_order1
        LET sr.order2=l_order2
        LET sr.order3=l_order3
        LET sr.order4=l_order4
        LET sr.order5=l_order5
        LET sr.order6=l_order6
        LET sr.order7=l_order7
        LET sr.order8=l_order8
        OUTPUT TO REPORT i101_rep(sr.*)
#No.FUN-590110 --end--
    END FOREACH
 
    FINISH REPORT i101_rep
 
    CLOSE i101_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i101_rep(sr)  #No.FUN-590110
DEFINE
    l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
    l_buf	    LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(120) 
    sr              RECORD                 #No.FUN-590110
        order1      LIKE bmp_file.bmp01,   #No.FUN-680096 VARCHAR(20) 
        order2      LIKE bmp_file.bmp01,   #No.FUN-680096 VARCHAR(20) 
        order3      LIKE bmp_file.bmp011,  #No.FUN-680096 VARCHAR(20) 
        order4      LIKE bmp_file.bmp02,   #No.FUN-680096 VARCHAR(20) 
        order5      LIKE bmp_file.bmp02,   #No.FUN-680096 VARCHAR(20) 
        order6      LIKE bmp_file.bmp03,   #No.FUN-680096 VARCHAR(20) 
        order7      LIKE bmp_file.bmp02,   #No.FUN-680096 VARCHAR(20) 
        order8      LIKE bmp_file.bmp03,   #No.FUN-680096 VARCHAR(20) 
        bmp01       LIKE bmp_file.bmp01,
        bmp011      LIKE bmp_file.bmp011,
        bmp02       LIKE bmp_file.bmp02,
        bmp03       LIKE bmp_file.bmp03,
        bmp04       LIKE bmp_file.bmp04,
        bmp06       LIKE bmp_file.bmp06,
        bmp28       LIKE bmp_file.bmp28,
        bmu01       LIKE bmu_file.bmu01,
        bmu011      LIKE bmu_file.bmu011,
        bmu02       LIKE bmu_file.bmu02,
        bmu03       LIKE bmu_file.bmu03,
        bmu06       LIKE bmu_file.bmu06,
        bmu07       LIKE bmu_file.bmu07,
        bmu08       LIKE bmu_file.bmu08
                    END RECORD
    OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
    ORDER BY sr.order1,sr.order2,sr.order3,sr.order4,sr.order5,sr.order6,
             sr.order7,sr.order8  #No.FUN-590110
 
    FORMAT
        PAGE HEADER
#No.FUN-590110 --start--
          #------------No.MOD-810059 modify
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
           # PRINT ' '   #No.TQC-750041 
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINTX name =H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],  
                  g_x[38],g_x[39]
          #------------No.MOD-810059 end
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.order4
            IF g_ls="Z" THEN
               INITIALIZE g_ima.* TO NULL
               SELECT * INTO g_ima.* FROM ima_file WHERE ima01=sr.bmp01
               PRINTX COLUMN 1,g_x[11] CLIPPED,sr.bmp01;   #No.MOD-810059 modify
               PRINT '    ',g_x[17] CLIPPED,sr.bmp011
               PRINT
            END IF
            IF g_ls="Y" THEN
               INITIALIZE g_ima.* TO NULL
               SELECT * INTO g_ima.* FROM ima_file WHERE ima01=sr.bmp03
               PRINTX  COLUMN 1,g_x[13] CLIPPED,sr.bmp03,g_ima.ima02,  #No.MOD-810059 modify
                     g_ima.ima021
               PRINT
               LET l_buf=NULL
            END IF
            IF g_ls="C" THEN
               PRINTX name = D1 COLUMN g_c[31],sr.bmu06;    #No.MOD-810059 modify
            END IF
 
        BEFORE GROUP OF sr.order6
            IF g_ls="Z" THEN
               LET l_buf=NULL
            END IF
            IF g_ls="C" THEN
               PRINTX name = D1 COLUMN g_c[32],sr.bmp01,  #No.MOD-810059 modify 
                     COLUMN g_c[33],sr.bmp011;
            END IF
 
        ON EVERY ROW
            IF l_buf IS NULL
               THEN LET l_buf=sr.bmu06
               ELSE LET l_buf=l_buf CLIPPED,' ',sr.bmu06
            END IF
            IF sr.bmu07<>1 THEN
               LET l_buf=l_buf CLIPPED,'*',sr.bmu07 USING '<<'
            END IF
            IF g_ls="C" THEN
               PRINTX name = D1 COLUMN g_c[34],sr.bmp02 USING '###&',  #No.MOD-810059 modify
                     COLUMN g_c[35],sr.bmp03,
                     COLUMN g_c[37],sr.bmp04,
                     COLUMN g_c[38],sr.bmu07 USING '####'
            END IF
        AFTER GROUP OF sr.bmp03
            IF g_ls="Z" THEN
               PRINTX name = D1 COLUMN g_c[34],sr.bmp02 USING '###&',  #No.MOD-810059 modify
                     COLUMN g_c[35],sr.bmp03,
                     COLUMN g_c[37],sr.bmp04,
                     COLUMN g_c[38],sr.bmp06 USING '####',
                     COLUMN g_c[39],l_buf[1,30]
               IF NOT cl_null(l_buf[31,60])  THEN
                  PRINTX name = D1 COLUMN g_c[39],l_buf[31,60] END IF   #No.MOD-810059 modify 
               IF NOT cl_null(l_buf[61,90])  THEN
                  PRINTX name = D1 COLUMN g_c[39],l_buf[61,90] END IF   #No.MOD-810059 modify 
               IF NOT cl_null(l_buf[91,120]) THEN
                  PRINTX name = D1 COLUMN g_c[39],l_buf[91,120] END IF  #No.MOD-810059 modify 
            END IF
        AFTER GROUP OF sr.bmp02
            IF g_ls="Y" THEN
               PRINTX name = D1 COLUMN g_c[34],sr.bmp02 USING '###&',   #No.MOD-810059 modify
                     COLUMN g_c[35],sr.bmp01,
                     COLUMN g_c[36],sr.bmp011,
                     COLUMN g_c[37],sr.bmp04,
                     COLUMN g_c[38],sr.bmp06 USING '####',
                     COLUMN g_c[39],l_buf[1,30]
               IF NOT cl_null(l_buf[31,60]) THEN
                  PRINTX name = D1 COLUMN g_c[39],l_buf[31,60] END IF   #No.MOD-810059 modify
               IF NOT cl_null(l_buf[61,90]) THEN
                  PRINTX name = D1 COLUMN g_c[39],l_buf[61,90] END IF   #No.MOD-810059 modify
               IF NOT cl_null(l_buf[91,120]) THEN
                  PRINTX name = D1 COLUMN g_c[39],l_buf[91,120] END IF  #No.MOD-810059 modify
            END IF
        AFTER GROUP OF sr.order1
            PRINT g_dash[1,g_len]
 
#No.FUN-590110 --end--
        ON LAST ROW
          #------------No.MOD-810059 add
           NEED 4 LINES                
           IF g_zz05 = 'Y' THEN                                                     
                CALL cl_wcchp(g_wc,'bmp01,bmp28,bmp011,bmp04,bmp03,bmp02')                   
                     RETURNING g_wc
                PRINT g_dash[1,g_len]                                                                          
                CALL cl_prt_pos_wc(g_wc)                                                                             
           END IF
           PRINT g_dash[1,g_len]                                                                          
          #------------No.MOD-810059 end
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT '(abmi101)'
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
#Patch....NO.TQC-610035 <> #
