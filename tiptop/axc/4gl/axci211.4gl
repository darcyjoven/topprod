# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: axci211.4gl
# Descriptions...: 料件分類毛利費用率維護
# Date & Author..: 09/04/14 By jan
# Modify.........: No.FUN-940049 09/04/14 By jan
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9C0025 09/12/28 By jan新增cmc07/cmc08 欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_cmc_o         RECORD LIKE cmc_file.*,    
       g_cmca          RECORD LIKE cmc_file.*,     
       g_cmca_t        RECORD LIKE cmc_file.*,      
       g_cmc021        LIKE cmc_file.cmc021,
       g_cmc021_t      LIKE cmc_file.cmc021,  
       g_cmc022        LIKE cmc_file.cmc022,
       g_cmc022_t      LIKE cmc_file.cmc022,   
       g_cmc01         LIKE cmc_file.cmc01,   
       g_cmc01_t       LIKE cmc_file.cmc01,   
       g_cmc02         LIKE cmc_file.cmc02,   
       g_cmc02_t       LIKE cmc_file.cmc02, 
       g_cmc07         LIKE cmc_file.cmc07,  #CHI-9C0025
       g_cmc07_t       LIKE cmc_file.cmc07,  #CHI-9C0025
       g_cmc08         LIKE cmc_file.cmc07,  #CHI-9C0025
       g_cmc08_t       LIKE cmc_file.cmc07,  #CHI-9C0025
       g_cmc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
           cmc03       LIKE cmc_file.cmc03,   
           cmc04       LIKE cmc_file.cmc04    
                       END RECORD,
       g_cmc_t         RECORD                 #程式變數 (舊值)
           cmc03       LIKE cmc_file.cmc03,   
           cmc04       LIKE cmc_file.cmc04 
                       END RECORD,
       g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN
       g_rec_b         LIKE type_file.num5,                #單身筆數
       l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT    
       l_sl            LIKE type_file.num5,                #目前處理的SCREEN LINE
       g_y             LIKE type_file.num5,           
       g_m             LIKE type_file.num5,           
       g_argv1         LIKE cmc_file.cmc01            
 
#主程式開始
DEFINE g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp      STRING   #No.TQC-720019
DEFINE l_sql          STRING   #No.FUN-780017
DEFINE g_before_input_done LIKE type_file.num5  
DEFINE g_cnt          LIKE type_file.num10 
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose 
DEFINE g_msg          LIKE type_file.chr1000 
DEFINE g_row_count    LIKE type_file.num10 
DEFINE g_curs_index   LIKE type_file.num10 
DEFINE g_jump         LIKE type_file.num10 
DEFINE g_no_ask       LIKE type_file.num5  
DEFINE g_str          STRING    
MAIN
DEFINE p_row,p_col   LIKE type_file.num5          
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time  
    LET g_cmc01= NULL
    LET g_cmc01_t= NULL
    LET p_row = 3 LET p_col = 30
    OPEN WINDOW i211_w AT p_row,p_col
        WITH FORM "axc/42f/axci211"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
 
    CALL i211_menu()
    CLOSE WINDOW i211_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
         RETURNING g_time    
END MAIN
 
FUNCTION i211_cs()
DEFINE l_cmc07    LIKE cmc_file.cmc07   #CHI-9C0025

      CLEAR FORM                             #清除畫面
      CALL g_cmc.clear()
      CALL cl_set_head_visible("","YES") 
 
      INITIALIZE g_cmc021 TO NULL
      INITIALIZE g_cmc022 TO NULL  
      INITIALIZE g_cmc01 TO NULL   
      INITIALIZE g_cmc02 TO NULL   
      INITIALIZE g_cmc07 TO NULL      #CHI-9C0025
      INITIALIZE g_cmc08 TO NULL      #CHI-9C0025
 
      #螢幕上取條件
      CONSTRUCT g_wc ON cmc021,cmc022,cmc01,cmc02,cmc07,cmc08,cmc03,cmc04  #CHI-9C0025
           FROM cmc021,cmc022,cmc01,cmc02,
                cmc07,cmc08,  #CHI-9C0025
                s_cmc[1].cmc03,s_cmc[1].cmc04  
 
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
       
        #CHI-9C0025--begin--add--
        AFTER FIELD cmc07
              LET l_cmc07 = get_fldbuf(cmc07)
        #CHI-9C0025--end--add-----

         ON ACTION controlp
            CASE 
               WHEN INFIELD(cmc01) #
