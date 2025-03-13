# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi151.4gl
# Descriptions...: 客戶產品維護作業
# Input parameter: 
# Date & Author..: 00/08/02 By Mandy 
# Modify.........: No:8914 03/12/15 By Melody 游標移到最近訂單日的位置 ,
#                : 向前移動會當掉,No:8914,GENERO已拿掉不適用
# Modify.........: No:9555 04/05/13 By Melody 當新輸入一筆資料時，
#                : key第二列資料時，第一列顯示的資料會與第二列相同
#                : No:9555,GENERO已拿掉不適用
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0099 05/02/15 By kim 報表轉XML功能
# Modify.........: No.MOD-590538 05/09/30 By saki 刪除後的總筆數控制修改
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-680064 06/10/18 By huchenghao 初始化g_rec_b
# Modify.........: No.FUN-6A0094 06/11/01 By yjkhero l_time轉g_time  
# Modify.........: No.FUN-6A0092 06/11/13 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6A0045 06/11/15 By Claire default obk11-obk14
# Modify.........: No.FUN-6A0020 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-670099 06/11/22 By Nicola 價格管理修改
# Modify.........: No.MOD-710048 07/01/26 By claire 無效料號不可新增
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780239 07/08/22 By claire 刪除時要將筆數-1
# Modify.........: No.TQC-780095 07/09/03 By Melody Primary key
# Modify.........: No.MOD-7B0197 07/11/22 By claire 要判斷客戶代碼是否為有效資料
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840019 08/04/28 By lutingting報表轉為使用CR輸出
# Modify.........: No.MOD-850108 08/05/12 By Smapmin 重新顯示單身客戶產品編號欄位
# Modify.........: No.MOD-850286 08/05/28 By Smapmin obkuser/obkgrup/obkacti/obk11 default預設值
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: NO.MOD-8B0180 08/11/19 By clover 單身新增出現錯誤訊息
# Modify.........: No.TQC-930029 09/03/05 By chenyu 單身“最近訂單單價”，“最近訂單數量”欄位不可錄入負值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0071 10/01/07 By huangrh 精簡程式 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-910088 11/11/15 By fengrui 增加數量欄位小數取位
# Modify.........: No.CHI-C60013 12/07/06 By Elise 增加資料所有者等欄位
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D50045 13/05/15 By zhuhao 单身料号开窗可多选插入单身

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_obk02         LIKE obk_file.obk02,   #客戶編號 (假單頭)
    g_obk02_t       LIKE obk_file.obk02,   #客戶編號 (舊值)
    g_obk01         LIKE obk_file.obk01,   #產品編號
    g_obk01_t       LIKE obk_file.obk01,   #產品編號(舊值)
    g_obk           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        obk01       LIKE obk_file.obk01,   #產品編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格
        obk03       LIKE obk_file.obk03,   #客戶的產品編號
        obk04       LIKE obk_file.obk04,   #最近訂單日
        obk05       LIKE obk_file.obk05,   #最近訂單幣別
        obk07       LIKE obk_file.obk07,   #最近訂單銷售單位
        obk08       LIKE obk_file.obk08,   #最近訂單單價
        obk09       LIKE obk_file.obk09,   #最近訂單數量  #CHI-C60013 add ,
      #------CHI-C60013------#
        obkuser     LIKE obk_file.obkuser, #資料所有者
        obkgrup     LIKE obk_file.obkgrup, #資料所有部門
        obkmodu     LIKE obk_file.obkmodu, #資料修改者
        obkdate     LIKE obk_file.obkdate, #最近修改日
        obkacti     LIKE obk_file.obkacti  #資料有效碼
      #------CHI-C60013------#
                    END RECORD,
    g_obk_t         RECORD                 #程式變數 (舊值)
        obk01       LIKE obk_file.obk01,   #產品編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格
        obk03       LIKE obk_file.obk03,   #客戶的產品編號
        obk04       LIKE obk_file.obk04,   #最近訂單日
        obk05       LIKE obk_file.obk05,   #最近訂單幣別
        obk07       LIKE obk_file.obk07,   #最近訂單銷售單位
        obk08       LIKE obk_file.obk08,   #最近訂單單價
        obk09       LIKE obk_file.obk09,   #最近訂單數量  #CHI-C60013 add ,
      #------CHI-C60013------#
        obkuser     LIKE obk_file.obkuser, #資料所有者
        obkgrup     LIKE obk_file.obkgrup, #資料所有部門
        obkmodu     LIKE obk_file.obkmodu, #資料修改者
        obkdate     LIKE obk_file.obkdate, #最近修改日
        obkacti     LIKE obk_file.obkacti  #資料有效碼
      #------CHI-C60013------#
                    END RECORD,
    g_argv1         LIKE obk_file.obk02,
    g_ss            LIKE type_file.chr1,   #No.FUN-680137  VARCHAR(01)
     g_wc,g_sql     STRING, #No.FUN-580092 HCN   
    g_rec_b         LIKE type_file.num5,   #單身筆數             #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-680137 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL 
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5             #count/index for any purpose    #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000          #No.FUN-680137 VARCHAR(72)
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   l_sql          STRING                       #No.FUN-840019
DEFINE   g_str          STRING                       #No.FUN-840019
DEFINE   l_table        STRING                       #No.FUN-840019
DEFINE   l_table1       STRING                       #No.FUN-840019
DEFINE   g_obk07_t      LIKE obk_file.obk07          #NO.FUN-910088
DEFINE   g_flag         LIKE type_file.chr1    #FUN-D50045 add
 
