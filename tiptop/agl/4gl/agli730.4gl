# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli730.4gl
# Descriptions...: 分攤傳票維護作業(變動比率)
# Date & Author..: 92/08/03 BY MAY
# Modify.........: By Melody    單身 keyin 順序調整
# Modify.........: By Melody    aab_file->gem_file
#                  By Melody    q_aac 改為不區分帳別
#                  By Melody    四組異動碼加入欄位控制
# Modify.........: No.MOD-480493 04/08/27 By Nicola 單頭起始日期/截止日期請給系統日
# Modify.........: No.MOD-490230 04/09/18 By Yuna  當簽核為'Y'時,簽核等級才可以輸入
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
#                  2005/01/05 alex FUN-4C0104 修改 4js bug 定義超長
# Modify.........: No.FUN-510007 05/03/02 By Smapmin 放寬金額欄位
# Modify.........: No.FUN-550028 05/05/16 By Will 單據編號放大
# Modify.........: No.TQC-5B0045 05/11/07 By Smapmin 資料列印位置調整
# Modify.........: No.FUN-5C0015 060102 BY GILL 新增異動碼5-10、關係人異動碼
# Modify.........: No.FUN-5C0015 06/02/14 BY GILL 用s_ahe_qry取代q_aee
# Modify.........: No.TQC-620028 06/02/22 By Smapmin 有做部門管理的科目才需CALL s_chkdept
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0083 06/11/08 By xumin報表寬度調整
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/03 By bnlent 會計科目加帳套-財務
# Modify.........: No.TQC-740093 07/04/16 By bnlent 會計科目加帳套-財務BUG
# Modify.........: No.MOD-740297 07/04/26 By Carrier afa/aee漏傳帳套 & 單身復制時,和科目相關字段的合理性
# Modify.........: No.TQC-750022 07/05/09 By Lynn 打印時,"FROM:"位置在報表名之上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810045 08/03/31 By rainy 專案管理,專案table gja_file->pja_file
# Modify.........: No.FUN-830139 08/03/31 By bnlent 1、去掉預算編號字段 2、管控ahb35,ahb36
# Modify.........: No.FUN-830092 08/04/11 By sherry 報表改由CR輸出
# Modify.........: No.FUN-850038 08/05/13 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-850027 08/05/29 By douzh WBS編碼錄入時要求時尾階并且為成本對象的WBS編碼
# Modify.........: No.MOD-930170 09/03/16 By chenl  若科目勾選項目管理后,需對項目編號和wbs編號進行輸入.若勾選預算管理,則需輸入預算編號.
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.FUN-950077 09/05/22 By dongbg 預算項目統一為費用原因/預算項目 
# Modify.........: No.FUN-980003 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 增加"專案未結案"的判斷
# Modify.........: No.MOD-9C0235 09/12/19 By Carrier aha07开窗和检查的aac11均为'1'
# Modify.........: No.MOD-9C0348 09/12/22 By sabrina (1)按【更改】進入單頭後,再按【維護來源科目】輸入完回到單頭按【確定】後存檔,
#                                                       系統又跳出【維護來源科目】之視窗
#                                                    (2)單身新增第2筆時請DEFAULT 上一筆之【會計科目】,【變動比率分子科目】.
#                                                    (3)若在非【序號】欄位按↓新增單身, 【序號】未自動帶出.
# Modify.........: No.MOD-9C0359 09/12/22 By sabrina 單頭傳票單別開窗,不應可看到現金收入OR現金支出性質傳票. 亦不應可輸入. 
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/03/01 by tommas delete cl_doc
# Modify.........: No.FUN-A30049 10/03/11 By lutingting GP5.2使用環境變數改為以FGL_GETENV引用 
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AGL
# Modify.........: No.MOD-A60169 10/04/25 By Dido 檢核單身是否有借貸方 
# Modify.........: No:CHI-A70042 10/08/02 By Summer 將相關使用 g_depno 予已 mark
# Modify.........: No.MOD-A40101 10/08/03 By sabrina 傳票單別要可輸入"應計傳票"
# Modify.........: No.MOD-AB0052 10/11/05 By Dido 當單頭無來源科目時,檢核單身是否有借貸方 
# Modify.........: No.TQC-AC0403 10/12/31 By zhangweib CALL s_check_no 傳入的參數有問題
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.MOD-B30386 11/03/18 By Dido 新增時單頭輸入不需檢核單身 
# Modify.........: No:FUN-B50105 11/05/23 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤

#IMPORT os   #FUN-A30049
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C20287 12/02/20 By wujie 查询增加oriu，orig
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-C80041 12/11/29 By bart 刪除單頭時，一併刪除相關table
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bookno        LIKE aaa_file.aaa01,
    g_aha000        LIKE aha_file.aha000,
    g_aha           RECORD LIKE aha_file.*,       #傳票編號 (假單頭)
    g_aha_t         RECORD LIKE aha_file.*,       #傳票編號 (舊值)
    g_aha_o         RECORD LIKE aha_file.*,       #傳票編號 (舊值)
    g_aha01_t       LIKE aha_file.aha01,   #
    g_aha00_t       LIKE aha_file.aha00,   #
    g_tail         LIKE type_file.num10,                #ROWID為更新項次之用 #No.FUN-680098  INTEGER
    g_aaa           RECORD LIKE aaa_file.*,
    g_ahb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variagles)
        ahb02       LIKE ahb_file.ahb02,   #項次
        ahb03       LIKE ahb_file.ahb03,   #科目編號
        aag02       LIKE aag_file.aag02,   #科目名稱
        ahb05       LIKE ahb_file.ahb05,   #部門
        ahb06       LIKE ahb_file.ahb06,   #借貸別
        ahb16       LIKE ahb_file.ahb16,   #異動金額
        ahb08       LIKE ahb_file.ahb08,   #專案號碼
        ahb35       LIKE ahb_file.ahb35,   #異動碼9    #No.FUN-830139
        ahb36       LIKE ahb_file.ahb36,   #異動碼10   #No.FUN-830139
        ahb11       LIKE ahb_file.ahb11,   #異動別-1
        ahb12       LIKE ahb_file.ahb12,   #異動別-2
        ahb13       LIKE ahb_file.ahb13,   #異動別-3
        ahb14       LIKE ahb_file.ahb14,   #異動別-4
 
        ahb31       LIKE ahb_file.ahb31,   #異動碼5
        ahb32       LIKE ahb_file.ahb32,   #異動碼6
        ahb33       LIKE ahb_file.ahb33,   #異動碼7
        ahb34       LIKE ahb_file.ahb34,   #異動碼8
        ahb37       LIKE ahb_file.ahb37,   #關係人異動碼
 
        ahb04       LIKE ahb_file.ahb04,   #摘要
        ahbud01     LIKE ahb_file.ahbud01,
        ahbud02     LIKE ahb_file.ahbud02,
        ahbud03     LIKE ahb_file.ahbud03,
        ahbud04     LIKE ahb_file.ahbud04,
        ahbud05     LIKE ahb_file.ahbud05,
        ahbud06     LIKE ahb_file.ahbud06,
        ahbud07     LIKE ahb_file.ahbud07,
        ahbud08     LIKE ahb_file.ahbud08,
        ahbud09     LIKE ahb_file.ahbud09,
        ahbud10     LIKE ahb_file.ahbud10,
        ahbud11     LIKE ahb_file.ahbud11,
        ahbud12     LIKE ahb_file.ahbud12,
        ahbud13     LIKE ahb_file.ahbud13,
        ahbud14     LIKE ahb_file.ahbud14,
        ahbud15     LIKE ahb_file.ahbud15
                    END RECORD,
    g_ahb_t         RECORD                 #程式變數 (舊值)
        ahb02       LIKE ahb_file.ahb02,   #項次
        ahb03       LIKE ahb_file.ahb03,   #科目編號
        aag02       LIKE aag_file.aag02,   #科目名稱
        ahb05       LIKE ahb_file.ahb05,   #部門
        ahb06       LIKE ahb_file.ahb06,   #借貸別
        ahb16       LIKE ahb_file.ahb16,   #異動金額
        ahb08       LIKE ahb_file.ahb08,   #專案號碼
        ahb35       LIKE ahb_file.ahb35,   #異動碼9    #No.FUN-830139
        ahb36       LIKE ahb_file.ahb36,   #異動碼10   #No.FUN-830139
        ahb11       LIKE ahb_file.ahb11,   #異動別-1
        ahb12       LIKE ahb_file.ahb12,   #異動別-2
        ahb13       LIKE ahb_file.ahb13,   #異動別-3
        ahb14       LIKE ahb_file.ahb14,   #異動別-4
 
        ahb31       LIKE ahb_file.ahb31,   #異動碼5
        ahb32       LIKE ahb_file.ahb32,   #異動碼6
        ahb33       LIKE ahb_file.ahb33,   #異動碼7
        ahb34       LIKE ahb_file.ahb34,   #異動碼8
        ahb37       LIKE ahb_file.ahb37,   #關係人異動碼
 
        ahb04       LIKE ahb_file.ahb04,   #摘要
        ahbud01     LIKE ahb_file.ahbud01,
        ahbud02     LIKE ahb_file.ahbud02,
        ahbud03     LIKE ahb_file.ahbud03,
        ahbud04     LIKE ahb_file.ahbud04,
        ahbud05     LIKE ahb_file.ahbud05,
        ahbud06     LIKE ahb_file.ahbud06,
        ahbud07     LIKE ahb_file.ahbud07,
        ahbud08     LIKE ahb_file.ahbud08,
        ahbud09     LIKE ahb_file.ahbud09,
        ahbud10     LIKE ahb_file.ahbud10,
        ahbud11     LIKE ahb_file.ahbud11,
        ahbud12     LIKE ahb_file.ahbud12,
        ahbud13     LIKE ahb_file.ahbud13,
        ahbud14     LIKE ahb_file.ahbud14,
        ahbud15     LIKE ahb_file.ahbud15
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,        #TQC-630166        
    g_sql_tmp           STRING,        #No.FUN-740020
    g_aaa03             LIKE aaa_file.aaa03,  #No.FUN-740020
    g_t1            LIKE oay_file.oayslip,              #No.FUN-550028        #No.FUN-680098CHAR(5)
    g_statu         LIKE type_file.chr1,                #No.FUN-680098 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680098 SMALLINT
    g_cmd           LIKE type_file.chr1000,             #No.FUN-680098 VARCHAR(300)
    g_sw            LIKE type_file.chr1,                #No.FUN-680098 VARCHAR(1)
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680098 SMALLINT
    l_str1          LIKE type_file.chr50,               #No.FUN-680098 VARCHAR(20)
#   g_depno         LIKE type_file.chr20,               #No.FUN-680098 VARCHAR(20) #CHI-A70042 mark
    l_priv1         LIKE zy_file.zy03,     # 使用者執行權限
    l_priv2         LIKE zy_file.zy04,     # 使用者資料權限
    l_priv3         LIKE zy_file.zy05      # 使用部門資料權限
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL    
DEFINE   g_before_input_done   LIKE type_file.num5               #No.FUN-680098 SMALLINT
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680098 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03           #No.FUN-680098 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5          #No.FUN-680098 SMALLINT
DEFINE   g_str           STRING                                                 
DEFINE   l_sql           STRING                                                 
DEFINE   l_table         STRING                                                 
 