#FUN-AA0059---------mod------------str-----------------               
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form     = "q_ima"
#                    LET g_qryparam.state = "c"
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY g_qryparam.multiret TO cmc01
                    NEXT FIELD cmc01
               #CHI-9C0025--begin--add---
               WHEN INFIELD(cmc08)
                 IF l_cmc07 MATCHES '[45]' THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                 CASE l_cmc07
                    WHEN '4'
                      LET g_qryparam.form = "q_pja"
                    WHEN '5'
                      LET g_qryparam.form = "q_imd09"
                    OTHERWISE EXIT CASE
                 END CASE
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY  g_qryparam.multiret TO cmc08
                 NEXT FIELD cmc08
                 END IF
               #CHI-9C0025--end--add------
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
   LET g_sql= "SELECT UNIQUE cmc021,cmc022,cmc01,cmc02,cmc07,cmc08 FROM cmc_file",   #CHI-9C0025
              " WHERE ", g_wc CLIPPED,
              " ORDER BY cmc021"
   PREPARE i211_prepare FROM g_sql      #預備一下
   DECLARE i211_b_cs SCROLL CURSOR WITH HOLD FOR i211_prepare   #宣告成可捲動的
 
   LET g_sql_tmp= "SELECT UNIQUE cmc021,cmc022,cmc01,cmc02,cmc07,cmc08 FROM cmc_file",  #CHI-9C0025
                  " WHERE ", g_wc CLIPPED,
                  " INTO TEMP x "
   DROP TABLE x
   PREPARE i211_precount_x FROM g_sql_tmp  
   EXECUTE i211_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE i211_precount FROM g_sql
   DECLARE i211_count CURSOR FOR i211_precount
END FUNCTION
 
FUNCTION i211_menu()
 
   WHILE TRUE
      LET g_argv1 = ARG_VAL(1)
      CALL i211_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i211_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i211_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i211_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i211_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i211_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_cmc),'','')
            END IF
         WHEN "related_document"           #相關文件
            IF cl_chk_act_auth() THEN
               IF g_cmc01 IS NOT NULL THEN
                  LET g_doc.column1 = "cmc021"
                  LET g_doc.column2 = "cmc022"
                  LET g_doc.column3 = "cmc01"  
                  LET g_doc.column4 = "cmc07"  #CHI-9C0025 
                  LET g_doc.column5 = "cmc08"  #CHI-9C0025
                  LET g_doc.value1 = g_cmc021
                  LET g_doc.value2 = g_cmc022
                  LET g_doc.value3 = g_cmc01   
                  LET g_doc.value4 = g_cmc07   #CHI-9C0025   
                  LET g_doc.value5 = g_cmc08   #CHI-9C0025   
                  CALL cl_doc()
               END IF 
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i211_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_cmc.clear()
   INITIALIZE g_cmc021 LIKE cmc_file.cmc021
   INITIALIZE g_cmc022 LIKE cmc_file.cmc022
   INITIALIZE g_cmc01 LIKE cmc_file.cmc01 
   INITIALIZE g_cmc02 LIKE cmc_file.cmc02 
   INITIALIZE g_cmc07 LIKE cmc_file.cmc07  #CHI-9C0025 
   INITIALIZE g_cmc08 LIKE cmc_file.cmc08  #CHI-9C0025 
   INITIALIZE g_cmca.* LIKE cmc_file.*      #DEFAULT 設定
   LET g_cmc021_t = NULL
   LET g_cmc022_t = NULL
   LET g_cmc01_t = NULL                     #FUN-7B0116 add
   LET g_cmc02_t = NULL                     #FUN-7B0116 add
   LET g_cmc07_t = NULL                     #CHI-9C0025
   LET g_cmc08_t = NULL                     #CHI-9C0025
   #預設值及將數值類變數清成零
   LET g_cmc_o.* = g_cmca.*
   CALL cl_opmsg('a')
   WHILE TRUE

