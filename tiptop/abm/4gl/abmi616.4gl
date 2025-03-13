# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: abmi616.4gl
# Descriptions...: 正式BOM底稿維護作業
# Date & Author..: 08/01/15 By jan
# Modify.........: No.FUN-810017 08/03/21 By jan
# Modify.........: No.FUN-830114 08/03/28 By jan 修改服飾作業
# Modify.........: No.FUN-830116 08/04/17 By jan 修改服飾作業
# Modify.........: No.FUN-840135 08/04/21 By jan 增加"整批審核"和"整批發放"action
# Modify.........: No.FUN-850017 08/05/06 By jan 拋轉bok表資料到bmb表時，修改bok33賦值
# Modify.........: No.FUN-870127 08/07/24 By arman 服飾版
# Modify.........: No.FUN-870117 08/09/05 by ve007 部位資料應分開來
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980001 09/08/06 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0077 09/12/16 By baofei 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-BB0186 11/11/21 By lixiang 增加發放還原功能
# Modify.........: No.TQC-BC0166 11/12/29 By yuhuabao BOM底稿產生時BOM表固定損耗bmb081及批量損耗bmb082給預設值'0'

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C80041 13/02/04 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20010 13/02/19 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.CHI-D10044 13/03/04 By bart s_uima146()參數變更
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm              RECORD
        plant       ARRAY[20]  OF LIKE azp_file.azp01,   
        dbs         ARRAY[20]  OF LIKE type_file.chr21,   
        a           LIKE boj_file.boj05
                    END RECORD,
    g_boj           RECORD LIKE boj_file.*,       #主件料件(假單頭)
    g_boj_t         RECORD LIKE boj_file.*,       #主件料件(舊值)
    g_boj_o         RECORD LIKE boj_file.*,       #主件料件(舊值)
    g_boj01_t       LIKE boj_file.boj01,  
    g_boj09_t       LIKE boj_file.boj09,
    g_boj06_t       LIKE boj_file.boj06,   
    g_bok10_fac_t   LIKE bok_file.bok10_fac,   #(舊值)
    g_ima08_h       LIKE ima_file.ima08,   #來源碼
    g_ima08_b       LIKE ima_file.ima08,   #來源碼
    g_ima37_b       LIKE ima_file.ima37,   #補貨政策
    g_ima25_b       LIKE ima_file.ima25,   #庫存單位
    g_ima63_b       LIKE ima_file.ima63,   #發料單位
    g_ima70_b       LIKE ima_file.ima63,   #消耗料件
    g_ima86_b       LIKE ima_file.ima86,   #成本單位
    g_ima107_b      LIKE ima_file.ima107,  #LOCATION
    g_ima04         LIKE ima_file.ima04,   
    g_db_type       LIKE type_file.chr3,    
    g_bok           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    bok32    LIKE bok_file.bok32,       #底稿項次
                    bok02    LIKE bok_file.bok02,       #元件項次
                    bok30    LIKE bok_file.bok30,       #計算方式 
                    bok03    LIKE bok_file.bok03,       #元件料件
                    ima02_b  LIKE ima_file.ima02,       #品名
                    ima021_b LIKE ima_file.ima021,      #規格
                    ima08_b  LIKE ima_file.ima08,       #來源
                    bok09    LIKE bok_file.bok09,       #作業編號
                    bok16    LIKE bok_file.bok16,       #UTE/SUB
                    bok14    LIKE bok_file.bok14,       #Required/Optional
                    bok04    LIKE bok_file.bok04,       #生效日
                    bok05    LIKE bok_file.bok05,       #失效日
                    bok06    LIKE bok_file.bok06,       #組成用量
                    bok07    LIKE bok_file.bok07,       #底數
                    bok10    LIKE bok_file.bok10,       #發料單位
                    bok08    LIKE bok_file.bok08,       #損耗率
                    bok19    LIKE bok_file.bok19,
                    bok24    LIKE bok_file.bok24,       #工程變異單號
                    bok13    LIKE bok_file.bok13,       #insert_loc
                    bok34    LIKE bok_file.bok34
                    END RECORD,
    g_bok_t         RECORD                 #程式變數 (舊值)
                    bok32    LIKE bok_file.bok32,       #底稿項次
                    bok02    LIKE bok_file.bok02,       #元件項次
                    bok30    LIKE bok_file.bok30,       #計算方式 
                    bok03    LIKE bok_file.bok03,       #元件料件
                    ima02_b  LIKE ima_file.ima02,       #品名
                    ima021_b LIKE ima_file.ima021,      #規格
                    ima08_b  LIKE ima_file.ima08,       #來源
                    bok09    LIKE bok_file.bok09,       #作業編號
                    bok16    LIKE bok_file.bok16,       #UTE/SUB
                    bok14    LIKE bok_file.bok14,       #Required/Optional
                    bok04    LIKE bok_file.bok04,       #生效日
                    bok05    LIKE bok_file.bok05,       #失效日
                    bok06    LIKE bok_file.bok06,       #組成用量
                    bok07    LIKE bok_file.bok07,       #底數
                    bok10    LIKE bok_file.bok10,       #發料單位
                    bok08    LIKE bok_file.bok08,       #損耗率
                    bok19    LIKE bok_file.bok19,
                    bok24    LIKE bok_file.bok24,       #工程變異單號
                    bok13    LIKE bok_file.bok13,       #insert_loc
                    bok34    LIKE bok_file.bok34
                    END RECORD,
    g_bok_o         RECORD                 #程式變數 (舊值)
                    bok32    LIKE bok_file.bok32,       #底稿項次
                    bok02    LIKE bok_file.bok02,       #元件項次
                    bok30    LIKE bok_file.bok30,       #計算方式 
                    bok03    LIKE bok_file.bok03,       #元件料件
                    ima02_b  LIKE ima_file.ima02,       #品名
                    ima021_b LIKE ima_file.ima021,      #規格
                    ima08_b  LIKE ima_file.ima08,       #來源
                    bok09    LIKE bok_file.bok09,       #作業編號
                    bok16    LIKE bok_file.bok16,       #UTE/SUB
                    bok14    LIKE bok_file.bok14,       #Required/Optional
                    bok04    LIKE bok_file.bok04,       #生效日
                    bok05    LIKE bok_file.bok05,       #失效日
                    bok06    LIKE bok_file.bok06,       #組成用量
                    bok07    LIKE bok_file.bok07,       #底數
                    bok10    LIKE bok_file.bok10,       #發料單位
                    bok08    LIKE bok_file.bok08,       #損耗率
                    bok19    LIKE bok_file.bok19,
                    bok24    LIKE bok_file.bok24,       #工程變異單號
                    bok13    LIKE bok_file.bok13,       #insert_loc
                    bok34    LIKE bok_file.bok34
                    END RECORD,
   l_b             DYNAMIC ARRAY OF RECORD
                    bok02    LIKE bok_file.bok02,
                    bok04    LIKE bok_file.bok04,
                    bok13    LIKE bok_file.bok13,
                    bok30    LIKE bok_file.bok30,
                    bok03    LIKE bok_file.bok03,
                    bok09    LIKE bok_file.bok09,
                    bok16    LIKE bok_file.bok16,
                    bok14    LIKE bok_file.bok14,
                    bok05    LIKE bok_file.bok05,
                    bok06    LIKE bok_file.bok06,
                    bok07    LIKE bok_file.bok07,
                    bok10    LIKE bok_file.bok10,
                    bok08    LIKE bok_file.bok08,
                    bok19    LIKE bok_file.bok19,
                    bok24    LIKE bok_file.bok24,
                    bok34    LIKE bok_file.bok34,
                    bok33    LIKE bok_file.bok33,
                    bok32    LIKE bok_file.bok32 #No.FUN-870117
                    END RECORD,
    l_boj10         DYNAMIC ARRAY OF LIKE boj_file.boj10,
    l_boj09         DYNAMIC ARRAY OF LIKE boj_file.boj09,
    l_boj01         DYNAMIC ARRAY OF LIKE boj_file.boj01,
    l_boj06_b       DYNAMIC ARRAY OF LIKE boj_file.boj06,
    l_boj08_b       DYNAMIC ARRAY OF LIKE boj_file.boj08,
    l_boj10_b       DYNAMIC ARRAY OF LIKE boj_file.boj10,
    l_boj01_b       DYNAMIC ARRAY OF LIKE boj_file.boj01,
    l_boj04_b       DYNAMIC ARRAY OF LIKE boj_file.boj04,
    l_boj05_b       DYNAMIC ARRAY OF LIKE boj_file.boj05,
    l_boj09_b       DYNAMIC ARRAY OF LIKE boj_file.boj09,
    l_bojuser_b       DYNAMIC ARRAY OF LIKE boj_file.bojuser,
    l_bojgrup_b       DYNAMIC ARRAY OF LIKE boj_file.bojgrup,
    l_bojacti_b       DYNAMIC ARRAY OF LIKE boj_file.bojacti,
    g_bok11         LIKE  bok_file.bok11,
    g_bok13         LIKE  bok_file.bok13,
    g_bok34         LIKE  bok_file.bok34,
    g_bok23         LIKE  bok_file.bok23,
    g_bok10_fac     LIKE  bok_file.bok10_fac,
    g_bok10_fac2    LIKE  bok_file.bok10_fac2,
    g_bok15         LIKE  bok_file.bok15,
    g_bok18         LIKE  bok_file.bok18,
    g_bok17         LIKE  bok_file.bok17,
    g_bok27         LIKE  bok_file.bok27,
    g_bok28         LIKE  bok_file.bok28,
    g_bok20         LIKE  bok_file.bok20,
    g_bok19         LIKE  bok_file.bok19,
    g_bok21         LIKE  bok_file.bok21,
    g_bok22         LIKE  bok_file.bok22,
    g_bok25         LIKE  bok_file.bok25,
    g_bok26         LIKE  bok_file.bok26,
    g_bok11_o       LIKE  bok_file.bok11,
    g_bok13_o       LIKE  bok_file.bok13,
    g_bok34_o       LIKE  bok_file.bok34,
    g_bok23_o       LIKE  bok_file.bok23,
    g_bok25_o       LIKE  bok_file.bok23,
    g_bok26_o       LIKE  bok_file.bok23,
    g_bok10_fac_o   LIKE  bok_file.bok10_fac,
    g_bok10_fac2_o  LIKE  bok_file.bok10_fac2,
    g_bok15_o       LIKE  bok_file.bok15,
    g_bok18_o       LIKE  bok_file.bok18,
    g_bok17_o       LIKE  bok_file.bok17,
    g_bok27_o       LIKE  bok_file.bok27,
    g_bok20_o       LIKE  bok_file.bok20,
    g_bok19_o       LIKE  bok_file.bok19,
    g_bok21_o       LIKE  bok_file.bok21,
    g_bok22_o       LIKE  bok_file.bok22,
    g_ima01         LIKE  ima_file.ima01,
    g_sql           string,                  
    g_wc,g_wc2,g_wc3      string,                 
    g_vdate         LIKE type_file.dat,      
    g_sw            LIKE type_file.num5,       #單位是否可轉換
    g_factor        LIKE ima_file.ima31_fac,   #單位換算率
    g_t1            LIKE oay_file.oayslip,
    g_cmd           LIKE type_file.chr1000,  
    g_aflag         LIKE type_file.chr1,    
    g_modify_flag   LIKE type_file.chr1,    
    g_tipstr        LIKE ze_file.ze03,       
    g_ecd02         LIKE ecd_file.ecd02,
    g_rec_b         LIKE type_file.num5,       #單身筆數
    l_ac            LIKE type_file.num5,       #目前處理的ARRAY CNT
    l_sl            LIKE type_file.num5        #目前處理的SCREEN LINE
DEFINE p_row,p_col  LIKE type_file.num5     
       
DEFINE
   g_value ARRAY[20] OF RECORD
            fname     LIKE type_file.chr5,    #欄位名稱，從'att01'~'att10'
            imx000    LIKE imx_file.imx000,   #該欄位在imx_file中對應的欄位名稱
            visible   LIKe type_file.chr1,    #是否可見，'Y'或'N'
            nvalue    STRING,
            value     STRING  #存放當前當前組值
            END RECORD
 
DEFINE   lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.* 
 
DEFINE   l_chk_boa     LIKE type_file.chr1,      
         l_chk_bob     LIKE type_file.chr1      
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_sql_tmp    STRING   
DEFINE   g_chr           LIKE type_file.chr1    
DEFINE   g_chr2          LIKE type_file.chr1    
DEFINE   g_cnt           LIKE type_file.num10  
DEFINE   g_level         LIKE type_file.num5  
DEFINE   g_msg           LIKE ze_file.ze03   
DEFINE   g_status        LIKE type_file.num5
DEFINE   g_row_count     LIKE type_file.num10  
DEFINE   g_curs_index    LIKE type_file.num10 
DEFINE   g_jump          LIKE type_file.num10  
DEFINE   mi_no_ask       LIKE type_file.num5  
DEFINE   g_before_input_done   LIKE type_file.num5  
DEFINE   g_itm DYNAMIC ARRAY OF RECORD 
                  db      LIKE type_file.chr20,  
                  tblname LIKE cre_file.cre08,   
                  ima01   LIKE ima_file.ima01,
                  ima02   LIKE ima_file.ima02
               END RECORD
DEFINE   b_bok           RECORD LIKE bok_file.*
DEFINE   l_bok13         LIKE ze_file.ze03             #No.FUN-830114
DEFINE   g_void          LIKE type_file.chr1  #CHI-C80041
 
MAIN
DEFINE  p_sma121  LIKE sma_file.sma121          
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的                                            #順序(忽略4gl寫的順序)  
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_db_type=cl_db_get_database_type() 
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql =
       "SELECT * FROM boj_file WHERE boj01=? AND boj09=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i616_cl CURSOR FROM g_forupd_sql
 
    CALL s_decl_bmb()
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time    
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW i616_w AT p_row,p_col WITH FORM "abm/42f/abmi616"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    IF s_industry('slk') THEN                                                                                                       
        CALL cl_set_comp_visible("boj06",g_sma.sma118='Y')
    ELSE
        CALL cl_set_comp_visible("boj06,bok30",g_sma.sma118='Y') 
    END IF
    IF s_industry('slk') THEN
        SELECT  ze03  INTO l_bok13 FROM ze_file WHERE ze01 = 'abmi600' AND ze02 = g_lang   #No.FUN-830114                                         
        CALL cl_set_comp_att_text("bok13",l_bok13)                                         #No.FUN-830114
    END IF
    SELECT ze03 INTO g_tipstr FROM ze_file WHERE
      ze01 = 'lib-294' AND ze02 = g_lang
 
    CALL i616_menu()
 
    CLOSE WINDOW i616_w                  #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
    RETURNING g_time    
END MAIN
 
#QBE 查詢資料
FUNCTION i616_curs()
DEFINE l_flag      LIKE type_file.chr1   #判斷單身是否給條件
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    
 
    CLEAR FORM                            #清除畫面
    CALL g_bok.clear()
    LET l_flag = 'N'
 IF g_wc IS NULL THEN 
    CALL cl_set_head_visible("","YES")      
   INITIALIZE g_boj.* TO NULL    
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
        boj09,boj11,boj01,boj06,boj04,boj05,bojuser,
        bojgrup,bojmodu,bojdate,bojacti,boj10                                         
 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(boj09) #查詢單                                      
               CALL cl_init_qry_var()                                        
                  LET g_qryparam.form = "q_boj09"                                 
                  LET g_qryparam.state = 'c'                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret            
                  DISPLAY g_qryparam.multiret TO boj09                          
                  NEXT FIELD boj09
               WHEN INFIELD(boj01)
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = "q_ima"
                #  LET g_qryparam.state = 'c'
                #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO boj01
                  NEXT FIELD boj01
               OTHERWISE EXIT CASE
             END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bojuser', 'bojgrup')
 
 
    CALL cl_set_head_visible("","YES")            #No.FUN-6B0033
 
       CONSTRUCT g_wc2 ON bok32,bok02,bok30,bok03,bok09,bok16,bok14,bok04, 
                          bok05,bok06,bok07,bok10,bok08,bok19,bok24,bok13
                               
            FROM s_bok[1].bok32,s_bok[1].bok02,s_bok[1].bok30,s_bok[1].bok03, 
                 s_bok[1].bok09,s_bok[1].bok16,s_bok[1].bok14,s_bok[1].bok04,
                 s_bok[1].bok05,s_bok[1].bok06,s_bok[1].bok07,s_bok[1].bok10,
                 s_bok[1].bok08,s_bok[1].bok19,s_bok[1].bok24,s_bok[1].bok13
      BEFORE CONSTRUCT
        CALL cl_qbe_display_condition(lc_qbe_sn)
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bok03) #料件主檔
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.form = "q_ima"
                #   LET g_qryparam.state = 'c'
                #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                   DISPLAY g_qryparam.multiret TO bok03
                   NEXT FIELD bok03
              WHEN INFIELD(bok09) #作業主檔
                   CALL q_ecd(TRUE,TRUE,g_bok[1].bok09)
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bok09
                     NEXT FIELD bok09
              WHEN INFIELD(bok10) #單位檔
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO bok10
                   NEXT FIELD bok10
              WHEN INFIELD(bok13)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_bmb13"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO bok13
                   NEXT FIELD bok13
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
   END IF
            IF g_wc2 != " 1=1" THEN LET l_flag = 'Y' END IF
            IF INT_FLAG THEN RETURN END IF
    IF l_flag = 'N' THEN   # 若單身未輸入條件
       LET g_sql = "SELECT  boj09,boj01 FROM boj_file ",        
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1 " 
     ELSE     # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  boj09,boj01 ",      
                   "  FROM boj_file, bok_file ",
                   " WHERE boj09 = bok31",
                   "   AND boj01 = bok01",
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
                   " ORDER BY 1 " 
    END IF
 
    PREPARE i616_prepare FROM g_sql
    DECLARE i616_curs
        SCROLL CURSOR WITH HOLD FOR i616_prepare
    IF l_flag = 'N' THEN   # 取合乎條件筆數
        LET g_sql_tmp="SELECT UNIQUE boj09,boj01 FROM boj_file WHERE ",g_wc CLIPPED,  
                  "  INTO TEMP x"
    ELSE
        LET g_sql_tmp="SELECT UNIQUE boj09,boj01 FROM boj_file,bok_file WHERE ",  
                  "bok31=boj09 AND bok01=boj01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  "  INTO TEMP x"
    END IF
    DROP TABLE x
    PREPARE i616_precount_x FROM g_sql_tmp  
    EXECUTE i616_precount_x
 
    LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE i616_precount FROM g_sql
    DECLARE i616_count CURSOR FOR i616_precount
