# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aeci711.4gl
# Descriptions...: Run Card單元明細資料維護作業
# Date & Author..: 00/05/05 By Apple
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-660091 05/06/15 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-6A0039 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980002 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60092 10/07/06 By lilingyu 平行工藝
# Modify.........: No.TQC-AB0385 10/11/30 By vealxu 單元編號欄位，無效的單元編號也能錄入通過，請控管住
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_shm   RECORD LIKE shm_file.*,
    g_shm_t RECORD LIKE shm_file.*,
    g_sgm   RECORD LIKE sgm_file.*,
    g_shm01 LIKE shm_file.shm01,
    g_shm05 LIKE shm_file.shm05,
    g_sgm03 LIKE sgm_file.sgm03,
    g_sgm012 LIKE sgm_file.sgm012,   #FUN-A60092 add
    g_argv1 LIKE shm_file.shm01,
    g_argv2 LIKE shm_file.shm05,
    g_argv3 LIKE sgm_file.sgm03,
    g_argv4 LIKE sgm_file.sgm012,    #FUN-A60092 add
    g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680073 SMALLINT
    g_sgn           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
      sgn05           LIKE sgn_file.sgn05, #單元代號
      sga02           LIKE sga_file.sga02, #名稱
      sga03           LIKE sga_file.sga03, #規格
      sgn06           LIKE sgn_file.sgn06, #零件數
      sgn07           LIKE sgn_file.sgn07, #單位工時
      sgn08           LIKE sgn_file.sgn08, #單元工時
      sgn10           LIKE sgn_file.sgn10, #單位機時
      sgn11           LIKE sgn_file.sgn11, #單元機時
      sgn09           LIKE sgn_file.sgn09  #單位人力
                    END RECORD,
    g_sgn_t         RECORD                 #程式變數 (舊值)
      sgn05           LIKE sgn_file.sgn05, #單元代號
      sga02           LIKE sga_file.sga02, #名稱
      sga03           LIKE sga_file.sga03, #規格
      sgn06           LIKE sgn_file.sgn06, #零件數
      sgn07           LIKE sgn_file.sgn07, #單位工時
      sgn08           LIKE sgn_file.sgn08, #單元工時
      sgn10           LIKE sgn_file.sgn10, #單位機時
      sgn11           LIKE sgn_file.sgn11, #單元機時
      sgn09           LIKE sgn_file.sgn09  #單位人力
                    END RECORD,
    p_row,p_col     LIKE type_file.num5,          #No.FUN-680073 SMALLINT 
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT  #No.FUN-680073 SMALLINT
 
DEFINE g_forupd_sql STRING                       #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE g_msg        LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE g_jump       LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0100
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    IF g_sma.sma55='N' THEN
       CALL cl_err('sma55=N:','aec-021',1)
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)
    LET g_argv3=ARG_VAL(3)
    LET g_argv4=ARG_VAL(4)  #FUN-A60092 add
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i711_w AT p_row,p_col
        WITH FORM "aec/42f/aeci711"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()

#FUN-A60092 --begin--
    IF g_sma.sma541 = 'Y' THEN 
       CALL cl_set_comp_visible("sgm012",TRUE)
    ELSE
       CALL cl_set_comp_visible("sgm012",FALSE)
    END IF 	
#FUN-A60092 --end--
 
    IF NOT cl_null(g_argv1) THEN
       CALL i711_q()
    END IF
    CALL i711()
    CLOSE WINDOW i711_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
END MAIN
 
FUNCTION i711()
    INITIALIZE g_shm.* TO NULL
    INITIALIZE g_sgm.* TO NULL
    CALL i711_menu()
END FUNCTION
 
