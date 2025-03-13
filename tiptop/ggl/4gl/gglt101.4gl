# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: gglt101.4gl
# Descriptions...: 公司科目餘額暫存資料維護作業(非TIPTOP公司)
# Date & Author..: 05/08/15 By Sarah
# Modify.........: No.FUN-580063 05/08/26 By Sarah 程式架構改變
# Modify.........: No.FUN-580064 05/09/07 By Dido 幣別自動帶入;增加彙總
# Modify.........: No.FUN-5A0020 05/10/06 By Sarah 若單身關係人沒有輸入資料,也應給予預設值' '
#                                                  借、貸方金額預設為0
# Modify.........: No.MOD-5A0445 05/11/11 By Smapmin 單身科目改抓ash_file
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
# Modify.........: No.TQC-760205 07/06/29 By Sarah 資料匯入,增加檢核科目編號(asi05)是否存在agli001來源科目(ash04)(show_msg)
# Modify.........: No.MOD-780113 07/08/17 By Sarah 科目編號(asi05)開窗改為開q_ash
# Modify.........: No.MOD-780114 07/08/17 By Sarah 離開單身時判斷借貸方金額,若不平顯示agl-060訊息
# Modify.........: No.FUN-770069 07/08/29 By Sarah 1.INSERT INTO asi_file時,asi00,asi01,asi02,asi03要寫入' '值
#                                                  2.單身刪除的WHERE條件句,asi05,asi13的部份應該用g_aag_t.asi05,g_aag_t.asi13
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.FUN-830144 08/04/08 By lilingyu 改CR報表
# Modify.........: No.FUN-920111 09/05/11 By ve007 asi05開放輸入
# Modify.........: No.FUN-950055 09/05/25 BY ve007 增加excel匯入功能 
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-960408 09/08/18 By destiny 去掉bp里的modify
# Modify.........: NO.FUN-980075 09/08/19 By hongmei 修改匯入問題和程式無法繼續執行問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910001 09/05/20 By hongmei 1.關係人代號開窗時改用q_pmc13
#                                                    2.畫面開放輸入asi01(族群代號),串ash_file時須需增加ash13=asi01
#                                                    3.資料匯入多抓asi01
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: NO.FUN-960045 09/10/29 BY Yiting excel匯入問題
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No:MOD-A30068 10/03/11 By sabrina 改變錯誤訊息顯示方式 
# Modify.........: No:MOD-A40022 10/04/06 By sabrina 無法複製
# Modify.........: No:FUN-9B0017 10/01/26 By chenmoyan 1.將畫面增加四個字段(異動碼5-8碼)
#                                                 2.匯入功能增加處理此四欄
#                                                 3.asi_pk增加asi14,asi15,asi16,
# Modify.........: No:MOD-AB0097 10/11/10 By Dido iconv 語法調整 
# Modify.........: No:TQC-AB0296 10/11/29 By suncx “會計年度”輸入負數無控管
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B50001 11/05/05/ By zhangweib  1.將畫面增加七個字段(asi18~asi24)
#                                                        2.匯入功能增加處理此七欄
# Modify.........: No:CHI-B50010 11/05/19 By JoHung 統一由shell撰寫iconv由UNICODE轉UTF-8語法
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

IMPORT os
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-BB0036
 