MAIN
DEFINE l_sql         STRING        #TQC-630166 
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_sql = "aha00.aha_file.aha00,",                                         
               "aha01.aha_file.aha01,",                                         
               "aha02.aha_file.aha02,",                                         
               "aha03.aha_file.aha03,",                                         
               "aha05.aha_file.aha05,",                                         
               "aha07.aha_file.aha07,",                                         
               "aha06.aha_file.aha06,",                                         
               "aha08.aha_file.aha08,",                                         
               "aha10.aha_file.aha10,",                                         
               "aha04.aha_file.aha04,",                                         
               "ahamksg.aha_file.ahamksg,",                                     
               "ahasign.aha_file.ahasign,",                                     
               "ahb02.ahb_file.ahb02,",                                         
               "ahb03.ahb_file.ahb03,",                                         
               "ahb04.ahb_file.ahb04,",                                         
               "ahb05.ahb_file.ahb05,",                                         
               "ahb06.ahb_file.ahb06,",                                         
               "ahb07.ahb_file.ahb07,",     
               "ahb08.ahb_file.ahb08,",                                         
               "ahb37.ahb_file.ahb37,",                                         
               "ahaacti.aha_file.ahaacti,",                                     
               "l_tc1.ahb_file.ahb11,",                                         
               "l_tc2.ahb_file.ahb12,",                                         
               "l_tc3.ahb_file.ahb13,",                                         
               "l_tc4.ahb_file.ahb14,",                                         
               "l_tc5.ahb_file.ahb31,",                                         
               "l_tc6.ahb_file.ahb32,",                                         
               "l_tc7.ahb_file.ahb33,",                                         
               "l_tc8.ahb_file.ahb34,",                                         
               "l_tc9.ahb_file.ahb35,",                                         
               "l_tc10.ahb_file.ahb36"                                          
                                                                                
   LET l_table = cl_prt_temptable('agli730',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",          
               "        ?,?,?,?,?, ?,?,?,?,?, ?) "                            
   PREPARE insert_prep FROM g_sql        
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql =
         "SELECT * FROM aha_file WHERE aha00 = ? AND aha01 = ? AND aha000 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i730_cl CURSOR FROM g_forupd_sql
 
    LET g_aha000 = '3' #性質變動比率
    IF INT_FLAG THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM 
    END IF
 
    #CHI-A70042 mark --start--
    #IF g_depno IS NOT NULL AND g_depno != ' ' THEN
    #   LET l_sql = "aglform $AGL/42f/agli730.42f agli730.42f ", g_depno CLIPPED   #FUN-A30049
#   #    LET l_sql = "aglform ",os.Path.join( os.Path.join(FGL_GETENV("AGL"),"42f"),"agli730.42f"), #FUN-A30049
#   #                "agli730.42f ", g_depno CLIPPED   #FUN-A30049
    #    RUN l_sql
    #    OPEN WINDOW i730_w WITH FORM "agli730"
    #       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    # 
    #CALL cl_ui_init()
    # 
    #ELSE
    #CHI-A70042 mark --end--
        OPEN WINDOW i730_w WITH FORM "agl/42f/agli730"
              ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #END IF #CHI-A70042 mark
 
    CALL i730_show_field()  #FUN-5C0015 BY GILL
 
    #LET l_str1 = g_depno CLIPPED,'*' CLIPPED #CHI-A70042 mark
 
    CALL i730_menu()
    CLOSE WINDOW i730_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i730_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_ahb.clear()
 
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_aha.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
        aha00,    #No.FUN-740020
        aha01,aha02,aha03,aha05,aha06,aha04,aha07,aha08,aha10,ahamksg,ahasign,       #No.FUN-830139
        ahauser,ahagrup,ahaoriu,ahaorig,ahamodu,ahadate,ahaacti,   #No.TQC-C20287 add oriu,orig
        ahaud01,ahaud02,ahaud03,ahaud04,ahaud05,
        ahaud06,ahaud07,ahaud08,ahaud09,ahaud10,
        ahaud11,ahaud12,ahaud13,ahaud14,ahaud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(aha00)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aaa"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aha00
             NEXT FIELD aha00
          WHEN INFIELD(aha02) #類別
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aca"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aha02
             NEXT FIELD aha02
          WHEN INFIELD(aha07) #單據性質
             CALL q_aac(TRUE,TRUE,g_aha.aha07,'1','0',' ','AGL') RETURNING g_aha.aha07    #TQC-670008
             DISPLAY BY NAME g_aha.aha07
             NEXT FIELD aha07
          WHEN INFIELD (ahasign)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_azc"
             LET g_qryparam.arg1 = 7
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahasign
             NEXT FIELD ahasign
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
    CALL g_ahb.clear()
    IF INT_FLAG THEN RETURN END IF
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ahauser', 'ahagrup')
 
    CONSTRUCT g_wc2 ON ahb02,ahb03,ahb05,ahb06,ahb16,#ahb15,  #No.FUN-830139
                       ahb35,ahb36,                           #No.FUN-830139
                       ahb11,ahb12,ahb13,ahb14, 
 
                       ahb31,ahb32,ahb33,ahb34,ahb37,   #No.FUN-830139 move ahb35,ahb36
 
                       ahb08,ahb04   # 螢幕上取單身條件
                       ,ahbud01,ahbud02,ahbud03,ahbud04,ahbud05
                       ,ahbud06,ahbud07,ahbud08,ahbud09,ahbud10
                       ,ahbud11,ahbud12,ahbud13,ahbud14,ahbud15
            FROM s_ahb[1].ahb02,s_ahb[1].ahb03,
                 s_ahb[1].ahb05,s_ahb[1].ahb06,s_ahb[1].ahb16,#s_ahb[1].ahb15, #No.FUN-830139
                 s_ahb[1].ahb35,s_ahb[1].ahb36,   #No.FUN-830139 
                 s_ahb[1].ahb11,s_ahb[1].ahb12,s_ahb[1].ahb13,s_ahb[1].ahb14,
 
                 s_ahb[1].ahb31,s_ahb[1].ahb32,s_ahb[1].ahb33,s_ahb[1].ahb34,
                 s_ahb[1].ahb37,     #No.FUN-830139 ahb35,ahb36移動位置
 
                 s_ahb[1].ahb08,s_ahb[1].ahb04
                 ,s_ahb[1].ahbud01,s_ahb[1].ahbud02,s_ahb[1].ahbud03
                 ,s_ahb[1].ahbud04,s_ahb[1].ahbud05,s_ahb[1].ahbud06
                 ,s_ahb[1].ahbud07,s_ahb[1].ahbud08,s_ahb[1].ahbud09
                 ,s_ahb[1].ahbud10,s_ahb[1].ahbud11,s_ahb[1].ahbud12
                 ,s_ahb[1].ahbud13,s_ahb[1].ahbud14,s_ahb[1].ahbud15
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(ahb03)      #查詢科目代號不為統制帳戶'1'
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aag"
             LET g_qryparam.where = " aag03 ='2'"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb03
          WHEN INFIELD(ahb16)      #查詢科目代號為帳戶性質
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aag"
             LET g_qryparam.where = " aag03 ='2'"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb16
          WHEN INFIELD(ahb04)     #查詢分攤摘要
             CALL q_aad(TRUE,TRUE,g_ahb[1].ahb04) RETURNING g_ahb[1].ahb04
             DISPLAY g_qryparam.multiret TO ahb04
          WHEN INFIELD(ahb05) #查詢部門
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_gem"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb05
          WHEN INFIELD(ahb08)    #查詢專案編號
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_pja2"    #FUN-810045 
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb08
          WHEN INFIELD(ahb11)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_ahb[1].ahb03
             LET g_qryparam.arg2 = 1
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb11
          WHEN INFIELD(ahb12)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_ahb[1].ahb03
             LET g_qryparam.arg2 = 2
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb12
          WHEN INFIELD(ahb13)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.default1 = g_ahb[1].ahb13
             LET g_qryparam.arg1 = g_ahb[1].ahb03
             LET g_qryparam.arg2 = 3
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb13
          WHEN INFIELD(ahb14)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_ahb[1].ahb03
             LET g_qryparam.arg2 = 4
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb14
 
          WHEN INFIELD(ahb31)    #查詢異動碼-5
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_ahb[1].ahb03
             LET g_qryparam.arg2 = 5
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb31
          WHEN INFIELD(ahb32)    #查詢異動碼-6
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_ahb[1].ahb03
             LET g_qryparam.arg2 = 6
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb32
          WHEN INFIELD(ahb33)    #查詢異動碼-7
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_ahb[1].ahb03
             LET g_qryparam.arg2 = 7
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb33
          WHEN INFIELD(ahb34)    #查詢異動碼-8
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_ahb[1].ahb03
             LET g_qryparam.arg2 = 8
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb34
          WHEN INFIELD(ahb35)    #查詢異動碼-9
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_pjb"    #No.FUN-830139 q_aee ->q_pjb
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb35
          WHEN INFIELD(ahb36)    #查詢異動碼-10
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_azf01a" #No.FUN-930104
             LET g_qryparam.arg1 = '7'       #No.FUN-950077
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb36
          WHEN INFIELD(ahb37)    #查詢關係人異動碼
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_ahb[1].ahb03
             LET g_qryparam.arg2 = 99
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb37
 
          OTHERWISE
             EXIT CASE
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
 
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   #IF g_wc2 = " 1=1" AND (g_depno IS NULL OR g_depno=' ') THEN#若單身未輸入條件 #CHI-A70042 mark
    IF g_wc2 = " 1=1" THEN#若單身未輸入條件 #CHI-A70042
       LET g_sql = "SELECT aha01,aha00,aha000 ",
                   " FROM aha_file",
                   " WHERE ", g_wc CLIPPED,
                   " AND aha000 = '",g_aha000,"' "
     ELSE                    # 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT aha01,aha00,aha000 ",
                   "  FROM aha_file, ahb_file ",
                   " WHERE aha01 = ahb01",
                   " AND aha000 = '",g_aha000,"' ",
                   " AND ahb000 = '",g_aha000,"' ",
                   " AND aha00 = ahb00 ",
                   " AND ahb02 !=0 ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
    END IF
    #CHI-A70042 mark --start--
    #IF g_depno IS NOT NULL OR g_depno != ' ' THEN  #若部門別有輸入條件
    #   LET g_sql = g_sql CLIPPED," AND ahb03 MATCHES '",l_str1,"' "
    #END IF
    #CHI-A70042 mark --end--
    LET g_sql = g_sql CLIPPED," ORDER BY aha00,aha01 "   #No.FUN-740020
 
    PREPARE i730_prepare FROM g_sql
    DECLARE i730_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i730_prepare
   #IF g_wc2 = " 1=1" AND (g_depno IS NULL OR g_depno =' ') THEN#取合乎條件筆數 #CHI-A70042 mark
    IF g_wc2 = " 1=1" THEN#取合乎條件筆數 #CHI-A70042
        LET g_sql="SELECT DISTINCT aha00,aha01 FROM aha_file WHERE ",g_wc CLIPPED,  #No.FUN-740020
                  " AND aha000 = '",g_aha000,"'"
    ELSE
        LET g_sql="SELECT DISTINCT aha00,aha01 FROM aha_file,ahb_file WHERE ",  #No.FUN-740020
                  "ahb01=aha01 AND aha00 = ahb00 ",
                  " AND aha000 = '",g_aha000,"'",
                  " AND ahb000 = '",g_aha000,"'",
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    #CHI-A70042 mark --start--
    #IF g_depno IS NOT NULL AND g_depno != ' ' THEN
    #   LET g_sql = g_sql CLIPPED," AND ahb03 MATCHES '",l_str1,"'"
    #END IF
    #CHI-A70042 mark --end--
    LET g_sql_tmp = g_sql CLIPPED,"  INTO TEMP x"
    DROP TABLE x
    PREPARE i710_pre_x FROM g_sql_tmp
    EXECUTE i710_pre_x
    LET g_sql = "SELECT COUNT(*) FROM x"
 
    PREPARE i730_precount FROM g_sql
    DECLARE i730_count CURSOR FOR i730_precount
END FUNCTION
 
FUNCTION i730_menu()
 
   WHILE TRUE
      CALL i730_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i730_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i730_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i730_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i730_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i730_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i730_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i730_b(' ')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i730_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "分攤摘要"
         WHEN "extra_memo"
            IF cl_chk_act_auth() THEN
               IF g_aha.aha01 IS NOT NULL AND g_aha.aha01 != ' ' THEN
                  LET g_cmd = 'agli701 ',g_aha.aha00,' ',g_aha.aha01,' ',
                                g_aha.aha000,' 0 ' CLIPPED
                  CALL cl_cmdrun(g_cmd)
               END IF
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_aha.aha01 IS NOT NULL THEN
                  LET g_doc.column1 = "aha00"
                  LET g_doc.value1 = g_aha.aha00
                  LET g_doc.column2 = "aha000"
                  LET g_doc.value2 = g_aha.aha000
                  LET g_doc.column3 = "aha01"
                  LET g_doc.value3 = g_aha.aha01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ahb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i730_a()
DEFINE   l_str  LIKE ze_file.ze03         #No.FUN-680098 VARCHAR(17)
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
   CALL g_ahb.clear()
    INITIALIZE g_aha.* LIKE aha_file.*             #DEFAULT 設定
    LET g_aha01_t = NULL
    LET g_aha00_t = NULL
    LET g_aha_o.* = g_aha.*
    LET g_aha.aha000 = g_aha000
    LET g_aha.aha03 = 1
     LET g_aha.aha05 = TODAY         #No.MOD-480493
     LET g_aha.aha06 = TODAY         #No.MOD-480493
    LET g_aha.aha08 = '1'
    LET g_aha.aha10 = '2'
    LET g_aha.aha11 = 0
    LET g_aha.aha12 = 0
    LET g_aha.ahamksg = 'N'
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_aha.ahauser=g_user
        LET g_aha.ahaoriu = g_user #FUN-980030
        LET g_aha.ahaorig = g_grup #FUN-980030
        LET g_aha.ahagrup=g_grup
        LET g_aha.ahadate=g_today
        LET g_aha.ahaacti='Y'              #資料有效
        LET g_aha.ahalegal=g_legal      #FUN-980003 add
        CALL i730_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_aha.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_aha.aha01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_aha.aha00 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET l_priv1=g_priv1 LET l_priv2=g_priv2 LET l_priv3=g_priv3
        CALL i721(g_aha.aha00,g_aha000,g_aha.aha01)    #No.TQC-740093   g_bookno -->g_aha.aha00
        LET g_priv1=l_priv1 LET g_priv2=l_priv2 LET g_priv3=l_priv3
        CALL i730_ahd03()
        INSERT INTO aha_file VALUES (g_aha.*)
        IF SQLCA.sqlcode THEN               #置入資料庫不成功
            CALL cl_err3("ins","aha_file",g_aha.aha01,g_aha.aha00,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        END IF
        SELECT aha00 INTO g_aha.aha00 FROM aha_file
            WHERE aha01 = g_aha.aha01
              AND aha00 = g_aha.aha00      #No.FUN-740020
              AND aha000= g_aha.aha000     #No.FUN-740020 
        LET g_aha01_t = g_aha.aha01        #保留舊值
        LET g_aha00_t = g_aha.aha00        #保留舊值  #No.FUN-740020
        LET g_aha_t.* = g_aha.*
        CALL g_ahb.clear()
        LET g_rec_b = 0
        CALL i730_b('a')                   #輸入單身
 
        CALL cl_getmsg('agl-042',g_lang) RETURNING l_str
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i730_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_aha.aha01 IS NULL OR g_aha.aha00 IS NULL THEN   #No.FUN-740020
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_aha.* FROM aha_file WHERE aha000=g_aha.aha000
       AND aha00=g_aha.aha00 AND aha01=g_aha.aha01
    IF g_aha.ahaacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_aha.aha01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_aha01_t = g_aha.aha01
    LET g_aha00_t = g_aha.aha00  #No.FUN-740020
    LET g_aha_o.* = g_aha.*
    BEGIN WORK
 
    OPEN i730_cl USING g_aha.aha00,g_aha.aha01,g_aha.aha000
    IF STATUS THEN
       CALL cl_err("OPEN i730_cl1:", STATUS, 1)
       CLOSE i730_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i730_cl INTO g_aha.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aha.aha01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i730_cl ROLLBACK WORK RETURN
    END IF
    CALL i730_show()
    WHILE TRUE
        LET g_aha01_t = g_aha.aha01
        LET g_aha00_t = g_aha.aha00  #No.FUN-740020
        LET g_aha.ahamodu=g_user
        LET g_aha.ahadate=g_today
        CALL i730_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_aha.*=g_aha_t.*
            CALL i730_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_aha.aha01 != g_aha01_t THEN            # 更改單號
            UPDATE ahb_file SET ahb01 = g_aha.aha01,
                                ahb00 = g_aha.aha00  #No.FUN-740020
                WHERE ahb01 = g_aha01_t AND ahb00 = g_aha.aha00 AND ahb000 = '3'
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","ahb_file",g_aha01_t,g_aha.aha00,SQLCA.sqlcode,"","ahb",1)  #No.FUN-660123
                CONTINUE WHILE
            END IF
        END IF
        LET l_priv1=g_priv1 LET l_priv2=g_priv2 LET l_priv3=g_priv3
        CALL i721(g_aha.aha00,g_aha000,g_aha.aha01)   #No.TQC-740093   g_bookno -->g_aha.aha00
        LET g_priv1=l_priv1 LET g_priv2=l_priv2 LET g_priv3=l_priv3
        CALL i730_ahd03()
        UPDATE aha_file SET aha_file.* = g_aha.*
            WHERE aha00 = g_aha.aha00 AND aha01 = g_aha.aha01 AND aha000 = g_aha.aha000
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","aha_file",g_aha01_t,g_aha00_t,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i730_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i730_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,        #判斷必要欄位是否有輸入        #No.FUN-680098 VARCHAR(1)
    l_aca02         LIKE azn_file.azn02,
    l_azn04         LIKE azn_file.azn04,
    l_aag07         LIKE aag_file.aag07,
    l_direct        LIKE type_file.chr1,       #No.FUN-680098 VARCHAR(1)
    l_direct1       LIKE type_file.chr1,       #No.FUN-680098 VARCHAR(1)
    l_direct2       LIKE type_file.chr1,       #No.FUN-680098 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,    #No.FUN-680098 VARCHAR(100)
    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改        #No.FUN-680098CHAR(1)
    l_aac11         STRING,                    #MOD-A40101 add
    li_result       LIKE type_file.num5,       #No.FUN-680098 SMALLINT
    l_cnt           LIKE type_file.num5        #MOD-AB0052
 
    DISPLAY BY NAME g_aha.aha05,g_aha.aha06
    CALL cl_set_head_visible("","YES")         #No.FUN-6B0029 
 
    INPUT BY NAME g_aha.ahaoriu,g_aha.ahaorig,
        g_aha.aha00,   #No.FUN-740020
        g_aha.aha01,g_aha.aha02,g_aha.aha03,g_aha.aha05,g_aha.aha06,g_aha.aha04,
        g_aha.aha07,g_aha.aha08,g_aha.aha10,                #No.FUN-830139
        g_aha.ahamksg,g_aha.ahasign,
        g_aha.ahauser,g_aha.ahagrup,g_aha.ahamodu,g_aha.ahadate,g_aha.ahaacti,
        g_aha.ahaud01,g_aha.ahaud02,g_aha.ahaud03,g_aha.ahaud04,
        g_aha.ahaud05,g_aha.ahaud06,g_aha.ahaud07,g_aha.ahaud08,
        g_aha.ahaud09,g_aha.ahaud10,g_aha.ahaud11,g_aha.ahaud12,
        g_aha.ahaud13,g_aha.ahaud14,g_aha.ahaud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i730_set_entry(p_cmd)
            CALL i730_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD aha00
            IF NOT cl_null(g_aha.aha00) THEN
               CALL i730_aha00('a',g_aha.aha00)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aha.aha00,g_errno,0)
                  LET g_aha.aha00 = g_aha_t.aha00
                  DISPLAY BY NAME g_aha.aha00
                  NEXT FIELD aha00
               END IF
            END IF
        AFTER FIELD aha01
            IF NOT cl_null(g_aha.aha01) THEN
             IF p_cmd = 'a' OR p_cmd = 'u' AND 
               (g_aha.aha01 != g_aha01_t OR g_aha.aha00 != g_aha00_t) THEN
                    SELECT count(*) INTO g_cnt FROM aha_file
                        WHERE aha01 = g_aha.aha01 AND
                              aha00 = g_aha.aha00 AND
                              aha000 = '3'
                    IF g_cnt > 0 THEN   #資料重複
                        CALL cl_err(g_aha.aha01,-239,0)
                        LET g_aha.aha01 = g_aha01_t
                        DISPLAY BY NAME g_aha.aha01
                        NEXT FIELD aha01
                    END IF
                END IF
            END IF
 
        AFTER FIELD aha02
            IF cl_null(g_aha.aha02) THEN
                LET g_aha.aha02 = g_aha_o.aha02
                DISPLAY BY NAME g_aha.aha02
            ELSE
                CALL i730_aha02('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD aha02
                END IF
            END IF
            LET g_aha_o.aha02 = g_aha.aha02
 
        AFTER FIELD aha03
            LET g_aha_o.aha03 = g_aha.aha03
 
        AFTER FIELD aha07   #總帳單別
            IF NOT cl_null(g_aha.aha07) THEN
               CALL i730_aha07('a',g_aha.aha07)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aha.aha07,g_errno,0)
                  LET g_aha.aha07 = g_aha_t.aha07
                  DISPLAY BY NAME g_aha.aha07
                  NEXT FIELD aha07
               END IF
                    LET g_t1=g_aha.aha07[1,g_doc_len]
#                 CALL s_check_no(g_sys,g_t1,"","","","","")
#                 CALL s_check_no("agl",g_t1,"","","","","")   #No.FUN-A40041      #No.TQC-AC0403
                  CALL s_check_no("agl",g_aha.aha07,g_aha_t.aha07,"*","aha_file", "aha07","")     #No.TQC-AC0403
                  RETURNING li_result,g_aha.aha07
                  LET g_aha.aha07 = s_get_doc_no(g_aha.aha07)
                  DISPLAY BY NAME g_aha.aha07
                  IF (NOT li_result) THEN
                     NEXT FIELD aha07
                  END IF
                SELECT aac08 INTO g_aha.ahamksg FROM aac_file
                   WHERE aac01 =  g_aha.aha07
                DISPLAY BY NAME g_aha.ahamksg
                IF g_aha.ahamksg MATCHES '[Yy]' THEN
                   CALL i730_set_entry(p_cmd)
                ELSE
                   CALL i730_set_no_entry(p_cmd)
                   LET g_aha.ahasign = ' '
                   DISPLAY ' ' TO ahasign
                END IF
            END IF
            LET g_aha_o.aha07 = g_aha.aha07
 
        AFTER FIELD aha05
            LET g_aha_o.aha03 = g_aha.aha03
 
        AFTER FIELD aha06  #有效截止日期
            IF cl_null(g_aha.aha06) THEN
                LET g_aha.aha06 = g_lastdat
                DISPLAY BY NAME g_aha.aha06
            ELSE
                IF g_aha.aha06 < g_aha.aha05 THEN
                   CALL cl_err('','agl-157',0)
                   NEXT FIELD aha05
                END IF
                LET g_aha_o.aha03 = g_aha.aha03
            END IF
 
        BEFORE FIELD aha08
            CALL i730_set_entry(p_cmd)
        AFTER FIELD aha08  #餘額來源 1:實際科目餘額 2:固定預算
            IF NOT cl_null(g_aha.aha08) THEN
               IF g_aha.aha08 NOT MATCHES '[12]'  THEN
                   NEXT FIELD aha08
               END IF
            END IF
            LET g_aha_o.aha08 = g_aha.aha08
            LET l_direct1 = 'D'
            LET l_direct2 = 'D'
            CALL i730_set_no_entry(p_cmd)
 
            IF g_aha.aha08 = '1' THEN #科目餘額檔
               IF l_direct1 = 'D' THEN
                  NEXT FIELD aha10
               ELSE
                  NEXT FIELD aha08
               END IF
            END IF
 
        BEFORE FIELD aha10
            IF g_aha.aha08 = '2' THEN
               IF l_direct2 = 'D' THEN
                  NEXT FIELD aha07
               END IF
            END IF
 
        AFTER FIELD ahasign
            IF g_aha.ahamksg MATCHES '[Yy]' THEN
               IF g_aha.ahasign IS NULL OR g_aha.ahasign =' ' THEN
                  CALL cl_err(g_aha.ahamksg,'agl-092',0)
                  NEXT FIELD ahamksg
               ELSE
                  SELECT * FROM aze_file WHERE aze01 = g_aha.ahasign AND
                                               azeacti IN ('y','Y') AND
                                               aze09 = 7
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("sel","aze_file",g_aha.ahasign,"","agl-093","","",1)  #No.FUN-660123
                      NEXT FIELD ahasign
                   END IF
               END IF
            END IF
 
        ##???是否餘額來源為實際科目餘額時餘額性質一定要輸入
        AFTER FIELD aha10  #餘額性質 1:累計餘額 2:當期異動
            IF NOT cl_null(g_aha.aha10) THEN
               IF g_aha.aha10 NOT MATCHES '[12]' THEN
                   NEXT FIELD aha10
               END IF
            END IF
            LET g_aha_o.aha10 = g_aha.aha10
            LET l_direct1 = 'U'
            IF g_aha.ahamksg MATCHES '[Nn]' OR cl_null(g_aha.ahamksg) THEN
              EXIT INPUT
           END IF
 
        AFTER FIELD ahamksg
           IF g_aha.ahamksg MATCHES '[Nn]' THEN
              EXIT INPUT
           END IF
 
        AFTER FIELD ahaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_aha.ahauser = s_get_data_owner("aha_file") #FUN-C10039
           LET g_aha.ahagrup = s_get_data_group("aha_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_aha.aha00 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_aha.aha00
            END IF
            IF g_aha.aha01 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_aha.aha01
            END IF
            IF g_aha.aha02 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_aha.aha02
            END IF
            IF g_aha.aha08 IS NULL OR g_aha.aha08 NOT MATCHES '[12]' THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_aha.aha08
            END IF
            IF g_aha.aha10 IS NULL OR g_aha.aha10 NOT MATCHES '[12]' THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_aha.aha10
            END IF
            IF l_flag='Y' THEN
                CALL cl_err('','9033',0)
                NEXT FIELD aha00   #No.FUN-740020
            END IF
 
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(aha00) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aaa"
                LET g_qryparam.default1 = g_aha.aha00
                CALL cl_create_qry() RETURNING g_aha.aha00
                DISPLAY BY NAME g_aha.aha00
                CALL i730_aha00('d',g_aha.aha00)
              WHEN INFIELD(aha02) #類別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aca"
                 LET g_qryparam.default1 = g_aha.aha02
                 CALL cl_create_qry() RETURNING g_aha.aha02
                 DISPLAY  BY NAME g_aha.aha02
                 CALL i730_aha02('d')
                 NEXT FIELD aha02
              WHEN INFIELD(aha07) #單據性質
                #CALL q_aac(FALSE,TRUE,g_aha.aha07,'1','0',' ','AGL')  #TQC-670008   #MOD-A40101 mark
                 LET l_aac11="1','3"                                       #MOD-A40101 add
                 CALL q_aac(FALSE,TRUE,g_aha.aha07,l_aac11,'0',' ','AGL')  #MOD-A40101 add
                 RETURNING g_aha.aha07
                 DISPLAY BY NAME g_aha.aha07
                 NEXT FIELD aha07
              WHEN INFIELD (ahasign)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azc"
                 LET g_qryparam.default1 = g_aha.ahasign
                 LET g_qryparam.arg1 = 7
                 CALL cl_create_qry() RETURNING g_aha.ahasign
                 DISPLAY  BY NAME g_aha.ahasign
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT
   #-MOD-AB0052-add-
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt 
      FROM ahd_file
     WHERE ahd01 = g_aha.aha01
       AND ahd00 = g_aha.aha00
       AND ahd000 = '3'
   #IF l_cnt = 0 THEN                  #MOD-B30386 mark
    IF l_cnt = 0 AND p_cmd = 'u' THEN  #MOD-B30386
       SELECT COUNT(*) INTO l_cnt 
         FROM ahb_file
        WHERE ahb01 = g_aha.aha01
          AND ahb00 = g_aha.aha00
          AND ahb000 = '3'
          AND ahb06 = '1' 
       IF l_cnt = 0 THEN
          CALL cl_err('','aap-401',1)
       END IF
       
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt 
         FROM ahb_file
        WHERE ahb01 = g_aha.aha01
          AND ahb00 = g_aha.aha00
          AND ahb000 = '3'
          AND ahb06 = '2' 
       IF l_cnt = 0 THEN
          CALL cl_err('','aap-402',1)
       END IF
    END IF
   #-MOD-AB0052-end-
END FUNCTION

FUNCTION i730_aha00(p_cmd,p_aha00)
  DEFINE p_cmd     LIKE type_file.chr1,  
         p_aha00   LIKE aha_file.aha00,
         l_aaaacti LIKE aaa_file.aaaacti
 
    LET g_errno = ' '
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_aha00
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
	END CASE
END FUNCTION
 
FUNCTION  i730_aha02(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
    l_aca02         LIKE aca_file.aca02, 
    l_aca03         LIKE aca_file.aca03,
    l_acaacti       LIKE aca_file.acaacti
 
    LET g_errno = ' '
    SELECT aca02,aca03,acaacti
        INTO l_aca02,l_aca03,l_acaacti
        FROM aca_file
        WHERE aca01 = g_aha.aha02
    CASE WHEN STATUS=100          LET g_errno = 'agl-090'  #No.7926
                            LET l_aca02 = NULL
         WHEN l_acaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
END FUNCTION
 
#Query 查詢
FUNCTION i730_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_aha.* TO NULL              #No.FUN-6B0040
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_ahb.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i730_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i730_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_aha.* TO NULL
    ELSE
        OPEN i730_count
        FETCH i730_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i730_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i730_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
    l_agso          LIKE type_file.num10              #絕對的筆數         #No.FUN-680098 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i730_cs INTO g_aha.aha01,g_aha.aha00,g_aha.aha000
        WHEN 'P' FETCH PREVIOUS i730_cs INTO g_aha.aha01,g_aha.aha00,g_aha.aha000
        WHEN 'F' FETCH FIRST    i730_cs INTO g_aha.aha01,g_aha.aha00,g_aha.aha000
        WHEN 'L' FETCH LAST     i730_cs INTO g_aha.aha01,g_aha.aha00,g_aha.aha000
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
          FETCH ABSOLUTE g_jump i730_cs INTO g_aha.aha01,g_aha.aha00,g_aha.aha000
          LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aha.aha01,SQLCA.sqlcode,0)
        INITIALIZE g_aha.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_aha.* FROM aha_file WHERE aha00 = g_aha.aha00 AND aha01 = g_aha.aha01 AND aha000 = g_aha.aha000
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","aha_file",g_aha.aha01,g_aha.aha00,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       INITIALIZE g_aha.* TO NULL
       RETURN
    ELSE
       LET g_data_owner = g_aha.ahauser     #No.FUN-4C0048
       LET g_data_group = g_aha.ahagrup     #No.FUN-4C0048
       CALL i730_show()
    END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i730_show()
    LET g_aha_t.* = g_aha.*                #保存單頭舊值
    DISPLAY BY NAME g_aha.ahaoriu,g_aha.ahaorig,                        # 顯示單頭值
 
        g_aha.aha00,     #No.FUN-740020
        g_aha.aha01,g_aha.aha06,g_aha.aha04,g_aha.aha05,
        g_aha.aha02,g_aha.aha03,g_aha.aha08,#g_aha.aha09,   #No.FUN-830139
        g_aha.aha10,g_aha.aha07,g_aha.ahamksg,g_aha.ahasign,
        g_aha.ahauser,g_aha.ahagrup,g_aha.ahamodu,g_aha.ahadate,
        g_aha.ahaacti,
        g_aha.ahaud01,g_aha.ahaud02,g_aha.ahaud03,g_aha.ahaud04,
        g_aha.ahaud05,g_aha.ahaud06,g_aha.ahaud07,g_aha.ahaud08,
        g_aha.ahaud09,g_aha.ahaud10,g_aha.ahaud11,g_aha.ahaud12,
        g_aha.ahaud13,g_aha.ahaud14,g_aha.ahaud15 
    CALL i730_ahd03()
    CALL i730_aha02('d')
    CALL cl_set_field_pic("","","","","",g_aha.ahaacti)
    CALL i730_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i730_ahd03()
DEFINE l_str   LIKE type_file.chr1000,#No.FUN-680098 VARCHAR(1000)
       l_ahd03 LIKE ahd_file.ahd03,
       l_ahd04 LIKE ahd_file.ahd04
 
  LET l_str = ' '
  DECLARE i730_ahd_cs CURSOR FOR
          SELECT ahd03,ahd04 FROM ahd_file
            WHERE ahd00 = g_aha.aha00 AND   #No.TQC-740093   g_bookno -->g_aha.aha00
                  ahd01 = g_aha.aha01 AND
                  ahd000 = '3'
  FOREACH i730_ahd_cs INTO l_ahd03,l_ahd04
    IF SQLCA.sqlcode THEN EXIT FOREACH END IF
    IF NOT cl_null(l_ahd04) THEN
       LET l_ahd03=l_ahd03 CLIPPED,'(',l_ahd04 CLIPPED,')'
    END IF
    IF cl_null(l_str)
       THEN LET l_str = l_ahd03 CLIPPED
       ELSE LET l_str = l_str CLIPPED,' ',l_ahd03
    END IF
  END FOREACH
  DISPLAY l_str TO FORMONLY.ahd03_1
END FUNCTION
 
FUNCTION i730_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_aha.aha00 IS NULL OR g_aha.aha01 IS NULL THEN  #No.FUN-740020
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i730_cl USING g_aha.aha00,g_aha.aha01,g_aha.aha000
    IF STATUS THEN
       CALL cl_err("OPEN i730_cl2:", STATUS, 1)
       CLOSE i730_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i730_cl INTO g_aha.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aha.aha01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i730_cl ROLLBACK WORK RETURN
    END IF
    CALL i730_show()
    IF cl_exp(0,0,g_aha.ahaacti) THEN                   #確認一下
        LET g_chr=g_aha.ahaacti
        IF g_aha.ahaacti='Y' THEN
            LET g_aha.ahaacti='N'
        ELSE
            LET g_aha.ahaacti='Y'
        END IF
        UPDATE aha_file                    #更改有效碼
            SET ahaacti=g_aha.ahaacti
            WHERE aha01=g_aha.aha01 AND aha00 = g_aha.aha00 AND
                  aha000 = g_aha.aha000
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","aha_file",g_aha.aha01,g_aha.aha00,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            LET g_aha.ahaacti=g_chr
        END IF
        DISPLAY BY NAME g_aha.ahaacti
    END IF
    CLOSE i730_cl
    COMMIT WORK
 
    #CKP
    CALL cl_set_field_pic("","","","","",g_aha.ahaacti)
 
END FUNCTION
 
#刪除資料
FUNCTION i730_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_aha.aha00 IS NULL OR g_aha.aha01 IS NULL THEN  #No.FUN-740020
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i730_cl USING g_aha.aha00,g_aha.aha01,g_aha.aha000
    IF STATUS THEN
       CALL cl_err("OPEN i730_cl3:", STATUS, 1)
       CLOSE i730_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i730_cl INTO g_aha.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_aha.aha01,SQLCA.sqlcode,0)
       CLOSE i730_cl ROLLBACK WORK RETURN END IF
    CALL i730_show()
#   IF cl_delh1(0,0) THEN                   #確認一下   #No.FUN-9B0098 MARK 10/03/01
    IF cl_delh(0,0) THEN               #No.FUN-9B0098 MODIFY 10/03/01
        LET g_doc.column1 = "aha00"       #No.FUN-9B0098 ADD 10/03/01
        LET g_doc.value1 = g_aha.aha00    #No.FUN-9B0098 ADD 10/03/01
        LET g_doc.column2 = "aha000"      #No.FUN-9B0098 ADD 10/03/01
        LET g_doc.value2 = g_aha.aha000   #No.FUN-9B0098 ADD 10/03/01  
        LET g_doc.column3 = "aha01"       #No.FUN-9B0098 ADD 10/03/01  
        LET g_doc.value3 = g_aha.aha01    #No.FUN-9B0098 ADD 10/03/01
        CALL cl_del_doc()                 #No.FUN-9B0098 ADD 10/03/01

        DELETE FROM aha_file WHERE aha00 = g_aha.aha00 AND   #單頭
                                   aha01 = g_aha.aha01 AND
                                   aha000 = g_aha.aha000
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("del","aha_file",g_aha.aha00,g_aha.aha01,SQLCA.sqlcode,"","",1)  #No.FUN-660123
        END IF
        DELETE FROM ahb_file WHERE ahb00 = g_aha.aha00 AND   #單身
                                   ahb01 = g_aha.aha01 AND
                                   ahb000 = g_aha.aha000
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","ahb_file",g_aha.aha00,g_aha.aha01,SQLCA.sqlcode,"","",1)  #No.FUN-660123
        END IF
        DELETE FROM ahc_file WHERE ahc00 = g_aha.aha00 AND   #額外摘要
                                   ahc01 = g_aha.aha01 AND
                                   ahc000 = g_aha.aha000
        IF SQLCA.sqlcode  THEN
            CALL cl_err3("del","ahc_file",g_aha.aha00,g_aha.aha01,SQLCA.sqlcode,"","",1)  #No.FUN-660123
        END IF
        DELETE FROM ahd_file WHERE ahd00 = g_aha.aha00 AND   #比率科目維護
                                   ahd01 = g_aha.aha01 AND
                                   ahd000 = g_aha.aha000
        IF SQLCA.sqlcode     THEN
            CALL cl_err3("del","ahd_file",g_aha.aha00,g_aha.aha01,SQLCA.sqlcode,"","",1)  #No.FUN-660123
        END IF
        CLEAR  FORM
        OPEN i730_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE i730_cs
           CLOSE i730_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end-- 
        FETCH i730_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i730_cs
           CLOSE i730_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i730_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i730_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET g_no_ask = TRUE
           CALL i730_fetch('/')
        END IF
    END IF
    CLOSE i730_cl
    COMMIT WORK
END FUNCTION
#單身
FUNCTION i730_b(p_key)
DEFINE
    p_key           LIKE type_file.chr1,                #No.FUN-680098  VARCHAR(1)
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680098 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680098  SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680098  VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680098  VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,             #No.FUN-680098 VARCHAR(100)
    l_direct        LIKE type_file.chr1,                #FTER  #No.FUN-680098  VARCHAR(1)
    l_direct2       LIKE type_file.chr1,                #FTER  #No.FUN-680098  VARCHAR(1)
    l_aag05         LIKE aag_file.aag05,
    l_aag15         LIKE aag_file.aag15,
    l_aag16         LIKE aag_file.aag16,
    l_aag17         LIKE aag_file.aag17,
    l_aag18         LIKE aag_file.aag18,
    l_aag151        LIKE aag_file.aag151,
    l_aag161        LIKE aag_file.aag161,
    l_aag171        LIKE aag_file.aag171,
    l_aag181        LIKE aag_file.aag181,
    l_aag21         LIKE aag_file.aag21,
    l_aag23         LIKE aag_file.aag23,
    l_cnt           LIKE type_file.num5,          #No.FUN-680098 smallint
    l_cnt1          LIKE type_file.num5,          #No.FUN-680098 smallint
    l_ahb02         LIKE ahb_file.ahb02,
    l_check         LIKE ahb_file.ahb02, #為check AFTER FIELD ahb02時對項次的
    l_check_t       LIKE ahb_file.ahb02,#判斷是否跳過AFTER ROW的處理
    l_aag09         LIKE aag_file.aag09,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680098 smallint
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680098 smallint
 
DEFINE
    l_aag31         LIKE aag_file.aag31,
    l_aag32         LIKE aag_file.aag32,
    l_aag33         LIKE aag_file.aag33,
    l_aag34         LIKE aag_file.aag34,
    l_aag35         LIKE aag_file.aag35,
    l_aag36         LIKE aag_file.aag36,
    l_aag37         LIKE aag_file.aag37,
    l_aag311        LIKE aag_file.aag311,
    l_aag321        LIKE aag_file.aag321,
    l_aag331        LIKE aag_file.aag331,
    l_aag341        LIKE aag_file.aag341,
    l_aag351        LIKE aag_file.aag351,
    l_aag361        LIKE aag_file.aag361,
    l_aag371        LIKE aag_file.aag371,
    l_i             LIKE type_file.num10    #No.FUN-680098    integer
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_aha.aha00 IS NULL OR g_aha.aha01 IS NULL THEN  #No.FUN-740020
        RETURN
    END IF
    SELECT * INTO g_aha.* FROM aha_file WHERE aha000=g_aha.aha000
       AND aha00=g_aha.aha00 AND aha01=g_aha.aha01
    IF g_aha.ahaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_aha.aha01,'aom-000',0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    #因為由sagli721回來後的ARRAY_COUNT尚保留為sagli721的ARRAY_COUNT固斧底抽薪之
    #計就是再重SHOW一次
    CALL i730_show()
 
 
    LET g_forupd_sql =
     " SELECT ahb02,ahb03,'',ahb05,ahb06,ahb16, ", #No.FUN-830139 del ahb15
     "        ahb08,ahb35,ahb36,ahb11,ahb12,ahb13,ahb14,",  #No.FUN-830139
 
     "       ahb31,ahb32,ahb33,ahb34,ahb37,",  #No.FUN-830139 移動ahb35,ahb36
 
     "        ahb04, ",
     "       ahbud01,ahbud02,ahbud03,ahbud04,ahbud05,",
     "       ahbud06,ahbud07,ahbud08,ahbud09,ahbud10,",
     "       ahbud11,ahbud12,ahbud13,ahbud14,ahbud15 ", 
     "   FROM ahb_file ",
     "  WHERE ahb000 = ? ",
     "    AND ahb01 = ? ",
     "    AND ahb00 = ? ",
     "    AND ahb02 = ? ",
     "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i730_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ahb
        WITHOUT DEFAULTS
        FROM s_ahb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
             IF g_rec_b != 0 THEN            #No.MOD-480217
               CALL fgl_set_arr_curr(l_ac)
            END IF
     
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            OPEN i730_cl USING g_aha.aha00,g_aha.aha01,g_aha.aha000
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN i730_cl:",SQLCA.sqlcode, 1)
               CLOSE i730_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i730_cl INTO g_aha.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_aha.aha01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i730_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                 LET g_ahb_t.* = g_ahb[l_ac].*     #No.MOD-480217
     
                OPEN i730_bcl USING g_aha.aha000,g_aha.aha01,g_aha.aha00,g_ahb_t.ahb02
                IF STATUS THEN
                    CALL cl_err("OPEN i730_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i730_bcl INTO g_ahb[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err("FETCH i730_bcl:",SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                LET g_before_input_done = FALSE
                CALL i730_set_entry_b(p_cmd)
                CALL i730_set_no_entry_b(p_cmd)
                LET g_before_input_done = TRUE
                CALL i730_ahb03(' ')           #for referenced field
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
     
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
                CANCEL INSERT        #No.MOD-480217
            END IF
     
            INSERT INTO ahb_file(ahb00,ahb000,ahb01,ahb02,ahb03,
                                 ahb04,ahb05,ahb06,ahb16,ahb08,
                                 ahb11,ahb12,ahb13,ahb14,
     
                                 ahb31,ahb32,ahb33,ahb34,
                                 ahb35,ahb36,ahb37,
                                 ahbud01,ahbud02,ahbud03,
                                 ahbud04,ahbud05,ahbud06,
                                 ahbud07,ahbud08,ahbud09,
                                 ahbud10,ahbud11,ahbud12,
                                 ahbud13,ahbud14,ahbud15,ahblegal  #FUN-980003 add legal
     
                                 )
            VALUES(g_aha.aha00,g_aha.aha000,g_aha.aha01,
                   g_ahb[l_ac].ahb02,g_ahb[l_ac].ahb03,
                   g_ahb[l_ac].ahb04,g_ahb[l_ac].ahb05,    
                   g_ahb[l_ac].ahb06,g_ahb[l_ac].ahb16,
                   g_ahb[l_ac].ahb08,g_ahb[l_ac].ahb11,
                   g_ahb[l_ac].ahb12,g_ahb[l_ac].ahb13,
                   g_ahb[l_ac].ahb14,#g_ahb[l_ac].ahb15,       #No.FUN-830139
     
                   g_ahb[l_ac].ahb31,g_ahb[l_ac].ahb32,g_ahb[l_ac].ahb33,
                   g_ahb[l_ac].ahb34,g_ahb[l_ac].ahb35,g_ahb[l_ac].ahb36,
                   g_ahb[l_ac].ahb37,
                   g_ahb[l_ac].ahbud01,g_ahb[l_ac].ahbud02,
                   g_ahb[l_ac].ahbud03,g_ahb[l_ac].ahbud04,
                   g_ahb[l_ac].ahbud05,g_ahb[l_ac].ahbud06,
                   g_ahb[l_ac].ahbud07,g_ahb[l_ac].ahbud08,
                   g_ahb[l_ac].ahbud09,g_ahb[l_ac].ahbud10,
                   g_ahb[l_ac].ahbud11,g_ahb[l_ac].ahbud12,
                   g_ahb[l_ac].ahbud13,g_ahb[l_ac].ahbud14,
                   g_ahb[l_ac].ahbud15,g_legal  #FUN-980003 add legal
     
                   )
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","ahb_file",g_aha.aha00,g_aha.aha01,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                LET g_ahb[l_ac].* = g_ahb_t.*
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
     
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ahb[l_ac].* TO NULL      #900423
            LET g_ahb_t.* = g_ahb[l_ac].*         #新輸入資料
            IF l_ac > 1 THEN
               LET g_ahb[l_ac].ahb03 = g_ahb[l_ac-1].ahb03
               LET g_ahb[l_ac].ahb16 = g_ahb[l_ac-1].ahb16
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ahb02
     
        BEFORE FIELD ahb02                        #default 序號
            IF g_ahb[l_ac].ahb02 IS NULL OR
               g_ahb[l_ac].ahb02 = 0 THEN
                SELECT max(ahb02)+1
                   INTO g_ahb[l_ac].ahb02
                   FROM ahb_file
                   WHERE ahb01 = g_aha.aha01 AND
                         ahb00 = g_aha.aha00 AND   #No.FUN-740020
                         ahb000 = '3'
                IF g_ahb[l_ac].ahb02 IS NULL THEN
                    LET g_ahb[l_ac].ahb02 = 1
                END IF
            END IF
     
        AFTER FIELD ahb02                        #check 序號是否重複
            IF g_ahb[l_ac].ahb02 != g_ahb_t.ahb02 OR
               g_ahb_t.ahb02 IS NULL THEN
                SELECT count(*)
                    INTO l_n
                    FROM ahb_file
                    WHERE  ahb000= g_aha.aha000 AND
                           ahb00 = g_aha.aha00 AND
                           ahb01 = g_aha.aha01 AND
                           ahb02 = g_ahb[l_ac].ahb02
               IF g_ahb[l_ac].ahb02 < l_check_t THEN #FOR (-U)
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ahb[l_ac].ahb02 = g_ahb_t.ahb02
                    NEXT FIELD ahb02
                END IF
               END IF
            END IF
     
        BEFORE FIELD ahb03
          CALL i730_set_entry_b(p_cmd)
     
        AFTER FIELD ahb03
          IF NOT cl_null(g_ahb[l_ac].ahb03) THEN
              CALL i730_ahb03('a')
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                 #Mod No.FUN-B10048
                 #LET g_ahb[l_ac].ahb03=g_ahb_t.ahb03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = g_ahb[l_ac].ahb03
                  LET g_qryparam.arg1 = g_aha.aha00  #No.FUN-740020
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aag01 LIKE '",g_ahb[l_ac].ahb03 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_ahb[l_ac].ahb03
                 #End Mod No.FUN-B10048
                  DISPLAY BY NAME g_ahb[l_ac].ahb03
                  NEXT FIELD ahb03
              END IF
              SELECT aag05,aag15,aag16,aag17,aag18,aag151,aag161,aag171,aag181,
                     aag21,aag23,
     
                      aag31,aag32,aag33,aag34,aag35,aag36,aag37,
                      aag311,aag321,aag331,aag341,aag351,aag361,aag371
     
                     INTO l_aag05,l_aag15,l_aag16,l_aag17,l_aag18,
                          l_aag151,l_aag161,l_aag171,l_aag181,
                          l_aag21,l_aag23,
     
                          l_aag31,l_aag32,l_aag33,l_aag34,l_aag35,
                          l_aag36,l_aag37,l_aag311,l_aag321,l_aag331,
                          l_aag341,l_aag351,l_aag361,l_aag371
     
                           FROM aag_file
                                WHERE aag01 = g_ahb[l_ac].ahb03
                                  AND aag00 = g_aha.aha00     #No.FUN-740020
                  IF l_aag151 IS NULL THEN
                     LET g_ahb[l_ac].ahb11=NULL
                  END IF
                  IF l_aag161 IS NULL THEN
                     LET g_ahb[l_ac].ahb12=NULL
                  END IF
                  IF l_aag171 IS NULL THEN
                     LET g_ahb[l_ac].ahb13=NULL
                  END IF
                  IF l_aag181 IS NULL THEN
                     LET g_ahb[l_ac].ahb14=NULL
                  END IF
                  DISPLAY BY NAME g_ahb[l_ac].ahb11
                  DISPLAY BY NAME g_ahb[l_ac].ahb12
                  DISPLAY BY NAME g_ahb[l_ac].ahb13
                  DISPLAY BY NAME g_ahb[l_ac].ahb14
     
                  IF l_aag311 IS NULL THEN
                     LET g_ahb[l_ac].ahb31=NULL
                  END IF
                  IF l_aag321 IS NULL THEN
                     LET g_ahb[l_ac].ahb32=NULL
                  END IF
                  IF l_aag331 IS NULL THEN
                     LET g_ahb[l_ac].ahb33=NULL
                  END IF
                  IF l_aag341 IS NULL THEN
                     LET g_ahb[l_ac].ahb34=NULL
                  END IF
                  IF l_aag351 IS NULL THEN
                     LET g_ahb[l_ac].ahb35=NULL
                  END IF
                  IF l_aag361 IS NULL THEN
                     LET g_ahb[l_ac].ahb36=NULL
                  END IF
                  IF l_aag371 IS NULL THEN
                     LET g_ahb[l_ac].ahb37=NULL
                  END IF
                  IF l_aag05 = 'N' THEN
                     LET g_ahb[l_ac].ahb05=NULL
                  END IF
          END IF
          CALL i730_set_no_entry_b(p_cmd) #FUN-5C0015 BY GILL
     
          CALL i730_set_no_required()
          CALL i730_set_required(l_aag151,l_aag161,l_aag171,l_aag181,
                                 l_aag311,l_aag321,l_aag331,l_aag341,
                                 l_aag351,l_aag361,l_aag371)
     
        #科目為需有部門資料者才需建立此欄位
        AFTER FIELD ahb05
            IF NOT cl_null(g_ahb[l_ac].ahb05) THEN
               SELECT * FROM gem_file WHERE gem01 = g_ahb[l_ac].ahb05
                                        AND gem05='Y' AND gemacti='Y'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","gem_file","g_ahb[l_ac].ahb05","","agl-003","","",1)  #No.FUN-660123
                  NEXT FIELD ahb05
               END IF
               SELECT aag05 INTO l_aag05 FROM aag_file
                 WHERE aag01 = g_ahb[l_ac].ahb03
                   AND aag00 = g_aha.aha00    #No.FUN-740020
               IF l_aag05 = 'Y' THEN
                  CALL s_chkdept(g_aaz.aaz72,g_ahb[l_ac].ahb03,g_ahb[l_ac].ahb05,g_aha.aha00)  #No.FUN-740020
                       RETURNING g_errno
                  IF not cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD  ahb05
                  END IF
               END IF   #TQC-620028
            END IF
            LET l_direct = 'U'
     
        AFTER FIELD ahb06
            IF NOT cl_null(g_ahb[l_ac].ahb06) THEN
               IF g_ahb[l_ac].ahb06 NOT MATCHES '[12]' THEN
                   NEXT FIELD ahb06
               END IF
            END IF
            LET l_direct = 'U'
     
        AFTER FIELD ahb16
            IF NOT cl_null(g_ahb[l_ac].ahb16) THEN
                SELECT * FROM aag_file WHERE aag01 = g_ahb[l_ac].ahb16 AND
                                             aag00 = g_aha.aha00 AND #No.FUN-740020
                                             aagacti IN ('Y','y') AND
                                             aag03 = '2'
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("sel","aag_file",g_ahb[l_ac].ahb16,"","agl-001","","",1)  #No.FUN-660123
                   LET g_ahb[l_ac].ahb16 = g_ahb_t.ahb16
                   DISPLAY BY NAME g_ahb[l_ac].ahb16
                   NEXT FIELD ahb16
                END IF
            END IF
     
        AFTER FIELD ahb08
            IF NOT cl_null(g_ahb[l_ac].ahb08) THEN
                SELECT * FROM pja_file
                       WHERE pja01 = g_ahb[l_ac].ahb08
                         AND pjaacti = 'Y'
                         AND pjaclose = 'N'                     #No.FUN-960038
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("sel","pja_file",g_ahb[l_ac].ahb08,"","agl-007","","",1)  #No.FUN-660123  #FUN-810045 gja->pja
                   LET g_ahb[l_ac].ahb08 = g_ahb_t.ahb08
                   DISPLAY BY NAME g_ahb[l_ac].ahb16
                   NEXT FIELD ahb16
                END IF
            END IF
            LET l_direct2 = 'U'
     
        BEFORE FIELD ahb11
          CALL i730_show_ahe02(l_aag15)
     
     
        AFTER FIELD ahb11
            IF NOT cl_null(g_ahb[l_ac].ahb11) THEN
                CALL s_chk_aee(g_ahb[l_ac].ahb03,'1',g_ahb[l_ac].ahb11,g_aha.aha00) #No.FUN-740020
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD ahb11
                END IF
            END IF
     
        BEFORE FIELD ahb12
          CALL i730_show_ahe02(l_aag16)
     
        AFTER FIELD ahb12
            IF NOT cl_null(g_ahb[l_ac].ahb12) THEN
                CALL s_chk_aee(g_ahb[l_ac].ahb03,'2',g_ahb[l_ac].ahb12,g_aha.aha00)  #No.FUN-740020
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD ahb12
                END IF
            END IF
     
        BEFORE FIELD ahb13
          CALL i730_show_ahe02(l_aag17)
     
        AFTER FIELD ahb13
            IF NOT cl_null(g_ahb[l_ac].ahb13) THEN
                CALL s_chk_aee(g_ahb[l_ac].ahb03,'3',g_ahb[l_ac].ahb13,g_aha.aha00) #No.FUN-740020
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD ahb13
                END IF
            END IF
     
        BEFORE FIELD ahb14
          CALL i730_show_ahe02(l_aag18)
     
        AFTER FIELD ahb14
          IF NOT cl_null(g_ahb[l_ac].ahb14) THEN
              CALL s_chk_aee(g_ahb[l_ac].ahb03,'4',g_ahb[l_ac].ahb14,g_aha.aha00) #No.FUN-740020
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD ahb14
              END IF
          END IF
     
        BEFORE FIELD ahb31
          CALL i730_show_ahe02(l_aag31)
     
        AFTER FIELD ahb31
          IF NOT cl_null(g_ahb[l_ac].ahb31) THEN
            CALL s_chk_aee(g_ahb[l_ac].ahb03,'5',g_ahb[l_ac].ahb31,g_aha.aha00) #No.FUN-740020
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD ahb31
            END IF
          END IF
     
        BEFORE FIELD ahb32
          CALL i730_show_ahe02(l_aag32)
     
        AFTER FIELD ahb32
           IF NOT cl_null(g_ahb[l_ac].ahb32) THEN
              CALL s_chk_aee(g_ahb[l_ac].ahb03,'6',g_ahb[l_ac].ahb32,g_aha.aha00) #No.FUN-740020
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD ahb32
              END IF
           END IF
     
        BEFORE FIELD ahb33
          CALL i730_show_ahe02(l_aag33)
     
        AFTER FIELD ahb33
           IF NOT cl_null(g_ahb[l_ac].ahb33) THEN
              CALL s_chk_aee(g_ahb[l_ac].ahb03,'7',g_ahb[l_ac].ahb33,g_aha.aha00) #No.FUN-740020
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD ahb33
              END IF
           END IF
     
        BEFORE FIELD ahb34
          CALL i730_show_ahe02(l_aag34)
     
        AFTER FIELD ahb34
           IF NOT cl_null(g_ahb[l_ac].ahb34) THEN
              CALL s_chk_aee(g_ahb[l_ac].ahb03,'8',g_ahb[l_ac].ahb34,g_aha.aha00) #No.FUN-740020
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD ahb34
              END IF
           END IF
     
        BEFORE FIELD ahb35
          CALL i730_show_ahe02(l_aag35)
     
        AFTER FIELD ahb35
           IF NOT cl_null(g_ahb[l_ac].ahb35) THEN
              CALL i730_chk_ahb35()  #No.FUN-830139
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD ahb35
              END IF
           END IF
     
        BEFORE FIELD ahb36
          CALL i730_show_ahe02(l_aag36)
     
        AFTER FIELD ahb36
           IF NOT cl_null(g_ahb[l_ac].ahb36) THEN
              CALL i730_chk_ahb36()   #No.FUN-830139
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD ahb36
              END IF
           END IF
     
        BEFORE FIELD ahb37
          CALL i730_show_ahe02(l_aag37)
     
        AFTER FIELD ahb37
           IF NOT cl_null(g_ahb[l_ac].ahb37) THEN
              CALL s_chk_aee(g_ahb[l_ac].ahb03,'99',g_ahb[l_ac].ahb37,g_aha.aha00) #No.FUN-740020
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD ahb37
              END IF
           END IF
     
     
        AFTER FIELD ahbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ahbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     
        BEFORE DELETE                            #是否取消單身
            IF g_ahb_t.ahb02 > 0 AND
               g_ahb_t.ahb02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM ahb_file
                    WHERE ahb01 = g_aha.aha01
                      AND ahb02 = g_ahb_t.ahb02
                      AND ahb00 = g_aha.aha00 #no.7277
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","ahb_file",g_aha.aha01,g_ahb_t.ahb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
     
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ahb[l_ac].* = g_ahb_t.*
               CLOSE i730_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ahb[l_ac].ahb02,-263,1)
               LET g_ahb[l_ac].* = g_ahb_t.*
            ELSE
     
                IF g_aaz.aaz88 > 0 THEN
                  FOR l_i = 1 TO g_aaz.aaz88
                    CASE
                      WHEN l_i = 1
                        CALL s_chk_aee(g_ahb[l_ac].ahb03,'1',g_ahb[l_ac].ahb11,g_aha.aha00) #No.FUN-740020
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,1)
                           NEXT FIELD ahb11
                        END IF
                      WHEN l_i = 2
                        CALL s_chk_aee(g_ahb[l_ac].ahb03,'2',g_ahb[l_ac].ahb12,g_aha.aha00) #No.FUN-740020
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,1)
                           NEXT FIELD ahb12
                        END IF
                      WHEN l_i = 3
                        CALL s_chk_aee(g_ahb[l_ac].ahb03,'3',g_ahb[l_ac].ahb13,g_aha.aha00) #No.FUN-740020
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,1)
                           NEXT FIELD ahb13
                        END IF
                      WHEN l_i = 4
                        CALL s_chk_aee(g_ahb[l_ac].ahb03,'4',g_ahb[l_ac].ahb14,g_aha.aha00) #No.FUN-740020
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,1)
                           NEXT FIELD ahb14
                        END IF

