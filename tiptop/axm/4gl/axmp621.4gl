# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axmp621.4gl
# Descriptions...: 下级出货回报整批处理作业 
# Date & Author..: 10/06/24 By shiwuying
# Memo...........: 
# ...............: 
# Modify.........:
# Modify.........: No:TQC-A50134 10/06/29 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No.FUN-A50102 10/09/29 By vealxu 跨db处理
# Modify.........: No.FUN-AA0059 10/10/25 By chenying 料號開窗控管 
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改	

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_xsh02       LIKE xsh_file.xsh02
DEFINE   g_xsh03       LIKE xsh_file.xsh03
DEFINE   g_xsh         DYNAMIC ARRAY OF RECORD
            sel        LIKE type_file.chr1,
            xsh99   LIKE xsh_file.xsh99,
            azp02      LIKE azp_file.azp02,
            xsh01      LIKE xsh_file.xsh01,
            xsh02      LIKE xsh_file.xsh02,
            xsh03      LIKE xsh_file.xsh03,
            xsh05      LIKE xsh_file.xsh05
                       END RECORD
DEFINE   g_xsh_t       RECORD
            sel        LIKE type_file.chr1,
            xsh99   LIKE xsh_file.xsh99,
            azp02      LIKE azp_file.azp02,
            xsh01      LIKE xsh_file.xsh01,
            xsh02      LIKE xsh_file.xsh02,
            xsh03      LIKE xsh_file.xsh03,
            xsh05      LIKE xsh_file.xsh05
                       END RECORD
DEFINE   g_xsi         DYNAMIC ARRAY OF RECORD
            xsi02      LIKE xsi_file.xsi02,
            xsi03      LIKE xsi_file.xsi03,
            ima02      LIKE ima_file.ima02,
            xsi04      LIKE xsi_file.xsi04,             
            xsi05      LIKE xsi_file.xsi05,
            xsi06      LIKE xsi_file.xsi06
                       END RECORD
DEFINE   g_xsi_con     RECORD LIKE xsi_file.*
DEFINE   g_wc          STRING
DEFINE   g_wc1         STRING
DEFINE   g_sql         STRING
DEFINE   g_action      STRING
DEFINE   g_forupd_sql  STRING 
DEFINE   g_rec_b       LIKE type_file.num5
DEFINE   g_rec_b1      LIKE type_file.num5
DEFINE   g_date_s      LIKE xsg_file.xsg02
DEFINE   g_date_e      LIKE xsg_file.xsg02
DEFINE   l_ac          LIKE type_file.num5
DEFINE   g_i           LIKE type_file.num5
DEFINE   g_cnt         LIKE type_file.num5
DEFINE   li_dbs        LIKE type_file.chr21

MAIN
   DEFINE   lwin_curr   ui.Window

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

   OPEN WINDOW p621_w WITH FORM "axm/42f/axmp621"
      ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_init()
   LET g_date_s=null   
   LET g_date_e=null   
   CALL p621_dialog()
   
   CLOSE WINDOW p621_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p621_dialog()
 DEFINE   l_i     LIKE type_file.num5

   CALL p621_cs()
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_xsh TO s_xsh.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE ROW
            LET l_ac = ARR_CURR()
            IF l_ac != 0 THEN
               CALL p621_b1_fill(g_wc1,g_xsh[l_ac].xsh01)
            END IF
      END DISPLAY

      DISPLAY ARRAY g_xsi TO s_xsi.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE ROW
            LET l_ac = ARR_CURR()
      END DISPLAY

      ON ACTION query
         CALL p621_cs()
        #CALL p621_b_fill(g_wc)
        #IF g_xsh.getLength() <= 0 THEN
        #   CALL cl_err("","ain-070",0)
        #END IF
        #IF l_ac > 0 THEN
        #   CALL p621_b1_fill(g_wc1,g_xsh[l_ac].xsh01)
        #END IF

      ON ACTION detail
         IF g_rec_b > 0 THEN
            CALL p621_b()
         END IF

     #ON ACTION accept
     #   IF g_rec_b > 0 THEN
     #      CALL p621_b()
     #   END IF

      ON ACTION sel_all
         IF g_rec_b > 0 THEN
            FOR l_i = 1 TO g_xsh.getLength()
               LET g_xsh[l_i].sel = 'Y'
               DISPLAY BY NAME g_xsh[l_i].sel
            END FOR
         END IF

      ON ACTION sel_none
         IF g_rec_b > 0 THEN
            FOR l_i = 1 TO g_xsh.getLength()
               LET g_xsh[l_i].sel = 'N'
               DISPLAY BY NAME g_xsh[l_i].sel
            END FOR
         END IF

      ON ACTION confirm
         CALL p621_y()

      ON ACTION from_excel
         CALL p621_from_excel()
         IF l_ac > 0 THEN
            CALL p621_b1_fill(" 1=1",g_xsh[l_ac].xsh01)
         END IF
                           
      ON ACTION close
         LET g_action = "exit"
         EXIT DIALOG
   END DIALOG
END FUNCTION

FUNCTION p621_b()
 DEFINE   l_i     LIKE type_file.num5

   INPUT ARRAY g_xsh FROM s_xsh.*
      ATTRIBUTES(WITHOUT DEFAULTS=TRUE,
           COUNT=g_xsh.getLength(),MAXCOUNT=g_xsh.getLength(),
           APPEND ROW=FALSE,INSERT ROW=FALSE,DELETE ROW=FALSE)
      BEFORE ROW
         LET l_ac = ARR_CURR()

      ON ACTION sel_all
         IF g_rec_b > 0 THEN
            FOR l_i = 1 TO g_xsh.getLength()
                LET g_xsh[l_i].sel = 'Y'
                DISPLAY BY NAME g_xsh[l_i].sel
            END FOR
            CALL p621_b_ref()
         END IF

      ON ACTION sel_none
         IF g_rec_b > 0 THEN
            FOR l_i = 1 TO g_xsh.getLength()
                LET g_xsh[l_i].sel = 'N'
                DISPLAY BY NAME g_xsh[l_i].sel
            END FOR
            CALL p621_b_ref()
         END IF
   END INPUT
