# Prog. Version..: '5.30.06-13.04.22(00005)'     #

# Descriptions...: 會計科目對沖關係維護作業
# Date & Author..: 01/09/17 By Debbie Hsu
# Modify.........: No:MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No:MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No:FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No:FUN-510007 05/01/20 By Nicola 報表架構修改
# Modify.........: No:MOD-4C0171 05/02/15 By Smapmin 接收參數時,第一個必為帳別,若第一個不是帳別,則加入Null
# Modify.........: NO:FUN-570108 05/07/13 By Trisy key值可更改
# Modify.........: No:FUN-570200 05/07/28 By Rosayu  程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No:FUN-580063 05/08/15 By Sarah 增加維護兩個欄位:asq09,asq10,放在asq01前面
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
# Modify.........: No:MOD-740403 07/04/23 By Pengu 新增時asq03預設值為 'N'，asqacti 預設值為 'Y'
# Modify.........: No:FUN-740170 07/04/24 By Sarah 當單身的股權比例(asq03)打勾時,差額對應科目(asq04)一定要輸入
# Modify.........: No:FUN-740172 07/04/24 By Sarah 單頭新增帳別及開窗合理性應要加判斷AGLI009,單頭來源欄位不可與對沖欄位值相同
# Modify.........: No:FUN-750058 07/05/21 By kim GP5.1合併報表改善專案
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No:TQC-760030 07/06/05 By Sarah 1.單身來源科目開窗沒資料，應抓來源公司所在DB符合單頭來源帳別的會計科目來開窗
#                                                  2.單身來源科目與對沖科目若輸入MISC，應馬上開MISC科目設定畫面以供輸入
# Modify.........: No:TQC-760100 07/06/13 By Sarah 對沖科目開窗應抓對沖科目+對沖帳號的一般會計科目
# Modify.........: No:FUN-760053 07/06/20 By Sarah 1.來源、對沖科目開窗應開合併後科目,差額對應科目開來源帳別、公司的合併後科目
#                                                  2.資料重複關不掉
#                                                  3.依股權比率沖銷時,目前無法維護差異科目
# Modify.........: No:FUN-770069 07/10/08 By Sarah 單身刪除的WHERE條件句,asq01的部份應該用g_asq_t.asq01
# Modify.........: No.FUN-820002 07/12/20 By lala   報表轉為使用p_query
# Modify.........: No:FUN-910001 09/09/18 By lutingting由11區追單, 1.單頭增加asq13(族群代號)                                                        
#                                                  2.開窗CALL q_ash1需多傳arg3(族群代號),arg4(合并報表帳別)
# Modify.........: NO.FUN-950047 09/05/19 BY yiting add asq14,asq15
# Modify.........: NO.FUN-930117 09/05/20 BY ve007 pk值異動，相關程式修改
# Modify.........: NO.FUN-920049 09/05/20 BY lutingting由11區追單 1.單頭帳別依agli009設定自動帶出,NOENTRY 
# Modify.........: NO.FUN-920140 09/05/21 BY jan BEFORE ROW抓取aag02要跨DB 
# Modify.........: NO.FUN-950051 09/05/25 By lutingting 由于agli002單頭增加"獨立會科合并"欄位,對檢查會科方式修改 
# Modify.........: No:FUN-960095 09/06/19 By lutingting 刪除時若asq01以及asq02為MISC,則將ggli2031,ggli2032得資料一并刪除
# Modify.........: No:TQC-960366 09/06/26 By destiny 復制時會報錯
# Modify.........: No:MOD-960314 09/06/25 By Sarah i003_asq12()傳的參數應該改為傳asq09
# Modify.........: NO.FUN-960093 09/08/11 BY yiting ggli203單身輸入後，查詢後點選單身，無法進入來源及對沖科目修改
# Modify.........: No.TQC-9C0099 09/12/16 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-9C0072 10/01/05 By vealxu 精簡程式碼
# Modify.........: NO.FUN-9C0160 09/12/25 BY Yiting 複製時有問題
# Modify.........: No.CHI-9C0038 10/01/25 By lutingting 開放可錄結轉科目
# Modify.........: NO.TQC-A20010 10/02/03 BY Yiting 帳別取錯
# Modify.........: No.FUN-9B0098 10/02/23 by tommas delete cl_doc
# Modify.........: NO.FUN-A30079 10/03/24 BY yiting 單頭增加"合併主體"欄位，後續沖銷分錄產生時必需考慮此欄位值為依據產生上層公司
# Modify.........: No.FUN-A50102 10/06/03 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: NO.FUN-A30122 10/03/31 by yiting 取合併帳別資料庫改由s_aaz641_asg，s_get_aaz641_asg取合併帳別
# Modify.........: NO.MOD-A50193 10/05/28 by sabrina 來源科目或對沖科目為MISC時，不需執行agli002
# Modify.........: No:CHI-A60013 10/07/16 By Summer 在跨資料庫SQL後加入DB_LINK語法
# Modify.........: NO.FUN-A70107 10/07/20 BY yiting 合併主體的階級需高於來源及目的公司的層級
# Modify.........: NO.MOD-AB0165 10/11/17 BY Dido 複製時欄位控制調整 
# Modify.........: NO.MOD-AB0238 10/11/26 BY Dido 更新時需增加 asqacti  
# Modify.........: NO.FUN-A80137 11/01/28 BY lixia 來源及目的公司對沖科目，可個別設定來源檔案
# Modify.........: NO.MOD-B20063 11/02/17 BY Dido 複製時 asq16 未更新  
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: NO.FUN-C80056 12/08/15 By xuxz 添加asq18的控管
# Modify.........: NO.TQC-C80156 12/08/27 By lujh 錄入，複製時 對沖帳套顯示錯誤
# Modify.........: No:FUN-D30032 13/04/02 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: NO.TQC-D40119 13/07/17 By yangtt 在取合并帐套时，用的是aaz641，应改为大陆版的参数asz01

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BA0006
#FUN-BA0012
#模組變數(Module Variables)
DEFINE                                    #FUN-BB0036
    g_asq13         LIKE asq_file.asq13,  #FUN-910001 add
    g_asq09         LIKE asq_file.asq09,
    g_asq10         LIKE asq_file.asq10,
    g_asq13_t       LIKE asq_file.asq13,  #FUN-910001 add 
    g_asq09_t       LIKE asq_file.asq09,
    g_asq10_t       LIKE asq_file.asq10,
    g_asq13_o       LIKE asq_file.asq13,  #FUN-910001 add
    g_asq09_o       LIKE asq_file.asq09,
    g_asq10_o       LIKE asq_file.asq10,  #No.FUN-730070
    g_asq00         LIKE asq_file.asq00,  #No.FUN-730070
    g_asq12         LIKE asq_file.asq12,  #No.FUN-730070
    g_asq00_t       LIKE asq_file.asq00,  #No.FUN-730070
    g_asq12_t       LIKE asq_file.asq12,  #No.FUN-730070
    g_asq00_o       LIKE asq_file.asq00,  #No.FUN-730070
    g_asq12_o       LIKE asq_file.asq12,  #No.FUN-730070
    g_asq16         LIKE asq_file.asq16,  #FUN-A30079
    g_asq16_t       LIKE asq_file.asq16,  #FUN-A30079
    g_asq           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        asq14       LIKE asq_file.asq14,   #FUN-950047
        asq15       LIKE asq_file.asq15,   #FUN-950047
        asq01       LIKE asq_file.asq01,   #科目編號
        asq01_desc  LIKE aag_file.aag02,
        asq17       LIKE asq_file.asq17,   #FUN-A80137
        asq02       LIKE asq_file.asq02,   #簡稱
        asq02_desc  LIKE aag_file.aag02,
        asq03       LIKE asq_file.asq03,
        asq18       LIKE asq_file.asq18, #FUN-C80056 add
        asq04       LIKE asq_file.asq04,
        asq04_desc  LIKE aag_file.aag02,
        asqacti     LIKE asq_file.asqacti
                    END RECORD,
    g_asq_t         RECORD                 #程式變數 (舊值)
        asq14       LIKE asq_file.asq14,   #FUN-950047
        asq15       LIKE asq_file.asq15,   #FUN-950047
        asq01       LIKE asq_file.asq01,   #科目編號
        asq01_desc  LIKE aag_file.aag02,
        asq17       LIKE asq_file.asq17,   #FUN-A80137
        asq02       LIKE asq_file.asq02,   #簡稱
        asq02_desc  LIKE aag_file.aag02,
        asq03       LIKE asq_file.asq03,
        asq18       LIKE asq_file.asq18, #FUN-C80056 add
        asq04       LIKE asq_file.asq04,
        asq04_desc  LIKE aag_file.aag02,
        asqacti     LIKE asq_file.asqacti
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
DEFINE g_asg03        LIKE asg_file.asg03          #FUN-920049 add                                                                  
DEFINE g_dbs_asg03    LIKE type_file.chr21        #FUN-920049 add                                                                   
DEFINE g_dbs_gl       LIKE type_file.chr21        #FUN-920049 add   
DEFINE g_plant_gl     LIKE type_file.chr21        #FUN-A30122 add by vealxu
DEFINE g_plant_asg03  LIKE type_file.chr21        #FUN-A30122 add by vealxu
DEFINE g_aaz641       LIKE aaz_file.aaz641        #FUN-950051add
#---FUN-A70107 start--
DEFINE g_asa2         DYNAMIC ARRAY OF RECORD                     
                      asb02         LIKE asb_file.asb02, 
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
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

   LET i=0
   LET g_asq13_t = NULL  #FUN-910001 add 
   LET g_asq09_t = NULL
   LET g_asq10_t = NULL
   LET g_asq00_t = NULL  #No.FUN-730070
   LET g_asq12_t = NULL  #No.FUN-730070

#--FUN-A70107 start--
 CREATE TEMP TABLE i003_asa_file(
   asb02  LIKE asb_file.asb02,
   count  LIKE type_file.num5)
#--FUN-A70107 end-----

   OPEN WINDOW i003_w WITH FORM "ggl/42f/ggli203"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
   CALL cl_ui_init()

   CALL i003_menu()
   CLOSE FORM i003_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

