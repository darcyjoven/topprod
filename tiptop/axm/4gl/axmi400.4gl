# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi400.4gl
# Descriptions...:
# Date & Author..: 10/05/05 By chenying
# Modify.........: No.FUN-AA0059 10/10/27 By huangtao 修改料號的管控
# Modify.........: No.FUN-AB0025 10/11/12 By vealxu  i400_b1() 的 AFTER FIELD odk01沒有控卡到
# Modify.........: No.FUN-B20011 11/02/10 By huangtao ds1 change into ds
# Modify.........: No.FUN-B90104 11/09/22 By huangrh 服飾版本開發，單身修改成DIALOG形式
# Modify.........: No.TQC-C20079 12/02/08 By qiaozy  錄入不存在的款號，報（-811） 不能夠為輸出檔案開啟印表機
# Modify.........: No:TQC-C20117 12/02/10 By lixiang 服飾BUG修改
# Modify.........: No:TQC-C20172 12/02/14 By lixiang 服飾BUG修改(主商品不可錄入非多屬性料件)
# Modify.........: No.TQC-C30136 12/03/08 By xujing 處理ON ACITON衝突問題
# Modify.........: No.TQC-C30167 12/03/09 By huangrh 料件單身的不錄入，可以回到上一行
# Modify.........: No.TQC-C40197 12/04/28 By qiaozy 光标移到新的一行，但没有新增任何资料无法移回上一行
# Modify.........: No.FUN-C60021 12/06/11 By qiaozy 快捷键的设置
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds       #FUN-B20011 add

GLOBALS "../../config/top.global"

DEFINE g_odk DYNAMIC ARRAY OF RECORD
             odk01  LIKE odk_file.odk01,
             ima02  LIKE ima_file.ima02,
             ima021 LIKE ima_file.ima021,
             ima25  LIKE ima_file.ima25
             END RECORD
             
DEFINE g_odk_t RECORD
               odk01  LIKE odk_file.odk01,                                                                                            
               ima02  LIKE ima_file.ima02,                                                                                            
               ima021 LIKE ima_file.ima021,                                                                                           
               ima25  LIKE ima_file.ima25                                                                                             
               END RECORD                

DEFINE g_odk_b DYNAMIC ARRAY OF RECORD
               odk02   LIKE odk_file.odk02,
               ima02b  LIKE ima_file.ima02,
               ima021b LIKE ima_file.ima021,
               ima25b  LIKE ima_file.ima25
               END RECORD

DEFINE g_odk_b_t RECORD 
                 odk02   LIKE odk_file.odk02,
                 ima02b  LIKE ima_file.ima02,
                 ima021b LIKE ima_file.ima021,
                 ima25b  LIKE ima_file.ima25
                 END RECORD

DEFINE g_wc         STRING
DEFINE g_sql        STRING
DEFINE g_forupd_sql STRING 
DEFINE l_ac         LIKE type_file.num5
DEFINE l_ac1        LIKE type_file.num5
DEFINE l_ac_t       LIKE type_file.num5
DEFINE l_ac1_t      LIKE type_file.num5
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_rec_b      LIKE type_file.num5 
DEFINE g_rec_b_2    LIKE type_file.num5
DEFINE g_rec_b_1    LIKE type_file.num5
DEFINE g_flag       LIKE type_file.chr1 
DEFINE g_argv1      LIKE ima_file.ima01
DEFINE g_wc2        STRING
DEFINE g_curs_index LIKE type_file.num5 #FUN-B90104--ADD--
DEFINE g_row_count  LIKE type_file.num5 #FUN-B90104--ADD--
DEFINE g_b_flag     LIKE type_file.chr1 #FUN-D30034 add
 
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

   OPEN WINDOW i400_w WITH FORM "axm/42f/axmi400"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_set_comp_required("odk01",TRUE) #TQC-C20079---add-- 
#FUN-B90104---ADD--BEGIN---
   LET l_ac=1
   CALL i400_b_fill1(" 1=1"," 1=1")
   CALL i400_b_fill_2(" 1=1")
   CALL i400_menu()
#FUN-B90104---ADD--END----
 
   CLOSE WINDOW i400_w     
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN

FUNCTION i400_menu()
   WHILE TRUE
      CALL i400_bp("G")
      
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i400_q()        #FUN-B90104---MODIFY-----
            END IF
            
         WHEN "detail"                
            IF cl_chk_act_auth() THEN 
               CALL i400_b()  
            ELSE
               LET g_action_choice=""        
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