#FUN-B50105   ---start   Add
                     END CASE
                  END FOR
                END IF

                IF g_aaz.aaz125 > 4 THEN
                  FOR l_i = 5 TO g_aaz.aaz125
                    CASE
#FUN-B50105   ---end     Add

                      WHEN l_i = 5
                        CALL s_chk_aee(g_ahb[l_ac].ahb03,'5',g_ahb[l_ac].ahb31,g_aha.aha00) #No.FUN-740020
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,1)
                           NEXT FIELD ahb31
                        END IF
                      WHEN l_i = 6
                        CALL s_chk_aee(g_ahb[l_ac].ahb03,'6',g_ahb[l_ac].ahb32,g_aha.aha00) #No.FUN-740020
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,1)
                           NEXT FIELD ahb32
                        END IF
                      WHEN l_i = 7
                        CALL s_chk_aee(g_ahb[l_ac].ahb03,'7',g_ahb[l_ac].ahb33,g_aha.aha00) #No.FUN-740020
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,1)
                           NEXT FIELD ahb33
                        END IF
                      WHEN l_i = 8
                        CALL s_chk_aee(g_ahb[l_ac].ahb03,'8',g_ahb[l_ac].ahb34,g_aha.aha00) #No.FUN-740020
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,1)
                           NEXT FIELD ahb34
                        END IF
                      WHEN l_i = 9
                        CALL i730_chk_ahb35()    #No.FUN-830139
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,1)
                           NEXT FIELD ahb35
                        END IF
                      WHEN l_i = 10
                        CALL i730_chk_ahb36()    #No.FUN-830139
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,1)
                           NEXT FIELD ahb36
                        END IF
                     END CASE
                  END FOR
                END IF
                CALL s_chk_aee(g_ahb[l_ac].ahb03,'99',g_ahb[l_ac].ahb37,g_aha.aha00)  #No.FUN-740020
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD ahb37
                END IF
     
                UPDATE ahb_file SET ahb02 = g_ahb[l_ac].ahb02,
                                    ahb03 = g_ahb[l_ac].ahb03,
                                    ahb04 = g_ahb[l_ac].ahb04,
                                    ahb05 = g_ahb[l_ac].ahb05,
                                    ahb06 = g_ahb[l_ac].ahb06,
                                    ahb16 = g_ahb[l_ac].ahb16,
                                    ahb08 = g_ahb[l_ac].ahb08,
                                    ahb11 = g_ahb[l_ac].ahb11,
                                    ahb12 = g_ahb[l_ac].ahb12,
                                    ahb13 = g_ahb[l_ac].ahb13,
                                    ahb14 = g_ahb[l_ac].ahb14,
     
                                    ahb31 = g_ahb[l_ac].ahb31,
                                    ahb32 = g_ahb[l_ac].ahb32,
                                    ahb33 = g_ahb[l_ac].ahb33,
                                    ahb34 = g_ahb[l_ac].ahb34,
                                    ahb35 = g_ahb[l_ac].ahb35,
                                    ahb36 = g_ahb[l_ac].ahb36,
                                    ahb37 = g_ahb[l_ac].ahb37,
                                    ahbud01 = g_ahb[l_ac].ahbud01,
                                    ahbud02 = g_ahb[l_ac].ahbud02,
                                    ahbud03 = g_ahb[l_ac].ahbud03,
                                    ahbud04 = g_ahb[l_ac].ahbud04,
                                    ahbud05 = g_ahb[l_ac].ahbud05,
                                    ahbud06 = g_ahb[l_ac].ahbud06,
                                    ahbud07 = g_ahb[l_ac].ahbud07,
                                    ahbud08 = g_ahb[l_ac].ahbud08,
                                    ahbud09 = g_ahb[l_ac].ahbud09,
                                    ahbud10 = g_ahb[l_ac].ahbud10,
                                    ahbud11 = g_ahb[l_ac].ahbud11,
                                    ahbud12 = g_ahb[l_ac].ahbud12,
                                    ahbud13 = g_ahb[l_ac].ahbud13,
                                    ahbud14 = g_ahb[l_ac].ahbud14,
                                    ahbud15 = g_ahb[l_ac].ahbud15
     
                WHERE ahb000 = g_aha.aha000
                  AND ahb01 = g_aha.aha01
                  AND ahb00 = g_aha.aha00
                  AND ahb02 =g_ahb_t.ahb02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","ahb_file",g_aha.aha01,g_aha.aha00,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                    LET g_ahb[l_ac].* = g_ahb_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
     
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D30032
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #LET g_ahb[l_ac].* = g_ahb_t.*  #FUN-D30032
               #FUN-D30032--add--str--
               IF p_cmd='u' THEN
                  LET g_ahb[l_ac].* = g_ahb_t.*
               ELSE
                  CALL g_ahb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF
               CLOSE i730_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032
            IF cl_null(g_ahb[l_ac].ahb02) THEN
               CALL g_ahb.deleteElement(l_ac)
            END IF
            CLOSE i730_bcl
            COMMIT WORK
     
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ahb03)      #查詢科目代號不為統制帳戶'1'
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_ahb[l_ac].ahb03
                 LET g_qryparam.arg1 = g_aha.aha00  #No.FUN-740020
                 LET g_qryparam.where = " aag03 ='2'"
                 CALL cl_create_qry() RETURNING g_ahb[l_ac].ahb03
                  DISPLAY BY NAME g_ahb[l_ac].ahb03          #No.MOD-490344
                 CALL i730_ahb03('d')
                 NEXT FIELD ahb03
              WHEN INFIELD(ahb16)      #查詢科目代號為帳戶性質
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_ahb[l_ac].ahb16
                 LET g_qryparam.arg1 = g_aha.aha00  #No.FUN-740020
                 LET g_qryparam.where = " aag03 ='2'"
                 CALL cl_create_qry() RETURNING g_ahb[l_ac].ahb16
                  DISPLAY BY NAME g_ahb[l_ac].ahb16          #No.MOD-490344
                 NEXT FIELD ahb16
              WHEN INFIELD(ahb04)     #查詢分攤摘要
                 CALL q_aad(FALSE,TRUE,g_ahb[l_ac].ahb04) RETURNING g_ahb[l_ac].ahb04
                  DISPLAY BY NAME g_ahb[l_ac].ahb04          #No.MOD-490344
                 NEXT FIELD ahb04
              WHEN INFIELD(ahb05) #查詢部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_ahb[l_ac].ahb05
                 LET g_qryparam.arg1 = g_aha.aha00  #No.FUN-740020
                 CALL cl_create_qry() RETURNING g_ahb[l_ac].ahb05
                  DISPLAY BY NAME g_ahb[l_ac].ahb05          #No.MOD-490344
                 NEXT FIELD ahb05
              WHEN INFIELD(ahb08)    #查詢專案編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pja2"    #FUN-810045 
                 LET g_qryparam.default1 = g_ahb[l_ac].ahb08
                 LET g_qryparam.arg1 = g_aha.aha00  #No.FUN-740020
                 CALL cl_create_qry() RETURNING g_ahb[l_ac].ahb08
                  DISPLAY BY NAME g_ahb[l_ac].ahb08          #No.MOD-490344
                 NEXT FIELD ahb08
     
             WHEN INFIELD(ahb11)    #查詢異動碼-1
                  CALL s_ahe_qry(g_ahb[l_ac].ahb03,'1','i',g_ahb[l_ac].ahb11,g_aha.aha00)  #No.FUN-740020
                     RETURNING g_ahb[l_ac].ahb11
                  DISPLAY g_ahb[l_ac].ahb11 TO ahb11
                  NEXT FIELD ahb11
     
             WHEN INFIELD(ahb12)    #查詢異動碼-2
                  CALL s_ahe_qry(g_ahb[l_ac].ahb03,'2','i',g_ahb[l_ac].ahb12,g_aha.aha00)  #No.FUN-740020
                     RETURNING g_ahb[l_ac].ahb12
                  DISPLAY g_ahb[l_ac].ahb12 TO ahb12
                  NEXT FIELD ahb12
     
             WHEN INFIELD(ahb13)    #查詢異動碼-3
                  CALL s_ahe_qry(g_ahb[l_ac].ahb03,'3','i',g_ahb[l_ac].ahb13,g_aha.aha00)  #No.FUN-740020
                     RETURNING g_ahb[l_ac].ahb13
                  DISPLAY g_ahb[l_ac].ahb13 TO ahb13
                  NEXT FIELD ahb13
     
             WHEN INFIELD(ahb14)    #查詢異動碼-4
                  CALL s_ahe_qry(g_ahb[l_ac].ahb03,'4','i',g_ahb[l_ac].ahb14,g_aha.aha00)  #No.FUN-740020
                     RETURNING g_ahb[l_ac].ahb14
                  DISPLAY g_ahb[l_ac].ahb14 TO ahb14
                  NEXT FIELD ahb14
     
             WHEN INFIELD(ahb31)    #查詢異動碼-5
                  CALL s_ahe_qry(g_ahb[l_ac].ahb03,'5','i',g_ahb[l_ac].ahb31,g_aha.aha00)  #No.FUN-740020
                     RETURNING g_ahb[l_ac].ahb31
                  DISPLAY g_ahb[l_ac].ahb31 TO ahb31
                  NEXT FIELD ahb31
     
             WHEN INFIELD(ahb32)    #查詢異動碼-6
                  CALL s_ahe_qry(g_ahb[l_ac].ahb03,'6','i',g_ahb[l_ac].ahb32,g_aha.aha00)  #No.FUN-740020
                     RETURNING g_ahb[l_ac].ahb32
                  DISPLAY g_ahb[l_ac].ahb32 TO ahb32
                  NEXT FIELD ahb32
     
             WHEN INFIELD(ahb33)    #查詢異動碼-7
                  CALL s_ahe_qry(g_ahb[l_ac].ahb03,'7','i',g_ahb[l_ac].ahb33,g_aha.aha00)  #No.FUN-740020
                     RETURNING g_ahb[l_ac].ahb33
                  DISPLAY g_ahb[l_ac].ahb33 TO ahb33
                  NEXT FIELD ahb33
     
             WHEN INFIELD(ahb34)    #查詢異動碼-8
                  CALL s_ahe_qry(g_ahb[l_ac].ahb03,'8','i',g_ahb[l_ac].ahb34,g_aha.aha00)  #No.FUN-740020
                     RETURNING g_ahb[l_ac].ahb34
                  DISPLAY g_ahb[l_ac].ahb34 TO ahb34
                  NEXT FIELD ahb34
     
             WHEN INFIELD(ahb35)    #查詢異動碼-9
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjb"
                  LET g_qryparam.default1 = g_ahb[l_ac].ahb35
                  CALL cl_create_qry() RETURNING g_ahb[l_ac].ahb35
                  DISPLAY g_ahb[l_ac].ahb35 TO ahb35
                  NEXT FIELD ahb35
     
             WHEN INFIELD(ahb36)    #查詢異動碼-10
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf01a" #No.FUN-930104
                  LET g_qryparam.arg1 = '7'       #No.FUN-950077
                  LET g_qryparam.default1 = g_ahb[l_ac].ahb36
                  CALL cl_create_qry() RETURNING g_ahb[l_ac].ahb36
                  DISPLAY g_ahb[l_ac].ahb36 TO ahb36
                  NEXT FIELD ahb36
     
             WHEN INFIELD(ahb37)    #查詢關係人異動碼
                  CALL s_ahe_qry(g_ahb[l_ac].ahb03,'99','i',g_ahb[l_ac].ahb37,g_aha.aha00)  #No.FUN-740020
                     RETURNING g_ahb[l_ac].ahb37
                  DISPLAY g_ahb[l_ac].ahb37 TO ahb37
                  NEXT FIELD ahb37
     
     
              OTHERWISE
                 EXIT CASE
            END CASE
     
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ahb02) AND l_ac > 1 THEN
                LET g_ahb[l_ac].* = g_ahb[l_ac-1].*
                SELECT max(ahb02)+1                                             
                  INTO g_ahb[l_ac].ahb02                                        
                  FROM ahb_file                                                 
                 WHERE ahb01 = g_aha.aha01                                      
                   AND ahb00 = g_aha.aha00  #No.FUN-740033                      
                   AND ahb000= '3'                                              
                DISPLAY BY NAME g_ahb[l_ac].ahb02                               
                NEXT FIELD ahb03                                                
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
 
    END INPUT
 
   #-MOD-A60169-add-
    LET l_cnt = 0
   #-MOD-AB0052-add-
    SELECT COUNT(*) INTO l_cnt 
      FROM ahd_file
     WHERE ahd01 = g_aha.aha01
       AND ahd00 = g_aha.aha00
       AND ahd000 = '3'
    IF l_cnt = 0 THEN 
   #-MOD-AB0052-end-
       SELECT COUNT(*) INTO l_cnt 
         FROM ahb_file
        WHERE ahb01 = g_aha.aha01
          AND ahb00 = g_aha.aha00
          AND ahb000 = '3'
          AND ahb06 = '1' 
       IF l_cnt = 0 THEN
          CALL cl_err('','aap-401',1)
       END IF
       
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt 
         FROM ahb_file
        WHERE ahb01 = g_aha.aha01
          AND ahb00 = g_aha.aha00
          AND ahb000 = '3'
          AND ahb06 = '2' 
       IF l_cnt = 0 THEN
          CALL cl_err('','aap-402',1)
       END IF
    END IF                  #MOD-AB0052
   #-MOD-A60169-add- 

        UPDATE aha_file SET ahamodu=g_user,ahadate=g_today
           WHERE aha01=g_aha.aha01 AND aha00=g_aha.aha00
             AND aha000=g_aha.aha000
 
    CLOSE i730_cl
    CLOSE i730_bcl
    COMMIT WORK
    CALL i730_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i730_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         #CHI-C80041---begin
         DELETE FROM ahc_file WHERE ahc00 = g_aha.aha00 AND  
                                    ahc01 = g_aha.aha01 AND
                                    ahc000 = g_aha.aha000
         DELETE FROM ahd_file WHERE ahd00 = g_aha.aha00 AND   
                                    ahd01 = g_aha.aha01 AND
                                    ahd000 = g_aha.aha000
         #CHI-C80041---end
         DELETE FROM aha_file
          WHERE aha01=g_aha.aha01 AND aha00=g_aha.aha00
            AND aha000=g_aha.aha000
         INITIALIZE g_aha.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i730_delall()
    SELECT COUNT(*) INTO g_cnt FROM ahb_file
        WHERE ahb01 = g_aha.aha01
          AND ahb00 = g_aha.aha00 #no.7277
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 故取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM aha_file WHERE aha01 = g_aha.aha01 AND aha00 = g_aha.aha00
                              AND aha000 = g_aha.aha000
    END IF
