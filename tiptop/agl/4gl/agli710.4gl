# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli710.4gl
# Descriptions...: 常用傳票維護作業
# Date & Author..: 92/04/14 BY MAY
#                  By Melody    aab_file->gem_file
#                  By Melody    q_aac 改為不區分帳別
#                  By Melody    四組異動碼加入欄位控制
# Modify.........: No.MOD-490231 04/09/13 By Yuna 按action "建立簽核等級資料" 有錯誤,無法執行
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
# Modify.........: No.MOD-4C0171 05/02/15 By Smapmin 接收參數時,第一個必為帳別,若第一個不是帳別,則加入Null
# Modify.........: No.FUN-510007 05/03/03 By Smapmin 放寬金額欄位
# Modify.........: No.FUN-550028 05/05/16 By Will 單據編號放大
# Modify.........: NO.TQC-5B0155 05/11/25 BY yiting 在_a()段之 CALL i710_b()之前,應LET g_rec_b = 0
# Modify.........: No.FUN-5C0015 060102 BY GILL 新增異動碼5-10、關係人異動碼
# Modify.........: No.FUN-5C0015 06/02/14 BY GILL 用s_ahe_qry取代q_aee
# Modify.........: No.TQC-620028 06/02/22 By Smapmin 有做部門管理的科目才需CALL s_chkdept
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-650044 06/05/15 By Echo 憑證類的報表因報表寬度(p_zz)為0或NULL,導致報表當掉
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730070 07/04/03 By Carrier 會計科目加帳套-財務
# Modify.........: No.MOD-740297 07/04/26 By Carrier 單身復制時,和科目相關字段的合理性
# Modify.........: No.TQC-750022 07/05/09 By Lynn 打印時,"FROM:"位置在報表名之上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810045 08/03/31 By rainy 專案管理,專案table gja_file->pja_file
# Modify.........: No.FUN-830139 08/03/31 By bnlent 1、去掉預算編號字段 2、agli601 ->aglt600 3、管控ahb35,ahb36
# Modify.........: No.FUN-830092 08/04/11 By sherry 報表改由CR輸出 
# Modify.........: No.FUN-850038 08/05/13 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-850027 08/05/29 By douzh WBS編碼錄入時要求時尾階并且為成本對象的WBS編碼
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.MOD-8C0257 08/12/25 By chenl   復制時對aha04欄位清空。
# Modify.........: No.MOD-910003 09/01/05 By Nicola AFTER ROW不可使用NEXT FILED
# Modify.........: No.MOD-930170 09/03/16 By chenl  若科目勾選項目管理后,需對項目編號和wbs編號進行輸入.若勾選預算管理,則需輸入預算編號.
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.FUN-950077 09/05/22 By dongbg 預算項目統一為費用原因/預算項目 
# Modify.........: No.TQC-960236 09/06/19 By xiaofeizhu 當資料有效碼(nmyacti)='N'時，不可刪除該筆資料
# Modify.........: No.FUN-980003 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980240 09/08/25 By xiaofeizhu 分攤類型欄位錄入的狀態下開窗需加上“acaacti='N'”
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/09 By chenmoyan 增加"專案未結案"的判斷
# Modify.........: No.MOD-9C0235 09/12/19 By Carrier aha07开窗和检查的aac11均为'1'
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AGL
# Modify.........: No.MOD-A40101 10/08/03 By sabrina 傳票單別要可輸入"應計傳票" 
# Modify.........: No.TQC-AC0403 10/12/31 By zhangweib CALL s_check_no 傳入的參數有問題
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No:FUN-B50105 11/05/23 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bookno         LIKE aaa_file.aaa01,
    g_aha000         LIKE aha_file.aha000,
    g_aha           RECORD LIKE aha_file.*,       #傳票編號 (假單頭)
    g_aha_t         RECORD LIKE aha_file.*,       #傳票編號 (舊值)
    g_aha_o         RECORD LIKE aha_file.*,       #傳票編號 (舊值)
    g_aha01_t       LIKE aha_file.aha01,   #
    g_aha00_t       LIKE aha_file.aha00,   #
    g_tail          LIKE type_file.num10,   #rowid為更新項次之用  #No.FUN-680098   INTEGER
    g_aaa           RECORD LIKE aaa_file.*,
    g_ahb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variagles)
        ahb02       LIKE ahb_file.ahb02,   #項次
        ahb03       LIKE ahb_file.ahb03,   #科目編號
        aag02       LIKE aag_file.aag02,   #科目名稱
        ahb05       LIKE ahb_file.ahb05,   #部門
        ahb06       LIKE ahb_file.ahb06,   #借貸別
        ahb07       LIKE ahb_file.ahb07,   #異動金額
        ahb08       LIKE ahb_file.ahb08,   #專案號碼
        ahb35       LIKE ahb_file.ahb35,   #異動碼9    #No.FUN-830139 WBS編碼
        ahb36       LIKE ahb_file.ahb36,   #異動碼10   #No.FUN-830139 預算項目
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
        ahb07       LIKE ahb_file.ahb07,   #異動金額
        ahb08       LIKE ahb_file.ahb08,   #專案號碼
        ahb35       LIKE ahb_file.ahb35,   #異動碼9    #No.FUN-830139 WBS編碼
        ahb36       LIKE ahb_file.ahb36,   #異動碼10   #No.FUN-830139 預算項目
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
    g_sql_tmp           STRING,        #No.FUN-730070
    g_aaa03             LIKE aaa_file.aaa03,  #No.FUN-730070
    g_t1            LIKE oay_file.oayslip,              #No.FUN-550028        #No.FUN-680098 VARCHAR(5)
    g_statu         LIKE  type_file.chr1,                                     #No.FUN-680098  VARCHAR(1)
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680098 SMALLINT
    g_cmd           LIKE type_file.chr1000,             #No.FUN-680098 VARCHAR(200)
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680098 SMALLINT
    l_str1          LIKE ahb_file.ahb03                 #No.FUN-680098 VARCHAR(20)
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680098 SMALLILNT
DEFINE g_chr              LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
DEFINE g_cnt              LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_i                LIKE type_file.num5          #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE g_msg              LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE g_row_count        LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_curs_index       LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_jump             LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_no_ask        LIKE type_file.num5          #No.FUN-680098 SMALLINT
DEFINE g_str           STRING                                                 
DEFINE l_sql           STRING                                                 
DEFINE l_table         STRING                                                 
DEFINE g_depno         LIKE type_file.chr20  
 
MAIN
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
 
   LET g_sql = "aha00.aha_file.aha00,",                                         
               "aha01.aha_file.aha01,",                                         
               "aha02.aha_file.aha02,",                                         
               "aha03.aha_file.aha03,",                                         
               "aha05.aha_file.aha05,",                                         
               "aha04.aha_file.aha04,",                                         
               "aha06.aha_file.aha06,",                                         
               "aha14.aha_file.aha14,",                                         
               "aha11.aha_file.aha11,",                                         
               "ahamksg.aha_file.ahamksg,",                                     
               "aha12.aha_file.aha12,",                                         
               "ahasign.aha_file.ahasign,",                                     
               "ahb02.ahb_file.ahb02,",                                         
               "ahb03.ahb_file.ahb03,",                                         
               "ahb04.ahb_file.ahb04,",                                         
               "ahb05.ahb_file.ahb05,",                                         
               "ahb06.ahb_file.ahb06,",                                         
               "ahb07.ahb_file.ahb07,",                                         
               "ahb08.ahb_file.ahb08,",                                         
               "ahb37.ahb_file.ahb37,",                                         
               "azi04.azi_file.azi04,",                                         
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
                                                                                
   LET l_table = cl_prt_temptable('agli710',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",          
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?) "                            
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_forupd_sql = "SELECT * FROM aha_file WHERE aha00 = ? AND aha01 = ? AND aha000 = '1' FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i710_cl CURSOR FROM g_forupd_sql
 
   LET g_aha000 = '1'

   OPEN WINDOW i710_w WITH FORM "agl/42f/agli710"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   LET l_str1 = g_depno CLIPPED,'*' CLIPPED
 
   CALL i710_show_field()  #FUN-5C0015 BY GILL
 
   CALL i710_menu()
   CLOSE WINDOW i710_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 