END FUNCTION

FUNCTION p621_b_ref()

   DISPLAY ARRAY g_xsh TO s_xsh.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE ROW
         EXIT DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION p621_cs()
   CALL g_xsh.clear()
   CALL g_xsi.clear()
   LET g_rec_b = 0
   LET g_rec_b1= 0
   CLEAR FORM
   DIALOG ATTRIBUTES(UNBUFFERED)
        
      CONSTRUCT g_wc ON xsh99,xsh01,xsh02,xsh03,xsh05
                   FROM s_xsh[1].xsh99,s_xsh[1].xsh01,s_xsh[1].xsh02,
                        s_xsh[1].xsh03,   s_xsh[1].xsh05
                        
          ON ACTION controlp
             CASE
                WHEN INFIELD(xsh99)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_xsh99_1"
                   LET g_qryparam.where = "axw01 IN ",g_auth
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO xsh99
                   NEXT FIELD xsh99
             END CASE
      END CONSTRUCT

      CONSTRUCT g_wc1 ON xsi02,xsi03,xsi04,xsi05,xsi06
                    FROM s_xsi[1].xsi02,s_xsi[1].xsi03,s_xsi[1].xsi04,
                         s_xsi[1].xsi05,s_xsi[1].xsi06

          ON ACTION controlp
             CASE
                WHEN INFIELD(xsi03)
#FUN-AA0059---------mod------------str-----------------                
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_xsi03_1"
#                   LET g_qryparam.state = "c"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima(TRUE, "q_xsi03_1","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                   DISPLAY g_qryparam.multiret TO xsi03
                   NEXT FIELD xsi03
             END CASE
      END CONSTRUCT

      ON ACTION accept
         CALL p621_b_fill(g_wc)
         IF g_xsh.getLength() <= 0 THEN
            CALL cl_err("","ain-070",0)
         END IF
         IF l_ac > 0 THEN
            CALL p621_b1_fill(g_wc1,g_xsh[l_ac].xsh01)
         END IF
         EXIT DIALOG

      ON ACTION cancel
         EXIT DIALOG

      ON ACTION close
         LET g_action = "exit"
         EXIT DIALOG
   END DIALOG
END FUNCTION

FUNCTION p621_xsh02(p_wc)
 DEFINE p_wc       STRING
 DEFINE l_wc       STRING
 DEFINE l_i        LIKE type_file.num5
 DEFINE l_len      LIKE type_file.num5

   LET l_len = p_wc.getLength()
   IF p_wc.getIndexOf("xsh02",1) THEN
      LET l_i = p_wc.getIndexOf("=",p_wc.getIndexOf("xsh02",1))
      LET l_wc = p_wc.subString(1,l_i-1),">",p_wc.subString(l_i,l_len)
   ELSE
      LET l_wc = g_wc
   END IF
   
   IF l_wc.getIndexOf("xsh03",1) THEN
      LET l_i = l_wc.getIndexOf("=",l_wc.getIndexOf("xsh03",1))
      LET l_wc = l_wc.subString(1,l_i-1),"<",l_wc.subString(l_i,l_wc.getLength())
   END IF
   RETURN l_wc
END FUNCTION

FUNCTION p621_b_fill(p_wc)
 DEFINE   p_wc     STRING
 DEFINE   l_cnt    LIKE type_file.num5
 DEFINE   l_azw01  LIKE azw_file.azw01

   IF cl_null(p_wc) THEN 
      LET p_wc=" 1=1"
   ELSE
      CALL p621_xsh02(p_wc) RETURNING p_wc  #处理日期,在日期范围内,非等于
   END IF
   SELECT azw01 INTO l_azw01 FROM azw_file WHERE azw07=g_plant
   LET g_plant_new = l_azw01
   CALL s_gettrandbs()
   LET g_dbs=g_dbs_tra
   LET g_dbs = s_dbstring(g_dbs)
   LET g_sql = "SELECT 'N',xsh99,'',xsh01,xsh02,xsh03,xsh05 ", 
             # "  FROM ",g_dbs CLIPPED,"xsh_file",                    #FUN-A50102 mark
               "  FROM ",cl_get_target_table(g_plant_new,'xsh_file'), #FUN-A50102  
               " WHERE ",p_wc CLIPPED,
               "   AND xsh99 IN ",g_auth
  #CASE         
  #   WHEN NOT cl_null(g_date_s) AND NOT cl_null(g_date_e)
  #      LET g_sql = g_sql," AND xsh02 >= '",g_date_s,"' AND xsh03<= '",g_date_e,"' "
  #   WHEN cl_null(g_date_s) AND NOT cl_null(g_date_e)
  #      LET g_sql = g_sql," AND xsh03 <= '",g_date_e,"'"
  #   WHEN NOT cl_null(g_date_s) AND cl_null(g_date_e)
  #      LET g_sql = g_sql," AND xsh02 >= '",g_date_s,"'"
  #END CASE
   LET g_sql=g_sql," ORDER BY xsh99 "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102 
   PREPARE xsh_pre FROM g_sql
   DECLARE xsh_curs CURSOR FOR xsh_pre

   CALL g_xsh.clear()
   LET l_cnt = 1

   FOREACH xsh_curs INTO g_xsh[l_cnt].*
      SELECT azp02 INTO g_xsh[l_cnt].azp02 FROM azp_file
       WHERE azp01=g_xsh[l_cnt].xsh99
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL g_xsh.deleteElement(l_cnt)
   LET g_rec_b = l_cnt - 1
END FUNCTION

