# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Descriptions...: 會計科目對沖關係維護作業
# Date & Author..: 01/09/17 By Debbie Hsu
# Modify.........: No:MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No:MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No:FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No:FUN-510007 05/01/20 By Nicola 報表架構修改
# Modify.........: No:MOD-4C0171 05/02/15 By Smapmin 接收參數時,第一個必為帳別,若第一個不是帳別,則加入Null
# Modify.........: NO:FUN-570108 05/07/13 By Trisy key值可更改
# Modify.........: No:FUN-570200 05/07/28 By Rosayu  程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No:FUN-580063 05/08/15 By Sarah 增加維護兩個欄位:axf09,axf10,放在axf01前面
# Modify.........: No:FUN-580064 05/09/02 By Dido 改成 "假雙檔" 維護程式
# Modify.........: NO.TQC-5B0064 05/11/08 By Niocla 報表修改
# Modify.........: No:FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No:FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No:FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No:FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:FUN-730070 07/04/02 By Carrier 會計科目加帳套-財務
# Modify.........: No:MOD-740403 07/04/23 By Pengu 新增時axf03預設值為 'N'，axfacti 預設值為 'Y'
# Modify.........: No:FUN-740170 07/04/24 By Sarah 當單身的股權比例(axf03)打勾時,差額對應科目(axf04)一定要輸入
# Modify.........: No:FUN-740172 07/04/24 By Sarah 單頭新增帳別及開窗合理性應要加判斷AGLI009,單頭來源欄位不可與對沖欄位值相同
# Modify.........: No:FUN-750058 07/05/21 By kim GP5.1合併報表改善專案
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No:TQC-760030 07/06/05 By Sarah 1.單身來源科目開窗沒資料，應抓來源公司所在DB符合單頭來源帳別的會計科目來開窗
#                                                  2.單身來源科目與對沖科目若輸入MISC，應馬上開MISC科目設定畫面以供輸入
# Modify.........: No:TQC-760100 07/06/13 By Sarah 對沖科目開窗應抓對沖科目+對沖帳號的一般會計科目
# Modify.........: No:FUN-760053 07/06/20 By Sarah 1.來源、對沖科目開窗應開合併後科目,差額對應科目開來源帳別、公司的合併後科目
#                                                  2.資料重複關不掉
#                                                  3.依股權比率沖銷時,目前無法維護差異科目
# Modify.........: No:FUN-770069 07/10/08 By Sarah 單身刪除的WHERE條件句,axf01的部份應該用g_axf_t.axf01
# Modify.........: No.FUN-820002 07/12/20 By lala   報表轉為使用p_query
# Modify.........: No:FUN-910001 09/09/18 By lutingting由11區追單, 1.單頭增加axf13(族群代號)                                                        
#                                                  2.開窗CALL q_axe1需多傳arg3(族群代號),arg4(合并報表帳別)
# Modify.........: NO.FUN-950047 09/05/19 BY yiting add axf14,axf15
# Modify.........: NO.FUN-930117 09/05/20 BY ve007 pk值異動，相關程式修改
# Modify.........: NO.FUN-920049 09/05/20 BY lutingting由11區追單 1.單頭帳別依agli009設定自動帶出,NOENTRY 
# Modify.........: NO.FUN-920140 09/05/21 BY jan BEFORE ROW抓取aag02要跨DB 
# Modify.........: NO.FUN-950051 09/05/25 By lutingting 由于agli002單頭增加"獨立會科合并"欄位,對檢查會科方式修改 
# Modify.........: No:FUN-960095 09/06/19 By lutingting 刪除時若axf01以及axf02為MISC,則將agli0031,agli0032得資料一并刪除
# Modify.........: No:TQC-960366 09/06/26 By destiny 復制時會報錯
# Modify.........: No:MOD-960314 09/06/25 By Sarah i003_axf12()傳的參數應該改為傳axf09
# Modify.........: NO.FUN-960093 09/08/11 BY yiting agli003單身輸入後，查詢後點選單身，無法進入來源及對沖科目修改
# Modify.........: No.TQC-9C0099 09/12/16 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-9C0072 10/01/05 By vealxu 精簡程式碼
# Modify.........: NO.FUN-9C0160 09/12/25 BY Yiting 複製時有問題
# Modify.........: No.CHI-9C0038 10/01/25 By lutingting 開放可錄結轉科目
# Modify.........: NO.TQC-A20010 10/02/03 BY Yiting 帳別取錯
# Modify.........: No.FUN-9B0098 10/02/23 by tommas delete cl_doc
# Modify.........: NO.FUN-A30079 10/03/24 BY yiting 單頭增加"合併主體"欄位，後續沖銷分錄產生時必需考慮此欄位值為依據產生上層公司
# Modify.........: No.FUN-A50102 10/06/03 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: NO.FUN-A30122 10/03/31 by yiting 取合併帳別資料庫改由s_aaz641_dbs，s_get_aaz641取合併帳別
# Modify.........: NO.MOD-A50193 10/05/28 by sabrina 來源科目或對沖科目為MISC時，不需執行agli002
# Modify.........: No:CHI-A60013 10/07/16 By Summer 在跨資料庫SQL後加入DB_LINK語法
# Modify.........: NO.FUN-A70107 10/07/20 BY yiting 合併主體的階級需高於來源及目的公司的層級
# Modify.........: NO.MOD-AB0165 10/11/17 BY Dido 複製時欄位控制調整 
# Modify.........: NO.MOD-AB0238 10/11/26 BY Dido 更新時需增加 axfacti  
# Modify.........: NO.FUN-A80137 11/01/28 BY lixia 來源及目的公司對沖科目，可個別設定來源檔案
# Modify.........: NO.MOD-B20063 11/02/17 BY Dido 複製時 axf16 未更新  
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No.MOD-C50143 12/05/22 By Polly 調整axf09/axf10開窗方式
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-C90063 12/09/10 By Polly 調整會查到舊有架構資料錯誤，重新抓取aaz641，取出g_axee00變數作為實際帳別條件
# Modify.........: No.MOD-CC0202 13/01/09 By Polly 複製時，同時將axs_file、axt_file資料複製
# Modify.........: No.MOD-D10110 13/01/14 By apo 刪除時一併刪除axu_file資料
# Modify.........: No.FUN-D20048 13/03/21 By Lori 新增貸方差額科目(axf18),沖銷組別(axf19)
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BA0006
#FUN-BA0012
#模組變數(Module Variables)
DEFINE
    g_axf13         LIKE axf_file.axf13,  #FUN-910001 add
    g_axf09         LIKE axf_file.axf09,
    g_axf10         LIKE axf_file.axf10,
    g_axf13_t       LIKE axf_file.axf13,  #FUN-910001 add 
    g_axf09_t       LIKE axf_file.axf09,
    g_axf10_t       LIKE axf_file.axf10,
    g_axf13_o       LIKE axf_file.axf13,  #FUN-910001 add
    g_axf09_o       LIKE axf_file.axf09,
    g_axf10_o       LIKE axf_file.axf10,  #No.FUN-730070
    g_axf00         LIKE axf_file.axf00,  #No.FUN-730070
    g_axf12         LIKE axf_file.axf12,  #No.FUN-730070
    g_axf00_t       LIKE axf_file.axf00,  #No.FUN-730070
    g_axf12_t       LIKE axf_file.axf12,  #No.FUN-730070
    g_axf00_o       LIKE axf_file.axf00,  #No.FUN-730070
    g_axf12_o       LIKE axf_file.axf12,  #No.FUN-730070
    g_axf16         LIKE axf_file.axf16,  #FUN-A30079
    g_axf16_t       LIKE axf_file.axf16,  #FUN-A30079
    g_axf           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        axf19       LIKE axf_file.axf19,   #FUN-D20048 add
        axf14       LIKE axf_file.axf14,   #FUN-950047
        axf15       LIKE axf_file.axf15,   #FUN-950047
        axf01       LIKE axf_file.axf01,   #科目編號
        axf01_desc  LIKE aag_file.aag02,
        axf17       LIKE axf_file.axf17,   #FUN-A80137
        axf02       LIKE axf_file.axf02,   #簡稱
        axf02_desc  LIKE aag_file.aag02,
        axf03       LIKE axf_file.axf03,
        axf04       LIKE axf_file.axf04,
        axf04_desc  LIKE aag_file.aag02,
        axf18       LIKE axf_file.axf18,   #FUN-D20048 add
        axf18_desc  LIKE aag_file.aag02,   #FUN-D20048 add
        axfacti     LIKE axf_file.axfacti
                    END RECORD,
    g_axf_t         RECORD                 #程式變數 (舊值)
        axf19       LIKE axf_file.axf19,   #FUN-D20048 add
        axf14       LIKE axf_file.axf14,   #FUN-950047
        axf15       LIKE axf_file.axf15,   #FUN-950047
        axf01       LIKE axf_file.axf01,   #科目編號
        axf01_desc  LIKE aag_file.aag02,
        axf17       LIKE axf_file.axf17,   #FUN-A80137
        axf02       LIKE axf_file.axf02,   #簡稱
        axf02_desc  LIKE aag_file.aag02,
        axf03       LIKE axf_file.axf03,
        axf04       LIKE axf_file.axf04,
        axf04_desc  LIKE aag_file.aag02,
        axf18       LIKE axf_file.axf18,   #FUN-D20048 add
        axf18_desc  LIKE aag_file.aag02,   #FUN-D20048 add
        axfacti     LIKE axf_file.axfacti
                    END RECORD,
    i               LIKE type_file.num5,   #No.FUN-680098 smallint
    g_wc,g_wc2      STRING,      
    g_sql           STRING,#TQC-630166     
    g_rec_b         LIKE type_file.num5,   #單身筆數                 #No.FUN-680098 smallint
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT      #No.FUN-680098 smallint

#主程式開始
DEFINE g_before_input_done   STRING       
DEFINE g_forupd_sql   STRING                       #SELECT ... FOR UPDATE NOWAIT SQL    
DEFINE g_sql_tmp      STRING                       #No.TQC-720019
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_i            LIKE type_file.num5          #count/index for any purpose     #No.FUN-680098 SMALLINT
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_no_ask      LIKE type_file.num5          #No.FUN-680098 SMALINT
DEFINE g_axz03        LIKE axz_file.axz03          #FUN-920049 add                                                                  
DEFINE g_dbs_axz03    LIKE type_file.chr21        #FUN-920049 add                                                                   
DEFINE g_dbs_gl       LIKE type_file.chr21        #FUN-920049 add   
DEFINE g_plant_gl     LIKE type_file.chr21        #FUN-A30122 add by vealxu
DEFINE g_plant_axz03  LIKE type_file.chr21        #FUN-A30122 add by vealxu
DEFINE g_aaz641       LIKE aaz_file.aaz641        #FUN-950051add
#---FUN-A70107 start--
DEFINE g_axa2         DYNAMIC ARRAY OF RECORD                     
                      axb02         LIKE axb_file.axb02, 
                      count         LIKE type_file.num5
                      END RECORD
DEFINE g_j        LIKE type_file.num5       
DEFINE g_k        LIKE type_file.num5       
DEFINE g_flag     LIKE type_file.chr1
#---FUN-A70107 end----

MAIN

   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

   LET i=0
   LET g_axf13_t = NULL  #FUN-910001 add 
   LET g_axf09_t = NULL
   LET g_axf10_t = NULL
   LET g_axf00_t = NULL  #No.FUN-730070
   LET g_axf12_t = NULL  #No.FUN-730070

#--FUN-A70107 start--
 CREATE TEMP TABLE i003_axa_file(
   axb02  LIKE axb_file.axb02,
   count  LIKE type_file.num5)
#--FUN-A70107 end-----

   OPEN WINDOW i003_w WITH FORM "agl/42f/agli003"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
   CALL cl_ui_init()

   CALL i003_menu()
   CLOSE FORM i003_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

#QBE 查詢資料
FUNCTION i003_cs()
    CLEAR FORM                            #清除畫面
    CALL g_axf.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
    INITIALIZE g_axf13 TO NULL    #FUN-910001 add 
    INITIALIZE g_axf09 TO NULL    #No.FUN-750051
    INITIALIZE g_axf10 TO NULL    #No.FUN-750051
    INITIALIZE g_axf00 TO NULL    #No.FUN-750051
    INITIALIZE g_axf12 TO NULL    #No.FUN-750051

    #CONSTRUCT g_wc ON axf13,axf09,axf00,axf10,axf12,axf01,axf02,axf03,axf04                                     #No.FUN-730070  #FUN-910001 add axf13
    #CONSTRUCT g_wc ON axf13,axf09,axf00,axf10,axf12,axf16,axf14,axf15,axf01,axf02,axf03,axf04                   #No.FUN-730070  #FUN-910001 add axf13  #FUN-950047 add axf14,axf15  #FUN-A30079 add axf16
    CONSTRUCT g_wc ON axf13,axf09,axf00,axf10,axf12,axf16,axf19,axf14,axf15,axf01,axf17,axf02,axf03,axf04,axf18  #FUN-A80137 add axf17  #FUN-D20048 add axf19,axf18
         #FROM axf13,axf09,axf00,axf10,axf12,s_axf[1].axf01,s_axf[1].axf02,                                      #No.FUN-730070  #FUN-910001 add axf13
         FROM axf13,axf09,axf00,axf10,axf12,axf16,s_axf[1].axf19,s_axf[1].axf14,s_axf[1].axf15,s_axf[1].axf01,   #No.FUN-730070  #FUN-910001 add axf13   #FUN-950047  #FUN-A30079 add axf16   #FUN-D20048 add axf19
              s_axf[1].axf17,s_axf[1].axf02,                  #FUN-A80137
              s_axf[1].axf03,s_axf[1].axf04,s_axf[1].axf18    #螢幕上取條件   #FUN-D20048 add axf18
       #No:FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No:FUN-580031 --end--       HCN

       ON ACTION CONTROLP
          CASE
            #str FUN-910001 add                                                                                                     
             WHEN INFIELD(axf13) #族群代號                                                                                          
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.state = "c"                                                                                          
                LET g_qryparam.form ="q_axa1"                                                                                       
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                  
                DISPLAY g_qryparam.multiret TO axf13                                                                                
                NEXT FIELD axf13                                                                                                    
            #end FUN-910001 add