MAIN
   
     OPTIONS
         INPUT NO WRAP
     DEFER INTERRUPT
   
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXM")) THEN
       EXIT PROGRAM
    END IF
 
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
 
    LET l_sql = "obk02.obk_file.obk02,",  
                "occ02.occ_file.occ02"    
    LET l_table = cl_prt_temptable('axmi151',l_sql) CLIPPED
    IF l_table=-1 THEN EXIT PROGRAM END IF
    
    LET l_sql = "obk02.obk_file.obk02,",      
                "obk01.obk_file.obk01,",      
                "l_ima02a.ima_file.ima02,",   
                "l_ima021a.ima_file.ima021,", 
                "obk03.obk_file.obk03,",      
                "l_ima02b.ima_file.ima02,",   
                "l_ima021b.ima_file.ima021,", 
                "obk04.obk_file.obk04,",      
                "obk05.obk_file.obk05,",      
                "obk07.obk_file.obk07,",      
                "obk08.obk_file.obk08,",      
                "obk09.obk_file.obk09,",      
                "azi03.azi_file.azi03"        
    LET l_table1 = cl_prt_temptable('axmi1511',l_sql) CLIPPED
    IF l_table1=-1 THEN EXIT PROGRAM END IF
 
    LET g_obk02_t = NULL                   #消除鍵值
    LET g_obk01_t = NULL
    LET g_argv1 = ARG_VAL(1)
 
    LET p_row = 2 LET p_col = 12
 
    OPEN WINDOW i151_w AT p_row,p_col
         WITH FORM "axm/42f/axmi151" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
    CALL i151_menu()
 
    CLOSE WINDOW i151_w                   #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #NO.FUN-6A0094
         RETURNING g_time                 #NO.FUN-6A0094
 
END MAIN     
 
#QBE 查詢資料
FUNCTION i151_curs()
    CLEAR FORM                            #清除畫面
    CALL g_obk.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    IF NOT cl_null(g_argv1) THEN 
       LET g_obk02 =  g_argv1
       DISPLAY g_obk02 TO obk02
       CALL i151_obk02('d')
 
   INITIALIZE g_obk02 TO NULL    #No.FUN-750051
       CONSTRUCT g_wc ON obk01,obk03,obk04,obk05,obk07,obk08,obk09,    #螢幕上取條件  #CHI-C60013 add ,
                         obkuser,obkgrup,obkmodu,obkdate,obkacti       ##CHI-C60013 add
                    FROM s_obk[1].obk01,s_obk[1].obk03,s_obk[1].obk04,s_obk[1].obk05,
                         s_obk[1].obk07,s_obk[1].obk08,s_obk[1].obk09, #CHI-C60013 add ,
                         s_obk[1].obkuser,s_obk[1].obkgrup,s_obk[1].obkmodu,    #CHI-C60013 add
                         s_obk[1].obkdate,s_obk[1].obkacti                      #CHI-C60013 add
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
            ON ACTION controlp
               CASE
                  WHEN INFIELD(obk01) #產品名稱
#FUN-AA0059---------mod------------str-----------------                  
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.state = "c"
#                       LET g_qryparam.form ="q_ima"
#                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                       DISPLAY g_qryparam.multiret TO obk01 
                       NEXT FIELD obk01
                  WHEN INFIELD(obk05) #幣別
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_azi"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO obk05 
                       NEXT FIELD obk05
                  WHEN INFIELD(obk07) #銷售單位
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_gfe"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO obk07 
                       NEXT FIELD obk07
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
 
             
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
             END CONSTRUCT
             LET g_wc = g_wc CLIPPED,cl_get_extra_cond('obkuser', 'obkgrup') #FUN-980030
 
             LET g_wc = g_wc CLIPPED," AND obk02 ='",g_argv1,"'"
 
             IF INT_FLAG THEN RETURN END IF
 
    ELSE 
        CONSTRUCT g_wc ON obk02,obk01,obk03,obk04,obk05,obk07,obk08,obk09    #螢幕上取條件
            FROM obk02,s_obk[1].obk01,s_obk[1].obk03,s_obk[1].obk04,s_obk[1].obk05,
                       s_obk[1].obk07,s_obk[1].obk08,s_obk[1].obk09 
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
            ON ACTION controlp
               CASE
                  WHEN INFIELD(obk01) #產品名稱