FUNCTION i400_odk01(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
    

   LET g_errno=''
   
   SELECT ima01,ima02,ima021,ima25 INTO g_odk[l_ac].odk01,g_odk[l_ac].ima02,g_odk[l_ac].ima021,g_odk[l_ac].ima25
      FROM ima_file WHERE ima01=g_odk[l_ac].odk01
   IF SQLCA.sqlcode=100 THEN
      LET g_errno='aoo-005'
   ELSE
	  LET g_errno=SQLCA.sqlcode USING '------'
   END IF 
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY BY NAME g_odk[l_ac].odk01,g_odk[l_ac].ima02,g_odk[l_ac].ima021,g_odk[l_ac].ima25
   END IF 
      
END FUNCTION

FUNCTION i400_bp(p_ud)
   DEFINE p_ud LIKE type_file.chr1

   IF p_ud<>"G" OR g_action_choice = "detail" THEN #FUN-D30034 add detail 
      RETURN 
   END IF
   
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel",FALSE)
   CALL i400_b_fill1(g_wc,g_wc2)
   CALL i400_b_fill_2(g_wc2)
#服飾版DIALOG形式                                             
#FUN-B90104---ADD---BEGIN---
   DIALOG ATTRIBUTES(UNBUFFERED)
   
      DISPLAY ARRAY g_odk_b TO s_odk_b.* 
         BEFORE DISPLAY
            LET g_action_choice=""
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag = '1'    #FUN-D30034 add
          
         BEFORE ROW

            LET l_ac1=DIALOG.getCurrentRow("s_odk_b")
        #####TQC-C30136---mark---str#####
        #ON ACTION accept
        #   LET g_action_choice = "detail"
        #   LET l_ac1=ARR_CURR()
        #   EXIT DIALOG
        #####TQC-C30136---mark---end#####        
         END DISPLAY
#FUN-B90104---ADD---END----- 

      DISPLAY ARRAY g_odk TO s_odk.* 
#FUN-B90104---ADD---BEGIN---
         BEFORE DISPLAY
            LET g_action_choice=""
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag = '2'    #FUN-D30034 add
#FUN-B90104---ADD---END-----

         BEFORE ROW
            LET l_ac = DIALOG.getCurrentRow("s_odk")

            CALL cl_show_fld_cont()
            CALL i400_b_fill_2(" 1=1") 
#            CALL i400_reflesh()
#####TQC-C30136---mark---str#####          
#FUN-B90104---ADD---BEGIN---
#        ON ACTION accept
#           LET g_action_choice = "detail"
#           LET l_ac=ARR_CURR()
#           EXIT DIALOG
#FUN-B90104---ADD---END-----
#####TQC-C30136---mark---end#####

      END DISPLAY
        

      ON ACTION accept
         LET g_action_choice = "detail"
#         LET l_ac = ARR_CURR()   #TQC-C30167 mark
#         LET l_ac1=ARR_CURR()    #TQC-C30167 mark
         EXIT DIALOG       #FUN-B90104----MODIFY---


      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG       #FUN-B90104----MODIFY---
  
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG  #FUN-B90104-----MODIFY---
         

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG      #FUN-B90104-----MODIFY---

 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DIALOG     #FUN-B90104-----MODIFY---  	   
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
            
      ON ACTION about          
         CALL cl_about()      
 
      ON ACTION HELP          
         CALL cl_show_help()  
 
      ON ACTION controlg       
         CALL cl_cmdask()
         
      ON ACTION cancel
          LET INT_FLAG=FALSE 
          LET g_action_choice="exit"
          EXIT DIALOG     #FUN-B90104-----MODIFY---
         
   END DIALOG             #FUN-B90104-----MODIFY---
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION

 
FUNCTION i400_q()
   CALL i400_b_askkey() 
END FUNCTION


FUNCTION i400_b_askkey()
   CLEAR FORM
   CALL g_odk.clear()

#FUN-B90104----ADD---BEGIN---
   CALL g_odk_b.clear()
   CALL cl_opmsg('q')
   LET INT_FLAG=0
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " odk01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
   ELSE
      CALL cl_set_head_visible("accept,cancel","YES")
      DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT g_wc ON odk01 FROM s_odk[1].odk01
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

      CONSTRUCT g_wc2 ON odk02 FROM s_odk_b[1].odk02
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

      ON ACTION controlp
         CASE

            WHEN INFIELD(odk01)
#FUN-B90104--mark--------begin---------
#              CALL q_sel_ima(TRUE, "q_odk_1"," ima151='Y' AND ima1010='1' ","","","","","","",'')
#              RETURNING  g_qryparam.multiret
#              DISPLAY g_qryparam.multiret TO odk01
#              NEXT FIELD odk01
#FUN-B90104----mark----end-------------
#FUN-B90104----add-------begin-----------------
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima_12"
               LET g_qryparam.where = "ima151 ='Y' "    #TQC-C20172 add
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO odk01 
               NEXT FIELD odk01 
#FUN-B90104--end-------------------------------
            WHEN INFIELD(odk02)
#FUN-B90104---------mark------------begin--------------
#              CALL q_sel_ima(TRUE, "q_odk_1"," ima151='Y' AND ima1010='1' ","","","","","","",'') 
#               RETURNING  g_qryparam.multiret
#              DISPLAY g_qryparam.multiret TO odk02
#              NEXT FIELD odk02
#FUN-B90104-------mark--------------end-----------------
#FUN-B90104----add-------begin-----------------
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima_12"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO odk02
               NEXT FIELD odk02
#FUN-B90104--end-------------------------------
            OTHERWISE EXIT CASE
         END CASE

         ON ACTION ACCEPT
            ACCEPT DIALOG

         ON ACTION CANCEL
            LET INT_FLAG=1
            EXIT DIALOG

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG


         ON ACTION about
            CALL cl_about()

         ON ACTION HELP
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()
         END DIALOG
      LET g_wc=g_wc CLIPPED
      LET g_wc2=g_wc2  CLIPPED


      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
   END IF
   IF cl_null(g_wc) THEN
      LET g_wc=" 1=1"
   END IF
   IF cl_null(g_wc2) THEN
      LET g_wc2=" 1=1"
   END IF
   IF g_wc2=" 1=1" OR cl_null(g_wc2) THEN
      LET g_sql="SELECT DISTINCT odk01 FROM odk_file ",
                " WHERE ",g_wc CLIPPED
      #          " ORDER BY odk01"
   ELSE
      LET g_sql="SELECT DISTINCT odk01 FROM odk_file ",
                " WHERE ", g_wc2 CLIPPED," AND ",g_wc CLIPPED
   END IF

   PREPARE i400_prepare21 FROM  g_sql
   DECLARE i400_cus21 SCROLL CURSOR WITH HOLD FOR i400_prepare21


   OPEN i400_cus21
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_odk[l_ac].odk01,SQLCA.sqlcode,0)
   ELSE
      CALL i400_b_fill1(g_wc,g_wc2)
      LET l_ac = 1

      LET g_odk_t.* = g_odk[l_ac].*
      CALL i400_b_fill_2(g_wc2)
   END IF
