# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: saimi106.4gl
# Descriptions...: 料件基本資料維護作業-成本要素值資料
# Date & Author..: 91/11/04 By Wu
# Modify ........: 92/06/18 畫面上增加 [成本要素資料處理狀況](ima93[6,6])
#                           的input查詢...... By Lin
#                  Note: 因原本的l_sql只from imb_file,現加 ima93
#                        的查詢條件,所以必須改成 from ima_file,imb_file
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.FUN-580026 05/08/10 By Sarah 在複製裡增加set_entry段
# Modify.........: No.TQC-5B0059 05/11/08 By Sarah 列印位置不對齊調整
# Modify.........: No.MOD-610075 06/01/18 By pengu aimi100串aimi106成本要素值維護,成本選項無法存入
# Modify.........: No.TQC-610066 06/01/18 By pengu QBE狀態欄位中未輸入任何條件無法按[放棄]離開
# Modify.........: No.FUN-650025 06/05/22 By kim 此程式建議改成 3 個page 可個自維護標準/現時/預設
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/13 By rainy 連續二次查詢key值時,若第二次查詢不到key值時, 會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/25 By jamie 1.FUNCTION i106_q() 一開始應清空g_imb.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-790061 07/09/10 By lumxa 查詢時候，狀態是灰色，不能查詢
# Modify.........: No.TQC-790172 07/09/29 By Pengu p_flow unicode 區無法執行程式
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840029 08/04/21 By sherry 報表改由CR輸出
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No:MOD-970069 09/11/26 By sabrina 新增料時若串aimi106若沒有資料不顯示料號
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A90049 10/09/25 By vealxu 1.只能允許查詢料件性質(ima120)='1' (企業料號')
#                                                   2.程式中如有  INSERT INTO ima_file 時料件性質(ima120)值給'1'(企業料號)
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No:FUN-AB0025 11/01/10 By lixh1  開窗BUG處理
# Modify.........: No:TQC-B20008 11/02/11 By destiny 新增时要显示orig,oriu
# Modify.........: No:MOD-B40097 11/04/13 By zhangll sql死循环修正
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B90177 11/09/29 By destiny oriu,orig不能查询 
# Modify.........: No:FUN-B90105 11/10/18 by linlin 子料件不可修改，母料件更新資料
# Modify.........: No.TQC-C40155 12/04/18 By xianghui 修改時點取消，還原成舊值的處理
# Modify.........: No.TQC-C40219 12/04/24 By xianghui 修正TQC-C40155的問題
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE    #No.TQC-790172 
    g_imb          RECORD LIKE imb_file.*,
    g_imb_t        RECORD LIKE imb_file.*,
    g_imb_o        RECORD LIKE imb_file.*,
    g_imb01_t      LIKE imb_file.imb01,
    g_argv1        LIKE imb_file.imb01,
    g_imaacti      LIKE ima_file.imaacti,
    g_imauser      LIKE ima_file.imauser,
    g_imagrup      LIKE ima_file.imagrup,
    g_imamodu      LIKE ima_file.imamodu,
    g_imadate      LIKE ima_file.imadate,
    g_ima08        LIKE ima_file.ima08,
    g_s            LIKE type_file.chr1,    #料件處理狀況  #No.FUN-690026 VARCHAR(1)
    g_cost_code    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_wc,g_sql     STRING, #TQC-630166
    g_str4         LIKE ze_file.ze03      #No.FUN-690026 VARCHAR(12)
    
DEFINE g_forupd_sql          STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                   LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump                LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask             LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cmd                 LIKE type_file.chr1    #No.MOD-610075 add  #No.FUN-690026 VARCHAR(1)
DEFINE g_str                 STRING                 #No.FUN-840029       
 
FUNCTION aimi106(p_argv1)
    DEFINE p_argv1         LIKE ima_file.ima01

    WHENEVER ERROR CALL cl_err_msg_log
 
    INITIALIZE g_imb.* TO NULL
    INITIALIZE g_imb_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM imb_file  WHERE imb01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE aimi106_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET g_cmd = 'N'     #No.MOD-610075 add
    LET g_argv1 = p_argv1
 
    OPEN WINDOW aimi106_w WITH FORM "aim/42f/aimi106"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '  THEN
       LET g_cmd = 'Y'     #No.MOD-610075 add
       CALL aimi106_q()
       LET g_cmd = 'N'     #No.MOD-610075 add
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
    CALL aimi106_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW aimi106_w

END FUNCTION
 
FUNCTION aimi106_curs()
   DEFINE l_cost     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          p_cost     LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
    IF cl_null(g_argv1) THEN
       CLEAR FORM
       INITIALIZE g_imb.* TO NULL  #FUN-640213 add
       CONSTRUCT BY NAME g_wc ON imb01,imb02
                                 ,imbuser,imbmodu,imbacti,imbgrup,imbdate  #TQC-790061 
                                 ,imboriu,imborig  #TQC-B90177 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          ON ACTION CONTROLP
             CASE
                WHEN INFIELD(imb01) #料件編號
#FUN-AA0059 --Begin--
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"      #FUN-AB0025
                   LET g_qryparam.default1 = g_imb.imb01
                   #CALL cl_create_qry() RETURNING g_imb.imb01
                  #DISPLAY BY NAME g_imb.imb01
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                 #  CALL q_sel_ima( TRUE, "q_ima","",g_imb.imb01,"","","","","",'')  RETURNING  g_qryparam.multiret     #FUN-AB0025
#FUN-AA0059 --End--
                   DISPLAY g_qryparam.multiret TO imb01
                   CALL aimi106_imb01('d')
                   NEXT FIELD imb01
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
 
       IF INT_FLAG THEN  RETURN END IF
       LET g_s=NULL
 
       INPUT g_s   WITHOUT DEFAULTS FROM s
          AFTER FIELD s  #資料處理狀況
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
          LET g_wc=g_wc CLIPPED," AND ima93[6,6] matches '",g_s,"' "
       END IF
    ELSE
    #MOD-970069---mark---start---
    #  LET g_imb.imb01 = g_argv1
    #  DISPLAY g_imb.imb01 TO imb01
    #MOD-970069---mark---end---
    #FUN-650025...............mark by FUN-650025 begin
    ##---No.MOD-610075 add
    #  LET g_cost_code = '2'
    #  DISPLAY g_cost_code TO d_cost
    ##----No.MOD-610075 end
    #FUN-650025...............mark by FUN-650025 end
       CALL aimi106_imb01('d')
       LET g_wc = " imb01 = '",g_argv1,"'"
    END IF
 
   #FUN-650025...............mark by FUN-650025 begin
   #IF g_cmd = 'N' THEN #No.MOD-610075 add
   #   LET g_cost_code = NULL
 
   #   WHILE TRUE
   #      INPUT g_cost_code  WITHOUT DEFAULTS FROM d_cost
   #         AFTER FIELD d_cost
   #            IF cl_null(g_cost_code) OR g_cost_code NOT MATCHES '[123]' THEN
   #               NEXT FIELD d_cost
   #            END IF
 
   #         ON IDLE g_idle_seconds
   #            CALL cl_on_idle()
   #            CONTINUE INPUT
 
   #     ON ACTION about         #MOD-4C0121
   #        CALL cl_about()      #MOD-4C0121
 
   #     ON ACTION help          #MOD-4C0121
   #        CALL cl_show_help()  #MOD-4C0121
 
   #     ON ACTION controlg      #MOD-4C0121
   #        CALL cl_cmdask()     #MOD-4C0121
 
 
   #      END INPUT
   #      IF INT_FLAG THEN  RETURN END IF   #No.TQC-610066 add
   #      IF g_cost_code MATCHES'[123]' THEN EXIT WHILE END IF
   #   END WHILE
   ##資料權限的檢查
   #END IF  #No.MOD-610075 add
   #FUN-650025...............mark by FUN-650025 end
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND imbuser = '",g_user,"'"
    #    END IF
 
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #       LET g_wc = g_wc clipped," AND imbgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #       LET g_wc = g_wc clipped," AND imbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imbuser', 'imbgrup')
    #End:FUN-980030
 
 
    LET g_sql="SELECT imb_file.imb01 ",
              " FROM ima_file,imb_file ", # 組合出 SQL 指令
             #" WHERE  ima01=imb01 AND ",g_wc CLIPPED, " ORDER BY imb01 "                 #FUN-A90049 mark
             #" WHERE ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL AND ima01=imb01 ) AND ",g_wc CLIPPED, " ORDER BY imb01 " #FUN-A90049 add
              " WHERE ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) AND ima01=imb01 AND ",g_wc CLIPPED, " ORDER BY imb01 " #FUN-A90049 add  #MOD-B40097 mod
    PREPARE aimi106_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE aimi106_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR aimi106_prepare
 
    LET g_sql= "SELECT COUNT(*) FROM ima_file,imb_file ",
             # " WHERE ima01=imb01 AND ",g_wc CLIPPED                       #FUN-A90049 mark
               " WHERE ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) AND ima01=imb01 AND ",g_wc CLIPPED      #FUN-A90049 add
    PREPARE aimi106_precount FROM g_sql
    DECLARE aimi106_count CURSOR FOR aimi106_precount
 
END FUNCTION
 
FUNCTION aimi106_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
       ON ACTION insert
           LET g_action_choice="insert"
           IF cl_chk_act_auth() THEN
               CALL aimi106_a()
           END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL aimi106_q()
            END IF
        ON ACTION next
            CALL aimi106_fetch('N')
        ON ACTION previous
            CALL aimi106_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL aimi106_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                CALL aimi106_x()
                #圖形顯示
                CALL cl_set_field_pic("","","","","",g_imb.imbacti)
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL aimi106_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL aimi106_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL aimi106_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #圖形顯示
            CALL cl_set_field_pic("","","","","",g_imb.imbacti)
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL aimi106_fetch('/')
        ON ACTION first
            CALL aimi106_fetch('F')
        ON ACTION last
            CALL aimi106_fetch('L')
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-680046-------add--------str----      
        ON ACTION related_document      #相關文件                     
           LET g_action_choice="related_document"         
              IF cl_chk_act_auth() THEN                  
                 IF g_imb.imb01 IS NOT NULL THEN       
                  LET g_doc.column1 = "imb01"         
                  LET g_doc.value1 = g_imb.imb01           
                  CALL cl_doc()                          
              END IF                                   
           END IF                               
        #No.FUN-680046-------add--------end----
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
    END MENU
    CLOSE aimi106_curs
END FUNCTION
 
 
FUNCTION aimi106_a()
DEFINE l_ima151      LIKE ima_file.ima151   #FUN-B90105

    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_imb.* LIKE imb_file.*
    LET g_imb01_t = NULL
    LET g_imb_t.*=g_imb.*
   #LET g_cost_code = '1' #FUN-650025 mark
    LET g_imb.imb02='0'  LET g_imb.imb111=0
    LET g_imb.imb112=0   LET g_imb.imb1131=0
    LET g_imb.imb1132=0  LET g_imb.imb114=0
    LET g_imb.imb115=0   LET g_imb.imb116=0
    LET g_imb.imb1151=0
    LET g_imb.imb1171=0  LET g_imb.imb1172=0
    LET g_imb.imb118=0   LET g_imb.imb119=0
    LET g_imb.imb129=0   LET g_imb.imb121=0
    LET g_imb.imb122=0   LET g_imb.imb1231=0
    LET g_imb.imb1232=0  LET g_imb.imb124=0
    LET g_imb.imb125=0   LET g_imb.imb126=0
    LET g_imb.imb1251=0
    LET g_imb.imb1271=0  LET g_imb.imb1272=0
    LET g_imb.imb120=0  LET g_imb.imb130=0
    LET g_imb.imb211=0   LET g_imb.imb212=0
    LET g_imb.imb2131=0  LET g_imb.imb2132=0
    LET g_imb.imb214=0   LET g_imb.imb215=0
    LET g_imb.imb2151=0  
    LET g_imb.imb216=0   LET g_imb.imb2171=0
    LET g_imb.imb2172=0  LET g_imb.imb219=0
    LET g_imb.imb218=0   LET g_imb.imb221=0
    LET g_imb.imb222=0   LET g_imb.imb2231=0
    LET g_imb.imb2232=0  LET g_imb.imb224=0
    LET g_imb.imb225=0   LET g_imb.imb226=0
    LET g_imb.imb2251=0
    LET g_imb.imb2271=0  LET g_imb.imb2272=0
    LET g_imb.imb229=0   LET g_imb.imb311=0
    LET g_imb.imb220=0  LET g_imb.imb230=0
    LET g_imb.imb312=0   LET g_imb.imb3131=0
    LET g_imb.imb3132=0  LET g_imb.imb314=0
    LET g_imb.imb315=0   LET g_imb.imb316=0
    LET g_imb.imb3151=0
    LET g_imb.imb3171=0  LET g_imb.imb3172=0
    LET g_imb.imb319=0   LET g_imb.imb318=0
    LET g_imb.imb321=0   LET g_imb.imb322=0
    LET g_imb.imb3231=0  LET g_imb.imb3232=0
    LET g_imb.imb324=0   LET g_imb.imb325=0
    LET g_imb.imb3251=0
    LET g_imb.imb326=0   LET g_imb.imb3271=0
    LET g_imb.imb3272=0  LET g_imb.imb329=0
    LET g_imb.imb320=0  LET g_imb.imb330=0
    LET g_imb_o.*=g_imb.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_imb.imbacti ='Y'                   #有效的資料
        LET g_imb.imbuser = g_user
        LET g_imb.imboriu = g_user #FUN-980030
        LET g_imb.imborig = g_grup #FUN-980030
        LET g_imb.imbgrup = g_grup               #使用者所屬群
        LET g_imb.imbdate = g_today
        CALL aimi106_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_imb.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_imb.imb01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
 
#       CASE g_cost_code
#         WHEN '1'
#       INSERT INTO imb_file VALUES(g_imb.*)       # DISK WRITE
       #FUN-650025...............mark begin
       #CASE g_cost_code
       #   WHEN '1'
       #       INSERT INTO imb_file (imb01,imb02,imb111,imb112,imb1131,  #No.MOD-470041
       #                            imb1132,imb114,imb115,imb1151,imb116,
       #                            imb1171,imb1172,imb119,imb118,imb120,
       #                            imb121,imb122,imb1231,imb1232,imb124,
       #                            imb125,imb1251,imb126,imb1271,imb1272,
       #                            imb129,imb130,imb211,imb212,imb2131,
       #                            imb2132,imb214,imb215,imb2151,imb216,
       #                            imb2171,imb2172,imb219,imb218,imb220,
       #                            imb221,imb222,imb2231,imb2232,imb224,
       #                            imb225,imb2251,imb226,imb2271,imb2272,
       #                            imb229,imb230,imb311,imb312,imb3131,
       #                            imb3132,imb314,imb315,imb3151,imb316,
       #                            imb3171,imb3172,imb319,imb318,imb320,
       #                            imb321,imb322,imb3231,imb3232,imb324,
       #                            imb325,imb3251,imb326,imb3271,imb3272,
       #                            imb329,imb330,imbacti,imbuser,imbgrup,
       #                            imbmodu,imbdate)
       #           VALUES(g_imb.imb01,g_imb.imb02,g_imb.imb111,g_imb.imb112,
       #                  g_imb.imb1131,g_imb.imb1132,g_imb.imb114,g_imb.imb115,
       #                  g_imb.imb1151,g_imb.imb116,g_imb.imb1171,g_imb.imb1172,
       #                  g_imb.imb119,g_imb.imb118, g_imb.imb120,g_imb.imb121,
       #                  g_imb.imb122,g_imb.imb1231,g_imb.imb1232,g_imb.imb124,
       #                  g_imb.imb125,g_imb.imb1251,g_imb.imb126,g_imb.imb1271,
       #                  g_imb.imb1272,g_imb.imb129,g_imb.imb130,0,0,0,0,0,0,
       #                  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
       #                  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,g_imb.imbacti,
       #                  g_imb.imbuser,g_imb.imbgrup,g_imb.imbmodu,
       #                  g_imb.imbdate)
       #   WHEN '2'
       #       INSERT INTO imb_file (imb01,imb02,imb111,imb112,imb1131,  #No.MOD-470041
       #                            imb1132,imb114,imb115,imb1151,imb116,
       #                            imb1171,imb1172,imb119,imb118,imb120,
       #                            imb121,imb122,imb1231,imb1232,imb124,
       #                            imb125,imb1251,imb126,imb1271,imb1272,
       #                            imb129,imb130,imb211,imb212,imb2131,
       #                            imb2132,imb214,imb215,imb2151,imb216,
       #                            imb2171,imb2172,imb219,imb218,imb220,
       #                            imb221,imb222,imb2231,imb2232,imb224,
       #                            imb225,imb2251,imb226,imb2271,imb2272,
       #                            imb229,imb230,imb311,imb312,imb3131,
       #                            imb3132,imb314,imb315,imb3151,imb316,
       #                            imb3171,imb3172,imb319,imb318,imb320,
       #                            imb321,imb322,imb3231,imb3232,imb324,
       #                            imb325,imb3251,imb326,imb3271,imb3272,
       #                            imb329,imb330,imbacti,imbuser,imbgrup,
       #                            imbmodu,imbdate)
       #           VALUES(g_imb.imb01,g_imb.imb02,0,0,0,0,0,0,0,0,0,0,0,0,0,
       #                  0,0,0,0,0,0,0,0,0,0,0,0,g_imb.imb111,g_imb.imb112,
       #                  g_imb.imb1131,g_imb.imb1132,g_imb.imb114,g_imb.imb115,
       #                  g_imb.imb1151,g_imb.imb116,g_imb.imb1171,g_imb.imb1172,
       #                  g_imb.imb119,g_imb.imb118,g_imb.imb120,g_imb.imb121,
       #                  g_imb.imb122,g_imb.imb1231,g_imb.imb1232,g_imb.imb124,
       #                  g_imb.imb125,g_imb.imb1251,g_imb.imb126,g_imb.imb1271,
       #                  g_imb.imb1272,g_imb.imb129,g_imb.imb130,0,0,0,0,0,0,
       #                  0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,g_imb.imbacti,
       #                  g_imb.imbuser,g_imb.imbgrup,g_imb.imbmodu,
       #                  g_imb.imbdate)
       #   WHEN '3'
       #       INSERT INTO imb_file (imb01,imb02,imb111,imb112,imb1131,  #No.MOD-470041
       #                            imb1132,imb114,imb115,imb1151,imb116,
       #                            imb1171,imb1172,imb119,imb118,imb120,
       #                            imb121,imb122,imb1231,imb1232,imb124,
       #                            imb125,imb1251,imb126,imb1271,imb1272,
       #                            imb129,imb130,imb211,imb212,imb2131,
       #                            imb2132,imb214,imb215,imb2151,imb216,
       #                            imb2171,imb2172,imb219,imb218,imb220,
       #                            imb221,imb222,imb2231,imb2232,imb224,
       #                            imb225,imb2251,imb226,imb2271,imb2272,
       #                            imb229,imb230,imb311,imb312,imb3131,
       #                            imb3132,imb314,imb315,imb3151,imb316,
       #                            imb3171,imb3172,imb319,imb318,imb320,
       #                            imb321,imb322,imb3231,imb3232,imb324,
       #                            imb325,imb3251,imb326,imb3271,imb3272,
       #                            imb329,imb330,imbacti,imbuser,imbgrup,
       #                            imbmodu,imbdate)
       #           VALUES(g_imb.imb01,g_imb.imb02,0,0,0,0,0,0,0,0,0,0,0,0,0,
       #                  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
       #                  0,0,0,0,0,0,0,0,0,0,0,0,g_imb.imb111,g_imb.imb112,
       #                  g_imb.imb1131,g_imb.imb1132,g_imb.imb114,g_imb.imb115,
       #                  g_imb.imb1151,g_imb.imb116,g_imb.imb1171,g_imb.imb1172,
       #                  g_imb.imb119,g_imb.imb118,g_imb.imb120,g_imb.imb121,
       #                  g_imb.imb122,g_imb.imb1231,g_imb.imb1232,g_imb.imb124,
       #                  g_imb.imb125,g_imb.imb1251,g_imb.imb126,g_imb.imb1271,
       #                  g_imb.imb1272,g_imb.imb129,g_imb.imb130,g_imb.imbacti,
       #                  g_imb.imbuser,g_imb.imbgrup,g_imb.imbmodu,
       #                  g_imb.imbdate)
       #   OTHERWISE
       #      EXIT CASE
       #END CASE
       #FUN-650025...............mark end
 
        INSERT INTO imb_file VALUES(g_imb.*)       #FUN-650025 add
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_imb.imb01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("ins","imb_file",g_imb.imb01,"",
                         SQLCA.sqlcode,"","",1)  #No.FUN-660156
            CONTINUE WHILE
        ELSE
          # UPDATE ima_file SET ima93=SUBSTRING(ima93,1,5)+'Y'+SUBSTRING(ima93,7,8)  #No.TQC-9B0021
            UPDATE ima_file SET ima93=ima93[1,5] || 'Y' || ima93[7,8],  #No.TQC-9B0021
                                imadate = g_today     #FUN-C30315 add
                           WHERE ima01 = g_imb.imb01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_imb.imb01,SQLCA.sqlcode,0) #No.FUN-660156
               CALL cl_err3("upd","ima_file",g_imb.imb01,"",
                             SQLCA.sqlcode,"","",1)  #No.FUN-660156
            END IF
            LET g_imb_t.* = g_imb.*                # 保存上筆資料
            SELECT imb01 INTO g_imb.imb01 FROM imb_file
                WHERE imb01 = g_imb.imb01
