# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: saimi108.4gl
# Descriptions...: 料件基本資料維護作業-品名規格額外說明資料
# Input parameter: 
# Date & Author..: 90/07/17 By Wu 
# Modify ........: 92/06/18 畫面上增加 [品名規格資料處理狀況](ima93[8,8])
#                           的input查詢...... By Lin
#                  Note: 因原本的l_sql只from imc_file,現加 ima93
#                        的查詢條件,所以必須改成 from ima_file,imc_file
#
# Modify         : No:7672 03/08/08 By Mandy 進入單身應判斷imc01,imc02皆不可為NULL
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-510017 05/02/22 By Mandy 報表轉XML
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制 
# Modify.........: No.FUN-580026 05/08/10 By Sarah 在複製裡增加set_entry段
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/13 By Rainy 連續二次查詢key值時,若第二次查詢不到key值時, 會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/10 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.TQC-790061 07/09/10 By lumxa 查詢時候，狀態是灰色，不能查詢
# Modify.........: No.TQC-790172 07/09/29 By Pengu p_flow unicode 區無法執行程式
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840029 08/04/21 By sherry 報表改由CR輸出 
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-970046 09/10/20 By Pengu 複製時會出現key直重複錯誤訊息
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A90049 10/09/25 By vealxu 1.只能允許查詢料件性質(ima120)='1' (企業料號')
#                                                   2.程式中如有  INSERT INTO ima_file 時料件性質(ima120)值給'1'(企業料號)
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No:FUN-AB0025 11/11/10 By lixh1  開窗BUG處理
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B90177 11/09/29 By destiny oriu,orig不能查询 
# Modify.........: No:FUN-B90105 11/10/18 by linlin 子料件不可修改，母料件更新資料
# Modify.........: No:TQC-C30181 12/03/09 By lixiang 子料件品名規格額外說明，開放修改
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE    #No.TQC-790172 
    g_imc01         LIKE imc_file.imc01,       #產品編號 (假單頭)
    g_imc01_t       LIKE imc_file.imc01,       #產品編號 (舊值)
    g_imc02         LIKE imc_file.imc02,       #品名規格額外說明類別
    g_imc02_t       LIKE imc_file.imc02,       #
    g_imc03         LIKE imc_file.imc03,       #行序
    g_imc03_t       LIKE imc_file.imc03,       #行序(舊值)
    g_imc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        imc03       LIKE imc_file.imc03,       #行序          
        imc04       LIKE imc_file.imc04        #說明
                    END RECORD,
    g_imc_t         RECORD                     #程式變數 (舊值)
        imc03       LIKE imc_file.imc03,       #行序
        imc04       LIKE imc_file.imc04        #說明
                    END RECORD,
    g_argv1         LIKE ima_file.ima01,
    g_imauser       LIKE ima_file.imauser,
    g_imagrup       LIKE ima_file.imagrup,
    g_imamodu       LIKE ima_file.imamodu,
    g_imadate       LIKE ima_file.imadate,
    g_imaacti       LIKE ima_file.imaacti,
    g_ss            LIKE type_file.chr1,       #No.FUN-690026 VARCHAR(1)
    g_s             LIKE type_file.chr1,       #料件處理狀況  #No.FUN-690026 VARCHAR(1)
    l_flag          LIKE type_file.chr1,       #No.FUN-690026 VARCHAR(1)
    g_wc,g_sql      string,                    #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,       #單身筆數  #No.FUN-690026 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col          LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql         STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp            STRING                 #No.TQC-720019
DEFINE g_chr                LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt                LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                  LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg                LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_before_input_done  LIKE type_file.num5    #FUN-570110      #No.FUN-690026 SMALLINT
DEFINE g_row_count          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask            LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_str                STRING                 #No.FUN-840029               
DEFINE l_sql                STRING                 #No.FUN-840029 
 
 
FUNCTION aimi108(p_argv1)
   DEFINE p_argv1       LIKE ima_file.ima01

    WHENEVER ERROR CONTINUE
 
    LET g_imc01 =   NULL               #清除鍵值
    LET g_imc02 =   NULL               #清除鍵值
    LET g_imc01_t = NULL
    LET g_imc02_t = NULL
    LET g_argv1 = p_argv1
 
    OPEN WINDOW aimi108_w WITH FORM "aim/42f/aimi108" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       CALL aimi108_q()
           #No:7672 若原本無品名規格額外說明則應直接CALL aimi108_a(),
           #        可避免user直接按B.單身時,KEY值欄位imc02為NULL
           LET g_cnt = 0
           SELECT COUNT(*) INTO g_cnt
             FROM imc_file
            WHERE imc01 = g_argv1
           IF g_cnt = 0 THEN
               CALL aimi108_a()
           END IF
           ##
    END IF
    CALL aimi108_menu()
 
    CLOSE WINDOW aimi108_w                 #結束畫面
END FUNCTION
 
 
FUNCTION aimi108_curs()
    CLEAR FORM                             #清除畫面
   CALL g_imc.clear()
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' 
       THEN LET g_imc01 =  g_argv1
            DISPLAY g_imc01 TO imc01
            CALL aimi108_imc01('d')
            LET g_wc = "imc01 ='",g_argv1,"'"
       ELSE
         #FUN-640213 add --start 
         INITIALIZE g_imc01 TO NULL
         INITIALIZE g_imc02 TO NULL
         INITIALIZE g_imc03 TO NULL
         #FUN-640213 add --end
       CALL cl_set_head_visible("","YES")   #No.FUN-6B0030  
       CONSTRUCT g_wc ON imc01,imc02,imc03,imc04    #螢幕上取條件
                         ,imauser,imamodu,imaacti,imagrup,imadate #TQC-790061
                         ,imaoriu,imaorig  #TQC-B90177
               FROM imc01,imc02,s_imc[1].imc03,s_imc[1].imc04
                    ,imauser,imamodu,imaacti,imagrup,imadate #TQC-790061
                    ,imaoriu,imaorig  #TQC-B90177 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
             CALL g_imc.clear()
 
          ON ACTION CONTROLP 
             CASE
                WHEN INFIELD(imc01) #料件編號
#FUN-AA0059 --Begin--
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ima"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"    #FUN-AB0025
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                #  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret    #FUN-AB0025
#FUN-AA0059 --End--
                   DISPLAY g_qryparam.multiret TO imc01 
                   NEXT FIELD imc01
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
          LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
            IF INT_FLAG THEN RETURN END IF
            LET g_s=NULL
           INPUT g_s   WITHOUT DEFAULTS FROM s 
               AFTER FIELD s  #保稅料件
                   IF g_s NOT MATCHES '[YN]' THEN
                      NEXT FIELD s
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
           IF INT_FLAG THEN RETURN END IF
           IF g_s IS NOT NULL THEN
              LET g_wc=g_wc CLIPPED," AND ima93[8,8] = '",g_s,"' "
           END IF
    END IF  
    LET g_sql= "SELECT UNIQUE imc01,imc02 FROM ima_file,imc_file ",
             # " WHERE ima01=imc01 AND ", g_wc CLIPPED,                          #FUN-A90049 mark
               " WHERE ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) AND ima01=imc01 AND ", g_wc CLIPPED,         #FUN-A90049 add  
               " ORDER BY imc01,imc02"
    PREPARE aimi108_prepare FROM g_sql      #預備一下
    DECLARE aimi108_b_curs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR aimi108_prepare
 
#   LET g_sql="SELECT UNIQUE imc01,imc02 ",      #No.TQC-720019
    LET g_sql_tmp="SELECT UNIQUE imc01,imc02 ",  #No.TQC-720019
            # "  FROM ima_file,imc_file WHERE ima01=imc01 AND ", g_wc CLIPPED,                         #FUN-A90049 mark
              "  FROM ima_file,imc_file WHERE ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) AND ima01=imc01 AND ", g_wc CLIPPED,        #FUN-A90049 add
              "   INTO TEMP x "
    DROP TABLE x
#   PREPARE i108_precount_x FROM g_sql      #No.TQC-720019
    PREPARE i108_precount_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i108_precount_x
         
        LET g_sql="SELECT COUNT(*) FROM x "  
 
    PREPARE aimi108_precount FROM g_sql
    DECLARE aimi108_count CURSOR FOR aimi108_precount
 
END FUNCTION
 
FUNCTION aimi108_menu()
 
   WHILE TRUE
      CALL aimi108_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL aimi108_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL aimi108_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL aimi108_r()
            END IF
          WHEN "modify" 
             IF cl_chk_act_auth() THEN
               CALL aimi108_u()
             END IF
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL aimi108_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL aimi108_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL aimi108_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imc),'','')
            END IF
         
         #相關文件#
         WHEN "related_document"                       #No.FUN-680046
            IF cl_chk_act_auth() THEN
               IF g_imc01 IS NOT NULL THEN
                 LET g_doc.column1 = "imc01"
                 LET g_doc.column2 = "imc02"
                 LET g_doc.value1 = g_imc01
                 LET g_doc.value2 = g_imc02
                 CALL cl_doc()
               END IF 
            END IF
         
      END CASE
   END WHILE
