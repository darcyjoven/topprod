# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: ggli001.4gl
# Descriptions...: 合併財報會計科目資料維護作業
# Date & Author..: 01/09/18 By Debbie Hsu
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510007 05/01/18 By Nicola 報表架構修改
# Modify.........: No.FUN-580063 05/08/15 By Sarah 1.azp02改成asg02,azp03改成asg03
#                                                  2.單身增加維護欄位:ash11,ash12
# Modify.........: No.FUN-590061 05/09/13 By Dido 切換工廠必須改為asg_file(agli009)來切換
# Modify.........: No.TQC-590045 05/09/28 By Sarah 組SQL字串有誤
# Modify.........: No.FUN-590124 05/10/05 By Dido 帶出合併科目名稱
# Modify.........: No.TQC-5B0064 05/11/09 By Nicola 進入單身判斷修改
# Modify.........: No.MOD-5A0443 05/11/29 By Smapmin 來源科目編號在使用TIPTOP的情況下才加以check
# Modify.........: No.TQC-660043 06/06/16 By Smapmin 將資料庫代碼改為營運中心代碼
# Modify.........: No.FUN-660123 06/06/27 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/21 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.MOD-710041 07/01/05 By Smapmin 開啟程式後馬上開窗查詢就會出錯
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730070 07/04/02 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-740199 07/04/22 By Carrier 1.整批產生輸入字段混亂
# Modify.........: No.FUN-740173 07/05/03 By Sarah 1.公司/帳別應要判斷agli009
#                                                  2.整批產生公司/帳別應要判斷agli009
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760003 07/06/01 By Sarah 1.單頭"帳別"欄位開窗改為抓上面那個"營運中心代碼"有設定的帳別，而不是抓數目前所在DB有設定的帳別
#                                                  2.單身的"合併財報科目編號",開窗所傳入的帳別改抓目前所在DB的預設帳別(aaz64)的會計科目
# Modify.........: No.MOD-760085 07/06/20 By Smapmin 相關會計科目要包含結轉科目
# Modify.........: No.FUN-760053 07/06/20 By Sarah 1.按下b修改單身時，合併財報科目名稱會不見
#                                                  2.當資料是由非TIPTOP公司寫入的科目抓取方式修改
# Modify.........: No.TQC-760205 07/06/29 By Sarah 單頭"帳別(ash00)"輸入時,應default agli009"帳別(asg05)",開窗時,時,若非tiptop公司(asg04='N')會有問題
# Modify.........: No.FUN-760085 07/07/25 By sherry  報表改由Crystal Rrport輸出 
# Modify.........: No.MOD-780106 07/08/17 By Sarah 整批產生時，若科目已存在者不做更新
# Modify.........: No.FUN-770069 07/09/17 By Sarah 修正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.FUN-7B0012 07/11/07 By Carrier db分隔符,call s_dbstring()處理
# Modify.........: No.FUN-820017 08/02/15 By alex 修正 s_dbstring用法
# Modify.........: No.MOD-830061 08/03/07 By Smapmin 列印時,合併財報科目名稱無法顯示
# Modify.........: No.MOD-920248 09/02/20 By Sarah 串aaa_file前應加串資料庫
# Modify.........: No.TQC-910022 09/03/04 By Sarah 調整mfg9142訊息為aco-025
# Modify.........: No.TQC-950003 09/05/04 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.FUN-910001 09/05/18 By lutingting由11區追單過來 1.畫面增加ash13(族群代號)欄位                                                    
#                                                  2.單身的"合并財報科目編號",開窗所傳入的帳別改抓目前所在DB的合并報表帳別(aaz641)的會計科目  
# Modify.........: NO.FUN-920035 09/05/20 BY lutingting由11區追單過來 1.單頭帳別依agli009設定自動帶出之後，應不可修改，設為NOENTRY                    
#                  2.單身ash04/ash06應依據單頭ash01輸入公司在agli009 所屬plant DB及帳別(ash04)/ash06找ash04上一層plant,檢查科目正確否/開窗資料一同處理
# Modify.........: NO.FUN-920111 09/05/20 By jan輸入會科加入非tiptop公司的邏輯
# Modify.........: NO.FUN-950051 09/05/22 By lutingting 由于agli002單頭增加"獨立會科合并"欄位,對檢查會科方式修改
# Modify.........: NO.FUN-950049 09/05/22 By jan ash11/ash12欄位給預設值
# Modify.........: NO.FUN-960062 09/06/02 BY yiting ggli001自動產生功能 
#                                            1.當下層公司為"非TIPTOP"公司，科目來源應為asi_file,合併會科也要檢查是否為非TIPTOP公司
#                                            2.合併科目應找出上層公司之後，判斷其會科存在的PLANT+合併帳別，自動帶出
# Modify.........: No.FUN-980003 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/21 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.FUN-990069 09/09/23 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.TQC-9B0069 09/11/18 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No:MOD-9C0382 09/12/23 By Sarah FUNCTION i001_getdbs(),抓取上層公司的SQL調整
# Modify.........: No.FUN-9C0072 10/01/05 By vealxu 精簡程式碼
# Modify.........: No.CHI-9C0038 10/01/25 By lutingting 科目可取結轉科目
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: NO.MOD-A60033 10/06/04 by Dido g_errno 清空問題 
# Modify.........: No.MOD-A20118 10/07/27 BY sabrina (1)AFTER FIELD ash04時，需判斷新舊值且要DISPLAY ash11、 ash12
#                                                    (2)執行整批產生時，應依agli102的aag04來設定"再衡量匯率"及"換算匯率"的值
# Modify.........: NO.MOD-A50019 10/07/27 by sabrina FOREACH i001_g裡的l_sql有誤
# Modify.........: NO.MOD-A70031 10/07/27 by sabrina 將重帶ash11/ash12的時機點移到若新舊值有異動時才需重帶 
# Modify.........: No.FUN-A30122 10/08/19 By vealxu 取合併帳別資料庫改由s_aaz641_asg，s_get_aaz641_asg取合併帳別 
# Modify.........: NO.MOD-AA0186 10/10/29 by Dido 匯率異動判斷調整 
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查詢自動過濾
# Modify.........: No.MOD-B30175 11/03/11 By lutingting 非TIPTO公司整批生成科目有問題 
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: NO.FUN-B60082 11/06/16 by belle AFTER FIELD ash04,ash06加入條件aag09 = 'Y'
# Modify.........: NO.TQC-B90008 11/09/01 BY Yitiing 整批匯入時，如果為TT公司，不用去處理aag08的邏輯
# Modify.........: NO.FUN-B90061 11/09/07 by belle 增加EXCEL匯入功能
# Modify.........: NO.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.FUN-D40130 13/04/27 By zhangweib 1.若整批產生"缺省會計科目"打鉤,則依原會計科目.若"缺省會計科目"沒有打鉤,則取母公司(g_plant)總帳參數agls103 aaz107的設置截取來源科目產生至合併科目；
#                                                        若aaz107沒有維護,則截取4碼.
#                                                      2.判斷合併科目ash06是否存在合併帳套(g_aaz641)的科目主檔中,若不存在,則合併科目ash06給空格

DATABASE ds
 
GLOBALS "../../config/top.global"    
#FUN-BA0006
 
#模組變數(Module Variables)
DEFINE  g_ash13         LIKE ash_file.ash13,      #FUN-910001 add    #FUN-BB0036
        g_ash13_t       LIKE ash_file.ash13,      #FUN-910001 add 
        g_ash01         LIKE ash_file.ash01,  
        g_ash01_t       LIKE ash_file.ash01, 
        g_ash01_o       LIKE ash_file.ash01,
        g_ash00         LIKE ash_file.ash00,   #No.FUN-730070
        g_ash00_t       LIKE ash_file.ash00,   #No.FUN-730070
        g_ash00_o       LIKE ash_file.ash00,   #No.FUN-730070
        g_ash           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        ash04       LIKE ash_file.ash04,                 
        ash05       LIKE ash_file.ash05,                 
        ash06       LIKE ash_file.ash06,                  
        aag02       LIKE aag_file.aag02,
        ash11       LIKE ash_file.ash11,   #FUN-580063
        ash12       LIKE ash_file.ash12    #FUN-580063
                    END RECORD,
    g_ash_t         RECORD                 #程式變數 (舊值)
        ash04       LIKE ash_file.ash04,                 
        ash05       LIKE ash_file.ash05,                 
        ash06       LIKE ash_file.ash06,
        aag02       LIKE aag_file.aag02,
        ash11       LIKE ash_file.ash11,   #FUN-580063
        ash12       LIKE ash_file.ash12    #FUN-580063
                    END RECORD,
    i               LIKE type_file.num5,           #No.FUN-680098 smallint
    g_wc,g_sql,g_wc2    STRING, #TQC-630166      
    g_sql_tmp           STRING, #No.FUN-730070
    g_rec_b         LIKE type_file.num5,           #單身筆數        #No.FUN-680098 smallint
    g_ss            LIKE type_file.chr1,           #No.FUN-680098  VARCHAR(1)
    g_dbs_gl        LIKE aag_file.aag01,           #No.FUN-680098  VARCHAR(24)
    g_plant_gl      LIKE aag_file.aag01,           #No.FUN-980025  VARCHAR(24)
    l_ac            LIKE type_file.num5,           #目前處理的ARRAY CNT     #No.FUN-680098 smallint
    g_cnt           LIKE type_file.num5,           #目前處理的ARRAY CNT     #No.FUN-680098 smallint 
    tm              RECORD 
           ash13       LIKE ash_file.ash13,      #FUN-910001 add 
           ash01  LIKE ash_file.ash01, 
           ash00  LIKE ash_file.ash00,             #No.FUN-730070
           y      LIKE type_file.chr1              #No.FUN-680098 VARCHAR(1)
       END RECORD
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL 
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680098 smallint
DEFINE g_asg03      LIKE asg_file.asg03            #FUN-760003 add    
DEFINE g_asg04      LIKE asg_file.asg04            #FUN-960062
DEFINE g_azp03      LIKE azp_file.azp03            #FUN-760003 add    
DEFINE g_azp01      LIKE azp_file.azp01            #TQC-9B0069
DEFINE g_dbs_o      LIKE asg_file.asg03            #FUN-760003 add    
DEFINE g_str        STRING                         #FUN-760085 add    
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose  #No.FUN-680098  smallint
DEFINE g_msg        LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680098  integer
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680098  integer
DEFINE g_jump       LIKE type_file.num10         #No.FUN-680098  integer
DEFINE g_no_ask     LIKE type_file.num5          #No.FUN-680098  smallint
DEFINE g_aaz641        LIKE aaz_file.aaz641      #FUN-920035                                                                        
DEFINE g_aaz641_g      LIKE aaz_file.aaz641      #FUN-920035                                                                        
DEFINE g_dbs_asg03     LIKE type_file.chr21      #FUN-920035                                                                        
DEFINE g_plant_asg03   LIKE type_file.chr21      #FUN-980025 add                                                                    
DEFINE g_asa_count     LIKE type_file.num5       #FUN-920035                                                                        
DEFINE g_ash00_def     LIKE ash_file.ash00       #FUN-920035  
DEFINE g_asb02         LIKE asb_file.asb02        #FUN-960062
DEFINE g_asg05         LIKE asg_file.asg05       #FUN-960062
DEFINE g_asg05_g       LIKE asg_file.asg05       #FUN-960062
DEFINE g_asg03_g       LIKE asg_file.asg03       #FUN-960062
DEFINE g_asg04_g       LIKE asg_file.asg04       #FUN-960062
DEFINE g_asa09         LIKE asa_file.asa09       #FUN-960062
DEFINE g_asa09_g       LIKE asa_file.asa09       #FUN-960062
#----以下為資料匯入時使用的變數----
#FUN-B90061--beatk--
DEFINE g_file          STRING
DEFINE g_disk          LIKE type_file.chr1
DEFINE g_ashl          RECORD LIKE ash_file.*
DEFINE l_table         STRING
DEFINE gg_sql          STRING
DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_choice        LIKE type_file.chr1
DEFINE g_i001_01       LIKE type_file.chr1000
#FUN-B90061---end---
MAIN
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
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
   LET g_ash13_t = NULL  #FUN-910001 add
   LET g_ash01_t = NULL
   LET g_ash00_t = NULL  #No.FUN-730070
 
   OPEN WINDOW i001_w WITH FORM "ggl/42f/ggli001"
        ATTRIBUTE(STYLE = g_win_style)
   
   CALL cl_ui_init()
 
   CALL i001_menu()
 
   CLOSE FORM i001_w                      #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i001_cs()
 
   CLEAR FORM                            #清除畫面
   CALL g_ash.clear()
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_ash13 TO NULL    #FUN-910001 add 
   INITIALIZE g_ash01 TO NULL    #No.FUN-750051
   INITIALIZE g_ash00 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON ash13,ash01,ash00,ash04,ash05,ash06,ash11,ash12  #No.FUN-730070  #FUN-910001 add ash13
                FROM ash13,ash01,ash00,s_ash[1].ash04,s_ash[1].ash05,                 #FUN-910001 add ash13
                     s_ash[1].ash06,s_ash[1].ash11,s_ash[1].ash12  #No.FUN-730070
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ash13) #族群編號                                                                                   
                 CALL cl_init_qry_var()                                                                                       
                 LET g_qryparam.state = "c"                                                                                   
                 LET g_qryparam.form = "q_asa1"                                                                               
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                           
                 DISPLAY g_qryparam.multiret TO ash13                                                                         
                 NEXT FIELD ash13                                                                                             
            WHEN INFIELD(ash01)  
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_asg"      #FUN-580063
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ash01  
               NEXT FIELD ash01
            WHEN INFIELD(ash00)  
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aaa"      #FUN-580063
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ash00  
               NEXT FIELD ash00
            WHEN INFIELD(ash04)  
               #CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_ash[1].ash04,'23',g_ash00)   #No.FUN-B60082 mark #No.FUN-980025 mark  
                CALL q_m_aag4(TRUE,TRUE,g_plant_gl,g_ash[1].ash04,'23',g_ash00)  #No.FUN-B60082 mod 
                     RETURNING g_qryparam.multiret    #No.MOD-480092
                DISPLAY g_qryparam.multiret TO ash04  #No.MOD-480092
               NEXT FIELD ash04
           WHEN INFIELD(ash06)  
              #CALL q_m_aag2(TRUE,TRUE,g_plant_asg03,g_ash[1].ash06,'23',g_aaz641)    #No.FUN-980025  #FUN-B50001                                              
              #CALL q_m_aag2(TRUE,TRUE,g_plant_asg03,g_ash[1].ash06,'23',g_asz01)     #No.FUN-B60082  mark
              #CALL q_m_aag4(TRUE,TRUE,g_plant_asg03,g_ash[1].ash06,'23',g_asz01)     #No.FUN-BA0012  mark #No.FUN-B60082
               CALL q_m_aag4(TRUE,TRUE,g_plant_asg03,g_ash[1].ash06,'23',g_aaz641)    #No.FUN-BA0012  add
                    RETURNING g_qryparam.multiret                                                                                   
               DISPLAY g_qryparam.multiret TO ash06                                                                                 
               NEXT FIELD ash06                                                                                                     
 
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
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ashuser', 'ashgrup') #FUN-980030
 
   IF INT_FLAG THEN
      RETURN 
   END IF
 
   LET g_sql = "SELECT UNIQUE ash13,ash01,ash00 FROM ash_file ",  #No.FUN-730070   #FUN-910001 add ash13 
               " WHERE ", g_wc CLIPPED,
               " ORDER BY ash13,ash01,ash00"    #No.FUN-730070    #FUN-910001 add ash13
   PREPARE i001_prepare FROM g_sql        #預備一下
   DECLARE i001_bcs SCROLL CURSOR WITH HOLD FOR i001_prepare
 
   LET g_sql_tmp = "SELECT UNIQUE ash13,ash01,ash00 ",    #FUN-910001 add ash13
                   "  FROM ash_file WHERE ", g_wc CLIPPED,
                   "  INTO TEMP x "
   DROP TABLE x
   PREPARE i001_pre_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i001_pre_x
   LET g_sql = "SELECT COUNT(*) FROM x"
   PREPARE i001_precount FROM g_sql
   DECLARE i001_count CURSOR FOR i001_precount
 