FUNCTION p621_b1_fill(p_wc,p_xsh01)
 DEFINE   p_wc     STRING
 DEFINE   l_cnt    LIKE type_file.num5
 DEFINE   l_azw01  LIKE azw_file.azw01
 DEFINE   p_xsh01  LIKE xsh_file.xsh01

   IF cl_null(p_wc) THEN
      LET p_wc=" 1=1"
   END IF
   IF cl_null(l_ac) OR l_ac = 0 THEN LET l_ac = 1 END IF
   SELECT azw01 INTO l_azw01 FROM azw_file WHERE azw07=g_plant
   LET g_plant_new = g_xsh[l_ac].xsh99
   CALL s_gettrandbs()
   LET g_dbs=g_dbs_tra
   LET g_dbs = s_dbstring(g_dbs)
   LET g_sql = "SELECT xsi02,xsi03,'',xsi04,xsi05,xsi06 ",
             # "  FROM ",g_dbs CLIPPED,"xsi_file",                     #FUN-A50102 mark
               "  FROM ",cl_get_target_table(g_plant_new,'xsi_file'),  #FUN-A50102 
               " WHERE xsi01='",p_xsh01,"'",
               "   AND ",p_wc
   LET g_sql=g_sql," ORDER BY xsi02 "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102 
   PREPARE xsi_pre FROM g_sql
   DECLARE xsi_curs CURSOR FOR xsi_pre
               
   CALL g_xsi.clear()
   LET l_cnt = 1
         
   FOREACH xsi_curs INTO g_xsi[l_cnt].*
      SELECT ima02 INTO g_xsi[l_cnt].ima02 FROM ima_file
       WHERE ima01=g_xsi[l_cnt].xsi03
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL g_xsi.deleteElement(l_cnt)
   LET g_rec_b1 = l_cnt - 1
END FUNCTION

