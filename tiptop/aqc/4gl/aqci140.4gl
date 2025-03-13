# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aqci140.4gl
# Descriptions...: 料件供應商檢驗資料維護作業
# Date & Author..: 97/12/24 By Melody
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-4B0255 04/11/26 By Mandy 串apmi600時,可針對供應商顯示相關的資料,如果供應商空白則可查詢全部的資料
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-690024 06/09/19 By jamie 判斷pmcacti
# Modify.........: No.FUN-690022 06/09/19 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0160 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7A0198 07/10/31 By Pengu 單身新增資料時會出現"必要輸入"的欄位卻塞進了NULL值的錯誤
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-920075 09/02/23 By xiaofeizhu _curs段之組sql及_b段之lock cursor及_i段的lock cursor及b_fill段的sql不要加有效無效判斷
# Modify.........: No.TQC-950130 09/05/21 By chenmoyan 復制時，單頭料號會判斷是否存在，但不存在的料號仍可正常存檔。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.TQC-9C0138 09/12/17 By Smapmin 單身insert 時會有 pmh23 為null
# Modify.........: No:FUN-9C0071 10/01/12 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A80063 10/08/13 By wujie    添加aqci140中pmh15和pmh16的item
# Modify.........: No.FUN-AA0015 10/10/07 By Nicola 預設pmh25 
# Modify.........: No.FUN-AA0059 10/10/27 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管 
# Modify.........: No.MOD-AC0095 10/12/13 BY sabrina l_desc型態改為LIKE ze_file.ze03
# Modify.........: No.CHI-BB0007 12/02/08 By jt_chen 在料件供應商檢驗資料維護作業(aqci140)畫面上只顯示一筆資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/16 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D50115 13/05/24 By lixh1 修改複製后刪除單身資料資料被鎖的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_pmh01         LIKE pmh_file.pmh01,   #類別代號 (假單頭)
    g_pmh22         LIKE pmh_file.pmh22,   #CHI-8C0017
    g_pmhacti       LIKE pmh_file.pmhacti, #    96-06-18
    g_pmhuser       LIKE pmh_file.pmhuser, #
    g_pmhgrup       LIKE pmh_file.pmhgrup, #
    g_pmhmodu       LIKE pmh_file.pmhmodu, #
    g_pmhdate       LIKE pmh_file.pmhdate, #
    g_pmh01_t       LIKE pmh_file.pmh01,   #類別代號 (舊值)
    g_pmh22_t       LIKE pmh_file.pmh22,   #CHI-8C0017
    g_pmh           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                pmh02       LIKE pmh_file.pmh02,
		pmc03       LIKE pmc_file.pmc03,
		pmh21       LIKE pmh_file.pmh21,     #No.CHI-8C0017 add
		pmh05       LIKE pmh_file.pmh05,
		pmh06       LIKE pmh_file.pmh06,
		pmh08       LIKE pmh_file.pmh08,
		pmh09       LIKE pmh_file.pmh09,
		pmh15       LIKE pmh_file.pmh15,
		pmh16       LIKE pmh_file.pmh16,
        ta_pmh01    LIKE pmh_file.ta_pmh01,
        ta_pmh02    LIKE pmh_file.ta_pmh02,
        ta_pmh03    LIKE pmh_file.ta_pmh03
                    END RECORD,
    g_pmh_t         RECORD                 #程式變數 (舊值)
                pmh02       LIKE pmh_file.pmh02,
		pmc03       LIKE pmc_file.pmc03,
		pmh21       LIKE pmh_file.pmh21,     #No.CHI-8C0017 add
		pmh05       LIKE pmh_file.pmh05,
		pmh06       LIKE pmh_file.pmh06,
		pmh08       LIKE pmh_file.pmh08,
		pmh09       LIKE pmh_file.pmh09,
		pmh15       LIKE pmh_file.pmh15,
		pmh16       LIKE pmh_file.pmh16,
        ta_pmh01    LIKE pmh_file.ta_pmh01,
        ta_pmh02    LIKE pmh_file.ta_pmh02,
        ta_pmh03    LIKE pmh_file.ta_pmh03
                    END RECORD,
    g_argv1         LIKE pmh_file.pmh01,
    g_wc,g_sql      STRING,                      #No.FUN-580092 HCN        #No.FUN-680104
    g_cmd           LIKE type_file.chr1000,      #MOD-4B0255        #No.FUN-680104
    g_ss            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)             #決定後續步驟
    g_rec_b         LIKE type_file.num5,         #單身筆數        #No.FUN-680104 SMALLINT
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql   STRING                       #SELECT ... FOR UPDATE SQL        #No.FUN-680104
DEFINE g_chr          LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5          #No.FUN-680104 SMALLINT
DEFINE g_cnt_1        LIKE type_file.num10         #CHI-8C0017

