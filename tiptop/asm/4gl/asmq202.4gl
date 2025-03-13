# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: asmq202.4gl
# Descriptions...: 單據查詢
# Date & Author..: 93/05/20  By  Felicity  Tseng
# Modify.........: No:7994 03/08/31 Kammy add tlf99 多角序號
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-550068 05/05/24 By day  單據編號加大
# Modify.........: No.FUN-560002 05/05/24 By day  單據編號修改
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-670051 06/07/17 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-840144 08/04/22 By Sarah 增加ACTION"查詢類別異動成本"串tlfc_file
# Modify.........: No.FUN-890125 08/10/08 By Jerry 修正若程式寫法為SELECT rowid,.....,rowid寫法會出現ORA-600的錯誤
# Modify.........: No.FUN-8C0035 09/01/20 By jan新增"異動時間" "作業編號兩個欄位
# Modify.........: No.TQC-930125 09/03/18 By Sunyanchun 查詢異動類型成本功能鈕雙擊單身，程序死鎖
# Modify.........: No.MOD-980158 09/08/19 By Smapmin tm.wc定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0204 09/11/24 By Carrier azf02的条件变为外连
# Modify.........: No:CHI-A90024 10/10/08 By Summer 增加顯示tlf20
# Modify.........: No:TQC-960120 10/11/05 By Sabrina _b_fill()段畫面沒有.cnt這個欄位
# Modify.........: No:CHI-B80055 13/01/22 By Alberti 查詢時異動成本(tlf21)要可以輸入
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
            #wc         LIKE type_file.chr1000  #No.FUN-690010   VARCHAR(1000)   #MOD-980158
            wc          STRING    #MOD-980158
           END RECORD,
       g_tlf_rowid     VARCHAR(36),   #No.FUN-690010 INT # saki 20070821 rowid chr18 -> num10 
       g_ima02	       LIKE ima_file.ima02,
       g_ima021	       LIKE ima_file.ima021,
       g_azf03	       LIKE azf_file.azf03,
       g_smydesc       LIKE smy_file.smydesc,
       g_wc,g_sql      STRING,                 #No.FUN-580092 HCN
       x1              LIKE tlf_file.tlf01,    #No.MOD-490217
       x2	       LIKE type_file.chr20,   #No.FUN-690010 VARCHAR(20),
       g_argv1	       LIKE tlf_file.tlf01,    #PART NO不可為空白 No.MOD-490217
       g_argv2	       LIKE tlf_file.tlf06,    #No.FUN-690010 VARCHAR(10),	# Begin date 不可為空白
       g_argv3	       LIKE tlf_file.tlf06,    #No.FUN-690010 VARCHAR(10),	# End  date 不可為空白
       g_argv4	       LIKE tlf_file.tlf902,   #No.FUN-690010 VARCHAR(10),	# Warehouse    可為空白
       g_argv5	       LIKE tlf_file.tlf903,   #No.FUN-690010 VARCHAR(10),	# Location     可為空白
       g_argv6	       LIKE tlf_file.tlf904    #No.FUN-690010 VARCHAR(24)	# Lot no       可為空白
DEFINE g_chr           LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10    #No.FUN-690010 INTEGER
DEFINE g_msg           LIKE ze_file.ze03       #No.FUN-690010 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10    #No.FUN-690010 INTEGER
DEFINE g_curs_index    LIKE type_file.num10    #No.FUN-690010 INTEGER
DEFINE g_jump          LIKE type_file.num10    #No.FUN-690010 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5     #No.FUN-690010 SMALLINT
DEFINE g_rec_b         LIKE type_file.num5          #單身筆數                      #FUN-840144 add
DEFINE l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT           #FUN-840144 add
DEFINE g_tlfc          DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)   #FUN-840144 add
        tlfctype         LIKE tlfc_file.tlfctype,   #成本計算類別
        tlfccost         LIKE tlfc_file.tlfccost,   #類別編號
        tlfc21           LIKE tlfc_file.tlfc21      #成會異動成本
                       END RECORD
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0089
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
   LET g_argv3=ARG_VAL(3)
   LET g_argv4=ARG_VAL(4)
   LET g_argv5=ARG_VAL(5)
   LET g_argv6=ARG_VAL(6)
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
 
   LET p_row = 2 LET p_col = 2
   OPEN WINDOW asmq202_w AT p_row,p_col WITH FORM "asm/42f/asmq202"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN CALL q202_q() END IF
 
   #WHILE TRUE      ####040512
   LET g_action_choice=""
   CALL q202_menu()
  #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
   #END WHILE    ####040512
 
   CLOSE WINDOW q202_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
