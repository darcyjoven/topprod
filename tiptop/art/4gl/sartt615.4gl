# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: sartt615.4gl
# Descriptions...: 押金收取/返還單
# Date & Author..: FUN-870100 09/09/27 By Cockroach
# Modify.........: FUN-9B0025 09/12/09 By cockroach PASS NO.
# Modify.........: TQC-A10085 10/01/10 By Cockroach 新增邏輯
# Modify.........: TQC-A20025 10/02/09 By Cockroach BUG處理
# Modify.........: TQC-A20047 10/02/23 By Cockroach BUG處理
# Modify.........: TQC-A20048 10/02/23 By Cockroach BUG處理
# Modify.........: TQC-A30002 10/03/01 By Cockroach BUG處理
# Modify.........: TQC-A30056 10/03/17 By Cockroach PASS No.
# Modify.........: FUN-A70130 10/08/06 By shaoyong  ART單據性質調整,q_smy改为q_oay
# Modify.........: TQC-AC0124 10/12/17 By huangtao 預設押金金額
# Modify.........: TQC-AC0223 10/12/17 By wangxin 借出單號帶出相對應的押金單號及退還金額 
# Modify.........: TQC-AC0127 10/12/22 By chenying add rxr16
# Modify.........: TQC-AC0127 10/12/28 By wuxj    當rxr16不為空的時候，不可取消審核，刪除時相對應的收款退款資料一併刪除
#                                                 增加產生賬款按鈕，調用axrp700
# Modify.........: TQC-B20065 11/02/16 By elva 增加接收参数rxr01
# Modify.........: No.CHI-B40058 11/05/13 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤


# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/sartt615.global"

#FUNCTION t615(p_argv1,p_argv2)  #TQC-B20065
FUNCTION t615(p_argv1,p_argv2,p_argv3)  #TQC-B20065
DEFINE p_argv1 LIKE type_file.chr1
DEFINE p_argv2 LIKE rxr_file.rxr02  #TQC-A10085 ADD
DEFINE p_argv3 LIKE rxr_file.rxr01  #TQC-B20065 ADD
DEFINE     l_n       LIKE type_file.num5 

    WHENEVER ERROR CALL cl_err_msg_log
    LET g_rxr00 = p_argv1
    LET p_rxr02 = p_argv2           #TQC-A10085 ADD
    LET g_rxr01 = p_argv3           #TQC-B20065 ADD

    LET g_forupd_sql="SELECT * FROM rxr_file ",
                     " WHERE rxr00='",g_rxr00,"' AND rxr01=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t615_cl CURSOR FROM g_forupd_sql
    
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t615_w AT p_row,p_col WITH FORM "art/42f/artt615"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()

    CALL t615_g_form()
    IF g_rxr00 ='1' THEN
       CALL cl_set_act_visible("pay_money",TRUE) 
       CALL cl_set_act_visible("reback_money",FALSE)   
    ELSE 
       CALL cl_set_act_visible("pay_money",FALSE) 
       CALL cl_set_act_visible("reback_money",TRUE) 
    END IF       
    
    IF NOT cl_null(p_rxr02) THEN        #TQC-A10085 add
       SELECT COUNT(*) INTO l_n FROM rxr_file
        WHERE rxr00 = g_rxr00
          AND rxr02 = p_rxr02
          AND rxracti='Y'
          AND rxrconf<>'X'

       IF l_n=0 THEN
          LET g_action_choice="insert"
          CALL t615_a()
          CALL cl_set_act_visible("insert",FALSE)
       ELSE 
          LET g_action_choice="query"
          CALL t615_q()
          CALL cl_set_act_visible("query",FALSE)
       END IF
    END IF
    #TQC-B20065 --begin
    IF NOT cl_null(g_rxr01) THEN
       LET g_action_choice="query"
       CALL t615_q()
       CALL cl_set_act_visible("query",FALSE)
    END IF
    #TQC-B20065 --end
    CALL t615_menu()
    CLOSE WINDOW t615_w
END FUNCTION

FUNCTION t615_g_form()
DEFINE l_rxr01 LIKE gae_file.gae04
DEFINE l_inx   LIKE type_file.num5
DEFINE l_str STRING

    CALL cl_set_comp_visible("rxr03,rxr13",g_rxr00='2')   
    SELECT gae04 INTO l_rxr01 FROM gae_file
     WHERE gae01 = 'artt615'
       AND gae12 = 'std'
       AND gae02 = 'rxr01'
       AND gae03 = g_lang


    IF g_rxr00='1' THEN
       LET l_str = l_rxr01
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("rxr01",l_str.subString(1,l_inx-1))
    ELSE
       LET l_str = l_rxr01
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("rxr01",l_str.subString(l_inx+1,l_str.getLength()))
    END IF
END FUNCTION


FUNCTION t615_cs()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01

    CLEAR FORM
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " rxr02= '",p_rxr02,"' AND rxracti='Y' AND rxrconf<>'X' "   #TQC-A10085 ADD 
    ELSE
       #TQC-B20065 --begin
       IF NOT cl_null(g_rxr01) THEN
          LET g_wc = " rxr01= '",g_rxr01,"' AND rxracti='Y' AND rxrconf='Y' "   
       ELSE
       #TQC-B20065 --end
          INITIALIZE g_rxr.* TO NULL
          CONSTRUCT BY NAME g_wc ON                               
              rxr01,rxr02,rxr03,rxr04,rxr05,
              rxr06,rxr07,rxr08,rxr09,rxr10,
              rxr11,rxr12,rxr13,rxr14,rxr16,rxr15,   #TQC-AC0127 add
              rxrconf,rxrcond,rxrconu,rxrplant,
              rxruser,rxrgrup,rxrmodu,rxrdate,
              rxracti,rxrcrat,rxroriu,rxrorig
                   
             BEFORE CONSTRUCT
                CALL cl_qbe_init()
                DISPLAY g_rxr00 TO rxr00   

              ON ACTION controlp
                 CASE
                    WHEN INFIELD(rxr01)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_rxr01"
                       LET g_qryparam.state = "c"
                       LET g_qryparam.arg1 = g_rxr00
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO rxr01
                       NEXT FIELD rxr01
                    WHEN INFIELD(rxr02)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_rxr02"
                       LET g_qryparam.state = "c"
                       LET g_qryparam.arg1 = g_rxr00
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO rxr02
                       NEXT FIELD rxr02
                    WHEN INFIELD(rxr03)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_rxr03"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO rxr03
                       NEXT FIELD rxr03
                    WHEN INFIELD(rxr10)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_rxr10"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO rxr10
                       NEXT FIELD rxr10
                    WHEN INFIELD(rxr14)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_rxr14"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO rxr14
                       NEXT FIELD rxr14
                    #TQC-AC0127-------add--------str-----------
                    WHEN INFIELD(rxr16)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_rxr16_1"
                       LET g_qryparam.state = "c"
                       LET g_qryparam.arg1  = g_rxr00
                       LET g_qryparam.where = " rxr16 IS NOT NULL"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO rxr16
                       NEXT FIELD rxr16 
                    #TQC-AC0127------add-------------end------------
                    WHEN INFIELD(rxrconu)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_rxrconu"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO rxrconu
                       NEXT FIELD rxrconu
                    WHEN INFIELD(rxrplant)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_azp"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO rxrplant
                       NEXT FIELD rxrplant
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
                 CALL cl_qbe_list() RETURNING lc_qbe_sn
                 CALL cl_qbe_display_condition(lc_qbe_sn)          
              	
          END CONSTRUCT
       END IF  #TQC-B20065
    END IF
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rxruser', 'rxrgrup')
  
    LET g_sql = "SELECT rxr01 FROM rxr_file ", 
                " WHERE rxr00 = '",g_rxr00,"'",
                "   AND ",g_wc CLIPPED," ORDER BY rxr01"
    PREPARE t615_prepare FROM g_sql
    DECLARE t615_cs SCROLL CURSOR WITH HOLD FOR t615_prepare

    LET g_sql="SELECT COUNT(*) FROM rxr_file ",
              " WHERE rxr00='",g_rxr00,"' AND ",g_wc CLIPPED                
    PREPARE t615_precount FROM g_sql
    DECLARE t615_count CURSOR FOR t615_precount
    
END FUNCTION