#FUN-AA0059---------mod------------str----------------
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.state = "c"
#                       LET g_qryparam.form ="q_ima"
#                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                        CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                       DISPLAY g_qryparam.multiret TO obk01 
                       NEXT FIELD obk01
                  WHEN INFIELD(obk02) #客戶編號
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_occ"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO obk02 
                       NEXT FIELD obk02
                  WHEN INFIELD(obk05) #幣別
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_azi"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO obk05
                       NEXT FIELD obk05
                  WHEN INFIELD(obk07) #銷售單位
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_gfe"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO obk07
                       NEXT FIELD obk07
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
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
             END CONSTRUCT
 
        IF INT_FLAG THEN RETURN END IF
    END IF  
    LET g_sql= "SELECT UNIQUE obk02 FROM obk_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY obk02 "
    PREPARE i151_prepare FROM g_sql      #預備一下
    DECLARE i151_b_curs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i151_prepare
    #因主鍵值有兩個故所抓出資料筆數有誤
    DROP TABLE x
    LET g_sql = "SELECT COUNT(DISTINCT obk02) FROM obk_file",
                " WHERE ",g_wc CLIPPED
    PREPARE i151_precount FROM g_sql
    DECLARE i151_count CURSOR FOR i151_precount
END FUNCTION
 
FUNCTION i151_menu()
 
   WHILE TRUE
      CALL i151_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i151_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i151_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i151_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i151_u()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i151_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i151_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_obk),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_obk02 IS NOT NULL THEN
                 LET g_doc.column1 = "obk02"
                 LET g_doc.value1 = g_obk02
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i151_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
   CALL g_obk.clear()
    INITIALIZE g_obk01 LIKE obk_file.obk01
    INITIALIZE g_obk02 LIKE obk_file.obk02
    CLOSE i151_b_curs
    LET g_obk01_t = NULL
    LET g_obk02_t = NULL
    LET g_wc      = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i151_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
    
        LET g_rec_b=0                               #No.FUN-680064 
        IF g_ss='N' THEN
            FOR g_cnt = 1 TO g_obk.getLength()
                INITIALIZE g_obk[g_cnt].* TO NULL
            END FOR
        ELSE
            CALL i151_b_fill(' 1=1')          #單身
        END IF
 
        CALL i151_b()                        #輸入單身
        IF SQLCA.sqlcode THEN 
            CALL cl_err(g_obk02,SQLCA.sqlcode,0)
        END IF
        LET g_obk02_t = g_obk02                 #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
   
FUNCTION i151_u()
    DEFINE  l_buf      LIKE cob_file.cob08        #No.FUN-680137 VARCHAR(30)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_chkey = 'N' THEN 
       CALL cl_err(g_obk02,'aoo-085',0)
       RETURN 
    END IF
    IF cl_null(g_obk02)  THEN 
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_obk02_t = g_obk02
    BEGIN WORK
    WHILE TRUE
        CALL i151_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_obk02=g_obk02_t
            DISPLAY g_obk02 TO obk02               #單頭
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_obk02 != g_obk02_t 
            THEN  UPDATE obk_file SET obk02 = g_obk02 #更新DB
                WHERE obk02 = g_obk02_t 
            IF SQLCA.sqlcode THEN
                LET l_buf = g_obk02 clipped
                CALL cl_err3("upd","obk_file",g_obk02_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i151_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #a:輸入 u:更改   #No.FUN-680137 VARCHAR(1)
    l_buf           LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(60)
    l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    l_occ02         LIKE occ_file.occ02           #客戶簡稱 
 
    LET g_ss = 'Y'
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT g_obk02 WITHOUT DEFAULTS  
        FROM obk02
 
 
       BEFORE FIELD obk02
           IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN 
               LET g_obk02 = g_argv1
               DISPLAY g_obk02 TO obk02
               CALL i151_obk02('d')
               NEXT FIELD obk02
           END IF
       AFTER FIELD obk02
           IF g_obk02 IS NULL THEN
               NEXT FIELD obk02
           ELSE 
               IF (g_obk02_t IS NULL) OR (g_obk02_t != g_obk02) THEN
                   CALL i151_obk02('a')
                   IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_obk02,g_errno,0)
                     LET g_obk02 = g_obk02_t
                     DISPLAY g_obk02 TO obk02
                     NEXT FIELD obk02
                   END IF
               END IF
           END IF
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
        ON ACTION controlp 
           CASE
              WHEN INFIELD(obk02) #客戶編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_occ"
                   LET g_qryparam.default1 = g_obk02
                   CALL cl_create_qry() RETURNING g_obk02
                   SELECT occ02 INTO l_occ02 FROM occ_file
                    WHERE occ01 = g_obk02
                   DISPLAY l_occ02 TO occ02
                   NEXT FIELD obk02
            END CASE
 
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
END FUNCTION
 
   
FUNCTION i151_obk02(p_cmd)
    DEFINE
           p_cmd   LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
           l_occacti LIKE occ_file.occacti,      #MOD-7B0197 
           l_occ02 LIKE occ_file.occ02
 
    LET g_errno = ' '
    IF g_obk02 IS NULL THEN
        LET l_occ02 = NULL
    ELSE
        SELECT occ02,occacti INTO l_occ02,l_occacti FROM occ_file   #MOD-7B0197 modify
            WHERE occ01 = g_obk02
        CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                       LET l_occ02 = NULL  LET l_occacti = NULL
             WHEN l_occacti='N' LET g_errno = '9028'
             OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
        DISPLAY l_occ02 TO  occ02 
    END IF
