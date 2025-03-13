# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimq840.4gl
# Descriptions...: 料件在外明細查詢
# Date & Author..: 93/07/14 By Nick
# Modify.........: No.MOD-480138 04/08/13 By Nicola 未秀資料筆數
# Modify.........: No.FUN-4A0040 04/10/06 By Echo 工單編號,投入料號,生產料號開窗
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: NO.MOD-510125 05/01/18 by ching EF簽核納入
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-5C0086 06/01/05 By Sarah 如aimi100依asms290設定動態DISPLAY單位管制方式,第二單位
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-710032 07/01/12 By Smapmin 雙單位畫面調整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-7A0112 07/10/31 By Judy msv需求，用到rowid的地方加入key值字段
# Modify.........: No.MOD-870174 08/07/15 By claire 條件給予工單號或投入料號，抓取資料的sql有問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2)
# Modify.........: No.TQC-C80095 12/08/15 By qiull 去掉單身的空值列，在b_fill中加CALL g_sr.deleteElement(g_cnt)
# Modify.........: No.MOD-CC0270 13/01/08 By Elise 參考saimq841修正公式
 
DATABASE ds
 
GLOBALS "../../config/top.global"
  DEFINE g_argv1      LIKE ima_file.ima01    # 所要查詢的key
  DEFINE g_wc,g_wc2   STRING                 # WHERE CONDICTION  #No.FUN-580092 HCN
  DEFINE g_sql        STRING                 #No.FUN-580092 HCN
  DEFINE g_rec_b      LIKE type_file.num5    #No.FUN-690026 SMALLINT
  DEFINE g_ima        RECORD
                      sfb01     LIKE sfb_file.sfb01,  #工單編號
                      sfb05     LIKE sfb_file.sfb05,  #生產料號
                      unfinish  LIKE sfb_file.sfb08,  #未完成量
                      sfa03     LIKE sfa_file.sfa03,  #料號
                      ima02     LIKE ima_file.ima02,  #品名
                      ima021    LIKE ima_file.ima021, #品名
                      ima25     LIKE ima_file.ima25,  #單位
#                     ima26     LIKE ima_file.ima26,  #庫存量         #FUN-A20044
                      avl_stk_mpsmrp LIKE type_file.num15_3,          #FUN-A20044 
                      ima906    LIKE ima_file.ima906, #單位管制方式   #FUN-5C0086 mark
                      ima907    LIKE ima_file.ima907  #第二單位       #FUN-5C0086
                      END RECORD
  DEFINE g_ima01     LIKE ima_file.ima01          #TQC-7A0112
  DEFINE g_sr         DYNAMIC ARRAY OF RECORD
                      ds_date  LIKE type_file.dat,      #No.FUN-690026 DATE
                      ds_class   LIKE type_file.chr20,    #No.FUN-690026 VARCHAR(8)
                      ds_no      LIKE sfa_file.sfa01,     #No.FUN-690026 VARCHAR(10)
                      ds_cust    LIKE pmm_file.pmm09,
                      ds_qlty    LIKE rpc_file.rpc13,
                      ds_total   LIKE rpc_file.rpc13
                      END RECORD
  DEFINE g_order      LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8         #No.FUN-6A0074
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   
    CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
 
    LET g_argv1 = ARG_VAL(1)
#--------------------temp table------
    DROP TABLE aim_temp
    #No.FUN-690026  --Begin
    #CREATE TEMP TABLE aim_temp
    #(
    #    ds_date         DATE,
    #    ds_class        VARCHAR(8),
    #    ds_no           VARCHAR(10),
    #    ds_cust         VARCHAR(10),
    #    ds_qlty         DECIMAL(12,3),
    #    ds_total        DECIMAL(12,3)
    #)
    CREATE TEMP TABLE aim_temp(
      ds_date    LIKE type_file.dat,   
      ds_class   LIKE type_file.chr20, 
      ds_no      LIKE sfa_file.sfa01,
      ds_cust    LIKE pmm_file.pmm09,
      ds_qlty    LIKE rpc_file.rpc13,
      ds_total   LIKE rpc_file.rpc13)
    #No.FUN-690026  --End  
    IF STATUS THEN
       CALL cl_err('Create aim_temp: ',STATUS,1)
       RETURN
    END IF