END FUNCTION
 
#檢查科目名稱
FUNCTION  i730_ahb03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
    l_aag07         LIKE aag_file.aag07,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02,aag07,aagacti
        INTO g_ahb[l_ac].aag02,l_aag07,l_aagacti
        FROM aag_file
        WHERE aag01 = g_ahb[l_ac].ahb03
          AND aag00 = g_aha.aha00   #No.FUN-740020
    CASE WHEN STATUS=100          LET g_errno = 'agl-001'  #No.7926
          WHEN l_aagacti = 'N' LET g_errno = '9028'
          WHEN l_aag07 = '1' LET g_errno = 'agl-015'
          OTHERWISE LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
    DISPLAY BY NAME g_ahb[l_ac].aag02
END FUNCTION
 
FUNCTION i730_ahb11(p_cmd,p_seq,p_key)
        DEFINE p_cmd    LIKE aag_file.aag151,        # 檢查否
                   p_seq        LIKE type_file.chr1,               # 項   #No.FUN-680098   VARCHAR(1) 
                   p_key        LIKE type_file.chr20,             # 異動碼  #No.FUN-680098    VARCHAR(20) 
                   l_aeeacti  LIKE aee_file.aeeacti,
                   l_aee04    LIKE aee_file.aee04
        LET g_errno = ' '
        IF p_cmd IS NULL OR p_cmd NOT MATCHES "[123]" THEN RETURN END IF
        SELECT aee04,aeeacti INTO l_aee04,l_aeeacti FROM aee_file
                WHERE aee01 = g_ahb[l_ac].ahb03
                  AND aee02 = p_seq     AND aee03 = p_key
                  AND aee00 = g_aha.aha00   #No.MOD-740297
        CASE p_cmd
                WHEN '2' IF p_key IS NULL OR p_key = ' ' THEN
                               LET g_errno = 'agl-154'
                                 END IF
                WHEN '3'
                        CASE
                          WHEN p_key IS NULL OR p_key = ' '
                               LET g_errno = 'agl-154'
                          WHEN l_aeeacti = 'N' LET g_errno = '9027'
                          WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-153'
                          OTHERWISE  LET g_errno = SQLCA.sqlcode USING'-------'
                        END CASE
                OTHERWISE EXIT CASE
        END CASE
        IF l_aee04 IS NOT NULL AND cl_null(g_errno) THEN
           IF g_ahb[l_ac].ahb04 IS NULL
              THEN LET g_ahb[l_ac].ahb04 = l_aee04
              DISPLAY BY NAME g_ahb[l_ac].ahb04
              ELSE IF l_aee04 != g_ahb[l_ac].ahb04  THEN
            LET INT_FLAG = 0  ######add for prompt bug
                      PROMPT l_aee04,' <cr>:' FOR CHAR g_chr
                         ON IDLE g_idle_seconds
                            CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                      END PROMPT
                   END IF
           END IF
        END IF
