# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: almt280.4gl
# Descriptions...: 商戶預登記作業 
# Date & Author..: NO.FUN-870010 08/07/18 By lilingyu 
# Modify.........: No.FUN-960134 09/07/09 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/24 By shiwuying add oriu,orig
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A70063 10/07/13 By chenying azf02 = '3' 抓取品牌代碼改抓 tqa_file.tqa03 = '2';
#                                                     欄位 azf01 改抓 tqa01, 欄位 azf03 改抓 tqa02
# Modify.........: No:FUN-A70063 10/07/14 By chenying q_azfp1替換成q_tqap1 
# Modify.........: No:FUN-A70130 10/08/09 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: NO:FUN-B20037 11/02/17 By huangtao 取消簽核 
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80060 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.FUN-B90056 11/09/06 By fanbj 將almt280單檔修改為雙檔
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30027 12/08/20 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20039 13/01/19 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No.CHI-D20015 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_lna       RECORD   LIKE lna_file.*,  
        g_lna_t     RECORD   LIKE lna_file.*,					
        g_lna_o     RECORD   LIKE lna_file.*,    
        g_lna01_t            LIKE lna_file.lna01,   
        g_lna02_t            LIKE lna_file.lna02
      #  g_lna07_t            LIKE lna_file.lna07,         #FUN-B90056
      #  g_lna08_t            LIKE lna_file.lna08          #FUN-B90056
#FUN-B90056--begin add------------------------------------
DEFINE g_lif              DYNAMIC ARRAY OF RECORD
         lif02               LIKE lif_file.lif02,
         tqa02               LIKE tqa_file.tqa02,
         lif03               LIKE lif_file.lif03,
         lifacti             LIKE lif_file.lifacti 
                          END RECORD,

       g_lif_t            RECORD 
          lif02              LIKE lif_file.lif02,
          tqa02              LIKE tqa_file.tqa02,
          lif03              LIKE lif_file.lif03,
          lifacti            LIKE lif_file.lifacti
                          END RECORD

DEFINE g_wc2                  STRING
DEFINE g_rec_b               LIKE type_file.num5
DEFINE l_ac                  LIKE type_file.num5
#FUN-B90056--end add--------------------------------------
DEFINE g_wc                  STRING 
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
DEFINE g_date                LIKE lna_file.lnadate
DEFINE g_modu                LIKE lna_file.lnamodu
#DEFINE g_kindslip            LIKE lrk_file.lrkslip    #FUN-A70130  mark
DEFINE g_kindslip            LIKE oay_file.oayslip     #FUN-A70130 
 
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

   IF (g_aza.aza113 = 'N') THEN
      CALL cl_err('','alm-798',1)
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_forupd_sql = "SELECT * FROM lna_file WHERE lna01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t280_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR

   #IF (aza113 = 'N') THEN 
   #   CALL cl_err('','alm-798',1)
   #   EXIT PROGRAM
   #END IF
      
 
   OPEN WINDOW t280_w WITH FORM "alm/42f/almt280"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()   
 
   LET g_action_choice = ""
   CALL t280_menu()
 
   CLOSE WINDOW t280_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t280_curs()
   DEFINE lc_qbe_sn    LIKE  gbm_file.gbm01    #FUN-B90056
 
       CLEAR FORM    
       CALL g_lif.clear()                     #FUN-B90056
       CONSTRUCT BY NAME g_wc ON  
 #                        lna01,lna02,lna03,lna04,lna05,lna06,lna07,lna08,        #FUN-B90056 mark
                         lna01,lna02,lna03,lna04,lna05,lna06,                     #FUN-B90056 add
                         lna09,lna11,lna12,lna13,lna14,lna15,lna16,lna17,
#                         lna18,lna19,lna20,lna21,lna22,lna23,lna24,lna25,        #FUN-B20037 mark
                         lna18,lna19,lna20,lna21,lna22,lna23,                     #FUN-B20037
