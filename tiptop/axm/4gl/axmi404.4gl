# Prog. Version..: '5.30.06-13.04.22(00010)'     #
# Pattern name...: axmi404.4gl
# Descriptions...:
# Date & Author..: 10/05/17 By shaoyong
# Modify.........: No.FUN-B20031 11/01/18 BY huangrh  修改整個程序結構為DIALOG,修改訂貨明細的為動態顯示,優化程式 
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B90101 11/11/08 By lixiang  1.服飾問題修改，如數量的控管，顯示等問題
#                                                     2.審核和取消審核的控管問題
# Modify.........: No.FUN-BC0071 12/02/08 By huangtao 增加取價參數 
# Modify.........: No:TQC-C20117 12/02/13 By lixiang 服飾BUG修改
# Modify.........: No:TQC-C20134 12/02/13 By xjll    使用訂貨會編號時資料有效碼為Y才可以使用
# Modify.........: No:TQC-C20172 12/02/14 By lixiang 服飾BUG修改
# Modify.........: No:TQC-C20224 12/02/15 By lixiang 錯誤信息及BUG修改
# Modify.........: No:TQC-C20232 12/02/15 By lixiang BUG修改
# Modify.........: No:TQC-C20327 12/02/20 By lixiang 錯誤信息及BUG修改
# Modify.........: No:TQC-C20376 12/02/22 By huangrh 單身的欄位開啟否修改，單身的更新修改
# Modify.........: No:TQC-C20418 12/02/23 By huangrh 增加odp14查詢，修改審核的必定商品的檢查BUG
# Modify.........: No:TQC-C30198 12/03/10 By lixiang  控管數量欄位數量不可小於零
# Modify.........: No:TQC-C40197 12/04/23 By qiaozy  訂貨明細相關BUG修改
# Modify.........: No:FUN-C60022 12/06/06 By qiaozy  訂貨明細畫面修改，即時顯示料件基本資料，款號欄位開啟
# Modify.........: No:FUN-C60021 12/06/11 By qiaozy  單身切換快捷鍵和其他快捷鍵設置
# Modify.........: No.CHI-C30107 12/06/21 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C60100 12/06/26 By qiaozy   服飾流通：快捷鍵controlb的問題，切換的標記請在BEFORE INPUT 賦值
# Modify.........: No:FUN-C70082 12/07/19 By xjll 訂貨會編號開窗和檢查訂貨會的有效日期的檢查
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40084 13/04/22 By jingll  雙擊單身會出現死循環現象 原因是g_action_choice 沒有清空

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_odp00   LIKE odp_file.odp00
DEFINE g_odp00_t LIKE odp_file.odp01
DEFINE g_odp01   LIKE odp_file.odp01
DEFINE g_odp01_t LIKE odp_file.odp01
DEFINE g_odp02   LIKE odp_file.odp02
DEFINE g_odp02_t LIKE odp_file.odp02
DEFINE g_odp13   LIKE odp_file.odp13
DEFINE g_odp13_t LIKE odp_file.odp13
DEFINE g_argv1   LIKE odp_file.odp01
DEFINE g_check   LIKE odp_file.odp11
DEFINE g_wc      STRING
DEFINE g_wc2     STRING
DEFINE g_forupd_sql STRING
DEFINE g_rec_b1   LIKE type_file.num5
DEFINE g_rec_b3  LIKE type_file.num5
DEFINE g_rec_b3_1  LIKE type_file.num5
DEFINE g_rec_b2  LIKE type_file.num5
DEFINE l_ac1     LIKE type_file.num5
DEFINE l_ac2     LIKE type_file.num5
DEFINE l_ac3     LIKE type_file.num5
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_row_count    LIKE type_file.num10  
DEFINE g_jump         LIKE type_file.num10 
DEFINE mi_no_ask      LIKE type_file.num5
DEFINE g_msg          LIKE ze_file.ze03 
DEFINE g_sql  STRING
DEFINE g_cnt   LIKE type_file.num10 
DEFINE g_cnt1  LIKE type_file.num10 
DEFINE g_cnt2  LIKE type_file.num10 
DEFINE g_t1    LIKE type_file.chr5
DEFINE g_odp   DYNAMIC ARRAY OF RECORD
               odp03   LIKE odp_file.odp03,
               odp04   LIKE odp_file.odp04,
               odp05   LIKE odp_file.odp05,
               odp07   LIKE odp_file.odp07,
               odp08   LIKE odp_file.odp08,
               odp09   LIKE odp_file.odp09,
               odp10   LIKE odp_file.odp10,
               odp09a  LIKE odp_file.odp09,
               odp10a  LIKE odp_file.odp10
               END RECORD
DEFINE g_odp_t RECORD
               odp03   LIKE odp_file.odp03,
               odp04   LIKE odp_file.odp04,
               odp05   LIKE odp_file.odp05,
               odp07   LIKE odp_file.odp07,
               odp08   LIKE odp_file.odp08,
               odp09   LIKE odp_file.odp09,
               odp10   LIKE odp_file.odp10,
               odp09a  LIKE odp_file.odp09,
               odp10a  LIKE odp_file.odp10
               END RECORD
DEFINE g_ima_2 RECORD
               ima01     LIKE ima_file.ima01,
               ima02     LIKE ima_file.ima02,
               ima021    LIKE ima_file.ima021,
               ima31     LIKE ima_file.ima31,
               ima1004   LIKE ima_file.ima1004,
               ima1005   LIKE ima_file.ima1005,
               ima1006   LIKE ima_file.ima1006,
               ima1007   LIKE ima_file.ima1007,
               ima1008   LIKE ima_file.ima1008,
               ima1009   LIKE ima_file.ima1009
               END RECORD
DEFINE g_odp_2   DYNAMIC ARRAY OF RECORD
               odp03_2   LIKE odp_file.odp03,
               odp04_2   LIKE odp_file.odp04,
               odp05_2   LIKE odp_file.odp05,
               odp07_2   LIKE odp_file.odp07,
               odp08_2   LIKE odp_file.odp08,
               odp09_2   LIKE odp_file.odp09,
               odp10_2   LIKE odp_file.odp10,
               odp09a_2  LIKE odp_file.odp09,
               odp10a_2  LIKE odp_file.odp10
               END RECORD
               
DEFINE g_odp_2t RECORD
               odp03_2   LIKE odp_file.odp03,
               odp04_2   LIKE odp_file.odp04,
               odp05_2   LIKE odp_file.odp05,
               odp07_2   LIKE odp_file.odp07,
               odp08_2   LIKE odp_file.odp08,
               odp09_2   LIKE odp_file.odp09,
               odp10_2   LIKE odp_file.odp10,
               odp09a_2  LIKE odp_file.odp09,
               odp10a_2  LIKE odp_file.odp10
               END RECORD
DEFINE p_row,p_col LIKE type_file.num5

#FUN-B20031 add------------begin----------------------------------
DEFINE  g_odq04         LIKE odq_file.odq04
DEFINE  g_imx  DYNAMIC ARRAY OF RECORD
               number   LIKE type_file.num5,
               color    LIKE type_file.chr20,
               imx01    LIKE type_file.num10,
               imx02    LIKE type_file.num10,
               imx03    LIKE type_file.num10,
               imx04    LIKE type_file.num10,
               imx05    LIKE type_file.num10,
               imx06    LIKE type_file.num10,
               imx07    LIKE type_file.num10,
               imx08    LIKE type_file.num10,
               imx09    LIKE type_file.num10,
               imx10    LIKE type_file.num10,
               imx11    LIKE type_file.num10,
               imx12    LIKE type_file.num10,
               imx13    LIKE type_file.num10,
               imx14    LIKE type_file.num10,
               imx15    LIKE type_file.num10,
               imx16    LIKE type_file.num10,
               imx17    LIKE type_file.num10,
               imx18    LIKE type_file.num10,
               imx19    LIKE type_file.num10,
               imx20    LIKE type_file.num10,
               count    LIKE type_file.num10 
               END RECORD
DEFINE g_imxtext DYNAMIC ARRAY OF RECORD
       color     LIKE type_file.chr50,
       detail    DYNAMIC ARRAY OF RECORD
         size   LIKE type_file.chr50
          END RECORD
       END RECORD
DEFINE  g_imx_t  RECORD
               number   LIKE type_file.num5,
               color    LIKE type_file.chr20,
               imx01    LIKE type_file.num10,
               imx02    LIKE type_file.num10,
               imx03    LIKE type_file.num10,
               imx04    LIKE type_file.num10,
               imx05    LIKE type_file.num10,
               imx06    LIKE type_file.num10,
               imx07    LIKE type_file.num10,
               imx08    LIKE type_file.num10,
               imx09    LIKE type_file.num10,
               imx10    LIKE type_file.num10,
               imx11    LIKE type_file.num10,
               imx12    LIKE type_file.num10,
               imx13    LIKE type_file.num10,
               imx14    LIKE type_file.num10,
               imx15    LIKE type_file.num10,
               imx16    LIKE type_file.num10,
               imx17    LIKE type_file.num10,
               imx18    LIKE type_file.num10,
               imx19    LIKE type_file.num10,
               imx20    LIKE type_file.num10, 
               count    LIKE type_file.num10 
               END RECORD
#FUN-B20031 add------------end-----------------------------------
DEFINE li_a          LIKE type_file.chr10  #FUN-C60021--ADD--
DEFINE g_b_flag      LIKE type_file.chr1   #FUN-D30034 add

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
   OPEN WINDOW i404_w AT p_row,p_col WITH FORM "axm/42f/axmi404"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   LET li_a=TRUE    #FUN-C60021---ADD---
   CALL cl_set_act_visible("controlb",FALSE) #FUN-C60021---ADD-
   CALL cl_set_comp_visible("number",FALSE)
   CALL i404_menu()
   

   CLOSE WINDOW i404_w     
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN

#FUN-B20031 modify-------------------begin-------------------------
FUNCTION i404_menu()

   WHILE TRUE  

      IF cl_null(g_action_choice) OR g_action_choice <> "detail" THEN   #FUN-D30034 add
         LET g_action_choice = " "
         CALL cl_set_act_visible("accept,cancel", FALSE)
         CALL cl_set_act_visible("controlb",FALSE)   #FUN-C60021--ADD
         DIALOG ATTRIBUTES(UNBUFFERED)
   
            DISPLAY ARRAY g_odp TO s_odp.*
         
               BEFORE DISPLAY
                    CALL cl_navigator_setting( g_curs_index, g_row_count )
                    CALL i404_b_fill_1(g_wc2)   #FUN-C60021---ADD--
                    CALL g_imx.clear()          #FUN-C60021---ADD-
                    CALL i404_403()
                    LET g_b_flag = '1'      #FUN-D30034 add
    
                BEFORE ROW
                  LET g_odq04='0'
                  LET l_ac1 = DIALOG.getCurrentRow("s_odp")
                  DISPLAY g_odp00,g_odp01,g_odp02 TO odp00,odp01,odp02
                  CALL i404_odl02('d')
                  CALL i404_occ02('d')
                  IF l_ac1>0 then
                    CALL i404_ima('d')
                    LET g_doc.column1 = "ima01"
                    LET g_doc.value1  = g_odp[l_ac1].odp07
                    CALL cl_get_fld_doc("ima04")
                    CALL i404_b_fill_2()  
                    CALL i404_b_set_text(g_odp[l_ac1].odp07)       
                    CALL i404_fill_imx(g_odp[l_ac1].odp07)        
   
                  END IF
   
            END DISPLAY
   
           DISPLAY ARRAY g_odp_2 TO s_odp_2.*
              BEFORE DISPLAY             #FUN-D30034 add
                 LET g_b_flag = '2'      #FUN-D30034 add
            
              BEFORE ROW
                 LET g_odq04='1'
                 LET l_ac2 = DIALOG.getCurrentRow("s_odp_2")
                 CALL i404_ima_2('d')
                 LET g_doc.column1 = "ima01"
                 LET g_doc.value1  = g_odp_2[l_ac2].odp07_2
                 CALL cl_get_fld_doc("ima04")
                 CALL i404_b_set_text(g_odp_2[l_ac2].odp07_2)
                 CALL i404_fill_imx(g_odp_2[l_ac2].odp07_2)
   
            END DISPLAY
   
            DISPLAY ARRAY g_imx TO s_imx.*
               BEFORE DISPLAY
                  CALL cl_navigator_setting( g_curs_index, g_row_count )
                  LET g_action_choice=""   
                  LET g_b_flag = '3'      #FUN-D30034 add
            
               BEFORE ROW
                  LET l_ac3 = DIALOG.getCurrentRow("s_imx")
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
   #          ON ACTION modify
   #             LET g_action_choice="modify"
   #             EXIT DIALOG
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
                LET l_ac1 = 1
                LET l_ac2 = 1
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
             ON ACTION confirm
                LET g_action_choice="confirm"
                EXIT DIALOG
   
             ON ACTION unconfirm
                LET g_action_choice="unconfirm"
                EXIT DIALOG
   
            
             ON ACTION controlg
                LET g_action_choice="controlg"
                EXIT DIALOG
             ON ACTION controls                    
                CALL cl_set_head_visible("","AUTO") 
   
             ON ACTION accept
                LET g_action_choice="detail"
                LET l_ac1 = ARR_CURR()
                EXIT DIALOG
           
             ON ACTION cancel
                    LET INT_FLAG=FALSE  
                LET g_action_choice="exit"
                EXIT DIALOG
   
   #FUN-C60021-----ADD----STR----
               ON ACTION controlb    #設置快捷鍵，用於“款號單身”與“多屬性單身”之間的切換
                  IF li_a THEN
                     LET li_a = FALSE
                     NEXT FIELD odp03
                  ELSE
                     LET li_a = TRUE
                     NEXT FIELD color
                  END IF
   #FUN-C60021------ADD---END-----             
             ON ACTION locale
                CALL cl_dynamic_locale()
                CALL cl_show_fld_cont()                   
   #             CALL i404_set_perlang()
   #             CALL i404_chspic()
                EXIT DIALOG
           
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE DIALOG
           
             ON ACTION about      
                CALL cl_about()  
                EXIT DIALOG
   
             AFTER DIALOG
                CONTINUE DIALOG
   
           END DIALOG

           CALL cl_set_act_visible("accept,cancel", TRUE)   
      END IF                                #FUN-D30034 add
       
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i404_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i404_q()
            END IF
  
#         WHEN "modify"
#            IF cl_chk_act_auth() THEN
#               CALL i404_u()
#            END IF
          
         WHEN "check"
            IF cl_chk_act_auth() THEN
               CALL i404_check()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i404_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i404_confirm()
            END IF

         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN
               CALL i404_unconfirm()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i404_r()
            END IF

         WHEN "next"
            IF cl_chk_act_auth() THEN
               CALL i404_fetch('N')
            END IF
         WHEN "previous"
            IF cl_chk_act_auth() THEN
               CALL i404_fetch('P')
            END IF
         WHEN "jump"
            IF cl_chk_act_auth() THEN
               CALL i404_fetch('/')
            END IF
         WHEN "first"
            IF cl_chk_act_auth() THEN
               CALL i404_fetch('F')
            END IF
         WHEN "last"
            IF cl_chk_act_auth() THEN
               CALL i404_fetch('L')
            END IF
 
         WHEN "exit"
            EXIT WHILE
        
         WHEN "help"
            CALL cl_show_help()

         WHEN "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

        WHEN "controlg"
            CALL cl_cmdask()

      END CASE
   END WHILE

END FUNCTION
#FUN-B20031 modify---------------------------------------end--------------------------------


FUNCTION i404_b_fill_1(p_wc2)
   DEFINE p_wc2 STRING

   LET g_sql="SELECT odp03,odp04,odp05,odp07,odp08,odp09,odp10,odp09*odp08,odp10*odp08 FROM odp_file ",
             " WHERE odp01='",g_odp01,"' ",
             " AND odp02='",g_odp02,"' ",
             " AND odp00='",g_odp00,"' ",
             " AND odp06='0' ",
             " AND odp12=' '"

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED

   PREPARE i404_odppb FROM g_sql
   DECLARE odp_cs CURSOR FOR i404_odppb

   CALL g_odp.clear()
   LET g_cnt1 = 1

   FOREACH odp_cs INTO g_odp[g_cnt1].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL cl_digcut(g_odp[g_cnt1].odp09a,t_azi04)  RETURNING g_odp[g_cnt1].odp09a
      CALL cl_digcut(g_odp[g_cnt1].odp10a,t_azi04)  RETURNING g_odp[g_cnt1].odp10a

      LET g_cnt1 = g_cnt1 + 1
      IF g_cnt1 > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_odp.deleteElement(g_cnt1)

   LET g_rec_b1=g_cnt1-1
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt1 = 0
END FUNCTION