END FUNCTION
 
FUNCTION i001_menu()
 
   WHILE TRUE
      CALL i001_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i001_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i001_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i001_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i001_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i001_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "batch_generate"
            IF cl_chk_act_auth() THEN
               CALL i001_g()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_ash01 IS NOT NULL THEN
                  LET g_doc.column1 = "ash13"                                                                               
                  LET g_doc.value1 = g_ash13                                                                                
                  LET g_doc.column2 = "ash01"                                                                               
                  LET g_doc.value2 = g_ash01                                                                                
                  LET g_doc.column3 = "ash00"                                                                               
                  LET g_doc.value3 = g_ash00                                                                                
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ash),'','')
            END IF
        #FUN-B90061--beatk--
         WHEN "dataload"                        # 資料匯入
            CALL i001_dataload()
        #FUN-B90061---end--- 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i001_a()
 
   IF s_aglshut(0) THEN
      RETURN
   END IF  
 
   MESSAGE ""
   CLEAR FORM
   CALL g_ash.clear()
   INITIALIZE g_ash13 LIKE ash_file.ash13      #DEFAULT 設定  #FUN-910001 add  
   INITIALIZE g_ash01 LIKE ash_file.ash01         #DEFAULT 設定
   INITIALIZE g_ash00 LIKE ash_file.ash00         #DEFAULT 設定  #No.FUN-730070
 
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i001_i("a")                           #輸入單頭
 
      IF INT_FLAG THEN                           #使用者不玩了
         LET g_ash13=NULL  #FUN-910001 add
         LET g_ash01=NULL
         LET g_ash00=NULL  #No.FUN-730070
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      LET g_rec_b = 0                    #No.FUN-680064
      IF g_ss='N' THEN
         CALL g_ash.clear()
      ELSE
         CALL i001_b_fill('1=1')         #單身
      END IF
 
      CALL i001_b()                       #輸入單身
 
      LET g_ash13_t = g_ash13            #保留舊值  #FUN-910001 add 
      LET g_ash01_t = g_ash01             #保留舊值
      LET g_ash00_t = g_ash00             #保留舊值  #No.FUN-730070
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i001_i(p_cmd)
DEFINE
   l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入   #No.FUN-680098 VARCHAR(1)
   l_n1,l_n        LIKE type_file.num5,          #No.FUN-680098  smallint
   p_cmd           LIKE type_file.chr1           #a:輸入 u:更改        #No.FUN-680098 VARCHAR(1)
 
   LET g_ss = 'Y'
 
   DISPLAY g_ash13 TO ash13   #FUN-910001 add 
   DISPLAY g_ash01 TO ash01 
   DISPLAY g_ash00 TO ash00   #No.FUN-730070
   CALL cl_set_head_visible("","YES")            #No.FUN-6B0029
   INPUT g_ash13,g_ash01,g_ash00 WITHOUT DEFAULTS FROM ash13,ash01,ash00 #No.FUN-730070  #FUN-910001 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i001_set_entry(p_cmd) 
         CALL i001_set_no_entry(p_cmd) 
         LET g_before_input_done = TRUE
 
      AFTER FIELD ash13   #族群代號                                                                                         
         IF cl_null(g_ash13) THEN                                                                                           
            CALL cl_err(g_ash13,'mfg0037',0)                                                                                
            NEXT FIELD ash13                                                                                                
         ELSE                                                                                                               
            LET l_n = 0                                                                                                     
            SELECT COUNT(*) INTO l_n FROM asa_file                                                                          
             WHERE asa01=g_ash13                                                                                            
            IF cl_null(l_n) THEN LET l_n = 0 END IF                                                                         
            IF l_n = 0 THEN                                                                                                 
               CALL cl_err(g_ash13,'agl-223',0)                                                                             
               NEXT FIELD ash13                                                                                             
            END IF                                                                                                          
        END IF                                                                                                             
 
      AFTER FIELD ash01 
         IF NOT cl_null(g_ash01) THEN 
               CALL i001_ash01('a',g_ash01)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ash01,g_errno,0)
                  NEXT FIELD ash01
               END IF
             IF g_ash13 IS NOT NULL AND g_ash01 IS NOT NULL AND                                                              
                g_ash00 IS NOT NULL THEN                                                                                     
                LET l_n = 0   LET l_n1 = 0                                                                                   
                SELECT COUNT(*) INTO l_n FROM asa_file                                                                       
                 WHERE asa01=g_ash13 AND asa02=g_ash01                                                                       
                   AND asa03=g_ash00                                                                                         
                SELECT COUNT(*) INTO l_n1 FROM asb_file                                                                      
                WHERE asb01=g_ash13 AND asb04=g_ash01                                                                       
                  AND asb05=g_ash00                                                                                         
                IF l_n+l_n1 = 0 THEN                                                                                         
                   CALL cl_err(g_ash01,'agl-223',0)                                                                          
                   LET g_ash13 = g_ash13_t                                                                                   
                   LET g_ash01 = g_ash01_t                                                                                   
                   LET g_ash00 = g_ash00_t                                                                                   
                   DISPLAY BY NAME g_ash13,g_ash01,g_ash00                                                                   
                   NEXT FIELD ash01                                                                                          
                END IF                                                                                                       
             END IF                                                                                                          
         END IF
 
      AFTER FIELD ash00
         IF cl_null(g_ash01) THEN NEXT FIELD ash01 END IF
         IF NOT cl_null(g_ash00) THEN
            CALL i001_ash00('a',g_ash00)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ash00,g_errno,0)
               NEXT FIELD ash00
            END IF
            #增加公司+帳別的合理性判斷,應存在agli009
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM asg_file
             WHERE asg01=g_ash01 AND asg05=g_ash00
            IF l_n = 0 THEN
               CALL cl_err(g_ash00,'agl-946',0)
               NEXT FIELD ash00
            END IF
            IF g_ash13 != g_ash13_t OR cl_null(g_ash13_t) OR                                                                
               g_ash01 != g_ash01_t OR cl_null(g_ash01_t) OR                                                                
               g_ash00 != g_ash00_t OR cl_null(g_ash00_t) THEN                                                              
               LET g_cnt = 0 
               SELECT COUNT(*) INTO g_cnt FROM ash_file
                WHERE ash01=g_ash01
                  AND ash00=g_ash00
                  AND ash13=g_ash13   #FUN-910001 add 
               IF g_cnt = 0  THEN             #不存在, 新來的  #No.TQC-740199
                  IF p_cmd = 'a' THEN 
                     LET g_ss = 'N' 
                  END IF
               ELSE
                  IF p_cmd='u' THEN
                     CALL cl_err(g_ash01,-239,0)
                     LET g_ash13=g_ash13_t   #FUN-910001 add
                     LET g_ash01=g_ash01_t
                     LET g_ash00=g_ash00_t
                     NEXT FIELD ash01
                  END IF
               END IF
               LET l_n = 0   LET l_n1 = 0                                                                                           
               SELECT COUNT(*) INTO l_n FROM asa_file                                                                               
                WHERE asa01=g_ash13 AND asa02=g_ash01                                                                               
                  AND asa03=g_ash00                                                                                                 
               SELECT COUNT(*) INTO l_n1 FROM asb_file                                                                              
                WHERE asb01=g_ash13 AND asb04=g_ash01                                                                               
                  AND asb05=g_ash00                                                                                                 
               IF l_n+l_n1 = 0 THEN                                                                                                 
                  CALL cl_err(g_ash01,'agl-223',0)                                                                                  
                  LET g_ash13 = g_ash13_t                                                                                           
                  LET g_ash01 = g_ash01_t                                                                                           
                  LET g_ash00 = g_ash00_t                                                                                           
                  DISPLAY BY NAME g_ash13,g_ash01,g_ash00                                                                           
                  NEXT FIELD ash01                                                                                                  
               END IF                                                                                                               
            END IF
         END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
        
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ash13) #族群編號                                                                                           
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_asa1"                                                                                        
               LET g_qryparam.default1 = g_ash13                                                                                    
               CALL cl_create_qry() RETURNING g_ash13                                                                               
               DISPLAY g_ash13 TO ash13                                                                                             
               NEXT FIELD ash13                                                                                                     
            WHEN INFIELD(ash01)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asg"     #FUN-580063
               LET g_qryparam.default1 = g_ash01
               CALL cl_create_qry() RETURNING g_ash01
               DISPLAY g_ash01 TO ash01 
               NEXT FIELD ash01
            WHEN INFIELD(ash00)  
               SELECT azp03 INTO g_azp03 FROM asg_file,azp_file
                WHERE asg01=g_ash01 AND asg03=azp01                
               SELECT azp01 INTO g_azp01 FROM asg_file,azp_file       #No.TQC-9B0069
                WHERE asg01=g_ash01 AND asg03=azp01                   #No.TQC-9B0069
               IF cl_null(g_azp03) THEN LET g_azp03 = g_dbs END IF  
               IF cl_null(g_azp01) THEN LET g_azp01 = g_plant END IF  #No.TQC-9B0069
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa4"    #FUN-580063   #TQC-760205 q_aaa->q_aaa4
               LET g_qryparam.default1 = g_ash00
               LET g_qryparam.plant = g_azp01                 #No.TQC-9B0069
               CALL cl_create_qry() RETURNING g_ash00
               DISPLAY g_ash00 TO ash00 
               NEXT FIELD ash00
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
   
