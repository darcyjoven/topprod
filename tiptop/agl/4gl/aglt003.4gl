# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aglt003.4gl
# Descriptions...: 公司科目餘額暫存資料維護作業(非TIPTOP公司)
# Date & Author..: 05/08/15 By Sarah
# Modify.........: No.FUN-580063 05/08/26 By Sarah 程式架構改變
# Modify.........: No.FUN-580064 05/09/07 By Dido 幣別自動帶入;增加彙總
# Modify.........: No.FUN-5A0020 05/10/06 By Sarah 若單身關係人沒有輸入資料,也應給予預設值' '
#                                                  借、貸方金額預設為0
# Modify.........: No.MOD-5A0445 05/11/11 By Smapmin 單身科目改抓axe_file
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0061 23/10/16 By xumin g_no_ask 改為 mi_no_ask
# Modify.........: No.FUN-6A0073 06/10/25 By xumin l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.MOD-6B0164 06/12/04 By Smapmin 單身locking cursor加一個key值
# Modify.........: No.TQC-6C0211 06/12/31 By wujie   調整“接下頁/結束”位置
# Modify.........: No.FUN-710023 07/01/25 By yjkhero 錯誤訊息匯整 
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-730021 07/03/05 By Smapmin 刪除後筆數有誤
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/13 By dxfwo 會計科目加帳套
# Modify.........: No.FUN-740166 07/04/24 By Sarah 1.關係人代碼查詢視窗應也要提供'客戶資料'(增加q_occ92查詢)
#                                                  2.金額未依下層公司幣別金額小數取位
# Modify.........: No.FUN-740198 07/04/26 By Sarah 增加公司+帳別的合理性判斷,應存在agli009
# Modify.........: No.MOD-740139 07/04/26 By Sarah 1.輸入之公司應該是非TIPTOP公司 
#                                                  2.單身輸入時,進入第三筆但未輸入科目代號,欲回上一筆,但會show"aap-262科目有誤"
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760173 07/06/25 By Sarah 資料匯入功能,於輸入 "來源檔名" 按 Ctrol-f(線上求助) 無功能
# Modify.........: No.TQC-760205 07/06/29 By Sarah 資料匯入,增加檢核科目編號(axq05)是否存在agli001來源科目(axe04)(show_msg)
# Modify.........: No.MOD-780113 07/08/17 By Sarah 科目編號(axq05)開窗改為開q_axe
# Modify.........: No.MOD-780114 07/08/17 By Sarah 離開單身時判斷借貸方金額,若不平顯示agl-060訊息
# Modify.........: No.FUN-770069 07/08/29 By Sarah 1.INSERT INTO axq_file時,axq00,axq01,axq02,axq03要寫入' '值
#                                                  2.單身刪除的WHERE條件句,axq05,axq13的部份應該用g_aag_t.axq05,g_aag_t.axq13
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.FUN-830144 08/04/08 By lilingyu 改CR報表
# Modify.........: No.FUN-920111 09/05/11 By ve007 axq05開放輸入
# Modify.........: No.FUN-950055 09/05/25 BY ve007 增加excel匯入功能 
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-960408 09/08/18 By destiny 去掉bp里的modify
# Modify.........: NO.FUN-980075 09/08/19 By hongmei 修改匯入問題和程式無法繼續執行問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910001 09/05/20 By hongmei 1.關係人代號開窗時改用q_pmc13
#                                                    2.畫面開放輸入axq01(族群代號),串axe_file時須需增加axe13=axq01
#                                                    3.資料匯入多抓axq01
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: NO.FUN-960045 09/10/29 BY Yiting excel匯入問題
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No:MOD-A30068 10/03/11 By sabrina 改變錯誤訊息顯示方式 
# Modify.........: No:MOD-A40022 10/04/06 By sabrina 無法複製
# Modify.........: No:FUN-9B0017 10/01/26 By chenmoyan 1.將畫面增加四個字段(異動碼5-8碼)
#                                                 2.匯入功能增加處理此四欄
#                                                 3.axq_pk增加axq14,axq15,axq16,
# Modify.........: No:MOD-AB0097 10/11/10 By Dido iconv 語法調整 
# Modify.........: No:TQC-AB0296 10/11/29 By suncx “會計年度”輸入負數無控管
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:CHI-B50010 11/05/19 By JoHung 統一由shell撰寫iconv由UNICODE轉UTF-8語法
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B90011 11/09/05 By Polly 當axq04/axq05/axq06/axq07/axq12皆為null時，則就不新增
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No.TQC-BA0076 11/10/14 by belle 修改AXQ17,AXQ18,AXQ19,AXQ21,AXQ22為Not Null的欄位,造成寫入失敗的原因 
# Modify........." No:MOD-C20020 12/02/04 By Polly 取消axq17/18/19/20/21/22/24給0的動作，以免匯出系統資料呈現0
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-D20044 13/02/19 by apo 增加EXCEL匯入範本功能
# Modify.........: No.CHI-D30001 13/03/04 by apo EXCEL 匯入時如果金額為空值則預設給0
# Modify.........: NO.CHI-D20029 13/03/12 By apo 因應ayf_file的KEY值有部門欄位，故新增axq29欄位提供輸入
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

IMPORT os
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-BA0012
#FUN-BA0006 
DEFINE tm      RECORD
               wc      LIKE type_file.chr1000# Head Where condition   #No.FUN-680098  VARCHAR(500)
               END RECORD,
       g_axq   RECORD
               axq01 	LIKE axq_file.axq01,   #族群代號   #FUN-910001 add
               axq04 	LIKE axq_file.axq04,   #下層公司編號
               axq041	LIKE axq_file.axq041,  #下層帳別
               axq06	LIKE axq_file.axq06,   #年度
               axq07	LIKE axq_file.axq07,   #期別
               axq12	LIKE axq_file.axq12    #幣別
               END RECORD,
       g_axq_t RECORD                          #備分舊值
               axq01 	LIKE axq_file.axq01,   #族群代號   #FUN-910001 add
               axq04 	LIKE axq_file.axq04,   #下層公司編號
               axq041	LIKE axq_file.axq041,  #下層帳別
               axq06	LIKE axq_file.axq06,   #年度
               axq07	LIKE axq_file.axq07,   #期別
               axq12	LIKE axq_file.axq12    #幣別
               END RECORD,
       g_aag   DYNAMIC ARRAY OF RECORD
               axq29    LIKE axq_file.axq29,   #CHI-D20029 add
               axq05	LIKE axq_file.axq05,   #科目編號
               axq051	LIKE axq_file.axq051,   #科目名稱   #MOD-5A0445        #No.FUN-920111
               axq13	LIKE axq_file.axq13,   #關係人代號
               axq08    LIKE axq_file.axq08,   #借方金額
               axq09    LIKE axq_file.axq09    #貸方金額
              ,axq14    LIKE axq_file.axq14,   #異動碼5值#FUN-9B0017           
               axq15    LIKE axq_file.axq15,   #異動碼6值#FUN-9B0017           
               axq16    LIKE axq_file.axq16,   #異動碼7值#FUN-9B0017           
               axq17    LIKE axq_file.axq17    #異動碼8值#FUN-9B0017
               END RECORD,
       g_aag_t RECORD                          #備份舊值
               axq29    LIKE axq_file.axq29,   #CHI-D20029 add
               axq05	LIKE axq_file.axq05,   #科目編號
               axq051	LIKE axq_file.axq051,   #科目名稱   #MOD-5A0445        #No.FUN-920111
               axq13	LIKE axq_file.axq13,   #關係人代號
               axq08    LIKE axq_file.axq08,   #借方金額
               axq09    LIKE axq_file.axq09    #貸方金額
              ,axq14    LIKE axq_file.axq14,   #異動碼5值 #FUN-9B0017           
               axq15    LIKE axq_file.axq15,   #異動碼6值 #FUN-9B0017           
               axq16    LIKE axq_file.axq16,   #異動碼7值 #FUN-9B0017           
               axq17    LIKE axq_file.axq17    #異動碼8值 #FUN-9B0017
               END RECORD,
       g_bookno         LIKE axq_file.axq00,   #INPUT ARGUMENT - 1
       g_wc,g_wc2,g_sql STRING,                #WHERE CONDITION      
       p_row,p_col      LIKE type_file.num5,   #No.FUN-680098 smallint
       g_rec_b          LIKE type_file.num5,   #單身筆數   #No.FUN-680098 smallint
       l_ac             LIKE type_file.num5    #目前處理的ARRAY CNT    #No.FUN-680098 smalint
DEFINE g_forupd_sql     STRING     
DEFINE g_sql_tmp        STRING   #No.TQC-720019
DEFINE g_cnt            LIKE type_file.num10         #No.FUN-680098 integer
DEFINE g_i              LIKE type_file.num5          #count/index for any purpose        #No.FUN-680098 smallint
DEFINE g_msg            LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE g_row_count      LIKE type_file.num10         #No.FUN-680098 integer
DEFINE g_curs_index     LIKE type_file.num10         #No.FUN-680098 integer
DEFINE g_jump           LIKE type_file.num10         #No.FUN-680098 integer
DEFINE mi_no_ask         LIKE type_file.num5          #No.FUN-680098 smallint   #No.FUN-6A0061
DEFINE g_flag           LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
DEFINE g_sumaxq08       LIKE axq_file.axq08          #借方合計  #No.FUN-680098  dec(20,6)   
DEFINE g_sumaxq09       LIKE axq_file.axq09          #貸方合計  #No.FUN-680098  dec(20,6) 
#----以下為資料匯入時使用的變數----
DEFINE g_file           STRING                       #來源資料檔名INPUT條件)
DEFINE g_disk           LIKE type_file.chr1          #從C:TIPTOP 上傳?(INPUT條件)  #No.FUN-680098   
DEFINE g_axql           RECORD LIKE axq_file.*
DEFINE g_t003_01        LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(146) 
DEFINE l_table          STRING                       #NO.FUN-830144                                                                 
DEFINE g_str            STRING                       #NO.FUN-830144                                                                 
DEFINE gg_sql           STRING                       #NO.FUN-830144
DEFINE g_azp03          LIKE azp_file.azp03          #FUN-910001 add
DEFINE g_choice         LIKE type_file.chr1          #No.FUN-950055
DEFINE g_cmd            LIKE type_file.chr100        #FUN-D20044
DEFINE sheet1           STRING                       #FUN-D20044
DEFINE li_result        LIKE type_file.num5          #FUN-D20044
DEFINE l_cmd            LIKE type_file.chr100        #FUN-D20044
DEFINE l_path           LIKE type_file.chr100        #FUN-D20044
DEFINE l_unixpath       LIKE type_file.chr100        #FUN-D20044
 
