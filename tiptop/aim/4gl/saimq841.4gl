# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: aimq841.4gl
# Descriptions...: 料件供需明細查詢
# Date & Author..: 94/07/14 By Nick
# Modify....2.0版: 95/11/06 By Danny (加判斷確認碼為'Y')
#                  By Melody    修改查詢時 display 之內容及計算方式
# Modify.........: 97/07/30 By Melody ogb19 取消
# No.B551 拿掉狀態顯示欄位, 因為原程式亦未讀取資料無意義
# Modify.........: No.MOD-480304 04/08/13 By Carol 供需明細(+/-) 資料錯誤
# Modify.........: No.MOD-490145 04/09/13 By Smapmin 顯示單身筆數
# Modify.........: No.FUN-4A0041 04/10/06 By Echo 料號開窗
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.MOD-530804 05/03/29 By kim pml16請購狀況應考慮easyflow的狀態如"簽核中"應納入
# Modify.........: No.FUN-550029 05/05/30 By vivien 單據編號格式放大
# Modify.........: No.MOD-5B0174 05/11/23 By Sarah g_argv2(料號)應放大到40碼
# Modify.........: No.FUN-5C0046 05/12/19 By kim 採購量需考慮easyflow的狀態如"簽核中"應納入
# Modify.........: No.FUN-5C0086 06/01/05 By Sarah 如aimi100依asms290設定動態DISPLAY單位管制方式,第二單位
# Modify.........: No.TQC-640132 06/04/17 By Nicola 原廠商交貨日期(pml33)改為以到庫日期(pml35)計算
# Modify.........: No.MOD-650078 06/05/17 By Claire sfb81->sfb15
# Modify.........: No.FUN-570018 06/05/25 By Sarah 第429行: oeb12-oeb24 => oeb12-oeb24+oeb25-oeb26
# Modify.........: No.TQC-660123 06/04/17 By Clinton原廠商交貨日期(pmn33)改為以到庫日期(pmn35)計算
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能 
# Modify.........: No.MOD-6B0099 06/11/20 By Claire 由外部程式串入時因action無功能,所以關閉 
# Modify.........: No.TQC-710032 07/01/15 By Smapmin 雙單位畫面調整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750041 07/05/15 By Lynn 點擊右邊的按鈕依BOM查詢,打開后點擊產品編號欄旁的放大鏡,系統無反應.
# Modify.........: No.TQC-790057 07/09/10 By lumxa  匯出Excel時候多一空白行
# Modify.........: No.MOD-820035 08/02/13 By Pengu 受定量應排除未確認的訂單
# Modify.........: No.MOD-810080 08/03/04 By Pengu 未考慮委外在驗量
# Modify.........: No.MOD-850310 08/05/30 by claire 工單未備(A)  = 應發 - 已發 -代買 + 下階料報廢 - 超領,若 A  < 0 ,則 LET A = 0
# Modify.........: No.MOD-8A0064 08/10/07 by claire 備料資料若為委外工單時,增加取廠商的資料
# Modify.........: No.FUN-940083 09/05/14 By dxfwo   原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No:MOD-990025 09/11/12 By sabrina 工單在製應排除拆件式工單
# Modify.........: No:FUN-8A0107 10/01/26 By shiwuying 算採購量時，將委外考慮進來
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:MOD-A70127 10/07/16 By Sarah 1.委外採購單不顯示在採購量裡
#                                                  2.增加委外IQC在驗量,用來顯示委外工單的QC量
# Modify.........: No:MOD-A90098 10/09/16 By Summer FQC在驗量應考慮生產單位與庫存單位的換算率
# Modify.........: NO:MOD-AA0069 10/10/13 BY sabrina FQC在驗量先排除拆件式工單(sfb02<>'11')
# Modify.........: NO:MOD-AB0221 10/11/25 BY sabrina 將ds_cust改為LIKE gem_file.gem02
# Modify.........: NO:MOD-AC0098 10/12/13 BY sabrina 還原A70127的IQC在驗量修改 
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AC0074 11/04/21 By shenyang    調整備置量，添加‘備置明細’欄位 
# Modify.........: No.TQC-B90069 11/09/08 By houlia 工單編號、訂單編號欄位提供開窗查詢功能 
# Modify.........: No:MOD-BC0300 11/12/29 By ck2yuan 預計結存每一筆根據上一筆計算而來,非每次抓取單頭可用量計算 
# Modify.........: No:CHI-B40039 13/01/18 By Alberti 工單在製量應扣除當站下線量

DATABASE ds
 