END MAIN
 
FUNCTION q202_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   CLEAR FORM
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL	
   LET INT_FLAG = 0  ######add for prompt bug
  #prompt g_argv1,'/',g_argv2,'/',g_argv3,'/',g_argv4,'/',g_argv5,'/' for g_chr
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc=" tlf01='",g_argv1,"'",
            " AND tlf06>='",g_argv2,"'",
            " AND tlf06<='",g_argv3,"'"
      IF NOT cl_null(g_argv4) THEN
         LET tm.wc=tm.wc CLIPPED," AND tlf902='",g_argv4,"'"
      END IF
      IF NOT cl_null(g_argv5) THEN
         LET tm.wc=tm.wc CLIPPED," AND tlf903='",g_argv5,"'"
      END IF
      IF NOT cl_null(g_argv6) THEN
         LET tm.wc=tm.wc CLIPPED," AND tlf904='",g_argv6,"'"
      END IF
   ELSE
      WHILE TRUE
      INITIALIZE x1 TO NULL    #No.FUN-750051
      INITIALIZE x2 TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON
                tlf01, tlf06,tlf905,tlf906,tlf62,tlf13,
                tlf14,tlf19,tlf20,tlf64,tlf930,tlf99,tlf05,tlf901,tlf902,tlf903,  #FUN-670051 #FUN-8C0035 add tlf05 #CHI-A90024 add tlf20
               #tlf904,tlf907,tlf10,tlf11,tlf12,tlf60,tlf02,           #CHI-B80055 mark
                tlf904,tlf907,tlf10,tlf11,tlf12,tlf60,tlf21,tlf02,     #CHI-B80055 add
                tlf020,tlf021,tlf022,tlf023,tlf025,tlf026,tlf027,
                tlf03,tlf030,tlf031,tlf032,tlf033,tlf035,tlf036,tlf037,
                tlf07,tlf09,tlf211,tlf212,tlf08               #FUN-8C0035 add tlf08                       
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         #MOD-530850
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(tlf01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = "c"
                LET g_qryparam.default1 = g_tlf.tlf01
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tlf01
                NEXT FIELD tlf01
              #FUN-670051...............begin
              WHEN INFIELD(tlf930)
                CALL cl_init_qry_var()
                LET g_qryparam.form  = "q_gem4"
                LET g_qryparam.state = "c"   #多選
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tlf930
                NEXT FIELD tlf930
              #FUN-670051...............end
              OTHERWISE
                EXIT CASE
            END CASE
         #--
 
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
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
      END WHILE
   END IF
   #No.TQC-9B0204  --Begin
  # LET g_sql=" SELECT tlf_file.rowid,tlf01,tlf06,ima02,ima021,azf03,smydesc,tlf_file.rowid ",
    LET g_sql=" SELECT tlf_file.rowid,tlf01,tlf06,ima02,ima021,azf03,smydesc ",#FUN-890125        
              " FROM tlf_file LEFT OUTER JOIN ima_file ON tlf_file.tlf01 = ima_file.ima01 ",
              "               LEFT OUTER JOIN azf_file ON tlf_file.tlf14 = azf_file.azf01 ",
              "                                       AND azf_file.azf02 = '2' ", #6818
              "               LEFT OUTER JOIN smy_file ON tlf_file.tlf905 LIKE ltrim(rtrim(smy_file.smyslip)) || '-%' ",
             " WHERE ",tm.wc CLIPPED,
#            "   AND azf_file.azf02 = '2' ", #6818
#No.FUN-550068-begin
#            "   AND tlf905[1,3] = smy_file.smyslip",
#No.FUN-550068-end
             " ORDER BY 2,3"
   #No.TQC-9B0204  --End  
   PREPARE q202_prepare FROM g_sql
   DECLARE q202_cs SCROLL CURSOR FOR q202_prepare
 
   LET g_sql=" SELECT COUNT(*) FROM tlf_file ",
             " WHERE ",tm.wc CLIPPED
   PREPARE q202_pp  FROM g_sql
   DECLARE q202_cnt   CURSOR FOR q202_pp
END FUNCTION
 
#中文的MENU
FUNCTION q202_menu()
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                CALL q202_q()
            END IF
        ON ACTION next
            CALL q202_fetch('N')
        ON ACTION previous
            CALL q202_fetch('P')
        ON ACTION jump
            cALL q202_fetch('/')
        ON ACTION first
            CALL q202_fetch('F')
        ON ACTION last
            CALL q202_fetch('L')
       #str FUN-840144 add
#       ON ACTION 查詢類別異動成本
        ON ACTION qry_tlfc_data
            CALL q202_q_tlfc()
       #end FUN-840144 add
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON IDLE g_idle_seconds
            CALL cl_on_idle()
        ON ACTION about         #MOD-4C0121
            CALL cl_about()     #MOD-4C0121

        ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()    #MOD-4C0121

        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
    END MENU
END FUNCTION
 
 
FUNCTION q202_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q202_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "Waiting..."
    OPEN q202_cs
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q202_cnt
       FETCH q202_cnt INTO g_row_count
       DISPLAY g_row_count TO cnt
       CALL q202_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q202_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690010 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q202_cs INTO g_tlf_rowid,x1,x2,
                                           # g_ima02,g_ima021,g_azf03,g_smydesc,g_tlf_rowid
                                             g_ima02,g_ima021,g_azf03,g_smydesc #FUN-890125                                   
        WHEN 'P' FETCH PREVIOUS q202_cs INTO g_tlf_rowid,x1,x2,
                                           # g_ima02,g_ima021,g_azf03,g_smydesc,g_tlf_rowid
                                             g_ima02,g_ima021,g_azf03,g_smydesc #FUN-890125                                        
        WHEN 'F' FETCH FIRST    q202_cs INTO g_tlf_rowid,x1,x2,
                                           # g_ima02,g_ima021,g_azf03,g_smydesc,g_tlf_rowid
                                             g_ima02,g_ima021,g_azf03,g_smydesc #FUN-890125                                        
        WHEN 'L' FETCH LAST     q202_cs INTO g_tlf_rowid,x1,x2,
                                           # g_ima02,g_ima021,g_azf03,g_smydesc,g_tlf_rowid
                                             g_ima02,g_ima021,g_azf03,g_smydesc #FUN-890125                                         
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
          # FETCH ABSOLUTE g_jump q202_cs INTO g_tlf_rowid,x1,x2,g_ima02,g_ima021,g_azf03,g_smydesc,g_tlf_rowid
            FETCH ABSOLUTE g_jump q202_cs INTO g_tlf_rowid,x1,x2,g_ima02,g_ima021,g_azf03,g_smydesc #FUN-890125             
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tlf.tlf01,SQLCA.sqlcode,0)
       INITIALIZE g_tlf.* TO NULL  #TQC-6B0105
       LET g_tlf_rowid = NULL      #TQC-6B0105
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
    SELECT * INTO g_tlf.* FROM tlf_file WHERE rowid = g_tlf_rowid
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_tlf.tlf01,SQLCA.sqlcode,0) # FUN-660138
        CALL cl_err3("sel","tlf_file",g_tlf.tlf01,g_tlf.tlf020,SQLCA.sqlcode,"","",0) #FUN-660138
        RETURN
    END IF
 
    CALL q202_show()
