# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglq810.4gl
# Descriptions...: 立帳異動明細查詢
# Date & Author..: 98/12/24 By plum
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.MOD-4C0171 05/02/15 By Smapmin 接收參數時,第一個必為帳別,若第一個不是帳別,則加入Null
# Modify.........: No.FUN-5C0015 06/01/03 By kevin 單頭增加欄位abg31~abg36
#                  (abg11~14, abg31~36)共10組依參數aaz88的設定顯示組數。
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/09 By dxfwo    會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No:TQC-A70119 10/07/27 By xiaofeizhu 修改單身無資料時，點明細查詢直接退出程序的BUG
# Modify.........: NO.MOD-AA0047 10/10/11 BY Dido 增加帳別條件
# Modify.........: No.FUN-B50051 11/05/12 By xjll 增加科目编号查询功能 
# Modify.........: No:FUN-B50105 11/05/26 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No:FUN-B40026 11/06/15 By zhangweib 除去对abg31~36的操作
# Modify.........: No:MOD-BA0092 11/10/14 By Polly 處理匯出的excel內容與單身內容不符合
# Modify.........: No.FUN-C10024 12/05/16 By minpp 帳套取歷年主會計帳別檔tna_file

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
     tm  RECORD
                wc     LIKE type_file.chr1000,  # Head Where condition   #No.FUN-680098  VARCHAR(600)
                wc2    LIKE type_file.chr1000   # Body Where condition   #No.FUN-680098  VARCHAR(600)
        END RECORD,
    g_abg   RECORD
        abg00   LIKE abg_file.abg00,   #No.FUN-740020 
        abg03   LIKE abg_file.abg03,
        abg01   LIKE abg_file.abg01,
        abg02   LIKE abg_file.abg02, 
        abg06   LIKE abg_file.abg06, 
        abg05   LIKE abg_file.abg05, 
        abg11   LIKE abg_file.abg11, 
        abg12   LIKE abg_file.abg12, 
        abg13   LIKE abg_file.abg13, 
        abg14   LIKE abg_file.abg14,