#FUN-BC0062 --begin--
     IF g_ccz.ccz28 = '6' THEN
        CALL cl_err('','axc-026',1)
        EXIT WHILE
     END IF
#FUN-BC0062 --end--

      LET g_cmca.cmc07 = g_ccz.ccz28   #CHI-9C0025
      LET g_cmca.cmc08 = ' '           #CHI-9C0025
      CALL i211_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_cmca.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_cmca.cmc021 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      LET g_rec_b=0
      CALL i211_b()                   #輸入單身
      LET g_cmc021_t=g_cmc021
      LET g_cmc022_t=g_cmc022
      LET g_cmc01_t=g_cmc01  
      LET g_cmc02_t=g_cmc02  
      LET g_cmc07_t=g_cmc07   #CHI-9C0025  
      LET g_cmc08_t=g_cmc08   #CHI-9C0025  
      EXIT WHILE
   END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i211_i(p_cmd)
DEFINE l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入      
       p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改       
DEFINE l_n1            LIKE type_file.chr1                  #CHI-9C0025
 
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INPUT BY NAME g_cmca.cmc021,g_cmca.cmc022,g_cmca.cmc01,g_cmca.cmc02,
                 g_cmca.cmc07,g_cmca.cmc08  #CHI-9C0025
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i211_set_entry(p_cmd)
         CALL i211_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
       
      AFTER FIELD cmc021                  #年度
         IF NOT cl_null(g_cmca.cmc021)  THEN
            LET g_cmc021=g_cmca.cmc021
         END IF
 
      AFTER FIELD cmc022                  #月份
         IF NOT cl_null(g_cmca.cmc022) THEN 
            IF g_cmca.cmc022 <= 0 OR g_cmca.cmc022 > 12 THEN
               CALL cl_err(g_cmca.cmc022,'aom-580',0)
               LET g_cmca.cmc022=g_cmc_o.cmc022
               DISPLAY BY NAME g_cmca.cmc022 
               NEXT FIELD cmc022
            END IF
            LET g_cmc_o.cmc022=g_cmca.cmc022
            LET g_cmc022=g_cmca.cmc022
         END IF
            
      AFTER FIELD cmc01      #料件
         IF NOT cl_null(g_cmca.cmc01)  THEN
           #FUN-AA0059 -----------------------add start------------------
            IF NOT s_chk_item_no(g_cmca.cmc01,'') THEN
               CALL cl_err('',g_errno,1)
               LET g_cmca.cmc01 = g_cmc01_t
               DISPLAY BY NAME g_cmca.cmc01
               NEXT FIELD cmc01
            END IF 
           #FUN-AA0059 -----------------------add end--------------------  
            LET g_cmc_o.cmc01=g_cmca.cmc01
            LET g_cmc01=g_cmca.cmc01
               SELECT count(*) INTO g_cnt FROM ima_file
                WHERE ima01 = g_cmca.cmc01
                  AND imaacti = 'Y'
               IF g_cnt = 0 THEN  
                  CALL cl_err(g_cmca.cmc01,'ams-003',0)
                  LET g_cmca.cmc01 = g_cmc01_t
                  DISPLAY BY NAME g_cmca.cmc01 
                  NEXT FIELD cmc01
               END IF
         END IF
 
      AFTER FIELD cmc02
        IF NOT cl_null(g_cmca.cmc02) THEN
           IF g_cmca.cmc02 < 0 THEN
              NEXT FIELD cmc02
           END IF
           LET g_cmc_o.cmc02=g_cmca.cmc02
           LET g_cmc02=g_cmca.cmc02
        END IF

       #CHI-9C0025--begin--add-------
        AFTER FIELD cmc07
          IF g_cmca.cmc07 IS NOT NULL THEN
             IF g_cmca.cmc07 NOT MATCHES '[12345]' THEN
                NEXT FIELD cmc07
             END IF
               IF g_cmca.cmc07 MATCHES'[12]' THEN
                  CALL cl_set_comp_entry("cmc08",FALSE)
                  LET g_cmca.cmc08 = ' '
               ELSE
                  CALL cl_set_comp_entry("cmc08",TRUE)
               END IF
            LET g_cmc_o.cmc07=g_cmca.cmc07
            LET g_cmc07=g_cmca.cmc07
          END IF

       AFTER FIELD cmc08
          IF NOT cl_null(g_cmca.cmc08) THEN
             IF p_cmd = "a" OR
              (p_cmd = "u" AND
               (g_cmca.cmc01 != g_cmc01_t OR g_cmca.cmc021 != g_cmc021_t OR
                g_cmca.cmc022 != g_cmc022_t OR
                g_cmca.cmc07 != g_cmc07_t OR g_cmca.cmc08 != g_cmc08_t)) THEN

                CASE g_cmca.cmc07
                 WHEN 4
                  SELECT pja02 FROM pja_file WHERE pja01 = g_cmca.cmc08
                                               AND pjaclose='N'
                  IF SQLCA.sqlcode!=0 THEN
                     CALL cl_err3('sel','pja_file',g_cmca.cmc08,'',SQLCA.sqlcode,'','',1)
                     NEXT FIELD cmc08
                  END IF
                 WHEN 5
                   LET l_n1 = 0
                   SELECT COUNT(*) INTO l_n1 FROM imd_file
                    WHERE imd09 = g_cmca.cmc08
                      AND imdacti = 'Y'
                   IF l_n1=0 THEN
                     CALL cl_err3('sel','imd_file',g_cmca.cmc08,'',100,'','',1)
                     NEXT FIELD cmc08
                  END IF
                 OTHERWISE EXIT CASE
                END CASE
             END IF
          ELSE
             LET g_cmca.cmc08=' '
          END IF
          LET g_cmc_o.cmc08=g_cmca.cmc08
          LET g_cmc08=g_cmca.cmc08
        #CHI-9C0025--end--add--------

      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF
         IF g_cmca.cmc022 IS NULL OR g_cmca.cmc022 <=0 OR g_cmca.cmc02 > 12 THEN
            LET l_flag='Y'
            DISPLAY BY NAME g_cmca.cmc022 
         END IF  
         LET g_cmc02=g_cmca.cmc02  
 
 
      ON ACTION CONTROLP                                                                                                            
         CASE                                                                                                                       
            WHEN INFIELD(cmc01)     #料號  