FUNCTION i001_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("ash13,ash01,ash00",TRUE)  #No.FUN-73070  #FUN-910001 add ash13 
   END IF 
 
END FUNCTION
 
FUNCTION i001_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("ash13,ash01,ash00",FALSE)   #No.FUN-73070    #FUN-910001 add ash13 
   END IF 
 
   CALL cl_set_comp_entry("ash00",FALSE)  #FUN-920035  
END FUNCTION
 
FUNCTION i001_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   CALL cl_set_comp_entry("ash05",TRUE)
END FUNCTION
 
FUNCTION i001_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
          l_asg04 LIKE asg_file.asg04
 
   SELECT asg04 INTO l_asg04 FROM asg_file
      WHERE asg01 = g_ash01
   IF l_asg04 = 'Y' THEN
      CALL cl_set_comp_entry ("ash05",FALSE)
   END IF
END FUNCTION
 
FUNCTION  i001_ash01(p_cmd,p_ash01)   #FUN-580063 將本段中所有azp改成asg
 
DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
       p_ash01         LIKE ash_file.ash01,
       l_asg02         LIKE asg_file.asg02,
       l_asg03         LIKE asg_file.asg03,
       l_asg05         LIKE asg_file.asg05    #TQC-760205 add
 
    LET g_errno = ' '
 
    SELECT asg02,asg03,asg05 INTO l_asg02,l_asg03,l_asg05   #TQC-760205 add asg05 
      FROM asg_file
     WHERE asg01 = p_ash01
 
    IF p_cmd = 'a' THEN 
       LET g_ash00 = l_asg05 
       DISPLAY g_ash00 TO ash00
    END IF
 
    CASE
       WHEN SQLCA.SQLCODE=100 
         #LET g_errno = 'mfg9142'   #TQC-910022 mark
          LET g_errno = 'aco-025'   #TQC-910022
          LET l_asg02 = NULL
          LET l_asg03 = NULL 
       OTHERWISE
          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_asg02 TO FORMONLY.asg02 
       DISPLAY l_asg03 TO FORMONLY.asg03
       DISPLAY l_asg05 TO FORMONLY.ash00  #FUN-920035   
    END IF
 
END FUNCTION
 
FUNCTION i001_ash00(p_cmd,p_ash00)
  DEFINE p_cmd     LIKE type_file.chr1,  
         p_ash00   LIKE ash_file.ash00,
         l_aaaacti LIKE aaa_file.aaaacti,
        #l_azp03   LIKE azp_file.azp03   #MOD-920248 add  #FUN-A50102
         l_azp01   LIKE azp_file.azp01   #FUN-A50102
 
    LET g_errno = ' '
   #SELECT azp03 INTO l_azp03 FROM azp_file,asg_file  #FUN-A50102
    SELECT azp01 INTO l_azp01 FROM azp_file,asg_file  #FUN-A50102
     WHERE azp01 = asg03 
       AND asg01 = g_ash01
   #LET g_sql = "SELECT aaaacti FROM ",s_dbstring(l_azp03),"aaa_file",  #TQC-950003 ADD  #FUN-A50102
    LET g_sql = "SELECT aaaacti FROM ",cl_get_target_table(l_azp01,'aaa_file'),  #FUN-A50102   
                " WHERE aaa01 = '",p_ash00,"'"
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql    #FUN-750088
    CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql  #FUN-A50102 
    PREPARE aaa_pre FROM g_sql
    DECLARE aaa_cs CURSOR FOR aaa_pre
    OPEN aaa_cs 
    FETCH aaa_cs INTO l_aaaacti
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
END FUNCTION
 
FUNCTION i001_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_ash13 TO NULL             #FUN-910001 add 
   INITIALIZE g_ash01 TO NULL             #No.FUN-6B0040
   INITIALIZE g_ash00 TO NULL             #No.FUN-6B0040  #No.FUN-730070
   MESSAGE ""
   CLEAR FORM
   CALL g_ash.clear()
 
   CALL i001_cs()                         #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN i001_bcs                          #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                  #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ash13 TO NULL  #FUN-910001 add
      INITIALIZE g_ash01 TO NULL
      INITIALIZE g_ash00 TO NULL  #No.FUN-730070
   ELSE
      CALL i001_fetch('F')                #讀出TEMP第一筆並顯示
 
      OPEN i001_count
      FETCH i001_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
   END IF
END FUNCTION
 
FUNCTION i001_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098 integer
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i001_bcs INTO g_ash13,g_ash01,g_ash00  #No.FUN-730070  #FUN-910001 add ash13
      WHEN 'P' FETCH PREVIOUS i001_bcs INTO g_ash13,g_ash01,g_ash00  #No.FUN-730070  #FUN-910001 add ash13
      WHEN 'F' FETCH FIRST    i001_bcs INTO g_ash13,g_ash01,g_ash00  #No.FUN-730070  #FUN-910001 add ash13
      WHEN 'L' FETCH LAST     i001_bcs INTO g_ash13,g_ash01,g_ash00  #No.FUN-730070  #FUN-910001 add ash13
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
 
           FETCH ABSOLUTE g_jump i001_bcs INTO g_ash13,g_ash01,g_ash00  #No.FUN-730070  #FUN-910001 add ash13
           LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_ash01,SQLCA.sqlcode,0)
      INITIALIZE g_ash13 TO NULL  #FUN-910001 add  
      INITIALIZE g_ash01 TO NULL  #TQC-6B0105
      INITIALIZE g_ash00 TO NULL  #TQC-6B0105  #No.FUN-730070
   ELSE
      CALL i001_show()
 
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
 
