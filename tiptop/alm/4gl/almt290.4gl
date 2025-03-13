# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: almt290.4gl
# Descriptions...: 潛在商戶登記作業 
# Date & Author..: NO.FUN-870010 08/07/23 By lilingyu 
# Modify.........: No.FUN-960134 09/07/09 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/24 By shiwuying add oriu,orig
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70063 10/07/14 by chenying azf02 = '3'抓取品牌代碼改抓 tqa_file.tqa03 = '2';
#                                                     欄位azf01改抓tqa01,欄位azf03改抓tqa02;
#                                                     q_lnb08替換成q_lnb08_1 
# Modify.........: No:FUN-A70130 10/08/09 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No:FUN-A80073 10/08/24 By wangxin 修改Bug：查詢任一筆已確認的資料後, 
#                                                    反覆按下 "查詢費用單",刪除費用單資料, 
#                                                    再按 "產生費用單","產生費用單" 最後會變成新增狀態的問題
# Modify.........: No.FUN-A80105 10/08/26 By huangtao 產生費用單開窗
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: NO:FUN-AA0071 10/10/25 By chenying 手動清空 lnb08 欄位值, After Field將 tqa02 欄位清空
# Modify.........: NO:FUN-AA0078 10/10/27 By shiwuying 按鈕名稱修改  
# Modify.........: No.FUN-AC0062 10/12/22 By lixh1 因lua05欄位no use,故mark掉lua05的所有邏輯
# Modify.........: NO:MOD-AC0365 11/01/05 By shiwuying bug修改
# Modify.........: NO:FUN-B20038 11/02/17 By huangtao 取消簽核
# Modify.........: NO:TQC-B50102 11/05/19 By lixia 修改來源門店編號(lnb03)時，重新顯示相應的名稱（rtz13)
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80060 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.FUN-B90056 11/09/08 By yangxf 去掉 缴纳质保金，注册资金，税务登记证，营业执照，营运中心编号证，5个栏位
#                                                   將 經營信息和其他品牌寫到單身
# Modify.........: No.FUN-B90121 12/01/13 By yangxf 将q_tqa001改成q_lnd02

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C30027 12/03/01 by fanbj 拿掉主品牌重複控管，僅提示重複，可以繼續錄入
# Modify.........: No:TQC-C40051 12/04/13 by pauline "產地" 欄位的開窗及欄位檢查,改成使用axmi365 oqw_file 的資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30027 12/08/20 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:FUN-D20039 13/01/19 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No.CHI-D20015 13/03/26 By qiull 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lnb       RECORD    LIKE lnb_file.*,  
       g_lnb_t     RECORD    LIKE lnb_file.*,					
       g_lnb_o     RECORD    LIKE lnb_file.*,    
       g_lnb01_t             LIKE lnb_file.lnb01,
       g_lnb02_t             LIKE lnb_file.lnb02
#FUN-B90056-----------begin------------
DEFINE g_lnd      DYNAMIC ARRAY OF RECORD
                      lnd02    LIKE lnd_file.lnd02,
                      tqa02_1  LIKE tqa_file.tqa02,
                      lnd03    LIKE lnd_file.lnd03,
                      lnd04    LIKE lnd_file.lnd04,
                      lnd05    LIKE lnd_file.lnd05,
                      lnd06    LIKE lnd_file.lnd06
                   END RECORD,
       g_lnc      DYNAMIC ARRAY OF RECORD
                      lnc02    LIKE lnc_file.lnc02,
                      tqa02_2  LIKE tqa_file.tqa02,
                      lnc03    LIKE lnc_file.lnc03,
                      geo02_1  LIKE geo_file.geo02
                   END RECORD,
       g_lnd_t    RECORD 
                      lnd02    LIKE lnd_file.lnd02,
                      tqa02_1  LIKE tqa_file.tqa02,
                      lnd03    LIKE lnd_file.lnd03,
                      lnd04    LIKE lnd_file.lnd04,
                      lnd05    LIKE lnd_file.lnd05,
                      lnd06    LIKE lnd_file.lnd06
                   END RECORD,
       g_lnc_t    RECORD
                      lnc02    LIKE lnc_file.lnc02,
                      tqa02_2  LIKE tqa_file.tqa02,
                      lnc03    LIKE lnc_file.lnc03,
                      geo02_1  LIKE geo_file.geo02
                   END RECORD                 
DEFINE g_wc                  STRING 
DEFINE g_wc2                 STRING
DEFINE g_wc3                 STRING
#FUN-B90056--------------end----------------
DEFINE g_sql                 STRING                 
DEFINE g_forupd_sql          STRING                    #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5   
DEFINE g_chr                 LIKE type_file.chr1 
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5       #count/index for any purpose
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10 
DEFINE g_jump                LIKE type_file.num10             
DEFINE g_no_ask              LIKE type_file.num5 
DEFINE g_void                LIKE type_file.chr1
DEFINE g_confirm             LIKE type_file.chr1
DEFINE g_lnb02               LIKE lnb_file.lnb02    
DEFINE g_date                LIKE lnb_file.lnbdate
DEFINE g_modu                LIKE lnb_file.lnbmodu
DEFINE g_gec02               LIKE gec_file.gec02
DEFINE g_gec04               LIKE gec_file.gec04
DEFINE g_gec07               LIKE gec_file.gec07
#DEFINE g_kindslip           LIKE lrk_file.lrkslip    #FUN-A70130  mark
DEFINE g_kindslip            LIKE oay_file.oayslip     #FUN-A70130
DEFINE g_lua01               LIKE lua_file.lua01       #No.FUN-A80105  
DEFINE g_dd                  LIKE lua_file.lua09       #No.FUN-A80105   
#FUN-B90056--------------begin--------------
DEFINE l_ac1                 LIKE type_file.num5
DEFINE l_ac2                 LIKE type_file.num5    
DEFINE g_rec_b1              LIKE type_file.num5
DEFINE g_rec_b2              LIKE type_file.num5
DEFINE g_flag_b              LIKE type_file.chr1 
#FUN-B90056--------------end----------------- 

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT          
    
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
  
   IF g_aza.aza113 = 'N' THEN
      CALL cl_err('','alm-798',1)
      EXIT PROGRAM
   END IF 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_forupd_sql = "SELECT * FROM lnb_file WHERE lnb01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t290_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW t290_w WITH FORM "alm/42f/almt290"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()   
 
   LET g_action_choice = ""
   CALL t290_menu()
 
   CLOSE WINDOW t290_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t290_curs()
 
   CLEAR FORM
   DIALOG ATTRIBUTE(UNBUFFERED)              #FUN-B90056 add
      CONSTRUCT BY NAME g_wc ON
         lnb01,lnb02,lnb03,lnb04,lnb05,lnb06,lnb07,lnb08,lnb09,lnb10,  
         lnb12,lnb13,lnb14,lnb15,lnb16,lnb17,lnb18,lnb19,lnb20,lnb21,
   #     lnb22,lnb23,lnb24,lnb27,lnb28,lnb29,lnb26,lnb25,lnb30,lnb31,       #FUN-B20038 mark
   #     lnb22,lnb23,lnb24,lnb27,lnb28,lnb29,lnb26,lnb25,lnb30,              #FUN-B20038 #FUN-B90056 mark
         lnb22,lnb28,lnb23,lnb24,                                            #FUN-B90056
   #     lnb32,lnb33,lnb34,lnb35,lnb36,lnb37,lnb38,lnb39,lnb52,lnb53,       #FUN-B20038 mark
         lnb33,lnb34,lnb35,lnb36,lnb37,lnb38,lnb39,lnb52,lnb53,              #FUN-B20038
         lnb40,lnb41,lnb42,lnb43,lnb44,lnb45,lnb46,lnb47,lnb48,lnb49,
         lnb50,lnb51,lnbuser,lnbgrup,lnboriu,lnborig,lnbcrat,lnbmodu,lnbdate #No:FUN-9B0136
    
         BEFORE CONSTRUCT
              CALL cl_qbe_init()
    
              ON ACTION controlp
                 CASE
                    WHEN INFIELD(lnb01)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lnb01"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lnb01
                       NEXT FIELD lnb01                     
                   
                   WHEN INFIELD(lnb02)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lnb02"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lnb02
                       NEXT FIELD lnb02  
   
                   WHEN INFIELD(lnb03)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lnb03"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lnb03
                       NEXT FIELD lnb03      
                   
                   WHEN INFIELD(lnb04)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lnb04"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lnb04
                       NEXT FIELD lnb04      
                    
                   WHEN INFIELD(lnb08)
                       CALL cl_init_qry_var()
   #                   LET g_qryparam.form = "q_lnb08"            #FUN-70063 mark
                       LET g_qryparam.form = "q_lnb08_1"          #FUN-70063 mod
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lnb08
                       NEXT FIELD lnb08           
                   
                    WHEN INFIELD(lnb09)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lnb09"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lnb09
                       NEXT FIELD lnb09
                    
                    WHEN INFIELD(lnb37)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lnb37"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lnb37
                       NEXT FIELD lnb37
                    
                     WHEN INFIELD(lnb39)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lnb39"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lnb39
                       NEXT FIELD lnb39
                     
                      WHEN INFIELD(lnb47)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lnb47"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lnb47
                       NEXT FIELD lnb47            
                     
                     WHEN INFIELD(lnb52)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lnb52"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lnb52
                       NEXT FIELD lnb52    
                       
                     WHEN INFIELD(lnb53)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lnb53"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lnb53
                       NEXT FIELD lnb53
                       
                  OTHERWISE
                  EXIT CASE
                 END CASE
    
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
#               CONTINUE CONSTRUCT  #FUN-B90056 mark
                CONTINUE DIALOG
    
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

             ON ACTION accept
                ACCEPT DIALOG

             ON ACTION cancel
                LET INT_FLAG = 1
                EXIT DIALOG    
        END CONSTRUCT
        CONSTRUCT g_wc2 ON lnd02,tqa02_1,lnd03,lnd04,lnd05,lnd06
                      FROM s_lnd[1].lnd02,s_lnd[1].tqa02_1,s_lnd[1].lnd03,s_lnd[1].lnd04,s_lnd[1].lnd05,s_lnd[1].lnd06 
           BEFORE CONSTRUCT
               CALL cl_qbe_init()

             ON ACTION controlp
                CASE
                   WHEN INFIELD(lnd02)
                       CALL cl_init_qry_var()
#                      LET g_qryparam.form = "q_tqa001"          #FUN-B90121 mark
                       LET g_qryparam.form = "q_lnd02"           #FUN-B90121 add
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO s_lnd[1].lnd02 
                       NEXT FIELD lnd02
                   OTHERWISE
                   EXIT CASE   
                END CASE
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE DIALOG

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

             ON ACTION accept
                ACCEPT DIALOG

             ON ACTION cancel
                LET INT_FLAG = 1
                EXIT DIALOG
       END CONSTRUCT
       CONSTRUCT g_wc3 ON lnc02,tqa02_2,lnc03,geo02_1
                     FROM s_lnc[1].lnc02,s_lnc[1].tqa02_2,s_lnc[1].lnc03,s_lnc[1].geo02_1
           BEFORE CONSTRUCT
               CALL cl_qbe_init()

             ON ACTION controlp
                CASE
                   WHEN INFIELD(lnc02)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lnc002"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO s_lnc[1].lnc02
                       NEXT FIELD lnc02
                   WHEN INFIELD(lnc03)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_lnc03"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO s_lnc[1].lnc03
                       NEXT FIELD lnc03 
                   OTHERWISE
                   EXIT CASE
                END CASE
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE DIALOG

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

             ON ACTION accept
                ACCEPT DIALOG

             ON ACTION cancel
                LET INT_FLAG = 1
                EXIT DIALOG
       END CONSTRUCT              
    END DIALOG
#FUN-B90056-------------end--------------
    IF INT_FLAG THEN
       RETURN
    END IF
   
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN   
    #        LET g_wc = g_wc clipped," AND lnbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN   
    #        LET g_wc = g_wc clipped," AND lnbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN 
    #        LET g_wc = g_wc clipped," AND lnbgrup IN",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lnbuser', 'lnbgrup')
    #End:FUN-980030
#FUN-B90056-------------begin----------- 
#    LET g_sql = "SELECT UNIQUE lnb_file.lnb01 FROM lnb_file",
#                " WHERE ",g_wc CLIPPED,
#                " ORDER BY lnb01"
# 
#    PREPARE t290_prepare FROM g_sql
#    DECLARE t290_cs                                # SCROLL CURSOR
#        SCROLL CURSOR WITH HOLD FOR t290_prepare
# 
#    LET g_sql = "SELECT COUNT(DISTINCT lnb01) FROM lnb_file WHERE ",g_wc CLIPPED,  
#    PREPARE t290_precount FROM g_sql
#    DECLARE t290_count CURSOR FOR t290_precount
#FUN-B90056-------------end--------------
#FUN-B90056 add begin ----
       IF g_wc3 = " 1=1" THEN
          IF g_wc2 = " 1=1" THEN
             LET g_sql = "SELECT UNIQUE lnb01 FROM lnb_file ",
                         " WHERE ",g_wc CLIPPED,
                         " ORDER BY lnb01"
          ELSE
             LET g_sql = "SELECT UNIQUE lnb01 ",
                         "  FROM lnb_file,lnd_file ",
                         " WHERE lnb01 = lnd01 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                         " ORDER BY lnb01"
          END IF
       ELSE
          IF g_wc2 = " 1=1" THEN
             LET g_sql = "SELECT UNIQUE lnb01 ",
                         "  FROM lnb_file,lnc_file ",
                         " WHERE lnb01 = lnc01 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED,
                         " ORDER BY lnb01"
          ELSE
             LET g_sql = "SELECT UNIQUE lnb01 ",
                         "  FROM lnb_file,lnc_file,lnd_file ",
                         " WHERE lnb01 = lnd01 AND lnb01 = lnc01 ",
                         "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                         "   AND ",g_wc3 CLIPPED,
                         " ORDER BY lnb01"
          END IF
      END IF
    PREPARE t290_prepare FROM g_sql
    DECLARE t290_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t290_prepare

    IF g_wc3 = " 1=1" THEN
       IF g_wc2 = " 1=1" THEN
          LET g_sql = "SELECT COUNT(*) FROM lnb_file ",
                      " WHERE ",g_wc CLIPPED
       ELSE
          LET g_sql = "SELECT COUNT(DISTINCT lnb01) ",
                      "  FROM lnb_file,lnd_file ",
                      " WHERE lnb01 = lnd01 ",
                      "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
       END IF
    ELSE
       IF g_wc2 = " 1=1" THEN
          LET g_sql = "SELECT COUNT(DISTINCT lnb01) ",
                      "  FROM lnb_file,lnc_file ",
                      " WHERE lnb01 = lnc01 ",
                      "   AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED
       ELSE
          LET g_sql = "SELECT COUNT(DISTINCT lnb01) ",
                      "  FROM lnb_file,lnc_file,lnd_file ",
                      " WHERE lnb01 = lnc01 AND lnb01 = lnd01 ",
                      "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED
       END IF
    END IF
    PREPARE t290_precount FROM g_sql
    DECLARE t290_count CURSOR FOR t290_precount
#FUN-B90056 add end ---
END FUNCTION
 
FUNCTION t290_menu()
   DEFINE l_msg        LIKE type_file.chr1000
#MOD-AC0365 Begin---
#  DEFINE l_lua01      LIKE lua_file.lua01
#  DEFINE l_count      LIKE type_file.num5
# #DEFINE l_tqa06      LIKE tqa_file.tqa06 
# #DEFINE l_lrkdmy2    LIKE lrk_file.lrkdmy2    #FUN-A70130  mark
   DEFINE l_oayconf    LIKE oay_file.oayconf    #FUN-A70130
# #DEFINE l_lrkdmy3    LIKE lrk_file.lrkdmy3   #FUN-A70130  mark
# #DEFINE l_lrkkind    LIKE lrk_file.lrkkind   #FUN-A70130  mark
# #DEFINE l_oayslip    LIKE oay_file.oayslip    #FUN-A70130
# #DEFINE l_oaytype    LIKE oay_file.oaytype    #FUN-A70130
# #DEFINE li_result    LIKE type_file.num5
# #DEFINE l_azw02      LIKE azw_file.azw02
#  DEFINE l_n1         LIKE type_file.num5
# #DEFINE  l_flag      LIKE type_file.chr1     #No.FUN-A80105
#MOD-AC0365 End-----
   #FUN-B90056 Add&Mark Begin ---
#    MENU ""
#        BEFORE MENU
#           CALL cl_navigator_setting(g_curs_index,g_row_count)
     WHILE TRUE
        CALL t290_bp("G")
        CASE g_action_choice
        