MAIN
    DEFINE
          l_sl		LIKE type_file.num5            #No.FUN-680098    SMALLINT
 
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
  
   LET gg_sql = "axq04.axq_file.axq04,",                                                                                            
                "axq041.axq_file.axq041,",                                                                                          
                "axq06.axq_file.axq06,",                                                                                            
                "axq07.axq_file.axq07,",                                                                                            
                "axq12.axq_file.axq12,",                                                                                            
                "axq05.axq_file.axq05,", 
                "axq051.axq_file.axq051,",      #No.FUN-920111                                                                                           
                "axq13.axq_file.axq13,",                                                                                            
                "axq08.axq_file.axq08,",                                                                                            
                "axq09.axq_file.axq09"                                                                                              
   LET l_table = cl_prt_temptable('aglt003',gg_sql) CLIPPED                                                                         
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                        
   LET gg_sql  = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                
                 " VALUES(?,?,?,?,?,?,?,?,?,?)"                                                                                     
   PREPARE insert_prep FROM gg_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',STATUS,1)                                                                                          
      EXIT PROGRAM                                                                                                                  
   END IF                                                                                                                           
 
   LET g_forupd_sql = "SELECT axq04,axq041,axq06,axq07,axq12 FROM axq_file ",
                      " WHERE axq01=? AND axq04=? AND axq041=? ", #FUN-910001 add axq01
                      "   AND axq06=? AND axq07=? AND axq12=? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t003_lock_u CURSOR FROM g_forupd_sql
 
   LET g_bookno = ARG_VAL(1)           #參數值(1) Part#
   SELECT azp03 INTO g_azp03 FROM azp_file WHERE azp01=g_plant   #FUN-910001 add
   
   LET p_row = 1 LET p_col = 1
   OPEN WINDOW t003_w AT p_row,p_col WITH FORM 'agl/42f/aglt003'
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_set_comp_visible("axq29",FALSE)  #CHI-D20029 add
 
   IF NOT cl_null(g_bookno) THEN
      CALL t003_q()
   END IF
 
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64 
   END IF
   CALL s_dsmark(g_bookno)
 
   CALL t003_menu()
   CLOSE WINDOW t003_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION t003_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   DEFINE l_axq04 LIKE axq_file.axq04
   DEFINE l_axz05 LIKE axz_file.axz05
 
   CLEAR FORM #清除畫面
   CALL g_aag.clear()
   CALL cl_set_head_visible("","YES")             #No.FUN-6B0029
 
   # 螢幕上取單頭條件
   INITIALIZE g_axq.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON axq01,axq04,axq041,axq06,axq07,axq12  #FUN-910001 add axq01
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(axq01)   #族群代號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_axa1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO axq01
               NEXT FIELD axq01
             WHEN INFIELD(axq04)   #下層公司編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axz2"   #MOD-740139   #只開非使用TIPTOP的公司
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axq04
                 LET l_axq04 = g_qryparam.multiret
             WHEN INFIELD(axq041)  #帳別開窗
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axq041
                 NEXT FIELD axq041
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
 
       AFTER CONSTRUCT
          CALL GET_FLDBUF(axq041) RETURNING g_axq.axq041   
 
       ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   #螢幕上取單身條件
   CONSTRUCT g_wc2 ON axq05,axq13,axq08,axq09
                     ,axq14,axq15,axq16,axq17 #FUN-9B0017
             FROM s_axq[1].axq05,s_axq[1].axq13,s_axq[1].axq08,s_axq[1].axq09
                 ,s_axq[1].axq14,s_axq[1].axq15,s_axq[1].axq16,s_axq[1].axq17 #FUN-9B0017
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axq05)   #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 IF NOT cl_null(g_axq.axq041) THEN
                    LET g_qryparam.arg1 = g_axq.axq041
                 ELSE
                    LET g_qryparam.arg1 = g_aaz.aaz64   
                 END IF
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axq05
            WHEN INFIELD(axq13)   #關係人代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc13"   #FUN-910001
                 LET g_qryparam.state = "c"
                 LET g_qryparam.plant = g_plant   #No.FUN-980025   
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axq13
#FUN-9B0017   ---start
            WHEN INFIELD(axq14)   #異動碼5值
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form ="q_ahe"                                                                         
                 LET g_qryparam.state = "c"                                                                                         
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO axq14
                 NEXT FIELD axq14
            WHEN INFIELD(axq15)   #異動碼6值  
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form ="q_ahe"                                                                                       
                 LET g_qryparam.state = "c"                                                                                         
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO axq15                                                                               
                 NEXT FIELD axq15                 
            WHEN INFIELD(axq16)   #異動碼7值  
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form ="q_ahe"                                                                                       
                 LET g_qryparam.state = "c"                                                                                         
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO axq16                                                                               
                 NEXT FIELD axq16                 
            WHEN INFIELD(axq17)   #異動碼8值  
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form ="q_ahe"                                                                                       
                 LET g_qryparam.state = "c"                                                                                         
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO axq17                                                                               
                 NEXT FIELD axq17                 
#FUN-9B0017   ---end     
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
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
 
   IF g_wc2 = " 1=1" THEN               # 若單身未輸入條件
      LET g_sql = "SELECT UNIQUE axq01,axq04,axq041,axq06,axq07,axq12 ",   #FUN-910001 add axq01
                  "  FROM axq_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY axq01,axq04,axq041,axq06,axq07,axq12"   #FUN-910001 add axq01
   ELSE                                 # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE axq01,axq04,axq041,axq06,axq07,axq12 ",  #FUN-910001 add axq01
                  "  FROM axq_file ",
                  " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY axq01,axq04,axq041,axq06,axq07,axq12"   #FUN-910001 add axq01
   END IF
   PREPARE t003_prepare FROM g_sql
   DECLARE t003_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR t003_prepare
 
   DROP TABLE x
   LET g_sql_tmp="SELECT UNIQUE axq01,axq04,axq041,axq06,axq07,axq12 ",  #No.TQC-720019   #FUN-910001 add axq01
             "  FROM axq_file ",
             " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
             "  INTO TEMP x "
   PREPARE t003_temp FROM g_sql_tmp  #No.TQC-720019
   EXECUTE t003_temp
 
   LET g_sql = "SELECT COUNT(*) FROM x"
   PREPARE t003_prepare_cnt FROM g_sql
   DECLARE t003_count CURSOR FOR t003_prepare_cnt
END FUNCTION
 