#FUN-AA0059---------mod------------str-----------------                                                                                                     
#               CALL cl_init_qry_var()                                                                                               
#               LET g_qryparam.form ="q_ima"                                                                                       
#               LET g_qryparam.default1 = g_cmca.cmc01                                                                                    
#               CALL cl_create_qry() RETURNING g_cmca.cmc01 
               CALL q_sel_ima(FALSE, "q_ima","",g_cmca.cmc01,"","","","","",'' ) 
                  RETURNING  g_cmca.cmc01

#FUN-AA0059---------mod------------end-----------------                                                                              
               DISPLAY  g_cmca.cmc01 TO cmc01                                                                                            
               NEXT FIELD cmc01 
             #CHI-9C0025--begin--add--------
               WHEN INFIELD(cmc08)
                 IF g_cmca.cmc07 MATCHES '[45]' THEN
                    CALL cl_init_qry_var()
                 CASE g_cmca.cmc07
                    WHEN '4'
                      LET g_qryparam.form = "q_pja"
                    WHEN '5'
                      LET g_qryparam.form = "q_imd09"
                    OTHERWISE EXIT CASE
                 END CASE
                 LET g_qryparam.default1 =g_cmca.cmc08
                 CALL cl_create_qry() RETURNING g_cmca.cmc08
                 DISPLAY BY NAME g_cmca.cmc08
                 NEXT FIELD cmc08
                 END IF
               #CHI-9C0025--end--add-------
             OTHERWISE EXIT CASE                                                                                                     
         END CASE 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
    
   END INPUT