DEFINE tm      RECORD
               wc      LIKE type_file.chr1000# Head Where condition   #No.FUN-680098  VARCHAR(500)
               END RECORD,
       g_asi   RECORD
               asi01 	LIKE asi_file.asi01,   #族群代號   #FUN-910001 add
               asi04 	LIKE asi_file.asi04,   #下層公司編號
               asi041	LIKE asi_file.asi041,  #下層帳別
               asi06	LIKE asi_file.asi06,   #年度
               asi07	LIKE asi_file.asi07,   #期別
               asi12	LIKE asi_file.asi12    #幣別
               END RECORD,
       g_asi_t RECORD                          #備分舊值
               asi01 	LIKE asi_file.asi01,   #族群代號   #FUN-910001 add
               asi04 	LIKE asi_file.asi04,   #下層公司編號
               asi041	LIKE asi_file.asi041,  #下層帳別
               asi06	LIKE asi_file.asi06,   #年度
               asi07	LIKE asi_file.asi07,   #期別
               asi12	LIKE asi_file.asi12    #幣別
               END RECORD,
       g_aag   DYNAMIC ARRAY OF RECORD
               asi05	LIKE asi_file.asi05,   #科目編號
               asi051	LIKE asi_file.asi051,   #科目名稱   #MOD-5A0445        #No.FUN-920111
               asi13	LIKE asi_file.asi13,   #關係人代號
               asi08    LIKE asi_file.asi08,   #借方金額
               asi09    LIKE asi_file.asi09    #貸方金額
              ,asi14    LIKE asi_file.asi14,   #異動碼5值#FUN-9B0017           
               asi15    LIKE asi_file.asi15,   #異動碼6值#FUN-9B0017           
               asi16    LIKE asi_file.asi16,   #異動碼7值#FUN-9B0017           
               asi17    LIKE asi_file.asi17    #異動碼8值#FUN-9B0017
              ,asi18    LIKE asi_file.asi18,   #個體本位幣借放金額 #FUN-B50001
               asi19    LIKE asi_file.asi19,   #個體本位幣貸放金額 #FUN-B50001
               asi20    LIKE asi_file.asi20,   #個體本位幣幣別     #FUN-B50001
               asi21    LIKE asi_file.asi21,   #個體功能幣貸放金額 #FUN-B50001
               asi22    LIKE asi_file.asi22,   #個體功能幣貸放金額 #FUN-B50001
               asi23    LIKE asi_file.asi23,   #個體功能幣幣別     #FUN-B50001
               asi24    LIKE asi_file.asi24    #原始公司編碼       #FUN-B50001
               END RECORD,
       g_aag_t RECORD                          #備份舊值
               asi05	LIKE asi_file.asi05,   #科目編號
               asi051	LIKE asi_file.asi051,   #科目名稱   #MOD-5A0445        #No.FUN-920111
               asi13	LIKE asi_file.asi13,   #關係人代號
               asi08    LIKE asi_file.asi08,   #借方金額
               asi09    LIKE asi_file.asi09    #貸方金額
              ,asi14    LIKE asi_file.asi14,   #異動碼5值 #FUN-9B0017           
               asi15    LIKE asi_file.asi15,   #異動碼6值 #FUN-9B0017           
               asi16    LIKE asi_file.asi16,   #異動碼7值 #FUN-9B0017           
               asi17    LIKE asi_file.asi17    #異動碼8值 #FUN-9B0017
              ,asi18    LIKE asi_file.asi18,   #個體本位幣借放金額 #FUN-B50001
               asi19    LIKE asi_file.asi19,   #個體本位幣貸放金額 #FUN-B50001
               asi20    LIKE asi_file.asi20,   #個體本位幣幣別     #FUN-B50001
               asi21    LIKE asi_file.asi21,   #個體功能幣貸放金額 #FUN-B50001
               asi22    LIKE asi_file.asi22,   #個體功能幣貸放金額 #FUN-B50001
               asi23    LIKE asi_file.asi23,   #個體功能幣幣別     #FUN-B50001
               asi24    LIKE asi_file.asi24    #原始公司編碼       #FUN-B50001
               END RECORD,
       g_bookno         LIKE asi_file.asi00,   #INPUT ARGUMENT - 1
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
DEFINE g_sumasi08       LIKE asi_file.asi08          #借方合計  #No.FUN-680098  dec(20,6)   
DEFINE g_sumasi09       LIKE asi_file.asi09          #貸方合計  #No.FUN-680098  dec(20,6) 
#----以下為資料匯入時使用的變數----
DEFINE g_file           STRING                       #來源資料檔名INPUT條件)
DEFINE g_disk           LIKE type_file.chr1          #從C:TIPTOP 上傳?(INPUT條件)  #No.FUN-680098   
DEFINE g_asil           RECORD LIKE asi_file.*
DEFINE g_t003_01        LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(146) 
DEFINE l_table          STRING                       #NO.FUN-830144                                                                 
DEFINE g_str            STRING                       #NO.FUN-830144                                                                 
DEFINE gg_sql           STRING                       #NO.FUN-830144
DEFINE g_azp03          LIKE azp_file.azp03          #FUN-910001 add
DEFINE g_choice         LIKE type_file.chr1          #No.FUN-950055
 
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
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
  
   LET gg_sql = "asi04.asi_file.asi04,",                                                                                            
                "asi041.asi_file.asi041,",                                                                                          
                "asi06.asi_file.asi06,",                                                                                            
                "asi07.asi_file.asi07,",                                                                                            
                "asi12.asi_file.asi12,",                                                                                            
                "asi05.asi_file.asi05,", 
                "asi051.asi_file.asi051,",      #No.FUN-920111                                                                                           
                "asi13.asi_file.asi13,",                                                                                            
                "asi08.asi_file.asi08,",                                                                                            
                "asi09.asi_file.asi09"                                                                                              
   LET l_table = cl_prt_temptable('gglt101',gg_sql) CLIPPED                                                                         
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                        
   LET gg_sql  = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                
                 " VALUES(?,?,?,?,?,?,?,?,?,?)"                                                                                     
   PREPARE insert_prep FROM gg_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',STATUS,1)                                                                                          
      EXIT PROGRAM                                                                                                                  
   END IF                                                                                                                           
 
   LET g_forupd_sql = "SELECT asi04,asi041,asi06,asi07,asi12 FROM asi_file ",
                      " WHERE asi01=? AND asi04=? AND asi041=? ", #FUN-910001 add asi01
                      "   AND asi06=? AND asi07=? AND asi12=? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t003_lock_u CURSOR FROM g_forupd_sql
 
   LET g_bookno = ARG_VAL(1)           #參數值(1) Part#
   SELECT azp03 INTO g_azp03 FROM azp_file WHERE azp01=g_plant   #FUN-910001 add
   
   LET p_row = 1 LET p_col = 1
   OPEN WINDOW t003_w AT p_row,p_col WITH FORM 'ggl/42f/gglt101'
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
 
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
   DEFINE l_asi04 LIKE asi_file.asi04
   DEFINE l_asg05 LIKE asg_file.asg05
 
   CLEAR FORM #清除畫面
   CALL g_aag.clear()
   CALL cl_set_head_visible("","YES")             #No.FUN-6B0029
 
   # 螢幕上取單頭條件
   INITIALIZE g_asi.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON asi01,asi04,asi041,asi06,asi07,asi12  #FUN-910001 add asi01
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(asi01)   #族群代號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_asa1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO asi01
               NEXT FIELD asi01
             WHEN INFIELD(asi04)   #下層公司編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_asg2"   #MOD-740139   #只開非使用TIPTOP的公司
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asi04
                 LET l_asi04 = g_qryparam.multiret
             WHEN INFIELD(asi041)  #帳別開窗
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asi041
                 NEXT FIELD asi041
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
          CALL GET_FLDBUF(asi041) RETURNING g_asi.asi041   
 
       ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   #螢幕上取單身條件
   CONSTRUCT g_wc2 ON asi05,asi13,asi08,asi09
                     ,asi14,asi15,asi16,asi17 #FUN-9B0017
                     ,asi18,asi19,asi20,asi21,asi22,asi23,asi24   #FUN-B50001 Add
             FROM s_asi[1].asi05,s_asi[1].asi13,s_asi[1].asi08,s_asi[1].asi09
                 ,s_asi[1].asi14,s_asi[1].asi15,s_asi[1].asi16,s_asi[1].asi17 #FUN-9B0017
                 ,s_asi[1].asi18,s_asi[1].asi19,s_asi[1].asi20,s_asi[1].asi21,#FUN-B50001 Add
                  s_asi[1].asi22,s_asi[1].asi23,s_asi[1].asi24                #FUN-B50001 Add
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asi05)   #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 IF NOT cl_null(g_asi.asi041) THEN
                    LET g_qryparam.arg1 = g_asi.asi041
                 ELSE
                    LET g_qryparam.arg1 = g_aaz.aaz64   
                 END IF
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asi05
            WHEN INFIELD(asi13)   #關係人代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc13"   #FUN-910001
                 LET g_qryparam.state = "c"
                 LET g_qryparam.plant = g_plant   #No.FUN-980025   
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asi13
#FUN-9B0017   ---start
            WHEN INFIELD(asi14)   #異動碼5值
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form ="q_ahe"                                                                         
                 LET g_qryparam.state = "c"                                                                                         
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO asi14
                 NEXT FIELD asi14
            WHEN INFIELD(asi15)   #異動碼6值  
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form ="q_ahe"                                                                                       
                 LET g_qryparam.state = "c"                                                                                         
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO asi15                                                                               
                 NEXT FIELD asi15                 
            WHEN INFIELD(asi16)   #異動碼7值  
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form ="q_ahe"                                                                                       
                 LET g_qryparam.state = "c"                                                                                         
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO asi16                                                                               
                 NEXT FIELD asi16                 
            WHEN INFIELD(asi17)   #異動碼8值  
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form ="q_ahe"                                                                                       
                 LET g_qryparam.state = "c"                                                                                         
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO asi17                                                                               
                 NEXT FIELD asi17                 
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
      LET g_sql = "SELECT UNIQUE asi01,asi04,asi041,asi06,asi07,asi12 ",   #FUN-910001 add asi01
                  "  FROM asi_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY asi01,asi04,asi041,asi06,asi07,asi12"   #FUN-910001 add asi01
   ELSE                                 # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE asi01,asi04,asi041,asi06,asi07,asi12 ",  #FUN-910001 add asi01
                  "  FROM asi_file ",
                  " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY asi01,asi04,asi041,asi06,asi07,asi12"   #FUN-910001 add asi01
   END IF
   PREPARE t003_prepare FROM g_sql
   DECLARE t003_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR t003_prepare
 
   DROP TABLE x
   LET g_sql_tmp="SELECT UNIQUE asi01,asi04,asi041,asi06,asi07,asi12 ",  #No.TQC-720019   #FUN-910001 add asi01
             "  FROM asi_file ",
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
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t003_a()                            # Add  輸入
   IF s_shut(0) THEN RETURN END IF            #判斷目前系統是否可用
   MESSAGE ""
   CLEAR FORM
   CALL g_aag.clear()
   INITIALIZE g_asi.* LIKE asi_file.*         #DEFAULT 設定
   LET g_sumasi08 = 0
   LET g_sumasi09 = 0
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL t003_i("a")                        # 輸入單頭
 
      IF INT_FLAG THEN                        # 使用者不玩了
         LET g_asi.asi01 = NULL   #FUN-910001 add
         LET g_asi.asi04 = NULL
         LET g_asi.asi041= NULL
         LET g_asi.asi06 = NULL
         LET g_asi.asi07 = NULL
         LET g_asi.asi12 = NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_asi.asi01 IS NULL OR g_asi.asi04 IS NULL OR g_asi.asi041 IS NULL OR   #FUN-910001 add asi01
         g_asi.asi06 IS NULL OR g_asi.asi07 IS NULL OR g_asi.asi12 IS NULL  THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      CALL g_aag.clear()
      LET g_rec_b = 0
 
      CALL t003_b()                           # 輸入單身
 
      SELECT asi06 INTO g_asi.asi06 FROM asi_file
       WHERE asi04=g_asi.asi04 AND asi041=g_asi.asi041
         AND asi06=g_asi.asi06 AND asi07=g_asi.asi07 AND asi12=g_asi.asi12
         AND asi01=g_asi.asi01   #FUN-910001 add
      LET g_asi_t.* = g_asi.*                 #保留舊值
 
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t003_i(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1,               #a:輸入 u:更改        #No.FUN-680098 VARCHAR(1) 
       l_n         LIKE type_file.num5     #FUN-740198 add
 
   DISPLAY BY NAME g_sumasi08,g_sumasi09
   DISPLAY g_asi.* TO asi01,asi04,asi041,asi06,asi07,asi12   #FUN-910001 add asi01
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
   INPUT g_asi.asi01,g_asi.asi04,g_asi.asi041,g_asi.asi06,g_asi.asi07,g_asi.asi12 WITHOUT DEFAULTS  #FUN-910001 add asi01
         FROM asi01,asi04,asi041,asi06,asi07,asi12   #FUN-910001 add asi01
     
      AFTER FIELD asi01
         IF cl_null(g_asi.asi01) THEN
            CALL cl_err(g_asi.asi01,'mfg5103',0)
            NEXT FIELD asi01
         END IF
     
      AFTER FIELD asi04
         IF cl_null(g_asi.asi04) THEN
            CALL cl_err(g_asi.asi04,'mfg5103',0)
            NEXT FIELD asi04
         END IF
         SELECT asg05,asg06 INTO g_asi.asi041,g_asi.asi12
           FROM asg_file
          WHERE asg01 = g_asi.asi04
         IF SQLCA.SQLCODE THEN
            CALL cl_err(g_asi.asi04,'aco-025',0)
            NEXT FIELD asi04
         END IF
         DISPLAY g_asi.asi041 TO asi041
         DISPLAY g_asi.asi12  TO asi12
         #增加公司+帳別的合理性判斷,應存在agli009
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM asg_file
          WHERE asg01=g_asi.asi04 AND asg05=g_asi.asi041 AND asg04='N'   #MOD-740139 add asg04='N'
         IF l_n = 0 THEN
            CALL cl_err(g_asi.asi04,'agl-948',0)   #MOD-740139 modify
            NEXT FIELD asi04
         END IF
 
      AFTER FIELD asi041
         IF cl_null(g_asi.asi041) THEN
            CALL cl_err(g_asi.asi041,'mfg5103',0)
            NEXT FIELD asi041
         END IF
         #增加公司+帳別的合理性判斷,應存在agli009
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM asg_file
          WHERE asg01=g_asi.asi04 AND asg05=g_asi.asi041 AND asg04='N'   #MOD-740139 add asg04='N'
         IF l_n = 0 THEN
            CALL cl_err(g_asi.asi041,'agl-948',0)   #MOD-740139 modify
            NEXT FIELD asi041
         END IF

      #TQC-AB0296 modify---beatk-------------------------
      AFTER FIELD asi06
         IF NOT cl_null(g_asi.asi06) THEN
            IF g_asi.asi06 < 0 THEN
               CALL cl_err(g_asi.asi06,'apj-035',0)
              LET g_asi.asi06 = g_asi_t.asi06
              NEXT FIELD asi06
            END IF
         END IF
      #TQC-AB0296 modify----end--------------------------
 
      AFTER FIELD asi07
         IF NOT cl_null(g_asi.asi07) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_asi.asi06
            IF g_azm.azm02 = 1 THEN
               IF g_asi.asi07 > 12 OR g_asi.asi07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD asi07
               END IF
            ELSE
               IF g_asi.asi07 > 13 OR g_asi.asi07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD asi07
               END IF
            END IF
         END IF
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(asi01)   #族群代號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_asa1"
                LET g_qryparam.default1 = g_asi.asi01
                CALL cl_create_qry() RETURNING g_asi.asi01
                DISPLAY g_asi.asi01 TO asi01
                NEXT FIELD asi01
           WHEN INFIELD(asi04)   #下層公司編號
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_asg2"   #MOD-740139   #只開非使用TIPTOP的公司
                LET g_qryparam.default1 = g_asi.asi04
                CALL cl_create_qry() RETURNING g_asi.asi04
                DISPLAY g_asi.asi04 TO asi04
                NEXT FIELD asi04
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
 
   IF cl_null(g_asi.asi01) AND cl_null(g_asi.asi04) AND cl_null(g_asi.asi041) AND  #FUN-910001 add asi01
      cl_null(g_asi.asi06) AND cl_null(g_asi.asi07) AND cl_null(g_asi.asi12) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT asi01,asi04,asi041,asi06,asi07,asi12 INTO g_asi.*   #FUN-910001 add asi01
     FROM asi_file
    WHERE asi04=g_asi.asi04 AND asa041=g_asi.asi041
      AND asa06=g_asi.asi06 AND asa07=g_asi.asi07 AND asa12=g_asi.asi12
      AND asi01=g_asi.asi01   #FUN-910001 add
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_asi_t.asi01 = g_asi.asi01   #FUN-910001 add
   LET g_asi_t.asi04 = g_asi.asi04
   LET g_asi_t.asi041= g_asi.asi041
   LET g_asi_t.asi06 = g_asi.asi06
   LET g_asi_t.asi07 = g_asi.asi07
   LET g_asi_t.asi12 = g_asi.asi12
   BEGIN WORK
 
   OPEN t003_lock_u USING g_asi.asi01,g_asi.asi04,g_asi.asi041,  #FUN-910001 add asi01
                          g_asi.asi06,g_asi.asi07,g_asi.asi12
   IF STATUS THEN
      CALL cl_err("OPEN t003_lock_u:", STATUS, 1)  
      CLOSE t003_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t003_lock_u INTO g_asi.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t003_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t003_show()
 
   WHILE TRUE
      LET g_asi_t.asi01 = g_asi.asi01   #FUN-910001 add
      LET g_asi_t.asi04 = g_asi.asi04
      LET g_asi_t.asi041= g_asi.asi041
      LET g_asi_t.asi06 = g_asi.asi06
      LET g_asi_t.asi07 = g_asi.asi07
      LET g_asi_t.asi12 = g_asi.asi12
 
      CALL t003_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL t003_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE asi_file SET asi04 = g_asi.asi04,
                          asi041= g_asi.asi041,
                          asi06 = g_asi.asi06,
                          asi07 = g_asi.asi07,
                          asi12 = g_asi.asi12,
                          asimodu = g_user,
                          asidate = g_today,
                          asi01 = g_asi.asi01   #FUN-910001 add
       WHERE asi04 = g_asi_t.asi04
         AND asi041= g_asi_t.asi041
         AND asi06 = g_asi_t.asi06
         AND asi07 = g_asi_t.asi07
         AND asi12 = g_asi_t.asi12
         AND asi01 = g_asi_t.asi01   #FUN-910001 add
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","asi_file",g_asi_t.asi04,g_asi_t.asi041,SQLCA.sqlcode,"","asi",1)  #No.FUN-660123
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
    INITIALIZE g_asi.* TO NULL             #No.FUN-6B0040
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
      WHEN 'N' FETCH NEXT     t003_cs INTO g_asi.asi01,g_asi.asi04,g_asi.asi041,   #FUN-910001 add asi01
                                           g_asi.asi06,g_asi.asi07,g_asi.asi12
      WHEN 'P' FETCH PREVIOUS t003_cs INTO g_asi.asi01,g_asi.asi04,g_asi.asi041,   #FUN-910001 add asi01
                                           g_asi.asi06,g_asi.asi07,g_asi.asi12
      WHEN 'F' FETCH FIRST    t003_cs INTO g_asi.asi01,g_asi.asi04,g_asi.asi041,   #FUN-910001 add asi01
                                           g_asi.asi06,g_asi.asi07,g_asi.asi12
      WHEN 'L' FETCH LAST     t003_cs INTO g_asi.asi01,g_asi.asi04,g_asi.asi041,   #FUN-910001 add asi01
                                           g_asi.asi06,g_asi.asi07,g_asi.asi12
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
            FETCH ABSOLUTE g_jump t003_cs INTO g_asi.asi01,g_asi.asi04,g_asi.asi041,   #FUN-910001 add asi01
                                               g_asi.asi06,g_asi.asi07,g_asi.asi12
            LET mi_no_ask = FALSE    #No.FUN-6A0061
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_asi.* TO NULL  #TQC-6B0105
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
 
   DISPLAY g_asi.asi01,g_asi.asi04,g_asi.asi041,  #FUN-910001 add asi01
           g_asi.asi06,g_asi.asi07,g_asi.asi12
        TO asi01,asi04,asi041,asi06,asi07,asi12   #FUN-910001 add asi01
   CALL t003_b_fill(g_wc2) #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION t003_r()
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_asi.asi01) AND cl_null(g_asi.asi04) AND cl_null(g_asi.asi041) AND   #FUN-910001 add asi01
      cl_null(g_asi.asi06) AND cl_null(g_asi.asi07) AND cl_null(g_asi.asi12) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
 
   IF cl_delh(15,16) THEN
      DELETE FROM asi_file WHERE asi04=g_asi.asi04 AND asi041=g_asi.asi041
                             AND asi06=g_asi.asi06 AND asi07=g_asi.asi07
                             AND asi12=g_asi.asi12
                             AND asi01=g_asi.asi01   #FUN-910001 add
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","asi_file",g_asi.asi04,g_asi.asi041,SQLCA.sqlcode,"","",1)  #No.FUN-660123
      ELSE
         CLEAR FORM
         CALL g_aag.clear()
         DROP TABLE x                        #No.TQC-720019
         PREPARE t003_pre_y2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE t003_pre_y2                 #No.TQC-720019
         OPEN t003_count
         FETCH t003_count INTO g_row_count
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
  ,l_azi04_t       LIKE azi_file.azi04       #金額取位小數位數    #FUN-B50001 add
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   IF cl_null(g_asi.asi01) AND cl_null(g_asi.asi04) AND cl_null(g_asi.asi041) AND   #FUN-910001 add asi01
      cl_null(g_asi.asi06) AND cl_null(g_asi.asi07) AND cl_null(g_asi.asi12) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_forupd_sql =
       "SELECT asi05,asi051,asi13,asi08,asi09,asi14,asi15,asi16,asi17 FROM asi_file ",  #NO.FUN-920111 #FUN-9B0017 add asi14-asi17 
       " WHERE asi01=? AND asi04=? AND asi041=? AND asi06=? AND asi07=? AND asi12=? ",   #FUN-910001 add asi01
       "   AND asi05=? AND asi13=? AND asi14=? AND asi15=? AND asi16=? AND asi17=? AND asi24 = ? ",       #FUN-9B0017 add asi14-asi17    #FUN-B50001 add asi24
       " FOR UPDATE"   #MOD-6B0164
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t003_bcl CURSOR FROM g_forupd_sql     # LOCK CURSOR
 
   #取得下層公司幣別金額取位小數位數
   SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=g_asi.asi12   
   IF cl_null(l_azi04) THEN LET l_azi04 = 0 END IF
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_aag WITHOUT DEFAULTS FROM s_asi.*
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
              OPEN t003_bcl USING g_asi.asi01,g_asi.asi04,g_asi.asi041,   #FUN-910001 add asi01
                                  g_asi.asi06,g_asi.asi07,g_asi.asi12,
                                  g_aag_t.asi05,g_aag_t.asi13   #MOD-6B0164
                                 ,g_aag_t.asi14,g_aag_t.asi15,   #FUN-9B0017
                                  g_aag_t.asi16,g_aag_t.asi17    #FUN-9B0017
                                 ,g_aag_t.asi24                  #FUN-B50001
                                  
              IF STATUS THEN
                 CALL cl_err("OPEN t003_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t003_bcl INTO g_aag[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_aag_t.asi05,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_aag[l_ac].* TO NULL      #900423
           LET g_aag[l_ac].asi08 = 0
           LET g_aag[l_ac].asi09 = 0
           LET g_aag_t.* = g_aag[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD asi05
 
       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              INITIALIZE g_aag[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_aag[l_ac].* TO s_asi.*
              CALL g_aag.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_aag[l_ac].asi13) THEN
              LET g_aag[l_ac].asi13 = ' '
           END IF
           IF cl_null(g_aag[l_ac].asi08) THEN
              LET g_aag[l_ac].asi08 = 0
           END IF
           IF cl_null(g_aag[l_ac].asi09) THEN
              LET g_aag[l_ac].asi09 = 0
           END IF
           #FUN-B50001--add--str--
           IF cl_null(g_aag[l_ac].asi24) THEN
              LET g_aag[l_ac].asi24 = ' '
           END IF
           #FUN-B50001--add--end
           INSERT INTO asi_file(asi00,asi01,asi02,asi03,   #FUN-770069 mod
                                asi04,asi041,asi06,asi07,asi12,
                                 asi05,asi051,asi13,asi08,asi09,           #No.FUN-920111
                                asiuser,asigrup,asimodu,asidate,asilegal,asioriu,asiorig, #FUN-980003 add asilegal
                               #asi14,asi15,asi16,asi17) #FUN-9B0017  #FUN-B50001 Mark
                                asi14,asi15,asi16,asi17,asi18,asi19,asi20,asi21,asi22,asi23,asi24) #FUN-B50001 Add
                         VALUES(' ',g_asi.asi01,' ',' ',           #FUN-770069 mod   #FUN-910001 mod
                                g_asi.asi04,g_asi.asi041,g_asi.asi06,
                                g_asi.asi07,g_asi.asi12,g_aag[l_ac].asi05,g_aag[l_ac].asi051,   #No.FUN-920111
                                g_aag[l_ac].asi13,g_aag[l_ac].asi08,
                                g_aag[l_ac].asi09,g_user,g_grup,g_user,g_today,g_legal, g_user, g_grup,  #FUN-980003 add g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
                                g_aag[l_ac].asi14,g_aag[l_ac].asi15, #FUN-9B0017
                               #g_aag[l_ac].asi16,g_aag[l_ac].asi17) #FUN-9B0017    #FUN-B50001 Mark
                                g_aag[l_ac].asi16,g_aag[l_ac].asi17,g_aag[l_ac].asi18,g_aag[l_ac].asi19,  #FUN-B50001 Add
                                g_aag[l_ac].asi20,g_aag[l_ac].asi21,g_aag[l_ac].asi22,g_aag[l_ac].asi23,  #FUN-B50001 Add
                                g_aag[l_ac].asi24)                                                        #FUN-B50001 Add

           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","asi_file",g_asi.asi04,g_asi.asi041,SQLCA.sqlcode,"","",1)  #No.FUN-660123
              CANCEL INSERT
           ELSE
              LET g_rec_b = g_rec_b + 1
              DISPLAY g_rec_b TO FORMONLY.cn2
              CALL t003_upamt()
              MESSAGE 'INSERT O.K'
           END IF
 
       AFTER FIELD asi13
           IF cl_null(g_aag[l_ac].asi13) THEN
              LET g_aag[l_ac].asi13 = ' '
           END IF
           IF g_aag_t.asi13 IS NULL OR g_aag_t.asi05 IS NULL OR
             (g_aag[l_ac].asi05 != g_aag_t.asi05) OR
             (g_aag[l_ac].asi13 != g_aag_t.asi13) THEN
              SELECT COUNT(*) INTO l_n
                FROM asi_file
               WHERE asi04=g_asi.asi04 AND asi041=g_asi.asi041
                 AND asi06=g_asi.asi06 AND asi07=g_asi.asi07
                 AND asi12=g_asi.asi12 AND asi05=g_aag[l_ac].asi05
                 AND asi13=g_aag[l_ac].asi13
                 AND asi01=g_asi.asi01    #FUN-910001 add
                 AND asi14=g_aag[l_ac].asi14  #FUN-9B0017
                 AND asi15=g_aag[l_ac].asi15  #FUN-9B0017
                 AND asi16=g_aag[l_ac].asi16  #FUN-9B0017
                 AND asi17=g_aag[l_ac].asi17  #FUN-9B0017
              IF l_n > 0 THEN
                 CALL cl_err('',-239,0)
                 NEXT FIELD asi13
              END IF
           END IF
 
#FUN-9B0017   ---start
       AFTER FIELD asi14	
          IF cl_null(g_aag[l_ac].asi14) THEN	
             LET g_aag[l_ac].asi14 = ' '
          END IF	
          IF g_aag_t.asi14 IS NULL OR g_aag_t.asi05 IS NULL OR	
            (g_aag[l_ac].asi05 != g_aag_t.asi05) OR	
            (g_aag[l_ac].asi14 != g_aag_t.asi14) THEN	
             SELECT COUNT(*) INTO l_n	
               FROM asi_file	
              WHERE asi04=g_asi.asi04 AND asi041=g_asi.asi041	
                AND asi06=g_asi.asi06 AND asi07=g_asi.asi07	
                AND asi12=g_asi.asi12 AND asi05=g_aag[l_ac].asi05	
                AND asi13=g_aag[l_ac].asi13	
                AND asi14=g_aag[l_ac].asi14	
                AND asi15=g_aag[l_ac].asi15	
                AND asi16=g_aag[l_ac].asi16	
                AND asi17=g_aag[l_ac].asi17                	
                AND asi01=g_asi.asi01    	
             IF l_n > 0 THEN	
                CALL cl_err('',-239,0)	
                NEXT FIELD asi14	
             END IF	
          END IF	
	
       AFTER FIELD asi15	
          IF cl_null(g_aag[l_ac].asi15) THEN	
             LET g_aag[l_ac].asi15 = ' '
          END IF	
          IF g_aag_t.asi15 IS NULL OR g_aag_t.asi05 IS NULL OR	
            (g_aag[l_ac].asi05 != g_aag_t.asi05) OR	
            (g_aag[l_ac].asi15 != g_aag_t.asi15) THEN	
             SELECT COUNT(*) INTO l_n	
               FROM asi_file	
              WHERE asi04=g_asi.asi04 AND asi041=g_asi.asi041	
                AND asi06=g_asi.asi06 AND asi07=g_asi.asi07	
                AND asi12=g_asi.asi12 AND asi05=g_aag[l_ac].asi05	
                AND asi13=g_aag[l_ac].asi13	
                AND asi14=g_aag[l_ac].asi14	
                AND asi15=g_aag[l_ac].asi15	
                AND asi16=g_aag[l_ac].asi16	
                AND asi17=g_aag[l_ac].asi17                	
                AND asi01=g_asi.asi01    	
             IF l_n > 0 THEN	
                CALL cl_err('',-239,0)	
                NEXT FIELD asi15	
             END IF	
          END IF	
	
       AFTER FIELD asi16	
          IF cl_null(g_aag[l_ac].asi16) THEN	
             LET g_aag[l_ac].asi16 = ' '
          END IF	
          IF g_aag_t.asi16 IS NULL OR g_aag_t.asi05 IS NULL OR	
            (g_aag[l_ac].asi05 != g_aag_t.asi05) OR	
            (g_aag[l_ac].asi14 != g_aag_t.asi14) THEN	
             SELECT COUNT(*) INTO l_n	
               FROM asi_file	
              WHERE asi04=g_asi.asi04 AND asi041=g_asi.asi041	
                AND asi06=g_asi.asi06 AND asi07=g_asi.asi07	
                AND asi12=g_asi.asi12 AND asi05=g_aag[l_ac].asi05	
                AND asi13=g_aag[l_ac].asi13	
                AND asi14=g_aag[l_ac].asi14	
                AND asi15=g_aag[l_ac].asi15	
                AND asi16=g_aag[l_ac].asi16	
                AND asi17=g_aag[l_ac].asi17                	
                AND asi01=g_asi.asi01    	
             IF l_n > 0 THEN	
                CALL cl_err('',-239,0)	
                NEXT FIELD asi16	
             END IF	
          END IF	
	
       AFTER FIELD asi17	
          IF cl_null(g_aag[l_ac].asi17) THEN	
             LET g_aag[l_ac].asi17 = ' '
          END IF	
          IF g_aag_t.asi17 IS NULL OR g_aag_t.asi05 IS NULL OR	
            (g_aag[l_ac].asi05 != g_aag_t.asi05) OR	
            (g_aag[l_ac].asi17 != g_aag_t.asi17) THEN	
             SELECT COUNT(*) INTO l_n	
               FROM asi_file	
              WHERE asi04=g_asi.asi04 AND asi041=g_asi.asi041	
                AND asi06=g_asi.asi06 AND asi07=g_asi.asi07	
                AND asi12=g_asi.asi12 AND asi05=g_aag[l_ac].asi05	
                AND asi13=g_aag[l_ac].asi13	
                AND asi14=g_aag[l_ac].asi14	
                AND asi15=g_aag[l_ac].asi15	
                AND asi16=g_aag[l_ac].asi16	
                AND asi17=g_aag[l_ac].asi17                	
                AND asi01=g_asi.asi01    	
             IF l_n > 0 THEN	
                CALL cl_err('',-239,0)	
                NEXT FIELD asi17	
             END IF	
          END IF	
#FUN-9B0017   ---end
#FUN-B50001   ---start
       AFTER FIELD asi18
          IF NOT cl_null(g_aag[l_ac].asi18) AND NOT cl_null(g_aag[l_ac].asi20) THEN 
              SELECT azi04 INTO l_azi04_t FROM azi04 WHERE azi01 = g_aag[l_ac].asi20
              IF cl_null(l_azi04) THEN LET l_azi04 = 0 END IF
              CALL cl_digcut(g_aag[l_ac].asi18,l_azi04_t)
                   RETURNING g_aag[l_ac].asi18
          END IF

       AFTER FIELD asi19
          IF NOT cl_null(g_aag[l_ac].asi19) AND NOT cl_null(g_aag[l_ac].asi20) THEN 
              SELECT azi04 INTO l_azi04_t FROM azi04 WHERE azi01 = g_aag[l_ac].asi20
              IF cl_null(l_azi04) THEN LET l_azi04 = 0 END IF
              CALL cl_digcut(g_aag[l_ac].asi19,l_azi04_t)
                   RETURNING g_aag[l_ac].asi19
          END IF

       AFTER FIELD asi20
          IF NOT cl_null(g_aag[l_ac].asi20) THEN
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM azi_file WHERE azi01 = g_aag[l_ac].asi20
              IF l_n < 1 THEN
                 CALL cl_err(g_aag[l_ac].asi20,'odb-002',0)
                 NEXT FIELD asi20
              END IF
          END IF

       AFTER FIELD asi21
          IF NOT cl_null(g_aag[l_ac].asi21) AND NOT cl_null(g_aag[l_ac].asi20) THEN 
              SELECT azi04 INTO l_azi04_t FROM azi04 WHERE azi01 = g_aag[l_ac].asi20
              IF cl_null(l_azi04) THEN LET l_azi04 = 0 END IF
              CALL cl_digcut(g_aag[l_ac].asi21,l_azi04_t)
                   RETURNING g_aag[l_ac].asi21
          END IF

       AFTER FIELD asi22
          IF NOT cl_null(g_aag[l_ac].asi22) AND NOT cl_null(g_aag[l_ac].asi20) THEN 
              SELECT azi04 INTO l_azi04_t FROM azi04 WHERE azi01 = g_aag[l_ac].asi20
              IF cl_null(l_azi04) THEN LET l_azi04 = 0 END IF
              CALL cl_digcut(g_aag[l_ac].asi22,l_azi04_t)
                   RETURNING g_aag[l_ac].asi22
          END IF

       AFTER FIELD asi23
          IF NOT cl_null(g_aag[l_ac].asi23) THEN
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM azi_file WHERE azi01 = g_aag[l_ac].asi23 
              IF l_n < 1 THEN
                 CALL cl_err(g_aag[l_ac].asi23,'odb-002',0)
                 NEXT FIELD asi23
              END IF
          END IF

       AFTER FIELD asi24
          IF NOT cl_null(g_aag[l_ac].asi24) THEN
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM asg_file
               WHERE asg01=g_aag[l_ac].asi24
              IF l_n = 0 THEN
                 CALL cl_err(g_aag[l_ac].asi24,'agl-948',0)  
                 NEXT FIELD asi24
              END IF
          END IF
#FUN-B50001   ---end
       #增加借貸方金額取位
       AFTER FIELD asi08
           IF NOT cl_null(g_aag[l_ac].asi08) THEN
              CALL cl_digcut(g_aag[l_ac].asi08,l_azi04) 
                   RETURNING g_aag[l_ac].asi08
              DISPLAY BY NAME g_aag[l_ac].asi08
           END IF
 
       AFTER FIELD asi09
           IF NOT cl_null(g_aag[l_ac].asi09) THEN
              CALL cl_digcut(g_aag[l_ac].asi09,l_azi04) 
                   RETURNING g_aag[l_ac].asi09
              DISPLAY BY NAME g_aag[l_ac].asi09
           END IF
 
       BEFORE DELETE                            #是否取消單身
           IF g_aag_t.asi05 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
 
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
 
              DELETE FROM asi_file
               WHERE asi04=g_asi.asi04   AND asi041=g_asi.asi041
                 AND asi06=g_asi.asi06   AND asi07=g_asi.asi07
                 AND asi12=g_asi.asi12   
                 AND asi05=g_aag_t.asi05 AND asi13=g_aag_t.asi13   #FUN-770069 mod
                 AND asi01=g_asi.asi01    #FUN-910001 add
                 AND asi14=g_aag_t.asi14 AND asi15=g_aag_t.asi15 #FUN-9B0017
                 AND asi16=g_aag_t.asi16 AND asi17=g_aag_t.asi17 #FUN-9B0017
                 AND asi24=g_aag_t.asi24    #FUN-B50001
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","asi_file",g_asi.asi04,g_asi.asi041,SQLCA.sqlcode,"","",1)  #No.FUN-660123
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
              CALL cl_err(g_aag[l_ac].asi05,-263,1)
              LET g_aag[l_ac].* = g_aag_t.*
           ELSE
              UPDATE asi_file SET asi05 = g_aag[l_ac].asi05,
                                  asi051 = g_aag[l_ac].asi051,   #No.FUN-920111
                                  asi13 = g_aag[l_ac].asi13,
                                  asi08 = g_aag[l_ac].asi08,
                                  asi09 = g_aag[l_ac].asi09,
                                  asimodu = g_user,
                                  asidate = g_today
                                 ,asi14 = g_aag[l_ac].asi14, #FUN-9B0017
                                  asi15 = g_aag[l_ac].asi15, #FUN-9B0017
                                  asi16 = g_aag[l_ac].asi16, #FUN-9B0017
                                  asi17 = g_aag[l_ac].asi17  #FUN-9B0017
                                 ,asi18 = g_aag[l_ac].asi18, #FUN-B50001
                                  asi19 = g_aag[l_ac].asi19, #FUN-B50001
                                  asi20 = g_aag[l_ac].asi20, #FUN-B50001
                                  asi21 = g_aag[l_ac].asi21, #FUN-B50001
                                  asi22 = g_aag[l_ac].asi22, #FUN-B50001
                                  asi23 = g_aag[l_ac].asi23, #FUN-B50001
                                  asi24 = g_aag[l_ac].asi24  #FUN-B50001
               WHERE asi04=g_asi.asi04 AND asi041=g_asi.asi041
                 AND asi06=g_asi.asi06 AND asi07=g_asi.asi07
                 AND asi12=g_asi.asi12 AND asi05=g_aag_t.asi05
                 AND asi13=g_aag_t.asi13
                 AND asi01=g_asi.asi01    #FUN-910001 add
                 AND asi14=g_aag_t.asi14 AND asi15=g_aag_t.asi15 #FUN-9B0017
                 AND asi16=g_aag_t.asi16 AND asi17=g_aag_t.asi17 #FUN-9B0017
                 AND asi24=g_aag_t.asi24     #FUN-B50001
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","asi_file",g_asi.asi04,g_asi.asi041,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                 LET g_aag[l_ac].* = g_aag_t.*
              ELSE
                 CALL t003_upamt()
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
       AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac      #FUN-D30032 Mark
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_aag[l_ac].* = g_aag_t.*
              #FUN-D30032--add--str--
              ELSE
                 CALL g_aag.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end-- 
              END IF
              CLOSE t003_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D30032 Add
           CLOSE t003_bcl
           COMMIT WORK
 
           CALL g_aag.deleteElement(g_rec_b+1)
 
       AFTER INPUT
           CALL t003_upamt()
           IF g_sumasi08 != g_sumasi09 THEN
              CALL cl_err('','agl-060',1)
           END IF
 
       #增加一ACTION提供開窗"客戶資料"(關係人=Y)
       ON ACTION occ_controlp
          CASE
             WHEN INFIELD(asi13)   #關係人代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_occ92"
                  LET g_qryparam.default1 = g_aag[l_ac].asi13
                  CALL cl_create_qry() RETURNING g_aag[l_ac].asi13
                  DISPLAY g_aag[l_ac].asi13 TO asi13
                  NEXT FIELD asi13
             OTHERWISE EXIT CASE
          END CASE
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(asi05) AND l_ac > 1 THEN
             LET g_aag[l_ac].* = g_aag[l_ac-1].*
             NEXT FIELD asi05
          END IF
 
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(asi13)   #關係人代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pmc13"   #FUN-910001 
                  LET g_qryparam.plant = g_plant   #No.FUN-980025   
                  LET g_qryparam.default1 = g_aag[l_ac].asi13
                  CALL cl_create_qry() RETURNING g_aag[l_ac].asi13
                  DISPLAY g_aag[l_ac].asi13 TO asi13
                  NEXT FIELD asi13
#FUN-9B0017   ---start                                                                                                  
             WHEN INFIELD(asi14)   #異動碼5值
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form ="q_ahe"                                                                                      
                  LET g_qryparam.default1 = g_aag[l_ac].asi14                                                                       
                  CALL cl_create_qry() RETURNING g_aag[l_ac].asi14                                                                  
                  DISPLAY g_aag[l_ac].asi14 TO asi14                                                                                
                  NEXT FIELD asi14                
             WHEN INFIELD(asi15)   #異動碼6值  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form ="q_ahe"                                                                                      
                  LET g_qryparam.default1 = g_aag[l_ac].asi15                                                                       
                  CALL cl_create_qry() RETURNING g_aag[l_ac].asi15                                                                  
                  DISPLAY g_aag[l_ac].asi15 TO asi15                                                                                
                  NEXT FIELD asi15      
             WHEN INFIELD(asi16)   #異動碼7值  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form ="q_ahe"                                                                                      
                  LET g_qryparam.default1 = g_aag[l_ac].asi16                                                                       
                  CALL cl_create_qry() RETURNING g_aag[l_ac].asi16                                                                  
                  DISPLAY g_aag[l_ac].asi16 TO asi16                                                                                
                  NEXT FIELD asi16                                                                                                  
             WHEN INFIELD(asi17)   #異動碼8值  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form ="q_ahe"                                                                                      
                  LET g_qryparam.default1 = g_aag[l_ac].asi17                                                                       
                  CALL cl_create_qry() RETURNING g_aag[l_ac].asi17                                                                  
                  DISPLAY g_aag[l_ac].asi17 TO asi17                                                                                
                  NEXT FIELD asi17          
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
 
  #LET l_sql = "SELECT asi05,asi051,asi13,asi08,asi09,asi14,asi15,asi16,asi17 FROM asi_file ",    #No.FUN-920111 #FUN-9B0017 add asi14-asi17 #FUN-B50001 Mark
   LET l_sql = "SELECT asi05,asi051,asi13,asi08,asi09,asi14,asi15,asi16,asi17, ",     #FUN-B50001 Add
               "       asi18,asi19,asi20,asi21,asi22,asi23,asi24 ",                   #FUN-B50001 Add
               "  FROM asi_file ",                                                    #FUN-B50001 Add
               " WHERE asi04 ='",g_asi.asi04,"'",
               "   AND asi041='",g_asi.asi041,"'",
               "   AND asi06 ='",g_asi.asi06,"'",
               "   AND asi07 ='",g_asi.asi07,"'",
               "   AND asi12 ='",g_asi.asi12,"'",
               "   AND asi01 ='",g_asi.asi01,"'",   #FUN-910001 add
               "   AND ",p_wc CLIPPED,
               " ORDER BY asi05"
 
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
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN                                    #此判斷用於單身放棄新增時，
   END IF                                       #指標要停留在未新增前的行數
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)    #將確定、放棄隱藏起來
   DISPLAY ARRAY g_aag TO s_asi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)        #將確定、放棄顯示出來