FUNCTION t003_menu()
 
   WHILE TRUE
      CALL t003_bp("G")
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL t003_a()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL t003_q()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL t003_r()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL t003_copy()
            END IF
         WHEN "detail"                          # B.單身
            IF cl_chk_act_auth() THEN
               CALL t003_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"                          # O.列印
            IF cl_chk_act_auth()
               THEN CALL t003_out()
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aag),'','')
            END IF
         WHEN "dataload"                        # 資料匯入
            CALL t003_dataload()
        #FUN-D20044--
         WHEN "excelexample"                    # 匯出Excel範本
            LET l_unixpath = os.Path.join( os.Path.join( os.Path.join(FGL_GETENV("TOP"),"tool"),"report"),"aglsample.xls")
            LET l_path = "C:\\tiptop\\aglt003.xls"
            LET g_cmd = "EXCEL ",l_path
            LET sheet1 = "sheet1"
            LET li_result = cl_download_file(l_unixpath,l_path)
            IF STATUS THEN
               CALL cl_err('',"amd-021",1)
               DISPLAY "Download fail!!"
               LET g_success = 'N'
               RETURN
            END IF
            CALL ui.Interface.frontCall("standard","shellexec",[g_cmd],[])
            SLEEP 10
            CALL ui.Interface.frontCall("WINDDE","DDEConnect",[g_cmd,sheet1],[li_result])
            CALL t003_checkError(li_result,"Connect DDE Sheet1")
            CALL t003_exceldata()
            CALL ui.Interface.frontCall("WINDDE","DDEFinish",[l_cmd,sheet1],[li_result])
        #FUN-D20044--
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t003_a()                            # Add  輸入
   IF s_shut(0) THEN RETURN END IF            #判斷目前系統是否可用
   MESSAGE ""
   CLEAR FORM
   CALL g_aag.clear()
   INITIALIZE g_axq.* LIKE axq_file.*         #DEFAULT 設定
   LET g_sumaxq08 = 0
   LET g_sumaxq09 = 0
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL t003_i("a")                        # 輸入單頭
 
      IF INT_FLAG THEN                        # 使用者不玩了
         LET g_axq.axq01 = NULL   #FUN-910001 add
         LET g_axq.axq04 = NULL
         LET g_axq.axq041= NULL
         LET g_axq.axq06 = NULL
         LET g_axq.axq07 = NULL
         LET g_axq.axq12 = NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_axq.axq01 IS NULL OR g_axq.axq04 IS NULL OR g_axq.axq041 IS NULL OR   #FUN-910001 add axq01
         g_axq.axq06 IS NULL OR g_axq.axq07 IS NULL OR g_axq.axq12 IS NULL  THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      CALL g_aag.clear()
      LET g_rec_b = 0
 
      CALL t003_b()                           # 輸入單身
 
      SELECT axq06 INTO g_axq.axq06 FROM axq_file
       WHERE axq04=g_axq.axq04 AND axq041=g_axq.axq041
         AND axq06=g_axq.axq06 AND axq07=g_axq.axq07 AND axq12=g_axq.axq12
         AND axq01=g_axq.axq01   #FUN-910001 add
      LET g_axq_t.* = g_axq.*                 #保留舊值
 
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t003_i(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1,               #a:輸入 u:更改        #No.FUN-680098 VARCHAR(1) 
       l_n         LIKE type_file.num5     #FUN-740198 add
DEFINE l_axz10     LIKE axz_file.axz10     #CHI-D20029 
 
   DISPLAY BY NAME g_sumaxq08,g_sumaxq09
   DISPLAY g_axq.* TO axq01,axq04,axq041,axq06,axq07,axq12   #FUN-910001 add axq01
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
   INPUT g_axq.axq01,g_axq.axq04,g_axq.axq041,g_axq.axq06,g_axq.axq07,g_axq.axq12 WITHOUT DEFAULTS  #FUN-910001 add axq01
         FROM axq01,axq04,axq041,axq06,axq07,axq12   #FUN-910001 add axq01
     
      AFTER FIELD axq01
         IF cl_null(g_axq.axq01) THEN
            CALL cl_err(g_axq.axq01,'mfg5103',0)
            NEXT FIELD axq01
         END IF
     
      AFTER FIELD axq04
         IF cl_null(g_axq.axq04) THEN
            CALL cl_err(g_axq.axq04,'mfg5103',0)
            NEXT FIELD axq04
         END IF
         SELECT axz05,axz06 INTO g_axq.axq041,g_axq.axq12
           FROM axz_file
          WHERE axz01 = g_axq.axq04
         IF SQLCA.SQLCODE THEN
            CALL cl_err(g_axq.axq04,'aco-025',0)
            NEXT FIELD axq04
         END IF
         DISPLAY g_axq.axq041 TO axq041
         DISPLAY g_axq.axq12  TO axq12
         #增加公司+帳別的合理性判斷,應存在agli009
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM axz_file
          WHERE axz01=g_axq.axq04 AND axz05=g_axq.axq041 AND axz04='N'   #MOD-740139 add axz04='N'
         IF l_n = 0 THEN
            CALL cl_err(g_axq.axq04,'agl-948',0)   #MOD-740139 modify
            NEXT FIELD axq04
         END IF
         #--CHI-D20029 start--
         SELECT axz10 INTO l_axz10 FROM axz_file WHERE axz01= g_axq.axq04
         IF l_axz10 = 'Y' OR cl_null(l_axz10) THEN        
             CALL cl_set_comp_visible("axq29",TRUE)
         ELSE
             CALL cl_set_comp_visible("axq29",FALSE)
         END IF
         #--CHI-D20029 end---
 
      AFTER FIELD axq041
         IF cl_null(g_axq.axq041) THEN
            CALL cl_err(g_axq.axq041,'mfg5103',0)
            NEXT FIELD axq041
         END IF
         #增加公司+帳別的合理性判斷,應存在agli009
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM axz_file
          WHERE axz01=g_axq.axq04 AND axz05=g_axq.axq041 AND axz04='N'   #MOD-740139 add axz04='N'
         IF l_n = 0 THEN
            CALL cl_err(g_axq.axq041,'agl-948',0)   #MOD-740139 modify
            NEXT FIELD axq041
         END IF

      #TQC-AB0296 modify---begin-------------------------
      AFTER FIELD axq06
         IF NOT cl_null(g_axq.axq06) THEN
            IF g_axq.axq06 < 0 THEN
               CALL cl_err(g_axq.axq06,'apj-035',0)
              LET g_axq.axq06 = g_axq_t.axq06
              NEXT FIELD axq06
            END IF
         END IF
      #TQC-AB0296 modify----end--------------------------
 
      AFTER FIELD axq07
         IF NOT cl_null(g_axq.axq07) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_axq.axq06
            IF g_azm.azm02 = 1 THEN
               IF g_axq.axq07 > 12 OR g_axq.axq07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD axq07
               END IF
            ELSE
               IF g_axq.axq07 > 13 OR g_axq.axq07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD axq07
               END IF
            END IF
         END IF
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(axq01)   #族群代號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_axa1"
                LET g_qryparam.default1 = g_axq.axq01
                CALL cl_create_qry() RETURNING g_axq.axq01
                DISPLAY g_axq.axq01 TO axq01
                NEXT FIELD axq01
           WHEN INFIELD(axq04)   #下層公司編號
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_axz2"   #MOD-740139   #只開非使用TIPTOP的公司
                LET g_qryparam.default1 = g_axq.axq04
                CALL cl_create_qry() RETURNING g_axq.axq04
                DISPLAY g_axq.axq04 TO axq04
                NEXT FIELD axq04
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
 
FUNCTION t003_u()
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_axq.axq01) AND cl_null(g_axq.axq04) AND cl_null(g_axq.axq041) AND  #FUN-910001 add axq01
      cl_null(g_axq.axq06) AND cl_null(g_axq.axq07) AND cl_null(g_axq.axq12) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT axq01,axq04,axq041,axq06,axq07,axq12 INTO g_axq.*   #FUN-910001 add axq01
     FROM axq_file
    WHERE axq04=g_axq.axq04 AND axa041=g_axq.axq041
      AND axa06=g_axq.axq06 AND axa07=g_axq.axq07 AND axa12=g_axq.axq12
      AND axq01=g_axq.axq01   #FUN-910001 add
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_axq_t.axq01 = g_axq.axq01   #FUN-910001 add
   LET g_axq_t.axq04 = g_axq.axq04
   LET g_axq_t.axq041= g_axq.axq041
   LET g_axq_t.axq06 = g_axq.axq06
   LET g_axq_t.axq07 = g_axq.axq07
   LET g_axq_t.axq12 = g_axq.axq12
   BEGIN WORK
 
   OPEN t003_lock_u USING g_axq.axq01,g_axq.axq04,g_axq.axq041,  #FUN-910001 add axq01
                          g_axq.axq06,g_axq.axq07,g_axq.axq12
   IF STATUS THEN
      CALL cl_err("OPEN t003_lock_u:", STATUS, 1)  
      CLOSE t003_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t003_lock_u INTO g_axq.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t003_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t003_show()
 
   WHILE TRUE
      LET g_axq_t.axq01 = g_axq.axq01   #FUN-910001 add
      LET g_axq_t.axq04 = g_axq.axq04
      LET g_axq_t.axq041= g_axq.axq041
      LET g_axq_t.axq06 = g_axq.axq06
      LET g_axq_t.axq07 = g_axq.axq07
      LET g_axq_t.axq12 = g_axq.axq12
 
      CALL t003_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL t003_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE axq_file SET axq04 = g_axq.axq04,
                          axq041= g_axq.axq041,
                          axq06 = g_axq.axq06,
                          axq07 = g_axq.axq07,
                          axq12 = g_axq.axq12,
                          axqmodu = g_user,
                          axqdate = g_today,
                          axq01 = g_axq.axq01   #FUN-910001 add
       WHERE axq04 = g_axq_t.axq04
         AND axq041= g_axq_t.axq041
         AND axq06 = g_axq_t.axq06
         AND axq07 = g_axq_t.axq07
         AND axq12 = g_axq_t.axq12
         AND axq01 = g_axq_t.axq01   #FUN-910001 add
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","axq_file",g_axq_t.axq04,g_axq_t.axq041,SQLCA.sqlcode,"","axq",1)  #No.FUN-660123
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t003_lock_u
   COMMIT WORK
END FUNCTION
 
FUNCTION t003_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_axq.* TO NULL             #No.FUN-6B0040
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL g_aag.clear()
    DISPLAY '' TO FORMONLY.cnt
 
    CALL t003_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    OPEN t003_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       CALL t003_fetch('F')                  # 讀出TEMP第一筆並顯示
       OPEN t003_count
       FETCH t003_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
FUNCTION t003_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
          l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098 integer
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t003_cs INTO g_axq.axq01,g_axq.axq04,g_axq.axq041,   #FUN-910001 add axq01
                                           g_axq.axq06,g_axq.axq07,g_axq.axq12
      WHEN 'P' FETCH PREVIOUS t003_cs INTO g_axq.axq01,g_axq.axq04,g_axq.axq041,   #FUN-910001 add axq01
                                           g_axq.axq06,g_axq.axq07,g_axq.axq12
      WHEN 'F' FETCH FIRST    t003_cs INTO g_axq.axq01,g_axq.axq04,g_axq.axq041,   #FUN-910001 add axq01
                                           g_axq.axq06,g_axq.axq07,g_axq.axq12
      WHEN 'L' FETCH LAST     t003_cs INTO g_axq.axq01,g_axq.axq04,g_axq.axq041,   #FUN-910001 add axq01
                                           g_axq.axq06,g_axq.axq07,g_axq.axq12
      WHEN '/'
            IF (NOT mi_no_ask) THEN      #No.FUN-6A0061
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
            FETCH ABSOLUTE g_jump t003_cs INTO g_axq.axq01,g_axq.axq04,g_axq.axq041,   #FUN-910001 add axq01
                                               g_axq.axq06,g_axq.axq07,g_axq.axq12
            LET mi_no_ask = FALSE    #No.FUN-6A0061
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_axq.* TO NULL  #TQC-6B0105
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
 
   CALL t003_show()
END FUNCTION
 
FUNCTION t003_show()
DEFINE l_axz10  LIKE axz_file.axz10   #CHI-D20029
 
   DISPLAY g_axq.axq01,g_axq.axq04,g_axq.axq041,  #FUN-910001 add axq01
           g_axq.axq06,g_axq.axq07,g_axq.axq12
        TO axq01,axq04,axq041,axq06,axq07,axq12   #FUN-910001 add axq01

   #--CHI-D20029 start--
   SELECT axz10 INTO l_axz10 FROM axz_file WHERE axz01= g_axq.axq04
   IF l_axz10 = 'Y' OR cl_null(l_axz10) THEN        
       CALL cl_set_comp_visible("axq29",TRUE)
   ELSE
       CALL cl_set_comp_visible("axq29",FALSE)
   END IF
   #--CHI-D20029 end---
   CALL t003_b_fill(g_wc2) #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION t003_r()
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_axq.axq01) AND cl_null(g_axq.axq04) AND cl_null(g_axq.axq041) AND   #FUN-910001 add axq01
      cl_null(g_axq.axq06) AND cl_null(g_axq.axq07) AND cl_null(g_axq.axq12) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
 
   IF cl_delh(15,16) THEN
      DELETE FROM axq_file WHERE axq04=g_axq.axq04 AND axq041=g_axq.axq041
                             AND axq06=g_axq.axq06 AND axq07=g_axq.axq07
                             AND axq12=g_axq.axq12
                             AND axq01=g_axq.axq01   #FUN-910001 add
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","axq_file",g_axq.axq04,g_axq.axq041,SQLCA.sqlcode,"","",1)  #No.FUN-660123
      ELSE
         CLEAR FORM
         CALL g_aag.clear()
         DROP TABLE x                        #No.TQC-720019
         PREPARE t003_pre_y2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE t003_pre_y2                 #No.TQC-720019
         OPEN t003_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE t003_cs
            CLOSE t003_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end-- 
         FETCH t003_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t003_cs
            CLOSE t003_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t003_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t003_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE   #No.FUN-6A0061
            CALL t003_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