FUNCTION i404_odl02(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
   DEFINE l_odl02 LIKE odl_file.odl02
   
   LET g_errno=''
    
   SELECT odl02 INTO l_odl02 FROM odl_file
      WHERE odl01=g_odp01 AND odlacti='Y'
   IF SQLCA.sqlcode=100 THEN
     #LET g_errno='aoo-005' #TQC-C20224 mark
      LET g_errno='1201'    #TQC-C20224 add
   ELSE
	  LET g_errno=SQLCA.sqlcode USING '------'
   END IF 
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_odl02 TO odl02
   END IF
END FUNCTION


FUNCTION i404_occ02(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
   DEFINE l_occ02 LIKE occ_file.occ02
   
   LET g_errno=''
    
   SELECT occ02 INTO l_occ02 FROM occ_file
      WHERE occ01=g_odp02
   IF SQLCA.sqlcode=100 THEN
     #LET g_errno='aoo-005'  #TQC-C20224  mark
      LET g_errno='anm-045'  #TQC-C20224  add  
   ELSE
	  LET g_errno=SQLCA.sqlcode USING '------'
   END IF 
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_occ02 TO occ02
   END IF
END FUNCTION

FUNCTION i404_ima(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
   DEFINE l_gfe02  LIKE gfe_file.gfe02
   DEFINE l_tqa02_1 LIKE tqa_file.tqa02
   DEFINE l_tqa02_2 LIKE tqa_file.tqa02
   DEFINE l_tqa02_3 LIKE tqa_file.tqa02
   DEFINE l_tqa02_4 LIKE tqa_file.tqa02
   DEFINE l_tqa02_5 LIKE tqa_file.tqa02
   DEFINE l_tqa02_6 LIKE tqa_file.tqa02
   LET g_errno=''
    
   SELECT ima01,ima02,ima021,ima31,ima1004,ima1005,ima1006,ima1007,ima1008,ima1009
     INTO g_ima_2.*  FROM ima_file
    WHERE ima01=g_odp[l_ac1].odp07

   IF SQLCA.sqlcode=100 THEN
     #LET g_errno='aoo-005'  #TQC-C20224 mark
      LET g_errno='1113'     #TQC-C20224 add
      INITIALIZE g_ima_2 TO NULL 
   ELSE
	  LET g_errno=SQLCA.sqlcode USING '------'
   END IF 
   IF p_cmd='d' OR cl_null(g_errno)THEN
   DISPLAY g_ima_2.*
        TO ima01,ima02,ima021,ima31,ima1004,ima1005,ima1006,ima1007,ima1008,ima1009
        
   END IF
  
      SELECT gfe02 INTO l_gfe02 from gfe_file
    WHERE gfe01 = g_ima_2.ima31
   SELECT tqa02 INTO l_tqa02_1 from tqa_file
    WHERE tqa01 = g_ima_2.ima1004
      AND tqa03 = '1'
   SELECT tqa02 INTO l_tqa02_2 from tqa_file
    WHERE tqa01 = g_ima_2.ima1005
      AND tqa03 = '2'
   SELECT tqa02 INTO l_tqa02_3 from tqa_file
    WHERE tqa01 = g_ima_2.ima1006
      AND tqa03 = '3'
   SELECT tqa02 INTO l_tqa02_4 from tqa_file
    WHERE tqa01 = g_ima_2.ima1007
      AND tqa03 = '4'
   SELECT tqa02 INTO l_tqa02_5 from tqa_file
    WHERE tqa01 = g_ima_2.ima1008
      AND tqa03 = '5'
   SELECT tqa02 INTO l_tqa02_6 from tqa_file
    WHERE tqa01 = g_ima_2.ima1009
      AND tqa03 = '6'

   DISPLAY l_gfe02,l_tqa02_1,l_tqa02_2,l_tqa02_3,l_tqa02_4,l_tqa02_5,l_tqa02_6
        TO gfe02,tqa02_1,tqa02_2,tqa02_3,tqa02_4,tqa02_5,tqa02_6

END FUNCTION

FUNCTION i404_ima_2(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
   DEFINE l_gfe02  LIKE gfe_file.gfe02
   DEFINE l_tqa02_1 LIKE tqa_file.tqa02
   DEFINE l_tqa02_2 LIKE tqa_file.tqa02
   DEFINE l_tqa02_3 LIKE tqa_file.tqa02
   DEFINE l_tqa02_4 LIKE tqa_file.tqa02
   DEFINE l_tqa02_5 LIKE tqa_file.tqa02
   DEFINE l_tqa02_6 LIKE tqa_file.tqa02
   LET g_errno=''
   

   SELECT ima01,ima02,ima021,ima31,ima1004,ima1005,ima1006,ima1007,ima1008,ima1009
     INTO g_ima_2.*  FROM ima_file
    WHERE ima01=g_odp_2[l_ac2].odp07_2

   IF SQLCA.sqlcode=100 THEN
     #LET g_errno='aoo-005'  #TQC-C20224 mark
      LET g_errno='1113'     #TQC-C20224 add
   ELSE
	  LET g_errno=SQLCA.sqlcode USING '------'
   END IF 
   IF p_cmd='d' OR cl_null(g_errno)THEN
        DISPLAY g_ima_2.*
             TO ima01,ima02,ima021,ima31,ima1004,ima1005,ima1006,ima1007,ima1008,ima1009
        
   END IF
  
   SELECT gfe02 INTO l_gfe02 from gfe_file
    WHERE gfe01 = g_ima_2.ima31
   SELECT tqa02 INTO l_tqa02_1 from tqa_file
    WHERE tqa01 = g_ima_2.ima1004
      AND tqa03 = '1'
   SELECT tqa02 INTO l_tqa02_2 from tqa_file
    WHERE tqa01 = g_ima_2.ima1005
      AND tqa03 = '2'
   SELECT tqa02 INTO l_tqa02_3 from tqa_file
    WHERE tqa01 = g_ima_2.ima1006
      AND tqa03 = '3'
   SELECT tqa02 INTO l_tqa02_4 from tqa_file
    WHERE tqa01 = g_ima_2.ima1007
      AND tqa03 = '4'
   SELECT tqa02 INTO l_tqa02_5 from tqa_file
    WHERE tqa01 = g_ima_2.ima1008
      AND tqa03 = '5'
   SELECT tqa02 INTO l_tqa02_6 from tqa_file
    WHERE tqa01 = g_ima_2.ima1009
      AND tqa03 = '6'

   DISPLAY l_gfe02,l_tqa02_1,l_tqa02_2,l_tqa02_3,l_tqa02_4,l_tqa02_5,l_tqa02_6
        TO gfe02,tqa02_1,tqa02_2,tqa02_3,tqa02_4,tqa02_5,tqa02_6

END FUNCTION



FUNCTION i404_cs()
   CLEAR FORM
   CALL g_odp.clear()
        
   IF NOT  cl_null(g_argv1) THEN                                              
      LET g_wc = " odp01 = '",g_argv1,"'"                                       
   ELSE                                                                         
      CALL cl_set_head_visible("","YES") 
   
      INITIALIZE g_odp00,g_odp01,g_odp02  TO NULL 
#      CONSTRUCT BY NAME g_wc ON odp00,odp01,odp02,odp13,odp11,odp14 #TQC-C20224 add odp11 #TQC-C20418 add odp14#FUN-C60022--MARK
      CONSTRUCT BY NAME g_wc ON odp01,odp13,odp00,odp02,odp11,odp14  #FUN-C60022--ADD---
        
      BEFORE CONSTRUCT 
         CALL cl_qbe_init()
  
         ON ACTION controlp
            IF INFIELD(odp00) THEN #查詢單据
               CALL cl_init_qry_var()
               LET g_qryparam.form="q_odp00"
               LET g_qryparam.state="c"
               LET g_qryparam.default1=g_odp00
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO odp00
               NEXT FIELD odp00
            END IF

            IF INFIELD (odp01) THEN 
               CALL cl_init_qry_var()
               LET g_qryparam.form="q_odp01" 
               LET g_qryparam.state="c"
               LET g_qryparam.default1=g_odp01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO odp01
               NEXT FIELD odp01
            END IF
      
            IF INFIELD (odp02) THEN 
               CALL cl_init_qry_var()
               LET g_qryparam.form="q_odp02"
               LET g_qryparam.state="c"
               LET g_qryparam.default1=g_odp02
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO odp02
               NEXT FIELD odp02
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
      CONSTRUCT g_wc2 ON odp03,odp04,odp05,odp07,odp08 
                      FROM s_odp[1].odp03,s_odp[1].odp04,s_odp[1].odp05,
                           s_odp[1].odp07,s_odp[1].odp08
                        
      BEFORE CONSTRUCT 
         ON IDLE g_idle_seconds                                                    
            CALL cl_on_idle()                                                      
            CONTINUE CONSTRUCT 
      
         ON ACTION controlp
            IF INFIELD (odp03) THEN 
               CALL cl_init_qry_var()
               LET g_qryparam.form="q_odp03"
               LET g_qryparam.state="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO odp03
               NEXT FIELD odp03
            END IF   
            IF INFIELD (odp04) THEN 
               CALL cl_init_qry_var()
               LET g_qryparam.form="q_odp04"
               LET g_qryparam.state="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO odp04
               NEXT FIELD odp04
            END IF   
            IF INFIELD (odp05) THEN 
               CALL cl_init_qry_var()
               LET g_qryparam.form="q_odp05"
               LET g_qryparam.state="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO odp05
               NEXT FIELD odp05

            END IF   
#FUN-C60022-----ADD----STR----
            IF INFIELD (odp07) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form="q_odp07"
               LET g_qryparam.state="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO odp07
               NEXT FIELD odp07
            END IF
#FUN-C60022-----ADD----END----

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

   IF g_wc2=" 1=1" THEN
      LET g_sql="SELECT distinct odp00 FROM odp_file",
                "  WHERE ", g_wc CLIPPED            
   ELSE
      LET g_sql="SELECT distinct odp00 ",
               "  FROM odp_file WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED ," AND odp06='0' " #," ORDER BY odp03"  #TQC-C20224 mark #TQC-C40197---ADD--ODP06
   END IF
   
   PREPARE i404_prepare FROM g_sql                                             
   DECLARE i404_cus SCROLL CURSOR WITH HOLD FOR i404_prepare  
   
   IF g_wc2 = " 1=1" THEN                                     
      LET g_sql="SELECT COUNT(distinct(odp00)) FROM odp_file WHERE ",g_wc CLIPPED
   ELSE                                                                       
      LET g_sql="SELECT COUNT(distinct(odp00)) FROM odp_file WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED," AND odp06='0' "    #TQC-C40197---ADD--ODP06  
   END IF                            
      
   PREPARE i404_precount FROM g_sql                                           
   DECLARE i404_count CURSOR FOR i404_precount  
END FUNCTION

FUNCTION i404_q()
   LET g_row_count=0
   LET g_curs_index=0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FROM
   INITIALIZE g_odp00,g_odp01,g_odp02 TO NULL
   CALL  g_odp.clear()
   CALL  g_odp_2.clear()
   CALL  g_imx.clear()
   DISPLAY ' ' TO FORMONLY.cnt

   CALL i404_cs()

   IF INT_FLAG THEN 
      LET INT_FLAG=0
      CLEAR FORM
      RETURN 
   END IF
   
   OPEN i404_count                          
      FETCH i404_count INTO g_row_count                                         
      DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN i404_cus                                                                
      IF SQLCA.sqlcode THEN                                                        
         CALL cl_err(g_odp00,SQLCA.sqlcode,0)                                  
         INITIALIZE g_odp00 TO NULL
      ELSE 
         CALL i404_fetch('F') 
      END IF   
END FUNCTION

FUNCTION i404_fetch(p_fodp)
DEFINE p_fodp VARCHAR(1)
DEFINE l_n    LIKE type_file.num5

CASE p_fodp
      WHEN 'N' FETCH NEXT i404_cus INTO g_odp00
      WHEN 'F' FETCH FIRST i404_cus INTO g_odp00
      WHEN 'L' FETCH LAST  i404_cus INTO g_odp00
      WHEN 'P' FETCH PREVIOUS i404_cus INTO g_odp00
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
      FETCH ABSOLUTE g_jump i404_cus INTO g_odp00
      LET mi_no_ask=FALSE
    END CASE
    
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_odp00,SQLCA.sqlcode,0)
       INITIALIZE g_odp00,g_odp01,g_odp02 TO NULL
       RETURN
    ELSE
       CASE p_fodp
          WHEN 'F' LET g_curs_index=1
          WHEN 'N' LET g_curs_index=g_curs_index+1
          WHEN 'P' LET g_curs_index=g_curs_index-1 
          WHEN 'L' LET g_curs_index=g_row_count
          WHEN '/' LET g_curs_index=g_jump
       END CASE
       CALL cl_navigator_setting(g_curs_index,g_row_count)
       DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    IF SQLCA.sqlcode THEN                   
        CALL cl_err3("sel","odp_file",g_odp00,"",SQLCA.sqlcode,"","",0)
    ELSE     
       CALL i404_show()                    
    END IF
END FUNCTION

FUNCTION i404_show()
  DEFINE l_odp14     LIKE odp_file.odp14
  DEFINE l_odp11     LIKE odp_file.odp11

   SELECT DISTINCT odp01,odp02,odp11,odp13,odp14 INTO g_odp01,g_odp02,l_odp11,g_odp13,l_odp14
     FROM odp_file
    WHERE odp00=g_odp00

   DISPLAY g_odp00,g_odp01,g_odp02,l_odp11,g_odp13,l_odp14 TO odp00,odp01,odp02,odp11,odp13,odp14
   CALL i404_odl02('d')
   CALL i404_occ02('d')
   CALL cl_show_fld_cont()
   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
    WHERE azi01=g_odp02
   CALL i404_b_fill_1(g_wc2)
   IF l_ac1 >0 THEN
      CALL i404_b_fill_2()

      CALL i404_ima('d')  
      LET g_doc.column1 = "ima01"             #FUN-C60022--ADD--
      LET g_doc.value1  = g_odp[l_ac1].odp07  #FUN-C60022--ADD---
      CALL cl_get_fld_doc("ima04")            #FUN-C60022--ADD---
   END IF
END FUNCTION

FUNCTION i404_b_fill_2()
   DEFINE p_wc2 STRING
   DEFINE l_n        LIKE type_file.num5
   DEFINE l_j        LIKE type_file.num5
   DEFINE l_odk02    LIKE odk_file.odk02
   DEFINE l_ima31    LIKE ima_file.ima31
   DEFINE l_occ42    LIKE occ_file.occ42
   DEFINE l_occ44    LIKE occ_file.occ44
   DEFINE l_occ45    LIKE occ_file.occ45

   LET g_sql = "SELECT odp03,odp04,odp05,odp07,odp08,odp09,odp10,odp09*odp08,odp10*odp08 FROM odp_file ",
                  " WHERE odp01 = '",g_odp01,"' ",
                  "   AND odp02 = '",g_odp02,"' ",
                  "   AND odp00 = '",g_odp00,"' ",
                  "   AND odp06='1' ",
                  "   AND odp12 = '",g_odp[l_ac1].odp07 ,"'"

   PREPARE i404_odppb2 FROM g_sql                                                   
   DECLARE odp_cs2 CURSOR FOR i404_odppb2 
   CALL g_odp_2.clear()                                                           
   LET g_cnt2 = 1                                                                
                                                                                
   FOREACH odp_cs2 INTO g_odp_2[g_cnt2].*
       IF SQLCA.sqlcode THEN                                                    
          CALL cl_err('foreach:',SQLCA.sqlcode,1)                               
          EXIT FOREACH
       END IF
       CALL cl_digcut(g_odp_2[g_cnt2].odp09a_2,t_azi04)  RETURNING g_odp_2[g_cnt2].odp09a_2
       CALL cl_digcut(g_odp_2[g_cnt2].odp10a_2,t_azi04)  RETURNING g_odp_2[g_cnt2].odp10a_2
       LET g_cnt2 = g_cnt2 + 1                                                    
       IF g_cnt2 > g_max_rec THEN                                                
          CALL cl_err( '', 9035, 0 )                                            
          EXIT FOREACH                                                          
       END IF                                                               
   END FOREACH
    
   CALL g_odp_2.deleteElement(g_cnt2)                                              

   LET g_rec_b2=g_cnt2-1                     
   DISPLAY g_rec_b2 TO FORMONLY.cn3    #TQC-C40197----ADD-----                                     
   LET g_cnt2 = 0 
   DISPLAY ARRAY g_odp_2 TO s_odp_2.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
       BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY

END FUNCTION	

FUNCTION i404_a()
  DEFINE li_result    LIKE type_file.num5  

   MESSAGE ""
   CLEAR FORM                                     
   INITIALIZE g_odp00 LIKE odp_file.odp00
   INITIALIZE g_odp01 LIKE odp_file.odp01
   INITIALIZE g_odp02 LIKE odp_file.odp02
   INITIALIZE g_odp13 LIKE odp_file.odp13
   LET g_odp00_t = NULL
   LET g_odp01_t = NULL
   LET g_odp02_t = NULL
   LET g_odp13_t = NULL
   LET g_wc = NULL
   LET g_odp13 = '1'  #TQC-C20172 add 
   CALL cl_opmsg('a')
   DISPLAY 'N' TO odp11
   
   WHILE TRUE     
      CALL i404_i("a")                                
      IF INT_FLAG THEN                          
 	 INITIALIZE g_odp00,g_odp01,g_odp02,g_odp13 TO NULL
         CALL g_odp.clear()
         CALL g_odp_2.clear()
         CALL g_imx.clear()

 	 LET INT_FLAG = 0
 	 CALL cl_err('',9001,0)
 	 CLEAR FORM
 	 EXIT WHILE
      END IF

      BEGIN WORK  

      CALL s_auto_assign_no("axm",g_odp00,g_today,'65',"odp_file","odp00","","","")
                  RETURNING li_result,g_odp00
      IF (NOT li_result) THEN
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
      DISPLAY g_odp00 TO odp00
      
      CALL g_odp.clear()
      CALL g_odp_2.clear()
      CALL g_imx.clear()
      LET g_rec_b1 = 0  
      CALL i404_b()  
      LET g_rec_b3_1 = 0
#      CALL i404_b_3(1)

      EXIT WHILE
   END WHILE
   
   LET g_wc=' '
END FUNCTION

FUNCTION i404_set_no_entry_b() 
   CALL cl_set_comp_entry("odp08,odp09,odp10",FALSE)
END FUNCTION

FUNCTION i404_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE l_input      LIKE type_file.chr1
   DEFINE l_n          LIKE type_file.num5
   DEFINE l_m          LIKE type_file.num5
   DEFINE li_result    LIKE type_file.num5
   DEFINE l_odlacti    LIKE odl_file.odlacti   #TQC-C40197--ADD---- 
   DEFINE l_n1         LIKE type_file.num5     #TQC-C40197--ADD----
   DEFINE l_cnt        LIKE type_file.num5     #FUN-C70082---add 

   DISPLAY g_odp00_t,g_odp01_t,g_odp02_t,g_odp13_t TO odp00,odp01,odp02,odp13
        
#   INPUT g_odp00,g_odp01,g_odp02,g_odp13 WITHOUT DEFAULTS FROM odp00,odp01,odp02,odp13 #FUN-C60022--MARK--
   INPUT g_odp01,g_odp13,g_odp00,g_odp02 WITHOUT DEFAULTS FROM odp01,odp13,odp00,odp02  #FUN-C60022--ADD--
   BEFORE INPUT
      CALL cl_set_docno_format("odp00")
      
   AFTER FIELD odp00
      IF cl_null(g_odp00) THEN
        #CALL cl_err("odp00",-386,1) #TQC-C20327 mark
         CALL cl_err("odp00",-1124,0)  #TQC-C20327 add 
         NEXT FIELD odp00
      ELSE
         CALL s_check_no("axm",g_odp00,g_odp00_t,"65","odp_file","odp00","") RETURNING li_result,g_odp00
         IF (NOT li_result) THEN
            LET g_odp00=g_odp00_t
            DISPLAY g_odp00_t TO odp00   
            NEXT FIELD odp00
         END IF
      END IF

   AFTER FIELD odp01
      IF cl_null(g_odp01) THEN
        #CALL cl_err("odp01",-386,1)  #TQC-C20327 mark
         CALL cl_err("odp00",-1124,0)  #TQC-C20327 add
         NEXT FIELD odp01
      ELSE
#TQC-C40197----ADD----STR-----
         #FUN-C70082----add--begin-----------
         SELECT COUNT(*) INTO l_cnt FROM odl_file WHERE odl01 = g_odp01 AND odlacti = 'Y'
                                                    AND odl03 <= g_today AND odl04 >= g_today
         IF cl_null(l_cnt) OR l_cnt = 0 THEN
            CALL cl_err('','wpc-679',0)
            NEXT FIELD odp01
         END IF
         #FUN-C70082----add--end-------------
         SELECT odlacti INTO l_odlacti FROM odl_file WHERE odl01=g_odp01
         SELECT count(*)INTO l_n1 FROM odm_file
          WHERE odm01=g_odp01 AND odmacti='Y' AND odmconf='Y' 
         IF l_odlacti<>'Y' THEN
            CALL cl_err("odp01","axm1149",0)
            NEXT FIELD odp01
         END IF
         IF cl_null(l_n1) OR l_n1=0 THEN
            CALL cl_err("","axm1150",0)
            NEXT FIELD odp01
         END IF   
#TQC-C40197----ADD----END-----
         CALL i404_odl02('d')
         IF NOT cl_null(g_errno) THEN
           CALL cl_err(g_odp01,g_errno,1)
           NEXT FIELD odp01
         END IF
      END IF
      
   AFTER FIELD odp02
      IF cl_null(g_odp02) THEN
        #CALL cl_err("odp02",-386,1)  #TQC-C20327 mark
         CALL cl_err("odp00",-1124,0)  #TQC-C20327 add  
         NEXT FIELD odp02
      ELSE
         CALL i404_occ02('d')
         IF NOT cl_null(g_errno) THEN
           CALL cl_err(g_odp02,g_errno,1)
           NEXT FIELD odp02
         END IF
      END IF
      
   AFTER INPUT
     IF INT_FLAG THEN
        EXIT INPUT
     END IF
     IF l_input='Y' THEN
        NEXT FIELD odp01
     END IF
 
   ON ACTION controlp    
      IF INFIELD(odp01) THEN                                                  
         CALL cl_init_qry_var()                                              
         LET g_qryparam.form="q_odl01"  
         LET g_qryparam.where=" odl03<='",g_today,"' AND odl04>='",g_today,"' "  #TQC-C40197---ADD-----                                                                                         
         LET g_qryparam.default1=g_odp01                                 
         CALL cl_create_qry() RETURNING g_odp01                 
         DISPLAY g_odp01 TO odp01                                
         NEXT FIELD odp01
      END IF
      IF INFIELD(odp00) THEN #查詢單据
         LET g_t1=s_get_doc_no(g_odp00)
         CALL q_oay(FALSE,FALSE,g_t1,'65','AXM') RETURNING g_t1 
         LET g_odp00=g_t1
         DISPLAY g_odp00_t TO odp00
         NEXT FIELD odp00
      END IF
      
      IF INFIELD(odp02) THEN                                                  
         CALL cl_init_qry_var()                                              
         LET g_qryparam.form="q_occ"                                                                                               
         LET g_qryparam.default1=g_odp02                                 
         CALL cl_create_qry() RETURNING g_odp02                 
         DISPLAY g_odp02 TO odp02                                
         NEXT FIELD odp02
      END IF
     
#FUN-C60021-----ADD---STR---
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about  
         CALL cl_about()

      ON ACTION help 
         CALL cl_show_help()

     ON ACTION controlg
         CALL cl_cmdask()
#FUN-C60021-----ADD---END--- 
   END INPUT
END FUNCTION


FUNCTION i404_b()

   DEFINE
    l_ac1_t          LIKE type_file.num5, 
    l_n              LIKE type_file.num5,           
    l_sum            LIKE type_file.num10,              
    l_cnt            LIKE type_file.num5,              
    l_lock_sw        LIKE type_file.chr1,             
    p_cmd1           LIKE type_file.chr1,                
    p_cmd3           LIKE type_file.chr1,                
    l_allow_insert   LIKE type_file.num5,            
    l_allow_delete   LIKE type_file.num5
    DEFINE l_odp07_t LIKE odp_file.odp07
    DEFINE c         STRING
    DEFINE l_j       LIKE type_file.num5
    DEFINE l_i       LIKE type_file.num5
    DEFINE l_qty     LIKE odq_file.odq07
    DEFINE l_odn09   LIKE odn_file.odn09
    DEFINE l_odq06   LIKE odq_file.odq06 
    DEFINE b_odq  RECORD  LIKE odq_file.*       #FUN-B20031 add
    DEFINE l_odq05   LIKE odq_file.odq05        #FUN-B20031 add
    DEFINE l_odq03   LIKE odq_file.odq03        #FUN-B20031 add
    DEFINE l_odq08   LIKE odq_file.odq08        #FUN-B20031 add
    DEFINE l_ps      LIKE sma_file.sma46        #FUN-B20031 add
    DEFINE l_ima31   LIKE ima_file.ima31
    DEFINE l_occ42   LIKE occ_file.occ42
    DEFINE l_occ44   LIKE occ_file.occ44
    DEFINE l_occ45   LIKE occ_file.occ45
    DEFINE l_price   LIKE oeb_file.oeb13
    DEFINE l_price2  LIKE oeb_file.oeb13
    DEFINE l_odm04   LIKE odm_file.odm04
    DEFINE l_odm05   LIKE odm_file.odm05
    DEFINE l_odm06   LIKE odm_file.odm06
    DEFINE l_odm07   LIKE odm_file.odm07
    DEFINE l_bdate   LIKE type_file.dat
    DEFINE l_edate   LIKE type_file.dat
    DEFINE l_odp11   LIKE odp_file.odp11       
    DEFINE l_occ76   LIKE occ_file.occ76
    DEFINE l_occ77   LIKE occ_file.occ77
    DEFINE l_count   LIKE type_file.num5  #FUN-B90101--add
    DEFINE l_ima151  LIKE ima_file.ima151 #FUN-B90101--add
    DEFINE l_imaag   LIKE ima_file.imaag  #TQC-C20117  add
    DEFINE l_odq  RECORD  LIKE odq_file.* #TQC-C20172  add
    DEFINE l_ima_yy       LIKE imaslk_file.imaslk05
    DEFINE l_now_yy       LIKE imaslk_file.imaslk05
    DEFINE l_odmacti      LIKE odm_file.odmacti      #TQC-C40197--ADD--
    DEFINE l_odmconf      LIKE odm_file.odmconf      #TQC-C40197--ADD--
    DEFINE l_n1           LIKE type_file.num5        #TQC-C40197--ADD--
    DEFINE l_sdate1        STRING                     #TQC-C40197--ADD--
    DEFINE l_edate1        STRING                     #TQC-C40197--ADD--
    DEFINE l_now          STRING                     #TQC-C40197--ADD--

    
    LET g_action_choice = ""  #FUN-D40084--add
    SELECT sma46 INTO l_ps FROM sma_file
    IF cl_null(l_ps) THEN
       LET l_ps=' '
    END IF

    IF g_check = 'Y' THEN
       CALL cl_err("",1209,0)
       RETURN
    END IF  

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_odp01 IS NULL AND g_odp02 IS NULL THEN
       RETURN
    END IF
    SELECT DISTINCT odp11 INTO l_odp11 FROM odp_file WHERE odp00=g_odp00 AND odp01=g_odp01 AND odp02=g_odp02    #FUN-B90101--add
    IF l_odp11 = 'Y' THEN
       CALL cl_err('','aap-005',0)
       RETURN
    END IF

    CALL cl_opmsg('b')
   #LET g_action_choice = ""   #FUN-D30034 add #FUN-D40084--mark

    SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
     WHERE azi01=g_odp02


    LET g_forupd_sql = "SELECT odp03,odp04,odp05,odp07,odp08,odp09,odp10,odp09*odp08,odp10*odp08 ", 
                       " FROM odp_file",
                       " WHERE odp00=? AND odp01=? AND odp02=? AND odp07=?  AND odp06=? ",
                       " FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i404_bcl CURSOR FROM g_forupd_sql     


#FUN-B20031 add----begin-----------------------------------------------------------

    LET g_forupd_sql = "SELECT * ",
                       " FROM odq_file",
                       " WHERE odq01=? AND odq02=? AND odq03=?  AND odq04=? AND odq05=? AND odq06=? AND odq08=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i404_bcl_odq CURSOR FROM g_forupd_sql

    LET g_odq04=''
#FUN-B20031 add--------------end----------------------------------------------------

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    CALL cl_set_act_visible("controlb",FALSE)  #FUN-C60021---ADD--
   
    IF g_rec_b1 > 0 THEN LET l_ac1 = 1 END IF   #FUN-D30034 add
    IF g_rec_b2 > 0 THEN LET l_ac2 = 1 END IF   #FUN-D30034 add
    IF g_rec_b3 > 0 THEN LET l_ac3 = 1 END IF   #FUN-D30034 add
    DIALOG ATTRIBUTE(UNBUFFERED)

    INPUT ARRAY g_odp  FROM s_odp.*
          ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           LET li_a=FALSE                 #FUN-C60100 add
           LET g_odq04='0'
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
           END IF
           LET g_b_flag = '1'      #FUN-D30034 add

        BEFORE ROW
           LET p_cmd1 = ''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N'          
           LET l_n  = ARR_COUNT()
           CALL i404_ima('d')  
           LET g_doc.column1 = "ima01"             #FUN-C60022---ADD--
           LET g_doc.value1  = g_odp[l_ac1].odp07  #FUN-C60022---ADD--
           CALL cl_get_fld_doc("ima04")            #FUN-C60022---ADD---
           CALL i404_b_fill_2()

           BEGIN WORK
       
           IF g_rec_b1 >= l_ac1 THEN
              LET p_cmd1='u'
              LET g_odp_t.* = g_odp[l_ac1].*  
              OPEN i404_bcl USING  g_odp00,g_odp01,g_odp02,g_odp[l_ac1].odp07,'0'
              IF STATUS THEN
                 CALL cl_err("",1125, 0)
                 LET l_lock_sw = "Y"
                 CLOSE i404_bcl
                 EXIT DIALOG
              ELSE
                 FETCH i404_bcl INTO g_odp[l_ac1].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_odp_t.odp03,SQLCA.sqlcode,0)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()    
              SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_odp[l_ac1].odp07
              #TQC-C20376----begin--------
              IF l_ima151 = 'Y' THEN
                 CALL cl_set_comp_entry("odp08",FALSE)
              ELSE
                 CALL cl_set_comp_entry("odp08",TRUE)
              END IF
              #TQC-C20376----end--------
              LET g_doc.column1 = "ima01"             #FUN-C60022---ADD--
              LET g_doc.value1  = g_odp[l_ac1].odp07  #FUN-C60022---ADD--
              CALL cl_get_fld_doc("ima04")            #FUN-C60022---ADD---
           END IF
           CALL i404_b_set_text(g_odp[l_ac1].odp07)                        #FUN-B20031 add 
           CALL i404_fill_imx(g_odp[l_ac1].odp07)                          #FUN-B20031 add   

        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd1='a'
           LET g_rec_b3_1 = 0
           LET g_rec_b3 = g_rec_b3_1
    
           CALL g_odp_2.clear()
           DISPLAY ARRAY g_odp_2 TO s_odp_2.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
              BEFORE DISPLAY
                 EXIT DISPLAY
           END DISPLAY
           
           INITIALIZE g_odp[l_ac1].* TO NULL
           LET g_odp[l_ac1].odp08 = 0     
           LET g_odp[l_ac1].odp09 = 0
           LET g_odp[l_ac1].odp10 = 0  
           LET g_odp[l_ac1].odp09a = 0
           LET g_odp[l_ac1].odp10a = 0  
           LET g_odp_t.* = g_odp[l_ac1].*    
           
           CALL i404_ima('d')  
           LET g_doc.column1 = "ima01"
           LET g_doc.value1  = g_odp[l_ac1].odp07
           CALL cl_get_fld_doc("ima04")

           CALL cl_show_fld_cont()       
           CALL i404_set_no_entry_b() 
           NEXT FIELD odp03

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

          INSERT INTO odp_file(odp00,odp01,odp02,odp03,odp04,odp05,odp06,odp07,odp08,odp09,odp10,odp11,odp12,odp13,odp14)
             VALUES(g_odp00,g_odp01,g_odp02,g_odp[l_ac1].odp03,g_odp[l_ac1].odp04,g_odp[l_ac1].odp05,
                 '0', g_odp[l_ac1].odp07, g_odp[l_ac1].odp08,g_odp[l_ac1].odp09,g_odp[l_ac1].odp10,'N',' ',g_odp13,'') 
                                                       
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","odp_file",g_odp00,g_odp[l_ac1].odp03,SQLCA.sqlcode,"","",1) 
             ROLLBACK WORK
             CANCEL INSERT
          ELSE
             SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=g_odp[l_ac1].odp07
             IF l_ima151 <> 'Y' THEN
                LET l_odq.odq00 =g_odp00
                LET l_odq.odq01 =g_odp01
                LET l_odq.odq02 =g_odp02
                LET l_odq.odq03 =g_odp[l_ac1].odp07
                LET l_odq.odq04 ='0'
                LET l_odq.odq05 =1
                LET l_odq.odq06 =g_odp[l_ac1].odp07
                LET l_odq.odq07 =g_odp[l_ac1].odp08
                LET l_odq.odq08 =' ' 
                INSERT INTO odq_file VALUES(l_odq.*)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","odq_file",g_odp00,g_odp[l_ac1].odp07,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL INSERT                   
                END IF
             END IF
             IF NOT i404_insodp2() THEN
                ROLLBACK WORK
                CANCEL INSERT
             END IF
             CALL i404_b_fill_2()
             COMMIT WORK
             LET g_rec_b1=g_rec_b1+1
             DISPLAY g_rec_b1 TO FORMONLY.cn2

          END IF
           

        AFTER FIELD odp03
           IF NOT cl_null(g_odp[l_ac1].odp03) THEN
#TQC-C40197--ADD---STR----
              SELECT count(*) INTO l_n1 FROM odm_file WHERE odm01=g_odp01 AND odm02=g_odp[l_ac1].odp03
              IF l_n1=0 OR cl_null(l_n1) THEN
                 CALL cl_err("","axm1153",0)
                 NEXT FIELD odp03
              END IF   
              SELECT odmacti,odmconf INTO l_odmacti,l_odmconf FROM odm_file
               WHERE odm01=g_odp01 AND odm02=g_odp[l_ac1].odp03
              IF l_odmacti<>'Y' THEN
                 CALL cl_err("","axm1151",0)
                 NEXT FIELD odp03
              END IF
              IF l_odmconf<>'Y' THEN
                 CALL cl_err("","axm1152",0)
                 NEXT FIELD odp03
              END IF  
              
#TQC-C40197--ADD---END------

             IF (g_odp[l_ac1].odp03!=g_odp_t.odp03 OR g_odp_t.odp03 IS NULL) THEN
                SELECT odm04,odm05,odm06,odm07 INTO l_odm04,l_odm05,l_odm06,l_odm07
                  FROM odm_file
                WHERE odm01=g_odp01 AND odm02=g_odp[l_ac1].odp03 
                  AND odmacti = 'Y' AND odmconf = 'Y'        #TQC-C20134--add odmacti = 'Y' AND odmconf = 'Y' 
                CALL s_ymtodate(l_odm04,l_odm05,l_odm06,l_odm07) RETURNING l_bdate,l_edate
                IF g_today > l_edate OR g_today < l_bdate THEN
                   CALL cl_err('',3002,0)
                   LET g_odp[l_ac1].*=g_odp_t.*
                   NEXT FIELD odp03
                END IF

                IF g_odp[l_ac1].odp04 IS NOT NULL AND
                    g_odp[l_ac1].odp05 IS NOT NULL THEN
                   SELECT COUNT(*) INTO l_n FROM odm_file,odn_file
                    WHERE odm01=odn01 AND odm02=odn02
                      AND odmacti = 'Y' AND odmconf = 'Y'        #TQC-C20134--add odmacti = 'Y' AND odmconf = 'Y'   
                      AND odn01=g_odp01 AND odn02=g_odp[l_ac1].odp03
                      AND odn03=g_odp[l_ac1].odp04 AND odn04=g_odp[l_ac1].odp05
                   IF cl_null(l_n) OR l_n=0 THEN
                      CALL cl_err("",3000,0)
                      LET g_odp[l_ac1].*=g_odp_t.*
                      NEXT FIELD odp03
                   END IF

                   SELECT odn05 INTO g_odp[l_ac1].odp07
                     FROM odn_file
                    WHERE odn02 = g_odp[l_ac1].odp03
                      AND odn01 = g_odp01
                      AND odn03 = g_odp[l_ac1].odp04
                      AND odn04 = g_odp[l_ac1].odp05
                   IF SQLCA.sqlcode=100 THEN
                      CALL cl_err("",1114,0)
                      LET g_odp[l_ac1].*=g_odp_t.*
                      NEXT FIELD odp03
                   END IF
                   DISPLAY g_odp[l_ac1].odp07 TO odp07

                   SELECT COUNT(*) INTO l_n FROM odp_file
                    WHERE odp00=g_odp00
                      AND odp01=g_odp01
                      AND odp02=g_odp02
                      AND odp06='0'
                      AND odp07=g_odp[l_ac1].odp07
                      AND odp12=' '
                   IF NOT cl_null(l_n) AND l_n>0 THEN
                      CALL cl_err("",-239,0)
                      LET g_odp[l_ac1].*=g_odp_t.*
                      NEXT FIELD odp03
                   END IF

                 #TQC-C20117--add--begin--
                   SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_odp[l_ac1].odp07
                                                            AND ima1010='1' and imaacti='Y'
                   IF l_n=0 THEN
                      CALL cl_err('','100',0)
                      LET g_odp[l_ac1].*=g_odp_t.*
                      NEXT FIELD odp03
                   END IF
                   SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file
                    WHERE ima01=g_odp[l_ac1].odp07 AND imaacti='Y'
                   IF l_ima151='N' AND l_imaag='@CHILD' THEN
                      CALL cl_err('','axm1104',0)
                      LET g_odp[l_ac1].*=g_odp_t.*
                      NEXT FIELD odp03 
                   END IF
                 #TQC-C20172-add--begin--
                   SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_odp[l_ac1].odp07
                   IF l_ima151 = 'Y' THEN
                      CALL cl_set_comp_entry("odp08",FALSE)
                   ELSE
                      CALL cl_set_comp_entry("odp08",TRUE)
                   END IF
                 #TQC-C20172-add--end--    
                 #TQC-C20117--add--end--
                    LET g_odp[l_ac1].odp08=0
                    DISPLAY g_odp[l_ac1].odp07 TO odp07
                    DISPLAY g_odp[l_ac1].odp08 TO odp08

                   SELECT ima31 INTO l_ima31 FROM ima_file WHERE ima01=g_odp[l_ac1].odp07
                   SELECT occ42,occ44,occ45,occ76,occ77 INTO l_occ42,l_occ44,l_occ45,l_occ76,l_occ77 FROM occ_file WHERE occ01=g_odp02
                   CALL s_fetch_price_new(g_odp02,g_odp[l_ac1].odp07,'',l_ima31,g_today,'5',g_plant,l_occ42,l_occ44,l_occ45,'','',1,'','a')  #FUN-BC0071 
                      RETURNING l_price,l_price2

                   IF cl_null(l_occ76) THEN LET l_occ76=100 END IF
                   IF cl_null(l_occ77) THEN LET l_occ77=100 END IF
                   LET l_now_yy = YEAR( g_today ) 
                   SELECT imaslk05 INTO l_ima_yy FROM imaslk_file WHERE imaslk00 = g_odp[l_ac1].odp07
                   IF NOT (cl_null(l_ima_yy) OR l_ima_yy=0) THEN
                      LET l_n = l_now_yy - l_ima_yy
                      IF l_n>0 THEN
                         LET l_occ76 = l_occ76-l_n*10
                         LET l_occ77 = l_occ77-l_n*10
                         IF l_occ76<10 THEN  #最低折扣为10
                            LET l_occ76 = 10
                         END IF
                         IF l_occ77<10 THEN  #最低折扣为10
                            LET l_occ77 = 10
                         END IF
                      END IF
                   END IF
                   IF cl_null(l_occ76) THEN LET l_occ76=100 END IF
                   IF cl_null(l_occ77) THEN LET l_occ77=100 END IF

                   IF g_odp13='1' THEN    #期貨
                      LET l_price2=l_price*l_occ76/100
                   ELSE                   #現貨
                      LET l_price2=l_price*l_occ77/100
                   END IF

                   CALL cl_digcut(l_price,t_azi03) RETURNING g_odp[l_ac1].odp09
                   CALL cl_digcut(l_price2,t_azi03) RETURNING g_odp[l_ac1].odp10
                   DISPLAY g_odp[l_ac1].odp09 TO odp09
                   DISPLAY g_odp[l_ac1].odp10 TO odp10

                END IF
                CALL i404_ima('d')
                LET g_doc.column1 = "ima01"             #FUN-C60022--ADD--
                LET g_doc.value1  = g_odp[l_ac1].odp07  #FUN-C60022--ADD---
                CALL cl_get_fld_doc("ima04")            #FUN-C60022--ADD---
                CALL i404_b_fill_2()
                CALL i404_b_set_text(g_odp[l_ac1].odp07)
                CALL i404_fill_imx(g_odp[l_ac1].odp07)
             END IF
           END IF

        AFTER FIELD odp04
           IF NOT cl_null(g_odp[l_ac1].odp04) THEN
              IF (g_odp[l_ac1].odp04!=g_odp_t.odp04 OR g_odp_t.odp04 IS NULL) THEN
                 IF g_odp[l_ac1].odp04 IS NOT NULL AND g_odp[l_ac1].odp05 IS NOT NULL THEN
                   SELECT COUNT(*) INTO l_n FROM odm_file,odn_file
                     WHERE odm01=odn01 AND odm02=odn02
                       AND odmacti = 'Y' AND odmconf = 'Y'        #TQC-C20134--add odmacti = 'Y' AND odmconf = 'Y'   
                       AND odn01=g_odp01 AND odn02=g_odp[l_ac1].odp03
                       AND odn03=g_odp[l_ac1].odp04 AND odn04=g_odp[l_ac1].odp05
                   IF cl_null(l_n) OR l_n=0 THEN
                      CALL cl_err("",3000,0)
                      LET g_odp[l_ac1].*=g_odp_t.*
                      NEXT FIELD odp04
                   END IF
   
                   SELECT odn05 INTO g_odp[l_ac1].odp07 FROM odn_file
                    WHERE odn02 = g_odp[l_ac1].odp03
                      AND odn01 = g_odp01
                      AND odn03 = g_odp[l_ac1].odp04
                      AND odn04 = g_odp[l_ac1].odp05
                   IF SQLCA.sqlcode=100 THEN
                      CALL cl_err("",1114,0)
                      LET g_odp[l_ac1].*=g_odp_t.*
                      NEXT FIELD odp03
                   END IF
                   DISPLAY g_odp[l_ac1].odp07 TO odp07

                   SELECT COUNT(*) INTO l_n FROM odp_file
                    WHERE odp00=g_odp00
                      AND odp01=g_odp01
                      AND odp02=g_odp02
                      AND odp06='0'
                      AND odp07=g_odp[l_ac1].odp07
                      AND odp12=' '
                   IF NOT cl_null(l_n) AND l_n>0 THEN
                      CALL cl_err("",-239,0)
                      LET g_odp[l_ac1].*=g_odp_t.*
                      NEXT FIELD odp04
                   END IF

                 #TQC-C20117--add--begin--
                   SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_odp[l_ac1].odp07
                                                            AND ima1010='1' and imaacti='Y'
                   IF l_n=0 THEN
                      CALL cl_err('','100',0)
                      LET g_odp[l_ac1].*=g_odp_t.*
                      NEXT FIELD odp03
                   END IF
                   SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file
                    WHERE ima01=g_odp[l_ac1].odp07 AND imaacti='Y'
                   IF l_ima151='N' AND l_imaag='@CHILD' THEN
                      CALL cl_err('','axm1104',0)
                      LET g_odp[l_ac1].*=g_odp_t.*
                      NEXT FIELD odp03
                   END IF
                 #TQC-C20117--add--end--
                   SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_odp[l_ac1].odp07
                   IF l_ima151 = 'Y' THEN
                      CALL cl_set_comp_entry("odp08",FALSE)
                   ELSE
                      CALL cl_set_comp_entry("odp08",TRUE)
                   END IF

                    LET g_odp[l_ac1].odp08=0
                    DISPLAY g_odp[l_ac1].odp08 TO odp08
                    SELECT ima31 INTO l_ima31 FROM ima_file WHERE ima01=g_odp[l_ac1].odp07
                    SELECT occ42,occ44,occ45,occ76,occ77 INTO l_occ42,l_occ44,l_occ45,l_occ76,l_occ77 FROM occ_file WHERE occ01=g_odp02
                    CALL s_fetch_price_new(g_odp02,g_odp[l_ac1].odp07,'',l_ima31,g_today,'5',g_plant,l_occ42,l_occ44,l_occ45,'','',1,'','a')  #FUN-BC0071
                       RETURNING l_price,l_price2

                    IF cl_null(l_occ76) THEN LET l_occ76=100 END IF
                    IF cl_null(l_occ77) THEN LET l_occ77=100 END IF
                    LET l_now_yy = YEAR( g_today )
                    SELECT imaslk05 INTO l_ima_yy FROM imaslk_file WHERE imaslk00 = g_odp[l_ac1].odp07
                    IF NOT (cl_null(l_ima_yy) OR l_ima_yy=0) THEN
                       LET l_n = l_now_yy - l_ima_yy
                       IF l_n>0 THEN
                          LET l_occ76 = l_occ76-l_n*10
                          LET l_occ77 = l_occ77-l_n*10
                          IF l_occ76<10 THEN  #最低折扣为10
                             LET l_occ76 = 10
                          END IF
                          IF l_occ77<10 THEN  #最低折扣为10
                             LET l_occ77 = 10
                          END IF
                       END IF
                    END IF
                    IF cl_null(l_occ76) THEN LET l_occ76=100 END IF
                    IF cl_null(l_occ77) THEN LET l_occ77=100 END IF

                    IF g_odp13='1' THEN    #期貨
                       LET l_price2=l_price*l_occ76/100
                    ELSE                   #現貨
                       LET l_price2=l_price*l_occ77/100
                    END IF

                    CALL cl_digcut(l_price,t_azi03) RETURNING g_odp[l_ac1].odp09
                    CALL cl_digcut(l_price2,t_azi03) RETURNING g_odp[l_ac1].odp10
                    DISPLAY g_odp[l_ac1].odp09 TO odp09
                    DISPLAY g_odp[l_ac1].odp10 TO odp10

                 END IF
                 CALL i404_ima('d')
                 LET g_doc.column1 = "ima01"             #FUN-C60022--ADD--
                 LET g_doc.value1  = g_odp[l_ac1].odp07  #FUN-C60022--ADD---
                 CALL cl_get_fld_doc("ima04")            #FUN-C60022--ADD---
                 CALL i404_b_fill_2()
                 CALL i404_b_set_text(g_odp[l_ac1].odp07)
                 CALL i404_fill_imx(g_odp[l_ac1].odp07)
              END IF
           END IF


        AFTER FIELD odp05
           IF NOT cl_null(g_odp[l_ac1].odp05) THEN
              IF (g_odp[l_ac1].odp05!=g_odp_t.odp05 OR g_odp_t.odp05 IS NULL) THEN
                 IF g_odp[l_ac1].odp03 IS NOT NULL AND  g_odp[l_ac1].odp04 IS NOT NULL AND
                     g_odp[l_ac1].odp05 IS NOT NULL THEN
   
                    SELECT COUNT(*) INTO l_n FROM odm_file,odn_file
                      WHERE odm01=odn01 AND odm02=odn02
                        AND odmacti = 'Y' AND odmconf = 'Y'        #TQC-C20134--add odmacti = 'Y' AND odmconf = 'Y'   
                        AND odn01=g_odp01 AND odn02=g_odp[l_ac1].odp03
                        AND odn03=g_odp[l_ac1].odp04 AND odn04=g_odp[l_ac1].odp05
                    IF cl_null(l_n) OR l_n=0 THEN
                       CALL cl_err("",3000,0)
                       LET g_odp[l_ac1].*=g_odp_t.*
                       NEXT FIELD odp05
                    END IF
   
                    SELECT odn05 INTO g_odp[l_ac1].odp07 FROM odn_file
                     WHERE odn02 = g_odp[l_ac1].odp03
                       AND odn01 = g_odp01
                       AND odn03 = g_odp[l_ac1].odp04
                       AND odn04 = g_odp[l_ac1].odp05
                    IF SQLCA.sqlcode=100 THEN
                       CALL cl_err("",1114,0)
                       LET g_odp[l_ac1].*=g_odp_t.*
                       NEXT FIELD odp03
                    END IF
                    DISPLAY g_odp[l_ac1].odp07 TO odp07

                    SELECT COUNT(*) INTO l_n FROM odp_file
                     WHERE odp00=g_odp00
                       AND odp01=g_odp01
                       AND odp02=g_odp02
                       AND odp06='0'
                       AND odp07=g_odp[l_ac1].odp07
                       AND odp12=' '
                    IF NOT cl_null(l_n) AND l_n>0 THEN
                       CALL cl_err("",-239,0)
                       LET g_odp[l_ac1].*=g_odp_t.*
                       NEXT FIELD odp05
                    END IF

                 #TQC-C20117--add--begin--
                    SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_odp[l_ac1].odp07
                                                             AND ima1010='1' and imaacti='Y'
                    IF l_n=0 THEN
                       CALL cl_err('','100',0)
                       LET g_odp[l_ac1].*=g_odp_t.*
                       NEXT FIELD odp03
                    END IF
                    SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file
                     WHERE ima01=g_odp[l_ac1].odp07 AND imaacti='Y'
                    IF l_ima151='N' AND l_imaag='@CHILD' THEN
                       CALL cl_err('','axm1104',0)
                       LET g_odp[l_ac1].*=g_odp_t.*
                       NEXT FIELD odp03
                    END IF
                 #TQC-C20117--add--end--
                    SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_odp[l_ac1].odp07
                    IF l_ima151 = 'Y' THEN
                       CALL cl_set_comp_entry("odp08",FALSE)
                    ELSE
                       CALL cl_set_comp_entry("odp08",TRUE)
                    END IF
                    LET g_odp[l_ac1].odp08=0
                    DISPLAY g_odp[l_ac1].odp08 TO odp08
                    SELECT ima31 INTO l_ima31 FROM ima_file WHERE ima01=g_odp[l_ac1].odp07
                    SELECT occ42,occ44,occ45,occ76,occ77 INTO l_occ42,l_occ44,l_occ45,l_occ76,l_occ77 FROM occ_file WHERE occ01=g_odp02
                    CALL s_fetch_price_new(g_odp02,g_odp[l_ac1].odp07,'',l_ima31,g_today,'5',g_plant,l_occ42,l_occ44,l_occ45,'','',1,'','a')  #FUN-BC0071
                       RETURNING l_price,l_price2

                    IF cl_null(l_occ76) THEN LET l_occ76=100 END IF
                    IF cl_null(l_occ77) THEN LET l_occ77=100 END IF
                    LET l_now_yy = YEAR( g_today )
                    SELECT imaslk05 INTO l_ima_yy FROM imaslk_file WHERE imaslk00 = g_odp[l_ac1].odp07
                    IF NOT (cl_null(l_ima_yy) OR l_ima_yy=0) THEN
                       LET l_n = l_now_yy - l_ima_yy
                       IF l_n>0 THEN
                          LET l_occ76 = l_occ76-l_n*10
                          LET l_occ77 = l_occ77-l_n*10
                          IF l_occ76<10 THEN  #最低折扣为10
                             LET l_occ76 = 10
                          END IF
                          IF l_occ77<10 THEN  #最低折扣为10
                             LET l_occ77 = 10
                          END IF
                       END IF
                    END IF
                   IF cl_null(l_occ76) THEN LET l_occ76=100 END IF
                   IF cl_null(l_occ77) THEN LET l_occ77=100 END IF

                    IF g_odp13='1' THEN    #期貨
                       LET l_price2=l_price*l_occ76/100
                    ELSE                   #現貨
                       LET l_price2=l_price*l_occ77/100
                    END IF

                    CALL cl_digcut(l_price,t_azi03) RETURNING g_odp[l_ac1].odp09
                    CALL cl_digcut(l_price2,t_azi03) RETURNING g_odp[l_ac1].odp10
                    DISPLAY g_odp[l_ac1].odp09 TO odp09
                    DISPLAY g_odp[l_ac1].odp10 TO odp10
                 END IF
                 CALL i404_ima('d')
                 LET g_doc.column1 = "ima01"             #FUN-C60022--ADD--
                 LET g_doc.value1  = g_odp[l_ac1].odp07  #FUN-C60022--ADD---
                 CALL cl_get_fld_doc("ima04")            #FUN-C60022--ADD---
                 CALL i404_b_fill_2()
                 CALL i404_b_set_text(g_odp[l_ac1].odp07)
                 CALL i404_fill_imx(g_odp[l_ac1].odp07)
              END IF
           END IF
     
     #TQC-C20327--add--begin-- 
        AFTER FIELD odp08
           #TQC-C40197----ADD--STR----
           IF NOT cl_null(g_odp[l_ac1].odp08) THEN
              IF g_odp[l_ac1].odp08<0 THEN
                 CALL cl_err("","axm1154",0)
                 NEXT FIELD odp08
              END IF
           END IF     
           #TQC-C40197------ADD---END------
           IF g_odp[l_ac1].odp08 <> g_odp_t.odp08 OR g_odp_t.odp08 IS NULL THEN
              LET g_odp[l_ac1].odp09a=g_odp[l_ac1].odp09*g_odp[l_ac1].odp08
              LET g_odp[l_ac1].odp10a=g_odp[l_ac1].odp10*g_odp[l_ac1].odp08

              CALL cl_digcut(g_odp[l_ac1].odp09a,t_azi04) RETURNING g_odp[l_ac1].odp09a
              CALL cl_digcut(g_odp[l_ac1].odp10a,t_azi04) RETURNING g_odp[l_ac1].odp10a 
           END IF 
     #TQC-C20327--add--end-- 
#FUN-C60022---ADD---STR----
        AFTER FIELD odp07
           IF NOT cl_null(g_odp[l_ac1].odp07) THEN  
              IF (g_odp[l_ac1].odp07!=g_odp_t.odp07 OR g_odp_t.odp07 IS NULL) THEN
   
                    SELECT COUNT(*) INTO l_n FROM odm_file,odn_file
                      WHERE odm01=odn01 AND odm02=odn02
                        AND odmacti = 'Y' AND odmconf = 'Y'    
                        AND odn01=g_odp01 
                        AND odn05=g_odp[l_ac1].odp07
                    IF cl_null(l_n) OR l_n=0 THEN
                       CALL cl_err("","axm1164",0)
                       LET g_odp[l_ac1].odp07=g_odp_t.odp07
                       NEXT FIELD odp07
                    END IF
                    

                    SELECT COUNT(*) INTO l_n FROM odp_file
                     WHERE odp00=g_odp00
                       AND odp01=g_odp01
                       AND odp02=g_odp02
                       AND odp06='0'
                       AND odp07=g_odp[l_ac1].odp07
                       AND odp12=' '
                    IF NOT cl_null(l_n) AND l_n>0 THEN
                       CALL cl_err("",-239,0)
                       LET g_odp[l_ac1].odp07=g_odp_t.odp07
                       NEXT FIELD odp07
                    END IF
                    SELECT odn02,odn03,odn04
                      INTO g_odp[l_ac1].odp03,g_odp[l_ac1].odp04,g_odp[l_ac1].odp05
                      FROM odn_file
                     WHERE odn01=g_odp01
                       AND odn05=g_odp[l_ac1].odp07 
                    IF SQLCA.sqlcode=100 THEN
                       CALL cl_err("",1114,0)
                       LET g_odp[l_ac1].odp07=g_odp_t.odp07
                       NEXT FIELD odp07
                    END IF
                    DISPLAY g_odp[l_ac1].odp03,g_odp[l_ac1].odp04,g_odp[l_ac1].odp05
                         TO odp03,odp04,odp05

                    SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_odp[l_ac1].odp07
                                                             AND ima1010='1' and imaacti='Y'
                    IF l_n=0 THEN
                       CALL cl_err('','100',0)
                       LET g_odp[l_ac1].odp07=g_odp_t.odp07
                       NEXT FIELD odp07
                    END IF
                    SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file
                     WHERE ima01=g_odp[l_ac1].odp07 AND imaacti='Y'
                    IF l_ima151='N' AND l_imaag='@CHILD' THEN
                       CALL cl_err('','axm1104',0)
                       LET g_odp[l_ac1].odp07=g_odp_t.odp07
                       NEXT FIELD odp07
                    END IF
                    SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_odp[l_ac1].odp07
                    IF l_ima151 = 'Y' THEN
                       CALL cl_set_comp_entry("odp08",FALSE)
                    ELSE
                       CALL cl_set_comp_entry("odp08",TRUE)
                    END IF
                    LET g_odp[l_ac1].odp08=0
                    DISPLAY g_odp[l_ac1].odp08 TO odp08
                    SELECT ima31 INTO l_ima31 FROM ima_file WHERE ima01=g_odp[l_ac1].odp07
                    SELECT occ42,occ44,occ45,occ76,occ77 INTO l_occ42,l_occ44,l_occ45,l_occ76,l_occ77 FROM occ_file WHERE occ01=g_odp02
                    CALL s_fetch_price_new(g_odp02,g_odp[l_ac1].odp07,'',l_ima31,g_today,'5',g_plant,l_occ42,l_occ44,l_occ45,'','',1,'','a')  #FUN-BC0071
                       RETURNING l_price,l_price2

                    IF cl_null(l_occ76) THEN LET l_occ76=100 END IF
                    IF cl_null(l_occ77) THEN LET l_occ77=100 END IF
                    LET l_now_yy = YEAR( g_today )
                    SELECT imaslk05 INTO l_ima_yy FROM imaslk_file WHERE imaslk00 = g_odp[l_ac1].odp07
                    IF NOT (cl_null(l_ima_yy) OR l_ima_yy=0) THEN
                       LET l_n = l_now_yy - l_ima_yy
                       IF l_n>0 THEN
                          LET l_occ76 = l_occ76-l_n*10
                          LET l_occ77 = l_occ77-l_n*10
                          IF l_occ76<10 THEN  #最低折扣为10
                             LET l_occ76 = 10
                          END IF
                          IF l_occ77<10 THEN  #最低折扣为10
                             LET l_occ77 = 10
                          END IF
                       END IF
                    END IF
                   IF cl_null(l_occ76) THEN LET l_occ76=100 END IF
                   IF cl_null(l_occ77) THEN LET l_occ77=100 END IF

                    IF g_odp13='1' THEN    #期貨
                       LET l_price2=l_price*l_occ76/100
                    ELSE                   #現貨
                       LET l_price2=l_price*l_occ77/100
                    END IF

                    CALL cl_digcut(l_price,t_azi03) RETURNING g_odp[l_ac1].odp09
                    CALL cl_digcut(l_price2,t_azi03) RETURNING g_odp[l_ac1].odp10
                    DISPLAY g_odp[l_ac1].odp09 TO odp09
                    DISPLAY g_odp[l_ac1].odp10 TO odp10
                 CALL i404_ima('d')
                 LET g_doc.column1 = "ima01"
                 LET g_doc.value1  = g_odp[l_ac1].odp07
                 CALL cl_get_fld_doc("ima04")
                 CALL i404_b_fill_2()
                 CALL i404_b_set_text(g_odp[l_ac1].odp07)
                 CALL i404_fill_imx(g_odp[l_ac1].odp07)
              END IF
           END IF
#FUN-C60022-----ADD----END------- 
#       AFTER FIELD odp07
#          IF NOT cl_null(g_odp[l_ac1].odp03) AND NOT cl_null(g_odp[l_ac1].odp04) AND 
#             NOT cl_null(g_odp[l_ac1].odp05) THEN
#             SELECT COUNT(*) INTO l_n FROM odm_file,odn_file
#               WHERE odm01=odn01 AND odm02=odn02
#                 AND odn01=g_odp01 AND odn02=g_odp[l_ac1].odp03
#                 AND odn03=g_odp[l_ac1].odp04 AND odn04=g_odp[l_ac1].odp05
#             IF cl_null(l_n) OR l_n=0 THEN
#                CALL cl_err("",1114,0)
#                NEXT FIELD odp07
#             END IF
#
#             IF p_cmd1="a" THEN
#                CALL i404_ima('d')
#                CALL i404_b_fill_2()
#             END IF 
#             IF p_cmd1 = "a" OR  (p_cmd1 ="u" AND g_odp[l_ac1].odp07 != g_odp_t.odp07) THEN
#                SELECT count(*) INTO l_n
#                  FROM odp_file
#                 WHERE odp01 = g_odp01
#                   AND odp02 = g_odp02
#                   AND odp00 = g_odp00
#                   AND odp06 = '0'
#                   AND odp07 = g_odp[l_ac1].odp07
#                   AND odp12 = ' '
#                IF l_n > 0 THEN
#                   CALL cl_err(" ",1117,0)
#                   NEXT FIELD odp03
#                END IF
#             END IF
#             let g_doc.column1 = "ima01"
#             let g_doc.value1  = g_odp[l_ac1].odp07
#             call cl_get_fld_doc("ima04")
#          
#          ELSE
#             SELECT count(*) INTO l_n FROM ima_file
#              WHERE ima01 = g_odp[l_ac1].odp07
#             IF l_n=0 THEN
#                CALL cl_err(" ",1113,0)
#                NEXT FIELD odp03
#             ELSE
#                IF p_cmd1=" " THEN
#                   NexT FIELD odp08
#                END IF 
#                IF p_cmd1 = "a" OR  (p_cmd1 ="u" AND g_odp[l_ac1].odp07 != g_odp_t.odp07) THEN
#                   SELECT count(*) INTO l_n
#                     FROM odp_file
#                    WHERE odp01 = g_odp01
#                      AND odp02 = g_odp02
#                      AND odp00 = g_odp00
#                      AND odp06 = '0'
#                      AND odp07 = g_odp[l_ac1].odp07
#                      AND odp12 = ' '
#                   IF l_n > 0 THEN
#                      CALL cl_err(" ",1117,0)
#                      NEXT FIELD odp07
#                   END IF
#                END IF
#                      
#                IF p_cmd1="a" THEN
#                   CALL i404_ima('d')
#                   CALL i404_b_fill_2()
#                END IF 
#             END IF    
#          END IF
#          SELECT ima31 INTO l_ima31 FROM ima_file WHERE ima01=g_odp[l_ac1].odp07
#          SELECT occ42,occ44,occ45 INTO l_occ42,l_occ44,l_occ45 FROM occ_file WHERE occ01=g_odp02
#          CALL s_fetch_price_new(g_odp02,g_odp[l_ac1].odp07,l_ima31,g_today,'1',g_plant,l_occ42,l_occ44,l_occ45,'','',1,'','a')
#             RETURNING g_odp[l_ac1].odp10,g_odp[l_ac1].odp09
#          LET g_odp[l_ac1].odp10=g_odp[l_ac1].odp10*g_odp[l_ac1].odp08
#          LET g_odp[l_ac1].odp09=g_odp[l_ac1].odp09*g_odp[l_ac1].odp08
#
#          CALL i404_b_set_text(g_odp[l_ac1].odp07)                        #FUN-B20031 add
#          CALL i404_fill_imx(g_odp[l_ac1].odp07)                          #FUN-B20031 add

        BEFORE DELETE
           CALL cl_set_act_visible("ACCEPT",TRUE)
           IF NOT i404_rr() THEN
              ROLLBACK WORK
              CANCEL DELETE
           END IF
           LET g_rec_b1=g_rec_b1-1

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_odp[l_ac1].* = g_odp_t.*
              CLOSE i404_bcl
              ROLLBACK WORK
              EXIT DIALOG
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_odp[l_ac1].odp07,-263,0)
              LET g_odp[l_ac1].* = g_odp_t.*
           ELSE
              UPDATE odp_file SET 
                               odp03=g_odp[l_ac1].odp03,
                               odp04=g_odp[l_ac1].odp04,
                               odp05=g_odp[l_ac1].odp05,
                               odp07=g_odp[l_ac1].odp07,
                               odp08=g_odp[l_ac1].odp08,
                               odp09=g_odp[l_ac1].odp09,
                               odp10=g_odp[l_ac1].odp10
              WHERE odp01=g_odp01
                AND odp02=g_odp02
                AND odp00=g_odp00
                AND odp07=g_odp_t.odp07
                AND odp12=' '
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","odp_file",g_odp00,g_odp_t.odp07,SQLCA.sqlcode,"","",1) 
                 LET g_odp[l_ac1].* = g_odp_t.*
                 CLOSE i404_bcl
                 ROLLBACK WORK
                 EXIT DIALOG
              ELSE
                 IF NOT i404_updodp2() THEN
                    LET g_odp[l_ac1].* = g_odp_t.*
                    CLOSE i404_bcl
                    ROLLBACK WORK
                    EXIT DIALOG
                 END IF
                 CALL i404_b_fill_2()
                 COMMIT WORK
              END IF
           END IF

         
      ON ACTION controlp    
         IF INFIELD(odp03) THEN                                                  
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form="q_odn03"                                                                                               
            LET g_qryparam.where=" odmconf='Y' AND odn05 IN(SELECT ima01 FROM ima_file where ima151<>'N' OR imaag<>'@CHILD' OR imaag IS NULL) "    #TQC-C20117  add#TQC-C40197-ADD odmconf
            LET g_qryparam.arg1=g_odp01
            LET g_qryparam.default1=g_odp[l_ac1].odp03
            LET g_qryparam.default2=g_odp[l_ac1].odp04
            LET g_qryparam.default3=g_odp[l_ac1].odp05
            LET g_qryparam.default4=g_odp[l_ac1].odp07
            CALL cl_create_qry() RETURNING g_odp[l_ac1].odp03,g_odp[l_ac1].odp04,g_odp[l_ac1].odp05,g_odp[l_ac1].odp07                 
            DISPLAY BY NAME g_odp[l_ac1].odp03,g_odp[l_ac1].odp07
            DISPLAY BY NAME g_odp[l_ac1].odp04,g_odp[l_ac1].odp05
            NEXT FIELD odp03
         END IF
         IF INFIELD(odp04) THEN                                                  
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form="q_odn03"                                                                                               
            LET g_qryparam.where=" odmconf='Y' AND odn05 IN(SELECT ima01 FROM ima_file where ima151<>'N' OR imaag<>'@CHILD' OR imaag IS NULL) "    #TQC-C20117  add #TQC-C40197--ADD odmconf
            LET g_qryparam.arg1=g_odp01
            LET g_qryparam.default1=g_odp[l_ac1].odp03
            LET g_qryparam.default2=g_odp[l_ac1].odp04
            LET g_qryparam.default3=g_odp[l_ac1].odp05
            LET g_qryparam.default4=g_odp[l_ac1].odp07
            CALL cl_create_qry() RETURNING g_odp[l_ac1].odp03,g_odp[l_ac1].odp04,g_odp[l_ac1].odp05,g_odp[l_ac1].odp07
            DISPLAY BY NAME g_odp[l_ac1].odp03,g_odp[l_ac1].odp07
            DISPLAY BY NAME g_odp[l_ac1].odp04,g_odp[l_ac1].odp05
            NEXT FIELD odp04
         END IF
         IF INFIELD(odp05) THEN                                                  
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form="q_odn03"                                                                                               
            LET g_qryparam.where=" odmconf='Y' AND odn05 IN(SELECT ima01 FROM ima_file where ima151<>'N' OR imaag<>'@CHILD' OR imaag IS NULL) "  #TQC-C20117  add  #TQC-C40197--ADD odmconf
            LET g_qryparam.arg1=g_odp01
            LET g_qryparam.default1=g_odp[l_ac1].odp03
            LET g_qryparam.default2=g_odp[l_ac1].odp04
            LET g_qryparam.default3=g_odp[l_ac1].odp05
            LET g_qryparam.default4=g_odp[l_ac1].odp07
            CALL cl_create_qry() RETURNING g_odp[l_ac1].odp03,g_odp[l_ac1].odp04,g_odp[l_ac1].odp05,g_odp[l_ac1].odp07
            DISPLAY BY NAME g_odp[l_ac1].odp03,g_odp[l_ac1].odp07
            DISPLAY BY NAME g_odp[l_ac1].odp04,g_odp[l_ac1].odp05
            NEXT FIELD odp05
         END IF
#FUN-C60022----ADD-----STR----
         IF INFIELD(odp07) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form="q_odn03"
            LET g_qryparam.where=" odmconf='Y' AND odn05 IN(SELECT ima01 FROM ima_file where ima151<>'N' OR imaag<>'@CHILD' OR imaag IS NULL) "
            LET g_qryparam.arg1=g_odp01
            LET g_qryparam.default1=g_odp[l_ac1].odp03
            LET g_qryparam.default2=g_odp[l_ac1].odp04
            LET g_qryparam.default3=g_odp[l_ac1].odp05
            LET g_qryparam.default4=g_odp[l_ac1].odp07
            CALL cl_create_qry() RETURNING g_odp[l_ac1].odp03,g_odp[l_ac1].odp04,g_odp[l_ac1].odp05,g_odp[l_ac1].odp07
            DISPLAY BY NAME g_odp[l_ac1].odp03,g_odp[l_ac1].odp07
            DISPLAY BY NAME g_odp[l_ac1].odp04,g_odp[l_ac1].odp05
            NEXT FIELD odp07
         END IF
#FUN-C60022----ADD----END------
         
        AFTER ROW

           LET l_ac1 = ARR_CURR()
           LET l_ac1_t = l_ac1
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd1 = 'u' THEN
                 Let g_odp[l_ac1].* = g_odp_t.*
              END IF
              CLOSE i404_bcl
              ROLLBACK WORK
              EXIT DIALOG
           END IF
           CLOSE i404_bcl
           COMMIT WORK

       #TQC-C20224--add--begin--   
        AFTER INPUT
           IF INT_FLAG THEN                         # 若按了DEL鍵
              LET INT_FLAG = 0
              EXIT DIALOG
           END IF
       #TQC-C20224--add--end--

    END INPUT

#FUN-B20031 add----------------begin----------------------------------------------

       INPUT ARRAY g_imx FROM s_imx.*
             ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
             INSERT ROW=TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
          BEFORE INPUT
              LET li_a=TRUE                 #FUN-C60100 add   
#              IF l_ac3=0 THEN LET l_ac3=1 END IF
              IF g_rec_b3 != 0 THEN 
                 CALL fgl_set_arr_curr(l_ac3)
              END IF
              LET g_b_flag = '3'      #FUN-D30034 add

          BEFORE ROW 
             LET p_cmd3 = ''
             LET l_ac3 = ARR_CURR()
             #LET l_n  = ARR_COUNT()            
             INITIALIZE g_imx_t.* TO NULL

             IF cl_null(g_imx[l_ac3].count) THEN
                LET g_imx[l_ac3].count=0 
             END IF

             BEGIN WORK
 
             IF g_odq04='0' THEN      #主商品
                OPEN i404_bcl USING g_odp00,g_odp01,g_odp02,g_odp[l_ac1].odp07,g_odq04
                IF STATUS THEN
                   CALL cl_err("OPEN i404_cl:", STATUS, 1)
                   CLOSE i404_bcl
                   ROLLBACK WORK
                   RETURN
                END IF
                FETCH i404_bcl INTO g_odp[l_ac1].*               # 對DB鎖定
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_odp00,SQLCA.sqlcode,0)
                   CLOSE i404_bcl
                   ROLLBACK WORK
                   RETURN
                END IF

                LET l_odq03=g_odp[l_ac1].odp07
                LET l_odq08=' '
             END IF

             IF g_odq04='1' THEN      #關聯商品
                LET l_odq03=g_odp_2[l_ac2].odp07_2
                LET l_odq08=g_odp[l_ac1].odp07
             END IF

             IF g_rec_b3 >= l_ac3 THEN
                LET p_cmd3='u'
                LET g_imx_t.* = g_imx[l_ac3].*  
                LET l_lock_sw = 'N'           
 
             END IF
           
           BEFORE INSERT
             LET p_cmd3='a'
             LET l_ac3 = ARR_CURR()
             INITIALIZE g_imx_t.* TO NULL
             INITIALIZE g_imx[l_ac3].* TO NULL
             LET g_imx[l_ac3].imx01=0
             LET g_imx[l_ac3].imx02=0
             LET g_imx[l_ac3].imx03=0
             LET g_imx[l_ac3].imx04=0
             LET g_imx[l_ac3].imx05=0
             LET g_imx[l_ac3].imx06=0
             LET g_imx[l_ac3].imx07=0
             LET g_imx[l_ac3].imx08=0
             LET g_imx[l_ac3].imx09=0
             LET g_imx[l_ac3].imx10=0
             IF cl_null(g_imx[l_ac3].count) THEN
                LET g_imx[l_ac3].count=0
             END IF
             LET g_imx[l_ac3].number=1
                 
           AFTER FIELD color          
              IF NOT cl_null(g_imx[l_ac3].color) THEN
                 IF NOT i404_check_color() THEN
                    LET g_imx[l_ac3].color=g_imx_t.color
                    NEXT FIELD color
                 END IF
                 IF g_imx[l_ac3].color !=g_imx_t.color AND g_imx_t.color IS NOT NULL THEN
                    CALL i404_imx_update()
                 END IF
              END IF             
 

           AFTER FIELD imx01
              IF NOT cl_null(g_imx[l_ac3].imx01) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx01 !=g_imx_t.imx01 AND g_imx_t.imx01 IS NOT NULL) THEN
                    IF NOT i404_check_imx(1,g_imx[l_ac3].imx01,g_imx_t.imx01) THEN
                       LET g_imx[l_ac3].imx01 = g_imx_t.imx01 
                       NEXT FIELD imx01
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx01,g_imx_t.imx01,p_cmd3)
                 END IF
              END IF
           AFTER FIELD imx02
              IF NOT cl_null(g_imx[l_ac3].imx02) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx02 !=g_imx_t.imx02 AND g_imx_t.imx02 IS NOT NULL) THEN
                    IF NOT i404_check_imx(2,g_imx[l_ac3].imx02,g_imx_t.imx02) THEN
                       LET g_imx[l_ac3].imx02 = g_imx_t.imx02
                       NEXT FIELD imx02
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx02,g_imx_t.imx02,p_cmd3)
                 END IF
              END IF
           AFTER FIELD imx03
              IF NOT cl_null(g_imx[l_ac3].imx03) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx03 !=g_imx_t.imx03 AND g_imx_t.imx03 IS NOT NULL) THEN
                    IF NOT i404_check_imx(3,g_imx[l_ac3].imx03,g_imx_t.imx03) THEN
                       LET g_imx[l_ac3].imx03 = g_imx_t.imx03  
                       NEXT FIELD imx03
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx03,g_imx_t.imx03,p_cmd3)
                 END IF
              END IF 
           AFTER FIELD imx04
              IF NOT cl_null(g_imx[l_ac3].imx04) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx04 !=g_imx_t.imx04 AND g_imx_t.imx04 IS NOT NULL) THEN
                     IF NOT i404_check_imx(4,g_imx[l_ac3].imx04,g_imx_t.imx04) THEN
                        LET g_imx[l_ac3].imx04 = g_imx_t.imx04 
                        NEXT FIELD imx04
                     END IF
                     CALL i404_getimx_count(g_imx[l_ac3].imx04,g_imx_t.imx04,p_cmd3)
                 END IF
              END IF  
           AFTER FIELD imx05
              IF NOT cl_null(g_imx[l_ac3].imx05) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx05 !=g_imx_t.imx05 AND g_imx_t.imx05 IS NOT NULL) THEN
                    IF NOT i404_check_imx(5,g_imx[l_ac3].imx05,g_imx_t.imx05) THEN
                       LET g_imx[l_ac3].imx05 = g_imx_t.imx05
                       NEXT FIELD imx05
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx05,g_imx_t.imx05,p_cmd3)
                 END IF
              END IF   
           AFTER FIELD imx06
              IF NOT cl_null(g_imx[l_ac3].imx06) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx06 !=g_imx_t.imx06 AND g_imx_t.imx06 IS NOT NULL) THEN
                    IF NOT i404_check_imx(6,g_imx[l_ac3].imx06,g_imx_t.imx06) THEN
                       LET g_imx[l_ac3].imx06 = g_imx_t.imx06
                       NEXT FIELD imx06
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx06,g_imx_t.imx06,p_cmd3)
                 END IF
              END IF  
           AFTER FIELD imx07
              IF NOT cl_null(g_imx[l_ac3].imx07) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx07 !=g_imx_t.imx07 AND g_imx_t.imx07 IS NOT NULL) THEN
                    IF NOT i404_check_imx(7,g_imx[l_ac3].imx07,g_imx_t.imx07) THEN
                       LET g_imx[l_ac3].imx07 = g_imx_t.imx07
                       NEXT FIELD imx07
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx07,g_imx_t.imx07,p_cmd3)
                 END IF 
              END IF
           AFTER FIELD imx08
              IF NOT cl_null(g_imx[l_ac3].imx08) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx08 !=g_imx_t.imx08 AND g_imx_t.imx08 IS NOT NULL) THEN
                    IF NOT i404_check_imx(8,g_imx[l_ac3].imx08,g_imx_t.imx08) THEN
                       LET g_imx[l_ac3].imx08 = g_imx_t.imx08
                       NEXT FIELD imx08
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx08,g_imx_t.imx08,p_cmd3)
                 END IF
              END IF 
           AFTER FIELD imx09
              IF NOT cl_null(g_imx[l_ac3].imx09) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx09 !=g_imx_t.imx09 AND g_imx_t.imx09 IS NOT NULL) THEN
                    IF NOT i404_check_imx(9,g_imx[l_ac3].imx09,g_imx_t.imx09) THEN
                       LET g_imx[l_ac3].imx09 = g_imx_t.imx09 
                       NEXT FIELD imx09
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx09,g_imx_t.imx09,p_cmd3)
                 END IF
              END IF   
           AFTER FIELD imx10
              IF NOT cl_null(g_imx[l_ac3].imx10) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx10 !=g_imx_t.imx10 AND g_imx_t.imx10 IS NOT NULL) THEN
                    IF NOT i404_check_imx(10,g_imx[l_ac3].imx10,g_imx_t.imx10) THEN
                       LET g_imx[l_ac3].imx10 = g_imx_t.imx10 
                       NEXT FIELD imx10
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx10,g_imx_t.imx10,p_cmd3)
                 END IF
              END IF       
           AFTER FIELD imx11
              IF NOT cl_null(g_imx[l_ac3].imx11) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx11 !=g_imx_t.imx11 AND g_imx_t.imx11 IS NOT NULL) THEN
                    IF NOT i404_check_imx(11,g_imx[l_ac3].imx11,g_imx_t.imx11) THEN
                       LET g_imx[l_ac3].imx11 = g_imx_t.imx11
                       NEXT FIELD imx11
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx11,g_imx_t.imx11,p_cmd3)
                 END IF
              END IF
           AFTER FIELD imx12
              IF NOT cl_null(g_imx[l_ac3].imx12) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx12 !=g_imx_t.imx12 AND g_imx_t.imx12 IS NOT NULL) THEN
                    IF NOT i404_check_imx(12,g_imx[l_ac3].imx12,g_imx_t.imx12) THEN
                       LET g_imx[l_ac3].imx12 = g_imx_t.imx12
                       NEXT FIELD imx12
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx12,g_imx_t.imx12,p_cmd3)
                 END IF
              END IF
           AFTER FIELD imx13
              IF NOT cl_null(g_imx[l_ac3].imx13) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx13 !=g_imx_t.imx13 AND g_imx_t.imx13 IS NOT NULL) THEN
                    IF NOT i404_check_imx(13,g_imx[l_ac3].imx13,g_imx_t.imx13) THEN
                       LET g_imx[l_ac3].imx13 = g_imx_t.imx13 
                       NEXT FIELD imx13
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx13,g_imx_t.imx13,p_cmd3)
                 END IF
              END IF 
           AFTER FIELD imx14
              IF NOT cl_null(g_imx[l_ac3].imx14) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx14 !=g_imx_t.imx14 AND g_imx_t.imx14 IS NOT NULL) THEN
                    IF NOT i404_check_imx(14,g_imx[l_ac3].imx14,g_imx_t.imx14) THEN
                       LET g_imx[l_ac3].imx14 = g_imx_t.imx14 
                       NEXT FIELD imx14
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx14,g_imx_t.imx14,p_cmd3)
                 END IF
              END IF  
           AFTER FIELD imx15
              IF NOT cl_null(g_imx[l_ac3].imx15) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx15 !=g_imx_t.imx15 AND g_imx_t.imx15 IS NOT NULL) THEN
                    IF NOT i404_check_imx(15,g_imx[l_ac3].imx15,g_imx_t.imx15) THEN
                       LET g_imx[l_ac3].imx15 = g_imx_t.imx15
                       NEXT FIELD imx15
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx15,g_imx_t.imx15,p_cmd3)
                 END IF
              END IF   
           AFTER FIELD imx16
              IF NOT cl_null(g_imx[l_ac3].imx16) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx16 !=g_imx_t.imx16 AND g_imx_t.imx16 IS NOT NULL) THEN
                    IF NOT i404_check_imx(16,g_imx[l_ac3].imx16,g_imx_t.imx16) THEN
                       LET g_imx[l_ac3].imx16 = g_imx_t.imx16  
                       NEXT FIELD imx16
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx16,g_imx_t.imx16,p_cmd3)
                 END IF
              END IF  
           AFTER FIELD imx17
              IF NOT cl_null(g_imx[l_ac3].imx17) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx17 !=g_imx_t.imx17 AND g_imx_t.imx17 IS NOT NULL) THEN
                    IF NOT i404_check_imx(17,g_imx[l_ac3].imx17,g_imx_t.imx17) THEN
                       LET g_imx[l_ac3].imx17 = g_imx_t.imx17 
                       NEXT FIELD imx17
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx17,g_imx_t.imx17,p_cmd3)
                 END IF
              END IF 
           AFTER FIELD imx18
              IF NOT cl_null(g_imx[l_ac3].imx18) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx18 !=g_imx_t.imx18 AND g_imx_t.imx18 IS NOT NULL) THEN
                    IF NOT i404_check_imx(18,g_imx[l_ac3].imx18,g_imx_t.imx18) THEN
                       LET g_imx[l_ac3].imx18 = g_imx_t.imx18
                       NEXT FIELD imx18
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx18,g_imx_t.imx18,p_cmd3)
                 END IF
              END IF 
           AFTER FIELD imx19
              IF NOT cl_null(g_imx[l_ac3].imx19) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx19 !=g_imx_t.imx19 AND g_imx_t.imx19 IS NOT NULL) THEN
                    IF NOT i404_check_imx(19,g_imx[l_ac3].imx19,g_imx_t.imx19) THEN
                       LET g_imx[l_ac3].imx19 = g_imx_t.imx19
                       NEXT FIELD imx19
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx19,g_imx_t.imx19,p_cmd3)
                 END IF
              END IF   
           AFTER FIELD imx20
              IF NOT cl_null(g_imx[l_ac3].imx20) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx20 !=g_imx_t.imx20 AND g_imx_t.imx20 IS NOT NULL) THEN
                    IF NOT i404_check_imx(20,g_imx[l_ac3].imx20,g_imx_t.imx20) THEN
                       LET g_imx[l_ac3].imx20 = g_imx_t.imx20  
                       NEXT FIELD imx20
                    END IF
                    CALL i404_getimx_count(g_imx[l_ac3].imx20,g_imx_t.imx20,p_cmd3)
                 END IF
              END IF                                                                                                            

           BEFORE DELETE 
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             CALL i404_ins_odq('r')  
             LET g_rec_b3=g_rec_b3-1

           AFTER INSERT 
              CALL i404_ins_odq('a')
              LET g_rec_b3=g_rec_b3+1
           
           ON ROW CHANGE 
              CALL i404_ins_odq('u')

           AFTER ROW
              IF g_success = 'Y' THEN
                 COMMIT WORK
              ELSE
   	         ROLLBACK WORK 
              END IF
              #CLOSE i404_bcl1
              CLOSE i404_bcl
              CLOSE i404_bcl_odq

           AFTER INPUT 
              IF INT_FLAG THEN                         # 若按了DEL鍵
                 LET INT_FLAG = 0
                 EXIT DIALOG
              END IF

         
              
        END INPUT