FUNCTION i710_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
      CALL g_ahb.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_aha.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
        aha00,aha01,aha02,aha03,aha05,aha06,aha04,aha14,aha07,  #No.FUN-730070
        ahamksg,ahasign,ahauser,ahagrup,ahamodu,ahadate,ahaacti,
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
             CALL i710_aha02('d')
             NEXT FIELD aha02
          WHEN INFIELD(aha07) #單據性質
             CALL q_aac(TRUE,TRUE,g_aha.aha07,'1','0',' ','AGL')  #TQC-670008
             RETURNING g_aha.aha07
             DISPLAY g_aha.aha07 TO aha07
          WHEN INFIELD (ahasign)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_azc"
             LET g_qryparam.arg1 = 7
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahasign
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
 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond("ahauser", "ahagrup")
 
    CONSTRUCT g_wc2 ON ahb02,ahb03,ahb05,ahb06,ahb07,#ahb15,      #No.FUN-830139
                       ahb08,ahb35,ahb36,ahb11,ahb12,ahb13,ahb14, #No.FUN-830139
 
                       ahb31,ahb32,ahb33,ahb34,ahb37,   #No.FUN-830139 移動ahb35,ahb36 
 
                       ahb04 # 螢幕上取單身條件
                       ,ahbud01,ahbud02,ahbud03,ahbud04,ahbud05
                       ,ahbud06,ahbud07,ahbud08,ahbud09,ahbud10
                       ,ahbud11,ahbud12,ahbud13,ahbud14,ahbud15
            FROM s_ahb[1].ahb02,s_ahb[1].ahb03,
                 s_ahb[1].ahb05,s_ahb[1].ahb06,s_ahb[1].ahb07,#s_ahb[1].ahb15, #No.FUN-830139
                 s_ahb[1].ahb08,s_ahb[1].ahb35,s_ahb[1].ahb36,#No.FUN-830139
                 s_ahb[1].ahb11,s_ahb[1].ahb12,
                 s_ahb[1].ahb13,s_ahb[1].ahb14,
 
                 s_ahb[1].ahb31,s_ahb[1].ahb32,s_ahb[1].ahb33,s_ahb[1].ahb34,
                 s_ahb[1].ahb37,                                #No.FUN-830139
 
                 s_ahb[1].ahb04
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
             LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2'"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb03
          WHEN INFIELD(ahb04)     #查詢常用摘要
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
           WHEN INFIELD(ahb11)    #查詢異動碼-1
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_ahb[1].ahb03
             LET g_qryparam.arg2 = 1
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb11
          WHEN INFIELD(ahb12)    #查詢異動碼-2
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_ahb[1].ahb03
             LET g_qryparam.arg2 = 2
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb12
          WHEN INFIELD(ahb13)    #查詢異動碼-3
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_ahb[1].ahb03
             LET g_qryparam.arg2 = 3
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb13
          WHEN INFIELD(ahb14)    #查詢異動碼-4
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
             LET g_qryparam.form ="q_pjb"          #No.FUN-830139 q_aee -> q_pjb
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ahb35
          WHEN INFIELD(ahb36)    #查詢異動碼-10
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_azf01a"#No.FUN-930104   
             LET g_qryparam.arg1 = '7'      #No.FUN-950077
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
 
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" AND (g_depno IS NULL OR g_depno=' ') THEN#若單身未輸入條件
       LET g_sql = "SELECT  aha01,aha00 ",
                   " FROM aha_file",
                   " WHERE ", g_wc CLIPPED,
                   " AND aha000= '1'"  #固定金額
     ELSE                    # 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT aha_file. aha01,aha00 ",
                   "  FROM aha_file, ahb_file ",
                   " WHERE aha01 = ahb01",
                   " AND aha000= '1'",  #固定金額
                   " AND ahb000= '1'",  #固定金額
                   " AND aha00 = ahb00 ",
                   " AND ahb02 !=0 ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
    END IF
    IF g_depno IS NOT NULL OR g_depno != ' ' THEN  #若部門別有輸入條件
       LET g_sql = g_sql CLIPPED," AND ahb03 MATCHES '",l_str1,"' "
    END IF
    LET g_sql = g_sql CLIPPED," ORDER BY aha00,aha01 "  #No.FUN-730070
 
    PREPARE i710_prepare FROM g_sql
    DECLARE i710_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i710_prepare
 
    IF g_wc2 = " 1=1" AND (g_depno IS NULL OR g_depno = ' ') THEN#取合乎條件筆數
        LET g_sql="SELECT DISTINCT aha00,aha01 FROM aha_file WHERE ",
                   g_wc CLIPPED," AND aha000 = '1' "
    ELSE
        LET g_sql="SELECT DISTINCT aha00,aha01 FROM aha_file,ahb_file WHERE ",
                  " ahb01=aha01 AND aha00 = ahb00 ",
                  " AND aha000 = '1' AND ahb000 = '1' AND ",
                  g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    IF g_depno IS NOT NULL OR g_depno != ' ' THEN  #若部門別有輸入條件
       LET g_sql = g_sql CLIPPED," AND ahb03 MATCHES '",l_str1,"' "
    END IF
    LET g_sql_tmp = g_sql CLIPPED,"  INTO TEMP x"
    DROP TABLE x
    PREPARE i710_pre_x FROM g_sql_tmp
    EXECUTE i710_pre_x
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i710_precount FROM g_sql
    DECLARE i710_count CURSOR FOR i710_precount
END FUNCTION
 
FUNCTION i710_menu()
 
   WHILE TRUE
      CALL i710_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i710_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i710_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i710_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i710_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i710_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i710_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i710_b(' ')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i710_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "other_memo"
            IF cl_chk_act_auth() THEN
               IF g_aha.aha01 IS NOT NULL AND g_aha.aha01 != ' ' THEN
                  LET g_cmd =
                        "agli701 '",g_aha.aha00,"' '",g_aha.aha01,"' '",
                         g_aha.aha000,"' 0 "
                  CALL cl_cmdrun(g_cmd CLIPPED)
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
FUNCTION i710_a()
DEFINE   l_str     LIKE type_file.chr20,        #No.FUN-680098  VARCHAR(17)
         li_result LIKE type_file.num5          #No.FUN-680098  SMALLINT
   IF s_aglshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
      CALL g_ahb.clear()
   INITIALIZE g_aha.* LIKE aha_file.*             #DEFAULT 設定
   LET g_aha01_t = NULL
   LET g_aha00_t = NULL
   LET g_aha.aha000 = g_aha000
   LET g_aha_o.* = g_aha.*
   LET g_aha.aha05 = g_today
   LET g_aha.aha06 = g_today
   LET g_aha.ahamksg = 'N'
   LET g_aha.aha11 = 0
   LET g_aha.aha12 = 0
   LET g_aha.ahalegal = g_legal #FUN-980003 add
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_aha.ahauser=g_user
      LET g_aha.ahaoriu = g_user #FUN-980030
      LET g_aha.ahaorig = g_grup #FUN-980030
      LET g_aha.ahagrup=g_grup
      LET g_aha.ahadate=g_today
      LET g_aha.ahaacti='Y'              #資料有效
      CALL i710_i("a")                #輸入單頭
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
 
      INSERT INTO aha_file VALUES (g_aha.*)
      IF SQLCA.sqlcode THEN               #置入資料庫不成功
         CALL cl_err3("ins","aha_file",g_aha.aha01,g_aha.aha00,SQLCA.sqlcode,"","",1)  #No.FUN-660123
         CONTINUE WHILE
      END IF
      SELECT aha00 INTO g_aha.aha00 FROM aha_file
       WHERE aha01 = g_aha.aha01
         AND aha00 = g_aha.aha00  #No.FUN-730070
         AND aha000 = '1'         #No.FUN-730070
      LET g_aha01_t = g_aha.aha01        #保留舊值
      LET g_aha00_t = g_aha.aha00        #保留舊值  #No.FUN-730070
      LET g_aha_t.* = g_aha.*
      CALL g_ahb.clear()
      LET g_rec_b = 0                    #NO.TQC-5B0155
      CALL i710_b('a')                   #輸入單身
 
      CALL cl_getmsg('agl-042',g_lang) RETURNING l_str
            LET INT_FLAG = 0  ######add for prompt bug
 
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i710_u()
   IF s_aglshut(0) THEN RETURN END IF
   IF g_aha.aha01 IS NULL OR g_aha.aha00 IS NULL THEN  #No.FUN-730070
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
   LET g_aha00_t = g_aha.aha00  #No.FUN-730070
   LET g_aha_o.* = g_aha.*
   BEGIN WORK
 
   OPEN i710_cl USING g_aha.aha00,g_aha.aha01
   IF STATUS THEN
      CALL cl_err("OPEN i710_cl:", STATUS, 1)
      CLOSE i710_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i710_cl INTO g_aha.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aha.aha01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i710_cl ROLLBACK WORK RETURN
   END IF
   CALL i710_show()
   WHILE TRUE
      LET g_aha01_t = g_aha.aha01
      LET g_aha00_t = g_aha.aha00  #No.FUN-730070
      LET g_aha.ahamodu=g_user
      LET g_aha.ahadate=g_today
      CALL i710_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_aha.*=g_aha_t.*
         CALL i710_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_aha.aha01 != g_aha01_t OR g_aha.aha00 != g_aha00_t THEN            # 更改單號  #No.FUN-730070
         UPDATE ahb_file SET ahb01 = g_aha.aha01,
                             ahb00 = g_aha.aha00  #No.FUN-730070
          WHERE ahb01 = g_aha01_t AND ahb00 = g_aha00_t AND ahb000 = '1'  #No.FUN-730070
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ahb_file",g_aha01_t,g_aha00_t,SQLCA.sqlcode,"","ahb",1)  #No.FUN-660123  #No.FUN-730070
            CONTINUE WHILE
         END IF
      END IF
      UPDATE aha_file SET aha_file.* = g_aha.*
       WHERE aha00 = g_aha.aha00 AND aha01 = g_aha.aha01 AND aha000 = '1'
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","aha_file",g_aha01_t,g_aha00_t,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730070
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i710_cl
   COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i710_i(p_cmd)