#FUN-B40026   ---start   Mark
#       # No.FUN-5C0015 add (s)
#       abg31   LIKE abg_file.abg31, 
#       abg32   LIKE abg_file.abg32, 
#       abg33   LIKE abg_file.abg33, 
#       abg34   LIKE abg_file.abg34, 
#       abg35   LIKE abg_file.abg35, 
#       abg36   LIKE abg_file.abg36, 
#       # No.FUN-5C0015 add (e)
#FUN-B40026   ---end      Mark
        abg04   LIKE abg_file.abg04, 
        abg071  LIKE abg_file.abg071, 
        abg072  LIKE abg_file.abg072, 
        abg073  LIKE abg_file.abg073  
        END RECORD,
    g_abh DYNAMIC ARRAY OF RECORD
            abh021  LIKE abh_file.abh021,
            abh01   LIKE abh_file.abh01,
            abh02   LIKE abh_file.abh02,
            abh05   LIKE abh_file.abh05,
            abh09   LIKE abh_file.abh09,
            gen02   LIKE gen_file.gen02,
            abaconf LIKE aba_file.aba19,
            abh04   LIKE abh_file.abh04        #No.FUN-680098  VARCHAR(25)
    END RECORD,
    g_unpay         LIKE abg_file.abg071,
    g_abh09tot      LIKE abh_file.abh09,
    g_argv1         LIKE abg_file.abg01,
    g_argv2         LIKE abg_file.abg02,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-680098 smallint
    g_wc,g_wc2,g_sql,g_cmd string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b  LIKE type_file.num10        #單身筆數    #No.FUN-680098   integer       
 
 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680098  integer
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680098 smallint
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-680098   VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680098  integer
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680098  integer
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680098  integer
DEFINE   mi_no_ask      LIKE type_file.num5         #No.FUN-680098  smallint
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0073
     DEFINE     l_sl          LIKE type_file.num5          #No.FUN-680098  smallint
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680098  smallint
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                         #擷取中斷鍵, 由程式處理
 
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
    OPEN WINDOW q810_w AT p_row,p_col
         WITH FORM "agl/42f/aglq810"  
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL q810_show_field()  # FUN-5C0015 add
 
    IF NOT cl_null(g_argv1) THEN CALL q810_q() END IF
    CALL q810_menu()
    CLOSE WINDOW q810_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION q810_cs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680098  smallint
 
   IF g_argv1 != ' ' THEN
      LET tm.wc = "abg01 = '",g_argv1,"' AND ","abg02=",g_argv2
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM #清除畫面
   CALL g_abh.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL                   # Default condition
      # No.FUN-5C0015 mod (s)
      #CONSTRUCT BY NAME tm.wc ON abg03,abg01,abg02,abg06,abg05,         
      #             abg11,abg12,abg13,abg14,abg04,abg071,abg072,abg073
   INITIALIZE g_abg.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON abg00,abg03,abg01,abg02,abg06,abg05,    #No.FUN-740020
                   abg11,abg12,abg13,abg14,
                  #abg31,abg32,abg33,abg34,abg35,abg36,     #FUN-B40026   Mark
                   abg04,abg071,abg072,abg073
      # No.FUN-5C0015 mod (e) 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          #No.FUN-740020  --Begin                                                                                                   
    ON ACTION CONTROLP                                                                                                              
          CASE                                                                                                                      
             WHEN INFIELD(abg00)                                                                                                    
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.state = "c"                                                                                             
                LET g_qryparam.form ="q_aaa"                                                                                        
                LET g_qryparam.default1 = g_abg.abg00                                                                               
                CALL cl_create_qry() RETURNING g_abg.abg00                                                                          
                DISPLAY BY NAME g_abg.abg00  
                   NEXT FIELD abg00   
    #No.FUN-B50051--str--
            WHEN INFIELD(abg03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_aag"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO abg03
                   NEXT FIELD abg03
    #No.FUN-B50051--end--                                                                                        
          OTHERWISE EXIT CASE                                                                                                       
       END CASE
          #No.FUN-740020  --End                                                                                                   
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
      CALL q810_b_askkey()
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   IF INT_FLAG THEN RETURN END IF
   MESSAGE ' WAIT ' 
   IF tm.wc2=" 1=1" THEN
      LET g_sql=" SELECT abg00,abg03,abg01,abg02 FROM abg_file ",  #No.FUN-740020
                " WHERE ",tm.wc CLIPPED,
                " ORDER BY abg00,abg03,abg01,abg02 "  # No.FUN-740020
   ELSE
      LET g_sql=" SELECT DISTINCT abg00,abg03,abg01,abg02 ", #No.FUN-740020
                "  FROM abg_file,abh_file ",
                " WHERE abg00=abh00 AND abg01=abh07 AND abg02=abh08",
                "   AND abg03=abh03 AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                " ORDER BY abg00,abg03,abg01,abg02 "                      #No.FUN-740020
   END IF
   PREPARE q810_prepare FROM g_sql
   DECLARE q810_cs SCROLL CURSOR FOR q810_prepare
 
   # 取合乎條件筆數
   IF tm.wc2=" 1=1" THEN
      LET g_sql=" SELECT COUNT(*) FROM abg_file ",
                " WHERE ",tm.wc CLIPPED
    ELSE
      LET g_sql=" SELECT COUNT(DISTINCT abg01)",
                "  FROM abg_file,abh_file ",
                " WHERE abg01=abh07 AND abg02=abh08",
                "   AND abg03=abh03 AND ",tm.wc CLIPPED,
                "   AND ",tm.wc2 CLIPPED,
                "   AND abg00 = abh00 "       #MOD-AA0047 
   END IF
   PREPARE q810_pp  FROM g_sql
   DECLARE q810_cnt   CURSOR FOR q810_pp
END FUNCTION
 
FUNCTION q810_b_askkey()
   CONSTRUCT tm.wc2 ON abh021,abh01,abh02,abh05,abh09,gen02,aba19,abh04
                  FROM s_abh[1].abh021,s_abh[1].abh01,s_abh[1].abh02,
                       s_abh[1].abh05, s_abh[1].abh09,s_abh[1].gen02,
                       s_abh[1].abaconf,s_abh[1].abh04
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
 
FUNCTION q810_menu()
 
   WHILE TRUE
      CALL q810_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q810_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
             #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_abg),'','')  #MOD-BA0092 mark
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_abh),'','')  #MOD-BA0092 add
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q810_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
   #DISPLAY '   ' TO FORMONLY.cnt  
    CALL q810_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q810_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q810_cnt
       FETCH q810_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt 
       CALL q810_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
        MESSAGE ''
END FUNCTION
 
