# Prog. Version..: '5.30.06-13.03.12(00010)'     #
# Pattern name...: axmi406.4gl
# Descriptions...:
# Date & Author..: 10/05/17 By chenying
# Modify.........: No.FUN-AB0061 10/11/16 By vealxu   訂單、出貨單、銷退單加基礎單價字段(oeb37,ogb37,ohb37)
# Modify.........: No.FUN-B20005 11/02/09 By chenying 完善程序 
# Modify.........: No.FUN-B20031 11/02/24 By huangrh 修改程式結構，改為DIALOG
# Modify.........: No.FUN-B20011 11/05/19 By huangtao database ds1--->ds
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B90105 11/10/12 BY linlin 修改轉出訂單功能
# Modify.........: No.FUN-B90101 11/11/11 By lixiang 修改轉出訂單的功能
#                                                   （服飾開發的二維形式，新增到表oebslk_file 和oebi_file)
# Modify.........: No.FUN-910088 12/01/17 By chenjing 增加數量欄位小數取位
# Modify.........: No:TQC-C20134 12/02/13 By xjll    使用訂貨會編號時資料有效碼為Y才可以使用
# Modify.........: No:TQC-C20172 12/02/14 By lixiang 服飾BUG修改(光標從一個母料件移到一個非多屬性料件上時，客戶訂貨明細沒有清空)
# Modify.........: No:TQC-C20376 12/02/22 By huangrh 款式匯總單身的實際訂貨量不應該統計未審核的資料,支持非多屬性料件
# Modify.........: No:TQC-C20418 12/02/23 By huangrh 款式的最低訂貨量不對
# Modify.........: No:TQC-C20454 12/02/24 By huangrh oeb906赋值
# Modify.........: No:FUN-C40043 12/04/12 By qiaozy  調整axmi406，使其支持非多屬性料件修改確認數量
# Modify.........: No:TQC-C40197 12/04/24 By qiaozy  訂貨明細確認相關BUG修改
# Modify.........: No:TQC-C40248 12/04/26 By qiaozy  oea83沒有給值
# Modify.........: No:FUN-C60027 12/06/08 By qiaozy  訂貨明細顏色尺寸抓值，客戶明細欄位修改，oea11賦值變化
# Modify.........: No:FUN-C60021 12/06/11 By qiaozy  快捷键设置
# Modify.........: No:FUN-C70082 12/07/19 By xjll    單身主款號后面添加品名
# Modify.......... No:CHI-C80060 12/08/27 By pauline 令oeb72預設值為null
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取

DATABASE ds     #FUN-B20011

GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt400.global"

DEFINE g_odr00        LIKE odr_file.odr00
DEFINE g_odr00_t      LIKE odr_file.odr00
DEFINE g_odr01        LIKE odr_file.odr01
DEFINE g_odr01_t      LIKE odr_file.odr01
DEFINE g_odp13        LIKE odp_file.odp13
DEFINE g_odp13_t      LIKE odp_file.odp13
DEFINE g_argv1        LIKE odr_file.odr01
DEFINE g_wc           STRING
DEFINE g_wc1          STRING
DEFINE g_wc2          STRING
DEFINE g_wc3          STRING
DEFINE g_wc4          STRING
DEFINE g_rec_b1       LIKE type_file.num5
DEFINE g_rec_b2       LIKE type_file.num5
DEFINE g_rec_b3       LIKE type_file.num5
DEFINE l_ac1          LIKE type_file.num5
DEFINE l_ac2          LIKE type_file.num5
DEFINE l_ac3 	      LIKE type_file.num5
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_row_count    LIKE type_file.num10  
DEFINE g_jump         LIKE type_file.num10 
DEFINE mi_no_ask      LIKE type_file.num5
DEFINE g_msg          LIKE ze_file.ze03 
DEFINE g_sql          STRING
DEFINE g_forupd_sql   STRING
DEFINE g_cnt          LIKE type_file.num10
DEFINE g_cnt1         LIKE type_file.num10
DEFINE g_cnt2         LIKE type_file.num10
DEFINE l_ps           LIKE sma_file.sma46
DEFINE g_odp DYNAMIC ARRAY OF RECORD
               odp07       LIKE odp_file.odp07,
               ima02       LIKE ima_file.ima02,
               odp08_s     LIKE odp_file.odp08,
               odn09       LIKE odn_file.odn09,
               odp08_odn08 LIKE odp_file.odp08,
               odp09_s     LIKE odp_file.odp09,  
               odp10_s     LIKE odp_file.odp10,  
               odp12       LIKE odp_file.odp12,
               ima02_1     LIKE ima_file.ima02    #FUN-C70082--add   
             END RECORD
               
DEFINE g_odr DYNAMIC ARRAY OF RECORD
               odr02    LIKE odp_file.odp02,
               occ02    LIKE occ_file.occ02,
               agd02_1  LIKE agd_file.agd02,
               agd02_2  LIKE agd_file.agd02,
               odr04    LIKE odr_file.odr04,
               odr05    LIKE odr_file.odr05,
               odr07    LIKE odr_file.odr07
             END RECORD

DEFINE g_odr2 DYNAMIC ARRAY OF RECORD
              odr02_2     LIKE odr_file.odr02,
              occ02_2     LIKE occ_file.occ02,
              odr05_s     LIKE odr_file.odr05,
              odp09       LIKE odp_file.odp09,
              odp10       LIKE odp_file.odp10,
              odr05_total LIKE odr_file.odr05,
              odp09_total LIKE odp_file.odp09,
              odp10_total LIKE odp_file.odp10,
              odo03       LIKE odo_file.odo03,
              odo04       LIKE odo_file.odo04,
              odr06       LIKE odr_file.odr06    #FUN-B90101 add
              END RECORD          

DEFINE p_row,p_col LIKE type_file.num5


MAIN
   OPTIONS                                       
      INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 4 LET p_col = 25
   OPEN WINDOW i406_w AT p_row,p_col WITH FORM "axm/42f/axmi406"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_set_comp_entry("odr02_2,occ02_2",FALSE)
   CALL cl_set_comp_visible("odp10_s",FALSE)

   CALL i406_menu()
   

   CLOSE WINDOW i406_w     
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN

#FUN-B20031---modify-----begin-------------------------------
FUNCTION i406_menu()
   DEFINE l_n       LIKE type_file.num5
   DEFINE g_odr06   LIKE odr_file.odr06
   DEFINE l_n1      LIKE type_file.num5    #FUN-B90101 add
   DEFINE l_odr02   LIKE odr_file.odr02    #FUN-B90101 add

   WHILE TRUE

      LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)

       DIALOG ATTRIBUTES(UNBUFFERED)
           DISPLAY ARRAY g_odp TO s_odp.*
              BEFORE DISPLAY
                 CALL cl_navigator_setting( g_curs_index, g_row_count )
          
              BEFORE ROW
                 LET l_ac1 = DIALOG.getCurrentRow("s_odp")
                 IF l_ac1 >0 THEN
                    IF cl_null(l_ac2) OR l_ac2=0 THEN LET l_ac2=1 END IF
                    CALL i406_b_fill_2(g_wc4)
                    CALL i406_b_fill_3(g_wc4)
                 END IF 
           END DISPLAY

           DISPLAY ARRAY g_odr2 TO s_odr2.*
              BEFORE DISPLAY
                 CALL cl_navigator_setting(g_curs_index,g_row_count)
                 LET g_action_choice=""

              BEFORE ROW
                 LET l_ac2 = DIALOG.getCurrentRow("s_odr2")
                 CALL cl_show_fld_cont()
                 IF l_ac2 >0 THEN
                   CALL i406_b_fill_3(g_wc4)
                 END IF

           END DISPLAY

           DISPLAY ARRAY g_odr TO s_odr.*
              BEFORE DISPLAY
                 CALL cl_navigator_setting( g_curs_index, g_row_count )
                 LET g_action_choice="" 
          
              BEFORE ROW
                 LET l_ac3 = DIALOG.getCurrentRow("s_odr")
           END DISPLAY

           ON ACTION insert
              LET g_action_choice="insert"
              EXIT DIALOG
           ON ACTION query
              LET g_action_choice="query"
              EXIT DIALOG
           ON ACTION delete
              LET g_action_choice="delete"
              EXIT DIALOG
           ON ACTION first
              LET g_action_choice = "first"
              EXIT DIALOG
           ON ACTION PREVIOUS 
              LET g_action_choice = "previous"
              EXIT DIALOG          
           ON ACTION jump
              LET g_action_choice = "jump"
              EXIT DIALOG
           ON ACTION next
              LET g_action_choice = "next"
              EXIT DIALOG
           ON ACTION last
              LET g_action_choice = "last"
              EXIT DIALOG
           ON ACTION detail
              LET g_action_choice="detail"
              EXIT DIALOG

           ON ACTION out_order
         #     LET g_action_choice="output"     #FUN-B90105 MARK
              LET g_action_choice="out_order" #FUN-B90105 ADD
              EXIT DIALOG

           ON ACTION output
              LET g_action_choice="output"
              EXIT DIALOG
           ON ACTION help
              LET g_action_choice="help"
              EXIT DIALOG
           ON ACTION exit
              LET g_action_choice="exit"
              EXIT DIALOG
           ON ACTION controlg
              LET g_action_choice="controlg"
              EXIT DIALOG
           ON ACTION controls                         
              CALL cl_set_head_visible("","AUTO")    
          
           ON ACTION accept
              LET g_action_choice="detail"
#              LET l_ac1 = ARR_CURR()                 #TQC-C20418 mark
              EXIT DIALOG
           ON ACTION cancel
              LET INT_FLAG=FALSE  
              LET g_action_choice="exit"
              EXIT DIALOG
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE DIALOG
           ON ACTION about   
              CALL cl_about()    
              EXIT DIALOG
#           ON ACTION exporttoexcel   
#              LET g_action_choice = 'exporttoexcel'
#              EXIT DIALOG
           AFTER DIALOG
              CONTINUE DIALOG

       END DIALOG

    CALL cl_set_act_visible("accept,cancel", TRUE) 

    CASE g_action_choice

         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i406_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i406_q()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i406_b()
            END IF

         WHEN "out_order"                #轉出訂單
            IF cl_chk_act_auth() THEN
               CALL i406_turnout()
           END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i406_r()
             END IF

         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_odr01 IS NOT NULL OR cl_null(g_odr00) THEN
                  LET g_doc.column1 = "odr01"
                  LET g_doc.value1 = g_odr01
                  CALL cl_doc()
               END IF
            END IF

         WHEN "next"
            IF cl_chk_act_auth() THEN
               CALL i406_fetch('N')
            END IF
         WHEN "previous"
            IF cl_chk_act_auth() THEN
               CALL i406_fetch('P')
            END IF
         WHEN "jump"
            IF cl_chk_act_auth() THEN
               CALL i406_fetch('/')
            END IF
         WHEN "first"
            IF cl_chk_act_auth() THEN
               CALL i406_fetch('F')
            END IF
         WHEN "last"
            IF cl_chk_act_auth() THEN
               CALL i406_fetch('L')
            END IF
         WHEN "help"
            CALL cl_show_help()

         WHEN "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exit"
            EXIT WHILE

      END CASE

   END WHILE

