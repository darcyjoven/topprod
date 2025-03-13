# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi402.4gl
# Descriptions...: 訂貨會手冊維護作業
# Date & Author..: 10/5/12 By ShaoYong
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.FUN-B20011 11/02/10 By huangtao database ds1改成darabase ds
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改	
# Modify.........: No.FUN-B90105 11/10/08 By linling 制訂訂貨會內容	
# Modify.........: No.FUN-C20006 12/02/08 By linling 程序規範修改
# Modify.........: No:TQC-C20117 12/02/10 By lixiang 服飾BUG修改
# Modify.........: No:TQC-C20134 12/02/13 By xjll    使用訂貨會編號時資料有效碼為Y才可以使用
# Modify.........: No:TQC-C20224 12/02/15 By lixiang BUG修改
# Modify.........: No:FUN-C20101 12/03/01 By qiaozy 使日期與axmi401相一致
# Modify.........: No:TQC-C20418 12/03/03 By huangrh 審核時候檢查BUG修改
# Modify.........: No:TQC-C40197 12/04/28 By qiaozy 单身页码栏位，光标移到新的一行，但没有新增任何资料的话，无法移回上一行
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C60021 12/06/11 By qiaozy 快捷键设置
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

#DATABASE ds1                   #FUN-B20011 mark
DATABASE ds                     #FUN-B20011 add

GLOBALS "../../config/top.global"


DEFINE g_odm      RECORD LIKE odm_file.*
DEFINE g_odm_t    RECORD LIKE odm_file.*
DEFINE g_odm01_t   LIKE  odm_file.odm01
DEFINE g_odn       DYNAMIC ARRAY OF RECORD
                   odn03 LIKE odn_file.odn03,
                   odn04 LIKE odn_file.odn04,
                   odn05 LIKE odn_file.odn05,
                   ima02 LIKE ima_file.ima02,
                   ima31 LIKE ima_file.ima31,
                   odn06 LIKE odn_file.odn06,
                   odn07 LIKE odn_file.odn07,
                   odn08 LIKE odn_file.odn08,
                   odn09 LIKE odn_file.odn09
                   END RECORD
DEFINE g_odn_t     RECORD
 #                  odn01 LIKE odn_file.odn01,                                   
 #                  odn02 LIKE odn_file.odn02,                                   
                   odn03 LIKE odn_file.odn03,                                   
                   odn04 LIKE odn_file.odn04,                                   
                   odn05 LIKE odn_file.odn05,
                   ima02 LIKE ima_file.ima02,
                   ima31 LIKE ima_file.ima31,
                   odn06 LIKE odn_file.odn06,
                   odn07 LIKE odn_file.odn07, 
                   odn08 LIKE odn_file.odn08,
                   odn09 LIKE odn_file.odn09
                   END RECORD   
                
DEFINE g_sql       STRING
DEFINE g_wc        STRING
DEFINE g_wc2       STRING
DEFINE g_rec_b     LIKE type_file.num5,
       l_ac        LIKE type_file.num5


DEFINE g_forupd_sql STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr       LIKE type_file.chr1
DEFINE g_cnt       LIKE type_file.num10
DEFINE g_i         LIKE type_file.num5

DEFINE g_msg       LIKE ze_file.ze03 
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_row_count    LIKE type_file.num10  
DEFINE g_jump         LIKE type_file.num10 
DEFINE mi_no_ask      LIKE type_file.num5
DEFINE g_argv1        LIKE odm_file.odm01

MAIN

    DEFINE   p_row,p_col   LIKE type_file.num5
#   OPTIONS
#      FORM LINE     FIRST + 2, 
#      MESSAGE LINE  LAST,
#      PROMPT LINE   LAST, 
#      INPUT NO WRAP             
#   DEFER INTERRUPT                            

   IF(NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log        
   IF (NOT cl_setup("AXM")) THEN             
      EXIT PROGRAM                           
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time         
   INITIALIZE g_odm.* TO NULL
   LET g_forupd_sql = "SELECT * FROM odm_file WHERE odm01=?  AND odm02=? AND odm03=? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i402_cl  CURSOR FROM g_forupd_sql
   LET p_row = 5 LET p_col = 10

   OPEN WINDOW i402_w AT p_row,p_col WITH FORM "axm/42f/axmi402"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()              

   CALL cl_set_comp_att_text("Time Bucket",' ')  #TQC-C20134 add
   CALL cl_set_comp_visible("odm08",FALSE)       #TQC-C20134 add
   CALL cl_set_comp_entry("odm04,odm05,odm06,odm07",FALSE) #FUN-C20101-----ADD-----
   CALL cl_set_comp_required("odn03",TRUE) #TQC-C40197--ADD----
   LET g_action_choice =""
   CALL i402_menu()
   CLOSE WINDOW i402_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time         
END MAIN 

FUNCTION i402_menu()
  WHILE TRUE
      CALL i402_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i402_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i402_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i402_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i402_u()
            END IF

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i402_x()
            END IF

         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i402_copy()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i402_b()
            ELSE
               LET g_action_choice = NULL
            END IF

       #TQC-C20134--add--begin--
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i402_confirm()
            END IF

        WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i402_undo_confirm()
            END IF
       #TQC-C20134-add--end--

       #  WHEN "output"
        #    IF cl_chk_act_auth() THEN
         #      CALL i402_out()
          #  END IF

         WHEN "help"
            CALL cl_show_help()
         
         WHEN "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "related_document" 
            IF cl_chk_act_auth() THEN
               IF g_odm.odm01 IS NOT NULL THEN
               LET g_doc.column1 = "odm01"
               LET g_doc.value1 = g_odm.odm01
              CALL cl_doc()
               END IF
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i402_bp(p_ud)
   DEFINE   p_ud            LIKE type_file.chr1     
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_odn TO s_odn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
#---chenmoyan
         LET g_doc.column1 = "ima01"
         LET g_doc.value1 = g_odn[l_ac].odn05
         CALL cl_get_fld_doc("ima04")
#---chenmoyan
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

      ON ACTION first
         CALL i402_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   

      ON ACTION previous
         CALL i402_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION jump
         CALL i402_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL i402_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   

      ON ACTION last
         CALL i402_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

    #TQC-C20134-add--begin--
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
    #TQC-C20134-add--end--

     # ON ACTION output
       #  LET g_action_choice="output"
        # EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         LET g_action_choice="locale"
         EXIT DISPLAY
      
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


      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032

      ON ACTION related_document                #No:FUN-6A0162 
         LET g_action_choice="related_document"          
         EXIT DISPLAY

       

   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)  
END FUNCTION                                   
                                                                        

FUNCTION i402_cs()
    DEFINE cl_qbe_sn LIKE gbm_file.gbm01 
   CLEAR FORM
  
   CALL g_odn.clear()                                                                 IF NOT  cl_null(g_argv1) THEN                                              
      LET g_wc = " odm01 = '",g_argv1,"'"                                       
   ELSE                                                                         
     CALL cl_set_head_visible("","YES") 
   
   INITIALIZE g_odm.*  TO NULL 
   CONSTRUCT BY NAME g_wc ON 
      odm01,odm02,odm03,odm04,odm05,odm06,odm07,odmacti,odmconf,odm08 #TQC-C20134 add odmacti,odmconf
#      odmuser,odmgrup,odmacti,odmmodu,odmdate
    
   BEFORE CONSTRUCT 
      CALL cl_qbe_init()
      
      ON ACTION controlp
         IF INFIELD (odm01) THEN 
            CALL cl_init_qry_var()
            LET g_qryparam.form="q_odm01"
            LET g_qryparam.state="c"
                  
            LET g_qryparam.default1=g_odm.odm01
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO odm01
            NEXT FIELD odm01
         END IF