DEFINE g_ima     RECORD LIKE ima_file.*
DEFINE g_ima_t   RECORD LIKE ima_file.*
 
MAIN
DEFINE
    p_row,p_col   LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AQC")) THEN
       EXIT PROGRAM
    END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
    LET g_argv1  = ARG_VAL(1)              #料件編號
    LET g_pmh01 = NULL                     #清除鍵值
    LET g_pmh01_t = NULL
    LET g_pmh01 = g_argv1
    LET g_pmh22 = NULL                     #CHI-8C0017
    LET g_pmh22_t = NULL                   #CHI-8C0017
 
    LET p_row = 4 LET p_col = 6
    OPEN WINDOW i140_w AT p_row,p_col
         WITH FORM "aqc/42f/aqci140"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
	CALL  i140_q()
    END IF
    CALL i140_menu()
    CLOSE WINDOW i140_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION i140_curs()
   DEFINE
    l_pmh  RECORD
            pmh01	 LIKE pmh_file.pmh01,       
            pmh22  LIKE pmh_file.pmh22        
           END RECORD   
 
    CLEAR FORM                             #清除畫面
    CALL g_pmh.clear()
    IF g_argv1 IS NULL OR g_argv1 = ' ' THEN
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pmh01 TO NULL    #No.FUN-750051
   INITIALIZE g_pmh22 TO NULL    #No.CHI-8C0017
    CONSTRUCT g_wc ON pmh01,pmh22 FROM pmh01,pmh22                      #CHI-8C0017 Add pmh22
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmhuser', 'pmhgrup') #FUN-980030
       IF INT_FLAG THEN RETURN END IF
    ELSE LET g_wc = " pmh01 = '",g_argv1,"'"
    END IF
    LET g_sql= "SELECT UNIQUE pmh01,pmh22 FROM pmh_file ",                      #CHI-8C0017 Add pmh22
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i140_prepare FROM g_sql      #預備一下
    DECLARE i140_b_curs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i140_prepare
 
    LET g_cnt_1 = 0
    FOREACH i140_b_curs INTO l_pmh.*
            LET g_cnt_1 = g_cnt_1 + 1
	  END FOREACH 
    
END FUNCTION
 
 
FUNCTION i140_menu()
 
   WHILE TRUE
      CALL i140_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i140_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i140_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i140_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i140_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmh),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_pmh01 IS NOT NULL THEN
                 LET g_doc.column1 = "pmh01"
                 LET g_doc.value1 = g_pmh01
                 CALL cl_doc()
               END IF
                END IF
                
         WHEN "check_material"          #add by hlf07751
     IF cl_chk_act_auth() THEN
   
        CALL cl_set_comp_entry("imaud03,imaud04",TRUE)
        SELECT imaud03 INTO g_ima.imaud03 FROM ima_file WHERE ima01=g_pmh01
         DISPLAY  g_ima.imaud03  TO FORMONLY.imaud03
            LET g_ima.imaud04 = 'Y'
            DISPLAY  g_ima.imaud04  TO FORMONLY.imaud04
            
        INPUT BY NAME g_ima.imaud04,g_ima.imaud03 WITHOUT DEFAULTS

        AFTER FIELD imaud03
        IF g_ima.imaud04 ='N' THEN
           IF NOT cl_null(g_ima.imaud03) THEN   
              CALL cl_err('','hlf03',0)
              LET g_ima.imaud03 = ''
              DISPLAY  g_ima.imaud03  TO FORMONLY.imaud03
              NEXT FIELD imaud03
           END IF
        ELSE
           IF cl_null(g_ima.imaud03) OR g_ima.imaud03 = 0 THEN   
              CALL cl_err('','hlf04',0)
              LET g_ima.imaud03 = ''
              DISPLAY  g_ima.imaud03  TO FORMONLY.imaud03
              NEXT FIELD imaud03
           END IF
        END IF
        
    
       END INPUT
        
       UPDATE ima_file SET
                imaud03 = g_ima.imaud03,
                imaud04 = g_ima.imaud04
       WHERE ima01 = g_pmh01
 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","qcs_file",g_pmh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
         LET g_success = 'N'
      END IF

      SELECT * INTO g_ima.* FROM ima_file   
      WHERE ima01 = g_pmh01
      CALL i140_show()
   END IF
        
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i140_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_pmh.clear()
    INITIALIZE g_pmh01 LIKE pmh_file.pmh01
    INITIALIZE g_pmh22 LIKE pmh_file.pmh22                   #CHI-8C0017
    LET g_pmh01_t = NULL
    LET g_pmh22_t = NULL                                     #CHI-8C0017
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i140_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ss='N' THEN
            CALL g_pmh.clear()
        ELSE
            CALL i140_b_fill('1=1')         #單身
        END IF
        LET g_rec_b = 0
        CALL i140_b()                   #輸入單身
        LET g_pmh01_t = g_pmh01            #保留舊值
        LET g_pmh22_t = g_pmh22            #CHI-8C0017
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i140_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680104 VARCHAR(1)
 
    LET g_ss='Y'
    LET g_pmhacti = 'Y'             # 有效的資料 96-06-18
    LET g_pmhuser = g_user          # 使用者
    LET g_pmhgrup = g_grup          # 使用者所屬群
    LET g_pmhdate = g_today         # 更改日期
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT g_pmh01,g_pmh22                        #CHI-8C0017
        WITHOUT DEFAULTS
        FROM pmh01,pmh22                         #CHI-8C0017
 
	BEFORE FIELD pmh01
	  IF g_sma.sma60 = 'Y'		# 若須分段輸入
	     THEN CALL s_inp5(8,15,g_pmh01) RETURNING g_pmh01
	          DISPLAY g_pmh01 TO pmh01
    	  END IF
 
        AFTER FIELD pmh01                  #類別代號
            IF NOT cl_null(g_pmh01) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_pmh01,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_pmh01= g_pmh01_t
                  NEXT FIELD pmh01
               END IF