#FUN-B90105----add--begin----
            IF s_industry('slk') THEN
               SELECT ima151 INTO l_ima151 FROM ima_file
                WHERE ima01 = g_imb.imb01
               IF l_ima151='Y' THEN
                  CALL i106_ins_imb()
               END IF
            END IF
#FUN-B90105----add--end---

        END IF
        DISPLAY 'Y' TO FORMONLY.s
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION aimi106_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_n             LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
    DISPLAY g_s TO FORMONLY.s
    DISPLAY BY NAME g_imb.imbuser,g_imb.imbgrup,
        g_imb.imbdate, g_imb.imbacti,g_imb.imborig,g_imb.imboriu  #TQC-B20008
     INPUT g_imb.imb01,g_imb.imb02, #g_cost_code, #FUN-650025
                   g_imb.imb111,
                   g_imb.imb112, g_imb.imb1131, g_imb.imb1132,
                   g_imb.imb119, g_imb.imb114,  g_imb.imb115,
                   g_imb.imb1151,
                   g_imb.imb116, g_imb.imb1171, g_imb.imb1172,
                   g_imb.imb120, g_imb.imb118,  g_imb.imb121,
                   g_imb.imb122, g_imb.imb1231, g_imb.imb1232,
                   g_imb.imb129, g_imb.imb124,  g_imb.imb125,
                   g_imb.imb1251,
                   g_imb.imb126, g_imb.imb1271, g_imb.imb1272,
                   g_imb.imb130,
 
                   #FUN-650025...............begin
                   g_imb.imb211,
                   g_imb.imb212, g_imb.imb2131, g_imb.imb2132,
                   g_imb.imb219, g_imb.imb214,  g_imb.imb215,
                   g_imb.imb2151, 
                   g_imb.imb216, g_imb.imb2171, g_imb.imb2172,
                   g_imb.imb220, g_imb.imb218,  g_imb.imb221,
                   g_imb.imb222, g_imb.imb2231, g_imb.imb2232,
                   g_imb.imb229, g_imb.imb224,  g_imb.imb225,
                   g_imb.imb2251,
                   g_imb.imb226, g_imb.imb2271, g_imb.imb2272,
                   g_imb.imb230,
 
                   g_imb.imb311,
                   g_imb.imb312, g_imb.imb3131, g_imb.imb3132,
                   g_imb.imb319, g_imb.imb314,  g_imb.imb315,
                   g_imb.imb3151,
                   g_imb.imb316, g_imb.imb3171, g_imb.imb3172,
                   g_imb.imb320, g_imb.imb318,  g_imb.imb321,
                   g_imb.imb322, g_imb.imb3231, g_imb.imb3232,
                   g_imb.imb329, g_imb.imb324,  g_imb.imb325,
                   g_imb.imb3251,
                   g_imb.imb326, g_imb.imb3271, g_imb.imb3272,
                   g_imb.imb330,
                   #FUN-650025...............end
 
                   g_imb.imbacti, g_imb.imbuser,g_imb.imbgrup,
                   g_imb.imbmodu,g_imb.imbdate
                    WITHOUT DEFAULTS
      FROM imb01,imb02,imb111, imb112, imb1131,imb1132, #FUN-650025 del d_cost
                   imb119, imb114, imb115, imb1151,imb116,  imb1171, imb1172,
                   imb120,imb118, imb121, imb122, imb1231, imb1232, imb129,
                   imb124, imb125, imb1251,imb126, imb1271, imb1272,
                   imb130,
                   #FUN-650025...............begin
                   imb211, imb212, imb2131,imb2132,
                   imb219, imb214, imb215, imb2151,imb216,  imb2171, imb2172,  
                   imb220, imb218, imb221, imb222, imb2231, imb2232, imb229,
                   imb224, imb225, imb2251,imb226, imb2271, imb2272,
                   imb230,
                   imb311, imb312, imb3131,imb3132,
                   imb319, imb314, imb315, imb3151,imb316,  imb3171, imb3172,
                   imb320, imb318, imb321, imb322, imb3231, imb3232, imb329,
                   imb324, imb325, imb3251,imb326, imb3271, imb3272,
                   imb330,
                   #FUN-650025...............begin
                   imbacti,imbuser,imbgrup,
                   imbmodu,imbdate
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i106_set_entry(p_cmd)
            CALL i106_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        BEFORE FIELD imb01                               #key 值不可修改
            IF g_argv1 IS NOT NULL AND g_argv1 != ' '
               THEN  LET g_imb.imb01 = g_argv1
                     DISPLAY BY NAME g_imb.imb01
                     CALL aimi106_imb01('d')
                     NEXT FIELD imb02
            END IF
	       IF g_sma.sma60 = 'Y'		# 若須分段輸入
	          THEN CALL s_inp5(6,12,g_imb.imb01) RETURNING g_imb.imb01
	               DISPLAY BY NAME g_imb.imb01
      	    END IF
 
        AFTER FIELD imb01
          IF g_imb.imb01 IS NOT NULL THEN
            IF g_imb_o.imb01 IS NULL OR g_imb.imb01 != g_imb_o.imb01
                   THEN CALL aimi106_imb01('d')
                        IF g_chr = 'E' THEN
                           CALL cl_err(g_imb.imb01,'mfg0002',0)
                           LET g_imb.imb01 = g_imb01_t
                           DISPLAY BY NAME g_imb.imb01
                           NEXT FIELD imb01
                        END IF
            END IF
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_imb.imb01 != g_imb01_t) THEN
                SELECT count(*) INTO l_n FROM imb_file
                    WHERE imb01 = g_imb.imb01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_imb.imb01,-239,0)
                    LET g_imb.imb01 = g_imb01_t
                    DISPLAY BY NAME g_imb.imb01
                    NEXT FIELD imb01
                END IF
            END IF
          END IF
 
       AFTER FIELD imb02