#單身
FUNCTION t003_b()
DEFINE
   l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT   #No.FUN-680098 SMALLINT
   l_n             LIKE type_file.num5,      #檢查重複用          #No.FUN-680098 SMALLINT
   l_lock_sw       LIKE type_file.chr1,      #單身鎖住否          #No.FUN-680098 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,      #處理狀態            #No.FUN-680098 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,      #可新增否            #No.FUN-680098 SMALLINT
   l_allow_delete  LIKE type_file.num5,      #可刪除否            #No.FUN-680098 SMALLINT
   l_azi04         LIKE azi_file.azi04       #金額取位小數位數    #FUN-740166 add
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   IF cl_null(g_axq.axq01) AND cl_null(g_axq.axq04) AND cl_null(g_axq.axq041) AND   #FUN-910001 add axq01
      cl_null(g_axq.axq06) AND cl_null(g_axq.axq07) AND cl_null(g_axq.axq12) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_forupd_sql =
      #"SELECT axq05,axq051,axq13,axq08,axq09,axq14,axq15,axq16,axq17 FROM axq_file ",        #CHI-D20029 mark   #NO.FUN-920111 #FUN-9B0017 add axq14-axq17
       "SELECT axq29,axq05,axq051,axq13,axq08,axq09,axq14,axq15,axq16,axq17 FROM axq_file ",  #CHI-D20029 add axq29
       " WHERE axq01=? AND axq04=? AND axq041=? AND axq06=? AND axq07=? AND axq12=? ",   #FUN-910001 add axq01
       "   AND axq05=? AND axq13=? AND axq14=? AND axq15=? AND axq16=? AND axq17=? ",       #FUN-9B0017 add axq14-axq17
       " FOR UPDATE"   #MOD-6B0164
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t003_bcl CURSOR FROM g_forupd_sql     # LOCK CURSOR
 
   #取得下層公司幣別金額取位小數位數
   SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=g_axq.axq12   
   IF cl_null(l_azi04) THEN LET l_azi04 = 0 END IF
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_aag WITHOUT DEFAULTS FROM s_axq.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
       BEFORE INPUT
           IF g_rec_b!=0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'                       #DEFAULT
           LET l_n  = ARR_COUNT()
 
           IF g_rec_b >= l_ac THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_aag_t.* = g_aag[l_ac].*          #BACKUP
              OPEN t003_bcl USING g_axq.axq01,g_axq.axq04,g_axq.axq041,   #FUN-910001 add axq01
                                  g_axq.axq06,g_axq.axq07,g_axq.axq12,
                                  g_aag_t.axq05,g_aag_t.axq13   #MOD-6B0164
                                 ,g_aag_t.axq14,g_aag_t.axq15,   #FUN-9B0017
                                  g_aag_t.axq16,g_aag_t.axq17    #FUN-9B0017
              IF STATUS THEN
                 CALL cl_err("OPEN t003_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t003_bcl INTO g_aag[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_aag_t.axq05,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_aag[l_ac].* TO NULL      #900423
           LET g_aag[l_ac].axq08 = 0
           LET g_aag[l_ac].axq09 = 0
           LET g_aag_t.* = g_aag[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD axq05
 
       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              INITIALIZE g_aag[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_aag[l_ac].* TO s_axq.*
              CALL g_aag.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_aag[l_ac].axq13) THEN
              LET g_aag[l_ac].axq13 = ' '
           END IF
           IF cl_null(g_aag[l_ac].axq08) THEN
              LET g_aag[l_ac].axq08 = 0
           END IF
           IF cl_null(g_aag[l_ac].axq09) THEN
              LET g_aag[l_ac].axq09 = 0
           END IF
          #
           INSERT INTO axq_file(axq00,axq01,axq02,axq03,   #FUN-770069 mod
                                axq04,axq041,axq06,axq07,axq12,
                                axq05,axq051,axq13,axq08,axq09,           #No.FUN-920111
                                axquser,axqgrup,axqmodu,axqdate,axqlegal,axqoriu,axqorig, #FUN-980003 add axqlegal
                               #axq14,axq15,axq16,axq17)        #CHI-D20029 mark   #FUN-9B0017
                                axq14,axq15,axq16,axq17,axq29)  #CHI-D20029 add axq29
                         VALUES(' ',g_axq.axq01,' ',' ',           #FUN-770069 mod   #FUN-910001 mod
                                g_axq.axq04,g_axq.axq041,g_axq.axq06,
                                g_axq.axq07,g_axq.axq12,g_aag[l_ac].axq05,g_aag[l_ac].axq051,   #No.FUN-920111
                                g_aag[l_ac].axq13,g_aag[l_ac].axq08,
                                g_aag[l_ac].axq09,g_user,g_grup,g_user,g_today,g_legal, g_user, g_grup,  #FUN-980003 add g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
                                g_aag[l_ac].axq14,g_aag[l_ac].axq15, #FUN-9B0017
                               #g_aag[l_ac].axq16,g_aag[l_ac].axq17)   #CHI-D20029 mark   #FUN-9B0017
                                g_aag[l_ac].axq16,g_aag[l_ac].axq17,g_aag[l_ac].axq29)    #CHI-D20029 add axq29

           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","axq_file",g_axq.axq04,g_axq.axq041,SQLCA.sqlcode,"","",1)  #No.FUN-660123
              CANCEL INSERT
           ELSE
              LET g_rec_b = g_rec_b + 1
              DISPLAY g_rec_b TO FORMONLY.cn2
              CALL t003_upamt()
              MESSAGE 'INSERT O.K'
           END IF
 
       AFTER FIELD axq13
           IF cl_null(g_aag[l_ac].axq13) THEN
              LET g_aag[l_ac].axq13 = ' '
           END IF
           IF g_aag_t.axq13 IS NULL OR g_aag_t.axq05 IS NULL OR
             (g_aag[l_ac].axq05 != g_aag_t.axq05) OR
             (g_aag[l_ac].axq13 != g_aag_t.axq13) THEN
              SELECT COUNT(*) INTO l_n
                FROM axq_file
               WHERE axq04=g_axq.axq04 AND axq041=g_axq.axq041
                 AND axq06=g_axq.axq06 AND axq07=g_axq.axq07
                 AND axq12=g_axq.axq12 AND axq05=g_aag[l_ac].axq05
                 AND axq13=g_aag[l_ac].axq13
                 AND axq01=g_axq.axq01    #FUN-910001 add
                 AND axq14=g_aag[l_ac].axq14  #FUN-9B0017
                 AND axq15=g_aag[l_ac].axq15  #FUN-9B0017
                 AND axq16=g_aag[l_ac].axq16  #FUN-9B0017
                 AND axq17=g_aag[l_ac].axq17  #FUN-9B0017
              IF l_n > 0 THEN
                 CALL cl_err('',-239,0)
                 NEXT FIELD axq13
              END IF
           END IF
 
#FUN-9B0017   ---start
       AFTER FIELD axq14	
          IF cl_null(g_aag[l_ac].axq14) THEN	
             LET g_aag[l_ac].axq14 = ' '
          END IF	
          IF g_aag_t.axq14 IS NULL OR g_aag_t.axq05 IS NULL OR	
            (g_aag[l_ac].axq05 != g_aag_t.axq05) OR	
            (g_aag[l_ac].axq14 != g_aag_t.axq14) THEN	
             SELECT COUNT(*) INTO l_n	
               FROM axq_file	
              WHERE axq04=g_axq.axq04 AND axq041=g_axq.axq041	
                AND axq06=g_axq.axq06 AND axq07=g_axq.axq07	
                AND axq12=g_axq.axq12 AND axq05=g_aag[l_ac].axq05	
                AND axq13=g_aag[l_ac].axq13	
                AND axq14=g_aag[l_ac].axq14	
                AND axq15=g_aag[l_ac].axq15	
                AND axq16=g_aag[l_ac].axq16	
                AND axq17=g_aag[l_ac].axq17                	
                AND axq01=g_axq.axq01    	
             IF l_n > 0 THEN	
                CALL cl_err('',-239,0)	
                NEXT FIELD axq14	
             END IF	
          END IF	
	
       AFTER FIELD axq15	
          IF cl_null(g_aag[l_ac].axq15) THEN	
             LET g_aag[l_ac].axq15 = ' '
          END IF	
          IF g_aag_t.axq15 IS NULL OR g_aag_t.axq05 IS NULL OR	
            (g_aag[l_ac].axq05 != g_aag_t.axq05) OR	
            (g_aag[l_ac].axq15 != g_aag_t.axq15) THEN	
             SELECT COUNT(*) INTO l_n	
               FROM axq_file	
              WHERE axq04=g_axq.axq04 AND axq041=g_axq.axq041	
                AND axq06=g_axq.axq06 AND axq07=g_axq.axq07	
                AND axq12=g_axq.axq12 AND axq05=g_aag[l_ac].axq05	
                AND axq13=g_aag[l_ac].axq13	
                AND axq14=g_aag[l_ac].axq14	
                AND axq15=g_aag[l_ac].axq15	
                AND axq16=g_aag[l_ac].axq16	
                AND axq17=g_aag[l_ac].axq17                	
                AND axq01=g_axq.axq01    	
             IF l_n > 0 THEN	
                CALL cl_err('',-239,0)	
                NEXT FIELD axq15	
             END IF	
          END IF	
	
       AFTER FIELD axq16	
          IF cl_null(g_aag[l_ac].axq16) THEN	
             LET g_aag[l_ac].axq16 = ' '
          END IF	
          IF g_aag_t.axq16 IS NULL OR g_aag_t.axq05 IS NULL OR	
            (g_aag[l_ac].axq05 != g_aag_t.axq05) OR	
            (g_aag[l_ac].axq14 != g_aag_t.axq14) THEN	
             SELECT COUNT(*) INTO l_n	
               FROM axq_file	
              WHERE axq04=g_axq.axq04 AND axq041=g_axq.axq041	
                AND axq06=g_axq.axq06 AND axq07=g_axq.axq07	
                AND axq12=g_axq.axq12 AND axq05=g_aag[l_ac].axq05	
                AND axq13=g_aag[l_ac].axq13	
                AND axq14=g_aag[l_ac].axq14	
                AND axq15=g_aag[l_ac].axq15	
                AND axq16=g_aag[l_ac].axq16	
                AND axq17=g_aag[l_ac].axq17                	
                AND axq01=g_axq.axq01    	
             IF l_n > 0 THEN	
                CALL cl_err('',-239,0)	
                NEXT FIELD axq16	
             END IF	
          END IF	
	
       AFTER FIELD axq17	
          IF cl_null(g_aag[l_ac].axq17) THEN	
             LET g_aag[l_ac].axq17 = ' '
          END IF	
          IF g_aag_t.axq17 IS NULL OR g_aag_t.axq05 IS NULL OR	
            (g_aag[l_ac].axq05 != g_aag_t.axq05) OR	
            (g_aag[l_ac].axq17 != g_aag_t.axq17) THEN	
             SELECT COUNT(*) INTO l_n	
               FROM axq_file	
              WHERE axq04=g_axq.axq04 AND axq041=g_axq.axq041	
                AND axq06=g_axq.axq06 AND axq07=g_axq.axq07	
                AND axq12=g_axq.axq12 AND axq05=g_aag[l_ac].axq05	
                AND axq13=g_aag[l_ac].axq13	
                AND axq14=g_aag[l_ac].axq14	
                AND axq15=g_aag[l_ac].axq15	
                AND axq16=g_aag[l_ac].axq16	
                AND axq17=g_aag[l_ac].axq17                	
                AND axq01=g_axq.axq01    	
             IF l_n > 0 THEN	
                CALL cl_err('',-239,0)	
                NEXT FIELD axq17	
             END IF	
          END IF	
#FUN-9B0017   ---end
       #增加借貸方金額取位
       AFTER FIELD axq08
           IF NOT cl_null(g_aag[l_ac].axq08) THEN
              CALL cl_digcut(g_aag[l_ac].axq08,l_azi04) 
                   RETURNING g_aag[l_ac].axq08
              DISPLAY BY NAME g_aag[l_ac].axq08
           END IF
 
       AFTER FIELD axq09
           IF NOT cl_null(g_aag[l_ac].axq09) THEN
              CALL cl_digcut(g_aag[l_ac].axq09,l_azi04) 
                   RETURNING g_aag[l_ac].axq09
              DISPLAY BY NAME g_aag[l_ac].axq09
           END IF
 
       BEFORE DELETE                            #是否取消單身
           IF g_aag_t.axq05 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
 
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
 
              DELETE FROM axq_file
               WHERE axq04=g_axq.axq04   AND axq041=g_axq.axq041
                 AND axq06=g_axq.axq06   AND axq07=g_axq.axq07
                 AND axq12=g_axq.axq12   
                 AND axq05=g_aag_t.axq05 AND axq13=g_aag_t.axq13   #FUN-770069 mod
                 AND axq01=g_axq.axq01    #FUN-910001 add
                 AND axq14=g_aag_t.axq14 AND axq15=g_aag_t.axq15 #FUN-9B0017
                 AND axq16=g_aag_t.axq16 AND axq17=g_aag_t.axq17 #FUN-9B0017
                 AND axq29=g_aag_t.axq29 #CHI-D20029 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","axq_file",g_axq.axq04,g_axq.axq041,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE
                 LET g_rec_b = g_rec_b-1
                 CALL t003_upamt()
                 DISPLAY g_rec_b TO FORMONLY.cn2
                 COMMIT WORK
              END IF
           END IF
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_aag[l_ac].* = g_aag_t.*
              CLOSE t003_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
 
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_aag[l_ac].axq05,-263,1)
              LET g_aag[l_ac].* = g_aag_t.*
           ELSE
              UPDATE axq_file SET axq05 = g_aag[l_ac].axq05,
                                  axq051 = g_aag[l_ac].axq051,   #No.FUN-920111
                                  axq13 = g_aag[l_ac].axq13,
                                  axq08 = g_aag[l_ac].axq08,
                                  axq09 = g_aag[l_ac].axq09,
                                  axqmodu = g_user,
                                  axqdate = g_today
                                 ,axq14 = g_aag[l_ac].axq14, #FUN-9B0017
                                  axq15 = g_aag[l_ac].axq15, #FUN-9B0017
                                  axq16 = g_aag[l_ac].axq16, #FUN-9B0017
                                  axq17 = g_aag[l_ac].axq17  #FUN-9B0017
                                 ,axq29 = g_aag[l_ac].axq29  #CHI-D20029
               WHERE axq04=g_axq.axq04 AND axq041=g_axq.axq041
                 AND axq06=g_axq.axq06 AND axq07=g_axq.axq07
                 AND axq12=g_axq.axq12 AND axq05=g_aag_t.axq05
                 AND axq13=g_aag_t.axq13
                 AND axq01=g_axq.axq01    #FUN-910001 add
                 AND axq14=g_aag_t.axq14 AND axq15=g_aag_t.axq15 #FUN-9B0017
                 AND axq16=g_aag_t.axq16 AND axq17=g_aag_t.axq17 #FUN-9B0017
                 AND axq29=g_aag_t.axq29  #CHI-D20029
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","axq_file",g_axq.axq04,g_axq.axq041,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                 LET g_aag[l_ac].* = g_aag_t.*
              ELSE
                 CALL t003_upamt()
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
       AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac #FUN-D30032 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_aag[l_ac].* = g_aag_t.*
              #FUN-D30032--add--begin--
              ELSE
                 CALL g_aag.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end----
              END IF
              CLOSE t003_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac #FUN-D30032 add
           CLOSE t003_bcl
           COMMIT WORK
           CALL g_aag.deleteElement(g_rec_b+1)
 
       AFTER INPUT
           CALL t003_upamt()
           IF g_sumaxq08 != g_sumaxq09 THEN
              CALL cl_err('','agl-060',1)
           END IF
 
       #增加一ACTION提供開窗"客戶資料"(關係人=Y)
       ON ACTION occ_controlp
          CASE
             WHEN INFIELD(axq13)   #關係人代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_occ92"
                  LET g_qryparam.default1 = g_aag[l_ac].axq13
                  CALL cl_create_qry() RETURNING g_aag[l_ac].axq13
                  DISPLAY g_aag[l_ac].axq13 TO axq13
                  NEXT FIELD axq13
             OTHERWISE EXIT CASE
          END CASE
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(axq05) AND l_ac > 1 THEN
             LET g_aag[l_ac].* = g_aag[l_ac-1].*
             NEXT FIELD axq05
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(axq13)   #關係人代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pmc13"   #FUN-910001 
                  LET g_qryparam.plant = g_plant   #No.FUN-980025   
                  LET g_qryparam.default1 = g_aag[l_ac].axq13
                  CALL cl_create_qry() RETURNING g_aag[l_ac].axq13
                  DISPLAY g_aag[l_ac].axq13 TO axq13
                  NEXT FIELD axq13
#FUN-9B0017   ---start                                                                                                  
             WHEN INFIELD(axq14)   #異動碼5值
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form ="q_ahe"                                                                                      
                  LET g_qryparam.default1 = g_aag[l_ac].axq14                                                                       
                  CALL cl_create_qry() RETURNING g_aag[l_ac].axq14                                                                  
                  DISPLAY g_aag[l_ac].axq14 TO axq14                                                                                
                  NEXT FIELD axq14                
             WHEN INFIELD(axq15)   #異動碼6值  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form ="q_ahe"                                                                                      
                  LET g_qryparam.default1 = g_aag[l_ac].axq15                                                                       
                  CALL cl_create_qry() RETURNING g_aag[l_ac].axq15                                                                  
                  DISPLAY g_aag[l_ac].axq15 TO axq15                                                                                
                  NEXT FIELD axq15      
             WHEN INFIELD(axq16)   #異動碼7值  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form ="q_ahe"                                                                                      
                  LET g_qryparam.default1 = g_aag[l_ac].axq16                                                                       
                  CALL cl_create_qry() RETURNING g_aag[l_ac].axq16                                                                  
                  DISPLAY g_aag[l_ac].axq16 TO axq16                                                                                
                  NEXT FIELD axq16                                                                                                  
             WHEN INFIELD(axq17)   #異動碼8值  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form ="q_ahe"                                                                                      
                  LET g_qryparam.default1 = g_aag[l_ac].axq17                                                                       
                  CALL cl_create_qry() RETURNING g_aag[l_ac].axq17                                                                  
                  DISPLAY g_aag[l_ac].axq17 TO axq17                                                                                
                  NEXT FIELD axq17          
#FUN-9B0017   ---end 
             OTHERWISE EXIT CASE
          END CASE
 
       ON ACTION controlf
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
 
   CLOSE t003_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION t003_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc      STRING,      
          l_sql     STRING,      
          l_n       LIKE type_file.num5          #No.FUN-680098 smallint
 
    #LET l_sql = "SELECT axq05,axq051,axq13,axq08,axq09,axq14,axq15,axq16,axq17 FROM axq_file ",       #CHI-D20029 mark   #No.FUN-920111 #FUN-9B0017 add axq14-axq17
    LET l_sql = "SELECT axq29,axq05,axq051,axq13,axq08,axq09,axq14,axq15,axq16,axq17 FROM axq_file ",  #CHI-D20029 
               " WHERE axq04 ='",g_axq.axq04,"'",
               "   AND axq041='",g_axq.axq041,"'",
               "   AND axq06 ='",g_axq.axq06,"'",
               "   AND axq07 ='",g_axq.axq07,"'",
               "   AND axq12 ='",g_axq.axq12,"'",
               "   AND axq01 ='",g_axq.axq01,"'",   #FUN-910001 add
               "   AND ",p_wc CLIPPED,
               " ORDER BY axq05"
 
   PREPARE t003_pb FROM l_sql
   DECLARE aag_cs CURSOR FOR t003_pb          #BODY CURSOR
 
   CALL g_aag.clear()                         #將資料放入Array前，先將裡面清空
   LET g_cnt=1                                #指定由第一筆開始塞資料
   LET g_rec_b = 0
 
   FOREACH aag_cs INTO g_aag[g_cnt].*         #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      ELSE
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN               #若超過系統指定最大單身筆數，
         CALL cl_err( '', 9035, 0 )           #則停止匯入資料
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_aag.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt -1
   CALL t003_upamt()
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t003_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #依照所選的action，呼叫所屬功能   #No.FUN-680098 VARCHAR(1)
DEFINE l_axz10     LIKE axz_file.axz10          #CHI-D20029  
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN                                    #此判斷用於單身放棄新增時，
   END IF                                       #指標要停留在未新增前的行數
 
   LET g_action_choice = " "
 
   #--CHI-D20029 start--
   SELECT axz10 INTO l_axz10 FROM axz_file WHERE axz01= g_axq.axq04
   IF l_axz10 = 'Y' OR cl_null(l_axz10) THEN        
       CALL cl_set_comp_visible("axq29",TRUE)
   ELSE
       CALL cl_set_comp_visible("axq29",FALSE)
   END IF
   #--CHI-D20029 end---

   CALL cl_set_act_visible("accept,cancel", FALSE)    #將確定、放棄隱藏起來
   DISPLAY ARRAY g_aag TO s_axq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                          #No.FUN-560228
 
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
         CALL t003_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            CALL fgl_set_arr_curr(1)  ######add in 040505
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t003_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            CALL fgl_set_arr_curr(1)  ######add in 040505
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t003_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            CALL fgl_set_arr_curr(1)  ######add in 040505
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t003_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            CALL fgl_set_arr_curr(1)  ######add in 040505
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t003_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            CALL fgl_set_arr_curr(1)  ######add in 040505
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
          LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION dataload
         LET g_action_choice = 'dataload'
         EXIT DISPLAY
 
     #FUN-D20044--
      ON ACTION excelexample 
         LET g_action_choice = 'excelexample'
         EXIT DISPLAY
     #FUN-D20044--
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)        #將確定、放棄顯示出來
END FUNCTION
 
