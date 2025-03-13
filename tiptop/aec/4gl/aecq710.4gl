# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aecq710.4gl
# Descriptions...: Run Card製程數量狀態查詢
# Date & Author..: 00/05/04 By Apple
# Modify.........: No:7662 03/07/24 Carol 於T.其它FUNCTION, 在DISPLAY資料時,
#                                         應區分GUI及TEXT MODE的筆數
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530852 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.TQC-630161 06/06/09 By Pengu 再計算wip量時不應將合併轉入與分割轉入量列入計算
# Modify.........: No.FUN-660091 06/06/15 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei欄位型態轉換
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770004 07/07/03 By mike 無法跳出幫助信息
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60095 10/07/06 By jan add sgm012/ecu014/sgm65 delete sgm57
# Modify.........: No.FUN-A80150 10/09/06 By sabrina GP5.2號機管理 
# Modify.........: No.TQC-AB0387 10/11/30 By vealxu 當首次查詢出單身有資料的情況下，再點查詢，條件下成抓不到資料的情況，查詢出來的結果是提示100無資料的錯誤
# Modify.........: No:TQC-AC0374 10/12/30 By jan 調用s_schdat_ecu014() 抓取製程段名稱
# Modify.........: No:FUN-B10056 11/02/21 By lixh1 制程段號說明欄位改用實體欄位sgm014來顯示
# Modify.........: No.FUN-A70095 11/06/13 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_shm   RECORD LIKE shm_file.*,
    g_shm_t RECORD LIKE shm_file.*,
    g_shm01_t LIKE shm_file.shm01,
    g_argv1   LIKE shm_file.shm01,
    g_wc,g_wc2      STRING,  #No.FUN-580092 HCN 
    g_sql           STRING,  #No.FUN-580092 HCN    
    g_sgm           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sgm03       LIKE sgm_file.sgm03,   #製程序
        sgm012      LIKE sgm_file.sgm012,  #製程段號   #FUN-A60095
      # ecu014      LIKE ecu_file.ecu014,  #製程段號名 #FUN-A60095  #FUN-B10056 mark
        sgm014      LIKE sgm_file.sgm014,  #FUN-B10056
        sgm06       LIKE sgm_file.sgm06,   #生產站別
        m06_name    LIKE pmc_file.pmc03,   #
        sgm54       LIKE sgm_file.sgm54,   #check-in 否
        sgm04       LIKE sgm_file.sgm04,
        ta_ecd05    LIKE ecd_file.ecd05,
        sgm45       LIKE sgm_file.sgm45,   #作業名稱
        sgm65       LIKE sgm_file.sgm65,   #標準產出量 #FUN-A60095
        wipqty      LIKE sgm_file.sgm315,  #
        sgm301      LIKE sgm_file.sgm301,  #
        sgm302      LIKE sgm_file.sgm302,  #
        sgm303      LIKE sgm_file.sgm303,
        sgm304      LIKE sgm_file.sgm304,
        sgm311      LIKE sgm_file.sgm311,  #
        sgm312      LIKE sgm_file.sgm312,  #
        sgm313      LIKE sgm_file.sgm313,  #
        sgm314      LIKE sgm_file.sgm314,  #
        shb30       LIKE shb_file.shb30,   #  #FUN-A80150 add  
        sgm66       LIKE sgm_file.sgm66,   #  #FUN-A80150 add  
        sgm315      LIKE sgm_file.sgm315,  #
        sgm316      LIKE sgm_file.sgm316,
        sgm317      LIKE sgm_file.sgm317,
        sgm321      LIKE sgm_file.sgm321,  #
        sgm322      LIKE sgm_file.sgm322,  #
        sgm291      LIKE sgm_file.sgm291,  #
        sgm292      LIKE sgm_file.sgm292,
       #sgm57       LIKE sgm_file.sgm57,   #FUN-A60095
        sgm58       LIKE sgm_file.sgm58,
        sgm52       LIKE sgm_file.sgm52,
        sgm53       LIKE sgm_file.sgm53,
        sgm55       LIKE sgm_file.sgm55,
        sgm56       LIKE sgm_file.sgm56
                    END RECORD,
    g_sgm_t         RECORD                 #程式變數 (舊值)
        sgm03       LIKE sgm_file.sgm03,   #製程序
        sgm012      LIKE sgm_file.sgm012,  #製程段號   #FUN-A60095
      # ecu014      LIKE ecu_file.ecu014,  #製程段號名 #FUN-A60095  #FUN-B10056 mark
        sgm014      LIKE sgm_file.sgm014,  #FUN-B10056
        sgm06       LIKE sgm_file.sgm06,   #生產站別
        m06_name    LIKE pmc_file.pmc03,   #
        sgm54       LIKE sgm_file.sgm54,   #check-in 否
        sgm04       LIKE sgm_file.sgm04,
        ta_ecd05    LIKE ecd_file.ecd05,
        sgm45       LIKE sgm_file.sgm45,   #作業名稱
        sgm65       LIKE sgm_file.sgm65,   #標準產出量 #FUN-A60095
        wipqty      LIKE sgm_file.sgm315,  #
        sgm301      LIKE sgm_file.sgm301,  #
        sgm302      LIKE sgm_file.sgm302,  #
        sgm303      LIKE sgm_file.sgm303,
        sgm304      LIKE sgm_file.sgm304,
        sgm311      LIKE sgm_file.sgm311,  #
        sgm312      LIKE sgm_file.sgm312,  #
        sgm313      LIKE sgm_file.sgm313,  #
        sgm314      LIKE sgm_file.sgm314,  #
        shb30       LIKE shb_file.shb30,   #  #FUN-A80150 add  
        sgm66       LIKE sgm_file.sgm66,   #  #FUN-A80150 add  
        sgm315      LIKE sgm_file.sgm315,  #
        sgm316      LIKE sgm_file.sgm316,
        sgm317      LIKE sgm_file.sgm317,
        sgm321      LIKE sgm_file.sgm321,  #
        sgm322      LIKE sgm_file.sgm322,  #
        sgm291      LIKE sgm_file.sgm291,  #
        sgm292      LIKE sgm_file.sgm292,
       #sgm57       LIKE sgm_file.sgm57,   #FUN-A60095
        sgm58       LIKE sgm_file.sgm58,
        sgm52       LIKE sgm_file.sgm52,
        sgm53       LIKE sgm_file.sgm53,
        sgm55       LIKE sgm_file.sgm55,
        sgm56       LIKE sgm_file.sgm56
                    END RECORD,
   #g_sgm59         LIKE sgm_file.sgm59,         #FUN-A60095
    g_rec_b         LIKE type_file.num5,         #單身筆數        #No.FUN-680073 SMALLINT
    l_ac            LIKE type_file.num5