#start FUN-580063
             WHEN INFIELD(axf09) #來源公司代碼
                CALL cl_init_qry_var()
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"                              #MOD-C50143 add
                LET g_qryparam.form ="q_axz"
                CALL cl_create_qry() RETURNING g_qryparam.multiret      #MOD-C50143 add
                DISPLAY g_qryparam.multiret TO axf09                    #MOD-C50143 add
               #LET g_qryparam.default1 = g_axf09                       #MOD-C50143 mark
               #CALL cl_create_qry() RETURNING g_axf09                  #MOD-C50143 mark
               #DISPLAY BY NAME g_axf09                #No:MOD-490344   #MOD-C50143 mark
                NEXT FIELD axf09
             WHEN INFIELD(axf10) #對沖公司代碼
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"                              #MOD-C50143 add
                LET g_qryparam.form ="q_axz"
                CALL cl_create_qry() RETURNING g_qryparam.multiret      #MOD-C50143 add
                DISPLAY g_qryparam.multiret TO axf10                    #MOD-C50143 add
               #LET g_qryparam.default1 = g_axf10                       #MOD-C50143 mark
               #CALL cl_create_qry() RETURNING g_axf10                  #MOD-C50143 mark
               #DISPLAY BY NAME g_axf10                   #No:MOD-490344#MOD-C50143 mark
                NEXT FIELD axf10
             #No.FUN-730070  --Begin
             WHEN INFIELD(axf00)  
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_aaa"      #FUN-580063
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO axf00  
                NEXT FIELD axf00
             WHEN INFIELD(axf12)  
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_aaa"      #FUN-580063
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO axf12  
                NEXT FIELD axf12
             #No.FUN-730070  --End   
             WHEN INFIELD(axf16) #合併主體
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_axz"
                LET g_qryparam.default1 = g_axf16
                CALL cl_create_qry() RETURNING g_axf16
                DISPLAY BY NAME g_axf16
                NEXT FIELD axf16
             WHEN INFIELD(axf01) #來源會計科目
                CALL q_m_aag2(TRUE,TRUE,g_plant_new,g_axf[1].axf01,'23',g_axf00)  #TQC-9C0099                                                  
                     RETURNING g_qryparam.multiret                                                                                  
                DISPLAY g_qryparam.multiret TO axf01                                                                                
                NEXT FIELD axf01                                                                                                    
             WHEN INFIELD(axf02) #對沖會計科目
                CALL q_m_aag2(TRUE,TRUE,g_dbs_axz03,g_axf[1].axf02,'23',g_axf00)                                                    
                     RETURNING g_qryparam.multiret                                                                                  
                DISPLAY g_qryparam.multiret TO axf02                                                                                
                NEXT FIELD axf02                                                                                                    
             WHEN INFIELD(axf04) #差額對應會計科目
                CALL q_m_aag2(TRUE,TRUE,g_dbs_axz03,g_axf[1].axf04,'23',g_axf00)                                                    
                     RETURNING g_qryparam.multiret                                                                                  
                DISPLAY g_qryparam.multiret TO axf04                                                                                
                NEXT FIELD axf04                                                                                                    
             #FUN-D20048 add begin---
             WHEN INFIELD(axf18) #差額對應會計科目
                CALL q_m_aag2(TRUE,TRUE,g_dbs_axz03,g_axf[1].axf18,'23',g_axf00)
                     RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO axf18
                NEXT FIELD axf18
             #FUN-D20048 add end-----
             OTHERWISE
                EXIT CASE
          END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       #No:FUN-580031 --start--     HCN
       ON ACTION qbe_select
          CALL cl_qbe_select() 
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No:FUN-580031 --end--       HCN
    END CONSTRUCT

    IF INT_FLAG THEN
       RETURN
    END IF

   #--------------------------MOD-C90063-----------------------------(S)
    LET g_sql = "SELECT UNIQUE axf13,axf09 ",
                "  FROM axf_file",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY axf13,axf09"
    PREPARE i003_aaz641p FROM g_sql
    DECLARE i003_aaz641c SCROLL CURSOR WITH HOLD FOR i003_aaz641p
    OPEN i003_aaz641c
    FETCH FIRST i003_aaz641c INTO g_axf13,g_axf09
    CALL s_aaz641_dbs(g_axf13,g_axf09) RETURNING g_plant_axz03
    CALL s_get_aaz641(g_plant_axz03) RETURNING g_axf00
   #--------------------------MOD-C90063-end--------------------------(E)

   #LET g_sql= "SELECT UNIQUE axf13,axf09,axf10,axf00,axf12 FROM axf_file ",  #No.FUN-730070  #FUN-910001 add axf13
    LET g_sql= "SELECT UNIQUE axf13,axf09,axf10,axf00,axf12,axf16 FROM axf_file ",  #No.FUN-730070  #FUN-910001 add axf13  #FUN-A30079 add axf16
               " WHERE ", g_wc CLIPPED,
               "   AND axf00 = '",g_axf00,"' ",              #MOD-C90063
               " ORDER BY axf13,axf09,axf00,axf10,axf12"  #No.FUN-730070  #FUN-910001 add axf13
    PREPARE i003_prepare FROM g_sql        #預備一下
    DECLARE i003_bcs                       #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i003_prepare

    LET g_sql = "SELECT UNIQUE axf13,axf09,axf10 ",      #No.TQC-720019 #FUN-910001 add axf13  #FUN-A30079 remark
#   LET g_sql_tmp = "SELECT UNIQUE axf13,axf09,axf10,axf00,axf12 ",  #No.TQC-720019  #No.FUN-730070  #FUN-910001 add axf13
                "  FROM axf_file ",
                " WHERE ", g_wc CLIPPED,
                "   AND axf00 = '",g_axf00,"' ",   #MOD-C90063
                " INTO TEMP x "
    DROP TABLE x
   PREPARE i003_pre_x FROM g_sql      #No.TQC-720019  #FUN-A30079 remark
#    PREPARE i003_pre_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i003_pre_x

    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i003_precnt FROM g_sql
    DECLARE i003_cnt CURSOR FOR i003_precnt
END FUNCTION

FUNCTION i003_menu()

   WHILE TRUE
      CALL i003_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i003_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i003_q()
            END IF
#FUN-A30079 start--
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i003_u()
            END IF
#FUN-A30079 end---
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i003_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i003_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i003_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i003_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #FUN-750058................begin
         WHEN "misc_source_acc"
            IF cl_chk_act_auth() THEN
               CALL i003_msa()
            END IF
         WHEN "misc_opposite_acc"
            IF cl_chk_act_auth() THEN
               CALL i003_moa()
            END IF
         #FUN-750058................end
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_axf09 IS NOT NULL THEN
                  LET g_doc.column1 = "axf01"
                  LET g_doc.column2 = "axf02"  #FUN-930117
                  LET g_doc.value1 = g_axf[l_ac].axf01
                  LET g_doc.value2 = g_axf[l_ac].axf02  #FUN-930117
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_axf),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i003_a()
    IF s_shut(0) THEN RETURN END IF                #判斷目前系統是否可用
    MESSAGE ""
    CLEAR FORM
    CALL g_axf.clear()
    INITIALIZE g_axf13 LIKE axf_file.axf13         #DEFAULT 設定  #FUN-910001 add 
    INITIALIZE g_axf09 LIKE axf_file.axf09         #DEFAULT 設定
    INITIALIZE g_axf10 LIKE axf_file.axf10         #DEFAULT 設定
    INITIALIZE g_axf00 LIKE axf_file.axf00         #DEFAULT 設定  #No.FUN-730070
    INITIALIZE g_axf12 LIKE axf_file.axf12         #DEFAULT 設定  #No.FUN-730070
    INITIALIZE g_axf16 LIKE axf_file.axf16         #DEFAULT 設定  #FUN-A30079 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i003_i("a")                           #輸入單頭
        IF INT_FLAG THEN                           #使用者不玩了
            LET g_axf13=NULL  #FUN-910001 add
            LET g_axf09=NULL
            LET g_axf10=NULL
            LET g_axf00=NULL  #No.FUN-730070
            LET g_axf12=NULL  #No.FUN-730070
            LET g_axf16=NULL  #FUN-A30079
            DISPLAY g_axf13,g_axf09,g_axf10,g_axf00,g_axf12,g_axf16   #FUN-910001 add axf13 #FUN-A30079 add axf16  
                 TO axf13,axf09,axf10,axf00,axf12,axf16  #FUN-760053 add    #FUN-910001 add axf13  #FUN-A30079 add axf16
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_axf09 IS NULL THEN # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_axf10 IS NULL OR g_axf13 IS NULL THEN # KEY 不可空白  #FUN-910001 add axf13
            CONTINUE WHILE
        END IF
        #No.FUN-730070  --Begin
        IF g_axf00 IS NULL OR g_axf12 IS NULL THEN # KEY 不可空白
            CONTINUE WHILE
        END IF
        #No.FUN-730070  --End  
        CALL g_axf.clear()
        LET g_rec_b = 0
        CALL i003_b()                              #輸入單身
        LET g_axf13_t = g_axf13                    #保留舊值  #FUN-910001 add
        LET g_axf09_t = g_axf09                    #保留舊值
        LET g_axf10_t = g_axf10                    #保留舊值
        LET g_axf00_t = g_axf00                    #保留舊值  #No.FUN-730070
        LET g_axf12_t = g_axf12                    #保留舊值  #No.FUN-730070
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i003_u()

    IF s_shut(0) THEN
       RETURN
    END IF

    IF cl_null(g_axf13) OR cl_null(g_axf09) OR cl_null(g_axf10) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    MESSAGE ""
    LET g_axf16_t = g_axf16
    BEGIN WORK
    WHILE TRUE
        CALL i003_i("u") 
        IF INT_FLAG THEN
            LET g_axf16=g_axf16_t
            DISPLAY g_axf16 TO axf16               #單頭
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF cl_null(g_axf16_t) OR g_axf16 != g_axf16_t THEN
           UPDATE axf_file 
              SET axf16 = g_axf16
            WHERE axf00 = g_axf00
              AND axf09 = g_axf09
              AND axf10 = g_axf10
              AND axf12 = g_axf12
              AND axf13 = g_axf13
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","axf_file",g_axf13,g_axf16,SQLCA.sqlcode,"","",1) 
                ROLLBACK WORK
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION


FUNCTION i003_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,     #判斷必要欄位是否有輸入 #No.FUN-680098 VARCHAR(1)
    l_n1,l_n        LIKE type_file.num5,     #No.FUN-680098  smallint
    p_cmd           LIKE type_file.chr1      #a:輸入 u:更改  #No.FUN-680098 VARCHAR(1)