END FUNCTION
 
FUNCTION i616_menu()
   DEFINE
      l_cmd           LIKE type_file.chr1000,  
      l_priv1         LIKE zy_file.zy03,       # 使用者執行權限
      l_priv2         LIKE zy_file.zy04,       # 使用者資料權限
      l_priv3         LIKE zy_file.zy05,       # 使用部門資料權限
      l_ima903        LIKE ima_file.ima903
   IF s_industry("slk") THEN
      CALL cl_getmsg("abm-603",2) RETURNING g_msg
      CALL i616_set_act_title("insert_loc",g_msg)
   END IF
 
   WHILE TRUE
      CALL i616_bp("G")
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i616_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
                LET g_wc='' #MOD-530690
               CALL i616_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i616_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i616_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i616_x()
               IF g_boj.boj10 = '1' OR g_boj.boj10 = '2' THEN
                  LET g_chr2 = 'Y'
               ELSE
                  LET g_chr2 = 'N'
               END IF
               CALL cl_set_field_pic("",g_chr2,"","","",g_boj.bojacti)
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                CALL i616_copy() 
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
                CALL i616_confirm()
            END IF
         WHEN "confirma"    #整批審核
            IF cl_chk_act_auth() THEN
                CALL i616_confirma()
            END IF
 
         WHEN "unconfirm"
           IF cl_chk_act_auth() THEN
               CALL i616_unconfirm()
           END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i616_b()
               IF g_ima08_h = 'A' AND g_boj.boj01 IS NOT NULL THEN
                  CALL p500_tm(0,0,g_boj.boj09)      
               END IF
            END IF
            LET g_action_choice = ""
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "發放"
         WHEN "bom_release"     
            IF cl_chk_act_auth() THEN
               CALL i616_j()
            END IF
     #TQC-BB0186--add--begin--
       #@WHEN "發放還原"
         WHEN "bom_reduction"
            IF cl_chk_act_auth() THEN
               CALL i616_rj()
            END IF
     #TQC-BB0186--add--end--

       #@WHEN "整批發放"
         WHEN "bom_release_b"     
            IF cl_chk_act_auth() THEN
               CALL i616_jb()
            END IF
         WHEN "insert_loc"
           LET l_cmd = "abmi618 '",g_boj.boj01,"' ",
                               "'",g_boj.boj09,"'",
                               " '' "      #No.FUN-870117
           CALL cl_cmdrun_wait(l_cmd)
           CALL i616_show()

       WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_boj.boj09 IS NOT NULL THEN
                LET g_doc.column1 = "boj09"
                LET g_doc.value1  = g_boj.boj09
                CALL cl_doc()
             END IF
          END IF
 
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bok),'','')
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
             # CALL i616_v()    #CHI-D20010
               CALL i616_v(1)   #CHI-D20010
               IF g_boj.boj10 = '1' OR g_boj.boj10 = '2' THEN
                  LET g_chr2 = 'Y'
               ELSE
                  LET g_chr2 = 'N'
               END IF
               IF g_boj.boj10 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF 
               CALL cl_set_field_pic("",g_chr2,"","",g_void,g_boj.bojacti)
            END IF
         #CHI-C80041---end
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
             # CALL i616_v()    #CHI-D20010
               CALL i616_v(2)   #CHI-D20010
               IF g_boj.boj10 = '1' OR g_boj.boj10 = '2' THEN
                  LET g_chr2 = 'Y'
               ELSE
                  LET g_chr2 = 'N'
               END IF
               IF g_boj.boj10 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF
               CALL cl_set_field_pic("",g_chr2,"","",g_void,g_boj.bojacti)
            END IF
         #CHI-D20010---end
      END CASE
   END WHILE
