# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aglt005.4gl
# Descriptions...: 公司權益科目金額(不在合併範圍內子公司)
# Date & Author..: 11/06/16  By lutingting
# Modify.........: No.FUN-B60134 11/06/27 By xjll  新增程式 
# Modify.........: No.TQC-BB0246 11/11/30 By yuhuabao g_azi(本幣取位)與t_azi(原幣取位)問題修改
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/01 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-DB0054 13/11/07 by fengmy 增加上層公司以及賬套
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm      RECORD
               wc      LIKE type_file.chr1000# Head Where condition  
               END RECORD,
       g_axqq  RECORD
               axqq01 	LIKE axqq_file.axqq01,   #族群代號  
               axqq02   LIKE axqq_file.axqq02,   #上層公司編號  #MOD-DB0054 add
               axqq03   LIKE axqq_file.axqq03,   #上層賬套      #MOD-DB0054 add
               axqq04 	LIKE axqq_file.axqq04,   #下層公司編號
               axqq041	LIKE axqq_file.axqq041,  #下層帳別
               axqq06	LIKE axqq_file.axqq06,   #年度
               axqq07	LIKE axqq_file.axqq07,   #期別
               axqq12	LIKE axqq_file.axqq12    #幣別
               END RECORD,
       g_axqq_t RECORD                           #備分舊值
               axqq01 	LIKE axqq_file.axqq01,   #族群代號 
               axqq02   LIKE axqq_file.axqq02,   #上層公司編號  #MOD-DB0054 add
               axqq03   LIKE axqq_file.axqq03,   #上層賬套      #MOD-DB0054 add
               axqq04 	LIKE axqq_file.axqq04,   #下層公司編號
               axqq041	LIKE axqq_file.axqq041,  #下層帳別
               axqq06	LIKE axqq_file.axqq06,   #年度
               axqq07	LIKE axqq_file.axqq07,   #期別
               axqq12	LIKE axqq_file.axqq12    #幣別
               END RECORD,
       g_aag   DYNAMIC ARRAY OF RECORD
               axqq05    LIKE axqq_file.axqq05,   #科目編號
               axqq08    LIKE axqq_file.axqq08,   #借方金額
               axqq09    LIKE axqq_file.axqq09    #貸方金額
               END RECORD,
       g_aag_t RECORD                          #備份舊值
               axqq05    LIKE axqq_file.axqq05,   #科目編號
               axqq08    LIKE axqq_file.axqq08,   #借方金額
               axqq09    LIKE axqq_file.axqq09    #貸方金額
               END RECORD,
       g_wc,g_wc2,g_sql STRING,                #WHERE CONDITION      
       p_row,p_col      LIKE type_file.num5, 
       g_rec_b          LIKE type_file.num5, 
       l_ac             LIKE type_file.num5    #目前處理的ARRAY CNT   
DEFINE g_forupd_sql     STRING     
DEFINE g_sql_tmp        STRING  
DEFINE g_cnt            LIKE type_file.num10      
DEFINE g_i              LIKE type_file.num5      
DEFINE g_msg            LIKE type_file.chr1000  
DEFINE g_row_count      LIKE type_file.num10   
DEFINE g_curs_index     LIKE type_file.num10  
DEFINE g_jump           LIKE type_file.num10 
DEFINE g_no_ask        LIKE type_file.num5
DEFINE g_flag           LIKE type_file.chr1      
DEFINE g_axqq00         LIKE axqq_file.axqq00
DEFINE g_axqq02         LIKE axqq_file.axqq02
DEFINE g_axqq03         LIKE axqq_file.axqq03
DEFINE g_sumaxqq08      LIKE axqq_file.axqq08
DEFINE g_sumaxqq09      LIKE axqq_file.axqq09

MAIN
   OPTIONS                                #改變一些系統預設值 # FUN-B60134 
      INPUT NO WRAP                       #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
   
  #LET g_forupd_sql = "SELECT axqq01,axqq04,axqq041,axqq06,axqq07,axqq12", #MOD-DB0054 mark
   LET g_forupd_sql = "SELECT axqq01,axqq02,axqq03,axqq04,axqq041,axqq06,axqq07,axqq12", #MOD-DB0054 add
                      "  FROM axqq_file ",
                      " WHERE axqq01=? AND axqq02=? AND axqq03=? AND axqq04=? AND axqq041=? ", #MOD-DB0054 add axqq02,03
                      "   AND axqq06=? AND axqq07=? AND axqq12=? ",                  
                       "  FOR UPDATE "            
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) 
   DECLARE t005_lock_u CURSOR FROM g_forupd_sql
 

   OPEN WINDOW t005_w WITH FORM "agl/42f/aglt005"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL t005_menu()
   CLOSE WINDOW t005_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION t005_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01  

   CLEAR FORM #清除畫面
   CALL g_aag.clear()
   CALL cl_set_head_visible("","YES")        

   # 螢幕上取單頭條件
   INITIALIZE g_axqq.* TO NULL   
   CONSTRUCT BY NAME g_wc ON axqq01,axqq02,axqq03,axqq04,axqq041,axqq06,axqq07,axqq12  #MOD-DB0054 add axqq02,axqq03 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()

       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(axqq01)   #族群代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_axa1"                
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axqq01
                 NEXT FIELD axqq01
             #MOD-DB0054 begin--------
             WHEN INFIELD(axqq02)   #上層公司編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axz"                
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axqq02
             WHEN INFIELD(axqq03)  #帳別開窗
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axz"                   
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axqq03
                 NEXT FIELD axqq041
             #MOD-DB0054 end----------
             WHEN INFIELD(axqq04)   #下層公司編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axz"   
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axqq04
             WHEN INFIELD(axqq041)  #帳別開窗
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axqq041
                 NEXT FIELD axqq041
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

       AFTER CONSTRUCT
          CALL GET_FLDBUF(axqq041) RETURNING g_axqq.axqq041   

       ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF

   #螢幕上取單身條件
   CONSTRUCT g_wc2 ON axqq05,axqq08,axqq09
             FROM s_axqq[1].axqq05,s_axqq[1].axqq08,s_axqq[1].axqq09
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axqq05)   #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 IF NOT cl_null(g_axqq.axqq041) THEN
                    LET g_qryparam.arg1 = g_axqq.axqq041
                 ELSE
                    LET g_qryparam.arg1 = g_aaz.aaz64   
                 END IF
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axqq05
            OTHERWISE EXIT CASE
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

      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   IF g_priv2='4' THEN                           #只能使用自己的資料
      LET g_wc = g_wc clipped," AND aaguser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET g_wc = g_wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   END IF
   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      LET g_wc = g_wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   END IF

   IF g_wc2 = " 1=1" THEN               # 若單身未輸入條件
     #LET g_sql = "SELECT UNIQUE axqq01,axqq04,axqq041,axqq06,axqq07,axqq12 ",  #MOD-DB0054 mark
      LET g_sql = "SELECT UNIQUE axqq01,axqq02,axqq03,axqq04,axqq041,axqq06,axqq07,axqq12 ",  #MOD-DB0054 
                  "  FROM axqq_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY axqq01,axqq04,axqq041,axqq06,axqq07,axqq12"  
   ELSE                                 # 若單身有輸入條件
     #LET g_sql = "SELECT UNIQUE axqq01,axqq04,axqq041,axqq06,axqq07,axqq12 ",  #MOD-DB0054 mark
      LET g_sql = "SELECT UNIQUE axqq01,axqq02,axqq03,axqq04,axqq041,axqq06,axqq07,axqq12 ",  #MOD-DB0054 
                  "  FROM axqq_file ", 
                  " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY axqq01,axqq04,axqq041,axqq06,axqq07,axqq12"  
   END IF
   PREPARE t005_prepare FROM g_sql
   DECLARE t005_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR t005_prepare

   DROP TABLE x
  #LET g_sql_tmp="SELECT UNIQUE axqq01,axqq04,axqq041,axqq06,axqq07,axqq12 ", #MOD-DB0054 mark
   LET g_sql_tmp="SELECT UNIQUE axqq01,axqq02,axqq03,axqq04,axqq041,axqq06,axqq07,axqq12 ", #MOD-DB0054 
             "  FROM axqq_file ",
             " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
             "  INTO TEMP x "
   PREPARE t005_temp FROM g_sql_tmp  
   EXECUTE t005_temp

   LET g_sql = "SELECT COUNT(*) FROM x"
   PREPARE t005_prepare_cnt FROM g_sql
   DECLARE t005_count CURSOR FOR t005_prepare_cnt