###

   INPUT ARRAY g_odp_2 FROM s_odp_2.*
      ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
                INSERT ROW=FALSE,DELETE ROW=TRUE, 
                APPEND ROW=FALSE)

       BEFORE INPUT
          LET g_odq04='1'
          IF g_rec_b2 != 0 THEN
             CALL fgl_set_arr_curr(l_ac2)
          END IF
          LET g_b_flag = '2'      #FUN-D30034 add

        #TQC-C20224--add--begin--
          IF cl_null(g_odp[l_ac1].odp08) OR g_odp[l_ac1].odp08 = 0 THEN
             CALL cl_err('','mfg-216',1)
             EXIT DIALOG
          END IF
        #TQC-C20224--add--end--

       BEFORE ROW
          LET l_lock_sw = 'N'    #FUN-B90101--add
          LET l_n  = ARR_COUNT() #FUN-B90101--add 
          LET l_ac2 = ARR_CURR()
          CALL i404_ima_2('d')                        #FUN-C60022--MODIFY IMA--IMA_2
          LET g_doc.column1 = "ima01"                 #FUN-C60022--ADD--
          LET g_doc.value1  = g_odp_2[l_ac1].odp07_2  #FUN-C60022--ADD---
          CALL cl_get_fld_doc("ima04")                #FUN-C60022--ADD---

          BEGIN WORK