END FUNCTION
FUNCTION i730_b_askkey()
DEFINE
    l_wc2           STRING        #TQC-630166   
 
    CLEAR aag02                           #清除FORMONLY欄位
    CONSTRUCT l_wc2 ON ahb02,ahb03
                       ,ahbud01,ahbud02,ahbud03,ahbud04,ahbud05
                       ,ahbud06,ahbud07,ahbud08,ahbud09,ahbud10
                       ,ahbud11,ahbud12,ahbud13,ahbud14,ahbud15
            FROM s_ahb[1].ahb02,s_ahb[1].ahb03
                 ,s_ahb[1].ahbud01,s_ahb[1].ahbud02,s_ahb[1].ahbud03
                 ,s_ahb[1].ahbud04,s_ahb[1].ahbud05,s_ahb[1].ahbud06
                 ,s_ahb[1].ahbud07,s_ahb[1].ahbud08,s_ahb[1].ahbud09
                 ,s_ahb[1].ahbud10,s_ahb[1].ahbud11,s_ahb[1].ahbud12
                 ,s_ahb[1].ahbud13,s_ahb[1].ahbud14,s_ahb[1].ahbud15
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
    CALL i730_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i730_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING        #TQC-630166 
 
    LET g_sql =
        " SELECT ahb02,ahb03,aag02,ahb05,ahb06,",
        " ahb16,ahb08,ahb35,ahb36,ahb11,ahb12,ahb13,ahb14,",  #No.FUN-830139
 
        " ahb31,ahb32,ahb33,ahb34,ahb37,",  #No.FUN-830139 ahb35,ahb36 移動位置
 
        " ahb04,",
        " ahbud01,ahbud02,ahbud03,ahbud04,ahbud05,",
        " ahbud06,ahbud07,ahbud08,ahbud09,ahbud10,",
        " ahbud11,ahbud12,ahbud13,ahbud14,ahbud15 ", 
        " FROM ahb_file LEFT OUTER JOIN aag_file ON ahb03 = aag01 AND ahb00 = aag00",
        " WHERE ahb01 ='",g_aha.aha01,"' AND ",  #單頭
        " ahb000= '",g_aha.aha000,"' AND  ",
        " ahb00 = '",g_aha.aha00,"' AND ",
        " ahb02 != 0 AND   ",
        p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i730_pb FROM g_sql
    DECLARE ahb_curs                       #SCROLL CURSOR
        CURSOR FOR i730_pb
 
    CALL g_ahb.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH ahb_curs INTO g_ahb[g_cnt].*   #單身 ARRAY 填充
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
     CALL g_ahb.deleteElement(g_cnt)  #No.MOD-480217
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i730_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ahb TO s_ahb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i730_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i730_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i730_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i730_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i730_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
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
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_field_pic("","","","","",g_aha.ahaacti)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 分攤摘要
      ON ACTION extra_memo
         LET g_action_choice="extra_memo"
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
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION i730_copy()
DEFINE
    l_aha        RECORD LIKE aha_file.*,
    l_ahb        RECORD LIKE ahb_file.*,
    l_ahd        RECORD LIKE ahd_file.*,
    l_oldno0,l_newno0  LIKE aha_file.aha00,    #No.FUN-740020
    l_oldno,l_newno    LIKE aha_file.aha01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_aha.aha00 IS NULL OR g_aha.aha01 IS NULL THEN  #No.FUN-740020
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL i730_set_entry('a')
    CALL i730_set_no_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
    INPUT l_newno0,l_newno FROM aha00,aha01   #No.FUN-740020
        AFTER FIELD aha00
            IF l_newno0 IS NOT NULL THEN
               CALL i730_aha00('a',l_newno0)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(l_newno0,g_errno,0)
                  NEXT FIELD aha00
               END IF
            END IF
        AFTER FIELD aha01
            IF l_newno IS NULL THEN
                NEXT FIELD aha01
            END IF
            SELECT count(*) INTO g_cnt FROM aha_file
                WHERE aha01 = l_newno AND aha00 = l_newno0 AND #No.FUN-740020
                      aha000 = '3'
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD aha00   #No.FUN-740020
            END IF
       ON ACTION CONTROLP 
            IF INFIELD(aha00) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = l_newno0
               CALL cl_create_qry() RETURNING l_newno0
               DISPLAY l_newno0 TO aha00
               NEXT FIELD aha00
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
        DISPLAY BY NAME g_aha.aha01,g_aha.aha00   #No.FUN-740020
      ROLLBACK WORK
        RETURN
    END IF
    LET l_aha.* = g_aha.*
    LET l_aha.aha01  =l_newno   #新的鍵值
    LET l_aha.aha00  =l_newno0  #No.FUN-740020
    LET l_aha.ahauser=g_user    #資料所有者
    LET l_aha.ahagrup=g_grup    #資料所有者所屬群
    LET l_aha.ahamodu=NULL      #資料修改日期
    LET l_aha.ahadate=g_today   #資料建立日期
    LET l_aha.ahaacti='Y'       #有效資料
    LET l_aha.ahalegal=g_legal  #FUN-980003 add
    LET l_aha.ahaoriu = g_user      #No.FUN-980030 10/01/04
    LET l_aha.ahaorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO aha_file VALUES (l_aha.*)
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","aha_file",l_aha.aha01,l_aha.aha00,SQLCA.sqlcode,"","aha:",1)  #No.FUN-660123
        RETURN
    END IF
 
    DECLARE i730_cs3 CURSOR FOR
            SELECT * FROM ahb_file
                   WHERE ahb00 = g_aha.aha00 AND ahb01 = g_aha.aha01 AND  #No.FUN-740020
                         ahb000 = g_aha.aha000
    FOREACH i730_cs3 INTO l_ahb.*
    IF SQLCA.sqlcode THEN EXIT FOREACH END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    END FOREACH
    FOREACH i730_cs3 INTO l_ahb.*
    IF SQLCA.sqlcode THEN EXIT FOREACH END IF
    LET l_ahb.ahb00 = l_newno0   #No.FUN-740020
    LET l_ahb.ahb01 = l_newno
    LET l_ahb.ahblegal = g_legal  #FUN-980003 add
    INSERT INTO ahb_file VALUES(l_ahb.*)
    IF SQLCA.sqlcode THEN 
       CALL cl_err3("ins","ahb_file",l_ahb.ahb01,l_ahb.ahb02,SQLCA.sqlcode,"","ahd:",1)  #No.FUN-660123
    END IF
    END FOREACH
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    #比率科目的維護檔(ahd_file)
    DECLARE i730_cs2  CURSOR FOR
            SELECT * FROM ahd_file
                   WHERE ahd00 = g_aha.aha00 AND ahd01 = g_aha.aha01 AND #No.FUN-740020
                         ahd000 = g_aha.aha000
    FOREACH i730_cs2 INTO l_ahd.*
    IF SQLCA.sqlcode THEN EXIT FOREACH END IF
    LET l_ahd.ahd00 = l_newno0    #No.FUN-740020
    LET l_ahd.ahd01 = l_newno
    INSERT INTO ahd_file VALUES(l_ahd.*)
    IF SQLCA.sqlcode THEN 
      CALL cl_err3("ins","ahd_file",l_ahd.ahd01,l_ahd.ahd02,SQLCA.sqlcode,"","ahd:",1)   #No.FUN-660123                                    #No.FUN-660123
    END IF 
    END FOREACH
 
    LET l_oldno = g_aha.aha01
    LET l_oldno0 = g_aha.aha00   #No.FUN-740020
    SELECT aha_file.* INTO g_aha.* FROM aha_file
                   WHERE aha01 = l_newno AND aha00 = l_newno0 AND   #No.FUN-740020
                         aha000 = g_aha.aha000
    CALL i730_show()
    CALL i730_u()
    CALL i730_b('a')
    #FUN-C30027---begin
    #SELECT aha_file.* INTO g_aha.* FROM aha_file
    #               WHERE aha01 = l_oldno AND
    #                     aha00 = l_oldno0 AND    #No.FUN-740020
    #                     aha000 = g_aha.aha000
    #CALL i730_show()
    #FUN-C30027---end