DEFINE g_forupd_sql      STRING                       #SELECT ... FOR UPDATE SQL  
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

    LET g_argv1 = ARG_VAL(1)  #Run Card

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

    INITIALIZE g_shm.* TO NULL
    INITIALIZE g_shm_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM shm_file WHERE shm01 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE q710_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW q710_w WITH FORM "aec/42f/aecq710"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
  #  CALL cl_set_comp_visible("sgm012,ecu014",g_sma.sma541='Y') #FUN-A60095  #FUN-B10056 mark
    CALL cl_set_comp_visible("sgm012,sgm014",g_sma.sma541='Y') #FUN-B10056  
    CALL cl_set_comp_visible("shm18",g_sma.sma1421='Y')        #FUN-A80150 add
    CALL cl_set_comp_visible("shb30,sgm66",g_sma.sma1431='Y')  #FUN-A80150 add

    IF g_user <> 'tiptop' THEN
       CALL cl_set_comp_visible("luoyb",FALSE)
    END IF 

    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN CALL q710_q()
    END IF
    CALL q710_menu()
    CLOSE WINDOW q710_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q710_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    LET  g_wc2=' 1=1'
    CLEAR FORM
    CALL g_sgm.clear()                            #TQC-AB0387 
    IF cl_null(g_argv1) THEN
       CALL cl_set_head_visible("","YES")         #No.FUN-6B0029
 
   INITIALIZE g_shm.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON shm01,shm012,shm06,shm05
 
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
 
       #CONSTRUCT g_wc2 ON sgm03,sgm012,sgm06,sgm54,sgm04,sgm45,sgm65,   #FUN-A60095 #FUN-B10056 mark
       CONSTRUCT g_wc2 ON sgm03,sgm012,sgm014,sgm06,sgm54,sgm04,sgm45,sgm65,   #FUN-B10056 add sgm014
                          sgm301,sgm302,sgm303,sgm304,sgm311,sgm312,sgm313,
                          sgm314,sgm66,sgm315,sgm316,sgm317, sgm321,sgm322,sgm291,        #FUN-A80150 add sgm66
                          sgm292,sgm58,sgm52,sgm53,sgm55,sgm56    #FUN-A60095 del sgm57
            FROM s_sgm[1].sgm03,s_sgm[1].sgm012,s_sgm[1].sgm014,s_sgm[1].sgm06,   #FUN-A60095  #FUN-B10056 add sgm014 
                 s_sgm[1].sgm04,
                 s_sgm[1].sgm54,s_sgm[1].sgm45,s_sgm[1].sgm65,    #FUN-A60095
                 s_sgm[1].sgm301,s_sgm[1].sgm302,
                 s_sgm[1].sgm303,s_sgm[1].sgm304,
                 s_sgm[1].sgm311,s_sgm[1].sgm312,
                 s_sgm[1].sgm313,s_sgm[1].sgm314,s_sgm[1].sgm66,s_sgm[1].sgm315,        #FUN-A80150 add sgm66
                 s_sgm[1].sgm316,s_sgm[1].sgm317,
                 s_sgm[1].sgm321,s_sgm[1].sgm322,
                 s_sgm[1].sgm291,s_sgm[1].sgm292,
                 s_sgm[1].sgm58,                    #FUN-A60095
                 s_sgm[1].sgm52,s_sgm[1].sgm53,
                 s_sgm[1].sgm55,s_sgm[1].sgm56
 
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
       LET g_wc ="shm01 ='",g_argv1,"'"
    END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND shmuser = '",g_user,"'"
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
       LET g_sql="SELECT shm01 FROM shm_file ",   
                 " WHERE ",g_wc CLIPPED, " ORDER BY shm01"
    ELSE
     # LET g_sql="SELECT shm01",                          #TQC-AB0387              
       LET g_sql="SELECT DISTINCT shm01 ",                #TQC-AB0387
                 "  FROM shm_file,sgm_file ",
                 " WHERE shm01=sgm01 ",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " ORDER BY shm01"
    END IF   
 
    PREPARE q710_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE q710_cs SCROLL CURSOR WITH HOLD FOR q710_prepare
 
   #TQC-AB0387 -------add start----------
    IF g_wc2=' 1=1' OR g_wc2 IS NULL THEN
       LET g_sql= "SELECT COUNT(*) FROM shm_file WHERE ",g_wc CLIPPED
    ELSE
   #TQC-AB0387 -------add end------------
   #LET g_sql= "SELECT COUNT(*) FROM shm_file WHERE ",g_wc CLIPPED    #TQC-AB0387
       LET g_sql= "SELECT COUNT(DISTINCT shm01) FROM shm_file,sgm_file ",                       #TQC-AB0387
                  " WHERE shm01=sgm01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED                  #TQC-AB0387
    END IF                                                                                      #TQC-AB0387
    PREPARE q710_precount FROM g_sql
    DECLARE q710_count CURSOR FOR q710_precount