FUNCTION i001_show()
 
   DISPLAY g_ash13 TO ash13      #FUN-910001 add 
   DISPLAY g_ash01 TO ash01 
   DISPLAY g_ash00 TO ash00      #No.FUN-730070
 
   CALL i001_ash01('d',g_ash01)
   CALL i001_ash00('d',g_ash00)  #No.FUN-730070
 
   CALL i001_getdbs(g_ash01,g_ash13)   #FUN-960062 add
   CALL s_aaz641_asg(g_ash13,g_ash01) RETURNING g_plant_asg03       #FUN-A30122
   CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_aaz641              #FUN-A30122
   CALL i001_b_fill(g_wc)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i001_r()
   DEFINE l_chr LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF s_aglshut(0) THEN RETURN END IF
 
   IF cl_null(g_ash13) OR cl_null(g_ash01) OR cl_null(g_ash00) THEN   #No.FUN-730070  #FUN-910001 
      CALL cl_err('',-400,0)
      RETURN 
   END IF
 
   BEGIN WORK
 
   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ash13"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ash13       #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "ash01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_ash01       #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "ash00"      #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_ash00       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM ash_file WHERE ash01=g_ash01 
                             AND ash00=g_ash00  #No.FUN-730070
                             AND ash13=g_ash13  #FUN-910001 add
      IF SQLCA.sqlcode THEN
          CALL cl_err3("del","ash_file",g_ash01,g_ash00,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660123  #No.FUN-730070
      ELSE
         CLEAR FORM
         CALL g_ash.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
 
         DROP TABLE x
         PREPARE i003_pre_x2 FROM g_sql_tmp
         EXECUTE i003_pre_x2              
         OPEN i001_count
         FETCH i001_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
 
         OPEN i001_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i001_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i001_fetch('/')
         END IF
      END IF
 
      LET g_msg=TIME
 
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980003 add plant,legal
                   VALUES ('ggli001',g_user,g_today,g_msg,g_ash01,'delete',g_plant,g_legal) ##FUN-980003 add plant,legal
   END IF
 
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i001_b()
DEFINE
    l_ash05         LIKE ash_file.ash05,
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT #No.FUN-680098 smallint
    l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680098 smallint
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        #No.FUN-680098 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態          #No.FUN-680098 VARCHAR(1)
    l_sql           LIKE type_file.chr1000,   #No.FUN-680098   VARCHAR(150)
    l_allow_insert  LIKE type_file.chr1,      #可新增否  #No.FUN-680098 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1,      #可刪除否  #No.FUN-680098 VARCHAR(1)
    l_asg04         LIKE asg_file.asg04,      #MOD-5A0443 
    l_asg03         LIKE asg_file.asg03       #TQC-660043
DEFINE l_asb02      LIKE asb_file.asb02       #FUN-920035 
DEFINE l_asa09      LIKE asa_file.asa09       #FUN-950051
DEFINE l_aag04      LIKE aag_file.aag04       #FUN-950049
 
   IF s_aglshut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   CALL s_aaz641_asg(g_ash13,g_ash01) RETURNING g_plant_asg03        #FUN-A30122 add
   CALL i001_getdbs(g_ash01,g_ash13)   #FUN-960062 add
   CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_aaz641               #FUN-A30122 add  
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT ash04,ash05,ash06,'',ash11,ash12 FROM ash_file ",  #FUN-580063
                      " WHERE ash13= ? AND ash01= ? AND ash00 = ? AND ash04 = ? FOR UPDATE "  #No.FUN-730070   #FUN-910001 add ash13 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i001_bcl CURSOR FROM g_forupd_sql       # LOCK CURSOR
 
   LET l_ac_t = 0
   INPUT ARRAY g_ash WITHOUT DEFAULTS FROM s_ash.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,
                   DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         LET g_action_choice = ""
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
            LET g_ash_t.* = g_ash[l_ac].*  #BACKUP
 
            OPEN i001_bcl USING g_ash13,g_ash01,g_ash00,g_ash_t.ash04  #No.FUN-730070  #FUN-910001  
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ash_t.ash04,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i001_bcl INTO g_ash[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ash_t.ash04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i001_ash06(l_ac)
                  LET g_errno = ' '                        #MOD-A60033 
               END IF
            END IF
 
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF 
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ash[l_ac].* TO NULL
         LET g_ash_t.* = g_ash[l_ac].*  
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD ash04
 
      AFTER INSERT
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO ash_file(ash00,ash01,ash04,ash05,ash06,ash11,ash12,ashacti,ashuser,  #No.FUN-730070
                              ashgrup,ashmodu,ashdate,ash13,ashoriu,ashorig)  #FUN-910001 add ash13
                       VALUES(g_ash00,g_ash01,g_ash[l_ac].ash04,g_ash[l_ac].ash05,  #No.FUN-730070
                              g_ash[l_ac].ash06,g_ash[l_ac].ash11,g_ash[l_ac].ash12,
                              'Y',g_user,g_grup,g_user,g_today,g_ash13, g_user, g_grup)  #FUN-910001 add g_ash13      #No.FUN-980030 10/01/04  insert columns oriu, orig
 
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ash_file",g_ash01,g_ash[l_ac].ash04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD ash04
         IF NOT cl_null(g_ash[l_ac].ash04) THEN 
               #FUN-A30122 --------------------add start----------------------------
               LET l_asg04 = ' ' 
               SELECT asg04 INTO l_asg04 FROM asg_file
                WHERE asg01 = g_ash01
               #FUN-A30122 --------------------add end----------------------------- 
              #IF g_ash[l_ac].ash04 != g_ash_t.ash04 THEN     #MOD-A20118 add                                       #MOD-AA0186 mark 
               IF (g_ash_t.ash04 IS NOT NULL AND g_ash[l_ac].ash04 != g_ash_t.ash04) OR g_ash_t.ash04 IS NULL THEN  #MOD-AA0186
                  LET l_asg04 = ' '
                  SELECT asg04 INTO l_asg04 FROM asg_file
                     WHERE asg01 = g_ash01
                  IF l_asg04 = 'N' THEN   #非TIPTOP公司
                      LET l_sql = " SELECT count(*) ",
                                  #" FROM ",g_dbs_gl,"asi_file",   #FUN-A50102
                                   "  FROM ",cl_get_target_table(g_plant_gl,'asi_file'),   #FUN-A50102
                                   " WHERE asi04 = '",g_ash01,"'",
                                   " AND asi01 = '",g_ash13,"'",
                                   " AND asi041 = '",g_ash00,"'",
                                   " AND asi05 = '", g_ash[l_ac].ash04,"'"
                      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql  #FUN-A50102
                      PREPARE asi_sel3 FROM l_sql 
                      EXECUTE asi_sel3 INTO l_n
                      IF l_n=0 THEN
                         CALL cl_err(g_ash[l_ac].ash04,'agl-229',0)
                         NEXT FIELD ash04
                      END IF
                  ELSE
                     #LET l_sql = " SELECT COUNT(*) FROM ",g_dbs_gl,"aag_file",  #FUN-A50102
                      LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_gl,'aag_file'),  #FUN-A50102 
                                 #" WHERE aag03 = '2' AND aag00 = '",g_ash00,"'",   #CHI-9C0038
                                  " WHERE aag00 = '",g_ash00,"' ",                  #CHI-9C0038
                                  " AND aag09 = 'Y'",                               #FUN-B60082
               	                  " AND aag07 IN ('2','3')"
                      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql  #FUN-A50102
                      DECLARE asi_sel4 CURSOR FROM l_sql
                      OPEN asi_sel4 
                      FETCH asi_sel4 INTO l_n
                      CLOSE asi_sel4 
                      IF l_n=0 THEN
                         CALL cl_err(g_ash[l_ac].ash04,'agl-229',0)
                         NEXT FIELD ash04
                      END IF                                     
                  END IF
                  LET g_errno = ' '
                  LET l_ash05 = ' '
                 #MOD-A70031---add---start---
                  LET l_aag04 = ''
                  LET l_sql = " SELECT aag04 FROM ",cl_get_target_table(g_plant_gl,'aag_file'),
                              "  WHERE aag00 = '",g_ash00,"'",
                              "    AND aag09 = 'Y'",                       #FUN-B60082
                              "    AND aag01 = '",g_ash[l_ac].ash04,"'"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
                  CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql 
                  DECLARE aag_sel_c CURSOR FROM l_sql
                  OPEN aag_sel_c 
                  FETCH aag_sel_c INTO l_aag04
                  CLOSE aag_sel_c 
                  IF cl_null(l_aag04) OR l_aag04 = '1' THEN  
                     LET g_ash[l_ac].ash11 = '1'
                     LET g_ash[l_ac].ash12 = '1'
                  ELSE
                     LET g_ash[l_ac].ash11 = '3'
                     LET g_ash[l_ac].ash12 = '3'
                  END IF
          END IF                     #FUN-A30122 add
                 #MOD-A70031---add---end---
                  IF l_asg04 = 'Y' THEN 
                     #CALL s_m_aag(g_plant_gl,g_ash[l_ac].ash04,g_ash00) RETURNING l_ash05   #No.FUN-730070  #FUN-990069 #CHI-9C0038
                     CALL i001_ash04(l_ac)   #CHI-9C0038
                     #FUN-A30122 -------------------------add start------------------------
                     LET g_sql = "SELECT aag02 ",
                                 "  FROM ",cl_get_target_table(g_plant_gl,'aag_file'),       
                                 " WHERE aag01 = '",g_ash[l_ac].ash04,"'",
                                 "   AND aag09 = 'Y'",               #No.FUN-B60082
                                 "   AND aag00 = '",g_ash00,"'"
                     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                     CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql  
                     PREPARE i001_sel_aag1 FROM g_sql  
                     DECLARE i001_cur_aag1 CURSOR FOR i001_sel_aag1
                     OPEN i001_cur_aag1
                     FETCH i001_cur_aag1 INTO g_ash[l_ac].ash05 
                     DISPLAY BY NAME g_ash[l_ac].ash05 
                     #FUN-A30122 -----------------------add end----------------------------      
                  ELSE                                                                       #FUN-760053 add
		      LET l_sql = " SELECT asi051",
                                 #" FROM ",g_dbs_gl," asi_file", #FUN-A50102
                                  " FROM ",cl_get_target_table(g_plant_gl,'asi_file'),  #FUN-A50102
                                  " WHERE asi04 = '",g_ash01,"'",
                                  " AND asi01 = '",g_ash13,"'",
                                  " AND asi041 = '",g_ash00,"'",
                                  " AND asi05 = '", g_ash[l_ac].ash04,"'"
                      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql  #FUN-A50102
                      PREPARE asi_sel1 FROM l_sql
                      DECLARE asi_sel2 SCROLL CURSOR FOR asi_sel1
                      OPEN asi_sel2
                      FETCH FIRST   asi_sel2  INTO l_ash05
                      CLOSE asi_sel2          
                  END IF
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_ash[l_ac].ash04,g_errno,0)
                     #FUN-B20004--beatk
                     #LET g_ash[l_ac].ash04=g_ash_t.ash04
                     IF l_asg04 = 'Y' THEN 
                       #CALL q_m_aag2(FALSE,FALSE,g_plant_gl,g_ash[l_ac].ash04,'23',g_ash00) #No.FUN-B60082 mark
                        CALL q_m_aag4(FALSE,FALSE,g_plant_gl,g_ash[l_ac].ash04,'23',g_ash00) #No.FUN-B60082 add
                             RETURNING g_ash[l_ac].ash04
                     ELSE 
                        CALL q_m_asi3(FALSE,FALSE,g_plant_gl,g_ash[l_ac].ash04,g_ash[l_ac].ash05,g_ash01,g_ash13,g_ash00) 
                             RETURNING g_ash[l_ac].ash04,g_ash[l_ac].ash05                     	  
                     END IF 
                     #FUN-B20004--end
                     NEXT FIELD ash04
                  END IF
                  IF cl_null(g_ash[l_ac].ash05) THEN 
                     LET g_ash[l_ac].ash05 = l_ash05
                  END IF
               END IF         #MOD-A20118 add
            #MOD-A70031---mark---start---    #往上移到判斷新舊值裡執行此動作
            #  LET l_aag04 = ''
            # #LET l_sql = " SELECT aag04 FROM ",g_dbs_gl," aag_file",   #FUN-A50102
            #  LET l_sql = " SELECT aag04 FROM ",cl_get_target_table(g_plant_gl,'aag_file'),  #FUN-A50102 
            #              "  WHERE aag00 = '",g_ash00,"'",
            #              "    AND aag01 = '",g_ash[l_ac].ash04,"'"
            #  CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
            #  CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql  #FUN-A50102
            #       DECLARE aag_sel_c CURSOR FROM l_sql
            #  OPEN aag_sel_c 
            #  FETCH aag_sel_c INTO l_aag04
            #  CLOSE aag_sel_c 
            #  IF cl_null(l_aag04) OR l_aag04 = '1' THEN   #FUN-960062 
            #     LET g_ash[l_ac].ash11 = '1'
            #     LET g_ash[l_ac].ash12 = '1'
            #  ELSE
            #     LET g_ash[l_ac].ash11 = '3'
            #     LET g_ash[l_ac].ash12 = '3'
            #  END IF
            #MOD-A70031---mark---end---
        #END IF                      #FUN-A30122 mark
         DISPLAY BY NAME g_ash[l_ac].ash11,g_ash[l_ac].ash12      #MOD-A20118 add
         CALL i001_set_entry_b(p_cmd)   #MOD-5A0443
         CALL i001_set_no_entry_b(p_cmd)   #MOD-5A0443
 
      AFTER FIELD ash06
         IF NOT cl_null(g_ash[l_ac].ash06) THEN 
            CALL i001_ash06(l_ac)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ash[l_ac].ash06,g_errno,0)
               #FUN-B20004--beatk
              #CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_ash[1].ash06,'23',g_aaz641)       #FUN-B50001
              #CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_ash[1].ash06,'23',g_asz01)        #FUN-B60082 mark
              #CALL q_m_aag4(FALSE,FALSE,g_plant_asg03,g_ash[1].ash06,'23',g_asz01)        #FUN-BA0012 #FUN-B60082 mod
               CALL q_m_aag4(FALSE,FALSE,g_plant_asg03,g_ash[1].ash06,'23',g_aaz641)       #FUN-BA0012 #FUN-B60082 mod
                    RETURNING g_ash[l_ac].ash06                       
               #LET g_ash[l_ac].ash06=g_ash_t.ash06
               #FUN-B20004--end
               NEXT FIELD ash06
            END IF
         END IF
      
      BEFORE DELETE                            #是否取消單身
         IF g_ash_t.ash04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
 
            DELETE FROM ash_file
             WHERE ash01 = g_ash01 AND ash04 = g_ash_t.ash04 
               AND ash00 = g_ash00 AND ash13 = g_ash13  #No.FUN-730070  #FUN-910001 add ash13
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ash_file",g_ash01,g_ash[l_ac].ash04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               ROLLBACK WORK
               CANCEL DELETE
            END IF
 
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ash[l_ac].* = g_ash_t.*
            CLOSE i001_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN 
            CALL cl_err(g_ash[l_ac].ash04,-263,0)
            LET g_ash[l_ac].* = g_ash_t.*
         ELSE 
            UPDATE ash_file SET ash04 = g_ash[l_ac].ash04,
                                ash05 = g_ash[l_ac].ash05,
                                ash06 = g_ash[l_ac].ash06,
                                ash11 = g_ash[l_ac].ash11,   #FUN-580063
                                ash12 = g_ash[l_ac].ash12,   #FUN-580063
                                ashmodu = g_user,
                                ashdate = g_today
             WHERE ash01 = g_ash01 
               AND ash00 = g_ash00  #No.FUN-730070
               AND ash13 = g_ash13  #FUN-910001 add 
               AND ash04 = g_ash_t.ash04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ash_file",g_ash01,g_ash_t.ash04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               LET g_ash[l_ac].* = g_ash_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()         # 新增
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_ash[l_ac].* = g_ash_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_ash.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end-- 
            END IF
            CLOSE i001_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  
         CLOSE i001_bcl
         COMMIT WORK
      
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(ash04) AND l_ac > 1 THEN
            LET g_ash[l_ac].* = g_ash[l_ac-1].*
            NEXT FIELD ash04
         END IF
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ash04)  
                SELECT asg04 INTO l_asg04  FROM asg_file WHERE asg01 = g_ash01
                IF l_asg04 = 'N' THEN 
                    CALL q_m_asi3(FALSE,TRUE,g_plant_gl,g_ash[l_ac].ash04,g_ash[l_ac].ash05,g_ash01,g_ash13,g_ash00) #No.FUN-980025 
                       RETURNING g_ash[l_ac].ash04,g_ash[l_ac].ash05
                ELSE    
                   #CALL q_m_aag2(FALSE,TRUE,g_plant_gl,g_ash[l_ac].ash04,'23',g_ash00) #No.FUN-B60082 mark #No.FUN-980025 
                    CALL q_m_aag4(FALSE,TRUE,g_plant_gl,g_ash[l_ac].ash04,'23',g_ash00) #No.FUN-B60082 mod 
                    RETURNING g_ash[l_ac].ash04
                END IF 
                DISPLAY BY NAME g_ash[l_ac].ash04           #No.MOD-490344
                NEXT FIELD ash04
            WHEN INFIELD(ash06) 
              #CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_ash[1].ash06,'23',g_aaz641)    #No.FUN-980025     #FUN-B50001                                           
              #CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_ash[1].ash06,'23',g_asz01)     #No.FUN-B60082 mark
              #CALL q_m_aag4(FALSE,TRUE,g_plant_asg03,g_ash[1].ash06,'23',g_asz01)     #FUN-BA0012 #No.FUN-B60082 mod
               CALL q_m_aag4(FALSE,TRUE,g_plant_asg03,g_ash[1].ash06,'23',g_aaz641)    #FUN-BA0012 #No.FUN-B60082 mod
               RETURNING g_ash[l_ac].ash06                                                                                     
               DISPLAY g_qryparam.multiret TO ash06                                                                                 
               NEXT FIELD ash06                                                                                                     
            OTHERWISE EXIT CASE
         END CASE
 
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
       ON ACTION controls                                        
          CALL cl_set_head_visible("","AUTO")                    
 
   END INPUT
 
   CLOSE i001_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i001_ash06(l_cnt)
