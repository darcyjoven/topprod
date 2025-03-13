# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimq233.4gl
# Descriptions...: 多單位料件ＢＩＮ卡查詢
# Date & Author..: 05/04/13 By ice 參考aimq231.4gl的寫法              
# Modify.........: No.FUN-570246 05/07/28 By Elva 起始日期調整成輸入年度期別查詢
# Modify.........: No.MOD-580335 05/09/05 By kim 組外部呼叫SQL錯誤
# Modify.........: No.MOD-590242 05/09/016 By pengu  在select tlff_file資料時須加UNIQUE，防止select出重複資料
# Modify.........: No.TQC-5C0080 05/12/21 By 取tlf_file時應是所有參考年度月份以後的資料，而不是只有該月的資料
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-730117 07/04/02 By Judy 匯出Excel的值有誤
# Modify.........: No.TQC-790058 07/09/10 By judy 匯出Excel多一空白行
# Modify.........: No.TQC-7A0112 07/10/31 By Judy msv需求，用到rowid的地方加入key值字段
# Modify.........: No.MOD-7C0024 07/12/05 By Pengu select單身資料時SQL的unique語法有問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0025 09/10/13 By Pengu 針對品明規格做查詢時，筆數會不對
# Modify.........: No.FUN-9B0028 09/11/04 By wujie 5.2SQL转标准语法
# Modify.........: No:CHI-A80048 10/09/17 By Summer 來源碼、目前庫存欄位在查詢時，可開放查詢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    tm            RECORD
                  wc   LIKE type_file.chr1000,   # Head Where condition  #No.FUN-690026 VARCHAR(500)
                  wc2  LIKE type_file.chr1000    # Body Where condition  #No.FUN-690026 VARCHAR(500)
                  END RECORD,
    g_imgg        RECORD
                  imgg01 LIKE imgg_file.imgg01,  # 料件編號
                  imgg02 LIKE imgg_file.imgg02,  # 倉庫編號
                  imgg03 LIKE imgg_file.imgg03,  # 存放位置
                  imgg04 LIKE imgg_file.imgg04,  # 批號
                  imgg09 LIKE imgg_file.imgg09,  # 單位
                  imgg10 LIKE imgg_file.imgg10   # 目前庫存
                  END RECORD,
    g_cmd         LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
    g_bdate       LIKE type_file.dat,     #期初庫存  #No.FUN-690026 DATE
    #FUN-570246  --begin
    g_yy          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_mm          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_edate       LIKE type_file.dat,     #No.FUN-690026 DATE
    #FUN-570246  --end
    g_imkk09      LIKE imkk_file.imkk09,  # 期初庫存
    g_ima02       LIKE ima_file.ima02,    # 品名    
    g_ima021      LIKE ima_file.ima021,   # 品名    
    g_ima08       LIKE ima_file.ima08,    # 來源碼  
    g_pia30       LIKE pia_file.pia30,    # 初盤量  
    g_pia50       LIKE pia_file.pia50,    # 複盤量  
    g_year        LIKE imkk_file.imkk05,  # 年度    
    g_month       LIKE imkk_file.imkk06,  # 期別    
    g_tlff_1      DYNAMIC ARRAY OF RECORD
                  tlff06  LIKE tlff_file.tlff06,  #產生日期             
                  cond    LIKE type_file.chr20,   #異動狀況  #No.FUN-690026 VARCHAR(14)
                  tlff026 LIKE tlff_file.tlff026, #來源單號
                  tlff036 LIKE tlff_file.tlff036, #目的單號
                  tlff10  LIKE tlff_file.tlff10,  #異動數量
                  tlff11  LIKE tlff_file.tlff11,  #FROM單位
                  tlff024 LIKE tlff_file.tlff024  #FROM異動後數量
                  END RECORD,
    g_tlff13      LIKE tlff_file.tlff13,  #異動命令 
    g_tlff08      LIKE tlff_file.tlff08,  #TIME
    g_tlff12      LIKE tlff_file.tlff12,  #MOD-530179
    g_tlff03      LIKE tlff_file.tlff03,  #
    g_tlff031     LIKE tlff_file.tlff031, #
    g_tlff032     LIKE tlff_file.tlff032, #
    g_tlff033     LIKE tlff_file.tlff033, #
    g_tlff027     LIKE tlff_file.tlff027, #No.MOD-590242 add
    g_tlff037     LIKE tlff_file.tlff037, #No.MOD-7C0024 add
    g_tlff034     LIKE tlff_file.tlff034, #TO 異動後數量
    g_tlff035     LIKE tlff_file.tlff035, #TO 單位
    g_query_flag  LIKE type_file.num5,    #第一次進入程式時即進入Query之後進入next  #No.FUN-690026 SMALLINT
    g_sql         string,                 #No.FUN-580092 HCN
    g_argv1       LIKE imgg_file.imgg01,  #NO.MOD-490217
    g_argv2       LIKE imgg_file.imgg02,  #No.FUN-540025
    g_argv3       LIKE imgg_file.imgg03,  #No.FUN-540025
    g_argv4       LIKE imgg_file.imgg04,  #No.FUN-540025
    g_argv5       LIKE type_file.num5,    #No.FUN-570246 #No.FUN-690026 SMALLINT
    g_argv6       LIKE type_file.num5,    #No.FUN-570246 #No.FUN-690026 SMALLINT
    i,m_cnt       LIKE type_file.num10,   #No.FUN-690026 INTEGER
    g_rec_b       LIKE type_file.num5     #單身筆數  #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col    LIKE type_file.num5      #No.FUN-690026 SMALLINT