FUNCTION i711_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    LET  g_wc2=' 1=1 '
    CLEAR FORM
    CALL g_sgn.clear()
    IF cl_null(g_argv1) AND cl_null(g_argv2) THEN
       CALL cl_set_head_visible("","YES")         #No.FUN-6B0029 
 
   INITIALIZE g_shm01 TO NULL    #No.FUN-750051
   INITIALIZE g_shm05 TO NULL    #No.FUN-750051
   INITIALIZE g_sgm03 TO NULL    #No.FUN-750051
   INITIALIZE g_sgm012 TO NULL   #FUN-A60092 add
       CONSTRUCT BY NAME g_wc ON shm01,shm012,shm05,shm06,sgm012,sgm03,sgm45,sgm06,  #FUN-A60092 add sgm012
                                 shm08,sgm14,sgm16,sgm49
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN

#FUN-A60092 --begin--
        ON ACTION controlp
           CASE
              WHEN INFIELD(sgm012)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sgm012"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sgm012
           END CASE
#FUN-A60092 --end--
 
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
       IF INT_FLAG THEN RETURN END IF
 
       CONSTRUCT g_wc2 ON sgn05,sgn06,sgn07,sgn08,sgn10,sgn11,sgn09
                 FROM s_sgn[1].sgn05,s_sgn[1].sgn06,s_sgn[1].sgn07,
                      s_sgn[1].sgn08,s_sgn[1].sgn10,s_sgn[1].sgn11,
                      s_sgn[1].sgn09
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(sgn05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sga"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sgn05
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    ELSE
       LET g_wc= " shm01='",g_argv1,"' AND shm05='",g_argv2,"'"
    END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND shmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND shmgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND shmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('shmuser', 'shmgrup')
    #End:FUN-980030
  
    IF g_wc2=' 1=1' OR g_wc2 IS NULL THEN
       LET g_sql=" SELECT DISTINCT shm01,shm05,sgm03,sgm012 FROM shm_file,sgm_file ", #FUN-A60092 add sgm012
                 "  WHERE shm01=sgm01",
                 "    AND ", g_wc CLIPPED, " ORDER BY shm01,shm05 "
    ELSE
       LET g_sql="SELECT DISTINCT shm01,shm05,sgm03,sgm012 FROM shm_file,sgm_file,sgn_file", #FUN-A60092 add sgm012
                 " WHERE shm01=sgm01 ",
                 "   AND sgn00=sgm01 ",
                 "   AND sgn01=shm05 ",
                 "   AND sgn02=shm06 ",
                 "   AND sgn03=sgm03 ",
                 "   AND sgn04=sgm06 ",
                 "   AND sgn012=sgm012",  #FUN-A60092
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " ORDER BY shm01,shm05"
    END IF
 
    PREPARE i711_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i711_cs SCROLL CURSOR WITH HOLD FOR i711_prepare
 
    IF g_wc2=' 1=1' OR g_wc2 IS NULL THEN
       LET g_sql=" SELECT DISTINCT shm01,shm05,sgm03,sgm012 FROM shm_file,sgm_file ",  #FUN-A60092 add sgm012
                 "  WHERE shm01=sgm01",
                 "   AND ",g_wc CLIPPED
    ELSE
       LET g_sql="SELECT DISTINCT shm01,shm05,sgm03,sgm012 FROM shm_file,sgm_file,sgn_file",  #FUN-A60092 add sgm012
                 " WHERE shm01=sgm01 ",
                 "   AND sgn00=sgm01 ",
                 "   AND sgn01=shm05 ",
                 "   AND sgn02=shm06 ",
                 "   AND sgn03=sgm03 ",
                 "   AND sgn04=sgm06 ",
                 "   AND sgn012=sgm012",  #FUN-A60092
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    IF INT_FLAG THEN RETURN END IF
 
    PREPARE i711_precount FROM g_sql
    DECLARE i711_count CURSOR FOR i711_precount
 
END FUNCTION
 
FUNCTION i711_menu()
 
   WHILE TRUE
      CALL i711_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i711_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i711_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0012
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sgn),'','')
            END IF