#            IF g_imb.imb02 IS NULL OR g_imb.imb02 NOT MATCHES'[012]'
             IF g_imb.imb02 IS NULL OR g_imb.imb02 NOT MATCHES'[01]'
                THEN #CALL cl_err(g_imb.imb02,'mfg1324',0)
                     LET g_imb.imb02 = g_imb_o.imb02
                     DISPLAY BY NAME g_imb.imb02
                     NEXT FIELD imb02
             END IF
             LET g_imb_o.imb02 = g_imb.imb02
             CASE g_imb.imb02
                WHEN '0'  CALL cl_getmsg('mfg0023',g_lang) RETURNING g_str4
                WHEN '1'  CALL cl_getmsg('mfg0024',g_lang) RETURNING g_str4
                WHEN '2'  CALL cl_getmsg('mfg0025',g_lang) RETURNING g_str4
                OTHERWISE EXIT CASE
             END CASE
        #    DISPLAY g_str4 TO FORMONLY.d1
 
      #FUN-650025...............mark begin
      #AFTER FIELD d_cost
      #      IF g_cost_code IS NULL OR g_cost_code NOT MATCHES'[123]'
      #         THEN CALL cl_err(g_cost_code,'mfg0051',0)
      #              NEXT FIELD d_cost
      #      END IF
      #FUN-650025...............mark end
 
        AFTER FIELD imb111
             IF g_imb.imb111 IS NULL OR g_imb.imb111 = ' '
                OR g_imb.imb111 < 0
                THEN CALL cl_err(g_imb.imb111,'mfg0013',0)
                     LET g_imb.imb111 = g_imb_o.imb111
                     DISPLAY BY NAME g_imb.imb111
                     NEXT FIELD imb111
             END IF
             IF g_imb.imb111 != g_imb_o.imb111 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb111 = g_imb.imb111
 
        AFTER FIELD imb112
             IF g_imb.imb112 IS NULL OR g_imb.imb112 = ' '
                OR g_imb.imb112 < 0
                THEN CALL cl_err(g_imb.imb112,'mfg0013',0)
                     LET g_imb.imb112 = g_imb_o.imb112
                     DISPLAY BY NAME g_imb.imb112
                     NEXT FIELD imb112
             END IF
             IF g_imb.imb112 != g_imb_o.imb112 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb112 = g_imb.imb112
 
        AFTER FIELD imb1131
             IF g_imb.imb1131 IS NULL OR g_imb.imb1131 = ' '
                OR g_imb.imb1131 < 0
                THEN CALL cl_err(g_imb.imb1131,'mfg0013',0)
                     LET g_imb.imb1131 = g_imb_o.imb1131
                     DISPLAY BY NAME g_imb.imb1131
                     NEXT FIELD imb1131
             END IF
             IF g_imb.imb1131 != g_imb_o.imb1131 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb1131 = g_imb.imb1131
 
        AFTER FIELD imb1132
             IF g_imb.imb1132 IS NULL OR g_imb.imb1132 = ' '
                OR g_imb.imb1132 < 0
                THEN CALL cl_err(g_imb.imb1132,'mfg0013',0)
                     LET g_imb.imb1132 = g_imb_o.imb1132
                     DISPLAY BY NAME g_imb.imb1132
                     NEXT FIELD imb1132
             END IF
             IF g_imb.imb1132 != g_imb_o.imb1132 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb1132 = g_imb.imb1132
 
        AFTER FIELD imb119
             IF g_imb.imb119 IS NULL OR g_imb.imb119 = ' '
                OR g_imb.imb119 < 0
                THEN CALL cl_err(g_imb.imb119,'mfg0013',0)
                     LET g_imb.imb119 = g_imb_o.imb119
                     DISPLAY BY NAME g_imb.imb119
                     NEXT FIELD imb119
             END IF
             IF g_imb.imb119 != g_imb_o.imb119 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb119 = g_imb.imb119
 
        AFTER FIELD imb115
             IF g_imb.imb115 IS NULL OR g_imb.imb115 = ' '
                OR g_imb.imb115 < 0
                THEN CALL cl_err(g_imb.imb115,'mfg0013',0)
                     LET g_imb.imb115 = g_imb_o.imb115
                     DISPLAY BY NAME g_imb.imb115
                     NEXT FIELD imb115
             END IF
             IF g_imb.imb115 != g_imb_o.imb115 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb115 = g_imb.imb115
 
        AFTER FIELD imb1151
             IF g_imb.imb1151 IS NULL OR g_imb.imb1151 = ' '
                OR g_imb.imb1151 < 0
                THEN CALL cl_err(g_imb.imb1151,'mfg0013',0)
                     LET g_imb.imb1151 = g_imb_o.imb1151
                     DISPLAY BY NAME g_imb.imb1151
                     NEXT FIELD imb1151
             END IF
             IF g_imb.imb1151 != g_imb_o.imb1151 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb1151 = g_imb.imb1151
 
        AFTER FIELD imb116
             IF g_imb.imb116 IS NULL OR g_imb.imb115 = ' '
                OR g_imb.imb116 < 0
                THEN CALL cl_err(g_imb.imb116,'mfg0013',0)
                     LET g_imb.imb116 = g_imb_o.imb116
                     DISPLAY BY NAME g_imb.imb116
                     NEXT FIELD imb116
             END IF
             IF g_imb.imb116 != g_imb_o.imb116 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb116 = g_imb.imb116
 
        AFTER FIELD imb1171
             IF g_imb.imb1171 IS NULL OR g_imb.imb1171 = ' '
                OR g_imb.imb1171 < 0
                THEN CALL cl_err(g_imb.imb1171,'mfg0013',0)
                     LET g_imb.imb1171 = g_imb_o.imb1171
                     DISPLAY BY NAME g_imb.imb1171
                     NEXT FIELD imb1171
             END IF
             IF g_imb.imb1171 != g_imb_o.imb1171 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb1171 = g_imb.imb1171
 
        AFTER FIELD imb1172
             IF g_imb.imb1172 IS NULL OR g_imb.imb1172 = ' '
                OR g_imb.imb1172 < 0
                THEN CALL cl_err(g_imb.imb1172,'mfg0013',0)
                     LET g_imb.imb1172 = g_imb_o.imb1172
                     DISPLAY BY NAME g_imb.imb1172
                     NEXT FIELD imb1172
             END IF
             IF g_imb.imb1172 != g_imb_o.imb1172 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb1172 = g_imb.imb1172
 
        AFTER FIELD imb114
             IF g_imb.imb114 IS NULL OR g_imb.imb114 = ' '
                OR g_imb.imb114 < 0
                THEN CALL cl_err(g_imb.imb114,'mfg0013',0)
                     LET g_imb.imb114 = g_imb_o.imb114
                     DISPLAY BY NAME g_imb.imb114
                     NEXT FIELD imb114
             END IF
             IF g_imb.imb114 != g_imb_o.imb114 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb114 = g_imb.imb114
 
        AFTER FIELD imb118
             IF g_imb.imb118 IS NULL OR g_imb.imb118 = ' '
                OR g_imb.imb118 < 0
                THEN CALL cl_err(g_imb.imb118,'mfg0013',0)
                     LET g_imb.imb118 = g_imb_o.imb118
                     DISPLAY BY NAME g_imb.imb118
                     NEXT FIELD imb118
             END IF
             IF g_imb.imb118 != g_imb_o.imb118 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb118 = g_imb.imb118
 
        AFTER FIELD imb121
             IF g_imb.imb121 IS NULL OR g_imb.imb121 = ' '
                OR g_imb.imb121 < 0
                THEN CALL cl_err(g_imb.imb121,'mfg0013',0)
                     LET g_imb.imb121 = g_imb_o.imb121
                     DISPLAY BY NAME g_imb.imb121
                     NEXT FIELD imb121
             END IF
             IF g_imb.imb121 != g_imb_o.imb121 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb121 = g_imb.imb121
 
        AFTER FIELD imb122
             IF g_imb.imb122 IS NULL OR g_imb.imb122 = ' '
                OR g_imb.imb122 < 0
                THEN CALL cl_err(g_imb.imb122,'mfg0013',0)
                     LET g_imb.imb122 = g_imb_o.imb122
                     DISPLAY BY NAME g_imb.imb122
                     NEXT FIELD imb122
             END IF
             IF g_imb.imb122 != g_imb_o.imb122 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb122 = g_imb.imb122
 
        AFTER FIELD imb1231
             IF g_imb.imb1231 IS NULL OR g_imb.imb1231 = ' '
                OR g_imb.imb1231 < 0
                THEN CALL cl_err(g_imb.imb1231,'mfg0013',0)
                     LET g_imb.imb1231 = g_imb_o.imb1231
                     DISPLAY BY NAME g_imb.imb1231
                     NEXT FIELD imb1231
             END IF
             IF g_imb.imb1231 != g_imb_o.imb1231 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb1231 = g_imb.imb1231
 
        AFTER FIELD imb1232
             IF g_imb.imb1232 IS NULL OR g_imb.imb1232 = ' '
                OR g_imb.imb1232 < 0
                THEN CALL cl_err(g_imb.imb1232,'mfg0013',0)
                     LET g_imb.imb1232 = g_imb_o.imb1232
                     DISPLAY BY NAME g_imb.imb1232
                     NEXT FIELD imb1232
             END IF
             IF g_imb.imb1232 != g_imb_o.imb1232 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb1232 = g_imb.imb1232
 
        AFTER FIELD imb124
             IF g_imb.imb124 IS NULL OR g_imb.imb124 = ' '
                OR g_imb.imb124 < 0
                THEN CALL cl_err(g_imb.imb124,'mfg0013',0)
                     LET g_imb.imb124 = g_imb_o.imb124
                     DISPLAY BY NAME g_imb.imb124
                     NEXT FIELD imb124
             END IF
             IF g_imb.imb124 != g_imb_o.imb124 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb124 = g_imb.imb124
 
        AFTER FIELD imb125
             IF g_imb.imb125 IS NULL OR g_imb.imb125 = ' '
                OR g_imb.imb125 < 0
                THEN CALL cl_err(g_imb.imb125,'mfg0013',0)
                     LET g_imb.imb125 = g_imb_o.imb125
                     DISPLAY BY NAME g_imb.imb125
                     NEXT FIELD imb125
             END IF
             IF g_imb.imb125 != g_imb_o.imb125 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb125 = g_imb.imb125
 
        AFTER FIELD imb1251
             IF g_imb.imb1251 IS NULL OR g_imb.imb1251 = ' '
                OR g_imb.imb1251 < 0
                THEN CALL cl_err(g_imb.imb1251,'mfg0013',0)
                     LET g_imb.imb1251 = g_imb_o.imb1251
                     DISPLAY BY NAME g_imb.imb1251
                     NEXT FIELD imb1251
             END IF
             IF g_imb.imb1251 != g_imb_o.imb1251 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb1251 = g_imb.imb1251
 
        AFTER FIELD imb126
             IF g_imb.imb126 IS NULL OR g_imb.imb126 = ' '
                OR g_imb.imb126 < 0
                THEN CALL cl_err(g_imb.imb126,'mfg0013',0)
                     LET g_imb.imb126 = g_imb_o.imb126
                     DISPLAY BY NAME g_imb.imb126
                     NEXT FIELD imb126
             END IF
             IF g_imb.imb126 != g_imb_o.imb126 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb126 = g_imb.imb126
 
        AFTER FIELD imb1271
             IF g_imb.imb1271 IS NULL OR g_imb.imb1271 = ' '
                OR g_imb.imb1271 < 0
                THEN CALL cl_err(g_imb.imb1271,'mfg0013',0)
                     LET g_imb.imb1271 = g_imb_o.imb1271
                     DISPLAY BY NAME g_imb.imb1271
                     NEXT FIELD imb1271
             END IF
             IF g_imb.imb1271 != g_imb_o.imb1271 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb1271 = g_imb.imb1271
 
        AFTER FIELD imb1272
             IF g_imb.imb1272 IS NULL OR g_imb.imb1272 = ' '
                OR g_imb.imb1272 < 0
                THEN CALL cl_err(g_imb.imb1272,'mfg0013',0)
                     LET g_imb.imb1272 = g_imb_o.imb1272
                     DISPLAY BY NAME g_imb.imb1272
                     NEXT FIELD imb1272
             END IF
             IF g_imb.imb1272 != g_imb_o.imb1272 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb1272 = g_imb.imb1272
 
        AFTER FIELD imb129
             IF g_imb.imb129 IS NULL OR g_imb.imb129 = ' '
                OR g_imb.imb129 < 0
                THEN CALL cl_err(g_imb.imb129,'mfg0013',0)
                     LET g_imb.imb129 = g_imb_o.imb129
                     DISPLAY BY NAME g_imb.imb129
                     NEXT FIELD imb129
             END IF
             IF g_imb.imb129 != g_imb_o.imb129 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb129 = g_imb.imb129
 
        AFTER FIELD imb120
             IF g_imb.imb120 IS NULL OR g_imb.imb120 = ' '
                OR g_imb.imb120 < 0
                THEN CALL cl_err(g_imb.imb120,'mfg0013',0)
                     LET g_imb.imb120 = g_imb_o.imb120
                     DISPLAY BY NAME g_imb.imb120
                     NEXT FIELD imb120
             END IF
             IF g_imb.imb120 != g_imb_o.imb120 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb120 = g_imb.imb120
 
        AFTER FIELD imb130
             IF g_imb.imb130 IS NULL OR g_imb.imb130 = ' '
                OR g_imb.imb130 < 0
                THEN CALL cl_err(g_imb.imb130,'mfg0013',0)
                     LET g_imb.imb130 = g_imb_o.imb130
                     DISPLAY BY NAME g_imb.imb130
                     NEXT FIELD imb130
             END IF
             IF g_imb.imb130 != g_imb_o.imb130 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb130 = g_imb.imb130
        #FUN-650025...............begin
        AFTER FIELD imb211
             IF g_imb.imb211 IS NULL OR g_imb.imb211 = ' '
                OR g_imb.imb211 < 0
                THEN CALL cl_err(g_imb.imb211,'mfg0013',0)
                     LET g_imb.imb211 = g_imb_o.imb211
                     DISPLAY BY NAME g_imb.imb211
                     NEXT FIELD imb211
             END IF
             IF g_imb.imb211 != g_imb_o.imb211 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb211 = g_imb.imb211
 
        AFTER FIELD imb212
             IF g_imb.imb212 IS NULL OR g_imb.imb212 = ' '
                OR g_imb.imb212 < 0
                THEN CALL cl_err(g_imb.imb212,'mfg0013',0)
                     LET g_imb.imb212 = g_imb_o.imb212
                     DISPLAY BY NAME g_imb.imb212
                     NEXT FIELD imb212
             END IF
             IF g_imb.imb212 != g_imb_o.imb212 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb212 = g_imb.imb212
 
        AFTER FIELD imb2131
             IF g_imb.imb2131 IS NULL OR g_imb.imb2131 = ' '
                OR g_imb.imb2131 < 0
                THEN CALL cl_err(g_imb.imb2131,'mfg0013',0)
                     LET g_imb.imb2131 = g_imb_o.imb2131
                     DISPLAY BY NAME g_imb.imb2131
                     NEXT FIELD imb2131
             END IF
             IF g_imb.imb2131 != g_imb_o.imb2131 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb2131 = g_imb.imb2131
 
        AFTER FIELD imb2132
             IF g_imb.imb2132 IS NULL OR g_imb.imb2132 = ' '
                OR g_imb.imb2132 < 0
                THEN CALL cl_err(g_imb.imb2132,'mfg0013',0)
                     LET g_imb.imb2132 = g_imb_o.imb2132
                     DISPLAY BY NAME g_imb.imb2132
                     NEXT FIELD imb2132
             END IF
             IF g_imb.imb2132 != g_imb_o.imb2132 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb2132 = g_imb.imb2132
 
        AFTER FIELD imb219
             IF g_imb.imb219 IS NULL OR g_imb.imb219 = ' '
                OR g_imb.imb219 < 0
                THEN CALL cl_err(g_imb.imb219,'mfg0013',0)
                     LET g_imb.imb219 = g_imb_o.imb219
                     DISPLAY BY NAME g_imb.imb219
                     NEXT FIELD imb219
             END IF
             IF g_imb.imb219 != g_imb_o.imb219 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb219 = g_imb.imb219
 
        AFTER FIELD imb215
             IF g_imb.imb215 IS NULL OR g_imb.imb215 = ' '
                OR g_imb.imb215 < 0
                THEN CALL cl_err(g_imb.imb215,'mfg0013',0)
                     LET g_imb.imb215 = g_imb_o.imb215
                     DISPLAY BY NAME g_imb.imb215
                     NEXT FIELD imb215
             END IF
             IF g_imb.imb215 != g_imb_o.imb215 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb215 = g_imb.imb215
 
        AFTER FIELD imb2151
             IF g_imb.imb2151 IS NULL OR g_imb.imb2151 = ' '
                OR g_imb.imb2151 < 0
                THEN CALL cl_err(g_imb.imb2151,'mfg0013',0)
                     LET g_imb.imb2151 = g_imb_o.imb2151
                     DISPLAY BY NAME g_imb.imb2151
                     NEXT FIELD imb2151
             END IF
             IF g_imb.imb2151 != g_imb_o.imb2151 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb2151 = g_imb.imb2151
 
        AFTER FIELD imb216
             IF g_imb.imb216 IS NULL OR g_imb.imb215 = ' '
                OR g_imb.imb216 < 0
                THEN CALL cl_err(g_imb.imb216,'mfg0013',0)
                     LET g_imb.imb216 = g_imb_o.imb216
                     DISPLAY BY NAME g_imb.imb216
                     NEXT FIELD imb216
             END IF
             IF g_imb.imb216 != g_imb_o.imb216 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb216 = g_imb.imb216
 
        AFTER FIELD imb2171
             IF g_imb.imb2171 IS NULL OR g_imb.imb2171 = ' '
                OR g_imb.imb2171 < 0
                THEN CALL cl_err(g_imb.imb2171,'mfg0013',0)
                     LET g_imb.imb2171 = g_imb_o.imb2171
                     DISPLAY BY NAME g_imb.imb2171
                     NEXT FIELD imb2171
             END IF
             IF g_imb.imb2171 != g_imb_o.imb2171 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb2171 = g_imb.imb2171
 
        AFTER FIELD imb2172
             IF g_imb.imb2172 IS NULL OR g_imb.imb2172 = ' '
                OR g_imb.imb2172 < 0
                THEN CALL cl_err(g_imb.imb2172,'mfg0013',0)
                     LET g_imb.imb2172 = g_imb_o.imb2172
                     DISPLAY BY NAME g_imb.imb2172
                     NEXT FIELD imb2172
             END IF
             IF g_imb.imb2172 != g_imb_o.imb2172 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb2172 = g_imb.imb2172
 
        AFTER FIELD imb214
             IF g_imb.imb214 IS NULL OR g_imb.imb214 = ' '
                OR g_imb.imb214 < 0
                THEN CALL cl_err(g_imb.imb214,'mfg0013',0)
                     LET g_imb.imb214 = g_imb_o.imb214
                     DISPLAY BY NAME g_imb.imb214
                     NEXT FIELD imb214
             END IF
             IF g_imb.imb214 != g_imb_o.imb214 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb214 = g_imb.imb214
 
        AFTER FIELD imb218
             IF g_imb.imb218 IS NULL OR g_imb.imb218 = ' '
                OR g_imb.imb218 < 0
                THEN CALL cl_err(g_imb.imb218,'mfg0013',0)
                     LET g_imb.imb218 = g_imb_o.imb218
                     DISPLAY BY NAME g_imb.imb218
                     NEXT FIELD imb218
             END IF
             IF g_imb.imb218 != g_imb_o.imb218 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb218 = g_imb.imb218
 
        AFTER FIELD imb221
             IF g_imb.imb221 IS NULL OR g_imb.imb221 = ' '
                OR g_imb.imb221 < 0
                THEN CALL cl_err(g_imb.imb221,'mfg0013',0)
                     LET g_imb.imb221 = g_imb_o.imb221
                     DISPLAY BY NAME g_imb.imb221
                     NEXT FIELD imb221
             END IF
             IF g_imb.imb221 != g_imb_o.imb221 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb221 = g_imb.imb221
 
        AFTER FIELD imb222
             IF g_imb.imb222 IS NULL OR g_imb.imb222 = ' '
                OR g_imb.imb222 < 0
                THEN CALL cl_err(g_imb.imb222,'mfg0013',0)
                     LET g_imb.imb222 = g_imb_o.imb222
                     DISPLAY BY NAME g_imb.imb222
                     NEXT FIELD imb222
             END IF
             IF g_imb.imb222 != g_imb_o.imb222 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb222 = g_imb.imb222
 
        AFTER FIELD imb2231
             IF g_imb.imb2231 IS NULL OR g_imb.imb2231 = ' '
                OR g_imb.imb2231 < 0
                THEN CALL cl_err(g_imb.imb2231,'mfg0013',0)
                     LET g_imb.imb2231 = g_imb_o.imb2231
                     DISPLAY BY NAME g_imb.imb2231
                     NEXT FIELD imb2231
             END IF
             IF g_imb.imb2231 != g_imb_o.imb2231 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb2231 = g_imb.imb2231
 
        AFTER FIELD imb2232
             IF g_imb.imb2232 IS NULL OR g_imb.imb2232 = ' '
                OR g_imb.imb2232 < 0
                THEN CALL cl_err(g_imb.imb2232,'mfg0013',0)
                     LET g_imb.imb2232 = g_imb_o.imb2232
                     DISPLAY BY NAME g_imb.imb2232
                     NEXT FIELD imb2232
             END IF
             IF g_imb.imb2232 != g_imb_o.imb2232 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb2232 = g_imb.imb2232
 
        AFTER FIELD imb224
             IF g_imb.imb224 IS NULL OR g_imb.imb224 = ' '
                OR g_imb.imb224 < 0
                THEN CALL cl_err(g_imb.imb224,'mfg0013',0)
                     LET g_imb.imb224 = g_imb_o.imb224
                     DISPLAY BY NAME g_imb.imb224
                     NEXT FIELD imb224
             END IF
             IF g_imb.imb224 != g_imb_o.imb224 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb224 = g_imb.imb224
 
        AFTER FIELD imb225
             IF g_imb.imb225 IS NULL OR g_imb.imb225 = ' '
                OR g_imb.imb225 < 0
                THEN CALL cl_err(g_imb.imb225,'mfg0013',0)
                     LET g_imb.imb225 = g_imb_o.imb225
                     DISPLAY BY NAME g_imb.imb225
                     NEXT FIELD imb225
             END IF
             IF g_imb.imb225 != g_imb_o.imb225 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb225 = g_imb.imb225
 
        AFTER FIELD imb2251
             IF g_imb.imb2251 IS NULL OR g_imb.imb2251 = ' '
                OR g_imb.imb2251 < 0
                THEN CALL cl_err(g_imb.imb2251,'mfg0013',0)
                     LET g_imb.imb2251 = g_imb_o.imb2251
                     DISPLAY BY NAME g_imb.imb2251
                     NEXT FIELD imb2251
             END IF
             IF g_imb.imb2251 != g_imb_o.imb2251 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb2251 = g_imb.imb2251
 
        AFTER FIELD imb226
             IF g_imb.imb226 IS NULL OR g_imb.imb226 = ' '
                OR g_imb.imb226 < 0
                THEN CALL cl_err(g_imb.imb226,'mfg0013',0)
                     LET g_imb.imb226 = g_imb_o.imb226
                     DISPLAY BY NAME g_imb.imb226
                     NEXT FIELD imb226
             END IF
             IF g_imb.imb226 != g_imb_o.imb226 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb226 = g_imb.imb226
 
        AFTER FIELD imb2271
             IF g_imb.imb2271 IS NULL OR g_imb.imb2271 = ' '
                OR g_imb.imb2271 < 0
                THEN CALL cl_err(g_imb.imb2271,'mfg0013',0)
                     LET g_imb.imb2271 = g_imb_o.imb2271
                     DISPLAY BY NAME g_imb.imb2271
                     NEXT FIELD imb2271
             END IF
             IF g_imb.imb2271 != g_imb_o.imb2271 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb2271 = g_imb.imb2271
 
        AFTER FIELD imb2272
             IF g_imb.imb2272 IS NULL OR g_imb.imb2272 = ' '
                OR g_imb.imb2272 < 0
                THEN CALL cl_err(g_imb.imb2272,'mfg0013',0)
                     LET g_imb.imb2272 = g_imb_o.imb2272
                     DISPLAY BY NAME g_imb.imb2272
                     NEXT FIELD imb2272
             END IF
             IF g_imb.imb2272 != g_imb_o.imb2272 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb2272 = g_imb.imb2272
 
        AFTER FIELD imb229
             IF g_imb.imb229 IS NULL OR g_imb.imb229 = ' '
                OR g_imb.imb229 < 0
                THEN CALL cl_err(g_imb.imb229,'mfg0013',0)
                     LET g_imb.imb229 = g_imb_o.imb229
                     DISPLAY BY NAME g_imb.imb229
                     NEXT FIELD imb229
             END IF
             IF g_imb.imb229 != g_imb_o.imb229 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb229 = g_imb.imb229
 
        AFTER FIELD imb220
             IF g_imb.imb220 IS NULL OR g_imb.imb220 = ' '
                OR g_imb.imb220 < 0
                THEN CALL cl_err(g_imb.imb220,'mfg0013',0)
                     LET g_imb.imb220 = g_imb_o.imb220
                     DISPLAY BY NAME g_imb.imb220
                     NEXT FIELD imb220
             END IF
             IF g_imb.imb220 != g_imb_o.imb220 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb220 = g_imb.imb220
 
        AFTER FIELD imb230
             IF g_imb.imb230 IS NULL OR g_imb.imb230 = ' '
                OR g_imb.imb230 < 0
                THEN CALL cl_err(g_imb.imb230,'mfg0013',0)
                     LET g_imb.imb230 = g_imb_o.imb230
                     DISPLAY BY NAME g_imb.imb230
                     NEXT FIELD imb230
             END IF
             IF g_imb.imb230 != g_imb_o.imb230 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb230 = g_imb.imb230
 
        AFTER FIELD imb311
             IF g_imb.imb311 IS NULL OR g_imb.imb311 = ' '
                OR g_imb.imb311 < 0
                THEN CALL cl_err(g_imb.imb311,'mfg0013',0)
                     LET g_imb.imb311 = g_imb_o.imb311
                     DISPLAY BY NAME g_imb.imb311
                     NEXT FIELD imb311
             END IF
             IF g_imb.imb311 != g_imb_o.imb311 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb311 = g_imb.imb311
 
        AFTER FIELD imb312
             IF g_imb.imb312 IS NULL OR g_imb.imb312 = ' '
                OR g_imb.imb312 < 0
                THEN CALL cl_err(g_imb.imb312,'mfg0013',0)
                     LET g_imb.imb312 = g_imb_o.imb312
                     DISPLAY BY NAME g_imb.imb312
                     NEXT FIELD imb312
             END IF
             IF g_imb.imb312 != g_imb_o.imb312 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb312 = g_imb.imb312
 
        AFTER FIELD imb3131
             IF g_imb.imb3131 IS NULL OR g_imb.imb3131 = ' '
                OR g_imb.imb3131 < 0
                THEN CALL cl_err(g_imb.imb3131,'mfg0013',0)
                     LET g_imb.imb3131 = g_imb_o.imb3131
                     DISPLAY BY NAME g_imb.imb3131
                     NEXT FIELD imb3131
             END IF
             IF g_imb.imb3131 != g_imb_o.imb3131 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb3131 = g_imb.imb3131
 
        AFTER FIELD imb3132
             IF g_imb.imb3132 IS NULL OR g_imb.imb3132 = ' '
                OR g_imb.imb3132 < 0
                THEN CALL cl_err(g_imb.imb3132,'mfg0013',0)
                     LET g_imb.imb3132 = g_imb_o.imb3132
                     DISPLAY BY NAME g_imb.imb3132
                     NEXT FIELD imb3132
             END IF
             IF g_imb.imb3132 != g_imb_o.imb3132 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb3132 = g_imb.imb3132
 
        AFTER FIELD imb319
             IF g_imb.imb319 IS NULL OR g_imb.imb319 = ' '
                OR g_imb.imb319 < 0
                THEN CALL cl_err(g_imb.imb319,'mfg0013',0)
                     LET g_imb.imb319 = g_imb_o.imb319
                     DISPLAY BY NAME g_imb.imb319
                     NEXT FIELD imb319
             END IF
             IF g_imb.imb319 != g_imb_o.imb319 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb319 = g_imb.imb319
 
        AFTER FIELD imb315
             IF g_imb.imb315 IS NULL OR g_imb.imb315 = ' '
                OR g_imb.imb315 < 0
                THEN CALL cl_err(g_imb.imb315,'mfg0013',0)
                     LET g_imb.imb315 = g_imb_o.imb315
                     DISPLAY BY NAME g_imb.imb315
                     NEXT FIELD imb315
             END IF
             IF g_imb.imb315 != g_imb_o.imb315 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb315 = g_imb.imb315
 
        AFTER FIELD imb3151
             IF g_imb.imb3151 IS NULL OR g_imb.imb3151 = ' '
                OR g_imb.imb3151 < 0
                THEN CALL cl_err(g_imb.imb3151,'mfg0013',0)
                     LET g_imb.imb3151 = g_imb_o.imb3151
                     DISPLAY BY NAME g_imb.imb3151
                     NEXT FIELD imb3151
             END IF
             IF g_imb.imb3151 != g_imb_o.imb3151 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb3151 = g_imb.imb3151
 
        AFTER FIELD imb316
             IF g_imb.imb316 IS NULL OR g_imb.imb315 = ' '
                OR g_imb.imb316 < 0
                THEN CALL cl_err(g_imb.imb316,'mfg0013',0)
                     LET g_imb.imb316 = g_imb_o.imb316
                     DISPLAY BY NAME g_imb.imb316
                     NEXT FIELD imb316
             END IF
             IF g_imb.imb316 != g_imb_o.imb316 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb316 = g_imb.imb316
 
        AFTER FIELD imb3171
             IF g_imb.imb3171 IS NULL OR g_imb.imb3171 = ' '
                OR g_imb.imb3171 < 0
                THEN CALL cl_err(g_imb.imb3171,'mfg0013',0)
                     LET g_imb.imb3171 = g_imb_o.imb3171
                     DISPLAY BY NAME g_imb.imb3171
                     NEXT FIELD imb3171
             END IF
             IF g_imb.imb3171 != g_imb_o.imb3171 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb3171 = g_imb.imb3171
 
        AFTER FIELD imb3172
             IF g_imb.imb3172 IS NULL OR g_imb.imb3172 = ' '
                OR g_imb.imb3172 < 0
                THEN CALL cl_err(g_imb.imb3172,'mfg0013',0)
                     LET g_imb.imb3172 = g_imb_o.imb3172
                     DISPLAY BY NAME g_imb.imb3172
                     NEXT FIELD imb3172
             END IF
             IF g_imb.imb3172 != g_imb_o.imb3172 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb3172 = g_imb.imb3172
 
        AFTER FIELD imb314
             IF g_imb.imb314 IS NULL OR g_imb.imb314 = ' '
                OR g_imb.imb314 < 0
                THEN CALL cl_err(g_imb.imb314,'mfg0013',0)
                     LET g_imb.imb314 = g_imb_o.imb314
                     DISPLAY BY NAME g_imb.imb314
                     NEXT FIELD imb314
             END IF
             IF g_imb.imb314 != g_imb_o.imb314 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb314 = g_imb.imb314
 
        AFTER FIELD imb318
             IF g_imb.imb318 IS NULL OR g_imb.imb318 = ' '
                OR g_imb.imb318 < 0
                THEN CALL cl_err(g_imb.imb318,'mfg0013',0)
                     LET g_imb.imb318 = g_imb_o.imb318
                     DISPLAY BY NAME g_imb.imb318
                     NEXT FIELD imb318
             END IF
             IF g_imb.imb318 != g_imb_o.imb318 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb318 = g_imb.imb318
 
        AFTER FIELD imb321
             IF g_imb.imb321 IS NULL OR g_imb.imb321 = ' '
                OR g_imb.imb321 < 0
                THEN CALL cl_err(g_imb.imb321,'mfg0013',0)
                     LET g_imb.imb321 = g_imb_o.imb321
                     DISPLAY BY NAME g_imb.imb321
                     NEXT FIELD imb321
             END IF
             IF g_imb.imb321 != g_imb_o.imb321 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb321 = g_imb.imb321
 
        AFTER FIELD imb322
             IF g_imb.imb322 IS NULL OR g_imb.imb322 = ' '
                OR g_imb.imb322 < 0
                THEN CALL cl_err(g_imb.imb322,'mfg0013',0)
                     LET g_imb.imb322 = g_imb_o.imb322
                     DISPLAY BY NAME g_imb.imb322
                     NEXT FIELD imb322
             END IF
             IF g_imb.imb322 != g_imb_o.imb322 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb322 = g_imb.imb322
 
        AFTER FIELD imb3231
             IF g_imb.imb3231 IS NULL OR g_imb.imb3231 = ' '
                OR g_imb.imb3231 < 0
                THEN CALL cl_err(g_imb.imb3231,'mfg0013',0)
                     LET g_imb.imb3231 = g_imb_o.imb3231
                     DISPLAY BY NAME g_imb.imb3231
                     NEXT FIELD imb3231
             END IF
             IF g_imb.imb3231 != g_imb_o.imb3231 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb3231 = g_imb.imb3231
 
        AFTER FIELD imb3232
             IF g_imb.imb3232 IS NULL OR g_imb.imb3232 = ' '
                OR g_imb.imb3232 < 0
                THEN CALL cl_err(g_imb.imb3232,'mfg0013',0)
                     LET g_imb.imb3232 = g_imb_o.imb3232
                     DISPLAY BY NAME g_imb.imb3232
                     NEXT FIELD imb3232
             END IF
             IF g_imb.imb3232 != g_imb_o.imb3232 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb3232 = g_imb.imb3232
 
        AFTER FIELD imb324
             IF g_imb.imb324 IS NULL OR g_imb.imb324 = ' '
                OR g_imb.imb324 < 0
                THEN CALL cl_err(g_imb.imb324,'mfg0013',0)
                     LET g_imb.imb324 = g_imb_o.imb324
                     DISPLAY BY NAME g_imb.imb324
                     NEXT FIELD imb324
             END IF
             IF g_imb.imb324 != g_imb_o.imb324 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb324 = g_imb.imb324
 
        AFTER FIELD imb325
             IF g_imb.imb325 IS NULL OR g_imb.imb325 = ' '
                OR g_imb.imb325 < 0
                THEN CALL cl_err(g_imb.imb325,'mfg0013',0)
                     LET g_imb.imb325 = g_imb_o.imb325
                     DISPLAY BY NAME g_imb.imb325
                     NEXT FIELD imb325
             END IF
             IF g_imb.imb325 != g_imb_o.imb325 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb325 = g_imb.imb325
 
        AFTER FIELD imb3251
             IF g_imb.imb3251 IS NULL OR g_imb.imb3251 = ' '
                OR g_imb.imb3251 < 0
                THEN CALL cl_err(g_imb.imb3251,'mfg0013',0)
                     LET g_imb.imb3251 = g_imb_o.imb3251
                     DISPLAY BY NAME g_imb.imb3251
                     NEXT FIELD imb3251
             END IF
             IF g_imb.imb3251 != g_imb_o.imb3251 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb3251 = g_imb.imb3251
 
        AFTER FIELD imb326
             IF g_imb.imb326 IS NULL OR g_imb.imb326 = ' '
                OR g_imb.imb326 < 0
                THEN CALL cl_err(g_imb.imb326,'mfg0013',0)
                     LET g_imb.imb326 = g_imb_o.imb326
                     DISPLAY BY NAME g_imb.imb326
                     NEXT FIELD imb326
             END IF
             IF g_imb.imb326 != g_imb_o.imb326 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb326 = g_imb.imb326
 
        AFTER FIELD imb3271
             IF g_imb.imb3271 IS NULL OR g_imb.imb3271 = ' '
                OR g_imb.imb3271 < 0
                THEN CALL cl_err(g_imb.imb3271,'mfg0013',0)
                     LET g_imb.imb3271 = g_imb_o.imb3271
                     DISPLAY BY NAME g_imb.imb3271
                     NEXT FIELD imb3271
             END IF
             IF g_imb.imb3271 != g_imb_o.imb3271 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb3271 = g_imb.imb3271
 
        AFTER FIELD imb3272
             IF g_imb.imb3272 IS NULL OR g_imb.imb3272 = ' '
                OR g_imb.imb3272 < 0
                THEN CALL cl_err(g_imb.imb3272,'mfg0013',0)
                     LET g_imb.imb3272 = g_imb_o.imb3272
                     DISPLAY BY NAME g_imb.imb3272
                     NEXT FIELD imb3272
             END IF
             IF g_imb.imb3272 != g_imb_o.imb3272 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb3272 = g_imb.imb3272
 
        AFTER FIELD imb329
             IF g_imb.imb329 IS NULL OR g_imb.imb329 = ' '
                OR g_imb.imb329 < 0
                THEN CALL cl_err(g_imb.imb329,'mfg0013',0)
                     LET g_imb.imb329 = g_imb_o.imb329
                     DISPLAY BY NAME g_imb.imb329
                     NEXT FIELD imb329
             END IF
             IF g_imb.imb329 != g_imb_o.imb329 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb329 = g_imb.imb329
 
        AFTER FIELD imb320
             IF g_imb.imb320 IS NULL OR g_imb.imb320 = ' '
                OR g_imb.imb320 < 0
                THEN CALL cl_err(g_imb.imb320,'mfg0013',0)
                     LET g_imb.imb320 = g_imb_o.imb320
                     DISPLAY BY NAME g_imb.imb320
                     NEXT FIELD imb320
             END IF
             IF g_imb.imb320 != g_imb_o.imb320 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb320 = g_imb.imb320
 
        AFTER FIELD imb330
             IF g_imb.imb330 IS NULL OR g_imb.imb330 = ' '
                OR g_imb.imb330 < 0
                THEN CALL cl_err(g_imb.imb330,'mfg0013',0)
                     LET g_imb.imb330 = g_imb_o.imb330
                     DISPLAY BY NAME g_imb.imb330
                     NEXT FIELD imb330
             END IF
             IF g_imb.imb330 != g_imb_o.imb330 THEN
                CALL aimi106_sum()
             END IF
             LET g_imb_o.imb330 = g_imb.imb330
        #FUN-650025...............end
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imb01) #料件編號
#FUN-AA0059 --Begin--
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"    #FUN-AB0025 
                  LET g_qryparam.default1 = g_imb.imb01
                  CALL cl_create_qry() RETURNING g_imb.imb01
                # CALL q_sel_ima(FALSE, "q_ima", "", g_imb.imb01, "", "", "", "" ,"",'' )  RETURNING g_imb.imb01    #FUN-AB0025
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_imb.imb01
                  CALL aimi106_imb01('d')
                  NEXT FIELD imb01
            END CASE
 