END FUNCTION 
 
#Query 查詢
FUNCTION i151_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_obk02 TO NULL               #No.FUN-6A0020 
 
    CALL cl_opmsg('q')
 
    MESSAGE ""                               
    CLEAR FORM                               
    CALL g_obk.clear()
 
    CALL i151_curs()                         #取得查詢條件
 
    IF INT_FLAG THEN                         #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
 
    OPEN i151_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                    #有問題
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_obk02 TO NULL       
       INITIALIZE g_obk01 TO NULL       
    ELSE
       CALL i151_fetch('F')            #讀出TEMP第一筆並顯示
       OPEN i151_count
       FETCH i151_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i151_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i151_b_curs INTO g_obk02
        WHEN 'P' FETCH PREVIOUS i151_b_curs INTO g_obk02
        WHEN 'F' FETCH FIRST    i151_b_curs INTO g_obk02
        WHEN 'L' FETCH LAST     i151_b_curs INTO g_obk02
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
            FETCH ABSOLUTE g_jump i151_b_curs INTO g_obk02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_obk02,SQLCA.sqlcode,0)
       INITIALIZE g_obk02 TO NULL  #TQC-6B0105
    ELSE
 
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL i151_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i151_show()
 
    DISPLAY g_obk02 TO obk02               #單頭
 
    CALL i151_obk02('d')                   #單頭
 
    CALL i151_b_fill(g_wc)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i151_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_obk02 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6A0020
       RETURN
    END IF
 
    BEGIN WORK
 
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "obk02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_obk02       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM obk_file WHERE obk02 = g_obk02
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","obk_file",g_obk02,"",SQLCA.sqlcode,"","BODY DELETE",1)  #No.FUN-660167
        ELSE
            CLEAR FORM
            CALL g_obk.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i151_count
            #FUN-B50064-add-start--
            IF STATUS THEN
               CLOSE i151_b_curs
               CLOSE i151_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end--
            FETCH i151_count INTO g_row_count
            #FUN-B50064-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i151_b_curs
               CLOSE i151_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i151_b_curs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i151_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i151_fetch('/')
            END IF
        END IF
    END IF
 
    COMMIT WORK
 
END FUNCTION
 