FUNCTION t615_menu()
   DEFINE l_price1      LIKE oeb_file.oeb14t 
   MENU ""
      BEFORE MENU
          CALL cl_navigator_setting( g_curs_index, g_row_count )

      ON ACTION confirm 
         LET g_action_choice="confirm"
         IF cl_chk_act_auth() THEN
            CALL t615_y()
         END IF          

      ON ACTION undo_confirm 
         LET g_action_choice="undo_confirm"
         IF cl_chk_act_auth() THEN
            CALL t615_n()
         END IF          

      ON ACTION void 
         LET g_action_choice="void"
         IF cl_chk_act_auth() THEN
            CALL t615_v()
         END IF
          
      ON ACTION insert 
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL t615_a()
         END IF

      ON ACTION query 
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL t615_q()
         END IF

      ON ACTION modify 
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL t615_u()
         END IF
         
      ON ACTION reproduce 
         LET g_action_choice="reproduce"
         IF cl_chk_act_auth() THEN
            CALL t615_copy()
         END IF
         
      ON ACTION invalid
         LET g_action_choice="invalid"
         IF cl_chk_act_auth() THEN
            CALL t615_x()
         END IF

      ON ACTION delete 
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL t615_r()
         END IF

      ON ACTION output 
         LET g_action_choice="output"
         IF cl_chk_act_auth() THEN
           # CALL t615_out()
         END IF

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         IF cl_chk_act_auth() THEN
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rxr),'','')
         END IF  

         
      ON ACTION pay_money 
         LET g_action_choice = "pay_money"
         IF cl_chk_act_auth() THEN
            CALL t615_pay_chk() 
            CALL s_pay('05',g_rxr.rxr01,g_rxr.rxrplant,g_rxr.rxr11,g_rxr.rxrconf)
         END IF      
      ON ACTION money_detail   
         LET g_action_choice = 'money_detail'                                                                                                            
         IF cl_chk_act_auth() THEN                                                                                                
          IF g_rxr00='1' THEN
            CALL s_pay_detail('05',g_rxr.rxr01,g_rxr.rxrplant,g_rxr.rxrconf)                                                     
          ELSE
            CALL s_pay_detail('06',g_rxr.rxr01,g_rxr.rxrplant,g_rxr.rxrconf)                                                     
          END IF
         END IF          
      ON ACTION reback_money           
         LET g_action_choice = 'reback_money'                                                                                             
         IF cl_chk_act_auth() THEN
            CALL t615_reback_chk() 
            CALL s_pay('06',g_rxr.rxr01,g_rxr.rxrplant,g_rxr.rxr13,g_rxr.rxrconf)
         END IF                

#TQC-AC0127   ---begin---
      ON ACTION produce_money
         LET g_action_choice = 'produce_money'
         IF cl_chk_act_auth() THEN
            IF g_rxr.rxrconf = 'Y' AND cl_null(g_rxr.rxr16) THEN
               LET g_msg="axrp700 '",g_rxr.rxr00,"' '",g_rxr.rxr01,"'"
               CALL cl_cmdrun(g_msg)
               SELECT rxr16 INTO g_rxr.rxr16 FROM rxr_file WHERE rxr01 = g_rxr.rxr01 AND rxr00 = g_rxr.rxr00
               DISPLAY BY NAME g_rxr.rxr16 
            ELSE
               CALL cl_err(g_rxr.rxr01,'axr106',1)
            END IF 
            CONTINUE MENU 
         END IF 
#TQC-AC0127   ---end---

      ON ACTION first
         CALL t615_fetch('F')

      ON ACTION previous 
         CALL t615_fetch('P')

      ON ACTION jump
         CALL t615_fetch('/')

      ON ACTION next 
         CALL t615_fetch('N') 

      ON ACTION last
         CALL t615_fetch('L')

      ON ACTION help 
         CALL cl_show_help()

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()              
         CALL t615_g_form()              #TQC-A20047 ADD

      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
                  
         
      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document    
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
             IF g_rxr.rxr01 IS NOT NULL THEN
                LET g_doc.column1 = "rxr00"
                LET g_doc.column1 = "rxr01"
                LET g_doc.value1 = g_rxr.rxr00
                LET g_doc.value1 = g_rxr.rxr01
                CALL cl_doc()
             END IF
         END IF
         LET g_action_choice = "exit"
         CONTINUE MENU

      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0025 
         LET INT_FLAG=FALSE
         LET g_action_choice = "exit"
         EXIT MENU
   END MENU
   CLOSE t615_cs

END FUNCTION



FUNCTION t615_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')
    CLEAR FORM
 
    MESSAGE ""
    DISPLAY ' ' TO FORMONLY.cnt

    CALL t615_cs()

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rxr.* TO NULL 
        RETURN
    END IF

    OPEN t615_cs

    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0) 
    ELSE
       OPEN t615_count
       FETCH t615_count INTO g_row_count
       IF g_row_count>0 THEN
          DISPLAY g_row_count TO FORMONLY.cnt
          CALL t615_fetch('F')
       ELSE
          CALL cl_err('',100,0)
       END IF
    END IF
END FUNCTION

FUNCTION t615_fetch(p_flrxr)
DEFINE p_flrxr         LIKE type_file.chr1    
       
    CASE p_flrxr
        WHEN 'N' FETCH NEXT     t615_cs INTO g_rxr.rxr01
        WHEN 'P' FETCH PREVIOUS t615_cs INTO g_rxr.rxr01
        WHEN 'F' FETCH FIRST    t615_cs INTO g_rxr.rxr01
        WHEN 'L' FETCH LAST     t615_cs INTO g_rxr.rxr01
        WHEN '/'
            IF (NOT mi_no_ask) THEN                   
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
                   LET g_jump = g_curs_index
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t615_cs INTO g_rxr.rxr01
            LET mi_no_ask = FALSE        
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rxr.rxr01,SQLCA.sqlcode,0)
        INITIALIZE g_rxr.* TO NULL  
        RETURN
    ELSE
      CASE p_flrxr
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF

    SELECT * INTO g_rxr.* FROM rxr_file    
     WHERE rxr00 = g_rxr00
       AND rxr01 = g_rxr.rxr01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","rxr_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_rxr.rxruser           
        LET g_data_group=g_rxr.rxrgrup 
        LET g_data_plant=g_rxr.rxrplant  #TQC-A10085 ADD
        CALL t615_show()                   
    END IF
END FUNCTION

FUNCTION t615_show()
DEFINE l_gen02     LIKE gen_file.gen02
DEFINE l_gen02_1   LIKE gen_file.gen02 
DEFINE l_occ02     LIKE occ_file.occ02
DEFINE l_azp02     LIKE azp_file.azp02

    LET g_rxr_t.* = g_rxr.*
    DISPLAY BY NAME g_rxr.rxr00,g_rxr.rxr01,g_rxr.rxr02,g_rxr.rxr03,
                    g_rxr.rxr04,g_rxr.rxr05,g_rxr.rxr06,g_rxr.rxr07,
                    g_rxr.rxr08,g_rxr.rxr09,g_rxr.rxr10,g_rxr.rxr11,
                    g_rxr.rxr12,g_rxr.rxr13,g_rxr.rxr14,g_rxr.rxr15,g_rxr.rxr16 , #TQC-AC0127 add rxr16
                    g_rxr.rxrconf,g_rxr.rxrcond,g_rxr.rxrconu,
                    g_rxr.rxrplant,g_rxr.rxruser,g_rxr.rxrgrup,
                    g_rxr.rxrmodu,g_rxr.rxrdate,g_rxr.rxracti,
                    g_rxr.rxrcrat,g_rxr.rxroriu,g_rxr.rxrorig

    IF cl_null(g_rxr.rxrconu) THEN
       DISPLAY '' TO rxrconu_desc
    ELSE
       SELECT gen02 INTO l_gen02 FROM gen_file
        WHERE gen01 = g_rxr.rxrconu
          AND genacti = 'Y'
       DISPLAY l_gen02 TO rxrconu_desc
    END IF
    
 
    IF cl_null(g_rxr.rxr10) THEN
       DISPLAY '' TO rxr10_desc
    ELSE
       SELECT gen02 INTO l_gen02_1 FROM gen_file
        WHERE gen01 = g_rxr.rxr10
          AND genacti = 'Y'
       DISPLAY l_gen02_1 TO rxr10_desc
    END IF    
    SELECT azp02 INTO l_azp02 FROM azp_file
     WHERE azp01 = g_rxr.rxrplant
   DISPLAY l_azp02 TO rxrplant_desc 

    CASE g_rxr.rxrconf
       WHEN "Y"
          CALL cl_set_field_pic('Y',"","","","","")
       WHEN "N"
          CALL cl_set_field_pic('',"","","","",g_rxr.rxracti)
       WHEN "X"
          CALL cl_set_field_pic("","","","",'Y',"")
    END CASE
     
    CALL cl_show_fld_cont()                   
