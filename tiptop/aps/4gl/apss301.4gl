# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apss301.4gl
# Descriptions...: APS INI Config(系統參數檔)
# Date & Author..: FUN-7C0002 2008/03/12 By Mandy #FUN-830024
# Modify.........: FUN-840209 2008/05/21 BY DUKE
# Modify.........: FUN-860060 2008/06/23 by duke add vlz71,vlz72
# Modify.........: FUN-870153 2008/07/30 by duke 隱藏 vlz60並將其資料來源預設為 sma_file.sma917
# Modify.........: FUN-880010 2008/08/07 BY duke 輸入APS版本時,CHECK資料庫編號及APS版本是否存在於vzy_file 且vzy10='Y'
# Modify.........: TQC-8A0053 2008/10/20 By Mandy vlz03 要show時,分
# Modify.........: FUN-8C0008 2008/12/03 By Duke add新開製令單別,新開採購令單別,版本自動確認
# Modify.........: FUN-910005 2009/01/06 by duke add 無法則工單是否繼承法則 0:否  1:是
# Modify.........: CHI-930015 2009/03/06 by duke APS版本及儲存版本均改為可開窗單選
# Modify.........: TQC-940126 2009/04/24 BY DUKE 調整畫面欄位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: FUN-B50003 11/05/03 By Abby---GP5.25 追版---str------------------------------
# Modify.........: FUN-930127 2009/03/27 By Duke 加入各項aps需求欄位
# Modify.........: TQC-950076 2009/05/13 By Duke 隱藏vlz44並設固定值 1
# Modify.........: FUN-990093 2009/09/30 By Mandy 新增時,新開製令單別預設:儲存版本-M;新開採購令單別預設:儲存版本-P
# Modify.........: FUN-A80051 2010/08/10 By Mandy apss301刪除時需判斷此儲存版本尚未有apsp400 的資料才可進行刪除(where vlz01=vld01 and vlz02=vld02)
# Modify.........: FUN-B50003 11/05/03 By Abby---GP5.25 追版---end------------------------------
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: FUN-B90038 11/09/05 By Abby (1)產能page,製令排序方式[vlz58]/訂單排序方式[vlz59] 隱藏
#                                              (2)供給page增加欄位==>安全庫存模式0:優先滿足 1:最後滿足
#                                              (3)apss301將畫面中的欄位[舊料採購令排除vlz43]隱藏
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#TQC-8A0053--mod---str---
#DEFINE g_vlz       RECORD LIKE vlz_file.*,   #FUN-7C0002 #FUN-830024
#       g_vlz_t     RECORD LIKE vlz_file.*,  #備份舊值
DEFINE g_vlz   RECORD
                 vlz01        LIKE vlz_file.vlz01,
                 vlz02        LIKE vlz_file.vlz02,  
                 vlz03        DATETIME YEAR TO MINUTE,
                 vlz04        LIKE vlz_file.vlz04,    
                 vlz05        LIKE vlz_file.vlz05,   
                 vlz06        LIKE vlz_file.vlz06,  
                 vlz07        LIKE vlz_file.vlz07,  
                 vlz08        LIKE vlz_file.vlz08,  
                 vlz09        LIKE vlz_file.vlz09,  
                 vlz10        LIKE vlz_file.vlz10,  
                 vlz11        LIKE vlz_file.vlz11,  
                 vlz12        LIKE vlz_file.vlz12,  
                 vlz13        LIKE vlz_file.vlz13,  
                 vlz14        LIKE vlz_file.vlz14,  
                 vlz15        LIKE vlz_file.vlz15,  
                 vlz16        LIKE vlz_file.vlz16,  
                 vlz17        LIKE vlz_file.vlz17,  
                 vlz18        LIKE vlz_file.vlz18,  
                 vlz19        LIKE vlz_file.vlz19,  
                 vlz20        LIKE vlz_file.vlz20,  
                 vlz21        LIKE vlz_file.vlz21,  
                 vlz22        LIKE vlz_file.vlz22,  
                 vlz23        LIKE vlz_file.vlz23,  
                 vlz24        LIKE vlz_file.vlz24,  
                 vlz25        LIKE vlz_file.vlz25,  
                 vlz26        LIKE vlz_file.vlz26,  
                 vlz27        LIKE vlz_file.vlz27,  
                 vlz28        LIKE vlz_file.vlz28,  
                 vlz29        LIKE vlz_file.vlz29,  
                 vlz30        LIKE vlz_file.vlz30,  
                 vlz31        LIKE vlz_file.vlz31,  
                 vlz32        LIKE vlz_file.vlz32,  
                 vlz33        LIKE vlz_file.vlz33,  
                 vlz34        LIKE vlz_file.vlz34,  
                 vlz35        LIKE vlz_file.vlz35,  
                 vlz36        LIKE vlz_file.vlz36,  
                 vlz37        LIKE vlz_file.vlz37,  
                 vlz38        LIKE vlz_file.vlz38,  
                 vlz39        LIKE vlz_file.vlz39,  
                 vlz40        LIKE vlz_file.vlz40,  
                 vlz41        LIKE vlz_file.vlz41,  
                 vlz42        LIKE vlz_file.vlz42,  
                 vlz43        LIKE vlz_file.vlz43,  
                 vlz44        LIKE vlz_file.vlz44,  
                 vlz45        LIKE vlz_file.vlz45,  
                 vlz46        LIKE vlz_file.vlz46,  
                 vlz47        LIKE vlz_file.vlz47,  
                 vlz48        LIKE vlz_file.vlz48,  
                 vlz49        LIKE vlz_file.vlz49,  
                 vlz50        LIKE vlz_file.vlz50,  
                 vlz51        LIKE vlz_file.vlz51,  
                 vlz52        LIKE vlz_file.vlz52,  
                 vlz53        LIKE vlz_file.vlz53,  
                 vlz54        LIKE vlz_file.vlz54,  
                 vlz55        LIKE vlz_file.vlz55,  
                 vlz56        LIKE vlz_file.vlz56,  
                 vlz57        LIKE vlz_file.vlz57,  
                 vlz58        LIKE vlz_file.vlz58,  
                 vlz59        LIKE vlz_file.vlz59,  
                 vlz60        LIKE vlz_file.vlz60,  
                 vlz61        LIKE vlz_file.vlz61,  
                 vlz62        LIKE vlz_file.vlz62,  
                 vlz63        LIKE vlz_file.vlz63,  
                 vlz64        LIKE vlz_file.vlz64,  
                 vlz65        LIKE vlz_file.vlz65,  
                 vlz66        LIKE vlz_file.vlz66,  
                 vlz67        LIKE vlz_file.vlz67,  
                 vlz68        LIKE vlz_file.vlz68,  
                 vlz69        LIKE vlz_file.vlz69,  
                 vlz70        LIKE vlz_file.vlz70,  
                 vlz71        LIKE vlz_file.vlz71,  
                 vlz72        LIKE vlz_file.vlz72,  
                 vlz56b       LIKE vlz_file.vlz56b,  
                 vlz57b       LIKE vlz_file.vlz57b,
                 vlz73        LIKE vlz_file.vlz73,   #FUN-8C0008 ADD
                 vlz74        LIKE vlz_file.vlz74,   #FUN-8C0008 ADD
                 vlz75        LIKE vlz_file.vlz75,    #FUN-8C0008 ADD
                 vlz76        LIKE vlz_file.vlz76,    #FUN-910005 ADD
                 vlz77        LIKE vlz_file.vlz77,    #FUN-930127 ADD
                 vlz78        LIKE vlz_file.vlz78,    #FUN-930127 ADD
                 vlz79        LIKE vlz_file.vlz79,    #FUN-930127 ADD
                 vlz80        LIKE vlz_file.vlz80,    #FUN-930127 ADD
                 vlz81        LIKE vlz_file.vlz81,    #FUN-930127 ADD
                 vlz82        LIKE vlz_file.vlz82,    #FUN-930127 ADD
                 vlz83        LIKE vlz_file.vlz83,    #FUN-930127 ADD
                 vlzlegal     LIKE vlz_file.vlzlegal, #FUN-B50003 add
                 vlzplant     LIKE vlz_file.vlzplant, #FUN-B50003 add
                 vlz84        LIKE vlz_file.vlz84     #FUN-B90038 ADD
               END RECORD