#       ON ACTION insert
#          LET g_action_choice="insert"
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL t290_a()
                ##自動審核                      
               LET g_kindslip=s_get_doc_no(g_lnb.lnb01)         
               IF NOT cl_null(g_kindslip) THEN
         #FUN-A70130 --------------------start--------------------------------               
         #         SELECT lrkdmy2 INTO l_lrkdmy2 FROM lrk_file                               
         #          WHERE lrkslip = g_kindslip                         
         #         IF l_lrkdmy2 = 'Y' THEN  
                  SELECT oayconf INTO l_oayconf FROM oay_file  
                   WHERE oayslip = g_kindslip
                   IF l_oayconf = 'Y' THEN  
         #FUN-A70130 ---------------------end---------------------------------         
                     IF g_lnb.lnb02 IS NULL OR g_lnb.lnb04 IS NULL OR
                        g_lnb.lnb05 IS NULL THEN
                        CALL cl_err('','alm-423',0)
                      ELSE
                        CALL t290_confirm() 
                      END IF                               
                  END IF                      
              END IF               
           END IF
 
#       ON ACTION query
#          LET g_action_choice="query"
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL t290_q()
           END IF
 
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_lnb.lnb01) THEN
                 CALL t290_b()
              ELSE
                 LET g_action_choice=''  
                 CALL cl_err('','-400',1)
              END IF
           END IF

#       ON ACTION next
#          CALL t290_fetch('N')
 
#       ON ACTION previous
#          CALL t290_fetch('P')
 
#       ON ACTION modify
#          LET g_action_choice="modify"
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL t290_u('w')
           END IF   
 
#       ON ACTION delete
#           LET g_action_choice="delete"
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL t290_r()
           END IF
 
#       ON ACTION reproduce
#          LET g_action_choice="reproduce"
#FUN-B90056 MARK---
#        WHEN "reproduce"
#           IF cl_chk_act_auth() THEN
#              CALL t290_copy()
#           END IF 
#FUN-B90056 MARK---   
           
#       ON ACTION confirm
#          LET g_action_choice="confirm"
        WHEN "confirm"
           IF cl_chk_act_auth() THEN
              IF cl_null(g_lnb.lnb05) OR cl_null(g_lnb.lnb02) OR cl_null(g_lnb.lnb04)THEN 
                 CALL cl_err('','alm-423',1)
               ELSE  
                 CALL t290_confirm()
               END IF   
           END IF   
           CALL t290_pic()
                   
#        ON ACTION unconfirm
#           LET g_action_choice="unconfirm"
        WHEN "unconfirm"
           IF cl_chk_act_auth() THEN
              CALL t290_unconfirm()
           END IF   
           CALL t290_pic()
           
#       ON ACTION void
#          LET g_action_choice = "void"
        WHEN "void"
           IF cl_chk_act_auth() THEN 
              CALL t290_v(1)
           END IF    
           CALL t290_pic()
        #FUN-D20039 -----------sta
        WHEN "undo_void"
           IF cl_chk_act_auth() THEN
              CALL t290_v(2)
           END IF
           CALL t290_pic()
        #FUN-D20039 -----------end
        
 #       ON ACTION qianhe
 #          LET g_action_choice = "qianhe"   
 #          IF cl_chk_act_auth() THEN 
 #             CALL t290_qianhe()
 #          END IF 
 #          CALL t290_pic()
#FUN-B90056-------------begin--------------   
#        ON ACTION brand
#           LET g_action_choice = "brand"                   
#           IF cl_chk_act_auth() THEN                                           
#              IF NOT cl_null(g_lnb.lnb01) THEN                     
#                 LET l_msg = "almt2901  '",g_lnb.lnb03,"'  '",g_lnb.lnb01 CLIPPED,"'"
#                 CALL cl_cmdrun_wait(l_msg)                               
#              ELSE                          
#                  CALL cl_err('',-400,1)                 
#              END IF                                              
#           END IF                    
#                     
#        ON ACTION business
#           LET g_action_choice = "business"                                     
#           IF cl_chk_act_auth() THEN              
#              IF NOT cl_null(g_lnb.lnb01) THEN               
#                LET l_msg = "almt2902  '",g_lnb.lnb03,"'  '",g_lnb.lnb01 CLIPPED,"'"
#                CALL cl_cmdrun_wait(l_msg)                
#              ELSE                  
#                CALL cl_err('',-400,1)                                        
#              END IF                                               
#          END IF    
#          
#       ON ACTION check_expense
#          LET g_action_choice = "check_expense"                 
#          IF cl_chk_act_auth() THEN 
#            #LET l_msg = "almi010  '' ''  '",g_lnb.lnb01,"'"     #FUN-A80073 ---mark---
#             LET l_msg = "artt610  '' ''  '",g_lnb.lnb01,"'"     #FUN-A80073 almi010棄用，改為artt610
#             CALL cl_cmdrun_wait(l_msg)           
#          ELSE
#             CALL cl_err('',-4001,1)
#          END IF 
#    
#        ON ACTION gen_expense        #FUN-AA0078
#       #MOD-AC0365 Begin---
#           LET g_action_choice = "gen_expense"
#           IF cl_chk_act_auth() THEN
#              CALL t290_gen_lua()
#           END IF
#FUN-B90056-------------end---------------
       #   LET l_flag = 'Y'          #No.FUN-A80105  
       #   LET g_action_choice = "gen_expense"
       #   IF cl_chk_act_auth() THEN                   
       #         IF NOT cl_null(g_lnb.lnb01) THEN                   
       #            IF g_lnb.lnb33 != 'Y' THEN
       #               CALL cl_err('','alm-238',1)
       #            ELSE             
       #              
       ##  SELECT tqa06 INTO l_tqa06 FROM tqa_file
       ##   WHERE tqa03 = '14'       	 
       ##     AND tqaacti = 'Y'
       ##     AND tqa01 IN(SELECT tqb03 FROM tqb_file
       ##                   WHERE tqbacti = 'Y'
       ##                     AND tqb09 = '2'
       ##                     AND tqb01 = g_plant) 
       ##  IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN 
       ##     CALL cl_err('','alm-619',1)            
       ##  ELSE
       #      LET l_lua01 = null
       #      SELECT lua01 INTO l_lua01 FROM lua_file
       #       WHERE lua12 = g_lnb.lnb01
       #      IF cl_null(l_lua01) THEN
       #         SELECT rye03 INTO g_lua01 FROM rye_file
       #         WHERE rye01 = 'art' AND rye02 = 'B9'
       #         LET g_dd = g_today
       #         OPEN WINDOW t290_1_w WITH FORM "alm/42f/almt290_1"
       #           ATTRIBUTE(STYLE=g_win_style CLIPPED)
       #           CALL cl_ui_locale("almt290_1")
       #        DISPLAY g_lua01 TO FORMONLY.g_lua01
       #        DISPLAY g_dd TO FORMONLY.g_dd
       #        INPUT  BY NAME g_lua01,g_dd   WITHOUT DEFAULTS
       #         BEFORE INPUT
       #            
       #         AFTER FIELD g_lua01
       #            SELECT COUNT(*) INTO  l_n1 FROM oay_file
       #             WHERE oaysys ='art' AND oaytype ='B9' AND oayslip = g_lua01
       #            IF l_n1 = 0 THEN 
       #               CALL cl_err(g_lua01,'art-800',0)
       #               NEXT FIELD g_lua01
       #            END IF
       #            
       #         ON ACTION CONTROLR
       #            CALL cl_show_req_fields()
 
       #         ON ACTION CONTROLG
       #            CALL cl_cmdask()
 
       #         ON ACTION CONTROLF
       #            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
       #            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

       #         ON ACTION controlp
       #            CASE
       #               WHEN INFIELD(g_lua01)
       #               CALL cl_init_qry_var()
       #               LET g_qryparam.form ="q_slip"
       #               LET g_qryparam.default1 = g_lua01
       #               CALL cl_create_qry() RETURNING g_lua01
       #               DISPLAY BY NAME g_lua01
       #               NEXT FIELD g_lua01
       #            OTHERWISE EXIT CASE
       #            END CASE
       #         ON IDLE g_idle_seconds
       #            CALL cl_on_idle()
       #            CONTINUE INPUT
 
       #         ON ACTION about
       #            CALL cl_about()
  
       #         ON ACTION HELP
       #            CALL cl_show_help()
 
       #       END INPUT  
       #        IF INT_FLAG THEN
       #            LET INT_FLAG=0
       #            LET l_flag = 'N'
       #            CALL cl_err('',9001,0)
       #        END IF
       #        CLOSE WINDOW t290_1_w 
       #         ####自動編號
       #   #      LET g_kindslip = s_get_doc_no(g_lnb.lnb01)  #根據單據編號獲取單別
       # #FUN-A70130 ------------------start-----------------------------------
       # #        SELECT lrkdmy3 INTO l_lrkdmy3 FROM lrk_file 
       # #         WHERE lrkslip = g_kindslip 
       # #        SELECT lrkkind INTO l_lrkkind FROM lrk_file
       # #         WHERE lrkslip = l_lrkdmy3
       # #FUN-A70130 ------------------end-------------------------------------
       #       IF l_flag = 'Y' THEN
       #         CALL s_check_no("art",g_lua01,"",'B9',"lua_file","lua01","")        #FUN-A70130     #No.FUN-A80105  
       #            RETURNING li_result,l_lua01
     
       #         CALL s_auto_assign_no("art",g_lua01,g_dd,'B9',"lua_file","lua01","","","")    #FUN-A70130   #No.FUN-A80105 
       #            RETURNING li_result,l_lua01  
       #      IF li_result THEN                    
       #         SELECT azw02 INTO l_azw02 FROM azw_file
       #          WHERE azw01 = g_lnb.lnb03
 
       #         INSERT INTO lua_file(luaplant,lualegal,lua01,lua02,lua03,lua04,lua05,lua06,
       #                              lua061,lua07,lua21,lua22,lua23,lua08,lua08t,lua09,
       #                              lua10,lua11,lua12,lua13,lua14,lua15,lua16,lua17,lua19,  #FUN-A80073 加lua19
       #                              lua18,luauser,luacrat,luamodu,luaacti,luagrup,luadate,luaoriu,luaorig,lua32)         
       #        #VALUES(g_lnb.lnb03,l_azw02,l_lua01,'01','','','1','MISC',      #FUN-AC0062
       #         VALUES(g_lnb.lnb03,l_azw02,l_lua01,'01','','',' ','MISC',      #FUN-AC0062
       #                g_lnb.lnb05 ,'',g_lnb.lnb37,g_gec04,g_gec07,'0','0',g_dd,
       #                'Y','4',g_lnb.lnb01,'N','0','N','','',g_lnb.lnb03,        #FUN-A80073 lua11的值給4,lua19的值為g_lnb.lnb03
       #                '',g_user,g_today,'','Y',g_grup,'', g_user, g_grup,'1')       #No.FUN-980030 10/01/04  insert columns oriu, orig
       #         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       #            CALL cl_err('insert lua_file:',SQLCA.SQLCODE,0) 
       #         END IF 
       #        ELSE
       #           CALL cl_err('','alm-859',0) 
       #        END IF
       #        END IF
       #      END IF     
       #      #IF cl_chk_act_auth() THEN                   
       #      #   IF NOT cl_null(g_lnb.lnb01) THEN                   
       #      #      IF g_lnb.lnb33 != 'Y' THEN
       #      #         CALL cl_err('','alm-238',1)
       #      #      ELSE             
       #      #      CALL cl_cmdrun_wait(l_msg) 
       #      #      END IF
       #      #   ELSE
       #      #      CALL cl_err('',-400,1)                                                             
       #      #   END IF                                                                                 
       #      #END IF 
       #              #LET l_msg = "almi010  '",l_lua01,"'  ''  ''"         #FUN-A80073 ---mark---
       #             IF l_flag = 'Y' THEN  
       #               LET l_msg = "artt610  '",l_lua01,"'  ''  ''"         #FUN-A80073 almi010棄用，改為artt610
       #               CALL cl_cmdrun_wait(l_msg) 
       #             END IF
       #            END IF
       #         ELSE
       #            CALL cl_err('',-400,1)                                                             
       #         END IF                                                                                 
       #      END IF
       #MOD-AC0365 End-----

#        ON ACTION help
#           CALL cl_show_help()
# 
#        ON ACTION exit
#           LET g_action_choice = "exit"
#           EXIT MENU
# 
#        ON ACTION jump
#           CALL t290_fetch('/')
# 
#        ON ACTION first
#           CALL t290_fetch('F')
# 
#        ON ACTION last
#           CALL t290_fetch('L')
# 
#        ON ACTION controlg
         WHEN "controlg"
            CALL cl_cmdask()
# 
#        ON ACTION locale
#           CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont() 
#           CALL t290_pic() 
#           
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE MENU
# 
#        ON ACTION about 
#           CALL cl_about() 
# 
#        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
#           LET INT_FLAG = FALSE 
#           LET g_action_choice = "exit"
#           EXIT MENU
# 
        WHEN "exit"
           EXIT WHILE
#       ON ACTION related_document 
#          LET g_action_choice="related_document"
        WHEN "related_document"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_lnb.lnb01) THEN
                 LET g_doc.column1 = "lnb01"
                 LET g_doc.value1 = g_lnb.lnb01
                 CALL cl_doc()
              END IF
           END IF
      END CASE
    END WHILE 
#   END MENU
    CLOSE t290_cs
   #FUN-B90056 Add&Mark End -----
END FUNCTION

#FUN-B90056----begin-----
FUNCTION t290_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_lnd TO s_lnd.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION detail
            LET g_action_choice = "detail"
            LET g_flag_b = '1'
            LET l_ac1 = 1
            EXIT DIALOG

         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac1 = ARR_CURR()
            EXIT DIALOG
      END DISPLAY

      DISPLAY ARRAY g_lnc TO s_lnc.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION detail
            LET g_action_choice = "detail"
            LET g_flag_b = '2'
            LET l_ac2 = 1
            EXIT DIALOG

         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac2 = ARR_CURR()
            EXIT DIALOG
      END DISPLAY

      ON ACTION insert
         LET g_action_choice = "insert"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice = "query"
         EXIT DIALOG

      ON ACTION modify
         LET g_action_choice = "modify"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice = "delete"
         EXIT DIALOG

      ON ACTION first
         CALL t290_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DIALOG

      ON ACTION previous
         CALL t290_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DIALOG

      ON ACTION jump
         CALL t290_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DIALOG

      ON ACTION next
         CALL t290_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DIALOG

      ON ACTION last
         CALL t290_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DIALOG

#FUN-B90056 MARK---
#      ON ACTION reproduce
#         LET g_action_choice = "reproduce"
#         EXIT DIALOG
#FUN-B90056 MARK---

      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT DIALOG

      ON ACTION unconfirm
         LET g_action_choice = "unconfirm"
         EXIT DIALOG

      ON ACTION void
         LET g_action_choice = "void"
         EXIT DIALOG
      #FUN-D20039 -------------sta
      ON ACTION undo_void
         LET g_action_choice = "undo_void"
         EXIT DIALOG
      #FUN-D20039 -------------end

      ON ACTION help
         CALL cl_show_help()

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION close
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG

      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 
#FUN-B90056----end-------

