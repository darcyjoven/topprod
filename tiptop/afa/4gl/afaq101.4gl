# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: afaq101.4gl
# Descriptions...: 固定資產財簽異動明細查詢
# Date & Author..: 97/03/25 By CONNIE
# Modify.........: No.MOD-480624 04/09/01 By Yuna 異動前與異動後資料,顯示資訊相反
# Modify.........: No.MOD-4A0123 04/10/08 By Kitty 外送收回狀態顯示錯誤
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0008 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.MOD-510118 05/02/03 By Kitty 異動前與異動後資料,顯示資訊相反(資本化->改良),程式中的中文都改掉
# Modify.........: No.FUN-510035 05/03/01 By Smapmin 將g_x資料轉移至ze_file
# Modify.........: No.MOD-530608 05/03/26 By Kitty 在序號欄位直接按ctrl+enter 會出現construct無此筆資料
# Modify.........: No.MOD-530844 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: NO.MOD-580222 05/08/23 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.TQC-630115 06/03/10 By Pengu 資產有異動卻查無易動記錄
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單 
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740026 07/04/11 By mike    會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770077 07/07/13 By wujie 匯出EXCEL匯出的值多一空白行 
# Modify.........: No.MOD-7C0089 07/12/17 By Smapmin 修改異動代號說明
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.MOD-960348 09/06/29 By mike FUNCTION q101_d(p_type,l_ac)的MENU段里,查詢視窗點選右上方[X]無反應                
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No:MOD-A50095 10/05/17 By Dido 異動前後資料給予問題
# Modify.........: No:MOD-AC0014 10/12/01 By Carrier 多部门分摊折旧时,fan_file过滤到fan05='2.多部门'的内容,仅显示3.分摊的部分
# Modify.........: No:MOD-AC0081 10/12/13 By Summer fap77 轉換說明有誤
# Modify.........: No:TQC-B20060 11/02/16 By destiny 增加顯示faj04,faj05,faj20的說明
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No:MOD-B70080 11/07/11 By Dido 接收變數個數調整 
# Modify.........: NO:MOD-BA0117 11/10/17 By johung 修改q101_pre_2/q101_pre_22的SQL欄位個數
# Modify.........: No.FUN-B90023 11/10/18 By xujing 取得aag02給予變數l_str8,l_str9…等要宣告為like aag_file.aag02
# Modify.........: No:FUN-BA0112 11/11/07 By Sakura 財簽二5.25與5.1程式比對不一致修改
# Modify.........: No:MOD-C50214 12/05/28 By suncx 狀態為折舊中的資產，查詢出其分錄底稿單號顯示在異動單號處
# Modify.........: No:MOD-CA0234 12/11/01 By Polly 資料為折舊時，fap542應給予財簽二金額
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE g_sw       LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
  DEFINE g_wc1,g_wc2    string               # WHERE CONDICTION  #No.FUN-580092 HCN
  DEFINE g_sql          string  #No.FUN-580092 HCN
  DEFINE g_faj  RECORD
                faj01   LIKE faj_file.faj01 ,
                faj02   LIKE faj_file.faj02 ,
                faj022  LIKE faj_file.faj022 ,
                faj04   LIKE faj_file.faj04 ,
                faj05   LIKE faj_file.faj05 ,
                faj07   LIKE faj_file.faj07 ,
                faj06   LIKE faj_file.faj06 ,
                faj19   LIKE faj_file.faj19 ,
                faj20   LIKE faj_file.faj20 ,
                faj21   LIKE faj_file.faj21 ,
                faj22   LIKE faj_file.faj22 ,
                faj25   LIKE faj_file.faj25 ,
                faj26   LIKE faj_file.faj26 ,
                faj13   LIKE faj_file.faj13 ,
                faj14   LIKE faj_file.faj14 ,
                faj262  LIKE faj_file.faj262,   #No:FUN-AB0088
                faj142  LIKE faj_file.faj142    #No:FUN-AB0088
                END RECORD
  DEFINE g_sr_tmp DYNAMIC ARRAY OF RECORD
                #fap03           LIKE type_file.chr6            #No.FUN-680070 VARCHAR(06)   #MOD-7C0089
                fap03           LIKE type_file.chr20            #No.FUN-680070 VARCHAR(06)   #MOD-7C0089   
                END RECORD
  DEFINE g_sr DYNAMIC ARRAY OF RECORD
                tdate           LIKE fap_file.fap04 ,
                #fap03           LIKE type_file.chr6,            #No.FUN-680070 VARCHAR(06)  #MOD-7C0089
                fap03           LIKE type_file.chr20,           #No.FUN-680070 VARCHAR(06)   #MOD-7C0089
                fap05           LIKE type_file.chr6,            #No.FUN-680070 VARCHAR(06)
                fap052          LIKE type_file.chr6,   #No:FUN-AB0088
                fap50           LIKE fap_file.fap50,
                fap501          LIKE fap_file.fap501,
                fap66           LIKE fap_file.fap66,
                fap54           LIKE fap_file.fap54,
                fap542          LIKE fap_file.fap542,   #No:FUN-AB0088
                fap77           LIKE type_file.chr6,            #No.FUN-680070 VARCHAR(06)
                fap772          LIKE type_file.chr6,   #No:FUN-AB0088
                desc            LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(60)
                desc2           LIKE type_file.chr1000   #No:FUN-AB0088
              END RECORD,
              tdate    LIKE type_file.dat          #No.FUN-680070 DATE
  DEFINE g_argv1 LIKE faj_file.faj01,
         l_za05         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(40)
 
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE   g_rec_b         LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_bookno1       LIKE aza_file.aza81        #No.FUN-740026
DEFINE   g_bookno2       LIKE aza_file.aza82        #No.FUN-740026 
DEFINE   g_flag          LIKE type_file.chr1        #No.FUN-740026 
 
 
MAIN
    OPTIONS
        COMMENT LINE  FIRST + 1,
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW q101_w WITH FORM "afa/42f/afaq101"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   #-----No:FUN-AB0088-----
    IF g_faa.faa31 = 'Y' THEN
       CALL cl_set_comp_visible("faj262,faj142,fap052,fap542,fap772,desc2",TRUE)
    ELSE
       CALL cl_set_comp_visible("faj262,faj142,fap052,fap542,fap772,desc2",FALSE)
    END IF
    #-----No:FUN-AB0088 END-----
 
   CALL q101_q()   #先查詢
   CALL q101_menu()
   CLOSE WINDOW q101_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q101_cs()
   DEFINE   l_cnt LIKE type_file.num5   ,       #No.FUN-680070 SMALLINT
            l_msg LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(80)
 
           CLEAR FORM #清除畫面
   CALL g_sr.clear()
           CALL cl_opmsg('q')
           INITIALIZE g_faj.* TO NULL
           LET tdate = TODAY
            CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_faj.* TO NULL    #No.FUN-750051
            CONSTRUCT BY NAME g_wc1 ON faj01,faj02,faj022
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
              BEFORE FIELD faj01
               IF NOT cl_null(g_argv1) THEN
                  DISPLAY g_argv1 TO faj01
               END IF
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
            #No.MOD-530608
           #IF SQLCA.SQLCODE THEN
           #  CALL cl_err('construct',SQLCA.SQLCODE,1)
           #  RETURN
           #END IF
 
           IF INT_FLAG THEN RETURN END IF
 
           #====>資料權限的檢查
           #Begin:FUN-980030
           #           IF g_priv2='4' THEN                           #只能使用自己的資料
           #               LET g_wc1 = g_wc1 clipped," AND fajuser = '",g_user,"'"
           #           END IF
           #           IF g_priv3='4' THEN                           #只能使用相同群的資料
           #              LET g_wc1 = g_wc1 clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
           #           END IF
 
           #           IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
           #              LET g_wc1 = g_wc1 clipped," AND fajgrup IN ",cl_chk_tgrup_list()
           #           END IF
           LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
           #End:FUN-980030
 
           INPUT tdate
              WITHOUT DEFAULTS
            FROM fap04
             AFTER FIELD fap04
               IF cl_null(tdate) THEN
                 CALL cl_err('','aim-372',0)
                 NEXT FIELD fap04
               END IF
            #-----TQC-860018---------
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
            
            ON ACTION about         
               CALL cl_about()      
            
            ON ACTION help          
               CALL cl_show_help()  
            
            ON ACTION controlg 
                CALL cl_cmdask()
            #-----END TQC-860018-----
          END INPUT
          IF INT_FLAG THEN RETURN       END IF
   LET g_sql="SELECT faj01,faj02,faj022,faj04,faj05,faj07,faj06,faj19,",
             " faj20,faj21,faj22,faj25,faj26,faj13,faj14,faj262,faj142 ",    #No:FUN-AB0088
             " FROM faj_file ",
             " WHERE ",g_wc1 ,
             " ORDER BY faj01,faj02"
   PREPARE q101_prepare FROM g_sql
   DECLARE q101_cs SCROLL CURSOR FOR q101_prepare
 
   LET g_sql=" SELECT count(*) FROM faj_file ",
             " WHERE ",g_wc1 CLIPPED
   PREPARE q101_pp  FROM g_sql
   DECLARE q101_count CURSOR FOR q101_pp