END FUNCTION

FUNCTION t005_menu()

   WHILE TRUE
      CALL t005_bp("G")
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL t005_a()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL t005_q()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL t005_r()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL t005_copy()
            END IF
         WHEN "detail"                          # B.單身
            IF cl_chk_act_auth() THEN
               CALL t005_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "auto_axqq"
            CALL t005_ins_axqq()
            CALL t005_b_fill('1=1')
         WHEN "exporttoexcel"   #No:FUN-4B0010
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aag),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION


FUNCTION t005_a()                            # Add  輸入
DEFINE l_n  LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF            #判斷目前系統是否可用
   MESSAGE ""
   CLEAR FORM
   CALL g_aag.clear()
   INITIALIZE g_axqq.* LIKE axqq_file.*         #DEFAULT 設定
   CALL cl_opmsg('a')

   LET g_axqq00 = g_aaz.aaz641
   WHILE TRUE
      CALL t005_i("a")                        # 輸入單頭

      IF INT_FLAG THEN                        # 使用者不玩了
         LET g_axqq.axqq01 = NULL 
         LET g_axqq.axqq02 = NULL             #MOD-DB0054 add
         LET g_axqq.axqq03 = NULL             #MOD-DB0054 add
         LET g_axqq.axqq04 = NULL
         LET g_axqq.axqq041= NULL
         LET g_axqq.axqq06 = NULL
         LET g_axqq.axqq07 = NULL
         LET g_axqq.axqq12 = NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF g_axqq.axqq01 IS NULL OR g_axqq.axqq04 IS NULL OR g_axqq.axqq041 IS NULL OR   
         g_axqq.axqq06 IS NULL OR g_axqq.axqq07 IS NULL OR g_axqq.axqq12 IS NULL  THEN 
         CONTINUE WHILE
      END IF

      CALL g_aag.clear()
      LET g_rec_b = 0

      SELECT COUNT(*) INTO l_n FROM axqq_file
       WHERE axqq00 = g_axqq00 AND axqq01 = g_axqq.axqq01 
         AND axqq02 = g_axqq.axqq02 AND axqq03 = g_axqq.axqq03      #MOD-DB0054 add
         AND axqq04 = g_axqq.axqq04 AND axqq041 = g_axqq.axqq041
         AND axqq06 = g_axqq.axqq06 AND axqq07 = g_axqq.axqq07
         AND axqq12 = g_axqq.axqq12
      IF l_n>0 THEN
         CALL t005_b_fill('1=1')
      END IF 

      CALL t005_b()                           # 輸入單身