END FUNCTION
 
FUNCTION q710_menu()
 
   WHILE TRUE
      CALL q710_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q710_q()
            END IF
         WHEN "help"
             IF cl_chk_act_auth() THEN    #No.TQC-770004
                 CALL cl_show_help()       #No.TQC-770004 
             END IF                         #No.TQC-770004 
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
#        #@WHEN "其它"
#        WHEN "other_data"
#           IF cl_chk_act_auth() THEN
#              CALL q710_t()
#           END IF
#FUN-4B0012
         WHEN "luoyb"
            CALL q710_luoyb()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sgm),'','')
            END IF
##
      END CASE
   END WHILE
      CLOSE q710_cs
END FUNCTION
 
FUNCTION q710_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
  # DISPLAY '   ' TO FORMONLY.cnt
    CALL q710_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN q710_count
    FETCH q710_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q710_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shm.shm01,SQLCA.sqlcode,0)
        INITIALIZE g_shm.* TO NULL
    ELSE
        CALL q710_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q710_fetch(p_flshm)
    DEFINE
        p_flshm         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680073 INTEGER
 
    CASE p_flshm
        WHEN 'N' FETCH NEXT     q710_cs INTO g_shm.shm01
        WHEN 'P' FETCH PREVIOUS q710_cs INTO g_shm.shm01
        WHEN 'F' FETCH FIRST    q710_cs INTO g_shm.shm01
        WHEN 'L' FETCH LAST     q710_cs INTO g_shm.shm01
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR  g_jump
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
            FETCH ABSOLUTE  g_jump q710_cs INTO g_shm.shm01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shm.shm01,SQLCA.sqlcode,0)
        INITIALIZE g_shm.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flshm
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index =  g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_shm.* FROM shm_file       # 重讀DB,因TEMP有不被更新特性
       WHERE shm01 = g_shm.shm01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_shm.shm01,SQLCA.sqlcode,1) #No.FUN-660091
       CALL cl_err3("sel","shm_file",g_shm.shm01,"",SQLCA.sqlcode,"","",1) #FUN-660091
 
     INITIALIZE g_shm.* TO NULL            #FUN-4C0034
    ELSE
       LET g_data_owner = g_shm.shmuser      #FUN-4C0034
       LET g_data_group = g_shm.shmgrup      #FUN-4C0034
       CALL q710_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION q710_show()
    LET g_shm_t.* = g_shm.*
    DISPLAY BY NAME
        g_shm.shm01, g_shm.shm012, g_shm.shm05, g_shm.shm06,
        g_shm.shm18,g_shm.shm08, g_shm.shm09                    #FUN-A80150 add shm18
    CALL q710_shm05('d')
    CALL q710_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q710_b_askkey()
  #  CONSTRUCT g_wc2 ON sgm03,sgm012,sgm54,sgm06,sgm45,sgm65,sgm301,sgm302,    #FUN-A60095   #FUN-B10056 mark
     CONSTRUCT g_wc2 ON sgm03,sgm012,sgm014,sgm54,sgm06,sgm04,sgm45,sgm65,sgm301,sgm302,  #FUN-B10056 add sgm014
              sgm311,sgm312,sgm313,sgm314,sgm66,sgm315,sgm321,sgm322,sgm291,sgm292,     #FUN-A80150 add sgm66
              sgm303,sgm304,sgm316,sgm317,sgm58   #FUN-A60095
         FROM s_sgm[1].sgm03,s_sgm[1].sgm012,     #FUN-A60095
              s_sgm[1].sgm014,                    #FUN-B10056 add sgm014
              s_sgm[1].sgm54,s_sgm[1].sgm06,
              s_sgm[1].sgm04,
              s_sgm[1].sgm45,s_sgm[1].sgm65,      #FUN-A60095
              s_sgm[1].sgm301,s_sgm[1].sgm302,
              s_sgm[1].sgm311,s_sgm[1].sgm312,
              s_sgm[1].sgm313,s_sgm[1].sgm314,s_sgm[1].sgm66,s_sgm[1].sgm315,     #FUN-A80150 add sgm66
              s_sgm[1].sgm321,s_sgm[1].sgm322,
              s_sgm[1].sgm291,s_sgm[1].sgm292,
              s_sgm[1].sgm303,s_sgm[1].sgm304,
              s_sgm[1].sgm316,s_sgm[1].sgm317,
              s_sgm[1].sgm58                      #FUN-A60095   
 
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
    CALL q710_b_fill(g_wc2)
