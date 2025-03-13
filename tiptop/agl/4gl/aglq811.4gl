# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglq811.4gl
# Descriptions...: 立帳異動明細查詢
# Date & Author..: 98/12/24 By plum
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.MOD-4C0171 05/02/15 By Smapmin 接收參數時,第一個必為帳別,若第一個不是帳別,則加入Null
# Modify.........: No.FUN-5C0015 06/01/03 By kevin 單頭增加欄位abh31~abh36
#                  (abh11~14, abh31~36)共10組依參數aaz88的設定顯示組數。
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/09 By hongmei 會計科目加帳套-財務
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A70119 10/07/27 By xiaofeizhu 修改單身無資料時，點明細查詢直接退出程序的BUG
# Modify.........: NO.MOD-AA0047 10/10/11 BY Dido 增加帳別條件
# Modify.........: NO.MOD-AB0059 10/11/05 BY Dido 增加帳別條件 
# Modify.........: No.FUN-B50051 11/05/12 By xjll 增加科目编号查询功能 
# Modify.........: No:FUN-B50105 11/05/26 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No.FUN-B40026 11/06/14 By zhangweib 去除abh31~abh36的操作
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
     tm  RECORD
          wc     LIKE type_file.chr1000,  # Head Where condition    #No.FUN-680098  VARCHAR(600) 
          wc2    LIKE type_file.chr1000   # Body Where condition    #No.FUN-680098   VARCHAR(600) 
        END RECORD,
    g_abh   RECORD LIKE abh_file.*,
    g_abg DYNAMIC ARRAY OF RECORD
            abg06   LIKE abg_file.abg06,
            abg01   LIKE abg_file.abg01,
            abg02   LIKE abg_file.abg02,
            abg05   LIKE abg_file.abg05,
            abg071  LIKE abg_file.abg071,
            abg072  LIKE abg_file.abg072,
            abg073  LIKE abg_file.abg073,
            unpay   LIKE abg_file.abg071,
            abg04   LIKE abg_file.abg04,    #No.FUN-680098  VARCHAR(25)
            gen02   LIKE gen_file.gen02
    END RECORD,
    g_unpay         LIKE abg_file.abg071,
    g_argv1         LIKE abh_file.abh01,
    g_argv2         LIKE abh_file.abh02,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-680098 smallint
     g_wc,g_wc2,g_sql,g_cmd string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b LIKE type_file.num10       #單身筆數   #No.FUN-680098  integer
 
 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680098  integer
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098  smallint
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-680098  VARCHAR(72) 
 