DEFINE g_cnt          LIKE type_file.num10     #No.FUN-690026 INTEGER
DEFINE g_msg          LIKE type_file.chr1000   #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10     #No.FUN-690026 INTEGER
DEFINE g_curs_index   LIKE type_file.num10     #No.FUN-690026 INTEGER
DEFINE g_jump         LIKE type_file.num10     #No.FUN-690026 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5      #No.FUN-690026 SMALLINT
 
MAIN                                          
#     DEFINE   l_time LIKE type_file.chr8     #No.FUN-6A0074
   DEFINE      l_sl   LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                             #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)   #No.FUN-540025
   LET g_argv3=ARG_VAL(3)   #No.FUN-540025
   LET g_argv4=ARG_VAL(4)   #No.FUN-540025
   LET g_argv5=ARG_VAL(5)   #No.FUN-540025
   LET g_argv6=ARG_VAL(6)   #No.FUN-570246
 
   #LET g_msg=g_today USING 'yy/mm/dd'
   #LET g_msg[7,8]='01'
 
    #MOD-520048
   LET g_msg=MDY(g_today USING 'mm',
                 1,
                 g_today USING 'yy')
 
 # LET g_bdate=DATE(g_msg) 
   CALL s_yp(g_today) RETURNING g_yy,g_mm  #FUN-570246
   LET g_query_flag=1
   LET p_row = 3 LET p_col = 2
 
   OPEN WINDOW q233_w AT p_row,p_col
        WITH FORM "aim/42f/aimq233" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN   
       CALL q233_q()
    END IF
 
    CALL q233_menu()
    CLOSE WINDOW q233_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
FUNCTION q233_curs()
   DEFINE   l_cnt LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   CLEAR FORM 
   CALL g_tlff_1.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL		
   #FUN-570246  --begin