#FUN-AA0059 ---------------------end-------------------------------
                IF g_pmh01 != g_pmh01_t OR     #輸入後更改不同時值
                   g_pmh01_t IS NULL THEN
                    SELECT UNIQUE pmh01 INTO g_chr
                        FROM pmh_file
                        WHERE pmh01=g_pmh01
                          AND pmhacti = 'Y'                                           #CHI-910021
                    IF SQLCA.sqlcode THEN             #不存在, 新來的
                        IF p_cmd='a' THEN
                            LET g_ss='N'
                        END IF
                    ELSE
                        IF p_cmd='u' THEN
                            CALL cl_err(g_pmh01,-239,0)
                            LET g_pmh01=g_pmh01_t
                            NEXT FIELD pmh01
                        END IF
                    END IF
                END IF
                CALL i140_pmh01('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_pmh01,g_errno,0)
                   NEXT FIELD pmh01
                END IF
            END IF
            
        BEFORE FIELD  pmh22 
           CALL i140_set_entry_b(p_cmd)                                           
 
        AFTER FIELD pmh22
           IF NOT cl_null(g_pmh22) THEN 
              IF g_pmh22 NOT MATCHES '[12]' THEN
                 NEXT FIELD pmh22
              END IF
           END IF
           CALL i140_set_no_entry_b(p_cmd)                                        
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(pmh01)
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#                    LET g_qryparam.default1 = ''
#                    CALL cl_create_qry() RETURNING g_pmh01
                     CALL q_sel_ima(FALSE, "q_ima","",'',"","","","","",'' ) 
                       RETURNING  g_pmh01  
#FUN-AA0059---------mod------------end-----------------
                     DISPLAY BY NAME g_pmh01
                     NEXT FIELD pmh01
                OTHERWISE EXIT CASE
            END CASE
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE INPUT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
    END INPUT
END FUNCTION
 
FUNCTION  i140_pmh01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
   #l_desc          LIKE type_file.chr4,          #No.FUN-680104 VARCHAR(04)  #MOD-AC0095 mark
    l_desc          LIKE ze_file.ze03,            #MOD-AC0095 add
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_ima103        LIKE ima_file.ima103,
    l_imaacti       LIKE ima_file.imaacti,          #資料有效碼
    l_imaud03       LIKE ima_file.imaud03,
    l_imaud04       LIKE ima_file.imaud04
    LET g_errno = ' '
    SELECT ima02, ima021, ima103, imaacti,imaud03,imaud04
        INTO l_ima02, l_ima021, l_ima103, l_imaacti,l_imaud03,l_imaud04
        FROM ima_file
        WHERE ima01 = g_pmh01
    CASE WHEN STATUS=100          LET g_errno = 'mfg0002' #No.7926
              LET l_ima02 = NULL LET l_ima021 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       CALL s_purdesc(l_ima103) RETURNING l_desc
       DISPLAY l_ima02  TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
       DISPLAY l_desc   TO FORMONLY.desc
       DISPLAY l_imaud03  TO FORMONLY.imaud03
       DISPLAY l_imaud04 TO FORMONLY.imaud04
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION i140_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_pmh01 TO NULL              #No.FUN-6A0160
    INITIALIZE g_pmh22 TO NULL              #No.CHI-8C0017
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i140_curs()                        #取得查詢條件
    IF INT_FLAG THEN                        #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_pmh01 TO NULL
        INITIALIZE g_pmh22 TO NULL          #No.CHI-8C0017
        RETURN
    END IF
    OPEN i140_b_curs                        #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                   #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_pmh01 TO NULL
        INITIALIZE g_pmh22 TO NULL          #No.CHI-8C0017
    ELSE
        CALL i140_fetch('F')                #讀出TEMP第一筆並顯示
        LET g_row_count = g_cnt_1
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i140_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680104 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i140_b_curs INTO g_pmh01,g_pmh22          #CHI-8C0017 Add g_pmh22
        WHEN 'P' FETCH PREVIOUS i140_b_curs INTO g_pmh01,g_pmh22          #CHI-8C0017 Add g_pmh22
        WHEN 'F' FETCH FIRST    i140_b_curs INTO g_pmh01,g_pmh22          #CHI-8C0017 Add g_pmh22
        WHEN 'L' FETCH LAST     i140_b_curs INTO g_pmh01,g_pmh22          #CHI-8C0017 Add g_pmh22
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i140_b_curs INTO g_pmh01,g_pmh22          #CHI-8C0017 Add g_pmh22
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_pmh01,SQLCA.sqlcode,0)
        INITIALIZE g_pmh01 TO NULL
    ELSE
        CALL i140_show()
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
FUNCTION i140_show()
 DEFINE  l_tot    LIKE pmh_file.pmh11
 
    DISPLAY g_pmh01 TO pmh01                #單頭
    DISPLAY g_pmh22 TO pmh22                #CHI-8C0017
    CALL i140_pmh01('d')                    #單身
    CALL i140_b_fill(g_wc)                  #單身
    CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i140_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_pmh01 IS NULL THEN
       CALL cl_err("",-400,0)               #No.FUN-6A0160
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "pmh01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_pmh01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM pmh_file WHERE pmh01 = g_pmh01
                               AND pmh22 = g_pmh22                                      #CHI-8C0017
                               AND pmh23 = ' '            #No.CHI-960033
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","pmh_file",g_pmh01,"",SQLCA.sqlcode,"","BODY DELETE",1)  #No.FUN-660115
        ELSE
            CLEAR FORM
            CALL g_pmh.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            LET g_row_count = g_cnt_1-g_cnt
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i140_b_curs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i140_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i140_fetch('/')
            END IF
 
        END IF
        LET g_msg=TIME
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i140_b()
DEFINE
    l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT  #No.FUN-680104 SMALLINT
    l_n             LIKE type_file.num5,       #檢查重複用      #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,       #單身鎖住否      #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,       #處理狀態        #No.FUN-680104 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,    #可新增否        #No.FUN-680104 VARCHAR(80)
    l_allow_insert  LIKE type_file.num5,       #可新增否        #No.FUN-680104 SMALLINT
    l_allow_delete  LIKE type_file.num5        #可刪除否        #No.FUN-680104 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_pmh01 IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
    LET g_pmhmodu=g_user          #修改者96-06-18
    LET g_pmhdate=g_today         #修改日期
    
    LET g_forupd_sql =
      " SELECT pmh02,'',pmh21,pmh05,pmh06,pmh08,pmh09,pmh15,pmh16,ta_pmh01,ta_pmh02,ta_pmh03,'' ",                  #CHI-8C0017
      "   FROM pmh_file ",
      "   WHERE pmh01= ? ",
      "    AND pmh02= ? ",
      "    AND pmh22= ? ",    #No.CHI-8C0017 add
      "    AND pmh23 = ' '",  #No.CHI-960033
      "    AND pmh21= ? ",    #No.CHI-8C0017 add
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i140_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_pmh WITHOUT DEFAULTS FROM s_pmh.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_pmh_t.* = g_pmh[l_ac].*  #BACKUP
                BEGIN WORK
                CALL i140_set_entry_b(p_cmd)                                           
                CALL i140_set_no_entry_b(p_cmd)                                        
                OPEN i140_bcl USING g_pmh01,g_pmh_t.pmh02,g_pmh22,g_pmh_t.pmh21                                 #CHI-8C0017                
                IF STATUS THEN
                    CALL cl_err("OPEN i140_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i140_bcl INTO g_pmh[l_ac].*
------------------add by hlf07751--------------------------------------------
                     IF  g_pmh[l_ac].ta_pmh01 IS NULL THEN
                     LET g_pmh[l_ac].ta_pmh01 = 'N'
                     END IF 
                     IF  g_pmh[l_ac].ta_pmh02 IS NULL THEN
                     LET g_pmh[l_ac].ta_pmh02 = 'N'
                     END IF 
                     IF  g_pmh[l_ac].ta_pmh03 IS NULL THEN
                     LET g_pmh[l_ac].ta_pmh03 = 'N'
                     END IF 
------------------add by hlf07751--------------------------------------------                    
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_pmh_t.pmh02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        LET g_pmh_t.*=g_pmh[l_ac].*
                        CALL i140_pmh02('d')
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
 
            IF cl_null(g_pmh[l_ac].pmh21) THEN LET g_pmh[l_ac].pmh21= ' ' END IF    #No.CHI-8C0017 add
            INSERT INTO pmh_file(pmh01,pmh02,pmh05,pmh06,pmh08,
                   pmh09,pmh15,pmh16,ta_pmh01,ta_pmh02,ta_pmh03,pmhacti,pmhuser,pmhgrup,
                   pmhmodu,pmhdate,pmh13,pmh21,pmh22,pmh23,pmh25)   #No:FUN-AA0015    #TQC-9C0138
            VALUES(g_pmh01,g_pmh[l_ac].pmh02,g_pmh[l_ac].pmh05,
                   g_pmh[l_ac].pmh06,g_pmh[l_ac].pmh08,
                   g_pmh[l_ac].pmh09,g_pmh[l_ac].pmh15,
                   g_pmh[l_ac].pmh16,g_pmh[l_ac].ta_pmh01,
                   g_pmh[l_ac].ta_pmh02,g_pmh[l_ac].ta_pmh03,
                   g_pmhacti,g_pmhuser,g_pmhgrup,g_pmhmodu, 
                   g_pmhdate,' ',g_pmh[l_ac].pmh21,g_pmh22,' ','N')   #No:FUN-AA0015                                   #TQC-9C0138
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","pmh_file",g_pmh01,g_pmh[l_ac].pmh02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b +1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_pmh[l_ac].* TO NULL      #900423
            LET g_pmh[l_ac].pmh21 = ' '     #No.CHI-8C0017 add
            LET g_pmh_t.* = g_pmh[l_ac].*         #新輸入資料
            LET g_pmhacti = 'Y'    #TQC-D50115
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD pmh02
 
        AFTER FIELD pmh02                        #check 序號是否重複
            IF NOT cl_null(g_pmh[l_ac].pmh02) THEN
               IF (g_pmh[l_ac].pmh02 != g_pmh_t.pmh02 OR
                   g_pmh_t.pmh02 IS NULL) THEN
                   SELECT count(*)
                       INTO l_n
                       FROM pmh_file
                       WHERE pmh01 = g_pmh01 AND
                             pmh02 = g_pmh[l_ac].pmh02
                         AND pmh22 = g_pmh22                                  #No.CHI-8C0017 add
                         AND pmh23 = ' '                                      #No.CHI-960033
                         AND pmh21 = g_pmh[l_ac].pmh21                        #No.CHI-8C0017 add
                         AND pmhacti = 'Y'                                           #CHI-910021                             
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_pmh[l_ac].pmh02 = g_pmh_t.pmh02
                       NEXT FIELD pmh02
                   ELSE
                       CALL i140_pmh02('a')
                       IF NOT cl_null(g_errno) THEN
                           CALL cl_err(g_pmh[l_ac].pmh02,g_errno,0)
                           NEXT FIELD pmh02
                       END IF
                   END IF
               END IF
            END IF
 
	AFTER FIELD pmh08
	    IF NOT cl_null(g_pmh[l_ac].pmh08) THEN
               IF g_pmh[l_ac].pmh08 NOT MATCHES'[yYnN]' THEN
                   NEXT FIELD pmh08
               END IF
	    END IF
 
	AFTER FIELD pmh09
	    IF NOT cl_null(g_pmh[l_ac].pmh09) THEN
               IF g_pmh[l_ac].pmh09 NOT MATCHES'[TRN]' THEN
                   NEXT FIELD pmh09
	       END IF
	    END IF
 
#No.FUN-A80063 --begin
  AFTER FIELD pmh15
     IF g_pmh[l_ac].pmh08 = 'Y' THEN   #FUN-640212 add
         IF g_pmh[l_ac].pmh15 NOT MATCHES '[1234]' THEN   
            NEXT FIELD pmh15
	       END IF
	   END IF                            #FUN-640212 add
#No.FUN-A80063 --begin
     IF g_pmh_t.pmh15 IS NULL OR g_pmh_t.pmh15 <> g_pmh[l_ac].pmh15 THEN 
        IF g_pmh[l_ac].pmh16 MATCHES '[567]' AND g_pmh[l_ac].pmh15 MATCHES '[12]' THEN 
           CALL cl_err('','aqc-045',1)
           LET g_pmh[l_ac].pmh15 = g_pmh_t.pmh15
           NEXT FIELD pmh15
        END IF 
     END IF 
#No.FUN-A80063 --end
 
      #--------------No.MOD-6C0127 add
       BEFORE FIELD pmh16
         CALL i140_combo()
      #--------------No.MOD-6C0127 end
 
       AFTER FIELD pmh16
           IF g_pmh[l_ac].pmh08 = 'Y' THEN   #FUN-640212 add
              IF g_pmh[l_ac].pmh16 IS NOT NULL THEN
                 IF g_pmh[l_ac].pmh15 = '1' THEN
                    IF g_pmh[l_ac].pmh16 NOT MATCHES '[123]' THEN
	                     NEXT FIELD pmh16
                    END IF
                 ELSE
                    IF g_pmh[l_ac].pmh15 = '2' THEN
                       IF g_pmh[l_ac].pmh16 NOT MATCHES '[1234]' THEN
	                        NEXT FIELD pmh16
                       END IF
                    END IF
                    IF g_pmh[l_ac].pmh15 = '3' OR g_pmh[l_ac].pmh15 ='4' THEN
                       IF g_pmh[l_ac].pmh16 NOT MATCHES '[1234567]' THEN
	                        NEXT FIELD pmh16
                       END IF
                    END IF
	               END IF
              END IF
	         END IF      

#	AFTER FIELD pmh16
#	    IF NOT cl_null(g_pmh[l_ac].pmh16) THEN
#               IF g_pmh[l_ac].pmh16 NOT MATCHES'[1234]' THEN
#                   NEXT FIELD pmh16
#	       END IF
#	    END IF
#No.FUN-A80063 --end
 
        BEFORE DELETE                            #是否取消單身
            IF g_pmh_t.pmh02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM pmh_file
                    WHERE pmh01 = g_pmh01 AND
                          pmh02 = g_pmh_t.pmh02
                      AND pmh22 = g_pmh22                               #No.CHI-8C0017 add                        
                      AND pmh23 = ' '                                   #No.CHI-960033
                      AND pmh21 = g_pmh_t.pmh21                         #No.CHI-8C0017 add                          
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","pmh_file",g_pmh01,g_pmh_t.pmh02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_pmh[l_ac].* = g_pmh_t.*
               CLOSE i140_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_pmh[l_ac].pmh02,-263,1)
                LET g_pmh[l_ac].* = g_pmh_t.*
            ELSE
                UPDATE pmh_file SET
                       pmh02=g_pmh[l_ac].pmh02,
                       pmh05=g_pmh[l_ac].pmh05,
                       pmh06=g_pmh[l_ac].pmh06,
                       pmh08=g_pmh[l_ac].pmh08,
                       pmh21=g_pmh[l_ac].pmh21, #No.CHI-8C0017 add
                       pmh09=g_pmh[l_ac].pmh09,
                       pmh15=g_pmh[l_ac].pmh15,
                       pmh16=g_pmh[l_ac].pmh16,
                       ta_pmh01=g_pmh[l_ac].ta_pmh01,
                       ta_pmh02=g_pmh[l_ac].ta_pmh02,
                       ta_pmh03=g_pmh[l_ac].ta_pmh03,
                       pmhmodu=g_pmhmodu,
                       pmhdate=g_pmhdate
                 WHERE pmh01=g_pmh01
                   AND pmh02=g_pmh_t.pmh02
                   AND pmh22 = g_pmh22                                    #No.CHI-8C0017 add 
                   AND pmh23 = ' '                                        #No.CHI-960033
                   AND pmh21 = g_pmh_t.pmh21                              #No.CHI-8C0017 add                   
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","pmh_file",g_pmh01,g_pmh_t.pmh02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                    LET g_pmh[l_ac].* = g_pmh_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac  #FUN-D30034
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_pmh[l_ac].* = g_pmh_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_pmh.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE i140_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30034
            CLOSE i140_bcl
            COMMIT WORK
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(pmh02)     #廠商編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pmc1"
                     LET g_qryparam.default1 = g_pmh[l_ac].pmh02
                     CALL cl_create_qry() RETURNING g_pmh[l_ac].pmh02
                     DISPLAY g_pmh[l_ac].pmh02 TO pmh02
                     NEXT FIELD pmh02
                OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION mntn_vender     #廠商編號
            LET g_cmd = "apmi600     ",g_pmh[l_ac].pmh02 CLIPPED  #FUN-7C0050
            CALL cl_cmdrun(g_cmd)                                 #MOD-4B0255
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(pmh02) AND l_ac > 1 THEN
                LET g_pmh[l_ac].* = g_pmh[l_ac-1].*
                NEXT FIELD pmh02
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
        END INPUT
 
 
    CLOSE i140_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i140_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
      CALL cl_set_comp_entry("pmh21",TRUE)                                       
