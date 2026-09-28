# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: armt125.4gl
# Descriptions...: RMA序號明細維護作業
# Date & Author..: 98/03/25 By plum
# Modify.........: No.FUN-4C0055 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510044 05/02/14 By Mandy 報表轉XML
# Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-550064 05/05/28 By Trisy 單據編號加大
# Modify.........: No.TQC-5B0109 05/11/11 By Echo &051112修改報表料件、品名、規格、單號格式
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0018 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: NO.FUN-860018 08/06/19 BY TSD.jarlin 傳統報表轉CR報表
# Modify.........: No.FUN-890102 08/09/23 By baofei   CR追單到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990103 09/10/10 By lilingyu 明細資料頁簽"保證期"天數沒控管負數
# Modify.........: No.TQC-A20033 10/02/10 By lilingyu 查詢狀態,RMA單號 退貨客戶 料號增加開窗功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_rma           RECORD LIKE rma_file.*,       #RMA單號  (單頭)
    g_rmb           RECORD LIKE rmb_file.*,       #RMA單號  (單頭)
    g_rmc           RECORD LIKE rmc_file.*,       #RMA單號  (單頭)
    g_rma_t         RECORD LIKE rma_file.*,       #RMA單號  (舊值)
    g_rmc_t         RECORD LIKE rmc_file.*,       #RMA單號  (舊值)
    g_rmc_o         RECORD LIKE rmc_file.*,       #RMA單號  (舊值)
    g_rma01_t       LIKE rma_file.rma01,   #簽核等級 (舊值)
    g_rmc02_t       LIKE rmc_file.rmc02,   #簽核等級 (舊值)
    g_cmd           LIKE type_file.chr1000,              #單別    (沿用)  #No.FUN-690010 VARCHAR(50)
    g_sheet         LIKE aba_file.aba00,   # Prog. Version..: '5.30.06-13.03.12(05),              #No.FUN-550064
    g_argv1         LIKE rmc_file.rmc01,   # RMA 單號
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #detail筆數  #No.FUN-690010 SMALLINT
    g_b_cnt         LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #detail筆數
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_sl            LIKE type_file.num5     #No.FUN-690010 SMALLINT               #目前處理的SCREEN LINE
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5   #No.FUN-690010 SMALLINT
DEFINE   l_table    STRING  #-----NO.FUN-860018 BY TSD.jarlin-----                                                                  
DEFINE   g_str      STRING  #-----NO.FUN-860018 BY TSD.jarlin-----   
 

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("ARM")) THEN
       EXIT PROGRAM
    END IF
 
    #-----NO.FUN-860018  BY TSD.jarlin-----<<temp table>>-----(S)                                                                   
    LET g_sql = "rmc01.rmc_file.rmc01,",                                                                                            
                "rmc02.rmc_file.rmc02,",                                                                                            
                "rmc04.rmc_file.rmc04,",                                                                                            
                "rmd05.rmd_file.rmd05,",                                                                                            
                "rmc06.rmc_file.rmc06,",                                                                                            
                "rmc061.rmc_file.rmc061,",                                                                                          
                "rmd07.rmd_file.rmd07,",                                                                                            
                "rmc08.rmc_file.rmc08,",                                                                                            
                "rmc09.rmc_file.rmc09,",                                                                                            
                "rmc10.rmc_file.rmc10,",                                                                                            
                "rmc14.rmc_file.rmc14,",                                                                                            
                "rmc16.rmc_file.rmc16,",                                                                                            
                "rmc25.rmc_file.rmc25,",                                                                                            
                "rmd02.rmd_file.rmd02,",                                                                                            
                "rmd03.rmd_file.rmd03,",                                                                                            
                "rmd031.rmd_file.rmd031,", 
                "rmd04.rmd_file.rmd04,",                                                                                            
                "rmd06.rmd_file.rmd06,",                                                                                            
                "rmd061.rmd_file.rmd061,",                                                                                          
                "rmd12.rmd_file.rmd12,",                                                                                            
                "rmd13.rmd_file.rmd13,",                                                                                            
                "rmd14.rmd_file.rmd14,",                                                                                            
                "rmd21.rmd_file.rmd21,",                                                                                            
                "rmd23.rmd_file.rmd23,",                                                                                            
                "rmd24.rmd_file.rmd24,",                                                                                            
                "rmd27.rmd_file.rmd27,",                                                                                            
                "rma03.rma_file.rma03,",        #客戶代號                                                                           
                "rma04.rma_file.rma04,",        #客戶簡稱                                                                           
                "rmk02.rmk_file.rmk02,",         #說明                                                                              
                "rmc14d.type_file.chr20,",                                                                                          
                "azi03.azi_file.azi03,",                                                                                            
                "azi04.azi_file.azi04,",   
                "azi05.azi_file.azi05"                                                                                              
    LET l_table = cl_prt_temptable('armt125',g_sql) CLIPPED                                                                         
    IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                        
    LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",                                                              
                "  ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"                                                                                    
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1)                                                                                         
       EXIT PROGRAM                                                                                                                 
    END IF                                                                                                                          
    #-----NO.FUN-860018---------------------------------------(E)   
    
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0085
 
    OPEN WINDOW t125_w WITH FORM "arm/42f/armt125"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_action_choice=""
    CALL t125_menu()
 
    CLOSE WINDOW t125_w                    #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION t125_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   INITIALIZE g_rma.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                 #螢幕上取單頭條件
          rma01,rma12,rma03,rma04,rma20,rmaconf,rmauser,rmagrup,
          rmamodu,rmadate,rmavoid
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
#TQC-A20033 --begin--
      ON ACTION controlp
        CASE         
          WHEN INFIELD(rma01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rma01"
               LET g_qryparam.state = 'c'
               LET g_qryparam.default1 = g_rma.rma01
               CALL cl_create_qry() RETURNING g_rma.rma01
               DISPLAY BY NAME g_rma.rma01
               NEXT FIELD rma01
                           
          WHEN INFIELD(rma03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rma03"
               LET g_qryparam.state = 'c'               
               LET g_qryparam.default1 = g_rma.rma03
               CALL cl_create_qry() RETURNING g_rma.rma03
               DISPLAY BY NAME g_rma.rma03
               NEXT FIELD rma01         
          END CASE 
#TQC-A20033 --end--              
 
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
  #資料權限的檢查
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                             #只能使用自己的資料
  #     LET g_wc = g_wc clipped," AND rmauser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                             #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND rmagrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc = g_wc clipped," AND rmagrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmauser', 'rmagrup')
  #End:FUN-980030
 
 
   CONSTRUCT BY NAME g_wc2 ON rmc04,rmc22         #螢幕上取rmc04,rmc22條件
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
 #TQC-A20033 --begin--
      ON ACTION controlp
        CASE         
          WHEN INFIELD(rmc04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rmc04"
               LET g_qryparam.state = 'c'               
               LET g_qryparam.default1 = g_rmc.rmc04
               CALL cl_create_qry() RETURNING g_rmc.rmc04
               DISPLAY BY NAME g_rmc.rmc04
               NEXT FIELD rmc04   
        END CASE 
#TQC-A20033 --end--  
 
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
    IF g_wc2 = " 1=1" THEN                        #若detailrmc04,rmc22未輸入條件
       LET g_sql = "SELECT rma01 FROM rma_file,oay_file ",
                   " WHERE ", g_wc CLIPPED,
#                  " AND rma01[1,3]=oayslip",
                   " AND rma01 like ltrim(rtrim(oayslip)) || '-%'",      #No.FUN-550064
                   " AND oaytype='70' ",
                   " ORDER BY rma01"
     ELSE                                         #若detailrmc04有輸入條件
       LET g_sql = "SELECT UNIQUE rma01 ",
                   "  FROM rma_file, rmc_file,oay_file ",
                   " WHERE rma01 = rmc01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
#                  " AND rma01[1,3]=oayslip",
                   " AND rma01 like ltrim(rtrim(oayslip)) || '-%'",      #No.FUN-550064
                   " AND oaytype='70' ",
                   " ORDER BY rma01"
    END IF
 
    PREPARE t125_prepare FROM g_sql
    DECLARE t125_cs                               #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t125_prepare
 
    IF g_wc2 = " 1=1" THEN                        #取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM rma_file,oay_file WHERE ",
                   g_wc CLIPPED,
#                 " AND rma01[1,3]=oayslip",
                  " AND rma01 like ltrim(rtrim(oayslip)) || '-%'",      #No.FUN-550064
                  " AND oaytype='70' "
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT rma01)",
                 "  FROM rma_file,rmc_file,oay_file WHERE ",
                  "rmc01=rma01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
#                 " AND rma01[1,3]=oayslip",
                  " AND rma01 like ltrim(rtrim(oayslip)) || '-%'",      #No.FUN-550064
                  " AND oaytype='70' "
    END IF
    PREPARE t125_precount FROM g_sql
    DECLARE t125_count CURSOR FOR t125_precount
END FUNCTION
 


FUNCTION t125_menu()
    MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                CALL t125_q()
            END IF
        ON ACTION next
            CALL t125_fetch('N')
        ON ACTION previous
            CALL t125_fetch('P')

        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic(g_rma.rmaconf,"","","","","")

        ON ACTION material_detail
           LET g_action_choice="material_detail"
           IF cl_chk_act_auth() THEN
              IF cl_null(g_rmc.rmc08) THEN
                 CALL cl_err('Repair Date ','aar-011',0)
              ELSE
                 IF g_i = 1 THEN
                    LET g_cmd= 'armt130 "',g_rma.rma01,'" "',
                                g_rmc_t.rmc02,'" "',g_rmc.rmc08,'"'
                 ELSE
                    LET g_cmd = "armt130 '",g_rma.rma01,"' '" ,
                                 g_rmc_t.rmc02,"' '",g_rmc.rmc08,"'"
                 END IF
                 #CALL cl_cmdrun(g_cmd CLIPPED)      #FUN-660216 remark
                 CALL cl_cmdrun_wait(g_cmd CLIPPED)  #FUN-660216 add
              END IF
           END IF
           CALL t125_b_show()
        ON ACTION next_row
            CALL t125_b_fetch('N')
        ON ACTION previous_row
            CALL t125_b_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t125_b_u()
            END IF

        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
                CALL  t125_out()
            END IF

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL t125_fetch('/')
        ON ACTION first
            CALL t125_fetch('F')
        ON ACTION last
            CALL t125_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      #No.MOD-530688  --begin
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT MENU
      #No.MOD-530688  --end
 
      #No.FUN-6A0018-------add--------str----
      ON ACTION related_document       #相關文件
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
             IF g_rma.rma01 IS NOT NULL THEN
                LET g_doc.column1 = "rma01"
                LET g_doc.value1 = g_rma.rma01
                CALL cl_doc()
             END IF
         END IF
      #No.FUN-6A0018-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
END FUNCTION
 
 
#Query 查詢
FUNCTION t125_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rma.* TO NULL               #NO.FUN-6A0018
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t125_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rma.* TO NULL
        RETURN
    END IF
    LET g_cnt=0
    OPEN t125_cs                               #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_rma.* TO NULL
    ELSE
       OPEN t125_count
       FETCH t125_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t125_fetch('F')                   #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t125_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                    #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                    #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t125_cs INTO g_rma.rma01
        WHEN 'P' FETCH PREVIOUS t125_cs INTO g_rma.rma01
        WHEN 'F' FETCH FIRST    t125_cs INTO g_rma.rma01
        WHEN 'L' FETCH LAST     t125_cs INTO g_rma.rma01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump t125_cs INTO g_rma.rma01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)
        INITIALIZE g_rma.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_rma.* FROM rma_file WHERE rma01 = g_rma.rma01
    IF SQLCA.sqlcode THEN
 #      CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)  # FUN-660111 
        CALL cl_err3("sel","rma_file",g_rma.rma01,"",SQLCA.sqlcode,"","",1) #FUN-660111
        INITIALIZE g_rma.* TO NULL
        RETURN
    END IF
        LET g_data_owner = g_rma.rmauser #FUN-4C0055
        LET g_data_group = g_rma.rmagrup #FUN-4C0055
        LET g_data_plant = g_rma.rmaplant #FUN-980030
    CALL t125_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t125_show()
    MESSAGE ""
    LET g_rma_t.* = g_rma.*                #保存單頭舊值
    DISPLAY BY NAME                        # 顯示單頭值
        g_rma.rma01,g_rma.rma03,
        g_rma.rma04,g_rma.rma12,g_rma.rma20,
        g_rma.rma18,g_rma.rmaconf,g_rma.rmauser,g_rma.rmagrup,
        g_rma.rmamodu,g_rma.rmadate,g_rma.rmavoid
    IF g_rma.rma09='6' THEN MESSAGE " RMA slip had been canceled!" END IF
    LET g_sql = "SELECT rmc01,rmc04,rmc02 FROM rmc_file ",
                " WHERE rmc01= '", g_rma.rma01 ,"'",
                " AND ",g_wc2 CLIPPED,
                " ORDER BY rmc01,rmc04,rmc02"
    PREPARE t125_bpre  FROM g_sql
    DECLARE t125_bcs
                  SCROLL CURSOR WITH HOLD FOR t125_bpre
    OPEN t125_bcs
    IF SQLCA.sqlcode THEN
        INITIALIZE g_rmb.* TO NULL
        INITIALIZE g_rmc.* TO NULL
        CALL t125_b_clear()
    ELSE
        LET g_b_cnt=0
        CALL t125_b_fetch('F')                #detail
    END IF
    CALL cl_set_field_pic(g_rma.rmaconf,"","","","","")
   #CLOSE t125_bcs
    CALL cl_show_fld_cont()   #FUN-550037(smin)
END FUNCTION
 
 
 
FUNCTION t125_b_u()
 
    SELECT * INTO g_rma.* FROM rma_file WHERE rma01 = g_rma.rma01
    IF g_rma.rma01 IS NULL THEN
       CALL cl_err('RMA NO# cannot be blank! ','mfg0037',0) 
       RETURN
    END IF
    IF g_rma.rmavoid ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_rmc.rmc01,'mfg1000',0)
        RETURN
    END IF
    IF g_rma.rmaconf ='Y' THEN    #檢查資料是否為已確認
        CALL cl_err(g_rmc.rmc01,'aap-086',0) RETURN
    END IF
    IF g_rma.rma09  ='6' THEN    #檢查資料是否為取消
        CALL cl_err(g_rmc.rmc01,'arm-018',0) RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_rmc_o.*=g_rmc.*
    LET g_rmc_t.*=g_rmc.*
    LET g_rma01_t=g_rma.rma01
    LET g_rmc02_t=g_rmc.rmc02
 
    LET g_forupd_sql = "SELECT * FROM rmc_file WHERE rmc01 = ? AND rmc02 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t125_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    BEGIN WORK
    OPEN t125_b_cl USING g_rmc.rmc01,g_rmc.rmc02
    IF STATUS THEN
       CALL cl_err("OPEN t125_b_cl:", STATUS, 1)
       CLOSE t125_b_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t125_b_cl INTO g_rmc.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rmc.rmc01,SQLCA.sqlcode,0)
        RETURN
    END IF
    IF g_rmc.rmc14 NOT MATCHES '[012]' THEN    #NO:7221 0.未修復 1.修復 2.不修
       RETURN                                  #才可改
    END IF
    WHILE TRUE
        CALL t125_b_i("u")                     # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_rmc.* = g_rmc_t.*
            CALL t125_b_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE rmc_file SET rmc_file.* = g_rmc.*    # 更新DB
            WHERE rmc01 = g_rmc.rmc01 AND rmc02 = g_rmc.rmc02               # COLAUTH?
        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_rmc.rmc01,SQLCA.sqlcode,0)  # FUN-660111 
            CALL cl_err3("upd","rmc_file",g_rmc_t.rmc01,g_rmc_t.rmc02,SQLCA.sqlcode,"","",1) #FUN-660111
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t125_b_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t125_b_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF g_rmc.rmc11 IS NULL THEN CALL t125_rmc11()   END IF
    IF g_rmc.rmc10 IS NULL THEN LET g_rmc.rmc10 = 0  END IF
    IF g_rmc.rmc13 IS NULL THEN LET g_rmc.rmc13 = 0  END IF
 
    DISPLAY BY NAME g_rmc.rmc02
    INPUT BY NAME   #NO:7221
      g_rmc.rmc16,g_rmc.rmc09,g_rmc.rmc18,g_rmc.rmc32 WITHOUT DEFAULTS
 
      {g_rmc.rmc07,g_rmc.rmc25,g_rmc.rmc08,g_rmc.rmc14,g_rmc.rmc16,
       g_rmc.rmc18,g_rmc.rmc09,g_rmc.rmc31,g_rmc.rmc29,g_rmc.rmc30,
       g_rmc.rmc21,g_rmc.rmc22,g_rmc.rmc17,g_rmc.rmc23,g_rmc.rmc24,
       g_rmc.rmc13,g_rmc.rmc10,g_rmc.rmc11,g_rmc.rmc12,
       g_rmc.rmc32
      }
 
   {    AFTER FIELD rmc08     #修復日期
           IF g_rmc.rmc08 IS NULL THEN NEXT FIELD rmc08 END IF
    }
        AFTER FIELD rmc16     #保固
            LET g_rmc_o.rmc16 = g_rmc.rmc16
 