{
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
}
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
        #-----END TQC-860018-----
 
    END INPUT
END FUNCTION
 
FUNCTION aimi106_imb01(p_cmd)
    DEFINE p_cmd        LIKE type_file.chr1,      #No.FUN-690026 VARCHAR(1)
          #l_sum        LIKE imb_file.imb118,     #MOD-530179
           l_ima05      LIKE ima_file.ima05,
           l_ima25      LIKE ima_file.ima25,
           l_ima02      LIKE ima_file.ima02,
           l_ima021     LIKE ima_file.ima021,
           l_ima03      LIKE ima_file.ima03,
          #l_ima86      LIKE ima_file.ima86,      #FUN-560183
          #l_ima86_fac  LIKE ima_file.ima86_fac,  #FUN-560183
           l_ima93      LIKE ima_file.ima93
 
  LET g_chr = ' '
  IF g_imb.imb01 IS NULL THEN
     LET g_chr = 'E'
     LET l_ima02  = NULL   LET l_ima03 = NULL
     LET l_ima021 = NULL
     LET l_ima05  = NULL   LET g_ima08 = NULL
     LET l_ima25  = NULL  #LET l_ima86 = NULL #FUN-560183
    #LET l_ima86_fac = 0  #FUN-560183
     LET l_ima93 = NULL
  ELSE SELECT ima02,ima021,ima03,ima05,ima08,ima25,ima93, #FUN-560183 del ima86,ima86_fac
              imaacti,imauser,imagrup,imamodu,imadate
         INTO l_ima02,l_ima021,l_ima03,l_ima05,g_ima08,l_ima25,l_ima93, #FUN-560183 del l_ima86,l_ima86_fac
              g_imaacti,g_imauser,g_imagrup,g_imamodu,g_imadate
         FROM ima_file
         WHERE ima01 = g_imb.imb01
        IF SQLCA.sqlcode
           THEN LET g_chr = 'E'
                LET l_ima02  = NULL   LET l_ima03 = NULL
                LET l_ima021 = NULL
                LET l_ima05  = NULL   LET g_ima08 = NULL
                LET l_ima25  = NULL  #LET l_ima86 = NULL #FUN-560183
               #LET l_ima86_fac = 0   LET l_ima93 = NULL #FUN-560183
           ELSE IF g_imaacti='N' THEN
                   LET g_chr='E'
                END IF
        END IF
  END IF
  
   #FUN-650025...............begin
   IF p_cmd = 'd' THEN
      CALL aimi106_sum()
   END IF
   #FUN-650025...............end
   LET g_s=l_ima93[6,6]
   IF g_chr = ' ' OR p_cmd = 'd' THEN
      DISPLAY l_ima02 TO ima02
      DISPLAY l_ima021 TO ima021
      DISPLAY l_ima05 TO ima05
      DISPLAY g_ima08 TO ima08
      DISPLAY l_ima25 TO ima25
     #DISPLAY l_ima86 TO ima86 #FUN-560183
     #DISPLAY l_ima86_fac TO ima86_fac   #FUN-560183
      DISPLAY g_s TO FORMONLY.s
      #圖形顯示
      CALL cl_set_field_pic("","","","","",g_imb.imbacti)
   END IF
