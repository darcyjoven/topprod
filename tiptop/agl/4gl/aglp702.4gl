# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aglp702.4gl
# Descriptions...: 遞延收入拋轉傳票還原作業
# Date & Author..: 10/08/05 FUN-9B0017 By Mike
# Modify.........: NO.FUN-A60007 10/08/06 BY Yiting oct081-->oct08
# Modify.........: NO.MOD-A80025 10/08/10 BY chenmoyan加入oct00為update條件
# Modify.........: NO.FUN-A80061 10/08/10 BY chenmoyan GL->AR
# Modify.........: No.FUN-AB0110 11/01/24 By chenmoyan 拋轉還原時遞延收入科目傳票單身項次回寫oct22
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting  1、將cl_used()改成標準，使用g_prog
#                                                          2、未加離開前的 cl_used(2) 
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B40056 11/06/03 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No.TQC-BB0048 11/11/07 By Carrier add azoplant/azolegal

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_wc,g_sql       STRING                  
DEFINE g_dbs_gl 	LIKE type_file.chr21   
DEFINE p_plant          LIKE ooz_file.ooz02p  
DEFINE p_acc            LIKE aaa_file.aaa01     
DEFINE p_acc1           LIKE aaa_file.aaa01    
DEFINE gl_date	 	LIKE type_file.dat        
DEFINE gl_yy,gl_mm	LIKE type_file.num5      
DEFINE g_existno	LIKE aba_file.aba01     
DEFINE g_existno1	LIKE aba_file.aba01    
DEFINE g_aaz84          LIKE aaz_file.aaz84        #還原方式 1.刪除 2.作廢 
DEFINE l_flag           LIKE type_file.chr1     
DEFINE g_cnt            LIKE type_file.num10   
DEFINE g_msg            LIKE type_file.chr1000    
DEFINE g_change_lang    LIKE type_file.chr1        #是否有做語言切換
DEFINE l_abapost        LIKE aba_file.abapost      
DEFINE l_aaa07          LIKE aaa_file.aaa07
DEFINE l_aba00          LIKE aba_file.aba00
DEFINE l_abaacti        LIKE aba_file.abaacti
DEFINE l_conf           LIKE type_file.chr1    

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL
   LET p_plant   = ARG_VAL(1)             #輸入總帳營運中心編號
   LET p_acc     = ARG_VAL(2)             #輸入總帳帳別編號
   LET g_existno = ARG_VAL(3)             #輸入原總帳傳票編號
   LET g_bgjob   = ARG_VAL(4)             #背景作業

   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211

   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p702_ask()
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            CALL cl_wait()
            BEGIN WORK
            CALL p702()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p702   
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_plant_new=p_plant
         LET g_sql="SELECT aba00,aba02,aba03,aba04,aba19,abapost,abaacti ",
                   " FROM ",cl_get_target_table(g_plant_new,'aba_file'),
                   #" WHERE aba01 = ? AND aba00 = ? AND aba06='GL'"
                   " WHERE aba01 = ? AND aba00 = ? AND aba06='AR'"   #FUN-A80061
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE p702_t_p3 FROM g_sql
         DECLARE p702_t_c3 CURSOR FOR p702_t_p3
         IF STATUS THEN
            CALL cl_err('decl aba_cursor:',STATUS,0)
            RETURN
         END IF
         OPEN p702_t_c3 USING g_existno,g_ooz.ooz02b
         FETCH p702_t_c3 INTO l_aba00,gl_date,gl_yy,gl_mm,l_conf,l_abapost,
                              l_abaacti 
         IF STATUS THEN
            CALL cl_err('sel aba:',STATUS,0)
            RETURN
         END IF
         IF l_abaacti = 'N' THEN
            CALL cl_err('','mfg8001',1)
            RETURN
         END IF
         #---增加判斷會計帳別之關帳日期
         LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_new,'aaa_file'),
                   " WHERE aaa01='",l_aba00,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE p702_x_gl_p3 FROM g_sql
         DECLARE p702_c_gl_p3 CURSOR FOR p702_x_gl_p3
         OPEN p702_c_gl_p3
         FETCH p702_c_gl_p3 INTO l_aaa07
         IF gl_date <= l_aaa07 THEN
            CALL cl_err(gl_date,'agl-200',0)
            RETURN
         END IF
         IF l_abapost = 'Y' THEN
            CALL cl_err(g_existno,'aap-130',0)
            RETURN
         END IF
         IF l_conf ='Y' THEN
            CALL cl_err(g_existno,'aap-026',0)
            RETURN
         END IF
         IF g_aza.aza63 = 'Y' THEN                                                                                                  
            SELECT aba00,aba01 INTO p_acc1,g_existno1                                                                            
                 FROM aba_file WHERE aba07=g_existno                                                                                    
            IF STATUS THEN                                                                                                          
               CALL cl_err3("sel","aba_file","","",STATUS,"","",1)                                                               
               RETURN                                                                                                               
            END IF                                                                                                     
            LET g_ooz.ooz02c = p_acc1                    
         END IF                  
         LET g_success = 'Y'
         BEGIN WORK
         CALL p702()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION p702()
   LET g_plant_new=p_plant
 
   #(還原方式為刪除/作廢)
   LET g_sql = "SELECT aaz84 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),
               " WHERE aaz00 = '0' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE aaz84_pre FROM g_sql
   DECLARE aaz84_cs CURSOR FOR aaz84_pre
   OPEN aaz84_cs
   FETCH aaz84_cs INTO g_aaz84
   IF STATUS THEN
      CALL cl_err('sel aaz84',STATUS,1)
      CALL cl_batch_bg_javamail("N")
      IF g_bgjob = "N" THEN
         CLOSE WINDOW p702 
      END IF
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   CALL p702_t()
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      CALL p702_t_1()
   END IF
