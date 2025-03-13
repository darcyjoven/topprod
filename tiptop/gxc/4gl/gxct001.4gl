# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: gxct001.4gl
# Descriptions...: 庫存入項開帳資料維護作業
# Date & Author..: 04/02/10 By Danny
# Modify.........: No.FUN-580014 05/08/15 By day 報表轉xml
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-5B0116 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-5C0002 05/12/05 By Sarah 補印ima021
# Modify.........: No.TQC-5C0059 05/12/15 By kevin 加入報表名稱
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680145 06/09/01 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0099 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0079 06/12/01 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-720019 07/03/02 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770001 07/07/02 By sherry  點擊"幫助"按鈕無效
# Modify.........: No.FUN-7C0101 08/01/09 By Zhangyajun 成本改善增加cxd010(成本計算類別),cxd011(類別編號)和各種制費
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-830135 08/03/27 By Zhangyajun Bug修改,報表增加字段
# Modify.........: No.FUN-830152 08/07/01 By baofei  報表打印改為CR輸出  
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-AA0059 10/10/28 By chenying 料號開窗控管
# Modify.........: No.FUN-AB0025 10/11/10 By vealxu 全系統增加料件管控
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_cxd01         LIKE cxd_file.cxd01,
    g_cxd02         LIKE cxd_file.cxd02,
    g_cxd03         LIKE cxd_file.cxd03,
    g_cxd010        LIKE cxd_file.cxd010,      #No.FUN-7C0101
    g_cxd011        LIKE cxd_file.cxd011,      #No.FUN-7C0101
    g_cxd01_t       LIKE cxd_file.cxd01,
    g_cxd02_t       LIKE cxd_file.cxd02,
    g_cxd03_t       LIKE cxd_file.cxd03,
    g_cxd010_t      LIKE cxd_file.cxd010,      #No.FUN-7C0101
    g_cxd011_t      LIKE cxd_file.cxd011,       #No.FUN-7C0101
    g_cxd           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        cxd04       LIKE cxd_file.cxd04,
        cxd05       LIKE cxd_file.cxd05,
        cxd06       LIKE cxd_file.cxd06,
        cxd07       LIKE cxd_file.cxd07,
        cxd08       LIKE cxd_file.cxd08,
        cxd091      LIKE cxd_file.cxd091,
        cxd092      LIKE cxd_file.cxd092,
        cxd093      LIKE cxd_file.cxd093,
        cxd094      LIKE cxd_file.cxd094,
        cxd095      LIKE cxd_file.cxd095,
        cxd096      LIKE cxd_file.cxd096,    #No.FUN-7C0101
        cxd097      LIKE cxd_file.cxd097,    #No.FUN-7C0101
        cxd098      LIKE cxd_file.cxd098,    #No.FUN-7C0101
        cxd09       LIKE cxd_file.cxd09,
        up1         LIKE ccc_file.ccc23,
        up2         LIKE ccc_file.ccc23,
        up3         LIKE ccc_file.ccc23,
        up4         LIKE ccc_file.ccc23,
        up5         LIKE ccc_file.ccc23,
        up6         LIKE ccc_file.ccc23,
        up7         LIKE ccc_file.ccc23,
        up8         LIKE ccc_file.ccc23,
        up          LIKE ccc_file.ccc23
                    END RECORD,
    g_cxd_t         RECORD                    #程式變數 (舊值)
        cxd04       LIKE cxd_file.cxd04,
        cxd05       LIKE cxd_file.cxd05,
        cxd06       LIKE cxd_file.cxd06,
        cxd07       LIKE cxd_file.cxd07,
        cxd08       LIKE cxd_file.cxd08,
        cxd091      LIKE cxd_file.cxd091,
        cxd092      LIKE cxd_file.cxd092,
        cxd093      LIKE cxd_file.cxd093,
        cxd094      LIKE cxd_file.cxd094,
        cxd095      LIKE cxd_file.cxd095,
        cxd096      LIKE cxd_file.cxd096,    #No.FUN-7C0101
        cxd097      LIKE cxd_file.cxd097,    #No.FUN-7C0101
        cxd098      LIKE cxd_file.cxd098,    #No.FUN-7C0101
        cxd09       LIKE cxd_file.cxd09,
        up1         LIKE ccc_file.ccc23,
        up2         LIKE ccc_file.ccc23,
        up3         LIKE ccc_file.ccc23,
        up4         LIKE ccc_file.ccc23,
        up5         LIKE ccc_file.ccc23,
        up6         LIKE ccc_file.ccc23,
        up7         LIKE ccc_file.ccc23,
        up8         LIKE ccc_file.ccc23,
        up          LIKE ccc_file.ccc23
                    END RECORD,
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_ima           RECORD LIKE ima_file.*,
    g_delete        LIKE type_file.chr1,         #NO.FUN-680145 VARCHAR(01)     #若刪除資料,則要重新顯示筆數
    g_rec_b         LIKE type_file.num5,         #NO.FUN-680145 SMALLINT     #單身筆數
    l_za05          LIKE type_file.chr1000,      #NO.FUN-680145 VARCHAR(40)
    l_ac            LIKE type_file.num5          #NO.FUN-680145 SMALLINT     #目前處理的ARRAY CNT
DEFINE p_row,p_col     LIKE type_file.num5       #NO.FUN-680145 SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp       STRING   #No.TQC-720019
DEFINE   g_cnt           LIKE type_file.num10    #NO.FUN-680145 INTEGER
DEFINE   g_chr           LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(01)
DEFINE   g_i             LIKE type_file.num5     #NO.FUN-680145 SMALLINT      #count/index for any purpose
DEFINE   g_str           STRING                  #No.FUN-830152 
DEFINE   g_msg           LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #NO.FUN-680145 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #NO.FUN-680145 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #NO.FUN-680145 INTEGER        #,d8_+|)w*:5'<F
DEFINE   mi_no_ask       LIKE type_file.num5     #NO.FUN-680145 SMALLINT       #,O'_6}1R+|)w5'5x5!
DEFINE   g_before_input_done LIKE type_file.num5          #NO.FUN-680145 SMALLINT
 
#主程式開始
MAIN
#DEFINE                                            #No.FUN-6A0099
#       l_time    LIKE type_file.chr8              #No.FUN-6A0099
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("GXC")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
         RETURNING g_time    #No.FUN-6A0099
    INITIALIZE g_cxd_t.* TO NULL
    LET g_forupd_sql =
        "SELECT * FROM cxd_file WHERE cxd01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t001_crl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 3 LET p_col = 17
    OPEN WINDOW t001_w AT p_row,p_col               #顯示畫面
        WITH FORM "gxc/42f/gxct001" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    LET g_delete='N'
    LET g_action_choice=""
    CALL t001_menu()
    CLOSE WINDOW t001_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
         RETURNING g_time    #No.FUN-6A0099
END MAIN
 