FUNCTION t003_upamt()
   DEFINE l_axq08  LIKE axq_file.axq08,        #No.FUN-680098   dec(20,6)
          l_axq09  LIKE axq_file.axq09         #No.FUN-680098   dec(20,6)
 
   #-->借方合計
   SELECT SUM(axq08) INTO l_axq08
     FROM axq_file
    WHERE axq04 = g_axq.axq04 AND axq041 = g_axq.axq041
      AND axq06 = g_axq.axq06 AND axq07 = g_axq.axq07
      AND axq12 = g_axq.axq12
      AND axq01 = g_axq.axq01         #FUN-910001 add
      IF SQLCA.sqlcode THEN LET l_axq08 = 0 END IF
   #-->貸方合計
   SELECT SUM(axq09) INTO l_axq09
     FROM axq_file
    WHERE axq04 = g_axq.axq04 AND axq041 = g_axq.axq041
      AND axq06 = g_axq.axq06 AND axq07 = g_axq.axq07
      AND axq12 = g_axq.axq12
      AND axq01 = g_axq.axq01         #FUN-910001 add
      IF SQLCA.sqlcode THEN LET l_axq09 = 0 END IF
 
   IF cl_null(l_axq08) THEN LET l_axq08 = 0 END IF
   IF cl_null(l_axq09) THEN LET l_axq09 = 0 END IF
 
   LET g_sumaxq08 = l_axq08
   LET g_sumaxq09 = l_axq09
 
   DISPLAY g_sumaxq08 TO FORMONLY.sumaxq08
   DISPLAY g_sumaxq09 TO FORMONLY.sumaxq09