END FUNCTION
 
FUNCTION i730_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680098 SMALLINT
    sr              RECORD
        aha00       LIKE aha_file.aha00,   #帳套    #No.FUN-740020
        aha01       LIKE aha_file.aha01,   #原始編號
        aha02       LIKE aha_file.aha02,   #產生批號
        aha03       LIKE aha_file.aha03,   #自動產生順序
        aha04       LIKE aha_file.aha04,   #上次產生日期
        aha05       LIKE aha_file.aha05,   #輸入日期
        aha06       LIKE aha_file.aha06,   #有效截止日期
        aha07       LIKE aha_file.aha07,   #總帳傳票單別
        aha08       LIKE aha_file.aha08,   #餘額來源
        aha10       LIKE aha_file.aha10,   #餘額性質
        ahamksg     LIKE aha_file.ahamksg, #簽核否
        ahasign     LIKE aha_file.ahasign, #簽核等級
        ahb02       LIKE ahb_file.ahb02,   #項次
        ahb03       LIKE ahb_file.ahb03,   #科目編號
        ahb05       LIKE ahb_file.ahb05,   #部門
        ahb06       LIKE ahb_file.ahb06,   #人員代號
        ahb07       LIKE ahb_file.ahb07,   #No.FUN-830092 
        ahb16       LIKE ahb_file.ahb16,   #異動金額
        ahb08       LIKE ahb_file.ahb08,   #專案編號
        ahb11       LIKE ahb_file.ahb11,   #異動碼-1
        ahb12       LIKE ahb_file.ahb12,   #異動碼-2
        ahb13       LIKE ahb_file.ahb13,   #異動碼-3
        ahb14       LIKE ahb_file.ahb14,   #異動碼-4
 
        ahb31       LIKE ahb_file.ahb31,   #異動碼-5
        ahb32       LIKE ahb_file.ahb32,   #異動碼-6
        ahb33       LIKE ahb_file.ahb33,   #異動碼-7
        ahb34       LIKE ahb_file.ahb34,   #異動碼-8
        ahb35       LIKE ahb_file.ahb35,   #異動碼-9
        ahb36       LIKE ahb_file.ahb36,   #異動碼-10
        ahb37       LIKE ahb_file.ahb37,   #關係人異動碼
 
        ahb04       LIKE ahb_file.ahb04,   #摘要
        ahaacti     LIKE aha_file.ahaacti
                    END RECORD,
    l_msg           LIKE type_file.chr50,   #No.FUN-680098 VARCHAR(24)
    l_name          LIKE type_file.chr20,   #External(Disk) file name    #No.FUN-680098 VARCHAR(20)
    l_za05          LIKE za_file.za05       #No.FUN-680098 VARCHAR(40)
    DEFINE  l_tc1   LIKE ahb_file.ahb11                                         
    DEFINE  l_tc2   LIKE ahb_file.ahb12                                         
    DEFINE  l_tc3   LIKE ahb_file.ahb13                                         
    DEFINE  l_tc4   LIKE ahb_file.ahb14                                         
    DEFINE  l_tc5   LIKE ahb_file.ahb31                                         
    DEFINE  l_tc6   LIKE ahb_file.ahb32                                         
    DEFINE  l_tc7   LIKE ahb_file.ahb33                                         
    DEFINE  l_tc8   LIKE ahb_file.ahb34                                         
    DEFINE  l_tc9   LIKE ahb_file.ahb35                                         
    DEFINE  l_tc10  LIKE ahb_file.ahb36                                         
    DEFINE  l_tc    LIKE type_file.chr1000                                      
 
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    CALL cl_del_data(l_table)                   #No.FUN-830092
    LET g_chr = ' '

   IF cl_confirm('agl-121') THEN    #no:7429
      LET g_chr='Y'
   ELSE
      LET g_chr='N'
   END IF
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'agli730'
    LET g_sql="SELECT aha00,aha01,aha02,aha03,aha04,aha05,aha06,aha07,", #No.FUN-740020
              "aha08,aha10,ahamksg,ahasign,",         #No.FUN-830139
              "ahb02,ahb03,ahb05,ahb06,ahb16,ahb08,",
              "ahb11,ahb12,ahb13,ahb14,",
 
              " ahb31,ahb32,ahb33,ahb34,ahb35,ahb36,ahb37,",
 
              " ahb04,ahaacti ",
              " FROM aha_file, ahb_file",
              " WHERE aha01 = ahb01 AND  ",g_wc CLIPPED, " AND",
              " aha00 = ahb00 AND aha000 = '3' AND ahb000 = '3' ", #No.FUN-740020
              " AND ",g_wc2 CLIPPED,
              " ORDER BY 1 "
    PREPARE i730_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i730_co CURSOR FOR i730_p1
 
 
    FOREACH i730_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF g_aaz.aaz88 >0 THEN                                                  
           FOR l_i = 1 TO g_aaz.aaz88                                           
               LET l_tc = ''                                                    
               CASE                                                             
                  WHEN l_i = 1                                                  
                       LET l_tc[1,11]=sr.ahb11[1,11]                            
                       LET l_tc1 = l_tc[1,11]                                   
                  WHEN l_i = 2                                                  
                       LET l_tc[1,11]=sr.ahb12[1,11]                            
                       LET l_tc2 = l_tc[1,11]                                   
                  WHEN l_i = 3                                                  
                       LET l_tc[1,11]=sr.ahb13[1,11]                            
                       LET l_tc3 = l_tc[1,11]                                   
                  WHEN l_i = 4                                                  
                       LET l_tc[1,11]=sr.ahb14[1,11]                            
                       LET l_tc4 = l_tc[1,11]                                   