END FUNCTION
 
FUNCTION t003_upamt()
   DEFINE l_asi08  LIKE asi_file.asi08,        #No.FUN-680098   dec(20,6)
          l_asi09  LIKE asi_file.asi09         #No.FUN-680098   dec(20,6)
 
   #-->借方合計
   SELECT SUM(asi08) INTO l_asi08
     FROM asi_file
    WHERE asi04 = g_asi.asi04 AND asi041 = g_asi.asi041
      AND asi06 = g_asi.asi06 AND asi07 = g_asi.asi07
      AND asi12 = g_asi.asi12
      AND asi01 = g_asi.asi01         #FUN-910001 add
      IF SQLCA.sqlcode THEN LET l_asi08 = 0 END IF
   #-->貸方合計
   SELECT SUM(asi09) INTO l_asi09
     FROM asi_file
    WHERE asi04 = g_asi.asi04 AND asi041 = g_asi.asi041
      AND asi06 = g_asi.asi06 AND asi07 = g_asi.asi07
      AND asi12 = g_asi.asi12
      AND asi01 = g_asi.asi01         #FUN-910001 add
      IF SQLCA.sqlcode THEN LET l_asi09 = 0 END IF
 
   IF cl_null(l_asi08) THEN LET l_asi08 = 0 END IF
   IF cl_null(l_asi09) THEN LET l_asi09 = 0 END IF
 
   LET g_sumasi08 = l_asi08
   LET g_sumasi09 = l_asi09
 
   DISPLAY g_sumasi08 TO FORMONLY.sumasi08
   DISPLAY g_sumasi09 TO FORMONLY.sumasi09