DEFINE
    l_cnt           LIKE type_file.num5,          #No.FUN-680098 smallint
    l_aag02         LIKE aag_file.aag02,
    l_aag03         LIKE aag_file.aag03,
    l_aag07         LIKE aag_file.aag07,
    l_aagacti       LIKE aag_file.aagacti
DEFINE l_asa09      LIKE asa_file.asa09   #FUN-950051
 
    LET g_errno = ' '
 
   LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",                                                                                 
              #"  FROM ",g_dbs_asg03,"aag_file",       #FUN-A50102
               "  FROM ",cl_get_target_table(g_plant_asg03,'aag_file'),   #FUN-A50102                                                                                  
               " WHERE aag01 = '",g_ash[l_cnt].ash06,"'",                                                                           
               "   AND aag00 = '",g_aaz641,"'"                                                                                      
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032                                                            
   CALL cl_parse_qry_sql(g_sql,g_plant_asg03) RETURNING g_sql   #FUN-A50102
   PREPARE i001_pre_05 FROM g_sql                                                                                                   
   DECLARE i001_cur_05 CURSOR FOR i001_pre_05                                                                                       
   OPEN i001_cur_05                                                                                                                 
   FETCH i001_cur_05 INTO l_aag02,l_aag03,l_aag07,l_aagacti                                                                         
 
    CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001' 
         WHEN l_aagacti = 'N'     LET g_errno = '9028' 
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015' 
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE 
 
   #FUN-B60082--beatk--
    IF SQLCA.sqlcode = 0 THEN
       LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",                                                                                 
                   "  FROM ",g_dbs_asg03,"aag_file",                                                                                    
                   " WHERE aag01 = '",g_ash[l_cnt].ash06,"'",                                                                           
                  #"  AND aag00 = '",g_asz01,"'",      #FUN-BA0012
                   "  AND aag00 = '",g_aaz641,"'",     #FUN-BA0012
                   "  AND aag09 = 'Y'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                    
       PREPARE i001_pre_06 FROM g_sql                                                                                                   
       DECLARE i001_cur_06 CURSOR FOR i001_pre_06 
       OPEN i001_cur_06
       FETCH i001_cur_06 INTO l_aag02,l_aag03,l_aag07,l_aagacti                                                                         

       CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-214'
            WHEN l_aagacti = 'N'     LET g_errno = '9028'
            WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
            OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
       END CASE 
    END IF
   #FUN-B60082---end---
 
    IF cl_null(g_errno) THEN
       LET g_ash[l_cnt].aag02 = l_aag02
    END IF
    
END FUNCTION
   
#CHI-9C0038--add--str--
FUNCTION i001_ash04(l_cnt)                    
DEFINE
    l_cnt           LIKE type_file.num5,
    l_aag02         LIKE aag_file.aag02,
    l_aag03         LIKE aag_file.aag03,
    l_aag07         LIKE aag_file.aag07,
    l_aagacti       LIKE aag_file.aagacti

    LET g_errno = ' '                                   #MOD-A60033 
    LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
               #"  FROM ",g_dbs_gl,"aag_file",  #FUN-A50102
                "  FROM ",cl_get_target_table(g_plant_gl,'aag_file'),   #FUN-A50102
                " WHERE aag01 = '",g_ash[l_cnt].ash04,"'",            
                "   AND aag00 = '",g_ash00,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql   #FUN-A50102
   PREPARE i001_sel_aag FROM g_sql
   DECLARE i001_cur_aag CURSOR FOR i001_sel_aag
   OPEN i001_cur_aag
   FETCH i001_cur_aag INTO l_aag02,l_aag03,l_aag07,l_aagacti

    CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
         WHEN l_aagacti = 'N'     LET g_errno = '9028'
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE

    #FUN-B60082--beatk--
     IF SQLCA.sqlcode = 0 THEN
     LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                "  FROM ",g_dbs_gl,"aag_file",
                " WHERE aag01 = '",g_ash[l_cnt].ash04,"'",
                "   AND aag00 = '",g_ash00,"'",
                "   AND aag09 = 'Y'" 
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     PREPARE i001_sel_cs7 FROM g_sql
     DECLARE i001_cur_cs7 CURSOR FOR i001_sel_cs7
     OPEN i001_cur_cs7
     FETCH i001_cur_cs7 INTO l_aag02,l_aag03,l_aag07,l_aagacti

     CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-214'
          WHEN l_aagacti = 'N'     LET g_errno = '9028'
          WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
          OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
     END CASE
    END IF
   #FUN-B60082---end---

    IF cl_null(g_errno) THEN
       LET g_ash[l_cnt].ash05 = l_aag02       
    END IF
END FUNCTION
#CHI-9C0038--add--end

FUNCTION i001_b_askkey()
DEFINE
    l_wc   LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(200)
 
   CLEAR FORM
   CALL g_ash.clear()
   CALL g_ash.clear()
 
   CONSTRUCT l_wc ON ash04,ash05,ash06,ash11,ash12  #螢幕上取條件
        FROM s_ash[1].ash04,s_ash[1].ash05,s_ash[1].ash06,s_ash[1].ash11,s_ash[1].ash12
 
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
      RETURN 
   END IF
 
   CALL i001_b_fill(l_wc)
   
END FUNCTION
 
FUNCTION i001_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc      LIKE type_file.chr1000 #No.FUN-680098  VARCHAR(200)
 
   LET g_sql = "SELECT ash04,ash05,ash06,'',ash11,ash12 ",  #FUN-580063
               " FROM ash_file ",
               " WHERE ash01 = '",g_ash01,"' AND ", p_wc CLIPPED ,
               "   AND ash00 = '",g_ash00,"'",
               "   AND ash13 = '",g_ash13,"'",   #FUN-910001 add  
               " ORDER BY ash04,ash05 "
   PREPARE i001_prepare2 FROM g_sql      #預備一下
   DECLARE ash_cs CURSOR FOR i001_prepare2
 
   CALL g_ash.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH ash_cs INTO g_ash[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      CALL i001_ash06(g_cnt)
      LET g_errno = ' '                #MOD-A60033 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_ash.deleteElement(g_cnt)
   LET g_rec_b=g_cnt -1
 
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ash TO s_ash.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first 
         CALL i001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL i001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL i001_fetch('L')
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
      ON ACTION output
         LET g_action_choice="output"
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
      ON ACTION batch_generate
         LET g_action_choice="batch_generate"
         EXIT DISPLAY
 
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
     ##FUN-B90061--beatk--
      ON ACTION dataload
         LET g_action_choice = 'dataload'
         EXIT DISPLAY
     ##FUN-B90061---end--- 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
   
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION i001_copy()
DEFINE l_ash          RECORD LIKE ash_file.*,
       l_sql          LIKE type_file.chr1000,     #No.FUN-680098 VARCHAR(100)
       l_oldno0       LIKE ash_file.ash00,        #No.FUN-730070
       l_newno0       LIKE ash_file.ash00,        #No.FUN-730070
       l_oldno1       LIKE ash_file.ash01,
       l_newno1       LIKE ash_file.ash01,
       l_oldno2       LIKE ash_file.ash13,        #FUN-910001 add                                                                   
       l_newno2       LIKE ash_file.ash13,        #FUN-910001 add                                                                   
       l_n,l_n1       LIKE type_file.num5         #FUN-910001 add
DEFINE l_ash01_cnt    LIKE type_file.num5         #FUN-920035 add 
   IF s_aglshut(0) THEN RETURN END IF
 
   IF cl_null(g_ash13) OR cl_null(g_ash01) OR cl_null(g_ash00) THEN  #No.FUN-730070  #FUN-910001 
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i001_set_entry('a') 
   LET g_before_input_done = TRUE
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
     INPUT l_newno2,l_newno1 FROM ash13,ash01  #No.FUN-730070  #FUN-910001   #FUN-920035 
      AFTER FIELD ash13   #族群代號                                                                                                 
         IF l_newno2 IS NULL THEN                                                                                                   
            NEXT FIELD ash13                                                                                                        
         END IF                                                                                                                     
 
      AFTER FIELD ash01
         IF l_newno1 IS NULL THEN 
            NEXT FIELD ash01
         END IF
         SELECT COUNT(*)                                                                                                            
           INTO l_ash01_cnt                                                                                                         
           FROM asg_file                                                                                                            
          WHERE asg01 = l_newno1                                                                                                    
         IF SQLCA.SQLCODE=100  THEN                                                                                                 
            LET g_errno = 'aco-025'   #TQC-910022                                                                                   
         END IF                                                                                                                     
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(l_newno1,g_errno,0)
            NEXT FIELD ash01
         ELSE                                                                                                                       
            SELECT asg05 INTO l_newno0                                                                                              
              FROM asg_file                                                                                                         
             WHERE asg01 = l_newno1                                                                                                 
            DISPLAY l_newno0 TO ash00                                                                                               
         END IF
         IF l_newno2 IS NOT NULL AND l_newno1 IS NOT NULL AND                                                                       
            l_newno0 IS NOT NULL THEN                                                                                               
            LET l_n = 0   LET l_n1 = 0                                                                                              
            SELECT COUNT(*) INTO l_n FROM asa_file                                                                                  
             WHERE asa01=l_newno2 AND asa02=l_newno1                                                                                
               AND asa03=l_newno0                                                                                                   
            SELECT COUNT(*) INTO l_n1 FROM asb_file                                                                                 
             WHERE asb01=l_newno2 AND asb04=l_newno1                                                                                
               AND asb05=l_newno0                                                                                                   
            IF l_n+l_n1 = 0 THEN                                                                                                    
               CALL cl_err(l_newno1,'agl-223',0)                                                                                    
               NEXT FIELD ash01                                                                                                     
            END IF                                                                                                                  
         END IF                                                                                                                     
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ash13) #族群編號                                                                                           
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_asa1"                                                                                        
               LET g_qryparam.default1 = l_newno2                                                                                   
               CALL cl_create_qry() RETURNING l_newno2                                                                              
               DISPLAY l_newno2 TO ash13                                                                                            
               NEXT FIELD ash13                                                                                                     
            WHEN INFIELD(ash01)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asg" 
               LET g_qryparam.default1 = l_newno1
               CALL cl_create_qry() RETURNING l_newno1
               DISPLAY l_newno1 TO ash01 
               NEXT FIELD ash01
            WHEN INFIELD(ash00)  
               SELECT azp03 INTO g_azp03 FROM asg_file,azp_file
                WHERE asg01=l_newno1 AND asg03=azp01
               SELECT azp01 INTO g_azp01 FROM asg_file,azp_file       #No.TQC-9B0069  
                WHERE asg01=l_newno1 AND asg03=azp01                  #No.TQC-9B0069
               IF cl_null(g_azp03) THEN LET g_azp03 = g_dbs END IF
               IF cl_null(g_azp01) THEN LET g_azp01 = g_plant END IF  #No.TQC-9B0069
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa4"   #TQC-760205 q_aaa->q_aaa4
               LET g_qryparam.default1 = l_newno0
               LET g_qryparam.plant = g_azp01                         #No.TQC-9B0069
               CALL cl_create_qry() RETURNING l_newno0
               DISPLAY l_newno0 TO ash00 
               NEXT FIELD ash00
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_ash01 TO ash01 
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM ash_file         #單身複製
    WHERE ash01=g_ash01 
      AND ash00=g_ash00  #No.FUN-730070
      AND ash13=g_ash13  #FUN-910001 add
     INTO TEMP x
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ash_file",g_ash01,g_ash00,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730070
      RETURN
   END IF
 
   UPDATE x SET ash01=l_newno1,ash00=l_newno0,ash13=l_newno2  #No.FUN-730070  #FUN-910001 add ash13
 
   INSERT INTO ash_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ash_file",l_newno1,l_newno0,SQLCA.sqlcode,"","ash:",1)  #No.FUN-660123  #No.FUN-730070
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
 
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
   
   LET l_oldno2 = g_ash13   #FUN-910001 add    
   LET l_oldno1 = g_ash01 
   LET l_oldno0 = g_ash00   #No.FUN-730070
   LET g_ash13=l_newno2     #FUN-910001 add
   LET g_ash01=l_newno1
   LET g_ash00=l_newno0     #No.FUN-730070
 
   CALL i001_b()
   #FUN-C80046---begin
   #LET g_ash13=l_oldno2     #FUN-910001 add 
   #LET g_ash01=l_oldno1
   #LET g_ash00=l_oldno0     #No.FUN-730070
   #
   #CALL i001_show()
   #FUN-C80046---end