#QBE 查詢資料
FUNCTION i003_cs()
    CLEAR FORM                            #清除畫面
    CALL g_asq.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
    INITIALIZE g_asq13 TO NULL    #FUN-910001 add 
    INITIALIZE g_asq09 TO NULL    #No.FUN-750051
    INITIALIZE g_asq10 TO NULL    #No.FUN-750051
    INITIALIZE g_asq00 TO NULL    #No.FUN-750051
    INITIALIZE g_asq12 TO NULL    #No.FUN-750051

    #CONSTRUCT g_wc ON asq13,asq09,asq00,asq10,asq12,asq01,asq02,asq03,asq04   #No.FUN-730070  #FUN-910001 add asq13
    #CONSTRUCT g_wc ON asq13,asq09,asq00,asq10,asq12,asq16,asq14,asq15,asq01,asq02,asq03,asq04   #No.FUN-730070  #FUN-910001 add asq13  #FUN-950047 add asq14,asq15  #FUN-A30079 add asq16
    CONSTRUCT g_wc ON asq13,asq09,asq00,asq10,asq12,asq16,asq14,asq15,asq01,asq17,asq02,asq03,asq18,asq04  #FUN-A80137 add asq17#FUN-C80056 add asq18
         #FROM asq13,asq09,asq00,asq10,asq12,s_asq[1].asq01,s_asq[1].asq02,    #No.FUN-730070  #FUN-910001 add asq13
         FROM asq13,asq09,asq00,asq10,asq12,asq16,s_asq[1].asq14,s_asq[1].asq15,s_asq[1].asq01,    #No.FUN-730070  #FUN-910001 add asq13   #FUN-950047  #FUN-A30079 add asq16
              s_asq[1].asq17,s_asq[1].asq02,             #FUN-A80137
              s_asq[1].asq03,s_asq[1].asq18,s_asq[1].asq04  #螢幕上取條件#FUN-C80056 add asq18
       #No:FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No:FUN-580031 --end--       HCN

       ON ACTION CONTROLP
          CASE
            #str FUN-910001 add                                                                                                     
             WHEN INFIELD(asq13) #族群代號                                                                                          
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.state = "c"                                                                                          
                LET g_qryparam.form ="q_asa1"                                                                                       
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                  
                DISPLAY g_qryparam.multiret TO asq13                                                                                
                NEXT FIELD asq13                                                                                                    
            #end FUN-910001 add
#start FUN-580063
             WHEN INFIELD(asq09) #來源公司代碼
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_asg"
                LET g_qryparam.default1 = g_asq09
                CALL cl_create_qry() RETURNING g_asq09
                DISPLAY BY NAME g_asq09            #No:MOD-490344
                NEXT FIELD asq09
             WHEN INFIELD(asq10) #對沖公司代碼
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_asg"
                LET g_qryparam.default1 = g_asq10
                CALL cl_create_qry() RETURNING g_asq10
                 DISPLAY BY NAME g_asq10            #No:MOD-490344
                NEXT FIELD asq10
             #No.FUN-730070  --Beatk
             WHEN INFIELD(asq00)  
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_aaa"      #FUN-580063
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO asq00  
                NEXT FIELD asq00
             WHEN INFIELD(asq12)  
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_aaa"      #FUN-580063
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO asq12  
                NEXT FIELD asq12
             #No.FUN-730070  --End   
             WHEN INFIELD(asq16) #合併主體
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_asg"
                LET g_qryparam.default1 = g_asq16
                CALL cl_create_qry() RETURNING g_asq16
                DISPLAY BY NAME g_asq16
                NEXT FIELD asq16
             WHEN INFIELD(asq01) #來源會計科目
                CALL q_m_aag2(TRUE,TRUE,g_plant_new,g_asq[1].asq01,'23',g_asq00)  #TQC-9C0099                                                  
                     RETURNING g_qryparam.multiret                                                                                  
                DISPLAY g_qryparam.multiret TO asq01                                                                                
                NEXT FIELD asq01                                                                                                    
             WHEN INFIELD(asq02) #對沖會計科目
                CALL q_m_aag2(TRUE,TRUE,g_dbs_asg03,g_asq[1].asq02,'23',g_asq00)                                                    
                     RETURNING g_qryparam.multiret                                                                                  
                DISPLAY g_qryparam.multiret TO asq02                                                                                
                NEXT FIELD asq02                                                                                                    
             WHEN INFIELD(asq04) #差額對應會計科目
                CALL q_m_aag2(TRUE,TRUE,g_dbs_asg03,g_asq[1].asq04,'23',g_asq00)                                                    
                     RETURNING g_qryparam.multiret                                                                                  
                DISPLAY g_qryparam.multiret TO asq04                                                                                
                NEXT FIELD asq04                                                                                                    
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

    #LET g_sql= "SELECT UNIQUE asq13,asq09,asq10,asq00,asq12 FROM asq_file ",  #No.FUN-730070  #FUN-910001 add asq13
    LET g_sql= "SELECT UNIQUE asq13,asq09,asq10,asq00,asq12,asq16 FROM asq_file ",  #No.FUN-730070  #FUN-910001 add asq13  #FUN-A30079 add asq16
               " WHERE ", g_wc CLIPPED,
               " ORDER BY asq13,asq09,asq00,asq10,asq12"  #No.FUN-730070  #FUN-910001 add asq13
    PREPARE i003_prepare FROM g_sql        #預備一下
    DECLARE i003_bcs                       #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i003_prepare

    LET g_sql = "SELECT UNIQUE asq13,asq09,asq10 ",      #No.TQC-720019 #FUN-910001 add asq13  #FUN-A30079 remark
#   LET g_sql_tmp = "SELECT UNIQUE asq13,asq09,asq10,asq00,asq12 ",  #No.TQC-720019  #No.FUN-730070  #FUN-910001 add asq13
                "  FROM asq_file ",
                " WHERE ", g_wc CLIPPED,
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
         #FUN-750058................beatk
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
               IF g_asq09 IS NOT NULL THEN
                  LET g_doc.column1 = "asq01"
                  LET g_doc.column2 = "asq02"  #FUN-930117
                  LET g_doc.value1 = g_asq[l_ac].asq01
                  LET g_doc.value2 = g_asq[l_ac].asq02  #FUN-930117
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_asq),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i003_a()
    IF s_shut(0) THEN RETURN END IF                #判斷目前系統是否可用
    MESSAGE ""
    CLEAR FORM
    CALL g_asq.clear()
    INITIALIZE g_asq13 LIKE asq_file.asq13         #DEFAULT 設定  #FUN-910001 add 
    INITIALIZE g_asq09 LIKE asq_file.asq09         #DEFAULT 設定
    INITIALIZE g_asq10 LIKE asq_file.asq10         #DEFAULT 設定
    INITIALIZE g_asq00 LIKE asq_file.asq00         #DEFAULT 設定  #No.FUN-730070
    INITIALIZE g_asq12 LIKE asq_file.asq12         #DEFAULT 設定  #No.FUN-730070
    INITIALIZE g_asq16 LIKE asq_file.asq16         #DEFAULT 設定  #FUN-A30079 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i003_i("a")                           #輸入單頭
        IF INT_FLAG THEN                           #使用者不玩了
            LET g_asq13=NULL  #FUN-910001 add
            LET g_asq09=NULL
            LET g_asq10=NULL
            LET g_asq00=NULL  #No.FUN-730070
            LET g_asq12=NULL  #No.FUN-730070
            LET g_asq16=NULL  #FUN-A30079
            DISPLAY g_asq13,g_asq09,g_asq10,g_asq00,g_asq12,g_asq16   #FUN-910001 add asq13 #FUN-A30079 add asq16  
                 TO asq13,asq09,asq10,asq00,asq12,asq16  #FUN-760053 add    #FUN-910001 add asq13  #FUN-A30079 add asq16
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_asq09 IS NULL THEN # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_asq10 IS NULL OR g_asq13 IS NULL THEN # KEY 不可空白  #FUN-910001 add asq13
            CONTINUE WHILE
        END IF
        #No.FUN-730070  --Beatk
        IF g_asq00 IS NULL OR g_asq12 IS NULL THEN # KEY 不可空白
            CONTINUE WHILE
        END IF
        #No.FUN-730070  --End  
        CALL g_asq.clear()
        LET g_rec_b = 0
        CALL i003_b()                              #輸入單身
        LET g_asq13_t = g_asq13                    #保留舊值  #FUN-910001 add
        LET g_asq09_t = g_asq09                    #保留舊值
        LET g_asq10_t = g_asq10                    #保留舊值
        LET g_asq00_t = g_asq00                    #保留舊值  #No.FUN-730070
        LET g_asq12_t = g_asq12                    #保留舊值  #No.FUN-730070
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i003_u()

    IF s_shut(0) THEN
       RETURN
    END IF

    IF cl_null(g_asq13) OR cl_null(g_asq09) OR cl_null(g_asq10) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    MESSAGE ""
    LET g_asq16_t = g_asq16
    BEGIN WORK
    WHILE TRUE
        CALL i003_i("u") 
        IF INT_FLAG THEN
            LET g_asq16=g_asq16_t
            DISPLAY g_asq16 TO asq16               #單頭
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF cl_null(g_asq16_t) OR g_asq16 != g_asq16_t THEN
           UPDATE asq_file 
              SET asq16 = g_asq16
            WHERE asq00 = g_asq00
              AND asq09 = g_asq09
              AND asq10 = g_asq10
              AND asq12 = g_asq12
              AND asq13 = g_asq13
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","asq_file",g_asq13,g_asq16,SQLCA.sqlcode,"","",1) 
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
DEFINE l_asq09_cnt  LIKE type_file.num5      #FUN-920049 add                                                                        
DEFINE l_asq10_cnt  LIKE type_file.num5      #FUN-920049 add   
DEFINE l_asq16_cnt  LIKE type_file.num5      #FUN-A30079
DEFINE l_i          LIKE type_file.num5      #FUN-A70107
DEFINE l_asq16_level LIKE type_file.num5     #FUN-A70107
DEFINE l_asq09_level LIKE type_file.num5     #FUN-A70107
DEFINE l_asq10_level LIKE type_file.num5     #FUN-A70107
DEFINE l_cnt         LIKE type_file.num5     #FUN-A70107

    DISPLAY g_asq13,g_asq09,g_asq10,g_asq00,g_asq12,g_asq16  #FUN-910001 add asq13  #FUN-A30079 add asq16 
         TO asq13,asq09,asq10,asq00,asq12,asq16              #No.FUN-730070     #FUN-910001 add asq13   #FUN-A30079 asq16
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0029  

    #INPUT g_asq13,g_asq09,g_asq00,g_asq10,g_asq12        #FUN-910001 add asq13 #FUN-920049 mark                                    
    # FROM asq13,asq09,asq00,asq10,asq12  #No.FUN-730070  #FUN-910001 add asq13 #FUN-920049 mark                                    
    INPUT g_asq13,g_asq09,g_asq10,g_asq16       #FUN-910001 add asq13 #FUN-A30079 add asq16                                                                      
     WITHOUT DEFAULTS   #FUN-A30079
     FROM asq13,asq09,asq10,asq16               #No.FUN-730070  #FUN-910001 add asq13   #FUN-A30079 add asq16   

    #--FUN-A30079 start--
    BEFORE INPUT
      LET g_before_input_done = FALSE
      CALL i003_set_entry(p_cmd)
      CALL i003_set_no_entry(p_cmd)
      LET g_before_input_done = TRUE
    #--FUN-A30079 end----

    #--FUN-A70107 start--
    AFTER FIELD asq13
        LET l_i = 1   
        LET g_j = 1
        LET g_k = 1
        LET g_flag = 'N'
        CALL i003_level(l_i)    
    #--FUN-A70107 end----

      #--FUN-920049 start---自動依agli009設定帳別帶出顯示--                                                                         
      AFTER FIELD asq09                                                                                                             
         IF NOT cl_null(g_asq09) THEN                                                                                               
             SELECT COUNT(*) INTO l_asq09_cnt                                                                                       
               FROM asg_file                                                                                                        
              WHERE asg01 = g_asq09                                                                                                 
             IF l_asq09_cnt = 0 THEN                                                                                                
                 CALL cl_err('','agl-943',0)                                                                                        
                 NEXT FIELD asq09     
             ELSE                                                                                                                   
                 #--FUN-A30122 start--
                 #CALL i003_asq00(g_asq09,g_asq13)  #FUN-950051 add asq13                                                                                           
                 CALL s_aaz641_asg(g_asq13,g_asq09) RETURNING g_plant_asg03    #FUN-A30122 mod g_dbs_asg03->g_plant_asg03 by vealxu  
                 CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_asq00            #FUN-A30122 mod g_dbs_asg03->g_plant_asg03 by vealxu
                 #---FUN-A30122 end---
                 DISPLAY g_asq00 TO asq00                                                                                           
                 IF cl_null(g_asq16) THEN  #FUN-A70107
                     LET g_asq16 = g_asq09     #FUN-A30079 add
                     DISPLAY g_asq16 TO asq16  #FUN-A30079 add
                 END IF                    #FUN-A70107
             END IF                                                                                                                 
         END IF                                                                                                                     
      #--FUN-920049 end-----   
 
      #str FUN-740172 add
      #對沖公司代碼(asq10)不可與來源公司代碼(asq09)相同
      AFTER FIELD asq10 
         IF NOT cl_null(g_asq10) THEN
            #--FUN-920049 start-----                                                                                               
             SELECT COUNT(*) INTO l_asq10_cnt                                                                                       
               FROM asg_file                                                                                                        
              WHERE asg01 = g_asq10                                                                                                 
             IF l_asq10_cnt = 0 THEN                                                                                                
                 CALL cl_err('','agl-943',0)                                                                                        
                 NEXT FIELD asq10                                                                                                   
             ELSE                                                                                                                   
                 CALL i003_asq12(g_asq10,g_asq13)   #FUN-950051 add asq13  #FUN-9C0160 mod
                 #CALL i003_asq12(g_asq09,g_asq13)   #FUN-950051 add asq13   #MOD-960314 #FUN-9C0160 mark
                 DISPLAY g_asq12 TO asq12                                                                                           
             END IF                                                                                                                 
             #--FUN-920049 end-----  
 
            IF g_asq10 = g_asq09 THEN
               CALL cl_err(g_asq10,'agl-945',0)   #對沖公司代碼不可與來源公司代碼相同!
               NEXT FIELD asq10
            END IF
         END IF
      #end FUN-740172 add