#FUN-B90101----add----begin------------------
          IF g_rec_b2 >= l_ac2 THEN
             LET g_odp_2t.* = g_odp_2[l_ac2].*
             OPEN i404_bcl USING  g_odp00,g_odp01,g_odp02,g_odp_2[l_ac2].odp07_2,'1'
              IF STATUS THEN
                 CALL cl_err("",1125, 0)
                 LET l_lock_sw = "Y"
                 CLOSE i404_bcl
                 EXIT DIALOG
              ELSE
                 FETCH i404_bcl INTO g_odp_2[l_ac2].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_odp_2t.odp03_2,SQLCA.sqlcode,0)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()
           CALL i404_ima_2('d')                        #FUN-C60022--ADD--
           LET g_doc.column1 = "ima01"                 #FUN-C60022---ADD--
           LET g_doc.value1  = g_odp_2[l_ac2].odp07_2  #FUN-C60022---ADD--
           CALL cl_get_fld_doc("ima04")                #FUN-C60022---ADD---
           END IF
#FUN-B90101------end-------------------------------
#         CALL cl_set_comp_entry("odp08_2",FALSE)   #FUN-B90101--mark
#         CALL cl_set_comp_entry("odp03_2,odp04_2,odp05_2,odp07_2",FALSE)  #FUN-B90101--add
          CALL i404_b_set_text(g_odp_2[l_ac2].odp07_2)           
          CALL i404_fill_imx(g_odp_2[l_ac2].odp07_2)  