DEFINE l_axf09_cnt  LIKE type_file.num5      #FUN-920049 add                                                                        
DEFINE l_axf10_cnt  LIKE type_file.num5      #FUN-920049 add   
DEFINE l_axf16_cnt  LIKE type_file.num5      #FUN-A30079
DEFINE l_i          LIKE type_file.num5      #FUN-A70107
DEFINE l_axf16_level LIKE type_file.num5     #FUN-A70107
DEFINE l_axf09_level LIKE type_file.num5     #FUN-A70107
DEFINE l_axf10_level LIKE type_file.num5     #FUN-A70107
DEFINE l_cnt         LIKE type_file.num5     #FUN-A70107

    DISPLAY g_axf13,g_axf09,g_axf10,g_axf00,g_axf12,g_axf16  #FUN-910001 add axf13  #FUN-A30079 add axf16 
         TO axf13,axf09,axf10,axf00,axf12,axf16              #No.FUN-730070     #FUN-910001 add axf13   #FUN-A30079 axf16
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0029  

    #INPUT g_axf13,g_axf09,g_axf00,g_axf10,g_axf12        #FUN-910001 add axf13 #FUN-920049 mark                                    
    # FROM axf13,axf09,axf00,axf10,axf12  #No.FUN-730070  #FUN-910001 add axf13 #FUN-920049 mark                                    
    INPUT g_axf13,g_axf09,g_axf10,g_axf16       #FUN-910001 add axf13 #FUN-A30079 add axf16                                                                      
     WITHOUT DEFAULTS   #FUN-A30079
     FROM axf13,axf09,axf10,axf16               #No.FUN-730070  #FUN-910001 add axf13   #FUN-A30079 add axf16   

    #--FUN-A30079 start--
    BEFORE INPUT
      LET g_before_input_done = FALSE
      CALL i003_set_entry(p_cmd)
      CALL i003_set_no_entry(p_cmd)
      LET g_before_input_done = TRUE
    #--FUN-A30079 end----

    #--FUN-A70107 start--
    AFTER FIELD axf13
        LET l_i = 1   
        LET g_j = 1
        LET g_k = 1
        LET g_flag = 'N'
        CALL i003_level(l_i)    
    #--FUN-A70107 end----

      #--FUN-920049 start---自動依agli009設定帳別帶出顯示--                                                                         
      AFTER FIELD axf09                                                                                                             
         IF NOT cl_null(g_axf09) THEN                                                                                               
             SELECT COUNT(*) INTO l_axf09_cnt                                                                                       
               FROM axz_file                                                                                                        
              WHERE axz01 = g_axf09                                                                                                 
             IF l_axf09_cnt = 0 THEN                                                                                                
                 CALL cl_err('','agl-943',0)                                                                                        
                 NEXT FIELD axf09     
             ELSE                                                                                                                   
                 #--FUN-A30122 start--
                 #CALL i003_axf00(g_axf09,g_axf13)  #FUN-950051 add axf13                                                                                           
                 CALL s_aaz641_dbs(g_axf13,g_axf09) RETURNING g_plant_axz03    #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu  
                 CALL s_get_aaz641(g_plant_axz03) RETURNING g_axf00            #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu
                 #---FUN-A30122 end---
                 DISPLAY g_axf00 TO axf00                                                                                           
                 IF cl_null(g_axf16) THEN  #FUN-A70107
                     LET g_axf16 = g_axf09     #FUN-A30079 add
                     DISPLAY g_axf16 TO axf16  #FUN-A30079 add
                 END IF                    #FUN-A70107
             END IF                                                                                                                 
         END IF                                                                                                                     
      #--FUN-920049 end-----   
 
      #str FUN-740172 add
      #對沖公司代碼(axf10)不可與來源公司代碼(axf09)相同
      AFTER FIELD axf10 
         IF NOT cl_null(g_axf10) THEN
            #--FUN-920049 start-----                                                                                               
             SELECT COUNT(*) INTO l_axf10_cnt                                                                                       
               FROM axz_file                                                                                                        
              WHERE axz01 = g_axf10                                                                                                 
             IF l_axf10_cnt = 0 THEN                                                                                                
                 CALL cl_err('','agl-943',0)                                                                                        
                 NEXT FIELD axf10                                                                                                   
             ELSE                                                                                                                   
                 CALL i003_axf12(g_axf10,g_axf13)   #FUN-950051 add axf13  #FUN-9C0160 mod
                 #CALL i003_axf12(g_axf09,g_axf13)   #FUN-950051 add axf13   #MOD-960314 #FUN-9C0160 mark
                 DISPLAY g_axf12 TO axf12                                                                                           
             END IF                                                                                                                 
             #--FUN-920049 end-----  
 
            IF g_axf10 = g_axf09 THEN
               CALL cl_err(g_axf10,'agl-945',0)   #對沖公司代碼不可與來源公司代碼相同!
               NEXT FIELD axf10
            END IF
         END IF
      #end FUN-740172 add

#---FUN-A30079 start--
      AFTER FIELD axf16                                                                                                             
         IF NOT cl_null(g_axf16) THEN                                                                                               
             SELECT COUNT(*) INTO l_axf16_cnt                                                                                       
               FROM axz_file                                                                                                        
              WHERE axz01 = g_axf16                                                                                                 
             IF l_axf16_cnt = 0 THEN                                                                                                
                 CALL cl_err('','agl-943',0)                                                                                        
                 LET g_axf16 = g_axf16_t  #FUN-A70107
                 DISPLAY BY NAME g_axf16  #FUN-A70107
                 NEXT FIELD axf16                                                                                                   
             END IF
             #--FUN-A70107 start--
             LET l_cnt = 0
             SELECT COUNT(*)
               INTO l_cnt
               FROM i003_axa_file
              WHERE axb02 = g_axf16
             IF l_cnt = 0 THEN
                 CALL cl_err('','agl030',0)
                 LET g_axf16 = g_axf16_t
                 DISPLAY BY NAME g_axf16
                 NEXT FIELD axf16
             END IF
             LET l_axf16_level = 0
             LET l_axf09_level = 0
             LET l_axf10_level = 0
             LET g_sql = "SELECT count ",
                         "  FROM i003_axa_file ",
                         " WHERE axb02 = '",g_axf16,"'"
                         PREPARE i003_axf16_p1 FROM g_sql                                                                                                  
                         DECLARE i003_axf16_c1 CURSOR FOR i003_axf16_p1                                                                                      
                         OPEN i003_axf16_c1                                                                                                                
                         FETCH i003_axf16_c1 INTO l_axf16_level                                                                                                  
                         CLOSE i003_axf16_c1
             LET g_sql = "SELECT count ",
                         "  FROM i003_axa_file ",
                         " WHERE axb02 = '",g_axf09,"'"
                         PREPARE i003_axf16_p2 FROM g_sql                                                                                                  
                         DECLARE i003_axf16_c2 CURSOR FOR i003_axf16_p2                                                                                      
                         OPEN i003_axf16_c2                                                                                                                
                         FETCH i003_axf16_c2 INTO l_axf09_level                                                                                                  
                         CLOSE i003_axf16_c2
             LET g_sql = "SELECT count ",
                         "  FROM i003_axa_file ",
                         " WHERE axb02 = '",g_axf10,"'"
                         PREPARE i003_axf16_p3 FROM g_sql                                                                                                  
                         DECLARE i003_axf16_c3 CURSOR FOR i003_axf16_p3                                                                                      
                         OPEN i003_axf16_c3                                                                                                                
                         FETCH i003_axf16_c3 INTO l_axf10_level                                                                                                  
                         CLOSE i003_axf16_c3
             IF l_axf16_level > l_axf09_level THEN
                 CALL cl_err('','agl028',0)
                 LET g_axf16 = g_axf16_t
                 DISPLAY BY NAME g_axf16
                 NEXT FIELD axf16
             END IF 
             IF l_axf16_level > l_axf10_level THEN
                 CALL cl_err('','agl029',0)
                 LET g_axf16 = g_axf16_t
                 DISPLAY BY NAME g_axf16
                 NEXT FIELD axf16
             END IF  
             #--FUN-A70107 end---
         END IF
#---FUN-A30079 end----

      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF   #FUN-760053 add
         IF p_cmd = 'a' THEN   #FUN-A30079 add
             IF NOT cl_null(g_axf09) AND NOT cl_null(g_axf10) AND 
                NOT cl_null(g_axf00) AND NOT cl_null(g_axf12) AND
                NOT cl_null(g_axf13) THEN   #FUN-910001 add 
                IF g_axf13_t IS NULL OR (g_axf13 != g_axf13_t) OR   #FUN-910001 add  
                   g_axf09_t IS NULL OR (g_axf09 != g_axf09_t) OR
                   g_axf00_t IS NULL OR (g_axf00 != g_axf00_t) OR
                   g_axf10_t IS NULL OR (g_axf10 != g_axf10_t) OR
                   g_axf12_t IS NULL OR (g_axf12 != g_axf12_t) THEN
                   SELECT COUNT(*) INTO l_n FROM axf_file
                    WHERE axf09 = g_axf09 AND axf10 = g_axf10
                      AND axf00 = g_axf00 AND axf12 = g_axf12
                      AND axf13 = g_axf13   #FUN-910001 add 
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      NEXT FIELD axf09
                   END IF
                END IF
             END IF
         END IF  #FUN-A30079 add
      #No.FUN-730070  --End  
