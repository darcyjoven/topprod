# Prog. Version..: '5.25.04-12.01.12(00001)'
# Pattern name...: aimp110.4gl
# Descriptions...: 料件圖片整批上傳作業 
# Date & Author..: 11/10/25 FUN-BA0092 By lilingyu

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_gca        RECORD LIKE gca_file.*,     #FUN-BA0092
       g_gcb        RECORD LIKE gcb_file.*,
       g_wc         STRING,
       g_wc2        STRING,
       g_path       STRING,              #图片的路径 
       g_key        RECORD
             gca01 LIKE gca_file.gca01,
             gca02 LIKE gca_file.gca02,
             gca03 LIKE gca_file.gca03,
             gca04 LIKE gca_file.gca04,
             gca05 LIKE gca_file.gca05
                    END RECORD
DEFINE g_field      STRING,               #图片的栏位
       g_mode       STRING                #判断上传的图片是那种模式
DEFINE g_flag       LIKE type_file.num10     #判断资料写入的成功否 
DEFINE g_sql        STRING
DEFINE g_ima01      LIKE ima_file.ima01
DEFINE   lc_channel   base.Channel
DEFINE   ls_cmd       STRING 
DEFINE   ls_result    STRING
DEFINE g_pictype      STRING

MAIN
   OPTIONS            
       INPUT NO WRAP 
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   CALL p110_tm()      #根据画面上的条件更新图片 

   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN

#根据画面上的条件更新图片
FUNCTION p110_tm()

   OPEN WINDOW aimip110_w AT 0,0 WITH FORM "aim/42f/aimp110"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()   
      
   WHILE TRUE
         CONSTRUCT BY NAME g_wc2 ON ima01 
         
         BEFORE CONSTRUCT 
           CALL cl_qbe_init()
         
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(ima01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_ima110"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ima01
                     NEXT FIELD ima01 
               END CASE 

         ON ACTION controlg
            CALL cl_cmdask()
         ON ACTION accept
            EXIT CONSTRUCT 
         ON ACTION cancel
            LET INT_FLAG = 1
            EXIT CONSTRUCT 
         ON ACTION close
            LET INT_FLAG = 1
            EXIT CONSTRUCT 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT   
      END CONSTRUCT 
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW aimp110_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      
      CALL cl_wait()
      CALL aimp110()

   END WHILE
   CLOSE WINDOW aimp110_w 
END FUNCTION

FUNCTION aimp110()
DEFINE l_sql  STRING
DEFINE l_num  LIKE type_file.num5
DEFINE l_num1 LIKE type_file.num5

   LET l_num = 0
   LET l_sql = "SELECT COUNT(*) FROM ima_file WHERE ",g_wc2 CLIPPED
   PREPARE aimp110_count  FROM l_sql
   EXECUTE aimp110_count INTO l_num
   IF cl_null(l_num) THEN 
      LET l_num = 0 
   END IF  
   
   LET g_sql = "SELECT ima01 FROM ima_file WHERE ",g_wc2 CLIPPED
   PREPARE p110_prepare FROM g_sql
   DECLARE p110_curs SCROLL CURSOR WITH HOLD  FOR p110_prepare
   CALL cl_progress_bar(l_num)

   FOREACH p110_curs INTO g_ima01 

      LET l_num1 = 0
      LET g_pictype = ''
      LET ls_result = '' 
      LET ls_cmd = "find /u53/top/doc/pic/",g_ima01,".*"
      LET lc_channel = base.Channel.create()
      CALL lc_channel.openPipe(ls_cmd,"r")
      CALL lc_channel.setDelimiter("")

      WHILE lc_channel.read(ls_result)
         LET l_num1 = ls_result.getlength()
         IF cl_null(l_num1) THEN LET l_num1 = 0 END IF
         IF l_num1 = 0 THEN
            EXIT WHILE
         END IF
         LET g_pictype = ls_result.subString(ls_result.getIndexOf(".",1) + 1,l_num1)
         IF NOT cl_null(g_pictype) THEN
           EXIT WHILE
         END IF   
      END WHILE

      CALL lc_channel.close()

      IF cl_null(g_pictype) THEN
         CALL cl_progressing("view: "|| g_ima01)
         CONTINUE FOREACH
      END IF 

      LET g_doc.column1 = "ima01"
      LET g_doc.value1= g_ima01 

      CALL p110_fld("ima04")

      CALL cl_progressing("view: "|| g_ima01)
   END FOREACH
END FUNCTION

#将图片资料写入表gca_file,gcb_file
FUNCTION p110_fld(p_field)
DEFINE p_field   STRING

   CALL p110_fieldprepare(p_field)      #初始化一些资料 
   LET g_flag = TRUE

   IF NOT p110_getfldnum() THEN          #查看当前图片是否为第一次写入
      CALL cl_err(NULL, "lib-211", 0)
      RETURN
   END IF
 
   IF NOT p110_writerecord() THEN        #写入资料gca_file,gcb_file
      CALL cl_err(NULL, "lib-209", 0)
      RETURN
   END IF
END FUNCTION

#初始化一些资料 
FUNCTION p110_fieldprepare(p_field)
DEFINE p_field   STRING

#  LET g_path = FGL_GETENV("TEMPDIR")
   LET g_path = '/u53/top/doc/pic'
   
   LET g_field = p_field CLIPPED
   LET g_key.gca01 = g_doc.column1 CLIPPED || "=" || g_doc.value1 CLIPPED
   LET g_key.gca02 = g_doc.column2 CLIPPED || "=" || g_doc.value2 CLIPPED
   LET g_key.gca03 = g_doc.column3 CLIPPED || "=" || g_doc.value3 CLIPPED
   LET g_key.gca04 = g_doc.column4 CLIPPED || "=" || g_doc.value4 CLIPPED
   LET g_key.gca05 = g_doc.column5 CLIPPED || "=" || g_doc.value5 CLIPPED
END FUNCTION
 
#获取是否为第一次写入图片 
FUNCTION p110_getfldnum()
DEFINE l_sql   STRING

   LET g_wc = "gca01 = '", g_key.gca01 CLIPPED, "'"
   IF NOT cl_null(g_key.gca02) THEN
      LET g_wc = g_wc, " AND gca02 = '", g_key.gca02 CLIPPED, "'"
   ELSE
      LET g_wc = g_wc, " AND gca02 = ' '"
   END IF
   IF NOT cl_null(g_key.gca03) THEN
      LET g_wc = g_wc, " AND gca03 = '", g_key.gca03 CLIPPED, "'"
   ELSE
      LET g_wc = g_wc, " AND gca03 = ' '"
   END IF
   IF NOT cl_null(g_key.gca04) THEN
      LET g_wc = g_wc, " AND gca04 = '", g_key.gca04 CLIPPED, "'"
   ELSE
      LET g_wc = g_wc, " AND gca04 = ' '"
   END IF
   IF NOT cl_null(g_key.gca05) THEN
      LET g_wc = g_wc, " AND gca05 = '", g_key.gca05 CLIPPED, "'"
   ELSE
      LET g_wc = g_wc, " AND gca05 = ' '"
   END IF
   #查询该料件是否为第一次写入资料
   LET l_sql = "SELECT gca_file.* FROM gca_file WHERE ", g_wc, 
                " AND gca08 = 'FLD'",
                " AND gca09 = '", g_field, "'",
                " AND gca11 = 'Y'"
   PREPARE fld_doc_pre FROM l_sql
   EXECUTE fld_doc_pre INTO g_gca.* 
   IF ( SQLCA.SQLCODE ) AND ( NOT g_flag ) THEN
      RETURN FALSE
   END IF
   CASE SQLCA.SQLCODE
      WHEN 0
         LET g_mode = "modify"
      WHEN NOTFOUND
         LET g_mode = "insert"
         INITIALIZE g_gca.* TO NULL
         INITIALIZE g_gcb.* TO NULL
      OTHERWISE
         CALL cl_err3("sel","gca_file","","",SQLCA.sqlcode,"","",0) 
         RETURN FALSE
   END CASE
 
   IF g_mode = "modify" THEN
     LOCATE g_gcb.gcb09 IN MEMORY
     SELECT gcb_file.* INTO g_gcb.* FROM gcb_file 
      WHERE gcb01 = g_gca.gca07 
        AND gcb02 = g_gca.gca08 
        AND gcb03 = g_gca.gca09 
        AND gcb04 = g_gca.gca10
    
     FREE g_gcb.gcb09
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("sel","gcb_file","","",SQLCA.sqlcode,"","",0)  
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
#写入资料gca_file,gcb_file
FUNCTION p110_writerecord()
DEFINE li_status     LIKE type_file.num10,
       l_min        LIKE type_file.num10 
DEFINE l_sql        STRING,
       l_docNum     STRING,
       l_time       STRING,
       l_fname      STRING

   CASE g_mode
      WHEN "insert"
         PREPARE min_pre FROM "SELECT MIN(gca06) - 1 FROM gca_file WHERE " || g_wc
         EXECUTE min_pre INTO l_min
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("sel","gca_file","","",SQLCA.sqlcode,"","select min(gca06):",0)
            RETURN FALSE
         END IF
         IF cl_null(l_min) OR l_min >=0 THEN
            LET l_min = -1
         END IF
         LET l_docNum = g_ima01 
         IF cl_null(g_key.gca02) THEN
            LET g_key.gca02 = ' '
         END IF
         IF cl_null(g_key.gca03) THEN
            LET g_key.gca03 = ' '
         END IF
         IF cl_null(g_key.gca04) THEN
            LET g_key.gca04 = ' '
         END IF
         IF cl_null(g_key.gca05) THEN
            LET g_key.gca05 = ' '
         END IF
         LET g_gca.gca01 = g_key.gca01
         LET g_gca.gca02 = g_key.gca02
         LET g_gca.gca03 = g_key.gca03
         LET g_gca.gca04 = g_key.gca04
         LET g_gca.gca05 = g_key.gca05
         LET g_gca.gca06 = l_min
         LET g_gca.gca07 = g_gcb.gcb01 := l_docNum
         LET g_gca.gca08 = g_gcb.gcb02 := "FLD" 
         LET g_gca.gca09 = g_gcb.gcb03 := g_field 
         LET g_gca.gca10 = g_gcb.gcb04 := "001"
         LET g_gca.gca11 = 'Y'
         LET g_gca.gca12 = g_gcb.gcb13 := g_user CLIPPED
         LET g_gca.gca13 = g_gcb.gcb14 := g_grup CLIPPED
         LET g_gca.gca14 = g_gcb.gcb15 := g_today CLIPPED
         LET g_gcb.gcb11 = "O"
         LET g_gcb.gcb12 = "U"
      WHEN "modify"
         LET l_docNum =  g_ima01 
         LET g_gcb.gcb07 = NULL
         LET g_gcb.gcb08 = NULL
         LET g_gcb.gcb09 = NULL
         LET g_gcb.gcb10 = NULL
         LET g_gca.gca15 = g_gcb.gcb16 := g_user CLIPPED
         LET g_gca.gca16 = g_gcb.gcb17 := g_grup CLIPPED
         LET g_gca.gca17 = g_gcb.gcb18 := g_today CLIPPED
   END CASE
   LET l_fname = g_path, "/", l_docNum,".",g_pictype
   LET g_gcb.gcb07 = l_docNum,".",g_pictype 
   LET g_gcb.gcb08 = "D"
   LOCATE g_gcb.gcb09 IN FILE l_fname
   LET li_status = TRUE

   BEGIN WORK

   CASE g_mode
      WHEN "insert"
         INSERT INTO gca_file VALUES (g_gca.*)
      WHEN "modify"
         LET l_sql = "UPDATE gca_file",
                     "   SET gca15 = '", g_gca.gca15 CLIPPED, "',",
                     "       gca16 = '", g_gca.gca16 CLIPPED, "',",
                     "       gca17 = '", g_gca.gca17 CLIPPED, "'",
                     " WHERE ", g_wc, " AND ",
                     "       gca06 = ", g_gca.gca06
         EXECUTE IMMEDIATE l_sql
   END CASE
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("upd","gca_file",g_gca.gca15,g_gca.gca16,SQLCA.sqlcode,"","",0)  
      LET li_status = FALSE
   ELSE
      CASE g_mode
         WHEN "insert"
            INSERT INTO gcb_file VALUES (g_gcb.*)
         WHEN "modify"
            UPDATE gcb_file 
               SET gcb07 = g_gcb.gcb07,
                   gcb08 = g_gcb.gcb08,
                   gcb09 = g_gcb.gcb09,
                   gcb10 = g_gcb.gcb10,
                   gcb16 = g_gcb.gcb16,
                   gcb17 = g_gcb.gcb17,
                   gcb18 = g_gcb.gcb18
             WHERE gcb01 = g_gcb.gcb01 AND
                   gcb02 = g_gcb.gcb02 AND
                   gcb03 = g_gcb.gcb03 AND
                   gcb04 = g_gcb.gcb04
      END CASE
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("upd","gcb_file",g_gcb.gcb01,g_gcb.gcb02,SQLCA.sqlcode,"","",0) 
         FREE g_gcb.gcb09
         RUN "rm -f " || l_fname
         LET li_status = FALSE
      END IF
   END IF
   IF NOT li_status THEN
      CALL cl_err('','aim-944',1)
      ROLLBACK WORK
   ELSE
   	  CALL cl_err('','aim-945',1)
      COMMIT WORK
   END IF
   RETURN li_status 
END FUNCTION
 