END FUNCTION
 
 
FUNCTION q710_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sgm TO s_sgm.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q710_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q710_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q710_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q710_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q710_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#FUN-4B0012
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##

      ON ACTION luoyb
         LET g_action_choice = 'luoyb'
         EXIT DISPLAY
 
       #No.MOD-530852  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
       #No.MOD-530852  --end
 
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
 
 
FUNCTION q710_shm05(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
    l_imaacti       LIKE ima_file.imaacti,
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021
 
    LET g_errno = ' '
    SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti FROM ima_file
     WHERE ima01=g_shm.shm05
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET g_shm.shm05 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------     
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY BY NAME g_shm.shm05
       DISPLAY l_ima02  TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
    END IF
END FUNCTION
 
FUNCTION q710_b_fill(p_wc2)                     #BODY FILL UP
  DEFINE p_wc2         LIKE type_file.chr1000   #No.FUN-680073 VARCHAR(600)
 
  #  LET g_sql ="SELECT sgm03,sgm012,'',sgm06,' ',sgm54,sgm04,sgm45,sgm65,'',sgm301,sgm302,", #FUN-A60095   #FUN-B10056 mark
     LET g_sql ="SELECT sgm03,sgm012,sgm014,sgm06,' ',sgm54,sgm04,ta_ecd05,sgm45,sgm65,'',sgm301,sgm302,",  #FUN-B10056 add sgm014
               " sgm303,sgm304,sgm311,sgm312,sgm313,sgm314,'',sgm66,sgm315,",        #FUN-A80150 add '',sgm66
               " sgm316,sgm317,sgm321,sgm322,",
               " sgm291,sgm292,sgm58, ",    #FUN-A60095
               " sgm52,sgm53,sgm55,sgm56 ", #FUN-A60095
               "  FROM sgm_file LEFT JOIN ecd_file on ecd01=sgm04 ",
               " WHERE sgm01 = '",g_shm.shm01, "'",
               "   AND ",g_wc2 CLIPPED,
               " ORDER BY sgm012,sgm03,sgm06 "  #FUN-A60095
    PREPARE q7103_pb FROM g_sql
    DECLARE sgm_curs CURSOR FOR q7103_pb
 
    CALL g_sgm.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    #單身 ARRAY 填充
    FOREACH sgm_curs  INTO g_sgm[g_cnt].*   #FUN-A60095
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF

        #FUN-A60095--begin--add------------
        #TQC-AC0374--begin--mark---------
        #SELECT ecu014 INTO g_sgm[g_cnt].ecu014 FROM ecu_file
        # WHERE ecu01 = g_shm.shm05
        #   AND ecu02 = g_shm.shm06
        #   AND ecu012= g_sgm[g_cnt].sgm012
        #TQC-AC0374--end--mark-----------
        #FUN-A60095--end--add----------------
     #   CALL s_schdat_ecu014(g_shm.shm012,g_sgm[g_cnt].sgm012) RETURNING g_sgm[g_cnt].ecu014 #TQC-AC0374  #FUN-B10056 mark

        SELECT eca02 INTO g_sgm[g_cnt].m06_name FROM eca_file
         WHERE eca01 = g_sgm[g_cnt].sgm06
        IF SQLCA.sqlcode THEN LET g_sgm[g_cnt].m06_name = ' ' END IF
 
        IF cl_null(g_sgm[g_cnt].sgm52) THEN
           LET g_sgm[g_cnt].sgm52 = 'N'
        END IF
        IF cl_null(g_sgm[g_cnt].sgm53) THEN
           LET g_sgm[g_cnt].sgm53 = 'N'
        END IF
        IF cl_null(g_sgm[g_cnt].sgm54) THEN
           LET g_sgm[g_cnt].sgm54 = 'N'
        END IF
 
       #FUN-A80150---add---start---
        SELECT shb30 INTO g_sgm[g_cnt].shb30 FROM shb_file
         WHERE shb16=g_shm.shm01 AND shb06=g_sgm[g_cnt].sgm03 
           AND shb012=g_sgm[g_cnt].sgm012
           AND shbconf = 'Y'     #FUN-A70095
       #FUN-A80150---add---end---
        CALL q710_get_wip(g_cnt)  # get WIP QTY
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '',9035,1)
           EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_sgm.deleteElement(g_cnt)
    LET g_rec_b= g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q710_get_wip(p_i)