#Modify FUN-B60134-- str--
#      SELECT ROWID INTO g_axqq_rowid FROM axqq_file
#       WHERE axqq04=g_axqq.axqq04 AND axqq041=g_axqq.axqq041
#         AND axqq06=g_axqq.axqq06 AND axqq07=g_axqq.axqq07 AND axqq12=g_axqq.axqq12
#         AND axqq01=g_axqq.axqq01  
#Modify FUN-B60134-- end--
      LET g_axqq_t.* = g_axqq.*                 #保留舊值

      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t005_i(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1,               #a:輸入 u:更改  
       l_n         LIKE type_file.num5,    #FUN-740198 add
       l_n1        LIKE type_file.num5     #MOD-DB0054 add
  #DISPLAY g_axqq.* TO axqq01,axqq04,axqq041,axqq06,axqq07,axqq12  #MOD-DB0054 mark
   DISPLAY g_axqq.* TO axqq01,axqq02,axqq03,axqq04,axqq041,axqq06,axqq07,axqq12  #MOD-DB0054  
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
#   INPUT g_axqq.axqq01,g_axqq.axqq04,g_axqq.axqq041,g_axqq.axqq06,g_axqq.axqq07,g_axqq.axqq12 WITHOUT DEFAULTS  #MOD-DB0054 mark
#         FROM axqq01,axqq04,axqq041,axqq06,axqq07,axqq12  #MOD-DB0054 mark
    INPUT g_axqq.axqq01,g_axqq.axqq02,g_axqq.axqq03,g_axqq.axqq04,g_axqq.axqq041,g_axqq.axqq06,g_axqq.axqq07,g_axqq.axqq12 WITHOUT DEFAULTS  #MOD-DB0054 
         FROM axqq01,axqq02,axqq03,axqq04,axqq041,axqq06,axqq07,axqq12  #MOD-DB0054 
      AFTER FIELD axqq01
         IF cl_null(g_axqq.axqq01) THEN
            CALL cl_err(g_axqq.axqq01,'mfg5103',0)
            NEXT FIELD axqq01
         ELSE
           #SELECT axa02,axa03 INTO g_axqq02,g_axqq03 FROM axa_file   #MOD-DB0054 mark
            SELECT axa02,axa03 INTO g_axqq.axqq02,g_axqq.axqq03 FROM axa_file  #MOD-DB0054 
             WHERE axa01 = g_axqq.axqq01 AND axa04 = 'Y'   
           DISPLAY g_axqq.axqq02 TO axqq02    #MOD-DB0054 add 
           DISPLAY g_axqq.axqq03 TO axqq03    #MOD-DB0054 add      
         END IF
         
       #MOD-DB0054 begin ------
       AFTER FIELD axqq02
         IF cl_null(g_axqq.axqq02) THEN
            CALL cl_err(g_axqq.axqq02,'mfg5103',0)
            NEXT FIELD axqq02
         END IF         
         SELECT COUNT(*) INTO l_n1 FROM axb_file 
         WHERE axb01 = g_axqq.axqq01 
           AND axb02 = g_axqq.axqq02           
         IF l_n1 = 0 THEN
            CALL cl_err(g_axqq.axqq02,'agl030',0)
            NEXT FIELD axqq02
         END IF 
         
         SELECT axz05 INTO g_axqq.axqq03
           FROM axz_file
          WHERE axz01 = g_axqq.axqq02
         IF SQLCA.SQLCODE THEN
            CALL cl_err(g_axqq.axqq02,'aco-025',0)
            NEXT FIELD axqq02
         END IF
         DISPLAY g_axqq.axqq03 TO axqq03 
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM axz_file
          WHERE axz01=g_axqq.axqq02 AND axz05=g_axqq.axqq03
         IF l_n = 0 THEN
            CALL cl_err(g_axqq.axqq02,'agl-948',0)  
            NEXT FIELD axqq02
         END IF

      AFTER FIELD axqq03
         IF cl_null(g_axqq.axqq03) THEN
            CALL cl_err(g_axqq.axqq03,'mfg5103',0)
            NEXT FIELD axqq03
         END IF
         #增加公司+帳別的合理性判斷,應存在agli009
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM axz_file
          WHERE axz01=g_axqq.axqq02 AND axz05=g_axqq.axqq03
         IF l_n = 0 THEN
            CALL cl_err(g_axqq.axqq03,'agl-948',0)   
            NEXT FIELD axqq03
         END IF
       #MOD-DB0054 end --------
      AFTER FIELD axqq04
         IF cl_null(g_axqq.axqq04) THEN
            CALL cl_err(g_axqq.axqq04,'mfg5103',0)
            NEXT FIELD axqq04
         END IF
         #MOD-DB0054 begin---------
         SELECT COUNT(*) INTO l_n1 FROM axb_file 
         WHERE axb01 = g_axqq.axqq01 
           AND axb02 = g_axqq.axqq02
           AND axb03 = g_axqq.axqq03
           AND axb04 = g_axqq.axqq04
         IF l_n1 = 0 THEN
            CALL cl_err(g_axqq.axqq04,'agl030',0)
            NEXT FIELD axqq04
         END IF 
         #MOD-DB0054 end-----------
         SELECT axz05,axz06 INTO g_axqq.axqq041,g_axqq.axqq12
           FROM axz_file
          WHERE axz01 = g_axqq.axqq04
         IF SQLCA.SQLCODE THEN
            CALL cl_err(g_axqq.axqq04,'aco-025',0)
            NEXT FIELD axqq04
         END IF
         DISPLAY g_axqq.axqq041 TO axqq041
         DISPLAY g_axqq.axqq12  TO axqq12
         #增加公司+帳別的合理性判斷,應存在agli009
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM axz_file
          WHERE axz01=g_axqq.axqq04 AND axz05=g_axqq.axqq041
         IF l_n = 0 THEN
            CALL cl_err(g_axqq.axqq04,'agl-948',0)  
            NEXT FIELD axqq04
         END IF

      AFTER FIELD axqq041
         IF cl_null(g_axqq.axqq041) THEN
            CALL cl_err(g_axqq.axqq041,'mfg5103',0)
            NEXT FIELD axqq041
         END IF
         #增加公司+帳別的合理性判斷,應存在agli009
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM axz_file
          WHERE axz01=g_axqq.axqq04 AND axz05=g_axqq.axqq041
         IF l_n = 0 THEN
            CALL cl_err(g_axqq.axqq041,'agl-948',0)   
            NEXT FIELD axqq041
         END IF
       

      AFTER FIELD axqq07
         IF NOT cl_null(g_axqq.axqq07) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_axqq.axqq06
            IF g_azm.azm02 = 1 THEN
               IF g_axqq.axqq07 > 12 OR g_axqq.axqq07 < 1 THEN
                  CALL cl_err(g_axqq.axqq07,'axm-164',0)
                  NEXT FIELD axqq07
               END IF
            ELSE
               IF g_axqq.axqq07 > 13 OR g_axqq.axqq07 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD axqq07
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
           WHEN INFIELD(axqq01)   #族群代號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_axa1"
                LET g_qryparam.default1 = g_axqq.axqq01
                CALL cl_create_qry() RETURNING g_axqq.axqq01
                DISPLAY g_axqq.axqq01 TO axqq01
                NEXT FIELD axqq01
           WHEN INFIELD(axqq04)   #下層公司編號
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_axz"   
                LET g_qryparam.default1 = g_axqq.axqq04
                CALL cl_create_qry() RETURNING g_axqq.axqq04
                DISPLAY g_axqq.axqq04 TO axqq04
                NEXT FIELD axqq04
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

FUNCTION t005_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_axqq.* TO NULL        
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL g_aag.clear()
    DISPLAY '' TO FORMONLY.cnt

    CALL t005_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF

    OPEN t005_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       CALL t005_fetch('F')                  # 讀出TEMP第一筆並顯示
       OPEN t005_count
       FETCH t005_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION

FUNCTION t005_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1,                 #處理方式       
          l_abso          LIKE type_file.num10                 #絕對的筆數    

   CASE p_flag
      WHEN 'N' FETCH NEXT     t005_cs INTO g_axqq.axqq01,g_axqq.axqq02,g_axqq.axqq03,g_axqq.axqq04,g_axqq.axqq041, #MOD-DB0054 add axqq02,axqq03
                                           g_axqq.axqq06,g_axqq.axqq07,g_axqq.axqq12
      WHEN 'P' FETCH PREVIOUS t005_cs INTO g_axqq.axqq01,g_axqq.axqq02,g_axqq.axqq03,g_axqq.axqq04,g_axqq.axqq041, #MOD-DB0054 add axqq02,axqq03
                                           g_axqq.axqq06,g_axqq.axqq07,g_axqq.axqq12
      WHEN 'F' FETCH FIRST    t005_cs INTO g_axqq.axqq01,g_axqq.axqq02,g_axqq.axqq03,g_axqq.axqq04,g_axqq.axqq041, #MOD-DB0054 add axqq02,axqq03
                                           g_axqq.axqq06,g_axqq.axqq07,g_axqq.axqq12
      WHEN 'L' FETCH LAST     t005_cs INTO g_axqq.axqq01,g_axqq.axqq02,g_axqq.axqq03,g_axqq.axqq04,g_axqq.axqq041, #MOD-DB0054 add axqq02,axqq03
                                           g_axqq.axqq06,g_axqq.axqq07,g_axqq.axqq12
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
            FETCH ABSOLUTE g_jump t005_cs INTO g_axqq.axqq01,g_axqq.axqq02,g_axqq.axqq03,g_axqq.axqq04,g_axqq.axqq041, #MOD-DB0054 add axqq02,axqq03
                                               g_axqq.axqq06,g_axqq.axqq07,g_axqq.axqq12
            LET g_no_ask = FALSE 
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_axqq.* TO NULL  #TQC-6B0105
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

   CALL t005_show()
END FUNCTION

FUNCTION t005_show()

   DISPLAY g_axqq.axqq01,g_axqq.axqq02,g_axqq.axqq03,g_axqq.axqq04,g_axqq.axqq041, #MOD-DB0054 add axqq02,axqq03
           g_axqq.axqq06,g_axqq.axqq07,g_axqq.axqq12
        TO axqq01,axqq02,axqq03,axqq04,axqq041,axqq06,axqq07,axqq12 #MOD-DB0054 add axqq02,axqq03
   CALL t005_b_fill(g_wc2) #單身
   CALL cl_show_fld_cont()              

END FUNCTION

FUNCTION t005_r()

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_axqq.axqq01) AND cl_null(g_axqq.axqq04) AND cl_null(g_axqq.axqq041) AND 
      cl_null(g_axqq.axqq06) AND cl_null(g_axqq.axqq07) AND cl_null(g_axqq.axqq12) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK

   IF cl_delh(15,16) THEN
      DELETE FROM axqq_file WHERE axqq04=g_axqq.axqq04 AND axqq041=g_axqq.axqq041
                             AND axqq06=g_axqq.axqq06 AND axqq07=g_axqq.axqq07
                             AND axqq12=g_axqq.axqq12
                             AND axqq01=g_axqq.axqq01
                             AND axqq02=g_axqq.axqq02 AND axqq03=g_axqq.axqq03  #MOD-DB0054 add
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","axqq_file",g_axqq.axqq04,g_axqq.axqq041,SQLCA.sqlcode,"","",1) 
      ELSE
         CLEAR FORM
         CALL g_aag.clear()
         DROP TABLE x                        
         PREPARE t005_pre_y2 FROM g_sql_tmp 
         EXECUTE t005_pre_y2               
         OPEN t005_count
         FETCH t005_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t005_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t005_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE   #
            CALL t005_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION

#單身
FUNCTION t005_b()
DEFINE
   l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT 
   l_n             LIKE type_file.num5,      #檢查重複用       
   l_lock_sw       LIKE type_file.chr1,      #單身鎖住否      
   p_cmd           LIKE type_file.chr1,      #處理狀態       
   l_allow_insert  LIKE type_file.num5,      #可新增否      
   l_allow_delete  LIKE type_file.num5      #可刪除否     
#   l_azi04         LIKE azi_file.azi04       #金額取位小數位數  #No.TQC-BB0246 mark

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')

   IF cl_null(g_axqq.axqq01) AND cl_null(g_axqq.axqq04) AND cl_null(g_axqq.axqq041) AND  
      cl_null(g_axqq.axqq06) AND cl_null(g_axqq.axqq07) AND cl_null(g_axqq.axqq12) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_axqq00 = g_aaz.aaz641
   SELECT axa02,axa03 INTO g_axqq02,g_axqq03 FROM axa_file
    WHERE axa01 = g_axqq.axqq01 AND axa04 = 'Y' 
   LET g_forupd_sql =
       "SELECT axqq05,axqq08,axqq09 FROM axqq_file ",  
       " WHERE axqq01=? AND axqq02=? AND axqq03=? AND axqq04=? AND axqq041=? AND axqq06=? AND axqq07=? AND axqq12=? ",  #MOD-DB0054 add axqq02,03 