GLOBALS "../../config/top.global"
  DEFINE g_argv1        LIKE type_file.chr1     # 1.依料號 2.依工單 3.依訂單  #No.FUN-690026 VARCHAR(1)
  DEFINE g_argv2        LIKE ima_file.ima01     #No.FUN-690026 VARCHAR(40)     # 料號 /   工單 /   訂單   #MOD-5B0174
  DEFINE g_sw           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
  DEFINE g_wc,g_wc2     STRING                  # WHERE CONDICTION  #No.FUN-580092 HCN
  DEFINE g_sql          STRING                  #No.FUN-580092 HCN
  DEFINE g_rec_b,g_i    LIKE type_file.num5     #MOD-480304 add  #No.FUN-690026 SMALLINT
  DEFINE g_ima          RECORD
                         ima01     LIKE ima_file.ima01,    #料號
                         ima02     LIKE ima_file.ima02,    #品名
                         ima021    LIKE ima_file.ima021,   #品名
                         ima25     LIKE ima_file.ima25,    #單位
#                        ima262    LIKE ima_file.ima262,   #庫存量
#                        ima26     LIKE ima_file.ima26,    #MRP可用庫存量
                         avl_stk   LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044
                         avl_stk_mpsmrp LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044
                         ima906    LIKE ima_file.ima906,   #單位管制方式  #FUN-5C0086
                         ima907    LIKE ima_file.ima907    #第二單位      #FUN-5C0086
                        END RECORD
  DEFINE g_sr           DYNAMIC ARRAY OF RECORD
                         ds_date   LIKE type_file.dat,     #No.FUN-690026 DATE
                         ds_class  LIKE ze_file.ze03,      #MOD-480304 #No.FUN-690026 VARCHAR(20)
                         ds_no     LIKE pmm_file.pmm01,    #No.FUN-550029 #No.FUN-690026 VARCHAR(16)
                        #ds_cust   LIKE pmm_file.pmm09,    #MOD-AB0221 mark  
                         ds_cust   LIKE gem_file.gem02,    #MOD-AB0221 add 
                         ds_qlty   LIKE rpc_file.rpc13,
                         ds_total  LIKE rpc_file.rpc13
                         END RECORD,
        g_sr_s         RECORD
                         ds_date   LIKE type_file.dat,     #No.FUN-690026 DATE
                         ds_class  LIKE ze_file.ze03,      #MOD-480304 #No.FUN-690026 VARCHAR(20)
                         ds_no     LIKE pmm_file.pmm01,    #No.FUN-550029 #No.FUN-690026 VARCHAR(16)
                        #ds_cust   LIKE pmm_file.pmm09,    #MOD-AB0221 mark  
                         ds_cust   LIKE gem_file.gem02,    #MOD-AB0221 add 
                         ds_qlty   LIKE rpc_file.rpc13,
                         ds_total  LIKE rpc_file.rpc13
                       END RECORD
 
DEFINE g_order          LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt            LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg            LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count      LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask        LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
FUNCTION aimq841(p_argv1,p_argv2)
    DEFINE p_argv1      LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
    DEFINE p_argv2      LIKE ima_file.ima01    #MOD-5B0174 #No.FUN-690026 VARCHAR(40)
    DEFINE l_za05      LIKE za_file.za05      #MOD-480304 add  #No.FUN-690026 VARCHAR(40)

    WHENEVER ERROR CALL cl_err_msg_log
 
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2
 
   IF (NOT cl_setup("AIM")) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
   END IF
 
   OPEN WINDOW q841_w WITH FORM "aim/42f/aimq841"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL q841_mu_ui()
 
   IF NOT cl_null(g_argv1) THEN 
      CALL cl_set_act_visible("query_by_w_o,query_by_order,query_by_bom",FALSE)
      CALL q841_q() 
   END IF
   CALL q841_menu()
   CLOSE WINDOW q841_w
END FUNCTION
 

