# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi010.4gl
# Descriptions...: 預算BOM資料維護作業
# Date & Author..: 02/09/18 By qazzaq
# Modi...........: ching  031028 No.8563 單位換算 # C和g和o
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: NO.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin放寬ima02
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0067 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.FUN-510025 05/01/14 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530239 05/03/24 By Smapmin 單身欄位對應錯誤,篩選功能畫面是英文的
#                                                    單身顯示有誤
# Modify.........: No.MOD-560121 05/06/19 By Mandy 按篩選未能按所KEY IN的主件品號產生資料
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.FUN-5B0013 05/11/01 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-5B0107 05/11/12 By Pengu 報表料件、品名、規格之格式調整
# Modify.........: No.TQC-630053 06/03/07 By Smapmin 產品別/品號開窗要開oba_file
# Modify.........: NO.TQC-630273 06/03/30 by yiting 篩選鍵按多次時，組成用量會一直累加
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0003 06/10/14 By jamie 1.FUNCTION i010()_q 一開始應清空g_bgg.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 g_no_ask
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760066 07/06/08 By chenl   1.按鈕代號應具有一定意義。
# Modify.........:                                   2.報表修改 
# Modify.........: No.FUN-770033 07/07/12 By destiny 報表改為使用crystal report 
# Modify.........: No.TQC-7A0089 07/10/22 By Nicole 報表mark方式調整
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-850038 08/05/13 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-840036 08/07/14 By dxfwo DISPLAY ARRAY的屬性中漏了UNBUFFERED，
#                                                  導致數據沒有及時顯示                        
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
# Modify.........: No.FUN-980001 09/08/05 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980117 09/08/18 By liuxqa 調整原有BUG。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0140 09/10/27 By liuxqa 修改ROWID.
# Modify.........: No:FUN-9C0077 09/12/15 By baofei 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/22 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B30211 11/03/30 By yangtingting 未加離開前得cl_used(2)
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/14 By yuhuabao 離開單身時候單身無資料則提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面
# Modify.........: No:MOD-D30217 13/03/27 By Alberti 取消 DELETE FROM bgh_file 的 IF SQLCA.SQLERRD[3]=0 THEN
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
   new_ver          LIKE bgm_file.bgm01,       #NO.FUN-680061 VARCHAR(10)
    g_bgg           RECORD LIKE bgg_file.*,    #主件料件(假單頭)
    g_bgg_t         RECORD LIKE bgg_file.*,    #主件料件(舊值)
    g_bgg_o         RECORD LIKE bgg_file.*,    #主件料件(舊值)
    g_bgg01_t       LIKE bgg_file.bgg01,       #(舊值)
    g_bgg02_t       LIKE bgg_file.bgg02,       #(舊值)
    g_bgh11_fac     LIKE bgh_file.bgh11_fac,   #(舊值)
    g_bgh11_fac_t   LIKE bgh_file.bgh11_fac,   #(舊值)
    g_bgh11_fac_o   LIKE bgh_file.bgh11_fac,   #(舊值)
    g_bgh           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    bgh03    LIKE bgh_file.bgh03,       #元件項次
                    bgh04    LIKE bgh_file.bgh04,       #元件料件
                    ima02_b  LIKE ima_file.ima02,       #品名
                     ima021_b LIKE ima_file.ima021,     #規格       #MOD-530239
                    bgh11    LIKE bgh_file.bgh11,       #單位
                    bgh06    LIKE bgh_file.bgh06,       #組成用量
                     #ima021_b LIKE ima_file.ima021,    #規格       #MOD-530239
                    bgh07    LIKE bgh_file.bgh07,       #底數
                    bgh08    LIKE bgh_file.bgh08,       #損耗率
                    #FUN-850038 --start---
                    bghud01  LIKE bgh_file.bghud01,
                    bghud02  LIKE bgh_file.bghud02,
                    bghud03  LIKE bgh_file.bghud03,
                    bghud04  LIKE bgh_file.bghud04,
                    bghud05  LIKE bgh_file.bghud05,
                    bghud06  LIKE bgh_file.bghud06,
                    bghud07  LIKE bgh_file.bghud07,
                    bghud08  LIKE bgh_file.bghud08,
                    bghud09  LIKE bgh_file.bghud09,
                    bghud10  LIKE bgh_file.bghud10,
                    bghud11  LIKE bgh_file.bghud11,
                    bghud12  LIKE bgh_file.bghud12,
                    bghud13  LIKE bgh_file.bghud13,
                    bghud14  LIKE bgh_file.bghud14,
                    bghud15  LIKE bgh_file.bghud15
                    #FUN-850038 --end--
                    END RECORD,
    g_bgh_t         RECORD                              #程式變數(舊值)
                    bgh03    LIKE bgh_file.bgh03,       #元件項次
                    bgh04    LIKE bgh_file.bgh04,       #元件料件
                    ima02_b  LIKE ima_file.ima02,       #品名
                     ima021_b LIKE ima_file.ima021,     #規格        #MOD-530239
                    bgh11    LIKE bgh_file.bgh11,       #單位
                    bgh06    LIKE bgh_file.bgh06,       #組成用量
                    #ima021_b LIKE ima_file.ima021,     #規格       #MOD-530239
                    bgh07    LIKE bgh_file.bgh07,       #底數
                    bgh08    LIKE bgh_file.bgh08,       #損耗率
                    #FUN-850038 --start---
                    bghud01  LIKE bgh_file.bghud01,
                    bghud02  LIKE bgh_file.bghud02,
                    bghud03  LIKE bgh_file.bghud03,
                    bghud04  LIKE bgh_file.bghud04,
                    bghud05  LIKE bgh_file.bghud05,
                    bghud06  LIKE bgh_file.bghud06,
                    bghud07  LIKE bgh_file.bghud07,
                    bghud08  LIKE bgh_file.bghud08,
                    bghud09  LIKE bgh_file.bghud09,
                    bghud10  LIKE bgh_file.bghud10,
                    bghud11  LIKE bgh_file.bghud11,
                    bghud12  LIKE bgh_file.bghud12,
                    bghud13  LIKE bgh_file.bghud13,
                    bghud14  LIKE bgh_file.bghud14,
                    bghud15  LIKE bgh_file.bghud15
                    #FUN-850038 --end--
                    END RECORD,
    g_bgh_o         RECORD                              #程式變數(舊值)
                    bgh03    LIKE bgh_file.bgh03,       #元件項次
                    bgh04    LIKE bgh_file.bgh04,       #元件料件
                    ima02_b  LIKE ima_file.ima02,       #品名
                    ima021_b LIKE ima_file.ima021,      #規格         #MOD-530239
                    bgh11    LIKE bgh_file.bgh11,       #單位
                    bgh06    LIKE bgh_file.bgh06,       #組成用量
                   #ima021_b LIKE ima_file.ima021,      #規格       #MOD-530239
                    bgh07    LIKE bgh_file.bgh07,       #底數
                    bgh08    LIKE bgh_file.bgh08,       #損耗率
                    #FUN-850038 --start---
                    bghud01  LIKE bgh_file.bghud01,
                    bghud02  LIKE bgh_file.bghud02,
                    bghud03  LIKE bgh_file.bghud03,
                    bghud04  LIKE bgh_file.bghud04,
                    bghud05  LIKE bgh_file.bghud05,
                    bghud06  LIKE bgh_file.bghud06,
                    bghud07  LIKE bgh_file.bghud07,
                    bghud08  LIKE bgh_file.bghud08,
                    bghud09  LIKE bgh_file.bghud09,
                    bghud10  LIKE bgh_file.bghud10,
                    bghud11  LIKE bgh_file.bghud11,
                    bghud12  LIKE bgh_file.bghud12,
                    bghud13  LIKE bgh_file.bghud13,
                    bghud14  LIKE bgh_file.bghud14,
                    bghud15  LIKE bgh_file.bghud15
                    #FUN-850038 --end--
                    END RECORD,
    g_ima01         LIKE  ima_file.ima01,
    g_oba01         LIKE  oba_file.oba01,
    g_sql           STRING,    #TQC-630166
    g_wc,g_wc2      STRING,    #TQC-630166
    g_vdate         LIKE type_file.dat,           #NO.FUN-680061 DATE
    g_sw            LIKE type_file.num5,          #單位是否可轉換 #FUN-680061 SMALLINT
    g_cmd           LIKE type_file.chr1000,       #No.FUN-680061 VARCHAR(60)
    g_aflag         LIKE type_file.chr1,          #No.FUN-680061 VARCHAR(01)
    g_modify_flag   LIKE type_file.chr1,          #No.FUN-680061 VARCHAR(01)
    g_rec_b         LIKE type_file.num5,          #單身筆數    #No.FUN-680061 SMALLINT
    l_ac            LIKE type_file.num5,          #目前處理的ARRAY CNT  #No.FUN-680061 SMALLINT
    vdate           LIKE type_file.dat            #NO.FUN-680061 DATE
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-680061 SMALLINT
DEFINE g_forupd_sql   STRING                      #SELECT ... FOR UPDATE SQL
DEFINE g_cnt          LIKE type_file.num10        #No.FUN-680061 INTEGER
DEFINE g_chr          LIKE type_file.chr1         #No.FUN-680061 VARCHAR(01)
DEFINE g_i            LIKE type_file.num5         #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE g_msg          LIKE ze_file.ze03           #No.FUN-680061 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10        #No.FUN-680061 INTEGER
DEFINE g_curs_index   LIKE type_file.num10        #No.FUN-680061 INTEGER
DEFINE g_jump         LIKE type_file.num10        #No.FUN-680061 INTEGER
DEFINE g_no_ask       LIKE type_file.num5         #No.FUN-680061 SMALLINT  #No.FUN-6A0057 g_no_ask 
DEFINE l_table        STRING                      #No.FUN-770033
DEFINE l_sql          STRING                      #No.FUN-770033
DEFINE g_str          STRING                      #No.FUN-770033
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABG")) THEN
       EXIT PROGRAM
    END IF
 

    LET g_sql= "bgg01.bgg_file.bgg01,",
               "bgg02.bgg_file.bgg02,",
               "l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima021,",
               "l_ima55.ima_file.ima55,",
               "bgh03.bgh_file.bgh03,",
               "bgh04.bgh_file.bgh04,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "bgh11.bgh_file.bgh11,",
               "bgh06.bgh_file.bgh06,",
               "bgh07.bgh_file.bgh07,",
               "bgh08.bgh_file.bgh08"
 
    LET l_table= cl_prt_temptable('abgi010',g_sql) CLIPPED
    IF l_table= -1 THEN EXIT PROGRAM END IF 
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)" 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep',status,-1)
    END IF

    
    LET g_wc2=' 1=1'
    SELECT sma19 INTO g_sma.sma19 FROM sma_file
 
    LET g_forupd_sql = "SELECT * FROM bgg_file WHERE bgg01 = ? AND bgg02 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i010_curl CURSOR FROM g_forupd_sql
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0056
 
    OPEN WINDOW i010_w WITH FORM "abg/42f/abgi010"
         ATTRIBUTE(STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    CALL i010_menu()
    CLOSE WINDOW i010_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0056
 
END MAIN
 
#QBE 查詢資料
FUNCTION i010_curs()
DEFINE  lc_qbe_sn  LIKE gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE l_flag      LIKE type_file.chr1    #判斷單身是否給條件 #No.FUN-680061 VARCHAR(01)
 
    CLEAR FORM                                #清除畫面
    CALL g_bgh.clear()
    LET l_flag = 'N'
    LET g_vdate = g_today
    CALL cl_set_head_visible("","YES")        #No.FUN-6B0033
   INITIALIZE g_bgg.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                 # 螢幕上取單頭條件
        bgg01,bgg02,bgg06,bgg07,bgguser,bgggrup,bggmodu,bggdate,bggacti,    #No.TQC-980117 mod
        bggud01,bggud02,bggud03,bggud04,bggud05,
        bggud06,bggud07,bggud08,bggud09,bggud10,
        bggud11,bggud12,bggud13,bggud14,bggud15

               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
              
        ON ACTION CONTROLP     #查詢條件
            CASE
               WHEN INFIELD(bgg02) #料件主檔
   #FUN-AA0059 --Begin--      
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state = "c"
               #   LET g_qryparam.form ="q_ima"   
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima( TRUE,"q_ima", "", "", "", "", "", "" ,"",'' ) RETURNING g_qryparam.multiret
   #FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO bgg02
               WHEN INFIELD(bgg06) #料件主檔
   #FUN-AA0059 --Begin-- 
   #               CALL cl_init_qry_var()
   #               LET g_qryparam.state = "c"
   #               LET g_qryparam.form ="q_ima"
   #               CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
   #FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO bgg06
               OTHERWISE EXIT CASE
             END CASE
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
    
     ON ACTION CONTROLE
        IF INFIELD(bgg02) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.state = "c"
           LET g_qryparam.form ="q_oba"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO bgg02
        END IF
    
 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
	
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
	
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF

    CONSTRUCT g_wc2 ON bgh03,bgh04,bgh11,bgh06,bgh07,bgh08
                       #No.FUN-850038 --start--
                       ,bghud01,bghud02,bghud03,bghud04,bghud05
                       ,bghud06,bghud07,bghud08,bghud09,bghud10
                       ,bghud11,bghud12,bghud13,bghud14,bghud15
                       #No.FUN-850038 ---end---
         FROM s_bgh[1].bgh03,s_bgh[1].bgh04,
              s_bgh[1].bgh11,
              s_bgh[1].bgh06,
              s_bgh[1].bgh07,s_bgh[1].bgh08
              #No.FUN-850038 --start--
              ,s_bgh[1].bghud01,s_bgh[1].bghud02,s_bgh[1].bghud03
              ,s_bgh[1].bghud04,s_bgh[1].bghud05,s_bgh[1].bghud06
              ,s_bgh[1].bghud07,s_bgh[1].bghud08,s_bgh[1].bghud09
              ,s_bgh[1].bghud10,s_bgh[1].bghud11,s_bgh[1].bghud12
              ,s_bgh[1].bghud13,s_bgh[1].bghud14,s_bgh[1].bghud15
              #No.FUN-850038 ---end---

		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)

     ON ACTION CONTROLP
           CASE WHEN INFIELD(bgh04) #料件主檔
           #FUN-AA0059 --Begin--
           #       CALL cl_init_qry_var()
           #       LET g_qryparam.state = "c"
           #       LET g_qryparam.form ="q_ima"
           #       CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
           #FUN-AA0059 --End--  
                  DISPLAY g_qryparam.multiret TO s_bgh[1].bgh04
                WHEN INFIELD(bgh11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gfe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_bgh[1].bgh11
               OTHERWISE EXIT CASE
           END  CASE
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 

                    ON ACTION qbe_save
		       CALL cl_qbe_save()

    END CONSTRUCT
    IF g_wc2 != " 1=1" THEN LET l_flag = 'Y' END IF
    IF INT_FLAG THEN RETURN END IF
    IF l_flag = 'N' THEN			# 若單身未輸入條件
       LET g_sql = "SELECT bgg01,bgg02 FROM bgg_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY bgg01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT bgg01,bgg02 ",
                   "  FROM bgg_file, bgh_file ",
                   " WHERE bgg01 = bgh01",
                   "   AND bgg02 = bgh02",
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
                   " ORDER BY bgg01"
    END IF
 
    PREPARE i010_prepare FROM g_sql
	DECLARE i010_curs
        SCROLL CURSOR WITH HOLD FOR i010_prepare
 
    IF l_flag = 'N' THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM bgg_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM bgg_file,bgh_file WHERE ",
                  "bgh01=bgg01 AND bgh02=bgg02 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i010_precount FROM g_sql
    DECLARE i010_count CURSOR FOR i010_precount
END FUNCTION
 
FUNCTION i010_menu()
   WHILE TRUE
      CALL i010_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i010_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i010_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i010_r()
           END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i010_copy()
            END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i010_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i010_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "invalid"
           IF cl_chk_act_auth() THEN
              CALL i010_x()
           END IF

        WHEN "date_produce"
           IF cl_chk_act_auth() THEN
              CALL i010_g()
           END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL i010_out()
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        WHEN "exporttoexcel"   #No.FUN-4B0021
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgh),'','')
           END IF

        WHEN "related_document"           #相關文件
         IF cl_chk_act_auth() THEN
            IF g_bgg.bgg01 IS NOT NULL THEN
               LET g_doc.column1 = "bgg01"
               LET g_doc.column2 = "bgg02"
               LET g_doc.value1 = g_bgg.bgg01
               LET g_doc.value2 = g_bgg.bgg02
               CALL cl_doc()
            END IF 
         END IF
       
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i010_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_bgh.clear()
    INITIALIZE g_bgg.* LIKE bgg_file.*             #DEFAULT 設定
    LET g_bgg01_t = NULL
    LET g_bgg02_t = NULL
    #預設值及將數值類變數清成零
    LET g_bgg_t.* = g_bgg.*
    LET g_bgg_o.* = g_bgg.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_bgg.bgguser=g_user
        LET g_bgg.bggoriu = g_user #FUN-980030
        LET g_bgg.bggorig = g_grup #FUN-980030
        LET g_bgg.bgggrup=g_grup
        LET g_bgg.bggdate=g_today
        LET g_bgg.bggacti='Y'              #資料有效
        CALL i010_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_bgg.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF cl_null(g_bgg.bgg02) THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO bgg_file VALUES (g_bgg.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功

            CALL cl_err3("ins","bgg_file",g_bgg.bgg01,g_bgg.bgg02,SQLCA.sqlcode,"","",1) #FUN-660105
            CONTINUE WHILE
        END IF
        LET g_bgg01_t = g_bgg.bgg01        #保留舊值
        LET g_bgg02_t = g_bgg.bgg02        #保留舊值
        LET g_bgg_t.* = g_bgg.*
        CALL g_bgh.clear()
        LET g_rec_b=0
        CALL i010_b()                   #輸入單身
        LET g_wc="     bgg01='",g_bgg.bgg01,"' ",
                 " AND bgg02='",g_bgg.bgg02,"' "
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i010_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_bgg.bgg02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_bgg.bggacti ='N' THEN    #資料若為無效,仍可更改.
       CALL cl_err(g_bgg.bgg01,'mfg1000',0) RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bgg01_t = g_bgg.bgg01
    LET g_bgg02_t = g_bgg.bgg02
    BEGIN WORK
    OPEN i010_curl USING g_bgg.bgg01,g_bgg.bgg02
    IF STATUS THEN
       CALL cl_err("OPEN i010_curl:", STATUS, 1)
       CLOSE i010_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_curl INTO g_bgg.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bgg.bgg01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i010_curl
        RETURN
    END IF
    CALL i010_show()
    WHILE TRUE
        LET g_bgg_t.* = g_bgg.*
        LET g_bgg_o.* = g_bgg.*
        LET g_bgg01_t = g_bgg.bgg01
        LET g_bgg02_t = g_bgg.bgg02
        LET g_bgg.bggmodu=g_user
        LET g_bgg.bggdate=g_today
        CALL i010_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bgg.*=g_bgg_t.*
            CALL i010_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_bgg.bgg01 != g_bgg01_t OR g_bgg.bgg02 != g_bgg02_t THEN # 更改KEY
           UPDATE bgh_file SET bgh01 = g_bgg.bgg01,
                               bgh02 = g_bgg.bgg02
                WHERE bgh01 = g_bgg01_t
                  AND bgh02 = g_bgg02_t
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","bgh_file",g_bgg01_t,g_bgg02_t,SQLCA.sqlcode,"","bgh",1) #FUN-660105
              CONTINUE WHILE
           END IF
        END IF
        UPDATE bgg_file SET bgg_file.* = g_bgg.*
         WHERE bgg01=g_bgg01_t AND bgg02=g_bgg02_t
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","bgg_file",g_bgg01_t,g_bgg02_t,SQLCA.sqlcode,"","",1) #FUN-660105
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i010_curl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i010_i(p_cmd)
DEFINE
    p_cmd   LIKE type_file.chr1,    #a:輸入 u:更改 #No.FUN-680061 VARCHAR(01)
    l_cmd   LIKE type_file.chr50    #No.FUN-680061 VARCHAR(40)
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
    DISPLAY BY NAME g_bgg.bgguser,g_bgg.bggmodu,
                    g_bgg.bgggrup,g_bgg.bggdate,g_bgg.bggacti    #No.TQC-980117 mod
 
    INPUT BY NAME g_bgg.bgg01,g_bgg.bgg02,g_bgg.bgg06,g_bgg.bgg07,  g_bgg.bggoriu,g_bgg.bggorig,
                  #FUN-850038     ---start---
                  g_bgg.bggud01,g_bgg.bggud02,g_bgg.bggud03,g_bgg.bggud04,
                  g_bgg.bggud05,g_bgg.bggud06,g_bgg.bggud07,g_bgg.bggud08,
                  g_bgg.bggud09,g_bgg.bggud10,g_bgg.bggud11,g_bgg.bggud12,
                  g_bgg.bggud13,g_bgg.bggud14,g_bgg.bggud15 
                  #FUN-850038     ----end----
                  WITHOUT DEFAULTS HELP 1
 
        BEFORE FIELD bgg01
            IF p_cmd = 'u' AND g_chkey matches'[Nn]' THEN
               RETURN
            END IF
        AFTER FIELD bgg01
            IF cl_null(g_bgg.bgg01) THEN LET g_bgg.bgg01=' ' END IF
 
        AFTER FIELD bgg02                         #產品別
          IF NOT cl_null(g_bgg.bgg02) THEN
            #FUN-AA0059 ---------------------add start----------------------
            IF NOT s_chk_item_no(g_bgg.bgg02,'') THEN
               CALL cl_err('',g_errno,1)
               LET g_bgg.bgg01 = g_bgg01_t
               LET g_bgg.bgg02 = g_bgg02_t
               NEXT FIELD bgg02
            END IF 
            #FUN-AA0059 ---------------------add end-------------------
            IF g_bgg.bgg02 != g_bgg02_t OR cl_null(g_bgg02_t) THEN
               SELECT count(*) INTO g_cnt FROM bgg_file
                WHERE bgg01 = g_bgg.bgg01
                  AND bgg02 = g_bgg.bgg02
               IF g_cnt > 0 THEN   #資料重複
                  CALL cl_err(g_bgg.bgg01,-239,0)
                  LET g_bgg.bgg01 = g_bgg01_t
                  LET g_bgg.bgg02 = g_bgg02_t
                  DISPLAY BY NAME g_bgg.bgg01,g_bgg.bgg02
                  NEXT FIELD bgg02
               END IF
            END IF
            CALL i010_bgg02('a')
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err(g_bgg.bgg01,g_errno,0)
               LET g_bgg.bgg01 = g_bgg_o.bgg01
               LET g_bgg.bgg02 = g_bgg_o.bgg02
               DISPLAY BY NAME g_bgg.bgg01,g_bgg.bgg02
               NEXT FIELD bgg02
            END IF
            IF cl_null(g_bgg.bgg07) THEN
               SELECT ima58 INTO g_bgg.bgg07 FROM ima_file
                WHERE ima01=g_bgg.bgg02
               DISPLAY BY NAME g_bgg.bgg07
            END IF
          END IF
 
        AFTER FIELD bgg06
            #FUN-AA0059 -------------------add start----------------------
            IF NOT cl_null(g_bgg.bgg06) THEN
               IF NOT s_chk_item_no(g_bgg.bgg06,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_bgg.bgg06 = g_bgg_o.bgg06
                  DISPLAY BY NAME g_bgg.bgg06
                  NEXT FIELD bgg06
                END IF
            END IF 
            #FUN-AA0059 -------------------add end----------------------------        
            SELECT COUNT(*) INTO g_cnt FROM ima_file
             WHERE ima01=g_bgg.bgg02
            IF g_cnt=0 AND  cl_null(g_bgg.bgg06) THEN
                NEXT FIELD bgg06
            END IF
            IF NOT cl_null(g_bgg.bgg06) THEN
              CALL i010_bgg06('a')
              IF NOT cl_null(g_errno)  THEN
                 CALL cl_err(g_bgg.bgg06,g_errno,0)
                 LET g_bgg.bgg06 = g_bgg_o.bgg06
                 DISPLAY BY NAME g_bgg.bgg06
                 NEXT FIELD bgg06
              END IF
            END IF
            IF cl_null(g_bgg.bgg07) THEN
               SELECT ima58 INTO g_bgg.bgg07 FROM ima_file
                WHERE ima01=g_bgg.bgg02
               DISPLAY BY NAME g_bgg.bgg07
            END IF
 

        AFTER FIELD bggud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bggud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bggud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bggud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bggud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bggud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bggud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bggud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bggud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bggud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bggud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bggud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bggud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bggud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bggud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

 
        AFTER INPUT
           LET g_bgg.bgguser = s_get_data_owner("bgg_file") #FUN-C10039
           LET g_bgg.bgggrup = s_get_data_group("bgg_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP     #查詢條件
            CASE
               WHEN INFIELD(bgg02) #料件主檔
#FUN-AA0059 --Begin--
              #    CALL cl_init_qry_var()
              #    LET g_qryparam.form ="q_ima"  
              #    LET g_qryparam.default1=g_bgg.bgg02
              #    CALL cl_create_qry() RETURNING g_bgg.bgg02
                  CALL q_sel_ima( FALSE, "q_ima","",g_bgg.bgg02,"","","","","",'')  RETURNING  g_bgg.bgg02
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_bgg.bgg02
                  NEXT FIELD bgg02
               WHEN INFIELD(bgg06) #料件主檔
#FUN-AA0059 --Begin--               
              #    CALL cl_init_qry_var()
              #    LET g_qryparam.form ="q_ima"
              #    LET g_qryparam.default1=g_bgg.bgg06
              #    CALL cl_create_qry() RETURNING g_bgg.bgg06
                  CALL q_sel_ima(FALSE, "q_ima", "",  g_bgg.bgg06, "", "", "", "" ,"",'' ) 
                                RETURNING g_bgg.bgg06
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_bgg.bgg06
                  NEXT FIELD bgg06
               OTHERWISE EXIT CASE
             END CASE
        ON ACTION CONTROLE     #查詢條件
            CASE
               WHEN INFIELD(bgg02) #產品分類
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_oba"
                  LET g_qryparam.default1 = g_bgg.bgg02
                  CALL cl_create_qry() RETURNING g_bgg.bgg02
                  DISPLAY BY NAME g_bgg.bgg02
                  NEXT FIELD bgg02
               OTHERWISE EXIT CASE
             END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
END FUNCTION
 
FUNCTION i010_bgg02(p_cmd)  #主件料件
    DEFINE p_cmd     LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima55   LIKE ima_file.ima55,
           l_imaacti LIKE ima_file.imaacti,
           l_oba02   LIKE oba_file.oba02
 
    LET g_errno = ' '
    LET l_ima02=''
    LET l_ima021=''
    LET l_ima55=''
    SELECT  ima02,ima021,ima55,imaacti
      INTO  l_ima02,l_ima021,l_ima55,l_imaacti
      FROM  ima_file
     WHERE  ima01 = g_bgg.bgg02
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2602'
                            LET l_ima02 = NULL LET l_ima021 = NULL
                            LET l_ima55 = NULL LET l_imaacti= NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(g_errno) THEN
       SELECT oba02 INTO l_ima02 FROM oba_file WHERE oba01 = g_bgg.bgg02
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2602'
                            LET l_ima02 = NULL
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       SELECT ima55 INTO l_ima55 FROM ima_file
        WHERE ima01=g_bgg.bgg06
    END IF
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02   TO FORMONLY.ima02
       DISPLAY l_ima021  TO FORMONLY.ima021
       DISPLAY l_ima55   TO FORMONLY.ima55
    END IF
END FUNCTION
 
FUNCTION i010_bgg06(p_cmd)                  #主件料件
    DEFINE p_cmd     LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima55   LIKE ima_file.ima55,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    LET l_ima02=''
    LET l_ima021=''
    LET l_ima55=''
    SELECT  ima02,ima021,ima55,imaacti
      INTO  l_ima02,l_ima021,l_ima55,l_imaacti
      FROM  ima_file
     WHERE  ima01 = g_bgg.bgg06
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2602'
                            LET l_ima02 = NULL LET l_ima021 = NULL
                            LET l_ima55 = NULL LET l_imaacti= NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'    LET g_errno = '9038'   #No.FUN-690022
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
#Query 查詢
FUNCTION i010_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bgg.* TO NULL             #No.FUN-6A0003   
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_bgh.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL cl_getmsg('mfg2618',g_lang) RETURNING g_msg
    CALL i010_curs()
    IF INT_FLAG THEN
        INITIALIZE g_bgg.* TO NULL
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! " #ATTRIBUTE(REVERSE)
    OPEN i010_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bgg.* TO NULL
    ELSE
        OPEN i010_count
        FETCH i010_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i010_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE " "
END FUNCTION
 
FUNCTION i010_fetch(p_flag)
DEFINE
    p_flag   LIKE type_file.chr1   #處理方式 #No.FUN-680061 VARCHAR(01)
 
    CASE p_flag
      WHEN 'N' FETCH NEXT     i010_curs INTO g_bgg.bgg01,g_bgg.bgg02
      WHEN 'P' FETCH PREVIOUS i010_curs INTO g_bgg.bgg01,g_bgg.bgg02
      WHEN 'F' FETCH FIRST    i010_curs INTO g_bgg.bgg01,g_bgg.bgg02
      WHEN 'L' FETCH LAST     i010_curs INTO g_bgg.bgg01,g_bgg.bgg02
      WHEN '/'
         IF (NOT g_no_ask) THEN     #No.FUN-6A0057 g_no_ask 
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
         FETCH ABSOLUTE g_jump i010_curs INTO g_bgg.bgg01,
                                              g_bgg.bgg02
         LET g_no_ask = FALSE            #No.FUN-6A0057 g_no_ask 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bgg.bgg01,SQLCA.sqlcode,0)
        INITIALIZE g_bgg.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_bgg.* FROM bgg_file WHERE bgg01 = g_bgg.bgg01 AND bgg02 = g_bgg.bgg02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","bgg_file",g_bgg.bgg01,g_bgg.bgg02,SQLCA.sqlcode,"","",1) #FUN-660105
        INITIALIZE g_bgg.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_bgg.bgguser   #FUN-4C0067
    LET g_data_group = g_bgg.bgggrup   #FUN-4C0067
    CALL i010_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i010_show()
    LET g_bgg_t.* = g_bgg.*                #保存單頭舊值
    DISPLAY BY NAME g_bgg.bggoriu,g_bgg.bggorig,                        # 顯示單頭值
     g_bgg.bgg01,  g_bgg.bgg02,g_bgg.bgg06,g_bgg.bgg07,g_bgg.bgguser,g_bgg.bgggrup,
        g_bgg.bggmodu,g_bgg.bggdate,g_bgg.bggacti,
        g_bgg.bggud01,g_bgg.bggud02,g_bgg.bggud03,g_bgg.bggud04,
        g_bgg.bggud05,g_bgg.bggud06,g_bgg.bggud07,g_bgg.bggud08,
        g_bgg.bggud09,g_bgg.bggud10,g_bgg.bggud11,g_bgg.bggud12,
        g_bgg.bggud13,g_bgg.bggud14,g_bgg.bggud15 
 
    CALL i010_bgg02('d')
    CALL i010_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i010_x()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bgg.bgg02) THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    BEGIN WORK
    OPEN i010_curl USING g_bgg.bgg01,g_bgg.bgg02
    IF STATUS THEN
       CALL cl_err("OPEN i010_curl:", STATUS, 1)
       CLOSE i010_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_curl INTO g_bgg.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bgg.bgg01,SQLCA.sqlcode,0)          #資料被他人LOCK
        RETURN
    END IF
    CALL i010_show()
    IF cl_exp(0,0,g_bgg.bggacti) THEN
        LET g_chr=g_bgg.bggacti
        IF g_bgg.bggacti='Y' THEN
           LET g_bgg.bggacti='N'
        ELSE
           LET g_bgg.bggacti='Y'
        END IF
        UPDATE bgg_file                    #更改有效碼
           SET bggacti=g_bgg.bggacti
         WHERE bgg01=g_bgg.bgg01
           AND bgg02=g_bgg.bgg02
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","bgg_file",g_bgg.bgg01,g_bgg.bgg02,SQLCA.sqlcode,"","",1) #FUN-660105
            LET g_bgg.bggacti=g_chr
        END IF
        DISPLAY BY NAME g_bgg.bggacti #ATTRIBUTE(RED)
    END IF
    CLOSE i010_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION i010_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
    DEFINE l_cnt LIKE type_file.num10   #No.FUN-680061 INTEGER
    
 
    IF s_shut(0) THEN RETURN END IF
    IF g_bgg.bgg02 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_bgg.bggacti = 'N' THEN
       CALL cl_err('','abm-950',0)
       RETURN
    END IF
    BEGIN WORK
    OPEN i010_curl USING g_bgg.bgg01,g_bgg.bgg02
    IF STATUS THEN
       CALL cl_err("OPEN i010_curl:", STATUS, 1)
       CLOSE i010_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_curl INTO g_bgg.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bgg.bgg01,SQLCA.sqlcode,0) RETURN
    END IF
    CALL i010_show()
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bgg01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bgg02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bgg.bgg01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_bgg.bgg02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       DELETE FROM bgg_file WHERE bgg01=g_bgg.bgg01 AND bgg02=g_bgg.bgg02
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","bgg_file",g_bgg.bgg01,g_bgg.bgg02,SQLCA.sqlcode,"","",1) #FUN-660105
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM bgh_file WHERE bgh01=g_bgg.bgg01 AND bgh02=g_bgg.bgg02
       
     #MOD-D30217-start-mark
     # IF SQLCA.SQLERRD[3]=0   THEN       
     #    CALL cl_err3("del","bgh_file",g_bgg.bgg01,g_bgg.bgg02,SQLCA.sqlcode,"","",1) #FUN-660105
     #    ROLLBACK WORK
     #    RETURN
     # END IF
     #MOD-D30217-end-mark
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
            VALUES ('abgi010',g_user,g_today,g_msg,g_bgg.bgg01||"|"||g_bgg.bgg02,'delete',g_plant,g_legal) #FUN-980001 add #No.TQC-9A0140 mod

          CLEAR FORM
          CALL g_bgh.clear()
          OPEN i010_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i010_curs
             CLOSE i010_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          FETCH i010_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i010_curs
             CLOSE i010_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i010_curs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i010_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET g_no_ask = TRUE     #No.FUN-6A0057 g_no_ask 
             CALL i010_fetch('/')
          END IF
       
    END IF

    CLOSE i010_curl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i010_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT #No.FUN-680061 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680061 VARCHAR(01)
    p_cmd           LIKE type_file.chr1,     #處理狀態          #No.FUN-680061 VARCHAR(01)
    l_buf           LIKE type_file.chr50,    #No.FUN-680061 VARCHAR(40)    
    l_cmd           LIKE type_file.chr1000,  #No.FUN-680061 VARCHAR(200)
    l_uflag,l_chr   LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,     #可新增否 #No.FUN-680061 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否 #No.FUN-680061 SMALLINT