END FUNCTION
#FUN-B20031----------modify-----------------end-------------------

FUNCTION i406_odl02(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
   DEFINE l_odl02 LIKE odl_file.odl02
   
   LET g_errno=''
    
   SELECT odl02 INTO l_odl02 FROM odl_file
      WHERE odl01=g_odr01 AND odlacti = 'Y'    #TQC-C20134--add odlacti = 'Y'
   IF SQLCA.sqlcode=100 THEN
      LET g_errno='aoo-005'
   ELSE
      LET g_errno=SQLCA.sqlcode USING '------'
   END IF 
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_odl02 TO odl02
   END IF
END FUNCTION

FUNCTION i406_ima02(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
   
   LET g_errno=''
    
   SELECT ima02 INTO g_odp[l_ac1].ima02 FROM ima_file
      WHERE ima01=g_odp[l_ac1].odp07
   IF SQLCA.sqlcode=100 THEN
      LET g_errno='aoo-005'
   ELSE
      LET g_errno=SQLCA.sqlcode USING '------'
   END IF 
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY  g_odp[l_ac1].ima02
   END IF
END FUNCTION

FUNCTION i406_cs()
   CLEAR FORM
   CALL g_odp.clear()
        
   IF NOT  cl_null(g_argv1) THEN                                              
      LET g_wc = " odr01 = '",g_argv1,"'"                                       
   ELSE                                                                         
      CALL cl_set_head_visible("","YES") 
   
      INITIALIZE g_odr01 TO NULL 
      INITIALIZE g_odr00 TO NULL 
      INITIALIZE g_odp13 TO NULL 
      CONSTRUCT BY NAME g_wc ON odr00,odr01,odp13
        
      BEFORE CONSTRUCT 
         CALL cl_qbe_init()
      
         ON ACTION controlp
            IF INFIELD (odr01) THEN 
               CALL cl_init_qry_var()
               LET g_qryparam.form="q_odl01_3"
               LET g_qryparam.state="c"
               LET g_qryparam.default1=g_odr01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO odr01
               NEXT FIELD odr01
            END IF
            IF INFIELD(odr00) THEN #查詢單据
               CALL cl_init_qry_var()
               LET g_qryparam.form="q_odr00"
               LET g_qryparam.state="c"
               LET g_qryparam.default1=g_odr00
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO odr00
               NEXT FIELD odr00
            END IF
      
         ON IDLE g_idle_seconds                       
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         ON ACTION about                       
            CALL cl_about()         
         ON ACTION help                                    
            CALL cl_show_help()  
         ON ACTION controlg                              
            CALL cl_cmdask() 
      END CONSTRUCT

      IF INT_FLAG THEN                                                          
         RETURN                                                                 
      END IF                                                                    
   END IF 
   
   IF NOT cl_null(g_argv1) THEN                                                 
      LET g_wc2 = " 1=1"                                                        
   ELSE   
#      CONSTRUCT g_wc2 ON imx00 FROM s_odp[1].odp07 #FUN-C40043------MARK--
      CONSTRUCT g_wc2 ON odp07 FROM s_odp[1].odp07 #FUN-C40043------add----
  
      BEFORE CONSTRUCT 
         ON IDLE g_idle_seconds                                                    
            CALL cl_on_idle()                                                      
            CONTINUE CONSTRUCT 
      
         ON ACTION controlp
            IF INFIELD (odp07) THEN 
               CALL cl_init_qry_var()
               LET g_qryparam.form="q_ima02_1"
               LET g_qryparam.state="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO odp07
               NEXT FIELD odp07
            END IF   
  
         ON ACTION about                                                 
            CALL cl_about()  
         ON ACTION controlg                                                        
            LET g_action_choice="controlg"                                         
         ON ACTION help                                                            
            LET g_action_choice="help"
      END CONSTRUCT

      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
   
   
#   IF NOT cl_null(g_argv1) AND NOT cl_null(g_wc2) THEN                                                 
#      LET g_wc3 = " 1=1"                                                        
#   ELSE   
#      CONSTRUCT g_wc3 ON odr02 FROM s_odr[1].odr02
#  
#      BEFORE CONSTRUCT 
#         ON IDLE g_idle_seconds                                                    
#            CALL cl_on_idle()                                                      
#            CONTINUE CONSTRUCT 
#      
#         ON ACTION controlp
#            IF INFIELD (odr02) THEN 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form="q_occ01_1"
#               LET g_qryparam.state="c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO odr02
#               NEXT FIELD odr02
#            END IF   
#  
#         ON ACTION about                                                 
#            CALL cl_about()  
#         ON ACTION controlg                                                        
#            LET g_action_choice="controlg"                                         
#         ON ACTION help                                                            
#            LET g_action_choice="help"
#      END CONSTRUCT
#
#      IF INT_FLAG THEN
#         RETURN
#      END IF
#   END IF
  
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_wc2) AND NOT cl_null(g_wc3)THEN                                                 
      LET g_wc4 = " 1=1"                                                        
   ELSE   
      CONSTRUCT g_wc4 ON odr02 FROM s_odr2[1].odr02_2
  
      BEFORE CONSTRUCT 
         ON IDLE g_idle_seconds                                                    
            CALL cl_on_idle()                                                      
            CONTINUE CONSTRUCT 
      
         ON ACTION controlp
            IF INFIELD (odr02_2) THEN 
               CALL cl_init_qry_var()
               LET g_qryparam.form="q_occ01_1"
               LET g_qryparam.state="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO odr02_2
               NEXT FIELD odr02_2
            END IF   
  
         ON ACTION about                                                 
            CALL cl_about()  
         ON ACTION controlg                                                        
            LET g_action_choice="controlg"                                         
         ON ACTION help                                                            
            LET g_action_choice="help"
      END CONSTRUCT

      IF INT_FLAG THEN
         RETURN
      END IF
   END IF   
 
   IF g_wc2=" 1=1" AND g_wc4=" 1=1" THEN
      LET g_sql="SELECT  DISTINCT odr00 FROM odr_file,odp_file",
                "  WHERE ", g_wc CLIPPED,
                "    AND odr01=odp01  AND odp11='Y' AND odp14=odr00"            
   ELSE
      LET g_sql="SELECT DISTINCT odr00 ",
                "  FROM odr_file,odp_file ",#FUN-C40043---MARK--imx_file
#                " WHERE odr000=odr03 ",     #FUN-C40043---MARK----
#                "   AND odr01=odp01",      #FUN-C40043---MARK-
                " WHERE odr01=odp01",       #FUN-C40043---add---- 
                "   AND odp11='Y'",
                "   AND odp14=odr00",
#                "   AND odp07=imx00",       #FUN-C40043--MARK----
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED,
                "   AND ",g_wc4 CLIPPED
   END IF
   
   PREPARE i406_prepare FROM g_sql                                             
   DECLARE i406_cus SCROLL CURSOR WITH HOLD FOR i406_prepare  
   
   IF g_wc2 = " 1=1" AND g_wc4=" 1=1" THEN                                     
      LET g_sql="SELECT COUNT(DISTINCT odr00) FROM odr_file,odp_file",
                "  WHERE ",g_wc CLIPPED,
                "    AND odr01=odp01  AND odp11='Y' AND odp14=odr00"             
   ELSE                                                                       
      LET g_sql="SELECT COUNT(DISTINCT odr00) FROM odr_file,odp_file ",   #FUN-C40043---MARk imx_file---- 
#                " WHERE odr000=odr03 ",   #FUN-C40043---MARK---
#                "   AND odr01=odp01",     #FUN-C40043---MARK----
                " WHERE odr01=odp01",       #FUN-C40043---add---- 
                "   AND odp11='Y'",
                "   AND odp14=odr00",
#                "   AND odp07=imx00",    #FUN-C40043---MARK---
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED,
                "   AND ",g_wc4 CLIPPED
   END IF                            
      
   PREPARE i406_precount FROM g_sql                                           
   DECLARE i406_count CURSOR FOR i406_precount  
END FUNCTION

FUNCTION i406_q()
   LET g_row_count=0
   LET g_curs_index=0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FROM
   CALL g_odp.clear()
   CALL g_odr.clear()
   CALL g_odr2.clear()
   DISPLAY ' ' TO FORMONLY.cnt

   CALL i406_cs()

   IF INT_FLAG THEN 
      LET INT_FLAG=0
      CLEAR FORM
      RETURN 
   END IF
   
   OPEN i406_count                          
   FETCH i406_count INTO g_row_count                                         
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN i406_cus                                                                
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err(g_odr01,SQLCA.sqlcode,0)                                  
      INITIALIZE g_odr00 TO NULL
      INITIALIZE g_odr01 TO NULL
      INITIALIZE g_odp13 TO NULL
   ELSE 
      CALL i406_fetch('F') 
   END IF   
END FUNCTION

FUNCTION i406_fetch(p_fodr)
DEFINE p_fodr VARCHAR(1)

   CASE p_fodr
      WHEN 'N' FETCH NEXT i406_cus INTO g_odr00
      WHEN 'F' FETCH FIRST i406_cus INTO g_odr00
      WHEN 'L' FETCH LAST  i406_cus INTO g_odr00
      WHEN 'P' FETCH PREVIOUS i406_cus INTO g_odr00
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
      FETCH ABSOLUTE g_jump i406_cus INTO g_odr00
      LET mi_no_ask=FALSE
   END CASE
    
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_odr01,SQLCA.sqlcode,0)
      INITIALIZE g_odr00 TO NULL
      INITIALIZE g_odr01 TO NULL
      INITIALIZE g_odp13 TO NULL
      RETURN
   ELSE
      CASE p_fodr
         WHEN 'F' LET g_curs_index=1
         WHEN 'N' LET g_curs_index=g_curs_index+1
         WHEN 'P' LET g_curs_index=g_curs_index-1 
         WHEN 'L' LET g_curs_index=g_row_count
         WHEN '/' LET g_curs_index=g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF

   SELECT  DISTINCT odr01 INTO g_odr01 FROM odr_file WHERE odr00=g_odr00 
   IF SQLCA.sqlcode THEN                   
      CALL cl_err3("sel","odr_file",g_odr01,"",SQLCA.sqlcode,"","",0)
   ELSE    
      CALL i406_show()                    
   END IF
END FUNCTION

FUNCTION i406_show()
DEFINE g_odr06   LIKE odr_file.odr06
   CALL i406_odl02('d')
   SELECT DISTINCT odp13 INTO g_odp13 FROM odp_file
    WHERE odp01=g_odr01 AND odp11='Y' AND odp14=g_odr00
   DISPLAY g_odp13 TO odp13
   DISPLAY g_odr01 TO odr01
   DISPLAY g_odr00 TO odr00
   CALL cl_show_fld_cont()
   CALL i406_b_fill_1(g_wc2)
   CALL i406_b_fill_2(g_wc4)  
   CALL i406_b_fill_3(g_wc4)
END FUNCTION