END FUNCTION
 
FUNCTION i140_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
     IF g_pmh22 = '1' THEN                        
        CALL cl_set_comp_entry("pmh21",FALSE)                                       
     END IF
END FUNCTION
 
FUNCTION i140_pmh02(p_cmd)  #供應廠商
    DEFINE p_cmd	LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
           l_pmcacti LIKE pmc_file.pmcacti
 
    LET g_errno = ' '
    SELECT pmc03,pmcacti
        INTO g_pmh[l_ac].pmc03,l_pmcacti
        FROM pmc_file
        WHERE pmc01 = g_pmh[l_ac].pmh02
 
    CASE WHEN STATUS=100          LET g_errno = 'mfg3001' #No.7926
                            LET  g_pmh[l_ac].pmc03 = NULL
         WHEN l_pmcacti='N' LET g_errno = '9028'
         WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i140_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
    CONSTRUCT l_wc ON pmh02,pmh05,pmh06,pmh08,pmh09,pmh15,pmh16
                 FROM s_pmh[1].pmh02,s_pmh[1].pmh05,
                      s_pmh[1].pmh06,s_pmh[1].pmh08,
                      s_pmh[1].pmh09,s_pmh[1].pmh15,
                      s_pmh[1].pmh16,s_pmh[1].ta_pmh01,
                      s_pmh[1].ta_pmh02,s_pmh[1].ta_pmh03
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
    CALL i140_b_fill(l_wc)