##
 
         #No.FUN-6A0039-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_shm01 IS NOT NULL THEN
                LET g_doc.column1 = "shm01"
                LET g_doc.column2 = "shm05"
                LET g_doc.column3 = "sgm03"
                LET g_doc.column4 = "sgm012"  #FUN-A60092 add
                LET g_doc.value1 = g_shm01
                LET g_doc.value2 = g_shm05
                LET g_doc.value3 = g_sgm03
                LET g_doc.value4 = g_sgm012   #FUN-A60092 add
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0039-------add--------end----
      END CASE
   END WHILE
   CLOSE i711_cs
END FUNCTION
 
FUNCTION i711_q()
 DEFINE l_cnt  RECORD
        shm01    LIKE shm_file.shm01,
        shm05    LIKE shm_file.shm05,
        sgm03    LIKE sgm_file.sgm03
       ,sgm012   LIKE sgm_file.sgm012  #FUN-A60092 add 
        END RECORD
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_shm.* TO NULL              #No.FUN-6A0039
    INITIALIZE g_sgm.* TO NULL              #No.FUN-6A0039  
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL i711_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_sgn.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i711_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shm.shm01,SQLCA.sqlcode,0)
        INITIALIZE g_shm.* TO NULL
        INITIALIZE g_sgm.* TO NULL
    ELSE
        FOREACH i711_count INTO l_cnt.*   #單身 ARRAY 填充
           LET g_row_count = g_row_count + 1
        END FOREACH
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i711_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i711_fetch(p_flsgn)
    DEFINE
        p_flsgn         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680073 INTEGER
 
    CASE p_flsgn
        WHEN 'N' FETCH NEXT     i711_cs INTO g_shm01,g_shm05,g_sgm03,g_sgm012  #FUN-A60092 add g_sgm012
        WHEN 'P' FETCH PREVIOUS i711_cs INTO g_shm01,g_shm05,g_sgm03,g_sgm012  #FUN-A60092 add g_sgm012
        WHEN 'F' FETCH FIRST    i711_cs INTO g_shm01,g_shm05,g_sgm03,g_sgm012  #FUN-A60092 add g_sgm012
        WHEN 'L' FETCH LAST     i711_cs INTO g_shm01,g_shm05,g_sgm03,g_sgm012  #FUN-A60092 add g_sgm012
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
            FETCH ABSOLUTE g_jump i711_cs INTO g_shm01,g_shm05,g_sgm03,g_sgm012  #FUN-A60092 add g_sgm012
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shm.shm01,SQLCA.sqlcode,0)
        INITIALIZE g_sgm.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flsgn
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_shm.* FROM shm_file       # 重讀DB,因TEMP有不被更新特性
     WHERE shm01= g_shm01
 
#FUN-4C0034
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_shm01,SQLCA.sqlcode,1) #No.FUN-660091
       CALL cl_err3("sel","shm_file",g_shm01,"",SQLCA.sqlcode,"","",1) #FUN-660091
       INITIALIZE g_shm.* TO NULL
    ELSE
       SELECT * INTO g_sgm.* FROM sgm_file
        WHERE sgm01 =g_shm01 AND  sgm03=g_sgm03
          AND sgm012= g_sgm012  #FUN-A60092 add
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_shm01,SQLCA.sqlcode,1) #No.FUN-660091
           CALL cl_err3("sel","sgm_file",g_shm01,g_sgm03,SQLCA.sqlcode,"","",1) #FUN-660091
           INITIALIZE g_sgm.* TO NULL
        ELSE
           LET g_data_owner = g_shm.shmuser      #FUN-4C0034
           LET g_data_group = g_shm.shmgrup      #FUN-4C0034
           LET g_data_plant = g_shm.shmplant #FUN-980030
           CALL i711_show()                      # 重新顯示
        END IF
    END IF
##
 
END FUNCTION
 
FUNCTION i711_b_askkey()
DEFINE
    l_wc2     LIKE type_file.chr1000      #No.FUN-680073 VARCHAR(200)        
 
    CONSTRUCT g_wc2 ON sgn05,sgn06,sgn07,sgn08,sgn09,sgn10,sgn11
              FROM s_sgn[1].sgn05,s_sgn[1].sgn06,s_sgn[1].sgn07,
                   s_sgn[1].sgn08,s_sgn[1].sgn09,s_sgn[1].sgn10,
                   s_sgn[1].sgn11
 
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
    CALL i711_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i711_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sgn TO s_sgn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i711_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i711_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i711_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i711_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i711_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
 