#FUN-B90101--------------add---------------
           SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=g_odp_2[l_ac2].odp07_2
           IF l_ima151 = 'Y' THEN
              CALL cl_set_comp_entry("odp08_2",FALSE)
           ELSE
              CALL cl_set_comp_entry("odp08_2",TRUE)
           END IF
#FUN-B90101-----------end------------------
          SELECT SUM(odq07)
            INTO g_odp_2[l_ac2].odp08_2
            FROM odq_file
           WHERE odq00 = g_odp00 AND odq01 = g_odp01 AND odq02=g_odp02 AND odq03=g_odp_2[l_ac2].odp07_2
             AND odq04=g_odq04   AND odq08=g_odp[l_ac1].odp07
       
          IF SQLCA.sqlcode OR cl_null(g_odp_2[l_ac2].odp08_2) THEN LET g_odp_2[l_ac2].odp08_2 = 0 END IF

          DISPLAY ARRAY g_imx TO s_imx.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
             BEFORE DISPLAY
                EXIT DISPLAY
          END DISPLAY
       BEFORE DELETE
          IF NOT cl_delb(0,0) THEN
             CANCEL DELETE
          END IF
          DELETE FROM odp_file WHERE odp01=g_odp01
                       AND odp02=g_odp02
                       AND odp00=g_odp00
                       AND odp06='1'
                       AND odp07=g_odp_2[l_ac2].odp07_2
                       AND odp12=g_odp[l_ac1].odp07
          IF SQLCA.sqlcode THEN
             CALL cl_err('del odp',SQLCA.sqlcode,1)
             ROLLBACK WORK
             CANCEL DELETE
          END IF
          LET g_rec_b2=g_rec_b2-1             #TQC-C40197----ADD----
          DISPLAY g_rec_b2 TO FORMONLY.cn3   #TQC-C40197-----ADD-----
          DELETE FROM odq_file WHERE odq01=g_odp01
                                 AND odq02=g_odp02
                                 AND odq00=g_odp00
                                 AND odq03=g_odp_2[l_ac2].odp07_2
                                 AND odq04='1'
                                 AND odq08=g_odp[l_ac1].odp07
          IF SQLCA.sqlcode THEN
             CALL cl_err('del odq',SQLCA.sqlcode,1)
             ROLLBACK WORK
             CANCEL DELETE
          END IF
#FUN-B90101-------------add-------begin------------       
         ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_odp_2[l_ac2].* = g_odp_2t.*
              CLOSE i404_bcl
              ROLLBACK WORK
              EXIT DIALOG
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_odp_2[l_ac2].odp07_2,-263,0)
              LET g_odp_2[l_ac2].* = g_odp_2t.*
           ELSE
              IF l_ima151 <> 'Y' THEN
                 UPDATE odp_file SET odp08=g_odp_2[l_ac2].odp08_2
                    WHERE odp01=g_odp01
                      AND odp02=g_odp02
                      AND odp00=g_odp00           
                      AND odp06='1'            
                      AND odp07=g_odp_2[l_ac2].odp07_2
                      AND odp12=g_odp[l_ac1].odp07     #主款號
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","odp_file",g_odp00,g_odp_2[l_ac2].odp07_2,SQLCA.sqlcode,"","",1)
                     LET g_odp_2[l_ac2].* = g_odp_2t.*
                     CLOSE i404_bcl
                     ROLLBACK WORK
                     EXIT DIALOG
                  ELSE
                     UPDATE odq_file SET odq07=g_odp_2[l_ac2].odp08_2
                       WHERE odq01 = g_odp01 AND odq02=g_odp02 AND odq00=g_odp00
                         AND odq04='1' AND odq05=1 AND odq06=g_odp_2[l_ac2].odp07_2
                         AND odq08=g_odp[l_ac1].odp07
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL cl_err3("upd","odq_file",g_odp00,g_odp_2[l_ac2].odp07_2,SQLCA.sqlcode,"","",1)
                        LET g_odp_2[l_ac2].* = g_odp_2t.*
                        CLOSE i404_bcl
                        ROLLBACK WORK
                        EXIT DIALOG
                     END IF
                  END IF
              END IF 
           END IF   

     #TQC-C20327--add--begin--
        AFTER FIELD odp08_2
#TQC-C40197-----ADD---STR----
           IF NOT cl_null(g_odp_2[l_ac2].odp08_2) THEN
              IF g_odp_2[l_ac2].odp08_2<0 THEN
                 CALL cl_err("","axm1154",0)
                 NEXT FIELD odp08_2
              END IF
           END IF  
#TQC-C40197-----ADD---END------
           IF g_odp_2[l_ac2].odp08_2 <> g_odp_2t.odp08_2 OR g_odp_2t.odp08_2 IS NULL THEN
              LET g_odp_2[l_ac2].odp09a_2=g_odp_2[l_ac2].odp09_2*g_odp_2[l_ac2].odp08_2
              LET g_odp_2[l_ac2].odp10a_2=g_odp_2[l_ac2].odp10_2*g_odp_2[l_ac2].odp08_2

              CALL cl_digcut(g_odp_2[l_ac2].odp09a_2,t_azi04) RETURNING g_odp_2[l_ac2].odp09a_2
              CALL cl_digcut(g_odp_2[l_ac2].odp10a_2,t_azi04) RETURNING g_odp_2[l_ac2].odp10a_2   
           END IF
     #TQC-C20327--add--end--

        AFTER ROW
           LET l_ac2 = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_odp_2[l_ac2].* = g_odp_2t.*
              CLOSE i404_bcl
              ROLLBACK WORK
              EXIT DIALOG
           END IF
           CLOSE i404_bcl
           COMMIT WORK 
#FUN-B90101------------end-------------------------

    END INPUT

    #FUN-D30034--add---begin---
    BEFORE DIALOG
       CASE g_b_flag
          WHEN '1' NEXT FIELD odp03
          WHEN '2' NEXT FIELD odp03_2
          WHEN '3' NEXT FIELD color
       END CASE
    #FUN-D30034--add---end---

#FUN-B20031 add---------------end-------------------------------------------------

       ON ACTION accept
          LET g_action_choice="detail"
          ACCEPT DIALOG

	ON ACTION cancel
#              IF g_odp[l_ac1].odp08<l_odn09 THEN
#                 CALL cl_err(l_odn09,1106,0)
#                 ACCEPT DIALOG
#              END IF
#
#                
#          LET INT_FLAG=FALSE
#     #     IF p_cmd1="a" AND p_cmd3="a" THEN
#     #        DELETE FROM odp_file WHERE odp01=g_odp01
#     #   			    AND odp02=g_odp02
#     #   			    AND odp03=g_odp[l_ac1].odp03           
#     #   			    AND odp04=g_odp[l_ac1].odp04           
#     #   			    AND odp05=g_odp[l_ac1].odp05           
#     #   			    AND odp07=g_odp[l_ac1].odp07           
#     #        CALL g_odp.deleteElement(l_ac1)
#     #        LET g_rec_b1=g_rec_b1-1
#     #     END IF
         #LET g_action_choice="exit"   #FUN-D30034 mark
         #FUN-D30034--add--begin---
          IF p_cmd1 = 'a' AND g_b_flag = '1' THEN
             CALL g_odp.deleteElement(l_ac1)
             IF g_rec_b1 != 0 THEN
                LET g_action_choice="detail"
             END IF
          END IF
          IF p_cmd3 = 'a' AND g_b_flag = '3' THEN
             CALL g_imx.deleteElement(l_ac3)
             IF g_rec_b3 != 0 THEN
                LET g_action_choice="detail"
             END IF
          END IF
         #FUN-D30034--add--end---
          EXIT DIALOG