#end FUN-580063
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLP
           CASE 
             #str FUN-910001 add                                                                                                    
              WHEN INFIELD(axf13) #族群代號                                                                                         
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form ="q_axa1"                                                                                      
                 LET g_qryparam.default1 = g_axf13                                                                                  
                 CALL cl_create_qry() RETURNING g_axf13                                                                             
                 DISPLAY BY NAME g_axf13                                                                                            
                 NEXT FIELD axf13                                                                                                   
             #end FUN-910001 add
              WHEN INFIELD(axf09) #來源公司代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axz"
                 LET g_qryparam.default1 = g_axf09
                 CALL cl_create_qry() RETURNING g_axf09
                 DISPLAY BY NAME g_axf09            #No:MOD-490344
                 NEXT FIELD axf09
              WHEN INFIELD(axf10) #對沖公司代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axz"
                 LET g_qryparam.default1 = g_axf10
                 CALL cl_create_qry() RETURNING g_axf10
                  DISPLAY BY NAME g_axf10            #No:MOD-490344
                 NEXT FIELD axf10
              #No.FUN-730070  --Begin
              WHEN INFIELD(axf00)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.default1 = g_axf00
                 CALL cl_create_qry() RETURNING g_axf00
                 DISPLAY BY NAME g_axf00
                 NEXT FIELD axf00
              WHEN INFIELD(axf12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.default1 = g_axf12
                 CALL cl_create_qry() RETURNING g_axf12
                 DISPLAY BY NAME g_axf12
                 NEXT FIELD axf12
              #No.FUN-730070  --End  
#---FUN-A30079 start--
              WHEN INFIELD(axf16)  #合併主體
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axz"
                 LET g_qryparam.default1 = g_axf16
                 CALL cl_create_qry() RETURNING g_axf16
                 DISPLAY BY NAME g_axf16
                 NEXT FIELD axf16
#-- FUN-A30079 end---
#end FUN-580063
              OTHERWISE EXIT CASE
          END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
 
    END INPUT
END FUNCTION

#Query 查詢
FUNCTION i003_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_axf13 TO NULL               #FUN-910001 add 
    INITIALIZE g_axf09 TO NULL               #NO.FUN-6B0040
    INITIALIZE g_axf10 TO NULL               #No.FUN-730070
    INITIALIZE g_axf00 TO NULL               #No.FUN-730070
    INITIALIZE g_axf12 TO NULL               #No.FUN-730070
    INITIALIZE g_axf16 TO NULL               #FUN-A30079
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_axf.clear()
    LET g_rec_b = 0                          #FUN-A30122 add 
    CALL i003_cs()                           #取得查詢條件
    IF INT_FLAG THEN                         #使用者不玩了
        LET INT_FLAG = 0 
        RETURN
    END IF
    OPEN i003_bcs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                    #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_axf13 TO NULL               #FUN-910001 add
        INITIALIZE g_axf09 TO NULL
        INITIALIZE g_axf10 TO NULL               #No.FUN-730070
        INITIALIZE g_axf00 TO NULL               #No.FUN-730070
        INITIALIZE g_axf12 TO NULL               #No.FUN-730070
        INITIALIZE g_axf16 TO NULL               #FUN-A30079
    ELSE
        OPEN i003_cnt
        FETCH i003_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i003_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION i003_fetch(p_flag)
DEFINE                                                                  
    p_flag          LIKE type_file.chr1,   #處理方式          #No.FUN-680098 VARCHAR(1)
    l_abso          LIKE type_file.num10   #絕對的筆數        #No.FUN-680098 integer

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i003_bcs INTO g_axf13,g_axf09,g_axf10,g_axf00,g_axf12  #No.FUN-730070  #FUN-910001 add axf13
        WHEN 'P' FETCH PREVIOUS i003_bcs INTO g_axf13,g_axf09,g_axf10,g_axf00,g_axf12  #No.FUN-730070  #FUN-910001 add axf13
        WHEN 'F' FETCH FIRST    i003_bcs INTO g_axf13,g_axf09,g_axf10,g_axf00,g_axf12  #No.FUN-730070  #FUN-910001 add axf13
        WHEN 'L' FETCH LAST     i003_bcs INTO g_axf13,g_axf09,g_axf10,g_axf00,g_axf12  #No.FUN-730070  #FUN-910001 add axf13
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about
                      CALL cl_about()
 
                   ON ACTION help
                      CALL cl_show_help()
 
                   ON ACTION controlg
                      CALL cl_cmdask()
 
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i003_bcs INTO g_axf13,g_axf09,g_axf10,g_axf00,g_axf12  #No.FUN-730070  #FUN-910001 add axf13
            LET g_no_ask = FALSE
    END CASE

    #SELECT unique axf13,axf09,axf10,axf00,axf12  #No.FUN-730070  #FUN-910001 add axf13
    SELECT unique axf13,axf09,axf10,axf00,axf12,axf16  #FUN-A30079 add axf16
      INTO g_axf13,g_axf09,g_axf10,g_axf00,g_axf12,g_axf16  #FUN-A30079
      FROM axf_file
     WHERE axf09 = g_axf09 AND axf10 = g_axf10
       AND axf00 = g_axf00 AND axf12 = g_axf12  #No.FUN-730070
       AND axf13 = g_axf13   #FUN-910001 add
    IF SQLCA.sqlcode THEN                         #有麻煩
#      CALL cl_err(g_axf09,SQLCA.sqlcode,0)   #No.FUN-660123
       CALL cl_err3("sel","axf_file",g_axf09,g_axf10,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       INITIALIZE g_axf13 TO NULL  #FUN-910001 add
       INITIALIZE g_axf09 TO NULL  #TQC-6B0105
       INITIALIZE g_axf10 TO NULL  #TQC-6B0105
       INITIALIZE g_axf00 TO NULL  #FUN-910001 add                                                                                  
       INITIALIZE g_axf12 TO NULL  #FUN-910001 add 
       INITIALIZE g_axf16 TO NULL  #FUN-A30079 add
    ELSE
        CALL i003_show()
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
FUNCTION i003_show()

#--FUN-A30122 start--
    CALL s_aaz641_dbs(g_axf13,g_axf09) RETURNING g_plant_axz03        #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu
    CALL s_get_aaz641(g_plant_axz03) RETURNING g_axf00                #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu
    CALL s_aaz641_dbs(g_axf13,g_axf10) RETURNING g_plant_gl           #FUN-A30122 mod g_dbs_gl->g_plant_gl by vealxu
    CALL s_get_aaz641(g_plant_gl) RETURNING g_axf12                   #FUN-A30122 mod g_dbs_gl->g_plant_gl by vealxu
#--FUN-A30122 end----

    DISPLAY g_axf09 TO axf09           #單頭
    DISPLAY g_axf10 TO axf10           #單頭
    DISPLAY g_axf00 TO axf00           #No.FUN-730070
    DISPLAY g_axf12 TO axf12           #No.FUN-730070
    DISPLAY g_axf13 TO axf13           #單頭   #FUN-910001 add  
    DISPLAY g_axf16 TO axf16           #FUN-A30079
    CALL i003_b_fill(g_wc)             #單身

    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i003_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc     LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(200)

    #LET g_sql = "SELECT axf14,axf15,axf01,'',axf02,'',axf03,axf04,'',axfacti FROM axf_file ",                      #FUN-950047 mod
    LET g_sql = "SELECT axf19,axf14,axf15,axf01,'',axf17,axf02,'',axf03,axf04,'',axf18,'',axfacti FROM axf_file ",  #FUN-A80137 add axf17   #FUN-D20048 add axf19,axf18,''
                " WHERE axf09 = '",g_axf09,"' AND axf10 = '",g_axf10,"'",
                "   AND axf00 = '",g_axf00,"' AND axf12 = '",g_axf12,"'",  #No.FUN-730070
                "   AND axf13 = '",g_axf13,"'",   #FUN-910001 add 
                " AND ",p_wc CLIPPED ," ORDER BY axf01"
    PREPARE i003_prepare2 FROM g_sql      #預備一下
    DECLARE axf_cs CURSOR FOR i003_prepare2

    CALL g_axf.clear()

    LET g_cnt = 1
    LET g_rec_b = 0

    FOREACH axf_cs INTO g_axf[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF

      CALL i003_aag('a',g_axf[g_cnt].axf01)               #FUN-760053
           RETURNING g_axf[g_cnt].axf01_desc  #No.FUN-730070

      CALL i003_aag('a',g_axf[g_cnt].axf02)               #FUN-760053
           RETURNING g_axf[g_cnt].axf02_desc  #No.FUN-730070

      CALL i003_aag('a',g_axf[g_cnt].axf04)               #FUN-760053
           RETURNING g_axf[g_cnt].axf04_desc  #No.FUN-730070

      #FUN-D20048 add begin---
      CALL i003_aag('a',g_axf[g_cnt].axf18)
           RETURNING g_axf[g_cnt].axf18_desc
      #FUN-D20048 add end-----

      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_axf.deleteElement(g_cnt)
    LET g_rec_b=g_cnt -1

    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION i003_r()

    IF s_shut(0) THEN RETURN END IF
    IF g_axf09 IS NULL
	THEN CALL cl_err('',-400,0) RETURN
    END IF
    IF g_axf10 IS NULL
	THEN CALL cl_err('',-400,0) RETURN
    END IF
    #No.FUN-730070  --Begin
    IF g_axf00 IS NULL OR g_axf12 IS NULL
	THEN CALL cl_err('',-400,0) RETURN
    END IF
    #No.FUN-730070  --End  
    #FUN-750058...........begin
    IF NOT cl_null(g_axf[1].axf01) THEN    #FUN-920049  避免輸入完單頭馬上按刪除時單身無值會當掉 
        IF NOT i003_chk_source_acc() THEN
           RETURN
        END IF
    END IF
    IF NOT cl_null(g_axf[1].axf01) THEN    #FUN-920049  
       IF NOT i003_chk_oppsite_acc() THEN
          RETURN
       END IF
    END IF                                    #FUN-920049     
    #FUN-750058...........end
    #MOD-D10110--str
    IF NOT cl_null(g_axf[1].axf01) THEN    
       IF NOT i003_chk_formula_acc() THEN
          RETURN
       END IF
    END IF
    #MOD-D10110--end
    BEGIN WORK
    IF cl_delh(15,16) THEN
        DELETE FROM axf_file WHERE axf09=g_axf09 AND axf10=g_axf10
                               AND axf00=g_axf00 AND axf12=g_axf12  #No.FUN-730070
                               AND axf13=g_axf13   #FUN-910001 add 
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_axf09,SQLCA.sqlcode,0)   #No.FUN-660123
           CALL cl_err3("del","axf_file",g_axf09,g_axf10,SQLCA.sqlcode,"","",1)  #No.FUN-660123
        ELSE
           CLEAR FORM
           CALL g_axf.clear()
           LET g_sql = "SELECT UNIQUE axf13,xf09, axf10,axf00,axf12 ",  #No.FUN-730070  #FUN-910001 add axf13
                       "  FROM axf_file ",
                       " INTO TEMP y "
           DROP TABLE y
           #No.FUN-730070  --Begin
           PREPARE i003_pre_y FROM g_sql 
           EXECUTE i003_pre_y           
           #No.FUN-730070  --End  
           LET g_sql = "SELECT COUNT(*) FROM y"
           PREPARE i003_precnt2 FROM g_sql
           DECLARE i003_cnt2 CURSOR FOR i003_precnt2
           OPEN i003_cnt2
           #FUN-B50062-add-start--
           IF STATUS THEN
              CLOSE i003_bcs
              CLOSE i003_cnt2 
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end-- 
           FETCH i003_cnt2 INTO g_row_count
           #FUN-B50062-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i003_bcs
              CLOSE i003_cnt2 
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end-- 
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i003_bcs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i003_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET g_no_ask = TRUE
              CALL i003_fetch('/')
           END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION

#單身
FUNCTION i003_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT #No.FUN-680098 smallint
    l_n             LIKE type_file.num5,         #檢查重複用        #No.FUN-680098 smallint
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否        #No.FUN-680098 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #處理狀態          #No.FUN-680098 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,         #可新增否          #No.FUN-680098 smallint
    l_allow_delete  LIKE type_file.num5,         #可刪除否          #No.FUN-680098 smallint
    l_cmd           STRING,                      #TQC-760030 add
    l_cnt           LIKE type_file.num5          #FUN-D20048 add

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    
    #---FUN-920049 start--                                                                                                           
   #找出單頭輸入上層公司所在DB及agls101中aaz641設定合并帳別資料                                                                     
   #後續單身對衝科目檢查皆以此DB+合并帳別做為檢查依據及開窗資料                                                                     
   #CALL i003_axf00(g_axf09,g_axf13)  #FUN-950051 add axf13  #FUN-A30122 mark                                                                                                         
   #---FUN-920049 end---    

    CALL s_aaz641_dbs(g_axf13,g_axf09) RETURNING g_plant_axz03  #FUN-A30122 add    #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu
    CALL s_get_aaz641(g_plant_axz03) RETURNING g_axf00          #FUN-A30122 add    #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu
    LET g_plant_new = g_plant_axz03                             #FUN-A30122 add by vealxu

    #LET g_forupd_sql = "SELECT axf14,axf15,axf01,'',axf02,'',axf03,axf04,'',axfacti FROM axf_file ",                            #FUN-950047
    LET g_forupd_sql = "SELECT axf19,axf14,axf15,axf01,'',axf17,axf02,'',axf03,axf04,'',axf18,'',axfacti FROM axf_file ",        #FUN-A80137 add axf17   #FUN-D20048 add axf19,axf18,''
                       "WHERE axf13 = ? AND axf09=? AND axf10=? AND axf00=? AND axf12=? AND axf01= ? AND axf02 = ? FOR UPDATE "  #FUN-950047 #NO.FUN-930117 add axf02
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i003_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_axf WITHOUT DEFAULTS FROM s_axf.*
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

            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_axf13_t = g_axf13        #BACKUP  #FUN-910001 add 
               LET g_axf09_t = g_axf09        #BACKUP
               LET g_axf10_t = g_axf10        #BACKUP
               LET g_axf00_t = g_axf00        #BACKUP  #No.FUN-730070
               LET g_axf12_t = g_axf12        #BACKUP  #No.FUN-730070
               LET g_axf_t.* = g_axf[l_ac].*  #BACKUP
               OPEN i003_bcl USING g_axf13,g_axf09,g_axf10,g_axf00,g_axf12,g_axf[l_ac].axf01,  #No.FUN-730070  #FUN-910001 add axf13
                                   g_axf[l_ac].axf02   #FUN-930117
               IF STATUS THEN
                  CALL cl_err("OPEN i003_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i003_bcl INTO g_axf[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_axf_t.axf01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  LET g_sql = "SELECT aag02 ",
                               #"  FROM ",g_dbs_axz03,"aag_file",
                               "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102
                               " WHERE aag01 = '",g_axf[l_ac].axf01,"'",
                               "   AND aag00 = '",g_axf00,"'"
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
                   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
                   PREPARE i003_pre_04 FROM g_sql
                   DECLARE i003_cur_04 CURSOR FOR i003_pre_04
                   OPEN i003_cur_04
                   FETCH i003_cur_04 INTO g_axf[l_ac].axf01_desc
                   LET g_sql = "SELECT aag02 ",
                              #"  FROM ",g_dbs_axz03,"aag_file",  #FUN-A50102
                               "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102
                               " WHERE aag01 = '",g_axf[l_ac].axf02,"'",
                               "   AND aag00 = '",g_axf00,"'"
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
                   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
                   PREPARE i003_pre_05 FROM g_sql
                   DECLARE i003_cur_05 CURSOR FOR i003_pre_05
                   OPEN i003_cur_05
                   FETCH i003_cur_05 INTO g_axf[l_ac].axf02_desc
                   LET g_sql = "SELECT aag02 ",
                              #"  FROM ",g_dbs_axz03,"aag_file",  #FUN-A50102
                               "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102
                               " WHERE aag01 = '",g_axf[l_ac].axf04,"'",
                               "   AND aag00 = '",g_axf00,"'"
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
                   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
                   PREPARE i003_pre_08 FROM g_sql
                   DECLARE i003_cur_08 CURSOR FOR i003_pre_08
                   OPEN i003_cur_08
                   FETCH i003_cur_08 INTO g_axf[l_ac].axf04_desc
                  #--FUN-920140 end----
               END IF
               CALL cl_show_fld_cont()
            END IF

        LET g_before_input_done = FALSE
        CALL i003_set_entry(p_cmd)
        CALL i003_set_no_entry(p_cmd)
       #CALL i003_set_required(p_cmd)      #FUN-740170 add   #FUN-760053 mark
       #CALL i003_set_no_required(p_cmd)   #FUN-740170 add   #FUN-760053 mark 
        LET g_before_input_done = TRUE
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108 --start--
            LET  g_before_input_done = FALSE
            CALL i003_set_entry(p_cmd)
            CALL i003_set_no_entry(p_cmd)
           #CALL i003_set_required(p_cmd)      #FUN-740170 add   #FUN-760053 mark
           #CALL i003_set_no_required(p_cmd)   #FUN-740170 add   #FUN-760053 mark 
            LET  g_before_input_done = TRUE
#No.FUN-570108 --end--
            INITIALIZE g_axf[l_ac].* TO NULL
           #----------No:MOD-740403 add
            LET g_axf[l_ac].axf03  ='N'
            LET g_axf[l_ac].axfacti='Y'
            LET g_axf[l_ac].axf14 = 'N'         #FUN-950047
            LET g_axf[l_ac].axf15 = '1'         #FUN-950047
            LET g_axf[l_ac].axf17 = '1'         #FUN-A80137
           #----------No:MOD-740403 end
            LET g_axf_t.* = g_axf[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()
            #NEXT FIELD axf01
            #NEXT FIELD axf14     #FUN-940047    #FUN-D20048 mark
            NEXT FIELD axf19      #FUN-D20048 add

        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              INITIALIZE g_axf[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_axf[l_ac].* TO s_axf.*
              CALL g_axf.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            #IF NOT cl_null(g_axf[l_ac].axf01) THEN   #FUN-920049 add     
            IF NOT cl_null(g_axf[l_ac].axf01) AND NOT cl_null(g_axf[l_ac].axf02) THEN   #FUN-920049 add   #FUN-A30122 mod  
                INSERT INTO axf_file(axf01,axf02,axf03,axf04,axf05,axf06,axf07,
                                     #axf08,axf09,axf10,axfacti,axfuser,axfgrup,axfmodu,axfdate,axf00,axf12,axf13)  #No.FUN-730070  #FUN-910001 add axf13
                                     axf08,axf09,axf10,axfacti,axfuser,axfgrup,axfmodu,axfdate,axf00,axf12,axf13,   #No.FUN-730070  #FUN-910001 add axf13  
                                     axf14,axf15,axf16,                                                             #FUN-950047  #FUN-A30079 add axf16
                                     axf17,axf18,axf19)                                                             #FUN-A80137  #FUN-D20048 add axf18,axf19
                              VALUES(g_axf[l_ac].axf01,g_axf[l_ac].axf02,g_axf[l_ac].axf03,g_axf[l_ac].axf04,
                                     '','','','',g_axf09,g_axf10,g_axf[l_ac].axfacti,g_user,g_grup,g_user,g_today,g_axf00,g_axf12,g_axf13,   #FUN-910001 add axf13 
                                     g_axf[l_ac].axf14,g_axf[l_ac].axf15,g_axf16,                                   #FUN-950047  #FUN-A30079 add axf16
                                     g_axf[l_ac].axf17,g_axf[l_ac].axf18,g_axf[l_ac].axf19)                         #FUN-A80137  #FUN-D20048 add axf18,axf19
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins","axf_file",g_axf[l_ac].axf01,g_axf09,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                    CANCEL INSERT
                ELSE
                    LET g_rec_b = g_rec_b + 1
                    DISPLAY g_rec_b TO FORMONLY.cn2
                    MESSAGE 'INSERT O.K'
                END IF
            ELSE                           #FUN-920049 add                                                                          
                CALL cl_err('','9044',1)   #FUN-920049 add                                                                          
            END IF                         #FUN-920049 add  

       #FUN-D20048 add begin---
       BEFORE FIELD axf19
          IF cl_null(g_axf[l_ac].axf19) THEN
             SELECT MAX(axf19)+1 INTO g_axf[l_ac].axf19
               FROM axf_file
              WHERE axf00 = g_axf00
                AND axf09 = g_axf09
                AND axf10 = g_axf10
                AND axf12 = g_axf12
                AND axf13 = g_axf13
                AND axf16 = g_axf16
             IF cl_null(g_axf[l_ac].axf19) THEN
                LET g_axf[l_ac].axf19 = 1
             END IF
             DISPLAY BY NAME g_axf[l_ac].axf19
          END IF

       AFTER FIELD axf19
          IF NOT cl_null(g_axf[l_ac].axf19) THEN
             SELECT COUNT(*) INTO l_cnt
               FROM axf_file
              WHERE axf00 = g_axf00
                AND axf09 = g_axf09
                AND axf10 = g_axf10
                AND axf12 = g_axf12
                AND axf13 = g_axf13
                AND axf16 = g_axf16
                AND axf01 <> g_axf[l_ac].axf01
                AND axf02 <> g_axf[l_ac].axf02
                AND axf19 = g_axf[l_ac].axf19
             IF l_cnt > 0 THEN
                CALL cl_err('','axm-396',1)
                NEXT FIELD axf19
             END IF
          END IF
       #FUN-D20048 add end------

       AFTER FIELD axf14 
          IF g_axf[l_ac].axf14 = 'Y' THEN
              FOR i = 1 TO ARR_COUNT()
                  IF i <> l_ac THEN
                      IF g_axf[i].axf14 = 'Y' THEN
                          LET g_axf[l_ac].axf14 = 'N' 
                          DISPLAY BY NAME g_axf[l_ac].axf14
                          CALL cl_err('','agl027',1)
                      END IF
                  END IF
              END FOR
          END IF

        AFTER FIELD axf01   #check axf09+axf10+axf01 是否重複
           IF NOT cl_null(g_axf[l_ac].axf01) THEN
              IF g_axf[l_ac].axf01[1,4]<>'MISC' THEN #FUN-750058
                 IF g_axf13_t     IS NULL OR   #FUN-910001 add 
                    g_axf09_t     IS NULL OR
                    g_axf10_t     IS NULL OR
                    g_axf00_t     IS NULL OR  #No.FUN-730070
                    g_axf12_t     IS NULL OR  #No.FUN-730070
                    g_axf_t.axf01 IS NULL OR
                    g_axf_t.axf02 IS NULL OR   #FUN-930117
                    (g_axf13 != g_axf13_t) OR  #FUN-910001 add
                    (g_axf09 != g_axf09_t) OR
                    (g_axf10 != g_axf10_t) OR
                    (g_axf00 != g_axf00_t) OR  #No.FUN-73070
                    (g_axf12 != g_axf12_t) OR  #No.FUN-73070
                    (g_axf[l_ac].axf01 != g_axf_t.axf01) OR  #FUN-930117 mod
                   (g_axf[l_ac].axf02 != g_axf_t.axf02) THEN #FUN-930117 add
                    SELECT count(*) INTO l_n FROM axf_file
                     WHERE axf09 = g_axf09
                       AND axf10 = g_axf10
                       AND axf00 = g_axf00 AND axf12 = g_axf12  #No.FUN-730070
                       AND axf01 = g_axf[l_ac].axf01
                       AND axf02 = g_axf[l_ac].axf02  #FUN-930117
                       AND axf13 = g_axf13   #FUN-910001 add 
                    IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_axf[l_ac].axf01 = g_axf_t.axf01
                       NEXT FIELD axf01
                    END IF
                 END IF
                #CALL i003_aag('a',g_axf[l_ac].axf01,g_axf00)   #FUN-760053 mark
                 CALL i003_aag('a',g_axf[l_ac].axf01)           #FUN-760053
                      RETURNING g_axf[l_ac].axf01_desc  #No.FUN-730070
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_axf[l_ac].axf01,g_errno,0)
                    #FUN-B20004--begin
                     CALL q_m_aag2(FALSE,FALSE,g_plant_new,g_axf[l_ac].axf01,'23',g_axf00)                                               
                     RETURNING g_axf[l_ac].axf01                         
                    #LET g_axf[l_ac].axf01=g_axf_t.axf01
                    #FUN-B20004--end
                    NEXT FIELD axf01
                 ELSE
                    DISPLAY g_axf[l_ac].axf01_desc TO axf01_desc
                 END IF
              ELSE
                 LET g_axf[l_ac].axf01_desc=NULL
                 DISPLAY BY NAME g_axf[l_ac].axf01_desc
              END IF

              LET l_cmd=g_axf[l_ac].axf01[1,4]   
              IF UPSHIFT(l_cmd) = 'MISC' THEN
                 CALL i003_msa()
              END IF
              #end TQC-760030 add 
           END IF
 
        AFTER FIELD axf02
           IF NOT cl_null(g_axf[l_ac].axf02) THEN
              IF g_axf[l_ac].axf02[1,4]<>'MISC' THEN #FUN-750058
                 CALL i003_aag('a',g_axf[l_ac].axf02)           #FUN-760053
                      RETURNING g_axf[l_ac].axf02_desc  #No.FUN-730070
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_axf[l_ac].axf02,g_errno,0)
                    #FUN-B20004--begin
                    CALL q_m_aag2(FALSE,FALSE,g_plant_new,g_axf[l_ac].axf02,'23',g_axf00) 
                         RETURNING g_axf[l_ac].axf02                          
                    #LET g_axf[l_ac].axf02=g_axf_t.axf02
                    #FUN-B20004--end
                    NEXT FIELD axf02
                 ELSE
                    DISPLAY g_axf[l_ac].axf02_desc TO axf02_desc
                 END IF
              ELSE
                 LET g_axf[l_ac].axf02_desc=NULL
                 DISPLAY BY NAME g_axf[l_ac].axf02_desc
              END IF
              LET l_cmd=g_axf[l_ac].axf02[1,4]   
              IF UPSHIFT(l_cmd) = 'MISC' THEN
                 CALL i003_moa()
              END IF
              #end TQC-760030 add 
           END IF

 
        AFTER FIELD axf03
           IF NOT cl_null(g_axf[l_ac].axf03) THEN
              IF g_axf[l_ac].axf03 NOT MATCHES'[YN]' THEN
                 NEXT FIELD axf03
              END IF
           END IF
 
        AFTER FIELD axf04
           IF NOT cl_null(g_axf[l_ac].axf04) THEN
             #CALL i003_aag('a',g_axf[l_ac].axf04,g_aza.aza81)  #FUN-760053 mark
              CALL i003_aag('a',g_axf[l_ac].axf04)              #FUN-760053
                   RETURNING g_axf[l_ac].axf04_desc  #No.FUN-730070
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_axf[l_ac].axf04,g_errno,0)
                 #FUN-B20004--begin
                 #LET g_axf[l_ac].axf04=g_axf_t.axf04
                 CALL q_m_aag2(FALSE,FALSE,g_plant_new,g_axf[l_ac].axf04,'23',g_axf00) 
                      RETURNING g_axf[l_ac].axf04 
                 #FUN-B20004--end
                 NEXT FIELD axf04
               ELSE
                 DISPLAY g_axf[l_ac].axf02_desc TO axf04_desc
              END IF
           END IF

        #FUN-D20048 add begin---
        AFTER FIELD axf18
           IF NOT cl_null(g_axf[l_ac].axf18) THEN
             #CALL i003_aag('a',g_axf[l_ac].axf18,g_aza.aza81)  #FUN-760053 mark
              CALL i003_aag('a',g_axf[l_ac].axf18)              #FUN-760053
                   RETURNING g_axf[l_ac].axf18_desc  #No.FUN-730070
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_axf[l_ac].axf18,g_errno,0)
                 #FUN-B20004--begin
                 #LET g_axf[l_ac].axf18=g_axf_t.axf18
                 CALL q_m_aag2(FALSE,FALSE,g_plant_new,g_axf[l_ac].axf18,'23',g_axf00)
                      RETURNING g_axf[l_ac].axf18
                 #FUN-B20004--end
                 NEXT FIELD axf18
               ELSE
                 DISPLAY g_axf[l_ac].axf02_desc TO axf18_desc
              END IF
           END IF
        #FUN-D20048 add end-----

        BEFORE DELETE                            #是否取消單身
            IF g_axf_t.axf01 IS NOT NULL THEN
                #FUN-750058...........begin
                IF NOT i003_chk_source_acc() THEN
                   CANCEL DELETE
                END IF
                IF NOT i003_chk_oppsite_acc() THEN
                   CANCEL DELETE
                END IF
                #FUN-750058...........end
                #MOD-D10110--str
                IF NOT i003_chk_formula_acc() THEN
                   CANCEL DELETE
                END IF
                #MOD-D10110--end
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                  #No.FUN-9B0098 10/02/23
                LET g_doc.column1 = "axf01"                 #No.FUN-9B0098 10/02/23
                LET g_doc.column2 = "axf02"                 #No.FUN-9B0098 10/02/23
                LET g_doc.value1 = g_axf[l_ac].axf01        #No.FUN-9B0098 10/02/23
                LET g_doc.value2 = g_axf[l_ac].axf02        #No.FUN-9B0098 10/02/23
                CALL cl_del_doc()                                                #No.FUN-9B0098 10/02/23

                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF

                DELETE FROM axf_file
                 WHERE axf01 = g_axf_t.axf01 AND axf09 = g_axf09   #FUN-770069 mod
                   AND axf10 = g_axf10
                   AND axf02 = g_axf_t.axf02   #FUN-930117 add
                   AND axf00 = g_axf00 AND axf12 = g_axf12  #No.FUN-730070
                   AND axf13 = g_axf13   #FUN-910001 add 
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_axf10_t,SQLCA.sqlcode,0)   #No.FUN-660123
                   CALL cl_err3("del","axf_file",g_axf_t.axf01,g_axf09,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

            COMMIT WORK

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_axf[l_ac].* = g_axf_t.*
               CLOSE i003_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_axf[l_ac].axf01,-263,1)
               LET g_axf[l_ac].* = g_axf_t.*
            ELSE
               UPDATE axf_file SET axf01 = g_axf[l_ac].axf01,
                                   axf02 = g_axf[l_ac].axf02,
                                   axf03 = g_axf[l_ac].axf03,
                                   axf04 = g_axf[l_ac].axf04,
                                   axf14 = g_axf[l_ac].axf14,   #FUN-950047
                                   axf15 = g_axf[l_ac].axf15,   #FUN-950047
                                   axf17 = g_axf[l_ac].axf17,   #FUN-A80137
                                   axf18 = g_axf[l_ac].axf18,   #FUN-D20048 add
                                   axf19 = g_axf[l_ac].axf19,   #FUN-D20048 add
                                   axfacti = g_axf[l_ac].axfacti,   #MOD-AB0238
                                   axfmodu = g_user,
                                   axfdate = g_today
                WHERE axf01 = g_axf_t.axf01 AND axf09 = g_axf09
                  AND axf10 = g_axf10
                  AND axf00 = g_axf00 AND axf12 = g_axf12  #No.FUN-730070
                  AND axf13 = g_axf13   #FUN-910001 add
                  AND axf02 = g_axf_t.axf02  #FUN-930117 add
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","axf_file",g_axf_t.axf01,g_axf09,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                  LET g_axf[l_ac].* = g_axf_t.*
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
               #LET g_axf[l_ac].* = g_axf_t.*  #FUN-D30032 mark
               #FUN-D30032--add--str--
               IF p_cmd='u' THEN
                  LET g_axf[l_ac].* = g_axf_t.*
               ELSE
                  CALL g_axf.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
               CLOSE i003_bcl
               #FUN-D30032--add--end--
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032
            LET g_axf_t.* = g_axf[l_ac].*
            CLOSE i003_bcl
            COMMIT WORK
            CALL g_axf.deleteElement(g_rec_b+1)

        ON ACTION mntn_acc_code1
           IF g_axf[l_ac].axf01 = 'MISC' THEN        #MOD-A50193 add  
              CALL cl_err('','agl-255',1)             #MOD-A50193 add
              CONTINUE INPUT                         #MOD-A50193 add 
           ELSE                                      #MOD-A50193 add     
              LET g_msg = "agli102 '",g_axf00,"' '",g_axf[l_ac].axf01 ,"' " #MOD-4C0171  #No.FUN-730070
              CALL cl_cmdrun(g_msg)
           END IF                #MOD-A50193 add
        ON ACTION mntn_acc_code2
           IF g_axf[l_ac].axf02 = 'MISC' THEN        #MOD-A50193 add  
              CALL cl_err('','agl-256',1)             #MOD-A50193 add
              CONTINUE INPUT                         #MOD-A50193 add 
           ELSE                                      #MOD-A50193 add     
              LET g_msg = "agli102 '",g_axf12,"' '",g_axf[l_ac].axf02 ,"' " #MOD-4C0171  #No.FUN-730070
              CALL cl_cmdrun(g_msg)
           END IF                #MOD-A50193 add 
        ON ACTION mntn_acc_code4
          #LET g_msg = "agli102 '",g_aza.aza81,"' '",g_axf[l_ac].axf04 ,"' " #MOD-4C0171  #No.FUN-730070   #FUN-760053 mark
           LET g_msg = "agli102 '",g_axf00,"' '",g_axf[l_ac].axf04 ,"' "     #MOD-4C0171  #No.FUN-730070   #FUN-760053
           CALL cl_cmdrun(g_msg)

        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(axf01) AND l_ac > 1 THEN
              LET g_axf[l_ac].* = g_axf[l_ac-1].*
              NEXT FIELD axf01
           END IF

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
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(axf01) #來源會計科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant_new,g_axf[l_ac].axf01,'23',g_axf00)   #TQC-9C0099                                            
                     RETURNING g_axf[l_ac].axf01                                                                                    
                 DISPLAY BY NAME g_axf[l_ac].axf01                                                                                  
                 NEXT FIELD axf01                                                                                                   
              WHEN INFIELD(axf02) #對沖會計科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant_new,g_axf[l_ac].axf02,'23',g_axf00)  #FUN-950051 mark #TQC-9C0099
                     RETURNING g_axf[l_ac].axf02                                                                                    
                 DISPLAY BY NAME g_axf[l_ac].axf02                                                                                  
                 NEXT FIELD axf02                                                                                                   
              WHEN INFIELD(axf04) #差額對應會計科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant_new,g_axf[l_ac].axf04,'23',g_axf00) #TQC-9C0099                                              
                     RETURNING g_axf[l_ac].axf04                                                                                    
                 DISPLAY BY NAME g_axf[l_ac].axf04                                                                                  
                 NEXT FIELD axf04                                                                                                   
              #FUN-D20048 add begin---
              WHEN INFIELD(axf18) #差額對應會計科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant_new,g_axf[l_ac].axf18,'23',g_axf00) #TQC-9C0099
                     RETURNING g_axf[l_ac].axf18
                 DISPLAY BY NAME g_axf[l_ac].axf18
                 NEXT FIELD axf18
              #FUN-D20048 add end-----
              OTHERWISE EXIT CASE
           END CASE
        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")                    
    END INPUT

    CLOSE i003_bcl
    COMMIT WORK