END FUNCTION
 
FUNCTION q101_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(80)
 
 
 
   WHILE TRUE
      CALL q101_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q101_q()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "明細查詢"
         WHEN "query_details"
            IF g_sw = "Y" THEN
               CALL q101_b()
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sr),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q101_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    DISPLAY '   ' TO FORMONLY.cnt
    LET INT_FLAG = 0
    CALL q101_cs()
    IF INT_FLAG THEN  RETURN END IF
    MESSAGE "Waiting!"
    OPEN q101_cs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('q101_q:',SQLCA.sqlcode,0)
    ELSE
       OPEN q101_count
       FETCH q101_count INTO g_row_count #CKP
       DISPLAY g_row_count TO FORMONLY.cnt #CKP
       CALL q101_fetch('F')                #讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q101_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q101_cs INTO g_faj.*
        WHEN 'P' FETCH PREVIOUS q101_cs INTO g_faj.*
        WHEN 'F' FETCH FIRST    q101_cs INTO g_faj.*
        WHEN 'L' FETCH LAST     q101_cs INTO g_faj.*
        WHEN '/'
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso q101_cs INTO g_faj.*
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err('Fetch:',SQLCA.sqlcode,0)
        INITIALIZE g_faj.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    CALL q101_show()
END FUNCTION
 
FUNCTION q101_show()
DEFINE l_gen02 LIKE gen_file.gen02
DEFINE l_gem02 LIKE gem_file.gem02   #TQC-B20060 
DEFINE l_fab02 LIKE fab_file.fab02   #TQC-B20060 
DEFINE l_fac02 LIKE fac_file.fac02   #TQC-B20060 

   SELECT gen02 INTO l_gen02 FROM gen_file
    WHERE gen01 = g_faj.faj19
   
   #TQC-B20060--begin
   SELECT gem02 INTO l_gem02 FROM gem_file
    WHERE gem01=g_faj.faj20
   SELECT fab02 INTO l_fab02 FROM fab_file
    WHERE fab01=g_faj.faj04
   SELECT fac02 INTO l_fac02 FROM fac_file
    WHERE fac01=g_faj.faj05  
      
   DISPLAY l_gem02 TO gem02 
   DISPLAY l_fab02 TO fab02  
   DISPLAY l_fac02 TO fac02  
   #TQC-B20060--end 
   IF STATUS THEN
      LET l_gen02 = ''
   END IF
   #No.FUN-9A0024--begin   
   #DISPLAY BY NAME g_faj.*  
   DISPLAY BY NAME g_faj.faj01,g_faj.faj02,g_faj.faj022,g_faj.faj04,g_faj.faj05,
                   g_faj.faj07,g_faj.faj06,g_faj.faj19,g_faj.faj20,g_faj.faj21,
                   g_faj.faj22,g_faj.faj25,g_faj.faj26,g_faj.faj13,g_faj.faj14
   #No.FUN-9A0024--end 
   DISPLAY l_gen02 TO gen02
 
   MESSAGE ' WAIT '
   CALL q101_b_fill() #單身
   MESSAGE ''
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q101_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
   DEFINE i,j,k     LIKE type_file.num5         #No.FUN-680070 smallint
   DEFINE l_str1    LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(120)
   DEFINE l_str2    LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(120)
   DEFINE l_fan03   LIKE fan_file.fan03
   DEFINE l_fan04   LIKE fan_file.fan04
   DEFINE l_fbn03   LIKE fbn_file.fbn03   #No:FUN-AB0088
   DEFINE l_fbn04   LIKE fbn_file.fbn04   #No:FUN-AB0088
   DEFINE l_fap15   LIKE fap_file.fap15
   DEFINE l_fap16   LIKE fap_file.fap16
   DEFINE l_fap17   LIKE fap_file.fap17
   DEFINE l_fap18   LIKE fap_file.fap18
   DEFINE l_fap19   LIKE fap_file.fap19
   DEFINE l_fap61   LIKE fap_file.fap61
   DEFINE l_fap62   LIKE fap_file.fap62
   DEFINE l_fap63   LIKE fap_file.fap63
   DEFINE l_fap64   LIKE fap_file.fap64
   DEFINE l_fap65   LIKE fap_file.fap65
   DEFINE l_fap66   LIKE fap_file.fap66
   DEFINE l_fap02   LIKE fap_file.fap02
   DEFINE l_fap021  LIKE fap_file.fap021
   DEFINE l_fap75   LIKE fap_file.fap75
   DEFINE l_fap76   LIKE fap_file.fap76
   DEFINE l_fap661  LIKE fap_file.fap661
   DEFINE l_fap52   LIKE fap_file.fap52
   DEFINE l_fap55   LIKE fap_file.fap55
   DEFINE l_fap67   LIKE fap_file.fap67
   DEFINE l_fap56   LIKE fap_file.fap56
   DEFINE l_fap57   LIKE fap_file.fap57
   DEFINE l_faz12   LIKE faz_file.faz12
   DEFINE l_fbb12   LIKE fbb_file.fbb12
   DEFINE l_date    LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE l_sw      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE l_zemsg   LIKE ze_file.ze03
   DEFINE l_zemsg2   LIKE ze_file.ze03
   DEFINE l_zemsg3  LIKE ze_file.ze03   #MOD-7C0089
   DEFINE l_fbl06   LIKE fbl_file.fbl06 #MOD-7C0089
   #-----No:FUN-AB0088-----
   DEFINE l_fap152  LIKE fap_file.fap152
   DEFINE l_fap162  LIKE fap_file.fap162
   DEFINE l_fap612  LIKE fap_file.fap612
   DEFINE l_fap622  LIKE fap_file.fap622
   DEFINE l_fap6612 LIKE fap_file.fap6612
   DEFINE l_fap522  LIKE fap_file.fap522
   DEFINE l_fap552  LIKE fap_file.fap552
   DEFINE l_fap672  LIKE fap_file.fap672
   DEFINE l_fap562  LIKE fap_file.fap562
   DEFINE l_fap572  LIKE fap_file.fap572
   #-----No:FUN-AB0088 END-----

 