#FUN-C60021----ADD---STR---
      ON ACTION controlb    #設置快捷鍵，用於“款號單身”與“多屬性單身”之間的切換
         SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 =  g_odp[l_ac1].odp07
         IF l_ima151 = 'Y' THEN
            IF li_a THEN
#               LET li_a = FALSE    #FUN-C60100--MARK------
               NEXT FIELD odp03
            ELSE
#               LET li_a = TRUE     #FUN-C60100---MARK---
               NEXT FIELD color
            END IF
         END IF
#FUN-C60021----ADD---END----          
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

      #FUN-D30034--mark--str--  #走CANCEL段
      # ON ACTION EXIT
      #    LET INT_FLAG=TRUE
      #    EXIT DIALOG
      #FUN-D30034--mark--end--

         ON ACTION close                #視窗右上角的"x"
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG

   END DIALOG 

   CALL cl_set_act_visible("accept,cancel",TRUE)   
   CLOSE i404_bcl
   COMMIT WORK
   CALL i404_delall()    #TQC-C20134 add

END FUNCTION

#TQC-C20134--add--begin--
FUNCTION i404_delall()
   DEFINE l_n   LIKE type_file.num5

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM odp_file WHERE odp01=g_odp01
                                            AND odp02=g_odp02
                                            AND odp00=g_odp00 

   IF l_n = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM odp_file WHERE odp01=g_odp01 AND odp02=g_odp02 AND odp00=g_odp00 
   END IF
END FUNCTION
#TQC-C20134-add--end--

FUNCTION i404_r()
DEFINE l_odp11 LIKE odp_file.odp11

    IF g_check = 'Y' THEN
       CALL cl_err("",1209,0)
       RETURN
    END IF 
    SELECT odp11 INTO l_odp11 FROM odp_file WHERE odp01=g_odp01 AND odp02=g_odp02 AND odp00=g_odp00
    IF l_odp11 = 'Y' THEN
       CALL cl_err('','alm-551',0)
       RETURN
    END IF 
    IF cl_delh(0,0) THEN 
       DELETE FROM odp_file 
        WHERE odp01=g_odp01
          AND odp02=g_odp02
          AND odp00=g_odp00
     
       DELETE FROM odq_file 
        WHERE odq01=g_odp01
          AND odq02=g_odp02
          AND odq00=g_odp00

       CALL g_odp.clear()
       CALL g_odp_2.clear()
       CALL g_imx.clear()
       INITIALIZE g_ima_2.* TO NULL
       LET g_odp00=NULL 
       LET g_odp01=NULL 
       LET g_odp02=NULL
       LET g_odp13=NULL

       COMMIT WORK

    END IF
 
    DISPLAY g_odp00,g_odp01,g_odp02,g_odp13 TO odp00,odp01,odp02,odp13
    CALL i404_odl02('d')
    CALL i404_occ02('d')
    DISPLAY g_ima_2.*
        TO ima01,ima02,ima021,ima31,ima1004,ima1005,ima1006,ima1007,ima1008,ima1009
          
    OPEN i404_count
    #FUN-B50064-add-start--
    IF STATUS THEN
       CLOSE i404_cus
       CLOSE i404_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50064-add-end-- 
    FETCH i404_count INTO g_row_count
    #FUN-B50064-add-start--
    IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
       CLOSE i404_cus
       CLOSE i404_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50064-add-end-- 
    DISPLAY g_row_count TO FORMONLY.cnt    #TQC-C40197--ADD----
    OPEN i404_cus
      IF g_curs_index=g_row_count+1 THEN
        LET g_jump=g_row_count     
        CALL i404_fetch('L')       
      ELSE
           LET g_jump=g_curs_index
           LET mi_no_ask=TRUE   
           CALL i404_fetch('/') 
      END IF
END FUNCTION

FUNCTION i404_rr()

   IF cl_null(g_odp00) OR g_odp01 IS NULL OR g_odp02 IS NULL THEN 
      CALL cl_err('',-400,0)
      RETURN FALSE
   END IF 

      
   IF NOT cl_delb(0,0) THEN
      RETURN FALSE
   END IF

   #刪除訂貨款式中的訂貨資料
   DELETE FROM odp_file WHERE odp01=g_odp01
                          AND odp02=g_odp02
                          AND odp00=g_odp00
                          AND odp07=g_odp[l_ac1].odp07
                          AND odp06='0'
                          AND odp12=' '
   IF SQLCA.sqlcode THEN
      CALL cl_err('del odp',SQLCA.sqlcode,1)
      RETURN FALSE
   END IF

   DELETE FROM odq_file WHERE odq01=g_odp01
                          AND odq02=g_odp02
                          AND odq00=g_odp00
                          AND odq03=g_odp[l_ac1].odp07
                          AND odq04='0'
                          AND odq08=' '
   IF SQLCA.sqlcode THEN
      CALL cl_err('del odp',SQLCA.sqlcode,1)
      RETURN FALSE
   END IF
   #刪除關聯款號資料
   DELETE FROM odp_file WHERE odp01=g_odp01
                          AND odp02=g_odp02
                          AND odp00=g_odp00
                          AND odp12=g_odp[l_ac1].odp07
                          AND odp06='1'
   IF SQLCA.sqlcode THEN
      CALL cl_err('del odp',SQLCA.sqlcode,1)
      RETURN FALSE
   END IF

   DELETE FROM odq_file WHERE odq01=g_odp01
                          AND odq02=g_odp02
                          AND odq00=g_odp00
                          AND odq04='1'
                          AND odq08=g_odp[l_ac1].odp07
   IF SQLCA.sqlcode THEN
      CALL cl_err('del odp',SQLCA.sqlcode,1)
      RETURN FALSE
   END IF
   
   RETURN TRUE
END FUNCTION
 
FUNCTION i404_403()
   DEFINE l_odo03 LIKE odo_file.odo03
   DEFINE l_odo04 LIKE odo_file.odo04
   DEFINE l_odp08 LIKE odp_file.odp08
   DEFINE l_odp09 LIKE odp_file.odp09


   SELECT odo03,odo04 INTO l_odo03,l_odo04 FROM odo_file
    WHERE odo01 = g_odp01
      AND odo02 = g_odp02

  SELECT sum(odp08),sum(odp10*odp08) INTO l_odp08,l_odp09 FROM odp_file
   WHERE odp01 = g_odp01
     AND odp02 = g_odp02
 
  IF l_odp08<l_odo03 AND l_odp09<l_odo04 THEN   
     CALL cl_err(" ",1111,0) 
  END IF
END FUNCTION
 
FUNCTION i404_check()
   DISPLAY "CHECK"
   IF cl_null(g_odp01) OR cl_null(g_odp02) OR cl_null(g_odp00) THEN
      CALL cl_err("",1206,0)
      RETURN
   END IF
   IF cl_null(g_odp[1].odp07) THEN
      CALL cl_err("",1207,0)
      RETURN
   END IF
   
   IF g_check = 'Y' THEN
      CALL cl_err("",1208,0)
      RETURN
   END IF  

   IF cl_prompt(0,0,"是否審核該資料") THEN
      UPDATE odp_file SET odp11 = 'Y'
       WHERE odp01 = g_odp01
         AND odp02 = g_odp02
         AND odp00 = g_odp00
   ELSE   
      RETURN
   END IF

END FUNCTION

#FUN-B20031 add----------------begin---------------------------

FUNCTION i404_b_set_text(p_odp07)
   DEFINE p_odp07     LIKE odp_file.odp07
   DEFINE l_ima151    LIKE ima_file.ima151
   DEFINE l_index     STRING
   DEFINE l_sql       STRING
   DEFINE l_color     LIKE type_file.chr50
   DEFINE l_size      LIKE type_file.chr50
   DEFINE l_i,l_j     LIKE type_file.num5
   DEFINE l_imx00     LIKE imx_file.imx00
   DEFINE lc_agd02    LIKE agd_file.agd02
   DEFINE lc_agd02_2  LIKE agd_file.agd02
   DEFINE lc_agd03    LIKE agd_file.agd03
   DEFINE lc_agd03_2  LIKE agd_file.agd03
   DEFINE l_imx01     LIKE imx_file.imx01
   DEFINE l_imx02     LIKE imx_file.imx02
   DEFINE l_agd04     LIKE agd_file.agd04
   DEFINE ls_value    STRING
   DEFINE ls_desc     STRING
   DEFINE l_repeat1   LIKE type_file.chr1,
          l_repeat2   LIKE type_file.chr1
   DEFINE l_colarray  DYNAMIC ARRAY OF RECORD 
          color       LIKE type_file.chr50
                      END RECORD

   SELECT ima151 INTO l_ima151 FROM ima_file
    WHERE ima01 = p_odp07
   IF l_ima151 = 'N' OR cl_null(l_ima151) THEN
      CALL cl_set_comp_visible("color,number,count",FALSE)
      FOR l_i = 1 TO 20
         LET l_index = l_i USING '&&'
         CALL cl_set_comp_visible("imx" || l_index,FALSE)
      END FOR
      RETURN
   ELSE
#    	CALL cl_set_comp_visible("color,number,count",TRUE)
    	CALL cl_set_comp_visible("color,count",TRUE)
   END IF

#抓取母料件多屬性資料
   LET l_sql = "SELECT DISTINCT(imx02),agd04 FROM imx_file,agd_file",
               " WHERE imx00 = '",p_odp07,"'",
               "   AND imx02=agd02",
               "   AND agd01 IN ",
               " (SELECT ima941 FROM ima_file WHERE ima01='",p_odp07,"')",
               " ORDER BY agd04"
   PREPARE s_f3_pre FROM l_sql
   DECLARE s_f2_cs CURSOR FOR s_f3_pre

   CALL g_imxtext.clear()
   FOREACH s_f2_cs INTO l_imx02,l_agd04
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET g_imxtext[1].detail[g_imxtext[1].detail.getLength()+1].size=l_imx02 CLIPPED
   END FOREACH

   LET l_sql = "SELECT DISTINCT(imx01),agd04 FROM imx_file,agd_file",
               " WHERE imx00 = '",p_odp07,"'",
               "   AND imx01=agd02",
               "   AND agd01 IN ",
               " (SELECT ima940 FROM ima_file WHERE ima01='",p_odp07,"')",
               " ORDER BY agd04"
   PREPARE s_colslk_pre FROM l_sql
   DECLARE s_colslk_cs CURSOR FOR s_colslk_pre

   CALL l_colarray.clear()
   FOREACH s_colslk_cs INTO l_imx01,l_agd04
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET l_colarray[l_colarray.getLength()+1].color=l_imx01 CLIPPED
   END FOREACH

   FOR l_i = 1 TO l_colarray.getLength()
      LET g_imxtext[l_i].* = g_imxtext[1].*
      LET g_imxtext[l_i].color = l_colarray[l_i].color
   END FOR

   FOR l_i = 1 TO g_imxtext.getLength()
      LET lc_agd02 = g_imxtext[l_i].color CLIPPED
      LET ls_value = ls_value,lc_agd02,","
      SELECT agd03 INTO lc_agd03 FROM agd_file,ima_file
       WHERE agd01 = ima940 AND agd02 = lc_agd02
         AND ima01 = p_odp07
      LET ls_desc = ls_desc,lc_agd02,":",lc_agd03 CLIPPED,"," 
   END FOR 
   CALL cl_set_combo_items("color",ls_value.subString(1,ls_value.getLength()-1),ls_desc.subString(1,ls_desc.getLength()-1))
   FOR l_i = 1 TO g_imxtext[1].detail.getLength()
      LET l_index = l_i USING '&&'
      LET lc_agd02_2 = g_imxtext[1].detail[l_i].size CLIPPED
      SELECT agd03 INTO lc_agd03_2 FROM agd_file,ima_file
       WHERE agd01 = ima941 AND agd02 = lc_agd02_2
         AND ima01 = p_odp07
      CALL cl_set_comp_visible("imx" || l_index,TRUE)
      CALL cl_set_comp_att_text("imx" || l_index,lc_agd03_2)
   END FOR
   FOR l_i = g_imxtext[1].detail.getLength()+1 TO 20
      LET l_index = l_i USING '&&' 
      CALL cl_set_comp_visible("imx" || l_index,FALSE)
   END FOR
END FUNCTION

FUNCTION i404_fill_imx(p_odp07)
   DEFINE l_sql        STRING
   DEFINE p_odp07      LIKE odp_file.odp07
   DEFINE l_ima151     LIKE ima_file.ima151   
   DEFINE l_i,l_j,l_n  LIKE type_file.num5
   DEFINE l_odq RECORD LIKE odq_file.*
   DEFINE l_maxodq05   LIKE odq_file.odq05
   DEFINE l_k          LIKE type_file.num5

   SELECT ima151 INTO l_ima151 FROM ima_file
    WHERE ima01 = p_odp07
   IF l_ima151 = 'N' OR cl_null(l_ima151) THEN
      RETURN
   END IF
   CALL g_imx.clear()

   LET l_odq.odq00 =g_odp00
   LET l_odq.odq01 =g_odp01
   LET l_odq.odq02 =g_odp02
   IF g_odq04='0' THEN
      LET l_odq.odq03 =g_odp[l_ac1].odp07
      LET l_odq.odq08 =' '
   END IF
   IF g_odq04='1' THEN
      LET l_odq.odq03 =g_odp_2[l_ac2].odp07_2
      LET l_odq.odq08 =g_odp[l_ac1].odp07
   END IF

   SELECT MAX(odq05) INTO l_maxodq05 FROM odq_file
     WHERE odq01=l_odq.odq01 AND odq02=l_odq.odq02
       AND odq03=l_odq.odq03 AND odq08=l_odq.odq08 AND odq04=g_odq04

   FOR l_n = 1 TO l_maxodq05
      FOR l_k = 1 TO g_imxtext.getLength()
         LET l_i=g_imx.getLength()+1
         LET g_imx[l_i].color = g_imxtext[l_k].color CLIPPED
         LET g_imx[l_i].number = l_n
         FOR l_j = 1 TO g_imxtext[1].detail.getLength()
            CASE l_j
             WHEN 1
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx01
             WHEN 2
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx02
             WHEN 3
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx03
             WHEN 4
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx04
             WHEN 5
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx05
             WHEN 6
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx06
             WHEN 7
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx07
             WHEN 8
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx08
             WHEN 9
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx09
             WHEN 10
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx10
             WHEN 11
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx11
             WHEN 12
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx12
             WHEN 13
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx13
             WHEN 14
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx14
             WHEN 15
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx15
             WHEN 16
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx16
             WHEN 17
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx17
             WHEN 18
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx18
             WHEN 19
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx19
             WHEN 20
                CALL i404_get_odq07(l_n,l_i,l_j,l_k,p_odp07) RETURNING g_imx[l_i].imx20
            END CASE

         END FOR
      END FOR
   END FOR
   FOR l_i =  g_imx.getLength() TO 1 STEP -1
      IF cl_null(g_imx[l_i].imx01) THEN LET g_imx[l_i].imx01=0 END IF
      IF cl_null(g_imx[l_i].imx02) THEN LET g_imx[l_i].imx02=0 END IF
      IF cl_null(g_imx[l_i].imx03) THEN LET g_imx[l_i].imx03=0 END IF
      IF cl_null(g_imx[l_i].imx04) THEN LET g_imx[l_i].imx04=0 END IF
      IF cl_null(g_imx[l_i].imx05) THEN LET g_imx[l_i].imx05=0 END IF
      IF cl_null(g_imx[l_i].imx06) THEN LET g_imx[l_i].imx06=0 END IF
      IF cl_null(g_imx[l_i].imx07) THEN LET g_imx[l_i].imx07=0 END IF
      IF cl_null(g_imx[l_i].imx08) THEN LET g_imx[l_i].imx08=0 END IF
      IF cl_null(g_imx[l_i].imx09) THEN LET g_imx[l_i].imx09=0 END IF
      IF cl_null(g_imx[l_i].imx10) THEN LET g_imx[l_i].imx10=0 END IF
      IF cl_null(g_imx[l_i].imx11) THEN LET g_imx[l_i].imx11=0 END IF
      IF cl_null(g_imx[l_i].imx12) THEN LET g_imx[l_i].imx12=0 END IF
      IF cl_null(g_imx[l_i].imx13) THEN LET g_imx[l_i].imx13=0 END IF
      IF cl_null(g_imx[l_i].imx14) THEN LET g_imx[l_i].imx14=0 END IF
      IF cl_null(g_imx[l_i].imx15) THEN LET g_imx[l_i].imx15=0 END IF
      IF cl_null(g_imx[l_i].imx16) THEN LET g_imx[l_i].imx16=0 END IF
      IF cl_null(g_imx[l_i].imx17) THEN LET g_imx[l_i].imx17=0 END IF
      IF cl_null(g_imx[l_i].imx18) THEN LET g_imx[l_i].imx18=0 END IF
      IF cl_null(g_imx[l_i].imx19) THEN LET g_imx[l_i].imx19=0 END IF
      IF cl_null(g_imx[l_i].imx20) THEN LET g_imx[l_i].imx20=0 END IF
      IF cl_null(g_imx[l_i].imx20) THEN LET g_imx[l_i].imx20=0 END IF
      IF cl_null(g_imx[l_i].count) THEN LET g_imx[l_i].count=0 END IF

      LET g_imx[l_i].count=g_imx[l_i].imx01 + g_imx[l_i].imx06 + g_imx[l_i].imx11 + g_imx[l_i].imx16 +
                           g_imx[l_i].imx02 + g_imx[l_i].imx07 + g_imx[l_i].imx12 + g_imx[l_i].imx17 +
                           g_imx[l_i].imx03 + g_imx[l_i].imx08 + g_imx[l_i].imx13 + g_imx[l_i].imx18 +
                           g_imx[l_i].imx04 + g_imx[l_i].imx09 + g_imx[l_i].imx14 + g_imx[l_i].imx19 +
                           g_imx[l_i].imx05 + g_imx[l_i].imx10 + g_imx[l_i].imx15 + g_imx[l_i].imx20 

      IF (g_imx[l_i].imx01 IS NULL OR g_imx[l_i].imx01 = 0) AND 
         (g_imx[l_i].imx02 IS NULL OR g_imx[l_i].imx02 = 0) AND 
         (g_imx[l_i].imx03 IS NULL OR g_imx[l_i].imx03 = 0) AND 
         (g_imx[l_i].imx04 IS NULL OR g_imx[l_i].imx04 = 0) AND 
         (g_imx[l_i].imx05 IS NULL OR g_imx[l_i].imx05 = 0) AND 
         (g_imx[l_i].imx06 IS NULL OR g_imx[l_i].imx06 = 0) AND 
         (g_imx[l_i].imx07 IS NULL OR g_imx[l_i].imx07 = 0) AND 
         (g_imx[l_i].imx08 IS NULL OR g_imx[l_i].imx08 = 0) AND 
         (g_imx[l_i].imx09 IS NULL OR g_imx[l_i].imx09 = 0) AND 
         (g_imx[l_i].imx10 IS NULL OR g_imx[l_i].imx10 = 0) AND 
         (g_imx[l_i].imx11 IS NULL OR g_imx[l_i].imx11 = 0) AND 
         (g_imx[l_i].imx12 IS NULL OR g_imx[l_i].imx12 = 0) AND 
         (g_imx[l_i].imx13 IS NULL OR g_imx[l_i].imx13 = 0) AND 
         (g_imx[l_i].imx14 IS NULL OR g_imx[l_i].imx14 = 0) AND 
         (g_imx[l_i].imx15 IS NULL OR g_imx[l_i].imx15 = 0) AND 
         (g_imx[l_i].imx16 IS NULL OR g_imx[l_i].imx16 = 0) AND 
         (g_imx[l_i].imx17 IS NULL OR g_imx[l_i].imx17 = 0) AND 
         (g_imx[l_i].imx18 IS NULL OR g_imx[l_i].imx18 = 0) AND 
         (g_imx[l_i].imx19 IS NULL OR g_imx[l_i].imx19 = 0) AND 
         (g_imx[l_i].imx20 IS NULL OR g_imx[l_i].imx20 = 0) 
         THEN
          CALL g_imx.deleteElement(l_i)
      END IF   
   END FOR
#   LET g_rec_b3 = g_imxtext.getLength()
   LET g_rec_b3 = g_imx.getLength()

END FUNCTION

FUNCTION i404_get_odq07(p_n,p_i,p_j,p_k,p_odp07)

    DEFINE p_i,p_j   LIKE type_file.num5
    DEFINE l_i       LIKE type_file.num5
    DEFINE p_n,p_k   LIKE type_file.num5
    DEFINE p_odp07   LIKE odp_file.odp07
    DEFINE l_ps      LIKE sma_file.sma46
    DEFINE l_qty     LIKE rvb_file.rvb07
    DEFINE l_odp07   LIKE odp_file.odp07
    DEFINE l_odq05   LIKE odq_file.odq05
    DEFINE l_odq08   LIKE odq_file.odq08

    SELECT sma46 INTO l_ps FROM sma_file
    IF cl_null(l_ps) THEN
       LET l_ps=' '
    END IF
    LET l_odp07 = p_odp07,l_ps,g_imxtext[p_k].color,l_ps,g_imxtext[p_k].detail[p_j].size

    IF g_odq04='0' THEN
       LET l_odq08=' '
    END IF
    IF g_odq04='1' THEN
       LET l_odq08=g_odp[l_ac1].odp07
    END IF
    SELECT odq07 INTO l_qty FROM odq_file
     WHERE odq00 = g_odp00 AND odq01 = g_odp01 AND odq02=g_odp02 AND odq08=l_odq08 AND odq05=p_n
       AND odq03=p_odp07 AND odq06 = l_odp07 AND odq04=g_odq04

    IF cl_null(l_qty) THEN
       LET l_qty = 0
    END IF