#MOD-AC0365 Begin---
FUNCTION t290_gen_lua()
 DEFINE l_cnt        LIKE type_file.num5
 DEFINE li_result    LIKE type_file.num5
 DEFINE l_azw02      LIKE azw_file.azw02
 DEFINE l_msg        LIKE type_file.chr1000
 DEFINE l_lua01      LIKE lua_file.lua01

   IF cl_null(g_lnb.lnb01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lnb.* FROM lnb_file WHERE lnb01 = g_lnb.lnb01
   IF g_lnb.lnb33 != 'Y' THEN
      CALL cl_err('','alm-238',1)
      RETURN
   END IF
   IF g_lnb.lnb03 <> g_plant THEN
      CALL cl_err('','alm-612',1)
      RETURN
   END IF

   LET l_cnt=0
   SELECT count(*) INTO l_cnt FROM lua_file
    WHERE lua12 = g_lnb.lnb01
   IF l_cnt=0 THEN
      #FUN-C90050 mark begin---
      #SELECT rye03 INTO g_lua01 FROM rye_file
      # WHERE rye01 = 'art' AND rye02 = 'B9'
      #FUN-C90050 mark end-----

      CALL s_get_defslip('art','B9',g_plant,'N') RETURNING g_lua01     #FUN-C90050 add

      LET g_dd = g_today
      OPEN WINDOW t290_1_w WITH FORM "alm/42f/almt290_1"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
      CALL cl_ui_locale("almt290_1")
      DISPLAY g_lua01 TO FORMONLY.g_lua01
      DISPLAY g_dd TO FORMONLY.g_dd
      INPUT  BY NAME g_lua01,g_dd   WITHOUT DEFAULTS
         BEFORE INPUT

         AFTER FIELD g_lua01
            LET l_cnt = 0
            SELECT COUNT(*) INTO  l_cnt FROM oay_file
             WHERE oaysys ='art' AND oaytype ='B9' AND oayslip = g_lua01
            IF l_cnt = 0 THEN
               CALL cl_err(g_lua01,'art-800',0)
               NEXT FIELD g_lua01
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

         ON ACTION controlp
            CASE
               WHEN INFIELD(g_lua01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_slip"
                  LET g_qryparam.default1 = g_lua01
                  CALL cl_create_qry() RETURNING g_lua01
                  DISPLAY BY NAME g_lua01
                  NEXT FIELD g_lua01
               OTHERWISE EXIT CASE
            END CASE
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
            CALL cl_about()

         ON ACTION HELP
            CALL cl_show_help()
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CALL cl_err('',9001,0)
         RETURN
      END IF
      CLOSE WINDOW t290_1_w
      ####自動編號
      CALL s_check_no("art",g_lua01,"",'B9',"lua_file","lua01","")
         RETURNING li_result,l_lua01

      CALL s_auto_assign_no("art",g_lua01,g_dd,'B9',"lua_file","lua01","","","")
         RETURNING li_result,l_lua01
      IF NOT li_result THEN
         CALL cl_err('','alm-859',0)
         RETURN
      END IF
      SELECT azw02 INTO l_azw02 FROM azw_file
       WHERE azw01 = g_lnb.lnb03

      INSERT INTO lua_file(luaplant,lualegal,lua01,lua02,lua03,lua04,lua05,lua06,
                             lua061,lua07,lua21,lua22,lua23,lua08,lua08t,lua09,
                             lua10,lua11,lua12,lua13,lua14,lua15,lua16,lua17,lua19,  #FUN-A80073 加lua19
                             lua18,luauser,luacrat,luamodu,luaacti,luagrup,luadate,luaoriu,luaorig,lua32)
       VALUES(g_lnb.lnb03,l_azw02,l_lua01,'01','','',' ','MISC',
               g_lnb.lnb05 ,'',g_lnb.lnb37,g_gec04,g_gec07,'0','0',g_dd,
               'Y','4',g_lnb.lnb01,'N','0','N','','',g_lnb.lnb03,
               '',g_user,g_today,'','Y',g_grup,'', g_user, g_grup,'1')
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('insert lua_file:',SQLCA.SQLCODE,0)
         RETURN
      END IF
   END IF
   LET l_msg = "artt610  ' '  ''  '",g_lnb.lnb01,"'"
   CALL cl_cmdrun_wait(l_msg)
END FUNCTION
#MOD-AC0365 End-----
 
FUNCTION t290_a()
DEFINE li_result     LIKE type_file.num5 
 
    MESSAGE ""
    CLEAR FORM    
    INITIALIZE g_lnb.*    LIKE lnb_file.*       
    INITIALIZE g_lnb_t.*  LIKE lnb_file.*
    INITIALIZE g_lnb_o.*  LIKE lnb_file.*     
    CALL g_lnd.clear()                   #FUN-B90056 add
    CALL g_lnc.clear()                   #FUN-B90056 add
   
     LET g_lnb02   = NULL
     LET g_lnb01_t = NULL
     LET g_wc = NULL
     CALL cl_opmsg('a')     
     
     WHILE TRUE
        LET g_lnb.lnbuser = g_user
        LET g_lnb.lnboriu = g_user #FUN-980030
        LET g_lnb.lnborig = g_grup #FUN-980030
        LET g_lnb.lnbgrup = g_grup  
        LET g_lnb.lnbcrat = g_today
        LET g_lnb.lnb24   = 0
        LET g_lnb.lnb29   = 0
        LET g_lnb.lnb31   = 'N'
        LET g_lnb.lnb32   = '0'
        LET g_lnb.lnb33   = 'N'
        LET g_lnb.lnb27   = 'N' 
       CALL t290_i('a','a')   
 
        IF INT_FLAG THEN  
           LET INT_FLAG = 0
           INITIALIZE g_lnb.* TO NULL
           LET g_lnb01_t = NULL           
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF cl_null(g_lnb.lnb01) THEN    
           CONTINUE WHILE
        END IF        
      #####自動編號#############
      BEGIN WORK
      #CALL s_auto_assign_no("alm",g_lnb.lnb01,g_lnb.lnbcrat,'16',"lnb_file","lnb01","","","") #FUN-A70130
      CALL s_auto_assign_no("alm",g_lnb.lnb01,g_lnb.lnbcrat,'L5',"lnb_file","lnb01","","","") #FUN-A70130
         RETURNING li_result,g_lnb.lnb01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lnb.lnb01
      ##########################     
                  
        INSERT INTO lnb_file VALUES(g_lnb.*)                   
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        #   ROLLBACK WORK          # FUN-B80060 下移兩行
           CALL cl_err(g_lnb.lnb01,SQLCA.SQLCODE,0)
           ROLLBACK WORK          # FUN-B80060
           CONTINUE WHILE
        ELSE
           COMMIT WORK
           SELECT * INTO g_lnb.* FROM lnb_file
              WHERE lnb01 = g_lnb.lnb01
        END IF
       #FUN-B90056 Add Begin ---
        LET g_lnb_t.* = g_lnb.*              #FUN-B90056 add
        LET g_rec_b1 = 0
        LET g_rec_b2 = 0
        CALL t290_b()
       #FUN-B90056 Add End -----
        EXIT WHILE
    END WHILE
    LET g_wc = NULL
END FUNCTION

FUNCTION t290_i(p_cmd,w_cmd)
DEFINE  p_cmd      LIKE type_file.chr1 
DEFINE  w_cmd      LIKE type_file.chr1
DEFINE  l_cnt      LIKE type_file.num5 
DEFINE  l_n        LIKE type_file.num5                #FUN-B90056 add
DEFINE  l_gecacti  LIKE gec_file.gecacti
DEFINE  l_gec02    LIKE gec_file.gec02
DEFINE  l_gec04    LIKE gec_file.gec04
DEFINE  l_gec07    LIKE gec_file.gec07  
DEFINE  l_oag02    LIKE oag_file.oag02
DEFINE  l_nmaacti  LIKE nma_file.nmaacti
DEFINE  l_ool02    LIKE ool_file.ool02
DEFINE  l_azi02    LIKE azi_file.azi02
DEFINE  l_aziacti  LIKE azi_file.aziacti
DEFINE  l_nma02    LIKE nma_file.nma02
DEFINE  l_count    LIKE type_file.num5 
DEFINE  li_result  LIKE type_file.num5 
 
#   DISPLAY BY NAME  g_lnb.lnb31,g_lnb.lnb32,g_lnb.lnb33,g_lnb.lnbuser,g_lnb.lnbgrup,        #FUN-B20038 mark
    DISPLAY BY NAME g_lnb.lnb33,g_lnb.lnbuser,g_lnb.lnbgrup,                                 #FUN-B20038
                    g_lnb.lnbcrat,g_lnb.lnbmodu,g_lnb.lnbdate                    
    LET g_lnb02_t = g_lnb.lnb02
    INPUT BY NAME   g_lnb.lnb01,g_lnb.lnb02,g_lnb.lnb03,g_lnb.lnb04,g_lnb.lnb05, g_lnb.lnboriu,g_lnb.lnborig,
                    g_lnb.lnb06,g_lnb.lnb07,g_lnb.lnb08,g_lnb.lnb09,g_lnb.lnb10,
                    g_lnb.lnb12,g_lnb.lnb13,g_lnb.lnb14,g_lnb.lnb15,g_lnb.lnb16,
                    g_lnb.lnb17,g_lnb.lnb18,g_lnb.lnb19,g_lnb.lnb20,g_lnb.lnb21,
#                   g_lnb.lnb22,g_lnb.lnb23,g_lnb.lnb24,g_lnb.lnb27,g_lnb.lnb28,    #FUN-B90056 mark
                    g_lnb.lnb22,g_lnb.lnb28,g_lnb.lnb23,g_lnb.lnb24,                #FUN-B90056      
#                   g_lnb.lnb29,g_lnb.lnb26,g_lnb.lnb25,g_lnb.lnb30,g_lnb.lnb36,    #FUN-B90056 mark
                    g_lnb.lnb36,                                                    #FUN-B90056 
                    g_lnb.lnb37,g_lnb.lnb38,g_lnb.lnb39,g_lnb.lnb52,g_lnb.lnb53,
                    g_lnb.lnb40,g_lnb.lnb41,g_lnb.lnb42,g_lnb.lnb43,g_lnb.lnb44,
                    g_lnb.lnb45,g_lnb.lnb46,g_lnb.lnb47,g_lnb.lnb49,g_lnb.lnb50,
                    g_lnb.lnb51
    WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE  
          CALL t290_set_entry(p_cmd)        
          CALL t290_set_no_entry(p_cmd)  
          CALL cl_set_docno_format("lnb01")      
          LET g_before_input_done = TRUE
          
      AFTER FIELD lnb01 
          IF NOT cl_null(g_lnb.lnb01) AND (cl_null(g_lnb_t.lnb01) 
              OR (g_lnb.lnb01 != g_lnb_t.lnb01)) THEN
            #CALL s_check_no("alm",g_lnb.lnb01,g_lnb01_t,'16',"lnb_file","lnb01","") #FUN-A70130
             CALL s_check_no("alm",g_lnb.lnb01,g_lnb01_t,'L5',"lnb_file","lnb01","") #FUN-A70130
                 RETURNING li_result,g_lnb.lnb01
             IF (NOT li_result) THEN
                LET g_lnb.lnb01=g_lnb_t.lnb01
                NEXT FIELD lnb01
             END IF
             DISPLAY BY NAME g_lnb.lnb01
          END IF           
      AFTER FIELD lnb02
      #    LET g_lnb02 = NULL 
          IF NOT cl_null(g_lnb.lnb02) THEN 
             IF (p_cmd = 'a' AND w_cmd = 'a') OR
          #     (p_cmd = 'u' AND w_cmd = 'u' AND g_lnb.lnb02 != g_lnb_t.lnb02) OR 
                (p_cmd = 'u' AND w_cmd = 'u' AND g_lnb.lnb02 != g_lnb02_t) OR
                (p_cmd = 'u' AND w_cmd = 'h') THEN
                CALL t290_check_lnb02(p_cmd)
                IF g_success = 'N' THEN                                                  
                   DISPLAY BY NAME g_lnb.lnb02                                                    
                   NEXT FIELD lnb02 
                ELSE
                   LET g_lnb02_t = g_lnb.lnb02
                   CALL t290_xxx()             	                 	           	   
                END IF
             END IF 
          END IF       
   

      #TQC-B50102--add--str--
      AFTER FIELD lnb03
         IF NOT cl_null(g_lnb.lnb03) THEN
            CALL t290_xxx_lnb03(g_lnb.lnb03)
         ELSE
            DISPLAY  ''  TO FORMONLY.rtz13      
         END IF
      #TQC-B50102--add--end--

      AFTER FIELD lnb08
         IF NOT cl_null(g_lnb.lnb08) THEN 
            CALL t290_xxx_lnb08(g_lnb.lnb08)
            IF g_success = 'N' THEN 
                LET g_lnb.lnb08 = g_lnb_t.lnb08
                DISPLAY BY NAME g_lnb.lnb08
                NEXT FIELD lnb08
             ELSE
             	  CALL t290_xxx_lnb081(g_lnb.lnb08)   
             END IF    
         END IF       
#FUN-AA0071---------------add---------------str----------
          IF cl_null(g_lnb.lnb08) THEN
             DISPLAY '' TO FORMONLY.tqa02
          END IF
#FUN-AA0071---------------add---------------end----------
     
     BEFORE FIELD lnb09 
       IF cl_null(g_lnb.lnb02) THEN 
            CALL cl_err('','alm-413',1)
            NEXT FIELD lnb02 
         END IF       
     
     AFTER FIELD lnb09
         IF NOT cl_null(g_lnb.lnb09) THEN 
            CALL t290_xxx_lnb09(g_lnb.lnb09)
            IF g_success = 'N' THEN 
                LET g_lnb.lnb08 = g_lnb_t.lnb09
                DISPLAY BY NAME g_lnb.lnb09
                NEXT FIELD lnb09
             ELSE
             	  CALL t290_xxx_lnb091(g_lnb.lnb09)   
             END IF    
         END IF  
     
     BEFORE FIELD lnb10 
        IF cl_null(g_lnb.lnb02) THEN 
            CALL cl_err('','alm-413',1)
            NEXT FIELD lnb02 
         END IF 
         
      BEFORE FIELD lnb12
        IF cl_null(g_lnb.lnb02) THEN 
            CALL cl_err('','alm-413',1)
            NEXT FIELD lnb02 
         END IF 
         
      BEFORE FIELD lnb13
        IF cl_null(g_lnb.lnb02) THEN 
            CALL cl_err('','alm-413',1)
            NEXT FIELD lnb02 
         END IF 
      
      BEFORE FIELD lnb14 
        IF cl_null(g_lnb.lnb02) THEN 
            CALL cl_err('','alm-413',1)
            NEXT FIELD lnb02 
         END IF 
       
       BEFORE FIELD lnb15
         IF cl_null(g_lnb.lnb02) THEN 
            CALL cl_err('','alm-413',1)
            NEXT FIELD lnb02 
         END IF 
       
       BEFORE FIELD lnb16
         IF cl_null(g_lnb.lnb02) THEN 
            CALL cl_err('','alm-413',1)
            NEXT FIELD lnb02 
         END IF 
             
       BEFORE FIELD lnb17
         IF cl_null(g_lnb.lnb02) THEN 
            CALL cl_err('','alm-413',1)
            NEXT FIELD lnb02 
         END IF 
       
       BEFORE FIELD lnb18 
        IF cl_null(g_lnb.lnb02) THEN 
            CALL cl_err('','alm-413',1)
            NEXT FIELD lnb02 
         END IF 
         
       BEFORE FIELD lnb19 
         IF cl_null(g_lnb.lnb02) THEN 
            CALL cl_err('','alm-413',1)
            NEXT FIELD lnb02 
         END IF 
       
       BEFORE FIELD lnb20
         IF cl_null(g_lnb.lnb02) THEN 
            CALL cl_err('','alm-413',1)
            NEXT FIELD lnb02 
         END IF 
         
       BEFORE FIELD lnb21
        IF cl_null(g_lnb.lnb02) THEN 
            CALL cl_err('','alm-413',1)
            NEXT FIELD lnb02 
         END IF 
        
        BEFORE FIELD lnb22 
         IF cl_null(g_lnb.lnb02) THEN 
            CALL cl_err('','alm-413',1)
            NEXT FIELD lnb02 
         END IF 
         
         BEFORE FIELD lnb23 
           IF cl_null(g_lnb.lnb02) THEN 
            CALL cl_err('','alm-413',1)
            NEXT FIELD lnb02 
         END IF 
        
        BEFORE FIELD lnb24 
         IF cl_null(g_lnb.lnb02) THEN 
            CALL cl_err('','alm-413',1)
            NEXT FIELD lnb02 
         END IF 
                           
     
        AFTER FIELD lnb24 
            IF NOT cl_null(g_lnb.lnb24) THEN
               IF g_lnb.lnb24 < 0 THEN 
                  CALL cl_err('','alm-236',1)
                  NEXT FIELD lnb24 
               END IF 
            END IF 
#FUN-B90056-------------begin--------------         
#        AFTER FIELD lnb26
#            IF NOT cl_null(g_lnb.lnb26) THEN 
#              IF (p_cmd='a' AND w_cmd='a') OR 
#                 (p_cmd = 'u' AND w_cmd = 'u' AND g_lnb.lnb26 != g_lnb_t.lnb26) OR
#                 (p_cmd='u' AND w_cmd = 'h') OR 
#                 (p_cmd = 'u' AND w_cmd = 'u' AND g_lnb_t.lnb26 IS NULL) THEN 
#                 LET l_count = 0 
#                 SELECT COUNT(*) INTO l_count FROM lnb_file
#                  WHERE lnb26 = g_lnb.lnb26
#                  IF l_count > 0 THEN 
#                    CALL cl_err('','alm-625',1)
#                    NEXT FIELD lnb26       	
#                  END IF  
#               END IF 
#            END IF 
#            
#       AFTER FIELD lnb29 
#         IF NOT cl_null(g_lnb.lnb29) THEN
#            IF g_lnb.lnb29 < 0 THEN 
#               CALL cl_err('','alm-241',1)
#               NEXT FIELD lnb29 
#            END IF 
#         END IF    
#FUN-B90056-------------end---------------      
   # AFTER FIELD lnb25
   #     IF NOT cl_null(g_lnb.lnb25) AND NOT cl_null(g_lnb.lnb30) THEN
   #        IF (p_cmd = 'a' AND w_cmd = 'a') OR  
   #           (p_cmd = 'u' AND w_cmd = 'u' AND g_lnb.lnb25 != g_lnb_t.lnb25) OR
   #           (p_cmd = 'u' AND w_cmd = 'u' AND g_lnb_t.lnb25 IS NULL) OR
   #           (p_cmd = 'u' AND w_cmd ='h') THEN 
   #          LET l_cnt = 0 
   #          SELECT COUNT(*) INTO l_cnt FROM lnb_file
   #           WHERE lnb25 = g_lnb.lnb25
   #             AND lnb30 = g_lnb.lnb30          
   #         IF l_cnt > 0 THEN 
   #            CALL cl_err('','alm-140',0)
   #            DISPLAY BY NAME g_lnb.lnb25
   #            NEXT FIELD lnb25
   #         END IF   
   #       END IF   
   #     END IF 
   #   
   # AFTER FIELD lnb30  
   #    IF NOT cl_null(g_lnb.lnb30) AND NOT cl_null(g_lnb.lnb35) THEN
   #        IF (p_cmd = 'a' AND w_cmd = 'a') OR  
   #           (p_cmd = 'u' AND w_cmd = 'u' AND g_lnb.lnb30 != g_lnb_t.lnb30) OR
   #           (p_cmd = 'u' AND w_cmd = 'u' AND g_lnb_t.lnb30 IS NULL) OR 
   #           (p_cmd = 'u' AND w_cmd ='h') THEN 
   #          LET l_cnt = 0 
   #          SELECT COUNT(*) INTO l_cnt FROM lnb_file
   #           WHERE lnb25 = g_lnb.lnb25
   #             AND lnb30 = g_lnb.lnb30          
   #         IF l_cnt > 0 THEN 
   #            CALL cl_err('','alm-140',0)
   #            DISPLAY BY NAME g_lnb.lnb30
   #            NEXT FIELD lnb30
   #         END IF   
   #       END IF   
   #     END IF 
       
     AFTER FIELD lnb37
          IF NOT cl_null(g_lnb.lnb37) THEN 
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM gec_file
              WHERE gec01 = g_lnb.lnb37
                AND gec011 = '2'
              IF l_cnt < 1 THEN 
                 CALL cl_err('','alm-141',0)
                 LET g_lnb.lnb37 = g_lnb_t.lnb37
                 DISPLAY BY NAME g_lnb.lnb37
                 NEXT FIELD lnb37
              ELSE
              	 SELECT gecacti INTO l_gecacti FROM gec_file
              	  WHERE gec01 = g_lnb.lnb37
              	    AND gec011 = '2'
              	 IF l_gecacti != 'Y' THEN 
              	    CALL cl_err('','alm-142',0)
                    LET g_lnb.lnb37 = g_lnb_t.lnb37
                    DISPLAY BY NAME g_lnb.lnb37
                    NEXT FIELD lnb37   
                 ELSE
                 	  SELECT gec02,gec04,gec07 INTO l_gec02,l_gec04,l_gec07
                 	    FROM gec_file
                 	   WHERE gec01 = g_lnb.lnb37
                 	     AND gec011 = '2'
                 	  DISPLAY l_gec02 TO FORMONLY.gec02     
                 	  DISPLAY l_gec04 TO FORMONLY.gec04 
                 	  DISPLAY l_gec07 TO FORMONLY.gec07 
                 	  LET g_gec02 = g_lnb.lnb37
                 	  LET g_gec04 = l_gec04
                 	  LET g_gec07 = l_gec07
                 END IF    
              END IF    
           ELSE
           	   DISPLAY '' TO FORMONLY.gec02
           	   DISPLAY '' TO FORMONLY.gec04
           	   DISPLAY '' TO FORMONLY.gec07 
           	   LET g_gec02 = NULL
           	   LET g_gec04 = NULL
           	   LET g_gec07 = NULL                                  
          END IF 
      
     AFTER FIELD lnb39
          IF NOT cl_null(g_lnb.lnb39) THEN 
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM oag_file
              WHERE oag01 = g_lnb.lnb39
             IF l_cnt < 1 THEN 
                CALL cl_err('','alm-143',0)
                LET g_lnb.lnb39 = g_lnb_t.lnb39
                DISPLAY BY NAME g_lnb.lnb39
                NEXT FIELD lnb39
             ELSE
             	  SELECT oag02 INTO l_oag02 FROM oag_file
             	   WHERE oag01 = g_lnb.lnb39
             	   DISPLAY l_oag02 TO FORMONLY.oag02    
             END IF     
          END IF  
      
     AFTER FIELD lnb47
          IF NOT cl_null(g_lnb.lnb47) THEN 
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM nma_file
              WHERE nma01 = g_lnb.lnb47
             IF l_cnt < 1 THEN 
                CALL cl_err('','alm-144',0)
                LET g_lnb.lnb47 = g_lnb_t.lnb47
                DISPLAY BY NAME g_lnb.lnb47
                NEXT FIELD lnb47
             ELSE
             	 SELECT nmaacti INTO l_nmaacti FROM nma_file
             	   WHERE nma01 = g_lnb.lnb47
             	   IF l_nmaacti != 'Y' THEN 
             	      CALL cl_err('','alm-004',0)
             	      LET g_lnb.lnb47 = g_lnb_t.lnb47
                    DISPLAY BY NAME g_lnb.lnb47
                    NEXT FIELD lnb47
                 ELSE
                 	   SELECT nma02 INTO l_nma02 FROM nma_file
             	       WHERE nma01 = g_lnb.lnb47
                       LET g_lnb.lnb48 = l_nma02
             	       DISPLAY l_nma02 TO lnb48    
             	   END IF     
             END IF     
          END IF  
    
     AFTER FIELD lnb52
           IF NOT cl_null(g_lnb.lnb52) THEN 
              LET l_cnt = 0 
              SELECT ool02 INTO l_ool02 FROM ool_file
               WHERE ool01 = g_lnb.lnb52
              IF STATUS = 100 THEN
                  CALL cl_err('','alm-145',0)
                  DISPLAY BY NAME g_lnb.lnb52
                  NEXT FIELD lnb52
              END IF
              DISPLAY l_ool02 TO FORMONLY.ool02
           END IF     
    
    AFTER FIELD lnb53
           IF NOT cl_null(g_lnb.lnb53) THEN 
              LET l_cnt = 0 
              SELECT azi02,aziacti INTO l_azi02,l_aziacti
                FROM azi_file
               WHERE azi01 = g_lnb.lnb53
              IF STATUS = 100 THEN
                  CALL cl_err('','alm-146',0)
                  LET g_lnb.lnb53 = g_lnb_t.lnb53
                  DISPLAY BY NAME g_lnb.lnb53
                  NEXT FIELD lnb53
              ELSE
               	   IF l_aziacti != 'Y' THEN 
               	      CALL cl_err('','alm-089',0)
                      LET g_lnb.lnb53 = g_lnb_t.lnb53
                      DISPLAY BY NAME g_lnb.lnb53
                      NEXT FIELD lnb53
               	   END IF    
                 DISPLAY l_azi02 TO FORMONLY.azi02
              END IF
           END IF 
                             
     AFTER INPUT        
        LET g_lnb.lnbuser = s_get_data_owner("lnb_file") #FUN-C10039
        LET g_lnb.lnbgrup = s_get_data_group("lnb_file") #FUN-C10039
        IF INT_FLAG THEN
           LET g_lnb02 = ''
           EXIT INPUT
        ELSE         
           IF g_lnb.lnb04 IS NULL THEN
              LET g_lnb.lnb04 = 'MISC'
           END IF 
           IF NOT cl_null(g_lnb.lnb26) THEN  
             IF (p_cmd = 'a' AND w_cmd= 'a') OR
                (p_cmd = 'u' AND w_cmd = 'u' AND g_lnb.lnb26 != g_lnb_t.lnb26) OR
                (p_cmd = 'u' AND w_cmd = 'h') OR
                (p_cmd = 'u' AND w_cmd = 'u' AND g_lnb_t.lnb26 IS NULL)THEN 
                 LET l_count = 0 
                 SELECT COUNT(*) INTO l_count FROM lnb_file
                  WHERE lnb26 = g_lnb.lnb26
                  IF l_count > 0 THEN 
                    CALL cl_err('','alm-625',1)
                    NEXT FIELD lnb26       	
                  END IF  
              END IF   
           END IF 	
           IF NOT cl_null(g_lnb.lnb05) THEN
             IF (p_cmd = 'a' AND w_cmd = 'a') OR
                (p_cmd = 'u' AND w_cmd = 'u' AND g_lnb.lnb05 != g_lnb_t.lnb05) OR
                (p_cmd = 'u' AND w_cmd = 'h') THEN 
               CALL t290_xxx_lnb05(g_lnb.lnb05)
               IF g_success = 'N' THEN 
                  DISPLAY BY NAME g_lnb.lnb05
                  NEXT FIELD lnb05
                END IF   
               END IF    
           END IF  
     #      IF NOT cl_null(g_lnb.lnb25) AND NOT cl_null(g_lnb.lnb30) THEN   
     #         IF (p_cmd = 'a' AND w_cmd = 'a') OR  
     #            (p_cmd = 'u' AND w_cmd = 'u' AND g_lnb.lnb25 != g_lnb_t.lnb25) OR
     #            (p_cmd = 'u' AND w_cmd = 'u' AND g_lnb_t.lnb25 IS NULL) OR
     #            (p_cmd = 'u' AND w_cmd ='h') THEN 
     #             LET l_cnt = 0 
     #             SELECT COUNT(*) INTO l_cnt FROM lnb_file
     #              WHERE lnb25 = g_lnb.lnb25
     #                AND lnb30 = g_lnb.lnb30
     #             IF l_cnt > 0 THEN 
     #                CALL cl_err('','alm-140',0)
     #                DISPLAY BY NAME g_lnb.lnb25
     #                NEXT FIELD lnb25
     #             END IF   
     #         END IF   
     #      END IF                                                                             
     #      IF NOT cl_null(g_lnb.lnb30) AND NOT cl_null(g_lnb.lnb25) THEN   
     #         IF (p_cmd = 'a' AND w_cmd = 'a') OR  
     #            (p_cmd = 'u' AND w_cmd = 'u' AND g_lnb.lnb30 != g_lnb_t.lnb30) OR
     #            (p_cmd = 'u' AND w_cmd = 'u' AND g_lnb_t.lnb30 IS NULL) OR
     #            (p_cmd = 'u' AND w_cmd ='h') THEN 
     #             LET l_cnt = 0 
     #             SELECT COUNT(*) INTO l_cnt FROM lnb_file
     #              WHERE lnb25 = g_lnb.lnb25
     #                AND lnb30 = g_lnb.lnb30
     #             IF l_cnt > 0 THEN 
     #                CALL cl_err('','alm-140',0)
     #                DISPLAY BY NAME g_lnb.lnb30
     #                NEXT FIELD lnb30
     #             END IF   
     #         END IF 
     #      END IF                                                      
        END IF      
      
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(lnb01)
             LET g_kindslip = s_get_doc_no(g_lnb.lnb01)
            # CALL q_lrk(FALSE,FALSE,g_kindslip,'16','ALM') RETURNING g_kindslip    #FUN-A70130   mark
            CALL q_oay(FALSE,FALSE,g_kindslip,'L5','ALM') RETURNING g_kindslip       #FUN-A70130 add
             LET g_lnb.lnb01 = g_kindslip
             DISPLAY BY NAME g_lnb.lnb01
             NEXT FIELD lnb01
          
          WHEN INFIELD(lnb02)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_lna290"  
            LET g_qryparam.default1 = g_lnb.lnb02
            CALL cl_create_qry() RETURNING g_lnb.lnb02
            DISPLAY BY NAME g_lnb.lnb02
            NEXT FIELD lnb02
            
         WHEN INFIELD(lnb03)
            CALL cl_init_qry_var()
#modify by hellen --begin 090601
#           LET g_qryparam.form = "q_lma290"  
            LET g_qryparam.form = "q_rtz"  
#modify by hellen --end 090601
            LET g_qryparam.default1 = g_lnb.lnb03
            CALL cl_create_qry() RETURNING g_lnb.lnb03
            DISPLAY BY NAME g_lnb.lnb03
            NEXT FIELD lnb03
            
          WHEN INFIELD(lnb08)
            CALL cl_init_qry_var()
#           LET g_qryparam.form = "q_azfp1"    #FUN-A70063 mark
            LET g_qryparam.form = "q_tqap1"    #FUN-A70063 mod
            LET g_qryparam.default1 = g_lnb.lnb08         
            CALL cl_create_qry() RETURNING g_lnb.lnb08
            DISPLAY BY NAME g_lnb.lnb08
            NEXT FIELD lnb08   
          
           WHEN INFIELD(lnb09)
            CALL cl_init_qry_var()
           #LET g_qryparam.form = "q_geo" #TQC-C40051 mark
            LET g_qryparam.form ="q_oqw"  #TQC-C40051 add 
            LET g_qryparam.default1 = g_lnb.lnb09
            CALL cl_create_qry() RETURNING g_lnb.lnb09
            DISPLAY BY NAME g_lnb.lnb09
            NEXT FIELD lnb09
          
           WHEN INFIELD(lnb37)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gec9"  
            LET g_qryparam.default1 = g_lnb.lnb37           
            CALL cl_create_qry() RETURNING g_lnb.lnb37
            DISPLAY BY NAME g_lnb.lnb37
            NEXT FIELD lnb37 
          
           WHEN INFIELD(lnb39)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_oag"  
            LET g_qryparam.default1 = g_lnb.lnb39
            CALL cl_create_qry() RETURNING g_lnb.lnb39
            DISPLAY BY NAME g_lnb.lnb39
            NEXT FIELD lnb39
          
           WHEN INFIELD(lnb47)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_nma"  
            LET g_qryparam.default1 = g_lnb.lnb47
            CALL cl_create_qry() RETURNING g_lnb.lnb47
            DISPLAY BY NAME g_lnb.lnb47
            NEXT FIELD lnb47
            
           WHEN INFIELD(lnb52)
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_ool" 
            LET g_qryparam.default1 = g_lnb.lnb52
            CALL cl_create_qry() RETURNING g_lnb.lnb52
            DISPLAY BY NAME g_lnb.lnb52
            NEXT FIELD lnb52  
           
          WHEN INFIELD(lnb53)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azi"  
            LET g_qryparam.default1 = g_lnb.lnb53
            CALL cl_create_qry() RETURNING g_lnb.lnb53
            DISPLAY BY NAME g_lnb.lnb53
            NEXT FIELD lnb53
            
          OTHERWISE
            EXIT CASE
        END CASE
        
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON ACTION CONTROLF  
        CALL cl_set_focus_form(ui.Interface.getRootNode())
             RETURNING g_fld_name,g_frm_name 
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
 
#FUN-B90056 Add Begin ---
FUNCTION t290_b()
DEFINE l_ac1_t         LIKE type_file.num5,
       l_ac2_t         LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.chr1,
       l_allow_delete  LIKE type_file.chr1
   IF s_shut(0) THEN RETURN END IF
   LET g_action_choice = ""
   SELECT * INTO g_lnb.* FROM lnb_file
    WHERE lnb01   = g_lnb.lnb01

   IF g_lnb.lnb33 = 'Y' THEN
      CALL cl_err(g_lnb.lnb01,'alm-027',1)
     RETURN
   END IF

   IF g_lnb.lnb33 = 'X' THEN
      CALL cl_err(g_lnb.lnb01,'alm-134',1)
     RETURN
   END IF
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_forupd_sql = "SELECT lnd02,'',lnd03,lnd04,lnd05,lnd06 ",
                      "  FROM lnd_file ",
                      " WHERE lnd01 = '",g_lnb.lnb01, 
                      "'  AND lnd02 = ? AND lnd03 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t290_bcl_1 CURSOR FROM g_forupd_sql      # LOCK CURSOR
   LET g_forupd_sql = "SELECT lnc02,'',lnc03,'' FROM lnc_file ",
                      " WHERE lnc01 = '",g_lnb.lnb01,
                      "'  AND lnc02 = ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t290_bcl_2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
   DIALOG ATTRIBUTE(UNBUFFERED)

      INPUT ARRAY g_lnd FROM s_lnd.*
         ATTRIBUTE (COUNT=g_rec_b1,MAXCOUNT=g_max_rec,
                   INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

         BEFORE INPUT
            IF g_rec_b1 != 0 THEN
               CALL fgl_set_arr_curr(l_ac1)
            END IF

         BEFORE ROW
            LET p_cmd=''
            LET l_ac1 = ARR_CURR()
            LET l_lock_sw = 'N'
            LET l_n  = ARR_COUNT()
            IF g_rec_b1>=l_ac1 THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               CALL t290_set_entry_b1(p_cmd)
               CALL t290_set_no_entry_b1(p_cmd)
               LET g_before_input_done = TRUE
               LET g_lnd_t.* = g_lnd[l_ac1].*
               OPEN t290_bcl_1 USING g_lnd_t.lnd02,g_lnd_t.lnd03
               IF STATUS THEN
                  CALL cl_err("OPEN t290_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t290_bcl_1 INTO g_lnd[l_ac1].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_lnd_t.lnd02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL t290_lnd02('d')
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE
            CALL t290_set_entry_b1(p_cmd)
            CALL t290_set_no_entry_b1(p_cmd)
            LET g_before_input_done = TRUE
            INITIALIZE g_lnd[l_ac1].* TO NULL
            LET g_lnd_t.* = g_lnd[l_ac1].*
            CALL cl_show_fld_cont()
            NEXT FIELD lnd02


         AFTER FIELD lnd02
            IF NOT cl_null(g_lnd[l_ac1].lnd02) THEN
               LET l_n = 0
               IF NOT cl_null(g_lnd[l_ac1].lnd03) AND 
                  ((g_lnd[l_ac1].lnd02 != g_lnd_t.lnd02 AND NOT cl_null(g_lnd_t.lnd02)) 
                  OR cl_null(g_lnd_t.lnd02)) THEN 
                  SELECT COUNT(*) INTO l_n
                    FROM lnd_file 
                   WHERE lnd02 = g_lnd[l_ac1].lnd02 
                     AND lnd03 = g_lnd[l_ac1].lnd03
               END IF 
               IF l_n > 0 THEN
                  LET g_lnd[l_ac1].lnd02 = g_lnd_t.lnd02
                  CALL cl_err('','alm-779',0)
                  NEXT FIELD lnd02    
               ELSE  
                  CALL t290_lnd02(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     LET g_lnd[l_ac1].lnd02 = g_lnd_t.lnd02
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD lnd02 
                  END IF 
               END IF    
            END IF 
         AFTER FIELD lnd03
            IF NOT cl_null(g_lnd[l_ac1].lnd03) THEN
               LET l_n = 0
               IF NOT cl_null(g_lnd[l_ac1].lnd02) AND 
                  ((g_lnd[l_ac1].lnd03 != g_lnd_t.lnd03 AND NOT cl_null(g_lnd_t.lnd03))
                  OR cl_null(g_lnd_t.lnd03)) THEN
                  SELECT COUNT(*) INTO l_n
                    FROM lnd_file
                   WHERE lnd02 = g_lnd[l_ac1].lnd02 
                     AND lnd03 = g_lnd[l_ac1].lnd03
               END IF
               IF l_n > 0 THEN
                  LET g_lnd[l_ac1].lnd03 = g_lnd_t.lnd03
                  CALL cl_err('','alm-779',0)
                  NEXT FIELD lnd03
               END IF
            END IF              

       AFTER FIELD lnd05
          IF NOT cl_null(g_lnd[l_ac1].lnd05) THEN
             IF cl_null(g_lnd[l_ac1].lnd06) THEN
                CALL cl_err('','alm-153',0)
                NEXT FIELD lnd06
             ELSE
                  IF g_lnd[l_ac1].lnd05 > g_lnd[l_ac1].lnd06 THEN
                     CALL cl_err('','alm-152',0)
                     NEXT FIELD lnd05
                  END IF
             END IF
          ELSE
                 IF NOT cl_null(g_lnd[l_ac1].lnd06) THEN
                    CALL cl_err('','alm-154',0)
                    NEXT FIELD lnd05
                 END IF
          END IF

       AFTER FIELD lnd06
           IF NOT cl_null(g_lnd[l_ac1].lnd06) THEN
              IF cl_null(g_lnd[l_ac1].lnd05) THEN
                 CALL cl_err('','alm-154',0)
                 NEXT FIELD lnd05
              ELSE
                   IF g_lnd[l_ac1].lnd06 < g_lnd[l_ac1].lnd05 THEN
                      CALL cl_err('','alm-155',0)
                      NEXT FIELD lnd06
                   END IF
              END IF
           ELSE
              IF NOT cl_null(g_lnd[l_ac1].lnd05) THEN
                 CALL cl_err('','alm-153',0)
                 NEXT FIELD lnd06
              END IF
           END IF             

         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE t290_bcl_1
               CANCEL INSERT
            END IF
            INSERT INTO lnd_file(lnd00,lnd01,lnd02,lnd03,lnd04,lnd05,lnd06)
            VALUES(g_lnb.lnb03,g_lnb.lnb01,g_lnd[l_ac1].lnd02,g_lnd[l_ac1].lnd03,
                   g_lnd[l_ac1].lnd04,g_lnd[l_ac1].lnd05,g_lnd[l_ac1].lnd06)

            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","lnd_file",g_lnd[l_ac1].lnd02,"",SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b1=g_rec_b1+1
               DISPLAY g_rec_b1 TO FORMONLY.cn3
               COMMIT WORK
            END IF

         BEFORE DELETE
            IF g_lnd_t.lnd02 IS NOT NULL AND g_lnd_t.lnd03 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL
               LET g_doc.column1 = "lnd02"
               LET g_doc.value1 = g_lnd[l_ac1].lnd02
               CALL cl_del_doc()
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM lnd_file WHERE lnd01 = g_lnb_t.lnb01 
                                      AND lnd02 = g_lnd_t.lnd02
                                      AND lnd03 = g_lnd_t.lnd03

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","lnd_file",g_lnd_t.lnd02,"",SQLCA.sqlcode,"","",1)
                  EXIT DIALOG
               END IF
               LET g_rec_b1=g_rec_b1-1
               DISPLAY g_rec_b1 TO FORMONLY.cn3
               COMMIT WORK
            END IF

         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_lnd[l_ac1].* = g_lnd_t.*
               CLOSE t290_bcl_1
               ROLLBACK WORK
               EXIT DIALOG
            END IF

            IF l_lock_sw="Y" THEN
               CALL cl_err(g_lnd[l_ac1].lnd02,-263,0)
               LET g_lnd[l_ac1].* = g_lnd_t.*
            ELSE
               UPDATE lnd_file SET lnd00 = g_lnb.lnb03,
                                   lnd01 = g_lnb.lnb01,
                                   lnd02 = g_lnd[l_ac1].lnd02,
                                   lnd03 = g_lnd[l_ac1].lnd03,
                                   lnd04 = g_lnd[l_ac1].lnd04,
                                   lnd05 = g_lnd[l_ac1].lnd05,
                                   lnd06 = g_lnd[l_ac1].lnd06
                WHERE lnd03 = g_lnd_t.lnd03
                  AND lnd01 = g_lnb_t.lnb01
                  AND lnd02 = g_lnd_t.lnd02

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","lnd_file",g_lnd_t.lnd02,"",SQLCA.sqlcode,"","",1)
                  LET g_lnd[l_ac1].* = g_lnd_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

         AFTER ROW
            LET l_ac1 = ARR_CURR()  
            LET l_ac1_t = l_ac1    

            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_lnd[l_ac1].* = g_lnd_t.*
               END IF
               CLOSE t290_bcl_1
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            CLOSE t290_bcl_1
            COMMIT WORK

         ON ACTION controlp
           CASE
              WHEN INFIELD(lnd02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqa001"
                 LET g_qryparam.default1 = g_lnd[l_ac1].lnd02
                 CALL cl_create_qry() RETURNING g_lnd[l_ac1].lnd02
                 DISPLAY g_lnd[l_ac1].lnd02 TO lnd02
                 CALL t290_lnd02('d')
                 NEXT FIELD lnd02
              OTHERWISE
              EXIT CASE
           END CASE

      END INPUT

      INPUT ARRAY g_lnc FROM s_lnc.*
         ATTRIBUTE (COUNT=g_rec_b2,MAXCOUNT=g_max_rec,
                   INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
            
         BEFORE INPUT
            IF g_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF
               
         BEFORE ROW
            LET p_cmd=''
            LET l_ac2 = ARR_CURR()
            LET l_lock_sw = 'N'
            LET l_n  = ARR_COUNT() 
               
            IF g_rec_b2>=l_ac2 THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               CALL t290_set_entry_b2(p_cmd)
               CALL t290_set_no_entry_b2(p_cmd)
               LET g_before_input_done = TRUE
               LET g_lnc_t.* = g_lnc[l_ac2].*
               OPEN t290_bcl_2 USING g_lnc_t.lnc02
               IF STATUS THEN
                  CALL cl_err("OPEN t290_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t290_bcl_2 INTO g_lnc[l_ac2].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_lnc_t.lnc02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL t290_lnc02('d')
                     CALL t290_lnc03('d')
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE
            CALL t290_set_entry_b2(p_cmd)
            CALL t290_set_no_entry_b2(p_cmd)
            LET g_before_input_done = TRUE
            INITIALIZE g_lnc[l_ac2].* TO NULL
            LET g_lnc_t.* = g_lnc[l_ac2].*
            CALL cl_show_fld_cont()
            NEXT FIELD lnc02

         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE t290_bcl_2
               CANCEL INSERT
            END IF
            INSERT INTO lnc_file(lnc00,lnc01,lnc02,lnc03)
            VALUES(g_lnb.lnb03,g_lnb.lnb01,g_lnc[l_ac2].lnc02,g_lnc[l_ac2].lnc03)

            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","lnc_file",g_lnc[l_ac2].lnc02,"",SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b2=g_rec_b2+1
               DISPLAY g_rec_b2 TO FORMONLY.cn4
               COMMIT WORK
            END IF
    
         AFTER FIELD lnc02
            IF NOT cl_null(g_lnc[l_ac2].lnc02) THEN
               LET l_n = 0
               IF (g_lnc[l_ac2].lnc02 != g_lnc_t.lnc02 
                  AND NOT cl_null(g_lnc_t.lnc02)) OR cl_null(g_lnc_t.lnc02) THEN
                 SELECT COUNT(*) INTO l_n
                   FROM lnc_file 
                  WHERE lnc01 = g_lnb.lnb01
                    AND lnc02 = g_lnc[l_ac2].lnc02
               END IF 
               IF l_n > 0 THEN
                  LET g_lnc[l_ac2].lnc02 = g_lnc_t.lnc02 
                  CALL cl_err('','alm-794',0)
                  NEXT FIELD lnc02
               ELSE
                  CALL t290_lnc02(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     LET g_lnc[l_ac2].lnc02 = g_lnc_t.lnc02
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD lnc02
                  END IF 
               END IF 
            END IF 
         
         AFTER FIELD lnc03
             IF NOT cl_null(g_lnc[l_ac2].lnc03) THEN
                 CALL t290_lnc03(p_cmd) 
                 IF NOT cl_null(g_errno) THEN
                     LET g_lnc[l_ac2].lnc03 = g_lnc_t.lnc03
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD lnc03
                 END IF
             END IF              
  
         BEFORE DELETE
            IF g_lnc_t.lnc02 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL
               LET g_doc.column1 = "lnc02"
               LET g_doc.value1 = g_lnc[l_ac2].lnc02
               CALL cl_del_doc()
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM lnc_file WHERE lnc00 = g_lnb.lnb03
                                      AND lnc01 = g_lnb.lnb01
                                      AND lnc02 = g_lnc_t.lnc02

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","lnc_file",g_lnc_t.lnc02,"",SQLCA.sqlcode,"","",1)
                  EXIT DIALOG
               END IF
               LET g_rec_b2=g_rec_b2-1
               DISPLAY g_rec_b2 TO FORMONLY.cn4
               COMMIT WORK
            END IF

         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_lnc[l_ac2].* = g_lnc_t.*
               CLOSE t290_bcl_2
               ROLLBACK WORK
               EXIT DIALOG
            END IF

            IF l_lock_sw="Y" THEN
               CALL cl_err(g_lnc[l_ac2].lnc02,-263,0)
               LET g_lnc[l_ac2].* = g_lnc_t.*
            ELSE
               UPDATE lnc_file SET lnc02=g_lnc[l_ac2].lnc02,
                                   lnc03=g_lnc[l_ac2].lnc03 
                WHERE lnc01 = g_lnb_t.lnb01
                  AND lnc00 = g_lnb_t.lnb03
                  AND lnc02 = g_lnc_t.lnc02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","lnc_file",g_lnc_t.lnc02,"",SQLCA.sqlcode,"","",1)
                  LET g_lnc[l_ac2].* = g_lnc_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

         AFTER ROW
            LET l_ac2 = ARR_CURR()            # 新增
            LET l_ac2_t = l_ac2                # 新增

            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_lnc[l_ac2].* = g_lnc_t.*
               END IF 
               CLOSE t290_bcl_2
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            CLOSE t290_bcl_2
            COMMIT WORK

         ON ACTION controlp
            CASE
               WHEN INFIELD(lnc02)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_lnc002"
                    LET g_qryparam.default1 = g_lnc[l_ac2].lnc02
                    CALL cl_create_qry() RETURNING g_lnc[l_ac2].lnc02
                    DISPLAY g_lnc[l_ac2].lnc02 TO lnc02
                    CALL t290_lnc02('d')
                    NEXT FIELD lnc02

               WHEN INFIELD(lnc03)
                    CALL cl_init_qry_var()
                   #LET g_qryparam.form ="q_geo"  #TQC-C40051 mark
                    LET g_qryparam.form ="q_oqw"  #TQC-C40051 add
                    LET g_qryparam.default1 = g_lnc[l_ac2].lnc03
                    CALL cl_create_qry() RETURNING g_lnc[l_ac2].lnc03
                    DISPLAY g_lnc[l_ac2].lnc03 TO lnc03
                    CALL t290_lnc03('d')
                    NEXT FIELD lnc03
            END CASE

      END INPUT
      ON ACTION accept
         ACCEPT DIALOG

      ON ACTION cancel
         EXIT DIALOG

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()
   END DIALOG
   CLOSE t290_bcl_1
   CLOSE t290_bcl_2
   COMMIT WORK
   CALL t290_delall()
END FUNCTION


FUNCTION t290_delall()
DEFINE l_n1   LIKE type_file.num5,
       l_n2   LIKE type_file.num5
   LET l_n1 = 0
   LET l_n2 = 0
   SELECT COUNT(*) INTO l_n1 FROM lnd_file
    WHERE lnd01 = g_lnb.lnb01
   SELECT COUNT(*) INTO l_n2 FROM lnc_file
    WHERE lnc01 = g_lnb.lnb01
   IF l_n1 = 0 AND l_n2 = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM lnb_file WHERE lnb01 = g_lnb.lnb01
   END IF
END FUNCTION


FUNCTION t290_lnd02(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1,
        l_tqaacti    LIKE tqa_file.tqaacti
   LET g_errno = ''
   SELECT tqa02,tqaacti
     INTO g_lnd[l_ac1].tqa02_1,l_tqaacti
     FROM tqa_file
    WHERE tqa01 = g_lnd[l_ac1].lnd02 
      AND tqa03 ='24'
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm-795'
      WHEN l_tqaacti <> 'Y'    LET g_errno = 'alm-777'
                               LET g_lnd[l_ac1].tqa02_1= ''
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY BY NAME g_lnd[l_ac1].tqa02_1 
   END IF   
END FUNCTION 

FUNCTION t290_lnc02(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1,
        l_tqaacti    LIKE tqa_file.tqaacti
   LET g_errno = ''
   SELECT tqa02,tqaacti
     INTO g_lnc[l_ac2].tqa02_2,l_tqaacti
     FROM tqa_file
    WHERE tqa01 = g_lnc[l_ac2].lnc02    
      AND tqa03 ='2'
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm-796'
      WHEN l_tqaacti <> 'Y'    LET g_errno = 'alm-793'
                               LET g_lnc[l_ac2].tqa02_2 = ''
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY BY NAME g_lnc[l_ac2].tqa02_2
   END IF
END FUNCTION 

FUNCTION t290_lnc03(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_oqwacti    LIKE oqw_file.oqwacti
   LET g_errno = ''
  #TQC-C40051 mark START
  #SELECT geo02
  #  INTO g_lnc[l_ac2].geo02_1
  #  FROM geo_file
  # WHERE geo01 = g_lnc[l_ac2].lnc03
  #TQC-C40051 mark END
  #TQC-C40051 add START
   SELECT oqw02, oqwacti
     INTO g_lnc[l_ac2].geo02_1, l_oqwacti 
     FROM oqw_file
    WHERE oqw01 = g_lnc[l_ac2].lnc03
  #TQC-C40051 add END
   CASE  
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm-797'
      WHEN l_oqwacti = 'N'     LET g_errno = 'alm-100'   #TQC-C40051 add
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY BY NAME g_lnc[l_ac2].geo02_1 
   END IF
END FUNCTION 
#FUN-B90056 Add End -----

FUNCTION t290_q()
    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_lnb.* TO NULL
    INITIALIZE g_lnb_t.* TO NULL
    INITIALIZE g_lnb_o.* TO NULL
    CLEAR FORM                                        #FUN-B90056 add
    LET g_lnb01_t = NULL
    CALL g_lnd.clear()                                #FUN-B90056 add
    CALL g_lnc.clear()                                #FUN-B90056 add
    LET g_wc = NULL
    LET g_wc2 = NULL                                  #FUN-B90056 add
    LET g_wc3 = NULL                                  #FUN-B90056 add
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cn2
    
    CALL t290_curs()  
          
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_lnb.* TO NULL
       LET g_lnb01_t = NULL
       LET g_wc = NULL
       RETURN
    END IF
    
    OPEN t290_count
    FETCH t290_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cn2
    OPEN t290_cs   
         
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lnb.lnb01,SQLCA.sqlcode,0)
       INITIALIZE g_lnb.* TO NULL
       LET g_lnb01_t = NULL
       LET g_wc = NULL
    ELSE
       CALL t290_fetch('F')  
    END IF
END FUNCTION
 
FUNCTION t290_fetch(p_icb)
 DEFINE p_icb LIKE type_file.chr1 
 
    CASE p_icb
        WHEN 'N' FETCH NEXT     t290_cs INTO g_lnb.lnb01
        WHEN 'P' FETCH PREVIOUS t290_cs INTO g_lnb.lnb01
        WHEN 'F' FETCH FIRST    t290_cs INTO g_lnb.lnb01
        WHEN 'L' FETCH LAST     t290_cs INTO g_lnb.lnb01
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0 
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
            FETCH ABSOLUTE g_jump t290_cs INTO g_lnb.lnb01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lnb.lnb01,SQLCA.sqlcode,0)
       INITIALIZE g_lnb.* TO NULL
       LET g_lnb01_t = NULL
       RETURN
    ELSE
      CASE p_icb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      DISPLAY g_curs_index TO  FORMONLY.idx
    END IF
 
    SELECT * INTO g_lnb.* FROM lnb_file  
     WHERE lnb01 = g_lnb.lnb01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lnb.lnb01,SQLCA.sqlcode,0)
    ELSE
       LET g_data_owner = g_lnb.lnbuser 
       LET g_data_group = g_lnb.lnbgrup
       CALL t290_show() 
    END IF
END FUNCTION
 
FUNCTION t290_show()
    LET g_lnb_t.* = g_lnb.*
    LET g_lnb_o.* = g_lnb.*
    DISPLAY BY NAME
                    g_lnb.lnb01,g_lnb.lnb02,g_lnb.lnb03,g_lnb.lnb04,g_lnb.lnb05, g_lnb.lnboriu,g_lnb.lnborig, 
                    g_lnb.lnb06,g_lnb.lnb07,g_lnb.lnb08,g_lnb.lnb09,g_lnb.lnb10,
                    g_lnb.lnb12,g_lnb.lnb13,g_lnb.lnb14,g_lnb.lnb15,g_lnb.lnb16,
                    g_lnb.lnb17,g_lnb.lnb18,g_lnb.lnb19,g_lnb.lnb20,g_lnb.lnb21,
#                   g_lnb.lnb22,g_lnb.lnb23,g_lnb.lnb24,g_lnb.lnb27,g_lnb.lnb28,                #FUN-B90056 mark
                    g_lnb.lnb22,g_lnb.lnb28,g_lnb.lnb23,g_lnb.lnb24,                            #FUN-B90056
#                   g_lnb.lnb29,g_lnb.lnb26,g_lnb.lnb25,g_lnb.lnb30,g_lnb.lnb31,               #FUN-B20038 mark
#                   g_lnb.lnb32,g_lnb.lnb33,g_lnb.lnb34,g_lnb.lnb35,g_lnb.lnb36,               #FUN-B20038 mark
#                   g_lnb.lnb29,g_lnb.lnb26,g_lnb.lnb25,g_lnb.lnb30,                            #FUN-B20038        #FUN-B90056 mark
                    g_lnb.lnb33,g_lnb.lnb34,g_lnb.lnb35,g_lnb.lnb36,                            #FUN-B20038
                    g_lnb.lnb37,g_lnb.lnb38,g_lnb.lnb39,g_lnb.lnb40,g_lnb.lnb41,
                    g_lnb.lnb42,g_lnb.lnb43,g_lnb.lnb44,g_lnb.lnb45,g_lnb.lnb46,
                    g_lnb.lnb47,g_lnb.lnb48,g_lnb.lnb49,g_lnb.lnb50,g_lnb.lnb51,
                    g_lnb.lnb52,g_lnb.lnb53,
                    g_lnb.lnbuser,g_lnb.lnbgrup,g_lnb.lnbcrat,g_lnb.lnbmodu,
                    g_lnb.lnbdate 
              
    CALL cl_show_fld_cont()  
    CALL t290_pic()
    CALL t290_xxx_lnb03(g_lnb.lnb03)
    CALL t290_xxx_show()
    CALL t290_b1_fill(g_wc2)  #FUN-B90056 ADD
    CALL t290_b2_fill(g_wc3)  #FUN-B90056 ADD    
END FUNCTION
 
FUNCTION t290_xxx_show()
#DEFINE  l_azf03    LIKE azf_file.azf03      #FUN-A70063 mark
 DEFINE  l_tqa02    LIKE tqa_file.tqa02      #FUN-A70063 add
 DEFINE  l_geo02    LIKE geo_file.geo02
 DEFINE  l_gec02    LIKE gec_file.gec02
 DEFINE  l_gec04    LIKE gec_file.gec04 
 DEFINE  l_gec07    LIKE gec_file.gec07 
 DEFINE  l_oag02    LIKE oag_file.oag02
  
#DISPLAY '' TO FORMONLY.azf03                #FUN-A70063 mark 
 DISPLAY '' TO FORMONLY.tqa02                #FUN-A70063 mod
 DISPLAY '' TO FORMONLY.geo02
 DISPLAY '' TO FORMONLY.gec02
 DISPLAY '' TO FORMONLY.gec04 
 DISPLAY '' TO FORMONLY.gec07 
 DISPLAY '' TO FORMONLY.oag02
  
#FUN-A70063--begin--
#IF NOT cl_null(g_lnb.lnb08) THEN 
#   SELECT azf03 INTO l_azf03 FROM azf_file
#    WHERE azf01 = g_lnb.lnb08
#      AND azf02 = '3'
#      AND azfacti = 'Y'
#   DISPLAY l_azf03 TO FORMONLY.azf03   
#END IF  

 IF NOT cl_null(g_lnb.lnb08) THEN 
    SELECT tqa02 INTO l_tqa02 FROM tqa_file 
     WHERE tqa03 = '2' 
       AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07)) 
         OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2'))) 
       AND tqa01 = g_lnb.lnb08
       AND tqaacti = 'Y'
    DISPLAY l_tqa02 TO FORMONLY.tqa02
 END IF  
#FUN-A70063--end--
 
 IF NOT cl_null(g_lnb.lnb09) THEN 
   #TQC-C40051 mark START
   #SELECT geo02 INTO l_geo02 FROM geo_file  
   # WHERE geo01 = g_lnb.lnb09               
   #   AND geoacti = 'Y'
   #TQC-C40051 mark END
   #TQC-C40051 add START
    SELECT oqw02 INTO l_geo02 FROM oqw_file  
     WHERE oqw01 = g_lnb.lnb09               
       AND oqwacti = 'Y'
   #TQC-C40051 add END
     DISPLAY l_geo02 TO FORMONLY.geo02  
 END IF 
 
 IF NOT cl_null(g_lnb.lnb37) THEN 
    SELECT gec02,gec04,gec07 INTO l_gec02,l_gec04,l_gec07 FROM gec_file
     WHERE gec01 = g_lnb.lnb37
       AND gecacti = 'Y'
       AND gec011 = '2'
     DISPLAY l_gec02 TO FORMONLY.gec02  
     DISPLAY l_gec04 TO FORMONLY.gec04 
     DISPLAY l_gec07 TO FORMONLY.gec07 
     LET g_gec02 = g_lnb.lnb37 
     LET g_gec04 = l_gec04
     LET g_gec07 = l_gec07
 ELSE
 	   LET g_gec02 = NULL 
     LET g_gec04 = NULL
     LET g_gec07 = NULL     
 END IF 
 
 IF NOT cl_null(g_lnb.lnb39) THEN 
    SELECT oag02 INTO l_oag02 FROM oag_file
     WHERE oag01 = g_lnb.lnb39
    DISPLAY l_oag02 TO FORMONLY.oag02 
 END IF 
 
END FUNCTION 
 
#FUN-B90056 Add Begin ---
FUNCTION t290_b1_fill(p_wc1)
 DEFINE   p_wc1           LIKE type_file.chr1000

    LET g_sql ="SELECT lnd02,'',lnd03,lnd04,lnd05,lnd06",
               " FROM lnd_file ",
               " WHERE ", p_wc1 CLIPPED,
               " and lnd01 = '",g_lnb.lnb01,"'",
               " ORDER BY lnd02"
    PREPARE t290_lnd_pb FROM g_sql
    DECLARE sel_lnd_curs CURSOR FOR t290_lnd_pb

    CALL g_lnd.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH sel_lnd_curs INTO g_lnd[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT tqa02 INTO g_lnd[g_cnt].tqa02_1
          FROM tqa_file
         WHERE tqa01 = g_lnd[g_cnt].lnd02 AND tqa03 = '24'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lnd.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b1 = g_cnt - 1
    DISPLAY g_rec_b1 TO FORMONLY.cn3
    LET g_cnt = 0

END FUNCTION

FUNCTION t290_b2_fill(p_wc2)
 DEFINE   p_wc2           LIKE type_file.chr1000

    LET g_sql ="SELECT lnc02,'',lnc03,'' ",
               " FROM lnc_file ",
               " WHERE ", p_wc2 CLIPPED,
               " and lnc01 = '",g_lnb.lnb01,"'",
               " ORDER BY lnc02"
    PREPARE t290_lnc_pb FROM g_sql
    DECLARE sel_lnc_curs CURSOR FOR t290_lnc_pb

    CALL g_lnc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH sel_lnc_curs INTO g_lnc[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT tqa02 INTO g_lnc[g_cnt].tqa02_2 FROM tqa_file
         WHERE tqa03 = '2' AND tqa01 = g_lnc[g_cnt].lnc02
       #TQC-C40051 mark START
        SELECT geo02 INTO g_lnc[g_cnt].geo02_1 FROM geo_file
         WHERE geo01 = g_lnc[g_cnt].lnc03
           AND geoacti  = 'Y'
       #TQC-C40051 mark END
       #TQC-C40051 add START
        SELECT oqw02 INTO g_lnc[g_cnt].geo02_1 FROM oqw_file
         WHERE oqw01 = g_lnc[g_cnt].lnc03
           AND oqwacti  = 'Y'
       #TQC-C40051 add END
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lnc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn4
    LET g_cnt = 0

END FUNCTION
#FUN-B90056 Add  end-------

FUNCTION t290_u(p_w)
DEFINE   p_w         LIKE type_file.chr1
DEFINE   l_n         LIKE type_file.num5
 
    IF cl_null(g_lnb.lnb01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF    
 
    SELECT * INTO g_lnb.* FROM lnb_file  
     WHERE lnb01   = g_lnb.lnb01
  
   IF g_lnb.lnb33 = 'Y' THEN
      CALL cl_err(g_lnb.lnb01,'alm-027',1)
     RETURN
   END IF    
 
   IF g_lnb.lnb33 = 'X' THEN
      CALL cl_err(g_lnb.lnb01,'alm-134',1)
     RETURN
   END IF    
   
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lnb01_t = g_lnb.lnb01
    BEGIN WORK
 
    OPEN t290_cl USING g_lnb.lnb01
    IF STATUS THEN
       CALL cl_err("OPEN t290_cl:",STATUS,1)
       CLOSE t290_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t290_cl INTO g_lnb.*  
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lnb.lnb01,SQLCA.sqlcode,1)
       CLOSE t290_cl
       ROLLBACK WORK
       RETURN
    END IF
    ##############
    LET g_date = g_lnb.lnbdate
    LET g_modu = g_lnb.lnbmodu
    #######
    IF p_w != 'c' THEN 
        LET g_lnb.lnbmodu = g_user  
        LET g_lnb.lnbdate = g_today 
    ELSE
    	LET g_lnb.lnbmodu = NULL
      LET g_lnb.lnbdate = NULL  
    END IF  	    
    
    CALL t290_show()                 
    WHILE TRUE       
        IF p_w != 'c' THEN
           CALL t290_i('u','u')
        ELSE
        	 LET g_lnb.lnb02 = ' '
        	 LET g_lnb.lnb05 = ''
        	 LET g_lnb.lnb25 = '' 
        	 LET g_lnb.lnb30 = ''       	 
        	 DISPLAY BY NAME g_lnb.lnb02,g_lnb.lnb05,
        	                 g_lnb.lnb25,g_lnb.lnb30
        	 CALL t290_i('u','h')
        END IF  	 
        IF INT_FLAG THEN         
           LET INT_FLAG = 0 
           LET g_lnb_t.lnbdate = g_date
           LET g_lnb_t.lnbmodu = g_modu
           #######  
           LET g_lnb_t.lnb05 = g_lnb.lnb05
           LET g_lnb_t.lnb25 = g_lnb.lnb25
           LET g_lnb_t.lnb30 = g_lnb.lnb30
           LET g_lnb_t.lnb02 = g_lnb.lnb02 
           LET g_lnb.*=g_lnb_t.*
           LET g_wc2 = " 1=1"
           LET g_wc3 = " 1=1"
           CALL t290_show()        
           CALL cl_err('',9001,0) 
           EXIT WHILE       
        END IF
 
       UPDATE lnb_file SET lnb_file.* = g_lnb.* 
         WHERE lnb01 = g_lnb01_t
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_lnb.lnb01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t290_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t290_r()
    IF cl_null(g_lnb.lnb01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    IF g_lnb.lnb33 = 'Y' THEN 
       CALL cl_err(g_lnb.lnb01,'alm-028',1)
       RETURN
     END IF
     
    IF g_lnb.lnb33 = 'X' THEN 
       CALL cl_err(g_lnb.lnb01,'alm-134',1)
       RETURN
     END IF
    BEGIN WORK
 
    OPEN t290_cl USING g_lnb.lnb01
    IF STATUS THEN
       CALL cl_err("OPEN t290_cl:",STATUS,0)
       CLOSE t290_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t290_cl INTO g_lnb.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lnb.lnb01,SQLCA.sqlcode,0)
       CLOSE t290_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL t290_show()
#   IF cl_delete() THEN   #FUN-B90056 MARK
    IF cl_delh(0,0) THEN  #FUN-B90056 Add
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lnb01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lnb.lnb01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM lnb_file  WHERE lnb01  = g_lnb.lnb01
       DELETE FROM lnc_file  WHERE lnc01  = g_lnb.lnb01
       DELETE FROM lnd_file  WHERE lnd01  = g_lnb.lnb01
       CLEAR FORM
       CALL g_lnd.clear()
       CALL g_lnc.clear()
       OPEN t290_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t290_cs
          CLOSE t290_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t290_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t290_cs
          CLOSE t290_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cn2
       OPEN t290_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t290_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL t290_fetch('/')
       END IF
    END IF
    CLOSE t290_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t290_copy()
DEFINE l_newno   LIKE lnb_file.lnb01
DEFINE l_oldno   LIKE lnb_file.lnb01
DEFINE li_result LIKE type_file.num5 
 
    IF cl_null(g_lnb.lnb01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL t290_set_entry('a')
    CALL cl_set_docno_format("lnb01")
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM lnb01
 
        AFTER FIELD lnb01 
          IF NOT cl_null(l_newno) THEN           
             #CALL s_check_no("alm",l_newno,"",'16',"lnb_file","lnb01","") #FUN-A70130
             CALL s_check_no("alm",l_newno,"",'L5',"lnb_file","lnb01","") #FUN-A70130
             RETURNING li_result,l_newno
             IF (NOT li_result) THEN
               LET l_newno = NULL
               DISPLAY l_newno TO lnb01
               NEXT FIELD lnb01
             END IF
          ELSE 
          	 CALL cl_err('','alm-055',1)
          	 NEXT FIELD lnb01    
          END IF
 
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
           ELSE
           ##自動編號##################     
            BEGIN WORK
            #CALL s_auto_assign_no("alm",l_newno,g_today,'16',"lnb_file","lnb01","","","") #FUN-A70130
            CALL s_auto_assign_no("alm",l_newno,g_today,'L5',"lnb_file","lnb01","","","") #FUN-A70130
              RETURNING li_result,l_newno
            IF (NOT li_result) THEN
               RETURN 
            END IF	
            DISPLAY l_newno TO lnb01 
            ##########################       
          END IF
       
         ON ACTION controlp
          CASE
            WHEN INFIELD(lnb01)     #單據編號
               LET g_kindslip = s_get_doc_no(l_newno)
              # CALL q_lrk(FALSE,FALSE,g_kindslip,'16','ALM') RETURNING g_kindslip    #FUN-A70130 mark
              CALL q_oay(FALSE,FALSE,g_kindslip,'L5','ALM') RETURNING g_kindslip      #FUN-A70130 add
               LET l_newno = g_kindslip
               DISPLAY l_newno TO lnb01
               NEXT FIELD lnb01
            
              OTHERWISE EXIT CASE
           END CASE
       
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION about 
          CALL cl_about() 
 
       ON ACTION help 
          CALL cl_show_help() 
  
       ON ACTION controlg 
          CALL cl_cmdask() 
 
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_lnb.lnb01
       RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM lnb_file
     WHERE lnb01=g_lnb.lnb01
      INTO TEMP x
    UPDATE x
        SET lnb01  =l_newno,     
            lnbuser=g_user, 
            lnbgrup=g_grup, 
            lnbmodu=NULL, 
            lnbdate=NULL,  
            lnbcrat=g_today,  
            lnb33  = 'N',
            lnb31  = 'N',
            lnb32  = '0',
            lnb34  = NULL,
            lnb35  = NULL,
            lnb04  = NULL,
            lnb05  = NULL,
            lnb26  = NULL  
    INSERT INTO lnb_file SELECT * FROM x
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
    #   ROLLBACK WORK        # FUN-B80060 下移兩行
       CALL cl_err(l_newno,SQLCA.sqlcode,0)
       ROLLBACK WORK        # FUN-B80060
       RETURN
    END IF 
#FUN-B90056 add begin----
    DROP TABLE y
    SELECT * FROM lnd_file
     WHERE lnd01=g_lnb.lnb01
      INTO TEMP y    
    UPDATE y SET lnd01 = l_newno
    INSERT INTO lnd_file SELECT * FROM y
    IF SQLCA.SQLCODE THEN
       CALL cl_err(l_newno,SQLCA.sqlcode,0)
       ROLLBACK WORK      
       RETURN
    END IF 
    DROP TABLE z
    SELECT * FROM lnc_file
     WHERE lnc01=g_lnb.lnb01
      INTO TEMP z 
    UPDATE z SET lnc01 = l_newno
    INSERT INTO lnc_file SELECT * FROM z
    IF SQLCA.SQLCODE THEN
       CALL cl_err(l_newno,SQLCA.sqlcode,0)
       ROLLBACK WORK        
#FUN-B90056 add end----
    ELSE
       COMMIT WORK
       MESSAGE 'ROW(',l_newno,') O.K'
       LET l_oldno = g_lnb.lnb01
       LET g_lnb.lnb01 = l_newno
       SELECT lnb_file.* INTO g_lnb.*
         FROM lnb_file   
        WHERE lnb01 = l_newno
       CALL t290_u('c')
       UPDATE lnb_file SET lnb25 = g_lnb.lnb25,
                           lnb30 = g_lnb.lnb30,
                           lnb05 = g_lnb.lnb05,
                           lnb02 = g_lnb.lnb02 
        WHERE lnb01 = l_newno   
         CALL t290_b()
         #SELECT lnb_file.* INTO g_lnb.* #FUN-C30027
         #FROM lnb_file                  #FUN-C30027
         #WHERE lnb01  = l_oldno         #FUN-C30027
    END IF
    #LET g_lnb.lnb01 = l_oldno           #FUN-C30027
    CALL t290_show()
END FUNCTION
 
FUNCTION t290_set_entry(p_cmd)
DEFINE   p_cmd    LIKE type_file.chr1 
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lnb01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t290_xxx()  
  DEFINE l_gec02    LIKE gec_file.gec02
  DEFINE l_gec04    LIKE gec_file.gec04 
  DEFINE l_gec07    LIKE gec_file.gec07 
  DEFINE l_oag02    LIKE oag_file.oag02
  DEFINE l_lna02    LIKE lna_file.lna02,
         l_lna03    LIKE lna_file.lna03,
         l_lna04    LIKE lna_file.lna04,
         l_lna05    LIKE lna_file.lna05,
         l_lna06    LIKE lna_file.lna06,
         l_lna07    LIKE lna_file.lna07,
         l_lna08    LIKE lna_file.lna08,
         l_lna09    LIKE lna_file.lna09,
         l_lna11    LIKE lna_file.lna11,
         l_lna12    LIKE lna_file.lna12, 
         l_lna13    LIKE lna_file.lna13,
         l_lna14    LIKE lna_file.lna14,
         l_lna15    LIKE lna_file.lna15,
         l_lna16    LIKE lna_file.lna16,
         l_lna17    LIKE lna_file.lna17,
         l_lna18    LIKE lna_file.lna18,
         l_lna19    LIKE lna_file.lna19,
         l_lna20    LIKE lna_file.lna20,
         l_lna21    LIKE lna_file.lna21,
         l_lna22    LIKE lna_file.lna22,
         l_lna23    LIKE lna_file.lna23 
   
  IF NOT cl_null(g_lnb.lnb02) THEN  
    
    SELECT lna02,lna03,lna04,lna05,lna06,lna07,lna08,lna09,lna11,lna12,
           lna13,lna14,lna15,lna16,lna17,lna18,lna19,lna20,lna21,lna22,
           lna23 
      INTO l_lna02,l_lna03,l_lna04,l_lna05,l_lna06,l_lna07,l_lna08,l_lna09,
           l_lna11,l_lna12,l_lna13,l_lna14,l_lna15,l_lna16,l_lna17,l_lna18,
           l_lna19,l_lna20,l_lna21,l_lna22,l_lna23
      FROM lna_file
     WHERE lna01 = g_lnb.lnb02     
 
     IF g_lnb.lnb02 = g_lnb02 THEN 
        LET l_lna02     = g_lnb.lnb03
        LET l_lna03     = g_lnb.lnb04
        LET l_lna04     = g_lnb.lnb05
        LET l_lna05     = g_lnb.lnb06
        LET l_lna06     = g_lnb.lnb07
        LET l_lna07     = g_lnb.lnb08
        LET l_lna08     = g_lnb.lnb09
        LET l_lna09     = g_lnb.lnb10
        LET l_lna11     = g_lnb.lnb12
        LET l_lna12     = g_lnb.lnb13
        LET l_lna13     = g_lnb.lnb14
        LET l_lna14     = g_lnb.lnb15
        LET l_lna15     = g_lnb.lnb16
        LET l_lna16     = g_lnb.lnb17
        LET l_lna17     = g_lnb.lnb18
        LET l_lna18     = g_lnb.lnb19
        LET l_lna19     = g_lnb.lnb20
        LET l_lna20     = g_lnb.lnb21
        LET l_lna21     = g_lnb.lnb22
        LET l_lna22     = g_lnb.lnb23
        LET l_lna23     = g_lnb.lnb24                        
        LET g_lnb.lnb03 = l_lna02
        LET g_lnb.lnb04 = l_lna03
        LET g_lnb.lnb05 = l_lna04
        LET g_lnb.lnb06 = l_lna05
        LET g_lnb.lnb07 = l_lna06
        LET g_lnb.lnb08 = l_lna07
        LET g_lnb.lnb09 = l_lna08
        LET g_lnb.lnb10 = l_lna09
        LET g_lnb.lnb12 = l_lna11
        LET g_lnb.lnb13 = l_lna12
        LET g_lnb.lnb14 = l_lna13
        LET g_lnb.lnb15 = l_lna14
        LET g_lnb.lnb16 = l_lna15
        LET g_lnb.lnb17 = l_lna16
        LET g_lnb.lnb18 = l_lna17
        LET g_lnb.lnb19 = l_lna18
        LET g_lnb.lnb20 = l_lna19
        LET g_lnb.lnb21 = l_lna20
        LET g_lnb.lnb22 = l_lna21
        LET g_lnb.lnb23 = l_lna22
        LET g_lnb.lnb24 = l_lna23
     ELSE
     	  LET l_lna02     = l_lna02
     	  LET l_lna03     = l_lna03
     	  LET l_lna04     = l_lna04
     	  LET l_lna05     = l_lna05
     	  LET l_lna06     = l_lna06
     	  LET l_lna07     = l_lna07
     	  LET l_lna08     = l_lna08
     	  LET l_lna09     = l_lna09
     	  LET l_lna11     = l_lna11
     	  LET l_lna12     = l_lna12
     	  LET l_lna13     = l_lna13
     	  LET l_lna14     = l_lna14
     	  LET l_lna15     = l_lna15
     	  LET l_lna16     = l_lna16
     	  LET l_lna17     = l_lna17
     	  LET l_lna18     = l_lna18
     	  LET l_lna19     = l_lna19
     	  LET l_lna20     = l_lna20
     	  LET l_lna21     = l_lna21
     	  LET l_lna22     = l_lna22
     	  LET l_lna23     = l_lna23
     	  LET g_lnb.lnb03 = l_lna02
     	  LET g_lnb.lnb04 = l_lna03
     	  LET g_lnb.lnb05 = l_lna04
     	  LET g_lnb.lnb06 = l_lna05
     	  LET g_lnb.lnb07 = l_lna06
     	  LET g_lnb.lnb08 = l_lna07
     	  LET g_lnb.lnb09 = l_lna08
     	  LET g_lnb.lnb10 = l_lna09
     	  LET g_lnb.lnb12 = l_lna11
     	  LET g_lnb.lnb13 = l_lna12
     	  LET g_lnb.lnb14 = l_lna13
     	  LET g_lnb.lnb15 = l_lna14
     	  LET g_lnb.lnb16 = l_lna15
     	  LET g_lnb.lnb17 = l_lna16
     	  LET g_lnb.lnb18 = l_lna17
     	  LET g_lnb.lnb19 = l_lna18
     	  LET g_lnb.lnb20 = l_lna19
     	  LET g_lnb.lnb21 = l_lna20
     	  LET g_lnb.lnb22 = l_lna21
     	  LET g_lnb.lnb23 = l_lna22
     	  LET g_lnb.lnb24 = l_lna23
     END IF
    DISPLAY l_lna02,l_lna03,l_lna04,l_lna05,l_lna06,l_lna07,l_lna08,l_lna09,
           l_lna11,l_lna12,l_lna13,l_lna14,l_lna15,l_lna16,l_lna17,l_lna18,
           l_lna19,l_lna20,l_lna21,l_lna22,l_lna23
        TO lnb03,lnb04,lnb05,lnb06,lnb07,lnb08,lnb09,lnb10,lnb12,lnb13,lnb14,
           lnb15,lnb16,lnb17,lnb18,lnb19,lnb20,lnb21,lnb22,lnb23,lnb24             
 
  LET g_lnb02 = g_lnb.lnb02
  CALL t290_xxx_lnb03(g_lnb.lnb03)
  CALL t290_xxx_lnb081(g_lnb.lnb08)
  CALL t290_xxx_lnb091(g_lnb.lnb09)
   SELECT gec02,gec04,gec07 INTO l_gec02,l_gec04,l_gec07 FROM gec_file
    WHERE gec01 = g_lnb.lnb37
      AND gec011 = '2'
  DISPLAY l_gec02 TO FORMONLY.gec02    
  DISPLAY l_gec04 TO FORMONLY.gec04 
  DISPLAY l_gec07 TO FORMONLY.gec07 
  
   SELECT oag02 INTO l_oag02 FROM oag_file
    WHERE oag01 = g_lnb.lnb39
  DISPLAY l_oag02 TO FORMONLY.oag02    
  END IF 
END FUNCTION
 
FUNCTION t290_xxx_lnb03(p_cmd)
DEFINE p_cmd          LIKE lnb_file.lnb03
DEFINE l_rtz13        LIKE rtz_file.rtz13 #FUN-A80148 add
 
IF NOT cl_null(p_cmd) THEN 
    SELECT rtz13 INTO l_rtz13 FROM rtz_file  
      WHERE rtz01   = p_cmd
    DISPLAY l_rtz13  TO FORMONLY.rtz13       
END IF  
END FUNCTION 
 
FUNCTION t290_xxx_lnb05(p_cmd)
DEFINE p_cmd          LIKE lnb_file.lnb05
DEFINE l_count        LIKE type_file.num5
 
   SELECT COUNT(*) INTO l_count FROM lnb_file
    WHERE lnb05 = p_cmd
    IF l_count > 0 THEN 
       CALL cl_err('','alm-613',1)
       LET g_success = 'N'
    ELSE
       LET g_success = 'Y'  	
    END IF 
END FUNCTION 
 
FUNCTION t290_xxx_lnb05_1(p_cmd)
DEFINE p_cmd          LIKE lnb_file.lnb05
DEFINE l_count        LIKE type_file.num5
 
  SELECT COUNT(lnb05) INTO l_count FROM lnb_file
   WHERE lnb05  = p_cmd
  IF l_count > 0 THEN 
     CALL cl_err('','alm-173',1)
     LET g_success = 'N'
  ELSE
  	 LET g_success = 'Y'
  END IF            
END FUNCTION 
 
FUNCTION t290_xxx_lnb08(p_cmd)
DEFINE p_cmd          LIKE lnb_file.lnb08
DEFINE l_count        LIKE type_file.num5
#DEFINE l_azfacti      LIKE azf_file.azfacti   #FUN-A70063 mark
#DEFINE l_azf02        LIKE azf_file.azf02     #FUN-A70063 mark
DEFINE l_tqa03        LIKE tqa_file.tqa03      #FUN-A70063 add
DEFINE l_tqaacti      LIKE tqa_file.tqaacti    #FUN-A70063 add
 
#FUN-A70063--begin--
# SELECT COUNT(*) INTO l_count FROM azf_file
#  WHERE azf01 = p_cmd
#  IF l_count < 1 THEN 
#    CALL cl_err('','alm-121',0)
#    LET g_success = 'N'
#  ELSE
# 	 SELECT azf02 INTO l_azf02 FROM azf_file
# 	  WHERE azf01 = p_cmd
# 	  IF l_azf02 != '3' THEN 
# 	     CALL cl_err('','alm-123',0)
# 	     LET g_success = 'N'
# 	  ELSE
# 	     SELECT azfacti INTO l_azfacti FROM azf_file
# 	      WHERE azf01 = p_cmd
# 	     IF l_azfacti != 'Y' THEN 
# 	        CALL cl_err('','alm-139',0)
# 	        LET g_success = 'N'
# 	     ELSE
# 	     		 LET g_success = 'Y'
# 	     END IF 		 
# 	  END IF 
#  END IF  	           
  
    SELECT COUNT(*) INTO l_count FROM tqa_file 
     WHERE tqa03 = '2' 
       AND tqa01 = p_cmd
    IF l_count < 1 THEN 
       CALL cl_err('','alm1002',0)
       LET g_success = 'N'
    ELSE
       SELECT COUNT(*) INTO l_count FROM tqa_file 
        WHERE tqa03 = '2'
          AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07)) 
             OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))  
          AND tqa01 = p_cmd
       IF l_count < 1 THEN
          CALL cl_err('','alm1004',0)
          LET g_success = 'N'
       ELSE
          SELECT tqaacti INTO l_tqaacti FROM tqa_file 
           WHERE tqa03 = '2'
             AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07)) 
               OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))  
             AND tqa01 = p_cmd
          IF l_tqaacti != 'Y' THEN
             CALL cl_err('','alm-139',0)
             LET g_success = 'N'
          ELSE
             LET g_success = 'Y'
          END IF
       END IF
    END IF
#FUN-A70063--end--

#No.FUN-9B0136 BEGIN -----
  IF g_success = 'Y' THEN
      SELECT COUNT(*) INTO l_count FROM lne_file
       WHERE lne08 = p_cmd
         AND lne36 = 'Y'
      IF l_count > 0 THEN
         CALL cl_err('','alm-706',0)
         #LET g_success = 'N'     #TQC-C30027 mark
      END IF
   END IF
 #No.FUN-9B0136 END -------
END FUNCTION 
 
FUNCTION t290_xxx_lnb081(p_cmd)
DEFINE p_cmd          LIKE lnb_file.lnb08
#DEFINE l_azf03        LIKE azf_file.azf03         #FUN-A70063 mark
DEFINE l_tqa02        LIKE tqa_file.tqa02          #FUN-A70063 add
 
#FUN-A70063--begin--
#SELECT azf03 INTO l_azf03 FROM azf_file
# WHERE azf01 = p_cmd
#DISPLAY l_azf03 TO FORMONLY.azf03 	           
 
   SELECT tqa02 INTO l_tqa02 FROM tqa_file 
    WHERE tqa03 = '2'
      AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07)) 
          OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))  
      AND tqa01 = p_cmd
   DISPLAY l_tqa02 TO FORMONLY.tqa02