#TQC-990103 --begin--
        AFTER FIELD rmc18
           IF NOT cl_null(g_rmc.rmc18) THEN 
              IF g_rmc.rmc18 < 0 THEN 
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD rmc18
              END IF 
           END IF 
#TQC-990103 --end--
 
        AFTER FIELD rmc09     #收費
            LET g_rmc_o.rmc09 = g_rmc.rmc09
    {
        AFTER FIELD rmc21     #除帳原因
            IF g_rmc.rmc21 IS NULL THEN
               LET g_rmc.rmc21 = g_rmc_t.rmc21
               DISPLAY BY NAME g_rmc.rmc21
               NEXT FIELD rmc21
            END IF
            CALL t125_rmc21()
 
        AFTER FIELD rmc10  #人工工時
            IF g_rmc.rmc10 IS NULL OR g_rmc.rmc10 < 0 THEN
                CALL cl_err('','mfg1322',0)
                NEXT FIELD rmc10
            END IF
            LET g_rmc.rmc12=g_rmc.rmc11 * g_rmc.rmc10
            DISPLAY BY NAME g_rmc.rmc12
 
        AFTER FIELD rmc11    #工資率
            IF g_rmc.rmc11 IS NULL OR g_rmc.rmc11 < 0 THEN
                CALL cl_err('','mfg1322',0)
                NEXT FIELD rmc11
            END IF
            LET g_rmc.rmc12=g_rmc.rmc11 * g_rmc.rmc10
            DISPLAY BY NAME g_rmc.rmc12
 
        AFTER FIELD rmc14     #除帳原因
            IF g_rmc.rmc14 IS NULL THEN
               LET g_rmc.rmc14 = g_rmc_t.rmc14
               DISPLAY BY NAME g_rmc.rmc14
               NEXT FIELD rmc14
            END IF
            CALL t125_rmc14()
 
        AFTER FIELD rmc31  #數量
            IF g_rmc.rmc31 IS NULL OR g_rmc.rmc31 <= 0 THEN
                CALL cl_err('','mfg1322',0)
                NEXT FIELD rmc31
            END IF
            LET g_rmc_o.rmc31 = g_rmc.rmc31
      }
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION t125_rmc11()      #工資率
    DEFINE p_cmd        LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
           l_rmg01 LIKE rmg_file.rmg01,
           l_rmg02 LIKE rmg_file.rmg02
 
    LET g_errno = ' '
    SELECT rmg01,rmg02 INTO l_rmg01,l_rmg02
           FROM rmg_file ORDER BY rmg01 DESC
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
                            LET l_rmg02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_errno =  '       ' THEN
       LET g_rmc.rmc11 = l_rmg02
      #DISPLAY BY NAME g_rmc.rmc11
    END IF