DEFINE g_vlz_t RECORD
                 vlz01        LIKE vlz_file.vlz01,
                 vlz02        LIKE vlz_file.vlz02,  
                 vlz03        DATETIME YEAR TO MINUTE,
                 vlz04        LIKE vlz_file.vlz04,    
                 vlz05        LIKE vlz_file.vlz05,   
                 vlz06        LIKE vlz_file.vlz06,  
                 vlz07        LIKE vlz_file.vlz07,  
                 vlz08        LIKE vlz_file.vlz08,  
                 vlz09        LIKE vlz_file.vlz09,  
                 vlz10        LIKE vlz_file.vlz10,  
                 vlz11        LIKE vlz_file.vlz11,  
                 vlz12        LIKE vlz_file.vlz12,  
                 vlz13        LIKE vlz_file.vlz13,  
                 vlz14        LIKE vlz_file.vlz14,  
                 vlz15        LIKE vlz_file.vlz15,  
                 vlz16        LIKE vlz_file.vlz16,  
                 vlz17        LIKE vlz_file.vlz17,  
                 vlz18        LIKE vlz_file.vlz18,  
                 vlz19        LIKE vlz_file.vlz19,  
                 vlz20        LIKE vlz_file.vlz20,  
                 vlz21        LIKE vlz_file.vlz21,  
                 vlz22        LIKE vlz_file.vlz22,  
                 vlz23        LIKE vlz_file.vlz23,  
                 vlz24        LIKE vlz_file.vlz24,  
                 vlz25        LIKE vlz_file.vlz25,  
                 vlz26        LIKE vlz_file.vlz26,  
                 vlz27        LIKE vlz_file.vlz27,  
                 vlz28        LIKE vlz_file.vlz28,  
                 vlz29        LIKE vlz_file.vlz29,  
                 vlz30        LIKE vlz_file.vlz30,  
                 vlz31        LIKE vlz_file.vlz31,  
                 vlz32        LIKE vlz_file.vlz32,  
                 vlz33        LIKE vlz_file.vlz33,  
                 vlz34        LIKE vlz_file.vlz34,  
                 vlz35        LIKE vlz_file.vlz35,  
                 vlz36        LIKE vlz_file.vlz36,  
                 vlz37        LIKE vlz_file.vlz37,  
                 vlz38        LIKE vlz_file.vlz38,  
                 vlz39        LIKE vlz_file.vlz39,  
                 vlz40        LIKE vlz_file.vlz40,  
                 vlz41        LIKE vlz_file.vlz41,  
                 vlz42        LIKE vlz_file.vlz42,  
                 vlz43        LIKE vlz_file.vlz43,  
                 vlz44        LIKE vlz_file.vlz44,  
                 vlz45        LIKE vlz_file.vlz45,  
                 vlz46        LIKE vlz_file.vlz46,  
                 vlz47        LIKE vlz_file.vlz47,  
                 vlz48        LIKE vlz_file.vlz48,  
                 vlz49        LIKE vlz_file.vlz49,  
                 vlz50        LIKE vlz_file.vlz50,  
                 vlz51        LIKE vlz_file.vlz51,  
                 vlz52        LIKE vlz_file.vlz52,  
                 vlz53        LIKE vlz_file.vlz53,  
                 vlz54        LIKE vlz_file.vlz54,  
                 vlz55        LIKE vlz_file.vlz55,  
                 vlz56        LIKE vlz_file.vlz56,  
                 vlz57        LIKE vlz_file.vlz57,  
                 vlz58        LIKE vlz_file.vlz58,  
                 vlz59        LIKE vlz_file.vlz59,  
                 vlz60        LIKE vlz_file.vlz60,  
                 vlz61        LIKE vlz_file.vlz61,  
                 vlz62        LIKE vlz_file.vlz62,  
                 vlz63        LIKE vlz_file.vlz63,  
                 vlz64        LIKE vlz_file.vlz64,  
                 vlz65        LIKE vlz_file.vlz65,  
                 vlz66        LIKE vlz_file.vlz66,  
                 vlz67        LIKE vlz_file.vlz67,  
                 vlz68        LIKE vlz_file.vlz68,  
                 vlz69        LIKE vlz_file.vlz69,  
                 vlz70        LIKE vlz_file.vlz70,  
                 vlz71        LIKE vlz_file.vlz71,  
                 vlz72        LIKE vlz_file.vlz72,  
                 vlz56b       LIKE vlz_file.vlz56b,  
                 vlz57b       LIKE vlz_file.vlz57b,
                 vlz73        LIKE vlz_file.vlz73,   #FUN-8C0008 ADD
                 vlz74        LIKE vlz_file.vlz74,   #FUN-8C0008 ADD
                 vlz75        LIKE vlz_file.vlz75,    #FUN-8C0008 ADD
                 vlz76        LIKE vlz_file.vlz76,    #FUN-910005 ADD
                 vlz77        LIKE vlz_file.vlz77,    #FUN-930127 ADD
                 vlz78        LIKE vlz_file.vlz78,    #FUN-930127 ADD
                 vlz79        LIKE vlz_file.vlz79,    #FUN-930127 ADD
                 vlz80        LIKE vlz_file.vlz80,    #FUN-930127 ADD
                 vlz81        LIKE vlz_file.vlz81,    #FUN-930127 ADD
                 vlz82        LIKE vlz_file.vlz82,    #FUN-930127 ADD
                 vlz83        LIKE vlz_file.vlz83,    #FUN-930127 ADD
                 vlzlegal     LIKE vlz_file.vlzlegal, #FUN-B50003 add
                 vlzplant     LIKE vlz_file.vlzplant, #FUN-B50003 add
                 vlz84        LIKE vlz_file.vlz84     #FUN-B90038 ADD
               END RECORD,    
#TQC-8A0053--mod---end---
       g_vlz01_t   LIKE vlz_file.vlz01,     #Key值備份
       g_vlz02_t   LIKE vlz_file.vlz02,     #Key值備份
       g_wc        STRING,                  #儲存 user 的查詢條件  
       g_sql       STRING                   #組 sql 用    
 
DEFINE g_forupd_sql          STRING         
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令        
DEFINE g_cnt                 LIKE type_file.num10         
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose        
DEFINE g_msg                 LIKE type_file.chr1000       
DEFINE g_curs_index          LIKE type_file.num10         
DEFINE g_row_count           LIKE type_file.num10         #總筆數        
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        
DEFINE mi_no_ask             LIKE type_file.num5          #是否開啟指定筆視窗        
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   INITIALIZE g_vlz.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM vlz_file WHERE vlz01=? AND vlz02=? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s301_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW s301_w AT p_row,p_col WITH FORM "aps/42f/apss301"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
 
   LET g_action_choice = ""
   CALL s301_menu()
 
   CLOSE WINDOW s301_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION s301_curs()