DEFINE 
        p_i     LIKE type_file.num5         #No.FUN-680073 SMALLINT 
 
#      某站若要報工則其可報工數=WIP量(a+b-f-g-d-e-h+i)，
#      若要做Check-In則可報工數=c-f-g-d-e-h+i。
       IF g_sgm[p_i].sgm54='Y' THEN   #check in 否
        LET g_sgm[p_i].wipqty
                        =  g_sgm[p_i].sgm291                #check in
                        #+ g_sgm[p_i].sgm303                #No.TQC-630161 mark
                        #+ g_sgm[p_i].sgm304                #No.TQC-630161 mark
                         - g_sgm[p_i].sgm311 #*g_sgm59      #良品轉出 #FUN-A60095
                         - g_sgm[p_i].sgm312 #*g_sgm59      #重工轉出 #FUN-A60095
                         - g_sgm[p_i].sgm313 #*g_sgm59      #當站報廢 #FUN-A60095
                         - g_sgm[p_i].sgm314 #*g_sgm59      #當站下線 #FUN-A60095
                         - g_sgm[p_i].sgm316 #*g_sgm59                #FUN-A60095
                         - g_sgm[p_i].sgm317 #*g_sgm59                #FUN-A60095
#                        - g_sgm[p_i].sgm321                #委外加工量
#                        + g_sgm[p_i].sgm322                #委外完工量
       ELSE
        LET g_sgm[p_i].wipqty
                        =  g_sgm[p_i].sgm301                #良品轉入量
                         + g_sgm[p_i].sgm302                #重工轉入量
                         + g_sgm[p_i].sgm303
                         + g_sgm[p_i].sgm304
                         - g_sgm[p_i].sgm311 #*g_sgm59      #良品轉出  #FUN-A60095
                         - g_sgm[p_i].sgm312 #*g_sgm59      #重工轉出  #FUN-A60095
                         - g_sgm[p_i].sgm313 #*g_sgm59      #當站報廢  #FUN-A60095
                         - g_sgm[p_i].sgm314 #*g_sgm59      #當站下線  #FUN-A60095
                         - g_sgm[p_i].sgm316 #*g_sgm59                 #FUN-A60095
                         - g_sgm[p_i].sgm317 #*g_sgm59                 #FUN-A60095 