END FUNCTION
 
#FUN-650025...............begin
FUNCTION  aimi106_sum()
  DEFINE l_sum1   LIKE imb_file.imb118, #FUN-650025
         l_sum2   LIKE imb_file.imb118, #FUN-650025
         l_sum3   LIKE imb_file.imb118  #FUN-650025
 
  IF g_ima08 matches'[PVZ]' THEN
      LET l_sum1 = g_imb.imb118
      LET l_sum2 = g_imb.imb218
      LET l_sum3 = g_imb.imb318
  ELSE
      LET l_sum1= g_imb.imb111  + g_imb.imb112  + g_imb.imb1131
                + g_imb.imb1132 + g_imb.imb114  + g_imb.imb115
                + g_imb.imb1151
                + g_imb.imb116  + g_imb.imb1171 + g_imb.imb1172
                + g_imb.imb119  + g_imb.imb120  + g_imb.imb121
                + g_imb.imb122  + g_imb.imb1231 + g_imb.imb1232
                + g_imb.imb124  + g_imb.imb125  + g_imb.imb126
                + g_imb.imb1251
                + g_imb.imb1271 + g_imb.imb1272 + g_imb.imb129
                + g_imb.imb130
      LET l_sum2= g_imb.imb211  + g_imb.imb212  + g_imb.imb2131
                + g_imb.imb2132 + g_imb.imb214  + g_imb.imb215
                + g_imb.imb2151  
                + g_imb.imb216  + g_imb.imb2171 + g_imb.imb2172
                + g_imb.imb219  + g_imb.imb220  + g_imb.imb221
                + g_imb.imb222  + g_imb.imb2231 + g_imb.imb2232
                + g_imb.imb224  + g_imb.imb225  + g_imb.imb226
                + g_imb.imb2251
                + g_imb.imb2271 + g_imb.imb2272 + g_imb.imb229
                + g_imb.imb230
      LET l_sum3= g_imb.imb311  + g_imb.imb312  + g_imb.imb3131
                + g_imb.imb3132 + g_imb.imb314  + g_imb.imb315
                + g_imb.imb3151
                + g_imb.imb316  + g_imb.imb3171 + g_imb.imb3172
                + g_imb.imb319  + g_imb.imb320  + g_imb.imb321
                + g_imb.imb322  + g_imb.imb3231 + g_imb.imb3232
                + g_imb.imb324  + g_imb.imb325  + g_imb.imb326
                + g_imb.imb3251
                + g_imb.imb3271 + g_imb.imb3272 + g_imb.imb329
                + g_imb.imb330
  END IF
  DISPLAY l_sum1 TO FORMONLY.d2
  DISPLAY l_sum2 TO FORMONLY.d3
  DISPLAY l_sum3 TO FORMONLY.d4