#單身
FUNCTION i151_b()
DEFINE
    l_imaacti       LIKE ima_file.imaacti, #MOD-710048 add
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_obk11         LIKE obk_file.obk11,   #TQC-6A0045
    l_obk12         LIKE obk_file.obk12,   #TQC-6A0045
    l_obk13         LIKE obk_file.obk13,   #TQC-6A0045
    l_obk14         LIKE obk_file.obk14,   #TQC-6A0045
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否          #No.FUN-680137 SMALLINT
    l_obkuser       LIKE obk_file.obkuser,   #MOD-850286
    l_obkgrup       LIKE obk_file.obkgrup,   #MOD-850286
    l_obkacti       LIKE obk_file.obkacti    #MOD-850286
 
    LET g_action_choice = ""
 
    IF cl_null(g_obk02) THEN 
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
       #"SELECT obk01,'','',obk03,obk04,obk05,obk07,obk08,obk09 FROM obk_file ",  #CHI-C60013 mark
        "SELECT obk01,'','',obk03,obk04,obk05,obk07,obk08,obk09, ",               #CHI-C60013
        "       obkuser,obkgrup,obkmodu,obkdate,obkacti FROM obk_file ",          #CHI-C60013
        " WHERE obk02 = ? AND obk01 = ? AND obk05 = ?  FOR UPDATE "  #No.FUN-670099
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i151_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_obk WITHOUT DEFAULTS FROM s_obk.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEn
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK    #MOD-8B0180
            
            IF g_rec_b >= l_ac THEN
 
               LET p_cmd='u'
               LET g_obk_t.* = g_obk[l_ac].*  #BACKUP
 
               OPEN i151_bcl USING g_obk02, g_obk_t.obk01,g_obk_t.obk05   #No.FUN-670099
               IF STATUS THEN
                  CALL cl_err("OPEN i151_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i151_bcl INTO g_obk_t.* 
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_obk_t.obk03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                      LET g_obk_t.*=g_obk[l_ac].*
                      LET g_obk07_t=g_obk[l_ac].obk07  #FUN-910088
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_obk[l_ac].* TO NULL      #900423
           #------CHI-C60013---mark--S--#
           #LET l_obkuser = g_user
           #LET l_obkgrup = g_grup
           #LET l_obkacti = 'Y'
           #------CHI-C60013---mark--E--#
           #------CHI-C60013------#
            LET g_obk[l_ac].obkuser = g_user
            LET g_obk[l_ac].obkgrup = g_grup
            LET g_obk[l_ac].obkdate = g_today
            LET g_obk[l_ac].obkacti = 'Y'
           #------CHI-C60013------#
            LET g_obk_t.* = g_obk[l_ac].*         #新輸入資料
            LET g_obk07_t = NULL              #FUN-910088
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD obk01
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
       LET l_obk11 = 'N'   #MOD-850286
       IF cl_null(g_obk[l_ac].obk01) THEN LET g_obk[l_ac].obk01=' ' END IF
       IF cl_null(g_obk02) THEN LET g_obk02=' ' END IF
       IF cl_null(g_obk[l_ac].obk05) THEN LET g_obk[l_ac].obk05=' ' END IF
            INSERT INTO obk_file(obk02,obk01,obk03,obk04,obk05,obk07,obk08,
                                 obk09,
                                 obk11,obk12,obk13,obk14,  #TQC-6A0045 add
                                #obkuser,obkgrup,obkacti,obkoriu,obkorig)   #MOD-850286   #CHI-C60013 mark  
                                 obkoriu,obkorig,obkuser,obkgrup,obkmodu,obkdate,obkacti) #CHI-C60013
                          VALUES(g_obk02,
                                 g_obk[l_ac].obk01,g_obk[l_ac].obk03,
                                 g_obk[l_ac].obk04,g_obk[l_ac].obk05,
                                 g_obk[l_ac].obk07,g_obk[l_ac].obk08,
                                 g_obk[l_ac].obk09,
                                 l_obk11,l_obk12,l_obk13,l_obk14, #TQC-6A0045 add
                                #l_obkuser,l_obkgrup,l_obkacti, g_user, g_grup)   #MOD-850286      #No.FUN-980030 10/01/04  insert columns oriu, orig  #CHI-C60013 mark
                                 g_user, g_grup,                                               #CHI-C60013
                                 g_obk[l_ac].obkuser,g_obk[l_ac].obkgrup,g_obk[l_ac].obkmodu,  #CHI-C60013
                                 g_obk[l_ac].obkdate,g_obk[l_ac].obkacti)                      #CHI-C60013
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","obk_file",g_obk02,g_obk[l_ac].obk01,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               #DISPLAY g_rec_b TO FORMONLY.cn2    #MOD-8B0180
            END IF
 
        AFTER FIELD obk01 
            IF NOT cl_null(g_obk[l_ac].obk01) THEN 
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_obk[l_ac].obk01,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_obk[l_ac].obk01= g_obk_t.obk01
                  NEXT FIELD  obk01
               END IF
#FUN-AA0059 ---------------------end-------------------------------
               IF cl_null(g_obk[l_ac].obk03) THEN 
                   LET g_obk[l_ac].obk03 = g_obk[l_ac].obk01
                   DISPLAY BY NAME g_obk[l_ac].obk03   #MOD-850108
               END IF
              
               SELECT ima02,ima021,ima31,imaacti    #MOD-710048 modify imaacti
                 INTO g_obk[l_ac].ima02,g_obk[l_ac].ima021,g_obk[l_ac].obk07,
                      l_imaacti   #MOD-710048 add
                 FROM ima_file
                WHERE ima01 = g_obk[l_ac].obk01
               IF STATUS THEN
                  CALL cl_err3("sel","ima_file",g_obk[l_ac].obk01,"",STATUS,"","select ima",1)  #No.FUN-660167
                  NEXT FIELD obk01
               END IF
               IF l_imaacti = 'N' THEN
                  CALL cl_err(g_obk[l_ac].obk01,'axm-890',1)
                  NEXT FIELD obk01
               END IF 
               #FUN-910088-add-str--
               IF NOT i151_obk09_check() THEN 
                  LET g_obk07_t = g_obk[l_ac].obk07
                  NEXT FIELD obk09
               END IF
               LET g_obk07_t = g_obk[l_ac].obk07
               #FUN-910088-add-end--
            END IF
 
        AFTER FIELD obk03
            DISPLAY BY NAME g_obk[l_ac].obk03  
 
        AFTER FIELD obk05
            IF NOT cl_null(g_obk[l_ac].obk05) THEN
               IF cl_null(g_obk_t.obk05) 
                  OR g_obk[l_ac].obk05 != g_obk_t.obk05 THEN 
                  SELECT count(*) INTO l_n FROM obk_file
                   WHERE obk02 = g_obk02 AND obk01 = g_obk[l_ac].obk01
                     AND obk05 = g_obk[l_ac].obk05
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_obk[l_ac].obk05 = g_obk_t.obk05
                     NEXT FIELD obk05
                  END IF
               END IF
               SELECT azi01 FROM azi_file
                   WHERE azi01 = g_obk[l_ac].obk05
               IF STATUS THEN
                   CALL cl_err3("sel","azi_file",g_obk[l_ac].obk05,"",STATUS,"","select azi",1)  #No.FUN-660167
                   NEXT FIELD obk05
               END IF
            END IF
 
        AFTER FIELD obk07
            IF NOT cl_null(g_obk[l_ac].obk07) THEN
               SELECT gfe01 FROM gfe_file
                   WHERE gfe01 = g_obk[l_ac].obk07
               IF STATUS THEN
                   CALL cl_err3("sel","gfe_file",g_obk[l_ac].obk07,"",STATUS,"","select gfe",1)  #No.FUN-660167
                   NEXT FIELD obk07
               END IF
               #FUN-910088-add-str--
               IF NOT i151_obk09_check() THEN 
                  LET g_obk07_t = g_obk[l_ac].obk07
                  NEXT FIELD obk09
               END IF
               LET g_obk07_t = g_obk[l_ac].obk07
               #FUN-910088-add-end--
            END IF
 
        AFTER FIELD obk08
            IF NOT cl_null(g_obk[l_ac].obk08) THEN
               IF g_obk[l_ac].obk08 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD obk08
               END IF
            END IF
 
        AFTER FIELD obk09
            #FUN-910088-mark-str--
            #IF NOT cl_null(g_obk[l_ac].obk09) THEN
            #   IF g_obk[l_ac].obk09 < 0 THEN
            #      CALL cl_err('','aec-020',0)
            #      NEXT FIELD obk09
            #   END IF
            #END IF
            #FUN-910088-mark-end--
            IF NOT i151_obk09_check() THEN NEXT FIELD obk09 END IF   #FUN-910088
 
        BEFORE DELETE                            #是否取消單身
            IF g_obk_t.obk01 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
               
                DELETE FROM obk_file
                 WHERE obk02 = g_obk02 AND obk01 = g_obk_t.obk01
                   AND obk05 = g_obk_t.obk05   #No.FUN-670099
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","obk_file",g_obk_t.obk01,g_obk02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b = g_rec_b -1   #MOD-780239 add
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_obk[l_ac].* = g_obk_t.*
               CLOSE i151_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_obk[l_ac].obk01,-263,1)
               LET g_obk[l_ac].* = g_obk_t.*
            ELSE
               LET g_obk[l_ac].obkmodu=g_user   #CHI-C60013
               LET g_obk[l_ac].obkdate=g_today  #CHI-C60013
               UPDATE obk_file SET obk02=g_obk02,
                                   obk01=g_obk[l_ac].obk01,
                                   obk03=g_obk[l_ac].obk03,
                                   obk04=g_obk[l_ac].obk04,
                                   obk05=g_obk[l_ac].obk05,
                                   obk07=g_obk[l_ac].obk07,
                                   obk08=g_obk[l_ac].obk08,
                                   obk09=g_obk[l_ac].obk09,       #CHI-C60013 add ,
                                   obkmodu=g_obk[l_ac].obkmodu,   #CHI-C60013
                                   obkdate=g_obk[l_ac].obkdate,   #CHI-C60013
                                   obkacti=g_obk[l_ac].obkacti    #CHI-C60013
                WHERE obk02 = g_obk02 
                  AND obk01 = g_obk_t.obk01
                  AND obk05 = g_obk_t.obk05   #No.FUN-670099  
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","obk_file",g_obk02,g_obk_t.obk01,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                 LET g_obk[l_ac].* = g_obk_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
 
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_obk[l_ac].* = g_obk_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_obk.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i151_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i151_bcl
            COMMIT WORK
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(obk01) #產品名稱
#FUN-D50045 ---------- mark ---------- begin -----------------
##FUN-AA0059---------mod------------str----------------              
##                   CALL cl_init_qry_var()
##                   LET g_qryparam.form ="q_ima"
##                   LET g_qryparam.default1 = g_obk[l_ac].obk01
##                   CALL cl_create_qry() RETURNING g_obk[l_ac].obk01
#                   CALL q_sel_ima(FALSE, "q_ima","",g_obk[l_ac].obk01,"","","","","",'' ) 
#                      RETURNING  g_obk[l_ac].obk01
##FUN-AA0059---------mod------------end-----------------
#                   SELECT ima02,ima021,ima31 
#                     INTO g_obk[l_ac].ima02,g_obk[l_ac].ima021,g_obk[l_ac].obk07
#                     FROM ima_file
#                    WHERE ima01 = g_obk[l_ac].obk01
#                   IF STATUS THEN
#                      CALL cl_err3("sel","ima_file",g_obk[l_ac].obk01,"",STATUS,"","select ima",1)  #No.FUN-660167
#                   END IF
#                   DISPLAY BY NAME g_obk[l_ac].obk01,g_obk[l_ac].ima02,g_obk[l_ac].ima021
#                   NEXT FIELD obk01
#FUN-D50045 ---------- mark ---------- end -------------------
#FUN-D50045 ---------- add ----------- begin -----------------
                   CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                   CALL i151_obk01()
                   CALL i151_b_fill(" 1=1")
                   COMMIT WORK
                   LET g_flag = TRUE
                   EXIT INPUT