#No.FUN-680070  -- begin --
#    CREATE TEMP TABLE tmp_file
#      ( sw              VARCHAR(1),
#        tdate           DATE,
#        fap03           VARCHAR(6),
#        fap05           VARCHAR(6),
#        fap50           VARCHAR(16),      #------------異動值-------  #No.TQC-630115 modify
#        fap501          SMALLINT,                                                     
#        fap66           SMALLINT,      #數量
#        fap54           DECIMAL(20,6), #調整成本   #No.FUN-4C0008
#        fap77           VARCHAR(6),       #狀態
#        descc           VARCHAR(60))
    CREATE TEMP TABLE tmp_file
      ( sw              LIKE type_file.chr1,  
        tdate           LIKE type_file.dat,   
        fap03           LIKE type_file.chr20, 
        fap05           LIKE type_file.chr20, 
        fap052          LIKE type_file.chr20,    #No:FUN-AB0088
        fap50           LIKE type_file.chr20, 
        fap501          LIKE type_file.num5,  
        fap66           LIKE type_file.num5,  
        fap54           LIKE type_file.num20_6,
        fap542          LIKE type_file.num20_6,   #No:FUN-AB0088
        fap77           LIKE type_file.chr20, 
        fap772          LIKE type_file.chr20,    #No:FUN-AB0088
        descc           LIKE type_file.chr1000,
        descc2          LIKE type_file.chr1000)   #No:FUN-AB0088