#---FUN-A30079 start--
      AFTER FIELD asq16                                                                                                             
         IF NOT cl_null(g_asq16) THEN                                                                                               
             SELECT COUNT(*) INTO l_asq16_cnt                                                                                       
               FROM asg_file                                                                                                        
              WHERE asg01 = g_asq16                                                                                                 
             IF l_asq16_cnt = 0 THEN                                                                                                
                 CALL cl_err('','agl-943',0)                                                                                        
                 LET g_asq16 = g_asq16_t  #FUN-A70107
                 DISPLAY BY NAME g_asq16  #FUN-A70107
                 NEXT FIELD asq16                                                                                                   
             END IF
             #--FUN-A70107 start--
             LET l_cnt = 0
             SELECT COUNT(*)
               INTO l_cnt
               FROM i003_asa_file
              WHERE asb02 = g_asq16
             IF l_cnt = 0 THEN
                 CALL cl_err('','agl030',0)
                 LET g_asq16 = g_asq16_t
                 DISPLAY BY NAME g_asq16
                 NEXT FIELD asq16
             END IF
             LET l_asq16_level = 0
             LET l_asq09_level = 0
             LET l_asq10_level = 0
             LET g_sql = "SELECT count ",
                         "  FROM i003_asa_file ",
                         " WHERE asb02 = '",g_asq16,"'"
                         PREPARE i003_asq16_p1 FROM g_sql                                                                                                  
                         DECLARE i003_asq16_c1 CURSOR FOR i003_asq16_p1                                                                                      
                         OPEN i003_asq16_c1                                                                                                                
                         FETCH i003_asq16_c1 INTO l_asq16_level                                                                                                  
                         CLOSE i003_asq16_c1
             LET g_sql = "SELECT count ",
                         "  FROM i003_asa_file ",
                         " WHERE asb02 = '",g_asq09,"'"
                         PREPARE i003_asq16_p2 FROM g_sql                                                                                                  
                         DECLARE i003_asq16_c2 CURSOR FOR i003_asq16_p2                                                                                      
                         OPEN i003_asq16_c2                                                                                                                
                         FETCH i003_asq16_c2 INTO l_asq09_level                                                                                                  
                         CLOSE i003_asq16_c2
             LET g_sql = "SELECT count ",
                         "  FROM i003_asa_file ",
                         " WHERE asb02 = '",g_asq10,"'"
                         PREPARE i003_asq16_p3 FROM g_sql                                                                                                  
                         DECLARE i003_asq16_c3 CURSOR FOR i003_asq16_p3                                                                                      
                         OPEN i003_asq16_c3                                                                                                                
                         FETCH i003_asq16_c3 INTO l_asq10_level                                                                                                  
                         CLOSE i003_asq16_c3
             IF l_asq16_level > l_asq09_level THEN
                 CALL cl_err('','agl028',0)
                 LET g_asq16 = g_asq16_t
                 DISPLAY BY NAME g_asq16
                 NEXT FIELD asq16
             END IF 
             IF l_asq16_level > l_asq10_level THEN
                 CALL cl_err('','agl029',0)
                 LET g_asq16 = g_asq16_t
                 DISPLAY BY NAME g_asq16
                 NEXT FIELD asq16
             END IF  
             #--FUN-A70107 end---
         END IF
#---FUN-A30079 end----

      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF   #FUN-760053 add
         IF p_cmd = 'a' THEN   #FUN-A30079 add
             IF NOT cl_null(g_asq09) AND NOT cl_null(g_asq10) AND 
                NOT cl_null(g_asq00) AND NOT cl_null(g_asq12) AND
                NOT cl_null(g_asq13) THEN   #FUN-910001 add 
                IF g_asq13_t IS NULL OR (g_asq13 != g_asq13_t) OR   #FUN-910001 add  
                   g_asq09_t IS NULL OR (g_asq09 != g_asq09_t) OR
                   g_asq00_t IS NULL OR (g_asq00 != g_asq00_t) OR
                   g_asq10_t IS NULL OR (g_asq10 != g_asq10_t) OR
                   g_asq12_t IS NULL OR (g_asq12 != g_asq12_t) THEN
                   SELECT COUNT(*) INTO l_n FROM asq_file
                    WHERE asq09 = g_asq09 AND asq10 = g_asq10
                      AND asq00 = g_asq00 AND asq12 = g_asq12
                      AND asq13 = g_asq13   #FUN-910001 add 
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      NEXT FIELD asq09
                   END IF
                END IF
             END IF
         END IF  #FUN-A30079 add
      #No.FUN-730070  --End  