DEFINE   g_row_count    LIKE type_file.num10      #No.FUN-680098  integer
DEFINE   g_curs_index   LIKE type_file.num10      #No.FUN-680098 integer
DEFINE   g_jump         LIKE type_file.num10      #No.FUN-680098 integer
DEFINE   mi_no_ask      LIKE type_file.num5       #No.FUN-680098 smallint
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0073
      DEFINE    l_sl          LIKE type_file.num5        #No.FUN-680098   smallint
   DEFINE p_row,p_col   LIKE type_file.num5        #No.FUN-680098   smallint
 
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
 
 
     LET g_argv1      = ARG_VAL(2)     #No.MOD-4C0171          #參數值(1) Part#傳票編號
     LET g_argv2      = ARG_VAL(3)     #No.MOD-4C0171          #參數值(2) Part#傳票項次
    LET g_query_flag =1
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q811_w AT p_row,p_col WITH FORM "agl/42f/aglq811"  
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL q811_show_field()  #FUN-5C0015 add 
 
    IF NOT cl_null(g_argv1) THEN CALL q811_q() END IF
    CALL q811_menu()
    CLOSE WINDOW q811_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION q811_cs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680098 smallint
 
   IF g_argv1 != ' ' THEN
      LET tm.wc = "abh01 = '",g_argv1,"' AND ","abh02=",g_argv2
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM #清除畫面
   CALL g_abg.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL                   # Default condition
      CALL cl_set_head_visible("","YES")        #No.FUN-6B0029 
 
      # No.FUN-5C0015 (s)
      #CONSTRUCT BY NAME tm.wc ON abh03,abh01,abh02,abh021,abh05,
      #             abh11,abh12,abh13,abh14,abh04,abh09,abhconf 
   INITIALIZE g_abh.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON abh00,abh03,abh01,abh02,abh021,abh05,      #No.FUN-740020
                   abh11,abh12,abh13,abh14,
                  #abh31,abh32,abh33,abh34,abh35,abh36,   #FUN-B40026   Mark
                   abh04,abh09,abhconf 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      #No.FUN-740020 ---Begin
      ON ACTION CONTROLP                                                                                                          
            CASE
              WHEN INFIELD(abh00)                                                                                                 
                     CALL cl_init_qry_var()                                                                                         
                     LET g_qryparam.form ="q_aaa"                                                                                   
                     LET g_qryparam.state = "c"                                                                                     
                     CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
                     DISPLAY g_qryparam.multiret TO abh00
                     NEXT FIELD abh00 
    #No.FUN-B50051--str--
            WHEN INFIELD(abh03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_aag"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO abh03
                   NEXT FIELD abh03
    #No.FUN-B50051--end--
            END CASE
      #No.FUN-740020 --end
 
      # No.FUN-5C0015 (e)
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
      CALL q811_b_askkey()
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   IF INT_FLAG THEN RETURN END IF
   MESSAGE ' WAIT ' 
   IF tm.wc2=" 1=1" THEN
      LET g_sql=" SELECT unique abh01,abh02,abh00,abh06,abh07,abh08 FROM abh_file ",
                " WHERE abhconf != 'X' AND ",tm.wc CLIPPED,
                " ORDER BY 1,2 " 
   ELSE
      LET g_sql=" SELECT unique abh01,abh02,abh00,abh06,abh07,abh08 ",
                "  FROM abh_file,abg_file ",
                " WHERE abh07=abg01 AND abh08=abg02",
                "   AND abh03=abg03 AND abhconf != 'X' ",
                "   AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "   AND abg00 = abh00 ",       #MOD-AA0047
                " ORDER BY 1,2  " 
   END IF
   PREPARE q811_prepare FROM g_sql
   DECLARE q811_cs SCROLL CURSOR FOR q811_prepare
 
   IF tm.wc2=" 1=1" THEN
      LET g_sql=" SELECT COUNT(*) FROM abh_file ",
                " WHERE ",tm.wc CLIPPED
    ELSE
      LET g_sql=" SELECT COUNT(UNIQUE abh01)",
                "  FROM abh_file,abg_file ",
               #No.B177 010503 by plum mod
               #" WHERE abh01=abg07 AND abh02=abg08",
               #"   AND abh03=abg03 AND ",tm.wc CLIPPED,
                " WHERE abh07=abg01 AND abh08=abg02",
                "   AND abh03=abg03 AND ",tm.wc CLIPPED,
               #No.B117...end
                "   AND ",tm.wc2 CLIPPED, 
                "   AND abg00 = abh00 "       #MOD-AA0047
   END IF
   PREPARE q811_pp  FROM g_sql
   DECLARE q811_cnt   CURSOR FOR q811_pp
END FUNCTION
 
FUNCTION q811_b_askkey()
   CONSTRUCT tm.wc2 ON abg06,abg01,abg02,abg05,abg071,abg072,abg073,abg04
                  FROM s_abg[1].abg06 ,s_abg[1].abg01 ,s_abg[1].abg02,
                       s_abg[1].abg05 ,s_abg[1].abg071,s_abg[1].abg072,
                       s_abg[1].abg073,s_abg[1].abg04
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
END FUNCTION
 
FUNCTION q811_menu()
 
   WHILE TRUE
      CALL q811_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q811_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_abg),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q811_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q811_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q811_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
    OPEN q811_cnt
    FETCH q811_cnt INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt 
    CALL q811_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
        MESSAGE ''
END FUNCTION
 