#No.FUN-680070  -- end --
   LET g_sw = "N"
   LET l_sql = "SELECT '1',fap04,fap03,fap05,fap052,",                   #No:FUN-AB0088
               " fap50,fap501,fap66,fap54,fap542,fap77,fap772,'','', ",  #No:FUN-AB0088 #MOD-B70080 add fap542
               " fap15,fap16,fap17,fap18,fap19,fap61,fap62,fap63,fap64,fap65,",
               " fap66,fap02,fap021,fap75,fap76,fap661,fap52,fap55,",
               " fap67,fap56,fap57",
               " fap152,fap162,fap612,fap622,fap6612,fap522,fap552,fap672,fap562,fap572",  #No:FUN-AB0088
               "  FROM fap_file ",
               " WHERE fap02 = '",g_faj.faj02,"'" ,
               "   AND fap021= '",g_faj.faj022,"'",
               "   AND fap04 >= '",tdate,"'"
   PREPARE q101_pre_1 FROM l_sql
   DECLARE q101_b_1 CURSOR FOR q101_pre_1
   FOREACH q101_b_1 INTO l_sw,g_sr[1].*,l_fap15,l_fap16,l_fap17,l_fap18,l_fap19,
                         l_fap61,l_fap62,l_fap63,l_fap64,l_fap65,l_fap66,
                         l_fap02,l_fap021,l_fap75,l_fap76,
                         l_fap661,l_fap52,l_fap55,
                         l_fap67,l_fap56,l_fap57,
                         l_fap152,l_fap162,l_fap612,l_fap622,l_fap6612,l_fap522,   #No:FUN-AB0088
                         l_fap552,l_fap672,l_fap562,l_fap572   #No:FUN-AB0088
   IF g_sw = 'N' THEN LET g_sw = 'Y' END IF
 
 
      CASE
         WHEN g_sr[1].fap03  = '1'    #資本化
              IF l_fap02 != l_fap75 OR l_fap021 != l_fap76 THEN
                 LET g_sr[1].desc = g_sr[1].desc clipped,' ',
                                    l_fap02,' ',l_fap021 clipped,'->',
                                    l_fap75,' ',l_fap76  clipped
                 #-----No:FUN-AB0088-----
                 IF g_faa.faa31 = 'Y' THEN
                    LET g_sr[1].desc2 = g_sr[1].desc2 clipped,' ',
                                       l_fap02,' ',l_fap021 clipped,'->',
                                       l_fap75,' ',l_fap76  clipped
                 END IF
                 #-----No:FUN-AB0088 END-----
              END IF
         WHEN g_sr[1].fap03  = '3'    #移轉
              IF l_fap17 != l_fap63 THEN   #保管部門
                 LET g_sr[1].desc = g_sr[1].desc clipped,' ',
                                    l_fap17 clipped,'->',l_fap63
                 #-----No:FUN-AB0088-----
                 IF g_faa.faa31 = 'Y' THEN
                    LET g_sr[1].desc2 = g_sr[1].desc2 clipped,' ',
                                       l_fap17 clipped,'->',l_fap63
                 END IF
                 #-----No:FUN-AB0088 END-----
              END IF
              IF l_fap18 != l_fap64 THEN   #保管人員
                 LET g_sr[1].desc = g_sr[1].desc clipped,' ',
                                    l_fap18 clipped,'->',l_fap64
                 #-----No:FUN-AB0088-----
                 IF g_faa.faa31 = 'Y' THEN
                    LET g_sr[1].desc2 = g_sr[1].desc2 clipped,' ',
                                       l_fap18 clipped,'->',l_fap64
                 END IF
                 #-----No:FUN-AB0088 END-----
              END IF
              IF l_fap19 != l_fap65 THEN   #存放位置
                 LET g_sr[1].desc = g_sr[1].desc clipped,' ',
                                    l_fap19 clipped,'->',l_fap65
                 #-----No:FUN-AB0088-----
                 IF g_faa.faa31 = 'Y' THEN
                    LET g_sr[1].desc2 = g_sr[1].desc2 clipped,' ',
                                       l_fap19 clipped,'->',l_fap65
                 END IF
                 #-----No:FUN-AB0088 END-----
              END IF
         WHEN g_sr[1].fap03  = '7'    #改良
              SELECT faz12 INTO l_faz12 FROM faz_file
                  WHERE faz01 = g_sr[1].fap50 AND faz02 = g_sr[1].fap501
               IF SQLCA.sqlcode THEN LET l_faz12 = ' ' END IF
              SELECT fag03 INTO g_sr[1].desc FROM fag_file
               WHERE fag01 = l_faz12 AND fag02 = '7'
               IF SQLCA.sqlcode THEN LET g_sr[1].desc = ' ' END IF
              #-----No:FUN-AB0088-----
              IF g_faa.faa31 = 'Y' THEN
                 LET g_sr[1].desc2 = g_sr[1].desc
              #-----No:FUN-AB0088-----
              END IF
              #-----No:FUN-AB0088 END-----

         WHEN g_sr[1].fap03  = '8'    #重估
              SELECT fbb12 INTO l_fbb12 FROM fbb_file
                  WHERE fbb01 = g_sr[1].fap50 AND fbb02 = g_sr[1].fap501
               IF SQLCA.sqlcode THEN LET l_fbb12 = ' ' END IF
              SELECT fag03 INTO g_sr[1].desc FROM fag_file
               WHERE fag01 = l_fbb12 AND fag02 = '8'
               IF SQLCA.sqlcode THEN LET g_sr[1].desc = ' ' END IF
              #-----No:FUN-AB0088-----
              IF g_faa.faa31 = 'Y' THEN
                 LET g_sr[1].desc2 = g_sr[1].desc
              END IF
              #-----No:FUN-AB0088 END-----

         WHEN g_sr[1].fap03  = '9'    #調整
             #-----MOD-7C0089---------
             #LET g_sr[1].desc = '成本:',l_fap661,' ','未用年限:',l_fap52,
             #                   ' ','累折:',l_fap55 clipped
             LET l_zemsg=''
             LET l_zemsg2=''
             LET l_zemsg3=''
             SELECT ze03 INTO l_zemsg FROM ze_file
                    WHERE ze01='afa-520' AND ze02=g_lang
             SELECT ze03 INTO l_zemsg2 FROM ze_file
                    WHERE ze01='afa-521' AND ze02=g_lang
             SELECT ze03 INTO l_zemsg3 FROM ze_file
                    WHERE ze01='afa-522' AND ze02=g_lang
             LET g_sr[1].desc = l_zemsg CLIPPED,l_fap661 CLIPPED,' ',
                                l_zemsg2 CLIPPED,l_fap52 CLIPPED,' ',
                                l_zemsg3 CLIPPED,l_fap55 CLIPPED
             #-----END MOD-7C0089-----
             #-----No:FUN-AB0088-----
              IF g_faa.faa31 = 'Y' THEN
                 LET g_sr[1].desc2 = l_zemsg CLIPPED,l_fap6612 CLIPPED,' ',
                                     l_zemsg2 CLIPPED,l_fap522 CLIPPED,' ',
                                     l_zemsg3 CLIPPED,l_fap552 CLIPPED
              END IF
              #-----No:FUN-AB0088 END-----
         WHEN g_sr[1].fap03  = '4' OR                       #出售
              g_sr[1].fap03  = '5' OR g_sr[1].fap03 = '6'   #報廢/銷帳
             LET g_sr[1].fap66  = l_fap67
             #-----MOD-7C0089---------
             #LET g_sr[1].desc = '銷帳數量:',l_fap67,' ','銷帳成本:',l_fap56,
             #        ' ','銷帳累折:',l_fap57 clipped
             LET l_zemsg=''
             LET l_zemsg2=''
             LET l_zemsg3=''
             SELECT ze03 INTO l_zemsg FROM ze_file
                    WHERE ze01='afa-523' AND ze02=g_lang
             SELECT ze03 INTO l_zemsg2 FROM ze_file
                    WHERE ze01='afa-524' AND ze02=g_lang
             SELECT ze03 INTO l_zemsg3 FROM ze_file
                    WHERE ze01='afa-525' AND ze02=g_lang
             LET g_sr[1].desc = l_zemsg CLIPPED,l_fap67 CLIPPED,' ',
                                l_zemsg2 CLIPPED,l_fap56 CLIPPED,' ',
                                l_zemsg3 CLIPPED,l_fap57 CLIPPED
             #-----END MOD-7C0089-----
             #-----No:FUN-AB0088-----
              IF g_faa.faa31 = 'Y' THEN
                 LET g_sr[1].desc2 = l_zemsg CLIPPED,l_fap672 CLIPPED,' ',
                                     l_zemsg2 CLIPPED,l_fap562 CLIPPED,' ',
                                     l_zemsg3 CLIPPED,l_fap572 CLIPPED
              END IF
              #-----No:FUN-AB0088 END-----
         WHEN g_sr[1].fap03  = 'A'       #外送  add by kitty 99-04-29
             SELECT ze03 INTO l_zemsg FROM ze_file
                    WHERE ze01 = 'afa-969' AND ze02 = g_lang
             SELECT ze03 INTO l_zemsg2 FROM ze_file
                    WHERE ze01 = 'afa-971' AND ze02 = g_lang
             LET g_sr[1].desc = l_zemsg CLIPPED,l_zemsg2 CLIPPED,':',l_fap65
             #-----No:FUN-AB0088-----
              IF g_faa.faa31 = 'Y' THEN
                 LET g_sr[1].desc2 = l_zemsg CLIPPED,l_zemsg2 CLIPPED,':',l_fap65
              END IF
              #-----No:FUN-AB0088 END-----
         WHEN g_sr[1].fap03  = 'B'       #收回
             SELECT ze03 INTO l_zemsg FROM ze_file
                    WHERE ze01 = 'afa-972' AND ze02 = g_lang
             LET g_sr[1].desc = l_zemsg CLIPPED,':',l_fap63
         #-----MOD-7C0089---------
             #-----No:FUN-AB0088-----
              IF g_faa.faa31 = 'Y' THEN
                 LET g_sr[1].desc = l_zemsg CLIPPED,':',l_fap63
              END IF
              #-----No:FUN-AB0088 END-----
         WHEN g_sr[1].fap03  = 'D'    #位置移轉 
              SELECT fbl06 INTO l_fbl06 FROM fbl_file
                  WHERE fbl01 = g_sr[1].fap50 
               IF SQLCA.sqlcode THEN LET l_fbl06 = ' ' END IF
              SELECT fag03 INTO g_sr[1].desc FROM fag_file
               WHERE fag01 = l_fbl06 AND fag02 = 'D'
               IF SQLCA.sqlcode THEN LET g_sr[1].desc = ' ' END IF
               #-----No:FUN-AB0088-----
              IF g_faa.faa31 = 'Y' THEN
                 LET g_sr[1].desc2 = g_sr[1].desc
              END IF
              #-----No:FUN-AB0088 END-----
         #-----END MOD-7C0089-----
         OTHERWISE EXIT CASE
      END  CASE
      INSERT INTO tmp_file VALUES(l_sw,g_sr[1].*)
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
 
   LET l_sql = "SELECT '2','','a','2', ",
              #" '----------','','',fan07,'','',fan03,fan04",               #MOD-B70080 mark
              #" '----------','','',fan07,'','','','','','',fan03,fan04",   #MOD-B70080      #MOD-BA0117 mark
              #" '----------','','','',fan07,'','','','','',fan03,fan04",   #MOD-BA0117      #MOD-C50214 mark
               " '----------',fan19,'','',fan07,'','','','','',fan03,fan04",   #MOD-BA0117   #MOD-C50214 異動單號處顯示分錄底稿單號
               "  FROM fan_file ",
               " WHERE fan01 = '",g_faj.faj02,"'" ,
               "   AND fan02 = '",g_faj.faj022,"'",
               "   AND fan041 = '1'",
               #仅显示1.单一部门及3.分摊的内容
               "   AND fan05 <> '2'",               #No.MOD-AC0014
               "   AND fan03 >= ",YEAR(tdate)
   PREPARE q101_pre_2 FROM l_sql
   DECLARE q101_b_2 CURSOR FOR q101_pre_2
   FOREACH q101_b_2 INTO l_sw,g_sr[1].* ,l_fan03,l_fan04
      IF l_fan03 = YEAR(tdate) AND l_fan04 < MONTH(tdate)
      THEN CONTINUE FOREACH
      END IF
      IF g_sw = 'N' THEN LET g_sw = 'Y' END IF
      CALL s_azn01(l_fan03,l_fan04) RETURNING l_date,g_sr[1].tdate
      INSERT INTO tmp_file VALUES(l_sw,g_sr[1].*)
   END FOREACH
 
   #-----No:FUN-AB0088-----
   IF g_faa.faa31 = 'Y' THEN
      LET l_sql = "SELECT '2','','a','2', ",
                 #" '----------','','','',fbn07,'','','','',fbn03,fbn04",      #MOD-B70080 mark
                 #" '----------','','',fbn07,'','','','','','',fbn03,fbn04",   #MOD-B70080        #MOD-BA0117 mark
                 #" '----------','','','',fbn07,'','','','','',fbn03,fbn04",   #MOD-BA0117        #MOD-C50214 mark
                 #" '----------',fbn19,'','',fbn07,'','','','','',fbn03,fbn04",   #MOD-BA0117 #MOD-C50214 異動單號處顯示分錄底稿單號 #MOD-CA0234 mark
                  " '----------',fbn19,'','','',fbn07,'','','','',fbn03,fbn04",   #MOD-CA0234 add
                  "  FROM fbn_file ",
                  " WHERE fbn01 = '",g_faj.faj02,"'" ,
                  "   AND fbn02 = '",g_faj.faj022,"'",
                  "   AND fbn041 = '1'",
                  #僅顯示1.單一部門及3.分攤的內容
                  "   AND fbn05 <> '2'",
                  "   AND fbn03 >= ",YEAR(tdate)
      PREPARE q101_pre_22 FROM l_sql
      DECLARE q101_b_22 CURSOR FOR q101_pre_22
      FOREACH q101_b_22 INTO l_sw,g_sr[1].* ,l_fbn03,l_fbn04
         IF l_fbn03 = YEAR(tdate) AND l_fbn04 < MONTH(tdate)
         THEN CONTINUE FOREACH
         END IF
         IF g_sw = 'N' THEN LET g_sw = 'Y' END IF
         CALL s_azn01(l_fbn03,l_fbn04) RETURNING l_date,g_sr[1].tdate
         INSERT INTO tmp_file VALUES(l_sw,g_sr[1].*)
      END FOREACH
   END IF
   #-----No:FUN-AB0088 END-----

   FOR g_cnt = 1 TO g_sr.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_sr[g_cnt].* TO NULL
       INITIALIZE g_sr_tmp[g_cnt].* TO NULL
   END FOR
  # LET l_str1 = "新購  資本化盤點  移轉  出售  報廢  ",
  #              "銷帳  改良  重估  調整  提折舊"
  # LET l_str2 = "取得  資本化      折舊中折畢  出售  ",
  #              "銷帳  折畢提 續提       折舊中"
 
    LET g_cnt = 1
    DECLARE q101_t CURSOR FOR
     SELECT * FROM tmp_file
      ORDER BY tdate,sw
    FOREACH q101_t INTO l_sw,g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F2:',STATUS,1) EXIT FOREACH END IF
      {
       IF g_sr[g_cnt].fap03 = 'a' THEN
          LET i = 10
          LET j = 10
       ELSE
          IF g_sr[g_cnt].fap05 = 'C' THEN LET g_sr[g_cnt].fap05 = 8 END IF
          LET i = g_sr[g_cnt].fap03
          LET j = g_sr[g_cnt].fap05
       END IF
       }
       LET g_sr_tmp[g_cnt].fap03 = g_sr[g_cnt].fap03
       CASE WHEN g_sr[g_cnt].fap03 = '0'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-953' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            WHEN g_sr[g_cnt].fap03 = '1'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-954' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            WHEN g_sr[g_cnt].fap03 = '2'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-955' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            WHEN g_sr[g_cnt].fap03 = '3'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-956' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            WHEN g_sr[g_cnt].fap03 = '4'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-957' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            WHEN g_sr[g_cnt].fap03 = '5'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-958' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            WHEN g_sr[g_cnt].fap03 = '6'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-959' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            WHEN g_sr[g_cnt].fap03 = '7'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-960' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            WHEN g_sr[g_cnt].fap03 = '8'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-961' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            WHEN g_sr[g_cnt].fap03 = '9'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-962' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            WHEN g_sr[g_cnt].fap03 = 'a'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-963' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            WHEN g_sr[g_cnt].fap03 = 'A'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-969' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            WHEN g_sr[g_cnt].fap03 = 'B'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-970' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            #-----MOD-7C0089---------
            WHEN g_sr[g_cnt].fap03 = 'C'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-059' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            WHEN g_sr[g_cnt].fap03 = 'D'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-515' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            WHEN g_sr[g_cnt].fap03 = 'E'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-052' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            WHEN g_sr[g_cnt].fap03 = 'F'
                   SELECT ze03 INTO l_zemsg FROM ze_file
                          WHERE ze01 = 'afa-516' AND ze02 = g_lang
                   LET g_sr[g_cnt].fap03 = l_zemsg CLIPPED
            #-----END MOD-7C0089-----
       END CASE
      #MOD-AC0081 mark --start--
      #CASE WHEN g_sr[g_cnt].fap05 = '0'
      #            SELECT ze03 INTO l_zemsg FROM ze_file
      #                   WHERE ze01 = 'afa-964' AND ze02 = g_lang
      #            LET g_sr[g_cnt].fap05 = l_zemsg CLIPPED
      #     WHEN g_sr[g_cnt].fap05 = '1'
      #            SELECT ze03 INTO l_zemsg FROM ze_file
      #                   WHERE ze01 = 'afa-954' AND ze02 = g_lang
      #            LET g_sr[g_cnt].fap05 = l_zemsg CLIPPED
      #     WHEN g_sr[g_cnt].fap05 = '2'
      #            SELECT ze03 INTO l_zemsg FROM ze_file
      #                   WHERE ze01 = 'afa-965' AND ze02 = g_lang
      #            LET g_sr[g_cnt].fap05 = l_zemsg CLIPPED
      #      WHEN g_sr[g_cnt].fap05 = '3'   #No.MOD-4A0123 外送
      #            SELECT ze03 INTO l_zemsg FROM ze_file
      #                   WHERE ze01 = 'afa-969' AND ze02 = g_lang
      #            LET g_sr[g_cnt].fap05 = l_zemsg CLIPPED
      #     WHEN g_sr[g_cnt].fap05 = '4'
      #            SELECT ze03 INTO l_zemsg FROM ze_file
      #                   WHERE ze01 = 'afa-966' AND ze02 = g_lang
      #            LET g_sr[g_cnt].fap05 = l_zemsg CLIPPED
      #     WHEN g_sr[g_cnt].fap05 = '5'
      #            SELECT ze03 INTO l_zemsg FROM ze_file
      #                   WHERE ze01 = 'afa-957' AND ze02 = g_lang
      #            LET g_sr[g_cnt].fap05 = l_zemsg CLIPPED
      #     WHEN g_sr[g_cnt].fap05 = '6'                   #銷帳
      #            SELECT ze03 INTO l_zemsg FROM ze_file
      #                   WHERE ze01 = 'afa-958' AND ze02 = g_lang
      #             LET g_sr[g_cnt].fap05 = l_zemsg CLIPPED  #No.MOD-4A0123
      #     WHEN g_sr[g_cnt].fap05 = '7'
      #            SELECT ze03 INTO l_zemsg FROM ze_file
      #                   WHERE ze01 = 'afa-967' AND ze02 = g_lang
      #            LET g_sr[g_cnt].fap05 = l_zemsg CLIPPED
      #     WHEN g_sr[g_cnt].fap05 = '8'
      #            SELECT ze03 INTO l_zemsg FROM ze_file
      #                   WHERE ze01 = 'afa-960' AND ze02 = g_lang
      #             LET g_sr[g_cnt].fap05 = l_zemsg CLIPPED    #No.MOD-4A0123
      #      WHEN g_sr[g_cnt].fap05 = '9'     #No.MOD-4A0123 重估
      #            SELECT ze03 INTO l_zemsg FROM ze_file
      #                   WHERE ze01 = 'afa-961' AND ze02 = g_lang
      #            LET g_sr[g_cnt].fap05 = l_zemsg CLIPPED
      #END CASE
      #MOD-AC0081 mark --end--
      CALL q101_zemsg(g_sr[g_cnt].fap05) RETURNING g_sr[g_cnt].fap05 #MOD-AC0081 add
      CALL q101_zemsg(g_sr[g_cnt].fap052) RETURNING g_sr[g_cnt].fap052    #No:FUN-AB0088
 
     # LET g_sr[g_cnt].fap03 = l_str1[i*6+1,i*6+6]
     # LET g_sr[g_cnt].fap05 = l_str2[j*6+1,j*6+6]
      #MOD-AC0081 mark --start--
      #IF g_sr[g_cnt].fap77 IS NOT NULL AND g_sr[g_cnt].fap77 <> ' ' THEN
      #   IF g_sr[g_cnt].fap77 = 'C' THEN LET g_sr[g_cnt].fap77 = 8 END IF
      #   LET j = g_sr[g_cnt].fap77
      #   LET g_sr[g_cnt].fap77 = l_str2[j*6+1,j*6+6]
      #END IF
      #MOD-AC0081 mark --end--
       CALL q101_zemsg(g_sr[g_cnt].fap77) RETURNING g_sr[g_cnt].fap77 #MOD-AC0081 add
       LET g_cnt = g_cnt + 1
    END FOREACH