END FUNCTION
 
FUNCTION i140_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
    LET g_sql =
       "SELECT DISTINCT pmh02,pmc03,pmh21,pmh05,pmh06,pmh08,pmh09,pmh15,pmh16,ta_pmh01,ta_pmh02,ta_pmh03 ",            #CHI-8C0017   #CHI-BB0007 add DISTINCT
       " FROM pmh_file LEFT OUTER JOIN pmc_file ON pmh02 = pmc01 ",
       " WHERE pmh01 = '",g_pmh01,"'",
       "   AND pmh22 = '",g_pmh22,"' ",                                            #CHI-8C0017
       "   AND pmh23 = ' ' ",                                                      #CHI-960033
       "   AND ",p_wc CLIPPED ,
       " ORDER BY 1"
    PREPARE i140_prepare2 FROM g_sql      #預備一下
    DECLARE pmh_curs CURSOR FOR i140_prepare2
    CALL g_pmh.clear()
    LET g_cnt = 1
    FOREACH pmh_curs INTO g_pmh[g_cnt].*   #單身 ARRAY 填充
------------------add by hlf07751--------------------------------------------
    IF  g_pmh[g_cnt].ta_pmh01 IS NULL THEN
    LET g_pmh[g_cnt].ta_pmh01 = 'N'
    END IF 
    IF  g_pmh[g_cnt].ta_pmh02 IS NULL THEN
    LET g_pmh[g_cnt].ta_pmh02 = 'N'
    END IF 
    IF  g_pmh[g_cnt].ta_pmh03 IS NULL THEN
    LET g_pmh[g_cnt].ta_pmh03 = 'N'
    END IF 