#      "   AND axqq05=? FOR UPDATE NOWAIT"   
       "   AND axqq05=? FOR UPDATE "  #FUN-B60134
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)   #FUN-B60134
      DECLARE t005_bcl CURSOR FROM g_forupd_sql     # LOCK CURSOR
   #取得下層公司幣別金額取位小數位數
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_axqq.axqq12   #No.TQC-BB0246 modify :l_azi->t_azi
   IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF                     #No.TQC-BB0246 modify :l_azi->t_azi

   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_aag WITHOUT DEFAULTS FROM s_axqq.*
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
             #OPEN t005_bcl USING g_axqq.axqq01,g_axqq02,g_axqq03,g_axqq.axqq04,g_axqq.axqq041,   #FUN-910001 add axqq01  #MOD-DB0054 add axqq02,03
              OPEN t005_bcl USING g_axqq.axqq01,g_axqq.axqq02,g_axqq.axqq03,g_axqq.axqq04,g_axqq.axqq041,   #FUN-910001 add axqq01  #MOD-DB0054 add axqq02,03
                                  g_axqq.axqq06,g_axqq.axqq07,g_axqq.axqq12,
                                  g_aag_t.axqq05
              IF STATUS THEN
                 CALL cl_err("OPEN t005_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t005_bcl INTO g_aag[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_aag_t.axqq05,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF

       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_aag[l_ac].* TO NULL 
           LET g_aag[l_ac].axqq08 = 0
           LET g_aag[l_ac].axqq09 = 0
           LET g_aag_t.* = g_aag[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD axqq05

       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              INITIALIZE g_aag[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_aag[l_ac].* TO s_axqq.*
              CALL g_aag.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_aag[l_ac].axqq08) THEN
              LET g_aag[l_ac].axqq08 = 0 
           END IF 
           IF cl_null(g_aag[l_ac].axqq09) THEN
              LET g_aag[l_ac].axqq09 = 0
           END IF
           INSERT INTO axqq_file(axqq00,axqq01,axqq02,axqq03, 
                                 axqq04,axqq041,axqq06,axqq07,axqq12,
                                 axqq05,axqq08,axqq09,axqqlegal)                #FUN-B60134    
                        #VALUES(g_axqq00,g_axqq.axqq01,g_axqq02,g_axqq03,       #MOD-DB0054 mark
                         VALUES(g_axqq00,g_axqq.axqq01,g_axqq.axqq02,g_axqq.axqq03,       #MOD-DB0054
                                g_axqq.axqq04,g_axqq.axqq041,g_axqq.axqq06,
                                g_axqq.axqq07,g_axqq.axqq12,g_aag[l_ac].axqq05,
                                g_aag[l_ac].axqq08,g_aag[l_ac].axqq09,g_legal)    #FUN-B60134
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","axqq_file",g_axqq.axqq04,g_axqq.axqq041,SQLCA.sqlcode,"","",1) 
              CANCEL INSERT
           ELSE
              LET g_rec_b = g_rec_b + 1
              DISPLAY g_rec_b TO FORMONLY.cnt2
              CALL t005_upamt()
              MESSAGE 'INSERT O.K'
           END IF
           

       AFTER FIELD axqq05
           IF NOT cl_null(g_aag[l_ac].axqq05) THEN
              IF g_aag[l_ac].axqq05!=g_aag_t.axqq05
                 OR g_aag_t.axqq05 IS NULL THEN
                 SELECT COUNT(*) INTO l_n FROM axqq_file
                  WHERE axqq00 = g_axqq00 AND axqq01 = g_axqq.axqq01
                   #AND axqq02 = g_axqq02 AND axqq03 = g_axqq03     #MOD-DB0054 mark
                    AND axqq02 = g_axqq.axqq02 AND axqq03 = g_axqq.axqq03     #MOD-DB0054 
                    AND axqq04 = g_axqq.axqq04 AND axqq041 = g_axqq.axqq041
                    AND axqq12 = g_axqq.axqq12 AND axqq06 = g_axqq.axqq06
                    AND axqq07 = g_axqq.axqq07 AND axqq05 = g_aag[l_ac].axqq05
                 IF l_n>0 THEN
                    CALL cl_err('',-239,1)
                    NEXT FIELD axqq05
                 END IF 
              END IF 
           END IF 

       AFTER FIELD axqq08
           IF NOT cl_null(g_aag[l_ac].axqq08) THEN
              CALL cl_digcut(g_aag[l_ac].axqq08,t_azi04)  #No.TQC-BB0246 modify :l_azi->t_azi
                   RETURNING g_aag[l_ac].axqq08
              DISPLAY BY NAME g_aag[l_ac].axqq08
           END IF

       AFTER FIELD axqq09
           IF NOT cl_null(g_aag[l_ac].axqq09) THEN
              CALL cl_digcut(g_aag[l_ac].axqq09,t_azi04) #No.TQC-BB0246 modify :l_azi->t_azi
                   RETURNING g_aag[l_ac].axqq09
              DISPLAY BY NAME g_aag[l_ac].axqq09
           END IF


       BEFORE DELETE                            #是否取消單身
           IF g_aag_t.axqq05 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF

              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF

              DELETE FROM axqq_file
               WHERE axqq04=g_axqq.axqq04   AND axqq041=g_axqq.axqq041
                 AND axqq06=g_axqq.axqq06   AND axqq07=g_axqq.axqq07
                 AND axqq12=g_axqq.axqq12   
                 AND axqq05=g_aag_t.axqq05 
                 AND axqq01=g_axqq.axqq01  
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","axqq_file",g_axqq.axqq04,g_axqq.axqq041,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE
                 LET g_rec_b = g_rec_b-1
                 CALL t005_upamt()
                 DISPLAY g_rec_b TO FORMONLY.cnt2
                 COMMIT WORK
              END IF
           END IF

       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_aag[l_ac].* = g_aag_t.*
              CLOSE t005_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_aag[l_ac].axqq05,-263,1)
              LET g_aag[l_ac].* = g_aag_t.*
           ELSE
              UPDATE axqq_file SET axqq05 = g_aag[l_ac].axqq05,
                                   axqq08 = g_aag[l_ac].axqq08,
                                   axqq09 = g_aag[l_ac].axqq09
               WHERE axqq04=g_axqq.axqq04 AND axqq041=g_axqq.axqq041
                 AND axqq06=g_axqq.axqq06 AND axqq07=g_axqq.axqq07
                 AND axqq12=g_axqq.axqq12 AND axqq05=g_aag_t.axqq05
                 AND axqq01=g_axqq.axqq01   
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","axqq_file",g_axqq.axqq04,g_axqq.axqq041,SQLCA.sqlcode,"","",1)
                 LET g_aag[l_ac].* = g_aag_t.*
              ELSE
                 CALL t005_upamt()
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF

       AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30032 mark
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
              CLOSE t005_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30032 add
           CLOSE t005_bcl
           COMMIT WORK
           CALL g_aag.deleteElement(g_rec_b+1)

       AFTER INPUT
           CALL t005_upamt()

       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(axqq05) AND l_ac > 1 THEN
             LET g_aag[l_ac].* = g_aag[l_ac-1].*
             NEXT FIELD axqq05
          END IF

       ON ACTION CONTROLZ
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

#       ON ACTION CONTROLP
#          CASE
#             OTHERWISE EXIT CASE
#          END CASE

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

   CLOSE t005_bcl
   COMMIT WORK
END FUNCTION

FUNCTION t005_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc      STRING,      
          l_sql     STRING,      
          l_n       LIKE type_file.num5          #No.FUN-680098 smallint

    LET l_sql = "SELECT axqq05,axqq08,axqq09 FROM axqq_file ",  
                " WHERE axqq04 ='",g_axqq.axqq04,"'",
                "   AND axqq041='",g_axqq.axqq041,"'",
                "   AND axqq06 ='",g_axqq.axqq06,"'",
                "   AND axqq07 ='",g_axqq.axqq07,"'",
                "   AND axqq12 ='",g_axqq.axqq12,"'",
                "   AND axqq01 ='",g_axqq.axqq01,"'",  
                "   AND ",p_wc CLIPPED,
                " ORDER BY axqq05"

   PREPARE t005_pb FROM l_sql
   DECLARE aag_cs CURSOR FOR t005_pb          #BODY CURSOR

   CALL g_aag.clear()                         #將資料放入Array前，先將裡面清空
   LET g_cnt=1                                #指定由第一筆開始塞資料
   LET g_rec_b = 0

   FOREACH aag_cs INTO g_aag[g_cnt].*         #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN               #若超過系統指定最大單身筆數，
         CALL cl_err( '', 9035, 0 )           #則停止匯入資料
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_aag.deleteElement(g_cnt)

   LET g_rec_b = g_cnt -1
   CALL t005_upamt()
   DISPLAY g_rec_b TO FORMONLY.cnt2
   LET g_cnt = 0
END FUNCTION

FUNCTION t005_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #依照所選的action，呼叫所屬功能   

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN                                    #此判斷用於單身放棄新增時，
   END IF                                       #指標要停留在未新增前的行數

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)    #將確定、放棄隱藏起來
   DISPLAY ARRAY g_aag TO s_axqq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                       

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
      ON ACTION first
         CALL t005_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY    

      ON ACTION previous
         CALL t005_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
            CALL fgl_set_arr_curr(1) 
	 ACCEPT DISPLAY             

      ON ACTION jump
         CALL t005_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
            CALL fgl_set_arr_curr(1)
	 ACCEPT DISPLAY            

      ON ACTION next
         CALL t005_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1) 
	 ACCEPT DISPLAY                 

      ON ACTION last
         CALL t005_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
            CALL fgl_set_arr_curr(1)  
   	 ACCEPT DISPLAY              

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
        #CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

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

      ON ACTION auto_axqq
         LET g_action_choice = 'auto_axqq'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)        #將確定、放棄顯示出來