#end FUN-580063
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLP
           CASE 
             #str FUN-910001 add                                                                                                    
              WHEN INFIELD(asq13) #族群代號                                                                                         
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form ="q_asa1"                                                                                      
                 LET g_qryparam.default1 = g_asq13                                                                                  
                 CALL cl_create_qry() RETURNING g_asq13                                                                             
                 DISPLAY BY NAME g_asq13                                                                                            
                 NEXT FIELD asq13                                                                                                   
             #end FUN-910001 add
              WHEN INFIELD(asq09) #來源公司代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_asg"
                 LET g_qryparam.default1 = g_asq09
                 CALL cl_create_qry() RETURNING g_asq09
                 DISPLAY BY NAME g_asq09            #No:MOD-490344
                 NEXT FIELD asq09
              WHEN INFIELD(asq10) #對沖公司代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_asg"
                 LET g_qryparam.default1 = g_asq10
                 CALL cl_create_qry() RETURNING g_asq10
                  DISPLAY BY NAME g_asq10            #No:MOD-490344
                 NEXT FIELD asq10
              #No.FUN-730070  --Beatk
              WHEN INFIELD(asq00)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.default1 = g_asq00
                 CALL cl_create_qry() RETURNING g_asq00
                 DISPLAY BY NAME g_asq00
                 NEXT FIELD asq00
              WHEN INFIELD(asq12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.default1 = g_asq12
                 CALL cl_create_qry() RETURNING g_asq12
                 DISPLAY BY NAME g_asq12
                 NEXT FIELD asq12
              #No.FUN-730070  --End  
#---FUN-A30079 start--
              WHEN INFIELD(asq16)  #合併主體
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_asg"
                 LET g_qryparam.default1 = g_asq16
                 CALL cl_create_qry() RETURNING g_asq16
                 DISPLAY BY NAME g_asq16
                 NEXT FIELD asq16
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
    INITIALIZE g_asq13 TO NULL               #FUN-910001 add 
    INITIALIZE g_asq09 TO NULL               #NO.FUN-6B0040
    INITIALIZE g_asq10 TO NULL               #No.FUN-730070
    INITIALIZE g_asq00 TO NULL               #No.FUN-730070
    INITIALIZE g_asq12 TO NULL               #No.FUN-730070
    INITIALIZE g_asq16 TO NULL               #FUN-A30079
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_asq.clear()
    LET g_rec_b = 0                          #FUN-A30122 add 
    CALL i003_cs()                           #取得查詢條件
    IF INT_FLAG THEN                         #使用者不玩了
        LET INT_FLAG = 0 
        RETURN
    END IF
    OPEN i003_bcs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                    #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_asq13 TO NULL               #FUN-910001 add
        INITIALIZE g_asq09 TO NULL
        INITIALIZE g_asq10 TO NULL               #No.FUN-730070
        INITIALIZE g_asq00 TO NULL               #No.FUN-730070
        INITIALIZE g_asq12 TO NULL               #No.FUN-730070
        INITIALIZE g_asq16 TO NULL               #FUN-A30079
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
        WHEN 'N' FETCH NEXT     i003_bcs INTO g_asq13,g_asq09,g_asq10,g_asq00,g_asq12  #No.FUN-730070  #FUN-910001 add asq13
        WHEN 'P' FETCH PREVIOUS i003_bcs INTO g_asq13,g_asq09,g_asq10,g_asq00,g_asq12  #No.FUN-730070  #FUN-910001 add asq13
        WHEN 'F' FETCH FIRST    i003_bcs INTO g_asq13,g_asq09,g_asq10,g_asq00,g_asq12  #No.FUN-730070  #FUN-910001 add asq13
        WHEN 'L' FETCH LAST     i003_bcs INTO g_asq13,g_asq09,g_asq10,g_asq00,g_asq12  #No.FUN-730070  #FUN-910001 add asq13
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
            FETCH ABSOLUTE g_jump i003_bcs INTO g_asq13,g_asq09,g_asq10,g_asq00,g_asq12  #No.FUN-730070  #FUN-910001 add asq13
            LET g_no_ask = FALSE
    END CASE

    #SELECT unique asq13,asq09,asq10,asq00,asq12  #No.FUN-730070  #FUN-910001 add asq13
    SELECT unique asq13,asq09,asq10,asq00,asq12,asq16  #FUN-A30079 add asq16
      INTO g_asq13,g_asq09,g_asq10,g_asq00,g_asq12,g_asq16  #FUN-A30079
      FROM asq_file
     WHERE asq09 = g_asq09 AND asq10 = g_asq10
       AND asq00 = g_asq00 AND asq12 = g_asq12  #No.FUN-730070
       AND asq13 = g_asq13   #FUN-910001 add
    IF SQLCA.sqlcode THEN                         #有麻煩
#      CALL cl_err(g_asq09,SQLCA.sqlcode,0)   #No.FUN-660123
       CALL cl_err3("sel","asq_file",g_asq09,g_asq10,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       INITIALIZE g_asq13 TO NULL  #FUN-910001 add
       INITIALIZE g_asq09 TO NULL  #TQC-6B0105
       INITIALIZE g_asq10 TO NULL  #TQC-6B0105
       INITIALIZE g_asq00 TO NULL  #FUN-910001 add                                                                                  
       INITIALIZE g_asq12 TO NULL  #FUN-910001 add 
       INITIALIZE g_asq16 TO NULL  #FUN-A30079 add
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
    CALL s_aaz641_asg(g_asq13,g_asq09) RETURNING g_plant_asg03        #FUN-A30122 mod g_dbs_asg03->g_plant_asg03 by vealxu
    CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_asq00                #FUN-A30122 mod g_dbs_asg03->g_plant_asg03 by vealxu
    CALL s_aaz641_asg(g_asq13,g_asq10) RETURNING g_plant_gl           #FUN-A30122 mod g_dbs_gl->g_plant_gl by vealxu
    CALL s_get_aaz641_asg(g_plant_gl) RETURNING g_asq12                   #FUN-A30122 mod g_dbs_gl->g_plant_gl by vealxu    
#--FUN-A30122 end----

    DISPLAY g_asq09 TO asq09           #單頭
    DISPLAY g_asq10 TO asq10           #單頭
    DISPLAY g_asq00 TO asq00           #No.FUN-730070
    DISPLAY g_asq12 TO asq12           #No.FUN-730070
    DISPLAY g_asq13 TO asq13           #單頭   #FUN-910001 add  
    DISPLAY g_asq16 TO asq16           #FUN-A30079
    CALL i003_b_fill(g_wc)             #單身

    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i003_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc     LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(200)

    #LET g_sql = "SELECT asq14,asq15,asq01,'',asq02,'',asq03,asq04,'',asqacti FROM asq_file ",  #FUN-950047 mod
    LET g_sql = "SELECT asq14,asq15,asq01,'',asq17,asq02,'',asq03,asq18,asq04,'',asqacti FROM asq_file ",  #FUN-A80137 add asq17#FUN-C80056 add asq18
                " WHERE asq09 = '",g_asq09,"' AND asq10 = '",g_asq10,"'",
                "   AND asq00 = '",g_asq00,"' AND asq12 = '",g_asq12,"'",  #No.FUN-730070
                "   AND asq13 = '",g_asq13,"'",   #FUN-910001 add 
                " AND ",p_wc CLIPPED ," ORDER BY asq01"
    PREPARE i003_prepare2 FROM g_sql      #預備一下
    DECLARE asq_cs CURSOR FOR i003_prepare2

    CALL g_asq.clear()

    LET g_cnt = 1
    LET g_rec_b = 0

    FOREACH asq_cs INTO g_asq[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF

      CALL i003_aag('a',g_asq[g_cnt].asq01)               #FUN-760053
           RETURNING g_asq[g_cnt].asq01_desc  #No.FUN-730070

      CALL i003_aag('a',g_asq[g_cnt].asq02)               #FUN-760053
           RETURNING g_asq[g_cnt].asq02_desc  #No.FUN-730070

      CALL i003_aag('a',g_asq[g_cnt].asq04)               #FUN-760053
           RETURNING g_asq[g_cnt].asq04_desc  #No.FUN-730070

      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_asq.deleteElement(g_cnt)
    LET g_rec_b=g_cnt -1

    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION i003_r()

    IF s_shut(0) THEN RETURN END IF
    IF g_asq09 IS NULL
	THEN CALL cl_err('',-400,0) RETURN
    END IF
    IF g_asq10 IS NULL
	THEN CALL cl_err('',-400,0) RETURN
    END IF
    #No.FUN-730070  --Beatk
    IF g_asq00 IS NULL OR g_asq12 IS NULL
	THEN CALL cl_err('',-400,0) RETURN
    END IF
    #No.FUN-730070  --End  
    #FUN-750058...........beatk
    IF NOT cl_null(g_asq[1].asq01) THEN    #FUN-920049  避免輸入完單頭馬上按刪除時單身無值會當掉 
        IF NOT i003_chk_source_acc() THEN
           RETURN
        END IF
    END IF
    IF NOT cl_null(g_asq[1].asq01) THEN    #FUN-920049  
       IF NOT i003_chk_oppsite_acc() THEN
          RETURN
       END IF
    END IF                                    #FUN-920049     
    #FUN-750058...........end
    BEGIN WORK
    IF cl_delh(15,16) THEN
        DELETE FROM asq_file WHERE asq09=g_asq09 AND asq10=g_asq10
                               AND asq00=g_asq00 AND asq12=g_asq12  #No.FUN-730070
                               AND asq13=g_asq13   #FUN-910001 add 
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_asq09,SQLCA.sqlcode,0)   #No.FUN-660123
           CALL cl_err3("del","asq_file",g_asq09,g_asq10,SQLCA.sqlcode,"","",1)  #No.FUN-660123
        ELSE
           CLEAR FORM
           CALL g_asq.clear()
#          LET g_sql = "SELECT UNIQUE asq13,xf09, asq10,asq00,asq12 ",  #No.FUN-730070  #FUN-910001 add asq13  #111101 lilingyu
           LET g_sql = "SELECT UNIQUE asq13,asq09, asq10,asq00,asq12 ",  #No.FUN-730070  #FUN-910001 add asq13  #111101 lilingyu

                       "  FROM asq_file ",
                       " INTO TEMP y "
           DROP TABLE y
           #No.FUN-730070  --Beatk
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
    l_cmd           STRING                       #TQC-760030 add

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    
    #---FUN-920049 start--                                                                                                           
   #找出單頭輸入上層公司所在DB及agls101中aaz641設定合并帳別資料                                                                     
   #後續單身對衝科目檢查皆以此DB+合并帳別做為檢查依據及開窗資料                                                                     
   #CALL i003_asq00(g_asq09,g_asq13)  #FUN-950051 add asq13  #FUN-A30122 mark                                                                                                         
   #---FUN-920049 end---    

    CALL s_aaz641_asg(g_asq13,g_asq09) RETURNING g_plant_asg03  #FUN-A30122 add    #FUN-A30122 mod g_dbs_asg03->g_plant_asg03 by vealxu
    CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_asq00          #FUN-A30122 add    #FUN-A30122 mod g_dbs_asg03->g_plant_asg03 by vealxu
    LET g_plant_new = g_plant_asg03                             #FUN-A30122 add by vealxu

    #LET g_forupd_sql = "SELECT asq14,asq15,asq01,'',asq02,'',asq03,asq04,'',asqacti FROM asq_file ",  #FUN-950047
    LET g_forupd_sql = "SELECT asq14,asq15,asq01,'',asq17,asq02,'',asq03,asq18,asq04,'',asqacti FROM asq_file ",  #FUN-A80137 add asq17#FUN-C80056 add asq18
                       "WHERE asq13 = ? AND asq09=? AND asq10=? AND asq00=? AND asq12=? AND asq01= ? AND asq02 = ? FOR UPDATE "  #FUN-950047 #NO.FUN-930117 add asq02
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i003_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_asq WITHOUT DEFAULTS FROM s_asq.*
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
               LET g_asq13_t = g_asq13        #BACKUP  #FUN-910001 add 
               LET g_asq09_t = g_asq09        #BACKUP
               LET g_asq10_t = g_asq10        #BACKUP
               LET g_asq00_t = g_asq00        #BACKUP  #No.FUN-730070
               LET g_asq12_t = g_asq12        #BACKUP  #No.FUN-730070
               LET g_asq_t.* = g_asq[l_ac].*  #BACKUP
               OPEN i003_bcl USING g_asq13,g_asq09,g_asq10,g_asq00,g_asq12,g_asq[l_ac].asq01,  #No.FUN-730070  #FUN-910001 add asq13
                                   g_asq[l_ac].asq02   #FUN-930117
               IF STATUS THEN
                  CALL cl_err("OPEN i003_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i003_bcl INTO g_asq[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_asq_t.asq01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  LET g_sql = "SELECT aag02 ",
                               #"  FROM ",g_dbs_asg03,"aag_file",
                               "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102
                               " WHERE aag01 = '",g_asq[l_ac].asq01,"'",
                               "   AND aag00 = '",g_asq00,"'"
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
                   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
                   PREPARE i003_pre_04 FROM g_sql
                   DECLARE i003_cur_04 CURSOR FOR i003_pre_04
                   OPEN i003_cur_04
                   FETCH i003_cur_04 INTO g_asq[l_ac].asq01_desc
                   LET g_sql = "SELECT aag02 ",
                              #"  FROM ",g_dbs_asg03,"aag_file",  #FUN-A50102
                               "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102
                               " WHERE aag01 = '",g_asq[l_ac].asq02,"'",
                               "   AND aag00 = '",g_asq00,"'"
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
                   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
                   PREPARE i003_pre_05 FROM g_sql
                   DECLARE i003_cur_05 CURSOR FOR i003_pre_05
                   OPEN i003_cur_05
                   FETCH i003_cur_05 INTO g_asq[l_ac].asq02_desc
                   LET g_sql = "SELECT aag02 ",
                              #"  FROM ",g_dbs_asg03,"aag_file",  #FUN-A50102
                               "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102
                               " WHERE aag01 = '",g_asq[l_ac].asq04,"'",
                               "   AND aag00 = '",g_asq00,"'"
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
                   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
                   PREPARE i003_pre_08 FROM g_sql
                   DECLARE i003_cur_08 CURSOR FOR i003_pre_08
                   OPEN i003_cur_08
                   FETCH i003_cur_08 INTO g_asq[l_ac].asq04_desc
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
            INITIALIZE g_asq[l_ac].* TO NULL
           #----------No:MOD-740403 add
            LET g_asq[l_ac].asq03  ='N'
            LET g_asq[l_ac].asqacti='Y'
            LET g_asq[l_ac].asq14 = 'N'         #FUN-950047
            LET g_asq[l_ac].asq15 = '1'         #FUN-950047
            LET g_asq[l_ac].asq17 = '1'         #FUN-A80137
           #----------No:MOD-740403 end
            LET g_asq_t.* = g_asq[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()
            #NEXT FIELD asq01
            NEXT FIELD asq14     #FUN-940047

        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              INITIALIZE g_asq[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_asq[l_ac].* TO s_asq.*
              CALL g_asq.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            #IF NOT cl_null(g_asq[l_ac].asq01) THEN   #FUN-920049 add     
            IF NOT cl_null(g_asq[l_ac].asq01) AND NOT cl_null(g_asq[l_ac].asq02) THEN   #FUN-920049 add   #FUN-A30122 mod  
                INSERT INTO asq_file(asq01,asq02,asq03,asq04,asq05,asq06,asq07,
                                     #asq08,asq09,asq10,asqacti,asquser,asqgrup,asqmodu,asqdate,asq00,asq12,asq13)  #No.FUN-730070  #FUN-910001 add asq13
                                     asq08,asq09,asq10,asqacti,asquser,asqgrup,asqmodu,asqdate,asq00,asq12,asq13,  #No.FUN-730070  #FUN-910001 add asq13  
                                     asq14,asq15,asq16,  #FUN-950047  #FUN-A30079 add asq16
                                     asq17,asq18)              #FUN-A80137#FUN-C80056 add asq18
                              VALUES(g_asq[l_ac].asq01,g_asq[l_ac].asq02,g_asq[l_ac].asq03,g_asq[l_ac].asq04,
                                     '','','','',g_asq09,g_asq10,g_asq[l_ac].asqacti,g_user,g_grup,g_user,g_today,g_asq00,g_asq12,g_asq13,   #FUN-910001 add asq13 
                                     g_asq[l_ac].asq14,g_asq[l_ac].asq15,g_asq16,  #FUN-950047 #FUN-A30079 add asq16
                                     g_asq[l_ac].asq17,g_asq[l_ac].asq18)   #FUN-A80137#FUN-C80056 add asq18
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins","asq_file",g_asq[l_ac].asq01,g_asq09,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                    CANCEL INSERT
                ELSE
                    LET g_rec_b = g_rec_b + 1
                    DISPLAY g_rec_b TO FORMONLY.cn2
                    MESSAGE 'INSERT O.K'
                END IF
            ELSE                           #FUN-920049 add                                                                          
                CALL cl_err('','9044',1)   #FUN-920049 add                                                                          
            END IF                         #FUN-920049 add  

       AFTER FIELD asq14 
          IF g_asq[l_ac].asq14 = 'Y' THEN
              FOR i = 1 TO ARR_COUNT()
                  IF i <> l_ac THEN
                      IF g_asq[i].asq14 = 'Y' THEN
                          LET g_asq[l_ac].asq14 = 'N' 
                          DISPLAY BY NAME g_asq[l_ac].asq14
                          CALL cl_err('','agl027',1)
                      END IF
                  END IF
              END FOR
          END IF

        AFTER FIELD asq01   #check asq09+asq10+asq01 是否重複
           IF NOT cl_null(g_asq[l_ac].asq01) THEN
              IF g_asq[l_ac].asq01[1,4]<>'MISC' THEN #FUN-750058
                 IF g_asq13_t     IS NULL OR   #FUN-910001 add 
                    g_asq09_t     IS NULL OR
                    g_asq10_t     IS NULL OR
                    g_asq00_t     IS NULL OR  #No.FUN-730070
                    g_asq12_t     IS NULL OR  #No.FUN-730070
                    g_asq_t.asq01 IS NULL OR
                    g_asq_t.asq02 IS NULL OR   #FUN-930117
                    (g_asq13 != g_asq13_t) OR  #FUN-910001 add
                    (g_asq09 != g_asq09_t) OR
                    (g_asq10 != g_asq10_t) OR
                    (g_asq00 != g_asq00_t) OR  #No.FUN-73070
                    (g_asq12 != g_asq12_t) OR  #No.FUN-73070
                    (g_asq[l_ac].asq01 != g_asq_t.asq01) OR  #FUN-930117 mod
                   (g_asq[l_ac].asq02 != g_asq_t.asq02) THEN #FUN-930117 add
                    SELECT count(*) INTO l_n FROM asq_file
                     WHERE asq09 = g_asq09
                       AND asq10 = g_asq10
                       AND asq00 = g_asq00 AND asq12 = g_asq12  #No.FUN-730070
                       AND asq01 = g_asq[l_ac].asq01
                       AND asq02 = g_asq[l_ac].asq02  #FUN-930117
                       AND asq13 = g_asq13   #FUN-910001 add 
                    IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_asq[l_ac].asq01 = g_asq_t.asq01
                       NEXT FIELD asq01
                    END IF
                 END IF
                #CALL i003_aag('a',g_asq[l_ac].asq01,g_asq00)   #FUN-760053 mark
                 CALL i003_aag('a',g_asq[l_ac].asq01)           #FUN-760053
                      RETURNING g_asq[l_ac].asq01_desc  #No.FUN-730070
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_asq[l_ac].asq01,g_errno,0)
                    #FUN-B20004--beatk
                     CALL q_m_aag2(FALSE,FALSE,g_plant_new,g_asq[l_ac].asq01,'23',g_asq00)                                               
                     RETURNING g_asq[l_ac].asq01                         
                    #LET g_asq[l_ac].asq01=g_asq_t.asq01
                    #FUN-B20004--end
                    NEXT FIELD asq01
                 ELSE
                    DISPLAY g_asq[l_ac].asq01_desc TO asq01_desc
                 END IF
              ELSE
                 LET g_asq[l_ac].asq01_desc=NULL
                 DISPLAY BY NAME g_asq[l_ac].asq01_desc
              END IF

              LET l_cmd=g_asq[l_ac].asq01[1,4]   
              IF UPSHIFT(l_cmd) = 'MISC' THEN
                 CALL i003_msa()
              END IF
              #end TQC-760030 add 
           END IF
 
        AFTER FIELD asq02
           IF NOT cl_null(g_asq[l_ac].asq02) THEN
              IF g_asq[l_ac].asq02[1,4]<>'MISC' THEN #FUN-750058
                 CALL i003_aag('a',g_asq[l_ac].asq02)           #FUN-760053
                      RETURNING g_asq[l_ac].asq02_desc  #No.FUN-730070
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_asq[l_ac].asq02,g_errno,0)
                    #FUN-B20004--beatk
                    CALL q_m_aag2(FALSE,FALSE,g_plant_new,g_asq[l_ac].asq02,'23',g_asq00) 
                         RETURNING g_asq[l_ac].asq02                          
                    #LET g_asq[l_ac].asq02=g_asq_t.asq02
                    #FUN-B20004--end
                    NEXT FIELD asq02
                 ELSE
                    DISPLAY g_asq[l_ac].asq02_desc TO asq02_desc
                 END IF
              ELSE
                 LET g_asq[l_ac].asq02_desc=NULL
                 DISPLAY BY NAME g_asq[l_ac].asq02_desc
              END IF
              LET l_cmd=g_asq[l_ac].asq02[1,4]   
              IF UPSHIFT(l_cmd) = 'MISC' THEN
                 CALL i003_moa()
              END IF
              #end TQC-760030 add 
           END IF

 
        AFTER FIELD asq03
           IF NOT cl_null(g_asq[l_ac].asq03) THEN
              IF g_asq[l_ac].asq03 NOT MATCHES'[YN]' THEN
                 NEXT FIELD asq03
              END IF
           END IF
 
        AFTER FIELD asq04
           IF NOT cl_null(g_asq[l_ac].asq04) THEN
             #CALL i003_aag('a',g_asq[l_ac].asq04,g_aza.aza81)  #FUN-760053 mark
              CALL i003_aag('a',g_asq[l_ac].asq04)              #FUN-760053
                   RETURNING g_asq[l_ac].asq04_desc  #No.FUN-730070
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_asq[l_ac].asq04,g_errno,0)
                 #FUN-B20004--beatk
                 #LET g_asq[l_ac].asq04=g_asq_t.asq04
                 CALL q_m_aag2(FALSE,FALSE,g_plant_new,g_asq[l_ac].asq04,'23',g_asq00) 
                      RETURNING g_asq[l_ac].asq04 
                 #FUN-B20004--end
                 NEXT FIELD asq04
               ELSE
                 DISPLAY g_asq[l_ac].asq02_desc TO asq04_desc
              END IF
           END IF

        BEFORE DELETE                            #是否取消單身
            IF g_asq_t.asq01 IS NOT NULL THEN
                #FUN-750058...........beatk
                IF NOT i003_chk_source_acc() THEN
                   CANCEL DELETE
                END IF
                IF NOT i003_chk_oppsite_acc() THEN
                   CANCEL DELETE
                END IF
                #FUN-750058...........end
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                  #No.FUN-9B0098 10/02/23
                LET g_doc.column1 = "asq01"                 #No.FUN-9B0098 10/02/23
                LET g_doc.column2 = "asq02"                 #No.FUN-9B0098 10/02/23
                LET g_doc.value1 = g_asq[l_ac].asq01        #No.FUN-9B0098 10/02/23
                LET g_doc.value2 = g_asq[l_ac].asq02        #No.FUN-9B0098 10/02/23
                CALL cl_del_doc()                                                #No.FUN-9B0098 10/02/23

                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF

                DELETE FROM asq_file
                 WHERE asq01 = g_asq_t.asq01 AND asq09 = g_asq09   #FUN-770069 mod
                   AND asq10 = g_asq10
                   AND asq02 = g_asq_t.asq02   #FUN-930117 add
                   AND asq00 = g_asq00 AND asq12 = g_asq12  #No.FUN-730070
                   AND asq13 = g_asq13   #FUN-910001 add 
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_asq10_t,SQLCA.sqlcode,0)   #No.FUN-660123
                   CALL cl_err3("del","asq_file",g_asq_t.asq01,g_asq09,SQLCA.sqlcode,"","",1)  #No.FUN-660123
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
               LET g_asq[l_ac].* = g_asq_t.*
               CLOSE i003_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_asq[l_ac].asq01,-263,1)
               LET g_asq[l_ac].* = g_asq_t.*
            ELSE
               UPDATE asq_file SET asq01 = g_asq[l_ac].asq01,
                                   asq02 = g_asq[l_ac].asq02,
                                   asq03 = g_asq[l_ac].asq03,
                                   asq18 = g_asq[l_ac].asq18,#FUN-C80056 add
                                   asq04 = g_asq[l_ac].asq04,
                                   asq14 = g_asq[l_ac].asq14,   #FUN-950047
                                   asq15 = g_asq[l_ac].asq15,   #FUN-950047
                                   asq17 = g_asq[l_ac].asq17,   #FUN-A80137
                                   asqacti = g_asq[l_ac].asqacti,   #MOD-AB0238
                                   asqmodu = g_user,
                                   asqdate = g_today
                WHERE asq01 = g_asq_t.asq01 AND asq09 = g_asq09
                  AND asq10 = g_asq10
                  AND asq00 = g_asq00 AND asq12 = g_asq12  #No.FUN-730070
                  AND asq13 = g_asq13   #FUN-910001 add
                  AND asq02 = g_asq_t.asq02  #FUN-930117 add
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","asq_file",g_asq_t.asq01,g_asq09,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                  LET g_asq[l_ac].* = g_asq_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac                  #FUN-D30032 mark  
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #LET g_asq[l_ac].* = g_asq_t.*   #FUN-D30032 mark
               #FUN-D30032--add--str--
               IF p_cmd = 'u' THEN
                  LET g_asq[l_ac].* = g_asq_t.*
               ELSE
                  CALL g_asq.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t 
                  END IF
               END IF
               #FUN-D30032--add--end--
               CLOSE i003_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac                  #FUN-D30032 add 
            LET g_asq_t.* = g_asq[l_ac].*
            CLOSE i003_bcl
            COMMIT WORK
            CALL g_asq.deleteElement(g_rec_b+1)
            #FUN-C80056--add-s-tr
            IF g_asq[l_ac].asq01[1,4] = 'MISC' OR g_asq[l_ac].asq02[1,4]= 'MISC' THEN 
               IF g_asq[l_ac].asq18 <> '3' THEN 
                   CALL cl_err('','ggl-006',1)
                   LET g_asq[l_ac].asq18 = 3
                   UPDATE asq_file SET asq18 = '3'
                    WHERE asq01 = g_asq_t.asq01 
                      AND asq02 = g_asq_t.asq02 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","asq_file",g_asq_t.asq01,"",SQLCA.sqlcode,"","",1)  
                   ELSE
                      MESSAGE 'UPDATE O.K'
                      COMMIT WORK
                   END IF
                   NEXT FIELD asq18
                END IF
            END IF
            #FUN-C80056 --add--end

        ON ACTION mntn_acc_code1
           IF g_asq[l_ac].asq01 = 'MISC' THEN        #MOD-A50193 add  
              CALL cl_err('','agl-255',1)             #MOD-A50193 add
              CONTINUE INPUT                         #MOD-A50193 add 
           ELSE                                      #MOD-A50193 add     
              LET g_msg = "agli102 '",g_asq00,"' '",g_asq[l_ac].asq01 ,"' " #MOD-4C0171  #No.FUN-730070
              CALL cl_cmdrun(g_msg)
           END IF                #MOD-A50193 add
        ON ACTION mntn_acc_code2
           IF g_asq[l_ac].asq02 = 'MISC' THEN        #MOD-A50193 add  
              CALL cl_err('','agl-256',1)             #MOD-A50193 add
              CONTINUE INPUT                         #MOD-A50193 add 
           ELSE                                      #MOD-A50193 add     
              LET g_msg = "agli102 '",g_asq12,"' '",g_asq[l_ac].asq02 ,"' " #MOD-4C0171  #No.FUN-730070
              CALL cl_cmdrun(g_msg)
           END IF                #MOD-A50193 add 
        ON ACTION mntn_acc_code4
          #LET g_msg = "agli102 '",g_aza.aza81,"' '",g_asq[l_ac].asq04 ,"' " #MOD-4C0171  #No.FUN-730070   #FUN-760053 mark
           LET g_msg = "agli102 '",g_asq00,"' '",g_asq[l_ac].asq04 ,"' "     #MOD-4C0171  #No.FUN-730070   #FUN-760053
           CALL cl_cmdrun(g_msg)

        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(asq01) AND l_ac > 1 THEN
              LET g_asq[l_ac].* = g_asq[l_ac-1].*
              NEXT FIELD asq01
           END IF

        ON ACTION CONTROLZ
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
              WHEN INFIELD(asq01) #來源會計科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant_new,g_asq[l_ac].asq01,'23',g_asq00)   #TQC-9C0099                                            
                     RETURNING g_asq[l_ac].asq01                                                                                    
                 DISPLAY BY NAME g_asq[l_ac].asq01                                                                                  
                 NEXT FIELD asq01                                                                                                   
              WHEN INFIELD(asq02) #對沖會計科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant_new,g_asq[l_ac].asq02,'23',g_asq00)  #FUN-950051 mark #TQC-9C0099
                     RETURNING g_asq[l_ac].asq02                                                                                    
                 DISPLAY BY NAME g_asq[l_ac].asq02                                                                                  
                 NEXT FIELD asq02                                                                                                   
              WHEN INFIELD(asq04) #差額對應會計科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant_new,g_asq[l_ac].asq04,'23',g_asq00) #TQC-9C0099                                              
                     RETURNING g_asq[l_ac].asq04                                                                                    
                 DISPLAY BY NAME g_asq[l_ac].asq04                                                                                  
                 NEXT FIELD asq04                                                                                                   
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
      CALL cl_set_comp_entry("asq13,asq09,asq10,asq01,asq00,asq12,asq02",TRUE)   #FUN-580063  #No.FUN-730070  #FUN-910001 add asq13  #FUN-930117 add asq02
   END IF