END FUNCTION


FUNCTION t615_a_default()
DEFINE l_azp02 LIKE azp_file.azp02
DEFINE l_gen02 LIKE gen_file.gen02

      LET g_rxr.rxr00 = g_rxr00
      LET g_rxr.rxr05 = g_today
      LET g_rxr.rxr08 = '1'    #TQC-A20048 ADD 
      LET g_rxr.rxrconf = 'N'
      LET g_rxr.rxrplant = g_plant
      LET g_rxr.rxruser = g_user
      LET g_rxr.rxrgrup = g_grup
      LET g_rxr.rxrcrat = g_today
      LET g_rxr.rxracti = 'Y' 
      LET g_rxr.rxroriu = g_user
      LET g_rxr.rxrorig = g_grup
      LET g_data_plant  = g_plant  #TQC-A10085 ADD
      LET g_rxr.rxrconu = ' ' 
      LET g_rxr.rxrcond = ' '  
      LET g_rxr.rxrdate = ' '
      LET g_rxr.rxr11 = 0
      LET g_rxr.rxr12 = 0
      LET g_rxr.rxr13 = 0 
      IF NOT cl_null(p_rxr02) THEN
         LET g_rxr.rxr02 = p_rxr02
         CALL t615_rxr02()
         SELECT gen02 INTO l_gen02 FROM gen_file
          WHERE gen01 = g_rxr.rxr10 AND genacti='Y'
         IF cl_null(l_gen02) THEN LET l_gen02=' ' END IF
         DISPLAY l_gen02 TO rxr10_desc 
      END IF
      SELECT azp02 INTO l_azp02 FROM azp_file
       WHERE azp01 = g_plant
      SELECT azw02 INTO g_rxr.rxrlegal FROM azw_file
       WHERE azw01 = g_plant
         AND azwacti = 'Y'
      DISPLAY BY NAME g_rxr.rxr00,g_rxr.rxr02,g_rxr.rxr05,g_rxr.rxrconf,
                      g_rxr.rxrplant,g_rxr.rxruser,
                      g_rxr.rxrgrup,g_rxr.rxrcrat,g_rxr.rxracti,
                      g_rxr.rxroriu,g_rxr.rxrorig
      DISPLAY l_azp02 TO rxrplant_desc
END FUNCTION

FUNCTION t615_a()
DEFINE li_result LIKE type_file.num5

   MESSAGE ""
   CLEAR FORM
   INITIALIZE g_rxr.* TO NULL
   LET g_wc = NULL 

   IF s_shut(0) THEN
      RETURN
   END IF

   INITIALIZE g_rxr.* LIKE rxr_file.*                  

   LET g_rxr_t.* = g_rxr.*
   CALL cl_opmsg('a')

   WHILE TRUE
      CALL t615_a_default()                   

      CALL t615_i("a")                          

      IF INT_FLAG THEN                          
         INITIALIZE g_rxr.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF cl_null(g_rxr.rxr01) THEN       
         CONTINUE WHILE
      END IF
      BEGIN WORK
      IF g_rxr00 = '1'  THEN
#        CALL s_auto_assign_no("art",g_rxr.rxr01,g_today,"R","rxr_file","rxr00,rxr01","","","") #FUN-A70130 mark
         CALL s_auto_assign_no("art",g_rxr.rxr01,g_today,"F1","rxr_file","rxr00,rxr01","","","") #FUN-A70130 mod
         RETURNING li_result,g_rxr.rxr01
      ELSE
#     	 CALL s_auto_assign_no("art",g_rxr.rxr01,g_today,"S","rxr_file","rxr00,rxr01","","","") #FUN-A70130 mark
      	 CALL s_auto_assign_no("art",g_rxr.rxr01,g_today,"F2","rxr_file","rxr00,rxr01","","","") #FUN-A70130 mod
         RETURNING li_result,g_rxr.rxr01  
      END IF   
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_rxr.rxr01
      IF g_rxr.rxr08 IS NULL THEN LET g_rxr.rxr08=' ' END IF
      IF cl_null(g_rxr.rxr13) THEN LET g_rxr.rxr13=0 END IF 

      SELECT azw02 INTO g_rxr.rxrlegal FROM azw_file
       WHERE azw01 = g_plant
         AND azwacti = 'Y' 
                  
      INSERT INTO rxr_file VALUES (g_rxr.*)
      IF SQLCA.sqlcode THEN                     
         CALL cl_err(g_rxr.rxr01,SQLCA.sqlcode,1)   
         CALL cl_err3("ins","rxr_file",g_rxr.rxr01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
 #    #TQC-A10085 ADD---------------------------
 #    UPDATE ruq_file
 #       SET ruq04 = g_rxr.rxr01
 #     WHERE ruq01 = g_rxr.rxr02
 #       AND ruq00 = g_rxr00
 #    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
 #       CALL cl_err3("upd","ruq_file",g_rxr.rxr02,"",SQLCA.sqlcode,"","ruq",1) 
 #       CONTINUE WHILE
 #    END IF
 #    #TQC-A10085 ADD---------------------------
      SELECT * INTO g_rxr.* FROM rxr_file
       WHERE rxr01 = g_rxr.rxr01
         AND rxr00 = g_rxr00  
      LET g_rxr_t.* = g_rxr.*                
      EXIT WHILE
   END WHILE
   CLOSE t615_cl
   COMMIT WORK
   CALL t615_show()  
END FUNCTION

FUNCTION t615_i(p_cmd)
DEFINE     p_cmd     LIKE type_file.chr1
DEFINE     l_n       LIKE type_file.num5 
DEFINE     l_rur15   LIKE rur_file.rur15    #add    

   CALL cl_set_head_visible("","YES")
   
   INPUT BY NAME
      g_rxr.rxr01,g_rxr.rxr02,g_rxr.rxr03,g_rxr.rxr04,
      g_rxr.rxr05,g_rxr.rxr06,g_rxr.rxr07,g_rxr.rxr08,
      g_rxr.rxr09,g_rxr.rxr10,g_rxr.rxr11,g_rxr.rxr12,
      g_rxr.rxr13,g_rxr.rxr14,g_rxr.rxr15  
      WITHOUT DEFAULTS

      BEFORE INPUT

          LET g_before_input_done = FALSE
          CALL t615_set_entry(p_cmd)
          CALL t615_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("rxr01")        #TQC-A20025 ADD
          IF g_rxr00 = '2' THEN
             CALL cl_set_comp_entry("rxr11",FALSE)
          END IF	
          IF NOT cl_null(p_rxr02) THEN         #TQC-A10085 ADD
             LET g_rxr.rxr02 = p_rxr02
             CALL cl_set_comp_entry("rxr02",FALSE)
          END IF
          CALL cl_set_comp_entry("rxr04,rxr12",FALSE)    #TQC-A10085 ADD 

      AFTER FIELD rxr01
         IF NOT cl_null(g_rxr.rxr01) THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rxr.rxr01 <> g_rxr_t.rxr01) THEN
                IF g_rxr00 = '1' THEN
#                  CALL s_check_no("art",g_rxr.rxr01,g_rxr_t.rxr01,"R","rxr_file","rxr00,rxr01","")  #FUN-A70130 mark
                   CALL s_check_no("art",g_rxr.rxr01,g_rxr_t.rxr01,"F1","rxr_file","rxr00,rxr01","")  #FUN-A70130 mod
                        RETURNING li_result,g_rxr.rxr01
                ELSE