#----------------------------------------------------------------------------
    CALL g_sr.deleteElement(g_cnt)       #No.TQC-770077
    LET g_rec_b = g_cnt - 1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
    DROP TABLE tmp_file
END FUNCTION
 
#MOD-AC0081 add --start--
FUNCTION q101_zemsg(p_fap05)
   DEFINE p_fap05   LIKE fap_file.fap05
   DEFINE l_zemsg   LIKE ze_file.ze03
   DEFINE l_ze03    LIKE ze_file.ze03

   LET l_ze03 = ''

   CASE WHEN p_fap05 = '0'
               SELECT ze03 INTO l_zemsg FROM ze_file
                      WHERE ze01 = 'afa-964' AND ze02 = g_lang
               LET l_ze03 = l_zemsg CLIPPED
        WHEN p_fap05 = '1'
               SELECT ze03 INTO l_zemsg FROM ze_file
                      WHERE ze01 = 'afa-954' AND ze02 = g_lang
               LET l_ze03 = l_zemsg CLIPPED
        WHEN p_fap05 = '2'
               SELECT ze03 INTO l_zemsg FROM ze_file
                      WHERE ze01 = 'afa-965' AND ze02 = g_lang
               LET l_ze03 = l_zemsg CLIPPED
         WHEN p_fap05 = '3'   #No:MOD-4A0123 外送
               SELECT ze03 INTO l_zemsg FROM ze_file
                      WHERE ze01 = 'afa-969' AND ze02 = g_lang
               LET l_ze03 = l_zemsg CLIPPED
        WHEN p_fap05 = '4'
               SELECT ze03 INTO l_zemsg FROM ze_file
                      WHERE ze01 = 'afa-966' AND ze02 = g_lang
               LET l_ze03 = l_zemsg CLIPPED
        WHEN p_fap05 = '5'
               SELECT ze03 INTO l_zemsg FROM ze_file
                      WHERE ze01 = 'afa-957' AND ze02 = g_lang
               LET l_ze03 = l_zemsg CLIPPED
        WHEN p_fap05 = '6'                   #銷帳
               SELECT ze03 INTO l_zemsg FROM ze_file
                      WHERE ze01 = 'afa-958' AND ze02 = g_lang
               LET l_ze03 = l_zemsg CLIPPED
        WHEN p_fap05 = '7'
               SELECT ze03 INTO l_zemsg FROM ze_file
                      WHERE ze01 = 'afa-967' AND ze02 = g_lang
               LET l_ze03 = l_zemsg CLIPPED
        WHEN p_fap05 = '8'
               SELECT ze03 INTO l_zemsg FROM ze_file
                      WHERE ze01 = 'afa-960' AND ze02 = g_lang
               LET l_ze03 = l_zemsg CLIPPED
         WHEN p_fap05 = '9'     
               SELECT ze03 INTO l_zemsg FROM ze_file
                      WHERE ze01 = 'afa-961' AND ze02 = g_lang
               LET l_ze03 = l_zemsg CLIPPED
   END CASE
   RETURN l_ze03