#  DISPLAY g_bdate TO bdate
   DISPLAY g_yy TO FORMONLY.yy
   DISPLAY g_mm TO FORMONLY.mm
   #FUN-570246  --end
   #No.FUN-540025  --begin
   IF g_argv1<>' ' THEN
      DISPLAY g_argv1 TO imgg01
      LET tm.wc=" imgg01='",g_argv1,"'"
      IF NOT cl_null(g_argv2) THEN
         LET tm.wc=tm.wc CLIPPED," AND imgg02='",g_argv2,"'"
         DISPLAY g_argv2 TO imgg02 #MOD-580335
      END IF
      IF NOT cl_null(g_argv3) THEN
        #LET tm.wc=tm.wc CLIPPED," AND imgg02='",g_argv3,"'"
         LET tm.wc=tm.wc CLIPPED," AND imgg03='",g_argv3,"'" #MOD-580335
         DISPLAY g_argv3 TO imgg03 #MOD-580335
      END IF
      IF NOT cl_null(g_argv4) THEN
        #LET tm.wc=tm.wc CLIPPED," AND imgg02='",g_argv4,"'"
         LET tm.wc=tm.wc CLIPPED," AND imgg04='",g_argv4,"'" #MOD-580335
         DISPLAY g_argv4 TO imgg04 #MOD-580335
      END IF
      #FUN-570246  --begin
  #   LET g_bdate=g_argv5
      LET g_yy = g_argv5
      LET g_mm = g_argv6
      DISPLAY g_yy TO FORMONLY.yy
      DISPLAY g_mm TO FORMONLY.mm
      #FUN-570246  --end
    ELSE
      INITIALIZE g_imgg.* TO NULL     #FUN-640213 add		
     #CONSTRUCT BY NAME tm.wc ON imgg01, ima02,ima021,imgg02, imgg03, imgg04,imgg09 #CHI-A80048 mark
      CONSTRUCT BY NAME tm.wc ON imgg01, ima02, ima021, ima08, imgg02, imgg03, imgg04, imgg09, imgg10 #CHI-A80048
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON ACTION CONTROLP
           CASE WHEN INFIELD(imgg01) #料件編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
         	  LET g_qryparam.form = "q_ima"
         	  CALL cl_create_qry() RETURNING g_qryparam.multiret
         	  DISPLAY g_qryparam.multiret TO imgg01
         	  NEXT FIELD imgg01
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
      
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
      #FUN-570246  --begin
  #   INPUT g_bdate WITHOUT DEFAULTS FROM bdate
      INPUT g_yy,g_mm WITHOUT DEFAULTS FROM yy,mm
  #      AFTER FIELD bdate
  #        IF cl_null(g_bdate) THEN
  #           CALL cl_err('','aim-372',0)
  #           NEXT FIELD bdate
  #        END IF
  #        IF DAY(g_bdate)!=1 THEN
  #           CALL cl_err('','aim-394',0)
  #           NEXT FIELD bdate
  #        END IF
         AFTER FIELD yy
            IF g_yy IS NULL OR g_yy < 999 OR g_yy>2100
               THEN NEXT FIELD yy
            END IF
        
         AFTER FIELD mm
#No.TQC-720032 -- begin --
            IF NOT cl_null(g_mm) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                  WHERE azm01 = g_yy
               IF g_azm.azm02 = 1 THEN
                  IF g_mm > 12 OR g_mm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD mm
                  END IF
               ELSE
                  IF g_mm > 13 OR g_mm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD mm
                  END IF
               END IF
            END IF
#            IF g_mm IS NULL OR g_mm <1 OR g_mm>13  
#               THEN NEXT FIELD mm
#            END IF
#No.TQC-720032 -- end --
 
         AFTER INPUT
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              RETURN       
           END IF
           IF cl_null(g_yy) THEN
              CALL cl_err('','aim-372',0)
              NEXT FIELD yy   
           END IF
           IF cl_null(g_mm) THEN
              CALL cl_err('','aim-372',0)
              NEXT FIELD mm   
           END IF
   #FUN-570246  --end
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
          ON ACTION about     
             CALL cl_about() 
 
          ON ACTION help    
             CALL cl_show_help()
 
          ON ACTION controlg   
             CALL cl_cmdask() 
 
      END INPUT
   END IF
   #No.FUN-540025  --end   
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   #FUN-570246  --begin
  # CALL s_yp(g_bdate) RETURNING g_year, g_month
  # LET g_month = g_month - 1
  # IF g_month = 0 THEN LET g_month = 12 LET g_year = g_year - 1 END IF
  # LET tm.wc2 = " tlff06 >= '",g_bdate,"'"
    CALL s_lsperiod(g_yy,g_mm) RETURNING g_year,g_month
    CALL s_azn01(g_yy,g_mm) RETURNING g_bdate,g_edate
   #LET tm.wc2 = " tlff06 BETWEEN '",g_bdate,"' AND '",g_edate,"'"   #No.TQC-5C0080 mark
    LET tm.wc2 = " tlff06 >= '",g_bdate,"'"      #No.TQC-5C0080 add
   #FUN-570246  --end
	MESSAGE ' WAIT ' 