#No.FUN-570108 --end--

   CALL cl_set_comp_entry("asq01,asq02,asq03,asq04",TRUE)  #FUN-960093
END FUNCTION

FUNCTION i003_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)

   IF p_cmd = 'u' AND g_chkey='N' THEN  #FUN-A30079 mod
       CALL cl_set_comp_entry("asq13,asq09,asq10,asq00,asq12",FALSE)  #FUN-580063  #No.FUN-730070  #FUN-910001 add asq13  #FUN-930117 add asq02   #FUN-960093 mod
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
               #"  FROM ",g_dbs_asg03,"aag_file",                                                                                    
               "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102                                                                                  
               " WHERE aag01 = '",p_act,"'",                                                                                        
               "   AND aag00 = '",g_asq00,"'"                                                                                       
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

   DISPLAY ARRAY g_asq TO s_asq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
      
      #FUN-750058................beatk
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
#No.FUN-6B0029--beatk                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i003_copy()
DEFINE
    l_asq		RECORD LIKE asq_file.*,
    l_n                 LIKE type_file.num5,                #檢查重複用        #No.FUN-680098 smallint
    l_old13,l_new13     LIKE asq_file.asq13,  #FUN-910001 add 
    l_old09,l_new09     LIKE asq_file.asq09,
    l_old10,l_new10	LIKE asq_file.asq10,
    l_old00,l_new00     LIKE asq_file.asq00,  #No.FUN-730070
    l_old12,l_new12	LIKE asq_file.asq12   #No.FUN-730070
