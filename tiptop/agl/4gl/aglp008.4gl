# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aglp008.4gl
# Descriptions...: 上报程序 (整批資料處理作業)
# Date & Author..: #FUN-B50001 11/05/05 by  zhangweib 
# Modify.........: No.TQC-B60373 11/06/30 By yinhy 錯誤碼'agl-246'改為'aap-129'
# Modify.........: No.TQC-B70142 11/07/19 By guoch g_dbs_a抓取時有誤
# Modify.........: No.FUN-B70062 11/07/26 By guoch 上层公司族群编号栏位开窗
# Modify.........: NO.MOD-BB0262 11/11/23 By xuxz 註釋中版本號修改
# Modify.........: No.MOD-C70171 12/07/17 By yinhy 增加開窗，會計年度、期別默認當前會計期間

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm      RECORD
                a  LIKE azp_file.azp01,   #集团公司营运中心
                b  LIKE axa_file.axa01,   #集团公司族群编号 
                c  LIKE aaw_file.aaw01,  #族群帐套
                h  LIKE axa_file.axa02,   #上传人所在公司编号
                d  LIKE type_file.num5,   #会计年度
                e  LIKE type_file.num5,   #期别
                f  LIKE gen_file.gen01,   #上传人编号     #暂时不用
                g  LIKE axa_file.axa01    #上传人族群编号  
               END RECORD,
       close_y,close_m LIKE type_file.num5,   #closing year & month
       l_yy,l_mm       LIKE type_file.num5,
       b_date          LIKE type_file.dat,    #期間起始日期
       e_date          LIKE type_file.dat,    #期間起始日期
       g_bookno        LIKE aea_file.aea00    #帳別
DEFINE ls_date         STRING,
       l_flag          LIKE type_file.chr1,
       g_change_lang   LIKE type_file.chr1
DEFINE g_dbs_a         LIKE azp_file.azp03    #集团营运中心对应DB
DEFINE g_sql           STRING                 
DEFINE g_aaw01         LIKE aaw_file.aaw01