END FUNCTION
 
FUNCTION t125_rmc14()  #修復狀況
    DEFINE l_rmc14      LIKE ze_file.ze03  #No.FUN-690010 VARCHAR(30)
   #DEFINE l_rmc14      VARCHAR(10)
 
     LET l_rmc14 = ' '
     CASE g_rmc.rmc14
          WHEN '0' CALL cl_getmsg('arm-507',g_lang) RETURNING l_rmc14
          WHEN '1' CALL cl_getmsg('arm-508',g_lang) RETURNING l_rmc14
          WHEN '2' CALL cl_getmsg('arm-509',g_lang) RETURNING l_rmc14
          WHEN '3' CALL cl_getmsg('arm-514',g_lang) RETURNING l_rmc14
          WHEN '4' CALL cl_getmsg('arm-515',g_lang) RETURNING l_rmc14
          WHEN '5' CALL cl_getmsg('arm-516',g_lang) RETURNING l_rmc14
          WHEN '6' CALL cl_getmsg('arm-517',g_lang) RETURNING l_rmc14
          OTHERWISE EXIT CASE
     END CASE
     DISPLAY l_rmc14 TO FORMONLY.c14d
END FUNCTION
 
FUNCTION t125_rmc21()  #除帳原因
    DEFINE l_rmc21     LIKE ze_file.ze03  #No.FUN-690010 VARCHAR(14)
 
     LET l_rmc21 = ''
     CASE g_rmc.rmc21
          WHEN '0'  CALL cl_getmsg('arm-510',g_lang) RETURNING l_rmc21
          WHEN '1'  CALL cl_getmsg('arm-511',g_lang) RETURNING l_rmc21
          WHEN '2'  CALL cl_getmsg('arm-512',g_lang) RETURNING l_rmc21
          WHEN '3'  CALL cl_getmsg('arm-513',g_lang) RETURNING l_rmc21
          OTHERWISE EXIT CASE
     END CASE
     DISPLAY l_rmc21 TO FORMONLY.rmc21_d