END FUNCTION
#MOD-AC0081 add --end--

FUNCTION q101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_sr TO s_sr.*
    ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #CKP
 
       BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q101_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 明細查詢
      ON ACTION query_details
         LET g_action_choice="query_details"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
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
 
FUNCTION q101_b()
    DEFINE l_ac,l_sl,l_n LIKE type_file.num5,         #No.FUN-680070 SMALLINT
           l_type    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
           l_msg     LIKE type_file.chr50        #No.FUN-680070 VARCHAR(50)
 
 
       INPUT ARRAY g_sr
             WITHOUT DEFAULTS
             FROM s_sr.*
             ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                       INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
       BEFORE INPUT
           CALL fgl_set_arr_curr(l_ac)
 
       BEFORE ROW
           LET l_ac = ARR_CURR()
           LET l_n  = ARR_COUNT()
           DISPLAY g_sr[l_ac].* TO s_sr[l_ac].*
           IF l_ac <= g_cnt THEN
              LET l_msg= '<^P> 查詢異動前資料 <^T> 查詢異動值資料'
              MESSAGE l_msg
           END IF
 
       AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              EXIT INPUT
           END IF
           DISPLAY g_sr[l_ac].* TO s_sr[l_ac].*
           MESSAGE ' '
 
        ON ACTION qry_before_tran
           IF g_sr[l_ac].fap50 IS NOT NULL
              AND g_sr[l_ac].fap50 <> '----------' THEN
              CALL q101_d("T",l_ac)
           END IF
 
        ON ACTION qry_after_tran
           IF g_sr[l_ac].fap50 IS NOT NULL
              AND g_sr[l_ac].fap50 <> '----------' THEN
              CALL q101_d("P",l_ac)
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
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
    END INPUT
    LET INT_FLAG=0
END FUNCTION
 