#FUN-B90104--ADD---END-------------

END FUNCTION


FUNCTION i400_b()
   DEFINE l_allow_insert,l_allow_delete  LIKE type_file.num5
   DEFINE l_lock_sw       LIKE type_file.chr1
   
#FUN-B90104---ADD---BEGIN---   
   DEFINE l_flag          LIKE type_file.chr1
   DEFINE l_n1            LIKE type_file.num5
   DEFINE p_cmd           LIKE type_file.chr1

   DEFINE l_count         LIKE type_file.num5
   DEFINE p_wc            STRING
   DEFINE l_odk02_wc      STRING
   DEFINE l_focus         LIKE type_file.num5
   DEFINE l_ima151        LIKE ima_file.ima151,    #TQC-C20117 add
          l_imaag         LIKE ima_file.imaag      #TQC-C20117 add

   IF cl_null(l_ac1) THEN
      LET l_ac1=1
   END IF
#FUN-B90104---ADD---END---

   CALL cl_set_act_visible("accept,cancel",TRUE )
   CALL cl_opmsg('b')
#   LET g_odk_t.odk01= g_odk[l_ac].odk01 
   
#FUN-B90104---ADD---BEGIN---
   LET g_sql="SELECT DISTINCT odk01,'','','' FROM odk_file ",
                     " WHERE odk01=?"
  
   DECLARE i400_b1cs CURSOR FROM g_sql
#FUN-B90104---ADD---END---
   
   LET g_forupd_sql="SELECT odk02,'','','' FROM odk_file ",
                     " WHERE odk01=? AND odk02=? FOR UPDATE"

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i400_bcl CURSOR FROM g_forupd_sql 
 #  DISPLAY  g_odk_b[1].odk02,g_odk_b[1].ima02b,g_odk_b[1].ima021b,g_odk_b[1].ima25b
  #      TO odk02,ima02b,ima021b,ima025b
   LET l_allow_delete = cl_detail_input_auth("delete")
   