DEFINE
   l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入        #No.FUN-680098 VARCHAR(1)
   l_aca02         LIKE azn_file.azn02,
   l_azn04         LIKE azn_file.azn04,
   l_aag07         LIKE aag_file.aag07,
   l_direct        LIKE type_file.chr1,         #No.FUN-680098  VARCHAR(1)
   p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改        #No.FUN-680098 VARCHAR(1)
   l_aac11         STRING,                      #MOD-A40101 add
   li_result       LIKE type_file.num5          #No.FUN-680098  SMALLINT
 
   DISPLAY BY NAME g_aha.aha05,g_aha.aha06,g_aha.aha11,g_aha.aha12
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0029
 
   INPUT BY NAME g_aha.ahaoriu,g_aha.ahaorig,
       g_aha.aha00,   #No.FUN-730070
       g_aha.aha01,g_aha.aha02,g_aha.aha03,g_aha.aha05,g_aha.aha06,
       g_aha.aha14,g_aha.aha07,g_aha.aha04,
       g_aha.ahamksg,g_aha.ahasign,g_aha.ahauser,
       g_aha.ahagrup,g_aha.ahamodu,g_aha.ahadate,g_aha.ahaacti,
       g_aha.ahaud01,g_aha.ahaud02,g_aha.ahaud03,g_aha.ahaud04,
       g_aha.ahaud05,g_aha.ahaud06,g_aha.ahaud07,g_aha.ahaud08,
       g_aha.ahaud09,g_aha.ahaud10,g_aha.ahaud11,g_aha.ahaud12,
       g_aha.ahaud13,g_aha.ahaud14,g_aha.ahaud15 
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i710_set_entry(p_cmd)
         CALL i710_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("aha14")
 
        AFTER FIELD aha00
            IF NOT cl_null(g_aha.aha00) THEN
               CALL i710_aha00('a',g_aha.aha00)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aha.aha00,g_errno,0)
                  LET g_aha.aha00 = g_aha_t.aha00
                  DISPLAY BY NAME g_aha.aha00
                  NEXT FIELD aha00
               END IF
            END IF
 
      #CHECK 單據性質,DEFAULT來源碼及傳票編號
       AFTER FIELD aha01
          IF NOT cl_null(g_aha.aha01) THEN
             IF p_cmd = 'a' OR p_cmd = 'u' AND
               (g_aha.aha01 != g_aha01_t OR g_aha.aha00 != g_aha00_t) THEN
                SELECT count(*) INTO g_cnt FROM aha_file
                 WHERE aha01 = g_aha.aha01
                   AND aha00 = g_aha.aha00
                   AND aha000 = '1' #固定金額
                IF g_cnt > 0 THEN   #資料重複
                   CALL cl_err(g_aha.aha01,-239,0)
                   LET g_aha.aha01 = g_aha01_t
                   LET g_aha.aha00 = g_aha00_t
                   DISPLAY BY NAME g_aha.aha01
                   NEXT FIELD aha01
                END IF
             END IF
          END IF
 
       AFTER FIELD aha02
          IF NOT cl_null(g_aha.aha02) THEN
             CALL i710_aha02('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD aha02
             END IF
          END IF
          LET g_aha_o.aha02 = g_aha.aha02
 
       AFTER FIELD aha03
          IF NOT cl_null(g_aha.aha03) THEN
             LET g_aha_o.aha03 = g_aha.aha03
          END IF
 
       AFTER FIELD aha05
          IF NOT cl_null(g_aha.aha05) THEN
             LET g_aha_o.aha03 = g_aha.aha03
          END IF
 
       AFTER FIELD aha06
          IF NOT cl_null(g_aha.aha06) THEN
             IF g_aha.aha06 < g_aha.aha05 THEN
                CALL cl_err('','agl-157',0)
                NEXT FIELD aha05
             END IF
             LET g_aha_o.aha03 = g_aha.aha03
             CALL i710_aha06()
          END IF
 
       AFTER FIELD aha07
          IF NOT cl_null(g_aha.aha07) THEN
               CALL i710_aha07('a',g_aha.aha07)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aha.aha07,g_errno,0)
                  LET g_aha.aha07 = g_aha_t.aha07
                  DISPLAY BY NAME g_aha.aha07
                  NEXT FIELD aha07
               END IF
              LET g_t1=g_aha.aha07[1,g_doc_len]
#            CALL s_check_no(g_sys,g_t1,"","","","","")
#            CALL s_check_no("agl",g_t1,"","","","","")   #No.FUN-A40041     #No.TQC-AC0403
             CALL s_check_no("agl",g_aha.aha07,g_aha_t.aha07,"*","aha_file", "aha07","")     #No.TQC-AC0403
             RETURNING li_result,g_aha.aha07
             LET g_aha.aha07 = s_get_doc_no(g_aha.aha07)
             DISPLAY BY NAME g_aha.aha07
             IF(NOT li_result) THEN
               NEXT FIELD aha07
             END IF
             LET g_aha_o.aha07 = g_aha.aha07
          END IF
 
       AFTER FIELD ahamksg
         CALL i710_set_entry(p_cmd)
 
       AFTER FIELD ahasign
          IF g_aha.ahamksg MATCHES '[Yy]' THEN
             IF cl_null(g_aha.ahasign) THEN
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
          CALL i710_set_no_entry(p_cmd)
 
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
          IF l_flag='Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD aha00  #No.FUN-730070
          END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(aha00)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aaa"
                LET g_qryparam.default1 = g_aha.aha00
                CALL cl_create_qry() RETURNING g_aha.aha00
                DISPLAY BY NAME g_aha.aha00
                CALL i710_aha00('d',g_aha.aha00)
             WHEN INFIELD(aha02) #類別
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aca01"                     #TQC-980240 Add
                LET g_qryparam.default1 = g_aha.aha02
                CALL cl_create_qry() RETURNING g_aha.aha02
                DISPLAY  BY NAME g_aha.aha02
                CALL i710_aha02('d')
                NEXT FIELD aha02
             WHEN INFIELD(aha07) #單據性質
               #CALL q_aac(FALSE,TRUE,g_aha.aha07,'1','0',' ','AGL')   #TQC-670008  #MOD-A40101 mark
                LET l_aac11="1','3"                                        #MOD-A40101 add
                CALL q_aac(FALSE,TRUE,g_aha.aha07,l_aac11,'0',' ','AGL')   #MOD-A40101 add
                RETURNING g_aha.aha07
                DISPLAY BY NAME g_aha.aha07
             WHEN INFIELD (ahasign)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_azc"
                LET g_qryparam.default1 = g_aha.ahasign,7
                LET g_qryparam.arg1 = 7
                CALL cl_create_qry() RETURNING g_aha.ahasign
                DISPLAY  BY NAME g_aha.ahasign
             OTHERWISE EXIT CASE
          END CASE
 
       ON ACTION create_approval_level
           CALL cl_cmdrun('aooi020' CLIPPED)   #No.MOD-490231
 
       ON ACTION create_apportionment_category
          CALL cl_cmdrun('agli700' CLIPPED)
 
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
 
 
   END INPUT
END FUNCTION
 
FUNCTION i710_aha00(p_cmd,p_aha00)
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

