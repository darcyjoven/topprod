# Prog. Version..: '5.30.03-12.09.18(00005)'     #
#
# Pattern name...: ghrq010.4gl
# Descriptions...: 設備備件ＢＩＮ卡查詢(依單據日期)
# Date & Author..: 2013/06/08 by hourf
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
# DEFINE hrbu01           LIKE hrbu_file.hrbu01
DEFINE 
    g_hrcr             RECORD 
    hrcr02              LIKE hrcr_file.hrcr02,    
    hrcr03              LIKE hrcr_file.hrcr03,    
    hrcr04              LIKE hrcr_file.hrcr04,    
    hrcr05              LIKE hrcr_file.hrcr05,    
    hrbx02              LIKE hrbu_file.hrbu01
                       END RECORD,
    g_hrcr02_desc       LIKE hrat_file.hrat02,
    g_hrcr05_desc       LIKE hrat_file.hrat02,
    g_hrbu01_desc       LIKE hrbu_file.hrbu02,
    g_datacatch         VARCHAR(1),
    g_cott          LIKE type_file.num5,
    g_b_hrcr           DYNAMIC ARRAY OF RECORD
      b_hrcr02       LIKE hrcr_file.hrcr02,
      hrat02         LIKE hrat_file.hrat02,
      hrat04         LIKE hrat_file.hrat04,
      hrat04_name    VARCHAR(20),
      b_hrbu01       LIKE hrbu_file.hrbu01,
      hrbx02_name    VARCHAR(20),
      b2_hrbu01      LIKE hrbu_file.hrbu01,
      b_hrcr03       LIKE hrcr_file.hrcr03,
      hrcr06         LIKE hrcr_file.hrcr06,
      shougong       STRING,
      b_hrcr05       LIKE hrcr_file.hrcr05,
      b_hrcr05_desc  LIKE hrat_file.hrat02,
      b_hrcr04       LIKE hrcr_file.hrcr04,
      hrbx06         LIKE hrbx_file.hrbx06
                     END RECORD,
    g_b_hrcr_t           RECORD
      b_hrcr02       LIKE hrcr_file.hrcr02,
      hrat02         LIKE hrat_file.hrat02,
      hrat04         LIKE hrat_file.hrat04,
      hrat04_name    VARCHAR(20),
      b_hrbu01       LIKE hrbu_file.hrbu01,
      hrbx02_name    VARCHAR(20),
      b2_hrbu01      LIKE hrbu_file.hrbu01,
      b_hrcr03       LIKE hrcr_file.hrcr03,
      hrcr06         LIKE hrcr_file.hrcr06,
      shougong       STRING,
      b_hrcr05       LIKE hrcr_file.hrcr05,
      b_hrcr05_desc  LIKE hrat_file.hrat02,
      b_hrcr04       LIKE hrcr_file.hrcr04,
      hrbx06         LIKE hrbx_file.hrbx06
                     END RECORD,
     g_wc             STRING,	     # Body Where condition  #No.FUN-580092 HCN
     g_sql,g_sql1     STRING,         #No.FUN-580092 HCN
     i                LIKE type_file.num10,          #No.FUN-680072INTEGER
     g_rec_b          LIKE type_file.num5   		  #單身筆數        #No.FUN-680072 SMALLINT
DEFINE   p_row,p_col     LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680072 VARCHAR(72)
DEFINE   l_ac            LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680072 INTEGER
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0068
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
 
 
   LET p_row = 4 LET p_col = 2
 
   OPEN WINDOW q010_w AT p_row,p_col
        WITH FORM "ghr/42f/ghrq010" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   CALL cl_set_label_justify("q010_w","right")
   
   CALL q010_menu()  
 
   CLOSE WINDOW q010_w
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION q010_curs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680072 SMALLINT
 
   CLEAR FORM
   CALL g_b_hrcr.clear() 
   LET  g_datacatch='3'
   CALL cl_opmsg('q')
 