MAIN

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_bookno = ARG_VAL(1)
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.a    = ARG_VAL(2)                   #集团公司营运中心
   LET tm.b    = ARG_VAL(3)                   #集团公司族群编号
   LET tm.c    = ARG_VAL(3)                   #族群帐套
   LET tm.d    = ARG_VAL(4)                   #会计年度
   LET tm.e    = ARG_VAL(5)                   #期别
   LET tm.f    = ARG_VAL(6)                   #上传人编号        #暂时不用
   LET tm.g    = ARG_VAL(7)                   #上传人族群编号    #暂时不用
   LET g_bgjob     = ARG_VAL(8)
   LET tm.h    = ARG_VAL(9)
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file
   END IF
   WHILE TRUE
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL aglp008_tm(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success = 'Y'
            BEGIN WORK
            CALL s_showmsg_init()
            CALL p008()
            CALL s_showmsg()     
            IF g_success='Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW aglp008_w
               EXIT WHILE
            END IF
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p008()
         CALL s_showmsg()
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END  IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION aglp008_tm(p_row,p_col)
   DEFINE  p_row,p_col     LIKE type_file.num5      
   DEFINE  lc_cmd          LIKE type_file.chr1000  
   DEFINE  l_cnt           LIKE type_file.num5
   DEFINE  l_azm02         LIKE azm_file.azm02

   CALL s_dsmark(g_bookno)

   LET p_row = 4 LET p_col = 26

   OPEN WINDOW aglp008_w AT p_row,p_col WITH FORM "agl/42f/aglp008" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
   CALL cl_set_comp_visible("f",FALSE)
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('q')
   WHILE TRUE 
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Defaealt condition

      SELECT azp03 INTO g_dbs_a FROM azp_file WHERE azp01 = tm.a
      CALL s_dbstring(g_dbs_a) RETURNING g_dbs_a

      LET g_bgjob = 'N'
      INPUT tm.a,tm.b,tm.c,tm.h,tm.d,tm.e,tm.f,tm.g,g_bgjob WITHOUT DEFAULTS  
       FROM a,b,c,h,d,e,f,g,g_bgjob     

         AFTER FIELD a    #集团营运中心
            IF cl_null(tm.a) THEN
               NEXT FIELD a
            ELSE
               SELECT azp01 FROM azp_file WHERE azp01 = tm.a 
               IF STATUS = 100 THEN
                  CALL cl_err(tm.a,'aap-025',0)
                  NEXT FIELD a
               END IF 
               
             #TQC-B70142 --begin
               LET g_dbs_a = tm.a
             #TQC-B70142 --end
               
               LET g_sql = "SELECT aaw01 FROM ",cl_get_target_table(g_dbs_a,'aaw_file')
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
               PREPARE sel_aaw01 FROM g_sql
               EXECUTE sel_aaw01 INTO tm.c
               IF cl_null(tm.c) THEN
                  CALL cl_err(tm.a,'agl-601',0)
                  NEXT FIELD b
               END IF
               DISPLAY tm.c TO FORMONLY.c
            END IF 

         AFTER FIELD b    #集团族群编号
            IF NOT cl_null(tm.b) THEN
               LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_dbs_a,'axa_file'), 
                           " WHERE axa01 = '",tm.b,"'" 
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
               PREPARE sel_axa01 FROM g_sql
               EXECUTE sel_axa01 INTO l_cnt
               IF l_cnt<1 THEN
                  #CALL cl_err(tm.b,'agl-246',0)  #No.TQC-B60373
                  CALL cl_err(tm.b,'aap-129',0)   #No.TQC-B60373
                  NEXT FIELD b
               END IF 
            #ELSE                                 #MOD-C70171
            #   NEXT FIELD b                      #MOD-C70171
            END IF


                         
         AFTER FIELD e    #期别
            IF NOT cl_null(tm.e) THEN
               SELECT azm02 INTO l_azm02 FROM azm_file
                WHERE azm01 = tm.d
               IF l_azm02 = 1 THEN
                  IF tm.e > 12 OR tm.e < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD e
                  END IF
               ELSE
                  IF tm.e > 13 OR tm.e < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD e 
                  END IF
               END IF
            ELSE
               NEXT FIELD e
            END IF

         AFTER FIELD g
            IF NOT cl_null(tm.g) THEN
               SELECT COUNT(*) INTO l_cnt FROM axa_file
                WHERE axa01 = tm.g
               IF l_cnt<1 THEN
                  #CALL cl_err(tm.g,'agl-246',0)   #No.TQC-B60373
                  CALL cl_err(tm.g,'aap-129',0)    #No.TQC-B60373
                  NEXT FIELD g
               END IF 
            ELSE
               NEXT FIELD g
            END IF 
            
         AFTER FIELD h
            IF NOT cl_null(tm.h) THEN
               LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_dbs_a,'axb_file'),
                           " WHERE axb01 = '",tm.b,"' AND axb04 = '",tm.h,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
               PREPARE sel_axb04_pre FROM g_sql
               DECLARE sel_axb04_cur CURSOR FOR sel_axb04_pre
               EXECUTE sel_axb04_cur INTO l_cnt
               IF l_cnt < 1 THEN
                  #CALL cl_err(tm.h,'agl-444',0)  #No.TQC-B60373
                  CALL cl_err(tm.h,'aap-129',0)   #No.TQC-B60373
                  NEXT FIELD h
               END IF 
            #ELSE                                 #MOD-C70171
            #   NEXT FIELD h                      #MOD-C70171
            END IF 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(a)   #集团公司营运中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_azp'
                   LET g_qryparam.default1 = tm.a
                   CALL cl_create_qry() RETURNING tm.a
                   DISPLAY BY NAME tm.a
                   NEXT FIELD a
              #FUN-B70062 --begin
               WHEN INFIELD(b)
                   CALL q_axa6(FALSE,TRUE,tm.b,g_dbs_a) RETURNING tm.b
                   DISPLAY BY NAME tm.b
                   NEXT FIELD b
              #FUN-B70062 --end
               #No.MOD-C70171  --Begin
               WHEN INFIELD(h)  
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_axb5'
                   LET g_qryparam.default1 = tm.h
                   LET g_qryparam.arg1 = tm.b
                   CALL cl_create_qry() RETURNING tm.h
                   DISPLAY BY NAME tm.h
               WHEN INFIELD(g) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_axa1'
                   LET g_qryparam.default1 = tm.g
                   CALL cl_create_qry() RETURNING tm.g
                   DISPLAY BY NAME tm.g
               #No.MOD-C70171  --End
               OTHERWISE EXIT CASE
            END CASE

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
   
         BEFORE INPUT
            CALL cl_qbe_init()
            #No.MOD-C70171  --Begin
            LET tm.d = g_sma.sma51
            LET tm.e = g_sma.sma52
            DISPLAY BY NAME tm.d
            DISPLAY BY NAME tm.e
            #No.MOD-C70171  --End

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_change_lang = TRUE
            EXIT INPUT

      END INPUT
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglp008_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'aglp008'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('aglp008','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",   
                         " '",tm.d CLIPPED,"'",  
                         " '",tm.e CLIPPED,"'",  
                         " '",tm.f CLIPPED,"'",
                         " '",tm.g CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('aglp008',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW aglp008_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION p008()
DEFINE l_axq    RECORD LIKE axq_file.*
DEFINE l_axh    RECORD LIKE axh_file.*
DEFINE l_axkk   RECORD LIKE axkk_file.*
DEFINE l_axa02  LIKE axa_file.axa02 
DEFINE l_axkk10 LIKE axkk_file.axkk10
DEFINE l_axkk11 LIKE axkk_file.axkk11
   CALL s_showmsg_init() 
   ### -->1.結轉前先刪除舊資料
   SELECT aaw01 INTO g_aaw01 FROM aaw_file   #下层公司帐别
   LET g_sql= "DELETE FROM ",cl_get_target_table(g_dbs_a,'axq_file'),
              " WHERE axq00 = '",tm.c,"'",    #族群帐别
              "   AND axq01 = '",tm.b,"'",    #族群编号
              "   AND axq06 = '",tm.d,"'",    #年度
              "   AND axq07 = '",tm.e,"'",    #期别
              "   AND axq04 = '",tm.h,"'",    #上层公司 编号
              "   AND axq041 = '",g_aaw01,"'" #下层合并帐别
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
   PREPARE del_axq FROM g_sql
   EXECUTE del_axq
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('del','axq',tm.c,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   SELECT axa02 INTO l_axa02 FROM axa_file WHERE axa01 = tm.g
      AND axa04 = 'Y'
   INITIALIZE l_axq.* TO NULL
   INITIALIZE l_axh.* TO NULL
   INITIALIZE l_axkk.* TO NULL

   ### -->2.開始抛砖资料
   DECLARE axh_cs CURSOR FOR 
       SELECT * FROM axh_file 
        WHERE axh00 = g_aaw01     #帐别 
          AND axh01 = tm.g         #族群编号
          AND axh02 = l_axa02      #上层公司
          AND axh06 = tm.d         #年度
          AND axh07 = tm.e         #期别

   FOREACH axh_cs INTO l_axh.*
      IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
      END IF                                                     

      IF SQLCA.sqlcode THEN
         LET g_showmsg=g_aaw01,"/",tm.g,"/",l_axa02,"/",tm.d,"/",tm.e
         CALL s_errmsg('axh00,axh01,axh02,axh06,axh07',g_showmsg,'(axh_cs1#1:foreach)',SQLCA.sqlcode,1)
         LET g_success='N' RETURN                             
      END IF
       
      LET l_axq.axq00 = tm.c
      LET l_axq.axq01 = tm.b 
      LET g_sql = "SELECT axa02 FROM ",cl_get_target_table(g_dbs_a,'axa_file'),
                  " WHERE axa01 = '",tm.b,"'",
                  "   AND axa04 = 'Y'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
      PREPARE sel_axa02_1 FROM g_sql
      EXECUTE sel_axa02_1 INTO l_axq.axq02
      LET l_axq.axq03 = tm.c 
      LET l_axq.axq04 = tm.h
      LET l_axq.axq041 =g_aaw01
      LET l_axq.axq05 = l_axh.axh05 
      SELECT aag02 INTO l_axq.axq051 FROM aag_file
       WHERE aag01 = l_axq.axq05 AND aag00 = g_aaw01
      LET l_axq.axq06 = tm.d
      LET l_axq.axq07 = tm.e

      LET l_axkk10 = 0
      LET l_axkk11 = 0
      SELECT SUM(axkk10),SUM(axkk11) INTO l_axkk10,l_axkk11 
        FROM axkk_file
       WHERE axkk00 = g_aaw01     #帐别
         AND axkk01 = tm.g         #族群编号
         AND axkk02 = l_axa02      #上层公司
         AND axkk08 = tm.d         #年度
         AND axkk09 = tm.e
         AND axkk05 = l_axh.axh05
         AND (axkk07 IS NOT NULL AND  axkk07 <> ' ')
      IF cl_null(l_axkk10) THEN LET l_axkk10 = 0 END IF 
      IF cl_null(l_axkk11) THEN LET l_axkk11 = 0 END IF 
      LET l_axq.axq08 = l_axh.axh08-l_axkk10
      LET l_axq.axq09 = l_axh.axh09-l_axkk11  
      LET l_axq.axq10 = l_axh.axh10
      LET l_axq.axq11 = l_axh.axh11
      LET l_axq.axq12 = l_axh.axh12
      LET l_axq.axq13 = ' '
      LET l_axq.axq14 = ' '
      LET l_axq.axq15 = ' '
      LET l_axq.axq16 = ' '
      LET l_axq.axq17 = ' '
      LET l_axq.axq18 = l_axh.axh14
      LET l_axq.axq19 = l_axh.axh15
      LET l_axq.axq20 = l_axh.axh16
      LET l_axq.axq21 = l_axh.axh17
      LET l_axq.axq22 = l_axh.axh18
      LET l_axq.axq23 = l_axh.axh19
      LET l_axq.axq24 = l_axh.axh20
      LET l_axq.axqconf = 'Y'
      LET l_axq.axqpost = 'N'
      LET l_axq.axqacti = 'Y'
      LET l_axq.axquser = g_user
      LET l_axq.axqgrup = g_grup
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_dbs_a,'axq_file'),
                  "     VALUES(?,?,?,?,?, ?,?,?,?,?,",
                  "            ?,?,?,?,?, ?,?,?,?,?,",
                  "            ?,?,?,?,?, ?,?,?,?,?,",
                  "            ?,?,?,?,?, ?,?)"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
      PREPARE insert_pre_1 FROM g_sql
      EXECUTE insert_pre_1 USING l_axq.*
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
         LET g_showmsg=tm.c,"/",tm.b,"/",l_axq.axq05,"/",l_axq.axq13
         CALL s_errmsg('axq00,axq01',g_showmsg,'ins_axq',SQLCA.sqlcode,1)
         LET g_success='N' 
      END IF
   END FOREACH
 
   INITIALIZE l_axq.* TO NULL
   DECLARE axkk_cs CURSOR FOR
       SELECT * FROM axkk_file
        WHERE axkk00 = g_aaw01     #帐别
          AND axkk01 = tm.g         #族群编号
          AND axkk02 = l_axa02      #上层公司
          AND axkk08 = tm.d         #年度
          AND axkk09 = tm.e         #期别

   FOREACH axkk_cs INTO l_axkk.*
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
      END IF

      IF SQLCA.sqlcode THEN
         LET g_showmsg=g_aaw01,"/",tm.g,"/",l_axa02,"/",tm.d,"/",tm.e
         CALL s_errmsg('axkk00,axkk01,axkk02,axkk08,axkk09',g_showmsg,'(axkk_cs1#1:foreach)',SQLCA.sqlcode,1)
         LET g_success='N' RETURN
      END IF

      #luttb--101213--add--str--
      IF cl_null(l_axkk.axkk07) THEN
         CONTINUE FOREACH
      END IF 
      #luttb--101213--add--end
      INITIALIZE l_axq.* TO NULL
      LET l_axq.axq00 = tm.c
      LET l_axq.axq01 = tm.b
      LET g_sql = "SELECT axa02 FROM ",cl_get_target_table(g_dbs_a,'axa_file'),
                  " WHERE axa01 = '",tm.b,"'",
                  "   AND axa04 = 'Y'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
      PREPARE sel_axa02_2 FROM g_sql
      EXECUTE sel_axa02_2 INTO l_axq.axq02
      LET l_axq.axq03 = tm.c
      LET l_axq.axq04 = tm.h
      LET l_axq.axq041 =g_aaw01
      LET l_axq.axq05 = l_axkk.axkk05
      SELECT aag02 INTO l_axq.axq051 FROM aag_file
       WHERE aag01 = l_axq.axq05 AND aag00 = g_aaw01
      LET l_axq.axq06 = tm.d
      LET l_axq.axq07 = tm.e
      LET l_axq.axq08 = l_axkk.axkk10
      LET l_axq.axq09 = l_axkk.axkk11
      LET l_axq.axq10 = l_axkk.axkk12
      LET l_axq.axq11 = l_axkk.axkk13
      LET l_axq.axq12 = l_axkk.axkk14
      LET l_axq.axq13 = l_axkk.axkk07
      LET l_axq.axq14 = ' '
      LET l_axq.axq15 = ' '
      LET l_axq.axq16 = ' '
      LET l_axq.axq17 = ' '
      LET l_axq.axq18 = l_axkk.axkk16
      LET l_axq.axq19 = l_axkk.axkk17
      LET l_axq.axq20 = l_axkk.axkk18
      LET l_axq.axq21 = l_axkk.axkk19
      LET l_axq.axq22 = l_axkk.axkk20
      LET l_axq.axq23 = l_axkk.axkk21
      LET l_axq.axq24 = l_axkk.axkk22
      LET l_axq.axqconf = 'Y'
      LET l_axq.axqpost = 'N'
      LET l_axq.axqacti = 'Y'
      LET l_axq.axquser = g_user
      LET l_axq.axqgrup = g_grup
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_dbs_a,'axq_file'),
                  "     VALUES(?,?,?,?,?, ?,?,?,?,?,",
                  "            ?,?,?,?,?, ?,?,?,?,?,",
                  "            ?,?,?,?,?, ?,?,?,?,?,",
                  "            ?,?,?,?,?, ?,?)"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_dbs_a) RETURNING g_sql
      PREPARE insert_pre_2 FROM g_sql
      EXECUTE insert_pre_2 USING l_axq.*
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg=tm.c,"/",tm.b,"/",l_axq.axq05,"/",l_axq.axq13
         CALL s_errmsg('axq00,axq01',g_showmsg,'ins_axq',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF
   END FOREACH


   IF g_totsuccess="N" THEN                                                        
      LET g_success="N"                                                           
   END IF                                                                          

END FUNCTION
#FUN-B50001
#MOD-BB0262