DEFINE l_old16,l_new16  LIKE asq_file.asq16   #FUN-A30079
DEFINE l_asq09_cnt      LIKE type_file.num5   #FUN-920049  add                                                                      
DEFINE l_asq10_cnt      LIKE type_file.num5   #FUN-920049  add 
 
    IF s_shut(0) THEN RETURN END IF

    IF cl_null(g_asq09) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF cl_null(g_asq10) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #No.FUN-730070  --Beatk
    IF cl_null(g_asq00) OR cl_null(g_asq12) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #No.FUN-730070  --End  
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 

    #---FUN-9C0160 start---
    LET l_old13 = g_asq13  
    LET l_old09 = g_asq09    
    LET l_old10 = g_asq10    
    LET l_old00 = g_asq00  
    LET l_old12 = g_asq12 
    #--FUN-9C0160 end---
    LET l_old16 = g_asq16  #FUN-A30079 add
    
   #-MOD-AB0165-add-    
     LET g_before_input_done = FALSE       
     CALL i003_set_entry('a')
     CALL i003_set_no_entry('a')
     LET g_before_input_done = TRUE      
   #-MOD-AB0165-end-    

    #INPUT l_new13,l_new09,l_new00,l_new10,l_new12        #FUN-910001 add l_new13                                                   
    #INPUT l_new13,l_new09,l_new10          #FUN-920049 mod                                                                          
    INPUT l_new13,l_new09,l_new10,l_new16   #FUN-A30079 add asq16
     #FROM asq13,asq09,asq00,asq10,asq12  #No.FUN-730070  #FUN-910001 add asq13                                                     
     #FROM asq13,asq09,asq10                #FUN-920049 mod  
     FROM asq13,asq09,asq10,asq16           #FUN-A30079 add asq16

    AFTER FIELD asq09   #check asq09+asq10 是否重複
       IF NOT cl_null(l_new09) THEN
          #--FUN-920049 start---自動依agli009設定帳別帶出顯示--                                                                    
           SELECT COUNT(*) INTO l_asq09_cnt                                                                                         
             FROM asg_file                                                                                                          
            WHERE asg01 = l_new09                                                                                                   
           IF l_asq09_cnt = 0 THEN                                                                                                  
               CALL cl_err('','agl-943',0)                                                                                          
               NEXT FIELD asq09                                                                                                     
           ELSE           
               #CALL i003_asq00(l_new09,l_new13)   #FUN-950051 add l_new13                                                                                            
               CALL s_aaz641_asg(l_new13,l_new09) RETURNING g_plant_asg03  #FUN-A30122 add   #FUN-A30122 mod g_dbs_asg03->g_plant_asg03 by vealxu
               CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_asq00          #FUN-A30122 add   #FUN-A30122 mod g_dbs_asg03->g_plant_asg03 by vealxu
               DISPLAY g_asq00 TO asq00                                                                                             
           END IF                                                                                                                   
           #--FUN-920049 end-----   

          SELECT COUNT(*) INTO l_n FROM asq_file
           WHERE asq09 = l_new09
             AND asq10 = l_new10
             AND asq00 = l_new00 AND asq12 = l_new12  #No.FUN-73070
             AND asq13 = l_new13   #FUN-910001 add
          IF l_n > 0 THEN
             CALL cl_err('',-239,0)
             NEXT FIELD asq09
          END IF
          #--FUN-920049 start---自動依agli009設定帳別帶出顯示--                                                                     
#         CALL i003_asq00(l_new09,l_new13)   #FUN-950051 add l_new13  #FUN-A30122 mark                                                                                                  
          DISPLAY g_asq00 TO asq00                   
          LET l_new00=g_asq00                                 #No.TQC-960366                                                                              
          #--FUN-920049 end-----    
       END IF

    AFTER FIELD asq10   #check asq09+asq10 是否重複
       IF NOT cl_null(l_new10) THEN
          #--FUN-920049 start---自動依agli009設定帳別帶出顯示--                                                                    
           SELECT COUNT(*) INTO l_asq10_cnt                                                                                         
             FROM asg_file                                                                                                          
            WHERE asg01 = l_new10                                                                                                   
           IF l_asq10_cnt = 0 THEN                                                                                                  
               CALL cl_err('','agl-943',0)                                                                                          
               NEXT FIELD asq10                                                                                                     
           ELSE                                                                                                                     
              #CALL i003_asq12(l_new10,l_new13)  #FUN-950051 add l_new13  
               CALL s_aaz641_asg(l_new13,l_new10) RETURNING g_plant_gl  #FUN-A30122 add     #FUN-A30122 mod g_dbs_asg03->g_plant_asg03 by vealxu
               CALL s_get_aaz641_asg(g_plant_gl) RETURNING g_asq12          #FUN-A30122 add     #FUN-A30122 mod g_dbs_asg03->g_plant_asg03 by vealxu   
               DISPLAY g_asq12 TO asq12                                  
               LET l_new12=g_asq12                            #No.TQC-960366                                                           
           END IF                                                                                                                   
           #--FUN-920049 end----- 
 
          SELECT COUNT(*) INTO l_n FROM asq_file
           WHERE asq09 = l_new09
             AND asq10 = l_new10
             AND asq00 = l_new00 AND asq12 = l_new12  #No.FUN-73070
             AND asq13 = l_new13   #FUN-910001 add  
          IF l_n > 0 THEN
             CALL cl_err('',-239,0)
             NEXT FIELD asq10
          END IF
          #str FUN-740172 add
          IF NOT cl_null(l_new10) THEN
             IF l_new10 = l_new09 THEN
                CALL cl_err(l_new10,'agl-945',0)   #對沖公司代碼不可與來源公司代碼相同!
                NEXT FIELD asq10
             END IF
          END IF
          #end FUN-740172 add
          #--FUN-920049 start---自動依agli009設定帳別帶出顯示--                                                                     
          CALL i003_asq12(l_new10,l_new13)  #FUN-950051 add l_new13 
          #CALL i003_asq12(l_new09,l_new13)  #FUN-950051 add l_new13   #MOD-960314 #FUN-9C0160 mark
          DISPLAY g_asq12 TO asq12                                                                                                  
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
             WHEN INFIELD(asq13) #族群代號                                                                                          
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.form ="q_asa1"                                                                                       
                LET g_qryparam.default1 = l_new13                                                                                   
                CALL cl_create_qry() RETURNING l_new13                                                                              
                DISPLAY l_new13 TO asq13                                                                                            
                NEXT FIELD asq13                                                                                                    
            #end FUN-910001 add 
             WHEN INFIELD(asq09) #來源公司代碼
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_asg"
                LET g_qryparam.default1 = l_new09
                CALL cl_create_qry() RETURNING l_new09
                DISPLAY l_new09 TO asq09
                NEXT FIELD asq09
             WHEN INFIELD(asq10) #對沖公司代碼
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_asg"
                LET g_qryparam.default1 = l_new10
                CALL cl_create_qry() RETURNING l_new10
                DISPLAY l_new10 TO asq10
                NEXT FIELD asq10
             #No.FUN-730070  --Beatk
             WHEN INFIELD(asq00)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aaa"
                LET g_qryparam.default1 = l_new00
                CALL cl_create_qry() RETURNING l_new00
                DISPLAY l_new00 TO asq00
                NEXT FIELD asq00
             WHEN INFIELD(asq12)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aaa"
                LET g_qryparam.default1 = l_new12
                CALL cl_create_qry() RETURNING l_new12
                DISPLAY l_new12 TO asq12
                NEXT FIELD asq12
             #No.FUN-730070  --End  