#    IF cl_null(l_odq05) THEN
#       LET l_odq05 = 0
#    END IF
#    IF g_imx[p_i].number=0 OR cl_null(g_imx[p_i].number) THEN
#       LET g_imx[p_i].number=l_odq05
#    END IF
    RETURN l_qty

END FUNCTION

FUNCTION i404_check_imx(p_index,p_qty,p_qty_t)
   DEFINE p_index     LIKE type_file.num5,
          p_qty       LIKE rvb_file.rvb07,
          p_qty_t     LIKE rvb_file.rvb07

#TQC-C30198---add------------------
    IF p_qty < 0 THEN
       CALL cl_err('','art-040',0)
       RETURN FALSE
    END IF
#TQC-C30198---end------------------   

   RETURN TRUE 
END FUNCTION 

FUNCTION i404_get_ima(p_ac3,p_index)
   DEFINE p_ac        LIKE type_file.num5
   DEFINE p_ac3       LIKE type_file.num5 
   DEFINE p_index     LIKE type_file.num5
   DEFINE l_ima01     LIKE ima_file.ima01
   DEFINE l_ps        LIKE sma_file.sma46
   
   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN LET l_ps = ' ' END IF

   IF g_odq04='0' THEN
      LET l_ima01 = g_odp[l_ac1].odp07,l_ps,
                    g_imx[l_ac3].color,l_ps,
                    g_imxtext[p_ac3].detail[p_index].size
   END IF
   IF g_odq04='1' THEN
      LET l_ima01 = g_odp_2[l_ac2].odp07_2,l_ps,
                    g_imx[l_ac3].color,l_ps,
                    g_imxtext[p_ac3].detail[p_index].size
   END IF

   RETURN l_ima01
END FUNCTION

FUNCTION i404_ins_odq(p_ac)
   DEFINE l_i        LIKE type_file.num5 
   DEFINE l_n        LIKE type_file.num5
   DEFINE l_ima151   LIKE ima_file.ima151
   DEFINE l_ogb      RECORD LIKE ogb_file.*
   DEFINE p_ac       LIKE type_file.chr1
   
   IF cl_null(l_ac1) OR l_ac1 = 0 THEN
      RETURN
   END IF 
   IF g_odq04='0' THEN
      SELECT COUNT(*) INTO l_n FROM odp_file
       WHERE odp00 = g_odp00 AND odp01 = g_odp01 AND odp02 = g_odp02 AND odp07=g_odp[l_ac1].odp07
      IF l_n = 0 THEN
         RETURN
      END IF
   END IF

    LET g_success = 'Y'  
#   FOR l_i = 1 TO g_imxtext.getLength()
#   FOR l_i = 1 TO g_imx.getLength()
      LET l_i=l_ac3
      IF g_imx[l_i].imx01 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,1,g_imx[l_i].imx01,p_ac)
      END IF 
      IF g_imx[l_i].imx02 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,2,g_imx[l_i].imx02,p_ac)
      END IF
      IF g_imx[l_i].imx03 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,3,g_imx[l_i].imx03,p_ac)
      END IF 
      IF g_imx[l_i].imx04 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,4,g_imx[l_i].imx04,p_ac)
      END IF
      IF g_imx[l_i].imx05 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,5,g_imx[l_i].imx05,p_ac)
      END IF 
      IF g_imx[l_i].imx06 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,6,g_imx[l_i].imx06,p_ac)
      END IF
      IF g_imx[l_i].imx07 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,7,g_imx[l_i].imx07,p_ac)
      END IF 
      IF g_imx[l_i].imx08 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,8,g_imx[l_i].imx08,p_ac)
      END IF 
      IF g_imx[l_i].imx09 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,9,g_imx[l_i].imx09,p_ac)
      END IF 
      IF g_imx[l_i].imx10 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,10,g_imx[l_i].imx10,p_ac)
      END IF
      IF g_imx[l_i].imx11 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,11,g_imx[l_i].imx11,p_ac)
      END IF 
      IF g_imx[l_i].imx12 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,12,g_imx[l_i].imx12,p_ac)
      END IF
      IF g_imx[l_i].imx13 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,13,g_imx[l_i].imx13,p_ac)
      END IF 
      IF g_imx[l_i].imx14 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,14,g_imx[l_i].imx14,p_ac)
      END IF
      IF g_imx[l_i].imx15 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,15,g_imx[l_i].imx15,p_ac)
      END IF
      IF g_imx[l_i].imx16 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,16,g_imx[l_i].imx16,p_ac)
      END IF 
      IF g_imx[l_i].imx17 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,17,g_imx[l_i].imx17,p_ac)
      END IF
      IF g_imx[l_i].imx18 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,18,g_imx[l_i].imx18,p_ac)
      END IF 
      IF g_imx[l_i].imx19 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,19,g_imx[l_i].imx19,p_ac)
      END IF
      IF g_imx[l_i].imx20 >= 0 THEN
         CALL i404_imx_ins_odq(l_i,20,g_imx[l_i].imx20,p_ac)
      END IF
#   END FOR 
   CALL i404_update_odp() 
#   CALL i404_b1_fill( '1=1')
END FUNCTION

FUNCTION i404_imx_ins_odq(p_ac3,p_index,p_qty,p_ac)
   DEFINE p_ac3     LIKE type_file.num5
   DEFINE p_index   LIKE type_file.num5 
   DEFINE p_qty     LIKE rvb_file.rvb07
   DEFINE l_ima01   LIKE ima_file.ima01
   DEFINE l_n       LIKE type_file.num5
   DEFINE p_ac      LIKE type_file.chr1
   DEFINE l_odq RECORD  LIKE odq_file.*

   
   CALL i404_get_ima(p_ac3,p_index) RETURNING l_ima01

   LET l_odq.odq00 =g_odp00
   LET l_odq.odq01 =g_odp01
   LET l_odq.odq02 =g_odp02
   IF g_odq04='0' THEN
      LET l_odq.odq03 =g_odp[l_ac1].odp07
      LET l_odq.odq08 =' '
   END IF
   IF g_odq04='1' THEN
      LET l_odq.odq03 =g_odp_2[l_ac2].odp07_2
      LET l_odq.odq08 =g_odp[l_ac1].odp07
   END IF
   LET l_odq.odq04 =g_odq04
   LET l_odq.odq05 =g_imx[p_ac3].number
   LET l_odq.odq06 =l_ima01
   LET l_odq.odq07 =p_qty
   IF cl_null(l_odq.odq05) THEN LET l_odq.odq05=1 END IF

   SELECT COUNT(*) INTO l_n FROM odq_file
    WHERE odq00 = g_odp00 AND odq01 = g_odp01 AND odq02=g_odp02 AND odq04=l_odq.odq04
      AND odq05=l_odq.odq05 AND odq06=l_odq.odq06  AND odq08=l_odq.odq08

   IF l_n > 0 THEN
      IF p_qty > 0 AND p_ac='u' THEN
         UPDATE odq_file SET odq_file.* = l_odq.*
          WHERE odq01 = g_odp01 AND odq02=g_odp02 AND odq00=g_odp00
            AND odq04=l_odq.odq04 AND odq05=l_odq.odq05 AND odq06=l_odq.odq06 
            AND odq08=l_odq.odq08

         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
         END IF
      END IF
      IF p_ac='r' OR (p_qty=0 AND p_ac='u') THEN  
       	 DELETE FROM odq_file 
       	  WHERE odq01 = g_odp01 AND odq02=g_odp02 AND odq00=g_odp00
            AND odq04=l_odq.odq04 AND odq05=l_odq.odq05 AND odq06=l_odq.odq06
            AND odq08=l_odq.odq08
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
         END IF
      END IF 
   ELSE
      IF p_qty > 0 AND (p_ac='a' OR p_ac='u') THEN    

         INSERT INTO odq_file VALUES (l_odq.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","odq_file",l_odq.odq01,l_odq.odq06,SQLCA.sqlcode,"","",1)  
            LET g_success = 'N'
         END IF
      END IF 
   END IF 
END FUNCTION

FUNCTION i404_imx_update()
   DEFINE l_i       LIKE type_file.num5

#   FOR l_i = 1 TO g_imxtext.getLength()
#   FOR l_i = 1 TO g_imx.getLength()
      LET l_i=l_ac3
      IF g_imx[l_i].imx01 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,1,g_imx[l_i].imx01)
      END IF
      IF g_imx[l_i].imx02 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,2,g_imx[l_i].imx02)
      END IF
      IF g_imx[l_i].imx03 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,3,g_imx[l_i].imx03)
      END IF
      IF g_imx[l_i].imx04 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,4,g_imx[l_i].imx04)
      END IF
      IF g_imx[l_i].imx05 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,5,g_imx[l_i].imx05)
      END IF
      IF g_imx[l_i].imx06 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,6,g_imx[l_i].imx06)
      END IF
      IF g_imx[l_i].imx07 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,7,g_imx[l_i].imx07)
      END IF
      IF g_imx[l_i].imx08 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,8,g_imx[l_i].imx08)
      END IF
      IF g_imx[l_i].imx09 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,9,g_imx[l_i].imx09)
      END IF
      IF g_imx[l_i].imx10 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,10,g_imx[l_i].imx10)
      END IF
      IF g_imx[l_i].imx11 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,11,g_imx[l_i].imx11)
      END IF
      IF g_imx[l_i].imx12 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,12,g_imx[l_i].imx12)
      END IF
      IF g_imx[l_i].imx13 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,13,g_imx[l_i].imx13)
      END IF
      IF g_imx[l_i].imx14 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,14,g_imx[l_i].imx14)
      END IF
      IF g_imx[l_i].imx15 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,15,g_imx[l_i].imx15)
      END IF
      IF g_imx[l_i].imx16 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,16,g_imx[l_i].imx16)
      END IF
      IF g_imx[l_i].imx17 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,17,g_imx[l_i].imx17)
      END IF
      IF g_imx[l_i].imx18 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,18,g_imx[l_i].imx18)
      END IF
      IF g_imx[l_i].imx19 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,19,g_imx[l_i].imx19)
      END IF
      IF g_imx[l_i].imx20 >= 0 THEN
         CALL i404_imx_upd_odq(l_i,20,g_imx[l_i].imx20)
      END IF
#   END FOR

END FUNCTION

FUNCTION i404_imx_upd_odq(p_ac3,p_index,p_qty)
   DEFINE p_ac3     LIKE type_file.num5
   DEFINE p_index   LIKE type_file.num5
   DEFINE p_qty     LIKE rvb_file.rvb07
   DEFINE l_ima01   LIKE ima_file.ima01
   DEFINE l_odq RECORD  LIKE odq_file.*
   DEFINE l_ima01_t   LIKE ima_file.ima01
   DEFINE l_ps        LIKE sma_file.sma46
   DEFINE l_n       LIKE type_file.num5


      SELECT sma46 INTO l_ps FROM sma_file
      IF cl_null(l_ps) THEN LET l_ps = ' ' END IF

      IF g_odq04='0' THEN
         LET l_odq.odq03 =g_odp[l_ac1].odp07
         LET l_odq.odq08 =' '
         LET l_ima01 = g_odp[l_ac1].odp07,l_ps,
                       g_imx[l_ac3].color,l_ps,
                       g_imxtext[p_ac3].detail[p_index].size

         LET l_ima01_t = g_odp[l_ac1].odp07,l_ps,
                       g_imx_t.color,l_ps,
                       g_imxtext[p_ac3].detail[p_index].size
   
      END IF
      IF g_odq04='1' THEN
         LET l_odq.odq03 =g_odp_2[l_ac2].odp07_2
         LET l_odq.odq08 =g_odp[l_ac1].odp07
         LET l_ima01 = g_odp_2[l_ac2].odp07_2,l_ps,
                       g_imx[l_ac3].color,l_ps,
                       g_imxtext[p_ac3].detail[p_index].size

         LET l_ima01_t = g_odp_2[l_ac2].odp07_2,l_ps,
                       g_imx_t.color,l_ps,
                       g_imxtext[p_ac3].detail[p_index].size
   
      END IF
   
      SELECT COUNT(*) INTO l_n FROM odq_file
        WHERE odq01=g_odp01 AND odq02=g_odp02 AND odq00=g_odp00
          AND odq03=l_odq.odq03 AND odq04=g_odq04
          AND odq05=g_imx_t.number AND odq06=l_ima01_t AND odq08=l_odq.odq08
      IF l_n=0 OR cl_null(l_n) THEN
         RETURN
      END IF

      UPDATE odq_file SET odq06=l_ima01
        WHERE odq01=g_odp01 AND odq02=g_odp02 AND odq00=g_odp00
          AND odq03=l_odq.odq03 AND odq04=g_odq04
          AND odq05=g_imx_t.number AND odq06=l_ima01_t AND odq08=l_odq.odq08

      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","odq_file",l_odq.odq01,l_ima01_t,SQLCA.sqlcode,"","",1)
      END IF

END FUNCTION


FUNCTION i404_update_odp()
   DEFINE l_sum_odq07  LIKE odq_file.odq07
   DEFINE l_odq03      LIKE odq_file.odq03
   DEFINE l_odq08      LIKE odq_file.odq08
   DEFINE l_odp09      LIKE odp_file.odp09
   DEFINE l_odp10      LIKE odp_file.odp10
   DEFINE l_occ42      LIKE occ_file.occ42
   DEFINE l_occ44      LIKE occ_file.occ44
   DEFINE l_occ45      LIKE occ_file.occ45
   DEFINE l_ima31      LIKE ima_file.ima31
   DEFINE l_price      LIKE oeb_file.oeb13
   DEFINE l_price2     LIKE oeb_file.oeb13
   
   IF g_odq04='0' THEN
      LET l_odq03=g_odp[l_ac1].odp07
      LET l_odq08=' '
   END IF
   IF g_odq04='1' THEN
      LET l_odq03=g_odp_2[l_ac2].odp07_2
      LET l_odq08=g_odp[l_ac1].odp07
   END IF
 
   SELECT SUM(odq07)
     INTO l_sum_odq07
     FROM odq_file
    WHERE odq01 = g_odp01 AND odq02=g_odp02 AND odq00=g_odp00 
      AND odq03=l_odq03 AND odq04=g_odq04   AND odq08=l_odq08

   IF SQLCA.sqlcode OR cl_null(l_sum_odq07) THEN LET l_sum_odq07 = 0 END IF 

   IF g_odq04='0' THEN
      UPDATE odp_file SET odp08 = l_sum_odq07
       WHERE odp01 = g_odp01 AND odp02 = g_odp02 AND odp00 = g_odp00 
         AND odp06='0' AND odp07= g_odp[l_ac1].odp07 AND odp12=' '
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","odp_file",g_odp00,g_odp[l_ac1].odp07,STATUS,"","x_upd odp",1)
         LET g_success = 'N'
      END IF
      LET g_odp[l_ac1].odp08=l_sum_odq07
      LET g_odp[l_ac1].odp09a=g_odp[l_ac1].odp09*g_odp[l_ac1].odp08
      LET g_odp[l_ac1].odp10a=g_odp[l_ac1].odp10*g_odp[l_ac1].odp08
      
      CALL cl_digcut(g_odp[l_ac1].odp09a,t_azi04) RETURNING g_odp[l_ac1].odp09a
      CALL cl_digcut(g_odp[l_ac1].odp10a,t_azi04) RETURNING g_odp[l_ac1].odp10a
   END IF
   IF g_odq04='1' THEN
      UPDATE odp_file SET odp08 = l_sum_odq07
       WHERE odp01 = g_odp01 AND odp02 = g_odp02 AND odp00 = g_odp00 
         AND odp06='1' AND odp07=g_odp_2[l_ac2].odp07_2  AND odp12=g_odp[l_ac1].odp07
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","odp_file",g_odp00,g_odp_2[l_ac2].odp07_2,STATUS,"","x_upd odp",1)
         LET g_success = 'N'
      END IF

      LET g_odp_2[l_ac2].odp08_2=l_sum_odq07
      LET g_odp_2[l_ac2].odp09a_2=g_odp_2[l_ac2].odp09_2*g_odp_2[l_ac2].odp08_2
      LET g_odp_2[l_ac2].odp10a_2=g_odp_2[l_ac2].odp10_2*g_odp_2[l_ac2].odp08_2

      CALL cl_digcut(g_odp_2[l_ac2].odp09a_2,t_azi04) RETURNING g_odp_2[l_ac2].odp09a_2
      CALL cl_digcut(g_odp_2[l_ac2].odp10a_2,t_azi04) RETURNING g_odp_2[l_ac2].odp10a_2
      DISPLAY ARRAY g_odp_2 TO s_odp_2.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
          BEFORE DISPLAY
            EXIT DISPLAY
      END DISPLAY
   END IF
END FUNCTION

FUNCTION i404_get_color_size(l_str1,l_str)
   DEFINE l_str  STRING
   DEFINE l_str1 STRING
   DEFINE l_ps   LIKE type_file.chr1
   DEFINE l_tok  base.stringTokenizer
   DEFINE l_i    LIKE type_file.num5
   DEFINE field_array   DYNAMIC ARRAY OF LIKE type_file.chr100

   LET l_str  = l_str.subString(l_str1.getLength()+1,l_str.getLength())
   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN
       LET l_ps=' '
   END IF
   LET l_tok = base.StringTokenizer.createExt(l_str,l_ps,'',TRUE)
   IF l_tok.countTokens() > 0 THEN
      LET l_i=0
      WHILE l_tok.hasMoreTokens()
            LET l_i=l_i+1
            LET field_array[l_i] = l_tok.nextToken()
      END WHILE
   END IF
   RETURN field_array[2],field_array[3]
END FUNCTION

FUNCTION i404_getimx_count(l_i,l_j,p_cmd)
   DEFINE l_i    LIKE type_file.num5
   DEFINE l_j    LIKE type_file.num5
   DEFINE p_cmd  LIKE type_file.chr1
    
   IF p_cmd='a' THEN
      IF cl_null(g_imx[l_ac3].imx01) THEN LET g_imx[l_ac3].imx01=0 END IF
      IF cl_null(g_imx[l_ac3].imx02) THEN LET g_imx[l_ac3].imx02=0 END IF
      IF cl_null(g_imx[l_ac3].imx03) THEN LET g_imx[l_ac3].imx03=0 END IF
      IF cl_null(g_imx[l_ac3].imx04) THEN LET g_imx[l_ac3].imx04=0 END IF
      IF cl_null(g_imx[l_ac3].imx05) THEN LET g_imx[l_ac3].imx05=0 END IF
      IF cl_null(g_imx[l_ac3].imx06) THEN LET g_imx[l_ac3].imx06=0 END IF
      IF cl_null(g_imx[l_ac3].imx07) THEN LET g_imx[l_ac3].imx07=0 END IF
      IF cl_null(g_imx[l_ac3].imx08) THEN LET g_imx[l_ac3].imx08=0 END IF
      IF cl_null(g_imx[l_ac3].imx09) THEN LET g_imx[l_ac3].imx09=0 END IF
      IF cl_null(g_imx[l_ac3].imx10) THEN LET g_imx[l_ac3].imx10=0 END IF
      IF cl_null(g_imx[l_ac3].imx11) THEN LET g_imx[l_ac3].imx11=0 END IF
      IF cl_null(g_imx[l_ac3].imx12) THEN LET g_imx[l_ac3].imx12=0 END IF
      IF cl_null(g_imx[l_ac3].imx13) THEN LET g_imx[l_ac3].imx13=0 END IF
      IF cl_null(g_imx[l_ac3].imx14) THEN LET g_imx[l_ac3].imx14=0 END IF
      IF cl_null(g_imx[l_ac3].imx15) THEN LET g_imx[l_ac3].imx15=0 END IF
      IF cl_null(g_imx[l_ac3].imx16) THEN LET g_imx[l_ac3].imx16=0 END IF
      IF cl_null(g_imx[l_ac3].imx17) THEN LET g_imx[l_ac3].imx17=0 END IF
      IF cl_null(g_imx[l_ac3].imx18) THEN LET g_imx[l_ac3].imx18=0 END IF
      IF cl_null(g_imx[l_ac3].imx19) THEN LET g_imx[l_ac3].imx19=0 END IF
      IF cl_null(g_imx[l_ac3].imx20) THEN LET g_imx[l_ac3].imx20=0 END IF

      LET g_imx[l_ac3].count=g_imx[l_ac3].imx01 + g_imx[l_ac3].imx06 + g_imx[l_ac3].imx11 + g_imx[l_ac3].imx16 +
                           g_imx[l_ac3].imx02 + g_imx[l_ac3].imx07 + g_imx[l_ac3].imx12 + g_imx[l_ac3].imx17 +
                           g_imx[l_ac3].imx03 + g_imx[l_ac3].imx08 + g_imx[l_ac3].imx13 + g_imx[l_ac3].imx18 +
                           g_imx[l_ac3].imx04 + g_imx[l_ac3].imx09 + g_imx[l_ac3].imx14 + g_imx[l_ac3].imx19 +
                           g_imx[l_ac3].imx05 + g_imx[l_ac3].imx10 + g_imx[l_ac3].imx15 + g_imx[l_ac3].imx20
     
   ELSE
      IF cl_null(l_i) THEN LET l_i=0 END IF
      IF cl_null(l_j) THEN LET l_j=0 END IF
      LET g_imx[l_ac3].count=g_imx[l_ac3].count+l_i-l_j 
   END IF
END FUNCTION

FUNCTION i404_imx_lock(p_odq03,p_odq08)
  DEFINE l_ima01       LIKE ima_file.ima01
  DEFINE p_odq03       LIKE odq_file.odq03
  DEFINE p_odq08       LIKE odq_file.odq08
  DEFINE b_odq  RECORD LIKE odq_file.*


      IF g_imx[l_ac3].imx01 >= 0 THEN