------------------add by hlf07751--------------------------------------------
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
    CALL g_pmh.deleteElement(g_cnt)
    LET g_rec_b= g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i140_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ""
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmh TO s_pmh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION check_material
         LET g_action_choice="check_material"
         EXIT DISPLAY
      ON ACTION first
         CALL i140_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i140_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i140_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i140_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i140_fetch('L')
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
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
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
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6A0160  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i140_copy()
DEFINE l_newno,l_oldno1  LIKE pmh_file.pmh01,
       l_n           LIKE type_file.num5,          #No.FUN-680104 SMALLINT
       l_ima02       LIKE ima_file.ima02,
       l_ima021      LIKE ima_file.ima021
 
    IF s_shut(0) THEN RETURN END IF
    IF g_pmh01 IS NULL
       THEN CALL cl_err('',-400,0)
            RETURN
    END IF
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       CALL cl_getmsg('mfg3161',g_lang) RETURNING g_msg
       MESSAGE g_msg
    ELSE
       DISPLAY '' AT 1,1
       CALL cl_getmsg('mfg3161',g_lang) RETURNING g_msg
       DISPLAY g_msg AT 2,1
    END IF
    DISPLAY ' ' TO pmh01
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT l_newno FROM pmh01
 
        BEFORE FIELD pmh01
	    IF g_sma.sma60 = 'Y'		# 若須分段輸入
	           THEN CALL s_inp5(8,15,l_newno) RETURNING l_newno
	                DISPLAY l_newno TO pmh01
    	    END IF
 
        AFTER FIELD pmh01
            IF NOT cl_null(l_newno) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(l_newno,"") THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD pmh01
               END IF