#       AFTER FIELD odm01
#         IF NOT cl_null(g_odm.odm01)   THEN 
#             CALL i402_odl02()
#          END IF
     

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
           CALL cl_qbe_list() RETURNING cl_qbe_sn                                 
         CALL cl_qbe_display_condition(cl_qbe_sn)
    #   ON ACTION qbe_save                           
     #     CALL cl_qbe_save()
    END CONSTRUCT

     IF INT_FLAG THEN                                                          
         RETURN                                                                 
      END IF                                                                    
    END IF       
     IF g_priv2='4' THEN                              
      LET g_wc = g_wc clipped," AND reduser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN                               
      LET g_wc = g_wc clipped," AND redgrup MATCHES '",g_grup CLIPPED,"*'"
   END IF
   IF g_priv3 MATCHES "[5678]" THEN                  
      LET g_wc = g_wc clipped," AND redgrup IN ",cl_chk_tgrup_list()
   END IF
   
  # LET g_sql="select odm01 from odm_file ",
   #          " where ",g_wc CLIPPED," order by odm01"
  # PREPARE i402_prepare FROM  g_sql
  # DECLARE i402_cus SCROLL CURSOR WITH HOLD FOR i402_prepare
   
  # LET g_sql="select count(*) from odm_file where ",g_wc CLIPPED
  # PREPARE i402_precount FROM  g_sql
  # DECLARE i402_count CURSOR  FOR i402_precount
  
   IF NOT cl_null(g_argv1) THEN                                                 
      LET g_wc2 = " 1=1"                                                        
   ELSE   
      CONSTRUCT g_wc2 ON odn03,odn04,odn05,odn06,odn07,odn08,odn09
               FROM s_odn[1].odn03,s_odn[1].odn04,s_odn[1].odn05,s_odn[1].odn06,
                    s_odn[1].odn07,s_odn[1].odn08,s_odn[1].odn09

      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(cl_qbe_sn)
         
      ON ACTION controlp
         IF INFIELD (odn05) THEN 
            CALL cl_init_qry_var()
            LET g_qryparam.form="q_odn05_1"
            LET g_qryparam.state="c"
                  
            LET g_qryparam.default1=g_odn[1].odn05
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO odn05
            NEXT FIELD odn05
         END IF

         ON IDLE g_idle_seconds                                                    
            CALL cl_on_idle()                                                      
            CONTINUE CONSTRUCT 
  
         ON ACTION about                                                 
            CALL cl_about()  

         ON ACTION controlg                                                        
            LET g_action_choice="controlg"                                         
         
         ON ACTION help                                                            
            LET g_action_choice="help"                                             
       
         ON ACTION qbe_save                                                      
            CALL cl_qbe_save() 
     # ON ACTION qbe_select
      #   CALL cl_qbe_list() RETURNING cl_qbe_sn
       #  CALL cl_qbe_display_condition(cl_qbe_sn)
      END CONSTRUCT

      IF INT_FLAG THEN
         RETURN
      END IF
   END IF

   IF g_wc2=" 1=1" THEN
      LET g_sql="SELECT odm01,odm02,odm03 FROM odm_file",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY odm01"
   ELSE
      LET g_sql="SELECT odm01,odm02,odm03 ",
                " FROM odm_file,odn_file WHERE odm01=odn01 AND odm02 = odn02 AND ",
                g_wc CLIPPED, " AND ", g_wc2 CLIPPED," ORDER BY odm01"
   END IF
   
   PREPARE i402_prepare FROM  g_sql                                             
   DECLARE i402_cus SCROLL CURSOR WITH HOLD FOR i402_prepare 

   IF g_wc2 = " 1=1" THEN                                      
      LET g_sql="SELECT COUNT(*) FROM odm_file WHERE ",g_wc CLIPPED             
   ELSE                                                                         
      LET g_sql="SELECT COUNT(DISTINCT odm01) FROM odm_file,odn_file WHERE ",   
                " odn_file.odn01=odm01 AND odm02 = odn02 AND ",
                g_wc CLIPPED, " AND ", g_wc2 CLIPPED           
   END IF                            
      
   PREPARE i402_precount FROM  g_sql                                           
   DECLARE i402_count CURSOR  FOR i402_precount  
END FUNCTION

FUNCTION i402_q()
   LET g_row_count=0
   LET g_curs_index=0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
  # INITIALIZE g_odm.* TO NULL

   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL  g_odn.clear()
   DISPLAY ' ' TO FORMONLY.cnt

   CALL i402_cs()

   IF INT_FLAG THEN 
      LET INT_FLAG=0
      CLEAR FORM
      RETURN 
   END IF

   OPEN i402_count                                                                  
   FETCH i402_count INTO g_row_count                                         
      DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN i402_cus                                                                
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err(g_odm.odm01,SQLCA.sqlcode,0)                                  
      INITIALIZE g_odm.* TO NULL
   ELSE 
       CALL i402_fetch('F') 
   END IF
   
END FUNCTION

FUNCTION i402_fetch(p_flodm)
   DEFINE p_flodm VARCHAR(1)
   
   CASE p_flodm
      WHEN 'N' FETCH NEXT  i402_cus INTO g_odm.odm01,g_odm.odm02,g_odm.odm03
      WHEN 'F' FETCH FIRST i402_cus INTO g_odm.odm01,g_odm.odm02,g_odm.odm03
      WHEN 'L' FETCH LAST  i402_cus INTO g_odm.odm01,g_odm.odm02,g_odm.odm03
      WHEN 'P' FETCH PREVIOUS i402_cus INTO g_odm.odm01,g_odm.odm02,g_odm.odm03
      WHEN '/'
         IF(NOT mi_no_ask) THEN 
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG=0
            
            PROMPT g_msg CLIPPED,":" FOR g_jump
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
               LET INT_FLAG=0
               EXIT CASE
            END IF
         END IF
          
         FETCH ABSOLUTE g_jump i402_cus INTO g_odm.odm01,g_odm.odm02,g_odm.odm03
         LET mi_no_ask=FALSE
    END CASE
    
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_odm.odm01,SQLCA.sqlcode,0)
       INITIALIZE g_odm.* TO NULL
       RETURN
    ELSE
       CASE p_flodm
          WHEN 'F' LET g_curs_index=1
          WHEN 'N' LET g_curs_index=g_curs_index+1
          WHEN 'P' LET g_curs_index=g_curs_index-1 
          WHEN 'L' LET g_curs_index=g_row_count
          WHEN '/' LET g_curs_index=g_jump
       END CASE
       CALL cl_navigator_setting(g_curs_index,g_row_count)
       DISPLAY g_curs_index TO FORMONLY.idx
     END IF

     SELECT * INTO g_odm.* FROM odm_file WHERE odm01=g_odm.odm01
 					   AND odm02=g_odm.odm02
					   AND odm03=g_odm.odm03 
     IF SQLCA.sqlcode THEN                   
	CALL cl_err3("sel","odm_file",g_odm.odm01,"",SQLCA.sqlcode,"","",0)
     ELSE
#	LET g_data_owner=g_odm.odmuser      
#	LET g_data_group=g_odm.odmgrup
#        LET g_odm.odmuser = g_user
#        LET g_odm.odmgrup = g_grup
#        LET g_odm.odmmodu = g_user
#        LET g_odm.odmdate = g_today
#        LET g_odm.odmorig  = g_grup
#        LET g_odm.odmoriu  = g_user
	CALL i402_show()                    
     END IF