FUNCTION p621_y()
DEFINE   l_n        LIKE type_file.num5
DEFINE   l_cnt      LIKE type_file.num5
DEFINE   l_xsi      RECORD LIKE xsi_file.*
DEFINE   l_ima36    LIKE ima_file.ima36
DEFINE   l_factor   LIKE ima_file.ima31_fac
DEFINE   l_str      STRING
DEFINE   l_img      RECORD LIKE img_file.*
DEFINE   l_azw02    LIKE azw_file.azw02

   IF g_rec_b = 0 THEN
      CALL cl_err("","-400",1)
      RETURN
   END IF

   LET l_cnt = 0
   FOR g_i = 1 TO g_rec_b
       IF g_xsh[g_i].sel = 'Y' THEN
          LET l_cnt = l_cnt + 1
          EXIT FOR
       END IF
   END FOR
   IF l_cnt = 0 THEN
      CALL cl_err("","-400",1)
      RETURN
   END IF

   BEGIN WORK 
   LET g_success = 'Y'
   CALL s_showmsg_init()
   
   FOR g_i = 1 TO g_rec_b
       IF g_xsh[g_i].sel <> 'Y' THEN CONTINUE FOR END IF
       IF g_xsh[g_i].xsh05= '1' THEN CONTINUE FOR END IF

       LET g_plant_new = g_xsh[g_i].xsh99
       CALL s_gettrandbs() 
       LET g_dbs=g_dbs_tra 
       LET g_dbs = s_dbstring(g_dbs)

       #Cehck 單身 料倉儲批是否存在 img_file中
     # LET g_sql = " SELECT * FROM ",g_dbs CLIPPED,"xsi_file ",                      #FUN-A50102 mark
       LET g_sql = " SELECT * FROM ",cl_get_target_table(g_plant_new,'xsi_file'),    #FUN-A50102 
                   "  WHERE xsi01 = '",g_xsh[g_i].xsh01,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102
       PREPARE p621_chk_xsi_p FROM g_sql
       DECLARE p621_chk_xsi CURSOR FOR p621_chk_xsi_p
       FOREACH p621_chk_xsi INTO l_xsi.*
          LET l_cnt=0
        # LET g_sql = "SELECT COUNT(*) FROM ",g_dbs CLIPPED,"img_file",                      #FUN-A50102 mark
          LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'img_file'),   #FUN-A50102
                      " WHERE img01='",l_xsi.xsi03,"'",
                      "   AND img02='",g_xsh[g_i].xsh99,"'"
                     #"   AND imgplant='",g_xsh[g_i].xsh99,"'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
          PREPARE p621_sel_img FROM g_sql
          EXECUTE p621_sel_img INTO l_cnt
          IF l_cnt=0 THEN
             INITIALIZE l_img.* TO NULL
             LET l_img.img01 = l_xsi.xsi03
             LET l_img.img02 = g_xsh[g_i].xsh99
             LET l_img.img03 =' '
             LET l_img.img04 =' '
             LET l_img.img10 = 0
             LET l_img.img21 = 1
             LET l_img.imgplant=g_xsh[g_i].xsh99
             SELECT azw02 INTO l_azw02 FROM azw_file WHERE azw01 = g_xsh[g_i].xsh99
           # LET g_sql = "INSERT INTO ",g_dbs CLIPPED,"img_file(img01,img02,img03,img04,img10,img21,imgplant,imglegal)",            #FUN-A50102 mark
             LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'img_file'),"(img01,img02,img03,img04,img10,img21,imgplant,imglegal)",   #FUN-A50102
                         " VALUES(?,?,?,?,?,?,?,?)"
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
             CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
             PREPARE p621_ins_img FROM g_sql
             EXECUTE p621_ins_img USING l_img.img01,l_img.img02,l_img.img03,l_img.img04,l_img.img10,
                                        l_img.img21,l_img.imgplant,l_azw02
             IF SQLCA.sqlcode<>0 OR sqlca.sqlerrd[3]=0 THEN
               # CALL cl_err('ins img:',SQLCA.sqlcode,1)
                CALL s_errmsg('xsi02',g_xsh[g_i].xsh01,'ins img_file',SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOR
             END IF 
          END IF
       END FOREACH

     # LET g_sql = " SELECT * FROM ",g_dbs CLIPPED,"xsi_file ",                    #FUN-A50102 mark
       LET g_sql = " SELECT * FROM ",cl_get_target_table(g_plant_new,'xsi_file'),  #FUN-A50102 
                   "  WHERE xsi01='",g_xsh[g_i].xsh01,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
       CALL cl_parse_qry_Sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
       PREPARE p621_sel_xsi_p2 FROM g_sql
       DECLARE p621_con CURSOR FOR p621_sel_xsi_p2
       FOREACH p621_con INTO g_xsi_con.*
          IF STATUS THEN 
             LET g_success='N'
             CALL cl_err('','axm-342',0)
             EXIT FOREACH
          END IF
        # LET g_sql = " SELECT ima31_fac FROM ",g_dbs CLIPPED,"ima_file ",                   #FUN-A50102 mark
          LET g_sql = " SELECT ima31_fac FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102 
                      " WHERE ima01='",g_xsi_con.xsi03,"'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102 
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql    #FUN-A50102
          PREPARE p621_sel_ima FROM g_sql
          EXECUTE p621_sel_ima INTO l_factor
          CALL p621_update(g_xsh[g_i].xsh99,l_ima36,'',g_xsi_con.xsi04,g_xsi_con.xsi05,l_factor)
       END FOREACH
       IF g_success='Y' THEN
        # LET g_sql = " UPDATE ",g_dbs CLIPPED,"xsh_file SET xsh05='1'",                      #FUN-A50102 mark
          LET g_sql = " UPDATE ",cl_get_target_table(g_plant_new,'xsh_file')," SET xsh05='1'",#FUN-A50102 
                      " WHERE xsh01='",g_xsh[g_i].xsh01,"'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
          PREPARE p621_upd_xsh FROM g_sql
          EXECUTE p621_upd_xsh
          IF SQLCA.sqlcode THEN
            # CALL cl_err("","mfg0073",0)
             CALL s_errmsg('xsh01',g_xsh[g_i].xsh01,'upd xsh',SQLCA.sqlcode,1)
             LET g_success = 'N'
          END IF
       END IF
   END FOR
   CALL s_showmsg()
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_err("","axm-344",0)
      FOR g_i = 1 TO g_rec_b
          IF g_xsh[g_i].sel = 'Y' THEN
             LET g_xsh[g_i].xsh05 = '1'
             DISPLAY BY NAME g_xsh[g_i].xsh05
          END IF
      END FOR
   ELSE
      ROLLBACK WORK
      CALL cl_err("","axm-343",0)#數據庫操作失敗,審核失敗
   END IF
END FUNCTION 

FUNCTION p621_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor)
  DEFINE p_ware     LIKE img_file.img02,   #倉庫   
         p_loca     LIKE img_file.img03,   #儲位   
         p_lot      LIKE img_file.img04,   #批號
         p_qty      LIKE tlf_file.tlf10,   #數量        
         p_uom      LIKE img_file.img09,   ##img 單位   
         p_factor   LIKE ima_file.ima31_fac,   #轉換率  
         u_type     LIKE type_file.num5,       # +1:雜收 -1:雜發   
         l_qty      LIKE img_file.img10,   
         l_imaqty   LIKE ima_file.ima262,
         l_imafac   LIKE img_file.img21,
         l_ima25    LIKE ima_file.ima25,
         l_cnt      LIKE type_file.num5,
         l_img      RECORD
           img10    LIKE img_file.img10,
           img16    LIKE img_file.img16,
           img23    LIKE img_file.img23,
           img24    LIKE img_file.img24,
           img09    LIKE img_file.img09,
           img21    LIKE img_file.img21
                   END RECORD
   DEFINE l_msg     STRING 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot =' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty =0   END IF
 
    LET g_forupd_sql =
      # "SELECT img10,img16,img23,img24,img09,img21 FROM ",g_dbs CLIPPED,"img_file ",       #FUN-A50102 mark
        "SELECT img10,img16,img23,img24,img09,img21 FROM ",cl_get_target_table(g_plant_new,'img_file'),  #FUN-A50102 
        " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)   #FUN-B80089
    CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql              #FUN-A50102
    CALL cl_parse_qry_sql(g_forupd_sql,g_plant_new) RETURNING g_forupd_sql  #FUN-A50102
   # LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)   #FUN-B80089
    DECLARE img_lock CURSOR FROM g_forupd_sql
 
    OPEN img_lock USING g_xsi_con.xsi03,p_ware,p_loca,p_lot 
    IF STATUS THEN
    #  CALL cl_err("img_file",SQLCA.sqlcode,1)
       CALL s_errmsg('xsi03',g_xsi_con.xsi03,'img_lock',STATUS,1)
       LET g_success='N'
       CLOSE img_lock
       RETURN
    END IF
    FETCH img_lock INTO l_img.*
    IF STATUS THEN
    #  CALL cl_err('img_file',STATUS,1)
       CALL s_errmsg('xsi03',g_xsi_con.xsi03,'img_lock',STATUS,1)
       LET g_success='N'
       CLOSE img_lock
       RETURN
    END IF
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
    
     LET u_type=-1
     LET l_qty= l_img.img10 - p_qty 
    CALL s_upimg1(g_xsi_con.xsi03,p_ware,p_loca,p_lot,u_type,p_qty*p_factor,g_today,
          '','','','',g_xsi_con.xsi01,g_xsi_con.xsi02,
          '','','','','','','','','','','','',g_xsh[g_i].xsh99)
    IF g_success='N' THEN
       RETURN
    END IF
         
    LET g_forupd_sql =
      # "SELECT ima25 FROM ",g_dbs CLIPPED,"ima_file WHERE ima01= ? FOR UPDATE "         #FUN-A50102 mark
        "SELECT ima25 FROM ",cl_get_target_table(g_plant_new,'ima_file')," WHERE ima01= ? FOR UPDATE "         #FUN-A50102
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)   #FUN-B80089
    CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql                #FUN-A50102
    CALL cl_parse_qry_sql(g_forupd_sql,g_plant_new) RETURNING g_forupd_sql     #FUN-A50102
    #LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)       #FUN-B80089
    DECLARE ima_lock CURSOR FROM g_forupd_sql

    OPEN ima_lock USING g_xsi_con.xsi03 
    IF STATUS THEN
    #  CALL cl_err("ima_file",STATUS,1)
       CALL s_errmsg('xsi03',g_xsi_con.xsi03,'ima_lock',STATUS,1)
       LET g_success = 'N'
       CLOSE ima_lock
       RETURN
    END IF

    FETCH ima_lock INTO l_ima25  
    IF STATUS THEN
    #  CALL cl_err('ima_file',STATUS,1)
       CALL s_errmsg('xsi03',g_xsi_con.xsi03,'ima_lock',STATUS,1)
       LET g_success = 'N'
       CLOSE ima_lock
       RETURN
    END IF

    IF p_uom=l_ima25 THEN
       LET l_imafac = 1
    ELSE
       CALL s_umfchk(g_xsi_con.xsi03,p_uom,l_ima25)
                RETURNING g_cnt,l_imafac
    ##----單位換算率抓不到--------###
       IF g_cnt = 1 THEN
       #  CALL cl_err('','aic-052',1)
          CALL s_errmsg('xsi03',g_xsi_con.xsi03,'imafac','aic-052',1)
          LET g_success ='N'
       END IF
    END IF

    IF cl_null(l_imafac) THEN
       LET l_imafac = 1
    END IF
    LET l_imaqty = p_qty * l_imafac
    CALL s_udima(g_xsi_con.xsi03,l_img.img23,l_img.img24,l_imaqty,
                    '',u_type)  RETURNING l_cnt
    IF g_success='N' THEN
       RETURN
    END IF