END FUNCTION
 
FUNCTION i001_out()
   DEFINE l_i             LIKE type_file.num5,          #No.FUN-680098  smallint
          l_name          LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-680098 VARCHAR(20)
          l_chr           LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)  
          sr RECORD
               ash13     LIKE ash_file.ash13,     #族群代號  #FUN-910001 add  
               ash01     LIKE ash_file.ash01,     #營運中心
               ash00     LIKE ash_file.ash00,     #帳套  #No.FUN-730070
               ash04     LIKE ash_file.ash04,     #科目編號
               ash05     LIKE ash_file.ash05,     #科目名稱
               ash06     LIKE ash_file.ash06,     #合併財報科目編號
               aag02     LIKE aag_file.aag02,     #合併財報科目名稱
               ash11     LIKE ash_file.ash11,     #再衡量匯率類別
               ash12     LIKE ash_file.ash12      #換算匯率類別
             END RECORD
 
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   LET g_sql="SELECT ash13,ash01,ash00,ash04,ash05,ash06,aag02,ash11,ash12 ", # 組合出 SQL 指令  #No.FUN-730070  #FUN-910001 add ash13
             " FROM ash_file, aag_file ",
             " WHERE ",g_wc CLIPPED ,
             "   AND ash06 = aag_file.aag01",  
             "   AND aag00 = '",g_aaz.aaz641,"'",    #FUN-910001
             " ORDER BY ash13,ash01,ash00,ash04 "    #No.FUN-730070  #FUN-910001 add ash13
   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(g_wc,'ash13,ash01,ash00,ash04,ash05,ash06,ash11,ash12')  #FUN-910001 mod
      RETURNING g_wc                                                          
      LET g_str = g_str CLIPPED,";", g_wc                                     
   END IF                                                                      
   LET g_str =  g_wc    
   CALL cl_prt_cs1('ggli001','ggli001',g_sql,g_str)
END FUNCTION
 
FUNCTION i001_g()
   DEFINE l_sql    LIKE type_file.chr1000,   #No.FUN-680098 VARCHAR(200)
          l_ash06  LIKE ash_file.ash06,
          l_aag01  LIKE aag_file.aag01,
          l_type   STRING,                   #FUN-960062
          l_aag02  LIKE aag_file.aag02,
          l_flag   LIKE type_file.chr1,      #TQC-590045        #No.FUN-680098 VARCHAR(1)
          l_asg03  LIKE asg_file.asg03,      #TQC-660043
          l_asg04  LIKE asg_file.asg04,      #FUN-760053 add
          l_n      LIKE type_file.num5,      #FUN-740173 add
          l_n1     LIKE type_file.num5       #FUN-910001 add
DEFINE l_asb02      LIKE asb_file.asb02      #FUN-950051  
DEFINE l_asa09      LIKE asa_file.asa09      #FUN-950051 
DEFINE l_ash11     LIKE ash_file.ash11       #FUN-950049
DEFINE l_ash12     LIKE ash_file.ash12       #FUN-950049 
DEFINE l_aag04     LIKE aag_file.aag04       #FUN-940049
DEFINE l_qbe_aag01  LIKE aag_file.aag01      #FUN-960062
DEFINE l_ash        DYNAMIC ARRAY OF RECORD  
       ash04        LIKE ash_file.ash04,                 
       ash05        LIKE ash_file.ash05,                 
       ash06        LIKE ash_file.ash06,                  
       aag02        LIKE aag_file.aag02,
       ash11        LIKE ash_file.ash11, 
       ash12        LIKE ash_file.ash12 
                    END RECORD
DEFINE l_asb02_asg04  LIKE asg_file.asg04
DEFINE l_aaz107     LIKE aaz_file.aaz107   #No.FUN-D40130   Add
DEFINE l_cnt1       LIKE type_file.num5    #No.FUN-D40130   add
DEFINE l_str1       STRING                 #No.FUN-D40130   add
 
   OPEN WINDOW i001_w3 AT 6,11
     WITH FORM "ggl/42f/ggli001_g"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("ggli001_g")
 
   CALL cl_getmsg('agl-021',g_lang) RETURNING g_msg
   MESSAGE g_msg 
 
   LET g_success='Y'   #TQC-590045
 
   WHILE TRUE   #TQC-590045
      CONSTRUCT g_wc ON aag01 FROM aag01
 
         AFTER FIELD aag01
            CALL GET_FLDBUF(aag01) RETURNING l_qbe_aag01
 
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
         CLOSE WINDOW i001_w3 
         RETURN 
      END IF
    
      LET tm.y='Y'
      DISPLAY tm.y TO FORMONLY.y 
    
      INPUT tm.ash13,tm.ash01,tm.y WITHOUT DEFAULTS   #No.FUN-730070        #FUN-910001 add ash13                                   
       FROM FORMONLY.ash13,FORMONLY.ash01,FORMONLY.y  #No.FUN-730070  #FUN-910001 add ash13   
 
         AFTER FIELD ash01
            IF NOT cl_null(tm.ash01) THEN 
               CALL i001_ash01('a',tm.ash01)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.ash01,g_errno,0)
                  NEXT FIELD ash01
               ELSE                                                                                                                 
                  SELECT asg05 INTO g_ash00_def                                                                                     
                    FROM asg_file                                                                                                   
                   WHERE asg01 = tm.ash01                                                                                           
               END IF                                                                                                               
            END IF
 
         AFTER FIELD y
            IF NOT cl_null(tm.y) THEN 
               IF tm.y NOT MATCHES '[YN]' THEN
                  NEXT FIELD y
               END IF 
            END IF
    
         ON ACTION CONTROLZ
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG
            CALL cl_cmdask()
    
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ash13) #族群編號                                                                                        
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form ="q_asa1"                                                                                     
                  LET g_qryparam.default1 = tm.ash13                                                                                
                  CALL cl_create_qry() RETURNING tm.ash13                                                                           
                  DISPLAY tm.ash13 TO ash13                                                                                         
                  NEXT FIELD ash13                                                                                                  
               WHEN INFIELD(ash01)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_asg"      #FUN-580063
                  LET g_qryparam.default1 = tm.ash01
                  CALL cl_create_qry() RETURNING tm.ash01
                  DISPLAY tm.ash01 TO ash01 
                  NEXT FIELD ash01
               WHEN INFIELD(ash00)  
                  SELECT azp03 INTO g_azp03 FROM asg_file,azp_file
                   WHERE asg01=tm.ash01 AND asg03=azp01
                  SELECT azp01 INTO g_azp01 FROM asg_file,azp_file       #No.TQC-9B0069
                   WHERE asg01=tm.ash01 AND asg03=azp01                  #No.TQC-9B0069
                  IF cl_null(g_azp03) THEN LET g_azp03 = g_dbs END IF
                  IF cl_null(g_azp01) THEN LET g_azp01 = g_plant END IF  #No.TQC-9B0069	
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa4"   #TQC-760205 q_aaa->q_aaa4
                  LET g_qryparam.default1 = tm.ash00
                  LET g_qryparam.plant = g_azp01                         #No.TQC-9B0069
                  CALL cl_create_qry() RETURNING tm.ash00
                  DISPLAY tm.ash00 TO ash00 
                  NEXT FIELD ash00
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
    
      IF INT_FLAG THEN 
         LET INT_FLAG=0
         CLOSE WINDOW i001_w3
         RETURN
      END IF
    
      IF cl_sure(0,0) THEN 
         BEGIN WORK     #No.TQC-740199
         CALL i001_getdbs(tm.ash01,tm.ash13)   #FUN-960062

         CALL s_aaz641_asg(tm.ash13,tm.ash01) RETURNING g_plant_asg03  #FUN-D40130
         CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_aaz641       #FUN-D40130
 
         IF g_asg04 = 'Y' THEN    #FUN-960062 add
            #FUN-A50102--mod--str--
            #LET l_sql ="SELECT aag01,aag02,aag04 FROM ",g_dbs_gl,"aag_file ",  #FUN-950049
             LET l_sql ="SELECT aag01,aag02,aag04 ",
                        "  FROM ",cl_get_target_table(g_plant_gl,'aag_file'),
            #FUN-A50102--mod--end
                        " WHERE aag07 IN ('2','3') ",
                        "  AND ",g_wc CLIPPED,
                        "  AND aag00 = '",g_ash00_def,"'",  #No.FUN-730070  #FUN-950051
                        "  AND aag09 = 'Y'",                #No.FUN-B60082
                        " ORDER BY aag01 "
         ELSE
            #FUN-A50102--mod--str--
            #LET l_sql ="SELECT UNIQUE asi05,asi051,'' FROM ",g_dbs_gl," asi_file ",  
             LET l_sql ="SELECT UNIQUE asi05,asi051,'' ",
                        "  FROM ",cl_get_target_table(g_plant_gl,'asi_file'),   #FUN-A50102
            #FUN-A50102--mod--end
                        "  WHERE asi04 = '",tm.ash01,"'",   #下層公司
                        "   AND asi01 = '",tm.ash13,"'",   #群組
                        "   AND asi041 = '",g_ash00_def,"'"   #下層公司帳別
                        #," ORDER BY aag01 "   #MOD-B30175
         END IF
	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-750088
         CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql  #FUN-A50102
         PREPARE i001_g_pre  FROM l_sql
         DECLARE i001_g CURSOR FOR i001_g_pre 
         LET i = 1    #FUN-960062
         FOREACH i001_g INTO l_aag01,l_aag02,l_aag04   #FUN-950049
            IF SQLCA.sqlcode THEN 
               CALL cl_err('i001_g',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
            LET l_ash06 = NULL 
         
          #No.FUN-D40130 ---Mark--- start
           #IF tm.y = 'Y' THEN
           #  #--TQC-B90008 start---
           #  IF g_asg04 = 'N' THEN    
           #     LET l_ash06 = l_aag01 
           #  END IF
           #  #--TQC-B90008 end---
           #ELSE 
           #   LET l_ash06 = ' '
           #END IF
           #No.FUN-D40130 ---Mark--- end   
 
          #No.FUN-D40130 ---Add--- start
            IF tm.y = 'Y' THEN
               LET l_ash06 = l_aag01 
            ELSE 
               LET l_sql = "SELECT aaz107 FROM ",cl_get_target_table(g_plant_asg03,'aaz_file')," WHERE aaz00 = '0'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,g_plant_asg03) RETURNING l_sql
               PREPARE aag_sel_aaz_prep FROM l_sql
               EXECUTE aag_sel_aaz_prep INTO l_aaz107
               IF cl_null(l_aaz107) THEN LET l_aaz107 = '4' END IF
               LET l_str1 = l_aag01
               LET l_ash06= l_str1.subString(1,l_aaz107)
               LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_asg03,'aag_file'),
                           " WHERE aag01 = '",l_ash06,"' AND aag00 = '",g_aaz641,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,g_plant_asg03) RETURNING l_sql
               PREPARE aag_sel_aag_prep FROM l_sql
               EXECUTE aag_sel_aag_prep INTO l_cnt1
               IF l_cnt1 < 1 THEN
                  LET l_ash06 = ""
               END IF
            END IF
           #No.FUN-D40130 ---Add--- end           

           #MOD-A20118---modify---start---
           #LET l_type = l_aag01
           #IF l_type.substring(1,1) MATCHES '[1]' THEN  #FUN-960062   
            LET l_aag04 = ''
            LET l_sql = " SELECT aag04 FROM ",cl_get_target_table(g_plant_gl,'aag_file'),
                        "  WHERE aag00 = '",g_ash00,"'",
                       #"    AND aag01 = '",g_ash[l_ac].ash04,"'"       #MOD-A50019 mark 
                        "    AND aag01 = '",l_aag01,"'"                 #MOD-A50019 add 
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
            CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql  
            PREPARE aag_sel_c1 FROM l_sql
            EXECUTE aag_sel_c1 INTO l_aag04
            IF cl_null(l_aag04) OR l_aag04 = '1' THEN   
           #MOD-A20118---modify---end---
               LET l_ash11 = '1'
               LET l_ash12 = '1'
            ELSE
               LET l_ash11 = '3'
               LET l_ash12 = '3'
            END IF
 
            LET l_ash[i].ash04 = l_aag01
            LET l_ash[i].ash05 = l_aag02

           #No.FUN-D40130 ---Mark--- start
           #IF tm.y = 'Y' THEN 
           #    LET l_ash[i].ash06 = l_ash06
           #ELSE
           #    LET l_ash[i].ash06 = ' '
           #END IF
           #No.FUN-D40130 ---Mark--- start
            LET l_ash[i].ash06 = l_ash06    #No.FUN-D40130   Add
                
            LET l_ash[i].aag02 = ''
            LET l_ash[i].ash11 = l_ash11
            LET l_ash[i].ash12 = l_ash12
            LET i = i + 1 
         END FOREACH
 
         FOR i = 1 TO l_ash.getLength()
           INSERT INTO ash_file (ash00,ash01,ash04,ash05,ash06,ash11,ash12, 
                                 ashacti,ashuser,ashgrup,ashmodu,ashdate,ash13,ashoriu,ashorig)
                         VALUES (g_ash00_def,tm.ash01,l_ash[i].ash04,
                                 l_ash[i].ash05,l_ash[i].ash06,
                                 l_ash[i].ash11,l_ash[i].ash12,
                                  'Y',g_user,g_grup,' ',g_today,tm.ash13, g_user, g_grup)        #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
               CONTINUE FOR     #FUN-960062
            ELSE
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","ash_file",tm.ash01,l_aag01,STATUS,"","ins ash",1)  #No.FUN-660123
                  LET g_success='N'   #TQC-590045
                  EXIT FOR    #FUN-960062
               END IF
            END IF   #MOD-780106 add
         END FOR     #FUN-960062
      END IF
    
      IF g_success='Y' THEN
         COMMIT WORK     #No.TQC-740199
         CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
      ELSE
         ROLLBACK WORK   #No.TQC-740199
         CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
      END IF
      IF l_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
   END WHILE
 
   CLOSE WINDOW i001_w3
 