END FUNCTION
 
FUNCTION t125_rmc04()  #料件編號
       DISPLAY '  '         TO FORMONLY.b02
      #DISPLAY 0            TO FORMONLY.rmb12
       DISPLAY g_rmc.rmc05  TO FORMONLY.mb04
       DISPLAY g_rmc.rmc06  TO FORMONLY.rmb05
       DISPLAY g_rmc.rmc061 TO FORMONLY.rmb06
END FUNCTION
 
FUNCTION t125_b_fetch(p_flag)              #BODY FILL UP
DEFINE
    p_flag          LIKE type_file.chr1,                    #處理方式  #No.FUN-690010 VARCHAR(1)
    p_wc2           LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(200)
    l_abso          LIKE type_file.num10                    #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N'
             FETCH NEXT t125_bcs INTO g_rmc.rmc01,g_rmc.rmc04,
                                      g_rmc.rmc02
        WHEN 'P'
             FETCH PREVIOUS t125_bcs INTO g_rmc.rmc01,g_rmc.rmc04,
                                      g_rmc.rmc02
        WHEN 'F'
             FETCH FIRST    t125_bcs INTO g_rmc.rmc01,g_rmc.rmc04,
                                      g_rmc.rmc02
        WHEN 'L'
             FETCH LAST     t125_bcs INTO g_rmc.rmc01,g_rmc.rmc04,
                                      g_rmc.rmc02
        WHEN '/'
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
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
            FETCH ABSOLUTE l_abso t125_bcs INTO g_rmc.rmc01,
                                                g_rmc.rmc04,g_rmc.rmc02
    END CASE
    IF SQLCA.sqlcode THEN
        IF SQLCA.sqlcode=100 THEN
            IF (g_b_cnt IS NULL OR g_b_cnt=0) THEN
                LET g_b_cnt=0
            END IF
           #CALL cl_err(g_rma.rma01,9064,0)
        END IF
        DISPLAY g_b_cnt TO FORMONLY.cn2
        IF p_flag='F' THEN
           INITIALIZE g_rmb.* TO NULL
           INITIALIZE g_rmc.* TO NULL
           CALL t125_b_clear()
        END IF
        RETURN
    END IF
    IF p_flag='F' THEN
        IF g_wc2 = " 1=1" THEN                  #取合乎條件筆數
           SELECT COUNT(*) INTO g_b_cnt
                  FROM rmc_file WHERE rmc01=g_rma.rma01
        ELSE
           SELECT COUNT(*) INTO g_b_cnt
                  FROM rmc_file WHERE rmc01=g_rma.rma01 AND
                       rmc04=g_rmc.rmc04
        END IF
        DISPLAY g_b_cnt TO FORMONLY.cn2
    END IF
{
    SELECT rmc_file.*,rmb_file.* INTO g_rmc.*,g_rmb.*
           FROM rmc_file,OUTER rmb_file
           WHERE rmc01 = g_rmc.rmc01 AND rmc02 = g_rmc.rmc02
           AND rmb01=rmc01 AND rmb03= rmc04
}
    SELECT rmc_file.* INTO g_rmc.* FROM rmc_file
     WHERE rmc01 = g_rmc.rmc01 AND rmc02 = g_rmc.rmc02
 
    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_rmc.rmc01,SQLCA.sqlcode,0)  # FUN-660111 
        CALL cl_err3("sel","rmc_file",g_rmc.rmc01,g_rmc.rmc02,SQLCA.sqlcode,"","",1) #FUN-660111
    ELSE
        CALL t125_b_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t125_b_show()
    IF g_rmc.rmc10 IS NULL THEN LET g_rmc.rmc10 = 0  END IF
    IF g_rmc.rmc13 IS NULL THEN LET g_rmc.rmc13 = 0  END IF
    LET g_rmc_t.* = g_rmc.*
    LET g_rmc_o.* = g_rmc.*
    DISPLAY BY NAME
      g_rmc.rmc04
    DISPLAY BY NAME
      g_rmc.rmc02,g_rmc.rmc07,g_rmc.rmc08,
      g_rmc.rmc16,g_rmc.rmc09,g_rmc.rmc29,g_rmc.rmc21,g_rmc.rmc17,
      g_rmc.rmc10,g_rmc.rmc31,g_rmc.rmc25,g_rmc.rmc14,
      g_rmc.rmc18,g_rmc.rmc32,g_rmc.rmc30,g_rmc.rmc22,g_rmc.rmc23,
      g_rmc.rmc24,g_rmc.rmc13,g_rmc.rmc11,g_rmc.rmc12
 
    CALL t125_rmc21()
    CALL t125_rmc14()
    INITIALIZE g_rmb.* TO NULL
    DECLARE z_curs SCROLL CURSOR FOR
      SELECT * FROM rmb_file
       WHERE rmb01 = g_rmc.rmc01
         AND rmb02 = g_rmc.rmc03
    OPEN z_curs
    FETCH z_curs INTO g_rmb.*
    IF STATUS = 0 THEN
       DISPLAY g_rmb.rmb02  TO FORMONLY.b02
       DISPLAY g_rmb.rmb04  TO FORMONLY.mb04
       DISPLAY g_rmb.rmb05  TO FORMONLY.rmb05
       DISPLAY g_rmb.rmb06  TO FORMONLY.rmb06
       DISPLAY g_rmb.rmb12  TO FORMONLY.rmb12
    ELSE
       CALL t125_rmc04()
    END IF
    CLOSE z_curs
    CALL cl_show_fld_cont()   #FUN-550037(smin)