END FUNCTION
 
FUNCTION i211_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1   
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("cmc021,cmc022,cmc01,cmc07,cmc08",TRUE)  #CHI-9C0025
   END IF
END FUNCTION
 
FUNCTION i211_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1  
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("cmc021,cmc022,cmc01,cmc07,cmc08",FALSE)  #CHI-9C0025
   END IF
   #CHI-9C0025--begin--add----
    IF p_cmd = 'u' AND g_chkey MATCHES '[Yy]' AND
       (NOT g_before_input_done) THEN
       IF g_cmca.cmc07 MATCHES'[12]' THEN
          CALL cl_set_comp_entry("cmc08",FALSE)
       ELSE
          CALL cl_set_comp_entry("cmc08",TRUE)
       END IF
    END IF
    #CHI-9C0025--end--add---
END FUNCTION
 
FUNCTION i211_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_cmc021 TO NULL 
   INITIALIZE g_cmc022 TO NULL 
   INITIALIZE g_cmc01 TO NULL 
   INITIALIZE g_cmc07 TO NULL  #CHI-9C0025
   INITIALIZE g_cmc08 TO NULL  #CHI-9C0025
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL i211_cs()                    #取得查詢條件
   IF INT_FLAG THEN                  #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i211_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_cmc021 TO NULL
      INITIALIZE g_cmc022 TO NULL  
      INITIALIZE g_cmc01 TO NULL  
   ELSE
      OPEN i211_count
      FETCH i211_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL i211_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i211_fetch(p_flag)
DEFINE p_flag       LIKE type_file.chr1      #處理方式   #No.FUN-680122 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i211_b_cs INTO g_cmc021,g_cmc022,g_cmc01,g_cmc02,
                                             g_cmc07,g_cmc08   #CHI-9C0025
      WHEN 'P' FETCH PREVIOUS i211_b_cs INTO g_cmc021,g_cmc022,g_cmc01,g_cmc02, 
                                             g_cmc07,g_cmc08   #CHI-9C0025
      WHEN 'F' FETCH FIRST    i211_b_cs INTO g_cmc021,g_cmc022,g_cmc01,g_cmc02, 
                                             g_cmc07,g_cmc08   #CHI-9C0025
      WHEN 'L' FETCH LAST     i211_b_cs INTO g_cmc021,g_cmc022,g_cmc01,g_cmc02,  
                                             g_cmc07,g_cmc08   #CHI-9C0025
      WHEN '/'
           IF (NOT g_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
                   #CONTINUE PROMPT
 
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
           FETCH ABSOLUTE g_jump i211_b_cs INTO g_cmc021,g_cmc022,g_cmc01,g_cmc02,
                                                g_cmc07,g_cmc08   #CHI-9C0025
           LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cmc01,SQLCA.sqlcode,0)
      INITIALIZE g_cmc021 TO NULL 
      INITIALIZE g_cmc022 TO NULL 
      INITIALIZE g_cmc01 TO NULL 
      INITIALIZE g_cmc07 TO NULL  #CHI-9C0025
      INITIALIZE g_cmc08 TO NULL  #CHI-9C0025
   ELSE
      CALL i211_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i211_show()
   DISPLAY g_cmc021,g_cmc022,g_cmc01,g_cmc02,g_cmc07,g_cmc08 #CHI-9C0025
        TO cmc021,cmc022,cmc01,cmc02,cmc07,cmc08  #CHI-9C0025
        
   CALL i211_b_fill(g_wc)                 #單身
   CALL cl_show_fld_cont()               