#FUN-A70063--end--

END FUNCTION 
 
FUNCTION t290_xxx_lnb09(p_cmd)
DEFINE p_cmd          LIKE lnb_file.lnb09
DEFINE l_count        LIKE type_file.num5
DEFINE l_geoacti      LIKE geo_file.geoacti
 
 
 #SELECT COUNT(*) INTO l_count FROM geo_file  #TQC-C40051 mark
 # WHERE geo01 = p_cmd                        #TQC-C40051 mark
  SELECT COUNT(*) INTO l_count FROM oqw_file  #TQC-C40051 add 
   WHERE oqw01 = p_cmd                        #TQC-C40051 add 
  IF l_count < 1 THEN 
     CALL cl_err('','alm-124',0)
     LET g_success = 'N'
  ELSE
    #SELECT geoacti INTO l_geoacti FROM geo_file  #TQC-C40051 mark
    # WHERE geo01 = p_cmd                         #TQC-C40051 mark
     SELECT oqwacti INTO l_geoacti FROM oqw_file  #TQC-C40051 add 
      WHERE oqw01 = p_cmd                         #TQC-C40051 add
      IF l_geoacti != 'Y' THEN 
         CALL cl_err('','alm-100',0)
         LET g_success = 'N'
      ELSE
      	 LET g_success = 'Y'
      END IF  	    
  END IF  	     	            
 