#FUN-AA0059 ---------------------end-------------------------------
                 SELECT count(*)
                    INTO l_n
                    FROM pmh_file
                    WHERE pmh01 = l_newno
                      AND pmhacti = 'Y'                                           #CHI-910021
                 IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     NEXT FIELD pmh01
	         END IF	
                 SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
                  WHERE ima01 = l_newno
                    AND imaacti = 'Y'
                 IF SQLCA.sqlcode THEN
                     CALL cl_err3("sel","ima_file",l_newno,"","mfg0002","","",1)  #No.FUN-660115
                     NEXT FIELD pmh01         #No.TQC-950130
                 ELSE
                     DISPLAY l_ima02 TO FORMONLY.ima02
                     DISPLAY l_ima021 TO FORMONLY.ima021
                 END IF
            END IF
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(pmh01)
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.default1 = l_newno
#                 CALL cl_create_qry() RETURNING l_newno
                  CALL q_sel_ima(FALSE, "q_ima","",l_newno,"","","","","",'' ) 
                    RETURNING l_newno  
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY l_newno TO pmh01
                  NEXT FIELD pmh01
                OTHERWISE EXIT CASE
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
    IF INT_FLAG
       THEN LET INT_FLAG = 0
            DISPLAY  g_pmh01 TO pmh01
            RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM pmh_file         #單身複製
        WHERE pmh01 = g_pmh01
          AND pmh22 = g_pmh22      #CHI-8C0017
          AND pmh23 = ' '          #No.CHI-960033
          AND pmhacti = 'Y'                                           #CHI-910021
        INTO TEMP x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x",g_pmh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
       RETURN
    END IF
    UPDATE x
        SET pmh01 = l_newno
    INSERT INTO pmh_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","pmh_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno1= g_pmh01
     LET g_pmh01=l_newno
     CALL i140_b_fill("1=1")    #TQC-D50115
     CALL i140_b()
     #LET g_pmh01=l_oldno1  #FUN-C80046
     #CALL i140_show()      #FUN-C80046
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
#No.FUN-A80063 --begin
FUNCTION i140_combo()
   DEFINE comb_value LIKE type_file.chr1000
   DEFINE comb_item  LIKE type_file.chr1000
  
   IF g_pmh[l_ac].pmh15 = '1' THEN
      LET comb_value = '1,2,3'   
      SELECT ze03 INTO comb_item FROM ze_file
                  WHERE ze01='aqc-042' AND ze02=g_lang
   ELSE
      LET comb_value = '1,2,3,4'   
      SELECT ze03 INTO comb_item FROM ze_file
                  WHERE ze01='aqc-043' AND ze02=g_lang
  END IF
   IF g_pmh[l_ac].pmh15 MATCHES '[34]' THEN
      LET comb_value = '1,2,3,4,5,6,7'   
      SELECT ze03 INTO comb_item FROM ze_file
                  WHERE ze01='aqc-044' AND ze02=g_lang
   END IF
 
  CALL cl_set_combo_items('pmh16',comb_value,comb_item)
END FUNCTION
#No.FUN-A80063 --end