#---FUN-A30079 start--
             WHEN INFIELD(asq16)   #合併主體
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_asg"
                LET g_qryparam.default1 = l_new16
                CALL cl_create_qry() RETURNING l_new16
                DISPLAY l_new09 TO asq16
                NEXT FIELD asq16
#---FUN-A30079 end---
             OTHERWISE EXIT CASE
          END CASE
 
    END INPUT

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY g_asq13 TO asq13  #FUN-910001 add  
        DISPLAY g_asq09 TO asq09
        DISPLAY g_asq10 TO asq10  #No.FUN-730070
        DISPLAY g_asq00 TO asq00  #No.FUN-730070
        DISPLAY g_asq12 TO asq12  #No.FUN-730070
        DISPLAY g_asq16 TO asq16  #FUN-A30079 add
        RETURN
    END IF

    DROP TABLE x

    SELECT *
      FROM asq_file         #單頭複製
     WHERE asq09 = l_old09 AND asq10 = l_old10
       AND asq00 = l_old00 AND asq12 = l_old12 
       AND asq13 = l_old13
     #--FUN-9C0160 end---
       INTO TEMP x
    IF SQLCA.sqlcode THEN
       #CALL cl_err3("ins","x",g_asq09,g_asq10,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       CALL cl_err3("ins","x",l_old09,g_asq10,SQLCA.sqlcode,"","",1)  #No.FUN-660123 #FUN-9C0160 mod
       RETURN
    END IF

    UPDATE x
       SET asq09 = l_new09,asq10 = l_new10,
           asq00 = l_new00,asq12 = l_new12,  #No.FUN-730070
           asq13 = l_new13,asq16 = l_new16   #FUN-910001 add #MOD-B20063 add asq16

    INSERT INTO asq_file
       SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","asq_file",l_new09,l_new10,SQLCA.sqlcode,"","asq:",1)  #No.FUN-660123
       RETURN
    END IF

    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_new09,') O.K'

    SELECT unique asq13,asq09,asq10,asq00,asq12,asq16   #FUN-910001 add asq13 #FU N-A30079 add asq16
      INTO g_asq13,g_asq09,g_asq10,g_asq00,g_asq12,g_asq16   #No.FUN-730070   #FUN-910001 add asq13 #FUN-A30079 add asq16
      FROM asq_file
     WHERE asq09 = l_new09 AND asq10 = l_new10
       AND asq00 = l_new00 AND asq12 = l_new12  #No.FUN-730070
       AND asq13 = l_new13   #FUN-910001 add

    CALL i003_b()
    #FUN-C80046---begin
    #SELECT unique asq13,asq09,asq10,asq00,asq12,asq16     #FUN-910001 add asq13   #FUN-A30079 add asq16
    #  INTO g_asq13,g_asq09,g_asq10,g_asq00,g_asq12,g_asq16  #No.FUN-730070  #FUN-910001 add asq13 #FUN-A30079 add asq16
    #  FROM asq_file
    # WHERE asq09 = l_old09 AND asq10 = l_old10
    #   AND asq00 = l_old00 AND asq12 = l_old12  #No.FUN-730070
    #   AND asq13 = l_old13   #FUN-910001 add 
    #
    #CALL i003_show()
    #FUN-C80046---end
END FUNCTION

FUNCTION i003_out()
   DEFINE l_i     LIKE type_file.num5,          #No.FUN-680098 smallilnt
          l_name  LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
          l_asq   RECORD LIKE asq_file.*,
          l_asq01_desc  LIKE aag_file.aag02,
          l_asq02_desc  LIKE aag_file.aag02,
          l_asq04_desc  LIKE aag_file.aag02,
          l_chr   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
DEFINE l_cmd  LIKE type_file.chr1000 
   IF cl_null(g_wc) AND
      NOT cl_null(g_asq00) AND NOT cl_null(g_asq09) AND 
      NOT cl_null(g_asq10) AND NOT cl_null(g_asq12) AND  #FUN-910001 mod                                                             
      NOT cl_null(g_asq13) THEN   #FUN-910001 add
      LET g_wc = " asq00 = '",g_asq00,"' AND ",                                                                                      
                 " asq09 = '",g_asq09,"' AND ",                                                                                      
                 " asq10 = '",g_asq10,"' AND ",                                                                                      
                 " asq12 = '",g_asq12,"' AND ",   #FUN-910001 add                                                                    
                 " asq13 = '",g_asq13,"'"         #FUN-910001 add
   END IF
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
   LET l_cmd = 'p_query "ggli203" "',g_asq00,'" "',g_wc CLIPPED,'"'                                                                  
   CALL cl_cmdrun(l_cmd)                                                                                                             
   RETURN
END FUNCTION

FUNCTION i001_asq00(p_cmd,p_asq09,p_asq00)    #FUN-740172
  DEFINE p_cmd     LIKE type_file.chr1,  
         p_asq09   LIKE asq_file.asq09,       #FUN-740172 add
         p_asq00   LIKE asq_file.asq00,
         l_aaaacti LIKE aaa_file.aaaacti,
         l_cnt     LIKE type_file.num5,     #FUN-740172 add
         l_cnt1    LIKE type_file.num5        #FUN-910001 add 
    LET g_errno = ' '
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_asq00
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE

    #str FUN-740172 add
    #合理性檢查,輸入的公司+帳別需存在agli009裡
    IF p_cmd = 'a' AND cl_null(g_errno) THEN
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM asg_file 
        WHERE asg01=p_asq09 AND asg05=p_asq00
       IF l_cnt = 0 THEN
          LET g_errno = 'agl-946'   #輸入之公司+帳別不存在合併報表公司基本資料檔裡!
       END IF
    END IF
    #end FUN-740172 add

   #str FUN-910001 add                                                                                                              
    IF g_asq13 IS NOT NULL AND g_asq09 IS NOT NULL AND                                                                              
       g_asq00 IS NOT NULL THEN                                                                                                     
       LET l_cnt = 0   LET l_cnt1 = 0                                                                                               
       SELECT COUNT(*) INTO l_cnt FROM asa_file                                                                                     
        WHERE asa01=g_asq13 AND asa02=g_asq09                                                                                       
          AND asa03=g_asq00                                                                                                         
       SELECT COUNT(*) INTO l_cnt1 FROM asb_file                                                                                    
        WHERE asb01=g_asq13 AND asb04=g_asq09                                                                                       
          AND asb05=g_asq00                                                                                                         
       IF l_cnt+l_cnt1 = 0 THEN                                                                                                     
          #此資料不存在聯屬公司層級單頭檔(asa_file)中,請重新輸入!                                                                   
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
   LET l_cmd=g_asq[l_ac].asq01[1,4]   
   IF UPSHIFT(l_cmd) <> 'MISC' THEN
      CALL cl_err('','agl-099',0)
      RETURN
   END IF
   CALL s_aaz641_asg(g_asq13,g_asq09) RETURNING g_plant_asg03 #FUN-A30122 add  #FUN-A30122 mod g_dbs_asg03->g_plant_asg03 by vealxu
   CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_asq00         #FUN-A30122 add  #FUN-A30122 mod g_dbs_asg03->g_plant_asg03 by vealxu

   LET l_cmd="ggli2031 '",g_asq00,"' ",     #來源帳別                                                                               
             "'",g_asq[l_ac].asq01,"' ",    #來源會計科目編號                                                                       
             "'",g_asq09,"' ",              #來源公司代碼                                                                           
             "'",g_asq10,"' ",              #對衝公司代碼                                                                           
             #"'",g_asq12,"' ",              #對衝帳別                                                                              
             "'",g_asq00,"' ",              #對衝帳別   #FUN-920049   
             "'",g_asq13,"'"                #族群代號   #FUN-910001 add
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION

FUNCTION i003_moa()
   DEFINE l_cmd STRING
   IF g_rec_b=0 THEN
      CALL cl_err('','amr-304',0)
      RETURN
   END IF
   LET l_cmd=g_asq[l_ac].asq02[1,4]   
   IF UPSHIFT(l_cmd) <> 'MISC' THEN
      CALL cl_err('','agl-123',0)
      RETURN
   END IF

   CALL s_aaz641_asg(g_asq13,g_asq09) RETURNING g_plant_asg03 #FUN-A30122 add   #FUN-A30122 mod g_dbs_asg03->g_plant_asg03 by vealxu
   CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_asq00         #FUN-A30122 add   #FUN-A30122 mod g_dbs_asg03->g_plant_asg03 by vealxu

   LET l_cmd="ggli2032 '",g_asq00,"' ",     #來源帳別
             "'",g_asq[l_ac].asq02,"' ",    #來源會計科目編號
             "'",g_asq09,"' ",              #來源公司代碼
             "'",g_asq10,"' ",              #對沖公司代碼
             #"'",g_asq12,"' ",                #對沖帳別
             "'",g_asq00,"' ",              #對衝帳別   #FUN-920049  
             "'",g_asq13,"'"                #族群代號   #FUN-910001 add
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION

FUNCTION i003_chk_source_acc()
   LET g_sql=g_asq[l_ac].asq01[1,4]
   IF UPSHIFT(g_sql) = 'MISC' THEN
      SELECT COUNT(*) INTO g_cnt FROM ast_file
                                WHERE ast00=g_asq00
                                  AND ast01=g_asq[l_ac].asq01
                                  AND ast09=g_asq09
                                  AND ast10=g_asq10
                                  AND ast12=g_asq12
                                  AND ast13=g_asq13   #FUN-910001 add 
      IF SQLCA.sqlcode OR cl_null(g_cnt) THEN
         LET g_cnt=0
      END IF
      IF g_cnt>0 THEN
         #FUN-960095--mod--str--  #若已維護ggli2031,則先將維護得ggli2031得資料刪除
         DELETE FROM ast_file 
          WHERE ast00=g_asq00                                                                                 
            AND ast01=g_asq[l_ac].asq01                                                                       
            AND ast09=g_asq09                                                                                 
            AND ast10=g_asq10                                                                                 
            AND ast12=g_asq12                                                                                 
            AND ast13=g_asq13   
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
   LET g_sql=g_asq[l_ac].asq02[1,4]
   IF UPSHIFT(g_sql) = 'MISC' THEN
      SELECT COUNT(*) INTO g_cnt FROM asu_file
                                WHERE asu00=g_asq00
                                  AND asu01=g_asq[l_ac].asq02
                                  AND asu09=g_asq09
                                  AND asu10=g_asq10
                                  AND asu12=g_asq12
                                  AND asu13=g_asq13   #FUN-910001 add
      IF SQLCA.sqlcode OR cl_null(g_cnt) THEN
         LET g_cnt=0
      END IF
      IF g_cnt>0 THEN
         #FUN-960095--mod--str--  #若已維護ggli2031,則先將維護得ggli2031得資料刪除 
         DELETE FROM asu_file 
          WHERE asu00=g_asq00                                                                                 
            AND asu01=g_asq[l_ac].asq02                                                                       
            AND asu09=g_asq09                                                                                 
            AND asu10=g_asq10                                                                                 
            AND asu12=g_asq12                                                                                 
            AND asu13=g_asq13
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN  
            #CALL cl_err('','agl-125',1)
            CALL cl_err('','agl-161',1)
            RETURN FALSE
         END IF #FUN-960095 add
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i003_asq00(p_asq09,p_asq13)         #FUN-950051 add p_asq13
DEFINE p_asq09  LIKE asq_file.asq09                 
#FUN-950051--add--beatk 
DEFINE p_asq13  LIKE asq_file.asq13 
DEFINE l_asa09  LIKE asa_file.asa09 
DEFINE l_asa02  LIKE asa_file.asa02   #FUN-9C0160
DEFINE l_cnt    LIKE type_file.num5   #FUN-9C0160


    SELECT asa09 INTO l_asa09 FROM asa_file 
     WHERE asa01 = p_asq13   #族群
       AND asa02 = p_asq09   #公司編號 
    IF l_asa09 = 'Y' THEN
       SELECT asg03 INTO g_asg03 FROM asg_file                                                                                         
        WHERE asg01 = p_asq09                                                                                                          
       LET g_plant_new = g_asg03      #營運中心                                                                                        
       CALL s_getdbs()                                                                                                                 
       IF cl_null(g_dbs_new) THEN                                                                                                      
           SELECT azp03 INTO g_dbs_new FROM azp_file                                                                                   
            WHERE azp01 = g_plant_new                                                                                                  
           IF STATUS THEN LET g_dbs_new = NULL RETURN END IF                                                                           
           LET g_dbs_new[21,21] = ':'                                                                                                  
       END IF                                                                                                                          
       LET g_dbs_asg03 = g_dbs_new    #上層公司所屬DB                                                                                  
                                                                                                                                       
       #上層公司所屬合并帳別                                                                                                           
       #LET g_sql = "SELECT aaz641 FROM ",g_dbs_asg03,"aaz_file",                                                                       
      #LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),  #FUN-A50102    #TQC-D40119 
      #            " WHERE aaz00 = '0'"                                                               #TQC-D40119
       LET g_sql = "SELECT asz01 FROM ",cl_get_target_table(g_plant_new,'asz_file'),                  #TQC-D40119
                   " WHERE asz00 = '0'"                                                               #TQC-D40119 
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
       PREPARE i003_pre_06 FROM g_sql                                                                                                  
       DECLARE i003_cur_06 CURSOR FOR i003_pre_06   
       OPEN i003_cur_06                                                                                                                
       FETCH i003_cur_06 INTO g_asq00                                                                                                  
       CLOSE i003_cur_06                                                                                                               
       IF cl_null(g_asq00) THEN                                                                                                        
           SELECT asg05 INTO g_asq00                                                                                                   
             FROM asg_file                                                                                                             
            WHERE asg01 = g_asq09                                                                                                      
       END IF     
    ELSE
       LET g_dbs_asg03 = s_dbstring(g_dbs CLIPPED) #當前DB
      #SELECT aaz641 INTO g_asq00 FROM aaz_file WHERE aaz00 = '0'     #TQC-D40119 mark
       SELECT asz01 INTO g_asq00 FROM asz_file WHERE asz00 = '0'      #TQC-D40119 add
    END IF 
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i003_asq12(p_asq10,p_asq13)  #FUN-950051 add asq13                                                                                                        
DEFINE p_asq10  LIKE asq_file.asq10                                                                                                 
#FUN-950051--add--beatk
DEFINE p_asq13  LIKE asq_file.asq13
DEFINE l_asa09  LIKE asa_file.asa09
DEFINE l_asa02  LIKE asa_file.asa02   #FUN-9C0160
DEFINE l_cnt    LIKE type_file.num5   #FUN-9C0160


    SELECT asa09 INTO l_asa09 FROM asa_file
     WHERE asa01 = p_asq13    #族群
       #AND asa02 = g_asq09    #公司編號 
       AND asa02 = g_asq10    #公司編號   #FUN-A30079 mod
    IF l_asa09 = 'Y' THEN 
       SELECT asg03 INTO g_asg03 FROM asg_file                                                                                         
        #WHERE asg01 = p_asq10                                                                                                          
        WHERE asg01 = g_asq09  #TQC-A20010 mod
       LET g_plant_new = g_asg03      #營運中心                                                                                        
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
       #LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'), #FUN-A50102       #TQC-C80156  mark
       LET g_sql = "SELECT asz01 FROM ",cl_get_target_table(g_plant_new,'asz_file'),  #TQC-C80156  add                                                                   
                   " WHERE asz00 = '0'"                                               #TQC-C80156  mod change asz00 to aaz00                                                                         
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
       PREPARE i003_pre_07 FROM g_sql                                                                                                  
       DECLARE i003_cur_07 CURSOR FOR i003_pre_07                                                                                      
       OPEN i003_cur_07                                                                                                                
       FETCH i003_cur_07 INTO g_asq12                                                                                                  
       CLOSE i003_cur_07
    ELSE
       LET g_dbs_gl = s_dbstring(g_dbs CLIPPED)
       #SELECT aaz641 INTO g_asq12 FROM aaz_file    #TQC-C80156  mark
       # WHERE aaz00 = '0'                          #TQC-C80156  mark
      #SELECT asz641 INTO g_asq12 FROM asz_file     #TQC-C80156  add    #TQC-D40119 mark
       SELECT asz01 INTO g_asq12 FROM asz_file     #TQC-C80156  add     #TQC-D40119 add
        WHERE asz00 = '0'                           #TQC-C80156  add
    END IF              
    IF cl_null(g_asq12) THEN                                                                                                        
        SELECT asg05 INTO g_asq12                                                                                                   
          FROM asg_file                                                                                                             
         WHERE asg01 = g_asq10                                                                                                      
    END IF                                                                                                                          
END FUNCTION                                                                                                                        

FUNCTION i003_level(p_i)
DEFINE p_asa02     LIKE asa_file.asa02
DEFINE l_sql       STRING 
DEFINE l_cnt       LIKE type_file.num5
DEFINE i           LIKE type_file.num5
DEFINE p_i         LIKE type_file.num5
DEFINE l_asb04     LIKE asb_file.asb04
DEFINE l_asb02     LIKE asb_file.asb02
DEFINE l_j         LIKE type_file.num5
DEFINE l_tmp_count LIKE type_file.num5
DEFINE l_asa02     LIKE asa_file.asa02

   IF p_i = 1 THEN
       #--找出群組中最上層的公司(第1階)---
       LET l_sql = "SELECT asa02 FROM asa_file",
                   " WHERE asa01 = '",g_asq13,"'",
                   " ORDER BY asa02"
       PREPARE i003_p FROM l_sql
       IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time 
          EXIT PROGRAM 
       END IF
       DECLARE i003_c CURSOR FOR i003_p
       FOREACH i003_c INTO l_asa02          #取出此群組中所有上層公司
           LET l_cnt = 0  
           SELECT COUNT(*) INTO l_cnt
             FROM asb_file
            WHERE asb01 = g_asq13
              AND asb04 = l_asa02       
           IF l_cnt > 0 THEN
               CONTINUE FOREACH
           ELSE
               INSERT INTO i003_asa_file VALUES(l_asa02,g_j)
               LET g_asa2[g_k].asb02 = l_asa02
               LET g_asa2[g_k].count = g_j
               LET g_k = g_k + 1
               LET g_j = g_j + 1
               EXIT FOREACH
           END IF
       END FOREACH
   END IF

   WHILE g_flag = 'N'
     IF p_i = 1 THEN  #找第一階
         #根據tm.asa02找出子公司清單
         LET l_sql = "SELECT asb04 FROM asb_file",
                     " WHERE asb01 = '",g_asq13,"'",
                     "   AND asb02 = '",l_asa02,"'",
                     " ORDER BY asb04"
         PREPARE i003_p1 FROM l_sql
         IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            EXIT PROGRAM 
         END IF
         DECLARE i003_c1 CURSOR FOR i003_p1
         LET l_asb04 = ''
         FOREACH i003_c1 INTO l_asb04  #抓出第二層子公司
            LET l_asb02 = l_asb04
            LET l_cnt = 0
            INSERT INTO i003_asa_file VALUES(l_asb04,g_j)
            LET g_asa2[g_k].asb02 = l_asb04
            LET g_asa2[g_k].count = g_j
            LET g_k = g_k + 1
         END FOREACH
         CALL g_asa2.deleteElement(g_k)
     ELSE
         LET l_asb04 = ''
         LET l_j = g_j - 1 
         LET l_sql = "SELECT asb02 FROM i003_asa_file ",
                     " WHERE count = '",l_j,"'"
         PREPARE i003_p2 FROM l_sql
         IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            EXIT PROGRAM 
         END IF
         DECLARE i003_c2 CURSOR FOR i003_p2
         FOREACH i003_c2 INTO l_asb02
             LET l_sql = "SELECT asb04 FROM asb_file",
                         " WHERE asb01 = '",g_asq13,"'",
                         "   AND asb02 = '",l_asb02,"'",
                         " ORDER BY asb04"
             PREPARE i003_p3 FROM l_sql
             IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time 
                EXIT PROGRAM 
             END IF
             DECLARE i003_c3 CURSOR FOR i003_p3
             LET l_asb04 = ''
             FOREACH i003_c3 INTO l_asb04  #抓出第一層子公司
                   INSERT INTO i003_asa_file VALUES (l_asb04,g_j)
                   LET g_asa2[g_k].asb02 = l_asb04
                   LET g_asa2[g_k].count = g_j
                   LET g_k = g_k + 1
             END FOREACH
             CALL g_asa2.deleteElement(g_k)
         END FOREACH
     END IF     
     IF cl_null(l_asb02) THEN 
         LET g_flag = 'Y'
     ELSE
         LET g_j = g_j + 1 
         LET p_i = p_i + 1
         CALL i003_level(g_j)
     END IF
   END WHILE
END FUNCTION

#No.FUN-9C0072 精簡程式碼