END FUNCTION
 
FUNCTION i001_getdbs(p_ash01,p_ash13)
DEFINE  p_ash01  LIKE ash_file.ash01
DEFINE  p_ash13  LIKE ash_file.ash13
DEFINE  l_cnt    LIKE type_file.num5
DEFINE  l_asa02  LIKE asa_file.asa02
DEFINE  l_asa02_cnt  LIKE type_file.num5
 
   SELECT asg03,asg04,asg05 INTO g_asg03,g_asg04,g_asg05 FROM asg_file 
     WHERE asg01 = p_ash01
   #下層公司使用tiptop否(asg04)=N,表示為非TIPTOP公司,
   #預設目前所在DB給他(g_dbs_gl)
   IF g_asg04 = 'N' THEN LET g_asg03=g_plant    
       SELECT azp03 INTO g_dbs_new FROM azp_file
        WHERE azp01 = g_asg03
       IF STATUS THEN
          LET g_dbs_new = NULL
       END IF
       LET g_plant_gl = g_asg03    #No.FUN-980025 add
       LET g_dbs_gl = s_dbstring(g_dbs_new CLIPPED) 
   ELSE
       SELECT azp03 INTO g_dbs_new FROM azp_file
        WHERE azp01 = g_asg03
       IF STATUS THEN
          LET g_dbs_new = NULL
       END IF
       LET g_plant_gl = g_asg03    #No.FUN-980025 add
       LET g_dbs_gl = s_dbstring(g_dbs_new CLIPPED) 
   END IF
 
   #g_dbs_asg03上層公司抓取aag_file產生至合併科目時，來源DB
   #判斷是否合併會科獨立(asa09)
   #IF asa09 = 'Y' 則取p_ash01的上層公司，代表合併帳別建立於上層公司
   #IF asa09 = 'N' 則取目前所在DB，代表合併帳別建立於最上層公司
   
#FUN-A30122 -----------------------mark start--------------------------------------
#   #判斷目前p_ash01是否為上層公司才能取出asa09的值
#   SELECT COUNT(*) INTO l_asa02_cnt   #判斷自己本身是否為上層公司
#     FROM asa_file
#    WHERE asa01 = p_ash13
#      AND asa02 = p_ash01
# 
#   IF l_asa02_cnt > 0 THEN     
#       #抓出asa09值判斷Y/N 
#       SELECT asa09 INTO g_asa09 FROM asa_file     
#         WHERE asa01 = p_ash13  
#          AND asa02 = p_ash01         #上層公司編號 
#       IF g_asa09 = 'N' THEN          #合併會科不獨立
#           SELECT azp03 INTO g_dbs_new FROM azp_file
#            WHERE azp01 = g_plant
#           LET g_plant_asg03 = g_plant   #No.FUN-980025 
#           LET g_dbs_asg03 = s_dbstring(g_dbs_new CLIPPED) 
#       ELSE
#           SELECT asb02 INTO l_asa02  #上層公司
#             FROM asb_file
#            WHERE asb01 = p_ash13
#              AND asb02 = p_ash01  #MOD-9C0382 mod asb04->asb02
#           SELECT asg03               #上層公司資料庫
#             INTO g_asg03 
#             FROM asg_file 
#             WHERE asg01 = l_asa02  
#           SELECT azp03 INTO g_dbs_new FROM azp_file
#            WHERE azp01 = g_asg03
#           IF STATUS THEN
#              LET g_dbs_new = NULL
#           END IF
#           LET g_plant_asg03 = g_asg03  #No.FUN-980025 
#           LET g_dbs_asg03 = s_dbstring(g_dbs_new CLIPPED) 
#       END IF
#   ELSE       #p_ash01是最下層公司
#       SELECT asb02 INTO l_asa02  #上層公司
#         FROM asb_file
#        WHERE asb01 = p_ash13
#          AND asb04 = p_ash01
#       SELECT asa09 INTO g_asa09 FROM asa_file     
#        WHERE asa01 = p_ash13  
#          AND asa02 = l_asa02         #上層公司編號 
#       IF cl_null(g_asa09) OR g_asa09  = 'N' THEN          #合併會科不獨立
#           SELECT azp03 INTO g_dbs_new FROM azp_file
#            WHERE azp01 = g_plant
#           LET g_plant_asg03 = g_plant   #No.FUN-980025 
#           LET g_dbs_asg03 = s_dbstring(g_dbs_new CLIPPED) 
#      ELSE
#          SELECT asg03               #上層公司資料庫
#            INTO g_asg03 
#            FROM asg_file 
#            WHERE asg01 = l_asa02  
#          SELECT azp03 INTO g_dbs_new FROM azp_file
#           WHERE azp01 = g_asg03
#          IF STATUS THEN
#             LET g_dbs_new = NULL
#          END IF
#          LET g_plant_asg03 = g_asg03  #No.FUN-980025 
#          LET g_dbs_asg03 = s_dbstring(g_dbs_new CLIPPED) 
#      END IF
#  END IF
#
# #LET g_sql = "SELECT aaz641 FROM ",g_dbs_asg03,"aaz_file",  #FUN-A50102
#  LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_asg03,'aaz_file'),  #FUN-A50102 
#              " WHERE aaz00 = '0'"
#  CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
#  CALL cl_parse_qry_sql(g_sql,g_plant_asg03) RETURNING g_sql  #FUN-A50102
#  PREPARE i001_pre_11 FROM g_sql
#  DECLARE i001_cur_11 CURSOR FOR i001_pre_11
#  OPEN i001_cur_11
#  FETCH i001_cur_11 INTO g_aaz641
#  IF cl_null(g_aaz641) THEN
#      CALL cl_err(g_asg03,'agl-601',1)
#  END IF
#FUN-A30122 --------------------------------------------mark end---------------------------------------
END FUNCTION
#No.FUN-9C0072 精簡程式碼
#FUN-B90061--beatk--
FUNCTION i001_dataload()    #資料匯入

   OPEN WINDOW i001_l_w AT p_row,p_col
     WITH FORM "ggl/42f/ggli001_l" ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("ggli001_l")

   CLEAR FORM
   ERROR ''
   LET g_disk = "Y" 
   LET g_choice = '1'
    
   INPUT g_file WITHOUT DEFAULTS FROM FORMONLY.file
        
      ON ACTION locale
         LET g_action_choice = "locale"
         CALL cl_show_fld_cont()
         EXIT INPUT
   
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()     # Command execution
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about 
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i001_l_w
      RETURN
   END IF
  
   WHILE TRUE
   IF cl_sure(0,0) THEN
      LET g_success='Y'
      BEGIN WORK 
    
      CALL i001_excel_bring(g_file)      

      DROP TABLE i001_tmp
      CALL s_showmsg() 
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF

      CLOSE WINDOW i001_l_w
   END IF
   EXIT WHILE  
   END WHILE  
   CLOSE WINDOW i001_l_w    
END FUNCTION

FUNCTION i001_ins_ash()
   SELECT * FROM ash_file
    WHERE ash00=g_ashl.ash00 AND ash01=g_ashl.ash01 AND ash04=g_ashl.ash04
      AND ash05=g_ashl.ash05 AND ash06=g_ashl.ash06 AND ash11=g_ashl.ash11
      AND ash12=g_ashl.ash12 AND ash13=g_ashl.ash13
   IF STATUS THEN
      LET g_ashl.ashacti='Y'
      LET g_ashl.ashuser=g_user
      LET g_ashl.ashgrup=g_grup
      LET g_ashl.ashdate=g_today

      INSERT INTO ash_file VALUES (g_ashl.*)
      IF STATUS THEN
         LET g_showmsg=g_ashl.ash00,"/",g_ashl.ash01,"/",g_ashl.ash04,"/",g_ashl.ash05,"/",
                       g_ashl.ash06,"/",g_ashl.ash11,"/",g_ashl.ash12,"/",g_ashl.ash13
         CALL s_errmsg('ash00,ash01,ash04,ash05,ash06,ash11,ash12,ash13'
                       ,g_showmsg,'ins ash_file',STATUS,1)
      END IF
   END IF
END FUNCTION