DEFINE ls      STRING
 
    CLEAR FORM
    INITIALIZE g_vlz.* TO NULL      
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
       #基本資料-----------------------
       #TQC-940126  MARK   --STR-- 
       #vlz01,vlz02,vlz03,vlz70,
       #vlz05,vlz06,vlz07,vlz08,vlz66,
       #vlz04,vlz09,vlz10,vlz11,vlz67,
       #vlz73, vlz74, vlz75,       #FUN-8C0008 ADD
       #TQC-940126  MARK   --END--  
 
       #TQC-940126  ADD    --STR--
        vlz01,vlz02,vlz03,vlz70,
        vlz66,vlz10,vlz11,vlz67,
        vlz73, vlz74, vlz75,       
       #TQC-940126  ADD    --END--
        vlz78, vlz83,                    #FUN-930127 ADD 
 
       #供給---------------------------
       #TQC-940126  MARK   --STR--
       #      vlz12,vlz13,vlz14,vlz15,vlz16,vlz17,vlz18,vlz19,vlz20,
       #vlz21,vlz22,vlz23,vlz24,vlz25,vlz26,vlz27,vlz28,vlz29,vlz30,vlz31,
       #      vlz32,vlz33,vlz34,vlz35,vlz36,vlz37,vlz38,vlz39,vlz40,
       #vlz41,vlz42,vlz43,vlz44,vlz45,vlz46,vlz47,vlz48,vlz49,vlz50,
       #vlz71,   #FUN-860060 add
       #vlz76,   #FUN-910005 add
       #TQC-940126  MARK  --END--
 
       #TQC-940126  ADD   --STR--
        vlz13,vlz14,vlz15,vlz17,vlz22,vlz23,vlz35,vlz36,
        vlz40,vlz41,vlz42,vlz43,vlz44,vlz50,vlz71,vlz76,
       #TQC-940126  ADD   --END--
        vlz77,vlz79,vlz80,vlz81,  #FUN-930127 ADD
        vlz84,                    #FUN-B90038
 
       #產能---------------------------
       #TQC-940126  MARK  --STR-- 
       ## vlz51,vlz52,vlz53,vlz54,vlz55,vlz56,vlz57,vlz58,vlz59,  #FUN-860060 mark
       #  vlz51,vlz52,vlz53,vlz54,vlz55,vlz56b,vlz57b,vlz58,vlz59,  #FUN-860060 add
       # vlz60,vlz61,vlz62,vlz63,vlz64,vlz65,vlz66,vlz67,vlz68,vlz69
       #TQC-940126  MARK  --END--
 
       #TQC-940126  ADD   --STR--
        vlz51,vlz52,vlz53,vlz54,vlz55,vlz56b,vlz57b,vlz58,vlz59,  
        vlz61,vlz62,vlz63,vlz64,vlz65,vlz68,vlz69,vlz72,
       #TQC-940126  ADD   --END-- 
        vlz82   #FUN-930127 ADD
 
        BEFORE CONSTRUCT
               CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(vlz01)
                CALL cl_init_qry_var()
               # LET g_qryparam.form = "q_vzy02"    #FUN-840209 MARK
                LET g_qryparam.form = "q_vlz01"    #FUN-840209
               # LET g_qryparam.state = "c"        #CHI-930015 MARK
                LET g_qryparam.default1 = g_vlz.vlz01
                LET g_qryparam.arg1 = g_plant CLIPPED
               # CALL cl_create_qry() RETURNING g_qryparam.multiret  #CHI-930015 MARK
               # DISPLAY g_qryparam.multiret TO vlz01  #CHI-930015 MARK
                CALL cl_create_qry() RETURNING g_vlz.vlz01,g_vlz.vlz02  #CHI-930015 ADD
                DISPLAY BY NAME g_vlz.vlz01,g_vlz.vlz02                 #CHI-930015 ADD
                NEXT FIELD vlz01
 
 
              WHEN INFIELD(vlz70)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_msp01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_vlz.vlz70
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO vlz70
                 NEXT FIELD vlz70
 
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
 
       ON ACTION qbe_select
         CALL cl_qbe_select()
       ON ACTION qbe_save
         CALL cl_qbe_save()
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   ##資料權限的檢查
   #IF g_priv2='4' THEN                           #只能使用自己的資料
   #    LET g_wc = g_wc clipped," AND vlzuser = '",g_user,"'"
   #END IF
   #IF g_priv3='4' THEN                           #只能使用相同群的資料
   #    LET g_wc = g_wc clipped," AND vlzgrup MATCHES '",
   #               g_grup CLIPPED,"*'"
   #END IF
 
   #IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #    LET g_wc = g_wc clipped," AND vlzgrup IN ",cl_chk_tgrup_list()
   #END IF
 
    LET g_sql="SELECT vlz01,vlz02 FROM vlz_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY vlz01,vlz02"
    PREPARE s301_prepare FROM g_sql
    DECLARE s301_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR s301_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM vlz_file WHERE ",g_wc CLIPPED
    PREPARE s301_precount FROM g_sql
    DECLARE s301_count CURSOR FOR s301_precount
END FUNCTION
 