END FUNCTION

FUNCTION i402_show()
   LET g_odm_t.*=g_odm.*
   DISPLAY  g_odm.odm01,g_odm.odm02,g_odm.odm03,g_odm.odm04,g_odm.odm05,
            g_odm.odm06,g_odm.odm07,g_odm.odmacti,g_odm.odmconf,g_odm.odm08  #TQC-C20134 add odmacti,odmconf
        TO  odm01,odm02,odm03,odm04,odm05,odm06,odm07,odmacti,odmconf,odm08  #TQC-C20134 add odmacti,odmconf
   CALL i402_odl02()
   CALL cl_show_fld_cont()

   CALL i402_b_fill(g_wc2)
#   CALL i402_ima02()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i402_odl02()
   DEFINE l_odl02 LIKE odl_file.odl02
   SELECT odl02 INTO l_odl02 FROM odl_file
#         WHERE odl01 = g_odm.odm01     #TQC-C20134--mark
          WHERE odl01 = g_odm.odm01 AND odlacti= 'Y'  #TQC-C20134--add
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('l_odl02',SQLCA.sqlcode,0)
#   END IF
   
   DISPLAY l_odl02 TO FORMONLY.odl02
END FUNCTION

FUNCTION i402_ima02()
#--chenmoyan
#  DEFINE l_ima04 LIKE ima_file.ima04
#  
#  LET g_doc.column1 = "ima01"
#  LET g_doc.value1 = g_odn[g_cnt].odn05
#--chenmoyan
#   CALL  cl_fld_doc("ima04")

#--chenmoyan
  SELECT ima02,ima31 INTO g_odn[g_cnt].ima02,g_odn[g_cnt].ima31 FROM ima_file
         WHERE ima01 = g_odn[g_cnt].odn05 
#  IF SQLCA.sqlcode THEN
#     CALL cl_err('l_ima02',SQLCA.sqlcode,0)
#  END IF
 
  DISPLAY g_odn[g_cnt].ima02,g_odn[g_cnt].ima31 TO ima02,ima31
#  DISPLAY l_ima04 TO FORMONLY.ima04
#  CALL cl_get_fld_doc("ima04")
#--chenmoyan
#   DISPLAY BY NAME ima04
END FUNCTION
#FUNCTION i402_ima02()
#   DEFINE l_ima02 LIKE ima_file.ima02
#   SELECT ima02 INTO l_ima02 FROM ima_file
#          WHERE ima01 = g_odn[l_ac].odn05
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('l_ima02',SQLCA.sqlcode,1)
#   END IF
#   DISPLAY BY NAME l_ima02 
#END FUNCTION

FUNCTION i402_b_fill(p_wc2)
   DEFINE p_wc2 STRING
   LET l_ac = ARR_CURR()
   LET l_ac = 1         
   
    

   LET g_sql="SELECT odn03,odn04,odn05,'','',odn06,odn07,odn08,odn09 FROM odn_file ",
             " WHERE odn_file.odn01='",g_odm.odm01,"' AND ",
             " odn_file.odn02 = '",g_odm.odm02,"' "
             

   IF NOT cl_null(p_wc2) THEN 
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY odn03"
   DISPLAY g_sql

   
   PREPARE i402_pb FROM g_sql                                                   
   DECLARE odn_cs CURSOR FOR i402_pb 
   
   CALL g_odn.clear()                                                           
   LET g_cnt = 1                                                                
                                                                                
   FOREACH odn_cs INTO g_odn[g_cnt].*                          
      IF SQLCA.sqlcode THEN                                                    
         CALL cl_err('foreach:',SQLCA.sqlcode,1)                               
         EXIT FOREACH
      END IF
      DISPLAY g_odn[g_cnt].odn03
      
      CALL i402_ima02()
      LET g_cnt = g_cnt + 1                                                    
          IF g_cnt > g_max_rec THEN                                                
             CALL cl_err( '', 9035, 0 )                                            
             EXIT FOREACH                                                          
          END IF
   END FOREACH
    
   CALL g_odn.deleteElement(g_cnt)                                              
                                                                                
   LET g_rec_b = g_cnt - 1                                                          
   DISPLAY g_rec_b TO FORMONLY.cn2                                              
   LET g_cnt = 0 
END FUNCTION 

FUNCTION i402_a()
   MESSAGE ""
   CLEAR FORM                                     
   INITIALIZE g_odm.* LIKE odm_file.*
   LET g_odm01_t = NULL
   LET g_wc = NULL
   CALL cl_opmsg('a')
   
   WHILE TRUE
      LET g_odm.odmacti = 'Y'          
      LET g_odm.odmuser = g_user
      LET g_odm.odmgrup = g_grup
#      LET g_odm.odmmodu = g_user
      LET g_odm.odmmodu = g_user #FUN-B90105 ADD
      LET g_odm.odmdate = g_today
      LET g_odm.odmorig  = g_grup
      LET g_odm.odmoriu  = g_user
      LET g_odm.odmconf  = 'N'    #TQC-C20134 add     
      LET g_odm.odm08    = '1'    #TQC-C20134 add
 
      CALL i402_i("a")                                
      IF INT_FLAG THEN                          
 	 INITIALIZE g_odm.* TO NULL
         CALL g_odn.clear()
 	 LET INT_FLAG = 0
 	 CALL cl_err('',9001,0)
 	 CLEAR FORM
 	 EXIT WHILE
      END IF
      IF g_odm.odm01 IS NULL AND g_odm.odm02 IS NULL AND
         g_odm.odm03 IS NULL THEN              
 	 CONTINUE WHILE
      END IF
      
      INSERT INTO odm_file VALUES(g_odm.*)      
      IF SQLCA.sqlcode THEN                        
  	 CALL cl_err3("ins","odm_file",g_odm.odm01,"",SQLCA.sqlcode,"","",0)
 	 CONTINUE WHILE
      END IF
      
      CALL g_odn.clear()
      LET g_rec_b = 0  
      CALL i402_b()  
      EXIT WHILE
   END WHILE
   
   LET g_wc=' '
END FUNCTION