END FUNCTION 
 
FUNCTION t290_xxx_lnb091(p_cmd)
DEFINE p_cmd          LIKE lnb_file.lnb09
DEFINE l_geo02        LIKE geo_file.geo02
 
#SELECT geo02 INTO l_geo02 FROM geo_file  #TQC-C40051 mark
# WHERE geo01 = p_cmd                     #TQC-C40051 mark
 SELECT oqw02 INTO l_geo02 FROM oqw_file  #TQC-C40051 add 
  WHERE oqw01 = p_cmd                     #TQC-C40051 add
 DISPLAY l_geo02 TO FORMONLY.geo02       
 
END FUNCTION 
 
 
FUNCTION t290_check_lnb02(p_cmd)
 DEFINE p_cmd      LIKE type_file.chr1
 DEFINE l_count    LIKE type_file.num5
 DEFINE l_lna26    LIKE lna_file.lna26
 
 SELECT COUNT(*) INTO l_count FROM lna_file
    WHERE lna01 = g_lnb.lnb02
 IF l_count < 1 THEN
    CALL cl_err('','alm-136',0)
    LET g_success = 'N'
 ELSE
    IF p_cmd = 'u' AND g_lnb.lnb02 =  g_lnb_t.lnb02 THEN
 
    ELSE
       LET l_count = 0 
       SELECT COUNT(lnb02) INTO l_count FROM lnb_file
        WHERE lnb02 = g_lnb.lnb02
       IF l_count > 0 THEN
          CALL cl_err('','alm-248',1)
          LET g_success = 'N'
       ELSE
          SELECT lna26 INTO l_lna26 FROM lna_file
           WHERE lna01 = g_lnb.lnb02
          IF l_lna26 != 'Y' THEN 
             CALL cl_err('','alm-120',0) 
             LET g_success = 'N'
          ELSE
    	     LET g_success = 'Y' 
          END IF  	 
       END IF    
    END IF
 END IF 