#                        - g_sgm[p_i].sgm321                #委外加工量
#                        + g_sgm[p_i].sgm322                #委外完工量
       END IF
 
       IF cl_null(g_sgm[p_i].wipqty) THEN LET g_sgm[p_i].wipqty=0 END IF
 
END FUNCTION

FUNCTION q710_luoyb()
   DEFINE l_shm       RECORD LIKE shm_file.*
   DEFINE l_sgm       RECORD LIKE sgm_file.*
   DEFINE l_cnt,l_n   LIKE type_file.num5
   DEFINE l_shb111    LIKE shb_file.shb111
   DEFINE l_shb113    LIKE shb_file.shb113
   DEFINE l_shb114    LIKE shb_file.shb114
   DEFINE l_shb115    LIKE shb_file.shb115

   DECLARE q710_c_luoyb CURSOR FOR
    SELECT shm_file.* FROM shm_file,sfb_file
     WHERE sfb01 = shm012
       AND sfb87 = 'Y'    #审核的工单刷新
       AND sfb04 >= '4'   #已发料的才刷新
#       AND sfb01 = 'WRK-16070176'
#       AND shm01 = 'MRA-16080030-038-00'
   FOREACH q710_c_luoyb INTO l_shm.*
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM sgm_file   #无工艺的不更新
      WHERE sgm01 = l_shm.shm01
     IF l_cnt = 0 OR cl_null(l_cnt) THEN
        CONTINUE FOREACH
     END IF
     
     UPDATE sgm_file SET sgm65 = l_shm.shm08    #将标准产出量更新为生产数量
      WHERE sgm01 = l_shm.shm01

     LET l_n = 1   
     LET l_shb111 = 0
     DECLARE q710_c_luoyb1 CURSOR FOR
      SELECT sgm_file.* FROM sgm_file
       WHERE sgm01 = l_shm.shm01
       ORDER BY sgm03 
     FOREACH q710_c_luoyb1 INTO l_sgm.*
       IF l_n = 1 THEN   #首道工艺更新良品转入量为标准产出量
          UPDATE sgm_file SET sgm301 = l_shm.shm08
           WHERE sgm01 = l_shm.shm01
             AND sgm03 = l_sgm.sgm03
       ELSE
          UPDATE sgm_file SET sgm301 = l_shb111+l_shb115        #更新良品转入量为上道工艺报工量
#                             sgm302 = l_shb113                 #返工转入
           WHERE sgm01 = l_shm.shm01
             AND sgm03 = l_sgm.sgm03
       END IF 
 
       LET l_shb111 = 0 LET l_shb113 = 0 LET l_shb114 = 0 LET l_shb115 = 0
       #取得报工良品、返工转出、当站下线、超量转移
       SELECT SUM(NVL(shb111,0)),SUM(NVL(shb113,0)),SUM(NVL(shb114,0)),SUM(NVL(shb115,0))
         INTO l_shb111,l_shb113,l_shb115 FROM shb_file
        WHERE shb16 = l_shm.shm01
          AND shb06 = l_sgm.sgm03
          AND shbconf = 'Y'
       IF cl_null(l_shb111) THEN LET l_shb111 = 0 END IF 
       IF cl_null(l_shb113) THEN LET l_shb113 = 0 END IF
       IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
       IF cl_null(l_shb115) THEN LET l_shb115 = 0 END IF

       UPDATE sgm_file SET sgm311 = l_shb111,        #更新良品转出量为报工量
                           sgm312 = l_shb113,
                           sgm314 = l_shb114,
                           sgm315 = l_shb115
                          ,sgm302 = l_shb113
        WHERE sgm01 = l_shm.shm01
          AND sgm03 = l_sgm.sgm03
       
       
       LET l_n = l_n + 1
     END FOREACH
   END FOREACH
END FUNCTION 