END FUNCTION
 
FUNCTION t003_copy()
   DEFINE l_axq                 RECORD LIKE axq_file.*,
          l_axq01_o,l_axq01_n   LIKE axq_file.axq01,    #FUN-910001 add
          l_axq04_o,l_axq04_n   LIKE axq_file.axq04,
          l_axq041_o,l_axq041_n LIKE axq_file.axq041,
          l_axq06_o,l_axq06_n   LIKE axq_file.axq06,
          l_axq07_o,l_axq07_n   LIKE axq_file.axq07,
          l_axq12_o,l_axq12_n   LIKE axq_file.axq12
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_axq.axq01 IS NULL AND g_axq.axq04 IS NULL AND g_axq.axq041 IS NULL AND  #FUN-910001 add axq01
      g_axq.axq06 IS NULL AND g_axq.axq07 IS NULL AND g_axq.axq12 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET l_axq06_n = ''
   LET l_axq07_n = ''
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INPUT l_axq01_n,l_axq04_n,l_axq041_n,l_axq06_n,l_axq07_n,l_axq12_n WITHOUT DEFAULTS  #FUN-910001 add axq01_n
         FROM axq01,axq04,axq041,axq06,axq07,axq12   #FUN-910001 add axq01
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axq01)   #族群代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_axa1"
                 LET g_qryparam.default1 = g_axq.axq01
                 CALL cl_create_qry() RETURNING l_axq01_n
                 DISPLAY l_axq01_n TO axq01
                 NEXT FIELD axq01
            WHEN INFIELD(axq04)   #下層公司編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axz2"   #MOD-740139   #只開非使用TIPTOP的公司
                 LET g_qryparam.default1 = g_axq.axq04
                 CALL cl_create_qry() RETURNING l_axq04_n
                 DISPLAY l_axq04_n TO axq04
                 NEXT FIELD axq04
            WHEN INFIELD(axq12)   #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_axq.axq12
                 CALL cl_create_qry() RETURNING l_axq12_n
                 DISPLAY l_axq12_n TO axq12
                 NEXT FIELD axq12
         END CASE

     #MOD-A40022---add---start---
      AFTER FIELD axq04
         IF cl_null(l_axq04_n) THEN
            CALL cl_err(l_axq04_n,'mfg5103',0)
            NEXT FIELD axq04
         END IF
         SELECT axz05,axz06 INTO l_axq041_n,l_axq12_n
           FROM axz_file
          WHERE axz01 = l_axq04_n
         IF SQLCA.SQLCODE THEN
            CALL cl_err(l_axq04_n,'aco-025',0)
            NEXT FIELD axq04
         END IF
         DISPLAY l_axq041_n TO axq041
         DISPLAY l_axq12_n  TO axq12
     #MOD-A40022---add---end---
 
      AFTER FIELD axq12
         IF NOT cl_null(l_axq12_n) THEN
            SELECT count(*) INTO g_cnt FROM axq_file
             WHERE axq04=l_axq04_n AND axq041=l_axq041_n
               AND axq06=l_axq06_n AND axq07=l_axq07_n
               AND axq12=l_axq12_n
               AND axq01=l_axq01_n   #FUN-910001 add
            IF g_cnt > 0 THEN
               CALL cl_err(l_axq12_n,-239,0)
               NEXT FIELD axq12
            END IF
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
      DISPLAY g_axq.axq01,g_axq.axq04,g_axq.axq041,  #FUN-910001 add axq01
              g_axq.axq06,g_axq.axq07,g_axq.axq12
           TO axq01,axq04,axq041,axq06,axq07,axq12   #FUN-910001 add axq01
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM axq_file         #單身複製
    WHERE axq04=g_axq.axq04 AND axq041=g_axq.axq041 AND axq06=g_axq.axq06
      AND axq07=g_axq.axq07 AND axq12=g_axq.axq12
      AND axq01=g_axq.axq01   #FUN-910001 add
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_axq.axq04,g_axq.axq041,SQLCA.sqlcode,"","",1)  #No.FUN-660123
      RETURN
   END IF
 
   UPDATE x
      SET axq04 =l_axq04_n,
          axq041=l_axq041_n,
          axq06 =l_axq06_n,
          axq07 =l_axq07_n,
          axq12 =l_axq12_n,
          axq01 =l_axq01_n   #FUN-910001 add
 
   INSERT INTO axq_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","axq_file",l_axq04_n,l_axq041_n,SQLCA.sqlcode,"","axq:",1)  #No.FUN-660123
      RETURN
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_axq04_n,') O.K'
   
   LET l_axq01_o = g_axq.axq01   #FUN-910001 add
   LET l_axq04_o = g_axq.axq04
   LET l_axq041_o= g_axq.axq041
   LET l_axq06_o = g_axq.axq06
   LET l_axq07_o = g_axq.axq07
   LET l_axq12_o = g_axq.axq12
   LET g_axq.axq01 =l_axq01_n    #FUN-910001 add
   LET g_axq.axq04 =l_axq04_n
   LET g_axq.axq041=l_axq041_n
   LET g_axq.axq06 =l_axq06_n
   LET g_axq.axq07 =l_axq07_n
   LET g_axq.axq12 =l_axq12_n
 
   CALL t003_b()
   #FUN-C30027---begin
   #LET g_axq.axq01 =l_axq01_o    #FUN-910001 add
   #LET g_axq.axq04 =l_axq04_o
   #LET g_axq.axq041=l_axq041_o
   #LET g_axq.axq06 =l_axq06_o
   #LET g_axq.axq07 =l_axq07_o
   #LET g_axq.axq12 =l_axq12_o
   #CALL t003_show()
   #FUN-C30027---end
END FUNCTION
 
FUNCTION t003_dataload()    #資料匯入
   DEFINE l_axz02 LIKE axz_file.axz02
 
   OPEN WINDOW t003_l_w AT p_row,p_col
     WITH FORM "agl/42f/aglt003_l" ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("aglt003_l")
 
   CLEAR FORM
   ERROR ''
   LET g_disk = "N"   #No.MOD-540062
    LET g_choice = '1'
    DISPLAY g_choice TO FORMONLY.b
    
   INPUT g_file,g_choice,g_disk WITHOUT DEFAULTS FROM FORMONLY.file,FORMONLY.b,FORMONLY.c
      
      AFTER FIELD b
         IF g_choice = '2' THEN 
            LET g_disk = 'Y'
         END IF 
      
      AFTER FIELD c
        IF g_choice = '2' AND g_disk = 'N' THEN 
          CALL cl_err('','agl-971',0)
          LET g_disk = 'Y'
          NEXT FIELD c
        END IF   
     
      ON ACTION locale                    #genero
         LET g_action_choice = "locale"
         CALL cl_show_fld_cont()          #No.FUN-550037 hmf
         EXIT INPUT
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()     # Command execution
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t003_l_w
      RETURN
   END IF
   
   WHILE TRUE   #FUN-980075 add
   IF cl_sure(0,0) THEN
      LET g_success='Y'
      BEGIN WORK                               #NO.FUN-710023 
    
      CALL t003_load()
 
      CALL t003_transfer()
 
      DROP TABLE t003_tmp
      CALL s_showmsg()                          #NO.FUN-710023     
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
 
      CLOSE WINDOW t003_l_w
   END IF
   EXIT WHILE                                                                   
   END WHILE                                                                    
   CLOSE WINDOW t003_l_w                                                        
END FUNCTION
 
FUNCTION t003_load()
   DEFINE m_sf        LIKE abh_file.abh11,       #No.FUN-680098   VARCHAR(30)
          m_tempdir   LIKE type_file.chr1000,    #No.FUN-680098   VARCHAR(240)
          ss          LIKE type_file.chr1000,    #No.FUN-680098   VARCHAR(330)
          l_n         LIKE type_file.num5,       #No.FUN-680098   SMALLINT
          m_file      LIKE type_file.chr1000     #No.FUN-680098   VARCHAR(256)
 