#--------------------------- insert tlf_file----------------                
    IF g_success='Y' THEN
       CALL p621_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,
                     u_type)
    END IF
   #LET l_msg = "seq#",g_xsi_con.xsi03,' audit ok!'
   #CALL cl_msg(l_msg)
END FUNCTION

FUNCTION p621_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                     u_type)
   DEFINE
      p_ware   LIKE img_file.img02,  #倉庫               
      p_loca   LIKE img_file.img03,  #儲位               
      p_lot    LIKE img_file.img04,  #批號               
      p_qty    LIKE tlf_file.tlf10,
      p_uom    LIKE img_file.img09,       ##img 單位   
      p_factor LIKE ima_file.ima31_fac,   ##轉換率  )
      p_unit   LIKE ima_file.ima25,       ##單位
      p_img10  LIKE img_file.img10,       #異動後數量
      u_type   LIKE type_file.num5  	  # +1:雜收 -1:雜發           
 
   INITIALIZE g_tlf.* TO NULL
   LET g_tlf.tlf01=g_xsi_con.xsi03         #異動料件編號xsk03
#   IF u_type=+1  THEN ###收料
## ----------來源----
#      LET g_tlf.tlf02=90
##------------目的----
#      LET g_tlf.tlf03=50                  #'Stock'
#      LET g_tlf.tlf030=g_plant
#      LET g_tlf.tlf031=p_ware             #倉庫
#      LET g_tlf.tlf032=p_loca             #儲位
#      LET g_tlf.tlf033=p_lot              #批號
#      LET g_tlf.tlf034=p_img10            #異動後數量
#      LET g_tlf.tlf035=p_unit             #庫存單位(ima_file or img_file)
#      LET g_tlf.tlf036=g_xsi_con.xsi01    #雜收單號
#      LET g_tlf.tlf037=g_xsi_con.xsi02    #雜收項次
#   END IF
   IF u_type=-1 THEN ###發料
#----------來源----
      LET g_tlf.tlf02=50                  #'Stock'
      LET g_tlf.tlf020=g_xsh[g_i].xsh99
      LET g_tlf.tlf021=p_ware             #倉庫
      LET g_tlf.tlf022=p_loca             #儲位
      LET g_tlf.tlf023=p_lot              #批號
      LET g_tlf.tlf024=p_img10            #異動後數量
      LET g_tlf.tlf025=p_unit             #庫存單位(ima_file or img_file)
      LET g_tlf.tlf026=g_xsi_con.xsi01    #雜發單號
      LET g_tlf.tlf027=g_xsi_con.xsi02    #雜發項次
#-----------目的----
      IF u_type=-1 
         THEN LET g_tlf.tlf03=90
         ELSE LET g_tlf.tlf03=40
      END IF
   END IF
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=g_xsh[g_i].xsh02      
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=p_qty            #異動數量
   LET g_tlf.tlf11=p_uom	          #單位
   LET g_tlf.tlf12 =p_factor        #發料/庫存 換算率
   LET g_tlf.tlf13 ='wagt012'
   CALL s_tlf1(1,0,g_xsh[g_i].xsh99)
END FUNCTION