END FUNCTION
 
 
#Add  輸入
FUNCTION i616_a()
DEFINE li_result  LIKE type_file.num5
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_bok.clear()
    INITIALIZE g_boj.* LIKE boj_file.*             #DEFAULT 設定
    LET g_boj09_t = NULL
    LET g_boj01_t = NULL
    #預設值及將數值類變數清成零
    LET g_boj_t.* = g_boj.*
    LET g_boj_o.* = g_boj.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_boj.bojuser=g_user
        LET g_boj.bojoriu = g_user #FUN-980030
        LET g_boj.bojorig = g_grup #FUN-980030
        LET g_boj.boj10 = 0      
        LET g_boj.boj08 = " " 
        LET g_boj.bojgrup=g_grup
        LET g_boj.bojdate=g_today
        LET g_boj.bojacti='Y'              #資料有效
           LET g_boj.boj06 = ' '           # 特性代碼
        CALL i616_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_boj.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_boj.boj09 IS NULL THEN                # KEY 不可空白                                                                   
            CONTINUE WHILE                                                                                                          
        END IF
        BEGIN WORK 
        CALL s_auto_assign_no("abm",g_boj.boj09,g_boj.boj11,"4","boj_file","boj09","","","")
        RETURNING li_result,g_boj.boj09 
        IF (NOT li_result) THEN                                                                                                     
           CONTINUE WHILE                                                                                                           
        END IF                                                                                                                      
        DISPLAY BY NAME g_boj.boj09
        IF cl_null(g_boj.boj10) THEN
           LET g_boj.boj10 = '0'
        END IF
        IF g_boj.boj06 IS NULL THEN
           LET g_boj.boj06 = ' '
        END IF
        INSERT INTO boj_file VALUES (g_boj.*)
        IF SQLCA.sqlcode THEN      #置入資料庫不成功
            CALL cl_err3("ins","boj_file",g_boj.boj09,"",SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
            CONTINUE WHILE
         ELSE                                                                                                                        
           COMMIT WORK                                                                                                      
           CALL cl_flow_notify(g_boj.boj09,'I')                                                                                     
        END IF
        SELECT boj01,boj09 INTO g_boj.boj01,g_boj.boj09 FROM boj_file
            WHERE boj09 = g_boj.boj09
              AND boj01 = g_boj.boj01
        LET g_boj09_t = g_boj.boj09        #保留舊值
        LET g_boj01_t = g_boj.boj01
        LET g_boj_t.* = g_boj.*
        CALL g_bok.clear()
        LET g_rec_b = 0
 
        CALL i616_b()                   #輸入單身
        IF g_ima08_h = 'A' AND g_aflag = 'Y' THEN      #主件為family 時
           CALL p500_tm(0,0,g_boj.boj09)
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i616_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_boj.boj09 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_boj.bojacti ='N' THEN    #資料若為無效,仍可更改.   
        CALL cl_err(g_boj.boj09,'mfg1000',0) RETURN         
    END IF                                                 
    IF g_boj.boj10 = 1  THEN
       CALL cl_err('','9023',0)
       RETURN
    END IF
    IF g_boj.boj10 = 2 THEN
       CALL cl_err('','abm-123',0)
       RETURN
    END IF
    IF g_boj.boj10 = 'X' THEN RETURN END IF  #CHI-C80041
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_boj09_t = g_boj.boj09
    LET g_boj01_t = g_boj.boj01
    BEGIN WORK
 
    OPEN i616_cl USING g_boj.boj01,g_boj.boj09
    IF STATUS THEN
       CALL cl_err("OPEN i616_cl:", STATUS, 1)
       CLOSE i616_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i616_cl INTO g_boj.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_boj.boj09,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i616_cl
         ROLLBACK WORK #MOD-4B0218
        RETURN
    END IF
    CALL i616_show()
    WHILE TRUE
        LET g_boj09_t = g_boj.boj09
        LET g_boj01_t = g_boj.boj01
        LET g_boj.bojmodu=g_user
        LET g_boj.bojdate=g_today
        CALL i616_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_boj.*=g_boj_t.*
            CALL i616_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_boj.boj09 != g_boj09_t  THEN            # 更改單號 
            UPDATE bok_file SET bok31 = g_boj.boj09,
                                bok01 = g_boj.boj01
                WHERE bok31 = g_boj09_t
                  AND bok01 = g_boj01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","bok_file",g_boj09_t,"",SQLCA.sqlcode,"","bok",1)  
                CONTINUE WHILE   
            ELSE #新增料件時系統參數(sma18 低階碼是重新計算)
                 UPDATE sma_file SET sma18 = 'Y' WHERE sma00 = '0'
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","cannot update sma_file",1)  
                 END IF
            END IF
        END IF
             UPDATE boj_file SET boj_file.* = g_boj.*
              WHERE boj01=g_boj01_t AND boj09=g_boj09_t      
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","boj_file",g_boj09_t,"",SQLCA.sqlcode,"","",1)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i616_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i616_i(p_cmd)
DEFINE
    p_cmd     LIKE type_file.chr1,     # VARCHAR(1),    #a:輸入 u:更改
    l_cmd     LIKE type_file.chr50     # VARCHAR(40)
DEFINE li_result LIKE type_file.num5  
DEFINE l_cnt     LIKE type_file.num10
 
    DISPLAY BY NAME g_boj.boj05,g_boj.boj10,g_boj.bojuser,g_boj.bojmodu,   
                    g_boj.bojgrup,g_boj.bojdate,g_boj.bojacti
    CALL cl_set_head_visible("","YES")     
    INPUT BY NAME g_boj.boj09,g_boj.boj11,g_boj.boj01,g_boj.boj06, g_boj.bojoriu,g_boj.bojorig,
                  g_boj.boj10,g_boj.boj04
        WITHOUT DEFAULTS
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i616_i_set_entry(p_cmd)
            CALL i616_i_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("boj09")
             
        AFTER FIELD boj09                         #主件料號
            IF NOT cl_null(g_boj.boj09) THEN                                                                                        
            CALL s_check_no("abm",g_boj.boj09,g_boj_t.boj09,"4","boj_file","boj09","")                                              
            RETURNING li_result,g_boj.boj09                                                                                         
            DISPLAY BY NAME g_boj.boj09
            IF(NOT li_result) THEN                                                                                                  
               LET g_boj.boj09=g_boj_o.boj09                                                                                        
               DISPLAY BY NAME g_boj.boj09                                                                                          
            END IF
            END IF
       BEFORE FIELD boj01                                                                                                          
            IF p_cmd = 'u' AND g_chkey matches'[Nn]' THEN                                                                           
               NEXT FIELD boj04                                                                                                     
            END IF                                                                                                                  
            IF g_sma.sma60 = 'Y'  # 若須分段輸入                                                                                    
               THEN CALL s_inp5(6,11,g_boj.boj01) RETURNING g_boj.boj01                                                             
                  DISPLAY BY NAME g_boj.boj01                                                                                       
            END IF
       AFTER FIELD boj01
                #FUN-AA0059 --------------------------add start-----------------
                IF NOT cl_null(g_boj.boj01) THEN
                   IF NOT s_chk_item_no(g_boj.boj01,'') THEN
                      CALL cl_err('',g_errno,1)
                      LET g_boj.boj01 = g_boj_o.boj01
                      DISPLAY BY NAME g_boj.boj01
                      NEXT FIELD boj01
                   END IF
                END IF    
                #FUN-AA0059 ---------------------------add end----------------------
                IF g_boj.boj01 != g_boj01_t OR g_boj01_t IS NULL THEN      
                   CALL i616_boj01('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_boj.boj01,g_errno,0)
                      LET g_boj.boj01 = g_boj_o.boj01
                      DISPLAY BY NAME g_boj.boj01
                      NEXT FIELD boj01
                   END IF
                END IF     
                SELECT count(*) INTO l_cnt FROM ima_file 
                WHERE ima01=g_boj.boj01 and ima151='Y'
                IF l_cnt>0 THEN
                   CALL cl_err('','abm-124',0)
                   NEXT FIELD boj01
                END IF
 
        AFTER FIELD boj06                         #特性代碼
               IF cl_null(g_boj.boj06) THEN
                   LET g_boj.boj06 = ' '
               END IF
            NEXT FIELD  boj10                              
 
     
        AFTER INPUT
           LET g_boj.bojuser = s_get_data_owner("boj_file") #FUN-C10039
           LET g_boj.bojgrup = s_get_data_group("boj_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF

        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP     #查詢條件
            CASE
               WHEN INFIELD(boj09)                                                                                           
                   LET g_t1=s_get_doc_no(g_boj.boj09)                                                                              
                    CALL q_smy(FALSE,FALSE,g_t1,'ABM','4') RETURNING g_t1
                   LET g_boj.boj09 = g_t1
                   DISPLAY BY NAME g_boj.boj09                                                                                     
                    NEXT FIELD boj09
               WHEN INFIELD(boj01) #料件主檔
#FUN-AA0059 --Begin--
                  #  CALL cl_init_qry_var()
                  #  LET g_qryparam.form = "q_ima"
                  #  LET g_qryparam.default1 = g_boj.boj01
                  #  CALL cl_create_qry() RETURNING g_boj.boj01
                    CALL q_sel_ima(FALSE, "q_ima", "", g_boj.boj01, "", "", "", "" ,"",'' )  RETURNING g_boj.boj01
#FUN-AA0059 --End--
                    DISPLAY BY NAME g_boj.boj01
                    NEXT FIELD boj01
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
 
FUNCTION i616_boj01(p_cmd)  #主件料件
    DEFINE p_cmd     LIKE type_file.chr1,   
           l_bmz01   LIKE bmz_file.bmz01,
           l_bmz03   LIKE bmz_file.bmz03,
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima55   LIKE ima_file.ima55,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT  ima02,ima021,ima55, ima08,imaacti
       INTO l_ima02,l_ima021,l_ima55, g_ima08_h,l_imaacti
       FROM ima_file
      WHERE ima01 = g_boj.boj01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2602'
                            LET l_ima02 = NULL LET l_ima021 = NULL
                            LET l_ima55 = NULL LET g_ima08_h = NULL
                            LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    #--->來源碼為'Z':雜項料件
    IF g_ima08_h ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ima02   TO FORMONLY.ima02_h
           DISPLAY l_ima021  TO FORMONLY.ima021_h
           DISPLAY g_ima08_h TO FORMONLY.ima08_h
           DISPLAY l_ima55   TO FORMONLY.ima55
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION i616_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_boj.* TO NULL             
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_bok.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL cl_getmsg('mfg2618',g_lang) RETURNING g_msg
    CALL i616_curs()
    IF INT_FLAG THEN
        INITIALIZE g_boj.* TO NULL
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i616_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_boj.* TO NULL
    ELSE
        OPEN i616_count
        FETCH i616_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i616_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
    MESSAGE " "
END FUNCTION
 
FUNCTION i616_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1           #處理方式
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i616_curs INTO g_boj.boj09,g_boj.boj01
        WHEN 'P' FETCH PREVIOUS i616_curs INTO g_boj.boj09,g_boj.boj01
        WHEN 'F' FETCH FIRST    i616_curs INTO g_boj.boj09,g_boj.boj01
        WHEN 'L' FETCH LAST     i616_curs INTO g_boj.boj09,g_boj.boj01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i616_curs INTO g_boj.boj09,g_boj.boj01
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_boj.boj09,SQLCA.sqlcode,0)
       INITIALIZE g_boj.* TO NULL   
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
    SELECT * INTO g_boj.* FROM boj_file WHERE boj01=g_boj.boj01 AND boj09=g_boj.boj09
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","boj_file",g_boj.boj09,"",SQLCA.sqlcode,"","",1)  
        INITIALIZE g_boj.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_boj.bojuser      
        LET g_data_group = g_boj.bojgrup     
    END IF
    CALL i616_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i616_show()
DEFINE l_count    LIKE type_file.num5    # SMALLINT
 
    LET g_boj_t.* = g_boj.*                #保存單頭舊值
    DISPLAY BY NAME g_boj.bojoriu,g_boj.bojorig,                              # 顯示單頭值
        g_boj.boj09,g_boj.boj11,g_boj.boj01,g_boj.boj06,g_boj.boj10,g_boj.boj04,g_boj.boj05, 
        g_boj.bojuser,g_boj.bojgrup,g_boj.bojmodu,
        g_boj.bojdate,g_boj.bojacti
 
 
    #圖形顯示
    IF g_boj.boj10 = '1' OR g_boj.boj10 = '2' THEN
       LET g_chr2 = 'Y'
    ELSE
       LET g_chr2 = 'N'
    END IF
    #CALL cl_set_field_pic("",g_chr2,"","","",g_boj.bojacti)  #CHI-C80041
    IF g_boj.boj10 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF  #CHI-C80041
    CALL cl_set_field_pic("",g_chr2,"","",g_void,g_boj.bojacti)  #CHI-C80041
    CALL i616_boj01('d')
    CALL i616_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION i616_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_boj.boj09 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i616_cl USING g_boj.boj01,g_boj.boj09
    IF STATUS THEN
       CALL cl_err("OPEN i616_cl:", STATUS, 1)
       CLOSE i616_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i616_cl INTO g_boj.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_boj.boj09,SQLCA.sqlcode,0)          #資料被他人LOCK
        RETURN
    END IF
    CALL i616_show()
    IF cl_exp(0,0,g_boj.bojacti) THEN
        LET g_chr=g_boj.bojacti
        IF g_boj.bojacti='Y' THEN
            LET g_boj.bojacti='N'
        ELSE
            LET g_boj.bojacti='Y'
        END IF
        UPDATE boj_file                    #更改有效碼
            SET bojacti=g_boj.bojacti,
                bojmodu=g_user,                                                                                           
                bojdate=g_today
            WHERE boj09=g_boj.boj09
              AND boj01=g_boj.boj01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","boj_file",g_boj.boj09,"",SQLCA.sqlcode,"","",1)  
            LET g_boj.bojacti=g_chr
        END IF
        DISPLAY BY NAME g_boj.bojacti
    END IF
    CLOSE i616_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i616_j()
   DEFINE l_bok31  LIKE bok_file.bok31
   DEFINE l_bok32  LIKE bok_file.bok32
   DEFINE l_bok01  LIKE bok_file.bok01
   DEFINE l_bok02  LIKE bok_file.bok02
   DEFINE l_bok03  LIKE bok_file.bok03
   DEFINE l_bok04  LIKE bok_file.bok04
   DEFINE l_bok33  LIKE bok_file.bok33    #No.FUN-850017
   DEFINE l_n LIKE type_file.num10
   DEFINE l_n1 LIKE type_file.num10
   DEFINE l_bmh05  LIKE bmh_file.bmh05     #No.FUN-870117
   DEFINE l_bmh06  LIKE bmh_file.bmh06     #No.FUN-870117
   DEFINE l_bmh07  LIKE bmh_file.bmh07     #No.FUN-870117
 
    IF s_shut(0) THEN RETURN END IF
    IF g_boj.boj09 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_boj.boj10 = 0 THEN CALL cl_err('','aco-174',0) RETURN END IF   
    IF g_boj.boj10 = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_boj.bojacti='N' THEN
       CALL cl_err(g_boj.bojacti,'aap-127',0) RETURN
    END IF
    IF NOT cl_null(g_boj.boj05) THEN
       CALL cl_err(g_boj.boj05,'abm-003',0) RETURN
    END IF
    SELECT COUNT(*) INTO g_cnt FROM bok_file WHERE bok31 = g_boj.boj09
                                               AND bok01 = g_boj.boj01
    IF g_cnt=0 THEN
       CALL cl_err(g_boj.boj09,'arm-034',0) RETURN
    END IF
    BEGIN WORK
 
    OPEN i616_cl USING g_boj.boj01,g_boj.boj09
    IF STATUS THEN
       CALL cl_err("OPEN i616_cl:", STATUS, 1)
       CLOSE i616_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i616_cl INTO g_boj.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_boj.boj09,SQLCA.sqlcode,0) RETURN
    END IF
    CALL i616_show()
    IF NOT cl_confirm('abm-004') THEN RETURN END IF
    LET g_boj.boj05=g_today
    CALL cl_set_head_visible("","YES")   
    INPUT BY NAME g_boj.boj05 WITHOUT DEFAULTS
 
      AFTER FIELD boj05
        IF cl_null(g_boj.boj05) THEN NEXT FIELD boj05 END IF
 
      AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
        IF cl_null(g_boj.boj05) THEN NEXT FIELD boj05 END IF
 
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
       LET g_boj.boj05=NULL
       DISPLAY BY NAME g_boj.boj05
       LET INT_FLAG=0
       ROLLBACK WORK
       RETURN
    END IF
    UPDATE boj_file SET boj05=g_boj.boj05,
                        boj10='2',
                        bojmodu=g_user,
                        bojdate=g_today          
                   WHERE boj09=g_boj.boj09
                     AND boj01=g_boj.boj01
    IF SQLCA.SQLERRD[3]=0 THEN
       LET g_boj.boj05=NULL
       DISPLAY BY NAME g_boj.boj05
       CALL cl_err3("upd","boj_file",g_boj.boj09,"",SQLCA.sqlcode,"","up boj05",1)  
       ROLLBACK WORK
       RETURN
    END IF
    DECLARE i616_up_cs CURSOR FOR
      SELECT bok31,bok32,bok01,bok02,bok03,bok04
        FROM bok_file
      WHERE bok31 = g_boj.boj09
        AND bok01 = g_boj.boj01
        AND (bok05 > g_boj.boj05 OR bok05 IS NULL )
   FOREACH i616_up_cs INTO l_bok31,l_bok32,l_bok01,l_bok02,l_bok03,l_bok04
       UPDATE bok_file
          SET bok04 = g_boj.boj05
        WHERE bok31 = l_bok31
          AND bok32 = l_bok32
          AND bok01 = l_bok01
       IF SQLCA.SQLERRD[3]=0 THEN
          LET g_boj.boj05=NULL
          DISPLAY BY NAME g_boj.boj05
          CALL cl_err3("upd","bok_file",l_bok01,l_bok02,SQLCA.sqlcode,"","up bok04",1)  
          ROLLBACK WORK
          EXIT FOREACH
       END IF

       UPDATE bmh_file
          SET bmh04 = g_boj.boj05
        WHERE bmh01 = l_bok01
          AND bmh09 = l_bok31
          AND bmh10 = l_bok32
       IF SQLCA.sqlcode THEN
          LET g_boj.boj05=NULL
          DISPLAY BY NAME g_boj.boj05
          CALL cl_err3("upd","bmh_file",l_bok01,l_bok02,SQLCA.sqlcode,"","up bmh04",1)  
          LET g_success = 'N'
          EXIT FOREACH
       END IF
   END FOREACH

    LET g_wc2 = "     (bok04 <='", g_boj.boj05,"'"," OR bok04 IS NULL )",
                " AND (bok05 >  '",g_boj.boj05,"'"," OR bok05 IS NULL )"
    LET g_wc2 = g_wc2 CLIPPED
    SELECT boj10,bojmodu,bojdate INTO g_boj.boj10,g_boj.bojmodu,g_boj.bojdate 
      FROM boj_file WHERE boj09=g_boj.boj09
                      AND boj01=g_boj.boj01

    SELECT count(*) INTO l_n FROM bma_file
     WHERE bma01=g_boj.boj01
       AND bma06=g_boj.boj06
    IF l_n > 0 THEN
       CALL cl_err('','',0)
    ELSE
       LET g_boj.boj08 = " "
       IF cl_null(g_boj.boj10) THEN
        LET g_boj.boj10 = '0'
       END IF
       IF cl_null(g_boj.boj06) THEN
          LET g_boj.boj06 = ' '
       END IF
       INSERT INTO bma_file(bma01,bma06,bma08,bma10,bma04,bma05,bmauser,bmagrup,bmaacti,bmaoriu,bmaorig)
       VALUES(g_boj.boj01,g_boj.boj06,g_boj.boj08,g_boj.boj10,
              g_boj.boj04,g_boj.boj05,g_boj.bojuser,g_boj.bojgrup,
              g_boj.bojacti, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","bma_file",g_boj.boj09,"",SQLCA.sqlcode,"","",0)
          ROLLBACK WORK
       END IF
    END IF
    DECLARE i616_up_cs1 CURSOR FOR 
    SELECT bok02,bok04,bok13,bok30,bok03,bok09,bok16,bok14,
           bok05,bok06,bok07,bok10,bok08,bok19,bok24,bok34,bok32    #No.FUN-850017
      FROM bok_file
     WHERE bok31 = g_boj.boj09                                                                                                     
       AND bok01 = g_boj.boj01
    LET g_success = 'Y'
    FOREACH i616_up_cs1 INTO g_bok[l_ac].bok02,g_bok[l_ac].bok04,g_bok[l_ac].bok13,
                             g_bok[l_ac].bok30,g_bok[l_ac].bok03,g_bok[l_ac].bok09,
                             g_bok[l_ac].bok16,g_bok[l_ac].bok14,g_bok[l_ac].bok05,
                             g_bok[l_ac].bok06,g_bok[l_ac].bok07,g_bok[l_ac].bok10,
                             g_bok[l_ac].bok08,g_bok[l_ac].bok19,g_bok[l_ac].bok24,
                             g_bok[l_ac].bok34,g_bok[l_ac].bok32    #No.FUN-850017
    SELECT count(*) INTO l_n1 FROM bmb_file
     WHERE bmb03=g_bok[l_ac].bok03 
       AND bmb01=g_boj.boj01
       AND bmb29=g_boj.boj06
       AND bmb02=g_bok[l_ac].bok02
       AND bmb04=g_bok[l_ac].bok04
       AND bmb13=g_bok[l_ac].bok13
    IF l_n1 > 0 THEN
       CALL cl_err('','mfg-240',0)
    ELSE
       SELECT bok33 INTO l_bok33 FROM bok_file
        WHERE bok31 = g_boj.boj09
          AND bok01 = g_boj.boj01
          AND bok32 = g_bok[l_ac].bok32
       IF cl_null(l_bok33) THEN LET l_bok33 = 0 END IF
       IF cl_null(g_boj.boj06) THEN LET g_boj.boj06 = ' ' END IF #NO.FUN-870127add
       INSERT INTO bmb_file(bmb01,bmb29,bmb02,bmb30,bmb03,bmb09,bmb16,bmb14,bmb04,
                            bmb05,bmb06,bmb07,bmb10,bmb08,bmb19,bmb24,bmb13,bmb31,bmb33,bmb081,bmb082) #No.TQC-BC0166 add bmb081,bmb082
       VALUES(g_boj.boj01,g_boj.boj06,g_bok[l_ac].bok02,g_bok[l_ac].bok30,g_bok[l_ac].bok03,
              g_bok[l_ac].bok09,g_bok[l_ac].bok16,g_bok[l_ac].bok14,g_bok[l_ac].bok04,
              g_bok[l_ac].bok05,g_bok[l_ac].bok06,g_bok[l_ac].bok07,g_bok[l_ac].bok10,
              g_bok[l_ac].bok08,g_bok[l_ac].bok19,g_bok[l_ac].bok24,g_bok[l_ac].bok13,g_bok[l_ac].bok34,l_bok33,0,0) #No.TQC-BC0166 add 0,0
       IF SQLCA.sqlcode THEN                                                                                                        
          CALL cl_err3("ins","bmb_file",g_boj.boj09,g_bok[l_ac].bok03,SQLCA.sqlcode,"","",0)                                                                                                                                                                             
          LET g_success = 'N'
       END IF

       DECLARE i616_bmt_curs CURSOR FOR 
       SELECT bmh05,bmh06,bmh07  
         FROM bmh_file WHERE bmh01 = g_boj.boj01 AND bmh09 = g_boj.boj09
                         AND bmh10 = g_bok[l_ac].bok32
       FOREACH i616_bmt_curs INTO  l_bmh05,l_bmh06,l_bmh07 
        INSERT INTO bmt_file
          VALUES(g_boj.boj01,g_bok[l_ac].bok02,g_bok[l_ac].bok03,g_bok[l_ac].bok04,
                l_bmh05,l_bmh06,l_bmh07,g_boj.boj06)               
       
       IF SQLCA.sqlcode THEN                                                                                                        
          CALL cl_err3("ins","bmt_file",g_boj.boj09,"",SQLCA.sqlcode,"","",0)           
          LET g_success = 'N' 
          EXIT FOREACH                                            
       END IF
       END FOREACH 

       UPDATE bma_file SET bmamodu = g_user,
                           bmadate = g_today
       WHERE bma01 = g_boj.boj01
         AND bma06 = g_boj.boj06
       IF SQLCA.sqlcode THEN                                                                                                        
          CALL cl_err3("upd","bma_file",g_boj.boj09,"",SQLCA.sqlcode,"","",0)                                                                                                                                                                             
          LET g_success = 'N'
       END IF
    END IF
    LET l_ac=l_ac+1    #No.FUN-830114
   END FOREACH
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      DISPLAY BY NAME g_boj.boj05
      DISPLAY BY NAME g_boj.boj10
      DISPLAY BY NAME g_boj.bojmodu
      DISPLAY BY NAME g_boj.bojdate
      COMMIT WORK
   END IF
 
END FUNCTION
 
#整批發放
FUNCTION i616_jb()
   DEFINE l_boj        RECORD LIKE boj_file.*,
          l_sql1       STRING,
          l_i          LIKE type_file.num5,
          l_x          LIKE type_file.num5,
          l_n          LIKE type_file.num5,
          l_n1         LIKE type_file.num5
  DEFINE l_bok31       LIKE bok_file.bok31
  DEFINE l_bok32       LIKE bok_file.bok32
  DEFINE l_bok01       LIKE bok_file.bok01
  DEFINE l_bok02       LIKE bok_file.bok02
  DEFINE l_bok03       LIKE bok_file.bok03
  DEFINE l_bok04       LIKE bok_file.bok04
  DEFINE l_flag1       LIKE type_file.chr1
  DEFINE l_bmh05  LIKE bmh_file.bmh05     #No.FUN-870117
  DEFINE l_bmh06  LIKE bmh_file.bmh06     #No.FUN-870117
  DEFINE l_bmh07  LIKE bmh_file.bmh07     #No.FUN-870117
 
  LET p_row = 10
  LET p_col = 35
  
  OPEN WINDOW i616b_w AT p_row,p_col WITH FORM "abm/42f/abmi616b"                                                               
         ATTRIBUTE (STYLE = g_win_style CLIPPED)      
   CALL cl_ui_locale("abmi616b")
   CONSTRUCT BY NAME g_wc3 ON
     boj09,boj11,boj01,boj06
      
      BEFORE  CONSTRUCT
         CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds                                                                                                           
         CALL cl_on_idle()                                                                                                          
         CONTINUE CONSTRUCT
   END CONSTRUCT                                                                                                                    
   IF NOT INT_FLAG THEN
   INITIALIZE tm.a TO NULL
   LET tm.a = g_today
   INPUT BY NAME tm.a WITHOUT DEFAULTS
 
   AFTER FIELD a
     IF cl_null(tm.a) THEN NEXT FIELD a END IF
 
   AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
        IF cl_null(tm.a) THEN NEXT FIELD a END IF
 
  END INPUT
  END IF
 
 CLOSE WINDOW i616b_w 
 IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
  IF NOT cl_confirm('abm-853') THEN 
     RETURN
  END IF
  LET l_sql1 = " SELECT boj10,boj09,boj01,boj06,boj04,boj05,bojuser,bojgrup,bojacti FROM boj_file",
                " WHERE ",g_wc3 CLIPPED
  PREPARE i616b_c1 FROM l_sql1
  DECLARE i616b_c1_curs
          CURSOR WITH HOLD FOR i616b_c1
  BEGIN WORK
  LET l_i = 1
  LET l_flag1 = 'N'
  FOREACH i616b_c1_curs INTO l_boj10_b[l_i],l_boj09_b[l_i],l_boj01_b[l_i],
                             l_boj06_b[l_i],l_boj04_b[l_i],l_boj05_b[l_i],
                             l_bojuser_b[l_i],l_bojgrup_b[l_i],l_bojacti_b[l_i]
     LET l_flag1 = 'Y'
     IF l_boj10_b[l_i] = '1' THEN
        UPDATE boj_file SET boj10 = '2',
                            boj05 = tm.a
         WHERE boj09 = l_boj09_b[l_i]
           AND boj01 = l_boj01_b[l_i]
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","boj_file",g_boj.boj09,g_boj.boj01,SQLCA.sqlcode,"","up boj10",1)  
           ROLLBACK WORK
           EXIT FOREACH
        ELSE
           LET l_boj10_b[l_i] = '2'
           LET l_boj05_b[l_i] = tm.a    #No.FUN-850017
           LET g_boj.boj10 = '2'
           LET g_boj.boj05 = tm.a       #No.FUN-850017
        END IF
        DECLARE i616b_up_cs CURSOR FOR
        SELECT bok31,bok32,bok01,bok02,bok03,bok04
          FROM bok_file
         WHERE bok31 = l_boj09_b[l_i]
           AND bok01 = l_boj01_b[l_i]
           AND (bok05 > g_boj.boj05 OR bok05 IS NULL )
       FOREACH i616b_up_cs INTO l_bok31,l_bok32,l_bok01,l_bok02,l_bok03,l_bok04
        UPDATE bok_file
           SET bok04 = g_boj.boj05
         WHERE bok31 = l_bok31
           AND bok32 = l_bok32
           AND bok01 = l_bok01
        IF SQLCA.SQLERRD[3]=0 THEN
           LET g_boj.boj05=NULL
           DISPLAY BY NAME g_boj.boj05
           CALL cl_err3("upd","bok_file",l_bok01,l_bok02,SQLCA.sqlcode,"","up bok04",1)  
           ROLLBACK WORK
           EXIT FOREACH
        END IF

          UPDATE bmh_file
             SET bmh04 = g_boj.boj05
           WHERE bmh01 = l_bok01
             AND bmh09 = l_bok31
             AND bmh10 = l_bok32
         IF SQLCA.sqlcode THEN
            LET g_boj.boj05=NULL
            DISPLAY BY NAME g_boj.boj05
            CALL cl_err3("upd","bmh_file",l_bok01,l_bok02,SQLCA.sqlcode,"","up bmh04",1)  
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         UPDATE boj_file SET boj05 = g_boj.boj05
          WHERE boj09 = l_boj09_b[l_i]
            AND boj01 = l_boj01_b[l_i]
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","boj_file",g_boj.boj09,g_boj.boj01,SQLCA.sqlcode,"","up boj10",1)  
             ROLLBACK WORK
             EXIT FOREACH
          ELSE
             LET l_boj05_b[l_i] = g_boj.boj05
             DISPLAY BY NAME g_boj.boj05
          END IF
       END FOREACH

        SELECT count(*) INTO l_n FROM bma_file
         WHERE bma01=l_boj01_b[l_i]
           AND bma06=l_boj06_b[l_i]
         IF l_n > 0 THEN
            CALL cl_err('','',0)
         ELSE
           LET l_boj08_b[l_i] = " "
           IF cl_null(l_boj10_b[l_i]) THEN
              LET l_boj10_b[l_i] = '0'
           END IF
           IF cl_null(l_boj06_b[l_i]) THEN LET l_boj06_b[l_i] = " " END IF
           INSERT INTO bma_file(bma01,bma06,bma08,bma10,bma04,bma05,bmauser,bmagrup,bmaacti,bmaoriu,bmaorig)
             VALUES(l_boj01_b[l_i],l_boj06_b[l_i],l_boj08_b[l_i],l_boj10_b[l_i],
                    l_boj04_b[l_i],l_boj05_b[l_i],l_bojuser_b[l_i],l_bojgrup_b[l_i],
                    l_bojacti_b[l_i], g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","bma_file",l_boj09_b[l_i],"",SQLCA.sqlcode,"","",0)
              ROLLBACK WORK
           END IF
         END IF
         DECLARE i616b_up_cs1 CURSOR FOR 
         SELECT bok02,bok04,bok13,bok30,bok03,bok09,bok16,bok14,
                bok05,bok06,bok07,bok10,bok08,bok19,bok24,bok34,bok33,bok32 #No.FUN-850017 No,FUN-870117
         FROM bok_file
        WHERE bok31 = l_boj09_b[l_i]                                                                                                     
          AND bok01 = l_boj01_b[l_i]
        LET l_x = 1
        LET g_success = 'Y'
        FOREACH i616b_up_cs1 INTO l_b[l_x].*
       SELECT count(*) INTO l_n1 FROM bmb_file
        WHERE bmb03=l_b[l_x].bok03 
          AND bmb01=l_boj01_b[l_i]
          AND bmb29=l_boj06_b[l_i]
          AND bmb02=l_b[l_x].bok02
          AND bmb04=l_b[l_x].bok04
          AND bmb13=l_b[l_x].bok13
       IF l_n1 > 0 THEN
          CALL cl_err('','mfg-240',0)
       ELSE
          IF cl_null(l_b[l_x].bok33) THEN LET l_b[l_x].bok33 = 0 END IF    #No.FUN-850017
          IF cl_null(l_boj06_b[l_i]) THEN LET l_boj06_b[l_i] = " " END IF  #No.FUN-870127 add
          INSERT INTO bmb_file(bmb01,bmb29,bmb02,bmb30,bmb03,bmb09,bmb16,bmb14,bmb04,
                               bmb05,bmb06,bmb07,bmb10,bmb08,bmb19,bmb24,bmb13,bmb31,bmb33,bmb081,bmb082) #No.TQC-BC0166 add bmb081,bmb082
          VALUES(l_boj01_b[l_i],l_boj06_b[l_i],l_b[l_x].bok02,l_b[l_x].bok30,l_b[l_x].bok03,
                 l_b[l_x].bok09,l_b[l_x].bok16,l_b[l_x].bok14,l_b[l_x].bok04,
                 l_b[l_x].bok05,l_b[l_x].bok06,l_b[l_x].bok07,l_b[l_x].bok10,
                 l_b[l_x].bok08,l_b[l_x].bok19,l_b[l_x].bok24,l_b[l_x].bok13,l_b[l_x].bok34,l_b[l_x].bok33,0,0) #No.TQC-BC0166 add 0,0
          IF SQLCA.sqlcode THEN                                                                                                        
             CALL cl_err3("ins","bmb_file",l_boj09_b[l_i],"",SQLCA.sqlcode,"","",0)                                                                                                                                                                             
             LET g_success = 'N'
          END IF

          DECLARE i616_bmt_curs1 CURSOR FOR 
           SELECT bmh05,bmh06,bmh07  
            FROM bmh_file WHERE bmh01 = l_boj01_b[l_i] AND bmh09 = l_boj09_b[l_i]
                         AND bmh10 = l_b[l_x].bok32 
          FOREACH i616_bmt_curs1 INTO  l_bmh05,l_bmh06,l_bmh07 
          INSERT INTO bmt_file
            VALUES(l_boj01_b[l_i],l_b[l_x].bok02,l_b[l_x].bok03,l_b[l_x].bok04,
                   l_bmh05,l_bmh06,l_bmh07,l_boj06_b[l_i])               
       
          IF SQLCA.sqlcode THEN                                                                                                        
             CALL cl_err3("ins","bmt_file",g_boj.boj09,"",SQLCA.sqlcode,"","",0)           
             LET g_success = 'N' 
             EXIT FOREACH                                            
          END IF
          END FOREACH 
          
          UPDATE bma_file SET bmamodu = g_user,
                              bmadate = g_today
                          WHERE bma01=l_boj01_b[l_i]
                            AND bma06=l_boj06_b[l_i]
          IF SQLCA.sqlcode THEN                                                                                                        
             CALL cl_err3("upd","bma_file",l_boj09_b[l_i],"",SQLCA.sqlcode,"","",0)                                                                                                                                                                             
             LET g_success = 'N'
          END IF
       END IF
       LET l_x=l_x+1    
       END FOREACH
        IF g_success = 'N' THEN
           ROLLBACK WORK
        ELSE
           DISPLAY BY NAME g_boj.boj10
           DISPLAY BY NAME g_boj.boj05
           COMMIT WORK
        END IF
     END IF
     LET l_i=l_i+1
 END FOREACH
 IF l_flag1 = 'N' THEN 
    CALL cl_err('','abm-855',0)
 END IF
END FUNCTION

#TQC-BB0186--add--begin--
FUNCTION i616_rj()
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_bok31  LIKE bok_file.bok31
   DEFINE l_bok32  LIKE bok_file.bok32
   DEFINE l_bok01  LIKE bok_file.bok01
   DEFINE l_bok02  LIKE bok_file.bok02
   DEFINE l_bok03  LIKE bok_file.bok03
   DEFINE l_bok04  LIKE bok_file.bok04

   IF s_shut(0) THEN RETURN END IF 
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM bma_file WHERE bma01 = g_boj.boj01 AND bma06 = g_boj.boj06
   IF l_n > 0 THEN
      CALL cl_err('','mfg-121',1)
      RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'

    OPEN i616_cl USING g_boj.boj01,g_boj.boj09
    IF STATUS THEN
       CALL cl_err("OPEN i616_cl:", STATUS, 1)
       CLOSE i616_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i616_cl INTO g_boj.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_boj.boj09,SQLCA.sqlcode,0) RETURN
    END IF
   
    UPDATE boj_file SET boj05=NULL,
                        boj10='1',
                        bojmodu=g_user,
                        bojdate=g_today
                   WHERE boj09=g_boj.boj09
                     AND boj01=g_boj.boj01
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","boj_file",g_boj.boj09,"",SQLCA.sqlcode,"","up boj05",1)
       ROLLBACK WORK
       RETURN
    END IF
    DECLARE i616_up_cs2 CURSOR FOR
      SELECT bok31,bok32,bok01,bok02,bok03,bok04
        FROM bok_file
      WHERE bok31 = g_boj.boj09
        AND bok01 = g_boj.boj01
        AND (bok05 > g_boj.boj05 OR bok05 IS NULL )
    FOREACH i616_up_cs2 INTO l_bok31,l_bok32,l_bok01,l_bok02,l_bok03,l_bok04
       UPDATE bok_file
          SET bok05 = NULL
        WHERE bok31 = l_bok31
          AND bok32 = l_bok32
          AND bok01 = l_bok01
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","bok_file",l_bok01,l_bok02,SQLCA.sqlcode,"","up bok04",1)
          ROLLBACK WORK
          EXIT FOREACH
       END IF

   END FOREACH

   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      LET g_boj.boj05 = NULL
      LET g_boj.boj10 = '1'
      COMMIT WORK
   END IF
   CALL i616_show()
    
END FUNCTION
#TQC-BB0186--add--end--

FUNCTION i616_r()
    DEFINE l_chr LIKE type_file.chr1    
    DEFINE l_cnt LIKE type_file.num10   
 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_boj.boj09 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_boj.boj10 = 1 THEN
      CALL cl_err('','9023',0)
      RETURN

    END IF
   IF g_boj.boj10 = 2 THEN
     CALL cl_err('','abm-123',0)
     RETURN

   END IF
   IF g_boj.boj10 = 'X' THEN RETURN END IF  #CHI-C80041
    #考慮參數(sma101) BOM表發放后是否可以修改單身
    IF NOT cl_null(g_boj.boj05) AND g_sma.sma101 = 'N' THEN
       IF g_ima08_h MATCHES '[MPXTS]' THEN    #單頭料件來源碼='MPXTS'才control 
          CALL cl_err('','abm-120',0)
          RETURN
       END IF
    END IF
 
    # 存在工單之BOM詢問是否可取消
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt
      FROM sfa_file
     WHERE sfa29 = g_boj.boj01
    IF l_cnt >0 AND l_cnt IS NOT NULL THEN
       IF NOT cl_confirm('mfg-004') THEN
          RETURN
       END IF
    END IF
    BEGIN WORK
 
    OPEN i616_cl USING g_boj.boj01,g_boj.boj09
    IF STATUS THEN
       CALL cl_err("OPEN i616_cl:", STATUS, 1)
       CLOSE i616_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i616_cl INTO g_boj.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_boj.boj09,SQLCA.sqlcode,0) RETURN
    END IF
    CALL i616_show()
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "boj09"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1  = g_boj.boj09      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
        DELETE FROM boj_file WHERE boj01=g_boj.boj01 AND boj09=g_boj.boj09
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                CALL cl_err3("del","boj_file",g_boj.boj09,"",SQLCA.sqlcode,"","del boj",1)  
                ROLLBACK WORK
                RETURN
            END IF
        DELETE FROM bok_file WHERE bok31=g_boj.boj09
                               AND bok01=g_boj.boj01
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bok_file",g_boj.boj09,"",SQLCA.sqlcode,"","del bok",1)  
                ROLLBACK WORK
                RETURN
            END IF
         DELETE FROM bmh_file WHERE bmh09=g_boj.boj09
                                AND bmh01=g_boj.boj01
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bmh_file",g_boj.boj09,"",SQLCA.sqlcode,"","del bok",1)  
                ROLLBACK WORK
                RETURN
            END IF

    LET g_msg=TIME
    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)    #FUN-980001 add plant & legal
       VALUES ('abmi616',g_user,g_today,g_msg,g_boj.boj01,g_boj.boj09,'delete',g_plant,g_legal)#FUN-980001 add plant & legal
    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)    #FUN-980001 add plant & legal
       VALUES ('abmi616',g_user,g_today,g_msg,g_boj.boj01,'delete',g_plant,g_legal)#FUN-980001 add plant & legal
    END IF
    IF g_sma.sma845='Y'   #低階碼可否部份重計
       THEN
       LET g_success='Y'
       #CALL s_uima146(g_boj.boj01)  #CHI-D10044
       CALL s_uima146(g_boj.boj01,0)  #CHI-D10044
       MESSAGE ""
    END IF
    COMMIT WORK
    CLOSE i616_cl
    CLEAR FORM
    CALL g_bok.clear()
    DROP TABLE x                            
    PREPARE i616_precount_x2 FROM g_sql_tmp  
    EXECUTE i616_precount_x2                 
    OPEN i616_count
    IF STATUS THEN
       CLOSE i616_curs
       CLOSE i616_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50062-add-end--

    FETCH i616_count INTO g_row_count
    #FUN-B50062-add-start--
    IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
       CLOSE i616_curs
       CLOSE i616_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50062-add-end--
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i616_curs
    IF g_curs_index = g_row_count + 1 THEN
       LET g_jump = g_row_count
       CALL i616_fetch('L')
    ELSE
       LET g_jump = g_curs_index
       LET mi_no_ask = TRUE
       CALL i616_fetch('/')
    END IF