#QBE 查詢資料
FUNCTION t001_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE  l_cxd010        LIKE cxd_file.cxd010   #No.FUN-7C0101 
    CLEAR FORM                             #清除畫面
    CALL g_cxd.clear()
 
   INITIALIZE g_cxd01 TO NULL    #No.FUN-750051
   INITIALIZE g_cxd02 TO NULL    #No.FUN-750051
   INITIALIZE g_cxd03 TO NULL    #No.FUN-750051
   INITIALIZE g_cxd010 TO NULL    #No.FUN-7C0101
   INITIALIZE g_cxd011 TO NULL    #No.FUN-7C0101
    CONSTRUCT BY NAME g_wc ON cxd01,cxd02,cxd03,cxd010,cxd011,cxduser,cxdgrup,cxdmodu,cxddate  #No.FUN-7C0101 add cxd010,cxd011
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        #No.FUN-7C0101--start--
        AFTER FIELD cxd010
            LET l_cxd010 = get_fldbuf(cxd010) 
        #No.FUN-7C0101---end---
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(cxd01)
#FUN-AA0059---------mod------------str----------------- 
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_ima"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end------------------
                  DISPLAY g_qryparam.multiret TO cxd01
                  NEXT FIELD cxd01 
              #No.FUN-7C0101--start--                                                            
              WHEN INFIELD(cxd011)                                               
                 IF l_cxd010 MATCHES '[45]' THEN                                 
                    CALL cl_init_qry_var()                                      
                    LET g_qryparam.state= "c"                                   
                 CASE l_cxd010                                                   
                    WHEN '4'                                                    
                      LET g_qryparam.form = "q_pja"                             
                    WHEN '5'                                                    
                      LET g_qryparam.form = "q_gem4"                            
                    OTHERWISE EXIT CASE                                         
                 END CASE                                                       
                 CALL cl_create_qry() RETURNING g_qryparam.multiret             
                 DISPLAY  g_qryparam.multiret TO cxd011                          
                 NEXT FIELD cxd011                                               
                 END IF                                                         
               #No.FUN-7C0101---end---              
                OTHERWISE
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cxduser', 'cxdgrup') #FUN-980030
 
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON cxd04,cxd05,cxd06,cxd07,cxd08,cxd091,cxd092,
                       cxd093,cxd094,cxd095,cxd096,cxd097,cxd098,cxd09   #No.FUN-7C0101 add cxd069,cxd097,cxd098
                  FROM s_cxd[1].cxd04,s_cxd[1].cxd05,s_cxd[1].cxd06,
                       s_cxd[1].cxd07,s_cxd[1].cxd08,s_cxd[1].cxd091,
                       s_cxd[1].cxd092,s_cxd[1].cxd093,s_cxd[1].cxd094,
                       s_cxd[1].cxd095,s_cxd[1].cxd096,s_cxd[1].cxd097,  #No.FUN-7C0101
                       s_cxd[1].cxd098,s_cxd[1].cxd09
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 
    LET g_sql="SELECT DISTINCT cxd01,cxd02,cxd03,cxd010,cxd011 ",   #No.FUN7C0101 add cxd010,cxd011
              "  FROM cxd_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
              " ORDER BY cxd01,cxd02,cxd03,cxd010,cxd011 "          #No.FUN-7C0101
    PREPARE t001_prepare FROM g_sql      #預備一下
    DECLARE t001_bcs                  #宣告成可卷動的
        SCROLL CURSOR WITH HOLD FOR t001_prepare
 
    #因主鍵值有兩個故所抓出資料筆數有誤
    DROP TABLE x
#   LET g_sql="SELECT DISTINCT cxd01,cxd02,cxd03 ",      #No.TQC-720019
    LET g_sql_tmp="SELECT DISTINCT cxd01,cxd02,cxd03,cxd010,cxd011 ",  #No.TQC-720019  #No.FUN-7C0101 add cxd010,cxd011
              "  FROM cxd_file WHERE ", g_wc CLIPPED," AND ",g_wc2 CLIPPED,
              " INTO TEMP x"
#   PREPARE t001_precount_x  FROM g_sql      #No.TQC-720019
    PREPARE t001_precount_x  FROM g_sql_tmp  #No.TQC-720019
    EXECUTE t001_precount_x
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE t001_precount FROM g_sql
    DECLARE t001_count CURSOR FOR t001_precount
END FUNCTION
 
FUNCTION t001_menu()
   WHILE TRUE
      CALL t001_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL t001_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL t001_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL t001_r()
           END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t001_copy()
            END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL t001_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL t001_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL t001_out()
           END IF
        WHEN "help"
        #  CALL SHOWHELP(1)                  #No.TQC-770001
           CALL cl_show_help()               #No.TQC-770001    
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        #No.FUN-6B0079-------add--------str----
        WHEN "related_document"           #相關文件
         IF cl_chk_act_auth() THEN
            IF g_cxd01 IS NOT NULL THEN
               LET g_doc.column1 = "cxd01"
               LET g_doc.column2 = "cxd02"
               LET g_doc.column3 = "cxd03"
               LET g_doc.column4 = "cxd010"  #No.FUN-7C0101
               LET g_doc.column5 = "cxd011"  #No.FUN-7C0101
               LET g_doc.value1 = g_cxd01
               LET g_doc.value2 = g_cxd02
               LET g_doc.value3 = g_cxd03
               LET g_doc.value4 = g_cxd010   #No.FUN-7C0101
               LET g_doc.value5 = g_cxd011   #No.FUN-7C0101
               CALL cl_doc()
            END IF 
         END IF
        #No.FUN-6B0079-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t001_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_cxd.clear()
    INITIALIZE g_cxd01 LIKE cxd_file.cxd01
    INITIALIZE g_cxd02 LIKE cxd_file.cxd02
    INITIALIZE g_cxd03 LIKE cxd_file.cxd03
    INITIALIZE g_cxd010 LIKE cxd_file.cxd010     #No.FUN-7C0101
    INITIALIZE g_cxd011 LIKE cxd_file.cxd011     #No.FUN-7C0101
    LET g_cxd01_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cxd010 = g_ccz.ccz28        #No.FUN-7C0101
        LET g_cxd011 = ' '                #No.FUN-7C0101
        LET g_cxd02 = YEAR(g_today)
        LET g_cxd03 = MONTH(g_today)
        CALL t001_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
           LET g_cxd01 = NULL
           LET g_cxd02 = NULL
           LET g_cxd03 = NULL
           LET g_cxd010= NULL    #No.FUN-7C0101
           LET g_cxd011= NULL    #No.FUN-7C0101
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        CALL g_cxd.clear()
        LET g_rec_b=0
        CALL t001_b()                      #輸入單身
        LET g_cxd01_t = g_cxd01            #保留舊值
        LET g_cxd02_t = g_cxd02            #保留舊值
        LET g_cxd03_t = g_cxd03            #保留舊值
        LET g_cxd010  = g_cxd010_t         #No.FUN-7C0101
        LET g_cxd011  = g_cxd011_t         #No.FUN-7C0101
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t001_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cxd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cxd01_t = g_cxd01
    WHILE TRUE
        CALL t001_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_cxd01=g_cxd01_t
            LET g_cxd02=g_cxd02_t
            LET g_cxd03=g_cxd03_t
            LET g_cxd010  = g_cxd010_t         #No.FUN-7C0101
            LET g_cxd011  = g_cxd011_t         #No.FUN-7C0101
            DISPLAY g_cxd01 TO cxd01          #ATTRIBUTE(YELLOW) #單頭
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_cxd01 != g_cxd01_t OR g_cxd02 != g_cxd02_t OR
           g_cxd03 != g_cxd03_t OR g_cxd010 !=g_cxd010_t OR     #No.FUN-7C0101
           g_cxd011 != g_cxd011_t THEN #更改單頭值               #No.FUN-7C0101
           UPDATE cxd_file SET cxd01 = g_cxd01,   #更新DB
                               cxd02 = g_cxd02,
                               cxd03 = g_cxd03,
                               cxd010= g_cxd010,               #No.FUN-7C0101
                               cxd011= g_cxd011                #No.FUN-7C0101
            WHERE cxd01 = g_cxd01_t AND cxd02 = g_cxd02_t
              AND cxd03 = g_cxd03_t 
              AND cxd010 = g_cxd010_t AND cxd011 = g_cxd011_t  #No.FUN-7C0101
           IF SQLCA.sqlcode THEN
              LET g_msg = g_cxd01 CLIPPED,' ',g_cxd02 CLIPPED,' ',
                          g_cxd03 CLIPPED,' ',g_cxd010 CLIPPED,' ',g_cxd011 CLIPPED #No.FUN-7C0101