FUNCTION s301_menu()
   DEFINE l_gae02 LIKE gae_file.gae02
   DEFINE l_gaq03 LIKE gaq_file.gaq03
   DEFINE l_cmd  LIKE type_file.chr1000      
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           CALL cl_set_comp_visible("vlz56,vlz57,vlz60",FALSE)  #FUN-860060  
           CALL cl_set_comp_visible("vlz44",FALSE)              #TQC-950076 ADD
           CALL cl_set_comp_visible("vlz43,vlz58,vlz59",FALSE)  #FUN-B90038 add
 
        #TQC-940126 MARK  --STR-----------------------------------------------------------------
        ##FUN-840209----ADD---begin--
        # CALL cl_set_comp_visible("vlz04,vlz05,vlz06,vlz07,vlz08,vlz12,vlz16,vlz18",FALSE)
        # CALL cl_set_comp_visible("vlz20,vlz21,vlz24,vlz25,vlz27,vlz28,vlz29,vlz30",FALSE)
        # CALL cl_set_comp_visible("vlz31,vlz32,vlz33,vlz34,vlz37,vlz38,vlz39,vlz45",FALSE)
        # CALL cl_set_comp_visible("vlz46,vlz47,vlz48,vlz49,vlz26,vlz09,vlz19",FALSE)
        ##FUN-840209----ADD---end----
        #TQC-940126 MARK  --END-----------------------------------------------------------------  
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL s301_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL s301_q()
            END IF
        ON ACTION next
            CALL s301_fetch('N')
        ON ACTION previous
            CALL s301_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL s301_u()
            END IF
       #ON ACTION invalid
       #    LET g_action_choice="invalid"
       #    IF cl_chk_act_auth() THEN
       #         CALL s301_x()
       #    END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL s301_r()
            END IF
      #ON ACTION upd_gae
      #   LET g_action_choice="upd_gae"
      #   DECLARE upd_gae_cs CURSOR  FOR 
      #      SELECT gae02 from gae_file
      #       WHERE gae01 = 'apss301'
      #         AND gae03 = '0'
      #         AND gae12 = 'std'
      #         AND gae02 LIKE 'vlz%'
      #      ORDER BY gae01,gae02
      #   LET l_gae02 = ''
      #   LET l_gaq03 = ''
      #   FOREACH upd_gae_cs INTO l_gae02
      #      LET l_gaq03 = ''
      #      SELECT gaq03 INTO l_gaq03 FROM gaq_file
      #       WHERE gaq01 = l_gae02
      #         AND gaq02 = '0'
      #      IF NOT cl_null(l_gaq03) THEN
      #         UPDATE gae_file
      #            SET gae04 = l_gaq03
      #         WHERE gae01 = 'apss301'
      #           AND gae03 = '0'
      #           AND gae12 = 'std'
      #           AND gae02 = l_gae02
      #      END IF
      #   END FOREACH 
 
      #ON ACTION ins_gae
      #     LET g_action_choice="ins_gae"
      #   DECLARE ins_gae_cs CURSOR  FOR 
      #      SELECT gae02,gae04 from gae_file
      #       WHERE gae01 = 'apss301'
      #         AND gae03 = '0'
      #         AND gae12 = 'std'
      #         AND gae02 LIKE 'vlz%'
      #      ORDER BY gae01,gae02
      #   LET l_gae02 = ''
      #   LET l_gaq03 = ''
      #   FOREACH ins_gae_cs INTO l_gae02,l_gaq03
      #      IF NOT cl_null(l_gae02) THEN
      #         UPDATE gae_file
      #            SET gae04 = l_gaq03
      #         WHERE gae01 = 'apss301'
      #           AND gae03 = '2'
      #           AND gae12 = 'std'
      #           AND gae02 = l_gae02
      #      ELSE
      #         LET l_gae02 = ''
      #      END IF
      #   END FOREACH 
 
      #ON ACTION reproduce
      #     LET g_action_choice="reproduce"
      #     IF cl_chk_act_auth() THEN
      #          CALL s301_copy()
      #     END IF
      #ON ACTION output
      #     LET g_action_choice="output"
      #     IF cl_chk_act_auth() THEN
      #        IF cl_null(g_wc) THEN LET g_wc='1=1' END IF          
      #        LET l_cmd = 'p_query "apss301" "',g_wc CLIPPED,'"'   
      #        CALL cl_cmdrun(l_cmd)                                
      #     END IF
 
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL s301_fetch('/')
        ON ACTION first
            CALL s301_fetch('F')
        ON ACTION last
            CALL s301_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE MENU
 
        ON ACTION about         
            CALL cl_about()     
 
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
 
         ON ACTION related_document    
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_vlz.vlz01 IS NOT NULL THEN
                 LET g_doc.column1 = "vlz01"
                 LET g_doc.column2 = "vlz02"
                 LET g_doc.value1 = g_vlz.vlz02
                 LET g_doc.value2 = g_vlz.vlz02
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE s301_cs
END FUNCTION
 
 
FUNCTION s301_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_vlz.* LIKE vlz_file.*
    LET g_vlz01_t = NULL
    LET g_vlz02_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
       #僅給defaut,NOENTRY
        LET g_vlz.vlz04  = NULL
        LET g_vlz.vlz05  = 0
        LET g_vlz.vlz06  = NULL
        LET g_vlz.vlz07  = NULL
        LET g_vlz.vlz08  = NULL
        LET g_vlz.vlz12  = 1  #FUN-860060
        LET g_vlz.vlz16  = 0
        LET g_vlz.vlz18  = 1
        LET g_vlz.vlz20  = 1
        LET g_vlz.vlz21  = 1
        LET g_vlz.vlz24  = 1
        LET g_vlz.vlz25  = 1
        LET g_vlz.vlz27  = 1
        LET g_vlz.vlz28  = 1
        LET g_vlz.vlz29  = 0
        LET g_vlz.vlz30  = 0
        LET g_vlz.vlz31  = 1
        LET g_vlz.vlz32  = 24
        LET g_vlz.vlz33  = 31
        LET g_vlz.vlz34  = 0
        LET g_vlz.vlz37  = 0
        LET g_vlz.vlz38  = 365
        LET g_vlz.vlz39  = 0
        LET g_vlz.vlz45  = 3
        LET g_vlz.vlz46  = 3
        LET g_vlz.vlz47  = 3
        LET g_vlz.vlz48  = 3
        LET g_vlz.vlz49  = 0
       #default
        #以下欄位才開放ENTRY
       #FUN-990093---mod----str----
       #LET g_vlz.vlz73  =  'APS_MO-'  #FUN-8C0008 ADD
       #LET g_vlz.vlz74  =  'APS_PO-'  #FUN-8C0008 ADD
        LET g_vlz.vlz73  =  ''
        LET g_vlz.vlz74  =  ''
       #FUN-990093---mod----end----
        LET g_vlz.vlz75  = 0           #FUN-8C0008 ADD
        LET g_vlz.vlz76  = 0           #FUN-910005 ADD
        LET g_vlz.vlz01  = ''   #FUN-840209
       #LET g_vlz.vlz02  =
       #LET g_vlz.vlz03  = 
        LET g_vlz.vlz09  = 0
        LET g_vlz.vlz10  = 0
        LET g_vlz.vlz11  = 0
        LET g_vlz.vlz13  = 2
        LET g_vlz.vlz14  = 2
        LET g_vlz.vlz15  = 2
        LET g_vlz.vlz17  = 1  #FUN-860060
        LET g_vlz.vlz19  = 0
        LET g_vlz.vlz22  = 1
        LET g_vlz.vlz23  = 1
        LET g_vlz.vlz26  = 0
        LET g_vlz.vlz35  = 0
        LET g_vlz.vlz36  = 0
        LET g_vlz.vlz40  = 0
        LET g_vlz.vlz41  = 0
        LET g_vlz.vlz42  = 0
       #LET g_vlz.vlz43  =
       #LET g_vlz.vlz44  = 0 #TQC-950076 MARK
        LET g_vlz.vlz44  = 1 #TQC-950076 ADD
        LET g_vlz.vlz50  = 1  #FUN-930127 MARK
        LET g_vlz.vlz50 = 0    #FUN-930127 ADD
        LET g_vlz.vlz51  = 1
        LET g_vlz.vlz52  = 12
        LET g_vlz.vlz53  = 0
        LET g_vlz.vlz54  = 0
        LET g_vlz.vlz55  = 0 
        LET g_vlz.vlz56  = 0
        LET g_vlz.vlz57  = 7200
        LET g_vlz.vlz56b = '00:00:00'  #FUN-860060 add
        LET g_vlz.vlz57b = '02:00:00'  #FUN-860060 add
        LET g_vlz.vlz58  = '1'
        LET g_vlz.vlz59  = '1'
        LET g_vlz.vlz60  = 0
       #LET g_vlz.vlz61  =
       LET g_vlz.vlz62  = 'VTOP'
       LET g_vlz.vlz63  = 'VTEQ'
       #LET g_vlz.vlz64  =
       #LET g_vlz.vlz65  =
        LET g_vlz.vlz66  = 'mcp'
        LET g_vlz.vlz67  = 2
       LET g_vlz.vlz68  = 'VTR1'
       LET g_vlz.vlz69  = 1
       LET g_vlz.vlz72  = 'VENDER'  #FUN-860060
       LET g_vlz.vlz71  = '0,1'  #FUN-860060
       LET g_vlz.vlz77  = 0  #FUN-930127 ADD
       LET g_vlz.vlz78  = 'MOD-'  #FUN-930127 ADD
       LET g_vlz.vlz79  = 1  #FUN-930127 ADD
       LET g_vlz.vlz80  = 0  #FUN-930127 ADD
       LET g_vlz.vlz81  = 30  #FUN-930127 ADD
       LET g_vlz.vlz82  = 0  #FUN-930127 ADD
       LET g_vlz.vlz83  = 0  #FUN-930127 ADD
       LET g_vlz.vlz84  = 1  #FUN-B90038 ADD
       LET g_vlz.vlzlegal = g_legal  #FUN-B50003 add
       LET g_vlz.vlzplant = g_plant  #FUN-B50003 add

       CALL s301_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_vlz.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF (g_vlz.vlz01) IS NULL OR (g_vlz.vlz02 IS NULL) THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO vlz_file VALUES(g_vlz.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","vlz_file",g_vlz.vlz01,"",SQLCA.sqlcode,"","",0)   
            CONTINUE WHILE
        ELSE
            SELECT vlz01,vlz02 INTO g_vlz.vlz01,g_vlz.vlz02 FROM vlz_file
             WHERE vlz01 = g_vlz.vlz01
               AND vlz02 = g_vlz.vlz02
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION s301_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   DEFINE   l_input   LIKE type_file.chr1          
   DEFINE   l_n       LIKE type_file.num5          
 
 
   DISPLAY BY NAME
       #TQC-940126 MARK   --STR-------------------------------------------------
       ##基本資料-----------------------
       # g_vlz.vlz01,g_vlz.vlz02,g_vlz.vlz03,g_vlz.vlz70,
       # g_vlz.vlz05,g_vlz.vlz06,g_vlz.vlz07,g_vlz.vlz08,g_vlz.vlz66,
       # g_vlz.vlz04,g_vlz.vlz09,g_vlz.vlz10,g_vlz.vlz11,g_vlz.vlz67,
       # g_vlz.vlz73,g_vlz.vlz74,g_vlz.vlz75,  #FUN-8C0008 ADD
       ##供給---------------------------
       #             g_vlz.vlz12,g_vlz.vlz13,g_vlz.vlz14,g_vlz.vlz15,g_vlz.vlz16,g_vlz.vlz17,g_vlz.vlz18,g_vlz.vlz19,g_vlz.vlz20,
       # g_vlz.vlz21,g_vlz.vlz22,g_vlz.vlz23,g_vlz.vlz24,g_vlz.vlz25,g_vlz.vlz26,g_vlz.vlz27,g_vlz.vlz28,g_vlz.vlz29,g_vlz.vlz30,g_vlz.vlz31,
       #             g_vlz.vlz32,g_vlz.vlz33,g_vlz.vlz34,g_vlz.vlz35,g_vlz.vlz36,g_vlz.vlz37,g_vlz.vlz38,g_vlz.vlz39,g_vlz.vlz40,
       # g_vlz.vlz41,g_vlz.vlz42,g_vlz.vlz43,g_vlz.vlz44,g_vlz.vlz45,g_vlz.vlz46,g_vlz.vlz47,g_vlz.vlz48,g_vlz.vlz49,g_vlz.vlz50,
       # g_vlz.vlz71,g_vlz.vlz72,  #FUN-860060  ADD
       # g_vlz.vlz76,              #FUN-910005 ADD
       ##產能---------------------------
       # g_vlz.vlz51,g_vlz.vlz52,g_vlz.vlz53,g_vlz.vlz54,g_vlz.vlz55,g_vlz.vlz56,g_vlz.vlz57,g_vlz.vlz58,g_vlz.vlz59,
       # g_vlz.vlz60,g_vlz.vlz61,g_vlz.vlz62,g_vlz.vlz63,g_vlz.vlz64,g_vlz.vlz65,g_vlz.vlz66,g_vlz.vlz67,g_vlz.vlz68,g_vlz.vlz69,
       # g_vlz.vlz56b, g_vlz.vlz57b  #FUN-860060 add
       #
       #TQC-940126 MARK   --END------------------------------------------------- 
 
       #TQC-940126 ADD    --STR-------------------------------------------------
       #基本資料-----------------------
         g_vlz.vlz01,g_vlz.vlz02,g_vlz.vlz03,g_vlz.vlz70,g_vlz.vlz66,
         g_vlz.vlz10,g_vlz.vlz11,g_vlz.vlz67,
         g_vlz.vlz73,g_vlz.vlz74,g_vlz.vlz75,  
         g_vlz.vlz78,g_vlz.vlz83,   #FUN-930127 ADD
       #供給---------------------------
         g_vlz.vlz13,g_vlz.vlz14,g_vlz.vlz15,g_vlz.vlz17,
         g_vlz.vlz22,g_vlz.vlz23,
         g_vlz.vlz35,g_vlz.vlz36,g_vlz.vlz40,
         g_vlz.vlz41,g_vlz.vlz42,g_vlz.vlz43,
        #g_vlz.vlz44,   #TQC-950076 MARK
         g_vlz.vlz50,g_vlz.vlz71,g_vlz.vlz76,
         g_vlz.vlz77, g_vlz.vlz79, g_vlz.vlz80, g_vlz.vlz81,  #FUN-930127 ADD
         g_vlz.vlz84,                                         #FUN-B90038 add
       #產能---------------------------
         g_vlz.vlz51,g_vlz.vlz52,g_vlz.vlz53,g_vlz.vlz54,g_vlz.vlz55,
         g_vlz.vlz56b,g_vlz.vlz57b,g_vlz.vlz58,g_vlz.vlz59,g_vlz.vlz60,
         g_vlz.vlz61,g_vlz.vlz62,g_vlz.vlz63,g_vlz.vlz64,g_vlz.vlz65,
         g_vlz.vlz68, g_vlz.vlz69,g_vlz.vlz72,  
         g_vlz.vlz82   #FUN-930127 ADD
       #TQC-940126 ADD   --END-------------------------------------------------- 
 
 
 
   INPUT BY NAME
       #TQC-940126  MARK  --STR-----------------------------------------------  
       ##基本資料-----------------------
       # g_vlz.vlz01,g_vlz.vlz02,g_vlz.vlz03,g_vlz.vlz70,
       # g_vlz.vlz05,g_vlz.vlz06,g_vlz.vlz07,g_vlz.vlz08,g_vlz.vlz66,
       # g_vlz.vlz04,g_vlz.vlz09,g_vlz.vlz10,g_vlz.vlz11,g_vlz.vlz67,
       # g_vlz.vlz73,g_vlz.vlz74,g_vlz.vlz75,  #FUN-8C0008 ADD
       ##供給---------------------------
       #             g_vlz.vlz12,g_vlz.vlz13,g_vlz.vlz14,g_vlz.vlz15,g_vlz.vlz16,g_vlz.vlz17,g_vlz.vlz18,g_vlz.vlz19,g_vlz.vlz20,
       # g_vlz.vlz21,g_vlz.vlz22,g_vlz.vlz23,g_vlz.vlz24,g_vlz.vlz25,g_vlz.vlz26,g_vlz.vlz27,g_vlz.vlz28,g_vlz.vlz29,g_vlz.vlz30,g_vlz.vlz31,
       #             g_vlz.vlz32,g_vlz.vlz33,g_vlz.vlz34,g_vlz.vlz35,g_vlz.vlz36,g_vlz.vlz37,g_vlz.vlz38,g_vlz.vlz39,g_vlz.vlz40,
       # g_vlz.vlz41,g_vlz.vlz42,g_vlz.vlz43,g_vlz.vlz44,g_vlz.vlz45,g_vlz.vlz46,g_vlz.vlz47,g_vlz.vlz48,g_vlz.vlz49,g_vlz.vlz50,
       # g_vlz.vlz71, #FUN-860060 ADD
       # g_vlz.vlz76, #FUN-910005 ADD
       ##產能---------------------------
       # g_vlz.vlz51,g_vlz.vlz52,g_vlz.vlz53,g_vlz.vlz54,g_vlz.vlz55,g_vlz.vlz56,g_vlz.vlz57,g_vlz.vlz58,g_vlz.vlz59,
       # g_vlz.vlz60,g_vlz.vlz61,g_vlz.vlz62,g_vlz.vlz63,g_vlz.vlz64,g_vlz.vlz65,g_vlz.vlz66,g_vlz.vlz67,g_vlz.vlz68,g_vlz.vlz69,
       # g_vlz.vlz56b, g_vlz.vlz57b  #FUN-860060  add
       # WITHOUT DEFAULTS
       #TQC-940126  MARK  --END-----------------------------------------------
 
       #TQC-940126  ADD   --STR------------------------------------------------
       #基本資料-----------------------
        g_vlz.vlz01,g_vlz.vlz02,g_vlz.vlz03,g_vlz.vlz70,g_vlz.vlz66,
        g_vlz.vlz10,g_vlz.vlz11,g_vlz.vlz67,
        g_vlz.vlz73,g_vlz.vlz74,g_vlz.vlz75,
        g_vlz.vlz78,g_vlz.vlz83,   #FUN-930127 ADD
       #供給---------------------------
        g_vlz.vlz13,g_vlz.vlz14,g_vlz.vlz15,g_vlz.vlz17,
        g_vlz.vlz22,g_vlz.vlz23,
        g_vlz.vlz35,g_vlz.vlz36,g_vlz.vlz40,
        g_vlz.vlz41,g_vlz.vlz42,g_vlz.vlz43,
       #g_vlz.vlz44,   #TQC-950076 MARK
        g_vlz.vlz50,g_vlz.vlz71,g_vlz.vlz76,
        g_vlz.vlz77, g_vlz.vlz79, g_vlz.vlz80, g_vlz.vlz81,  #FUN-930127 ADD
        g_vlz.vlz84,                                         #FUN-B90038 add
       #產能---------------------------
        g_vlz.vlz51,g_vlz.vlz52,g_vlz.vlz53,g_vlz.vlz54,g_vlz.vlz55,
        g_vlz.vlz56b,g_vlz.vlz57b,g_vlz.vlz58,g_vlz.vlz59,
        g_vlz.vlz61,g_vlz.vlz62,g_vlz.vlz63,g_vlz.vlz64,g_vlz.vlz65,
        g_vlz.vlz68, g_vlz.vlz69,g_vlz.vlz72,
        g_vlz.vlz82  #FUN-930127 ADD
       #TQC-940126  ADD   --END-----------------------------------------------
   WITHOUT DEFAULTS #FUN-B50003 add    
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL s301_set_entry(p_cmd)
          CALL s301_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD vlz01
         DISPLAY "AFTER FIELD vlz01"
         IF NOT cl_null(g_vlz.vlz01) THEN
             IF g_vlz.vlz01 <> 'TP' THEN
                 CALL s301_vlz01()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_vlz.vlz01,g_errno,1)
                    LET g_vlz.vlz01 = g_vlz01_t
                    DISPLAY BY NAME g_vlz.vlz01
                    #NEXT FIELD vlz01                 #FUN-910005 MARK 
                    #FUN-910005 ADD --STR-- 
                    IF g_action_choice="modify" THEN  
                       EXIT INPUT                     
                    ELSE                              
                       NEXT FIELD vlz01
                    END IF
                    #FUN-910005  ADD  --END--
                 END IF
             END IF
         END IF
         IF NOT cl_null(g_vlz.vlz01) AND NOT cl_null(g_vlz.vlz02) THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_vlz.vlz01 != g_vlz01_t) OR
               (p_cmd = "u" AND g_vlz.vlz02 != g_vlz02_t) THEN
               SELECT count(*) INTO l_n FROM vlz_file 
                WHERE vlz01 = g_vlz.vlz01
                  AND vlz02 = g_vlz.vlz02
               IF l_n > 0 THEN                  # Duplicated
                  LET g_msg = g_vlz.vlz01 CLIPPED ,' + ', g_vlz.vlz02 CLIPPED
                  CALL cl_err(g_msg,-239,1)
                  LET g_vlz.vlz01 = g_vlz01_t
                  DISPLAY BY NAME g_vlz.vlz01
                  NEXT FIELD vlz01
               END IF
            END IF  
         END IF   
         #FUN-870153
         SELECT sma917 into g_vlz.vlz60 FROM sma_file
         IF SQLCA.sqlcode THEN 
            LET g_vlz.vlz60 = 0
         END IF
         DISPLAY BY NAME g_vlz.vlz60  
      AFTER FIELD vlz02
         DISPLAY "AFTER FIELD vlz02"
         IF NOT cl_null(g_vlz.vlz01) AND NOT cl_null(g_vlz.vlz02) THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_vlz.vlz01 != g_vlz01_t) OR
               (p_cmd = "u" AND g_vlz.vlz02 != g_vlz02_t) THEN
               SELECT count(*) INTO l_n FROM vlz_file 
                WHERE vlz01 = g_vlz.vlz01
                  AND vlz02 = g_vlz.vlz02
               IF l_n > 0 THEN                  # Duplicated
                  LET g_msg = g_vlz.vlz01 CLIPPED ,' + ', g_vlz.vlz02 CLIPPED
                  CALL cl_err(g_msg,-239,1)
                  LET g_vlz.vlz02 = g_vlz02_t
                  DISPLAY BY NAME g_vlz.vlz02
                  NEXT FIELD vlz02
               END IF
               LET g_vlz.vlz73 = g_vlz.vlz02 CLIPPED,'-M' #FUN-990093 add
               LET g_vlz.vlz74 = g_vlz.vlz02 CLIPPED,'-P' #FUN-990093 add
               DISPLAY BY NAME g_vlz.vlz73,g_vlz.vlz74    #FUN-990093 add
            END IF  
         END IF     
      AFTER FIELD vlz51
         IF NOT cl_null(g_vlz.vlz51) THEN
             IF g_vlz.vlz51 < 0  THEN
                 #輸入值不可小於零!
                 CALL cl_err('','aim-391',1)
                  LET g_vlz.vlz51 = g_vlz_t.vlz51
                  DISPLAY BY NAME g_vlz.vlz51
                  NEXT FIELD vlz51
             END IF
         END IF
 
      AFTER FIELD vlz52
         IF NOT cl_null(g_vlz.vlz52) THEN
             IF g_vlz.vlz52 < 0  THEN
                 #輸入值不可小於零!
                 CALL cl_err('','aim-391',1)
                 LET g_vlz.vlz52 = g_vlz_t.vlz52
                 DISPLAY BY NAME g_vlz.vlz52
                 NEXT FIELD vlz52
             END IF
         END IF

      #FUN-930127  ADD  --STR--
      AFTER FIELD vlz81
        IF NOT cl_null(g_vlz.vlz81) THEN
            IF g_vlz.vlz81 < 0  THEN
                #輸入值不可小於零!
                CALL cl_err('','aim-391',1)
                LET g_vlz.vlz81 = g_vlz_t.vlz81
                DISPLAY BY NAME g_vlz.vlz81
                NEXT FIELD vlz81
            END IF
        END IF
      #FUN-930127  ADD  --END--
 
      #FUN-860060 MARK
      #AFTER FIELD vlz56
      #   IF NOT cl_null(g_vlz.vlz56) THEN
      #       IF g_vlz.vlz56 < 0  THEN
      #           #輸入值不可小於零!
      #           CALL cl_err('','aim-391',1)
      #           LET g_vlz.vlz56 = g_vlz_t.vlz56
      #           DISPLAY BY NAME g_vlz.vlz56
      #           NEXT FIELD vlz56
      #       END IF
      #   END IF
 
      #FUN-860060 ADD----begin------
      AFTER FIELD vlz56b
        IF  (cl_null(g_vlz.vlz56b)) or
            (g_vlz.vlz56b[3,3]<>':') or
            (g_vlz.vlz56b[6,6]<>':') or
            (cl_null(g_vlz.vlz56b[8,8])) or
            (g_vlz.vlz56b[1,2]<'00' or g_vlz.vlz56b[1,2]>'24') or
            (g_vlz.vlz56b[4,5]<'00' or g_vlz.vlz56b[4,5]>'60') or
            (g_vlz.vlz56b[7,8]<'00' or g_vlz.vlz56b[7,8]>'60') THEN
            CALL cl_err('','aem-006',0)
            NEXT  FIELD vlz56b
        END IF
        LET g_vlz.vlz56 = g_vlz.vlz56b[1,2]*60*60 +
                          g_vlz.vlz56b[4,5]*60 +
                          g_vlz.vlz56b[7,8]
        DISPLAY BY NAME g_vlz.vlz56
 
      AFTER FIELD vlz57b
        IF  (cl_null(g_vlz.vlz57b)) or
            (g_vlz.vlz57b[3,3]<>':') or
            (g_vlz.vlz57b[6,6]<>':') or
            (cl_null(g_vlz.vlz57b[8,8])) or
            (g_vlz.vlz57b[1,2]<'00' or g_vlz.vlz57b[1,2]>'24') or
            (g_vlz.vlz57b[4,5]<'00' or g_vlz.vlz57b[4,5]>'60') or
            (g_vlz.vlz57b[7,8]<'00' or g_vlz.vlz57b[7,8]>'60') THEN
            CALL cl_err('','aem-006',0)
            NEXT  FIELD vlz57b
        END IF
        LET g_vlz.vlz57 = g_vlz.vlz57b[1,2]*60*60 +
                          g_vlz.vlz57b[4,5]*60 +
                          g_vlz.vlz57b[7,8]
        DISPLAY BY NAME g_vlz.vlz57
      #FUN-860060  add ----end-----
 
      AFTER FIELD vlz70
         IF NOT cl_null(g_vlz.vlz70) THEN
             CALL s301_vlz70()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_vlz.vlz70,g_errno,1)
                LET g_vlz.vlz70 = g_vlz_t.vlz70
                DISPLAY BY NAME g_vlz.vlz70
                NEXT FIELD vlz70
             END IF
         END IF
 
      #FUN-8C0008 ADD STR-----------------------------
      AFTER FIELD vlz73
         IF NOT cl_null(g_vlz.vlz73) THEN
            IF LENGTH(g_vlz.vlz73)>11 THEN
               CALL cl_err(g_vlz.vlz73,'aps-731',0)
               NEXT FIELD vlz73
            END IF 
         END IF
      AFTER FIELD vlz74
         IF NOT cl_null(g_vlz.vlz74) THEN
            IF LENGTH(g_vlz.vlz74) > 11 THEN
               CALL cl_err(g_vlz.vlz74,'aps-731',0)
               NEXT FIELD vlz74
            END IF
         END IF
      #FUN-8C0008 ADD END----------------------------
 
                    
      AFTER INPUT   
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_vlz.vlz01) OR cl_null(g_vlz.vlz02) THEN
               DISPLAY BY NAME g_vlz.vlz01,g_vlz.vlz02
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD vlz01
            END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(vlz01) THEN
            LET g_vlz.* = g_vlz_t.*
            CALL s301_show()
            NEXT FIELD vlz01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(vlz01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_vzy02"
              LET g_qryparam.default1 = g_vlz.vlz01
              LET g_qryparam.arg1 = g_plant CLIPPED
              CALL cl_create_qry() RETURNING g_vlz.vlz01
              DISPLAY BY NAME g_vlz.vlz01
              NEXT FIELD vlz01
           WHEN INFIELD(vlz70)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_msp01"
              LET g_qryparam.default1 = g_vlz.vlz70
              CALL cl_create_qry() RETURNING g_vlz.vlz70
              DISPLAY BY NAME g_vlz.vlz70
              NEXT FIELD vlz70
 
           OTHERWISE
              EXIT CASE
           END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION
 
 
FUNCTION s301_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_vlz.* TO NULL            
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL s301_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN s301_count
    FETCH s301_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN s301_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vlz.vlz01,SQLCA.sqlcode,0)
        INITIALIZE g_vlz.* TO NULL
    ELSE
        CALL s301_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION s301_fetch(p_flvlz)
    DEFINE
        p_flvlz         LIKE type_file.chr1           
 
    CASE p_flvlz
        WHEN 'N' FETCH NEXT     s301_cs INTO g_vlz.vlz01,g_vlz.vlz02
        WHEN 'P' FETCH PREVIOUS s301_cs INTO g_vlz.vlz01,g_vlz.vlz02
        WHEN 'F' FETCH FIRST    s301_cs INTO g_vlz.vlz01,g_vlz.vlz02
        WHEN 'L' FETCH LAST     s301_cs INTO g_vlz.vlz01,g_vlz.vlz02
        WHEN '/'
            IF (NOT mi_no_ask) THEN              
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
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump s301_cs INTO g_vlz.vlz01,g_vlz.vlz02
            LET mi_no_ask = FALSE         
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vlz.vlz01,SQLCA.sqlcode,0)
        INITIALIZE g_vlz.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_flvlz
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx             
    END IF
 
    SELECT * INTO g_vlz.* FROM vlz_file    # 重讀DB,因TEMP有不被更新特性
       WHERE vlz01=g_vlz.vlz01 AND vlz02=g_vlz.vlz02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vlz_file",g_vlz.vlz01,"",SQLCA.sqlcode,"","",0)  
    ELSE
       #LET g_data_owner=g_vlz.vlzuser 
       #LET g_data_group=g_vlz.vlzgrup
        CALL s301_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION s301_show()
    LET g_vlz.vlz72='VENDER'  #FUN-860060
    LET g_vlz_t.* = g_vlz.*
   #DISPLAY BY NAME g_vlz.*  #TQC-940126
   #TQC-940126 ADD  --STR-----------------------------------------------
    DISPLAY BY NAME
        g_vlz.vlz01,g_vlz.vlz02,g_vlz.vlz03,g_vlz.vlz70,g_vlz.vlz66,
        g_vlz.vlz10,g_vlz.vlz11,g_vlz.vlz67,
        g_vlz.vlz73,g_vlz.vlz74,g_vlz.vlz75,
      #供給---------------------------
        g_vlz.vlz13,g_vlz.vlz14,g_vlz.vlz15,g_vlz.vlz17,
        g_vlz.vlz22,g_vlz.vlz23,
        g_vlz.vlz35,g_vlz.vlz36,g_vlz.vlz40,
        g_vlz.vlz41,g_vlz.vlz42,g_vlz.vlz43,
       #g_vlz.vlz44,  #TQC-950076 MARK
        g_vlz.vlz50,g_vlz.vlz71,g_vlz.vlz76,
        g_vlz.vlz77,g_vlz.vlz79,g_vlz.vlz80,g_vlz.vlz81,  #FUN-B90038 add
        g_vlz.vlz84,                                      #FUN-B90038 add
      #產能---------------------------
        g_vlz.vlz51,g_vlz.vlz52,g_vlz.vlz53,g_vlz.vlz54,g_vlz.vlz55,
        g_vlz.vlz56b,g_vlz.vlz57b,g_vlz.vlz58,g_vlz.vlz59,g_vlz.vlz60,
        g_vlz.vlz61,g_vlz.vlz62,g_vlz.vlz63,g_vlz.vlz64,g_vlz.vlz65,
        g_vlz.vlz68, g_vlz.vlz69,g_vlz.vlz72
   #TQC-940126 ADD  --END---------------------------------------------- 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION s301_u()
    IF cl_null(g_vlz.vlz01) OR cl_null(g_vlz.vlz02) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_vlz.* FROM vlz_file 
     WHERE vlz01=g_vlz.vlz01
       AND vlz02=g_vlz.vlz02
   #IF g_vlz.vlzacti = 'N' THEN
   #    CALL cl_err('',9027,0) 
   #    RETURN
   #END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vlz01_t = g_vlz.vlz01
    LET g_vlz02_t = g_vlz.vlz02
    BEGIN WORK
 
    OPEN s301_cl USING g_vlz.vlz01,g_vlz.vlz02
    IF STATUS THEN
       CALL cl_err("OPEN s301_cl:", STATUS, 1)
       CLOSE s301_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH s301_cl INTO g_vlz.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vlz.vlz01,SQLCA.sqlcode,1)
        RETURN
    END IF
   #LET g_vlz.vlzmodu=g_user                  #修改者
   #LET g_vlz.vlzdate = g_today               #修改日期
    CALL s301_show()                          # 顯示最新資料
    WHILE TRUE
        CALL s301_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vlz.*=g_vlz_t.*
            CALL s301_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_vlz.vlzlegal = g_legal  #FUN-B50003 add
        LET g_vlz.vlzplant = g_plant  #FUN-B50003 add

        UPDATE vlz_file SET vlz_file.* = g_vlz.*    # 更新DB
            WHERE vlz01=g_vlz_t.vlz01 AND vlz02=g_vlz_t.vlz02
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","vlz_file",g_vlz.vlz01,"",SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE s301_cl
    COMMIT WORK