FUNCTION i001_excel_bring(p_fname)
   DEFINE p_fname     STRING  
   DEFINE channel_r   base.Channel
   DEFINE l_string    LIKE type_file.chr1000
   DEFINE unix_path   LIKE type_file.chr1000
   DEFINE window_path LIKE type_file.chr1000
   DEFINE l_cmd       LIKE type_file.chr1000 
   DEFINE li_result   LIKE type_file.chr1 
   DEFINE l_column    DYNAMIC ARRAY of RECORD 
            col1      LIKE gaq_file.gaq01,
            col2      LIKE gaq_file.gaq03
                      END RECORD
   DEFINE l_cnt3      LIKE type_file.num5
   DEFINE li_i        LIKE type_file.num5
   DEFINE li_n        LIKE type_file.num5
   DEFINE ls_cell     STRING
   DEFINE ls_cell_r   STRING
   DEFINE li_i_r      LIKE type_file.num5
   DEFINE ls_cell_c   STRING
   DEFINE ls_value    STRING
   DEFINE ls_value_o  STRING
   DEFINE li_flag     LIKE type_file.chr1 
   DEFINE lr_data_tmp   DYNAMIC ARRAY OF RECORD
             data01     STRING
                    END RECORD
   DEFINE l_fname     STRING   
   DEFINE l_column_name LIKE zta_file.zta01
   DEFINE l_data_type LIKE ztb_file.ztb04
   DEFINE l_nullable  LIKE ztb_file.ztb05
   DEFINE l_flag_1    LIKE type_file.chr1  
   DEFINE l_date      LIKE type_file.dat
   DEFINE li_k        LIKE type_file.num5
   DEFINE l_err_cnt   LIKE type_file.num5
   DEFINE l_no_b      LIKE pmw_file.pmw01   
   DEFINE l_no_e      LIKE pmw_file.pmw01
   DEFINE l_old_no    LIKE type_file.chr50  
   DEFINE l_old_no_b  LIKE type_file.chr50  
   DEFINE l_old_no_e  LIKE type_file.chr50
   DEFINE lr_err      DYNAMIC ARRAY OF RECORD
               line        STRING,
               key1        STRING,
               err         STRING
                      END RECORD
   DEFINE  m_tempdir  LIKE type_file.chr1000,    
           ss1        LIKE type_file.chr1000,
           m_sf       LIKE type_file.chr1000,
           m_file     LIKE type_file.chr1000,
           l_j        LIKE type_file.num5,
           l_n        LIKE type_file.num5
   DEFINE  g_target   LIKE type_file.chr1000
   DEFINE  tok        base.StringTokenizer
   DEFINE  ss         STRING 
   DEFINE  l_str      DYNAMIC ARRAY OF STRING  
   DEFINE  ms_codeset String  
   DEFINE  l_txt1     LIKE type_file.chr1000
   DEFINE  l_asg04    LIKE asg_file.asg04
   DEFINE  l_sql      LIKE type_file.chr1000
   DEFINE
           l_cnt      LIKE type_file.num5,
           l_aag02    LIKE aag_file.aag02,
           l_aag03    LIKE aag_file.aag03,
           l_aag07    LIKE aag_file.aag07,
           l_aag09    LIKE aag_file.aag09,
           l_aagacti  LIKE aag_file.aagacti

   LET m_tempdir = FGL_GETENV("TEMPDIR")
   LET l_n = LENGTH(m_tempdir)
   
   LET ms_codeset = cl_get_codeset()
   
   IF l_n>0 THEN
      IF m_tempdir[l_n,l_n]='/' THEN
         LET m_tempdir[l_n,l_n]=' '
      END IF
   END IF

   IF m_tempdir is null THEN
      LET m_file=p_fname
   ELSE
      LET m_file=m_tempdir CLIPPED,'/',p_fname,".txt"
   END IF

   IF g_disk= "Y" THEN
      LET m_sf = "c:/tiptop/"
      LET m_sf = m_sf CLIPPED,p_fname CLIPPED,".txt"
      IF NOT cl_upload_file(m_sf, m_file) THEN
         CALL cl_err(NULL, "lib-212", 1)
      END IF
   END IF

   LET ss1="test -s ",m_file CLIPPED
   RUN ss RETURNING l_n

   IF l_n THEN
      IF m_tempdir IS NULL THEN
         LET m_tempdir='.'
      END IF

      DISPLAY "* NOTICE * No such excel file '",m_file CLIPPED,"'"
      DISPLAY "PLEASE make sure that the excel file download from LEADER"
      DISPLAY "has been put in the directory:"
      DISPLAY '--> ',m_tempdir
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
    
   LET channel_r = base.Channel.create()                                                                                         
   LET g_target  = FGL_GETENV("TEMPDIR"),"\/", p_fname,"_",g_dbs CLIPPED,".TXT"  
   
         
   IF m_sf IS NOT NULL THEN 
      IF NOT cl_upload_file(m_sf,g_target) THEN
         CALL cl_err("Can't upload file: ", m_sf, 0)
         RETURN 
      END IF
   END IF  
   
   LET l_txt1 = FGL_GETENV("TEMPDIR"),"\/",p_fname,"_",g_dbs CLIPPED,".txt"
   
   CASE ms_codeset
      WHEN "UTF-8"
         LET l_cmd = "cp ",g_target," ",l_txt1
         RUN l_cmd
         LET l_cmd = "ule2utf8 ",l_txt1
         RUN l_cmd
         #CHI-B50010 -- end --
         LET l_cmd = "cp -f " || l_txt1 CLIPPED || " " || g_target CLIPPED  
         RUN l_cmd 
         LET l_cmd = " killcr " ||g_target CLIPPED     
         RUN l_cmd   
      WHEN "BIG5"
         LET l_cmd = "iconv -f UNICODE -t BIG-5 " || g_target CLIPPED || " > " || l_txt1 CLIPPED  #MOD-AB0097
         RUN l_cmd
         LET l_cmd = "cp -f " || l_txt1 CLIPPED || " " || g_target CLIPPED  
         RUN l_cmd 
         LET l_cmd = " killcr " ||g_target CLIPPED     
         RUN l_cmd   
      WHEN "GB2312"
         LET l_cmd = "iconv -f UNICODE -t GB2312 " || g_target CLIPPED || " > " || l_txt1 CLIPPED  #MOD-AB0097
         RUN l_cmd
         LET l_cmd = "cp -f " || l_txt1 CLIPPED || " " || g_target CLIPPED  
         RUN l_cmd 
         LET l_cmd = " killcr " ||g_target CLIPPED     
         RUN l_cmd 
   END CASE
     
   LET g_success='Y' 
   CALL channel_r.openFile(g_target,  "r") 
   IF STATUS THEN
      CALL cl_err("Can't open file: ", STATUS, 0)
      RETURN
   END IF
   CALL channel_r.setDelimiter("")
   CALL s_showmsg_init()
   WHILE channel_r.read(ss)
     LET tok = base.StringTokenizer.create(ss,ASCII 9)
     LET l_j=0
     CALL l_str.clear()
     WHILE tok.hasMoreTokens()
       LET l_j=l_j+1
       LET l_str[l_j]=tok.nextToken()
     END WHILE
     LET g_ashl.ash01  = null 
     LET g_ashl.ash04  = null 
     LET g_ashl.ash06  = null
     LET g_ashl.ash11  = null
     LET g_ashl.ash12  = null
     LET g_ashl.ash13  = null
     LET g_ashl.ash01  = l_str[1] CLIPPED
     LET g_ashl.ash04  = l_str[2] CLIPPED
     LET g_ashl.ash06  = l_str[3] CLIPPED
     LET g_ashl.ash11  = l_str[4] CLIPPED
     LET g_ashl.ash12  = l_str[5] CLIPPED
     LET g_ashl.ash13  = l_str[6] CLIPPED
     IF cl_null(g_ashl.ash01) OR
        cl_null(g_ashl.ash04) OR cl_null(g_ashl.ash13) THEN
        CONTINUE WHILE
     END IF
    #依ash01去撈ash00帳別
     SELECT asg05 INTO g_ashl.ash00
       FROM asg_file
      WHERE asg01 = g_ashl.ash01
     IF cl_null(g_ashl.ash00) THEN
        CALL s_errmsg('ash00',g_showmsg,'','agl-095',1)
        CONTINUE WHILE
     END IF
     CALL i001_getdbs(g_ashl.ash01,g_ashl.ash13)
     IF NOT cl_null(g_ashl.ash04) THEN
        SELECT asg04 INTO l_asg04 FROM asg_file
         WHERE asg01 = g_ashl.ash01
         IF l_asg04 = 'N' THEN   #非TIPTOP公司
            LET l_sql = "SELECT asi051",
                        "  FROM ",cl_get_target_table(g_plant_gl,'asi_file'),
                        " WHERE asi04 = '",g_ash01,"'",
                        "   AND asi01 = '",g_ashl.ash01,"'",
                        "   AND asi041 = '",g_ashl.ash00,"'",
                        "   AND asi05 = '",g_ashl.ash04,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            PREPARE ash04_sel1 FROM l_sql 
            EXECUTE ash04_sel1 INTO g_ashl.ash05
            IF cl_null(g_ashl.ash05) THEN
               LET g_showmsg = g_ashl.ash00,'/',g_ashl.ash04
               CALL s_errmsg('ash00,ash04',g_showmsg,'','agl1007',1)
               CONTINUE WHILE
            END IF
         ELSE
            LET g_errno = null
            LET l_aag02 = null
            LET l_aag03 = null
            LET l_aag07 = null
            LET l_aagacti = null
            LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                        "  FROM ",cl_get_target_table(g_plant_gl,'aag_file'),
                        " WHERE aag01 = '",g_ashl.ash04,"'",
                        "   AND aag00 = '",g_ashl.ash00,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            PREPARE ash04_sel2 FROM g_sql
            DECLARE ash04_cur2 CURSOR FOR ash04_sel2
            OPEN ash04_cur2
            FETCH ash04_cur2 INTO l_aag02,l_aag03,l_aag07,l_aagacti
            LET g_ashl.ash05 = l_aag02
            CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
                 WHEN l_aagacti = 'N'     LET g_errno = '9028'
                 WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                 OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               LET g_showmsg = g_ashl.ash00,'/',g_ashl.ash04
               CALL s_errmsg('ash00,ash04',g_showmsg,'',g_errno,1)
               CONTINUE WHILE
            END IF
            CLOSE ash04_cur2
            IF SQLCA.sqlcode = 0 THEN
               LET g_errno = null
               LET l_aag02 = null
               LET l_aag03 = null
               LET l_aag07 = null
               LET l_aagacti = null
               LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                           "  FROM ",cl_get_target_table(g_plant_gl,'aag_file'),
                           " WHERE aag01 = '",g_ashl.ash04,"'",
                           "   AND aag00 = '",g_ashl.ash00,"'",
                           "   AND aag09 = 'Y'" 
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               PREPARE ash04_sel3 FROM g_sql
               DECLARE ash04_cur3 CURSOR FOR ash04_sel3
               OPEN ash04_cur3
               FETCH ash04_cur3 INTO l_aag02,l_aag03,l_aag07,l_aagacti
               LET g_ashl.ash05 = l_aag02
               CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-214'
                    WHEN l_aagacti = 'N'     LET g_errno = '9028'
                    WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                    OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
               END CASE
               IF NOT cl_null(g_errno) THEN
                  LET g_showmsg = g_ashl.ash00,'/',g_ashl.ash04
                  CALL s_errmsg('ash00,ash04',g_showmsg,'',g_errno,1)
                  CONTINUE WHILE
               END IF
               CLOSE ash04_cur3
            END IF
         END IF
     END IF
     IF NOT cl_null(g_ashl.ash06) THEN
        CALL s_aaz641_asg(g_ashl.ash13,g_ashl.ash01) RETURNING g_plant_asg03
       #CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_asz01     #FUN-BA0012
        CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_aaz641    #FUN-BA0012
        LET g_errno = null
        LET l_aag02 = null 
        LET l_aag03 = null 
        LET l_aag07 = null 
        LET l_aagacti = null 
        LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                    "  FROM ",cl_get_target_table(g_plant_asg03,'aag_file'),
                    " WHERE aag01 = '",g_ashl.ash06,"'",
                   #"  AND aag00 = '",g_asz01,"'"      #FUN-BA0012
                    "  AND aag00 = '",g_aaz641,"'"     #FUN-BA0012
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                                            
        PREPARE ash06_sel2 FROM g_sql 
        DECLARE ash06_cur2 CURSOR FOR ash06_sel2                                                                                       
        OPEN ash06_cur2                                                                                                                 
        FETCH ash06_cur2 INTO l_aag02,l_aag03,l_aag07,l_aagacti                                                                         

        CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001' 
             WHEN l_aagacti = 'N'     LET g_errno = '9028' 
             WHEN l_aag07  = '1'      LET g_errno = 'agl-015' 
             OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
        END CASE 
        IF NOT cl_null(g_errno) THEN
           LET g_showmsg = g_ashl.ash00,'/',g_ashl.ash06
           CALL s_errmsg('ash00,ash06',g_showmsg,'',g_errno,1)
           CONTINUE WHILE
        END IF

        IF SQLCA.sqlcode = 0 THEN
           LET g_errno = null
           LET l_aag02 = null
           LET l_aag03 = null
           LET l_aag07 = null
           LET l_aagacti = null
           LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",                                                                                 
                       "  FROM ",g_dbs_asg03,"aag_file",                                                                                    
                       " WHERE aag01 = '",g_ashl.ash06,"'",                                                                           
                      #"  AND aag00 = '",g_asz01,"'",    #FUN-BA0012
                       "  AND aag00 = '",g_aaz641,"'",   #FUN-BA0012
                       "  AND aag09 = 'Y'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql                    
           PREPARE ash06_sel3 FROM g_sql                                                                                                   
           DECLARE ash06_cur3 CURSOR FOR ash06_sel3
           OPEN ash06_cur3
           FETCH ash06_cur3 INTO l_aag02,l_aag03,l_aag07,l_aagacti                                                                         

           CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-214'
                WHEN l_aagacti = 'N'     LET g_errno = '9028'
                WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
           END CASE 
        END IF
        IF NOT cl_null(g_errno) THEN
           LET g_showmsg = g_ashl.ash00,'/',g_ashl.ash06
           CALL s_errmsg('ash00,ash06',g_showmsg,'',g_errno,1)
           CONTINUE WHILE
        END IF
     END IF
     CALL i001_ins_ash()
   END WHILE
   CALL channel_r.close()
   
   IF g_totsuccess="N" THEN 
      LET g_success="N" 
   END IF  
END FUNCTION
#FUN-B90061---end---