#-------end------------------
 
    OPEN WINDOW q840_w AT p_row,p_col
         WITH FORM "aim/42f/aimq840"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #-----TQC-710032---------
   CALL q840_mu_ui()
   ##start FUN-5C0086
   # CALL cl_set_comp_visible("ima906",g_sma.sma115 = 'Y')
   # CALL cl_set_comp_visible("group043",g_sma.sma115 = 'Y')
   # CALL cl_set_comp_visible("ima907",g_sma.sma115 = 'Y')
   # CALL cl_set_comp_visible("group044",g_sma.sma115='Y')
   # IF g_sma.sma122='1' THEN
   #    CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
   #    CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   # END IF
   # IF g_sma.sma122='2' THEN
   #    CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
   #    CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   # END IF
   ##end FUN-5C0086
   #-----END TQC-710032-----
 
#    IF cl_chk_act_auth() THEN
#       CALL q840_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q840_q() END IF
 
    CALL q840_menu()
    CLOSE WINDOW q840_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
FUNCTION q840_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   IF g_argv1 != ' '
      THEN LET g_wc = "ima01 = '",g_argv1,"'"
		   LET g_wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_sr.clear()
           CALL cl_opmsg('q')
           CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
           CONSTRUCT BY NAME g_wc ON sfb01,sfa03,ima02,ima021,sfb05
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
 
 
              #### No.FUN-4A0041
              ON ACTION controlp
                  CASE
 
                     WHEN INFIELD(sfb01)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_sfb9"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO sfb01
                      NEXT FIELD sfb01
 
                     WHEN INFIELD(sfa03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_ima"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO sfb03
                      NEXT FIELD sfb03
 
                     WHEN INFIELD(sfb05)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_ima"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO sfb05
                      NEXT FIELD sfb05
                  END CASE
              ### END  No.FUN-4A0041
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           IF INT_FLAG THEN RETURN END IF
		   LET g_wc2=" 1=1 "
   END IF
 
   MESSAGE ' WAIT '
  #start FUN-5C0086
  #LET g_sql=" SELECT sfb01,sfb05,sfb08-sfb09,sfa03,ima02,ima021,ima25,ima26 ",
   LET g_sql=" SELECT sfb01,sfb05,sfb08-sfb09,sfa03,ima02,ima021,",
#            "        ima25,ima26,ima906,ima907,ima01 ", #TQC-7A0112   #FUN-A20044
             "        ima25,'',ima906,ima907,ima01 ",                  #FUN-A20044    
  #end FUN-5C0086
             " FROM sfa_file,sfb_file,ima_file",
             " WHERE sfa01=sfb01 AND ima01 = sfa03 AND sfb87!='X' AND ",g_wc CLIPPED
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY sfb01"
   PREPARE q840_prepare FROM g_sql
   DECLARE q840_cs SCROLL CURSOR FOR q840_prepare
 
    #-----No.MOD-480138-----
 #MOD-870174--begin--
   #LET g_sql="SELECT COUNT(DISTINCT sfb01) FROM sfb_file WHERE ",
   #          "sfb87!='X' AND ",g_wc CLIPPED
   LET g_sql="SELECT COUNT(*) ",                                                                                             
              "  FROM sfa_file,sfb_file ",                                                                                          
              " WHERE sfb87!='X'",                                                                                                  
              "   AND sfa01=sfb01",                                                                                                 
              "   AND ",g_wc CLIPPED 
 #MOD-870174--end----
   PREPARE q840_precount FROM g_sql
   DECLARE q840_count CURSOR FOR q840_precount
 
   OPEN q840_count
   FETCH q840_count INTO g_row_count
   CLOSE q840_count
   #-----END---------------
END FUNCTION
 
FUNCTION q840_b_askkey()
   CONSTRUCT g_wc2 ON ds_no FROM s_sr[1].ds_no
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
 
FUNCTION q840_menu()
 
   WHILE TRUE
      CALL q840_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q840_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sr),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q840_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
     DISPLAY '   ' TO FORMONLY.cnt   #No.MOD-480138
    CALL q840_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
     #-----No.MOD-480138-----
    OPEN q840_count
    FETCH q840_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    #-----END---------------
    OPEN q840_cs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('q840_q:',SQLCA.sqlcode,0)
    ELSE
        CALL q840_fetch('F')                #讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q840_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690026 INTEGER
   ,l_avl_stk_mpsmrp LIKE type_file.num15_3,              #No.FUN-A20044
    l_unavl_stk      LIKE type_file.num15_3,              #No.FUN-A20044
    l_avl_stk        LIKE type_file.num15_3               #No.FUN-A20044
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q840_cs INTO g_ima.*,g_ima01 #TQC-7A0112
        WHEN 'P' FETCH PREVIOUS q840_cs INTO g_ima.*,g_ima01 #TQC-7A0112
        WHEN 'F' FETCH FIRST    q840_cs INTO g_ima.*,g_ima01 #TQC-7A0112
        WHEN 'L' FETCH LAST     q840_cs INTO g_ima.*,g_ima01 #TQC-7A0112
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
            FETCH ABSOLUTE l_abso q840_cs INTO g_ima.*,g_ima01 #TQC-7A0112
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('Fetch:',SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
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
     
    CALL s_getstock(g_ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   #FUN-A20044
    LET g_ima.avl_stk_mpsmrp = l_avl_stk_mpsmrp                                 #FUN-A20044          
    CALL q840_show()
END FUNCTION
 
FUNCTION q840_show()
   DISPLAY BY NAME g_ima.sfb01,g_ima.sfb05,
		   g_ima.unfinish,g_ima.sfa03,
		   g_ima.ima02,g_ima.ima021,g_ima.ima25,
#		   g_ima.ima26                 #FUN-A20044
                   g_ima.avl_stk_mpsmrp        #FUN-A20044
                  ,g_ima.ima906,g_ima.ima907   #FUN-5C0086
   CALL q840_b_fill() #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q840_b_fill()              #BODY FILL UP
   DEFINE l_sql LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
#         l_sum LIKE ima_file.ima26,    #MOD-530179      #FUN-A20044
          l_sum LIKE type_file.num15_3,                  #FUN-A20044             
          tm    RECORD
                ds_date         LIKE type_file.dat,      #No.FUN-690026 DATE
                ds_class        LIKE type_file.chr20,    #No.FUN-690026 VARCHAR(8)
                ds_no           LIKE sfa_file.sfa01,     #No.FUN-690026 VARCHAR(10)
                ds_cust         LIKE pmm_file.pmm09,
#        	ds_qlty		LIKE ima_file.ima26, #MOD-530179    #FUN-A20044
#	        ds_total	LIKE ima_file.ima26  #MOD-530179    #FUN-A20044
                ds_qlty         LIKE type_file.num15_3,             #FUN-A20044
                ds_total        LIKE type_file.num15_3              #FUN-A20044 
            	END RECORD
 
   DELETE FROM aim_temp   #bugno:3585 清除temp table資料
 
    #------------------獨立需求---------------------------
    DECLARE q840_bcs1 CURSOR WITH HOLD FOR
		 SELECT rpc12,'',rpc02,'',(rpc13-rpc131)*rpc16_fac,''
		  FROM rpc_file
		  WHERE rpc01=g_ima.sfa03 AND (rpc13-rpc131) > 0
                  ORDER BY 1
    #------------------訂單需求---------------------------
    DECLARE q840_bcs2 CURSOR WITH HOLD FOR
		#SELECT oeb15,'',oeb01,oea03,(oeb12-oeb24)*oeb05_fac,''                #MOD-CC0270 mark
                 SELECT oeb15,'',oeb01,oea03,(oeb12-oeb24+oeb25-oeb26)*oeb05_fac,''    #MOD-CC0270
		   FROM oea_file,oeb_file
		  WHERE oea01 = oeb01
		   #AND (oeb12-oeb24) > 0             #MOD-CC0270 mark
                    AND (oeb12-oeb24+oeb25-oeb26) >0  #MOD-CC0270
#	    AND oeb70 ='N' AND g_ima.sfa03 = oeb04
		    AND oeb70 ='N' AND oeb04=g_ima.sfa03
                   #AND oeaconf !='X' #mandy 01/08/07 #MOD-CC0270 mark
                    AND oeaconf = 'Y' #MOD-CC0270
                    ORDER BY 1
    IF STATUS THEN CALL cl_err('Decl bcs2',STATUS,1) END IF
    #------------------備料需求---------------------------
    DECLARE q840_bcs3 CURSOR WITH HOLD FOR
#		 SELECT sfb13,'',sfa01,'',(sfa05-sfa06-sfa065-sfa061)*sfa13,''      #FUN-A60027 mark
               # SELECT sfb13,'',sfa01,'',SUM((sfa05-sfa06-sfa065-sfa061)*sfa13),'' #FUN-A60027 #MOD-CC0270 mark
                 SELECT sfb13,'',sfa01,'',SUM((sfa05-sfa06-sfa065+sfa063-sfa062)*sfa13),''      #MOD-CC0270
                   FROM sfa_file,sfb_file
                   WHERE sfa01 = sfb01 AND sfb04 NOT IN ('6','7','8')
                     AND g_ima.sfa03 = sfa03 AND (sfa05-sfa06-sfa061-sfa065)>0
                     AND sfb87!='X'
                   GROUP BY sfab13,sfa01       #FUN-A60027
                   ORDER BY 1
    #----------------工單生產供給--------------------------
    DECLARE q840_bcs4 CURSOR WITH HOLD FOR
		 SELECT sfb15,'',sfb01,'',(sfb08-sfb09)*ima55_fac,''
                   FROM sfb_file,ima_file
                  WHERE sfb04 NOT IN ('6','7','8')
                    AND g_ima.sfa03 = sfb05 AND (sfb08-sfb09)>0
                    AND sfb87!='X' AND sfb05=ima01
                  ORDER BY 1
    #----------------採購供給------------------------------
    DECLARE q840_bcs5 CURSOR WITH HOLD FOR
	# SELECT pmn33,'',pmn01,pmm09,pmn20-pmn50-pmn58,''
		#SELECT pmn33,'',pmn01,pmm09,(pmn20-pmn50)*pmn09,''   #No+032    #MOD-CC0270 mark
                 SELECT pmn33,'',pmn01,pmm09,(pmn20-pmn50+pmn55+pmn58)*pmn09,''  #MOD-CC0270
                   FROM pmn_file,pmm_file
                  WHERE pmn01=pmm01
                    #AND pmn16 matches '[12]'
                     #MOD-510125
                    AND ( pmn16 <='2' OR pmn16='S' OR pmn16='R' OR pmn16='W')
                    #--
                  # AND g_ima.sfa03 = pmn04 AND (pmn20-pmn50-pmn58)>0
                  # AND g_ima.sfa03 = pmn04 AND (pmn20-pmn50)>0   #NO.+032    #MOD-CC0270 mark
                    AND g_ima.sfa03 = pmn04 AND pmn20 -(pmn50-pmn55-pmn58)>0  #MOD-CC0270
                  ORDER BY 1
    #--------------- IQC供給 ------------------------------
    DECLARE q840_bcs6 CURSOR WITH HOLD FOR
       #SELECT rva06,'IQC',rvb01,pmc03,rvb31*pmn09,''  #MOD-CC0270 mark
        SELECT rva06,'IQC',rvb01,pmc03,(rvb07-rvb29-rvb30)*pmn09,''  #MOD-CC0270
          FROM pmn_file,rvb_file, rva_file, OUTER pmc_file
         WHERE rvb05 = g_ima.sfa03
           AND rvb01 = rva01 AND rva_file.rva05 = pmc_file.pmc01
          #AND rvb31 >  0             #MOD-CC0270 mark
           AND rvaconf='Y' AND rvb04=pmn01 AND rvb03=pmn02
           AND rvb07 > (rvb29+rvb30)  #MOD-CC0270 add
         ORDER BY 1
    #--------------- FQC供給 -----------------------------
    DECLARE q840_bcs7 CURSOR WITH HOLD FOR
        SELECT qcf04,'FQC',qcf01,'',qcf22*ima55_fac,''
          FROM qcf_file,sfb_file,ima_file
         WHERE qcf22 > 0  AND qcf14 <> 'X'
          AND sfb01 = qcf02
          AND sfb05 = g_ima.sfa03 
          AND sfb02 <> '7' AND sfb02 <> '8' AND sfb02 <> '11'  #MOD-CC0270 add
          AND sfb04 <'8' AND sfb11 > 0   #MOD-CC0270 add
          AND sfb87!='X' AND qcf021=ima01
         ORDER BY 1
    #--------------- END ---------------------------------
 
  # display '.' at 2,1
    FOREACH q840_bcs1 INTO tm.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('F1:',SQLCA.sqlcode,1)
            RETURN
        END IF
        CASE g_lang
          WHEN '0'
            LET tm.ds_class = '獨立性需求'
          WHEN '2'
            LET tm.ds_class = '獨立性需求'
          OTHERWISE
            LET tm.ds_class = 'Indep Dem'
        END CASE
        LET tm.ds_qlty = -tm.ds_qlty
#       LET g_ima.ima26 = g_ima.ima26 + tm.ds_qlty           #FUN-A20044
#       LET tm.ds_total = g_ima.ima26                        #FUN-A20044
        LET g_ima.avl_stk_mpsmrp = g_ima.avl_stk_mpsmrp + tm.ds_qlty           #FUN-A20044
        LET tm.ds_total = g_ima.avl_stk_mpsmrp                                 #FUN-A20044
        INSERT INTO aim_temp VALUES (tm.*)      #bugno:3585
        IF SQLCA.sqlcode THEN
#            CALL cl_err('INSERT-F1:',SQLCA.sqlcode,1)
            CALL cl_err3("ins","aim_temp",tm.ds_date,"",SQLCA.sqlcode,"",
                         "INSERT-F1",1)   #NO.FUN-640266 #No.FUN-660156
            RETURN
        END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
 
 #  display '..' at 2,1
    FOREACH q840_bcs2 INTO tm.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('F2:',SQLCA.sqlcode,1)
            RETURN
        END IF
        CASE g_lang
          WHEN '0'
            LET tm.ds_class = '訂    單'
          WHEN '2'
            LET tm.ds_class = '訂    單'
          OTHERWISE
            LET tm.ds_class = 'OM  S/O '
        END CASE
        LET tm.ds_qlty = -tm.ds_qlty
#       LET g_ima.ima26 = g_ima.ima26 + tm.ds_qlty      #FUN-A20044
#       LET tm.ds_total = g_ima.ima26                   #FUN-A20044
        LET g_ima.avl_stk_mpsmrp = g_ima.avl_stk_mpsmrp + tm.ds_qlty      #FUN-A20044
        LET tm.ds_total = g_ima.avl_stk_mpsmrp                            #FUN-A20044
        INSERT INTO aim_temp VALUES (tm.*)       #bugno:3585
        IF SQLCA.sqlcode THEN
#           CALL cl_err('INSERT-F2:',SQLCA.sqlcode,1)
            CALL cl_err3("ins","aim_temp",tm.ds_date,"",SQLCA.sqlcode,"",
                         "INSERT-F2",1)   #NO.FUN-640266 #No.FUN-660156
            RETURN
        END IF
    END FOREACH
 
#   display '...' at 2,1
    FOREACH q840_bcs3 INTO tm.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('F3:',SQLCA.sqlcode,1)
          RETURN
       END IF
       CASE g_lang
          WHEN '0'
             LET tm.ds_class = '工單備料'
          WHEN '2'
             LET tm.ds_class = '工單備料'
          OTHERWISE
             LET tm.ds_class = 'W/O Plac'
       END CASE
       LET tm.ds_qlty = -tm.ds_qlty
#      LET g_ima.ima26 = g_ima.ima26 + tm.ds_qlty           #FUN-A20044
#      LET tm.ds_total = g_ima.ima26                        #FUN-A20044
       LET g_ima.avl_stk_mpsmrp = g_ima.avl_stk_mpsmrp + tm.ds_qlty           #FUN-A20044
       LET tm.ds_total = g_ima.avl_stk_mpsmrp                                 #FUN-A20044
       INSERT INTO aim_temp VALUES (tm.*)       #bugno:3585
       IF SQLCA.sqlcode THEN
#         CALL cl_err('INSERT-F3:',SQLCA.sqlcode,1)
          CALL cl_err3("ins","aim_temp",tm.ds_date,"",SQLCA.sqlcode,"",
                       "INSERT-F3",1)   #NO.FUN-640266 #No.FUN-660156
          RETURN
       END IF
    END FOREACH
 
#   display '....' at 2,1
    FOREACH q840_bcs4 INTO tm.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('F4:',SQLCA.sqlcode,1)
          RETURN
       END IF
       CASE g_lang
          WHEN '0'
             LET tm.ds_class = '工單生產'
          WHEN '2'
             LET tm.ds_class = '工單生產'
          OTHERWISE
             LET tm.ds_class = 'W/O Prod'
       END CASE
#      LET g_ima.ima26 = g_ima.ima26 + tm.ds_qlty     #FUN-A20044
#      LET tm.ds_total = g_ima.ima26                  #FUN-A20044
       LET g_ima.avl_stk_mpsmrp = g_ima.avl_stk_mpsmrp + tm.ds_qlty     #FUN-A20044
       LET tm.ds_total = g_ima.avl_stk_mpsmrp                           #FUN-A20044
       INSERT INTO aim_temp VALUES (tm.*)       #bugno:3585
       IF SQLCA.sqlcode THEN
         #CALL cl_err('INSERT-F4:',SQLCA.sqlcode,1)
          CALL cl_err3("ins","aim_temp",tm.ds_date,"",SQLCA.sqlcode,"",
                       "INSERT-F4",1)   #NO.FUN-640266  #No.FUN-660156
          RETURN
       END IF
    END FOREACH
 
#   display '.....' at 2,1
    FOREACH q840_bcs5 INTO tm.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('F5:',SQLCA.sqlcode,1)
            RETURN
        END IF
        CASE g_lang
          WHEN '0'
            LET tm.ds_class = '採購對外'
          WHEN '2'
            LET tm.ds_class = '採購對外'
          OTHERWISE
            LET tm.ds_class = 'Purchase'
        END CASE
#       LET g_ima.ima26 = g_ima.ima26 + tm.ds_qlty    #FUN-A20044
#       LET tm.ds_total = g_ima.ima26                 #FUN-A20044
        LET g_ima.avl_stk_mpsmrp = g_ima.avl_stk_mpsmrp + tm.ds_qlty    #FUN-A20044
        LET tm.ds_total = g_ima.avl_stk_mpsmrp                          #FUN-A20044 
        INSERT INTO aim_temp VALUES (tm.*)       #bugno:3585
        IF SQLCA.sqlcode THEN
            #CALL cl_err('INSERT-F5:',SQLCA.sqlcode,1)
            CALL cl_err3("ins","aim_temp",tm.ds_date,"",SQLCA.sqlcode,"",
                         "INSERT-F5",1)   #NO.FUN-640266 #No.FUN-660156
            RETURN
        END IF
    END FOREACH
 
#   display '....:' at 2,1
    FOREACH q840_bcs6 INTO tm.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('F6:',SQLCA.sqlcode,1)
            RETURN
        END IF
        CASE g_lang
          WHEN '0'
            LET tm.ds_class = '採購在驗'
          WHEN '2'
            LET tm.ds_class = '採購在驗'
          OTHERWISE
            LET tm.ds_class = 'IQC     '
        END CASE
#       LET g_ima.ima26 = g_ima.ima26 + tm.ds_qlty     #FUN-A20044
#	LET tm.ds_total = g_ima.ima26                  #FUN-A20044
        LET g_ima.avl_stk_mpsmrp = g_ima.avl_stk_mpsmrp + tm.ds_qlty     #FUN-A20044
        LET tm.ds_total = g_ima.avl_stk_mpsmrp                           #FUN-A20044  
        INSERT INTO aim_temp VALUES (tm.*)       #bugno:3585
        IF SQLCA.sqlcode THEN
#           CALL cl_err('INSERT-F6:',SQLCA.sqlcode,1)
            CALL cl_err3("ins","aim_temp",tm.ds_date,"",SQLCA.sqlcode,"",
                         "INSERT-F6",1)   #NO.FUN-640266 #No.FUN-660156
            RETURN
        END IF
    END FOREACH
 
#   display '...::' at 2,1
    FOREACH q840_bcs7 INTO tm.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('F7:',SQLCA.sqlcode,1)
            RETURN
        END IF
        CASE g_lang
          WHEN '0'
            LET tm.ds_class = '工單在驗'
          WHEN '2'
            LET tm.ds_class = '工單在驗'
          OTHERWISE
            LET tm.ds_class = 'FQC     '
        END CASE
#       LET g_ima.ima26 = g_ima.ima26 + tm.ds_qlty       #FUN-A20044
#       LET tm.ds_total = g_ima.ima26                    #FUN-A20044
        LET g_ima.avl_stk_mpsmrp = g_ima.avl_stk_mpsmrp + tm.ds_qlty       #FUN-A20044
        LET tm.ds_total = g_ima.avl_stk_mpsmrp                             #FUN-A20044
        INSERT INTO aim_temp VALUES (tm.*)       #bugno:3585
        IF SQLCA.sqlcode THEN
            #CALL cl_err('INSERT-F7:',SQLCA.sqlcode,1)
            CALL cl_err3("ins","aim_temp",tm.ds_date,"",SQLCA.sqlcode,"",
                         "INSERT-F7",1)   #NO.FUN-640266
            RETURN
        END IF
    END FOREACH
 
    FOR g_cnt = 1 TO g_sr.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_sr[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET l_sum = 0
 
#----- #bugno:3585-----------
    DECLARE q840_bcstm CURSOR WITH HOLD FOR SELECT * FROM aim_temp ORDER BY 1
    FOREACH q840_bcstm INTO g_sr[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('TM:',SQLCA.sqlcode,1)
            RETURN
        END IF
        LET l_sum=l_sum+g_sr[g_cnt].ds_qlty
        LET g_sr[g_cnt].ds_total=l_sum
        LET g_cnt = g_cnt + 1
#       IF g_cnt > g_sr_arrno THEN
#          CALL cl_err('',9035,0)
#          EXIT FOREACH
#       END IF
    END FOREACH
#---------------------
    CALL g_sr.deleteElement(g_cnt)     #TQC-C80095
    LET g_rec_b = (g_cnt-1)
     DISPLAY g_rec_b TO FORMONLY.cn2   #No.MOD-480138
END FUNCTION
 
 
FUNCTION q840_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   #CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sr TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
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
         CALL q840_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q840_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q840_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q840_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q840_fetch('L')
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
         CALL q840_mu_ui()   #TQC-710032
 
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
#        LET l_ac = ARR_CURR()
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
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------  
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#-----TQC-710032---------
FUNCTION q840_mu_ui()
   CALL cl_set_comp_visible("ima906",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("group043",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("ima907",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("group044",g_sma.sma115='Y')
   IF g_sma.sma122='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   END IF
   IF g_sma.sma122='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   END IF
END FUNCTION
#-----END TQC-710032-----
 