#             CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660146
              CALL cl_err3("upd","cxd_file",g_cxd01_t,g_cxd02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660146
              CONTINUE WHILE
           END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION t001_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)     #a:輸入 u:更改
    l_n             LIKE type_file.num5,    #NO.FUN-680145 smallint
    l_cxd02         LIKE cxd_file.cxd02,
    l_cxd03         LIKE cxd_file.cxd03
 
 
    INPUT g_cxd01,g_cxd02,g_cxd03,g_cxd010,g_cxd011 WITHOUT DEFAULTS   #No.FUN-7C0101
          FROM cxd01,cxd02,cxd03,cxd010,cxd011 HELP 1                  #No.FUN-7C0101
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t001_set_entry(p_cmd)
            CALL t001_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD cxd01
            IF NOT cl_null(g_cxd01) THEN
               #FUN-AB0025 --------------add start----------
               IF NOT s_chk_item_no(g_cxd01,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD cxd01
               END IF
               #FUN-AB0025 -------------add end-----------
               IF p_cmd = 'a' OR (p_cmd = 'u' AND g_cxd01 != g_cxd01_t) THEN
                  SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = g_cxd01
                  IF STATUS THEN
#                    CALL cl_err(g_cxd01,'mfg3006',0)  #No.FUN-660146
                     CALL cl_err3("sel","ima_file",g_cxd01,"","mfg3006","","",1)  #No.FUN-660146
                     NEXT FIELD cxd01 
                  END IF
                  DISPLAY BY NAME g_ima.ima02,g_ima.ima25
               END IF
            END IF
 
        AFTER FIELD cxd03
            IF NOT cl_null(g_cxd03) THEN
               IF g_cxd03 < 1 OR g_cxd03 > 13 THEN NEXT FIELD cxd03 END IF
#               IF p_cmd = 'a' OR (p_cmd = 'u' AND                     #No.FUN-7C0101 mark
#                 (g_cxd01 != g_cxd01_t OR g_cxd02 != g_cxd02_t OR     
#                  g_cxd03 != g_cxd03_t)) THEN                         
#                  SELECT COUNT(*) INTO g_cnt FROM cxd_file           
#                   WHERE cxd01 = g_cxd01 AND cxd02 = g_cxd02         
#                     AND cxd03 = g_cxd03                             
#                  IF g_cnt > 0 THEN                                   
#                     CALL cl_err(g_cxd03,-239,0) NEXT FIELD cxd03
#                  END IF
            END IF
        #No.FUN-7C0101--start--
        AFTER FIELD cxd010
            IF NOT cl_null(g_cxd010) THEN
               IF g_cxd010 NOT MATCHES '[12345]' THEN
                  NEXT FIELD cxd010
               END IF
            END IF
        AFTER FIELD cxd011
            IF NOT cl_null(g_cxd011) THEN             
               IF p_cmd = 'a' OR (p_cmd = 'u' AND
                 (g_cxd01 != g_cxd01_t OR g_cxd02 != g_cxd02_t OR
                  g_cxd03 != g_cxd03_t OR g_cxd010 != g_cxd010_t OR
                  g_cxd011 != g_cxd011_t)) THEN
                CASE g_cxd010                                                                                                    
                 WHEN 4                                                                                                             
                  SELECT pja02 FROM pja_file WHERE pja01 = g_cxd011                                                              
                                               AND pjaclose = 'N'  #No.FUN-960038
                  IF SQLCA.sqlcode!=0 THEN                                                                                          
                     CALL cl_err3('sel','pja_file',g_cxd011,'',SQLCA.sqlcode,'','',1)                                            
                     NEXT FIELD cxd011                                                                                               
                  END IF                                                                                                            
                 WHEN 5                                                                                                             
                   SELECT gem02 FROM gem_file WHERE gem01 = g_cxd011 AND gem09 IN ('1','2') AND gemacti = 'Y'                    
                   IF SQLCA.sqlcode!=0 THEN                                                                                         
                     CALL cl_err3('sel','gem_file',g_cxd011,'',SQLCA.sqlcode,'','',1)                                            
                     NEXT FIELD cxd011                                                                                               
                  END IF                                                                                                            
                 OTHERWISE EXIT CASE                                                                                                
                END CASE
               END IF
           ELSE 
            LET g_cxd011 = ' '
           END IF
              SELECT COUNT(*) INTO g_cnt FROM cxd_file                                                                          
                   WHERE cxd01 = g_cxd01 AND cxd02 = g_cxd02                                                                        
                     AND cxd03 = g_cxd03 AND cxd010 = g_cxd010                                                                      
                     AND cxd011 = g_cxd011                                                                                          
                  IF g_cnt > 0 THEN                                                                                                 
                     CALL cl_err(g_cxd011,-239,0) NEXT FIELD cxd011                                                                 
                  END IF
        #No.FUN-7C0101---end---
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(cxd01)
                # CALL q_ima(0,0,g_cxd01) RETURNING g_cxd01
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_ima"
#                 LET g_qryparam.default1=g_cxd01
#                 CALL cl_create_qry() RETURNING g_cxd01
                  CALL q_sel_ima(FALSE, "q_ima","",g_cxd01,"","","","","",'' ) 
                   RETURNING g_cxd01  
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_cxd01 TO cxd01
                  NEXT FIELD cxd01
              #No.FUN-7C0101--start--
              WHEN INFIELD(cxd011)
                IF g_cxd010 MATCHES '[45]' THEN 
                  CALL cl_init_qry_var()
                  CASE g_cxd010
                    WHEN '4'
                      LET g_qryparam.form = "q_pja"                     
                    WHEN '5'
                      LET g_qryparam.form = "q_gem4"
                    OTHERWISE EXIT CASE
                  END CASE
                  LET g_qryparam.default1 =g_cxd011
                  CALL cl_create_qry() RETURNING g_cxd011
                  DISPLAY BY NAME g_cxd011   
                END IF           
             OTHERWISE EXIT CASE              
             #No.FUN-7C0101---end---
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
END FUNCTION
 
#Query 查詢
FUNCTION t001_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL t001_cs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_cxd01  TO NULL
        INITIALIZE g_cxd02  TO NULL
        INITIALIZE g_cxd03  TO NULL
        INITIALIZE g_cxd010 TO NULL       #No.FUN-7C0101
        INITIALIZE g_cxd011 TO NULL       #No.FUN-7C0101
        RETURN
    END IF
    OPEN t001_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_cxd01 TO NULL
    ELSE
        CALL t001_fetch('F')            #讀出TEMP第一筆并顯示
        OPEN t001_count
        FETCH t001_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t001_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)    #處理方式
    l_abso          LIKE type_file.num10    #NO.FUN-680145 INTEGER    #絕對的筆數
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t001_bcs INTO g_cxd01,g_cxd02,g_cxd03,g_cxd010,g_cxd011 #No.FUN-7C0101
        WHEN 'P' FETCH PREVIOUS t001_bcs INTO g_cxd01,g_cxd02,g_cxd03,g_cxd010,g_cxd011 #No.FUN-7C0101 
        WHEN 'F' FETCH FIRST    t001_bcs INTO g_cxd01,g_cxd02,g_cxd03,g_cxd010,g_cxd011 #No.FUN-7C0101
        WHEN 'L' FETCH LAST     t001_bcs INTO g_cxd01,g_cxd02,g_cxd03,g_cxd010,g_cxd011 #No.FUN-7C0101
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
           FETCH ABSOLUTE g_jump t001_bcs INTO g_cxd01,g_cxd02,g_cxd03,g_cxd010,g_cxd011 #No.FUN-7C0101
           LET mi_no_ask = FALSE
    END CASE
 