#                         lna26,lna27,lna28,lna29,lnauser,lnagrup,lnaoriu,lnaorig,lnacrat,#No:FUN-9B0136  #FUN-B90056  mark
#                         lnamodu,lnadate            
                         lna26,lna27,lna28,lna29,lnauser,lnagrup,lnaoriu,lnaorig,lnadate,   #FUN-90056 add
                         lnamodu,lnacrat          
 
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
           ON ACTION controlp
              CASE
                 WHEN INFIELD(lna01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lna01"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lna01
                    NEXT FIELD lna01                     
                
                WHEN INFIELD(lna02)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lna02"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lna02
                    NEXT FIELD lna02  
                        
                WHEN INFIELD(lna03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lna03"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lna03
                    NEXT FIELD lna03      
     
                # FUN-B90056 --start mark----------------------------         
     #           WHEN INFIELD(lna07)
     #               CALL cl_init_qry_var()
#    #               LET g_qryparam.form = "q_lna07"     #FUN-A70063 
     #               LET g_qryparam.form = "q_lna07_1"     #FUN-A70063
     #               LET g_qryparam.state = "c"
     #               CALL cl_create_qry() RETURNING g_qryparam.multiret
     #               DISPLAY g_qryparam.multiret TO lna07
     #               NEXT FIELD lna07      
     #            
     #           WHEN INFIELD(lna08)
     #               CALL cl_init_qry_var()
     #               LET g_qryparam.form = "q_lna08"
     #               LET g_qryparam.state = "c"
     #               CALL cl_create_qry() RETURNING g_qryparam.multiret
     #               DISPLAY g_qryparam.multiret TO lna08
     #               NEXT FIELD lna08           
               #FUN-B90056 --end mark-----------------------------------
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
       IF INT_FLAG THEN
          RETURN
       END IF
   
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN   
    #        LET g_wc = g_wc clipped," AND lnauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN   
    #        LET g_wc = g_wc clipped," AND lnagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN 
    #        LET g_wc = g_wc clipped," AND lnagrup IN",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lnauser', 'lnagrup')
    #End:FUN-980030

    #FUN-B90056---begin add--------------------------------------------------------------
    CONSTRUCT g_wc2 ON lif02,lif03,lifacti
                  FROM s_lif[1].lif02,s_lif[1].lif03,s_lif[1].lifacti

       BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)

       ON ACTION controlp
          CASE
             WHEN INFIELD(lif02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lif01"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO lif02
                NEXT FIELD lif02
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

    IF INT_FLAG THEN
       RETURN
    END IF 

    IF g_wc2= " 1=1" THEN
       LET g_sql = "SELECT lna01 FROM lna_file ",
                   " WHERE ",g_wc CLIPPED,
                   " ORDER BY lna01"
    ELSE 
       LET g_sql = " SELECT DISTINCT lna01 ",
                   "   FROM lna_file,lif_file ",
                   "  WHERE lif01 = lna01 ",
                   "    AND ",g_wc CLIPPED ,
                   "    AND ",g_wc2 CLIPPED ,
                   "  ORDER BY lna01"
    END IF 
    #FUN-B90056---end add-------------------------------------------------------
    #FUN-B90056---begin mark----------------------------------------------------
    #LET g_sql = "SELECT lna01 FROM lna_file ",
    #           " WHERE ",g_wc CLIPPED,
    #            " ORDER BY lna01"
    #FUN-B90056---end mark------------------------------------------------------
    PREPARE t280_prepare FROM g_sql
    DECLARE t280_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t280_prepare
 
    #LET g_sql = "SELECT COUNT(*) FROM lna_file WHERE ",g_wc CLIPPED   #FUN-B90056 mark
    #FUN-B90056---begin add----------------------------------------------------------
    IF g_wc2 = " 1=1" THEN
       LET g_sql = " SELECT count( DISTINCT lna01) FROM lna_file WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql = " SELECT count( DISTINCT lna01) ",
                   "   FROM lna_file,lif_file ",
                   "  WHERE lif01 = lna01 ",
                   "    AND ",g_wc CLIPPED ,
                   "    AND ",g_wc2 CLIPPED ,
                   "  ORDER BY lna01"

    END IF
    #FUN-B90056---end add------------------------------------------------------------
    PREPARE t280_precount FROM g_sql
    DECLARE t280_count CURSOR FOR t280_precount
END FUNCTION
#FUN-B90056---begin mark----------------------------------------------------------------------- 
#FUNCTION t280_menu()
# #DEFINE   l_lrkdmy2      LIKE lrk_file.lrkdmy2   #FUN-A70130  mark
#  DEFINE   l_oayconf      LIKE oay_file.oayconf   #FUN-A70130
# 
#    MENU ""
#        BEFORE MENU
#           CALL cl_navigator_setting(g_curs_index,g_row_count)
#        
#        ON ACTION insert
#           LET g_action_choice="insert"
#           IF cl_chk_act_auth() THEN
#              CALL t280_a()
#               ##自動審核                                                     
#              LET g_kindslip=s_get_doc_no(g_lna.lna01)                                         
#                 IF NOT cl_null(g_kindslip) THEN
#           #FUN-A70130 ---------------------start------------------------------
#           #         SELECT lrkdmy2 INTO l_lrkdmy2 FROM lrk_file                              
#           #          WHERE lrkslip = g_kindslip                                                 
#           #         IF l_lrkdmy2 = 'Y' THEN 
#                     SELECT oayconf INTO l_oayconf FROM oay_file
#                     WHERE oayslip = g_kindslip
#                     IF l_oayconf = 'Y' THEN
#           #FUN-A70130 ---------------------end--------------------------------           
#                       IF cl_null(g_lna.lna04) THEN
#                          CALL cl_err('','alm-618',1)
#                       ELSE
#                        CALL t280_confirm()  
#                       END IF     
#                    END IF                                                                      
#                END IF           
#           END IF
# 
#        ON ACTION query
#           LET g_action_choice="query"
#           IF cl_chk_act_auth() THEN
#              CALL t280_q()
#           END IF
# 
#        ON ACTION next
#           CALL t280_fetch('N')
# 
#        ON ACTION previous
#           CALL t280_fetch('P')
# 
#        ON ACTION modify
#           LET g_action_choice="modify"
#           IF cl_chk_act_auth() THEN
#              CALL t280_u('w')
#           END IF   
#   
#        ON ACTION delete
#           LET g_action_choice="delete"
#           IF cl_chk_act_auth() THEN
#              CALL t280_r()
#           END IF
# 
#        ON ACTION reproduce
#           LET g_action_choice="reproduce"
#           IF cl_chk_act_auth() THEN
#              CALL t280_copy()
#           END IF    
#           
#        ON ACTION confirm
#           LET g_action_choice="confirm"
#           IF cl_chk_act_auth() THEN
#              IF cl_null(g_lna.lna04) THEN 
#                 CALL cl_err('','alm-618',1)
#                ELSE 
#                   CALL t280_confirm()
#               END IF     
#           END IF   
#           CALL t280_pic()
#                   
#        ON ACTION unconfirm
#           LET g_action_choice="unconfirm"
#           IF cl_chk_act_auth() THEN
#              CALL t280_unconfirm()
#           END IF   
#           CALL t280_pic()
#           
#        ON ACTION void
#           LET g_action_choice = "void"
#           IF cl_chk_act_auth() THEN 
#              CALL t280_v()
#           END IF    
#           CALL t280_pic()
#           
#        ON ACTION help
#           CALL cl_show_help()
# 
#        ON ACTION exit
#           LET g_action_choice = "exit"
#           EXIT MENU
# 
#        ON ACTION jump
#           CALL t280_fetch('/')
# 
#        ON ACTION first
#           CALL t280_fetch('F')
# 
#        ON ACTION last
#           CALL t280_fetch('L')
# 
#        ON ACTION controlg
#           CALL cl_cmdask()
# 
#        ON ACTION locale
#           CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont() 
#           CALL t280_pic() 
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
#        ON ACTION related_document 
#           LET g_action_choice="related_document"
#           IF cl_chk_act_auth() THEN
#              IF NOT cl_null(g_lna.lna01) THEN
#                 LET g_doc.column1 = "lna01"
#                 LET g_doc.value1 = g_lna.lna01
#                 CALL cl_doc()
#              END IF
#           END IF
# 
#    END MENU
#    CLOSE t280_cs
#END FUNCTION
#FUN-B90056---end mark---------------------------------------------------------------

#FUN-B90056---begin add--------------------------------------------------------------
FUNCTION t280_menu()
   DEFINE   l_oayconf      LIKE oay_file.oayconf   

   WHILE TRUE
      CALL t280_bp("G")

      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t280_a()
               ##自動審核
               LET g_kindslip=s_get_doc_no(g_lna.lna01)
               IF NOT cl_null(g_kindslip) THEN
                  SELECT oayconf INTO l_oayconf FROM oay_file
                   WHERE oayslip = g_kindslip
                  IF l_oayconf = 'Y' THEN
                     IF cl_null(g_lna.lna04) THEN
                        CALL cl_err('','alm-618',1)
                     ELSE
                        CALL t280_confirm()
                     END IF
                  END IF
               END IF
            END IF 

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t280_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t280_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t280_u("u")
            END IF

         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t280_copy()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t280_b("u")
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "confirm"
           IF cl_chk_act_auth() THEN
              IF cl_null(g_lna.lna04) THEN
                 CALL cl_err('','alm-618',1)
                ELSE
                   CALL t280_confirm()
               END IF
           END IF
           CALL t280_pic()

        WHEN "undo_confirm "
           IF cl_chk_act_auth() THEN
              CALL t280_unconfirm()
           END IF
           CALL t280_pic()

        WHEN "void"
           IF cl_chk_act_auth() THEN
              CALL t280_v(1)
           END IF
           CALL t280_pic()

        #FUN-D20039 --------sta
        WHEN "undo_void"
           IF cl_chk_act_auth() THEN
              CALL t280_v(2)
           END IF
           CALL t280_pic()
        #FUN-D20039 --------end

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_lif),'','')
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
#FUN-B90056---end add---------------------------------------------------------------
 
FUNCTION t280_a()
DEFINE li_result     LIKE type_file.num5 
 
    MESSAGE ""
    CLEAR FORM   
    CALL g_lif.clear()   #FUN-B90056 add
    
    INITIALIZE g_lna.*    LIKE lna_file.*       
    INITIALIZE g_lna_t.*  LIKE lna_file.*
    INITIALIZE g_lna_o.*  LIKE lna_file.*     
   
     LET g_lna01_t = NULL
     LET g_lna02_t = NULL

     #FUN-B90056--start mark--
     #LET g_lna07_t = NULL  
     #LET g_lna08_t = NULL 
     #FUN-B90056--end mark----  

     LET g_wc = NULL
     CALL cl_opmsg('a')     
     
     WHILE TRUE
        LET g_lna.lnauser = g_user
        LET g_lna.lnaoriu = g_user #FUN-980030
        LET g_lna.lnaorig = g_grup #FUN-980030
        LET g_lna.lnagrup = g_grup 
        LET g_lna.lnacrat = g_today
        LET g_lna.lnadate = g_today   #FUN-B90056 add
        LET g_lna.lna23 = 0
        LET g_lna.lna24   = 'N'
        LET g_lna.lna25   = '0'
        LET g_lna.lna26   = 'N'
        
        CALL t280_i("a","")    
 
        IF INT_FLAG THEN  
           LET INT_FLAG = 0
           INITIALIZE g_lna.* TO NULL
           LET g_lna01_t = NULL
           LET g_lna02_t = NULL
          
          #FUN-B90056--------------    