END FUNCTION
 
FUNCTION t125_b_clear()
   DISPLAY BY NAME g_rmc.rmc02,g_rmc.rmc04,g_rmc.rmc07,g_rmc.rmc08,
      g_rmc.rmc16,g_rmc.rmc09,g_rmc.rmc29,g_rmc.rmc21,g_rmc.rmc17,
      g_rmc.rmc10,g_rmc.rmc31,g_rmc.rmc25,g_rmc.rmc14,
      g_rmc.rmc18,g_rmc.rmc32,g_rmc.rmc30,g_rmc.rmc22,g_rmc.rmc23,
      g_rmc.rmc24,g_rmc.rmc13,g_rmc.rmc11,g_rmc.rmc12
   DISPLAY ' '          TO FORMONLY.b02
   DISPLAY ' '          TO FORMONLY.mb04
   DISPLAY ' '          TO FORMONLY.rmb12
   DISPLAY ' '          TO FORMONLY.rmb05
   DISPLAY ' '          TO FORMONLY.rmb06
   DISPLAY ' '          TO FORMONLY.rmc21_d
   DISPLAY ' '          TO FORMONLY.c14d
END FUNCTION
 
FUNCTION t125_out()
DEFINE sr       RECORD
                rmc    RECORD LIKE rmc_file.*,
                rmd    RECORD LIKE rmd_file.*,
                rma03  LIKE rma_file.rma03,
                rma04  LIKE rma_file.rma04,
                rmc14d LIKE type_file.chr20,   #No.FUN-690010 VARCHAR(20),
                rmk02  LIKE rmk_file.rmk02
                END RECORD,
       l_name   LIKE type_file.chr20   #No.FUN-690010 VARCHAR(20)
   #-----NO.FUN-860018 BY TSD.jarlin--------------(S)                                                                               
       CALL cl_del_data(l_table)                                                                                                    
       SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog                                                                       
   #-----NO.FUN-860018----------------------------(E)  
 
   #IF cl_null(g_rmc.rmc01) OR cl_null(g_rmc.rmc02) THEN RETURN END IF
    IF cl_null(g_wc) or cl_null(g_wc2) THEN RETURN END IF
    CALL cl_wait()