END FUNCTION
 
#單身
FUNCTION i616_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,   #檢查重復用
    l_n1            LIKE type_file.num5,
    l_n3            LIKE type_file.num5,   #No.FUN-870117
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否
    p_cmd           LIKE type_file.chr1,   #處理狀態
    l_buf           LIKE type_file.chr50,  
    l_cmd           LIKE type_file.chr1000,
    l_uflag,l_chr   LIKE type_file.chr1,   
    l_ima08         LIKE ima_file.ima08,
    l_bok01         LIKE ima_file.ima01,
    l_qpa           LIKE bok_file.bok06,
    l_ima04         LIKE ima_file.ima04,
    l_i             LIKE type_file.num5,   
    l_cnt           LIKE type_file.num5,
    l_result        LIKE gep_file.gep01,   
    l_str           LIKE gep_file.gep01,
    l_valid,l_count LIKE type_file.num5,   
    l_formula01     LIKE gep_file.gep01,
    l_formula02     LIKE gep_file.gep01,
    l_formula03     LIKE gep_file.gep01,
 
    l_viewcad_cmd   LIKE type_file.chr1000, 
    l_allow_insert  LIKE type_file.num5,       #可新增否
    l_allow_delete  LIKE type_file.num5        #可刪除否
DEFINE li_result LIKE type_file.num5  
DEFINE l_m          LIKE type_file.num5      
DEFINE l_r          LIKE type_file.num5        #No.FUN-830114
DEFINE l_ima151     LIKE ima_file.ima151   
DEFINE r_ima151     LIKE ima_file.ima151       #NO.FUN-830114
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_boj.boj09) THEN
        RETURN
    END IF
    IF g_boj.boj10 = 1 THEN
       CALL cl_err('','9023',0)
       RETURN 
    END IF      
    IF g_boj.boj10 = 2 THEN
       CALL cl_err('','abm-123',0)
       RETURN
    END IF
    IF g_boj.boj10 = 'X' THEN RETURN END IF  #CHI-C80041
    #考慮參數(sma101) BOM表發放后是否可以修改單身
    IF NOT cl_null(g_boj.boj05) AND g_sma.sma101 = 'N' THEN
       IF g_ima08_h MATCHES '[MPXTS]' THEN    #單頭料件來源碼='MPXTS'才control 
          CALL cl_err('','abm-120',0)
          RETURN
       END IF
    END IF
    IF g_boj.bojacti ='N' THEN    #資料若為無效,仍可更改.  
        CALL cl_err(g_boj.boj09,'mfg1000',0) RETURN       
    END IF                                                
    LET l_uflag ='N'
    LET g_aflag ='N'
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      "SELECT * ",
      " FROM bok_file ",
      "  WHERE bok31 = ?  ",
      "   AND bok32 = ? ", 
      "   AND bok01 = ? ",
      " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i616_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
 
    INPUT ARRAY g_bok
          WITHOUT DEFAULTS
          FROM s_bok.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
             LET g_modify_flag = 'N' 
            LET g_before_input_done = FALSE
            CALL i616_b_set_entry()
            LET g_before_input_done = TRUE
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN i616_cl USING g_boj.boj01,g_boj.boj09
            IF STATUS THEN
                CALL cl_err("OPEN i616_cl:", STATUS, 1)
                CLOSE i616_cl
                RETURN
            END IF
            FETCH i616_cl INTO g_boj.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_boj.boj09,SQLCA.sqlcode,0)  # 資料被他人LOCK
               CLOSE i616_cl
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_bok_t.* = g_bok[l_ac].*  #BACKUP
               LET g_bok_o.* = g_bok[l_ac].*
                OPEN i616_bcl USING g_boj.boj09,g_bok_t.bok32,g_boj.boj01 
                IF STATUS THEN
                    CALL cl_err("OPEN i616_bcl:", STATUS, 1)
                ELSE
                    FETCH i616_bcl INTO b_bok.* 
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bok_t.bok32,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        CALL i616_b_move_to() 
                    END IF
 
                END IF
 
                CALL cl_show_fld_cont()     
            END IF
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            CALL i616_b_move_back()
            INSERT INTO bok_file VALUES (b_bok.*)
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","bok_file",g_boj.boj09,g_bok[l_ac].bok32,SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                LET g_modify_flag='Y'
                UPDATE boj_file SET bojdate = g_today
                                WHERE boj01=g_boj.boj01 AND boj09=g_boj.boj09
                MESSAGE 'INSERT O.K'
                #update 上一項次失效日
                CALL i616_update('a')
                IF g_sma.sma845='Y'   #低階碼可否部份重計
                   THEN
                    LET g_success='Y'                                
                   #CALL s_uima146(g_bok[l_ac].bok03)  #CHI-D10044
                   CALL s_uima146(g_bok[l_ac].bok03,0)  #CHI-D10044
                   MESSAGE ""
                   IF g_success='N' THEN
                       #不可輸入此元件料號,因為產品結構偵錯發現有誤! 
                       CALL cl_err(g_bok[l_ac].bok32,'abm-602',1)      
                      LET g_bok[l_ac].* = g_bok_t.*
                      DISPLAY g_bok[l_ac].* TO s_bok[l_sl].*
                      ROLLBACK WORK
                       CALL g_bok.deleteElement(l_ac)               
                       CANCEL INSERT                                 
                   END IF
                END IF
                IF l_uflag = 'N' THEN
                  #新增料件時系統參數(sma18 低階碼是重新計算)
                   UPDATE sma_file SET sma18 = 'Y'
                        WHERE sma00 = '0'
                   IF SQLCA.SQLERRD[3]  = 0 THEN
                      CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","cannot update sma_file",1)  
                   END IF
                   LET l_uflag = 'Y'
                END IF
                IF g_aflag = 'N' THEN LET g_aflag = 'Y' END IF
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
             COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_bok[l_ac].* TO NULL      
            LET g_bok15 ='N'
            LET g_bok19 ='Y'    LET g_bok21 ='Y'
            LET g_bok22 ='Y'    LET g_bok23 = 100
            LET g_bok11 = NULL  LET g_bok13 = NULL
            LET g_bok18 = 0     LET g_bok17 = 'N'
            LET g_bok20 = NULL  LET g_bok34 = 'N'    #No.FUN-830114
            LET g_bok28 = 0 # 誤差容許率預設值應為 0
            LET g_bok10_fac = 1 LET g_bok10_fac2 = 1
 
            LET g_bok[l_ac].bok09 = ' '
            LET g_bok[l_ac].bok16 = '0'
            LET g_bok[l_ac].bok14 = '0'
            LET g_bok[l_ac].bok04 = g_today #Body default
            LET g_bok[l_ac].bok06 = 1         #Body default
            LET g_bok[l_ac].bok07 = 1         #Body default
            LET g_bok[l_ac].bok08 = 0         #Body default
            LET g_bok[l_ac].bok19 = '1'
            LET g_bok[l_ac].bok34 = 'N'       #No.FUN-830114
            IF g_sma.sma118 != 'Y' THEN
                LET g_bok[l_ac].bok30 = ' '
            ELSE
                LET g_bok[l_ac].bok30 = '1'
            END IF
            LET g_bok_t.* = g_bok[l_ac].*         #新輸入資料
            LET g_bok_o.* = g_bok[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     
            NEXT FIELD bok32
 
    
        BEFORE FIELD bok32
            IF g_bok[l_ac].bok32 IS NULL OR g_bok[l_ac].bok32 = 0 THEN
               SELECT MAX(bok32)+1
                 INTO g_bok[l_ac].bok32
                 FROM bok_file
                WHERE bok31 = g_boj.boj09
                  AND bok01 = g_boj.boj01
               IF g_bok[l_ac].bok32 IS NULL THEN
                  LET g_bok[l_ac].bok32 = 1
               END IF
             END IF
 
        AFTER FIELD bok32
           IF NOT cl_null(g_bok[l_ac].bok32) THEN
              IF g_bok[l_ac].bok32 != g_bok_t.bok32
                 OR g_bok_t.bok32 IS NULL THEN
                 SELECT count(*)
                   INTO l_n1
                   FROM bok_file
                 WHERE bok31 = g_boj.boj09
                   AND bok01 = g_boj.boj01
                   AND bok32 = g_bok[l_ac].bok32
                IF l_n1 > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_bok[l_ac].bok32 = g_bok_t.bok32
                   NEXT FIELD bok32
                END IF
              END IF
           END IF
 
        BEFORE FIELD bok02                        #default 項次
            IF g_bok[l_ac].bok02 IS NULL OR g_bok[l_ac].bok02 = 0 THEN
                SELECT max(bok02)
                   INTO g_bok[l_ac].bok02
                   FROM bok_file
                   WHERE bok31 = g_boj.boj09
                     AND bok01 = g_boj.boj01
                IF g_bok[l_ac].bok02 IS NULL
                   THEN LET g_bok[l_ac].bok02 = 0
                END IF
                LET g_bok[l_ac].bok02 = g_bok[l_ac].bok02 + g_sma.sma19
                DISPLAY g_bok[l_ac].bok02 TO s_bok[l_sl].bok02
            END IF
            IF p_cmd = 'a'
              THEN LET g_bok20 = g_bok[l_ac].bok02
            END IF
 
        AFTER FIELD bok02                        #default 項次
            IF g_bok[l_ac].bok02 IS NOT NULL AND
               g_bok[l_ac].bok02 <> 0 AND p_cmd='a' THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM bok_file
                      WHERE bok31=g_boj.boj09
                        AND bok01=g_boj.boj01
                        AND bok02=g_bok[l_ac].bok02
               IF l_n>0 THEN
                  IF NOT cl_confirm('mfg-002') THEN 
                     NEXT FIELD bok02 
                  ELSE
                     FOR l_i = 1 TO g_rec_b
                       IF l_i <> l_ac THEN
                         IF g_bok[l_i].bok02 = g_bok[l_ac].bok02 AND g_bok[l_i].bok04 <> g_bok[l_ac].bok04 THEN
                            LET g_bok[l_i].bok05 = g_bok[l_ac].bok04
                            DISPLAY BY NAME g_bok[l_i].bok04
                         END IF
                       END IF
                     END FOR
                  END IF
               END IF
            END IF
             #若有更新項次時,插件位置的key值更新為變動后的項次
             IF p_cmd = 'u' AND (g_bok[l_ac].bok02 != g_bok_t.bok02) THEN
                SELECT COUNT(*) INTO l_n FROM bok_file
                       WHERE bok31=g_boj.boj09
                         AND bok02=g_bok[l_ac].bok02
                IF l_n>0 THEN
                  IF NOT cl_confirm('mfg-002') THEN 
                     NEXT FIELD bok02 
                  ELSE
                     FOR l_i = 1 TO g_rec_b
                       IF l_i <> l_ac THEN
                         IF g_bok[l_i].bok02 = g_bok[l_ac].bok02 AND g_bok[l_i].bok04 <> g_bok[l_ac].bok04 THEN
                            LET g_bok[l_i].bok05 = g_bok[l_ac].bok04
                            DISPLAY BY NAME g_bok[l_i].bok04
                         END IF
                       END IF
                     END FOR
                  END IF
                END IF

             END IF
             IF s_industry('slk') THEN                                                                                               
               IF g_bok[l_ac].bok02 IS NOT NULL AND g_bok[l_ac].bok03 IS NOT NULL AND                                               
                  g_bok[l_ac].bok04 IS NOT NULL AND g_bok[l_ac].bok13 IS NOT NULL AND p_cmd = 'a' THEN                              
                 SELECT COUNT(*) INTO l_r  FROM bok_file WHERE bok01 = g_boj.boj01                                                  
                                                           AND bok02 = g_bok[l_ac].bok02                                            
                                                           AND bok03 = g_bok[l_ac].bok03                                            
                                                           AND bok04 = g_bok[l_ac].bok04                                            
                                                           AND bok13 = g_bok[l_ac].bok13                                            
                IF l_r >0 THEN                                                                                                      
                   CALL cl_err('','abm-644',0)                                                                                      
                   NEXT FIELD bok02                                                                                                 
                END IF                                                                                                              
               END IF                                                                                                               
           END IF
 
        AFTER FIELD bok03                         #(元件料件)
               IF cl_null(g_bok[l_ac].bok03) THEN
                  LET g_bok[l_ac].bok03=g_bok_t.bok03
               END IF
               IF NOT cl_null(g_bok[l_ac].bok03) THEN
                 #FUN-AA0059 ------------------------add start----------------------------
                  IF NOT s_chk_item_no(g_bok[l_ac].bok03,'') THEN 
                     CALL cl_err('',g_errno,1)
                     NEXT FIELD bok03
                  END IF 
                 #FUN-AA0059 ------------------------add end------------------------------     
                  SELECT count(*) INTO l_cnt FROM ima_file
                   WHERE ima01=g_bok[l_ac].bok03 and ima151='Y'
                  IF l_cnt>0 THEN
                     CALL cl_err('','abm-124',0)
                     NEXT FIELD bok03
                  END IF
                  IF cl_null(g_bok_t.bok03) OR g_bok_t.bok03 <> g_bok[l_ac].bok03 THEN     
                     SELECT COUNT(*) INTO l_n FROM bok_file
                             WHERE bok31=g_boj.boj09
                               AND bok01=g_boj.boj01
                               AND bok03=g_bok[l_ac].bok03
                      IF l_n>0 THEN
                         IF NOT cl_confirm('abm-728') THEN NEXT FIELD bok03 END IF
                      END IF
                   END IF
                   CALL i616_bok03(p_cmd)    #必需讀取(料件主檔) #No:7685
                           IF NOT cl_null(g_errno) THEN
                               CALL cl_err('',g_errno,0)
                               LET g_bok[l_ac].bok03=g_bok_t.bok03
                               NEXT FIELD bok03
                           END IF
                   IF p_cmd = 'a' THEN LET g_bok15 = g_ima70_b END IF
                   IF s_bomchk(g_boj.boj01,g_bok[l_ac].bok03,g_ima08_h,g_ima08_b)
                             THEN NEXT FIELD bok03
                   END IF
                   IF g_bok[l_ac].bok10 IS NULL OR g_bok[l_ac].bok10 = ' '
                              OR g_bok[l_ac].bok03 != g_bok_t.bok03
                             THEN LET g_bok[l_ac].bok10 = g_ima63_b
                                  DISPLAY g_ima63_b   TO s_bok[l_sl].bok10
                   END IF
                   IF g_ima08_b = 'D'
                             THEN LET g_bok17 = 'Y'
                             ELSE LET g_bok17 = 'N'
                   END IF
               END IF
           IF NOT cl_null(g_bok[l_ac].bok03) THEN                                                                                  
              SELECT ima151 INTO r_ima151 FROM ima_file WHERE ima01 = g_bok[l_ac].bok03                                             
              IF g_bok[l_ac].bok02 = '1' THEN                                                                                       
                IF  r_ima151 = 'Y' THEN                                                                                             
                   CALL cl_err('','abm-645',0)                                                                                      
                   NEXT FIELD bok03                                                                                                 
                END IF                                                                                                              
              END IF                                                                                                                
              IF g_bok[l_ac].bok02 = '4' THEN                                                                                       
                IF  r_ima151 <> 'Y' THEN                                                                                            
                   CALL cl_err('','abm-646',0)                                                                                      
                   NEXT FIELD bok03                                                                                                 
                END IF                                                                                                              
              END IF                                                                                                                
          END IF                                                                                                                  
            IF s_industry('slk') THEN                                                                                               
              IF g_bok[l_ac].bok02 IS NOT NULL AND g_bok[l_ac].bok03 IS NOT NULL AND                                                
                 g_bok[l_ac].bok04 IS NOT NULL AND g_bok[l_ac].bok13 IS NOT NULL AND p_cmd = 'a'THEN                                
                SELECT COUNT(*) INTO l_r  FROM bok_file WHERE bok01 = g_boj.boj01                                                   
                                                          AND bok02 = g_bok[l_ac].bok02                                             
                                                          AND bok03 = g_bok[l_ac].bok03                                             
                                                          AND bok04 = g_bok[l_ac].bok04
                                                          AND bok13 = g_bok[l_ac].bok13                                             
               IF l_r >0 THEN                                                                                                       
                  CALL cl_err('','abm-644',0)                                                                                       
                  NEXT FIELD bok02                                                                                                  
               END IF                                                                                                               
              END IF                                                                                                                
           END IF
 
        AFTER FIELD bok04                       
            IF NOT cl_null(g_bok[l_ac].bok04) THEN
               IF NOT cl_null(g_bok[l_ac].bok05) THEN
                  IF g_bok[l_ac].bok05 < g_bok[l_ac].bok04 THEN 
                     CALL cl_err(g_bok[l_ac].bok04,'mfg2604',0)
                     NEXT FIELD bok04
                  END IF
               END IF
                CALL i616_bdate(p_cmd)     #生效日
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_bok[l_ac].bok04,g_errno,0)
                   LET g_bok[l_ac].bok04 = g_bok_t.bok04
                   DISPLAY g_bok[l_ac].bok04 TO s_bok[l_sl].bok04
                   NEXT FIELD bok04
                END IF
            END IF
            IF s_industry('slk') THEN                                                                                               
              IF g_bok[l_ac].bok02 IS NOT NULL AND g_bok[l_ac].bok03 IS NOT NULL AND                                                
                 g_bok[l_ac].bok04 IS NOT NULL AND g_bok[l_ac].bok13 IS NOT NULL AND p_cmd = 'a' THEN                               
                SELECT COUNT(*) INTO l_r  FROM bok_file WHERE bok01 = g_boj.boj01                                                   
                                                          AND bok02 = g_bok[l_ac].bok02                                             
                                                          AND bok03 = g_bok[l_ac].bok03                                             
                                                          AND bok04 = g_bok[l_ac].bok04                                             
                                                          AND bok13 = g_bok[l_ac].bok13                                             
               IF l_r >0 THEN                                                                                                       
                  CALL cl_err('','abm-644',0)                                                                                       
                  NEXT FIELD bok02                                                                                                  
               END IF                                                                                                               
              END IF                                                                                                                
           END IF
 
        AFTER FIELD bok05   #check失效日小于生效日
            IF NOT cl_null(g_bok[l_ac].bok05) THEN
               IF NOT cl_null(g_bok[l_ac].bok04) THEN
                  IF g_bok[l_ac].bok05 < g_bok[l_ac].bok04 THEN 
                     CALL cl_err(g_bok[l_ac].bok05,'mfg2604',0)
                     NEXT FIELD bok05
                  END IF
               END IF
                IF g_bok[l_ac].bok05 IS NOT NULL OR g_bok[l_ac].bok05 != ' '
                   THEN IF g_bok[l_ac].bok05 < g_bok[l_ac].bok04
                          THEN CALL cl_err(g_bok[l_ac].bok05,'mfg2604',0)
                          NEXT FIELD bok04
                        END IF
                END IF
                CALL i616_edate(p_cmd)     #生效日
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_bok[l_ac].bok05,g_errno,0)
                   LET g_bok[l_ac].bok05 = g_bok_t.bok05
                   DISPLAY g_bok[l_ac].bok05 TO s_bok[l_sl].bok05
                   NEXT FIELD bok04
                END IF
            END IF
 
        AFTER FIELD bok06    #組成用量不可小于零
          IF NOT cl_null(g_bok[l_ac].bok06) THEN
              IF g_bok[l_ac].bok06 <= 0 THEN
                  CALL cl_err(g_bok[l_ac].bok06,'mfg2614',0)
                  LET g_bok[l_ac].bok06 = g_bok_o.bok06
                  DISPLAY BY NAME g_bok[l_ac].bok06
                  NEXT FIELD bok06
              END IF
          END IF
          LET g_bok_o.bok06 = g_bok[l_ac].bok06
 
        AFTER FIELD bok07    #底數不可小于等于零
            IF NOT cl_null(g_bok[l_ac].bok07) THEN
                IF g_bok[l_ac].bok07 <= 0
                 THEN CALL cl_err(g_bok[l_ac].bok07,'mfg2615',0)
                      LET g_bok[l_ac].bok07 = g_bok_o.bok07
                       DISPLAY BY NAME g_bok[l_ac].bok07
                      NEXT FIELD bok07
                END IF
                LET g_bok_o.bok07 = g_bok[l_ac].bok07
            ELSE
               CALL cl_err(g_bok[l_ac].bok07,'mfg3291',1)
               LET g_bok[l_ac].bok07 = g_bok_o.bok07
               NEXT FIELD bok07
            END IF
 
        AFTER FIELD bok08    #損耗率
            IF NOT cl_null(g_bok[l_ac].bok08) THEN
                IF g_bok[l_ac].bok08 < 0 OR g_bok[l_ac].bok08 > 100
                 THEN CALL cl_err(g_bok[l_ac].bok08,'mfg4063',0)
                      LET g_bok[l_ac].bok08 = g_bok_o.bok08
                      NEXT FIELD bok08
                END IF
                LET g_bok_o.bok08 = g_bok[l_ac].bok08
            END IF
            IF cl_null(g_bok[l_ac].bok08) THEN
                LET g_bok[l_ac].bok08 = 0
            END IF
            DISPLAY BY NAME g_bok[l_ac].bok08
 
        AFTER FIELD bok09    #作業編號
              #有使用制程(sma54='Y')
            IF NOT cl_null(g_bok[l_ac].bok09)
               THEN
               SELECT COUNT(*) INTO g_cnt FROM ecd_file
                WHERE ecd01=g_bok[l_ac].bok09
               IF g_cnt=0
                  THEN
                  CALL cl_err('sel ecd_file',100,0)
                  NEXT FIELD bok09
               END IF
            END IF
            IF g_bok[l_ac].bok09 IS NULL THEN
                LET g_bok[l_ac].bok09 = ' '
            END IF
            SELECT count(*) INTO l_n3 FROM bok_file
             WHERE bok01 = g_boj.boj01
               AND bok03 = g_bok[l_ac].bok03
               AND bok09 = g_bok[l_ac].bok09
            IF l_n3 > 0 THEN
               CALL cl_err('','abm-042',0)
               NEXT FIELD bok09
            END IF
 
        AFTER FIELD bok10   #發料單位
           IF g_bok[l_ac].bok10 IS NULL OR g_bok[l_ac].bok10 = ' '
             THEN LET g_bok[l_ac].bok10 = g_bok_o.bok10
             DISPLAY BY NAME g_bok[l_ac].bok10
             ELSE IF ((g_bok_o.bok10 IS NULL) OR (g_bok_t.bok10 IS NULL)
                      OR (g_bok[l_ac].bok10 != g_bok_o.bok10))
                  THEN CALL i616_bok10()
                       IF NOT cl_null(g_errno) THEN
                           CALL cl_err(g_bok[l_ac].bok10,g_errno,0)
                           LET g_bok[l_ac].bok10 = g_bok_o.bok10
                           DISPLAY g_bok[l_ac].bok10 TO s_bok[l_sl].bok10
                           NEXT FIELD bok10
                       ELSE IF g_bok[l_ac].bok10 != g_ima25_b
                            THEN CALL s_umfchk(g_bok[l_ac].bok03,
                                 g_bok[l_ac].bok10,g_ima25_b)
                                 RETURNING g_sw,g_bok10_fac  #發料/庫存單位
                                 IF g_sw THEN
                                   CALL cl_err(g_bok[l_ac].bok10,'mfg2721',0)
                                   LET g_bok[l_ac].bok10 = g_bok_o.bok10
                                   DISPLAY g_bok[l_ac].bok10 TO
                                           s_bok[l_sl].bok10
                                   NEXT FIELD bok10
                                 END IF
                            ELSE   LET g_bok10_fac  = 1
                            END  IF
                            IF g_bok[l_ac].bok10 != g_ima86_b  #發料/成本單位
                            THEN CALL s_umfchk(g_bok[l_ac].bok03,
                                         g_bok[l_ac].bok10,g_ima86_b)
                                 RETURNING g_sw,g_bok10_fac2
                                 IF g_sw THEN
                                   CALL cl_err(g_bok[l_ac].bok03,'mfg2722',0)
                                   LET g_bok[l_ac].bok10 = g_bok_o.bok10
                                   DISPLAY g_bok[l_ac].bok10 TO
                                             s_bok[l_sl].bok10
                                   NEXT FIELD bok10
                                 END IF
                            ELSE LET g_bok10_fac2 = 1
                          END IF
                       END IF
                  END IF
          END IF
          LET g_bok_o.bok10 = g_bok[l_ac].bok10
 
        AFTER FIELD bok16  #替代特性
           IF NOT cl_null(g_bok[l_ac].bok16) THEN
               IF g_bok[l_ac].bok16 NOT MATCHES'[0125]' THEN
                   LET g_bok[l_ac].bok16 = g_bok_o.bok16
                   DISPLAY BY NAME g_bok[l_ac].bok16
                   NEXT FIELD bok16
               END IF
               LET g_bok_o.bok16 = g_bok[l_ac].bok16
           END IF
 
        AFTER FIELD bok14  
           IF NOT cl_null(g_bok[l_ac].bok14) THEN
               IF g_bok[l_ac].bok14 NOT MATCHES'[01]' THEN
                   LET g_bok[l_ac].bok14 = g_bok_o.bok14
                   DISPLAY BY NAME g_bok[l_ac].bok14
                   NEXT FIELD bok14
               END IF
           END IF
 
        AFTER FIELD bok19
          IF NOT cl_null(g_bok[l_ac].bok19) THEN
              IF g_bok[l_ac].bok19 NOT MATCHES'[1234]' THEN
                  LET g_bok[l_ac].bok19 = g_bok_o.bok19
                  DISPLAY BY NAME g_bok[l_ac].bok19
                  NEXT FIELD bok19
              END IF
          END IF
          AFTER FIELD bok13
            IF  NOT cl_null(g_bok[l_ac].bok13) THEN
               SELECT COUNT(*) INTO l_m FROM bol_file 
                WHERE bol01= g_bok[l_ac].bok13 
                  AND bolacti = 'Y'
                IF l_m <=0 THEN
                   NEXT FIELD bok13
                END IF
             END IF 
             IF s_industry('slk') THEN                                                                                                
             IF g_bok[l_ac].bok02 IS NOT NULL AND g_bok[l_ac].bok03 IS NOT NULL AND                                                 
                g_bok[l_ac].bok04 IS NOT NULL AND g_bok[l_ac].bok13 IS NOT NULL AND p_cmd = 'a' THEN                                
               SELECT COUNT(*) INTO l_r  FROM bok_file WHERE bok01 = g_boj.boj01                                                    
                                                         AND bok02 = g_bok[l_ac].bok02                                              
                                                         AND bok03 = g_bok[l_ac].bok03                                              
                                                         AND bok04 = g_bok[l_ac].bok04                                              
                                                         AND bok13 = g_bok[l_ac].bok13                                              
              IF l_r >0 THEN                                                                                                        
                 CALL cl_err('','abm-644',0)                                                                                        
                 NEXT FIELD bok02                                                                                                   
              END IF                                                                                                                
             END IF                                                                                                                 
           END IF
 
          AFTER FIELD bok30
             IF NOT cl_null(g_bok[l_ac].bok30) THEN
                SELECT ima151 INTO l_ima151 FROM ima_file 
                 WHERE ima01 = g_boj.boj01 OR ima01 = g_bok[l_ac].bok03
                 IF l_ima151 = 'Y' THEN
                   IF g_bok[l_ac].bok30 = '4' THEN
                        NEXT FIELD bok30
                        CALL cl_err('','abm-000',0) 
                   END IF
                END IF
             END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bok_t.bok32 > 0 AND
               g_bok_t.bok32 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM bok_file
                    WHERE bok31 = g_boj.boj09
                      AND bok01 = g_boj.boj01
                      AND bok32 = g_bok_t.bok32
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 OR g_success='N' THEN
                    CALL cl_err("",SQLCA.sqlcode,0)   
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                DELETE FROM bmh_file
                    WHERE bmh01 = g_boj.boj01
                      AND bmh09 = g_boj.boj09
                      AND bmh10 = g_bok_t.bok32
                IF SQLCA.sqlcode OR g_success='N' THEN
                    CALL cl_err("",SQLCA.sqlcode,0)   
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF

                #移至DELETE FROM bok_file 之后
                IF g_sma.sma845='Y' THEN  #低階碼可否部份重計
                    LET g_success='Y'
                    #CALL s_uima146(g_bok[l_ac].bok03)  #CHI-D10044
                    CALL s_uima146(g_bok[l_ac].bok03,0)  #CHI-D10044
                    MESSAGE ""
                    IF g_success='N' THEN
                       CALL cl_err(g_bok[l_ac].bok03,'abm-002',1)
                       ROLLBACK WORK
                       CANCEL DELETE
                    END IF
                END IF
 
                LET g_modify_flag = 'Y' #MOD-530319
         COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bok[l_ac].* = g_bok_t.*
               CLOSE i616_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bok[l_ac].bok32,-263,1)
                LET g_bok[l_ac].* = g_bok_t.*
            ELSE
                CALL i616_b_move_back() 
                UPDATE bok_file SET * = b_bok.*
                 WHERE bok31 = g_boj.boj09
                   AND bok01 = g_boj.boj01
                   AND bok32 = g_bok_t.bok32
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","bok_file",g_boj.boj09,g_bok_t.bok32,SQLCA.sqlcode,"","",1) 
                    LET g_bok[l_ac].* = g_bok_t.*
                ELSE
                    UPDATE bmh_file SET bmh02 = g_bok[l_ac].bok02,
                                        bmh03 = g_bok[l_ac].bok03,
                                        bmh04 = g_bok[l_ac].bok04,
                                        bmh08 = g_boj.boj06,
                                        bmh10 = g_bok[l_ac].bok32
                     WHERE bmh01 = g_boj.boj01
                       AND bmh09 = g_boj.boj09
                       AND bmh10 = g_bok_t.bok32
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("upd","bmh_file",g_boj.boj09,g_bok_t.bok32,SQLCA.sqlcode,"","",1)                                  
                    END IF
                    UPDATE boj_file SET bojdate = g_today
                                    WHERE boj01=g_boj.boj01 AND boj09=g_boj.boj09
                    #--->update 上一項次失效日
                    CALL i616_update('u')
                    IF g_sma.sma845='Y' AND  #低階碼可否部份重計
                       g_bok_t.bok03 <> g_bok[l_ac].bok03
                       THEN
                       #CALL s_uima146(g_bok[l_ac].bok03)  #CHI-D10044
                       #CALL s_uima146(g_bok_t.bok03)  #CHI-D10044
                       CALL s_uima146(g_bok[l_ac].bok03,0)  #CHI-D10044
                       CALL s_uima146(g_bok_t.bok03,0)  #CHI-D10044
                       MESSAGE ""
                       IF g_success='N' THEN
                           #不可輸入此元件料號,因為產品結構偵錯發現有誤!
                          CALL cl_err(g_bok[l_ac].bok03,'abm-602',1)    
                          LET g_bok[l_ac].* = g_bok_t.*
                          DISPLAY g_bok[l_ac].* TO s_bok[l_sl].*
                          ROLLBACK WORK
                          NEXT FIELD bok02
                       END IF
                    END IF
                    #--->新增料件時系統參數(sma18 低階碼是重新計算)
                    IF l_uflag = 'N' THEN
                       UPDATE sma_file SET sma18 = 'Y'
                               WHERE sma00 = '0'
                       IF SQLCA.SQLERRD[3] = 0 THEN
                         CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","cannot update sma_file",1)  
                       END IF
                       LET l_uflag = 'Y'
                    END IF
                     LET g_modify_flag = 'Y' 
                    MESSAGE 'UPDATE O.K'
                    IF g_aflag = 'N' THEN LET g_aflag = 'Y' END IF
          COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_bok[l_ac].* = g_bok_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bok.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i616_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            IF cl_null(g_bok[l_ac].bok02) OR 
               cl_null(g_bok[l_ac].bok03) THEN
               CALL g_bok.deleteElement(l_ac)
            END IF
            CLOSE i616_bcl
            COMMIT WORK
 
 
     ON ACTION CONTROLP
           CASE WHEN INFIELD(bok03) #料件主檔
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form = "q_ima"
               #   LET g_qryparam.default1 = g_bok[l_ac].bok03
               #     CALL cl_create_qry() RETURNING g_bok[l_ac].bok03
                  CALL q_sel_ima(FALSE, "q_ima", "", g_bok[l_ac].bok03, "", "", "", "" ,"",'' )  RETURNING g_bok[l_ac].bok03 