#         CALL i404_get_ima(l_ac3,1) RETURNING l_ima01
#         FOREACH i404_bcl1 USING g_odp01,g_odp02,p_odq03,p_odq08,l_ima01
#            INTO l_odq05
#
#            OPEN i404_bcl_odq USING g_odp01,g_odp02,p_odq03,g_odq04,l_odq05,l_ima01,p_odq08
#                IF SQLCA.sqlcode THEN
#                   CALL cl_err('lock odq',SQLCA.sqlcode,1)
#                   LET l_lock_sw = "Y"
#                ELSE
#                   FETCH i404_bcl_odq INTO b_odq.*
#                   IF SQLCA.sqlcode THEN
#                      CALL cl_err('lock odq',SQLCA.sqlcode,1)
#                      LET l_lock_sw = "Y"
#                   END IF
#                END IF
#         END FOREACH
         CALL i404_imx_lockodq(1,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx02 >= 0 THEN
         CALL i404_imx_lockodq(2,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx03 >= 0 THEN
         CALL i404_imx_lockodq(3,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx04 >= 0 THEN
         CALL i404_imx_lockodq(4,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx05 >= 0 THEN
         CALL i404_imx_lockodq(5,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx06 >= 0 THEN
         CALL i404_imx_lockodq(6,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx07 >= 0 THEN
         CALL i404_imx_lockodq(7,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx08 >= 0 THEN
         CALL i404_imx_lockodq(8,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx09 >= 0 THEN
         CALL i404_imx_lockodq(9,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx10 >= 0 THEN
         CALL i404_imx_lockodq(10,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx11 >= 0 THEN
         CALL i404_imx_lockodq(11,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx12 >= 0 THEN
         CALL i404_imx_lockodq(12,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx13 >= 0 THEN
         CALL i404_imx_lockodq(13,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx14 >= 0 THEN
         CALL i404_imx_lockodq(14,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx15 >= 0 THEN
         CALL i404_imx_lockodq(15,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx16 >= 0 THEN
         CALL i404_imx_lockodq(16,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx17 >= 0 THEN
         CALL i404_imx_lockodq(17,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx18 >= 0 THEN
         CALL i404_imx_lockodq(18,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx19 >= 0 THEN
         CALL i404_imx_lockodq(19,p_odq03,p_odq08)
      END IF
      IF g_imx[l_ac3].imx20 >= 0 THEN
         CALL i404_imx_lockodq(20,p_odq03,p_odq08)
      END IF

END FUNCTION

FUNCTION i404_imx_lockodq(p_i,p_odq03,p_odq08)
   DEFINE p_odq03       LIKE odq_file.odq03
   DEFINE p_odq08       LIKE odq_file.odq08
   DEFINE l_ima01       LIKE ima_file.ima01
   DEFINE p_i           LIKE type_file.num5
   DEFINE l_odq05       LIKE odq_file.odq05
   DEFINE b_odq  RECORD LIKE odq_file.*

        CALL i404_get_ima(l_ac3,p_i) RETURNING l_ima01
        LET g_forupd_sql = "SELECT odq05 ",
                           " FROM odq_file",
                           " WHERE odq01='",g_odp01,"' AND odq02='",g_odp02,"' AND odq00='",g_odp00,"'",
                           "   AND odq03='",p_odq03,"' AND odq08='",p_odq08,"'",
                           "   AND odq06='",l_ima01,"' "

        PREPARE i404_odq FROM g_forupd_sql
        DECLARE i404_bcl1 CURSOR FOR i404_odq


         CALL i404_get_ima(l_ac3,p_i) RETURNING l_ima01
         FOREACH i404_bcl1 INTO l_odq05

            OPEN i404_bcl_odq USING g_odp00,g_odp01,g_odp02,p_odq03,g_odq04,l_odq05,l_ima01,p_odq08
                IF SQLCA.sqlcode THEN
                   CALL cl_err('lock odq',SQLCA.sqlcode,1)
#                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i404_bcl_odq INTO b_odq.*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('lock odq',SQLCA.sqlcode,1)
#                      LET l_lock_sw = "Y"
                   END IF
                END IF
         END FOREACH

END FUNCTION

FUNCTION i404_confirm()
   DEFINE l_n         LIKE type_file.num5 
   DEFINE l_success   LIKE type_file.chr1
   DEFINE l_odo03 LIKE odo_file.odo03
   DEFINE l_odo04 LIKE odo_file.odo04
   DEFINE l_odp07 LIKE odp_file.odp07
   DEFINE l_odp08 LIKE odp_file.odp08
   DEFINE l_odp09 LIKE odp_file.odp09
   DEFINE l_odn09 LIKE odn_file.odn09
   DEFINE l_odn08 LIKE odn_file.odn08    #TQC-C20117  add
   DEFINE l_odp10 LIKE odp_file.odp10    #TQC-C20117  add
   DEFINE l_msg   STRING
   DEFINE l_odn02 LIKE odn_file.odn02    #TQC-C20117  add
   DEFINE l_odn05 LIKE odn_file.odn05    #TQC-C20117  add
   DEFINE l_odp06 LIKE odp_file.odp06    #TQC-C20117  add
   DEFINE l_odp12 LIKE odp_file.odp12    #TQC-C20232 add
   DEFINE l_odp11 LIKE odp_file.odp11    #FUN-C60022 ADD

    IF g_check = 'Y' THEN
       CALL cl_err("",8888,0)
       RETURN
    END IF
   LET l_success='Y'
#CHI-C30107 ---------------- add ------------------- begin
  SELECT count(*) INTO l_n FROM odp_file
    WHERE odp01=g_odp01 AND odp02=g_odp02 AND odp00=g_odp00

   IF l_n=0 OR cl_null(l_n) THEN
      CALL cl_err('','aap-129',1)
      RETURN             
   END IF
   SELECT DISTINCT odp11 INTO l_odp11 FROM odp_file
    WHERE odp01=g_odp01 AND odp02=g_odp02 AND odp00=g_odp00
   IF l_odp11='Y' THEN
      CALL cl_err("","axm1163",0)
      RETURN
   END IF
   IF NOT cl_confirm('aap-222') THEN RETURN END IF
#CHI-C30107 ---------------- add ------------------- end
   SELECT count(*) INTO l_n FROM odp_file
    WHERE odp01=g_odp01 AND odp02=g_odp02 AND odp00=g_odp00

   IF l_n=0 OR cl_null(l_n) THEN
      CALL cl_err('','aap-129',1)
     #LET l_success='N'      #TQC-C20117  mark
      RETURN                 #TQC-C20117  add
   END IF
#FUN-C60022----ADD----STR---
   SELECT DISTINCT odp11 INTO l_odp11 FROM odp_file
    WHERE odp01=g_odp01 AND odp02=g_odp02 AND odp00=g_odp00
   IF l_odp11='Y' THEN
      CALL cl_err("","axm1163",0)
      RETURN
   END IF
#FUN-C60022----ADD----END----  
   SELECT odo03,odo04 INTO l_odo03,l_odo04 FROM odo_file
    WHERE odo01 = g_odp01
      AND odo02 = g_odp02

   SELECT sum(odp08),sum(odp10*odp08) INTO l_odp08,l_odp10 FROM odp_file
    WHERE odp01 = g_odp01
      AND odp02 = g_odp02
      AND odp00 = g_odp00

   IF l_odp08<l_odo03 AND l_odp10<l_odo04 THEN  
      CALL cl_err('',1111,1)
      RETURN                 #TQC-C20117  add
   END IF
#  IF cl_confirm('aap-222') THEN   #FUN-C60022---ADD--- #CHI-C30107 mark
      DECLARE i404_check_odp08 CURSOR FOR SELECT odp06,odp07,odp08,odp10,odp12 FROM odp_file   #TQC-C20117  add odp08,odp10
                                  WHERE odp01 = g_odp01 AND odp02 = g_odp02 AND odp00 = g_odp00
      CALL s_showmsg_init()
      FOREACH i404_check_odp08 INTO l_odp06,l_odp07,l_odp08,l_odp10,l_odp12    #TQC-C20117  add
         IF l_success='N' THEN
            EXIT FOREACH
         END IF
    #TQC-C20134--add--begin--
         IF cl_null(l_odp08) OR l_odp08 = 0 THEN
         #刪除訂貨款式中的訂貨資料
            IF l_odp06 = '0' THEN
               DELETE FROM odp_file WHERE odp01=g_odp01
                                   AND odp02=g_odp02
                                   AND odp00=g_odp00
                                   AND odp07=l_odp07
                                   AND odp06='0'
                                   AND odp12=' '
               DELETE FROM odq_file WHERE odq01=g_odp01
                                   AND odq02=g_odp02
                                   AND odq00=g_odp00
                                   AND odq03=l_odp07
                                   AND odq04='0'
                                   AND odq08=' '
            END IF
         #刪除關聯款號資料
            IF l_odp06 = '1' THEN
               DELETE FROM odp_file WHERE odp01=g_odp01
                                   AND odp02=g_odp02
                                   AND odp00=g_odp00
                                   AND odp07=l_odp07  #TQC-C20232 add
                                   AND odp12=l_odp12  #TQC-C20232 add
                                 # AND odp12=l_odp07  #TQC-C20232 mark
                                   AND odp06='1'
               DELETE FROM odq_file WHERE odq01=g_odp01
                                   AND odq02=g_odp02
                                   AND odq00=g_odp00
                                   AND odq04='1'
                                   AND odq03=l_odp07   #TQC-C20232 add
                                   AND odq08=l_odp12   #TQC-C20232 add
                                #  AND odq08=l_odp07   #TQC-C20232 mark 
            END IF
            CONTINUE FOREACH
         END IF
    #TQC-C20134--add--end--

         LET l_odn09=0         
         LET l_odn08=0     #TQC-C20117  add
         SELECT odn08,odn09 INTO l_odn08,l_odn09 FROM odn_file    #TQC-C20117  add odn08
          WHERE odn01=g_odp01 AND odn05=l_odp07       
         LET l_odp10 = l_odp08 * l_odp10                   #TQC-C40197----ADD---
         IF l_odp08<l_odn09 AND l_odp10 < l_odn08 THEN     #TQC-C40197---ADD---
            IF l_odp08<l_odn09 THEN
               LET l_msg = l_odp07||' '||l_odp08||'<'||l_odn09     #TQC-C20117  add
               CALL s_errmsg('',l_msg,'',1105,1)           #TQC-C20117  add
             # CALL cl_err(l_odp07||' '||l_odn09,1105,1)   #TQC-C20117  mark
             # LET l_success='N'                           #TQC-C20117  mark 
            END IF  
      #TQC-C20117--add--begin--
#         LET l_odp10 = l_odp08 * l_odp10 #TQC-C40197--MARK---
            IF l_odp10 < l_odn08 THEN
               LET l_msg = l_odp07||' '||l_odp10||'<'||l_odn08
               CALL s_errmsg('',l_msg,'',1103,1)
            END IF 
      #TQC-C20117--add--end--
         END IF  #TQC-C40197-----ADD----
      END FOREACH
      CALL s_showmsg()

   #TQC-C20117--add--begin--
      DECLARE i404_check_odp07 CURSOR FOR SELECT odn02,odn05 FROM odn_file WHERE odn01=g_odp01 AND odn06='Y'
      CALL s_showmsg_init()
      FOREACH i404_check_odp07 INTO l_odn02,l_odn05
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM odp_file
          WHERE odp01 = g_odp01 AND odp03 = l_odn02 AND odp07 = l_odn05 AND odp00=g_odp00  #TQC-C20418 add odp00=g_odp00
         IF l_n = 0 THEN
            CALL s_errmsg('',l_odn05||' '||l_odn02,'',1104,1)
            LET l_success='N'
         END IF
      END FOREACH
      CALL s_showmsg()
   #TQC-C20117--add--end--
      IF l_success='Y' THEN
         UPDATE odp_file SET odp11='Y'
          WHERE odp01=g_odp01 AND odp02=g_odp02 AND odp00=g_odp00
    
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","odp_file",g_odp00,g_odp02,STATUS,"","x_upd odp",1)
            LET l_success='N'
         END IF
      END IF
   
      IF l_success='Y' THEN
         DISPLAY 'Y' TO odp11
#        CALL cl_err('','abm-983',0)  #FUN-C60022---MARK---
      END IF
#  END IF                             #FUN-C60022---ADD---- #CHI-C30107 mark
END FUNCTION

FUNCTION i404_unconfirm()
  DEFINE l_success   LIKE type_file.chr1
  DEFINE l_odp14     LIKE odp_file.odp14
  DEFINE l_n         LIKE type_file.num5
  DEFINE l_odp11     LIKE odp_file.odp11   #FUN-C60022--ADD---

   LET l_success='Y'
   SELECT count(*) INTO l_n FROM odp_file
    WHERE odp01=g_odp01 AND odp02=g_odp02 AND odp00=g_odp00

   IF l_n=0 OR cl_null(l_n) THEN
      CALL cl_err('','aap-129',1)
      LET l_success='N'
      RETURN                              #FUN-C60022----ADD---
   END IF
#FUN-C60022----ADD----STR---
   SELECT DISTINCT odp11 INTO l_odp11 FROM odp_file
    WHERE odp01=g_odp01 AND odp02=g_odp02 AND odp00=g_odp00
   IF l_odp11='N' THEN
      CALL cl_err('',9025,0)
      LET l_success='N'
      RETURN     
   END IF
#FUN-C60022----ADD----END----
   SELECT DISTINCT odp14 INTO l_odp14 FROM odp_file 
    WHERE odp01=g_odp01 AND odp02=g_odp02 AND odp00=g_odp00
   IF NOT cl_null(l_odp14) THEN
      CALL cl_err('','axm1105',0)
      LET l_success='N'
      RETURN    
   END IF  
   IF cl_confirm('axm-109') THEN         #FUN-C60022---ADD----
      IF l_success='Y' THEN
         UPDATE odp_file SET odp11='N'
          WHERE odp01=g_odp01 AND odp02=g_odp02 AND odp00=g_odp00 
   
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","odp_file",g_odp00,g_odp02,STATUS,"","x_upd odp",1)
            LET l_success='N'
         END IF
      END IF

      IF l_success='Y' THEN
         DISPLAY 'N' TO odp11
#        CALL cl_err('','aic-059',0)    #FUN-C60022--MARK---
      END IF
   END IF                               #FUN-C60022-----ADD---

END FUNCTION

FUNCTION i404_check_color()
  DEFINE i          LIKE type_file.num5
  DEFINE l_flag     LIKE type_file.chr1

    FOR i=1 TO g_imx.getLength()
      IF g_imx[i].color=g_imx[l_ac3].color AND i<>l_ac3 AND g_imx[l_ac3].number=g_imx[i].number THEN
         LET l_flag='N'
         EXIT FOR
      END IF
    END FOR
    IF l_flag='N' THEN
       CALL cl_err('',1120,0)
       RETURN FALSE
    END IF
    RETURN TRUE

END FUNCTION

FUNCTION i404_updodp2()
   DEFINE l_odq RECORD LIKE odq_file.*   #TQC-C20418 add
   DEFINE l_ima151     LIKE ima_file.ima151 #TQC-C20418 add
 
   DELETE FROM odp_file WHERE odp00=g_odp00
                          AND odp01=g_odp01
                          AND odp02=g_odp02
                          AND odp06='1'
                          AND odp12=g_odp_t.odp07
#                         AND odp13=g_odp13
   IF SQLCA.sqlcode THEN
      CALL cl_err('del odp',SQLCA.sqlcode,1)
      RETURN FALSE
   END IF
#FUN-B90101--------add------------begin--------------
   DELETE FROM odq_file WHERE odq01=g_odp01
                          AND odq02=g_odp02
                          AND odq00=g_odp00
                          AND odq03=g_odp_t.odp07
                          AND odq04='0'
                          AND odq08=' '
   IF SQLCA.sqlcode THEN
      CALL cl_err('del odp',SQLCA.sqlcode,1)
      RETURN FALSE
   END IF
   DELETE FROM odq_file WHERE odq01=g_odp01
                          AND odq02=g_odp02
                          AND odq00=g_odp00
                          AND odq04='1'
                          AND odq08=g_odp_t.odp07
   IF SQLCA.sqlcode THEN
      CALL cl_err('del odp',SQLCA.sqlcode,1)
      RETURN FALSE
   END IF
#FUN-B90101--------end-------------------------------
   SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=g_odp[l_ac1].odp07  #TQC-C20418 add
   IF l_ima151 = 'Y' THEN                    #TQC-C20418 add
      IF NOT i404_insodp2() THEN
         RETURN FALSE
      END IF
#TQC-C20418--add--begin--
   ELSE
      LET l_odq.odq00 =g_odp00
      LET l_odq.odq01 =g_odp01
      LET l_odq.odq02 =g_odp02
      LET l_odq.odq03 =g_odp[l_ac1].odp07
      LET l_odq.odq04 ='0'
      LET l_odq.odq05 =1
      LET l_odq.odq06 =g_odp[l_ac1].odp07
      LET l_odq.odq07 =g_odp[l_ac1].odp08
      LET l_odq.odq08 =' '
      INSERT INTO odq_file VALUES(l_odq.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","odq_file",g_odp00,g_odp[l_ac1].odp07,SQLCA.sqlcode,"","",1)
         RETURN FALSE 
      END IF
   END IF
#TQC-C20418--add--end--
   RETURN TRUE

END FUNCTION

FUNCTION i404_insodp2()    #新增關聯料件資料到odp_file
  DEFINE l_odp    RECORD   LIKE odp_file.*
  DEFINE l_price           LIKE oeb_file.oeb13
  DEFINE l_occ42           LIKE occ_file.occ42
  DEFINE l_occ44           LIKE occ_file.occ44
  DEFINE l_occ45           LIKE occ_file.occ45
  DEFINE l_occ76           LIKE occ_file.occ76
  DEFINE l_occ77           LIKE occ_file.occ77
  DEFINE l_ima31           LIKE ima_file.ima31
  DEFINE l_success         LIKE type_file.chr1
  DEFINE l_ima151          LIKE ima_file.ima151   #FUN-B90101--add
  DEFINE l_odq   RECORD    LIKE odq_file.*        #FUN-B90101--add
  DEFINE l_ima_yy          LIKE imaslk_file.imaslk05
  DEFINE l_now_yy          LIKE imaslk_file.imaslk05
  DEFINE l_n               LIKE type_file.num5

   LET g_sql = "SELECT odk02 FROM odk_file ",
                  " WHERE odk01 = '",g_odp[l_ac1].odp07 ,"'",
                  "   AND odk02 <> ' '"

   PREPARE i404_insodp2 FROM g_sql
   DECLARE odp_inscs2 CURSOR FOR i404_insodp2

   LET l_success='Y'
   FOREACH odp_inscs2 INTO l_odp.odp07
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      SELECT odn02,odn03,odn04 INTO l_odp.odp03,l_odp.odp04,l_odp.odp05 
        FROM odn_file,odm_file
      WHERE odn01=odm01 AND odm02=odn02 AND odn05=l_odp.odp07
#        AND odm01=g_odp01 AND odm02=g_odp[l_ac1].odp03   #TQC-C40197--MARK---
        AND odm01=g_odp01                          #TQC-C40197--ADD------
        AND odmacti = 'Y' AND odmconf = 'Y'        #TQC-C20134--add odmacti = 'Y' AND odmconf = 'Y'   

      SELECT ima31 INTO l_ima31 FROM ima_file WHERE ima01=l_odp.odp07
      SELECT occ42,occ44,occ45,occ76,occ77 INTO l_occ42,l_occ44,l_occ45,l_occ76,l_occ77 FROM occ_file WHERE occ01=g_odp02
      CALL s_fetch_price_new(g_odp02,l_odp.odp07,'',l_ima31,g_today,'5',g_plant,l_occ42,l_occ44,l_occ45,'','',1,'','a')    #FUN-BC0071
         RETURNING l_odp.odp09,l_price

     IF cl_null(l_occ76) THEN LET l_occ76=100 END IF
     IF cl_null(l_occ77) THEN LET l_occ77=100 END IF
     LET l_now_yy = YEAR( g_today )
     SELECT imaslk05 INTO l_ima_yy FROM imaslk_file WHERE imaslk00 =l_odp.odp07
     IF NOT (cl_null(l_ima_yy) OR l_ima_yy=0) THEN
        LET l_n = l_now_yy - l_ima_yy
        IF l_n>0 THEN
           LET l_occ76 = l_occ76-l_n*10
           LET l_occ77 = l_occ77-l_n*10
           IF l_occ76<10 THEN  #最低折扣为10
              LET l_occ76 = 10
           END IF
           IF l_occ77<10 THEN  #最低折扣为10
              LET l_occ77 = 10
           END IF
        END IF
     END IF
     IF cl_null(l_occ76) THEN LET l_occ76=100 END IF
     IF cl_null(l_occ77) THEN LET l_occ77=100 END IF


      IF g_odp13='1' THEN    #期貨
         LET l_odp.odp10=l_odp.odp09*l_occ76/100
      ELSE                   #現貨
         LET l_odp.odp10=l_odp.odp09*l_occ77/100
      END IF

      CALL cl_digcut(l_odp.odp09,t_azi03) RETURNING l_odp.odp09
      CALL cl_digcut(l_odp.odp10,t_azi03) RETURNING l_odp.odp10
      LET l_odp.odp00=g_odp00
      LET l_odp.odp01=g_odp01
      LET l_odp.odp02=g_odp02
      LET l_odp.odp06='1'
      LET l_odp.odp08=0
      LET l_odp.odp11='N'
      LET l_odp.odp12=g_odp[l_ac1].odp07
      LET l_odp.odp13=g_odp13

      INSERT INTO odp_file VALUES (l_odp.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","odp_file",g_odp00,l_odp.odp07,SQLCA.sqlcode,"","",1)
         LET l_success='N'
         EXIT FOREACH
      END IF
#FUN-B90101---add--------------------------
      SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=l_odp.odp07 
      IF l_ima151 <> 'Y' THEN
         LET l_odq.odq00 =g_odp00
         LET l_odq.odq01 =g_odp01
         LET l_odq.odq02 =g_odp02
         LET l_odq.odq03 =l_odp.odp07
         LET l_odq.odq04 ='1'
         LET l_odq.odq05 =1
         LET l_odq.odq06 =l_odp.odp07
         LET l_odq.odq07 =l_odp.odp08
         LET l_odq.odq08 =g_odp[l_ac1].odp07
         INSERT INTO odq_file VALUES(l_odq.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","odq_file",g_odp00,l_odp.odp07,SQLCA.sqlcode,"","",1)
            LET l_success='N'
            EXIT FOREACH
         END IF
      END IF
#FUN-B90101---end--------------------------
      INITIALIZE l_odp.* TO null  #TQC-C40197---ADD--- 
   END FOREACH

   IF l_success='Y' THEN
      RETURN TRUE
   ELSE
      RETURN FALSE
   END IF
END FUNCTION

#FUN-B20031 add-------------------------end-----------------------------------