{
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_cxd01,SQLCA.sqlcode,0)
    ELSE
        IF g_query='Y' AND g_delete='Y' THEN     #顯示合乎條件筆數
            OPEN t001_count
            FETCH t001_count INTO g_cnt
            DISPLAY g_cnt TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
        END IF
        CALL t001_show()
    END IF
}
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_cxd01,SQLCA.sqlcode,0) 
        INITIALIZE g_cxd01 TO NULL                #No.FUN-6B0079
        INITIALIZE g_cxd02 TO NULL                #No.FUN-6B0079
        INITIALIZE g_cxd03 TO NULL                #No.FUN-6B0079
        INITIALIZE g_cxd010 TO NULL               #No.FUN-7C0101
        INITIALIZE g_cxd011 TO NULL               #No.FUN-7C0101
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
    CALL t001_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t001_show()
    DISPLAY g_cxd01,g_cxd02,g_cxd03,g_cxd010,g_cxd011 TO cxd01,cxd02,cxd03,cxd010,cxd011 #No.FUN-7C0101
 
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = g_cxd01
    DISPLAY BY NAME g_ima.ima02,g_ima.ima25
    CALL t001_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t001_r()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cxd01 IS NULL THEN 
       CALL cl_err("",-400,0)                 #No.FUN-6B0079
       RETURN 
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cxd01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "cxd02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "cxd03"         #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "cxd010"        #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "cxd011"        #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cxd01          #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_cxd02          #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_cxd03          #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_cxd010         #No.FUN-9B0098 10/02/24
        LET g_doc.value5 = g_cxd011         #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM cxd_file WHERE cxd01 = g_cxd01
                               AND cxd02 = g_cxd02 AND cxd03 = g_cxd03
                               AND cxd010 = g_cxd010 AND cxd011 = g_cxd011  #No.FUN-7C0101
        CLEAR FORM
        CALL g_cxd.clear()
        DROP TABLE x                              #No.TQC-720019
        PREPARE t001_precount_x2  FROM g_sql_tmp  #No.TQC-720019
        EXECUTE t001_precount_x2                  #No.TQC-720019
        OPEN t001_count
#FUN-B50065------begin---
        IF STATUS THEN
           CLOSE t001_count
           COMMIT WORK
           RETURN
        END IF
#FUN-B50065------end------
        FETCH t001_count INTO g_row_count
#FUN-B50065------begin---
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t001_count
           COMMIT WORK
           RETURN
        END IF
#FUN-B50065------end------
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t001_bcs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t001_fetch('L')            #讀出TEMP第一筆并顯示
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t001_fetch('/')
        END IF
     END IF
 
#    CLOSE t001_bcs  #No.TQC-720019
     COMMIT WORK
END FUNCTION
 