#    LET l_name = 'armt125.out'
#    CALL cl_outnam('armt125') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
#No.CHI-6A0004--------Begin---------
#    SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#           FROM azi_file WHERE azi01=g_aza.aza17
#No.CHI-6A0004--------End-----------
    LET g_sql=" SELECT rmc_file.*,rmd_file.*,rma03,rma04,'',rmk02 ",
              "   FROM rma_file,rmc_file LEFT OUTER JOIN (rmd_file LEFT OUTER JOIN rmk_file ON rmk01 = CAST(rmd02 AS CHAR(4))) ON rmc01 = rmd01 AND  rmc02 = rmd03",
              "  WHERE ",g_wc CLIPPED,
              "    AND ",g_wc2 CLIPPED,
              "    AND rma01 = rmc01 ",
              "  ORDER BY rmc01,rmc02 "
    PREPARE t125_p1 FROM g_sql              # RUNTIME 編譯
    IF STATUS THEN CALL cl_err('t125_p1',STATUS,1) RETURN END IF
    DECLARE t125_co                         # SCROLL CURSOR
        CURSOR FOR t125_p1
 
#    START REPORT t125_rep TO l_name
 
    FOREACH t125_co INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        CASE sr.rmc.rmc14
             WHEN '0' CALL cl_getmsg('arm-507',g_lang) RETURNING sr.rmc14d
             WHEN '1' CALL cl_getmsg('arm-508',g_lang) RETURNING sr.rmc14d
             WHEN '2' CALL cl_getmsg('arm-509',g_lang) RETURNING sr.rmc14d
             WHEN '3' CALL cl_getmsg('arm-514',g_lang) RETURNING sr.rmc14d
             WHEN '4' CALL cl_getmsg('arm-515',g_lang) RETURNING sr.rmc14d
             WHEN '5' CALL cl_getmsg('arm-516',g_lang) RETURNING sr.rmc14d
             WHEN '6' CALL cl_getmsg('arm-517',g_lang) RETURNING sr.rmc14d
             OTHERWISE LET sr.rmc14d=' '
       END CASE