END FUNCTION

FUNCTION t005_upamt()
   DEFINE l_axqq08  LIKE axqq_file.axqq08,        #No.FUN-680098   dec(20,6)
          l_axqq09  LIKE axqq_file.axqq09         #No.FUN-680098   dec(20,6)

   SELECT SUM(axqq08) INTO l_axqq08
     FROM axqq_file
    WHERE axqq04 = g_axqq.axqq04 AND axqq041 = g_axqq.axqq041
      AND axqq06 = g_axqq.axqq06 AND axqq07 = g_axqq.axqq07
      AND axqq12 = g_axqq.axqq12
      AND axqq01 = g_axqq.axqq01        
      IF SQLCA.sqlcode THEN LET l_axqq08 = 0 END IF
   SELECT SUM(axqq09) INTO l_axqq09
     FROM axqq_file
    WHERE axqq04 = g_axqq.axqq04 AND axqq041 = g_axqq.axqq041
      AND axqq06 = g_axqq.axqq06 AND axqq07 = g_axqq.axqq07
      AND axqq12 = g_axqq.axqq12
      AND axqq01 = g_axqq.axqq01       
      IF SQLCA.sqlcode THEN LET l_axqq09 = 0 END IF
 
   IF cl_null(l_axqq08) THEN LET l_axqq08 = 0 END IF
   IF cl_null(l_axqq09) THEN LET l_axqq09 = 0 END IF

   LET g_sumaxqq08 = l_axqq08
   LET g_sumaxqq09 = l_axqq09

   DISPLAY g_sumaxqq08 TO FORMONLY.sumaxqq08
   DISPLAY g_sumaxqq09 TO FORMONLY.sumaxqq09
END FUNCTION

FUNCTION t005_copy()
   DEFINE l_axqq                 RECORD LIKE axqq_file.*,
          l_axqq01_o,l_axqq01_n   LIKE axqq_file.axqq01,    #FUN-910001 add
          l_axqq04_o,l_axqq04_n   LIKE axqq_file.axqq04,
          l_axqq041_o,l_axqq041_n LIKE axqq_file.axqq041,
          l_axqq06_o,l_axqq06_n   LIKE axqq_file.axqq06,
          l_axqq07_o,l_axqq07_n   LIKE axqq_file.axqq07,
          l_axqq12_o,l_axqq12_n   LIKE axqq_file.axqq12
         ,l_axqq02_o,l_axqq02_n   LIKE axqq_file.axqq02,  #MOD-DB0054 
          l_axqq03_o,l_axqq03_n   LIKE axqq_file.axqq03,  #MOD-DB0054 
          l_n,l_n1                LIKE type_file.num5     #MOD-DB0054 
   IF s_shut(0) THEN RETURN END IF

   IF g_axqq.axqq01 IS NULL AND g_axqq.axqq04 IS NULL AND g_axqq.axqq041 IS NULL AND   #FUN-910001 add axqq01
      g_axqq.axqq06 IS NULL AND g_axqq.axqq07 IS NULL AND g_axqq.axqq12 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET l_axqq06_n = ''
   LET l_axqq07_n = ''
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029