FUNCTION q841_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   IF NOT cl_null(g_argv1) THEN
      CASE WHEN g_argv1='1' LET g_wc = "ima01 = '",g_argv2,"'"
           WHEN g_argv1='2' LET g_wc = "ima01 IN",
                                       " (SELECT sfa03 FROM sfa_file WHERE ",
                                       "  sfa01='",g_argv2,"')"
           WHEN g_argv1='3' LET g_wc = "ima01 IN",
                                       " (SELECT oeb04 FROM oeb_file WHERE ",
                                       "  oeb01='",g_argv2,"')"
      END CASE
   ELSE
      CLEAR FORM #清除畫面
      CALL g_sr.clear()
      CALL cl_opmsg('q')
      IF g_sw = 1 THEN
         CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031         
         CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021
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
                    WHEN INFIELD(ima01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ima"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ima01
                     NEXT FIELD ima01
  #TQC-B90069 --add
                    WHEN INFIELD(sfa01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_sfa10"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfa01 
                     NEXT FIELD sfa01 
                    WHEN INFIELD(oeb01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oea03"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO oeb01 
                     NEXT FIELD oeb01 
  #TQC-B90069  --end
                  END CASE
               ### END  No.FUN-4A0041
         END CONSTRUCT
         IF INT_FLAG THEN RETURN END IF
      END IF
      IF g_sw = 2 THEN
         OPEN WINDOW q841_w2 WITH FORM "aim/42f/aimq841_2"
               ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
         CALL cl_ui_locale("aimq841_2")
 
         CONSTRUCT BY NAME g_wc2 ON sfa01
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 #TQC-B90069--add

               ON ACTION controlp
                  CASE
                    WHEN INFIELD(sfa01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_sfa10"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfa01
                     NEXT FIELD sfa01
                  END CASE
#TQC-B90069 -- end
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
         END CONSTRUCT
         CLOSE WINDOW q841_w2
         IF INT_FLAG THEN RETURN END IF
         LET g_wc = "ima01 IN (SELECT sfa03 FROM sfa_file WHERE ",
                     g_wc2 CLIPPED,")"
      END IF
 
      IF g_sw = 3 THEN
         OPEN WINDOW q841_w3 WITH FORM "aim/42f/aimq841_3"
               ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
         CALL cl_ui_locale("aimq841_3")
 
         CONSTRUCT BY NAME g_wc2 ON oeb01
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
#TQC-B90069--add

               ON ACTION controlp
                  CASE
                    WHEN INFIELD(oeb01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oea03"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO oeb01
                     NEXT FIELD oeb01
                  END CASE
#TQC-B90069 -- end
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
         END CONSTRUCT
         CLOSE WINDOW q841_w3
         IF INT_FLAG THEN RETURN END IF
         LET g_wc = "ima01 IN (SELECT oeb04 FROM oeb_file WHERE ",
                     g_wc2 CLIPPED,")"
      END IF
 
      IF g_sw = 4 THEN
         OPEN WINDOW q841_w4 WITH FORM "aim/42f/aimq841_4"
               ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
         CALL cl_ui_locale("aimq841_4")
 
         CONSTRUCT BY NAME g_wc2 ON bmb01
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT

              ON ACTION controlp                                                                                                    
                  CASE                                                                                                              
                    WHEN INFIELD(bmb01)                                                                                             
                     CALL cl_init_qry_var()                                                                                         
                     LET g_qryparam.form = "q_bmb01"                                                                                  
                     LET g_qryparam.state = 'c'                                                                                     
                     CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
                     DISPLAY g_qryparam.multiret TO bmb01                                                                           
                     NEXT FIELD bmb01                                                                                               
                  END CASE
# No.TQC-750041-- end 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
         END CONSTRUCT
         CLOSE WINDOW q841_w4
         IF INT_FLAG THEN RETURN END IF
         LET g_wc = "ima01 IN (SELECT bmb03 FROM bmb_file WHERE ",
                     g_wc2 CLIPPED,")"
      END IF
   END IF
  #start FUN-5C0086
  #LET g_sql=" SELECT ima01,ima02,ima021,ima25,ima262,ima26 ",
#  LET g_sql=" SELECT ima01,ima02,ima021,ima25,ima262,ima26,ima906,ima907 ",
   LET g_sql=" SELECT ima01,ima02,ima021,ima25,0,0,ima906,ima907 ",
  #end FUN-5C0086
             " FROM ima_file ", " WHERE ",g_wc CLIPPED
 
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
 
   LET g_sql = g_sql clipped," ORDER BY ima01"
   PREPARE q841_prepare FROM g_sql
   DECLARE q841_cs SCROLL CURSOR FOR q841_prepare
 
   LET g_sql=" SELECT count(*) FROM ima_file ", " WHERE ",g_wc CLIPPED
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
   #End:FUN-980030
 
   PREPARE q841_pp  FROM g_sql
   DECLARE q841_cnt CURSOR FOR q841_pp
END FUNCTION
 
 
FUNCTION q841_menu()
 
   WHILE TRUE
      CALL q841_bp("G")
      CASE g_action_choice
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "query"
            LET g_sw = 1
            CALL q841_q()
#@         WHEN "依料號查詢"
#        WHEN "query_by_item_no"
#           LET g_sw = 1
#           CALL q841_q()
#@         WHEN "依工單查詢"
         WHEN "query_by_w_o"
            LET g_sw = 2
            CALL q841_q()
#@         WHEN "依訂單查詢"
         WHEN "query_by_order"
            LET g_sw = 3
            CALL q841_q()
#@         WHEN "依BOM查詢"
         WHEN "query_by_bom"
            LET g_sw = 4
            CALL q841_q()
 #FUN-AC0074--add--begin
         WHEN "Stocks_detail"
            IF cl_chk_act_auth() THEN
               CALL q841_detail()
            END IF
 #FUN-AC0074--add--end
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sr),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q841_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q841_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "Waiting!"
    OPEN q841_cs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('q841_q:',SQLCA.sqlcode,0)
    ELSE
       OPEN q841_cnt
       FETCH q841_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q841_fetch('F')                #讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q841_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690026 VARCHAR(1)
   DEFINE   l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044 
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q841_cs INTO g_ima.*
        WHEN 'P' FETCH PREVIOUS q841_cs INTO g_ima.*
        WHEN 'F' FETCH FIRST    q841_cs INTO g_ima.*
        WHEN 'L' FETCH LAST     q841_cs INTO g_ima.*
        WHEN '/'
            IF (NOT g_no_ask) THEN
                 CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump q841_cs INTO g_ima.*
            LET g_no_ask = FALSE
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
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
   
    CALL s_getstock(g_ima.ima01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
    LET g_ima.avl_stk_mpsmrp = l_n1                                 #NO.FUN-A20044 
    LET g_ima.avl_stk = l_n3                                        #NO.FUN-A20044 
 
    CALL q841_show()
END FUNCTION
 
FUNCTION q841_show()
   DISPLAY BY NAME g_ima.*
   MESSAGE ' WAIT '
   CALL q841_b_fill() #單身
   MESSAGE ''
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q841_b_fill()              #BODY FILL UP
   DEFINE l_sfb02             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
	  I,J                 LIKE type_file.num10,   #No.FUN-690026 INTEGER
          m_oeb12             LIKE oeb_file.oeb12,
          m_ogb12             LIKE ogb_file.ogb12,
          l_pmm09             LIKE pmm_file.pmm09,
          l_pmc03             LIKE pmc_file.pmc03,
          l_sfb82             LIKE sfb_file.sfb82,
          l_ima55_fac         LIKE ima_file.ima55_fac,
 	  qty_1,qty_2         LIKE sfb_file.sfb08,    #MOD-530179
 	  qty_3,qty_4         LIKE sfb_file.sfb08,    #MOD-530179
 	  qty_5,qty_51,qty_52 LIKE sfb_file.sfb08,    #MOD-530179  #MOD-A70127 add qty_52
 	  qty_6,qty_7         LIKE sfb_file.sfb08,    #MOD-530179
          l_msg               STRING,                 #MOD-5B0174
          l_n1                LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044
          l_n2                LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044
          l_n3                LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044 
          l_sfb05             LIKE sfb_file.sfb05,    #CHI-B40039 add
          l_shb114            LIKE shb_file.shb114    #CHI-B40039 add   
 
    #-->受訂量
    DECLARE q841_bcs1 CURSOR FOR
       SELECT oeb15,'',oeb01,occ02,(oeb12-oeb24+oeb25-oeb26)*oeb05_fac,0   #FUN-570018 modify oeb12-oeb24 => oeb12-oeb24+oeb25-oeb26
         FROM oeb_file, oea_file, occ_file
         WHERE oeb04 = g_ima.ima01 AND oeb01 = oea01
           AND occ01 = oea03 AND oea00<>'0' AND oeb70 = 'N' 
           AND oeb12-oeb24+oeb25-oeb26 >0   #AND oeb12 > oeb24   #FUN-570018 modify
          #--------No.MOD-820035 modify
          #AND oeaconf != 'X' #01/08/07 mandy
           AND oeaconf = 'Y'   
          #--------No.MOD-820035 end
         ORDER BY oeb15
    #-->在製量
    SELECT ima55_fac INTO l_ima55_fac #BugNo:5474
      FROM ima_file
     WHERE ima01 = g_ima.ima01
    IF cl_null(l_ima55_fac) THEN
        LET l_ima55_fac = 1
    END IF
    DECLARE q841_bcs2 CURSOR FOR
       SELECT sfb15,'',sfb01,gem02,(sfb08-sfb09-sfb10-sfb11-sfb12)*l_ima55_fac,0,sfb02,sfb82,sfb05    #CHI-B40039 add sfb05
         FROM sfb_file, OUTER gem_file
        WHERE sfb05 = g_ima.ima01 AND sfb04 !='8' AND sfb_file.sfb82 = gem_file.gem01
          AND sfb08 > (sfb09+sfb10+sfb11+sfb12) AND sfb87!='X'
          AND (sfb02 != '11' AND sfb02 != '15')       #No:MOD-990025  add
        ORDER BY sfb15
    #-->請購量
    DECLARE q841_bcs3 CURSOR FOR
       SELECT pml35,'',pml01,pmc03,(pml20-pml21)*pml09,0   #No.TQC-640132
         FROM pml_file, pmk_file, OUTER pmc_file
         WHERE pml04 = g_ima.ima01 AND pml01 = pmk01 AND pmk_file.pmk09 = pmc_file.pmc01
          AND pml20 > pml21 AND (pml16<='2' OR pml16='S' OR pml16='R' OR pml16='W')   ##MOD-530804
         AND pml011 !='SUB' AND pmk18 != 'X'
        ORDER BY pml35   #No.TQC-640132
    #-->採購量
    DECLARE q841_bcs4 CURSOR FOR
       #TQC-660123
       #SELECT pmn33,'',pmm01,pmc03,(pmn20-pmn50+pmn55)*pmn09,0
#      SELECT pmn35,'',pmm01,pmc03,(pmn20-pmn50+pmn55)*pmn09,0        #No.FUN-940083  
       SELECT pmn35,'',pmm01,pmc03,(pmn20-pmn50+pmn55+pmn58)*pmn09,0  #No.FUN-940083
         FROM pmn_file, pmm_file, OUTER pmc_file
        WHERE pmn04 = g_ima.ima01 AND pmn01 = pmm01 AND pmm_file.pmm09 = pmc_file.pmc01
         #No.+453 010720 by plum
         #AND pmn20 > pmn50 AND pmn16 <= '2' AND pmn011 !='SUB'
         #AND pmn20 -(pmn50-pmn55)>0 AND pmn16 <= '2' AND pmn011 !='SUB' #FUN-5C0046
#         AND pmn20 -(pmn50-pmn55)>0 AND (pmn16 <= '2' OR pmn16='S' OR pmn16='R' OR pmn16='W') AND pmn011 !='SUB' #FUN-5C0046         #No.FUN-9A0068
       #No.FUN-8A0107 -BEGIN-----
       #  AND pmn20 -(pmn50-pmn55-pmn58)>0 AND (pmn16 <= '2' OR pmn16='S' OR pmn16='R' OR pmn16='W') AND pmn011 !='SUB' #FUN-5C0046   #No.FUN-9A0068
          AND pmn20 -(pmn50-pmn55-pmn58)>0 AND (pmn16 <= '2' OR pmn16='S'
           OR pmn16='R' OR pmn16='W')
       #No.FUN-8A0107 -END-------
          AND pmn011 !='SUB'   #MOD-A70127 add
         #No.+453...end
          AND pmm18 != 'X'
        ORDER BY pmn35
    #-->IQC 在驗量
    DECLARE q841_bcs5 CURSOR FOR
       SELECT rva06,'',rvb01,pmc03,(rvb07-rvb29-rvb30)*pmn09,0  #MOD-A70127 mark #MOD-AC0098 取消mark
      #SELECT rva06,'',rvb01,pmc03,rvb31*pmn09,0                #MOD-A70127      #MOD-AC0098 mark
         FROM rvb_file, rva_file, OUTER pmc_file, pmn_file
        WHERE rvb05 = g_ima.ima01 AND rvb01 = rva01 AND rva_file.rva05 = pmc_file.pmc01
          AND rvb04 = pmn_file.pmn01 AND rvb03 = pmn_file.pmn02
          AND rvb07 > (rvb29+rvb30)  #MOD-A70127 mark  #MOD-AC0098 取消mark
         #AND rvb31 > 0              #MOD-A70127       #MOD-AC0098 mark
          AND rvaconf='Y'  #BugNo:5992
          AND rva10 !='SUB'     #No:MOD-810080 mark   #MOD-A70127 mark回復
        ORDER BY rva06
    #-->FQC 在驗量
    DECLARE q841_bcs51 CURSOR FOR
      #SELECT sfb15,'',sfb01,gem02,sfb11,0   #MOD-650078 sfb81->sfb15 #MOD-A90098 mark
       SELECT sfb15,'',sfb01,gem02,sfb11*l_ima55_fac,0   #MOD-A90098
         FROM sfb_file, OUTER gem_file
        WHERE sfb05 = g_ima.ima01
          AND sfb02 <> '7' AND sfb02 <> '8' AND sfb87!='X'   #MOD-A70127 add sfb02<>'8'
          AND sfb02 <> '11'        #MOD-AA0069 add
          AND sfb04 <'8' AND sfb_file.sfb82=gem_file.gem01
          AND sfb11 > 0   #No:7188
   #str MOD-A70127 add
   #-->委外IQC在製量
    DECLARE q841_bcs52 CURSOR FOR
      #SELECT rva06,'',rvb01,pmc03,rvb31*pmn09,0                #MOD-AC0098 mark
       SELECT rva06,'',rvb01,pmc03,(rvb07-rvb29-rvb30)*pmn09,0  #MOD-AC0098 add 
         FROM rvb_file, rva_file, OUTER pmc_file, pmn_file
        WHERE rvb05 = g_ima.ima01 AND rvb01 = rva01 AND rva05 = pmc01
          AND rvb04 = pmn01 AND rvb03 = pmn02
         #AND rvb31 > 0               #MOD-AC0098 mark
          AND rvb07 > (rvb29+rvb30)   #MOD-AC0098 add 
          AND rvaconf='Y'
          AND rva10 ='SUB'
          AND pmn43 = 0
        ORDER BY rva06
   #end MOD-A70127 add
    #-->備料量
    #MOD-850310-begin-modify
    #工單未備(A)  = 應發 - 已發 -代買 + 下階料報廢 - 超領
    #若 A  < 0 ,則 LET A = 0,同amrp500 之計算邏輯
    DECLARE q841_bcs6 CURSOR FOR
       SELECT sfb13,'',sfa01,gem02,(sfa05-sfa06-sfa065+sfa063-sfa062)*sfa13,0  #MOD-850310
              ,sfb82,sfb02                                                     #MOD-8A0064 add
      #SELECT sfb13,'',sfa01,gem02,(sfa05-sfa06-sfa065)*sfa13,0                #MOD-850310 mark
         FROM sfb_file,sfa_file, OUTER gem_file
        WHERE sfa03 = g_ima.ima01 AND sfb01 = sfa01 AND sfb_file.sfb82 = gem_file.gem01
          AND sfb04 !='8' AND sfa05 > 0 AND sfa05 > sfa06+sfa065 AND sfb87!='X'
        ORDER BY sfb13
    #-->銷售備置量
#FUN-AC0074--mark(s)
# #  SELECT SUM((oeb12-oeb24)*oeb05_fac) INTO m_oeb12
#    SELECT SUM(oeb905*oeb05_fac) INTO m_oeb12    #no.7182
#     FROM oeb_file, oea_file, occ_file
##   WHERE oeb04 = g_ima.ima01 AND oeb01 = oea01 AND oea00 = '1' AND oeb19 = 'Y'
#    WHERE oeb04 = g_ima.ima01 AND oeb01 = oea01 AND oea00 <>'0' AND oeb19 = 'Y'
#      AND oeb70 = 'N' AND oeb12 > oeb24 AND oea03=occ01
#      AND oeaconf != 'X' #01/08/07 mandy
 
#    LET qty_7 = m_oeb12 #+ m_ogb12
#    IF cl_null(qty_7) THEN LET qty_7=0 END IF   #MOD-A70127 add
#FUN-AC0074--mark(e)
#FUN-AC0074--add--begin
     SELECT SUM(sig05) INTO m_oeb12 FROM sig_file
       WHERE sig01 = g_ima.ima01
     LET qty_7 = m_oeb12
     IF cl_null(qty_7) THEN LET qty_7=0 END IF
#FUN-AC0074--add--end 
    DISPLAY BY NAME qty_7 ATTRIBUTE(REVERSE)    #------ 銷售備置量不條列明細
 
#----------------------------------------------------------------------------
    CALL g_sr.clear()
    LET g_cnt = 1
    LET qty_1=0 LET qty_2=0  LET qty_3=0  LET qty_4=0
    LET qty_5=0 LET qty_51=0 LET qty_52=0  #MOD-A70127 add qty_52
    LET qty_6=0 LET qty_7=0
#----------------------------------------------------------------------------
 #MOD-480304 modify
    FOREACH q841_bcs1 INTO g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F1:',STATUS,1) EXIT FOREACH END IF
      #start MOD-5B0174
      #LET g_sr[g_cnt].ds_class = g_x[1]       #MOD-480304
       LET l_msg = ''
       CALL cl_getmsg('aim-821',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
      #end MOD-5B0174
       LET qty_1 = qty_1 + g_sr[g_cnt].ds_qlty
       LET g_sr[g_cnt].ds_qlty = -g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
    END FOREACH
    DISPLAY BY NAME qty_1 ATTRIBUTE(REVERSE)
##
#----------------------------------------------------------------------------
    FOREACH q841_bcs2 INTO g_sr[g_cnt].*,l_sfb02,l_sfb82,l_sfb05           #CHI-B40039 add sfb05
       IF STATUS THEN CALL cl_err('F2:',STATUS,1) EXIT FOREACH END IF
      #start MOD-5B0174
      #LET g_sr[g_cnt].ds_class = g_x[2]       #MOD-480304
       LET l_msg = ''
       CALL cl_getmsg('aim-822',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
      #end MOD-5B0174
       LET qty_2 = qty_2 + g_sr[g_cnt].ds_qlty
       #CHI-B40039---add---start---
       LET l_shb114 = 0
       SELECT SUM(shb114) INTO l_shb114 
         FROM shb_file,sfb_file
        WHERE shb10 = l_sfb05 AND shb10=sfb05
          AND shb05=sfb01 
          AND sfb01=g_sr[g_cnt].ds_no
          AND sfb87!='X' AND sfb04 < '8'
          AND (sfb02 != '11' AND sfb02 != '15')      
       IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
       LET qty_2 = qty_2 - l_shb114
       LET g_sr[g_cnt].ds_qlty = g_sr[g_cnt].ds_qlty - l_shb114
      #CHI-B40039---add---end---
       IF cl_null(g_sr[g_cnt].ds_cust) THEN
          SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 =l_sfb82
          IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
          IF l_sfb02 = '7' AND cl_null(l_pmc03) THEN
             SELECT pmm09,pmc03 INTO l_pmm09,l_pmc03 FROM pmm_file,pmc_file
                          WHERE pmm01 = g_sr[g_cnt].ds_no
                            AND pmm09 = pmc01
             IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
          END IF
          LET g_sr[g_cnt].ds_cust = l_pmc03
       END IF
     # LET g_sr[g_cnt].ds_qlty = -g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
    END FOREACH
    DISPLAY BY NAME qty_2 ATTRIBUTE(REVERSE)
#----------------------------------------------------------------------------
    FOREACH q841_bcs3 INTO g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F3:',STATUS,1) EXIT FOREACH END IF
      #start MOD-5B0174
      #LET g_sr[g_cnt].ds_class = g_x[3]       #MOD-480304
       LET l_msg = ''
       CALL cl_getmsg('aim-823',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
      #end MOD-5B0174
       LET qty_3 = qty_3 + g_sr[g_cnt].ds_qlty
     # LET g_sr[g_cnt].ds_qlty = -g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
    END FOREACH
    DISPLAY BY NAME qty_3 ATTRIBUTE(REVERSE)
#----------------------------------------------------------------------------
    FOREACH q841_bcs4 INTO g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F4:',STATUS,1) EXIT FOREACH END IF
      #start MOD-5B0174
      #LET g_sr[g_cnt].ds_class = g_x[4]       #MOD-480304
       LET l_msg = ''
       CALL cl_getmsg('aim-824',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
      #end MOD-5B0174
       LET qty_4 = qty_4 + g_sr[g_cnt].ds_qlty
     # LET g_sr[g_cnt].ds_qlty = -g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    DISPLAY BY NAME qty_4 ATTRIBUTE(REVERSE)
#----------------------------------------------------------------------------
 #MOD-480304
    FOREACH q841_bcs5 INTO g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F5:',STATUS,1) EXIT FOREACH END IF
      #start MOD-5B0174
      #LET g_sr[g_cnt].ds_class = g_x[5]       #MOD-480304
       LET l_msg = ''
       CALL cl_getmsg('aim-825',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
      #end MOD-5B0174
       LET qty_5 = qty_5 + g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    DISPLAY BY NAME qty_5 ATTRIBUTE(REVERSE)
##
#----------------------------------------------------------------------------
    FOREACH q841_bcs51 INTO g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F51:',STATUS,1) EXIT FOREACH END IF
      #start MOD-5B0174
      #LET g_sr[g_cnt].ds_class = g_x[6]       #MOD-480304
       LET l_msg = ''
       CALL cl_getmsg('aim-826',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
      #end MOD-5B0174
       LET qty_51 = qty_51 + g_sr[g_cnt].ds_qlty
   #   LET g_sr[g_cnt].ds_qlty = -g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    DISPLAY BY NAME qty_51 ATTRIBUTE(REVERSE)
#----------------------------------------------------------------------------
   #str MOD-A70127 add
    FOREACH q841_bcs52 INTO g_sr[g_cnt].*
       IF STATUS THEN CALL cl_err('F52:',STATUS,1) EXIT FOREACH END IF
       LET l_msg = ''
       CALL cl_getmsg('aim-829',g_lang) RETURNING l_msg   #委外IQC在驗量
       LET g_sr[g_cnt].ds_class = l_msg
       LET qty_52 = qty_52 + g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    DISPLAY BY NAME qty_52 ATTRIBUTE(REVERSE)
   #end MOD-A70127 add
#----------------------------------------------------------------------------
    FOREACH q841_bcs6 INTO g_sr[g_cnt].*,l_sfb82,l_sfb02    #MOD-8A0064 add l_sfb82,l_sfb02
       IF STATUS THEN CALL cl_err('F6:',STATUS,1) EXIT FOREACH END IF
      #start MOD-5B0174
      #LET g_sr[g_cnt].ds_class = g_x[7]       #MOD-480304
       LET l_msg = ''
       CALL cl_getmsg('aim-827',g_lang) RETURNING l_msg
       LET g_sr[g_cnt].ds_class = l_msg
      #end MOD-5B0174
      #MOD-8A0064-begin-add
       IF cl_null(g_sr[g_cnt].ds_cust) THEN
          SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 =l_sfb82
          IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
          IF l_sfb02 = '7' AND cl_null(l_pmc03) THEN
             SELECT pmm09,pmc03 INTO l_pmm09,l_pmc03 FROM pmm_file,pmc_file
                          WHERE pmm01 = g_sr[g_cnt].ds_no
                            AND pmm09 = pmc01
             IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
          END IF
          LET g_sr[g_cnt].ds_cust = l_pmc03
       END IF
      #MOD-8A0064-end-add
       IF g_sr[g_cnt].ds_qlty < 0 THEN LET g_sr[g_cnt].ds_qlty = 0  END IF #MOD-850310 add
       LET qty_6 = qty_6 + g_sr[g_cnt].ds_qlty
       LET g_sr[g_cnt].ds_qlty = -g_sr[g_cnt].ds_qlty
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
 
    CALL g_sr.deleteElement(g_cnt)    #TQC-790057
    DISPLAY BY NAME qty_6 ATTRIBUTE(REVERSE)
#----------------------------------------------------------------------------
LET g_cnt = g_cnt - 1      			# Get real number of record
 LET g_rec_b = g_cnt     #MOD-480304
#------------------------Bubble Sort Start !!!--------11/10/94 by nick------
FOR I= 1 TO g_cnt-1
    FOR J= g_cnt-1 TO I STEP -1
    #---------- COMPARE  & SWAP ------------
        IF (g_sr[J].ds_date > g_sr[J+1].ds_date) OR
                     (g_sr[J+1].ds_date IS NULL) THEN
	   LET g_sr_s.*	= g_sr[J].*
	   LET g_sr[J].* = g_sr[J+1].*
	   LET g_sr[J+1].* = g_sr_s.*	
	END IF	
   END FOR
END FOR
#------------------------Bubble Sort End------------------------------------
    CALL s_getstock(g_ima.ima01,g_plant) RETURNING  l_n1,l_n2,l_n3    #MOD-BC0300 add
    LET g_ima.avl_stk_mpsmrp = l_n1                                   #MOD-BC0300 add
FOR I = 1 TO g_cnt 
#    CALL s_getstock(g_ima.ima01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044  #MOD-BC0300 mark
#    LET g_ima.avl_stk_mpsmrp = l_n1                                   #NO.FUN-A20044          #MOD-BC0300 mark
    LET g_ima.avl_stk_mpsmrp = g_ima.avl_stk_mpsmrp + g_sr[I].ds_qlty #NO.FUN-A20044 
    LET g_sr[I].ds_total = g_ima.avl_stk_mpsmrp                       #NO.FUN-A20044   
#   LET g_ima.ima26 = g_ima.ima26 + g_sr[I].ds_qlty
#   LET g_sr[I].ds_total = g_ima.ima26
END FOR
 
 #MOD-490145顯示單身筆數
DISPLAY g_rec_b TO FORMONLY.cn2
LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION q841_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sr TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      #BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #   LET l_sl = SCR_LINE()
 
      ON ACTION first
         CALL q841_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q841_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q841_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q841_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q841_fetch('L')
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
         CALL q841_mu_ui()   #TQC-710032
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
#@      ON ACTION 依料號查詢
#     ON ACTION query_by_item_no
#        LET g_action_choice="query_by_item_no"
#@      ON ACTION 依工單查詢
      ON ACTION query_by_w_o
         LET g_action_choice="query_by_w_o"
         EXIT DISPLAY
#@      ON ACTION 依訂單查詢
      ON ACTION query_by_order
         LET g_action_choice="query_by_order"
         EXIT DISPLAY
#@      ON ACTION 依BOM查詢
      ON ACTION query_by_bom
         LET g_action_choice="query_by_bom"
         EXIT DISPLAY
#FUN-AC0074--add--begin
      ON ACTION Stocks_detail
         LET g_action_choice="Stocks_detail"
         EXIT DISPLAY
#FUN-AC0074--add--end 
      ON ACTION accept
#         LET l_ac = ARR_CURR()
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
 
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#-----TQC-710032---------
FUNCTION q841_mu_ui()
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
#FUN-AC0074--add--begin
FUNCTION q841_detail()
  DEFINE tm RECORD
         a               LIKE type_file.chr1
         END RECORD
DEFINE  l_cmd           LIKE type_file.chr1000

  OPEN WINDOW q841_detail_w WITH FORM "aim/42f/aimq102a"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("aimq102a")
  LET tm.a='1'
   DISPLAY BY NAME tm.a

   INPUT BY NAME tm.a WITHOUT DEFAULTS
      AFTER FIELD a
            IF tm.a NOT MATCHES '[1234]' THEN
               NEXT FIELD a
            END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW q841_detail_w
      RETURN
   END IF

   CLOSE WINDOW q841_detail_w
   CASE tm.a
      WHEN '1'
        LET l_cmd = "asfq610"," '1' "," '",g_ima.ima01,"'"
        CALL cl_cmdrun(l_cmd)
      WHEN '2'
        LET l_cmd = "axmq611"," '2' "," '",g_ima.ima01,"'"
        CALL cl_cmdrun(l_cmd)
      WHEN '3'
        LET l_cmd = "aimq611"," '3' "," '",g_ima.ima01,"'"
        CALL cl_cmdrun(l_cmd)
      WHEN '4'
        LET l_cmd = "asfq612"," '4' "," '",g_ima.ima01,"'"
        CALL cl_cmdrun(l_cmd)
   END CASE
END FUNCTION
#FUN-AC0074--add--end