#FUN-AA0059 --End--
                  DISPLAY g_bok[l_ac].bok03 TO bok03
                  NEXT FIELD bok03
 
              WHEN INFIELD(bok09) #作業主檔
                   CALL q_ecd(FALSE,TRUE,g_bok[l_ac].bok09) RETURNING g_bok[l_ac].bok09
                   DISPLAY g_bok[l_ac].bok09 TO bok09
                   NEXT FIELD bok09
               WHEN INFIELD(bok10) #單位檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_bok[l_ac].bok10
                  CALL cl_create_qry() RETURNING g_bok[l_ac].bok10
                  DISPLAY g_bok[l_ac].bok10 TO bok10
                  NEXT FIELD bok10
               WHEN INFIELD(bok13) #單位檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bmb13"
                  LET g_qryparam.default1 = g_bok[l_ac].bok13
                  CALL cl_create_qry() RETURNING g_bok[l_ac].bok13
                  DISPLAY g_bok[l_ac].bok13 TO bok13
                  NEXT FIELD bok13
               OTHERWISE EXIT CASE
           END  CASE
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(bok32) AND l_ac > 1 THEN
               LET g_bok[l_ac].* = g_bok[l_ac-1].*
               LET g_bok[l_ac].bok04 = g_today 
               LET g_bok[l_ac].bok02 = NULL
               LET g_bok[l_ac].bok05 = NULL   
               NEXT FIELD bok32
           END IF
 
        ON ACTION create_loc_data
           COMMIT WORK
           LET l_cmd = "abmi618 '",g_boj.boj01,"' ",
                               "'",g_boj.boj09,"'",
                               "",g_bok[l_ac].bok32    #No.FUN-870117
           CALL cl_cmdrun_wait(l_cmd)
           CALL i616_show()
           LET INT_FLAG = 0
 
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
        AFTER INPUT
          IF g_modify_flag='Y' AND
             g_sma.sma846='Y'   #產品結構有異動時是否自動執行偵錯檢查
             THEN
             LET g_status=0
             LET g_level=0
              LET g_success = 'Y'                   
            # CALL get_main_bom(g_boj.boj01,'c',1)
              CALL get_mai_bom(g_boj.boj01,'c',1)   
              IF g_success = 'N'                    
                THEN
                 CALL cl_err('','abm-002',1)       
             ELSE
                MESSAGE "Verify Ok!"
             END IF
          END IF
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
       
      ON ACTION controls                      
         CALL cl_set_head_visible("","AUTO")  
 
    END INPUT
    UPDATE boj_file SET bojmodu = g_user,bojdate = g_today
      WHERE boj01=g_boj.boj01 AND boj09=g_boj.boj09
 
    CLOSE i616_bcl
    COMMIT WORK