#           LET g_lna07_t = NULL
#           LET g_lna08_t = NULL  
          #FUN-B90056---------------

           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        
        IF cl_null(g_lna.lna01) THEN    
           CONTINUE WHILE
        END IF        
      ####自動編號#################
      BEGIN WORK
      #CALL s_auto_assign_no("alm",g_lna.lna01,g_lna.lnacrat,'12',"lna_file","lna01","","","") #FUN-A70130
      CALL s_auto_assign_no("alm",g_lna.lna01,g_lna.lnacrat,'L1',"lna_file","lna01","","","") #FUN-A70130
         RETURNING li_result,g_lna.lna01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lna.lna01
      ##############################    
      INSERT INTO lna_file VALUES(g_lna.*)                   
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        #   ROLLBACK WORK        #FUN-B80060 下移兩行
         CALL cl_err(g_lna.lna01,SQLCA.SQLCODE,0)
         ROLLBACK WORK         #FUN-B80060
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         SELECT * INTO g_lna.* FROM lna_file
          WHERE lna01 = g_lna.lna01
      END IF
      #FUN-B90056--begin add--------
      LET g_lna01_t=g_lna.lna01
      LET g_lna_t.*=g_lna.*
      LET g_lna_o.*=g_lna.*

      CALL g_lif.clear()
      LET g_rec_b=0
      CALL t280_b("a") 
      #FUN-B90056--end add-----------
      EXIT WHILE
   END WHILE
   LET g_wc = NULL
END FUNCTION
 
FUNCTION t280_i(p_cmd,w_cmd)
DEFINE   p_cmd      LIKE type_file.chr1 
DEFINE   w_cmd      LIKE type_file.chr1 
DEFINE   l_cnt      LIKE type_file.num5 
DEFINE   l_count    LIKE type_file.num5 
DEFINE   li_result  LIKE type_file.num5 
 
#   DISPLAY BY NAME  g_lna.lna24,g_lna.lna25,g_lna.lna26,           #FUN-B20037  mark
    DISPLAY BY NAME g_lna.lna26,                                    #FUN-B20037  add
                    g_lna.lnauser,g_lna.lnagrup,g_lna.lnacrat,g_lna.lnamodu,
                    g_lna.lnadate                    
              
   INPUT BY NAME  g_lna.lna01,g_lna.lna02,g_lna.lna03,g_lna.lna04,g_lna.lna05, g_lna.lnaoriu,g_lna.lnaorig,
     #             g_lna.lna06,g_lna.lna07,g_lna.lna08,g_lna.lna09,g_lna.lna11,       #FUN-B90056 mark
                  g_lna.lna06,g_lna.lna09,g_lna.lna11,                                #FUN-B90056 add
                  g_lna.lna12,g_lna.lna13,g_lna.lna14,g_lna.lna15,g_lna.lna16,
                  g_lna.lna17,g_lna.lna18,g_lna.lna19,g_lna.lna20,g_lna.lna21,
                  g_lna.lna22,g_lna.lna23,g_lna.lna29
    WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE  
          CALL t280_set_entry(p_cmd)        
          CALL t280_set_no_entry(p_cmd)  
          CALL cl_set_docno_format("lna01")      
          LET g_before_input_done = TRUE
          
      AFTER FIELD lna01 
          IF NOT cl_null(g_lna.lna01) THEN
            #CALL s_check_no("alm",g_lna.lna01,g_lna01_t,'12',"lna_file","lna01","") #FUN-A70130
            CALL s_check_no("alm",g_lna.lna01,g_lna01_t,'L1',"lna_file","lna01","") #FUN-A70130
                 RETURNING li_result,g_lna.lna01
            IF (NOT li_result) THEN
               LET g_lna.lna01=g_lna_t.lna01
               NEXT FIELD lna01
            END IF
              DISPLAY BY NAME g_lna.lna01
          END IF           
 
      AFTER FIELD lna02
          IF NOT cl_null(g_lna.lna02) THEN 
                CALL t280_lna02(p_cmd)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                    LET g_lna.lna02 = g_lna_t.lna02                                                 
                    DISPLAY BY NAME g_lna.lna02                                              
                    NEXT FIELD lna02 
                END IF
          END IF 
      
      AFTER FIELD lna03
        IF NOT cl_null(g_lna.lna03) THEN 
           IF p_cmd = 'a' OR
             (p_cmd = 'u' AND g_lna.lna03 != g_lna_t.lna03) OR
             (p_cmd = 'u' AND w_cmd = 'h') OR
             (P_cmd = 'u' AND g_lna_t.lna03 IS NULL) THEN
           LET l_count = 0 
           SELECT COUNT(*) INTO l_count FROM lna_file
            WHERE lna03 = g_lna.lna03
           IF l_count > 0 THEN 
              CALL cl_err('','alm-617',1)
              NEXT FIELD lna03
           END IF   
          END IF
        END IF 
      
      AFTER FIELD lna04 
         IF NOT cl_null(g_lna.lna04) THEN
           IF p_cmd = 'a' OR
             (p_cmd = 'u' AND g_lna.lna04 != g_lna_t.lna04) OR
             (p_cmd = 'u' AND w_cmd = 'h') OR
             (p_cmd = 'u' AND g_lna_t.lna04 IS NULL) THEN
           LET l_count = 0 
           SELECT COUNT(*) INTO l_count FROM lna_file
            WHERE lna04 = g_lna.lna04
           IF l_count > 0 THEN 
              CALL cl_err('','alm-613',1)
              NEXT FIELD lna04
           END IF   
          END IF
       END IF
          
      #FUN-B90056--start mark------------------------- 
      #  AFTER FIELD lna07
      #    IF NOT cl_null(g_lna.lna07) THEN 
      #          CALL t280_lna07(p_cmd)
      #          IF NOT cl_null(g_errno) THEN
      #             CALL cl_err('',g_errno,0)
      #              LET g_lna.lna07 = g_lna_t.lna07                    
      #              DISPLAY BY NAME g_lna.lna07                  
      #              NEXT FIELD lna07 
      #          END IF
      #    END IF  
      # 
      # AFTER FIELD lna08
      #    IF NOT cl_null(g_lna.lna08) THEN 
      #          CALL t280_lna08(p_cmd)
      #          IF NOT cl_null(g_errno) THEN
      #             CALL cl_err('',g_errno,0)
      #              LET g_lna.lna08 = g_lna_t.lna08
      #              DISPLAY BY NAME g_lna.lna08
      #              NEXT FIELD lna08
      #          END IF
      #    END IF            
      #FUN-B90056--end mark------------------------------  

     AFTER FIELD lna23 
         IF NOT cl_null(g_lna.lna23) THEN
            IF g_lna.lna23 < 0 THEN
               CALL cl_err('','alm-236',1)
               NEXT FIELD lna23 
            END IF 
         END IF     
   
 
     AFTER INPUT
        LET g_lna.lnauser = s_get_data_owner("lna_file") #FUN-C10039
        LET g_lna.lnagrup = s_get_data_group("lna_file") #FUN-C10039
        IF INT_FLAG THEN
           EXIT INPUT
        ELSE
           IF NOT cl_null(g_lna.lna03) THEN                     
              IF p_cmd = 'a' OR                                   
                (p_cmd = 'u' AND g_lna.lna03 != g_lna_t.lna03) OR                          
                (p_cmd = 'u' AND w_cmd = 'h') OR
                (P_cmd = 'u' AND g_lna_t.lna03 IS NULL) THEN                              
                LET l_count = 0                                                        
                SELECT COUNT(*) INTO l_count FROM lna_file                        
                 WHERE lna03 = g_lna.lna03                                                         
                 IF l_count > 0 THEN                                                          
                     CALL cl_err('','alm-617',1)                                                    
                     NEXT FIELD lna03                                                              
                 END IF                                                                             
               END IF                                                                              
           END IF        
            IF NOT cl_null(g_lna.lna04) THEN                                                      
                IF p_cmd = 'a' OR                                                    
                   (p_cmd = 'u' AND g_lna.lna04 != g_lna_t.lna04) OR                      
                   (p_cmd = 'u' AND w_cmd = 'h') OR
                   (p_cmd = 'u' AND g_lna_t.lna04 IS NULL) THEN                                     
                   LET l_count = 0                                                           
                   SELECT COUNT(*) INTO l_count FROM lna_file                                           
                    WHERE lna04 = g_lna.lna04                                                         
                    IF l_count > 0 THEN                                                                 
                       CALL cl_err('','alm-613',1)                                                
                       NEXT FIELD lna04                                                                 
                    END IF                                                                                 
                END IF                                                                                
             END IF        
        END IF      
      
     ON ACTION CONTROLP
        CASE 
            WHEN INFIELD(lna01)
               LET g_kindslip = s_get_doc_no(g_lna.lna01)
              # CALL q_lrk(FALSE,FALSE,g_kindslip,'12','ALM') RETURNING g_kindslip      #FUN-A70130  mark
                CALL q_oay(FALSE,FALSE,g_kindslip,'L1','ALM') RETURNING g_kindslip      #FUN-A70130  add
               LET g_lna.lna01 = g_kindslip
               DISPLAY BY NAME g_lna.lna01
               NEXT FIELD lna01
          
          WHEN INFIELD(lna02)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_rtz28"  
            LET g_qryparam.default1 = g_lna.lna02
            CALL cl_create_qry() RETURNING g_lna.lna02
            DISPLAY BY NAME g_lna.lna02
            NEXT FIELD lna02
       
       #FUN-B90056--start mark-----------------------------      
       #   WHEN INFIELD(lna07)
       #     CALL cl_init_qry_var()