#       OUTPUT TO REPORT t125_rep(sr.*)
        #-----NO.FUN-860018 BY TSD.jarlin------------(S)                                                                            
        EXECUTE insert_prep USING sr.rmc.rmc01,sr.rmc.rmc02,sr.rmc.rmc04,                                                           
                                  sr.rmd.rmd05,sr.rmc.rmc06,sr.rmc.rmc061,                                                          
                                  sr.rmd.rmd07,sr.rmc.rmc08,sr.rmc.rmc09,                                                           
                                  sr.rmc.rmc10,sr.rmc.rmc14,sr.rmc.rmc16,                                                           
                                  sr.rmc.rmc25,sr.rmd.rmd02,sr.rmd.rmd03,                                                           
                                  sr.rmd.rmd031,sr.rmd.rmd04,sr.rmd.rmd06,                                                          
                                  sr.rmd.rmd061,                                                                                    
                                  sr.rmd.rmd12,sr.rmd.rmd13,sr.rmd.rmd14,                                                           
                                  sr.rmd.rmd21,sr.rmd.rmd23,sr.rmd.rmd24,                                                           
                                  sr.rmd.rmd27,sr.rma03,sr.rma04,                                                                   
                                  sr.rmk02,sr.rmc14d,g_azi03,g_azi04,g_azi05                                                        
                                                                                                                                    
        IF SQLCA.sqlcode THEN                                                                                                       
           CALL cl_err('foreach:',status,1)                                                                                         
           EXIT FOREACH                                                                                                             
        END IF                                                                                                                      
        #-----NO.FUN-860018--------------------------(E) 
    END FOREACH
   #-----NO.FUN-860018 BY TSD.jarlin--------------(S)                                                                               
       LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED                                                                             
                   ,l_table CLIPPED                                                                                                 
                   ," ORDER BY rmc01,rmc02,rmd02"                                                                                   
                                                                                                                                    
       IF g_zz05 = 'Y' THEN                                                                                                         
          CALL cl_wcchp(g_wc,'rma01,rma12,rma03,rma04,rma20,                                                                        
                              rmaconf,rmauser,rmagrup,rmamodu,                                                                      
                              rmadate,rmavoid')                                                                                     
          RETURNING g_str                                                                                                           
       ELSE                                                                                                                         
          LET g_str=''                                                                                                              
       END IF                                                                                                                       
       LET g_str=g_str                                                                                                              
                                                                                                                                    
       CALL cl_prt_cs3('armt125','armt125',g_sql,g_str)                                                                             
   #-----NO.FUN-860018----------------------------(E)  
#    FINISH REPORT t125_rep
    CLOSE t125_co
    MESSAGE ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#No.FUN-860018---BEGIN
#REPORT t125_rep(sr)
#DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
#       sr         RECORD
#                  rmc    RECORD LIKE rmc_file.*,
#                  rmd    RECORD LIKE rmd_file.*,
#                  rma03  LIKE rma_file.rma03,
#                  rma04  LIKE rma_file.rma04,
#                  rmc14d LIKE type_file.chr20,   #No.FUN-690010 VARCHAR(20),
#                  rmk02  LIKE rmk_file.rmk02
#                  END RECORD
 
#  OUTPUT
#    TOP MARGIN g_top_margin
#    LEFT MARGIN g_left_margin
#    BOTTOM MARGIN g_bottom_margin
#    PAGE LENGTH g_page_line
 
#  ORDER BY sr.rmc.rmc01,sr.rmc.rmc02,sr.rmd.rmd02
 
#   FORMAT
#      PAGE HEADER
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#          LET g_pageno = g_pageno + 1
#          LET pageno_total = PAGENO USING '<<<',"/pageno"
#          #TQC-5B0109&051112
#          PRINT g_x[9] CLIPPED,' ',sr.rmc.rmc01,COLUMN 54,
#                g_x[14] CLIPPED,' ',sr.rma03 CLIPPED,'(',sr.rma04 CLIPPED,')'
#          PRINT g_x[10] CLIPPED,' ',sr.rmc.rmc02 USING '##&',COLUMN 54,
#                g_x[15] CLIPPED,' ',sr.rmc.rmc14,' ',sr.rmc14d CLIPPED
#          PRINT g_x[11] CLIPPED,' ',sr.rmc.rmc08,COLUMN 54,
#                g_x[16] CLIPPED,' ',sr.rmc.rmc16,COLUMN 62,
#                g_x[18] CLIPPED,' ',sr.rmc.rmc09
#          PRINT g_x[12] CLIPPED,' ',sr.rmc.rmc04, COLUMN 54, g_x[17] CLIPPED,' ',sr.rmc.rmc10,COLUMN 66,
#                g_x[19] CLIPPED,' ',sr.rmc.rmc25
#          PRINT g_x[13] CLIPPED,' ',sr.rmc.rmc06 CLIPPED
#          PRINT COLUMN 12,sr.rmc.rmc061 CLIPPED
#          #END TQC-5B0109&051112
#          PRINT g_head CLIPPED,pageno_total
#          PRINT g_dash
#          PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#          PRINTX name=H2 g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
#          PRINTX name=H3 g_x[45],g_x[46],g_x[47]
#          PRINT g_dash1
#          LET l_last_sw = 'y'
 
#      BEFORE GROUP OF sr.rmc.rmc02
#          SKIP TO TOP OF PAGE
 
#      ON EVERY ROW
#         PRINTX name=D1 COLUMN g_c[31],sr.rmd.rmd02 USING '###&', #FUN-590118
#                        COLUMN g_c[32],sr.rmd.rmd031 USING '###&',
#                        COLUMN g_c[33],sr.rmd.rmd23,
#                        COLUMN g_c[34],sr.rmk02,
#                        COLUMN g_c[35],sr.rmd.rmd24,
#                        COLUMN g_c[36],sr.rmd.rmd21
#         PRINTX name=D2 COLUMN g_c[37],' ',
#                        COLUMN g_c[38],sr.rmd.rmd04,
#                        COLUMN g_c[39],sr.rmd.rmd07,
#                        COLUMN g_c[40],sr.rmd.rmd05,
#                        COLUMN g_c[41],cl_numfor(sr.rmd.rmd12,41,0),
#                        COLUMN g_c[42],sr.rmd.rmd27,
#                        COLUMN g_c[43],cl_numfor(sr.rmd.rmd13,43,g_azi03),
#                        COLUMN g_c[44],cl_numfor(sr.rmd.rmd14,44,g_azi04)
#         PRINTX name=D3 COLUMN g_c[45],' ',
#                        COLUMN g_c[46],sr.rmd.rmd06,
#                        COLUMN g_c[47],sr.rmd.rmd061
#        {PRINT COLUMN 10,sr.rmd.rmd031 USING '###&','  ',sr.rmd.rmd04,' ',
#               sr.rmd.rmd07,' ',sr.rmd.rmd05,sr.rmd.rmd12 USING '######&','  ',
#               sr.rmd.rmd27,'  ',sr.rmd.rmd02 USING '##&'
#         PRINT COLUMN 10,sr.rmd.rmd23,'  ',sr.rmk02,' ',sr.rmd.rmd24 }
 
#      ON LAST ROW
#        PRINT g_dash[1,g_len]
#        PRINT g_x[4] CLIPPED,COLUMN (g_len-10),g_x[7] CLIPPED
#        LET l_last_sw = 'n'
 
#      PAGE TRAILER
#        IF l_last_sw = 'y' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4] CLIPPED,COLUMN (g_len-10),g_x[6] CLIPPED
#        ELSE
#           SKIP 2 LINE
#        END IF
 
#END REPORT
#No.FUN-860018---END
#No.FUN-890102
#Patch....NO.TQC-610037 <001> #