END FUNCTION
 
FUNCTION q202_show()
DEFINE l_gem02a LIKE gem_file.gem02 #FUN-670051
DEFINE l_ecm45  LIKE ecm_file.ecm45 #FUN-8C0035
   DISPLAY BY NAME
      g_tlf.tlf01, g_tlf.tlf06,
      g_tlf.tlf901, g_tlf.tlf902, g_tlf.tlf903, g_tlf.tlf904,
      g_tlf.tlf905,g_smydesc, g_tlf.tlf906, g_tlf.tlf907, g_tlf.tlf62,
      g_tlf.tlf10, g_tlf.tlf11, g_tlf.tlf12, g_tlf.tlf60,
      g_tlf.tlf21, g_tlf.tlf15, g_tlf.tlf16,
      g_tlf.tlf19, g_tlf.tlf20,g_tlf.tlf64,g_tlf.tlf930,g_tlf.tlf99, g_tlf.tlf14, g_tlf.tlf13,  #no.A050 add tlf64  #FUN-670051 #CHI-A90024 add tlf20
      g_tlf.tlf21,g_tlf.tlf211,g_tlf.tlf212, g_tlf.tlf07, g_tlf.tlf09,
      g_tlf.tlf02, g_tlf.tlf020, g_tlf.tlf021, g_tlf.tlf022, g_tlf.tlf023,
      g_tlf.tlf025, g_tlf.tlf026, g_tlf.tlf027, g_tlf.tlf03, g_tlf.tlf030,
      g_tlf.tlf031, g_tlf.tlf032, g_tlf.tlf033, g_tlf.tlf035, g_tlf.tlf036,
      g_tlf.tlf037,g_ima02,g_ima021,g_azf03,g_tlf.tlf05,g_tlf.tlf08     #FUN-8C0035 add tlf05,tlf08
   CALL s_command(g_tlf.tlf13) RETURNING g_chr,g_msg
   DISPLAY g_msg TO tlf13_desc
   #FUN-670051...............begin
   SELECT gem02 INTO l_gem02a FROM gem_file where gem01=g_tlf.tlf930 #FUN-670051
   IF SQLCA.sqlcode THEN LET l_gem02a=NULL END IF
   DISPLAY l_gem02a TO FORMONLY.gem02a
   #FUN-670051...............end
   #FUN-8C0035--BEGIN--
   SELECT ecm45 INTO l_ecm45 FROM ecm_file WHERE ecm04=g_tlf.tlf05
   DISPLAY l_ecm45 TO FORMONLY.ecm45
   #FUN-8C0035--END--
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#str FUN-840144 add
FUNCTION q202_q_tlfc()
 
  IF g_tlf_rowid IS NULL THEN
     CALL cl_err('',-400,0) RETURN
  END IF
 
  OPEN WINDOW asmq202_w1 AT 06,11 WITH FORM "asm/42f/asmq202c"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
  CALL cl_ui_locale("asmq202c")
 
  CALL q202_b_fill()            #單身
 
   WHILE TRUE
      CALL q202_bp("G")
      CASE g_action_choice
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tlfc),'','')
            END IF
      END CASE
   END WHILE
 
   CLOSE WINDOW asmq202_w1
 