END FUNCTION
 
   
FUNCTION aimi108_a()
  DEFINE  l_cnt  LIKE type_file.num10   #No.FUN-690026 INTEGER
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_imc.clear()
    INITIALIZE g_imc01 LIKE imc_file.imc01
    INITIALIZE g_imc02 LIKE imc_file.imc02
    LET g_imc01_t = NULL
    LET g_imc02_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL aimi108_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_rec_b = 0                    #No.FUN-680064
        IF g_ss='N' THEN
            CALL g_imc.clear()
#            LET g_rec_b = 0               #No.FUN-680064
        ELSE
            CALL aimi108_b_fill('1=1')          #單身
        END IF
        CALL aimi108_b()                        #輸入單身
        LET g_imc01_t = g_imc01                 #保留舊值
        LET g_imc02_t = g_imc02                 #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
   
FUNCTION aimi108_u()
  DEFINE  l_buf      LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(30)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imaacti matches'[Nn]' THEN 
       CALL cl_err(g_imc01,'mfg1000',0)
    END IF
    IF g_imc01 IS NULL OR g_imc02 IS NULL THEN 
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imc01_t = g_imc01
    LET g_imc02_t = g_imc02
    BEGIN WORK   #No.+205 mark 拿掉
    WHILE TRUE
        CALL aimi108_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_imc01=g_imc01_t
            LET g_imc02=g_imc02_t
            DISPLAY g_imc01 TO imc01               #單頭
                
            DISPLAY g_imc02 TO imc02               #單頭
                
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_imc01 != g_imc01_t OR g_imc02 != g_imc02_t 
           THEN   UPDATE imc_file SET imc01 = g_imc01,  #更新DB
                                      imc02 = g_imc02
                WHERE imc01 = g_imc01_t AND imc02 = g_imc02_t 
            IF SQLCA.sqlcode THEN
                LET l_buf = g_imc01 clipped,'+',g_imc02 clipped