FUNCTION i406_b_fill_1(p_wc2)        #款式匯總 
DEFINE p_wc3 STRING
DEFINE p_wc2 STRING
DEFINE l_odp09 LIKE odp_file.odp09
DEFINE l_odp10 LIKE odp_file.odp10 

   IF cl_null(p_wc2) THEN
      LET p_wc2=" 1=1"
   END IF
   LET g_sql="SELECT DISTINCT odp07,'','','','','','',odp12,'' FROM odp_file",  #FUN-C70082--add ''
             " WHERE odp01='",g_odr01,"'",
             "   AND odp14='",g_odr00,"'",
             "   AND odp11='Y'",
             "   AND odp13='",g_odp13,"'",
             "   AND ",p_wc2 CLIPPED

   LET g_sql=g_sql CLIPPED

   PREPARE i406_odrpb FROM g_sql                                                   
   DECLARE odr_cs CURSOR FOR i406_odrpb 
   
   CALL g_odp.clear()                                                           
   LET g_cnt = 1                                                                
                                                                                
   FOREACH odr_cs INTO g_odp[g_cnt].*                           
       IF SQLCA.sqlcode THEN                                                    
          CALL cl_err('foreach:',SQLCA.sqlcode,1)                               
          EXIT FOREACH
       END IF

       SELECT ima02 INTO g_odp[g_cnt].ima02
         FROM ima_file 
        WHERE ima01=g_odp[g_cnt].odp07

      #FUN-C70082---add---begin--------
      SELECT ima02 INTO g_odp[g_cnt].ima02_1
        FROM ima_file
       WHERE ima01=g_odp[g_cnt].odp12
      #FUN-C70082---add---end----------

       SELECT SUM(odp08) INTO g_odp[g_cnt].odp08_s 
         FROM odp_file
        WHERE odp01=g_odr01 AND odp07=g_odp[g_cnt].odp07 AND odp13=g_odp13
          AND odp12=g_odp[g_cnt].odp12 AND odp14=g_odr00 AND odp11='Y'
       SELECT odn09 INTO g_odp[g_cnt].odn09                                #TQC-C20418 modify odn08->>odn09
         FROM odn_file
        WHERE odn01=g_odr01 AND odn05=g_odp[g_cnt].odp07
       LET g_odp[g_cnt].odp08_odn08 =g_odp[g_cnt].odp08_s - g_odp[g_cnt].odn09
       DISPLAY g_odp[g_cnt].odp08_odn08 TO odp08_odn08
     
       SELECT DISTINCT odp09 INTO l_odp09 
         FROM odp_file 
        WHERE odp01=g_odr01 AND odp07=g_odp[g_cnt].odp07 AND odp13=g_odp13
          AND odp12=g_odp[g_cnt].odp12 AND odp14=g_odr00 AND odp11='Y'
       SELECT DISCTINCT odp10 INTO l_odp10
         FROM odp_file
        WHERE odp01=g_odr01 AND odp07=g_odp[g_cnt].odp07 AND odp13=g_odp13
          AND odp12=g_odp[g_cnt].odp12 AND odp14=g_odr00 AND odp11='Y'
       LET g_odp[g_cnt].odp09_s = l_odp09 * g_odp[g_cnt].odp08_s
       LET g_odp[g_cnt].odp10_s = l_odp10 * g_odp[g_cnt].odp08_s
       CALL cl_digcut(g_odp[g_cnt].odp09_s,t_azi04) RETURNING g_odp[g_cnt].odp09_s
       CALL cl_digcut(g_odp[g_cnt].odp10_s,t_azi04) RETURNING g_odp[g_cnt].odp10_s
       DISPLAY g_odp[g_cnt].odp09_s,g_odp[g_cnt].odp10_s  TO odp09_s,odp10_s
       LET g_cnt = g_cnt + 1                                                    
       IF g_cnt > g_max_rec THEN                                                
          CALL cl_err( '', 9035, 0 )                                            
          EXIT FOREACH                                                          
       END IF                                                               

   END FOREACH
    
   CALL g_odp.deleteElement(g_cnt)                                              
                                                                                
   LET g_rec_b1=g_cnt-1                                                          
   DISPLAY g_rec_b1 TO FORMONLY.cn1                                              
   LET g_cnt = 0 
END FUNCTION

FUNCTION i406_b_fill_3(p_wc4)   #客戶訂貨明細
DEFINE p_wc  STRING 
DEFINE p_wc3 STRING
DEFINE p_wc2 STRING 
DEFINE p_wc4 STRING
DEFINE field_array  DYNAMIC ARRAY OF LIKE type_file.chr1000
DEFINE l_color LIKE agd_file.agd02
DEFINE l_size  LIKE agd_file.agd02
DEFINE l_odr07 LIKE odr_file.odr07
DEFINE l_odr03 LIKE odr_file.odr03
DEFINE l_ima151 like ima_file.ima151  #FUN-C40043
DEFINE l_imx00  LIKE imx_file.imx00
#FUN-C60027-----ADD------STR------
DEFINE l_ima940_1 LIKE ima_file.ima940 
DEFINE l_ima941_1 LIKE ima_file.ima941
DEFINE l_ima940_2 LIKE ima_file.ima940
DEFINE l_ima941_2 LIKE ima_file.ima941
#FUN-C60027-----ADD------end--------

   IF cl_null(p_wc4) THEN
      LET p_wc4=" 1=1"
   END IF
   IF g_odp.getLength()=0 OR g_odr2.getLength()=0 THEN
      CALL g_odr.clear()    #TQC-C20172 add
      RETURN
   END IF
   IF cl_null(l_ac1) OR l_ac1=0 THEN LET l_ac1=1 END IF
   IF cl_null(l_ac2) OR l_ac2=0 THEN LET l_ac2=1 END IF
#FUN-C40043------ADD----STR-------
   SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=g_odp[l_ac1].odp07

   IF l_ima151='Y' THEN 
#FUN-C40043-------ADD----END-------   

      LET g_sql="SELECT odr02,odr04,odr05,odr07,odr03 FROM odr_file,imx_file ",
                " WHERE odr01='",g_odr01,"'",
                "   AND odr00='",g_odr00,"'",
                "   AND ",p_wc4 CLIPPED,
                "   AND odr03=imx000",
                "   AND odr02='",g_odr2[l_ac2].odr02_2, "'",
                "   AND odr07='",g_odp[l_ac1].odp12,"'",
                "   AND imx00='",g_odp[l_ac1].odp07,"'"
#FUN-C40043-----ADD----STR----
   ELSE
      LET g_sql="SELECT odr02,odr04,odr05,odr07,odr03 FROM odr_file",
             " WHERE odr01='",g_odr01,"'",
             "   AND odr00='",g_odr00,"'",
             "   AND ",p_wc4 CLIPPED,
             "   AND odr02='",g_odr2[l_ac2].odr02_2, "'",
             "   AND odr07='",g_odp[l_ac1].odp12,"'",
             "   AND odr03='",g_odp[l_ac1].odp07,"'"
   END IF 
#FUN-C40043------ADD----END----   

   PREPARE i406_odrp1 FROM g_sql
   DECLARE i406_odr1 CURSOR FOR i406_odrp1
 
   CALL g_odr.clear() 
   OPEN i406_odr1
   LET g_cnt=1
   FOREACH  i406_odr1 
    INTO g_odr[g_cnt].odr02,g_odr[g_cnt].odr04,g_odr[g_cnt].odr05,g_odr[g_cnt].odr07,l_odr03
      IF l_ima151='Y' THEN #FUN-C40043-------ADD-
#FUN-C60027------mark------END--- 
#         SELECT tqa02 INTO g_odr[g_cnt].agd02_1 FROM tqa_file,imx_file WHERE imx000=l_odr03 AND imx01=tqa01 AND tqa03='25'
#         SELECT tqa02 INTO g_odr[g_cnt].agd02_2 FROM tqa_file,imx_file WHERE imx000=l_odr03 AND imx02=tqa01 AND tqa03='26'
#FUN-C60027------MARK----END---
#FUN-C60027------ADD----STR-----
          SELECT ima940 INTO l_ima940_1 FROM ima_file WHERE ima01=g_odp[l_ac1].odp07
          SELECT ima941 INTO l_ima941_1 FROM ima_file WHERE ima01=g_odp[l_ac1].odp07
          SELECT ima940 INTO l_ima940_2 FROM ima_file WHERE ima01=l_odr03
          SELECT ima941 INTO l_ima941_2 FROM ima_file WHERE ima01=l_odr03
          SELECT agd03 INTO g_odr[g_cnt].agd02_1 FROM agd_file WHERE agd01=l_ima940_1 AND agd02=l_ima940_2
          SELECT agd03 INTO g_odr[g_cnt].agd02_2 FROM agd_file WHERE agd01=l_ima941_1 AND agd02=l_ima941_2        
#FUN-C60027-------ADD----END------
      END IF    #FUN-C40043-------ADD-
      SELECT occ02 INTO g_odr[g_cnt].occ02 FROM occ_file
         WHERE occ01=g_odr[g_cnt].odr02

      LET g_cnt = g_cnt + 1                                                                                                             
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

   END FOREACH
   
   CALL g_odr.deleteElement(g_cnt)                                              
                                                                               
   LET g_rec_b2=g_cnt-1                                                          
   DISPLAY g_rec_b2 TO FORMONLY.cn3   
                                              
   LET g_cnt = 0 
END FUNCTION

FUNCTION i406_b_fill_2(p_wc4)   #客戶明細   
DEFINE p_wc4           STRING  
DEFINE l_odp09         LIKE odp_file.odp09
DEFINE l_odp10         LIKE odp_file.odp10
DEFINE l_ima151        LIKE ima_file.ima151
DEFINE l_odp10_total   LIKE odp_file.odp10
DEFINE l_odp09_total   LIKE odp_file.odp09
  
   IF cl_null(p_wc4) THEN
      LET p_wc4=" 1=1"
   END IF
   IF g_odp.getLength()=0 THEN
      RETURN
   END IF
   IF cl_null(l_ac1) OR l_ac1=0 THEN LET l_ac1=1 END IF

#TQC-C20376--------modify----begin---
   SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=g_odp[l_ac1].odp07
   IF l_ima151='Y' THEN
      LET g_sql="SELECT DISTINCT odr02,'','','','','','','','','',odr06",#FUN-B90101 add odr06
                " FROM odr_file,imx_file ",     
                " WHERE odr01='",g_odr01,"'",
                "   AND odr00='",g_odr00,"'",
                "   AND imx000=odr03 ",       
                "   AND imx00='",g_odp[l_ac1].odp07,"'",
                "   AND odr07='",g_odp[l_ac1].odp12,"'",
                "   AND ",p_wc4 CLIPPED
   ELSE
      LET g_sql="SELECT DISTINCT odr02,'','','','','','','','','',odr06",
                " FROM odr_file ",
                " WHERE odr01='",g_odr01,"'",
                "   AND odr00='",g_odr00,"'",
                "   AND odr03='",g_odp[l_ac1].odp07,"'",
                "   AND odr07='",g_odp[l_ac1].odp12,"'",
                "   AND ",p_wc4 CLIPPED
   END IF