#   LET g_sql= " SELECT ima02,ima021,ima08,imkk09 ", #TQC-7A0112
    LET g_sql= " SELECT imgg01,imgg02,imgg03,imgg04,imgg09,ima02,ima021,ima08,imkk09 ", #TQC-7A0112
#No.FUN-9B0028 --begin
              #" FROM imgg_file LEFT OUTER JOIN ima_file ON ima01 = imgg01", #CHI-A80048 mark
               " FROM ima_file ,imgg_file ", #CHI-A80048 
               "                LEFT OUTER JOIN imkk_file ON ",
               "      imkk01 = imgg01 ",
               "  AND imkk02 = imgg02 ",
               "  AND imkk03 = imgg03 ",
               "  AND imkk04 = imgg04 ",
               "  AND imkk10 = imgg09 ",
               "  AND imkk05 ='",g_year,"'",
               "  AND imkk06 ='",g_month,"'",
               " WHERE ",tm.wc CLIPPED,
               "  AND ima01 = imgg01 ", #CHI-A80048 add
#               " FROM imgg_file,ima_file, imkk_file ",
#               " WHERE ima_file.ima01(+) = imgg01 ",
#               "  AND imkk_file.imkk01(+) = imgg01 ",
#               "  AND imkk_file.imkk02(+) = imgg02 ",
#               "  AND imkk_file.imkk03(+) = imgg03 ",
#               "  AND imkk_file.imkk04(+) = imgg04 ",
#               "  AND imkk_file.imkk10(+) = imgg09 ",
#               " AND imkk_file.imkk05(+) ='",g_year,"'",
#               " AND imkk_file.imkk06(+) ='",g_month,"'",
#               "    AND ",tm.wc CLIPPED,
#No.FUN-9B0028 --end
               "  ORDER BY imgg01"
    PREPARE q233_prepare FROM g_sql
    DECLARE q233_cs                         #SCROLL CURSOR
            SCROLL CURSOR FOR q233_prepare
 
    # 取合乎條件筆數
    #若使用組合鍵值, 則可以使用本方法去得到筆數值
    LET g_sql=" SELECT COUNT(*) FROM ima_file,imgg_file ",  #No.MOD-9A0025 modify
               " WHERE ",tm.wc CLIPPED,                     #No.MOD-9A0025 add ,
               "   AND ima01=imgg01 "                       #No.MOD-9A0025 add
    PREPARE q233_pp  FROM g_sql
    DECLARE q233_count   CURSOR FOR q233_pp
END FUNCTION
 