#      #     LET g_qryparam.form = "q_azfp1"              #FUN-A70063
       #     LET g_qryparam.form = "q_tqap1"              #FUN-A70063 add
       #     LET g_qryparam.default1 = g_lna.lna07
       #     CALL cl_create_qry() RETURNING g_lna.lna07
       #     DISPLAY BY NAME g_lna.lna07
       #     NEXT FIELD lna07 
       # 
       #  WHEN INFIELD(lna08)
       #     CALL cl_init_qry_var()
       #     LET g_qryparam.form = "q_geo"  
       #     LET g_qryparam.default1 = g_lna.lna08
       #     CALL cl_create_qry() RETURNING g_lna.lna08
       #     DISPLAY BY NAME g_lna.lna08
       #     NEXT FIELD lna08 
       #FUN-B90056--end mark-----------------------------
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
 
FUNCTION t280_q()
    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    
    INITIALIZE g_lna.* TO NULL
    INITIALIZE g_lna_t.* TO NULL
    INITIALIZE g_lna_o.* TO NULL
    
    LET g_lna01_t = NULL
    LET g_lna02_t = NULL
  #  LET g_lna07_t = NULL  #FUN-B90056
  #  LET g_lna08_t = NULL  #FUN-B90056
    LET g_wc = NULL
    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    
    CALL t280_curs()  
          
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_lna.* TO NULL
       CALL g_lif.clear()        #FUN-B90056 add
       LET g_lna01_t = NULL
       LET g_lna02_t = NULL
  #     LET g_lna07_t = NULL    #FUN-B90056 mark
  #     LET g_lna08_t = NULL    #FUN-B90056 mark
       LET g_wc = NULL
       RETURN
    END IF
    
    OPEN t280_count
    FETCH t280_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t280_cs   
         
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lna.lna01,SQLCA.sqlcode,0)
       INITIALIZE g_lna.* TO NULL
       LET g_lna01_t = NULL
       LET g_lna02_t = NULL
    #   LET g_lna07_t = NULL    #FUN-B90056 mark
    #   LET g_lna08_t = NULL    #FUN-B90056 mark
       LET g_wc = NULL
    ELSE
       CALL t280_fetch('F')  
    END IF
END FUNCTION
 
FUNCTION t280_fetch(p_icb)
 DEFINE p_icb LIKE type_file.chr1 
 
    CASE p_icb
        WHEN 'N' FETCH NEXT     t280_cs INTO g_lna.lna01
        WHEN 'P' FETCH PREVIOUS t280_cs INTO g_lna.lna01
        WHEN 'F' FETCH FIRST    t280_cs INTO g_lna.lna01
        WHEN 'L' FETCH LAST     t280_cs INTO g_lna.lna01
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
            FETCH ABSOLUTE g_jump t280_cs INTO g_lna.lna01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lna.lna01,SQLCA.sqlcode,0)
       INITIALIZE g_lna.* TO NULL
       LET g_lna01_t = NULL
       LET g_lna02_t = NULL
    #   LET g_lna07_t = NULL    #FUN-B90056
    #   LET g_lna08_t = NULL    #FUN-B90056 
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
      DISPLAY g_curs_index TO  FORMONLY.indx
    END IF
 
    SELECT * INTO g_lna.* FROM lna_file  
     WHERE lna01 = g_lna.lna01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lna.lna01,SQLCA.sqlcode,0)
    ELSE
       LET g_data_owner = g_lna.lnauser 
       LET g_data_group = g_lna.lnagrup
       CALL t280_show() 
    END IF
END FUNCTION
 
FUNCTION t280_show()
    LET g_lna_t.* = g_lna.*
    LET g_lna_o.* = g_lna.*
    DISPLAY BY NAME g_lna.lna01,g_lna.lna02,g_lna.lna03,g_lna.lna04,g_lna.lna05, g_lna.lnaoriu,g_lna.lnaorig,
#                    g_lna.lna06,g_lna.lna07,g_lna.lna08,g_lna.lna09,g_lna.lna11,             #FUN-B90056 mark
                    g_lna.lna06,g_lna.lna09,g_lna.lna11,                                      #FUN-B90056 add 
                    g_lna.lna12,g_lna.lna13,g_lna.lna14,g_lna.lna15,g_lna.lna16,
                    g_lna.lna17,g_lna.lna18,g_lna.lna19,g_lna.lna20,g_lna.lna21,
#                    g_lna.lna22,g_lna.lna23,g_lna.lna24,g_lna.lna25,g_lna.lna26,                #FUN-B20037  mark
                    g_lna.lna22,g_lna.lna23,g_lna.lna26,                                         #FUN-B20037  add
                    g_lna.lna27,g_lna.lna28,g_lna.lna29,
                    g_lna.lnauser,g_lna.lnagrup,g_lna.lnacrat,g_lna.lnamodu,
                    g_lna.lnadate 
              
    CALL cl_show_fld_cont()  
    CALL t280_pic()
    CALL t280_lna02('d')
 #   CALL t280_lna07('d')         #FUN-B90056 mark
 #   CALL t280_lna08('d')         #FUN-B90056 mark  
    CALL t280_b_fill(g_wc2)
END FUNCTION

FUNCTION t280_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
  
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lif TO s_lif.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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

   ON ACTION delete
      LET g_action_choice="delete"
      EXIT DISPLAY

   ON ACTION modify
      LET g_action_choice="modify"
      EXIT DISPLAY

   ON ACTION confirm
      LET g_action_choice="confirm"
      EXIT DISPLAY

   ON ACTION undo_confirm
      LET g_action_choice="undo_confirm"
      EXIT DISPLAY
   
   ON ACTION void
      LET g_action_choice="void"
      EXIT DISPLAY
   
   #FUN-D20039 ---------sta
   ON ACTION undo_void
      LET g_action_choice="undo_void"
      EXIT DISPLAY
   #FUN-D20039 ---------end  

   ON ACTION first
      CALL t280_fetch('F')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
      ACCEPT DISPLAY

   ON ACTION previous
      CALL t280_fetch('P')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
      ACCEPT DISPLAY

   ON ACTION jump
      CALL t280_fetch('/')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
      ACCEPT DISPLAY

   ON ACTION next
      CALL t280_fetch('N')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
      ACCEPT DISPLAY

   ON ACTION last
      CALL t280_fetch('L')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
      ACCEPT DISPLAY

   ON ACTION reproduce
      LET g_action_choice="reproduce"
      EXIT DISPLAY

   ON ACTION detail
      LET g_action_choice="detail"
      LET l_ac=1
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

   ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

   AFTER DISPLAY
      CONTINUE DISPLAY

   ON ACTION controls
      CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION
 