#FUN-D50045 ---------- add ----------- end -------------------
              WHEN INFIELD(obk05) #幣別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azi"
                   LET g_qryparam.default1 = g_obk[l_ac].obk05
                   CALL cl_create_qry() RETURNING g_obk[l_ac].obk05
                   DISPLAY BY NAME g_obk[l_ac].obk05
                   NEXT FIELD obk05
              WHEN INFIELD(obk07) #銷售單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_obk[l_ac].obk07
                   CALL cl_create_qry() RETURNING g_obk[l_ac].obk07
                   DISPLAY BY NAME g_obk[l_ac].obk07
                   NEXT FIELD obk07
            END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(obk01) AND l_ac > 1 THEN
               LET g_obk[l_ac].* = g_obk[l_ac-1].*
               NEXT FIELD obk01
            END IF
 
        ON ACTION controls                               #No.FUN-6A0092
           CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
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
 
    
    END INPUT

#No.FUN-D50045 --------- add -------- begin ----------------
    IF g_flag THEN
       LET g_flag = FALSE
       CALL i151_b()
    END IF
#No.FUN-D50045 --------- add -------- end ------------------
 
END FUNCTION
   
FUNCTION i151_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    CONSTRUCT g_wc ON obk01,obk03,obk04,obk05,obk07,obk08,obk09    #螢幕上取條件
        FROM s_obk[1].obk01,s_obk[1].obk03,s_obk[1].obk04,s_obk[1].obk05,
             s_obk[1].obk07,s_obk[1].obk08,s_obk[1].obk09 
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
 
    
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 
    CALL i151_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION i151_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680137   VARCHAR(200)
 
    LET g_sql =
               "SELECT obk01,'','',obk03,obk04,obk05,obk07,obk08,obk09,",  #CHI-C60013 add ,
               "       obkuser,obkgrup,obkmodu,obkdate,obkacti ",          #CHI-C60013
               " FROM obk_file ",
               " WHERE obk02 = '",g_obk02,
               "' AND ",p_wc CLIPPED ,
               " ORDER BY obk01,obk03,obk04 "
    PREPARE i151_p2 FROM g_sql      #預備一下
    DECLARE obk_curs CURSOR FOR i151_p2
 
    CALL g_obk.clear()
    LET g_cnt = 1
 
    FOREACH obk_curs INTO g_obk[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT ima02,ima021 
          INTO g_obk[g_cnt].ima02,g_obk[g_cnt].ima021 FROM ima_file
         WHERE ima01 = g_obk[g_cnt].obk01
        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     
    END FOREACH
    CALL g_obk.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1               #告訴I.單身筆數
 
END FUNCTION
 
FUNCTION i151_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_obk TO s_obk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL i151_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i151_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL i151_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i151_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL i151_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
   
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i151_out()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680137 SMALLINT
    sr              RECORD
        obk02       LIKE obk_file.obk02,   #客戶編號
        occ02       LIKE occ_file.occ02,   #客戶簡稱
        obk01       LIKE obk_file.obk01,   #產品編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格
        obk03       LIKE obk_file.obk03,   #客戶的產品編號
        obk04       LIKE obk_file.obk04,   #最近訂單日
        obk05       LIKE obk_file.obk05,   #最近訂單幣別
        obk07       LIKE obk_file.obk07,   #最近訂單銷售單位
        obk08       LIKE obk_file.obk08,   #最近訂單單價
        obk09       LIKE obk_file.obk09    #最近訂單數量
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680137 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #No.FUN-680137 VARCHAR(40)
 
  DEFINE  l_ima02a,l_ima02b LIKE ima_file.ima02
  DEFINE  l_ima021a,l_ima021b LIKE ima_file.ima021
  
  LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?)"
  PREPARE insert_prep FROM l_sql
  IF STATUS THEN 
     CALL cl_err('insert_prep:',STATUS,1)  
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
     EXIT PROGRAM
  END IF
  
  LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?) "
  PREPARE insert_prep1 FROM l_sql
  IF STATUS THEN 
     CALL cl_err('insert_prep1:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
     EXIT PROGRAM
  END IF
  
  CALL cl_del_data(l_table)
  CALL cl_del_data(l_table1)
 
    IF not cl_null(g_argv1) THEN 
        LET g_wc = " obk02 ='",g_argv1,"'" CLIPPED
    END IF
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmi151'  #No.FUN-840019    
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql= "SELECT UNIQUE obk02 FROM obk_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY obk02 "
    PREPARE i151_p1 FROM g_sql                # RUNTIME 編譯
    IF SQLCA.sqlcode THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,0) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM  
    END IF
    DECLARE i151_co                         # CURSOR
        CURSOR FOR i151_p1
 
    FOREACH i151_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
            DECLARE obk02_curs CURSOR FOR   
                SELECT obk01,obk03,obk04,obk05,obk07,obk08,obk09  FROM obk_file
                    WHERE obk02 = sr.obk02
            FOREACH obk02_curs INTO  sr.obk01,sr.obk03,sr.obk04,sr.obk05,sr.obk07,sr.obk08,sr.obk09
            #no.4560 依幣別取位
            SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
             WHERE azi01 = sr.obk05
            SELECT ima02,ima021 INTO l_ima02a,l_ima021a FROM ima_file 
                WHERE ima01=sr.obk01
            IF SQLCA.sqlcode THEN 
                LET l_ima02a = NULL 
                LET l_ima021a = NULL 
            END IF
            SELECT ima02,ima021 INTO l_ima02b,l_ima021b FROM ima_file 
                WHERE ima01=sr.obk03
            IF SQLCA.sqlcode THEN 
                LET l_ima02b = NULL 
                LET l_ima021b = NULL 
            END IF
            EXECUTE insert_prep1 USING
                 sr.obk02,sr.obk01,l_ima02a,l_ima021a,sr.obk03,l_ima02b,
                 l_ima021b,sr.obk04,sr.obk05,sr.obk07,sr.obk08,sr.obk09,t_azi03
            END FOREACH  
       SELECT occ02 INTO sr.occ02 FROM occ_file
           WHERE occ01 = sr.obk02 
       EXECUTE insert_prep USING
              sr.obk02,sr.occ02                   
    END FOREACH
 
    CLOSE i151_co
    ERROR ""
    
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
                
    IF g_zz05 = 'Y' THEN 
       CALL cl_wcchp(g_wc,'obk02,obk01,obk03,obk04,obk05,obk07,obk08,obk09')
            RETURNING g_str
    END IF
    
    CALL cl_prt_cs3('axmi151','axmi151',l_sql,g_str)            