#               CALL cl_err(l_buf,SQLCA.sqlcode,0) #No.FUN-660156 
                CALL cl_err3("upd","imc_file",g_imc01_t,g_imc02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660156
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION aimi108_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,   #a:輸入 u:更改  #No.FUN-690026 VARCHAR(1)
    l_buf           LIKE type_file.chr1000,#No.FUN-690026 VARCHAR(60)
    l_n             LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
    LET g_ss = 'Y'
    DISPLAY BY NAME g_imc01,g_imc02 
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT g_imc01,g_imc02  WITHOUT DEFAULTS  
        FROM imc01,imc02
 
#No.FUN-570110 --start                                                                                                              
        BEFORE INPUT                                                                                                                
             LET g_before_input_done = FALSE                                                                                        
             CALL i108_set_entry(p_cmd)                                                                                             
             CALL i108_set_no_entry(p_cmd)                                                                                          
             LET g_before_input_done = TRUE                                                                                         
#No.FUN-570110 --end  
       BEFORE FIELD imc01
         #-----------------No:MOD-970046 modify
         #IF g_argv1 IS NOT NULL AND g_argv1 != ' ' 
         # THEN  LET g_imc01 = g_argv1
          IF g_argv1 IS NOT NULL AND g_argv1 != ' ' AND cl_null(g_imc01)
           THEN  LET g_imc01 = g_argv1
         #-----------------No:MOD-970046 end
                   DISPLAY g_imc01 TO imc01 
                   CALL aimi108_imc01('d')
                   NEXT FIELD imc02
          END IF
	       IF g_sma.sma60 = 'Y'		# 若須分段輸入
	          THEN CALL s_inp5(6,12,g_imc01) RETURNING g_imc01
	               DISPLAY BY NAME g_imc01 
      	    END IF
 
       AFTER FIELD imc01 
           IF NOT cl_null(g_imc01) THEN
               IF (g_imc01_t IS NULL) OR (g_imc01_t != g_imc01) THEN
                   CALL aimi108_imc01('a')
                   IF g_chr = 'E' THEN
                      CALL cl_err(g_imc01,'mfg1015',0)
                      NEXT FIELD imc01
                   END IF
               END IF
           END IF
 
       AFTER FIELD imc02
            IF g_imc01 != g_imc01_t OR     #輸入後更改不同時值
               g_imc01_t IS NULL OR g_imc02 != g_imc02_t OR
               g_imc02_t IS NULL THEN
                  SELECT UNIQUE imc01,imc02 FROM imc_file
                      WHERE imc01=g_imc01 AND imc02=g_imc02
                    IF SQLCA.sqlcode THEN             #不存在, 新來的
                         IF p_cmd='a' THEN
                          LET g_ss='N'
                         END IF
                    ELSE IF p_cmd='u' THEN
                            LET l_buf = g_imc01 clipped,'+',g_imc02 clipped
                            CALL cl_err(l_buf,-239,0)
                            LET g_imc01=g_imc01_t
                            LET g_imc02=g_imc02_t
                            NEXT FIELD imc01
                         END IF
                  END IF
            END IF
             
        AFTER INPUT 
            LET l_flag = 'Y'
            IF INT_FLAG THEN EXIT INPUT END IF
            IF g_imc01 IS NULL OR g_imc01 = ' ' THEN 
               LET l_flag = 'N'
            END IF 
            IF g_imc02 IS NULL OR g_imc02 = ' ' THEN 
               LET l_flag = 'N'
            END IF 
            IF l_flag = 'N' THEN NEXT FIELD imc02 END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
        ON ACTION CONTROLP 
           CASE
              WHEN INFIELD(imc01) #料件編號
#FUN-AA0059 --Begin--
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ima"
                 LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"    #FUN-AB0025
                 LET g_qryparam.default1 = g_imc01
                 CALL cl_create_qry() RETURNING g_imc01
               # CALL q_sel_ima(FALSE, "q_ima", "", g_imc01, "", "", "", "" ,"",'' )  RETURNING g_imc01   #FUN-AB0025
#FUN-AA0059 --End--
                 DISPLAY BY NAME g_imc01 
                 NEXT FIELD imc01
           END CASE
 
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT 
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
        #-----END TQC-860018-----
 
    END INPUT
END FUNCTION
   
FUNCTION aimi108_imc01(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,     #No.FUN-690026 VARCHAR(1)
           l_ima05   LIKE ima_file.ima05,
           l_ima08   LIKE ima_file.ima08,
           l_ima25   LIKE ima_file.ima25,
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima03   LIKE ima_file.ima03,
           l_ima93   LIKE ima_file.ima93 
 
  LET g_chr = ' '
  IF g_imc01 IS NULL THEN 
     LET g_chr = 'E'
     LET l_ima02  = NULL   LET l_ima03 = NULL
     LET l_ima021 = NULL  
     LET l_ima05  = NULL   LET l_ima08 = NULL
     LET l_ima25  = NULL   LET l_ima93   = NULL
  ELSE SELECT ima02,ima021,ima03,ima05,ima08,ima25,ima93,
            imauser,imagrup,imamodu,imadate,imaacti
         INTO l_ima02,l_ima021,l_ima03,l_ima05,l_ima08,l_ima25,l_ima93,
              g_imauser,g_imagrup,g_imamodu,g_imadate,g_imaacti
         FROM ima_file 
         WHERE ima01 = g_imc01 
       IF SQLCA.sqlcode != 0
          THEN LET g_chr = 'E'
               LET l_ima02  = NULL   LET l_ima03 = NULL
               LET l_ima021 = NULL 
               LET l_ima05  = NULL   LET l_ima08 = NULL
               LET l_ima25  = NULL   LET l_ima93   = NULL
          ELSE IF g_imaacti matches'[Nn]' THEN 
                  LET g_chr = 'E'
               END IF
       END IF
  END IF
  LET g_s=l_ima93[8,8]
  IF g_chr = ' ' OR p_cmd = 'd' THEN 
   DISPLAY l_ima02 TO ima02     
   DISPLAY l_ima021 TO ima021     
   DISPLAY l_ima03 TO ima03     
   DISPLAY l_ima05 TO ima05     
   DISPLAY l_ima08 TO ima08     
   DISPLAY l_ima25 TO ima25     
   DISPLAY g_s TO FORMONLY.s 
   DISPLAY g_imauser TO imauser  
   DISPLAY g_imagrup TO imagrup  
   DISPLAY g_imamodu TO imamodu 
   DISPLAY g_imadate TO imadate 
   DISPLAY g_imaacti TO imaacti 
 END IF
END FUNCTION 
#Query 查詢
FUNCTION aimi108_q()
  DEFINE l_imc01 LIKE imc_file.imc01,
         l_imc02 LIKE imc_file.imc02,
         l_cnt   LIKE type_file.num10   #No.FUN-690026 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
   CALL g_imc.clear()
    CALL aimi108_curs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN aimi108_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_imc01 TO NULL
        INITIALIZE g_imc02 TO NULL
        INITIALIZE g_imc03 TO NULL
    ELSE
        LET l_cnt = 0
        OPEN aimi108_count
        FETCH aimi108_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL aimi108_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION aimi108_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式  #No.FUN-690026 VARCHAR(1)
    l_msg           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(40) 
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     aimi108_b_curs INTO g_imc01,g_imc02
        WHEN 'P' FETCH PREVIOUS aimi108_b_curs INTO g_imc01,g_imc02
        WHEN 'F' FETCH FIRST    aimi108_b_curs INTO g_imc01,g_imc02
        WHEN 'L' FETCH LAST     aimi108_b_curs INTO g_imc01,g_imc02
        WHEN '/' 
            IF (NOT g_no_ask) THEN
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump aimi108_b_curs INTO g_imc01,g_imc02
            LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        LET l_msg = g_imc01 clipped ,'+',g_imc02 clipped
        CALL cl_err(l_msg,SQLCA.sqlcode,0)
        INITIALIZE g_imc01 TO NULL  #TQC-6B0105
        INITIALIZE g_imc02 TO NULL  #TQC-6B0105
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
    #FUN-4C0053
    SELECT imauser,imagrup 
      INTO g_data_owner ,g_data_group
      FROM ima_file 
     WHERE ima01 = g_imc01
    #FUN-4C0053(end)
 
 
 
    CALL aimi108_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION aimi108_show()
  
    DISPLAY g_imc01 TO imc01               #單頭
    DISPLAY g_imc02 TO imc02               #單頭
    #圖形顯示
    CALL cl_set_field_pic("","","","","",g_imaacti)
    CALL aimi108_imc01('d')                   #單身
    CALL aimi108_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION aimi108_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_imc01 IS NULL THEN
        RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "imc01"      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "imc02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_imc01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_imc02       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM imc_file WHERE imc01 = g_imc01 AND imc02 = g_imc02
        IF SQLCA.sqlcode THEN
#          CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
           CALL cl_err3("del","imc_file",g_imc01,"",SQLCA.sqlcode,"",
                        "BODY DELETE",1)   #NO.FUN-640266 #No.FUN-660156
        ELSE
            COMMIT WORK
            CLEAR FORM
            CALL g_imc.clear()
            CALL g_imc.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            DROP TABLE x
#           EXECUTE i108_precount_x                  #No.TQC-720019
            PREPARE i108_precount_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i108_precount_x2                 #No.TQC-720019
            OPEN aimi108_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE aimi108_b_curs
               CLOSE aimi108_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH aimi108_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE aimi108_b_curs
               CLOSE aimi108_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN aimi108_b_curs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL aimi108_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET g_no_ask = TRUE
               CALL aimi108_fetch('/')
            END IF
        END IF
    END IF
END FUNCTION
 
#單身
FUNCTION aimi108_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用  #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態    #No.FUN-690026 VARCHAR(1)
    l_uflag         LIKE type_file.chr1,    #處理否      #No.FUN-690026 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否    #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否    #No.FUN-690026 SMALLINT
DEFINE l_ima151     LIKE ima_file.ima151    #FUN-B90105
DEFINE l_imaag      LIKE ima_file.imaag     #FUN-B90105
 
    LET g_action_choice = ""
    IF g_imc01 IS NULL OR g_imc02 IS NULL THEN #No:7672
        CALL cl_err('',-400,0)
        RETURN
    END IF
#TQC-C30181--mark--begin-- 
##FUN-B90105----add--begin---- 
#   IF s_industry('slk') THEN
#      SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file
#       WHERE ima01 = g_imc01 
#      IF l_ima151='N' AND l_imaag='@CHILD' THEN
#         CALL cl_err(g_imc01,'axm_665',1)
#         RETURN
#      END IF
#   END IF
##FUN-B90105----add--end---
#TQC-C30181--mark--end--

    LET l_uflag ='N'
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT imc03,imc04 ",
                       "   FROM imc_file ",
                       "   WHERE imc01 = ? ",
                       "    AND imc02 = ? ",
                       "    AND imc03 = ? ",
                       "    FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i108_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_imc WITHOUT DEFAULTS FROM s_imc.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_imc_t.* = g_imc[l_ac].*  #BACKUP
 
               BEGIN WORK
               OPEN i108_bcl USING g_imc01,g_imc02,g_imc_t.imc03
               IF STATUS THEN
                  CALL cl_err("OPEN i108_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
display g_imc01
display g_imc02
display g_imc_t.imc03
                  FETCH i108_bcl INTO g_imc[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_imc_t.imc03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  LET g_imc_t.*=g_imc[l_ac].*
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_imc[l_ac].* TO NULL      #900423
            LET g_imc_t.* = g_imc[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD imc03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            #CHI-790004..................begin
            IF cl_null(g_imc02) THEN
               LET g_imc02=' '
            END IF
            #CHI-790004..................end
            INSERT INTO imc_file(imc01,imc02,imc03,imc04)
                 VALUES(g_imc01,g_imc02,g_imc[l_ac].imc03,g_imc[l_ac].imc04)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_imc[l_ac].imc03,SQLCA.sqlcode,0)  #No.FUN-660156
               CALL cl_err3("ins","imc_file",g_imc01,"",SQLCA.sqlcode,"",
                            "",1)   #NO.FUN-660156
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               #更改料件主檔  
               IF l_uflag = 'N' THEN 
                # UPDATE ima_file SET ima93=SUBSTRING(ima93,1,7)+'Y',  #No.TQC-9B0021
                  UPDATE ima_file SET ima93=ima93[1,7] || 'Y',  #No.TQC-9B0021
                                      imamodu=g_user,
                                      imadate=g_today   
                    WHERE ima01 = g_imc01
                  IF SQLCA.SQLERRD[3] = 0 OR SQLCA.SQLCODE THEN 
#                    CALL cl_err(g_imc01,SQLCA.sqlcode,0) #No.FUN-660156
                     CALL cl_err3("upd","ima_file",g_imc01,"",SQLCA.sqlcode,"",
                                  "",1)   #NO.FUN-660156
                  ELSE 
                     LET l_uflag = 'Y'
                  END IF
               END IF
               display 'Y' TO FORMONLY.s
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE FIELD imc03                        # dgeeault 序號
           IF g_imc[l_ac].imc03 IS NULL OR g_imc[l_ac].imc03 = 0 THEN
               SELECT count(*) INTO g_cnt
                 FROM imc_file
                WHERE imc01 = g_imc01
                  AND imc02 = g_imc02
               SELECT max(imc03)+1 INTO g_imc[l_ac].imc03 
                 FROM imc_file
                WHERE imc01 = g_imc01 
                  AND imc02 = g_imc02 
               IF g_imc[l_ac].imc03 IS NULL THEN
                  LET g_imc[l_ac].imc03 = 1 
               END IF
           END IF
            
        AFTER FIELD imc03                        #check 序號是否重複
            IF g_imc[l_ac].imc03 IS NOT NULL AND
               (g_imc[l_ac].imc03 != g_imc_t.imc03 OR g_imc_t.imc03 IS NULL) THEN
               SELECT count(*) INTO l_n
                 FROM imc_file
                WHERE imc01 = g_imc01 AND imc02 = g_imc02
                  AND imc03 = g_imc[l_ac].imc03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_imc[l_ac].imc03 = g_imc_t.imc03
                  NEXT FIELD imc03
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_imc_t.imc03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM imc_file
                    WHERE imc01 = g_imc01 
                      AND imc02 = g_imc02
                      AND imc03 = g_imc_t.imc03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_imc_t.imc03,SQLCA.sqlcode,0) #No.FUN-660156
                    CALL cl_err3("del","imc_file",g_imc01,g_imc_t.imc03,SQLCA.sqlcode,"",
                                 "",1)   #NO.FUN-660156
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_imc[l_ac].* = g_imc_t.*
               CLOSE i108_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_imc[l_ac].imc03,-263,1)
               LET g_imc[l_ac].* = g_imc_t.*
            ELSE
                UPDATE imc_file SET
                              imc03 = g_imc[l_ac].imc03,
                              imc04 = g_imc[l_ac].imc04
                 WHERE imc01 = g_imc01 
                   AND imc02 = g_imc02 
                   AND imc03 = g_imc_t.imc03 
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_imc[l_ac].imc03,SQLCA.sqlcode,0) #No.FUN-660156
                    CALL cl_err3("upd","imc_file",g_imc01,g_imc_t.imc03,SQLCA.sqlcode,"",
                                 "",1)   #NO.FUN-660156
                    LET g_imc[l_ac].* = g_imc_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark
 
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_imc[l_ac].* = g_imc_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_imc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i108_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40030 Add
            CLOSE i108_bcl
            COMMIT WORK
 
       #ON ACTION CONTROLN
       #    CALL aimi108_b_askkey()
       #    EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(imc03) AND l_ac > 1 THEN
                LET g_imc[l_ac].* = g_imc[l_ac-1].*
                NEXT FIELD imc03
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
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------  
 
    END INPUT
 
   #start FUN-5A0029
    LET g_imamodu = g_user
    LET g_imadate = g_today
    UPDATE ima_file SET imamodu = g_imamodu,imadate = g_imadate
     WHERE ima01 = g_imc01
    DISPLAY g_imamodu TO imamodu
    DISPLAY g_imadate TO imadate
   #end FUN-5A0029
 
    CLOSE i108_bcl
#FUN-B90105----add--begin---- 
       IF s_industry('slk') THEN
          IF l_ima151='Y' THEN
             CALL i108_ins_imc()
          END IF
       END IF
#FUN-B90105----add--end---
    COMMIT WORK
END FUNCTION
#FUN-B90105----add--begin---- 
FUNCTION i108_ins_imc()
  DEFINE l_imx000 LIKE imx_file.imx000
  DEFINE l_sql    STRING
  DEFINE l_imc    RECORD LIKE imc_file.*

     LET l_sql="SELECT * FROM imc_file WHERE imc01='",g_imc01,"'"
     PREPARE imc_ins FROM l_sql
     DECLARE imc_ins_upd CURSOR FOR imc_ins

     DELETE FROM imc_file WHERE imc01 IN (SELECT imx000 FROM imx_file WHERE imx00=g_imc01)
     FOREACH imc_ins_upd INTO l_imc.*
        IF SQLCA.sqlcode THEN
           CALL cl_err3("del","imc_file",l_imc.imc01,"",SQLCA.sqlcode,"","",1)
           CONTINUE FOREACH
        END IF

        LET l_sql="SELECT imx000 FROM imx_file WHERE imx00='",l_imc.imc01,"'"
        PREPARE imc_ins1 FROM l_sql
        DECLARE imc_ins1_upd CURSOR FOR imc_ins1
        FOREACH imc_ins1_upd INTO l_imx000
            LET l_imc.imc01=l_imx000
            INSERT INTO imc_file VALUES(l_imc.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","imc_file",l_imc.imc01,"",SQLCA.sqlcode,"","",1)
               CONTINUE FOREACH
            END IF
        END FOREACH
     END FOREACH
END FUNCTION
#FUN-B90105----add--end---
   
FUNCTION aimi108_b_askkey()
DEFINE
    l_wc  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    CONSTRUCT l_wc ON imc03,imc04    #螢幕上取條件
       FROM s_imc[1].imc03,s_imc[1].imc04
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
    CALL aimi108_b_fill(l_wc)
END FUNCTION
 
FUNCTION aimi108_b_fill(p_wc)              #BODY FILL UP
DEFINE
    l_i   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_cnt LIKE type_file.num10,   #No.FUN-690026 INTEGER
    p_wc  LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(200)
 
    LET g_sql = "SELECT imc03,imc04 ",
                " FROM ima_file,imc_file ",
                " WHERE ima01=imc01 AND imc01 = '",g_imc01,"' AND ",
                " imc02 = '",g_imc02,"' AND ", p_wc CLIPPED ,
                " ORDER BY imc03"
    PREPARE aimi108_prepare2 FROM g_sql      #預備一下
    DECLARE imc_curs CURSOR FOR aimi108_prepare2
    CALL g_imc.clear()
    LET l_cnt = 1
    FOREACH imc_curs INTO g_imc[l_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_cnt = l_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_imc.deleteElement(l_cnt)
    LET g_rec_b=l_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET l_cnt = 0
END FUNCTION
 
FUNCTION aimi108_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_imc TO s_imc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
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
       ON ACTION modify
          LET g_action_choice="modify"
          EXIT DISPLAY
      ON ACTION first
         CALL aimi108_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL aimi108_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL aimi108_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL aimi108_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL aimi108_fetch('L')
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
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #圖形顯示
         CALL cl_set_field_pic("","","","","",g_imaacti)
 
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
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                  #No.FUN-680046  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
  
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------  
 
      #No.FUN-7C0050 add 
      &include "qry_string.4gl"
  
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION aimi108_copy()
DEFINE
    l_imc01,l_oldno1 LIKE imc_file.imc01,
    l_imc02,l_oldno2 LIKE imc_file.imc02,
    l_imc03          LIKE imc_file.imc03,
    l_cnt            LIKE type_file.num10,   #No.FUN-690026 INTEGER
    l_buf            LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(40)
    
    CALL cl_getmsg('copy',g_lang) RETURNING g_msg
    IF s_shut(0) THEN RETURN END IF
    IF g_imc01 IS NULL OR g_imc02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE   #FUN-580026
    CALL i108_set_entry('a')          #FUN-580026
    LET g_before_input_done = TRUE    #FUN-580026
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_imc01,l_imc02 FROM imc01,imc02
 
       BEFORE FIELD imc01
	       IF g_sma.sma60 = 'Y'		# 若須分段輸入
	          THEN CALL s_inp5(6,12,l_imc01) RETURNING l_imc01
	               DISPLAY l_imc01 TO imc01 
      	    END IF
        AFTER FIELD imc01
            IF l_imc01 IS NULL THEN
                NEXT FIELD imc01
            ELSE SELECT ima01 FROM ima_file 
                             WHERE ima01 = l_imc01
                               AND imaacti IN ('y','Y')
                 IF SQLCA.sqlcode != 0 THEN 
#                   CALL cl_err(l_imc01,'mfg0002',0) #No.FUN-660156 
                    CALL cl_err3("sel","ima_file",l_imc01,"","mfg0002","",
                                 "",1)   #NO.FUN-660156
                    NEXT FIELD imc01
                 END IF
            END IF
       AFTER FIELD imc02 
            SELECT count(*) INTO l_cnt FROM imc_file
                WHERE imc01 = l_imc01 
                  and imc02 = l_imc02 
            IF l_cnt > 0 THEN
                CALL cl_err(l_imc01,-239,0)
                NEXT FIELD imc01
            END IF
        ON ACTION CONTROLP 
           CASE
              WHEN INFIELD(imc01) #料件編號
#FUN-AA0059 --Begin--
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ima"
                 LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"   #FUN-AB0025
                 LET g_qryparam.default1 = l_imc01
                 CALL cl_create_qry() RETURNING l_imc01
#                 CALL FGL_DIALOG_SETBUFFER( l_imc01 )
               #  CALL q_sel_ima(FALSE, "q_ima", "", l_imc01, "", "", "", "" ,"",'' )  RETURNING l_imc01   #FUN-AB0025
#FUN-AA0059 --End--
                 DISPLAY BY NAME l_imc01 
                 NEXT FIELD imc01
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    LET l_buf = l_imc01 clipped,'+',l_imc02 clipped
    #CHI-790004..................begin
    IF cl_null(l_imc02) THEN
       LET l_imc02=' '
    END IF
    #CHI-790004..................end
    BEGIN WORK
    DROP TABLE x
    SELECT * FROM imc_file
        WHERE imc01 = g_imc01 AND imc02 = g_imc02 
        INTO TEMP x
    UPDATE x
        SET imc01=l_imc01,    #資料鍵值
            imc02=l_imc02
    INSERT INTO imc_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err('imc:',SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("ins","imc_file","","",SQLCA.sqlcode,"",
                    "",1)   #NO.FUN-660156
        ROLLBACK WORK
        RETURN
    END IF
    COMMIT WORK
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_buf,') O.K'
        
     LET l_oldno1 = g_imc01
     LET l_oldno2 = g_imc02
     LET g_imc01  = l_imc01
     LET g_imc02  = l_imc02
     CALL aimi108_u()
     CALL aimi108_b()
     #LET g_imc01  = l_oldno1  #FUN-C30027
     #LET g_imc02  = l_oldno2  #FUN-C30027
     CALL aimi108_show()
END FUNCTION
 
FUNCTION aimi108_out()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-690026 SMALLINT
    sr              RECORD
        imc01       LIKE imc_file.imc01,   #料件編號
        ima02       LIKE ima_file.ima02,   #品名規格
        ima021      LIKE ima_file.ima021,  #品名規格
        imc02       LIKE imc_file.imc02,   #說明性質
        imc03       LIKE imc_file.imc03,   #行序
        imc04       LIKE imc_file.imc04    #說明
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
    l_za05          LIKE za_file.za05      #No.FUN-690026 VARCHAR(40)
 
    IF cl_null(g_wc) THEN 
        LET g_wc="     imc01='",g_imc01,"'",
                 " AND imc02='",g_imc02,"'" 
    END IF
    IF cl_null(g_imc01) THEN
        CALL cl_err('','9057',0) 
        RETURN 
    END IF
    CALL cl_wait()
    #LET l_name = 'aimi108.out'                  #No.FUN-840029
    #CALL cl_outnam('aimi108') RETURNING l_name  #No.FUN-840029
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimi108' #No.FUN-840029
    LET g_sql="SELECT imc01,ima02,ima021,imc02,imc03,imc04",
              " FROM imc_file,ima_file ",  # 組合出 SQL 指令
              " WHERE imc01= ima01 AND ",g_wc CLIPPED
    #No.FUN-840029---Begin 
    #PREPARE aimi108_p1 FROM g_sql                # RUNTIME 編譯
    #DECLARE aimi108_curo                         # CURSOR
    #    CURSOR FOR aimi108_p1
 
    #START REPORT aimi108_rep TO l_name
 
    #FOREACH aimi108_curo INTO sr.*
    #    IF SQLCA.sqlcode THEN
    #        CALL cl_err('foreach:',SQLCA.sqlcode,1)
    #        EXIT FOREACH
    #        END IF
    #    OUTPUT TO REPORT aimi108_rep(sr.*)
    #END FOREACH
 
    #FINISH REPORT aimi108_rep
 
    #CLOSE aimi108_curo
    #ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'imc01,imc02,imc03,imc04                              
                         ,imauser,imamodu,imaacti,imagrup,imadate')             
       RETURNING g_str                                                          
    END IF                                                                      
    CALL cl_prt_cs1('aimi108','aimi108',g_sql,g_str)                            
    #No.FUN-840029---End  
END FUNCTION
 
#No.FUN-840029---Begin
#REPORT aimi108_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
#   sr              RECORD
#       imc01       LIKE imc_file.imc01,   #產品編號
#       ima02       LIKE ima_file.ima02,   #產品名稱
#       ima021      LIKE ima_file.ima021,  #產品名稱
#       imc02       LIKE imc_file.imc02,   #說明性質
#       imc03       LIKE imc_file.imc03,   #行序
#       imc04       LIKE imc_file.imc04    #說明
#                   END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.imc01,sr.imc02,sr.imc03
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno" 
#           PRINT g_head CLIPPED,pageno_total     
#           PRINT ' '
#           PRINT g_dash
#           PRINT g_x[11] clipped, sr.imc01
#           PRINT g_x[12] clipped, sr.ima02
#           PRINT COLUMN 10, sr.ima021
#           PRINT ' '
#           PRINT g_x[31],g_x[32],g_x[33]
#           PRINT g_dash1 
#           LET l_trailer_sw = 'n'
 
#       BEFORE GROUP OF sr.imc01  #料件編號
#           SKIP TO TOP OF PAGE
 
#       BEFORE GROUP OF sr.imc02
#           PRINT COLUMN g_c[31],sr.imc02;
#            
#       ON EVERY ROW
#           PRINT COLUMN g_c[32],sr.imc03 using '###&',
#                 COLUMN g_c[33],sr.imc04
 
#       AFTER GROUP OF sr.imc01  #料件編號
#           PRINT g_dash
 
#       ON LAST ROW
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-840029---End 
 
#No.FUN-570110 --start                                                                                                              
FUNCTION i108_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                               #No.FUN-690026 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("imc01,imc02",TRUE)                                                                                     
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i108_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                               #No.FUN-690026 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("imc01,imc02",FALSE)                                                                                    
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
#No.FUN-570110 --end                                                                                                                
                       