FUNCTION q811_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
    l_cnt           LIKE type_file.num5,                                  #No.FUN-680098 smallint
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098 integer
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q811_cs INTO g_abh.abh01,g_abh.abh02,
                                             g_abh.abh00,g_abh.abh06,
                                             g_abh.abh07,g_abh.abh08
        WHEN 'P' FETCH PREVIOUS q811_cs INTO g_abh.abh01,g_abh.abh02,
                                             g_abh.abh00,g_abh.abh06,
                                             g_abh.abh07,g_abh.abh08
        WHEN 'F' FETCH FIRST    q811_cs INTO g_abh.abh01,g_abh.abh02,
                                             g_abh.abh00,g_abh.abh06,
                                             g_abh.abh07,g_abh.abh08
        WHEN 'L' FETCH LAST     q811_cs INTO g_abh.abh01,g_abh.abh02,
                                             g_abh.abh00,g_abh.abh06,
                                             g_abh.abh07,g_abh.abh08
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
            FETCH ABSOLUTE g_jump q811_cs INTO g_abh.abh01,g_abh.abh02,
                                               g_abh.abh00,g_abh.abh06,
                                               g_abh.abh07,g_abh.abh08
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_abh.abh01,SQLCA.sqlcode,0)
        INITIALIZE g_abh.* TO NULL  #TQC-6B0105
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
    SELECT count(*) INTO l_cnt  
      FROM abh_file WHERE abh00 = g_abh.abh00 AND abh01 = g_abh.abh01 AND abh02 = g_abh.abh02    #No.FUN-740020
    IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
    IF l_cnt = 0  THEN
        CALL cl_err(g_abh.abh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL q811_show()
END FUNCTION
 
FUNCTION q811_show()
   DEFINE l_aag02 LIKE aag_file.aag02
   DEFINE l_gen02 LIKE gen_file.gen02
   DEFINE l_gem02 LIKE gem_file.gem02
 
 
   SELECT * INTO g_abh.* FROM abh_file
    WHERE abh01 = g_abh.abh01 AND abh02 = g_abh.abh02
      AND abh00 = g_abh.abh00 AND abh06 = g_abh.abh06
      AND abh07 = g_abh.abh07 AND abh08 = g_abh.abh08
 
   DISPLAY BY NAME g_abh.abh00,g_abh.abh03,g_abh.abh01,       #No.FUN-740020 
            g_abh.abh02,g_abh.abh021, g_abh.abh05,g_abh.abh11 ,
            g_abh.abh12,g_abh.abh13 , g_abh.abh14,g_abh.abh04 ,
           #g_abh.abh31,g_abh.abh32,g_abh.abh33,g_abh.abh34,  # FUN-5C0015 add #FUN-B40026   Mark
           #g_abh.abh35,g_abh.abh36,                          # FUN-5C0015 add #FUN-B40026   Mark
            g_abh.abh09,g_abh.abhconf 
 
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_abh.abh03
                                             AND aag00=g_abh.abh00      #No.FUN-740020
   IF SQLCA.sqlcode THEN LET l_aag02 = ' ' END IF
   DISPLAY l_aag02 TO FORMONLY.aag02 
 
   SELECT gen02 INTO l_gen02 FROM aba_file,gen_file
    WHERE aba01=g_abh.abh01 AND gen01=abauser
   IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
   DISPLAY l_gen02 TO FORMONLY.gen02_h
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_abh.abh05
   DISPLAY l_gem02 TO gem02
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      DISPLAY "!" TO abhconf
   END IF
   CALL q811_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q811_b_fill()              #BODY FILL UP
   DEFINE l_sql           LIKE type_file.chr1000,        #No.FUN-680098 VARCHAR(400)
          g_gen02         LIKE gen_file.gen02,
          g_abaconf       LIKE aba_file.aba19,
          g_abauser       LIKE aba_file.abauser 
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT abg06,abg01,abg02,abg05,abg071,abg072,abg073,0,abg04[1,25], ",
        "       ' ' ",
        "  FROM abh_file,abg_file ",
        " WHERE abh01= '",g_abh.abh01,"' AND abh02='",g_abh.abh02,"'",
        "   AND abh00= '",g_abh.abh00,"' AND abh06='",g_abh.abh06,"'",
        "   AND abh07= '",g_abh.abh07,"' AND abh08='",g_abh.abh08,"'",
        "   AND abg00 = abh00 ",                                         #MOD-AB0059 
        "   AND abg01= abh07 AND abg02 = abh08 ",
        "   AND ",tm.wc2 CLIPPED,
        " ORDER BY abg06,abg01,abg02 "
 
    PREPARE q811_pb FROM l_sql
    DECLARE q811_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q811_pb
 
    FOR g_cnt = 1 TO g_abg.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_abg[g_cnt].* TO NULL
    END FOR
    LET g_unpay=0 
    LET g_cnt = 1
    FOREACH q811_bcs INTO g_abg[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_abg[g_cnt].abg071 IS NULL THEN LET g_abg[g_cnt].abg071=0 END IF
        IF g_abg[g_cnt].abg072 IS NULL THEN LET g_abg[g_cnt].abg072=0 END IF
        IF g_abg[g_cnt].abg073 IS NULL THEN LET g_abg[g_cnt].abg073=0 END IF
        LET g_unpay=g_abg[g_cnt].abg071-g_abg[g_cnt].abg072-g_abg[g_cnt].abg073
        SELECT gen02 INTO g_gen02 FROM aba_file,gen_file
         WHERE aba01=g_abg[g_cnt].abg01 AND gen01=abauser
        IF SQLCA.sqlcode THEN LET g_gen02 = ' ' END IF
        LET g_abg[g_cnt].gen02  =g_gen02
        LET g_abg[g_cnt].unpay  =g_unpay
        LET g_cnt = g_cnt + 1
#       IF g_cnt > g_abg_arrno THEN
#          CALL cl_err('',9035,0)
#          EXIT FOREACH
#       END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2  
 
    DISPLAY ARRAY g_abg TO s_abg.* ATTRIBUTE(COUNT=g_cnt)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
END FUNCTION
 
FUNCTION q811_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_abg TO s_abg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first 
         CALL q811_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q811_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL q811_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q811_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL q811_fetch('L')
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION query_details #detail查詢
         LET g_i = ARR_CURR()
         IF g_i > 0 THEN                      #TQC-A70119 Add
         IF g_abg[g_i].abg01 <> ' ' AND g_abg[g_i].abg01 IS NOT NULL THEN
             LET g_cmd =  "aglq810 '' ","'",g_abg[g_i].abg01,"' ",g_abg[g_i].abg02  #MOD-4C0171
            CALL cl_cmdrun(g_cmd clipped)
         END IF
         LET g_action_choice="query_details"
         END IF                               #TQC-A70119 Add
         EXIT DISPLAY
 
      ON ACTION accept
        #LET l_ac = ARR_CURR()
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
 
   
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
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
 
#FUN-5C0015 BY kevin (s)
FUNCTION  q811_show_field()
#依參數決定異動碼的多寡
 
  DEFINE l_field     string
 
#FUN-B50105   ---start   Mark
# IF g_aaz.aaz88 = 10 THEN
#    RETURN
# END IF
#
# IF g_aaz.aaz88 = 0 THEN
#    LET l_field  = "abh11,abh12,abh13,abh14,abh31,abh32,abh33,abh34,",
#                   "abh35,abh36"
# END IF
#
# IF g_aaz.aaz88 = 1 THEN
#    LET l_field  = "abh12,abh13,abh14,abh31,abh32,abh33,abh34,",
#                   "abh35,abh36"
# END IF
#
# IF g_aaz.aaz88 = 2 THEN
#    LET l_field  = "abh13,abh14,abh31,abh32,abh33,abh34,",
#                   "abh35,abh36"
# END IF
#
# IF g_aaz.aaz88 = 3 THEN
#    LET l_field  = "abh14,abh31,abh32,abh33,abh34,",
#                   "abh35,abh36"
# END IF
#
# IF g_aaz.aaz88 = 4 THEN
#    LET l_field  = "abh31,abh32,abh33,abh34,",
#                   "abh35,abh36"
# END IF
#
# IF g_aaz.aaz88 = 5 THEN
#    LET l_field  = "abh32,abh33,abh34,",
#                   "abh35,abh36"
# END IF
#
# IF g_aaz.aaz88 = 6 THEN
#    LET l_field  = "abh33,abh34,abh35,abh36"
# END IF
#
# IF g_aaz.aaz88 = 7 THEN
#    LET l_field  = "abh34,abh35,abh36"
# END IF
#
# IF g_aaz.aaz88 = 8 THEN
#    LET l_field  = "abh35,abh36"
# END IF
#
# IF g_aaz.aaz88 = 9 THEN
#    LET l_field  = "abh36"
# END IF
#FUN-B50105   ---end     Mark


#FUN-B50105   ---start   Add
  IF g_aaz.aaz88 = 0 THEN
     LET l_field = "abh11,abh12,abh13,abh14"
  END IF
  IF g_aaz.aaz88 = 1 THEN
     LET l_field = "abh12,abh13,abh14"
  END IF
  IF g_aaz.aaz88 = 2 THEN
     LET l_field = "abh13,abh14"
  END IF
  IF g_aaz.aaz88 = 3 THEN
     LET l_field = "abh14"
  END IF
  IF g_aaz.aaz88 = 4 THEN
     LET l_field = ""
  END IF
#FUN-B40026   ---start   Mark
# IF NOT cl_null(l_field) THEN
#    LET l_field = l_field,","
# END IF
# IF g_aaz.aaz125 = 5 THEN
#    LET l_field = l_field,"abh32,abh33,abh34,abh35,abh36"
# END IF
# IF g_aaz.aaz125 = 6 THEN
#    LET l_field = l_field,"abh33,abh34,abh35,abh36"
# END IF
# IF g_aaz.aaz125 = 7 THEN
#    LET l_field = l_field,"abh34,abh35,abh36"
# END IF
# IF g_aaz.aaz125 = 8 THEN
#    LET l_field = l_field,"abh35,abh36"
# END IF
#FUN-B40026   ---end     Mark
#FUN-B50105   ---end     Add
 
  CALL cl_set_comp_visible(l_field,FALSE)
 
END FUNCTION
 
#FUN-5C0015 BY kevin (e)