END FUNCTION
 
FUNCTION t003_copy()
   DEFINE l_asi                 RECORD LIKE asi_file.*,
          l_asi01_o,l_asi01_n   LIKE asi_file.asi01,    #FUN-910001 add
          l_asi04_o,l_asi04_n   LIKE asi_file.asi04,
          l_asi041_o,l_asi041_n LIKE asi_file.asi041,
          l_asi06_o,l_asi06_n   LIKE asi_file.asi06,
          l_asi07_o,l_asi07_n   LIKE asi_file.asi07,
          l_asi12_o,l_asi12_n   LIKE asi_file.asi12
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_asi.asi01 IS NULL AND g_asi.asi04 IS NULL AND g_asi.asi041 IS NULL AND  #FUN-910001 add asi01
      g_asi.asi06 IS NULL AND g_asi.asi07 IS NULL AND g_asi.asi12 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET l_asi06_n = ''
   LET l_asi07_n = ''
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INPUT l_asi01_n,l_asi04_n,l_asi041_n,l_asi06_n,l_asi07_n,l_asi12_n WITHOUT DEFAULTS  #FUN-910001 add asi01_n
         FROM asi01,asi04,asi041,asi06,asi07,asi12   #FUN-910001 add asi01
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asi01)   #族群代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_asa1"
                 LET g_qryparam.default1 = g_asi.asi01
                 CALL cl_create_qry() RETURNING l_asi01_n
                 DISPLAY l_asi01_n TO asi01
                 NEXT FIELD asi01
            WHEN INFIELD(asi04)   #下層公司編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_asg2"   #MOD-740139   #只開非使用TIPTOP的公司
                 LET g_qryparam.default1 = g_asi.asi04
                 CALL cl_create_qry() RETURNING l_asi04_n
                 DISPLAY l_asi04_n TO asi04
                 NEXT FIELD asi04
            WHEN INFIELD(asi12)   #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_asi.asi12
                 CALL cl_create_qry() RETURNING l_asi12_n
                 DISPLAY l_asi12_n TO asi12
                 NEXT FIELD asi12
         END CASE

     #MOD-A40022---add---start---
      AFTER FIELD asi04
         IF cl_null(l_asi04_n) THEN
            CALL cl_err(l_asi04_n,'mfg5103',0)
            NEXT FIELD asi04
         END IF
         SELECT asg05,asg06 INTO l_asi041_n,l_asi12_n
           FROM asg_file
          WHERE asg01 = l_asi04_n
         IF SQLCA.SQLCODE THEN
            CALL cl_err(l_asi04_n,'aco-025',0)
            NEXT FIELD asi04
         END IF
         DISPLAY l_asi041_n TO asi041
         DISPLAY l_asi12_n  TO asi12
     #MOD-A40022---add---end---
 
      AFTER FIELD asi12
         IF NOT cl_null(l_asi12_n) THEN
            SELECT count(*) INTO g_cnt FROM asi_file
             WHERE asi04=l_asi04_n AND asi041=l_asi041_n
               AND asi06=l_asi06_n AND asi07=l_asi07_n
               AND asi12=l_asi12_n
               AND asi01=l_asi01_n   #FUN-910001 add
            IF g_cnt > 0 THEN
               CALL cl_err(l_asi12_n,-239,0)
               NEXT FIELD asi12
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
      DISPLAY g_asi.asi01,g_asi.asi04,g_asi.asi041,  #FUN-910001 add asi01
              g_asi.asi06,g_asi.asi07,g_asi.asi12
           TO asi01,asi04,asi041,asi06,asi07,asi12   #FUN-910001 add asi01
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM asi_file         #單身複製
    WHERE asi04=g_asi.asi04 AND asi041=g_asi.asi041 AND asi06=g_asi.asi06
      AND asi07=g_asi.asi07 AND asi12=g_asi.asi12
      AND asi01=g_asi.asi01   #FUN-910001 add
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_asi.asi04,g_asi.asi041,SQLCA.sqlcode,"","",1)  #No.FUN-660123
      RETURN
   END IF
 
   UPDATE x
      SET asi04 =l_asi04_n,
          asi041=l_asi041_n,
          asi06 =l_asi06_n,
          asi07 =l_asi07_n,
          asi12 =l_asi12_n,
          asi01 =l_asi01_n   #FUN-910001 add
 
   INSERT INTO asi_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","asi_file",l_asi04_n,l_asi041_n,SQLCA.sqlcode,"","asi:",1)  #No.FUN-660123
      RETURN
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_asi04_n,') O.K'
   
   LET l_asi01_o = g_asi.asi01   #FUN-910001 add
   LET l_asi04_o = g_asi.asi04
   LET l_asi041_o= g_asi.asi041
   LET l_asi06_o = g_asi.asi06
   LET l_asi07_o = g_asi.asi07
   LET l_asi12_o = g_asi.asi12
   LET g_asi.asi01 =l_asi01_n    #FUN-910001 add
   LET g_asi.asi04 =l_asi04_n
   LET g_asi.asi041=l_asi041_n
   LET g_asi.asi06 =l_asi06_n
   LET g_asi.asi07 =l_asi07_n
   LET g_asi.asi12 =l_asi12_n
 
   CALL t003_b()
   #FUN-C80046---begin
   #LET g_asi.asi01 =l_asi01_o    #FUN-910001 add
   #LET g_asi.asi04 =l_asi04_o
   #LET g_asi.asi041=l_asi041_o
   #LET g_asi.asi06 =l_asi06_o
   #LET g_asi.asi07 =l_asi07_o
   #LET g_asi.asi12 =l_asi12_o
   #CALL t003_show()
   #FUN-C80046---end