FUNCTION q810_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098 integer
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q810_cs INTO g_abg.abg00,g_abg.abg03,     #No.FUN-740020
                                             g_abg.abg01,g_abg.abg02
        WHEN 'P' FETCH PREVIOUS q810_cs INTO g_abg.abg00,g_abg.abg03,     #No.FUN-740020  
                                             g_abg.abg01,g_abg.abg02
        WHEN 'F' FETCH FIRST    q810_cs INTO g_abg.abg00,g_abg.abg03,     #No.FUN-740020
                                             g_abg.abg01,g_abg.abg02
        WHEN 'L' FETCH LAST     q810_cs INTO g_abg.abg00,g_abg.abg03,     #No.FUN-740020
                                             g_abg.abg01,g_abg.abg02
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
            FETCH ABSOLUTE g_jump q810_cs INTO g_abg.abg00,g_abg.abg03,g_abg.abg01,g_abg.abg02    #No.FUN-740020
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_abg.abg01,SQLCA.sqlcode,0)
        INITIALIZE g_abg.* TO NULL  #TQC-6B0105
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
    SELECT  abg00,abg03,abg01,abg02,abg06,abg05,               #No.FUN-740020  
            abg11,abg12,abg13,abg14,
           #abg31,abg32,abg33,abg34,abg35,abg36,    #FUN-5C0015 #FUN-B40026
            abg04,abg071,abg072,abg073
      INTO g_abg.*
      FROM abg_file WHERE abg00 = g_abg.abg00 AND abg01 = g_abg.abg01 AND abg02 = g_abg.abg02 AND abg03 = g_abg.abg03
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_abg.abg01,SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("sel","abg_file",g_abg.abg01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123
        RETURN
    END IF
 
    CALL q810_show()
END FUNCTION
 
FUNCTION q810_show()
   DEFINE l_aag02 LIKE aag_file.aag02
   DEFINE l_gem02 LIKE gem_file.gem02
   DEFINE l_pay   LIKE abg_file.abg071
 
   #No.FUN-9A0024--begin   
   #DISPLAY BY NAME g_abg.*  
   DISPLAY BY NAME g_abg.abg00,g_abg.abg03,g_abg.abg01,g_abg.abg02,g_abg.abg06,g_abg.abg05,
                   g_abg.abg11,g_abg.abg12,g_abg.abg13,g_abg.abg14,
                  #g_abg.abg31,g_abg.abg32,g_abg.abg33,   #FUN-B40026   Mark
                  #g_abg.abg34,g_abg.abg35,g_abg.abg36,   #FUN-B40026   Mark
                   g_abg.abg04,g_abg.abg071,g_abg.abg072,g_abg.abg073
   #No.FUN-9A0024--end 
 # SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_abg.abg03   #FUN-C10024  mark
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_abg.abg03 AND aag00=g_abg.abg00 #FUN-C10024 add
   LET l_pay  = g_abg.abg072 + g_abg.abg073
   LET g_unpay=g_abg.abg071- l_pay 
   DISPLAY l_aag02 TO FORMONLY.aag02    
   DISPLAY l_pay      TO FORMONLY.tot2  
   DISPLAY g_unpay    TO FORMONLY.unpay 
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_abg.abg05
   DISPLAY l_gem02 TO gem02
   CALL q810_b_fill() #單身
   DISPLAY g_abh09tot TO FORMONLY.tot
   IF g_abh09tot != l_pay  THEN 
      DISPLAY  'ERROR DATA ' TO abg14 
   END IF
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q810_b_fill()              #BODY FILL UP
   DEFINE l_sql      LIKE type_file.chr1000,  #No.FUN-680098 VARCHAR(1000)
          g_gen02         LIKE gen_file.gen02,
          g_abaconf       LIKE aba_file.aba19,
          g_abauser       LIKE aba_file.abauser 
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
       #"SELECT abh021,abh01,abh02,abh05,abh09,'','',substring(abh04,1,25) ",  #No.TQC-9B0021
        "SELECT abh021,abh01,abh02,abh05,abh09,'','',abh04[1,25] ",  #No.TQC-9B0021
        "  FROM abh_file ",
        " WHERE abh07= '",g_abg.abg01,"' AND abh08= '",g_abg.abg02,"'",
        "   AND abh03='",g_abg.abg03,"'",
        "   AND abhconf != 'X' AND ",tm.wc2 CLIPPED,
        "   AND abh00 = '",g_abg.abg00,"'",       #MOD-AA0047
        " ORDER BY abh021,abh01,abh02 "
 
    PREPARE q810_pb FROM l_sql
    DECLARE q810_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q810_pb
 
    FOR g_cnt = 1 TO g_abh.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_abh[g_cnt].* TO NULL
    END FOR
    LET g_unpay=0 LET g_abh09tot=0
    LET g_cnt = 1
    FOREACH q810_bcs INTO g_abh[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_abh[g_cnt].abh09 IS NULL THEN
           LET g_abh[g_cnt].abh09 = 0 
        END IF
        LET g_abh09tot=g_abh09tot+g_abh[g_cnt].abh09 
        SELECT abauser,aba19 INTO g_abauser,g_abaconf FROM aba_file
         WHERE aba01=g_abh[g_cnt].abh01
        SELECT gen02 INTO g_gen02 FROM gen_file WHERE gen01=g_abauser
        LET g_abh[g_cnt].gen02  =g_gen02
        LET g_abh[g_cnt].abaconf=g_abaconf
        LET g_cnt = g_cnt + 1
#       IF g_cnt > g_abh_arrno THEN
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
    DISPLAY g_rec_b TO FORMONLY.cn2
 
   DISPLAY ARRAY g_abh TO s_abh.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
 
END FUNCTION
 
FUNCTION q810_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_abh TO s_abh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q810_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q810_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL q810_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q810_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL q810_fetch('L')
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
        IF g_abh[g_i].abh01 <> ' ' AND g_abh[g_i].abh01 IS NOT NULL THEN
           LET g_cmd =  "aglq811 '' ","'",g_abh[g_i].abh01,"' ",g_abh[g_i].abh02  #MOD-4C0171
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
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#FUN-5C0015 BY kevin (s)
FUNCTION  q810_show_field()
#依參數決定異動碼的多寡
 
  DEFINE l_field   STRING
 
#FUN-B50105   ---start   Mark
# IF g_aaz.aaz88 = 10 THEN
#    RETURN
# END IF
#
# IF g_aaz.aaz88 = 0 THEN
#    LET l_field  = "abg11,abg12,abg13,abg14,abg31,abg32,abg33,abg34,",
#                   "abg35,abg36"
# END IF
#
# IF g_aaz.aaz88 = 1 THEN
#    LET l_field  = "abg12,abg13,abg14,abg31,abg32,abg33,abg34,",
#                   "abg35,abg36"
# END IF
#
# IF g_aaz.aaz88 = 2 THEN
#    LET l_field  = "abg13,abg14,abg31,abg32,abg33,abg34,",
#                   "abg35,abg36"
# END IF
#
# IF g_aaz.aaz88 = 3 THEN
#    LET l_field  = "abg14,abg31,abg32,abg33,abg34,",
#                   "abg35,abg36"
# END IF
#
# IF g_aaz.aaz88 = 4 THEN
#    LET l_field  = "abg31,abg32,abg33,abg34,",
#                   "abg35,abg36"
# END IF
#
# IF g_aaz.aaz88 = 5 THEN
#    LET l_field  = "abg32,abg33,abg34,",
#                   "abg35,abg36"
# END IF
#
# IF g_aaz.aaz88 = 6 THEN
#    LET l_field  = "abg33,abg34,abg35,abg36"
# END IF
#
# IF g_aaz.aaz88 = 7 THEN
#    LET l_field  = "abg34,abg35,abg36"
# END IF
#
# IF g_aaz.aaz88 = 8 THEN
#    LET l_field  = "abg35,abg36"
# END IF
#
# IF g_aaz.aaz88 = 9 THEN
#    LET l_field  = "abg36"
# END IF
#FUN-B50105   ---end     Mark

#FUN-B50105   ---start   Add
  IF g_aaz.aaz88 = 0 THEN
     LET l_field = "abg11,abg12,abg13,abg14"
  END IF
  IF g_aaz.aaz88 = 1 THEN
     LET l_field = "abg12,abg13,abg14"
  END IF
  IF g_aaz.aaz88 = 2 THEN
     LET l_field = "abg13,abg14"
  END IF
  IF g_aaz.aaz88 = 3 THEN
     LET l_field = "abg14"
  END IF
  IF g_aaz.aaz88 = 4 THEN
     LET l_field = ""
  END IF
#FUN-B40026   ---start   Mark
# IF NOT cl_null(l_field) THEN 
#    LET l_field = l_field,","
# END IF
# IF g_aaz.aaz125 = 5 THEN
#    LET l_field = l_field,"abg32,abg33,abg34,abg35,abg36"
# END IF
# IF g_aaz.aaz125 = 6 THEN
#    LET l_field = l_field,"abg33,abg34,abg35,abg36"
# END IF
# IF g_aaz.aaz125 = 7 THEN
#    LET l_field = l_field,"abg34,abg35,abg36"
# END IF
# IF g_aaz.aaz125 = 8 THEN
#    LET l_field = l_field,"abg35,abg36"
# END IF
#FUN-B40026   ---start   Mark
#FUN-B50105   ---end     Add
 
  CALL cl_set_comp_visible(l_field,FALSE)
 
END FUNCTION
 
#FUN-5C0015 BY kevin (e)
 
 