#FUN-B90104--ADD----BEGIN---------
   LET l_allow_insert = cl_detail_input_auth("insert")

   IF g_rec_b > 0 THEN LET l_ac = 1 END IF    #FUN-D30034 add
   IF g_rec_b_2 > 0 THEN LET l_ac1 = 1 END IF  #FUN-D30034 add

   DIALOG ATTRIBUTES(UNBUFFERED)

      INPUT ARRAY g_odk FROM s_odk.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
         BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_b_flag ='1'    #FUN-D30034 add

            LET g_action_choice = "" 
     
         BEFORE ROW
            LET l_ac= ARR_CURR()
            CALL i400_b_fill_2(" 1=1")

            LET l_lock_sw='N'
            LET g_odk_t.*=g_odk[l_ac].*
            BEGIN WORK
            
               IF g_rec_b>= l_ac THEN
                  LET p_cmd='u'
                  LET g_odk_t.*=g_odk[l_ac].*
     
                  OPEN i400_b1cs USING g_odk_t.odk01
                  IF STATUS THEN
                     CALL cl_err("OPEN i400_b1cs:", STATUS, 1)
                     LET l_lock_sw = "Y"
                     CLOSE i400_b1cs
                  ELSE
                  
                     FETCH i400_b1cs INTO g_odk[l_ac].*
                     CALL i400_odk01('d')
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(g_odk_t.odk01,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                     END IF
                  END IF
                  CALL cl_show_fld_cont()
               END IF
 


         AFTER FIELD odk01
#FUN-B90104---------mark-------begin---------------
#FUN-AB0025 ----------add by vealxu -------------
#           IF NOT cl_null(g_odk_b[l_ac1].odk02) THEN
#              IF NOT s_chk_item_no(g_odk_b[l_ac1].odk02,'') THEN
#                 CALL cl_err('',g_errno,1)
#                 NEXT FIELD odk01
#              END IF
#           END IF
#FUN-AB0025 ----------add by vealxu end-------------
#      
#           IF cl_null(g_odk[l_ac].odk01) THEN
#              CALL cl_err("","axm1021",0)
#              NEXT FIELD odk01
#           END IF
#           LET l_count=0
#           SELECT COUNT(*) INTO l_count FROM ima_file
#           WHERE ima01=g_odk[l_ac].odk01
#             AND ima151='Y'
#             AND ima1010='1'
#          
#           IF l_count = 0 THEN
#              CALL cl_err("","axm1022",0)
#              NEXT FIELD odk01
#           END IF
#FUN-B90104---------mark-----end-------------------------
#FUN-B90104--------------add-----begin-----------------             
             #TQC-C30167---modify--begin---
             #IF cl_null(g_odk[l_ac].odk01) THEN 
             #   CALL cl_err("","axm1021",0)      
             #    NEXT FIELD odk01                
             # ELSE                                
             IF NOT cl_null(g_odk[l_ac].odk01) THEN
             #TQC-C30167---modify--end---
                LET l_count=0
                SELECT COUNT(*) INTO l_count FROM ima_file WHERE ima01=g_odk[l_ac].odk01
                   AND ima1010='1' AND imaacti <>'X'     
                   AND ima151 ='Y'           #TQC-C20172 add 
                IF cl_null(l_count) OR l_count=0 THEN
                   CALL cl_err('','axm1026',1)   #TQC-C20079---modify----------
                   LET g_odk[l_ac].odk01=g_odk_t.odk01
                   NEXT FIELD odk01
                END IF
                CALL i400_odk01('d')       #TQC-C40197--ADD-- 
                CALL i400_b_fill_2(" 1=1") #TQC-C40197--ADD---
             END IF
#FUN-B90104-------------end-----------------------------
             IF p_cmd='a' OR (p_cmd = "u" AND g_odk[l_ac].odk01 != g_odk_t.odk01) THEN
                IF NOT cl_null(g_odk[l_ac].odk01) THEN   #TQC-C30167--add
                   SELECT COUNT(DISTINCT odk01) INTO l_count FROM odk_file
                    WHERE odk01=g_odk[l_ac].odk01
                   IF l_count = 1 THEN
                      CALL cl_err("","axm1024",1)
                      LET  g_odk[l_ac].odk01 = g_odk_t.odk01
                      NEXT FIELD odk01
                   END IF                         #TQC-C30167--add
                END IF
             END IF
#            CALL i400_odk01('d')        #TQC-C40197--MARK---
#            CALL i400_b_fill_2(" 1=1")  #TQC-C40197--MARK---
  
         BEFORE INSERT
            LET p_cmd='a'
            DISPLAY "BEFORE INSERT!"
            CALL g_odk_b.clear()
            INITIALIZE g_odk[l_ac].* TO NULL         
            LET g_odk_t.* = g_odk[l_ac].*    
            CALL cl_show_fld_cont()       
            NEXT FIELD odk01
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE i400_b1cs
               ROLLBACK WORK
               CANCEL INSERT
            END IF
            INSERT INTO odk_file(odk01,odk02)
              VALUES(g_odk[l_ac].odk01,' ')
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","odk_file",g_odk[l_ac].odk01,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b = g_rec_b + 1
               DISPLAY g_rec_b TO FORMONLY.cnt
               COMMIT WORK        
            END IF
         BEFORE DELETE
            IF g_odk[l_ac].odk01 IS NOT NULL     THEN
               SELECT COUNT(*) INTO l_n1 FROM odk_file WHERE odk01 = g_odk_t.odk01
               IF l_n1=0 THEN
                  CALL cl_err(g_odk_t.odk01,"are-1",0)
                  ROLLBACK WORK
                  CANCEL DELETE
               ELSE

                  IF NOT cl_delb(0,0) THEN
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF
                  IF l_lock_sw = "Y" THEN
                     CALL cl_err("", -263, 1)
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF
              
                  DELETE FROM odk_file
                  WHERE odk01 = g_odk_t.odk01
             
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","odk_file",g_odk_t.odk01,"",SQLCA.sqlcode,"","",1)  
               
                     ROLLBACK WORK
                     LET l_lock_sw = "N"
                     CANCEL DELETE
                  ELSE 
           
                     CLEAR FORM
                     CALL g_odk_b.clear()
                     LET g_rec_b=g_rec_b-1
                     DISPLAY g_rec_b TO FORMONLY.cnt
                     LET g_rec_b_1=0
                     DISPLAY g_rec_b_1 TO  FORMONLY.cn2
                     #LET l_flag='N'
                  END IF
               END IF
            END IF
            COMMIT WORK

          ON ROW CHANGE
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                LET g_odk[l_ac].* = g_odk_t.*
                LET  l_lock_sw = "N" 
                CLOSE i400_b1cs
                ROLLBACK WORK
                EXIT DIALOG 
             END IF
             IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_odk[l_ac].odk01,-263,1)
                LET g_odk[l_ac].* = g_odk_t.*
             ELSE    
                UPDATE odk_file SET odk01=g_odk[l_ac].odk01
                 WHERE odk01=g_odk_t.odk01
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","odk_file",g_odk_t.odk01,"",SQLCA.sqlcode,"","",1) 
                   LET g_odk[l_ac].* = g_odk_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                   CALL i400_b_fill_2(" 1=1")
                END IF
                IF SQLCA.sqlcode=0 and  SQLCA.sqlerrd[3] = 0 THEN
                   LET g_rec_b = g_rec_b + 1
                   DISPLAY g_rec_b TO FORMONLY.cnt
                END IF
             END IF
                       
          AFTER ROW
             LET l_ac = ARR_CURR()
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_odk[l_ac].* = g_odk_t.*
                END IF
                LET  l_lock_sw = "N"
                CLOSE i400_b1cs  
                ROLLBACK WORK 
                EXIT DIALOG 
             END IF
             LET  l_lock_sw = "N"
             CLOSE i400_b1cs  
             COMMIT WORK      
       END INPUT
#FUN-B90104---ADD---END-----