END FUNCTION
 
FUNCTION t003_dataload()    #資料匯入
   DEFINE l_asg02 LIKE asg_file.asg02
 
   OPEN WINDOW t003_l_w AT p_row,p_col
     WITH FORM "ggl/42f/gglt101_l" ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("gglt101_l")
 
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
 
      ON ACTION CONTROLZ
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
      INITIALIZE g_asil.* TO NULL  #MOD-520054
      LET g_asil.asi00 =' '                          #TQC-760205 add
      LET g_asil.asi01 =' '                          #TQC-760205 add
      LET g_asil.asi02 =' '                          #TQC-760205 add
      LET g_asil.asi03 =' '                          #TQC-760205 add
      LET g_asil.asi04 =g_t003_01[1,10] CLIPPED      #下層公司編號 
      LET g_asil.asi041=g_t003_01[11,20] CLIPPED     #下層帳號     
      LET g_asil.asi05 =g_t003_01[21,44] CLIPPED     #科目編號     
      LET g_asil.asi06 =g_t003_01[45,49]             #會計年度     
      LET g_asil.asi07 =g_t003_01[50,54]             #期別         
      LET g_asil.asi08 =g_t003_01[55,75]             #借方金額     
      LET g_asil.asi09 =g_t003_01[76,96]             #貸方金額     
      LET g_asil.asi10 =g_t003_01[97,106]            #借方筆數     
      LET g_asil.asi11 =g_t003_01[107,116]           #貸方筆數    
      LET g_asil.asi12 =g_t003_01[117,120] CLIPPED   #幣別        
      LET g_asil.asi13 =g_t003_01[121,130] CLIPPED   #關係人代號
      LET g_asil.asi01 =g_t003_01[131,140] CLIPPED   #族群代號   #FUN-910001 add 
      LET g_asil.asi051 = g_t003_01[141,221] CLIPPED             #No.FUN-920111  