END FUNCTION
 
#FUNCTION s301_x()
#    IF g_vlz.vlz01 IS NULL THEN
#        CALL cl_err('',-400,0)
#        RETURN
#    END IF
#    BEGIN WORK
#
#    OPEN s301_cl USING g_vlz.vlz01,g_vlz.vlz02
#    IF STATUS THEN
#       CALL cl_err("OPEN s301_cl:", STATUS, 1)
#       CLOSE s301_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#    FETCH s301_cl INTO g_vlz.*
#    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_vlz.vlz01,SQLCA.sqlcode,1)
#       RETURN
#    END IF
#    CALL s301_show()
#    IF cl_exp(0,0,g_vlz.vlzacti) THEN
#        LET g_chr=g_vlz.vlzacti
#        IF g_vlz.vlzacti='Y' THEN
#            LET g_vlz.vlzacti='N'
#        ELSE
#            LET g_vlz.vlzacti='Y'
#        END IF
#        UPDATE vlz_file
#            SET vlzacti=g_vlz.vlzacti
#            WHERE rowid=g_vlz_rowid
#        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_vlz.vlz01,SQLCA.sqlcode,0)
#            LET g_vlz.vlzacti=g_chr
#        END IF
#        DISPLAY BY NAME g_vlz.vlzacti
#    END IF
#    CLOSE s301_cl
#    COMMIT WORK
#END FUNCTION
 