#FUN-4B0012
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
     ON ACTION related_document                #No.FUN-6A0039  相關文件
        LET g_action_choice="related_document"          
        EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
##
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i711_show()
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_eca02    LIKE eca_file.eca02
 
    DISPLAY BY NAME g_shm.shm01,g_shm.shm012,g_shm.shm08,g_shm.shm05,
                    g_shm.shm06,
                    g_sgm.sgm012,  #FUN-A60092 add
                    g_sgm.sgm03,g_sgm.sgm45,g_sgm.sgm06,g_sgm.sgm14,
                    g_sgm.sgm49,g_sgm.sgm16
    SELECT ima02,ima021 INTO  l_ima02,l_ima021 FROM ima_file
     WHERE ima01 = g_shm.shm05
     IF SQLCA.sqlcode THEN LET l_ima02 = ' ' LET l_ima021 = ' ' END IF
    SELECT eca02 INTO l_eca02  FROM eca_file
     WHERE eca01=g_sgm.sgm06
     IF SQLCA.sqlcode THEN LET l_eca02 =' ' END IF
    DISPLAY l_ima02  TO FORMONLY.ima02
    DISPLAY l_ima021 TO FORMONLY.ima021
    DISPLAY l_eca02  TO FORMONLY.eca02
    CALL i711_b_tot('d')
    CALL i711_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i711_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2        LIKE type_file.chr1000  #No.FUN-680073 VARCHAR(200)  
 
    LET g_sql = "SELECT sgn05,'','',sgn06,sgn07,sgn08,sgn10,sgn11,sgn09 ",
                " FROM sgn_file ",
                " WHERE sgn00 = '",g_shm01,"'  ",
                "   AND sgn01 = '",g_shm05,"'  ",
                "   AND sgn02 = '",g_shm.shm06,"'  ",
                "   AND sgn03 = '",g_sgm03,"'  ",
                "   AND sgn012= '",g_sgm012,"'", #FUN-A60092
                "   AND sgn04 = '",g_sgm.sgm06,"' ",
                "   AND ", p_wc2 CLIPPED,
                " ORDER BY 1 "
    PREPARE i711_pb FROM g_sql
    DECLARE sgn_curs CURSOR FOR i711_pb
 
    CALL g_sgn.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH sgn_curs INTO g_sgn[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_ac=g_cnt
        CALL i711_sgn05()
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_sgn.deleteElement(g_cnt)
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i711_sgn05()
    LET g_errno = ' '
    SELECT sga02,sga03,sga04,sga06
      INTO g_sgn[l_ac].sga02,g_sgn[l_ac].sga03,g_sgn[l_ac].sgn07,
           g_sgn[l_ac].sgn10
      FROM sga_file
     WHERE sga01 = g_sgn[l_ac].sgn05
       AND sgaacti = 'Y'                 #TQC-AB0385 add
    CASE WHEN SQLCA.SQLCODE = 100
              LET g_errno = 'aec-012'
              LET g_sgn[l_ac].sgn05 = NULL
         OTHERWISE
              LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF SQLCA.SQLCODE = 0  AND cl_null(g_errno)  THEN
       DISPLAY g_sgn[l_ac].sga02 TO sga02
       DISPLAY g_sgn[l_ac].sga03 TO sga03
       DISPLAY g_sgn[l_ac].sgn07 TO sgn07
    END IF
END FUNCTION
 
FUNCTION i711_b_tot(p_cmd)
    DEFINE l_sgm14a LIKE sgm_file.sgm14,
           l_sgm49a LIKE sgm_file.sgm49,
           l_sgm16a LIKE sgm_file.sgm16,
           l_sgm14  LIKE sgm_file.sgm14,
           l_sgm49  LIKE sgm_file.sgm49,
           l_sgm16  LIKE sgm_file.sgm16,
           p_cmd    LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
    SELECT SUM(sgn08),SUM(sgn09),SUM(sgn11)
      INTO l_sgm14a,l_sgm49a,l_sgm16a
            FROM sgn_file
            WHERE sgn00=g_shm.shm01
              AND sgn01=g_shm.shm05
              AND sgn02=g_shm.shm06
              AND sgn03=g_sgm03
              AND sgn012=g_sgm012  #FUN-A60092 add
              AND sgn04=g_sgm.sgm06
    LET g_sgm.sgm14 = l_sgm14a * g_shm.shm08
    LET g_sgm.sgm49 = l_sgm49a * g_shm.shm08
    LET g_sgm.sgm16 = l_sgm16a * g_shm.shm08
    DISPLAY BY NAME g_sgm.sgm14,g_sgm.sgm49,g_sgm.sgm16
    DISPLAY l_sgm14a,l_sgm49a,l_sgm16a TO sgm14a,sgm49a,sgm16a
    IF p_cmd='a' THEN
       UPDATE sgm_file SET
                       sgm14=g_sgm.sgm14,
                       sgm49=g_sgm.sgm49,
                       sgm16=g_sgm.sgm16
        WHERE sgm01=g_sgm.sgm01 AND sgm03=g_sgm.sgm03
          AND sgm012=g_sgm.sgm012 #FUN-A60092 add
        IF STATUS THEN
#           CALL cl_err('',STATUS,0) #No.FUN-660091
            CALL cl_err3("upd","sgm_file",g_sgm.sgm01,g_sgm.sgm03,STATUS,"","",1) #FUN-660091
        END IF
    END IF
END FUNCTION
 
FUNCTION i711_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT #No.FUN-680073 SMALLINT SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態          #No.FUN-680073 VARCHAR(1)
    l_sgn38         LIKE type_file.dat,      #No.FUN-680073     DATE
    l_allow_insert  LIKE type_file.num5,     #可新增否          #No.FUN-680073 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否          #No.FUN-680073 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_shm.* FROM shm_file  WHERE shm01= g_shm01
    IF SQLCA.sqlcode THEN INITIALIZE g_shm.* TO NULL END IF
    SELECT * INTO g_sgm.* FROM sgm_file WHERE sgm01 =g_shm01 AND  sgm03=g_sgm03
                                          AND sgm012=g_sgm012  #FUN-A60092 add
    IF SQLCA.sqlcode THEN INITIALIZE g_sgm.* TO NULL END IF
    IF g_shm.shm01 IS NULL THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT sgn05,'','',sgn06,sgn07,sgn08,sgn10,sgn11,sgn09 ",
                       " FROM sgn_file ",
                       " WHERE sgn00=? ",
                       "  AND sgn01=?  ",
                       "  AND sgn02=?  ",
                       "  AND sgn03=?  ",
                       "  AND sgn04=?  ",
                       "  AND sgn05=?  ",
                       "  AND sgn012= ? ", #FUN-A60092 add
                       "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i711_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_sgn WITHOUT DEFAULTS FROM s_sgn.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b !=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            IF g_rec_b>=l_ac THEN
            #IF g_sgn_t.sgn05 IS NOT NULL THEN
                LET p_cmd='u'
                LET g_sgn_t.* = g_sgn[l_ac].*  #BACKUP
                OPEN i711_bcl USING g_shm.shm01,g_shm.shm05,g_shm.shm06,g_sgm03,g_sgm.sgm06,g_sgn_t.sgn05
                                   ,g_sgm012    #FUN-A60092 add 
                IF STATUS THEN
                   CALL cl_err("OPEN i711_bcl:", STATUS, 1)
                   CLOSE i711_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i711_bcl INTO g_sgn[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_sgn_t.sgn05,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL  i711_sgn05()
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_sgn[l_ac].sgn05 IS NULL THEN    #重要欄位空白,無效
                INITIALIZE g_sgn[l_ac].* TO NULL
            END IF
#FUN-A60092 --begin--
            IF cl_null(g_sgm012) THEN
               LET g_sgm012 = ' '  
            END IF 
#FUN-A60092 --end--
            INSERT INTO sgn_file(sgn00,sgn01,sgn02,sgn03,
                                  sgn04,sgn05,
                                  sgn06,sgn07,sgn08,sgn10,sgn11,
                                  sgn09,
                                  sgnplant,sgnlegal,sgn012) #FUN-980002  #FUN-A60092 add sgn012
            VALUES(g_shm.shm01,g_shm.shm05,g_shm.shm06,
                    g_sgm03 ,g_sgm.sgm06,g_sgn[l_ac].sgn05,
                    g_sgn[l_ac].sgn06,g_sgn[l_ac].sgn07,
                    g_sgn[l_ac].sgn08,g_sgn[l_ac].sgn10,
                    g_sgn[l_ac].sgn11,g_sgn[l_ac].sgn09,
                    g_plant,g_legal,g_sgm012)          #FUN-980002 #FUN-A60092 add g_sgm012
            IF SQLCA.sqlcode THEN
#               CALL cl_err('ins sgn:',SQLCA.sqlcode,0) #No.FUN-660091
                CALL cl_err3("ins","sgn_file",g_shm.shm01,g_shm.shm05,SQLCA.sqlcode,"","ins sgn:",1) #FUN-660091
                CANCEL INSERT
            ELSE
                LET g_success='Y'
                CALL i711_b_tot('a')
                COMMIT WORK
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
                INITIALIZE g_sgn[l_ac].* TO NULL      #900423
                LET g_sgn[l_ac].sgn06 = 0
                LET g_sgn[l_ac].sgn07 = 0
                LET g_sgn[l_ac].sgn08 = 0
                LET g_sgn[l_ac].sgn09 = 0
            LET g_sgn_t.* = g_sgn[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD sgn05
 
        BEFORE FIELD sgn05
           LET g_shm_t.* = g_shm.*	
 
        AFTER FIELD sgn05                        #check 序號是否重複
            LET g_shm_t.* = g_shm.*
            IF NOT cl_null(g_sgn[l_ac].sgn05) THEN
               IF g_sgn[l_ac].sgn05 != g_sgn_t.sgn05 OR
                  g_sgn_t.sgn05 IS NULL THEN
                   SELECT count(*) INTO l_n
                      FROM sgn_file
                      WHERE sgn00 = g_shm.shm01
                        AND sgn01 = g_shm.shm05
                        AND sgn02 = g_shm.shm06
                        AND sgn03 = g_sgm03
                        AND sgn012= g_sgm012  #FUN-A60092 add
                        AND sgn04 = g_sgm.sgm06
                        AND sgn05 = g_sgn[l_ac].sgn05
                   IF l_n > 0 THEN CALL cl_err('',-239,0)
                       LET g_sgn[l_ac].sgn05 = g_sgn_t.sgn05
                       NEXT FIELD sgn05
                   END IF
               END IF
            END IF
 
        BEFORE FIELD sgn06
            CALL i711_sgn05()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD sgn05
            END IF
 
        AFTER FIELD sgn06
            IF g_sgn[l_ac].sgn06 IS NULL OR g_sgn[l_ac].sgn06 = 0  THEN
               NEXT FIELD sgn06
            END IF
            LET g_sgn[l_ac].sgn08 = g_sgn[l_ac].sgn07 * g_sgn[l_ac].sgn06
            LET g_sgn[l_ac].sgn11 = g_sgn[l_ac].sgn10 * g_sgn[l_ac].sgn06
            DISPLAY g_sgn[l_ac].sgn07 TO sgn07
            DISPLAY g_sgn[l_ac].sgn08 TO sgn08
            DISPLAY g_sgn[l_ac].sgn11 TO sgn11
 
        BEFORE FIELD sgn09
            LET g_sgn[l_ac].sgn09 = g_sgn[l_ac].sgn08 / 500
            IF g_sgn[l_ac].sgn09 < 0.001 THEN
               LET g_sgn[l_ac].sgn09 = 0.001
            END IF
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_sgn[l_ac].sgn09
            #------MOD-5A0095 END------------
 
        AFTER FIELD sgn09
            IF g_sgn[l_ac].sgn09 IS NULL OR g_sgn[l_ac].sgn09 = 0  THEN
               NEXT FIELD sgn09
            END IF
        BEFORE DELETE                            #是否取消單身
            IF g_sgn_t.sgn05 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
{ckp#1}         DELETE FROM sgn_file
                 WHERE sgn00=g_shm.shm01 AND sgn01=g_shm.shm05
                   AND sgn02=g_shm.shm06 AND sgn03=g_sgm03
                   AND sgn012=g_sgm012  #FUN-A60092 add
                   AND sgn04=g_sgm.sgm06 AND sgn05 = g_sgn[l_ac].sgn05
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_sgn_t.sgn05,SQLCA.sqlcode,0) #No.FUN-660091
                   CALL cl_err3("del","sgn_file",g_shm.shm01,g_shm.shm05,SQLCA.sqlcode,"","",1) #FUN-660091
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                LET g_success='Y'
                CALL i711_b_tot('a')
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sgn[l_ac].* = g_sgn_t.*
               CLOSE i711_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sgn[l_ac].sgn05,-263,1)
               LET g_sgn[l_ac].* = g_sgn_t.*
            ELSE
               IF g_sgn[l_ac].sgn05 IS NULL THEN    #重要欄位空白,無效
                   INITIALIZE g_sgn[l_ac].* TO NULL
               END IF
               UPDATE sgn_file SET
                      sgn05=g_sgn[l_ac].sgn05,
                      sgn06=g_sgn[l_ac].sgn06,
                      sgn07=g_sgn[l_ac].sgn07,
                      sgn08=g_sgn[l_ac].sgn08,
                      sgn10=g_sgn[l_ac].sgn10,
                      sgn11=g_sgn[l_ac].sgn11,
                      sgn09=g_sgn[l_ac].sgn09
                WHERE sgn00=g_shm.shm01
                  AND sgn01=g_shm.shm05
                  AND sgn02=g_shm.shm06
                  AND sgn03=g_sgm03
                  AND sgn012=g_sgm012  #FUN-A60092 add
                  AND sgn04=g_sgm.sgm06
                  AND sgn05 = g_sgn_t.sgn05
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_sgn[l_ac].sgn05,SQLCA.sqlcode,0) #No.FUN-660091
                   CALL cl_err3("upd","sgn_file",g_shm.shm01,g_sgn_t.sgn05,SQLCA.sqlcode,"","",1) #FUN-660091
                   LET g_sgn[l_ac].* = g_sgn_t.*
               ELSE
                   LET g_success='Y'
                   CALL i711_b_tot('a')
                   COMMIT WORK
                   MESSAGE 'UPDATE O.K'
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_sgn[l_ac].* = g_sgn_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sgn.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i711_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i711_bcl
            COMMIT WORK
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(sgn05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sga"
                 LET g_qryparam.default1 = g_sgn[l_ac].sgn05
                 CALL cl_create_qry() RETURNING g_sgn[l_ac].sgn05
#                 CALL FGL_DIALOG_SETBUFFER( g_sgn[l_ac].sgn05 )
                 DISPLAY g_sgn[l_ac].sgn05 TO sgn05
                 CALL i711_sgn05()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('','aec-012',0)
                    NEXT FIELD sgn05
                 END IF
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(sgn05) AND l_ac > 1 THEN
                LET g_sgn[l_ac].* = g_sgn[l_ac-1].*
                NEXT FIELD sgn05
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
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
    END INPUT
 
    CLOSE i711_bcl
    COMMIT WORK
END FUNCTION
#Patch....NO.MOD-5A0095 <001> #