END FUNCTION

FUNCTION i003_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("axf13,axf09,axf10,axf01,axf00,axf12,axf02",TRUE)   #FUN-580063  #No.FUN-730070  #FUN-910001 add axf13  #FUN-930117 add axf02
   END IF
#No.FUN-570108 --end--

   CALL cl_set_comp_entry("axf01,axf02,axf03,axf04,axf18",TRUE)  #FUN-960093   #FUN-D20048 add axf18
END FUNCTION

FUNCTION i003_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)

   IF p_cmd = 'u' AND g_chkey='N' THEN  #FUN-A30079 mod
       CALL cl_set_comp_entry("axf13,axf09,axf10,axf00,axf12",FALSE)  #FUN-580063  #No.FUN-730070  #FUN-910001 add axf13  #FUN-930117 add axf02   #FUN-960093 mod
   END IF
END FUNCTION

#-->檢查科目名稱
FUNCTION i003_aag(p_cmd,p_act)
   DEFINE  p_cmd      LIKE type_file.chr1,     #No.FUN-680098 VARCHAR(1)
           p_act      LIKE aag_file.aag01,
          #p_bookno   LIKE aag_file.aag00,     #No.FUN-730070   #FUN-760053 mark
           l_aag02    LIKE aag_file.aag02,
           l_aag03    LIKE aag_file.aag03,
           l_aag07    LIKE aag_file.aag07,
           l_aagacti  LIKE aag_file.aagacti

   LET g_errno = ' '

   LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",                                                                                 
               #"  FROM ",g_dbs_axz03,"aag_file",                                                                                    
               "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102                                                                                  
               " WHERE aag01 = '",p_act,"'",                                                                                        
               "   AND aag00 = '",g_axf00,"'"                                                                                       
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE i003_pre_03 FROM g_sql                                                                                                   
   DECLARE i003_cur_03 CURSOR FOR i003_pre_03                                                                                       
   OPEN i003_cur_03                                                                                                                 
   FETCH i003_cur_03 INTO l_aag02,l_aag03,l_aag07,l_aagacti                                                                         
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
        WHEN l_aagacti = 'N'     LET g_errno = '9028'
        WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
       #WHEN l_aag03 != '2'      LET g_errno = 'agl-201'   #CHI-9C0038
        OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE

   RETURN l_aag02