END FUNCTION
#FUN-650025...............end
 
FUNCTION aimi106_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_imb.* TO NULL                   #FUN-680046 add
    
    CALL cl_opmsg('q')
    MESSAGE ""
    
    DISPLAY '   ' TO FORMONLY.cnt
    CALL aimi106_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN aimi106_count
    FETCH aimi106_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN aimi106_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imb.imb01,SQLCA.sqlcode,0)
        INITIALIZE g_imb.* TO NULL
    ELSE
        CALL aimi106_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aimi106_fetch(p_flimb)
    DEFINE
        p_flimb          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flimb
        WHEN 'N' FETCH NEXT     aimi106_curs INTO g_imb.imb01
        WHEN 'P' FETCH PREVIOUS aimi106_curs INTO g_imb.imb01
        WHEN 'F' FETCH FIRST    aimi106_curs INTO g_imb.imb01
        WHEN 'L' FETCH LAST     aimi106_curs INTO g_imb.imb01
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
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump aimi106_curs INTO g_imb.imb01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imb.imb01,SQLCA.sqlcode,0)
        INITIALIZE g_imb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flimb
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_imb.* FROM imb_file            # 重讀DB,因TEMP有不被更新特性
       WHERE imb01 = g_imb.imb01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_imb.imb01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","imb_file",g_imb.imb01,"",
                     SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
        LET g_data_owner = g_imb.imbuser #FUN-4C0053
        LET g_data_group = g_imb.imbgrup #FUN-4C0053
        CALL aimi106_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION aimi106_show()
    DEFINE   l_sum        LIKE imb_file.imb118 #MOD-530179
 
    LET g_imb_t.* = g_imb.*
    DISPLAY g_s TO FORMONLY.s
    CALL aimi106_cost()
    CALL aimi106_imb01('d')
    CASE g_imb.imb02
         WHEN '0'  CALL cl_getmsg('mfg0023',g_lang) RETURNING g_str4
         WHEN '1'  CALL cl_getmsg('mfg0024',g_lang) RETURNING g_str4
         WHEN '2'  CALL cl_getmsg('mfg0025',g_lang) RETURNING g_str4
         OTHERWISE EXIT CASE
    END CASE
#   DISPLAY g_str4 TO FORMONLY.d1
#   CASE g_cost_code
#        WHEN '1'  CALL cl_getmsg('mfg1315',g_lang) RETURNING l_str
#        WHEN '2'  CALL cl_getmsg('mfg1316',g_lang) RETURNING l_str
#        WHEN '3'  CALL cl_getmsg('mfg1317',g_lang) RETURNING l_str
#        OTHERWISE EXIT CASE
#   END CASE
#   DISPLAY l_str   TO FORMONLY.d_cost
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION  aimi106_cost()
 
    DISPLAY BY NAME  g_imb.imbuser, g_imb.imbgrup, g_imb.imbmodu, g_imb.imboriu,g_imb.imborig,
                     g_imb.imbdate, g_imb.imbacti
    DISPLAY BY NAME  g_imb.imb01,g_imb.imb02
    DISPLAY BY NAME  g_imb.imb111,
                     g_imb.imb112,g_imb.imb1131,g_imb.imb1132,
                     g_imb.imb119,g_imb.imb114,g_imb.imb115,
                     g_imb.imb1151,
                     g_imb.imb116,g_imb.imb1171,g_imb.imb1172,
                     g_imb.imb118, g_imb.imb121, g_imb.imb122,
                     g_imb.imb1231,g_imb.imb1232, g_imb.imb129,
                     g_imb.imb124,g_imb.imb125,  g_imb.imb126,
                     g_imb.imb1251,
                     g_imb.imb1271,g_imb.imb1272,g_imb.imb120,g_imb.imb130
    DISPLAY BY NAME  g_imb.imb211,
                     g_imb.imb212 ,g_imb.imb2131,g_imb.imb2132,
                     g_imb.imb219 ,g_imb.imb214,g_imb.imb215 ,
                     g_imb.imb2151,  
                     g_imb.imb216, g_imb.imb2171,g_imb.imb2172,
                     g_imb.imb218, g_imb.imb221, g_imb.imb222,
                     g_imb.imb2231,g_imb.imb2232, g_imb.imb229,
                     g_imb.imb224,g_imb.imb225,  g_imb.imb226,
                     g_imb.imb2251,
                     g_imb.imb2271,g_imb.imb2272,g_imb.imb220,g_imb.imb230
    DISPLAY BY NAME  g_imb.imb311,
                     g_imb.imb312 ,g_imb.imb3131,g_imb.imb3132,
                     g_imb.imb319 ,g_imb.imb314,g_imb.imb315 ,
                     g_imb.imb3151,
                     g_imb.imb316, g_imb.imb3171,g_imb.imb3172,
                     g_imb.imb318, g_imb.imb321, g_imb.imb322,
                     g_imb.imb3231,g_imb.imb3232, g_imb.imb329,
                     g_imb.imb324,g_imb.imb325,  g_imb.imb326,
                     g_imb.imb3251,
                     g_imb.imb3271,g_imb.imb3272,g_imb.imb320,g_imb.imb330
END FUNCTION
 