END FUNCTION
 
#單身
FUNCTION i211_b()
DEFINE l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  
       l_n             LIKE type_file.num5,    #檢查重複用 
       l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  
       p_cmd           LIKE type_file.chr1,    #處理狀態 
       l_length        LIKE type_file.num5,    #長度
       l_allow_insert  LIKE type_file.num5,    #可新增否 
       l_allow_delete  LIKE type_file.num5     #可刪除否
 
   LET g_action_choice = ""
   LET g_cmca.cmc021=g_cmc021
   LET g_cmca.cmc022=g_cmc022
   LET g_cmca.cmc01=g_cmc01
   LET g_cmca.cmc02=g_cmc02 
   LET g_cmca.cmc07=g_cmc07   #CHI-9C0025 
   LET g_cmca.cmc08=g_cmc08   #CHI-9C0025 
   IF g_cmca.cmc021 IS NULL OR g_cmca.cmc021 = 0 THEN RETURN END IF
   IF g_cmca.cmc01 IS NULL THEN RETURN END IF 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT cmc03,cmc04 ",  
                      "  FROM cmc_file ", 
                      " WHERE cmc021 =? ",
                      "   AND cmc022 =? ",
                      "   AND cmc01 =? ", 
                      "   AND cmc03 =? ",
                      "   AND cmc07 =? ",  #CHI-9C0025
                      "   AND cmc08 =? ",  #CHI-9C0025
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i211_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
                  
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_cmc WITHOUT DEFAULTS FROM s_cmc.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         #CALL i211_set_entry_b()
         #CALL i211_set_no_entry_b()
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b>=l_ac THEN
            LET g_cmc_t.* = g_cmc[l_ac].*  #BACKUP
            LET p_cmd='u'
 
            OPEN i211_bcl USING g_cmca.cmc021,g_cmca.cmc022,g_cmca.cmc01, 
                                g_cmc_t.cmc03,g_cmca.cmc07,g_cmca.cmc08  #CHI-9C0025
            IF STATUS THEN
               CALL cl_err("OPEN i211_bcl:", STATUS, 1)
               CLOSE i211_bcl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH i211_bcl INTO g_cmc[l_ac].* 
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_cmc_t.cmc03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_cmca.cmc08) THEN LET g_cmca.cmc08 = ' ' END IF  #CHI-9C0025
         INSERT INTO cmc_file(cmc021,cmc022,cmc01,cmc02,cmc03,cmc04,cmc07,cmc08,cmclegal) #CHI-9C0025    #FUN-A50075 add legal
         VALUES(g_cmca.cmc021,g_cmca.cmc022,g_cmca.cmc01,g_cmca.cmc02,g_cmc[l_ac].cmc03,
                g_cmc[l_ac].cmc04,g_cmca.cmc07,g_cmca.cmc08,g_legal)  #CHI-9C0025     #FUN-A50075 ADD LEGAL
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","cmc_file",g_cmca.cmc021,g_cmca.cmc022,SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_cmc[l_ac].* TO NULL      #900423
         LET g_cmc[l_ac].cmc04 = 0
         LET g_cmc_t.* = g_cmc[l_ac].*             #新輸入資料
         CALL cl_show_fld_cont()     
 
      AFTER FIELD cmc03     
            IF g_cmc[l_ac].cmc03 IS NOT NULL AND 
              (g_cmc[l_ac].cmc03 != g_cmc_t.cmc03 OR g_cmc_t.cmc03 IS NULL) THEN
               SELECT count(*) INTO g_cnt
                 FROM cmc_file
                WHERE cmc021 = g_cmca.cmc021
                  AND cmc022 = g_cmca.cmc022
                  AND cmc07 = g_cmca.cmc07   #CHI-9C0025
                  AND cmc08 = g_cmca.cmc08   #CHI-9C0025
                  AND cmc01 = g_cmca.cmc01  
                  AND cmc03 = g_cmc[l_ac].cmc03
               IF g_cnt > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_cmc[l_ac].cmc03 = g_cmc_t.cmc03
                  NEXT FIELD cmc03
               END IF
            END IF
      
 
      AFTER FIELD cmc04
         IF NOT cl_null(g_cmc[l_ac].cmc04) THEN
            IF g_cmc[l_ac].cmc04<0 THEN 
               NEXT FIELD cmc04
             END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_cmca_t.cmc03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
               DELETE FROM cmc_file WHERE cmc021 = g_cmca.cmc021
                                      AND cmc022 = g_cmca.cmc022
                                      AND cmc01 = g_cmca.cmc01
                                      AND cmc07 = g_cmca.cmc07   #CHI-9C0025
                                      AND cmc08 = g_cmca.cmc08   #CHI-9C0025
                                      AND cmc03 = g_cmc_t.cmc03
                                   
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","cmc_file",g_cmca.cmc01,g_cmca.cmc02,SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_cmc[l_ac].* = g_cmc_t.*
            CLOSE i211_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_cmc[l_ac].cmc03,-263,1)
            LET g_cmc[l_ac].* = g_cmc_t.*
         ELSE
            UPDATE cmc_file SET cmc03=g_cmc[l_ac].cmc03,
                                cmc04=g_cmc[l_ac].cmc04
                          WHERE cmc021 = g_cmca.cmc021 
                            AND cmc022 = g_cmca.cmc022
                            AND cmc01 = g_cmca.cmc01 
                            AND cmc07 = g_cmca.cmc07  #CHI-9C0025 
                            AND cmc08 = g_cmca.cmc08  #CHI-9C0025 
                            AND cmc03 = g_cmc_t.cmc03
            IF SQLCA.sqlcode THEN #No.FUN-660127
               LET g_cmc[l_ac].* = g_cmc_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac       #FUN-D40030 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_cmc[l_ac].* = g_cmc_t.*
            #FUN-D40030---add---str---
            ELSE
               CALL g_cmc.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030---add---end---
            END IF
            CLOSE i211_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac       #FUN-D40030 add
         CLOSE i211_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cmc03) AND l_ac > 1 THEN
               LET g_cmc[l_ac].* = g_cmc[l_ac-1].*
               NEXT FIELD cmc03
            END IF
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")         #No.FUN-6A0092
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
      
   CLOSE i211_bcl
   COMMIT WORK