#單身
FUNCTION t001_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #NO.FUN-680145 SMALLINT      #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,     #NO.FUN-680145 SMALLINT      #檢查重復用
    l_str           LIKE type_file.chr20,    #NO.FUN-680145 VARCHAR(20)
    l_lock_sw       LIKE type_file.chr1,     #NO.FUN-680145 VARCHAR(1)       #單身鎖住否
    p_cmd           LIKE type_file.chr1,     #NO.FUN-680145 VARCHAR(1)       #處理狀態
    l_allow_insert  LIKE type_file.num5,     #NO.FUN-680145 SMALLINT      #可新增否
    l_allow_delete  LIKE type_file.num5      #NO.FUN-680145 SMALLINT      #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cxd01 IS NULL THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
       "SELECT cxd04,cxd05,cxd06,cxd07,cxd08,cxd091,cxd092,cxd093,cxd094,",
       "cxd095,cxd096,cxd097,cxd098,cxd09,0,0,0,0,0,0 FROM cxd_file ",      #No.FUN-7C0101 add cxd096,cxd097,cxd098
       " WHERE cxd01 = ? AND cxd02 = ? AND cxd03 = ? ",
       " AND cxd010 = ? AND cxd011 =? AND cxd04 = ? FOR UPDATE"             #No.FUN-7C0101
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_cxd WITHOUT DEFAULTS FROM s_cxd.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec, #UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                BEGIN WORK
                LET g_cxd_t.* = g_cxd[l_ac].*      #BACKUP
                OPEN t001_bcl USING g_cxd01,g_cxd02,g_cxd03,g_cxd010,g_cxd011,g_cxd_t.cxd04   #No.FUN-7C0101 add cxd010,cxd011
                IF STATUS THEN
                   CALL cl_err("OPEN t001_bcl:", STATUS, 1)
                   LET l_lock_sw='Y'
                ELSE
                   FETCH t001_bcl INTO g_cxd[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cxd_t.cxd04,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL t001_cxd09()
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD cxd04
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_cxd[l_ac].* TO NULL      #900423
            LET g_cxd[l_ac].cxd05 = g_today
            LET g_cxd[l_ac].cxd08 = 0
            LET g_cxd[l_ac].cxd09 = 0
            LET g_cxd[l_ac].cxd091= 0
            LET g_cxd[l_ac].cxd092= 0
            LET g_cxd[l_ac].cxd093= 0
            LET g_cxd[l_ac].cxd094= 0
            LET g_cxd[l_ac].cxd095= 0
            LET g_cxd[l_ac].cxd096= 0     #No.FUN-7C0101
            LET g_cxd[l_ac].cxd097= 0     #No.FUN-7C0101
            LET g_cxd[l_ac].cxd098= 0     #No.FUN-7C0101
            LET g_cxd_t.* = g_cxd[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cxd04
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO cxd_file(cxd01,cxd02,cxd03,cxd010,cxd011,cxd04,cxd05,    #No.FUN-7C0101
                                 cxd06,cxd07,cxd08,cxd09,cxd091,
                                 cxd092,cxd093,cxd094,cxd095,cxd096,cxd097,cxd098, #No.FUN-7C0101
                                 cxdacti,cxduser,cxdgrup,cxdmodu,cxddate, 
                                #cxdplant,cxdlegal,cxdoriu,cxdorig)   #FUN-980011 add   #FUN-A50075
                                 cxdlegal,cxdoriu,cxdorig)   #FUN-A50075
                         VALUES(g_cxd01,g_cxd02,g_cxd03,g_cxd010,g_cxd011,
                                g_cxd[l_ac].cxd04,g_cxd[l_ac].cxd05,
                                g_cxd[l_ac].cxd06,g_cxd[l_ac].cxd07,
                                g_cxd[l_ac].cxd08,g_cxd[l_ac].cxd09,
                                g_cxd[l_ac].cxd091,g_cxd[l_ac].cxd092,
                                g_cxd[l_ac].cxd093,g_cxd[l_ac].cxd094,
                                g_cxd[l_ac].cxd095,g_cxd[l_ac].cxd096,      #No.FUN-7C0101
                                g_cxd[l_ac].cxd097,g_cxd[l_ac].cxd098,      #No.FUN-7C0101
                                'Y',g_user,g_grup,'','',
                               #g_plant,g_legal, g_user, g_grup)     #FUN-980011 add      #No.FUN-980030 10/01/04  insert columns oriu, orig    #FUN-A50075
                                g_legal, g_user, g_grup)     #FUN-A50075
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_cxd[l_ac].cxd04,SQLCA.sqlcode,0)   #No.FUN-660146
               CALL cl_err3("ins","cxd_file",g_cxd01,g_cxd[l_ac].cxd04,SQLCA.sqlcode,"","",1)  #No.FUN-660146
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               COMMIT WORK
            END IF
            LET g_msg=TIME
 
        BEFORE FIELD cxd04
            IF cl_null(g_cxd[l_ac].cxd04) THEN
               SELECT MAX(cxd04)+1 INTO g_cxd[l_ac].cxd04 FROM cxd_file
                WHERE cxd01 = g_cxd01 AND cxd02 = g_cxd02 AND cxd03 = g_cxd03
               IF cl_null(g_cxd[l_ac].cxd04) THEN
                  LET g_cxd[l_ac].cxd04 = 1
               END IF
            END IF
 
        BEFORE FIELD cxd05
            IF NOT cl_null(g_cxd[l_ac].cxd04) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_cxd[l_ac].cxd04 != g_cxd_t.cxd04) THEN
                  SELECT COUNT(*) INTO l_n FROM cxd_file
                   WHERE cxd01 = g_cxd01 AND cxd02 = g_cxd02 AND cxd03 = g_cxd03
                     AND cxd04 = g_cxd[l_ac].cxd04
                  IF l_n > 0 THEN
                     CALL cl_err(g_cxd[l_ac].cxd04,-239,0) NEXT FIELD cxd04
                  END IF
               END IF
            END IF
 
        AFTER FIELD cxd08
           IF g_cxd[l_ac].cxd08 < 0 THEN
              NEXT FIELD cxd08
           END IF
 
        AFTER FIELD cxd091
           IF g_cxd[l_ac].cxd091 < 0 THEN
              NEXT FIELD cxd091
           END IF
           CALL t001_cxd09()
 
        AFTER FIELD cxd092
           IF g_cxd[l_ac].cxd092 < 0 THEN
              NEXT FIELD cxd092
           END IF
           CALL t001_cxd09()
 
        AFTER FIELD cxd093
           IF g_cxd[l_ac].cxd093 < 0 THEN
              NEXT FIELD cxd093
           END IF
           CALL t001_cxd09()
 
        AFTER FIELD cxd094
           IF g_cxd[l_ac].cxd094 < 0 THEN
              NEXT FIELD cxd094
           END IF
           CALL t001_cxd09()
 
        AFTER FIELD cxd095
           IF g_cxd[l_ac].cxd095 < 0 THEN
              NEXT FIELD cxd095
           END IF
           CALL t001_cxd09()
        #No.FUN-7C0101--start--
        AFTER FIELD cxd096
           IF g_cxd[l_ac].cxd096 < 0 THEN
              NEXT FIELD cxd096
           END IF
           CALL t001_cxd09()
        AFTER FIELD cxd097
           IF g_cxd[l_ac].cxd097 < 0 THEN
              NEXT FIELD cxd097
           END IF
           CALL t001_cxd09()
        AFTER FIELD cxd098
           IF g_cxd[l_ac].cxd098 < 0 THEN
              NEXT FIELD cxd098
           END IF
           CALL t001_cxd09()
        #No.FUN-7C0101---end---
        BEFORE DELETE                            #是否取消單身
            IF g_cxd[l_ac].cxd04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM cxd_file
                 WHERE cxd01 = g_cxd01 AND cxd02 = g_cxd02 AND cxd03 = g_cxd03
                   AND cxd010 = g_cxd010 AND cxd011 = g_cxd011 AND cxd04 = g_cxd_t.cxd04  #No.FUN-7C0101
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_cxd_t.cxd04,SQLCA.sqlcode,0)   #No.FUN-660146
                    CALL cl_err3("del","cxd_file",g_cxd01,g_cxd_t.cxd04,SQLCA.sqlcode,"","",1)  #No.FUN-660146
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                LET g_msg=TIME
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cxd[l_ac].* = g_cxd_t.*
               CLOSE t001_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cxd[l_ac].cxd04,-263,1)
               LET g_cxd[l_ac].* = g_cxd_t.*
            ELSE
 UPDATE cxd_file SET      
                   cxd04 = g_cxd[l_ac].cxd04,cxd05 = g_cxd[l_ac].cxd05,   
                   cxd06 = g_cxd[l_ac].cxd06,cxd07 = g_cxd[l_ac].cxd07,   
                   cxd08 = g_cxd[l_ac].cxd08,cxd09 = g_cxd[l_ac].cxd09,   
                   cxd091= g_cxd[l_ac].cxd091,cxd092 = g_cxd[l_ac].cxd092, 
                   cxd093 = g_cxd[l_ac].cxd093,cxd094 = g_cxd[l_ac].cxd094, 
                   cxd095 = g_cxd[l_ac].cxd095,cxdmodu= g_user,cxddate=g_today
              WHERE CURRENT OF t001_bcl
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_cxd[l_ac].cxd04,SQLCA.sqlcode,0)   #No.FUN-660146
                   CALL cl_err3("upd","cxd_file",g_cxd01,g_cxd_t.cxd04,SQLCA.sqlcode,"","",1)  #No.FUN-660146
                   LET g_cxd[l_ac].* = g_cxd_t.*
                   ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
               LET g_msg=TIME
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_cxd[l_ac].* = g_cxd_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_cxd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t001_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add 
            CLOSE t001_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL t001_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(cxd04) AND l_ac > 1 THEN
                LET g_cxd[l_ac].* = g_cxd[l_ac-1].*
                DISPLAY g_cxd[l_ac].* TO s_cxd[l_ac].*
                NEXT FIELD cxd04
            END IF
 
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
 