#   DISPLAY g_bdate TO bdate
#   CALL cl_set_head_visible("","YES")          #No.FUN-6B0029
 
   INITIALIZE g_hrcr.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON hrcr05,hrcr02,hrbx02,hrcr04,hrcr03
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(hrcr05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrcr"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcr05
                 NEXT FIELD hrcr05
              WHEN INFIELD(hrcr02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrcr"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcr02
                 NEXT FIELD hrcr02
              WHEN INFIELD(hrbx02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbu"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbx02
                 NEXT FIELD hrbx02
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrcruser', 'hrcrgrup') #FUN-980030
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
#    IF NOT cl_null(g_hrcr.hrbx02) THEN 
     IF g_wc LIKE '%hrbx02%'  THEN 
      LET g_datacatch='1'
       CALL cl_set_comp_entry("datacatch",FALSE)
       DISPLAY g_datacatch TO datacatch
    END IF 
   INPUT g_datacatch WITHOUT DEFAULTS FROM datacatch
      AFTER FIELD datacatch
                                                                                
      AFTER INPUT                                                               
        IF INT_FLAG THEN                                                        
           LET INT_FLAG = 0                                                     
           RETURN                                                               
        END IF                                                                  
 
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
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    MESSAGE ' WAIT ' ATTRIBUTE(REVERSE,BLINK)
 
    LET g_sql= " SELECT UNIQUE hrcr02,hrcr03,hrcr04,hrcr05,hrbx02 ",
               "   FROM hrcr_file,hrbx_file",
               "  WHERE hrbx04=hrcr05 ",
#               "    AND hrcrconf='Y'  ",
               "    AND  ", g_wc  CLIPPED
     IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
     END IF
    LET g_sql=g_sql CLIPPED, "  ORDER BY hrcr02"
    PREPARE q010_prepare FROM g_sql
    DECLARE q010_cs SCROLL CURSOR FOR q010_prepare
 
    # 取合乎條件筆數
    #若使用組合鍵值, 則可以使用本方法去得到筆數值
    LET g_sql= " SELECT UNIQUE hrcr02,hrcr03,hrcr04,hrcr05,hrbx02 ",
               "   FROM hrcr_file,hrbx_file",
               "  WHERE hrbx04=hrcr05 ",
               "    AND  ", g_wc  CLIPPED,
               "   INTO TEMP x"
    DROP TABLE x                                                            
    PREPARE q010_precount_x FROM g_sql                                      
    EXECUTE q010_precount_x                                                 
    LET g_sql = " SELECT COUNT(*) FROM x " 
    PREPARE q010_pp  FROM g_sql
    DECLARE q010_cnt   CURSOR FOR q010_pp
END FUNCTION
 
FUNCTION q010_menu()
    WHILE TRUE
      CALL q010_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q010_q()
            END IF
         WHEN "help" 
#           CALL SHOWHELP(1)           #No.TQC-770003
            CALL cl_show_help()        #No.TQC-770003
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcr),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q010_q()
    LET g_row_count = 0                                                        
    LET g_curs_index = 0                                                       
    CALL cl_navigator_setting( g_curs_index, g_row_count )                    
    MESSAGE ""      
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL q010_curs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
    END IF
    OPEN q010_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q010_cnt
       FETCH q010_cnt INTO g_row_count
    IF g_row_count=0 THEN
       CALL cl_err('',100,0)
       LET g_datacatch=''
       RETURN
    END IF
       DISPLAY g_row_count TO cnt  #ATTRIBUTE(MAGENTA)
#       CALL q010_fetch('F')                 # 讀出TEMP第一筆並顯示
        CALL q010_b_fill()
    END IF
    LET g_datacatch=''
    MESSAGE ''
END FUNCTION
 
#FUNCTION q010_fetch(p_flag)
#DEFINE
#    p_flag          LIKE type_file.chr1                 #處理方式        #No.FUN-680072 VARCHAR(1)
# 
#    CASE p_flag
#        WHEN 'N' FETCH NEXT     q010_cs INTO g_hrcr.hrcr02,g_hrcr.hrcr03,g_hrcr.hrcr04,g_hrcr.hrcr05,g_hrcr.hrbx02 
#        WHEN 'P' FETCH PREVIOUS q010_cs INTO g_hrcr.hrcr02,g_hrcr.hrcr03,g_hrcr.hrcr04,g_hrcr.hrcr05,g_hrcr.hrbx02
#        WHEN 'F' FETCH FIRST    q010_cs INTO g_hrcr.hrcr02,g_hrcr.hrcr03,g_hrcr.hrcr04,g_hrcr.hrcr05,g_hrcr.hrbx02
#        WHEN 'L' FETCH LAST     q010_cs INTO g_hrcr.hrcr02,g_hrcr.hrcr03,g_hrcr.hrcr04,g_hrcr.hrcr05,g_hrcr.hrbx02
#        WHEN '/'
#          IF (NOT mi_no_ask) THEN      
#             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
#             LET INT_FLAG=0
#             PROMPT g_msg CLIPPED,': ' FOR g_jump
#               ON IDLE g_idle_seconds                                           
#                  CALL cl_on_idle()                                             
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
#            END PROMPT
#            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
#          END IF
#          FETCH ABSOLUTE g_jump q010_cs INTO g_hrcr.hrcr02,g_hrcr.hrcr03,g_hrcr.hrcr04,g_hrcr.hrcr05,g_hrcr.hrbx02
#          LET mi_no_ask = FALSE     
#    END CASE
#    IF SQLCA.sqlcode THEN                                                       
#        CALL cl_err(g_hrcr.hrcr05,SQLCA.sqlcode,0)                                
#        INITIALIZE g_hrcr.* TO NULL  #TQC-6B0105
#        CLEAR FORM
#        CALL g_b_hrcr.clear()
#        RETURN
#    ELSE
#       CASE p_flag                                                              
#          WHEN 'F' LET g_curs_index = 1                                        
#          WHEN 'P' LET g_curs_index = g_curs_index - 1                        
#          WHEN 'N' LET g_curs_index = g_curs_index + 1                        
#          WHEN 'L' LET g_curs_index = g_row_count                             
#          WHEN '/' LET g_curs_index = g_jump                                 
#       END CASE                                                                 
#       CALL cl_navigator_setting( g_curs_index, g_row_count )
#    CALL q010_show()
#    END IF 
#END FUNCTION
 
FUNCTION q010_show()
   SELECT hrat02 INTO g_hrcr02_desc FROM hrat_file WHERE hrat01=g_hrcr.hrcr02   #考勤人员姓名  
   SELECT hrat02 INTO g_hrcr05_desc FROM hrat_file WHERE hrat01=g_hrcr.hrcr05   #操作人员姓名 
   SELECT hrbx02 INTO g_hrcr.hrbx02 FROM hrbx_file WHERE hrbx04=g_hrcr.hrcr05   #刷卡机型号
   SELECT hrbu02 INTO g_hrbu01_desc FROM hrbu_file WHERE hrbu01=g_hrcr.hrbx02   #刷卡机名称
#   DISPLAY g_hrcr.hrcr02,g_hrcr.hrcr03,g_hrcr.hrcr04,g_hrcr.hrcr05,g_hrcr.hrbx02,g_hrcr02_desc,g_hrcr05_desc,g_hrbu01_desc 
#        TO hrcr02,hrcr03,hrcr04,hrcr05,hrbx02,hrcr02_desc,hrcr05_desc,hrbu01_desc 
#   SELECT img10 INTO g_fia.img10 FROM img_file   #當前庫存
#    WHERE img01=g_fia.fjb03 AND img02=g_fia.fiw04
#      AND img03=g_fia.fiw05 AND img04=g_fia.fiw06
#   IF cl_null(g_fia.img10) THEN LET g_fia.img10=0 END IF
#   DISPLAY g_fia.img10 TO img10
 
   CALL q010_b_fill() #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q010_b_fill()              #BODY FILL UP
   DEFINE t         STRING
   DEFINE m         LIKE   hrcr_file.hrcr06
  # DEFINE hrcr06    LIKE   hrcr_file.hrcr06
   DEFINE l_sql     STRING       #No.FUN-680072CHAR(500)
   DEFINE l_sql2    STRING       #No.FUN-680072CHAR(500)
   DEFINE g_field   LIKE type_file.chr10 
   DEFINE g_row     LIKE type_file.num5 
   DEFINE g_hrcr06  LIKE hrcr_file.hrcr06  
   DEFINE g_hrcr02_t  LIKE hrcr_file.hrcr02  
    LET g_cnt = 1
#   LET l_sql = " SELECT  hrcr02 ",
#        "  FROM hrcr_file ",
#        " WHERE hrcr02 = '",g_hrcr.hrcr02,"'"
    LET l_sql= " SELECT UNIQUE hrcr02,hrbx02,hrcr05 ",
               "   FROM hrcr_file,hrbx_file",
               "  WHERE hrbx04=hrcr05 ",
               "    AND  ", g_wc  CLIPPED
    PREPARE q010_pb FROM l_sql
    DECLARE q010_bcs SCROLL CURSOR WITH HOLD FOR q010_pb
 
    LET g_rec_b=0
    CALL g_b_hrcr.clear()
#    FOREACH q010_bcs INTO g_b_hrcr[g_cnt].b_hrcr02 
     FOREACH q010_bcs INTO g_b_hrcr[g_cnt].b_hrcr02,g_b_hrcr[g_cnt].b_hrbu01,g_hrcr.hrcr05
       IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
    LET g_b_hrcr[g_cnt].shougong= 'N'
  IF g_datacatch='1'  THEN
        SELECT hrat02,hrat04 INTO g_b_hrcr[g_cnt].hrat02,g_b_hrcr[g_cnt].hrat04   #姓名，部门编号
          FROM hrat_file 
         WHERE hrat01=g_b_hrcr[g_cnt].b_hrcr02
        SELECT hrao02 INTO g_b_hrcr[g_cnt].hrat04_name                            #所属部门名称
          FROM hrao_file  
         WHERE hrao01=g_b_hrcr[g_cnt].hrat04
        SELECT hrbx04,hrbx03,hrbx06 INTO g_b_hrcr[g_cnt].b_hrcr05,g_b_hrcr[g_cnt].b_hrcr04,g_b_hrcr[g_cnt].hrbx06  
          FROM hrbx_file                                                          #操作人员工号，操作日期，备注
         WHERE hrbx04=g_hrcr.hrcr05
        SELECT hrat02 INTO g_b_hrcr[g_cnt].b_hrcr05_desc                          #操作人姓名
          FROM hrat_file 
         WHERE hrat01=g_b_hrcr[g_cnt].b_hrcr05
        SELECT hrbu01,hrbu02 INTO g_b_hrcr[g_cnt].b_hrbu01,g_b_hrcr[g_cnt].hrbx02_name 
          FROM hrbu_file                                                          #刷卡机型号，考勤机名称
         WHERE hrbu01=g_hrcr.hrbx02
        SELECT hrby04,hrby05,hrby06 INTO g_b_hrcr[g_cnt].b2_hrbu01,g_b_hrcr[g_cnt].b_hrcr03,g_b_hrcr[g_cnt].hrcr06
          FROM hrby_file                                                          #考勤卡号，刷卡日期，刷卡时间
         WHERE hrby03=g_hrcr.hrbx02
        LET g_cnt=g_cnt+1
  END IF
  IF g_datacatch='2' THEN
     LET g_row=g_cnt
     FOR g_cnt=g_row TO g_row+5                                  #根据刷卡时间显示所有数据 
      CASE
         WHEN(g_cnt=g_row)
             LET g_field = 'hrcr06'
         WHEN(g_cnt=g_row+1)
             LET g_field = 'hrcr07'
         WHEN(g_cnt=g_row+2)
             LET g_field = 'hrcr08'
         WHEN(g_cnt=g_row+3)
             LET g_field = 'hrcr09'
         WHEN(g_cnt=g_row+4)
             LET g_field = 'hrcr10'
         OTHERWISE
             LET g_field = 'hrcr11'
      END CASE
     IF g_field!='hrcr06' THEN
        LET g_b_hrcr[g_cnt].b_hrcr02=g_hrcr02_t
     END IF
        LET l_sql = "SELECT ",g_field,
                    "  FROM hrcr_file",
                    " WHERE hrcr02 = '",g_b_hrcr[g_cnt].b_hrcr02,"'",
                    "   AND hrcr05 = '",g_hrcr.hrcr05,"'"
        PREPARE q010_pre5 FROM l_sql
        EXECUTE q010_pre5 INTO m
    SELECT hrcr06 INTO g_hrcr06 FROM hrcr_file WHERE hrcr02=g_b_hrcr[g_cnt].b_hrcr02 AND hrcr05=g_hrcr.hrcr05 
    IF NOT cl_null(m) AND m!="00:00" AND g_field="hrcr06" THEN
        LET g_b_hrcr[g_cnt].shougong='Y'
        LET g_b_hrcr[g_cnt].b_hrbu01=''
        SELECT hrat02,hrat04 INTO g_b_hrcr[g_cnt].hrat02,g_b_hrcr[g_cnt].hrat04   #姓名，部门编号
          FROM hrat_file 
         WHERE hrat01=g_b_hrcr[g_cnt].b_hrcr02
        SELECT hrao02 INTO g_b_hrcr[g_cnt].hrat04_name                            #所属部门名称
          FROM hrao_file  
         WHERE hrao01=g_b_hrcr[g_cnt].hrat04
        SELECT hrcr05,hrcr04,hrcr13 INTO g_b_hrcr[g_cnt].b_hrcr05,g_b_hrcr[g_cnt].b_hrcr04,g_b_hrcr[g_cnt].hrbx06
          FROM hrcr_file                                                          #操作人员工号，操作日期，备注
         WHERE hrcr05=g_hrcr.hrcr05
           AND hrcr02=g_b_hrcr[g_cnt].b_hrcr02
        SELECT hrat02 INTO g_b_hrcr[g_cnt].b_hrcr05_desc                          #操作人姓名
          FROM hrat_file
         WHERE hrat01=g_hrcr.hrcr05 
        SELECT hrcr03 INTO  g_b_hrcr[g_cnt].b_hrcr03
          FROM hrcr_file                                                          #刷卡日期
         WHERE hrcr02=g_b_hrcr[g_cnt].b_hrcr02
           AND hrcr05=g_hrcr.hrcr05
          EXECUTE q010_pre5 INTO g_b_hrcr[g_cnt].hrcr06
      LET g_hrcr02_t=g_b_hrcr[g_cnt].b_hrcr02
     END IF 
       IF NOT cl_null(m) AND m!="00:00" AND g_field!="hrcr06" THEN
        LET g_b_hrcr[g_cnt].shougong='Y'
        LET g_b_hrcr[g_cnt].b_hrbu01=''
        SELECT hrat02,hrat04 INTO g_b_hrcr[g_cnt].hrat02,g_b_hrcr[g_cnt].hrat04   #姓名，部门编号
          FROM hrat_file 
         WHERE hrat01=g_b_hrcr[g_cnt].b_hrcr02
        SELECT hrao02 INTO g_b_hrcr[g_cnt].hrat04_name                            #所属部门名称
          FROM hrao_file  
         WHERE hrao01=g_b_hrcr[g_cnt].hrat04
        SELECT hrcr05,hrcr04,hrcr13 INTO g_b_hrcr[g_cnt].b_hrcr05,g_b_hrcr[g_cnt].b_hrcr04,g_b_hrcr[g_cnt].hrbx06
          FROM hrcr_file                                                          #操作人员工号，操作日期，备注
         WHERE hrcr05=g_hrcr.hrcr05
           AND hrcr02=g_b_hrcr[g_cnt].b_hrcr02
        SELECT hrat02 INTO g_b_hrcr[g_cnt].b_hrcr05_desc                          #操作人姓名
          FROM hrat_file
         WHERE hrat01=g_b_hrcr[g_cnt].b_hrcr05 
        SELECT hrcr03 INTO  g_b_hrcr[g_cnt].b_hrcr03
          FROM hrcr_file                                                          #刷卡日期
         WHERE hrcr02=g_b_hrcr[g_cnt].b_hrcr02
           AND hrcr05=g_hrcr.hrcr05
          EXECUTE q010_pre5 INTO g_b_hrcr[g_cnt].hrcr06
          LET g_hrcr02_t=g_b_hrcr[g_cnt].b_hrcr02
#          LET g_b_hrcr_t.*= g_b_hrcr[g_cnt].*
       END IF 
     IF cl_null(m) OR m="00:00"  THEN
        LET g_b_hrcr[g_cnt].b_hrcr02=''
        LET g_b_hrcr[g_cnt].b_hrbu01=''
        LET g_b_hrcr[g_cnt].shougong=''
#       LET g_cnt=g_cnt-1
        EXIT FOR
     END IF
     END FOR
   END IF
   IF g_datacatch='3' THEN

     SELECT hrat02,hrat04 INTO g_b_hrcr[g_cnt].hrat02,g_b_hrcr[g_cnt].hrat04   #姓名，部门编号
       FROM hrat_file 
      WHERE hrat01=g_b_hrcr[g_cnt].b_hrcr02
     SELECT hrao02 INTO g_b_hrcr[g_cnt].hrat04_name                            #所属部门名称
       FROM hrao_file  
      WHERE hrao01=g_b_hrcr[g_cnt].hrat04
     SELECT hrbx04,hrbx03,hrbx06 INTO g_b_hrcr[g_cnt].b_hrcr05,g_b_hrcr[g_cnt].b_hrcr04,g_b_hrcr[g_cnt].hrbx06  
       FROM hrbx_file                                                          #操作人员工号，操作日期，备注
      WHERE hrbx04=g_hrcr.hrcr05
     SELECT hrat02 INTO g_b_hrcr[g_cnt].b_hrcr05_desc                          #操作人姓名
       FROM hrat_file 
       WHERE hrat01=g_b_hrcr[g_cnt].b_hrcr05
     SELECT hrbu01,hrbu02 INTO g_b_hrcr[g_cnt].b_hrbu01,g_b_hrcr[g_cnt].hrbx02_name 
       FROM hrbu_file                                                          #刷卡机型号，考勤机名称
      WHERE hrbu01=g_hrcr.hrbx02
     SELECT hrby04,hrby05,hrby06 INTO g_b_hrcr[g_cnt].b2_hrbu01,g_b_hrcr[g_cnt].b_hrcr03,g_b_hrcr[g_cnt].hrcr06
       FROM hrby_file                                                          #考勤卡号，刷卡日期，刷卡时间
      WHERE hrby03=g_hrcr.hrbx02
      LET g_hrcr02_t=g_b_hrcr[g_cnt].b_hrcr02 
     LET g_cnt=g_cnt+1
     LET g_row=g_cnt
     FOR g_cnt=g_row TO g_row+5                                  #根据刷卡时间显示所有数据 
      CASE
         WHEN(g_cnt=g_row)
             LET g_field = 'hrcr06'
         WHEN(g_cnt=g_row+1)
             LET g_field = 'hrcr07'
         WHEN(g_cnt=g_row+2)
             LET g_field = 'hrcr08'
         WHEN(g_cnt=g_row+3)
             LET g_field = 'hrcr09'
         WHEN(g_cnt=g_row+4)
             LET g_field = 'hrcr10'
         OTHERWISE
             LET g_field = 'hrcr11'
      END CASE
        LET g_b_hrcr[g_cnt].b_hrcr02=g_hrcr02_t
        LET l_sql = "SELECT ",g_field,
                    "  FROM hrcr_file",
                    " WHERE hrcr02 = '",g_b_hrcr[g_cnt].b_hrcr02,"'",
                    "   AND hrcr05 = '",g_hrcr.hrcr05,"'"
#                    " AND  hrcrconf= 'Y' "
        PREPARE q010_pre6 FROM l_sql
        EXECUTE q010_pre6 INTO m
    SELECT hrcr06 INTO g_hrcr06 FROM hrcr_file WHERE hrcr02=g_b_hrcr[g_cnt].b_hrcr02 AND hrcr05= g_hrcr.hrcr05 
    IF cl_null(g_hrcr06) OR g_hrcr06="00:00" THEN
#       LET g_cnt=g_cnt-1 
        LET g_b_hrcr[g_cnt].b_hrcr02=''
        LET g_b_hrcr[g_cnt].b_hrbu01=''
        LET g_b_hrcr[g_cnt].shougong='' 
       EXIT FOR
    END IF 
    IF NOT cl_null(m) AND m!="00:00"   THEN
        LET g_b_hrcr[g_cnt].shougong='Y'
        LET g_b_hrcr[g_cnt].b_hrbu01=''
        SELECT hrat02,hrat04 INTO g_b_hrcr[g_cnt].hrat02,g_b_hrcr[g_cnt].hrat04   #姓名，部门编号
          FROM hrat_file 
         WHERE hrat01=g_b_hrcr[g_cnt].b_hrcr02
        SELECT hrao02 INTO g_b_hrcr[g_cnt].hrat04_name                            #所属部门名称
          FROM hrao_file  
         WHERE hrao01=g_b_hrcr[g_cnt].hrat04
        SELECT hrcr05,hrcr04,hrcr13 INTO g_b_hrcr[g_cnt].b_hrcr05,g_b_hrcr[g_cnt].b_hrcr04,g_b_hrcr[g_cnt].hrbx06
          FROM hrcr_file                                                          #操作人员工号，操作日期，备注
         WHERE hrcr05=g_hrcr.hrcr05
           AND hrcr02=g_b_hrcr[g_cnt].b_hrcr02
        SELECT hrat02 INTO g_b_hrcr[g_cnt].b_hrcr05_desc                          #操作人姓名
          FROM hrat_file
         WHERE hrat01=g_hrcr.hrcr05 
        SELECT hrcr03 INTO  g_b_hrcr[g_cnt].b_hrcr03
          FROM hrcr_file                                                          #刷卡日期
         WHERE hrcr02=g_b_hrcr[g_cnt].b_hrcr02
           AND hrcr05=g_hrcr.hrcr05
          EXECUTE q010_pre6 INTO g_b_hrcr[g_cnt].hrcr06
     IF cl_null(m) OR m="00:00"  THEN
        LET g_b_hrcr[g_cnt].b_hrcr02=''
        LET g_b_hrcr[g_cnt].b_hrbu01=''
        LET g_b_hrcr[g_cnt].shougong=''
#       LET g_cnt=g_cnt-1
        EXIT FOR
     END IF
     END IF
     IF cl_null(m) OR m="00:00"  THEN
        LET g_b_hrcr[g_cnt].b_hrcr02=''
        LET g_b_hrcr[g_cnt].b_hrbu01=''
        LET g_b_hrcr[g_cnt].shougong=''
        EXIT FOR
     END IF
     END FOR
    END IF
#     IF g_datacatch='3' AND m='00:00' THEN
#        LET g_b_hrcr[g_cnt].b_hrcr02=''
#        LET g_b_hrcr[g_cnt].b_hrbu01=''
#        LET g_b_hrcr[g_cnt].shougong='' 
#     END IF
#    LET g_cnt=g_cnt+1 
    END FOREACH
#    LET g_rec_b=g_cnt-1
#    DISPLAY g_rec_b TO FORMONLY.cn2
#    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_cnt-1 TO cnt 
END FUNCTION
 
FUNCTION q010_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_b_hrcr TO s_b_hrcr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #No.CHI-840065 
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
                                                                                
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
#      ON ACTION first 
#         CALL q010_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#         IF g_rec_b != 0 THEN                                                 
#            CALL fgl_set_arr_curr(1)
#         END IF                            
#           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#         EXIT DISPLAY
#      ON ACTION previous
#         CALL q010_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   
#         IF g_rec_b != 0 THEN                                                 
#            CALL fgl_set_arr_curr(1) 
#         END IF                            
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#         EXIT DISPLAY
#      ON ACTION jump 
#         CALL q010_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   
#         IF g_rec_b != 0 THEN                                                 
#            CALL fgl_set_arr_curr(1)  
#         END IF                            
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#         EXIT DISPLAY
#      ON ACTION next
#         CALL q010_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   
#         IF g_rec_b != 0 THEN                                                 
#            CALL fgl_set_arr_curr(1)  
##         END IF                            
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#         EXIT DISPLAY
#      ON ACTION last
#         CALL q010_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   
#         IF g_rec_b != 0 THEN                                                 
#            CALL fgl_set_arr_curr(1)  
#         END IF                            
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#         EXIT DISPLAY
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
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close                                                           
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
      ON IDLE g_idle_seconds                                                 
         CALL cl_on_idle()                                                   
         CONTINUE DISPLAY               
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION exporttoexcel
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
 