FUNCTION i402_i(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   DEFINE l_input LIKE type_file.chr1
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_m     LIKE type_file.num5
   DEFINE l_odl02 LIKE odl_file.odl02
   DEFINE l_odl03 LIKE odl_file.odl03 #FUN-C20101---ADD--
   DEFINE l_odl04 LIKE odl_file.odl04 #FUN-C20101---ADD--

   DISPLAY BY NAME g_odm.odm01,g_odm.odm02,g_odm.odm03,g_odm.odm04,g_odm.odm05,
                   g_odm.odm06,g_odm.odm07,g_odm.odmacti,g_odm.odmconf,g_odm.odm08   #TQC-C20134 add odmacti,odmconf       

        
   INPUT BY NAME g_odm.odm01,g_odm.odm02,g_odm.odm03,g_odm.odm04,g_odm.odm05,
                 g_odm.odm06,g_odm.odm07,g_odm.odm08
         WITHOUT DEFAULTS
      

   BEFORE INPUT
     LET g_before_input_done = FALSE
     CALL i402_set_entry(p_cmd)
     CALL i402_set_no_entry(p_cmd)
     LET g_before_input_done = TRUE

   BEFORE FIELD odm04
      IF p_cmd="a" THEN
         LET g_odm.odm04 = YEAR(g_today)
         DISPLAY BY NAME g_odm.odm04
      END IF
#FUN-B90105 add------begin-----      
   BEFORE FIELD odm08
      IF p_cmd="a" THEN
         LET g_odm.odm08 = '1'
         DISPLAY BY NAME g_odm.odm08
      END IF  
#FUN-B90105 add------end-----

   AFTER FIELD odm01
      IF NOT cl_null(g_odm.odm01)  THEN
         SELECT count(*) INTO l_m FROM odl_file WHERE odl01=g_odm.odm01 AND odlacti = 'Y'    #TQC-C20134--add odlacti = 'Y
         IF l_m = 0 OR cl_null(l_m)  THEN
            CALL cl_err("odm01",1201,0)
            NEXT FIELD odm01
         END IF
         IF p_cmd = "a" OR (p_cmd = "u" AND g_odm.odm01 != g_odm_t.odm01) THEN
            SELECT count(*) INTO l_n FROM odm_file WHERE odm02=g_odm.odm02
                                                     AND odm01=g_odm.odm01
            IF l_n > 0 THEN
               CALL cl_err("",1210,0)
               NEXT FIELD odm01
            END IF
#FUN-C20101------ADD------STR-----
            SELECT odl03,odl04 INTO l_odl03,l_odl04 FROM odl_file
             WHERE odl01=g_odm.odm01
            LET g_odm.odm04=YEAR(l_odl03)
            LET g_odm.odm05=MONTH(l_odl03)
            LET g_odm.odm06=YEAR(l_odl04)
            LET g_odm.odm07=MONTH(l_odl04)
         DISPLAY g_odm.odm04,g_odm.odm05,g_odm.odm06,g_odm.odm07 TO odm04,odm05,odm06,odm07
#FUN-C20101------ADD-----END-----  
         END IF
      END IF
      SELECT odl02 INTO l_odl02 FROM odl_file
       WHERE odl01=g_odm.odm01 AND odlacti = 'Y'   #TQC-C20134--add odlacti = 'Y
      DISPLAY l_odl02 TO FORMONLY.odl02
      

   AFTER FIELD odm02
      DISPLAY "AFTER FIELD odm02"
      IF NOT cl_null(g_odm.odm02)  THEN
         IF p_cmd = "a" OR (p_cmd = "u" AND g_odm.odm02 != g_odm_t.odm02) THEN
            SELECT count(*) INTO l_n FROM odm_file WHERE odm02=g_odm.odm02
                                                     AND odm01=g_odm.odm01
            IF l_n > 0 THEN                    
  	       CALL cl_err("",1210,0)
               NEXT FIELD odm02
            END IF
         END IF
      END IF
      
   AFTER FIELD odm03   
    IF NOT cl_null(g_odm.odm03)  THEN   
        IF p_cmd = "a" OR (p_cmd = "u" AND g_odm.odm03 != g_odm_t.odm03) THEN
           SELECT count(*) INTO l_n FROM odm_file WHERE odm03=g_odm.odm03
 						     AND odm01=g_odm.odm01
 						     AND odm02=g_odm.odm02
           IF l_n > 0 THEN                    
	       CALL cl_err("",'axm1027',0) #FUN-C20006 add
             NEXT FIELD odm03
           END IF
        END IF
     END IF  
     
   AFTER FIELD odm04
      DISPLAY "AFTER FIELD odm04"
      IF g_odm.odm04 < 0 THEN                  
 	    CALL cl_err(g_odm.odm04,'axm1036',0) #FUN-C20006 add
         NEXT FIELD odm04
      END IF
      IF g_odm.odm06 < g_odm.odm04 THEN      #FUN-B90105 add
 	    CALL cl_err(g_odm.odm06,'axm1035',0) #FUN-B90105 add #FUN-C20006 add
         NEXT FIELD odm06                    #FUN-B90105 add
      END IF                                 #FUN-B90105 add
   AFTER FIELD odm05
      DISPLAY "AFTER FIELD odm05"
    #  IF cl_null(g_odm.odm05)    THEN   #FUN-B90105 MARK
    #     CALL cl_err("odm05",1205,0)    #FUN-B90105 MARK
    #     NEXT FIELD odm05               #FUN-B90105 MARK
    #  END IF                            #FUN-B90105 MARK
      IF g_odm.odm05 <= 0 THEN                  
 	    CALL cl_err(g_odm.odm05,'axm1036',0) #FUN-C20006 add
         NEXT FIELD odm05
      END IF
 #FUN-B90105------ADD------     
      IF g_odm.odm05 > 12 THEN                  
 	    CALL cl_err(g_odm.odm05,'axm1030',0) #FUN-C20006 add
         NEXT FIELD odm05
      END IF
 #FUN-B90105------END------     
   AFTER FIELD odm06
      DISPLAY "AFTER FIELD odm06"
     
   #   IF cl_null(g_odm.odm06)  OR g_odm.odm06 < g_odm.odm04 THEN     #FUN-B90105 mark
      IF g_odm.odm06 < g_odm.odm04 THEN                               #FUN-B90105 add
 	    CALL cl_err(g_odm.odm06,'axm1035',0) #FUN-C20006 add

         NEXT FIELD odm06
      END IF
  
   AFTER FIELD odm07
      DISPLAY "AFTER FIELD odm07"
     # IF cl_null(g_odm.odm07) THEN        #FUN-B90105 MARK
     #   CALL cl_err("odm07",1205,0)       #FUN-B90105 MARK
     #   NEXT FIELD odm07                  #FUN-B90105 MARK
     # END IF                              #FUN-B90105 MARK
      IF g_odm.odm06 = g_odm.odm04  AND g_odm.odm07 < g_odm.odm05 THEN   #FUN-B90105 delete '='               
 	    CALL cl_err(g_odm.odm07,'axm1028',0) #FUN-C20006 add
         NEXT FIELD odm07
         END IF
      IF g_odm.odm07 <=0 THEN
         CALL cl_err(g_odm.odm07,'axm1036',0) #FUN-C20006 add
         NEXT FIELD odm07
      END IF
#FUN-B90105------ADD------begin-
      IF g_odm.odm07 > 12 THEN                  
 	    CALL cl_err(g_odm.odm07,'axm1030',0) #FUN-C20006 add
         NEXT FIELD odm07
      END IF
#FUN-B90105------END------  
     
      
   AFTER INPUT
     IF INT_FLAG THEN
        EXIT INPUT
     END IF
     IF g_odm.odm01 IS NULL THEN
        DISPLAY BY NAME g_odm.odm01
        LET l_input='Y'
     END IF
     IF p_cmd = "a" THEN
        SELECT count(*) INTO l_n FROM odm_file 
         WHERE odm01 = g_odm.odm01
           AND odm02 = g_odm.odm02
        IF l_n > 0 THEN
           CALL cl_err("",'axm1027',0) #FUN-C20006 add
           NEXT FIELD odm01
        END IF
     END IF
     IF p_cmd="u" THEN
        IF g_odm.odm01 != g_odm01_t OR g_odm.odm02 != g_odm_t.odm02 THEN           
           SELECT count(*) INTO l_n FROM odm_file 
            WHERE odm01 = g_odm.odm01
              AND odm02 = g_odm.odm02
           IF l_n > 0 THEN
              CALL cl_err("",'axm1027',0) #FUN-C20006 add
              NEXT FIELD odm01
           END IF
        END IF
     END IF
      IF g_odm.odm06 = g_odm.odm04  AND g_odm.odm07 < g_odm.odm05 THEN   #FUN-B90105 delete '='              
 	    CALL cl_err(g_odm.odm07,'axm1028',0) #FUN-C20006 add
         NEXT FIELD odm07
         IF g_odm.odm07 <=0 THEN
            CALL cl_err(g_odm.odm07,'axm1036',0) #FUN-C20006 add
            NEXT FIELD odm07
         END IF
      END IF
     IF l_input='Y' THEN
        NEXT FIELD odm01
     END IF
 
   ON ACTION controlp    
      IF INFIELD(odm01) THEN                                                  
         CALL cl_init_qry_var()                                              
         LET g_qryparam.form="q_odl01"                                                                                               
         LET g_qryparam.default1=g_odm.odm01                                 
         CALL cl_create_qry() RETURNING g_odm.odm01                 
         DISPLAY BY NAME g_odm.odm01                                
         NEXT FIELD odm01
      END IF
     
   #FUN-C60021----ADD---STR---
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE INPUT

   ON ACTION about  
      CALL cl_about()

   ON ACTION help 
      CALL cl_show_help()

   ON ACTION controlg
      CALL cl_cmdask()
   #FUN-C60021----ADD---END--- 
   END INPUT
END FUNCTION

FUNCTION i402_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("odm01,odm02,odm03",TRUE)
    END IF
END FUNCTION

FUNCTION i402_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("odm01,odm02,odm03",FALSE)
   END IF
END FUNCTION

FUNCTION i402_u()
   IF g_odm.odm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#  SELECT * INTO g_odm.* FROM odm_file WHERE odm01=g_odm.odm01 
   IF g_odm.odmacti = 'N' THEN               
      CALL cl_err('',9027,0) 
      RETURN
   END IF
#TQC-C20134--add--begin--
   IF g_odm.odmconf = 'Y' THEN
      CALL cl_err('','mfg1005',0)
      RETURN
   END IF
#TQC-C20134-add--end--

   MESSAGE ""
      CALL cl_opmsg('u')
 	   LET g_odm01_t = g_odm.odm01
           LET g_odm_t.* = g_odm.*

 	   BEGIN WORK                                
	                                                          
 	   OPEN i402_cl USING g_odm.odm01,g_odm.odm02,g_odm.odm03
 	   IF STATUS THEN
 	      CALL cl_err("OPEN i402_cl:", STATUS, 1)
  	      CLOSE i402_cl
 	      ROLLBACK WORK
 	      RETURN
 	   END IF
 	   FETCH i402_cl INTO g_odm.*                
 	   IF SQLCA.sqlcode THEN
 	      CALL cl_err(g_odm.odm01,SQLCA.sqlcode,1)
 	      CLOSE i402_cl
 	      ROLLBACK WORK
 	      RETURN
 	   END IF
#   LET g_odm.odmmodu=g_user   
   LET g_odm.odmmodu=g_user  #FUN-B90105 ADD               
   LET g_odm.odmdate = g_today                
#   CALL i402_show()                                   
   WHILE TRUE
 	 CALL i402_i("u")                                   
 	 IF INT_FLAG THEN  
            LET INT_FLAG = 0
     	    LET g_odm.*=g_odm_t.*
            CALL i402_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
 	 END IF

          IF g_odm.odm01 != g_odm01_t OR g_odm.odm02 != g_odm_t.odm02 THEN           
             UPDATE odn_file SET odn01 = g_odm.odm01,
                                 odn02 = g_odm.odm02
                WHERE odn01 = g_odm01_t
                  AND odn02 = g_odm_t.odm02
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#               CALL cl_err3("upd","odn_file",g_odm01_t,"",SQLCA.sqlcode,"","odn",1)  
                CALL cl_err("",'axm1027',0) #FUN-C20006 add
                CONTINUE WHILE
             END IF
          END IF
       
          UPDATE odm_file SET odm_file.* = g_odm.* 
 	     WHERE odm01=g_odm01_t 
               AND odm02=g_odm_t.odm02
 	      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                               
#	         CALL cl_err3("upd","odm_file",g_odm.odm01,"",SQLCA.sqlcode,"","",0)
                CALL cl_err("",'axm1027',0) #FUN-C20006 add
 	         CONTINUE WHILE
 	      END IF
  	      EXIT WHILE
        END WHILE
   CLOSE i402_cl
   COMMIT WORK
 CALL cl_flow_notify(g_odm.odm01,'U')
        CALL i402_b_fill("1=1")
        CALL i402_bp_refresh()
  END FUNCTION

FUNCTION i402_r()
   IF g_odm.odm01 IS NULL THEN 
      CALL cl_err('',-400,0)
      RETURN 
   END IF 
 
#TQC-C20134--add--begin--
   IF g_odm.odmconf = 'Y' THEN
      CALL cl_err('','alm-551',0)
      RETURN
   END IF
#TQC-C20134-add--end--
   
   BEGIN WORK
   
   OPEN i402_cl USING g_odm.odm01,g_odm.odm02,g_odm.odm03
   IF STATUS THEN 
      CALL cl_err("OPEN i402_cl:",STATUS,0)
      CLOSE i402_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i402_cl INTO g_odm.*
   IF SQLCA.sqlcode THEN 
      CALL cl_err(g_odm.odm01,SQLCA.sqlcode,0)
      RETURN 
   END IF 
   CALL i402_show()
   IF cl_delh(0,0) THEN 
      DELETE FROM odm_file WHERE odm01=g_odm.odm01
                             AND odm02=g_odm.odm02
                             AND odm03=g_odm.odm03
      DELETE FROM odn_file WHERE odn01=g_odm.odm01
                             AND odn02=g_odm.odm02
      CLEAR FORM
      CALL g_odn.clear()  
      OPEN i402_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i402_cus
         CLOSE i402_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i402_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i402_cus
         CLOSE i402_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i402_cus
      IF g_curs_index=g_row_count+1 THEN
        LET g_jump=g_row_count
        CALL i402_fetch('L')
      ELSE
        LET g_jump=g_curs_index
        LET mi_no_ask=TRUE
        CALL i402_fetch('/')
      END IF
   END IF
   CLOSE i402_cl
   COMMIT WORK
END FUNCTION

FUNCTION i402_copy()

   DEFINE l_newno     LIKE odm_file.odm01,
          l_newno2    LIKE odm_file.odm02,
          l_newno3    LIKE odm_file.odm03,
          l_oldno     LIKE odm_file.odm01,
          l_oldno2    LIKE odm_file.odm02,
          l_oldno3    LIKE odm_file.odm03,
          l_m       LIKE type_file.num10, 
          l_n       LIKE type_file.num10 
   IF s_shut(0) THEN 
      RETURN 
   END IF

   IF g_odm.odm01 IS null OR g_odm.odm02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_before_input_done = FALSE
   CALL i402_set_entry('a')
   LET g_before_input_done = TRUE


   CALL cl_set_head_visible("","YES")     
     
   INPUT l_newno,l_newno2,l_newno3 FROM odm01,odm02,odm03
      
       AFTER FIELD odm01
          IF NOT cl_null(l_newno) THEN
             SELECT count(*) INTO l_m FROM odl_file WHERE odl01=l_newno AND odlacti = 'Y'    #TQC-C20134--add odlacti = 'Y
             IF l_m = 0 OR cl_null(l_m)  THEN
                CALL cl_err("odm01",1201,0)
                NEXT FIELD odm01
             END IF

            SELECT count(*) INTO l_n FROM odm_file
                   WHERE  odm01 = l_newno
                     AND  odm02 = l_newno2
            IF l_n>0  THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD odm01
            END IF
                NEXT FIELD odm02
          ELSE
                NEXT FIELD odm01
          END IF
       AFTER FIELD odm02
          IF NOT cl_null(l_newno2) THEN
             SELECT count(*) INTO l_n FROM odm_file
                    WHERE  odm01 = l_newno
                      AND  odm02 = l_newno2
             IF l_n>0  THEN
                CALL cl_err("",1210,0)
                NEXT FIELD odm01
             END IF
             NEXT FIELD odm03
          ELSE 
             NEXT FIELD odm02
          END IF
       AFTER FIELD odm03
            IF NOT cl_null(l_newno3) THEN
               SELECT count(*) INTO l_n FROM odm_file
                      WHERE  odm01 = l_newno
                        AND  odm02 = l_newno2
                        AND  odm03 = l_newno3
               IF l_n>0  THEN
                  CALL cl_err("",'axm1027',0) #FUN-C20006 add
                  NEXT FIELD odm01
               END IF
               EXIT INPUT
            ELSE
               CALL cl_err("",1211,0)
               NEXT FIELD odm03
          END IF
       
   END INPUT
    
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_odm.odm01,g_odm.odm02,g_odm.odm03
      ROLLBACK WORK
      RETURN
   END IF

   DROP TABLE y
   SELECT * FROM odm_file      
       WHERE odm01=g_odm.odm01
         AND odm02=g_odm.odm02
         AND odm03=g_odm.odm03
       INTO TEMP y

   UPDATE y
       SET odm01=l_newno,      
           odm02=l_newno2,
           odm03=l_newno3,
           odmuser=g_user,   
           odmgrup=g_grup,  
#           odmmodu=g_user,
           odmmodu=g_user,    #FUN-B90105 ADD
           odmdate=g_today,  
           odmorig=g_grup,
           odmoriu=g_user,
           odmacti='Y'       

   INSERT INTO odm_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","odm_file","","",SQLCA.sqlcode,"","",0)  
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF

   DROP TABLE x

   SELECT * FROM odn_file         
       WHERE odn01=g_odm.odm01
         AND odn02=g_odm.odm02
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",0)  
      RETURN
   END IF

   UPDATE x SET odn01=l_newno,odn02=l_newno2
   INSERT INTO odn_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","odn_file","","",SQLCA.sqlcode,"","",0)    #FUN-B80089  ADD
      ROLLBACK WORK
   #   CALL cl_err3("ins","odn_file","","",SQLCA.sqlcode,"","",0)    #FUN-B80089 MARK
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_odm.odm01
   LET l_oldno2= g_odm.odm02
   LET l_oldno3= g_odm.odm03
   SELECT odm_file.* INTO g_odm.* FROM odm_file WHERE odm01 = l_newno
                                                  AND odm02 = l_newno2
                                                  AND odm03 = l_newno3
   CALL i402_u()
   CALL i402_b()
   #FUN-C80046---begin
   #SELECT odm_file.* INTO  g_odm.* FROM odm_file WHERE odm01 = l_oldno
   #                                                AND odm02 = l_oldno2
   #                                                AND odm03 = l_odlno3
   #CALL i402_show()
   #FUN-C80046---end
END FUNCTION

FUNCTION i402_x()
   IF g_odm.odm01 IS NULL THEN

      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_odm.odm01 IS NOT NULL THEN
      BEGIN WORK
 
      OPEN i402_cl USING g_odm.odm01,g_odm.odm02,g_odm.odm03
   
      IF STATUS THEN                                                                                                                   
         CALL cl_err("OPEN i402_cl:",STATUS,0)                                                                                         
         CLOSE i402_cl                                                                                                                 
         ROLLBACK WORK                                                                                                                 
         RETURN                                                                                                                        
      END IF         
      FETCH i402_cl INTO g_odm.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_odm.odm01,SQLCA.sqlcode,1)
         RETURN
      END IF
      CALL i402_show()
      IF cl_exp(0,0,g_odm.odmacti) THEN             
         LET g_chr=g_odm.odmacti
        IF g_odm.odmacti='Y' THEN
            LET g_odm.odmacti='N'
        ELSE
            LET g_odm.odmacti='Y'
        END IF
	UPDATE odm_file SET odmacti=g_odm.odmacti
	   WHERE odm01=g_odm.odm01
	  IF SQLCA.SQLERRD[3]=0 THEN                 
	     CALL cl_err(g_odm.odm01,SQLCA.sqlcode,0)
	     LET g_odm.odmacti=g_chr
           
	     DISPLAY BY NAME g_odm.odmacti
      
             CLOSE i402_cl
	     ROLLBACK WORK
             RETURN
         END IF
          DISPLAY BY NAME g_odm.odmacti
      END IF
    CLOSE i402_cl
    COMMIT WORK
   END IF