FUNCTION aimi106_u()

    IF s_shut(0) THEN RETURN END IF
    IF g_imb.imb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_imb.imbacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_imb.imb01,'9027',0)
        RETURN
    END IF
    IF g_imaacti ='N' THEN        #檢查資料是否為無效
        CALL cl_err(g_imb.imb01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imb01_t = g_imb.imb01
    LET g_imb_o.* = g_imb.*
    BEGIN WORK
 
    #-genero-------------------------------------------------------------
    #(1) If you have "?" inside above DECLARE SELECT FOR UPDATE SQL
    #(2) Then using syntax: "OPEN cursor USING variable"
    #For example, "OPEN a USING g_a_worid"
    #
    #* Remember to remove releated block of *.ora file, no more needed
    #--------------------------------------------------------------------
    #--Put variable into LOCK CURSOR
    OPEN aimi106_curl USING g_imb.imb01
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN aimi106_curl:", STATUS, 1)
       CLOSE aimi106_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aimi106_curl INTO g_imb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imb.imb01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_imb.imbmodu=g_user                     #修改者
    LET g_imb.imbdate = g_today                  #修改日期
    CALL aimi106_show()                          # 顯示最新資料
    WHILE TRUE
        CALL aimi106_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imb_t.imbdate=g_imb_o.imbdate        #TQC-C40219
            LET g_imb_t.imbmodu=g_imb_o.imbmodu        #TQC-C40219
            LET g_imb.*=g_imb_t.*        #TQC-C40155 #TQC-C40219
           #LET g_imb.*=g_imb_o.*        #TQC-C40155 #TQC-C40219
            CALL aimi106_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
       #FUN-650025...............mark begin
       #CASE g_cost_code
       #  WHEN '1'
       #         UPDATE imb_file SET
       #                      imb111 =g_imb.imb111 ,imb112 =g_imb.imb112 ,imb1131=g_imb.imb1131,
       #                      imb1132=g_imb.imb1132,imb114 =g_imb.imb114 ,imb115 =g_imb.imb115 ,
       #                      imb1151=g_imb.imb1151,imb116 =g_imb.imb116 ,imb1171=g_imb.imb1171,
       #                      imb1172=g_imb.imb1172,imb119 =g_imb.imb119 ,imb118 =g_imb.imb118 ,
       #                      imb120 =g_imb.imb120 ,imb121 =g_imb.imb121 ,imb122 =g_imb.imb122 ,
       #                      imb1231=g_imb.imb1231,imb1232=g_imb.imb1232,imb124 =g_imb.imb124 ,
       #                      imb125 =g_imb.imb125 ,imb1251=g_imb.imb1251,imb126 =g_imb.imb126 ,
       #                      imb1271=g_imb.imb1271,imb1272=g_imb.imb1272,imb129 =g_imb.imb129 ,
       #                      imb130 =g_imb.imb130 ,imbacti=g_imb.imbacti,imbuser=g_imb.imbuser,
       #                      imbgrup=g_imb.imbgrup,imbmodu=g_imb.imbmodu,imbdate=g_imb.imbdate
       #              WHERE imb01 = g_imb.imb01             # COLAUTH?
       #  WHEN '2'
       #        UPDATE imb_file SET
       #                      imb211=g_imb.imb111,imb212=g_imb.imb112,imb2131=g_imb.imb1131,
       #                      imb2132=g_imb.imb1132,imb214=g_imb.imb114,imb215=g_imb.imb115,
       #                      imb2151=g_imb.imb1151,
       #                      imb216=g_imb.imb116,imb2171=g_imb.imb1171,imb2172=g_imb.imb1172,
       #                      imb219=g_imb.imb119,imb218=g_imb.imb118, imb220=g_imb.imb120,
       #                      imb221=g_imb.imb121, imb222=g_imb.imb122,imb2231=g_imb.imb1231,
       #                      imb2232=g_imb.imb1232, imb224=g_imb.imb124,imb225=g_imb.imb125,
       #                      imb2251=g_imb.imb1251,
       #                      imb226=g_imb.imb126, imb2271=g_imb.imb1271,imb2272=g_imb.imb1272,
       #                      imb229=g_imb.imb129, imb230=g_imb.imb130,
       #                      imbacti=g_imb.imbacti,imbuser=g_imb.imbuser,imbgrup=g_imb.imbgrup,
       #                      imbmodu=g_imb.imbmodu,imbdate=g_imb.imbdate
       #              WHERE imb01 = g_imb.imb01             # COLAUTH?
       #  WHEN '3'
       #       UPDATE imb_file SET
       #                      imb311=g_imb.imb111,imb312=g_imb.imb112,imb3131=g_imb.imb1131,
       #                      imb3132=g_imb.imb1132,imb314=g_imb.imb114,imb315=g_imb.imb115,
       #                      imb3151=g_imb.imb1151,
       #                      imb316=g_imb.imb116,imb3171=g_imb.imb1171,imb3172=g_imb.imb1172,
       #                      imb319=g_imb.imb119,imb318=g_imb.imb118, imb320=g_imb.imb120,
       #                      imb321=g_imb.imb121, imb322=g_imb.imb122,imb3231=g_imb.imb1231,
       #                      imb3232=g_imb.imb1232, imb324=g_imb.imb124,imb325=g_imb.imb125,
       #                      imb3251=g_imb.imb1251,
       #                      imb326=g_imb.imb126, imb3271=g_imb.imb1271,imb3272=g_imb.imb1272,
       #                      imb329=g_imb.imb129, imb330=g_imb.imb130,
       #                      imbacti=g_imb.imbacti,imbuser=g_imb.imbuser,imbgrup=g_imb.imbgrup,
       #                      imbmodu=g_imb.imbmodu,imbdate=g_imb.imbdate
       #              WHERE imb01 = g_imb.imb01             # COLAUTH?
       #       OTHERWISE EXIT CASE
       #END CASE
       #FUN-650025...............mark end
        UPDATE imb_file SET imb_file.*=g_imb.* WHERE imb01 = g_imb.imb01 #FUN-650025
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_imb.imb01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","imb_file",g_imb01_t,"",
                         SQLCA.sqlcode,"","",1)  #No.FUN-660156
            CONTINUE WHILE
      # ELSE UPDATE ima_file SET ima93=SUBSTRING(ima93,1,5)+'Y'+SUBSTRING(ima93,7,8)  #No.TQC-9B0021
        ELSE UPDATE ima_file SET ima93=ima93[1,5] || 'Y' || ima93[7,8],  #No.TQC-9B0021
                                 imadate = g_today     #FUN-C30315 add
                             WHERE ima01 = g_imb.imb01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_imb.imb01,SQLCA.sqlcode,0) #No.FUN-660156
                CALL cl_err3("upd","ima_file",g_imb.imb01,"",
                              SQLCA.sqlcode,"","",1)  #No.FUN-660156
             END IF
        END IF
        EXIT WHILE
    END WHILE
    CLOSE aimi106_curl
    COMMIT WORK
END FUNCTION
#FUN-B90105----add--begin---- 
FUNCTION i106_ins_imb()
  DEFINE l_imx000 LIKE imx_file.imx000
  DEFINE l_sql    STRING
  DEFINE l_imb    RECORD LIKE imb_file.*
  DEFINE l_count  LIKE type_file.num5

     SELECT count(*) INTO l_count FROM imb_file WHERE imb01 IN (SELECT imx000 FROM imx_file WHERE imx00=g_imb.imb01)
     IF NOT cl_null(l_count) AND l_count >0  THEN
        RETURN
     END IF

     INITIALIZE l_imb.* LIKE imb_file.*
     LET l_imb.imb02='0'  LET l_imb.imb111=0
     LET l_imb.imb112=0   LET l_imb.imb1131=0
     LET l_imb.imb1132=0  LET l_imb.imb114=0
     LET l_imb.imb115=0   LET l_imb.imb116=0
     LET l_imb.imb1151=0
     LET l_imb.imb1171=0  LET l_imb.imb1172=0
     LET l_imb.imb118=0   LET l_imb.imb119=0
     LET l_imb.imb129=0   LET l_imb.imb121=0
     LET l_imb.imb122=0   LET l_imb.imb1231=0
     LET l_imb.imb1232=0  LET l_imb.imb124=0
     LET l_imb.imb125=0   LET l_imb.imb126=0
     LET l_imb.imb1251=0
     LET l_imb.imb1271=0  LET l_imb.imb1272=0
     LET l_imb.imb120=0   LET l_imb.imb130=0
     LET l_imb.imb211=0   LET l_imb.imb212=0
     LET l_imb.imb2131=0  LET l_imb.imb2132=0
     LET l_imb.imb214=0   LET l_imb.imb215=0
     LET l_imb.imb2151=0
     LET l_imb.imb216=0   LET l_imb.imb2171=0
     LET l_imb.imb2172=0  LET l_imb.imb219=0
     LET l_imb.imb218=0   LET l_imb.imb221=0
     LET l_imb.imb222=0   LET l_imb.imb2231=0
     LET l_imb.imb2232=0  LET l_imb.imb224=0
     LET l_imb.imb225=0   LET l_imb.imb226=0
     LET l_imb.imb2251=0
     LET l_imb.imb2271=0  LET l_imb.imb2272=0
     LET l_imb.imb229=0   LET l_imb.imb311=0
     LET l_imb.imb220=0   LET l_imb.imb230=0
     LET l_imb.imb312=0   LET l_imb.imb3131=0
     LET l_imb.imb3132=0  LET l_imb.imb314=0
     LET l_imb.imb315=0   LET l_imb.imb316=0
     LET l_imb.imb3151=0
     LET l_imb.imb3171=0  LET l_imb.imb3172=0
     LET l_imb.imb319=0   LET l_imb.imb318=0
     LET l_imb.imb321=0   LET l_imb.imb322=0
     LET l_imb.imb3231=0  LET l_imb.imb3232=0
     LET l_imb.imb324=0   LET l_imb.imb325=0
     LET l_imb.imb3251=0
     LET l_imb.imb326=0   LET l_imb.imb3271=0
     LET l_imb.imb3272=0  LET l_imb.imb329=0
     LET l_imb.imb320=0   LET l_imb.imb330=0
     LET l_imb.imbacti ='Y'                   #有效的資料
     LET l_imb.imbuser = g_user
     LET l_imb.imboriu = g_user
     LET l_imb.imborig = g_grup
     LET l_imb.imbgrup = g_grup               #使用者所屬群
     LET l_imb.imbdate = g_today

     LET l_sql="SELECT imx000 FROM imx_file WHERE imx00='",g_imb.imb01,"'"
     PREPARE imb_ins1 FROM l_sql
     DECLARE imb_ins1_upd CURSOR FOR imb_ins1
     FOREACH imb_ins1_upd INTO l_imx000
         LET l_imb.imb01=l_imx000
         INSERT INTO imb_file VALUES(l_imb.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","imb_file",l_imb.imb01,"",SQLCA.sqlcode,"","",1)
            CONTINUE FOREACH
         END IF
      END FOREACH
END FUNCTION
#FUN-B90105----add--end---
 
FUNCTION aimi106_x()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imb.imb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    #-genero-------------------------------------------------------------
    #(1) If you have "?" inside above DECLARE SELECT FOR UPDATE SQL
    #(2) Then using syntax: "OPEN cursor USING variable"
    #For example, "OPEN a USING g_a_worid"
    #
    #* Remember to remove releated block of *.ora file, no more needed
    #--------------------------------------------------------------------
    #--Put variable into LOCK CURSOR
    OPEN aimi106_curl USING g_imb.imb01
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN aimi106_curl:", STATUS, 1)
       CLOSE aimi106_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aimi106_curl INTO g_imb.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imb.imb01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL aimi106_show()
    IF cl_exp(0,0,g_imb.imbacti) THEN
        LET g_chr=g_imb.imbacti
        IF g_imb.imbacti='Y' THEN
            LET g_imb.imbacti='N'
        ELSE
            LET g_imb.imbacti='Y'
        END IF
        UPDATE imb_file
            SET imbacti=g_imb.imbacti,
                imbmodu=g_user, imbdate=g_today
            WHERE imb01=g_imb.imb01
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_imb.imb01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","imb_file",g_imb.imb01,"",
                         SQLCA.sqlcode,"","",1)  #No.FUN-660156
            LET g_imb.imbacti=g_chr
        END IF
        DISPLAY BY NAME g_imb.imbacti
    END IF
    CLOSE aimi106_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION aimi106_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imb.imb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN aimi106_curl USING g_imb.imb01
    IF STATUS THEN
       CALL cl_err("OPEN aimi106_curl:", STATUS, 1)
       CLOSE aimi106_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aimi106_curl INTO g_imb.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_imb.imb01,SQLCA.sqlcode,0) RETURN END IF
    CALL aimi106_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "imb01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_imb.imb01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM imb_file WHERE imb01 = g_imb.imb01
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_imb.imb01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("del","imb_file",g_imb.imb01,"",
                         SQLCA.sqlcode,"","",1)  #No.FUN-660156
        ELSE
            CLEAR FORM
            OPEN aimi106_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE aimi106_curs
               CLOSE aimi106_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH aimi106_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE aimi106_curs
               CLOSE aimi106_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN aimi106_curs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL aimi106_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET g_no_ask = TRUE
               CALL aimi106_fetch('/')
            END IF
        END IF
    END IF
    CLOSE aimi106_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION aimi106_copy()
    DEFINE
        l_n             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_newno,l_oldno LIKE ima_file.ima01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imb.imb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE   #FUN-580026
    CALL i106_set_entry('a')          #FUN-580026
    LET g_before_input_done = TRUE    #FUN-580026
    INPUT l_newno FROM imb01
        BEFORE FIELD imb01                               #key 值不可修改
	       IF g_sma.sma60 = 'Y'		# 若須分段輸入
	          THEN CALL s_inp5(6,12,l_newno) RETURNING l_newno
	               DISPLAY l_newno TO imb01
      	    END IF
 
        AFTER FIELD imb01
            IF l_newno IS NULL THEN
                NEXT FIELD imb01
            ELSE SELECT ima01 FROM ima_file
                              WHERE ima01 = l_newno
                                AND imaacti IN ('y','Y')
                 IF SQLCA.sqlcode THEN 