#   INPUT l_axqq01_n,l_axqq04_n,l_axqq041_n,l_axqq06_n,l_axqq07_n,l_axqq12_n WITHOUT DEFAULTS   #MOD-DB0054 mark
#         FROM axqq01,axqq04,axqq041,axqq06,axqq07,axqq12            #MOD-DB0054 mark
   INPUT l_axqq01_n,l_axqq02_n,l_axqq03_n,l_axqq04_n,l_axqq041_n,l_axqq06_n,l_axqq07_n,l_axqq12_n WITHOUT DEFAULTS   #MOD-DB0054 
         FROM axqq01,axqq02,axqq03,axqq04,axqq041,axqq06,axqq07,axqq12            #MOD-DB0054 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axqq01)   #族群代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_axa1"
                 LET g_qryparam.default1 = g_axqq.axqq01
                 CALL cl_create_qry() RETURNING l_axqq01_n
                 DISPLAY l_axqq01_n TO axqq01
                 NEXT FIELD axqq01            
            WHEN INFIELD(axqq04)   #下層公司編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axz"  
                 LET g_qryparam.default1 = g_axqq.axqq04
                 CALL cl_create_qry() RETURNING l_axqq04_n
                 DISPLAY l_axqq04_n TO axqq04
                 NEXT FIELD axqq04
            WHEN INFIELD(axqq12)   #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_axqq.axqq12
                 CALL cl_create_qry() RETURNING l_axqq12_n
                 DISPLAY l_axqq12_n TO axqq12
                 NEXT FIELD axqq12
         END CASE
      #MOD-DB0054 begin ------
       AFTER FIELD axqq01
         IF cl_null(l_axqq01_n) THEN
            CALL cl_err(l_axqq01_n,'mfg5103',0)
            NEXT FIELD axqq01
         ELSE           
            SELECT axa02,axa03 INTO l_axqq02_n,l_axqq03_n FROM axa_file 
             WHERE axa01 = l_axqq01_n AND axa04 = 'Y'   
           DISPLAY l_axqq02_n TO axqq02    #MOD-DB0054 add 
           DISPLAY l_axqq03_n TO axqq03    #MOD-DB0054 add      
         END IF
       AFTER FIELD axqq02
         IF cl_null(l_axqq02_n) THEN
            CALL cl_err(l_axqq02_n,'mfg5103',0)
            NEXT FIELD axqq02
         END IF         
         SELECT COUNT(*) INTO l_n1 FROM axb_file 
         WHERE axb01 = l_axqq01_n 
           AND axb02 = l_axqq02_n           
         IF l_n1 = 0 THEN
            CALL cl_err(l_axqq02_n,'agl030',0)
            NEXT FIELD axqq02
         END IF         
         SELECT axz05 INTO l_axqq03_n
           FROM axz_file
          WHERE axz01 = l_axqq02_n
         IF SQLCA.SQLCODE THEN
            CALL cl_err(l_axqq02_n,'aco-025',0)
            NEXT FIELD axqq02
         END IF
         DISPLAY l_axqq03_n TO axqq03 
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM axz_file
          WHERE axz01=l_axqq02_n AND axz05=l_axqq03_n
         IF l_n = 0 THEN
            CALL cl_err(l_axqq02_n,'agl-948',0)  
            NEXT FIELD axqq02
         END IF     
       #MOD-DB0054 end --------
      AFTER FIELD axqq04
         IF cl_null(l_axqq04_n) THEN
            CALL cl_err(l_axqq04_n,'mfg5103',0)
            NEXT FIELD axqq04
         END IF
         SELECT axz05,axz06 INTO l_axqq041_n,l_axqq12_n
           FROM axz_file
          WHERE axz01 = l_axqq04_n
         IF SQLCA.SQLCODE THEN
            CALL cl_err(l_axqq04_n,'aco-025',0)
            NEXT FIELD axqq04
         END IF
         DISPLAY l_axqq041_n TO axqq041
         DISPLAY l_axqq12_n  TO axqq12

      AFTER FIELD axqq12
         IF NOT cl_null(l_axqq12_n) THEN
            SELECT count(*) INTO g_cnt FROM axqq_file
             WHERE axqq04=l_axqq04_n AND axqq041=l_axqq041_n
               AND axqq06=l_axqq06_n AND axqq07=l_axqq07_n
               AND axqq12=l_axqq12_n
               AND axqq01=l_axqq01_n 
            IF g_cnt > 0 THEN
               CALL cl_err(l_axqq12_n,-239,0)
               NEXT FIELD axqq12
            END IF
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
   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
     #DISPLAY g_axqq.axqq01,g_axqq.axqq04,g_axqq.axqq041,   #MOD-DB0054 mark
      DISPLAY g_axqq.axqq01,g_axqq.axqq02,g_axqq.axqq03,g_axqq.axqq04,g_axqq.axqq041,   #MOD-DB0054
              g_axqq.axqq06,g_axqq.axqq07,g_axqq.axqq12
           TO axqq01,axqq02,axqq03,axqq04,axqq041,axqq06,axqq07,axqq12   #FUN-910001 add axqq01 #MOD-DB0054 add axqq02,03
      RETURN
   END IF

   DROP TABLE x
   SELECT * FROM axqq_file         #單身複製
    WHERE axqq04=g_axqq.axqq04 AND axqq041=g_axqq.axqq041 AND axqq06=g_axqq.axqq06
      AND axqq07=g_axqq.axqq07 AND axqq12=g_axqq.axqq12
      AND axqq01=g_axqq.axqq01 AND axqqlegal=g_legal      #FUN-B60134 axqqlegal=g_legal  
      AND axqq02=g_axqq.axqq02 AND axqq03=g_axqq.axqq03   #MOD-DB0054 add
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_axqq.axqq04,g_axqq.axqq041,SQLCA.sqlcode,"","",1)  
      RETURN
   END IF

   UPDATE x
      SET axqq04 =l_axqq04_n,
          axqq041=l_axqq041_n,
          axqq06 =l_axqq06_n,
          axqq07 =l_axqq07_n,
          axqq12 =l_axqq12_n,
          axqq01 =l_axqq01_n,
          axqqlegal = g_legal    #FUN-B60134
         ,axqq02 =l_axqq02_n,    #MOD-DB0054 add
          axqq03 =l_axqq03_n     #MOD-DB0054 add
   INSERT INTO axqq_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","axqq_file",l_axqq04_n,l_axqq041_n,SQLCA.sqlcode,"","axqq:",1)
      RETURN
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_axqq04_n,') O.K'

   LET l_axqq01_o = g_axqq.axqq01 
   LET l_axqq02_o = g_axqq.axqq02  #MOD-DB0054 add 
   LET l_axqq03_o = g_axqq.axqq03  #MOD-DB0054 add 
   LET l_axqq04_o = g_axqq.axqq04
   LET l_axqq041_o= g_axqq.axqq041
   LET l_axqq06_o = g_axqq.axqq06
   LET l_axqq07_o = g_axqq.axqq07
   LET l_axqq12_o = g_axqq.axqq12
   LET g_axqq.axqq01 =l_axqq01_n 
   LET g_axqq.axqq02 =l_axqq02_n   #MOD-DB0054 add 
   LET g_axqq.axqq03 =l_axqq03_n   #MOD-DB0054 add 
   LET g_axqq.axqq04 =l_axqq04_n
   LET g_axqq.axqq041=l_axqq041_n
   LET g_axqq.axqq06 =l_axqq06_n
   LET g_axqq.axqq07 =l_axqq07_n
   LET g_axqq.axqq12 =l_axqq12_n

   CALL t005_b()
   #FUN-C30027---begin
   #LET g_axqq.axqq01 =l_axqq01_o 
   #LET g_axqq.axqq04 =l_axqq04_o
   #LET g_axqq.axqq041=l_axqq041_o
   #LET g_axqq.axqq06 =l_axqq06_o
   #LET g_axqq.axqq07 =l_axqq07_o
   #LET g_axqq.axqq12 =l_axqq12_o
   #CALL t005_show()
   #FUN-C30027---end