#                  CALL s_check_no("art",g_rxr.rxr01,g_rxr_t.rxr01,"S","rxr_file","rxr00,rxr01","")  #FUN-A70130 mark
                   CALL s_check_no("art",g_rxr.rxr01,g_rxr_t.rxr01,"F2","rxr_file","rxr00,rxr01","")  #FUN-A70130 mod
                        RETURNING li_result,g_rxr.rxr01
                END IF
                IF (NOT li_result) THEN
                   LET g_rxr.rxr01=g_rxr_t.rxr01
                   NEXT FIELD rxr01
                END IF
               SELECT COUNT(*) INTO l_n FROM rxr_file
                WHERE rxr00=g_rxr00
                  AND rxr01=g_rxr.rxr01
               IF l_n>0 THEN 
                  CALL cl_err(g_rxr.rxr01,-239,0)
                  NEXT FIELD rxr01
               END IF   
            END IF
         END IF
      

      AFTER FIELD rxr02
         IF NOT cl_null(g_rxr.rxr02) THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rxr.rxr02 <> g_rxr_t.rxr02) THEN
               SELECT COUNT(*) INTO l_n FROM ruq_file
                WHERE ruq00 = g_rxr00
                  AND ruq01 = g_rxr.rxr02
               IF l_n<>1 THEN
                  CALL cl_err(g_rxr.rxr02,'aic-004',0)
                  LET g_rxr.rxr02=g_rxr_t.rxr02
                  NEXT FIELD rxr02 
               ELSE
                  SELECT COUNT(*) INTO l_n FROM rxr_file
                   WHERE rxr00=g_rxr00
                     AND rxr02=g_rxr.rxr02
                     AND rxracti='Y'
                     AND rxrconf<>'X'
                  IF l_n<>0 THEN 
                     CALL cl_err(g_rxr.rxr02,'art-622',0)
                     LET g_rxr.rxr02=g_rxr_t.rxr02
                     NEXT FIELD rxr02  
                  ELSE
                     IF NOT cl_null(g_rxr.rxr11) AND g_rxr.rxr11>0 AND g_rxr00='1' THEN  #TQC-A20025 ADD
                        SELECT SUM(rur15) INTO l_rur15 FROM rur_file
                         WHERE rur00='1'
                           AND rur01=g_rxr.rxr02
                        IF g_rxr.rxr11 > l_rur15 THEN
                           CALL cl_err('','art-644',0)
                           LET g_rxr.rxr02=g_rxr_t.rxr02
                           NEXT FIELD rxr02
                        ELSE
                           CALL t615_rxr02()
                           IF NOT cl_null(g_errno) THEN
                              CALL cl_err('',g_errno,0)
                              LET g_rxr.rxr02=g_rxr_t.rxr02
                              NEXT FIELD rxr02
                           END IF
                        END IF
          #TQC-AC0124 ---------------------STA
                     ELSE
                        IF g_rxr.rxr00 = '1' THEN        #TQC-AC0223 add
                           SELECT SUM(rur15) INTO g_rxr.rxr11 FROM rur_file
                            WHERE rur00 = '1'
                              AND rur01= g_rxr.rxr02
                           IF cl_null(g_rxr.rxr11) THEN
                              LET g_rxr.rxr11 = 0
                           END IF
                           DISPLAY BY NAME g_rxr.rxr11
                        #TQC-AC0223 add begin-----------------------------   
                        ELSE 
                           SELECT ruq04,SUM(rur15) INTO g_rxr.rxr03,g_rxr.rxr13 FROM ruq_file,rur_file
                            WHERE rur01 = ruq01
                              AND rur00 = '1'
                              AND ruq00 = '1'
                              AND ruq01 = g_rxr.rxr03
                            GROUP BY ruq04
                           IF STATUS = 100 THEN
                              LET g_rxr.rxr13 = 0
                              DISPLAY BY NAME g_rxr.rxr13
                           ELSE
                              IF cl_null(g_rxr.rxr13) THEN
                                 LET g_rxr.rxr13 = 0
                              END IF
                              DISPLAY BY NAME g_rxr.rxr03,g_rxr.rxr13
                              CALL cl_set_comp_entry("rxr03",FALSE) 
                              CALL cl_set_comp_entry("rxr13",TRUE) 
                           END IF   
                        END IF   
                        #TQC-AC0223 add end-------------------------------
          #TQC-AC0124 ---------------------END
                     END IF 
                  END IF
               END IF
            END IF
         END IF   

      AFTER FIELD rxr03
         IF NOT cl_null(g_rxr.rxr03) THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rxr.rxr03 <> g_rxr_t.rxr03) THEN
               SELECT COUNT(*) INTO l_n FROM rxr_file
                WHERE rxr00='1'
                  AND rxr01=g_rxr.rxr03
               IF l_n<>1 THEN
                  CALL cl_err(g_rxr.rxr01,'aic-004',0)
                  LET g_rxr.rxr03=g_rxr_t.rxr03
                  NEXT FIELD rxr03
               ELSE
                  SELECT COUNT(*) INTO l_n FROM rxr_file
                   WHERE rxr00='2'
                     AND rxr03=g_rxr.rxr03
                  IF l_n<>0 THEN
                     CALL cl_err(g_rxr.rxr03,'art-622',0)
                     LET g_rxr.rxr03=g_rxr_t.rxr03
                     NEXT FIELD rxr03
                  ELSE
                     CALL t615_rxr03()
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_rxr.rxr03=g_rxr_t.rxr03
                        NEXT FIELD rxr03
                     END IF
                  END IF
               END IF
            END IF
         END IF 
             

      AFTER FIELD rxr10
         IF NOT cl_null(g_rxr.rxr10) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rxr.rxr10 != g_rxr_t.rxr10) THEN
               CALL t615_rxr10('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxr.rxr10,g_errno,0)
                  LET g_rxr.rxr10 = g_rxr_t.rxr10
                  DISPLAY BY NAME g_rxr.rxr10
                  NEXT FIELD rxr10
               END IF
            END IF
         END IF    

      AFTER FIELD rxr11
         IF NOT cl_null(g_rxr.rxr11) THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rxr.rxr11 != g_rxr_t.rxr11) THEN
               IF g_rxr.rxr11 <= 0 THEN
                  CALL cl_err('','afa-949',0)
                  LET g_rxr.rxr11 = g_rxr_t.rxr11
                  DISPLAY BY NAME g_rxr.rxr11
                  NEXT FIELD rxr11
               ELSE
                  IF NOT cl_null(g_rxr.rxr02) THEN                #TQC-A20025 ADD
                     SELECT SUM(rur15) INTO l_rur15 FROM rur_file
                      WHERE rur01 = g_rxr.rxr02
                        AND rur00 = '1'
                     IF g_rxr.rxr11 > l_rur15 THEN
                        CALL cl_err(g_rxr.rxr11,'art-644',0)
                        LET g_rxr.rxr11 = g_rxr_t.rxr11
                        DISPLAY BY NAME g_rxr.rxr11
                        NEXT FIELD rxr11
                     END IF
                  END IF
               END IF
            END IF  
         END IF

   #  AFTER FIELD rxr12
   #     IF NOT cl_null(g_rxr.rxr12) THEN
   #        IF p_cmd = "a" OR                    
   #           (p_cmd = "u" AND g_rxr.rxr12 != g_rxr_t.rxr12) THEN
   #           IF g_rxr.rxr11-g_rxr.rxr12-g_rxr.rxr13 <0 THEN
   #              CALL cl_err(g_rxr.rxr12,'alm-220',0)
   #              LET g_rxr.rxr12 = g_rxr_t.rxr12
   #              DISPLAY BY NAME g_rxr.rxr12
   #              NEXT FIELD rxr12
   #           END IF
   #        END IF
   #     END IF           
          
      AFTER FIELD rxr13
         IF NOT cl_null(g_rxr.rxr13) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rxr.rxr13 != g_rxr_t.rxr13) THEN
               IF g_rxr.rxr11-g_rxr.rxr12-g_rxr.rxr13 <0 THEN
                  CALL cl_err(g_rxr.rxr13,'alm-220',0)
                  LET g_rxr.rxr13 = g_rxr_t.rxr13
                  DISPLAY BY NAME g_rxr.rxr13
                  NEXT FIELD rxr13
               END IF
            END IF
         END IF   
         
      AFTER FIELD rxr14
         IF NOT cl_null(g_rxr.rxr14) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rxr.rxr14 != g_rxr_t.rxr14) THEN
               SELECT count(*) INTO l_n FROM azf_file
                WHERE azf01=g_rxr.rxr14 AND azf09='7' AND azfacti='Y'
               IF l_n<1 THEN
                  CALL cl_err(g_rxr.rxr14,'1306',0) 
                  LET g_rxr.rxr14 = g_rxr_t.rxr14
                  DISPLAY BY NAME g_rxr.rxr14
                  NEXT FIELD rxr14
               END IF
            END IF
         END IF   
                  
      AFTER INPUT
         LET g_rxr.rxruser = s_get_data_owner("rxr_file") #FUN-C10039
         LET g_rxr.rxrgrup = s_get_data_group("rxr_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_rxr.rxr01) THEN
               NEXT FIELD rxr01
            END IF

      ON ACTION CONTROLO                        
         IF INFIELD(rxr01) THEN
            LET g_rxr.* = g_rxr_t.*
            CALL t615_show()
            NEXT FIELD rxr01
         END IF

     ON ACTION controlp
        CASE
           WHEN INFIELD(rxr01)
              LET g_t1=s_get_doc_no(g_rxr.rxr01)
              IF g_rxr00 = '1' THEN
#                CALL q_smy(FALSE,FALSE,g_t1,'ART','R') RETURNING g_t1 #FUN-A70130--mark--
                 CALL q_oay(FALSE,FALSE,g_t1,'F1','ART') RETURNING g_t1 #FUN-A70130--mod--
              ELSE
#                CALL q_smy(FALSE,FALSE,g_t1,'ART','S') RETURNING g_t1 #FUN-A70130--mark--
                 CALL q_oay(FALSE,FALSE,g_t1,'F2','ART') RETURNING g_t1 #FUN-A70130--mod--
              END IF
              LET g_rxr.rxr01=g_t1
              DISPLAY BY NAME g_rxr.rxr01
              NEXT FIELD rxr01
           WHEN INFIELD(rxr02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ruq01"
              LET g_qryparam.default1 = g_rxr.rxr02
              LET g_qryparam.arg1 = g_rxr00 
              LET g_qryparam.where = "( ruq01 NOT IN (SELECT rxr02 FROM rxr_file
                                                       WHERE rxr00='",g_rxr00,"' AND rxracti='Y'
                                                         AND rxrconf<>'X' ))"
              CALL cl_create_qry() RETURNING g_rxr.rxr02
              DISPLAY BY NAME g_rxr.rxr02
             #CALL t615_rxr02()
              NEXT FIELD rxr02
           WHEN INFIELD(rxr03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rxr01"
              LET g_qryparam.default1 = g_rxr.rxr03
              LET g_qryparam.arg1 = '1' 
              CALL cl_create_qry() RETURNING g_rxr.rxr03
              DISPLAY BY NAME g_rxr.rxr03
              CALL t615_rxr03()
              NEXT FIELD rxr03
           WHEN INFIELD(rxr10)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_rxr.rxr10
              CALL cl_create_qry() RETURNING g_rxr.rxr10
              DISPLAY BY NAME g_rxr.rxr10
              CALL t615_rxr10('d')
              NEXT FIELD rxr10
           WHEN INFIELD(rxr14)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azf01"
              LET g_qryparam.arg1 = 7
              LET g_qryparam.default1 = g_rxr.rxr14
              CALL cl_create_qry() RETURNING g_rxr.rxr14
              DISPLAY BY NAME g_rxr.rxr14 
              NEXT FIELD rxr14             
           OTHERWISE
              EXIT CASE
        END CASE

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
 
 
   END INPUT

END FUNCTION

FUNCTION t615_u()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF cl_null(g_rxr.rxr01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_rxr.* FROM rxr_file
    WHERE rxr01 = g_rxr.rxr01
      AND rxr00 = g_rxr00

   IF g_rxr.rxracti ='N' THEN    
      CALL cl_err(g_rxr.rxr01,'9027',0)
      RETURN
   END IF
   IF g_rxr.rxrconf <>'N' THEN
      CALL cl_err(g_rxr.rxr01,'9022',0)
      RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   
   BEGIN WORK

   OPEN t615_cl USING g_rxr.rxr01
   IF STATUS THEN
      CALL cl_err("OPEN t615_cl:", STATUS, 1)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t615_cl INTO g_rxr.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rxr.rxr01,SQLCA.sqlcode,0)    
       CLOSE t615_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL t615_show()

   WHILE TRUE
      LET g_rxr.rxrmodu = g_user
      LET g_rxr.rxrdate = g_today

      CALL t615_i("u")                            

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rxr.*=g_rxr_t.*
         CALL t615_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF


      UPDATE rxr_file SET rxr_file.* = g_rxr.*
       WHERE rxr00 = g_rxr00
         AND rxr01 = g_rxr.rxr01
         AND rxracti='Y'
         AND rxrconf='N'
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rxr_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE t615_cl
   COMMIT WORK
   CALL t615_show()

END FUNCTION

FUNCTION t615_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          

    IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rxr01",TRUE)
       CALL cl_set_comp_entry("rxr16",FALSE)   #TQC-AC0127 ddd
    END IF
END FUNCTION

FUNCTION t615_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1         

    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rxr01",FALSE)
       CALL cl_set_comp_entry("rxr16",FALSE)   #TQC-AC0127 ddd
    END IF
END FUNCTION
               

#UNCTION t615_upd_log()
#   LET g_rxr.rxrmodu = g_user
#   LET g_rxr.rxrdate = g_today
#   UPDATE rxr_file SET rxrmodu = g_rxr.rxrmodu,rxrdate = g_rxr.rxrdate
#    WHERE rxr01 = g_rxr.rxr01
#      AND rxr00 = g_rxr00

#   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_err3("upd","rxr_file",g_rxr.rxrmodu,g_rxr.rxrdate,SQLCA.sqlcode,"","",1)
#   END IF
#   DISPLAY BY NAME g_rxr.rxrmodu,g_rxr.rxrdate
#   MESSAGE 'UPDATE O.K.'
#ND FUNCTION

FUNCTION t615_r()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF cl_null(g_rxr.rxr01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   SELECT * INTO g_rxr.* FROM rxr_file
    WHERE rxr01=g_rxr.rxr01
      AND rxr00=g_rxr00

   IF g_rxr.rxracti ='N' THEN    
      CALL cl_err(g_rxr.rxr01,'abm-950',0)
      RETURN
   END IF
   IF g_rxr.rxrconf<>'N' THEN
      CALL cl_err('','9022',0)
      RETURN
   END IF
   BEGIN WORK

   OPEN t615_cl USING g_rxr.rxr01
   IF STATUS THEN
      CALL cl_err("OPEN t615_cl:", STATUS, 1)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t615_cl INTO g_rxr.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxr.rxr01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF

   CALL t615_show()

   IF cl_delete() THEN                   
     #UPDATE ruq_file
     #   SET ruq04 = ""
     # WHERE ruq01 = g_rxr.rxr02
     #   AND ruq00 = g_rxr00
     #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     #   CALL cl_err3("upd","ruq_file",g_rxr.rxr02,"",SQLCA.sqlcode,"","ruq",1) 
     #   RETURN
     #END IF
      DELETE FROM rxr_file WHERE rxr01 = g_rxr.rxr01 AND rxr00 = g_rxr00
      CLEAR FORM

#TQC-AC0127   ---begin---
      DELETE FROM rxx_file WHERE rxx01 = g_rxr.rxr01
      DELETE FROM rxy_file WHERE rxy01 = g_rxr.rxr01
      DELETE FROM rxz_file WHERE rxz01 = g_rxr.rxr01
#TQC-AC0127   ---end---

      OPEN t615_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t615_cs
         CLOSE t615_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t615_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t615_cs
         CLOSE t615_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t615_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t615_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL t615_fetch('/')
         END IF
      END IF
   END IF

   CLOSE t615_cl
   COMMIT WORK
END FUNCTION

FUNCTION t615_copy()
DEFINE l_newno     LIKE rxr_file.rxr01,
       l_oldno     LIKE rxr_file.rxr01,
       l_cnt       LIKE type_file.num5,
       l_n         LIKE type_file.num5
   IF s_shut(0) THEN RETURN END IF

   IF cl_null(g_rxr.rxr01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_before_input_done = FALSE
   CALL t615_set_entry('a')

   CALL cl_set_head_visible("","YES")       
   INPUT l_newno FROM rxr01
      AFTER FIELD rxr01
         IF l_newno IS NULL THEN               
            NEXT FIELD rxr01
         ELSE 
            IF g_rxr00 = '1' THEN          	                           
#              CALL s_check_no("art",l_newno,"","R","rxr_file","rxr00,rxr01","") #FUN-A70130 mark
               CALL s_check_no("art",l_newno,"","F1","rxr_file","rxr00,rxr01","") #FUN-A70130 mod
               RETURNING li_result,l_newno     
            ELSE
#              CALL s_check_no("art",l_newno,"","S","rxr_file","rxr00,rxr01","") #FUN-A70130 mark
               CALL s_check_no("art",l_newno,"","F2","rxr_file","rxr00,rxr01","") #FUN-A70130 mod
               RETURNING li_result,l_newno        
            END IF                	                                  
            IF (NOT li_result) THEN                                                 
               NEXT FIELD ruq01                                              
            END IF                                                                                                                  
         END IF           

        ON ACTION controlp
          CASE
             WHEN INFIELD(rxr01)                        
                LET g_t1=s_get_doc_no(l_newno)
                LET g_qryparam.state = 'i' 
                LET g_qryparam.plant = g_plant
                IF g_rxr00='1' THEN
#                  CALL q_smy(FALSE,FALSE,g_t1,'art','R') RETURNING g_t1  #FUN-A70130--mark--
                   CALL q_oay(FALSE,FALSE,g_t1,'F1','ART') RETURNING g_t1 #FUN-A70130--mod--
                ELSE
#                  CALL q_smy(FALSE,FALSE,g_t1,'art','S') RETURNING g_t1  #FUN-A70130--mark--
                   CALL q_oay(FALSE,FALSE,g_t1,'F2','ART') RETURNING g_t1 #FUN-A70130--mod--
                END IF
                LET l_newno=g_t1
                DISPLAY l_newno TO rxr01            
                NEXT FIELD rxr01
              OTHERWISE EXIT CASE
           END CASE  
 
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

   BEGIN WORK
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_rxr.rxr01
      ROLLBACK WORK
      RETURN
   END IF

   DROP TABLE y

   SELECT * FROM rxr_file         
    WHERE rxr01=g_rxr.rxr01
     INTO TEMP y
   IF g_rxr00 = '1'  THEN
#     CALL s_auto_assign_no("art",g_rxr.rxr01,g_today,"R","rxr_file","rxr00,rxr01","","","") #FUN-A70130 mark
      CALL s_auto_assign_no("art",g_rxr.rxr01,g_today,"F1","rxr_file","rxr00,rxr01","","","") #FUN-A70130 mod
      RETURNING li_result,g_rxr.rxr01
   ELSE
#     CALL s_auto_assign_no("art",g_rxr.rxr01,g_today,"S","rxr_file","rxr00,rxr01","","","") #FUN-A70130 mark
      CALL s_auto_assign_no("art",g_rxr.rxr01,g_today,"F2","rxr_file","rxr00,rxr01","","","") #FUN-A70130 mod
      RETURNING li_result,g_rxr.rxr01
   END IF         
   IF (NOT li_result) THEN
       RETURN
   END IF

   UPDATE y
       SET rxr01=l_newno,    
           rxruser=g_user,   
           rxrgrup=g_grup,   
           rxrmodu=NULL,     
           rxrdate=g_today,  
           rxracti='Y',
           rxrconf='N',
           rxroriu=g_user,
           rxrorig=g_group,
           rxr11= 0,
           rxr12= 0,
           rxr13= 0      

   INSERT INTO rxr_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rxr_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK 
   END IF

   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rxr.rxr01
   SELECT rxr_file.* INTO g_rxr.* FROM rxr_file WHERE rxr01 = l_newno
   CALL t615_u()
   SELECT rxr_file.* INTO g_rxr.* FROM rxr_file WHERE rxr01 = l_oldno
   CALL t615_show()

END FUNCTION

FUNCTION t615_x()
 DEFINE l_n  LIKE type_file.num5    

   IF s_shut(0) THEN
      RETURN
   END IF

   IF cl_null(g_rxr.rxr01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   IF g_rxr.rxracti='N' THEN
      SELECT COUNT(*) INTO l_n FROM rxr_file
       WHERE rxr00=g_rxr00
         AND rxr02=g_rxr.rxr02
         AND rxracti='Y' 
         AND rxrconf<>'X'
      IF l_n>0 THEN
         CALL cl_err(g_rxr.rxr02,'art-650',0)
         RETURN
      END IF
   END IF
   BEGIN WORK

   OPEN t615_cl USING g_rxr.rxr01
   IF STATUS THEN
      CALL cl_err("OPEN t615_cl:", STATUS, 1)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t615_cl INTO g_rxr.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxr.rxr01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
   IF g_rxr.rxrconf<>'N' THEN
      CALL cl_err('','9022',0)
      RETURN
   END IF
   LET g_success = 'Y'

   CALL t615_show()

   IF cl_exp(0,0,g_rxr.rxracti) THEN                   
      LET g_chr=g_rxr.rxracti
      IF g_rxr.rxracti='Y' THEN
         LET g_rxr.rxracti='N'
      ELSE
         LET g_rxr.rxracti='Y'
      END IF
      UPDATE rxr_file SET rxracti=g_rxr.rxracti,
                          rxrmodu=g_user,
                          rxrdate=g_today
       WHERE rxr01=g_rxr.rxr01
         AND rxr00=g_rxr00
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rxr_file",g_rxr.rxr01,"",SQLCA.sqlcode,"","",1)  
         LET g_rxr.rxracti=g_chr
      END IF
   END IF

   CLOSE t615_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   SELECT rxracti,rxrmodu,rxrdate
     INTO g_rxr.rxracti,g_rxr.rxrmodu,g_rxr.rxrdate FROM rxr_file
    WHERE rxr01=g_rxr.rxr01
      AND rxr00=g_rxr00
   DISPLAY BY NAME g_rxr.rxracti,g_rxr.rxrmodu,g_rxr.rxrdate
  #TQC-A30002 ADD-----------------------------
   IF g_rxr.rxracti='Y' THEN 
      CALL cl_set_field_pic("","","","","","Y")
   ELSE
      CALL cl_set_field_pic("","","","","","N")  
   END IF
  #TQC-A30002 END-----------------------------
END FUNCTION


FUNCTION t615_y()
DEFINE l_n  LIKE type_file.num5    #add
DEFINE l_gen02 LIKE gen_file.gen02 #TQC-A20025
DEFINE l_rxx04 LIKE rxx_file.rxx04  #add
DEFINE l_rxx00 LIKE rxx_file.rxx00
DEFINE l_amt   LIKE rxr_file.rxr11

    IF cl_null(g_rxr.rxr01) THEN
        CALL cl_err('',-400,0)
        RETURN
   END IF

   IF g_rxr.rxrconf <> 'N' THEN
      CALL cl_err('','8888',0)
      RETURN
   END IF

   IF g_rxr.rxracti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
  
  #IF g_rxr00='1' AND g_rxr.rxrconf='Y' THEN
  #   SELECT COUNT(*) INTO l_n 
  #     FROM rxr_file
  #    WHERE rxr00='2'
  #      AND rxr03=g_rxr.rxr01
  #   IF l_n>0 THEN
  #      CALL cl_err('','art-624',0)
  #      RETURN
  #   END IF   
  #END IF
   
#TQC-A20025 ADD-未付款不可審核-------------------------
   IF g_rxr00='1' THEN
      LET l_rxx00='05'              #押金收取
      LET l_amt  =g_rxr.rxr11
   ELSE
      LET l_rxx00='06'              #押金退還
      LET l_amt  =g_rxr.rxr13
   END IF
   SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file  
    WHERE rxx00 = l_rxx00
      AND rxx01 = g_rxr.rxr01
   IF SQLCA.sqlcode THEN 
      CALL cl_err('sel SUM(RXX04)',STATUS,0)
      LET l_rxx04=NULL 
   END IF  
   IF cl_null(l_rxx04) THEN LET l_rxx04=0 END IF      
   IF l_rxx04 < l_amt THEN
      CALL cl_err('','art-645',0)
      RETURN
   END IF 
 #TQC-A20025 ------------------------------------------

   

   BEGIN WORK
   LET g_success = 'Y'

   OPEN t615_cl USING g_rxr.rxr01
   IF STATUS THEN
      CALL cl_err("OPEN t615_cl:", STATUS, 1)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t615_cl INTO g_rxr.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_rxr_t.* = g_rxr.*
   IF cl_upsw(0,0,g_rxr.rxrconf) THEN 
      LET g_rxr.rxrconf='Y'
      LET g_rxr.rxrconu = g_user
      LET g_rxr.rxrcond = g_today 
 
      UPDATE rxr_file SET rxrconf = g_rxr.rxrconf,
                          rxrconu = g_rxr.rxrconu,
                          rxrcond = g_rxr.rxrcond 
       WHERE rxr01 = g_rxr.rxr01
         AND rxr00 = g_rxr00
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","rxr_file",g_rxr.rxr01,"",STATUS,"","",1)
         LET g_rxr.rxrconf=g_rxr_t.rxrconf
         LET g_rxr.rxrconu=g_rxr_t.rxrconu
         LET g_rxr.rxrcond=g_rxr_t.rxrcond 
         LET g_success = 'N'
         ROLLBACK WORK #TQC-AC0127
         RETURN
      ELSE
         IF SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","rxr_file",g_rxr.rxr01,"","9050","","",1)
            LET g_rxr.rxrconf=g_rxr_t.rxrconf
            LET g_rxr.rxrconu=g_rxr_t.rxrconu
            LET g_rxr.rxrcond=g_rxr_t.rxrcond 
            LET g_success = 'N'
            ROLLBACK WORK #TQC-AC0127
            RETURN
         END IF
      END IF

      IF NOT cl_null(g_rxr.rxr02)  THEN  #TQC-AC0127 
         UPDATE ruq_file
            SET ruq04 = g_rxr.rxr01
          WHERE ruq01 = g_rxr.rxr02
            AND ruq00 = g_rxr00
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("upd","ruq_file",g_rxr.rxr02,"",SQLCA.sqlcode,"","ruq",1)
             LET g_success = 'N'   #TQC-AC0127
             ROLLBACK WORK         #TQC-AC0127 
             RETURN
          END IF
      END IF    #TQC-AC0127    

      IF g_rxr00 = '2' THEN
         UPDATE rxr_file SET rxr12 = rxr12+g_rxr.rxr13
          WHERE rxr00='1'
            AND rxr01=g_rxr.rxr03
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rxr_file",g_rxr.rxr03,"",STATUS,"","",1)
            LET g_rxr.rxrconf=g_rxr_t.rxrconf
            LET g_rxr.rxrconu=g_rxr_t.rxrconu
            LET g_rxr.rxrcond=g_rxr_t.rxrcond
            LET g_success = 'N'
            ROLLBACK WORK #TQC-AC0127
            RETURN
         END IF
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      SELECT gen02 INTO l_gen02 FROM gen_file
       WHERE gen01 = g_rxr.rxrconu
         AND genacti='Y'
      IF cl_null(l_gen02) THEN LET l_gen02=' ' END IF 
      DISPLAY BY NAME g_rxr.rxrconf,g_rxr.rxrconu,g_rxr.rxrcond
                
      IF g_rxr.rxrconf='Y' THEN
        CALL cl_set_field_pic("Y","","","","","")
      ELSE
        CALL cl_set_field_pic("N","","","","","")
      END IF
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t615_n()
DEFINE l_n  LIKE type_file.num5    #add
DEFINE l_gen02 LIKE gen_file.gen02 #TQC-A20025
DEFINE l_rxx04 LIKE rxx_file.rxx04  #add
DEFINE l_rxx00 LIKE rxx_file.rxx00
DEFINE l_amt   LIKE rxr_file.rxr11

    IF cl_null(g_rxr.rxr01) THEN
        CALL cl_err('',-400,0)
        RETURN
   END IF

   IF g_rxr.rxracti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF

   IF g_rxr.rxrconf<>'Y' THEN
      CALL cl_err('','9025',0)
      RETURN
   END IF  

#TQC-AC0127   ---begin---
   IF NOT cl_null(g_rxr.rxr16) THEN 
      CALL cl_err('','axr105',0)
      RETURN
   END IF
#TQC-AC0127   ---end---
 
   IF g_rxr00='1' AND g_rxr.rxrconf='Y' THEN
      SELECT COUNT(*) INTO l_n 
        FROM rxr_file
       WHERE rxr00='2'
         AND rxr03=g_rxr.rxr01
      IF l_n>0 THEN
         CALL cl_err('','art-624',0)
         RETURN
      END IF   
   END IF
   
##TQC-A20025 ADD-未付款不可審核-------------------------
#  IF g_rxr00='1' THEN
#     LET l_rxx00='05'              #押金收取
#     LET l_amt  =g_rxr.rxr11
#  ELSE
#     LET l_rxx00='06'              #押金退還
#     LET l_amt  =g_rxr.rxr13
#  END IF
#  SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file  
#   WHERE rxx00 = l_rxx00
#     AND rxr01 = g_rxr.rxr01
#  IF SQLCA.sqlcode THEN 
#     CALL cl_err('sel SUM(RXX04)',STATUS,0)
#     LET l_rxx04=NULL 
#  END IF  
#  IF cl_null(l_rxx04) THEN LET l_rxx04=0 END IF      
#  IF l_rxx04 < l_amt THEN
#     CALL cl_err('','art-645',0)
#     RETURN
#  END IF 
##TQC-A20025 ------------------------------------------
   BEGIN WORK
   LET g_success = 'Y'

   OPEN t615_cl USING g_rxr.rxr01
   IF STATUS THEN
      CALL cl_err("OPEN t615_cl:", STATUS, 1)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t615_cl INTO g_rxr.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_rxr_t.* = g_rxr.*
   IF cl_upsw(0,0,g_rxr.rxrconf) THEN 
      LET g_rxr.rxrconf = 'N'
      LET g_rxr.rxrconu = ''
      LET g_rxr.rxrcond = ''
      UPDATE rxr_file SET rxrconf = g_rxr.rxrconf,
                          rxrconu = g_rxr.rxrconu,
                          rxrcond = g_rxr.rxrcond 
       WHERE rxr01 = g_rxr.rxr01
         AND rxr00 = g_rxr00
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","rxr_file",g_rxr.rxr01,"",STATUS,"","",1)
         LET g_rxr.rxrconf=g_rxr_t.rxrconf
         LET g_rxr.rxrconu=g_rxr_t.rxrconu
         LET g_rxr.rxrcond=g_rxr_t.rxrcond 
         LET g_success = 'N'
         RETURN
      ELSE
         IF SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","rxr_file",g_rxr.rxr01,"","9050","","",1)
            LET g_rxr.rxrconf=g_rxr_t.rxrconf
            LET g_rxr.rxrconu=g_rxr_t.rxrconu
            LET g_rxr.rxrcond=g_rxr_t.rxrcond 
            LET g_success = 'N'
            RETURN
         END IF
      END IF

      IF NOT cl_null(g_rxr.rxr02) THEN   #TQC-AC0127  add 
         UPDATE ruq_file
            SET ruq04 = ""
          WHERE ruq01 = g_rxr.rxr02
            AND ruq00 = g_rxr00
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","ruq_file",g_rxr.rxr02,"",SQLCA.sqlcode,"","ruq",1) 
            RETURN
         END IF
      END IF    #TQC-AC0127  add

      IF g_rxr00 = '2' THEN
         UPDATE rxr_file SET rxr12 = rxr12-g_rxr.rxr13
          WHERE rxr00='1'
            AND rxr01=g_rxr.rxr03
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rxr_file",g_rxr.rxr03,"",STATUS,"","",1)
            LET g_rxr.rxrconf=g_rxr_t.rxrconf
            LET g_rxr.rxrconu=g_rxr_t.rxrconu
            LET g_rxr.rxrcond=g_rxr_t.rxrcond
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      SELECT gen02 INTO l_gen02 FROM gen_file
       WHERE gen01 = g_rxr.rxrconu
         AND genacti='Y'
      IF cl_null(l_gen02) THEN LET l_gen02=' ' END IF 
      DISPLAY BY NAME g_rxr.rxrconf,g_rxr.rxrconu,g_rxr.rxrcond
      IF g_rxr.rxrconf='Y' THEN
        CALL cl_set_field_pic("Y","","","","","")
      ELSE
        CALL cl_set_field_pic("N","","","","","")
      END IF
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t615_v() #
DEFINE l_n LIKE type_file.num5

   IF cl_null(g_rxr.rxr01) THEN 
        CALL cl_err('',-400,0) 
        RETURN 
   END IF
   
   IF g_rxr.rxrconf = 'Y' THEN
#      CALL cl_err('','apy-705',0)     #CHI-B40058
      CALL cl_err('','apc-122',0)      #CHI-B40058
      RETURN
   END IF
   
   IF g_rxr.rxracti='N' THEN
      CALL cl_err('','atm-364',0)
      RETURN
   END IF

   IF g_rxr.rxrconf='X' THEN
      SELECT COUNT(*) INTO l_n FROM rxr_file
       WHERE rxr00=g_rxr00
         AND rxr02=g_rxr.rxr02
         AND rxracti='Y' 
         AND rxrconf<>'X'
      IF l_n>0 THEN
         CALL cl_err(g_rxr.rxr02,'art-650',0)
         RETURN
      END IF
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'

   OPEN t615_cl USING g_rxr.rxr01
   IF STATUS THEN
      CALL cl_err("OPEN t615_cl:", STATUS, 1)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t615_cl INTO g_rxr.*    
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)      
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_rxr_t.* = g_rxr.*      
   IF cl_void(0,0,g_rxr.rxrconf) THEN
      IF g_rxr.rxrconf='X' THEN
         LET g_rxr.rxrconf='N'
         LET g_rxr.rxrconu = ''
         LET g_rxr.rxrcond = ''
      ELSE
         LET g_rxr.rxrconf='X'
         LET g_rxr.rxrconu = g_user
         LET g_rxr.rxrcond = g_today
      END IF 
      LET g_rxr.rxrmodu = g_user
      LET g_rxr.rxrdate = g_today
      UPDATE rxr_file SET rxrconf = g_rxr.rxrconf,
                          rxrconu = g_rxr.rxrconu,
                          rxrcond = g_rxr.rxrcond,
                          rxrmodu = g_rxr.rxrmodu,
                          rxrdate = g_rxr.rxrdate
       WHERE rxr01 = g_rxr.rxr01 
         AND rxr00 = g_rxr00
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","rxr_file",g_rxr.rxr01,"",STATUS,"","",1) 
         LET g_rxr.rxrconf=g_rxr_t.rxrconf
         LET g_rxr.rxrconu=g_rxr_t.rxrconu
         LET g_rxr.rxrcond=g_rxr_t.rxrcond
         LET g_success = 'N'
      ELSE
         IF SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","rxr_file",g_rxr.rxr01,"","9050","","",1) 
            LET g_rxr.rxrconf=g_rxr_t.rxrconf
            LET g_rxr.rxrconu=g_rxr_t.rxrconu
            LET g_rxr.rxrcond=g_rxr_t.rxrcond
            LET g_success = 'N'            
         END IF
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      DISPLAY BY NAME g_rxr.rxrconf,g_rxr.rxrconu,g_rxr.rxrcond,
                      g_rxr.rxruser,g_rxr.rxrdate
      IF g_rxr.rxrconf='X' THEN
        CALL cl_set_field_pic("","","","",'Y',"")
      ELSE
        CALL cl_set_field_pic("","","","",'N',"")
      END IF
   ELSE
      ROLLBACK WORK
   END IF   
END FUNCTION

FUNCTION t615_rxr04(p_cmd,p_type)
DEFINE p_cmd LIKE type_file.chr1
DEFINE p_type LIKE rxr_file.rxr03
DEFINE l_oeaconf LIKE oea_file.oeaconf
DEFINE l_occ02 LIKE occ_file.occ02

    LET g_errno=''
    IF p_type='1' THEN
    SELECT oea03,oea85,oea87,oea88,oea89,oea90,oea91,oeaconf
      INTO g_rxr.rxr08,g_rxr.rxr09,g_rxr.rxr10,g_rxr.rxr11,
           g_rxr.rxr12,g_rxr.rxr13,g_rxr.rxr14,l_oeaconf
      FROM oea_file
     WHERE oea01 = g_rxr.rxr04
    CASE WHEN SQLCA.sqlcode=100 LET g_errno=''
         WHEN l_oeaconf<>'Y'    LET g_errno='9029'
         OTHERWISE
           LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       SELECT occ02 INTO l_occ02 FROM occ_file
        WHERE occ01 = g_rxr.rxr08
          AND occacti = 'Y'
       DISPLAY BY NAME g_rxr.rxr08,g_rxr.rxr09,g_rxr.rxr10,g_rxr.rxr11,
                       g_rxr.rxr12,g_rxr.rxr13,g_rxr.rxr14
       DISPLAY l_occ02 TO rxr08_desc
    END IF     
    END IF
END FUNCTION

FUNCTION t615_rxr10(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_genacti LIKE gen_file.genacti
DEFINE l_rxr10_desc LIKE gen_file.gen02

   LET g_errno=''
   SELECT gen02,genacti 
     INTO l_rxr10_desc,l_genacti
     FROM gen_file
    WHERE gen01 = g_rxr.rxr10
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='aoo-017'
        WHEN l_genacti='N'     LET g_errno='9028'
        OTHERWISE
           LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_rxr10_desc TO rxr10_desc
    END IF
END FUNCTION



FUNCTION t615_pay_chk()   
   SELECT * INTO g_rxr.* 
    FROM rxr_file 
    WHERE rxr00 = g_rxr00 
    AND rxr01 =g_rxr.rxr01
   IF s_shut(0) THEN RETURN END IF                                                                                                  
   IF g_rxr.rxr01 IS NULL THEN RETURN END IF                                                                                        
   IF g_rxr.rxrconf='Y' THEN CALL cl_err('',9023,0) RETURN END IF                                                                   
   IF g_rxr.rxrconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF                                                                 
END FUNCTION


FUNCTION t615_reback_chk()
   SELECT * INTO g_rxr.* 
    FROM rxr_file 
    WHERE rxr00 = g_rxr00 
    AND rxr01 =g_rxr.rxr01                                                                                                                                                                                                        
   IF g_rxr.rxr01 IS NULL THEN RETURN END IF                                                                                  
   IF g_rxr.rxrconf = 'Y' THEN CALL cl_err('','art-334',0) RETURN END IF                                                                                                                                                                                                                                               
   IF g_rxr.rxrconf = 'X' THEN CALL cl_err('','9024',0) RETURN  END IF                                                         
                            
END FUNCTION 
#TQC-A10085 ADD START-------------------------------------------------------------
FUNCTION t615_rxr02() 
DEFINE l_ruqacti   LIKE ruq_file.ruqacti
DEFINE l_ruqconf   LIKE ruq_file.ruqconf

    LET g_errno = ""
    
    SELECT ruq05,ruq06,ruq07,ruq08,ruq09,ruqacti,ruqconf 
      INTO g_rxr.rxr10,g_rxr.rxr06,g_rxr.rxr07,
           g_rxr.rxr08,g_rxr.rxr09,l_ruqacti,l_ruqconf
      FROM ruq_file
     WHERE ruq00 = g_rxr00
      AND  ruq01 = g_rxr.rxr02  
    CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'mfg9329'
                            RETURN
         WHEN l_ruqacti='N' LET g_errno = 'aap-084'
                            RETURN
         WHEN l_ruqconf<>'Y' LET g_errno = 'aap-084'
                            RETURN
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                            DISPLAY BY NAME g_rxr.rxr10,g_rxr.rxr06,g_rxr.rxr07,g_rxr.rxr08,g_rxr.rxr09
    END CASE
END FUNCTION

FUNCTION t615_rxr03()   
DEFINE l_rxracti   LIKE rxr_file.rxracti
DEFINE l_rxrconf   LIKE rxr_file.rxrconf 
    
    SELECT rxr11,rxr12,rxracti,rxrconf
      INTO g_rxr.rxr11,g_rxr.rxr12,l_rxracti,l_rxrconf 
      FROM rxr_file
     WHERE rxr00 = '1'
       AND rxr01 = g_rxr.rxr03  
    CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'mfg9329'
                            RETURN
         WHEN l_rxracti='N' LET g_errno = 'aap-084'
                            RETURN
         WHEN l_rxrconf<>'Y' LET g_errno = 'aap-084'
                            RETURN                            
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                            DISPLAY BY NAME g_rxr.rxr11,g_rxr.rxr12
    END CASE
END FUNCTION
#TQC-A10085 ADD END -------------------------------------------------------------
#TQC-A30056 PASS NO