END FUNCTION

FUNCTION i003_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_axf TO s_axf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

#--FUN-A30079 start--
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
#--FUN-A30079 end---

      ON ACTION first
         CALL i003_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i003_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL i003_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION next
         CALL i003_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION last
         CALL i003_fetch('L')
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
 
      ON ACTION about
         CALL cl_about()
      
      #FUN-750058................begin
#@    ON ACTION MISC來源科目設定
      ON ACTION misc_source_acc
         LET g_action_choice="misc_source_acc"
         EXIT DISPLAY

#@    ON ACTION MISC對沖科目設定
      ON ACTION misc_opposite_acc
         LET g_action_choice="misc_opposite_acc"
         EXIT DISPLAY
      #FUN-750058................end

#@    ON ACTION 相關文件
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i003_copy()
DEFINE
    l_axf		RECORD LIKE axf_file.*,
    l_n                 LIKE type_file.num5,                #檢查重複用        #No.FUN-680098 smallint
    l_old13,l_new13     LIKE axf_file.axf13,  #FUN-910001 add 
    l_old09,l_new09     LIKE axf_file.axf09,
    l_old10,l_new10	LIKE axf_file.axf10,
    l_old00,l_new00     LIKE axf_file.axf00,  #No.FUN-730070
    l_old12,l_new12	LIKE axf_file.axf12   #No.FUN-730070
DEFINE l_old16,l_new16  LIKE axf_file.axf16   #FUN-A30079
DEFINE l_axf09_cnt      LIKE type_file.num5   #FUN-920049  add                                                                      
DEFINE l_axf10_cnt      LIKE type_file.num5   #FUN-920049  add 
DEFINE l_axt03          LIKE axt_file.axt03   #MOD-CC0202 add
DEFINE l_sql            STRING                #MOD-CC0202 add
 
    IF s_shut(0) THEN RETURN END IF

    IF cl_null(g_axf09) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF cl_null(g_axf10) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #No.FUN-730070  --Begin
    IF cl_null(g_axf00) OR cl_null(g_axf12) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #No.FUN-730070  --End  
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 

    #---FUN-9C0160 start---
    LET l_old13 = g_axf13  
    LET l_old09 = g_axf09    
    LET l_old10 = g_axf10    
    LET l_old00 = g_axf00  
    LET l_old12 = g_axf12 
    #--FUN-9C0160 end---
    LET l_old16 = g_axf16  #FUN-A30079 add
    
   #-MOD-AB0165-add-    
     LET g_before_input_done = FALSE       
     CALL i003_set_entry('a')
     CALL i003_set_no_entry('a')
     LET g_before_input_done = TRUE      
   #-MOD-AB0165-end-    

    #INPUT l_new13,l_new09,l_new00,l_new10,l_new12        #FUN-910001 add l_new13                                                   
    #INPUT l_new13,l_new09,l_new10          #FUN-920049 mod                                                                          
    INPUT l_new13,l_new09,l_new10,l_new16   #FUN-A30079 add axf16
     #FROM axf13,axf09,axf00,axf10,axf12  #No.FUN-730070  #FUN-910001 add axf13                                                     
     #FROM axf13,axf09,axf10                #FUN-920049 mod  
     FROM axf13,axf09,axf10,axf16           #FUN-A30079 add axf16

    AFTER FIELD axf09   #check axf09+axf10 是否重複
       IF NOT cl_null(l_new09) THEN
          #--FUN-920049 start---自動依agli009設定帳別帶出顯示--                                                                    
           SELECT COUNT(*) INTO l_axf09_cnt                                                                                         
             FROM axz_file                                                                                                          
            WHERE axz01 = l_new09                                                                                                   
           IF l_axf09_cnt = 0 THEN                                                                                                  
               CALL cl_err('','agl-943',0)                                                                                          
               NEXT FIELD axf09                                                                                                     
           ELSE           
               #CALL i003_axf00(l_new09,l_new13)   #FUN-950051 add l_new13                                                                                            
               CALL s_aaz641_dbs(l_new13,l_new09) RETURNING g_plant_axz03  #FUN-A30122 add   #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu
               CALL s_get_aaz641(g_plant_axz03) RETURNING g_axf00          #FUN-A30122 add   #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu
               DISPLAY g_axf00 TO axf00                                                                                             
           END IF                                                                                                                   
           #--FUN-920049 end-----   

          SELECT COUNT(*) INTO l_n FROM axf_file
           WHERE axf09 = l_new09
             AND axf10 = l_new10
             AND axf00 = l_new00 AND axf12 = l_new12  #No.FUN-73070
             AND axf13 = l_new13   #FUN-910001 add
          IF l_n > 0 THEN
             CALL cl_err('',-239,0)
             NEXT FIELD axf09
          END IF
          #--FUN-920049 start---自動依agli009設定帳別帶出顯示--                                                                     
#         CALL i003_axf00(l_new09,l_new13)   #FUN-950051 add l_new13  #FUN-A30122 mark                                                                                                  
          DISPLAY g_axf00 TO axf00                   
          LET l_new00=g_axf00                                 #No.TQC-960366                                                                              
          #--FUN-920049 end-----    
       END IF

    AFTER FIELD axf10   #check axf09+axf10 是否重複
       IF NOT cl_null(l_new10) THEN
          #--FUN-920049 start---自動依agli009設定帳別帶出顯示--                                                                    
           SELECT COUNT(*) INTO l_axf10_cnt                                                                                         
             FROM axz_file                                                                                                          
            WHERE axz01 = l_new10                                                                                                   
           IF l_axf10_cnt = 0 THEN                                                                                                  
               CALL cl_err('','agl-943',0)                                                                                          
               NEXT FIELD axf10                                                                                                     
           ELSE                                                                                                                     
              #CALL i003_axf12(l_new10,l_new13)  #FUN-950051 add l_new13  
               CALL s_aaz641_dbs(l_new13,l_new10) RETURNING g_plant_gl  #FUN-A30122 add     #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu
               CALL s_get_aaz641(g_plant_gl) RETURNING g_axf12          #FUN-A30122 add     #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu
               DISPLAY g_axf12 TO axf12                                  
               LET l_new12=g_axf12                            #No.TQC-960366                                                           
           END IF                                                                                                                   
           #--FUN-920049 end----- 
 
          SELECT COUNT(*) INTO l_n FROM axf_file
           WHERE axf09 = l_new09
             AND axf10 = l_new10
             AND axf00 = l_new00 AND axf12 = l_new12  #No.FUN-73070
             AND axf13 = l_new13   #FUN-910001 add  
          IF l_n > 0 THEN
             CALL cl_err('',-239,0)
             NEXT FIELD axf10
          END IF
          #str FUN-740172 add
          IF NOT cl_null(l_new10) THEN
             IF l_new10 = l_new09 THEN
                CALL cl_err(l_new10,'agl-945',0)   #對沖公司代碼不可與來源公司代碼相同!
                NEXT FIELD axf10
             END IF
          END IF
          #end FUN-740172 add
          #--FUN-920049 start---自動依agli009設定帳別帶出顯示--                                                                     
          CALL i003_axf12(l_new10,l_new13)  #FUN-950051 add l_new13 
          #CALL i003_axf12(l_new09,l_new13)  #FUN-950051 add l_new13   #MOD-960314 #FUN-9C0160 mark
          DISPLAY g_axf12 TO axf12                                                                                                  
          #--FUN-920049 end-----   
       END IF

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION CONTROLP
          CASE
            #str FUN-910001 add                                                                                                     
             WHEN INFIELD(axf13) #族群代號                                                                                          
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.form ="q_axa1"                                                                                       
                LET g_qryparam.default1 = l_new13                                                                                   
                CALL cl_create_qry() RETURNING l_new13                                                                              
                DISPLAY l_new13 TO axf13                                                                                            
                NEXT FIELD axf13                                                                                                    
            #end FUN-910001 add 
             WHEN INFIELD(axf09) #來源公司代碼
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_axz"
                LET g_qryparam.default1 = l_new09
                CALL cl_create_qry() RETURNING l_new09
                DISPLAY l_new09 TO axf09
                NEXT FIELD axf09
             WHEN INFIELD(axf10) #對沖公司代碼
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_axz"
                LET g_qryparam.default1 = l_new10
                CALL cl_create_qry() RETURNING l_new10
                DISPLAY l_new10 TO axf10
                NEXT FIELD axf10
             #No.FUN-730070  --Begin
             WHEN INFIELD(axf00)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aaa"
                LET g_qryparam.default1 = l_new00
                CALL cl_create_qry() RETURNING l_new00
                DISPLAY l_new00 TO axf00
                NEXT FIELD axf00
             WHEN INFIELD(axf12)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aaa"
                LET g_qryparam.default1 = l_new12
                CALL cl_create_qry() RETURNING l_new12
                DISPLAY l_new12 TO axf12
                NEXT FIELD axf12
             #No.FUN-730070  --End  