FUNCTION q101_d(p_type,l_ac)
 DEFINE p_row,p_col,l_ac  LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        p_type,answer     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
        l_fap             RECORD LIKE fap_file.* ,
        l_fan             RECORD LIKE fan_file.* ,
        l_str1,l_str5,l_str6,l_str12 LIKE type_file.chr20, #No:FUN-AB0088     #No.FUN-680028       #No.FUN-680070 VARCHAR(20) #FUN-B90023 MOD
        l_str2,l_str3,l_str4,l_str7,l_str8,l_str9,l_str10 LIKE aag_file.aag02  #FUN-B90023 add
    LET p_row = 5 LET p_col = 2
    #No.FUN-740026 --BEGIN--                                                                                                     
       CALL s_get_bookno(YEAR(g_sr[l_ac].tdate))  RETURNING g_flag,g_bookno1,g_bookno2                                              
       IF g_flag='1' THEN #抓不到帳套                                                                                               
          CALL cl_err(g_sr[l_ac].tdate,'aoo-081',1)                                                                                 
       END IF                                                                                                                       
    #No.FUN-740026  --END--  
    SELECT * INTO l_fap.* FROM fap_file
     WHERE fap02 = g_faj.faj02 AND fap021 = g_faj.faj022
       AND fap03 = g_sr_tmp[l_ac].fap03
       AND fap04 = g_sr[l_ac].tdate
 
     IF p_type = "P" THEN    #"T"-->before "P"-->After     #No.MOD-510118
       OPEN WINDOW q_1011 AT p_row,p_col
             WITH FORM "afa/42f/afaq1012"           #No.MOD-510118
             ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
       CALL cl_ui_locale("afaq1012")
       #No.FUN-680028 --begin
    #  IF g_aza.aza63 = 'Y' THEN
       IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
          CALL cl_set_comp_visible("fap581,fap591,fap601",TRUE)
       ELSE
          CALL cl_set_comp_visible("fap581,fap591,fap601",FALSE)
       END IF
       #No.FUN-680028 --end
        #No.MOD-510118改取ze_file
       LET l_str1=''
       CASE
           WHEN l_fap.fap61 = '1'
              # LET l_str1 = "單一部門"
                SELECT ze03 INTO l_str1 FROM ze_file
                 WHERE ze01 = 'afa-169' AND ze02 = g_lang
           WHEN l_fap.fap61 = '2'
               #LET l_str1 = "多部門"
                SELECT ze03 INTO l_str1 FROM ze_file
                 WHERE ze01 = 'afa-170' AND ze02 = g_lang
           WHEN l_fap.fap61 = '3'
               #LET l_str1 = "被分攤"
                SELECT ze03 INTO l_str1 FROM ze_file
                 WHERE ze01 = 'afa-171' AND ze02 = g_lang
       END CASE
      
       #-----No:FUN-AB0088-----
       LET l_str12=''
       CASE
           WHEN l_fap.fap612 = '1'
              # LET l_str1 = "單一部門"
                SELECT ze03 INTO l_str12 FROM ze_file
                 WHERE ze01 = 'afa-169' AND ze02 = g_lang
           WHEN l_fap.fap612 = '2'
               #LET l_str1 = "多部門"
                SELECT ze03 INTO l_str12 FROM ze_file
                 WHERE ze01 = 'afa-170' AND ze02 = g_lang
           WHEN l_fap.fap612 = '3'
               #LET l_str1 = "被分攤"
                SELECT ze03 INTO l_str12 FROM ze_file
                 WHERE ze01 = 'afa-171' AND ze02 = g_lang
       END CASE
       #-----No:FUN-AB0088 END-----
 
       SELECT aag02 INTO l_str2 FROM aag_file   # 累計折舊
        WHERE aag01 = l_fap.fap59
         AND  aag00 = g_bookno1      #No.FUN-740026
       IF cl_null(l_str2) THEN LET l_str2 = l_fap.fap59 END IF
       SELECT aag02 INTO l_str3 FROM aag_file   # 資產科目
        WHERE aag01 = l_fap.fap58
         AND  aag00 = g_bookno1      #No.FUN-740026
       IF cl_null(l_str3) THEN LET l_str3 = l_fap.fap58 END IF
       SELECT aag02 INTO l_str4 FROM aag_file   # 折舊科目
        WHERE aag01 = l_fap.fap60
          AND  aag00 = g_bookno1      #No.FUN-740026
 
        #---No.MOD-480624---#
      #IF cl_null(l_str4) THEN LET l_str4 = l_fap.fap14 END IF     #MOD-A50095 mark
       IF cl_null(l_str4) THEN LET l_str4 = l_fap.fap60 END IF     #MOD-A50095
       SELECT gen02 INTO l_str5 FROM gen_file   # 保管人員
        WHERE gen01 = l_fap.fap64
      #IF cl_null(l_str5) THEN LET l_str5 = l_fap.fap18 END IF     #MOD-A50095 mark
       IF cl_null(l_str5) THEN LET l_str5 = l_fap.fap64 END IF     #MOD-A50095
       SELECT gem02 INTO l_str6 FROM gem_file   # 保管部門
        WHERE gem01 = l_fap.fap63
      #IF cl_null(l_str6) THEN LET l_str6 = l_fap.fap17 END IF     #MOD-A50095 mark
 
       IF cl_null(l_str6) THEN LET l_str6 = l_fap.fap63 END IF
       SELECT gem02 INTO l_str7 FROM gem_file   # 分攤部門
        WHERE gem01 = l_fap.fap62
       IF cl_null(l_str7) THEN LET l_str7 = l_fap.fap62 END IF
 
       #No.FUN-680028 --begin
       SELECT aag02 INTO l_str8 FROM aag_file   # 累計折舊
        WHERE aag01 = l_fap.fap591
         AND  aag00 = g_bookno2      #No.FUN-740026
       IF cl_null(l_str8) THEN LET l_str8 = l_fap.fap591 END IF
       SELECT aag02 INTO l_str9 FROM aag_file   # 資產科目
        WHERE aag01 = l_fap.fap581
         AND  aag00 = g_bookno2      #No.FUN-740026
       IF cl_null(l_str9) THEN LET l_str9 = l_fap.fap581 END IF
       SELECT aag02 INTO l_str10 FROM aag_file   # 折舊科目
        WHERE aag01 = l_fap.fap601
         AND  aag00 = g_bookno2      #No.FUN-740026
      #IF cl_null(l_str10) THEN LET l_str10 = l_fap.fap141 END IF     #MOD-A50095 mark
       IF cl_null(l_str10) THEN LET l_str10 = l_fap.fap601 END IF     #MOD-A50095
       #No.FUN-680028 --end
       DISPLAY BY NAME l_fap.fap51,l_fap.fap61,l_fap.fap52,
                       l_fap.fap53,l_fap.fap661,l_fap.fap54,l_fap.fap55,
                       l_fap.fap56,l_fap.fap57,l_fap.fap66,l_fap.fap67,
                       l_fap.fap63,l_fap.fap64,l_fap.fap65,l_fap.fap62,
                       l_fap.fap58,l_fap.fap59,l_fap.fap60
       #No.FUN-680028 --begin
   #   IF g_aza.aza63 = 'Y' THEN
       IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
          DISPLAY BY NAME l_fap.fap581,l_fap.fap591,l_fap.fap601
       ##-----No:FUN-BA0112 Mark-----      
       #   #-----No:FUN-AB0088-----
       #   DISPLAY BY NAME l_fap.fap51,l_fap.fap61,l_fap.fap52,
       #                   l_fap.fap53,l_fap.fap661,l_fap.fap55,
       #                   l_fap.fap56,l_fap.fap57,l_fap.fap66,l_fap.fap67,
       #                   l_fap.fap62
       #   #-----No:FUN-AB0088 END-----
       ##-----No:FUN-BA0112 Mark END-----

       ##-----No:FUN-BA0112 add STR-----
           DISPLAY BY NAME l_fap.fap512,l_fap.fap612,l_fap.fap622,
                           l_fap.fap522,l_fap.fap6612,l_fap.fap562,
                           l_fap.fap572,l_fap.fap532,l_fap.fap542,
                           l_fap.fap552,l_fap.fap672                 
       ##-----No:FUN-BA0112 add END-----       
       END IF
       #No.FUN-680028 --end
 