FUNCTION p621_from_excel()
   DEFINE   lr_data         DYNAMIC ARRAY OF RECORD
            data01,data02,data03,data04,data05,data06,data07
                            LIKE type_file.chr50 #STRING
                            END RECORD
   DEFINE   lr_data_tmp     DYNAMIC ARRAY OF RECORD
            data01,data02,data03,data04,data05,data06,data07
                            LIKE type_file.chr50 #STRING
                            END RECORD
   DEFINE   ls_doc_path     STRING
   DEFINE   ls_file_name    STRING
   DEFINE   ls_file_path    STRING
   DEFINE   li_result       LIKE type_file.num5
   DEFINE   li_cnt          LIKE type_file.num5
   DEFINE   ls_fields       STRING
   DEFINE   ls_exe_sql      STRING
   DEFINE   li_i            LIKE type_file.num5
   DEFINE   li_j            LIKE type_file.num5
   DEFINE   li_k            LIKE type_file.num5
   DEFINE   ls_cell         STRING
   DEFINE   ls_cell2        STRING
   DEFINE   ls_cell_r       STRING
   DEFINE   ls_cell_c       STRING
   DEFINE   ls_cell_r2      STRING
   DEFINE   ls_cell_c2      STRING
   DEFINE   li_data_stat    LIKE type_file.num5
   DEFINE   li_data_end     LIKE type_file.num5
   DEFINE   li_col_idx      LIKE type_file.num5
   DEFINE   ls_value        STRING
   DEFINE   lr_err          DYNAMIC ARRAY OF RECORD
               line         STRING,
               key1         STRING,
               err          STRING,
               cmd          STRING
                            END RECORD
   DEFINE   lr_loc          DYNAMIC ARRAY OF RECORD
               loc1         LIKE type_file.chr10,
               loc2         LIKE type_file.chr10
                            END RECORD
   DEFINE   l_flag          LIKE type_file.chr1
   DEFINE   l_xsh01         LIKE xsh_file.xsh01
   DEFINE   l_xsh04         LIKE xsh_file.xsh04
   DEFINE   l_xsh05         LIKE xsh_file.xsh05
   DEFINE   l_xsi02         LIKE xsi_file.xsi02
   DEFINE   l_xsh99         LIKE xsh_file.xsh99
   DEFINE   ls_max_no       LIKE type_file.chr10
   DEFINE   ls_chr          LIKE type_file.chr10
   DEFINE   ls_date         LIKE type_file.chr10
   DEFINE   ls_col_cnt      LIKE type_file.num5
   DEFINE   ls_col_cnt1     LIKE type_file.num5
   DEFINE   l_str           STRING
   DEFINE   l_str1          STRING
   DEFINE   l_date1,l_date2 LIKE type_file.dat
   DEFINE   l_azp02         LIKE azp_file.azp02
   DEFINE   l_imafac        LIKE img_file.img21
   DEFINE   l_ima25         LIKE ima_file.ima25
 
   CLEAR FORM
   CALL g_xsh.clear()
   CALL g_xsi.clear()
   LET g_rec_b = 0
   LET g_rec_b1= 0

   #開窗選擇檔案
   OPEN WINDOW axmp6211_w WITH FORM "axm/42f/axmp6211" 
   CALL cl_ui_locale("axmp6211")
   
   INPUT ls_doc_path,ls_col_cnt,ls_col_cnt1 WITHOUT DEFAULTS
    FROM FORMONLY.doc_path,FORMONLY.col_cnt,FORMONLY.col_cnt1
      BEFORE INPUT
         LET ls_col_cnt = 1
         LET ls_col_cnt1= 1
         DISPLAY ls_col_cnt,ls_col_cnt1 TO col_cnt,col_cnt1
      AFTER FIELD col_cnt
         IF NOT cl_null(ls_col_cnt) THEN
            IF ls_col_cnt < 0 OR ls_col_cnt > 10000 THEN
               NEXT FIELD col_cnt
            END IF
         END IF
      AFTER FIELD col_cnt1
         IF NOT cl_null(ls_col_cnt1) THEN
            IF ls_col_cnt1 < 0 OR ls_col_cnt1 > 10000 THEN
               NEXT FIELD col_cnt
            END IF
         END IF
      AFTER INPUT 
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF ls_doc_path IS NULL OR cl_null(ls_col_cnt) OR cl_null(ls_col_cnt) THEN
            NEXT FIELD doc_path
         END IF
      ON ACTION open_file
         CALL cl_browse_file() RETURNING ls_doc_path
         DISPLAY ls_doc_path TO FORMONLY.doc_path
      ON ACTION exit
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      CLOSE WINDOW axmp6211_w
      RETURN
   END IF
 
   IF ls_doc_path IS NULL OR cl_null(ls_col_cnt) OR cl_null(ls_col_cnt) THEN
      CLOSE WINDOW axmp6211_w
      RETURN
   ELSE
      LET ls_file_path = ls_doc_path  #完整路径
      LET ls_file_name = ls_doc_path  #文件名
      WHILE TRUE
         IF ls_file_name.getIndexOf("/",1) THEN #取文件名,去除路径
            LET ls_file_name = ls_file_name.subString(ls_file_name.getIndexOf("/",1) + 1,ls_file_name.getLength())
         ELSE
            EXIT WHILE
         END IF
      END WHILE
      DISPLAY 'ls_file_path = ',ls_file_path
   END IF
 
   CALL ui.Interface.frontCall("standard","shellexec",[ls_file_path] ,li_result)
   CALL p621_checkError(li_result,"Open File")
 
   CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL",ls_file_name],[li_result])
   CALL p621_checkError(li_result,"Connect File")
 
   CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL","Sheet1"],[li_result])
   CALL p621_checkError(li_result,"Connect Sheet1")
 
   MESSAGE ls_file_name," File Analyze..."
 
   FOR li_i = 1 TO 7  #取excel中每个栏位的开始位置和结束位置
       LET l_str = li_i
       LET l_str1 = ls_col_cnt
       LET lr_loc[li_i].loc1 = "R",l_str1.trim(),"C",l_str.trim()
       LET l_str1 = ls_col_cnt1
       LET lr_loc[li_i].loc2 = "R",l_str1.trim(),"C",l_str.trim()
   END FOR
 
   #準備解Excel內的資料
   #第一階段搜尋
   LET li_col_idx = 1
   FOR li_i = 1 TO 7   #1->excel中的栏位数
      #直接默认取列，直向
      #R1C1  第一行第一列
      #R10C1 第十行第一列
      LET ls_cell = lr_loc[li_i].loc1
      LET ls_cell_c = ls_cell.subString(ls_cell.getIndexOf("C",1),ls_cell.getLength())
      LET ls_cell_r = ls_cell.subString(ls_cell.getIndexOf("R",1)+1,ls_cell.getIndexOf("C",1)-1)
      LET li_data_stat = ls_cell_r
      LET ls_cell = lr_loc[li_i].loc2
      LET ls_cell_r = ls_cell.subString(ls_cell.getIndexOf("R",1)+1,ls_cell.getIndexOf("C",1)-1)
      LET li_data_end = ls_cell_r
 
      #將抓到的資料放到lr_data_tmp
      LET li_cnt = 1
      FOR li_j = li_data_stat TO li_data_end
          LET ls_value = ""
                LET ls_cell_r = li_j
                LET ls_cell = "R",ls_cell_r.trim(),ls_cell_c.trim()
          CALL ui.Interface.frontCall("WINDDE","DDEPeek",["EXCEL",ls_file_name,ls_cell],[li_result,ls_value])
          CALL p621_checkError(li_result,"Peek Cells")
          LET ls_value = ls_value.trim()
          IF ls_value.getIndexOf("\"",1) THEN
             LET ls_value = cl_replace_str(ls_value,'"','@#$%')
             LET ls_value = cl_replace_str(ls_value,'@#$%','\"')
          END IF
          IF ls_value.getIndexOf("'",1) THEN
             LET ls_value = cl_replace_str(ls_value,"'","@#$%")
             LET ls_value = cl_replace_str(ls_value,"@#$%","''")
          END IF
          CASE li_col_idx
             WHEN 1
                LET lr_data_tmp[li_cnt].data01 = ls_value
             WHEN 2
                LET lr_data_tmp[li_cnt].data02 = ls_value
             WHEN 3
                LET lr_data_tmp[li_cnt].data03 = ls_value
             WHEN 4
                LET lr_data_tmp[li_cnt].data04 = ls_value
             WHEN 5
                LET lr_data_tmp[li_cnt].data05 = ls_value
             WHEN 6
                LET lr_data_tmp[li_cnt].data06 = ls_value
             WHEN 7
                LET lr_data_tmp[li_cnt].data07 = ls_value
          END CASE
          LET li_cnt = li_cnt + 1
      END FOR
      LET li_col_idx = li_col_idx + 1
   END FOR
   CALL g_xsi.deleteElement(li_cnt)

   DROP TABLE p621_tmp
   CREATE TEMP TABLE p621_tmp(
      data01 LIKE xsh_file.xsh99,
      data02 LIKE xsh_file.xsh02,
      data03 LIKE xsh_file.xsh03,
      data04 LIKE xsi_file.xsi03,
      data05 LIKE xsi_file.xsi04,
      data06 LIKE xsi_file.xsi05,
      data07 LIKE xsi_file.xsi06);

   BEGIN WORK

  ##將第一階段的東西倒到lr_data
  #FOR li_i = 1 TO lr_data_tmp.getLength()
  #    LET lr_data[li_i].* = lr_data_tmp[li_i].*
  #END FOR
  ##帶入找到的lr_data資料，執行INSERT指令
  #LET l_xsh99 = ''
  #FOR li_i = 1 TO lr_data.getLength()

   FOR li_i = 1 TO lr_data_tmp.getLength()
       INSERT INTO p621_tmp VALUES(lr_data_tmp[li_i].*)
   END FOR
   LET l_xsh99 = ''
   LET li_i = 1
   LET li_k = 1
   LET li_cnt = 1
   DECLARE p621_c CURSOR FOR SELECT * FROM p621_tmp ORDER BY data01
   FOREACH p621_c INTO lr_data[li_i].*
       IF cl_null(l_xsh99) OR lr_data[li_i].data01 <> l_xsh99 THEN
          LET g_sql = "SELECT azp02,azw07 FROM azw_file,azp_file",
                      " WHERE azw01 = '",lr_data[li_i].data01,"'",
                      "   AND azp01 = azw01",
                      "   AND azw01 IN ",g_auth
          PREPARE p621_azw FROM g_sql
          EXECUTE p621_azw INTO l_azp02,l_xsh04
          IF STATUS = 100 OR SQLCA.sqlcode THEN
             LET lr_err[li_k].line = li_i
             LET lr_err[li_k].key1 = lr_data[li_i].data01
             LET lr_err[li_k].err  = 'axm-335'
             LET lr_err[li_k].cmd  = g_sql
             LET li_k = li_k + 1
             LET li_i = li_i + 1
             CONTINUE FOREACH
          END IF
          LET l_xsh99 = lr_data[li_i].data01
          LET g_plant_new = lr_data[li_i].data01
          CALL s_gettrandbs()
          LET g_dbs=g_dbs_tra
          LET g_dbs = s_dbstring(g_dbs)

          LET ls_chr="HB"
          LET ls_date = TODAY USING "yyyymmdd"
        # LET g_sql = "SELECT MAX(xsh01) FROM ",g_dbs CLIPPED,"xsh_file",                   #FUN-A50102 mark
          LET g_sql = "SELECT MAX(xsh01) FROM ",cl_get_target_table(g_plant_new,'xsh_file'),#FUN-A50102
                      " WHERE xsh01 LIKE '",ls_chr,"",ls_date,"%'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
          PREPARE maxno_pre FROM g_sql
          EXECUTE maxno_pre INTO l_xsh01
          IF cl_null(l_xsh01) THEN
             LET l_xsh01 = ls_chr,ls_date,"0001"
          ELSE
             LET ls_max_no = l_xsh01[11,14]
             LET ls_max_no = ls_max_no + 1
             LET l_xsh01 = ls_chr,ls_date,ls_max_no USING "&&&&"
          END IF

          LET l_xsh05 = '0'
          LET l_date1 = lr_data[li_i].data02
          LET l_date2 = lr_data[li_i].data03
        # LET ls_exe_sql = "INSERT INTO ",g_dbs CLIPPED,"xsh_file(xsh99,xsh01,xsh02,xsh03,xsh04,xsh05) VALUES('",      #FUN-A50102 mark
          LET ls_exe_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'xsh_file'),"(xsh99,xsh01,xsh02,xsh03,xsh04,xsh05) VALUES('",      #FUN-A50102
       lr_data[li_i].data01,"','",l_xsh01,"','",l_date1,"','",
       l_date2,"','",l_xsh04,"','",l_xsh05,"')"
          CALL cl_replace_sqldb(ls_exe_sql) RETURNING ls_exe_sql                #FUN-A50102 
          CALL cl_parse_qry_sql(ls_exe_sql,g_plant_new) RETURNING ls_exe_sql    #FUN-A50102
          PREPARE execute2_sql FROM ls_exe_sql
          EXECUTE execute2_sql
          IF SQLCA.sqlcode THEN
             LET lr_err[li_k].line = li_i
             LET lr_err[li_k].key1 = l_xsh01
             LET lr_err[li_k].err  = SQLCA.sqlcode
             LET lr_err[li_k].cmd  = ls_exe_sql
             LET li_k = li_k + 1
             LET li_i = li_i + 1
             CONTINUE FOREACH
          ELSE
             LET g_xsh[li_cnt].sel = 'N'
             LET g_xsh[li_cnt].xsh99 = lr_data[li_cnt].data01
             LET g_xsh[li_cnt].azp02 = l_azp02
             LET g_xsh[li_cnt].xsh01 = l_xsh01
             LET g_xsh[li_cnt].xsh02 = l_date1
             LET g_xsh[li_cnt].xsh03 = l_date2
             LET g_xsh[li_cnt].xsh05 = l_xsh05
             LET li_cnt = li_cnt + 1
          END IF
       END IF
     # LET g_sql = "SELECT ima25 FROM ",g_dbs CLIPPED,"ima_file ",                         #FUN-A50102
       LET g_sql = "SELECT ima25 FROM ",cl_get_target_table(g_plant_new,'ima_file'),#FUN-A50102 
                   " WHERE ima01 = '",lr_data[li_i].data04,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                   #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql       #FUN-A50102
       PREPARE p621_sel_ima01 FROM g_sql
       EXECUTE p621_sel_ima01 INTO l_ima25
       IF SQLCA.sqlcode THEN
          LET lr_err[li_k].line = li_i
          LET lr_err[li_k].key1 = lr_data[li_i].data04
          LET lr_err[li_k].err  = 'axm-337'
          LET lr_err[li_k].cmd  = g_sql
          LET li_k = li_k + 1
          LET li_i = li_i + 1
          CONTINUE FOREACH
       END IF

       IF lr_data[li_i].data06!=l_ima25 THEN
          CALL s_umfchk(lr_data[li_i].data04,lr_data[li_i].data06,l_ima25)
                RETURNING g_cnt,l_imafac
         ##----單位換算率抓不到--------###
          IF g_cnt = 1 THEN
             LET lr_err[li_k].line = li_i
             LET lr_err[li_k].key1 = lr_data[li_i].data06
             LET lr_err[li_k].err  = 'aic-052'
             LET lr_err[li_k].cmd  = 'imafac'
             LET li_k = li_k + 1
             LET li_i = li_i + 1
             CONTINUE FOREACH
          END IF
       END IF

       IF cl_null(lr_data[li_i].data05) OR lr_data[li_i].data05 <= 0 THEN
          LET lr_err[li_k].line = li_i
          LET lr_err[li_k].key1 = lr_data[li_i].data05
          LET lr_err[li_k].err  = 'axm-337'
          LET lr_err[li_k].cmd  = g_sql
          LET li_k = li_k + 1
          LET li_i = li_i + 1
          CONTINUE FOREACH
       END IF
       IF cl_null(lr_data[li_i].data07) OR lr_data[li_i].data07 <= 0 THEN
          LET lr_err[li_k].line = li_i
          LET lr_err[li_k].key1 = lr_data[li_i].data07
          LET lr_err[li_k].err  = 'axm-337'
          LET lr_err[li_k].cmd  = g_sql
          LET li_k = li_k + 1
          LET li_i = li_i + 1
          CONTINUE FOREACH
       END IF
     # LET g_sql = "SELECT MAX(xsi02)+1 FROM ",g_dbs CLIPPED,"xsi_file",                    #FUN-A50102 mark
       LET g_sql = "SELECT MAX(xsi02)+1 FROM ",cl_get_target_table(g_plant_new,'xsi_file'), #FUN-A50102 
                   " WHERE xsi01 = '",l_xsh01,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102 
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
       PREPARE p621_sel_xsi02 FROM g_sql
       EXECUTE p621_sel_xsi02 INTO l_xsi02
       IF cl_null(l_xsi02) OR l_xsi02 = 0 THEN
          LET l_xsi02 = 1
       END IF
     # LET ls_exe_sql = "INSERT INTO ",g_dbs CLIPPED,"xsi_file(xsi01,xsi02,xsi03,xsi04,xsi05,xsi06) VALUES('",       #FUN-A50102 mark
       LET ls_exe_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'xsi_file'),"(xsi01,xsi02,xsi03,xsi04,xsi05,xsi06) VALUES('",   #FUN-A50102
                      l_xsh01,"','",l_xsi02,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",
                      lr_data[li_i].data06,"','",lr_data[li_i].data07,"')"
       CALL cl_replace_sqldb(ls_exe_sql)RETURNING ls_exe_sql                    #FUN-A50102
       CALL cl_parse_qry_sql(ls_exe_sql,g_plant_new) RETURNING ls_exe_sql       #FUN-A50102
       PREPARE execute3_sql FROM ls_exe_sql
       EXECUTE execute3_sql
       IF SQLCA.sqlcode THEN
          LET lr_err[li_k].line = li_i
          LET lr_err[li_k].key1 = l_xsh01
          LET lr_err[li_k].err  = SQLCA.sqlcode
          LET lr_err[li_k].cmd  = ls_exe_sql
          LET li_k = li_k + 1
       END IF
       LET li_i = li_i +1
   END FOREACH
 
   IF lr_err.getLength() > 0 THEN
      CALL cl_show_array(base.TypeInfo.create(lr_err),cl_getmsg("lib-314",g_lang),"Line|Key1|Error")
      CALL cl_end2(2) RETURNING l_flag
      ROLLBACK WORK
      CALL g_xsh.clear()
   ELSE
      CALL cl_end2(1) RETURNING l_flag
   END IF
   COMMIT WORK
   LET g_rec_b = g_xsh.getLength()
 
   #關閉Excel寫入
   CALL ui.Interface.frontCall("WINDDE","DDEFinish",["EXCEL","Sheet1"],[li_result])
   CALL p621_checkError(li_result,"Finish")
 
   CLOSE WINDOW axmp6211_w
END FUNCTION
 
FUNCTION p621_checkError(p_result,p_msg)
   DEFINE   p_result   LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   p_msg      STRING
   DEFINE   ls_msg     STRING
   DEFINE   li_result  LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
 
   IF p_result THEN
      RETURN
   END IF
   DISPLAY p_msg," DDE ERROR:"
   CALL ui.Interface.frontCall("WINDDE","DDEError",[],[ls_msg])
   DISPLAY ls_msg
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result])
   IF NOT li_result THEN
      DISPLAY "Exit with DDE Error."
   END IF
#  EXIT PROGRAM
END FUNCTION
#TQC-A50134 10/06/29 By chenls 非T/S類table中的xxxplant替換成xxxstore