#---FUN-A30079 start--
             WHEN INFIELD(axf16)   #合併主體
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_axz"
                LET g_qryparam.default1 = l_new16
                CALL cl_create_qry() RETURNING l_new16
                DISPLAY l_new09 TO axf16
                NEXT FIELD axf16
#---FUN-A30079 end---
             OTHERWISE EXIT CASE
          END CASE
 
    END INPUT

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY g_axf13 TO axf13  #FUN-910001 add  
        DISPLAY g_axf09 TO axf09
        DISPLAY g_axf10 TO axf10  #No.FUN-730070
        DISPLAY g_axf00 TO axf00  #No.FUN-730070
        DISPLAY g_axf12 TO axf12  #No.FUN-730070
        DISPLAY g_axf16 TO axf16  #FUN-A30079 add
        RETURN
    END IF

    DROP TABLE x

    SELECT *
      FROM axf_file         #單頭複製
     WHERE axf09 = l_old09 AND axf10 = l_old10
       AND axf00 = l_old00 AND axf12 = l_old12 
       AND axf13 = l_old13
     #--FUN-9C0160 end---
       INTO TEMP x
    IF SQLCA.sqlcode THEN
       #CALL cl_err3("ins","x",g_axf09,g_axf10,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       CALL cl_err3("ins","x",l_old09,g_axf10,SQLCA.sqlcode,"","",1)  #No.FUN-660123 #FUN-9C0160 mod
       RETURN
    END IF

    UPDATE x
       SET axf09 = l_new09,axf10 = l_new10,
           axf00 = l_new00,axf12 = l_new12,  #No.FUN-730070
           axf13 = l_new13,axf16 = l_new16   #FUN-910001 add #MOD-B20063 add axf16

    INSERT INTO axf_file
       SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","axf_file",l_new09,l_new10,SQLCA.sqlcode,"","axf:",1)  #No.FUN-660123
       RETURN
    END IF
   #---------------------------MOD-CC0202-------------------(S)
    DROP TABLE s
    SELECT * FROM axs_file
     WHERE axs00 = l_old00
       AND axs09 = l_old09
       AND axs10 = l_old10
       AND axs12 = l_old12
       AND axs13 = l_old13
      INTO TEMP s

    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","s",l_old09,g_axf10,SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    UPDATE s
       SET axs09 = l_new09,axs10 = l_new10,
           axs00 = l_new00,axs12 = l_new12,
           axs13 = l_new13
    INSERT INTO axs_file
       SELECT * FROM s
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","axs_file",l_new09,l_new10,SQLCA.sqlcode,"","axs:",1)
       RETURN
    END IF

    DROP TABLE t
    SELECT * FROM axt_file
     WHERE axt00 = l_old00
       AND axt09 = l_old09
       AND axt10 = l_old10
       AND axt12 = l_old12
       AND axt13 = l_old13
      INTO TEMP t

    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","t",l_old09,g_axf10,SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    UPDATE t
       SET axt09 = l_new09,axt10 = l_new10,
           axt00 = l_new00,axt12 = l_new12,
           axt13 = l_new13
    INSERT INTO axt_file
       SELECT * FROM t
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","axt_file",l_new09,l_new10,SQLCA.sqlcode,"","axt:",1)
       RETURN
    END IF
    LET l_sql = "SELECT axt03 FROM axt_file ",
                " WHERE axt00 = '",l_new00,"'",
                " AND axt09 = '",l_new09,"'",
                " AND axt10 = '",l_new10,"'",
                " AND axt12 = '",l_new12,"'",
                " AND axt13 = '",l_new13,"'",
                " AND axt04 = 'Y'"
    PREPARE i003_axt_p FROM l_sql
    IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    DECLARE i003_axt_c CURSOR FOR i003_axt_p
    FOREACH i003_axt_c INTO l_axt03
             DROP TABLE u
             SELECT * FROM axu_file
              WHERE axu00 = l_old00
                AND axu09 = l_old09
                AND axu10 = l_old10
                AND axu12 = l_old12
                AND axu13 = l_old13
                AND axu03 = l_axt03
               INTO TEMP u

             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","u",l_axt03,g_axf10,SQLCA.sqlcode,"","",1)
                RETURN
             END IF
             UPDATE u
                SET axu09 = l_new09,axu10 = l_new10,
                    axu00 = l_new00,axu12 = l_new12,
                    axu13 = l_new13
             INSERT INTO axu_file
                SELECT * FROM u
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","axu_file",l_new09,l_new10,SQLCA.sqlcode,"","axu:",1)
                RETURN
             END IF
    END FOREACH
   #---------------------------MOD-CC0202-------------------(E)

    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_new09,') O.K'

    SELECT unique axf13,axf09,axf10,axf00,axf12,axf16   #FUN-910001 add axf13 #FU N-A30079 add axf16
      INTO g_axf13,g_axf09,g_axf10,g_axf00,g_axf12,g_axf16   #No.FUN-730070   #FUN-910001 add axf13 #FUN-A30079 add axf16
      FROM axf_file
     WHERE axf09 = l_new09 AND axf10 = l_new10
       AND axf00 = l_new00 AND axf12 = l_new12  #No.FUN-730070
       AND axf13 = l_new13   #FUN-910001 add

    CALL i003_b()
    #FUN-C30027---begin
    #SELECT unique axf13,axf09,axf10,axf00,axf12,axf16     #FUN-910001 add axf13   #FUN-A30079 add axf16
    #  INTO g_axf13,g_axf09,g_axf10,g_axf00,g_axf12,g_axf16  #No.FUN-730070  #FUN-910001 add axf13 #FUN-A30079 add axf16
    #  FROM axf_file
    # WHERE axf09 = l_old09 AND axf10 = l_old10
    #   AND axf00 = l_old00 AND axf12 = l_old12  #No.FUN-730070
    #   AND axf13 = l_old13   #FUN-910001 add 
    #
    #CALL i003_show()
    #FUN-C30027---end
END FUNCTION

FUNCTION i003_out()
   DEFINE l_i     LIKE type_file.num5,          #No.FUN-680098 smallilnt
          l_name  LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
          l_axf   RECORD LIKE axf_file.*,
          l_axf01_desc  LIKE aag_file.aag02,
          l_axf02_desc  LIKE aag_file.aag02,
          l_axf04_desc  LIKE aag_file.aag02,
          l_chr   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
DEFINE l_cmd  LIKE type_file.chr1000 
   IF cl_null(g_wc) AND
      NOT cl_null(g_axf00) AND NOT cl_null(g_axf09) AND 
      NOT cl_null(g_axf10) AND NOT cl_null(g_axf12) AND  #FUN-910001 mod                                                             
      NOT cl_null(g_axf13) THEN   #FUN-910001 add
      LET g_wc = " axf00 = '",g_axf00,"' AND ",                                                                                      
                 " axf09 = '",g_axf09,"' AND ",                                                                                      
                 " axf10 = '",g_axf10,"' AND ",                                                                                      
                 " axf12 = '",g_axf12,"' AND ",   #FUN-910001 add                                                                    
                 " axf13 = '",g_axf13,"'"         #FUN-910001 add
   END IF
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
   LET l_cmd = 'p_query "agli003" "',g_axf00,'" "',g_wc CLIPPED,'"'                                                                  
   CALL cl_cmdrun(l_cmd)                                                                                                             
   RETURN
END FUNCTION

FUNCTION i001_axf00(p_cmd,p_axf09,p_axf00)    #FUN-740172
  DEFINE p_cmd     LIKE type_file.chr1,  
         p_axf09   LIKE axf_file.axf09,       #FUN-740172 add
         p_axf00   LIKE axf_file.axf00,
         l_aaaacti LIKE aaa_file.aaaacti,
         l_cnt     LIKE type_file.num5,     #FUN-740172 add
         l_cnt1    LIKE type_file.num5        #FUN-910001 add 
    LET g_errno = ' '
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_axf00
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE

    #str FUN-740172 add
    #合理性檢查,輸入的公司+帳別需存在agli009裡
    IF p_cmd = 'a' AND cl_null(g_errno) THEN
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM axz_file 
        WHERE axz01=p_axf09 AND axz05=p_axf00
       IF l_cnt = 0 THEN
          LET g_errno = 'agl-946'   #輸入之公司+帳別不存在合併報表公司基本資料檔裡!
       END IF
    END IF
    #end FUN-740172 add

   #str FUN-910001 add                                                                                                              
    IF g_axf13 IS NOT NULL AND g_axf09 IS NOT NULL AND                                                                              
       g_axf00 IS NOT NULL THEN                                                                                                     
       LET l_cnt = 0   LET l_cnt1 = 0                                                                                               
       SELECT COUNT(*) INTO l_cnt FROM axa_file                                                                                     
        WHERE axa01=g_axf13 AND axa02=g_axf09                                                                                       
          AND axa03=g_axf00                                                                                                         
       SELECT COUNT(*) INTO l_cnt1 FROM axb_file                                                                                    
        WHERE axb01=g_axf13 AND axb04=g_axf09                                                                                       
          AND axb05=g_axf00                                                                                                         
       IF l_cnt+l_cnt1 = 0 THEN                                                                                                     
          #此資料不存在聯屬公司層級單頭檔(axa_file)中,請重新輸入!                                                                   
          LET g_errno = 'agl-223'                                                                                                   
       END IF                                                                                                                       
    END IF                                                                                                                          
   #end FUN-910001 add 
END FUNCTION
#No.FUN-730070  --End  

FUNCTION i003_msa()   
   DEFINE l_cmd STRING
   IF g_rec_b=0 THEN
      CALL cl_err('','amr-304',0)
      RETURN
   END IF
   LET l_cmd=g_axf[l_ac].axf01[1,4]   
   IF UPSHIFT(l_cmd) <> 'MISC' THEN
      CALL cl_err('','agl-099',0)
      RETURN
   END IF
   CALL s_aaz641_dbs(g_axf13,g_axf09) RETURNING g_plant_axz03 #FUN-A30122 add  #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_axf00         #FUN-A30122 add  #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu

   LET l_cmd="agli0031 '",g_axf00,"' ",     #來源帳別                                                                               
             "'",g_axf[l_ac].axf01,"' ",    #來源會計科目編號                                                                       
             "'",g_axf09,"' ",              #來源公司代碼                                                                           
             "'",g_axf10,"' ",              #對衝公司代碼                                                                           
             #"'",g_axf12,"' ",              #對衝帳別                                                                              
             "'",g_axf00,"' ",              #對衝帳別   #FUN-920049   
             "'",g_axf13,"'"                #族群代號   #FUN-910001 add
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION

FUNCTION i003_moa()
   DEFINE l_cmd STRING
   IF g_rec_b=0 THEN
      CALL cl_err('','amr-304',0)
      RETURN
   END IF
   LET l_cmd=g_axf[l_ac].axf02[1,4]   
   IF UPSHIFT(l_cmd) <> 'MISC' THEN
      CALL cl_err('','agl-123',0)
      RETURN
   END IF

   CALL s_aaz641_dbs(g_axf13,g_axf09) RETURNING g_plant_axz03 #FUN-A30122 add   #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_axf00         #FUN-A30122 add   #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu

   LET l_cmd="agli0032 '",g_axf00,"' ",     #來源帳別
             "'",g_axf[l_ac].axf02,"' ",    #來源會計科目編號
             "'",g_axf09,"' ",              #來源公司代碼
             "'",g_axf10,"' ",              #對沖公司代碼
             #"'",g_axf12,"' ",                #對沖帳別
             "'",g_axf00,"' ",              #對衝帳別   #FUN-920049  
             "'",g_axf13,"'"                #族群代號   #FUN-910001 add
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION

FUNCTION i003_chk_source_acc()
   LET g_sql=g_axf[l_ac].axf01[1,4]
   IF UPSHIFT(g_sql) = 'MISC' THEN
      SELECT COUNT(*) INTO g_cnt FROM axs_file
                                WHERE axs00=g_axf00
                                  AND axs01=g_axf[l_ac].axf01
                                  AND axs09=g_axf09
                                  AND axs10=g_axf10
                                  AND axs12=g_axf12
                                  AND axs13=g_axf13   #FUN-910001 add 
      IF SQLCA.sqlcode OR cl_null(g_cnt) THEN
         LET g_cnt=0
      END IF
      IF g_cnt>0 THEN
         #FUN-960095--mod--str--  #若已維護agli0031,則先將維護得agli0031得資料刪除
         DELETE FROM axs_file 
          WHERE axs00=g_axf00                                                                                 
            AND axs01=g_axf[l_ac].axf01                                                                       
            AND axs09=g_axf09                                                                                 
            AND axs10=g_axf10                                                                                 
            AND axs12=g_axf12                                                                                 
            AND axs13=g_axf13   
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            #CALL cl_err('','agl-124',1)
            CALL cl_err('','agl-151',1)
         #FUN-960095--mod--end  
            RETURN FALSE
         END IF  #FUN-960095 add
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i003_chk_oppsite_acc()
   LET g_sql=g_axf[l_ac].axf02[1,4]
   IF UPSHIFT(g_sql) = 'MISC' THEN
      SELECT COUNT(*) INTO g_cnt FROM axt_file
                                WHERE axt00=g_axf00
                                  AND axt01=g_axf[l_ac].axf02
                                  AND axt09=g_axf09
                                  AND axt10=g_axf10
                                  AND axt12=g_axf12
                                  AND axt13=g_axf13   #FUN-910001 add
      IF SQLCA.sqlcode OR cl_null(g_cnt) THEN
         LET g_cnt=0
      END IF
      IF g_cnt>0 THEN
         #FUN-960095--mod--str--  #若已維護agli0031,則先將維護得agli0031得資料刪除 
         DELETE FROM axt_file 
          WHERE axt00=g_axf00                                                                                 
            AND axt01=g_axf[l_ac].axf02                                                                       
            AND axt09=g_axf09                                                                                 
            AND axt10=g_axf10                                                                                 
            AND axt12=g_axf12                                                                                 
            AND axt13=g_axf13
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN  
            #CALL cl_err('','agl-125',1)
            CALL cl_err('','agl-161',1)
            RETURN FALSE
         END IF #FUN-960095 add
      END IF
   END IF
   RETURN TRUE
END FUNCTION

#MOD-D10110--str
FUNCTION i003_chk_formula_acc()
   LET g_sql=g_axf[l_ac].axf02[1,4]
   IF UPSHIFT(g_sql) = 'MISC' THEN
      SELECT COUNT(*) INTO g_cnt FROM axu_file
                                WHERE axu00=g_axf00
                                  AND axu01=g_axf[l_ac].axf02
                                  AND axu09=g_axf09
                                  AND axu10=g_axf10
                                  AND axu12=g_axf12
                                  AND axu13=g_axf13   
      IF SQLCA.sqlcode OR cl_null(g_cnt) THEN
         LET g_cnt=0
      END IF
      IF g_cnt>0 THEN
         #若已維護agli0031,則先將維護得agli0031得資料刪除 
         DELETE FROM axu_file 
          WHERE axu00=g_axf00                                                                                 
            AND axu01=g_axf[l_ac].axf02                                                                       
            AND axu09=g_axf09                                                                                 
            AND axu10=g_axf10                                                                                 
            AND axu12=g_axf12                                                                                 
            AND axu13=g_axf13
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN  
            CALL cl_err('','agl-161',1)
            RETURN FALSE
         END IF 
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#MOD-D10110--end

FUNCTION i003_axf00(p_axf09,p_axf13)         #FUN-950051 add p_axf13
DEFINE p_axf09  LIKE axf_file.axf09                 
#FUN-950051--add--begin 
DEFINE p_axf13  LIKE axf_file.axf13 
DEFINE l_axa09  LIKE axa_file.axa09 
DEFINE l_axa02  LIKE axa_file.axa02   #FUN-9C0160
DEFINE l_cnt    LIKE type_file.num5   #FUN-9C0160


    SELECT axa09 INTO l_axa09 FROM axa_file 
     WHERE axa01 = p_axf13   #族群
       AND axa02 = p_axf09   #公司編號 
    IF l_axa09 = 'Y' THEN
       SELECT axz03 INTO g_axz03 FROM axz_file                                                                                         
        WHERE axz01 = p_axf09                                                                                                          
       LET g_plant_new = g_axz03      #營運中心                                                                                        
       CALL s_getdbs()                                                                                                                 
       IF cl_null(g_dbs_new) THEN                                                                                                      
           SELECT azp03 INTO g_dbs_new FROM azp_file                                                                                   
            WHERE azp01 = g_plant_new                                                                                                  
           IF STATUS THEN LET g_dbs_new = NULL RETURN END IF                                                                           
           LET g_dbs_new[21,21] = ':'                                                                                                  
       END IF                                                                                                                          
       LET g_dbs_axz03 = g_dbs_new    #上層公司所屬DB                                                                                  
                                                                                                                                       
       #上層公司所屬合并帳別                                                                                                           
       #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",                                                                       
       LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),  #FUN-A50102                                                                      
                   " WHERE aaz00 = '0'"                                                                                                
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
       PREPARE i003_pre_06 FROM g_sql                                                                                                  
       DECLARE i003_cur_06 CURSOR FOR i003_pre_06   
       OPEN i003_cur_06                                                                                                                
       FETCH i003_cur_06 INTO g_axf00                                                                                                  
       CLOSE i003_cur_06                                                                                                               
       IF cl_null(g_axf00) THEN                                                                                                        
           SELECT axz05 INTO g_axf00                                                                                                   
             FROM axz_file                                                                                                             
            WHERE axz01 = g_axf09                                                                                                      
       END IF     
    ELSE
       LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED) #當前DB
       SELECT aaz641 INTO g_axf00 FROM aaz_file WHERE aaz00 = '0'
    END IF 
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i003_axf12(p_axf10,p_axf13)  #FUN-950051 add axf13                                                                                                        
DEFINE p_axf10  LIKE axf_file.axf10                                                                                                 
#FUN-950051--add--begin
DEFINE p_axf13  LIKE axf_file.axf13
DEFINE l_axa09  LIKE axa_file.axa09
DEFINE l_axa02  LIKE axa_file.axa02   #FUN-9C0160
DEFINE l_cnt    LIKE type_file.num5   #FUN-9C0160


    SELECT axa09 INTO l_axa09 FROM axa_file
     WHERE axa01 = p_axf13    #族群
       #AND axa02 = g_axf09    #公司編號 
       AND axa02 = g_axf10    #公司編號   #FUN-A30079 mod
    IF l_axa09 = 'Y' THEN 
       SELECT axz03 INTO g_axz03 FROM axz_file                                                                                         
        #WHERE axz01 = p_axf10                                                                                                          
        WHERE axz01 = g_axf09  #TQC-A20010 mod
       LET g_plant_new = g_axz03      #營運中心                                                                                        
       CALL s_getdbs()                                                                                                                 
       IF cl_null(g_dbs_new) THEN                                                                                                      
           SELECT azp03 INTO g_dbs_new FROM azp_file                                                                                   
            WHERE azp01 = g_plant_new                                                                                                  
           IF STATUS THEN LET g_dbs_new = NULL RETURN END IF                                                                           
           LET g_dbs_new[21,21] = ':'                                                                                                  
       END IF 
       LET g_dbs_gl = g_dbs_new    #上層公司所屬DB                                                                                     
                                                                                                                                    
       #上層公司所屬合并帳別                                                                                                           
       #LET g_sql = "SELECT aaz641 FROM ",g_dbs_gl,"aaz_file",                                                                          
       LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'), #FUN-A50102                                                                          
                   " WHERE aaz00 = '0'"                                                                                                
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
       PREPARE i003_pre_07 FROM g_sql                                                                                                  
       DECLARE i003_cur_07 CURSOR FOR i003_pre_07                                                                                      
       OPEN i003_cur_07                                                                                                                
       FETCH i003_cur_07 INTO g_axf12                                                                                                  
       CLOSE i003_cur_07
    ELSE
       LET g_dbs_gl = s_dbstring(g_dbs CLIPPED)
       SELECT aaz641 INTO g_axf12 FROM aaz_file
        WHERE aaz00 = '0'
    END IF              
    IF cl_null(g_axf12) THEN                                                                                                        
        SELECT axz05 INTO g_axf12                                                                                                   
          FROM axz_file                                                                                                             
         WHERE axz01 = g_axf10                                                                                                      
    END IF                                                                                                                          
END FUNCTION                                                                                                                        

FUNCTION i003_level(p_i)
DEFINE p_axa02     LIKE axa_file.axa02
DEFINE l_sql       STRING 
DEFINE l_cnt       LIKE type_file.num5
DEFINE i           LIKE type_file.num5
DEFINE p_i         LIKE type_file.num5
DEFINE l_axb04     LIKE axb_file.axb04
DEFINE l_axb02     LIKE axb_file.axb02
DEFINE l_j         LIKE type_file.num5
DEFINE l_tmp_count LIKE type_file.num5
DEFINE l_axa02     LIKE axa_file.axa02

   IF p_i = 1 THEN
       #--找出群組中最上層的公司(第1階)---
       LET l_sql = "SELECT axa02 FROM axa_file",
                   " WHERE axa01 = '",g_axf13,"'",
                   " ORDER BY axa02"
       PREPARE i003_p FROM l_sql
       IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time 
          EXIT PROGRAM 
       END IF
       DECLARE i003_c CURSOR FOR i003_p
       FOREACH i003_c INTO l_axa02          #取出此群組中所有上層公司
           LET l_cnt = 0  
           SELECT COUNT(*) INTO l_cnt
             FROM axb_file
            WHERE axb01 = g_axf13
              AND axb04 = l_axa02       
           IF l_cnt > 0 THEN
               CONTINUE FOREACH
           ELSE
               INSERT INTO i003_axa_file VALUES(l_axa02,g_j)
               LET g_axa2[g_k].axb02 = l_axa02
               LET g_axa2[g_k].count = g_j
               LET g_k = g_k + 1
               LET g_j = g_j + 1
               EXIT FOREACH
           END IF
       END FOREACH
   END IF

   WHILE g_flag = 'N'
     IF p_i = 1 THEN  #找第一階
         #根據tm.axa02找出子公司清單
         LET l_sql = "SELECT axb04 FROM axb_file",
                     " WHERE axb01 = '",g_axf13,"'",
                     "   AND axb02 = '",l_axa02,"'",
                     " ORDER BY axb04"
         PREPARE i003_p1 FROM l_sql
         IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            EXIT PROGRAM 
         END IF
         DECLARE i003_c1 CURSOR FOR i003_p1
         LET l_axb04 = ''
         FOREACH i003_c1 INTO l_axb04  #抓出第二層子公司
            LET l_axb02 = l_axb04
            LET l_cnt = 0
            INSERT INTO i003_axa_file VALUES(l_axb04,g_j)
            LET g_axa2[g_k].axb02 = l_axb04
            LET g_axa2[g_k].count = g_j
            LET g_k = g_k + 1
         END FOREACH
         CALL g_axa2.deleteElement(g_k)
     ELSE
         LET l_axb04 = ''
         LET l_j = g_j - 1 
         LET l_sql = "SELECT axb02 FROM i003_axa_file ",
                     " WHERE count = '",l_j,"'"
         PREPARE i003_p2 FROM l_sql
         IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            EXIT PROGRAM 
         END IF
         DECLARE i003_c2 CURSOR FOR i003_p2
         FOREACH i003_c2 INTO l_axb02
             LET l_sql = "SELECT axb04 FROM axb_file",
                         " WHERE axb01 = '",g_axf13,"'",
                         "   AND axb02 = '",l_axb02,"'",
                         " ORDER BY axb04"
             PREPARE i003_p3 FROM l_sql
             IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time 
                EXIT PROGRAM 
             END IF
             DECLARE i003_c3 CURSOR FOR i003_p3
             LET l_axb04 = ''
             FOREACH i003_c3 INTO l_axb04  #抓出第一層子公司
                   INSERT INTO i003_axa_file VALUES (l_axb04,g_j)
                   LET g_axa2[g_k].axb02 = l_axb04
                   LET g_axa2[g_k].count = g_j
                   LET g_k = g_k + 1
             END FOREACH
             CALL g_axa2.deleteElement(g_k)
         END FOREACH
     END IF     
     IF cl_null(l_axb02) THEN 
         LET g_flag = 'Y'
     ELSE
         LET g_j = g_j + 1 
         LET p_i = p_i + 1
         CALL i003_level(g_j)
     END IF
   END WHILE
END FUNCTION

#No.FUN-9C0072 精簡程式碼