END FUNCTION
 
FUNCTION q202_bp(p_ud)
   DEFINE p_ud     LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_tlfc TO s_tlfc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         #LET g_action_choice="detail"   #NO.TQC-930125
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q202_b_fill()
 
   LET g_sql = "SELECT tlfctype,tlfccost,tlfc21 ",
               "  FROM tlfc_file ",
               " WHERE tlfc01 ='",g_tlf.tlf01,"'",
               "   AND tlfc02 = ",g_tlf.tlf02,
               "   AND tlfc03 = ",g_tlf.tlf03,
               "   AND tlfc06 ='",g_tlf.tlf06,"'",
               "   AND tlfc13 ='",g_tlf.tlf13,"'",
               "   AND tlfc902='",g_tlf.tlf902,"'",
               "   AND tlfc903='",g_tlf.tlf903,"'",
               "   AND tlfc904='",g_tlf.tlf904,"'",
               "   AND tlfc905='",g_tlf.tlf905,"'",
               "   AND tlfc906='",g_tlf.tlf906,"'",
               "   AND tlfc907= ",g_tlf.tlf907,
               " ORDER BY tlfctype,tlfccost"
   PREPARE q202_pre3 FROM g_sql      #預備一下
   DECLARE tlfc_cs CURSOR FOR q202_pre3
 
   CALL g_tlfc.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH tlfc_cs INTO g_tlfc[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_tlfc.deleteElement(g_cnt)
   LET g_rec_b=g_cnt -1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
  #DISPLAY 1 TO FORMONLY.cnt      #TQC-960120 mark
   LET g_cnt = 0
 
END FUNCTION
#end FUN-840144 add
#Patch....NO.TQC-610037 <001> #