#   CALL i616_delall()  #CHI-C30002 mark
    CALL i616_delHeader() #CHI-C30002 add
END FUNCTION


#CHI-C30002 ------ add ------ begin
FUNCTION i616_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_boj.boj09) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM boj_file ",
                  "  WHERE boj09 LIKE '",l_slip,"%' ",
                  "    AND boj09 > '",g_boj.boj09,"'",
                  "    AND boj01 = '",g_boj.boj01,"'"
      PREPARE i616_pb1 FROM l_sql 
      EXECUTE i616_pb1 INTO l_cnt      
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL i616_v()   #CHI-D20010
         CALL i616_v(1)  #CHI-D20010
         IF g_boj.boj10 = '1' OR g_boj.boj10 = '2' THEN
            LET g_chr2 = 'Y'
         ELSE
            LET g_chr2 = 'N'
         END IF
         IF g_boj.boj10 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF 
         CALL cl_set_field_pic("",g_chr2,"","",g_void,g_boj.bojacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM boj_file WHERE boj09 = g_boj.boj09
                                AND boj01 = g_boj.boj01
         INITIALIZE g_boj.* TO NULL
         CLEAR FORM
      END IF
   END IF
         
END FUNCTION
#CHI-C30002 ------ add ------ end
 
#CHI-C30002 ------ mark ----- begin
#FUNCTION i616_delall()
#   SELECT COUNT(*) INTO g_cnt FROM bok_file
#       WHERE bok31=g_boj.boj09
#         AND bok01=g_boj.boj01
#   IF g_cnt = 0 THEN    # 未輸入單身資料, 則取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM boj_file WHERE boj09 = g_boj.boj09
#                             AND boj01 = g_boj.boj01
#   END IF
#END FUNCTION
#CHI-C30002 ------ mark ----- end
 
FUNCTION i616_bok03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #VARCHAR(1),
    l_ima110        LIKE ima_file.ima110,
    l_ima140        LIKE ima_file.ima140,
    l_ima1401       LIKE ima_file.ima1401,  
    l_imaacti       LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima08,ima37,ima25,ima63,ima70,ima86,ima105,ima107,  
           ima110,ima140,ima1401,imaacti  
        INTO g_bok[l_ac].ima02_b,g_bok[l_ac].ima021_b,
             g_ima08_b,g_ima37_b,g_ima25_b,g_ima63_b,
             g_ima70_b,g_ima86_b,g_bok27,g_ima107_b,l_ima110,l_ima140,l_ima1401,l_imaacti 
        FROM ima_file
        WHERE ima01 = g_bok[l_ac].bok03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET g_bok[l_ac].ima02_b = NULL
                                   LET g_bok[l_ac].ima021_b = NULL
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_ima70_b IS NULL OR g_ima70_b = ' ' THEN
       LET g_ima70_b = 'N'
    END IF
    #--->來源碼為'Z':雜項料件
    IF g_ima08_b ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN
    END IF
 
    IF l_ima140  ='Y' THEN 
       LET g_errno = 'aim-809'
       RETURN
    END IF
 
    IF g_bok27 IS NULL OR g_bok27 = ' ' THEN LET g_bok27 = 'N' END IF
    IF cl_null(l_ima110) THEN LET l_ima110='1' END IF
    IF p_cmd = 'a' THEN
       LET g_bok[l_ac].bok19 = l_ima110
       DISPLAY g_bok[l_ac].bok19 TO s_bok[l_sl].bok19
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
        DISPLAY g_bok[l_ac].ima02_b TO s_bok[l_sl].ima02_b
        DISPLAY g_bok[l_ac].ima021_b TO s_bok[l_sl].ima021_b
        LET g_bok[l_ac].ima08_b = g_ima08_b
        DISPLAY g_bok[l_ac].ima08_b TO s_bok[l_sl].ima08_b
    END IF
END FUNCTION
 
FUNCTION  i616_bdate(p_cmd)
  DEFINE   l_bok04_a,l_bok04_i LIKE bok_file.bok04,
           l_bok05_a,l_bok05_i LIKE bok_file.bok05,
           p_cmd     LIKE type_file.chr1,     #VARCHAR(01),
           l_n       LIKE type_file.num10     #INTEGER
 
    LET g_errno = " "
    IF p_cmd = 'a' THEN
       SELECT COUNT(*) INTO l_n FROM bok_file
                             WHERE bok31 = g_boj.boj09         #主件
                               AND bok01 = g_boj.boj01
                               AND bok32 = g_bok[l_ac].bok32  #項次
                               AND bok04 = g_bok[l_ac].bok04
       IF l_n >= 1 THEN  LET g_errno = 'mfg2737' RETURN END IF
    END IF
    IF p_cmd = 'u' THEN
       SELECT count(*) INTO l_n FROM bok_file
                      WHERE bok31 = g_boj.boj09         #主件
                        AND bok01 = g_boj.boj01
                        AND bok32 = g_bok[l_ac].bok32   #項次
       IF l_n = 1 THEN RETURN END IF
    END IF
    SELECT MAX(bok04),MAX(bok05) INTO l_bok04_a,l_bok05_a
                       FROM bok_file
                      WHERE bok31 = g_boj.boj09        #主件
                        AND bok01 = g_boj.boj01
                       AND  bok32 = g_bok[l_ac].bok32   #項次
                       AND  bok04 < g_bok[l_ac].bok04   #生效日
    IF l_bok04_a IS NOT NULL AND l_bok05_a IS NOT NULL
    THEN IF (g_bok[l_ac].bok04 > l_bok04_a )
            AND (g_bok[l_ac].bok04 < l_bok05_a)
         THEN LET g_errno = 'mfg2737'
              RETURN
         END IF
    END IF
    IF g_bok[l_ac].bok04 <  l_bok04_a THEN
        LET g_errno = 'mfg2737'
    END IF
    IF l_bok04_a IS NULL AND l_bok05_a IS NULL THEN
       RETURN
    END IF
 
    SELECT MIN(bok04),MIN(bok05) INTO l_bok04_i,l_bok05_i
                       FROM bok_file
                      WHERE bok31 = g_boj.boj09         #主件
                       AND  bok01 = g_boj.boj01
                       AND  bok32 = g_bok[l_ac].bok32   #項次
                       AND  bok04 > g_bok[l_ac].bok04   #生效日
    IF l_bok04_i IS NULL AND l_bok05_i IS NULL THEN RETURN END IF
    IF l_bok04_a IS NULL AND l_bok05_a IS NULL THEN
       IF g_bok[l_ac].bok04 < l_bok04_i THEN
          LET g_errno = 'mfg2737'
       END IF
    END IF
    IF g_bok[l_ac].bok04 > l_bok04_i THEN LET g_errno = 'mfg2737' END IF
END FUNCTION
 
FUNCTION  i616_edate(p_cmd)
  DEFINE   l_bok04_i   LIKE bok_file.bok04,
           l_bok04_a   LIKE bok_file.bok04,
           p_cmd       LIKE type_file.chr1,    #VARCHAR(01),
           l_n         LIKE type_file.num5     #SMALLINT
 
    IF p_cmd = 'u' THEN
       SELECT COUNT(*) INTO l_n FROM bok_file
                      WHERE bok31 = g_boj.boj09         #主件
                        AND bok01 = g_boj.boj01
                        AND bok32 = g_bok[l_ac].bok32   #項次
       IF l_n =1 THEN RETURN END IF
    END IF
    LET g_errno = " "
    SELECT MIN(bok04) INTO l_bok04_i
                       FROM bok_file
                      WHERE bok31 = g_boj.boj09         #主件
                       AND  bok01 = g_boj.boj01
                       AND  bok32 = g_bok[l_ac].bok32   #項次
                       AND  bok04 > g_bok[l_ac].bok04   #生效日
   SELECT MAX(bok04) INTO l_bok04_a
                       FROM bok_file
                      WHERE bok31 = g_boj.boj09         #主件
                       AND  bok01 = g_boj.boj01
                       AND  bok32 = g_bok[l_ac].bok32   #項次
                       AND  bok04 > g_bok[l_ac].bok04   #生效日
   IF l_bok04_i IS NULL THEN RETURN END IF
   IF g_bok[l_ac].bok05 > l_bok04_i THEN LET g_errno = 'mfg2738' END IF
END FUNCTION
 
FUNCTION  i616_bok10()
DEFINE l_gfeacti       LIKE gfe_file.gfeacti
 
LET g_errno = ' '
 
     SELECT gfeacti INTO l_gfeacti FROM gfe_file
       WHERE gfe01 = g_bok[l_ac].bok10
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
         WHEN l_gfeacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
#=====>此FUNCTION 目的在update 上一筆的失效日
FUNCTION i616_update(p_cmd) DEFINE l_bok01 LIKE bok_file.bok01,l_bok31 LIKE bok_file.bok31,l_bok32 LIKE bok_file.bok32
  DEFINE p_cmd     LIKE type_file.chr1,    #VARCHAR(01),
         l_bok02   LIKE bok_file.bok02,
         l_bok03   LIKE bok_file.bok03,
         l_bok04   LIKE bok_file.bok04

    DECLARE i616_update SCROLL CURSOR  FOR
            SELECT bok02,bok03,bok04,bok01,bok31,bok32 FROM bok_file
                   WHERE bok31 = g_boj.boj09
                     AND bok01 = g_boj.boj01
                     AND bok32 = g_bok[l_ac].bok32
                     AND (bok04 < g_bok[l_ac].bok04)
                   ORDER BY bok04
    OPEN i616_update
    FETCH LAST i616_update INTO l_bok02,l_bok03,l_bok04,l_bok01,l_bok31,l_bok32
    IF SQLCA.sqlcode = 0
       THEN UPDATE bok_file SET bok05 = g_bok[l_ac].bok04
                          WHERE bok31 = g_boj.boj09
                            AND bok01 = g_boj.boj01
                            AND bok02 = l_bok02
                            AND bok03 = l_bok03
                            AND bok04 = l_bok04
           CALL cl_err('','abm-810','0')   
    END IF
    CLOSE i616_update
END FUNCTION
 
FUNCTION i616_b_askkey()
DEFINE
    l_wc2        STRING        #NO.FUN-910082   
 
    CLEAR ima02_b,ima021_b,ima08_b
    CONSTRUCT l_wc2 ON bok32,bok02,bok03,bok04,bok05,# 螢幕上取單身條件
                       bok06,bok07,bok10,bok08,bok13,bok19,bok24,bok34
         FROM s_bok[1].bok32,s_bok[1].bok02,s_bok[1].bok03,s_bok[1].bok04,s_bok[1].bok05,
              s_bok[1].bok06,s_bok[1].bok07,s_bok[1].bok10,s_bok[1].bok08,
              s_bok[1].bok13,s_bok[1].bok19,s_bok[1].bok24,s_bok[1].bok34
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
    CALL i616_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i616_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2       STRING      #NO.FUN-910082  
 
    LET g_sql =
        "SELECT bok32,bok02,bok30,bok03,ima02,ima021,ima08,bok09,bok16,bok14,bok04,bok05,bok06,bok07,",
        "       bok10,bok08,bok19,bok24,bok13,bok34 ",
        " FROM bok_file,  ima_file",
        " WHERE bok31 ='",g_boj.boj09,"' ",
        "   AND bok01 ='",g_boj.boj01,"' ",
        "   AND bok03 = ima_file.ima01 ",
        "   AND bok06 != 0 ",          #No.FUN-610022組成用量為零就不顯示了
        "   AND ",p_wc2 CLIPPED
 
    CASE g_sma.sma65
      WHEN '1'  LET g_sql = g_sql CLIPPED, " ORDER BY 2,3,4"
      WHEN '2'  LET g_sql = g_sql CLIPPED, " ORDER BY 3,2,4"
      WHEN '3'  LET g_sql = g_sql CLIPPED, " ORDER BY 7,2,4"
      OTHERWISE LET g_sql = g_sql CLIPPED, " ORDER BY 2,3,4"
    END CASE
 
    PREPARE i616_pb FROM g_sql
    DECLARE bok_curs                       #SCROLL CURSOR
        CURSOR FOR i616_pb
 
    CALL g_bok.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH bok_curs INTO g_bok[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
  EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_bok.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i616_bp(p_ud)
   DEFINE   p_ud     LIKE type_file.chr1    
   DEFINE   l_count  LIKE type_file.num5    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_bok TO s_bok.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
   BEFORE DISPLAY
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   IF s_industry("slk") THEN
      CALL cl_getmsg("abm-603",2) RETURNING g_msg
      CALL i616_set_act_title("insert_loc",g_msg)
   END IF
 
 
      BEFORE ROW                                 
         LET l_ac = ARR_CURR()                  
       CALL cl_show_fld_cont()                 
         LET l_sl = SCR_LINE()                  
 
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
         CALL i616_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL i616_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
 ACCEPT DISPLAY               
 
      ON ACTION jump
         CALL i616_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
 ACCEPT DISPLAY                  
 
      ON ACTION next
         CALL i616_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
 ACCEPT DISPLAY                   
 
      ON ACTION last
         CALL i616_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
 ACCEPT DISPLAY                   
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         IF g_boj.boj10 = '1' OR g_boj.boj10 = '2' THEN
            LET g_chr2 = 'Y'
         ELSE
            LET g_chr2 = 'N'
         END IF
         CALL cl_set_field_pic("",g_chr2,"","","",g_boj.bojacti)
         EXIT DISPLAY
     #ON ACTION 審核 
      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT DISPLAY
     #ON ACTION 取消審核
      ON ACTION unconfirm
         LET g_action_choice = "unconfirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end  
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
         CALL cl_show_fld_cont()                  
         IF g_boj.boj10 = '1' OR g_boj.boj10 = '2' THEN
            LET g_chr2 = 'Y'
         ELSE
            LET g_chr2 = 'N'
         END IF
         #CALL cl_set_field_pic("",g_chr2,"","","",g_boj.bojacti)  #CHI-C80041
         IF g_boj.boj10 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF  #CHI-C80041
         CALL cl_set_field_pic("",g_chr2,"","",g_void,g_boj.bojacti)  #CHI-C80041
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 發放
      ON ACTION bom_release         
         LET g_action_choice="bom_release"
         EXIT DISPLAY
    #TQC-BB0186--add--begin--
    #@ON ACTION 發放還原
      ON ACTION bom_reduction
         LET g_action_choice="bom_reduction"
         EXIT DISPLAY
    #TQC-BB0186--add--end--
 
     #ON ACTION 整批審核 
      ON ACTION confirma
         LET g_action_choice = "confirma"
         EXIT DISPLAY
    #@ON ACTION 整批發放
      ON ACTION bom_release_b         
         LET g_action_choice="bom_release_b"
         EXIT DISPLAY

      ON ACTION insert_loc
         LET g_action_choice="insert_loc"
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
 
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
 
       ON ACTION controls
 
         CALL cl_set_head_visible("","AUTO")   
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i616_copy()
   DEFINE new_boj06,old_boj06 LIKE boj_file.boj06 
   DEFINE new_boj01,old_boj01 LIKE boj_file.boj01
   DEFINE new_boj09,old_boj09 LIKE boj_file.boj09,
         l_bok  RECORD LIKE bok_file.*,
         ef_date       LIKE type_file.dat,      
         ans_1         LIKE type_file.chr1,     
         l_dir         LIKE type_file.chr1,     
         l_sql         STRING                   
  DEFINE li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   LET p_row = 10 LET p_col = 24
   OPEN WINDOW i616_c_w AT p_row,p_col WITH FORM "abm/42f/abmi616_c"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("abmi616_c")
 
    CALL cl_set_comp_visible("old_boj06,new_boj06",g_sma.sma118='Y')
 
 
   LET old_boj01   = g_boj.boj01 LET new_boj01 = NULL
   LET old_boj06   = g_boj.boj06 LET new_boj06 = NULL
   LET old_boj09   = g_boj.boj09 LET new_boj09 = NULL
   LET ans_1  = '1' 

   LET ef_date= NULL
   CALL cl_set_head_visible("","YES")             #No.FUN-6B0033
   INPUT BY NAME old_boj09,new_boj09,old_boj01,new_boj01,old_boj06,new_boj06,ans_1,ef_date #,ans_3,ans_31,ans_4,ans_5 #No.FUN-830116
               WITHOUT DEFAULTS
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i616_set_entry()
         CALL i616_set_no_entry()
         CALL i616_set_required(ans_1)
         CALL i616_set_no_required(ans_1)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("new_boj09")
 
      AFTER FIELD old_boj09
        IF g_sma.sma118 != 'Y' THEN
            IF NOT cl_null(old_boj09) THEN
                SELECT count(*) INTO g_cnt FROM boj_file WHERE boj09 = old_boj09
                                                           AND boj01 = old_boj01
                IF g_cnt=0 THEN CALL cl_err('boj_file',100,0) NEXT FIELD old_boj09 END IF
            END IF
        END IF
      AFTER FIELD old_boj06
        IF cl_null(old_boj06) THEN
            LET old_boj06 = ' '
        END IF
      AFTER FIELD new_boj09
        CALL s_check_no("abm",new_boj09,"","4","boj_file","boj09","") RETURNING li_result,new_boj09                                 
            DISPLAY new_boj09                                                                                         
           IF (NOT li_result) THEN                                                                                                  
              NEXT FIELD new_boj09                                                                                                      
           END IF
          CALL s_auto_assign_no("abm",new_boj09,g_boj.boj11,"4","boj_file","boj09","","","")                                             
               RETURNING li_result,new_boj09                                                                                          
                DISPLAY BY NAME new_boj09                                                                                           
               IF (NOT li_result) THEN                                                                                              
                  NEXT FIELD new_boj09                                                                                                  
               END IF
        IF g_sma.sma118 != 'Y' THEN #FUN-550014 add if 判斷
            IF NOT cl_null(new_boj09) AND NOT cl_null(new_boj01) THEN
                SELECT count(*) INTO g_cnt FROM boj_file WHERE boj09 = new_boj09
                                                           AND boj01 = new_boj01
                IF g_cnt>0 THEN CALL cl_err('boj_file',-239,0) NEXT FIELD new_boj09 END IF
                SELECT count(*) INTO g_cnt FROM ima_file WHERE ima01 = new_boj01
                IF g_cnt=0 THEN CALL cl_err('ima_file',100,0) NEXT FIELD new_boj01 END IF
            END IF
        END IF
      AFTER FIELD new_boj06
        IF cl_null(new_boj06) THEN
            LET new_boj06 = ' '
        END IF
        IF NOT cl_null(new_boj01) THEN
            SELECT count(*) INTO g_cnt FROM ima_file WHERE ima01 = new_boj01
            IF g_cnt=0 THEN CALL cl_err('ima_file',100,0) NEXT FIELD new_boj01 END IF
        END IF
      ON CHANGE ans_1
        IF ans_1 != '3' THEN
            CALL i616_set_no_entry()
            CALL i616_set_no_required(ans_1)
            LET ef_date = NULL
        ELSE
            CALL i616_set_entry()
            CALL i616_set_required(ans_1)
        END IF
      AFTER FIELD ans_1
        IF NOT cl_null(ans_1) THEN
            IF ans_1 NOT MATCHES "[123]" THEN NEXT FIELD ans_1 END IF
        END IF
 

      AFTER FIELD ef_date
        IF cl_null(ef_date) THEN
            NEXT FIELD ef_date
        END IF
 
       AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF

          SELECT count(*) INTO g_cnt FROM boj_file WHERE boj09 = new_boj09
                                                     AND boj01 = new_boj01
          IF g_cnt>0 THEN CALL cl_err('boj_file',-239,0) NEXT FIELD new_boj09 END IF
 
      ON ACTION CONTROLP
        CASE
           WHEN INFIELD(new_boj09)
              LET g_t1=s_get_doc_no(g_boj.boj09)                                                                               
                    CALL q_smy(FALSE,FALSE,g_t1,'ABM','4') RETURNING g_t1                                                           
                   LET new_boj09 = g_t1                                                                                           
                   DISPLAY new_boj09                                                                                       
                    NEXT FIELD new_boj09
           WHEN INFIELD(new_boj01)
#FUN-AA0059 --Begin--
           #     CALL cl_init_qry_var()                                                                                                
           #   LET g_qryparam.form = "q_ima"                                                                                         
           #   CALL cl_create_qry() RETURNING new_boj01                                                                                 
              CALL q_sel_ima(FALSE, "q_ima", "", "" , "", "", "", "" ,"",'' )  RETURNING new_boj01 
#FUN-AA0059 --End--
              DISPLAY BY NAME new_boj01                                                                                                        
              NEXT FIELD new_boj01
           OTHERWISE EXIT CASE
        END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
   CLOSE WINDOW i616_c_w
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   MESSAGE ' COPY.... '
IF cl_sure(0,0) THEN
 
   BEGIN WORK
   LET g_success='Y'
   IF cl_null(old_boj06) THEN LET old_boj06 = ' ' END IF 
   IF cl_null(new_boj06) THEN LET new_boj06 = ' ' END IF 
 



   DROP TABLE y
   SELECT * FROM boj_file
    WHERE boj09=old_boj09
      AND boj01=old_boj01
     INTO TEMP y
   UPDATE y
       SET boj09=new_boj09,     #新的鍵值
           boj06=new_boj06,  #FUN-550014 add
           boj01=new_boj01,
           boj05=NULL,       #發放日
           boj10=0,
           bojuser=g_user,   #資料所有者
           bojgrup=g_grup,   #資料所有者所屬群
           bojmodu=NULL,     #資料修改日期
           bojdate=g_today,  #資料建立日期
           bojacti='Y'       #有效資料
   INSERT INTO boj_file SELECT * FROM y
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err('ins boj: ',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      ROLLBACK WORK
      RETURN
   END IF
   DROP TABLE x
   LET l_sql = " SELECT * FROM bok_file WHERE bok31='",old_boj09,"'",
                                       "  AND bok01='",old_boj01,"'"
   PREPARE i616_pbok FROM l_sql
   DECLARE i616_cbok CURSOR FOR i616_pbok
   FOREACH i616_cbok INTO l_bok.*
      IF SQLCA.SQLCODE THEN CALL cl_err('sel bok:',SQLCA.SQLCODE,0)
         EXIT FOREACH
      END IF
      LET l_bok.bok31 = new_boj09
      LET l_bok.bok29 = new_boj06
      LET l_bok.bok01 = new_boj01
      LET l_bok.bok24=null
      IF ans_1 = '2' THEN LET l_bok.bok04 = g_today END IF
      IF ans_1 = '3' THEN LET l_bok.bok04 = ef_date END IF
      #若生效日不使用原生效日時, 必須將失效日清null
      #否則可能產生 生效日 > 失效日之情況
      IF  ans_1 <> '1' THEN
         LET l_bok.bok05=null
      END IF
      IF cl_null(l_bok.bok28) THEN LET l_bok.bok28 = 0 END IF

      INSERT INTO bok_file VALUES(l_bok.*)
      IF SQLCA.SQLCODE <> 0 THEN
         CALL cl_err3("ins","bok_file",l_bok.bok31,l_bok.bok32,"mfg-001","","",1)  
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
END IF
 
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_err('','abm-019',0)
      LET g_wc="boj09='",new_boj09,"'"
      CALL i616_q()
   ELSE
      ROLLBACK WORK
      CALL cl_err('','abm-020',0)
   END IF
END FUNCTION
 
FUNCTION i616_set_entry()
    CALL cl_set_comp_entry("ef_date,old_boj06,new_boj06",TRUE)  
END FUNCTION
 
FUNCTION i616_set_no_entry()
    CALL cl_set_comp_entry("ef_date",FALSE)
    IF g_sma.sma118 != 'Y' THEN
        CALL cl_set_comp_entry("old_boj06,new_boj06",FALSE)
    END IF
END FUNCTION
 
 
FUNCTION i616_set_required(p_ans_1)
  DEFINE    p_ans_1       LIKE type_file.chr1      
    IF p_ans_1 = '3' THEN
        CALL cl_set_comp_required("ef_date",TRUE)
    END IF
END FUNCTION
 
FUNCTION i616_set_no_required(p_ans_1)
  DEFINE   p_ans_1        LIKE type_file.chr1      
    CALL cl_set_comp_required("ef_date",FALSE)
END FUNCTION
 
 
FUNCTION i616_i_set_entry(p_cmd)
DEFINE   p_cmd  LIKE type_file.chr1
    CALL cl_set_comp_entry("boj09,boj10,boj01",TRUE)#NO.FUN-870127
END FUNCTION
FUNCTION i616_i_set_no_entry(p_cmd)
DEFINE   p_cmd  LIKE type_file.chr1
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN #NO.FUN-870127
        CALL cl_set_comp_entry("boj09,boj01",FALSE)#No.FUN-870127
    END IF
    IF p_cmd ='a' OR p_cmd = 'u' THEN                                                                                 
        CALL cl_set_comp_entry("boj10",FALSE)                                                                         
    END IF
END FUNCTION
FUNCTION i616_b_set_entry()
    CALL cl_set_comp_entry("bok30",TRUE)
END FUNCTION
FUNCTION i616_b_set_no_entry()
    IF g_sma.sma118 != 'Y' THEN
        CALL cl_set_comp_entry("bok30",FALSE)
    END IF
END FUNCTION
 
FUNCTION i616_b_move_to()
   LET g_bok[l_ac].bok32 = b_bok.bok32
   LET g_bok[l_ac].bok02 = b_bok.bok02
   LET g_bok[l_ac].bok30 = b_bok.bok30
   LET g_bok[l_ac].bok03 = b_bok.bok03
   LET g_bok[l_ac].bok09 = b_bok.bok09
   LET g_bok[l_ac].bok16 = b_bok.bok16
   LET g_bok[l_ac].bok14 = b_bok.bok14
   LET g_bok[l_ac].bok04 = b_bok.bok04
   LET g_bok[l_ac].bok05 = b_bok.bok05
   LET g_bok[l_ac].bok06 = b_bok.bok06
   LET g_bok[l_ac].bok07 = b_bok.bok07
   LET g_bok[l_ac].bok10 = b_bok.bok10
   LET g_bok[l_ac].bok08 = b_bok.bok08
   LET g_bok[l_ac].bok19 = b_bok.bok19
   LET g_bok[l_ac].bok24 = b_bok.bok24
   LET g_bok[l_ac].bok13 = b_bok.bok13
   LET g_bok[l_ac].bok34 = b_bok.bok34
 
END FUNCTION
 
FUNCTION i616_b_move_back()
   #KEY 值
   LET b_bok.bok31 = g_boj.boj09
   LET b_bok.bok01 = g_boj.boj01
   LET b_bok.bok32 = g_bok[l_ac].bok32
   LET b_bok.bok02 = g_bok[l_ac].bok02
   LET b_bok.bok30 = g_bok[l_ac].bok30
   LET b_bok.bok03 = g_bok[l_ac].bok03
   LET b_bok.bok09 = g_bok[l_ac].bok09
   LET b_bok.bok16 = g_bok[l_ac].bok16
   LET b_bok.bok14 = g_bok[l_ac].bok14
   LET b_bok.bok04 = g_bok[l_ac].bok04
   LET b_bok.bok05 = g_bok[l_ac].bok05
   LET b_bok.bok06 = g_bok[l_ac].bok06
   LET b_bok.bok07 = g_bok[l_ac].bok07
   LET b_bok.bok10 = g_bok[l_ac].bok10
   LET b_bok.bok08 = g_bok[l_ac].bok08
   LET b_bok.bok19 = g_bok[l_ac].bok19
   LET b_bok.bok24 = g_bok[l_ac].bok24
   LET b_bok.bok13 = g_bok[l_ac].bok13
   LET b_bok.bok34 = g_bok[l_ac].bok34
   
   IF cl_null(b_bok.bok29) THEN
      LET b_bok.bok29  = g_boj.boj06
   END IF
 
   IF cl_null(b_bok.bok29) THEN
      LET b_bok.bok29  = ' '
   END IF
 
END FUNCTION
 
#整批審核
FUNCTION i616_confirma()
   DEFINE l_boj        RECORD LIKE boj_file.*,
          l_sql1       STRING,
          l_i          LIKE type_file.num5,
          l_flag1      LIKE type_file.chr1
  LET p_row = 10
  LET p_col = 35
  
  OPEN WINDOW i616a_w AT p_row,p_col WITH FORM "abm/42f/abmi616a"                                                               
         ATTRIBUTE (STYLE = g_win_style CLIPPED)      
 
   CALL cl_ui_locale("abmi616a")
   LET l_flag1 = 'N'
   CONSTRUCT BY NAME g_wc3 ON
     boj09,boj11,boj01,boj06
      
      BEFORE  CONSTRUCT
         CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds                                                                                                           
         CALL cl_on_idle()                                                                                                          
         CONTINUE CONSTRUCT
      ON ACTION cancel
        EXIT CONSTRUCT
   END CONSTRUCT                                                                                                                    
 
 CLOSE WINDOW i616a_w 
  IF INT_FLAG THEN 
     LET INT_FLAG = 0 
     RETURN 
  END IF
  IF NOT cl_confirm('abm-852') THEN 
     RETURN
  END IF
  LET l_sql1 = " SELECT boj10,boj09,boj01 FROM boj_file",
                " WHERE ",g_wc3 CLIPPED
  PREPARE i616_c1 FROM l_sql1
  DECLARE i616_c1_curs
          CURSOR WITH HOLD FOR i616_c1
  LET l_i = 1
  FOREACH i616_c1_curs INTO l_boj10[l_i],l_boj09[l_i],l_boj01[l_i]
     LET l_flag1 = 'Y'
     IF l_boj10[l_i] = '0' THEN
        UPDATE boj_file SET boj10 = '1'
         WHERE boj09 = l_boj09[l_i]
           AND boj01 = l_boj01[l_i]
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","boj_file",g_boj.boj09,g_boj.boj01,SQLCA.sqlcode,"","up boj10",1)  
           EXIT FOREACH
        ELSE
           LET g_boj.boj10 = '1'
           DISPLAY BY NAME g_boj.boj10
        END IF
     END IF
     LET l_i=l_i+1
 END FOREACH
 IF l_flag1 = 'N' THEN 
    CALL cl_err('','abm-854',0)
 END IF
END FUNCTION
 
FUNCTION i616_confirm()
   DEFINE l_cnt   LIKE type_file.num5  
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_boj.boj09) THEN
      CALL cl_err('','-400',0) 
      RETURN
   END IF
   IF g_boj.boj10='1' THEN CALL cl_err('','9023',1) RETURN END IF     #CHI-C30107 add
   IF g_boj.boj10='2' THEN CALL cl_err('','abm-123',1) RETURN END IF  #CHI-C30107 add
   IF g_boj.boj10 = 'X' THEN RETURN END IF  #CHI-C80041
   IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 add
 
   SELECT * INTO g_boj.* FROM boj_file
    WHERE boj09=g_boj.boj09
      AND boj01=g_boj.boj01
 
   IF g_boj.boj10='1' THEN CALL cl_err('','9023',1) RETURN END IF
   IF g_boj.boj10='2' THEN CALL cl_err('','abm-123',1) RETURN END IF
   IF g_boj.boj10 = 'X' THEN RETURN END IF  #CHI-C80041
 
   #---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM boj_file
    WHERE boj09=g_boj.boj09
      AND boj01=g_boj.boj01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',1)
      RETURN
   END IF
 
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
 
   BEGIN WORK
 
   OPEN i616_cl USING g_boj.boj01,g_boj.boj09
   IF STATUS THEN
      CALL cl_err("OPEN i616_cl:", STATUS, 1)
      CLOSE i616_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i616_cl INTO g_boj.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_boj.boj09,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i616_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_boj.boj10 = '0' THEN
      LET g_boj.boj10 = '1'
   END IF
 
   CALL i616_show()
 
   IF INT_FLAG THEN                   #使用者不玩了
      LET g_boj.boj10 ='0' 
      LET INT_FLAG = 0
      DISPLAY By Name g_boj.boj10
      CALL cl_err('',9001,0)
      CLOSE i616_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE boj_file
      SET boj10 = g_boj.boj10
    WHERE boj01=g_boj.boj01 AND boj09=g_boj.boj09
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(g_boj.boj09,SQLCA.sqlcode,0)
      CALL i616_show()
      ROLLBACK WORK
      RETURN
   END IF
   CLOSE i616_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i616_unconfirm()
 
   IF cl_null(g_boj.boj09) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF
 
   SELECT * INTO g_boj.* FROM boj_file
    WHERE boj09=g_boj.boj09
      AND boj01=g_boj.boj01
 
   IF g_boj.boj10='0' THEN CALL cl_err('','9002',1)    RETURN END IF
   IF g_boj.boj10='2' THEN CALL cl_err('','aec-108',1) RETURN END IF
   IF g_boj.boj10 = 'X' THEN RETURN END IF  #CHI-C80041
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   BEGIN WORK   
   OPEN i616_cl USING g_boj.boj01,g_boj.boj09
   IF STATUS THEN
      CALL cl_err("OPEN i616_cl:", STATUS, 1)
      CLOSE i616_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i616_cl INTO g_boj.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_boj.boj09,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i616_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   IF g_boj.boj10 = '1' THEN
      LET g_boj.boj10 = '0'
   END IF
 
   CALL i616_show()
 
   UPDATE boj_file
      SET boj10 = g_boj.boj10
    WHERE boj01=g_boj.boj01 AND boj09=g_boj.boj09
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(g_boj.boj09,SQLCA.sqlcode,0)
      CALL i616_show()
      ROLLBACK WORK
      RETURN
   END IF
   CLOSE i616_cl
   COMMIT WORK
END FUNCTION
 

FUNCTION i616_set_bok13_entry()                                                                                                     
   IF s_industry('slk') THEN                                                                                                        
    CALL cl_set_comp_entry("bok13",TRUE)                                                                                            
   ELSE                                                                                                                             
    CALL cl_set_comp_entry("bok13",FALSE)                                                                                           
   END IF                                                                                                                           
END FUNCTION 

FUNCTION i616_set_act_title(ps_act_names, pi_title)
   DEFINE   ps_act_names    STRING,
            pi_title        STRING 
   DEFINE   la_act_type     DYNAMIC ARRAY OF STRING,
            lnode_root      om.DomNode,
            li_i            LIKE type_file.num5, 
            lst_act_names   base.StringTokenizer,
            ls_act_name     STRING,
            llst_items      om.NodeList,
            li_j            LIKE type_file.num5, 
            lnode_item      om.DomNode,
            ls_item_name    STRING,
            ls_item_tag     STRING
 
   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN
      RETURN
   END IF
 
   IF (ps_act_names IS NULL) THEN
      RETURN
   ELSE
      LET ps_act_names = ps_act_names.toLowerCase()
   END IF
 
 
   LET la_act_type[1] = "ActionDefault"
   LET la_act_type[2] = "LocalAction"
   LET la_act_type[3] = "Action"
   LET la_act_type[4] = "MenuAction"
   LET lnode_root = ui.Interface.getRootNode()
   FOR li_i = 1 TO la_act_type.getLength()
      LET lst_act_names = base.StringTokenizer.create(ps_act_names, ",")
      WHILE lst_act_names.hasMoreTokens() 
         LET ls_act_name = lst_act_names.nextToken()
         LET ls_act_name = ls_act_name.trim()
         LET llst_items = lnode_root.selectByTagName(la_act_type[li_i])
 
         FOR li_j = 1 TO llst_items.getLength()
            LET lnode_item = llst_items.item(li_j)
            LET ls_item_name = lnode_item.getAttribute("name")
            IF (ls_item_name IS NULL) THEN
               CONTINUE FOR
            END IF
 
            IF (ls_item_name.equals(ls_act_name)) THEN
                CALL lnode_item.setAttribute("text",pi_title)
               EXIT FOR
            END IF
         END FOR
      END WHILE
   END FOR
END FUNCTION
#No:FUN-9C0077
#CHI-C80041---begin
#FUNCTION i616_v()       #CHI-D20010
FUNCTION i616_v(p_type)  #CHI-D20010
DEFINE l_chr  LIKE type_file.chr1
DEFINE l_flag LIKE type_file.chr1
DEFINE p_type LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_boj.boj01) OR cl_null(g_boj.boj09) THEN CALL cl_err('',-400,0) RETURN END IF  

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_boj.boj10 ='X' THEN RETURN END IF
   ELSE
      IF g_boj.boj10 <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN i616_cl USING g_boj.boj01,g_boj.boj09
   IF STATUS THEN
      CALL cl_err("OPEN i616_cl:", STATUS, 1)
      CLOSE i616_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i616_cl INTO g_boj.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_boj.boj09,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE i616_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_boj.boj10 = '1' OR g_boj.boj10 = '2' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF g_boj.boj10 = 'X' THEN LET l_flag = 'X' ELSE LET l_flag = 'N' END IF 
   IF cl_void(0,0,l_flag) THEN 
        LET l_chr=g_boj.boj10
       #IF g_boj.boj10='0' THEN  #CHI-D20010
        IF p_type = 1 THEN   #CHI-D20010
            LET g_boj.boj10='X' 
        ELSE
            LET g_boj.boj10='0'
        END IF
        UPDATE boj_file
            SET boj10=g_boj.boj10,  
                bojmodu=g_user,
                bojdate=g_today
            WHERE boj01=g_boj.boj01
              AND boj09=g_boj.boj09
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","boj_file",g_boj.boj09,"",SQLCA.sqlcode,"","",1)  
            LET g_boj.boj10=l_chr 
        END IF
        DISPLAY BY NAME g_boj.boj10
   END IF
 
   CLOSE i616_cl
   COMMIT WORK
   CALL cl_flow_notify(g_boj.boj09,'V')
 
END FUNCTION
#CHI-C80041---end