END FUNCTION

FUNCTION i402_b()

   DEFINE
    l_ac            LIKE type_file.num5,              
    l_ac_t          LIKE type_file.num5, 
    l_n             LIKE type_file.num5,           
    l_cnt           LIKE type_file.num5,              
    l_count         LIKE type_file.num5,              
    l_lock_sw       LIKE type_file.chr1,             
    p_cmd           LIKE type_file.chr1,                
    l_allow_insert  LIKE type_file.num5,            
    l_allow_delete  LIKE type_file.num5,
    l_ima151        LIKE ima_file.ima151,      #TQC-C20117 add
    l_imaag         LIKE ima_file.imaag        #TQC-C20117 add
 
    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_odm.odm01 IS NULL THEN
       RETURN
    END IF

    SELECT * INTO g_odm.* FROM odm_file
           WHERE odm01=g_odm.odm01
             AND odm02=g_odm.odm02        #FUN-B90105 ADD
             AND odm03=g_odm.odm03        #FUN-B90105 ADD

    IF g_odm.odmacti ='N' THEN  
       CALL cl_err(g_odm.odm01,'mfg1000',0)
       RETURN
    END IF

  #TQC-C20224--add--begin--
    IF g_odm.odmconf = 'Y' THEN 
       CALL cl_err('',9023,0) 
       RETURN 
    END IF
  #TQC-C20224--add--end--
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT odn03,odn04,odn05,' ',' ',odn06,odn07,odn08,odn09 ", 
                       " FROM odn_file",
                       " WHERE odn01=? AND odn02=? AND odn03=? AND odn04=?",   #FUN-B90105 ADD ond03,odn04
                       " FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i402_bcl CURSOR FROM g_forupd_sql     

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_odn WITHOUT DEFAULTS FROM s_odn.*
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