#No.FUN-7C0101--start-- mark  
#    #FUN-5B0116-begin                     
#     UPDATE cxd_file SET cxdmodu = g_user,cxddate = g_today
#      WHERE cxd01 = g_cxd01
#        AND cxd02 = g_cxd02
#        AND cxd03 = g_cxd03
#        AND cxd010 = g_cxd010
#        AND cxd011 = g_cxd011
#        AND cxd04 = g_cxd[l_ac].cxd04
#     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
##       CALL cl_err('upd cxd_user',SQLCA.SQLCODE,1)   #No.FUN-660146
#       CALL cl_err3("upd","cxd_file",g_cxd01,g_cxd[l_ac].cxd04,SQLCA.sqlcode,"","upd cxd_user",1)  #No.FUN-660146
#     END IF
#    #FUN-5B0116-end
#No.FUN-7C0101---end---
    CLOSE t001_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION t001_cxd09()
 
    LET g_cxd[l_ac].cxd09 = g_cxd[l_ac].cxd091 + g_cxd[l_ac].cxd092 +
                            g_cxd[l_ac].cxd093 + g_cxd[l_ac].cxd094 +
                            g_cxd[l_ac].cxd095 + g_cxd[l_ac].cxd096 +     #No.FUN-7C0101
                            g_cxd[l_ac].cxd097 + g_cxd[l_ac].cxd098
 
    LET g_cxd[l_ac].up1 = g_cxd[l_ac].cxd091 / g_cxd[l_ac].cxd08
    LET g_cxd[l_ac].up2 = g_cxd[l_ac].cxd092 / g_cxd[l_ac].cxd08
    LET g_cxd[l_ac].up3 = g_cxd[l_ac].cxd093 / g_cxd[l_ac].cxd08
    LET g_cxd[l_ac].up4 = g_cxd[l_ac].cxd094 / g_cxd[l_ac].cxd08
    LET g_cxd[l_ac].up5 = g_cxd[l_ac].cxd095 / g_cxd[l_ac].cxd08
    LET g_cxd[l_ac].up6 = g_cxd[l_ac].cxd096 / g_cxd[l_ac].cxd08    #No.FUN-7C0101
    LET g_cxd[l_ac].up7 = g_cxd[l_ac].cxd097 / g_cxd[l_ac].cxd08    #No.FUN-7C0101
    LET g_cxd[l_ac].up8 = g_cxd[l_ac].cxd098 / g_cxd[l_ac].cxd08    #No.FUN-7C0101
    LET g_cxd[l_ac].up  = g_cxd[l_ac].cxd09  / g_cxd[l_ac].cxd08
    DISPLAY BY NAME g_cxd[l_ac].up1
    DISPLAY BY NAME g_cxd[l_ac].up2 
    DISPLAY BY NAME g_cxd[l_ac].up3
    DISPLAY BY NAME g_cxd[l_ac].up4
    DISPLAY BY NAME g_cxd[l_ac].up5
    DISPLAY BY NAME g_cxd[l_ac].up6
    DISPLAY BY NAME g_cxd[l_ac].up7
    DISPLAY BY NAME g_cxd[l_ac].up8
    DISPLAY BY NAME g_cxd[l_ac].up 
END FUNCTION
 
FUNCTION t001_b_askkey()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE
    l_wc            LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(200)
 
 CONSTRUCT l_wc ON cxd04,cxd05,cxd06,cxd07,cxd08,cxd091,cxd092,
                      cxd093,cxd094,cxd095,cxd096,cxd097,cxd098,cxd09        #螢幕上取條件 #No.FUN-7C0101
                 FROM s_cxd[1].cxd04,s_cxd[1].cxd05,s_cxd[1].cxd06,
                      s_cxd[1].cxd07,s_cxd[1].cxd08,s_cxd[1].cxd091,
                      s_cxd[1].cxd092,s_cxd[1].cxd093,s_cxd[1].cxd094,
                      s_cxd[1].cxd095,s_cxd[1].cxd096,s_cxd[1].cxd097,  #No.FUN-7C0101
                      s_cxd[1].cxd098,s_cxd[1].cxd09
 
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
                   CALL cl_qbe_list() RETURNING lc_qbe_sn
                   CALL cl_qbe_display_condition(lc_qbe_sn)
                ON ACTION qbe_save
                   CALL cl_qbe_save()
                #No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
 
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL t001_b_fill(l_wc)
END FUNCTION
 