END FUNCTION

FUNCTION p702_ask()
   DEFINE l_abapost,l_flag   LIKE aba_file.abapost 
   DEFINE l_aaa07            LIKE aaa_file.aaa07
   DEFINE l_aba00            LIKE aba_file.aba00
   DEFINE l_abaacti          LIKE aba_file.abaacti
   DEFINE l_conf             LIKE type_file.chr1    
   DEFINE lc_cmd             LIKE type_file.chr1000 
   DEFINE li_chk_bookno      LIKE type_file.num5,   
          l_sql              STRING                

   OPEN WINDOW p702 WITH FORM "agl/42f/aglp702" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("p_acc1,g_existno1",FALSE)
   ELSE
      CALL cl_set_comp_visible("p_acc1,g_existno1",TRUE)
   END IF

   WHILE TRUE
      LET g_bgjob = "N" 
      SELECT ooz02p,ooz02b INTO g_ooz.ooz02p,g_ooz.ooz02b
        FROM ooz_file
       WHERE ooz00='0'
      LET p_plant = g_ooz.ooz02p
      LET p_acc   = g_ooz.ooz02b
      LET g_existno = NULL

      INPUT BY NAME p_plant,p_acc,g_existno,g_bgjob WITHOUT DEFAULTS    

         BEFORE INPUT
            CALL cl_qbe_init()

         AFTER FIELD p_plant
            SELECT azp01 FROM azp_file
             WHERE azp01 = p_plant
            IF STATUS <> 0 THEN
               NEXT FIELD p_plant
            END IF
            LET g_plant_new=p_plant

         AFTER FIELD p_acc
            LET g_ooz.ooz02b = p_acc
            CALL s_check_bookno(p_acc,g_user,p_plant) 
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD p_acc
            END IF 
            LET g_plant_new= p_plant  #工廠編號
            LET l_sql = "SELECT COUNT(*)",
                        "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'),
                        " WHERE aaa01 = '",p_acc,"' ",
                        "   AND aaaacti IN ('Y','y') "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
            CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
            PREPARE p702_pre2 FROM l_sql
            DECLARE p702_cur2 CURSOR FOR p702_pre2
            OPEN p702_cur2
            FETCH p702_cur2 INTO g_cnt
            IF g_cnt=0 THEN
               CALL cl_err('sel aaa',100,0)
               NEXT FIELD p_acc
            END IF

         AFTER FIELD g_existno
            IF cl_null(g_existno) THEN
               NEXT FIELD g_existno
            END IF
            LET g_plant_new= p_plant  #工廠編號
            LET g_sql="SELECT aba00,aba02,aba03,aba04,aba19,abapost,abaacti ",
                      " FROM ",cl_get_target_table(g_plant_new,'aba_file'),
                      #" WHERE aba01 = ? AND aba00 = ? AND aba06='GL'"
                      " WHERE aba01 = ? AND aba00 = ? AND aba06='AR'"   #FUN-A80061
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
            PREPARE p702_t_p1 FROM g_sql
            DECLARE p702_t_c1 CURSOR FOR p702_t_p1
            IF STATUS THEN
               CALL cl_err('decl aba_cursor:',STATUS,0)
               NEXT FIELD g_existno
            END IF
            OPEN p702_t_c1 USING g_existno,g_ooz.ooz02b
            FETCH p702_t_c1 INTO l_aba00,gl_date,gl_yy,gl_mm,l_conf,l_abapost,
                                 l_abaacti 
            IF STATUS THEN
               CALL cl_err('sel aba:',STATUS,0)
               NEXT FIELD g_existno
            END IF
            IF l_abaacti = 'N' THEN
               CALL cl_err('','mfg8001',1)
               NEXT FIELD g_existno
            END IF
            #---增加判斷會計帳別之關帳日期
            LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_new,'aaa_file'),
                      " WHERE aaa01='",l_aba00,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
            PREPARE p702_x_gl_p1 FROM g_sql
            DECLARE p702_c_gl_p1 CURSOR FOR p702_x_gl_p1
            OPEN p702_c_gl_p1
            FETCH p702_c_gl_p1 INTO l_aaa07
            IF gl_date <= l_aaa07 THEN
               CALL cl_err(gl_date,'agl-200',0)
               NEXT FIELD g_existno
            END IF
            IF l_abapost = 'Y' THEN
               CALL cl_err(g_existno,'aap-130',0)
               NEXT FIELD g_existno
            END IF
            IF l_conf ='Y' THEN
               CALL cl_err(g_existno,'aap-026',0)
               NEXT FIELD g_existno
            END IF
         #FUN-B50090 add begin-------------------------
         #重新抓取關帳日期
            LET g_sql ="SELECT ooz09 FROM ooz_file ",
                       " WHERE ooz00 = '0'"
            PREPARE t600_ooz09_p FROM g_sql
            EXECUTE t600_ooz09_p INTO g_ooz.ooz09
         #FUN-B50090 add -end--------------------------
            IF gl_date < g_ooz.ooz09 THEN  
               CALL cl_err(gl_date,'aap-027',0)
               NEXT FIELD g_existno
            END IF
            IF g_aza.aza63 = 'Y' THEN                                                                                                  
               SELECT aba00,aba01 INTO p_acc1,g_existno1
                 FROM aba_file WHERE aba07=g_existno
               IF STATUS THEN                                                                                                          
                  CALL cl_err3("sel","aba_file","","",STATUS,"","",1)                                                               
                  NEXT FIELD g_existno
               END IF    
               LET g_ooz.ooz02c = p_acc1
               DISPLAY p_acc1 TO FORMONLY.p_acc1   
               DISPLAY g_existno1 TO FORMONLY.g_existno1                                                                                   
            END IF 

         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            LET l_flag='N'
            IF cl_null(p_plant)   THEN
               LET l_flag='Y'
            END IF
            IF cl_null(p_acc)     THEN
               LET l_flag='Y'
            END IF
            IF cl_null(g_existno) THEN
               LET l_flag='Y'
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD p_plant
            END IF
            LET g_plant_new= p_plant  # 工廠編號

         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about  
            CALL cl_about()  
 
         ON ACTION help     
            CALL cl_show_help() 
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         EXIT WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW p702 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "aglp702"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('aglp702','9031',1)
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",p_plant CLIPPED,"'",
                         " '",p_acc CLIPPED,"'",
                         " '",g_existno CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('aglp702',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p702
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION p702_t()
   DEFINE n1            LIKE type_file.num10 

   LET g_plant_new=p_plant
   IF g_aaz84 = '2' THEN   #還原方式為作廢 
      LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'aba_file'),
                " SET abaacti = 'N' ",
                " WHERE aba01 = ? AND aba00 = ? "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p702_updaba_p FROM g_sql
      EXECUTE p702_updaba_p USING g_existno,g_ooz.ooz02b
      IF SQLCA.sqlcode THEN
         CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      END IF
   ELSE
      IF g_bgjob = "N" THEN       
         MESSAGE   "Delete GL's Voucher body!" 
         CALL ui.Interface.refresh()
      END IF                    
      LET g_sql=" DELETE FROM ",cl_get_target_table(g_plant_new,'abb_file'),
                "  WHERE abb01=? AND abb00=?"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p702_2_p3 FROM g_sql
      EXECUTE p702_2_p3 USING g_existno,g_ooz.ooz02b
      IF SQLCA.sqlcode THEN
         CALL cl_err('(del abb)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      END IF
      IF g_bgjob = "N" THEN      
         MESSAGE   "Delete GL's Voucher head!" 
         CALL ui.Interface.refresh()
      END IF                      
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'aba_file'),
                " WHERE aba01=? AND aba00=?"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p702_2_p4 FROM g_sql
      EXECUTE p702_2_p4 USING g_existno,g_ooz.ooz02b
      IF SQLCA.sqlcode THEN
         CALL cl_err('(del aba)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('(del aba):0',SQLCA.SQLCODE,1) LET g_success = 'N' RETURN
      END IF
      IF g_bgjob = "N" THEN    
         MESSAGE   "Delete GL's Voucher desp!" 
         CALL ui.Interface.refresh()
      END IF 
#FUN-B40056 -begin
      LET g_sql=" DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'),
                "  WHERE tic04=? AND tic00=?"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p702_2_p9 FROM g_sql
      EXECUTE p702_2_p9 USING g_existno,g_ooz.ooz02b
      IF SQLCA.sqlcode THEN
         CALL cl_err('(del tic)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      END IF
#FUN-B40056 -end
   END IF                    
   IF g_bgjob = "N" THEN     
      MESSAGE   "Delete GL's Voucher detail!"
      CALL ui.Interface.refresh()
   END IF                        
   CALL s_abhmod(g_dbs_gl,g_ooz.ooz02b,g_existno)   
   IF g_success = 'N' THEN RETURN END IF
   LET g_msg = TIME
   INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)       #No.TQC-BB0048
          VALUES('aglp702',g_user,g_today,g_msg,g_existno,'delete',g_plant,g_legal)   #No.TQC-BB0048
   #UPDATE oct_file SET oct08=NULL WHERE oct08 = g_existno
   #UPDATE oct_file SET oct08=NULL WHERE oct08 = g_existno AND oct00 = '0'  #MOD-A80025 #FUN-AB0110 mark
    UPDATE oct_file SET oct08=NULL,oct22=NULL WHERE oct08 = g_existno AND oct00 = '0'  #FUN-AB0110
   LET n1 = SQLCA.SQLERRD[3]
   IF n1 <=0 THEN LET g_success='N' RETURN END IF 
END FUNCTION

FUNCTION p702_t_1()
   DEFINE n1            LIKE type_file.num10   

   LET g_plant_new=p_plant
   IF g_aaz84 = '2' THEN   #還原方式為作廢 
      LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'aba_file'),
                " SET abaacti = 'N' ",
                " WHERE aba01 = ? AND aba00 = ? "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p702_updaba_p1 FROM g_sql
      EXECUTE p702_updaba_p1 USING g_existno1,g_ooz.ooz02c
      IF SQLCA.sqlcode THEN
         CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      END IF
   ELSE
      IF g_bgjob = "N" THEN
         MESSAGE   "Delete GL's Voucher body!"  
         CALL ui.Interface.refresh()
      END IF                     
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abb_file'),
                " WHERE abb01=? AND abb00=?"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p702_2_p6 FROM g_sql
      EXECUTE p702_2_p6 USING g_existno1,g_ooz.ooz02c
      IF SQLCA.sqlcode THEN
         CALL cl_err('(del abb)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      END IF
      IF g_bgjob = "N" THEN
         MESSAGE   "Delete GL's Voucher head!"  
         CALL ui.Interface.refresh()
      END IF
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'aba_file'),
                " WHERE aba01=? AND aba00=?"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p702_2_p7 FROM g_sql
      EXECUTE p702_2_p7 USING g_existno1,g_ooz.ooz02c
      IF SQLCA.sqlcode THEN
         CALL cl_err('(del aba)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('(del aba):0',SQLCA.SQLCODE,1) LET g_success = 'N' RETURN
      END IF
      IF g_bgjob = "N" THEN
         MESSAGE   "Delete GL's Voucher desp!" 
         CALL ui.Interface.refresh()
      END IF       
#FUN-B40056  -begin
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'),
                " WHERE tic04=? AND tic00=?"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p702_2_p8 FROM g_sql
      EXECUTE p702_2_p8 USING g_existno1,g_ooz.ooz02c
      IF SQLCA.sqlcode THEN
         CALL cl_err('(del tic)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      END IF
#FUN-B40056  -end           
   END IF
   IF g_bgjob = "N" THEN
      MESSAGE   "Delete GL's Voucher detail!"  
      CALL ui.Interface.refresh()
   END IF
   IF g_success = 'N' THEN RETURN END IF
   LET g_msg = TIME
   INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)          #No.TQC-BB0048
          VALUES('aglp702',g_user,g_today,g_msg,g_existno1,'delete',g_plant,g_legal)     #No.TQC-BB0048
   #UPDATE oct_file SET oct081=NULL WHERE oct081=g_existno1
   #UPDATE oct_file SET oct08=NULL WHERE oct08=g_existno1  #FUN-A60007 mod
   #UPDATE oct_file SET oct08=NULL WHERE oct08=g_existno1 AND oct00 = '1'   #MOD-A80025 #FUN-AB0110 mark
    UPDATE oct_file SET oct08=NULL,oct22=NULL WHERE oct08=g_existno1 AND oct00 = '1' #FUN-AB0110
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","oct",g_existno1,"",SQLCA.sqlcode,"","(upd oct031)",1)
      LET g_success='N' RETURN
   END IF

END FUNCTION
#FUN-9B0017