#TQC-C20376--------modify----begin---
  
   LET g_sql=g_sql CLIPPED

   PREPARE i406_odrpb3 FROM g_sql                                                   
   DECLARE odr_cs3 CURSOR FOR i406_odrpb3 
   
   CALL g_odr2.clear()                                                           
   LET g_cnt = 1                                                                
                                                                               
   FOREACH odr_cs3 INTO g_odr2[g_cnt].*                           
      IF SQLCA.sqlcode THEN                                                    
         CALL cl_err('foreach:',SQLCA.sqlcode,1)                               
         EXIT FOREACH
      END IF
      SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
       WHERE azi01=g_odr2[g_cnt].odr02_2

      SELECT occ02 INTO g_odr2[g_cnt].occ02_2 FROM occ_file
         WHERE occ01=g_odr2[g_cnt].odr02_2
      IF l_ima151='Y' THEN
         SELECT SUM(odr05) INTO g_odr2[g_cnt].odr05_s 
          FROM odr_file,imx_file
         WHERE odr01=g_odr01 AND odr00=g_odr00
           AND odr02=g_odr2[g_cnt].odr02_2
           AND odr03=imx000 AND imx00=g_odp[l_ac1].odp07
           AND odr07=g_odp[l_ac1].odp12
      ELSE
         SELECT SUM(odr05) INTO g_odr2[g_cnt].odr05_s
          FROM odr_file
         WHERE odr01=g_odr01 AND odr00=g_odr00
           AND odr02=g_odr2[g_cnt].odr02_2
           AND odr03=g_odp[l_ac1].odp07
           AND odr07=g_odp[l_ac1].odp12
      END IF

      SELECT DISTINCT odp09 INTO l_odp09 FROM odp_file
        WHERE odp01=g_odr01 AND odp02=g_odr2[g_cnt].odr02_2 AND odp13=g_odp13 AND odp11='Y'
          AND odp07=g_odp[l_ac1].odp07 AND odp12= g_odp[l_ac1].odp12 AND odp14=g_odr00
      SELECT DISTINCT odp10 INTO l_odp10 FROM odp_file
        WHERE odp01=g_odr01 AND odp02=g_odr2[g_cnt].odr02_2 AND odp13=g_odp13 AND odp11='Y'
          AND odp07=g_odp[l_ac1].odp07 AND odp12= g_odp[l_ac1].odp12 AND odp14=g_odr00
   
      LET g_odr2[g_cnt].odp09=l_odp09*g_odr2[g_cnt].odr05_s 
      LET g_odr2[g_cnt].odp10=l_odp10*g_odr2[g_cnt].odr05_s
      CALL cl_digcut(g_odr2[g_cnt].odp09,t_azi04) RETURNING g_odr2[g_cnt].odp09
      CALL cl_digcut(g_odr2[g_cnt].odp10,t_azi04) RETURNING g_odr2[g_cnt].odp10
     
      SELECT odo03 INTO g_odr2[g_cnt].odo03 FROM odo_file 
        WHERE odo01=g_odr01 AND odo02=g_odr2[g_cnt].odr02_2
      SELECT odo04 INTO g_odr2[g_cnt].odo04 FROM odo_file 
        WHERE odo01=g_odr01 AND odo02=g_odr2[g_cnt].odr02_2

      SELECT SUM(odp09*odr05),SUM(odp10*odr05) INTO g_odr2[g_cnt].odp09_total,g_odr2[g_cnt].odp10_total
        FROM odp_file,odr_file,imx_file
       WHERE odp01=g_odr01 AND odp02=g_odr2[g_cnt].odr02_2 AND odp13=g_odp13
         AND odp14=g_odr00 AND odr00=odp14  AND odr01=odp01 AND odp02=odr02 
         AND odp12=odr07 AND imx00=odp07 AND imx000=odr03  AND odp11='Y'
      IF cl_null(g_odr2[g_cnt].odp09_total) THEN LET g_odr2[g_cnt].odp09_total=0 END IF
      IF cl_null(g_odr2[g_cnt].odp10_total) THEN LET g_odr2[g_cnt].odp10_total=0 END IF
      SELECT SUM(odp09*odr05),SUM(odp10*odr05) INTO l_odp09_total,l_odp10_total
        FROM odp_file,odr_file
       WHERE odp01=g_odr01 AND odp02=g_odr2[g_cnt].odr02_2 AND odp13=g_odp13
         AND odp14=g_odr00 AND odr00=odp14  AND odr01=odp01 AND odp02=odr02
         AND odp12=odr07 AND odp07=odr03  AND odp11='Y'
      IF cl_null(l_odp09_total) THEN LET l_odp09_total=0 END IF  #TQC-C40197--MODIFY g_odr2[g_cnt].odp09_total-->l_odp09_total
      IF cl_null(l_odp10_total) THEN LET l_odp10_total=0 END IF  #TQC-C40197--MODIFY g_odr2[g_cnt].odp10_total-->l_odp10_total
      LET g_odr2[g_cnt].odp09_total=g_odr2[g_cnt].odp09_total+l_odp09_total
      LET g_odr2[g_cnt].odp10_total=g_odr2[g_cnt].odp10_total+l_odp10_total

      CALL cl_digcut(g_odr2[g_cnt].odp09_total,t_azi04) RETURNING g_odr2[g_cnt].odp09_total
      CALL cl_digcut(g_odr2[g_cnt].odp10_total,t_azi04) RETURNING g_odr2[g_cnt].odp10_total

      SELECT SUM(odr05) INTO g_odr2[g_cnt].odr05_total
        FROM odr_file 
       WHERE odr00=g_odr00 
         AND odr01=g_odr01
         AND odr02=g_odr2[g_cnt].odr02_2

      LET g_cnt = g_cnt + 1                                                    
      IF g_cnt > g_max_rec THEN                                                
         CALL cl_err( '', 9035, 0 )                                            
         EXIT FOREACH                                                          
      END IF                                                               
   END FOREACH
   
   CALL g_odr2.deleteElement(g_cnt)
   LET g_rec_b3=g_cnt-1                                                          
   DISPLAY g_rec_b3 TO FORMONLY.cn2                                              
   LET g_cnt = 0 
   
END FUNCTION    

FUNCTION i406_b_fill()
   DEFINE l_odp09 LIKE odp_file.odp09
   DEFINE l_odp10 LIKE odp_file.odp10  
   DEFINE l_n LIKE type_file.num5

   LET g_sql="SELECT DISTINCT odp07,'','','','','','',odp12,'' FROM odp_file ",  #FUN-C70082--add ''
             " WHERE odp01='",g_odr01,"'",
             "   AND odp11 = 'Y' ",  #FUN-B90101 add
             "   AND odp13 = '",g_odp13,"'", 
             "   AND odp14 IS NULL "   
 
   DISPLAY g_sql

   PREPARE i406_pb FROM g_sql                                                   
   DECLARE odp_cs CURSOR FOR i406_pb 
   
   CALL g_odp.clear()                                                           
   LET g_cnt = 1                                                                
                                                                                
   FOREACH odp_cs INTO g_odp[g_cnt].*                           
      IF SQLCA.sqlcode THEN                                                    
         CALL cl_err('foreach:',SQLCA.sqlcode,1)                               
         EXIT FOREACH
      END IF

      SELECT ima02 INTO g_odp[g_cnt].ima02 
        FROM ima_file 
       WHERE ima01=g_odp[g_cnt].odp07

      #FUN-C70082---add---begin--------      
      SELECT ima02 INTO g_odp[g_cnt].ima02_1
        FROM ima_file
       WHERE ima01=g_odp[g_cnt].odp12
      #FUN-C70082---add---end----------

      SELECT SUM(odp08) INTO g_odp[g_cnt].odp08_s 
        FROM odp_file
       WHERE odp01=g_odr01 AND odp07=g_odp[g_cnt].odp07 AND odp11='Y'  #TQC-C20376 add odp11='Y'
         AND odp12=g_odp[g_cnt].odp12 AND odp14 IS NULL AND odp13=g_odp13
      SELECT odn09 INTO g_odp[g_cnt].odn09                             #TQC-C20418 modify odn08->>odn09
        FROM odn_file
       WHERE odn01=g_odr01 AND odn05=g_odp[g_cnt].odp07
      LET g_odp[g_cnt].odp08_odn08 =g_odp[g_cnt].odp08_s - g_odp[g_cnt].odn09

      SELECT odp09 INTO l_odp09 
        FROM odp_file  
       WHERE odp01=g_odr01 AND odp07=g_odp[g_cnt].odp07
         AND odp12=g_odp[g_cnt].odp12 AND odp14 IS NULL
         AND odp13=g_odp13 AND odp11='Y'
      SELECT odp10 INTO l_odp10 
        FROM odp_file  
       WHERE odp01=g_odr01 AND odp07=g_odp[g_cnt].odp07 
         AND odp12=g_odp[g_cnt].odp12 AND odp14 IS NULL
         AND odp13=g_odp13 AND odp11='Y'

      LET g_odp[g_cnt].odp09_s = l_odp09 * g_odp[g_cnt].odp08_s
      LET g_odp[g_cnt].odp10_s = l_odp10 * g_odp[g_cnt].odp08_s
      CALL cl_digcut(g_odp[g_cnt].odp09_s,t_azi04) RETURNING g_odp[g_cnt].odp09_s
      CALL cl_digcut(g_odp[g_cnt].odp10_s,t_azi04) RETURNING g_odp[g_cnt].odp10_s
      DISPLAY g_odp[g_cnt].odp09_s,g_odp[g_cnt].odp10_s  TO odp09_s,odp10_s
      DISPLAY g_odp[g_cnt].odp08_odn08 TO odp08_odn08
      LET g_cnt = g_cnt + 1                                                    
      IF g_cnt > g_max_rec THEN                                                
         CALL cl_err( '', 9035, 0 )                                            
         EXIT FOREACH                                                          
      END IF                                                               
   END FOREACH
    
   CALL g_odp.deleteElement(g_cnt)                                              
                                                                                
   LET g_rec_b1=g_cnt-1                                                          
   DISPLAY g_rec_b1 TO FORMONLY.cn1                                              
   LET g_cnt = 0 
   IF g_rec_b1=0 THEN
      CALL cl_err( '','axm1111', 0 )
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION

FUNCTION i406_a()
DEFINE li_result    LIKE type_file.num5
   MESSAGE ""
   CLEAR FORM   
   CALL g_odp.clear()
   CALL g_odr.clear()
   CALL g_odr2.clear()
   LET g_wc=NULL
   LET g_wc1=NULL
   LET g_wc2=NULL
   LET g_wc3=NULL
   LET g_wc4=NULL
   CALL cl_opmsg('a')
   WHILE TRUE
      BEGIN WORK   #FUN-B20005 add
      CALL i406_i()
      IF INT_FLAG THEN                          
         INITIALIZE g_odr01 TO NULL
         INITIALIZE g_odr00 TO NULL
         INITIALIZE g_odp13 TO NULL
         CALL g_odp.clear()
         CALL g_odr.clear()
         CALL g_odr2.clear()
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         ROLLBACK WORK  #FUN-B20005 add
         EXIT WHILE
      END IF

      IF NOT i406_b_fill() THEN
         ROLLBACK WORK
         CONTINUE WHILE
      END IF

      CALL s_auto_assign_no("axm",g_odr00,g_today,'66',"odr_file","odr00","","","")
                  RETURNING li_result,g_odr00
      IF (NOT li_result) THEN
         ROLLBACK WORK
         CONTINUE WHILE
      END IF

      DISPLAY g_odr00 TO odr00
      IF NOT i406_insert_odr() THEN
         ROLLBACK WORK
         CONTINUE WHILE
      END IF

      COMMIT WORK
      EXIT WHILE
  END WHILE