END FUNCTION

#FUN-910088-add-str--
FUNCTION i151_obk09_check()
   IF NOT cl_null(g_obk[l_ac].obk07) AND NOT cl_null(g_obk[l_ac].obk09) THEN 
      IF cl_null(g_obk_t.obk09) OR cl_null(g_obk07_t) OR g_obk_t.obk09 != g_obk[l_ac].obk09 OR g_obk07_t != g_obk[l_ac].obk07 THEN 
         LET g_obk[l_ac].obk09 = s_digqty(g_obk[l_ac].obk09,g_obk[l_ac].obk07)
         DISPLAY BY NAME g_obk[l_ac].obk09
      END IF
   END IF
   IF NOT cl_null(g_obk[l_ac].obk09) THEN
      IF g_obk[l_ac].obk09 < 0 THEN
         CALL cl_err('','aec-020',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-910088-add-end--
#No:FUN-9C0071--------精簡程式-----

#NO.FUN-D50045 ---------- add --------------- begin --------------
FUNCTION i151_obk01()
   DEFINE l_obk     RECORD LIKE obk_file.*
   DEFINE tok       base.StringTokenizer

   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_qryparam.multiret,"|")
   WHILE tok.hasMoreTokens()
      LET l_obk.obk01 = tok.nextToken()
      LET l_obk.obk02 = g_obk02
     #LET l_obk.obk03 = tok.nextToken()    #FUN-D50045 mark
      LET l_obk.obk03 = l_obk.obk01
      LET l_obk.obk04 = g_today
      SELECT ima31 INTO l_obk.obk07 FROM ima_file WHERE ima01 = l_obk.obk01
      SELECT occ42 INTO l_obk.obk05 FROM occ_file WHERE occ01 = l_obk.obk02
      IF cl_null(l_obk.obk05) THEN
         CALL s_errmsg('obk01',l_obk.obk01,'INS obk_file','afa-111',1)
         CONTINUE WHILE
      END IF
      LET l_obk.obk08 = 0
      LET l_obk.obk09 = 0
      LET l_obk.obk11 = 'N'
      LET l_obk.obkuser = g_user
      LET l_obk.obkgrup = g_grup
      LET l_obk.obkdate = g_today
      LET l_obk.obkacti = 'Y'
      INSERT INTO obk_file VALUES(l_obk.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('obk01',l_obk.obk01,'INS obk_file',SQLCA.sqlcode,1)
         CONTINUE WHILE
      END IF
   END WHILE
   CALL s_showmsg()
END FUNCTION
#NO.FUN-D50045 ---------- add --------------- end ----------------