FUNCTION s301_r()
  DEFINE l_cnt        LIKE type_file.num5 #FUN-A80051 add
    IF cl_null(g_vlz.vlz01) OR cl_null(g_vlz.vlz02) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #FUN-A80051--add---str---
    SELECT COUNT(*) INTO l_cnt
      FROM vld_file
     WHERE vld01 = g_vlz.vlz01
       AND vld02 = g_vlz.vlz02
    IF l_cnt >=1 THEN
        CALL cl_err("",'aps-102', 1) #"APS版本+儲存版本"已有MDS匯整資料,故不可以刪除!
        RETURN
    END IF
    #FUN-A80051--add---end---
    BEGIN WORK
 
    OPEN s301_cl USING g_vlz.vlz01,g_vlz.vlz02
    IF STATUS THEN
       CALL cl_err("OPEN s301_cl:", STATUS, 0)
       CLOSE s301_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH s301_cl INTO g_vlz.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vlz.vlz01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL s301_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vlz01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "vlz02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vlz.vlz02      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_vlz.vlz02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM vlz_file 
        WHERE vlz01 = g_vlz.vlz01
          AND vlz02 = g_vlz.vlz02
       CLEAR FORM
       OPEN s301_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE s301_cs
          CLOSE s301_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH s301_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE s301_cs
          CLOSE s301_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN s301_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL s301_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE                 
          CALL s301_fetch('/')
       END IF
    END IF
    CLOSE s301_cl
    COMMIT WORK