END FUNCTION

#新增時，輸入訂貨會編號自動帶出款式匯總和客戶訂貨明細資料
FUNCTION i406_i()
DEFINE l_cnt        LIKE type_file.num5
DEFINE li_result    LIKE type_file.num5

 INPUT  g_odr00,g_odr01,g_odp13 FROM odr00,odr01,odp13

    BEFORE INPUT
       CALL cl_set_docno_format("odr00")

    AFTER FIELD odr00
       IF cl_null(g_odr00) THEN
          CALL cl_err("odr00",-386,1)
          NEXT FIELD odr00
       ELSE
          CALL s_check_no("axm",g_odr00,g_odr00_t,"66","odr_file","odr00","") 
           RETURNING li_result,g_odr00
          IF (NOT li_result) THEN
             LET g_odr00=g_odr00_t
             DISPLAY g_odr00_t TO odr00
             NEXT FIELD odr00
          END IF
       END IF

    AFTER FIELD odr01
       IF NOT cl_null(g_odr01) THEN 
          SELECT COUNT(*) INTO l_cnt FROM odp_file
           WHERE odp01  = g_odr01 AND odp11 ='Y' AND odp14 IS NULL
          IF l_cnt = 0 THEN 
             CALL cl_err('','axm1016',0)
             NEXT FIELD odr01
          ELSE    
            CALL i406_odl02('d')
#            CALL i406_b_fill()
            CALL cl_show_fld_cont()
          END IF  
       END IF   
    AFTER INPUT
       IF INT_FLAG THEN
          EXIT INPUT
       END IF  
       
       ON ACTION controlp
          IF INFIELD(odr01) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form="q_odl01_2"  
             CALL cl_create_qry() RETURNING g_odr01
             DISPLAY g_odr01 TO odr01
             NEXT FIELD odr01
          END IF
       IF INFIELD(odr00) THEN #查詢單据
          LET g_t1=s_get_doc_no(g_odr00)
          CALL q_oay(FALSE,FALSE,g_t1,'66','AXM') RETURNING g_t1
          LET g_odr00=g_t1
          DISPLAY g_odr00 TO odp00
          NEXT FIELD odr00
       END IF
#FUN-C60021----ADD----STR--
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about  
         CALL cl_about()

     ON ACTION help 
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()
#FUN-C60021---ADD-----END---

   END INPUT
END FUNCTION

#FUN-B20031-----modify----------------begin-------------------
FUNCTION i406_b()   #新增時可修改客戶訂貨確認數量
  DEFINE l_lock_sw     LIKE type_file.chr1
  DEFINE l_color       LIKE agd_file.agd02
  DEFINE l_size        LIKE agd_file.agd02
  DEFINE p_cmd1        LIKE type_file.chr1
  DEFINE p_cmd2        LIKE type_file.chr1
  DEFINE p_cmd3        LIKE type_file.chr1
  DEFINE l_count       LIKE type_file.num5
  DEFINE l_odr03       LIKE odr_file.odr03
  DEFINE l_odr05_t     LIKE odr_file.odr05
  DEFINE l_ima151      LIKE ima_file.ima151  #FUN-C40043---ADD---

   IF cl_null(g_odr01) OR cl_null(g_odr00) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT COUNT(*)  INTO l_count FROM odr_file,oea_file
    WHERE odr00=g_odr00 AND odr01=g_odr01  AND oea01=odr06 AND oeaslk02=g_odp13
   IF l_count>0 AND NOT cl_null(l_count) THEN
      CALL cl_err(g_odr00,'axm1106',0)
      RETURN
   END IF

   
   CALL cl_set_act_visible("accept,cancel",TRUE) 
   CALL cl_opmsg('b')
   LET g_forupd_sql =  "SELECT * ",
                       " FROM odr_file",
                       " WHERE odr00=? AND odr01=? AND odr02=? AND odr03=? AND odr07=? ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i406_bcl CURSOR FROM g_forupd_sql


 DIALOG ATTRIBUTE(UNBUFFERED)

     INPUT ARRAY g_odr  FROM s_odr.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,
                    APPEND ROW=FALSE)
        BEFORE INPUT
           LET g_action_choice=''
           CALL cl_set_comp_required("odp07",FALSE)
           CALL cl_set_comp_entry("odp07",FALSE)

        BEFORE ROW
           LET p_cmd2=''
           LET l_ac3 = ARR_CURR()
           LET l_lock_sw='N'

           BEGIN WORK
           IF g_rec_b2>=l_ac3 THEN
              LET p_cmd2='u'
              CALL i406_set_no_entry('u') 
              LET l_odr05_t=g_odr[l_ac3].odr05
           END IF  #FUN-B20005 add
   
        AFTER FIELD odr05
           IF cl_null(g_odr[l_ac3].odr05) THEN
              CALL cl_err(g_odr[l_ac3].odr05,'axm1108',1)
              NEXT FIELD odr05
           END IF
           IF g_odr[l_ac3].odr05<0 THEN
              CALL cl_err(g_odr[l_ac3].odr05,'axm1101',0)
              NEXT FIELD odr05
           END IF
           IF g_odr[l_ac3].odr05>g_odr[l_ac3].odr04 THEN
              CALL cl_err(g_odr[l_ac3].odr05,'axm1109',1)
              NEXT FIELD odr05
           END IF
      
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_odr[l_ac3].odr05 = l_odr05_t
              CLOSE i406_bcl
              ROLLBACK WORK
              EXIT DIALOG
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_odr[l_ac3].odr02,-263,1)
              LET g_odr[l_ac3].odr05 = l_odr05_t 
           ELSE
              SELECT sma46 INTO l_ps FROM sma_file
              IF cl_null(l_ps) THEN
                 LET l_ps=' '
              END IF
              SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=g_odp[l_ac1].odp07  #FUN-C40043--ADD--   
              SELECT DISTINCT agd02 INTO l_color FROM agd_file,ima_file WHERE ima940=agd01 AND agd03=g_odr[l_ac3].agd02_1 AND ima01=g_odp[l_ac1].odp07
              SELECT DISTINCT agd02 INTO l_size  FROM agd_file,ima_file WHERE ima941=agd01 AND agd03=g_odr[l_ac3].agd02_2 AND ima01=g_odp[l_ac1].odp07
              IF l_ima151='Y' THEN                           #FUN-C40043--ADD--    
                 LET l_odr03=g_odp[l_ac1].odp07 CLIPPED,l_ps,l_color CLIPPED,l_ps,l_size
              ELSE                                           #FUN-C40043--ADD-- 
                 LET l_odr03=g_odp[l_ac1].odp07 CLIPPED      #FUN-C40043--ADD--
              END IF                                         #FUN-C40043--ADD--        
              UPDATE odr_file SET odr05=g_odr[l_ac3].odr05
                 WHERE odr02=g_odr[l_ac3].odr02 
                   AND odr01=g_odr01 
                   AND odr03=l_odr03 
                   AND odr00=g_odr00 
                   AND odr07=g_odr[l_ac3].odr07
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","odr_file",g_odr01,g_odr[l_ac3].odr05,SQLCA.sqlcode,"","",1)   
                 LET g_odr[l_ac3].odr05 = l_odr05_t
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF      
           END IF 
 
       AFTER ROW
           
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i406_bcl
             ROLLBACK WORK
             EXIT DIALOG
          END IF
          CLOSE i406_bcl
          COMMIT WORK
      

       ON IDLE g_idle_seconds                            
          CALL cl_on_idle()
          CONTINUE DIALOG

    END INPUT

       ON ACTION accept
          LET g_action_choice="detail"
          ACCEPT DIALOG

        ON ACTION cancel
          LET g_action_choice="exit"
          EXIT DIALOG

       ON ACTION locale
         LET g_action_choice="locale"
         EXIT DIALOG

        ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

       ON ACTION controlg
          CALL cl_cmdask()
       ON ACTION controls
          CALL cl_set_head_visible("main,language,info","AUTO")
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG

       ON ACTION EXIT
          LET INT_FLAG=TRUE
          EXIT DIALOG

         ON ACTION close                #視窗右上角的"x"
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG


  END DIALOG

  CALL cl_set_act_visible("accept,cancel",TRUE)

END FUNCTION

#FUN-B20031-modify----------------end-----------------------

FUNCTION i406_insert_odr()
  DEFINE l_odr  RECORD LIKE odr_file.*
  DEFINE l_odq03       LIKE odq_file.odq03
  DEFINE l_success     LIKE type_file.chr1
  DEFINE l_ima151      LIKE ima_file.ima151   #FUN-C40043----ADD----
#FUN-B90101--add--begin--
   LET g_sql = "SELECT DISTINCT odq02,odq03,odq06,odq08 FROM odq_file,odp_file ",
               " WHERE odp01=odq01 AND odp02=odq02 AND odp06=odq04 AND odp00=odq00 AND odp07=odq03 ",
               "   AND odp11='Y' AND odp12=odq08 AND odq01='",g_odr01,"' AND odp14 IS NULL",
               "   AND odp13='",g_odp13,"'"     
#FUN-B90101--add--end--
   PREPARE i406_insert_odrpre FROM g_sql
   DECLARE i406_insert_odrcs CURSOR FOR i406_insert_odrpre

   LET l_success='Y'
   FOREACH i406_insert_odrcs INTO l_odr.odr02,l_odq03,l_odr.odr03,l_odr.odr07
#FUN-C40043----ADD----STR----
      SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=l_odq03
      IF l_ima151<>'Y' THEN
         LET l_odr.odr03=l_odq03
      END IF
#FUN-C40043----ADD----END---- 
      LET l_odr.odr01=g_odr01
      LET l_odr.odr00=g_odr00
      SELECT SUM(odq07) INTO l_odr.odr04 FROM odq_file,odp_file
        WHERE odq01=l_odr.odr01 AND odq02=l_odr.odr02
          AND odq03=l_odq03 AND odq06=l_odr.odr03 AND odq08=l_odr.odr07
          AND odp00=odq00 AND odp01=odq01 AND odp02=odq02
          AND odp06=odq04 AND odp12=odq08 AND odp07=odq03
          AND odp11='Y' AND odp14 IS NULL 
          AND odp13=g_odp13  

      LET l_odr.odr05=l_odr.odr04
   
      INSERT INTO odr_file VALUES (l_odr.*)
      IF SQLCA.sqlcode THEN 
         CALL cl_err3("ins","odr_file",g_odr01,"",SQLCA.SQLCODE,"","",1)  
         LET l_success = 'N'
         EXIT FOREACH
      END IF          
   END FOREACH
   UPDATE odp_file SET odp14=g_odr00 WHERE odp11='Y' AND odp01=g_odr01 AND odp13=g_odp13 AND odp14 IS NULL
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","odp_file",'','',SQLCA.sqlcode,"","",0)
      LET l_success = 'N'
   END IF
   IF l_success='Y' THEN
      RETURN TRUE
   ELSE
      RETURN FALSE
   END IF