END FUNCTION

FUNCTION t005_ins_axqq()
DEFINE l_sql   STRING
DEFINE l_aag01 LIKE aag_file.aag01
DEFINE l_axqq  RECORD
               axqq05 LIKE axqq_file.axqq05,
               axqq08 LIKE axqq_file.axqq08,
               axqq09 LIKE axqq_file.axqq09
               END RECORD

    LET g_success = 'Y'
    IF NOT cl_null(g_axqq.axqq04) AND NOT cl_null(g_axqq.axqq041) AND
       NOT cl_null(g_axqq.axqq06) AND NOT cl_null(g_axqq.axqq07) AND
       NOT cl_null(g_axqq.axqq12) AND NOT cl_null(g_axqq.axqq01) THEN
      
       BEGIN WORK
       CALL s_showmsg_init()
#FUN-B60134--mod--str--
#      SELECT azp03 INTO g_dbs_new FROM azp_file,axz_file
#       WHERE azp01 = axz03 AND axz01 = g_axqq.axqq04 
#      CALL s_dbstring(g_dbs_new CLIPPED) RETURNING g_dbs_new
       SELECT axz03 INTO g_plant_new FROM axz_file WHERE axz01 = g_axqq.axqq04
#FUN-B60134--mod--end

       #LET l_sql = "SELECT aag01 FROM ",g_dbs_new CLIPPED,"aag_file",   #FUN-B60134
       LET l_sql = "SELECT aag01 FROM ",cl_get_target_table(g_plant_new,'aag_file'),  #FUN-B60134
                   " WHERE aag00 = '",g_axqq.axqq041,"'",
                   "   AND aag19 IN ('19','20','21','22')",   #权益类
                   "   AND aag07<>'1' " 
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #FUN-B60134
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-B60134
       PREPARE sel_aag_pre FROM l_sql
       DECLARE sel_aag_cur CURSOR FOR sel_aag_pre
       FOREACH sel_aag_cur INTO l_aag01
               LET l_axqq.axqq05 = l_aag01 
     
               #LET l_sql = "SELECT SUM(aah05-aah04) FROM ",g_dbs_new CLIPPED,"aah_file ",  #FUN-B60134
               LET l_sql = "SELECT SUM(aah05-aah04) FROM ",cl_get_target_table(g_plant_new,'aah_file'),
                           " WHERE aah00 = '",g_axqq.axqq041,"' AND aah02 = '",g_axqq.axqq06,"'", 
                           "   AND aah03 = 0 AND aah01 = '",l_axqq.axqq05,"'" 
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #FUN-B60134
               CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-B60134
               PREPARE sel_axqq08 FROM l_sql
               EXECUTE sel_axqq08 INTO l_axqq.axqq08
               IF cl_null(l_axqq.axqq08) THEN LET l_axqq.axqq08 = 0 END IF 
               #LET l_sql ="SELECT SUM(aah05-aah04) FROM ",g_dbs_new CLIPPED,"aah_file ", #FUN-B60134
               LET l_sql ="SELECT SUM(aah05-aah04) FROM ",cl_get_target_table(g_plant_new,'aah_file'),
                          " WHERE aah00 = '",g_axqq.axqq041,"' AND aah02 = '",g_axqq.axqq06,"'", 
                          "   AND aah03 BETWEEN 1 AND '",g_axqq.axqq07,"'", 
                          "   AND aah01 = '",l_axqq.axqq05,"'" 
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #FUN-B60134
               CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-B60134
               PREPARE sel_axqq09 FROM l_sql
               EXECUTE sel_axqq09 INTO l_axqq.axqq09
               IF cl_null(l_axqq.axqq09) THEN LET l_axqq.axqq09 = 0 END IF 
               IF l_axqq.axqq08 = 0 AND l_axqq.axqq09 = 0 THEN CONTINUE FOREACH END IF 
     

               INSERT INTO axqq_file(axqq00,axqq01,axqq02,axqq03,
                                     axqq04,axqq041,axqq06,axqq07,axqq12,
                                     axqq05,axqq08,axqq09,axqqlegal)          #FUN-B60134
                        #VALUES(g_axqq00,g_axqq.axqq01,g_axqq02,g_axqq03,     #MOD-DB0054 mark
                         VALUES(g_axqq00,g_axqq.axqq01,g_axqq.axqq02,g_axqq.axqq03,     #MOD-DB0054
                                g_axqq.axqq04,g_axqq.axqq041,g_axqq.axqq06,
                                g_axqq.axqq07,g_axqq.axqq12,l_axqq.axqq05,
                                l_axqq.axqq08,l_axqq.axqq09,g_legal)           #FUN-B60134
           IF SQLCA.sqlcode THEN
              CALL s_errmsg('axqq_file','insert',l_axqq.axqq05,SQLCA.sqlcode,1)
              LET g_success = 'N'
           END IF 
       END FOREACH
       IF g_success = 'Y' THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
        END IF 
    ELSE
       RETURN
    END IF 
END FUNCTION