#FUN-B90104---ADD---BEGIN----
      INPUT ARRAY g_odk_b FROM s_odk_b.*
          ATTRIBUTE(COUNT=g_rec_b_2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
#FUN-B90104---ADD---END----

         BEFORE INPUT
            LET g_action_choice = "" 
            LET g_b_flag ='2'    #FUN-D30034 add   

         BEFORE ROW
            LET l_ac1=ARR_CURR()
            LET l_lock_sw='N'
            
            LET g_odk_b_t.*=g_odk_b[l_ac1].*
     
            BEGIN WORK


               IF g_rec_b_2 >= l_ac1 THEN
                  LET p_cmd='u'
                  LET g_odk_b_t.* = g_odk_b[l_ac1].*  
              
                  OPEN i400_bcl USING g_odk[l_ac].odk01,g_odk_b[l_ac1].odk02
                  IF STATUS THEN
                     CALL cl_err("OPEN i400_bcl:", STATUS, 1)
                     CLOSE i400_bcl
                     LET l_lock_sw = "Y"
                  ELSE
                     FETCH i400_bcl INTO g_odk_b[l_ac1].*
#                    SELECT ima02 INTO l_ima02,ima021 INTO l_ima021,ima025 INTO l_ima025 FROM ima_file WHERE ima01=g_odk_b[l_ac1].odk02
                     CALL i400_odk02('d')                
                     IF SQLCA.sqlcode and SQLCA.sqlcode<>100 THEN
                        CALL cl_err(g_odk_b_t.odk02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                     END IF
                  END IF
                  CALL cl_show_fld_cont()         
               END IF

#FUN-B90104---ADD---BEGIN--- 
         BEFORE INSERT
            LET l_ac1 = ARR_CURR()
            LET p_cmd = 'a'
            INITIALIZE g_odk_b[l_ac1].* TO NULL
     
            LET g_odk_b_t.* = g_odk_b[l_ac1].*
            CALL cl_show_fld_cont()
            NEXT FIELD odk02
         AFTER INSERT
            IF INT_FLAG THEN
	           CALL cl_err('',9001,0)
	           LET INT_FLAG = 0
	           CLOSE i400_bcl
                   ROLLBACK WORK
	           CANCEL INSERT
	        END IF
            INSERT INTO odk_file(odk01,odk02)
            VALUES(g_odk[l_ac].odk01,g_odk_b[l_ac1].odk02)      
            IF SQLCA.sqlcode THEN
	           CALL cl_err3("ins","odk_file",g_odk[l_ac].odk01,"",SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
	           CANCEL INSERT
	        ELSE 
	           MESSAGE 'INSERT O.K'
	           LET g_rec_b_2 = g_rec_b_2 + 1
	           DISPLAY g_rec_b_2 TO FORMONLY.cn2
            END IF
#FUN-B90104---ADD---END---

     
         AFTER FIELD odk02
#FUN-B90104-------------modify------------begin-------------------
#FUN-AA0059 ---------------------start----------------------------
            IF NOT cl_null(g_odk_b[l_ac1].odk02) THEN
#              IF NOT s_chk_item_no(g_odk_b[l_ac1].odk02,"") THEN
#                  CALL cl_err('',g_errno,1)
#                 LET g_odk_b[l_ac1].odk02=g_odk_b_t.odk02 
#                 NEXT FIELD odk02
#               END IF
               LET l_count=0
           #TQC-C20117--add--begin--  
               SELECT COUNT(*) INTO l_count FROM ima_file WHERE ima01=g_odk_b[l_ac1].odk02
                                                         AND ima1010='1' and imaacti='Y'
               IF l_count=0 THEN
                  CALL cl_err('','100',0)
                  LET g_odk_b[l_ac1].odk02=g_odk_b_t.odk02
                  NEXT FIELD odk02
               END IF
               SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file
                WHERE ima01=g_odk_b[l_ac1].odk02 AND imaacti='Y'
               IF l_ima151='N' AND l_imaag='@CHILD' THEN
                  CALL cl_err('','axm1104',0)
                  NEXT FIELD odk02 
               END IF
           #TQC-C20117--add--end-- 
 
           #TQC-C20117--mark--begin--
           #   SELECT COUNT(*) INTO l_count FROM ima_file WHERE ima01=g_odk_b[l_ac1].odk02
           #      AND ima1010='1' AND imaacti <>'X' AND (ima151 !='N' OR imaag<>'@CHILD')
           #   IF cl_null(l_count) OR l_count=0 THEN
           #      CALL cl_err('','axm1026',1)  #TQC-C20079---modify----------
           #      LET g_odk_b[l_ac1].odk02=g_odk_b_t.odk02
           #      NEXT FIELD odk02
           #   END IF
           #TQC-C20117--mark--end---
               CALL i400_odk02('d')
            END IF
#FUN-AA0059 ---------------------end-------------------------------
#FUN-B90104---------modify----------------end---------------------

#FUN-B90104 ---------------------start----------------------------
#TQC-C30167----mark---begin--
#           IF cl_null(g_odk_b[l_ac1].odk02) THEN
#              CALL cl_err("","axm1021",0)
#              NEXT FIELD odk02
#           END IF
#TQC-C30167----mark---end--
#FUN-B90104-------------mark-------begin----------------
#          LET l_count=0
#          SELECT COUNT(*) INTO l_count FROM ima_file
#          WHERE ima01=g_odk_b[l_ac1].odk02
#            AND ima151='Y'
#            AND ima1010='1'
#         
#          IF l_count = 0 THEN
#             CALL cl_err("","axm1022",0)
#             NEXT FIELD odk02
#
#          END IF
#FUN-B90104---------------mark--------------end----------
           IF p_cmd='a' OR (p_cmd = "u" AND g_odk_b[l_ac1].odk02 != g_odk_b_t.odk02) THEN
              IF NOT cl_null(g_odk_b[l_ac1].odk02) THEN   #TQC-C3016add
                 LET l_count=0
                 SELECT COUNT(*) INTO l_count FROM odk_file
                  WHERE odk01=g_odk[l_ac].odk01
                    AND odk02=g_odk_b[l_ac1].odk02
                 IF l_count = 1 THEN
                    CALL cl_err("","axm1025",1)
                    LET g_odk_b[l_ac1].odk02=g_odk_b_t.odk02 
                    NEXT FIELD odk02
                 END IF
              END IF                                      #TQC-C3016add
           END IF
#FUN-B90104 ---------------------END----------------------------
        
         BEFORE DELETE
            IF g_odk_b[l_ac1].odk02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               DELETE FROM odk_file
                WHERE odk01 = g_odk[l_ac].odk01
                  AND odk02 = g_odk_b_t.odk02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","odk_file",g_odk[l_ac].odk01,g_odk_b_t.odk02,SQLCA.sqlcode,"","",1)  
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b_2=g_rec_b_2-1
               DISPLAY g_rec_b_2 TO FORMONLY.cn2
            END IF
            COMMIT WORK
          
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_odk_b[l_ac1].* = g_odk_b_t.*
               
#FUN-B90104 ---------------------START----------------------------
               LET l_lock_sw = "N"
               CLOSE i400_bcl
               ROLLBACK WORK
               
#FUN-B90104 ---------------------END---------------------------- 
             
               EXIT DIALOG    #FUN-B90104----MODIFY-----
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_odk_b[l_ac1].odk02,-263,1)
               LET g_odk_b[l_ac1].* = g_odk_t.*
            ELSE    
               UPDATE odk_file SET odk02=g_odk_b[l_ac1].odk02
                       WHERE odk01=g_odk_t.odk01 AND odk02=g_odk_b_t.odk02
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","odk_file",g_odk_t.odk01,g_odk_b_t.odk02,SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    LET g_odk_b[l_ac1].* = g_odk_b_t.*
                    
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                    CALL i400_b_fill_2(" 1=1")  #FUN-B90104--modify----
                 END IF
           END IF

           AFTER ROW
              LET l_ac1 = ARR_CURR() #FUN-B90104--ADD--
              LET l_ac1_t=l_ac       #FUN-B90104--ADD--
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0

#FUN-B90104--ADD--begin------
                 IF p_cmd='u' THEN 
                    LET g_odk_b[l_ac1].* = g_odk_b_t.*
                 END IF 
                 CLOSE i400_bcl
                 ROLLBACK WORK
                 EXIT DIALOG 
              END IF
        END INPUT   
#FUN-B90104--ADD--end--------

       #FUN-D30034---add---begin---- 
        BEFORE DIALOG
           CASE g_b_flag
              WHEN '1' NEXT FIELD odk01
              WHEN '2' NEXT FIELD odk02
           END CASE 
       #FUN-D30034---add---end---- 

#FUN-B90104----ADD----BEGIN----
    ON ACTION controlp
       CASE 
          WHEN INFIELD (odk01)
#FUN-B90104-------modify-----------begin-------------
#            CALL q_sel_ima(FALSE, "q_ima01_4"," ima151='Y' AND ima1010='1' AND imaacti='Y' ",g_odk_t.odk01,"","","","","",'' )
#               RETURNING g_odk[l_ac].odk01  
             CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima_12"
                  LET g_qryparam.where = "ima151 ='Y' "  #TQC-C20172 add   
                  LET g_qryparam.default1 = g_odk[l_ac].odk01 
                  CALL cl_create_qry() RETURNING g_odk[l_ac].odk01 
#FUN-B90104-------------modify-------------end--------
                 DISPLAY g_odk[l_ac].odk01 TO odk01
             CALL i400_odk01('d')                                                                                
             NEXT FIELD odk01 
          WHEN INFIELD (odk02)

             LET l_focus = ARR_CURR()
             LET l_count = 0
             LET l_count = g_odk_b.getLength()
             IF cl_null(l_count) THEN
                LET l_count=0
             END IF
             IF l_focus >= l_count AND cl_null(g_odk_b[l_focus].odk02) THEN
                LET l_odk02_wc = ''
              # CALL q_sel_ima(TRUE, "q_odk_3"," ima151='Y' AND ima1010='1' ",g_odk_b_t.odk02,"","","","","",'' )
                CALL q_ima_400(1,1,g_plant)
                RETURNING l_odk02_wc
                CALL i400_gb(l_odk02_wc)
                DISPLAY BY NAME g_odk_b[l_ac1].odk02
                NEXT FIELD odk02
             ELSE
#FUN-B90104---------modify-------begin------------
#                CALL q_sel_ima(FALSE, "q_odk_3"," ima151='Y' AND ima1010='1' ",g_odk_b_t.odk02,"","","","","",'' )
#                CALL q_ima_400(0,1,g_plant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima_12"
                 LET g_qryparam.default1 = g_odk[l_ac].odk01
                 CALL cl_create_qry()  RETURNING g_odk_b[l_ac1].odk02
                 DISPLAY BY NAME g_odk_b[l_ac1].odk02
                 NEXT FIELD odk02
#FUN-B90104---------------modify-----------------end------
             END IF
          OTHERWISE EXIT CASE
       END CASE
    ON ACTION ACCEPT
       LET g_action_choice="detail"
       ACCEPT DIALOG

    ON ACTION CANCEL
      #LET g_action_choice="exit"  #FUN-D30034 mark
      #FUN-D30034--add---begin---
       IF p_cmd = 'a' THEN
          IF g_b_flag = '1' THEN
             CALL g_odk.deleteElement(l_ac)
             IF g_rec_b != 0 THEN
                LET g_action_choice="detail"
             END IF
          END IF
          IF g_b_flag = '2' THEN
             CALL g_odk_b.deleteElement(l_ac1)
             IF g_rec_b_2 != 0 THEN
                LET g_action_choice="detail"
             END IF
          END IF
       END IF 
      #FUN-D30034--add---end---
       EXIT DIALOG
#FUN-B90104----ADD----END------

    ON IDLE g_idle_seconds                            
       CALL cl_on_idle()
       CONTINUE DIALOG   #FUN-B90104----MODIFY----
      
    ON ACTION about       
       CALL cl_about()  
       
    ON ACTION help 
        CALL cl_show_help()
#FUN-C60021-----ADD---STR---
    ON ACTION controlg
       CALL cl_cmdask()
#FUN-C60021----ADD---END----
    END DIALOG           #FUN-B90104----MODIFY----
    CLOSE i400_bcl
    CLOSE i400_b1cs      #FUN-B90104----ADD----
    
    COMMIT WORK

 
END FUNCTION

FUNCTION i400_odk02(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1                                                                                              
                                                                                                                                    
                                                                                                                                    
   LET g_errno=''                                                                                                                   
                                                                                                                                    
   SELECT ima01,ima02,ima021,ima25 INTO g_odk_b[l_ac1].odk02,g_odk_b[l_ac1].ima02b,g_odk_b[l_ac1].ima021b,g_odk_b[l_ac1].ima25b                 
      FROM ima_file WHERE ima01=g_odk_b[l_ac1].odk02                                                                                   
   IF SQLCA.sqlcode=100 THEN                                                                                                        
      LET g_errno='aoo-005'                                                                                                         
   ELSE                                                                                                                             
          LET g_errno=SQLCA.sqlcode USING '------'                                                                                  
   END IF                                                                                                                           
   IF p_cmd='d' OR cl_null(g_errno)THEN                                                                                             
      DISPLAY BY NAME g_odk_b[l_ac1].odk02,g_odk_b[l_ac1].ima02b,g_odk_b[l_ac1].ima021b,g_odk_b[l_ac1].ima25b                                      
   END IF                              
END FUNCTION




FUNCTION i400_b_fill1(p_wc1,p_wc2)
 
   DEFINE p_wc1 STRING 
   DEFINE p_wc2 STRING 
   
#FUN-B90104----ADD---BEGIN---
   IF cl_null(p_wc1) THEN
      LET p_wc1=" 1=1"
   END IF
   IF cl_null(p_wc2) THEN
      LET p_wc2=" 1=1"
   END IF
#FUN-B90104----ADD---END------

   IF p_wc2!=" 1=1" THEN                                                                                                                                
      LET g_sql="SELECT DISTINCT odk01,'','','' FROM odk_file " ,                                                                   
              " WHERE odk01<>' ' AND ",p_wc2 CLIPPED ," AND ",p_wc1 CLIPPED
   ELSE
      LET g_sql="SELECT DISTINCT odk01,'','',''  FROM odk_file " ,                                                                   
             " WHERE odk01<>' ' AND ",p_wc1 CLIPPED                               
   END IF

   PREPARE i400_pre1 FROM g_sql                                                                                                      
   DECLARE i400_cus1 CURSOR FOR i400_pre1                                                                                             
                                                                                                                                    
   CALL g_odk.clear()                                                                                                               
                                                                                                                                    
   LET g_cnt = 1                                                                                                                    
                                                                                                                                    
   FOREACH i400_cus1 INTO g_odk[g_cnt].*                                                                                             
      IF STATUS THEN                                                                                                                
         CALL cl_err('foreach:',STATUS,1)                                                                                           
         EXIT FOREACH                                                                                                               
      END IF                                                                                                                        
                                                                                                                                    
       SELECT ima02,ima021,ima25 INTO g_odk[g_cnt].ima02, g_odk[g_cnt].ima021,g_odk[g_cnt].ima25           
            FROM ima_file WHERE ima01=g_odk[g_cnt].odk01 
#       SELECT ima02,ima021,ima25 INTO g_odk[g_cnt].ima02, g_odk[g_cnt].ima021,g_odk[g_cnt].ima25           
 #           FROM ima_file WHERE ima01=g_odk[g_cnt].odk01 
      
        LET g_cnt = g_cnt + 1                                                                                                         
      IF g_cnt > g_max_rec THEN                                                                                                     
         CALL cl_err( '', 9035, 0 )                                                                                                 
         EXIT FOREACH                                                                                                               
      END IF                                                                                                                        
   END FOREACH                                                                                                                      
                                                                                                                                    
   CALL g_odk.deleteElement(g_cnt)                                                                                                  
                                                                                                                                    
   MESSAGE ""                                                                                                                       
   LET g_rec_b = g_cnt-1                                                                                                            
   DISPLAY g_rec_b TO FORMONLY.cnt                                                                                                  
   LET g_cnt = 0                              
END FUNCTION

FUNCTION i400_b_fill_2(p_wc2)   #FUN-B90104---MODIFY------

 #FUN-B90104---ADD---BEGIN-----
   DEFINE p_wc2 STRING
   IF cl_null(p_wc2) THEN
      LET p_wc2=" 1=1"
   END IF
   IF p_wc2=" 1=1" THEN
   
      LET g_sql="SELECT odk02,'','',''  FROM odk_file WHERE odk01='",g_odk[l_ac].odk01 CLIPPED,"' AND odk02<>' ' "
   ELSE 
      LET g_sql="SELECT odk02,'','',''  FROM odk_file WHERE odk01='",g_odk[l_ac].odk01 CLIPPED,"'"," AND odk02<>' ' ",p_wc2 CLIPPED 
   END IF 
#FUN-B90104---ADD----END----- 
  
#   LET g_sql="SELECT odk02,'','',''  FROM odk_file WHERE odk01='",g_odk[l_ac].odk01 CLIPPED,"'" #FUN-B90104---MARK--
   
   PREPARE i400_pre_b FROM g_sql                                                                                                      
   DECLARE i400_cus_b CURSOR FOR i400_pre_b                                                                                            
                                                                                                                                    
   CALL g_odk_b.clear()                                                                                                               
                                                                                                                                    
   LET g_cnt = 1                                                                                                                    
                                                                                                                                    
   FOREACH i400_cus_b INTO g_odk_b[g_cnt].*                                                                                             
      IF STATUS THEN                                                                                                                
         CALL cl_err('foreach:',STATUS,1)                                                                                           
         EXIT FOREACH                                                                                                               
      END IF                                                                                                                        
                                                                                                                                    
      SELECT ima02,ima021,ima25 INTO g_odk_b[g_cnt].ima02b, g_odk_b[g_cnt].ima021b,g_odk_b[g_cnt].ima25b
        FROM ima_file  WHERE ima01=g_odk_b[g_cnt].odk02
     # DISPLAY g_odk_b[g_cnt].odk02,g_odk_b[g_cnt].ima02b,g_odk_b[g_cnt].ima021b,g_odk_b[g_cnt].ima25b TO odk02,ima02b,ima021b,ima25b 
      LET g_cnt = g_cnt + 1                                                                                                         
      IF g_cnt > g_max_rec THEN                                                                                                     
         CALL cl_err( '', 9035, 0 )                                                                                                 
         EXIT FOREACH                                                                                                               
      END IF                                                                                                                        
   END FOREACH                                                                                                                      
                                                                                                                                    
   CALL g_odk_b.deleteElement(g_cnt)                                                                                                  
                                                                                                                                    
   MESSAGE ""                                                                                                                       
   LET g_rec_b_2 = g_cnt-1                                                                                                            
   DISPLAY g_rec_b_2 TO FORMONLY.cn2                                                                                                  
   LET g_cnt = 0
 
# END IF                  
END FUNCTION

#FUN-B90104---ADD--BEGIN---
FUNCTION i400_gb(l_odk02_wc)
   DEFINE l_cnt       LIKE   type_file.num10
   DEFINE l_max       LIKE   type_file.num10
   DEFINE l_odk02_wc         STRING
   DEFINE l_odk02     LIKE   odk_file.odk02
   DEFINE l_count     LIKE  type_file.num10 
   
   IF cl_null(l_odk02_wc) THEN 
      RETURN
   END IF
   
   CALL cl_replace_str(l_odk02_wc,'|',"','") RETURNING l_odk02_wc
   LET g_sql = "SELECT ima01 FROM ima_file",
               " WHERE ima01 IN ('",l_odk02_wc,"')"
   
   PREPARE i400_gb FROM g_sql
   DECLARE odk_gb CURSOR FOR i400_gb
   
   LET l_cnt = g_odk_b.getLength()
   
   IF cl_null(l_cnt) OR l_cnt = 0 THEN
      LET l_cnt = 1
   END IF
   
   
   LET l_count=0
   FOREACH odk_gb INTO l_odk02
      IF SQLCA.sqlcode THEN			
         CALL cl_err('foreach odk_gb',SQLCA.sqlcode,1)			
         LET g_success = 'N'			
         EXIT FOREACH			
      END IF 
      LET l_count=l_count+1
      LET g_odk_b[l_cnt].odk02=l_odk02         
      SELECT ima02,ima021,ima25 
        INTO g_odk_b[l_cnt].ima02b,g_odk_b[l_cnt].ima021b,g_odk_b[l_cnt].ima25b
        FROM ima_file 
       WHERE ima01 = g_odk_b[l_cnt].odk02
     
       DISPLAY BY NAME g_odk_b[l_cnt].ima02b
       DISPLAY BY NAME g_odk_b[l_cnt].ima021b
       DISPLAY BY NAME g_odk_b[l_cnt].ima25b 
       IF l_count <>1 THEN
          INSERT INTO odk_file(odk01,odk02)
                        VALUES(g_odk[l_ac].odk01,g_odk_b[l_cnt].odk02)
          IF STATUS OR SQLCA.SQLCODE THEN
             ROLLBACK WORK
             RETURN
          END IF
       END IF
       LET l_cnt = l_cnt + 1
       
   END FOREACH
   CALL g_odk_b.deleteElement(l_cnt)
   LET g_rec_b_2=l_cnt-2
END FUNCTION

#FUN-B90104---ADD--END-----

FUNCTION i400_reflesh()
   DEFINE l_n LIKE type_file.num5
    
   SELECT COUNT(*) INTO l_n FROM odk_file WHERE odk01=g_odk[l_ac].odk01
   IF l_n=0 THEN
      CLEAR FORM
      CALL g_odk_b.clear()
      LET g_rec_b_1=0
      DISPLAY g_rec_b_1 TO  FORMONLY.cn2
      DISPLAY g_rec_b TO  FORMONLY.cnt
   ELSE 
      DISPLAY ARRAY g_odk_b TO s_odk_b.* ATTRIBUTE(COUNT=g_rec_b)    
      BEFORE ROW                                                  
         EXIT DISPLAY                                             
      END DISPLAY                                                    
   END IF 
END FUNCTION
#FUN-B90104