END FUNCTION
 
#FUNCTION s301_copy()
#    DEFINE
#        l_newno         LIKE vlz_file.vlz01,
#        l_oldno         LIKE vlz_file.vlz01,
#        p_cmd     LIKE type_file.chr1,        
#        l_input   LIKE type_file.chr1        
#
#    IF g_vlz.vlz01 IS NULL THEN
#       CALL cl_err('',-400,0)
#        RETURN
#    END IF
# 
#    LET l_input='N'
#    LET g_before_input_done = FALSE
#    CALL s301_set_entry('a')
#    LET g_before_input_done = TRUE
#    INPUT l_newno FROM vlz01
# 
#        AFTER FIELD vlz01
#           IF l_newno IS NOT NULL THEN
#              SELECT count(*) INTO g_cnt FROM vlz_file
#                  WHERE vlz01 = l_newno
#              IF g_cnt > 0 THEN
#                 CALL cl_err(l_newno,-239,0)
#                  NEXT FIELD vlz01
#              END IF
#                  SELECT gen01
#                      FROM gen_file
#                      WHERE gen01= l_newno
#                  IF SQLCA.sqlcode THEN
#                      DISPLAY BY NAME g_vlz.vlz01
#                      LET l_newno = NULL
#                      NEXT FIELD vlz01
#                  END IF
#           END IF
# 
#        ON ACTION controlp                        # 沿用所有欄位
#           IF INFIELD(vlz01) THEN
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_gen"
#              LET g_qryparam.default1 = g_vlz.vlz01
#              CALL cl_create_qry() RETURNING l_newno
##              CALL FGL_DIALOG_SETBUFFER( l_newno )
#             #DISPLAY BY NAME l_newno                  #TQC-640187 mark
#              DISPLAY l_newno TO vlz01                 #TQC-640187
#              SELECT gen01
#              FROM gen_file
#              WHERE gen01= l_newno
#              IF SQLCA.sqlcode THEN
#                 DISPLAY BY NAME g_vlz.vlz01
#                 LET l_newno = NULL
#                 NEXT FIELD vlz01
#              END IF
#              NEXT FIELD vlz01
#           END IF
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
# 
#    END INPUT
#    IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        DISPLAY BY NAME g_vlz.vlz01
#        RETURN
#    END IF
#    DROP TABLE x
#    SELECT * FROM vlz_file
#        WHERE rowid=g_vlz_rowid
#        INTO TEMP x
#    UPDATE x
#        SET vlz01=l_newno,    #資料鍵值
#            vlzacti='Y',      #資料有效碼
#            vlzuser=g_user,   #資料所有者
#            vlzgrup=g_grup,   #資料所有者所屬群
#            vlzmodu=NULL,     #資料修改日期
#            vlzdate=g_today   #資料建立日期
#    INSERT INTO vlz_file
#        SELECT * FROM x
#    IF SQLCA.sqlcode THEN
##       CALL cl_err(g_vlz.vlz01,SQLCA.sqlcode,0)   #No.FUN-660131
#        CALL cl_err3("ins","vlz_file",g_vlz.vlz01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
#    ELSE
#        MESSAGE 'ROW(',l_newno,') O.K'
#        LET l_oldno = g_vlz.vlz01
#        LET g_vlz.vlz01 = l_newno
#        SELECT vlz_file.* INTO g_vlz.* FROM vlz_file
#               WHERE vlz01 = l_newno
#        CALL s301_u()
#        SELECT vlz_file.* INTO g_vlz.* FROM vlz_file
#               WHERE vlz01 = l_oldno
#    END IF
#    LET g_vlz.vlz01 = l_oldno
#    CALL s301_show()
#END FUNCTION
 
FUNCTION s301_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("vlz01,vlz02",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION s301_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1    
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("vlz01,vlz02",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION s301_vlz01()
DEFINE l_cnt                 LIKE type_file.num10         
 
   LET g_errno=''
   SELECT count(*)
     INTO l_cnt
     FROM vzy_file
    WHERE vzy01 = g_vlz.vlz01
      AND vzy06 = g_plant 
      AND vzy10 = 'Y'   #FUN-880010
    IF l_cnt <= 0 THEN
        #無此版本代號, 請重新輸入!
        LET g_errno='adm-002'
    ELSE 
        LET g_errno=SQLCA.sqlcode USING '------'
    END IF
END FUNCTION
 
FUNCTION s301_vlz70()
DEFINE l_cnt                 LIKE type_file.num10         
 
   LET g_errno=''
   SELECT count(*)
     INTO l_cnt
     FROM msp_file
    WHERE msp01 = g_vlz.vlz70
    IF l_cnt <= 0 THEN
        #無此版本代號, 請重新輸入!
        LET g_errno='adm-002'
    ELSE 
        LET g_errno=SQLCA.sqlcode USING '------'
    END IF
END FUNCTION