#                   CALL cl_err(l_newno,'mfg0002',0) #No.FUN-660156
                    CALL cl_err3("sel","ima_file",l_newno,"",
                                 "mfg0002","","",1)  #No.FUN-660156
                                NEXT FIELD imb01
                 END IF
            END IF
            SELECT count(*) INTO g_cnt FROM imb_file
                WHERE imb01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD imb01
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_imb.imb01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM imb_file
        WHERE imb01=g_imb.imb01
        INTO TEMP x
    UPDATE x
        SET imb01=l_newno,    #資料鍵值
            imbuser=g_user,   #資料所有者
            imbgrup=g_grup,   #資料所有者所屬群
            imbmodu=NULL,     #資料修改日期
            imbdate=g_today,  #資料建立日期
            imbacti='Y'       #有效資料
    INSERT INTO imb_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_imb.imb01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("ins","imb_file",g_imb.imb01,"",
                     SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_imb.imb01
        SELECT imb_file.* INTO g_imb.* FROM imb_file
                       WHERE imb01 = l_newno
        CALL aimi106_u()
        #SELECT imb_file.* INTO g_imb.* FROM imb_file  #FUN-C30027
        #               WHERE imb01 = l_oldno          #FUN-C30027
    END IF
    CALL aimi106_show()
  # DISPLAY BY NAME g_imb.imb01
END FUNCTION
 
FUNCTION aimi106_out()
    DEFINE
        sr        RECORD LIKE  imb_file.*,
        l_i       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_name    LIKE type_file.chr20,   #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
        l_za05    LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
        l_chr     LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
    CALL cl_wait()
#   LET l_name = 'aimi106.out'
    #FUN-650025...............begin
    CALL i106_set_cost() 
    IF (NOT g_cost_code MATCHES '[123]') OR 
        cl_null(g_cost_code) THEN
       RETURN
    END IF 
    #FUN-650025...............end
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#NO.CHI-6A0004--END     
    #CALL cl_outnam('aimi106') RETURNING l_name        #No.FUN-840029
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimi106'
    #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF    #No.FUN-840029
    #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR      #No.FUN-840029 
    LET g_sql="SELECT imb_file.* FROM ima_file,imb_file ",
              " WHERE ima01=imb01 AND ",g_wc CLIPPED
    #No.FUN-840029---Begin 
    #PREPARE aimi106_p1 FROM g_sql                # RUNTIME 編譯
    #DECLARE aimi106_curo                         # CURSOR
    #    CURSOR FOR aimi106_p1
 
    #START REPORT aimi106_rep TO l_name
 
    #FOREACH aimi106_curo INTO sr.*
    #    IF SQLCA.sqlcode THEN
    #        CALL cl_err('foreach:',SQLCA.sqlcode,1)
    #        EXIT FOREACH
    #        END IF
    #    OUTPUT TO REPORT aimi106_rep(sr.*)
    #END FOREACH
 
    #FINISH REPORT aimi106_rep
 
    #CLOSE aimi106_curo
    #ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'imb01,imb02,imbuser,imbmodu,imbacti,imbgrup,imbdate')
       RETURNING g_str                                                          
    END IF                                                                      
    LET g_str = g_str,";",g_azi03,";",g_cost_code                               
    CALL cl_prt_cs1('aimi106','aimi106',g_sql,g_str)                            
    #No.FUN-840029---End  
 
END FUNCTION
 
#No.FUN-840029---Begin
#REPORT aimi106_rep(sr)
#   DEFINE
#       sr RECORD LIKE imb_file.*,
#       l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       l_str1          LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(8)
#       l_str2          LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(8)
#       l_str3          LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(8)
#       l_str4          LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(12)
#       l_chr           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.imb01,sr.imb02
 
#   FORMAT
#       PAGE HEADER
#           PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user
#           PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#           PRINT ' '
#           PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#                 COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
#           PRINT g_dash[1,g_len]
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#       CASE sr.imb02
#          WHEN '0'  CALL cl_getmsg('mfg0023',g_lang) RETURNING l_str4
#          WHEN '1'  CALL cl_getmsg('mfg0024',g_lang) RETURNING l_str4
#          WHEN '2'  CALL cl_getmsg('mfg0025',g_lang) RETURNING l_str4
#         OTHERWISE EXIT CASE
#       END CASE
#           PRINT  g_x[11] clipped,sr.imb01
#           PRINT  g_x[12] clipped,l_str4
#           PRINT ' '
#       CASE g_cost_code
#        WHEN '1'
#           IF sr.imbacti = 'N' THEN PRINT '*'; END IF
#              CALL cl_getmsg('mfg1315',g_lang) RETURNING l_str1
#              CALL cl_getmsg('mfg0021',g_lang) RETURNING l_str2
#              CALL cl_getmsg('mfg0022',g_lang) RETURNING l_str3
#             #start TQC-5B0059
#             #PRINT l_str1,COLUMN 11,'-----------------------------',
#             #      l_str2,'--------------',l_str3,'----'
#              PRINT l_str1,COLUMN 11,'----------------------------------',
#                    l_str2,'---------------',l_str3,'-----'
#             #end TQC-5B0059
#              PRINT COLUMN 12,g_x[14] clipped, COLUMN 37,cl_numfor(sr.imb111 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb121 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[15] clipped, COLUMN 37,cl_numfor(sr.imb112 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb122 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[16] clipped, COLUMN 37,cl_numfor(sr.imb1131,15,g_azi03),COLUMN 60,cl_numfor(sr.imb1231,15,g_azi03)
#              PRINT COLUMN 12,g_x[17] clipped, COLUMN 37,cl_numfor(sr.imb1132,15,g_azi03),COLUMN 60,cl_numfor(sr.imb1232,15,g_azi03)
#              PRINT COLUMN 12,g_x[18] clipped, COLUMN 37,cl_numfor(sr.imb119 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb129 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[19] clipped, COLUMN 37,cl_numfor(sr.imb114 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb124 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[20] clipped, COLUMN 37,cl_numfor(sr.imb115 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb125 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[21] clipped, COLUMN 37,cl_numfor(sr.imb116 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb126 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[22] clipped, COLUMN 37,cl_numfor(sr.imb1171,15,g_azi03),COLUMN 60,cl_numfor(sr.imb1271,15,g_azi03)
#              PRINT COLUMN 12,g_x[23] clipped, COLUMN 37,cl_numfor(sr.imb1172,15,g_azi03),COLUMN 60,cl_numfor(sr.imb1272,15,g_azi03)
#              PRINT COLUMN 12,g_x[23] clipped, COLUMN 37,cl_numfor(sr.imb120 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb130 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[24] clipped, COLUMN 37,cl_numfor(sr.imb118 ,15,g_azi03)
#        WHEN '2'
#              CALL cl_getmsg('mfg1316',g_lang) RETURNING l_str1
#              CALL cl_getmsg('mfg0021',g_lang) RETURNING l_str2
#              CALL cl_getmsg('mfg0022',g_lang) RETURNING l_str3
#             #start TQC-5B0059
#             #PRINT l_str1,COLUMN 11,'-----------------------------',
#             #      l_str2,'--------------',l_str3,'----'
#              PRINT l_str1,COLUMN 11,'----------------------------------',
#                    l_str2,'---------------',l_str3,'-----'
#             #end TQC-5B0059
#              PRINT COLUMN 12,g_x[14] clipped,COLUMN 37,cl_numfor(sr.imb211 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb221 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[15] clipped,COLUMN 37,cl_numfor(sr.imb212 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb222 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[16] clipped,COLUMN 37,cl_numfor(sr.imb2131,15,g_azi03),COLUMN 60,cl_numfor(sr.imb2231,15,g_azi03)
#              PRINT COLUMN 12,g_x[17] clipped,COLUMN 37,cl_numfor(sr.imb2132,15,g_azi03),COLUMN 60,cl_numfor(sr.imb2232,15,g_azi03)
#              PRINT COLUMN 12,g_x[18] clipped,COLUMN 37,cl_numfor(sr.imb219 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb229 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[19] clipped,COLUMN 37,cl_numfor(sr.imb214 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb224 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[20] clipped,COLUMN 37,cl_numfor(sr.imb215 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb225 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[21] clipped,COLUMN 37,cl_numfor(sr.imb216 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb226 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[22] clipped,COLUMN 37,cl_numfor(sr.imb2171,15,g_azi03),COLUMN 60,cl_numfor(sr.imb2271,15,g_azi03)
#              PRINT COLUMN 12,g_x[23] clipped,COLUMN 37,cl_numfor(sr.imb2172,15,g_azi03),COLUMN 60,cl_numfor(sr.imb2272,15,g_azi03)
#              PRINT COLUMN 12,g_x[25] clipped,COLUMN 37,cl_numfor(sr.imb220 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb230 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[24] clipped,COLUMN 37,cl_numfor(sr.imb218 ,15,g_azi03)
#        WHEN '3'
#              CALL cl_getmsg('mfg1317',g_lang) RETURNING l_str1
#              CALL cl_getmsg('mfg0021',g_lang) RETURNING l_str2
#              CALL cl_getmsg('mfg0022',g_lang) RETURNING l_str3
#             #start TQC-5B0059
#             #PRINT l_str1,COLUMN 11,'-----------------------------',
#             #      l_str2,'--------------',l_str3,'----'
#              PRINT l_str1,COLUMN 11,'----------------------------------',
#                    l_str2,'---------------',l_str3,'-----'
#             #end TQC-5B0059
#              PRINT COLUMN 12,g_x[14] clipped, COLUMN 37,cl_numfor(sr.imb311 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb321 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[15] clipped, COLUMN 37,cl_numfor(sr.imb312 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb322 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[16] clipped, COLUMN 37,cl_numfor(sr.imb3131,15,g_azi03),COLUMN 60,cl_numfor(sr.imb3231,15,g_azi03)
#              PRINT COLUMN 12,g_x[17] clipped, COLUMN 37,cl_numfor(sr.imb3132,15,g_azi03),COLUMN 60,cl_numfor(sr.imb3232,15,g_azi03)
#              PRINT COLUMN 12,g_x[18] clipped, COLUMN 37,cl_numfor(sr.imb319 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb329 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[19] clipped, COLUMN 37,cl_numfor(sr.imb314 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb324 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[20] clipped, COLUMN 37,cl_numfor(sr.imb315 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb325 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[21] clipped, COLUMN 37,cl_numfor(sr.imb316 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb326 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[22] clipped, COLUMN 37,cl_numfor(sr.imb3171,15,g_azi03),COLUMN 60,cl_numfor(sr.imb3271,15,g_azi03)
#              PRINT COLUMN 12,g_x[23] clipped, COLUMN 37,cl_numfor(sr.imb3172,15,g_azi03),COLUMN 60,cl_numfor(sr.imb3272,15,g_azi03)
#              PRINT COLUMN 12,g_x[25] clipped, COLUMN 37,cl_numfor(sr.imb320 ,15,g_azi03),COLUMN 60,cl_numfor(sr.imb330 ,15,g_azi03)
#              PRINT COLUMN 12,g_x[24] clipped, COLUMN 37,cl_numfor(sr.imb318 ,15,g_azi03)
#           OTHERWISE EXIT CASE
#       END CASE
#       PRINT ' '
 
#       ON LAST ROW
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN PRINT g_dash[1,g_len]
#                   CALL cl_prt_pos_wc(g_wc) #TQC-630166
#           END IF
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-840029---End
 
FUNCTION i106_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
      IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("imb01",TRUE)
      END IF
 
{
      CASE
        WHEN INFIELD(A) OR (NOT g_before_input_done)
             CALL cl_set_comp_entry("B,C,",TRUE)
      END CASE
}
 
END FUNCTION
 
FUNCTION i106_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("imb01",FALSE)
    END IF
 
{
    CASE
        WHEN INFIELD(A) OR (NOT g_before_input_done)
          CASE xxx
            WHEN yyy
                 CALL cl_set_comp_entry("B,C",FALSE)
            OTHERWISE
                 CALL cl_set_comp_entry("D,E",FALSE)
          END CASE
    END CASE
}
 
END FUNCTION
 
#FUN-650025
FUNCTION i106_set_cost()
 
   OPEN WINDOW i106a_w AT 2,2 WITH FORM "aim/42f/aimi106a" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
         
   CALL cl_ui_locale("aimi106a")
 
   LET g_cost_code="1"
 
   INPUT g_cost_code WITHOUT DEFAULTS FROM d_cost
 
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
      LET g_cost_code = NULL
   END IF
   CLOSE WINDOW i106a_w
   RETURN
END FUNCTION
#Patch....NO.TQC-610036 <001> #