{
       #印異動後資料
       DISPLAY BY NAME l_fap.fap06,l_fap.fap15,l_fap.fap16,l_fap.fap24,
                       l_fap.fap25,l_fap.fap26,l_fap.fap07,l_fap.fap08,
                       l_fap.fap41,l_fap.fap09,l_fap.fap11,l_fap.fap23,
                       l_fap.fap22,l_fap.fap54,l_fap.fap20,l_fap.fap201,
                       l_fap.fap21,l_fap.fap63,l_fap.fap64,l_fap.fap65
}
       #-------END--------#
 
       DISPLAY l_str1,l_str2,l_str3,l_str4,l_str5,l_str6,l_str7
            TO desc ,fap59,fap58,fap60,gen02,gem02,fap62
       #No.FUN-680028 --begin
   #   IF g_aza.aza63 = 'Y' THEN
       IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
          DISPLAY l_str8,l_str9,l_str10,l_str12   #No:FUN-AB0088
               TO fap591,fap581,fap601,desc2   #No:FUN-AB0088
       END IF
       #No.FUN-680028 --end
    ELSE
       LET p_row = 5 LET p_col = 2
       OPEN WINDOW q_1011 AT p_row,p_col
            WITH FORM "afa/42f/afaq1011"
             ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
       CALL cl_ui_locale("afaq1011")
       #No.FUN-680028 --begin
    #  IF g_aza.aza63 = 'Y' THEN
       IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
          CALL cl_set_comp_visible("fap121,fap131,fap141",TRUE)
       ELSE
          CALL cl_set_comp_visible("fap121,fap131,fap141",FALSE)
       END IF
       #No.FUN-680028 --end
 
        #No.MOD-510118改取ze_file
       LET l_str1=''
       CASE
           WHEN l_fap.fap15 = '1'
              # LET l_str1 = "單一部門"
                SELECT ze03 INTO l_str1 FROM ze_file
                 WHERE ze01 = 'afa-169' AND ze02 = g_lang
           WHEN l_fap.fap15 = '2'
               #LET l_str1 = "多部門"
                SELECT ze03 INTO l_str1 FROM ze_file
                 WHERE ze01 = 'afa-170' AND ze02 = g_lang
           WHEN l_fap.fap15 = '3'
               #LET l_str1 = "被分攤"
                SELECT ze03 INTO l_str1 FROM ze_file
                 WHERE ze01 = 'afa-171' AND ze02 = g_lang
       END CASE

       #-----No:FUN-AB0088-----
       CASE
           WHEN l_fap.fap152 = '1'
              # LET l_str1 = "單一部門"
                SELECT ze03 INTO l_str12 FROM ze_file
                 WHERE ze01 = 'afa-169' AND ze02 = g_lang
           WHEN l_fap.fap152 = '2'
               #LET l_str1 = "多部門"
                SELECT ze03 INTO l_str12 FROM ze_file
                 WHERE ze01 = 'afa-170' AND ze02 = g_lang
           WHEN l_fap.fap152 = '3'
               #LET l_str1 = "被分攤"
                SELECT ze03 INTO l_str12 FROM ze_file
                 WHERE ze01 = 'afa-171' AND ze02 = g_lang
       END CASE
       #-----No:FUN-AB0088 END-----

       SELECT aag02 INTO l_str2 FROM aag_file   # 資產科目
        WHERE aag01 = l_fap.fap12
         AND  aag00 = g_bookno1      #No.FUN-740026
       IF cl_null(l_str2) THEN LET l_str2 = l_fap.fap12 END IF
       SELECT aag02 INTO l_str3 FROM aag_file   # 累折科目
        WHERE aag01 = l_fap.fap13
         AND  aag00 = g_bookno1      #No.FUN-740026
       IF cl_null(l_str3) THEN LET l_str3 = l_fap.fap13 END IF
       SELECT aag02 INTO l_str4 FROM aag_file   # 累計折舊
        WHERE aag01 = l_fap.fap14
         AND  aag00 = g_bookno1      #No.FUN-740026
 
        #---No.MOD-480624---#
      #IF cl_null(l_str4) THEN LET l_str4 = l_fap.fap60 END IF     #MOD-A50095 mark
       IF cl_null(l_str4) THEN LET l_str4 = l_fap.fap14 END IF     #MOD-A50095
       SELECT gen02 INTO l_str5 FROM gen_file   # 保管人員
        WHERE gen01 = l_fap.fap18
      #IF cl_null(l_str5) THEN LET l_str5 = l_fap.fap64 END IF     #MOD-A50095 mark
       IF cl_null(l_str5) THEN LET l_str5 = l_fap.fap18 END IF     #MOD-A50095
       SELECT gem02 INTO l_str6 FROM gem_file   # 保管部門
        WHERE gem01 = l_fap.fap17
       IF cl_null(l_str6) THEN LET l_str6 = l_fap.fap17 END IF     #MOD-A50095
       #--------END--------#
       #No.FUN-680028 --begin
       SELECT aag02 INTO l_str7 FROM aag_file   # 資產科目
        WHERE aag01 = l_fap.fap121
         AND  aag00 = g_bookno2      #No.FUN-740026
       IF cl_null(l_str7) THEN LET l_str7 = l_fap.fap121 END IF
       SELECT aag02 INTO l_str8 FROM aag_file   # 累折科目
        WHERE aag01 = l_fap.fap131
         AND  aag00 = g_bookno2      #No.FUN-740026 
       IF cl_null(l_str8) THEN LET l_str8 = l_fap.fap131 END IF
       SELECT aag02 INTO l_str9 FROM aag_file   # 累計折舊
        WHERE aag01 = l_fap.fap141
          AND  aag00 = g_bookno2      #No.FUN-740026 
          
      #IF cl_null(l_str9) THEN LET l_str9 = l_fap.fap601 END IF     #MOD-A50095 mark
       IF cl_null(l_str9) THEN LET l_str9 = l_fap.fap141 END IF     #MOD-A50095
       #No.FUN-680028 --end
 
        #No.MOD-510118
       DISPLAY BY NAME l_fap.fap06,l_fap.fap15,l_fap.fap16,l_fap.fap24,
                       l_fap.fap25,l_fap.fap26,l_fap.fap07,l_fap.fap08,
                       l_fap.fap41,l_fap.fap09,l_fap.fap11,l_fap.fap23,
                       l_fap.fap22,l_fap.fap101,l_fap.fap20,l_fap.fap201,
                       l_fap.fap21,l_fap.fap17,l_fap.fap18,l_fap.fap19,
                       l_fap.fap10,l_fap.fap12,l_fap.fap13,l_fap.fap14
       #No.FUN-680028 --begin
    #  IF g_aza.aza63 = 'Y' THEN
       IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
          DISPLAY BY NAME l_fap.fap121,l_fap.fap131,l_fap.fap141
          #-----No:FUN-AB0088-----
          DISPLAY BY NAME l_fap.fap062,l_fap.fap152,l_fap.fap162,l_fap.fap242,
                          l_fap.fap252,l_fap.fap262,l_fap.fap092,l_fap.fap112,
                         #l_fap.fap232,l_fap.fap222,l_fap.fap1012,l_fap.fap212,l_fap.fap102
                          l_fap.fap232,l_fap.fap222,l_fap.fap1012,l_fap.fap212,l_fap.fap103   #No:FU
						 ,l_fap.fap082,l_fap.fap072 #No:FUN-BA0112 add
          #-----No:FUN-AB0088 END-----
       END IF
       #No.FUN-680028 --end
{
        #---No.MOD-480624---#
       DISPLAY BY NAME l_fap.fap51,l_fap.fap61,l_fap.fap52,
                       l_fap.fap53,l_fap.fap661,l_fap.fap54,l_fap.fap55,
                       l_fap.fap56,l_fap.fap57,l_fap.fap66,l_fap.fap67,
                       l_fap.fap17,l_fap.fap18,l_fap.fap19
       #--------END--------#
}
       DISPLAY l_str1,l_str2,l_str3,l_str4,l_str5,l_str6
            TO desc ,fap12,fap13,fap14,gen02,gem02
       #No.FUN-680028 --begin
   #   IF g_aza.aza63 = 'Y' THEN
       IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
          DISPLAY l_str7,l_str8,l_str9,l_str12   #No:FUN-AB0088
               #TO fap121,fap131,fap141,desc   #No:FUN-AB0088 #No:FUN-BA0112 mark
			   TO fap121,fap131,fap141,desc2 #No:FUN-BA0112 add
       END IF
       #No.FUN-680028 --end
    END IF
      #No.MOD-510118
     #LET INT_FLAG = 0  ######add for prompt bug
     MENU ""
          ON ACTION exit
              EXIT MENU
  #  PROMPT '請按任意鍵繼續!' FOR CHAR answer
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
#          CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
#MOD-960348   ---start                                                                                                              
    --for Windows close event trapped                                                                                               
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145                                                                                                          
      LET INT_FLAG=FALSE                                                                                                            
      LET g_action_choice = "exit"                                                                                                  
      EXIT MENU                                                                                                                     
#MOD-960348   ---end    
    END MENU
   #END PROMPT
    CLOSE WINDOW q_1011
END FUNCTION