IF g_choice = '1' THEN                     #No.FUN-950055
   DROP TABLE t003_tmp;
   CREATE TEMP TABLE t003_tmp (
        t003_01 LIKE type_file.chr1000); 
   IF STATUS THEN
      CALL cl_err('',status,1)
   END IF
 
   LET m_tempdir = FGL_GETENV("TEMPDIR")
   LET l_n = LENGTH(m_tempdir)
 
   IF l_n>0 THEN
      IF m_tempdir[l_n,l_n]='/' THEN
         LET m_tempdir[l_n,l_n]=' '
      END IF
   END IF
 
   IF m_tempdir is null THEN
      LET m_file=g_file
   ELSE
      LET m_file=m_tempdir CLIPPED,'/',g_file
   END IF
 
   IF g_disk= "Y" THEN
      LET m_sf = "c:/tiptop/"
      LET m_sf = m_sf CLIPPED,g_file CLIPPED
      IF NOT cl_upload_file(m_sf, m_file) THEN
         CALL cl_err(NULL, "lib-212", 1)
      END IF
   END IF
 
   -- l_n=0 if the file is exist;
   -- otherwise there is no such file
 
   IF NOT os.Path.exists(m_file) THEN
      IF m_tempdir IS NULL THEN
         LET m_tempdir='.'
      END IF
 
      DISPLAY "* NOTICE * No such text file '",m_file CLIPPED,"'"
      DISPLAY "PLEASE make sure that the text file download from LEADER"
      DISPLAY "has been put in the directory:"
      DISPLAY '--> ',m_tempdir
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
 
   LOAD FROM m_file INSERT INTO t003_tmp
   IF STATUS THEN
      CALL cl_err('',status,1)
   END IF
 
   DECLARE t003_s1_c CURSOR WITH HOLD FOR SELECT t003_01 FROM t003_tmp
 ELSE                                            #No.FUN-950055   
 	 CALL t003_excel_bring(g_file)                 #No.FUN-950055
 END IF                                          #No.FUN-950055
    
END FUNCTION
 
FUNCTION t003_transfer()
   DEFINE l_n    LIKE type_file.num10      #No.FUN-680098 INTEGER
 
 IF g_choice = '1' THEN                    #No.FUN-950055
 
   LET l_n=0
   CALL s_showmsg_init()                   #NO.FUN-710023 
   FOREACH t003_s1_c INTO g_t003_01
      IF STATUS THEN
         CALL s_errmsg(' ',' ',' ',status,1) #NO.FUN-710023 
         LET g_success='N'
         EXIT FOREACH
      END IF
      IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
      END IF                                                     
 
      LET l_n=l_n+1
      MESSAGE l_n
      CALL ui.Interface.refresh() #CKP
      INITIALIZE g_axql.* TO NULL  #MOD-520054
      LET g_axql.axq00 =' '                          #TQC-760205 add
      LET g_axql.axq01 =' '                          #TQC-760205 add
      LET g_axql.axq02 =' '                          #TQC-760205 add
      LET g_axql.axq03 =' '                          #TQC-760205 add
      LET g_axql.axq04 =g_t003_01[1,10] CLIPPED      #下層公司編號 
      LET g_axql.axq041=g_t003_01[11,20] CLIPPED     #下層帳號     
      LET g_axql.axq05 =g_t003_01[21,44] CLIPPED     #科目編號     
      LET g_axql.axq06 =g_t003_01[45,49]             #會計年度     
      LET g_axql.axq07 =g_t003_01[50,54]             #期別         
      LET g_axql.axq08 =g_t003_01[55,75]             #借方金額     
      LET g_axql.axq09 =g_t003_01[76,96]             #貸方金額     
      LET g_axql.axq10 =g_t003_01[97,106]            #借方筆數     
      LET g_axql.axq11 =g_t003_01[107,116]           #貸方筆數    
      LET g_axql.axq12 =g_t003_01[117,120] CLIPPED   #幣別        
      LET g_axql.axq13 =g_t003_01[121,130] CLIPPED   #關係人代號
      LET g_axql.axq01 =g_t003_01[131,140] CLIPPED   #族群代號   #FUN-910001 add 
      LET g_axql.axq051 = g_t003_01[141,221] CLIPPED             #No.FUN-920111  
#FUN-9B0017   ---start
      LET g_axql.axq14 =g_t003_01[222,232] CLIPPED
      LET g_axql.axq15 =g_t003_01[233,243] CLIPPED
      LET g_axql.axq16 =g_t003_01[244,254] CLIPPED
      LET g_axql.axq17 =g_t003_01[255,265] CLIPPED
#FUN-9B0017   ---end
#TQC-BA0076   ---start---
      LET g_axql.axq18 =g_t003_01[266,275] CLIPPED
      LET g_axql.axq19 =g_t003_01[276,285] CLIPPED
      LET g_axql.axq21 =g_t003_01[286,295] CLIPPED
      LET g_axql.axq22 =g_t003_01[296,305] CLIPPED
      LET g_axql.axq23 =g_t003_01[306,315] CLIPPED
      LET g_axql.axq24 =g_t003_01[316,325] CLIPPED
#TQC-BA0076   ----end----
#-----------------No.MOD-B90011-----------------------------start
     IF cl_null(g_axql.axq04) AND cl_null(g_axql.axq05) AND
        cl_null(g_axql.axq06) AND cl_null(g_axql.axq07) AND
        cl_null(g_axql.axq12) THEN
        CONTINUE FOREACH
     END IF
#-----------------No.MOD-B90011-----------------------------end
 
      CALL t003_ins_axq()
   END FOREACH
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
 END IF                    #No.FUN-950055
END FUNCTION
 