#FUN-B50105   ---start   Add
               END CASE                                                         
           END FOR                                                              
        END IF                                                                  

        IF g_aaz.aaz125 > 4 THEN                                                  
           FOR l_i = 1 TO g_aaz.aaz125                                           
               LET l_tc = ''                                                    
               CASE                                                             
#FUN-B50105   ---end     Add

                  WHEN l_i = 5                                                  
                       LET l_tc[1,11]=sr.ahb31[1,11]                            
                       LET l_tc5 = l_tc[1,11]
                  WHEN l_i = 6                                                  
                       LET l_tc[1,11]=sr.ahb32[1,11]                            
                       LET l_tc6 = l_tc[1,11]                                   
                  WHEN l_i = 7                                                  
                       LET l_tc[1,11]=sr.ahb33[1,11]                            
                       LET l_tc7 = l_tc[1,11]                                   
                  WHEN l_i = 8                                                  
                       LET l_tc[1,11]=sr.ahb34[1,11]                            
                       LET l_tc8 = l_tc[1,11]                                   
                  WHEN l_i = 9                                                  
                       LET l_tc[1,11]=sr.ahb35[1,11]                            
                       LET l_tc9 = l_tc[1,11]                                   
                  WHEN l_i = 10                                                 
                       LET l_tc[1,11]=sr.ahb36[1,11]                            
                       LET l_tc10 = l_tc[1,11]                                  
               END CASE                                                         
           END FOR                                                              
        END IF                                                                  
        EXECUTE insert_prep USING sr.aha00,sr.aha01,sr.aha02,sr.aha03,  
                                  sr.aha05,sr.aha07,sr.aha06,sr.aha08,          
                                  sr.aha10,sr.aha04,                   
                                  sr.ahamksg,sr.ahasign,                        
                                  sr.ahb02,sr.ahb03,sr.ahb04,sr.ahb05,          
                                  sr.ahb06,sr.ahb07,sr.ahb08,sr.ahb37,          
                                  sr.ahaacti,l_tc1,l_tc2,l_tc3,                 
                                  l_tc4,l_tc5,l_tc6,l_tc7,l_tc8,l_tc9,l_tc10    
                                                                                
    END FOREACH                                                                 

    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'aha00,aha01,aha02,aha03,aha05,aha06,aha04,aha07,     
        aha08,aha10,ahamksg,ahasign,ahauser,ahagrup,ahamodu,ahadate,      
        ahaacti,ahb02,ahb03,ahb05,ahb06,ahb16,ahb15,ahb11,ahb12,ahb13,ahb14,    
        ahb31,ahb32,ahb33,ahb34,ahb35,ahb36,ahb37,ahb08,ahb04 ')                
            RETURNING g_str                                            
    END IF                                                                      
    LET g_str = g_str,";",g_aaz.aaz88,";",g_chr,";",g_azi04,";",g_aaz.aaz125    #FUN-B50105   Add ,";",g_aaz.aaz125
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED          
    CALL cl_prt_cs3('agli730','agli730',l_sql,g_str)                            
END FUNCTION
 
#單頭
FUNCTION i730_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("aha00,aha01",TRUE)   #No.FUN-740020
   END IF
   IF INFIELD(aha08) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("aha10",TRUE)         #No.FUN-830139
   END IF
   IF INFIELD(aha07) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("ahasign",TRUE)
   END IF
END FUNCTION
 
FUNCTION i730_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("aha00,aha01",FALSE)  #No.FUN-740020
       END IF
   END IF
   IF INFIELD(aha08) OR (NOT g_before_input_done) THEN
       IF g_aha.aha08 = '2' THEN
           CALL cl_set_comp_entry("aha10",FALSE)
       END IF
   END IF
   IF INFIELD(aha07) OR (NOT g_before_input_done) THEN
      IF g_aha.ahamksg = 'N' THEN
      CALL cl_set_comp_entry("ahasign",FALSE)
      END IF
   END IF
END FUNCTION
 
#單身
FUNCTION i730_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF INFIELD(ahb03) THEN
       CALL cl_set_comp_entry("ahb05,ahb11,ahb12,ahb13,ahb14",TRUE)
      CALL cl_set_comp_entry("ahb08",TRUE)   #No.MOD-930170
 
       CALL cl_set_comp_entry("ahb31,ahb32,ahb33,ahb34,ahb35,ahb36,ahb37",TRUE)
 
   END IF
 
END FUNCTION
 