#FUN-9B0017   ---start
      LET g_asil.asi14 =g_t003_01[222,232] CLIPPED
      LET g_asil.asi15 =g_t003_01[233,243] CLIPPED
      LET g_asil.asi16 =g_t003_01[244,254] CLIPPED
      LET g_asil.asi17 =g_t003_01[255,265] CLIPPED
#FUN-9B0017   ---end
#FUN-B50001   ---start
      LET g_asil.asi18 =g_t003_01[266,276] CLIPPED
      LET g_asil.asi19 =g_t003_01[277,287] CLIPPED
      LET g_asil.asi20 =g_t003_01[288,298] CLIPPED
      LET g_asil.asi21 =g_t003_01[299,309] CLIPPED
      LET g_asil.asi22 =g_t003_01[310,320] CLIPPED
      LET g_asil.asi23 =g_t003_01[321,331] CLIPPED
      LET g_asil.asi24 =g_t003_01[332,342] CLIPPED
#FUN-B50001   ---end
 
      CALL t003_ins_asi()
   END FOREACH
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
 END IF                    #No.FUN-950055
END FUNCTION
 
FUNCTION t003_ins_asi()
   SELECT * FROM asi_file
    WHERE asi01=g_asil.asi01 AND asi02=g_asil.asi02   AND asi03=g_asil.asi03
      AND asi04=g_asil.asi04 AND asi041=g_asil.asi041 AND asi05=g_asil.asi05
      AND asi06=g_asil.asi06 AND asi07=g_asil.asi07   AND asi00=g_asil.asi00
      AND asi12=g_asil.asi12 AND asi13=g_asil.asi13   #FUN-980075 add asi13
      AND asi14=g_asil.asi14 AND asi15=g_asil.asi15   #FUN-9B0017
      AND asi16=g_asil.asi16 AND asi17=g_asil.asi17   #FUN-9B0017
      AND asi24=g_asil.asi24   #FUN-B50001
   IF STATUS THEN
      LET g_asil.asiacti='Y'
      LET g_asil.asiuser=g_user
      LET g_asil.asigrup=g_grup
      LET g_asil.asidate=g_today
      LET g_asil.asilegal=g_legal #FUN-980003 add g_legal
 
      IF cl_null(g_asil.asi01)  THEN
         LET g_asil.asi01=' '
      END IF
 
      LET g_asil.asioriu = g_user      #No.FUN-980030 10/01/04
      LET g_asil.asiorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO asi_file VALUES (g_asil.*)
      IF STATUS THEN
         LET g_showmsg=g_asil.asi01,"/",g_asil.asi02,"/",g_asil.asi03,"/",g_asil.asi04,"/",
                       g_asil.asi041,"/",g_asil.asi05,"/",g_asil.asi06,"/",g_asil.asi07,"/",
                       g_asil.asi00,"/",g_asil.asi12,"/",g_asil.asi13
         CALL s_errmsg('asi01,asi02,asi03,asi04,asi041,asi05,asi06,asi07
                        ,asi00,asi12,asi13',g_showmsg,'ins asi_file',STATUS,1)    #MOD-A30068 0 modify 1
      END IF
   END IF
END FUNCTION
 
FUNCTION t003_out()
   DEFINE
      l_i             LIKE type_file.num5,          #No.FUN-680098 smallint
      l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
      l_asi  RECORD
              asi04   LIKE asi_file.asi04,
              asi041  LIKE asi_file.asi041,
              asi06   LIKE asi_file.asi06,
              asi07   LIKE asi_file.asi07,
              asi12   LIKE asi_file.asi12,
              asi05   LIKE asi_file.asi05,
              asi051  LIKE asi_file.asi051,            #No.FUN-920111
              asi13   LIKE asi_file.asi13,
              asi08   LIKE asi_file.asi08,
              asi09   LIKE asi_file.asi09
             END RECORD
 
    CALL cl_del_data(l_table)                                                                                                        
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'gglt101'
  
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno AND aaf02 = g_lang
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 239 END IF
 
    LET g_sql="SELECT asi04,asi041,asi06,asi07,asi12,asi05,asi051,asi13,asi08,asi09 ",    #No.FUN-920111
             " FROM asi_file ",    #MOD-5A0445
             " WHERE ",g_wc CLIPPED,    #MOD-5A0445
             "   AND ",g_wc2 CLIPPED
   PREPARE t003_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE t003_co CURSOR FOR t003_p1
 
 
   FOREACH t003_co INTO l_asi.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      EXECUTE insert_prep USING                                                                                                     
           l_asi.asi04,l_asi.asi041,l_asi.asi06,l_asi.asi07,                                                                        
           l_asi.asi12,l_asi.asi05,l_asi.asi051,l_asi.asi13,                          #No.FUN-920111                                                                       
           l_asi.asi08,l_asi.asi09 
      
   END FOREACH
   LET gg_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
 
   IF g_zz05 = 'Y' THEN                                                                                                             
      CALL cl_wcchp(g_wc,'asi01,asi04,asi041,asi06,asi07,asi12')   #FUN-910001 mod                                                                          
           RETURNING g_wc                                                                                                           
   ELSE                                                                                                                             
      LET g_wc = ""                                                                                                             
   END IF                                                                                                                           
 
   LET g_str = g_wc                                                                                                                 
   CALL cl_prt_cs3('gglt101','gglt101',gg_sql,g_str) 
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

   #CHI-B50010 -- beatk --
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
     LET tok = base.StringTokenizer.create(ss,ASCII 9)
     LET l_j=0
     CALL l_str.clear()
     WHILE tok.hasMoreTokens()
       LET l_j=l_j+1
       LET l_str[l_j]=tok.nextToken()
     END WHILE
#FUN-B50001   ---start   Mark
#    LET g_asil.asi00 =' '                        
#    LET g_asil.asi01 =' '                         
#    LET g_asil.asi02 =' '                         
#    LET g_asil.asi03 =' '                         
#    LET g_asil.asi04  = l_str[1]
#    LET g_asil.asi041 = l_str[2]
#    LET g_asil.asi05  = l_str[3]
#    LET g_asil.asi06  = l_str[4] 
#    LET g_asil.asi07  = l_str[5]
#    LET g_asil.asi08  = l_str[6]
#    LET g_asil.asi09  = l_str[7]
#    LET g_asil.asi10  = l_str[8]
#    LET g_asil.asi11  = l_str[9]
#    LET g_asil.asi12  = l_str[10]
#    LET g_asil.asi13  = l_str[13]  #FUN-960045
#    LET g_asil.asi01  = l_str[11]  #FUN-960045
#    LET g_asil.asi051 = l_str[12]  #FUN-960045
#  
#    IF cl_null(g_asil.asi13) THEN LET g_asil.asi13 = ' ' END IF  #FUN-980075 add  
##FUN-9B0017   ---start
#    LET g_asil.asi14  = l_str[14]
#    LET g_asil.asi15  = l_str[15]
#    LET g_asil.asi16  = l_str[16]
#    LET g_asil.asi17  = l_str[17]
#    IF cl_null(g_asil.asi14) THEN LET g_asil.asi14 = ' ' END IF
#    IF cl_null(g_asil.asi15) THEN LET g_asil.asi15 = ' ' END IF
#    IF cl_null(g_asil.asi16) THEN LET g_asil.asi16 = ' ' END IF
#    IF cl_null(g_asil.asi17) THEN LET g_asil.asi17 = ' ' END IF
##FUN-9B0017   ---end
#FUN-B50001   ---end   Mark
#FUN-B50001   ---start
     LET g_asil.asi00 = l_str[1]
     LET g_asil.asi01 = l_str[2]
     LET g_asil.asi02 = l_str[3]
     LET g_asil.asi03 = l_str[4]
     LET g_asil.asi04  = l_str[5]
     LET g_asil.asi041 = l_str[6]
     LET g_asil.asi05  = l_str[7]
     LET g_asil.asi051 = l_str[23]
     LET g_asil.asilegal = l_str[24]
     LET g_asil.asi06  = l_str[8]
     LET g_asil.asi07  = l_str[9]
     LET g_asil.asi08  = l_str[10]
     LET g_asil.asi09  = l_str[11]
     LET g_asil.asi10  = l_str[12]
     LET g_asil.asi11  = l_str[13]
     IF cl_null(g_asil.asi13) THEN LET g_asil.asi13 = ' ' END IF
     LET g_asil.asi12  = l_str[14]
     LET g_asil.asi13  = l_str[15]
     LET g_asil.asi14  = l_str[27]
     LET g_asil.asi15  = l_str[28]
     LET g_asil.asi16  = l_str[29]
     LET g_asil.asi17  = l_str[30]
     IF cl_null(g_asil.asi14) THEN LET g_asil.asi14 = ' ' END IF
     IF cl_null(g_asil.asi15) THEN LET g_asil.asi15 = ' ' END IF
     IF cl_null(g_asil.asi16) THEN LET g_asil.asi16 = ' ' END IF
     IF cl_null(g_asil.asi17) THEN LET g_asil.asi17 = ' ' END IF
     LET g_asil.asi18  = l_str[31]
     LET g_asil.asi19  = l_str[32]
     LET g_asil.asi20  = l_str[33]
     LET g_asil.asi21  = l_str[34]
     LET g_asil.asi22  = l_str[35]
     LET g_asil.asi23  = l_str[36]
     LET g_asil.asi24  = l_str[37]
#FUN-B50001   ---end
     CALL t003_ins_asi()
       
 
 
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