FUNCTION t003_ins_axq()
   SELECT * FROM axq_file
    WHERE axq01=g_axql.axq01 AND axq02=g_axql.axq02   AND axq03=g_axql.axq03
      AND axq04=g_axql.axq04 AND axq041=g_axql.axq041 AND axq05=g_axql.axq05
      AND axq06=g_axql.axq06 AND axq07=g_axql.axq07   AND axq00=g_axql.axq00
      AND axq12=g_axql.axq12 AND axq13=g_axql.axq13   #FUN-980075 add axq13
      AND axq14=g_axql.axq14 AND axq15=g_axql.axq15   #FUN-9B0017
      AND axq16=g_axql.axq16 AND axq17=g_axql.axq17   #FUN-9B0017
   IF STATUS THEN
      LET g_axql.axqacti='Y'
      LET g_axql.axquser=g_user
      LET g_axql.axqgrup=g_grup
      LET g_axql.axqdate=g_today
      LET g_axql.axqlegal=g_legal #FUN-980003 add g_legal
 
      IF cl_null(g_axql.axq01)  THEN
         LET g_axql.axq01=' '
      END IF
 
     #--------------------------------MOD-C20020-----------------------mark
     #IF cl_null(g_axql.axq17) THEN LET g_axql.axq17=0   END IF
     #IF cl_null(g_axql.axq18) THEN LET g_axql.axq18=0   END IF
     #IF cl_null(g_axql.axq19) THEN LET g_axql.axq19=0   END IF
     #IF cl_null(g_axql.axq20) THEN LET g_axql.axq20=0   END IF
     #IF cl_null(g_axql.axq21) THEN LET g_axql.axq21=0   END IF
     #IF cl_null(g_axql.axq22) THEN LET g_axql.axq22=0   END IF
     #IF cl_null(g_axql.axq24) THEN LET g_axql.axq24=' ' END IF
     #--------------------------------MOD-C20020-----------------------mark
     #CHI-D30001--str
      IF cl_null(g_axql.axq08) THEN LET g_axql.axq08=0   END IF
      IF cl_null(g_axql.axq09) THEN LET g_axql.axq09=0   END IF
     #CHI-D30001--end

      LET g_axql.axqoriu = g_user      #No.FUN-980030 10/01/04
      LET g_axql.axqorig = g_grup      #No.FUN-980030 10/01/04
      
      INSERT INTO axq_file VALUES (g_axql.*)
      IF STATUS THEN
         LET g_showmsg=g_axql.axq01,"/",g_axql.axq02,"/",g_axql.axq03,"/",g_axql.axq04,"/",
                       g_axql.axq041,"/",g_axql.axq05,"/",g_axql.axq06,"/",g_axql.axq07,"/",
                       g_axql.axq00,"/",g_axql.axq12,"/",g_axql.axq13
         CALL s_errmsg('axq01,axq02,axq03,axq04,axq041,axq05,axq06,axq07
                        ,axq00,axq12,axq13',g_showmsg,'ins axq_file',STATUS,1)    #MOD-A30068 0 modify 1
      END IF
   END IF
END FUNCTION
 
FUNCTION t003_out()
   DEFINE
      l_i             LIKE type_file.num5,          #No.FUN-680098 smallint
      l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
      l_axq  RECORD
              axq04   LIKE axq_file.axq04,
              axq041  LIKE axq_file.axq041,
              axq06   LIKE axq_file.axq06,
              axq07   LIKE axq_file.axq07,
              axq12   LIKE axq_file.axq12,
              axq05   LIKE axq_file.axq05,
              axq051  LIKE axq_file.axq051,            #No.FUN-920111
              axq13   LIKE axq_file.axq13,
              axq08   LIKE axq_file.axq08,
              axq09   LIKE axq_file.axq09
             END RECORD
 
    CALL cl_del_data(l_table)                                                                                                        
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aglt003'
  
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno AND aaf02 = g_lang
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 239 END IF
 
    LET g_sql="SELECT axq04,axq041,axq06,axq07,axq12,axq05,axq051,axq13,axq08,axq09 ",    #No.FUN-920111
             " FROM axq_file ",    #MOD-5A0445
             " WHERE ",g_wc CLIPPED,    #MOD-5A0445
             "   AND ",g_wc2 CLIPPED
   PREPARE t003_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE t003_co CURSOR FOR t003_p1
 
 
   FOREACH t003_co INTO l_axq.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      EXECUTE insert_prep USING                                                                                                     
           l_axq.axq04,l_axq.axq041,l_axq.axq06,l_axq.axq07,                                                                        
           l_axq.axq12,l_axq.axq05,l_axq.axq051,l_axq.axq13,                          #No.FUN-920111                                                                       
           l_axq.axq08,l_axq.axq09 
      
   END FOREACH
   LET gg_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
 
   IF g_zz05 = 'Y' THEN                                                                                                             
      CALL cl_wcchp(g_wc,'axq01,axq04,axq041,axq06,axq07,axq12')   #FUN-910001 mod                                                                          
           RETURNING g_wc                                                                                                           
   ELSE                                                                                                                             
      LET g_wc = ""                                                                                                             
   END IF                                                                                                                           
 
   LET g_str = g_wc                                                                                                                 
   CALL cl_prt_cs3('aglt003','aglt003',gg_sql,g_str) 
END FUNCTION
 
 
FUNCTION t003_excel_bring(p_fname)
   DEFINE p_fname   STRING  
   DEFINE channel_r base.Channel
   DEFINE l_string  LIKE type_file.chr1000
   DEFINE unix_path LIKE type_file.chr1000
   DEFINE window_path LIKE type_file.chr1000
   DEFINE l_cmd     LIKE type_file.chr1000 
   DEFINE li_result LIKE type_file.chr1 
   DEFINE l_column  DYNAMIC ARRAY of RECORD 
            col1    LIKE gaq_file.gaq01,
            col2    LIKE gaq_file.gaq03
                    END RECORD
   DEFINE l_cnt3    LIKE type_file.num5
   DEFINE li_i      LIKE type_file.num5
   DEFINE li_n      LIKE type_file.num5
   DEFINE ls_cell   STRING
   DEFINE ls_cell_r STRING
   DEFINE li_i_r    LIKE type_file.num5
   DEFINE ls_cell_c STRING
   DEFINE ls_value  STRING
   DEFINE ls_value_o  STRING
   DEFINE li_flag   LIKE type_file.chr1 
   DEFINE lr_data_tmp   DYNAMIC ARRAY OF RECORD
             data01 STRING
                    END RECORD
   DEFINE l_fname   STRING   
   DEFINE l_column_name LIKE zta_file.zta01
   DEFINE l_data_type LIKE ztb_file.ztb04
   DEFINE l_nullable  LIKE ztb_file.ztb05
   DEFINE l_flag_1  LIKE type_file.chr1  
   DEFINE l_date    LIKE type_file.dat
   DEFINE li_k                 LIKE type_file.num5
   DEFINE l_err_cnt            LIKE type_file.num5
   DEFINE l_no_b               LIKE pmw_file.pmw01   
   DEFINE l_no_e               LIKE pmw_file.pmw01
   DEFINE l_old_no             LIKE type_file.chr50  
   DEFINE l_old_no_b           LIKE type_file.chr50  
   DEFINE l_old_no_e           LIKE type_file.chr50
   DEFINE lr_err       DYNAMIC ARRAY OF RECORD
               line         STRING,
               key1         STRING,
               err          STRING
                        END RECORD
  DEFINE  m_tempdir   LIKE type_file.chr1000,    
          ss1          LIKE type_file.chr1000,
          m_sf        LIKE type_file.chr1000,
          m_file      LIKE type_file.chr1000,
          l_j         LIKE type_file.num5,
          l_n         LIKE type_file.num5
  DEFINE  g_target    LIKE type_file.chr1000
  DEFINE tok           base.StringTokenizer
  DEFINE ss            STRING 
  DEFINE l_str         DYNAMIC ARRAY OF STRING  
  DEFINE ms_codeset          String  
  DEFINE l_txt1        LIKE type_file.chr1000                   
   
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
   -- l_n=0 if the file is exist;
   -- otherwise there is no such file
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

  #-MOD-AB0097-add-
#   LET l_cmd = "iconv -f UNICODE -t UTF-8 " || g_target CLIPPED || " > " || l_txt1 CLIPPED    #CHI-B50010 mark
#   RUN l_cmd                                                                                  #CHI-B50010 mark

   #CHI-B50010 -- begin --
   LET l_cmd = "cp ",g_target," ",l_txt1
   RUN l_cmd
   LET l_cmd = "ule2utf8 ",l_txt1
   RUN l_cmd
   #CHI-B50010 -- end --
   
   LET l_cmd = "cp -f " || l_txt1 CLIPPED || " " || g_target CLIPPED  
   RUN l_cmd 
   LET l_cmd = " killcr " ||g_target CLIPPED     
   RUN l_cmd   
  #-MOD-AB0097-end-

   LET g_success='Y'                                                          
   CALL channel_r.openFile(g_target,  "r")                                    
   IF STATUS THEN
      CALL cl_err("Can't open file: ", STATUS, 0)
      RETURN
   END IF
   CALL channel_r.setDelimiter("")
   WHILE channel_r.read(ss)
    #LET tok = base.StringTokenizer.create(ss,ASCII 9)              #FUN-D20044 mark
     LET tok = base.StringTokenizer.createExt(ss,ASCII 9,'',TRUE)   #FUN-D20044
     LET l_j=0
     CALL l_str.clear()
     WHILE tok.hasMoreTokens()
       LET l_j=l_j+1
       LET l_str[l_j]=tok.nextToken()
     END WHILE
     LET g_axql.axq00 =' '                        
     LET g_axql.axq01 =' '                         
     LET g_axql.axq02 =' '                         
     LET g_axql.axq03 =' '                         
     LET g_axql.axq04  = l_str[1]
     LET g_axql.axq041 = l_str[2]
     LET g_axql.axq05  = l_str[3]
     LET g_axql.axq06  = l_str[4] 
     LET g_axql.axq07  = l_str[5]
     LET g_axql.axq08  = l_str[6]
     LET g_axql.axq09  = l_str[7]
     LET g_axql.axq10  = l_str[8]
     LET g_axql.axq11  = l_str[9]
     LET g_axql.axq12  = l_str[10]
     LET g_axql.axq13  = l_str[13]  #FUN-960045
     LET g_axql.axq01  = l_str[11]  #FUN-960045
     LET g_axql.axq051 = l_str[12]  #FUN-960045
   
     IF cl_null(g_axql.axq13) THEN LET g_axql.axq13 = ' ' END IF  #FUN-980075 add  
#FUN-9B0017   ---start
     LET g_axql.axq14  = l_str[14]
     LET g_axql.axq15  = l_str[15]
     LET g_axql.axq16  = l_str[16]
     LET g_axql.axq17  = l_str[17]
     IF cl_null(g_axql.axq14) THEN LET g_axql.axq14 = ' ' END IF
     IF cl_null(g_axql.axq15) THEN LET g_axql.axq15 = ' ' END IF
     IF cl_null(g_axql.axq16) THEN LET g_axql.axq16 = ' ' END IF
     IF cl_null(g_axql.axq17) THEN LET g_axql.axq17 = ' ' END IF
     IF cl_null(g_axql.axq18) THEN LET g_axql.axq18=0   END IF
     IF cl_null(g_axql.axq19) THEN LET g_axql.axq19=0   END IF
     IF cl_null(g_axql.axq20) THEN LET g_axql.axq20=0   END IF
     IF cl_null(g_axql.axq21) THEN LET g_axql.axq21=0   END IF
     IF cl_null(g_axql.axq22) THEN LET g_axql.axq22=0   END IF
     IF cl_null(g_axql.axq24) THEN LET g_axql.axq24=' ' END IF
#FUN-9B0017   ---end
#-----------------No.MOD-B90011-----------------------------start
     IF cl_null(g_axql.axq04) AND cl_null(g_axql.axq05) AND
        cl_null(g_axql.axq06) AND cl_null(g_axql.axq07) AND
        cl_null(g_axql.axq12) THEN
        CONTINUE WHILE 
     END IF
#-----------------No.MOD-B90011-----------------------------end

     CALL t003_ins_axq()
       
 
 
   END WHILE
   CALL channel_r.close()
   
   IF g_totsuccess="N" THEN                                                        
      LET g_success="N"                                                           
   END IF  
 
END FUNCTION
 
FUNCTION t003_checkError(p_result,p_msg)
   DEFINE   p_result   SMALLINT
   DEFINE   p_msg      STRING
   DEFINE   ls_msg     STRING
   DEFINE   li_result  SMALLINT
 
   IF p_result THEN
      RETURN
   END IF
   DISPLAY p_msg," DDE ERROR:"
   CALL ui.Interface.frontCall("WINDDE","DDEError",[],[ls_msg])
   DISPLAY ls_msg
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result])
   IF NOT li_result THEN
      DISPLAY "Exit with DDE Error."
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
   EXIT PROGRAM
END FUNCTION
 
#NO.FUN-9C0072 精簡程式碼

#FUN-D20044--
FUNCTION t003_exceldata()  

DEFINE l_gaq03   LIKE gaq_file.gaq03
DEFINE l_str     STRING
DEFINE l_str1    STRING
DEFINE ls_cell   STRING
DEFINE l_err     STRING
DEFINE l_gaq03_s STRING 
DEFINE i         LIKE type_file.num5

DEFINE l_gaq_feld   DYNAMIC ARRAY OF RECORD
        gaq01       LIKE gaq_file.gaq01,
        locate      LIKE gaq_file.gaq01
        END RECORD

   CALL l_gaq_feld.clear()

  #下層公司
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq04'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C1'

  #下層公司帳別
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq041'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C2'

  #科目編號
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq05'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C3'

  #會計年度
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq06'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C4'

  #期別
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq07'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C5'

  #借方金額
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq08'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C6'

  #貸方金額
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq09'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C7'

  #借方筆數
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq10'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C8'

  #貸方筆數
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq11'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C9'

  #幣別
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq12'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C10'

  #集團代號
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq01'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C11'

  #科目名稱
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq051'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C12'

  #關係人代號
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq13'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C13'

  #異動碼5值
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq14'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C14'

  #異動碼6值
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq15'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C15'

  #異動碼7值
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq16'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C16'

  #異動碼8值
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axq17'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C17'

   FOR i = 1 TO l_gaq_feld.getLength()
      SELECT gaq03 INTO l_gaq03 
        FROM gaq_file 
       WHERE gaq01 = l_gaq_feld[i].gaq01
         AND gaq02 = g_lang
      LET l_gaq03_s = l_gaq03       
      LET l_str = l_gaq03_s.trim() 
      LET ls_cell = l_gaq_feld[i].locate
      LET l_str1 = "DDEPoke Sheet1 "CLIPPED,l_gaq_feld[i].locate
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet1,ls_cell,l_str],li_result)
      CALL t003_checkError(li_result,l_str1 )
   END FOR

END FUNCTION
#FUN-D20044--