END FUNCTION

#FUNCTION i406_reflesh()
#   DISPLAY ARRAY g_odr TO s_odr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #shaoyong
#      BEFORE DISPLAY
#         EXIT DISPLAY
#   END DISPLAY
#
#   DISPLAY ARRAY g_odr2 TO s_odr2.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #shaoyong   
#      BEFORE DISPLAY                                                  
#         EXIT DISPLAY                                             
#   END DISPLAY                                                    
#END FUNCTION
#
#FUNCTION i406_reflesh1()
#   DISPLAY ARRAY g_odr2 TO s_odr2.* ATTRIBUTE(COUNT=g_rec_b)
#      BEFORE ROW
#        EXIT DISPLAY
#   END DISPLAY
#END FUNCTION
#
#FUNCTION i406_reflesh2()
#   DISPLAY ARRAY g_odr TO s_odr.* ATTRIBUTE(COUNT=g_rec_b)
#      BEFORE ROW
#         EXIT DISPLAY
#   END DISPLAY
#END FUNCTION
   
FUNCTION i406_turnout()   #轉出訂單
  DEFINE l_odp07          LIKE odp_file.odp07
  DEFINE l_occ09          LIKE occ_file.occ09
  DEFINE l_occ07          LIKE occ_file.occ07
  DEFINE l_occ42          LIKE occ_file.occ42
  DEFINE l_occ41          LIKE occ_file.occ41
  DEFINE l_occ44          LIKE occ_file.occ44
  DEFINE l_occ45          LIKE occ_file.occ45
  DEFINE l_color          LIKE agd_file.agd02
  DEFINE li_result        LIKE type_file.num5 
  DEFINE g_odr06          LIKE odr_file.odr06
  DEFINE l_odr02          LIKE odr_file.odr02       #FUN-B90101 add
  DEFINE l_odr05          LIKE odr_file.odr05       #FUN-B90101 add
  DEFINE l_cnt            LIKE type_file.num5       #FUN-B90101 add 
  DEFINE l_count          LIKE type_file.num5
  DEFINE l_n              LIKE type_file.num5
  DEFINE l_amount         LIKE type_file.num20_6
  DEFINE l_odo03          LIKE odo_file.odo03
  DEFINE l_odo04          LIKE odo_file.odo04
  DEFINE l_ima_yy         LIKE imaslk_file.imaslk05
  DEFINE l_now_yy         LIKE imaslk_file.imaslk05
  DEFINE l_ima151         LIKE ima_file.ima151     #TQC-C20376
  DEFINE l_sql            STRING
  DEFINE l_oea    RECORD  LIKE oea_file.*
  DEFINE l_oeb    RECORD  LIKE oeb_file.*
  DEFINE l_oebi   RECORD  LIKE oebi_file.*
  DEFINE l_oebslk RECORD  LIKE oebslk_file.*
  DEFINE l_odr    DYNAMIC ARRAY OF RECORD
                   odr02 LIKE odr_file.odr02,
                   odr03 LIKE odr_file.odr03
                  END RECORD
  DEFINE l_oeb04          LIKE oeb_file.oeb04
  DEFINE l_oebslk04       LIKE oebslk_file.oebslk04      
  DEFINE l_oebslk09       LIKE oebslk_file.oebslk09
  DEFINE l_oebslk091      LIKE oebslk_file.oebslk091 
  DEFINE l_oebslk092      LIKE oebslk_file.oebslk092 
  DEFINE l_oebslk12       LIKE oebslk_file.oebslk12 
  DEFINE l_oebslk13       LIKE oebslk_file.oebslk13
  DEFINE l_oebslk14       LIKE oebslk_file.oebslk14
  DEFINE l_oebslk14t      LIKE oebslk_file.oebslk14t 
  DEFINE l_oebslk23       LIKE oebslk_file.oebslk23
  DEFINE l_oebslk24       LIKE oebslk_file.oebslk24
  DEFINE l_oebslk25       LIKE oebslk_file.oebslk25
  DEFINE l_oebslk26       LIKE oebslk_file.oebslk26
  DEFINE l_oebslk28       LIKE oebslk_file.oebslk28
  DEFINE l_oebslk1006     LIKE oebslk_file.oebslk1006
  DEFINE l_imaag          LIKE ima_file.imaag
  DEFINE l_count1          LIKE type_file.num20_6   #FUN-C40043---ADD------
  DEFINE l_occ02          LIKE occ_file.occ02       #TQC-C40197---ADD------

   IF cl_null(g_odr01) OR cl_null(g_odr00) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT COUNT(*)  INTO l_count FROM odr_file,oea_file
    WHERE odr00=g_odr00 AND odr01=g_odr01  AND oea01=odr06 AND oeaslk02=g_odp13
   IF l_count>0 AND NOT cl_null(l_count) THEN
      CALL cl_err(g_odr00,'axm1106',0)
      RETURN
   END IF
   DECLARE cur_checkodr CURSOR FOR SELECT odr02,SUM(odr05) FROM odr_file
                                    WHERE odr00=g_odr00 AND odr01=g_odr01 
                                    GROUP BY odr02
   FOREACH cur_checkodr INTO l_odr02,l_odr05
      SELECT odo03,od04 INTO l_odo03,l_odo04 FROM odo_file WHERE odo01=g_odr01 AND odo02=l_odr02
      IF cl_null(l_odo03) THEN LET l_odo03=0 END IF
      IF cl_null(l_odo04) THEN LET l_odo04=0 END IF
      SELECT SUM(odp09*odr05) INTO l_amount FROM odp_file,odr_file,imx_file
        WHERE odp01=g_odr01 AND odp02=l_odr02 AND odp13=g_odp13  AND odp14=g_odr00
          AND odr00=odp14  AND odr01=odp01 AND odp02=odr02 AND odp12=odr07
          AND imx00=odp07 AND imx000=odr03 AND odp11='Y'
#FUN-C40043-------ADD-------STR------
      SELECT SUM(odp09*odr05) INTO l_count1 FROM odp_file,odr_file
        WHERE odp01=g_odr01 AND odp02=l_odr02 AND odp13=g_odp13  AND odp14=g_odr00
          AND odr00=odp14  AND odr01=odp01 AND odp02=odr02 AND odp12=odr07
          AND odr03=odp07  AND odp11='Y'
      IF cl_null(l_amount) THEN LET l_amount=0 END IF
      IF cl_null(l_count1) THEN LET l_count1=0 END IF
      LET l_amount=l_amount+l_count1
#FUN-C40043-------ADD-------END-------

      IF l_odr05<l_odo03 AND l_amount<l_odo04 THEN
         CALL cl_err('',1111,0)
         EXIT FOREACH
      END IF
   
   END FOREACH

   INITIALIZE l_oea.* TO NULL
   INITIALIZE l_oeb.* TO NULL
   INITIALIZE l_oebslk.* TO NULL       #FUN-B90101 add  
  
   BEGIN WORK

   LET g_success = 'Y'                 #FUN-B90101 add    
   LET g_t1=s_get_doc_no(l_oea.oea01)
   CALL q_oay(FALSE,FALSE,g_t1,'30','AXM') RETURNING g_t1
  
   LET g_sql="SELECT DISTINCT odr02 FROM odr_file WHERE odr01='",g_odr01,"' AND odr00='",g_odr00,"'"
   PREPARE i406_recordp FROM g_sql
   DECLARE i406_recordcs CURSOR FOR i406_recordp
   OPEN i406_recordcs
   LET g_cnt=1
   FOREACH i406_recordcs INTO l_odr[g_cnt].odr02
      IF SQLCA.sqlcode THEN                                                    
         CALL cl_err('foreach:',SQLCA.sqlcode,1)                               
         EXIT FOREACH
      END IF
       
      INITIALIZE l_oea.* TO NULL
      LET l_oea.oea00='1'
      LET l_oea.oea01=g_t1
      CALL s_auto_assign_no("axm",l_oea.oea01,g_today,"30","oea_file","oea01",g_plant,"","")
                  RETURNING li_result,l_oea.oea01
      IF (NOT li_result) THEN
         LET g_success='N'
         EXIT FOREACH
      END IF
      SELECT occ09,occ07,occ42,occ41,occ44,occ45 INTO  l_occ09,l_occ07,l_occ42,l_occ41,l_occ44,l_occ45     
         FROM occ_file WHERE occ01=l_odr[g_cnt].odr02
#TQC-C40197------ADD---STR----
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=l_odr[g_cnt].odr02
       LET l_oea.oea032=l_occ02