END FUNCTION 
 
FUNCTION t290_check_lnb03(p_cmd)
 DEFINE p_cmd      LIKE lnb_file.lnb03 
 DEFINE l_count    LIKE type_file.num5
 DEFINE l_rtz28    LIKE rtz_file.rtz28  #FUN-A80148 add
 
 SELECT COUNT(*) INTO l_count FROM rtz_file
   WHERE rtz01  = p_cmd
  
 IF l_count < 1 THEN
    CALL cl_err('','alm-077',0)
    LET g_success = 'N'
 ELSE
    SELECT rtz28 INTO l_rtz28 FROM rtz_file
      WHERE rtz01   = p_cmd
     IF l_rtz28 != 'Y' THEN 
       CALL cl_err('','alm-002',0)
       LET g_success = 'N'
     ELSE
     	 LET g_success = 'Y'
     END IF   
 END IF 
END FUNCTION 
 
 
FUNCTION t290_set_no_entry(p_cmd)          
   DEFINE   p_cmd     LIKE type_file.chr1   
 
  IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN   
      CALL cl_set_comp_entry("lnb01",FALSE)        
  END IF           
END FUNCTION          
 
FUNCTION t290_confirm()
   DEFINE l_lnb34         LIKE lnb_file.lnb34 
   DEFINE l_lnb35         LIKE lnb_file.lnb35 
   DEFINE l_count         LIKE type_file.num5
   
   IF cl_null(g_lnb.lnb01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 ------------ add ------------- begin
   IF g_lnb.lnb33 = 'Y' THEN
      CALL cl_err(g_lnb.lnb01,'alm-005',1)
      RETURN
   END IF
   IF g_lnb.lnb33 = 'X' THEN
      CALL cl_err(g_lnb.lnb01,'alm-134',1)
      RETURN
   END IF
   IF NOT cl_confirm("alm-006") THEN RETURN END IF
   SELECT * INTO g_lnb.* FROM lnb_file
    WHERE lnb01  = g_lnb.lnb01
   IF cl_null(g_lnb.lnb01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 ------------ add ------------- end
   IF g_lnb.lnb33 = 'Y' THEN
      CALL cl_err(g_lnb.lnb01,'alm-005',1)
      RETURN
   END IF   
   IF g_lnb.lnb33 = 'X' THEN
      CALL cl_err(g_lnb.lnb01,'alm-134',1)
      RETURN
   END IF   
   
#  SELECT * INTO g_lnb.* FROM lnb_file  #CHI-C30107 mark
#   WHERE lnb01  = g_lnb.lnb01          #CHI-C30107 mark
   
    LET l_lnb34 = g_lnb.lnb34
    LET l_lnb35 = g_lnb.lnb35 
   
    BEGIN WORK 
    OPEN t290_cl USING g_lnb.lnb01
    IF STATUS THEN 
       CALL cl_err("open t290_cl:",STATUS,1)
       CLOSE t290_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    
    FETCH t290_cl INTO g_lnb.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lnb.lnb01,SQLCA.sqlcode,0)
      CLOSE t290_cl
      ROLLBACK WORK
      RETURN 
    END IF    
 
#CHI-C30107 ----------------- MARK --------------------- BEGIN
#  IF NOT cl_confirm("alm-006") THEN
#      RETURN
#  ELSE
#CHI-C30107 ----------------- MARK --------------------- END
   	  LET g_lnb.lnb33 = 'Y'
      LET g_lnb.lnb34 = g_user
      LET g_lnb.lnb35 = g_today
  #######
      LET l_count = 0
      SELECT COUNT(*) INTO l_count FROM occ_file
#       WHERE occ01  = g_lnb.lnb04
        WHERE occ01  = 'MISC'
#         AND occ246 = g_lnb.plant_code
#         AND g_lnb.lnb04 != 'MISC'
#      IF l_count > 0 THEN         
#         CALL cl_err('','alm-616',1)
#         RETURN 
#       ELSE
#          IF g_lnb.lnb04 = 'MISC' THEN 
#          ELSE       	
       	 IF l_count = 0 THEN 
            INSERT INTO occ_file(occ01,occ02,occ06,occ07,occ08,occ09,occ18,occ231,occ246,occ67,
                                 occ41,occ42,occ45,occuser,occgrup,occmodu,occdate,occacti,occ1004,
                                 occ37,occ56,occ57,occ31,occ65,occ40,occoriu,occorig)
              VALUES('MISC','MISC','1','MISC','1','MISC','MISC',g_lnb.lnb46,g_plant,
                     g_lnb.lnb52,g_lnb.lnb37,g_lnb.lnb53,g_lnb.lnb39,
                     g_lnb.lnbuser,g_lnb.lnbgrup,g_lnb.lnbmodu,g_lnb.lnbdate,'Y','1',
                     'N','N','N','N','N','Y', g_user, g_grup)       #No.FUN-980030 10/01/04  insert columns oriu, orig
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                CALL cl_err('insert occ_file:',SQLCA.SQLCODE,0)  
                LET g_lnb.lnb33 = 'N'
                LET g_lnb.lnb34 = l_lnb34
                LET g_lnb.lnb35 = l_lnb35 
                RETURN     
             END IF
        END IF 
          UPDATE lnb_file
         SET lnb33 = g_lnb.lnb33,
             lnb34 = g_lnb.lnb34,
             lnb35 = g_lnb.lnb35 
       WHERE lnb01 = g_lnb.lnb01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err('upd lnb:',SQLCA.SQLCODE,0)
           LET g_lnb.lnb33 = 'N'
           LET g_lnb.lnb34 = l_lnb34
           LET g_lnb.lnb35 = l_lnb35     
           DISPLAY BY NAME g_lnb.lnb33,g_lnb.lnb34,g_lnb.lnb35
           RETURN
        ELSE
           DISPLAY BY NAME g_lnb.lnb33,g_lnb.lnb34,g_lnb.lnb35    
        END IF          
#   END IF       
  ###########      
       
#   END IF   #CHI-C30107 mark
  CLOSE t290_cl
  COMMIT WORK      
END FUNCTION
 
FUNCTION t290_unconfirm()
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_lnb34         LIKE lnb_file.lnb34 
   DEFINE l_lnb35         LIKE lnb_file.lnb35 
   DEFINE l_count         LIKE type_file.num5
   
   IF cl_null(g_lnb.lnb01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lnb.* FROM lnb_file
   WHERE lnb01  = g_lnb.lnb01
  
   LET l_lnb34 = g_lnb.lnb34
   LET l_lnb35 = g_lnb.lnb35 
  
   IF g_lnb.lnb33 = 'N' THEN
      CALL cl_err(g_lnb.lnb01,'alm-007',1)
      RETURN
   END IF
  
   IF g_lnb.lnb33 = 'X' THEN
      CALL cl_err(g_lnb.lnb01,'alm-134',1)
      RETURN
   END IF
   
   SELECT COUNT(*) INTO l_count FROM lua_file
    WHERE lua12 = g_lnb.lnb01
      AND lua01 IS NOT NULL
    IF l_count > 0 THEN 
       CALL cl_err('','alm-240',1)
       RETURN
    END IF   
   
   LET l_count = 0 
   SELECT COUNT(*) INTO l_count FROM lne_file
    WHERE lne01 IS NOT NULL
      AND lne03 = g_lnb.lnb01 
    IF l_count > 0 THEN 
       CALL cl_err('','alm-243',1)
       RETURN
    END IF   
   SELECT COUNT(*) INTO l_count FROM lig_file
    WHERE lig06 = g_lnb.lnb01
      AND lig01 IS NOT NULL
    IF l_count > 0 THEN
       CALL cl_err('','alm-880',1)
       RETURN
    END IF      
    BEGIN WORK
    OPEN t290_cl USING g_lnb.lnb01
    
    IF STATUS THEN 
       CALL cl_err("open t290_cl:",STATUS,1)
       CLOSE t290_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t290_cl INTO g_lnb.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lnb.lnb01,SQLCA.sqlcode,0)
      CLOSE t290_cl
      ROLLBACK WORK
      RETURN 
    END IF
    
   IF NOT cl_confirm('alm-008') THEN
      RETURN
   ELSE
#      SELECT occ1004 INTO l_occ1004 FROM occ_file
#       WHERE occ01  = 'MISC'
#        AND occ246 = g_lnb.plant_code
#      IF l_occ1004 != 'Y' OR l_occ1004 IS NULL THEN  #只有處于非審核狀態,才可以取消本筆資料的審核
       LET g_lnb.lnb33 = 'N'
       #CHI-D20015---modify---str---
       #LET g_lnb.lnb34 = NULL 
       #LET g_lnb.lnb35 = NULL
       LET g_lnb.lnb34 = g_user
       LET g_lnb.lnb35 = g_today
       #CHI-D20015---modify---end---
       LET g_lnb.lnbmodu = g_user
       LET g_lnb.lnbdate = g_today
       
#       #####delete occ_file##########
#       DELETE FROM occ_file
#        WHERE occ01  = 'MISC'
#         AND occ246 = g_lnb.plant_code
             
       UPDATE lnb_file
          SET   lnb33 = g_lnb.lnb33,
                lnb34 = g_lnb.lnb34,
                lnb35 = g_lnb.lnb35,
              lnbmodu = g_lnb.lnbmodu,
              lnbdate = g_lnb.lnbdate   
         WHERE lnb01  = g_lnb.lnb01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd lna:',SQLCA.SQLCODE,0)
          LET g_lnb.lnb33 = "Y"
          LET g_lnb.lnb34 = l_lnb34
          LET g_lnb.lnb35 = l_lnb35      
          DISPLAY BY NAME g_lnb.lnb33,g_lnb.lnb34,g_lnb.lnb35
          RETURN
         ELSE        
          DISPLAY BY NAME g_lnb.lnb33,g_lnb.lnb34,g_lnb.lnb35,g_lnb.lnbmodu,g_lnb.lnbdate
         END IF
#     ELSE
#        CALL cl_err('','alm-652',1)
#        RETURN
 #    END IF
   END IF 
    CLOSE t290_cl
  COMMIT WORK    
END FUNCTION
 
FUNCTION t290_pic()
   CASE g_lnb.lnb33
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void    = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void    = ''
      WHEN 'X'  LET g_confirm = ''
                LET g_void    = 'Y'
      OTHERWISE LET g_confirm = ''
                LET g_void    = ''
   END CASE
 
   CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
END FUNCTION
 
FUNCTION t290_v(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废

   IF cl_null(g_lnb.lnb01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lnb.* FROM lnb_file
     WHERE lnb01      = g_lnb.lnb01
 
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_lnb.lnb33 ='X' THEN RETURN END IF
    ELSE
       IF g_lnb.lnb33 <>'X' THEN RETURN END IF
    END IF
   #FUN-D20039 ----------end
   IF g_lnb.lnb33 = 'Y' THEN
      CALL cl_err(g_lnb.lnb01,'9023',0)
      RETURN
   END IF

     BEGIN WORK
    OPEN t290_cl USING g_lnb.lnb01
    
    IF STATUS THEN 
       CALL cl_err("open t290_cl:",STATUS,1)
       CLOSE t290_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t290_cl INTO g_lnb.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lnb.lnb01,SQLCA.sqlcode,0)
      CLOSE t290_cl
      ROLLBACK WORK
      RETURN 
    END IF      
    
   IF g_lnb.lnb33 != 'Y' THEN
      IF g_lnb.lnb33 = 'X' THEN
         IF NOT cl_confirm('alm-086') THEN
            RETURN
         ELSE
            LET g_lnb.lnb33 = 'N'
            LET g_lnb.lnbmodu = g_user
            LET g_lnb.lnbdate = g_today
            UPDATE lnb_file
               SET lnb33 = g_lnb.lnb33,
                   lnbmodu = g_lnb.lnbmodu,
                   lnbdate = g_lnb.lnbdate
             WHERE lnb01 = g_lnb.lnb01
               #AND plant_code = g_lnb.plant_code
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lnb:',SQLCA.SQLCODE,0)
               LET g_lnb.lnb33 = "X"
               DISPLAY BY NAME g_lnb.lnb33
               RETURN
            ELSE
               DISPLAY BY NAME g_lnb.lnb33,g_lnb.lnbmodu,g_lnb.lnbdate
            END IF
         END IF
      ELSE
         IF NOT cl_confirm('alm-085') THEN
            RETURN
         ELSE
            LET g_lnb.lnb33 = 'X'
            LET g_lnb.lnbmodu = g_user
            LET g_lnb.lnbdate = g_today
            UPDATE lnb_file
               SET lnb33 = g_lnb.lnb33,
                   lnbmodu = g_lnb.lnbmodu,
                   lnbdate = g_lnb.lnbdate
             WHERE lnb01 = g_lnb.lnb01
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lnb:',SQLCA.SQLCODE,0)
               LET g_lnb.lnb33 = "N"
               DISPLAY BY NAME g_lnb.lnb33
               RETURN
            ELSE
               DISPLAY BY NAME g_lnb.lnb33,g_lnb.lnbmodu,g_lnb.lnbdate
            END IF
         END IF
      END IF
   END IF
  CLOSE t290_cl
  COMMIT WORK  
END FUNCTION 
#FUN-B90056 Add Begin ---
FUNCTION t290_set_entry_b1(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("lnd02,lnd03",TRUE)
   END IF
END FUNCTION

FUNCTION t290_set_no_entry_b1(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("lnd02,lnd03",FALSE)
   END IF
END FUNCTION 

FUNCTION t290_set_entry_b2(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("lnc02",TRUE)
   END IF
END FUNCTION

FUNCTION t290_set_no_entry_b2(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("lnc02",FALSE)
   END IF
END FUNCTION
#FUN-B90056 Add end ---

#No.FUN-960134 