FUNCTION t001_b_fill(p_wc)              #BODY FILL UP
DEFINE   p_wc            LIKE type_file.chr1000    #NO.FUN-680145 VARCHAR(200)
 
    LET g_sql = "SELECT cxd04,cxd05,cxd06,cxd07,cxd08,cxd091,cxd092,",
                "       cxd093,cxd094,cxd095,cxd096,cxd097,cxd098,cxd09,",
                "       0,0,0,0,0,0,0,0,0 ",  #No.FUN-7C0101
                "  FROM cxd_file ",
                " WHERE cxd01 = '",g_cxd01,"'",
                "   AND cxd02 = ",g_cxd02," AND cxd03 = ",g_cxd03,
                " AND cxd010 = '",g_cxd010,"' AND cxd011 = '",g_cxd011,"' ",     #No.FUN-7C0101
                "   AND ",p_wc CLIPPED ,
                " ORDER BY cxd04"
    PREPARE t001_prepare2 FROM g_sql      #預備一下
    DECLARE cxd_cs CURSOR FOR t001_prepare2
    CALL g_cxd.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH cxd_cs INTO g_cxd[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cxd[g_cnt].up = g_cxd[g_cnt].cxd09 / g_cxd[g_cnt].cxd08
        LET g_cxd[g_cnt].up1= g_cxd[g_cnt].cxd091/ g_cxd[g_cnt].cxd08
        LET g_cxd[g_cnt].up2= g_cxd[g_cnt].cxd092/ g_cxd[g_cnt].cxd08
        LET g_cxd[g_cnt].up3= g_cxd[g_cnt].cxd093/ g_cxd[g_cnt].cxd08
        LET g_cxd[g_cnt].up4= g_cxd[g_cnt].cxd094/ g_cxd[g_cnt].cxd08
        LET g_cxd[g_cnt].up5= g_cxd[g_cnt].cxd095/ g_cxd[g_cnt].cxd08
        LET g_cxd[g_cnt].up6= g_cxd[g_cnt].cxd096/ g_cxd[g_cnt].cxd08   #No.FUN-7C0101
        LET g_cxd[g_cnt].up7= g_cxd[g_cnt].cxd097/ g_cxd[g_cnt].cxd08   #No.FUN-7C0101
        LET g_cxd[g_cnt].up8= g_cxd[g_cnt].cxd098/ g_cxd[g_cnt].cxd08   #No.FUN-7C0101
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('','9035',0) EXIT FOREACH
        END IF
    END FOREACH
    CALL g_cxd.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1               #no.6277
END FUNCTION
 
FUNCTION t001_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #NO.FUN-680145 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cxd TO s_cxd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t001_fetch('L')
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
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t001_copy()
DEFINE l_newno1,l_oldno1  LIKE cxd_file.cxd01,
       l_newno2,l_oldno2  LIKE cxd_file.cxd02,
       l_newno3,l_oldno3  LIKE cxd_file.cxd03,
       l_newno4,l_oldno4  LIKE cxd_file.cxd010,  #No.FUN-7C0101
       l_newno5,l_oldno5  LIKE cxd_file.cxd011,  #No.FUN-7C0101
       l_ima              RECORD LIKE ima_file.*,
       l_n                LIKE type_file.num5    #NO.FUN-680145 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_cxd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    LET g_before_input_done = FALSE
    CALL t001_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno1,l_newno2,l_newno3,l_newno4,l_newno5   #No.FUN-7C0101
          FROM cxd01,cxd02,cxd03,cxd010,cxd011
        AFTER FIELD cxd01
            IF cl_null(l_newno1) THEN NEXT FIELD cxd01 END IF
            #FUN-AB0025 -----------add start---------
            IF NOT cl_null(l_newno1) THEN
               IF NOT s_chk_item_no(l_newno1,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD cxd01
               END IF 
            END IF
            #FUN-AB0025 ------------add end---------- 
            SELECT * INTO l_ima.* FROM ima_file WHERE ima01 = l_newno1
            IF STATUS THEN
#              CALL cl_err(l_newno1,'mfg3006',0)    #No.FUN-660146
               CALL cl_err3("sel","ima_file",l_newno1,"","mfg3006","","",1)  #No.FUN-660146
               NEXT FIELD cxd01
            END IF
            DISPLAY l_ima.ima02,l_ima.ima25 TO ima02,ima25
        AFTER FIELD cxd02
            IF cl_null(l_newno2) THEN NEXT FIELD cxd02 END IF
        AFTER FIELD cxd03
            IF cl_null(l_newno3) THEN NEXT FIELD cxd03 END IF
            IF l_newno3 < 1 AND l_newno3 > 13 THEN NEXT FIELD cxd03 END IF
            SELECT COUNT(*) INTO l_n FROM cxd_file
             WHERE cxd01 = l_newno1 AND cxd02 = l_newno2 AND cxd03 = l_newno3
            IF l_n > 0 THEN
               CALL cl_err(l_newno3,-239,0) NEXT FIELD cxd03
            END IF
        #No.FUN-7C0101--start--
        AFTER FIELD cxd010
            IF cl_null(l_newno4) THEN NEXT FIELD cxd010 END IF
            IF l_newno4 NOT MATCHES '[12345]' THEN NEXT FIELD cxd010 END IF
        AFTER FIELD cxd011
            IF cl_null(l_newno5) THEN LET l_newno5=' ' END IF
        #No.FUN-7C0101---end---
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(cxd01)
                # CALL q_ima(0,0,l_newno1) RETURNING l_newno1
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_ima"
#                 LET g_qryparam.default1=l_newno1
#                 CALL cl_create_qry() RETURNING l_newno1
                  CALL q_sel_ima(FALSE, "q_ima","",l_newno1,"","","","","",'' ) 
                     RETURNING l_newno1  
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY l_newno1 TO cxd01
                  NEXT FIELD cxd01
              #No.FUN-7C0101--start--
              WHEN INFIELD(cxd011)
                 CALL cl_init_qry_var()
                 CASE l_newno4
                    WHEN '4'
                      LET g_qryparam.form = "q_pja"                     
                    WHEN '5'
                      LET g_qryparam.form = "q_gem4"
                    OTHERWISE EXIT CASE
                 END CASE
                 LET g_qryparam.default1 = l_newno5
                 CALL cl_create_qry() RETURNING l_newno5
                 NEXT FIELD cxd011
              #No.FUN-7C0101---end---
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
        DISPLAY g_cxd01,g_cxd02,g_cxd03 TO cxd01,cxd02,cxd03 #ATTRIBUTE(YELLOW)
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM cxd_file         #單身複製
       WHERE cxd01 = g_cxd01 AND cxd02 = g_cxd02 AND cxd03 = g_cxd03
             AND cxd010 = g_cxd010 AND cxd011 = g_cxd011            #No.FUN-7C0101
        INTO TEMP x
    IF SQLCA.sqlcode THEN
       LET g_msg = g_cxd01 CLIPPED,' ',g_cxd02 CLIPPED,' ',g_cxd03 CLIPPED,
                   g_cxd010 CLIPPED,' ',g_cxd011 CLIPPED            #No.FUN-7C0101
#      CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660146
       CALL cl_err3("ins","x",g_cxd01,g_cxd02,SQLCA.sqlcode,"","",1)  #No.FUN-660146
       RETURN
    END IF
    UPDATE x SET cxd01 = l_newno1, cxd02 = l_newno2, cxd03 = l_newno3,
                 cxd010 = l_newno4,cxd011 = l_newno5              #No.FUN-7C0101
    INSERT INTO cxd_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
       LET g_msg = g_cxd01 CLIPPED,' ',g_cxd02 CLIPPED,' ',g_cxd03 CLIPPED,
                   g_cxd010 CLIPPED,' ',g_cxd011 CLIPPED            #No.FUN-7C0101
#      CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660146
       CALL cl_err3("ins","cxd_file",l_newno1,l_newno2,SQLCA.sqlcode,"","",1)  #No.FUN-660146
       RETURN
    END IF
    LET l_oldno1= g_cxd01
    LET l_oldno2= g_cxd02
    LET l_oldno3= g_cxd03
    LET l_oldno4= g_cxd010  #No.FUN-7C0101
    LET l_oldno5= g_cxd011  #No.FUN-7C0101
    LET g_cxd01=l_newno1
    LET g_cxd02=l_newno2
    LET g_cxd03=l_newno3
    LET g_cxd010 = l_newno4 #No.FUN-7C0101
    LET g_cxd011 = l_newno5 #No.FUN-7C0101
    CALL t001_b()
    #FUN-C80046---begin
    #LET g_cxd01=l_oldno1
    #LET g_cxd02=l_oldno2
    #LET g_cxd03=l_oldno3
    #LET l_oldno4= g_cxd010  #No.FUN-7C0101
    #LET l_oldno5= g_cxd011  #No.FUN-7C0101
    #CALL t001_show()
    #FUN-C80046---end
END FUNCTION
 
FUNCTION t001_out()
    DEFINE
        l_i             LIKE type_file.num5,    #NO.FUN-680145 SMALLINT 
        l_name          LIKE type_file.chr20,   #NO.FUN-680145 VARCHAR(20)   # External(Disk) file name
        sr              RECORD
                        cxd      RECORD LIKE cxd_file.*,
                        ima02    LIKE ima_file.ima02,
                        ima021   LIKE ima_file.ima021,   #FUN-5C0002
                        ima25    LIKE ima_file.ima25,
                        up       LIKE ccc_file.ccc23
                        END RECORD,
        l_za05          LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(40) 
 
    IF cl_null(g_wc) THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
#   CALL cl_outnam('axmr551') RETURNING l_name  #No.FUN-580014
#    CALL cl_outnam('gxct001') RETURNING l_name #No.TQC-5C0059    #No.FUN-830152
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   #LET g_sql="SELECT cxd_file.*,ima02,ima25,0 ",          #FUN-5C0002 mark
    LET g_sql="SELECT cxd_file.*,ima02,ima021,ima25,0 ",   #FUN-5C0002
    "  FROM cxd_file LEFT OUTER JOIN ima_file ON cxd01=ima01",
    " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
#No.FUN-830152---Begin                                                                                                              
    LET g_str = g_azi03,";",g_azi04                                                                                                  
    CALL cl_prt_cs1('gxct001','gxct001',g_sql,g_str) 
#    PREPARE t001_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE t001_curo CURSOR FOR t001_p1
#    START REPORT t001_rep TO l_name
 
#    FOREACH t001_curo INTO sr.*
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
#        END IF
#        LET sr.up = sr.cxd.cxd09 / sr.cxd.cxd08
#        IF cl_null(sr.up) THEN LET sr.up = 0 END IF
#        OUTPUT TO REPORT t001_rep(sr.*)
#    END FOREACH
 
#    FINISH REPORT t001_rep
 
#    CLOSE t001_curo
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-830152---End
END FUNCTION
#No.FUN-830152---Begin 
#REPORT t001_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,     #NO.FUN-680145 VARCHAR(1)
#       l_cnt           LIKE type_file.num10,    #NO.FUN-680145 INTEGER
#       sr              RECORD
#                       cxd      RECORD LIKE cxd_file.*,
#                       ima02    LIKE ima_file.ima02,
#                       ima021   LIKE ima_file.ima021,   #FUN-5C0002
#                       ima25    LIKE ima_file.ima25,
#                       up       LIKE ccc_file.ccc23
#                       END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
##    ORDER BY sr.cxd.cxd02,sr.cxd.cxd03,sr.cxd.cxd01,sr.cxd.cxd04                              #FUN-830135 mark
#   ORDER BY sr.cxd.cxd02,sr.cxd.cxd03,sr.cxd.cxd01,sr.cxd.cxd04,sr.cxd.cxd010,sr.cxd.cxd011   #FUN-830135  
##No.FUN-580014-begin
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
 
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
 
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           PRINT g_x[14] CLIPPED,sr.cxd.cxd02 USING '<<<<','  ',
#                 g_x[15] CLIPPED,sr.cxd.cxd03 USING '<<'
#           PRINT g_dash[1,g_len]
#           PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],
#                          g_x[35],g_x[36],g_x[37],g_x[38]
#          #PRINTX name=H2 g_x[39]           #FUN-5C0002 mark
#          #PRINTX name=H2 g_x[39],g_x[40]   #FUN-5C0002    #FUN-830135 mark
#           PRINTX name=H2 g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]  #FUN-830135
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       BEFORE GROUP OF sr.cxd.cxd03
#           SKIP TO TOP OF PAGE
 
#       BEFORE GROUP OF sr.cxd.cxd01
#           #PRINTX name=D1 COLUMN g_c[31],sr.cxd.cxd01[1,20];
#           PRINTX name=D1 COLUMN g_c[31],sr.cxd.cxd01 clipped; #NO.FUN-5B0015
 
#       ON EVERY ROW
#           PRINTX name=D1 COLUMN  g_c[32],sr.ima25 CLIPPED,
#                          COLUMN  g_c[33],sr.cxd.cxd05,
#                          COLUMN  g_c[34],sr.cxd.cxd06 CLIPPED,
#                          COLUMN  g_c[35],sr.cxd.cxd07 USING '###&',
#                          COLUMN  g_c[36],cl_numfor(sr.cxd.cxd08,36,0),
#                          COLUMN  g_c[37],cl_numfor(sr.cxd.cxd09,37,g_azi04),
#                          COLUMN  g_c[38],cl_numfor(sr.up,38,g_azi03)
#           PRINTX name=D2 COLUMN g_c[39],sr.ima02 CLIPPED
#                         ,COLUMN g_c[40],sr.ima021 CLIPPED   #FUN-5C0002
#                         ,COLUMN g_c[41]," "                    #FUN-830135
#                         ,COLUMN g_c[42],sr.cxd.cxd010 CLIPPED  #FUN-830135
#                         ,COLUMN g_c[43],sr.cxd.cxd011 CLIPPED  #FUN-830135 
##No.FUN-580014-end
 
#       AFTER GROUP OF sr.cxd.cxd01
#           PRINT ''
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4] CLIPPED,COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-830152---End 
#genero
FUNCTION t001_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("cxd01,cxd02,cxd03,cxd010,cxd011",TRUE)   #No.FUN-7C0101
   END IF
 
END FUNCTION
 
FUNCTION t001_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("cxd01,cxd02,cxd03,cxd010,cxd011",FALSE) #No.FUN-7C0101
       END IF
   END IF
 
END FUNCTION
#Patch....NO.TQC-610037 <> #