DEFINE l_ima25      LIKE ima_file.ima25
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bgg.bgg02) THEN
        RETURN
    END IF
    IF g_bgg.bggacti ='N' THEN    #資料若為無效,仍可更改.
       CALL cl_err(g_bgg.bgg01,'mfg1000',0) RETURN
    END IF
    LET l_uflag ='N'
    LET g_aflag ='N'
    LET g_modify_flag ='N'
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
       "SELECT bgh03,bgh04,' ',' ',bgh11,bgh06,bgh07,bgh08,", 
       #No.FUN-850038 --start--
       "       bghud01,bghud02,bghud03,bghud04,bghud05,",
       "       bghud06,bghud07,bghud08,bghud09,bghud10,",
       "       bghud11,bghud12,bghud13,bghud14,bghud15 ", 
       #No.FUN-850038 ---end---
       " FROM bgh_file ",
       " WHERE bgh01=? AND bgh02=? AND bgh03=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i010_b_curl CURSOR FROM g_forupd_sql
 

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    IF g_rec_b=0 THEN CALL g_bgh.clear() END IF
 
    INPUT ARRAY g_bgh WITHOUT DEFAULTS FROM s_bgh.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            OPEN i010_curl USING g_bgg.bgg01,g_bgg.bgg02
            IF STATUS THEN
               CALL cl_err("OPEN i010_curl:", STATUS, 1)
               CLOSE i010_curl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i010_curl INTO g_bgg.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_bgg.bgg01,SQLCA.sqlcode,0)  # 資料被他人LOCK
               CLOSE i010_curl
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_bgh_t.* = g_bgh[l_ac].*  #BACKUP
               LET g_bgh_o.* = g_bgh[l_ac].*
               OPEN i010_b_curl USING g_bgg.bgg01,g_bgg.bgg02,g_bgh_t.bgh03
               IF STATUS THEN
                  CALL cl_err("OPEN i010_b_curl:", STATUS, 1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH i010_b_curl INTO g_bgh[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_bgh_t.bgh03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL i010_bgh04('d')
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bgh[l_ac].* TO NULL      #900423
            LET g_bgh[l_ac].bgh06 = 1         #Body default
            LET g_bgh[l_ac].bgh07 = 1         #Body default
            LET g_bgh[l_ac].bgh08 = 0         #Body default
            LET g_bgh11_fac = 1
            LET g_bgh_t.* = g_bgh[l_ac].*         #新輸入資料
            LET g_bgh_o.* = g_bgh[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bgh03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO bgh_file(bgh01,bgh02,bgh03,bgh04,bgh05,bgh06,bgh07, #No:BUG47-0041
                                 bgh08,bgh09,bgh10,bgh11,bgh11_fac,
                                 #FUN-850038 --start--
                                 bghud01,bghud02,bghud03,bghud04,bghud05,
                                 bghud06,bghud07,bghud08,bghud09,bghud10,
                                 bghud11,bghud12,bghud13,bghud14,bghud15)
                                 #FUN-850038 --end--
                 VALUES(g_bgg.bgg01,g_bgg.bgg02,g_bgh[l_ac].bgh03,
                        g_bgh[l_ac].bgh04,' ',g_bgh[l_ac].bgh06,
                        g_bgh[l_ac].bgh07,g_bgh[l_ac].bgh08,' ',
                        ' ',g_bgh[l_ac].bgh11,g_bgh11_fac,
                        #FUN-850038 --start--
                        g_bgh[l_ac].bghud01,g_bgh[l_ac].bghud02,
                        g_bgh[l_ac].bghud03,g_bgh[l_ac].bghud04,
                        g_bgh[l_ac].bghud05,g_bgh[l_ac].bghud06,
                        g_bgh[l_ac].bghud07,g_bgh[l_ac].bghud08,
                        g_bgh[l_ac].bghud09,g_bgh[l_ac].bghud10,
                        g_bgh[l_ac].bghud11,g_bgh[l_ac].bghud12,
                        g_bgh[l_ac].bghud13,g_bgh[l_ac].bghud14,
                        g_bgh[l_ac].bghud15)
                        #FUN-850038 --end--
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","bgh_file",g_bgg.bgg01,g_bgg.bgg02,SQLCA.sqlcode,"","",1) #FUN-660105
               CANCEL INSERT
            ELSE
               LET g_modify_flag='Y'
               UPDATE bgg_file SET bggdate = g_today
                WHERE bgg01=g_bgg.bgg01 AND bgg02=g_bgg.bgg02
               MESSAGE 'INSERT O.K'
               IF g_aflag = 'N' THEN LET g_aflag = 'Y' END IF
               LET g_rec_b=g_rec_b+1
    	       COMMIT WORK
            END IF
 
        BEFORE FIELD bgh03                        #default 項次
            IF cl_null(g_bgh[l_ac].bgh03) OR g_bgh[l_ac].bgh03 = 0 THEN
               SELECT MAX(bgh03)
                 INTO g_bgh[l_ac].bgh03
                 FROM bgh_file
                WHERE bgh01 = g_bgg.bgg01
                  AND bgh02 = g_bgg.bgg02
                IF cl_null(g_bgh[l_ac].bgh03) THEN
                   LET g_bgh[l_ac].bgh03 = 0
                END IF
                LET g_bgh[l_ac].bgh03 = g_bgh[l_ac].bgh03 + g_sma.sma19
            END IF
 
        AFTER FIELD bgh03                        #default 項次
            IF NOT cl_null(g_bgh[l_ac].bgh03) AND
               g_bgh[l_ac].bgh03 <> 0 AND p_cmd='a' THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM bgh_file
                WHERE bgh01=g_bgg.bgg01
                  AND bgh02=g_bgg.bgg02
                  AND bgh03=g_bgh[l_ac].bgh03
               IF l_n>0 THEN
                  IF NOT cl_conf(0,0,'mfg-002') THEN NEXT FIELD bgh03 END IF
               END IF
             END IF
 
        AFTER FIELD bgh04                         #(元件料件)
            #FUN-AA0059 -------------------add start------------------
            IF NOT cl_null(g_bgh[l_ac].bgh04) THEN
               IF NOT s_chk_item_no(g_bgh[l_ac].bgh04,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_bgh[l_ac].bgh04=g_bgh_t.bgh04
                  NEXT FIELD bgh04
               END IF 
            END IF 
            #FUN-AA0059 ---------------------add end----------------------
            IF cl_null(g_bgh[l_ac].bgh04) THEN
               LET g_bgh[l_ac].bgh04=g_bgh_t.bgh04
               NEXT FIELD bgh04
            END IF
            IF cl_null(g_bgh_t.bgh04) THEN
               SELECT COUNT(*) INTO l_n FROM bgh_file
                      WHERE bgh01=g_bgg.bgg01
                        AND bgh02=g_bgg.bgg02
                        AND bgh04=g_bgh[l_ac].bgh04
               IF l_n>0 THEN
                  IF NOT cl_conf(0,0,'abm-728') THEN NEXT FIELD bgh04 END IF
               END IF
            END IF
            CALL i010_bgh04('a')      #必需讀取(料件主檔)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_bgh[l_ac].bgh04=g_bgh_t.bgh04
               NEXT FIELD bgh04
            END IF
            LET l_ima25=''
            SELECT ima25 INTO l_ima25 FROM ima_file
             WHERE ima01=g_bgh[l_ac].bgh04
 
       AFTER FIELD bgh11
          IF NOT cl_null(g_bgh[l_ac].bgh11 ) THEN
               CALL i100_bgh11('a',g_bgh[l_ac].bgh11 )
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  LET g_bgh[l_ac].bgh11 = g_bgh_t.bgh11
                  NEXT FIELD bgh11
               END IF
           END IF
           CALL s_umfchk(g_bgh[l_ac].bgh04,
                g_bgh[l_ac].bgh11,l_ima25)
           RETURNING g_sw,g_bgh11_fac  #發料/庫存單位
           IF g_sw THEN
              CALL cl_err(g_bgh[l_ac].bgh11,'mfg2721',0)
              LET g_bgh[l_ac].bgh11 = g_bgh_o.bgh11
              NEXT FIELD bgh11
           END IF
           IF cl_null(g_bgh11_fac) THEN LET g_bgh11_fac=1 END IF
 
        AFTER FIELD bgh06    #組成用量不可小於零
          IF g_bgh[l_ac].bgh06 < 0 OR cl_null(g_bgh[l_ac].bgh06) THEN
             CALL cl_err(g_bgh[l_ac].bgh06,'mfg2614',0)
             LET g_bgh[l_ac].bgh06 = g_bgh_o.bgh06
             NEXT FIELD bgh06
          END IF
          LET g_bgh_o.bgh06 = g_bgh[l_ac].bgh06
 
        AFTER FIELD bgh07    #底數不可小於等於零
            IF g_bgh[l_ac].bgh07 <= 0 OR cl_null(g_bgh[l_ac].bgh07) THEN
               CALL cl_err(g_bgh[l_ac].bgh07,'mfg2615',0)
               LET g_bgh[l_ac].bgh07 = g_bgh_o.bgh07
               NEXT FIELD bgh07
            END IF
            LET g_bgh_o.bgh07 = g_bgh[l_ac].bgh07
 
        AFTER FIELD bgh08    #損耗率
            IF g_bgh[l_ac].bgh08 < 0 OR g_bgh[l_ac].bgh08 > 100 THEN
               CALL cl_err(g_bgh[l_ac].bgh08,'mfg4063',0)
               LET g_bgh[l_ac].bgh08 = g_bgh_o.bgh08
               NEXT FIELD bgh08
            END IF
            LET g_bgh_o.bgh08 = g_bgh[l_ac].bgh08
 
        AFTER FIELD bghud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bghud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bghud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bghud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bghud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bghud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bghud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bghud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bghud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bghud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bghud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bghud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bghud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bghud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bghud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bgh_t.bgh03 > 0 AND (NOT cl_null(g_bgh_t.bgh03)) THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM bgh_file
                WHERE bgh01 = g_bgg.bgg01
                  AND bgh02 = g_bgg.bgg02
                  AND bgh03 = g_bgh_t.bgh03
               IF SQLCA.sqlcode OR g_success='N' THEN
                  LET l_buf = g_bgh_t.bgh03 clipped
                  CALL cl_err(l_buf,SQLCA.sqlcode,0)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               LET g_modify_flag='Y'
            END IF
	    COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bgh[l_ac].* = g_bgh_t.*
               CLOSE i010_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bgh[l_ac].bgh03,-263,1)
               LET g_bgh[l_ac].* = g_bgh_t.*
            ELSE
               UPDATE bgh_file
                  SET bgh03=g_bgh[l_ac].bgh03,
                      bgh04=g_bgh[l_ac].bgh04,
                      bgh06=g_bgh[l_ac].bgh06,
                      bgh07=g_bgh[l_ac].bgh07,
                      bgh08=g_bgh[l_ac].bgh08,
                      bgh11=g_bgh[l_ac].bgh11,
                      bgh11_fac=g_bgh11_fac,
                      #FUN-850038 --start--
                      bghud01 = g_bgh[l_ac].bghud01,
                      bghud02 = g_bgh[l_ac].bghud02,
                      bghud03 = g_bgh[l_ac].bghud03,
                      bghud04 = g_bgh[l_ac].bghud04,
                      bghud05 = g_bgh[l_ac].bghud05,
                      bghud06 = g_bgh[l_ac].bghud06,
                      bghud07 = g_bgh[l_ac].bghud07,
                      bghud08 = g_bgh[l_ac].bghud08,
                      bghud09 = g_bgh[l_ac].bghud09,
                      bghud10 = g_bgh[l_ac].bghud10,
                      bghud11 = g_bgh[l_ac].bghud11,
                      bghud12 = g_bgh[l_ac].bghud12,
                      bghud13 = g_bgh[l_ac].bghud13,
                      bghud14 = g_bgh[l_ac].bghud14,
                      bghud15 = g_bgh[l_ac].bghud15
                      #FUN-850038 --end-- 
                WHERE bgh01=g_bgg.bgg01
                  AND bgh02=g_bgg.bgg02
                  AND bgh03=g_bgh_t.bgh03
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","bgh_file",g_bgg.bgg01,g_bgg.bgg02,SQLCA.sqlcode,"","",1) #FUN-660105
                   LET g_bgh[l_ac].* = g_bgh_t.*
                ELSE
                   IF g_bgh_t.bgh04 <> g_bgh[l_ac].bgh04 THEN
                      LET g_modify_flag='Y'
                   END IF
                   UPDATE bgg_file SET bggdate = g_today
                    WHERE bgg01=g_bgg.bgg01 AND bgg02=g_bgg.bgg02
                   IF g_aflag = 'N' THEN LET g_aflag = 'Y' END IF
    	           COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_bgh[l_ac].* = g_bgh_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bgh.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE i010_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac #FUN-D30032 add
            CLOSE i010_b_curl
            COMMIT WORK
           #CALL g_bgh.deleteElement(g_rec_b+1)  #FUN-D30032 mark
 
     ON ACTION CONTROLP
           CASE WHEN INFIELD(bgh04) #料件主檔
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form ="q_ima"
               #   LET g_qryparam.default1=g_bgh[l_ac].bgh04
               #   CALL cl_create_qry() RETURNING g_bgh[l_ac].bgh04
                  CALL q_sel_ima(FALSE, "q_ima", "", g_bgh[l_ac].bgh04, "", "", "", "" ,"",'' ) 
                    RETURNING g_bgh[l_ac].bgh04
#FUN-AA0059 --End--
                  NEXT FIELD bgh04
                WHEN INFIELD(bgh11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1=g_bgh[l_ac].bgh11
                  CALL cl_create_qry() RETURNING g_bgh[l_ac].bgh11
                  NEXT FIELD bgh11
               OTHERWISE EXIT CASE
           END  CASE
 
     ON ACTION CONTROLN
            CALL i010_b_askkey()
            EXIT INPUT
 
     ON ACTION CONTROLO                       #沿用所有欄位
           IF INFIELD(bgh03) AND l_ac > 1 THEN
              LET g_bgh[l_ac].* = g_bgh[l_ac-1].*
              LET g_bgh[l_ac].bgh03 = NULL
 LET g_bgh[l_ac].bgh04 = NULL   #No.+003 add
              NEXT FIELD bgh03
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
    
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
      END INPUT

      UPDATE bgg_file SET bggmodu = g_user,bggdate = g_today
       WHERE bgg01=g_bgg.bgg01 AND bgg02=g_bgg.bgg02
 
    CALL i010_delHeader()     #CHI-C30002 add
    CLOSE i010_b_curl
    COMMIT WORK
#   CALL i010_delall()        #CHI-C30002 mark
END FUNCTION

#CHI-C30002 ------- add -------- begin
FUNCTION i010_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM bgg_file WHERE bgg01=g_bgg.bgg01 AND bgg02=g_bgg.bgg02
         INITIALIZE g_bgg.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 ------- add -------- end

#CHI-C30002 ------- mark ------- begin 
#FUNCTION i010_delall()
#   SELECT COUNT(*) INTO g_cnt FROM bgh_file
#       WHERE bgh01=g_bgg.bgg01
#         AND bgh02=g_bgg.bgg02
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 則取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM bgg_file
#       WHERE bgg01 = g_bgg.bgg01
#         AND bgg02 = g_bgg.bgg02
#   END IF
#END FUNCTION
#CHI-C30002 ------- mark ------- end
 
FUNCTION i010_bgh04(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
    l_ima110        LIKE ima_file.ima110,
    l_imaacti       LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima63,imaacti
      INTO g_bgh[l_ac].ima02_b,g_bgh[l_ac].ima021_b,g_bgh[l_ac].bgh11,l_imaacti
      FROM ima_file
     WHERE ima01 = g_bgh[l_ac].bgh04
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET g_bgh[l_ac].ima02_b = NULL
                                   LET g_bgh[l_ac].ima021_b = NULL
                                   LET g_bgh[l_ac].bgh11   = NULL
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i100_bgh11(p_cmd,p_key)
DEFINE l_gfeacti LIKE gfe_file.gfeacti,
      p_key     LIKE bgh_file.bgh11,
      l_fac     LIKE pml_file.pml09,   #No.FUN-680061 DEC(16,8)
      p_cmd     LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
 
LET g_errno = " "
SELECT gfeacti INTO l_gfeacti
  FROM gfe_file  WHERE gfe01 = p_key
CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0019'
                               LET l_gfeacti = NULL
     WHEN l_gfeacti='N'        LET g_errno = '9028'
     OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
END CASE
 
END FUNCTION
 
 
 
FUNCTION i010_b_askkey()
DEFINE
    l_wc2   LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(200)
 
    CLEAR ima02_b,ima021_b,ima25_b
    CONSTRUCT l_wc2 ON bgh03,bgh04,bgh11,bgh06,bgh07,bgh08 # 螢幕上取單身條件
                       #No.FUN-850038 --start--
                       ,bghud01,bghud02,bghud03,bghud04,bghud05
                       ,bghud06,bghud07,bghud08,bghud09,bghud10
                       ,bghud11,bghud12,bghud13,bghud14,bghud15
                       #No.FUN-850038 ---end---
         FROM s_bgh[1].bgh03,s_bgh[1].bgh04,
              s_bgh[1].bgh11,
              s_bgh[1].bgh06,s_bgh[1].bgh07,
              s_bgh[1].bgh08
              ,s_bgh[1].bghud01,s_bgh[1].bghud02,s_bgh[1].bghud03
              ,s_bgh[1].bghud04,s_bgh[1].bghud05,s_bgh[1].bghud06
              ,s_bgh[1].bghud07,s_bgh[1].bghud08,s_bgh[1].bghud09
              ,s_bgh[1].bghud10,s_bgh[1].bghud11,s_bgh[1].bghud12
              ,s_bgh[1].bghud13,s_bgh[1].bghud14,s_bgh[1].bghud15

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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i010_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i010_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2   LIKE type_file.chr1000       #No.FUN-680061 VARCHAR(300)
    LET g_sql =
        "SELECT bgh03,bgh04,ima02,ima021,bgh11,bgh06,bgh07,bgh08,",   #MOD-530239
        "       bghud01,bghud02,bghud03,bghud04,bghud05,",
        "       bghud06,bghud07,bghud08,bghud09,bghud10,",
        "       bghud11,bghud12,bghud13,bghud14,bghud15 ", 
        "  FROM bgh_file LEFT OUTER JOIN ima_file ON bgh04 = ima01 ",  #No.TQC-9A0140 mod
        " WHERE bgh01 ='",g_bgg.bgg01,"' ",
        "   AND bgh02 ='",g_bgg.bgg02,"' ",
        "   AND ",p_wc2 CLIPPED
 
    PREPARE i010_pb FROM g_sql
    DECLARE bgh_curs                       #SCROLL CURSOR
        CURSOR FOR i010_pb
 
    CALL g_bgh.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH bgh_curs INTO g_bgh[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('',9035,0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bgh.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i010_bp(p_ud)
DEFINE
   p_ud   LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bgh TO s_bgh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)   #TQC-840036   
 
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
         CALL i010_fetch('F')
      ON ACTION previous                       #FUN-AA0059 add 
         CALL i010_fetch('P')
      ON ACTION jump                           #FUN-AA0059 add
         CALL i010_fetch('/')
      ON ACTION next                           #FUN-AA0059 add
         CALL i010_fetch('N')
      ON ACTION last                           #FUN-AA0059 add 
         CALL i010_fetch('L')

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
      ON ACTION date_produce
         LET g_action_choice="date_produce"
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
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0003  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
     
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i010_out()
    DEFINE
        l_i    LIKE type_file.num5,     #No.FUN-680061 SMALLINT
        l_name LIKE type_file.chr20,    # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
        l_za05 LIKE type_file.chr1000,  #NO.FUN-680061 VARCHAR(40)
        l_ima02         LIKE ima_file.ima02,       #No.FUN-770033                                                                                 
        l_ima021        LIKE ima_file.ima021,      #No.FUN-770033                                                                                 
        l_ima55         LIKE ima_file.ima55,       #No.FUN-770033
        sr RECORD
             bgg01      LIKE bgg_file.bgg01,
             bgg02      LIKE bgg_file.bgg02,
             bgh03      LIKE bgh_file.bgh03,
             bgh04      LIKE bgh_file.bgh04,
             bgh11      LIKE bgh_file.bgh11,
             bgh06      LIKE bgh_file.bgh06,
             bgh07      LIKE bgh_file.bgh07,
             bgh08      LIKE bgh_file.bgh08,
             ima02      LIKE ima_file.ima02,
             ima021     LIKE ima_file.ima021,
             bggacti    LIKE bgg_file.bggacti
        END RECORD
 
    CALL cl_wait()
    CALL cl_del_data(l_table)                                #No.FUN-770033
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog   #No.FUN-770033
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 LET g_sql="SELECT bgg01,bgg02,bgh03,bgh04,bgh11,bgh06,bgh07,bgh08,",
              "       ima02,ima021 ",
              "  FROM bgg_file,bgh_file LEFT OUTER JOIN ima_file ON bgh04 = ima01 ",   # 組合出 SQL 指令  #TQC-9A0140 mod
              " WHERE bgg01=bgh01 AND bgg02=bgh02 ", #AND bgh_file.bgh04=ima_file.ima01", #TQC-9A0140 mod
              "   AND ",g_wc CLIPPED ,
              "   AND ",g_wc2 CLIPPED ,
              " ORDER BY bgg01,bgg02,bgh03 " 
    PREPARE i010_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i010_co CURSOR FOR i010_p1
 
 
    FOREACH i010_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT ima02,ima021,ima55                                                                                               
            INTO l_ima02,l_ima021,l_ima55                                                                                         
            FROM ima_file                                                                                                         
            WHERE ima01 = sr.bgg02                                                                                                 
        IF SQLCA.sqlcode THEN                                                                                                   
           LET l_ima02='' LET l_ima021='' LET l_ima55=''                                                                         
        END IF 
    EXECUTE insert_prep USING
            sr.bgg01,sr.bgg02,l_ima02,l_ima021,l_ima55,sr.bgh03,sr.bgh04,
            sr.ima02,sr.ima021,sr.bgh11,sr.bgh06,sr.bgh07,sr.bgh08 
      
    END FOREACH
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
        IF g_zz05 = 'Y' THEN                               
           CALL cl_wcchp(g_wc,'bgg01,bgg02,bgg06,bgg07,bgguser,bgggrup,bggmodu,bggdate')                                                                              
           RETURNING g_wc                
           LET g_str = g_wc      
        END IF 
    LET g_str=g_str                                                     
 
 
    CLOSE i010_co
    ERROR ""
    CALL cl_prt_cs3('abgi010','abgi010',l_sql,g_str)       
END FUNCTION

 
FUNCTION i010_copy()
DEFINE
    new_ver     LIKE bgg_file.bgg01,
    old_ver     LIKE bgg_file.bgg01,
    new_no      LIKE bgg_file.bgg02,
    old_no      LIKE bgg_file.bgg02,
    l_ima02     LIKE ima_file.ima02,
    l_ima021    LIKE ima_file.ima021,
    l_ima55     LIKE ima_file.ima55,
    l_imaacti   LIKE ima_file.imaacti
 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_bgg.bgg02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   DISPLAY "" AT 1,1
   CALL cl_getmsg('copy',g_lang) RETURNING g_msg
   DISPLAY g_msg AT 2,1 #ATTRIBUTE(RED)    #No.FUN-940135
   CALL cl_set_head_visible("","YES")      #No.FUN-6B0033
 WHILE TRUE
   INPUT new_ver,new_no FROM bgg01,bgg02
       AFTER FIELD bgg01
           IF cl_null(new_ver) THEN
              LET new_ver = ' '
           END IF
 
       AFTER FIELD bgg02
           #FUN-AA0059 -----------------------add start-----------------
           IF NOT cl_null(new_no) THEN
              IF NOT s_chk_item_no(new_no,'') THEN 
                 CALL cl_err('',g_errno,1) 
                 NEXT FIELD bgg02
              END IF 
           END IF 
           #FUN-AA0059 -------------------add end----------------------------- 
           IF cl_null(new_no) THEN
              NEXT FIELD bgg02
           END IF
           SELECT COUNT(*) INTO g_cnt FROM bgg_file
            WHERE bgg01=new_ver
              AND bgg02=new_no
           IF g_cnt >0 THEN
              CALL cl_err(new_no,-239,0)
              NEXT FIELD bgg02
           END IF
           LET g_errno = ' '
           SELECT  ima02,ima021,ima55,imaacti
             INTO  l_ima02,l_ima021,l_ima55,l_imaacti
             FROM  ima_file
            WHERE  ima01 = new_no
           CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2602'
                   LET l_ima02 = NULL LET l_ima021 = NULL
                   LET l_ima55 = NULL LET l_imaacti= NULL
                WHEN l_imaacti='N' LET g_errno = '9028'
          
                WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
                    
                OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
           END CASE
           IF cl_null(g_errno) THEN
              DISPLAY l_ima02   TO FORMONLY.ima02
              DISPLAY l_ima021  TO FORMONLY.ima021
              DISPLAY l_ima55   TO FORMONLY.ima55
           END IF
 
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_bgg.bgg01,g_errno,0)
              LET new_ver = g_bgg.bgg01 #g_bgg_o.bgg01
              LET new_no  = g_bgg.bgg02 #g_bgg_o.bgg02
              DISPLAY BY NAME new_ver,new_no
              NEXT FIELD bgg02
           END IF
 
        ON ACTION CONTROLP     #查詢條件
            CASE
               WHEN INFIELD(bgg02) #料件主檔
#FUN-AA0059 --Begin--              
              #    CALL cl_init_qry_var()
              #    LET g_qryparam.form ="q_ima" 
              #    LET g_qryparam.default1=new_no
              #    CALL cl_create_qry() RETURNING new_no
                  CALL q_sel_ima(FALSE, "q_ima", "", new_no, "", "", "", "" ,"",'' )  RETURNING new_no
#FUN-AA0059 --End--
                  DISPLAY BY NAME new_no
                  NEXT FIELD bgg02
               OTHERWISE EXIT CASE
             END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    
     ON ACTION CONTROLE
        IF INFIELD(bgg02) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_oba"
           LET g_qryparam.default1=new_no
           CALL cl_create_qry() RETURNING new_no
           DISPLAY BY NAME new_no
           NEXT FIELD bgg02
        END IF
     
 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG=0
      DISPLAY BY NAME g_bgg.bgg01
      DISPLAY BY NAME g_bgg.bgg02
      RETURN
   END IF
   IF new_ver IS NULL OR new_no IS NULL THEN
      CONTINUE WHILE
   END IF
   EXIT WHILE
 END WHILE
 
 
   DROP TABLE y
   SELECT * FROM bgg_file
    WHERE bgg01=g_bgg.bgg01
      AND bgg02=g_bgg.bgg02
     INTO TEMP y
   UPDATE y
      SET bgg01 = new_ver,
          bgg02 = new_no,
          bgguser=g_user,
          bgggrup=g_grup,
          bggmodu=NULL,
          bggdate=g_today,
          bggacti='Y'
   INSERT INTO bgg_file
      SELECT * FROM y
 
   DROP TABLE x
   SELECT * FROM bgh_file
       WHERE bgh01=g_bgg.bgg01
         AND bgh02=g_bgg.bgg02
        INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_bgg.bgg01,g_bgg.bgg02,SQLCA.sqlcode,"","",1) #FUN-660105
      RETURN
   END IF
   UPDATE x
      SET bgh01=new_ver,
          bgh02=new_no
   INSERT INTO bgh_file
      SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","bgh_file",g_bgg.bgg01,g_bgg.bgg02,SQLCA.sqlcode,"","",1) #FUN-660105
      RETURN
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',new_ver,') OK'
      ATTRIBUTE(REVERSE)
   LET old_ver = g_bgg.bgg01
   LET old_no  = g_bgg.bgg02
   SELECT  bgg_file.* INTO g_bgg.* FROM bgg_file
    WHERE bgg01=new_ver
      AND bgg02=new_no
   CALL i010_u()
   CALL i010_b()
   #FUN-C30027---begin
   #SELECT  bgg_file.* INTO g_bgg.* FROM bgg_file
   # WHERE bgg01= old_ver
   #   AND bgg02= old_no
   #CALL i010_show()
   #FUN-C30027---end
END FUNCTION
 
FUNCTION i010_g()
DEFINE
    t_bma01     LIKE ima_file.ima01,   #NO.MOD-490217
    t_oba01     LIKE oba_file.oba01,   #NO.FUN-680061 VARCHAR(20)
    l_sql       LIKE type_file.chr1000,#No.FUN-680061 VARCHAR(1000)
    l_ima02     LIKE ima_file.ima02,
    l_ima021    LIKE ima_file.ima021,
    l_ima55     LIKE ima_file.ima55,
    l_ima58     LIKE ima_file.ima58,
    l_ima910    LIKE ima_file.ima910,  #FUN-550095 add
    l_imaacti   LIKE ima_file.imaacti,
    l_bma       RECORD LIKE bma_file.*,#複製用buffer
    l_oba02     LIKE oba_file.oba02
 
    OPEN WINDOW i010_g_w AT 10,24 WITH FORM "abg/42f/abgi010_g"
         ATTRIBUTE(STYLE = g_win_style)
     CALL cl_ui_locale("abgi010_g")        #MOD-530239
    IF STATUS THEN
       CALL cl_err('open window i010_g_w:',STATUS,0)
       RETURN
    END IF
    LET t_bma01 = NULL
    LET vdate = NULL
    LET new_ver = NULL
    LET t_oba01   = NULL
 
  INPUT t_bma01,vdate,new_ver,t_oba01 FROM bma01,vdate,new_ver,oba01
    BEFORE FIELD bma01
      LET  vdate=g_today
        DISPLAY BY NAME vdate
 
    AFTER FIELD bma01
      IF NOT cl_null(t_bma01) THEN
        #FUN-AA0059 --------------------add start-----------------
        IF NOT s_chk_item_no(t_bma01,'') THEN
           CALL cl_err('',g_errno,1) 
            LET t_bma01 = NULL
            DISPLAY BY NAME t_bma01
            NEXT FIELD bma01
        END IF 
        #FUN-AA0059 ------------------add end----------------
        LET g_errno = ' '
        SELECT  ima02,ima021,ima55,ima58,imaacti
          INTO  l_ima02,l_ima021,l_ima55,l_ima58,l_imaacti
          FROM  ima_file
         WHERE  ima01 = t_bma01
        CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2602'
                LET l_ima02 = NULL LET l_ima021 = NULL
                LET l_ima55 = NULL
                LET l_ima58 = NULL LET l_imaacti= NULL
             WHEN l_imaacti='N' LET g_errno = '9028'
   
             WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    
             OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
        IF NOT cl_null(g_errno) THEN
           CALL cl_err(g_bgg.bgg01,g_errno,0)
           LET t_bma01 = NULL
           DISPLAY BY NAME t_bma01
           NEXT FIELD bma01
        END IF
      END IF
 
    AFTER FIELD new_ver
        IF cl_null(new_ver) THEN
           LET new_ver = ' '
        END IF
        SELECT COUNT(*) INTO g_cnt FROM bgg_file
         WHERE bgg01=new_ver
           AND bgg02=t_bma01
        IF g_cnt >0 THEN
           CALL cl_err(new_ver,-239,0)
           NEXT FIELD new_ver
        END IF
 
     AFTER FIELD oba01
         IF cl_null(t_oba01)  THEN
             LET t_oba01 = t_bma01
             DISPLAY t_oba01 TO oba01
         ELSE
            LET g_errno = ' '
            SELECT  oba02 INTO l_oba02
             FROM  oba_file
              WHERE  oba01 = t_oba01
            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aom-005'
                LET l_oba02 = NULL
                  OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_bgg.bgg01,g_errno,0)
               LET t_oba01 = NULL
               DISPLAY BY NAME t_oba01
               NEXT FIELD oba01
            END IF
         END IF
 
    ON ACTION CONTROLP     #查詢條件
       CASE
          WHEN INFIELD(bma01) #料件主檔
#FUN-AA0059 --Begin--         
            #   CALL cl_init_qry_var()
            #   LET g_qryparam.form ="q_ima"
            #   LET g_qryparam.default1=t_bma01
            #   CALL cl_create_qry() RETURNING t_bma01
               CALL q_sel_ima(FALSE, "q_ima", "", t_bma01, "", "", "", "" ,"",'' )  RETURNING t_bma01 
#FUN-AA0059 --End--
               DISPLAY BY NAME t_bma01
               NEXT FIELD bma01
          WHEN INFIELD(oba01) #產品分類
          
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oba"
               LET g_qryparam.default1 = t_oba01
               CALL cl_create_qry() RETURNING t_oba01
               DISPLAY BY NAME t_oba01
               NEXT FIELD oba01
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
   CLOSE WINDOW i010_g_w
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
   LET g_oba01=t_oba01
   INSERT INTO bgg_file(bgg01,bgg02,bgg06,bgg07,bgguser,bgggrup,bggacti,bggoriu,bggorig)
        VALUES (new_ver,t_oba01,t_bma01,l_ima58,g_user,g_grup,'Y', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
   
   SELECT ima910 INTO l_ima910
     FROM ima_file
    WHERE ima01=t_bma01
   IF cl_null(l_ima910) THEN
       LET l_ima910 = ' '
   END IF
   
   CALL i010_bom(0,t_bma01,l_ima910,1) #FUN-550095 add l_ima910
   SELECT bgg_file.* INTO g_bgg.* FROM bgg_file
    WHERE bgg01=new_ver AND bgg02=t_bma01
   LET g_wc =" bgg01='",new_ver,"' AND bgg02='",t_oba01,"' "
   LET g_wc2=" 1=1"
   CALL i010_show()
   DISPLAY 1     TO FORMONLY.cnt 
 
END FUNCTION
 
 
FUNCTION i010_bom(p_level,p_key,p_key2,p_total) #FUN-550095 add p_key2
   DEFINE p_level     LIKE type_file.num5,   #FUN-680061 SMALLINT
          p_total     LIKE bmb_file.bmb06,   #FUN-560227
          l_total     LIKE bmb_file.bmb06,   #FUN-560227
          p_key	      LIKE bma_file.bma01,   #主件料件編號
          p_key2      LIKE bma_file.bma02,   #FUN-550095 add
          l_bgh03     LIKE bgh_file.bgh03,
          l_ac        LIKE type_file.num5,   #No.FUN-680061 SMALLINT
          i           LIKE type_file.num5,   #No.FUN-680061 SMALLINT
          arrno	      LIKE type_file.num5,   #No.FUN-680061 SMALLINT
          l_chr,l_cnt LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
       sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              bma01   LIKE bma_file.bma01,   #主件料件
              bmb01   LIKE bmb_file.bmb01,   #本階主件
              bmb02   LIKE bmb_file.bmb02,   #項次
              bmb03   LIKE bmb_file.bmb03,   #元件料號
              bmb04   LIKE bmb_file.bmb04,   #有效日期
              bmb10   LIKE bmb_file.bmb10,   #
              bmb10_fac   LIKE bmb_file.bmb10_fac,
              bmb05   LIKE bmb_file.bmb05,   #失效日期
              bmb06   LIKE bmb_file.bmb06,   #QPA/BASE #FUN-560227
              bmb07   LIKE bmb_file.bmb07,
              bmb08   LIKE bmb_file.bmb08    #損耗率%
          END RECORD,
          l_cmd        LIKE type_file.chr1000#No.FUN-680061
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN
       CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
       EXIT PROGRAM
    END IF
    IF g_trace='Y' THEN DISPLAY 'bom:',p_key END IF
    LET p_level = p_level + 1
    LET arrno = 602
    WHILE TRUE
        LET l_cmd=
            "SELECT bma01,",
            "       bmb01, bmb02, bmb03, bmb04,bmb10,bmb10_fac, bmb05, ",
            "       bmb06/bmb07,1    ,  bmb08 ",
            "  FROM bmb_file LEFT OUTER JOIN bma_file ON bmb03 = bma01 ",  #TQC-9A0140 mod
            " WHERE bmb01='", p_key,"' ",
            "   AND bmb29='", p_key2,"' " #FUN-550095 add
            #"   AND bmb_file.bmb03 = bma_file.bma01"
 
        #生效日及失效日的判斷
           LET l_cmd=l_cmd CLIPPED,
                      " AND (bmb04 <='",vdate,"' OR bmb04 IS NULL)",
                      " AND (bmb05 > '",vdate,"' OR bmb05 IS NULL)"
     #---->排列方式
        PREPARE i010_precur FROM l_cmd
        IF SQLCA.sqlcode THEN
	   CALL cl_err('P1:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
           EXIT PROGRAM
        END IF
        DECLARE i010_cur CURSOR FOR i010_precur
        LET l_ac = 1
        FOREACH i010_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
            #FUN-8B0035--BEGIN--                                                                                                    
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            #FUN-8B0035--END--
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
            IF g_trace='Y' THEN
               DISPLAY "COM2:",sr[i].bma01," ",sr[i].bmb02," ",sr[i].bmb03
            END IF
           #與多階展開不同之處理在此:
           #尾階在展開時, 其展開之
            IF NOT cl_null(sr[i].bma01) THEN         #若為主件(有BOM單頭)
              #CALL i010_bom(p_level,sr[i].bmb03,' ',                #FUN-550095 add ' '#FUN-8B0035
               CALL i010_bom(p_level,sr[i].bmb03,l_ima910[i],        #FUN-8B0035
                             p_total*sr[i].bmb06*(1+sr[i].bmb08/100))
            ELSE
               LET l_total=p_total*sr[i].bmb06*(1+sr[i].bmb08/100)
               #No.8546 同料相加
               LET g_cnt=0
               SELECT COUNT(*) INTO g_cnt FROM bgh_file
                WHERE bgh01=new_ver
                  AND bgh02=g_oba01
                  AND bgh04=sr[i].bmb03
               IF g_cnt >0 THEN
                  SELECT bgh03 INTO l_bgh03 FROM bgh_file
                   WHERE bgh01=new_ver
                     AND bgh02=g_oba01
                     AND bgh04=sr[i].bmb03
                  UPDATE bgh_file SET bgh06=bgh06+l_total
                   WHERE bgh01=new_ver
                     AND bgh02=g_oba01
                     AND bgh03=l_bgh03
               ELSE
                 SELECT MAX(bgh03)
                   INTO sr[i].bmb02
                   FROM bgh_file
                  WHERE bgh01 = new_ver
                    AND bgh02 = g_oba01
                 IF cl_null(sr[i].bmb02) THEN
                   LET sr[i].bmb02 = 0
                 END IF
                 LET sr[i].bmb02 = sr[i].bmb02 + g_sma.sma19
                 INSERT INTO bgh_file(bgh01,bgh02,bgh03,bgh04,
                                      bgh06,bgh07,bgh08,bgh11,bgh11_fac)
                 VALUES (new_ver,g_oba01,sr[i].bmb02,sr[i].bmb03,
                         l_total,1,0,sr[i].bmb10,sr[i].bmb10_fac)
               END IF
            END IF
        END FOR
        IF l_ac-1 < arrno THEN                        # BOM單身已讀完
            EXIT WHILE
        END IF
    END WHILE
END FUNCTION
#Patch....NO.TQC-610035 <001> #