#FUN-B90105----star------
           OPEN i402_cl USING g_odm.odm01,g_odm.odm02,g_odm.odm03
           IF STATUS THEN
              CALL cl_err("OPEN i402_cl:", STATUS, 1)
              CLOSE i402_cl
              ROLLBACK WORK
              RETURN
            END IF

           FETCH i402_cl INTO g_odm.*           
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_odm.odm01,SQLCA.sqlcode,0)      
              CLOSE i402_cl
              ROLLBACK WORK
              RETURN
           END IF
#FUN-B90105----end-----
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_odn_t.* = g_odn[l_ac].*  
              
#FUN-B90105----star------
              OPEN i402_bcl USING g_odm.odm01,g_odm.odm02,g_odn_t.odn03,g_odn_t.odn04
                IF STATUS THEN
                   CALL cl_err("OPEN i402_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
              FETCH i402_bcl INTO g_odn[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_odn_t.odn03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
#FUN-B90105----end-----
              CALL cl_show_fld_cont()    
              CALL i402_set_entry_b(p_cmd)  
              CALL i402_set_no_entry_b(p_cmd)
           END IF
#FUN-B90105----star------         #不显示品名，销售单位的BUG
           SELECT ima02,ima31 INTO g_odn[l_ac].ima02,g_odn[l_ac].ima31 FROM ima_file
            WHERE ima01 = g_odn[l_ac].odn05
#FUN-B90105----end-----
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_odn[l_ac].* TO NULL   
           LET g_odn[l_ac].odn03 = ""      
           LET g_odn[l_ac].odn04 = ""           
           LET g_odn[l_ac].odn05 = "" 
           LET g_odn[l_ac].odn06 = 'N'  
           LET g_odn[l_ac].odn07 = 'N' 
           LET g_odn[l_ac].odn08 = ""     
           LET g_odn[l_ac].odn09 = ""   
           LET g_odn_t.* = g_odn[l_ac].*    
           
           CALL cl_show_fld_cont()       
           CALL i402_set_entry_b(p_cmd)    
           CALL i402_set_no_entry_b(p_cmd) 
           NEXT FIELD odn03

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO odn_file(odn01,odn02,odn03,odn04,odn05,odn06,odn07,odn08,odn09)
           VALUES(g_odm.odm01,g_odm.odm02,g_odn[l_ac].odn03,g_odn[l_ac].odn04,g_odn[l_ac].odn05,
                  g_odn[l_ac].odn06, g_odn[l_ac].odn07, g_odn[l_ac].odn08, g_odn[l_ac].odn09) 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","odn_file",g_odm.odm01,g_odn[l_ac].odn03,SQLCA.sqlcode,"","",1) 
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           
        AFTER FIELD odn03 
           DISPLAY "AFTER FIELD odn03"                       
           IF NOT cl_null(g_odn[l_ac].odn03) THEN
#             IF p_cmd = "a" OR  (p_cmd ="u" AND g_odn[l_ac].odn03 != g_odn_t.odn03) THEN
#                SELECT count(*)
#                  INTO l_n
#                  FROM odn_file
#                  WHERE odn01 = g_odm.odm01
#                  AND odn02 = g_odm.odm02
#                  AND odn03 = g_odn[l_ac].odn03
#                IF l_n > 0 THEN
#                   CALL cl_err('',-239,0)
#                   NEXT FIELD odn03
#                END IF
#             END IF
           ELSE
#              CALL cl_err("",1118,0) #TQC-C40197---MARK--
#              NEXT FIELD odn03  #TQC-C40197---MARK----
           END IF   

#TQC-C40197-----ADD----STR-----        
        BEFORE FIELD odn04
           IF cl_null(g_odn[l_ac].odn03) THEN
              CALL cl_err("",1118,0)
              NEXT FIELD odn03
           END IF         
#TQC-C40197-----ADD----END------

        AFTER FIELD odn04 
           DISPLAY "AFTER FIELD odn04"                       
           IF NOT cl_null(g_odn[l_ac].odn04) THEN
              IF p_cmd = "a" OR (p_cmd= "u" AND g_odn[l_ac].odn04 != g_odn_t.odn04) THEN
                 SELECT count(*)
                   INTO l_n
                   FROM odn_file
                   WHERE odn01 = g_odm.odm01
                   AND odn02 = g_odm.odm02
                   AND odn03 = g_odn[l_ac].odn03
                   AND odn04 = g_odn[l_ac].odn04
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_odn[l_ac].odn04 = g_odn_t.odn04
                    NEXT FIELD odn04
                 END IF
              END IF
           ELSE
              CALL cl_err("odn04",1205,0)
              NEXT FIELD odn04
           END IF                     
  
        AFTER FIELD odn05
           IF NOT cl_null(g_odn[l_ac].odn05) THEN
#FUN-B90105 modify---begin--
#             IF NOT s_chk_item_no(g_odn[l_ac].odn05,'') THEN       
#                CALL cl_err('',g_errno,1)                         
#                NEXT FIELD odn05                                 
#             END IF                                             
              LET l_count=0

             #TQC-C20117--add--begin--
              SELECT COUNT(*) INTO l_count FROM ima_file WHERE ima01=g_odn[l_ac].odn05
                                                         AND ima1010='1' and imaacti='Y'
               IF l_count=0 THEN
                  CALL cl_err('','100',0)
                  LET g_odn[l_ac].odn05=g_odn_t.odn05
                  NEXT FIELD odn05
               END IF
               SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file
                WHERE ima01=g_odn[l_ac].odn05 AND imaacti='Y'
               IF l_ima151='N' AND l_imaag='@CHILD' THEN
                  CALL cl_err('','axm1104',0)
                  NEXT FIELD odn05 
               END IF
             #TQC-C20117--add--end--
             #TQC-C20117--mark--begin--
             #SELECT COUNT(*) INTO l_count FROM ima_file
             #WHERE ima01=g_odn[l_ac].odn05
             #  AND imaacti <>'X' AND (ima151 !='N' OR imaag<>'@CHILD')
             #  AND ima1010='1'
             #IF cl_null(l_count) OR l_count = 0 THEN
             #   CALL cl_err("","-0811",0)
             #   NEXT FIELD odn05
             #END IF
             #TQC-C20117--mark--end---
#FUN-B90105 modify----end--
              IF p_cmd = "a" OR (p_cmd= "u" AND g_odn[l_ac].odn05 != g_odn_t.odn05) THEN
                 SELECT count(*) INTO l_n  FROM odn_file
                   WHERE odn01=g_odm.odm01
                     AND odn05=g_odn[l_ac].odn05
                 IF l_n > 0 THEN
                    CALL cl_err(g_odn[l_ac].odn05,3001,0)
                    LET g_odn[l_ac].odn05 = g_odn_t.odn05
                    NEXT FIELD odn05
                 END IF

              END IF
           END IF
           SELECT ima02,ima31 INTO g_odn[l_ac].ima02,g_odn[l_ac].ima31 FROM ima_file
            WHERE ima01 = g_odn[l_ac].odn05 
           DISPLAY g_odn[l_ac].ima02,g_odn[l_ac].ima31 TO ima02,ima31
#FUN-B90105----BEGIN---
         LET g_doc.column1 = "ima01"
         LET g_doc.value1 = g_odn[l_ac].odn05
         CALL cl_get_fld_doc("ima04") 
#FUN-B90105----END----       
        AFTER FIELD odn08
           IF g_odn[l_ac].odn08<0 THEN
              CALL cl_err(g_odn[l_ac].odn08,'axm1029',0) #FUN-C20006 add
              NEXT FIELD odn08
           END IF      
        AFTER FIELD odn09
           IF g_odn[l_ac].odn09<0 THEN
              CALL cl_err(g_odn[l_ac].odn09,'axm1029',0) #FUN-C20006 add
              NEXT FIELD odn09
           END IF

 
        BEFORE DELETE                      
           IF  NOT cl_null(g_odn_t.odn03) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              
              DELETE FROM odn_file
                 WHERE odn01 = g_odm.odm01
                 AND odn03 = g_odn_t.odn03
                 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","odn_file",g_odm.odm01,g_odn_t.odn03,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
        
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_odn[l_ac].* = g_odn_t.*
              CLOSE i402_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_odn[l_ac].odn03,-263,1)
              LET g_odn[l_ac].* = g_odn_t.*
           ELSE
              UPDATE odn_file SET 
                                  odn03=g_odn[l_ac].odn03,
                                  odn04=g_odn[l_ac].odn04,
                                  odn05=g_odn[l_ac].odn05,
                                  odn06=g_odn[l_ac].odn06,
                                  odn07=g_odn[l_ac].odn07,
                                  odn08=g_odn[l_ac].odn08,
                                  odn09=g_odn[l_ac].odn09
               WHERE odn01=g_odm.odm01
                 AND odn02=g_odm.odm02
                 AND odn03=g_odn_t.odn03
                 AND odn04=g_odn_t.odn04
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                CALL cl_err3("upd","odn_file",g_odm.odm01,g_odn_t.odn03,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 CALL cl_err("",'axm1027',0) #FUN-C20006 add
                 LET g_odn[l_ac].* = g_odn_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF

      ON ACTION controlp      
        IF INFIELD (odn05) THEN 
#FUN-AA0059---------mod------------str-----------------          
#FUN-B90105--------modify---------begin----------------
            CALL cl_init_qry_var()
            LET g_qryparam.form="q_ima01_slk"
            LET g_qryparam.default1=g_odn[l_ac].odn05   
            CALL cl_create_qry() RETURNING g_odn[l_ac].odn05
#           CALL q_sel_ima(FALSE, "q_ima","",g_odn[l_ac].odn05,"","","","","",'' ) #FUN-B90105 mark 
#            RETURNING  g_odn[l_ac].odn05 
#FUN-B90105-----modify----------end--------------------

#FUN-AA0059---------mod------------end-----------------           
          DISPLAY g_odn[l_ac].odn05 TO odn05
            NEXT FIELD odn05 
         END IF
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 Let g_odn[l_ac].* = g_odn_t.*
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_odn.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end----
              END IF
#FUN-B90105---add---star------
           SELECT ima02,ima31 INTO g_odn[l_ac].ima02,g_odn[l_ac].ima31 FROM ima_file
            WHERE ima01 = g_odn[l_ac].odn05 
           DISPLAY g_odn[l_ac].ima02,g_odn[l_ac].ima31 TO ima02,ima31
#FUN-B90105---add---end-------
              CLOSE i402_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30034 add
           CLOSE i402_bcl
           COMMIT WORK
       #FUN-C60021----ADD---STR---
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

       ON ACTION controlg
          CALL cl_cmdask()
   #FUN-C60021----ADD---END---
    END INPUT
    
    CLOSE i402_bcl
    COMMIT WORK
    CALL i402_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i402_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM odm_file WHERE odm01 = g_odm.odm01
                                AND odm02 = g_odm.odm02
                                AND odm03 = g_odm.odm03
         INITIALIZE g_odm.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i402_bp_refresh()
  DISPLAY ARRAY g_odn TO s_odn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION

FUNCTION i402_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
  CALL cl_set_comp_entry("odn03,odn04,odn05,odn06,odn07,odn08,odn09",TRUE)  
END FUNCTION
FUNCTION i402_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1  

END FUNCTION

#TQC-C20134--add--begin--
FUNCTION i402_confirm()
   DEFINE l_odn05   LIKE odn_file.odn05,
          l_n       LIKE type_file.num5,
          l_success LIKE type_file.chr1


    IF cl_null(g_odm.odm01) THEN
       CALL cl_err('','-400',0)
       RETURN
    END IF
    IF g_odm.odmconf = 'Y' THEN
       CALL cl_err('','alm1069',0)
       RETURN
    END IF
    IF g_odm.odmacti = 'N' THEN
       CALL cl_err('','mfg-214',0)
       RETURN
    END IF  
    IF NOT cl_confirm('axm-108') THEN
       LET l_success = 'N'    
       RETURN
    END IF
#CHI-C30107 --------------------- add --------------------- begin
    SELECT * INTO g_odm.* FROM odm_file WHERE odm01=g_odm.odm01
                                          AND odm02=g_odm.odm02
                                          AND odm03=g_odm.odm03
    IF cl_null(g_odm.odm01) THEN
       CALL cl_err('','-400',0)
       RETURN
    END IF
    IF g_odm.odmconf = 'Y' THEN
       CALL cl_err('','alm1069',0)
       RETURN
    END IF
    IF g_odm.odmacti = 'N' THEN
       CALL cl_err('','mfg-214',0)
       RETURN
    END IF
#CHI-C30107 --------------------- add --------------------- end
    LET l_success='Y'
    SELECT count(*) INTO l_n FROM odm_file WHERE odm01=g_odm.odm01
                                             AND odm02=g_odm.odm02
                                             AND odm03=g_odm.odm03
    IF l_n=0 OR cl_null(l_n) THEN
       CALL cl_err('','aap-129',1)
       RETURN 
    END IF

    #TQC-C20418---modify--begin---
    DECLARE i402_chk_odn05 CURSOR FOR SELECT odn05 FROM odn_file,odm_file
                                                  WHERE odn01 = g_odm.odm01 
                                                    AND odm02 = g_odm.odm02
                                                    AND odn01 = odm01
                                                    AND odm02 = odn02
    CALL s_showmsg_init()
    FOREACH i402_chk_odn05 INTO l_odn05
       LET l_n = 0
       SELECT COUNT(*) INTO l_n FROM odn_file,odm_file WHERE odn01 = g_odm.odm01 AND odn05 = l_odn05
                                                         AND odm02 = odn02 AND odn01 = odm01 
                                                         AND odmacti = 'Y' AND odmconf = 'Y'
       IF l_n > 0 THEN
          CALL s_errmsg('',g_odm.odm01||'  '||l_odn05,'','mfg-213',1)
          LET l_success='N'
       END IF
    END FOREACH
    CALL s_showmsg()
    
#    CALL s_showmsg_init()
#    FOREACH i402_chk_odn05 INTO l_odn05
#       IF l_success='N' THEN
#          EXIT FOREACH
#       END IF
#       LET l_n = 0
#       SELECT COUNT(*) INTO l_n FROM odn_file,odm_file WHERE odn01 = g_odm.odm01 AND odn05 = l_odn05
#                                                         AND odn01 = odm01 AND odm02 = odn02 AND odmacti = 'Y'
#                                                         AND odn02 = g_odm.odm02
#       IF l_n > 1 THEN
#          CALL s_errmsg('',g_odm.odm01||' '||g_odm.odm02||' '||l_odn05,'','mfg-212',1)
#          LET l_success='N'
#       END IF
#    END FOREACH
#    CALL s_showmsg() 
    #TQC-C20418---modify--end---

    IF l_success='Y' THEN
       UPDATE odm_file SET odmconf = 'Y' WHERE odm01=g_odm.odm01 AND odm02=g_odm.odm02 AND odm03 = g_odm.odm03
       IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","odm_file",g_odm.odm01,g_odm.odm02,STATUS,"","x_upd odm",1)
          ROLLBACK WORK
       ELSE
          COMMIT WORK
          LET g_odm.odmconf = 'Y'
          CALL cl_err('','abm-983',0)
       END IF
    END IF
    DISPLAY g_odm.odmconf TO odmconf
     
END FUNCTION

FUNCTION i402_undo_confirm()
  
    IF cl_null(g_odm.odm01) THEN
       CALL cl_err('','-400',0)
       RETURN
    END IF 
    IF g_odm.odmconf = 'N' THEN
       CALL cl_err('','apm-098',0)
       RETURN
    END IF
    IF NOT cl_confirm('axm-109') THEN 
       RETURN 
    END IF 
    UPDATE odm_file SET odmconf = 'N' WHERE odm01=g_odm.odm01 AND odm02=g_odm.odm02 AND odm03 = g_odm.odm03
    IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_err3("upd","odm_file",g_odm.odm01,g_odm.odm02,STATUS,"","x_upd odm",1)
       ROLLBACK WORK
    ELSE
       COMMIT WORK
       LET g_odm.odmconf = 'N'
    END IF
    DISPLAY g_odm.odmconf TO odmconf 
END FUNCTION
#TQC-C20134-add--end--

#FUNCTION i402_out()

#END FUNCTION
#FUN-B50064