END FUNCTION
   
FUNCTION i211_b_askkey()
DEFINE l_wc            LIKE type_file.chr1000     
 
   CALL cl_opmsg('q')
   CLEAR cmc03cmc04 
   #螢幕上取條件
   CONSTRUCT l_wc ON cmc03,cmc04
        FROM s_cmc[1].cmc03,s_cmc[1].cmc04
 
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
   CALL i211_b_fill(l_wc)
   CALL cl_opmsg('b')
END FUNCTION
 
FUNCTION i211_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc          LIKE type_file.chr1000        
 
   LET g_sql = "SELECT cmc03,cmc04",  
               "  FROM cmc_file",
               " WHERE cmc021 = ",g_cmc021,
               "   AND cmc022 = ",g_cmc022,
               "   AND cmc01 = '",g_cmc01,"'",   
               "   AND cmc07 = '",g_cmc07,"'",  #CHI-9C0025 
               "   AND cmc08 = '",g_cmc08,"'",  #CHI-9C0025 
               "   AND ",p_wc CLIPPED 
   IF NOT cl_null(g_cmc02) THEN
      LET g_sql = g_sql CLIPPED," AND cmc02 = '",g_cmc02,"'"
   ELSE
      LET g_sql = g_sql CLIPPED," AND cmc02 IS NULL "
   END IF
   LET g_sql = g_sql," ORDER BY 1"
   PREPARE i211_prepare2 FROM g_sql      #預備一下
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE i211_curs1 CURSOR FOR i211_prepare2
   CALL g_cmc.clear()
   LET g_cnt = 1
   FOREACH i211_curs1 INTO g_cmc[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('B_FILL:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_cmc.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i211_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cmc TO s_cmc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION first 
         CALL i211_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY 
 
      ON ACTION previous
         CALL i211_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY 
 
      ON ACTION jump 
         CALL i211_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
 	 ACCEPT DISPLAY                   
 
      ON ACTION next
         CALL i211_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY   
 
      ON ACTION last 
         CALL i211_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY 
                              
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
         CALL cl_show_fld_cont()   
 
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
         LET INT_FLAG=FALSE
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
 
      ON ACTION related_document     
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      ON ACTION controls        
         CALL cl_set_head_visible("","AUTO")           
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i211_r()
   IF g_cmc01 IS NULL THEN
      CALL cl_err("",-400,0)   
      RETURN 
   END IF
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL         #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "cmc021"       #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "cmc022"       #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "cmc01"        #No.FUN-9B0098 10/02/24
       LET g_doc.column4 = "cmc07"        #No.FUN-9B0098 10/02/24
       LET g_doc.column5 = "cmc08"        #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_cmc021        #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_cmc022        #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_cmc01         #No.FUN-9B0098 10/02/24
       LET g_doc.value4 = g_cmc07         #No.FUN-9B0098 10/02/24
       LET g_doc.value5 = g_cmc08         #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      IF NOT cl_null(g_cmc02) THEN
         DELETE FROM cmc_file
          WHERE cmc021=g_cmc021 AND cmc022=g_cmc022 AND cmc01=g_cmc01 AND cmc02=g_cmc02  
            AND cmc07=g_cmc07 AND cmc08=g_cmc08   #CHI-9C0025
      ELSE
         DELETE FROM cmc_file
          WHERE cmc021=g_cmc021 AND cmc022=g_cmc022 AND cmc01=g_cmc01 AND cmc02 IS NULL
            AND cmc07=g_cmc07 AND cmc08=g_cmc08   #CHI-9C0025
      END IF  
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","cmc_file",g_cmc01,g_cmc02,SQLCA.sqlcode,"","BODY DELETE",1)  
      ELSE
         CLEAR FORM
         CALL g_cmc.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         DROP TABLE x
         PREPARE i211_precount_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i211_precount_x2                 #No.TQC-720019
         OPEN i211_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i211_b_cs
            CLOSE i211_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i211_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i211_b_cs
            CLOSE i211_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i211_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i211_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i211_fetch('/')
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION i211_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
    l_za05          LIKE za_file.za05,
    l_name          LIKE type_file.chr20          #No.FUN-680122    VARCHAR(20)           #External(Disk) file name
 
    IF g_wc IS NULL THEN 
       IF NOT cl_null(g_cmc01) THEN
          LET g_wc=" cmc021=",g_cmc021," AND cmc022= ",g_cmc022,
                                     " AND cmc01='",g_cmc01,"'",
                                     " AND cmc07='",g_cmc07,"'",  #CHI-9C0025
                                     " AND cmc08='",g_cmc08,"'",  #CHI-9C0025
                                     " AND cmc02='",g_cmc02,"'"   
       ELSE
          CALL cl_err('','9057',0) RETURN 
       END IF
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'cmc021,cmc022,cmc01,cmc02,cmc03,cmc04,cmc07,cmc08') #CHI-9C0025  
            RETURNING g_str                                                     
    END IF
    LET l_sql = "SELECT cmc021,cmc022,cmc01,cmc02,cmc03,cmc04 ", 
                "  FROM cmc_file ",                                                                                                        
                " WHERE ",g_wc CLIPPED  
    CALL cl_prt_cs1('axci211','axci211',l_sql,g_str)
END FUNCTION
#FUN-940049