#TQC-C40197------ADD---end------
       LET l_oea.oea04=l_occ09
       LET l_oea.oea17=l_occ07
       LET l_oea.oea23=l_occ42
       LET l_oea.oea02=g_today
       LET l_oea.oea03=l_odr[g_cnt].odr02
       CALL s_curr3(l_oea.oea23,l_oea.oea02,g_oaz.oaz52)  RETURNING l_oea.oea24
       LET l_oea.oea21=l_occ41
       LET l_oea.oea31=l_occ44
       LET l_oea.oea32=l_occ45
       LET l_oea.oeaslk02=g_odp13
       LET l_oea.oeaplant=g_plant
       LET l_oea.oealegal=g_legal
       LET l_oea.oea83=g_plant   #TQC-C40248----ADD------  
       
       SELECT azi03,azi04 INTO t_azi03,t_azi04   
         FROM azi_file
        WHERE azi01 = l_oea.oea23

       SELECT gec04,gec05,gec07  INTO l_oea.oea211,l_oea.oea212,l_oea.oea213    
          FROM gec_file  WHERE gec01 = l_oea.oea21
       INSERT INTO oea_file(oea00,oea01,oea02,oea03,oea032,oea04,oea17,oea06,oea08,oea09,oea11,
                            oea12,oea14,oea15,oea61,oea62,oea63,oea85,oeaslk02,oea917,
                            oea213,oea37,oeamksg,oea50,oea18,oea07,oea65,oealegal,oeaplant,oea1004,
                            oea1015,oeaslk01,oea23,oea24,oea21,oea31,oea32,
                            oea211,oea212,oeahold,oeaconf,oea49,oea72,oea044,oea41,oea42,oea43,oea44,
                            oea33,oea161,oea162,oea163,oea261,oea262,oea263,
                            oea05,oea25,oea26,oea46,oea80,oea81,oea47,oea48,oeaoriu,oea83) #TQC-C40197----add oea032--#TQC-C40248--ADD oea83
                     VALUES('1',l_oea.oea01,g_today,l_odr[g_cnt].odr02,l_oea.oea032,l_oea.oea04,l_oea.oea17,0,'1',1,'B',
                            '',g_user,g_grup,0,0,0,' ',g_odp13,'N',  
                            l_oea.oea213,'N','N','N','N','N','N',g_legal,g_plant,'',
                            '','',l_oea.oea23,l_oea.oea24,l_oea.oea21,l_oea.oea31,l_oea.oea32,
                            l_oea.oea211,l_oea.oea212,'','N','0','','','','','','','',0,100,0,0,0,0,'1','','','','','','','',g_user,l_oea.oea83) #TQC-C40197----add oea032-#TQC-C40248--ADD oea83
                            #FUN-C60027--MODIFY oea11 賦值為'B'
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("ins","oea_file",l_oea.oea01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'   
         EXIT FOREACH
      END IF

      LET g_sql = "SELECT DISTINCT odr03 FROM odr_file",
                  "   WHERE odr01 ='",g_odr01,"' AND odr02 ='",l_odr[g_cnt].odr02,"'",
                  "     AND odr00='",g_odr00,"'",
                  "     ORDER BY odr03"
      PREPARE i406_recordp2 FROM g_sql
      DECLARE i406_recordcs2 CURSOR FOR i406_recordp2
      OPEN i406_recordcs2
      LET g_cnt2=1

      FOREACH i406_recordcs2 INTO l_oeb04    
         INITIALIZE l_oeb.* TO NULL
         LET l_oeb.oeb04=l_oeb04
         SELECT ima31 INTO l_oeb.oeb05 FROM ima_file WHERE ima01=l_oeb.oeb04
         SELECT ima02 INTO l_oeb.oeb06 FROM ima_file WHERE ima01=l_oeb.oeb04

         SELECT SUM(odr05) INTO l_oeb.oeb12 FROM odr_file
          WHERE odr00=g_odr00 AND odr01=g_odr01 AND odr02=l_odr[g_cnt].odr02 AND odr03=l_oeb.oeb04
         LET l_oeb.oeb12 = s_digqty(l_oeb.oeb12,l_oeb.oeb05)   #FUN-910088--add--

         SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file 
          WHERE ima01=l_oeb.oeb04
         IF  l_ima151='N' AND l_imaag='@CHILD' THEN
            SELECT DISTINCT odp09 INTO l_oeb.oeb13
              FROM odp_file,imx_file
             WHERE odp01=g_odr01 AND odp07=imx00 AND odp13=g_odp13
               AND odp14=g_odr00 AND odp11='Y'   AND imx000=l_oeb.oeb04
         ELSE
            SELECT DISTINCT odp09 INTO l_oeb.oeb13
              FROM odp_file
             WHERE odp01=g_odr01 AND odp07=l_oeb.oeb04 AND odp13=g_odp13
               AND odp14=g_odr00 AND odp11='Y'
         END IF

         CALL cl_digcut(l_oeb.oeb13,t_azi03) RETURNING l_oeb.oeb13
         LET l_oeb.oeb05_fac=1
         LET l_oeb.oeb916=l_oeb.oeb05
         LET l_oeb.oeb917=l_oeb.oeb12

         IF g_odp13 = '1' THEN
            SELECT occ76 INTO l_oeb.oeb1006 FROM occ_file
             WHERE occ01= l_odr[g_cnt].odr02
         END IF
         IF g_odp13 = '2' THEN
            SELECT occ77 INTO l_oeb.oeb1006 FROM occ_file
             WHERE occ01= l_odr[g_cnt].odr02
         END IF
         IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006= 100 END IF

         LET l_now_yy = YEAR( g_today )
#         SELECT imaslk05 INTO l_ima_yy FROM ima_file WHERE ima01 = l_oeb.oeb04   #TQC-C40197-----MARK---
         SELECT imaslk05 INTO l_ima_yy FROM imaslk_file WHERE ima00 = l_oeb.oeb04  #TQC-C40197----add-----
         IF NOT (cl_null(l_ima_yy) OR l_ima_yy=0) THEN
            LET l_n = l_now_yy - l_ima_yy
            IF l_n>0 THEN
               LET l_oeb.oeb1006 = l_oeb.oeb1006-l_n*10
               IF l_oeb.oeb1006<10 THEN  #最低折扣为10
                  LET l_oeb.oeb1006 = 10
               END IF
            END IF
         END IF
         IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006= 100 END IF
         IF l_oea.oea213 = 'N' THEN
            LET l_oeb.oeb14=l_oeb.oeb917*l_oeb.oeb13*l_oeb.oeb1006/100
            CALL cl_digcut(l_oeb.oeb14,t_azi04) RETURNING l_oeb.oeb14
            LET l_oeb.oeb14t=l_oeb.oeb14*(1+l_oea.oea211/100)
            CALL cl_digcut(l_oeb.oeb14t,t_azi04) RETURNING l_oeb.oeb14t
         ELSE
            LET l_oeb.oeb14t=l_oeb.oeb917*l_oeb.oeb13*l_oeb.oeb1006/100
            CALL cl_digcut(l_oeb.oeb14t,t_azi04) RETURNING l_oeb.oeb14t
            LET l_oeb.oeb14=l_oeb.oeb14t/(1+l_oea.oea211/100)
            CALL cl_digcut(l_oeb.oeb14,t_azi04) RETURNING l_oeb.oeb14
         END IF 
         SELECT ima31_fac INTO l_oeb.oeb05_fac FROM ima_file WHERE ima01 = l_oeb.oeb04
         SELECT imc02 INTO l_oeb.oeb07 FROM imc_file WHERE imc01 = l_oeb.oeb04
         SELECT obk03 INTO l_oeb.oeb11 FROM obk_file WHERE obk01 = l_oeb.oeb04 AND obk02=l_odr[g_cnt].odr02 
         IF l_oeb.oeb37 = 0 OR cl_null(l_oeb.oeb37) THEN LET l_oeb.oeb37 = l_oeb.oeb13  END IF           #FUN-AB0061  
         SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file WHERE oeb01=l_oea.oea01
         IF cl_null(l_oeb.oeb03) THEN LET l_oeb.oeb03=1 END IF
        #SELECT rtz07 INTO l_oeb.oeb09 FROM rtz_file WHERE rtz01=g_plant    #FUN-C90049 mark
         CALL s_get_coststore(g_plant,l_oeb.oeb04) RETURNING l_oeb.oeb09             #FUN-C90049 add
         IF cl_null(l_oeb.oeb09) THEN LET l_oeb.oeb09=' ' END IF
         LET l_oeb.oeb091=' '
         LET l_oeb.oeb092=' '

         LET l_oeb.oeb01   =l_oea.oea01
         LET l_oeb.oeb15   = g_today
         LET l_oeb.oeb16   = g_today
         LET l_oeb.oeb19   = 'N'
         LET l_oeb.oeb23   = 0
         LET l_oeb.oeb24   = 0
         LET l_oeb.oeb25   = 0
         LET l_oeb.oeb26   = 0
         LET l_oeb.oeb28   = 0
         LET l_oeb.oeb29   = 0
         LET l_oeb.oeb32   = g_today
         LET l_oeb.oeb44   = '1'
         LET l_oeb.oeb47   = 0
         LET l_oeb.oeb48   = g_odp13
         LET l_oeb.oeb1003 = '1'
         LET l_oeb.oeb1008 = l_oea.oea21
         LET l_oeb.oeb1009 = l_oea.oea211
         LET l_oeb.oeb1010 = l_oea.oea213
         LET l_oeb.oeb1012 = 'N'
         LET l_oeb.oeb70   = 'N'
        #LET l_oeb.oeb72   = l_oeb.oeb15   #CHI-C80060 mark
         LET l_oeb.oeb72   = NULL          #CHI-C80060 add
         LET l_oeb.oeb905  = 0
         LET l_oeb.oeb910  = l_oeb.oeb05
         LET l_oeb.oeb911  = 1
         LET l_oeb.oeb912  = l_oeb.oeb12
         LET l_oeb.oeb916  = l_oeb.oeb05
         LET l_oeb.oeb917  = l_oeb.oeb12
         LET l_oeb.oeb920  = '0'
         LET l_oeb.oeb930  = s_costcenter(l_oea.oea15)
         LET l_oeb.oebplant=g_plant
         LET l_oeb.oeblegal=g_legal
#TQC-C20454------------add---begin----
         SELECT obk11 INTO l_oeb.oeb906 FROM obk_file WHERE obk01 = l_oeb.oeb04
                                                            AND obk02 = l_oea.oea03
                                                            AND obk05 = l_oea.oea23
         IF cl_null(l_oeb.oeb906) THEN
            LET l_oeb.oeb906 = 'N'
         END IF
#TQC-C20454------------add---end----

         INSERT INTO oeb_file VALUES(l_oeb.*)

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("ins","oeb_file",l_oea.oea01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF

         LET l_oebi.oebi01 = l_oea.oea01
         LET l_oebi.oebi03 = l_oeb.oeb03 
         LET l_oebi.oebiplant = g_plant
         LET l_oebi.oebilegal = g_legal
         INSERT INTO oebi_file VALUES(l_oebi.*)

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("ins","oebi_file",l_oea.oea01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            ROLLBACK WORK
         END IF
         
         LET g_cnt2=g_cnt2+1
      END FOREACH

      LET l_sql = " SELECT imx00,SUM(oeb12),",
                  "  SUM(oeb14),SUM(oeb14t),",
                  "  SUM(oeb23),SUM(oeb24),SUM(oeb25),SUM(oeb26),SUM(oeb28)",
                  " FROM oeb_file,imx_file WHERE oeb04=imx000 AND oeb01 ='",l_oea.oea01,"'",
                  " GROUP BY imx00 ",
                  " ORDER BY imx00"
#款式資料統計

      PREPARE oebslk_pre FROM l_sql
      DECLARE oebslk_cl CURSOR FOR oebslk_pre
      FOREACH oebslk_cl INTO l_oebslk04,l_oebslk12,l_oebslk14,l_oebslk14t,
                             l_oebslk23,l_oebslk24,l_oebslk25,l_oebslk26,l_oebslk28
         IF STATUS THEN 
            CALL cl_err('foreach:',STATUS,1) 
            EXIT FOREACH 
         END IF
         INITIALIZE l_oebslk.* TO NULL   
         LET l_oebslk.oebslk04=l_oebslk04
         LET l_oebslk.oebslk12=l_oebslk12
         LET l_oebslk.oebslk14=l_oebslk14
         LET l_oebslk.oebslk14t=l_oebslk14t
         LET l_oebslk.oebslk23=l_oebslk23
         LET l_oebslk.oebslk24=l_oebslk24
         LET l_oebslk.oebslk25=l_oebslk25
         LET l_oebslk.oebslk26=l_oebslk26
         LET l_oebslk.oebslk28=l_oebslk28

         SELECT DISTINCT oeb09,oeb091,oeb092,oeb13,oeb1006 
           INTO l_oebslk.oebslk09,l_oebslk.oebslk091,l_oebslk.oebslk092,l_oebslk.oebslk13,l_oebslk.oebslk1006
           FROM oeb_file,imx_file 
          WHERE oeb01=l_oea.oea01 AND oeb04=imx000 AND imx00=l_oebslk.oebslk04
         SELECT ima31,ima02 INTO l_oebslk.oebslk05,l_oebslk.oebslk06
           FROM ima_file WHERE ima01=l_oebslk.oebslk04
         SELECT imc02 INTO l_oebslk.oebslk07 FROM imc_file WHERE imc01=l_oebslk.oebslk04
#TQC-C40197----MARK---STR---
#         SELECT img02,img03,img04 INTO l_oebslk.oebslk09,l_oebslk.oebslk091,l_oebslk.oebslk092
#           FROM img_file WHERE img01=l_oebslk.oebslk04
#TQC-C40197----MARK---END-----
         SELECT obk03 INTO l_oebslk.oebslk11 FROM obk_file WHERE obk01=l_oebslk.oebslk04

         LET l_oebslk.oebslk05_fac=1
         LET l_oebslk.oebslk01=l_oea.oea01
         SELECT MAX(oebslk03)+1 INTO l_oebslk.oebslk03
           FROM oebslk_file WHERE oebslk01 = l_oea.oea01
         IF cl_null(l_oebslk.oebslk03) THEN
            LET l_oebslk.oebslk03 = 1
         END IF
         LET l_oebslk.oebslk131=l_oebslk.oebslk13*l_oebslk.oebslk1006/100
         CALL cl_digcut(l_oeb.oeb13,t_azi03) RETURNING l_oeb.oeb13
         CALL cl_digcut(l_oeb.oeb14,t_azi04) RETURNING l_oeb.oeb14
         CALL cl_digcut(l_oeb.oeb14t,t_azi04) RETURNING l_oeb.oeb14t

         LET l_oebslk.oebslk091=' '
         LET l_oebslk.oebslk092=' '
         LET l_oebslk.oebslk23=0
         LET l_oebslk.oebslk24=0
         LET l_oebslk.oebslk25=0
         LET l_oebslk.oebslk26=0
         LET l_oebslk.oebslk28=0
         LET l_oebslk.oebslkplant=g_plant
         LET l_oebslk.oebslklegal=g_legal
         INSERT INTO oebslk_file VALUES (l_oebslk.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","oebslk_file",l_oea.oea01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         UPDATE oebi_file SET oebislk02=l_oebslk.oebslk04,
                              oebislk03=l_oebslk.oebslk03
          WHERE oebi01=l_oea.oea01
            AND oebi03 IN (SELECT oeb03 FROM oeb_file,imx_file
                            WHERE oeb01=l_oea.oea01
                              AND oeb04=imx000
                              AND imx00=l_oebslk.oebslk04)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","oebi_file",l_oea.oea01,l_oebslk.oebslk04,SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF

      END FOREACH

#TQC-C20376------add----begin----------------------
#非多屬性資料處理
      LET l_sql = " SELECT oeb04,oeb09,oeb091,oeb092,oeb12,",
                  " oeb13,oeb14,oeb14t,",
                  " oeb23,oeb24,oeb25,oeb26,oeb28,oeb1006",
                  " FROM oeb_file,ima_file",
                  " WHERE oeb01 ='",l_oea.oea01,"'",
                  "   AND oeb04=ima01",
                  "   AND ima151<>'Y'",
                  "   AND (ima151<>'N' OR imaag<>'@CHILD' OR imaag IS NULL)",
                  "   ORDER BY oeb04 "

      PREPARE oebslk_pre2 FROM l_sql
      DECLARE oebslk_cl2 CURSOR FOR oebslk_pre2
      FOREACH oebslk_cl2 INTO l_oebslk04,l_oebslk09,l_oebslk091,l_oebslk092,
                              l_oebslk12,l_oebslk13,l_oebslk14,l_oebslk14t,
                              l_oebslk23,l_oebslk24,l_oebslk25,l_oebslk26,
                              l_oebslk28,l_oebslk1006
         IF STATUS THEN 
            CALL cl_err('foreach:',STATUS,1) 
            EXIT FOREACH 
         END IF
         INITIALIZE l_oebslk.* TO NULL
         LET l_oebslk.oebslk04=l_oebslk04
         LET l_oebslk.oebslk09=l_oebslk09
         LET l_oebslk.oebslk091=l_oebslk091
         LET l_oebslk.oebslk092=l_oebslk092
         LET l_oebslk.oebslk12=l_oebslk12
         LET l_oebslk.oebslk13=l_oebslk13
         LET l_oebslk.oebslk14=l_oebslk14
         LET l_oebslk.oebslk14t=l_oebslk14t
         LET l_oebslk.oebslk23=l_oebslk23
         LET l_oebslk.oebslk24=l_oebslk24
         LET l_oebslk.oebslk25=l_oebslk25
         LET l_oebslk.oebslk26=l_oebslk26
         LET l_oebslk.oebslk28=l_oebslk28
         LET l_oebslk.oebslk1006=l_oebslk1006

         SELECT ima31,ima02 INTO l_oebslk.oebslk05,l_oebslk.oebslk06
           FROM ima_file WHERE ima01=l_oebslk.oebslk04
         SELECT imc02 INTO l_oebslk.oebslk07 FROM imc_file WHERE imc01=l_oebslk.oebslk04
#TQC-C40197-----mark----STR----
#         SELECT img02,img03,img04 INTO l_oebslk.oebslk09,l_oebslk.oebslk091,l_oebslk.oebslk092
#           FROM img_file WHERE img01=l_oebslk.oebslk04
#TQC-C40197-----mark----END-----
         SELECT obk03 INTO l_oebslk.oebslk11 FROM obk_file WHERE obk01=l_oebslk.oebslk04

         LET l_oebslk.oebslk05_fac=1
         LET l_oebslk.oebslk01=l_oea.oea01
         SELECT MAX(oebslk03)+1 INTO l_oebslk.oebslk03
           FROM oebslk_file WHERE oebslk01 = l_oea.oea01
         IF cl_null(l_oebslk.oebslk03) THEN
            LET l_oebslk.oebslk03 = 1
         END IF
         LET l_oebslk.oebslk131=l_oebslk.oebslk13*l_oebslk.oebslk1006/100
         CALL cl_digcut(l_oeb.oeb13,t_azi03) RETURNING l_oeb.oeb13
         CALL cl_digcut(l_oeb.oeb14,t_azi04) RETURNING l_oeb.oeb14
         CALL cl_digcut(l_oeb.oeb14t,t_azi04) RETURNING l_oeb.oeb14t

         LET l_oebslk.oebslk091=' '
         LET l_oebslk.oebslk092=' '
         LET l_oebslk.oebslk23=0
         LET l_oebslk.oebslk24=0
         LET l_oebslk.oebslk25=0
         LET l_oebslk.oebslk26=0
         LET l_oebslk.oebslk28=0
         LET l_oebslk.oebslkplant=g_plant
         LET l_oebslk.oebslklegal=g_legal
         INSERT INTO oebslk_file VALUES (l_oebslk.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","oebslk_file",l_oea.oea01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         UPDATE oebi_file SET oebislk02=l_oebslk.oebslk04,
                              oebislk03=l_oebslk.oebslk03
          WHERE oebi01=l_oea.oea01
            AND oebi03= (SELECT oeb03 FROM oeb_file
                            WHERE oeb01=l_oea.oea01
                              AND oeb04=l_oebslk.oebslk04)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","oebi_file",l_oea.oea01,l_oebslk.oebslk04,SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END FOREACH
#TQC-C20376------add----end----------------------

      UPDATE odr_file SET odr06=l_oea.oea01
          WHERE odr01=g_odr01 AND odr00=g_odr00 AND odr02=l_odr[g_cnt].odr02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","odr_file",l_oea.oea01,l_odr[g_cnt].odr02,SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      LET g_cnt = g_cnt+1    #FUN-B90101 add   記錄轉成訂單的筆數 
   END FOREACH

#FUN-B90101--add--begin--
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL i406_notice(g_cnt-1)
      CALL i406_b_fill_2(g_wc4)
   ELSE
      ROLLBACK WORK
      CALL cl_err(g_odr00,'aic-060',0)  
   END IF 
#FUN-B90101--add--end--
      
   LET g_cnt=0
   LET g_cnt1=0
   LET g_cnt2=0
END FUNCTION

#FUN-B90101--add--begin--
FUNCTION i406_notice(l_nt)
   DEFINE   ps_msg          STRING
   DEFINE   ps_msg2         STRING
   DEFINE   l_nt            LIKE type_file.num5
   DEFINE   ls_msg          LIKE type_file.chr1000
   DEFINE   ls_msg2         LIKE type_file.chr1000
   DEFINE   lc_msg          LIKE type_file.chr1000
   DEFINE   lc_msg2         LIKE type_file.chr1000
   DEFINE   li_result       LIKE type_file.num5
   DEFINE   lc_title        LIKE ze_file.ze03

   WHENEVER ERROR CALL cl_err_msg_log

   IF (cl_null(g_lang)) THEN
      LET g_lang = "1"
   END IF
   IF (cl_null(ps_msg)) THEN
      LET ps_msg = ""
   END IF

   SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-042' AND ze02 = g_lang
   IF SQLCA.SQLCODE THEN
      LET lc_title = "Confirm"
   END IF

   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01='axm1112' AND ze02 = g_lang
   SELECT ze03 INTO ls_msg2 FROM ze_file WHERE ze01='axm1113' AND ze02 = g_lang

   LET ps_msg =ls_msg CLIPPED
   LET ps_msg2 =ls_msg2 CLIPPED
   LET ps_msg =ps_msg,l_nt,ps_msg2

    LET li_result = FALSE

    LET lc_title=lc_title CLIPPED

   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ps_msg.trim(), IMAGE="question")
      ON ACTION accept
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU

   END MENU

   IF (INT_FLAG) THEN
      LET INT_FLAG = FALSE
   END IF
END FUNCTION
#FUN-B90101--add--end--

#FUN-B20005-------add--------begin------
FUNCTION i406_set_no_entry(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN   
      CALL cl_set_comp_entry("odr02",FALSE)
   END IF
END FUNCTION

FUNCTION i406_r()
 DEFINE l_count       LIKE  type_file.num5

   IF cl_null(g_odr01) OR cl_null(g_odr00) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT COUNT(*)  INTO l_count FROM odr_file,oea_file
    WHERE odr00=g_odr00 AND odr01=g_odr01  AND oea01=odr06 AND oeaslk02=g_odp13
   IF l_count>0 AND NOT cl_null(l_count) THEN
      CALL cl_err(g_odr00,'axm1106',0)
      RETURN 
   END IF
   IF cl_delh(0,0) THEN 
      DELETE FROM odr_file WHERE odr01=g_odr01 AND odr00=g_odr00      
      UPDATE odp_file SET odp14=''
       WHERE odp01=g_odr01 AND odp14=g_odr00 AND odp13=g_odp13 AND odp11='Y'
      COMMIT WORK
   END IF
 
   CLEAR FORM
   CALL g_odp.clear()
   CALL g_odr.clear()
   CALL g_odr2.clear()
   OPEN i406_count
#FUN-B50065------begin------------------------
   IF STATUS THEN
      CLOSE i406_cus
      CLOSE i406_count
      COMMIT WORK
      RETURN
   END IF
#FUN-B50065------end---------------------------
   FETCH i406_count INTO g_row_count
#FUN-B50065------begin------------------------
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE i406_cus
      CLOSE i406_count
      COMMIT WORK
      RETURN
   END IF
#FUN-B50065------end---------------------------
   DISPLAY g_row_count TO FORMONLY.cnt
   
   OPEN i406_cus
   IF g_curs_index = g_row_count + 1 THEN
      LET g_jump = g_row_count
      CALL i406_fetch('L')
   ELSE
      LET g_jump = g_curs_index
      LET mi_no_ask = TRUE                  
      CALL i406_fetch('/')
   END IF      
END FUNCTION
#FUN-B20005-------add-------end--------