FUNCTION t280_u(p_w)
DEFINE   p_w   LIKE type_file.chr1
 
    IF cl_null(g_lna.lna01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF    
    
    SELECT * INTO g_lna.* FROM lna_file 
      WHERE lna01  = g_lna.lna01
  
   IF g_lna.lna26 = 'Y' THEN
      CALL cl_err(g_lna.lna01,'alm-027',1)
     RETURN
   END IF    
 
   IF g_lna.lna26 = 'X' THEN
      CALL cl_err(g_lna.lna01,'alm-134',1)
     RETURN
   END IF    
   
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lna01_t = g_lna.lna01
    
    BEGIN WORK
 
    OPEN t280_cl USING g_lna.lna01
    IF STATUS THEN
       CALL cl_err("OPEN t280_cl:",STATUS,1)
       CLOSE t280_cl
       ROLLBACK WORK
       RETURN
    END IF
    
    FETCH t280_cl INTO g_lna.*  
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lna.lna01,SQLCA.sqlcode,1)
       CLOSE t280_cl
       ROLLBACK WORK
       RETURN
    END IF
    
   ###############
   LET g_date = g_lna.lnadate
   LET g_modu = g_lna.lnamodu
   ############### 
  IF p_w != 'c' THEN 
    LET g_lna.lnamodu = g_user  
    LET g_lna.lnadate = g_today 
  ELSE
    LET g_lna.lnamodu = NULL  
  END IF   
  
    CALL t280_show()    
    
    WHILE TRUE
        IF p_w != 'c' THEN
          CALL t280_i("u","")     
        ELSE
          CALL t280_i("u","h") 
        END IF   
        
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           ###############
           LET g_lna_t.lnadate = g_date
           LET g_lna_t.lnamodu = g_modu
           ###############
           LET g_lna.*=g_lna_t.*
           CALL t280_show()
           CALL cl_err('',9001,0)        
           EXIT WHILE
        END IF

        #FUN-B90056---begin add--------------------------
        IF g_lna.lna01 != g_lna01_t THEN
         UPDATE lif_file
            SET lif01 = g_lna.lna01
          WHERE lif01 = g_lna01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lif_file",g_lna01_t,
                  "",SQLCA.sqlcode,"","lif",1)
            CONTINUE WHILE
         END IF
      END IF
      #FUN-B90056---end add-------------------------------
 
       UPDATE lna_file SET lna_file.* = g_lna.* 
         WHERE lna01 = g_lna01_t
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_lna.lna01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t280_cl
    COMMIT WORK

    SELECT * INTO g_lna.*
     FROM lna_file
    WHERE lna01=g_lna.lna01
    
   CALL t280_show()
   CALL cl_flow_notify(g_lna.lna01,'U')
   CALL t280_b_fill("1=1")
   CALL t280_bp_refresh()
END FUNCTION
 
FUNCTION t280_r()
    IF cl_null(g_lna.lna01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_lna.lna26 = 'Y' THEN 
       CALL cl_err(g_lna.lna01,'alm-028',1)
       RETURN
     END IF
       
    IF g_lna.lna26 = 'X' THEN 
       CALL cl_err(g_lna.lna01,'alm-134',1)
       RETURN
     END IF
    BEGIN WORK
 
    OPEN t280_cl USING g_lna.lna01
    IF STATUS THEN
       CALL cl_err("OPEN t280_cl:",STATUS,0)
       CLOSE t280_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t280_cl INTO g_lna.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lna.lna01,SQLCA.sqlcode,0)
       CLOSE t280_cl
       ROLLBACK WORK
       RETURN
    END IF
    
    CALL t280_show()
    
   # IF cl_delete() THEN                  #FUN-B90056  mark
     IF cl_delh(0,0) THEN                 #FUN-B90056  add
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lna01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lna.lna01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM lna_file 
      #  WHERE plant_code = g_lna.plant_code
        #FUN-B90056---begin add-------------------
        WHERE lna01 = g_lna.lna01

       DELETE FROM lif_file
        WHERE lif01 =g_lna.lna01

       CALL g_lif.clear()
       #FUN-B90056---end add--------------------
       CLEAR FORM
       OPEN t280_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t280_cs
          CLOSE t280_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t280_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t280_cs
          CLOSE t280_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       #DISPLAY g_row_count TO FORMONLY.cn2    #FUN-B90056--mark
       DISPLAY g_row_count TO FORMONLY.cnt     #FUN-B90056--add
       OPEN t280_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t280_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL t280_fetch('/')
       END IF
    END IF
    CLOSE t280_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t280_copy()