FUNCTION  i710_aha02(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
   l_aca02         LIKE aca_file.aca02,
   l_acaacti       LIKE aca_file.acaacti
 
   LET g_errno = ' '
   SELECT aca02,aca03,acaacti
     INTO l_aca02,g_aha.aha03,l_acaacti
     FROM aca_file
    WHERE aca01 = g_aha.aha02
   CASE WHEN STATUS=100          LET g_errno = 'agl-090'  #No.7926
                           LET l_aca02 = NULL
        WHEN l_acaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_aca02 TO FORMONLY.aca02
   END IF
END FUNCTION
 
FUNCTION i710_aha06()
   DEFINE pon,y1,m1,y2,m2 LIKE type_file.num5     #No.FUN-680098  SMALLINT
 
   SELECT azn02,azn04 INTO y1,m1 FROM azn_file WHERE azn01=g_aha.aha05
   SELECT azn02,azn04 INTO y2,m2 FROM azn_file WHERE azn01=g_aha.aha06
   LET pon = (y2*(11+g_aza.aza02)+m2) - (y1*(11+g_aza.aza02)+m1) + 1
   DISPLAY BY NAME pon
END FUNCTION
 
#Query 查詢
FUNCTION i710_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_aha.* TO NULL              #No.FUN-6B0040
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_ahb.clear()
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i710_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i710_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_aha.* TO NULL
   ELSE
      OPEN i710_count
      FETCH i710_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i710_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i710_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
   l_agso          LIKE type_file.num10               #絕對的筆數        #No.FUN-680098 INTEGER
 
   CASE p_flag
       WHEN 'N' FETCH NEXT     i710_cs INTO g_aha.aha01,g_aha.aha00
       WHEN 'P' FETCH PREVIOUS i710_cs INTO g_aha.aha01,g_aha.aha00
       WHEN 'F' FETCH FIRST    i710_cs INTO g_aha.aha01,g_aha.aha00
       WHEN 'L' FETCH LAST     i710_cs INTO g_aha.aha01,g_aha.aha00
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
          FETCH ABSOLUTE g_jump i710_cs INTO g_aha.aha01,g_aha.aha00
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
   SELECT * INTO g_aha.* FROM aha_file WHERE aha00 = g_aha.aha00 AND aha01 = g_aha.aha01 AND aha000 = '1'
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aha_file",g_aha.aha01,g_aha.aha00,SQLCA.sqlcode,"","",1)  #No.FUN-660123
      INITIALIZE g_aha.* TO NULL
      RETURN
   ELSE
      LET g_data_owner = g_aha.ahauser     #No.FUN-4C0048
      LET g_data_group = g_aha.ahagrup     #No.FUN-4C0048
      CALL i710_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i710_show()
   LET g_aha_t.* = g_aha.*                #保存單頭舊值
   DISPLAY BY NAME g_aha.ahaoriu,g_aha.ahaorig,                        # 顯示單頭值
       g_aha.aha00,  #No.FUN-730070
       g_aha.aha01,g_aha.aha02,g_aha.aha03,
       g_aha.aha04,g_aha.aha05,g_aha.aha06,g_aha.aha14,g_aha.aha07,
       g_aha.aha11,g_aha.aha12,
       g_aha.ahamksg,g_aha.ahauser,g_aha.ahagrup,
       g_aha.ahamodu,g_aha.ahadate,g_aha.ahaacti,
       g_aha.ahaud01,g_aha.ahaud02,g_aha.ahaud03,g_aha.ahaud04,
       g_aha.ahaud05,g_aha.ahaud06,g_aha.ahaud07,g_aha.ahaud08,
       g_aha.ahaud09,g_aha.ahaud10,g_aha.ahaud11,g_aha.ahaud12,
       g_aha.ahaud13,g_aha.ahaud14,g_aha.ahaud15 
   CALL cl_set_field_pic("","","","","",g_aha.ahaacti)
   CALL i710_aha02('d')
   CALL i710_aha06()
   CALL i710_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i710_x()
   IF s_aglshut(0) THEN RETURN END IF
   IF g_aha.aha01 IS NULL OR g_aha.aha00 IS NULL THEN  #No.FUN-730070
      CALL cl_err("",-400,0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN i710_cl USING g_aha.aha00,g_aha.aha01
   IF STATUS THEN
      CALL cl_err("OPEN i710_cl:", STATUS, 1)
      CLOSE i710_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i710_cl INTO g_aha.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aha.aha01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i710_cl ROLLBACK WORK RETURN
   END IF
   CALL i710_show()
   IF cl_exp(0,0,g_aha.ahaacti) THEN                   #確認一下
      LET g_chr=g_aha.ahaacti
      IF g_aha.ahaacti='Y' THEN
         LET g_aha.ahaacti='N'
      ELSE
         LET g_aha.ahaacti='Y'
      END IF
      UPDATE aha_file                    #更改有效碼
         SET ahaacti=g_aha.ahaacti
       WHERE aha01=g_aha.aha01 AND aha00 = g_aha.aha00
         AND aha000 = '1'   #No.FUN-730070
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","aha_file",g_aha.aha01,g_aha.aha00,SQLCA.sqlcode,"","",1)  #No.FUN-660123
         LET g_aha.ahaacti=g_chr
      END IF
      DISPLAY BY NAME g_aha.ahaacti
   END IF
   CLOSE i710_cl
   COMMIT WORK
   CALL cl_set_field_pic("","","","","",g_aha.ahaacti)
 
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i710_r()
   IF s_aglshut(0) THEN RETURN END IF
   IF g_aha.aha01 IS NULL OR g_aha.aha00 IS NULL THEN  #No.FUN-730070
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_aha.ahaacti = 'N' THEN CALL cl_err('','abm-950',0) RETURN END IF             #TQC-960236
   BEGIN WORK
 
   OPEN i710_cl USING g_aha.aha00,g_aha.aha01
   IF STATUS THEN
      CALL cl_err("OPEN i710_cl:", STATUS, 1)
      CLOSE i710_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i710_cl INTO g_aha.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aha.aha01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i710_cl ROLLBACK WORK RETURN
   END IF
   CALL i710_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "aha00"          #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_aha.aha00       #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "aha000"         #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_aha.aha000      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "aha01"          #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_aha.aha01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM aha_file WHERE aha00 = g_aha.aha00 AND  #No.FUN-730070
                                 aha01 = g_aha.aha01 AND aha000 = '1'
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","aha_file",g_aha.aha00,g_aha.aha01,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730070
      ELSE
         CLEAR FORM
         CALL g_ahb.clear()
      END IF
      DELETE FROM ahb_file WHERE ahb00 = g_aha.aha00 AND  #No.FUN-730070
                                 ahb01 = g_aha.aha01 AND
                                 ahb000 = '1'
      CLEAR FORM
      CALL g_ahb.clear()
      CALL g_ahb.clear()
      DROP TABLE x
      PREPARE i010_pre_x2 FROM g_sql_tmp
      EXECUTE i010_pre_x2
      OPEN i710_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i710_cs
         CLOSE i710_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end-- 
      FETCH i710_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i710_cs
         CLOSE i710_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i710_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i710_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i710_fetch('/')
      END IF
   END IF
   CLOSE i710_cl
   COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i710_b(p_key)
DEFINE
    p_key           LIKE type_file.chr1,                                        #No.FUN-680098  VARCHAR(1)
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT      #No.FUN-680098  SMALLINT
    l_n,i           LIKE type_file.num5,                #檢查重複用             #No.FUN-680098  SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否             #No.FUN-680098  VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態               #No.FUN-680098  VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,                                       #No.FUN-680098  VARCHAR(100)
    l_direct        LIKE type_file.chr1,                #FTER                   #No.FUN-680098  VARCHAR(1)
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
    l_aha11         LIKE aha_file.aha11,
    l_aha12         LIKE aha_file.aha12,
    l_cnt           LIKE type_file.num5,          #No.FUN-680098  SMALLINT
    l_cnt1          LIKE type_file.num5,          #No.FUN-680098  SMALLINT
    l_ahb02         LIKE ahb_file.ahb02,
    l_check         LIKE ahb_file.ahb02, #為check AFTER FIELD ahb02時對項次的
    l_check_t       LIKE ahb_file.ahb02,#判斷是否跳過AFTER ROW的處理
    l_aag09         LIKE aag_file.aag09,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680098  SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680098  SMALLINT
 
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
    l_aag371        LIKE aag_file.aag371
 
    LET g_action_choice = ""
    IF s_aglshut(0) THEN RETURN END IF
    IF g_aha.aha01 IS NULL OR g_aha.aha00 IS NULL THEN  #No.FUN-730070
       RETURN
    END IF
    SELECT * INTO g_aha.* FROM aha_file WHERE aha000=g_aha.aha000
       AND aha00=g_aha.aha00 AND aha01=g_aha.aha01
    IF g_aha.ahaacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_aha.aha01,'aom-000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
    SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01=g_aha.aha00  #No.FUN-730070
    SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_aaa03      #幣別檔小數位數讀取          #CHI-6A0004  #No.FUN-730070
 
    LET g_forupd_sql = "SELECT ahb02,ahb03,' ',ahb05,ahb06,ahb07,ahb08,ahb35,ahb36,", #No.FUN-830139 去掉ahb15
                       "       ahb11,ahb12,ahb13,ahb14,",
 
                       "       ahb31,ahb32,ahb33,ahb34,ahb37,", #No.FUN-830139 移動ahb35,ahb36到ahb08后
 
                       "       ahb04,",
                       "       ahbud01,ahbud02,ahbud03,ahbud04,ahbud05,",
                       "       ahbud06,ahbud07,ahbud08,ahbud09,ahbud10,",
                       "       ahbud11,ahbud12,ahbud13,ahbud14,ahbud15 ", 
                       "  FROM ahb_file",
                       " WHERE ahb01 =? AND ahb00 =? AND ahb000= '1'",
                       "   AND ahb02 =? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i710_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ahb WITHOUT DEFAULTS FROM s_ahb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
           IF g_rec_b!=0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           OPEN i710_cl USING g_aha.aha00,g_aha.aha01
           IF STATUS THEN
              CALL cl_err("OPEN i710_cl:", STATUS, 1)
              CLOSE i710_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i710_cl INTO g_aha.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_aha.aha01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i710_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_ahb_t.* = g_ahb[l_ac].*  #BACKUP
               OPEN i710_bcl USING g_aha.aha01,g_aha.aha00,g_ahb_t.ahb02
               IF STATUS THEN
                  CALL cl_err("OPEN i710_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               END IF
               FETCH i710_bcl INTO g_ahb[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ahb_t.ahb02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
               CALL i710_set_entry_b()
               CALL i710_set_no_entry_b()
               CALL i710_set_no_required()
               CALL i710_set_required()
           END IF
           IF l_ac <= l_n then                   #DISPLAY NEWEST
              CALL i710_ahb03(' ')           #for referenced field
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ahb[l_ac].* TO NULL      #900423
           LET g_ahb_t.* = g_ahb[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD ahb02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO ahb_file(ahb00,ahb000,ahb01,ahb02,ahb03,
                                ahb04,ahb05,ahb06,ahb07,ahb08,
                                ahb11,ahb12,ahb13,ahb14,
                                ahb31,ahb32,ahb33,ahb34,
                                ahb35,ahb36,ahb37,
                                ahbud01,ahbud02,ahbud03,
                                ahbud04,ahbud05,ahbud06,
                                ahbud07,ahbud08,ahbud09,
                                ahbud10,ahbud11,ahbud12,
                                ahbud13,ahbud14,ahbud15,ahblegal #FUN-980003 add legal
                                )
                VALUES(g_aha.aha00,'1',g_aha.aha01,g_ahb[l_ac].ahb02,
                       g_ahb[l_ac].ahb03,g_ahb[l_ac].ahb04,
                       g_ahb[l_ac].ahb05,g_ahb[l_ac].ahb06,
                       g_ahb[l_ac].ahb07,g_ahb[l_ac].ahb08,
                       g_ahb[l_ac].ahb11,g_ahb[l_ac].ahb12,
                       g_ahb[l_ac].ahb13,g_ahb[l_ac].ahb14,
 
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
                       g_ahb[l_ac].ahbud15,g_legal #FUN-980003 add legal
                       )
 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ahb_file",g_aha.aha00,g_aha.aha01,SQLCA.sqlcode,"","",1)  #No.FUN-660123
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
           SELECT SUM(ahb07) INTO l_aha11 FROM ahb_file,aag_file
            WHERE ahb01 = g_aha.aha01
              AND ahb00 = g_aha.aha00
              AND ahb000= '1'
              AND ahb06 = '1'
              AND ahb03 = aag01
              AND ahb00 = aag00  #No.FUN-730070
              AND aag09 NOT IN ('N','n')
           IF l_aha11 IS NULL OR SQLCA.sqlcode THEN
              LET l_aha11 = 0
           END IF
           SELECT SUM(ahb07) INTO l_aha12 FROM ahb_file,aag_file
            WHERE ahb01 = g_aha.aha01
              AND ahb00 = g_aha.aha00
              AND ahb000= '1'
              AND ahb06 = '2'
              AND ahb03 = aag01
              AND ahb00 = aag00  #No.FUN-730070
              AND aag09 NOT IN ('N','n')
           IF l_aha12 IS NULL OR SQLCA.sqlcode THEN
              LET l_aha12 = 0
           END IF
           UPDATE aha_file SET aha11 = l_aha11,
                               aha12 = l_aha12
            WHERE aha01 = g_aha.aha01
              AND aha00 = g_aha.aha00
              AND aha000= '1'   #No.FUN-730070
           COMMIT WORK
           LET g_aha.aha11 = l_aha11
           LET g_aha.aha12 = l_aha12
           DISPLAY BY NAME g_aha.aha11,g_aha.aha12
 
        BEFORE FIELD ahb02                        #default 序號
           IF cl_null(g_ahb[l_ac].ahb02) OR g_ahb[l_ac].ahb02 = 0 THEN
              SELECT max(ahb02)+1
                INTO g_ahb[l_ac].ahb02
                FROM ahb_file
               WHERE ahb01 = g_aha.aha01
                 AND ahb00 = g_aha.aha00  #No.FUN-730070
                 AND ahb000= '1'
              IF g_ahb[l_ac].ahb02 IS NULL THEN
                 LET g_ahb[l_ac].ahb02 = 1
              END IF
           END IF
 
        AFTER FIELD ahb02                        #check 序號是否重複
           IF NOT cl_null(g_ahb[l_ac].ahb02) THEN
              IF g_ahb[l_ac].ahb02 != g_ahb_t.ahb02 OR g_ahb_t.ahb02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM ahb_file
                  WHERE ahb00 = g_aha.aha00
                    AND ahb000= '1'
                    AND ahb01 = g_aha.aha01
                    AND ahb02 = g_ahb[l_ac].ahb02
                 IF g_ahb[l_ac].ahb02 < l_check_t THEN #FOR (-U)
                    IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_ahb[l_ac].ahb02 = g_ahb_t.ahb02
                       NEXT FIELD ahb02
                    END IF
                 END IF
              END IF
           END IF
 
        BEFORE FIELD ahb03
           CALL i710_set_entry_b()
 
        AFTER FIELD ahb03
           IF NOT cl_null(g_ahb[l_ac].ahb03) THEN
              SELECT COUNT(*) INTO g_cnt
                  FROM ahb_file
                  WHERE ahb03=g_ahb[l_ac].ahb03 AND
                        ahb01=g_aha.aha01 AND
                        ahb00 = g_aha.aha00 AND
                        ahb000= '1'
              IF SQLCA.sqlcode OR g_cnt IS NULL THEN
                 LET g_cnt=0
              END IF
              CALL i710_ahb03('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                #Mod No.FUN-B10048
                #LET g_ahb[l_ac].ahb03=g_ahb_t.ahb03
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_ahb[l_ac].ahb03
                 LET g_qryparam.arg1 = g_aha.aha00  #No.FUN-730070
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
                                  AND aag00 = g_aha.aha00  #No.FUN-730070
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
           CALL i710_set_no_entry_b()
 
           CALL i710_set_no_required()
           CALL i710_set_required()
 
 
#科目為需有部門資料者才需建立此欄位
        AFTER FIELD ahb05
           IF NOT cl_null(g_ahb[l_ac].ahb05) THEN
              SELECT * FROM gem_file WHERE gem01 = g_ahb[l_ac].ahb05 AND
                                           gemacti IN ('y','Y') AND gem05='Y'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","gem_file",g_ahb[l_ac].ahb05,"","agl-003","","",1)  #No.FUN-660123
                 NEXT FIELD ahb05
              END IF
              SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_ahb[l_ac].ahb03
                  AND aag00 = g_aha.aha00  #No.FUN-730070
              IF l_aag05 = 'Y' THEN
                 CALL s_chkdept(g_aaz.aaz72,g_ahb[l_ac].ahb03,g_ahb[l_ac].ahb05,g_aha.aha00) RETURNING g_errno  #No.FUN-730070
                 IF not cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD  ahb05
                 END IF
              END IF   #TQC-620028
              LET l_direct = 'U'
           END IF
 
 
        AFTER FIELD ahb06
           IF NOT cl_null(g_ahb[l_ac].ahb06) THEN
              IF g_ahb[l_ac].ahb06 NOT MATCHES '[12]' THEN
                 NEXT FIELD ahb06
              END IF
              LET l_direct = 'U'
           END IF
 
        AFTER FIELD ahb07
           IF NOT cl_null(g_ahb[l_ac].ahb07) THEN
              IF g_ahb[l_ac].ahb07 <= 0 THEN
                 CALL cl_err(g_ahb[l_ac].ahb07,'agl-006',0)
                 LET g_ahb[l_ac].ahb07 = g_ahb_t.ahb07
                 DISPLAY BY NAME g_ahb[l_ac].ahb07
                 NEXT FIELD ahb07
              END IF
              LET g_ahb[l_ac].ahb07 = cl_numfor(g_ahb[l_ac].ahb07,15,t_azi04)        #CHI-6A0004
           END IF
 
        AFTER FIELD ahb08
           IF NOT cl_null(g_ahb[l_ac].ahb08) THEN
              SELECT * FROM pja_file WHERE pja01 = g_ahb[l_ac].ahb08 AND pjaacti = 'Y'  #FUN-810045
                                       AND pjaclose = 'N'                               #FUN-960038
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","pja_file",g_ahb[l_ac].ahb08,"","agl-007","","",1)  #No.FUN-660123  #FUN-810045 gja_file->pja_file
                 LET g_ahb[l_ac].ahb08 = g_ahb_t.ahb08
                 DISPLAY BY NAME g_ahb[l_ac].ahb08
                 NEXT FIELD ahb08
              END IF
           END IF
 
        BEFORE FIELD ahb11
          CALL i710_show_ahe02(l_aag15)
 
        AFTER FIELD ahb11
            CALL s_chk_aee(g_ahb[l_ac].ahb03,'1',g_ahb[l_ac].ahb11,g_aha.aha00)  #No.FUN-730070
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD ahb11
            END IF
 
        BEFORE FIELD ahb12
          CALL i710_show_ahe02(l_aag16)
 
        AFTER FIELD ahb12
            CALL s_chk_aee(g_ahb[l_ac].ahb03,'2',g_ahb[l_ac].ahb12,g_aha.aha00)  #No.FUN-730070
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
              NEXT FIELD ahb12
           END IF
 
        BEFORE FIELD ahb13
          CALL i710_show_ahe02(l_aag17)
 
        AFTER FIELD ahb13
            CALL s_chk_aee(g_ahb[l_ac].ahb03,'3',g_ahb[l_ac].ahb13,g_aha.aha00)  #No.FUN-730070
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
              NEXT FIELD ahb13
           END IF
 
        BEFORE FIELD ahb14
          CALL i710_show_ahe02(l_aag18)
 
        AFTER FIELD ahb14
            CALL s_chk_aee(g_ahb[l_ac].ahb03,'4',g_ahb[l_ac].ahb14,g_aha.aha00)  #No.FUN-730070
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
              NEXT FIELD ahb14
           END IF
 
        BEFORE FIELD ahb31
          CALL i710_show_ahe02(l_aag31)
 
        AFTER FIELD ahb31
           CALL s_chk_aee(g_ahb[l_ac].ahb03,'5',g_ahb[l_ac].ahb31,g_aha.aha00)  #No.FUN-730070
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
              NEXT FIELD ahb31
           END IF
 
        BEFORE FIELD ahb32
          CALL i710_show_ahe02(l_aag32)
 
        AFTER FIELD ahb32
           CALL s_chk_aee(g_ahb[l_ac].ahb03,'6',g_ahb[l_ac].ahb32,g_aha.aha00)  #No.FUN-730070
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
              NEXT FIELD ahb32
           END IF
 
        BEFORE FIELD ahb33
          CALL i710_show_ahe02(l_aag33)
 
        AFTER FIELD ahb33
           CALL s_chk_aee(g_ahb[l_ac].ahb03,'7',g_ahb[l_ac].ahb33,g_aha.aha00)  #No.FUN-730070
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
              NEXT FIELD ahb33
           END IF
 
        BEFORE FIELD ahb34
          CALL i710_show_ahe02(l_aag34)
 
        AFTER FIELD ahb34
           CALL s_chk_aee(g_ahb[l_ac].ahb03,'8',g_ahb[l_ac].ahb34,g_aha.aha00)  #No.FUN-730070
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
              NEXT FIELD ahb34
           END IF
 
        BEFORE FIELD ahb35
          CALL i710_show_ahe02(l_aag35)
 
        AFTER FIELD ahb35
           IF NOT cl_null(g_ahb[l_ac].ahb35) THEN
              CALL i710_chk_ahb35()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD ahb35
              END IF
           END IF
 
        BEFORE FIELD ahb36
          CALL i710_show_ahe02(l_aag36)
 
        AFTER FIELD ahb36
           IF NOT cl_null(g_ahb[l_ac].ahb36) THEN
              CALL i710_chk_ahb36()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD ahb36
              END IF
           END IF
 
        BEFORE FIELD ahb37
          CALL i710_show_ahe02(l_aag37)
 
        AFTER FIELD ahb37
           CALL s_chk_aee(g_ahb[l_ac].ahb03,'99',g_ahb[l_ac].ahb37,g_aha.aha00)  #No.FUN-730070
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
              NEXT FIELD ahb37
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
                    WHERE ahb00 = g_aha.aha00 AND  #No.FUN-730070
                          ahb000= '1' AND
                          ahb01 = g_aha.aha01 AND
                          ahb02 = g_ahb_t.ahb02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","ahb_file",g_aha.aha01,g_ahb_t.ahb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730070
                    ROLLBACK WORK
                    CANCEL DELETE
                ELSE
                    COMMIT WORK
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
 
#因為按<F2>刪除時會先走AFTER ROW 在走BEFORE  DELETE 所以不會將已
#DELETE的資料自單頭的借方金額或貸方金額減掉故在此在作一次加總和更新
 
 #*****特別處理:將單身之借方餘額及貸方餘額加總後UPDATE到單頭的
 #借方餘額、貸方餘額*********
            #若為非貨幣性科目則不作累計值
              SELECT SUM(ahb07) INTO l_aha11 FROM ahb_file,aag_file
                   WHERE ahb01 = g_aha.aha01 AND
                         ahb00 = g_aha.aha00 AND
                         ahb000= '1' AND
                         ahb06 = '1' AND   #No.MOD-910003
                         ahb03 = aag01 AND
                         ahb00 = aag00 AND   #No.FUN-730070
                         aag09 NOT IN ('N','n')
              IF SQLCA.sqlcode OR l_aha11 IS NULL THEN LET l_aha11 = 0 END IF
              SELECT SUM(ahb07) INTO l_aha12 FROM ahb_file,aag_file
                   WHERE ahb01 = g_aha.aha01 AND
                         ahb00 = g_aha.aha00 AND
                         ahb000= '1' AND
                         ahb06 = '2' AND   #No.MOD-910003
                         ahb03 = aag01 AND
                         ahb00 = aag00 AND   #No.FUN-730070
                         aag09 NOT IN ('N','n')
              IF SQLCA.sqlcode OR l_aha12 IS NULL THEN LET l_aha12 = 0 END IF
           UPDATE aha_file  SET  aha11 = l_aha11,
                                 aha12 = l_aha12
                        WHERE aha01 = g_aha.aha01 AND
                              aha00 = g_aha.aha00 AND
                              aha000= '1'
           LET g_aha.aha11 = l_aha11
           LET g_aha.aha12 = l_aha12
           DISPLAY BY NAME g_aha.aha11,g_aha.aha12
                NEXT FIELD ahb02
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ahb[l_ac].* = g_ahb_t.*
              CLOSE i710_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ahb[l_ac].ahb02,-263,1)
              LET g_ahb[l_ac].* = g_ahb_t.*
           ELSE
              UPDATE ahb_file SET ahb02 = g_ahb[l_ac].ahb02,
                                  ahb03 = g_ahb[l_ac].ahb03,
                                  ahb04 = g_ahb[l_ac].ahb04,
                                  ahb05 = g_ahb[l_ac].ahb05,
                                  ahb06 = g_ahb[l_ac].ahb06,
                                  ahb07 = g_ahb[l_ac].ahb07,
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
 
               WHERE ahb01 = g_aha.aha01
                 AND ahb00 = g_aha.aha00
                 AND ahb000= '1'
                 AND ahb02=g_ahb_t.ahb02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","ahb_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660123
                 LET g_ahb[l_ac].* = g_ahb_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
              END IF
 
              SELECT SUM(ahb07) INTO l_aha11 FROM ahb_file,aag_file
               WHERE ahb01 = g_aha.aha01
                 AND ahb00 = g_aha.aha00
                 AND ahb000= '1'
                 AND ahb06 = '1'
                 AND ahb03 = aag01
                 AND ahb00 = aag00   #No.FUN-730070
                 AND aag09 NOT IN ('N','n')
              IF l_aha11 IS NULL OR SQLCA.sqlcode THEN
                 LET l_aha11 = 0
              END IF
              SELECT SUM(ahb07) INTO l_aha12 FROM ahb_file,aag_file
               WHERE ahb01 = g_aha.aha01
                 AND ahb00 = g_aha.aha00
                 AND ahb000= '1'
                 AND ahb06 = '2'
                 AND ahb03 = aag01
                 AND ahb00 = aag00   #No.FUN-730070
                 AND aag09 NOT IN ('N','n')
              IF l_aha12 IS NULL OR SQLCA.sqlcode THEN
                 LET l_aha12 = 0
              END IF
              UPDATE aha_file SET aha11 = l_aha11,
                                  aha12 = l_aha12
               WHERE aha01 = g_aha.aha01
                 AND aha00 = g_aha.aha00
                 AND aha000='1'   #No.FUN-730070
              COMMIT WORK
              LET g_aha.aha11 = l_aha11
              LET g_aha.aha12 = l_aha12
              DISPLAY BY NAME g_aha.aha11,g_aha.aha12
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D30032
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
	       #IF g_cmd='u' THEN #FUN-D30032
               IF p_cmd='u' THEN  #FUN-D30032
                  LET g_ahb[l_ac].* = g_ahb_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_ahb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF
               CLOSE i710_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032
            CLOSE i710_bcl
            COMMIT WORK
            CALL g_ahb.deleteElement(g_rec_b+1)   #No.MOD-910003
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ahb03)      #查詢科目代號不為統制帳戶'1'
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_ahb[l_ac].ahb03
                 LET g_qryparam.arg1 = g_aha.aha00  #No.FUN-730070
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2'"
                 CALL cl_create_qry() RETURNING g_ahb[l_ac].ahb03
                  DISPLAY BY NAME g_ahb[l_ac].ahb03           #No.MOD-490344
                 CALL i710_ahb03('d')
                 NEXT FIELD ahb03
              WHEN INFIELD(ahb04)     #查詢常用摘要
                     CALL q_aad(FALSE,TRUE,g_ahb[l_ac].ahb04)
                     RETURNING g_ahb[l_ac].ahb04
                     DISPLAY g_ahb[l_ac].ahb04 TO ahb04
                 NEXT FIELD ahb04
              WHEN INFIELD(ahb05) #查詢部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_ahb[l_ac].ahb05
                 CALL cl_create_qry() RETURNING g_ahb[l_ac].ahb05
                  DISPLAY BY NAME g_ahb[l_ac].ahb05           #No.MOD-490344
                 NEXT FIELD ahb05
              WHEN INFIELD(ahb08)    #查詢專案編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pja2"    #FUN-810045 
                 LET g_qryparam.default1 = g_ahb[l_ac].ahb08
                 CALL cl_create_qry() RETURNING g_ahb[l_ac].ahb08
                  DISPLAY BY NAME g_ahb[l_ac].ahb08           #No.MOD-490344
                 NEXT FIELD ahb08
 
              WHEN INFIELD(ahb11)    #查詢異動碼-1
                   CALL s_ahe_qry(g_ahb[l_ac].ahb03,'1','i',g_ahb[l_ac].ahb11,g_aha.aha00)  #No.FUN-730070
                      RETURNING g_ahb[l_ac].ahb11
                   DISPLAY g_ahb[l_ac].ahb11 TO ahb11
                   NEXT FIELD ahb11
 
              WHEN INFIELD(ahb12)    #查詢異動碼-2
                   CALL s_ahe_qry(g_ahb[l_ac].ahb03,'2','i',g_ahb[l_ac].ahb12,g_aha.aha00)  #No.FUN-730070
                      RETURNING g_ahb[l_ac].ahb12
                   DISPLAY g_ahb[l_ac].ahb12 TO ahb12
                   NEXT FIELD ahb12
 
              WHEN INFIELD(ahb13)    #查詢異動碼-3
                   CALL s_ahe_qry(g_ahb[l_ac].ahb03,'3','i',g_ahb[l_ac].ahb13,g_aha.aha00)  #No.FUN-730070
                      RETURNING g_ahb[l_ac].ahb13
                   DISPLAY g_ahb[l_ac].ahb13 TO ahb13
                   NEXT FIELD ahb13
 
              WHEN INFIELD(ahb14)    #查詢異動碼-4
                   CALL s_ahe_qry(g_ahb[l_ac].ahb03,'4','i',g_ahb[l_ac].ahb14,g_aha.aha00)  #No.FUN-730070
                      RETURNING g_ahb[l_ac].ahb14
                   DISPLAY g_ahb[l_ac].ahb14 TO ahb14
                   NEXT FIELD ahb14
 
              WHEN INFIELD(ahb31)    #查詢異動碼-5
                   CALL s_ahe_qry(g_ahb[l_ac].ahb03,'5','i',g_ahb[l_ac].ahb31,g_aha.aha00)  #No.FUN-730070
                      RETURNING g_ahb[l_ac].ahb31
                   DISPLAY g_ahb[l_ac].ahb31 TO ahb31
                   NEXT FIELD ahb31
 
              WHEN INFIELD(ahb32)    #查詢異動碼-6
                   CALL s_ahe_qry(g_ahb[l_ac].ahb03,'6','i',g_ahb[l_ac].ahb32,g_aha.aha00)  #No.FUN-730070
                      RETURNING g_ahb[l_ac].ahb32
                   DISPLAY g_ahb[l_ac].ahb32 TO ahb32
                   NEXT FIELD ahb32
 
              WHEN INFIELD(ahb33)    #查詢異動碼-7
                   CALL s_ahe_qry(g_ahb[l_ac].ahb03,'7','i',g_ahb[l_ac].ahb33,g_aha.aha00)  #No.FUN-730070
                      RETURNING g_ahb[l_ac].ahb33
                   DISPLAY g_ahb[l_ac].ahb33 TO ahb33
                   NEXT FIELD ahb33
 
              WHEN INFIELD(ahb34)    #查詢異動碼-8
                   CALL s_ahe_qry(g_ahb[l_ac].ahb03,'8','i',g_ahb[l_ac].ahb34,g_aha.aha00)  #No.FUN-730070
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
                  LET g_qryparam.form ="q_azf01a"  #No.FUN-930104
                  LET g_qryparam.arg1 = '7'        #No.FUN-950077
                  LET g_qryparam.default1 = g_ahb[l_ac].ahb36
                  CALL cl_create_qry() RETURNING g_ahb[l_ac].ahb36
                  DISPLAY g_ahb[l_ac].ahb36 TO ahb36
                  NEXT FIELD ahb36
 
              WHEN INFIELD(ahb37)    #查詢關係人異動碼
                   CALL s_ahe_qry(g_ahb[l_ac].ahb03,'99','i',g_ahb[l_ac].ahb37,g_aha.aha00)  #No.FUN-730070
                      RETURNING g_ahb[l_ac].ahb37
                   DISPLAY g_ahb[l_ac].ahb37 TO ahb37
                   NEXT FIELD ahb37
 
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION create_account
           CALL cl_cmdrun('agli102' CLIPPED)
 
        ON ACTION create_voucher_extra_memo
           LET l_cmd = "agli701 '",g_aha.aha00,"' '",g_aha.aha01,"' '",
                       g_aha.aha000,"' ",g_ahb[l_ac].ahb02," "
           CALL cl_cmdrun(l_cmd)
 
        ON ACTION create_budget_number
            LET l_cmd = "aglt600 "
           CALL cl_cmdrun(l_cmd CLIPPED)
 
        ON ACTION create_department_data
           CALL cl_cmdrun('agli104' CLIPPED)
 
        ON ACTION create_transaction_code
           CASE
              WHEN INFIELD(ahb11)
                  CALL cl_cmdrun("agli109  '' '1' ")  #MOD-4C0171
              WHEN INFIELD(ahb12)
                  CALL cl_cmdrun("agli109  '' '2' ")  #MOD-4C0171
              WHEN INFIELD(ahb13)
                  CALL cl_cmdrun("agli109  '' '3' ")  #MOD-4C0171
              WHEN INFIELD(ahb14)
                  CALL cl_cmdrun("agli109  '' '4' ")  #MOD-4C0171
 
              WHEN INFIELD(ahb31)
                  CALL cl_cmdrun("agli109  '' '5' ")
              WHEN INFIELD(ahb32)
                  CALL cl_cmdrun("agli109  '' '6' ")
              WHEN INFIELD(ahb33)
                  CALL cl_cmdrun("agli109  '' '7' ")
              WHEN INFIELD(ahb34)
                  CALL cl_cmdrun("agli109  '' '8' ")
              WHEN INFIELD(ahb35)
                  CALL cl_cmdrun("agli109  '' '9' ")
              WHEN INFIELD(ahb36)
                  CALL cl_cmdrun("agli109  '' '10' ")
              WHEN INFIELD(ahb37)
                  CALL cl_cmdrun("agli109  '' '99' ")
 
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
                   AND ahb000= '1'
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
 
 
       ON ACTION addno
          SELECT COUNT(*) INTO l_cnt FROM ahb_file
           WHERE ahb01 = g_aha.aha01
             AND ahb00 = g_aha.aha00
             AND ahb000= '1'
             AND ahb02 >= g_ahb[l_ac].ahb02
          DECLARE ahb_cl
             CURSOR FOR SELECT ahb02 FROM ahb_file
             WHERE ahb00 = g_aha.aha00 AND
                   ahb000= '1' AND
                   ahb01 = g_aha.aha01 AND
                   ahb02 >= g_ahb[l_ac].ahb02
                   ORDER BY  1 DESC
          FOREACH ahb_cl INTO l_ahb02
             UPDATE ahb_file SET ahb02 = l_ahb02 + 1
              WHERE ahb00 = g_aha.aha00 AND
                    ahb000='1' AND
                    ahb01 =  g_aha.aha01 AND
                    ahb02 = l_ahb02
          END FOREACH
          CALL i710_show()
          LET l_check = g_ahb[l_ac].ahb02
          IF l_check  < l_check_t  OR l_check_t = 0 THEN
             LET l_check_t =  l_check
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
    UPDATE aha_file SET ahamodu=g_user,ahadate=g_today
     WHERE aha01=g_aha.aha01 AND aha00=g_aha.aha00
       AND aha000=g_aha.aha000
 
    CLOSE i710_bcl
    COMMIT WORK
 
    CALL i710_chk()   #No.MOD-910003
    CALL i710_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i710_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM aha_file WHERE aha01=g_aha.aha01 AND aha00=g_aha.aha00
                                AND aha000=g_aha.aha000
         INITIALIZE g_aha.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#檢查科目名稱
FUNCTION  i710_ahb03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
    l_aag07         LIKE aag_file.aag07,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02,aag07,aagacti
        INTO g_ahb[l_ac].aag02,l_aag07,l_aagacti
        FROM aag_file
        WHERE aag01 = g_ahb[l_ac].ahb03
          AND aag00 = g_aha.aha00  #No.FUN-730070
    CASE WHEN STATUS=100          LET g_errno = 'agl-001'  #No.7926
          WHEN l_aagacti = 'N' LET g_errno = '9028'
          WHEN l_aag07 = '1' LET g_errno = 'agl-015'
          OTHERWISE LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
    DISPLAY BY NAME g_ahb[l_ac].aag02
END FUNCTION
 
FUNCTION i710_ahb11(p_cmd,p_seq,p_key)
        DEFINE p_cmd    LIKE aag_file.aag151,        # 檢查否
                   p_seq  LIKE type_file.chr1,       # 項      #No.FUN-680098 VARCHAR(1)
                   p_key  LIKE type_file.chr20,      # 異動    #No.FUN-680098 VARCHAR(20)
                   l_aeeacti  LIKE aee_file.aeeacti,
                   l_aee04    LIKE aee_file.aee04
        LET g_errno = ' '
        IF p_cmd IS NULL OR p_cmd NOT MATCHES "[123]" THEN RETURN END IF
        SELECT aee04,aeeacti INTO l_aee04,l_aeeacti FROM aee_file
                WHERE aee01 = g_ahb[l_ac].ahb03
                  AND aee02 = p_seq     AND aee03 = p_key
                  AND aee00 = g_aha.aha00   #No.FUN-730070
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
           IF g_ahb[l_ac].ahb04 IS NULL THEN
              LET g_ahb[l_ac].ahb04 = l_aee04
              DISPLAY BY NAME g_ahb[l_ac].ahb04
           ELSE
              IF l_aee04 != g_ahb[l_ac].ahb04  THEN
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
 
FUNCTION i710_b_askkey()
DEFINE
    l_wc2           STRING       #TQC-630166
 
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
    CALL i710_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i710_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING        #TQC-630166
 
    LET g_sql = " SELECT ahb02,ahb03,aag02,ahb05,ahb06,",
                " ahb07,ahb08,ahb35,ahb36,ahb11,ahb12,ahb13,ahb14,",  #No.FUN-830139
 
                " ahb31,ahb32,ahb33,ahb34,ahb37,", #No.FUN-830139 ahb35,ahb36移動到ahb08后
 
                " ahb04,",
                " ahbud01,ahbud02,ahbud03,ahbud04,ahbud05,",
                " ahbud06,ahbud07,ahbud08,ahbud09,ahbud10,",
                " ahbud11,ahbud12,ahbud13,ahbud14,ahbud15 ", 
                " FROM ahb_file LEFT OUTER JOIN aag_file ON ahb03 = aag01 AND ahb00 = aag00",
                " WHERE ahb01 ='",g_aha.aha01,"' AND ",  #單頭
                " ahb00 = '",g_aha.aha00,"' AND ",
                " ahb000= '1' AND  ",
                " ahb02 != 0 AND   ",
                " ahb00 = aag00  "    #AND  ",  #No.FUN-730070
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1 " 
    DISPLAY g_sql
 
    PREPARE i710_pb FROM g_sql
    DECLARE ahb_curs                       #SCROLL CURSOR
        CURSOR FOR i710_pb
 
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
    CALL g_ahb.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i710_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ahb TO s_ahb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i710_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i710_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i710_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i710_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i710_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION other_memo
         LET g_action_choice="other_memo"
         EXIT DISPLAY
#     ON ACTION 額外摘要
#        LET g_action_choice="額外摘要"
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
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
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i710_copy()
DEFINE
    l_aha        RECORD LIKE aha_file.*,
    l_oldno,l_newno    LIKE aha_file.aha01,
    l_oldno0,l_newno0  LIKE aha_file.aha00   #No.FUN-730070
 
    IF s_aglshut(0) THEN RETURN END IF
    IF g_aha.aha01 IS NULL OR g_aha.aha00 IS NULL THEN  #No.FUN-730070
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i710_set_entry('a')
    CALL i710_set_no_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
    INPUT l_newno0,l_newno FROM aha00,aha01  #No.FUN-730070
        BEFORE INPUT
            CALL cl_set_docno_format("aha14")
 
        AFTER FIELD aha00
            IF l_newno0 IS NOT NULL THEN
               CALL i710_aha00('a',l_newno0)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(l_newno0,g_errno,0)
                  NEXT FIELD aha00
               END IF
            END IF
 
        AFTER FIELD aha01
            IF l_newno IS NULL THEN
                NEXT FIELD aha01
            ELSE
                SELECT count(*) INTO g_cnt FROM aha_file
                       WHERE aha01 = l_newno AND aha00 = l_newno0 AND  #No.FUN-730070
                             aha000 = '1'
                IF g_cnt > 0 THEN
                   CALL cl_err(l_newno,-239,0)
                   NEXT FIELD aha00  #No.FUN-730070
                END IF
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
        DISPLAY BY NAME g_aha.aha01,g_aha.aha00  #No.FUN-730070
        ROLLBACK WORK
        RETURN
    END IF
    LET l_aha.* = g_aha.*
    LET l_aha.aha01  =l_newno   #新的鍵值
    LET l_aha.aha00  =l_newno0  #No.FUN-730070
    LET l_aha.aha04  =NULL      #上次產生日期    #No.MOD-8C0257
    LET l_aha.ahauser=g_user    #資料所有者
    LET l_aha.ahagrup=g_grup    #資料所有者所屬群
    LET l_aha.ahamodu=NULL      #資料修改日期
    LET l_aha.ahadate=g_today   #資料建立日期
    LET l_aha.ahaacti='Y'       #有效資料
    LET l_aha.ahalegal = g_legal #FUN-980003 add
    LET l_aha.ahaoriu = g_user      #No.FUN-980030 10/01/04
    LET l_aha.ahaorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO aha_file VALUES (l_aha.*)
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","aha_file",l_aha.aha01,l_aha.aha00,SQLCA.sqlcode,"","aha:",1)  #No.FUN-660123
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM ahb_file         #單身複製
        WHERE ahb01 =g_aha.aha01
          AND ahb00 =g_aha.aha00  #No.FUN-730070
          AND ahb000='1'          #No.FUN-730070
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","x",g_aha.aha01,g_aha.aha00,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730070
        RETURN
    END IF
    UPDATE x
        SET ahb01=l_newno,
            ahb00=l_newno0  #No.FUN-730070
    INSERT INTO ahb_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","ahb_file",l_newno,"",SQLCA.sqlcode,"","ahb:",1)  #No.FUN-660123
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_aha.aha01
     LET l_oldno0= g_aha.aha00  #No.FUN-730070
     SELECT aha_file.* INTO g_aha.* FROM aha_file
                     WHERE aha01 = l_newno AND aha00 = l_newno0 AND  #No.FUN-730070
                           aha000= '1'
     CALL i710_u()
     CALL i710_b('a')
     #FUN-C30027---begin
     #SELECT aha_file.* INTO g_aha.* FROM aha_file
     #                WHERE aha01 = l_oldno AND aha00 = l_oldno0 AND  #No.FUN-730070
     #                      aha000= '1'
     #CALL i710_show()
     #FUN-C30027---end
END FUNCTION
 
FUNCTION i710_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("aha01,aha00",TRUE)  #No.FUN-730070
    END IF
    IF g_aha.ahamksg='Y' THEN
       CALL cl_set_comp_entry("ahasign",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i710_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aha01,aha00",FALSE)  #No.FUN-730070
    END IF
    IF g_aha.ahamksg='N' THEN
       CALL cl_set_comp_entry("ahasign",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i710_set_entry_b()
 
      CALL cl_set_comp_entry("ahb05,ahb11,ahb12,ahb13,ahb14",TRUE)
      CALL cl_set_comp_entry("ahb08",TRUE)   #No.MOD-930170
 
      CALL cl_set_comp_entry("ahb31,ahb32,ahb33,ahb34,ahb35,ahb36,ahb37",TRUE)
 
 
END FUNCTION
 
FUNCTION i710_set_no_entry_b()
 
DEFINE    l_aag05         LIKE aag_file.aag05,
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
 
       LET l_aag05 =NULL LET l_aag151=NULL LET l_aag161=NULL
       LET l_aag171=NULL LET l_aag181=NULL LET l_aag21 =NULL
       LET l_aag23 =NULL LET l_aag311=NULL LET l_aag321=NULL
       LET l_aag331=NULL LET l_aag341=NULL LET l_aag351=NULL
       LET l_aag361=NULL LET l_aag371=NULL
       SELECT aag05,aag151,aag161,aag171,aag181,aag21,aag23,
              aag311,aag321,aag331,aag341,aag351,aag361,aag371
         INTO l_aag05,l_aag151,l_aag161,
              l_aag171,l_aag181,l_aag21,l_aag23,
              l_aag311,l_aag321,l_aag331,
              l_aag341,l_aag351,l_aag361,l_aag371
         FROM aag_file
        WHERE aag01 = g_ahb[l_ac].ahb03
          AND aag00 = g_aha.aha00   #No.FUN-740033
       IF l_aag05="N" THEN
          CALL cl_set_comp_entry("ahb05",FALSE)
         IF NOT cl_null(g_ahb[l_ac].ahb05) THEN   
            LET g_ahb[l_ac].ahb05 = NULL 
            DISPLAY BY NAME g_ahb[l_ac].ahb05
         END IF 
       END IF
       IF l_aag23="N" THEN
          CALL cl_set_comp_entry("ahb08,ahb35",FALSE)   #No.MOD-930170 add ahb35
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
 
FUNCTION i710_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680098  SMALLINT
    sr              RECORD
        aha00       LIKE aha_file.aha00,   #No.FUN-730070
        aha01       LIKE aha_file.aha01,   #傳票編號
        aha02       LIKE aha_file.aha02,   #傳票日期
        aha03       LIKE aha_file.aha03,   #說明
        aha04       LIKE aha_file.aha04,   #說明
        aha05       LIKE aha_file.aha05,   #輸入日期
        aha06       LIKE aha_file.aha06,   #來源碼
        aha14       LIKE aha_file.aha14,   #參考號碼
        aha11       LIKE aha_file.aha11,   #借方金額
        aha12       LIKE aha_file.aha12,   #貸方金額
        ahamksg     LIKE aha_file.ahamksg, #簽核否
        ahasign     LIKE aha_file.ahasign, #簽核等級
        ahb02       LIKE ahb_file.ahb02,   #項次
        ahb03       LIKE ahb_file.ahb03,   #科目編號
        ahb05       LIKE ahb_file.ahb05,   #部門
        ahb06       LIKE ahb_file.ahb06,   #人員代號
        ahb07       LIKE ahb_file.ahb07,   #異動金額
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
    l_msg           LIKE ze_file.ze03, #No.FUN-680098   VARCHAR(24)
    l_name          LIKE type_file.chr20,  #External(Disk) file name   #No.FUN-680098 VARCHAR(20)
    l_za05          LIKE za_file.za05      #No.FUN-680098 VARCHAR(40)
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
    CALL cl_del_data(l_table)                     #No.FUN-830092     
    LET g_chr = ' '
            LET INT_FLAG = 0  ######add for prompt bug
   IF cl_confirm('agl-121') THEN    #no:7429
      LET g_chr='Y'
   ELSE
      LET g_chr='N'
   END IF
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'agli710'
    LET g_sql="SELECT aha00,aha01,aha02,aha03,aha04,aha05,aha06,aha14,aha11,",  #No.FUN-730070
          "aha12,",
          "ahamksg,ahasign,",
          "ahb02,ahb03,ahb05,ahb06,ahb07,ahb08,",
          "ahb11,ahb12,ahb13,ahb14,",
 
          " ahb31,ahb32,ahb33,ahb34,ahb35,ahb36,ahb37,",
 
          " ahb04,ahaacti ",
          " FROM aha_file, ahb_file",
          " WHERE aha000 = '1' ",
          "   AND aha01 = ahb01 AND aha00 = ahb00 AND aha000 = ahb000 AND  ",   #No:8349
          g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED,
          " ORDER BY 1 "
    PREPARE i710_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i710_co CURSOR FOR i710_p1
 
 
    FOREACH i710_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = sr.aha00          
        SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file                   
         WHERE azi01 = g_aaa03                                                  
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
           FOR l_i = 5 TO g_aaz.aaz125                                           
               LET l_tc = ''                                                    
               CASE                                                             
#FUn-B50105   ---end     Add
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
                                  sr.aha05,sr.aha04,sr.aha06,sr.aha14,          
                                  sr.aha11,sr.ahamksg,sr.aha12,sr.ahasign,      
                                  sr.ahb02,sr.ahb03,sr.ahb04,sr.ahb05,          
                                  sr.ahb06,sr.ahb07,sr.ahb08,sr.ahb37, 
                                  t_azi04,sr.ahaacti,l_tc1,l_tc2,l_tc3,         
                                  l_tc4,l_tc5,l_tc6,l_tc7,l_tc8,l_tc9,l_tc10    
                                                                                
                                                                                
    END FOREACH
 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'aha00,aha01,aha02,aha03,aha05,aha06,aha04,aha14,     
                     aha07,ahamksg,ahasign,ahauser,ahagrup,ahamodu,ahadate,     
                     ahaacti,ahb02,ahb03,ahb05,ahb06,ahb07,ahb15,ahb08,ahb11,   
                     ahb12,ahb13,ahb14,ahb31,ahb32,ahb33,ahb34,ahb35,ahb36,     
                     ahb37,ahb04')                                              
            RETURNING g_str                                                     
    END IF                                                                      
    LET g_str = g_str,";",g_aaz.aaz88,";",g_chr,";",g_aaz.aaz125    #FUN-B50105   Add ,";",g_aaz.aaz125 
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED          
    CALL cl_prt_cs3('agli710','agli710',l_sql,g_str)                            
END FUNCTION
 
FUNCTION  i710_show_field()
#依參數決定異動碼的多寡
 
  DEFINE l_field     STRING
 
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
 
FUNCTION i710_set_no_required()
   CALL cl_set_comp_required("ahb05,ahb08,ahb11,ahb12,ahb13,ahb14,ahb31,ahb32,ahb33,ahb34,ahb35,  #No.MOD-930170 add ahb05,ahb08
                         ahb36,ahb37",FALSE)
END FUNCTION
 
FUNCTION i710_set_required()
DEFINE    l_aag05         LIKE aag_file.aag05
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
 
   LET l_aag151=NULL LET l_aag161=NULL LET l_aag171=NULL
   LET l_aag181=NULL LET l_aag311=NULL LET l_aag321=NULL
   LET l_aag331=NULL LET l_aag341=NULL LET l_aag351=NULL
   LET l_aag361=NULL LET l_aag371=NULL LET l_aag05 =NULL
   SELECT aag151,aag161,aag171,aag181,aag05,
          aag311,aag321,aag331,aag341,aag351,aag361,aag371,
          aag21,aag23   #No.MOD-930170
     INTO l_aag151,l_aag161,l_aag171,l_aag181,l_aag05,
          l_aag311,l_aag321,l_aag331,
          l_aag341,l_aag351,l_aag361,l_aag371,
          l_aag21,l_aag23   #No.MOD-930170
     FROM aag_file
    WHERE aag01 = g_ahb[l_ac].ahb03
      AND aag00 = g_aha.aha00   #No.FUN-740033
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
 
FUNCTION i710_show_ahe02(p_code)
DEFINE p_code   LIKE aag_file.aag15,
       l_str    LIKE type_file.chr20,      #No.FUN-680098  VARCHAR(20)
       l_ahe02  LIKE ahe_file.ahe02
 
   SELECT ahe02 INTO l_ahe02 FROM ahe_file WHERE ahe01 = p_code
 
   #-->顯示狀況
   IF p_code IS NOT NULL AND p_code != ' ' THEN
      CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
      LET l_str = l_str CLIPPED,l_ahe02,'!'
      ERROR l_str
   END IF
END FUNCTION
 
FUNCTION i710_chk_ahb35()
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
 
FUNCTION i710_chk_ahb36()
DEFINE l_azfacti  LIKE azf_file.azfacti
DEFINE l_n        LIKE type_file.num5
DEFINE l_azf09    LIKE azf_file.azf09   #No.FUN-930104
 
   LET g_errno = ' '
   SELECT COUNT(*)  
     INTO l_n
     FROM azf_file
    WHERE azf01 = g_ahb[l_ac].ahb36
      AND azf02 = '2'
   SELECT azfacti,azf09       #No.FUN-930104
     INTO l_azfacti,l_azf09   #No.FUN-930104
     FROM azf_file
    WHERE azf01 = g_ahb[l_ac].ahb36
      AND azf02 = '2'
   CASE WHEN l_n <= 0      LET g_errno = 'abg-502'  
        WHEN l_azfacti='N' LET g_errno = '9028'
       #WHEN l_azf09 != '9'LET g_errno = 'aoo-408' #No.FUN-930104 
        WHEN l_azf09 != '7'LET g_errno = 'aoo-406' #No.FUN-950077 
        OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i710_chk()
 
   IF g_aha.aha11 != g_aha.aha12 THEN
      IF g_aaz.aaz71 = '1' THEN
         CALL cl_err('','agl-147',1)
         CALL i710_b(' ')
      ELSE
         CALL cl_err('','agl-147',1)
      END IF
   END IF
 
END FUNCTION
 
FUNCTION i710_aha07(p_cmd,p_aha07)
  DEFINE p_cmd     LIKE type_file.chr1
  DEFINE p_aha07   LIKE aha_file.aha07
  DEFINE l_aacacti LIKE aac_file.aacacti
  DEFINE l_aac03   LIKE aac_file.aac03
  DEFINE l_aac11   LIKE aac_file.aac11
 
    LET g_errno = ' '
    SELECT aac03,aacacti,aac11 INTO l_aac03,l_aacacti,l_aac11
      FROM aac_file
     WHERE aac01=p_aha07
       AND (aac03='0' OR aac03='1')     #原程序是这样写的,具体现在为何,不知道
    CASE
        WHEN l_aacacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'mfg0014'
        WHEN l_aac11 <> '1'  LET g_errno = 'agl-901'
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
	END CASE
END FUNCTION
#No.FUN-9C0072 精簡程式碼