FUNCTION i730_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
    l_aag05         LIKE aag_file.aag05,
    l_aag21         LIKE aag_file.aag21,
    l_aag23         LIKE aag_file.aag23,
    l_aag151        LIKE aag_file.aag151,
    l_aag161        LIKE aag_file.aag161,
    l_aag171        LIKE aag_file.aag171,
    l_aag181        LIKE aag_file.aag181,
    l_aag311        LIKE aag_file.aag311,
    l_aag321        LIKE aag_file.aag321,
    l_aag331        LIKE aag_file.aag331,
    l_aag341        LIKE aag_file.aag341,
    l_aag351        LIKE aag_file.aag351,
    l_aag361        LIKE aag_file.aag361,
    l_aag371        LIKE aag_file.aag371
 
    SELECT aag05,aag151,aag161,aag171,aag181,aag21,aag23,
           aag311,aag321,aag331,aag341,aag351,aag361,aag371
      INTO l_aag05,
           l_aag151,l_aag161,l_aag171,l_aag181,l_aag21,l_aag23,
           l_aag311,l_aag321,l_aag331,l_aag341,l_aag351,l_aag361,l_aag371
      FROM aag_file
     WHERE aag01 = g_ahb[l_ac].ahb03
       AND aag00 = g_aha.aha00    #No.FUN-740020
    IF l_aag151 IS NULL THEN
       LET g_ahb[l_ac].ahb11=NULL
    END IF
    IF l_aag161 IS NULL THEN
       LET g_ahb[l_ac].ahb12=NULL
    END IF
    IF l_aag171 IS NULL THEN
       LET g_ahb[l_ac].ahb13=NULL
    END IF
    IF l_aag181 IS NULL THEN
       LET g_ahb[l_ac].ahb14=NULL
    END IF
 
    IF l_aag311 IS NULL THEN
       LET g_ahb[l_ac].ahb31=NULL
    END IF
    IF l_aag321 IS NULL THEN
       LET g_ahb[l_ac].ahb32=NULL
    END IF
    IF l_aag331 IS NULL THEN
       LET g_ahb[l_ac].ahb33=NULL
    END IF
    IF l_aag341 IS NULL THEN
       LET g_ahb[l_ac].ahb34=NULL
    END IF
    IF l_aag371 IS NULL THEN
       LET g_ahb[l_ac].ahb37=NULL
    END IF
 
       IF l_aag05 != 'Y' THEN
           CALL cl_set_comp_entry("ahb05",FALSE)
          IF NOT cl_null(g_ahb[l_ac].ahb05) THEN   
             LET g_ahb[l_ac].ahb05 = NULL 
             DISPLAY BY NAME g_ahb[l_ac].ahb05
          END IF 
       END IF
       IF l_aag23 != 'Y' THEN
           CALL cl_set_comp_entry("ahb08,ahb35",FALSE)  #No.MOD-930170 add ahb35
           IF NOT cl_null(g_ahb[l_ac].ahb08) THEN   
              LET g_ahb[l_ac].ahb08 = NULL 
              DISPLAY BY NAME g_ahb[l_ac].ahb08
           END IF 
           IF NOT cl_null(g_ahb[l_ac].ahb35) THEN   
              LET g_ahb[l_ac].ahb35 = NULL 
              DISPLAY BY NAME g_ahb[l_ac].ahb35
           END IF 
       END IF
       IF l_aag21="N" OR cl_null(l_aag21) THEN
          CALL cl_set_comp_entry("ahb36",FALSE)
         IF NOT cl_null(g_ahb[l_ac].ahb36) THEN   
            LET g_ahb[l_ac].ahb36 = NULL 
            DISPLAY BY NAME g_ahb[l_ac].ahb36
         END IF 
       END IF
       IF cl_null(l_aag151) THEN
           CALL cl_set_comp_entry("ahb11",FALSE)
       END IF
       IF cl_null(l_aag161) THEN
           CALL cl_set_comp_entry("ahb12",FALSE)
       END IF
       IF cl_null(l_aag171) THEN
           CALL cl_set_comp_entry("ahb13",FALSE)
       END IF
       IF cl_null(l_aag181) THEN
           CALL cl_set_comp_entry("ahb14",FALSE)
       END IF
 
       IF cl_null(l_aag311) THEN
          CALL cl_set_comp_entry("ahb31",FALSE)
       END IF
       IF cl_null(l_aag321) THEN
          CALL cl_set_comp_entry("ahb32",FALSE)
       END IF
       IF cl_null(l_aag331) THEN
          CALL cl_set_comp_entry("ahb33",FALSE)
       END IF
       IF cl_null(l_aag341) THEN
          CALL cl_set_comp_entry("ahb34",FALSE)
       END IF
       IF cl_null(l_aag371) THEN
          CALL cl_set_comp_entry("ahb37",FALSE)
       END IF
 
 
END FUNCTION
 
FUNCTION  i730_show_field()
#依參數決定異動碼的多寡
 
  DEFINE l_field   STRING
 
#FUN-B50105   ---start   Mark
# IF g_aaz.aaz88 = 10 THEN
#    RETURN
# END IF
#
# IF g_aaz.aaz88 = 0 THEN
#    LET l_field  = "ahb11,ahb12,ahb13,ahb14,ahb31,ahb32,ahb33,ahb34,",
#                   "ahb35,ahb36"
# END IF
#
# IF g_aaz.aaz88 = 1 THEN
#    LET l_field  = "ahb12,ahb13,ahb14,ahb31,ahb32,ahb33,ahb34,",
#                   "ahb35,ahb36"
# END IF
#
# IF g_aaz.aaz88 = 2 THEN
#    LET l_field  = "ahb13,ahb14,ahb31,ahb32,ahb33,ahb34,",
#                   "ahb35,ahb36"
# END IF
#
# IF g_aaz.aaz88 = 3 THEN
#    LET l_field  = "ahb14,ahb31,ahb32,ahb33,ahb34,",
#                   "ahb35,ahb36"
# END IF
#
# IF g_aaz.aaz88 = 4 THEN
#    LET l_field  = "ahb31,ahb32,ahb33,ahb34,",
#                   "ahb35,ahb36"
# END IF
#
# IF g_aaz.aaz88 = 5 THEN
#    LET l_field  = "ahb32,ahb33,ahb34,",
#                   "ahb35,ahb36"
# END IF
#
# IF g_aaz.aaz88 = 6 THEN
#    LET l_field  = "ahb33,ahb34,ahb35,ahb36"
# END IF
#
# IF g_aaz.aaz88 = 7 THEN
#    LET l_field  = "ahb34,ahb35,ahb36"
# END IF
#
# IF g_aaz.aaz88 = 8 THEN
#    LET l_field  = "ahb35,ahb36"
# END IF
#
# IF g_aaz.aaz88 = 9 THEN
#    LET l_field  = "ahb36"
# END IF
#FUN-B50105   ---end     Mark
#FUN-B50105   ---start   Add
   IF g_aaz.aaz88 = 0 THEN
      LET l_field = "ahb11,ahb12,ahb13,ahb14"
   END IF
   IF g_aaz.aaz88 = 1 THEN
      LET l_field = "ahb12,ahb13,ahb14"
   END IF
   IF g_aaz.aaz88 = 2 THEN
      LET l_field = "ahb13,ahb14"
   END IF
   IF g_aaz.aaz88 = 3 THEN
      LET l_field = "ahb14"
   END IF
   IF g_aaz.aaz88 = 4 THEN
      LET l_field = ""
   END IF
   IF NOT cl_null(l_field) THEN lET l_field = l_field,"," END IF
   IF g_aaz.aaz125 = 5 THEN
      LET l_field = l_field,"ahb32,ahb33,ahb34,ahb35,ahb36"
   END IF
   IF g_aaz.aaz125 = 6 THEN
      LET l_field = l_field,"ahb33,ahb34,ahb35,ahb36"
   END IF
   IF g_aaz.aaz125 = 7 THEN
      LET l_field = l_field,"ahb34,ahb35,ahb36"
   END IF
   IF g_aaz.aaz125 = 8 THEN
      LET l_field = l_field,"ahb35,ahb36"
   END IF
#FUN-B50105   ---end     Add 

  CALL cl_set_comp_visible(l_field,FALSE)
  CALL cl_set_comp_visible("ahb08,ahb35,ahb36",g_aza.aza08 = 'Y')  #No.FUN-830139
 
END FUNCTION
 
FUNCTION i730_set_no_required()
   CALL cl_set_comp_required("ahb05,ahb08,ahb11,ahb12,ahb13,ahb14,ahb31,ahb32,ahb33,ahb34,ahb35,  #No.MOD-930170 add ahb05,ahb08
                         ahb36,ahb37",FALSE)
END FUNCTION
 
FUNCTION i730_set_required(l_aag151,l_aag161,l_aag171,l_aag181,
                          l_aag311,l_aag321,l_aag331,l_aag341,
                          l_aag351,l_aag361,l_aag371)
DEFINE    l_aag151        LIKE aag_file.aag151,
          l_aag161        LIKE aag_file.aag161,
          l_aag171        LIKE aag_file.aag171,
          l_aag181        LIKE aag_file.aag181,
          l_aag311        LIKE aag_file.aag311,
          l_aag321        LIKE aag_file.aag321,
          l_aag331        LIKE aag_file.aag331,
          l_aag341        LIKE aag_file.aag341,
          l_aag351        LIKE aag_file.aag351,
          l_aag361        LIKE aag_file.aag361,
          l_aag371        LIKE aag_file.aag371
DEFINE    l_aag21         LIKE aag_file.aag21    #No.MOD-930170
DEFINE    l_aag23         LIKE aag_file.aag23    #No.MOD-930170
DEFINE    l_aag05         LIKE aag_file.aag05    #No.MOD-930170
 
   LET l_aag151=NULL LET l_aag161=NULL LET l_aag171=NULL
   LET l_aag181=NULL LET l_aag311=NULL LET l_aag321=NULL
   LET l_aag331=NULL LET l_aag341=NULL LET l_aag351=NULL
   LET l_aag361=NULL LET l_aag371=NULL LET l_aag05 =NULL
   SELECT aag151,aag161,aag171,aag181,aag05,
          aag311,aag321,aag331,aag341,aag351,aag361,aag371,
          aag21,aag23   
     INTO l_aag151,l_aag161,l_aag171,l_aag181,l_aag05,
          l_aag311,l_aag321,l_aag331,
          l_aag341,l_aag351,l_aag361,l_aag371,
          l_aag21,l_aag23   
     FROM aag_file
    WHERE aag01 = g_ahb[l_ac].ahb03
      AND aag00 = g_aha.aha00   
   IF l_aag05 = 'Y' THEN
      CALL cl_set_comp_required("ahb05",TRUE)
   END IF
   IF l_aag21 = 'Y' THEN 
      CALL cl_set_comp_required("ahb36",TRUE)
   END IF
   IF l_aag23 = 'Y' THEN 
      CALL cl_set_comp_required("ahb08,ahb35",TRUE)
   END IF
   IF l_aag151 MATCHES '[23]' THEN
      CALL cl_set_comp_required("ahb11",TRUE)
   END IF
   IF l_aag161 MATCHES '[23]' THEN
      CALL cl_set_comp_required("ahb12",TRUE)
   END IF
   IF l_aag171 MATCHES '[23]' THEN
      CALL cl_set_comp_required("ahb13",TRUE)
   END IF
   IF l_aag181 MATCHES '[23]' THEN
      CALL cl_set_comp_required("ahb14",TRUE)
   END IF
   IF l_aag311 MATCHES '[23]' THEN
      CALL cl_set_comp_required("ahb31",TRUE)
   END IF
   IF l_aag321 MATCHES '[23]' THEN
      CALL cl_set_comp_required("ahb32",TRUE)
   END IF
   IF l_aag331 MATCHES '[23]' THEN
      CALL cl_set_comp_required("ahb33",TRUE)
   END IF
   IF l_aag341 MATCHES '[23]' THEN
      CALL cl_set_comp_required("ahb34",TRUE)
   END IF
   IF l_aag371 MATCHES '[23]' THEN
      CALL cl_set_comp_required("ahb37",TRUE)
   END IF
END FUNCTION
 
FUNCTION i730_show_ahe02(p_code)
DEFINE p_code  LIKE aag_file.aag15,
      l_str    LIKE ze_file.ze03,      #No.FUN-680098 VARCHAR(20)
      l_ahe02  LIKE ahe_file.ahe02
 
  SELECT ahe02 INTO l_ahe02 FROM ahe_file WHERE ahe01 = p_code
 
  #-->顯示狀況
  IF p_code IS NOT NULL AND p_code != ' ' THEN
     CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
     LET l_str = l_str CLIPPED,l_ahe02,'!'
     ERROR l_str
  END IF
END FUNCTION

FUNCTION i730_chk_ahb35()
DEFINE l_pjbacti  LIKE pjb_file.pjbacti
DEFINE l_n        LIKE type_file.num5
DEFINE l_pjb09    LIKE pjb_file.pjb09      #No.FUN-850027 
DEFINE l_pjb11    LIKE pjb_file.pjb11      #No.FUN-850027
 
   LET g_errno = ' '
   SELECT COUNT(*)  
     INTO l_n
     FROM pjb_file
    WHERE pjb01 = g_ahb[l_ac].ahb08
      AND pjb02 = g_ahb[l_ac].ahb35
      AND pjb25 = 'N'
   SELECT pjb09,pjb11,pjbacti              #No.FUN-850027 add pjb09,pjb11
     INTO l_pjb09,l_pjb11,l_pjbacti        #No.FUN-850027
     FROM pjb_file
    WHERE pjb01 = g_ahb[l_ac].ahb08
      AND pjb02 = g_ahb[l_ac].ahb35
      AND pjb25 = 'N'
   CASE WHEN l_n <= 0      LET g_errno = 'abg-501'  
        WHEN l_pjb09 !='Y' LET g_errno = 'apj-090'    #No.FUN-850027
        WHEN l_pjb11 !='Y' LET g_errno = 'apj-090'    #No.FUN-850027
        WHEN l_pjbacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
END FUNCTION
FUNCTION i730_chk_ahb36()
DEFINE l_azfacti  LIKE azf_file.azfacti
DEFINE l_n        LIKE type_file.num5
DEFINE l_azf09  LIKE azf_file.azf09
 
   LET g_errno = ' '
   SELECT COUNT(*)  
     INTO l_n
     FROM azf_file
    WHERE azf01 = g_ahb[l_ac].ahb36
      AND azf02 = '2'
   SELECT azfacti,azf09      #No.FUN-930104
     INTO l_azfacti,l_azf09  #No.FUN-930104
     FROM azf_file
    WHERE azf01 = g_ahb[l_ac].ahb36
      AND azf02 = '2'
   CASE WHEN l_n <= 0      LET g_errno = 'abg-502'  
        WHEN l_azfacti='N' LET g_errno = '9028'
        WHEN l_azf09 !='7' LET g_errno = 'aoo-406' #No.FUN-950077         
        OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i730_aha07(p_cmd,p_aha07)
  DEFINE p_cmd     LIKE type_file.chr1
  DEFINE p_aha07   LIKE aha_file.aha07
  DEFINE l_aacacti LIKE aac_file.aacacti
  DEFINE l_aac03   LIKE aac_file.aac03
  DEFINE l_aac11   LIKE aac_file.aac11
 
    LET g_errno = ' '
    SELECT aac03,aacacti,aac11 INTO l_aac03,l_aacacti,l_aac11
      FROM aac_file
     WHERE aac01=p_aha07
    CASE
        WHEN l_aacacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'mfg0014'
        WHEN l_aac11 <> '1'  LET g_errno = 'agl-901'
        WHEN l_aac03 <> '0'  LET g_errno = 'agl-138'        #MOD-9C0359 add
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
	END CASE
END FUNCTION
#No.FUN-9C0072 精簡程式碼 