DEFINE l_newno   LIKE lna_file.lna01
DEFINE l_oldno   LIKE lna_file.lna01
DEFINE li_result LIKE type_file.num5 
 
    IF cl_null(g_lna.lna01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL t280_set_entry('a')
    CALL cl_set_docno_format("lna01")
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM lna01
 
        AFTER FIELD lna01 
          IF NOT cl_null(l_newno) THEN           
            #CALL s_check_no("alm",l_newno,"",'12',"lna_file","lna01","") #FUN-A70130
            CALL s_check_no("alm",l_newno,"",'L1',"lna_file","lna01","") #FUN-A70130
              RETURNING li_result,l_newno
            IF (NOT li_result) THEN
               LET l_newno = NULL
               DISPLAY l_newno TO lna01
               NEXT FIELD lna01
            END IF
          ELSE 
          	 CALL cl_err('','alm-055',1)
          	 NEXT FIELD lna01    
          END IF
 
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          ELSE
         ###自動編號#############     
            BEGIN WORK
            #CALL s_auto_assign_no("alm",l_newno,g_today,'12',"lna_file","lna01","","","") #FUN-A70130
            CALL s_auto_assign_no("alm",l_newno,g_today,'L1',"lna_file","lna01","","","") #FUN-A70130
              RETURNING li_result,l_newno
            IF (NOT li_result) THEN
               RETURN 
            END IF	
            DISPLAY l_newno TO lna01
          ######################    
          END IF
       
        ON ACTION controlp
          CASE
            WHEN INFIELD(lna01)     #單據編號
               LET g_kindslip = s_get_doc_no(l_newno)
              # CALL q_lrk(FALSE,FALSE,g_kindslip,'12','ALM') RETURNING g_kindslip  #FUN-A70130 mark
             CALL q_oay(FALSE,FALSE,g_kindslip,'L1','ALM') RETURNING g_kindslip     #FUN-A70130  add 
               LET l_newno = g_kindslip
               DISPLAY l_newno TO lna01
               NEXT FIELD lna01
            
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
       DISPLAY BY NAME g_lna.lna01
       RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM lna_file
     WHERE lna01=g_lna.lna01
      INTO TEMP x
    UPDATE x
        SET lna01=l_newno,      
            lnauser=g_user, 
            lnagrup=g_grup, 
            lnamodu=NULL, 
            lnadate=NULL,  
            lnacrat=g_today,  
            lna27 = NULL,
            lna28 = NULL,
            lna26 = 'N' ,
            lna04 = NULL,
            lna03 = NULL 
    INSERT INTO lna_file SELECT * FROM x
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
    #   ROLLBACK WORK  # FUN-B80060 下移兩行
       CALL cl_err(l_newno,SQLCA.sqlcode,0)
       ROLLBACK WORK  # FUN-B80060 
    ELSE
        DROP TABLE y1
       SELECT *
         FROM lif_file
        WHERE lif01 = g_lna.lna01
         INTO TEMP y1

         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
            RETURN
         END IF

         UPDATE y1
            SET lif01 = l_newno
         INSERT INTO lif_file
         SELECT * FROM y1
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lif_file","","",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
         
       COMMIT WORK
       MESSAGE 'ROW(',l_newno,') O.K'
       LET l_oldno = g_lna.lna01
       LET g_lna.lna01 = l_newno
       
       SELECT lna_file.* INTO g_lna.*
         FROM lna_file
        WHERE lna01 = l_newno
        
       CALL t280_u('c')
       CALL t280_b("a")
       #SELECT lna_file.* INTO g_lna.*  #FUN-C30027
       #  FROM lna_file                 #FUN-C30027
       # WHERE lna01 = l_oldno          #FUN-C30027
    END IF
    
    #LET g_lna.lna01 = l_oldno          #FUN-C30027
    CALL t280_show()
    
END FUNCTION
 
FUNCTION t280_set_entry(p_cmd)
DEFINE   p_cmd    LIKE type_file.chr1 
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lna01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t280_lna02(p_cmd)
 DEFINE p_cmd      LIKE type_file.chr1
 DEFINE l_rtz13    LIKE rtz_file.rtz13  #FUN-A80148 add
 DEFINE l_rtz28    LIKE rtz_file.rtz28  #FUN-A80148 add
 
   LET g_errno = ''
   SELECT rtz13,rtz28 INTO l_rtz13,l_rtz28
     FROM rtz_file
    WHERE rtz01 = g_lna.lna02
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-077'
                               LET l_rtz13 = ''
                               LET l_rtz28 = ''
        WHEN l_rtz28 <> 'Y'    LET g_errno = 'alm-120'
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_rtz13 TO FORMONLY.rtz13
   END IF
END FUNCTION 

#FUN-B90056--start mark-------------------------------------------------- 
#FUNCTION t280_lna07(p_cmd)
# DEFINE p_cmd      LIKE type_file.chr1
# DEFINE l_count    LIKE type_file.num5
##DEFINE l_azfacti  LIKE azf_file.azfacti              #FUN-A70063  mark  
##DEFINE l_azf03    LIKE azf_file.azf03                #FUN-A70063  mark
# DEFINE l_tqaacti  LIKE tqa_file.tqaacti              #FUN-A70063
# DEFINE l_tqa02    LIKE tqa_file.tqa02                #FUN-A70063
# 
#   LET g_errno = ''
#
##FUN-A70063--begin--
##  SELECT azf03,azfacti INTO l_azf03,l_azfacti
##    FROM azf_file
##   WHERE azf01 = g_lna.lna07
##     AND azf02 = '3'
##FUN-A70063--end--
#
##FUN-A70063--begin--
#   SELECT * FROM tqa_file WHERE tqa01 = g_lna.lna07 AND tqa03 = '2'
#   IF SQLCA.sqlcode=100 THEN  LET g_errno='alm1002'
#   ELSE
#     SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti 
#       FROM tqa_file 
#      WHERE tqa03 = '2' 
#        AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
#             OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))  
#        AND tqa01 = g_lna.lna07
##FUN-A70063--end--
#
#   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm1004'   #FUN-A70063 
##                              LET l_azf03 = ''        #FUN-A70063 mark
#                               LET l_tqa02 = ''        #FUN-A70063 
##       WHEN l_azfacti='N'     LET g_errno='9028'      #FUN-A70063 mark 
#        WHEN l_tqaacti='N'     LET g_errno='9028'      #FUN-A70063
#        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#   END CASE
# END IF
# #No.FUN-9B0136 BEGIN -----
#   IF cl_null(g_errno) THEN
#      SELECT COUNT(*) INTO l_count FROM lne_file
#       WHERE lne08 = g_lna.lna07
#         AND lne36 = 'Y'
#      IF l_count > 0 THEN
#         LET g_errno = 'alm-706'
#      END IF
#   END IF
# #No.FUN-9B0136 END -------
#   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
##     DISPLAY l_azf03 TO FORMONLY.azf03          #FUN-A70063
#      DISPLAY l_tqa02 TO FORMONLY.tqa02          #FUN-A70063
#   END IF
#END FUNCTION 
# 
#FUNCTION t280_lna08(p_cmd)
# DEFINE p_cmd      LIKE type_file.chr1
# DEFINE l_geo02    LIKE geo_file.geo02
# DEFINE l_geoacti  LIKE geo_file.geoacti
# 
#   LET g_errno = ''
#   SELECT geo02,geoacti INTO l_geo02,l_geoacti
#     FROM geo_file
#    WHERE geo01 = g_lna.lna08
#   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-124'
#                               LET l_geo02 = ''
#        WHEN l_geoacti='N'     LET g_errno='9028'
#        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#   END CASE         
#   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
#      DISPLAY l_geo02 TO FORMONLY.geo02
#   END IF
#END FUNCTION 
#FUN-B90056--end mark--------------------------------------------------------------
 
FUNCTION t280_set_no_entry(p_cmd)          
   DEFINE   p_cmd     LIKE type_file.chr1   
 
  IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN   
      CALL cl_set_comp_entry("lna01",FALSE)        
  END IF           
END FUNCTION  
 
FUNCTION t280_confirm()
   DEFINE l_lna27         LIKE lna_file.lna27 
   DEFINE l_lna28         LIKE lna_file.lna28 
   DEFINE l_count         LIKE type_file.num5 
   
   IF cl_null(g_lna.lna01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 ----------------- add ----------------- begin
   IF g_lna.lna26 = 'Y' THEN
      CALL cl_err(g_lna.lna01,'alm-005',1)
      RETURN
   END IF

   IF g_lna.lna26 = 'X' THEN
      CALL cl_err(g_lna.lna01,'alm-134',1)
      RETURN
   END IF   
   IF NOT cl_confirm("alm-006") THEN  RETURN END IF
   SELECT * INTO g_lna.* FROM lna_file
    WHERE lna01      = g_lna.lna01
   IF cl_null(g_lna.lna01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 ----------------- add ----------------- end
   IF g_lna.lna26 = 'Y' THEN
      CALL cl_err(g_lna.lna01,'alm-005',1)
      RETURN
   END IF
   
   IF g_lna.lna26 = 'X' THEN
      CALL cl_err(g_lna.lna01,'alm-134',1)
      RETURN
   END IF
   
 
#  SELECT * INTO g_lna.* FROM lna_file  #CHI-C30107 mark
#   WHERE lna01      = g_lna.lna01      #CHI-C30107 mark
   
    LET l_lna27 = g_lna.lna27
    LET l_lna28 = g_lna.lna28 
   
    BEGIN WORK 
    OPEN t280_cl USING g_lna.lna01
    IF STATUS THEN 
       CALL cl_err("open t280_cl:",STATUS,1)
       CLOSE t280_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    
    FETCH t280_cl INTO g_lna.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lna.lna01,SQLCA.sqlcode,0)
      CLOSE t280_cl
      ROLLBACK WORK
      RETURN 
    END IF    
  
#  IF NOT cl_confirm("alm-006") THEN  #CHI-C30107 mark
#      RETURN                         #CHI-C30107 mark
#  ELSE                               #CHI-C30107 mark
   	  LET g_lna.lna26 = 'Y'
      LET g_lna.lna27 = g_user
      LET g_lna.lna28 = g_today
      UPDATE lna_file
         SET lna26 = g_lna.lna26,
             lna27 = g_lna.lna27,
             lna28 = g_lna.lna28
        WHERE lna01= g_lna.lna01
       
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lna:',SQLCA.SQLCODE,0)
         LET g_lna.lna26 = "N"
         LET g_lna.lna27 = l_lna27
         LET g_lna.lna28 = l_lna28
         DISPLAY BY NAME g_lna.lna26,g_lna.lna27,g_lna.lna28
         RETURN
       ELSE
         DISPLAY BY NAME g_lna.lna26,g_lna.lna27,g_lna.lna28
       END IF
 #  END IF  #CHI-C30107 mark
     CLOSE t280_cl
  COMMIT WORK      
END FUNCTION
 
FUNCTION t280_unconfirm()
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_lna27         LIKE lna_file.lna27 
   DEFINE l_lna28         LIKE lna_file.lna28 
   
   IF cl_null(g_lna.lna01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lna.* FROM lna_file
    WHERE lna01      = g_lna.lna01
  
   LET l_lna27 = g_lna.lna27
   LET l_lna28 = g_lna.lna28 
  
   IF g_lna.lna26 = 'N' THEN
      CALL cl_err(g_lna.lna01,'alm-007',1)
      RETURN
   END IF
  
   IF g_lna.lna26 = 'X' THEN
      CALL cl_err(g_lna.lna01,'alm-134',1)
      RETURN
   END IF
   
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM lnb_file
    WHERE lnb01 IS NOT NULL
      AND lnb02 = g_lna.lna01
      
    IF l_n > 0 THEN 
       CALL cl_err('','alm-242',1)
       RETURN 
    END IF   

    SELECT COUNT(*) INTO l_n FROM lig_file
     WHERE lig06 = g_lna.lna01
    IF l_n >0 THEN
       CALL cl_err('','alm1059',1)
       RETURN
    END IF

    BEGIN WORK
    LET g_success = 'Y'
    OPEN t280_cl USING g_lna.lna01
    
    IF STATUS THEN 
       CALL cl_err("open t280_cl:",STATUS,1)
       CLOSE t280_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t280_cl INTO g_lna.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lna.lna01,SQLCA.sqlcode,0)
      CLOSE t280_cl
      ROLLBACK WORK
      RETURN 
    END IF    
    
 
   IF NOT cl_confirm('alm-008') THEN
      RETURN
   ELSE
       LET g_lna.lna26 = 'N'
       #CHI-D20015--modify--str--
       #LET g_lna.lna27 = NULL
       #LET g_lna.lna28 = NULL
       LET g_lna.lna27 = g_user
       LET g_lna.lna28 = g_today 
       #CHI-D20015--modify--str--
       LET g_lna.lnamodu = g_user
       LET g_lna.lnadate = g_today
       UPDATE lna_file
          SET lna26 = g_lna.lna26,
              lna27 = g_lna.lna27,
              lna28 = g_lna.lna28,
              lnamodu = g_lna.lnamodu,
              lnadate = g_lna.lnadate
          WHERE lna01 = g_lna.lna01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd lna:',SQLCA.SQLCODE,0)
          LET g_lna.lna26 = "Y"
          LET g_lna.lna27 = l_lna27
          LET g_lna.lna28 = l_lna28
          DISPLAY BY NAME g_lna.lna26,g_lna.lna27,g_lna.lna28
          RETURN
         ELSE
            DISPLAY BY NAME g_lna.lna26,g_lna.lna27,g_lna.lna28,g_lna.lnamodu,g_lna.lnadate
         END IF
   END IF 
    CLOSE t280_cl
   IF g_success = 'Y' THEN 
      COMMIT WORK  
   END IF    
END FUNCTION
 
FUNCTION t280_pic()
   CASE g_lna.lna26
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
 
FUNCTION t280_v(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废

   IF cl_null(g_lna.lna01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lna.* FROM lna_file
    WHERE lna01  = g_lna.lna01
 
   #FUN-D20039 ----------sta
   IF p_type = 1 THEN
      IF g_lna.lna26='X' THEN RETURN END IF
   ELSE
      IF g_lna.lna26<>'X' THEN RETURN END IF
   END IF
   #FUN-D20039 ----------end
   IF g_lna.lna26 = 'Y' THEN
      CALL cl_err(g_lna.lna01,'9023',0)
      RETURN
   END IF
     BEGIN WORK
    OPEN t280_cl USING g_lna.lna01
    
    IF STATUS THEN 
       CALL cl_err("open t280_cl:",STATUS,1)
       CLOSE t280_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t280_cl INTO g_lna.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lna.lna01,SQLCA.sqlcode,0)
      CLOSE t280_cl
      ROLLBACK WORK
      RETURN 
    END IF      
    
   IF g_lna.lna26 != 'Y' THEN
      IF g_lna.lna26 = 'X' THEN
         IF NOT cl_confirm('alm-086') THEN
            RETURN
         ELSE
            LET g_lna.lna26 = 'N'
            LET g_lna.lnamodu = g_user
            LET g_lna.lnadate = g_today
            UPDATE lna_file
               SET lna26 = g_lna.lna26,
                   lnamodu = g_lna.lnamodu,
                   lnadate = g_lna.lnadate
             WHERE lna01 = g_lna.lna01
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lna:',SQLCA.SQLCODE,0)
               LET g_lna.lna26 = "X"
               DISPLAY BY NAME g_lna.lna26
               RETURN
            ELSE
               DISPLAY BY NAME g_lna.lna26,g_lna.lnamodu,g_lna.lnadate
            END IF
         END IF
      ELSE
         IF NOT cl_confirm('alm-085') THEN
            RETURN
         ELSE
            LET g_lna.lna26 = 'X'
            LET g_lna.lnamodu = g_user
            LET g_lna.lnadate = g_today
            UPDATE lna_file
               SET lna26 = g_lna.lna26,
                   lnamodu = g_lna.lnamodu,
                   lnadate = g_lna.lnadate
             WHERE lna01 = g_lna.lna01
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lna:',SQLCA.SQLCODE,0)
               LET g_lna.lna26 = "N"
               DISPLAY BY NAME g_lna.lna26
               RETURN
            ELSE
               DISPLAY BY NAME g_lna.lna26,g_lna.lnamodu,g_lna.lnadate
            END IF
         END IF
      END IF
   END IF
  CLOSE t280_cl
  COMMIT WORK  
END FUNCTION 

#FUN-B90056---begin add----------------------------------------------------------------

FUNCTION t280_b(flag)
   DEFINE
      l_n             LIKE type_file.num5,
      l_n1            LIKE type_file.num5,
      l_i1            LIKE type_file.num5,
      l_lock_sw       LIKE type_file.chr1,
      p_cmd           LIKE type_file.chr1,
      l_allow_insert  LIKE type_file.num5,
      flag            LIKE type_file.chr1,
      l_allow_delete  LIKE type_file.num5

   LET g_action_choice = ""

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lna.lna01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lna.*
     FROM lna_file
    WHERE lna01=g_lna.lna01

   IF g_lna.lna26 = 'X' THEN
      CALL cl_err(g_lna.lna01,'alm-134',1)
     RETURN
   END IF

   IF g_lna.lna26 = 'Y' THEN
      CALL cl_err(g_lna.lna01,'alm-027',1)
     RETURN
   END IF

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT lif02,'',lif03,lifacti",
                   "  FROM lif_file",
                   "  WHERE lif01=? AND lif02=? ",
                   "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t280_bcl CURSOR FROM g_forupd_sql

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_lif WITHOUT DEFAULTS FROM s_lif.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)

   BEFORE INPUT
      DISPLAY "BEFORE INPUT!"
      IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(l_ac)
      END IF

   BEFORE ROW
      DISPLAY "BEFORE ROW!"
      LET p_cmd = ''
      LET l_ac = ARR_CURR()
      LET l_lock_sw = 'N'
      LET l_n  = ARR_COUNT()

      BEGIN WORK
      LET g_success = 'N'

      OPEN t280_cl USING g_lna.lna01
      IF STATUS THEN
         CALL cl_err("OPEN t280_cl:", STATUS, 1)
         CLOSE t280_cl
         ROLLBACK WORK
         RETURN
      END IF

      FETCH t280_cl INTO g_lna.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_lna.lna01,SQLCA.sqlcode,0)
         CLOSE t280_cl
         ROLLBACK WORK
         RETURN
      END IF

      IF g_rec_b >= l_ac THEN
         LET p_cmd='u'
         LET g_lif_t.* = g_lif[l_ac].*

         OPEN t280_bcl USING g_lna.lna01,g_lif_t.lif02
         IF STATUS THEN
            CALL cl_err("OPEN t280_bcl:", STATUS, 1)
            LET l_lock_sw = "Y"
         ELSE
            FETCH t280_bcl INTO g_lif[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_lif_t.lif02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL t280_lif02('d')
         END IF
         CALL cl_show_fld_cont()
      END IF

   BEFORE INSERT
      DISPLAY "BEFORE INSERT!"
      LET l_n = ARR_COUNT()
      LET p_cmd='a'
      INITIALIZE g_lif[l_ac].* TO NULL
      LET g_lif_t.* = g_lif[l_ac].*
      LET g_lif[l_ac].lifacti='Y'

      CALL cl_show_fld_cont()
      NEXT FIELD lif02

   AFTER INSERT
      DISPLAY "AFTER INSERT!"
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         CANCEL INSERT
      END IF
      LET l_n=0

      INSERT INTO lif_file(lif01,lif02,lif03,lifacti)
           VALUES(g_lna.lna01,g_lif[l_ac].lif02,
                  g_lif[l_ac].lif03,g_lif[l_ac].lifacti)

      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lif_file",g_lna.lna01,
                      g_lif[l_ac].lif02,SQLCA.sqlcode,"","",1)
         CANCEL INSERT
      ELSE
         MESSAGE 'INSERT O.K'
         COMMIT WORK
         LET g_success = 'Y'
         LET g_rec_b=g_rec_b+1
         DISPLAY g_rec_b TO FORMONLY.cnt2
      END IF

   AFTER FIELD lif02
      IF NOT cl_null(g_lif[l_ac].lif02) THEN
         IF (g_lif[l_ac].lif02 != g_lif_t.lif02 AND g_lif_t.lif02 !='')
               OR g_lif_t.lif02 IS NULL THEN
            SELECT count(*) INTO l_n1
              FROM lif_file
             WHERE lif01 = g_lna.lna01
               AND lif02 = g_lif[l_ac].lif02
            IF l_n1 >0 THEN
               CALL cl_err('','alm-167',0)
               LET g_lif[l_ac].lif02=g_lif_t.lif02
               NEXT FIELD lif02
            ELSE
               CALL t280_lif02('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  LET g_lif[l_ac].lif02=g_lif_t.lif02
                  NEXT FIELD lif02
               END IF
            END IF
         END IF
      END IF

   BEFORE DELETE
      DISPLAY "BEFORE DELETE"
      IF g_lif_t.lif02 IS NOT NULL THEN

         IF NOT cl_delb(0,0) THEN
            CANCEL DELETE
         END IF

         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            CANCEL DELETE
         END IF

         DELETE FROM lif_file
               WHERE lif01 = g_lna.lna01
                 AND lif02 = g_lif_t.lif02

         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","lna_file",g_lna.lna01,
                          g_lif_t.lif02,SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            CANCEL DELETE
         END IF
         LET g_rec_b=g_rec_b-1
         DISPLAY g_rec_b TO FORMONLY.cnt2
      END IF
      COMMIT WORK
      LET g_success = 'Y'

   ON ROW CHANGE
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_lif[l_ac].* = g_lif_t.*
         CLOSE t280_bcl
         ROLLBACK WORK
         EXIT INPUT
      END IF
      IF l_lock_sw = 'Y' THEN
         CALL cl_err(g_lif[l_ac].lif02,-263,1)
         LET g_lif[l_ac].* = g_lif_t.*
      ELSE
         UPDATE lif_file
            SET lif02=g_lif[l_ac].lif02,
                lif03=g_lif[l_ac].lif03,
                lifacti=g_lif[l_ac].lifacti
          WHERE lif01=g_lna.lna01
            AND lif02=g_lif_t.lif02

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lif_file",g_lna.lna01,
                 g_lif_t.lif02,SQLCA.sqlcode,"","",1)
            LET g_lif[l_ac].* = g_lif_t.*
         ELSE
            MESSAGE 'UPDATE O.K'
            COMMIT WORK
            LET g_success = 'Y'
         END IF
      END IF

   AFTER ROW
      DISPLAY  "AFTER ROW!!"
      LET l_ac = ARR_CURR()
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0

         IF p_cmd = 'a' THEN
            CALL g_lif.deleteElement(l_ac)
         END IF

         IF p_cmd = 'u' THEN
            LET g_lif[l_ac].* = g_lif_t.*
         END IF

         CLOSE t280_bcl
         ROLLBACK WORK
         EXIT INPUT
      END IF

      IF g_success =  'N' THEN
         CLOSE t280_bcl
         ROLLBACK WORK
      ELSE
         CLOSE t280_bcl
      END IF

   ON ACTION CONTROLO
      IF INFIELD(lif02) AND l_ac > 1 THEN
         LET g_lif[l_ac].* = g_lif[l_ac-1].*
         LET g_lif[l_ac].lif02 = g_rec_b + 1
         NEXT FIELD lif02
      END IF

   ON ACTION CONTROLR
      CALL cl_show_req_fields()

   ON ACTION CONTROLG
      CALL cl_cmdask()

   ON ACTION controlp
      CASE
         WHEN INFIELD(lif02)
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_tqa20"
            LET g_qryparam.default1 = g_lif[l_ac].lif02
            CALL cl_create_qry() RETURNING g_lif[l_ac].lif02
            DISPLAY BY NAME g_lif[l_ac].lif02
            CALL t280_lif02('d')
            NEXT FIELD lif02
         OTHERWISE
            EXIT CASE
      END CASE

   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE INPUT

   ON ACTION about
      CALL cl_about()

   ON ACTION help
      CALL cl_show_help()

   ON ACTION controls
      CALL cl_set_head_visible("","AUTO")
   END INPUT

   IF p_cmd = 'u' AND flag = 'u' THEN
      LET g_lna.lnamodu = g_user
      LET g_lna.lnadate = g_today

      UPDATE lna_file
         SET lnamodu = g_lna.lnamodu,
             lnadate = g_lna.lnadate
       WHERE lna01 = g_lna.lna01
      DISPLAY BY NAME g_lna.lnamodu,g_lna.lnadate
   END IF
   CLOSE t280_bcl
#  CALL t280_delall()  #CHI-C30002 mark
   CALL t280_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t280_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_lna.lna01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM lna_file ",
                  "  WHERE lna01 LIKE '",l_slip,"%' ",
                  "    AND lna01 > '",g_lna.lna01,"'"
      PREPARE t280_pb1 FROM l_sql 
      EXECUTE t280_pb1 INTO l_cnt 
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t280_v(1)       #FUN-D20039 add '1'
         CALL t280_pic()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM lna_file WHERE lna01 = g_lna.lna01
         INITIALIZE g_lna.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t280_lif02(p_cmd)
   DEFINE   p_cmd   LIKE    type_file.chr1
   DEFINE   l_tqa02 LIKE    tqa_file.tqa02,
            l_tqaacti LIKE  tqa_file.tqaacti
   

   SELECT tqa02 ,tqaacti INTO l_tqa02,l_tqaacti
     FROM tqa_file
    WHERE tqa01=g_lif[l_ac].lif02
      AND tqa03 = '31'
   
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm-046'
                               LET l_tqa02 = ''
      WHEN l_tqaacti <> 'Y'    LET g_errno = '9028'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd='d' THEN
      LET g_lif[l_ac].tqa02=l_tqa02
      DISPLAY BY NAME g_lif[l_ac].tqa02
   END IF
END FUNCTION

#CHI-C30002 -------- mark -------- begin
#FUNCTION t280_delall()
#  SELECT COUNT(*) INTO g_cnt
#    FROM lif_file
#   WHERE lif01 = g_lna.lna01

#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED

#     DELETE FROM lna_file WHERE lna01 = g_lna.lna01
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
FUNCTION t280_b_fill(p_wc2)
   DEFINE p_wc2      STRING

   LET g_sql = "SELECT lif02,'',lif03,lifacti ",
               "  FROM lif_file",
               " WHERE lif01 ='",g_lna.lna01,"' "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lif02 "

   PREPARE t280_pb FROM g_sql
   DECLARE t280_b_cs CURSOR FOR t280_pb

   CALL g_lif.clear()
   LET g_cnt = 1

   FOREACH t280_b_cs INTO g_lif[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET g_errno = ' '
      SELECT tqa02 INTO g_lif[g_cnt].tqa02
        FROM tqa_file
       WHERE tqa01 = g_lif[g_cnt].lif02
         AND tqa03 = '31'

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_lif.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt2
   LET g_cnt = 0
END FUNCTION


FUNCTION t280_bp_refresh()
   DISPLAY ARRAY g_lif TO s_lif.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

   BEFORE DISPLAY
      EXIT DISPLAY

   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

#FUN-B90056---end add------------------------------------------------------------------
 
#No.FUN-960134 