FUNCTION q233_b_askkey()
   CONSTRUCT tm.wc2 ON tlff06,tlff026,tlff036,tlff10,tlff11,tlff024 FROM
                    s_tlff[1].tlff06,s_tlff[1].tlff026,s_tlff[1].tlff036,
		    s_tlff[1].tlff10,s_tlff[1].tlff11,s_tlff[1].tlff024
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
 
 
FUNCTION q233_menu()
 
   WHILE TRUE
      CALL q233_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
               CALL q233_q()
            END IF
         WHEN "Transaction_detail" 
	    LET g_cmd = "asmq203 '",g_imgg.imgg01,"' '",g_bdate,"' '' '",g_imgg.imgg02,"' '",g_imgg.imgg03,"' '",g_imgg.imgg04,"' '",g_imgg.imgg09,"'"
	    CALL cl_cmdrun(g_cmd CLIPPED)
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
#             CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tlff),'','')   #TQC-730117
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tlff_1),'','') #TQC-730117
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q233_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL q233_curs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
    END IF
    OPEN q233_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q233_count
       FETCH q233_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL q233_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q233_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q233_cs INTO g_imgg.imgg01, #TQC-7A0112 add imgg01
                                             g_imgg.imgg02,g_imgg.imgg03, #TQC-7A0112 add imgg02,imgg03
                                             g_imgg.imgg04,g_imgg.imgg09,g_ima02, #TQC-7A0112 add imgg04,imgg09
                                             g_ima021,g_ima08,g_imkk09
        WHEN 'P' FETCH PREVIOUS q233_cs INTO g_imgg.imgg01, #TQC-7A0112 add imgg01
                                             g_imgg.imgg02,g_imgg.imgg03, #TQC-7A0112 add imgg02,imgg03
                                             g_imgg.imgg04,g_imgg.imgg09,g_ima02, #TQC-7A0112 add imgg04,imgg09
                                             g_ima021,g_ima08,g_imkk09
        WHEN 'F' FETCH FIRST    q233_cs INTO g_imgg.imgg01, #TQC-7A0112 add imgg01
                                             g_imgg.imgg02,g_imgg.imgg03, #TQC-7A0112 add imgg02,imgg03
                                             g_imgg.imgg04,g_imgg.imgg09,g_ima02, #TQC-7A0112 add imgg04,imgg09
                                             g_ima021,g_ima08,g_imkk09
        WHEN 'L' FETCH LAST     q233_cs INTO g_imgg.imgg01, #TQC-7A0112 add imgg01
                                             g_imgg.imgg02,g_imgg.imgg03, #TQC-7A0112 add imgg02,imgg03
                                             g_imgg.imgg04,g_imgg.imgg09,g_ima02, #TQC-7A0112 add imgg04,imgg09
                                             g_ima021,g_ima08,g_imkk09
        WHEN 'L' FETCH LAST     q233_cs INTO g_imgg.imgg01, #TQC-7A0112 add imgg01
                                             g_imgg.imgg02,g_imgg.imgg03, #TQC-7A0112 add imgg02,imgg03
                                             g_imgg.imgg04,g_imgg.imgg09,g_ima02, #TQC-7A0112 add imgg04,imgg09
                                             g_ima021,g_ima08,g_imkk09
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
            FETCH ABSOLUTE g_jump q233_cs INTO g_imgg.imgg01, #TQC-7A0112 add imgg01
                                               g_imgg.imgg02,g_imgg.imgg03, #TQC-7A0112 add imgg02,imgg03
                                               g_imgg.imgg04,g_imgg.imgg09,g_ima02, #TQC-7A0112 add imgg04,imgg09
                                               g_ima021,g_ima08,g_imkk09
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imgg.imgg01,SQLCA.sqlcode,0)
        INITIALIZE g_ima02   TO NULL  #TQC-6B0105
        INITIALIZE g_ima021  TO NULL  #TQC-6B0105
        INITIALIZE g_ima08   TO NULL  #TQC-6B0105
        INITIALIZE g_imkk09  TO NULL  #TQC-6B0105
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
 
	SELECT imgg01,imgg02,imgg03,imgg04,imgg09,imgg10
	  INTO g_imgg.* 
	  FROM imgg_file
      WHERE imgg01 = g_imgg.imgg01 AND imgg02 = g_imgg.imgg02 AND imgg03 = g_imgg.imgg03 AND imgg04 = g_imgg.imgg04 AND imgg09 = g_imgg.imgg09
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_imgg.imgg01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("sel","imgg_file",g_imgg.imgg01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
            RETURN
        END IF
 
    CALL q233_show()
END FUNCTION
 
FUNCTION q233_show()
   DISPLAY BY NAME g_imgg.*   # 顯示單頭值
   IF g_imkk09 IS NULL THEN 
      LET g_imkk09=0 
   END IF
   DISPLAY g_imkk09 TO imkk09
   CALL q233_b_fill() #單身
   DISPLAY g_ima02, g_ima021,g_ima08, g_yy,g_mm   #FUN-570246   
           TO ima02, ima021, ima08, yy,mm   #FUN-570246    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q233_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
          l_nouse   LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
   define l_cnt1    LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   LET l_sql =
        "SELECT UNIQUE tlff06,tlff07,tlff026,tlff036,tlff10,tlff11,tlff024,tlff03,",             #No.MOD-590242 add unique
        "       tlff031,tlff032,tlff033,tlff034,tlff035,tlff13,tlff08,tlff12,tlff02,tlff027,",   #No.MOD-590242 add tlff027
        "       tlff037 ",    #No.MOD-7C0024 add tlff037
        " FROM  tlff_file",
        " WHERE tlff01 = '",g_imgg.imgg01,"'",
        "   AND (tlff907 <> 0)  AND tlff902 = '",g_imgg.imgg02 ,"'",
        "   AND tlff903 = '",g_imgg.imgg03,"'",
        "   AND tlff904 = '",g_imgg.imgg04,"'",
        "   AND tlff11 = '",g_imgg.imgg09,"'",
        "  AND ",tm.wc2 CLIPPED,
        " ORDER BY tlff06,tlff08"
    PREPARE q233_pb FROM l_sql
    DECLARE q233_bcs                       #BODY CURSOR
        CURSOR FOR q233_pb
 
    CALL g_tlff_1.clear()
    LET g_rec_b=0
    LET m_cnt = 1
    select count(*) into l_cnt1 from tlff_file
      WHERE tlff01 =g_imgg.imgg01 and tlff902=g_imgg.imgg02
      and tlff903=g_imgg.imgg03 and tlff904=g_imgg.imgg04
      and (tlff907 <> 0) and tlff11=g_imgg.imgg09
    #  and tm.wc2  
    display "cnt:"||l_cnt1
    FOREACH q233_bcs INTO g_tlff_1[m_cnt].*,g_tlff03,
                          g_tlff031,g_tlff032,g_tlff033,g_tlff034,g_tlff035,g_tlff13,
                          g_tlff08, g_tlff12,g_tlff027, #No.MOD-590242 add g_tlff027
                          g_tlff037                     #No.MOD-7C0024 add tlff037
        IF m_cnt=1 THEN
            LET g_rec_b=SQLCA.SQLERRD[3]
        END IF
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_tlff13 = 'aimp880' THEN
           SELECT pia30,pia50 INTO g_pia30,g_pia50 FROM pia_file
             WHERE pia02=g_imgg.imgg01 AND pia03=g_imgg.imgg02
               AND pia04=g_imgg.imgg03 AND pia05=g_imgg.imgg04
               AND (pia01=g_tlff_1[m_cnt].tlff026 OR pia01=g_tlff_1[m_cnt].tlff036)
           IF NOT cl_null(g_pia50) THEN LET g_pia30 = g_pia50 END IF
           IF g_tlff_1[m_cnt].tlff036 ='Physical'
              THEN LET g_tlff_1[m_cnt].tlff036=g_pia30
              ELSE LET g_tlff_1[m_cnt].tlff026=g_pia30
           END IF
        END IF
        IF g_tlff031 = g_imgg.imgg02 AND g_tlff032 = g_imgg.imgg03 AND
           g_tlff033 = g_imgg.imgg04 AND g_tlff13 != 'apmt1071'
           THEN LET g_tlff_1[m_cnt].tlff024 = g_tlff034
           ELSE LET g_tlff_1[m_cnt].tlff10 = g_tlff_1[m_cnt].tlff10 * -1
                IF (g_tlff13='aimt324' OR g_tlff13='aimt720')
                    THEN LET g_tlff12=1
                END IF
        END IF
        IF g_tlff_1[m_cnt].tlff10 IS NULL THEN LET g_tlff_1[m_cnt].tlff10=0 END IF
        IF g_tlff12 IS NULL THEN LET g_tlff12=0 END IF
         IF g_imkk09 IS NULL THEN LET g_imkk09=0 END IF  #MOD-530724
        LET g_imkk09 = g_imkk09 + g_tlff_1[m_cnt].tlff10 #* g_tlff12  By carrier
        LET g_tlff_1[m_cnt].tlff024 = g_imkk09
        CALL s_command (g_tlff13) RETURNING l_nouse,g_tlff_1[m_cnt].cond
        IF cl_null(g_tlff_1[m_cnt].cond)
           THEN LET g_tlff_1[m_cnt].cond=g_tlff13 END IF
        LET m_cnt = m_cnt + 1
#       IF m_cnt > g_tlff_arrno THEN
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
    CALL g_tlff_1.deleteElement(m_cnt)  #TQC-790058
    LET g_rec_b = m_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q233_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_tlff_1 TO s_tlff.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #No.MOD-480045
 
    # BEFORE DISPLAY
    #    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL cl_show_fld_cont()                           #No.FUN-560228
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q233_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q233_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL q233_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q233_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL q233_fetch('L')
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION Transaction_detail
         LET g_action_choice = 'Transaction_detail'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
       #No.MOD-530688  --begin                                                   
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
       #No.MOD-530688  --end          
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
